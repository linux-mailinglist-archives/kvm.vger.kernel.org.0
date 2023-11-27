Return-Path: <kvm+bounces-2473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BD437F982D
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 05:16:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9C82BB20B1D
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 04:16:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21A9B539D;
	Mon, 27 Nov 2023 04:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RCnIZNgq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F2612F
	for <kvm@vger.kernel.org>; Sun, 26 Nov 2023 20:15:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701058553;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ix+WFitJBKrcF/nyD03YVJLz7HUVFgt2C1pUAXyakXI=;
	b=RCnIZNgqpwrxldb2jg1oOojXjt+FH7RkTEcZbR1MKBJ4mK/4vj2djfC2OfPYjtyy5dTvzd
	oIQj9Enlz6MNY47PgPwBThIeBW/17wBOTZHBeiV0LNSU5tsFCWxyOvJwz8UnIRNdHnxCvo
	FgpJY7AFteXo0247vxbUc8bnzjtC0Nk=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-64-jI9qI_ANPTGSTJN9Blxp-A-1; Sun, 26 Nov 2023 23:15:52 -0500
X-MC-Unique: jI9qI_ANPTGSTJN9Blxp-A-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1cfccc9d6bcso8205855ad.2
        for <kvm@vger.kernel.org>; Sun, 26 Nov 2023 20:15:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701058551; x=1701663351;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ix+WFitJBKrcF/nyD03YVJLz7HUVFgt2C1pUAXyakXI=;
        b=mmk7l89hT1zNydrT88eZzQbGldgEi5+lMyn+33qvsDvFBVZuOQ5yPlDN2+sh9Beg6p
         siuoVHlyqinDrOWzz2RJxARk9CKZInLVPe4tCAw4vIHakndhGFyrR5gtVlgcVxOeR2jp
         34resKWMBQRTAaJfBWrCIJeHWJWqXmqg6RRYlBLn711AwpFomPvxhPw7Pmda2QXtI4Pf
         h3FhftOkrSoUloBEOZR0Wd9byBNq59+veHjnc5g83NnD1+31fhwIDH7l3IGIi10mf9xM
         kRTLHcz5qA2Wp6aE04blwCxvT9gh52ZGUoZW7xzB0ct+fBLg0otpRa1llvI1P04CZuea
         N0XQ==
X-Gm-Message-State: AOJu0YwLWXk31P/AmwaB1ytVv3MITe0gcOtagIz5hw5zVNJ7MPqoAxpF
	qP/nNT1oryEKATgRNQdMOfu4jPcmttd/VdKzanhHyeVdzQN6ciRkdNjeUp1x5QO4bGq11fIAA+N
	al3tso6GNYMRl
X-Received: by 2002:a17:902:a40c:b0:1c2:1068:1f4f with SMTP id p12-20020a170902a40c00b001c210681f4fmr9100553plq.17.1701058550983;
        Sun, 26 Nov 2023 20:15:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFQEtKOXmahElKlwsOEf/KkC0jUwnXDQHbFbZNS6QwNnoBZSsph81FBVz5o3u0PGJ+ks8tPFQ==
X-Received: by 2002:a17:902:a40c:b0:1c2:1068:1f4f with SMTP id p12-20020a170902a40c00b001c210681f4fmr9100544plq.17.1701058550740;
        Sun, 26 Nov 2023 20:15:50 -0800 (PST)
Received: from [192.168.68.51] ([43.252.115.3])
        by smtp.gmail.com with ESMTPSA id iy13-20020a170903130d00b001cfcf0fcc56sm813882plb.84.2023.11.26.20.15.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Nov 2023 20:15:50 -0800 (PST)
Message-ID: <427f87fb-7e10-492f-9a5e-0e5f1a111dc2@redhat.com>
Date: Mon, 27 Nov 2023 15:15:46 +1100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-for-9.0 07/16] target/arm/kvm: Have kvm_arm_pvtime_init
 take a ARMCPU argument
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
References: <20231123183518.64569-1-philmd@linaro.org>
 <20231123183518.64569-8-philmd@linaro.org>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20231123183518.64569-8-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/24/23 05:35, Philippe Mathieu-Daudé wrote:
> Unify the "kvm_arm.h" API: All functions related to ARM vCPUs
> take a ARMCPU* argument. Use the CPU() QOM cast macro When
> calling the generic vCPU API from "sysemu/kvm.h".
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   target/arm/kvm_arm.h | 6 +++---
>   hw/arm/virt.c        | 5 +++--
>   target/arm/kvm.c     | 6 +++---
>   3 files changed, 9 insertions(+), 8 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


