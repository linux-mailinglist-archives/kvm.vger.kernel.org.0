Return-Path: <kvm+bounces-2475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AA5C77F983C
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 05:22:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC9B01C20845
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 04:22:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B54B53A5;
	Mon, 27 Nov 2023 04:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hSmXNFgK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E529F0
	for <kvm@vger.kernel.org>; Sun, 26 Nov 2023 20:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701058927;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/nhwhp1t2bW5Fo7bLOGwpFSKPeOVuScueoe5eRS0QQw=;
	b=hSmXNFgKzNTKWu+ySKTjOfgvZ9sRGx88w/QyCoWZ8v8vwUJ7BiiqBXSwCLgNJ1x9YtSWdV
	H5jYhXZB6DmGn/ABuCoiSjzyj7sekQ5Mr6ZqbALO9NJk90NiJr6MfAYzD1Sh3FZGaB1MV6
	/igEV6DNGZVwSuGv7/JrKC6GtSCoSHw=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-5aagSRbvMXWAD4uDx9TR1g-1; Sun, 26 Nov 2023 23:22:05 -0500
X-MC-Unique: 5aagSRbvMXWAD4uDx9TR1g-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1cfcf1e9442so6684785ad.3
        for <kvm@vger.kernel.org>; Sun, 26 Nov 2023 20:22:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701058924; x=1701663724;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/nhwhp1t2bW5Fo7bLOGwpFSKPeOVuScueoe5eRS0QQw=;
        b=E3ugrucDGTQdkb9na7gd3u5SUpw/B8VG+5CwgetuRL92Ny62ROjoMmHAzncdIX/f5r
         bHw+9nYpuCfZePPckjKwsCgK4bVZNe8GQr6jA4p0NZ1t62xcvZho8sCzugf4jWtDh3fT
         hwbl7RBQ/gKg4LqG7GQ1aIDC/iUdE/ppxUL8iUrOqbthP/1V3woQ1Dl3AVKei2Ke3uot
         I86t2pR7dOwLxF9EBfkk2GxE87gHvlumM704qnhSGZJZPn7PMDQZsrwPo9q7Sb4oUdMB
         44ZYMuOuTeqai9v8fbvjrrFnTipiXfaUS429WCHjmTTGQ8XTNqkBox5yp1UDlMsfkO0M
         KLqQ==
X-Gm-Message-State: AOJu0Yw8fjt6zHAVMtHNYUeC0qTp+I9H/v7Ie7CkIe9ay5vOoFLl1c1q
	RALarXzx82fU3uBwCXJLcFzSafZ0aiyzcTN3mxGzhj/6nMkZ+nfA4xIn791qGEfSWaN/+29w2h3
	+v+bG+Cnc7Prj
X-Received: by 2002:a17:902:9898:b0:1cf:cf43:303a with SMTP id s24-20020a170902989800b001cfcf43303amr1786947plp.64.1701058924751;
        Sun, 26 Nov 2023 20:22:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGahJzPVW6qpzOig4IomRFqNt413I5D7KdVsB5RNKfQL4bunCVAFvR+or0fMFWGg+/2zvnFtQ==
X-Received: by 2002:a17:902:9898:b0:1cf:cf43:303a with SMTP id s24-20020a170902989800b001cfcf43303amr1786940plp.64.1701058924515;
        Sun, 26 Nov 2023 20:22:04 -0800 (PST)
Received: from [192.168.68.51] ([43.252.115.3])
        by smtp.gmail.com with ESMTPSA id q8-20020a17090311c800b001cf57ea953csm7140277plh.290.2023.11.26.20.22.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Nov 2023 20:22:04 -0800 (PST)
Message-ID: <6d1cdfc7-803f-438f-b210-1eddb34aeba7@redhat.com>
Date: Mon, 27 Nov 2023 15:21:59 +1100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-for-9.0 09/16] target/arm/kvm: Have kvm_arm_pmu_set_irq
 take a ARMCPU argument
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
References: <20231123183518.64569-1-philmd@linaro.org>
 <20231123183518.64569-10-philmd@linaro.org>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20231123183518.64569-10-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 11/24/23 05:35, Philippe Mathieu-Daudé wrote:
> Unify the "kvm_arm.h" API: All functions related to ARM vCPUs
> take a ARMCPU* argument. Use the CPU() QOM cast macro When
> calling the generic vCPU API from "sysemu/kvm.h".
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   target/arm/kvm_arm.h | 4 ++--
>   hw/arm/virt.c        | 2 +-
>   target/arm/kvm.c     | 6 +++---
>   3 files changed, 6 insertions(+), 6 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


