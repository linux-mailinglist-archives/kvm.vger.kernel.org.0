Return-Path: <kvm+bounces-40704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B800A5A57B
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 22:02:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BBE08174AEE
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 21:02:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06A9D1DF72D;
	Mon, 10 Mar 2025 21:02:49 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from zero.eik.bme.hu (zero.eik.bme.hu [152.66.115.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BC91D7999
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 21:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=152.66.115.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741640568; cv=none; b=YvE+B+GoHdxCMlIecTX2iNxHEuXP6EgB1VFWV4nm+aBEyIwGeorD3sHYNOpwTCR4QdKRQMH1qc1sWnR7EjXQET0In4StPriYvgGh/ypVYzcC3nqxqdoQC9uKyma33MAs9wGfJMErQYp2XcMTzN3FEIwrfCShc9ZnvO2+yr6MP0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741640568; c=relaxed/simple;
	bh=hbOJd/3fOqwbZWw+Jk/NJnjjZryrh1QTP5fg0uKy7JQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=oIXU+hmGsbTdtum1TPW0qOia1UPtmVx+QP1s5e5Eg5G6aIeD4DE+ZQKy/cGMbQJJnDHGaEbMMA5Yai/iGFPIYaGc85YF6g1Y8FCVd2TCEd/D8iEfXu7xs4hHyrMAHcBbuGh9PETyGcmvNIJHd2FqlUx1DERUaOi/jsOYHATDb/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eik.bme.hu; spf=pass smtp.mailfrom=eik.bme.hu; arc=none smtp.client-ip=152.66.115.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eik.bme.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eik.bme.hu
Received: from zero.eik.bme.hu (localhost [127.0.0.1])
	by zero.eik.bme.hu (Postfix) with ESMTP id AF51A4E602E;
	Mon, 10 Mar 2025 22:02:42 +0100 (CET)
X-Virus-Scanned: amavisd-new at eik.bme.hu
Received: from zero.eik.bme.hu ([127.0.0.1])
 by zero.eik.bme.hu (zero.eik.bme.hu [127.0.0.1]) (amavisd-new, port 10028)
 with ESMTP id IphZi4_PVs8l; Mon, 10 Mar 2025 22:02:40 +0100 (CET)
Received: by zero.eik.bme.hu (Postfix, from userid 432)
	id 6B4A84E601A; Mon, 10 Mar 2025 22:02:40 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by zero.eik.bme.hu (Postfix) with ESMTP id 6816074577D;
	Mon, 10 Mar 2025 22:02:40 +0100 (CET)
Date: Mon, 10 Mar 2025 22:02:40 +0100 (CET)
From: BALATON Zoltan <balaton@eik.bme.hu>
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>
cc: qemu-devel@nongnu.org, qemu-ppc@nongnu.org, 
    Alistair Francis <alistair.francis@wdc.com>, 
    Richard Henderson <richard.henderson@linaro.org>, 
    Harsh Prateek Bora <harshpb@linux.ibm.com>, alex.bennee@linaro.org, 
    Palmer Dabbelt <palmer@dabbelt.com>, 
    Daniel Henrique Barboza <danielhb413@gmail.com>, kvm@vger.kernel.org, 
    Peter Xu <peterx@redhat.com>, Nicholas Piggin <npiggin@gmail.com>, 
    Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, 
    David Hildenbrand <david@redhat.com>, Weiwei Li <liwei1518@gmail.com>, 
    Paul Durrant <paul@xen.org>, 
    "Edgar E. Iglesias" <edgar.iglesias@gmail.com>, 
    =?ISO-8859-15?Q?Philippe_Mathieu-Daud=E9?= <philmd@linaro.org>, 
    Anthony PERARD <anthony@xenproject.org>, 
    Yoshinori Sato <ysato@users.sourceforge.jp>, 
    manos.pitsidianakis@linaro.org, qemu-riscv@nongnu.org, 
    Paolo Bonzini <pbonzini@redhat.com>, xen-devel@lists.xenproject.org, 
    Stefano Stabellini <sstabellini@kernel.org>
Subject: Re: [PATCH 00/16] make system memory API available for common code
In-Reply-To: <86acf98f-99d6-4a93-b62f-c83571b0ae09@linaro.org>
Message-ID: <5c6a446b-e715-cc38-b212-3291ecc426d2@eik.bme.hu>
References: <20250310045842.2650784-1-pierrick.bouvier@linaro.org> <f231b3be-b308-56cf-53ff-1a6a7fb4da5c@eik.bme.hu> <c5b9eea9-c412-461d-b79b-0fa2f72128ee@linaro.org> <a57faa36-2e66-4438-accc-0cbfdeebf100@linaro.org> <6b3e48e2-0730-09e2-55b1-35daff4ecf75@eik.bme.hu>
 <86acf98f-99d6-4a93-b62f-c83571b0ae09@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Mon, 10 Mar 2025, Pierrick Bouvier wrote:
> On 3/10/25 12:40, BALATON Zoltan wrote:
>> On Mon, 10 Mar 2025, Pierrick Bouvier wrote:
>>> On 3/10/25 09:28, Pierrick Bouvier wrote:
>>>> Hi Zoltan,
>>>> 
>>>> On 3/10/25 06:23, BALATON Zoltan wrote:
>>>>> On Sun, 9 Mar 2025, Pierrick Bouvier wrote:
>>>>>> The main goal of this series is to be able to call any memory ld/st
>>>>>> function
>>>>>> from code that is *not* target dependent.
>>>>> 
>>>>> Why is that needed?
>>>>> 
>>>> 
>>>> this series belongs to the "single binary" topic, where we are trying to
>>>> build a single QEMU binary with all architectures embedded.
>> 
>> Yes I get it now, I just forgot as this wasn't mentioned so the goal
>> wasn't obvious.
>> 
>
> The more I work on this topic, the more I realize we miss a clear and concise 
> document (wiki page, or anything than can be edited easily - not email) 
> explaining this to other developers, and that we could share as a link, and 
> enhance based on the questions asked.

Maybe you can start collecting FAQ on a wiki page so you don't have to 
answer them multiple times. I think most people aware of this though just 
may not associate a series with it if not mentioned in the description.

>>>> To achieve that, we need to have every single compilation unit compiled
>>>> only once, to be able to link a binary without any symbol conflict.
>>>> 
>>>> A consequence of that is target specific code (in terms of code relying
>>>> of target specific macros) needs to be converted to common code,
>>>> checking at runtime properties of the target we run. We are tackling
>>>> various places in QEMU codebase at the same time, which can be confusing
>>>> for the community members.
>> 
>> Mentioning this single binary in related series may help reminding readers
>> about the context.
>> 
>
> I'll make sure to mention this "name" in the title for next series, thanks!
>
>>>> This series take care of system memory related functions and associated
>>>> compilation units in system/.
>>>> 
>>>>>> As a positive side effect, we can
>>>>>> turn related system compilation units into common code.
>>>>> 
>>>>> Are there any negative side effects? In particular have you done any
>>>>> performance benchmarking to see if this causes a measurable slow down?
>>>>> Such as with the STREAM benchmark:
>>>>> https://stackoverflow.com/questions/56086993/what-does-stream-memory-bandwidth-benchmark-really-measure
>>>>> 
>>>>> Maybe it would be good to have some performance tests similiar to
>>>>> functional tests that could be run like the CI tests to detect such
>>>>> performance changes. People report that QEMU is getting slower and 
>>>>> slower
>>>>> with each release. Maybe it could be a GSoC project to make such tests 
>>>>> but
>>>>> maybe we're too late for that.
>>>>> 
>>>> 
>>>> I agree with you, and it's something we have mentioned during our
>>>> "internal" conversations. Testing performance with existing functional
>>>> tests would already be a first good step. However, given the poor
>>>> reliability we have on our CI runners, I think it's a bit doomed.
>>>> 
>>>> Ideally, every QEMU release cycle should have a performance measurement
>>>> window to detect potential sources of regressions.
>> 
>> Maybe instead of aiming for full CI like performance testing something
>> simpler like a few tests that excercise some apects each like STREAM that
>> tests memory access, copying a file from network and/or disk that tests
>> I/O and mp3 encode with lame for example that's supposed to test floating
>> point and SIMD might be simpler to do. It could be made a bootable image
>> that just runs the test and reports a number (I did that before for
>> qemu-system-ppc when we wanted to test an issue that on some hosts it ran
>> slower). Such test could be run by somebody making changes so they could
>> call these before and after their patch to quickly check if there's
>> anything to improve. This may be less through then full performance
>> testing but still give some insight and better than not testing anything
>> for performance.
>> 
>> I'm bringig this topic up to try to keep awareness on this so QEMU can
>> remain true to its name. (Although I'm not sure if originally the Q in the
>> name stood for the time it took to write or its performance but it's
>> hopefully still a goal to keep it fast.)
>> 
>
> You do well to remind that, but as always, the problem is that "run by 
> somebody" is not an enforceable process.
>
>>>> To answer to your specific question, I am trying first to get a review
>>>> on the approach taken. We can always optimize in next series version, in
>>>> case we identify it's a big deal to introduce a branch for every memory
>>>> related function call.
>> 
>> I'm not sure we can always optimise after the fact so sometimes it can be
>> necessary to take performance in consideration while designing changes.
>> 
>
> In the context of single binary concerned series, we mostly introduce a few 
> branches in various spots, to do a runtime check.
> As Richard mentioned in this series, we can keep target code exactly as it 
> is.
>
>>>> In all cases, transforming code relying on compile time
>>>> optimization/dead code elimination through defines to runtime checks
>>>> will *always* have an impact,
>> 
>> Yes, that's why it would be good to know how much impact is that.
>> 
>>>> even though it should be minimal in most of cases.
>> 
>> Hopefully but how do we know if we don't even test for it?
>> 
>
> In the case of this series, I usually so a local test booting (automatically) 
> an x64 debian stable vm, that poweroff itself as part of its init.
>
> With and without this series, the variation is below the average one I have 
> between two runs (<1 sec, for a total of 40 seconds), so the impact is 
> litterally invisible.

That's good to hear. Some overhead which is unavoidable is OK I just hope 
we can avoid which is not unavoidable and try to do something about what 
would have noticable performance penalty. If you're already aware of that 
and do that then that's all I wanted to say, nothing new.

>>>> But the maintenance and compilation time benefits, as well as
>>>> the perspectives it opens (single binary, heterogeneous emulation, use
>>>> QEMU as a library) are worth it IMHO.
>> 
>> I'm not so sure about that. Heterogeneous emulation sounds interesting but
>> is it needed most of the time? Using QEMU as a library also may not be
>> common and limited by licencing. The single binary would simplify packages
>> but then this binary may get huge so it's slower to load, may take more
>> resources to run and more time to compile and if somebody only needs one
>> architecture why do I want to include all of the others and wait for it to
>> compile using up a lot of space on my disk? So in other words, while these
>> are interesting and good goals could it be achieved with keeping the
>> current way of building single ARCH binary as opposed to single binary
>> with multiple archs and not throwing out the optimisations a single arch
>> binary can use? Which one is better may depend on the use case so if
>> possible it would be better to allow both keeping what we have and adding
>> multi arch binary on top not replacing the current way completely.
>> 
>
> Thanks, it's definitely interesting to hear the concerns on this, so we can 
> address them, and find the best and minimal solution to achive the desired 
> goal.
>
> I'll answer point by point.
>
> QEMU as a library: that's what Unicorn is 
> (https://www.unicorn-engine.org/docs/beyond_qemu.html), which is used by a 
> lot of researchers. Talking frequently with some of them, they would be happy 
> to have such a library directly with upstream QEMU, so it can benefit from 
> all the enhancements done to TCG. It's mostly a use case for security 
> researchers/engineers, but definitely a valid one. Just look at the list of 
> QEMU downstream forks focused on that. Combining this with plugins would be 
> amazing, and only grow our list of users.
>
> For the heterogeneous scenario, yes it's not the most common case. But we 
> *must*, in terms of QEMU binary, be able to have a single binary first. By 
> that, I mean the need is to be able to link a binary with several arch 
> present, without any symbol conflict.

OK Unicorn engine explains it and it needs multiple targets in single 
library (which maybe is the real goal, not a single binary here and that 
only needs targets not all devices). By the way I think multiple-arch is 
what they really mean on that beyond_qemu.html page above under 
Thread-safety.

> The other approach possible is to rename many functions through QEMU codebase 
> by adding a target_prefix everywhere, which would be ugly and endless. That's 
> why we are currently using the "remove duplicated compilation units" 
> pragmatic approach. As well, we can do a lot of headers cleanup on the way 
> (removing useless dependencies), which is good for everyone.
>
> For compilation times, it will only speed it up, because in case you have 
> only specific targets, non-needed files won't be compiled/linked. For multi 
> target setup, it's only a speed up (with all targets, it would be a drop from 
> 9000+ CUs to around 4000+). Less disk space as well, most notable in debug.
> As well, having files compiled only once allow to use reliably code 
> indexation tools (clangd for instance), instead of picking a random CU 
> setting based on one target.
> Finally, having a single binary would mean it's easy to use LTO (or at least 
> distros would use it easily), and get the same or better performance as what 
> we have today.
>
> The "current" way, with several binaries, can be kept forever if people

As I said I think that would be needed as there are valid use cases for 
both.

> wants. But it's not feasible to keep headers and cu compatible for both 
> modes. It would be a lot of code duplication, and that is really not 
> desirable IMHO. So we need to do those system wide changes and convince the 
> community it's a good progress for everyone.

It would be nice to keep optimisations where possible and it seems it 
might be possible sometimes so just take that in consideration as well not 
just one goal.

> Kudos to Philippe who has been doing this long and tedious work for several 
> years now, and I hope that with some fresh eyes/blood, it can be completed 
> soon.

Absolutely and I did not mean to say not to do it just added another view 
point for consideration.

Regards,
BALATON Zoltan

