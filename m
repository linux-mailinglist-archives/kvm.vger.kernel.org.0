Return-Path: <kvm+bounces-28571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F25A99945C
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 23:24:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 177C22849D4
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 21:24:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CD6A1E3786;
	Thu, 10 Oct 2024 21:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M5AA11u9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3C779D2
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 21:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728595453; cv=none; b=fRp4cBHirECBPODgex8IuiMPLZVcbPfF8nBgOstOjBB8povOEurZ/2oiNcIbIL3TJD42ATPPPL40vLoYQiYQ4KBJmdl9XtpWUefmMHb1pxlMoOiejruN1Nlev/m0uT7ssbh9WQtXnUfcVAjljiYbTy3Q8SdOXNtm5iWaSIbiuDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728595453; c=relaxed/simple;
	bh=xI1dEkXaQRPy+Y7NG1ym0bdm9CVIBqjAdXZTdGZXapQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=t6SYoXNdnjoFKPRmMMFtO9dOqgG2Oq1ponlXNxs66Rl49HnTrR6bvyJ/Lh+Hng53i4YRuH2Cau7kywMX6mVoIpJVwjidCNfdyqjL5jGS4qTq4ExHcCpuHzMA1KNkkB54CX1jU2X9S0KAy4Vy76rizsGQfvPWm4I9ISzjd7tKbZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M5AA11u9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728595450;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=TTrbVtOPHPilcmbjskJG9XlxanFpaqz6L16YYJyOAKI=;
	b=M5AA11u959r/vI7Byg3Eu2wmd0419aUTWcdqrmTT5gHhzpXf7AuIYcMwFFt/NmqnxUjjB+
	Sx6Urd8RaOp8AvjBOwXlFbeAIfp+MrX+JKycc3uwbaSu6CiTNDOEmm5zkkssr3CmbH3mwM
	MQ2Kyi2ugVw6kOuBp0zpWrcqK+tk+8k=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-564-4aAtq4-gNviqGcY9w0nMaw-1; Thu, 10 Oct 2024 17:24:09 -0400
X-MC-Unique: 4aAtq4-gNviqGcY9w0nMaw-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a996ae140f9so91747866b.3
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 14:24:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728595448; x=1729200248;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TTrbVtOPHPilcmbjskJG9XlxanFpaqz6L16YYJyOAKI=;
        b=uKkNz5mvfHWgq6JcL32EiKVyjaVpA/DYjNj3o831XCT2jlwPmJpUkoPu2G5ykYuCl8
         iLm/mPUfCXDyfZLsWKVHPWaJDsd5FSoI4pE/qxgmIDaNiad2a80kF78tXWR1Y6MCT5BH
         PtskQMIqQLFN0H5IOqh+JiezOVTjpwRSZmKyRdxty71U4e7E/QP2WQ4cK5P+CyN0ejbL
         6kQ0QXxqrj4wragjBY9Ny3YI6fr9f/eDSZw8oqtt7jAq+W68yPHy1eBG/Xu75vo4c3Zu
         aZ9JotS1xuL42gYo36GjjDpgCSSb8z5ZD8Gt1erBJkxM95Tld30xl+fcB8Ftr0TnzXIV
         o0bQ==
X-Forwarded-Encrypted: i=1; AJvYcCXduZPJb1JWCl+kdqQH4U89TOOVcNupuDFVw9yklVMBhbY8s6pyeXA29hpNq/YlL96US5w=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWwyala61F6aSS4nU5vGiEu9+vJ+BrMxUrzMPJ2r3GAqUTNozP
	NoXTsk5n1zGuy/ueXl2se517iVZXK3l+tFPnciYUkW/EGLbpyUoOMakawU3bQPFNbzOJytxE+Lu
	e53RbZo7/3kd50CbwMyCcFXNiarCjA1emJmNDDA02zpNonFUSAQ==
X-Received: by 2002:a17:907:e2c2:b0:a99:50b8:9a10 with SMTP id a640c23a62f3a-a99b95e5ff5mr26361266b.64.1728595448154;
        Thu, 10 Oct 2024 14:24:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH15rRMAVXsYsvGP3nHpjiqsOwqxS4ttKi4hWbrl20imAxCjoxkwTI5t6kkZa8FMv1uivlQnA==
X-Received: by 2002:a17:907:e2c2:b0:a99:50b8:9a10 with SMTP id a640c23a62f3a-a99b95e5ff5mr26359666b.64.1728595447686;
        Thu, 10 Oct 2024 14:24:07 -0700 (PDT)
Received: from [192.168.10.3] ([151.81.124.37])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-a99a80dc502sm139723466b.146.2024.10.10.14.24.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Oct 2024 14:24:07 -0700 (PDT)
Message-ID: <640d6536-e1b3-4ca8-99f8-676e8905cc3e@redhat.com>
Date: Thu, 10 Oct 2024 23:23:55 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] powerpc/kvm: Fix spinlock member access for PREEMPT_RT
To: Vishal Chourasia <vishalc@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Naveen N Rao <naveen@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <ZwgYXsCDDwsOBZ4a@linux.ibm.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <ZwgYXsCDDwsOBZ4a@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/10/24 20:09, Vishal Chourasia wrote:
> Hi,
> 
> While building the kernel with CONFIG_PREEMPT_RT, I encountered several
> compilation errors in the PowerPC KVM code. The issues appear in
> book3s_hv_rm_mmu.c where it tries to access the 'rlock' member of struct
> spinlock, which doesn't exist in the RT configuration.

How was this tested? I suspect that putting to sleep a task that is 
running in real mode is a huge no-no.  The actual solution would have to 
be to split mmu_lock into a spin_lock and a raw_spin_lock, but that's a 
huge amount of work probably.  I'd just add a "depends on !PPC || 
!KVM_BOOK3S_64_HV" or something like that, to prevent enabling KVM-HV on 
PREEMPT_RT kernels.

Thanks,

Paolo

> arch/powerpc/kvm/book3s_hv_rm_mmu.c:248:32: error: no member named 'rlock' in 'struct spinlock'
>    248 |         arch_spin_lock(&kvm->mmu_lock.rlock.raw_lock);
>        |                         ~~~~~~~~~~~~~ ^
> ./arch/powerpc/include/asm/qspinlock.h:164:45: note: expanded from macro 'arch_spin_lock'
>    164 | #define arch_spin_lock(l)               queued_spin_lock(l)
>        |                                                          ^
> arch/powerpc/kvm/book3s_hv_rm_mmu.c:263:36: error: no member named 'rlock' in 'struct spinlock'
>    263 |                         arch_spin_unlock(&kvm->mmu_lock.rlock.raw_lock);
>        |                                           ~~~~~~~~~~~~~ ^
> ./arch/powerpc/include/asm/qspinlock.h:166:49: note: expanded from macro 'arch_spin_unlock'
>    166 | #define arch_spin_unlock(l)             queued_spin_unlock(l)
>        |                                                            ^
> arch/powerpc/kvm/book3s_hv_rm_mmu.c:277:34: error: no member named 'rlock' in 'struct spinlock'
>    277 |         arch_spin_unlock(&kvm->mmu_lock.rlock.raw_lock);
>        |                           ~~~~~~~~~~~~~ ^
> ./arch/powerpc/include/asm/qspinlock.h:166:49: note: expanded from macro 'arch_spin_unlock'
>    166 | #define arch_spin_unlock(l)             queued_spin_unlock(l)
>        |                                                            ^
> arch/powerpc/kvm/book3s_hv_rm_mmu.c:938:32: error: no member named 'rlock' in 'struct spinlock'
>    938 |         arch_spin_lock(&kvm->mmu_lock.rlock.raw_lock);
>        |                         ~~~~~~~~~~~~~ ^
> ./arch/powerpc/include/asm/qspinlock.h:164:45: note: expanded from macro 'arch_spin_lock'
>    164 | #define arch_spin_lock(l)               queued_spin_lock(l)
>        |                                                          ^
> arch/powerpc/kvm/book3s_hv_rm_mmu.c:950:34: error: no member named 'rlock' in 'struct spinlock'
>    950 |         arch_spin_unlock(&kvm->mmu_lock.rlock.raw_lock);
>        |                           ~~~~~~~~~~~~~ ^
> ./arch/powerpc/include/asm/qspinlock.h:166:49: note: expanded from macro 'arch_spin_unlock'
>    166 | #define arch_spin_unlock(l)             queued_spin_unlock(l)
>        |                                                            ^
> arch/powerpc/kvm/book3s_hv_rm_mmu.c:966:32: error: no member named 'rlock' in 'struct spinlock'
>    966 |         arch_spin_lock(&kvm->mmu_lock.rlock.raw_lock);
>        |                         ~~~~~~~~~~~~~ ^
> ./arch/powerpc/include/asm/qspinlock.h:164:45: note: expanded from macro 'arch_spin_lock'
>    164 | #define arch_spin_lock(l)               queued_spin_lock(l)
>        |                                                          ^
> arch/powerpc/kvm/book3s_hv_rm_mmu.c:981:34: error: no member named 'rlock' in 'struct spinlock'
>    981 |         arch_spin_unlock(&kvm->mmu_lock.rlock.raw_lock);
>        |                           ~~~~~~~~~~~~~ ^
> ./arch/powerpc/include/asm/qspinlock.h:166:49: note: expanded from macro 'arch_spin_unlock'
>    166 | #define arch_spin_unlock(l)             queued_spin_unlock(l)
>        |                                                            ^
> 7 errors generated.
> make[4]: *** [scripts/Makefile.build:229: arch/powerpc/kvm/book3s_hv_rm_mmu.o] Error 1
> make[3]: *** [scripts/Makefile.build:478: arch/powerpc/kvm] Error 2
> make[3]: *** Waiting for unfinished jobs....
> make[2]: *** [scripts/Makefile.build:478: arch/powerpc] Error 2
> make[2]: *** Waiting for unfinished jobs....
> 
> Replace arch_spin_lock/unlock on kvm->mmu_lock.rlock.raw_lock with
> simple spin_lock/unlock on kvm->mmu_lock to fix build errors with
> CONFIG_PREEMPT_RT. The RT configuration changes the spinlock structure,
> removing the rlock member.
> 
> Signed-off-by: Vishal Chourasia <vishalc@linux.ibm.com>
> ---
>   arch/powerpc/kvm/book3s_hv_rm_mmu.c | 14 +++++++-------
>   1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_hv_rm_mmu.c b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
> index 17cb75a127b04..abf1e6de85644 100644
> --- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
> +++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
> @@ -245,7 +245,7 @@ long kvmppc_do_h_enter(struct kvm *kvm, unsigned long flags,
>          /* Translate to host virtual address */
>          hva = __gfn_to_hva_memslot(memslot, gfn);
> 
> -       arch_spin_lock(&kvm->mmu_lock.rlock.raw_lock);
> +       spin_lock(&kvm->mmu_lock);
>          ptep = find_kvm_host_pte(kvm, mmu_seq, hva, &hpage_shift);
>          if (ptep) {
>                  pte_t pte;
> @@ -260,7 +260,7 @@ long kvmppc_do_h_enter(struct kvm *kvm, unsigned long flags,
>                   * to <= host page size, if host is using hugepage
>                   */
>                  if (host_pte_size < psize) {
> -                       arch_spin_unlock(&kvm->mmu_lock.rlock.raw_lock);
> +                       spin_unlock(&kvm->mmu_lock);
>                          return H_PARAMETER;
>                  }
>                  pte = kvmppc_read_update_linux_pte(ptep, writing);
> @@ -274,7 +274,7 @@ long kvmppc_do_h_enter(struct kvm *kvm, unsigned long flags,
>                          pa |= gpa & ~PAGE_MASK;
>                  }
>          }
> -       arch_spin_unlock(&kvm->mmu_lock.rlock.raw_lock);
> +       spin_unlock(&kvm->mmu_lock);
> 
>          ptel &= HPTE_R_KEY | HPTE_R_PP0 | (psize-1);
>          ptel |= pa;
> @@ -935,7 +935,7 @@ static long kvmppc_do_h_page_init_zero(struct kvm_vcpu *vcpu,
>          mmu_seq = kvm->mmu_invalidate_seq;
>          smp_rmb();
> 
> -       arch_spin_lock(&kvm->mmu_lock.rlock.raw_lock);
> +       spin_lock(&kvm->mmu_lock);
> 
>          ret = kvmppc_get_hpa(vcpu, mmu_seq, dest, 1, &pa, &memslot);
>          if (ret != H_SUCCESS)
> @@ -947,7 +947,7 @@ static long kvmppc_do_h_page_init_zero(struct kvm_vcpu *vcpu,
>          kvmppc_update_dirty_map(memslot, dest >> PAGE_SHIFT, PAGE_SIZE);
> 
>   out_unlock:
> -       arch_spin_unlock(&kvm->mmu_lock.rlock.raw_lock);
> +       spin_unlock(&kvm->mmu_lock);
>          return ret;
>   }
> 
> @@ -963,7 +963,7 @@ static long kvmppc_do_h_page_init_copy(struct kvm_vcpu *vcpu,
>          mmu_seq = kvm->mmu_invalidate_seq;
>          smp_rmb();
> 
> -       arch_spin_lock(&kvm->mmu_lock.rlock.raw_lock);
> +       spin_lock(&kvm->mmu_lock);
>          ret = kvmppc_get_hpa(vcpu, mmu_seq, dest, 1, &dest_pa, &dest_memslot);
>          if (ret != H_SUCCESS)
>                  goto out_unlock;
> @@ -978,7 +978,7 @@ static long kvmppc_do_h_page_init_copy(struct kvm_vcpu *vcpu,
>          kvmppc_update_dirty_map(dest_memslot, dest >> PAGE_SHIFT, PAGE_SIZE);
> 
>   out_unlock:
> -       arch_spin_unlock(&kvm->mmu_lock.rlock.raw_lock);
> +       spin_unlock(&kvm->mmu_lock);
>          return ret;
>   }
> 
> --
> 2.46.2
> 
> 


