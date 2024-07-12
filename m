Return-Path: <kvm+bounces-21545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 591F192FEEC
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 19:03:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0DFEE1F2122E
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:03:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8238517A59F;
	Fri, 12 Jul 2024 17:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4FZd6+vY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8C017997D
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 17:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720803674; cv=none; b=N9+OlUtn3xZFUngt1gf3QMYnvukZl1mfTwmOraNzjzIReiUuiX//pFiSgZdse6iBQrvQ/3PDkliFKDbqrjleEwxL8dTsrFeribL5dCTz3HlLU8r2H3n4RRl2ULRtK4zhiE1lQk5c7h0ba1boBGAeEd1a5AYyLU1DqVndZ/ViWo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720803674; c=relaxed/simple;
	bh=/oJj5vwlZeyskk+GmP45ROP1br4fXDWKMm3Wo5pDy64=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bmlQEoi8RvCKCdo0SgHfJrmQDB0kaeMAdTsDEMjotK6uEvwoGLxF9lDDRI08iUmD0cW/JmrTWfHoQBS50jy4JyK8GBeldl+avV+vYOYmX2B2nKpP/wusBISiJsj4LNc67X7tiOu2ADJyQA3ElFrFCSG2jkYXXgiqEHkKoD72qLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4FZd6+vY; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-367987e6ebcso1585640f8f.2
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 10:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720803672; x=1721408472; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HhvK+VsrCDIF0zdCgKI0fd0HHuRdBdA78SeRsMH4q04=;
        b=4FZd6+vYdHNetqPYBVq0OPYSqiH0u4eFWuGqvPgUwr5y2oHbgd1OBwSI0/EGJlafdI
         jT4+AH/lgQe0XE0MoKDXpEx5bEgf6qfZWjvZIhFHsK6qy3PkvPi8vDUP2QPZBkDIqh6r
         uWY1eumCkH+MeDnNc1KjL7zLetrKj7s/YUfHm8NYLPNJq5UVqs4BOVL5oZtyVJ78hcAU
         J5GqG0/OtR8iAj8fesdhbofxo0Wez/hIJpHboOOUqXIXweYtkLbICeOzvZ5vPSFqRnn4
         qY0US9FYSSv2Vf106dkH4M4q2wkgIvzeCXa78ol04YEGW4n4gcv/yI99+uaLlIbQs27p
         dELQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720803672; x=1721408472;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HhvK+VsrCDIF0zdCgKI0fd0HHuRdBdA78SeRsMH4q04=;
        b=sBo5E5IZOarL5oyDYwA41mL7jk4bK5TLHTeyjqSPybVfgTgKmdSz7JzEN6GE99Th4f
         WnGEhOYn+eHdrkVjx3R7f8+LjThZXvfRB9+AZ13rg2tUFnpf2ihTsLW6gAHGb+TtcLhD
         aR1+horNTuw3C0jeyhP96uqnWvu4BNzowvr5hA4SkNQpwb7YenNMv5BCZucCol/1hb97
         0OUSVLb4DOwe6yEiv/FnnzaItpSEjEF8BA9soDFu2mUjMjNnDqufhlL9G+QNmWruBcjS
         1XSKA/BJU9YSpJAuvpES6rm0Ow+YjbqLsLFNqyMWouAiVQOkWNzZonFToMdRvbl4s+Dx
         WSAA==
X-Forwarded-Encrypted: i=1; AJvYcCVJnOZ4nJNuK9jGqixjqhyah/Vp4Uu1TV0uIFaN99ihYaCujfNPQlk5HGos4m6yoyKsH3E1KlQzkNWICcb2sqmkk+ej
X-Gm-Message-State: AOJu0YzYyQlPhbxEvtHmDabHubtD6mM4AtQSqsW3WHlIo15eofETGnxb
	RthmS+1f1BDrWsAwE4awRFtRyqlhamLUu+xeBjoOuZoZ9hDB+3BhUITkNLoFAlxHnAIXAy80g24
	6RxuClPIfaA==
X-Google-Smtp-Source: AGHT+IFAPE6Abc5gQhah4PjzgMavZ5HwflkhPdDu4LbVKDPqBKd9rbMZcjfutEvjASrTYbwEe+XhPDdeyFCaUQ==
X-Received: from beeg.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:11db])
 (user=jackmanb job=sendgmr) by 2002:adf:e988:0:b0:367:9db7:d6d4 with SMTP id
 ffacd0b85a97d-367ceac39c9mr19900f8f.9.1720803671416; Fri, 12 Jul 2024
 10:01:11 -0700 (PDT)
Date: Fri, 12 Jul 2024 17:00:25 +0000
In-Reply-To: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
X-Mailer: b4 0.14-dev
Message-ID: <20240712-asi-rfc-24-v1-7-144b319a40d8@google.com>
Subject: [PATCH 07/26] mm: asi: Switch to unrestricted address space before a
 context switch
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

From: Junaid Shahid <junaids@google.com>

To keep things simpler for the time being, we disallow context switches
within the restricted address space. In the future, we would be able to
relax this limitation for the case of context switches to different
threads within the same process (or to the idle thread and back).

Signed-off-by: Junaid Shahid <junaids@google.com>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 kernel/sched/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7019a40457a6..e65ac22e5a28 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -77,6 +77,7 @@
 #include <asm/irq_regs.h>
 #include <asm/switch_to.h>
 #include <asm/tlb.h>
+#include <asm/asi.h>
 
 #define CREATE_TRACE_POINTS
 #include <linux/sched/rseq_api.h>
@@ -5353,6 +5354,8 @@ static __always_inline struct rq *
 context_switch(struct rq *rq, struct task_struct *prev,
 	       struct task_struct *next, struct rq_flags *rf)
 {
+	asi_exit();
+
 	prepare_task_switch(rq, prev, next);
 
 	/*

-- 
2.45.2.993.g49e7a77208-goog


