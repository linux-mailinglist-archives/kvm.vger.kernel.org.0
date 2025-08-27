Return-Path: <kvm+bounces-55809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 47F19B375D6
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 02:07:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 66BB61B677B0
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 00:07:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D6B41F3D56;
	Wed, 27 Aug 2025 00:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Cnehlumx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768B31DFE0B
	for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 00:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756253136; cv=none; b=aVCj8VILAv+oAS3CPpGsixKzLvdGWLfrDyRNdqXHySjPHmiGymB3cXPBSSY7k+nIcmNlrlkW3YcOm+ShZycyB0vNCicPvETmIxs0Nct9t0J5E1gd5xcb4fILV7SGwdekQotCnrALdKRPNWwPI+wbiUDwRvrdACK9Oh9KJvZ1cPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756253136; c=relaxed/simple;
	bh=cqqucMYtivTxgJ2yWtjMcM5NpaFOO1MES3223ug0X4E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=khBteVXUS/2GyYo8MlYp7DLcveURfCT/j9ODQS1wlXSxCy5MoBeSOSbaba84wF28Qw2BveSB+Fbu6mfVXJQQxxTp3Q4Vp2uiX8fAzkfSUQ0jxxF1aly+jUsLS2bTeZBCN1PdUAQRv4izDLe8vg/smjTS257YiqjrhItARY7G8+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Cnehlumx; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-325ce9b32baso2338933a91.0
        for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 17:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756253135; x=1756857935; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=oGCmox8NCxkTSpPUlLKTfWHUVoiysl+0iyU32s+8vBE=;
        b=Cnehlumx5usGz9bDM7tH+A9BsThIbDUwO9/e6cwD6Sd48sx1Sv8jqgKm0aSrTlfVPF
         TS1T7PcgcInnBxA1EKivFEdk4+nUXBUuQq2xzvKr+XcKpZ1rcUxpm5GA+ks96mOj1ky0
         SlmnBke0dt2bqy+2vLPd+5V0EF1TmeH8ZYFAzKxgddP4+I1ybNnYaNDKZdx8qKLAYbRJ
         6rzidg/0wvS2Txyzv9P9yfxbLKJobKv82pfANzJS34vvDSt+mVp2gqDbyTvltjGq76Pz
         2/gbhzUkP7Kz7I/HizUZ9pOPZ99B4l/70uoOvSVcBqvHPDuKuSTykzOdkufU5DVyhw+H
         ms7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756253135; x=1756857935;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oGCmox8NCxkTSpPUlLKTfWHUVoiysl+0iyU32s+8vBE=;
        b=kLjvBoAabVHKsIPEa8G/wDD9lVjkN4FRPjat1Icj56sBNZJ7IBVCim97n5rJDPKeSS
         erWA0+3owqyPn3kCWKDJhdTBLYNSAh+YTXsnrDGZV/u9E7mupUK2qE8dRThBMCG3eGPt
         Q2WvaX/fgxaxxNSklM+S0f8tZE7vHr/lA8EgFvJlG4hedWcuWs7chyNnOblVKhGA8v+i
         ogjkoGsdMB8i5q94StxWDqO63B619/C8ZxPFtNpoFn+1aUdSRPQ0vVBxm286+GtVXYwn
         24ZnVUBjx1MbEbOEjZC0MjP1MlH7WzAyYbGD6f6eDSkSHI0/9bqH4PuGRHyk90ewVgv4
         4z3g==
X-Gm-Message-State: AOJu0Yx6jqSCmHY3N4eCvNuF/2B/nqJJ/tYPHdABT/Iyxg8RUpHUqEqh
	JpLiknprJMLHD6Opnp2jVhWFNomRBo4ahWhmMXoip/ZLZK8T8/XNoTbutVsDuk8ci29Qz8vET6Z
	xUJqoig==
X-Google-Smtp-Source: AGHT+IEYma5Tgh82jGLGfJfLfmhoqHyeRAhaK0BUFIBNQaa0nt6VPuBWzXcFJlUAx1BFZPkgbXKo0snHV+0=
X-Received: from pjd5.prod.google.com ([2002:a17:90b:54c5:b0:325:8ff:2ad])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5787:b0:30a:4874:5397
 with SMTP id 98e67ed59e1d1-32515ef215amr21922120a91.9.1756253134805; Tue, 26
 Aug 2025 17:05:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 26 Aug 2025 17:05:16 -0700
In-Reply-To: <20250827000522.4022426-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250827000522.4022426-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.268.g9569e192d0-goog
Message-ID: <20250827000522.4022426-7-seanjc@google.com>
Subject: [RFC PATCH 06/12] KVM: TDX: Return -EIO, not -EINVAL, on a
 KVM_BUG_ON() condition
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"

Return -EIO when a KVM_BUG_ON() is tripped, as KVM's ABI is to return -EIO
when a VM has been killed due to a KVM bug, not -EINVAL.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 9fb6e5f02cc9..ef4ffcad131f 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1624,7 +1624,7 @@ static int tdx_mem_page_record_premap_cnt(struct kvm *kvm, gfn_t gfn,
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 
 	if (KVM_BUG_ON(kvm->arch.pre_fault_allowed, kvm))
-		return -EINVAL;
+		return -EIO;
 
 	/* nr_premapped will be decreased when tdh_mem_page_add() is called. */
 	atomic64_inc(&kvm_tdx->nr_premapped);
@@ -1638,7 +1638,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 
 	/* TODO: handle large pages. */
 	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
-		return -EINVAL;
+		return -EIO;
 
 	/*
 	 * Read 'pre_fault_allowed' before 'kvm_tdx->state'; see matching
@@ -1849,7 +1849,7 @@ static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
 	 * and slot move/deletion.
 	 */
 	if (KVM_BUG_ON(is_hkid_assigned(kvm_tdx), kvm))
-		return -EINVAL;
+		return -EIO;
 
 	/*
 	 * The HKID assigned to this TD was already freed and cache was
@@ -1870,7 +1870,7 @@ static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	 * there can't be anything populated in the private EPT.
 	 */
 	if (KVM_BUG_ON(!is_hkid_assigned(to_kvm_tdx(kvm)), kvm))
-		return -EINVAL;
+		return -EIO;
 
 	ret = tdx_sept_zap_private_spte(kvm, gfn, level, page);
 	if (ret <= 0)
-- 
2.51.0.268.g9569e192d0-goog


