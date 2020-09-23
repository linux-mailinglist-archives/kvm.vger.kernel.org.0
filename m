Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5B62275F56
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 20:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgIWSEe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 14:04:34 -0400
Received: from mga05.intel.com ([192.55.52.43]:39920 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726831AbgIWSEe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 14:04:34 -0400
IronPort-SDR: asIjJpE4sGsm+5HJWUXWhDGaJV8+LwGrlOsim9QRlFIovvMoyF6ARo9FECbc/lH4CJGfxpBF35
 2w5h2BSMIXtQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="245808969"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="245808969"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 11:04:12 -0700
IronPort-SDR: RapogMugkRRiQeQEnKD6sqXTNKhPKL3ZcjCVBa6mbA/af8jppZ5ewBUEHctP2h+UYn6xo9DPna
 HkSM5MD92p/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="322670281"
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
Subject: [PATCH v2 07/15] KVM: VMX: Rename vcpu_vmx's "guest_msrs_ready" to "guest_uret_msrs_loaded"
Date:   Wed, 23 Sep 2020 11:04:01 -0700
Message-Id: <20200923180409.32255-8-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923180409.32255-1-sean.j.christopherson@intel.com>
References: <20200923180409.32255-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add "uret" to "guest_msrs_ready" to explicitly associate it with the
"guest_uret_msrs" array, and replace "ready" with "loaded" to more
precisely reflect what it tracks, e.g. "ready" could be interpreted as
meaning ready for processing (setup_msrs() has run), which is wrong.
"loaded" also aligns with the similar "guest_state_loaded" field.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 8 ++++----
 arch/x86/kvm/vmx/vmx.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index eefd1c991615..4da4fc65d459 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1140,8 +1140,8 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	 * when guest state is loaded. This happens when guest transitions
 	 * to/from long-mode by setting MSR_EFER.LMA.
 	 */
-	if (!vmx->guest_msrs_ready) {
-		vmx->guest_msrs_ready = true;
+	if (!vmx->guest_uret_msrs_loaded) {
+		vmx->guest_uret_msrs_loaded = true;
 		for (i = 0; i < vmx->nr_active_uret_msrs; ++i)
 			kvm_set_user_return_msr(vmx->guest_uret_msrs[i].index,
 						vmx->guest_uret_msrs[i].data,
@@ -1229,7 +1229,7 @@ static void vmx_prepare_switch_to_host(struct vcpu_vmx *vmx)
 #endif
 	load_fixmap_gdt(raw_smp_processor_id());
 	vmx->guest_state_loaded = false;
-	vmx->guest_msrs_ready = false;
+	vmx->guest_uret_msrs_loaded = false;
 }
 
 #ifdef CONFIG_X86_64
@@ -1730,7 +1730,7 @@ static void setup_msrs(struct vcpu_vmx *vmx)
 		move_msr_up(vmx, index, nr_active_uret_msrs++);
 
 	vmx->nr_active_uret_msrs = nr_active_uret_msrs;
-	vmx->guest_msrs_ready = false;
+	vmx->guest_uret_msrs_loaded = false;
 
 	if (cpu_has_vmx_msr_bitmap())
 		vmx_update_msr_bitmap(&vmx->vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 202487d8dc28..f90de1fd6319 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -221,7 +221,7 @@ struct vcpu_vmx {
 	struct vmx_uret_msr   guest_uret_msrs[MAX_NR_USER_RETURN_MSRS];
 	int                   nr_uret_msrs;
 	int                   nr_active_uret_msrs;
-	bool                  guest_msrs_ready;
+	bool                  guest_uret_msrs_loaded;
 #ifdef CONFIG_X86_64
 	u64		      msr_host_kernel_gs_base;
 	u64		      msr_guest_kernel_gs_base;
-- 
2.28.0

