Return-Path: <kvm+bounces-25873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D6C0096BB65
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 14:00:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 193EAB25422
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 11:59:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01CA81D460E;
	Wed,  4 Sep 2024 11:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WLh0bkU7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928581D45FA
	for <kvm@vger.kernel.org>; Wed,  4 Sep 2024 11:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725451166; cv=none; b=BRTjZv+fQGFk+MI0J41YuA3Am+FwPOPLbjRKGHQA5pyI4cy1EXY0z0nYuX87wGEvrf81617xiIE3CVoq3Vhznon2U0ZhW1QRsqd7aBtckhS69nbacc0Gw5XVCNxygt8f6k5Y8rvc3OF6UHqlb87CpQcDOyuT/b3ZM2YCbPeqtZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725451166; c=relaxed/simple;
	bh=qic7WnFphvxImhlZq2xJgj/uL6OD1DNHtFw7bFhP0m8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nE1LRjnYv7KwkzPregrDj/AZt5hMLS6SVV7NlCkhEUkMTUG/8zAf6V9/gNCu0luhYsNfMl8qoLPqnaoUAwn3/JBAbKo6jWBDcqNU2qebcu6W5a1nDULz2spAZvbIh6Z2mdrf8XjP0jOdYZezJhvtSWAGLZh7ivwCtuFPIbw2LeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WLh0bkU7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725451163;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dBW9QyBTPJ2vPf7oNy3xBpLtcKazFBxSJAYyxXMm5To=;
	b=WLh0bkU7XsEqQM0Uc2sE+TtND/Q3cqNJT5EuVRRH+PnpPcM7ovVLyWibt70CaHW2OfN0Hx
	qGah8S+xki6uSIM3/aOW3Mmh+lgfHf89YfH19UFtZgi1iHg2anqbubLXJDGCPBvuuIOlRH
	dYkvP2A/4hLGRYyrUTW0VEaOVpORPMY=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-588-Rewt6gsHMLi0NCLkRIg9_Q-1; Wed, 04 Sep 2024 07:59:22 -0400
X-MC-Unique: Rewt6gsHMLi0NCLkRIg9_Q-1
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-6db2a306480so11465437b3.3
        for <kvm@vger.kernel.org>; Wed, 04 Sep 2024 04:59:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725451162; x=1726055962;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dBW9QyBTPJ2vPf7oNy3xBpLtcKazFBxSJAYyxXMm5To=;
        b=tbSOIgpI2XQA0lSDLPvTxQtuaieJYmLavLf6vZQsPCTX+oSq49zdH5MjmSuPG+O7w/
         ig54oIMmOHdCm76t0Fr/SqbkyiITXj/22qO+xNfVd70SMh8gHSskexyWmZ1l+XulDaXF
         bwLMCAhcVhppdyFRxO1Z7L8xSra1ubUfCpqkCONEVXvG2IGOSUIAQJfnrBuR6Isl+uVM
         oQ+dJtVO9Sq2tV0aYSLf51Ezl0Nx8n8+gg63cPatuw9syF8kN9zY/EeFd4U9+Tk8J8G6
         wWbZWXHIPXK3XHcx8ZObSbvsEKBd0B3CTaqaXsvkW5CrJB/uMbaECcFBNyGFLT7GqcJD
         PtXQ==
X-Forwarded-Encrypted: i=1; AJvYcCVyACLqhlDxHCi2YXbfoeQsCkqNkwF7v9GUa+9U1cq8GDQo0vp6K6aUiTNtTRkTCRiIIgY=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywu+Mab2D7LHGuyEvZrg1LXt4ymep5Xta+kpbm4f/ffSOs5PG+1
	EDt0oNphLUFzSugBv11UVv4XhdSRo69zdq5K8T7jtbBdodBnREPMLwLsAlxVIBxErQvPebEtFaA
	rwCfqvkeTjHkSZvsLGlnw6neo1r9xjK5EJLwC4xlLp648NxtY7A==
X-Received: by 2002:a05:690c:6785:b0:630:f7c9:80d6 with SMTP id 00721157ae682-6d40fe0f6f3mr192366257b3.27.1725451161921;
        Wed, 04 Sep 2024 04:59:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGq5HvwRqtezxFnSO42dBg91ombB3BJoTOvLU4UJi+3DHaAlCu/R/sHK6aAwUDyIFtI7vIAAA==
X-Received: by 2002:a05:690c:6785:b0:630:f7c9:80d6 with SMTP id 00721157ae682-6d40fe0f6f3mr192365827b3.27.1725451161569;
        Wed, 04 Sep 2024 04:59:21 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:9db0:474c:ff43:9f5c? ([2a01:e0a:280:24f0:9db0:474c:ff43:9f5c])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a806d5b0easm611441485a.100.2024.09.04.04.59.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Sep 2024 04:59:21 -0700 (PDT)
Message-ID: <1a4270a7-212e-4651-a720-913b3dd11296@redhat.com>
Date: Wed, 4 Sep 2024 13:59:14 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 19/19] qapi/vfio: Rename VfioMigrationState to Qapi*,
 and drop prefix
To: Markus Armbruster <armbru@redhat.com>, qemu-devel@nongnu.org
Cc: alex.williamson@redhat.com, andrew@codeconstruct.com.au,
 andrew@daynix.com, arei.gonglei@huawei.com, berrange@redhat.com,
 berto@igalia.com, borntraeger@linux.ibm.com, clg@kaod.org, david@redhat.com,
 den@openvz.org, eblake@redhat.com, eduardo@habkost.net,
 farman@linux.ibm.com, farosas@suse.de, hreitz@redhat.com,
 idryomov@gmail.com, iii@linux.ibm.com, jamin_lin@aspeedtech.com,
 jasowang@redhat.com, joel@jms.id.au, jsnow@redhat.com, kwolf@redhat.com,
 leetroy@gmail.com, marcandre.lureau@redhat.com, marcel.apfelbaum@gmail.com,
 michael.roth@amd.com, mst@redhat.com, mtosatti@redhat.com,
 nsg@linux.ibm.com, pasic@linux.ibm.com, pbonzini@redhat.com,
 peter.maydell@linaro.org, peterx@redhat.com, philmd@linaro.org,
 pizhenwei@bytedance.com, pl@dlhnet.de, richard.henderson@linaro.org,
 stefanha@redhat.com, steven_lee@aspeedtech.com, thuth@redhat.com,
 vsementsov@yandex-team.ru, wangyanan55@huawei.com,
 yuri.benditovich@daynix.com, zhao1.liu@intel.com, qemu-block@nongnu.org,
 qemu-arm@nongnu.org, qemu-s390x@nongnu.org, kvm@vger.kernel.org,
 avihaih@nvidia.com
References: <20240904111836.3273842-1-armbru@redhat.com>
 <20240904111836.3273842-20-armbru@redhat.com>
Content-Language: en-US, fr
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clegoate@redhat.com>
In-Reply-To: <20240904111836.3273842-20-armbru@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/4/24 13:18, Markus Armbruster wrote:
> QAPI's 'prefix' feature can make the connection between enumeration
> type and its constants less than obvious.  It's best used with
> restraint.
> 
> VfioMigrationState has a 'prefix' that overrides the generated
> enumeration constants' prefix to QAPI_VFIO_MIGRATION_STATE.
> 
> We could simply drop 'prefix', but then the enumeration constants
> would look as if they came from kernel header linux/vfio.h.
> 
> Rename the type to QapiVfioMigrationState instead, so that 'prefix' is
> not needed.
> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>


Reviewed-by: Cédric Le Goater <clg@redhat.com>

Thanks,

C.


> ---
>   qapi/vfio.json      | 9 ++++-----
>   hw/vfio/migration.c | 2 +-
>   2 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/qapi/vfio.json b/qapi/vfio.json
> index eccca82068..b53b7caecd 100644
> --- a/qapi/vfio.json
> +++ b/qapi/vfio.json
> @@ -7,7 +7,7 @@
>   ##
>   
>   ##
> -# @VfioMigrationState:
> +# @QapiVfioMigrationState:
>   #
>   # An enumeration of the VFIO device migration states.
>   #
> @@ -32,10 +32,9 @@
>   #
>   # Since: 9.1
>   ##
> -{ 'enum': 'VfioMigrationState',
> +{ 'enum': 'QapiVfioMigrationState',
>     'data': [ 'stop', 'running', 'stop-copy', 'resuming', 'running-p2p',
> -            'pre-copy', 'pre-copy-p2p' ],
> -  'prefix': 'QAPI_VFIO_MIGRATION_STATE' }
> +            'pre-copy', 'pre-copy-p2p' ] }
>   
>   ##
>   # @VFIO_MIGRATION:
> @@ -63,5 +62,5 @@
>     'data': {
>         'device-id': 'str',
>         'qom-path': 'str',
> -      'device-state': 'VfioMigrationState'
> +      'device-state': 'QapiVfioMigrationState'
>     } }
> diff --git a/hw/vfio/migration.c b/hw/vfio/migration.c
> index 262d42a46e..17199b73ae 100644
> --- a/hw/vfio/migration.c
> +++ b/hw/vfio/migration.c
> @@ -81,7 +81,7 @@ static const char *mig_state_to_str(enum vfio_device_mig_state state)
>       }
>   }
>   
> -static VfioMigrationState
> +static QapiVfioMigrationState
>   mig_state_to_qapi_state(enum vfio_device_mig_state state)
>   {
>       switch (state) {


