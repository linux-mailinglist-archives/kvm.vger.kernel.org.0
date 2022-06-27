Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD11D55E2B5
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239284AbiF0Vzv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 17:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241365AbiF0Vy6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 17:54:58 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 054EB63C5;
        Mon, 27 Jun 2022 14:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656366895; x=1687902895;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ncNIt0DVblJprtw0IA2haoHQ8Feuv1HEbxzFNl+9ODk=;
  b=llp0dLvpgBDsHskeJ42q7MtPkAbNlqeV++r5MjNvsIKV/ELcH9yOYGVU
   tL6gs6LBjVsimWzwndFr4L7UyMqhuu4Jmy3ONmPrDPaeJmrqu8FEUuPdc
   3QSmvQvtqNm6u8c1XsZ2g2vQ62tzsrk2wHg/t8q1rjf/+UjHGyxHVevYs
   B0p+agabthWEJcs7mdj6hweXl1Z17ZiosHYhyxIyTJ9TgNpHWXMa7rDuS
   qhxMxpPIVRcFNGKfUb0N5grCaZAfa82C8sCh0XgteoMlrVUdHe1WBgof3
   DGPXuNnQvzqVZ4S0rIoHADXtzyurJTOCj+ERSufZBhd3123aXFh9ZbZle
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="281609526"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="281609526"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:51 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="657863523"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:51 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v7 028/102] KVM: TDX: allocate/free TDX vcpu structure
Date:   Mon, 27 Jun 2022 14:53:20 -0700
Message-Id: <cfc7cfc72ea187b31e1c39df379a20545ca9b686.1656366338.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1656366337.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

The next step of TDX guest creation is to create vcpu.  Allocate TDX vcpu
structures, initialize it.  Allocate pages of TDX vcpu for the TDX module.

In the case of the conventional case, cpuid is empty at the initialization.
and cpuid is configured after the vcpu initialization.  Because TDX
supports only X2APIC mode, cpuid is forcibly initialized to support X2APIC
on the vcpu initialization.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 135 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 135 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 1273b60a1a00..d9fe3f6463c3 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -6,6 +6,7 @@
 #include "capabilities.h"
 #include "x86_ops.h"
 #include "tdx.h"
+#include "x86.h"
 
 #undef pr_fmt
 #define pr_fmt(fmt) "tdx: " fmt
@@ -61,6 +62,11 @@ static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
 	return pa;
 }
 
+static inline bool is_td_vcpu_created(struct vcpu_tdx *tdx)
+{
+	return tdx->tdvpr.added;
+}
+
 static inline bool is_td_created(struct kvm_tdx *kvm_tdx)
 {
 	return kvm_tdx->tdr.added;
@@ -392,6 +398,135 @@ int tdx_vm_init(struct kvm *kvm)
 	return ret;
 }
 
+int tdx_vcpu_create(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	int ret, i;
+
+	/* TDX only supports x2APIC, which requires an in-kernel local APIC. */
+	if (!vcpu->arch.apic)
+		return -EINVAL;
+
+	fpstate_set_confidential(&vcpu->arch.guest_fpu);
+
+	ret = tdx_alloc_td_page(&tdx->tdvpr);
+	if (ret)
+		return ret;
+
+	tdx->tdvpx = kcalloc(tdx_caps.tdvpx_nr_pages, sizeof(*tdx->tdvpx),
+			GFP_KERNEL_ACCOUNT);
+	if (!tdx->tdvpx) {
+		ret = -ENOMEM;
+		goto free_tdvpr;
+	}
+	for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++) {
+		ret = tdx_alloc_td_page(&tdx->tdvpx[i]);
+		if (ret)
+			goto free_tdvpx;
+	}
+
+	vcpu->arch.efer = EFER_SCE | EFER_LME | EFER_LMA | EFER_NX;
+
+	vcpu->arch.cr0_guest_owned_bits = -1ul;
+	vcpu->arch.cr4_guest_owned_bits = -1ul;
+
+	vcpu->arch.tsc_offset = to_kvm_tdx(vcpu->kvm)->tsc_offset;
+	vcpu->arch.l1_tsc_offset = vcpu->arch.tsc_offset;
+	vcpu->arch.guest_state_protected =
+		!(to_kvm_tdx(vcpu->kvm)->attributes & TDX_TD_ATTRIBUTE_DEBUG);
+
+	return 0;
+
+free_tdvpx:
+	/* @i points at the TDVPX page that failed allocation. */
+	for (--i; i >= 0; i--)
+		free_page(tdx->tdvpx[i].va);
+	kfree(tdx->tdvpx);
+free_tdvpr:
+	free_page(tdx->tdvpr.va);
+
+	return ret;
+}
+
+void tdx_vcpu_free(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	int i;
+
+	/* Can't reclaim or free pages if teardown failed. */
+	if (is_hkid_assigned(to_kvm_tdx(vcpu->kvm)))
+		return;
+
+	for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++)
+		tdx_reclaim_td_page(&tdx->tdvpx[i]);
+	kfree(tdx->tdvpx);
+	tdx_reclaim_td_page(&tdx->tdvpr);
+}
+
+void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	struct msr_data apic_base_msr;
+	u64 err;
+	int i;
+
+	/* TDX doesn't support INIT event. */
+	if (WARN_ON(init_event))
+		goto td_bugged;
+	if (WARN_ON(is_td_vcpu_created(tdx)))
+		goto td_bugged;
+
+	err = tdh_vp_create(kvm_tdx->tdr.pa, tdx->tdvpr.pa);
+	if (WARN_ON_ONCE(err)) {
+		pr_tdx_error(TDH_VP_CREATE, err, NULL);
+		goto td_bugged;
+	}
+	tdx_mark_td_page_added(&tdx->tdvpr);
+
+	for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++) {
+		err = tdh_vp_addcx(tdx->tdvpr.pa, tdx->tdvpx[i].pa);
+		if (WARN_ON_ONCE(err)) {
+			pr_tdx_error(TDH_VP_ADDCX, err, NULL);
+			goto td_bugged;
+		}
+		tdx_mark_td_page_added(&tdx->tdvpx[i]);
+	}
+
+	if (!vcpu->arch.cpuid_entries) {
+		/*
+		 * On cpu creation, cpuid entry is blank.  Forcibly enable
+		 * X2APIC feature to allow X2APIC.
+		 */
+		struct kvm_cpuid_entry2 *e;
+
+		e = kvmalloc_array(1, sizeof(*e), GFP_KERNEL_ACCOUNT);
+		*e  = (struct kvm_cpuid_entry2) {
+			.function = 1,	/* Features for X2APIC */
+			.index = 0,
+			.eax = 0,
+			.ebx = 0,
+			.ecx = 1ULL << 21,	/* X2APIC */
+			.edx = 0,
+		};
+		vcpu->arch.cpuid_entries = e;
+		vcpu->arch.cpuid_nent = 1;
+	}
+	apic_base_msr.data = APIC_DEFAULT_PHYS_BASE | LAPIC_MODE_X2APIC;
+	if (kvm_vcpu_is_reset_bsp(vcpu))
+		apic_base_msr.data |= MSR_IA32_APICBASE_BSP;
+	apic_base_msr.host_initiated = true;
+	if (WARN_ON(kvm_set_apic_base(vcpu, &apic_base_msr)))
+		goto td_bugged;
+
+	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+
+	return;
+
+td_bugged:
+	vcpu->kvm->vm_bugged = true;
+}
+
 int tdx_dev_ioctl(void __user *argp)
 {
 	struct kvm_tdx_capabilities __user *user_caps;
-- 
2.25.1

