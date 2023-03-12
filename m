Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D680A6B6480
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbjCLJ6m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbjCLJ6E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:58:04 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E160150F9E
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:57:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615049; x=1710151049;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qAJmt+ZUWNNjJK8RhVCXPSQLKBqL9wM/yJiMzzt0ARs=;
  b=AFETVo8EHn04sbsO8Vym9z82PqMaAIG4yXeL2oT1Xif0AjG124+yFe4k
   Jj6tRu6sH8+f8wg94XTJWTol6r6TPbu1rGp489VNPUUa8Ixq/dU5VB7Qp
   8eyi7Lf3R/HOXSuVcZyXRKdAHWMLMTgpt7mSxYdaD3Yu7e7a3SK2lzsgI
   eMswedLgLSR70cAerId1vh8tb7+ZWtD7F+/9NcHb9F9hGalwzvNGvjS9P
   VuYGNW8zcfIn85Gy4+OVdB/iew7YYzQW7L0u7fWh0YDieg6UZcrHPEyNf
   cAbSdeDw0SDDcqYRwB9voOetBuUum2Jcy9KoOuoa//yt6YGGt7BAol843
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="336998093"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="336998093"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="680677646"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="680677646"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:10 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-5 02/22] pkvm: x86: Add memory operation APIs for for host VM
Date:   Mon, 13 Mar 2023 02:02:43 +0800
Message-Id: <20230312180303.1778492-3-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180303.1778492-1-jason.cj.chen@intel.com>
References: <20230312180303.1778492-1-jason.cj.chen@intel.com>
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

Add below memory operation APIs for host VM:
- gva2gpa
- read_gva/write_gva
- read_gpa/write_gpa
such ops will be used later for vmx instruction emulation, for example,
vmxon instruction will put vmxon area's point in a guest memory, it
means pKVM need to read its content from a gva.

Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/memory.c | 106 +++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/memory.h |  11 +++
 arch/x86/kvm/vmx/pkvm/hyp/vmexit.c |   1 +
 3 files changed, 118 insertions(+)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/memory.c b/arch/x86/kvm/vmx/pkvm/hyp/memory.c
index d3e479860189..e99fa72cedac 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/memory.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/memory.c
@@ -6,7 +6,10 @@
 #include <linux/types.h>
 #include <asm/kvm_pkvm.h>
 
+#include <pkvm.h>
 #include "memory.h"
+#include "pgtable.h"
+#include "pkvm_hyp.h"
 
 unsigned long __page_base_offset;
 unsigned long __symbol_base_offset;
@@ -63,3 +66,106 @@ bool mem_range_included(struct mem_range *child, struct mem_range *parent)
 {
 	return parent->start <= child->start && child->end <= parent->end;
 }
+
+void *host_gpa2hva(unsigned long gpa)
+{
+	/* host gpa = hpa */
+	return pkvm_phys_to_virt(gpa);
+}
+
+extern struct pkvm_pgtable_ops mmu_ops;
+static struct pkvm_mm_ops mm_ops = {
+	.phys_to_virt = host_gpa2hva,
+};
+
+static int check_translation(struct kvm_vcpu *vcpu, gpa_t gpa,
+		u64 prot, u32 access, struct x86_exception *exception)
+{
+	/* TODO: exception for #PF */
+	return 0;
+}
+
+int gva2gpa(struct kvm_vcpu *vcpu, gva_t gva, gpa_t *gpa,
+		u32 access, struct x86_exception *exception)
+{
+	struct pkvm_pgtable guest_mmu;
+	gpa_t _gpa;
+	u64 prot;
+	int pg_level;
+
+	/* caller should ensure exception is not NULL */
+	WARN_ON(exception == NULL);
+
+	memset(exception, 0, sizeof(*exception));
+
+	/*TODO: support other paging mode beside long mode */
+	guest_mmu.root_pa = vcpu->arch.cr3 & PAGE_MASK;
+	pkvm_pgtable_init(&guest_mmu, &mm_ops, &mmu_ops, &pkvm_hyp->mmu_cap, false);
+	pkvm_pgtable_lookup(&guest_mmu, (unsigned long)gva,
+			(unsigned long *)&_gpa, &prot, &pg_level);
+	*gpa = _gpa;
+	if (_gpa == INVALID_ADDR)
+		return -EFAULT;
+
+	return check_translation(vcpu, _gpa, prot, access, exception);
+}
+
+/* only support host VM now */
+static int copy_gva(struct kvm_vcpu *vcpu, gva_t gva, void *addr,
+		unsigned int bytes, struct x86_exception *exception, bool from_guest)
+{
+	u32 access = VMX_AR_DPL(vmcs_read32(GUEST_SS_AR_BYTES)) == 3 ? PFERR_USER_MASK : 0;
+	gpa_t gpa;
+	void *hva;
+	int ret;
+
+	/*FIXME: need check the gva per page granularity */
+	ret = gva2gpa(vcpu, gva, &gpa, access, exception);
+	if (ret)
+		return ret;
+
+	hva = host_gpa2hva(gpa);
+	if (from_guest)
+		memcpy(addr, hva, bytes);
+	else
+		memcpy(hva, addr, bytes);
+
+	return bytes;
+}
+
+int read_gva(struct kvm_vcpu *vcpu, gva_t gva, void *addr,
+		unsigned int bytes, struct x86_exception *exception)
+{
+	return copy_gva(vcpu, gva, addr, bytes, exception, true);
+}
+
+int write_gva(struct kvm_vcpu *vcpu, gva_t gva, void *addr,
+		unsigned int bytes, struct x86_exception *exception)
+{
+	return copy_gva(vcpu, gva, addr, bytes, exception, false);
+}
+
+/* only support host VM now */
+static int copy_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, void *addr,
+		unsigned int bytes, bool from_guest)
+{
+	void *hva;
+
+	hva = host_gpa2hva(gpa);
+	if (from_guest)
+		memcpy(addr, hva, bytes);
+	else
+		memcpy(hva, addr, bytes);
+
+	return bytes;
+}
+
+int read_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, void *addr, unsigned int bytes)
+{
+	return copy_gpa(vcpu, gpa, addr, bytes, true);
+}
+
+int write_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, void *addr, unsigned int bytes)
+{
+	return copy_gpa(vcpu, gpa, addr, bytes, false);
+}
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/memory.h b/arch/x86/kvm/vmx/pkvm/hyp/memory.h
index c9175272096b..4a75d8dff1b3 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/memory.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/memory.h
@@ -20,4 +20,15 @@ struct mem_range {
 bool find_mem_range(unsigned long addr, struct mem_range *range);
 bool mem_range_included(struct mem_range *child, struct mem_range *parent);
 
+#include <linux/kvm_host.h>
+void *host_gpa2hva(unsigned long gpa);
+int gva2gpa(struct kvm_vcpu *vcpu, gva_t gva, gpa_t *gpa,
+		u32 access, struct x86_exception *exception);
+int read_gva(struct kvm_vcpu *vcpu, gva_t gva, void *addr,
+		unsigned int bytes, struct x86_exception *exception);
+int write_gva(struct kvm_vcpu *vcpu, gva_t gva, void *addr,
+		unsigned int bytes, struct x86_exception *exception);
+int read_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, void *addr, unsigned int bytes);
+int write_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, void *addr, unsigned int bytes);
+
 #endif
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c b/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c
index e8015a6830b0..02224d93384a 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c
@@ -154,6 +154,7 @@ int pkvm_main(struct kvm_vcpu *vcpu)
 		}
 
 		vcpu->arch.cr2 = native_read_cr2();
+		vcpu->arch.cr3 = vmcs_readl(GUEST_CR3);
 
 		vmx->exit_reason.full = vmcs_read32(VM_EXIT_REASON);
 		vmx->exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
-- 
2.25.1

