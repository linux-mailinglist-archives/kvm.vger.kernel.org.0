Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7632C486D6F
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 23:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245316AbiAFW5n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 17:57:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245315AbiAFW5j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 17:57:39 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32966C061245
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 14:57:39 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id r4so9060639lfe.7
        for <kvm@vger.kernel.org>; Thu, 06 Jan 2022 14:57:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yzJHZd4Gd1bheV/asbmK4G/1FwWEzAUZrWzJArtbIz0=;
        b=Zki0siD3mjTCJ70qLU296CjxF52vQfJKI9PpJrTU7MY3UICyxWjAKdi4TJ4C/B7HPz
         tuOP9SU2M7i0h0K5hJZUGebEweMPff9dy5AUBCuFom56gcWfis/ZpECIa8KMs2O+6VW4
         oGeIaqvyI+YI/EtIZpGppHj5db0VKmjSSISAmJiS3KCVF3LI8CWhSostoJBNt7sTMLFm
         +ChSBeu1Xuf8WOyHMvH82CJxotgrxF91bIZAYNhwZnZWGF7tvkXD+1/JhqPxN5oqy2GL
         mY7kxxfDMmb2wG09pCYOwX73yQHNuhnTztrLJ6ifluVCG0xp/PKOUYTgi0VgSGSGzq50
         Bu7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yzJHZd4Gd1bheV/asbmK4G/1FwWEzAUZrWzJArtbIz0=;
        b=6kR004UrSmxIwEVw548vV8p9dVrS5EGkkg0oyHGOAbcmErs5CFYb2W6hlGJ2FI8VWx
         otExw8s3J/STXgEk2wRmZGr2No8mpJHLIs3WgCeSQyQOseWVUZstuTc9HPmgGatFKQkW
         JvDg5mve9K+qg9mytEfNmWCxD7bMGeO3WUVaBvGanr5TOyIo8yIygoq2lmeaNuBmDgiN
         9+LlNboIuEf9EGFsdpmxI/oE58DwqlCU4NOjp/mBQ9ITiZOVakRvilT4yxDtsESN4eGd
         1O/raHf1acmG2dHdr/Bzo6i8iLcxm9rSB+Jo3PPdbz0VBFpxiLHeDbLVwpRQAc+xZNcQ
         6ceQ==
X-Gm-Message-State: AOAM5308CXzDGBC3gCfA9YugAqg6lbSj4HiLRuvSC11gPmLw+rdFG8ct
        UTsfvnTkCHRGhUsUTRBIW27WVWAOrSev4X9Cyeiw3Q==
X-Google-Smtp-Source: ABdhPJzh5R/BPz0CNdBZp9zlAFI0lnHCaa+83+UPJ0fPwq4JsnQcqrVtpZN/2GMbdMF6B1JV/2eiK9mfFtjYlXqO5PU=
X-Received: by 2002:ac2:5388:: with SMTP id g8mr52790726lfh.64.1641509857221;
 Thu, 06 Jan 2022 14:57:37 -0800 (PST)
MIME-Version: 1.0
References: <20211213225918.672507-1-dmatlack@google.com> <20211213225918.672507-7-dmatlack@google.com>
 <YddSQNlPGyRDtk41@google.com>
In-Reply-To: <YddSQNlPGyRDtk41@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 6 Jan 2022 14:57:10 -0800
Message-ID: <CALzav=cf9-t2nvSsOt0XFwdSog3uXUpPKjhYca4j3MsD6nq10g@mail.gmail.com>
Subject: Re: [PATCH v1 06/13] KVM: x86/mmu: Refactor tdp_mmu iterators to take
 kvm_mmu_page root
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 6, 2022 at 12:34 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Dec 13, 2021, David Matlack wrote:
> > Instead of passing a pointer to the root page table and the root level
> > separately, pass in a pointer to the kvm_mmu_page that backs the root.
> > This reduces the number of arguments by 1, cutting down on line lengths.
> >
> > No functional change intended.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > Reviewed-by: Ben Gardon <bgardon@google.com>
> > ---
> >  arch/x86/kvm/mmu/tdp_iter.c |  5 ++++-
> >  arch/x86/kvm/mmu/tdp_iter.h | 10 +++++-----
> >  arch/x86/kvm/mmu/tdp_mmu.c  | 14 +++++---------
> >  3 files changed, 14 insertions(+), 15 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
> > index b3ed302c1a35..92b3a075525a 100644
> > --- a/arch/x86/kvm/mmu/tdp_iter.c
> > +++ b/arch/x86/kvm/mmu/tdp_iter.c
> > @@ -39,9 +39,12 @@ void tdp_iter_restart(struct tdp_iter *iter)
> >   * Sets a TDP iterator to walk a pre-order traversal of the paging structure
> >   * rooted at root_pt, starting with the walk to translate next_last_level_gfn.
> >   */
> > -void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
> > +void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
> >                   int min_level, gfn_t next_last_level_gfn)
> >  {
> > +     u64 *root_pt = root->spt;
> > +     int root_level = root->role.level;
>
> Uber nit, arch/x86/ prefers reverse fir tree, though I've yet to get Paolo fully
> on board :-)
>
> But looking at the usage of root_pt, even better would be
>
>   void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
>                       int min_level, gfn_t next_last_level_gfn)
>   {
>         int root_level = root->role.level;
>
>         WARN_ON(root_level < 1);
>         WARN_ON(root_level > PT64_ROOT_MAX_LEVEL);
>
>         iter->next_last_level_gfn = next_last_level_gfn;
>         iter->root_level = root_level;
>         iter->min_level = min_level;
>         iter->pt_path[iter->root_level - 1] = (tdp_ptep_t)root->spt;
>         iter->as_id = kvm_mmu_page_as_id(root);
>
>         tdp_iter_restart(iter);
>   }
>
> to avoid the pointless sptep_to_sp() and eliminate the motivation for root_pt.

Will do.
