Return-Path: <kvm+bounces-68998-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yJ20IeOQc2l0xAAAu9opvQ
	(envelope-from <kvm+bounces-68998-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 16:16:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id CC93877A7C
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 16:16:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C55B330C6763
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 15:04:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEF1337880A;
	Fri, 23 Jan 2026 15:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JhItdOqe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1BFC36656C;
	Fri, 23 Jan 2026 15:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769180440; cv=none; b=RhF2LUZYvuHjAj3FaQCWXHJU6HW0po2dYuk080P+eKIkLUS44uvSKXSoxSIZAhxBvxTbHfNZMZ6+u41EUuQ8TfAQGtDdu2Qqzdp0DFxFskr+fsyFW1Et/ID/+rd2/Eipkxy8x25zgx+q7pg9Ds8sixhgTf+UQDHY21jzD6CKDjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769180440; c=relaxed/simple;
	bh=vvzbZrmWpmV4juJ40Ifm3lvVv14EgpU1dMvILRTmZHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPSFoPD3F1EhFT1rLWknguwrFxH4yj+Ghq/VUQYYP1Uiqwh2p9Mwg8x+v/2cw5OxTBO7QkaUmSnCDCBQABvYanjGrDvxWB4T0oce4f2EhpOGE33CxO36F0jLQv8P43Z0gBJdmLcJQuAt29+vxqy3VMu1RYgGYAnF+gSOgKk4nAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JhItdOqe; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769180439; x=1800716439;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vvzbZrmWpmV4juJ40Ifm3lvVv14EgpU1dMvILRTmZHk=;
  b=JhItdOqem5Q2CUwRkSzrRZe2kevhHUxmPA87mdo+PYdXQLrraUa/0bMA
   NtGxrFDIcJ/fH9VAiWKZkBwkdUwbJ+WFqnY6G99r+V8hKoYIv0pmRZzcq
   km7JxMwOR65X5bi3qtpI7cEYNsPhdW89L1Q3iUqwSqZacWeRBc5GPI8Fm
   81mjXaYaChae9bHx6XRqE/OJlJCNQTxJrm0B0DGIENGkG0GSg+Lw81hos
   YIIkC2BRLuDcp0Lc1EZwGIHUXMoKXRGRlX4s2Fv8fT5GfD0AcHLDsSaYz
   Bod2Xmn9i1BYTxgDw4XbqTEfbWBCVwHB5BaFQzynuDxa8a0TnfjQ+Hy+3
   A==;
X-CSE-ConnectionGUID: c9UrCA3jQHeVD7R78cmzNQ==
X-CSE-MsgGUID: LfqVcjYBTuihKnQs7Y8d4w==
X-IronPort-AV: E=McAfee;i="6800,10657,11680"; a="70334535"
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="70334535"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 07:00:21 -0800
X-CSE-ConnectionGUID: +sdwN0EGS4GqpGe5TPcqoA==
X-CSE-MsgGUID: xnPA9BEAT1OlpSc2sHrXWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="237697219"
Received: from 984fee019967.jf.intel.com ([10.23.153.244])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 07:00:21 -0800
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
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v3 24/26] x86/virt/seamldr: Extend sigstruct to 16KB
Date: Fri, 23 Jan 2026 06:55:32 -0800
Message-ID: <20260123145645.90444-25-chao.gao@intel.com>
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
	RCPT_COUNT_TWELVE(0.00)[24];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68998-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,intel.com:mid]
X-Rspamd-Queue-Id: CC93877A7C
X-Rspamd-Action: no action

Currently, each TDX Module has a 4KB sigstruct that is passed to the
P-SEAMLDR during module updates to authenticate the TDX Module binary.

Future TDX Module versions will pack additional information into the
sigstruct, which will exceed the current 4KB size limit.

To accommodate this, the sigstruct is being extended to support up to
16KB. Update seamldr_params and tdx-blob structures to handle the larger
sigstruct size.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/virt/vmx/tdx/seamldr.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/seamldr.c b/arch/x86/virt/vmx/tdx/seamldr.c
index d2d85114d6c4..9e77b24f659c 100644
--- a/arch/x86/virt/vmx/tdx/seamldr.c
+++ b/arch/x86/virt/vmx/tdx/seamldr.c
@@ -29,6 +29,8 @@
 /* P-SEAMLDR can accept up to 496 4KB pages for TDX module binary */
 #define SEAMLDR_MAX_NR_MODULE_4KB_PAGES	496
 
+#define SEAMLDR_MAX_NR_SIG_4KB_PAGES	4
+
 /* scenario field in struct seamldr_params */
 #define SEAMLDR_SCENARIO_UPDATE		1
 
@@ -40,8 +42,8 @@
 struct seamldr_params {
 	u32	version;
 	u32	scenario;
-	u64	sigstruct_pa;
-	u8	reserved[104];
+	u64	sigstruct_pa[SEAMLDR_MAX_NR_SIG_4KB_PAGES];
+	u8	reserved[80];
 	u64	num_module_pages;
 	u64	mod_pages_pa_list[SEAMLDR_MAX_NR_MODULE_4KB_PAGES];
 } __packed;
@@ -121,7 +123,10 @@ static struct seamldr_params *alloc_seamldr_params(const void *module, unsigned
 	if (module_size > SEAMLDR_MAX_NR_MODULE_4KB_PAGES * SZ_4K)
 		return ERR_PTR(-EINVAL);
 
-	if (!IS_ALIGNED(module_size, SZ_4K) || sig_size != SZ_4K ||
+	if (sig_size > SEAMLDR_MAX_NR_SIG_4KB_PAGES * SZ_4K)
+		return ERR_PTR(-EINVAL);
+
+	if (!IS_ALIGNED(module_size, SZ_4K) || !IS_ALIGNED(sig_size, SZ_4K) ||
 	    !IS_ALIGNED((unsigned long)module, SZ_4K) ||
 	    !IS_ALIGNED((unsigned long)sig, SZ_4K))
 		return ERR_PTR(-EINVAL);
@@ -132,12 +137,17 @@ static struct seamldr_params *alloc_seamldr_params(const void *module, unsigned
 
 	params->scenario = SEAMLDR_SCENARIO_UPDATE;
 
-	/*
-	 * Don't assume @sig is page-aligned although it is 4KB-aligned.
-	 * Always add the in-page offset to get the physical address.
-	 */
-	params->sigstruct_pa = (vmalloc_to_pfn(sig) << PAGE_SHIFT) +
-			       ((unsigned long)sig & ~PAGE_MASK);
+	ptr = sig;
+	for (i = 0; i < sig_size / SZ_4K; i++) {
+		/*
+		 * Don't assume @sig is page-aligned although it is 4KB-aligned.
+		 * Always add the in-page offset to get the physical address.
+		 */
+		params->sigstruct_pa[i] = (vmalloc_to_pfn(ptr) << PAGE_SHIFT) +
+					  ((unsigned long)ptr & ~PAGE_MASK);
+		ptr += SZ_4K;
+	}
+
 	params->num_module_pages = module_size / SZ_4K;
 
 	ptr = module;
-- 
2.47.3


