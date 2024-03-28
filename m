Return-Path: <kvm+bounces-12941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2598C88F587
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 03:51:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CA0D51F2BE83
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 02:51:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B9A22C6B7;
	Thu, 28 Mar 2024 02:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FLwigaMc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3061B2C6A9
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 02:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711594258; cv=none; b=sV7yOW3582qhlynowDWS46mvd4GhSeRJflb8RNEOfJ2XOhZosLygTJLF1mQCJiBP/CWvEhft+9fgRYqf5wf8ufiFsCI4nUmpB1wulrtBuh5sSD2ITaPIm0d3Mvc8CjEsHYhxZkFXGQFhyEy3My57aPqstZKk/76VSqDzxbCTy+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711594258; c=relaxed/simple;
	bh=6kiqhJKQshLo/BjwdEMSoc1e4fwgvGXzMhgJJcB1bNc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Jd6yGD403c2lcT2OYNY8iSN46a7j7mhIkxFrmn4tpWXjGkBJYEF6yZ2JzMZFFt+dweBdc1eGHxbPc+5eQ42bTWjDk2ESpF2seUdxdIBBk7i+FLGBUtttVBh97tJYnFS+t2lvEUTwUUxmDS8GnL6L12sHY+ZmVwMuhsb868eYRnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FLwigaMc; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6b269686aso756583276.1
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 19:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711594256; x=1712199056; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=seKwScTc9wqkrhGrgx5tr+y5GeB++CIZke1OsGxBUZc=;
        b=FLwigaMcsfUuCqo5xC/tWwHVh0IId4RtoR2lUSFapiZL5H1M0rFRVXgrsJdQTSn765
         yTSmvHtIsYv6W1lKvIs4HUN4F/V7xbLK2Mv4aQijvYcWDrOhrCDUdsDB8ZKC7ykHD/+R
         2leiLQjShNywaN/cU2hGuWRs2mWuOqRgGqJH3wTLfj3syxKdrXXUbZvYu5IxRYAuvKYV
         dn6Zqw0sadLat2zKM7xinfO4v2VkLtQoLkxeLahjZjP3EQ43U6OBZWa31AZZ4YJsxElW
         ycGyS46TQxc+v/X/EnqC3vHhRVTiQ+lIwaiSPWNZU67BjzRBC7hCdRnFbNtTvALMtsqL
         EWTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711594256; x=1712199056;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=seKwScTc9wqkrhGrgx5tr+y5GeB++CIZke1OsGxBUZc=;
        b=CNp2i707Cq7gnNVlb/mfrMtC4a1T1XLRUqrGmQoxlG2m6pzXpEhuqsFlULDVe7cEhE
         swxDQn+y0ASMjiDFcRtqngSGm3pEImcEh+ZjL0PQgDMjJjyqTUyRyxD0rJRZwFykK9ts
         L3tPbLLzIGOv15Vi8zqUKzs/Y8WTpNiwVLjQca5ntodhFJ6cf2OQ+z5Uho7ySzMR/po8
         xMs5aX5kc14GfBL17RoAYjoiXvbbh2z79n8mW0z2wVcjPanCVh6496U9HT2VWQxLmFuJ
         Zk+JQDco9rD4uBsHW7GDc8Jyf66dEH3LwUyt37iakVbwB92eVgsmn5rvTuMaPn8nQhuq
         QvWg==
X-Forwarded-Encrypted: i=1; AJvYcCXNqQ3ADDQfZDR3fpd9yoviOdrO7GTaipPc5YHJkgCDo9NwbZuuPQaJlwhpp3wryO2GwRgl9k0ytC7tv1XKUT1ORhdH
X-Gm-Message-State: AOJu0Yw5404e8aaTigLVVRDrDrPdj7dP63GmAkYswF00Y5r/WAx/4MsE
	EtpDq4x2tR4t638KQ9lMR9ar4zOQESbGHQGcqxwelkhBdHdoY936pJswByhLy4myiZwzut8oCLs
	yzLVdBhJ91svh+9v5htShQQ==
X-Google-Smtp-Source: AGHT+IEO9/kWiBlfm+yWQ+WCwdKpSW8LEFVaawt8sTBofKxrZN8NZmXedY9jk9Xhy7bDK1Xf3oVmIhdKSvQRsIc+mA==
X-Received: from ctop-sg.c.googlers.com ([fda3:e722:ac3:cc00:4f:4b78:c0a8:1223])
 (user=ackerleytng job=sendgmr) by 2002:a05:6902:160f:b0:dcc:79ab:e522 with
 SMTP id bw15-20020a056902160f00b00dcc79abe522mr160235ybb.11.1711594255835;
 Wed, 27 Mar 2024 19:50:55 -0700 (PDT)
Date: Thu, 28 Mar 2024 02:50:52 +0000
In-Reply-To: <20240314232637.2538648-16-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com> <20240314232637.2538648-16-seanjc@google.com>
Message-ID: <diqzcyrfkr1v.fsf@ctop-sg.c.googlers.com>
Subject: Re: [PATCH 15/18] KVM: selftests: Allocate x86's TSS at VM creation
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> Allocate x86's per-VM TSS at creation of a non-barebones VM.  Like the
> GDT, the TSS is needed to actually run vCPUs, i.e. every non-barebones VM
> is all but guaranteed to allocate the TSS sooner or later.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/lib/x86_64/processor.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index 5cf845975f66..03b9387a1d2e 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -519,9 +519,6 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
>  static void kvm_setup_tss_64bit(struct kvm_vm *vm, struct kvm_segment *segp,
>  				int selector)
>  {
> -	if (!vm->arch.tss)
> -		vm->arch.tss = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
> -
>  	memset(segp, 0, sizeof(*segp));
>  	segp->base = vm->arch.tss;
>  	segp->limit = 0x67;
> @@ -619,6 +616,8 @@ static void vm_init_descriptor_tables(struct kvm_vm *vm)
>  	vm->arch.gdt = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
>  	vm->arch.idt = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
>  	vm->handlers = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
> +	vm->arch.tss = __vm_vaddr_alloc_page(vm, MEM_REGION_DATA);
> +
>  	/* Handlers have the same address in both address spaces.*/
>  	for (i = 0; i < NUM_INTERRUPTS; i++)
>  		set_idt_entry(vm, i, (unsigned long)(&idt_handlers)[i], 0,
> -- 
> 2.44.0.291.gc1ea87d7ee-goog

Reviewed-by: Ackerley Tng <ackerleytng@google.com>

