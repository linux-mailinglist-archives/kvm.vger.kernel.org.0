Return-Path: <kvm+bounces-22986-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 12D589452CF
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 20:36:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B28D11F24519
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 18:36:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4D7A14D449;
	Thu,  1 Aug 2024 18:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T6f4Ughv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A2E14C5A7
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 18:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722537309; cv=none; b=GL0J2+NYs08aBOkJBSibhszTNfUyGZ2ff4K577O59BpQzPKrDGCOtZhflRu1pzTsDRFG/dqCdcK+z24jtRDndLV5LxjdLMzvy3KRgxn5ajdmUVr03hrst9OW0f5sFkBgo31iZ6grau3Qc2/bVEXnCtJ+PtKVHnxEg0xXKAIXOGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722537309; c=relaxed/simple;
	bh=/XSoRdfaJzNo/ZGf04C230tSmY5GFwai1Y6z9V+ll3s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TbOroBtNPsgZ8kSwXADjqkLE6M6mIUW3icrru3skLkkiXqNX+ukdEkdWy6hIdJPSlZ/h4x9hQFXgLhCmCX1nwCmPwfHgghUQRel4mySgfiIUEOI4p6Fwwt9PrsZUbVVMBLF9cRd7Z7SkkmAChcutOudIJgO3TJhlZ3upQP39ggk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T6f4Ughv; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7104d2cac39so2257873b3a.1
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 11:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722537308; x=1723142108; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=YgfeHTUFXLVGjVFJpfNzwAaN7GsDEU7AXhuO1w5LlJU=;
        b=T6f4UghvEEptu57168f+L/zM2OSsfTUEmq1aYaownOtHbbaFnbOQ8PWU0JuKJgce0H
         9fQZZawMVXL1956CtTaup8jRe66DfJ2jxln5sAhr19titUwv3w2uBWqXPqqVv6dd5WTu
         cGEgRY1qU5xXsf66qMwFiRjqe1LhSabKEpXXdGiP8fkoZFZ/AXnxagDFTf506ChfutbB
         BerF3q22V5B07c89wofMVqoMFo/AZJvDayCRHBYir2P56J1tZ7SoqPkDBHGQY5kJMLAd
         LCfJVXCXpldMdtKUwjNRwX2jOX+xLfvMyHOearGAJAIiUZPadY5Q6Hq2DGw2t2lH8qkY
         Il3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722537308; x=1723142108;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YgfeHTUFXLVGjVFJpfNzwAaN7GsDEU7AXhuO1w5LlJU=;
        b=ZvRRLKxtW8a3hLjznc3wd/Np5uOrsiV/BfCnbP2fGQEy3EQ4bvEWvbVinM/+ATBQed
         f7VudWlQdP0TtdI4HtnwX5qNYR6eYWeoFjVThVrAQ1JU6wNadVUFIca1OPJEkT8a3NNT
         TdYven33xQ1Uvcsevb6Q6QT6hRiyCf2QoyBrbYj4iAETYnd11skriNaUIZcmLCopjE2d
         NtvPhPjOeM1O+I2tRqLng50gbOLgFVsEU8pGEKmF+P0u2AVu7aQQj+gd0eSbnRfGEsGI
         fWLk5yb9/H/a2QrG+FZbQ/peh8ptg8TfCB1XM9zdbjn0BZCkGV6F4x1VbXw1qTsAv7Ma
         dRAQ==
X-Gm-Message-State: AOJu0Yz9jQR9pgdjqC7zX1QaENo6erndNTlT8wOUCi9FqPcEhGyds5L0
	MMCP4CIcvOpCpFYytyY/fFK9slKqk7f0MsZPjfaqFbcg6OHQVLeBXFs/zf2m7kJqs/XK1B3aooe
	Q3A==
X-Google-Smtp-Source: AGHT+IHTWEhjwHtp09vWEbUgtVyznzcr5+x5rCkfOWJrq49bIvfwRkVTlE43qqkCOx+dDWfaukt6/MOxYM0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:949c:b0:705:ca19:2d08 with SMTP id
 d2e1a72fcca58-7106d0ca7camr8792b3a.6.1722537307533; Thu, 01 Aug 2024 11:35:07
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  1 Aug 2024 11:34:50 -0700
In-Reply-To: <20240801183453.57199-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801183453.57199-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240801183453.57199-7-seanjc@google.com>
Subject: [RFC PATCH 6/9] KVM: x86/mmu: Process only valid TDP MMU roots when
 aging a gfn range
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Skip invalid TDP MMU roots when aging a gfn range.  There is zero reason
to process invalid roots, as they by definition hold stale information.
E.g. if a root is invalid because its from a previous memslot generation,
in the unlikely event the root has a SPTE for the gfn, then odds are good
that the gfn=>hva mapping is different, i.e. doesn't map to the hva that
is being aged by the primary MMU.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 2b0fc601d2ce..b358642890e1 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1202,9 +1202,11 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
 
 	/*
 	 * Don't support rescheduling, none of the MMU notifiers that funnel
-	 * into this helper allow blocking; it'd be dead, wasteful code.
+	 * into this helper allow blocking; it'd be dead, wasteful code.  Note,
+	 * this helper must NOT be used to unmap GFNs, as it processes only
+	 * valid roots!
 	 */
-	for_each_tdp_mmu_root(kvm, root, range->slot->as_id) {
+	for_each_valid_tdp_mmu_root(kvm, root, range->slot->as_id) {
 		rcu_read_lock();
 
 		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end)
-- 
2.46.0.rc1.232.g9752f9e123-goog


