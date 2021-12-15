Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5044755DF
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 11:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241529AbhLOKJn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 05:09:43 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:47056 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236662AbhLOKJm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Dec 2021 05:09:42 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639562981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=77Forlu4jTsD7arP2c+F0ARgAvIkkJEpfa/mmyGaEzs=;
        b=T9rXDFnzFqL0S53u7ODOMdQvDIcX001x8fdxrBWt2SIGgQEayqKviyhT2IWQ5CpTbvMcDX
        sUWTUA+GmFr0wbcOMI/vMwSkBAVaTHs0R9isSttwVblI4JpHWMUxeivRCJX+srJO9WuYoq
        s6lJD90Bo4G6bVlNdcP/RLL1hlFRUbXtmb9FUsoO1XcrKTzbKlr4o2qeymXTDlUMShnh9N
        pcqZbHtOX8a8KB3k9CvEUkjrNYwJ6Jsjmr0GWFofp/VnttFdqXV/yh5zRdVAI5Wp9By9ga
        +h7SnUNLaS+oY4LmyVVGK9lyxM7rY0CmqiG5v9T58ynzxqwkFHBAhxR0Ikig1w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639562981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=77Forlu4jTsD7arP2c+F0ARgAvIkkJEpfa/mmyGaEzs=;
        b=0WzFzjUD2eoPPem6JFTvMPAl8kR4/7bYf7qrWsv3OpwhtOccFrR4yGguWhbyZk6OoLC1hO
        3fsJJdhL7QZWPnCQ==
To:     "Wang, Wei W" <wei.w.wang@intel.com>,
        "quintela@redhat.com" <quintela@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Sean Christoperson <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Zeng, Guang" <guang.zeng@intel.com>
Subject: RE: [patch 5/6] x86/fpu: Provide fpu_update_guest_xcr0/xfd()
In-Reply-To: <afeba57f71f742b88aac3f01800086f9@intel.com>
References: <20211214022825.563892248@linutronix.de>
 <20211214024948.048572883@linutronix.de>
 <854480525e7f4f3baeba09ec6a864b80@intel.com> <87zgp3ry8i.ffs@tglx>
 <b3ac7ba45c984cf39783e33e0c25274d@intel.com> <87r1afrrjx.ffs@tglx>
 <87k0g7qa3t.fsf@secure.mitica> <87k0g7rkwj.ffs@tglx>
 <878rwm7tu8.fsf@secure.mitica>
 <afeba57f71f742b88aac3f01800086f9@intel.com>
Date:   Wed, 15 Dec 2021 11:09:40 +0100
Message-ID: <878rwmrxgb.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 15 2021 at 02:17, Wei W. Wang wrote:
> On Wednesday, December 15, 2021 5:36 AM, Juan Quintela wrote:
>> >> If it needs to be done in any other order, it is completely
>> >> independent of whatever is inside the migration stream.
>> >
>> > From the migration data perspective that's correct, but I have the
>> > nagging feeling that this in not that simple.
>> 
>> Oh, I was not meaning that it was simple at all.
>
> It seems to be a consensus that the ordering constraint wouldn't be
> that easy.

Right, but what is easy in this context? Not easy does not mean it is
impossible.

> Would you think that our current solution (the 3 parts shared earlier
> to do fpstate expansion at KVM_SET_XSAVE) is acceptable as the 1st
> version?

This is really the wrong question in the context of an user space ABI.

The point is that if we go and add that hack, then the hack has to be
supported forever. So there is no "as the 1st version".

I'm not at all a fan of this kind of approach because it puts the burden
at the wrong end and it carefully avoids to sit down and really think it
through.

That way we just pile hacks on hacks forever up to the point where the
hacks end up in a circular dependency which becomes unresolvable.

That's not a KVM/Qemu specific problem. That's a problem in general and
we've been bitten by that again and again.

The worst about this is that those people who try to sell their quick
and dirty hack in the first place are not those who end up dealing with
the consequences some time down the road.

Lets assume the restore order is XSTATE, XCR0, XFD:

     XSTATE has everything in init state, which means the default
     buffer is good enough

     XCR0 has everything enabled including AMX, so the buffer is
     expanded

     XFD has AMX disable set, which means the buffer expansion was
     pointless

If we go there, then we can just use a full expanded buffer for KVM
unconditionally and be done with it. That spares a lot of code.

Thanks,

        tglx
