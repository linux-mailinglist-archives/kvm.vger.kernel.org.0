Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 730D5372EB2
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 19:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbhEDRTH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 13:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232184AbhEDRS5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 13:18:57 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B0FC06138D
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 10:18:02 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id u3-20020a2509430000b02904e7f1a30cffso12571922ybm.8
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 10:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=BuFmFez9jUwRrnImsJ+azB1vrZijd6DUJ5M+cWbALfs=;
        b=PIfalVHC3CmdnOo5mB3aYhbwxb1wXrQpggHTflDbp6Uh83tVVd+KOzlWt1oSBY493K
         9FnzGeEcc9Y9Ro58Pc567FMkCbJYMGyMy0Z7EYWWrenzyg5qKNzMevOGakrh7kFzJEXx
         9pCf8KAH845t6dr/gtKuc7T5Ct6jH6xiu/BEhzgd2wOPw6acO9Chl0Mw+ZElTupOYZmm
         pBccjs7Knx/aXfVGK2S1pYOL+rSYV0xi1jndG2/aSrRJ6mWrkPwsGxRxL8Vi/6hJhg0R
         l7wFb1vxrSi5NtojsrOULz6I4wCiWaIAImJA+yclYjN5OFuBIo+QSVYozmmVXrB5TroK
         E+BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=BuFmFez9jUwRrnImsJ+azB1vrZijd6DUJ5M+cWbALfs=;
        b=XjsxBWFHubRx91++pMGAL7F4/FggUeJg1qOqwnZJRFKUN55mLbNGdbIjs3+nhDpB6S
         6x0NrgGL8dKC6bmNsH0RJbKJq0MYUIXvgysEvzC/18GflYzM1A1K+Y9iIQRQ3wFhZq/o
         sp8pt3fjl6m7LvSYy3UlgKmF6y1IM1scOkQeDH0sPmTQebUan77EtQ32dOgq6H5TU7rn
         WlN1apL6TeHR7lDZGGsrkT26cjtEORDvJXwYjRb4jIDED4ScQiUuvvYjXA5rYMNKx6iY
         uy8rDt2+cE6FbqjZ9JuFbE0fIoZM3s03RITrSPc/PLkLNJj5SgMR4FjOaMiznMyhhizI
         kR6A==
X-Gm-Message-State: AOAM531w4PYXOllzILWK5w0siUQ5SBKtSDwnSSna2G0ar8gWx8BVHyUE
        Ps1WkTbhSdqhFcyoa7dxF3Ut8lo0Xl0=
X-Google-Smtp-Source: ABdhPJxM3Dh5e52Zged/McORpx1LmcgL4PsGFgtMVfeMjkfKzXR2ggkHVyGPixQ/p2PxcnWIM9V1rgaNfDU=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:df57:48cb:ea33:a156])
 (user=seanjc job=sendgmr) by 2002:a5b:802:: with SMTP id x2mr35901294ybp.28.1620148681694;
 Tue, 04 May 2021 10:18:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 May 2021 10:17:27 -0700
In-Reply-To: <20210504171734.1434054-1-seanjc@google.com>
Message-Id: <20210504171734.1434054-9-seanjc@google.com>
Mime-Version: 1.0
References: <20210504171734.1434054-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
Subject: [PATCH 08/15] KVM: VMX: Configure list of user return MSRs at module init
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Configure the list of user return MSRs that are actually supported at
module init instead of reprobing the list of possible MSRs every time a
vCPU is created.  Curating the list on a per-vCPU basis is pointless; KVM
is completely hosed if the set of supported MSRs changes after module init,
or if the set of MSRs differs per physical PCU.

The per-vCPU lists also increase complexity (see __vmx_find_uret_msr()) and
creates corner cases that _should_ be impossible, but theoretically exist
in KVM, e.g. advertising RDTSCP to userspace without actually being able to
virtualize RDTSCP if probing MSR_TSC_AUX fails.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 61 ++++++++++++++++++++++++++++--------------
 arch/x86/kvm/vmx/vmx.h | 10 ++++++-
 2 files changed, 50 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 42e4bbaa299a..68454b0de2b1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -461,7 +461,7 @@ static unsigned long host_idt_base;
  * support this emulation, IA32_STAR must always be included in
  * vmx_uret_msrs_list[], even in i386 builds.
  */
-static const u32 vmx_uret_msrs_list[] = {
+static u32 vmx_uret_msrs_list[] = {
 #ifdef CONFIG_X86_64
 	MSR_SYSCALL_MASK, MSR_LSTAR, MSR_CSTAR,
 #endif
@@ -469,6 +469,12 @@ static const u32 vmx_uret_msrs_list[] = {
 	MSR_IA32_TSX_CTRL,
 };
 
+/*
+ * Number of user return MSRs that are actually supported in hardware.
+ * vmx_uret_msrs_list is modified when KVM is loaded to drop unsupported MSRs.
+ */
+static int vmx_nr_uret_msrs;
+
 #if IS_ENABLED(CONFIG_HYPERV)
 static bool __read_mostly enlightened_vmcs = true;
 module_param(enlightened_vmcs, bool, 0444);
@@ -700,9 +706,16 @@ static inline int __vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr)
 {
 	int i;
 
-	for (i = 0; i < vmx->nr_uret_msrs; ++i)
+	/*
+	 * Note, vmx->guest_uret_msrs is the same size as vmx_uret_msrs_list,
+	 * but is ordered differently.  The MSR is matched against the list of
+	 * supported uret MSRs using "slot", but the index that is returned is
+	 * the index into guest_uret_msrs.
+	 */
+	for (i = 0; i < vmx_nr_uret_msrs; ++i) {
 		if (vmx_uret_msrs_list[vmx->guest_uret_msrs[i].slot] == msr)
 			return i;
+	}
 	return -1;
 }
 
@@ -6929,18 +6942,10 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 			goto free_vpid;
 	}
 
-	BUILD_BUG_ON(ARRAY_SIZE(vmx_uret_msrs_list) != MAX_NR_USER_RETURN_MSRS);
+	for (i = 0; i < vmx_nr_uret_msrs; ++i) {
+		vmx->guest_uret_msrs[i].data = 0;
 
-	for (i = 0; i < ARRAY_SIZE(vmx_uret_msrs_list); ++i) {
-		u32 index = vmx_uret_msrs_list[i];
-		int j = vmx->nr_uret_msrs;
-
-		if (kvm_probe_user_return_msr(index))
-			continue;
-
-		vmx->guest_uret_msrs[j].slot = i;
-		vmx->guest_uret_msrs[j].data = 0;
-		switch (index) {
+		switch (vmx_uret_msrs_list[i]) {
 		case MSR_IA32_TSX_CTRL:
 			/*
 			 * TSX_CTRL_CPUID_CLEAR is handled in the CPUID
@@ -6954,15 +6959,14 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 			 * host so that TSX remains always disabled.
 			 */
 			if (boot_cpu_has(X86_FEATURE_RTM))
-				vmx->guest_uret_msrs[j].mask = ~(u64)TSX_CTRL_CPUID_CLEAR;
+				vmx->guest_uret_msrs[i].mask = ~(u64)TSX_CTRL_CPUID_CLEAR;
 			else
-				vmx->guest_uret_msrs[j].mask = 0;
+				vmx->guest_uret_msrs[i].mask = 0;
 			break;
 		default:
-			vmx->guest_uret_msrs[j].mask = -1ull;
+			vmx->guest_uret_msrs[i].mask = -1ull;
 			break;
 		}
-		++vmx->nr_uret_msrs;
 	}
 
 	err = alloc_loaded_vmcs(&vmx->vmcs01);
@@ -7821,17 +7825,34 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
 };
 
+static __init void vmx_setup_user_return_msrs(void)
+{
+	u32 msr;
+	int i;
+
+	BUILD_BUG_ON(ARRAY_SIZE(vmx_uret_msrs_list) != MAX_NR_USER_RETURN_MSRS);
+
+	for (i = 0; i < ARRAY_SIZE(vmx_uret_msrs_list); ++i) {
+		msr = vmx_uret_msrs_list[i];
+
+		if (kvm_probe_user_return_msr(msr))
+			continue;
+
+		kvm_define_user_return_msr(vmx_nr_uret_msrs, msr);
+		vmx_uret_msrs_list[vmx_nr_uret_msrs++] = msr;
+	}
+}
+
 static __init int hardware_setup(void)
 {
 	unsigned long host_bndcfgs;
 	struct desc_ptr dt;
-	int r, i, ept_lpage_level;
+	int r, ept_lpage_level;
 
 	store_idt(&dt);
 	host_idt_base = dt.address;
 
-	for (i = 0; i < ARRAY_SIZE(vmx_uret_msrs_list); ++i)
-		kvm_define_user_return_msr(i, vmx_uret_msrs_list[i]);
+	vmx_setup_user_return_msrs();
 
 	if (setup_vmcs_config(&vmcs_config, &vmx_capability) < 0)
 		return -EIO;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 008cb87ff088..d71ed8b425c5 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -245,8 +245,16 @@ struct vcpu_vmx {
 	u32                   idt_vectoring_info;
 	ulong                 rflags;
 
+	/*
+	 * User return MSRs are always emulated when enabled in the guest, but
+	 * only loaded into hardware when necessary, e.g. SYSCALL #UDs outside
+	 * of 64-bit mode or if EFER.SCE=1, thus the SYSCALL MSRs don't need to
+	 * be loaded into hardware if those conditions aren't met.
+	 * nr_active_uret_msrs tracks the number of MSRs that need to be loaded
+	 * into hardware when running the guest.  guest_uret_msrs[] is resorted
+	 * whenever the number of "active" uret MSRs is modified.
+	 */
 	struct vmx_uret_msr   guest_uret_msrs[MAX_NR_USER_RETURN_MSRS];
-	int                   nr_uret_msrs;
 	int                   nr_active_uret_msrs;
 	bool                  guest_uret_msrs_loaded;
 #ifdef CONFIG_X86_64
-- 
2.31.1.527.g47e6f16901-goog

