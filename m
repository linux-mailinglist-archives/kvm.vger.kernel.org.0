Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78910667B47
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240392AbjALQk6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:40:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232750AbjALQh2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:37:28 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D16BB7D1;
        Thu, 12 Jan 2023 08:33:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541229; x=1705077229;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ihKGnqJBa7minypALfE9XUALsE00T9ZHzP9R8DlkExM=;
  b=YtUQU4rK/5v/LExcqL9FtsOOgSBSKoUkyyl5fn9RYh23bBJg9eHEcdmB
   Mr7auY+75YYnJ9IPUSaFIPSCMxFPuGURFnUtYn6jasYMt/wzpkWU62CpF
   PYsZcHGfSMm+jbGNF7u/tl3FmHRctEHTCs4WOplGfTs2em+KKhsL5Hb6r
   JUMAvCtJuGaPJcUk4YFt0jILvJkKhBzeLvcFIuFWyZ4bY1DFPWBaCkfug
   CQoO/ki9aeOYeRzBgJYEOmYpWk/I6waj3Ees4/e9ZoKDrMhX4vBEq1mmw
   eu69YVO6L8mNSt31NBDmsSacN5UBC3pXiIolxTSHvoMaCapkZWCZQLsiq
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="386089797"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="386089797"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:38 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="726372609"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="726372609"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:38 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v11 105/113] KVM: TDX: Add a method to ignore dirty logging
Date:   Thu, 12 Jan 2023 08:32:53 -0800
Message-Id: <a9b8397c82488c17739ffd59c35a5667e4d90ac5.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Currently TDX KVM doesn't support tracking dirty pages (yet).  Implement a
method to ignore it.  Because the flag for kvm memory slot to enable dirty
logging isn't accepted for TDX, warn on the method is called for TDX.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 47c2b6e1e484..cbac63170cea 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -730,6 +730,14 @@ static u8 vt_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 	return vmx_get_mt_mask(vcpu, gfn, is_mmio);
 }
 
+static void vt_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
+{
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return;
+
+	vmx_update_cpu_dirty_logging(vcpu);
+}
+
 static void vt_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 			u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code)
 {
@@ -873,7 +881,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.sched_in = vt_sched_in,
 
 	.cpu_dirty_log_size = PML_ENTITY_NUM,
-	.update_cpu_dirty_logging = vmx_update_cpu_dirty_logging,
+	.update_cpu_dirty_logging = vt_update_cpu_dirty_logging,
 
 	.nested_ops = &vmx_nested_ops,
 
-- 
2.25.1

