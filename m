Return-Path: <kvm+bounces-40594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D0DFA58DAE
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 09:08:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5ACD4167B2B
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 08:08:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 220C222259B;
	Mon, 10 Mar 2025 08:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fPtWyx2N"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEFBC222575
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 08:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741594105; cv=none; b=KQBynycVuaiWpaoCzmawGJ2ATjv2dYZJ/JsNpuMHH6p/a+iN4+Oa5E3PqJ7erPVH43xevLKoOkOItJTPDSBWkKZtdafW8MqXAQPNWZgTn1rn9Rtayq3dKAZzN1JBHjPGZCfpLdoc7Ahfjvj54MCY7USZ5/5YNBTY9ThAq/N31Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741594105; c=relaxed/simple;
	bh=ISx1hO09ddIy2gHgXoVXvI7rdGH2eYr/5woG1E2I3OI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uPqMPc6cJbpVApEiukxMWIAOeY10fFW3b3gT+1Im6YHW+NOncCiyOPw9nrLebfnTxZ8V0tKfxjkqq3AxiQmwggChbI8539xt9xnAkZB9iBeHtjkhxldLAfA/nNGHIOhnqAAA+smbpi8uTapaqeU1cVikQz3wLHLX8wJldlcsTbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fPtWyx2N; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741594102;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pL2ObvzrNSvxyqAwP+KydM2AQVwV9P3+kj9fufE1kXc=;
	b=fPtWyx2NlKp1NvwozaMslClOQP1QicCA+SXnmaSraWyMds8P4SLFY4oCs/JgiN9qvwPyEZ
	Z0srajsjIFLT6doP/1C/UvayAFOZGQ+awuWvAYW8qLC4eFvsiinC9JP/P3voKJM+NYybWB
	Q1xpLaCi9yxrZjJjrf/od6rH6n9pJoU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-600-CuaqatkjMwunVw9J-XEqcQ-1; Mon, 10 Mar 2025 04:08:19 -0400
X-MC-Unique: CuaqatkjMwunVw9J-XEqcQ-1
X-Mimecast-MFC-AGG-ID: CuaqatkjMwunVw9J-XEqcQ_1741594099
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43bc97e6360so17884685e9.3
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 01:08:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741594099; x=1742198899;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pL2ObvzrNSvxyqAwP+KydM2AQVwV9P3+kj9fufE1kXc=;
        b=UTIrMJ6GRxUzegwcFn9l/nyqg+0IC+Pdj8+DanVtJ/EUYub5l4FzquPiqeWwZqmRLK
         d72X96xSoIobWFmUX1oQ/WeumDRtXNk9d6CxZzs7qGg3vgtO2WtPXJbjKuMKjXE8RaX2
         KeRraAuvynbR0XD12/7dxuPejPfvoWLZjliG3ZIBGlZkdjrPX3wh6THEslaOK/nwOJ4K
         FKheBRAfOXOFtEQP3NVWwAIKBZQRn1SAuQ5q6R+cP20iQVfePYGtSBRQ9VrIBEIkJL9Y
         TbsCMsWzFO7dKcS4Gn9+bChDsHtmYwk/aW863LQj/MLMcpRxCM9NGksew4Tep2x1GTiS
         w2pA==
X-Forwarded-Encrypted: i=1; AJvYcCUcEN+vZH55YQCkbP8OBvmPmFh0bhHZTCg+ma9bOYImXbYiBYO7kNJ8XOv4MvuVkFLXLf0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyp287wwpGvxlsKFHik4lNTHeEAwKypmCKHzexEZMVpuDGJPOB5
	ZweR3hsbgs5kvAf5FTydEnhX3sM8XhoJ0u0UVXaBEsUenZknukvfJsakSfw5tDx5FNpNVZZ/soG
	hAXwGaHb3zP/kXN2DaUOPqAsXgmCe2Uocl165HS83uMMHwQse2A==
X-Gm-Gg: ASbGncuVgmVgmEoFWGWsRchL8CL5z1Z1SOdrjIutGg3+xJIX+wCAc36gNixKTWq9GqQ
	hS6dtgGEBexBV/4WJ3OVltN0dyBtLL5AXystRhZ8/p3JNHVRjPEsA2Bcy+59MIyUCo82tTcr9CA
	Wzw9ZsG9P/7Mt5/X1lYAmGU1A3Nt+fo9fLeqSeY0wv8nPtjAxoyKeFVCQPonjrHPR3iyhp/FTfE
	cUdFoiMH075CDgffFU+L/pMs0tWrbuUJ1WKSZIBQvu2TW7cbRjLDwfnJW+rBQoqAYLF2zQC8P77
	76iORDQLLNCzydjDwbVnw9MemPOo89fMguUslZeaoBxZO2K5/vY+Sm2Hp5/pNJs=
X-Received: by 2002:a5d:47a2:0:b0:38d:d7a4:d447 with SMTP id ffacd0b85a97d-39132da0f2fmr6809670f8f.34.1741594098679;
        Mon, 10 Mar 2025 01:08:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHcuk8O08VAJ1w4B9X3sHWn33Nr3w+1n8EOHcUeysuu3RyyFRhoQg2nYaSRkMkylCw7Z8pRwQ==
X-Received: by 2002:a5d:47a2:0:b0:38d:d7a4:d447 with SMTP id ffacd0b85a97d-39132da0f2fmr6809655f8f.34.1741594098301;
        Mon, 10 Mar 2025 01:08:18 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43cfcbdd0a7sm9338655e9.11.2025.03.10.01.08.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Mar 2025 01:08:16 -0700 (PDT)
Message-ID: <510b65b4-3b7c-42b7-9108-4fd438055535@redhat.com>
Date: Mon, 10 Mar 2025 09:08:13 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2 01/21] hw/vfio/common: Include missing 'system/tcg.h'
 header
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
 <20250308230917.18907-2-philmd@linaro.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250308230917.18907-2-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit




On 3/9/25 12:08 AM, Philippe Mathieu-Daudé wrote:
> Always include necessary headers explicitly, to avoid
> when refactoring unrelated ones:
>
>   hw/vfio/common.c:1176:45: error: implicit declaration of function ‘tcg_enabled’;
>    1176 |                                             tcg_enabled() ? DIRTY_CLIENTS_ALL :
>         |                                             ^~~~~~~~~~~
>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Reviewed-by: Cédric Le Goater <clg@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  hw/vfio/common.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/hw/vfio/common.c b/hw/vfio/common.c
> index 7a4010ef4ee..b1596b6bf64 100644
> --- a/hw/vfio/common.c
> +++ b/hw/vfio/common.c
> @@ -42,6 +42,7 @@
>  #include "migration/misc.h"
>  #include "migration/blocker.h"
>  #include "migration/qemu-file.h"
> +#include "system/tcg.h"
>  #include "system/tpm.h"
>  
>  VFIODeviceList vfio_device_list =


