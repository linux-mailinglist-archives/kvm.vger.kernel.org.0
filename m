Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADD0288707
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 12:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387726AbgJIKeb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 06:34:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730763AbgJIKea (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Oct 2020 06:34:30 -0400
Received: from coco.lan (ip5f5ad5d0.dynamic.kabel-deutschland.de [95.90.213.208])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DEF9221FC;
        Fri,  9 Oct 2020 10:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602239669;
        bh=pRI4Tm1lG+Jblk58G1pSvqxmgDEZi2xS8IJzqwbJFvw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z0ZZm8k90LDIkkwepgM63s827tTWfKOZRcqR7o+KzIwoiE1/gtsqyykPEtefC1BOJ
         aqhxaJ85cRFHWn7mghZunfQqK4WizlHdY1AlS3galp81cAdVsdFebaWYB06Z1YG2jP
         N7/7ovKPoZG++Py9RD5QO4Y+qb3C0vzKbhvXTkLw=
Date:   Fri, 9 Oct 2020 12:34:21 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2 09/17] mm: Add unsafe_follow_pfn
Message-ID: <20201009123421.67a80d72@coco.lan>
In-Reply-To: <20201009075934.3509076-10-daniel.vetter@ffwll.ch>
References: <20201009075934.3509076-1-daniel.vetter@ffwll.ch>
        <20201009075934.3509076-10-daniel.vetter@ffwll.ch>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Em Fri,  9 Oct 2020 09:59:26 +0200
Daniel Vetter <daniel.vetter@ffwll.ch> escreveu:

> Way back it was a reasonable assumptions that iomem mappings never
> change the pfn range they point at. But this has changed:
>=20
> - gpu drivers dynamically manage their memory nowadays, invalidating
> ptes with unmap_mapping_range when buffers get moved
>=20
> - contiguous dma allocations have moved from dedicated carvetouts to
> cma regions. This means if we miss the unmap the pfn might contain
> pagecache or anon memory (well anything allocated with GFP_MOVEABLE)
>=20
> - even /dev/mem now invalidates mappings when the kernel requests that
> iomem region when CONFIG_IO_STRICT_DEVMEM is set, see 3234ac664a87
> ("/dev/mem: Revoke mappings when a driver claims the region")
>=20
> Accessing pfns obtained from ptes without holding all the locks is
> therefore no longer a good idea.
>=20
> Unfortunately there's some users where this is not fixable (like v4l
> userptr of iomem mappings) or involves a pile of work (vfio type1
> iommu). For now annotate these as unsafe and splat appropriately.
>=20
> This patch adds an unsafe_follow_pfn, which later patches will then
> roll out to all appropriate places.

NACK, as this breaks an existing userspace API on media.

While I agree that using the userptr on media is something that
new drivers may not support, as DMABUF is a better way of
handling it, changing this for existing ones is a big no,=20
as it may break usersapace.

The right approach here would be to be able to fine-tune
support for it on a per-driver basis, e. g. disabling such
feature only for drivers that would use a movable page.

The media subsystem has already a way to disable USERPTR
support from VB2. the right approach would be to ensure
that newer drivers will only set this if they won't use
movable pages.

Regards,
Mauro

>=20
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: linux-mm@kvack.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-samsung-soc@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Cc: kvm@vger.kernel.org
> ---
>  include/linux/mm.h |  2 ++
>  mm/memory.c        | 32 +++++++++++++++++++++++++++++++-
>  mm/nommu.c         | 17 +++++++++++++++++
>  security/Kconfig   | 13 +++++++++++++
>  4 files changed, 63 insertions(+), 1 deletion(-)
>=20
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 2a16631c1fda..ec8c90928fc9 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1653,6 +1653,8 @@ int follow_pte_pmd(struct mm_struct *mm, unsigned l=
ong address,
>  		   pte_t **ptepp, pmd_t **pmdpp, spinlock_t **ptlp);
>  int follow_pfn(struct vm_area_struct *vma, unsigned long address,
>  	unsigned long *pfn);
> +int unsafe_follow_pfn(struct vm_area_struct *vma, unsigned long address,
> +		      unsigned long *pfn);
>  int follow_phys(struct vm_area_struct *vma, unsigned long address,
>  		unsigned int flags, unsigned long *prot, resource_size_t *phys);
>  int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
> diff --git a/mm/memory.c b/mm/memory.c
> index f7cbc4dde0ef..7c7b234ffb24 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4821,7 +4821,12 @@ EXPORT_SYMBOL(follow_pte_pmd);
>   * @address: user virtual address
>   * @pfn: location to store found PFN
>   *
> - * Only IO mappings and raw PFN mappings are allowed.
> + * Only IO mappings and raw PFN mappings are allowed. Note that callers =
must
> + * ensure coherency with pte updates by using a &mmu_notifier to follow =
updates.
> + * If this is not feasible, or the access to the @pfn is only very short=
 term,
> + * use follow_pte_pmd() instead and hold the pagetable lock for the dura=
tion of
> + * the access instead. Any caller not following these requirements must =
use
> + * unsafe_follow_pfn() instead.
>   *
>   * Return: zero and the pfn at @pfn on success, -ve otherwise.
>   */
> @@ -4844,6 +4849,31 @@ int follow_pfn(struct vm_area_struct *vma, unsigne=
d long address,
>  }
>  EXPORT_SYMBOL(follow_pfn);
> =20
> +/**
> + * unsafe_follow_pfn - look up PFN at a user virtual address
> + * @vma: memory mapping
> + * @address: user virtual address
> + * @pfn: location to store found PFN
> + *
> + * Only IO mappings and raw PFN mappings are allowed.
> + *
> + * Returns zero and the pfn at @pfn on success, -ve otherwise.
> + */
> +int unsafe_follow_pfn(struct vm_area_struct *vma, unsigned long address,
> +	unsigned long *pfn)
> +{
> +#ifdef CONFIG_STRICT_FOLLOW_PFN
> +	pr_info("unsafe follow_pfn usage rejected, see CONFIG_STRICT_FOLLOW_PFN=
\n");
> +	return -EINVAL;
> +#else
> +	WARN_ONCE(1, "unsafe follow_pfn usage\n");
> +	add_taint(TAINT_USER, LOCKDEP_STILL_OK);
> +
> +	return follow_pfn(vma, address, pfn);
> +#endif
> +}
> +EXPORT_SYMBOL(unsafe_follow_pfn);
> +
>  #ifdef CONFIG_HAVE_IOREMAP_PROT
>  int follow_phys(struct vm_area_struct *vma,
>  		unsigned long address, unsigned int flags,
> diff --git a/mm/nommu.c b/mm/nommu.c
> index 75a327149af1..3db2910f0d64 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -132,6 +132,23 @@ int follow_pfn(struct vm_area_struct *vma, unsigned =
long address,
>  }
>  EXPORT_SYMBOL(follow_pfn);
> =20
> +/**
> + * unsafe_follow_pfn - look up PFN at a user virtual address
> + * @vma: memory mapping
> + * @address: user virtual address
> + * @pfn: location to store found PFN
> + *
> + * Only IO mappings and raw PFN mappings are allowed.
> + *
> + * Returns zero and the pfn at @pfn on success, -ve otherwise.
> + */
> +int unsafe_follow_pfn(struct vm_area_struct *vma, unsigned long address,
> +	unsigned long *pfn)
> +{
> +	return follow_pfn(vma, address, pfn);
> +}
> +EXPORT_SYMBOL(unsafe_follow_pfn);
> +
>  LIST_HEAD(vmap_area_list);
> =20
>  void vfree(const void *addr)
> diff --git a/security/Kconfig b/security/Kconfig
> index 7561f6f99f1d..48945402e103 100644
> --- a/security/Kconfig
> +++ b/security/Kconfig
> @@ -230,6 +230,19 @@ config STATIC_USERMODEHELPER_PATH
>  	  If you wish for all usermode helper programs to be disabled,
>  	  specify an empty string here (i.e. "").
> =20
> +config STRICT_FOLLOW_PFN
> +	bool "Disable unsafe use of follow_pfn"
> +	depends on MMU
> +	help
> +	  Some functionality in the kernel follows userspace mappings to iomem
> +	  ranges in an unsafe matter. Examples include v4l userptr for zero-copy
> +	  buffers sharing.
> +
> +	  If this option is switched on, such access is rejected. Only enable
> +	  this option when you must run userspace which requires this.
> +
> +	  If in doubt, say Y.
> +
>  source "security/selinux/Kconfig"
>  source "security/smack/Kconfig"
>  source "security/tomoyo/Kconfig"



Thanks,
Mauro
