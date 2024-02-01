Return-Path: <kvm+bounces-7756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AAA4845F1A
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 19:01:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C33A5B26D97
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 18:01:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B38F284FAE;
	Thu,  1 Feb 2024 18:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b="2FY75X4n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F8984FA6
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 18:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706810476; cv=none; b=VMX+c5qxYolsuqzfAO0HcNQlf/WOweB5ATCbgroqduMV9jBq9rpcUiq0dnSCMDlXX48Uvfs/1+hP8wG25BeGwLYQ8GZiOJnDvvnfdxzHrWClGhIfCt81cRMjFwlUUSYc0vAuM27XRRR979Kk78WcwRIeuTg8OrYCKlXOCvDA3cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706810476; c=relaxed/simple;
	bh=W9J0NoGcrnYERrTcK+GUgbqfp52tsMxvbK+w7SaPV60=;
	h=Date:Subject:In-Reply-To:CC:From:To:Message-ID:Mime-Version:
	 Content-Type; b=Fh+RpYgST28QdP7Qtss+YOcfnQDLEm8H4ijUy0HshEzrKxWuhDd7qw26BQkFgQ0cT+vYzsRXcs8E2qRHX1FX22JgtPpogn5s5OBWTAMpG86pWzu47sK9CEQfgTWgfZ2VkygwA4eq5FHo4XSICdU8sLD5hQqkAk2O0RTuCgxbIb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com; spf=pass smtp.mailfrom=dabbelt.com; dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b=2FY75X4n; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dabbelt.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1d7393de183so9213055ad.3
        for <kvm@vger.kernel.org>; Thu, 01 Feb 2024 10:01:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20230601.gappssmtp.com; s=20230601; t=1706810474; x=1707415274; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a6iCiiJEkCihp55oAEAEl5G/BiNyoF0zUrNoSz0w21Q=;
        b=2FY75X4nrzFMK1XzjhuAQe3D1ffF6yy69PRaYmV5nO7E0yEbnNl+1iGCSm7qpggOls
         Anr3GAz9HR7tU6olcQheBuq64Rybuc11COTPWH7xJFqDUm4TAgNc46lox9vLqWQtW8mS
         YFvjCjx4Qh2l3cwgZXi27fAVj9qpjfE4B+v+/cbC8f2vRBL0hoKXuLJzycVcfbedO28f
         MdoQ+ANVRNiI5yq4VOZ2w7Ko/P+3vn70RBP7dH1NRJQT/+IPRqvtEz+rF0TlujPque9Z
         Uh/bLQAU7syL0rn/gn23QCA7M5qBh8Rki0BeOBnioziXCLexfv/s177tbXZS4zKTh3Ot
         bDcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706810474; x=1707415274;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a6iCiiJEkCihp55oAEAEl5G/BiNyoF0zUrNoSz0w21Q=;
        b=a9d8UfftIe5x0gJTor2tEOqzeLWhbX7VjapudM2r0pnsZhdGu1in0W3JuB5INsVDi4
         z8zBlPPEfIGDEIPNWlIEzjWs3NAPArXy8w74BAu9MZAedt4UTUh4N0UQZhi3xqDyJEXg
         jIeVlvPPEMelo8yyJcjeDXShWx7hfH4TYG+lEd9SZh3GUrtdWDf300XNztXnh/JUWax/
         fUmbFLv7pwuTpgcsMNL/bofHCAwrYTPoqUJtZoM9CumuM1JEShn3vMP7wX2o0fHM73D3
         OJebHIKOvNReXfy9hRpYvObtplE9gYAi9XAFCNhGFX/LXU+dr2VWxa7gM+PRO/2M0kRa
         OR1Q==
X-Gm-Message-State: AOJu0YwngVFil58e3FclubS4KI2v0p24DwEncwTEUYLv4MrEEhbAKydD
	rT0JnPOmFxqzNSbGO7mB3ULkNE11CJOhtTRnriE0kAFZ8P9zOoCfuajattKsDHg=
X-Google-Smtp-Source: AGHT+IF15aCA64A+pUYtrNvn3aPBFP3YvRRtEpAp7GhLaGBTwkos6AGRBMomIaVUMVTpq99RCQfFMQ==
X-Received: by 2002:a17:90a:bc89:b0:293:d87e:c0fa with SMTP id x9-20020a17090abc8900b00293d87ec0famr3127352pjr.17.1706810473841;
        Thu, 01 Feb 2024 10:01:13 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCVLFmKNxnofRAm9+gmbtAPqzFlddhJuk3PI7Q/NjyXtJ7ZmHp/iTXv0TqfWfZjBaYzFcJopyG/9CDE+R+Jvvm0AZE2oEp2H1XiQOasKu+bdMsINxyBmBY5jTw58tvIpPgG+8pFfE4REHtX6JYC4f0MnquUQN2FJgHlWUglZqdX0AAutrjhomLn4WOttNBDZowK8M6oTDpJIKMK5zEL7B57m8l2DzdVPdCvNWBdNIiiJJpTqImLPcPjW1TVcA+i/QJ+Smow81am9Ta9fUe93MosSLs3u5DtSGA71RgmAo0rrseQVq4kPrBBAL0YwWtv87oLFn0jnKEYoDs/3013pcUBUSS1NOLxp/ILGeAvZ8CtLkHexM/zGg2zr3jqNiiyjXNuFTOwvY7CH857u5/m6eEZC4kBw+4isj41JIR5jioNJPtspftVQDzfP51ZYtxZJvdJd1G/n1LmyzTdmgDM5DCZYxDVbq7r21JeY+DbRZ9cDGnbcC80C+Dq1YyM1TrSNFLrGFjr4cn4CPrY/V9vyNQTBRhdzHLpuJwBz3zxXJlwPr0XZN2BEmMZgokwZxh+BZVCbuy2MQwBBdL4evAMOsvE007/KWpdqC+Ehpyr8KJ5Stk4roUjeT1/2UPsSMDH/dPqhrm/ODu25Q02BsA==
Received: from localhost ([12.44.203.122])
        by smtp.gmail.com with ESMTPSA id w20-20020a17090aea1400b00295f2cb67d1sm3326389pjy.16.2024.02.01.10.01.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Feb 2024 10:01:13 -0800 (PST)
Date: Thu, 01 Feb 2024 10:01:13 -0800 (PST)
X-Google-Original-Date: Thu, 01 Feb 2024 10:01:10 PST (-0800)
Subject:     Re: Call for GSoC/Outreachy internship project ideas
In-Reply-To: <87le84jd85.fsf@draig.linaro.org>
CC: stefanha@gmail.com, Alistair Francis <Alistair.Francis@wdc.com>,
  dbarboza@ventanamicro.com, qemu-devel@nongnu.org, kvm@vger.kernel.org, afaria@redhat.com,
  eperezma@redhat.com, gmaglione@redhat.com, marcandre.lureau@redhat.com, rjones@redhat.com,
  sgarzare@redhat.com, imp@bsdimp.com, philmd@linaro.org, pbonzini@redhat.com, thuth@redhat.com,
  danielhb413@gmail.com, gaosong@loongson.cn, akihiko.odaki@daynix.com, shentey@gmail.com,
  npiggin@gmail.com, seanjc@google.com, Marc Zyngier <maz@kernel.org>
From: Palmer Dabbelt <palmer@dabbelt.com>
To: alex.bennee@linaro.org
Message-ID: <mhng-ec5f9ea7-e704-4302-8542-c8c36ea979d8@palmer-ri-x1c9a>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On Thu, 01 Feb 2024 09:39:22 PST (-0800), alex.bennee@linaro.org wrote:
> Palmer Dabbelt <palmer@dabbelt.com> writes:
>
>> On Tue, 30 Jan 2024 12:28:27 PST (-0800), stefanha@gmail.com wrote:
>>> On Tue, 30 Jan 2024 at 14:40, Palmer Dabbelt <palmer@dabbelt.com> wrote:
>>>>
>>>> On Mon, 15 Jan 2024 08:32:59 PST (-0800), stefanha@gmail.com wrote:
>>>> > Dear QEMU and KVM communities,
>>>> > QEMU will apply for the Google Summer of Code and Outreachy internship
>>>> > programs again this year. Regular contributors can submit project
>>>> > ideas that they'd like to mentor by replying to this email before
>>>> > January 30th.
>>>>
>>>> It's the 30th, sorry if this is late but I just saw it today.  +Alistair
>>>> and Daniel, as I didn't sync up with anyone about this so not sure if
>>>> someone else is looking already (we're not internally).
> <snip>
>>> Hi Palmer,
>>> Performance optimization can be challenging for newcomers. I wouldn't
>>> recommend it for a GSoC project unless you have time to seed the
>>> project idea with specific optimizations to implement based on your
>>> experience and profiling. That way the intern has a solid starting
>>> point where they can have a few successes before venturing out to do
>>> their own performance analysis.
>>
>> Ya, I agree.  That's part of the reason why I wasn't sure if it's a
>> good idea.  At least for this one I think there should be some easy to
>> understand performance issue, as the loops that go very slowly consist
>> of a small number of instructions and go a lot slower.
>>
>> I'm actually more worried about this running into a rabbit hole of
>> adding new TCG operations or even just having no well defined mappings
>> between RVV and AVX, those might make the project really hard.
>
> You shouldn't have a hard guest-target mapping. But are you already
> using the TCGVec types and they are not expanding to AVX when its
> available?

Ya, sorry, I guess that was an odd way to describe it.  IIUC we're doing 
sane stuff, it's just that RISC-V has a very different vector masking 
model than other ISAs.  I just said AVX there because I only care about 
the performance on Intel servers, since that's what I run QEMU on.  I'd 
asssume we have similar performance problems on other targets, I just 
haven't looked.

So my worry would be that the RVV things we're doing slowly just don't 
have fast implementations via AVX and thus we run into some intractable 
problems.  That sort of stuff can be really frusturating for an intern, 
as everything's new to them so it can be hard to know when something's 
an optimization dead end.

That said, we're seeing 100x slowdows in microbenchmarks and 10x 
slowdowns in real code, so I think there sholud be some way to do 
better.

> Remember for anything float we will end up with softfloat anyway so we
> can't use SIMD on the backend.

Yep, but we have a handful of integer slowdowns too so I think there's 
some meat to chew on here.  The softfloat stuff should be equally slow 
for scalar/vector, so we shouldn't be tripping false positives there.

>>> Do you have the time to profile and add specifics to the project idea
>>> by Feb 21st? If that sounds good to you, I'll add it to the project
>>> ideas list and you can add more detailed tasks in the coming weeks.
>>
>> I can at least dig up some of the examples I ran into, there's been a
>> handful filtering in over the last year or so.
>>
>> This one
>> <https://gist.github.com/compnerd/daa7e68f7b4910cb6b27f856e6c2beba>
>> still has a much more than 10x slowdown (73ms -> 13s) with
>> vectorization, for example.
>>
>>> Thanks,
>>> Stefan
>
> -- 
> Alex Bennée
> Virtualisation Tech Lead @ Linaro

