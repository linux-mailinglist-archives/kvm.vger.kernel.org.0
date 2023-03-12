Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E59126B6977
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 19:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231727AbjCLSDO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 14:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231592AbjCLSCE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 14:02:04 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C2354C6E6;
        Sun, 12 Mar 2023 10:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678643957; x=1710179957;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eMGy5QxDn2SKE8EQsBgUoj7aSQRqMC9DsAcsKLbcZbA=;
  b=A6I6+FQmkBfZr8GBqqlg1krysH4uNco2uMlYUY2y+v5uUra/88gaWpPp
   kA69yFLopHQYj2oy9eSlEokWpotBBWpHX+qpiIrHXZIGwHO1Iz6CrZAih
   kgtb1uRth2GDZ69kt8GkS0Y+jl51rT7CutuVbufpE7YphWkTl4H9Mjfqh
   ffMnsZy0is5Pz8bAollEPuWJ7edlgcMlQFx4VoV4ZXdHijMxUWilv9Hff
   GwclzSifwa0g6X7FREBxQSfWDCNbmRuZEapIuXEkjVrmYzLuMLm5UKfPJ
   OIHbObRAN7F6Iq9XajeR3l9rze4v2FDoMn+K5aPoaSkVoWAnHB7O8fuF+
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="316659940"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316659940"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="742596690"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="742596690"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:08 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v13 061/113] KVM: TDX: Finalize VM initialization
Date:   Sun, 12 Mar 2023 10:56:25 -0700
Message-Id: <6b15c383c7110e06a313f6448d39b5824745f50a.1678643052.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1678643051.git.isaku.yamahata@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index 74148437ceac..445cf19d5f96 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -568,6 +568,7 @@ enum kvm_tdx_cmd_id {
 	KVM_TDX_INIT_VM,
 	KVM_TDX_INIT_VCPU,
 	KVM_TDX_INIT_MEM_REGION,
+	KVM_TDX_FINALIZE_VM,
 
 	KVM_TDX_CMD_NR_MAX,
 };
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 8e7dc4c70af0..d5a2f769a58d 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1295,6 +1295,34 @@ static int tdx_init_mem_region(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
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
@@ -1314,6 +1342,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
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
index a7d4d8fe9ca8..e5a66160f0ad 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -568,6 +568,7 @@ enum kvm_tdx_cmd_id {
 	KVM_TDX_INIT_VM,
 	KVM_TDX_INIT_VCPU,
 	KVM_TDX_INIT_MEM_REGION,
+	KVM_TDX_FINALIZE_VM,
 
 	KVM_TDX_CMD_NR_MAX,
 };
-- 
2.25.1

