Return-Path: <kvm+bounces-16397-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D8A78B961C
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 10:06:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6EC861F214CB
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 08:06:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 156AF3F9D9;
	Thu,  2 May 2024 07:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="To57n73T"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9FB286BD
	for <kvm@vger.kernel.org>; Thu,  2 May 2024 07:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714636731; cv=none; b=hLFjs8ur08DOwCGr5mH6Ol8IO/7w8NSMad2fE/2t+8Z/FCAYnVW6tvjjYhL8/x9XNVv5eoiW7FRS6h5jWhJYE6p78ZpNMDzyAHD53sAlyFtZ26igOOXmPNrruzKF5njkO5+tphTUtHl2rVtTDkz+meEyIzQSFDUdLc4x4qORa54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714636731; c=relaxed/simple;
	bh=M6bNAlUWFAUVedhVV7/Ef/MA8rIvBKks3JV/imDXzTg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rwsSCJ3ZO5kNMq/LuVZoLHECO+A0tAm86E2R68IM+s/bKU6ZvvLxATQyyfP0Hfy35qRPzC0vlaAu5SE8C4fwqFTp7UZlKBY7b1tLB0Neqv8wah4mFxZK3g75nH+FBC5Jd0ssmqs2uVt7hk9BfcC4q+2vkSD7h2A2lPEmORPvG5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=To57n73T; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714636727;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CHP3GjDVgcLRBj76hOfDQWMiYZpjeo5fFoO4QDsCmSE=;
	b=To57n73TMbg+vHJ5yJnKmvUIV5NkL0CKdF45p3pusXxyDbP3wzgg5zzUszvvxByeFjX4cI
	vrylsIIkypnm0kZ6IxpYJkmD3AYZ/mfAmHI2lf45zvD8ye/0DAoGGYpvC3kxymQQF2te6P
	pvcnHVZoyTPvTsKI4UYSFGyxiJkHVtE=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-349-VeUtrOazPLKQ9P675e_L0A-1; Thu, 02 May 2024 03:58:44 -0400
X-MC-Unique: VeUtrOazPLKQ9P675e_L0A-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7926c07a543so165691285a.3
        for <kvm@vger.kernel.org>; Thu, 02 May 2024 00:58:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714636724; x=1715241524;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CHP3GjDVgcLRBj76hOfDQWMiYZpjeo5fFoO4QDsCmSE=;
        b=iEkXcanbvUuK75s8fBWtWVrPkbXmqaZzeKS0vZU1Ng3O3fPmKNBXB9qX0aQNEnE2CS
         i2H+0cO4x7oiA3FEs1cKeJdddqoYvxsGQgmPKShaCH4pfkhSuzBdBzpUr2goafZ4a/36
         8vP0eno56UkFnzD+aDbFeA9TWQK2uDoRp7v4bh+jodqUa3nibM9952qQy8QRkjoIHCSC
         97085AU+RR3QjbYjAlIqbPDIhsb1lakUE8l6uqJhBW3OYHCOLZjN1sq/nHxvct/9l/r1
         Hnrdfu8US1b8wZ4w9sIWtlpnoNX5SRW6zsrCorBYTL/0/RWdM+RCGDdarhwiqpTaVUWt
         adfA==
X-Forwarded-Encrypted: i=1; AJvYcCUR7+riG6pNi6GTlfC8Si/NXZCAgH5poxcNE10JjKWxbFXvOrybAmLvI7tmWQ6UU4PtfMEaW8+Gj6krCgo2sr4rYoAd
X-Gm-Message-State: AOJu0Yy+ZPr3YyxDBV8SIgaIv0xpw73fmqSR5hKfXeBAjOvoKDWJi/uu
	cvD9CltHjswDE6Td6h5xuikgtIi7qg1c4WeiW0MbsE0P5rVhCBRaSkkgBWLL6qMRg9tA8vDRUGE
	LMFr4nuU1hIMnSwONX/8UnU/jGZ7z30ZtclraZhMlioqOHiudSQ==
X-Received: by 2002:a05:620a:22a2:b0:790:9e68:db10 with SMTP id p2-20020a05620a22a200b007909e68db10mr4788255qkh.5.1714636724076;
        Thu, 02 May 2024 00:58:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGfPs/80kVsOGbEIowCh7I12Up+qoGrvJCwcHBhGjIAUjboedJxmagzloxRfQpATVk8ujnjNA==
X-Received: by 2002:a05:620a:22a2:b0:790:9e68:db10 with SMTP id p2-20020a05620a22a200b007909e68db10mr4788237qkh.5.1714636723717;
        Thu, 02 May 2024 00:58:43 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-43-179-34.web.vodafone.de. [109.43.179.34])
        by smtp.gmail.com with ESMTPSA id g4-20020a05620a108400b00790676d0fe2sm176981qkk.121.2024.05.02.00.58.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 May 2024 00:58:43 -0700 (PDT)
Message-ID: <c0c32041-38b8-4918-bd6f-7637ce515fd2@redhat.com>
Date: Thu, 2 May 2024 09:58:39 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH] arm64: Default to 4K translation granule
To: Oliver Upton <oliver.upton@linux.dev>,
 Andrew Jones <andrew.jones@linux.dev>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
 Eric Auger <eric.auger@redhat.com>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
References: <20240502074156.1346049-1-oliver.upton@linux.dev>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240502074156.1346049-1-oliver.upton@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/05/2024 09.41, Oliver Upton wrote:
> Some arm64 implementations in the wild, like the Apple parts, do not
> support the 64K translation granule. This can be a bit annoying when
> running with the defaults on such hardware, as every test fails
> before getting the MMU turned on.
> 
> Switch the default page size to 4K with the intention of having the
> default setting be the most widely applicable one.

What about using "getconf PAGESIZE" to get the page size of the host 
environment? Would that work, too?

  Thomas



