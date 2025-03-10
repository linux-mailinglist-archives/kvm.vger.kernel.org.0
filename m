Return-Path: <kvm+bounces-40703-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73293A5A4EA
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 21:27:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A9AC33A625E
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 20:26:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ECD51DEFD6;
	Mon, 10 Mar 2025 20:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="t/cd23+m"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9651EC5
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 20:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741638416; cv=none; b=hYxtW54QGF694xo5wyiTqvMeQhCZY+IgXnCGL4PB2U+ftFWeI/u/Fnxxgk1Gv6pvF8J0SNKRUE2cGHsZMHPgGJ9t6pe3ukIXo8WxXFLeNvkeKfLutQDUKA9+fg7fF+mEzJ13pPm7QnDBoi8C7YnyoGOjX2xCkpN6s2JliIjkgKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741638416; c=relaxed/simple;
	bh=bT6iemFh8VcxTZM6LIlOJE7+Dos9ZruU5a5EIb0b86U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g6sE6Ei5QLHI1JzGSlI385Jf6VcDZ5/qp563ySLe4sjzfa0mM7JSt2d+8Icc1S9ZcsuOmXKjk7e+CLvmoiLH1NvoA0BmuWjRiIc+MMZpgPlW0bINGTFTkZyMwP509NMC0GqsvzTC933iyhFBuFUki6++sfMd+eX1m81WrkF65CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=t/cd23+m; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-224100e9a5cso87684245ad.2
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 13:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741638413; x=1742243213; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AiIiLS1GP7q3a1RswImI3k6TFErdPpBi0gj3iveuYnY=;
        b=t/cd23+mm2iemMxPCyUguLOiFivilfy84n3+WtcDA+1i2AUAVua9cW3J/cBXQrzE6v
         yPZip/velCDF2PPzH9Y18uYfm9b+cUB+E/Ezt0RWGB0i+6/Ow+D0eIa16x+o/nc6jfbO
         aIEDThF/2QVb8MvfD7iQ6oHUrYn8RmbkXlrgPKdD6zvjBcOswuUP+nHPxcbnWTHBPXS/
         0vKQygzbOfJvFX+tx0D+OYyLeec9en7J4gRO7j/kwb3IAi09W+bm6JTc4SbJ+dyRUdv7
         TeOtjqz+xbmuePjT5nxxLaJwzlX272Tid6yFGX1hlFyY3eRU3i4dAv1KrKlrwCtl6Zlt
         tMuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741638413; x=1742243213;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AiIiLS1GP7q3a1RswImI3k6TFErdPpBi0gj3iveuYnY=;
        b=LQd6DW+4ahvq85e8DMJ04AODTlF1GMYiSBz3IxA/xKSPlrzYguMlOFU64lfdr6vcTW
         2OJDSEJEwcwleVLNL0JHpPonZfh+GAy2kDr2+eEsawBYfmfDTyP4GnBsp3L2phZIAY7l
         rGdFSixM5Tu1MvZ4kBJbfvv3GWIgNgxPLZQ41d3G71Wsgyh4hwM7h7TafMdTLSMngQZR
         Vncjn3wVpbVzXnMsk5SHSnOuhpOyECYQgRYOTl4UtlP0kn68HCM6xC7iMbjeZDmMeZMv
         xpMOnD4Sn5IXdCqjigA64wGi5ftHgQGU6s80IfpOj6/AHhlHZpPxXlJK5GFNKAfcP1f9
         MOSA==
X-Forwarded-Encrypted: i=1; AJvYcCWFs22ynvResuJUTmqqEyDWXYEW++SUhPDyKANkUmGnoVc5RK/Toq1SgJc7TLLJKrWjNNE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+bhE4d1ZaM/5cK2kSRKqLipwsmtdJbdeYvTx99iQD1UwgtGF2
	uYiGoo5S2fWLuExRyVS2LztXfkf9SwwUdXFbZuQySL+8D17oJeHpMpeRQ574XOc=
X-Gm-Gg: ASbGncvrL0o9Ai7/PYf6+YkDMY75qcv/VjDT4aZtSB0tnHBdryey+5FBTCAj3qvIHHm
	A4jCcbvbfI1QN4ewuvU1I4hxU58naWRziQIFDinJKf6WClv9BG1hb4TJfXStfsu0Q3gk/SksNOg
	FoOs2dPk2tBLKp7Yzc6dZRh/jzUA1ZrrowoQRlddXocRYp3myaVzkAjPsLMPXK5aY0H7AYw9fGD
	naI1W5YGkd78FvenLxlDqP7N8TGYVETIF7u+wNCxH7eZmO/T8aUiVvbIeNAnuieiF/A8YkPwkK1
	2x2qouQZgM2eNcJNpV00+RaJFNkRWvM6k6ZrucxjEIWpjMN0En/tepTWF+H1ID9PvetN
X-Google-Smtp-Source: AGHT+IGqrKJLGR1X/ovR/W78lQ/Ua1Y2uHeHfWuLidHf+nTUnqStlIa4GrnBGcWZ3g9vtZOGkIWxrQ==
X-Received: by 2002:a17:90b:2883:b0:2ee:44ec:e524 with SMTP id 98e67ed59e1d1-2ff7cf3e402mr23135122a91.35.1741638412801;
        Mon, 10 Mar 2025 13:26:52 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-224109e8397sm82675275ad.58.2025.03.10.13.26.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Mar 2025 13:26:52 -0700 (PDT)
Message-ID: <86acf98f-99d6-4a93-b62f-c83571b0ae09@linaro.org>
Date: Mon, 10 Mar 2025 13:26:51 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/16] make system memory API available for common code
Content-Language: en-US
To: BALATON Zoltan <balaton@eik.bme.hu>
Cc: qemu-devel@nongnu.org, qemu-ppc@nongnu.org,
 Alistair Francis <alistair.francis@wdc.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, alex.bennee@linaro.org,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>, kvm@vger.kernel.org,
 Peter Xu <peterx@redhat.com>, Nicholas Piggin <npiggin@gmail.com>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 David Hildenbrand <david@redhat.com>, Weiwei Li <liwei1518@gmail.com>,
 Paul Durrant <paul@xen.org>, "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Anthony PERARD <anthony@xenproject.org>,
 Yoshinori Sato <ysato@users.sourceforge.jp>, manos.pitsidianakis@linaro.org,
 qemu-riscv@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
 xen-devel@lists.xenproject.org, Stefano Stabellini <sstabellini@kernel.org>
References: <20250310045842.2650784-1-pierrick.bouvier@linaro.org>
 <f231b3be-b308-56cf-53ff-1a6a7fb4da5c@eik.bme.hu>
 <c5b9eea9-c412-461d-b79b-0fa2f72128ee@linaro.org>
 <a57faa36-2e66-4438-accc-0cbfdeebf100@linaro.org>
 <6b3e48e2-0730-09e2-55b1-35daff4ecf75@eik.bme.hu>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <6b3e48e2-0730-09e2-55b1-35daff4ecf75@eik.bme.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/10/25 12:40, BALATON Zoltan wrote:
> On Mon, 10 Mar 2025, Pierrick Bouvier wrote:
>> On 3/10/25 09:28, Pierrick Bouvier wrote:
>>> Hi Zoltan,
>>>
>>> On 3/10/25 06:23, BALATON Zoltan wrote:
>>>> On Sun, 9 Mar 2025, Pierrick Bouvier wrote:
>>>>> The main goal of this series is to be able to call any memory ld/st
>>>>> function
>>>>> from code that is *not* target dependent.
>>>>
>>>> Why is that needed?
>>>>
>>>
>>> this series belongs to the "single binary" topic, where we are trying to
>>> build a single QEMU binary with all architectures embedded.
> 
> Yes I get it now, I just forgot as this wasn't mentioned so the goal
> wasn't obvious.
>

The more I work on this topic, the more I realize we miss a clear and 
concise document (wiki page, or anything than can be edited easily - not 
email) explaining this to other developers, and that we could share as a 
link, and enhance based on the questions asked.

>>> To achieve that, we need to have every single compilation unit compiled
>>> only once, to be able to link a binary without any symbol conflict.
>>>
>>> A consequence of that is target specific code (in terms of code relying
>>> of target specific macros) needs to be converted to common code,
>>> checking at runtime properties of the target we run. We are tackling
>>> various places in QEMU codebase at the same time, which can be confusing
>>> for the community members.
> 
> Mentioning this single binary in related series may help reminding readers
> about the context.
> 

I'll make sure to mention this "name" in the title for next series, thanks!

>>> This series take care of system memory related functions and associated
>>> compilation units in system/.
>>>
>>>>> As a positive side effect, we can
>>>>> turn related system compilation units into common code.
>>>>
>>>> Are there any negative side effects? In particular have you done any
>>>> performance benchmarking to see if this causes a measurable slow down?
>>>> Such as with the STREAM benchmark:
>>>> https://stackoverflow.com/questions/56086993/what-does-stream-memory-bandwidth-benchmark-really-measure
>>>>
>>>> Maybe it would be good to have some performance tests similiar to
>>>> functional tests that could be run like the CI tests to detect such
>>>> performance changes. People report that QEMU is getting slower and slower
>>>> with each release. Maybe it could be a GSoC project to make such tests but
>>>> maybe we're too late for that.
>>>>
>>>
>>> I agree with you, and it's something we have mentioned during our
>>> "internal" conversations. Testing performance with existing functional
>>> tests would already be a first good step. However, given the poor
>>> reliability we have on our CI runners, I think it's a bit doomed.
>>>
>>> Ideally, every QEMU release cycle should have a performance measurement
>>> window to detect potential sources of regressions.
> 
> Maybe instead of aiming for full CI like performance testing something
> simpler like a few tests that excercise some apects each like STREAM that
> tests memory access, copying a file from network and/or disk that tests
> I/O and mp3 encode with lame for example that's supposed to test floating
> point and SIMD might be simpler to do. It could be made a bootable image
> that just runs the test and reports a number (I did that before for
> qemu-system-ppc when we wanted to test an issue that on some hosts it ran
> slower). Such test could be run by somebody making changes so they could
> call these before and after their patch to quickly check if there's
> anything to improve. This may be less through then full performance
> testing but still give some insight and better than not testing anything
> for performance.
> 
> I'm bringig this topic up to try to keep awareness on this so QEMU can
> remain true to its name. (Although I'm not sure if originally the Q in the
> name stood for the time it took to write or its performance but it's
> hopefully still a goal to keep it fast.)
> 

You do well to remind that, but as always, the problem is that "run by 
somebody" is not an enforceable process.

>>> To answer to your specific question, I am trying first to get a review
>>> on the approach taken. We can always optimize in next series version, in
>>> case we identify it's a big deal to introduce a branch for every memory
>>> related function call.
> 
> I'm not sure we can always optimise after the fact so sometimes it can be
> necessary to take performance in consideration while designing changes.
> 

In the context of single binary concerned series, we mostly introduce a 
few branches in various spots, to do a runtime check.
As Richard mentioned in this series, we can keep target code exactly as 
it is.

>>> In all cases, transforming code relying on compile time
>>> optimization/dead code elimination through defines to runtime checks
>>> will *always* have an impact,
> 
> Yes, that's why it would be good to know how much impact is that.
> 
>>> even though it should be minimal in most of cases.
> 
> Hopefully but how do we know if we don't even test for it?
> 

In the case of this series, I usually so a local test booting 
(automatically) an x64 debian stable vm, that poweroff itself as part of 
its init.

With and without this series, the variation is below the average one I 
have between two runs (<1 sec, for a total of 40 seconds), so the impact 
is litterally invisible.

>>> But the maintenance and compilation time benefits, as well as
>>> the perspectives it opens (single binary, heterogeneous emulation, use
>>> QEMU as a library) are worth it IMHO.
> 
> I'm not so sure about that. Heterogeneous emulation sounds interesting but
> is it needed most of the time? Using QEMU as a library also may not be
> common and limited by licencing. The single binary would simplify packages
> but then this binary may get huge so it's slower to load, may take more
> resources to run and more time to compile and if somebody only needs one
> architecture why do I want to include all of the others and wait for it to
> compile using up a lot of space on my disk? So in other words, while these
> are interesting and good goals could it be achieved with keeping the
> current way of building single ARCH binary as opposed to single binary
> with multiple archs and not throwing out the optimisations a single arch
> binary can use? Which one is better may depend on the use case so if
> possible it would be better to allow both keeping what we have and adding
> multi arch binary on top not replacing the current way completely.
> 

Thanks, it's definitely interesting to hear the concerns on this, so we 
can address them, and find the best and minimal solution to achive the 
desired goal.

I'll answer point by point.

QEMU as a library: that's what Unicorn is 
(https://www.unicorn-engine.org/docs/beyond_qemu.html), which is used by 
a lot of researchers. Talking frequently with some of them, they would 
be happy to have such a library directly with upstream QEMU, so it can 
benefit from all the enhancements done to TCG. It's mostly a use case 
for security researchers/engineers, but definitely a valid one. Just 
look at the list of QEMU downstream forks focused on that. Combining 
this with plugins would be amazing, and only grow our list of users.

For the heterogeneous scenario, yes it's not the most common case. But 
we *must*, in terms of QEMU binary, be able to have a single binary 
first. By that, I mean the need is to be able to link a binary with 
several arch present, without any symbol conflict.

The other approach possible is to rename many functions through QEMU 
codebase by adding a target_prefix everywhere, which would be ugly and 
endless. That's why we are currently using the "remove duplicated 
compilation units" pragmatic approach. As well, we can do a lot of 
headers cleanup on the way (removing useless dependencies), which is 
good for everyone.

For compilation times, it will only speed it up, because in case you 
have only specific targets, non-needed files won't be compiled/linked. 
For multi target setup, it's only a speed up (with all targets, it would 
be a drop from 9000+ CUs to around 4000+). Less disk space as well, most 
notable in debug.
As well, having files compiled only once allow to use reliably code 
indexation tools (clangd for instance), instead of picking a random CU 
setting based on one target.
Finally, having a single binary would mean it's easy to use LTO (or at 
least distros would use it easily), and get the same or better 
performance as what we have today.

The "current" way, with several binaries, can be kept forever if people 
wants. But it's not feasible to keep headers and cu compatible for both 
modes. It would be a lot of code duplication, and that is really not 
desirable IMHO. So we need to do those system wide changes and convince 
the community it's a good progress for everyone.

Kudos to Philippe who has been doing this long and tedious work for 
several years now, and I hope that with some fresh eyes/blood, it can be 
completed soon.

>>>> Regards,
>>>> BALATON Zoltan
>>>
>>> Regards,
>>> Pierrick
>>>
>>
>> As a side note, we recently did some work around performance analysis (for
>> aarch64), as you can see here [1]. In the end, QEMU performance depends
> 
> Thank you, very interesting read.
> 
>> (roughly in this order) on:
>> 1. quality of code generated by TCG
>> 2. helper code to implement instructions
>> 3. mmu emulation
>>
>> Other state of the art translators that exist are faster (fex, box64) mainly
>> by enhancing 1, and relying on various tricks to avoid translating some
>> libraries calls. But those translators are host/target specific, and the
>> ratio of instructions generated (vs target ones read) is much lower than
>> QEMU. In the experimentation listed in the blog, I observed that for
>> qemu-system-aarch64, we have an average expansion factor of around 18 (1
>> guest insn translates to 18 host ones).
>>
>> For users seeing performance decreases, beyond the QEMU code changes, adding
>> new target instructions may add new helpers, which may be called by the stack
>> people use, and they can sometimes observe a slower behaviour.
> 
> I'm mostly interested in emulating PPC for older and obscure OSes running
> on older hardware so there new instructions isn't a problem. Most of the
> time MMU emulation, helpers and TCG code generation is mostly dominating
> there and on PPC particularly the lack of hard float usage. Apart from
> that maybe some device emulations but that's a different topic. This is
> already slow so any overhead introduced at lowest levels just adds to
> that and target specific optimisation may only get back what's lost
> elsewhere.
> 

One think we really lack for now is how to measure generated code 
quality. I mean, to know how far we are from the optimal translation.
For mmu and helper code, it's easy, as this appear in any profiling.
But for the rest, it's kind of a blackbox.

Once again, having QEMU has a library (TCG more precisely) would be 
something very beneficial to work on that.

> Regards,
> BALATON Zoltan
> 
>> There are probably some other low hanging fruits for other target
>> architectures.
>>
>> [1] https://www.linaro.org/blog/qemu-a-tale-of-performance-analysis/
>>
>>


