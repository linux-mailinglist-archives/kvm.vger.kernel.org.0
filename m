Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAFD1FE4F6
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 19:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfKOSdy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 13:33:54 -0500
Received: from mail-wr1-f46.google.com ([209.85.221.46]:34267 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbfKOSdy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Nov 2019 13:33:54 -0500
Received: by mail-wr1-f46.google.com with SMTP id e6so12056718wrw.1
        for <kvm@vger.kernel.org>; Fri, 15 Nov 2019 10:33:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nt76VJq+AvRdmgTmCwjkMhdJekqZR/On+yFU5X38d+g=;
        b=fwUy1Z5gpBOK/bEoLUPvETy3MtxsG6ETR6mMYA4n4AX75FJkAgtm3/XHEEPQ9LAyzG
         CVvVmLbNbHtBt21R++5TbVu4TFQph0XkTzzdhGxeo6MO0qA/I5bba1DEu2YTEAk0vj4F
         enYXtOzxYT7Fs5Q5zJKvVrY/O9zMS103EJVP6tSF7eCzA7AKFNpSlcZ7rNiQNeJscq7i
         ovwkhGSwybxr/RN/p/7nY4eZbTxUml5R8NgUdo8hWvVWs5Je/npJUACVAj87abexBWNa
         kwg9x/WwOzATURMFu/YGAfTae56p+dr8CMYDY3v9jsiAJvEd9+v7r7p43i4sPw0oyhaS
         ymiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nt76VJq+AvRdmgTmCwjkMhdJekqZR/On+yFU5X38d+g=;
        b=qsVp0MaPrqCSD87KXZLqxRzV2J4evHpRC03zD8vGw9nvsXCtkY80C24tvCRHvF3gy/
         tEABwhZHhSxLXyA2jS4VQiepF400stL9Q3cX5IpTT7mx1nvR++GEn1MSzXjDhMiLv4u9
         oMqoz18A5VeD1kR8/lrsZsuTXAU8M9LFYNuhPsHjne0xWQnts644otrDFkk2W64mB5CE
         ERJe+8NL1hsKEcEiLCMvjBckzY4ElYJlfw/OuV5g4gPE4FvBiyOYZkO3w2OvFOOaAmd9
         3SQcq0778BLXq5phZLxqxlmVr8/Cf+fs27J8nU0xQ1DTRdKRQqS0UdUp65/F1nad3BOr
         3X6g==
X-Gm-Message-State: APjAAAWZ0OSoDfStH0Prgn/5c1+2KfZ1K8JL27bF015AwOrXzKm+kfwb
        WK2xX9e1QQ0BcsbL8SIK/744fqpqDg3W3/6cUkyL5LyV
X-Google-Smtp-Source: APXvYqzoOQteX/gW1P0FfoNlQQlSeZ75l/+9letcXdSTmieCv5BkByiyI4FBymc6LOoVzcF76KPLNVGb7IBmXTSlpEM=
X-Received: by 2002:adf:e389:: with SMTP id e9mr7356278wrm.285.1573842831013;
 Fri, 15 Nov 2019 10:33:51 -0800 (PST)
MIME-Version: 1.0
References: <CALMp9eQ3NcXOJ9MDMBhm2Fi2cvMW7X5GxVgDw97zS=H5vOMvgw@mail.gmail.com>
 <a5845d60-fe38-afc6-e433-4c5a12813026@redhat.com>
In-Reply-To: <a5845d60-fe38-afc6-e433-4c5a12813026@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 15 Nov 2019 10:33:39 -0800
Message-ID: <CALMp9eRdWCbN689WrB2WKG3N3_vqpYa6G+1CB+kUbO_sig026w@mail.gmail.com>
Subject: Re: KVM_GET_SUPPORTED_CPUID
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 15, 2019 at 3:42 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 14/11/19 21:09, Jim Mattson wrote:
> > Can someone explain this ioctl to me? The more I look at it, the less
> > sense it makes to me.
>
> It certainly has some historical baggage in it, much like
> KVM_GET_MSR_INDEX_LIST.  But (unlike KVM_GET_MSR_INDEX_LIST) it's mostly
> okay; the issues you report boil down to one of:
>
> 1) KVM_GET_SUPPORTED_CPUID being a system ioctl
>
> 2) supporting the simple case of taking the output of
> KVM_GET_SUPPORTED_CPUID and passing it to KVM_SET_CPUID2

For this purpose, wouldn't 'DEFAULT' make a lot more sense than
'SUPPORTED' in the name of this ioctl?

> 3) CPUID information being poorly designed, or just Intel doing
> undesirable things
>
> > Let's start with leaf 0. If I see 0xd in EAX, does that indicate the
> > *maximum* supported value in EAX?
>
> This is easy, you can always supply a subset of the values to the guest,
> and this includes reducing the value of integer values (such as the
> number of leaves) or clearing bits.  It should be documented better,
> possibly including with a list of leaves that can be filled by the VMM
> as it likes (e.g. cache topology).

Maybe you can reduce CPUID.0H:EAX, but there are some integer values
that you can't reduce (e.g. CPUID.(EAX=0Dh,ECX=0):ECX). So, I'd argue
that this isn't "easy."

> > Or does that mean that only a value
> > of 0xd is supported for EAX? If I see "AuthenticAMD" in EBX/EDX/ECX,
> > does that mean that "GenuineIntel" is *not* supported? I thought
> > people were having reasonable success with cross-vendor migration.
>
> This is (2).  But in general passing the host value is the safe choice,
> everything else has reasonable success but it's not something I would
> recommend in production (and it's something I wouldn't mind removing,
> really).
>
> > What about leaf 7 EBX? If a bit is clear, does that mean setting the
> > bit is unsupported? If a bit is set, does that mean clearing the bit
> > is unsupported? Do those answers still apply for bits 6 and 13, where
> > a '1' indicates the absence of a feature?
>
> Again, clearing bits is always supported in theory, but I say "in
> theory" because of course bits 6 and 13 are indeed problematic. And
> unfortunately the only solutions for those is to stick your head in the
> sand and pretend they don't exist.  If bits 6 and 13 were handled
> strictly, people would not be able to migrate VMs between e.g. Haswell
> and Ivy Bridge machines within the same fleet, which is something people
> want to do.  So, this is (3).

For these two bits, one could argue that *setting* them is always
supported, at least insofar as *clearing* the normal polarity bits is
supported. If you say that FCS and FDS are "deprecated [sic]" on your
Ivy Bridge platform, but software relies on it, then that software is
just as ill-behaved as software that depends on any other feature that
has been masked off. (Of course, none of the software that actually
depends on this feature actually checks the CPUID bit, since the CPUID
bit was defined after-the-fact.) So, even if you're strict about it,
you can migrate between Haswell and Ivy Bridge.


> A similar case is CPUID[0Ah].EBX (unavailable architectural events).
>
> > What about leaf 0xa? Kvm's api.txt says, "Note that certain
> > capabilities, such as KVM_CAP_X86_DISABLE_EXITS, may expose cpuid
> > features (e.g. MONITOR) which are not supported by kvm in its default
> > configuration. If userspace enables such capabilities, it is
> > responsible for modifying the results of this ioctl appropriately."
> > However, it appears that the vPMU is enabled not by such a capability,
> > but by filling in leaf 0xa.
>
> Right, the supported values are provided by KVM_GET_SUPPORTED_CPUID.  So
> as long as you don't zero the PMU version id to 0, PMU is enabled.
>
> > How does userspace know what leaf 0xa
> > values are supported by both the hardware and kvm?
>
> Reducing functionality is supported---fewer GP or fixed counters, or
> disabling events by *setting* bits in EBX or reducing EAX[31:24].
>
> > And as for KVM_CAP_X86_DISABLE_EXITS, in particular, how is userspace
> > supposed to know what the appropriate modification to
> > KVM_GET_SUPPORTED_CPUID is? Is this documented somewhere else?
> >
> > And as for the "certain capabilities" clause above, should I assume
> > that any capability enabled by userspace may require modifications to
> > KVM_GET_SUPPORTED_CPUID?  What might those required modifications be?
> > Has anyone thought to document them, or better yet, provide an API to
> > get them?
>
> And finally this is (1).  It should be documented by the individual
> capabilities or ioctls.
>
> With KVM_ENABLE_CAP, the only one that is _absent_ from
> KVM_GET_SUPPORTED_CPUID the MONITOR bit.

And leaf 5?

> The opposite case is X2APIC, which is reported as supported in
> KVM_GET_SUPPORTED_CPUID even though requires KVM_CREATE_IRQCHIP (or
> KVM_ENABLE_CAP + KVM_CAP_SPLIT_IRQCHIP).  Of course any serious VMM uses
> in-kernel irqchip, but still it's ugly.
>
> Providing an API to get a known-good value of CPUID for the current VM
> (a KVM_GET_SUPPORTED_CPUID vm-ioctl, basically) would be a fine idea.
> If anybody is interested, I can think of other cases where this applies.
>  It would provide a better way to do (2), essentially.
>
> > What about the processor brand string in leaves 0x80000000-0x80000004?
> > Is a string of NULs really the only supported value?
>
> Indeed this should probably return the host values, at least for
> consistency with the vendor.
>
> > And just a nit, but why does this ioctl bother returning explicitly
> > zeroed leaves for unsupported leaves in range?
>
> No particular reason, it just keeps the code simpler.
>
> > It would really be nice if I could use this ioctl to write a
> > "HostSupportsGuest" function based in part on an existing guest's
> > CPUID information, but that doesn't seem all that feasible, without
> > intimate knowledge of how the host's implementation of kvm works.
>
> It does not depend that much on knowledge of the host's implementation
> of KVM.  However, it does depend on tiny details of the CPUID bits.
>
> Thanks,
>
> Paolo
>
