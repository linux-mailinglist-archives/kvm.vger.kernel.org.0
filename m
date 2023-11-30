Return-Path: <kvm+bounces-2838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D5AB67FE79D
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 04:18:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 959492822CB
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 03:18:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B01C134A9;
	Thu, 30 Nov 2023 03:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZGo1AAXY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F7B510CE
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 19:18:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701314317;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u+iSpIxtCVTh9BXoYftq0bmE/10+Op2Y3rwSgLPtBkY=;
	b=ZGo1AAXYPnKIxN2k6JJbAvpOY8wsEiiDMyRl3mjBtKuEXBopA1ctwom0cua35TZb/0/Cd3
	BTKK4Y7Vrj/JgbNiwGea4p4xxXfMW5FYS8OwUqlC+ZbUaHAgDLu6HNePfJ6/pBFUKTbr2i
	exTl9jdB2LIt1Xu0o8s4MvpaW5fX15Q=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-351-7HPODpjqN12b9B_4cl4Cig-1; Wed, 29 Nov 2023 22:18:34 -0500
X-MC-Unique: 7HPODpjqN12b9B_4cl4Cig-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1cfbeee2265so1304955ad.0
        for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 19:18:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701314313; x=1701919113;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u+iSpIxtCVTh9BXoYftq0bmE/10+Op2Y3rwSgLPtBkY=;
        b=iF3rsOp5c9TEQOJ00FnEl98am4QUJQ9/N+PIhvLF/yAP1c5wgOEpCf/iuAIkNTBj9d
         ZJJPYnv/sVw7kjf3wv/keA+1Wn6pDDQ0kpQba++eWc3cH1H1honJKDcGQWQG2g4PFuxN
         EXtx1NxGYgI6pcBZaixjdWQgDnwDxJSY9eZF1QuVtj9ENWN1K42sVtRnlV0OJtDVOa7Q
         DjzLlR+F2mwNjQha6+A5QBe6FFNXQFGx+TAFlPBKfy0GSxTwskrDbTJBOVOB/v/p3nbi
         SutG9LrG7XO33hzHIvChblGV9Ms68OC04vs9l4JrbkGjZAYcqO4+VvWB/qAUaATSphhp
         MRbw==
X-Gm-Message-State: AOJu0Yz6M5zOi2fUTTxEIU3jSBM5MJYY+c0ZnFWWw9PoXa9vb63QRpHK
	U+3jJyAzs382EB85ay7hK8CqJuwtlKUoX439Mq7v/PqPk7pxRi1ZtjcvPXnW8dvL0kdR0wFciwt
	Z2i7+SNyLuGrS
X-Received: by 2002:a17:902:f683:b0:1cf:c680:f37f with SMTP id l3-20020a170902f68300b001cfc680f37fmr14239942plg.2.1701314313433;
        Wed, 29 Nov 2023 19:18:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFm1n8ELJdp4RfPk7lYND0rjP6RFv0rZ+fw84nRZl7Y4mDKazCvnKOkvSgAXTtmo4jZAZfpqg==
X-Received: by 2002:a17:902:f683:b0:1cf:c680:f37f with SMTP id l3-20020a170902f68300b001cfc680f37fmr14239928plg.2.1701314313097;
        Wed, 29 Nov 2023 19:18:33 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id i18-20020a17090332d200b001cfb971edf3sm126724plr.8.2023.11.29.19.18.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Nov 2023 19:18:32 -0800 (PST)
Message-ID: <75fd59f0-c47d-ae26-61b2-e6d800c33e90@redhat.com>
Date: Thu, 30 Nov 2023 11:18:29 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [kvm-unit-tests PATCH v1 3/3] arm64: efi: Make running tests on
 EFI can be parallel
Content-Language: en-US
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvmarm@lists.linux.dev, Alexandru Elisei <alexandru.elisei@arm.com>,
 Eric Auger <eric.auger@redhat.com>, Nikos Nikoleris
 <nikos.nikoleris@arm.com>, Ricardo Koller <ricarkol@google.com>,
 kvm@vger.kernel.org
References: <20231129032123.2658343-1-shahuang@redhat.com>
 <20231129032123.2658343-4-shahuang@redhat.com>
 <20231129-7fbc43944dc62a55cffe131c@orel>
 <a574e4b6-4c1b-d939-e61c-6a97a245341e@redhat.com>
 <20231129-cbddf8063ae5af7a37aa2e4a@orel>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20231129-cbddf8063ae5af7a37aa2e4a@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi drew,

On 11/29/23 19:43, Andrew Jones wrote:
> On Wed, Nov 29, 2023 at 06:14:20PM +0800, Shaoqin Huang wrote:
>> Hi drew,
>>
>> On 11/29/23 17:27, Andrew Jones wrote:
>>> On Tue, Nov 28, 2023 at 10:21:23PM -0500, Shaoqin Huang wrote:
>>>> Currently running tests on EFI in parallel can cause part of tests to
>>>> fail, this is because arm/efi/run script use the EFI_CASE to create the
>>>> subdir under the efi-tests, and the EFI_CASE is the filename of the
>>>> test, when running tests in parallel, the multiple tests exist in the
>>>> same filename will execute at the same time, which will use the same
>>>> directory and write the test specific things into it, this cause
>>>> chaotic and make some tests fail.
>>>
>>> How do they fail? iiuc, we're switching from having one of each unique
>>> binary on the efi partition to multiple redundant binaries, since we
>>> copy the binary for each test, even when it's the same as for other
>>> tests. It seems like we should be able to keep single unique binaries
>>> and resolve the parallel execution failure by just checking for existence
>>> of the binaries or only creating test-specific data directories or
>>> something.
>>>
>>
>> The problem comes from the arm/efi/run script, as you can see. If we
>> parallel running multiple tests on efi, for example, running the pmu-sw-incr
>> and pmu-chained-counters and other pmu tests at the same time, the EFI_CASE
>> will be pmu. So they will write their $cmd_args to the
>> $EFI/TEST/pmu/startup.nsh at the same time, which will corrupt the
>> startup.nsh file.
>>
>> cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_TEST/$EFI_CASE/"
>> echo "@echo -off" > "$EFI_TEST/$EFI_CASE/startup.nsh"
>> ...
>> echo "$EFI_CASE.efi" "${cmd_args[@]}" >> "$EFI_TEST/$EFI_CASE/startup.nsh"
>>
>> And I can get the log which outputs:
>>
>> * pmu-sw-incr.log:
>>    - ABORT: pmu: Unknown sub-test 'pmu-mem-acce'
>> * pmu-chained-counters.log
>>    - ABORT: pmu: Unknown sub-test 'pmu-mem-access-reliab'
>>
>> And the efi-tests/pmu/startup.nsh:
>>
>> @echo -off
>> setvar fdtfile -guid 97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823 -rt =L"dtb"
>> pmu.efi pmu-mem-access-reliability
>> setvar fdtfile -guid 97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823 -rt =L"dtb"
>> pmu.efi pmu-chained-sw-incr
>>
>>
>> Thus when running parallel, some of them will fail. So I create different
>> sub-dir in the efi-tests for each small test.
> 
> Ok, I was guessing it was something like that. Maybe we should create a
> "bin" type of named directory for all the binaries and then create a
> separate subdir for each test and its startup.nsh, rather than copying
> the binaries multiple times.
> 

I can put this kind of improvement into another patch. Currently I want 
to use the safety way to fix this problem, create different directory 
and copy the .efi for each of them will not cause any interfere for each 
of the test. We can tolerate the redundant, it doesn't cost many space.

Thanks,
Shaoqin

>>>>    : "${EFI_CASE:=$(basename $1 .efi)}"
>>>>    : "${EFI_VAR_GUID:=97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823}"
>>>> @@ -56,20 +58,20 @@ if [ "$EFI_CASE" = "_NO_FILE_4Uhere_" ]; then
>>>>    	EFI_CASE=dummy
>>>>    fi
>>>> -: "${EFI_CASE_DIR:="$EFI_TEST/$EFI_CASE"}"
>>>> +: "${EFI_CASE_DIR:="$EFI_TEST/$EFI_TESTNAME"}"
>>>>    mkdir -p "$EFI_CASE_DIR"
>>>> -cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_TEST/$EFI_CASE/"
>>>> -echo "@echo -off" > "$EFI_TEST/$EFI_CASE/startup.nsh"
>>>> +cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_DIR/"
>>>> +echo "@echo -off" > "$EFI_CASE_DIR/startup.nsh"
>>>
>>> Unrelated change, should be a separate patch.
>>>
>>
>> Ok, Will separate it.
> 
> Actually, disregard my comment. I was too hasty here and thought the
> '@echo -off' was getting added, but now I see only the path was getting
> updated. It's correct to make this change here in this patch.
> 
> Thanks,
> drew
> 

-- 
Shaoqin


