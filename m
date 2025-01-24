Return-Path: <kvm+bounces-36486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AAA9AA1B6E1
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:37:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E201816CFF3
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:37:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 149834436E;
	Fri, 24 Jan 2025 13:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dh3F/s+O"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80824206B
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725827; cv=none; b=XrVJxvYq2qZtdBz1F/5+xbgMtsDLszwV9zLd+nBfzIKiodqx+Oqb24bz6eCVN0smbp0jP1FFloca03dmp3W79Q88ij1aE8PLp512rmYsLZeMuOGFdsTUkRfh3iHJyNOAw2idOEAUoBv3JlgR1QAcvbbbXJ/RqxmGVs5WxzaRUuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725827; c=relaxed/simple;
	bh=k4KI7JqdKXwSaj6F8A12dq8VgP78I35tk6J67g1GTA8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fhMvn1WzGb8A9Gu5je0MxCEbJh6ktzps6Z10w98WTqDFdlIqR+YxuqsH9r4FEF+3KzMNY4BgYbcI8b9sa6muCRDp4U7W37pMFwxDDWzAIV6WanJjCYHV06TX+5jqfjZwxrq5v7hWw9UrLYAnwfwBanHLvyAuQo7BBEva3snOYYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dh3F/s+O; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725826; x=1769261826;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k4KI7JqdKXwSaj6F8A12dq8VgP78I35tk6J67g1GTA8=;
  b=dh3F/s+OU6N1hiZiwmLpwEOtIuKlp4UQDaRSuDJwd7FCN/ODLmXfnCYu
   rjLOm8MR1k0KtT3r9kyxP2SXUohzoi2XmzAbWRt6wW37sHW5sTs3xlQ+t
   5rUgIEpaekv9RDvyd+Id9BiKeKNGlPc9XNw1CIz+lIpUsve/GWmODcvyp
   mSBsX6E/x8ulj8BwTipOblyB9Lk1O4o3z/Qg6BnZLOus1uZHwUPEycTDO
   0sBStf3WyQya/ku7nZbAthSZQ475ficj/tmTPHVcquNs7Jva+NDXyYTz9
   y0NxL1SQfWltTs38mvxFIikXNmbXUZ9QwNJ0Rbu161TzHimELOSy/TfMj
   w==;
X-CSE-ConnectionGUID: wKbnASmYS7mUeLBbIMAOug==
X-CSE-MsgGUID: ra9YFJpqQJi7IMR0HDVj/A==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246176"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246176"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:37:06 -0800
X-CSE-ConnectionGUID: nT6XmjO6Th61FL7urozFDw==
X-CSE-MsgGUID: lcLbrOt9SHyKhDI8nyXAlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804098"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:37:01 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Igor Mammedov <imammedo@redhat.com>
Cc: Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	xiaoyao.li@intel.com,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: [PATCH v7 01/52] *** HACK *** linux-headers: Update headers to pull in TDX API changes
Date: Fri, 24 Jan 2025 08:19:57 -0500
Message-Id: <20250124132048.3229049-2-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250124132048.3229049-1-xiaoyao.li@intel.com>
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Pull in recent TDX updates, which are not backwards compatible.

It's just to make this series runnable. It will be updated by script

	scripts/update-linux-headers.sh

once TDX support is upstreamed in linux kernel

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 linux-headers/asm-x86/kvm.h | 70 +++++++++++++++++++++++++++++++++++++
 linux-headers/linux/kvm.h   |  1 +
 2 files changed, 71 insertions(+)

diff --git a/linux-headers/asm-x86/kvm.h b/linux-headers/asm-x86/kvm.h
index 96589490c426..baca2d479365 100644
--- a/linux-headers/asm-x86/kvm.h
+++ b/linux-headers/asm-x86/kvm.h
@@ -923,5 +923,75 @@ struct kvm_hyperv_eventfd {
 #define KVM_X86_SEV_VM		2
 #define KVM_X86_SEV_ES_VM	3
 #define KVM_X86_SNP_VM		4
+#define KVM_X86_TDX_VM		5
+
+/* Trust Domain eXtension sub-ioctl() commands. */
+enum kvm_tdx_cmd_id {
+	KVM_TDX_CAPABILITIES = 0,
+	KVM_TDX_INIT_VM,
+	KVM_TDX_INIT_VCPU,
+	KVM_TDX_INIT_MEM_REGION,
+	KVM_TDX_FINALIZE_VM,
+	KVM_TDX_GET_CPUID,
+
+	KVM_TDX_CMD_NR_MAX,
+};
+
+struct kvm_tdx_cmd {
+	/* enum kvm_tdx_cmd_id */
+	__u32 id;
+	/* flags for sub-commend. If sub-command doesn't use this, set zero. */
+	__u32 flags;
+	/*
+	 * data for each sub-command. An immediate or a pointer to the actual
+	 * data in process virtual address.  If sub-command doesn't use it,
+	 * set zero.
+	 */
+	__u64 data;
+	/*
+	 * Auxiliary error code.  The sub-command may return TDX SEAMCALL
+	 * status code in addition to -Exxx.
+	 * Defined for consistency with struct kvm_sev_cmd.
+	 */
+	__u64 hw_error;
+};
+
+struct kvm_tdx_capabilities {
+	__u64 supported_attrs;
+	__u64 supported_xfam;
+	__u64 reserved[254];
+	struct kvm_cpuid2 cpuid;
+};
+
+struct kvm_tdx_init_vm {
+	__u64 attributes;
+	__u64 xfam;
+	__u64 mrconfigid[6];	/* sha384 digest */
+	__u64 mrowner[6];	/* sha384 digest */
+	__u64 mrownerconfig[6];	/* sha384 digest */
+
+	/* The total space for TD_PARAMS before the CPUIDs is 256 bytes */
+	__u64 reserved[12];
+
+	/*
+	 * Call KVM_TDX_INIT_VM before vcpu creation, thus before
+	 * KVM_SET_CPUID2.
+	 * This configuration supersedes KVM_SET_CPUID2s for VCPUs because the
+	 * TDX module directly virtualizes those CPUIDs without VMM.  The user
+	 * space VMM, e.g. qemu, should make KVM_SET_CPUID2 consistent with
+	 * those values.  If it doesn't, KVM may have wrong idea of vCPUIDs of
+	 * the guest, and KVM may wrongly emulate CPUIDs or MSRs that the TDX
+	 * module doesn't virtualize.
+	 */
+	struct kvm_cpuid2 cpuid;
+};
+
+#define KVM_TDX_MEASURE_MEMORY_REGION   _BITULL(0)
+
+struct kvm_tdx_init_mem_region {
+	__u64 source_addr;
+	__u64 gpa;
+	__u64 nr_pages;
+};
 
 #endif /* _ASM_X86_KVM_H */
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 3bcd4eabe324..b325122505b5 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -369,6 +369,7 @@ struct kvm_run {
 #define KVM_SYSTEM_EVENT_WAKEUP         4
 #define KVM_SYSTEM_EVENT_SUSPEND        5
 #define KVM_SYSTEM_EVENT_SEV_TERM       6
+#define KVM_SYSTEM_EVENT_TDX_FATAL      7
 			__u32 type;
 			__u32 ndata;
 			union {
-- 
2.34.1


