Return-Path: <kvm+bounces-68981-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IDLrJluNc2l0xAAAu9opvQ
	(envelope-from <kvm+bounces-68981-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 16:01:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5370077695
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 16:01:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id D5608300B467
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 15:01:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 519EC344D80;
	Fri, 23 Jan 2026 15:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OPRxGL2S"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE4B1ADC83;
	Fri, 23 Jan 2026 15:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769180421; cv=none; b=EvwhRnfFxmKuyDkCyzR+mY05o1hNIDvtPF9nA3xUaBThMC3Snpp4mg5noVurGLvFwH6fPuIMYHkum/eGULVEeV5LSOuckI8T1qoPGJBewTgnPDSPrUnLMXeTKtijQ0yIiw+pjL+T3nrA5RRmqEeapoM6sV/WMw/NDl3Zapktmec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769180421; c=relaxed/simple;
	bh=EUdvM04qz2HU4Z4hCMb6uYQfEZu2qW0yXwhkH90a0KQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BOipTj1zUduf5oDYaKWM7duFG73w0SkMuJRBleY3mVpl2bw+x2iUKoQi7V1QSNw3OPREZIioyWJCv2S03b1kl2rw5N5EIvdZCPmI4oMxv/znNrLdIBEoqHs5EVpIchA4d+Hl5oL7KHESSzC0vGzVYnPJ5RPsschPb59fUTqC8b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OPRxGL2S; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769180418; x=1800716418;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EUdvM04qz2HU4Z4hCMb6uYQfEZu2qW0yXwhkH90a0KQ=;
  b=OPRxGL2SD4rjrd9v3jCz9qG9estkNDJOERlGqwPRmLIupeI3TXCwbuta
   xPNNYv+vz+/tbwv5f1AtWbO6DD/S578Lb5x+S8aPVGe4IUQL+h0wSAL5u
   UVF8BGio1VGHiWLJTZdevjn2x503xePWxt67lihBGWEX/OIB/wrtYSZNz
   URUZUGd1ATrjGQ0o+RW0v63ZLDSgrg+I1iJvw3yCH/n4kIMcasSbPawRk
   43g/5rby8p/r4CZYCYLk5UcDnVl+LoYzM8eQI5zd5Qco+Uaou/qwvW/zk
   bvli1t3I34kLhr0DTdA21HaCSbTuG9aO6Jl/CePE4MojjhFPZJM/64IgC
   w==;
X-CSE-ConnectionGUID: 49WS1UWMQBSVmP0sJl9HNA==
X-CSE-MsgGUID: Wq+vjex0QCShlQJ9O+dM6w==
X-IronPort-AV: E=McAfee;i="6800,10657,11680"; a="70334372"
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="70334372"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 07:00:11 -0800
X-CSE-ConnectionGUID: Vg43tIqvR7qE5IldtlceBQ==
X-CSE-MsgGUID: hVIuuNeVSl+O5J88qChV7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="237697090"
Received: from 984fee019967.jf.intel.com ([10.23.153.244])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 07:00:11 -0800
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
Subject: [PATCH v3 06/26] x86/virt/tdx: Prepare to support P-SEAMLDR SEAMCALLs
Date: Fri, 23 Jan 2026 06:55:14 -0800
Message-ID: <20260123145645.90444-7-chao.gao@intel.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[25];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68981-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,intel.com:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5370077695
X-Rspamd-Action: no action

P-SEAMLDR is another component alongside the TDX module within the
protected SEAM range. P-SEAMLDR can update the TDX module at runtime.
Software can talk with P-SEAMLDR via SEAMCALLs with the bit 63 of RAX
(leaf number) set to 1 (a.k.a P-SEAMLDR SEAMCALLs).

P-SEAMLDR SEAMCALLs differ from SEAMCALLs of the TDX module in terms of
error codes and the handling of the current VMCS.

In preparation for adding support for P-SEAMLDR SEAMCALLs, do the two
following changes to SEAMCALL low-level helpers:

1) Tweak sc_retry() to retry on "lack of entropy" errors reported by
   P-SEAMLDR because it uses a different error code.

2) Add seamldr_err() to log error messages on P-SEAMLDR SEAMCALL failures.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
---
Add seamldr_prerr() as a macro to be consistent with existing code. If
maintainers would like to switch these to static inline functions then I
would be happy to add a new patch to convert existing macros to static
inline functions and build on that.

v3:
 - print P-SEAMLDR leaf numbers in hex
 - use %# to print error code [Binbin]
 - mark the is_seamldr_call() call as unlikely [Binbin]
 - remove the function to get the error code for retry from leaf numbers
   [Yilun]
v2:
 - use a macro rather than an inline function for seamldr_err() for
   consistency.
---
 arch/x86/virt/vmx/tdx/seamcall.h | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/seamcall.h b/arch/x86/virt/vmx/tdx/seamcall.h
index 0912e03fabfe..256f71d6ca70 100644
--- a/arch/x86/virt/vmx/tdx/seamcall.h
+++ b/arch/x86/virt/vmx/tdx/seamcall.h
@@ -34,15 +34,28 @@ static __always_inline u64 __seamcall_dirty_cache(sc_func_t func, u64 fn,
 	return func(fn, args);
 }
 
+#define SEAMLDR_RND_NO_ENTROPY	0x8000000000030001ULL
+
+#define SEAMLDR_SEAMCALL_MASK	_BITUL(63)
+
+static inline bool is_seamldr_call(u64 fn)
+{
+	return fn & SEAMLDR_SEAMCALL_MASK;
+}
+
 static __always_inline u64 sc_retry(sc_func_t func, u64 fn,
 			   struct tdx_module_args *args)
 {
+	u64 retry_code = TDX_RND_NO_ENTROPY;
 	int retry = RDRAND_RETRY_LOOPS;
 	u64 ret;
 
+	if (unlikely(is_seamldr_call(fn)))
+		retry_code = SEAMLDR_RND_NO_ENTROPY;
+
 	do {
 		ret = func(fn, args);
-	} while (ret == TDX_RND_NO_ENTROPY && --retry);
+	} while (ret == retry_code && --retry);
 
 	return ret;
 }
@@ -68,6 +81,16 @@ static inline void seamcall_err_ret(u64 fn, u64 err,
 			args->r9, args->r10, args->r11);
 }
 
+static inline void seamldr_err(u64 fn, u64 err, struct tdx_module_args *args)
+{
+	/*
+	 * Note: P-SEAMLDR leaf numbers are printed in hex as they have
+	 * bit 63 set, making them hard to read and understand if printed
+	 * in decimal
+	 */
+	pr_err("P-SEAMLDR (%llx) failed: %#016llx\n", fn, err);
+}
+
 static __always_inline int sc_retry_prerr(sc_func_t func,
 					  sc_err_func_t err_func,
 					  u64 fn, struct tdx_module_args *args)
@@ -96,4 +119,7 @@ static __always_inline int sc_retry_prerr(sc_func_t func,
 #define seamcall_prerr_ret(__fn, __args)					\
 	sc_retry_prerr(__seamcall_ret, seamcall_err_ret, (__fn), (__args))
 
+#define seamldr_prerr(__fn, __args)						\
+	sc_retry_prerr(__seamcall, seamldr_err, (__fn), (__args))
+
 #endif
-- 
2.47.3


