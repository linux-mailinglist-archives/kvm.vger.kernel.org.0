Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F45464C108
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 01:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237610AbiLNAJK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 19:09:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237568AbiLNAIh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 19:08:37 -0500
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5830523153
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 16:08:02 -0800 (PST)
Received: by mail-qk1-x72e.google.com with SMTP id h8so608457qkk.8
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 16:08:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mZ92YtnQEvuyt/w8J84vCUssEmExzTkIRL4Fcee9MWo=;
        b=UR3KFG5PX0bDn6p+beajzZzOZuq7o76x0V4yEZJzuRUo+g9KB/zUshRWZFL7qzw1Dd
         YBNU/+3H6oSu6Oeou0P+gkPSa8c9GgpsOTIh6lNWyMV5qAKdyk4vaBEiD8Z6xF+1kzgs
         ZeVz/do2fqCKNvExOw00A6jMjt2r5heSQ+pHl18IoYGSsxns4GcokTZxMATa16zO6N34
         fb2w+HLArv9/WzLNLhg+gxbT9AR/g+NdSdOiAyYHTt9Kc2clh3WEW+2UY7MRcb3xJnue
         8Nf+jdlsrMRNItw8qNQ7hgFiXGPrZUx8LA7qzp9tQ7c5JiNAvnpM46ACWxmSKgfYnVOQ
         xQhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mZ92YtnQEvuyt/w8J84vCUssEmExzTkIRL4Fcee9MWo=;
        b=PsbZ0A09NK+z9nKe8LBiGuFubH8WUj8R3F2p2MzNN/2vMqY9FrBJ80eyApZgnFSddD
         5umlJ6u2upMqAqCUSWp6TG9r1EFiTrw+cyRV74o0wb/MQuGhFAWgHSbuCwH/3CbPid3N
         O6bjTcXlSDphPytxGdT69vRXCf7J0W0cM/+1wnOZouvru0gaDh0qF7g77QoiMmeEEXHx
         tOwAiCJQGvScXRpg9D5sAbnvb/tMYMJnABlpfHV9ivsSfgmTmPTMmkcRSFUM+YOpTqJY
         OhBGqdDhhNEBXYPbVZVUmE/Dfl/bn4rZOnwS2qJMB7GNizAdd4frut9PWdutvgLOfwbM
         KEQw==
X-Gm-Message-State: ANoB5pn5WXsfr27Y5OlwjXOVXi4Vhgw5i4zF++0FXj4294vXsocSA8zP
        VoE0ebugLzEM1kyu2gEXG5cFaPEUOPyXUz/fkSP0EA==
X-Google-Smtp-Source: AA0mqf73jnVk0hm795bF34Ej8JDTLzHjT28OVxzoAdtvD9F/amsG47bO5LXsmdljvTU3WlDR2kiXhiv1+x3AhENu9YE=
X-Received: by 2002:a05:620a:1361:b0:6ff:ae58:94ee with SMTP id
 d1-20020a05620a136100b006ffae5894eemr382091qkl.81.1670976481397; Tue, 13 Dec
 2022 16:08:01 -0800 (PST)
MIME-Version: 1.0
References: <20221206173601.549281-1-bgardon@google.com> <20221206173601.549281-2-bgardon@google.com>
 <Y5O1LbbeI7XXeaT2@google.com>
In-Reply-To: <Y5O1LbbeI7XXeaT2@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 13 Dec 2022 16:07:50 -0800
Message-ID: <CANgfPd9seknv1UCORyaR2KdkkBco1cDPuBc4z7V0trUtM_sZnQ@mail.gmail.com>
Subject: Re: [PATCH 1/7] KVM: x86/MMU: Move pte_list operations to rmap.c
To:     David Matlack <dmatlack@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 9, 2022 at 2:22 PM David Matlack <dmatlack@google.com> wrote:
>
> On Tue, Dec 06, 2022 at 05:35:55PM +0000, Ben Gardon wrote:
> > In the interest of eventually splitting the Shadow MMU out of mmu.c,
> > start by moving some of the operations for manipulating pte_lists out of
> > mmu.c and into a new pair of files: rmap.c and rmap.h.
> >
> > No functional change intended.
> >
> > Signed-off-by: Ben Gardon <bgardon@google.com>
> > ---
> [...]
> > diff --git a/arch/x86/kvm/mmu/rmap.h b/arch/x86/kvm/mmu/rmap.h
> > new file mode 100644
> > index 000000000000..059765b6e066
> > --- /dev/null
> > +++ b/arch/x86/kvm/mmu/rmap.h
> > @@ -0,0 +1,34 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
> > +#ifndef __KVM_X86_MMU_RMAP_H
> > +#define __KVM_X86_MMU_RMAP_H
> > +
> > +#include <linux/kvm_host.h>
> > +
> > +/* make pte_list_desc fit well in cache lines */
> > +#define PTE_LIST_EXT 14
> > +
> > +/*
> > + * Slight optimization of cacheline layout, by putting `more' and `spte_count'
> > + * at the start; then accessing it will only use one single cacheline for
> > + * either full (entries==PTE_LIST_EXT) case or entries<=6.
> > + */
> > +struct pte_list_desc {
> > +     struct pte_list_desc *more;
> > +     /*
> > +      * Stores number of entries stored in the pte_list_desc.  No need to be
> > +      * u64 but just for easier alignment.  When PTE_LIST_EXT, means full.
> > +      */
> > +     u64 spte_count;
> > +     u64 *sptes[PTE_LIST_EXT];
> > +};
> > +
> > +static struct kmem_cache *pte_list_desc_cache;
>
> The definition of pte_list_desc_cache needs to go in a C file since it's
> a global variable. Since it now needs to be accessed by more than once C
> file, drop the static. Then it can be accessed with extern.
>
> Since most of the code that sets up and deals with pte_list_desc_cache
> is still in mmu.c, my vote is to keep the definition there.
>
> i.e.
>
> mmu.c:
>
>   struct kmem_cache *pte_list_desc_cache;
>
> rmap.c
>
>   extern struct kmem_cache *pte_list_desc_cache;
>
> And no need for anything in rmap.h.

Right, good point. I'll fix that in the next edition.
