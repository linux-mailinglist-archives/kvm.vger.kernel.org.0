Return-Path: <kvm+bounces-18595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7ED1E8D7AC4
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 06:29:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 512711C2167A
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 04:29:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EA9817BB9;
	Mon,  3 Jun 2024 04:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ICU8aSUR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01DBF1B7E4
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 04:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717388952; cv=none; b=JZIB5uIoV9DV5sCNh4uEE1hmnxo5r/t2mpkhQq+dinANeiNajVqzfyWy6uOYTBVCRHfe/fdDcNpGwExr6Olt4h1J1h8jEV0n68trPDjVOma+vyYd/x7KfgBJvXj6izQx1GyIgKvlbuWuZssQG8xZGuBBmxiWNjLRBkxTUwNEUfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717388952; c=relaxed/simple;
	bh=Ls3vfEWnk7b6Wm7VxJtXxT1NzEcRgIms7yaI835vvk8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X82Baot5Bi2yx/e6Kk0kS1lFLaNVf4ckn1yww0BVjaToazYw94DKTY3IZSK8VSLEB7BWYvNBpz0IZNksGpTS5ZXX88XpiCc6k5GlTqj+73Dev8Lw2+PgZydcC19TBUaNX98OKa+XoUpgz4Z+rNtsg/y3QIUL7uh/LwGTCtK7o2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ICU8aSUR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717388949;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JwhEQmzMqqIaoN9//KeQfCRud/RMBPsUeYMrJfOmv0A=;
	b=ICU8aSURl6JTDvUVLZ0yBbkFHI9gFJy3eCz5hvX+sezdAYM0O/g2Z6OS5iCudMW6pytnsh
	eCuoBPhYpj6gmhlvEARWlHuefgehSSdZ09Cn1/5W7St4x0oeQUTlrzwfEeYNrgAUz4T+ZA
	ZiXE3lUgsNrVIPI4vRW7RnWHooPJcfY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-465-62QNaGegPQKNW_WcS_k0Vw-1; Mon, 03 Jun 2024 00:29:04 -0400
X-MC-Unique: 62QNaGegPQKNW_WcS_k0Vw-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-35e0ea8575cso1371946f8f.3
        for <kvm@vger.kernel.org>; Sun, 02 Jun 2024 21:29:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717388944; x=1717993744;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JwhEQmzMqqIaoN9//KeQfCRud/RMBPsUeYMrJfOmv0A=;
        b=DaL1tfQT8JENv3AKZGimr9veHnMYtWjyyNH2BB4gBmhzLB/u3wRmIURKSAQNAdsQ48
         oB62Xw9+Lx8lW+iHuRioR+pkHVhnLRmW3hSi3o0YJbLx4nNv2vuZg2JCURmNB7uF58TO
         ROxZYSdSRAhcNfBz0UvnGJBVSWUjWqIYRxCF70thfAfxCaiBI8K+rcVAE6u7iySOyvZ8
         7IRaZZB5wONzWq07/JHNpML6qHGUUhi1lzlbNOPlJsfM3UeLmQ4/q83SzzfV/I0L3Ckw
         TJ/+cOpDTiYxV9SpLXC11Sy4oG39yFccCImQx244aHjVbRGa1MRPtXAkwglp7FYUIRfJ
         utCg==
X-Forwarded-Encrypted: i=1; AJvYcCUBl3t18M/BIn3PkIMlXDyChuxGA/pzUMd9fDqLGhdmHBUT4g8g/KZEzd3Uxj60L7wjSAP6NFMr0Irl33t1/tiWas1l
X-Gm-Message-State: AOJu0Yy81l3kLXuC0pOx5pEvqzHpuwTTOx5EGncx0oIanuEAP457kzHt
	rDbgBt5+qfKteg0wOqGpl+sntFoxf1sMmmYZmAVqmKFCjFVdwKhBB9vaSjol7hNsSU41TBB5yb2
	MSrLR+CJqmUiOJb6BLuiW9ImfS7BsJAqi1f+ywab5cAA8udlC5g==
X-Received: by 2002:a5d:68cf:0:b0:354:f92f:fd00 with SMTP id ffacd0b85a97d-35e0f30c6b5mr5243021f8f.52.1717388943816;
        Sun, 02 Jun 2024 21:29:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGBgVNxBGGdbE8aYjiKftOOlySMI6jmq6kSP5/rb+jsN+R3BCNKl8WId6Rm9jS++kS3sxXfqw==
X-Received: by 2002:a5d:68cf:0:b0:354:f92f:fd00 with SMTP id ffacd0b85a97d-35e0f30c6b5mr5243013f8f.52.1717388943449;
        Sun, 02 Jun 2024 21:29:03 -0700 (PDT)
Received: from [192.168.0.4] (ip-109-43-176-229.web.vodafone.de. [109.43.176.229])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35e535567e9sm3253302f8f.21.2024.06.02.21.29.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Jun 2024 21:29:03 -0700 (PDT)
Message-ID: <5a2f4d2d-6e8e-4009-a9e3-e9f51cb8aa20@redhat.com>
Date: Mon, 3 Jun 2024 06:29:01 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 4/4] gitlab-ci: Always save artifacts
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org
References: <20240602122559.118345-1-npiggin@gmail.com>
 <20240602122559.118345-5-npiggin@gmail.com>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240602122559.118345-5-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/06/2024 14.25, Nicholas Piggin wrote:
> The unit test logs are important to have when a test fails so
> mark these as always save.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   .gitlab-ci.yml | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> index 23bb69e24..c58dcc46c 100644
> --- a/.gitlab-ci.yml
> +++ b/.gitlab-ci.yml
> @@ -4,14 +4,19 @@ before_script:
>    - dnf update -y
>    - dnf install -y make python
>   
> +# Always save logs even for build failure, because the tests are actually
> +# run as part of the test step (because there is little need for an
> +# additional build step.
>   .intree_template:
>    artifacts:
> +  when: always
>     expire_in: 2 days
>     paths:
>      - logs
>   
>   .outoftree_template:
>    artifacts:
> +  when: always
>     expire_in: 2 days
>     paths:
>      - build/logs

Reviewed-by: Thomas Huth <thuth@redhat.com>


