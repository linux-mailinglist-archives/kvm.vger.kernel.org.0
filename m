Return-Path: <kvm+bounces-6656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B217A83783C
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:10:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C8FB2924D6
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:10:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0D1C6A350;
	Mon, 22 Jan 2024 23:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WTTV0sKt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE62679E4;
	Mon, 22 Jan 2024 23:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967758; cv=none; b=VcL9v8kAKQ39kezJ++Ie0Fx7fnbS6IWwZOoSimdmk/wEvPXAmbt3IeX2TuqZlLFwZWWuGF18Isn8xUZX0IThe+4Pq/EGT4aM5pxvEjUOoPrnRM0XsTctHv9lToh+QaWmXDX1EzDExFxfiN2DhlNgeuTYp6sSF4QJ5BwjhQh5rV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967758; c=relaxed/simple;
	bh=uxYufzop2laEHK1z19d6w/Q3lRI1D5BR2hLfHAi+uA8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qy/H8TjRHc/dlf8qLGGQisj50iuvOUdLo5zrhk8XFQEEMHobiNZ4Wm83agLiqB1RZNRleYSMhCDjPZtrJ1aER7ya0zwTDH322bYkxo+xuIMg6OTBuvMKpX7C5tZmNSM2lVlp4yaeEoRvR6wkyxACOkHwX2MkyWv/5ng+jcYi8xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WTTV0sKt; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967757; x=1737503757;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uxYufzop2laEHK1z19d6w/Q3lRI1D5BR2hLfHAi+uA8=;
  b=WTTV0sKt1z2r4jwcCDZnI5qaNJ+K3HSpPMzDXYdfiMDMJi7gbgIUDtNI
   lttqmhrKkLD4marZBx5jQA4IZk1lyo7rrUM1Zq+29w4XD2ct5b1CBvrxN
   JytOmeoIeB+dsqy4H1ZAoOqvUsiM35WzF4vYHzQFRXxVprLgbqAVfurAO
   CwgK2pAqYrXNoLBz7FkphPY0ZqswwIGvf812gC4NSs4C0u+KfWuBbGuGX
   DLx6moyHfidMMV9UoI+f9bsJyA2WR1zkUQNxAyR4hTQVACQ0lv195ydao
   CkzZqwpqcvhqSRnAYI48FEYRnX9o6mBahRXosbdyHfBXTC3HGleK1qOIL
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="8016492"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="8016492"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1468230"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:38 -0800
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
Subject: [PATCH v18 065/121] KVM: TDX: Finalize VM initialization
Date: Mon, 22 Jan 2024 15:53:41 -0800
Message-Id: <ebce8fd312a9ea4386b8df7ad4da41db4400b73e.1705965635.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965634.git.isaku.yamahata@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
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
---
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/vmx/tdx.c          | 21 +++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 9fda7c90b7b5..f2a37b479f26 100644
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
index 1a5a91b99de9..faa04d8922b6 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1473,6 +1473,24 @@ static int tdx_init_mem_region(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
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
@@ -1495,6 +1513,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_TDX_INIT_MEM_REGION:
 		r = tdx_init_mem_region(kvm, &tdx_cmd);
 		break;
+	case KVM_TDX_FINALIZE_VM:
+		r = tdx_td_finalizemr(kvm);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
-- 
2.25.1


