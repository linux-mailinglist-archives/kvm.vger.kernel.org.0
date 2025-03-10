Return-Path: <kvm+bounces-40587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A9BCA58D0A
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 08:38:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C11B37A2B92
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 07:37:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA465221543;
	Mon, 10 Mar 2025 07:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bO2g/kjp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2451F1CAA70
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 07:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741592307; cv=none; b=bDrH+/0HeMuOprU7tG46ASwTGrCflWzjbMdL0hfV8KgzVxPwaRIy/buCIj7ncYcg83sYZFrm3bMSqvrHTPgTN7sifkgsczHYpukr7sN9XBpruoZWOQClsvUMkTm5K7Tb/i3PHQhZdXVB9wL5FiabtlQXTk7NdNmD9rdrH5u3/0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741592307; c=relaxed/simple;
	bh=1OXJRubtXFMW2KYDuJU4NAsfR5xoiHagHY62jO57foE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MIMFJmOzMjXMe2sbTcy7cI8PTYkV5lZrown91VMNHWjaJIC2tZuOlvth69kxZCdD18Emtw1bCknj/Zn2KMzqBf2GTF3gthv2nD5cV585t6OyRCf1wFJPQhOVP8T9Njt+MQhmiCMV0PXP2yXUJoCXsayCDV74gYbcFWr8gPpLMKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bO2g/kjp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741592304;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fcGMiPuXUpwi+/5XTTpJX6j45pWqFypmx1+7cGeA7kA=;
	b=bO2g/kjpLafnCg9lv85XnUBKBDyrBGat+pZjeHjQhlDid49QHIzcOuvUI0JHe3ctSuciKF
	vM+d4dyeNk3liZoQfhKamdYkNn2D4NwNgK5JilDo5+VzlxS9ITScTcMpVyNMY1MYO8pUGh
	iKwT2YqvIl1YQikXlISqPq4ZJmD/j6A=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-iOWos8JDON6Gibq0pOG6iA-1; Mon, 10 Mar 2025 03:38:20 -0400
X-MC-Unique: iOWos8JDON6Gibq0pOG6iA-1
X-Mimecast-MFC-AGG-ID: iOWos8JDON6Gibq0pOG6iA_1741592299
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-39137e17c50so790289f8f.3
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 00:38:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741592299; x=1742197099;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fcGMiPuXUpwi+/5XTTpJX6j45pWqFypmx1+7cGeA7kA=;
        b=Ngrfi/Byb0f1njx3R9R5SeXO85mykk+YCZDx2e0FhVieQKGmOUCSAltB04Z0dcv9Zw
         ryEHhu20gjlfk9yfXzXaNkExK+qsVP1xRXVIePFVZoOsVs9bjtvQU8Nj7odA547PtuCt
         9wattrdkwkOjtQ2upgFWUbVRNKBwRIsudEsLnUK+pUT13/Fzc1XvxvBMtmmr72TZ3YXi
         Kth7MWoGyTcfcGf2wuFwpBBeWhfLf+gleVOTovKn0jeoQ3dsDEkpQycdS1C7QXnMtt+7
         tdxz4vaq3ZBbQR4TPvmP0sntyvpsJf4ppD+pR9QeXDwa3MEVM9AM3Ivw2dhgg2kGdH/t
         IRCA==
X-Forwarded-Encrypted: i=1; AJvYcCVu+ZSFRHrBTkBUr+7woPyRQ65DMT4/x10pVb9bE/zjFLIb8yujIdU5USfIs/WvO0CVyAo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0IfFC5IyXmrQGfhRpcBgKcfD1LLea3yyGbNG0q5YR0r0KzA+e
	usTkja+Tx6ZsxyeSy7Hxr36d8W1LgjOtZq/XyNy+pYPGKvcn/J+b0SXM7eEpCnk36emjUbltTD/
	YBNviRWaNiSytEGmfgBI/opg/43x7jnfJv/MVRRb4gXEE+V1ySg==
X-Gm-Gg: ASbGnctA/bxCOzHiHb6AQMcv74AhtLY248hXEWQ0yr2D3SxWC/J5/lxByrBEUGPySQj
	TlWNgJ2SJUXKWOov16bBwJxkHvexoXAt3Fi9yTwWAniyD6+3GAC+ys856zI36clYNazmQUkkqx3
	HbTtPiffOvsr0iuwNzI7QX39iauOS2hKIgrFIUk6v3s39+BpsW3DzxfUm3sDWEmhUtgk7DAwUAS
	1QR13ll5Xg1husXDys2MJckEj/yX/NoULsMWmj1q2TbSQD0kVanbp8e5RTNh5LSCyAYuk8WOND8
	Osd9MouT3M9pyibBb+DPphYPCTU7qEzLD2rmyW6u6BFM3DB7o6+pzg==
X-Received: by 2002:a5d:64aa:0:b0:390:e853:85bd with SMTP id ffacd0b85a97d-39132db1108mr8321568f8f.48.1741592298833;
        Mon, 10 Mar 2025 00:38:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE0MGS9KJUmdCejnHIUD/RZQ1jDAmK+3msRX4LEXUMNgnJkjKsldrWGKI/drvwRgRDBSDmiVQ==
X-Received: by 2002:a5d:64aa:0:b0:390:e853:85bd with SMTP id ffacd0b85a97d-39132db1108mr8321532f8f.48.1741592298503;
        Mon, 10 Mar 2025 00:38:18 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:9db0:474c:ff43:9f5c? ([2a01:e0a:280:24f0:9db0:474c:ff43:9f5c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bd435c88esm164018355e9.36.2025.03.10.00.38.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Mar 2025 00:38:17 -0700 (PDT)
Message-ID: <6c9b7ba4-e894-44b5-8a35-eee310c50c94@redhat.com>
Date: Mon, 10 Mar 2025 08:38:16 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/21] qom: Introduce type_is_registered()
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
 Eric Auger <eric.auger@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 Ilya Leoshkevich <iii@linux.ibm.com>, Jason Herne <jjherne@linux.ibm.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>
References: <20250308230917.18907-1-philmd@linaro.org>
 <20250308230917.18907-11-philmd@linaro.org>
Content-Language: en-US, fr
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Autocrypt: addr=clg@redhat.com; keydata=
 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
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <20250308230917.18907-11-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/9/25 00:09, Philippe Mathieu-Daudé wrote:
> In order to be able to check whether a QOM type has been
> registered, introduce the type_is_registered() helper.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>

FWIW,


Reviewed-by: Cédric Le Goater <clg@redhat.com>

Thanks,

C.


> ---
>   include/qom/object.h | 8 ++++++++
>   qom/object.c         | 5 +++++
>   2 files changed, 13 insertions(+)
> 
> diff --git a/include/qom/object.h b/include/qom/object.h
> index 9192265db76..5b5333017e0 100644
> --- a/include/qom/object.h
> +++ b/include/qom/object.h
> @@ -898,6 +898,14 @@ Type type_register_static(const TypeInfo *info);
>    */
>   void type_register_static_array(const TypeInfo *infos, int nr_infos);
>   
> +/**
> + * type_is_registered:
> + * @typename: The @typename to check.
> + *
> + * Returns: %true if @typename has been registered, %false otherwise.
> + */
> +bool type_is_registered(const char *typename);
> +
>   /**
>    * DEFINE_TYPES:
>    * @type_array: The array containing #TypeInfo structures to register
> diff --git a/qom/object.c b/qom/object.c
> index 01618d06bd8..be442980049 100644
> --- a/qom/object.c
> +++ b/qom/object.c
> @@ -100,6 +100,11 @@ static TypeImpl *type_table_lookup(const char *name)
>       return g_hash_table_lookup(type_table_get(), name);
>   }
>   
> +bool type_is_registered(const char *typename)
> +{
> +    return !!type_table_lookup(typename);
> +}
> +
>   static TypeImpl *type_new(const TypeInfo *info)
>   {
>       TypeImpl *ti = g_malloc0(sizeof(*ti));


