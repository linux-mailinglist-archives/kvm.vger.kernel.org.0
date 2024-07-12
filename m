Return-Path: <kvm+bounces-21556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AE5692FF02
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 19:06:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF121285AB1
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:06:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C02E517CA1C;
	Fri, 12 Jul 2024 17:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ikU/AH5i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5253F17C9F8
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 17:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720803708; cv=none; b=Dh/jWmDiapZR30uPe1ze3XiHXFh3qd5MKRzaifpkubDnlBM64miLwtUpktdvKDb67OnN950//ButGbUoy27jy+EXR4/nGdRUlA3M4pIQ9A/K827Bem9Ng6npZ/iGnSa1NEguddi7kCYy3a8/AUGrvm/KNxy26KzQ3zVLvo5fJT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720803708; c=relaxed/simple;
	bh=ZFN3pqUHygYP3u85utcm51QcO4qoDXiBKRc/+5sufdI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bxETCgCsNncPH67qoPJpkgXbphs8gZVYWyqDdT/mB4ii0saBqoZe72kvbWFhASu+UGeJNdm85fRP/KUXhfXhqvbZFMZTmeIlmjl+Iq57FsHZn+s1c8lZHBd/z6+tG9S4YJEPx2PNbYL9u0t2q/Th9z3C3Ha0GnsoQsuQR0G2Qc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ikU/AH5i; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-42725d3ae3eso15363205e9.3
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 10:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720803705; x=1721408505; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9uYrhf+8D7jqi5tPdexW+5CSq/ZRPpRaUw7HFMG3mLc=;
        b=ikU/AH5iybV0aMgJSTtuDJydkFM41C6xEuKrPpd/g2lfNLSUz+gjiUthUYDbADOmlS
         Ni5Icu8CBDSYtGnVZpAlbaa+5q1PuMnipqob5nwbcnBLDC8nLLpYLaijLHjw4dUZ042z
         mUlrawsNcDSh9y4GrAZJxH8X/bVTNxPwREnYOjF5fyMfsp9ts554oWc17QSNomCu3iIL
         HsVB7ZyooBn/+ztu+tSrcfqgh5hzEDsx+hx6u5SxsIFptFwPVM9IVG7vvzgKi18eTe/B
         S1SWdSoXNtjd5djZ+H2EtWx2gnNbdV+8MNT9PkpFtHE2jjrFvy6BP8zuEkI4pFzHYkHo
         +evg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720803705; x=1721408505;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9uYrhf+8D7jqi5tPdexW+5CSq/ZRPpRaUw7HFMG3mLc=;
        b=EOvBFy8hnV9ABADomlfdTLaF8x13ms25zR9LCXCqk8d4qRITSu3GXS5E/3jhU10KYA
         CeAFsUT0Msg5HZ5uAHkSFpWMh4AYJKtgjkPuwTY4ULPBDXF7WfJSHXQIT5tCiNLjBoGC
         lk6vhoQxBA5yRoJkNN4smfKJggudJsnB4faBo2pAHYw8/by8O81a6vL+A9ghY5K+S1ma
         HmMMJDWGFQdecPQAnULZTXtjSRjG4dhAIvmXZuXHK/bhq1GxZVS20hpfk7kwLuc0izwH
         pMglTNqjA8MEVr6uNegrlgN2FTuN394cGIzlMKJ8vPJLdnXxfhI1Ql/iBUgrHbDsmIW6
         5aaw==
X-Forwarded-Encrypted: i=1; AJvYcCXnSrgSWRp3PYZihWKFmpdzNWVzSDhJ8D6rvvTfotXR/oSHSQJ+AeunsNpvKlof13sWRvPwKWJxRymnncxFiTF+PgF3
X-Gm-Message-State: AOJu0YxEhz18+FhfAqkQf0FBFRbxWDW5pZUcQVbuVTJIJ+/HF131fmwL
	AaRRfLZrrMrW89TOdcrGeHVDqb8IFhFvOXGZgoAEqmHsfQl83vKxsCtRtfLJ2aa6V6ImPytWsGF
	K1+SWmaQxZA==
X-Google-Smtp-Source: AGHT+IEAch1YA6Hi8yZ9PqgivQRgArWS9QwTp9vfGmMIf5En6W6fVDOrfLBr4fzHwEnBua+4wRIDTzrg/vklEA==
X-Received: from beeg.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:11db])
 (user=jackmanb job=sendgmr) by 2002:a05:600c:19cc:b0:426:6c7a:3a77 with SMTP
 id 5b1f17b1804b1-426705ced5bmr1906465e9.1.1720803704718; Fri, 12 Jul 2024
 10:01:44 -0700 (PDT)
Date: Fri, 12 Jul 2024 17:00:36 +0000
In-Reply-To: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
X-Mailer: b4 0.14-dev
Message-ID: <20240712-asi-rfc-24-v1-18-144b319a40d8@google.com>
Subject: [PATCH 18/26] mm: asi: Map vmalloc/vmap data as nonsesnitive
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

We add new VM flags for sensitive and global-nonsensitive, parallel to
the corresponding GFP flags.

__get_vm_area_node and friends will default to creating
global-nonsensitive VM areas, and vmap then calls asi_map as necessary.

__vmalloc_node_range has additional logic to check and set defaults for
the sensitivity of the underlying page allocation. It does this via an
initial __set_asi_flags call - note that it then calls
__get_vm_area_node which also calls __set_asi_flags. This second call
is a NOP.

By default, we mark the underlying page allocation as sensitive, even
if the VM area is global-nonsensitive. This is just an optimization to
avoid unnecessary asi_map etc, since presumably most code has no reason
to access vmalloc'd data through the direct map.

There are some details of the GFP-flag/VM-flag interaction that are not
really obvious, for example: what should happen when callers of
__vmalloc explicitly set GFP sensitivity flags? (That function has no VM
flags argument). For the moment let's just not block on that and focus
on adding the infastructure, though.

At the moment, the high-level vmalloc APIs doesn't actually provide a
way to conffigure sensitivity, this commit just adds the infrastructure.
We'll have to decide how to expose this to allocation sites as we
implement more denylist logic. vmap does already allow configuring vm
flags.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/vmalloc.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 7a8daf5afb7c..d14e2f692e42 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3189,6 +3189,7 @@ struct vm_struct *remove_vm_area(const void *addr)
 {
 	struct vmap_area *va;
 	struct vm_struct *vm;
+	unsigned long vm_addr;
 
 	might_sleep();
 
@@ -3200,6 +3201,7 @@ struct vm_struct *remove_vm_area(const void *addr)
 	if (!va || !va->vm)
 		return NULL;
 	vm = va->vm;
+	vm_addr = (unsigned long) READ_ONCE(vm->addr);
 
 	debug_check_no_locks_freed(vm->addr, get_vm_area_size(vm));
 	debug_check_no_obj_freed(vm->addr, get_vm_area_size(vm));
@@ -3331,6 +3333,7 @@ void vfree(const void *addr)
 				addr);
 		return;
 	}
+	asi_unmap(ASI_GLOBAL_NONSENSITIVE, vm->addr, get_vm_area_size(vm));
 
 	if (unlikely(vm->flags & VM_FLUSH_RESET_PERMS))
 		vm_reset_perms(vm);
@@ -3370,12 +3373,14 @@ void vunmap(const void *addr)
 
 	if (!addr)
 		return;
+
 	vm = remove_vm_area(addr);
 	if (unlikely(!vm)) {
 		WARN(1, KERN_ERR "Trying to vunmap() nonexistent vm area (%p)\n",
 				addr);
 		return;
 	}
+	asi_unmap(ASI_GLOBAL_NONSENSITIVE, vm->addr, get_vm_area_size(vm));
 	kfree(vm);
 }
 EXPORT_SYMBOL(vunmap);
@@ -3424,16 +3429,21 @@ void *vmap(struct page **pages, unsigned int count,
 
 	addr = (unsigned long)area->addr;
 	if (vmap_pages_range(addr, addr + size, pgprot_nx(prot),
-				pages, PAGE_SHIFT) < 0) {
-		vunmap(area->addr);
-		return NULL;
-	}
+				pages, PAGE_SHIFT) < 0)
+		goto err;
+
+	if (asi_map(ASI_GLOBAL_NONSENSITIVE, area->addr,
+		    get_vm_area_size(area)))
+		goto err; /* The necessary asi_unmap() is in vunmap. */
 
 	if (flags & VM_MAP_PUT_PAGES) {
 		area->pages = pages;
 		area->nr_pages = count;
 	}
 	return area->addr;
+err:
+	vunmap(area->addr);
+	return NULL;
 }
 EXPORT_SYMBOL(vmap);
 
@@ -3701,6 +3711,10 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 		goto fail;
 	}
 
+	if (asi_map(ASI_GLOBAL_NONSENSITIVE, area->addr,
+		    get_vm_area_size(area)))
+		goto fail; /* The necessary asi_unmap() is in vfree. */
+
 	return area->addr;
 
 fail:
@@ -3780,6 +3794,13 @@ void *__vmalloc_node_range(unsigned long size, unsigned long align,
 		size = ALIGN(real_size, 1UL << shift);
 	}
 
+	/*
+	 * Assume nobody is interested in accessing these pages via the direct
+	 * map, so there's no point in having them in ASI's global-nonsensitive
+	 * physmap, which would just cost us a TLB flush later on.
+	 */
+	gfp_mask |= __GFP_SENSITIVE;
+
 again:
 	area = __get_vm_area_node(real_size, align, shift, VM_ALLOC |
 				  VM_UNINITIALIZED | vm_flags, start, end, node,

-- 
2.45.2.993.g49e7a77208-goog


