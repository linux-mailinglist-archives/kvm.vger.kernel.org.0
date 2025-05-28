Return-Path: <kvm+bounces-47888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D8DFAC6CBE
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 17:22:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 339A74E224D
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 15:22:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA46028C2B0;
	Wed, 28 May 2025 15:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q7y8oo1+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60C0286892
	for <kvm@vger.kernel.org>; Wed, 28 May 2025 15:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748445721; cv=none; b=AR/OH20DAVl8NkqNoSDC2ZdjHnqFucWRAaVBrnswI+WMuPHQyjsnS93NRwHwDgjkvISq4JdTkEzx5RsfvieMK8q+x1EXzAJvbyAOggVs9FIFxe8pQhLr892nLpXp02f+z5Q2POadnQjYZIB9AFsaC+CdwULK2cMAXrZ7BWhGQI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748445721; c=relaxed/simple;
	bh=0L9FqIrWV1HH0CKjcDoLD6PMX4MXaZyCx+Isv4wqI6I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gth/u0CA2ppgkb3XUqh46VVKppOVNG96dPixLar2YrdOq7SG1W8vm04jZZdaqmAIrbd4gr1sAILgn0lo2j8jSfLz7lp0M2G1IOIbAL0/QJEpFHKtZg28R0Dv9vf+6jnUM2M6r+YJcBjhgZmVJXUP6V+JDkua6sWOSHZf+nLwHSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q7y8oo1+; arc=none smtp.client-ip=209.85.219.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-e733cd55f9eso3861775276.1
        for <kvm@vger.kernel.org>; Wed, 28 May 2025 08:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748445718; x=1749050518; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=32qgoYfovQ3gS/SAum8cU1W1nbKSlw2h8oFp1ZvYf5Q=;
        b=Q7y8oo1+2gzsQIi+PeqDcDAEwLJqN+KmeSdhlEh3Oi3GxiDgf1I5sJWOXGjVsF0iI3
         WvpuGJEz4EZwmJw7SAASjvpWF6xX9GVTVmSwI9JV+vJP0K9hxQ0RQZI941LbvGj9MVj9
         bJRxr3We937W2p75QhjIWt9fa1Hp9fqxL3XM5E5y7qLDKTa0jzbIq4itUfFTgLtNIedm
         j5L9ZtOAvfdeecYg2YWAvMxTNR4pDzqKtSNpAPWMiZ1IPBBkAtmw8bbXpWrGLvtrBCwA
         pjsZGKulykcsqmcS+pAF85LYpXUB86JQQ1JasA17T1omW96W4pdyjy/raBYdRZBZFRwv
         l/ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748445718; x=1749050518;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=32qgoYfovQ3gS/SAum8cU1W1nbKSlw2h8oFp1ZvYf5Q=;
        b=Mg3Yhj/ArXJrrFVAqJq3tkYkFemR2V9AKBJyt/43nWTE6SH+t4Cq0Kcs3A1hy4tosL
         lygPjW5qOiHkFBN4BOpqupOW+kmHAwDpPyc4Yr+h8UHD7slVZjIdYXzN1dp3Ie/kFBzx
         Mwk1AA/SJM+NSSaSKicJIGf4LRC7CcrmVlxKQrjZcoGabcReJL7hKRh5u5Zae8C9p0A6
         NZ9yAsph0Y3qh17IXYiSzx16SxAznUm2jqhtlNn0xcQI2XQr8hyk9EMSDsyg5C1A0Ls1
         oMJ1Ze7aEyecib7CCSLurgI0dE6vFmKk27qP5WpfFMkb22Zsuimzsyas/tSzYTvb5cvC
         sASQ==
X-Forwarded-Encrypted: i=1; AJvYcCW+ht6XIWs761cKBdSsET4CZENpVzoDe5gF23aSSdbPnIiyf+SnIhqxSdB0WHAMRXNvdfQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/0nsN1/SV0CXN0Sh17P8ZNi9osTABXOqmeTe9M4SMpwn5eVWK
	OjXK2vrP6+dAfoH3riOM8kt/pQkGLoVISl2c/lPTCJiISiGwZLe8ucu/B9+pWcaw+Gi5DxTX7Ob
	XSYG4GfdUh5CqhD9EAUHASzbPk3yn1Syx3W+/Q/l6
X-Gm-Gg: ASbGncumy5Fs1s58Qlz/4VR5gWJKzreG2kZMTHDbAZxg6HWN4tckCyfx7EeQqabk2dn
	te/JByuryMim1Py/aAgBz/y5wD5l7TKo0ozf1OT+25s/T5L4pwb0syxFk3kWGeNGsGLZt8MVywf
	4MHJAjyPzA5oSL1uMv5zw9gJH6RTpbQQfS9JJf49vG0LEnqX0te1twY47+DSiOTSvS62dvd26rs
	A2rhQ==
X-Google-Smtp-Source: AGHT+IFSzzwtG0QBLjREdP8rJp3MI7Sye8YaM/FgQl/WLbT3PKgJS/6Q9/qQMcY7F2ocTfZADqMYbCZWjE0ffy1ogQw=
X-Received: by 2002:a05:6902:2b0c:b0:e78:f7a0:fd02 with SMTP id
 3f1490d57ef6-e7f61839725mr2840203276.37.1748445717406; Wed, 28 May 2025
 08:21:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250109204929.1106563-1-jthoughton@google.com>
 <20250109204929.1106563-2-jthoughton@google.com> <aBqi7fDtnvxzxV1V@google.com>
In-Reply-To: <aBqi7fDtnvxzxV1V@google.com>
From: James Houghton <jthoughton@google.com>
Date: Wed, 28 May 2025 11:21:21 -0400
X-Gm-Features: AX0GCFti85Bmslv3UKy35YTx4AbsV0M4oMVo9TuLb01TfEKfWoCE-rNdRG1Yeks
Message-ID: <CADrL8HUMm0PUqx-xNdPvSMP6z4gzs2OTUJG1sdyy88D-XWxT3g@mail.gmail.com>
Subject: Re: [PATCH v2 01/13] KVM: Add KVM_MEM_USERFAULT memslot flag and bitmap
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Anish Moorthy <amoorthy@google.com>, 
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 6, 2025 at 8:01=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Thu, Jan 09, 2025, James Houghton wrote:
> > Use one of the 14 reserved u64s in struct kvm_userspace_memory_region2
> > for the user to provide `userfault_bitmap`.
> >
> > The memslot flag indicates if KVM should be reading from the
> > `userfault_bitmap` field from the memslot. The user is permitted to
> > provide a bogus pointer. If the pointer cannot be read from, we will
> > return -EFAULT (with no other information) back to the user.
>
> For the uAPI+infrastructure changelog, please elaborate on the design goa=
ls and
> choices.  The "what" is pretty obvious from the patch; describe why this =
is being
> added.
>
> > Signed-off-by: James Houghton <jthoughton@google.com>
> > ---
> >  include/linux/kvm_host.h | 14 ++++++++++++++
> >  include/uapi/linux/kvm.h |  4 +++-
> >  virt/kvm/Kconfig         |  3 +++
> >  virt/kvm/kvm_main.c      | 35 +++++++++++++++++++++++++++++++++++
> >  4 files changed, 55 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 401439bb21e3..f7a3dfd5e224 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -590,6 +590,7 @@ struct kvm_memory_slot {
> >       unsigned long *dirty_bitmap;
> >       struct kvm_arch_memory_slot arch;
> >       unsigned long userspace_addr;
> > +     unsigned long __user *userfault_bitmap;
> >       u32 flags;
> >       short id;
> >       u16 as_id;
> > @@ -724,6 +725,11 @@ static inline bool kvm_arch_has_readonly_mem(struc=
t kvm *kvm)
> >  }
> >  #endif
> >
> > +static inline bool kvm_has_userfault(struct kvm *kvm)
> > +{
> > +     return IS_ENABLED(CONFIG_HAVE_KVM_USERFAULT);
> > +}
>
> Eh, don't think we need this wrapper.  Just check the CONFIG_xxx manually=
 in the
> one or two places where code isn't guarded by an #ifdef.
>
> >  struct kvm_memslots {
> >       u64 generation;
> >       atomic_long_t last_used_slot;
> > @@ -2553,4 +2559,12 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_v=
cpu *vcpu,
> >                                   struct kvm_pre_fault_memory *range);
> >  #endif
> >
> > +int kvm_gfn_userfault(struct kvm *kvm, struct kvm_memory_slot *memslot=
,
> > +                   gfn_t gfn);
> > +
> > +static inline bool kvm_memslot_userfault(struct kvm_memory_slot *memsl=
ot)
>
> I strongly prefer kvm_is_userfault_memslot().  KVM's weird kvm_memslot_<f=
lag>()
> nomenclature comes from ancient code, i.e. isn't something I would follow=
.
>
> > +{
> > +     return memslot->flags & KVM_MEM_USERFAULT;
>
> I think it's worth checking for a non-NULL memslot, even if all current c=
allers
> pre-check for a slot.
>
> > @@ -2042,6 +2051,9 @@ int __kvm_set_memory_region(struct kvm *kvm,
> >               if (r)
> >                       goto out;
> >       }
> > +     if (mem->flags & KVM_MEM_USERFAULT)
> > +             new->userfault_bitmap =3D
> > +               (unsigned long __user *)(unsigned long)mem->userfault_b=
itmap;
>
>         if (mem->flags & KVM_MEM_USERFAULT)
>                 new->userfault_bitmap =3D u64_to_user_ptr(mem->userfault_=
bitmap);

Applied this change to the other cast (where we do access_ok()) as well, th=
anks!

>
> >       r =3D kvm_set_memslot(kvm, old, new, change);
> >       if (r)
> > @@ -6426,3 +6438,26 @@ void kvm_exit(void)
> >       kvm_irqfd_exit();
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_exit);
> > +
> > +int kvm_gfn_userfault(struct kvm *kvm, struct kvm_memory_slot *memslot=
,
> > +                    gfn_t gfn)
>
> I think this series is the perfect opportunity (read: victim) to introduc=
e a
> common "struct kvm_page_fault".  With a common structure to provide the g=
fn, slot,
> write, exec, and is_private fields, this helper can handle the checks and=
 the call
> to kvm_prepare_memory_fault_exit().
>
> And with that in place, I would vote to name this something like kvm_do_u=
serfault(),
> return a boolean, and let the caller return -EFAULT.

Returning 'true' from kvm_do_userfault() without a
kvm_prepare_memory_fault_exit() looked a bit strange at first, but I
don't have strong feelings. I'll add a small comment there.

>
> For making "struct kvm_page_fault" common, one thought would be to have a=
rch code
> define the entire struct, and simply assert on the few fields that common=
 KVM needs
> being defined by arch code.  And wrap all references in CONFIG_KVM_GENERI=
C_PAGE_FAULT.
>
> I don't expect there will be a huge number of fields that common KVM need=
s, i.e. I
> don't think the maintenance burden of punting to arch code will be high. =
 And letting
> arch code own the entire struct means we don't need to have e.g. fault->a=
rch.present
> vs. fault->write in KVM x86, which to me is a big net negative for readab=
ility.
>
> I'll respond to the cover letter with an attachment of seven patches to s=
ketch out
> the idea.

Looks great! Thanks very much!

>
> > +{
> > +     unsigned long bitmap_chunk =3D 0;
> > +     off_t offset;
> > +
> > +     if (!kvm_memslot_userfault(memslot))
> > +             return 0;
> > +
> > +     if (WARN_ON_ONCE(!memslot->userfault_bitmap))
> > +             return 0;
>
> '0' is technically a valid userspace address.  I'd just drop this.  If we=
 have a
> KVM bug that results in failure to generate usefaults, we'll notice quite=
 quickly.
>
> > +
> > +     offset =3D gfn - memslot->base_gfn;
> > +
> > +     if (copy_from_user(&bitmap_chunk,
> > +                        memslot->userfault_bitmap + offset / BITS_PER_=
LONG,
> > +                        sizeof(bitmap_chunk)))
>
> Since the address is checked during memslot creation, I'm pretty sure thi=
s can
> use __get_user().  At the very least, it should be get_user().

Thanks! I agree, __get_user() should be fine.

>
> > +             return -EFAULT;
> > +
> > +     /* Set in the bitmap means that the gfn is userfault */
> > +     return !!(bitmap_chunk & (1ul << (offset % BITS_PER_LONG)));
>
> test_bit()?

Thanks for all the feedback and applying it for me in those patches
you sent back. :)

