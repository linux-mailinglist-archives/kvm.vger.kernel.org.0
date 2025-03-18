Return-Path: <kvm+bounces-41461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E8C35A67FD9
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 23:36:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4555D19C1DC2
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 22:36:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC7742066D8;
	Tue, 18 Mar 2025 22:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="W7thV3+8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5532F36
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 22:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742337398; cv=none; b=lyWsfu7iBVvovu1imvtzaRXA+1QTquRwjVI+yj/zId1jCzU4kZpxvZAhoZvlKO5T1lHuNBmunwH0UaKOcT/a0ARX/jDoE6B/9Hs5gCejLaUJntn9n9mnd3Qyp9Bz3ONGjEhJmnV3mAtflPhXOlijvLFhxQ/T+8FfIAKmXAKW+BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742337398; c=relaxed/simple;
	bh=t4yk7wmiueq8C3mRvfJRi6CBzXLU7tndyfPcGtXzorQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IYZKKZBeeUwG+TBUxhB0myeGo20c+BS2M4LgJt83zWDcPXjJiiO1/xl1VdW5G5KlbwUwKag4tgvkWQTGuuZsWdscadMUeL392+Ejr/DkrMy8V1VbXN6VG1REA6gUhda6VTPKlcfrILHU/oQLDLLHTjglzG7YrAfmfg0lImXrY/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=W7thV3+8; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-224019ad9edso5592505ad.1
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 15:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742337397; x=1742942197; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UUhi9h0Ky4Lwg2yhKJLazGJR+aageMiVJ0t5ECQWEPk=;
        b=W7thV3+8O3udalVql1NfgCj+BGHLS8MpQ1Joq19Q8JJ20Ltd8VRCal5kdaYj3RHW6q
         l6Gh6XXWlsTSa99VMv1olCtU2ycxAJxbY1BYrxFtErzTJRItg6iC99mOPWagiBiNeobe
         e9XLdo+MR5hcmIMd3Vzsicj0R8QbpVphe/gLGTnzG+gaEUzp7XbxhAMfdfP7JrEtMjwt
         cGHFtcysv7z+e57rnBoLyS3yYYzwbuTjIyDbLHbDYmIcP7awoMyeBlBiYqvNcmSswU+m
         M/Oq67l/BhBU0rRk9lBVsXfpzsS+D9SVwG1lDib3r4DubrAmAkotIPzBWEHnTE8yaguS
         5G/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742337397; x=1742942197;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UUhi9h0Ky4Lwg2yhKJLazGJR+aageMiVJ0t5ECQWEPk=;
        b=SSYBQbRIMTJLCtBk03JRVIDQH2rGs1/SGDDoJRUyFCIG5U7W6Ti7l0zlinnFE5HhW0
         Vj+K1zI46x6jt00XIuhOKkcSL2F8H13HWndNxtPaF+Zd99xJMs6N8vFn3JNyCQfpgpxk
         byaElB0SYuCXQpl8fRgAaMD++MaZH8XvuolEckQpRl4l7snvblf3Mj1QwljO1qfj2ijc
         pUPs1wLlfXpJMNRXPm7dsHKKqKw6J0fGAR3vxOUK3GM/e/P4NX8RLwRE3+fQ2x52KyD2
         z7Vln4FcioPxfXVgYD0Qru6wAkjgQT7bFuFerMwCmDNsvikoTanGZHLOrArnf5Nnkgr9
         1FLw==
X-Forwarded-Encrypted: i=1; AJvYcCXTOw6OV2WvovjQmp6Erxp9tFY4nRr9Td2gXTKh0L9KC7BM1sdo51fiqkoyVb1phxybq/c=@vger.kernel.org
X-Gm-Message-State: AOJu0YzAXf5XkZkEKxuSKMU1Edqt6CgBoYyXgXOY9Ox5aB18+WA0MS5x
	p7Hx3/HZneY4pUGYOJAU7+oiokvUHPs/YjcRKK6WUki6gMQHovFf0LFLq+PHMq8=
X-Gm-Gg: ASbGncuA9QSlZidq70HNQluNCvY703XS2DiYjf9KOSxvUOJzwTsWDyX8l3HQwf4I22X
	WK2+qLAr4cfL9/4hi3NN6yP9qLon/qJR8/9OrmhNw6s+jIDsPaGej+XH9QHmWUbgRfvnymD6NRT
	RTOIH5dEY72veOBflGE5Mo6B2wRvcp3xwlLvFlpIkYKMcnaKveIDD3ovhyVKCJZxPz/3Nq6cAkz
	MqfkqPklQ6oRfGa+rWb7uMxqYyVyM720CrkwMSJBTAdNtzWNQOBoCM735YcZBKnnS82mHJMBSrJ
	EM340ZgRxy4k64/ve4nNlSzBNlOFTP6NeqdZ5LFZ05OiQnWxCrmveI3XpGToJtO1BYiwx+p/zl9
	Og1LIDLai
X-Google-Smtp-Source: AGHT+IF/EP9tvkxdUM+YtdNjRtxjdctiECzFem2hCJcdLxuxEimfX8lMgON8I3Z9Cbv3sCS9h/91yw==
X-Received: by 2002:a17:90b:4a11:b0:2fe:b174:31fe with SMTP id 98e67ed59e1d1-301bde51a32mr547250a91.2.1742337396781;
        Tue, 18 Mar 2025 15:36:36 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf589bccsm37460a91.11.2025.03.18.15.36.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 15:36:36 -0700 (PDT)
Message-ID: <ac79c5f1-d7ea-4079-b042-3805063fddba@linaro.org>
Date: Tue, 18 Mar 2025 15:36:33 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/13] exec/cpu-all: allow to include specific cpu
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 qemu-arm@nongnu.org, alex.bennee@linaro.org,
 Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
 <20250318045125.759259-5-pierrick.bouvier@linaro.org>
 <35c90e78-2c2c-4bbb-9996-4031c9eef08a@linaro.org>
 <7202c9e9-1002-4cdc-9ce4-64785aac5de4@linaro.org>
 <0c6f23d5-d220-4fa7-957e-8721f1aa732f@linaro.org>
 <172a10d0-f479-4d6c-9555-a9060bdf744e@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <172a10d0-f479-4d6c-9555-a9060bdf744e@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/18/25 15:25, Pierrick Bouvier wrote:
> On 3/18/25 15:21, Richard Henderson wrote:
>> On 3/18/25 15:16, Pierrick Bouvier wrote:
>>>> This doesn't make any sense to me.  CPU_INCLUDE is defined within the very file that
>>>> you're trying to include by avoiding "cpu.h".
>>>>
>>>
>>> Every target/X/cpu.h includes cpu-all.h, which includes "cpu.h" itself, relying on per
>>> target include path set by build system.
>>
>> So, another solution would be to fix the silly include loop?
>>
> 
> If you're ok with it, I'm willing to remove cpu-all.h completely (moving tlb flags bits in 
> a new header), and fixing missing includes everywhere.
> 
> I just wanted to make sure it's an acceptable path before spending too much time on it.

I would very much like cpu-all.h to go away.

It looks like we have, on tcg-next:

(1) cpu_copy is linux-user only, and should go in linux-user/qemu.h.

(2) the TLB flags certainly deserve their own header.

(3) The QEMU_BUILD_BUG_ON assertions need not be done in a header,
     so long as there is *some* file that won't build if the assertions fail.
     Perhaps cpu-target.c is as good as any.


r~

