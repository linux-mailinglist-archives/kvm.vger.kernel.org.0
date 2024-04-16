Return-Path: <kvm+bounces-14721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FD068A629A
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 06:51:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B2F0BB20EAB
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 04:51:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07C6F381BD;
	Tue, 16 Apr 2024 04:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BS2MaIcC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4CE1642B
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 04:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713243057; cv=none; b=Zkmi/HX8a7zAZSz3KRGxjmmbTjlE6p91TWbKMvlWlw2ckmgJR4J6QVRzULAtu91rkduDhd6Q72d0x51tgCUEiNBleSNcQ8R2CvL/Mu5ovd6CIbP9GldTClLlyve6D2YgAeCKk8zeO9pHxbBJOJissqf0UA/KhJFs18TpO9sKqzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713243057; c=relaxed/simple;
	bh=MGaBtjkC6syhJC5ja6KzKgyK6NUV8gWsHzIDwykuvOQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U8noCFrTEtZAoqH8Y7r18gkHNOdCT27j1R/09C0TYcwk5iGlKxV+5EUQJfgRZGDryZR67WeyjaOKwTzte3qyg53v4tCQnOcj4dG6AMlKTRtxg/6kfdaSKAf4+2P5fFjjjCk0OmXhhIQgVUgm4oivB5OQ8wnTd+BCPd6n6cFi+Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BS2MaIcC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713243054;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hUMvOI44LQITn0QQfxWuxppp606ZUuM5f4XktOIdKpI=;
	b=BS2MaIcC1PFp2ELskB0le82aeBDxjtFr1hSTNhU2zDSpfXPYhjcvzEw95oELn6PUYwi24M
	rZQE51H9JtcOSlWGAyFQVyS2NosIGOWF8CC2PDSod5lEQM739CpCNGH/VNqYVkZKHTHwi8
	Aimy9qsWaLmVI4RBhxq21oBtYjjByvI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-662-MbXDLzeRMFKp-UM22iMJDw-1; Tue, 16 Apr 2024 00:50:52 -0400
X-MC-Unique: MbXDLzeRMFKp-UM22iMJDw-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-56e7187af0fso2371126a12.0
        for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 21:50:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713243052; x=1713847852;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hUMvOI44LQITn0QQfxWuxppp606ZUuM5f4XktOIdKpI=;
        b=b3Dnh8fjfuNtC/qbySQfOZWJImUHQ+OF4hmi0m3jDQc4ji8tch22qXypGEM+/abU3C
         P7GpVTwPVWacp0EWzfXkt+6rIzBypZsqWtvqOruT4wlfEag6EEX0pP7Q0oFdoq5yIHuj
         t2Kx5MxJFsNsyWUmyHGtVpqNNSZGX2+D1I2UOkKwNZYRbKAUSdKbWrgGOrGbsOUS58ee
         Kqavm1p6Xj7Fkqs8jW51/4kLxSlNR39J1DXDBgCTMUI301YjTqp2zXPxwngsXf9u0hA6
         LtFA0AASsbC39LmMPW+FSbTRlV9E+eh0Oqjv1ehbD3BiEJaarY0It1K4lql7z+N9vnXV
         8iSg==
X-Forwarded-Encrypted: i=1; AJvYcCWYlf0OmLb6fUOqtsfZIFuPDoX670Oqz9T08sRIm/3E0hfSVtewITEUt08XnY4jFLbN01tst5s2W/CHrgULbCNaqqaa
X-Gm-Message-State: AOJu0Yx6Z4D969i5EEBedLJYTsvlrqsY0XbK2ouLc6W5Jnb/8MsNvSVL
	SSDjZ7NlXiybtWoCJTD6jIszP3Qi14wDMkZwbzzfWU9EDlxe+xssPQQrQUMg/MZCIrmIbsWseGZ
	K+uudPD3H4LMocwweIvlnOcYezuvcgQJH64Ufn8RNHZYSpqk4s0htDOR8Jw==
X-Received: by 2002:a50:9b53:0:b0:56d:f637:4515 with SMTP id a19-20020a509b53000000b0056df6374515mr7177621edj.42.1713243051869;
        Mon, 15 Apr 2024 21:50:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH7YK9mWnBYKfr61YvddWRbU4muyppecHDHP8vmEPrtiwDcag/GTEQQUt6A2tVbOEJ+/qlDtg==
X-Received: by 2002:a50:9b53:0:b0:56d:f637:4515 with SMTP id a19-20020a509b53000000b0056df6374515mr7177612edj.42.1713243051583;
        Mon, 15 Apr 2024 21:50:51 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-43-179-50.web.vodafone.de. [109.43.179.50])
        by smtp.gmail.com with ESMTPSA id e21-20020a056402105500b0056e685b1d45sm5638987edu.87.2024.04.15.21.50.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Apr 2024 21:50:51 -0700 (PDT)
Message-ID: <75b85c85-1c82-487b-91dd-024c2e7163e1@redhat.com>
Date: Tue, 16 Apr 2024 06:50:50 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v8 03/35] migration: Add a migrate_skip
 command
To: Nicholas Piggin <npiggin@gmail.com>, Nico Boehr <nrb@linux.ibm.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Andrew Jones
 <andrew.jones@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
References: <20240405083539.374995-1-npiggin@gmail.com>
 <20240405083539.374995-4-npiggin@gmail.com>
 <171259197029.48513.5232971921641010684@t14-nrb>
 <D0L83A745KF8.1KXG6GEDFXSZD@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <D0L83A745KF8.1KXG6GEDFXSZD@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16/04/2024 05.22, Nicholas Piggin wrote:
> On Tue Apr 9, 2024 at 1:59 AM AEST, Nico Boehr wrote:
>> Quoting Nicholas Piggin (2024-04-05 10:35:04)
>> [...]
>>> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
>>> index 39419d4e2..4a1aab48d 100644
>>> --- a/scripts/arch-run.bash
>>> +++ b/scripts/arch-run.bash
>> [...]
>>> @@ -179,8 +189,11 @@ run_migration ()
>>>                  # Wait for test exit or further migration messages.
>>>                  if ! seen_migrate_msg ${src_out} ;  then
>>>                          sleep 0.1
>>> -               else
>>> +               elif grep -q "Now migrate the VM" < ${src_out} ; then
>>>                          do_migration || return $?
>>> +               elif [ $skip_migration -eq 0 ] && grep -q "Skipped VM migration" < ${src_out} ; then
>>> +                       echo > ${src_infifo} # Resume src and carry on.
>>> +                       break;
>>
>> If I understand the code correctly, this simply makes the test PASS when
>> migration is skipped, am I wrong?
> 
> This just gets the harness past the wait-for-migration phase, it
> otherwise should not change behaviour.
> 
>> If so, can we set ret=77 here so we get a nice SKIP?
> 
> The harness _should_ still scan the status value printed by the
> test case when it exits. Is it not working as expected? We
> certainly should be able to make it SKIP.

I just gave it a try (by modifying the selftest-migration-skip test 
accordingly), and it seems to work fine, so I think this patch here should 
be ok.

  Thomas



