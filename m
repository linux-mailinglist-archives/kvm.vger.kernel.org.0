Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D86957BFE93
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 15:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbjJJN4w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 09:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232495AbjJJN4t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 09:56:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220A9A7
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 06:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696946168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8/nFjvwS56V7OUAo4D2QoDI4RZYmaHavyYCmq+zkU0g=;
        b=aHqNqTIGw/Tf1iCnN9AKRrUo99qqkcQffejf+xa/Z4fSWqiGKzOlhguOHJPoHUFVrTFjbt
        PJxoBePKVa6Nt3tlqQ+sxEk+tqzO2j4vNyqEp49PGk1TioJmrtKNe1QaCKpB6ZgG7SGsyO
        O+Eb3bUcVDUWZzru7q+4qFv5W740fHc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-B_z9Hfl_OzGP8mWywJHe0Q-1; Tue, 10 Oct 2023 09:56:06 -0400
X-MC-Unique: B_z9Hfl_OzGP8mWywJHe0Q-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4055ce1e8c4so30362945e9.0
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 06:56:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696946165; x=1697550965;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8/nFjvwS56V7OUAo4D2QoDI4RZYmaHavyYCmq+zkU0g=;
        b=mwag9aSjgjJk5NuJcZ1OXSUVLvYnxDUitlFkOFDzROsYmaxzq8xO6fQD/Vm9N7EqwC
         ZwJrf5zl1YPwae6CblKGspuTuc3ec8QprEcr6YVDTVMDdD4H7rJGnMF5qUPExtw8xWiQ
         wQcclAm4X54UAftTLlurjoTMRYEt8tOejXUW/qWydOwJohIIFFFDpkr+oxkE61DjfakP
         xUTeSEsFVCybvZ5e8iC1eTSoID4S/xii8ux6R2qkCgBeSNuC8+cTomZ5L44M405os/oa
         qaCE+ab0NOz6U8pGsVSp7uVJZK5On2M7gJ8Azh1hoxbl0zy+g1ZsXYEAbZoEpETp1dyo
         DwSw==
X-Gm-Message-State: AOJu0YyQaRVFh8rCjZUV5aWAJ0oNjGFuoflffjzV5WWnyldf075pEdxr
        25LKBBlTdYi82fXD5oFJjb8uGrOI0Arfa/8bNE0D/gH6Bh/h52gr6gWg3Zj1j9EXRkSrR56QAVm
        RgpyZ58a4KmyP
X-Received: by 2002:a05:600c:2187:b0:401:b0f2:88d3 with SMTP id e7-20020a05600c218700b00401b0f288d3mr12644047wme.19.1696946165444;
        Tue, 10 Oct 2023 06:56:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGPR74xcoRnn7rHPwNnL+k0ait5tAnM9xrQDqU+TQYe1Lpr60Cr97Kw6Gsuf7NuKa0hpjMTCw==
X-Received: by 2002:a05:600c:2187:b0:401:b0f2:88d3 with SMTP id e7-20020a05600c218700b00401b0f288d3mr12644030wme.19.1696946165016;
        Tue, 10 Oct 2023 06:56:05 -0700 (PDT)
Received: from redhat.com ([147.235.219.90])
        by smtp.gmail.com with ESMTPSA id s17-20020a1cf211000000b00405623e0186sm16576404wmc.26.2023.10.10.06.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 06:56:04 -0700 (PDT)
Date:   Tue, 10 Oct 2023 09:56:00 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Message-ID: <20231010094756-mutt-send-email-mst@kernel.org>
References: <20230921124040.145386-11-yishaih@nvidia.com>
 <20230922055336-mutt-send-email-mst@kernel.org>
 <c3724e2f-7938-abf7-6aea-02bfb3881151@nvidia.com>
 <20230926072538-mutt-send-email-mst@kernel.org>
 <ZRpjClKM5mwY2NI0@infradead.org>
 <20231002151320.GA650762@nvidia.com>
 <ZR54shUxqgfIjg/p@infradead.org>
 <20231005111004.GK682044@nvidia.com>
 <ZSAG9cedvh+B0c0E@infradead.org>
 <20231010131031.GJ3952@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231010131031.GJ3952@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 10, 2023 at 10:10:31AM -0300, Jason Gunthorpe wrote:
> > > There is alot of code in VFIO and the VMM side to take a VF and turn
> > > it into a vPCI function. You can't just trivially duplicate VFIO in a
> > > dozen drivers without creating a giant mess.
> > 
> > I do not advocate for duplicating it.  But the code that calls this
> > functionality belongs into the driver that deals with the compound
> > device that we're doing this work for.
> 
> On one hand, I don't really care - we can put the code where people
> like.
> 
> However - the Intel GPU VFIO driver is such a bad experiance I don't
> want to encourage people to make VFIO drivers, or code that is only
> used by VFIO drivers, that are not under drivers/vfio review.

So if Alex feels it makes sense to add some virtio functionality
to vfio and is happy to maintain or let you maintain the UAPI
then why would I say no? But we never expected devices to have
two drivers like this does, so just exposing device pointer
and saying "use regular virtio APIs for the rest" does not
cut it, the new APIs have to make sense
so virtio drivers can develop normally without fear of stepping
on the toes of this admin driver.

-- 
MST

