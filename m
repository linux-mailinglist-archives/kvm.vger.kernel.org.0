Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C793D64DE
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 18:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240265AbhGZQMs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 12:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239942AbhGZQKo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jul 2021 12:10:44 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EDB4C0619C4
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 09:47:56 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id 185so12650226iou.10
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 09:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/gscgTlqJAwtBK+aPZMSmpPlTZ1wrLA7ddYUtDzkea4=;
        b=eW2pP1eixo09AKQQCwkoPmgJHcZI3HV8mvMeiWS1KO8EZLVBQkXJAew6ayYLiCXrgb
         hBYt64Uiv5loTWdc4hWxUIwtlFY0XAVA30oRfO+3MbymozhW8PHxTmvZHa4eRZS7kFe4
         nU6mLDn5U0IASGb7EGVmMTlmPhTNKXxbY2JqCc1LpO2HNYUwsLhzBQawLAIyl6Cl/zl0
         XWCc73CrP33zU2wcyw2gWwd8OqO8t2AGGPcnKccb09SNnMu9O8xYRjjJmBK9nAsP97Sw
         dlMLXrR1YTqyvCNAAgyHz9MaxHlanZnh5yrHWOrLmCN1/2Zy3HwR6r8NgERBntMlLGkL
         8Rwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/gscgTlqJAwtBK+aPZMSmpPlTZ1wrLA7ddYUtDzkea4=;
        b=P6EN31LFZX41Vn60d5GnjNk1HCOaksd3RGUQZ/fl651sI+9xPEWTNBHKuQMk8Gf0LM
         G783uidlCN8DRKqlVl4jWyIw7lSy0Tok05R/xoz1BToiMa2Q5nJzC06/mwkac7/ZJwGt
         stfC7rscxdJIC9KS0jGad4IyCg0qTA7IPynXMFLBUJpzRaOCWiXSNLWvc87o7LLc+nS9
         bIlCxJgGEoqcKoGH1SizVAiqouAIkhy+8joWhsZNNHBWp45Q4/MJAS/VW4kf5gdGjm+N
         KjgygilYLeVij10n12kA34vdNz8Z61D0dqRMGKQn5jWTNKDld3+2Ciwk0GxSIG9KfQor
         y6Kg==
X-Gm-Message-State: AOAM532O66Fi8bSErpSoKeTdwRc/UDg4ZLcPdBch8T/or0hiKbS5+fGc
        xBO4423eGPnJ0OpKbBxSoQR112MTTTmhkJmcwMidqg==
X-Google-Smtp-Source: ABdhPJxr2DHNlsY36LedoSQBviPFgzyvH39XXlAV2YkiSqJAmkTNXF+z2xtRX/2vLLVAdpZto6928JLGRTlM46IpnGc=
X-Received: by 2002:a05:6638:2416:: with SMTP id z22mr17318372jat.57.1627318075369;
 Mon, 26 Jul 2021 09:47:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210726075238.GA10030@kili>
In-Reply-To: <20210726075238.GA10030@kili>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 26 Jul 2021 09:47:43 -0700
Message-ID: <CANgfPd-H3a7zdEeV2rtyCTcHinYOwTB=KFFRXYSnYCG8e+tq6w@mail.gmail.com>
Subject: Re: [bug report] KVM: x86/mmu: Use an rwlock for the x86 MMU
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 26, 2021 at 12:52 AM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> [ This is not the correct patch to blame, but there is something going
>   on here which I don't understand so this email is more about me
>   learning rather than reporting bugs. - dan ]
>
> Hello Ben Gardon,
>
> The patch 531810caa9f4: "KVM: x86/mmu: Use an rwlock for the x86 MMU"
> from Feb 2, 2021, leads to the following static checker warning:
>
>         arch/x86/kvm/mmu/mmu.c:5769 kvm_mmu_zap_all()
>         warn: sleeping in atomic context
>
> arch/x86/kvm/mmu/mmu.c
>     5756 void kvm_mmu_zap_all(struct kvm *kvm)
>     5757 {
>     5758        struct kvm_mmu_page *sp, *node;
>     5759        LIST_HEAD(invalid_list);
>     5760        int ign;
>     5761
>     5762        write_lock(&kvm->mmu_lock);
>                 ^^^^^^^^^^^^^^^^^^^^^^^^^^
> This line bumps the preempt count.
>
>     5763 restart:
>     5764        list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link) {
>     5765                if (WARN_ON(sp->role.invalid))
>     5766                        continue;
>     5767                if (__kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list, &ign))
>     5768                        goto restart;
> --> 5769                if (cond_resched_rwlock_write(&kvm->mmu_lock))
>                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> This line triggers a sleeping in atomic warning.  What's going on here
> that I'm not understanding?


Hi Dan,

Thanks for sending this. I'm confused by this sequence too. I'm not
sure how this could sleep in an atomic context.
My first thought was that there might be something going on with the
qrwlock's wait_lock, but since this thread already acquired the
rwlock, it can't be holding / waiting on the wait_lock.

Then I thought the __might_sleep could be in the wrong place, but it's
in the same place for a regular spinlock, so I think that's fine.

I do note that __cond_resched_rwlock does not check rwlock_needbreak
like __cond_resched_lock checks spin_needbreak. That seems like an
oversight, but I don't see how it could cause this warning.

I'm as confused by this as you. Did you confirm that this sleeping in
atomic warning does not happen before this commit? What kind of
configuration are you able to reproduce this on?

It might be worth asking some sched / locking folks about this as
they'll likely have a better understanding of all the intricacies of
the layers of locking macros.
I'm very curious to understand what's causing this too.

Ben

>
>
>     5770                        goto restart;
>     5771        }
>     5772
>     5773        kvm_mmu_commit_zap_page(kvm, &invalid_list);
>     5774
>     5775        if (is_tdp_mmu_enabled(kvm))
>     5776                kvm_tdp_mmu_zap_all(kvm);
>     5777
>     5778        write_unlock(&kvm->mmu_lock);
>     5779 }
>
> regards,
> dan carpenter
