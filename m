Return-Path: <kvm+bounces-61539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97BDFC222F3
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 21:16:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C86384268D9
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 20:13:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1696382876;
	Thu, 30 Oct 2025 20:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RAsAjtKF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F94381E41
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 20:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761855026; cv=none; b=KAczzfvrjTagIpPzeT8Z5jpPJuv9GTQHbHx26+VCYdQ4GfxdUMojiAzQckzzwZDrjz3xKNGX4ed4RqvesCas+xUZJXtf8/3CUtCvxMfdCyrpPV7sWNCLCb4sIBcS9FNCzvDyX2hwl6PzjDvVEWt/V6ICTBOfEzpSSeZkEBRPzSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761855026; c=relaxed/simple;
	bh=VPvA8JSjcYzb7PAL2NCANYZ0tcPgx4vpcgMWgfs85d0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BMZC/X9zTlooslo83Ft4Na1x1b99rNAqrj0SmvZMe5o6p0WQrTZKg/ygsIjomRCzppZp8q2xS+ArZzZ/x/sqPYPenvANMAasEWuOFw0zjC33pbuSYPER3pM7/KyVIRJ8bWiiIRhKLQtozSth8cOvIQ4NJsXF3vBYVT1DtiziNTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RAsAjtKF; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33dadf7c5beso1398494a91.0
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 13:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761855024; x=1762459824; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=IvM7TjIntZ9FlQ6yPFIX7Pdb82bcYcGNbKTNQ5X1yLU=;
        b=RAsAjtKFqBFhMwFq6toP5dP0KTxOgS1mv6Bb6GEoY/sJqhjeRUT+156qucBNkuQd9z
         vhTCqmDN8XamGFLJxNtUL5mE79I6366jAxdlaXRywFBGRyX9GlWRCpwXZj9xtFxI00kw
         3uFshrpVjk9O+Q4Y9Sj0ZPfpGqyHgrGWwFz9jodRrO8LukyqdLxP/aCxBxOn6F6aW7V+
         2kKCjwJly6tNcgLL8l8PorUxJQKBexh870eo4Mfk06ZD8Q3OBtjKaBDPeHVJWRN7jXti
         f6r+Z2iLC32gC/7uUcA/LPFtmRdoCNh5fWtN4i2ojTyCPKmFtnaddc2NoQq75bE1ARKd
         Mmeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761855024; x=1762459824;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IvM7TjIntZ9FlQ6yPFIX7Pdb82bcYcGNbKTNQ5X1yLU=;
        b=X974xKYDQl7Qqef/yifwen1PechlRtrV7MBbzavL1gEAGYaEudvX1cx/aSt1neILuS
         GKItXtaWFkjFqHDUWej5M2UIlkPgpg9sEibkeucbksWZxZGX9xnLWnFh/vEmpuAUp6gS
         i2NksOlQ+lNwb13WnRR6+FEwh0p1+2dy4Z9kumbjauehwU248Pl6C2z44QszwrU+YCR+
         kedAnhoNldK0DdNVO+GfHDTiNqvip3tVNXKG1SDi6CMB43SVBUI5x2fO4VMoZFV/Brn3
         OPUASI6rP5kTrdeLzMm7WAUwfEcYTvuYScuy5kL+Caja6w8ZhCaXCSL1E02/aSaHsBBr
         H1fQ==
X-Forwarded-Encrypted: i=1; AJvYcCWWkyDV4WovRJl6T+gUZNCsBsbS2sd8A6as6ipfHKlIB15QiKKtI9czHFpyd/YdINaq/C8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMtiu4owFPMH5Aw15Vx11rFNEX6LJA8VfbgCw4AnEdpBSDx5uc
	k1BGy7u5ZrZrGXZhnIQU6Sz1+Z4BrUcLcX+1uilawRycYqsETB5EpmojEruOBz2Ww9LnZV0VI9F
	e6pn5uA==
X-Google-Smtp-Source: AGHT+IGgb27AO5v2WDGNnxGkmz0o+KOcj5EzJAo9YzbL1iR1u4hmGEpmIxfQoNCUxUiI3kNavEPI4qshnw4=
X-Received: from pjdr2.prod.google.com ([2002:a17:90a:2e82:b0:340:8a98:4706])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3947:b0:340:6fae:1a0c
 with SMTP id 98e67ed59e1d1-34083070e80mr1280206a91.21.1761855023579; Thu, 30
 Oct 2025 13:10:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Oct 2025 13:09:33 -0700
In-Reply-To: <20251030200951.3402865-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251030200951.3402865-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251030200951.3402865-11-seanjc@google.com>
Subject: [PATCH v4 10/28] KVM: TDX: Fold tdx_sept_drop_private_spte() into tdx_sept_remove_private_spte()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Fold tdx_sept_drop_private_spte() into tdx_sept_remove_private_spte() as a
step towards having "remove" be the only and only function that deals with
removing/zapping/dropping a SPTE, e.g. to avoid having to differentiate
between "zap", "drop", and "remove".  Eliminating the "drop" helper also
gets rid of what is effectively dead code due to redundant checks, e.g. on
an HKID being assigned.

No functional change intended.

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 90 +++++++++++++++++++-----------------------
 1 file changed, 40 insertions(+), 50 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index c242d73b6a7b..abea9b3d08cf 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1648,55 +1648,6 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	return tdx_mem_page_record_premap_cnt(kvm, gfn, level, pfn);
 }
 
-static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
-				      enum pg_level level, struct page *page)
-{
-	int tdx_level = pg_level_to_tdx_sept_level(level);
-	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
-	gpa_t gpa = gfn_to_gpa(gfn);
-	u64 err, entry, level_state;
-
-	/* TODO: handle large pages. */
-	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
-		return -EIO;
-
-	if (KVM_BUG_ON(!is_hkid_assigned(kvm_tdx), kvm))
-		return -EIO;
-
-	/*
-	 * When zapping private page, write lock is held. So no race condition
-	 * with other vcpu sept operation.
-	 * Race with TDH.VP.ENTER due to (0-step mitigation) and Guest TDCALLs.
-	 */
-	err = tdh_mem_page_remove(&kvm_tdx->td, gpa, tdx_level, &entry,
-				  &level_state);
-
-	if (unlikely(tdx_operand_busy(err))) {
-		/*
-		 * The second retry is expected to succeed after kicking off all
-		 * other vCPUs and prevent them from invoking TDH.VP.ENTER.
-		 */
-		tdx_no_vcpus_enter_start(kvm);
-		err = tdh_mem_page_remove(&kvm_tdx->td, gpa, tdx_level, &entry,
-					  &level_state);
-		tdx_no_vcpus_enter_stop(kvm);
-	}
-
-	if (KVM_BUG_ON(err, kvm)) {
-		pr_tdx_error_2(TDH_MEM_PAGE_REMOVE, err, entry, level_state);
-		return -EIO;
-	}
-
-	err = tdh_phymem_page_wbinvd_hkid((u16)kvm_tdx->hkid, page);
-
-	if (KVM_BUG_ON(err, kvm)) {
-		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
-		return -EIO;
-	}
-	tdx_quirk_reset_page(page);
-	return 0;
-}
-
 static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
 				     enum pg_level level, void *private_spt)
 {
@@ -1858,7 +1809,11 @@ static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
 static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 					enum pg_level level, kvm_pfn_t pfn)
 {
+	int tdx_level = pg_level_to_tdx_sept_level(level);
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	struct page *page = pfn_to_page(pfn);
+	gpa_t gpa = gfn_to_gpa(gfn);
+	u64 err, entry, level_state;
 	int ret;
 
 	/*
@@ -1869,6 +1824,10 @@ static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (KVM_BUG_ON(!is_hkid_assigned(to_kvm_tdx(kvm)), kvm))
 		return -EIO;
 
+	/* TODO: handle large pages. */
+	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
+		return -EIO;
+
 	ret = tdx_sept_zap_private_spte(kvm, gfn, level, page);
 	if (ret <= 0)
 		return ret;
@@ -1879,7 +1838,38 @@ static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	 */
 	tdx_track(kvm);
 
-	return tdx_sept_drop_private_spte(kvm, gfn, level, page);
+	/*
+	 * When zapping private page, write lock is held. So no race condition
+	 * with other vcpu sept operation.
+	 * Race with TDH.VP.ENTER due to (0-step mitigation) and Guest TDCALLs.
+	 */
+	err = tdh_mem_page_remove(&kvm_tdx->td, gpa, tdx_level, &entry,
+				  &level_state);
+
+	if (unlikely(tdx_operand_busy(err))) {
+		/*
+		 * The second retry is expected to succeed after kicking off all
+		 * other vCPUs and prevent them from invoking TDH.VP.ENTER.
+		 */
+		tdx_no_vcpus_enter_start(kvm);
+		err = tdh_mem_page_remove(&kvm_tdx->td, gpa, tdx_level, &entry,
+					  &level_state);
+		tdx_no_vcpus_enter_stop(kvm);
+	}
+
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error_2(TDH_MEM_PAGE_REMOVE, err, entry, level_state);
+		return -EIO;
+	}
+
+	err = tdh_phymem_page_wbinvd_hkid((u16)kvm_tdx->hkid, page);
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
+		return -EIO;
+	}
+
+	tdx_quirk_reset_page(page);
+	return 0;
 }
 
 void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
-- 
2.51.1.930.gacf6e81ea2-goog


