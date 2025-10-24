Return-Path: <kvm+bounces-60987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8117C04B8A
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 09:30:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4DE73BCF8F
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 07:30:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2DC92D73A2;
	Fri, 24 Oct 2025 07:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="M3kUpFbe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4AE2D6614
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 07:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761291005; cv=none; b=LVhgxr3d10i106gEoac6etIhb3AKPIoWQL5lmG97db/9wssODKg+kQrTCccHVolk/ubFFUBf9KPYwKEwQydN+5doZ2885+yzeNufesHEJeKlysqHUP0AU7NvWyBP/9YPqsuwnb/37mm/zzgFzDa4eMQcWFZOIkt5aAMDoPFKaCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761291005; c=relaxed/simple;
	bh=FB/iTAvL78eIbIef0wvuAJhxSikt6Cs4D/A/WL4INUY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VY8GrlRiisX79F6E9d0VI1k/qzYLl6g1CyCRexM+6dkhas4yld2bn52BL7Vv2ThQVrThxqDSQefrtF0iztKHMz6z5EfhXtizKbRLXmC4PA5cgUf8NT/umTJEJS2ZZRNdjPLCzkmOWShVCyF8syKLh9wsolv9YO/8A2LUV2uCOgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=M3kUpFbe; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-431d2ca8323so9175825ab.3
        for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 00:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1761291003; x=1761895803; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QeECwYvKn3QP1ga5HQAMgeWC7ylNejyM0v5Sr0Cm2EQ=;
        b=M3kUpFbe625ngjS1ypBrkSodf4LmiVN7PKgTJv/gnuoeD8V/m3nntBkJqZHnl39R98
         HneNf7qSleiK9jGzKOk3xA023rJn/LymZF0MptUWle88bglU4lPaQDphl7iJp9KCf0Zn
         X1HPF91af9Yd+QL7AbOqUirFjCFivXIo8dYnaTVZRUMm8F+gdOtNWQMJoBYKh9dv+tnt
         V6e16wi7iiIV3ge6pw8zccDvU5SEjGdmrCyngW9SgS728O/1PaV96RP+2EFKalFa6Esw
         hS1yguN5g6aNPHhg5WLVOvv0ORVr0Y207oSRAz/tA0esEN+mq4P5rY5DtDnZr3zCpLnN
         xc/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761291003; x=1761895803;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QeECwYvKn3QP1ga5HQAMgeWC7ylNejyM0v5Sr0Cm2EQ=;
        b=noMaH0Lri8ho24wA5HolWpQCvOW4g0JW82TPUIRSffwzZ+PzYutRe396TlBA0k6e5R
         60+tiVgeTdCk6tDrR2sFf7pWKU6lHB1+TkPzrvDs2MezJHAXp6DjRCvUax7WUxDvJjFQ
         8y2HeygHyoVS5RtUeT5QDkkgjnvBn7aAj6WcF9ntNn33uYEJNcQDIkEClqm5RY+8hjgJ
         fTBSh3cXPBzh6SXZ2VVartV0mdicJhJb1c3+rb4h4FbWNUCy0OHaS6wr+3wCdsRIzOW4
         PUN6V49bLkZ/tzKO57CTAnsyYScnnSJNR/JeP5Kt2Ez+tTyQo0G0d4v7qHWyiE2tPHOU
         1upw==
X-Forwarded-Encrypted: i=1; AJvYcCUOGh2iDzzv6Nm3BCHTwLS+7t7mH/Amt1N9W0eYFMQs8raU60VWhRMwh1PzOPy0+ipjg2o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3rJQ3UT8j3DnWYxF6ozthlMB3ERyy0hNHQhPfJd9To19O00W7
	Xq4a+dkTSR2BGaXAvlJlzTiVvrFfO+u3W7uQ3uCUs1JjlHxRpIrYDl0xjZT/hpk4fgtsTATWq9d
	7MaXmQNWZw1VZl8RB0+HdI4+WYhk8Uz8YteCvdEZSdg==
X-Gm-Gg: ASbGncudBWdEpmKeGjetz4URWJca7r7itKPtCGvpN2Q+3tRpFlkBrt5ZQPL8OWSvh1X
	Luc8WETiVgU/EbVnkqQhGMl+LGAtfYzbO2VOdpLeolQPBApM/dyz/cMQJQ3aNWs+9R3wpRCgC8s
	OknAy+JYWWNgZ1t3zycYA6hJGNm3dMNS+b8VSMKzBGIWRGFcUUDVrHcAmu9AGNtrFNnQvkJvoPo
	IAvt/Osc0zRvCSWpbByLMV8TenGTX/74i9kFumplrqaZyLrjTwTf0Icl0xtCi1gvGQFe29cMiuW
	yEZWWCDYiL5IrXU0xg==
X-Google-Smtp-Source: AGHT+IGIrifKfiiRQa/2XZA9cCQCxDOOhKMJD+Ko/sNM4+GGNt9y1f4J0I/KaEUwS5Wnzok7qVC/rqsQNjRaChFrIM0=
X-Received: by 2002:a05:6e02:1947:b0:42d:8bc6:d163 with SMTP id
 e9e14a558f8ab-430c522f3a6mr361200565ab.9.1761291003374; Fri, 24 Oct 2025
 00:30:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251020130801.68356-1-fangyu.yu@linux.alibaba.com>
In-Reply-To: <20251020130801.68356-1-fangyu.yu@linux.alibaba.com>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 24 Oct 2025 12:59:51 +0530
X-Gm-Features: AWmQ_blnTdA3IFCP2Lj2bbMBWo7LdsRpDZqjAY90yJsReH08LO8cALRDcjSPJO0
Message-ID: <CAAhSdy1fCCdciZLqmoeWDG_QoOHDi9j0_ZZKYkpGJmWrf14Q-g@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Remove automatic I/O mapping for VM_PFNMAP
To: fangyu.yu@linux.alibaba.com
Cc: atish.patra@linux.dev, pjw@kernel.org, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, alex@ghiti.fr, pbonzini@redhat.com, 
	jiangyifei@huawei.com, guoren@kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 20, 2025 at 6:38=E2=80=AFPM <fangyu.yu@linux.alibaba.com> wrote=
:
>
> From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>
> As of commit aac6db75a9fc ("vfio/pci: Use unmap_mapping_range()"),
> vm_pgoff may no longer guaranteed to hold the PFN for VM_PFNMAP
> regions. Using vma->vm_pgoff to derive the HPA here may therefore
> produce incorrect mappings.
>
> Instead, I/O mappings for such regions can be established on-demand
> during g-stage page faults, making the upfront ioremap in this path
> is unnecessary.
>
> Fixes: 9d05c1fee837 ("RISC-V: KVM: Implement stage2 page table programmin=
g")
> Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>

LGTM.

Queued it as fix for Linux-6.18

Reviewed-by: Anup Patel <anup@brainfault.org>

Thanks,
Anup

> ---
>  arch/riscv/kvm/mmu.c | 20 +-------------------
>  1 file changed, 1 insertion(+), 19 deletions(-)
>
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index 525fb5a330c0..84c04c8f0892 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -197,8 +197,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>
>         /*
>          * A memory region could potentially cover multiple VMAs, and
> -        * any holes between them, so iterate over all of them to find
> -        * out if we can map any of them right now.
> +        * any holes between them, so iterate over all of them.
>          *
>          *     +--------------------------------------------+
>          * +---------------+----------------+   +----------------+
> @@ -229,32 +228,15 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>                 vm_end =3D min(reg_end, vma->vm_end);
>
>                 if (vma->vm_flags & VM_PFNMAP) {
> -                       gpa_t gpa =3D base_gpa + (vm_start - hva);
> -                       phys_addr_t pa;
> -
> -                       pa =3D (phys_addr_t)vma->vm_pgoff << PAGE_SHIFT;
> -                       pa +=3D vm_start - vma->vm_start;
> -
>                         /* IO region dirty page logging not allowed */
>                         if (new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
>                                 ret =3D -EINVAL;
>                                 goto out;
>                         }
> -
> -                       ret =3D kvm_riscv_mmu_ioremap(kvm, gpa, pa, vm_en=
d - vm_start,
> -                                                   writable, false);
> -                       if (ret)
> -                               break;
>                 }
>                 hva =3D vm_end;
>         } while (hva < reg_end);
>
> -       if (change =3D=3D KVM_MR_FLAGS_ONLY)
> -               goto out;
> -
> -       if (ret)
> -               kvm_riscv_mmu_iounmap(kvm, base_gpa, size);
> -
>  out:
>         mmap_read_unlock(current->mm);
>         return ret;
> --
> 2.50.1
>

