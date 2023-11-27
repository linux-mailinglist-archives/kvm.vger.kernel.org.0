Return-Path: <kvm+bounces-2479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CBF57F984F
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 05:29:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BAB36280E42
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 04:29:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E5C75663;
	Mon, 27 Nov 2023 04:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IFpaxsy/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37CA0111
	for <kvm@vger.kernel.org>; Sun, 26 Nov 2023 20:29:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701059355;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uTJbdB49WbhT9nfFscdktMnYs7K7t3F10x3+Dyunhh4=;
	b=IFpaxsy/aG5sgGVk0na5PTXxDUp04JAnXu1Xt+HFTBqM0ZYZWqjHSWAWo28HbB02P5SnvZ
	WQxgUWi+8v7ENBL1DZ4Up+aG8C2P6woEE78pFXT+pCGSwcLCYd5IDyvffHnyIbCFkrHwNv
	goZhSWxJvC1Xun7UiWLYi+T20PNgFgM=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-127-SuMJLV_-OLG72USQ6YEi9A-1; Sun, 26 Nov 2023 23:29:13 -0500
X-MC-Unique: SuMJLV_-OLG72USQ6YEi9A-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1cfb5471cd4so14085355ad.3
        for <kvm@vger.kernel.org>; Sun, 26 Nov 2023 20:29:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701059352; x=1701664152;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uTJbdB49WbhT9nfFscdktMnYs7K7t3F10x3+Dyunhh4=;
        b=QrBi+g+cCtV6ygzT1hoO5jSKi93UYYF+kRiYDQgXKQ69pLon89Jr3ZhUmC9PQf5xjt
         8V2u3wdKAqY1ebZoF3Y5Cl3AZTb8NCPNnRhJRtwAmKCNUSdOuV3OR5KHQ5ARPxG4VHp5
         y3uFXo5dYRRu5r7t8BOpz3CO5D6wegjo07JIDE8KlGR5H6JhHifodiv8vw3Hz6y/Ull0
         apGwdKGUS1o6MSUErMxC08tkQMYt+a+xm9odcoHWHYpQqTRcF7HRZaD9HioAdgckH9fv
         vf4FyI6zSDP1V/AYlHnpeq8nTrEc89+oO8ufhkVyQ4B0GodKS2Slk8Jn+wgYKlVtXxL6
         tEgQ==
X-Gm-Message-State: AOJu0YwbA5eSlkfKf3ZK3j5Ah7vVP9Hl0zRPqZBF01ESAfWlyToRBL41
	fceNuo9HA+xjBrj3flsukzGPIejXVCvVN8M/FRmS7Djp3exrLYX5gcWiBc0miEOnZkKPrMfPueW
	of0GiIOMWd/k0
X-Received: by 2002:a17:903:1103:b0:1cf:6e3d:d8e7 with SMTP id n3-20020a170903110300b001cf6e3dd8e7mr10024129plh.26.1701059352691;
        Sun, 26 Nov 2023 20:29:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IERZHHf3LS1imT3NzFS6So6tgu6CEywhSiCJc5JsehQXTfkdDQsDnilQIZZdU3hKcUBHkXwAQ==
X-Received: by 2002:a17:903:1103:b0:1cf:6e3d:d8e7 with SMTP id n3-20020a170903110300b001cf6e3dd8e7mr10024114plh.26.1701059352408;
        Sun, 26 Nov 2023 20:29:12 -0800 (PST)
Received: from [192.168.68.51] ([43.252.115.3])
        by smtp.gmail.com with ESMTPSA id x17-20020a170902ea9100b001c5fd2a28d3sm7196296plb.28.2023.11.26.20.29.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Nov 2023 20:29:12 -0800 (PST)
Message-ID: <68fd2489-4eda-4cc5-abb9-923511475e37@redhat.com>
Date: Mon, 27 Nov 2023 15:29:08 +1100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-for-9.0 12/16] target/arm/kvm: Have
 kvm_arm_[get|put]_virtual_time take ARMCPU argument
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
References: <20231123183518.64569-1-philmd@linaro.org>
 <20231123183518.64569-13-philmd@linaro.org>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20231123183518.64569-13-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/24/23 05:35, Philippe Mathieu-Daudé wrote:
> Unify the "kvm_arm.h" API: All functions related to ARM vCPUs
> take a ARMCPU* argument. Use the CPU() QOM cast macro When
> calling the generic vCPU API from "sysemu/kvm.h".
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   target/arm/kvm.c | 23 ++++++++++-------------
>   1 file changed, 10 insertions(+), 13 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


