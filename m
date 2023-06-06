Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABE4C723EF5
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 12:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236090AbjFFKKL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 06:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237278AbjFFKKF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 06:10:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ADA2E53
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 03:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686046158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iCQQ1LZ3gBqjk1nNTdvMqD1fo9eGMxkBs1BPtbczoAU=;
        b=CMzI+gQAyItCHDIMjj9NsirIK23I57OXEt5I0alg3zLUGAoLX9v78ZP6SkzKq5m6gqW32P
        nVZLIBeyJOF2mpfuKxgN2PFQQnDYixMr6H2Utzr8ER5wglpS9UlDHiYqkdmXQN6tx3qnVc
        bu/I08NvQlmXr1uOq0uvChWDQEmfpuE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-210-lYJjarR7PLKJLoO4MBLhtg-1; Tue, 06 Jun 2023 06:09:17 -0400
X-MC-Unique: lYJjarR7PLKJLoO4MBLhtg-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f73283f6c7so12703045e9.1
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 03:09:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686046156; x=1688638156;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iCQQ1LZ3gBqjk1nNTdvMqD1fo9eGMxkBs1BPtbczoAU=;
        b=IdObdWTpqpJj8wbsLQhSt/I/gwb3q/cOWgqAU7S4ncUVALu7gdKjj7RhF5F0A0dBmx
         T93X5hv3iL/roNNiyCzx02SuBteYhinNWUzKti9MqfctMikdtCfHNmn1YR5IQeeZ4dRT
         ySHzs+YPm4zUk18fb2X4QjnxU4CQ7EV56fbH8MIf0P6wh4qaNPK/+SWO3Tmd02mmWiLu
         dVW7C515aOPG4cqu/sRXLx6ErfBbzBr2X9spVJNScm5nmOfqEfdv+9/b1qzHat+0gjqg
         iydts/KMl0FVldpHGzd5ePkFdag8dDJPJu4eQu9wvkWoc6OBujg+luWPR9c0MwKaNclV
         fTtQ==
X-Gm-Message-State: AC+VfDwwJjJpiQUvx3Snej59AmkAATcnLwXl9i/BLdiqelCzlB9IBuoa
        e3zdP+dipFSwnYzfTHz6zy0Cr+pEd2T4C6B/h3Wy7j0d+xX7RfloD5qlEkcZat3K7Pc3Itxxk5X
        CfnkkVE922Pun
X-Received: by 2002:a05:600c:3797:b0:3f7:9b05:928e with SMTP id o23-20020a05600c379700b003f79b05928emr1391403wmr.0.1686046156248;
        Tue, 06 Jun 2023 03:09:16 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ52QSnNnJkRGc6Nqh1PipbVz5Hr4kx9RIOGdzDonWM60PuLaRTr//cxK7weQ3RmRxLry7a9hQ==
X-Received: by 2002:a05:600c:3797:b0:3f7:9b05:928e with SMTP id o23-20020a05600c379700b003f79b05928emr1391380wmr.0.1686046155959;
        Tue, 06 Jun 2023 03:09:15 -0700 (PDT)
Received: from sgarzare-redhat (93-44-29-47.ip95.fastwebnet.it. [93.44.29.47])
        by smtp.gmail.com with ESMTPSA id f4-20020adff8c4000000b00307a83ea722sm12052625wrq.58.2023.06.06.03.09.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 03:09:15 -0700 (PDT)
Date:   Tue, 6 Jun 2023 12:09:11 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Shannon Nelson <shannon.nelson@amd.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
        Tiwei Bie <tiwei.bie@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-vdpa: filter VIRTIO_F_RING_PACKED feature
Message-ID: <kpcujul6foyvw66qhy3wck5bzgedka2gzzixupnaog7byr4h45@6ddbvcy32db4>
References: <20230605110644.151211-1-sgarzare@redhat.com>
 <20230605084104-mutt-send-email-mst@kernel.org>
 <24fjdwp44hovz3d3qkzftmvjie45er3g3boac7aezpvzbwvuol@lmo47ydvnqau>
 <20230605085840-mutt-send-email-mst@kernel.org>
 <gi2hngx3ndsgz5d2rpqjywdmou5vxhd7xgi5z2lbachr7yoos4@kpifz37oz2et>
 <20230605095404-mutt-send-email-mst@kernel.org>
 <32ejjuvhvcicv7wjuetkv34qtlpa657n4zlow4eq3fsi2twozk@iqnd2t5tw2an>
 <20230605173958-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230605173958-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05, 2023 at 05:44:50PM -0400, Michael S. Tsirkin wrote:
>On Mon, Jun 05, 2023 at 04:56:37PM +0200, Stefano Garzarella wrote:
>> On Mon, Jun 05, 2023 at 09:54:57AM -0400, Michael S. Tsirkin wrote:
>> > On Mon, Jun 05, 2023 at 03:30:35PM +0200, Stefano Garzarella wrote:
>> > > On Mon, Jun 05, 2023 at 09:00:25AM -0400, Michael S. Tsirkin wrote:
>> > > > On Mon, Jun 05, 2023 at 02:54:20PM +0200, Stefano Garzarella wrote:
>> > > > > On Mon, Jun 05, 2023 at 08:41:54AM -0400, Michael S. Tsirkin wrote:
>> > > > > > On Mon, Jun 05, 2023 at 01:06:44PM +0200, Stefano Garzarella wrote:
>> > > > > > > vhost-vdpa IOCTLs (eg. VHOST_GET_VRING_BASE, VHOST_SET_VRING_BASE)
>> > > > > > > don't support packed virtqueue well yet, so let's filter the
>> > > > > > > VIRTIO_F_RING_PACKED feature for now in vhost_vdpa_get_features().
>> > > > > > >
>> > > > > > > This way, even if the device supports it, we don't risk it being
>> > > > > > > negotiated, then the VMM is unable to set the vring state properly.
>> > > > > > >
>> > > > > > > Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
>> > > > > > > Cc: stable@vger.kernel.org
>> > > > > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>> > > > > > > ---
>> > > > > > >
>> > > > > > > Notes:
>> > > > > > >     This patch should be applied before the "[PATCH v2 0/3] vhost_vdpa:
>> > > > > > >     better PACKED support" series [1] and backported in stable branches.
>> > > > > > >
>> > > > > > >     We can revert it when we are sure that everything is working with
>> > > > > > >     packed virtqueues.
>> > > > > > >
>> > > > > > >     Thanks,
>> > > > > > >     Stefano
>> > > > > > >
>> > > > > > >     [1] https://lore.kernel.org/virtualization/20230424225031.18947-1-shannon.nelson@amd.com/
>> > > > > >
>> > > > > > I'm a bit lost here. So why am I merging "better PACKED support" then?
>> > > > >
>> > > > > To really support packed virtqueue with vhost-vdpa, at that point we would
>> > > > > also have to revert this patch.
>> > > > >
>> > > > > I wasn't sure if you wanted to queue the series for this merge window.
>> > > > > In that case do you think it is better to send this patch only for stable
>> > > > > branches?
>> > > > > > Does this patch make them a NOP?
>> > > > >
>> > > > > Yep, after applying the "better PACKED support" series and being
>> > > > > sure that
>> > > > > the IOCTLs of vhost-vdpa support packed virtqueue, we should revert this
>> > > > > patch.
>> > > > >
>> > > > > Let me know if you prefer a different approach.
>> > > > >
>> > > > > I'm concerned that QEMU uses vhost-vdpa IOCTLs thinking that the kernel
>> > > > > interprets them the right way, when it does not.
>> > > > >
>> > > > > Thanks,
>> > > > > Stefano
>> > > > >
>> > > >
>> > > > If this fixes a bug can you add Fixes tags to each of them? Then it's ok
>> > > > to merge in this window. Probably easier than the elaborate
>> > > > mask/unmask dance.
>> > >
>> > > CCing Shannon (the original author of the "better PACKED support"
>> > > series).
>> > >
>> > > IIUC Shannon is going to send a v3 of that series to fix the
>> > > documentation, so Shannon can you also add the Fixes tags?
>> > >
>> > > Thanks,
>> > > Stefano
>> >
>> > Well this is in my tree already. Just reply with
>> > Fixes: <>
>> > to each and I will add these tags.
>>
>> I tried, but it is not easy since we added the support for packed virtqueue
>> in vdpa and vhost incrementally.
>>
>> Initially I was thinking of adding the same tag used here:
>>
>> Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
>>
>> Then I discovered that vq_state wasn't there, so I was thinking of
>>
>> Fixes: 530a5678bc00 ("vdpa: support packed virtqueue for set/get_vq_state()")
>>
>> So we would have to backport quite a few patches into the stable branches.
>> I don't know if it's worth it...
>>
>> I still think it is better to disable packed in the stable branches,
>> otherwise I have to make a list of all the patches we need.
>>
>> Any other ideas?
>>
>> Thanks,
>> Stefano
>
>OK so. You want me to apply this one now, and fixes in the next
>kernel?

Yep, it seems to me the least risky approach.

Thanks,
Stefano

