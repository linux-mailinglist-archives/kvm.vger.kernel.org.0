Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD3E757C7B3
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 11:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbiGUJdI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 05:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbiGUJdH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 05:33:07 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732768053F;
        Thu, 21 Jul 2022 02:33:06 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id b26so1424090wrc.2;
        Thu, 21 Jul 2022 02:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l5niOVFsh2sCh8YnUUi4BLzbtkhxEAzqscgbM7MRnjQ=;
        b=bm50RtAX9ajTFua0iJ1xCdzl0sJ0gmSnfo+3vWGB6+0kShPYneL1iaUpdoOMSBVRyE
         9zvUrs+pmkPjiMmOtmvaNb1xd936dlYQMI0M2b69oEJfRHDgJV7B/cl8a7bUekMzPzQT
         QCzrb+NzoT7sLD9W2NNP4+fE5hDyMSaMXUxJ+xYtEXqCDHr+G0SpQkNQaafo327mhHlp
         zZ4+E1TVwW0GgLkaldq+MXeVS9sDlRFJ5GzFuQfK3Fk6a8Acwtnjnio5pxFCjZeTnVnA
         vU4MEcAYDx/fe2LUcET6whSW8NKVJFIsT7h4Q3qSdGkkFdLcljo7QcW+UaOLjctVQZNC
         meYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l5niOVFsh2sCh8YnUUi4BLzbtkhxEAzqscgbM7MRnjQ=;
        b=IzBzZoPLXi1ZGh6zyLjeuoKLFLXJdXZSw9EpPEiNrPb0zxJ+Zs90dyNYpb9qYPY/n/
         lGCfOBZKSoozK8FLwIYV6Dk7wj1nFTWlroaZMvQFXB961L17aeUNQvn2WK5vaI7mk4CZ
         v9dAOOnc5arrfdzUIpOJdQ68UmOetnF6h9b0ZtSmrpxD8g2z+DhIsvNSuyOWOGO7VpOo
         8mUJhzDy3LlD0f6k0XTpCeAThuHmZFOKMV6SA68mAuVDmxnqPnlP3PwF/Bqmg7nOt6uc
         9/YhD1FCyapsRpsuc1ARDMNmwcZ9QlQ/ExLcr6H5Pnc0GupnWagyYRoejHPis3Xx2/0Z
         Wq3g==
X-Gm-Message-State: AJIora/51sf74P9vJS4c2Aq7uQFBUlzg+jd0t5GQl1jLO7xWWbV1hoBx
        AR6ta3tX/GL8p+4t8smLhWP5f3S+7EREIIdi//bZAGcEP7Q=
X-Google-Smtp-Source: AGRyM1ssa3GPQdBMD2hAosSKN1BnrY5ZSF80zStvf8FgpyiS1ZTqrK/LEtoqIQnCq0JVG2zYF8OEXBpT3X5mYZ9FP70=
X-Received: by 2002:a05:6000:1a87:b0:21d:b5b9:7666 with SMTP id
 f7-20020a0560001a8700b0021db5b97666mr34540696wry.1.1658395984874; Thu, 21 Jul
 2022 02:33:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220605064342.309219-1-jiangshanlai@gmail.com>
 <20220605064342.309219-6-jiangshanlai@gmail.com> <YtcLiNskPb8z/2Qc@google.com>
In-Reply-To: <YtcLiNskPb8z/2Qc@google.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Thu, 21 Jul 2022 17:32:53 +0800
Message-ID: <CAJhGHyAoM+6cOh7XQUvavgJcUts53FW6BnjM_wqMD6fkoYoB3w@mail.gmail.com>
Subject: Re: [PATCH 05/12] KVM: X86/MMU: Clear unsync bit directly in __mmu_unsync_walk()
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 20, 2022 at 3:52 AM Sean Christopherson <seanjc@google.com> wrote:

> > ---
> >  arch/x86/kvm/mmu/mmu.c | 22 +++++++++++++---------
> >  1 file changed, 13 insertions(+), 9 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index f35fd5c59c38..2446ede0b7b9 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -1794,19 +1794,23 @@ static int __mmu_unsync_walk(struct kvm_mmu_page *sp,
> >                               return -ENOSPC;
> >
> >                       ret = __mmu_unsync_walk(child, pvec);
> > -                     if (!ret) {
> > -                             clear_unsync_child_bit(sp, i);
> > -                             continue;
> > -                     } else if (ret > 0) {
> > -                             nr_unsync_leaf += ret;
> > -                     } else
> > +                     if (ret < 0)
> >                               return ret;
> > -             } else if (child->unsync) {
> > +                     nr_unsync_leaf += ret;
> > +             }
> > +
> > +             /*
> > +              * Clear unsync bit for @child directly if @child is fully
> > +              * walked and all the unsync shadow pages descended from
> > +              * @child (including itself) are added into @pvec, the caller
> > +              * must sync or zap all the unsync shadow pages in @pvec.
> > +              */
> > +             clear_unsync_child_bit(sp, i);
> > +             if (child->unsync) {
> >                       nr_unsync_leaf++;
> >                       if (mmu_pages_add(pvec, child, i))
>
> This ordering is wrong, no?  If the child itself is unsync and can't be added to
> @pvec, i.e. fails here, then clearing its bit in unsync_child_bitmap is wrong.

mmu_pages_add() can always successfully add the page to @pvec and
the caller needs to guarantee there is enough room to do so.

When it returns true, it means it will fail if you keep adding pages.

>
> I also dislike that that this patch obfuscates that a shadow page can't be unsync
> itself _and_ have unsync children (because only PG_LEVEL_4K can be unsync).  In
> other words, keep the
>
>         if (child->unsync_children) {
>
>         } else if (child->unsync) {
>
>         }
>

The code was not streamlined like this just because
I need to add some comments on clear_unsync_child_bit().

Duplicated clear_unsync_child_bit() would require
duplicated comments.  I will use "See above" instead.
