Return-Path: <kvm+bounces-64042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 76C25C76D4A
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 02:00:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id 1719C33460
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:56:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B066E2D8DB1;
	Fri, 21 Nov 2025 00:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zkn9XFu2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66EDC2C11E0;
	Fri, 21 Nov 2025 00:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763686314; cv=none; b=g2Ov2uGmR4ymyNa/adGgtMiJRerB/mIZSQd0IBtlBMICFxh7vg4ZmlfpBmsUDIJckxarwPmh8zFyZEMd72+gHbQtoyA4OFaOvJxC+WXmRgKIPKpPKLPHuYzQOx0ikfYACGQ9xzwnX7QWb2SzHgVnNqujqi/SEma4VYP6IQPF5Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763686314; c=relaxed/simple;
	bh=pioh7oItQU+pjwmsuy2xyp62gOAlhgcs49oI3IaESJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gqpw/slfewK6gzh69XgQHgbqbFYWl3godi8BDjetsPbhgMl1yaYH07bsRX+5vD69ynaRQ1jIX3TcQEGDpDWoFrjiDZLO7GRjudfzutSaak0QIRr5lZBkHEMjQjV/cBEnks4hMwJ4iXHTXvNxSwZfLKZUtfihgGVWkVd3kpORJQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Zkn9XFu2; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763686312; x=1795222312;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pioh7oItQU+pjwmsuy2xyp62gOAlhgcs49oI3IaESJI=;
  b=Zkn9XFu2AlVsKwketHfmKu22BpjcDVAaJDVR1esWQHGu4RMOlSkTeWdi
   e26v85xtOl6hJLxVWoz0Rlc53KGUtS9HRpr/BbsYTq+kT0DWIkyjjv6kK
   s2tEfkkWz3X7xOgl+FSHpwderG7BxzayxOHVZQPXtEv4jDf6DXpl13JWQ
   CHLhE+U2KJISP2qzW76RxO0lmpdBYlWe93NOKNoTjF6NudK+cxbZD+QRf
   5PUd0mzWDzunixHJBw9Y9E0qaGHDiTkJ9I7m/F3zYxoHCrgCTZZZcdXxM
   tutVLGiCbBPkw3wINiM9ZushZVn52Z0PDi3wDMi2JJX2y/e3B85fvU6zG
   Q==;
X-CSE-ConnectionGUID: nJnPBHXcQ62O2qTSrrJNbw==
X-CSE-MsgGUID: EZ+hEkjdQIqAR73oe2cBqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11619"; a="64780818"
X-IronPort-AV: E=Sophos;i="6.20,214,1758610800"; 
   d="scan'208";a="64780818"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 16:51:47 -0800
X-CSE-ConnectionGUID: OUrv/n8TQauFiyl+Yyjz9A==
X-CSE-MsgGUID: 6mW1DfIPSVGrU8V5zT9Jdw==
X-ExtLoop1: 1
Received: from rpedgeco-desk.jf.intel.com ([10.88.27.139])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 16:51:46 -0800
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: bp@alien8.de,
	chao.gao@intel.com,
	dave.hansen@intel.com,
	isaku.yamahata@intel.com,
	kai.huang@intel.com,
	kas@kernel.org,
	kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	mingo@redhat.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	tglx@linutronix.de,
	vannapurve@google.com,
	x86@kernel.org,
	yan.y.zhao@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@intel.com
Cc: rick.p.edgecombe@intel.com,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH v4 14/16] KVM: TDX: Reclaim PAMT memory
Date: Thu, 20 Nov 2025 16:51:23 -0800
Message-ID: <20251121005125.417831-15-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Call tdx_free_page() and tdx_pamt_put() on the paths that free TDX
pages.

The PAMT memory holds metadata for TDX-protected memory. With Dynamic
PAMT, PAMT_4K is allocated on demand. The kernel supplies the TDX module
with a few pages that cover 2M of host physical memory.

PAMT memory can be reclaimed when the last user is gone. It can happen
in a few code paths:

- On TDH.PHYMEM.PAGE.RECLAIM in tdx_reclaim_td_control_pages() and
  tdx_reclaim_page().

- On TDH.MEM.PAGE.REMOVE in tdx_sept_drop_private_spte().

- In tdx_sept_zap_private_spte() for pages that were in the queue to be
  added with TDH.MEM.PAGE.ADD, but it never happened due to an error.

- In tdx_sept_free_private_spt() for SEPT pages;

Add tdx_pamt_put() for memory that comes from guest_memfd and use
tdx_free_page() for the rest.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
[Minor log tweak]
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
v4:
 - Rebasing on post-populate series required some changes on how PAMT
   refcounting was handled in the KVM_TDX_INIT_MEM_REGION path. Now
   instead of incrementing DPAMT refcount on the fake add in the fault
   path, it only increments it when tdh_mem_page_add() actually succeeds,
   like in tdx_mem_page_aug(). Because of this, the special handling for
   the case tdx_is_sept_zap_err_due_to_premap() cared about is unneeded.

v3:
 - Minor log tweak to conform kvm/x86 style.
---
 arch/x86/kvm/vmx/tdx.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 24322263ac27..f8de50e7dc7f 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -360,7 +360,7 @@ static void tdx_reclaim_control_page(struct page *ctrl_page)
 	if (tdx_reclaim_page(ctrl_page))
 		return;
 
-	__free_page(ctrl_page);
+	tdx_free_page(ctrl_page);
 }
 
 struct tdx_flush_vp_arg {
@@ -597,7 +597,7 @@ static void tdx_reclaim_td_control_pages(struct kvm *kvm)
 
 	tdx_quirk_reset_page(kvm_tdx->td.tdr_page);
 
-	__free_page(kvm_tdx->td.tdr_page);
+	tdx_free_page(kvm_tdx->td.tdr_page);
 	kvm_tdx->td.tdr_page = NULL;
 }
 
@@ -1827,6 +1827,8 @@ static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
 				     enum pg_level level, void *private_spt)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	struct page *page = virt_to_page(private_spt);
+	int ret;
 
 	/*
 	 * free_external_spt() is only called after hkid is freed when TD is
@@ -1843,7 +1845,12 @@ static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
 	 * The HKID assigned to this TD was already freed and cache was
 	 * already flushed. We don't have to flush again.
 	 */
-	return tdx_reclaim_page(virt_to_page(private_spt));
+	ret = tdx_reclaim_page(virt_to_page(private_spt));
+	if (ret)
+		return ret;
+
+	tdx_pamt_put(page);
+	return 0;
 }
 
 static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
@@ -1895,6 +1902,7 @@ static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 		return;
 
 	tdx_quirk_reset_page(page);
+	tdx_pamt_put(page);
 }
 
 void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
-- 
2.51.2


