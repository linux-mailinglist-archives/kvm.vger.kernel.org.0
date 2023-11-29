Return-Path: <kvm+bounces-2752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 973927FD3C4
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 11:14:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C87D81C211CC
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 10:14:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E18B19BC2;
	Wed, 29 Nov 2023 10:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UdfOaScu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E72CDE1
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 02:14:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701252869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7zsg/RI6TTCXC9r+9JvBhKGQYtqp3P81us7lifIiZaY=;
	b=UdfOaScugToRDNQkKKHw9wsBW+Ag9HHY4oL8pGMt0Grgj1qkjHUkSX/27vunBjBrxbqGBK
	jOo16I9xXbicHG3H3bsQEAPK76YJBbtt6uTIg5S6WMuz8UdrGNEYlTYuGWptWfKv2fsFcY
	84iXysI/8l69/82x6o4EJVtpoGJ43/g=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-20-Qu99CY39P-Wq8DaCHbAmHA-1; Wed, 29 Nov 2023 05:14:27 -0500
X-MC-Unique: Qu99CY39P-Wq8DaCHbAmHA-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-6cdd63867a5so60792b3a.1
        for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 02:14:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701252867; x=1701857667;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7zsg/RI6TTCXC9r+9JvBhKGQYtqp3P81us7lifIiZaY=;
        b=TZ9X9KIJFF/xLUFch1A6yIZGVpphtLPpCJPyJ1Zbc5X2MkdrEWs/Vol6tZDUNK7I57
         hjMcb7AaHG91fYV3HcOqxz4HbbDzi2HVxLMNojs6Mq0PDla1HTzZEDaV74NdYwP6G94H
         4qP8HhexTZFSIMGcvhZYv44yh4U3LGKZdIQMXKeqLFgt9ICquZ4RuIOXGLgJ9oHSVKhE
         uyuk+xpxcpPBacoZ7g0qP7Jyp3m4GJpltYU+q0WvgWVRVxk3knQoKnNaAih3SpHZ7U1O
         fFQa1cfJSOZKrr+eJJ0OKUzWEKZbf3ZNY3WsNDZUZjWnjv88cWgVc7Uezb8Otqkh5Y/g
         WTBg==
X-Gm-Message-State: AOJu0YxzDkHatINJOqzLWH7nAqc3029Iu0gOwdI44nscfNKGtVoiDPQc
	UtdQGNTrO9UOCuSC+LiVc706spmXkb56MTAR+WSd91lw+HB08NzOHQ1i6AOOgqMWciI/1in7irb
	SA2+/cFTHZJHJ
X-Received: by 2002:a05:6a00:9390:b0:6bf:1621:ccad with SMTP id ka16-20020a056a00939000b006bf1621ccadmr21822300pfb.0.1701252864763;
        Wed, 29 Nov 2023 02:14:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHPEveFUFjif03Zl8nGajMV3+o7G3pWbTGRE4N87OLSfTPpYTZcxH9Fz8K6h0d7YeBVLvaBDw==
X-Received: by 2002:a05:6a00:9390:b0:6bf:1621:ccad with SMTP id ka16-20020a056a00939000b006bf1621ccadmr21822280pfb.0.1701252864339;
        Wed, 29 Nov 2023 02:14:24 -0800 (PST)
Received: from [10.72.112.34] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id c21-20020aa78815000000b006cdc05b1a84sm1231123pfo.74.2023.11.29.02.14.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Nov 2023 02:14:23 -0800 (PST)
Message-ID: <a574e4b6-4c1b-d939-e61c-6a97a245341e@redhat.com>
Date: Wed, 29 Nov 2023 18:14:20 +0800
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
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20231129-7fbc43944dc62a55cffe131c@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi drew,

On 11/29/23 17:27, Andrew Jones wrote:
> On Tue, Nov 28, 2023 at 10:21:23PM -0500, Shaoqin Huang wrote:
>> Currently running tests on EFI in parallel can cause part of tests to
>> fail, this is because arm/efi/run script use the EFI_CASE to create the
>> subdir under the efi-tests, and the EFI_CASE is the filename of the
>> test, when running tests in parallel, the multiple tests exist in the
>> same filename will execute at the same time, which will use the same
>> directory and write the test specific things into it, this cause
>> chaotic and make some tests fail.
> 
> How do they fail? iiuc, we're switching from having one of each unique
> binary on the efi partition to multiple redundant binaries, since we
> copy the binary for each test, even when it's the same as for other
> tests. It seems like we should be able to keep single unique binaries
> and resolve the parallel execution failure by just checking for existence
> of the binaries or only creating test-specific data directories or
> something.
> 

The problem comes from the arm/efi/run script, as you can see. If we 
parallel running multiple tests on efi, for example, running the 
pmu-sw-incr and pmu-chained-counters and other pmu tests at the same 
time, the EFI_CASE will be pmu. So they will write their $cmd_args to 
the $EFI/TEST/pmu/startup.nsh at the same time, which will corrupt the 
startup.nsh file.

cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_TEST/$EFI_CASE/"
echo "@echo -off" > "$EFI_TEST/$EFI_CASE/startup.nsh"
...
echo "$EFI_CASE.efi" "${cmd_args[@]}" >> "$EFI_TEST/$EFI_CASE/startup.nsh"

And I can get the log which outputs:

* pmu-sw-incr.log:
   - ABORT: pmu: Unknown sub-test 'pmu-mem-acce'
* pmu-chained-counters.log
   - ABORT: pmu: Unknown sub-test 'pmu-mem-access-reliab'

And the efi-tests/pmu/startup.nsh:

@echo -off
setvar fdtfile -guid 97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823 -rt =L"dtb"
pmu.efi pmu-mem-access-reliability
setvar fdtfile -guid 97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823 -rt =L"dtb"
pmu.efi pmu-chained-sw-incr


Thus when running parallel, some of them will fail. So I create 
different sub-dir in the efi-tests for each small test.

Thanks,
Shaoqin

>>
>> To Fix this things, use the testname instead of the filename to create
>> the subdir under the efi-tests. We use the EFI_TESTNAME to replace the
>> EFI_CASE in script. Since every testname is specific, now the tests
>> can be run parallel. It also considers when user directly use the
>> arm/efi/run to run test, in this case, still use the filename.
>>
>> Besides, replace multiple $EFI_TEST/$EFI_CASE to the $EFI_CASE_DIR, this
>> makes the script looks more clean and we don'e need to replace many
>> EFI_CASE to EFI_TESTNAME.
>>
>> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
>> ---
>>   arm/efi/run | 16 +++++++++-------
>>   1 file changed, 9 insertions(+), 7 deletions(-)
>>
>> diff --git a/arm/efi/run b/arm/efi/run
>> index 6872c337..03bfbef4 100755
>> --- a/arm/efi/run
>> +++ b/arm/efi/run
>> @@ -24,6 +24,8 @@ fi
>>   : "${EFI_SRC:=$TEST_DIR}"
>>   : "${EFI_UEFI:=$DEFAULT_UEFI}"
>>   : "${EFI_TEST:=efi-tests}"
>> +: "${EFI_TESTNAME:=$TESTNAME}"
>> +: "${EFI_TESTNAME:=$(basename $1 .efi)}"
>>   : "${EFI_CASE:=$(basename $1 .efi)}"
>>   : "${EFI_VAR_GUID:=97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823}"
>>   
>> @@ -56,20 +58,20 @@ if [ "$EFI_CASE" = "_NO_FILE_4Uhere_" ]; then
>>   	EFI_CASE=dummy
>>   fi
>>   
>> -: "${EFI_CASE_DIR:="$EFI_TEST/$EFI_CASE"}"
>> +: "${EFI_CASE_DIR:="$EFI_TEST/$EFI_TESTNAME"}"
>>   mkdir -p "$EFI_CASE_DIR"
>>   
>> -cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_TEST/$EFI_CASE/"
>> -echo "@echo -off" > "$EFI_TEST/$EFI_CASE/startup.nsh"
>> +cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_DIR/"
>> +echo "@echo -off" > "$EFI_CASE_DIR/startup.nsh"
> 
> Unrelated change, should be a separate patch.
> 

Ok, Will separate it.

>>   if [ "$EFI_USE_DTB" = "y" ]; then
>>   	qemu_args+=(-machine acpi=off)
>>   	FDT_BASENAME="dtb"
>> -	$(EFI_RUN=y $TEST_DIR/run -machine dumpdtb="$EFI_TEST/$EFI_CASE/$FDT_BASENAME" "${qemu_args[@]}")
>> -	echo "setvar fdtfile -guid $EFI_VAR_GUID -rt =L\"$FDT_BASENAME\""  >> "$EFI_TEST/$EFI_CASE/startup.nsh"
>> +	$(EFI_RUN=y $TEST_DIR/run -machine dumpdtb="$EFI_CASE_DIR/$FDT_BASENAME" "${qemu_args[@]}")
>> +	echo "setvar fdtfile -guid $EFI_VAR_GUID -rt =L\"$FDT_BASENAME\""  >> "$EFI_CASE_DIR/startup.nsh"
>>   fi
>> -echo "$EFI_CASE.efi" "${cmd_args[@]}" >> "$EFI_TEST/$EFI_CASE/startup.nsh"
>> +echo "$EFI_CASE.efi" "${cmd_args[@]}" >> "$EFI_CASE_DIR/startup.nsh"
>>   
>>   EFI_RUN=y $TEST_DIR/run \
>>          -bios "$EFI_UEFI" \
>> -       -drive file.dir="$EFI_TEST/$EFI_CASE/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
>> +       -drive file.dir="$EFI_CASE_DIR/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
>>          "${qemu_args[@]}"
>> -- 
>> 2.40.1
>>
> 
> Thanks,
> drew
> 

-- 
Shaoqin


