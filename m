Return-Path: <kvm+bounces-21561-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46E9892FF0C
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 19:08:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B1D59B23A64
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:08:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3784217DA2D;
	Fri, 12 Jul 2024 17:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1t+bEW6Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FE917DA0E
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 17:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720803722; cv=none; b=ZGjLVYM0MV8ft8f4milqFFUH4xYE2mikTw97USmudlh9giapBdFyfq+c96TAsVBbm3ub1uCz94yn8AQUyRFHBqmfMyCThpE6awDRsjESPOS3/7jZu1qbMVVEkvp02kmXZEGGAh4Ft3Jn6D8HxhQ4Ig6FGNMhLS8UOi9jnNO9oVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720803722; c=relaxed/simple;
	bh=ac71kaw+Ep3tBDBJVMZFqxi1H+z1kJbDT7fCK4NtG0E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=E1geEU/xXLvyCTej3V63zqb1thUvJ7urEVNJwwjfSWUZQKgcHSq8/yWPgFSSl3F0tubDj5iSCaJ+dJm9Q3GloB+QNNYs7Gzn2/70r0ZWagDzKQiYoZVVXX8jHGWTUCzj50N6Z840tmBluewS9gsVvoJLNgf383XacCpImqWN4HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1t+bEW6Q; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc691f1f83aso1235062276.1
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 10:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720803720; x=1721408520; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tumXnPtU8b3obH923+Z5afsvMmdmRsZkkH9VAm+WVDk=;
        b=1t+bEW6Qyoyc0O9Ode7AFDj5wtqGYpCUgVlIQ+QiBlOkwI7f3W36OjVyL6a10yJLK3
         JZok2mIOhw7DCxnIQJm65JYHrjkVck0YELfdc/wgbeJUtOs7N+57A0MH3sPMh2lxxXDs
         oYJAMfv433pyzBiJr8nsysZNBlQPB5ZgQ916fmXMhBN1Fk3uY2OQ/YyymuOef5DoQkKZ
         BWkOe7PIC5iKjD50lAHGIZdw3np4ZkzlyE+wJReeYgkyIxgrOT8TvD/Rwf4+r+LOnlGu
         LbIlM/bFJwuJtASbXkr3cF0pr0ErFDu8MdXzra1UAgGn4YVQ0GGNcnAV99yyZyEr85sB
         UI1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720803720; x=1721408520;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tumXnPtU8b3obH923+Z5afsvMmdmRsZkkH9VAm+WVDk=;
        b=be33gvJumC23WmUDxhVfh2XanpjRuv51UF1PDomWSBuI7S7eEtZqHfs5btSHuzsIwB
         p7iI3OLdxrKkyizi5PhqiWN2V6ZJCTErirWg7sRw/6S/oMJBtztrSt4mK1qP4bUndeas
         VyybdoD5S2MwpFbXdBDINzDxAPSaa1r0XYobGOekhX1nxPeeOYvfFjAJKL+s7GH7K3LL
         cU15z+nLOj37u+sJGtaK/c7RKNLQHVdKo2IiDkhr+VZtRdJVsJR0XrbcqHuMu/7vzaY0
         ru1WkALnH5Nq3e4zNCBJYd2av/IM/85HPiU4VDD3qeaUDnOOHBBO6lCdKmmiKf4JnxyB
         QIcw==
X-Forwarded-Encrypted: i=1; AJvYcCWGG29/prOXEk+U6RnMS05XUuH6ZB6nBoUeG5na2TQqjMGM71nu/pHIV847YfUlkwOfqhYjRjunCWb4NL4BUmD0/Sdj
X-Gm-Message-State: AOJu0YwFqRxVSXjuuv4G+X+71yG3l2TB3YlpF1LJ80Y/Y7Z6+38BCvfL
	9KpVHJvnPY8FiOgo3mGccP9jIKc8jtTUD3v7l5l4h0aXGs+C5US9CrJDUOcq20yhxXfVBN3Q1TR
	b4t3xz9DDRQ==
X-Google-Smtp-Source: AGHT+IEh5KZMBf6CBGJRGFZI0bbM06TYxceB64wgc/tD6lYzumVKZafd3yatQIPYK79nMgLcMRU8yR72H65XJA==
X-Received: from beeg.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:11db])
 (user=jackmanb job=sendgmr) by 2002:a05:6902:1892:b0:e03:3c8c:e80f with SMTP
 id 3f1490d57ef6-e058a86d9bamr152146276.1.1720803720133; Fri, 12 Jul 2024
 10:02:00 -0700 (PDT)
Date: Fri, 12 Jul 2024 17:00:41 +0000
In-Reply-To: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
X-Mailer: b4 0.14-dev
Message-ID: <20240712-asi-rfc-24-v1-23-144b319a40d8@google.com>
Subject: [PATCH 23/26] mm: asi: Stabilize CR3 in switch_mm_irqs_off()
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

An ASI-restricted CR3 is unstable as interrupts can cause ASI-exits.
Although we already unconditionally ASI-exit during context-switch, and
before returning from the VM-run path, it's still possible to reach
switch_mm_irqs_off() in a restricted context, because KVM code updates
static keys, which requires using a temporary mm.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/mm/tlb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 36087d6238e6..a9804274049e 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -534,6 +534,9 @@ void switch_mm_irqs_off(struct mm_struct *unused, struct mm_struct *next,
 	bool need_flush;
 	u16 new_asid;
 
+	/* Stabilize CR3, before reading or writing CR3 */
+	asi_exit();
+
 	/* We don't want flush_tlb_func() to run concurrently with us. */
 	if (IS_ENABLED(CONFIG_PROVE_LOCKING))
 		WARN_ON_ONCE(!irqs_disabled());

-- 
2.45.2.993.g49e7a77208-goog


