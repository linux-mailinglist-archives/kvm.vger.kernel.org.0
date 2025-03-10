Return-Path: <kvm+bounces-40613-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D2B7A59053
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 10:54:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 01776188BB9B
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 09:54:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 897EA225762;
	Mon, 10 Mar 2025 09:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SF3pdZUm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6CE21D585
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 09:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741600466; cv=none; b=UMX6sLIZ/gqJYw8C+d3ui/ph81GLXHGP3PPrCzl5kxzhq06tLk4nH6lmj+o4lYkzHHm6y/UnkWNdEnhCYvBufSM+t7V3n4cPOc7qZpQG9g7rA3j0accnGiuuYGxPpMrG0tlRVAyifKyfK/65+WKTdKDc8K7/hFBJLS4iPNgYqto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741600466; c=relaxed/simple;
	bh=BIbzu1magtNr5tNBT4m89gYVVEZIqe1cGEyaCn78eIE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dzOUnNOXXah5A7buIOGz8boxMztKtzbnnOJ/yBVlYa9+aBPrmyLTaQoEHVLANDDQ71xGkjlkfVvdRtkTHI11+A7c6aEwdNeqOQxOQHGroBB833D5tZScvqP42aAnN1l3hLz7DSQcZ2ZJTM9bcoMxR0ac6ZybJ5755P0YQTkqbXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SF3pdZUm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741600463;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wtuqdOuiecVVRmmjSp3gslEg0ualkMi9F/wEULB6TGE=;
	b=SF3pdZUmMtenn1J/SiFXA2aTvqrk4wD9E6CL0mhR1b96djIJbEQOX9yy+7OXJUYfsliG38
	uSAjavF4fVud3uoVnFjfL8fm+68800tDVGTowUGmllS4BrZpp9TwovWXjNsWCDpocMWtox
	x/uIW5RTgn0ROn/znZ0EMBfIesH5Mno=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-98-mxPikIGPPaOPG4ugOZIrUg-1; Mon, 10 Mar 2025 05:54:22 -0400
X-MC-Unique: mxPikIGPPaOPG4ugOZIrUg-1
X-Mimecast-MFC-AGG-ID: mxPikIGPPaOPG4ugOZIrUg_1741600461
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-39149cbc77dso479463f8f.3
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 02:54:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741600461; x=1742205261;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wtuqdOuiecVVRmmjSp3gslEg0ualkMi9F/wEULB6TGE=;
        b=Lpb9oMg3cymQSg0DttweYeGz+YgRXjr7E5hiV58mtXZXhMyFtrJP6jmOBhOytXkGwv
         bYDIqUOr33TkoBfvizlt0Wz1lYTHS6qTRTVpV43hMyjcL3nAlc4V2U4ZR1n8LkTtqUAP
         9sh+CTlDIeC0PdRo6oBeVk37PzRPVWTctAqG9D/w9XO83x8g0mwPbGn5M77/eugd7UFI
         G0Us14ETALa7uXxGr/BbN6VFUc2hlnomOMrBT4yAH4/nGSnj/fMjyzCaTc0jvEzJ9/d4
         eKHn8vnxRk7sb+MKYKt45alnAVVkWeQ+OG0aR7dL/29hYocFbFI3kcr0m8pxY2/pAMec
         027w==
X-Forwarded-Encrypted: i=1; AJvYcCVtVX7mON4QNEQ2ibARzXUhK2N8qlTdcP0/ISqUdqzyvpono5mlDFe6T0jo1mmutNrH3FU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8gPT6zUsuLwCuR29VBaLnJ5kdT6EBBKStO0f2DKjNN7zlryEk
	UyJZgAGvcsFv5MSC1G76Bov+h0VAr9ZlH+gt6zv9pJbwzCSRjP32TWB7+frP/S3QdVtNZA9gykL
	Ak7lxXvhoewvGkQ0y9sfp/ylwh0V6H8aGOjlDyPEbbcOBUawpkg==
X-Gm-Gg: ASbGncunMPOc+7OQY3czh1NSOSqOyl8FA+0QOa7jWdFYRDPjd8DkI+0PouUm+IgTqam
	LKVx693VHC2xtTWV0c6JEU9w0Eo29TpqiRJC9AtWNBElbMi0L11F33ELuWBQMToQ0wzZtvwqtgf
	m2/1U0oZgDpHylNCOyicttxnijzvj0tD61OZ3najK+eKric5UVr9TWpP4mbOG9kha8uO7QWR/4S
	A3dXi1MvlohrY9KwbY18j9hwLRb9tNRDbeCDCX2qxACM5zl2DRPTKtE1S/pWC+z1b5Q3II11rZf
	RLJjT4U0Kg/a/oxsZ3oGtIhl0cdO7zCJH6KAX8h1lvVSMGEoCrhJxOkK+tuHQ9o=
X-Received: by 2002:a5d:47cc:0:b0:391:3049:d58d with SMTP id ffacd0b85a97d-39132b58ad8mr9968028f8f.0.1741600461035;
        Mon, 10 Mar 2025 02:54:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEgn6vs3wtpQflZqcFKB+5gsLSC3ji/MtXlKgd119Pz3EhyxOK5skvoV6airBMnFiGNkKyOOg==
X-Received: by 2002:a5d:47cc:0:b0:391:3049:d58d with SMTP id ffacd0b85a97d-39132b58ad8mr9967987f8f.0.1741600460622;
        Mon, 10 Mar 2025 02:54:20 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912bfb7ae4sm13985560f8f.5.2025.03.10.02.54.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Mar 2025 02:54:19 -0700 (PDT)
Message-ID: <35eb4589-fea5-47e6-a0f2-c30cc7afd72d@redhat.com>
Date: Mon, 10 Mar 2025 10:54:16 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2 10/21] qom: Introduce type_is_registered()
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
 <20250308230917.18907-11-philmd@linaro.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250308230917.18907-11-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit




On 3/9/25 12:09 AM, Philippe Mathieu-Daudé wrote:
> In order to be able to check whether a QOM type has been
> registered, introduce the type_is_registered() helper.
>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  include/qom/object.h | 8 ++++++++
>  qom/object.c         | 5 +++++
>  2 files changed, 13 insertions(+)
>
> diff --git a/include/qom/object.h b/include/qom/object.h
> index 9192265db76..5b5333017e0 100644
> --- a/include/qom/object.h
> +++ b/include/qom/object.h
> @@ -898,6 +898,14 @@ Type type_register_static(const TypeInfo *info);
>   */
>  void type_register_static_array(const TypeInfo *infos, int nr_infos);
>  
> +/**
> + * type_is_registered:
> + * @typename: The @typename to check.
> + *
> + * Returns: %true if @typename has been registered, %false otherwise.
> + */
> +bool type_is_registered(const char *typename);
> +
>  /**
>   * DEFINE_TYPES:
>   * @type_array: The array containing #TypeInfo structures to register
> diff --git a/qom/object.c b/qom/object.c
> index 01618d06bd8..be442980049 100644
> --- a/qom/object.c
> +++ b/qom/object.c
> @@ -100,6 +100,11 @@ static TypeImpl *type_table_lookup(const char *name)
>      return g_hash_table_lookup(type_table_get(), name);
>  }
>  
> +bool type_is_registered(const char *typename)
> +{
> +    return !!type_table_lookup(typename);
> +}
> +
>  static TypeImpl *type_new(const TypeInfo *info)
>  {
>      TypeImpl *ti = g_malloc0(sizeof(*ti));


