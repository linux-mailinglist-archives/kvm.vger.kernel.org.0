Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68082D8FE8
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 13:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389604AbfJPLtm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 07:49:42 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:49888 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728404AbfJPLtm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 07:49:42 -0400
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1iKhnz-00040t-47; Wed, 16 Oct 2019 13:49:27 +0200
Date:   Wed, 16 Oct 2019 13:49:26 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        H Peter Anvin <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, kvm@vger.kernel.org
Subject: Re: [PATCH v9 09/17] x86/split_lock: Handle #AC exception for split
 lock
In-Reply-To: <57f40083-9063-5d41-f06d-fa1ae4c78ec6@redhat.com>
Message-ID: <alpine.DEB.2.21.1910161244060.2046@nanos.tec.linutronix.de>
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com> <1560897679-228028-10-git-send-email-fenghua.yu@intel.com> <alpine.DEB.2.21.1906262209590.32342@nanos.tec.linutronix.de> <20190626203637.GC245468@romley-ivt3.sc.intel.com>
 <alpine.DEB.2.21.1906262338220.32342@nanos.tec.linutronix.de> <20190925180931.GG31852@linux.intel.com> <3ec328dc-2763-9da5-28d6-e28970262c58@redhat.com> <alpine.DEB.2.21.1910161142560.2046@nanos.tec.linutronix.de>
 <57f40083-9063-5d41-f06d-fa1ae4c78ec6@redhat.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 16 Oct 2019, Paolo Bonzini wrote:
> On 16/10/19 11:47, Thomas Gleixner wrote:
> > On Wed, 16 Oct 2019, Paolo Bonzini wrote:
> >> Just never advertise split-lock
> >> detection to guests.  If the host has enabled split-lock detection,
> >> trap #AC and forward it to the host handler---which would disable
> >> split lock detection globally and reenter the guest.
> > 
> > Which completely defeats the purpose.
> 
> Yes it does.  But Sean's proposal, as I understand it, leads to the
> guest receiving #AC when it wasn't expecting one.  So for an old guest,
> as soon as the guest kernel happens to do a split lock, it gets an
> unexpected #AC and crashes and burns.  And then, after much googling and
> gnashing of teeth, people proceed to disable split lock detection.

I don't think that this was what he suggested/intended.

> In all of these cases, the common final result is that split-lock
> detection is disabled on the host.  So might as well go with the
> simplest one and not pretend to virtualize something that (without core
> scheduling) is obviously not virtualizable.

You are completely ignoring any argument here and just leave it behind your
signature (instead of trimming your reply).

> > 1) Sane guest
> > 
> > Guest kernel has #AC handler and you basically prevent it from
> > detecting malicious user space and killing it. You also prevent #AC
> > detection in the guest kernel which limits debugability.

That's a perfectly fine situation. Host has #AC enabled and exposes the
availability of #AC to the guest. Guest kernel has a proper handler and
does the right thing. So the host _CAN_ forward #AC to the guest and let it
deal with it. For that to work you need to expose the MSR so you know the
guest state in the host.

Your lazy 'solution' just renders #AC completely useless even for
debugging.

> > 2) Malicious guest
> > 
> > Trigger #AC to disable the host detection and then carry out the DoS 
> > attack.

With your proposal you render #AC useless even on hosts which have SMT
disabled, which is just wrong. There are enough good reasons to disable
SMT.

I agree that with SMT enabled the situation is truly bad, but we surely can
be smarter than just disabling it globally unconditionally and forever.

Plus we want a knob which treats guests triggering #AC in the same way as
we treat user space, i.e. kill them with SIGBUS.

Thanks,

	tglx
