Return-Path: <kvm+bounces-10102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FBBC869D49
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 18:13:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E452A1F25DBB
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 17:13:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 657734CB20;
	Tue, 27 Feb 2024 17:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Fj9QyAmS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084A3249EB
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 17:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709053991; cv=none; b=KgmEC+uPxxZHuV09d1trnz9U2ikqyYDO3SZOH3ChBvnIDZtLCBu+/qeOV79EzDKkyK5sR3g89i94VzrhulWD9MwT1caqUx3ZBZaF4Q6qi/sRGgO+J+k3C+wzLOoTbCewni1IVsS4rjU74wvSen6qQmJZfzJF4afbNr6YeIF6rUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709053991; c=relaxed/simple;
	bh=SWlb2BlxVRz858KyACzU9TGdZmZCIXkEAFtIFfCbVDQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eHd5I/NIkE4HT1jp+mv5J6JzM/9v2M6emcvZeZwTubDxvRpzG7JJEVgQ70On9j2QM06aRelFIcYDKPF/CgtBJbmV1JOJGw4uLhmEhKGP3FBnHbVmFWaUZBQzujldSatqTpCy+AQL1uff36EgZRH6oGD2Ns86ScTkoJ4WdGluY3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Fj9QyAmS; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-5a054fa636eso2524690eaf.0
        for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 09:13:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709053988; x=1709658788; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l4w4THpRXMgaO2N+PLLuITl0YtMqqfXqaqVn9NdnEso=;
        b=Fj9QyAmSsTiuHqlNFVYfzvBqc2Snd/wc5S3SGSU2tr5rQCtTCiVCDVkl7MdXYGi+/i
         sb/wPQQl7o/vcO9D0dgFqnETzRU81nHyFvcH+yZQcFqOaK0oSegjpJybrGLlQ0ZmSRH6
         JsSuiEdx5BA1wfI5OJb40K+WbUdxUuuwbgUKO7Br74zzXA3vLmqpwzHT8Uj/szi0Uj1b
         7OAxUpzsojhdvR94ZPSIrenKmA+EuJVxBf0Rt1IYC/WwEggfx+A9ksZORXvFW9N2EJkJ
         p85RkFOfHdmQSfl5LfKvBhTzXtR7YhB9ffofZ7FjT8yyUFEmKugFMZrObHf8jN/CKoRj
         CkjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709053988; x=1709658788;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l4w4THpRXMgaO2N+PLLuITl0YtMqqfXqaqVn9NdnEso=;
        b=IA1mKA8lN8y3HAenwPy6OiwoH2DqLjUMJGkEmOT1yjgu4L1Z3Y5JydDYxBC1tjDkyb
         qzLzZ+1xnRFNTbDSVKQ2HOlXyYn+QkztjbFBvxveq7dfdswasNUQvPp6vToDdXDCE179
         4wu9MAA0cZWT/DYOWuJf3NZk+eqrtGM5aBf+K2+HP8qtmKxySOqoB4X+tCS4Ew5iRQRV
         eRzUrCuYpu6c0VPmY86MFJs8i5Pk72yLrkbZ4mNcgzCg0TOoNKkfdGmJ58giWPfP9I/m
         1aO363VXVoKuq/Bdlk4auuyrQx3MAEfAEdkSZ1cBSoX/xIB0ES9jF52SlOHsO4A/rB3P
         Lbog==
X-Forwarded-Encrypted: i=1; AJvYcCVZK4rtN5nxRTF+bAPuxotIP3XPbrWDMPRmCg0u+lf5LNZB6TQ6WYdRsN94ceP0IQ5tfH4KBFegc/uUS1jGE55DnIUU
X-Gm-Message-State: AOJu0YyIn7xdj97TmyvejhN8M0h3uB5PLsn9kX4o0ovna/HmGzZS7NHp
	eP2jLQMiVEsyfjD4E7mdswUrvFJRtsbESGHV+uIYfB+jgStSIzHKJmmfiDFiQBgimxQoLqwNHUx
	iyl5BI+kjIlGP7nBb9/1RRn6+DG7FNK3/EZ5U
X-Google-Smtp-Source: AGHT+IG4NLP9w08aTBX6ChmfOuNBrO//8IOWcDelgzmmzT45Z6RFkmBGUjqHH2I7/3vyEZJraFaKzHOfDRMNSwwlpGI=
X-Received: by 2002:a05:6820:2c07:b0:5a0:651d:4238 with SMTP id
 dw7-20020a0568202c0700b005a0651d4238mr7449063oob.2.1709053988360; Tue, 27 Feb
 2024 09:13:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240213192340.2023366-1-avagin@google.com>
In-Reply-To: <20240213192340.2023366-1-avagin@google.com>
From: Andrei Vagin <avagin@google.com>
Date: Tue, 27 Feb 2024 09:12:55 -0800
Message-ID: <CAEWA0a6rxNsX6t+Fj_UOKPEZP1g1ePAL8QqZCSMmE0_nc_RFWw@mail.gmail.com>
Subject: Re: [PATCH v3] kvm/x86: allocate the write-tracking metadata on-demand
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, 
	Zhenyu Wang <zhenyuw@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Paolo and Sean,

Can we move forward with this version? Do you have any other comments,
suggestions?

Thanks,
Andrrei

On Tue, Feb 13, 2024 at 11:23=E2=80=AFAM Andrei Vagin <avagin@google.com> w=
rote:
>
> The write-track is used externally only by the gpu/drm/i915 driver.
> Currently, it is always enabled, if a kernel has been compiled with this
> driver.
>
> Enabling the write-track mechanism adds a two-byte overhead per page acro=
ss
> all memory slots. It isn't significant for regular VMs. However in gVisor=
,
> where the entire process virtual address space is mapped into the VM, eve=
n
> with a 39-bit address space, the overhead amounts to 256MB.
>
> Rework the write-tracking mechanism to enable it on-demand in
> kvm_page_track_register_notifier.
>
> Here is Sean's comment about the locking scheme:
>
> The only potential hiccup would be if taking slots_arch_lock would
> deadlock, but it should be impossible for slots_arch_lock to be taken in
> any other path that involves VFIO and/or KVMGT *and* can be coincident.
> Except for kvm_arch_destroy_vm() (which deletes KVM's internal
> memslots), slots_arch_lock is taken only through KVM ioctls(), and the
> caller of kvm_page_track_register_notifier() *must* hold a reference to
> the VM.
>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Andrei Vagin <avagin@google.com>
> ---
> v1: https://lore.kernel.org/lkml/ZcErs9rPqT09nNge@google.com/T/
> v2: allocate the write-tracking metadata on-demand
>     https://lore.kernel.org/kvm/20240206153405.489531-1-avagin@google.com=
/
> v3: explicitly track if there are *external* write tracking users.
>
>  arch/x86/include/asm/kvm_host.h |  9 +++++
>  arch/x86/kvm/mmu/page_track.c   | 68 ++++++++++++++++++++++++++++++++-
>  2 files changed, 75 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index d271ba20a0b2..a777ac77b3ea 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1468,6 +1468,15 @@ struct kvm_arch {
>          */
>         bool shadow_root_allocated;
>
> +#ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING
> +       /*
> +        * If set, the VM has (or had) an external write tracking user, a=
nd
> +        * thus all write tracking metadata has been allocated, even if K=
VM
> +        * itself isn't using write tracking.
> +        */
> +       bool external_write_tracking_enabled;
> +#endif
> +
>  #if IS_ENABLED(CONFIG_HYPERV)
>         hpa_t   hv_root_tdp;
>         spinlock_t hv_root_tdp_lock;
> diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.=
c
> index c87da11f3a04..f6448284c18e 100644
> --- a/arch/x86/kvm/mmu/page_track.c
> +++ b/arch/x86/kvm/mmu/page_track.c
> @@ -20,10 +20,23 @@
>  #include "mmu_internal.h"
>  #include "page_track.h"
>
> +static bool kvm_external_write_tracking_enabled(struct kvm *kvm)
> +{
> +#ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING
> +       /*
> +        * Read external_write_tracking_enabled before related pointers. =
 Pairs
> +        * with the smp_store_release in kvm_page_track_write_tracking_en=
able().
> +        */
> +       return smp_load_acquire(&kvm->arch.external_write_tracking_enable=
d);
> +#else
> +       return false;
> +#endif
> +}
> +
>  bool kvm_page_track_write_tracking_enabled(struct kvm *kvm)
>  {
> -       return IS_ENABLED(CONFIG_KVM_EXTERNAL_WRITE_TRACKING) ||
> -              !tdp_enabled || kvm_shadow_root_allocated(kvm);
> +       return kvm_external_write_tracking_enabled(kvm) ||
> +              kvm_shadow_root_allocated(kvm) || !tdp_enabled;
>  }
>
>  void kvm_page_track_free_memslot(struct kvm_memory_slot *slot)
> @@ -153,6 +166,50 @@ int kvm_page_track_init(struct kvm *kvm)
>         return init_srcu_struct(&head->track_srcu);
>  }
>
> +static int kvm_enable_external_write_tracking(struct kvm *kvm)
> +{
> +       struct kvm_memslots *slots;
> +       struct kvm_memory_slot *slot;
> +       int r =3D 0, i, bkt;
> +
> +       mutex_lock(&kvm->slots_arch_lock);
> +
> +       /*
> +        * Check for *any* write tracking user (not just external users) =
under
> +        * lock.  This avoids unnecessary work, e.g. if KVM itself is usi=
ng
> +        * write tracking, or if two external users raced when registerin=
g.
> +        */
> +       if (kvm_page_track_write_tracking_enabled(kvm))
> +               goto out_success;
> +
> +       for (i =3D 0; i < kvm_arch_nr_memslot_as_ids(kvm); i++) {
> +               slots =3D __kvm_memslots(kvm, i);
> +               kvm_for_each_memslot(slot, bkt, slots) {
> +                       /*
> +                        * Intentionally do NOT free allocations on failu=
re to
> +                        * avoid having to track which allocations were m=
ade
> +                        * now versus when the memslot was created.  The
> +                        * metadata is guaranteed to be freed when the sl=
ot is
> +                        * freed, and will be kept/used if userspace retr=
ies
> +                        * the failed ioctl() instead of killing the VM.
> +                        */
> +                       r =3D kvm_page_track_write_tracking_alloc(slot);
> +                       if (r)
> +                               goto out_unlock;
> +               }
> +       }
> +
> +out_success:
> +       /*
> +        * Ensure that external_write_tracking_enabled becomes true stric=
tly
> +        * after all the related pointers are set.
> +        */
> +       smp_store_release(&kvm->arch.external_write_tracking_enabled, tru=
e);
> +out_unlock:
> +       mutex_unlock(&kvm->slots_arch_lock);
> +       return r;
> +}
> +
>  /*
>   * register the notifier so that event interception for the tracked gues=
t
>   * pages can be received.
> @@ -161,10 +218,17 @@ int kvm_page_track_register_notifier(struct kvm *kv=
m,
>                                      struct kvm_page_track_notifier_node =
*n)
>  {
>         struct kvm_page_track_notifier_head *head;
> +       int r;
>
>         if (!kvm || kvm->mm !=3D current->mm)
>                 return -ESRCH;
>
> +       if (!kvm_external_write_tracking_enabled(kvm)) {
> +               r =3D kvm_enable_external_write_tracking(kvm);
> +               if (r)
> +                       return r;
> +       }
> +
>         kvm_get_kvm(kvm);
>
>         head =3D &kvm->arch.track_notifier_head;
> --
> 2.43.0.687.g38aa6559b0-goog
>

