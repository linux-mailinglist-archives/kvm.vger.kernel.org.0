Return-Path: <kvm+bounces-20141-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BC13910E3A
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 19:15:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 74887B255E5
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 17:15:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1DCE1B3F11;
	Thu, 20 Jun 2024 17:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P5A7J6Nr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865AE1ABCB1
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 17:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718903716; cv=none; b=HkKgTJImQWxu3HN+FP431H8GUSh9i66YVczWuJUWycf9p34VvAnmW4DjVY15Jms6i9+WZnJdPankYuNl/72WLbM4hkv6O0mISdLRHqMdsKXqALoYk2bYuVcgQezXKu8XubMJNSuknSOGdpE/3GNawvqMEUgXm84np75H6jxNBUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718903716; c=relaxed/simple;
	bh=p5Z9xReJQK1bktUDN5hS8GFAnY/f61qWwr6AQ76v6Rg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KaBeJNF1JxcogUFr3U3gTdCjHhOSXpmMg72tbVDpeSwT/ad/nfvnW1hdDEN25uK6N4J0GgMVEGlSBQpTqJsU8nYJ0UT6PHpRdCav3Ep85ry6gmD96tgmyJPhQoqpm+7RcrXF+oRdkTu+CnbNyu9gMvb+oI+wZK9RPLEFPzS3sSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P5A7J6Nr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718903713;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cvReVOaxMOcLfFk/GJhrVgAzazDhgpmW/4bz55GggPg=;
	b=P5A7J6NrLCJCKWVEQiPDPUn0gBvhQHKWXgQL9BR2opeteRiaev7Iy3lOyieo3Ze7ld/Nbc
	HOk6rL5SI14NV+YTcKxFtKC0VOLcPuQw29k4si6Fyrexf8RxMk1aHaLqIs9j1ZmGGT2lmk
	gpt+vi3xbyooCewR8XJIDQpEkEYBWBM=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-687-tHv6jswROZSmULsIMAqi9Q-1; Thu, 20 Jun 2024 13:15:12 -0400
X-MC-Unique: tHv6jswROZSmULsIMAqi9Q-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a6efbb08949so47872666b.0
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 10:15:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718903711; x=1719508511;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cvReVOaxMOcLfFk/GJhrVgAzazDhgpmW/4bz55GggPg=;
        b=NZcnliYokeN4uGFRjvGTeSSp1+Hsq77KjVp1oIbp19RFQgwpibQeExgsE203V/Hbq0
         htMoNir1zgfj07L19Nnv/NFxMfHlk9YUGRO2ok5+/zBIknglFWZpXkEoNQ/Tz9GD5p0w
         0YW9lANB8XDPfnomBiPvlBy21Gn39mL0fASJfdXayzu0PpoYkIY3TSd/3ElLYvc/84lq
         Qb7tr4PkdFfR2/SegNePOLODKP1625LS294c6Sz0lGxpchJ2oCSd+8XegBIIHjhgTSV8
         gg84VWqN0fBYylLhqRj4/hBRYDSuiiy4XYZ2/83phcRElpCftPJvr3yoHGk72CrOnlVB
         owmQ==
X-Forwarded-Encrypted: i=1; AJvYcCX4MVCLbldCRSyu4GaQHgO6tdS08op6vlodAUB5Y/WBtuuD8sO83rxIPYXJetJhyjcjIgYZnLxaAOqChtDt+JO+WGCh
X-Gm-Message-State: AOJu0YyM1cMcJvX0QXmpky+oMk4Jl8gxs6Kq2AdEX8Ja/t0q0/ZNWQi4
	l46J3Sw6qjFulhNMWQMW3RMp3Civv8uctaZ7T8if6nrNZ25ZdsgONExjE+j1XtBxhVXZWWBTPGZ
	lg31WuBxfiO8lXBdATnC2JMaQXZcIsuV0vvrCCd0EqTOPq7Vkkw==
X-Received: by 2002:a17:906:f902:b0:a6e:feb5:148e with SMTP id a640c23a62f3a-a6fab6171f0mr366335066b.27.1718903711115;
        Thu, 20 Jun 2024 10:15:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFPyXpnNY0SyWO4sHYdLq8eNHEnBVH/phU7MM9RicdojSub3BCzlw01liWp7UGPuWd3dgQQKA==
X-Received: by 2002:a17:906:f902:b0:a6e:feb5:148e with SMTP id a640c23a62f3a-a6fab6171f0mr366332666b.27.1718903710718;
        Thu, 20 Jun 2024 10:15:10 -0700 (PDT)
Received: from [192.168.0.4] (ip-109-43-178-117.web.vodafone.de. [109.43.178.117])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f57b5e7b2sm782086066b.68.2024.06.20.10.15.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jun 2024 10:15:10 -0700 (PDT)
Message-ID: <de6a283f-7da8-4d2f-b2ea-9a3c12e754e4@redhat.com>
Date: Thu, 20 Jun 2024 19:15:08 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/12] plugins: add migration blocker
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 qemu-ppc@nongnu.org, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Jamie Iles <quic_jiles@quicinc.com>,
 David Hildenbrand <david@redhat.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Mark Burton <mburton@qti.qualcomm.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>, qemu-arm@nongnu.org,
 Laurent Vivier <lvivier@redhat.com>, Alexander Graf <agraf@csgraf.de>,
 Ilya Leoshkevich <iii@linux.ibm.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Marco Liebel <mliebel@qti.qualcomm.com>, Halil Pasic <pasic@linux.ibm.com>,
 qemu-s390x@nongnu.org, Cameron Esfahani <dirty@apple.com>,
 Alexandre Iooss <erdnaxe@crans.org>, Nicholas Piggin <npiggin@gmail.com>,
 Roman Bolshakov <rbolshakov@ddn.com>,
 "Dr. David Alan Gilbert" <dave@treblig.org>,
 Marcelo Tosatti <mtosatti@redhat.com>,
 Mahmoud Mandour <ma.mandourr@gmail.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20240620152220.2192768-1-alex.bennee@linaro.org>
 <20240620152220.2192768-10-alex.bennee@linaro.org>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240620152220.2192768-10-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 20/06/2024 17.22, Alex Bennée wrote:
> If the plugin in controlling time there is some state that might be
> missing from the plugin tracking it. Migration is unlikely to work in
> this case so lets put a migration blocker in to let the user know if
> they try.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> Suggested-by: "Dr. David Alan Gilbert" <dave@treblig.org>
> ---
>   plugins/api.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/plugins/api.c b/plugins/api.c
> index 4431a0ea7e..c4239153af 100644
> --- a/plugins/api.c
> +++ b/plugins/api.c
> @@ -47,6 +47,8 @@
>   #include "disas/disas.h"
>   #include "plugin.h"
>   #ifndef CONFIG_USER_ONLY
> +#include "qapi/error.h"
> +#include "migration/blocker.h"
>   #include "exec/ram_addr.h"
>   #include "qemu/plugin-memory.h"
>   #include "hw/boards.h"
> @@ -589,11 +591,17 @@ uint64_t qemu_plugin_u64_sum(qemu_plugin_u64 entry)
>    * Time control
>    */
>   static bool has_control;
> +Error *migration_blocker;
>   
>   const void *qemu_plugin_request_time_control(void)
>   {
>       if (!has_control) {
>           has_control = true;
> +#ifdef CONFIG_SOFTMMU
> +        error_setg(&migration_blocker,
> +                   "TCG plugin time control does not support migration");
> +        migrate_add_blocker(&migration_blocker, NULL);
> +#endif
>           return &has_control;
>       }
>       return NULL;

Reviewed-by: Thomas Huth <thuth@redhat.com>


