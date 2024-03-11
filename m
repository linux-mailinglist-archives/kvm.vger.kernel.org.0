Return-Path: <kvm+bounces-11517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E401D877C73
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 10:17:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E1E228226C
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 09:17:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5A7B2BAF2;
	Mon, 11 Mar 2024 09:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X76AEdLo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2CB29CE8
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 09:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710148603; cv=none; b=M88LY1SHa4P5R8kRfkSgzbJLX+SZYz3opYsscomJj3I9uMH+YArV5QyoruGiGKJkkDd4dX9tPWMfKz/T0Pk6BJahZm57Ni9suF7bKcirvUaq0LF9TUZY0oHl3Z9yLjSBqydUR2/5LE7brQOQ3LWAGq+0MIVqJ5X/z2j7kTw8I6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710148603; c=relaxed/simple;
	bh=YhVl++BZOeI6zwz1aTmXNBeQhgXKmhmPqQVXenLFTfI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nJwSlD/yXadnyBO58qR1oUygV5709lWp2QYUEsRBc8cJ5oVcIAkeD9E4fHVYKI6ndYM9tIdYiHYE4jSYKNZ/MsCT2pJKaQuJwEIAEq0bQReUECezepJ5UQENhAuMnaJEGj3esMDkdP5qpoYVQYKL/zP+P8lpCpTnyLBYvFxYAD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X76AEdLo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710148601;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h1Ri9kDddSL5LEfhUJzNl9VSoQTVKWDORtXZoaQ46AI=;
	b=X76AEdLoM30szPK4+QhprtIx5s5NnETK0tUWq5z5Fuqhe6WT8YP7Ub+pKSatKQ/Hw3C+t9
	QJiSKku5xwwr5xgcDxYQh3pM1TPuV8UNp7Lrkqy2vsXOYY/l2JpmIJw4NHMS2ZgB8zQkea
	PeELbLANZxRtH4ZSK2lubsPZCdAEO7g=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-403-P5zBriyAOSmpC72a0VNaXA-1; Mon, 11 Mar 2024 05:16:37 -0400
X-MC-Unique: P5zBriyAOSmpC72a0VNaXA-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-33e4397540bso2505487f8f.3
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 02:16:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710148596; x=1710753396;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h1Ri9kDddSL5LEfhUJzNl9VSoQTVKWDORtXZoaQ46AI=;
        b=Wag5veA/qUPqOZ+/wA93GtP2GwNQXPh1+GU1Y/pRVXXulE09c2hITQrw3UpZXUTDti
         TvJRl7mgw5wU9DGKka9+RVNf/p77clbjX9PyjvzjWLJyqX8dfw/Wm6510/q6rsOSNwJd
         U9JAejUvoA6E8phpQt6aQY+30ZYIk4bIEcOMcHf7ZmkpH+s1Mz0VuN+tbymPg7lNuOvw
         osCVZ/9DsWOUBn3EFcwDVj84hHwmlJXDaMiIT0jiWPBN4QToAKRbn+FDKDzd1FZUjE33
         jb0aQk8XB38C2t2/6RdiD1ApiEfasTYo2sjcjT2KRj0FHUvNaLkTLddzyE7TIXJCBpNJ
         hVuA==
X-Gm-Message-State: AOJu0Yz6MpuPg16YKu+0tbtMlCDz7zyY3nIi/f7+m7I0EXnAUg3TXM4o
	yYEQQcTlR1N4MQNccmlipMj+VVGnw0ZARFMQ2ibB8Hp8C0RLnuuFrNd1wDiVFEYLh8ccM2YhSpP
	AlXz52oTFE4+o/NRFN/veDQMbIX1bgiXSXPylo5HdrGnnupIyFA==
X-Received: by 2002:a05:600c:35c8:b0:413:14da:a9f7 with SMTP id r8-20020a05600c35c800b0041314daa9f7mr4558894wmq.0.1710148596652;
        Mon, 11 Mar 2024 02:16:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHq2xtSDxKyoXCZ4290qqGUfXEXDNrk4RQV0BmYu6hnCQ4RqLN62Fs5tQRIZAVlJsCDhIwRnQ==
X-Received: by 2002:a05:600c:35c8:b0:413:14da:a9f7 with SMTP id r8-20020a05600c35c800b0041314daa9f7mr4558881wmq.0.1710148596305;
        Mon, 11 Mar 2024 02:16:36 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id n4-20020a05600c4f8400b00412ff941abasm14934328wmq.21.2024.03.11.02.16.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Mar 2024 02:16:35 -0700 (PDT)
Message-ID: <70d2114b-0b72-4065-b70d-c31cbc70291a@redhat.com>
Date: Mon, 11 Mar 2024 10:16:35 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2 5/7] vfio/platform: Disable virqfds on cleanup
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, clg@redhat.com, reinette.chatre@intel.com,
 linux-kernel@vger.kernel.org, kevin.tian@intel.com, stable@vger.kernel.org
References: <20240308230557.805580-1-alex.williamson@redhat.com>
 <20240308230557.805580-6-alex.williamson@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20240308230557.805580-6-alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Alex,

On 3/9/24 00:05, Alex Williamson wrote:
> irqfds for mask and unmask that are not specifically disabled by the
> user are leaked.  Remove any irqfds during cleanup
>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: stable@vger.kernel.org
> Fixes: a7fa7c77cf15 ("vfio/platform: implement IRQ masking/unmasking via an eventfd")
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  drivers/vfio/platform/vfio_platform_irq.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
> index 61a1bfb68ac7..e5dcada9e86c 100644
> --- a/drivers/vfio/platform/vfio_platform_irq.c
> +++ b/drivers/vfio/platform/vfio_platform_irq.c
> @@ -321,8 +321,11 @@ void vfio_platform_irq_cleanup(struct vfio_platform_device *vdev)
>  {
>  	int i;
>  
> -	for (i = 0; i < vdev->num_irqs; i++)
> +	for (i = 0; i < vdev->num_irqs; i++) {
> +		vfio_virqfd_disable(&vdev->irqs[i].mask);
> +		vfio_virqfd_disable(&vdev->irqs[i].unmask);
>  		vfio_set_trigger(vdev, i, -1, NULL);
> +	}
>  
>  	vdev->num_irqs = 0;
>  	kfree(vdev->irqs);


