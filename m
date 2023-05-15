Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D10E77030FB
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 17:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242141AbjEOPHK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 11:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242113AbjEOPHH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 11:07:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B92519A1
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 08:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684163150;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mMiRcXgp4xTERmW4ger84CCwzwpKxTdK8sNyJO+9QFs=;
        b=f9hPw32nJL+W1LaKBK3CouLG9tVgYFeP4qRo/xd5OKc59mMb5GUnawx2ozMfN0DRY1m/ui
        fDRssxYgU9P7snMNw9ZTFW27qgX75LtyETzCZJeMAsQVsJ23kkqylh79eZLCz4DVyQLesS
        y+SodaXQj2puBtevaDlkUSoH3GXAQF4=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-171-J8rsmBfnO5yWOHwOib9TSw-1; Mon, 15 May 2023 11:05:49 -0400
X-MC-Unique: J8rsmBfnO5yWOHwOib9TSw-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-3f398a25be2so4202451cf.0
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 08:05:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684163149; x=1686755149;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mMiRcXgp4xTERmW4ger84CCwzwpKxTdK8sNyJO+9QFs=;
        b=RBTZEA6fiLFTrTxFWIvSNQaP5rTWjIO0zBMLzU/zGI+9wo+fEsLQUj8YC8E/0PR9JO
         SLzlEdhn0S9OeN9s6nwHw5rXKrMiF5ZgUOgguhomxpvrR6bkVwhO61BT8ZAFbmNC5u6L
         CdnA96InyHJSN4mLUBpW/I2WgBDIYGFIGVC3uFnLGOJBKrJ6L/0lnz3N7z0d5esJx8UZ
         DIkB9Oa1TRs3DWgQDxVpH7QbMVsrRhjPjBDXyO4K3PYBTjyCADKt7ydIMQ3tjXB5TILM
         /yIQcB8UJuGbrKPV3nK/S2j/2tZf1Be4tvGSzRLBPHjjwqP9abWm3WqVDhTIE0wj4cLH
         +BZw==
X-Gm-Message-State: AC+VfDzjI5Bal3K5aFYBzrBN6T9I9K72Dy1+gIhoOswT9o9/iSn2Ok/G
        B9+JADwOciShO6ryENCvAZ/TJrXbZoKIsWf80OqqcK0Xh6CTnfRTrrsatdESkB1Vx7S59+cNjlN
        /xxp3iK+JGYEc
X-Received: by 2002:a05:622a:14ce:b0:3ef:5587:723b with SMTP id u14-20020a05622a14ce00b003ef5587723bmr15837184qtx.3.1684163148746;
        Mon, 15 May 2023 08:05:48 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6fuKFZn8nWKO+IpreRY5odGmJjJSvH/yDsUT1zPfllrG5zSJxbS/qVgIBwFcdhWdqsqk3Pdw==
X-Received: by 2002:a05:622a:14ce:b0:3ef:5587:723b with SMTP id u14-20020a05622a14ce00b003ef5587723bmr15837145qtx.3.1684163148295;
        Mon, 15 May 2023 08:05:48 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-62-70-24-86-62.dsl.bell.ca. [70.24.86.62])
        by smtp.gmail.com with ESMTPSA id ay24-20020a05622a229800b003ee4b5a2dd3sm4386360qtb.21.2023.05.15.08.05.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 May 2023 08:05:47 -0700 (PDT)
Date:   Mon, 15 May 2023 11:05:46 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Axel Rasmussen <axelrasmussen@google.com>
Cc:     David Matlack <dmatlack@google.com>,
        Anish Moorthy <amoorthy@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, maz@kernel.org,
        oliver.upton@linux.dev, James Houghton <jthoughton@google.com>,
        bgardon@google.com, ricarkol@google.com, kvm <kvm@vger.kernel.org>,
        kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
Message-ID: <ZGJKSl7mb5t30zwN@x1n>
References: <ZFLRpEV09lrpJqua@x1n>
 <ZFLVS+UvpG5w747u@google.com>
 <ZFLyGDoXHQrN1CCD@x1n>
 <ZFQC5TZ9tVSvxFWt@x1n>
 <CAF7b7mrTGL8rLVCmsmX4dZinZHRFFB7R7kX0Wv9FZR-B-4xhhw@mail.gmail.com>
 <ZFhO9dlaFQRwaPFa@x1n>
 <CAF7b7mqPdfbzj6cOWPsg+Owysc-SOTF+6UUymd9f0Mctag=8DQ@mail.gmail.com>
 <ZFwRuCuYYMtuUFFA@x1n>
 <CALzav=e29rRw4TTRGpTkazgJpU1zPML3zQGoyeHj9Zbkq+yAdQ@mail.gmail.com>
 <CAJHvVci4VuQ_vdpRKczg4ic6x7eZRXE4+ZUvzO-xU_9VJ1Vqvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJHvVci4VuQ_vdpRKczg4ic6x7eZRXE4+ZUvzO-xU_9VJ1Vqvg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 11, 2023 at 10:33:24AM -0700, Axel Rasmussen wrote:
> On Thu, May 11, 2023 at 10:18 AM David Matlack <dmatlack@google.com> wrote:
> >
> > On Wed, May 10, 2023 at 2:50 PM Peter Xu <peterx@redhat.com> wrote:
> > > On Tue, May 09, 2023 at 01:52:05PM -0700, Anish Moorthy wrote:
> > > > On Sun, May 7, 2023 at 6:23 PM Peter Xu <peterx@redhat.com> wrote:
> > >
> > > What I wanted to do is to understand whether there's still chance to
> > > provide a generic solution.  I don't know why you have had a bunch of pmu
> > > stack showing in the graph, perhaps you forgot to disable some of the perf
> > > events when doing the test?  Let me know if you figure out why it happened
> > > like that (so far I didn't see), but I feel guilty to keep overloading you
> > > with such questions.
> > >
> > > The major problem I had with this series is it's definitely not a clean
> > > approach.  Say, even if you'll all rely on userapp you'll still need to
> > > rely on userfaultfd for kernel traps on corner cases or it just won't work.
> > > IIUC that's also the concern from Nadav.
> >
> > This is a long thread, so apologies if the following has already been discussed.
> >
> > Would per-tid userfaultfd support be a generic solution? i.e. Allow
> > userspace to create a userfaultfd that is tied to a specific task. Any
> > userfaults encountered by that task use that fd, rather than the
> > process-wide fd. I'm making the assumption here that each of these fds
> > would have independent signaling mechanisms/queues and so this would
> > solve the scaling problem.
> >
> > A VMM could use this to create 1 userfaultfd per vCPU and 1 thread per
> > vCPU for handling userfault requests. This seems like it'd have
> > roughly the same scalability characteristics as the KVM -EFAULT
> > approach.
> 
> I think this would work in principle, but it's significantly different
> from what exists today.
> 
> The splitting of userfaultfds Peter is describing is splitting up the
> HVA address space, not splitting per-thread.

[sorry mostly travel last week]

No, my idea was actually split per-thread, but since currently there's no
way to split per thread I was thinking we should start testing with split
per vma so it "emulates" the best we can have out of a split per thread.

> 
> I think for this design, we'd need to change UFFD registration so
> multiple UFFDs can register the same VMA, but can be filtered so they
> only receive fault events caused by some particular tid(s).

Having multiple real uffds per vma is challenging, as you mentioned
enqueuing may be more of an effort, meanwhile it's hard to know what's the
attribute of the uffd over this vma because each uffd has one feature list.

Here what we may need is only the "logical queue" of the uffd.  So I was
considering supporting multi-queue for a _single_ userfaultfd.

I actually mentioned some of it in the very initial reply to Anish:

https://lore.kernel.org/all/ZEGuogfbtxPNUq7t@x1n/

        If the real problem relies in a bunch of threads queuing, is it
        possible that we can provide just more queues for the events?  The
        readers will just need to go over all the queues.

        Way to decide "which thread uses which queue" can be another
        problem, what comes ups quickly to me is a "hash(tid) % n_queues"
        but maybe it can be better.  Each vcpu thread will have different
        tids, then they can hopefully scale on the queues.

The queues may need to be created also as sub-uffds, each only support
partial of the uffd interfaces (read/poll, COPY/CONTINUE/ZEROPAGE) but not
all (e.g. UFFDIO_API shouldn't be supported there).

> This might also incur some (small?) overhead, because in the fault path
> we now need to maintain some data structure so we can lookup which UFFD
> to notify based on a combination of the address and our tid. Today, since
> VMAs and UFFDs are 1:1 this lookup is trivial.  I think it's worth
> keeping in mind that a selling point of Anish's approach is that it's a
> very small change. It's plausible we can come up with some alternative
> way to scale, but it seems to me everything suggested so far is likely to
> require a lot more code, complexity, and effort vs. Anish's approach.

Yes, I think that's also the reason why I thought I overloaded too much on
this work.  If Anish eagerly wants that and make it useful, then I'm
totally fine because maintaining the 2nd cap seems trivial assuming the
maintainer already would accept the 1st cap.

I just hope it'll be thoroughly tested with even Google's private userspace
hypervisor, so the kernel interface is (even if not straightforward enough
to a new user seeing this) solid so it will service the goal for the
problem Anish is tackling with.

Thanks,

-- 
Peter Xu

