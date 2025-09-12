Return-Path: <kvm+bounces-57407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B1F19B551FF
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 16:42:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 75135188D410
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 14:39:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C82E13115BE;
	Fri, 12 Sep 2025 14:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="InIRgQGX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D18C12FF69
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 14:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757687877; cv=none; b=JqSCYZP0gH9YJcMqqOGZFGc32lIP6oQcJEyNPQzBJGPmi4QzTnm5gS3Q4VQmvXwsnxk8ehW/41nh95b2hAWqgnaOSEJFjvO4B08PyyWjq+b07sMhyGd76Q5lTEGcizw/42KG7CI7Se/zVoin0Q7ArjxSeePoj6GfNjT8lAISkmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757687877; c=relaxed/simple;
	bh=MXoXYhIAI6PclC+dBNAPePesW/IoQ8aaRQWQp7X2Ri4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Jr5Egq8xPDN71ENtVqXw/wjWlM4odcYQBHJjdLmfjSiTyYpr70LR3GGTeAz5Q4jU2axHRVlMu+Y8vQNPfxStzA3QO8WCVLKZoFosd4PVz/ZXwwkzZe7ecxLl5VOzuUUkbYbNHYnI+3FVrfjfnxzIpFvtAqt9e/SOuUQJb4WJhPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=InIRgQGX; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2490768ee5fso15925965ad.3
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 07:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757687876; x=1758292676; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4ChX4wJYplW5xDrGHdwPeybL6wYetaasFY+ssOzwgo4=;
        b=InIRgQGXxnKdU57VqYOH/IUC0GfImZcpriyi7QaZMt98XVYV40exsoWB92Sd/XPFWz
         MoZPmmnA4YYl14BvzWWSrZpZbFiCS5qIWQyKXF6cjnbPZb2DbhYhrQRNtvgJPQXLp0Qf
         xzrD9eCCcIEHGbI8sVOLuiDNoUg/xerUkhmLuCMFVcLvk1GotpMiZp0c9GVh63635mp4
         AM0cQdt3uVN6ybMHvJR9zC/54vweB9Ac1WoVIDU8r4RwXoBwqiobfq3unbFsRRY5dXE2
         Uf0HUbVhR9x4mmY+ELwenPCQkG/xhm1U3W3PwE+h8LbsW1Go0V+8I8j2WGEMwNL68tFT
         BCPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757687876; x=1758292676;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4ChX4wJYplW5xDrGHdwPeybL6wYetaasFY+ssOzwgo4=;
        b=US2RRf7d+DA2vS23rfVWMG7R2fldR3FFaHbiZvHNys+1h2Z9Vz2mbxwtlgNNZBKBR7
         iPaeRMDhOB+WU4+yR8K21x1cmZ8Wuhxm2uICb7eBtT0OAvxIpRW2C571J46Ez8GN2HyF
         J7zcprJ9ojS0NCrapcJdiZqTZ/sPdhTtUF67bcRSBdrT60FJaMtsza+m+zstfuqRLItn
         U+7cqKIExBbEhOGFLGy3rKXJ5oRL0/J+JwpYIycZsGau7Sb0sPqsHWqejp+/eyHBnzWe
         WfFZJD+dxb7b6MK13C3BxQzOEZI4Vi0Ki5/vg+X8F5DRNMe+phlLd0tf5h6N2OoSlQHd
         NfuQ==
X-Forwarded-Encrypted: i=1; AJvYcCUaNox+F9gCF5Pik2DRF9ctIbIibR0JwfY9dRNrA3DXovMjSocfD22K+pJqNoZnI33SMp4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBzIurt4PM51R5Pz3aM/voysf5zL0JiyVhJi3IXG9k+z5eSFc+
	8GIlKqa64d1Mr41bQs4ytCrYw4hGYr7WIZVcwFg4kdL9c5/9OeFlxQbu9Qk6dpt8MmXQfkfuto8
	J5e5Usg==
X-Google-Smtp-Source: AGHT+IH4qD+Epm+gzLaj7UYu+Wr7KrKt0ZGH9dlBDVZ54WnTlDMtq+Yub+gzUIGlWKmhkE+sQU6AnhJqywA=
X-Received: from pjbst15.prod.google.com ([2002:a17:90b:1fcf:b0:31e:c1fb:dbb2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2ec6:b0:25c:982e:2b22
 with SMTP id d9443c01a7336-25d27134267mr32519415ad.61.1757687875731; Fri, 12
 Sep 2025 07:37:55 -0700 (PDT)
Date: Fri, 12 Sep 2025 07:37:54 -0700
In-Reply-To: <20250626073459.12990-14-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250626073459.12990-1-minipli@grsecurity.net> <20250626073459.12990-14-minipli@grsecurity.net>
Message-ID: <aMQwQnGpNzutdr-q@google.com>
Subject: Re: [kvm-unit-tests PATCH v2 13/13] x86: Avoid top-most page for
 vmalloc on x86-64
From: Sean Christopherson <seanjc@google.com>
To: Mathias Krause <minipli@grsecurity.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Jun 26, 2025, Mathias Krause wrote:
> The x86-64 implementation if setup_mmu() doesn't initialize 'vfree_top'
> and leaves it at its zero-value. This isn't wrong per se, however, it
> leads to odd configurations when the first vmalloc/vmap page gets
> allocated. It'll be the very last page in the virtual address space --
> which is an interesting corner case -- but its boundary will probably
> wrap. It does so, for CET's shadow stack, at least, which loads the
> shadow stack pointer with the base address of the mapped page plus its
> size, i.e. 0xffffffff_fffff000 + 4096, which wraps to 0x0.
> 
> The CPU seems to handle such configurations just fine. However, it feels
> odd to set the shadow stack pointer to "NULL".
> 
> To avoid the wrapping, ignore the top most page by initializing
> 'vfree_top' to just one page below.
> 
> Reviewed-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> ---
> v2:
> - change comment in x86/lam.c too
> 
>  lib/x86/vm.c |  2 ++
>  x86/lam.c    | 10 +++++-----
>  2 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/x86/vm.c b/lib/x86/vm.c
> index 90f73fbb2dfd..27e7bb4004ef 100644
> --- a/lib/x86/vm.c
> +++ b/lib/x86/vm.c
> @@ -191,6 +191,8 @@ void *setup_mmu(phys_addr_t end_of_memory, void *opt_mask)
>          end_of_memory = (1ul << 32);  /* map mmio 1:1 */
>  
>      setup_mmu_range(cr3, 0, end_of_memory);
> +    /* skip the last page for out-of-bound and wrap-around reasons */
> +    init_alloc_vpage((void *)(~(PAGE_SIZE - 1)));

This breaks the eventinj test (leads to SHUTDOWN).  I haven't spent any time
trying to figure out why.

