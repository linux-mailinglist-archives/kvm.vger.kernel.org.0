Return-Path: <kvm+bounces-22376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B942393DB64
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 01:57:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CFC5B1C20B98
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 23:57:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02A5116E895;
	Fri, 26 Jul 2024 23:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cpZRhfLd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF92161915
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722037986; cv=none; b=kEi+8ejyLf/942Fz0cAMcb4vh3Jy7it0ewhp8qNpUmUK8w5aPXRJ6k40Es/f6ZANo3fnkQAum0u4+z9XobkIhEDlHzYphqYKZUemMR5qCREdKmGIMOWpVSFjkCMn0yqdCg/1ZIsIi0zuAwtg+vI9d5iT3+/CUcCSqoR6PXufWm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722037986; c=relaxed/simple;
	bh=izT0ZHXrcrHipMlKscBt522ZpbrYe6ZS+CksnjxIp6E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JpCPQIHbf/0wkobPohwcGOre2OxZvRlqWjhYHK29dKY77BGtUL7gHHXiTRwlo1qQWUcEXBU1NeHF0LeTs9hrkU4Gmgz9r9rXe4oKNl3JU4vT50YJ8fQnqyP95gdPMvC4MR3PX/cSSv8ZChMFRy0eRh7ORcq3ek99pE7L+r3pM44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cpZRhfLd; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fb116ff8bfso14436275ad.0
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722037984; x=1722642784; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=G8vTlhvtYFVN9mhfz5x+cQCHJ6x1sNjhm2Vdu8bZ6Vo=;
        b=cpZRhfLd+3Ycs0GZk2KtEJ2X+UfQgIiXNHCsUGYj8voK7P1x4QTfARQbypDB6ymh3w
         lt59ko/N7fug9ZcvjZE2ygnMPn6qVbp79QUvelIIRVTuJPACyO18/0QP6hFlRp616C9Z
         DzXzOf3OG0oqBOCOTeDRqTRhpBghqwOiLzD+VIe1q7OqTbE1+gHjHigBFsVMDzU0mVQJ
         gILPZpDPfLv+jecLk78p4QxjM3IYDC/OAB5F0pOzPp9Yov0UpufcSagEZdp2LFJBZJkw
         YejtYmgMRK5vqtbZ7msWVLkE+HVYZILqb7ldtqtuGovSCoCd+VRTUnQ4meAn6p0LdH41
         +oeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722037984; x=1722642784;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G8vTlhvtYFVN9mhfz5x+cQCHJ6x1sNjhm2Vdu8bZ6Vo=;
        b=XDf7J7tfj9oobkWDRFPoVCRc5d0LZ2FiXqOqU8dOXtDFCPyL8RKS+tw5E6F1CdP9Y9
         wE6cMdf3YVqsCaeh9n3Jv3cNlEJzq95QUbBvwU4XPS4eWCVJZoWjpl5h5N1vjORdNgo4
         dsttW0h7ad4YvFJvo7bllRDQFG8wAeeM/wOFfAwP+wUP3FZGds8u7yQcBKlHcZP3cbjn
         LVSIszb+tm1/c45GYGVfH4gA5wzYcWE79eF5eSp0iXPlw7YGGQ/6KITbGksOEF1piPRT
         BNzbNiah0fOKsqr7LZr7GdI4wusMmM7f820jC2PuHMpd2Jxwu20b6EzBbpw0XFbBzLHs
         45pg==
X-Gm-Message-State: AOJu0Yzd/WKgkwypuVF5C2iMheHXqtwl6FIXWsmeGsmUFoeNRQzABwmw
	p5IaoHn0Sr7PpiS0A+1ilsAUmuEU7+xHjnkghJD4L6Ssrs1z3GJpVfZEw/KYQC5zQfHMQzBGYVq
	mSw==
X-Google-Smtp-Source: AGHT+IGcvEjw3oRLgbDLJZa9I5d4JQMYDdZeA/FUbXpEzYyt5G6Xd+JdRMAKGNKsfMlLtXc62VqHMV40c8I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:234e:b0:1f6:2964:17b8 with SMTP id
 d9443c01a7336-1ff0492c71fmr137005ad.10.1722037983933; Fri, 26 Jul 2024
 16:53:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:22 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-14-seanjc@google.com>
Subject: [PATCH v12 13/84] KVM: Annotate that all paths in hva_to_pfn() might sleep
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Now that hva_to_pfn() no longer supports being called in atomic context,
move the might_sleep() annotation from hva_to_pfn_slow() to hva_to_pfn().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 84c73b4fc804..03af1a0090b1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2807,8 +2807,6 @@ static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
 	struct page *page;
 	int npages;
 
-	might_sleep();
-
 	if (writable)
 		*writable = write_fault;
 
@@ -2947,6 +2945,8 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool interruptible, bool *async,
 	kvm_pfn_t pfn;
 	int npages, r;
 
+	might_sleep();
+
 	if (hva_to_pfn_fast(addr, write_fault, writable, &pfn))
 		return pfn;
 
-- 
2.46.0.rc1.232.g9752f9e123-goog


