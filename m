Return-Path: <kvm+bounces-26239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F8D8973652
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 13:36:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B36A287057
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 11:36:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C118618EFCE;
	Tue, 10 Sep 2024 11:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HT4Lrww5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC701684AE
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 11:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725968204; cv=none; b=V4Gqz1jS1RfpByNqdDqNObWA76T4gMqQ8Gof+KlVsZG2eTgsPwVFb3JV5G5/BFzFtmWfb1/mR9iCkqGo7H84Znx3FOKmZARojxrP1pFlAxCc3Ty2/n79abXuwkzIdR5sSYaQ/2wiEvCLbWuWU1LraOjzm3fdkokjk3Me34KhQSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725968204; c=relaxed/simple;
	bh=ZtsvNdUTBZKLzPa6P4YfJoTHq8HtddfUs1LNwe2eHIY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LYrnp2Dqf/IyzuAuRoBLFq5H5nozypfWX36S33OI+fv7hjMDBV6T4TkMbiPJpIHwr9W4OjJgBNexkiAfQ36p0EBzA3DAXK//E782bx9iDFEM+QL/stTLZ5D9WUr2erTBkUhJdD4KMeMVMW7ezEBZuEGf6h6vVP4MIXg2pCaBdJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HT4Lrww5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725968201;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LoQghBT4B7DKrzS532OLio+2CVw/dfJ6mhzi4/2pTTA=;
	b=HT4Lrww56+lSTvyUzg1ucNcD3E71tS4h2yyAqxsRGNGRCnRo9bysYpOXTwAISBlLBXxOIS
	ybKfPw2sx2Ri+e1nCPUWy8E3MPtZlD678MkDgEU5Ejx2IEaOd35CsaYGEXztMwxrAg+4O2
	5Z8l8zVWqBdGdpW2hWX56LEzmd97u78=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-55-WtanG2ytM7agSTvWRIKoyw-1; Tue, 10 Sep 2024 07:36:39 -0400
X-MC-Unique: WtanG2ytM7agSTvWRIKoyw-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-42cb050acc3so15421135e9.1
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 04:36:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725968198; x=1726572998;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LoQghBT4B7DKrzS532OLio+2CVw/dfJ6mhzi4/2pTTA=;
        b=dpdKCoC2Ps52L9PFNi/T1eYlAwNxt89ziVWbsEpabifNWx63bwBbUoq8sb4A82EMkz
         iS9jX9mfMc7QyjRfif1npdDb128CpAPunKi6jpnPjERPpktC0z+IMMIROGO9EjQA1DYu
         4JtvC0rucMV3jY9VMsUhSy/X+45CgD1s+Fqx/2UBddsWldzJ57q3eBqwyZOH2Lzx26GG
         kHytG6PzylEJp0ajez0JmKq7oZjfAYRZzH6cxjqBYoYzVTDyAezrqpzkK10efAJOjsrb
         o/OQpOAav+OJcLKg0Z6FuiePIueay6KyDswH7eIz2KwN/Pd6Wls965jFjHhfCejxa+J6
         /Xwg==
X-Gm-Message-State: AOJu0YytBRcRIylOOugdyk7bgwQ/vovmRjrFiQMmcVHB8ETovqaekjNa
	EIcq7Ufbp+TVRtA3ExkfJJsqysdKrhBMn1pVbkAV1RrYpfYpSVSwKAsY132zE7gTbELYIggM3CW
	2jg/R/0WF+ADyhPfKvmarAbTZ82iPFZUk7LsJZ2AyOpblq2FH4g==
X-Received: by 2002:a05:600c:1908:b0:42c:b697:a62c with SMTP id 5b1f17b1804b1-42cbddce6b9mr17288775e9.5.1725968198571;
        Tue, 10 Sep 2024 04:36:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGFmSY0w+YvqViM5UzUqZ+oaU7+gerEpMcjBlixm/x3CFSbfqcE/MfPL0it39IkO+KrCGzHHg==
X-Received: by 2002:a05:600c:1908:b0:42c:b697:a62c with SMTP id 5b1f17b1804b1-42cbddce6b9mr17288395e9.5.1725968197576;
        Tue, 10 Sep 2024 04:36:37 -0700 (PDT)
Received: from ?IPV6:2003:cb:c706:b600:cfda:b383:a116:a940? (p200300cbc706b600cfdab383a116a940.dip0.t-ipconnect.de. [2003:cb:c706:b600:cfda:b383:a116:a940])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42caeaba04csm108840495e9.0.2024.09.10.04.36.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 04:36:37 -0700 (PDT)
Message-ID: <ec3337f7-3906-4a1b-b153-e3d5b16685b6@redhat.com>
Date: Tue, 10 Sep 2024 13:36:35 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC RESEND 0/6] hugetlbfs largepage RAS project
To: =?UTF-8?Q?=E2=80=9CWilliam_Roche?= <william.roche@oracle.com>,
 pbonzini@redhat.com, peterx@redhat.com, philmd@linaro.org,
 marcandre.lureau@redhat.com, berrange@redhat.com, thuth@redhat.com,
 richard.henderson@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
 qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org, joao.m.martins@oracle.com
References: <20240910090747.2741475-1-william.roche@oracle.com>
 <20240910100216.2744078-1-william.roche@oracle.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240910100216.2744078-1-william.roche@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10.09.24 12:02, “William Roche wrote:
> From: William Roche <william.roche@oracle.com>
> 

Hi,

> 
> Apologies for the noise; resending as I missed CC'ing the maintainers of the
> changed files
> 
> 
> Hello,
> 
> This is a Qemu RFC to introduce the possibility to deal with hardware
> memory errors impacting hugetlbfs memory backed VMs. When using
> hugetlbfs large pages, any large page location being impacted by an
> HW memory error results in poisoning the entire page, suddenly making
> a large chunk of the VM memory unusable.
> 
> The implemented proposal is simply a memory mapping change when an HW error
> is reported to Qemu, to transform a hugetlbfs large page into a set of
> standard sized pages. The failed large page is unmapped and a set of
> standard sized pages are mapped in place.
> This mechanism is triggered when a SIGBUS/MCE_MCEERR_Ax signal is received
> by qemu and the reported location corresponds to a large page.
> 
> This gives the possibility to:
> - Take advantage of newer hypervisor kernel providing a way to retrieve
> still valid data on the impacted hugetlbfs poisoned large page.
> If the backend file is MAP_SHARED, we can copy the valid data into the

How are you dealing with other consumers of the shared memory, such as 
vhost-user processes, vm migration whereby RAM is migrated using file 
content, vfio that might have these pages pinned?

In general, you cannot simply replace pages by private copies when 
somebody else might be relying on these pages to go to actual guest RAM.

It sounds very hacky and incomplete at first.


-- 
Cheers,

David / dhildenb


