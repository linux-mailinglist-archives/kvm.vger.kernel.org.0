Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53CEA181BE
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 23:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbfEHVrF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 17:47:05 -0400
Received: from mga03.intel.com ([134.134.136.65]:22962 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726875AbfEHVrE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 17:47:04 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 14:47:04 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.36])
  by orsmga002.jf.intel.com with ESMTP; 08 May 2019 14:47:03 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <kernellwp@gmail.com>
Subject: [PATCH] KVM: lapic: Reuse auto-adjusted timer advance of first stable vCPU
Date:   Wed,  8 May 2019 14:47:02 -0700
Message-Id: <20190508214702.25317-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wanpeng pointed out that auto-tuning the advancement time for every vCPU
can lead to inaccurate wait times, e.g. if the advancement is calculated
while an overcommitted host is under heavy load, then KVM will waste a
lot of time busy waiting if the load decreases, e.g. when neighbour VMs
are idle.

Sidestep this issue and reduce time spent adjusting the advancement by
saving the first stable advancement value and reusing that value for all
*new* vCPUs.  This provides a safe way to auto-adjust the advancement,
minimizes the potential for a poor calculation due to system load, and
preserves the ability for userspace to change the advancement on the fly
(the module parameter is writable when KVM is loaded), as the value set
by userspace takes priority.

Regarding changing the advancement on the fly, doing so is likely less
useful with auto-adjusting, especially now that recognizing a change
requires restarting the VM.  Allowing the two concepts to coexist is
theoretically possible, but would be ugly and slow.  Auto-tuning needs
to track advancement time on a per-vCPU basis (because adjusments are
done relative to the last advancement), so supporting both approaches
would require additional code and conditionals, i.e. overhead, but would
only provide marginal value.  That being said, keep the ability to
change the module param without a reload as it's useful for debug and
testing.

Note, the comment from commit 39497d7660d9 ("KVM: lapic: Track lapic
timer advance per vCPU") about TSC scaling:

  And because virtual_tsc_khz and tsc_scaling_ratio are per-vCPU, the
  correct calibration for a given vCPU may not apply to all vCPUs.

was effectively resolved by commit b6aa57c69cb2 ("KVM: lapic: Convert
guest TSC to host time domain if necessary").  The timer advancement is
calculated and stored in nanoseconds, and operates in the host time
domain, i.e. calculates *host* overhead.  In short, reusing an
advancement time for vCPUs with different TSC scaling is ok.

Fixes: 39497d7660d9 ("KVM: lapic: Track lapic timer advance per vCPU")
Cc: Wanpeng Li <kernellwp@gmail.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/lapic.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index bd13fdddbdc4..4f234df11078 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -70,6 +70,8 @@
 #define APIC_BROADCAST			0xFF
 #define X2APIC_BROADCAST		0xFFFFFFFFul
 
+static u32 adjusted_timer_advance_ns = -1;
+
 #define LAPIC_TIMER_ADVANCE_ADJUST_DONE 100
 /* step-by-step approximation to mitigate fluctuation */
 #define LAPIC_TIMER_ADVANCE_ADJUST_STEP 8
@@ -1542,6 +1544,15 @@ void wait_lapic_expire(struct kvm_vcpu *vcpu)
 			apic->lapic_timer.timer_advance_adjust_done = true;
 		}
 		apic->lapic_timer.timer_advance_ns = timer_advance_ns;
+
+		/*
+		 * The first vCPU to get a stable advancement time "wins" and
+		 * sets the advancement time that is used for *new* vCPUS that
+		 * are created with auto-adjusting enabled.
+		 */
+		if (apic->lapic_timer.timer_advance_adjust_done)
+			(void)cmpxchg(&adjusted_timer_advance_ns, -1,
+				      timer_advance_ns);
 	}
 }
 
@@ -2302,12 +2313,15 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
 	hrtimer_init(&apic->lapic_timer.timer, CLOCK_MONOTONIC,
 		     HRTIMER_MODE_ABS_PINNED);
 	apic->lapic_timer.timer.function = apic_timer_fn;
-	if (timer_advance_ns == -1) {
+	if (timer_advance_ns != -1) {
+		apic->lapic_timer.timer_advance_ns = timer_advance_ns;
+		apic->lapic_timer.timer_advance_adjust_done = true;
+	} else if (adjusted_timer_advance_ns != -1) {
+		apic->lapic_timer.timer_advance_ns = adjusted_timer_advance_ns;
+		apic->lapic_timer.timer_advance_adjust_done = true;
+	} else {
 		apic->lapic_timer.timer_advance_ns = 1000;
 		apic->lapic_timer.timer_advance_adjust_done = false;
-	} else {
-		apic->lapic_timer.timer_advance_ns = timer_advance_ns;
-		apic->lapic_timer.timer_advance_adjust_done = true;
 	}
 
 
-- 
2.21.0

