Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2F5D944F
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 16:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393210AbfJPOus (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 10:50:48 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50475 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388751AbfJPOus (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 10:50:48 -0400
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1iKkdJ-00073D-B5; Wed, 16 Oct 2019 16:50:37 +0200
Date:   Wed, 16 Oct 2019 16:50:36 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
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
        Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, kvm@vger.kernel.org
Subject: Re: [PATCH v9 09/17] x86/split_lock: Handle #AC exception for split
 lock
In-Reply-To: <b2c42a64-eb42-1f18-f609-42eec3faef18@intel.com>
Message-ID: <alpine.DEB.2.21.1910161646160.2046@nanos.tec.linutronix.de>
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com> <1560897679-228028-10-git-send-email-fenghua.yu@intel.com> <alpine.DEB.2.21.1906262209590.32342@nanos.tec.linutronix.de> <20190626203637.GC245468@romley-ivt3.sc.intel.com>
 <alpine.DEB.2.21.1906262338220.32342@nanos.tec.linutronix.de> <20190925180931.GG31852@linux.intel.com> <3ec328dc-2763-9da5-28d6-e28970262c58@redhat.com> <alpine.DEB.2.21.1910161142560.2046@nanos.tec.linutronix.de> <57f40083-9063-5d41-f06d-fa1ae4c78ec6@redhat.com>
 <alpine.DEB.2.21.1910161244060.2046@nanos.tec.linutronix.de> <3a12810b-1196-b70a-aa2e-9fe17dc7341a@redhat.com> <b2c42a64-eb42-1f18-f609-42eec3faef18@intel.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 16 Oct 2019, Xiaoyao Li wrote:
> On 10/16/2019 7:58 PM, Paolo Bonzini wrote:
> > > With your proposal you render #AC useless even on hosts which have SMT
> > > disabled, which is just wrong. There are enough good reasons to disable
> > > SMT.
> > 
> > My lazy "solution" only applies to SMT enabled.  When SMT is either not
> > supported, or disabled as in "nosmt=force", we can virtualize it like
> > the posted patches have done so far.
> > 
> 
> Do we really need to divide it into two cases of SMT enabled and SMT disabled?

Yes. See the matrix I just sent.

> > > I agree that with SMT enabled the situation is truly bad, but we surely
> > > can
> > > be smarter than just disabling it globally unconditionally and forever.
> > > 
> > > Plus we want a knob which treats guests triggering #AC in the same way as
> > > we treat user space, i.e. kill them with SIGBUS.
> > 
> > Yes, that's a valid alternative.  But if SMT is possible, I think the
> > only sane possibilities are global disable and SIGBUS.  SIGBUS (or
> > better, a new KVM_RUN exit code) can be acceptable for debugging guests too.
> 
> If SIGBUS, why need to globally disable?

See the matrix I just sent.

> When there is an #AC due to split-lock in guest, KVM only has below two
> choices:
> 1) inject back into guest.
>    - If kvm advertise this feature to guest, and guest kernel is latest, and
> guest kernel must enable it too. It's the happy case that guest can handler it
> on its own purpose.
>    - Any other cases, guest get an unexpected #AC and crash.

That's just wrong for obvious reasons.

> 2) report to userspace (I think the same like a SIGBUS)

No. What guarantees that userspace qemu handles the SIGBUS sanely?

> So for simplicity, we can do what Paolo suggested that don't advertise this
> feature and report #AC to userspace when an #AC due to split-lock in guest
> *but* we never disable the host's split-lock detection due to guest's
> split-lock.

No, you can't.

Guess what happens when you just boot some existing guest on a #AC enabled
host without having updated qemu to handle the exit code/SIGBUS.

It simply will crash and burn in nonsensical ways. Same as reinjecting it
into the guest and letting it crash.

Thanks,

	tglx


