Return-Path: <kvm+bounces-11887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 95AAC87C97C
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 08:54:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F41921F2292A
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 07:54:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4F1A14AB4;
	Fri, 15 Mar 2024 07:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="VzOAQfG4"
X-Original-To: kvm@vger.kernel.org
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3971168B1;
	Fri, 15 Mar 2024 07:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710489235; cv=none; b=Coxyq5aTXf2DCdRbJgtGXQvmeP0X316eOu3WwsyxbcPw0Y36O+Ba9mtpkaTLhBxwPZlcTRt4A7uzbg1CMDM6qaU0U2g8MevYBV2KThhfEuD/TydRetdGaj4aNzKNl01BCn9UuJmiY8Mtxcwp2YA72mGtSeM0xM6Jmgm65KaON8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710489235; c=relaxed/simple;
	bh=6FMRl6m8tBGLZaaAzsLem205PhnR/hBTd36NLkHi/Cw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YfRap1HphXMzhw1wadsALLNYDdUyWTILr15+rGf9cclpyRg9SjU0j0Ux4ajwjhsGjqf2uCgJMxVnhpeDNFzq9yHUk2JJM8eRYE/v7R7ohDD1/Kv0SaNS3kBf+DVWIhAlT1Z6JWtIWuRaCG/SGsx10ulMUFLQtp3GMBV4lpVUH0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=VzOAQfG4; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1710489229; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=taaP0Q9u2K5DH9xLuWgNdAcyQdJAZ4Px6dOvD4Tr4Bc=;
	b=VzOAQfG4t0ynN0mr9D+RsuQLbRV1YKnO7NNvycyCEWHUN0x51I6QP6xNBf2W2znTe8TZ3tOGYV0hVvuwWmrrPNhCL+oog1dgrhUBgRPg10L01uj13W3ySlhgqDLwMHFEw+gq2pkYs0Tz3R6Le8jldCAYf+6uZNwwuOfrYP6NUTA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=xianting.tian@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0W2VZ4oX_1710489199;
Received: from 30.221.98.145(mailfrom:xianting.tian@linux.alibaba.com fp:SMTPD_---0W2VZ4oX_1710489199)
          by smtp.aliyun-inc.com;
          Fri, 15 Mar 2024 15:53:48 +0800
Message-ID: <e004b5d6-e74c-44a8-afaa-b6f4b993817d@linux.alibaba.com>
Date: Fri, 15 Mar 2024 15:53:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vhost: correct misleading printing information
To: mst@redhat.com, jasowang@redhat.com
Cc: kvm@vger.kernel.org, virtualization@lists.linux.dev,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240311082109.46773-1-xianting.tian@linux.alibaba.com>
From: Xianting Tian <xianting.tian@linux.alibaba.com>
In-Reply-To: <20240311082109.46773-1-xianting.tian@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

it is a very minor fix, I think it can be applied

在 2024/3/11 下午4:21, Xianting Tian 写道:
> Guest moved avail idx not used idx when we need to print log if
> '(vq->avail_idx - last_avail_idx) > vq->num', so fix it.
>
> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
> ---
>   drivers/vhost/vhost.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 045f666b4f12..1f3604c79394 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -2515,7 +2515,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
>   		vq->avail_idx = vhost16_to_cpu(vq, avail_idx);
>   
>   		if (unlikely((u16)(vq->avail_idx - last_avail_idx) > vq->num)) {
> -			vq_err(vq, "Guest moved used index from %u to %u",
> +			vq_err(vq, "Guest moved avail index from %u to %u",
>   				last_avail_idx, vq->avail_idx);
>   			return -EFAULT;
>   		}

