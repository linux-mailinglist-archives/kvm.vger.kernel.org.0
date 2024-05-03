Return-Path: <kvm+bounces-16486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A230C8BA744
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 08:56:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 580B5282B45
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 06:56:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56EAB1465A2;
	Fri,  3 May 2024 06:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NkEeWZuT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2551857CA8
	for <kvm@vger.kernel.org>; Fri,  3 May 2024 06:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714719372; cv=none; b=XPEKRHKojU/vglB0xjlYfnwt+2trPGh0imXyzsCWKHrjPbhkF1JwN6xJk692FrQFwRTLHsIRWbKi83OKNCJ/b/qdNvKhqD+8q/wT20HG9Fksswj5Hj8j01t0xo51TB649yrPGZgRZVyaDCIntP+Iv0WNYGq86Fi9tXOg5O4c5yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714719372; c=relaxed/simple;
	bh=3G3c3NE8LrVbzexu46c+BLr17Qv2A4lsjNdI+HIralY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G4ovgjOgg1y/BaaW8KcJj4Qwsq4RxzanRIptUqsymlvpxEB47CY2rs+eE1hDerTpXP0QIizTTv/1pxpF/riQuTl/VQHwDEOI2KakkgDcb737czAKNA6yxHb9RJcHa4HDMNXFGvY0RoCIIqU8G2kDBuI/Rkzi7hepN3KQ7a0Qe8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NkEeWZuT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714719369;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=V6p1b52yI6TXyt1fECtGqOpIF975IIXtsLuXmCF6zMA=;
	b=NkEeWZuTW+RaX38jn/g4wCsFX8mxuNq4qlyQv8ZvQXuixFPCScUN0VEAxnKYKmGVmYAy+X
	umI2qWhLBGT+NQwV1dpSsqzIp+MgL9B/FAnUum+fI0LpM5tZWy8wxPdeh45kkQOf3Qez3M
	sxFz94x8tUJWH+MorK3PZIIy8hBx+bo=
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com
 [209.85.221.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-422-URILEEaGO8Oq6NL-dWZxhw-1; Fri, 03 May 2024 02:56:07 -0400
X-MC-Unique: URILEEaGO8Oq6NL-dWZxhw-1
Received: by mail-vk1-f200.google.com with SMTP id 71dfb90a1353d-4daca01d01bso4442709e0c.3
        for <kvm@vger.kernel.org>; Thu, 02 May 2024 23:56:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714719367; x=1715324167;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V6p1b52yI6TXyt1fECtGqOpIF975IIXtsLuXmCF6zMA=;
        b=W96a3vqL647ne4DAN+LUB3F61ZtuYinFn7uRoBqhJWNyJJ4SxhchtF3hhux2uWPmto
         773+bDlA+3hMhrdWfkJhB3U6Z5/qP8NBZ49c/O4mXaQzE1Y7ppdJQEeMqwRsyELZpRDA
         XOKsKhq4G3cfY4iL8p2hLh+5+LtHyeVeuYpcQfbC9Nohx9ZDrPUSKUDJTwWZx44wfPQZ
         cajFjwUlqMXLZGcCv5S+JQckJ1zgpiNIH7zwyKN+inQriQ9nRxdJ8tlX5u2T+Ouij6vT
         XIHeDAPdwuFAYAUlHnpK1QJ2ZdIlIBJcHxAMV2ookfN4HzrBYBLpPJmH6FsSeLQWe9fu
         7bAA==
X-Gm-Message-State: AOJu0YxpKj/0My/l8WbSMVhjTt9qj6B28/9Y2S6HgLKGM6Pa3gopFMvK
	VH8eX9ju8kEETDVU/ce8Z+76mKKTSBsMfZBfHdbeLrBuP2n+CbxrnWYPIQQPHJYqSKRwSYqCEnb
	xiqJZ0CyH+W0ecaQCi1jOc5YdZVj09T3urHp5tiUYqmYGbvsUPw==
X-Received: by 2002:a05:6102:342:b0:47c:a74:9e03 with SMTP id e2-20020a056102034200b0047c0a749e03mr1818254vsa.3.1714719367246;
        Thu, 02 May 2024 23:56:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IER59IttyU2qfuXQt2k1jIj0hQThCkHaCGSWvplfWGRe+elGIox4xz4jNykRanIB+aGKKs79g==
X-Received: by 2002:a05:6102:342:b0:47c:a74:9e03 with SMTP id e2-20020a056102034200b0047c0a749e03mr1818238vsa.3.1714719366648;
        Thu, 02 May 2024 23:56:06 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-43-179-34.web.vodafone.de. [109.43.179.34])
        by smtp.gmail.com with ESMTPSA id cx10-20020a056214188a00b0069b5672bab8sm972010qvb.134.2024.05.02.23.56.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 May 2024 23:56:06 -0700 (PDT)
Message-ID: <951ccd88-0e39-4379-8d86-718e72594dd9@redhat.com>
Date: Fri, 3 May 2024 08:56:03 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH] doc: update unittests doc
To: Nicholas Piggin <npiggin@gmail.com>, Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org
References: <20240503060039.978863-1-npiggin@gmail.com>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240503060039.978863-1-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03/05/2024 08.00, Nicholas Piggin wrote:
> Some cleanups and a comment about the check parameter restrictions.
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

This looks like it's only moving the "a" from one line to the other? I'd 
suggest to drop this hunk.

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

Actually, there are some other "magic" groups that have been introduced in 
the course of time:

- The "migration" group is required for migration tests.

- The "panic" group is required for tests where success means that the
   guest crashed (but it's currently only used on s390x).

We might want to document those groups here, too?

  Thomas


