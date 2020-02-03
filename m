Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9449F150FD1
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 19:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729581AbgBCSmD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 13:42:03 -0500
Received: from mga02.intel.com ([134.134.136.20]:49288 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729514AbgBCSmD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Feb 2020 13:42:03 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Feb 2020 10:42:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,398,1574150400"; 
   d="scan'208";a="310804551"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 03 Feb 2020 10:42:01 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 1/2] KVM: MIPS: Fix a build error due to referencing not-yet-defined function
Date:   Mon,  3 Feb 2020 10:41:59 -0800
Message-Id: <20200203184200.23585-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200203184200.23585-1-sean.j.christopherson@intel.com>
References: <20200203184200.23585-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hoist kvm_mips_comparecount_wakeup() above its only user,
kvm_arch_vcpu_create() to fix a compilation error due to referencing an
undefined function.

Fixes: d11dfed5d700 ("KVM: MIPS: Move all vcpu init code into kvm_arch_vcpu_create()")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/mips/kvm/mips.c | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 2606f3f02b54..92509041b954 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -280,6 +280,27 @@ static inline void dump_handler(const char *symbol, void *start, void *end)
 	pr_debug("\tEND(%s)\n", symbol);
 }
 
+static void kvm_mips_comparecount_func(unsigned long data)
+{
+	struct kvm_vcpu *vcpu = (struct kvm_vcpu *)data;
+
+	kvm_mips_callbacks->queue_timer_int(vcpu);
+
+	vcpu->arch.wait = 0;
+	if (swq_has_sleeper(&vcpu->wq))
+		swake_up_one(&vcpu->wq);
+}
+
+/* low level hrtimer wake routine */
+static enum hrtimer_restart kvm_mips_comparecount_wakeup(struct hrtimer *timer)
+{
+	struct kvm_vcpu *vcpu;
+
+	vcpu = container_of(timer, struct kvm_vcpu, arch.comparecount_timer);
+	kvm_mips_comparecount_func((unsigned long) vcpu);
+	return kvm_mips_count_timeout(vcpu);
+}
+
 int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 {
 	return 0;
@@ -1209,27 +1230,6 @@ int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	return 0;
 }
 
-static void kvm_mips_comparecount_func(unsigned long data)
-{
-	struct kvm_vcpu *vcpu = (struct kvm_vcpu *)data;
-
-	kvm_mips_callbacks->queue_timer_int(vcpu);
-
-	vcpu->arch.wait = 0;
-	if (swq_has_sleeper(&vcpu->wq))
-		swake_up_one(&vcpu->wq);
-}
-
-/* low level hrtimer wake routine */
-static enum hrtimer_restart kvm_mips_comparecount_wakeup(struct hrtimer *timer)
-{
-	struct kvm_vcpu *vcpu;
-
-	vcpu = container_of(timer, struct kvm_vcpu, arch.comparecount_timer);
-	kvm_mips_comparecount_func((unsigned long) vcpu);
-	return kvm_mips_count_timeout(vcpu);
-}
-
 int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
 				  struct kvm_translation *tr)
 {
-- 
2.24.1

