Return-Path: <kvm+bounces-13591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A113898DC7
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 20:13:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 77216B231DB
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 18:13:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BAD71D554;
	Thu,  4 Apr 2024 18:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BIIY9i9B"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38291CA82
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 18:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712254392; cv=none; b=DYEncFvUNkNOyuNEZ442Xj8nqs4SfL7OXkzWUSOofIStn/JWHn5SLGemSA034DGgpSbEFnFpPdB9I7WjDwS/X83i0UnRbyLdX3qVxOPYpDGCiXITi6Ywxg9WXKxboyZy+6iZVwL287YdJ1mu4eBH4hgucn5HjEbum8meYFNhviA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712254392; c=relaxed/simple;
	bh=7r+vp77GfHcP/u9lzgmPJXs0U4W9p9k3rgYIL0yRTMw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VciF0pLyUi6V/XlI0em4fCxyaVWWRL9PqR321vdP2QojRZta15sh+uzWTAj1d7LE87pipP/yRLLSR3VhUERwa8hVzosPGVcKfXX7TEqYqBxQr5D8FDOrLAfwUuC6rp6smi1XqQURWvnu46avoHwDFbi16tkR/YSu2OXE2cyaMp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BIIY9i9B; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-415523d9824so13351705e9.3
        for <kvm@vger.kernel.org>; Thu, 04 Apr 2024 11:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712254389; x=1712859189; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PljaTZNIhWGVVBVk1FxzmoZmc6LBiiDTllP+5X4HaUo=;
        b=BIIY9i9B8aW/uIxGRfcS7jHkSl7VUEYoZCoaPshZ1bbdp902lixRokXXLf5og4mAd9
         Epog7PnKbDZylKNp7wyB6Zn+1oNaPQroqXcr7uWuxVvWJHW2sKlWfeSvC7hoY6VVNRzs
         OBa8wAM+KgYUVFbyXSLqXEbncwDmO4BNhRHyAdWpuJUqf2oJE5zBd0DaVe5liWXd7LgD
         HvKh/NJn2hqq67felIY6BFcf6bFXmSGxlz/vbcxgJx2Vve8PuObaq3ZLX8TVFmB5R4IG
         zYKsDKzYG3swsc7Vs6a6sqdYDjP6LSbgNQUDwG4gGFyJeGaZsifco9DnJMT+tTncD63w
         ThGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712254389; x=1712859189;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PljaTZNIhWGVVBVk1FxzmoZmc6LBiiDTllP+5X4HaUo=;
        b=C6I7QnwTX77gS/TVfsJbCz+6X1Iht6Zayu0Kf2ldvFdzv6eSvF6cycWhYfAW7OVuei
         zJOahcojJkHLi7efoBd+3i33nuBrFCNEejl7yxWvULwWGiwPM8GLG4HV59ah1f9VaZER
         e1rSXjmdJYWeNJY+wX8vBvGRFKtzsL827GjayaogYpO2++DhPyvmNyYqMZXFyjlf+zvE
         yw7x/nw9AWo6SH/QTpQrrphWLwf8cUiUbPeFmfYsG/RD+HyAi7rGxQRjMvNOXOJJ06jj
         WMVkwZXm4GxSFDIeAKjspYdjk5bBec0crgoozDRc0vHRf4m0xPUpkugjW/qGbnro4l07
         gPCg==
X-Forwarded-Encrypted: i=1; AJvYcCWhN7jXRJZ6Zi8MpsJ6XxeaDFUv/056frdSELvg0q29WtpQSoqg1/ntFJUQr2MP6gg8kjQd2+C52eTtM6/csn8P8aoH
X-Gm-Message-State: AOJu0YyoFF5QcO2oL4wZJytpRF6WDBKehOa89xQKJm1umvDwrvTz+YaW
	9Ps+ochs+7uuVCjjiBIfFzavjQ3oK1qstAqOFyon7KwH0QOoI/y50/YTXfrQBey292BTZMv9S/f
	UYpeS92Y6qvrCU2LLvvMxngehfsFUfSphgzhiDItX1+uHMPvNBpUN
X-Google-Smtp-Source: AGHT+IEWkUEMx9khJJrvbtUCugKUrfa2EP0iwaToE25+JeybzWKIZDK0q5GGkv3vaKy+wqiyJ+4OjhFiPFi+FZBi3Vc=
X-Received: by 2002:adf:eec2:0:b0:33e:bfd0:335c with SMTP id
 a2-20020adfeec2000000b0033ebfd0335cmr3130118wrp.51.1712254388783; Thu, 04 Apr
 2024 11:13:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240402213656.3068504-1-dmatlack@google.com> <cb793d79-f476-3134-23b7-dc43801b133e@loongson.cn>
 <CALzav=c_qP2kLVS6R4VQRyS6aMvj0381WKCE=5JpqRUrdEYPyg@mail.gmail.com> <Zg7fAr7uYMiw_pc3@google.com>
In-Reply-To: <Zg7fAr7uYMiw_pc3@google.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 4 Apr 2024 11:12:40 -0700
Message-ID: <CALzav=cF+tq-snKbdP76FpodUdd7Fhu9Pf3jTK5c5=vb-MY9cQ@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: Aggressively drop and reacquire mmu_lock during CLEAR_DIRTY_LOG
To: Sean Christopherson <seanjc@google.com>
Cc: maobibo <maobibo@loongson.cn>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 4, 2024 at 10:10=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Apr 04, 2024, David Matlack wrote:
> > On Tue, Apr 2, 2024 at 6:50=E2=80=AFPM maobibo <maobibo@loongson.cn> wr=
ote:
> > > > This change eliminates dips in guest performance during live migrat=
ion
> > > > in a 160 vCPU VM when userspace is issuing CLEAR ioctls (tested wit=
h
> > > > 1GiB and 8GiB CLEARs). Userspace could issue finer-grained CLEARs, =
which
> > > Frequently drop/reacquire mmu_lock will cause userspace migration
> > > process issuing CLEAR ioctls to contend with 160 vCPU, migration spee=
d
> > > maybe become slower.
> >
> > In practice we have not found this to be the case. With this patch
> > applied we see a significant improvement in guest workload throughput
> > while userspace is issuing CLEAR ioctls without any change to the
> > overall migration duration.
>
> ...
>
> > In the case of this patch, there doesn't seem to be a trade-off. We
> > see an improvement to vCPU performance without any regression in
> > migration duration or other metrics.
>
> For x86.  We need to keep in mind that not all architectures have x86's o=
ptimization
> around dirty logging faults, or around faults in general. E.g. LoongArch'=
s (which
> I assume is Bibo Mao's primary interest) kvm_map_page_fast() still acquir=
es mmu_lock.
> And if the fault can't be handled in the fast path, KVM will actually acq=
uire
> mmu_lock twice (mmu_lock is dropped after the fast-path, then reacquired =
after
> the mmu_seq and fault-in pfn stuff).
>
> So for x86, I think we can comfortably state that this change is a net po=
sitive
> for all scenarios.  But for other architectures, that might not be the ca=
se.
> I'm not saying this isn't a good change for other architectures, just tha=
t we
> don't have relevant data to really know for sure.

I do not have data for other architectures, but may be able to get
data on ARM in the next few weeks. I believe we saw similar benefits
when testing on ARM.

>
> Absent performance data for other architectures, which is likely going to=
 be
> difficult/slow to get, it might make sense to have this be opt-in to star=
t.  We
> could even do it with minimal #ifdeffery, e.g. something like the below w=
ould allow
> x86 to do whatever locking it wants in kvm_arch_mmu_enable_log_dirty_pt_m=
asked()
> (I assume we want to give kvm_get_dirty_log_protect() similar treatment?)=
.

I don't see any reason not to give kvm_get_dirty_log_protect() the
same treatment, but it's less important since
kvm_get_dirty_log_protect() does not take the mmu_lock at all when
manual-protect is enabled.

>
> I don't love the idea of adding more arch specific MMU behavior (going th=
e wrong
> direction), but it doesn't seem like an unreasonable approach in this cas=
e.

I wonder if this is being overly cautious. I would expect only more
benefit on architectures that more aggressively take the mmu_lock on
vCPU threads during faults. The more lock acquisition on vCPU threads,
the more this patch will help reduce vCPU starvation during
CLEAR_DIRTY_LOG.

Hm, perhaps testing with ept=3DN (which will use the write-lock for even
dirty logging faults) would be a way to increase confidence in the
effect on other architectures?

>
> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> index 86d267db87bb..5eb1ce83f29d 100644
> --- a/virt/kvm/dirty_ring.c
> +++ b/virt/kvm/dirty_ring.c
> @@ -66,9 +66,9 @@ static void kvm_reset_dirty_gfn(struct kvm *kvm, u32 sl=
ot, u64 offset, u64 mask)
>         if (!memslot || (offset + __fls(mask)) >=3D memslot->npages)
>                 return;
>
> -       KVM_MMU_LOCK(kvm);
> +       KVM_MMU_LOCK_FOR_DIRTY_LOG_PROTECT(kvm);
>         kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot, offset, mas=
k);
> -       KVM_MMU_UNLOCK(kvm);
> +       KVM_MMU_UNLOCK_FOR_DIRTY_LOG_PROTECT(kvm);
>  }
>
>  int kvm_dirty_ring_alloc(struct kvm_dirty_ring *ring, int index, u32 siz=
e)
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d1fd9cb5d037..74ae844e4ed0 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2279,7 +2279,7 @@ static int kvm_get_dirty_log_protect(struct kvm *kv=
m, struct kvm_dirty_log *log)
>                 dirty_bitmap_buffer =3D kvm_second_dirty_bitmap(memslot);
>                 memset(dirty_bitmap_buffer, 0, n);
>
> -               KVM_MMU_LOCK(kvm);
> +               KVM_MMU_LOCK_FOR_DIRTY_LOG_PROTECT(kvm);
>                 for (i =3D 0; i < n / sizeof(long); i++) {
>                         unsigned long mask;
>                         gfn_t offset;
> @@ -2295,7 +2295,7 @@ static int kvm_get_dirty_log_protect(struct kvm *kv=
m, struct kvm_dirty_log *log)
>                         kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, mems=
lot,
>                                                                 offset, m=
ask);
>                 }
> -               KVM_MMU_UNLOCK(kvm);
> +               KVM_MMU_UNLOCK_FOR_DIRTY_LOG_PROTECT(kvm);
>         }
>
>         if (flush)
> @@ -2390,7 +2390,7 @@ static int kvm_clear_dirty_log_protect(struct kvm *=
kvm,
>         if (copy_from_user(dirty_bitmap_buffer, log->dirty_bitmap, n))
>                 return -EFAULT;
>
> -       KVM_MMU_LOCK(kvm);
> +       KVM_MMU_LOCK_FOR_DIRTY_LOG_PROTECT(kvm);
>         for (offset =3D log->first_page, i =3D offset / BITS_PER_LONG,
>                  n =3D DIV_ROUND_UP(log->num_pages, BITS_PER_LONG); n--;
>              i++, offset +=3D BITS_PER_LONG) {
> @@ -2413,7 +2413,7 @@ static int kvm_clear_dirty_log_protect(struct kvm *=
kvm,
>                                                                 offset, m=
ask);
>                 }
>         }
> -       KVM_MMU_UNLOCK(kvm);
> +       KVM_MMU_UNLOCK_FOR_DIRTY_LOG_PROTECT(kvm);
>
>         if (flush)
>                 kvm_flush_remote_tlbs_memslot(kvm, memslot);
> diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
> index ecefc7ec51af..39d8b809c303 100644
> --- a/virt/kvm/kvm_mm.h
> +++ b/virt/kvm/kvm_mm.h
> @@ -20,6 +20,11 @@
>  #define KVM_MMU_UNLOCK(kvm)            spin_unlock(&(kvm)->mmu_lock)
>  #endif /* KVM_HAVE_MMU_RWLOCK */
>
> +#ifndef KVM_MMU_LOCK_FOR_DIRTY_LOG_PROTECT
> +#define KVM_MMU_LOCK_FOR_DIRTY_LOG_PROTECT     KVM_MMU_LOCK
> +#define KVM_MMU_UNLOCK_FOR_DIRTY_LOG_PROTECT   KVM_MMU_UNLOCK
> +#endif
> +
>  kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible=
,
>                      bool *async, bool write_fault, bool *writable);
>
>

