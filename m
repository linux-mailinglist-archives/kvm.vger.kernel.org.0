Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0431665C6BB
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 19:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238412AbjACSuj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 13:50:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238803AbjACSt6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 13:49:58 -0500
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD40213F35
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 10:49:47 -0800 (PST)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-466c5fb1c39so436234147b3.10
        for <kvm@vger.kernel.org>; Tue, 03 Jan 2023 10:49:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kD5iCtmMtoY9zsUWZCFp6s8wajpgXbqSKtnkj2WC3Sw=;
        b=L69g2USYZkrgZ0NBPPovmuZzIm0GkBKlaw7kOr6MsNMHL5yfYxZmdW8n/WZo7h27Ov
         a8wEcdkm3ACX7AMviZn5cczTFZDZnd6E1mjtn0dAIBg0VO89RYGO5P50EX12+cKD0rMf
         GOxXDEL1e2WxSEU1X3DRI2dllts9D+GJWtDtrTHdUshkFyJQMbWC985rnA4b/DbPanJX
         wC+oZneFvhy8Er8/9waMD7X8gLM54afCq3eEQUEY6q/sOzMIhKMLGdquLvJkWl9BOrq6
         6Kl69DbvaddqEQoaLmOPy+JBkF8Wjf7dXKaH5O6F6uQs5t4Ii4ATiIpsuE5oz/GL4m04
         jl3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kD5iCtmMtoY9zsUWZCFp6s8wajpgXbqSKtnkj2WC3Sw=;
        b=OOETP9zls5gZYAjXOK2hU+qOXAmLj/TKRacaamdobK8S7fIbsKWg5RfdA39fqAlg+G
         OCfDcCJY3xL+FtnhLKGiukiNx3MNyYe3WrjcdF+CCGWG8AYRhbzJOSoOoAn5PQ+VkcX7
         vNIQgLHw7NQcG59eCOtoMWVCCBVdqqHKF/5XbUbmyvTydEQHSR4b49GfRt3nuex/pZUZ
         bswyUDV98RUIYmy+bBZvV3CEQTfx/cKcFuZ9CQBZlk5RmAt5mW3ryV5bMJijjzLB/Vdq
         08wqifffHb9muRQM0+2I9EYbahlNAPrMT/owM8J4bCTjDVgX9c7Kn3IXlljoD+AGbjMy
         Ro4g==
X-Gm-Message-State: AFqh2kpoulMgWVkRHZOz/1NLRbn6AbHwG8ta+UMxlo6435bxnqM6vOEk
        QPvJM8Q+uuuotBvGqo8l6uQTejmM7E+HGruWwFpM0w==
X-Google-Smtp-Source: AMrXdXupLlRU1794URzIsqQNP+rdNjB+ialAMHEflMgrpUGU4vGKeZ7VQKQDqIj7Yd7LKbscJcUzylDa4lYvAn279eU=
X-Received: by 2002:a0d:e2c1:0:b0:474:1969:ed89 with SMTP id
 l184-20020a0de2c1000000b004741969ed89mr3051604ywe.175.1672771786812; Tue, 03
 Jan 2023 10:49:46 -0800 (PST)
MIME-Version: 1.0
References: <20221222023457.1764-1-vipinsh@google.com> <20221222023457.1764-9-vipinsh@google.com>
 <Y64gLzMJ5Ap2VmDs@google.com>
In-Reply-To: <Y64gLzMJ5Ap2VmDs@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Tue, 3 Jan 2023 10:49:11 -0800
Message-ID: <CAHVum0cVzitQ79TJHE0vx2XQqtxvytGd5gmg7-wxFSDUqNEYsA@mail.gmail.com>
Subject: Re: [Patch v3 8/9] KVM: x86/mmu: Make split_shadow_page_cache NUMA aware
To:     David Matlack <dmatlack@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Thu, Dec 29, 2022 at 3:18 PM David Matlack <dmatlack@google.com> wrote:
>
> On Wed, Dec 21, 2022 at 06:34:56PM -0800, Vipin Sharma wrote:
> > Make split_shadow_page_cache NUMA aware and allocate page table's pages
> > during the split based on the underlying physical page's NUMA node.
> >
> > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  2 +-
> >  arch/x86/kvm/mmu/mmu.c          | 50 ++++++++++++++++++---------------
> >  2 files changed, 29 insertions(+), 23 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index b1f319ad6f89..7b3f36ae37a4 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1410,7 +1410,7 @@ struct kvm_arch {
> >        *
> >        * Protected by kvm->slots_lock.
> >        */
> > -     struct kvm_mmu_memory_cache split_shadow_page_cache;
> > +     struct kvm_mmu_memory_cache split_shadow_page_cache[MAX_NUMNODES];
> >       struct kvm_mmu_memory_cache split_page_header_cache;
> >
> >       /*
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 511c6ef265ee..7454bfc49a51 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -6126,7 +6126,7 @@ static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
> >  int kvm_mmu_init_vm(struct kvm *kvm)
> >  {
> >       struct kvm_page_track_notifier_node *node = &kvm->arch.mmu_sp_tracker;
> > -     int r;
> > +     int r, nid;
> >
> >       INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
> >       INIT_LIST_HEAD(&kvm->arch.possible_nx_huge_pages);
> > @@ -6145,8 +6145,9 @@ int kvm_mmu_init_vm(struct kvm *kvm)
> >       INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_page_header_cache,
> >                                 mmu_page_header_cache, NUMA_NO_NODE);
> >
> > -     INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_shadow_page_cache,
> > -                               NULL, NUMA_NO_NODE);
> > +     for_each_node(nid)
> > +             INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_shadow_page_cache[nid],
> > +                                       NULL, NUMA_NO_NODE);
>                                                 ^^^^^^^^^^^^
>                                                 Should this be nid?
Yes, I will fix it in the next version. Thanks
