Return-Path: <kvm+bounces-16673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2CAB8BC7F4
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 09:03:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0097FB210B0
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:03:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE6F050263;
	Mon,  6 May 2024 07:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eElLFyrh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A7D55E5B
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 07:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714979004; cv=none; b=WqztuwDHR814BoIJ1QKmNjWk5Tb+mLSxG3te6okOWEBnkhF740MD0s6yIKifCVObiXMaMDoCc3GvNWLKlu6pbWzBG3yb2hddPIefalqe8Wv3dKQbjVcYpDn7E7ttK0ugF/mPxE9oc/QMGCVxSFN40XyidATCufhZ+7J4snIApLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714979004; c=relaxed/simple;
	bh=JRGVYTZw3hqgkgPTW9ncjpvZqXGaaJSsPcSFbP4oEyY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TyD0rSjVV08F5zb3aHEtx3nT8/73C7I45/VoD88iZ6Vg5s8t0JClmLPo9jTAMYAXZ9tHFqXxARdV5IcBemspqizG3VZhKQbz2ambpYaGQYgmwiKbF/iVRAdXQOBW9RBGPI9LrnZ6ohyCKAICZdFXcIuKf/2i/vE7gT8Dy3uYASQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eElLFyrh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714979000;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QnO7jBPKKqZ6Z81KpQ6b8hLP1pvwmRM1V0g0UAtBOn0=;
	b=eElLFyrhQiQfsjHMr+wZZvvIle1kpP14d17NkCUgomlLyU97mLZedBATGg9UAd3RzHNtCl
	Zqzo4WNrjvC8EjPtifZSe0C5EXfB9WPz4viPEEBSdITyuPN0qP1WTwjJ5roP3TM9GC13y8
	zAvWo4sKRKioGtVN5XZYAkCvf3Y2qow=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-22-FpPj08cNN_e5W2Zk01j0KA-1; Mon, 06 May 2024 03:03:17 -0400
X-MC-Unique: FpPj08cNN_e5W2Zk01j0KA-1
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-6f0512c4ddfso1036066a34.2
        for <kvm@vger.kernel.org>; Mon, 06 May 2024 00:03:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714978997; x=1715583797;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QnO7jBPKKqZ6Z81KpQ6b8hLP1pvwmRM1V0g0UAtBOn0=;
        b=KTRaGjJo2LLp7WWYHDqgQwUUOl/bXw6NSdG/+LKxix/3f1uTquwX5OfuyEX2eMXqr4
         hJJCYZ76ScRMTr8L8Vrrdyiji7W5o5Ti44CrmHOyyDT1WYlkHa+uimYYk0SgRTiYk6Ve
         JQ7oZ5UuinS9pHHxHGxjJCalEzkZsuzV8w83KRZS7jvOAEZYr1JrRCDPK9yO1ibRjFWk
         cX8LqLUnpDbh2cgDkvFjp352K/zkOHGPbG1r3ltaEbIsg7eOtpFbRbUZKSoalr1IW42j
         sPpEB2tcJdH9hnPDrVTZThD7CEm545WjgoTtpfDPRCoETcjOjjWn2gJoReYVLEh9Ljud
         /Iww==
X-Forwarded-Encrypted: i=1; AJvYcCVh6xmvdud1kfQEGfWr4ET81qDoqcW7Xf6aq/Y5B6NKmQYLnfCWWYHM6zJ8bVNsAfUf7tZgtdi6tXfGiQSgha48fF9S
X-Gm-Message-State: AOJu0YyA9NlicUH7iJ+gKMMLwHG5D4WycS5jO560xXi9akQ1G2Z709XU
	h6ktJmF8uGxMl+stdnQQ97hS8/+sxjgTm1Y4QdOxOnldVRVXNRDaXid1CogUYNAvb5Cq+uWm+8M
	YcrkfhmgrCCUISjGoIV4mY11g4Ng5ApBidOfRdvpj78bRxDOjxg==
X-Received: by 2002:a05:6830:2683:b0:6f0:718c:f6fa with SMTP id l3-20020a056830268300b006f0718cf6famr524945otu.33.1714978996795;
        Mon, 06 May 2024 00:03:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHnIMeW46pwEBSzJeXMBA/+Nsm8YphXdw2r5+GmnzvWpZ+zuQSah5TAiHaKmMzbSqoylTMJvQ==
X-Received: by 2002:a05:6830:2683:b0:6f0:718c:f6fa with SMTP id l3-20020a056830268300b006f0718cf6famr524930otu.33.1714978996423;
        Mon, 06 May 2024 00:03:16 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-43-179-34.web.vodafone.de. [109.43.179.34])
        by smtp.gmail.com with ESMTPSA id de27-20020a05620a371b00b0078ed5316f96sm3603704qkb.6.2024.05.06.00.03.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 May 2024 00:03:16 -0700 (PDT)
Message-ID: <5cde6ee7-eabc-414b-a409-24a6ed141b39@redhat.com>
Date: Mon, 6 May 2024 09:03:13 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v9 01/31] doc: update unittests doc
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Andrew Jones
 <andrew.jones@linux.dev>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
References: <20240504122841.1177683-1-npiggin@gmail.com>
 <20240504122841.1177683-2-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240504122841.1177683-2-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/05/2024 14.28, Nicholas Piggin wrote:
> This adds a few minor fixes.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   docs/unittests.txt | 12 +++++++-----
>   1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/docs/unittests.txt b/docs/unittests.txt
> index 3192a60ec..7cf2c55ad 100644
> --- a/docs/unittests.txt
> +++ b/docs/unittests.txt
> @@ -15,8 +15,8 @@ unittests.cfg format
>   
>   # is the comment symbol, all following contents of the line is ignored.
>   
> -Each unit test is defined with a [unit-test-name] line, followed by
> -a set of parameters that control how the test case is run. The name is
> +Each unit test is defined with a [unit-test-name] line, followed by a
> +set of parameters that control how the test case is run. The name is
>   arbitrary and appears in the status reporting output.
>   
>   Parameters appear on their own lines under the test name, and have a
> @@ -62,8 +62,8 @@ groups
>   groups = <group_name1> <group_name2> ...
>   
>   Used to group the test cases for the `run_tests.sh -g ...` run group
> -option. Adding a test to the nodefault group will cause it to not be
> -run by default.
> +option. The group name is arbitrary, aside from the nodefault group
> +which makes the test to not be run by default.
>   
>   accel
>   -----
> @@ -82,8 +82,10 @@ Optional timeout in seconds, after which the test will be killed and fail.
>   
>   check
>   -----
> -check = <path>=<<value>
> +check = <path>=<value>
>   
>   Check a file for a particular value before running a test. The check line
>   can contain multiple files to check separated by a space, but each check
>   parameter needs to be of the form <path>=<value>
> +
> +The path and value can not contain space, =, or shell wildcard characters.

Could you comment on my feedback here, please:

  https://lore.kernel.org/kvm/951ccd88-0e39-4379-8d86-718e72594dd9@redhat.com/

  Thanks,
   Thomas


