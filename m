Return-Path: <kvm+bounces-21549-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 948FC92FEF4
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 19:04:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 470B328286A
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:04:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A198717B4FD;
	Fri, 12 Jul 2024 17:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n5/MBrQ8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2966817B420
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 17:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720803686; cv=none; b=VX68bq4Iaxh5NgVY3YlaMFXIhVlmOoeyauGmHN03TwY5UP6a7f1UvebClw4RiCFE4yvuXGslwberJtGmDrxuxmakNfLp82BLrJjk9tqE1TshRNO9or3grgCp4ILls9tC0wR1ifwhz1VVneGNztq15WzYFGylOLvN185++DORanI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720803686; c=relaxed/simple;
	bh=tmQea9Di7/WAZR/rcHWCtTHIP3bmxSVvEz9ipvVMY+I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aUUoI3Nvs7f4nbTGH1ozeEcTVD7Rk4vVufKE/azvDP6na4udGvKzWmqnWlo7kd3v3lTAyYCGw63CcTIbJqnVpXieXcifHA9CsneQ1yYkSUe+5AiqD3b46MM3vpvoNjBr8k2UIo7zE2KXcqyfLkqLkTdfbK7wnfAkVZcDsZ16mEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n5/MBrQ8; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-426620721c2so15369225e9.2
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 10:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720803684; x=1721408484; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tzyFc6toxGAQrtxbLGqZIE4RB+JOOXOhclq2H8+llZE=;
        b=n5/MBrQ8NNpA/RaOk0E8Oj95aR2bIk/2lc6ePuHi4uBrmx9SsgkDSLIq8MvPJ4b0sH
         +Fp1RwJBKnHWVT2mV9je+DuWL9TG3iLs6FWkK+3pg4Rln5ornjYd+6qF6XDfAnLzWXH+
         +zw1ppScMVdlk2c595Rw/41aLLLsz5J29I8jGYzRoQoKpWaF22rZYC97dsF/nBMlP0zp
         VZYd4wF/4/muZhGrl16FbkT8yExRvhyaHRfxbbxjkfaZ0SseLb+VRzXwSThg0MxXLKkI
         J2bBMeuCo/vJ0NdP2k6E94LGA9EKNUJTTwzJVtTMMMhnuEg1Ir+aGZG0QdPJXmb82583
         AkEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720803684; x=1721408484;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tzyFc6toxGAQrtxbLGqZIE4RB+JOOXOhclq2H8+llZE=;
        b=dsdqXSuE1g2tUL6LDvFFoh0Yv1KddtwP+1LZeIBy5FWc3pQxaWL8WJNXD+zTq0jxqG
         wNHAWi/g/uLGxBoUH+EOtFc1DPz8XjsD6ZXNEfuV/YnQGJximfI0yen5jXZgbXxRonp1
         MZbgey8hq+kLffKyyinZlPgtUaJFkl0uqhdg9hvHyx0awM0mlO37rmAZjk4o2xotZPsH
         Cj/HIYWul7titDwN4j3s6OvIVaC/e56xhNViX7UEu8B3Byx0VNVQnihbEhO7J58UnIN2
         a34fCiihKT0QlOj3BUJVYEA4EUMN8QbkPWc5sbEYoyk4F5ANV7PofIRCiMy5yIOY+8GX
         m1MQ==
X-Forwarded-Encrypted: i=1; AJvYcCVMb9E5nuaVoAg94h24cn6u83ritpmSMFIpkm+qnFVlM0e/cOgcSTfaaNHqioYpE4JOEH8AtZXteG6pIjjwsPgsV9M+
X-Gm-Message-State: AOJu0YziKb+oN+z7tBsdmKtw2k8e5P/y9BvXvwg4ad5Sf2KdjrHvGCyE
	880YewsY2lJs4l6OCGFINqEJdwKoUa8bYNZj+l+FhbI790Crr0eEH3e9l5GopNNAEyRz3GuVqfI
	t+sxSJtg87g==
X-Google-Smtp-Source: AGHT+IEU6XhUTfh8cq6gCvMggnXLFkSt7XlYIzIUi6HAiuQhdPaLLmoiwQpzZ2rTTEjQ37T3mDQb8/UfRpK6jw==
X-Received: from beeg.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:11db])
 (user=jackmanb job=sendgmr) by 2002:a05:600c:4f0e:b0:426:6a73:fb5f with SMTP
 id 5b1f17b1804b1-426708f9ab5mr1904875e9.7.1720803683507; Fri, 12 Jul 2024
 10:01:23 -0700 (PDT)
Date: Fri, 12 Jul 2024 17:00:29 +0000
In-Reply-To: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
X-Mailer: b4 0.14-dev
Message-ID: <20240712-asi-rfc-24-v1-11-144b319a40d8@google.com>
Subject: [PATCH 11/26] mm: asi: ASI page table allocation functions
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

This adds custom allocation and free functions for ASI page tables.

The alloc functions support allocating memory using different GFP
reclaim flags, in order to be able to support non-sensitive allocations
from both standard and atomic contexts. They also install the page
tables locklessly, which makes it slightly simpler to handle
non-sensitive allocations from interrupts/exceptions.

Signed-off-by: Junaid Shahid <junaids@google.com>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/mm/asi.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index 0ba156f879d3..8798aab66748 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -71,6 +71,65 @@ void asi_unregister_class(int index)
 }
 EXPORT_SYMBOL_GPL(asi_unregister_class);
 
+#ifndef mm_inc_nr_p4ds
+#define mm_inc_nr_p4ds(mm)	do {} while (false)
+#endif
+
+#ifndef mm_dec_nr_p4ds
+#define mm_dec_nr_p4ds(mm)	do {} while (false)
+#endif
+
+#define pte_offset		pte_offset_kernel
+
+/*
+ * asi_p4d_alloc, asi_pud_alloc, asi_pmd_alloc, asi_pte_alloc.
+ *
+ * These are like the normal xxx_alloc functions, but:
+ *
+ *  - They use atomic operations instead of taking a spinlock; this allows them
+ *    to be used from interrupts. This is necessary because we use the page
+ *    allocator from interrupts and the page allocator ultimately calls this
+ *    code.
+ *  - They support customizing the allocation flags.
+ *
+ * On the other hand, they do not use the normal page allocation infrastructure,
+ * that means that PTE pages do not have the PageTable type nor the PagePgtable
+ * flag and we don't increment the meminfo stat (NR_PAGETABLE) as they do.
+ */
+static_assert(!IS_ENABLED(CONFIG_PARAVIRT));
+#define DEFINE_ASI_PGTBL_ALLOC(base, level)				\
+__maybe_unused								\
+static level##_t * asi_##level##_alloc(struct asi *asi,			\
+				       base##_t *base, ulong addr,	\
+				       gfp_t flags)			\
+{									\
+	if (unlikely(base##_none(*base))) {				\
+		ulong pgtbl = get_zeroed_page(flags);			\
+		phys_addr_t pgtbl_pa;					\
+									\
+		if (!pgtbl)						\
+			return NULL;					\
+									\
+		pgtbl_pa = __pa(pgtbl);					\
+									\
+		if (cmpxchg((ulong *)base, 0,				\
+			    pgtbl_pa | _PAGE_TABLE) != 0) {		\
+			free_page(pgtbl);				\
+			goto out;					\
+		}							\
+									\
+		mm_inc_nr_##level##s(asi->mm);				\
+	}								\
+out:									\
+	VM_BUG_ON(base##_leaf(*base));					\
+	return level##_offset(base, addr);				\
+}
+
+DEFINE_ASI_PGTBL_ALLOC(pgd, p4d)
+DEFINE_ASI_PGTBL_ALLOC(p4d, pud)
+DEFINE_ASI_PGTBL_ALLOC(pud, pmd)
+DEFINE_ASI_PGTBL_ALLOC(pmd, pte)
+
 void __init asi_check_boottime_disable(void)
 {
 	bool enabled = IS_ENABLED(CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION_DEFAULT_ON);

-- 
2.45.2.993.g49e7a77208-goog


