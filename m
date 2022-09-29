Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2F45EF2EE
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 12:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235130AbiI2KB7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 06:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234974AbiI2KBz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 06:01:55 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C530713A07F
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 03:01:53 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 14BE11477;
        Thu, 29 Sep 2022 03:02:00 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9BFC93F73B;
        Thu, 29 Sep 2022 03:01:52 -0700 (PDT)
Date:   Thu, 29 Sep 2022 11:01:49 +0100
From:   Andre Przywara <andre.przywara@arm.com>
To:     dinhngoc.tu@irit.fr
Cc:     kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: Re: [PATCH kvmtool] virtio-net: Fix vq->use_event_idx flag check
Message-ID: <20220929110149.2fe2549d@donnerap.cambridge.arm.com>
In-Reply-To: <20220928151615.1792-1-dinhngoc.tu@irit.fr>
References: <20220928151615.1792-1-dinhngoc.tu@irit.fr>
Organization: ARM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 28 Sep 2022 17:16:15 +0200
dinhngoc.tu@irit.fr wrote:

Hi,

> From: Tu Dinh Ngoc <dinhngoc.tu@irit.fr>
> 
> VIRTIO_RING_F_EVENT_IDX is a bit position value, but
> virtio_init_device_vq populates vq->use_event_idx by ANDing this value
> directly to vdev->features.

Indeed, it's used correctly in other parts of the code (virtio/net.c,
virtio/scsi.c), so we need to shift.

Just one thing below, but good catch!

> 
> Fix the check for this flag in virtio_init_device_vq.
> ---
>  virtio/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virtio/core.c b/virtio/core.c
> index f432421..32e6a7a 100644
> --- a/virtio/core.c
> +++ b/virtio/core.c
> @@ -165,7 +165,7 @@ void virtio_init_device_vq(struct kvm *kvm, struct virtio_device *vdev,
>  	struct vring_addr *addr = &vq->vring_addr;
>  
>  	vq->endian		= vdev->endian;
> -	vq->use_event_idx	= (vdev->features & VIRTIO_RING_F_EVENT_IDX);
> +	vq->use_event_idx	= (vdev->features & (1 << VIRTIO_RING_F_EVENT_IDX));

Can you make this "1UL << ..." instead? Shifting signed values is quite
fragile.

Cheers,
Andre

>  	vq->enabled		= true;
>  
>  	if (addr->legacy) {

