Return-Path: <kvm+bounces-68988-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yHbgOkSPc2l0xAAAu9opvQ
	(envelope-from <kvm+bounces-68988-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 16:09:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 05F2E777E8
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 16:09:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 436C730394B5
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 15:02:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26C1C35B63A;
	Fri, 23 Jan 2026 15:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jtIMl8z2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F10C335078;
	Fri, 23 Jan 2026 15:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769180432; cv=none; b=uYpmr2CO9O4UQ24cD1Cha3v4XLD2CsF2jUllmGOHfE+FsCuqkz7oLtuxZzwJg1SRGHo89P8y7tJZ3qMUgut67CiKoqKgwbN8/mws70TBH78ivpp3agev7SRuoYr2QFNfzcEinxQ34wN9AeqCUmMui4URHtMHxG/bGPOs+/pfFj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769180432; c=relaxed/simple;
	bh=4LnuKXZdo9kH8tHxBpxRr93UuLKtVKw8kcBh5tt10ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tgTdpakeg2yKCCcnrcmYxXCyy4Zrxm+1/2KGEW6yK/v6j+SPxeEzE/Vcy2Iy3FL/20e426Fv5A/0DEDRcl7OEBDGMeW069oMgpzxgrpPTdnosEeLtYknPJ9EfUALmmGp66YlqPQrc4I3+OFwAbxTQRCUKwCGLayUeZRsZzp2u+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jtIMl8z2; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769180428; x=1800716428;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4LnuKXZdo9kH8tHxBpxRr93UuLKtVKw8kcBh5tt10ng=;
  b=jtIMl8z2jnCWrimBeme1W5J1Wgw3h2h4EfiWGZbhoFXPyf5PIEinNsrk
   +gzzNQj7god8bUO/e0rrnDmDP1WFmMexWBoNsqvbRpUEVWHFHG1EcGJtH
   aoFaI9eBftwv4HQoUJ5JCiE9Vd/EICBxgLorPeQIHjvDUUlgV2zN6Kg6y
   kl74/hcVWdbquo/A3cMOgappWY6y+AQ6Lh3hbNVCJ5ysp397aJIUWJWST
   hj/3LAXTxjw8fcDajQsYpL/2SWnbSd+1lu2Yzig/CHSCngeoGu8JHXe1E
   C3vNEULM5AL7wxdXEJagC8U9FGPD4XusLqjgrckrCZoUattxLWGxzFhug
   g==;
X-CSE-ConnectionGUID: 6wQYFlGNSdCpasQ6KnWsjA==
X-CSE-MsgGUID: PQoMYUQjR0apP2Xj9UIdBw==
X-IronPort-AV: E=McAfee;i="6800,10657,11680"; a="70334431"
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="70334431"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 07:00:15 -0800
X-CSE-ConnectionGUID: 1JumdmDxTTmAtiAd9CUWtA==
X-CSE-MsgGUID: wg7sgRBERO6DFa1EHA3y/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="237697141"
Received: from 984fee019967.jf.intel.com ([10.23.153.244])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 07:00:15 -0800
From: Chao Gao <chao.gao@intel.com>
To: linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org
Cc: reinette.chatre@intel.com,
	ira.weiny@intel.com,
	kai.huang@intel.com,
	dan.j.williams@intel.com,
	yilun.xu@linux.intel.com,
	sagis@google.com,
	vannapurve@google.com,
	paulmck@kernel.org,
	nik.borisov@suse.com,
	zhenzhong.duan@intel.com,
	seanjc@google.com,
	rick.p.edgecombe@intel.com,
	kas@kernel.org,
	dave.hansen@linux.intel.com,
	vishal.l.verma@intel.com,
	Chao Gao <chao.gao@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v3 13/26] x86/virt/seamldr: Allocate and populate a module update request
Date: Fri, 23 Jan 2026 06:55:21 -0800
Message-ID: <20260123145645.90444-14-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260123145645.90444-1-chao.gao@intel.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[25];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68988-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:email,intel.com:url,intel.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 05F2E777E8
X-Rspamd-Action: no action

A module update request is a struct used to describe information about
the TDX module to install. It is part of the P-SEAMLDR <-> kernel ABI
and is accepted by the SEAMLDR_INSTALL SEAMCALL.

The request includes pointers to pages that contain the module binary, a
pointer to a sigstruct file, and an update scenario.

Define the request struct according to the P-SEAMLDR spec [1], and parse
the bitstream from userspace to populate that struct for later module
updates.

Note that the bitstream format is specified in [2]. It consists of a
header, a sigstruct, a module binary, and reserved fields for future
extensions. The header includes fields like a simple checksum and a
signature for error detection.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
Link: https://cdrdv2.intel.com/v1/dl/getContent/733584 # [1]
Link: https://github.com/intel/tdx-module-binaries/blob/main/blob_structure.txt # [2]
---
v3:
 - Print tdx_blob version in hex [Binbin]
 - Drop redundant sigstruct alignment check [Yilun]
 - Note buffers passed from firmware upload infrastructure are
   vmalloc()'d above alloc_seamldr_params()
---
 arch/x86/virt/vmx/tdx/seamldr.c | 158 ++++++++++++++++++++++++++++++++
 1 file changed, 158 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/seamldr.c b/arch/x86/virt/vmx/tdx/seamldr.c
index d1d4f96c4963..d136ef89cd36 100644
--- a/arch/x86/virt/vmx/tdx/seamldr.c
+++ b/arch/x86/virt/vmx/tdx/seamldr.c
@@ -6,10 +6,12 @@
  */
 #define pr_fmt(fmt)	"seamldr: " fmt
 
+#include <linux/cleanup.h>
 #include <linux/cpuhplock.h>
 #include <linux/cpumask.h>
 #include <linux/irqflags.h>
 #include <linux/mm.h>
+#include <linux/slab.h>
 #include <linux/types.h>
 
 #include <asm/seamldr.h>
@@ -19,6 +21,26 @@
 /* P-SEAMLDR SEAMCALL leaf function */
 #define P_SEAMLDR_INFO			0x8000000000000000
 
+/* P-SEAMLDR can accept up to 496 4KB pages for TDX module binary */
+#define SEAMLDR_MAX_NR_MODULE_4KB_PAGES	496
+
+/* scenario field in struct seamldr_params */
+#define SEAMLDR_SCENARIO_UPDATE		1
+
+/*
+ * Passed to P-SEAMLDR to describe information about the TDX module to install.
+ * Defined in "SEAM Loader (SEAMLDR) Interface Specification", Revision
+ * 343755-003, Section 3.2.
+ */
+struct seamldr_params {
+	u32	version;
+	u32	scenario;
+	u64	sigstruct_pa;
+	u8	reserved[104];
+	u64	num_module_pages;
+	u64	mod_pages_pa_list[SEAMLDR_MAX_NR_MODULE_4KB_PAGES];
+} __packed;
+
 static struct seamldr_info seamldr_info __aligned(256);
 
 static inline int seamldr_call(u64 fn, struct tdx_module_args *args)
@@ -73,6 +95,137 @@ const struct seamldr_info *seamldr_get_info(void)
 }
 EXPORT_SYMBOL_FOR_MODULES(seamldr_get_info, "tdx-host");
 
+static void free_seamldr_params(struct seamldr_params *params)
+{
+	free_page((unsigned long)params);
+}
+
+/*
+ * Allocate and populate a seamldr_params.
+ * Note that both @module and @sig should be vmalloc'd memory.
+ */
+static struct seamldr_params *alloc_seamldr_params(const void *module, unsigned int module_size,
+						   const void *sig, unsigned int sig_size)
+{
+	struct seamldr_params *params;
+	const u8 *ptr;
+	int i;
+
+	BUILD_BUG_ON(sizeof(struct seamldr_params) != SZ_4K);
+	if (module_size > SEAMLDR_MAX_NR_MODULE_4KB_PAGES * SZ_4K)
+		return ERR_PTR(-EINVAL);
+
+	if (!IS_ALIGNED(module_size, SZ_4K) || sig_size != SZ_4K ||
+	    !IS_ALIGNED((unsigned long)module, SZ_4K) ||
+	    !IS_ALIGNED((unsigned long)sig, SZ_4K))
+		return ERR_PTR(-EINVAL);
+
+	params = (struct seamldr_params *)get_zeroed_page(GFP_KERNEL);
+	if (!params)
+		return ERR_PTR(-ENOMEM);
+
+	params->scenario = SEAMLDR_SCENARIO_UPDATE;
+
+	/*
+	 * Don't assume @sig is page-aligned although it is 4KB-aligned.
+	 * Always add the in-page offset to get the physical address.
+	 */
+	params->sigstruct_pa = (vmalloc_to_pfn(sig) << PAGE_SHIFT) +
+			       ((unsigned long)sig & ~PAGE_MASK);
+	params->num_module_pages = module_size / SZ_4K;
+
+	ptr = module;
+	for (i = 0; i < params->num_module_pages; i++) {
+		params->mod_pages_pa_list[i] = (vmalloc_to_pfn(ptr) << PAGE_SHIFT) +
+					       ((unsigned long)ptr & ~PAGE_MASK);
+		ptr += SZ_4K;
+	}
+
+	return params;
+}
+
+/*
+ * Intel TDX Module blob. Its format is defined at:
+ * https://github.com/intel/tdx-module-binaries/blob/main/blob_structure.txt
+ */
+struct tdx_blob {
+	u16	version;
+	u16	checksum;
+	u32	offset_of_module;
+	u8	signature[8];
+	u32	len;
+	u32	resv1;
+	u64	resv2[509];
+	u8	data[];
+} __packed;
+
+/*
+ * Verify that the checksum of the entire blob is zero. The checksum is
+ * calculated by summing up all 16-bit words, with carry bits dropped.
+ */
+static bool verify_checksum(const struct tdx_blob *blob)
+{
+	u32 size = blob->len;
+	u16 checksum = 0;
+	const u16 *p;
+	int i;
+
+	/* Handle the last byte if the size is odd */
+	if (size % 2) {
+		checksum += *((const u8 *)blob + size - 1);
+		size--;
+	}
+
+	p = (const u16 *)blob;
+	for (i = 0; i < size; i += 2) {
+		checksum += *p;
+		p++;
+	}
+
+	return !checksum;
+}
+
+static struct seamldr_params *init_seamldr_params(const u8 *data, u32 size)
+{
+	const struct tdx_blob *blob = (const void *)data;
+	int module_size, sig_size;
+	const void *sig, *module;
+
+	if (blob->version != 0x100) {
+		pr_err("unsupported blob version: %x\n", blob->version);
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (blob->resv1 || memchr_inv(blob->resv2, 0, sizeof(blob->resv2))) {
+		pr_err("non-zero reserved fields\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	/* Split the given blob into a sigstruct and a module */
+	sig		= blob->data;
+	sig_size	= blob->offset_of_module - sizeof(struct tdx_blob);
+	module		= data + blob->offset_of_module;
+	module_size	= size - blob->offset_of_module;
+
+	if (sig_size <= 0 || module_size <= 0 || blob->len != size)
+		return ERR_PTR(-EINVAL);
+
+	if (memcmp(blob->signature, "TDX-BLOB", 8)) {
+		pr_err("invalid signature\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (!verify_checksum(blob)) {
+		pr_err("invalid checksum\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	return alloc_seamldr_params(module, module_size, sig, sig_size);
+}
+
+DEFINE_FREE(free_seamldr_params, struct seamldr_params *,
+	    if (!IS_ERR_OR_NULL(_T)) free_seamldr_params(_T))
+
 /**
  * seamldr_install_module - Install a new TDX module
  * @data: Pointer to the TDX module binary data. It should be vmalloc'd
@@ -94,6 +247,11 @@ int seamldr_install_module(const u8 *data, u32 size)
 	if (!is_vmalloc_addr(data))
 		return -EINVAL;
 
+	struct seamldr_params *params __free(free_seamldr_params) =
+						init_seamldr_params(data, size);
+	if (IS_ERR(params))
+		return PTR_ERR(params);
+
 	guard(cpus_read_lock)();
 	if (!cpumask_equal(cpu_online_mask, cpu_present_mask)) {
 		pr_err("Cannot update TDX module if any CPU is offline\n");
-- 
2.47.3


