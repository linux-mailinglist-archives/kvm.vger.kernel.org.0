Return-Path: <kvm+bounces-9700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4948866D22
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:52:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A0398283741
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:52:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2B1B1DA23;
	Mon, 26 Feb 2024 08:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QOpse7s+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F177692FB;
	Mon, 26 Feb 2024 08:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936115; cv=none; b=sJBloOYQR6+Kmxz2Bq79Vn/e6UvGX8zQRVdCs7xQ1PUBESHtCoVW3L7g2MD5KT7RSWDH9mcIWw037V0BwmdEEf4uoHgbDQlIkQOSR372uQhLq9HMA9KaGlNpfbqe3HF/iJxtxqNCNe8dAEGQout/ImUGZXFI5g30Ja7KLni1Hhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936115; c=relaxed/simple;
	bh=WLwpU+ZFzvbhXg3wiYCTpPwFcaOG9hkZbPu7n4G5fQY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uBKvNJfrpx1jE/7O7MCuSzmMA5iBlDh4dPxrEz8+kdugwRuyK0HaALZkwRvNThIVmO3d+FQcMJbFei2UHsyLPQZr7x6pnKZLP3aTPcq/oGCjg38thsCczofCQgZeNveTRBMf4Ha1yCRWoWjS5B/fTHExcu5ZL76+8Dg6Tl4R3mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QOpse7s+; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936114; x=1740472114;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WLwpU+ZFzvbhXg3wiYCTpPwFcaOG9hkZbPu7n4G5fQY=;
  b=QOpse7s+vdx0m3tbYa2IF/qB8lW/GHA0QqOwflfbpmBs3kyVXE2UbDsU
   2i7a4lnRNodp5+utyRAIjO4GPV31jstPp+riqKl3DxRu5wXa0eMP8Uilk
   Yd+qdZsOjbU+oam7ly1TTrum5G14m7HsPeUDjfYCJltZPuKRljysveAVr
   QnhWc3ZReED8jQfRfplEdAQ7VjTICue+8UfnDB7h/THMSQg/PGqfcUD0r
   wkMuDEcMBhbiU6tL2DwBvVREtp/XYQ3HV3QHkxxFfYxDbuHZXJrNZ+7ex
   O74sdVUOlBer4Kfpf0fACtSgbeEq/urYCZw6yfQ1Zni1iXVeBfVZrfCrz
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="3069489"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="3069489"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="11272485"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:33 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v19 076/130] KVM: TDX: Finalize VM initialization
Date: Mon, 26 Feb 2024 00:26:18 -0800
Message-Id: <e3c862ae9c78bda2988768c1038fec100bb372cf.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
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
v18:
- Remove the change of tools/arch/x86/include/uapi/asm/kvm.h.

v14 -> v15:
- removed unconditional tdx_track() by tdx_flush_tlb_current() that
  does tdx_track().

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/vmx/tdx.c          | 21 +++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 34167404020c..c160f60189d1 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -573,6 +573,7 @@ enum kvm_tdx_cmd_id {
 	KVM_TDX_INIT_VM,
 	KVM_TDX_INIT_VCPU,
 	KVM_TDX_EXTEND_MEMORY,
+	KVM_TDX_FINALIZE_VM,
 
 	KVM_TDX_CMD_NR_MAX,
 };
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 3cfba63a7762..6aff3f7e2488 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1400,6 +1400,24 @@ static int tdx_extend_memory(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
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
@@ -1422,6 +1440,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_TDX_EXTEND_MEMORY:
 		r = tdx_extend_memory(kvm, &tdx_cmd);
 		break;
+	case KVM_TDX_FINALIZE_VM:
+		r = tdx_td_finalizemr(kvm);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
-- 
2.25.1


