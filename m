Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28D0D7B0E0A
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 23:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbjI0Vay (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 17:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjI0Vaw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 17:30:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6BD5D6
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 14:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695850212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E/hWvDm1OcTrG/VO8KCVt4P4CK7b9Zrkcj60yfAmxHA=;
        b=CDW+iLUA+PmtIsheWNajNqqecDSIbbe58zNtKa+e3uoPs7Mpv3mxfqmpsDJAzXHbmZt9Ld
        RvoyZDtDV8eVih8vU9KBd3qpi4Nf4Eff/WiwMfPkpK1twmrM6r0SlF27Q2MRhiyR7Tppw2
        l7PNzo6G2isTsbbFuD5CCzd8G8r8+IE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-601-Fff5mr6fOVS9YjwYGcvXhA-1; Wed, 27 Sep 2023 17:30:10 -0400
X-MC-Unique: Fff5mr6fOVS9YjwYGcvXhA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3fd0fa4d08cso103630345e9.1
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 14:30:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695850209; x=1696455009;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E/hWvDm1OcTrG/VO8KCVt4P4CK7b9Zrkcj60yfAmxHA=;
        b=wsKk76kAIek9LBb4DO1mJ6QpFlhUTXYjmoK2XSV2KBmoaecYl7NeRxAbdkSIrne5WN
         1QJO3YPp3/aoT/aCepDOgUN6f16aSgbmXBQ4sGAsG0qU9eA8n7d8oKRrKVFXQQXy3/RK
         CwIg324jdU87nW1Fbx1jJT5jLQEvveBjsEKNtronMBA7YTM9VqfjMJzpqosZhbH/E04Z
         OSfg0JNzQg6Z2bQWiHrIK/0klRqA5Q0OuiQnnocHVUICAOlXWD1uLjpbMgicj9ZmTtTC
         YOTkM1hrIIWIu84hPlfARxbHNSW7Lyh0CyYEmqUA0defahWZK69GJHtXdKNB6sPjObsy
         Dbvw==
X-Gm-Message-State: AOJu0Ywcyl372SSFW5m7AAPALxzWsp2CR7CNcnpoekcrZb3ApYp58m2+
        +ZHpi1KV9ZVVaf8Lnr1SkPZi3nTPmaezCRGRs3lV/088/jwZK4wAvAO4dyQec+PLxSmW+XsyAV3
        BKTs/rx7OVT44
X-Received: by 2002:a1c:7c17:0:b0:401:c0ef:c287 with SMTP id x23-20020a1c7c17000000b00401c0efc287mr2914645wmc.27.1695850208869;
        Wed, 27 Sep 2023 14:30:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEemzT3gLlpHYsXzcHz13K1oDD8XGSyUvzYYkawuzvrxg1U8rZ9W15Au84bTbbiacNpiQ4/Rw==
X-Received: by 2002:a1c:7c17:0:b0:401:c0ef:c287 with SMTP id x23-20020a1c7c17000000b00401c0efc287mr2914632wmc.27.1695850208496;
        Wed, 27 Sep 2023 14:30:08 -0700 (PDT)
Received: from redhat.com ([2.52.19.249])
        by smtp.gmail.com with ESMTPSA id p10-20020a5d59aa000000b00323287186aasm9084532wrr.32.2023.09.27.14.30.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Sep 2023 14:30:07 -0700 (PDT)
Date:   Wed, 27 Sep 2023 17:30:04 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, kvm@vger.kernel.org,
        maorg@nvidia.com, virtualization@lists.linux-foundation.org,
        jiri@nvidia.com, leonro@nvidia.com
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Message-ID: <20230927172806-mutt-send-email-mst@kernel.org>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-11-yishaih@nvidia.com>
 <20230922055336-mutt-send-email-mst@kernel.org>
 <c3724e2f-7938-abf7-6aea-02bfb3881151@nvidia.com>
 <20230926072538-mutt-send-email-mst@kernel.org>
 <20230927131817.GA338226@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230927131817.GA338226@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 27, 2023 at 10:18:17AM -0300, Jason Gunthorpe wrote:
> On Tue, Sep 26, 2023 at 07:41:44AM -0400, Michael S. Tsirkin wrote:
> 
> > > By the way, this follows what was done already between vfio/mlx5 to
> > > mlx5_core modules where mlx5_core exposes generic APIs to execute a command
> > > and to get the a PF from a given mlx5 VF.
> > 
> > This is up to mlx5 maintainers. In particular they only need to worry
> > that their patches work with specific hardware which they likely have.
> > virtio has to work with multiple vendors - hardware and software -
> > and exposing a low level API that I can't test on my laptop
> > is not at all my ideal.
> 
> mlx5 has a reasonable API from the lower level that allows the vfio
> driver to safely issue commands. The API provides all the safety and
> locking you have been questioning here.
> 
> Then the vfio driver can form the commands directly and in the way it
> needs. This avoids spewing code into the core modules that is only
> used by vfio - which has been a key design consideration for our
> driver layering.
> 
> I suggest following the same design here as it has been well proven.
> Provide a solid API to operate the admin queue and let VFIO use
> it. One of the main purposes of the admin queue is to deliver commands
> on behalf of the VF driver, so this is a logical and reasonable place
> to put an API.

Not the way virtio is designed now. I guess mlx5 is designed in
a way that makes it safe.

> > > This way, we can enable further commands to be added/extended
> > > easily/cleanly.
> > 
> > Something for vfio maintainer to consider in case it was
> > assumed that it's just this one weird thing
> > but otherwise it's all generic vfio. It's not going to stop there,
> > will it? The duplication of functionality with vdpa will continue :(
> 
> VFIO live migration is expected to come as well once OASIS completes
> its work.

Exactly. Is there doubt vdpa will want to support live migration?
Put this code in a library please.

> Parav, are there other things?
> 
> Jason

