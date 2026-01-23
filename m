Return-Path: <kvm+bounces-68977-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KIyXGHqNc2l0xAAAu9opvQ
	(envelope-from <kvm+bounces-68977-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 16:02:18 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id EEE78776AC
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 16:02:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4F7CD3046AAE
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 15:00:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0F7B28FFFB;
	Fri, 23 Jan 2026 15:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X0L/Ypiz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17FEF28488D;
	Fri, 23 Jan 2026 15:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769180415; cv=none; b=HeeqTPKxJa0C/U3DHlRv5c538lAlUhYBKoHtrO9pulrYGnIWfIKeTczQ92Jo6ZU2NuhSB6uOVszi0d0dLAMUZwkP9YJyoj8ajyOrqRg2tcXCZYxHmpajFRxpUD70Llu5gUfetHmyi5gb9P4+tMM6v1DN6SiWx4N53aa8MTPiH70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769180415; c=relaxed/simple;
	bh=HaMEyLc+oaG7OmponVaIw/lEk5QQtY46m2sTc9gb1PY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K89GbD1p5Q7tumB723dKe5KnGjKL31PxpOVVJEX8ysXbadAOFZiHGUSd6U9sCQu2gg7GAs2t3GQrXMT2u5oo0sLKWkBbYXOCBGTg9MlcsEYkqFvoK5lSHaEZ4WXamVYyTQkQ2N9YG0kr3/Nr/ak6U5Qhvya8edDxBFa3qcIhpn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X0L/Ypiz; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769180414; x=1800716414;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HaMEyLc+oaG7OmponVaIw/lEk5QQtY46m2sTc9gb1PY=;
  b=X0L/Ypiz7r+YW5B9pQRW4BI6SyAUI+MJxx1Hdk3ivr74OblG2tJjfNNn
   6lLgk5D6Fgr7xtynXPvDNE43yVCN02EPJ/EH2WsaOMkyBa23rxHq2TMLb
   ZAc5C9OCg2DIYTXFpvKFqsp6WaCryr8Dk7r5aYSf/qKKgN5yzQmzKh8Gs
   7ibI+4s8eoSiFdVG82GtGa21l1DjsVVkJ8fOe5XN8VbcRmDUAN6/gzvkN
   NKlOiYG4fM19IWHDIKwWRdF2+G9/lsr7fnbgOuFcWbi0mE3D1QFWoLDsZ
   rZLjoGRJ/DPKoC4FVj4NTd5yY3Gdl6/3M6afdB1mr3EVAErvIfFZ0l/FY
   Q==;
X-CSE-ConnectionGUID: 3UlHI+9YRJ+ZyfRLL6ioRQ==
X-CSE-MsgGUID: ina6bKOtQeywPv8ip0rA2w==
X-IronPort-AV: E=McAfee;i="6800,10657,11680"; a="70334337"
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="70334337"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 07:00:08 -0800
X-CSE-ConnectionGUID: EguImU4ATgyVTKaFDCrj2g==
X-CSE-MsgGUID: YPlqmC//QSWU0MFpB0KfEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="237697028"
Received: from 984fee019967.jf.intel.com ([10.23.153.244])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 07:00:08 -0800
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
Subject: [PATCH v3 02/26] x86/virt/tdx: Use %# prefix for hex values in SEAMCALL error messages
Date: Fri, 23 Jan 2026 06:55:10 -0800
Message-ID: <20260123145645.90444-3-chao.gao@intel.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[24];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68977-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,intel.com:mid]
X-Rspamd-Queue-Id: EEE78776AC
X-Rspamd-Action: no action

"%#" format specifier automatically adds the "0x" prefix and has one less
character than "0x%".

For conciseness, replace "0x%" with "%#" when printing hexadecimal values
in SEAMCALL error messages.

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
"0x%" is also used to print TDMR ranges. I didn't convert them to reduce
code churn, but if they should be converted for consistency, I'm happy
to do that.

v2: new
---
 arch/x86/virt/vmx/tdx/tdx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index dbc7cb08ca53..2218bb42af40 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -63,16 +63,16 @@ typedef void (*sc_err_func_t)(u64 fn, u64 err, struct tdx_module_args *args);
 
 static inline void seamcall_err(u64 fn, u64 err, struct tdx_module_args *args)
 {
-	pr_err("SEAMCALL (%llu) failed: 0x%016llx\n", fn, err);
+	pr_err("SEAMCALL (%llu) failed: %#016llx\n", fn, err);
 }
 
 static inline void seamcall_err_ret(u64 fn, u64 err,
 				    struct tdx_module_args *args)
 {
 	seamcall_err(fn, err, args);
-	pr_err("RCX 0x%016llx RDX 0x%016llx R08 0x%016llx\n",
+	pr_err("RCX %#016llx RDX %#016llx R08 %#016llx\n",
 			args->rcx, args->rdx, args->r8);
-	pr_err("R09 0x%016llx R10 0x%016llx R11 0x%016llx\n",
+	pr_err("R09 %#016llx R10 %#016llx R11 %#016llx\n",
 			args->r9, args->r10, args->r11);
 }
 
-- 
2.47.3


