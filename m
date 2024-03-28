Return-Path: <kvm+bounces-12931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B3B588F55E
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 03:29:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DDC421F28BD3
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 02:29:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85C5A2E635;
	Thu, 28 Mar 2024 02:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rhk42HML"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9022575F
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 02:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711592941; cv=none; b=rZTO4K0HD2gp9CFdreuQuXCQu9YVeJIVlS3Xzjie1z8SKYeVqIlUA/xwd5nwaOTTLZxfKmqMqWBYEX5XeTRVwyAsEyQ/pXnaV5hm75Ycm4LH9fpKYADefonggLog5WBh+P0FuGd8M8NCAmVvXXVUQrPeZ+qE+VZkZCLjDCCm660=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711592941; c=relaxed/simple;
	bh=qJqf+gspYBFRI2K5imH74xBgzF2f9aynWHZqrtIDj+k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Opp+V0cfMfO44mbCNAgc75KMf7mI2VCLVwUDETxCwyr8ASL76TEPs2Jda1wfHtxmDHx+uuMZnlX8g/x2u0RqmZaSeyDqnI1yAZrzUd8olDd0mFs3WU0xsQ49EaVevjVTiPd1+9nzvoKPqwJtBOj/dUa7DJyNQr18ZAWESgoBTx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rhk42HML; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dcd94cc48a1so748919276.3
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 19:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711592938; x=1712197738; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/QmOyqM5X2MNASCMJ2dyKBKMwyn+XBPI/URXs6ak0lY=;
        b=rhk42HMLIfXvjMyIuNQ1KAsmWHS2F3VZ7xM529MKMOc9qjyuoKjr/XOmBBvR6KXvjF
         NNpwNIpqhFCDVoBJ4Uzi5Rl4v0/HkoGaFpHj03VUpDhIpNOfNcQ+dhzYWTAcCbJYlUvX
         I00+UsIUkDjVQaLkEGkIRVzwt49HorrgRtBvaRcjfbH4EPU5HN0MmVOIliFaYmzSLIYe
         03Q6602D/PaMndefNu0Q8+km6V/DdxctqRDEr5YsGyFhzY2grawQZFXuVgESvadrW1bG
         Q9GEzmI/yKA8T1RdWOUVOHDB+gqiSDnzDz2Y1W3X1s2P/fYBlgB2bWUS3xzV/JDXdECS
         ssbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711592938; x=1712197738;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/QmOyqM5X2MNASCMJ2dyKBKMwyn+XBPI/URXs6ak0lY=;
        b=rebbMBsVH0t6bshESeCv6bXNVry7uieWj8YZlQA4mAwrMIZxxxgkX7cniN6iMplCV7
         uTVWWYsgF5eIqyvI8iymaOjfCj1myKBvrrt2CAKQy5i4w1eG0yi8yDz01rCVTuoXyFD+
         CjPO2QetXOy7pBckVzpxiLM6QWQa2KKZDJtVNYU1/YLpaIgbg4aUgo9ynRgRayvxQo7L
         HIp4PyX1BIr+aNR9uT1zqazrIl8bI+tdtftg9VjWfWp10aTLujV4oVvtJt7ArQ7I8j0u
         FyzHTu4zjK7rdhsHteJsl8w+lDYL07zHfiB67v2LLBrtkvlJN98op2vnm6un2WOFpiXz
         x55A==
X-Forwarded-Encrypted: i=1; AJvYcCV4ZU99iEgKvZg/W/s0ZIKRFUPnoCkZtfWWS/E8AyrupDeykv0huz6VGD9Lo0DjjoML65801KB9rQbD1QUE93CbnoKN
X-Gm-Message-State: AOJu0Yx73nlnrUEfJ31y3+LEit4ciJtifD3YX41Mm/BQqXlTMvTW3oH8
	UeKlFebYPbuc0CCA0AjUxRm30IsCPmFQakIQl8a4/cQcgDF2xsgZVSTKH9wj1aMN9D/v9Mk/C1K
	Lj+2W0oT/jwTbWEJMYNabMA==
X-Google-Smtp-Source: AGHT+IG3h7UFptSbhQThXKYXVUxHjXW9GcRNRwfD8DnNx4fzNFxp960mZTVoDNqHvfoMy5v3WIivsTHuarJXGtUe7A==
X-Received: from ctop-sg.c.googlers.com ([fda3:e722:ac3:cc00:4f:4b78:c0a8:1223])
 (user=ackerleytng job=sendgmr) by 2002:a05:6902:2290:b0:dc7:48ce:d17f with
 SMTP id dn16-20020a056902229000b00dc748ced17fmr489931ybb.10.1711592938320;
 Wed, 27 Mar 2024 19:28:58 -0700 (PDT)
Date: Thu, 28 Mar 2024 02:28:51 +0000
In-Reply-To: <20240314232637.2538648-14-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com> <20240314232637.2538648-14-seanjc@google.com>
Message-ID: <diqz7chnm6n0.fsf@ctop-sg.c.googlers.com>
Subject: Re: [PATCH 13/18] KVM: selftests: Drop superfluous switch() on
 vm->mode in vcpu_init_sregs()
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

> Replace the switch statement on vm->mode in x86's vcpu_init_sregs()'s with
> a simple assert that the VM has a 48-bit virtual address space.  A switch
> statement is both overkill and misleading, as the existing code incorrectly
> implies that VMs with LA57 would need different to configuration for the
> LDT, TSS, and flat segments.  In all likelihood, the only difference that
> would be needed for selftests is CR4.LA57 itself.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../selftests/kvm/lib/x86_64/processor.c      | 25 ++++++++-----------
>  1 file changed, 10 insertions(+), 15 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index 8547833ffa26..561c0aa93608 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -555,6 +555,8 @@ static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_sregs sregs;
>  
> +	TEST_ASSERT_EQ(vm->mode, VM_MODE_PXXV48_4K);
> +
>  	/* Set mode specific system register values. */
>  	vcpu_sregs_get(vcpu, &sregs);
>  
> @@ -562,22 +564,15 @@ static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
>  
>  	kvm_setup_gdt(vm, &sregs.gdt);
>  
> -	switch (vm->mode) {
> -	case VM_MODE_PXXV48_4K:
> -		sregs.cr0 = X86_CR0_PE | X86_CR0_NE | X86_CR0_PG;
> -		sregs.cr4 |= X86_CR4_PAE | X86_CR4_OSFXSR;
> -		sregs.efer |= (EFER_LME | EFER_LMA | EFER_NX);
> +	sregs.cr0 = X86_CR0_PE | X86_CR0_NE | X86_CR0_PG;
> +	sregs.cr4 |= X86_CR4_PAE | X86_CR4_OSFXSR;
> +	sregs.efer |= (EFER_LME | EFER_LMA | EFER_NX);
>  
> -		kvm_seg_set_unusable(&sregs.ldt);
> -		kvm_seg_set_kernel_code_64bit(vm, DEFAULT_CODE_SELECTOR, &sregs.cs);
> -		kvm_seg_set_kernel_data_64bit(vm, DEFAULT_DATA_SELECTOR, &sregs.ds);
> -		kvm_seg_set_kernel_data_64bit(vm, DEFAULT_DATA_SELECTOR, &sregs.es);
> -		kvm_setup_tss_64bit(vm, &sregs.tr, 0x18);
> -		break;
> -
> -	default:
> -		TEST_FAIL("Unknown guest mode, mode: 0x%x", vm->mode);
> -	}
> +	kvm_seg_set_unusable(&sregs.ldt);
> +	kvm_seg_set_kernel_code_64bit(vm, DEFAULT_CODE_SELECTOR, &sregs.cs);
> +	kvm_seg_set_kernel_data_64bit(vm, DEFAULT_DATA_SELECTOR, &sregs.ds);
> +	kvm_seg_set_kernel_data_64bit(vm, DEFAULT_DATA_SELECTOR, &sregs.es);
> +	kvm_setup_tss_64bit(vm, &sregs.tr, 0x18);
>  
>  	sregs.cr3 = vm->pgd;
>  	vcpu_sregs_set(vcpu, &sregs);
> -- 
> 2.44.0.291.gc1ea87d7ee-goog

Reviewed-by: Ackerley Tng <ackerleytng@google.com>

