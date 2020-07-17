Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79B22224080
	for <lists+kvm@lfdr.de>; Fri, 17 Jul 2020 18:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgGQQWv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jul 2020 12:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgGQQWu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jul 2020 12:22:50 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE34C0619D2;
        Fri, 17 Jul 2020 09:22:50 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595002968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VL5z70c9ivCEdV8jKg+QDjtim4MWFgGLQSfzhEgLqa4=;
        b=DfxFj3JOgV4P677n+L/c5gnLES+uaqRVgDiXn4Zyua9k+6KCFkhE7/z4MS2WRsstct8xur
        nZcrlvILdQK2ZAKEujSK+L0npVKy1e/7kIAKwoYjCbIcPFjNnih6kWQ5elx12s7QxdDCjU
        PkR2xr/sEuc9eJbkHrs1QBVGajuzYT3up1jq1op76OkNoYB4+jnF0ljFojiMCIwnnIL4LN
        6xTZATNPpKM0Erw/bQvMt94JNWe/l7yFBJ9NdrLsgnSp4/y3cKCfsQXioB630iNrzoEABF
        eVzL2Vy2QjloV/c2ZBlGxJjKHJARusemqD0C1M6ReMZjLdhsTiolM6QSMBOEDA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595002968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VL5z70c9ivCEdV8jKg+QDjtim4MWFgGLQSfzhEgLqa4=;
        b=UV0QsqJXu+FJ1RFv4cdZ1We2LAZTtzHAlTORuWLNQvaypU2QZB7sSYNPBDGjwoP6zoBXn5
        +ADCc0JiHIgn+RDw==
To:     Doug Anderson <dianders@chromium.org>
Cc:     Abhishek Bhardwaj <abhishekbh@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Anthony Steinhauser <asteinhauser@google.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Waiman Long <longman@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        x86 <x86@kernel.org>
Subject: Re: [PATCH v5] x86/speculation/l1tf: Add KConfig for setting the L1D cache flush mode
In-Reply-To: <CAD=FV=WCu7o41iyn27vNBWo4f_X_XVy+PPPjBKc+70g5jd5+8w@mail.gmail.com>
References: <20200708194715.4073300-1-abhishekbh@google.com> <87y2ntotah.fsf@nanos.tec.linutronix.de> <CAD=FV=WCu7o41iyn27vNBWo4f_X_XVy+PPPjBKc+70g5jd5+8w@mail.gmail.com>
Date:   Fri, 17 Jul 2020 18:22:47 +0200
Message-ID: <874kq6ru08.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Doug,

Doug Anderson <dianders@chromium.org> writes:
> On Thu, Jul 9, 2020 at 3:51 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>> TBH, I don't see why this is a good idea.
>>
>>  1) I'm not following your argumentation that the command line option is
>>     a poor Kconfig replacement. The L1TF mode is a boot time (module
>>     load time) decision and the command line parameter is there to
>>     override the carefully chosen and sensible default behaviour.
>
> When you say that the default behavior is carefully chosen and
> sensible, are you saying that (in your opinion) there would never be a
> good reason for someone distributing a kernel to others to change the
> default?  Certainly I agree that having the kernel command line
> parameter is nice to allow someone to override whatever the person
> building the kernel chose, but IMO it's not a good way to change the
> default built-in to the kernel.

The problem is that you have to be careful about what you stick into
Kconfig. It's L1TF on x86 today and tomorrow it's MDS and whatever and
then you do the same thing on the other architectures as well. And we
still need the command line options so that generic builds can be
customized at boot time.

> The current plan (as I understand it) is that we'd like to ship
> Chromebook kernels with this option changed from the default that's
> there now.  In your opinion, is that a sane thing to do?

If it's sane for you folks, then feel free to do so. Distros & al patch
the kernel do death anyway, but that does not mean that mainline has to
have everything these people chose to do.

>>  2) You can add the desired mode to the compiled in (partial) kernel
>>     command line today.
>
> This might be easier on x86 than it is on ARM.  ARM (and ARM64)
> kernels only have two modes: kernel provides cmdline and bootloader
> provides cmdline.  There are out-of-mainline ANDROID patches to
> address this but nothing in mainline.
>
> The patch we're discussing now is x86-only so it's not such a huge
> deal, but the fact that combining the kernel and bootloader
> commandline never landed in mainline for arm/arm64 means that this
> isn't a super common/expected thing to do.

Did you try to get that merged for arm/arm64?

>>  3) Boot loaders are well capable of handling large kernel command lines
>>     and the extra time spend for reading the parameter does not matter
>>     at all.
>
> Long command lines can still be a bit of a chore for humans to deal
> with.  Many times I've needed to look at "/proc/cmdline" and make
> sense of it.  The longer the command line is and the more cruft
> stuffed into it the more of a chore it is.  Yes, this is just one
> thing to put in the command line, but if 10 different drivers all have
> their "one thing" to put there it gets really long.  If 100 different
> drivers all want their one config option there it gets really really
> long.

This will not go away when you want to support a gazillion of systems
which need tweaks left and right due to creative hardware/BIOS with a
generic kernel. And come on, parsing a long command line is not rocket
science and it's not something you do every two minutes.

> IMO the command line should be a last resort place to put
> things and should just contain:
>
> 1. Legacy things that _have_ to be in the command line because they've
> always been there.
>
> 2. Things that the bootloader/BIOS needs to communicate to the kernel
> and has no better way to communicate.
>
> 3. Cases where the person running the kernel needs to override a
> default set by the person compiling the kernel.

Which is the case for a lot of things and it's widely used exactly for
that reason.

>>  4) It's just a tiny part of the whole speculation maze. If we go there
>>     for L1TF then we open the flood gates for a gazillion other config
>>     options.
>
> It seems like the only options that we'd need CONFIG option for would
> be the ones where it would be sane to change the default compiled into
> the kernel.  Hopefully that's not too many things?

That's what _you_ need. But accepting this we set a precedence and how
do I argue that L1TF makes sense, but other things not? This stuff is
horrible enough already, no need to add more ifdefs and options and
whatever to it.

> Obviously, like many design choices, the above is all subjective.
> It's really your call and if these arguments don't convince you it
> sounds like the way forward is just to use "CONFIG_CMDLINE" and take
> advantage of the fact that on x86 this will get merged with the
> bootloader's command line.

I rather see the support for command line merging extended to arm/arm64
because that's of general usefulness beyond the problem at hand.

Thanks,

        tglx
