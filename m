Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D30956B64A0
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 11:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbjCLKAo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 06:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbjCLKAG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 06:00:06 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0067C18ABA
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:59:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615150; x=1710151150;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=djoPEtfyddIBv2aQNJPfp+f/K0zw4PhG2s75CN6Oyls=;
  b=QJzeiH2o73/nkEKjkacOopXsbSBTkMkMgVsscKS3DUPE1OaGbrRgWMpw
   uWWa6MxI+It5LnAaDadB0+waxabAX4basgZaoEvEM6qhTCp56iiPFqS3B
   Qt0mT3bQHdjhbI7lMn+CflG288W2wVX5AeZ1E3qZmKZo4QZHoW9K4vG+6
   nWmRsHTN6uBoDTiOtjGotD2/uARv185x9AfCymVwFpU3Su0cp9JPxIMxv
   EVSlR2xIVQ6u2b3kXtGaPI5Wsr2lcoSY64RW7YdCDEvmSvPUTgfh6bNjg
   iDNx7NWbxAYYHP2YtApZvFtN9ixt4iMpQQ2TZHPw8YZmk72EBRwM98wjn
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="339344720"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="339344720"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:57:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="1007627373"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="1007627373"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:57:02 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: [RFC PATCH part-6 11/13] pkvm: x86: Introduce shadow EPT invalidation support
Date:   Mon, 13 Mar 2023 02:03:43 +0800
Message-Id: <20230312180345.1778588-12-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180345.1778588-1-jason.cj.chen@intel.com>
References: <20230312180345.1778588-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Shadow EPT invalidation is required to emulate INVEPT.

And as a VM only has one shadow EPT, when vEPTP got changed, the shadow
EPT shall be invalidated as well.

The invalidation is implemented by just simply destroying all the existing
mappings for corresponding shadow EPT without freeing the root.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/ept.c      | 18 ++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/ept.h      |  1 +
 arch/x86/kvm/vmx/pkvm/hyp/nested.c   | 12 ++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h |  3 +++
 4 files changed, 34 insertions(+)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/ept.c b/arch/x86/kvm/vmx/pkvm/hyp/ept.c
index a0793e4d02ef..de68f8c9eeb0 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/ept.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/ept.c
@@ -305,6 +305,24 @@ static struct pkvm_mm_ops shadow_ept_mm_ops = {
 	.flush_tlb = flush_tlb_noop,
 };
 
+void pkvm_invalidate_shadow_ept(struct shadow_ept_desc *desc)
+{
+	struct pkvm_shadow_vm *vm = sept_desc_to_shadow_vm(desc);
+	struct pkvm_pgtable *sept = &desc->sept;
+	unsigned long size = sept->pgt_ops->pgt_level_to_size(sept->level + 1);
+
+	pkvm_spin_lock(&vm->lock);
+
+	if (!is_valid_eptp(desc->shadow_eptp))
+		goto out;
+
+	pkvm_pgtable_unmap(sept, 0, size);
+
+	flush_ept(desc->shadow_eptp);
+out:
+	pkvm_spin_unlock(&vm->lock);
+}
+
 void pkvm_shadow_ept_deinit(struct shadow_ept_desc *desc)
 {
 	struct pkvm_pgtable *sept = &desc->sept;
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/ept.h b/arch/x86/kvm/vmx/pkvm/hyp/ept.h
index 92a4f18535ea..f63538368746 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/ept.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/ept.h
@@ -32,6 +32,7 @@ void pkvm_guest_ept_init(struct shadow_vcpu_state *shadow_vcpu, u64 guest_eptp);
 void pkvm_guest_ept_deinit(struct shadow_vcpu_state *shadow_vcpu);
 enum sept_handle_ret
 pkvm_handle_shadow_ept_violation(struct shadow_vcpu_state *shadow_vcpu, u64 l2_gpa, u64 exit_quali);
+void pkvm_invalidate_shadow_ept(struct shadow_ept_desc *desc);
 
 static inline bool is_valid_eptp(u64 eptp)
 {
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/nested.c b/arch/x86/kvm/vmx/pkvm/hyp/nested.c
index 22c161100145..8b9202ecafff 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/nested.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/nested.c
@@ -708,6 +708,8 @@ static void nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 static void setup_guest_ept(struct shadow_vcpu_state *shadow_vcpu, u64 guest_eptp)
 {
 	struct vmcs12 *vmcs12 = (struct vmcs12 *)shadow_vcpu->cached_vmcs12;
+	struct pkvm_shadow_vm *vm = shadow_vcpu->vm;
+	bool invalidate = false;
 
 	if (!is_valid_eptp(guest_eptp))
 		pkvm_guest_ept_deinit(shadow_vcpu);
@@ -715,6 +717,16 @@ static void setup_guest_ept(struct shadow_vcpu_state *shadow_vcpu, u64 guest_ept
 		pkvm_guest_ept_deinit(shadow_vcpu);
 		pkvm_guest_ept_init(shadow_vcpu, guest_eptp);
 	}
+
+	pkvm_spin_lock(&vm->lock);
+	if (vm->sept_desc.last_guest_eptp != guest_eptp) {
+		vm->sept_desc.last_guest_eptp = guest_eptp;
+		invalidate = true;
+	}
+	pkvm_spin_unlock(&vm->lock);
+
+	if (invalidate)
+		pkvm_invalidate_shadow_ept(&vm->sept_desc);
 }
 
 int handle_vmxon(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h b/arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h
index f891660d9085..cc7ec8505a98 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h
@@ -15,6 +15,9 @@ struct shadow_ept_desc {
 	/* shadow EPTP value configured by pkvm */
 	u64 shadow_eptp;
 
+	/* Save the last guest EPTP value configured by kvm high */
+	u64 last_guest_eptp;
+
 	struct pkvm_pgtable sept;
 };
 
-- 
2.25.1

