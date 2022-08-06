Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E245F58B4CE
	for <lists+kvm@lfdr.de>; Sat,  6 Aug 2022 11:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240856AbiHFJmv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Aug 2022 05:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiHFJmu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Aug 2022 05:42:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A404E0F9;
        Sat,  6 Aug 2022 02:42:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF131B804A4;
        Sat,  6 Aug 2022 09:42:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AC11C433C1;
        Sat,  6 Aug 2022 09:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659778966;
        bh=qCrb+uhGHZLFEcmNx8yyS2wZACamZkAd0f+2rHn1FlI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C2Q6OxPPUGczZlpitW1/uOZHT9OupTEQXxjwJre6xcp75fW/drWAZeqWoUT/ta9po
         ET6KMun7iV9u9yvsd4eTiTrNhICPjO3KZKLuu+TXNDPNz8JnfMODeoor6W/oqPs7se
         SRN7IrrjNP5iGhGdq7L/2qzFfxYYvgMZadLe0lDK3jtepOsXv3IyPXjLfrBR9tGGZz
         QEQ661z5Uzo2PJjWFz3h6A88FMWH5BtdF4ucDVy1oxcvNyEFJ0YnR/lsYBAyfvkXO2
         YnO8BvLN0d3aLKt9d8GDMgKrZ1L3BYcjkncr8F/TJdAvLYq4KancdBDgfhmLy4/P32
         SC+34qEAcsywQ==
Date:   Sat, 6 Aug 2022 10:42:40 +0100
From:   Will Deacon <will@kernel.org>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     mst@redhat.com, stefanha@redhat.com, jasowang@redhat.com,
        torvalds@linux-foundation.org, ascull@google.com, maz@kernel.org,
        keirf@google.com, jiyong@google.com, kernel-team@android.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: IOTLB support for vhost/vsock breaks crosvm on Android
Message-ID: <20220806094239.GA30268@willie-the-truck>
References: <20220805181105.GA29848@willie-the-truck>
 <20220806074828.zwzgn5gj47gjx5og@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220806074828.zwzgn5gj47gjx5og@sgarzare-redhat>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Stefano,

On Sat, Aug 06, 2022 at 09:48:28AM +0200, Stefano Garzarella wrote:
> On Fri, Aug 05, 2022 at 07:11:06PM +0100, Will Deacon wrote:
> > The fundamental issue is, I think, that VIRTIO_F_ACCESS_PLATFORM is
> > being used for two very different things within the same device; for the
> > guest it basically means "use the DMA API, it knows what to do" but for
> > vhost it very specifically means "enable IOTLB". We've recently had
> > other problems with this flag [3] but in this case it used to work
> > reliably and now it doesn't anymore.
> > 
> > So how should we fix this? One possibility is for us to hack crosvm to
> > clear the VIRTIO_F_ACCESS_PLATFORM flag when setting the vhost
> 
> Why do you consider this a hack?

I think it's a hack for two reasons:

  (1) We're changing userspace to avoid a breaking change in kernel behaviour
  (2) I think that crosvm's approach is actually pretty reasonable

To elaborate on (2), crosvm has a set of device features that it has
negotiated with the guest. It then takes the intersection of these features
with those advertised by VHOST_GET_FEATURES and calls VHOST_SET_FEATURES
with the result. If there was a common interpretation of what these features
do, then this would work and would mean we wouldn't have to opt-in on a
per-flag basis for vhost. Since VIRTIO_F_ACCESS_PLATFORM is being overloaded
to mean two completely different things, then it breaks and I think masking
out that specific flag is a hack because it's basically crosvm saying "yeah,
I may have negotiated this with the driver but vhost _actually_ means
'IOTLB' when it says it supports this flag so I'll mask it out because I
know better".

> If the VMM implements the translation feature, it is right in my opinion
> that it does not enable the feature for the vhost device. Otherwise, if it
> wants the vhost device to do the translation, enable the feature and send
> the IOTLB messages to set the translation.
> 
> QEMU for example masks features when not required or supported.
> crosvm should negotiate only the features it supports.
> 
> @Michael and @Jason can correct me, but if a vhost device negotiates
> VIRTIO_F_ACCESS_PLATFORM, then it expects the VMM to send IOTLB messages to
> set the translation.

As above, the issue is that vhost now unconditionally advertises this in
VHOST_GET_FEATURES and so a VMM with no knowledge of IOTLB can end up
enabling it by accident.

Will
