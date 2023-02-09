Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E48C68FD3B
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 03:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbjBICls (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 21:41:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232133AbjBIClR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 21:41:17 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E81629437
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 18:41:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675910475; x=1707446475;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RozJ/gzxgAwpaGMFdcRGLx9n/ARfjXGU/nWNk3jvgkg=;
  b=jL+4ckLP20YXcUDOmNlF9R9iLN5cHvef7lqpR88Yd6rluKED4Wmi2ESf
   ZFaKk9PLfhpqwDq3W53JAxZVnrSkZq+0L+e3MCQoxJsL8GxVsmRFq6JEH
   v5eLnnGKgYjTm1eo+YaIOLrg5ayEqo+AZVMxwYPEWMZuYlxN1O1pFZyfo
   7lu0pzvjEsFD9BDM/yxmM83rhZpgkzeP2UOf5VXCp/qceOieGYZ/0I7m1
   1c2PwVjJHBE+6WsI20fdufxvNWVJgAL9Sj7SNR5X+5+8oRvsWHbUnryoL
   WZR7qvC25oh1HV3Sld0jCBzPGWtUMghJac9Rt/6WX5vHqImDm938kVqiL
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="394586658"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="394586658"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 18:41:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="645094436"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="645094436"
Received: from sqa-gate.sh.intel.com (HELO robert-clx2.tsp.org) ([10.239.48.212])
  by orsmga006.jf.intel.com with ESMTP; 08 Feb 2023 18:41:10 -0800
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, yu.c.zhang@linux.intel.com,
        yuan.yao@linux.intel.com, jingqi.liu@intel.com,
        weijiang.yang@intel.com, chao.gao@intel.com,
        isaku.yamahata@intel.com
Cc:     kirill.shutemov@linux.intel.com, kvm@vger.kernel.org,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v4 6/9] KVM: x86: When KVM judges CR3 valid or not, consider LAM bits
Date:   Thu,  9 Feb 2023 10:40:19 +0800
Message-Id: <20230209024022.3371768-7-robert.hu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230209024022.3371768-1-robert.hu@linux.intel.com>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Before apply to kvm_vcpu_is_illegal_gpa(), clear LAM bits if it's valid.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>
---
 arch/x86/kvm/x86.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1bdc8c0c80c0..3218f465ae71 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1231,6 +1231,14 @@ static void kvm_invalidate_pcid(struct kvm_vcpu *vcpu, unsigned long pcid)
 	kvm_mmu_free_roots(vcpu->kvm, mmu, roots_to_free);
 }
 
+static bool kvm_is_valid_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
+{
+	if (guest_cpuid_has(vcpu, X86_FEATURE_LAM))
+		cr3 &= ~(X86_CR3_LAM_U48 | X86_CR3_LAM_U57);
+
+	return kvm_vcpu_is_legal_gpa(vcpu, cr3);
+}
+
 int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 {
 	bool skip_tlb_flush = false;
@@ -1254,7 +1262,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	 * stuff CR3, e.g. for RSM emulation, and there is no guarantee that
 	 * the current vCPU mode is accurate.
 	 */
-	if (kvm_vcpu_is_illegal_gpa(vcpu, cr3))
+	if (!kvm_is_valid_cr3(vcpu, cr3))
 		return 1;
 
 	if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, cr3))
-- 
2.31.1

