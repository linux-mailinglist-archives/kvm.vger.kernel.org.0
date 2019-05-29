Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDD42E024
	for <lists+kvm@lfdr.de>; Wed, 29 May 2019 16:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbfE2Ouy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 May 2019 10:50:54 -0400
Received: from foss.arm.com ([217.140.101.70]:47398 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726012AbfE2Ouy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 May 2019 10:50:54 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E9F4C341;
        Wed, 29 May 2019 07:50:53 -0700 (PDT)
Received: from [10.1.196.129] (ostrya.cambridge.arm.com [10.1.196.129])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4A08D3F5AF;
        Wed, 29 May 2019 07:50:53 -0700 (PDT)
Subject: Re: [PATCH kvmtool 4/4] virtio/blk: Avoid taking pointer to packed
 struct
To:     Andre Przywara <andre.przywara@arm.com>,
        Will Deacon <Will.Deacon@arm.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20190503171544.260901-1-andre.przywara@arm.com>
 <20190503171544.260901-5-andre.przywara@arm.com>
From:   Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Message-ID: <67f7f667-b3b5-2d6a-d148-d8af61c1d90d@arm.com>
Date:   Wed, 29 May 2019 15:50:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190503171544.260901-5-andre.przywara@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/05/2019 18:15, Andre Przywara wrote:
> clang and GCC9 refuse to compile virtio/blk.c with the following message:
> virtio/blk.c:161:37: error: taking address of packed member 'geometry' of class
>       or structure 'virtio_blk_config' may result in an unaligned pointer value
>       [-Werror,-Waddress-of-packed-member]
>         struct virtio_blk_geometry *geo = &conf->geometry;
> 
> Since struct virtio_blk_geometry is in a kernel header, we can't do much
> about the packed attribute, but as Peter pointed out, the solution is
> rather simple: just get rid of the convenience variable and use the
> original struct member directly.
> 
> Suggested-by: Peter Maydell <peter.maydell@linaro.org>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Reviewed-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>

I just encountered this one with GCC 9.1

> ---
>  virtio/blk.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/virtio/blk.c b/virtio/blk.c
> index 50db6f5f..f267be15 100644
> --- a/virtio/blk.c
> +++ b/virtio/blk.c
> @@ -161,7 +161,6 @@ static void set_guest_features(struct kvm *kvm, void *dev, u32 features)
>  {
>  	struct blk_dev *bdev = dev;
>  	struct virtio_blk_config *conf = &bdev->blk_config;
> -	struct virtio_blk_geometry *geo = &conf->geometry;
>  
>  	bdev->features = features;
>  
> @@ -170,7 +169,8 @@ static void set_guest_features(struct kvm *kvm, void *dev, u32 features)
>  	conf->seg_max = virtio_host_to_guest_u32(&bdev->vdev, conf->seg_max);
>  
>  	/* Geometry */
> -	geo->cylinders = virtio_host_to_guest_u16(&bdev->vdev, geo->cylinders);
> +	conf->geometry.cylinders = virtio_host_to_guest_u16(&bdev->vdev,
> +						conf->geometry.cylinders);
>  
>  	conf->blk_size = virtio_host_to_guest_u32(&bdev->vdev, conf->blk_size);
>  	conf->min_io_size = virtio_host_to_guest_u16(&bdev->vdev, conf->min_io_size);
> 

