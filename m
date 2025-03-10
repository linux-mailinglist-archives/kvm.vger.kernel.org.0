Return-Path: <kvm+bounces-40610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 378A2A58E2C
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 09:29:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C46C3ACC50
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 08:29:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFBBA223715;
	Mon, 10 Mar 2025 08:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KeOcC/OW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF0F223706
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 08:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741595373; cv=none; b=X6D6dl3L9KDlbBqAGyO6iBEoes/yFhiFJoJbK5cVgKlywF3cYKg6wImVs8qJn+HRssiKlYD8rzlJm9j60ZAPQ2bKTL4t+pv/OFjXqZs4HGQQl8dHStIwa38RMr4rAl9ebUBluBjwioFCtHDkn+MD/3xtwVq1r0ptvKqs6xtgCeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741595373; c=relaxed/simple;
	bh=+ySaC9YZXWLZ/B3ciUj4olJbindhYAtjZE+cJY1Yo2Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IACrNxerunHYxnE5tck0Hog6rF/Np7PNVFE3BEttdWZKajF28JBW0rV7JLX3YuchZB2/oKK32e5AWtplzsNBctqXjFLKgwAoOAj03yVSVg3G/lwMTGiFG51RAzjspbLTBtWukpSnOwI8T7NxoYqxMv1NeoE9aDD+saOPSSQKOFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KeOcC/OW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741595370;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H9IUHSXAtOcyBX6406ivSQAj3+/L2kwNFrYXokmmlkw=;
	b=KeOcC/OWlpBNx8/MfIbzryT8tIV7WMvr/SAtTy4kh2kF/jl9s8TBevaRekIFP7aX5p/0+R
	n8Cse9wNCcmO6iqvy1ir+qxT/IwRwYkItYiMrB0j00qgmm81EusHg/KRUNwhHYA7TpVdJ4
	OKytlsIjzQHE8QPtnC5aZ/Z7VHXpZkI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-417-xgnRUi2TOBGmzOEGeLbmHg-1; Mon, 10 Mar 2025 04:29:27 -0400
X-MC-Unique: xgnRUi2TOBGmzOEGeLbmHg-1
X-Mimecast-MFC-AGG-ID: xgnRUi2TOBGmzOEGeLbmHg_1741595367
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3913aea90b4so691091f8f.2
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 01:29:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741595366; x=1742200166;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H9IUHSXAtOcyBX6406ivSQAj3+/L2kwNFrYXokmmlkw=;
        b=FVbL/lsI0cZpJ0Ni0bfBEgw407jrg+TY6dPiME2TY6pJ8dLpO1aLvXnEA/jl95MQsu
         xInO+sSuy/zC6kdok+FIN2REf/dYEKOtaprj3WkhTKr+dYYC+kiDIPHUVhueRbxtgbE2
         oE+zqqMdMMv3OsSt5vHAfE/IwmNVmLpDHZ7VgIMTg7JR0zKrffEdVelRvO4jMU/XEHsy
         LsC8Pjud+f6c0YIuEF4PLem07uagWAcPMgsN6QzmnmqeMKR//u9NSX8CE/7Nw8Rv7uww
         3vpCdyvAtsfgtMnMKLOsxaEclkbzhk8eGgGo0nPZFIKP2dG3+GEYio8YwkAuqeUBr8v6
         F3WA==
X-Forwarded-Encrypted: i=1; AJvYcCWSvZOOm1GrhfHFApbB5hRdK0pq0yYtTwDQOd6/ocY6kLqqEuPpEd4fOiFwIBqS8XnQDms=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSFwYuQJdFUxBUUlC1IHUwqrU0BaOXY0B/c4spntZVr4W84zDZ
	zQrHUz/IIMQznIfBBIFSiGddB7GVF5GKT0k8uSEGWFOX16BcJ2zI1LzI9JpsX1ObPk/EdB63jO/
	WwoUdMLjl9/4Or6M7SypsVXSQYxcFe4nhTEPfuX93pS56070Slw==
X-Gm-Gg: ASbGncv9cAFArFYY+n+O6aZrO2+Lh4AuF1G9pdQYHeIrystYk5L/dRpCjrdcvx8XqBz
	rjJYRC948pdoQk9ls7YiEDUmWs47PaG2lBSndOdp8xz6tSTbx01KG0vv2IhN/ty36auHLEdTkfa
	ytVcp8F1xBNuS8pdJKAWygPp2IMtepsRDG2QOw9EFUcNEOOTjQbMdyRhysrfNXQ05wfhqWReeGm
	vCpe7Vmzn81yN/FWT9OpyRGNIN3ibCzm31CBnRqxMPovPPX917A27GDHgPsgXCMBexWKlxFjeE4
	cueccHK/k82HrI3XZND1TJSSuS/9Swni4wZUYQ/UNxyqp73UbIeguz6OkgYYLDQ=
X-Received: by 2002:a5d:6c66:0:b0:391:4763:2a with SMTP id ffacd0b85a97d-39147630139mr2479796f8f.47.1741595366706;
        Mon, 10 Mar 2025 01:29:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHPNJntjpr3gMQ8m9M8Z5B8/nqI3UcZG0kOxTXkmBrWyewceDf0RpQnBesTDqtsAR+C/l5M/A==
X-Received: by 2002:a5d:6c66:0:b0:391:4763:2a with SMTP id ffacd0b85a97d-39147630139mr2479753f8f.47.1741595366332;
        Mon, 10 Mar 2025 01:29:26 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c103f57sm14175885f8f.91.2025.03.10.01.29.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Mar 2025 01:29:25 -0700 (PDT)
Message-ID: <1671aad2-ab9e-4462-88c1-11389d299c76@redhat.com>
Date: Mon, 10 Mar 2025 09:29:22 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2 07/21] hw/vfio: Compile display.c once
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
 <20250308230917.18907-8-philmd@linaro.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250308230917.18907-8-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit




On 3/9/25 12:09 AM, Philippe Mathieu-Daudé wrote:
> display.c doesn't rely on target specific definitions,
> move it to system_ss[] to build it once.
>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Reviewed-by: Cédric Le Goater <clg@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Eric
> ---
>  hw/vfio/meson.build | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/hw/vfio/meson.build b/hw/vfio/meson.build
> index 5c9ec7e8971..a8939c83865 100644
> --- a/hw/vfio/meson.build
> +++ b/hw/vfio/meson.build
> @@ -5,7 +5,6 @@ vfio_ss.add(files(
>  ))
>  vfio_ss.add(when: 'CONFIG_PSERIES', if_true: files('spapr.c'))
>  vfio_ss.add(when: 'CONFIG_VFIO_PCI', if_true: files(
> -  'display.c',
>    'pci-quirks.c',
>    'pci.c',
>  ))
> @@ -28,3 +27,6 @@ system_ss.add(when: 'CONFIG_VFIO', if_true: files(
>  system_ss.add(when: ['CONFIG_VFIO', 'CONFIG_IOMMUFD'], if_true: files(
>    'iommufd.c',
>  ))
> +system_ss.add(when: 'CONFIG_VFIO_PCI', if_true: files(
> +  'display.c',
> +))


