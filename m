Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 915C06E9DDF
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 23:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbjDTVaN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 17:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbjDTVaL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 17:30:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 401C55599
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 14:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682026150;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HDRlM2AxMnsdyfyV+QoAFp3KBlLJ57QTAbE5avGat94=;
        b=VmNuTIAKIrs7YgiP6OZg2m1G3GgZ/mZkhxxJdx1NS3cp2o8qwl1mU7Zq2UVHb+hVBT9D/z
        mbswCqajcf9dX8vYS9T4gbxqJl8q7RU3xkF+5DQ0cIwZSVdrFeIyVHo+Gt4ARcxBsafqJ9
        vM3u/y5NODtvJOPWeXhAOcJZu9NK3DI=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-567-LHSa9jt_OVip4ggp7Tmbyw-1; Thu, 20 Apr 2023 17:29:09 -0400
X-MC-Unique: LHSa9jt_OVip4ggp7Tmbyw-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-3ef3116d1dcso3290371cf.1
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 14:29:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682026148; x=1684618148;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HDRlM2AxMnsdyfyV+QoAFp3KBlLJ57QTAbE5avGat94=;
        b=Iir487TrtPFJrFVh9+vGSMQBlEO70ysgXgPse3ilSVrEbfisZ9Cr+XExx/cHMfj+Xc
         JYOQh2xecF3tC/jUjffkQb6ZV46Mao6xFoNi3lqs0eN84QZ2Xejyxc3JvNudNrWFAOH7
         KrztuJZBI2A1U1eVNNDW2F+Prb6OLKhchZR4v67HwPAIU0yv4NcaKHZwb7j5YSH7fg30
         WGHhFbp9zBM4BkSuLN3rRb6vxTrgByc1kgvId776DZzf+w6CRXMJyzqGcSwHLI5eH7Zl
         v2tQfNFyxHwQUQEyZZrIWh5fQpzwmBjI8mkKXjl22MLs6IQm+RTb6kvLCPWfwY9V+5NA
         3rpw==
X-Gm-Message-State: AAQBX9dduKN0Yc+UMzXjDOnbQIZc3V+yEgI9g9fIWs9pfzsxXZ1Vi1ZJ
        GVxtxqMyMBvoeX/Q/5DBe2UM2BrMs4iA4G/SySvf1UvPZl6YcE2njnVdQq/vSnZh8sh35spweQ/
        bgxMluyAUZr0P
X-Received: by 2002:a05:622a:1a12:b0:3eb:143a:746a with SMTP id f18-20020a05622a1a1200b003eb143a746amr4771038qtb.4.1682026148509;
        Thu, 20 Apr 2023 14:29:08 -0700 (PDT)
X-Google-Smtp-Source: AKy350YqBBUfyt4SNW81xn4TnP0axcTvbXVOiAGkFrl8Mnsl2wIQ3j6/sBnmDpyd7F+AZ8L2hzahKQ==
X-Received: by 2002:a05:622a:1a12:b0:3eb:143a:746a with SMTP id f18-20020a05622a1a1200b003eb143a746amr4771009qtb.4.1682026148203;
        Thu, 20 Apr 2023 14:29:08 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-40-70-52-229-124.dsl.bell.ca. [70.52.229.124])
        by smtp.gmail.com with ESMTPSA id o8-20020a05620a228800b00746aa080eefsm745930qkh.6.2023.04.20.14.29.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 14:29:07 -0700 (PDT)
Date:   Thu, 20 Apr 2023 17:29:06 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     Axel Rasmussen <axelrasmussen@google.com>, pbonzini@redhat.com,
        maz@kernel.org, oliver.upton@linux.dev, seanjc@google.com,
        jthoughton@google.com, bgardon@google.com, dmatlack@google.com,
        ricarkol@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Nadav Amit <nadav.amit@gmail.com>
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
Message-ID: <ZEGuogfbtxPNUq7t@x1n>
References: <20230412213510.1220557-1-amoorthy@google.com>
 <ZEBHTw3+DcAnPc37@x1n>
 <CAJHvVchBqQ8iVHgF9cVZDusMKQM2AjtNx2z=i9ZHP2BosN4tBg@mail.gmail.com>
 <ZEBXi5tZZNxA+jRs@x1n>
 <CAF7b7mo68VLNp=QynfT7QKgdq=d1YYGv1SEVEDxF9UwHzF6YDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAF7b7mo68VLNp=QynfT7QKgdq=d1YYGv1SEVEDxF9UwHzF6YDw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Anish,

[Copied Nadav Amit for the last few paragraphs on userfaultfd, because
 Nadav worked on a few userfaultfd performance problems; so maybe he'll
 also have some ideas around]

On Wed, Apr 19, 2023 at 02:53:46PM -0700, Anish Moorthy wrote:
> On Wed, Apr 19, 2023 at 2:05 PM Peter Xu <peterx@redhat.com> wrote:
> >
> > On Wed, Apr 19, 2023 at 01:15:44PM -0700, Axel Rasmussen wrote:
> > > We considered sharding into several UFFDs. I do think it helps, but
> > > also I think there are two main problems with it...
> >
> > But I agree I can never justify that it'll always work.  If you or Anish
> > could provide some data points to further support this issue that would be
> > very interesting and helpful, IMHO, not required though.
> 
> Axel covered the reasons for not pursuing the sharding approach nicely
> (thanks!). It's not something we ever prototyped, so I don't have any
> further numbers there.
> 
> On Wed, Apr 19, 2023 at 2:05 PM Peter Xu <peterx@redhat.com> wrote:
> >
> > On Wed, Apr 19, 2023 at 01:15:44PM -0700, Axel Rasmussen wrote:
> >
> > > I think we could share numbers from some of our internal benchmarks,
> > > or at the very least give relative numbers (e.g. +50% increase), but
> > > since a lot of the software stack is proprietary (e.g. we don't use
> > > QEMU), it may not be that useful or reproducible for folks.
> >
> > Those numbers can still be helpful.  I was not asking for reproduceability,
> > but some test to better justify this feature.
> 
> I do have some internal benchmarking numbers on this front, although
> it's been a while since I've collected them so the details might be a
> little sparse.

Thanks for sharing these data points.  I don't understand most of them yet,
but I think it's better than the unit test numbers provided.

> 
> I've confirmed performance gains with "scalable userfaultfd" using two
> workloads besides the self-test:
> 
> The first, cycler, spins up a VM and launches a binary which (a) maps
> a large amount of memory and then (b) loops over it issuing writes as
> fast as possible. It's not a very realistic guest but it at least
> involves an actual migrating VM, and we often use it to
> stress/performance test migration changes. The write rate which cycler
> achieves during userfaultfd-based postcopy (without scalable uffd
> enabled) is about 25% of what it achieves under KVM Demand Paging (the
> internal KVM feature GCE currently uses for postcopy). With
> userfaultfd-based postcopy and scalable uffd enabled that rate jumps
> nearly 3x, so about 75% of what KVM Demand Paging achieves. The
> attached "Cycler.png" illustrates this effect (though due to some
> other details, faster demand paging actually makes the migrations
> worse: the point is that scalable uffd performs more similarly to kvm
> demand paging :)

Yes I don't understand why vanilla uffd is so different, neither am I sure
what does the graph mean, though. :)

Is the first drop caused by starting migration/precopy?

Is the 2nd (huge) drop (mostly to zero) caused by frequently accessing new
pages during postcopy?

Is the workload busy writes single thread, or NCPU threads?

Is what you mentioned on the 25%-75% comparison can be shown on the graph?
Or maybe that's part of the period where all three are very close to 0?

> 
> The second is the redis memtier benchmark [1], a more realistic
> workflow where we migrate a VM running the redis server. With scalable
> userfaultfd, the client VM observes significantly higher transaction
> rates during uffd-based postcopy (see "Memtier.png"). I can pull the
> exact numbers if needed, but just from eyeballing the graph you can
> see that the improvement is something like 5-10x (at least) for
> several seconds. There's still a noticeable gap with KVM demand paging
> based-postcopy, but the improvement is definitely significant.
> 
> [1] https://github.com/RedisLabs/memtier_benchmark

Does the "5-10x" difference rely in the "15s valley" you pointed out in the
graph?

Is it reproduceable that the blue line always has a totally different
"valley" comparing to yellow/red?

Personally I still really want to know what happens if we just split the
vma and see how it goes with a standard workloads, but maybe I'm asking too
much so don't yet worry.  The solution here proposed still makes sense to
me and I agree if this can be done well it can resolve the bottleneck over
1-userfaultfd.

But after I read some of the patches I'm not sure whether it's possible it
can be implemented in a complete way.  You mentioned here and there on that
things can be missing probably due to random places accessing guest pages
all over kvm.  Relying sololy on -EFAULT so far doesn't look very reliable
to me, but it could be because I didn't yet really understand how it works.

Is above a concern to the current solution?

Have any of you tried to investigate the other approach to scale
userfaultfd?

It seems userfaultfd does one thing great which is to have the trapping at
an unified place (when the page fault happens), hence it doesn't need to
worry on random codes splat over KVM module read/write a guest page.  The
question is whether it'll be easy to do so.

Split vma definitely is still a way to scale userfaultfd, but probably not
in a good enough way because it's scaling in memory axis, not cores.  If
tens of cores accessing a small region that falls into the same VMA, then
it stops working.

However maybe it can be scaled in other form?  So far my understanding is
"read" upon uffd for messages is still not a problem - the read can be done
in chunk, and each message will be converted into a request to be send
later.

If the real problem relies in a bunch of threads queuing, is it possible
that we can provide just more queues for the events?  The readers will just
need to go over all the queues.

Way to decide "which thread uses which queue" can be another problem, what
comes ups quickly to me is a "hash(tid) % n_queues" but maybe it can be
better.  Each vcpu thread will have different tids, then they can hopefully
scale on the queues.

There's at least one issue that I know with such an idea, that after we
have >1 uffd queues it means the message order will be uncertain.  It may
matter for some uffd users (e.g. cooperative userfaultfd, see
UFFD_FEATURE_FORK|REMOVE|etc.)  because I believe order of messages matter
for them (mostly CRIU).  But I think that's not a blocker either because we
can forbid those features with multi queues.

That's a wild idea that I'm just thinking about, which I have totally no
idea whether it'll work or not.  It's more or less of a generic question on
"whether there's chance to scale on uffd side just in case it might be a
cleaner approach", when above concern is a real concern.

Thanks,

-- 
Peter Xu

