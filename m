Return-Path: <kvm+bounces-19066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AA10900068
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 12:11:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D98901F23F4F
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 10:11:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CCA215B986;
	Fri,  7 Jun 2024 10:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ODiAS7do"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883521CA85
	for <kvm@vger.kernel.org>; Fri,  7 Jun 2024 10:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717755052; cv=none; b=kVl9lRuoRUrskdwoT/OZVg/svmmCbn1YBya2y2bFZOXzos+iVPJQcu5O5ryjsnyiVzKOjEbTJHUVH7856yg0Z8wtk2RQcFixYHt4sbOq9gL+rk7V+exzj4E4q0XXNJKb3OWDYMplG5VGEnlJRdb5rWD9jsEs36BVzGAO/rMlHl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717755052; c=relaxed/simple;
	bh=QW+p0LE+OA0sFKpEDoQlNfo/8sXx7142FTJZGgXwPxA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ORBCuIQB9h/t2wKpxRnEgc+HTjBHgjv4Yk1R4JKyaVLeM5l00Obg9Zhszqu+LvUeEwv4Cz9I4jnP/BwxJgtP9YrVfuXlO/qhOpHjx0OzYXId7xL1Wsge2sDMQGS9JHc+pdmGdEBJTgBID8K7Kcn6zUku1LIr+SZ+f5ur2ala8mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ODiAS7do; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717755048;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V1PfJJ2X6kfxVeld9qIvWb5WqYVs7ksNnwyBTZFTZh4=;
	b=ODiAS7dojKLCdPKPxHHlOz2Sece/Y4b8ZhKutb3vm688iEMx9OoijQhAAEKvBTj7EIYgMQ
	qlyBK44tRE7dNFu9gy1OHCEqF4YlB2yp5JgLsY4fGh1EUrn+Q2+hGOs/bfmIwXeQ9rsrzx
	91B72nA7iSQOWthY1exaFvs4jGZxfN4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-534-3yYfjpJGPrSVR18xv1QPVA-1; Fri, 07 Jun 2024 06:10:47 -0400
X-MC-Unique: 3yYfjpJGPrSVR18xv1QPVA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-35858762c31so1160974f8f.0
        for <kvm@vger.kernel.org>; Fri, 07 Jun 2024 03:10:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717755046; x=1718359846;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V1PfJJ2X6kfxVeld9qIvWb5WqYVs7ksNnwyBTZFTZh4=;
        b=V1T9pDw1PU4b7yQFQ0zuEwo8ara/K2kObX2knaAr/txus/+r3phXcaDvb8ML7B/bjQ
         I1g+ZleHOkZpB4bki4qMtGiBWZaLebjKiycPidB2QoJNt3D7eD47bx7Bzhul1qFIkL0t
         NvEXsZPF0xAUa88EBKdzmIqtzYmGkNHSBPZBXSMO/SaN0em1vuXFR1GtIitiNaMz5Un8
         DdCDKBgq6CreQwtsvbLwzb/8Un2TlIRBXET+U/7kQ7CIsncJwRjA+27Xm9yEvccSqbZE
         Q+1j37bee9ic0wh2lSqK4kCSSarR3jSfJeOaHj2QAd88WW5hZDC7WSuvvjPjCOqfaFiR
         sBXQ==
X-Forwarded-Encrypted: i=1; AJvYcCWbRDCUzcBhz16C1KUGwPQ9+IEeFYobkFmxjT86IorkibIKWTPMXtoaWXf2gU2TPfBpzZcl4jveP4ITUtpRxGU1iH3t
X-Gm-Message-State: AOJu0Yy/OZ1C6dLa/VK0dw1fcnc9Yksfwnk/gnnDQGTyDhuhos+nMpYh
	e+bxsRbqx4YhLd52JOSt4BwJaaGWg0rP7BKKe9Wy71k9uM+1DzcXvMJ0+2nduPDyqb5Xd68eQur
	geEfVlcxewLozk0nvgsc60pAVE1XAKv/u0QUY1PbMnN2eoz7OltPUYe1GnqNTtKgBuukDvRF051
	Z4tMzR4VYs0WO8EjIoTmlERF61
X-Received: by 2002:a5d:4e08:0:b0:34c:fd92:3359 with SMTP id ffacd0b85a97d-35efea29070mr2152882f8f.21.1717755046087;
        Fri, 07 Jun 2024 03:10:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFtI7a6+AdMZCJmgOoWoZZH9VEawBdUDuuktV7O8VTbiwlVP+AmaIQlQPw9D70k9nVauCb1+/x3VAnFyKs8qdI=
X-Received: by 2002:a5d:4e08:0:b0:34c:fd92:3359 with SMTP id
 ffacd0b85a97d-35efea29070mr2152844f8f.21.1717755045636; Fri, 07 Jun 2024
 03:10:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com> <20240530210714.364118-11-rick.p.edgecombe@intel.com>
In-Reply-To: <20240530210714.364118-11-rick.p.edgecombe@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 7 Jun 2024 12:10:33 +0200
Message-ID: <CABgObfYhKmBkqGP-d12o6W2TfiaqwP-c8pcae9-pnkaYJt6K-w@mail.gmail.com>
Subject: Re: [PATCH v2 10/15] KVM: x86/tdp_mmu: Reflect building mirror page tables
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: seanjc@google.com, kvm@vger.kernel.org, kai.huang@intel.com, 
	dmatlack@google.com, erdemaktas@google.com, isaku.yamahata@gmail.com, 
	linux-kernel@vger.kernel.org, sagis@google.com, yan.y.zhao@intel.com, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 30, 2024 at 11:07=E2=80=AFPM Rick Edgecombe
<rick.p.edgecombe@intel.com> wrote:
> +       /* Update mirrored mapping with page table link */
> +       int (*reflect_link_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level=
 level,
> +                               void *mirrored_spt);
> +       /* Update the mirrored page table from spte getting set */
> +       int (*reflect_set_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level=
 level,
> +                               kvm_pfn_t pfn);

Possibly link_external_spt and set_external_spte, since you'll have to
s/mirrored/external/ in the comment. But not a hard request.

> +static void *get_mirrored_spt(gfn_t gfn, u64 new_spte, int level)
> +{
> +       if (is_shadow_present_pte(new_spte) && !is_last_spte(new_spte, le=
vel)) {
> +               struct kvm_mmu_page *sp =3D to_shadow_page(pfn_to_hpa(spt=
e_to_pfn(new_spte)));

I think this is spte_to_child_sp(new_spte)?

> +               void *mirrored_spt =3D kvm_mmu_mirrored_spt(sp);
> +
> +               WARN_ON_ONCE(sp->role.level + 1 !=3D level);
> +               WARN_ON_ONCE(sp->gfn !=3D gfn);
> +               return mirrored_spt;

Based on previous reviews this can be just "return sp->external_spt",
removing the not-particularly-interesting kvm_mmu_mirrored_spt()
helper.

> +static int __must_check reflect_set_spte_present(struct kvm *kvm, tdp_pt=
ep_t sptep,

tdp_mmu_set_mirror_spte_atomic?

> +       /*
> +        * For mirrored page table, callbacks are needed to propagate SPT=
E
> +        * change into the mirrored page table. In order to atomically up=
date
> +        * both the SPTE and the mirrored page tables with callbacks, uti=
lize
> +        * freezing SPTE.
> +        * - Freeze the SPTE. Set entry to REMOVED_SPTE.
> +        * - Trigger callbacks for mirrored page tables.
> +        * - Unfreeze the SPTE.  Set the entry to new_spte.
> +        */

/*
 * We need to lock out other updates to the SPTE until the external
 * page table has been modified. Use REMOVED_SPTE similar to
 * the zapping case.
 */

Easy peasy. :) We may want to rename REMOVED_SPTE to FROZEN_SPTE; feel
free to do it at the head of this series, then it can be picked for
6.11.

> -static inline int __tdp_mmu_set_spte_atomic(struct tdp_iter *iter, u64 n=
ew_spte)
> +static inline int __tdp_mmu_set_spte_atomic(struct kvm *kvm, struct tdp_=
iter *iter, u64 new_spte)
>  {
>         u64 *sptep =3D rcu_dereference(iter->sptep);
>
> @@ -571,15 +629,36 @@ static inline int __tdp_mmu_set_spte_atomic(struct =
tdp_iter *iter, u64 new_spte)
>          */
>         WARN_ON_ONCE(iter->yielded || is_removed_spte(iter->old_spte));
>
> -       /*
> -        * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs =
and
> -        * does not hold the mmu_lock.  On failure, i.e. if a different l=
ogical
> -        * CPU modified the SPTE, try_cmpxchg64() updates iter->old_spte =
with
> -        * the current value, so the caller operates on fresh data, e.g. =
if it
> -        * retries tdp_mmu_set_spte_atomic()
> -        */
> -       if (!try_cmpxchg64(sptep, &iter->old_spte, new_spte))
> -               return -EBUSY;
> +       if (is_mirror_sptep(iter->sptep) && !is_removed_spte(new_spte)) {
> +               int ret;
> +
> +               /* Don't support atomic zapping for mirrored roots */

The why is hidden in the commit message to patch 11. I wonder if it
isn't clearer to simply squash together patches 10 and 11 (your call),
and instead split out the addition of the new struct kvm parameters.

Anyway, this comment needs a bit more info:

/*
 * Users of atomic zapping don't operate on mirror roots,
 * so only need to handle present new_spte.
 */

> +               if (KVM_BUG_ON(!is_shadow_present_pte(new_spte), kvm))
> +                       return -EBUSY;
> +               /*
> +                * Populating case.
> +                * - reflect_set_spte_present() implements
> +                *   1) Freeze SPTE
> +                *   2) call hooks to update mirrored page table,
> +                *   3) update SPTE to new_spte
> +                * - handle_changed_spte() only updates stats.
> +                */

Comment not needed (weird I know).


> +               ret =3D reflect_set_spte_present(kvm, iter->sptep, iter->=
gfn,
> +                                              iter->old_spte, new_spte, =
iter->level);
> +               if (ret)
> +                       return ret;
> +       } else {
> +               /*
> +                * Note, fast_pf_fix_direct_spte() can also modify TDP MM=
U SPTEs
> +                * and does not hold the mmu_lock.  On failure, i.e. if a
> +                * different logical CPU modified the SPTE, try_cmpxchg64=
()
> +                * updates iter->old_spte with the current value, so the =
caller
> +                * operates on fresh data, e.g. if it retries
> +                * tdp_mmu_set_spte_atomic()
> +                */
> +               if (!try_cmpxchg64(sptep, &iter->old_spte, new_spte))
> +                       return -EBUSY;
> +       }
>
>         return 0;
>  }
> @@ -610,7 +689,7 @@ static inline int tdp_mmu_set_spte_atomic(struct kvm =
*kvm,
>
>         lockdep_assert_held_read(&kvm->mmu_lock);
>
> -       ret =3D __tdp_mmu_set_spte_atomic(iter, new_spte);
> +       ret =3D __tdp_mmu_set_spte_atomic(kvm, iter, new_spte);
>         if (ret)
>                 return ret;
>
> @@ -636,7 +715,7 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm =
*kvm,
>          * Delay processing of the zapped SPTE until after TLBs are flush=
ed and
>          * the REMOVED_SPTE is replaced (see below).
>          */
> -       ret =3D __tdp_mmu_set_spte_atomic(iter, REMOVED_SPTE);
> +       ret =3D __tdp_mmu_set_spte_atomic(kvm, iter, REMOVED_SPTE);
>         if (ret)
>                 return ret;
>
> @@ -698,6 +777,11 @@ static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_=
id, tdp_ptep_t sptep,
>         role =3D sptep_to_sp(sptep)->role;
>         role.level =3D level;
>         handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, role, fa=
lse);
> +
> +       /* Don't support setting for the non-atomic case */
> +       if (is_mirror_sptep(sptep))
> +               KVM_BUG_ON(is_shadow_present_pte(new_spte), kvm);
> +
>         return old_spte;
>  }
>
> --
> 2.34.1
>


