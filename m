Return-Path: <kvm+bounces-15210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 982738AAA29
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 10:28:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C57F01C220E8
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 08:28:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C82D553E02;
	Fri, 19 Apr 2024 08:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gvHUKR7n"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D81DDF59
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 08:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713515305; cv=none; b=lMa/FZU1Zzc8kXYgZD+EF5/MrKCFONSAn92JnpjP4qfvrIzh2hBtzfudWrfp1EABWvMcUMQIdt/PnukG1hHoCEQJDNF6VUG2B9DvKlXkv3sNhdlM9pkpRl49h9Xo3MYNg4vhZQabbKA8pslm73Pu7DVdh6GN9gXOx1cNXO5YAD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713515305; c=relaxed/simple;
	bh=SitLLMumydR5MJZAC/p+0mGDm8EYMQNKD5Q0qSD9HWE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SNxseGjfLtnbXPtgXX2tWC7+kCpWlsrkoHTfxynFYMHXeAaSMSxm7dqNDvyBpfg/B4tEVvAyh72O4tMVJ1GsIQMPr8Ks4XPfKhUb73UoQvUxbDC3UjJpKfiNMwipKZ708R9SjmfEWeCErdbL8sCRYhwk0tvtORR/+JOjKd9MFXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gvHUKR7n; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713515302;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1MFOgOZgDhaJpiXcuUNv0/+Rz9Id9JNcB2281VROi/c=;
	b=gvHUKR7nss6DXFTvvVi1djK4mh1wHVgym5ypWjRU/W0/FT9MTKE8UQWkzm1Q2D2ra7sPVm
	fgJ3TnBSRYkPRCMcLR7DF+BOe8ueTdYJ/PJtACAicNoIc4UUAziUZJI2gTy/agkzzMlT+H
	5w9bxN4q/wevYpPy+fElltYUNwe9vZc=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-LPqWDb-RPLezWcM-LrM2pA-1; Fri, 19 Apr 2024 04:28:20 -0400
X-MC-Unique: LPqWDb-RPLezWcM-LrM2pA-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2d84af71cddso13538771fa.0
        for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 01:28:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713515299; x=1714120099;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1MFOgOZgDhaJpiXcuUNv0/+Rz9Id9JNcB2281VROi/c=;
        b=i2mFTn/5Hhpjy3l2G+4hXlrBc+srDuuSrF6eKmChFx2IAmDH3XlE7A4HkCnvzxZvmc
         JwtCyaRFEaJ25VaoAtmSMHEdIjEtOLZySsAz13szGefCnw+23EwxD8fspHOSCarFkdZu
         evYMOyX0tlSPTWiPSMT7yRwKCzx2TU9zzL9o2p0S/VXTnvuQHfm3w2qC97sAfcIxnArg
         9pRKMxx0K/hbkKrtFc98VF3gQiHXXrwkYVR0qX0jE4ox/L69g2fZLh38h71V9Ty9ELIS
         yLxBY0KN0/KEcCce5j9D5M9oJ+7FE4RssyrWNDfI18Ej/uAvbdbZhQjBKWypskqRJxIg
         5dpw==
X-Forwarded-Encrypted: i=1; AJvYcCUAmedvRVX1d2cXjh/U5WP/w3utTsU4b/WiriXX8vR3YUF2ouhtlia3KwcO03vN3wwoEarR/Q/WQ1eOW0hoHz6Cg1II
X-Gm-Message-State: AOJu0YwKEKa+te2EyQpmrFXcMw6OI90sWDswXSvVBsemd9ej0lqp1PXZ
	hQm9XNC2RLbV0n++aWyHAuVtN+olnkXv1ZvS059diTe0RQHCBxGhalcTj8Kz6EwrIEzGW7yhUw5
	YmN2kHco9Qoy1wqppZqGbHLBy0x9sIBLHFrjpp4CI57PqZ6xpPQ==
X-Received: by 2002:a2e:80ca:0:b0:2dc:e4c2:8891 with SMTP id r10-20020a2e80ca000000b002dce4c28891mr421918ljg.21.1713515299098;
        Fri, 19 Apr 2024 01:28:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHLG/nOMGQOi3MJU+++GRw7qfucDlQDiHvUdIo48HcZd10IiVj7Q8SzcJGtgdHBiTY8PwdGDQ==
X-Received: by 2002:a2e:80ca:0:b0:2dc:e4c2:8891 with SMTP id r10-20020a2e80ca000000b002dce4c28891mr421900ljg.21.1713515298684;
        Fri, 19 Apr 2024 01:28:18 -0700 (PDT)
Received: from [192.168.13.102] ([212.24.158.62])
        by smtp.gmail.com with ESMTPSA id h15-20020a05600c350f00b00418d68df226sm6300373wmq.0.2024.04.19.01.28.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Apr 2024 01:28:18 -0700 (PDT)
Message-ID: <540ddf1b-8ccd-498e-90da-68ed167cca35@redhat.com>
Date: Fri, 19 Apr 2024 10:28:17 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH] test_migrate_unmapped_collection test
 fails during skip
To: Andrew Jones <andrew.jones@linux.dev>
Cc: thuth@redhat.com, kvm@vger.kernel.org
References: <20240418155549.71374-1-jarichte@redhat.com>
 <20240418-057e93240295617e456f221c@orel>
Content-Language: en-US
From: Jan Richter <jarichte@redhat.com>
In-Reply-To: <20240418-057e93240295617e456f221c@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/18/24 21:20, Andrew Jones wrote:
> On Thu, Apr 18, 2024 at 05:55:49PM +0200, Jan Richter wrote:
>> The test_migrate_unmapped_collection test fails when the errata
>> requirements are not meet and the test should be skipped. Instead of
> 
> met
> 
>> being skipped, the test returns `ERROR: Test exit before migration
>> point.`
>>
>> This is caused by changes in fa8914bccc226db86bd70d71bfd6022db252fc78
> 
> Please use the standard way of referencing commits, which, in this case,
> would be
> 
> commit fa8914bccc22 ("migration: Add a migrate_skip command")
> 
>> which changes the behaviour of skipped migration tests. This fixes this
>> issue by adding migrate_skip() method to
>> test_migrate_unmapped_collection.
> 
> And we should add a Fixes tag
> 
> Fixes: fa8914bccc22 ("migration: Add a migrate_skip command")
> 
>>
>> Signed-off-by: Jan Richter <jarichte@redhat.com>
>> ---
>>  arm/gic.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/arm/gic.c b/arm/gic.c
>> index bbf828f1..256dd80d 100644
>> --- a/arm/gic.c
>> +++ b/arm/gic.c
>> @@ -829,6 +829,7 @@ static void test_migrate_unmapped_collection(void)
>>  	if (!errata(ERRATA_UNMAPPED_COLLECTIONS)) {
>>  		report_skip("Skipping test, as this test hangs without the fix. "
>>  			    "Set %s=y to enable.", ERRATA_UNMAPPED_COLLECTIONS);
>> +		migrate_skip();
>>  		return;
>>  	}
>>  
>> -- 
>> 2.44.0
>>
> 
> Otherwise LGTM
> 
> Thanks,
> drew
> 
Hi Drew,

thanks for the review. I will send new version with fixed commit message.

- Jan



