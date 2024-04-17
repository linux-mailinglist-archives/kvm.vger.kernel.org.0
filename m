Return-Path: <kvm+bounces-14963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F20598A835E
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 14:47:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 53A83B216D6
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 12:47:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82DB613D265;
	Wed, 17 Apr 2024 12:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O/r/3tJr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC443D72
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 12:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713358050; cv=none; b=pwC2D8tvCZijgosu1UkX+f3+hKXRQpLgAiYOFT/86u48dCoY4KmlY8DULvrsygzd9LMYK/iqw6G/oTTtA+aoarxpHTtJkVTruXi1gXFAYLv6O7G3qO4bI+kWL9q4SOljtp6wyxUKX9qTHUmgmhH38qgOPvMutm953BAD2XsI1ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713358050; c=relaxed/simple;
	bh=kgMTTNaQ41H283hTf4Cx0qam6oDRZjIKFuf0V/Qv8fQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OGIdBZfjIXhnvCMGSwmwxTitLD9J7pJmq9iWyTRyS7ZNPrYDf2tLPivYaORI/CXHEQfzPmhEitMt57DgXWrEoz3T0obqxO6cv4U+4xkRsV5UtWt7taf9hJ/BfCcG5dkqBNn1q3IjKXSYDDbaOR8TZbK7Qamb0eTNudKIcjSTJ08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O/r/3tJr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713358048;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6neZnIM4zQvOSiYD3BD6EG/L+KQ7xlZ8zd6Zxrru2bc=;
	b=O/r/3tJrlGNOgvqkuivuY1gfnktCoIQGJTDH6ySd21ndWNvKBRYImBhbHY25Kcf5kSncZf
	l8RWSIZMpbeFVHkFqeflixynfpYJmKywDkJfNKQ6n8Y6sXLohjk7ZA6/xWHc4hCRrDptVl
	WbRU68yW7WhyqtLL/0RZuwm/IaIn+9s=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-168-TE9UD1dTPcCdwpJa-6Peyw-1; Wed, 17 Apr 2024 08:47:27 -0400
X-MC-Unique: TE9UD1dTPcCdwpJa-6Peyw-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-417cf901ab4so22571125e9.1
        for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 05:47:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713358046; x=1713962846;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6neZnIM4zQvOSiYD3BD6EG/L+KQ7xlZ8zd6Zxrru2bc=;
        b=G2hUCOtk9qiQ3V3rufMs1K4Ozbnq9DVf5pt6fu1l/99dX0tGZ/MW9iSso5uEn0HT/X
         c/ObhYYyXridad92CEHLBuudeHllCL50OOqjkX/9voP/FrpfDAsiVQbCjosl39Kcq+5V
         DdUNPpeTjrSVXVlXoakOxSnW7fSEuWevCpt4lYEcT8Id9CMZEz+zGtPxpjt7+HIK4Qub
         QDBK0MhRvT5WtAUJonta5SpSIlSfSdL23k6YEJzedAA5IemK57yPoAplRa75t93zZ8kh
         9gHRSf6si91QzZ3rGjWRF1Icni9z53DPlEUSnBcr7c6MXlZeE4Cl212zL096ZoZo7gbh
         1okw==
X-Forwarded-Encrypted: i=1; AJvYcCWdoq+T3RJNhFQjlB9Ey0zwUGbo8gT3dL1H8DZni41BrBxaGt222D5oXcux+XrzVMAIxhdXebiLthfcV8LMOCSLydHA
X-Gm-Message-State: AOJu0YynGPxKBXOdds8RBn+8dfywPKhAxMOJFnu01mP7lykBLmVPH4+X
	GtcZ7wYpGEvT0DfRgNBGG01Iw9qatFUEyfMVXjcvWFofLzFQAgQgAa+5y7doeOU6Pt91FptRwYu
	ObtTNPzyrio+oj9mqk798iJhNexXfI3Pm1HhVIMyH8V5b78jtCg==
X-Received: by 2002:a05:600c:4f89:b0:413:f80f:9f9 with SMTP id n9-20020a05600c4f8900b00413f80f09f9mr11608446wmq.25.1713358045828;
        Wed, 17 Apr 2024 05:47:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFhLwVof5ztMHPDkvE33UvEQlz/QFIkU/DttVah8FamM3AipfWS1hmkqSLm0VjbJTikgXzjXQ==
X-Received: by 2002:a05:600c:4f89:b0:413:f80f:9f9 with SMTP id n9-20020a05600c4f8900b00413f80f09f9mr11608431wmq.25.1713358045413;
        Wed, 17 Apr 2024 05:47:25 -0700 (PDT)
Received: from ?IPV6:2003:cb:c745:2300:653:c844:4858:570f? (p200300cbc74523000653c8444858570f.dip0.t-ipconnect.de. [2003:cb:c745:2300:653:c844:4858:570f])
        by smtp.gmail.com with ESMTPSA id u12-20020a05600c19cc00b004182cd07133sm2730213wmq.3.2024.04.17.05.47.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Apr 2024 05:47:25 -0700 (PDT)
Message-ID: <5554ef27-bb94-4e22-ad86-92053681879d@redhat.com>
Date: Wed, 17 Apr 2024 14:47:23 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/2] s390/mm: shared zeropage + KVM fixes
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Andrea Arcangeli <aarcange@redhat.com>, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org
References: <20240411161441.910170-1-david@redhat.com>
 <Zh/EkOPBRS1q0ru2@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <Zh/EkOPBRS1q0ru2@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17.04.24 14:46, Alexander Gordeev wrote:
> On Thu, Apr 11, 2024 at 06:14:39PM +0200, David Hildenbrand wrote:
> 
> Hi David,
> 
>> Based on s390/features. Andrew agreed that both patches can go via the
>> s390x tree.
> 
> I am going to put on a branch this series together with the selftest:
> https://lore.kernel.org/r/20240412084329.30315-1-david@redhat.com
> 
> I there something in s390/features your three patches depend on?
> Or v6.9-rc2 contains everything needed already?

v6.9-rc2 should have all we need IIRC.

-- 
Cheers,

David / dhildenb


