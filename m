Return-Path: <kvm+bounces-25828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7386C96AF20
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 05:20:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1DF2F1F26050
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 03:20:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3EB44AEE6;
	Wed,  4 Sep 2024 03:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kjKDZ9f7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F5013D2A9;
	Wed,  4 Sep 2024 03:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725419687; cv=none; b=gaC+OE9oePmi6Sh8SS37oCWH5mpqK8derv7mMED72BcUbNQDbm0gZxh1TAWNAEkQjwZvy9W11BHDZMMDXZj8w2iKHTh3kHNixnKLjBE3K7kkBNUksmaenvUewB2ZNqRQg90A+mGILzn17VSJ+PmALuNSjNQuTAfJeVibutal6Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725419687; c=relaxed/simple;
	bh=rrGzdniK2GFyZIc5ro2AjfZct5nRKwSCW1uYyGcSXGc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fk61cmg6/YDGVd3n67CFYN9nZg99jkAhs0Uj8B4KSCVanrbZMKlw+Icx3R9s1tmRPO7mVhJcgoKblqXhI+xay5FxN3sAl/ycKm7JaCNhXbcDmWkxiNWtj8WNoxU0AVMTvate3h/CIgGj9RFDUFzQffitVoWcBhGZ1KMp0f3gJnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kjKDZ9f7; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725419685; x=1756955685;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rrGzdniK2GFyZIc5ro2AjfZct5nRKwSCW1uYyGcSXGc=;
  b=kjKDZ9f7Hd2WJI0Z+SD20mROJ7nCn4JB2TWq1YSPH3TSx54hvCTGLxy+
   DCh+mnkTeMruLlu4QmMaBFnhPxoKnR6EBoOFTZsSqDpj+Gv7IxD2rIchM
   UG+uluQMz4lNF9XylkTeYoN/6maLrnYsiH9GSVByDvt+Vjwpy+wK9hmZ3
   bTqdmqAvj9CYu0jKhHeTSqGWJEHwfrt7ByfTtTB6Kftlk8Z0uoOoR7mO/
   YRoIhMbqRcDydfPopV2pecs3sWmFr4dL8fQHLm4XNjjvRD2kVfHp5Zttg
   lwQHOtl3TnUGVeRiLbG9Qveoekzzf1gVGkhoItipqQu+HrwRWQi8EgNFV
   A==;
X-CSE-ConnectionGUID: F2g5uzRZSOyT4pUZVCyCYQ==
X-CSE-MsgGUID: fX7yLL1CTnejx8byXtEEvA==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="23564731"
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="23564731"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:08:13 -0700
X-CSE-ConnectionGUID: 7vh4eNHSTwa0BdE85cfHew==
X-CSE-MsgGUID: 6OVuKBC4SuSNz+jWnNoS+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="65106389"
Received: from dgramcko-desk.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.221.153])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:08:12 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	dmatlack@google.com,
	isaku.yamahata@gmail.com,
	yan.y.zhao@intel.com,
	nik.borisov@suse.com,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 20/21] KVM: TDX: Finalize VM initialization
Date: Tue,  3 Sep 2024 20:07:50 -0700
Message-Id: <20240904030751.117579-21-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add a new VM-scoped KVM_MEMORY_ENCRYPT_OP IOCTL subcommand,
KVM_TDX_FINALIZE_VM, to perform TD Measurement Finalization.

Documentation for the API is added in another patch:
"Documentation/virt/kvm: Document on Trust Domain Extensions(TDX)"

For the purpose of attestation, a measurement must be made of the TDX VM
initial state. This is referred to as TD Measurement Finalization, and
uses SEAMCALL TDH.MR.FINALIZE, after which:
1. The VMM adding TD private pages with arbitrary content is no longer
   allowed
2. The TDX VM is runnable

Co-developed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU part 2 v1:
 - Added premapped check.
 - Update for the wrapper functions for SEAMCALLs. (Sean)
 - Add check if nr_premapped is zero.  If not, return error.
 - Use KVM_BUG_ON() in tdx_td_finalizer() for consistency.
 - Change tdx_td_finalizemr() to take struct kvm_tdx_cmd *cmd and return error
   (Adrian)
 - Handle TDX_OPERAND_BUSY case (Adrian)
 - Updates from seamcall overhaul (Kai)
 - Rename error->hw_error

v18:
 - Remove the change of tools/arch/x86/include/uapi/asm/kvm.h.

v15:
 - removed unconditional tdx_track() by tdx_flush_tlb_current() that
   does tdx_track().
---
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/vmx/tdx.c          | 28 ++++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 789d1d821b4f..0b4827e39458 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -932,6 +932,7 @@ enum kvm_tdx_cmd_id {
 	KVM_TDX_INIT_VM,
 	KVM_TDX_INIT_VCPU,
 	KVM_TDX_INIT_MEM_REGION,
+	KVM_TDX_FINALIZE_VM,
 	KVM_TDX_GET_CPUID,
 
 	KVM_TDX_CMD_NR_MAX,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 796d1a495a66..3083a66bb895 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1257,6 +1257,31 @@ void tdx_flush_tlb_current(struct kvm_vcpu *vcpu)
 	ept_sync_global();
 }
 
+static int tdx_td_finalizemr(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+
+	if (!is_hkid_assigned(kvm_tdx) || is_td_finalized(kvm_tdx))
+		return -EINVAL;
+	/*
+	 * Pages are pending for KVM_TDX_INIT_MEM_REGION to issue
+	 * TDH.MEM.PAGE.ADD().
+	 */
+	if (atomic64_read(&kvm_tdx->nr_premapped))
+		return -EINVAL;
+
+	cmd->hw_error = tdh_mr_finalize(kvm_tdx);
+	if ((cmd->hw_error & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_BUSY)
+		return -EAGAIN;
+	if (KVM_BUG_ON(cmd->hw_error, kvm)) {
+		pr_tdx_error(TDH_MR_FINALIZE, cmd->hw_error);
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
@@ -1281,6 +1306,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_TDX_INIT_VM:
 		r = tdx_td_init(kvm, &tdx_cmd);
 		break;
+	case KVM_TDX_FINALIZE_VM:
+		r = tdx_td_finalizemr(kvm, &tdx_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
-- 
2.34.1


