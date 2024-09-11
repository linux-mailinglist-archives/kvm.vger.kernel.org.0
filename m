Return-Path: <kvm+bounces-26491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 32FC0974EE1
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 11:42:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B3B641F24E2F
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 09:41:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2039715B153;
	Wed, 11 Sep 2024 09:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="GHCBuvZo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E871745C18
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 09:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726047705; cv=none; b=ALUN86mdROAVax+ITevYBFf2HPGslHibi0S4qGjUplDYfDaVsqLKZi5xhaA7YF18cTCsmTdEmhp1OgYoB2oNVXa7IAYposyGaOv9oRndICnyVOT2c0KFhY92cnJs27lmWA9VrHm5BvilMSz8JXYE5jdwQCw9lBpT3yjsry7jNmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726047705; c=relaxed/simple;
	bh=H4B9/uwNGKt/vZ/gpS8GV45FGQDVPOnLe+0SZOwtc7U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GIecjkiCq+tPQFU5WG2yccwCh70nx3tq8A8e24Dy49uDFtnS8BOwInS+Q3hr9kHx/B9XRz0xAmjeA9rAMvvNs3HcVjmNn0M1Leu9nXqpbNHEsNma8VqfWTdvcjqmKOys+7O8NGIf07v25ZU/n/tgZasYAoC6DWj/MR2qdL65C3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=GHCBuvZo; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2055136b612so79336745ad.0
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 02:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1726047703; x=1726652503; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kn5qlxz6rYEqhaF1IlMFBCOQtR9IuIiaMxxsFKOJnss=;
        b=GHCBuvZot0HExvOp+kRJdqwN6bev7E1IWXilTrpw+YvbVa2Lh/EJ9gwKDShjKrDyRQ
         b7hgtZ/xskrFuF+p5gBrOgxbExx36Mqyi9hfgvNi6M9qx3AUHDRcXNh0+Yx2CPWlfUSf
         VWtbFn6cAZiaz6Y37pVmwbfSLhm79cfnriMQrBA/Vaq3ISYczTklFjqcQpTi/OEVgGUs
         jStlAbOUUms4Lo7bPLExFFPMNELPqv9Af0VzrKAlwOJMDTtM+RXkEOKnsx0AK7HOjIk6
         atljVe3yPKmB43wx0My1yzSvbu6dql836CXvLRLArUgM30BxMMsnH825WpdKutm47V4z
         Gxlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726047703; x=1726652503;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kn5qlxz6rYEqhaF1IlMFBCOQtR9IuIiaMxxsFKOJnss=;
        b=EaXrurgE/J0EVTwWxHTgkodWjK/pZ3WhNZjkAxvKb9KRG9h1a+Kd+tSEFNFnwP+pJQ
         s6opFmPrxVLfFN+GNckmHouTYtX7xnArXg8wLWDv28kLo7RsSzPHhcdr5EGeaNmARLWe
         tfkvgWH22DQfYQlntF2dOC5eU/IY2cNcHZCDynxTAfIxxVKDn9Fpnuy49sVQPOIyajT0
         TUV5zSb0Dqeg2nz/0acSUueOKwZMAK/lil1gJKAqEKF+TYJ7ziGoYFd8QudMVceMQe1k
         HQRqL3thQqQWW445hSxcYR0tv60OCXs6kf/47P4231QDuCoJ0QySP60w5b/55bn2/1xm
         Or0g==
X-Forwarded-Encrypted: i=1; AJvYcCUUBco2VK4aFaKUtNpIv3GdAO9++7R8z7tWDePYSlk+BhVdy2l6Lbuopgr7y1nF28JIKbg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSOErmXcXzig+eEgaPkmeqs9fOsHslXGiT3RxwunbcH8+5CvCx
	ZdIkVmMq+j5hTSwGYlKRpcw3UViwIhkkjNsgC8Kfh0y9BBB4Be/2rqLlDnYfGeI=
X-Google-Smtp-Source: AGHT+IG7rMRmLj/y96aXDOZLOEvKG9GOrb7S5g+4beGqyo1xcxzviLsaVZV/GqWsQoagVaROIUgcuw==
X-Received: by 2002:a17:902:f790:b0:202:19a0:fcba with SMTP id d9443c01a7336-2074c6a4573mr64727285ad.41.1726047703192;
        Wed, 11 Sep 2024 02:41:43 -0700 (PDT)
Received: from [192.168.68.110] (201-68-240-198.dsl.telesp.net.br. [201.68.240.198])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20710e321fdsm60213095ad.83.2024.09.11.02.41.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2024 02:41:42 -0700 (PDT)
Message-ID: <c9167c3f-9cb4-458b-ab1e-ee5c1103f76b@ventanamicro.com>
Date: Wed, 11 Sep 2024 06:41:28 -0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 20/39] hw/ppc: replace assert(false) with
 g_assert_not_reached()
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>, "Richard W.M. Jones" <rjones@redhat.com>,
 Joel Stanley <joel@jms.id.au>, Kevin Wolf <kwolf@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 Corey Minyard <minyard@acm.org>, Eric Farman <farman@linux.ibm.com>,
 Thomas Huth <thuth@redhat.com>, Keith Busch <kbusch@kernel.org>,
 WANG Xuerui <git@xen0n.name>, Hyman Huang <yong.huang@smartx.com>,
 Stefan Berger <stefanb@linux.vnet.ibm.com>,
 Michael Rolnik <mrolnik@gmail.com>,
 Alistair Francis <alistair.francis@wdc.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Markus Armbruster <armbru@redhat.com>,
 Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, qemu-riscv@nongnu.org,
 Ani Sinha <anisinha@redhat.com>, Halil Pasic <pasic@linux.ibm.com>,
 Jesper Devantier <foss@defmacro.it>, Laurent Vivier <laurent@vivier.eu>,
 Peter Maydell <peter.maydell@linaro.org>, Igor Mammedov
 <imammedo@redhat.com>, kvm@vger.kernel.org,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Richard Henderson <richard.henderson@linaro.org>, Fam Zheng
 <fam@euphon.net>, qemu-s390x@nongnu.org, Hanna Reitz <hreitz@redhat.com>,
 Nicholas Piggin <npiggin@gmail.com>, Eduardo Habkost <eduardo@habkost.net>,
 Laurent Vivier <lvivier@redhat.com>, Rob Herring <robh@kernel.org>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, qemu-block@nongnu.org,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>, qemu-ppc@nongnu.org,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Fabiano Rosas <farosas@suse.de>,
 Helge Deller <deller@gmx.de>, Dmitry Fleytman <dmitry.fleytman@gmail.com>,
 Akihiko Odaki <akihiko.odaki@daynix.com>,
 Marcelo Tosatti <mtosatti@redhat.com>,
 David Gibson <david@gibson.dropbear.id.au>,
 Aurelien Jarno <aurelien@aurel32.net>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 Yanan Wang <wangyanan55@huawei.com>, Peter Xu <peterx@redhat.com>,
 Bin Meng <bmeng.cn@gmail.com>, Weiwei Li <liwei1518@gmail.com>,
 Klaus Jensen <its@irrelevant.dk>,
 Jean-Christophe Dubois <jcd@tribudubois.net>,
 Jason Wang <jasowang@redhat.com>
References: <20240910221606.1817478-1-pierrick.bouvier@linaro.org>
 <20240910221606.1817478-21-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
In-Reply-To: <20240910221606.1817478-21-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/10/24 7:15 PM, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---

Reviewed-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>

>   hw/ppc/spapr_events.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/hw/ppc/spapr_events.c b/hw/ppc/spapr_events.c
> index cb0eeee5874..38ac1cb7866 100644
> --- a/hw/ppc/spapr_events.c
> +++ b/hw/ppc/spapr_events.c
> @@ -645,7 +645,7 @@ static void spapr_hotplug_req_event(uint8_t hp_id, uint8_t hp_action,
>           /* we shouldn't be signaling hotplug events for resources
>            * that don't support them
>            */
> -        g_assert(false);
> +        g_assert_not_reached();
>           return;
>       }
>   

