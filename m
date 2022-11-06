Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA7E61E636
	for <lists+kvm@lfdr.de>; Sun,  6 Nov 2022 22:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbiKFVIN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Nov 2022 16:08:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbiKFVHq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Nov 2022 16:07:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960BA1055F
        for <kvm@vger.kernel.org>; Sun,  6 Nov 2022 13:06:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667768807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+DA4NmQNiOjUonEI2cHNDOXzF9gIkeMHW76hG0VbL0A=;
        b=ftut7mGIQxsgWmzJEgk4X/2hbZdTYbg2Fei9MNJCmNjEgea9tTEsoFzICCwsNNI+bfyGy4
        QnUKYAjt9A/ZzGdKb4DYG+H1PdtfuBrDYTQww9y8/HbBFAYSPZoCGcAOt3cCurTZrevfuH
        JW0NctglnI2mof3dQMCf3q8RPcwlbgw=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-541-NpBApaTuNAqmpBYMY3s2ZQ-1; Sun, 06 Nov 2022 16:06:46 -0500
X-MC-Unique: NpBApaTuNAqmpBYMY3s2ZQ-1
Received: by mail-qt1-f198.google.com with SMTP id i13-20020ac8764d000000b003a4ec8693dcso7039802qtr.14
        for <kvm@vger.kernel.org>; Sun, 06 Nov 2022 13:06:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+DA4NmQNiOjUonEI2cHNDOXzF9gIkeMHW76hG0VbL0A=;
        b=EcLu+npmSl7cSrAN6MAUhiEx2T8E8G1zxOaaBQdD1zNIFJMo9L1jNOYNP5trZfr7CN
         vG/g1YRj7aBP3cwROUBmJUfC91je5BxUfJHXadKVSjLmmQrLesxMKAhi8s5cltj/blV6
         5D6lPqNXfyoLPqsgsQxc4D9bkhTS2TtK/Fd7ikTHnM05K/IkRjjrBb7YiQZbSXH7CscT
         2Dq595NW3pKp7QCF3jvuHM9hoMFHD1Xv9Y+EQ4t88jOuXmZBW2yK9a0L+pqmJdL7K0ak
         y/K/YaS19nt7Jx7EUvXdTuSySOTEy2x8WWDAzy1vO2p1dr/ieaZc5NXeIpXoxL7xQDJA
         0s7Q==
X-Gm-Message-State: ACrzQf1Jtzcrzzh19HvW8hLX658jxnK1AHpck03j+l+e8RG9zxUmopJ/
        MICp0tvkjPMniy7sw8W5o9ZXymEcyRdxz20F2LRKjKfZVxcHVx0+32Vtk/4GdsXlVG+TCRixXYA
        mKzOb1XesqDVV
X-Received: by 2002:a05:6214:27cc:b0:4c1:2cc7:2d7c with SMTP id ge12-20020a05621427cc00b004c12cc72d7cmr14767315qvb.95.1667768805855;
        Sun, 06 Nov 2022 13:06:45 -0800 (PST)
X-Google-Smtp-Source: AMsMyM7q0ohWcv/UJR31wQp4DpFc+MiUL5KSilBMUc9xT24+vyRdsz6Dr0AWP9j07T9XXNm64FuQ8A==
X-Received: by 2002:a05:6214:27cc:b0:4c1:2cc7:2d7c with SMTP id ge12-20020a05621427cc00b004c12cc72d7cmr14767290qvb.95.1667768805588;
        Sun, 06 Nov 2022 13:06:45 -0800 (PST)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id r1-20020ac85e81000000b0039cc7ebf46bsm4548114qtx.93.2022.11.06.13.06.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Nov 2022 13:06:44 -0800 (PST)
Date:   Sun, 6 Nov 2022 16:06:43 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Gavin Shan <gshan@redhat.com>, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        shuah@kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev,
        ajones@ventanamicro.com, bgardon@google.com, dmatlack@google.com,
        will@kernel.org, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        pbonzini@redhat.com, seanjc@google.com, oliver.upton@linux.dev,
        zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v8 3/7] KVM: Support dirty ring in conjunction with bitmap
Message-ID: <Y2gh4x4MD8BJvogH@x1n>
References: <20221104234049.25103-1-gshan@redhat.com>
 <20221104234049.25103-4-gshan@redhat.com>
 <87o7tkf5re.wl-maz@kernel.org>
 <Y2ffRYoqlQOxgVtk@x1n>
 <87iljrg7vd.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87iljrg7vd.wl-maz@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 06, 2022 at 08:12:22PM +0000, Marc Zyngier wrote:
> Hi Peter,
> 
> On Sun, 06 Nov 2022 16:22:29 +0000,
> Peter Xu <peterx@redhat.com> wrote:
> > 
> > Hi, Marc,
> > 
> > On Sun, Nov 06, 2022 at 03:43:17PM +0000, Marc Zyngier wrote:
> > > > +Note that the bitmap here is only a backup of the ring structure, and
> > > > +normally should only contain a very small amount of dirty pages, which
> > > 
> > > I don't think we can claim this. It is whatever amount of memory is
> > > dirtied outside of a vcpu context, and we shouldn't make any claim
> > > regarding the number of dirty pages.
> > 
> > The thing is the current with-bitmap design assumes that the two logs are
> > collected in different windows of migration, while the dirty log is only
> > collected after the VM is stopped.  So collecting dirty bitmap and sending
> > the dirty pages within the bitmap will be part of the VM downtime.
> > 
> > It will stop to make sense if the dirty bitmap can contain a large portion
> > of the guest memory, because then it'll be simpler to just stop the VM,
> > transfer pages, and restart on dest node without any tracking mechanism.
> 
> Oh, I absolutely agree that the whole vcpu dirty ring makes zero sense
> in general. It only makes sense if the source of the dirty pages is
> limited to the vcpus, which is literally a corner case. Look at any
> real machine, and you'll quickly realise that this isn't the case, and
> that DMA *is* a huge source of dirty pages.
> 
> Here, we're just lucky enough not to have much DMA tracking yet. Once
> that happens (and I have it from people doing the actual work that it
> *is* happening), you'll realise that the dirty ring story is of very
> limited use. So I'd rather drop anything quantitative here, as this is
> likely to be wrong.

Is it a must that arm64 needs to track device DMAs using the same dirty
tracking interface rather than VFIO or any other interface?  It's
definitely not the case for x86, but if it's true for arm64, then could the
DMA be spread across all the guest pages?  If it's also true, I really
don't know how this will work..

We're only syncing the dirty bitmap once right now with the protocol.  If
that can cover most of the guest mem, it's same as non-live.  If we sync it
periodically, then it's the same as enabling dirty-log alone and the rings
are useless.

> 
> >
> > [1]
> > 
> > > 
> > > > +needs to be transferred during VM downtime. Collecting the dirty bitmap
> > > > +should be the very last thing that the VMM does before transmitting state
> > > > +to the target VM. VMM needs to ensure that the dirty state is final and
> > > > +avoid missing dirty pages from another ioctl ordered after the bitmap
> > > > +collection.
> > > > +
> > > > +To collect dirty bits in the backup bitmap, the userspace can use the
> > > > +same KVM_GET_DIRTY_LOG ioctl. KVM_CLEAR_DIRTY_LOG shouldn't be needed
> > > > +and its behavior is undefined since collecting the dirty bitmap always
> > > > +happens in the last phase of VM's migration.
> > > 
> > > It isn't clear to me why KVM_CLEAR_DIRTY_LOG should be called out. If
> > > you have multiple devices that dirty the memory, such as multiple
> > > ITSs, why shouldn't userspace be allowed to snapshot the dirty state
> > > multiple time? This doesn't seem like a reasonable restriction, and I
> > > really dislike the idea of undefined behaviour here.
> > 
> > I suggested the paragraph because it's very natural to ask whether we'd
> > need to CLEAR_LOG for this special GET_LOG phase, so I thought this could
> > be helpful as a reference to answer that.
> > 
> > I wanted to make it clear that we don't need CLEAR_LOG at all in this case,
> > as fundamentally clear log is about re-protect the guest pages, but if
> > we're with the restriction of above (having the dirty bmap the last to
> > collect and once and for all) then it'll make no sense to protect the guest
> > page at all at this stage since src host shouldn't run after the GET_LOG
> > then the CLEAR_LOG will be a vain effort.
> 
> That's not for you to decide, but userspace. I can perfectly expect
> userspace saving an ITS, getting the bitmap, saving the pages and then
> *clearing the log* before processing the next ITS. Or anything else.

I think I can get your point on why you're not happy with the document, but
IMHO how we document is one thing, how it'll work is another.  I preferred
explicit documentation because it'll help the app developer to support the
interface, also more docs to reference in the future; no strong opinion,
though.

However if there's fundamental statement that was literally wrong, then
it's another thing, and we may need to rethink.

Thanks,

-- 
Peter Xu

