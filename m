Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24B8C275F5A
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 20:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgIWSEo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 14:04:44 -0400
Received: from mga05.intel.com ([192.55.52.43]:39920 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726785AbgIWSEY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 14:04:24 -0400
IronPort-SDR: QA7I5rYZBqrAJXHLZD7dHt/vM4Fzee02R4NarvEUN3zovh0X/iiPsbo/N1FoKb26hBDvNyvpZ6
 aNrwTINZzQHg==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="245808974"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="245808974"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 11:04:13 -0700
IronPort-SDR: yoN1458qw0Kaql42Ri4RIYaS19zPA4c9xxONmziFmsF9lHyYS4iJytIxd859/WRGx0DbMcrFjo
 RZPxmHsVoibw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="322670291"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga002.jf.intel.com with ESMTP; 23 Sep 2020 11:04:11 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 10/15] KVM: VMX: Move uret MSR lookup into update_transition_efer()
Date:   Wed, 23 Sep 2020 11:04:04 -0700
Message-Id: <20200923180409.32255-11-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923180409.32255-1-sean.j.christopherson@intel.com>
References: <20200923180409.32255-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move checking for the existence of MSR_EFER in the uret MSR array into
update_transition_efer() so that the lookup and manipulation of the
array in setup_msrs() occur back-to-back.  This paves the way toward
adding a helper to wrap the lookup and manipulation.

To avoid unnecessary overhead, defer the lookup until the uret array
would actually be modified in update_transition_efer().  EFER obviously
exists on CPUs that support the dedicated VMCS fields for switching
EFER, and EFER must exist for the guest and host EFER.NX value to
diverge, i.e. there is no danger of attempting to read/write EFER when
it doesn't exist.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ed9ce25d3807..f3192855f0fb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -953,10 +953,11 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
 	m->host.val[j].value = host_val;
 }
 
-static bool update_transition_efer(struct vcpu_vmx *vmx, int efer_offset)
+static bool update_transition_efer(struct vcpu_vmx *vmx)
 {
 	u64 guest_efer = vmx->vcpu.arch.efer;
 	u64 ignore_bits = 0;
+	int i;
 
 	/* Shadow paging assumes NX to be available.  */
 	if (!enable_ept)
@@ -988,17 +989,21 @@ static bool update_transition_efer(struct vcpu_vmx *vmx, int efer_offset)
 		else
 			clear_atomic_switch_msr(vmx, MSR_EFER);
 		return false;
-	} else {
-		clear_atomic_switch_msr(vmx, MSR_EFER);
-
-		guest_efer &= ~ignore_bits;
-		guest_efer |= host_efer & ignore_bits;
-
-		vmx->guest_uret_msrs[efer_offset].data = guest_efer;
-		vmx->guest_uret_msrs[efer_offset].mask = ~ignore_bits;
-
-		return true;
 	}
+
+	i = __vmx_find_uret_msr(vmx, MSR_EFER);
+	if (i < 0)
+		return false;
+
+	clear_atomic_switch_msr(vmx, MSR_EFER);
+
+	guest_efer &= ~ignore_bits;
+	guest_efer |= host_efer & ignore_bits;
+
+	vmx->guest_uret_msrs[i].data = guest_efer;
+	vmx->guest_uret_msrs[i].mask = ~ignore_bits;
+
+	return true;
 }
 
 #ifdef CONFIG_X86_32
@@ -1719,9 +1724,11 @@ static void setup_msrs(struct vcpu_vmx *vmx)
 			move_msr_up(vmx, index, nr_active_uret_msrs++);
 	}
 #endif
-	index = __vmx_find_uret_msr(vmx, MSR_EFER);
-	if (index >= 0 && update_transition_efer(vmx, index))
-		move_msr_up(vmx, index, nr_active_uret_msrs++);
+	if (update_transition_efer(vmx)) {
+		index = __vmx_find_uret_msr(vmx, MSR_EFER);
+		if (index >= 0)
+			move_msr_up(vmx, index, nr_active_uret_msrs++);
+	}
 	if (guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDTSCP)) {
 		index = __vmx_find_uret_msr(vmx, MSR_TSC_AUX);
 		if (index >= 0)
-- 
2.28.0

