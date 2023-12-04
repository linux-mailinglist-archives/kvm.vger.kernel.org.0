Return-Path: <kvm+bounces-3287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B8CF802A9F
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 04:55:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 72896280C94
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 03:55:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E09CC4698;
	Mon,  4 Dec 2023 03:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WFHRbC+J"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E27FFB6
	for <kvm@vger.kernel.org>; Sun,  3 Dec 2023 19:55:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701662115;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D5lLOORfRcCNxVRCcAK4ye/0pShLDh//TEXCyUwt7Ho=;
	b=WFHRbC+JeE6txdZ3IIjnHw7wwxEgMrBULYTTFF4GvF7h4iuHDVAHMb1Zszru+OTUiD4h1b
	dd1nr80O+ADqGT46s7rJqGCUgqo0W2bUpvyDNbWoFi92Hysuc8gjftk3CSbA9QYfJi7EC4
	5rJ126WEbEPi5zJqDsOLACOx5ewE2tg=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-551-o-Y_FQzDPj250QCtoD9Axw-1; Sun, 03 Dec 2023 22:55:13 -0500
X-MC-Unique: o-Y_FQzDPj250QCtoD9Axw-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1d053953954so13339265ad.2
        for <kvm@vger.kernel.org>; Sun, 03 Dec 2023 19:55:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701662112; x=1702266912;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D5lLOORfRcCNxVRCcAK4ye/0pShLDh//TEXCyUwt7Ho=;
        b=vp8BtwEIJvuzuSRtJ6L2fJQ7o04FLoBn0QtZXHZsOtiLZE/ptKaT+EUlLOLrOkIoei
         6QwO8L8/Xm+22vWsYl+IqWdwanl/2UmUR89ULHNpUBv2TCFe7IhdxvsPDTlp1FkG+2pT
         HAbdcrOhMRpmIbYhz83DBaNcjuVkQTBr64iQrcBs1sjvjZK7IP3gpsWsPW3W+s/yZ3PP
         eiNgX+cdx7vp/f9YK2M9G9z4jbMRXhlIuJqWpPWGAaI08mkj6VkKmo6wryedD3hK/xb9
         JA6Mu92+2XZqH0IJKsPx2ZrXT2O13ZAXwZ9mmMFTQXEulqD1Ib7K6AxW6uJAOD/RNloa
         FZeg==
X-Gm-Message-State: AOJu0Yx/Xt5DqJmPMBm7CWSD9geoZU4YL9BcoIqIfivbTQMRPpq3azEs
	d3CuUM8BbrwPhhkNuv8zLivYXKebuEnFd0PWikfAgEOR7GWQb1BF7csyiURLyy4wqa6lrz8a5yZ
	kJOYKU8qwTlz5TO+p6nr+
X-Received: by 2002:a17:902:a50e:b0:1d0:6ffd:6e60 with SMTP id s14-20020a170902a50e00b001d06ffd6e60mr997568plq.88.1701662112544;
        Sun, 03 Dec 2023 19:55:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGl0xpifpIDP0JZxNBTa0wVIODcQ6AaZvqFQddOTQ80Unt2jlibel8DU7jAMPosKF+HmOaaDQ==
X-Received: by 2002:a17:902:a50e:b0:1d0:6ffd:6e60 with SMTP id s14-20020a170902a50e00b001d06ffd6e60mr997561plq.88.1701662112105;
        Sun, 03 Dec 2023 19:55:12 -0800 (PST)
Received: from [192.168.68.51] ([43.252.115.3])
        by smtp.gmail.com with ESMTPSA id s16-20020a170902ea1000b001d0855ce7c8sm2105952plg.252.2023.12.03.19.55.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Dec 2023 19:55:11 -0800 (PST)
Message-ID: <d4e5fc82-48b9-4e20-b395-d8ebb9391e1c@redhat.com>
Date: Mon, 4 Dec 2023 13:55:07 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-for-9.0 1/2] accel/kvm: Expose kvm_supports_guest_debug()
 prototype
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20231201143201.40182-1-philmd@linaro.org>
 <20231201143201.40182-2-philmd@linaro.org>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20231201143201.40182-2-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/2/23 00:32, Philippe Mathieu-Daudé wrote:
> kvm_supports_guest_debug() should be accessible by KVM
> implementations.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   accel/kvm/kvm-cpus.h | 1 -
>   include/sysemu/kvm.h | 1 +
>   2 files changed, 1 insertion(+), 1 deletion(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


