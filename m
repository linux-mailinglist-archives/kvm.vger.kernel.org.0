Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69B54420B62
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 14:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233738AbhJDM5A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 08:57:00 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:44062 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233584AbhJDM4j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 08:56:39 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633352089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=62OmEZ5vBf0VS7xxv6zBKLiA9bAGxIWLY0YLtcYhdkM=;
        b=BZIffpy133/yzNOScRB4BBhPtTdvlG4VHFT6aZjnljPIqh/ysKiOm/7OZTD02DYnvI1SjN
        i5F6qCN5rZi8Lji1arf7u3RrZH2KIErZc4bmy5vPlHFwEVENtUOZdqm3mbxE6nTnxhhkq4
        xTvT33qc49lnNJVQTh8fAv07ImjxpKjibNatVEQ2wiMhNIg00fL+r55nQOHjPRPeh1LogB
        P8dgTC4XTJtvDgj9FoXg8cG0tS4aZ5SBtY1QxCQ2QalO8zIyPLd/mJ8UCImKbGl7mK+aPV
        IKAtOQXaNKqaGDk/PxLqPsVt/UxGE0yWrsQfX4V0Q7dYjsfiRu56ka2q6+z9ww==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633352089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=62OmEZ5vBf0VS7xxv6zBKLiA9bAGxIWLY0YLtcYhdkM=;
        b=R77QosgLqt29Za3iflfHfOxMjgQ94okqHVkr0qsGCn66EWopBVj/iq/XR5cY7/mkL8PALl
        mKs0DkwF20nYcrCA==
To:     "Bae, Chang Seok" <chang.seok.bae@intel.com>
Cc:     "bp@suse.de" <bp@suse.de>, "Lutomirski, Andy" <luto@kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Macieira, Thiago" <thiago.macieira@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v10 04/28] x86/fpu/xstate: Modify address finders to
 handle both static and dynamic buffers
In-Reply-To: <B7F1A300-3E61-4CB4-8BCA-316FE68B7222@intel.com>
References: <20210825155413.19673-1-chang.seok.bae@intel.com>
 <20210825155413.19673-5-chang.seok.bae@intel.com> <87ee946g45.ffs@tglx>
 <B7F1A300-3E61-4CB4-8BCA-316FE68B7222@intel.com>
Date:   Mon, 04 Oct 2021 14:54:48 +0200
Message-ID: <878rz9gdbb.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 03 2021 at 22:35, Chang Seok Bae wrote:
> On Oct 1, 2021, at 06:15, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Okay, a NULL pointer is odd and it as an argument should be avoided. Defining
> a separate struct fpu for the initial state can make every function expect a
> valid struct fpu pointer.
>
> I think that the patch set will have such order (once [1] is dropped out) of,
>     - patch1 (new): a cleanup patch for fpstate_init_xstate() in patch1
>     - patch2 (new): the above init_fpu goes into this, and 
>     - patch3-5: changes arguments to fpu,

So actually I sat down over the weekend and looked at that again. Adding this
to struct fpu is wrong. The size and features information belongs into
something like this:

struct fpstate {
	unsigned int		size;
        u64			xfeatures;

        union fpregs_state	regs;
};

Why? Simply because fpstate is the container for the dynamically sized
regs and that's where it semantically belongs.

While staring at that I just started to cleanup stuff all over the place
to make the integration of this simpler.

The patches are completely untested and have no changelogs yet, but if
you want a preview, I've uploaded a patch series to:

    https://tglx.de/~tglx/patches.tar

I'm still staring at some of the dynamic feature integrations, but this
is roughly where this should be heading.

Thanks,

        tglx
