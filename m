Return-Path: <kvm+bounces-40338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04D3BA56AD7
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 15:51:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D64E816E7F9
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 14:51:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CF57218EB5;
	Fri,  7 Mar 2025 14:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="G6fqniQN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545A716EB4C
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 14:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741359059; cv=none; b=Jznc67MjwNtH4V8MEXhPlGElcLJ/X5cIC9D5BOnM3+KKKS5eeevQ0yG5FFiFNXMie9xX4P9ZsTdqyWvJojIqbNaeW4EwyNbLDz8qhvk+43DFnHLO1GY8Ww9uwr8DFd250eu0OkuPjGhDMTeJA5YBB2MiwPy1V1CbSxc+mYkGWRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741359059; c=relaxed/simple;
	bh=eAedVYtfVf3yxgzI40aE73Utpr7yVE8JA/C++NA9E18=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Td8rmncd+4MK13bwf4pbWs8IrltkaGXGKV7tD7GbyxwAP24KzVANEQtIdCGY7bdfn1dpZenfA60i3/85epTWODzlcRBrBUdWCo57IvoBeoIGSRc1U+baB8AIE6gC5qJeSe7sfNpk3G3U1wK5Ym1HJjnJuge6/Gvs2jPOkmRHMy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=G6fqniQN; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5e539ea490dso2476901a12.0
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 06:50:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741359056; x=1741963856; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dNZtIZJytF/Zt61U4OrGGE9iALPc/9QtNmwJUb2ZA74=;
        b=G6fqniQNdOXnHM7miLhqlrGOwQJo9ZUoYxkX0C/sNfnrs3OJxuGEOr1Z/mqfsywHiA
         2qUO3ktmvH6p38n2ca/wzuijdNDk9HquCkuMdXgsVPkf24X4+z/pK5gwZ/UvQhqNKOxH
         EW+dtiJthDJ1uj5HLDWzmZxcgU4Qtav5cIlaCPfvBTz+yF+VvTQzUCJ23tXFfGQHSF5K
         iBRvQH2pH3ud/N4OdCq9AGJAbgGAftMUxRXOC2ek9cZnyBB5L5XwNk2vsLKOYWV82D7y
         9hzttu/R8ctSbYClijt4W1uLbUA+rxZXhZVsmxfqSiyrB7Y33nBhoIw1FZqDtVA2Fo9f
         aRoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741359056; x=1741963856;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dNZtIZJytF/Zt61U4OrGGE9iALPc/9QtNmwJUb2ZA74=;
        b=aSnNX22ZVl98zHMoBwcqp9c55Td/lwhSYK0fPHlPd1XtXutwHRLVfxkv825KvrvLTG
         f+SNi8kPil6V29ajxKjiFZqf0kj+xsp9b8mSIUmiNt3+tfXOiDi2cizXGOKNRjFsZwFC
         eUCja1LF6M0erAzYlligV/faMSJVFqpBo/7r81GFBQ2ZPE+L3tOHyHjjeviBMkOiwaty
         m7410UIFcn+E7wXlLwzYyCEIyediEdm9iOjePfl3EdSMFCBdN98klSNdcKK+QenB95wO
         gBwzYg+n17ldlfbMwtwPjqEQL17yB1FwtbnnkX5kNmLjCPkDYUQevi3pQwdPRUI3wUwn
         NuUQ==
X-Forwarded-Encrypted: i=1; AJvYcCVpQsJwffz5UHfNPmeD2/dOsk59/ptdHUFPw/Ndl6THBd2wt1E9pruDTZtEQspjKPVtWCI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOXkq1zDG7F8S/sUANaFS9h++h9EFIIDLrmVVD0H9PXKLXhnTR
	01YeDKtiCkwwg9HEd/pHuzkDhEVIYK+XsE1hWiTTXVnEFk+ugFTfcoy2NMUqA7I=
X-Gm-Gg: ASbGncuubpz76Uyxr10kv8QFaatysGz4IH0PvRt6CzG9ad0yjPYSif9EYMIg78eB1Fo
	AlRaO+ngzib1xxM59A4FBc5OaqwuuhqvBgUmS72xqbl8/2l+vUKrsKjHdDCGFqQEWN1An3MJgAR
	NlKoa3OPk+QE1nVCzJ2syrr0d4vtU5qiWKwdDMyx0gy2QHNgL838XbbTXVdRCdruFUdBjXZJVle
	N6VB6aUqrZqISuk0lXXa7i4QYBdvGFY2St2tou4emEo7Wn7zJW2HOwIFcxXVLVSM9DwTVxTO0YR
	2ab6I/YLPY30n6alJUeIzX1QSAC92rDfL/QXcKhTv9fQ8+w=
X-Google-Smtp-Source: AGHT+IGlT1ukA1jbMwwSvTcNJeSfQ9ZpWZAeZEzYscuw2hkZ6zyCLpFa1cLRIlIwBB9gpCeXrZuDzg==
X-Received: by 2002:a05:6402:34c7:b0:5e5:ba77:6f24 with SMTP id 4fb4d7f45d1cf-5e5e22d4c66mr8934967a12.16.1741359054974;
        Fri, 07 Mar 2025 06:50:54 -0800 (PST)
Received: from draig.lan ([185.126.160.109])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e5c745c552sm2726825a12.17.2025.03.07.06.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 06:50:54 -0800 (PST)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 27D825F90C;
	Fri,  7 Mar 2025 14:50:53 +0000 (GMT)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: Pierrick Bouvier <pierrick.bouvier@linaro.org>,  kvm@vger.kernel.org,
  Paolo Bonzini <pbonzini@redhat.com>,  Philippe =?utf-8?Q?Mathieu-Daud?=
 =?utf-8?Q?=C3=A9?=
 <philmd@linaro.org>,  Richard Henderson <richard.henderson@linaro.org>,
  qemu-devel@nongnu.org,  manos.pitsidianakis@linaro.org,  Marcelo Tosatti
 <mtosatti@redhat.com>
Subject: Re: [PATCH 5/7] hw/hyperv/syndbg: common compilation unit
In-Reply-To: <95a6f718-8fab-434c-9b02-6812f7afbcc3@maciej.szmigiero.name>
	(Maciej S. Szmigiero's message of "Fri, 7 Mar 2025 12:07:25 +0100")
References: <20250306064118.3879213-1-pierrick.bouvier@linaro.org>
	<20250306064118.3879213-6-pierrick.bouvier@linaro.org>
	<353b36fd-2265-43c3-8072-3055e5bd7057@linaro.org>
	<35c2c7a5-5b12-4c21-a40a-375caae60d0c@linaro.org>
	<d62743f5-ca79-47c0-a72b-c36308574bdd@linaro.org>
	<6556fdd8-83ea-4cc6-9a3b-3822fdc8cb5d@linaro.org>
	<95a6f718-8fab-434c-9b02-6812f7afbcc3@maciej.szmigiero.name>
User-Agent: mu4e 1.12.9; emacs 30.1
Date: Fri, 07 Mar 2025 14:50:53 +0000
Message-ID: <87o6yc3nea.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

"Maciej S. Szmigiero" <mail@maciej.szmigiero.name> writes:

> On 6.03.2025 23:56, Pierrick Bouvier wrote:
>> On 3/6/25 09:58, Philippe Mathieu-Daud=C3=A9 wrote:
>>> On 6/3/25 17:23, Pierrick Bouvier wrote:
>>>> On 3/6/25 08:19, Richard Henderson wrote:
>>>>> On 3/5/25 22:41, Pierrick Bouvier wrote:
>>>>>> Replace TARGET_PAGE.* by runtime calls
>>>>>>
>>>>>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>>>>>> ---
>>>>>> =C2=A0=C2=A0=C2=A0 hw/hyperv/syndbg.c=C2=A0=C2=A0=C2=A0 | 7 ++++---
>>>>>> =C2=A0=C2=A0=C2=A0 hw/hyperv/meson.build | 2 +-
>>>>>> =C2=A0=C2=A0=C2=A0 2 files changed, 5 insertions(+), 4 deletions(-)
>>>>>>
>>>>>> diff --git a/hw/hyperv/syndbg.c b/hw/hyperv/syndbg.c
>>>>>> index d3e39170772..f9382202ed3 100644
>>>>>> --- a/hw/hyperv/syndbg.c
>>>>>> +++ b/hw/hyperv/syndbg.c
>>>>>> @@ -14,7 +14,7 @@
>>>>>> =C2=A0=C2=A0=C2=A0 #include "migration/vmstate.h"
>>>>>> =C2=A0=C2=A0=C2=A0 #include "hw/qdev-properties.h"
>>>>>> =C2=A0=C2=A0=C2=A0 #include "hw/loader.h"
>>>>>> -#include "cpu.h"
>>>>>> +#include "exec/target_page.h"
>>>>>> =C2=A0=C2=A0=C2=A0 #include "hw/hyperv/hyperv.h"
>>>>>> =C2=A0=C2=A0=C2=A0 #include "hw/hyperv/vmbus-bridge.h"
>>>>>> =C2=A0=C2=A0=C2=A0 #include "hw/hyperv/hyperv-proto.h"
>>>>>> @@ -188,7 +188,8 @@ static uint16_t handle_recv_msg(HvSynDbg *syndbg,
>>>>>> uint64_t outgpa,
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 uint6=
4_t timeout, uint32_t
>>>>>> *retrieved_count)
>>>>>> =C2=A0=C2=A0=C2=A0 {
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 uint16_t ret;
>>>>>> -=C2=A0=C2=A0=C2=A0 uint8_t data_buf[TARGET_PAGE_SIZE - UDP_PKT_HEAD=
ER_SIZE];
>>>>>> +=C2=A0=C2=A0=C2=A0 const size_t buf_size =3D qemu_target_page_size(=
) -
>>>>>> UDP_PKT_HEADER_SIZE;
>>>>>> +=C2=A0=C2=A0=C2=A0 uint8_t *data_buf =3D g_alloca(buf_size);
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hwaddr out_len;
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 void *out_data;
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ssize_t recv_byte_count;
>>>>>
>>>>> We've purged the code base of VLAs, and those are preferable to alloc=
a.
>>>>> Just use g_malloc and g_autofree.
>>>>>
>>>>
>>>> I hesitated, due to potential performance considerations for people
>>>> reviewing the patch. I'll switch to heap based storage.
>>>
>>> OTOH hyperv is x86-only, so we could do:
>>>
>>> #define BUFSZ (4 * KiB)
>>>
>>> handle_recv_msg()
>>> {
>>> =C2=A0=C2=A0=C2=A0 uint8_t data_buf[BUFSZ - UDP_PKT_HEADER_SIZE];
>>> =C2=A0=C2=A0=C2=A0 ...
>>>
>>> hv_syndbg_class_init()
>>> {
>>> =C2=A0=C2=A0=C2=A0 assert(BUFSZ > qemu_target_page_size());
>>> =C2=A0=C2=A0=C2=A0 ...
>>>
>>> and call it a day.
>> Could be possible for now yes.
>> Any opinion from concerned maintainers?
>
> I think essentially hardcoding 4k pages in hyperv is okay
> (with an appropriate checking/enforcement asserts() of course),
> since even if this gets ported to ARM64 at some point
> it is going to need *a lot* of changes anyway.

There was a talk at last years KVM Forum about porting WHPX for Windows
on Arm:

  https://kvm-forum.qemu.org/2024/Qemu_support_for_Windows_on_Arm_GgKlLjf.p=
df

but am I right in thinking all the hyperv code in QEMU is about
providing guest facing enlightenments for Windows guests under KVM? I
guess no one is working on that at the moment.


>
> Thanks,
> Maciej

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

