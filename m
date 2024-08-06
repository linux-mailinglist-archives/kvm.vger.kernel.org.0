Return-Path: <kvm+bounces-23434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B015949874
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 21:36:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D2511C213E5
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 19:36:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CCE6155CB2;
	Tue,  6 Aug 2024 19:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dgXFt8rq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1711149001
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 19:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722972987; cv=none; b=RG8poIoZ5oKJ+Zi5v+9CySqK8FyEepolAW9m+0WcVElSlOLCR5ClS6iIM53XdkezkHnKniGm0mZlfXxBZZIiIKdMtxLuIecP4NPr/5vDXrpG2wDdBbPiovw3w1CbSCAwwQOqOUZK9P30KmrWTBYgthY63FL/KP3F8WeBEwNxxAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722972987; c=relaxed/simple;
	bh=iEz7lCKN6LmqkDmIh7w+RAirspZH+Yr49vveXIUCT2Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GEva/q1ovesetIKtmgznhxPfUlwftGJrIRDfSp/m/NLDdZa3jPKg1qTjIFiDAqKApSmMv9GKflQMJL5yyVZL+tdGdk0vseVW5K5AlfTTmw7XtNRQFU+CX71l8EVAhEIXQu4EhjhK5zVsqlG59WldCrCWBipuodqqeuGTp/az0hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dgXFt8rq; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-39b37e5f8fdso716455ab.1
        for <kvm@vger.kernel.org>; Tue, 06 Aug 2024 12:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1722972984; x=1723577784; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+IcNnXdUnkI1mV+s9deswScXVelqj2JzGCxi8Q1hYao=;
        b=dgXFt8rq338v9mNPgwgFpyQeEyP9PhlbTH0gd/5M7tHssveTygnJUSoOPDz1s7zoEE
         vrXqctZJ3rctpjXUVqMPwL6X/tRQnb/2HsOyBqlkjG+8c0fMU5I73PouwXQytmKaxy2b
         I6DfJ98qKJ91h8g816wg/YeFcfIfIoxRJQTdY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722972984; x=1723577784;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+IcNnXdUnkI1mV+s9deswScXVelqj2JzGCxi8Q1hYao=;
        b=gCd4QvinzN1qLFCbzNdaLgie4ZT/lxvc4bzjFYQBaeRzZ073vg/OoFm9niRVESeyf2
         qFt+Hj95SbUbZ2mAYASMLXsKYTZWk4/LkvgQ4gqmkP7YTlkj5F0tXRDzyZKs6jgLyw+a
         jPqWE3hO8I6T6afbQCVKb+8Ir6VXaQ5dJMyYp4hQ1NKBqJrxAXo61POHaNNKauATKUvm
         u4wmKIYgy5IFyqf9AFpid0fDiad0S6TBOYVyNhPX4jWC9qpVLWdPmw3QbdqA0gSPbKfU
         XZS2W6FWe5GfTA29gOT3EfhxFyDuhnu/+IN1C8lL6My2prSFBENxTDCrEKfuCLi5AfY1
         IlAw==
X-Forwarded-Encrypted: i=1; AJvYcCUR8Jg8Sxokdgx75MFuWasRP/+11FLjNmFzmrj3jrR9hlK1GZmiaxT8e8rD6iOgvztTxM6RCsUlIA+TQfHHDyLoIytG
X-Gm-Message-State: AOJu0YydY/TCWEjdSO3DYxyHF0zqBWoQP+tYyfR3nsxFsK32l1SG6ln0
	Jue7t1T3j/kE8BbZLgQRy5p2ok5BL/zUlKQn1VXnk/XqttgIxDxr6qYPdB8VTrM=
X-Google-Smtp-Source: AGHT+IEZoVlqN5oqC2UZRAj8/ipXO6L3aUE6bBqVulf2yqdJndVbcARXaKrOBMfnhl2rIFv8JufbBQ==
X-Received: by 2002:a6b:7b02:0:b0:81f:a783:e595 with SMTP id ca18e2360f4ac-81fd434de8bmr1018147939f.1.1722972983992;
        Tue, 06 Aug 2024 12:36:23 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-81fd4d830afsm267206139f.55.2024.08.06.12.36.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Aug 2024 12:36:23 -0700 (PDT)
Message-ID: <ed207f8a-893d-489f-8e41-d698292ab918@linuxfoundation.org>
Date: Tue, 6 Aug 2024 13:36:22 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] selftests: harness: refactor __constructor_order
To: Kees Cook <kees@kernel.org>, Masahiro Yamada <masahiroy@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>,
 linux-kernel@vger.kernel.org,
 Alexandre Belloni <alexandre.belloni@bootlin.com>,
 Benjamin Tissoires <bentiss@kernel.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>, Janosch Frank <frankja@linux.ibm.com>,
 Jiri Kosina <jikos@kernel.org>, Shuah Khan <shuah@kernel.org>,
 bpf@vger.kernel.org, kvm@vger.kernel.org, linux-input@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rtc@vger.kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240727143816.1808657-1-masahiroy@kernel.org>
 <202408052126.E8A8120C1@keescook>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <202408052126.E8A8120C1@keescook>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/5/24 22:27, Kees Cook wrote:
> On Sat, Jul 27, 2024 at 11:37:35PM +0900, Masahiro Yamada wrote:
>>
>> This series refactors __constructor_order because
>> __constructor_order_last() is unneeded.
>>
>> No code change since v1.
>> I reworded "reverse-order" to "backward-order" in commit description.
>>
>>
>> Masahiro Yamada (2):
>>    selftests: harness: remove unneeded __constructor_order_last()
>>    selftests: harness: rename __constructor_order for clarification
> 
> Thanks for resending this!
> 
> Reviewed-by: Kees Cook <kees@kernel.org>
> 
> Shuah, do you want to take this via kselftest? If not, I can carry it...
> 
> -Kees
> 

Just about to ask you if you want me take it :)

Yes I can take this - I will apply this for Linux 6.12-rc1.

thanks,
-- Shuah



