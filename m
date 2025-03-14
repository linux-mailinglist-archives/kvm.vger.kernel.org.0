Return-Path: <kvm+bounces-41059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 83CACA6124F
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 14:16:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 36BE17AD92B
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 13:15:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A18CC1FFC76;
	Fri, 14 Mar 2025 13:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="buQiEUuv"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957481FFC4B;
	Fri, 14 Mar 2025 13:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741958086; cv=none; b=SnesYz5dMdknQU0aJidjJpBhdpyBhJ45CRwAjKFumk3AhA5RWn0GrJM2mTKYzypjE5P6nnbmXZXW7u367kLNZHOoWJfQ9U5uVxs+PEH7P73yqjIHNdARA82iiKLTeITghfi7mKMpoQYnPS8cy9Bm0JEwwRmhbExbzh++oCGoMwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741958086; c=relaxed/simple;
	bh=7DMjWm8n/7fLinZzNMznJvbWq1as/rJpVihvFho7YMY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J3TOLdDKiTyrYTYZqmpiQCF2o1z4VF8WS36X/+Uslc9xR1a8QbMy4UEosSIdLbrnZTGU9mPJGxT2D9S/JiKXHjT8egU4b5M3tAZ/bCcUGzGiTGBbedyzuOSRwFXx9UbAWZdhJZCoLETMzRaEF3nwDdRZXgBTFdSMWvo/kr0MZRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=buQiEUuv; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 270D340E015E;
	Fri, 14 Mar 2025 13:14:41 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id z-pXS9vvo2h3; Fri, 14 Mar 2025 13:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1741958076; bh=rK3jFCPqqItfl6ZwdgpRWuAuoUZAqjm53rLp3ckpUT0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=buQiEUuvGPz5ahlbn9PZtwPr+7vVbnqzon3HVoWjnvJq7YlGd1eCukMFuwc5DbzNq
	 +BBRyB87TCk0D6ai9KuTHjQxQgVo83ZljRWXRyJ5xCSwl3aEOfYGhGUX3zDZDLnqn+
	 s2MU7ElEGXfjAV89BWTTnroEzUBIS3Wf3RUT/kV2+7OjClA9DQG/Hvopy2xRaK7Bn8
	 lmG1GyeoHZ8k5v3BYHWevFZgw8ryzPcmzY7T/A8YyzHsCdFH//sIIUfXajgXZbotnx
	 IhXKl0/iiNsMHRKO7/uUyXgXoiIaz5gaEaAA8W8VdjBES3RrkRV+0aDAd3j+6kSHUV
	 6k++mMLZZyAN2jc0Hu6M4sR91Y9zoHt/jS7tc7Bgbr/ypFP1R4MkETlxEvEn8gvWO/
	 Y7rPYfvUfrnjUTMWCLU9v/5/s2XYAqsS6ftcIib2NBhMmT2R7V3ROm6PNzSbzb3Rvl
	 9JgDLtLPWisWvlUMzaDaH5Unqhf8eG2wm/sVnKTsR98OQDs/Ooj0UY6GeH6Pu6P1J/
	 2qAAJ83OLDHUGkfe0hPZzL6plpiHGeQlHlXjJoHhtm8q57frspkNwtX2/53ad6KY0u
	 S32/I19c9GIX27/+TaNuIc4iI9x2XZe0tre/KLSLBG8Wtyc5d6Fs/HOtJAVxxel8/N
	 jmLhNS9GU2k3ONwVLl4hBbDw=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1A99F40E023B;
	Fri, 14 Mar 2025 13:14:25 +0000 (UTC)
Date: Fri, 14 Mar 2025 14:14:19 +0100
From: Borislav Petkov <bp@alien8.de>
To: Brendan Jackman <jackmanb@google.com>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com,
	yosryahmed@google.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	peterz@infradead.org, seanjc@google.com, tglx@linutronix.de,
	x86@kernel.org
Subject: Re: [PATCH RFC v2 03/29] mm: asi: Introduce ASI core API
Message-ID: <20250314131419.GJZ9Qrq8scAtDyBUcg@fat_crate.local>
References: <20250227120607.GPZ8BVL2762we1j3uE@fat_crate.local>
 <20250228084355.2061899-1-jackmanb@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250228084355.2061899-1-jackmanb@google.com>

On Fri, Feb 28, 2025 at 08:43:55AM +0000, Brendan Jackman wrote:
> Yeah I see what you mean. I think the issues are:
> 
> 1. We're mixing up two different aspects in the API:
> 
>    a. Starting and finishing "critical sections" (i.e. the region
>       between asi_enter() and asi_relax())
> 
>    b. Actually triggering address space transitions.
> 
> 2. There is a fundamental asymmetry at play here: asi_enter() and
>    asi_exit() can both be NOPs (when we're already in the relevant
>    address space), and asi_enter() being a NOP is really the _whole
>    point of ASI_.

I'm guessing you mean this thing in __asi_enter():

+	if (!target || target == this_cpu_read(curr_asi))
+		return;

The assumption being that curr_asi will be the target most of the time after
having done the expensive switch once...

>    The ideal world is where asi_exit() is very very rare, so
>    asi_enter() is almost always a NOP.

... asi_exit() being the actual switch to the unrestricted CR3.

And asi_relax() being the switch of current task's asi target ptr to NULL.
Comment says

"Domain to enter when returning to process context."

but I'm none-the-wiser.

So, why are we doing that relaxing thing?

I'm guessing the relaxing is marking the end of the region where we're running
untrusted code. After asi_relax() we are still in the restricted CR3 but we're
not running untrusted code.

> So we could disentangle part 1 by just rejigging things as you suggest,
> and I think the naming would be like:
> 
> asi_enter
>   asi_start_critical
>   asi_end_critical
> asi_exit

Yap, that's what I was gonna suggest: asi_enter and asi_exit do the actual CR3
build and switch and start_critical and end_critical do the cheaper tracking
thing.

> But the issue with that is that asi_start_critical() _must_ imply
> asi_enter()

What does that mean exactly?

asi_start_critical() must never be called before asi_enter()?

If so, I'm sure there are ways to track and check that and warn if not, right?

> (otherwise if we get an NMI between asi_enter() and
> asi_start_critical(), and that causes a #PF, we will start the
> critical section in the wrong address space and ASI won't do its job).
> So, we are somewhat forced to mix up a. and b. from above.

I don't understand: asi_enter() can be interrupted by an NMI at any random
point. How is the current, imbalanced interface not vulnerable to this
scenario?

> BTW, there is another thing complicating this picture a little: ASI
> "clients" (really just meaning KVM code at this point) are not not
> really supposed to care at all about the actual address space, the fact
> that they currently have to call asi_exit() in part 4b is just a
> temporary thing to simplify the initial implementation. It has a
> performance cost (not enormous, serious KVM platforms try pretty hard

You mean the switch to the unrestricted_cr3? I can imagine...

> to avoid returning to user space, but it does still matter) so
> Google's internal version has already got rid of it and that's where I
> expect this thing to evolve too. But for now it just lets us keep
> things simple since e.g. we never have to think about context
> switching in the restricted address space.
> 
> With that in mind, what if it looked like this:
> 
> ioctl(KVM_RUN) {
>     enter_from_user_mode()
>     while !need_userspace_handling()
> 	// This implies asi_enter(), but this code "doesn't care"
> 	// about that.
>         asi_start_critical();
>         vmenter();
>         asi_end_critical();
>     }
>     // TODO: This is temporary, it should not be needed.
>     asi_exit();
>     exit_to_user_mode()
> }
> 
> Once the asi_exit() call disappears, it will be symmetrical from the
> "client API"'s point of view. And while we still mix up address space
> switching with critical section boundaries, the address space
> switching is "just an implementation detail" and not really visible as
> part of the API.

So I'm still unclear on that whole design here so I'm asking silly questions
but I know that:

1. you can do empty calls to keep the interface balanced and easy to use

2. once you can remove asi_exit(), you should be able to replace all in-tree
   users in one atomic change so that they're all switched to the new,
   simplified interface

But I still have the feeling that we could re-jig what asi_enter/relax/exit do
and thus have a balanced interface. We'll see...

> I have now setup Mutt.

I did that 20 years ago. Never looked back. I'd say you're on the right track
:-)

> But, for now I am replying with plan vim + git-send-email, because I also
> sent this RFC to a ridiculous CC list (I just blindly used the
> get_maintainers.pl output, I don't know why I thought that was a reasonable
> approach) and it turns out this is the easiest way to trim it in a reply!
> Hopefully I can get the headers right...

Yeah, works. On the next version, you could trim it to the couple relevant
lists and to whoever reviewed this. The others can always get the thread from
lore and there's really no need anymore to Cc the whole world :)

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

