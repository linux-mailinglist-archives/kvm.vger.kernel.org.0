Return-Path: <kvm+bounces-2478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E5F9D7F984C
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 05:27:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1FCC51C208CE
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 04:27:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 519F45695;
	Mon, 27 Nov 2023 04:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BxY9b3s5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9713CD7
	for <kvm@vger.kernel.org>; Sun, 26 Nov 2023 20:27:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701059268;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bzPDIBNHl9MOltvsq0mdaA199GFM+p4KPfAkED3jE+o=;
	b=BxY9b3s5PWNLthscGOpW3SKRGWj32qNEJ2Ja14KsM1Dkze+OjSEGXtOswErwcarLB6VaMN
	Iz/UL5seoJPbNUySWlZB3MZ9JkHOBewhuNyJKM0gtEfKmbnMf59wFIgRdFJemxGWHfgHDQ
	hXr4jS/C9Eg9PAEKgkDELKt/upmeK3o=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-311-Nx6aeQkHPi6SzIw_6ikZYQ-1; Sun, 26 Nov 2023 23:25:53 -0500
X-MC-Unique: Nx6aeQkHPi6SzIw_6ikZYQ-1
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-6cbe0378d0eso5412418b3a.3
        for <kvm@vger.kernel.org>; Sun, 26 Nov 2023 20:25:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701059152; x=1701663952;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bzPDIBNHl9MOltvsq0mdaA199GFM+p4KPfAkED3jE+o=;
        b=WoMDkMDvf3v6qJDOPVSzzdbJsrf8CAt2nTzqwC8mbjIshFdR/K7auZaqAa8mPiRy1L
         g0xL42HNHX4+VFndJHMmWediMhNvHPUeW5HuAj0KmVZZ7NaoA4OTWKa/xxn8Z4hCjDK/
         fxyjX31HdOn8XsQmJIJh3eb6RySwm+1ymWUpC6KRL2w5dbGk/54Xpx2NUd75cPxBG5n5
         4qe0xugDt3qrQGrKW6fDFsIV3xjdLULkplYaoAHOO9hijsLV3XTg2GjRqvEeZ/367/Az
         HXzBR+8vQiMQWD1piMGmawty+VXnpu9PgbntW2r7i7Sqdr6VWF8JlIWEbkdA+icMUWvB
         G1OA==
X-Gm-Message-State: AOJu0Yx8pwvOX8KT9FLMz7NnlrnFX6razDWzwwPnbohxbB69nZaQo3zk
	n1HSXPZfWQVYnPFcaotPeEa1EN8Lctz1h9Mz/uN28HzP6SoEDsLtDKZpLivzILDcQrz4d7bIqTF
	l7ThrDdMNSTxs
X-Received: by 2002:a05:6a00:1954:b0:6cb:a1a7:ebcb with SMTP id s20-20020a056a00195400b006cba1a7ebcbmr12097189pfk.24.1701059152475;
        Sun, 26 Nov 2023 20:25:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG7TqBPaWtSSs4ZG1kEaauKKpfqg5/Oebaw7t4bdNhyTq4NWkMHt64BocUMBw9TSsYImE2nsQ==
X-Received: by 2002:a05:6a00:1954:b0:6cb:a1a7:ebcb with SMTP id s20-20020a056a00195400b006cba1a7ebcbmr12097178pfk.24.1701059152198;
        Sun, 26 Nov 2023 20:25:52 -0800 (PST)
Received: from [192.168.68.51] ([43.252.115.3])
        by smtp.gmail.com with ESMTPSA id m22-20020aa78a16000000b00692cb1224casm6337813pfa.183.2023.11.26.20.25.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Nov 2023 20:25:51 -0800 (PST)
Message-ID: <e9b5be52-fd68-4152-b7c0-b75772dfded8@redhat.com>
Date: Mon, 27 Nov 2023 15:25:49 +1100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-for-9.0 10/16] target/arm/kvm: Have kvm_arm_vcpu_init take
 a ARMCPU argument
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
References: <20231123183518.64569-1-philmd@linaro.org>
 <20231123183518.64569-11-philmd@linaro.org>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20231123183518.64569-11-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 11/24/23 05:35, Philippe Mathieu-Daudé wrote:
> Unify the "kvm_arm.h" API: All functions related to ARM vCPUs
> take a ARMCPU* argument. Use the CPU() QOM cast macro When
> calling the generic vCPU API from "sysemu/kvm.h".
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   target/arm/kvm.c | 11 +++++------
>   1 file changed, 5 insertions(+), 6 deletions(-)
>

Reviewed-by: Gavin Shan <gshan@redhat.com>


