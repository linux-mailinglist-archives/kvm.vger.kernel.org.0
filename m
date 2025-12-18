Return-Path: <kvm+bounces-66247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E3982CCB4EB
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 11:09:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4EBF030542C9
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 10:07:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02F623328ED;
	Thu, 18 Dec 2025 10:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="obt/VBqd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCE9332EA5
	for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 10:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766052441; cv=none; b=K9xnjNMBdBgSuL+c1zqyHTTDD94GExEOQ77PHnsLxn6m7tFvHG55flDwlL3WzYMGEm0SG+/QExQsP4FtaDdbtUtxlPibHrnlKmpTABJb2IGBX3N/KKKdHYEu37P5e0eEo8Z3Mep5wZDxAtVednfrqYJ4enPRnOqv0nM6qGXbfAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766052441; c=relaxed/simple;
	bh=sX5ot0SWvR4uFdPToYaH3vFF1rWp6L6zdPzZr2BQoWw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ctcvco9V9KoJlUj56px1y86lmuuzi0bdbPzvvlAHwHKgYxXc+CI/tQEXlRpQ6aNRD8Jl3rPfBa8iJFiUvbnyr9PJbIhNemmhC7uAZEsrF4BeL2lMdL4wYnHTaTcpdsyylgAZHDCfaO1ED5oDfCBwpkIe7GnhIHJQ6hIxMSR8JSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=obt/VBqd; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-42fb2314f52so234928f8f.0
        for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 02:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1766052437; x=1766657237; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3XTSYsbyxz/KIY73QMVlXMluHU7KeBcQcAPsFtAx27k=;
        b=obt/VBqd1c70xyvl/JoGJmhkGIYzj3A8KdKLRtPYoLe55poPBMhTTXQmKtik5wt/e6
         gVFvWmYfIRVmspb46njTV/y5Nbot8Ps/1SxXiQLWCJ+34S10IOHEiRqJ6PfBGIa7k0Ck
         aNG4hgWSiZDI8kvB4YPtaMqYEfGwaKVgrEScs3shIvGYFkJymlIQi/oLf07PBhHXAYNh
         p2dLRTQckIqJ2xx/qDlgF+yQeT2GD7v52cYVnBV3QnQiA4ifJu8mtRWldD5nE9HIx69S
         foQD8joLdNWJJpUrRA4jogDB4yAOdelbvNM82rOTZddGgX3SRSdBu1ge1nB3t18Hxdh2
         gH7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766052437; x=1766657237;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3XTSYsbyxz/KIY73QMVlXMluHU7KeBcQcAPsFtAx27k=;
        b=clKu3NrVAr4+wu1si8EgzuqHlelwBrqDmU5SyzCYG4VKVA0w60iA9IrZbCFNX0qSvl
         uJPP+2bRaUT7xQtYn2WYljpcVpz9G+9yV6rn7DWgATho2nfvDyu0Bk1j1ZBB/IOPaZWS
         istttkUXXQGkYhzpwfY+YD0y4kduHLsweaaLyLSPdzN297UPfNPzughfIwtbtzADmJ6b
         m42KTZ5753tWc2KQ8TZoXepx0NourfOx0yZ0Vx0ko+mvBPB7bTf0KCnUT/Ihf2ZhdcCw
         7ezRDKEde65CFpaxvKiXrP7ou/5huxy+QRlGEsxPEJcKb7OTGANL5SLb6nrqRNYasVMG
         G+Sg==
X-Gm-Message-State: AOJu0YyDgDBxRBQL9OO0fbGq45g3iCY6RteEfq/VyG1LCb7ZBi0adOJJ
	ZBB0SuBcB/n5INr9QrOEkXHCNtizfmsDZOesIFVz27oBMuqCejPp7WH7MQhOlHq5lRs=
X-Gm-Gg: AY/fxX7kOjXG9lAz9LEEoTt0pzMpru5YX8mEOqq6aXxImG8etMCdhtEtu+kZsxVqDv5
	/V0fee0WiUBAAlLSqgIZ0j3aWh0kFIgcWPb8/R3uNkAJQdCYvdcP1GUA2uPrPPYrg0L1cO1IMCM
	amnLs0gUMXCZtYjKjY2sMNp1KlI2yquIh6DcznAJ5JsLyLutIR2WfN78VjggPpL2ubEArt75lmE
	MOK7/EKRZcRoGZsw3GBwmTMvaQDhr0G8lHJaFZza4hIeeoA7eZBa7IbY+DQI5H2xkCRq+oD8XsY
	BGEWJ3oloJgdBz49e9Jh19oYnFmtrK5Ep20xzttlczUPlB9NySwZxO96jrmVBDprK3Piq7LOLWB
	3Pnvp1f/JMaJz0+3BukAJiXxi32Oie5DrXmXW0XImA3VT9DzTITpLbpR02C3dKaHv/HbuerJjkd
	9FK8vAjGbPO7UdiDfduqe7JW6VQnJuWl80hkY7HXFeRgzAeNIZXNZprnGqW9qNI8aZV8TBfze9d
	Iy0nqq6D2KQA7Tk09z2bwr8vABcSUs4XPU/6buLyNRCcfQ=
X-Google-Smtp-Source: AGHT+IFYcQZYNoE7IFGpPLaAgvf7Oneyj5Y8t7UvDpSWbX4/UjEfrN/2gkJmtzsovfR1iQr8f9fTfg==
X-Received: by 2002:a05:6000:2888:b0:430:8583:d196 with SMTP id ffacd0b85a97d-4308583d267mr20126634f8f.33.1766052436717;
        Thu, 18 Dec 2025 02:07:16 -0800 (PST)
Received: from ?IPV6:2003:fa:af29:b100:e8b2:7dbf:b11:65fc? (p200300faaf29b100e8b27dbf0b1165fc.dip0.t-ipconnect.de. [2003:fa:af29:b100:e8b2:7dbf:b11:65fc])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324498f965sm4200787f8f.20.2025.12.18.02.07.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Dec 2025 02:07:16 -0800 (PST)
Message-ID: <769da4d7-0e8c-447a-be6b-1e3ad9a0ae36@grsecurity.net>
Date: Thu, 18 Dec 2025 11:07:14 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 0/4] Better backtraces for leaf
 functions
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andrew Jones <andrew.jones@linux.dev>, Eric Auger <eric.auger@redhat.com>,
 Thomas Huth <thuth@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20250915215432.362444-1-minipli@grsecurity.net>
 <176314469132.1828515.1099412303366772472.b4-ty@google.com>
 <15788499-87c6-4e57-b3ae-86d3cc61a278@grsecurity.net>
 <aRufV8mPlW3uKMo4@google.com>
 <083276ef-ff1b-4ac3-af19-3f73b1581d39@grsecurity.net>
 <0274322e-e28c-4511-a565-6bb85bfade8b@grsecurity.net>
 <3bac29b9-4c49-4e5d-997e-9e4019a2fceb@grsecurity.net>
 <aUNci6Oy1EXXoQuY@google.com>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 xsDNBF4u6F8BDAC1kCIyATzlCiDBMrbHoxLywJSUJT9pTbH9MIQIUW8K1m2Ney7a0MTKWQXp
 64/YTQNzekOmta1eZFQ3jqv+iSzfPR/xrDrOKSPrw710nVLC8WL993DrCfG9tm4z3faBPHjp
 zfXBIOuVxObXqhFGvH12vUAAgbPvCp9wwynS1QD6RNUNjnnAxh3SNMxLJbMofyyq5bWK/FVX
 897HLrg9bs12d9b48DkzAQYxcRUNfL9VZlKq1fRbMY9jAhXTV6lcgKxGEJAVqXqOxN8DgZdU
 aj7sMH8GKf3zqYLDvndTDgqqmQe/RF/hAYO+pg7yY1UXpXRlVWcWP7swp8OnfwcJ+PiuNc7E
 gyK2QEY3z5luqFfyQ7308bsawvQcFjiwg+0aPgWawJ422WG8bILV5ylC8y6xqYUeSKv/KTM1
 4zq2vq3Wow63Cd/qyWo6S4IVaEdfdGKVkUFn6FihJD/GxnDJkYJThwBYJpFAqJLj7FtDEiFz
 LXAkv0VBedKwHeBaOAVH6QEAEQEAAc0nTWF0aGlhcyBLcmF1c2UgPG1pbmlwbGlAZ3JzZWN1
 cml0eS5uZXQ+wsERBBMBCgA7AhsDBQsJCAcCBhUKCQgLAgQWAgMBAh4BAheAFiEEd7J359B9
 wKgGsB94J4hPxYYBGYYFAmBbH/cCGQEACgkQJ4hPxYYBGYaX/gv/WYhaehD88XjpEO+yC6x7
 bNWQbk7ea+m82fU2x/x6A9L4DN/BXIxqlONzk3ehvW3wt1hcHeF43q1M/z6IthtxSRi059RO
 SarzX3xfXC1pc5YMgCozgE0VRkxH4KXcijLyFFjanXe0HzlnmpIJB6zTT2jgI70q0FvbRpgc
 rs3VKSFb+yud17KSSN/ir1W2LZPK6er6actK03L92A+jaw+F8fJ9kJZfhWDbXNtEE0+94bMa
 cdDWTaZfy6XJviO3ymVe3vBnSDakVE0HwLyIKvfAEok+YzuSYm1Nbd2T0UxgSUZHYlrUUH0y
 tVxjEFyA+iJRSdm0rbAvzpwau5FOgxRQDa9GXH6ie6/ke2EuZc3STNS6EBciJm1qJ7xb2DTf
 SNyOiWdvop+eQZoznJJte931pxkRaGwV+JXDM10jGTfyV7KT9751xdn6b6QjQANTgNnGP3qs
 TO5oU3KukRHgDcivzp6CWb0X/WtKy0Y/54bTJvI0e5KsAz/0iwH19IB0vpYLzsDNBF4u6F8B
 DADwcu4TPgD5aRHLuyGtNUdhP9fqhXxUBA7MMeQIY1kLYshkleBpuOpgTO/ikkQiFdg13yIv
 q69q/feicsjaveIEe7hUI9lbWcB9HKgVXW3SCLXBMjhCGCNLsWQsw26gRxDy62UXRCTCT3iR
 qHP82dxPdNwXuOFG7IzoGBMm3vZbBeKn0pYYWz2MbTeyRHn+ZubNHqM0cv5gh0FWsQxrg1ss
 pnhcd+qgoynfuWAhrPD2YtNB7s1Vyfk3OzmL7DkSDI4+SzS56cnl9Q4mmnsVh9eyae74pv5w
 kJXy3grazD1lLp+Fq60Iilc09FtWKOg/2JlGD6ZreSnECLrawMPTnHQZEIBHx/VLsoyCFMmO
 5P6gU0a9sQWG3F2MLwjnQ5yDPS4IRvLB0aCu+zRfx6mz1zYbcVToVxQqWsz2HTqlP2ZE5cdy
 BGrQZUkKkNH7oQYXAQyZh42WJo6UFesaRAPc3KCOCFAsDXz19cc9l6uvHnSo/OAazf/RKtTE
 0xGB6mQN34UAEQEAAcLA9gQYAQoAIAIbDBYhBHeyd+fQfcCoBrAfeCeIT8WGARmGBQJeORkW
 AAoJECeIT8WGARmGXtgL/jM4NXaPxaIptPG6XnVWxhAocjk4GyoUx14nhqxHmFi84DmHUpMz
 8P0AEACQ8eJb3MwfkGIiauoBLGMX2NroXcBQTi8gwT/4u4Gsmtv6P27Isn0hrY7hu7AfgvnK
 owfBV796EQo4i26ZgfSPng6w7hzCR+6V2ypdzdW8xXZlvA1D+gLHr1VGFA/ZCXvVcN1lQvIo
 S9yXo17bgy+/Xxi2YZGXf9AZ9C+g/EvPgmKrUPuKi7ATNqloBaN7S2UBJH6nhv618bsPgPqR
 SV11brVF8s5yMiG67WsogYl/gC2XCj5qDVjQhs1uGgSc9LLVdiKHaTMuft5gSR9hS5sMb/cL
 zz3lozuC5nsm1nIbY62mR25Kikx7N6uL7TAZQWazURzVRe1xq2MqcF+18JTDdjzn53PEbg7L
 VeNDGqQ5lJk+rATW2VAy8zasP2/aqCPmSjlCogC6vgCot9mj+lmMkRUxspxCHDEms13K41tH
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <aUNci6Oy1EXXoQuY@google.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------u0IehbX85HN0timF1oZrFJU4"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------u0IehbX85HN0timF1oZrFJU4
Content-Type: multipart/mixed; boundary="------------xVM07hl82XkYJQAQxvVwBdAq";
 protected-headers="v1"
From: Mathias Krause <minipli@grsecurity.net>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andrew Jones <andrew.jones@linux.dev>, Eric Auger <eric.auger@redhat.com>,
 Thomas Huth <thuth@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <769da4d7-0e8c-447a-be6b-1e3ad9a0ae36@grsecurity.net>
Subject: Re: [kvm-unit-tests PATCH v2 0/4] Better backtraces for leaf
 functions
References: <20250915215432.362444-1-minipli@grsecurity.net>
 <176314469132.1828515.1099412303366772472.b4-ty@google.com>
 <15788499-87c6-4e57-b3ae-86d3cc61a278@grsecurity.net>
 <aRufV8mPlW3uKMo4@google.com>
 <083276ef-ff1b-4ac3-af19-3f73b1581d39@grsecurity.net>
 <0274322e-e28c-4511-a565-6bb85bfade8b@grsecurity.net>
 <3bac29b9-4c49-4e5d-997e-9e4019a2fceb@grsecurity.net>
 <aUNci6Oy1EXXoQuY@google.com>
In-Reply-To: <aUNci6Oy1EXXoQuY@google.com>

--------------xVM07hl82XkYJQAQxvVwBdAq
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Sean,

On 18.12.25 02:44, Sean Christopherson wrote:
> On Fri, Nov 21, 2025, Mathias Krause wrote:
>> On 18.11.25 02:47, Mathias Krause wrote:
>>
>> Finally found it. It's register corruption within both host and guest.=

>> [...]
>=20
> *sigh*
>=20
> I'm not going to type out the first dozen words that escaped my mouth w=
hen
> reading this.  I happen to like my job :-)

Me too, that's why I had to switch tasks to gain back some sanity ;)

> [...]
>> I hacked up something to verify my theory and made 'regs' "per-cpu". I=
t
>> needs quite some code churn and I'm not all that happy with it. IMHO,
>> 'regs' and lots of the other VMX management state should be part of so=
me
>> vcpu struct or something. In fact, struct vmx_test already has a
>> 'guest_regs' but using it won't work, as we need offsetable absolute
>> memory references for the inline ASM in vmx_enter_guest() to work as i=
t
>> cannot make use of register-based memory references at all. (My hack
>> uses a global 'scratch_regs' with mutual exclusion on its usage.)
>=20
> So, much to my chagrin, I started coding away before reading your entir=
e mail
> (I got through the paragraph about 'regs' getting clobbered, and then c=
ame back
> to the rest later; that was a mistake).

A common mistake of mine: writing lengthy explanations that don't get
read. Maybe I should start included some tl;dr section for such cases ;)

> I had the exact same idea about making regs per-CPU, but without the qu=
otes.

Actually, I wanted something quick to test, so I went the easy route and
used a global array. However, my plan for a proper fix was to do the
real per-cpu thing, as that would still fit the "offsetable absolute
memory reference" needs for inline asm, as GS/FS-prefixed addresses
would be just fine.

> Of course, because I didn't read your entire mail, converting only regs=
 to be
> per-CPU didn't help.  It actually made things worse (TIL the INIT test =
shares
> a VMCS between CPUs... WTF).

Hah! This rabbit hole has way to many branches!

>=20
> After making launch and in_guest per-CPU, and using RAX to communicate =
hypercalls,

Nice! The use of a global 'hypercall_field' for communicating the
intended hypercall was just puzzling to me. Using registers is such a
more natural way of doing it.

> I've got everything passing (module one unsolvable SIPI wart; see below=
).  I need
> to write changelogs and squash a few fixups, but overall it ended up be=
ing a nice
> cleanuped (de-duplicating the VMX vs. SVM GPR handling drops a lot of c=
ode).  I'm
> tempted to delete a blank lines just to get to net negative LoC :-D
>=20
>  lib/x86/smp.h       |  32 ++++++++++++++++++++++++++++++++
>  lib/x86/virt.h      |  61 ++++++++++++++++++++++++++++++++++++++++++++=
+++++++++++++++++
>  x86/Makefile.common |  14 ++++++++++++++
>  x86/realmode.c      |   3 +++
>  x86/svm.c           |  19 ++++++++-----------
>  x86/svm.h           |  61 +++++++++-----------------------------------=
-----------------
>  x86/svm_tests.c     |   5 +++--
>  x86/vmx.c           | 122 ++++++++++++++++++++++++++++++++++++++++++++=
++++++++++++++-----------------------------------------------------------=
-----
>  x86/vmx.h           |  72 +++-----------------------------------------=
----------------------------
>  x86/vmx_tests.c     | 104 ++++++++++++++++++++++++++++++++++++++++++++=
++++++++++++------------------------------------------------
>  10 files changed, 247 insertions(+), 246 deletions(-)

Not too bad!

>=20
>> To see the register corruption, one could start the vmx_sipi_signal_te=
st
>> test with -s -S, attach gdb to it and add a watch for regs.rax. Steppi=
ng
>> through the test will clearly show how 'regs' get overwritten wrongly.=

>=20
> The test itself is also flawed.  On top of this race that you spotted:
>=20
>  @@ -9985,11 +9985,11 @@ static void vmx_sipi_signal_test(void)        =
       =20
>        /* update CR3 on AP */                                          =
       =20
>        on_cpu(1, update_cr3, (void *)read_cr3());                      =
       =20
>                                                                        =
       =20
>  +     vmx_set_test_stage(0);                                          =
       =20
>  +                                                                     =
       =20
>        /* start AP */                                                  =
       =20
>        on_cpu_async(1, sipi_test_ap_thread, NULL);                     =
       =20
>                                                                        =
       =20
>  -     vmx_set_test_stage(0);                                          =
       =20
>  -                                                                     =
       =20
>        /* BSP enter guest */                                           =
       =20
>        enter_guest();                                                  =
       =20
>   }                               =20
>=20
> This snippet is also broken:
>=20
> 	vmx_set_test_stage(1);
>=20
> 	/* AP enter guest */
> 	enter_guest();
>=20
> because the BSP can think the AP has entered WFS before it has even att=
empted
> VMLAUNCH.  It's "fine" so long as there are host CPUs available, but th=
e test
> fails 100% for me if I run KUT in a VM with e.g. j<number of CPUs>, and=
 on an
> Ivybridge server CPU, it fails pretty consistently.  No idea why, maybe=
 a slower
> nested VM-Enter path?  E.g. the test passes on EMR even if I run with j=
<2x CPUs>.

Yeah, I noticed the failing synchronization between the vCPUs too. I
even tried to fix them by introducing a few more states (simply more
steps). However, then I ended up in deadlocks, as the AP re-enters
vmx_sipi_test_guest() multiple times (well, twice). It was likely
related to the register corruption, I only noticed later. So I believed
those magic sleeps (delay(SIPI_SIGNAL_TEST_DELAY)) are for the lack of
synchronization and should account for the time span of the AP setting a
new step value but not yet having switched to the guest.
It might be worth revisiting my attempts of explicitly adding new step
states, now with the register corrupting being handled...

>=20
> Unfortunately, I can't think of any way to fix that problem.  To recogn=
ize the
> SIPI, the AP needs to do VM-Enter with a WFS activity state, and I'm st=
ruggling
> to think of a way to atomically write software-visible state at the tim=
e of VM-Enter.
> E.g. in theory, the test could peek at the LAUNCHED field in the VMCS, =
but that
> would require reverse engineering the VMCS layout for every CPU.  If KV=
M emulated
> any VM-wide MSRs, maybe we could throw one in the MSR load list?  But a=
ll the ones
> I can think of, e.g. Hyper-V's partition-wide MSRs, aren't guaranteed t=
o be available.

Ahh, that explains the deadlock I observed. So adding more states won't
help. Yeah, it needs some trickery... or those magic sleeps :D

>=20
> Anywho, now that I know what to look for, I can ignore false failures e=
asily enough.
> If someone cares enough to come up with a clever fix, then yay.  Otherw=
ise, I'll
> just deal with the intermittent failures (or maybe nuke and pave).

>=20
> As for this patch, I'll write changelogs and get a series posted with t=
he backtrace
> and realmode patch at the end.

Thanks a lot for picking up the work! For me, KUT is far from my daily
work, so spending time on it cuts on the time budget what I'm actually
supposed to do. After having spent nearly a week in chasing that bug
made me realize, the work to fix it properly would be, at least for me,
yet another week and I didn't had the time for it back then.

Of course, if changes of mine cause regressions, I feel strongly
obligated to fix these -- even if it isn't my code's fault after all.
However, in this case, I just didn't found the time to do so yet. So
thanks again for working on this!

I'll be off for the season from tomorrow on, so may not provide instant
feedback for the series, in case you post it in the next couple of days.
But I'm looking forward reviewing it! :)

One more thing. I was able to land the gcc bug fix[1], so the realmode
patch could be reworded to mention that only "pre gcc-16" is broken but
the patch is still needed as gcc 16 isn't even released yet and far from
being the minimal supported version for KUT.

Thanks,
Mathias

[1] https://gcc.gnu.org/git/?p=3Dgcc.git;a=3Dcommitdiff;h=3D114a19fae9bd

--------------xVM07hl82XkYJQAQxvVwBdAq--

--------------u0IehbX85HN0timF1oZrFJU4
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsD5BAABCAAjFiEEd7J359B9wKgGsB94J4hPxYYBGYYFAmlD0lMFAwAAAAAACgkQJ4hPxYYBGYYP
FgwAn8BB2vS3VNxqG7q2yVG20BQmKHXDNwHp+Ghs5nLOQSrOY5rAlGpahWzga9xdkX8n8YdTCYvz
iXzwCtX5Ct8GJmspuZGIJsH5ZUsO3HiuN8xUs8KGkSLOFNbC1T7dmrTns8VKbmBJkZR55nWb6b2R
CSAvq8dsPHd3bd8HXUd32MDZ5HDOXB+LVP28jTLbs/6MJ8QQOoskxW8ZocmlSPiM4LTSmNIKUV6s
nOHAWLBlIrgO6NStJaD+P6Jm5z5bCdfJa64dq5mVHqt06qhTaU+P+/5GHmNWDNAEyfGkqD1mES5M
68qK7dHo0XE6ELWKtHUJ0gU9FfY3sL1OSbcZSBRHm+6tLzEmNaZiDokz40Raan1Lmj5LjxZBEf0E
quxhpZdi8pm9ZJDSuIJKMKKGAzwjXt9SUVLAPw77fnilHISGx9d1xhIHN0AOucwtz2YYG/CDDK5Y
WjzYZQIpI1Z2HHXU7O4MW6E3uk5C5wimcHEndYMM2xoQU6oYtIhkBJ//9PNW
=gIea
-----END PGP SIGNATURE-----

--------------u0IehbX85HN0timF1oZrFJU4--

