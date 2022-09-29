Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4641E5EF433
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 13:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235100AbiI2LV5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 07:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234798AbiI2LVy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 07:21:54 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C793313F715
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 04:21:53 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3D1FA15BF;
        Thu, 29 Sep 2022 04:22:00 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C3F5D3F73B;
        Thu, 29 Sep 2022 04:21:52 -0700 (PDT)
Date:   Thu, 29 Sep 2022 12:21:36 +0100
From:   Andre Przywara <andre.przywara@arm.com>
To:     Tu Dinh Ngoc <dinhngoc.tu@irit.fr>
Cc:     kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: Re: [PATCH kvmtool v2] virtio-net: Fix vq->use_event_idx flag check
Message-ID: <20220929122136.38f74d7f@donnerap.cambridge.arm.com>
In-Reply-To: <20220929101421.257-1-dinhngoc.tu@irit.fr>
References: <20220928151615.1792-1-dinhngoc.tu@irit.fr>
        <20220929101421.257-1-dinhngoc.tu@irit.fr>
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

On Thu, 29 Sep 2022 12:14:21 +0200
Tu Dinh Ngoc <dinhngoc.tu@irit.fr> wrote:

Hi,

thanks for the quick change!

> VIRTIO_RING_F_EVENT_IDX is a bit position value, but
> virtio_init_device_vq populates vq->use_event_idx by ANDing this value
> directly to vdev->features.
> 
> Fix the check for this flag in virtio_init_device_vq.

I am afraid you need a Signed-off-by: line here, but for the code:

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  virtio/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virtio/core.c b/virtio/core.c
> index f432421..ea0e5b6 100644
> --- a/virtio/core.c
> +++ b/virtio/core.c
> @@ -165,7 +165,7 @@ void virtio_init_device_vq(struct kvm *kvm, struct virtio_device *vdev,
>  	struct vring_addr *addr = &vq->vring_addr;
>  
>  	vq->endian		= vdev->endian;
> -	vq->use_event_idx	= (vdev->features & VIRTIO_RING_F_EVENT_IDX);
> +	vq->use_event_idx	= (vdev->features & (1UL << VIRTIO_RING_F_EVENT_IDX));
>  	vq->enabled		= true;
>  
>  	if (addr->legacy) {

