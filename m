Return-Path: <kvm+bounces-13577-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 810E6898C1A
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 18:29:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 101F228AED3
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 16:29:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C239912BEBF;
	Thu,  4 Apr 2024 16:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Qlrw7Rbp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F66E1E522
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 16:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712248190; cv=none; b=uOHEFTnxiF/wh+WKG4wRnIJLB0IwL0o6LCj77uCUdPxvrzoabSDSHUXOwnah+Q+ktFEbWP0JdHoGmwYPirP1cumszZoftvEF13mLk9gdsDE5jAlbnuj832jiAhrFlS72bcSnf6XZe+D6FSFkhJssYiORLdlsM9v7HSUzgBA3A/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712248190; c=relaxed/simple;
	bh=LMTOeetA5V3XX5XNpF9h0J9xtXoeUf7ZRq9wIYhkS6M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iMNnBYDZV64VKj2n2iDvxafMOrTMpUofc4S+NElJatod0KHBLdWAt1wwDg91dHYwsPP2Ca8OlkljAZZwEuretS+q8QxScR+TjL1mMbAz6Z1odDdf2ichhNUHtSuHDWyEMDPT+Y6Xmm+X7N29LG5RDTgYtc+FB4JxrUpUdPmWOBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Qlrw7Rbp; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-34373f95c27so782649f8f.1
        for <kvm@vger.kernel.org>; Thu, 04 Apr 2024 09:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712248186; x=1712852986; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sbXLCHLAGJTM4+QfXzCykBMcE+YY9AnNs3tQLFeWi5o=;
        b=Qlrw7Rbp3nUT6TpTzMpn3N0F9MtbFugAqX7Dz1rxneYcKg5MI7Z/ruB79TcaSuQX7g
         SATWaErfm7+nDtnUUy5TpiK5mPsaf4fxDrVVAYqh5fxcuaHRr8BKD4/C7/hJXQKCfDUd
         +pmdnbsbX4vlW4cvpdrdHp0d52TCbQOZVAbcLDhPangMkyYS6433md1840menlTamyw0
         U5GquWnirkYDKHi3DcKp/gCUM690CWwgXvOygQ2Z/gkz6TabrLOV7dge68DzBC1ivgzZ
         1usyuY3lqeMyTVWJh5NDyMr/mb2/Jaj6urq8k4TchCQlEXhf8JyS3YxlYUOI3fQiWIS8
         8oow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712248186; x=1712852986;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sbXLCHLAGJTM4+QfXzCykBMcE+YY9AnNs3tQLFeWi5o=;
        b=tX6iVBxWCK4KjuCt8wyNePo0lxXdNm6WERwDG5oj6jHz8owEq74r7C9XpqjQ0xne6S
         g/roIojlNdfkg3YLccwOAkC1HejfWanU31rru5YsOxTxUzJEGuRcZxuRlWVez/dj9cFs
         KdBJ2vFApQrG9Alc+R/xsEtNV3TsEeaM6rCCKpiI2h6LKpso5pyyjfKc5XYMkLSulkwU
         XnRX0oJmAekp/P/4SYWk1ynLWC8FzBsSbmaWiCVKLHCyxDwbiYcCpnFbfLAQIRXLDtCV
         ZyxQrqctwAEs69Rnc3r+5hNPqYGgKwIe6lfXTWkNOONDWf/SLJ8N9dPGx8nHP5F2jpTV
         t6Ww==
X-Forwarded-Encrypted: i=1; AJvYcCUP3FAtdrDE2rAFF76F0dKU8YVe1TRImjITC7/JLLAiLU+Y8A8yzh5y9/V3E6NoQB8kFGCB8AiuYN/BoYVKgIjEvEB/
X-Gm-Message-State: AOJu0YxwUzNh2z8Ftm9e75t9n0f1Eup07YeF0SMD/w3aQuu4+77Ef67k
	13NhbcHNqB1LRF9JhoYOtwcL6tWBey6GdIi9YG73OcMawGGLd5EA/TAkNYCwSN8HQ5nAcXebDIn
	2HhxwIDG222TUQW3briZ9H5Ps2JMo2YPJGaw8
X-Google-Smtp-Source: AGHT+IFTg58YH4jsXgi9OvvPnZABDtWiCqP8PUjbSUGa6O2B/JVyTwIqHTvFrWXo5dC5rh4l6bGdAAhbnOymMVQuxEk=
X-Received: by 2002:adf:fa08:0:b0:33e:7333:d459 with SMTP id
 m8-20020adffa08000000b0033e7333d459mr2165773wrr.49.1712248186161; Thu, 04 Apr
 2024 09:29:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240402213656.3068504-1-dmatlack@google.com> <cb793d79-f476-3134-23b7-dc43801b133e@loongson.cn>
In-Reply-To: <cb793d79-f476-3134-23b7-dc43801b133e@loongson.cn>
From: David Matlack <dmatlack@google.com>
Date: Thu, 4 Apr 2024 09:29:18 -0700
Message-ID: <CALzav=c_qP2kLVS6R4VQRyS6aMvj0381WKCE=5JpqRUrdEYPyg@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: Aggressively drop and reacquire mmu_lock during CLEAR_DIRTY_LOG
To: maobibo <maobibo@loongson.cn>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 2, 2024 at 6:50=E2=80=AFPM maobibo <maobibo@loongson.cn> wrote:
>
>
>
> On 2024/4/3 =E4=B8=8A=E5=8D=885:36, David Matlack wrote:
> > Aggressively drop and reacquire mmu_lock during CLEAR_DIRTY_LOG to avoi=
d
> > blocking other threads (e.g. vCPUs taking page faults) for too long.
> >
> > Specifically, change kvm_clear_dirty_log_protect() to acquire/release
> > mmu_lock only when calling kvm_arch_mmu_enable_log_dirty_pt_masked(),
> > rather than around the entire for loop. This ensures that KVM will only
> > hold mmu_lock for the time it takes the architecture-specific code to
> > process up to 64 pages, rather than holding mmu_lock for log->num_pages=
,
> > which is controllable by userspace. This also avoids holding mmu_lock
> > when processing parts of the dirty_bitmap that are zero (i.e. when ther=
e
> > is nothing to clear).
> >
> > Moving the acquire/release points for mmu_lock should be safe since
> > dirty_bitmap_buffer is already protected by slots_lock, and dirty_bitma=
p
> > is already accessed with atomic_long_fetch_andnot(). And at least on x8=
6
> > holding mmu_lock doesn't even serialize access to the memslot dirty
> > bitmap, as vCPUs can call mark_page_dirty_in_slot() without holding
> > mmu_lock.
> >
> > This change eliminates dips in guest performance during live migration
> > in a 160 vCPU VM when userspace is issuing CLEAR ioctls (tested with
> > 1GiB and 8GiB CLEARs). Userspace could issue finer-grained CLEARs, whic=
h
> Frequently drop/reacquire mmu_lock will cause userspace migration
> process issuing CLEAR ioctls to contend with 160 vCPU, migration speed
> maybe become slower.

In practice we have not found this to be the case. With this patch
applied we see a significant improvement in guest workload throughput
while userspace is issuing CLEAR ioctls without any change to the
overall migration duration.

For example, here[1] is a graph showing the effect of this patch on
a160 vCPU VM being Live Migrated while running a MySQL workload.
Y-Axis is transactions, blue line is without the patch, red line is
with the patch.

[1] https://drive.google.com/file/d/1zSKtc6wOQqfQrAQ4O9xlFmuyJ2-Iah0k/view

> In theory priority of userspace migration thread
> should be higher than vcpu thread.

I don't think it's black and white. If prioritizing migration threads
causes vCPU starvation (which is the type of issue this patch is
fixing), then that's probably not the right trade-off. IMO the
ultimate goal of live migration is that it's completely transparent to
the guest workload, i.e. we should aim to minimize guest disruption as
much as possible. A change that migration go 2x as fast but reduces
vCPU performance by 10x during the migration is probably not worth it.
And the reverse is also true, a change that increases vCPU performance
by 10% during migration but makes the migration take 10x longer is
also probably not worth it.

In the case of this patch, there doesn't seem to be a trade-off. We
see an improvement to vCPU performance without any regression in
migration duration or other metrics.

>
> Drop and reacquire mmu_lock with 64-pages may be a little too smaller,
> in generic it is one huge page size. However it should be decided by
> framework maintainer:)
>
> Regards
> Bibo Mao
> > would also reduce contention on mmu_lock, but doing so will increase th=
e
> > rate of remote TLB flushing. And there's really no reason to punt this
> > problem to userspace since KVM can just drop and reacquire mmu_lock mor=
e
> > frequently.
> >
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Oliver Upton <oliver.upton@linux.dev>
> > Cc: Tianrui Zhao <zhaotianrui@loongson.cn>
> > Cc: Bibo Mao <maobibo@loongson.cn>
> > Cc: Huacai Chen <chenhuacai@kernel.org>
> > Cc: Michael Ellerman <mpe@ellerman.id.au>
> > Cc: Anup Patel <anup@brainfault.org>
> > Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
> > Cc: Janosch Frank <frankja@linux.ibm.com>
> > Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > Cc: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> > v2:
> >   - Rebase onto kvm/queue [Marc]
> >
> > v1: https://lore.kernel.org/kvm/20231205181645.482037-1-dmatlack@google=
.com/
> >
> >   virt/kvm/kvm_main.c | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index fb49c2a60200..0a8b25a52c15 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -2386,7 +2386,6 @@ static int kvm_clear_dirty_log_protect(struct kvm=
 *kvm,
> >       if (copy_from_user(dirty_bitmap_buffer, log->dirty_bitmap, n))
> >               return -EFAULT;
> >
> > -     KVM_MMU_LOCK(kvm);
> >       for (offset =3D log->first_page, i =3D offset / BITS_PER_LONG,
> >                n =3D DIV_ROUND_UP(log->num_pages, BITS_PER_LONG); n--;
> >            i++, offset +=3D BITS_PER_LONG) {
> > @@ -2405,11 +2404,12 @@ static int kvm_clear_dirty_log_protect(struct k=
vm *kvm,
> >               */
> >               if (mask) {
> >                       flush =3D true;
> > +                     KVM_MMU_LOCK(kvm);
> >                       kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, mems=
lot,
> >                                                               offset, m=
ask);
> > +                     KVM_MMU_UNLOCK(kvm);
> >               }
> >       }
> > -     KVM_MMU_UNLOCK(kvm);
> >
> >       if (flush)
> >               kvm_flush_remote_tlbs_memslot(kvm, memslot);
> >
> > base-commit: 9bc60f733839ab6fcdde0d0b15cbb486123e6402
> >
>

