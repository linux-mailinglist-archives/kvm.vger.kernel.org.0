Return-Path: <kvm+bounces-14306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8209A8A1E40
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 20:31:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A3F071C21248
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 18:31:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87D2D78C93;
	Thu, 11 Apr 2024 18:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ldxlZC9Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043F078C82
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 18:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712858469; cv=none; b=gEPdLZ30AZCxahug0pRlpVtLv5OnH6DpSx409FRiL8QiqHDrkU/ptWGNUdopIwpfmAeLf56VZmggGI2WysQzgWFdUlpzLyV9Eaeji/eMIraSNsKNwC0y+xi5fWCaz4cmOsh94x8pOcZFc2SNoAejlyEef4BGMifBERMt12jhmX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712858469; c=relaxed/simple;
	bh=ELksu+sLzaHjlNPUR9IEFLD8rhRIAjWKwOmmScUPvR4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kRK8cQaonX0H536r6Y7xt5A2sRcp3BJfGZz1WoPeY/BhczrE2l+mP18yYcu7aTtIUgCUWD2xSb6DnujZX0Qhpxrc5YjYhKFHzs50MD8xcJ86ZYgLr3YbP7pOtCTSBkjrJZh08G8YYNpoEEE3GOibTOJ0jrWYfYECWorMpnvO1ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ldxlZC9Q; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-417e51e7aedso1371995e9.3
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 11:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712858466; x=1713463266; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TFQZlmoBEIaWgT85a+mHB96sryXc4pNLPf5zok3FIIo=;
        b=ldxlZC9QDQBVGNl5h9QLMeHkpkm6mAjtNEmsXiaiRkoawakaBTEmIh9XPsNwZHeIUr
         QuHNRf/VCTrFaMNvbGPTBhWKFg4He/nRuG2HEsh2eHDhN2MMX1W2AvxgtELjtSOmw19L
         4JQOfqROSAJj1zvdbPN/vRnA52kjYTcm8warHW0v13url7Srpr/Tb7FNuMzGB6VKQWSU
         dNPngNArB1djPXVTkVGZHB4yfx8N6OKQN+vVB2T5D/v8OIHNQ4zxDx5+e8MdvaXkBEgF
         jCDQViUA9VuqMo7H4p21qOi7jrTetxWhR9RiRIA4gXMeZdb7uuPn5owmGfNm9yB9dS13
         XC1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712858466; x=1713463266;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TFQZlmoBEIaWgT85a+mHB96sryXc4pNLPf5zok3FIIo=;
        b=MCozV+B/yWvPtZTmvfbN5DzCSKUbL7bPghBjsBW42kO6iA3qPASjA4qBOHYeNdRZuS
         l94tpQQIt8Zk1kA6cyy5Zg+IR2J3lxdMLNHXfRy3JbGxUIcruL7BUnGZhWlFYE29IEPT
         W6FK169CXkE8eAdTODYWqxYbOTJgpCswCvI+gBcLuAr5+araqEBbRWlExR/yklkC2qDF
         2XMxaUyYCu3EagvrwYNe5pCGUFYc2UCGGAOBGyZBn6a7iVsPacYQxYr0UN2NiNZIE0jQ
         fj8fjrFVHK727thGxvjtwLbjDq8/Fz628ZMiTCuQgwxnVbVj0NG0DTBtF6GCNklHED29
         o3/A==
X-Forwarded-Encrypted: i=1; AJvYcCWf/4eFXWN5eMlToswivdUtkEnRWeMvv7MYcU4dW+HIy8yyTcSPCSEQe2glHdD/Q/TDkUN/KoXP6XQ6aNeXGb8fuvhl
X-Gm-Message-State: AOJu0YwD2UQO7pxhBTfEzCilw/CWLPESvIrZkKreamrTowrl7BwK3nve
	K7hrrJISu57pRtgCKZf4J36D9l4OGIeoyWTNWBVhZWwj2sEI9VD9P3oG8qS9r5CBe8DZ5ZNGoOx
	BO1G6RIZT7srOLMdImmtbwZIXmt91FE1eWmkG
X-Google-Smtp-Source: AGHT+IEl4Iu+H70L5iEuaxVGs2wVMTfN36uwSB9T1kbBSUqJDIrWPvmyrfPoncl+j8yWfnTJVbG6KZ40Dk/wHobSp7A=
X-Received: by 2002:a5d:564e:0:b0:343:6551:935 with SMTP id
 j14-20020a5d564e000000b0034365510935mr235209wrw.66.1712858466173; Thu, 11 Apr
 2024 11:01:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240401232946.1837665-1-jthoughton@google.com>
 <20240401232946.1837665-6-jthoughton@google.com> <ZhgZHJH3c5Lb5SBs@google.com>
 <Zhgdw8mVNYZvzgWH@google.com>
In-Reply-To: <Zhgdw8mVNYZvzgWH@google.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 11 Apr 2024 11:00:37 -0700
Message-ID: <CALzav=f=_+UQBJv_eZ=t5wE0AytVo1mwfDoum+ZyNfNHvyOccQ@mail.gmail.com>
Subject: Re: [PATCH v3 5/7] KVM: x86: Participate in bitmap-based PTE aging
To: James Houghton <jthoughton@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Yu Zhao <yuzhao@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Gavin Shan <gshan@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	David Rientjes <rientjes@google.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 11, 2024 at 10:28=E2=80=AFAM David Matlack <dmatlack@google.com=
> wrote:
>
> On 2024-04-11 10:08 AM, David Matlack wrote:
> > On 2024-04-01 11:29 PM, James Houghton wrote:
> > > Only handle the TDP MMU case for now. In other cases, if a bitmap was
> > > not provided, fallback to the slowpath that takes mmu_lock, or, if a
> > > bitmap was provided, inform the caller that the bitmap is unreliable.
> > >
> > > Suggested-by: Yu Zhao <yuzhao@google.com>
> > > Signed-off-by: James Houghton <jthoughton@google.com>
> > > ---
> > >  arch/x86/include/asm/kvm_host.h | 14 ++++++++++++++
> > >  arch/x86/kvm/mmu/mmu.c          | 16 ++++++++++++++--
> > >  arch/x86/kvm/mmu/tdp_mmu.c      | 10 +++++++++-
> > >  3 files changed, 37 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/k=
vm_host.h
> > > index 3b58e2306621..c30918d0887e 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -2324,4 +2324,18 @@ int memslot_rmap_alloc(struct kvm_memory_slot =
*slot, unsigned long npages);
> > >   */
> > >  #define KVM_EXIT_HYPERCALL_MBZ             GENMASK_ULL(31, 1)
> > >
> > > +#define kvm_arch_prepare_bitmap_age kvm_arch_prepare_bitmap_age
> > > +static inline bool kvm_arch_prepare_bitmap_age(struct mmu_notifier *=
mn)
> > > +{
> > > +   /*
> > > +    * Indicate that we support bitmap-based aging when using the TDP=
 MMU
> > > +    * and the accessed bit is available in the TDP page tables.
> > > +    *
> > > +    * We have no other preparatory work to do here, so we do not nee=
d to
> > > +    * redefine kvm_arch_finish_bitmap_age().
> > > +    */
> > > +   return IS_ENABLED(CONFIG_X86_64) && tdp_mmu_enabled
> > > +                                    && shadow_accessed_mask;
> > > +}
> > > +
> > >  #endif /* _ASM_X86_KVM_HOST_H */
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 992e651540e8..fae1a75750bb 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -1674,8 +1674,14 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_g=
fn_range *range)
> > >  {
> > >     bool young =3D false;
> > >
> > > -   if (kvm_memslots_have_rmaps(kvm))
> > > +   if (kvm_memslots_have_rmaps(kvm)) {
> > > +           if (range->lockless) {
> > > +                   kvm_age_set_unreliable(range);
> > > +                   return false;
> > > +           }
> >
> > If a VM has TDP MMU enabled, supports A/D bits, and is using nested
> > virtualization, MGLRU will effectively be blind to all accesses made by
> > the VM.
> >
> > kvm_arch_prepare_bitmap_age() will return true indicating that the
> > bitmap is supported. But then kvm_age_gfn() and kvm_test_age_gfn() will
> > return false immediately and indicate the bitmap is unreliable because =
a
> > shadow root is allocate. The notfier will then return
> > MMU_NOTIFIER_YOUNG_BITMAP_UNRELIABLE.

Ah no, I'm wrong here. Setting args.unreliable causes the notifier to
return 0 instead of MMU_NOTIFIER_YOUNG_FAST.
MMU_NOTIFIER_YOUNG_BITMAP_UNRELIABLE is used for something else.

The control flow of all this and naming of functions and macros is
overall confusing. args.unreliable and
MMU_NOTIFIER_YOUNG_BITMAP_UNRELIABLE for one. Also I now realize
kvm_arch_prepare/finish_bitmap_age() are used even when the bitmap is
_not_ provided, so those names are also misleading.

