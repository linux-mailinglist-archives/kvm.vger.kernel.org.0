Return-Path: <kvm+bounces-27533-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC353986AA1
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 03:39:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F3EE41C220D8
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 01:39:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50C181AC8B4;
	Thu, 26 Sep 2024 01:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hNHeWhmg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f74.google.com (mail-ua1-f74.google.com [209.85.222.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0072D1714BE
	for <kvm@vger.kernel.org>; Thu, 26 Sep 2024 01:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727314537; cv=none; b=omQLYgM+LQmgPkXFXHYPzXwp8w/eCxBjkBeMGbb02H5Y6SbbznDtMBDrufBP+KxrVQYc6V/AvZ0ZXoAL7vFmHCXVw4S4QVt/7ADKV0GNBaIP2H92wFPm4eiY2XeQMQLh9rbKZH+8C7P1Dquh99LTTcPZUVoWhlE4VzgurDHuzXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727314537; c=relaxed/simple;
	bh=b3hOj3Hs+s10OWkM1ZyjJYJwKJI4XiaxkkuOL7OmSoE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rkX/lusjNVDzOBhMpLp1225NPQFVkYe2IgkoA9E/4YKyNFMjrrCCsCcgGAY+RDfGN17/cC8axVH0ZifKQiBpAnnf6jk6cp44hiONaX4UvwY5pBUuhUEvTeQsYpEfc1MJjyMmvWO6IKMYY/PpUwbJj8ortPleBp0XFoL0QnRJHXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hNHeWhmg; arc=none smtp.client-ip=209.85.222.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-ua1-f74.google.com with SMTP id a1e0cc1a2514c-848ab182357so373674241.0
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 18:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727314535; x=1727919335; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mEOlPh0OL8PB5uPzly3STECymuKs02gkKhKmsw1ZgQM=;
        b=hNHeWhmgLFRQ2/Uc9GTeVXn78ModPOXmrvuJYjSfRKHvFK93P5qrFHPFtd58NC3F4N
         WX6woI2oNEuf213Ih3lQiDxYftnApJVnOFx8g0SOTNNKEHeO6Y6S08EhwKKkucmVIMkv
         ZwqSLx8o5DxCrd1OZbNDh6KKCSEDKpMgS8M3Vu0Vj+Nc33B/JKfgJNgJxtJ6Jssr1Mt7
         nhDzcMRqCj80o+ZKs5ZQgLCrbWPYNz6Q9RfmKjV8aJq7W/u0p4h5JKALmRFtEO3ZY+8Q
         4o/ymmrg5fKH78RE4R2kk32bBvjGDQVr/Tz21wgeF3iVvRQi+1UXnF5aCCDBRyVpZTaZ
         hvsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727314535; x=1727919335;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mEOlPh0OL8PB5uPzly3STECymuKs02gkKhKmsw1ZgQM=;
        b=KRP159nWq+gQ1kfIIbPQwlsYKfg1La8mYKpLLdLyMQAbBbWX6bWykQcquFut1rxl2f
         AkGuCeM1RpLOnHHvT39ChzTPmJ8EETe8hDeKadY2KlAnZyXaDx2Hhd8rPymfFNe9CiJP
         L5IDv9P2x02B3H6EVhF3w/uKtfcKjG0RGRDVqmv6TPKpbw12zK5MoB6l3zufp3wtkViK
         OQDScMiBiybnh4eBsG9vxlbyNF15jLaSYdAOmLBvFZKGedlft//fovzhiRIJijPn58jF
         QiA339qcoX+KiqaN05D/qfgGOuUjBXhOPJI2B3rlcCvkKlGi7DsL6s+dWva/k/L5CpCO
         qOCw==
X-Forwarded-Encrypted: i=1; AJvYcCVktt951uzcROXdceMwPXD3c5Db+wYUhGnnWvEnOM7M5RyqeH9xcWz+X3/7BNqkBJr3WVQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxS4monVCB6Q6Era8XxcLIUJGYXQjtdhz4AD/3GUQ6IprjP0pis
	0ZS0AeaTJ2iJPXHk5kgk6cazWw3hwLAFJxyzuEKeAF1id5douSsxM+lgPEeXBPEghA+XrMJAbF5
	qvzbklz/bSKHetCQWWA==
X-Google-Smtp-Source: AGHT+IEMx7yb7oZJxjUcxiV+ubu09F3MgF2iO9wA9qRkGH/snKIzoGYYivc2BPhRyOg04he4NRTTUUTncXdmo6QX
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:13d:fb22:ac12:a84b])
 (user=jthoughton job=sendgmr) by 2002:ab0:71d3:0:b0:84e:89c5:3bdf with SMTP
 id a1e0cc1a2514c-84e9940fb1bmr4272241.0.1727314534796; Wed, 25 Sep 2024
 18:35:34 -0700 (PDT)
Date: Thu, 26 Sep 2024 01:35:04 +0000
In-Reply-To: <20240926013506.860253-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240926013506.860253-1-jthoughton@google.com>
X-Mailer: git-send-email 2.46.0.792.g87dc391469-goog
Message-ID: <20240926013506.860253-17-jthoughton@google.com>
Subject: [PATCH v7 16/18] KVM: x86/mmu: Enable has_fast_aging
From: James Houghton <jthoughton@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

Because the x86 MMU locklessly implements fast_only versions of
kvm_test_age_gfn and kvm_age_gfn, we can advertise support for
has_fast_aging to allow MGLRU to quickly find better eviction
candidates.

There is one case where the MMU is not 100% accurate: for the shadow
MMU, when A/D bits are not in use, young sptes will never be aged with
the fast_only kvm_age_gfn. In this case, such pages will consistently
appear young, so they will be the least likely eviction candidates.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f47bd88b55e3..1798e3853d27 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7708,6 +7708,8 @@ int kvm_mmu_post_init_vm(struct kvm *kvm)
 {
 	int err;
 
+	kvm->mmu_notifier.has_fast_aging = true;
+
 	if (nx_hugepage_mitigation_hard_disabled)
 		return 0;
 
-- 
2.46.0.792.g87dc391469-goog


