Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6451C7AA288
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 23:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232598AbjIUVUw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 17:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233217AbjIUVUH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 17:20:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57FC83BE1B
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 13:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695329154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HXeE4TG44R23JcxBjDhXWMi0+WtDdxhkEq9BQKJjIy0=;
        b=d4HRj1be9UJr4Si9k9wtk+lizXpaslQlr3W/ULYDfsBXQMJ9DOhzHan/tO85HY4kQYfuAe
        IcaXjI9TQlWgylZq/GEIDR+aVg3DetozR9wQ3oWOJG5M6UVtUx5pAasst5b7udrRQTYI0L
        WSM7sNye13N77amb6OviUyxftLDqrcY=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-16-PqtRlkbYNySixYPyNYBrhw-1; Thu, 21 Sep 2023 16:45:52 -0400
X-MC-Unique: PqtRlkbYNySixYPyNYBrhw-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2b710c5677eso19517941fa.0
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 13:45:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695329151; x=1695933951;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HXeE4TG44R23JcxBjDhXWMi0+WtDdxhkEq9BQKJjIy0=;
        b=Rc8fhhaXUI9BIlqfbn0u/MKascRzabeL1O26uUYRegrnugwYomwGAl5CHSfqHfcXxw
         cvRobBRi+ngozIGvB5gcwjSzEtXi18LykwCOPibxjy9ZWlzFqFdAJuBByDjZjNgYGx7n
         KQUy6iorc/c5qEMpKvzVGrEGbmbdBDWILfJXjhGyglFYSmFr+t13FqB5mDyYH3rCzskU
         7dKVJNIDOthbM90vvSxbk/W8csUccLqxttJHDCakhnFFZQwTYBImr6cK08s75j9h6bKk
         IhM0gNL68qkz43DzfU/5i1Ezbj7lDvOxUQmgiALW/gGRRNcvN2s+5vdQRJCT8wPxLv0J
         QO4g==
X-Gm-Message-State: AOJu0YxFFo8mdz1jMFMNLVXI4GdALxShMC4MSbGnPNJC5s8fB5a/Dr69
        jFCdKgOyoZIvmqO3a+whSVX6dC1u+m/EYSDzOkl+L5ZT2IRJTSY+cAo/pvNaQwh742aQdsFCr44
        A4478tamMEyCQ
X-Received: by 2002:a19:a410:0:b0:503:3890:ca3a with SMTP id q16-20020a19a410000000b005033890ca3amr5181235lfc.66.1695329150807;
        Thu, 21 Sep 2023 13:45:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGUVyMjlZeXfqdaSOLrm1jlrnnaNg6HRSFnF4mEMeS4M7zyGlAp1B55TKazyR2yo53Y4zjmqQ==
X-Received: by 2002:a19:a410:0:b0:503:3890:ca3a with SMTP id q16-20020a19a410000000b005033890ca3amr5181222lfc.66.1695329150452;
        Thu, 21 Sep 2023 13:45:50 -0700 (PDT)
Received: from redhat.com ([2.52.150.187])
        by smtp.gmail.com with ESMTPSA id ba26-20020a0564021ada00b005333c729654sm1304241edb.24.2023.09.21.13.45.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 13:45:49 -0700 (PDT)
Date:   Thu, 21 Sep 2023 16:45:45 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230921163421-mutt-send-email-mst@kernel.org>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-12-yishaih@nvidia.com>
 <20230921090844-mutt-send-email-mst@kernel.org>
 <20230921141125.GM13733@nvidia.com>
 <20230921101509-mutt-send-email-mst@kernel.org>
 <20230921164139.GP13733@nvidia.com>
 <20230921124331-mutt-send-email-mst@kernel.org>
 <20230921183926.GV13733@nvidia.com>
 <20230921150448-mutt-send-email-mst@kernel.org>
 <20230921194946.GX13733@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921194946.GX13733@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 04:49:46PM -0300, Jason Gunthorpe wrote:
> On Thu, Sep 21, 2023 at 03:13:10PM -0400, Michael S. Tsirkin wrote:
> > On Thu, Sep 21, 2023 at 03:39:26PM -0300, Jason Gunthorpe wrote:
> > > On Thu, Sep 21, 2023 at 12:53:04PM -0400, Michael S. Tsirkin wrote:
> > > > > vdpa is not vfio, I don't know how you can suggest vdpa is a
> > > > > replacement for a vfio driver. They are completely different
> > > > > things.
> > > > > Each side has its own strengths, and vfio especially is accelerating
> > > > > in its capability in way that vpda is not. eg if an iommufd conversion
> > > > > had been done by now for vdpa I might be more sympathetic.
> > > > 
> > > > Yea, I agree iommufd is a big problem with vdpa right now. Cindy was
> > > > sick and I didn't know and kept assuming she's working on this. I don't
> > > > think it's a huge amount of work though.  I'll take a look.
> > > > Is there anything else though? Do tell.
> > > 
> > > Confidential compute will never work with VDPA's approach.
> > 
> > I don't see how what this patchset is doing is different
> > wrt to Confidential compute - you trap IO accesses and emulate.
> > Care to elaborate?
> 
> This patch series isn't about confidential compute, you asked about
> the future. VFIO will support confidential compute in the future, VDPA
> will not.

Nonsense it already works.

But I did not ask about the future since I do not believe it
can be confidently predicted. I asked what is missing in VDPA
now for you to add this feature there and not in VFIO.


> > > > There are a bunch of things that I think are important for virtio
> > > > that are completely out of scope for vfio, such as migrating
> > > > cross-vendor. 
> > > 
> > > VFIO supports migration, if you want to have cross-vendor migration
> > > then make a standard that describes the VFIO migration data format for
> > > virtio devices.
> > 
> > This has nothing to do with data formats - you need two devices to
> > behave identically. Which is what VDPA is about really.
> 
> We've been looking at VFIO live migration extensively. Device
> mediation, like VDPA does, is one legitimate approach for live
> migration. It suites a certain type of heterogeneous environment well.
> 
> But, it is equally legitimate to make the devices behave the same and
> have them process a common migration data.
> 
> This can happen in public with standards, or it can happen in private
> within a cloud operator's "private-standard" environment.
> 
> To date, in most of my discussions, I have not seen a strong appetite
> for such public standards. In part due to the complexity.
> 
> Regardles, it is not the kernel communities job to insist on one
> approach or the other.
>
> > > You are asking us to invest in the complexity of VDPA through out
> > > (keep it working, keep it secure, invest time in deploying and
> > > debugging in the field)
> > > 
> > > When it doesn't provide *ANY* value to the solution.
> > 
> > There's no "the solution"
> 
> Nonsense.

what there's only one solution that you use the definite article?

> > this sounds like a vendor only caring about solutions that involve
> > that vendor's hardware exclusively, a little.
> 
> Not really.
> 
> Understand the DPU provider is not the vendor here. The DPU provider
> gives a cloud operator a SDK to build these things. The operator is
> the vendor from your perspective.
> 
> In many cases live migration never leaves the operator's confines in
> the first place.
> 
> Even when it does, there is no real use case to live migrate a
> virtio-net function from, say, AWS to GCP.
> 
> You are pushing for a lot of complexity and software that solves a
> problem people in this space don't actually have.
> 
> As I said, VDPA is fine for the scenarios it addresses. It is an
> alternative, not a replacement, for VFIO.
> 
> Jason

yea, VDPA does trap and emulate for config accesses.  which is exactly
what this patch does?  so why does it belong in vfio muddying up its
passthrough model is beyond me, except that apparently there's some
specific deployment that happens to use vfio so now whatever
that deployment needs has to go into vfio whether it belongs there or not.


-- 
MST

