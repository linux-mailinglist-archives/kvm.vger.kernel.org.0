Return-Path: <kvm+bounces-23793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 85E1A94D7AA
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 21:49:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 333A21F226FA
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 19:49:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 483A219ADA6;
	Fri,  9 Aug 2024 19:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tDvNCmaS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB07168498
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 19:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723232656; cv=none; b=TDHpDIDP4d/u1nk7iyhWgPmkEzivn/c42nHPWUXTSRoZHkqrU7U939DjimEuHzMTbVm+uGAkO3XMsM6rMNvjjFAd6TAaUsLzq9hAI3wgOQWq8mvfHnw+YVzWyeDA57iIOkkAwWDAmc356gG5++FRDoxcSgZkUGGLy0yip0GyvNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723232656; c=relaxed/simple;
	bh=lGLMFgBOB+zT1nvZAyf/Zc7DkG5GaKVPXMH41Wm07lY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qayJVZY8a9GtCSVeUY8R74Lyrzoh68iJA8JaVgdZozGe1OkNmnSwdsDk0499a83LTA2RYnQd/Y91c6X/8f8sErOq2zmR3kk3t3PUw3gR3/pA4macwrs93rGMPO9UNLgeiNj+FreNZg35e2b4icFqjW0pk/WSArx3TWCLQ1DhcMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tDvNCmaS; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-200618d71dfso20777805ad.1
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 12:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723232654; x=1723837454; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=gQyjT/J4Ba5hX1ofSr3HGlFYc34S1qyVyBiZGiETo24=;
        b=tDvNCmaSDyqOauFuB0GWJbupGiwGO8rmxX2bpgQzlrI5g57Kcf7X1Faa8FSlpolcLL
         GvFtAEyKjHolXIqtxftBtftG/Z+k8t1KRJE42VhaKYK4Jw7866V0YIpmVGdSRHR5Fi3I
         SsiE9MshFRX+GuDK4ZoVsRyj48km10uh7kVg/juZWCCgbyxhWzWg2+HBXOfOIHA0Up4n
         aXYMr6EBW5K7GwI2+fXxrE70TbcG83xrjQdqxh0I3sAMqPqDuxEsgEZf/gf0jNT+bwEl
         M7p/NEh1zNOc3mC3UwznIb5eBLgT3UEDUkzeogRIHbQB0EC4A+I/swdOwWHZe1cIDi3K
         V4aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723232654; x=1723837454;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gQyjT/J4Ba5hX1ofSr3HGlFYc34S1qyVyBiZGiETo24=;
        b=cZ2BnPxzpC+C2RoiyZ81tu8SC7/cqJ1x6m6+AU06U4psKouswGeUttjZjRj71deojN
         PG+WSfQt87Ltyp2a30Z5NL50nhwGQbD34FY2HW+eLNLYpcI6czAqAA/x3fpO9zNjA61K
         m9dmCv1YfZ/++TUOsvmS4Fyez8cr9vF2Kg16JJjEQcIdj3aA6v13uTW6V4mUwtMXYNX/
         aIUr/XN0uESP02pV+K33x6Y44FELexnwa9P6mETyHlWSmY/GrlPxhvMI3dcFYrPruzUe
         OqPlk68mO8vbOtJMZ95dZ7lqDV+LK9MCkBE+DvqJJM8iXBoMRlShMgvbY8W3hysQ9I5w
         quRQ==
X-Gm-Message-State: AOJu0Yyj3Gd30LSOcOCAUY426uACy/bGFZOVCI2+83XXG72tJ8DwMhkN
	4Olnmev7Hw5LVCU3mO6qAT355zoXQyn4qcgzai/tLP2tnvD22TOjY4j1MMCtwruE6QcxdQf82XJ
	igw==
X-Google-Smtp-Source: AGHT+IE7aWrPpp/r00UqCmma5DjJiz0mB/4c0ahEJTDpFl71+olIXEHExH9+iNKK22JWV2AmgsyXWas3vJg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f689:b0:1fa:1a78:b5bc with SMTP id
 d9443c01a7336-200ae2a6d55mr1531575ad.0.1723232654489; Fri, 09 Aug 2024
 12:44:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Aug 2024 12:43:30 -0700
In-Reply-To: <20240809194335.1726916-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809194335.1726916-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809194335.1726916-19-seanjc@google.com>
Subject: [PATCH 18/22] KVM: x86/mmu: Use KVM_PAGES_PER_HPAGE() instead of an
 open coded equivalent
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Use KVM_PAGES_PER_HPAGE() instead of open coding equivalent logic that is
anything but obvious.

No functional change intended, and verified by compiling with the below
assertions:

        BUILD_BUG_ON((1UL << KVM_HPAGE_GFN_SHIFT(PG_LEVEL_4K)) !=
                      KVM_PAGES_PER_HPAGE(PG_LEVEL_4K));

        BUILD_BUG_ON((1UL << KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M)) !=
                      KVM_PAGES_PER_HPAGE(PG_LEVEL_2M));

        BUILD_BUG_ON((1UL << KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G)) !=
                      KVM_PAGES_PER_HPAGE(PG_LEVEL_1G));

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 49c1f6cc1526..8ca7f51c2da3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1499,7 +1499,7 @@ static bool slot_rmap_walk_okay(struct slot_rmap_walk_iterator *iterator)
 static void slot_rmap_walk_next(struct slot_rmap_walk_iterator *iterator)
 {
 	while (++iterator->rmap <= iterator->end_rmap) {
-		iterator->gfn += (1UL << KVM_HPAGE_GFN_SHIFT(iterator->level));
+		iterator->gfn += KVM_PAGES_PER_HPAGE(iterator->level);
 
 		if (iterator->rmap->val)
 			return;
-- 
2.46.0.76.ge559c4bf1a-goog


