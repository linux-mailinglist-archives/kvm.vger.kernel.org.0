Return-Path: <kvm+bounces-40262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F288BA55249
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 18:06:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C205518833F1
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 17:03:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7924925A35F;
	Thu,  6 Mar 2025 17:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FZIKrwjo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCD113635B
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 17:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741280597; cv=none; b=g6l57ZrNqMtirxqVJcQySCzwscGP8bonRvBooE+sHuIzSoUid3m4uuAoDGORr3/fDyv+lTgdAKm5DHAuWY4xF53EcldAW7G3QSPy05AUDAvop8gqoZ5zdvKOX7JDTDcKdhi7J5Mqk/4z6/pbsmaTr9Uv2e3xEKZ/cD1HmXNxTqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741280597; c=relaxed/simple;
	bh=1Pb1LWdB/fkOI6KagikZenEdrDGuxjTvfvQ7hM2eBTY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fwPWhjmO7EpObey15/h+z36DuaXOirNcM5rm6pT8U+t/gPxOhFRBbq/YLBW+EWWPdv6LL/Z0O+oUMXmG9wF9GCFPtt4AmaaAgo9EH8J5gIEscGpgEF2xqDsKH/Q0qA/snXVmlKd2sd2E3cG/FrYLLFI3naq/tvNPrIhgKYbVxF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FZIKrwjo; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-474e1b8c935so360811cf.0
        for <kvm@vger.kernel.org>; Thu, 06 Mar 2025 09:03:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741280594; x=1741885394; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4EMbFFYJ1L3mBwyzCsveQHnx4Pg8IDkCRue104JrOR8=;
        b=FZIKrwjousfzhRVJ/NrOu10J9CY6wgy/9I/Owh1NlI3wly/SFSnMrLGN5n/39Nep9T
         npFTGOMGg12uGqKLpel6QXSGhCZCrpZu/PW7szKD3/LIxYHb+/TMQIOdVrzHZf+iBJQZ
         //DJGILeiPEThB+enYaGOTWyUXOmmuk7Fb63Y0OLlbsKrGnG8qSRN8ll5oj4IliiNwOD
         9yi8HgaitD8gppDMqYClDACMzDawYcIa4QW9TCuTKjwYM2t0ijFG6KvCXg7x8QX4hwq/
         7y05Y+hlfwvoh49XzzNVZ++AyLC+UOnxZZAeYHmuEIbcdYQ0EgB3w3M4EgHV+yH5ckeE
         qWaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741280594; x=1741885394;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4EMbFFYJ1L3mBwyzCsveQHnx4Pg8IDkCRue104JrOR8=;
        b=niDD0b2z4P/m/k3KwKfxKDoMdjDjLsE1p0YmNU0Um27Y1885Y18mu2budTt4trTFyg
         uUMrvckZX0YJ+18SaaQNWtEVSgkUHbezck6t5j5fTI/RCJvac46OcejH3XX6XW6iNgtl
         tviS5zfZyu7zgKpewprqdxPxpQVdDPKfEn172UOvpjxyY/SWvNkDOrc8nDE0Ru7OIQkk
         UVpu+AgXb0romOzCi4KdzolNlk5sqvaoHazXTiEM52z0T3/PY2KpjM7i2a1DjZVVmOEW
         sD+NZXNLOcW1Fca1rljidDI+FoBbKiW9jZz+19oW6o5vq7BEneSKwfF/el+MX9oi5SZk
         jmQg==
X-Gm-Message-State: AOJu0Ywkymj9dODkfkyNHyLEox+ToO+bQFSvLaLRSfu+Scgwnaifieer
	icWaxigEPReU9vXsJEwx75jDIeLYs4XaDjWameeNpWX4mAYI6ada1crJFZDVv+WBoJ+6Q39LEr/
	uGqbTiYGJ7z1rfa7TUJ/R0OJri8F5QGQu0xIf
X-Gm-Gg: ASbGnctDo/Rii/q1O0OuGhITKat96YTpiK+Av3slb+J7xY72z8m12SKpZUQlbo/0EB6
	Uxzn4a0CR7osBO3+mwBGWfYTCHmWPaTXGDbP/PahlgZRuj5AgwZDzlbpVJfBOTnGzgWHzsqO3Oy
	2BJq48aJOZkZadriMPa0hlNmJK
X-Google-Smtp-Source: AGHT+IFscbfbEjQWzgP/Q0C4syso7M3jLLXL+09eTxjQNjzcEV/iwWGPrS218eIlgnbeDmmG2MI/wuau2W2s73zwJUo=
X-Received: by 2002:a05:622a:54f:b0:474:fb73:6988 with SMTP id
 d75a77b69052e-4751b0f4665mr4590771cf.24.1741280593410; Thu, 06 Mar 2025
 09:03:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250303171013.3548775-5-tabba@google.com> <diqzldtita25.fsf@ackerleytng-ctop.c.googlers.com>
In-Reply-To: <diqzldtita25.fsf@ackerleytng-ctop.c.googlers.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 6 Mar 2025 17:02:34 +0000
X-Gm-Features: AQ5f1JqLAreIPGMno5EAURP2cZNEzAHzAi-nToyKh39XwFjVasgUAzUIjnmcvsY
Message-ID: <CA+EHjTycf+OgM1M+XuCqG=ypAGt+woEVHYj9t86o6Knf+Kk-EQ@mail.gmail.com>
Subject: Re: [PATCH v5 4/9] KVM: guest_memfd: Handle in-place shared memory as
 guest_memfd backed memory
To: Ackerley Tng <ackerleytng@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, mail@maciej.szmigiero.name, david@redhat.com, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com, peterx@redhat.com
Content-Type: text/plain; charset="UTF-8"

Hi Ackerley,

On Thu, 6 Mar 2025 at 16:09, Ackerley Tng <ackerleytng@google.com> wrote:
>
> Fuad Tabba <tabba@google.com> writes:
>
> > For VMs that allow sharing guest_memfd backed memory in-place,
> > handle that memory the same as "private" guest_memfd memory. This
> > means that faulting that memory in the host or in the guest will
> > go through the guest_memfd subsystem.
> >
> > Note that the word "private" in the name of the function
> > kvm_mem_is_private() doesn't necessarily indicate that the memory
> > isn't shared, but is due to the history and evolution of
> > guest_memfd and the various names it has received. In effect,
> > this function is used to multiplex between the path of a normal
> > page fault and the path of a guest_memfd backed page fault.
> >
>
> I think this explanation is a good summary, but this change seems to
> make KVM take pages via guest_memfd functions for more than just
> guest-private pages.
>
> This change picks the guest_memfd fault path as long as the memslot has
> an associated guest_memfd (kvm_slot_can_be_private()) and gmem was
> configured to kvm_arch_gmem_supports_shared_mem().
>
> For shared accesses, shouldn't KVM use the memslot's userspace_addr?
> It's still possibly the same mmap-ed guest_memfd inode, but via
> userspace_addr. And for special accesses from within KVM (e.g. clock),
> maybe some other changes are required inside KVM, or those could also
> use userspace_addr.

The reason is that, although it does have a userspace_addr, it might
not actually be mapped. We don't require that shared memory be mapped.

Cheers,
/fuad


> You mentioned that pKVM doesn't use
> KVM_GENERIC_MEMORY_ATTRIBUTES/mem_attr_array, so perhaps the change
> required here is that kvm_mem_is_private() should be updated to
> kvm_slot_can_be_private() && whatever pKVM uses to determine if a gfn is
> private?
>
> So perhaps kvm_arch_gmem_supports_shared_mem() should be something like
> kvm_arch_gmem_use_guest_memfd(), where x86 would override that to use
> mem_attr_array if CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES is selected?
>
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  include/linux/kvm_host.h | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 2d025b8ee20e..296f1d284d55 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -2521,7 +2521,8 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> >  #else
> >  static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> >  {
> > -     return false;
> > +     return kvm_arch_gmem_supports_shared_mem(kvm) &&
> > +            kvm_slot_can_be_private(gfn_to_memslot(kvm, gfn));
> >  }
> >  #endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */

