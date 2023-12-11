Return-Path: <kvm+bounces-4029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 75F0F80C4E1
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 10:40:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31A4B2812FB
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 09:40:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B172321373;
	Mon, 11 Dec 2023 09:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NFppxFqW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20AF3106
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 01:40:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702287603;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pw2V/0UThqP6DMD1gXJuWi+WO5ZbDXws64yBbZzN7bo=;
	b=NFppxFqWMdmt+vG7URPQpCHJnhu2eWXnmq+6OfWDFYXMX2VQ/tr+xBJ9J4/XdWVvhm/Lbu
	CxsaPKiLTuEAKDHcDSyufOgdL4BKYLT05iezYHUP0Dsq8gsVB7FbetVs7qZWn5Q+hgN1Ho
	CSrJhTQdMAs+sEBSzQLxQHd7pDHZr9o=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-196-kcedXweNPhWfL02MP7PZuA-1; Mon, 11 Dec 2023 04:40:01 -0500
X-MC-Unique: kcedXweNPhWfL02MP7PZuA-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-77d7d33b126so489006185a.2
        for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 01:40:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702287601; x=1702892401;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pw2V/0UThqP6DMD1gXJuWi+WO5ZbDXws64yBbZzN7bo=;
        b=HeMIXSp0Tx6TiEyFBONCT0f5gjEmNgMikZr1VkNxf8NldNDMC70HPG+7W8oDGsYe+k
         M14fDfIiJ77QRuJCHRGvYAc64FQ180Z8aIQ3X/Pk2/F91fIsWKecQbyDKix4p/MO1SnQ
         bmxicn6knQMfN2/6PtErTdEdDpibyVSqomZiaQcWUNOENT5eRYAHJUG9BAWG6gf/ePgl
         2LeY3Rrub3GqVOX3hWo9wOEDx635Sju7X+aDHfGnSdjWJTsH3GUhD4P5e3VLs3nvN9Zu
         sIjYMx2oqcN3WsVxf0ZkxIfRMqY9BM6GnSrGH0DhegwWMVLSmrfnIWJj9KzOl5k8e5C8
         UOVg==
X-Gm-Message-State: AOJu0YzJrRI6TCY0dgSKPG9b3yH4Yb5R1wuwi2T1sWYaiTaZre93duJ6
	L/rrmOcaqvqsYLKDYKCXHuyp7bwT0bEHEcdZu+I1G58lMuK8Agm2xmqYhJh8TnHMRK1DRE+30aT
	MH4hiJD/07LbW
X-Received: by 2002:a05:620a:178e:b0:77d:89c4:1618 with SMTP id ay14-20020a05620a178e00b0077d89c41618mr4975592qkb.32.1702287601248;
        Mon, 11 Dec 2023 01:40:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHFh0CmhAi9QrDdT/r7dkEpjRzwP+eWAZjhFgCQHrEwdlTQNxKJrFhX5V8wHidkJMg1u+/Xbg==
X-Received: by 2002:a05:620a:178e:b0:77d:89c4:1618 with SMTP id ay14-20020a05620a178e00b0077d89c41618mr4975584qkb.32.1702287601011;
        Mon, 11 Dec 2023 01:40:01 -0800 (PST)
Received: from [192.168.0.6] (ip-109-43-178-138.web.vodafone.de. [109.43.178.138])
        by smtp.gmail.com with ESMTPSA id rq11-20020a05620a674b00b0077f1645282csm2783052qkn.22.2023.12.11.01.39.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Dec 2023 01:40:00 -0800 (PST)
Message-ID: <abfbb656-fc55-4b10-ab54-e7fb96896bc9@redhat.com>
Date: Mon, 11 Dec 2023 10:39:57 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: selftests: Use TAP in the steal_time test
Content-Language: en-US
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 Andrew Jones <ajones@ventanamicro.com>
References: <20231019095900.450467-1-thuth@redhat.com>
 <20231019-2946dcc38c3e95e0e7433eae@orel>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20231019-2946dcc38c3e95e0e7433eae@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 19/10/2023 15.13, Andrew Jones wrote:
> On Thu, Oct 19, 2023 at 11:59:00AM +0200, Thomas Huth wrote:
>> For easier use of the tests in automation and for having some
>> status information for the user while the test is running, let's
>> provide some TAP output in this test.
>>
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>> ---
>>   NB: This patch does not use the interface from kselftest_harness.h
>>       since it is not very suitable for the for-loop in this patch.
>>
>>   tools/testing/selftests/kvm/steal_time.c | 46 ++++++++++++------------
>>   1 file changed, 23 insertions(+), 23 deletions(-)
>>
> 
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Thanks Andrew!

Paolo, if there are no other concerns, could you maybe pick it up for kvm/next ?

  Thanks,
   Thomas


