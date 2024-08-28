Return-Path: <kvm+bounces-25236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DAFA09623DC
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 11:47:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 587AD1F24F38
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 09:47:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DCF6169382;
	Wed, 28 Aug 2024 09:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="or4cHeG4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681F1167296
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 09:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724838428; cv=none; b=VzXKflU3dDBJKAJ2YAc6016Wrwr8DufrL2YCz4LGKbwpe1xkoBUdI+96aZasmzVFMTdM/muCnxV9rKUmu5RfIjCyJRqVQECt0sR8XjtRd1WSdcySSsjTIhTE8tTZBGmqhB2YQvxW6maGGHn1JCbnHNGNqE82XPCU7NG2rB2WHa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724838428; c=relaxed/simple;
	bh=JaahmtBNvMYpYGDI8TfWiHxXUqqgkc9FlY7+LPCUrzE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=p1BvBQ5ngs2TL1n8BGASZvLkag0JV4CCcspEf4Ok/yse08RuPp5EqSPcRKo+gJugDiEonv6sESwwtPzDCNyMr6o2fH4BaQ94BJLoWmajIRg4dSHgdUzOS8FdL/429imespg1upN+M9PH1BP5g/oks/zUV+qNRziVlcvOB91UQw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=or4cHeG4; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-42819654737so55478745e9.1
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 02:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724838425; x=1725443225; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f4FnjsYFSElhR+3f7IugFyQV34/agqN5SguHwrwKdRE=;
        b=or4cHeG4LREv2WCATRM1JdsEkUyYTm03bcdXlgfrhCGX7AhQY/hHX8ao5qn7FcSorp
         8x6uYfJmWkMAJNUKHOzdPS0aCXEsYbXGf+vfPVjiQ7LHqIQC3Pigmin84W3YKpBbDHbz
         bxB9d6eRmh69mx+NPI5KF20gGCthAlElKQDhid26YhB03C71tGGeAF2t3sZs3CtkzE1Y
         WnqJouMgGhxNRABuLDkza4yfVVa8D/ERhDSmfhrx9Wnh7S3RVj9G7YoZ7czx8jmyc9AQ
         Deyz1Jk/woPBYJhVHr4cBQRJUCKbupX2j/7hov/FMbYU2Zbpf80uou5q6/7NsyBgIVEj
         4mxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724838425; x=1725443225;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f4FnjsYFSElhR+3f7IugFyQV34/agqN5SguHwrwKdRE=;
        b=d8st6Cd3nEzM0Cb3rY5gKMIH43pUnTVMPapvCx3QphEU2ad79sh7N/f+pgLZhqiTC8
         MpFxnjdDN5xlNgMz7w2v98eNDa4inA1uasVxBjlTLGuHLqX108LnsWgGXR3YgJ87tv5M
         +456yRGdUByWdSsONIa0zyeuydTgkMDRvXsHP3mIaVG3plepFdUi+zjWgJDvHWuIQIX4
         Zn6NCCwBrVDQvpt6p6nn7WOfXR1yFW61zpm2+IVSMI+52xVnkNL6v6Nl1Ngl62trt6ce
         UegBZOP26m7KhshDh+4zpBX8IX1BAr9KVtmKwbWH47nvfAdFs48zVTISYiIwCP0/OiON
         UwTg==
X-Forwarded-Encrypted: i=1; AJvYcCVzvHBGvmxB0r3m9UKJlADuCtmtAIF1ebGb14PMqpRzFEcPfRjZk26jyc2ICIlvEAD+6gU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzySfJwFF8lD4V3UDaiGpy2LFFjggJl5FpwLiHl0WpryGeVo657
	Imh2hUEQxMMcd2NH+zPqFg00JLZrSNltz2+IeJFtSVOZSQ2b9+8wNXB5fmMj/wc=
X-Google-Smtp-Source: AGHT+IH0KC6Z0HHx3zEIhScnAd0zosTOFRut+SoaKBSOi0hUzOh0yIoDnTQbgYeiAVq0L8twAXC6cQ==
X-Received: by 2002:adf:f7d2:0:b0:368:77f9:fb34 with SMTP id ffacd0b85a97d-37311857bf9mr9665467f8f.15.1724838424122;
        Wed, 28 Aug 2024 02:47:04 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3730813c0dcsm15170235f8f.37.2024.08.28.02.47.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2024 02:47:03 -0700 (PDT)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 999935F796;
	Wed, 28 Aug 2024 10:47:02 +0100 (BST)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: D Scott Phillips <scott@os.amperecomputing.com>
Cc: linux-kernel@vger.kernel.org,  kvm@vger.kernel.org,
  linux-arm-kernel@lists.infradead.org,  kvmarm@lists.linux.dev,
  maz@kernel.org,  arnd@linaro.org
Subject: Re: [PATCH 1/3] ampere/arm64: Add a fixup handler for alignment
 faults in aarch64 code
In-Reply-To: <86frqpk6d7.fsf@scott-ph-mail.amperecomputing.com> (D. Scott
	Phillips's message of "Tue, 27 Aug 2024 14:23:16 -0700")
References: <20240827130829.43632-1-alex.bennee@linaro.org>
	<20240827130829.43632-2-alex.bennee@linaro.org>
	<86frqpk6d7.fsf@scott-ph-mail.amperecomputing.com>
Date: Wed, 28 Aug 2024 10:47:02 +0100
Message-ID: <87plpt3rop.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

D Scott Phillips <scott@os.amperecomputing.com> writes:

> Alex Benn=C3=A9e <alex.bennee@linaro.org> writes:
>
>> From: D Scott Phillips <scott@os.amperecomputing.com>
>>
>> A later patch will hand out Device memory in some cases to code
>> which expects a Normal memory type, as an errata workaround.
>> Unaligned accesses to Device memory will fault though, so here we
>> add a fixup handler to emulate faulting accesses, at a performance
>> penalty.
>>
>> Many of the instructions in the Loads and Stores group are supported,
>> but these groups are not handled here:
>>
>>  * Advanced SIMD load/store multiple structures
>>  * Advanced SIMD load/store multiple structures (post-indexed)
>>  * Advanced SIMD load/store single structure
>>  * Advanced SIMD load/store single structure (post-indexed)
>
> Hi Alex, I'm keeping my version of these patches here:
>
> https://github.com/AmpereComputing/linux-ampere-altra-erratum-pcie-65
>
> It looks like the difference to the version you've harvested is that
> I've since added handling for these load/store types:
>
> Advanced SIMD load/store multiple structure
> Advanced SIMD load/store multiple structure (post-indexed)
> Advanced SIMD load/store single structure
> Advanced SIMD load/store single structure (post-indexed)

Are you going to roll in the fixes I added or should I re-spin with your
additional handling?

> I've never sent these patches because in my opinion there's too much
> complexity to maintain upstream for this workaround, though now they're
> here so we can have that conversation.

It's not totally out of the scope of the kernel to do instruction
decoding to workaround things that can't be executed directly. There is
already a bunch of instruction decode logic to handle stepping over
instruction probes. The 32 bit ARM code even has a complete user-space
alignment fixup handler driver by procfs.

It might make sense to share some of the logic although of course the
probe handler and the misaligned handler are targeting different sets of
instructions.

The core kernel code also has a bunch of unaligned load/store helper
functions that could probably be re-used as well to further reduce the
code delta.

> Finally, I think a better approach overall would have been to have
> device memory mapping in the stage 2 page table, then booting with pkvm
> would have this workaround for both the host and guests. I don't think
> that approach changes the fact that there's too much complexity here.

That would be a cleaner solution for pKVM although we would like to see
it ported to Xen as well. There is a tension there between having a
generic fixup library and something tightly integrated into a given
kernel/hypervisor.

I don't think instruction decoding is fundamentally too complicated for
a kernel - although I may be biased as a QEMU developer ;-). However if
it is to be taken forward I think it should probably come with an
exhaustive test case to exercise the decoder and fixup handler. The
fixes so far were found by repeatedly iterating on vkmark and seeing
were things failed and fixing when they came up.

I will leave it to the kernel maintainers to decide if this is an
acceptable workaround or not.

I do have two remaining questions:

  - Why do AMD GPUs trigger this and not nVidia? Do they just have their
    own fixup code hidden in the binary blob? Would Nouveau suffer
    similar problems?

  - Will Arm SoC PCI implementations continue to see these edge cases
    that don't affect the x86 world? This is not the first Arm machine
    with PCI to see issues. In fact of the 3 machines I have (SynQuacer,
    MachiatoBin and AVA) all have some measure of PCI "fun" to deal
    with.

Thanks,

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

