Return-Path: <kvm+bounces-2477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E67E17F9849
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 05:26:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A356D280D9C
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 04:26:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC8AB53BA;
	Mon, 27 Nov 2023 04:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PB3rrbDh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ABB8D7
	for <kvm@vger.kernel.org>; Sun, 26 Nov 2023 20:26:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701059201;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sZZnkvSfitGisLGL04wWrdlz4T2wKJDLQwGw8KJBvFg=;
	b=PB3rrbDhFhAYGJu1tpDRetEJdZ4RPIsc2foTm4wermkzhGFhv28rcQ+pkcLhc5FfQMPOs8
	CqP2SgElbzfFRyVr3x+t3QJzMiLKPZulmibAbKLwr3e3hx3tkvLVVaeRN9qejPFhZqwvYQ
	uAC1kqYpmpygcG50ppHxzZiWfQ7qW+E=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-183--qvc9YySOSuwY2qzwDp-JQ-1; Sun, 26 Nov 2023 23:26:40 -0500
X-MC-Unique: -qvc9YySOSuwY2qzwDp-JQ-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-6cb9dd2ab9cso3858221b3a.3
        for <kvm@vger.kernel.org>; Sun, 26 Nov 2023 20:26:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701059199; x=1701663999;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sZZnkvSfitGisLGL04wWrdlz4T2wKJDLQwGw8KJBvFg=;
        b=Ij/IcKAQvv46oGQxz587OIZYeMELtJIAAuNUU4Uo6Dudm5bL4maUYkaxyiK7/m47k9
         YHsmiQYXi0yFEEChfdQjIdX1+rL+J2VWtrsX6E7wtlNwSB4Hi95Fhm+b3e/3aK1dGIvD
         f8JErueL+zznjAezqHmOsx94WROUrGDd7dJitfEAFLU4H6Y1UWvapVN0Wn/K+hG0DTCg
         GwN3EnX+IeTwifCt6oB0fVlsqagvsZ4E8H+aUFDRRt0DwmWPtE0LGe7bcefbYzegKMUI
         OZU/iCUdRzcgIqRGD+UwtT0a+7BjyYuYX+1N2XqBj1Ut1KYhR/FqYGzZQ8kjDIMBIh/3
         XEDQ==
X-Gm-Message-State: AOJu0YxGefC1ZuBy25bE6gI7DZoKWEJf4ePkxZGI/MPuMuYwzWVQfHvE
	T6eKKuamEUZrKNwxhaNyFZtOXj5CutA6r+uImVQSeopggK+dV93RczDNcOHFCcC1HzwMfhMJ219
	FegCxsIC/UmpZG/OJFjmC
X-Received: by 2002:aa7:9a87:0:b0:6bb:8982:411c with SMTP id x7-20020aa79a87000000b006bb8982411cmr9200721pfi.8.1701059198887;
        Sun, 26 Nov 2023 20:26:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFlQgLBRj9RDgY8/fOQHANXpbPnRJoIpEX3kwfRAw85G15nRnOlWbfc823/LeAaCBRyIjGsDQ==
X-Received: by 2002:aa7:9a87:0:b0:6bb:8982:411c with SMTP id x7-20020aa79a87000000b006bb8982411cmr9200711pfi.8.1701059198624;
        Sun, 26 Nov 2023 20:26:38 -0800 (PST)
Received: from [192.168.68.51] ([43.252.115.3])
        by smtp.gmail.com with ESMTPSA id m22-20020aa78a16000000b00692cb1224casm6337813pfa.183.2023.11.26.20.26.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Nov 2023 20:26:38 -0800 (PST)
Message-ID: <a803c70b-319b-4b32-b0f5-fbe5723d33fe@redhat.com>
Date: Mon, 27 Nov 2023 15:26:35 +1100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-for-9.0 11/16] target/arm/kvm: Have kvm_arm_vcpu_finalize
 take a ARMCPU argument
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
References: <20231123183518.64569-1-philmd@linaro.org>
 <20231123183518.64569-12-philmd@linaro.org>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20231123183518.64569-12-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/24/23 05:35, Philippe Mathieu-Daudé wrote:
> Unify the "kvm_arm.h" API: All functions related to ARM vCPUs
> take a ARMCPU* argument. Use the CPU() QOM cast macro When
> calling the generic vCPU API from "sysemu/kvm.h".
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   target/arm/kvm.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


