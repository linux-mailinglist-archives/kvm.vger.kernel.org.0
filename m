Return-Path: <kvm+bounces-60839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A7413BFCFE9
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 18:00:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5CD363ACE9D
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 16:00:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A104026E146;
	Wed, 22 Oct 2025 16:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oLwv1VdS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B3326E6E8
	for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 16:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761148831; cv=none; b=ap3LJj+achKHeGzR8D3cGjt/UFYj0+RGBOtjE86bF9hwUFs+zQRDhHmndXGLMi8vAivyLJJXYGXHXbX8oKIe1BDS0IspEEMOFj+Hi8kuPYBVMWbKfZnTGS/JWfW66GAw8OHlG+gm2zsurChxacncP18gxO3rGxTbAyDKZAfChZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761148831; c=relaxed/simple;
	bh=aqh+eIb/pAJr1faQbjM3BAw0kdTESmg5XgtIC+w7U7o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F+xbfZig9OdOhc0wEQtyq9WWiz9BT866uVtWDKNVW5CE3hgbqvYR+Z7mlWShyML+DaFs5EDgA8Mk0tGKlfmVRVWes9wDQ0p8pqxhEQGZpCFv8eT0umwCU4gMOPPQ69K1BW2Eb6qS++aZrMHXQ9/M60Q9xoIULnM+O4z4ROccYFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oLwv1VdS; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-47101c27c9cso72985e9.0
        for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 09:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761148826; x=1761753626; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nrE4Qz7SJRI1Enuhm5FI5J4QD5PmBoz82eoX+T/eGMU=;
        b=oLwv1VdS+JpHpiamz7188I1SWjVkvlQk1bIGBDB2pKKFigqWA98TBo7EDAzHsQ16Mg
         R/xzzbhorKqaYw0ZCXeiw2eR9hrP5u+LbL1tdeLU5Q8bvIFIeyTQshFbLL3kHlKDzBUC
         4Baxgmth/hz8AsJUkqaqUYwmX1Yb/X+QCK0qyEHqTxdEcwzUdbTr6itZJrr0xNUBkwaX
         rDidT4rcKadIMMfejfS0qQTUhEKjQWbFhRecyxMQ+4andv8rzmb9uwslxUlmGOsEVHrS
         ng4AFUTqUCqK1Kp76kp+8nqOSUEIsPBOZ/1BtVuhvyHwa2AYVorY3q/Ba/oEV+HVQlnQ
         ucKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761148826; x=1761753626;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nrE4Qz7SJRI1Enuhm5FI5J4QD5PmBoz82eoX+T/eGMU=;
        b=LXZrpv6n6oYsjroPIKaCdbFEl6E18RFDmScB35XcPUwbwuwPra8v6+ZnH9kDiLSwzk
         ULr0T7RzD/JvOW4tprzH/EbpD2B1Rb/bCUPdmGFCUIZImLl6yvxWkdSQMH91CfCqJhW9
         lbNt2T+CoPC0i/jMkbKK8SpTQhA9cgevL1v2nwOu8xIVj7YWSPLY6cotym01DYJ70k47
         ocn0XVLoK0kMX8DbHfbL6Cz2Zwx5PTpXxj2RppwsMBC2+SEr6pjJJxQ3b/xDWBw90f7M
         v0ciBqHlHZW7Q1YjkF7+eG8BBuAUl/k4MlIcX5o6cWxHQyGtL6kPcKH4e7SyIwl8vUdk
         gVhA==
X-Forwarded-Encrypted: i=1; AJvYcCVebyHzKCuJjF+5NQc+SClqRjGUimI+uPUrP1Lddvfa9ijMPXxryqMGaBBzGaOfD1esS6k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEUxqRnKo0qxzQ1aMg/Rd3sf1A0GCXAiSn+hB9/5tI2j1zF9xm
	nLr8Rq4GhnnWt6mjNhn6xTEUxjLjcH3WpTgvEv8syuU7//KtMuDHWuNgiom8NSUWEf7P7WNErMw
	zRJN870xsWaJ4dTgkrHjIafA4kooQBUxYVM+mQjjr
X-Gm-Gg: ASbGnctDyzdxL5OpNgzCYytYmdLhAk2ftoPN4HYvahoo9eCn9pZJNI5MozMaR5QWpRG
	YESE7gFINaRkBeZgQq9dSCnOm1V0r3hXcVsJKRvuuGAcTLKfIavon0q7yV2EK5mpyhNAyzRGPVS
	iergtCw1EAp8uiPf7lkemjc6tRYLXriU8w4078fWlpy9r9c967uPXZSaRNk8dUbcNkJfTE4RAlv
	X5DpBwQG1iGR1YmMwPsILVSkVOfSL6sEIilZ1GRj9dXOP34mMVp7CB9bK6dIMCZHvJZuEd/zxB+
	dIOnERAR0qdbevo+WQ==
X-Google-Smtp-Source: AGHT+IGQ5urEAQ9m57T3Tr0rBInJl1kxrVgo9aZA5J1ni84q+HbgDwPfJxL7EgSHQYRd3sVOQI4JW1ylUbWl3BXuheM=
X-Received: by 2002:a05:600c:c04b:10b0:46f:c587:df17 with SMTP id
 5b1f17b1804b1-475c5138edbmr772405e9.1.1761148826010; Wed, 22 Oct 2025
 09:00:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251021102327.199099-1-ankita@nvidia.com> <20251021102327.199099-2-ankita@nvidia.com>
In-Reply-To: <20251021102327.199099-2-ankita@nvidia.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Wed, 22 Oct 2025 09:00:13 -0700
X-Gm-Features: AS18NWCpMHMP31ZSlN1pMxGifJCs7kl9OgsJ-oSyN2IYIPEyac80DDLNqIbtKlQ
Message-ID: <CACw3F5036Kfs_j8np+_+YejC02ADeLoCNYaQVhmBRzQF32NAgA@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] mm: handle poisoning of pfn without struct pages
To: ankita@nvidia.com
Cc: aniketa@nvidia.com, vsethi@nvidia.com, jgg@nvidia.com, mochs@nvidia.com, 
	skolothumtho@nvidia.com, linmiaohe@huawei.com, nao.horiguchi@gmail.com, 
	akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, tony.luck@intel.com, bp@alien8.de, rafael@kernel.org, 
	guohanjun@huawei.com, mchehab@kernel.org, lenb@kernel.org, 
	kevin.tian@intel.com, alex@shazbot.org, cjia@nvidia.com, kwankhede@nvidia.com, 
	targupta@nvidia.com, zhiw@nvidia.com, dnigam@nvidia.com, kjaju@nvidia.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-edac@vger.kernel.org, 
	Jonathan.Cameron@huawei.com, ira.weiny@intel.com, 
	Smita.KoralahalliChannabasappa@amd.com, u.kleine-koenig@baylibre.com, 
	peterz@infradead.org, linux-acpi@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 21, 2025 at 3:23=E2=80=AFAM <ankita@nvidia.com> wrote:
>
> From: Ankit Agrawal <ankita@nvidia.com>
>
> The kernel MM currently does not handle ECC errors / poison on a memory
> region that is not backed by struct pages. If a memory region mapped
> using remap_pfn_range() for example, but not added to the kernel, MM
> will not have associated struct pages. Add a new mechanism to handle
> memory failure on such memory.
>
> Make kernel MM expose a function to allow modules managing the device
> memory to register the device memory SPA and the address space associated
> it. MM maintains this information as an interval tree. On poison, MM can
> search for the range that the poisoned PFN belong and use the address_spa=
ce
> to determine the mapping VMA.
>
> In this implementation, kernel MM follows the following sequence that is
> largely similar to the memory_failure() handler for struct page backed
> memory:
> 1. memory_failure() is triggered on reception of a poison error. An
> absence of struct page is detected and consequently memory_failure_pfn()
> is executed.
> 2. memory_failure_pfn() collects the processes mapped to the PFN.
> 3. memory_failure_pfn() sends SIGBUS to all the processes mapping the
> poisoned PFN using kill_procs().
>
> Note that there is one primary difference versus the handling of the
> poison on struct pages, which is to skip unmapping to the faulty PFN.
> This is done to handle the huge PFNMAP support added recently [1] that
> enables VM_PFNMAP vmas to map in either PMD level. Otherwise, a poison
> to a PFN would need breaking the PMD mapping into PTEs to unmap only
> the poisoned PFN. This will have a major performance impact.
>
> Link: https://lore.kernel.org/all/20240826204353.2228736-1-peterx@redhat.=
com/ [1]
>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  MAINTAINERS                    |   1 +
>  include/linux/memory-failure.h |  17 +++++
>  include/linux/mm.h             |   1 +
>  include/ras/ras_event.h        |   1 +
>  mm/Kconfig                     |   1 +
>  mm/memory-failure.c            | 128 ++++++++++++++++++++++++++++++++-
>  6 files changed, 148 insertions(+), 1 deletion(-)
>  create mode 100644 include/linux/memory-failure.h
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 520fb4e379a3..463d062d0386 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11359,6 +11359,7 @@ M:      Miaohe Lin <linmiaohe@huawei.com>
>  R:     Naoya Horiguchi <nao.horiguchi@gmail.com>
>  L:     linux-mm@kvack.org
>  S:     Maintained
> +F:     include/linux/memory-failure.h
>  F:     mm/hwpoison-inject.c
>  F:     mm/memory-failure.c
>
> diff --git a/include/linux/memory-failure.h b/include/linux/memory-failur=
e.h
> new file mode 100644
> index 000000000000..bc326503d2d2
> --- /dev/null
> +++ b/include/linux/memory-failure.h
> @@ -0,0 +1,17 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_MEMORY_FAILURE_H
> +#define _LINUX_MEMORY_FAILURE_H
> +
> +#include <linux/interval_tree.h>
> +
> +struct pfn_address_space;
> +
> +struct pfn_address_space {
> +       struct interval_tree_node node;
> +       struct address_space *mapping;
> +};
> +
> +int register_pfn_address_space(struct pfn_address_space *pfn_space);
> +void unregister_pfn_address_space(struct pfn_address_space *pfn_space);
> +
> +#endif /* _LINUX_MEMORY_FAILURE_H */
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 1ae97a0b8ec7..0ab4ea82ce9e 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4006,6 +4006,7 @@ enum mf_action_page_type {
>         MF_MSG_DAX,
>         MF_MSG_UNSPLIT_THP,
>         MF_MSG_ALREADY_POISONED,
> +       MF_MSG_PFN_MAP,
>         MF_MSG_UNKNOWN,
>  };
>
> diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
> index c8cd0f00c845..fecfeb7c8be7 100644
> --- a/include/ras/ras_event.h
> +++ b/include/ras/ras_event.h
> @@ -375,6 +375,7 @@ TRACE_EVENT(aer_event,
>         EM ( MF_MSG_DAX, "dax page" )                                   \
>         EM ( MF_MSG_UNSPLIT_THP, "unsplit thp" )                        \
>         EM ( MF_MSG_ALREADY_POISONED, "already poisoned" )              \
> +       EM ( MF_MSG_PFN_MAP, "non struct page pfn" )                    \
>         EMe ( MF_MSG_UNKNOWN, "unknown page" )
>
>  /*
> diff --git a/mm/Kconfig b/mm/Kconfig
> index e443fe8cd6cf..0b07219390b9 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -777,6 +777,7 @@ config MEMORY_FAILURE
>         depends on ARCH_SUPPORTS_MEMORY_FAILURE
>         bool "Enable recovery from hardware memory errors"
>         select MEMORY_ISOLATION
> +       select INTERVAL_TREE
>         select RAS
>         help
>           Enables code to recover from some memory failures on systems
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index df6ee59527dd..acfe5a9bde1d 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -38,6 +38,7 @@
>
>  #include <linux/kernel.h>
>  #include <linux/mm.h>
> +#include <linux/memory-failure.h>
>  #include <linux/page-flags.h>
>  #include <linux/sched/signal.h>
>  #include <linux/sched/task.h>
> @@ -154,6 +155,10 @@ static const struct ctl_table memory_failure_table[]=
 =3D {
>         }
>  };
>
> +static struct rb_root_cached pfn_space_itree =3D RB_ROOT_CACHED;
> +
> +static DEFINE_MUTEX(pfn_space_lock);
> +
>  /*
>   * Return values:
>   *   1:   the page is dissolved (if needed) and taken off from buddy,
> @@ -957,6 +962,7 @@ static const char * const action_page_types[] =3D {
>         [MF_MSG_DAX]                    =3D "dax page",
>         [MF_MSG_UNSPLIT_THP]            =3D "unsplit thp",
>         [MF_MSG_ALREADY_POISONED]       =3D "already poisoned page",
> +       [MF_MSG_PFN_MAP]                =3D "non struct page pfn",
>         [MF_MSG_UNKNOWN]                =3D "unknown page",
>  };
>
> @@ -1349,7 +1355,7 @@ static int action_result(unsigned long pfn, enum mf=
_action_page_type type,
>  {
>         trace_memory_failure_event(pfn, type, result);
>
> -       if (type !=3D MF_MSG_ALREADY_POISONED) {
> +       if (type !=3D MF_MSG_ALREADY_POISONED && type !=3D MF_MSG_PFN_MAP=
) {
>                 num_poisoned_pages_inc(pfn);
>                 update_per_node_mf_stats(pfn, result);
>         }
> @@ -2216,6 +2222,121 @@ static void kill_procs_now(struct page *p, unsign=
ed long pfn, int flags,
>         kill_procs(&tokill, true, pfn, flags);
>  }
>
> +int register_pfn_address_space(struct pfn_address_space *pfn_space)
> +{
> +       if (!pfn_space)
> +               return -EINVAL;
> +
> +       mutex_lock(&pfn_space_lock);
> +
> +       if (interval_tree_iter_first(&pfn_space_itree,
> +                                    pfn_space->node.start,
> +                                    pfn_space->node.last)) {
> +               mutex_unlock(&pfn_space_lock);
> +               return -EBUSY;
> +       }
> +
> +       interval_tree_insert(&pfn_space->node, &pfn_space_itree);
> +       mutex_unlock(&pfn_space_lock);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(register_pfn_address_space);
> +
> +void unregister_pfn_address_space(struct pfn_address_space *pfn_space)
> +{
> +       if (!pfn_space)
> +               return;
> +
> +       mutex_lock(&pfn_space_lock);
> +       interval_tree_remove(&pfn_space->node, &pfn_space_itree);

IIRC removing something not in interval tree will panic kernel. If I
am not mistaken, should here do something like
interval_tree_iter_first before interval_tree_remove, to avoid
driver's ill behavior crash the system?

> +       mutex_unlock(&pfn_space_lock);
> +}
> +EXPORT_SYMBOL_GPL(unregister_pfn_address_space);
> +
> +static void add_to_kill_pfn(struct task_struct *tsk,
> +                           struct vm_area_struct *vma,
> +                           struct list_head *to_kill,
> +                           unsigned long pfn)
> +{
> +       struct to_kill *tk;
> +
> +       tk =3D kmalloc(sizeof(*tk), GFP_ATOMIC);
> +       if (!tk)
> +               return;
> +
> +       /* Check for pgoff not backed by struct page */
> +       tk->addr =3D vma_address(vma, pfn, 1);
> +       tk->size_shift =3D PAGE_SHIFT;
> +
> +       if (tk->addr =3D=3D -EFAULT)
> +               pr_info("Unable to find address %lx in %s\n",
> +                       pfn, tsk->comm);
> +
> +       get_task_struct(tsk);
> +       tk->tsk =3D tsk;
> +       list_add_tail(&tk->nd, to_kill);
> +}
> +
> +/*
> + * Collect processes when the error hit a PFN not backed by struct page.
> + */
> +static void collect_procs_pfn(struct address_space *mapping,
> +                             unsigned long pfn, struct list_head *to_kil=
l)
> +{
> +       struct vm_area_struct *vma;
> +       struct task_struct *tsk;
> +
> +       i_mmap_lock_read(mapping);
> +       rcu_read_lock();
> +       for_each_process(tsk) {
> +               struct task_struct *t =3D tsk;
> +
> +               t =3D task_early_kill(tsk, true);
> +               if (!t)
> +                       continue;
> +               vma_interval_tree_foreach(vma, &mapping->i_mmap, pfn, pfn=
) {
> +                       if (vma->vm_mm =3D=3D t->mm)
> +                               add_to_kill_pfn(t, vma, to_kill, pfn);
> +               }
> +       }
> +       rcu_read_unlock();
> +       i_mmap_unlock_read(mapping);
> +}
> +
> +static int memory_failure_pfn(unsigned long pfn, int flags)
> +{
> +       struct interval_tree_node *node;
> +       LIST_HEAD(tokill);
> +
> +       mutex_lock(&pfn_space_lock);
> +       /*
> +        * Modules registers with MM the address space mapping to the dev=
ice memory they
> +        * manage. Iterate to identify exactly which address space has ma=
pped to this
> +        * failing PFN.
> +        */
> +       for (node =3D interval_tree_iter_first(&pfn_space_itree, pfn, pfn=
); node;
> +            node =3D interval_tree_iter_next(node, pfn, pfn)) {
> +               struct pfn_address_space *pfn_space =3D
> +                       container_of(node, struct pfn_address_space, node=
);
> +
> +               collect_procs_pfn(pfn_space->mapping, pfn, &tokill);
> +       }
> +       mutex_unlock(&pfn_space_lock);
> +
> +       /*
> +        * Unlike System-RAM there is no possibility to swap in a differe=
nt
> +        * physical page at a given virtual address, so all userspace
> +        * consumption of direct PFN memory necessitates SIGBUS (i.e.
> +        * MF_MUST_KILL)
> +        */
> +       flags |=3D MF_ACTION_REQUIRED | MF_MUST_KILL;
> +
> +       kill_procs(&tokill, true, pfn, flags);
> +
> +       return action_result(pfn, MF_MSG_PFN_MAP, MF_RECOVERED);
> +}
> +
>  /**
>   * memory_failure - Handle memory failure of a page.
>   * @pfn: Page Number of the corrupted page
> @@ -2259,6 +2380,11 @@ int memory_failure(unsigned long pfn, int flags)
>         if (!(flags & MF_SW_SIMULATED))
>                 hw_memory_failure =3D true;
>
> +       if (!pfn_valid(pfn) && !arch_is_platform_page(PFN_PHYS(pfn))) {
> +               res =3D memory_failure_pfn(pfn, flags);
> +               goto unlock_mutex;
> +       }
> +
>         p =3D pfn_to_online_page(pfn);
>         if (!p) {
>                 res =3D arch_memory_failure(pfn, flags);
> --
> 2.34.1
>
>

