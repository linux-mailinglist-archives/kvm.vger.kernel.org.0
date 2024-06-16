Return-Path: <kvm+bounces-19747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 778AB909F49
	for <lists+kvm@lfdr.de>; Sun, 16 Jun 2024 20:43:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DF33B1F2288B
	for <lists+kvm@lfdr.de>; Sun, 16 Jun 2024 18:43:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AF70446A1;
	Sun, 16 Jun 2024 18:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JooFOKOE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFDD49628
	for <kvm@vger.kernel.org>; Sun, 16 Jun 2024 18:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718563422; cv=none; b=Mg5w4oRL9t6ueCFe8aQWWUz1XM6JzUH3VHTxbqatSYTko1+Doqg3m6fmzFJV2BZHL3EoMJE0+bFNRTwzHIHMtk23iOpX39znbsWwUqgDag7xTui9jhokElq43a2z6NKZA/hBm6/4bIxssitRJTK11iqCQK5VxUYclc2Am5yqG7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718563422; c=relaxed/simple;
	bh=Zskto/y7k+dLCGwYwnq3X2jWBzmoa/eMOCY4QKOsF/w=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=NmlUHf56ixqrjRfuQAjEnFN7CMbmfF4q0hH/OK1o2tKkM6f7Yqz5aXOEZCWXp0yMsSZbXZcyDw8j1aQofKQx3Jpx8/aJDCKqYDYWWGYsYfWhFAIDh1PpdnzrH2oB8RghMP3PmA4lTOjEPPO5qZIjWKFTlMVmXwaNORlobRdea7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JooFOKOE; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-421b9068274so33450315e9.1
        for <kvm@vger.kernel.org>; Sun, 16 Jun 2024 11:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718563418; x=1719168218; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=61uU3w5r/LIuL9mGfsdmC7+uInEtZsL4PLydE/0gEyQ=;
        b=JooFOKOESEurTYdPaPMXAtALHRMytr9QUTWhmXUjtZjnvp9k7tgmHV6yuzNQIeK/c4
         Xpal59/j/N2RwBpEuYlwkg7HJqvwN1oBqulGEzAXDRKJ5pjiqzzePvZWe9DRe62HY44n
         V/fF6NZCQPibe7gbh893nkTtxhEDpmA6Xrg5xnA5IzTOI1LMss9NeRuNQgDbwkKTp1oV
         87i3d3PDz3u5k4zrl56YkhjWZ/rygeoD24ZIu+vM/63TqNXrLFszBIrVN6qmALAqUqyW
         keenA+5Tmb2Mw4AQTkcIBYWx1YA0DVoReeXi8WJyUG4rgRMEJXwwkJ1XTzJI3JOjDYRt
         KBYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718563418; x=1719168218;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=61uU3w5r/LIuL9mGfsdmC7+uInEtZsL4PLydE/0gEyQ=;
        b=EGc3Te5n5BcQTfwUjxDStsXEBDRxUeY4i7y84pOPVB35MahRXF1BGTRPeM6fZbrT/d
         bdmVd/ZJCy+aYAfd4DI08bKNcL/mkc7ebadX+6JD5plEq7asHJshFt661hA19W030JWP
         RzBK/LZj0ZWLRY5eWZMnpX7T5gelKIEoc4CVI+ZWvXQjGhq5eSINOyNvDQfNWqQ9tXHO
         I8//iRgvAxsLqo19EuP+Z2XxFfKMgbxzy0AhI9KW2lhbMKLpuJ67IlN75BuSDqAW/oNh
         UkRwErzhhac5TPzfmR15Iw3XX1rPQ+g942Ay1YcgsRWD9OvIpi7BHUlVvphr9q6GXtbu
         unrQ==
X-Forwarded-Encrypted: i=1; AJvYcCWFQtuS4x0lTgjlkdd9vWzI4AM4p/3xjHezPTUMNCJINwx3Lkut8U7SXWyg1cLavgBOWiQ1Sfj2PHE9UYMCHHzF4h3f
X-Gm-Message-State: AOJu0YzegAasSRVeX0y1ubpMabBL/ENkA7SQN77V3elpaEbgcUxPs7EF
	4rQHNmSd2uJVJCVbPX/11F2MNJEpQCDHGlzaXqzEtnjM6vZ2eDTOtGIOajMeCTA=
X-Google-Smtp-Source: AGHT+IEldkSREus3vB6BTyry8+OqgS+HADxfRtbrtfhNZMy3m6/pRi886sUQFFDfdu2/VhLJuWDQFg==
X-Received: by 2002:a5d:4a4c:0:b0:35f:1d29:db8d with SMTP id ffacd0b85a97d-3607a76374dmr4589048f8f.25.1718563418197;
        Sun, 16 Jun 2024 11:43:38 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36075104a3dsm10173809f8f.112.2024.06.16.11.43.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Jun 2024 11:43:37 -0700 (PDT)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 429C85F91D;
	Sun, 16 Jun 2024 19:43:37 +0100 (BST)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Cc: Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
  qemu-devel@nongnu.org,
  David Hildenbrand <david@redhat.com>,  Ilya Leoshkevich
 <iii@linux.ibm.com>,  Daniel Henrique Barboza <danielhb413@gmail.com>,
  Marcelo Tosatti <mtosatti@redhat.com>,  Paolo Bonzini
 <pbonzini@redhat.com>,  Mark Burton <mburton@qti.qualcomm.com>,
  qemu-s390x@nongnu.org,  Peter Maydell <peter.maydell@linaro.org>,
  kvm@vger.kernel.org,  Laurent Vivier <lvivier@redhat.com>,  Halil Pasic
 <pasic@linux.ibm.com>,  Christian Borntraeger <borntraeger@linux.ibm.com>,
  Alexandre Iooss <erdnaxe@crans.org>,  qemu-arm@nongnu.org,  Alexander
 Graf <agraf@csgraf.de>,  Nicholas Piggin <npiggin@gmail.com>,  Marco
 Liebel <mliebel@qti.qualcomm.com>,  Thomas Huth <thuth@redhat.com>,  Roman
 Bolshakov <rbolshakov@ddn.com>,  qemu-ppc@nongnu.org,  Mahmoud Mandour
 <ma.mandourr@gmail.com>,  Cameron Esfahani <dirty@apple.com>,  Jamie Iles
 <quic_jiles@quicinc.com>,  "Dr. David Alan Gilbert" <dave@treblig.org>,
  Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH 9/9] contrib/plugins: add ips plugin example for cost
 modeling
In-Reply-To: <db8d82d4-c88d-45ac-bc99-e85a4240add2@linaro.org> (Pierrick
	Bouvier's message of "Fri, 14 Jun 2024 10:39:38 -0700")
References: <20240612153508.1532940-1-alex.bennee@linaro.org>
	<20240612153508.1532940-10-alex.bennee@linaro.org>
	<31ba8570-9009-4530-934d-3b73b07520d0@linaro.org>
	<db8d82d4-c88d-45ac-bc99-e85a4240add2@linaro.org>
Date: Sun, 16 Jun 2024 19:43:37 +0100
Message-ID: <87frtcsp7q.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Pierrick Bouvier <pierrick.bouvier@linaro.org> writes:

> On 6/13/24 01:54, Philippe Mathieu-Daud=C3=A9 wrote:
>> On 12/6/24 17:35, Alex Benn=C3=A9e wrote:
>>> From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>>>
>>> This plugin uses the new time control interface to make decisions
>>> about the state of time during the emulation. The algorithm is
>>> currently very simple. The user specifies an ips rate which applies
>> ... IPS rate (Instructions Per Second) which ...
>>=20
>>> per core. If the core runs ahead of its allocated execution time the
>>> plugin sleeps for a bit to let real time catch up. Either way time is
>>> updated for the emulation as a function of total executed instructions
>>> with some adjustments for cores that idle.
>>>
>>> Examples
>>> --------
>>>
>>> Slow down execution of /bin/true:
>>> $ num_insn=3D$(./build/qemu-x86_64 -plugin ./build/tests/plugin/libinsn=
.so -d plugin /bin/true |& grep total | sed -e 's/.*: //')
>>> $ time ./build/qemu-x86_64 -plugin ./build/contrib/plugins/libips.so,ip=
s=3D$(($num_insn/4)) /bin/true
>>> real 4.000s
>>>
>>> Boot a Linux kernel simulating a 250MHz cpu:
>>> $ /build/qemu-system-x86_64 -kernel /boot/vmlinuz-6.1.0-21-amd64 -appen=
d "console=3DttyS0" -plugin ./build/contrib/plugins/libips.so,ips=3D$((250*=
1000*1000)) -smp 1 -m 512
>>> check time until kernel panic on serial0
>>>
>>> Tested in system mode by booting a full debian system, and using:
>>> $ sysbench cpu run
>>> Performance decrease linearly with the given number of ips.
>>>
>>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>>> Message-Id: <20240530220610.1245424-7-pierrick.bouvier@linaro.org>
>>> ---
>>>    contrib/plugins/ips.c    | 164 +++++++++++++++++++++++++++++++++++++=
++
>>>    contrib/plugins/Makefile |   1 +
>>>    2 files changed, 165 insertions(+)
>>>    create mode 100644 contrib/plugins/ips.c
>>>
>>> diff --git a/contrib/plugins/ips.c b/contrib/plugins/ips.c
>>> new file mode 100644
>>> index 0000000000..db77729264
>>> --- /dev/null
>>> +++ b/contrib/plugins/ips.c
>>> @@ -0,0 +1,164 @@
>>> +/*
>>> + * ips rate limiting plugin.
>> The plugin names are really to packed to my taste (each time I look
>> for
>> one I have to open most source files to figure out the correct one); so
>> please ease my life by using a more descriptive header at least:
>>        Instructions Per Second (IPS) rate limiting plugin.
>> Thanks.
>>=20
>
> I agree most of the plugin names are pretty cryptic, and they are
> lacking a common "help" system, to describe what they do, and which
> options are available for them. It's definitely something we could add
> in the future.
>
> Regarding what you reported, I'm totally ok with the change.
>
> However, since this is a new series, I'm not if I or Alex should
> change it. If it's ok for you to modify this Alex, it could be simpler
> than waiting for me to push a new patch with just this.

Its my tree so I'll fix it up. I'll ask you if I want a respin ;-)

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

