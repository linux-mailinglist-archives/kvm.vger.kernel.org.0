Return-Path: <kvm+bounces-56076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77A63B399D7
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 12:29:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 87949173126
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 10:28:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B05030DEA1;
	Thu, 28 Aug 2025 10:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I9+wJUjC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B22430BBA8
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 10:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756376795; cv=none; b=N97HdmG91c+G2SSQhtsF5pt7G5zzi0fByLDc/wZgxYMl1nBK+I0i5HIwCJkFOmhdpXSvHpzY+nb96EKQgfoXcBeXaMta0IlCYqoezyyPukEBg4/j6RXyrRT5RgyIp4uOMRjoJn/bpXR9IYxpf/iErEvPNFwdg5yQ5wlUA6IAryQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756376795; c=relaxed/simple;
	bh=sh2LcQ6Lxm7TMsk0fKFwAED7+3qWa4eQO4kONfe0irc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f88Z7juRjorneRuV364FQfEAU2giQzddkfKY4PHIVVl94x9BMBxQC6PsXhPuTqESNSkFJeCtyhA2VoY9vGI1fkqd7lVHev95uOK9RTarIlhgxT3Qk/ZCf9MzVdMRm7+83bj/dgMsgYbGheXb9qnkeAEonMUsA/B6vRk9geOkJaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I9+wJUjC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756376793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KriyZgiAZRJDnfHsymUHd3lqzo8k4QI+bEtwKwBmcAI=;
	b=I9+wJUjCWMWKsXEC8F0EIYeIfWv3MLvtWOehQANpiV3rfgilBWYciEDh/NcXFnRoor32Gw
	nGDUcHZhjMs1Jcg5yi+kEPeKhhI7duPWQRGTINrf6CLrWzwUWPeBB4mDAHrN+mMcPa2Xty
	XkJMZff2Kf5DgofQ0HUTmYwZwqiantI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-3AONsdm1M7OISW7TwIeGng-1; Thu, 28 Aug 2025 06:26:31 -0400
X-MC-Unique: 3AONsdm1M7OISW7TwIeGng-1
X-Mimecast-MFC-AGG-ID: 3AONsdm1M7OISW7TwIeGng_1756376790
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a1b0c5366so4956245e9.3
        for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 03:26:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756376790; x=1756981590;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KriyZgiAZRJDnfHsymUHd3lqzo8k4QI+bEtwKwBmcAI=;
        b=A+hbGNuuEGmpnNfjKZhA3h2yFYolcBCsZB9JwImpiSrR7oud01vvOT2SBvxGvA9oAI
         rKl4W85V4C2OlF9KK4N2ahGu9PXKaXgI8Gc9XvGM7/Pn3URjesClNTkFBWJV0lSjXl3+
         nKLImX0pGJ+15OrLnq6ZECQvXIhbhkv/8pP0V8VbSZe9f7l9h2D3jckAzpyKUX9tU4X2
         X+VjNqSkxmRReEpeRK5RinWlSYkjOAJQOCkm5247nzLVm3C9CSKdcvZZgq6S+pAXfc6s
         LDI5WgkAIHl3QQsff1MJSGWWU77WQe94e7supy5W6xukDEeccL7DhcMJy9hEok7fXvrD
         qFdg==
X-Forwarded-Encrypted: i=1; AJvYcCXitOs0MkoTk+iXuQbqd/04y3ydW3jpo7dYV9gyEBsEbqwMIR8WioiDldsVKjVLcmKlSHA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJp/7Y95beBRnNOOEYSDsKYYNmLdpg7obbhQqwkJILbaKddAin
	PV01N1cgT6GaFQlanHjMiZfdJmYRiPLYreNEhu766XFKvKQxQF24J1CPYz4wko2DxegvlflKLSS
	9KxL7KoROUoSnhcamevmk5Qhyti4b3P7aYvqb9BqBstiOKjetpRrWIs0Xalkw1j8Xltg=
X-Gm-Gg: ASbGncuTe+3j6ZnefOG9OQJotsAagD4S0H3TNljWHS5OhAZhwybMkK7+Fm/uYUU1B2c
	ykmBbvoEgxdfQNl/qW4lT2BMs1O0Sq1erPkwKAFyhfcrxm02WG6nKz16XSG6BZog2ALeSpQ0stT
	pzWD53eHPrqNveeB9S5DjsDuzxhcNM+xeYixDvxb2M3uP9CCLsI6DSGgqtlEs1FJcBvj6LZtJU9
	U1UXtPSNTKnoOU3ywwx8XOlS59LrEsLbUavw3quT/KMKelVdsBT2ODoWwinT4Odcm4u8sqcigHA
	Ujz2jpBtg4Q/HD9jw8ex4clswVBe6JklLhlkV2llV4Db3LLlpAuZl1vwWUOSSBNvAnxlaKMmvxq
	RjUTwcvOt5C+aldnoh0KkSimAVZrhYBkKE4kZUzehNgAjGzU/ssSauF0guMitX6LU0aw=
X-Received: by 2002:a05:600c:4f4d:b0:456:1b6f:c888 with SMTP id 5b1f17b1804b1-45b62586a5dmr114585635e9.23.1756376790544;
        Thu, 28 Aug 2025 03:26:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFtFlmG2bk+e9nYytQDuLDUJ8uuAXsdALOuDZVwchnxhUM2yFRl9mv4ZYrhg+X+WjfZRuMlZg==
X-Received: by 2002:a05:600c:4f4d:b0:456:1b6f:c888 with SMTP id 5b1f17b1804b1-45b62586a5dmr114585345e9.23.1756376790087;
        Thu, 28 Aug 2025 03:26:30 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:c100:2225:10aa:f247:7b85? (p200300d82f28c100222510aaf2477b85.dip0.t-ipconnect.de. [2003:d8:2f28:c100:2225:10aa:f247:7b85])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f31d083sm67062965e9.24.2025.08.28.03.26.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Aug 2025 03:26:29 -0700 (PDT)
Message-ID: <093db25e-12d7-4372-873b-72f189117936@redhat.com>
Date: Thu, 28 Aug 2025 12:26:27 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 11/12] KVM: selftests: cover
 GUEST_MEMFD_FLAG_NO_DIRECT_MAP in guest_memfd_test.c
To: "Roy, Patrick" <roypat@amazon.co.uk>,
 "seanjc@google.com" <seanjc@google.com>
Cc: "tabba@google.com" <tabba@google.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, "rppt@kernel.org"
 <rppt@kernel.org>, "will@kernel.org" <will@kernel.org>,
 "vbabka@suse.cz" <vbabka@suse.cz>, "Cali, Marco" <xmarcalx@amazon.co.uk>,
 "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 "Thomson, Jack" <jackabt@amazon.co.uk>, "Manwaring, Derek"
 <derekmn@amazon.com>
References: <20250828093902.2719-1-roypat@amazon.co.uk>
 <20250828093902.2719-12-roypat@amazon.co.uk>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250828093902.2719-12-roypat@amazon.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 28.08.25 11:39, Roy, Patrick wrote:
> Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
> ---

WARNING: Missing commit description - Add an appropriate one
WARNING: From:/Signed-off-by: email name mismatch: 'From: "Roy, Patrick" 
<roypat@amazon.co.uk>' != 'Signed-off-by: Patrick Roy <roypat@amazon.co.uk>'

-- 
Cheers

David / dhildenb


