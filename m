Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5EA67B1227
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 07:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbjI1Fc5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 01:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjI1Fc4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 01:32:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF4E122
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 22:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695879127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JJKTBrFfNa844uYvKAsmJlERJoic2KHS63xODOblJos=;
        b=cgy9bSfmZ8ORo1fN/dhDU02YiKeG8XhORA76TnDfEvB+0Ygc0yTQa6ds2atfir0gvSeRid
        IRw6MLg7o3DENu9RCkPRoEpfWcuWr/rTX4N6PGzxE9RMolIpUQZ9WTSuzLOs3TV93VxqFr
        V/0umpQzh9IAb6pqCv89qZDjpTcGLxQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-691-_-sNUxuONBuMNInrwWRqrQ-1; Thu, 28 Sep 2023 01:32:03 -0400
X-MC-Unique: _-sNUxuONBuMNInrwWRqrQ-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f42bcef2acso107932515e9.2
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 22:32:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695879122; x=1696483922;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JJKTBrFfNa844uYvKAsmJlERJoic2KHS63xODOblJos=;
        b=nmQLSKr8JN/LGpCXmaLRosqS/lQHGt9P0KW70s7XdjTEXWzBn/8MCzm91bAWrmnnfo
         zu1B/R1yCG6rlTGI+LmhSSi276dpLzlW10wMiIKi1+EJHZs5eD/K8RSCS5ibsp6qoZsp
         oqdn1QcsxjU01wjbenxBlFE9mS61qsSL9HieYYDI3QRu42gMhYkX0XclKkMP9yWCEn6m
         3VSHhVBklX9nI3IDococ69LYC/fVY6qRrnRQjZm9lnFrzWvJ5+Zr4ZFp3zOWHzse7ACs
         4m9R5QiwBayjDjwUKuHL/LSNvsjEFw/lcTDohdSdhwpV0nE7sJyHKgbMdSiSMNz6zfKX
         AfIQ==
X-Gm-Message-State: AOJu0Yx/bMTUJeuuIojfHsg7CPQe8bzqffSElXW/r58HkqVbqwTngnA0
        I7ryNI7rJtC9Ctk62C9aHZ4f4wx9OKXwxdyxU6TL8l1tL5Li0UwOEMWGTVGTG34zvHwD2XHFEGe
        5kOKFd70mVSiT
X-Received: by 2002:a7b:cb8c:0:b0:405:36d7:4579 with SMTP id m12-20020a7bcb8c000000b0040536d74579mr210557wmi.28.1695879122709;
        Wed, 27 Sep 2023 22:32:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHnQQOsX2nd46FlaNt8Gwvvx+JHgJ+INrZJAdTjHC8F4FEZId76DIGMa4aSekPcBkjhv4hyCA==
X-Received: by 2002:a7b:cb8c:0:b0:405:36d7:4579 with SMTP id m12-20020a7bcb8c000000b0040536d74579mr210537wmi.28.1695879122411;
        Wed, 27 Sep 2023 22:32:02 -0700 (PDT)
Received: from redhat.com ([2.52.19.249])
        by smtp.gmail.com with ESMTPSA id 19-20020a05600c029300b004060f0a0fdbsm6639359wmk.41.2023.09.27.22.32.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Sep 2023 22:32:01 -0700 (PDT)
Date:   Thu, 28 Sep 2023 01:31:58 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230928012650-mutt-send-email-mst@kernel.org>
References: <CACGkMEvMP05yTNGE5dBA2-M0qX-GXFcdGho7_T5NR6kAEq9FNg@mail.gmail.com>
 <20230922121132.GK13733@nvidia.com>
 <CACGkMEsxgYERbyOPU33jTQuPDLUur5jv033CQgK9oJLW+ueG8w@mail.gmail.com>
 <20230925122607.GW13733@nvidia.com>
 <20230925143708-mutt-send-email-mst@kernel.org>
 <20230926004059.GM13733@nvidia.com>
 <20230926014005-mutt-send-email-mst@kernel.org>
 <20230926135057.GO13733@nvidia.com>
 <20230927173221-mutt-send-email-mst@kernel.org>
 <20230927232005.GE339126@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230927232005.GE339126@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 27, 2023 at 08:20:05PM -0300, Jason Gunthorpe wrote:
> On Wed, Sep 27, 2023 at 05:38:55PM -0400, Michael S. Tsirkin wrote:
> > On Tue, Sep 26, 2023 at 10:50:57AM -0300, Jason Gunthorpe wrote:
> > > On Tue, Sep 26, 2023 at 01:42:52AM -0400, Michael S. Tsirkin wrote:
> > > > On Mon, Sep 25, 2023 at 09:40:59PM -0300, Jason Gunthorpe wrote:
> > > > > On Mon, Sep 25, 2023 at 03:44:11PM -0400, Michael S. Tsirkin wrote:
> > > > > > > VDPA is very different from this. You might call them both mediation,
> > > > > > > sure, but then you need another word to describe the additional
> > > > > > > changes VPDA is doing.
> > > > > > 
> > > > > > Sorry about hijacking the thread a little bit, but could you
> > > > > > call out some of the changes that are the most problematic
> > > > > > for you?
> > > > > 
> > > > > I don't really know these details.
> > > > 
> > > > Maybe, you then should desist from saying things like "It entirely fails
> > > > to achieve the most important thing it needs to do!" You are not making
> > > > any new friends with saying this about a piece of software without
> > > > knowing the details.
> > > 
> > > I can't tell you what cloud operators are doing, but I can say with
> > > confidence that it is not the same as VDPA. As I said, if you want to
> > > know more details you need to ask a cloud operator.
> >
> > So it's not the changes that are problematic, it's that you have
> > customers who are not using vdpa. The "most important thing" that vdpa
> > fails at is simply converting your customers from vfio to vdpa.
> 
> I said the most important thing was that VFIO presents exactly the
> same virtio device to the VM as the baremetal. Do you dispute that,
> technically, VDPA does not actually achieve that?

I dispute that it is the most important. The important thing is to have
guests work.

> Then why is it so surprising that people don't want a solution that
> changes the vPCI ABI they worked hard to create in the first place?
> 
> I'm still baffled why you think everyone should use vdpa..
> 
> Jason

They shouldn't. If you want proprietary extensions then vfio is the way
to go, I don't think vdpa will support that.

-- 
MST

