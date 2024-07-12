Return-Path: <kvm+bounces-21519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F7FD92FD4E
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:14:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B7FE284997
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 15:14:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EAE4174ED0;
	Fri, 12 Jul 2024 15:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hkHU+PvO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05351741D0
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 15:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720797222; cv=none; b=rWQQF6QDb21n4tSk1XEk/Mk/xuB8bbRRHiW1eLCWbeWit67B6YwHnBj/b2c58pFH0+rdDwxRW8P045SNaFaYkEXQvXUGeqilernY6M0SYMiqaJUFWnawvI78HaQVhxfyhYQRFmNu6u8ySSumP4ENKnPUD52vlkUfmRZhk2DoQgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720797222; c=relaxed/simple;
	bh=FMK1JNQzZMC+LLZ+NnGfOW2CO/G1iLTvC9MBzV8N/ss=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=q07cmBcvCNK5DZK9TV5Q8b4UE9LNCjShw6e21uhBt0j3FOQGs0eU99l3NPCjzS41y4Z5IbVrFuTdB3lrN4VGCX7VPBlJ/iWv3BGy7fRbBcr8R2A/r7l2hAX+tFOLUJ977d78sRaH4xFxBKebe3pGUUorY7YoWOhLLvJRqTTaMlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hkHU+PvO; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e03623b24ddso4051631276.1
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 08:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720797220; x=1721402020; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=uNeBBWCFWkfC6m3nRC4ikAjguGNDe/LUsyASgE65KAs=;
        b=hkHU+PvOezwwEOba4ULpklfsCbN9d+iWkYw9EYM2zfI6lSoxVdZqBU0r5Plo1tuzsP
         YNoWUy2nQTGq/M34PjUj5lnvbRvJov8bz1kIoNksFmUkYRMqGjaPPNQNW9r+Bz5cOvwx
         yY9Sz4xklNaijMBDzta3bVBk8EYxtrN6pgRkKv4Fo3zo7qEOHHMG4u8McwfTpQtML33K
         eCu/ZM4WxWDYizhH4d8NAUaMGLXoZGkDRfobXbBHc2wAZlwDZrPLKHJIy8bD1OW8iwNb
         mQ6P5DOQQfj5oE8/0xzm82WWCDAMYK99WUDqDL1FB4WcsjH5eRjgsB1UoZfOiA9pltf1
         EaLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720797220; x=1721402020;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uNeBBWCFWkfC6m3nRC4ikAjguGNDe/LUsyASgE65KAs=;
        b=oLszM6xFrtf9RC4hdhvhfI7XpxOzQHQ2tC5p9VDqEc/VCktcfE9mWA3GtiIX6tsNaB
         JVeSsloyr8p8Sex3q1yK8xYvUBIF2F05PLxUThYSwRbN6Ppfon+oFjZrsR1oWgeQICL/
         OWte82w4+7aevSDf2wS+bCdpZ6/uF1aWoQDGo3OGHz0k8Z8RXLCq4Gi0xWZbqNDBxU+G
         Sy8YD8tComjDMu78edSNuHUBDNGgKyIZw8R9yaOl/d/qjyDEw/a4uAV1GBAgr/LgmDVS
         irWfIfFVPL/tF6BvbfRSgYloRUMqfbCkeywEmpbcpqSimBe0bg91k83cXssoz2SdbIS4
         58EA==
X-Gm-Message-State: AOJu0Yy4pVJnamqSsOS9dTcBbOQVk4W3tE4izhJq7KKd2mL0qZDikxEi
	R82+YP8vrLad2Ib83j8TohQAmAenbxtwc7tMLjoXIcQki+cYVrnaZh/eUaJv5CL4wNOTyeWOdNC
	afg==
X-Google-Smtp-Source: AGHT+IFb18rrVSrijY3yb9YIXcErdEDiSDk80QlE2yIt+GQ0EP5KOyZY2pb43G390lTTX4jv/Y2p7iSY+m0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:114b:b0:e05:74ca:70ce with SMTP id
 3f1490d57ef6-e0574ca77fbmr435165276.4.1720797219866; Fri, 12 Jul 2024
 08:13:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Jul 2024 08:13:34 -0700
In-Reply-To: <20240712151335.1242633-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240712151335.1242633-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Message-ID: <20240712151335.1242633-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: x86/mmu: Bug the VM if KVM tries to split a
 !hugepage SPTE
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Bug the VM instead of simply warning if KVM tries to split a SPTE that is
non-present or not-huge.  KVM is guaranteed to end up in a broken state as
the callers fully expect a valid SPTE, e.g. the shadow MMU will add an
rmap entry, and all MMUs will account the expected small page.  Returning
'0' is also technically wrong now that SHADOW_NONPRESENT_VALUE exists,
i.e. would cause KVM to create a potential #VE SPTE.

While it would be possible to have the callers gracefully handle failure,
doing so would provide no practical value as the scenario really should be
impossible, while the error handling would add a non-trivial amount of
noise.

Fixes: a3fe5dbda0a4 ("KVM: x86/mmu: Split huge pages mapped by the TDP MMU when dirty logging is enabled")
Cc: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/spte.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index c8fe13217ff7..bc55e3b26045 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -296,11 +296,7 @@ u64 make_huge_page_split_spte(struct kvm *kvm, u64 huge_spte, union kvm_mmu_page
 {
 	u64 child_spte;
 
-	if (WARN_ON_ONCE(!is_shadow_present_pte(huge_spte)))
-		return 0;
-
-	if (WARN_ON_ONCE(!is_large_pte(huge_spte)))
-		return 0;
+	KVM_BUG_ON(!is_shadow_present_pte(huge_spte) || !is_large_pte(huge_spte), kvm);
 
 	child_spte = huge_spte;
 
-- 
2.45.2.993.g49e7a77208-goog


