Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83BF556BB60
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 16:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238340AbiGHN6U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 09:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238288AbiGHN6T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 09:58:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7531C2C640
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 06:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657288696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DkINNwNj/wvMhz9e5/8WZEdU3d3i4BXmoSion7M+nwg=;
        b=IJ74h2yYZQIq80LWlxEiPjOdVIHUuFaZsMKFDSq886EjbuLdCIj0t/u4AP3IwUXii4AwW9
        oQmx6TsKBSP4Cj5Zt34yV5xUhPOM5TVT34qaqtIKAnSgJZTzR2chQ41yh8OR5jZWqMLFkz
        xPAOMqV9uHTT1QJ+TTQsXSzryqF9g6w=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-4f3m1D48O16v5t6Q2FmGLQ-1; Fri, 08 Jul 2022 09:58:15 -0400
X-MC-Unique: 4f3m1D48O16v5t6Q2FmGLQ-1
Received: by mail-qt1-f199.google.com with SMTP id v4-20020ac873c4000000b0031ea1a9e8cfso3201435qtp.23
        for <kvm@vger.kernel.org>; Fri, 08 Jul 2022 06:58:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DkINNwNj/wvMhz9e5/8WZEdU3d3i4BXmoSion7M+nwg=;
        b=sgQQ427f1ts5BFOoJ+nwG7sidYxpUYAs+HR3yh5lwNjFCyJ/ADV1NzwrDLwOx/7XRl
         j6riXTZCvatiUAmWdvyRkVb9fu1rbh6P9CZDRiOFDQV7z/odG95LoAG/e/AGcNxTTUHw
         vQ/QmY+VfPYgNgdD0yVRHG6Y938njDVeTjFwXgjqPnPITX7OOyJOuHPxbkKNGLtoKB2M
         8vBcJaObMGnydVg+/LAfnS088pgjkXgmKMqg1ZZNpFnvB9IkH8OuEvXNPvpQt/9tL3W5
         t5osq3X0BJs2Jmil1krNjRVVSXE1PlFH99B/IUJX7EgXbjmnM1cLKQ25wAtbN+zsp+f0
         v0ww==
X-Gm-Message-State: AJIora8i8AS+N+ubN1x+YiYJkZpJ3iTSFRIvwlXXiQ4M2a3lOxCKhr4t
        GH9fAO+n46X83MoJTn6nXH3U1A8zajbU3Ohr7gL0vlMNfWUC9ghikWKl9pRBAOjfBi43lHXnnVh
        eaKXfry64GmhE
X-Received: by 2002:a0c:dd11:0:b0:473:34ad:8e06 with SMTP id u17-20020a0cdd11000000b0047334ad8e06mr2839861qvk.4.1657288694404;
        Fri, 08 Jul 2022 06:58:14 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vxJv/NEyo15Tw1UQuhMw6BYWdDy7KEWS/QMrPgjBkRPoWXy9uvRkJMzNBM4QKpJ3PeU0utMg==
X-Received: by 2002:a0c:dd11:0:b0:473:34ad:8e06 with SMTP id u17-20020a0cdd11000000b0047334ad8e06mr2839830qvk.4.1657288694053;
        Fri, 08 Jul 2022 06:58:14 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-37-74-12-30-48.dsl.bell.ca. [74.12.30.48])
        by smtp.gmail.com with ESMTPSA id m14-20020a05620a24ce00b006af59e9ddeasm28327532qkn.18.2022.07.08.06.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 06:58:12 -0700 (PDT)
Date:   Fri, 8 Jul 2022 09:58:09 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Steven Price <steven.price@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Peter Collingbourne <pcc@google.com>,
        kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        kvm@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        linux-arm-kernel@lists.infradead.org,
        Michael Roth <michael.roth@amd.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Will Deacon <will@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Gavin Shan <gshan@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH] KVM: arm64: permit MAP_SHARED mappings with MTE enabled
Message-ID: <Ysg38XZSzPk8tYwK@xz-m1.local>
References: <20220623234944.141869-1-pcc@google.com>
 <YrXu0Uzi73pUDwye@arm.com>
 <14f2a69e-4022-e463-1662-30032655e3d1@arm.com>
 <875ykmcd8q.fsf@redhat.com>
 <YrwRPh1S6qjzkJMm@arm.com>
 <7a32fde7-611d-4649-2d74-f5e434497649@arm.com>
 <871qv12hqj.fsf@redhat.com>
 <b91ae197-d191-2204-aab5-21a0aabded69@arm.com>
 <87bktz7o49.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87bktz7o49.fsf@redhat.com>
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 08, 2022 at 03:03:34PM +0200, Cornelia Huck wrote:
> On Mon, Jul 04 2022, Steven Price <steven.price@arm.com> wrote:
> 
> > On 04/07/2022 13:19, Cornelia Huck wrote:
> >> On Mon, Jul 04 2022, Steven Price <steven.price@arm.com> wrote:
> >> 
> >>> On 29/06/2022 09:45, Catalin Marinas wrote:
> >>>> On Mon, Jun 27, 2022 at 05:55:33PM +0200, Cornelia Huck wrote:
> >>>
> >>>>> [Postcopy needs a different interface, I guess, so that the migration
> >>>>> target can atomically place a received page and its metadata. I see
> >>>>> https://lore.kernel.org/all/CAJc+Z1FZxSYB_zJit4+0uTR-88VqQL+-01XNMSEfua-dXDy6Wg@mail.gmail.com/;
> >>>>> has there been any follow-up?]
> >>>>
> >>>> I don't follow the qemu list, so I wasn't even aware of that thread. But
> >>>> postcopy, the VMM needs to ensure that both the data and tags are up to
> >>>> date before mapping such page into the guest address space.
> >>>>
> >>>
> >>> I'm not sure I see how atomically updating data+tags is different from
> >>> the existing issues around atomically updating the data. The VMM needs
> >>> to ensure that the guest doesn't see the page before all the data+all
> >>> the tags are written. It does mean lazy setting of the tags isn't
> >>> possible in the VMM, but I'm not sure that's a worthwhile thing anyway.
> >>> Perhaps I'm missing something?
> >> 
> >> For postcopy, we basically want to fault in any not-yet-migrated page
> >> via uffd once the guest accesses it. We only get the page data that way,
> >> though, not the tag. I'm wondering whether we'd need a 'page+metadata'
> >> uffd mode; not sure if that makes sense. Otherwise, we'd need to stop
> >> the guest while grabbing the tags for the page as well, and stopping is
> >> the thing we want to avoid here.
> >
> > Ah, I think I see now. UFFDIO_COPY atomically populates the (data) page
> > and ensures that no thread will see the partially populated page. But
> > there's currently no way of doing that with tags as well.
> 
> Nod.
> 
> >
> > I'd not looked at the implementation of userfaultfd before and I'd
> > assumed it avoided the need for an 'atomic' operation like this. But
> > apparently not! AFAICT either a new ioctl would be needed (which can
> > take a tag buffer) or a new flag to UFFDIO_COPY which would tighten the
> > alignment requirements of `src` and would copy the tags along with the data.
> 
> I was thinking about a new flag that implies "copy metadata"; not sure
> how we would get the same atomicity with a separate ioctl. I've only
> just started looking at userfaultfd, though, and I might be on a wrong
> track... One thing I'd like to avoid is having something that is too
> ARM-specific, I think there are other architecture features that might
> have similar issues.

Agreed, to propose such an interface we'd better make sure it'll be easily
applicable to other similar memory protection mechanisms elsewhere.

> 
> Maybe someone more familiar with uffd and/or postcopy can chime in?

Hanving UFFDIO_COPY provide a new flag sounds reasonable to me.  I'm
curious what's the maximum possible size of the tags and whether they can
be embeded already into struct uffdio_copy somehow.

Thanks,

-- 
Peter Xu

