Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 652C051BC2E
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 11:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353538AbiEEJfE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 05:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354489AbiEEJc3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 05:32:29 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B8DD4474E
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 02:28:37 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id y3so7531243ejo.12
        for <kvm@vger.kernel.org>; Thu, 05 May 2022 02:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jgD3dc30hDSb1sD/UY6bEqet0i6vaf7qFrSseTwVNYk=;
        b=AL+W36rG74HIjR7zaLNYDXv7uSAljpTmTNM3/NbEJPtF3r/FczPy7N0H1TKpr0iDNE
         5Jpup+8W0EqlW0WraQAIOwvDfQH1nZM+uScEMaNMCRKqyvvIsSWWzu5vpkyyJI+9WIEY
         MAV/uQa2mlVvQohDBI4anyK9XzqJz7vbKWbGNTI53C0HHx+Jzy4F7cI3H4Zu2J3wW4+g
         O4zfrwMe3VIjDQj6II+t+1Ru66BxNg6ti/AoVvviwBqguobmloHpz1fwqr+sH43yl8R1
         tN9ot7YWd+iIfxpQLHIfCqcB47afLIUWohZraQrmd81JCa4p0V3gGLV+hIUFqlK8jCQT
         oodg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jgD3dc30hDSb1sD/UY6bEqet0i6vaf7qFrSseTwVNYk=;
        b=qY8nzYwFI8qVhCGb6fOBl8hn8x9QhDg20NYAYpGJo78DBogigJ/mMy0CpgCJF3bkcE
         8avRlAf31p2Rp7RqPmu/OzZb0bFLXrzrceYzoE0Nqvzh7yhSrCkIXlVp8+T5Dc/2f6A9
         aPLT7u3voxBX6whgQv22JaiV8WaskwfDa2x2R11YyZQ3Mw9MvXyUAfJmc2BHEOJ4229b
         lCxoLLY9dKdH2gZSaJvKV4zX2BfvwfrDKBvEBEw0oR4uJMkQqBbC/EaJbY0UWWLlrVmy
         e1JpQfE9TN6ZdJNSQcCOlRLwrjlCgboGkgYdKCDSKjJZb00sZsqoA5J6T+aenU3AeuOE
         721A==
X-Gm-Message-State: AOAM530Namz2Et40WncRDycw/xMjgFXuugY4jKz+Rz41Rn0K3eYvIue7
        NE4OvlVZYC5uHlKL5kcgLOwUdKIiw58NndCPZNlT
X-Google-Smtp-Source: ABdhPJwCHh59BnQZZit1Nc9Lb2JvDpD0hj6IUMEdMepAcaKROYe9FW2YhKNEvHgXyD1Sr7Q0ABCKkqafkl5IBHqVgcA=
X-Received: by 2002:a17:907:8a23:b0:6f0:14b6:33d9 with SMTP id
 sc35-20020a1709078a2300b006f014b633d9mr25284477ejc.559.1651742916116; Thu, 05
 May 2022 02:28:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220504081117.40-1-xieyongji@bytedance.com> <CACGkMEvdVFP2GkTy2Vxe44xZ+6BOU3FM5WccuHe-32FN1Pm=7A@mail.gmail.com>
 <CACycT3sdLfJPhm73p8onT1zZF3eyt+uPKBj__cfH_RvEk=FoBw@mail.gmail.com> <CACGkMEtQXk-FsSGvEh1CpAYy9O-Zo+s9_CqwfPX358hBJ7gNBg@mail.gmail.com>
In-Reply-To: <CACGkMEtQXk-FsSGvEh1CpAYy9O-Zo+s9_CqwfPX358hBJ7gNBg@mail.gmail.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 5 May 2022 17:29:10 +0800
Message-ID: <CACycT3uYB6n56SSmzbFx3YCW3yMNZnbupwY7_Z25CGEJRyMFOA@mail.gmail.com>
Subject: Re: [PATCH] vringh: Fix maximum number check for indirect descriptors
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst <mst@redhat.com>, rusty <rusty@rustcorp.com.au>,
        fam.zheng@bytedance.com, kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 5, 2022 at 4:23 PM Jason Wang <jasowang@redhat.com> wrote:
>
> On Thu, May 5, 2022 at 4:06 PM Yongji Xie <xieyongji@bytedance.com> wrote:
> >
> > On Thu, May 5, 2022 at 3:47 PM Jason Wang <jasowang@redhat.com> wrote:
> > >
> > > On Wed, May 4, 2022 at 4:12 PM Xie Yongji <xieyongji@bytedance.com> wrote:
> > > >
> > > > We should use size of descriptor chain to check the maximum
> > > > number of consumed descriptors in indirect case.
> > >
> > > AFAIK, it's a guard for loop descriptors.
> > >
> >
> > Yes, but for indirect descriptors, we know the size of the descriptor
> > chain. Should we use it to test loop condition rather than using
> > virtqueue size?
>
> Yes.
>
> >
> > > > And the
> > > > statistical counts should also be reset to zero each time
> > > > we get an indirect descriptor.
> > >
> > > What might happen if we don't have this patch?
> > >
> >
> > Then we can't handle the case that one request includes multiple
> > indirect descriptors. Although I never see this kind of case now, the
> > spec doesn't forbid it.
>
> It looks to me we need to introduce dedicated counters for indirect
> descriptors instead of trying to use a single counter?
>

OK, I see.

> (All evils came from the move_to_indirect()/return_from_indierct()
> logic, vhost have dedicated helper to deal with indirect descriptors -
> get_indirect()).
>

Yes, it tries to handle both direct and indirect cases in one loop.

Thanks,
Yongji
