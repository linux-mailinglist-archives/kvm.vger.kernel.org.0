Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD45069829F
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 18:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbjBORrp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 12:47:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjBORro (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 12:47:44 -0500
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9167737F15
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 09:47:43 -0800 (PST)
Received: by mail-qv1-xf30.google.com with SMTP id y2so7930983qvo.4
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 09:47:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1676483262;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WP1JNa4W/AmrkCNSc3ANi+zdSMWTWC+4FVT8pyWRWzQ=;
        b=dknhbWOUpFszYt6gBrp4BoGaoVHJjeRNv1YFklJ5PG1D8K5n1CnRItYUd4M2EGWI2B
         lFYYuiUdhWflZ30VKY7UbE7/cpM63SQP9FvzGvrdT9qoDMwEV+DGAEOY9yCAHXsbDTpx
         tDMlvoppgQOCrWWSxGtJHt/wkn1LNBmS9iMvi3fqJAK17GTOSCYCaHuLK6TJWjtl6OZ3
         FB3waJt+Pttk6llI2s1xcONUVHcNB/1XN2RAg8IJR2dDiXPSELH6lCnm/228xpnIjnGw
         Nv4JLVN51NT3PftRlJG4OCV7vpHqYB6PuwN6TsGe9zACTFaFjxv/N8R5nmGCIAnUYxV/
         qVsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676483262;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WP1JNa4W/AmrkCNSc3ANi+zdSMWTWC+4FVT8pyWRWzQ=;
        b=CTLd7klLVfByWKpwaYAUn1VBsA/gSKKTohXq+QzMy9+bvyV4aoaYuz+C7rHKt0aN7W
         aqSNeiOutfWQVRhXmOraHbAtyY9vSZfrUuqUOLOuos4A6YphQjJYanO56UeS5g719fs2
         tS3mFWTtm67a/f/J+dEF0YarXbLozf8NcI6n0i6atHZOg61n02RmhhrRNj1jZ8Qg8uXS
         xEW8lzL7gJNlfeP0GDKX2HrX80sDgcL6ma4dg+GdCvBCqwZgjdXDEfrFpjuUDe+N95Ep
         8fUt79RLHJxPYo2+6FhnWX+N5QH133P1RXjUBQBNGunJAJu8yY2eZ2H/AjcPVfggwDNm
         eTKg==
X-Gm-Message-State: AO0yUKVcocHOfIERK2ovSJvD6/u5Og49TSJol0wkc/ocx8SedPx/MZd5
        f4qW9f0We1uiJczt/aB5mZPx3/CxyEfiX2EDLifgeg==
X-Google-Smtp-Source: AK7set8M3sXmHwvK69zDrbwFGZgKFkFCni1niDqX3B4zq45NHNGOIzD6V5SLqvS7S916jJ2NYLM1txdZflOHnRDLjOs=
X-Received: by 2002:a0c:e086:0:b0:56e:a207:142d with SMTP id
 l6-20020a0ce086000000b0056ea207142dmr222494qvk.6.1676483262557; Wed, 15 Feb
 2023 09:47:42 -0800 (PST)
MIME-Version: 1.0
References: <20230206165851.3106338-1-ricarkol@google.com> <20230206165851.3106338-6-ricarkol@google.com>
 <8be5c7be-fd43-86e8-6b3d-6085dd4f3cc6@redhat.com>
In-Reply-To: <8be5c7be-fd43-86e8-6b3d-6085dd4f3cc6@redhat.com>
From:   Ricardo Koller <ricarkol@google.com>
Date:   Wed, 15 Feb 2023 09:47:31 -0800
Message-ID: <CAOHnOrxMjJ6RZZ4mnLKrJSEee+6PagLPNf+b-OSpfxbj+2Pa=w@mail.gmail.com>
Subject: Re: [PATCH v2 05/12] KVM: arm64: Refactor kvm_arch_commit_memory_region()
To:     Gavin Shan <gshan@redhat.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, reijiw@google.com, rananta@google.com,
        bgardon@google.com, ricarkol@gmail.com
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

On Wed, Feb 8, 2023 at 10:02 PM Gavin Shan <gshan@redhat.com> wrote:
>
> Hi Ricardo,
>
> On 2/7/23 3:58 AM, Ricardo Koller wrote:
> > Refactor kvm_arch_commit_memory_region() as a preparation for a future
> > commit to look cleaner and more understandable. Also, it looks more
> > like its x86 counterpart (in kvm_mmu_slot_apply_flags()).
> >
> > No functional change intended.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >   arch/arm64/kvm/mmu.c | 15 +++++++++++----
> >   1 file changed, 11 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 9bd3c2cfb476..d2c5e6992459 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1761,20 +1761,27 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
> >                                  const struct kvm_memory_slot *new,
> >                                  enum kvm_mr_change change)
> >   {
> > +     bool log_dirty_pages = new && new->flags & KVM_MEM_LOG_DIRTY_PAGES;
> > +
> >       /*
> >        * At this point memslot has been committed and there is an
> >        * allocated dirty_bitmap[], dirty pages will be tracked while the
> >        * memory slot is write protected.
> >        */
> > -     if (change != KVM_MR_DELETE && new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
> > +     if (log_dirty_pages) {
> > +
> > +             if (change == KVM_MR_DELETE)
> > +                     return;
> > +
>
> When @change is KVM_MR_DELETE, @new should be NULL. It means this check
> isn't needed?

If you don't mind, I prefer not risking making this commit change some
functionality.

>
> >               /*
> >                * If we're with initial-all-set, we don't need to write
> >                * protect any pages because they're all reported as dirty.
> >                * Huge pages and normal pages will be write protect gradually.
> >                */
> > -             if (!kvm_dirty_log_manual_protect_and_init_set(kvm)) {
> > -                     kvm_mmu_wp_memory_region(kvm, new->id);
> > -             }
> > +             if (kvm_dirty_log_manual_protect_and_init_set(kvm))
> > +                     return;
> > +
> > +             kvm_mmu_wp_memory_region(kvm, new->id);
> >       }
> >   }
> >
>
> Thanks,
> Gavin
>
>
>
