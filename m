Return-Path: <kvm+bounces-12199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A840880876
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 01:16:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8C8441C22403
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 00:16:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D29BA937;
	Wed, 20 Mar 2024 00:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bSroxVNO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DAE65244
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 00:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710893752; cv=none; b=VJHoFDJ+iNGtMGqMBRDghjA/BjDIJZwbNR/yIy5Jd+DAKSQ9Ubg/2UNG+oegbeAAzNzP2pyBNa+egbxa4i3IpJHFA4Soat1TY77uqS4BJ8tKgMkm71NgCq6OLXGw4jK8I1YzGYBe3u6oPy7m555Ywv7YwoBnkZ6vLPcjYddI7Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710893752; c=relaxed/simple;
	bh=w7N5groxenxQwOyx2Bg0o9JgzIKj55+kMVOrUurrk9Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tKeEOTJLknMoRmnSmGr5C8R0+0l8inPBmSz3hCYA6ebHu43EPd1Adkdae1ss8+IJaIoKoutFyAjkBE7uhnfD987An+gvzrGstDGhHSR7nlLVabkSAl/NVX4+bmO0r+7CXu4/S+s8pjywKCmDMMApulW3TdnYPoAlsvKvxufek9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bSroxVNO; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60cc8d4e1a4so117839197b3.3
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 17:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710893750; x=1711498550; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=QwdnnYU5NTwIDpJoKUhQ+ev0BrLDudc5wiCqltwp/lk=;
        b=bSroxVNOMlhRMbm4vIfnBfwwKndEXfOCkPSEclAOu/7jzyqG45JIDH5emZRxcsQJLK
         Vduof3xv6U+bH+X7W+KFKZSj2XqrJjhwaZbplzWkAtYUzjVLwui78jrBzUMgKKczng6F
         hYb8ATjqkUcDQOigMbrKvluoKJmnA5U0Rk0kyn6Ir0BRdXw0kw+KIjVHlbsV6poefeQR
         eL02mPPcKWofZIwUuGHRu6J8FQGKZEyUDBckzAl7Y8peMMmiH7i4HjtM5Ca0nv5YUSmS
         aITDmev19YHOR4ONyWaNghbTbGRbOu0DeyoKKs/0oM8l/1m3vcA0yX3IUjxvx45F/5p7
         aaQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710893750; x=1711498550;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QwdnnYU5NTwIDpJoKUhQ+ev0BrLDudc5wiCqltwp/lk=;
        b=QhnY4Nnj6sH9avPSPAB1hEz0EBkhwmLrOdCF/N23VM+UkCzj+4QgjX/T1ih3/WowNm
         z4mQ4uUg9rfsfHlT0+ZyqHLHpYAZlXGHvI2H8PYROWeSoYqH5lplDLmyWwhhZTFv/A9Y
         uvgfK3ptO1UjL3/SXJ0rFE4FbzwF+hhkh8bwSu/hmJiIi+IvTDX4nLnSkpb7SS2uA6+L
         J3gA6sL0qWuhzBYC4nYciAyy6RC7+5sZYb5Sd2CGefIVuhRhz8QFUsZXCKA88G84DGXA
         7OhElbfZJb9R7UqutH0kRjDHd1FUsy9UxAZhmXx22sv9SH3vwn7rcIh4WpYPYM57zbTn
         5ydw==
X-Gm-Message-State: AOJu0YzLyEQVqhDQlAtV8eQMP1YWEh1XQsLPs+5zPLHt05ZUtewLENCu
	Cru0anCOKl0e/2LNdYy9QaANBI2UlLrh3xdvLJrgpWR+lktO6aaIw1J07TgWVQN+Zy9KQo9cUwl
	Xrg==
X-Google-Smtp-Source: AGHT+IFoMEoUU1bqXVgSJMZ8c63cXq26fjN6lJZWr1OCTaj+JhBJGEp+ggbssXee4pM4Ws29Fac1D1f2DtU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:db01:0:b0:60c:cbdc:48b4 with SMTP id
 d1-20020a0ddb01000000b0060ccbdc48b4mr1115906ywe.3.1710893750386; Tue, 19 Mar
 2024 17:15:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 19 Mar 2024 17:15:42 -0700
In-Reply-To: <20240320001542.3203871-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240320001542.3203871-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240320001542.3203871-4-seanjc@google.com>
Subject: [PATCH 3/3] KVM: Explicitly disallow activatating a gfn_to_pfn_cache
 with INVALID_GPA
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, syzbot+106a4f72b0474e1d1b33@syzkaller.appspotmail.com, 
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Content-Type: text/plain; charset="UTF-8"

Explicit disallow activating a gfn_to_pfn_cache with an error gpa, i.e.
INVALID_GPA, to ensure that KVM doesn't mistake a GPA-based cache for an
HVA-based cache (KVM uses INVALID_GPA as a magic value to differentiate
between GPA-based and HVA-based caches).

WARN if KVM attempts to activate a cache with INVALID_GPA, purely so that
new caches need to at least consider what to do with a "bad" GPA, as all
existing usage of kvm_gpc_activate() guarantees gpa != INVALID_GPA.  I.e.
removing the WARN in the future is completely reasonable if doing so would
yield cleaner/better code overall.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/pfncache.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 91b0e329006b..f618719644e0 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -418,6 +418,13 @@ static int __kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned
 
 int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len)
 {
+	/*
+	 * Explicitly disallow INVALID_GPA so that the magic value can be used
+	 * by KVM to differentiate between GPA-based and HVA-based caches.
+	 */
+	if (WARN_ON_ONCE(kvm_is_error_gpa(gpa)))
+		return -EINVAL;
+
 	return __kvm_gpc_activate(gpc, gpa, KVM_HVA_ERR_BAD, len);
 }
 
-- 
2.44.0.291.gc1ea87d7ee-goog


