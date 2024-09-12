Return-Path: <kvm+bounces-26665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5598C9763D2
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 10:02:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5F8411C20AE1
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 08:02:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92CA618DF9B;
	Thu, 12 Sep 2024 08:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NN/9nE8I"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91EEA126C18
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 08:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726128166; cv=none; b=kosiUNk32Q+wWf+0EcSYQkaEE+MfLQi1UGSn3Kq3ZENCQxh3mXlB+HhNxiecCqedmP5eNcOCM3cqULA7vRpYW2/5h2uiR6sTX92gBR8BWtPJgpDDmnlDpx0rY7ps1OPQ+rlq9qeWRCXFZq2GS5l7XoAFjVFM6BXFBEuxKjfY1zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726128166; c=relaxed/simple;
	bh=Oi3FJRkPNYKycmUZm9towbpHpMZOAL+lTSh6x8lAauE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fjik87hISyqQPdgqoTD2jC5PVGSL3CIDaPhvCPmYqlyeqaOB+jGCfOIkKoiaIUfFC2fxlz2e1NOl3VmH1kpzy2Ia+g2dmnYd6o5BRZrk0cHFn1446RXCR81tqwIE/pDgdR7hVCn0fwEgSj4RrZyDq6dtUZjhQ7I1KVuYbTQQHsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NN/9nE8I; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726128163;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZJCCBAsy1yjL6s99J+14imn5GBc215lIAHWntNhCiQ4=;
	b=NN/9nE8IYophqsUeaKc67tZP7tH7K5OGQpsBVOOwSK3SDRwjfgHEmWg0F8rvK/RKZEdjed
	H+vQAB/lNwOM/J8wfEul16oy534P1Ug9OFU7EXj6iYanqpF61GyzUapsiJYgqJh9CBT+vm
	o07XH/s8zGs5+MQn/eXGrlhm/BiemA8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-647-ecBWDYq8PTmDZe5c088npQ-1; Thu, 12 Sep 2024 04:02:41 -0400
X-MC-Unique: ecBWDYq8PTmDZe5c088npQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-42ac185e26cso4834195e9.3
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 01:02:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726128160; x=1726732960;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZJCCBAsy1yjL6s99J+14imn5GBc215lIAHWntNhCiQ4=;
        b=CcrlPAddnM0uNPR0pCiV0zKu2vLP+SH4ahURB7yjRHMe6GKb3Km94VUunQtHIzNKa9
         s7q0CMbLi2ZZzL76MUnhVA4/zCnXRxu25T3yCfAZC02clb5+IPf7NCcVdx+oSoWlKS1+
         wgwWKE+FTXd2hN8ccb4EuMipB778clemnmoChi9tc3Gf+Rfn9SJY335E0l0wyiJWgITE
         kmYhnwujXHyiskzQFH74Zq1XpeAmh5HLQAV4BNzlYevL7sHbfb9kT3XJ7p6jPJKsf4nQ
         6DLg43Z4AuKEO49OPBX5gIOl156aHVb0KHQ0uKfFGcKDylVhy+CsT2iAOGQPaASeTeR0
         euIg==
X-Forwarded-Encrypted: i=1; AJvYcCUyqZGacAi5XbrNd7JH7mrGhzNsMplDmiQ+kCoiItongIaDHlRWnd9Dzbf6qTuWuLVlXMU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzA5mPPZj1w6B1Y5F1sF4BDoKgbaHg06WyrTyWIthjKS7ICKB1
	C6ThRCKdQpI2SF9yrndC5qvhY9M7J9SBVBLa4yKKjWL1i7HP20WA+E47VfEOJUUvKfazp+j25sG
	7E1c3+6gqTuYO4D7lGjzm7QmAUJTFAN46iycFC3UwBQZUnYIWrQ==
X-Received: by 2002:a05:600c:511d:b0:42c:b62c:9f36 with SMTP id 5b1f17b1804b1-42cdb5389e4mr14181145e9.5.1726128159719;
        Thu, 12 Sep 2024 01:02:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEON90/FK9z91xoz/hl8qQv4UdLOeyoldJa5DD3joRha0AcFsGOMu+tz57qR5UM1pH1Hmui2w==
X-Received: by 2002:a05:600c:511d:b0:42c:b62c:9f36 with SMTP id 5b1f17b1804b1-42cdb5389e4mr14180635e9.5.1726128159137;
        Thu, 12 Sep 2024 01:02:39 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:9db0:474c:ff43:9f5c? ([2a01:e0a:280:24f0:9db0:474c:ff43:9f5c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42caeb32678sm163754975e9.16.2024.09.12.01.02.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Sep 2024 01:02:38 -0700 (PDT)
Message-ID: <fdd3f261-c2a5-49a7-b8ef-3e99287a0921@redhat.com>
Date: Thu, 12 Sep 2024 10:02:30 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 43/48] hw/ppc: remove return after
 g_assert_not_reached()
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Jason Wang <jasowang@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, Laurent Vivier <lvivier@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, Nicholas Piggin <npiggin@gmail.com>,
 Klaus Jensen <its@irrelevant.dk>, WANG Xuerui <git@xen0n.name>,
 Halil Pasic <pasic@linux.ibm.com>, Rob Herring <robh@kernel.org>,
 Michael Rolnik <mrolnik@gmail.com>, Zhao Liu <zhao1.liu@intel.com>,
 Peter Maydell <peter.maydell@linaro.org>,
 Richard Henderson <richard.henderson@linaro.org>,
 Fabiano Rosas <farosas@suse.de>, Corey Minyard <minyard@acm.org>,
 Keith Busch <kbusch@kernel.org>, Thomas Huth <thuth@redhat.com>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, Kevin Wolf <kwolf@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Jesper Devantier <foss@defmacro.it>,
 Hyman Huang <yong.huang@smartx.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, qemu-s390x@nongnu.org,
 Laurent Vivier <laurent@vivier.eu>, qemu-riscv@nongnu.org,
 "Richard W.M. Jones" <rjones@redhat.com>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 Aurelien Jarno <aurelien@aurel32.net>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, kvm@vger.kernel.org,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Akihiko Odaki <akihiko.odaki@daynix.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
 Hanna Reitz <hreitz@redhat.com>, Ani Sinha <anisinha@redhat.com>,
 qemu-ppc@nongnu.org, =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?=
 <marcandre.lureau@redhat.com>, Alistair Francis <alistair.francis@wdc.com>,
 Bin Meng <bmeng.cn@gmail.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Helge Deller <deller@gmx.de>, Peter Xu <peterx@redhat.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Dmitry Fleytman <dmitry.fleytman@gmail.com>,
 Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
 Yanan Wang <wangyanan55@huawei.com>, qemu-arm@nongnu.org,
 Igor Mammedov <imammedo@redhat.com>,
 Jean-Christophe Dubois <jcd@tribudubois.net>,
 Eric Farman <farman@linux.ibm.com>,
 Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>, qemu-block@nongnu.org,
 Stefan Berger <stefanb@linux.vnet.ibm.com>, Joel Stanley <joel@jms.id.au>,
 Eduardo Habkost <eduardo@habkost.net>,
 David Gibson <david@gibson.dropbear.id.au>, Fam Zheng <fam@euphon.net>,
 Weiwei Li <liwei1518@gmail.com>, Markus Armbruster <armbru@redhat.com>
References: <20240912073921.453203-1-pierrick.bouvier@linaro.org>
 <20240912073921.453203-44-pierrick.bouvier@linaro.org>
Content-Language: en-US, fr
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clegoate@redhat.com>
In-Reply-To: <20240912073921.453203-44-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/12/24 09:39, Pierrick Bouvier wrote:
> This patch is part of a series that moves towards a consistent use of
> g_assert_not_reached() rather than an ad hoc mix of different
> assertion mechanisms.
> 
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>


Reviewed-by: Cédric Le Goater <clg@redhat.com>

Thanks,

C.


> ---
>   hw/ppc/ppc.c          | 1 -
>   hw/ppc/spapr_events.c | 1 -
>   2 files changed, 2 deletions(-)
> 
> diff --git a/hw/ppc/ppc.c b/hw/ppc/ppc.c
> index e6fa5580c01..fde46194122 100644
> --- a/hw/ppc/ppc.c
> +++ b/hw/ppc/ppc.c
> @@ -267,7 +267,6 @@ static void power9_set_irq(void *opaque, int pin, int level)
>           break;
>       default:
>           g_assert_not_reached();
> -        return;
>       }
>   }
>   
> diff --git a/hw/ppc/spapr_events.c b/hw/ppc/spapr_events.c
> index 38ac1cb7866..4dbf8e2e2ef 100644
> --- a/hw/ppc/spapr_events.c
> +++ b/hw/ppc/spapr_events.c
> @@ -646,7 +646,6 @@ static void spapr_hotplug_req_event(uint8_t hp_id, uint8_t hp_action,
>            * that don't support them
>            */
>           g_assert_not_reached();
> -        return;
>       }
>   
>       if (hp_id == RTAS_LOG_V6_HP_ID_DRC_COUNT) {


