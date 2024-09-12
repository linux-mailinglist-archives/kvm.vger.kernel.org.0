Return-Path: <kvm+bounces-26747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8314D976E82
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 18:14:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 04AFA1F249D2
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 16:14:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12F3B13DBBE;
	Thu, 12 Sep 2024 16:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LMU+7qua"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F4C126C00
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 16:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726157663; cv=none; b=QobxYfcv/lE+iE1qHmuO/MD8GIy7j+io0PHnWTCI2S7MdEwqRG/dLwvcFK+8JsxYoKDMGaUCYFE9ZMKzgM5CIoEFSts0+wLD2GKPX2cgnfc3s+hL5L6iPiCtwdGZ1JnchiCEf2G876hYbwcSbUi3KZ3VMpedaATwc9Cfz4IpLuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726157663; c=relaxed/simple;
	bh=nId45z6QZa8yBHuE1talfP2plHQimEyDcY2dwVsp+j4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A2UNe8ae41SQJkVanrXlcKkaRmV6t+pZhWoUmui5Qm5MVi24qS54p9LpCaklDDFAA73MeggjuMZBB640ORVNljoNG++rx1TSA7B6oMU/Hvv4ppiM1HZf6DinnEezkmc03b4OlSVHd+bW4cCu3FY5+LrmUTIooTiD0RIuq5nkZY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LMU+7qua; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726157660;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=f0b6ry8Ezr/LJuQPzt/4qKls+i9F57WWKFMYh7hwV6o=;
	b=LMU+7qualFBUPqPAylN2T6mQId3riwpxtU8cyPlY81F+pAaaG1RROgvfNXp53TDcovwyWW
	oM5qdMr+CsM9dOZ//HsM87n+yTI3BEk+8MvxMf6HjMSwXUQ1HnGH7fV43pwqC9V1GzmoD/
	jqfdrhtypKWQopeztSBWt9bcSkRduSw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-145-h9i6C2P2Mi2odai2EW1ZDg-1; Thu, 12 Sep 2024 12:14:19 -0400
X-MC-Unique: h9i6C2P2Mi2odai2EW1ZDg-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5becd2ca7e7so1068975a12.1
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 09:14:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726157658; x=1726762458;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f0b6ry8Ezr/LJuQPzt/4qKls+i9F57WWKFMYh7hwV6o=;
        b=VyBx/x++xgdTaCNhT10MwbXiiCCKIyYcXZucAlv1/VPxkqOsA4rWMHmzr1M50Jvq9z
         vsh0WGSS43/P1CTMY6vyVmqP3O6s9B3xdAJJcq/7kWOZMBtk2aUxsySfGZjISJY8Ftqf
         SCvJmie02gDqskV5qwL+4zcD89z0kfj6Mp8RTpeXDXZEFxP2pLan8sgdyOqyZcThr8/m
         N1Wkz+7+KeX/Np+zlECtEwvfVoQoQXV7vcH1Doa1F9ywlrRnQfxgDKuqSkWDNndhuwJI
         tuCm2IJEAQ5oHDtecwbX3xqzBv8Dds6hs7UYoMROJe+LCyzCgJNciluFFKfiZCt4+CxC
         JrRQ==
X-Forwarded-Encrypted: i=1; AJvYcCXcL2EwVC2nWsNwML60BFzbSLPOcgWuIxc5Df3FgV0Yv3eWhfV6HJQ//CR7mmfjC+Zb0S8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1irIY0W1hLuTWOB6Hlpht/w+GiMyBG/BRQLV98OESaLai37g3
	hfk98HN2RYmRgtshbfpwMykeTHOw5qxip6YRQyKtvGgCHw0vY0HzwFhBQaMAFYmV61tiTxKTPbW
	4U0k8M/vIipD30jEwRHxHX5lBCMHS3lwFRHi870grEkpqAMdKYg==
X-Received: by 2002:a05:6402:2546:b0:5c2:7741:7d82 with SMTP id 4fb4d7f45d1cf-5c4143626camr3319220a12.11.1726157657981;
        Thu, 12 Sep 2024 09:14:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEW4s9xI2m+gPSP+KOKW2/eT/+C5yDBiqcOeWUmuDrQx9C2HWrZ1Da9f6NGDiY2kJx0xpd05g==
X-Received: by 2002:a05:6402:2546:b0:5c2:7741:7d82 with SMTP id 4fb4d7f45d1cf-5c4143626camr3319143a12.11.1726157657432;
        Thu, 12 Sep 2024 09:14:17 -0700 (PDT)
Received: from [192.168.55.123] (93-55-14-26.ip261.fastwebnet.it. [93.55.14.26])
        by smtp.googlemail.com with ESMTPSA id 4fb4d7f45d1cf-5c3ebd41c7dsm6671900a12.13.2024.09.12.09.14.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Sep 2024 09:14:16 -0700 (PDT)
Message-ID: <cf9642be-8169-496d-81ca-203ffa0f8edd@redhat.com>
Date: Thu, 12 Sep 2024 18:14:07 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/48] docs/spin: replace assert(0) with
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
 Jesper Devantier <foss@defmacro.it>, Hyman Huang <yong.huang@smartx.com>,
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
 <20240912073921.453203-2-pierrick.bouvier@linaro.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240912073921.453203-2-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/12/24 09:38, Pierrick Bouvier wrote:
> This patch is part of a series that moves towards a consistent use of
> g_assert_not_reached() rather than an ad hoc mix of different
> assertion mechanisms.
> 
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>

This is not C code, so please drop this patch.

Paolo

> ---
>   docs/spin/aio_notify_accept.promela | 6 +++---
>   docs/spin/aio_notify_bug.promela    | 6 +++---
>   2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/docs/spin/aio_notify_accept.promela b/docs/spin/aio_notify_accept.promela
> index 9cef2c955dd..f929d303281 100644
> --- a/docs/spin/aio_notify_accept.promela
> +++ b/docs/spin/aio_notify_accept.promela
> @@ -118,7 +118,7 @@ accept_if_req_not_eventually_false:
>       if
>           :: req -> goto accept_if_req_not_eventually_false;
>       fi;
> -    assert(0);
> +    g_assert_not_reached();
>   }
>   
>   #else
> @@ -141,12 +141,12 @@ accept_if_event_not_eventually_true:
>           :: !event && notifier_done  -> do :: true -> skip; od;
>           :: !event && !notifier_done -> goto accept_if_event_not_eventually_true;
>       fi;
> -    assert(0);
> +    g_assert_not_reached();
>   
>   accept_if_event_not_eventually_false:
>       if
>           :: event     -> goto accept_if_event_not_eventually_false;
>       fi;
> -    assert(0);
> +    g_assert_not_reached();
>   }
>   #endif
> diff --git a/docs/spin/aio_notify_bug.promela b/docs/spin/aio_notify_bug.promela
> index b3bfca1ca4f..ce6f5177ed5 100644
> --- a/docs/spin/aio_notify_bug.promela
> +++ b/docs/spin/aio_notify_bug.promela
> @@ -106,7 +106,7 @@ accept_if_req_not_eventually_false:
>       if
>           :: req -> goto accept_if_req_not_eventually_false;
>       fi;
> -    assert(0);
> +    g_assert_not_reached();
>   }
>   
>   #else
> @@ -129,12 +129,12 @@ accept_if_event_not_eventually_true:
>           :: !event && notifier_done  -> do :: true -> skip; od;
>           :: !event && !notifier_done -> goto accept_if_event_not_eventually_true;
>       fi;
> -    assert(0);
> +    g_assert_not_reached();
>   
>   accept_if_event_not_eventually_false:
>       if
>           :: event     -> goto accept_if_event_not_eventually_false;
>       fi;
> -    assert(0);
> +    g_assert_not_reached();
>   }
>   #endif


