Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 888056B6456
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbjCLJy5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbjCLJyu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:54:50 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B62436FF8
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:54:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614889; x=1710150889;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=86y0tREPLuyN0zFA9basjyrhsvvVIpNwyPWtrDWHgpU=;
  b=DLxK2hyCDOZIV58bSobxFbiwys5VcVnsj38A71wxCjqmfiF16qrbGSuw
   /ZFrpBJcV9fCtl8PsxITc8LEwzA5GLUlN7XEKPy2bWqh0qV8DxX8S+J0Y
   7iaPxFe/z51x+iNHhueaP94Mccz0eS4Ps3jpZ+lLNQ8RzCtSimteXEoe+
   oc8r1dmIuZNIH40katLTTlYrHGVKRfLrEmrgKEVjv0wEMJzWGjkQJNvV2
   LEHMkQSEm1zGDS+XnSbybjDKYoFc539qlrLsFmvefUlmj66pQ4fs7Xffx
   OeZrCY2DznTOn3ox047Q/KTeXu0IOHl2TyYbUCMU/9q5iDUzAwDWgAUL3
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316622910"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316622910"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:54:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="852408991"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="852408991"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:54:27 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: [RFC PATCH part-2 07/17] pkvm: x86: Allocate vmcs and msr bitmap pages for host vcpu
Date:   Mon, 13 Mar 2023 02:01:02 +0800
Message-Id: <20230312180112.1778254-8-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180112.1778254-1-jason.cj.chen@intel.com>
References: <20230312180112.1778254-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VMCS page is key control structure to do VMX operations, and allocate it
with revision id (setup by __setup_vmcs_config) for host vcpu during its
VMX initialization. Later VMX ops VMPTRLD makes it as current VMCS pointer
to do VMCS fields setup through VMWRITE then run host VM through
VMLAUNCH.

pKVM enables "use MSR bitmaps" VM-execution control to intercept and
emulate necessary MSR (e,g, VMX MSR). It needs to setup a MSR bitmaps
page in VMCS field, and such page is allocated during host vcpu VMX
initialization in this patch as well.

Make use of vcpu_vmx->vmcs01 to record this information for host vcpu.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/pkvm_host.c | 54 ++++++++++++++++++++++++++++++-
 1 file changed, 53 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/pkvm/pkvm_host.c b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
index 6b937192e901..272205977e1e 100644
--- a/arch/x86/kvm/vmx/pkvm/pkvm_host.c
+++ b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
@@ -39,6 +39,28 @@ static void pkvm_early_free(void *ptr, int pages)
 	free_pages_exact(ptr, pages << PAGE_SHIFT);
 }
 
+static struct vmcs *pkvm_alloc_vmcs(struct vmcs_config *vmcs_config_ptr)
+{
+	struct vmcs *vmcs;
+	int pages = ALIGN(vmcs_config_ptr->size, PAGE_SIZE) >> PAGE_SHIFT;
+
+	vmcs = pkvm_early_alloc_contig(pages);
+	if (!vmcs)
+		return NULL;
+
+	memset(vmcs, 0, vmcs_config_ptr->size);
+	vmcs->hdr.revision_id = vmcs_config_ptr->revision_id; /* vmcs revision id */
+
+	return vmcs;
+}
+
+static void pkvm_free_vmcs(void *vmcs, struct vmcs_config *vmcs_config_ptr)
+{
+	int pages = ALIGN(vmcs_config_ptr->size, PAGE_SIZE) >> PAGE_SHIFT;
+
+	pkvm_early_free(vmcs, pages);
+}
+
 static inline void vmxon_setup_revid(void *vmxon_region)
 {
 	u32 rev_id = 0;
@@ -116,12 +138,42 @@ static __init int pkvm_enable_vmx(struct pkvm_host_vcpu *vcpu)
 
 static __init int pkvm_host_init_vmx(struct pkvm_host_vcpu *vcpu)
 {
-	return pkvm_enable_vmx(vcpu);
+	struct vcpu_vmx *vmx = &vcpu->vmx;
+	int ret;
+
+	ret = pkvm_enable_vmx(vcpu);
+	if (ret)
+		return ret;
+
+	/* vmcs01: host vmcs in pKVM */
+	vmx->vmcs01.vmcs = pkvm_alloc_vmcs(&pkvm->vmcs_config);
+	if (!vmx->vmcs01.vmcs)
+		return -ENOMEM;
+
+	vmx->vmcs01.msr_bitmap = pkvm_early_alloc_contig(1);
+	if (!vmx->vmcs01.msr_bitmap) {
+		pr_err("%s: No page for msr_bitmap\n", __func__);
+		return -ENOMEM;
+	}
+
+	return ret;
 }
 
 static __init void pkvm_host_deinit_vmx(struct pkvm_host_vcpu *vcpu)
 {
+	struct vcpu_vmx *vmx = &vcpu->vmx;
+
 	pkvm_cpu_vmxoff();
+
+	if (vmx->vmcs01.vmcs) {
+		pkvm_free_vmcs(vmx->vmcs01.vmcs, &pkvm->vmcs_config);
+		vmx->vmcs01.vmcs = NULL;
+	}
+
+	if (vmx->vmcs01.msr_bitmap) {
+		pkvm_early_free(vmx->vmcs01.msr_bitmap, 1);
+		vmx->vmcs01.msr_bitmap = NULL;
+	}
 }
 
 static __init int pkvm_host_check_and_setup_vmx_cap(struct pkvm_hyp *pkvm)
-- 
2.25.1

