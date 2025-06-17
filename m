Return-Path: <kvm+bounces-49674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5661ADC128
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 06:59:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC5383B2768
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 04:58:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04E0D23B616;
	Tue, 17 Jun 2025 04:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="lsKfXB5K"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481FF21348
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 04:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750136342; cv=none; b=ZI6mU/07pUm9mD6yYIG0O2VF+/k0UQT1i8OMAQaUZd6rye1GtGYdaeiHcVd63cC9jeLWL0ITTrweCbrgtaBm729dGhjEACXdcy3ZOGWbsBjhkDPoasMZecV22nrTqaWD/3Xi9gEHudRRdQhUmr+r1bL01wWIXXhJHX8D9z4cIXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750136342; c=relaxed/simple;
	bh=oC0N+8iJdsFa6t85idz8kAO5kH1GbcyGScpKZjQ9qts=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GlRw3a+1g5kxjiCVay2dmO/4DMxg/PQyzcLzkowptCicI2A34CvSuYYMFAqLScxzqov7O3Cgka0snXMoLhubhZVXF/ah+FYmzLfFxyuFlG++oL3ATpBhe2FIV1ip6OtaExji+hjr/bpStd+lrRB7P5As6tfQ5lTPI3KG7Jq/lcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=lsKfXB5K; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-54e98f73850so5068530e87.1
        for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 21:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1750136338; x=1750741138; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TabJOmc9YbjjVWqBpFHGZqmoipuAKz7Dqc3oFlaWkHM=;
        b=lsKfXB5KK6bN7fKrVDgcmmEZXIz3o0vvm6lnUOBMaV4wtMpczawzJEhQWQNw3pKs6A
         iVhiaJrbj/hUqmMeNkkBMlh5+XHkNg0YyFdd44R2hlPr+BIcglHniIIncAc2Tt11cATT
         I4XkRq/ayTQqgq5HdXZSYmCaFGEipFCq7lpVlf4UC7W25p9CkhAzCaipxlJryBg6jM1W
         at1yph0HkcebBR6tMPVgk70IwKEYhVNZUXNTykLGS0ygJ7XUYnsBcQg0Y/H0UC3WHHTF
         uwMmFfnpaWbxf8iJZs+e4woYHk3K1KulIiYX+KTCJERGV9ZxizY7DIawMIkfVYoOhrP3
         Qe4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750136338; x=1750741138;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TabJOmc9YbjjVWqBpFHGZqmoipuAKz7Dqc3oFlaWkHM=;
        b=gADgBG1lyN3/HJsEymrihhMtNHUN8mROklGAuRG5r7xW1bHCUq4F2uC+VjyTu902N9
         SBRqVU0GDQpPfJ22BbjwGOJ629xrx9pFRkXqsCQbMu7+ZBKqPtQDIjZ9StUbzyUCTNJx
         4G0diBtciXVHXPr18Eg94Ss9P92DLDEz8g03REQIuGhyuSimTYdnxqwmCYqaoLt59Q8K
         a1esrbU1xslWrvReZ2At4DrRVesRL95hZ/9DsMGeghhT1j6ZUjgbvA43WsgU9GSavojp
         1JBoLVxoktbB7DWncGlpZkuByZRUtM7eiJL0dmxJOTH6u8aZ453jXy5ToML6xZgRFq3u
         EF2A==
X-Forwarded-Encrypted: i=1; AJvYcCX4MVnbpm1ZlJBDgNhxjSAS6ytrv+uBZybs2iucXyRC7HkILkdCbSBT+YBwwTVeeP19i+g=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBdmWNOs1Z3YliQDht5Vl7VTf/LYgn56ghHnBGY8t+5HlGnV8u
	i5CSFQzcI5HzLumgbazo3hSUuQx6pYjmnqEQS1zhfmS2m4p2+TNWWeaP8erTvN6lwG7qCnHKw/V
	4eHsp/tTHGL4ftNOD0WGLzjmjdA8c4XXAmwPmh/pR0g==
X-Gm-Gg: ASbGncvAMFwVWTokkLfSuWNTTVZuw/52e/9CQ45wxCJNfNrEsBwU7hhJ5zbxded2smL
	HOCx4IB4BYLX0G77iouOdpX71fFjBXHuoCeq0jBjz9oTy3K7eJ/zr0oSAEJi+L6b/peuLt3HU8q
	VDQmP21tumFfPWIpJ3plVlRJJ9CDUuIgM+B6+K71fdgeTW
X-Google-Smtp-Source: AGHT+IFH8UXFsAgXaqMjPDngF+lr7LJYJmQ6Doqaj2U7P69oabZRjWW7AlVBQ0Razbz6dxJNJnlmZobYZZyydWbrHDc=
X-Received: by 2002:a05:6512:110d:b0:553:2450:5895 with SMTP id
 2adb3069b0e04-553b6e71411mr3168533e87.4.1750136338338; Mon, 16 Jun 2025
 21:58:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250613065743.737102-1-apatel@ventanamicro.com>
 <20250613065743.737102-7-apatel@ventanamicro.com> <422c5677-48d1-41be-b128-595829c27167@linux.dev>
In-Reply-To: <422c5677-48d1-41be-b128-595829c27167@linux.dev>
From: Anup Patel <apatel@ventanamicro.com>
Date: Tue, 17 Jun 2025 10:28:45 +0530
X-Gm-Features: AX0GCFvh2GOQL0PlDDoaK4dE-NJWM8cyM_PZVHGF4_9faoB70s17Wy1wHH6F0Fs
Message-ID: <CAK9=C2UQAKk3kVswTzKRG43Ds3T3etfK-45Y+Uv2g3wn+Qg1fg@mail.gmail.com>
Subject: Re: [PATCH v2 06/12] RISC-V: KVM: Implement kvm_arch_flush_remote_tlbs_range()
To: Atish Patra <atish.patra@linux.dev>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Alexandre Ghiti <alex@ghiti.fr>, Andrew Jones <ajones@ventanamicro.com>, 
	Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 14, 2025 at 6:14=E2=80=AFAM Atish Patra <atish.patra@linux.dev>=
 wrote:
>
>
> On 6/12/25 11:57 PM, Anup Patel wrote:
> > The kvm_arch_flush_remote_tlbs_range() expected by KVM core can be
> > easily implemented for RISC-V using kvm_riscv_hfence_gvma_vmid_gpa()
> > hence provide it.
> >
> > Also with kvm_arch_flush_remote_tlbs_range() available for RISC-V, the
> > mmu_wp_memory_region() can happily use kvm_flush_remote_tlbs_memslot()
> > instead of kvm_flush_remote_tlbs().
> >
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > ---
> >   arch/riscv/include/asm/kvm_host.h | 2 ++
> >   arch/riscv/kvm/mmu.c              | 2 +-
> >   arch/riscv/kvm/tlb.c              | 8 ++++++++
> >   3 files changed, 11 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm=
/kvm_host.h
> > index ff1f76d6f177..6162575e2177 100644
> > --- a/arch/riscv/include/asm/kvm_host.h
> > +++ b/arch/riscv/include/asm/kvm_host.h
> > @@ -43,6 +43,8 @@
> >       KVM_ARCH_REQ_FLAGS(5, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> >   #define KVM_REQ_STEAL_UPDATE                KVM_ARCH_REQ(6)
> >
> > +#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
> > +
> >   #define KVM_HEDELEG_DEFAULT         (BIT(EXC_INST_MISALIGNED) | \
> >                                        BIT(EXC_BREAKPOINT)      | \
> >                                        BIT(EXC_SYSCALL)         | \
> > diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> > index 29f1bd853a66..a5387927a1c1 100644
> > --- a/arch/riscv/kvm/mmu.c
> > +++ b/arch/riscv/kvm/mmu.c
> > @@ -344,7 +344,7 @@ static void gstage_wp_memory_region(struct kvm *kvm=
, int slot)
> >       spin_lock(&kvm->mmu_lock);
> >       gstage_wp_range(kvm, start, end);
> >       spin_unlock(&kvm->mmu_lock);
> > -     kvm_flush_remote_tlbs(kvm);
> > +     kvm_flush_remote_tlbs_memslot(kvm, memslot);
> >   }
> >
> >   int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
> > diff --git a/arch/riscv/kvm/tlb.c b/arch/riscv/kvm/tlb.c
> > index da98ca801d31..f46a27658c2e 100644
> > --- a/arch/riscv/kvm/tlb.c
> > +++ b/arch/riscv/kvm/tlb.c
> > @@ -403,3 +403,11 @@ void kvm_riscv_hfence_vvma_all(struct kvm *kvm,
> >       make_xfence_request(kvm, hbase, hmask, KVM_REQ_HFENCE_VVMA_ALL,
> >                           KVM_REQ_HFENCE_VVMA_ALL, NULL);
> >   }
> > +
> > +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 n=
r_pages)
> > +{
> > +     kvm_riscv_hfence_gvma_vmid_gpa(kvm, -1UL, 0,
> > +                                    gfn << PAGE_SHIFT, nr_pages << PAG=
E_SHIFT,
> > +                                    PAGE_SHIFT);
> > +     return 0;
> > +}
>
> LGTM. However, I noticed that kvm_flush_remote_tlbs_range doesn't
> increment remote_tlb_flush_requests/remote_tlb_flush stat counter.
>
> So we would be losing those stats here. Do you know if there is a
> specific reason behind not supporting the stat counters in the *tlbs_rang=
e
> function ?

Looks like this was missed out in generic kvm_flush_remote_tlbs_range().

Regards,
Anup

