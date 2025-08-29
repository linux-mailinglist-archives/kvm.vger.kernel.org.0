Return-Path: <kvm+bounces-56211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0212FB3AED4
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 02:08:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BD0EE7AA0C4
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 00:06:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA9181E1A3B;
	Fri, 29 Aug 2025 00:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yCd7pOGw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCAC11A8412
	for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 00:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756425995; cv=none; b=VfYB08Frl7N8G1DuaxL7qqOv8QxEBJm6kBlIDVlC97PLaBSE5pLihUq3wutmo9hGMgetIkBGcxtqBjSeo47YPmiXjlczGB6PYKA83TJo1x4zvQ8Dw1sZRpylvA9YO1hzFtoHMyDWVS9tljGzV7eV18X3ziMzii4nsL9eU8IOeqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756425995; c=relaxed/simple;
	bh=guMBlrm/rcFiyVpqt0hr4LlDYx3tQGzdjshtf5uFvKE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=C0DoPkpRItVxxAF34WCHbKX123KhiaIH/dlpwJoM4tx7P+hlx/fEAySQXUbiYA+YVtQY7KoGycc79h4Ud5RmD7O9vIX7a0zysQjbp91MLIkRwTOlHWMQ41P/QI6vCj0JS/Kkvij/8LDon6ep2j2a6AIk05yLbTvYH5gZIAH5o6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yCd7pOGw; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-771e4a8b533so1434121b3a.3
        for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 17:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756425992; x=1757030792; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pc+C5r9UxosSdMvNvv24ZE703L5ZdmGhUK9UzcuK6dE=;
        b=yCd7pOGwWQVHc3T8jDXWjaOQEvGvz2haegZuBWqdzMNHUqizvtOYi9EmzkRDU4U0lH
         bvzfB7EwvnCSzREPtP4YRB8DHa20BeDiQBtkhbAzJem1hMh9xAGpqgWAJJ+a3XyjNhpr
         Abc6IPZAKoJOQdiJkdiNPsNz0i09/ArKyYPT3UP1mBAIvzJyXJKbxP0pFVDPE2ZSghIP
         IZj0hZ1jpafRXfBBHtSfPHz0WORJBs5i1RTs051wIFQ22mWQRUy69sTP7YLM3Zak/nP6
         WlWdiC1gBCOCmPHodNFHqfn6bRfLmA19SvKX0v7u8zz9yNZvwceIcyTW5j67fWeBxdHE
         i9Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756425992; x=1757030792;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pc+C5r9UxosSdMvNvv24ZE703L5ZdmGhUK9UzcuK6dE=;
        b=YqKzHp39ot5RhmY0qUj9jwjdiLFrFgePxQCTB+NLAMO+E/ZjFybraTIqk4M8EjnQdA
         z2iLnPMvHbuSAlq4j0hQIN8v6o0lhFb2pxqpLHMWtvz6aLJ1uSuCsMvDvBRi3IlpLOIT
         UklJhWxJDVQr3gnQQBY26BENzluHQKcNC5OcU0DNZxfOxgUiCWsItmbSC6L2xMbtSYqn
         eWPL08J7TIgeixw14UJbpn7c9QuFkwamDlvEpmIhph/0D5A4+7tkYTAfxXsBTXK9w2TG
         qQ/Icy2aVijtrc0LLJQzRP+jT15lgXSXZ2w8Uzae4NEJ9d87c+EgeNKSkMJRWlca7I/h
         8x6Q==
X-Gm-Message-State: AOJu0Yyk6P2opr9LNB0YiccWaJyLEVTuBjZoGQzpjbYYOmIBl1kSDVUH
	qrBcL5GBNFoOAcb+/0z4Ftazlh6NeBH6j5YWKoTM1fnoaI7C/TkPDT+khN/k02I0do4+BQmEp1B
	xPCBtFw==
X-Google-Smtp-Source: AGHT+IGsQEGpqIkG4palZicWIZvUBh20hOQat16whhSvJD3x6nNIGewZDiu5LE2a2PmQKQicnX6o2AzYyqk=
X-Received: from pfbca20.prod.google.com ([2002:a05:6a00:4194:b0:76c:4298:869f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:88b:b0:749:bc7:1577
 with SMTP id d2e1a72fcca58-7702fa4f67emr31500813b3a.9.1756425992004; Thu, 28
 Aug 2025 17:06:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 28 Aug 2025 17:06:06 -0700
In-Reply-To: <20250829000618.351013-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250829000618.351013-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.318.gd7df087d1a-goog
Message-ID: <20250829000618.351013-7-seanjc@google.com>
Subject: [RFC PATCH v2 06/18] KVM: TDX: Return -EIO, not -EINVAL, on a
 KVM_BUG_ON() condition
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Return -EIO when a KVM_BUG_ON() is tripped, as KVM's ABI is to return -EIO
when a VM has been killed due to a KVM bug, not -EINVAL.  Note, many (all?)
of the affected paths never propagate the error code to userspace, i.e.
this is about internal consistency more than anything else.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index f24f8635b433..50a9d81dad53 100644
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
@@ -1661,10 +1661,10 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 
 	/* TODO: handle large pages. */
 	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
-		return -EINVAL;
+		return -EIO;
 
 	if (KVM_BUG_ON(!is_hkid_assigned(kvm_tdx), kvm))
-		return -EINVAL;
+		return -EIO;
 
 	/*
 	 * When zapping private page, write lock is held. So no race condition
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
2.51.0.318.gd7df087d1a-goog


