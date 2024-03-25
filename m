Return-Path: <kvm+bounces-12606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5602988B078
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 20:51:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 834C9BE4FD9
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 17:14:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B4D913C9C9;
	Mon, 25 Mar 2024 15:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TYKQ05Hw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C222433AD
	for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 15:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711382052; cv=none; b=aM4wOK8uTS8pkmupdajKYxLMkff8BQkSq8vHneV++G7p/JRfumsuiBcm25r2XZTkisxMxGH9bYLNSg1jvM5KoQA3g4qAc+MbdYv87wmzJQdQ/psDsPrjTZL5uOIpmoZ76JaHGoA8bvddS/uCbKlJFIK6K7D1QFzWRfWMnjVNC6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711382052; c=relaxed/simple;
	bh=c/TwX7VCuiS06YT2nEvfnNXircdArnDruK4tCBCT5eQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QplG96c5xRM3XgmsfOz4T7cNad5qBAjE4V9cQvOgjLwfCAi4E6oRLMfOQMghX6EkAlMYY+BpZe7rGp2hJyhbsmxfRFpN/QL7gP+HgBtrbQNZzAY9RRa74fWRhmuxD9QVJAX1wQ1StLbgiK24cWpWmsQKaw9xRXxdTcYjviHKdoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TYKQ05Hw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711382050;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WVTqNn/tSJ8aDQ1daUbOXsohjW6KUPH9mX5kruoLQjU=;
	b=TYKQ05Hw1AQMcBjmjnQ8EiEJ/UwfbFsGPiKqlalYMlTdsacQ1gdr4HVS87Y6YN6AkjLdit
	uCHZ2HHLd+UBgGiz+PoARLcNq2pfpL9EmzUYeDCWeUXAWuX9WL6Lchat9cHra+n4UFCy8K
	+DPf8mHAvSNw+A1u273o4DItSaoliVA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-19-GDSCDDXrMs26Fn9uwnEWpw-1; Mon, 25 Mar 2024 11:54:07 -0400
X-MC-Unique: GDSCDDXrMs26Fn9uwnEWpw-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4147de378b9so16181215e9.3
        for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 08:54:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711382046; x=1711986846;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WVTqNn/tSJ8aDQ1daUbOXsohjW6KUPH9mX5kruoLQjU=;
        b=SX0sHbEiCANjzLj29dOEDQ92OycdNDZor3YZ4kmML5fRe0DQTRkMUxZhAQyIQmp2PM
         crLr9OkqI88AO4fEncLVSvxidcRiICaPLOlqYvaYdiGZIex9/rqX1J5ZTN7SFzheliT3
         4RFOkhMTnTRdpgskyC+9k6GtLMqScbl80eSEYraZE/1XDrYnCeOFsuGBFt3VW836ShFJ
         OmcitI6Q/qcYu4GfSzXiBZBi5XstoByFp/JjlLrMBw9dqupg7541ke34CbB9d808ez7V
         xLOgtJhQzwgwYu8cPQmkTcPYnxQ2mdxzMSYNrSIxKYapYYtEyvajhegh+RWoPwqQRQZA
         ouhA==
X-Forwarded-Encrypted: i=1; AJvYcCWGnFY/EnfxTfYFVpqFaMNOslxQNS56R+qnnuOcYDCWUhYwdPobeT4/gBa17ksM78nCNW3waxDuNm7wj9Qhe1gg+iIl
X-Gm-Message-State: AOJu0YyhQM1AL2Wr4lX+0APT6M2jSIfjLJ39y0YTT7kM4Cttneh++bw/
	GtD+GeXxPwmWl2KF3SvZJEk4s6+zRW6oi24rlXUY4KXsEz8ZK73EtrUsf68SthuU6hCfW7daLgN
	C/daq4nyku6zI+FV9qFtFwLAa+GiSGSHU6MB34wDb8GU4Sfa+NA==
X-Received: by 2002:a05:600c:3b1c:b0:414:6909:f65f with SMTP id m28-20020a05600c3b1c00b004146909f65fmr29169wms.6.1711382046054;
        Mon, 25 Mar 2024 08:54:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGD6+unXqelSSGOx4UHrZ6q+cMOMdzI+nbQ6A24EFEMTqbcFmZRjzOAgLUttkiJFquDYExNyw==
X-Received: by 2002:a05:600c:3b1c:b0:414:6909:f65f with SMTP id m28-20020a05600c3b1c00b004146909f65fmr29153wms.6.1711382045714;
        Mon, 25 Mar 2024 08:54:05 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-43-176-158.web.vodafone.de. [109.43.176.158])
        by smtp.gmail.com with ESMTPSA id o20-20020a5d58d4000000b0033e7503ce7esm9811125wrf.46.2024.03.25.08.54.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Mar 2024 08:54:04 -0700 (PDT)
Message-ID: <4edfe9dd-6e61-4bbb-bcab-fa3c1102b377@redhat.com>
Date: Mon, 25 Mar 2024 16:54:03 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v7 01/35] arch-run: Add functions to help
 handle migration directives from test
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Andrew Jones
 <andrew.jones@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
References: <20240319075926.2422707-1-npiggin@gmail.com>
 <20240319075926.2422707-2-npiggin@gmail.com>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240319075926.2422707-2-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 19/03/2024 08.58, Nicholas Piggin wrote:
> The migration harness will be expanded to deal with more commands
> from the test, moving these checks into functions helps keep things
> managable.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   scripts/arch-run.bash | 20 +++++++++++++++-----
>   1 file changed, 15 insertions(+), 5 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>


