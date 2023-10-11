Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBA5F7C4AE6
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 08:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345681AbjJKGof (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 02:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345305AbjJKGoe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 02:44:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EBD79E
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 23:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697006624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mJx1ZypuyCBhHofs+m0EruMV3iKJ6PM06dyDEb4T+8w=;
        b=hpAGODKumpydQt50JmAGepzvIvNCIgHBU0HW+hL3v5iLgmLRO6YzyHUsWlu7+VQdGjuJnr
        yfx+ZK2gl54UBRBDjy1oU55cCfeqf8/LuEV/5/z/D8+/FAuczQrCHX9yB0LDdBOUceRPEk
        eCo2sQ7jDvxF1BQS2ZXyqbiVoW9XUmg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-424-e0Z9ppUpP3q9Ci8zgqodJQ-1; Wed, 11 Oct 2023 02:43:42 -0400
X-MC-Unique: e0Z9ppUpP3q9Ci8zgqodJQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-40540179bcdso42634015e9.2
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 23:43:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697006621; x=1697611421;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mJx1ZypuyCBhHofs+m0EruMV3iKJ6PM06dyDEb4T+8w=;
        b=HSqjHQILpOaDtF5vEPFhMwsDVACZ3DpiPyyB/VtWREWtPyb56N5VHF2WndWEuBJGpx
         8w7Q7kWp6/2NKD9CVhqTcoA9C1mREu8wPxypIYbw4uJxALE9pR9n02as1BKCE86X8zRv
         Z13FV4Brpj0kxa6NFhpotZURXbKvXAgpZqCZNoYSLWJ7A+w3e1Le5oGB2h6tCvponbsr
         1OUTT/imSY5FBAjoX3seQmZ/ZkjK3KopduymfVp7p5LpMm6lZEEFOZiVmVTVsWcvKI/A
         cpgczloAI9te9cYpVJO9uWz7+a+hlQnWmxYImbYjFce51xdww8zhb06+kV/+E83jrEma
         M++g==
X-Gm-Message-State: AOJu0YxofNK78z1LY66S34Ig6oBECkjBj2vcZv2QXr0n9JfLcCBYxah1
        NN65Lp1CANNm+D+jigqLZcJegLe8iX8VozEzq7g24xMGjw1W+Zc3PGwd5uAOWlV13EN79X1xWv1
        BY3dw11W0VE1T
X-Received: by 2002:a05:6000:24d:b0:32d:84a3:f3fe with SMTP id m13-20020a056000024d00b0032d84a3f3femr691983wrz.41.1697006621582;
        Tue, 10 Oct 2023 23:43:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG8A2qvfZT9bfpQ4OGYXjkie2YsT/ReG59ydBRsD0X364kMDllO/yZ7REyYw6wH9Rau1hYO9g==
X-Received: by 2002:a05:6000:24d:b0:32d:84a3:f3fe with SMTP id m13-20020a056000024d00b0032d84a3f3femr691972wrz.41.1697006621226;
        Tue, 10 Oct 2023 23:43:41 -0700 (PDT)
Received: from redhat.com ([147.235.219.90])
        by smtp.gmail.com with ESMTPSA id r25-20020adfa159000000b0032d819a8900sm1706874wrr.27.2023.10.10.23.43.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 23:43:40 -0700 (PDT)
Date:   Wed, 11 Oct 2023 02:43:37 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Message-ID: <20231011021454-mutt-send-email-mst@kernel.org>
References: <20231005111004.GK682044@nvidia.com>
 <ZSAG9cedvh+B0c0E@infradead.org>
 <20231010131031.GJ3952@nvidia.com>
 <20231010094756-mutt-send-email-mst@kernel.org>
 <20231010140849.GL3952@nvidia.com>
 <20231010105339-mutt-send-email-mst@kernel.org>
 <e979dfa2-0733-7f0f-dd17-49ed89ef6c40@nvidia.com>
 <20231010111339-mutt-send-email-mst@kernel.org>
 <20231010155937.GN3952@nvidia.com>
 <ZSY9Cv5/e3nfA7ux@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZSY9Cv5/e3nfA7ux@infradead.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 10, 2023 at 11:13:30PM -0700, Christoph Hellwig wrote:
> On Tue, Oct 10, 2023 at 12:59:37PM -0300, Jason Gunthorpe wrote:
> > On Tue, Oct 10, 2023 at 11:14:56AM -0400, Michael S. Tsirkin wrote:
> > 
> > > I suggest 3 but call it on the VF. commands will switch to PF
> > > internally as needed. For example, intel might be interested in exposing
> > > admin commands through a memory BAR of VF itself.
> > 
> > FWIW, we have been pushing back on such things in VFIO, so it will
> > have to be very carefully security justified.
> > 
> > Probably since that is not standard it should just live in under some
> > intel-only vfio driver behavior, not in virtio land.
> 
> Btw, what is that intel thing everyone is talking about?  And why
> would the virtio core support vendor specific behavior like that?

It's not a thing it's Zhu Lingshan :) intel is just one of the vendors
that implemented vdpa support and so Zhu Lingshan from intel is working
on vdpa and has also proposed virtio spec extensions for migration.
intel's driver is called ifcvf.  vdpa composes all this stuff that is
added to vfio in userspace, so it's a different approach.

-- 
MST

