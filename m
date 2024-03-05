Return-Path: <kvm+bounces-10877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F069E871622
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 07:59:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 67335B239FC
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 06:59:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C47787BAF5;
	Tue,  5 Mar 2024 06:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gjqRxLaO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2AD4500B
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 06:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709621967; cv=none; b=cWjODYItGsxta4V16bafPsxGgsV3KGhiPqYO4gvX9lcMlFg3ap/xl49avoYuGZjPpdEKRwuAI468AZDl840R589cdDWbdxtklcRHVZI76CfpljxFPgltBt9W0iXaW7459j2FBK6OYuOXWi2dtf79r3T6SYXsroH8PGOxJnIj4cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709621967; c=relaxed/simple;
	bh=jHDvZIRPKXABzaP9RkFDv7E3gNp+Hc9DWkWS3LQiguI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bDomUR8d3DNUTzq6LzqbLcO6wciePr+YChP3RMFX0kxOyXwsb7n89rvqQMNSngrSnpCQaq9ERmViXN37TKteC8MIIMItC3lWd0B2phl+cPmHoU9QV/JRXQe4Lsu+IGk273H4O90Ow/47tYL3kR1ZyFZc0T2rLXj6tS1SQfOcb7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gjqRxLaO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709621964;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9xBFTmAHpQN5UhDa+SuJqkQIR2xSKuNZi8JmjqquGcc=;
	b=gjqRxLaOD/E6YNpxJjE9yrSFgO9khYA+j05JMPPadZWJfYwfJzHBsH1N7su1MGzCDpQgoh
	lqQL/fU5YpYnTrlmsclC3dcHP7aqfJC1qkTmOgIqEWOTSCIBwBR2H/vmM15GNgQTAq3I1F
	p0vSAHuTvv8Xmw1i30u3ihtwNyRG9u4=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-471-88bL0uDjPfiUYDoFf_UvlQ-1; Tue, 05 Mar 2024 01:59:22 -0500
X-MC-Unique: 88bL0uDjPfiUYDoFf_UvlQ-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-564902d757bso3576150a12.1
        for <kvm@vger.kernel.org>; Mon, 04 Mar 2024 22:59:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709621961; x=1710226761;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9xBFTmAHpQN5UhDa+SuJqkQIR2xSKuNZi8JmjqquGcc=;
        b=rBlbzY30uXKaAml0wZlrHi2BKmgC4vRU0VogdXJe0pMGSpLijGbSsFwSu7b1udsri7
         BfTdaLgO9Wlq53TY2Et17zkl1KcP2Yi9tUEehJFKV8G58N4Z+RvDJ3giDT6PD1qsF+xI
         ABh6khkVNHs6uQ3SnI9KODm5Ss22da8us3wUVD4BUMnVCD4eKmznSjaPhgp4K8U8dgEt
         vj6bwRT5TecUsboxMVpnIsh9JY31Y+3FRGUVEiVmtsf6HZIzWgC9xRv3O5TaKFQ739O/
         aXzokssHHWJqMFLhpvWvKQVTq3pzFJkpASYRBr0MNjq3L4FNFgvK1qnI7Bv5OAz/8GrY
         5vRw==
X-Forwarded-Encrypted: i=1; AJvYcCXf4D1WyXj4apxG/nYcsebcUKVaZcdxIsUp7rT3/XN5U7kSnn75l4SHGYBYeoUcYFAds/UU3iJoVsOjMBDsa12Px+mM
X-Gm-Message-State: AOJu0Yw+R/ZFcTO8vpnGEMvpM+bjKEeapshMTCmfMarxQrpeHYImfFga
	SeiolEtJO6hz8oJ2sSXRCGnQxAG6zvWpG9e4C5aWd6mkrluU6BNQrOYuONJsZUhEcn5W8DgAf7e
	mLRp2Vd8a8JJlpJ0Wufnfqv0oZ2jnLEcGKD3RcM7VjT894B92Gw==
X-Received: by 2002:a50:c943:0:b0:565:fb4c:7707 with SMTP id p3-20020a50c943000000b00565fb4c7707mr7454567edh.26.1709621961745;
        Mon, 04 Mar 2024 22:59:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGVOc573z/n+OxOHCCZFjV20B92BEZN40JbHJQCILheyn9n3J22dC2KVvHsY+Ce0sWX2ZuoxA==
X-Received: by 2002:a50:c943:0:b0:565:fb4c:7707 with SMTP id p3-20020a50c943000000b00565fb4c7707mr7454556edh.26.1709621961468;
        Mon, 04 Mar 2024 22:59:21 -0800 (PST)
Received: from [192.168.0.9] (ip-109-43-178-243.web.vodafone.de. [109.43.178.243])
        by smtp.gmail.com with ESMTPSA id g13-20020a056402428d00b0056793ab2ad8sm192024edc.94.2024.03.04.22.59.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Mar 2024 22:59:21 -0800 (PST)
Message-ID: <30beded9-0d20-4321-b01a-55c6a4f5680c@redhat.com>
Date: Tue, 5 Mar 2024 07:59:19 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 03/32] powerpc: Fix stack backtrace
 termination
Content-Language: en-US
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Andrew Jones
 <andrew.jones@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
 Joel Stanley <joel@jms.id.au>, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org
References: <20240226101218.1472843-1-npiggin@gmail.com>
 <20240226101218.1472843-4-npiggin@gmail.com>
 <94491aab-b252-4590-b2a7-7a581297606f@redhat.com>
 <CZLLLI5JUI8L.1CQ5IF84ZGBYO@wheely>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <CZLLLI5JUI8L.1CQ5IF84ZGBYO@wheely>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05/03/2024 07.29, Nicholas Piggin wrote:
> On Tue Feb 27, 2024 at 6:50 PM AEST, Thomas Huth wrote:
>> On 26/02/2024 11.11, Nicholas Piggin wrote:
...
>>>    	/* save DTB pointer */
>>> -	std	r3, 56(r1)
>>> +	SAVE_GPR(3,r1)
>>
>> Isn't SAVE_GPR rather meant for the interrupt frame, not for the normal C
>> calling convention frames?
>>
>> Sorry for asking dumb questions ... I still have a hard time understanding
>> the changes here... :-/
> 
> Ah, that was me being lazy and using an interrupt frame for the new
> frame.

Ah, ok. It's super-confusing (at least for me) to see an interrupt frame 
here out of no reason... could you please either add proper comments here 
explaining this, or even better switch to a normal stack frame, please?

  Thanks,
   Thomas


