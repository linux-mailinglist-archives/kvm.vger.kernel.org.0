Return-Path: <kvm+bounces-40595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C78B4A58DAF
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 09:08:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 44928188C75B
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 08:08:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D82D3223326;
	Mon, 10 Mar 2025 08:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E132U3ZP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F0C222591
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 08:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741594107; cv=none; b=C/zkr66vXP4Fhcvtc8Hisqsw0GX/hTA4RSTLrnGpNynJYROdsfWPK9g5zF0b0rqSEoedLzvZKkIokmTRoP+Lsr3EtFXujabTrX1wOZrdOfYrEBpmMOq1E9BiN4/Unhne05eX7rEM6wMPAtzj0tXP4T6nDjd/cslAqYwtd8NJgNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741594107; c=relaxed/simple;
	bh=4LkXQGguBxQTvyWvXF3O/7I00AfoJjhRrbLxTI51z8o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DOsG1+eMZm9lXra4Ezxxmjlzz+pQFfk42JVZfnUvZt6roCaVEvuDCcIyKCrAkIiQ+XZJe4kfnXxoGO8i0XRCyFhGrQXAAl5zhfqGhBALxSx8piEtUWO3nPOaESeJ99WwIw60KFgutj1WqVOh9+XPc9o8NosMeAWPxsHxKQpneag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E132U3ZP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741594104;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2SVqfFpfoDG60gjNZIvZf6TG6Jva8VJJjYnJ5TQlFzU=;
	b=E132U3ZPA9B/qOqsLLkcwLGl1+lpW0Frobf/V+ZP7LkrnOcylrr5oz5Cp9vWSuhE6o5skQ
	vAR++le0KWxSNvsYq5yJtpsE6QikOVs6yHfV7dYDd2JFXQ9cZq5+CqiQ7+UqcRMwFwQAJl
	OUBZcJJOGZmn9i7FxXpqeAaeGuPsc6s=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-_M2RGOtFOeCffPKyNxvo9g-1; Mon, 10 Mar 2025 04:08:23 -0400
X-MC-Unique: _M2RGOtFOeCffPKyNxvo9g-1
X-Mimecast-MFC-AGG-ID: _M2RGOtFOeCffPKyNxvo9g_1741594102
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43bd0586a73so31536985e9.2
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 01:08:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741594102; x=1742198902;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2SVqfFpfoDG60gjNZIvZf6TG6Jva8VJJjYnJ5TQlFzU=;
        b=HHC5g6eIB0vOuA2ZuJPKiw56jL0RtUlRbiL8yZoVDWJNei5p5Qhx+cNrr8mall9V7f
         CL+prQCggkLjT9ivxomVIL0Uf3OtV6p+TpnxVJHUR2y0Mxz37sP8tRXD6PxHaxIFAz8a
         JZx2M84520qxDcsmErvtpEUwhMMAi04LjYm3i4cIF+aDJYne9nq2zfaKdA1aV6eb5k3y
         9xAxxgPcta/qr0ryNTFe21/IFxyRumpuD7+agzftxOX+r8pskEdWcxBwrkA7AjoTBlKj
         tQQ0efZPVp36lntLlRCTytNPsVkJcOowQl7hwRA6flnuN0+lV8JCDZrZAp+DXhyEYIpR
         Pr3g==
X-Forwarded-Encrypted: i=1; AJvYcCWET1/xBSPKpIp1W/1WvLAwloTQmvnrT91xq3rke2gCLGBHEbOrVJAR7xkERqQzL5U13mk=@vger.kernel.org
X-Gm-Message-State: AOJu0YydsLwBN9MyudxohZ4tGBHj5ylO5i55EkfLMuKPREi6Ut5IYC9B
	4vHUL9A+kcBuyNoyJtRWZ/9dMRxvTLIEHJ1g64RkhJW6CupNUDC+y2Gu7FUeDa9ntOI4WTzxhO/
	PhPTiMksz+jOJgjBC0GF5TGsuQHJnTCP1BTCGJv7XX2qw2drvWQ==
X-Gm-Gg: ASbGncuSMJbBYp64yc91SrXW5p90FbtwIG5ueRu1hYvC3asvUeiV4/if3b5OwtrvH77
	RkgQA+roLtxBe1Gj/TEuVAoPb4SdfEyvM4OeEpIWaeRqdF+8YkmgYnBNEW8iqHKMEiu2obefGcr
	HksTXLVSaHOz3fq3ni6gEjfRhHyaCFISclh6tH74Ps1Uy5uHPQpcVWQyJof9XGUHkuG2JpAIM9A
	JagTtDN9zGdnkvnVe4NfQEB16EpU9iF0gyxe0/Et3s3iczczjhYTQkITYoifx/F4qJ9gHnTm6R0
	MvyjX4bUwhURq3TqRTzSithfnt5D0d18qTH26NJ/Z6Nl/xvYLyNcX3Xe1cMNZ7s=
X-Received: by 2002:a05:600c:1e8c:b0:43c:fc0c:7f33 with SMTP id 5b1f17b1804b1-43cfc0c92bcmr7549565e9.2.1741594101981;
        Mon, 10 Mar 2025 01:08:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHAvJo0H2j6esnE0YJy2idFdRJrPW3F+ziL9sDrU5Yt1vwPcmThEaW3VKBboPQlYFKcfohn+A==
X-Received: by 2002:a05:600c:1e8c:b0:43c:fc0c:7f33 with SMTP id 5b1f17b1804b1-43cfc0c92bcmr7548915e9.2.1741594101489;
        Mon, 10 Mar 2025 01:08:21 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43cfcbdd0a7sm9338655e9.11.2025.03.10.01.08.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Mar 2025 01:08:20 -0700 (PDT)
Message-ID: <ff98f698-3f5a-4b08-9e77-3814a74165e4@redhat.com>
Date: Mon, 10 Mar 2025 09:08:15 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2 02/21] hw/vfio/spapr: Do not include <linux/kvm.h>
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Yi Liu <yi.l.liu@intel.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Tony Krowiak <akrowiak@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>,
 Halil Pasic <pasic@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
 David Hildenbrand <david@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>, Tomita Moeko
 <tomitamoeko@gmail.com>, qemu-ppc@nongnu.org,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Eric Farman <farman@linux.ibm.com>, Eduardo Habkost <eduardo@habkost.net>,
 Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
 Zhenzhong Duan <zhenzhong.duan@intel.com>, qemu-s390x@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
 <clg@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>,
 Jason Herne <jjherne@linux.ibm.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Richard Henderson <richard.henderson@linaro.org>
References: <20250308230917.18907-1-philmd@linaro.org>
 <20250308230917.18907-3-philmd@linaro.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250308230917.18907-3-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit




On 3/9/25 12:08 AM, Philippe Mathieu-Daudé wrote:
> <linux/kvm.h> is already include by "system/kvm.h" in the next line.
included

>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Reviewed-by: Cédric Le Goater <clg@redhat.com>
> ---
>  hw/vfio/spapr.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/hw/vfio/spapr.c b/hw/vfio/spapr.c
> index ad4c499eafe..9b5ad05bb1c 100644
> --- a/hw/vfio/spapr.c
> +++ b/hw/vfio/spapr.c
> @@ -11,9 +11,6 @@
>  #include "qemu/osdep.h"
>  #include <sys/ioctl.h>
>  #include <linux/vfio.h>
> -#ifdef CONFIG_KVM
> -#include <linux/kvm.h>
> -#endif
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
>  #include "system/kvm.h"
>  #include "exec/address-spaces.h"
>  


