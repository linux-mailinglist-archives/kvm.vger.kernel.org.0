Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D74272327B
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 23:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbjFEVpk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 17:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232823AbjFEVpi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 17:45:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3D9F2
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 14:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686001497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WpKIMI7QM/wVRTxo2f7IQpPSM5zVOF2jBBbDgfwLd/0=;
        b=PC2MjuDJ0X6p3EDliUsdGz0RXtNxmjXIsgwnCob7+pNm5RNfwi9wzNNEO71mVksSeibCj7
        DYVRjUgqTTwz2afGclyxYWrmkk9rU1aH0HayCqJMY4PGaOPXJMVdpHywweK4Pdu+wJri2g
        XIN45RnlgNp4TA9v8mCEN4or6OctXJs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-255-lgjSGpxqNBi4mdj6sI3wqw-1; Mon, 05 Jun 2023 17:44:56 -0400
X-MC-Unique: lgjSGpxqNBi4mdj6sI3wqw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f7e8c24a92so1612995e9.0
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 14:44:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686001495; x=1688593495;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WpKIMI7QM/wVRTxo2f7IQpPSM5zVOF2jBBbDgfwLd/0=;
        b=R+jTKdfkZoJkeEE0h7lJjM1PKoFaP7tc9V8KDui50q7hIsXK57aP2lEiMmDbKjQRXm
         S5QvAahBf4I8VyTaVoxta9u4iSnPBRco+h08Qa1xfES0lKULJ4jqOauMltOeuETgZZCw
         iJexzxA6WYP3y9+Z903SA+4wzccTvgHv7SHRM7v0k8fDaG0nh2D1oC5qQmY4DC18Iprs
         YyTWZ+yScQI+gsL09O5q13enT/09YJLqj5Vd4A3a7+PatlkMJQ4V2kF+VuA+Ev9oeOcr
         eDhRAJoM+iWBzaxETNVyhQGsSGpt9bJXVDWE0oUq1uO5LyJ497cZEFBDHjOMnu010tF1
         UvEw==
X-Gm-Message-State: AC+VfDzsrnRditlTsgwZ9rL+tvcTA+WvzO2s0DVVinFK+Lo/hcAK/KuR
        o0zcEj32qIE3TFG++7pufWMW6kWRgwQ0ORGoSwtQ7plsUxg5HzHghtcV2EFjRvXzu/AMqrNf5Dp
        UQK4TEgiL8H81
X-Received: by 2002:a7b:c40f:0:b0:3f7:5e08:7a04 with SMTP id k15-20020a7bc40f000000b003f75e087a04mr324439wmi.25.1686001495373;
        Mon, 05 Jun 2023 14:44:55 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4u8Ic/y4eCXxAW8Bpwr/2TMDw54kNLZMenywFlEZSHsc+nxVJwRBB1hWlaJzPhaz3ai/scQA==
X-Received: by 2002:a7b:c40f:0:b0:3f7:5e08:7a04 with SMTP id k15-20020a7bc40f000000b003f75e087a04mr324432wmi.25.1686001495049;
        Mon, 05 Jun 2023 14:44:55 -0700 (PDT)
Received: from redhat.com ([2.55.41.2])
        by smtp.gmail.com with ESMTPSA id b14-20020a5d40ce000000b002e5ff05765esm10931997wrq.73.2023.06.05.14.44.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 14:44:54 -0700 (PDT)
Date:   Mon, 5 Jun 2023 17:44:50 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Shannon Nelson <shannon.nelson@amd.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        Tiwei Bie <tiwei.bie@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-vdpa: filter VIRTIO_F_RING_PACKED feature
Message-ID: <20230605173958-mutt-send-email-mst@kernel.org>
References: <20230605110644.151211-1-sgarzare@redhat.com>
 <20230605084104-mutt-send-email-mst@kernel.org>
 <24fjdwp44hovz3d3qkzftmvjie45er3g3boac7aezpvzbwvuol@lmo47ydvnqau>
 <20230605085840-mutt-send-email-mst@kernel.org>
 <gi2hngx3ndsgz5d2rpqjywdmou5vxhd7xgi5z2lbachr7yoos4@kpifz37oz2et>
 <20230605095404-mutt-send-email-mst@kernel.org>
 <32ejjuvhvcicv7wjuetkv34qtlpa657n4zlow4eq3fsi2twozk@iqnd2t5tw2an>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32ejjuvhvcicv7wjuetkv34qtlpa657n4zlow4eq3fsi2twozk@iqnd2t5tw2an>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05, 2023 at 04:56:37PM +0200, Stefano Garzarella wrote:
> On Mon, Jun 05, 2023 at 09:54:57AM -0400, Michael S. Tsirkin wrote:
> > On Mon, Jun 05, 2023 at 03:30:35PM +0200, Stefano Garzarella wrote:
> > > On Mon, Jun 05, 2023 at 09:00:25AM -0400, Michael S. Tsirkin wrote:
> > > > On Mon, Jun 05, 2023 at 02:54:20PM +0200, Stefano Garzarella wrote:
> > > > > On Mon, Jun 05, 2023 at 08:41:54AM -0400, Michael S. Tsirkin wrote:
> > > > > > On Mon, Jun 05, 2023 at 01:06:44PM +0200, Stefano Garzarella wrote:
> > > > > > > vhost-vdpa IOCTLs (eg. VHOST_GET_VRING_BASE, VHOST_SET_VRING_BASE)
> > > > > > > don't support packed virtqueue well yet, so let's filter the
> > > > > > > VIRTIO_F_RING_PACKED feature for now in vhost_vdpa_get_features().
> > > > > > >
> > > > > > > This way, even if the device supports it, we don't risk it being
> > > > > > > negotiated, then the VMM is unable to set the vring state properly.
> > > > > > >
> > > > > > > Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
> > > > > > > Cc: stable@vger.kernel.org
> > > > > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > > > > > ---
> > > > > > >
> > > > > > > Notes:
> > > > > > >     This patch should be applied before the "[PATCH v2 0/3] vhost_vdpa:
> > > > > > >     better PACKED support" series [1] and backported in stable branches.
> > > > > > >
> > > > > > >     We can revert it when we are sure that everything is working with
> > > > > > >     packed virtqueues.
> > > > > > >
> > > > > > >     Thanks,
> > > > > > >     Stefano
> > > > > > >
> > > > > > >     [1] https://lore.kernel.org/virtualization/20230424225031.18947-1-shannon.nelson@amd.com/
> > > > > >
> > > > > > I'm a bit lost here. So why am I merging "better PACKED support" then?
> > > > >
> > > > > To really support packed virtqueue with vhost-vdpa, at that point we would
> > > > > also have to revert this patch.
> > > > >
> > > > > I wasn't sure if you wanted to queue the series for this merge window.
> > > > > In that case do you think it is better to send this patch only for stable
> > > > > branches?
> > > > > > Does this patch make them a NOP?
> > > > >
> > > > > Yep, after applying the "better PACKED support" series and being
> > > > > sure that
> > > > > the IOCTLs of vhost-vdpa support packed virtqueue, we should revert this
> > > > > patch.
> > > > >
> > > > > Let me know if you prefer a different approach.
> > > > >
> > > > > I'm concerned that QEMU uses vhost-vdpa IOCTLs thinking that the kernel
> > > > > interprets them the right way, when it does not.
> > > > >
> > > > > Thanks,
> > > > > Stefano
> > > > >
> > > >
> > > > If this fixes a bug can you add Fixes tags to each of them? Then it's ok
> > > > to merge in this window. Probably easier than the elaborate
> > > > mask/unmask dance.
> > > 
> > > CCing Shannon (the original author of the "better PACKED support"
> > > series).
> > > 
> > > IIUC Shannon is going to send a v3 of that series to fix the
> > > documentation, so Shannon can you also add the Fixes tags?
> > > 
> > > Thanks,
> > > Stefano
> > 
> > Well this is in my tree already. Just reply with
> > Fixes: <>
> > to each and I will add these tags.
> 
> I tried, but it is not easy since we added the support for packed virtqueue
> in vdpa and vhost incrementally.
> 
> Initially I was thinking of adding the same tag used here:
> 
> Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
> 
> Then I discovered that vq_state wasn't there, so I was thinking of
> 
> Fixes: 530a5678bc00 ("vdpa: support packed virtqueue for set/get_vq_state()")
> 
> So we would have to backport quite a few patches into the stable branches.
> I don't know if it's worth it...
> 
> I still think it is better to disable packed in the stable branches,
> otherwise I have to make a list of all the patches we need.
> 
> Any other ideas?
> 
> Thanks,
> Stefano

OK so. You want me to apply this one now, and fixes in the next
kernel?

-- 
MST

