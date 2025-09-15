Return-Path: <kvm+bounces-57629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5431AB586C1
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 23:28:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B71A41B24C89
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 21:28:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F5752C08B2;
	Mon, 15 Sep 2025 21:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="AgckZhTH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA7A2DC78E
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 21:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757971682; cv=none; b=pFPfUMNVWgceOKfIX9nWi3XfLzXDXBvRIPQFbHwMiyfpexo7vrbhjCvMj0FFUluC++eFwoSWcNva1jOL30my5dRrX2rZ2Keqz4jzBzf+Z6yDEhnTC5COWoVosYgYXAtE8ZABi30eCpFFIWYPOpF3SW7Q04I6TfxS91wcACajZZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757971682; c=relaxed/simple;
	bh=mQQi0fS0R+8Vt2hbFe7zaxA2tzgvMhMA24l6r7fpyJQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uxH5XPxuwXFOqxp8eICCXO4egq0vN97c6Siluio1c+HWJtL4WHcML3dJbhZxSLOtMy029b828IEyQc8r7OaOuY6ivAoXG2/DooN9VuiDOzgyGogu0nudgjlr1w2ROaIyBbtAEFDP3t+SFxbTuD2MRzLjUJtM2en98pa7/DOuvqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=AgckZhTH; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8127215a4c6so545156885a.0
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 14:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1757971679; x=1758576479; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=g27UvLX7c9aw4EkAViSdQBn8kI2gbwfS7+nl0qMM/Wk=;
        b=AgckZhTHm4eJjnQnF8+B3qbk2c+AHMD2d8S4GuoWwzZasnl9jZS6LDwXkBd8XQecdb
         o51805fwcvFxkSUmIWJIoU5sSF1oisGXAUn/OzgwSb3LICOexue7U7JqjC2HloCXVWY2
         +5KrTMnNmjgPw/wwZecQFZDMmKAsZQiYr8ghanMAvI8ymB99vvcnaDbO7OgUwRjB/hi2
         wfAt4luf7FDvPr8PCIwADPK4SKW1RzbbU3cnEWJHYYyAmCbITy/pQlxYfJ+57a5UdCAN
         yGvtKdiqqf8T0Ll8j5J8foQId9krL6gD0gwmCK4gqpEKJEeFZH676JhkLsX99i4QcvTO
         YEsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757971679; x=1758576479;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g27UvLX7c9aw4EkAViSdQBn8kI2gbwfS7+nl0qMM/Wk=;
        b=GdIopcIjUb+u5b8f5vAm58yNeQbzzSdw4C+VlIgBUkhZkE4U9up6lTf1KewhE0X/z4
         KDgsEBAfohQ/Ib2B0YtQaSBuNr1P7vLls+YEnjTvYmUZCy8eNgZfSFfDdHRt7hZshd1x
         QndJ1w9DK/G9YCSlbVHkEFtIYUUbFEj2y+iFzQMTndNxdyZ8pg4DYR3pOjrYPk5Mfkag
         DW+4XLPGc/SqqbzKdDU5M20JyJpbMqUnqrrMaQ/0NP6PmeDeTWjulT6lMFtyOgaFiuH+
         sYF7xpQHbB9eMxkMPxtWQItE+pQjRGn4dESLets+EijysF3PKhQPGTS8BxrMrBYnOYBb
         amIA==
X-Forwarded-Encrypted: i=1; AJvYcCXDPuv4Hy/6IUiCLk9+2RoOrsobPOZPWm1pMQ+HK0HYeB34B1EHUZlFDzZvxIIgFrmjbbo=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywpd8E7e6MxSvWwLBZmERi3y/FJ0MJvRWf2yXlI+F1ld3kcW3M6
	bbpd0wjqWA7SI7Ha8Xa2Nv7b7DW238SufAL1SR7rsTs6jXIFG4Cg9r68FfxbqX0TlYjLGduueOI
	rM/ZL
X-Gm-Gg: ASbGncs1koACrfL6OPc1qpiVOU3HWpAdJBXwrBVPnwZhq2BC8yVK/TGV0n2ir6u3fgA
	QF10JUSdjmiv68LR8Yk5xbwiETlDhtXtBRs/116xoeSVPFzA2LA+OyojnFh/6OVO240kRjEnRER
	GVDSbh7zECnKhNeEVrMw3iDFRNGAJkZf+fIYcNEHdLQYKILQf+T1+dV+wP7Rs7n3CbSll7sAvvD
	mItnaqgMpcK/qlHCte/Y1bCSmQ9J36j/ieZAiHpR7bS2g/8CipYAK97rANNLWbe+Xx7obCui/mu
	QvsZr2VRtrqZBqiFHvhC0VklypSDIC2CPd5l+qBvWNwlJC0VzOIK+ISK57jWPxzh/DvgaPpsrcX
	2+QYtHg8fdw4QYunkeI17qgljxvIFmMa3DeA9aMAUt440cDSi0NCLZLFnkAE8H15+0DuIGZZ6Ai
	8ZzlkjtwW+G4N52R4FaRh7ZMY60g8RjmTiUoVF8IVbGrgQtb0+AqjX8n7s/AsLzjChIhVN
X-Google-Smtp-Source: AGHT+IHsVF/oMAjFgcI11wCwhMY7SS79YEfgjGXyOoC4YQh3NTo7eFqhXCeCo23EiBgprd6+6b0+vQ==
X-Received: by 2002:a05:622a:2997:b0:4b7:9b27:6599 with SMTP id d75a77b69052e-4b79b276977mr91089121cf.27.1757971679312;
        Mon, 15 Sep 2025 14:27:59 -0700 (PDT)
Received: from ?IPV6:2003:fa:af00:da00:8e63:e663:d61a:1504? (p200300faaf00da008e63e663d61a1504.dip0.t-ipconnect.de. [2003:fa:af00:da00:8e63:e663:d61a:1504])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b639dad799sm75539131cf.28.2025.09.15.14.27.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 14:27:58 -0700 (PDT)
Message-ID: <bad630f8-3223-4f58-a128-30761207f3d1@grsecurity.net>
Date: Mon, 15 Sep 2025 23:27:56 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH] Better backtraces for leaf functions
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Thomas Huth <thuth@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvm@vger.kernel.org
References: <20250724181759.1974692-1-minipli@grsecurity.net>
 <20250908-c34647c9836098b0484b7430@orel>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <20250908-c34647c9836098b0484b7430@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Am 08.09.25 um 20:35 schrieb Andrew Jones:
> On Thu, Jul 24, 2025 at 08:17:59PM +0200, Mathias Krause wrote:
>> Leaf functions are problematic for backtraces as they lack the frame
>> pointer setup epilogue. If such a function causes a fault, the original
>> caller won't be part of the backtrace. That's problematic if, for
>> example, memcpy() is failing because it got passed a bad pointer. The
>> generated backtrace will look like this, providing no clue what the
>> issue may be:
>> [...]

>> +ifneq ($(KEEP_FRAME_POINTER),)
>> +# Fake profiling to force the compiler to emit a frame pointer setup also in
>> +# leaf function (-mno-omit-leaf-frame-pointer doesn't work, unfortunately).
>> +#
>> +# Note:
>> +# We need to defer the cc-option test until -fno-pic or -no-pie have been
>> +# added to CFLAGS as -mnop-mcount needs it. The lazy evaluation of CFLAGS
>> +# during compilation makes this do "The Right Thing."
>> +fomit_frame_pointer += $(call cc-option, -pg -mnop-mcount, "")
>> +endif
>> +

> 
> My riscv cross compiler doesn't seem to need this, i.e. we already get
> memcpy() in the trace with just -fno-omit-frame-pointer.

Yeah, noticing the same here. Apparently, RISCV has a debug-friendly
default stack frame epilogue.

> 
> Also, while arm doesn't currently have memcpy() in the trace, adding
> -mno-omit-leaf-frame-pointer works for the cross compiler I'm using
> for it.

Hmm, actually, ARM is failing hard on me, causing recursive faults,
because of the truncated stack frame setup in leaf functions that lacks
saving the return address on the stack, making the code follow "wild"
pointers:

| Unhandled exception 4 (dabt)
| Exception frame registers:
| pc : [<40012614>]    lr : [<40010414>]    psr: 200001d3
| sp : 4013fd94  ip : f4523f20  fp : 4013fd94
| r10: 00000000  r9 : 00000000  r8 : 00000000
| r7 : 00000000  r6 : 00000000  r5 : 40140000  r4 : 00000000
| r3 : deadbeee  r2 : 00000029  r1 : deadbf18  r0 : f4523f21
| Flags: nzCv  IRQs off  FIQs off  Mode SVC_32
| Control: 00c50078  Table: 00000000  DAC: 00000000
| DFAR: deadbeef    DFSR: 00000008
| Unhandled exception 4 (dabt)
| Exception frame registers:
| pc : [<4001318c>]    lr : [<40117400>]    psr: 200001d3
| sp : 4013fcd8  ip : ea000670  fp : 4013fcdc
| r10: 00000000  r9 : 00000000  r8 : 00000000
| r7 : 00000000  r6 : 4013fd94  r5 : 00000004  r4 : 4013fd48
| r3 : e1a04000  r2 : 00000013  r1 : 4013fce8  r0 : 00000002
| Flags: nzCv  IRQs off  FIQs off  Mode SVC_32
| Control: 00c50078  Table: 00000000  DAC: 00000000
| DFAR: ea000670    DFSR: 00000008
| RECURSIVE STACK WALK!!!
|   STACK: @4001318c
| 0x4001318c: arch_backtrace_frame at lib/arm/stack.c:44
|                   break;
|       >       return_addrs[depth] = (void *)fp[0];
|               if (return_addrs[depth] == 0)

Note the "RECURSIVE STACK WALK!!!" above.

I'm using "arm-linux-gnueabi-gcc (Debian 14.2.0-19) 14.2.0" here.

Also, -mno-omit-leaf-frame-pointer isn't supported for ARM but only
AArch64. However, there it fixes the backtraces, indeed.

> 
> And, neither the riscv nor the arm cross compilers I'm using have
> -mnop-mcount.
> 
> So, I think something like this should be put in arch-specific makefiles.

I added it on purpose to the top-level Makefile, willingly knowing that
-mnop-mcount is an x86-specific option. However, arch Makefiles get
included early, so the -fno-pic / -no-pie flags won't be in CFLAGS by
the time of the test, nor would be the $(cc-option ...) helper be
available. But yes, it's kinda ugly and, apparently, other architectures
need fixing too, so I bit the bullet and did a different hack^W^W proper
fix for em all (will post it in a few).

Thanks,
Mathias

