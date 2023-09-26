Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90EE37AEBD2
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 13:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233884AbjIZLuP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 07:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbjIZLuN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 07:50:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FCCAE4
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 04:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695728962;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rn26GZx7iEMFes15hPD/QXW1aPy6SBHdulzAjklMMFQ=;
        b=Twqc8CbuSbVQZvv5ACt1mTsGKJ8JjXoAiDkrxNW33yT5+O5Oac9Dx+ZyBLBtIhmaAvZYHX
        QreSg7dheLZ8obdY4gIcL+EkNRmHgeNHgugfZJjZr4eHKA9DWvAD6Jpzszd0SQvGgAhYUv
        Z0A5SO7m4A0+1551F51A7TdPeWo6nnk=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-477-XtLNgyZdPFitzDr6Dg0ltQ-1; Tue, 26 Sep 2023 07:49:21 -0400
X-MC-Unique: XtLNgyZdPFitzDr6Dg0ltQ-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-9b274cc9636so419765166b.0
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 04:49:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695728959; x=1696333759;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rn26GZx7iEMFes15hPD/QXW1aPy6SBHdulzAjklMMFQ=;
        b=KyANoqpNWIKU1OzqMR0vBzXDgG2izMeNCV4CkXszUr7CwxEbp7aamc/tkxWN9LHTAr
         KaXs6eSBn6qjeYWseTMJKdGXnD7FXRHcN9uP9R4SK6smVEz2krGPe2DXRhoNJcl9ShIw
         WwkTHJF5drBvd/3uiCzG6E4Z6siMLwftRSMHQIXkC0upmFhdTX9qo4ZLqmRatunT7EBX
         yRdv7HzsO+2AKVetObvJXHpTxyMnxYvka7emO4C7SFNLZMXsdFoTBZZIBe12VfumVWsp
         v7e/VO4Bd26A7/2q/meTnO6nCwffIqy2bbcAQyJmGcbQ7Bj87YX/CthiDeMPxx3OWtmX
         FYcA==
X-Gm-Message-State: AOJu0YwNVtysBMvdSB9KQj14xTj0XTdQ3mQ3Xj6gENTEClSVh2dFh3bi
        +5e28Pa1UdizdMLV5rUV4YkGOeOkHesRrJuKZ5vlQuvdSU3oI85aD8IADgPlyQwuCiHfgglFVHG
        zjK1HHyl5mmMKhCHzbMdfz84=
X-Received: by 2002:a17:906:1bb1:b0:9ae:3d17:d5d0 with SMTP id r17-20020a1709061bb100b009ae3d17d5d0mr8592498ejg.31.1695728959735;
        Tue, 26 Sep 2023 04:49:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGh6wPENW7EVBACR9Vb/Wc56um6GyOBGTE8QTlhaORLYVTFCoMGcZFTrxB//pXG2+0p0JOmIg==
X-Received: by 2002:a17:906:1bb1:b0:9ae:3d17:d5d0 with SMTP id r17-20020a1709061bb100b009ae3d17d5d0mr8592474ejg.31.1695728959330;
        Tue, 26 Sep 2023 04:49:19 -0700 (PDT)
Received: from redhat.com ([2.52.31.177])
        by smtp.gmail.com with ESMTPSA id l5-20020a170906a40500b009ae4ead6c01sm7633080ejz.163.2023.09.26.04.49.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 04:49:18 -0700 (PDT)
Date:   Tue, 26 Sep 2023 07:49:14 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Parav Pandit <parav@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Feng Liu <feliu@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230926074520-mutt-send-email-mst@kernel.org>
References: <20230921181637.GU13733@nvidia.com>
 <20230921152802-mutt-send-email-mst@kernel.org>
 <20230921195345.GZ13733@nvidia.com>
 <20230921155834-mutt-send-email-mst@kernel.org>
 <CACGkMEvD+cTyRtax7_7TBNECQcGPcsziK+jCBgZcLJuETbyjYw@mail.gmail.com>
 <20230922122246.GN13733@nvidia.com>
 <PH0PR12MB548127753F25C45B7EFF203DDCFFA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CACGkMEuX5HJVBOw9E+skr=K=QzH3oyHK8gk-r0hAvi6Wm7OA7Q@mail.gmail.com>
 <PH0PR12MB5481ED78F7467EEB0740847EDCFCA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CACGkMEv9_+6sYp1JZpCZr19csg0jO-jLVhuygWqm+s9mWr3Lew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEv9_+6sYp1JZpCZr19csg0jO-jLVhuygWqm+s9mWr3Lew@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 26, 2023 at 10:32:39AM +0800, Jason Wang wrote:
> It's the implementation details in legacy. The device needs to make
> sure (reset) the driver can work (is done before get_status return).

I think that there's no way to make it reliably work for all legacy drivers.

They just assumed a software backend and did not bother with DMA
ordering. You can try to avoid resets, they are not that common so
things will tend to mostly work if you don't stress them to much with
things like hot plug/unplug in a loop.  Or you can try to use a driver
after 2011 which is more aware of hardware ordering and flushes the
reset write with a read.  One of these two tricks, I think, is the magic
behind the device exposing memory bar 0 that you mention.

-- 
MST

