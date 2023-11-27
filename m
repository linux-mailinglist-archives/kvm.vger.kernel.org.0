Return-Path: <kvm+bounces-2470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B9037F9824
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 05:07:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B3CF1C2089B
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 04:07:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C78D25382;
	Mon, 27 Nov 2023 04:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dKnmJSXy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD85E8
	for <kvm@vger.kernel.org>; Sun, 26 Nov 2023 20:07:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701058061;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uOi5ccQjIN+8+wBdKqclzhUw5sb2VuINIekNHHuIl1I=;
	b=dKnmJSXyes823TfATwR0WRtgmKZYtmNUrcr9xB0oLZzWV1xVZii1TLUbEmacP+OC4wFXYw
	2DxwQnDK9ebjgHHVvPkzV3AR8gKE/U8g58H6mRZjntEybiLycgq6mOZ4Hv4CIsqWz5tQ6C
	7mA9aJMHvBbYLXOQ4FNLPk0Ws2YIoj4=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-342-UYChvTTcM--Ss08wPbMtZg-1; Sun, 26 Nov 2023 23:07:40 -0500
X-MC-Unique: UYChvTTcM--Ss08wPbMtZg-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1cfba9f385aso20723675ad.0
        for <kvm@vger.kernel.org>; Sun, 26 Nov 2023 20:07:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701058053; x=1701662853;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uOi5ccQjIN+8+wBdKqclzhUw5sb2VuINIekNHHuIl1I=;
        b=qXgBMEAFx7aH/71BlrGxVtXdGJynAJkBNXp4Wi8UgNkcZbBHQ+prdB1XfV7mbRZYLr
         PmSaYdlSC0qipysPqMX16pNRvrKTON1ckMC832RbOIFLo6hlNFd7Wea8XJjPPb56n49q
         O+TA73IhfQ5AO6ERVof6e3zyV4CGwaMMLhcl5r1qAnhn1aXiqnRC4sMUMEfuDAJB0vh6
         iFFT6aILaT1DVjaFsl4PNYDtWQPqxda/4950pYXPNwUL11rFt9XdWpEkLPPdig3y3vZS
         JDbpbeqMElMUfctQGOHtbTTBO31hp0vmJlHVrcAGy+1nwhZabFAOQbtzm4da/8vbQVe6
         Webg==
X-Gm-Message-State: AOJu0Ywb3NiIjB7IJnXhL/uSznBNvLByFrNYiGhRBctbYJD1Is9pS0ca
	5tMb+4KMV5eooNn8L5u0KIoqWM6bhexIIfv+HHZD0XE5Fml0NQanpwueQP+kuEvYpgQl8W99Hy3
	RCGxBxwSjNEBBXJhYIlxz
X-Received: by 2002:a17:903:244a:b0:1cf:c5db:937b with SMTP id l10-20020a170903244a00b001cfc5db937bmr4165720pls.48.1701058053728;
        Sun, 26 Nov 2023 20:07:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFZK7Av/oWrQ1aHTNBng5X3UsNOGXA30E0ptW5ZlFWWcYgduTkddUD9Y/7/tYVmYpU3MYg/JQ==
X-Received: by 2002:a17:903:244a:b0:1cf:c5db:937b with SMTP id l10-20020a170903244a00b001cfc5db937bmr4165699pls.48.1701058053473;
        Sun, 26 Nov 2023 20:07:33 -0800 (PST)
Received: from [192.168.68.51] ([43.252.115.3])
        by smtp.gmail.com with ESMTPSA id d14-20020a170902728e00b001cfd2c76338sm489163pll.197.2023.11.26.20.07.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Nov 2023 20:07:33 -0800 (PST)
Message-ID: <215ac168-2717-499c-91b3-a2fb01e636f5@redhat.com>
Date: Mon, 27 Nov 2023 15:07:28 +1100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-for-9.0 04/16] target/arm/kvm: Have kvm_arm_sve_set_vls
 take a ARMCPU argument
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
References: <20231123183518.64569-1-philmd@linaro.org>
 <20231123183518.64569-5-philmd@linaro.org>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20231123183518.64569-5-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/24/23 05:35, Philippe Mathieu-Daudé wrote:
> Unify the "kvm_arm.h" API: All functions related to ARM vCPUs
> take a ARMCPU* argument. Use the CPU() QOM cast macro When
> calling the generic vCPU API from "sysemu/kvm.h".
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   target/arm/kvm.c | 7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


