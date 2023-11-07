Return-Path: <kvm+bounces-945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BE377E4291
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 16:02:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A04BEB2129E
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:02:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE589358BD;
	Tue,  7 Nov 2023 15:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KeJ2yZwa"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4FC8358B5
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 15:00:24 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17E02422C;
	Tue,  7 Nov 2023 06:59:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369199; x=1730905199;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=t296sOBw3tRA26oDWIsL7fAOE1b/ps7IKCGJBA1F2U0=;
  b=KeJ2yZwa/NYYywb6QOAuURduPpWZX3bAJpDbwmRT3MPb3VekuhgfqIQt
   ebhvSqqBuFSUdX31eJj/ovnp9k2a6Du1p3EW8kmOzMOmHmREz2pz954j7
   f4FXF4BSlWdULkoyfWK6wEbmGcFwDEhDdNBhiJ+LcvvXvRdJyO6BXQfW3
   ZNw8na8jhiVOT3MJI/XLqheQf1GqNX9atkmmXhqMkVTRGrMVEXht4hUwU
   6ZS+GYRBwI3C4QaUMeM933mx98PXD74BVzYlKZ+kbuznoyTD2v0a2eWYU
   fJeSCmny65EXbXNiEcXwFrqZkjJ5UIXykmIFYw2lWCTwRSrjrI2wIjCPW
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="2462407"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="2462407"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10851442"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:17 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v17 060/116] KVM: TDX: Finalize VM initialization
Date: Tue,  7 Nov 2023 06:56:26 -0800
Message-Id: <21513b983db8648afff5dc4a700c8ad5356c142c.1699368322.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1699368322.git.isaku.yamahata@intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
v14 -> v15:
- removed unconditional tdx_track() by tdx_flush_tlb_current() that
  does tdx_track().
---
 arch/x86/include/uapi/asm/kvm.h       |  1 +
 arch/x86/kvm/vmx/tdx.c                | 21 +++++++++++++++++++++
 tools/arch/x86/include/uapi/asm/kvm.h |  1 +
 3 files changed, 23 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index a1815fcbb0be..1b4134247837 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -573,6 +573,7 @@ enum kvm_tdx_cmd_id {
 	KVM_TDX_INIT_VM,
 	KVM_TDX_INIT_VCPU,
 	KVM_TDX_INIT_MEM_REGION,
+	KVM_TDX_FINALIZE_VM,
 
 	KVM_TDX_CMD_NR_MAX,
 };
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 2b635fcf11b4..caf7eb331487 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1405,6 +1405,24 @@ static int tdx_init_mem_region(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
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
+	kvm_tdx->finalized = true;
+	return 0;
+}
+
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_tdx_cmd tdx_cmd;
@@ -1427,6 +1445,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
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
index a3408f6e1124..4753a29a22ec 100644
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


