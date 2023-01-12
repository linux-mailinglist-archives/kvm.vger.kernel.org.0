Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F156E667B95
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240896AbjALQno (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:43:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240305AbjALQiq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:38:46 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509B41A395;
        Thu, 12 Jan 2023 08:34:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541247; x=1705077247;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MOWOzNQCLerslcUh6f06ow7P+ZCoxqv9lJ3uaHFqC6U=;
  b=W4MJSTvUenO2MOGmumb55ijyeqMOMWf8m3d0zi1ZKszRYrs1IhPuzuBq
   fjtCBx+QePv64VFTeMUqi5ZkLFBGEdLJA9NdwkO0eLzrHhFnhQgwXXDfw
   Q3TstZBgDL2gzW++HG7Jj/xqSall5eoIwmOBaP1Ar5TBlkbq3gUJja4Id
   ZI6khzHJ+MH0guBRPBQ29xPi5FOZLxrTfsomyT28qCah5dnf9ZpdwxsKR
   UQCRU2H3bm3o/fBwPStGF9DLiGTuHKfw40L13GTACwxgmQ3PtkBB6IAe5
   AlIM6bp5/j7uEmRpAbvgK6UQBNs4ya/ufQkJRyYoy5nLsPiYg2D+wf9pk
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323811958"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323811958"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:31 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="721151852"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="721151852"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:30 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v11 062/113] KVM: TDX: Finalize VM initialization
Date:   Thu, 12 Jan 2023 08:32:10 -0800
Message-Id: <6c535930b199b762f80aeca9a0f46d8050fbc77d.1673539699.git.isaku.yamahata@intel.com>
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

To protect the initial contents of the guest TD, the TDX module measures
the guest TD during the build process as SHA-384 measurement.  The
measurement of the guest TD contents needs to be completed to make the
guest TD ready to run.

Add a new subcommand, KVM_TDX_FINALIZE_VM, for VM-scoped
KVM_MEMORY_ENCRYPT_OP to finalize the measurement and mark the TDX VM ready
to run.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/uapi/asm/kvm.h       |  1 +
 arch/x86/kvm/vmx/tdx.c                | 31 +++++++++++++++++++++++++++
 tools/arch/x86/include/uapi/asm/kvm.h |  1 +
 3 files changed, 33 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 5280d175623d..24353eb901c0 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -538,6 +538,7 @@ enum kvm_tdx_cmd_id {
 	KVM_TDX_INIT_VM,
 	KVM_TDX_INIT_VCPU,
 	KVM_TDX_INIT_MEM_REGION,
+	KVM_TDX_FINALIZE_VM,
 
 	KVM_TDX_CMD_NR_MAX,
 };
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 5f1c459da363..d04e2729d2a3 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1252,6 +1252,34 @@ static int tdx_init_mem_region(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 	return ret;
 }
 
+static int tdx_td_finalizemr(struct kvm *kvm)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	u64 err;
+
+	if (!is_hkid_assigned(kvm_tdx) || is_td_finalized(kvm_tdx))
+		return -EINVAL;
+
+	err = tdh_mr_finalize(kvm_tdx->tdr_pa);
+	if (WARN_ON_ONCE(err)) {
+		pr_tdx_error(TDH_MR_FINALIZE, err, NULL);
+		return -EIO;
+	}
+
+	/*
+	 * Blindly do TDH_MEM_TRACK after finalizing the measurement to handle
+	 * the case where SEPT entries were zapped/blocked, e.g. from failed
+	 * NUMA balancing, after they were added to the TD via
+	 * tdx_init_mem_region().  TDX module doesn't allow TDH_MEM_TRACK prior
+	 * to TDH.MR.FINALIZE, and conversely requires TDH.MEM.TRACK for entries
+	 * that were TDH.MEM.RANGE.BLOCK'd prior to TDH.MR.FINALIZE.
+	 */
+	(void)tdh_mem_track(to_kvm_tdx(kvm)->tdr_pa);
+
+	kvm_tdx->finalized = true;
+	return 0;
+}
+
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_tdx_cmd tdx_cmd;
@@ -1271,6 +1299,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_TDX_INIT_MEM_REGION:
 		r = tdx_init_mem_region(kvm, &tdx_cmd);
 		break;
+	case KVM_TDX_FINALIZE_VM:
+		r = tdx_td_finalizemr(kvm);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
index 6587da064a61..7bab32a0b068 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -533,6 +533,7 @@ enum kvm_tdx_cmd_id {
 	KVM_TDX_INIT_VM,
 	KVM_TDX_INIT_VCPU,
 	KVM_TDX_INIT_MEM_REGION,
+	KVM_TDX_FINALIZE_VM,
 
 	KVM_TDX_CMD_NR_MAX,
 };
-- 
2.25.1

