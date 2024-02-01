Return-Path: <kvm+bounces-7753-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0855845ED8
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 18:47:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2533E1C25107
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 17:47:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B61CF6FB93;
	Thu,  1 Feb 2024 17:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ihK5pDi1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327247C6C3
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 17:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706809614; cv=none; b=kNx5/k7fZRN4Z8+snu3oFlljwXHZMYorCvmaVpuMYvKCUmczQufbgAS4yFfIaeB1L90A5afG0ZXebehqXGWKc6nZAWdZfrn7JcxgtRvY8kzVqClA2BzHwAFp3ehubpGN6LV/U4VmpUVxN1x2rGGurQDy4fY/+FaJYeUU+iB8Y3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706809614; c=relaxed/simple;
	bh=UtrCl+//nMzOrjxzTW2hJCrpbv42WlAfJ1HSYNjMd1Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ERezpxOrNfXuxcFpsvkKUNE6odBlK0YMDujM/J2fjDmAaTbGQwSwaP2jjxXD4CKMRP6lELqqPSp1LIjiOkszqWYT0NpHp0oV49g+8Fy1EHfQxrEN6DjZxJjemHG0tO8WoM3y/QheY76u7OSPZPf+IT8yEOFT7IwpgpsiJp0fXg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ihK5pDi1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706809612;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8Pfr4KxXg16gh4zIma5BqG45urMrXkBX1Ao+OzgSrmg=;
	b=ihK5pDi186Kjedu5CT+2qFSYlnuNjbprczMNbhlrR0Z4TpGL6eTvXQpExR78jwpbmJ+aIy
	ae6H4yLXyac9CWnJ09m6qIr3sN2pV3jCUECZ6an6wFkNJffweQdH68yM4tJVD1jgM2VFOR
	40Hnv0wtRINVOaEh9pIegYDD714QnDQ=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-139-67L0lAOLPOGpOm3-0mNM9w-1; Thu, 01 Feb 2024 12:46:50 -0500
X-MC-Unique: 67L0lAOLPOGpOm3-0mNM9w-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-78538ead61fso115297585a.2
        for <kvm@vger.kernel.org>; Thu, 01 Feb 2024 09:46:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706809610; x=1707414410;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8Pfr4KxXg16gh4zIma5BqG45urMrXkBX1Ao+OzgSrmg=;
        b=j7dyL7/RxK59pVANY1M8W5YnDajvi+zZs0AwXYJw9/e5q35FIiGhZltrkUS+gSm5Es
         uowca+oxzQ+HMenetVytd4HXoC9zA0pmOpGstGzxhdlYWZXKXufzloXO/lCHi1sMDw01
         5aYt0pJ/NaN63eJrTHdIr3sTKFrEH0dhHTOE0rJn11+Nhlm4ZDPJgY5g25npNynsuKY1
         2nHmwZCbKPik/sGT3R1SLuSAkvVfOf+DpVRIgP8sgAkzDhyOvb4suEpf9+XIeG3/467o
         A6Q8ybFrAG2jgfJ9OhjYGNqcE2ffO8gwqTWPpzXsZ8kyXXp/94oknvZ5LR+9+B0Q/iJU
         P/gw==
X-Gm-Message-State: AOJu0Yx1Hax9lzNje7ymdiemSFbZUrmy8jT1YOjkXZArS3Sz04SbzoP4
	U0TI0PfSYf+6MBDuyM5UVd32zZugB+f9NxMcA+kGszHNYwiJdhzLnWhG6/lAaiiyc4VLEuBSb05
	7Gp/I5haezAn9M97En4bjzd3OGi67vAzlmWrD4N/xxq8wUky2TQ==
X-Received: by 2002:a05:620a:4014:b0:783:f7a9:9cef with SMTP id h20-20020a05620a401400b00783f7a99cefmr4001840qko.16.1706809610359;
        Thu, 01 Feb 2024 09:46:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGVkeTVrLRcUd7YlboQiZrp4IV61mP2U3t7oYqqsWCeH9M0QO425T0tKYqDxmrKuuUO20X6Bw==
X-Received: by 2002:a05:620a:4014:b0:783:f7a9:9cef with SMTP id h20-20020a05620a401400b00783f7a99cefmr4001822qko.16.1706809610101;
        Thu, 01 Feb 2024 09:46:50 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCU3ksgcpVhUOrPNNPWWNbdI3Oocz2WpGPfCP4NRqj8Igra3/lFT+ycuOqRpZkaFR+b6rYyUnUWnS5n1Bh94rEXkni93Kxo808C/N0CcTRK7/rDFdXHyZlLcwbAQ6ivxr0OaEmDpUuzGc4U4yDQQQwmn8LW7CpxUqn2ORSbfJG/tmBEcBrsFDWZPkf/RCGXIXTbBAMw2My2fFvkoGDFs8VY+exOjZqs7PbABabYQYxcisv6eV1visCdwx8CYu6HZhiyuiJyFsffkhL2JTL4AOYnQ4RkI8u0UG4fhVjb5pwJCDkiyx/KdVTX2qmhH
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id u20-20020a05620a085400b00783f669dc18sm2605qku.118.2024.02.01.09.46.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Feb 2024 09:46:49 -0800 (PST)
Message-ID: <783ed9aa-82f7-41b7-a082-e3b75276bd7c@redhat.com>
Date: Thu, 1 Feb 2024 18:46:46 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 16/24] arm/arm64: Share memregions
Content-Language: en-US
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 kvmarm@lists.linux.dev, ajones@ventanamicro.com, anup@brainfault.org,
 atishp@atishpatra.org, pbonzini@redhat.com, thuth@redhat.com,
 alexandru.elisei@arm.com
References: <20240126142324.66674-26-andrew.jones@linux.dev>
 <20240126142324.66674-42-andrew.jones@linux.dev>
 <730ca018-cb7b-4ef8-b544-7afdfce03bc8@redhat.com>
 <20240201-522cd6aa1f8162c0c50f63b0@orel>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20240201-522cd6aa1f8162c0c50f63b0@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/1/24 15:21, Andrew Jones wrote:
> On Thu, Feb 01, 2024 at 01:03:54PM +0100, Eric Auger wrote:
>> Hi Drew,
>>
>> On 1/26/24 15:23, Andrew Jones wrote:
> ...
>>> -static void mem_regions_add_assumed(void)
>>> -{
>>> -	phys_addr_t code_end = (phys_addr_t)(unsigned long)&_etext;
>>> -	struct mem_region *r;
>>> -
>>> -	r = mem_region_find(code_end - 1);
>>> -	assert(r);
>>> +	struct mem_region *code, *data;
>>>  
>>>  	/* Split the region with the code into two regions; code and data */
>>> -	mem_region_add(&(struct mem_region){
>>> -		.start = code_end,
>>> -		.end = r->end,
>>> -	});
>>> -	*r = (struct mem_region){
>>> -		.start = r->start,
>>> -		.end = code_end,
>>> -		.flags = MR_F_CODE,
>>> -	};
>>> +	memregions_split((unsigned long)&_etext, &code, &data);
>>> +	assert(code);
>>> +	code->flags |= MR_F_CODE;
>> I think this would deserve to be split into several patches, esp. this
>> change in the implementation of
>>
>> mem_regions_add_assumed and the init changes. At the moment this is pretty difficult to review
>>
> Darn, you called me out on this one :-) I had a feeling I should split out
> the introduction of memregions_split(), since it was sneaking a bit more
> into the patch than just code motion as advertised, but then I hoped I
> get away with putting a bit more burden on the reviewer instead. If you
> haven't already convinced yourself that the new function is equivalent to
> the old code, then I'll respin with the splitting and also create a new
> patch for the 'mem_region' to 'memregions' rename while at it (so there
> will be three patches instead of one). But, if you're already good with
> it, then I'll leave it as is, since patch splitting is a pain...
frankly I would prefer you split. But maybe somebody smarter than me
will be able to review as is, maybe just wait a little bit until you
respin ;-)

Eric
>
> Thanks,
> drew
>


