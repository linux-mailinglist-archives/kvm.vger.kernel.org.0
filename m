Return-Path: <kvm+bounces-21553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AF00192FEFC
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 19:05:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 672E3281DDB
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:05:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88FDA17C23B;
	Fri, 12 Jul 2024 17:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2TVNbVZw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F4817C21A
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 17:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720803698; cv=none; b=t2qnTKccGp7o9pTeGR6VHs7iIuaJCLwhA898Y7tfAyd3u7ZbTwwGtzSxxevtGUHCerdjI8sS/FYpgyKZw2nEyWUxLLsNUPQTuH9m9k4+FVzH7HiJmExDq+enzNLuOO5XsIDMxm7ft0lK8WKlQKPPmAJXRuqmlYhhF4GrtVElymk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720803698; c=relaxed/simple;
	bh=tWN6TTu143KggvbB+U0oNB1aBXCL6xSZoNTP9ZhwMws=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uy1Up8Hga7rLCpg4xEQtU5XWE6EalhYEif5Q/4WBkHESvlCAXC21DclBPEA2Ye5ctUHu3r2Nj6fAVzc9mBBsU8er4ICpUEix+G6ld9h32Qk/pHXvCrIRqN/3+EzT5PQ5XYjf0TsXG5bUWhXLnY5lKIZZOAZtupig4o/lLSoGE7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2TVNbVZw; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3678f832c75so1791366f8f.3
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 10:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720803696; x=1721408496; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wVrvdlJuWkiD+fWXDk/FgNJ7m+hI0zlwjZ1uzkGuBuA=;
        b=2TVNbVZwLPkJRaZKBJjPxXXA10SyuhSb3GYjLyl62vvBnrkmnwrhv2eRrV0n0oHMcZ
         Z+EPcYP+0kmlzENohsivYVchqjeYhrLHRVGBMGmxRjozhpVd/4CAXMOX+tyuVTfjm6iq
         Cl5+bYe8upVb3tTbXaDIa1lU5paqTsYjsinPV13kT5yi9z1bv5BBnpZebaj/MkKOr0bU
         HuT/7zAdQNQt78ioFkP8MwGTzRK2YuE5gRCx6QQPpwiSrG2wrvqeyZd8ShAHqzQ/BQDr
         HZilBQJVUHH6P4MhVfTausRkfZLiD/Udrj9SBfgfmYRKZQqYs+rDU69KMdcdGNGCuiDh
         fkrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720803696; x=1721408496;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wVrvdlJuWkiD+fWXDk/FgNJ7m+hI0zlwjZ1uzkGuBuA=;
        b=HdKwY0n5Z7LuMsdXwOGomMYoUr7gjzYlfYLf9zoJXcGp6kCv6nQuB5jONGcnluPhqI
         dUkuIlUrucz4YzJElWNA2SURe8C13FfPsycPYI1ZPkElJ9A6gD3J9Qg69QYiKdbT+QGL
         OZEWeGywAUTNxvCprHXO+bbr5aGIp3+feDpAJDroZytzdpxe3bdmtyzv5TCJbLMg4nT8
         EY1Msmd7PWF3qQGxKukpFgrYpMyZJy7MlcT328HY49eoenjJihbkSFYaTNWautExH17w
         9IIzqGYL2Kxguw2YHJHzNZmATLZjwCjv/nfhu4IQCpJhOoQXa8tyfF/Y96QpVPcYFWqn
         4xRQ==
X-Forwarded-Encrypted: i=1; AJvYcCUTsg3Mf20PS3gKbU9wp7hh4/bH9z2I7VhZ/9Evhy5ksgU2O532oYpFqc2ghECbqPKJZvKV5GGOBnM2j5sy+UIGaBAl
X-Gm-Message-State: AOJu0Yw8xWXF+EjjIMexOqtofRJW8oCP4cssbcD+G2y+yRzofMfLvNgq
	Anp0wppdM8PcM+dwcQXqj7AFDL65OmQvdVT1QdOx1SCNYXN3CDMB+iJHLlRbrDaFrxKtlZvLbuF
	0LJk7aKTqGg==
X-Google-Smtp-Source: AGHT+IErU4rdmgQiGRDTef2HJjYT1+igKTiETpi6GcIgcGxVKuf8GnSM5HDh2rVJ+wSRQZ9KiIWprZFuMKIHlA==
X-Received: from beeg.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:11db])
 (user=jackmanb job=sendgmr) by 2002:a05:6000:400c:b0:368:5d2:9e5f with SMTP
 id ffacd0b85a97d-36805d29fa3mr5077f8f.0.1720803695788; Fri, 12 Jul 2024
 10:01:35 -0700 (PDT)
Date: Fri, 12 Jul 2024 17:00:33 +0000
In-Reply-To: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
X-Mailer: b4 0.14-dev
Message-ID: <20240712-asi-rfc-24-v1-15-144b319a40d8@google.com>
Subject: [PATCH 15/26] mm: Add __PAGEFLAG_FALSE
From: Brendan Jackman <jackmanb@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alexandre Chartre <alexandre.chartre@oracle.com>, Liran Alon <liran.alon@oracle.com>, 
	Jan Setje-Eilers <jan.setjeeilers@oracle.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, 
	Lorenzo Stoakes <lstoakes@gmail.com>, David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Michal Hocko <mhocko@kernel.org>, Khalid Aziz <khalid.aziz@oracle.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Valentin Schneider <vschneid@redhat.com>, Paul Turner <pjt@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Junaid Shahid <junaids@google.com>, Ofir Weisse <oweisse@google.com>, 
	Yosry Ahmed <yosryahmed@google.com>, Patrick Bellasi <derkling@google.com>, 
	KP Singh <kpsingh@google.com>, Alexandra Sandulescu <aesa@google.com>, 
	Matteo Rizzo <matteorizzo@google.com>, Jann Horn <jannh@google.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	kvm@vger.kernel.org, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"

__PAGEFLAG_FALSE is a non-atomic equivalent of PAGEFLAG_FALSE.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/page-flags.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 4bf1c25fd1dc5..57fa58899a661 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -488,6 +488,10 @@ static inline int Page##uname(const struct page *page) { return 0; }
 FOLIO_SET_FLAG_NOOP(lname)						\
 static inline void SetPage##uname(struct page *page) {  }
 
+#define __SETPAGEFLAG_NOOP(uname, lname)					\
+static inline void __folio_set_##lname(struct folio *folio) { }		\
+static inline void __SetPage##uname(struct page *page) {  }
+
 #define CLEARPAGEFLAG_NOOP(uname, lname)				\
 FOLIO_CLEAR_FLAG_NOOP(lname)						\
 static inline void ClearPage##uname(struct page *page) {  }
@@ -510,6 +514,9 @@ static inline int TestClearPage##uname(struct page *page) { return 0; }
 #define TESTSCFLAG_FALSE(uname, lname)					\
 	TESTSETFLAG_FALSE(uname, lname) TESTCLEARFLAG_FALSE(uname, lname)
 
+#define __PAGEFLAG_FALSE(uname, lname) TESTPAGEFLAG_FALSE(uname, lname)		\
+	__SETPAGEFLAG_NOOP(uname, lname) __CLEARPAGEFLAG_NOOP(uname, lname)
+
 __PAGEFLAG(Locked, locked, PF_NO_TAIL)
 FOLIO_FLAG(waiters, FOLIO_HEAD_PAGE)
 PAGEFLAG(Error, error, PF_NO_TAIL) TESTCLEARFLAG(Error, error, PF_NO_TAIL)

-- 
2.45.2.993.g49e7a77208-goog


