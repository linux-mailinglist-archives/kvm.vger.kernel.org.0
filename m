Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79FD7679E06
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 16:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233876AbjAXPyz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 10:54:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233378AbjAXPyx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 10:54:53 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F80C49550
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 07:54:53 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id b24-20020a17090a551800b0022beefa7a23so2232613pji.5
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 07:54:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tTB7QQhaFSlJZCgaajKbzp9eWeGSwdO4XEz/GYqEPW8=;
        b=WLrzs2UbKnxvmlEXQmhbTDf/QauwbyqmKmZHAz2K8tZCKPQ9o3EQGeimUUsavMAWkx
         BpehPBLyWtPsQg9sAQUeSxs81wkP4Puvj6RhemDLofbk5gO5J44dUGm0Aw9yLAnyXN26
         Yousn6hgnAHb0Csm8CynGQBc96HZvQqjSi+hJCn0GMxNJiPS7alV93LHIOWv916+f3o/
         ZpesoNLvsQiqCicY00FkXJ3KfNyA+dVGmhr22vEfUgbqb059OAyNtAdEMEw3zaQE5QVl
         0RXelImEnStBITFtg8EGEvdCAdIskk2a5N8OsKDzE0qlVPzAbMFSVyu0fGVq0uEzc6Vr
         baLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tTB7QQhaFSlJZCgaajKbzp9eWeGSwdO4XEz/GYqEPW8=;
        b=MSMRxF29DXKn+PxEKpfAtw5QpdO1+CDnIIP5U77Rct8i9PE52xZNcRoQtMBBkKle42
         bO3wtecV4DurjcRxTmqmb2w/FFEV4Phxg6TzvE5SHap5PIPcwWQd2IL1cRPPBySW8WsH
         01jYtmpzo5Jjm4tJty7UgVQPIBioUITxsuK4x9p4+bCfE+/DWLocSb2FGcWD+tPEqdMP
         AIhC2KwQgqZY9EhVqa8uR4NY50jklW0osJC4yPsZw47nZ3T31ym/e27TPxDDE0CsSDhY
         jpHe7EUd0vcDpy1OuZ7nrqqpE/yC8ujTbEXCXt7MrazpiCtXDKbJLkULqCsjiBkX2gdt
         l5jQ==
X-Gm-Message-State: AO0yUKXpo6nnMKWpxa6zyg6lNmGARHexLMS+GxcbI4QoNW9UbaL7Y1T2
        2VM0eKDxTavQ2h6GYX36GFh8QQLEu5pq7uX7Wj/tIw==
X-Google-Smtp-Source: AK7set82EVT6qAWOMs7UHodk557+mxhNz3qM85ri7lrGhnXrY20LJRqZ9w9mYPYVIvADZLnUH7oe+A==
X-Received: by 2002:a17:903:2644:b0:189:b910:c6d2 with SMTP id je4-20020a170903264400b00189b910c6d2mr169346plb.1.1674575692495;
        Tue, 24 Jan 2023 07:54:52 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id ja5-20020a170902efc500b001930b189b32sm1816858plb.189.2023.01.24.07.54.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 07:54:51 -0800 (PST)
Date:   Tue, 24 Jan 2023 07:54:48 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vipin Sharma <vipinsh@google.com>
Subject: Re: [PATCH 2/2] selftests: KVM: Add page splitting test
Message-ID: <Y8//SKBTT2h2m8Cz@google.com>
References: <20230119212510.3938454-1-bgardon@google.com>
 <20230119212510.3938454-3-bgardon@google.com>
 <Y8nKerX9tDRHkFq+@google.com>
 <CANgfPd8B_0w39d7V+c4GnUxdqrc8qN78r8Pq0Con3Mx9WO0hkQ@mail.gmail.com>
 <Y8qj1QS1VadgaX7A@google.com>
 <CAOHnOrzKBh2Cq7ZQece+6f6P5wS6gZ1R2vjEQ5=QLTy7BmUvFQ@mail.gmail.com>
 <CANgfPd_B0q6uU1Be7A-QOj5_YoWi8z9g9LO63mc+=136hO5K4Q@mail.gmail.com>
 <Y87UzmpCg9hXO2NI@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y87UzmpCg9hXO2NI@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 23, 2023 at 10:41:18AM -0800, David Matlack wrote:
> On Fri, Jan 20, 2023 at 12:04:04PM -0800, Ben Gardon wrote:
> > On Fri, Jan 20, 2023 at 6:34 AM Ricardo Koller <ricarkol@google.com> wrote:
> > >
> > ...
> > > > > > > +
> > > > > > > +     run_test(&p);
> > > > > >
> > > > > > Use for_each_guest_mode() to run against all supported guest modes.
> > > > >
> > > > > I'm not sure that would actually improve coverage. None of the page
> > > > > splitting behavior depends on the mode AFAICT.
> > > >
> > > > You need to use for_each_guest_mode() for the ARM case. The issue is
> > > > that whatever mode (guest page size and VA size) you pick might not be
> > > > supported by the host. So, you first to explore what's available (via
> > > > for_each_guest_mode()).
> > >
> > > Actually, that's fixed by using the default mode, which picks the
> > > first available
> > > mode. I would prefer to use for_each_guest_mode() though, who knows and
> > > something fails with some specific guest page size for some reason.
> > 
> > Okay, will do. I wasn't sure if we did eager page splitting on ARM, so
> 
> Ricardo is in the process of upstreaming eager page splitting for ARM:
> 
> https://lore.kernel.org/kvm/20230113035000.480021-1-ricarkol@google.com/
> 
> > I was only planning on making this test for x86_64 initially, hence it
> > being in that directory. If ARM rolls with the same behavior, then
> > I'll add the for_each_mode bit and move the test up a directory.
> 
> In addition to for_each_guest_mode(), KVM/ARM will need to expose page
> size stats so the test can verify the splitting (yet another reason to
> have a common MMU).
> 
> Ricardo, if you're interested in adding page size stats to KVM/ARM ahead
> of the Common MMU, e.g. to test eager page splitting, let me know.

Sure, I can do that. Sounds pretty useful too.

> I
> want to make sure we align on the userspace-visible stat names to avoid
> churn down the road. Specifically, do we want to expose neutral names
> like pages_{pte,pmd,pud} or expand the KVM/x86 list to include all of
> ARM's possible pages sizes like pages_{4k,16k,64k,...} (or both)?

I would prefer the latter, mainly to match the x86 names:

	+	stats->pages_4k = vm_get_stat(vm, "pages_4k");
	+	stats->pages_2m = vm_get_stat(vm, "pages_2m");
	+	stats->pages_1g = vm_get_stat(vm, "pages_1g");
	(from this patch)

but pages_{pte,pmd,pud} would certainly make this test simpler
as it would handle all guest page sizes:

	+	stats->pages_pte = vm_get_stat(vm, "pages_pte");


