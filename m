Return-Path: <kvm+bounces-25255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F1CD962A16
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 16:24:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 832801F24D83
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 14:24:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C4E018C91A;
	Wed, 28 Aug 2024 14:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a2Xor3QV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F08189900
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 14:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724855071; cv=none; b=rC0E+q/WbfbQB+zDNrUiuJJfPp+z9R+5hu0OJKi1YijUro+7eilDp6zCIzvOEZ2RYMrA9bgHY37OJpAAzIIt3NWLA3P5OhPgR2Mcrdv944nQ+5LYApcZfEYLXZyXpMK45xON8HHL5uIcVM5YC5P4e4NjvrMxB7GPMr2jW5v63Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724855071; c=relaxed/simple;
	bh=ioXy8of+N3MrucytfolPiEEAsJj9nz3fGmpkxDrHO1U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OmO/IYG41+aKVipYeJOvAGNcJGg+75F9OrvTTDp5m9WJ4Bw2bnZUYHYN6g73EQfRtqYO0tznsG5EzAwGBQzVacrnt/ELPJsWxC7NZjlu5ANuEiSHd20FeHg8VfMnBTP236hEsBdsQEHpfx9HqzujWXqRnG4koI4QXZ2g8WJFZvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a2Xor3QV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724855068;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=355PW4sSqsC1A4aL38kel0SH9CqCQG/5oU1R6gXP9T0=;
	b=a2Xor3QV327/xt4ww+iOj2cToVEojVFZPPJZGxITwEwjbDL1H/dSjQuqO6k4dUeHr4aNhV
	o6bSXK17wsZm4RBM/xhBxassVmtQV9TqsTcwa7f9ms6Sr819P8UqaJ4fSeNf91Qr0wlJuI
	+bG8/AH6HaczI8qEsb8l6JwciwfszZ4=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-208-Y4ycay76N-KYZ79Pa3y4ow-1; Wed, 28 Aug 2024 10:24:12 -0400
X-MC-Unique: Y4ycay76N-KYZ79Pa3y4ow-1
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-5dcaed3bad8so8590719eaf.3
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 07:24:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724855052; x=1725459852;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=355PW4sSqsC1A4aL38kel0SH9CqCQG/5oU1R6gXP9T0=;
        b=SRZoaXjEujPl9TCPFRXiUCPwxH+ipKHZa2CDexaYzf8SYV5O19ZPoQSB0Msq4Bz830
         OM8rnNTaaa5ISQjEnzUuX3bTLxsFlPkpPkDV1IOsFQi7uqGzDx1M0SYbkl4bPcCmAdKn
         uM11QyXRIH0cbVpB5pBeUyHMCHOioTebs2glDEdxDtfL6hKSCjEfQKQH9yACcxcpS2CZ
         X6dgg+AQ9KuLduVJayVchj2NtfLrvP198Oh+8sWICm8P+F59fNG8S7wTMbH9pFoJ8Kur
         8LSjWzn1yQWV2NzbrkWnrQwRZcykMD1AB10Enrwq8JJRkRcQuEkEkWRnG/ZBqjU/2+9Q
         8uwQ==
X-Forwarded-Encrypted: i=1; AJvYcCU2S307iE13gaNMkKH8Cr1Twr1FwtvACWl603QahiRXVxDAcJgw7za2yUo4wkfT0KuraMM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzpIwLmdZcNXr0q35E0hAVqtd+ui3kfGaR/3NbnhWxOGPxG1DEW
	WJI5pwFUETdpmLrmmkFYG+JaS/A/SzFC4l3BqAVy4Q4TysyDvhqEdiEK2ZbljvBS0Peyd1KUJ9z
	Pxg5SvpJxho1mK5ivdH3qqgpKjHVJsniu8q/3916BvfvaJapsGA==
X-Received: by 2002:a05:6820:22a9:b0:5d8:6769:9d85 with SMTP id 006d021491bc7-5dcc6259314mr17483958eaf.6.1724855051611;
        Wed, 28 Aug 2024 07:24:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHrf66e2cWOHb1ey05OprbItKe0gmFxS5nGBvoISWxV5VBk1weYo4yvuE0vLG+8egFr0ZhZGA==
X-Received: by 2002:a05:6820:22a9:b0:5d8:6769:9d85 with SMTP id 006d021491bc7-5dcc6259314mr17483914eaf.6.1724855051201;
        Wed, 28 Aug 2024 07:24:11 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5dcb5e9451bsm3044256eaf.42.2024.08.28.07.24.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2024 07:24:10 -0700 (PDT)
Date: Wed, 28 Aug 2024 10:24:05 -0400
From: Peter Xu <peterx@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Gavin Shan <gshan@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>, x86@kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Alistair Popple <apopple@nvidia.com>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Jason Gunthorpe <jgg@nvidia.com>, Borislav Petkov <bp@alien8.de>,
	Zi Yan <ziy@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>,
	Yan Zhao <yan.y.zhao@intel.com>, Will Deacon <will@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v2 06/19] mm/pagewalk: Check pfnmap for folio_walk_start()
Message-ID: <Zs8zBT1aDh1v9Eje@x1n>
References: <20240826204353.2228736-1-peterx@redhat.com>
 <20240826204353.2228736-7-peterx@redhat.com>
 <9f9d7e96-b135-4830-b528-37418ae7bbfd@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9f9d7e96-b135-4830-b528-37418ae7bbfd@redhat.com>

On Wed, Aug 28, 2024 at 09:44:04AM +0200, David Hildenbrand wrote:
> On 26.08.24 22:43, Peter Xu wrote:
> > Teach folio_walk_start() to recognize special pmd/pud mappings, and fail
> > them properly as it means there's no folio backing them.
> > 
> > Cc: David Hildenbrand <david@redhat.com>
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> > ---
> >   mm/pagewalk.c | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> > index cd79fb3b89e5..12be5222d70e 100644
> > --- a/mm/pagewalk.c
> > +++ b/mm/pagewalk.c
> > @@ -753,7 +753,7 @@ struct folio *folio_walk_start(struct folio_walk *fw,
> >   		fw->pudp = pudp;
> >   		fw->pud = pud;
> > -		if (!pud_present(pud) || pud_devmap(pud)) {
> > +		if (!pud_present(pud) || pud_devmap(pud) || pud_special(pud)) {
> >   			spin_unlock(ptl);
> >   			goto not_found;
> >   		} else if (!pud_leaf(pud)) {
> > @@ -783,7 +783,7 @@ struct folio *folio_walk_start(struct folio_walk *fw,
> >   		fw->pmdp = pmdp;
> >   		fw->pmd = pmd;
> > -		if (pmd_none(pmd)) {
> > +		if (pmd_none(pmd) || pmd_special(pmd)) {
> >   			spin_unlock(ptl);
> >   			goto not_found;
> >   		} else if (!pmd_leaf(pmd)) {
> 
> As raised, this is not the right way to to it. You should follow what
> CONFIG_ARCH_HAS_PTE_SPECIAL and vm_normal_page() does.
> 
> It's even spelled out in vm_normal_page_pmd() that at the time it was
> introduced there was no pmd_special(), so there was no way to handle that.

I can try to do something like that, but even so it'll be mostly cosmetic
changes, and AFAICT there's no real functional difference.

Meanwhile, see below comment.

> 
> 
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index f0cf5d02b4740..272445e9db147 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -672,15 +672,29 @@ struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
>  {
>         unsigned long pfn = pmd_pfn(pmd);
> -       /*
> -        * There is no pmd_special() but there may be special pmds, e.g.
> -        * in a direct-access (dax) mapping, so let's just replicate the
> -        * !CONFIG_ARCH_HAS_PTE_SPECIAL case from vm_normal_page() here.
> -        */

This one is correct; I overlooked this comment which can be obsolete.  I
can either refine this patch or add one patch on top to refine the comment
at least.

> +       if (IS_ENABLED(CONFIG_ARCH_HAS_PMD_SPECIAL)) {

We don't yet have CONFIG_ARCH_HAS_PMD_SPECIAL, but I get your point.

> +               if (likely(!pmd_special(pmd)))
> +                       goto check_pfn;
> +               if (vma->vm_ops && vma->vm_ops->find_special_page)
> +                       return vma->vm_ops->find_special_page(vma, addr);

Why do we ever need this?  This is so far destined to be totally a waste of
cycles.  I think it's better we leave that until either xen/gntdev.c or any
new driver start to use it, rather than keeping dead code around.

> +               if (vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP))
> +                       return NULL;
> +               if (is_huge_zero_pmd(pmd))
> +                       return NULL;

This is meaningless too until we make huge zero pmd apply special bit
first, which does sound like to be outside the scope of this series.

> +               if (pmd_devmap(pmd))
> +                       /* See vm_normal_page() */
> +                       return NULL;

When will it be pmd_devmap() if it's already pmd_special()?

> +               return NULL;

And see this one.. it's after:

  if (xxx)
      return NULL;
  if (yyy)
      return NULL;
  if (zzz)
      return NULL;
  return NULL;

Hmm??  If so, what's the difference if we simply check pmd_special and
return NULL..

> +       }
> +
> +       /* !CONFIG_ARCH_HAS_PMD_SPECIAL case follows: */
> +
>         if (unlikely(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP))) {
>                 if (vma->vm_flags & VM_MIXEDMAP) {
>                         if (!pfn_valid(pfn))
>                                 return NULL;
> +                       if (is_huge_zero_pmd(pmd))
> +                               return NULL;

I'd rather not touch here as this series doesn't change anything for
MIXEDMAP yet..

>                         goto out;
>                 } else {
>                         unsigned long off;
> @@ -692,6 +706,11 @@ struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
>                 }
>         }
> +       /*
> +        * For historical reasons, these might not have pmd_special() set,
> +        * so we'll check them manually, in contrast to vm_normal_page().
> +        */
> +check_pfn:
>         if (pmd_devmap(pmd))
>                 return NULL;
>         if (is_huge_zero_pmd(pmd))
> 
> 
> 
> We should then look into mapping huge zeropages also with pmd_special.
> pmd_devmap we'll leave alone until removed. But that's indeoendent of your series.

This does look reasonable to match what we do with pte zeropage.  Could you
remind me what might be the benefit when we switch to using special bit for
pmd zero pages?

> 
> I wonder if CONFIG_ARCH_HAS_PTE_SPECIAL is sufficient and we don't need additional
> CONFIG_ARCH_HAS_PMD_SPECIAL.

The hope is we can always reuse the bit in the pte to work the same for
pmd/pud.

Now we require arch to select ARCH_SUPPORTS_HUGE_PFNMAP to say "pmd/pud has
the same special bit defined".

> 
> As I said, if you need someone to add vm_normal_page_pud(), I can handle that.

I'm pretty confused why we need that for this series alone.

If you prefer vm_normal_page_pud() to be defined and check pud_special()
there, I can do that.  But again, I don't yet see how that can make a
functional difference considering the so far very limited usage of the
special bit, and wonder whether we can do that on top when it became
necessary (and when we start to have functional requirement of such).

Thanks,

-- 
Peter Xu


