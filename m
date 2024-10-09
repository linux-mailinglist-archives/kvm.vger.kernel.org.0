Return-Path: <kvm+bounces-28354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C197A99763E
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 22:14:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C490E1C21C77
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 20:14:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E2AA1E1C16;
	Wed,  9 Oct 2024 20:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JJiSjLyy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2401B173336
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 20:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728504859; cv=none; b=RMr267zlrZwmKfr7bphWR3eZ/xm+YeOpGs4+NzEVLKLH6rEUjXHcG0Taa2ojbDnyYz3zVVgoivsmZqu3Z1u2EcM/Bw4iowofMaZlcZoF1Hei/i30nMxRIuA/2yRcrPA2f53oHN1+UwFiuxyQ/qaiBYVKlwwxmQGqFY2bzHpIJac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728504859; c=relaxed/simple;
	bh=BVtjgb/YYP4QvS77mL4PSspi83hHxUfOLZoWcc7WLlA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VtjYWUUg0ncZju28sDXbltVsHoZ9wP5vArVoEafQ6oCjuWSkEpzqhvwYV+WuF5wCCngdQQBFD4B5zMEz1DmoHsmFNzJ4eof1y9eghv2+HIXFHZ0rLYz8nU6xByDvLlEUQJM6HUNRW4yqcx+isLN84cnV42PriY7WSmU9pZsxda4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JJiSjLyy; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-431157f7e80so11235e9.1
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 13:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728504855; x=1729109655; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=00dvkUx7dowxRyLP14nGRMSqcFQqg69XRrk4zXSh3Ao=;
        b=JJiSjLyyI9oTG9QN6SAXEvHPKXm6gehyv5dmGL0/MqKkxAshhw8zpdn/6JASyMPjCn
         uJp6JUcwFAs7P3QaJp9V8jPQY9aLt4XdnD9BJUUPXZsMi3pcMvaZyfmpYF0SCGisXaFS
         Of30pHf7eUESLFn6yaK6aUWbhht1fh4AdFon5I1kPb+Ya7883HDpm9FPNyzF/JbGoGmw
         OlS6FP3JPAcvdgovuizWcm+jlpvAeX6EaR+E4DxKujMI/fonAgWJpBsxQHexDFw5iVgD
         lkZ5ry61OSv3nxbox+RwvFik5tmVl+IsE85/4MM5iYd/KwUSn8cXPJk9RFuzTpt33uZW
         hL+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728504855; x=1729109655;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=00dvkUx7dowxRyLP14nGRMSqcFQqg69XRrk4zXSh3Ao=;
        b=H0WlUWZPOh4FtAJaczfUtBWVSDjC5FQMPJ/PdZhbK62ZnyCYK8fJHWLY0H7t1n1CDr
         f1flBFfUZDM1kxDILaekSp+FlslaHxPdZD7SvFuAc/m/QADO7Z45tfVFXxgls/Rj8Sxi
         erbvRfIO9bb8ynDaI5UvMqAn6ltjJ0vrdKYAFuN+QtLv/xKWWWNEbmxl9+580NjGWy08
         88x+mQ4ehLsg8f+G8c3K5i0fcU4v6nmbzE1jELqBG2zdIQLud8WYEVdIOveUyvxJxTOu
         reRA98F2XTuLH8298TcEUc2v9KaYrBHyL4jhjZggvmEz5nOybiD1DSedJp2lemIjc8hj
         4xWQ==
X-Forwarded-Encrypted: i=1; AJvYcCWxvC7q5m/oXxzhlz3Mt8L4uU8QGgQsRV7AiAOl81Z93Z+xbj4Rq5AfdQ+5ARJMI/MNb/U=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtC+AyWUHGPv6FDPWmbLHvTuUzDM/2y+OJPuOIUqJq5diE8Ygv
	UQajKXs4On3mqu7vAtasMRavKpz9zp0Z8Y8opoyjYsjeq3yGT5YrlPNWk9EZnTkfrKfJx+CWupz
	vgwG+40Zba3CmigsIRJqPrclYlvwZsrq1ZZfY
X-Google-Smtp-Source: AGHT+IERrmlIt9QcjUaPDNCzfWlCpl13jC7IdXa4U/ODkNRpSvURDowoy6IvUKjnwww9bh0lvRB0+LqZ8b4NcursxD0=
X-Received: by 2002:a05:600c:1d92:b0:42c:acd7:b59b with SMTP id
 5b1f17b1804b1-431161b38e1mr906765e9.6.1728504855085; Wed, 09 Oct 2024
 13:14:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240829-guest-memfd-lib-v2-0-b9afc1ff3656@quicinc.com> <20240829-guest-memfd-lib-v2-2-b9afc1ff3656@quicinc.com>
In-Reply-To: <20240829-guest-memfd-lib-v2-2-b9afc1ff3656@quicinc.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Thu, 10 Oct 2024 01:44:01 +0530
Message-ID: <CAGtprH_JP2w-4rq02h_Ugvq5KuHX7TUvegOS7xUs_iy5hriE7g@mail.gmail.com>
Subject: Re: [PATCH RFC v2 2/5] mm: guest_memfd: Allow folios to be accessible
 to host
To: Elliot Berman <quic_eberman@quicinc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Fuad Tabba <tabba@google.com>, David Hildenbrand <david@redhat.com>, Patrick Roy <roypat@amazon.co.uk>, 
	qperret@google.com, Ackerley Tng <ackerleytng@google.com>, 
	Mike Rapoport <rppt@kernel.org>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
	linux-coco@lists.linux.dev, linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 30, 2024 at 3:55=E2=80=AFAM Elliot Berman <quic_eberman@quicinc=
.com> wrote:
>
> Memory given to a confidential VM sometimes needs to be accessible by
> Linux. Before the VM starts, Linux needs to load some payload into
> the guest memory. While the VM is running, the guest may make some of
> the memory accessible to the host, e.g. to share virtqueue buffers. We
> choose less-used terminology here to avoid confusion with other terms
> (i.e. private). Memory is considered "accessible" when Linux (the host)
> can read/write to that memory. It is considered "inaccessible" when
> reads/writes aren't allowed by the hypervisor.
>
> Careful tracking of when the memory is supposed to be "inaccessible" and
> "accessible" is needed because hypervisors will fault Linux if we
> incorrectly access memory which shouldn't be accessed. On arm64 systems,
> this is a translation fault. On x86 systems, this could be a machine
> check.
>
> After discussion in [1], we are using 3 counters to track the state of a
> folio: the general folio_ref_count, a "safe" ref count, and an
> "accessible" counter.

This is a long due response after discussion at LPC. In order to
support hugepages with guest memfd, the current direction is to split
hugepages on memory conversion [1]. During LPC session [2], we
discussed the need of reconstructing split hugepages before giving
back the memory to hugepage allocator. After the session I discussed
this topic with David H and I think that the best way to handle
reconstruction would be to get a callback from folio_put when the last
refcount of pages backing guest shared memory is dropped. Reason being
that get/pin_user_pages* don't increase inode refcount and so
guest_memfd inode can get cleaned up while backing memory is still
pinned e.g. by VFIO pinning memory ranges to setup IOMMU pagetables.

If such a callback is supported, I believe we don't need to implement
the "safe refcount" logic.  shared -> private conversion (should be
similar for truncation) handling by guest_memfd may look like:
1) Drop all the guest_memfd internal refcounts on pages backing
converted ranges.
2) Tag such pages such that core-mm invokes a callback implemented by
guest_memfd when the last refcount gets dropped.
At this point I feel that the mechanism to achieve step 2 above should
be a small modification in core-mm logic which should be generic
enough and will not need piggy-backing on ZONE_DEVICE memory handling
which already carries similar logic [3].

Private memory doesn't need such a special callback since we discussed
at LPC about the desired policy to be:
1) Guest memfd owns all long-term refcounts on private memory.
2) Any short-term refcounts distributed outside guest_memfd should be
protected by folio locks.
3) On truncation/conversion, guest memfd private memory users will be
notified to unmap/refresh the memory mappings.

i.e. After private -> shared conversion, it would be guaranteed that
there are no active users of guest private memory.

[1] Linux MM Alignment Session:
https://lore.kernel.org/all/20240712232937.2861788-1-ackerleytng@google.com=
/
[2] https://lpc.events/event/18/contributions/1764/
[3] https://elixir.bootlin.com/linux/v6.11.2/source/mm/swap.c#L117

>
> Transition between accessible and inaccessible is allowed only when:
> 0. The folio is locked
> 1. The "accessible" counter is at 0.
> 2. The "safe" ref count equals the folio_ref_count.
> 3. The hypervisor allows it.
>
> The accessible counter can be used by Linux to guarantee the page stays
> accessible, without elevating the general refcount. When the accessible
> counter decrements to 0, we attempt to make the page inaccessible. When
> the accessible counters increments to 1, we attempt to make the page
> accessible.
>
> We expect the folio_ref_count to be nearly zero. The "nearly" amount is
> determined by the "safe" ref count value. The safe ref count isn't a
> signal whether the folio is accessible or not, it is only used to
> compare against the folio_ref_count.
>
> The final condition to transition between (in)accessible is whether the
> ->prepare_accessible or ->prepare_inaccessible guest_memfd_operation
> passes. In arm64 pKVM/Gunyah terms, the fallible "prepare_accessible"
> check is needed to ensure that the folio is unlocked by the guest and
> thus accessible to the host.
>
> When grabbing a folio, the client can either request for it to be
> accessible or inaccessible. If the folio already exists, we attempt to
> transition it to the state, if not already in that state. This will
> allow KVM or userspace to access guest_memfd *before* it is made
> inaccessible because KVM and userspace will use
> GUEST_MEMFD_GRAB_ACCESSIBLE.
>
> [1]: https://lore.kernel.org/all/a7c5bfc0-1648-4ae1-ba08-e706596e014b@red=
hat.com/
>
> Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
> ---
>  include/linux/guest_memfd.h |  10 ++
>  mm/guest_memfd.c            | 238 ++++++++++++++++++++++++++++++++++++++=
+++---
>  2 files changed, 236 insertions(+), 12 deletions(-)
>
> diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
> index 8785b7d599051..66e5d3ab42613 100644
> --- a/include/linux/guest_memfd.h
> +++ b/include/linux/guest_memfd.h
> @@ -22,17 +22,27 @@ struct guest_memfd_operations {
>         int (*invalidate_begin)(struct inode *inode, pgoff_t offset, unsi=
gned long nr);
>         void (*invalidate_end)(struct inode *inode, pgoff_t offset, unsig=
ned long nr);
>         int (*prepare_inaccessible)(struct inode *inode, struct folio *fo=
lio);
> +       int (*prepare_accessible)(struct inode *inode, struct folio *foli=
o);
>         int (*release)(struct inode *inode);
>  };
>
> +enum guest_memfd_grab_flags {
> +       GUEST_MEMFD_GRAB_INACCESSIBLE   =3D (0UL << 0),
> +       GUEST_MEMFD_GRAB_ACCESSIBLE     =3D (1UL << 0),
> +};
> +
>  enum guest_memfd_create_flags {
>         GUEST_MEMFD_FLAG_CLEAR_INACCESSIBLE =3D (1UL << 0),
>  };
>
>  struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u=
32 flags);
> +void guest_memfd_put_folio(struct folio *folio, unsigned int accessible_=
refs);
> +void guest_memfd_unsafe_folio(struct folio *folio);
>  struct file *guest_memfd_alloc(const char *name,
>                                const struct guest_memfd_operations *ops,
>                                loff_t size, unsigned long flags);
>  bool is_guest_memfd(struct file *file, const struct guest_memfd_operatio=
ns *ops);
> +int guest_memfd_make_accessible(struct folio *folio);
> +int guest_memfd_make_inaccessible(struct folio *folio);
>
>  #endif
> diff --git a/mm/guest_memfd.c b/mm/guest_memfd.c
> index c6cd01e6064a7..62cb576248a9d 100644
> --- a/mm/guest_memfd.c
> +++ b/mm/guest_memfd.c
> @@ -4,9 +4,33 @@
>   */
>
>  #include <linux/anon_inodes.h>
> +#include <linux/atomic.h>
>  #include <linux/falloc.h>
>  #include <linux/guest_memfd.h>
>  #include <linux/pagemap.h>
> +#include <linux/wait.h>
> +
> +#include "internal.h"
> +
> +static DECLARE_WAIT_QUEUE_HEAD(safe_wait);
> +
> +/**
> + * struct guest_memfd_private - private per-folio data
> + * @accessible: number of kernel users expecting folio to be accessible.
> + *              When zero, the folio converts to being inaccessible.
> + * @safe: number of "safe" references to the folio. Each reference is
> + *        aware that the folio can be made (in)accessible at any time.
> + */
> +struct guest_memfd_private {
> +       atomic_t accessible;
> +       atomic_t safe;
> +};
> +
> +static inline int base_safe_refs(struct folio *folio)
> +{
> +       /* 1 for filemap */
> +       return 1 + folio_nr_pages(folio);
> +}
>
>  /**
>   * guest_memfd_grab_folio() -- grabs a folio from the guest memfd
> @@ -35,21 +59,56 @@
>   */
>  struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u=
32 flags)
>  {
> -       unsigned long gmem_flags =3D (unsigned long)file->private_data;
> +       const bool accessible =3D flags & GUEST_MEMFD_GRAB_ACCESSIBLE;
>         struct inode *inode =3D file_inode(file);
>         struct guest_memfd_operations *ops =3D inode->i_private;
> +       struct guest_memfd_private *private;
> +       unsigned long gmem_flags;
>         struct folio *folio;
>         int r;
>
>         /* TODO: Support huge pages. */
> -       folio =3D filemap_grab_folio(inode->i_mapping, index);
> +       folio =3D __filemap_get_folio(inode->i_mapping, index,
> +                       FGP_LOCK | FGP_ACCESSED | FGP_CREAT | FGP_STABLE,
> +                       mapping_gfp_mask(inode->i_mapping));
>         if (IS_ERR(folio))
>                 return folio;
>
> -       if (folio_test_uptodate(folio))
> +       if (folio_test_uptodate(folio)) {
> +               private =3D folio_get_private(folio);
> +               atomic_inc(&private->safe);
> +               if (accessible)
> +                       r =3D guest_memfd_make_accessible(folio);
> +               else
> +                       r =3D guest_memfd_make_inaccessible(folio);
> +
> +               if (r) {
> +                       atomic_dec(&private->safe);
> +                       goto out_err;
> +               }
> +
> +               wake_up_all(&safe_wait);
>                 return folio;
> +       }
>
> -       folio_wait_stable(folio);
> +       private =3D kmalloc(sizeof(*private), GFP_KERNEL);
> +       if (!private) {
> +               r =3D -ENOMEM;
> +               goto out_err;
> +       }
> +
> +       folio_attach_private(folio, private);
> +       /*
> +        * 1 for us
> +        * 1 for unmapping from userspace
> +        */
> +       atomic_set(&private->accessible, accessible ? 2 : 0);
> +       /*
> +        * +1 for us
> +        */
> +       atomic_set(&private->safe, 1 + base_safe_refs(folio));
> +
> +       gmem_flags =3D (unsigned long)inode->i_mapping->i_private_data;
>
>         /*
>          * Use the up-to-date flag to track whether or not the memory has=
 been
> @@ -57,19 +116,26 @@ struct folio *guest_memfd_grab_folio(struct file *fi=
le, pgoff_t index, u32 flags
>          * storage for the memory, so the folio will remain up-to-date un=
til
>          * it's removed.
>          */
> -       if (gmem_flags & GUEST_MEMFD_FLAG_CLEAR_INACCESSIBLE) {
> +       if (accessible || (gmem_flags & GUEST_MEMFD_FLAG_CLEAR_INACCESSIB=
LE)) {
>                 unsigned long nr_pages =3D folio_nr_pages(folio);
>                 unsigned long i;
>
>                 for (i =3D 0; i < nr_pages; i++)
>                         clear_highpage(folio_page(folio, i));
> -
>         }
>
> -       if (ops->prepare_inaccessible) {
> -               r =3D ops->prepare_inaccessible(inode, folio);
> -               if (r < 0)
> -                       goto out_err;
> +       if (accessible) {
> +               if (ops->prepare_accessible) {
> +                       r =3D ops->prepare_accessible(inode, folio);
> +                       if (r < 0)
> +                               goto out_free;
> +               }
> +       } else {
> +               if (ops->prepare_inaccessible) {
> +                       r =3D ops->prepare_inaccessible(inode, folio);
> +                       if (r < 0)
> +                               goto out_free;
> +               }
>         }
>
>         folio_mark_uptodate(folio);
> @@ -78,6 +144,8 @@ struct folio *guest_memfd_grab_folio(struct file *file=
, pgoff_t index, u32 flags
>          * unevictable and there is no storage to write back to.
>          */
>         return folio;
> +out_free:
> +       kfree(private);
>  out_err:
>         folio_unlock(folio);
>         folio_put(folio);
> @@ -85,6 +153,132 @@ struct folio *guest_memfd_grab_folio(struct file *fi=
le, pgoff_t index, u32 flags
>  }
>  EXPORT_SYMBOL_GPL(guest_memfd_grab_folio);
>
> +/**
> + * guest_memfd_put_folio() - Drop safe and accessible references to a fo=
lio
> + * @folio: the folio to drop references to
> + * @accessible_refs: number of accessible refs to drop, 0 if holding a
> + *                   reference to an inaccessible folio.
> + */
> +void guest_memfd_put_folio(struct folio *folio, unsigned int accessible_=
refs)
> +{
> +       struct guest_memfd_private *private =3D folio_get_private(folio);
> +
> +       WARN_ON_ONCE(atomic_sub_return(accessible_refs, &private->accessi=
ble) < 0);
> +       atomic_dec(&private->safe);
> +       folio_put(folio);
> +       wake_up_all(&safe_wait);
> +}
> +EXPORT_SYMBOL_GPL(guest_memfd_put_folio);
> +
> +/**
> + * guest_memfd_unsafe_folio() - Demotes the current folio reference to "=
unsafe"
> + * @folio: the folio to demote
> + *
> + * Decrements the number of safe references to this folio. The folio wil=
l not
> + * transition to inaccessible until the folio_ref_count is also decremen=
ted.
> + *
> + * This function does not release the folio reference count.
> + */
> +void guest_memfd_unsafe_folio(struct folio *folio)
> +{
> +       struct guest_memfd_private *private =3D folio_get_private(folio);
> +
> +       atomic_dec(&private->safe);
> +       wake_up_all(&safe_wait);
> +}
> +EXPORT_SYMBOL_GPL(guest_memfd_unsafe_folio);
> +
> +/**
> + * guest_memfd_make_accessible() - Attempt to make the folio accessible =
to host
> + * @folio: the folio to make accessible
> + *
> + * Makes the given folio accessible to the host. If the folio is current=
ly
> + * inaccessible, attempts to convert it to accessible. Otherwise, return=
s with
> + * EBUSY.
> + *
> + * This function may sleep.
> + */
> +int guest_memfd_make_accessible(struct folio *folio)
> +{
> +       struct guest_memfd_private *private =3D folio_get_private(folio);
> +       struct inode *inode =3D folio_inode(folio);
> +       struct guest_memfd_operations *ops =3D inode->i_private;
> +       int r;
> +
> +       /*
> +        * If we already know the folio is accessible, then no need to do
> +        * anything else.
> +        */
> +       if (atomic_inc_not_zero(&private->accessible))
> +               return 0;
> +
> +       r =3D wait_event_timeout(safe_wait,
> +                              folio_ref_count(folio) =3D=3D atomic_read(=
&private->safe),
> +                              msecs_to_jiffies(10));
> +       if (!r)
> +               return -EBUSY;
> +
> +       if (ops->prepare_accessible) {
> +               r =3D ops->prepare_accessible(inode, folio);
> +               if (r)
> +                       return r;
> +       }
> +
> +       atomic_inc(&private->accessible);
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(guest_memfd_make_accessible);
> +
> +/**
> + * guest_memfd_make_inaccessible() - Attempt to make the folio inaccessi=
ble
> + * @folio: the folio to make inaccessible
> + *
> + * Makes the given folio inaccessible to the host. IF the folio is curre=
ntly
> + * accessible, attempt so convert it to inaccessible. Otherwise, returns=
 with
> + * EBUSY.
> + *
> + * Conversion to inaccessible is allowed when ->accessible decrements to=
 zero,
> + * the folio safe counter =3D=3D folio reference counter, the folio is u=
nmapped
> + * from host, and ->prepare_inaccessible returns it's ready to do so.
> + *
> + * This function may sleep.
> + */
> +int guest_memfd_make_inaccessible(struct folio *folio)
> +{
> +       struct guest_memfd_private *private =3D folio_get_private(folio);
> +       struct inode *inode =3D folio_inode(folio);
> +       struct guest_memfd_operations *ops =3D inode->i_private;
> +       int r;
> +
> +       r =3D atomic_dec_if_positive(&private->accessible);
> +       if (r < 0)
> +               return 0;
> +       else if (r > 0)
> +               return -EBUSY;
> +
> +       unmap_mapping_folio(folio);
> +
> +       r =3D wait_event_timeout(safe_wait,
> +                              folio_ref_count(folio) =3D=3D atomic_read(=
&private->safe),
> +                              msecs_to_jiffies(10));
> +       if (!r) {
> +               r =3D -EBUSY;
> +               goto err;
> +       }
> +
> +       if (ops->prepare_inaccessible) {
> +               r =3D ops->prepare_inaccessible(inode, folio);
> +               if (r)
> +                       goto err;
> +       }
> +
> +       return 0;
> +err:
> +       atomic_inc(&private->accessible);
> +       return r;
> +}
> +EXPORT_SYMBOL_GPL(guest_memfd_make_inaccessible);
> +
>  static long gmem_punch_hole(struct file *file, loff_t offset, loff_t len=
)
>  {
>         struct inode *inode =3D file_inode(file);
> @@ -229,10 +423,12 @@ static int gmem_error_folio(struct address_space *m=
apping, struct folio *folio)
>
>  static bool gmem_release_folio(struct folio *folio, gfp_t gfp)
>  {
> +       struct guest_memfd_private *private =3D folio_get_private(folio);
>         struct inode *inode =3D folio_inode(folio);
>         struct guest_memfd_operations *ops =3D inode->i_private;
>         off_t offset =3D folio->index;
>         size_t nr =3D folio_nr_pages(folio);
> +       unsigned long val, expected;
>         int ret;
>
>         ret =3D ops->invalidate_begin(inode, offset, nr);
> @@ -241,14 +437,32 @@ static bool gmem_release_folio(struct folio *folio,=
 gfp_t gfp)
>         if (ops->invalidate_end)
>                 ops->invalidate_end(inode, offset, nr);
>
> +       expected =3D base_safe_refs(folio);
> +       val =3D atomic_read(&private->safe);
> +       WARN_ONCE(val !=3D expected, "folio[%x] safe ref: %d !=3D expecte=
d %d\n",
> +                 folio_index(folio), val, expected);
> +
> +       folio_detach_private(folio);
> +       kfree(private);
> +
>         return true;
>  }
>
> +static void gmem_invalidate_folio(struct folio *folio, size_t offset, si=
ze_t len)
> +{
> +       WARN_ON_ONCE(offset !=3D 0);
> +       WARN_ON_ONCE(len !=3D folio_size(folio));
> +
> +       if (offset =3D=3D 0 && len =3D=3D folio_size(folio))
> +               filemap_release_folio(folio, 0);
> +}
> +
>  static const struct address_space_operations gmem_aops =3D {
>         .dirty_folio =3D noop_dirty_folio,
>         .migrate_folio =3D gmem_migrate_folio,
>         .error_remove_folio =3D gmem_error_folio,
>         .release_folio =3D gmem_release_folio,
> +       .invalidate_folio =3D gmem_invalidate_folio,
>  };
>
>  static inline bool guest_memfd_check_ops(const struct guest_memfd_operat=
ions *ops)
> @@ -291,8 +505,7 @@ struct file *guest_memfd_alloc(const char *name,
>          * instead of reusing a single inode.  Each guest_memfd instance =
needs
>          * its own inode to track the size, flags, etc.
>          */
> -       file =3D anon_inode_create_getfile(name, &gmem_fops, (void *)flag=
s,
> -                                        O_RDWR, NULL);
> +       file =3D anon_inode_create_getfile(name, &gmem_fops, NULL, O_RDWR=
, NULL);
>         if (IS_ERR(file))
>                 return file;
>
> @@ -303,6 +516,7 @@ struct file *guest_memfd_alloc(const char *name,
>
>         inode->i_private =3D (void *)ops; /* discards const qualifier */
>         inode->i_mapping->a_ops =3D &gmem_aops;
> +       inode->i_mapping->i_private_data =3D (void *)flags;
>         inode->i_mode |=3D S_IFREG;
>         inode->i_size =3D size;
>         mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
>
> --
> 2.34.1
>
>

