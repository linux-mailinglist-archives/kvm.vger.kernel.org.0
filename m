Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4BFF65CB33
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 02:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237880AbjADBGB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 20:06:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbjADBF7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 20:05:59 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E394D12AA6
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 17:05:56 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id z16so15107666wrw.1
        for <kvm@vger.kernel.org>; Tue, 03 Jan 2023 17:05:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lgU5P1L7gNa0tdGaVNRVNmjRoo+ImVqTA7zCp84GB0c=;
        b=qGUnY8Efw2L/MMNwi630Qmj5ZtTbvDdbNsCc9pxjCtL6dq5EoWqLgMppGhj0qsYW0X
         +SRHbP0RRQ1uBfea18yol+aI/Pv12mk+h6GeP3mUDqVxXh0I5o1xz9TDMYzuN2onN2Vr
         mlalR8Ncr5FwRc2lx4rly7yJJTdzbafuET8EhbjUEwITKEpYR53+7O5whvUuHYLynjFI
         9rzjOUndQipPw8tcRjeolIcQxv2kFXsh6GkOK34d2ZYZITvkYF3KnPGiM9G9jtRVLufD
         UeUbP5GfKFeiS2ZTdsU/Vswh3JhBBdOxD1HZeNsANzU9REwSAxdk08TyvEVfzlNRex1J
         vZ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lgU5P1L7gNa0tdGaVNRVNmjRoo+ImVqTA7zCp84GB0c=;
        b=EHbwo5VUCTvxOua0FyuskdLtF+N94vdD1+C1sRHhbBmd2XfmumCbj4kB1aZPyLMHj2
         mp7nh6UOTqVv6rEu8IW5MbDMJgJKfIWk8dg5yu+83wn3MfJlBzaGv43JhMnOw7u5dYAI
         chakhiRAtHqSMUbr7tK+UUQHEzPMeGEyfEC6nLDBrZRBgKzywBxu8wP/d0YLSzWzUD3z
         dNWAmSYfqmYl6pV9b93ez/UkiWuAVBjOdXXQ9bncXKXPU07zejydcac6ckS4bbb4ki/O
         TGlD28DUXBTrSEe7SxZvKOY+d+nUHqbG1812IXJvW/LW9QjBDqfSqxDSlcHbf31rEA/V
         tpCQ==
X-Gm-Message-State: AFqh2krsobYxjT3hZeMEQnE1WrwBtfahpjcLJ1Tdm/kPbe6N9fDVu3tO
        HoIQxm4aWEc6FqXGwtxDnKekIPkFb4mFAUgGn3Lt5g==
X-Google-Smtp-Source: AMrXdXud6BQyRhsvF5DXlHBM3atTldfPr46GP7x93GUitenY95hZSa0+puECh+8/Q3mvX0ziCjtBlpIpyR5jQ44EQzM=
X-Received: by 2002:a5d:6148:0:b0:280:91ea:29b7 with SMTP id
 y8-20020a5d6148000000b0028091ea29b7mr907851wrt.98.1672794355405; Tue, 03 Jan
 2023 17:05:55 -0800 (PST)
MIME-Version: 1.0
References: <Y44NylxprhPn6AoN@x1n> <CALzav=d=N7teRvjQZ1p0fs6i9hjmH7eVppJLMh_Go4TteQqqwg@mail.gmail.com>
 <Y442dPwu2L6g8zAo@google.com> <CADrL8HV_8=ssHSumpQX5bVm2h2J01swdB=+at8=xLr+KtW79MQ@mail.gmail.com>
 <Y46VgQRU+do50iuv@google.com> <CADrL8HVM1poR5EYCsghhMMoN2U+FYT6yZr_5hZ8pLZTXpLnu8Q@mail.gmail.com>
 <Y4+DVdq1Pj3k4Nyz@google.com> <CADrL8HVftX-B+oHLbjnJCret01yjUpOjQfmHdDa7mYkMenOa+A@mail.gmail.com>
 <CALzav=cyPgsYPZfxsUFMBJ1j33LHxfSY-Bj0ttZqjozDm745Nw@mail.gmail.com>
 <CADrL8HV2K=NAGATdRobq8aMJJwRapiF7gxrJovhz7k-Me3ZFuw@mail.gmail.com> <Y7TO5Xxi5RWw1Xa6@google.com>
In-Reply-To: <Y7TO5Xxi5RWw1Xa6@google.com>
From:   James Houghton <jthoughton@google.com>
Date:   Wed, 4 Jan 2023 01:05:42 +0000
Message-ID: <CADrL8HWr6-+i_MYmuPDACffB9k+cK2Fh2Z2KPBiM5W3DgH2F_A@mail.gmail.com>
Subject: Re: [RFC] Improving userfaultfd scalability for live migration
To:     Sean Christopherson <seanjc@google.com>
Cc:     David Matlack <dmatlack@google.com>, Peter Xu <peterx@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Linux MM <linux-mm@kvack.org>, kvm <kvm@vger.kernel.org>,
        chao.p.peng@linux.intel.com, Oliver Upton <oupton@google.com>
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

On Wed, Jan 4, 2023 at 12:57 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Dec 08, 2022, James Houghton wrote:
> > - For the no-slow-GUP choice, if someone MADV_DONTNEEDed memory and we
> > didn't know about it, we would get stuck in MADV_POPULATE_WRITE. By
> > using UFFD_FEATURE_THREAD_ID, we can tell if we got a userfault for a
> > thread that is in the middle of a MADV_POPULATE_WRITE, and we can try
> > to unblock the thread by doing an extra UFFDIO_CONTINUE.
> >
> > - For the PF_NO_UFFD_WAIT choice, if someone MADV_DONTNEEDed memory,
> > we would just keep trying to start the vCPU without doing anything (we
> > assume some other thread has UFFDIO_CONTINUEd for us). This is
> > basically the same as if we were stuck in MADV_POPULATE_WRITE, and we
> > can try to unblock the thread in a fashion similar to how we would in
> > the other case.
> >
> > So really these approaches have similar requirements for what
> > userspace needs to track. So I think I prefer the no-slow-GUP approach
> > then.
>
> Are you planning on sending a patch (RFC?) for the no-slow-GUP approach?  It sounds
> like there's a rough consensus that that's a viable, minimally invasive solution.

Yes, soon. amoorthy@google.com is working on it.

Also a small correction regarding userspace needing to track
MADV_DONTNEEDs, userfaultfd already handles that with
UFFD_EVENT_REMOVE, so it's a non-issue. Even more reason to take the
no-slow-GUP approach.

- James
