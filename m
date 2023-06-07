Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34C93726EE9
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 22:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235415AbjFGUyJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 16:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235428AbjFGUx5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 16:53:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C841FE3
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 13:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686171186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ft5xiF/Ta3lHBxFgPgTJpXvjBg2+fN90ep4jurEd3BE=;
        b=HYqQy44yTPd3obRjQyvQ1G+KTMKa+urRv5HDgEHRyAon4tgJOutOfKwPwK2u0CNPUvzvgA
        rLRijb9uTD2XAo7yCCQVqD1ma1E5sRP+GQwppbo8rvrs4Z9gJq2WMzIyaCYpRDLshBAIXZ
        Km1iFlYHez6OxPooWWK6QDMUqT7usnU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-322-5FN8-K3VNRSKYsKxxNHsJQ-1; Wed, 07 Jun 2023 16:53:05 -0400
X-MC-Unique: 5FN8-K3VNRSKYsKxxNHsJQ-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-30ae8a5006dso10669764f8f.2
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 13:53:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686171184; x=1688763184;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ft5xiF/Ta3lHBxFgPgTJpXvjBg2+fN90ep4jurEd3BE=;
        b=l/a5/W3EcHMdVEYv04IP4iJ444qqiXvYnpmBW25GoV0oxZhgYUcaYKuh3spV3F1rty
         YwyHj/YQO23aXG9DLcla+3UKpsqdDeW66sBNAFsQOHMg1D3t2UVBH6ajtplADDPRTjpI
         Qawh3WlPTyhnTv9iY2r0ZrY9wyS5bBxgvWEz1D/KRAT43xH4I2YGVMiN3HVRieo1Z3ZG
         qGiI+Wc+bVdKuG82oK+oXKzE5fzg3kiHJJlqJui9k6mk5rjcscaDZWoFGbSUb/b86fcm
         rhEaYV4FRPcCn65I1Dy5+7PI/MYuKI26rskCqgcvGMHKPn3pKTCxIMcRjzchmVQYhItr
         TX0A==
X-Gm-Message-State: AC+VfDyVGjLHk4H5oE5X4RRxmGtThapp6fTfeu2hZuOuCq6B8tuycBWy
        rFl4Ak1+nCqI8AeDnGQyKsCC/wIIgDcTV9xuVycqR1ifq/4rYlDkwvO0eoPfmhzyUORS1Zo6SPG
        V9MshZmcRwBuz
X-Received: by 2002:a5d:58e7:0:b0:30a:e5b7:a290 with SMTP id f7-20020a5d58e7000000b0030ae5b7a290mr5386607wrd.15.1686171184000;
        Wed, 07 Jun 2023 13:53:04 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7Uq6PcUd+YOTWXVp6ailbjy7D3AfyP/yNhUjsRFNK0FKM+EidonNaUBgJwfcpN5SMVyMEYIw==
X-Received: by 2002:a5d:58e7:0:b0:30a:e5b7:a290 with SMTP id f7-20020a5d58e7000000b0030ae5b7a290mr5386597wrd.15.1686171183665;
        Wed, 07 Jun 2023 13:53:03 -0700 (PDT)
Received: from redhat.com ([2.55.41.2])
        by smtp.gmail.com with ESMTPSA id j10-20020adff54a000000b003047ae72b14sm16389987wrp.82.2023.06.07.13.53.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 13:53:03 -0700 (PDT)
Date:   Wed, 7 Jun 2023 16:52:59 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Shannon Nelson <shannon.nelson@amd.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        Tiwei Bie <tiwei.bie@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-vdpa: filter VIRTIO_F_RING_PACKED feature
Message-ID: <20230607165205-mutt-send-email-mst@kernel.org>
References: <20230605110644.151211-1-sgarzare@redhat.com>
 <20230605084104-mutt-send-email-mst@kernel.org>
 <24fjdwp44hovz3d3qkzftmvjie45er3g3boac7aezpvzbwvuol@lmo47ydvnqau>
 <20230605085840-mutt-send-email-mst@kernel.org>
 <gi2hngx3ndsgz5d2rpqjywdmou5vxhd7xgi5z2lbachr7yoos4@kpifz37oz2et>
 <20230605095404-mutt-send-email-mst@kernel.org>
 <32ejjuvhvcicv7wjuetkv34qtlpa657n4zlow4eq3fsi2twozk@iqnd2t5tw2an>
 <20230605173958-mutt-send-email-mst@kernel.org>
 <kpcujul6foyvw66qhy3wck5bzgedka2gzzixupnaog7byr4h45@6ddbvcy32db4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <kpcujul6foyvw66qhy3wck5bzgedka2gzzixupnaog7byr4h45@6ddbvcy32db4>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 06, 2023 at 12:09:11PM +0200, Stefano Garzarella wrote:
> On Mon, Jun 05, 2023 at 05:44:50PM -0400, Michael S. Tsirkin wrote:
> > On Mon, Jun 05, 2023 at 04:56:37PM +0200, Stefano Garzarella wrote:
> > > On Mon, Jun 05, 2023 at 09:54:57AM -0400, Michael S. Tsirkin wrote:
> > > > On Mon, Jun 05, 2023 at 03:30:35PM +0200, Stefano Garzarella wrote:
> > > > > On Mon, Jun 05, 2023 at 09:00:25AM -0400, Michael S. Tsirkin wrote:
> > > > > > On Mon, Jun 05, 2023 at 02:54:20PM +0200, Stefano Garzarella wrote:
> > > > > > > On Mon, Jun 05, 2023 at 08:41:54AM -0400, Michael S. Tsirkin wrote:
> > > > > > > > On Mon, Jun 05, 2023 at 01:06:44PM +0200, Stefano Garzarella wrote:
> > > > > > > > > vhost-vdpa IOCTLs (eg. VHOST_GET_VRING_BASE, VHOST_SET_VRING_BASE)
> > > > > > > > > don't support packed virtqueue well yet, so let's filter the
> > > > > > > > > VIRTIO_F_RING_PACKED feature for now in vhost_vdpa_get_features().
> > > > > > > > >
> > > > > > > > > This way, even if the device supports it, we don't risk it being
> > > > > > > > > negotiated, then the VMM is unable to set the vring state properly.
> > > > > > > > >
> > > > > > > > > Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
> > > > > > > > > Cc: stable@vger.kernel.org
> > > > > > > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > > > > > > > ---
> > > > > > > > >
> > > > > > > > > Notes:
> > > > > > > > >     This patch should be applied before the "[PATCH v2 0/3] vhost_vdpa:
> > > > > > > > >     better PACKED support" series [1] and backported in stable branches.
> > > > > > > > >
> > > > > > > > >     We can revert it when we are sure that everything is working with
> > > > > > > > >     packed virtqueues.
> > > > > > > > >
> > > > > > > > >     Thanks,
> > > > > > > > >     Stefano
> > > > > > > > >
> > > > > > > > >     [1] https://lore.kernel.org/virtualization/20230424225031.18947-1-shannon.nelson@amd.com/
> > > > > > > >
> > > > > > > > I'm a bit lost here. So why am I merging "better PACKED support" then?
> > > > > > >
> > > > > > > To really support packed virtqueue with vhost-vdpa, at that point we would
> > > > > > > also have to revert this patch.
> > > > > > >
> > > > > > > I wasn't sure if you wanted to queue the series for this merge window.
> > > > > > > In that case do you think it is better to send this patch only for stable
> > > > > > > branches?
> > > > > > > > Does this patch make them a NOP?
> > > > > > >
> > > > > > > Yep, after applying the "better PACKED support" series and being
> > > > > > > sure that
> > > > > > > the IOCTLs of vhost-vdpa support packed virtqueue, we should revert this
> > > > > > > patch.
> > > > > > >
> > > > > > > Let me know if you prefer a different approach.
> > > > > > >
> > > > > > > I'm concerned that QEMU uses vhost-vdpa IOCTLs thinking that the kernel
> > > > > > > interprets them the right way, when it does not.
> > > > > > >
> > > > > > > Thanks,
> > > > > > > Stefano
> > > > > > >
> > > > > >
> > > > > > If this fixes a bug can you add Fixes tags to each of them? Then it's ok
> > > > > > to merge in this window. Probably easier than the elaborate
> > > > > > mask/unmask dance.
> > > > >
> > > > > CCing Shannon (the original author of the "better PACKED support"
> > > > > series).
> > > > >
> > > > > IIUC Shannon is going to send a v3 of that series to fix the
> > > > > documentation, so Shannon can you also add the Fixes tags?
> > > > >
> > > > > Thanks,
> > > > > Stefano
> > > >
> > > > Well this is in my tree already. Just reply with
> > > > Fixes: <>
> > > > to each and I will add these tags.
> > > 
> > > I tried, but it is not easy since we added the support for packed virtqueue
> > > in vdpa and vhost incrementally.
> > > 
> > > Initially I was thinking of adding the same tag used here:
> > > 
> > > Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
> > > 
> > > Then I discovered that vq_state wasn't there, so I was thinking of
> > > 
> > > Fixes: 530a5678bc00 ("vdpa: support packed virtqueue for set/get_vq_state()")
> > > 
> > > So we would have to backport quite a few patches into the stable branches.
> > > I don't know if it's worth it...
> > > 
> > > I still think it is better to disable packed in the stable branches,
> > > otherwise I have to make a list of all the patches we need.
> > > 
> > > Any other ideas?
> > > 
> > > Thanks,
> > > Stefano
> > 
> > OK so. You want me to apply this one now, and fixes in the next
> > kernel?
> 
> Yep, it seems to me the least risky approach.
> 
> Thanks,
> Stefano

I'd like something more general though. Bring back the allowlist?
Jason, your thoughts?

-- 
MST

