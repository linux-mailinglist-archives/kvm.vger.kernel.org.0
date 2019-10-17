Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5F5DB914
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2019 23:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441541AbfJQVbn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Oct 2019 17:31:43 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:54518 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441534AbfJQVbm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Oct 2019 17:31:42 -0400
Received: from p5b06da22.dip0.t-ipconnect.de ([91.6.218.34] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1iLDMn-0007MJ-68; Thu, 17 Oct 2019 23:31:29 +0200
Date:   Thu, 17 Oct 2019 23:31:15 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
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
Subject: Re: [RFD] x86/split_lock: Request to Intel
In-Reply-To: <20191017172312.GC20903@linux.intel.com>
Message-ID: <alpine.DEB.2.21.1910172207010.1869@nanos.tec.linutronix.de>
References: <20190925180931.GG31852@linux.intel.com> <3ec328dc-2763-9da5-28d6-e28970262c58@redhat.com> <alpine.DEB.2.21.1910161142560.2046@nanos.tec.linutronix.de> <57f40083-9063-5d41-f06d-fa1ae4c78ec6@redhat.com> <c3ff2fb3-4380-fb07-1fa3-15896a09e748@intel.com>
 <d30652bb-89fa-671a-5691-e2c76af231d0@redhat.com> <8808c9ac-0906-5eec-a31f-27cbec778f9c@intel.com> <alpine.DEB.2.21.1910161519260.2046@nanos.tec.linutronix.de> <ba2c0aab-1d7c-5cfd-0054-ac2c266c1df3@redhat.com> <alpine.DEB.2.21.1910171322530.1824@nanos.tec.linutronix.de>
 <20191017172312.GC20903@linux.intel.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 17 Oct 2019, Sean Christopherson wrote:
> On Thu, Oct 17, 2019 at 02:29:45PM +0200, Thomas Gleixner wrote:
> > The more I look at this trainwreck, the less interested I am in merging any
> > of this at all.
> > 
> > The fact that it took Intel more than a year to figure out that the MSR is
> > per core and not per thread is yet another proof that this industry just
> > works by pure chance.
> > 
> > There is a simple way out of this misery:
> > 
> >   Intel issues a microcode update which does:
> > 
> >     1) Convert the OR logic of the AC enable bit in the TEST_CTRL MSR to
> >        AND logic, i.e. when one thread disables AC it's automatically
> >        disabled on the core.
> > 
> >        Alternatively it supresses the #AC when the current thread has it
> >        disabled.
> > 
> >     2) Provide a separate bit which indicates that the AC enable logic is
> >        actually AND based or that #AC is supressed when the current thread
> >        has it disabled.
> > 
> >     Which way I don't really care as long as it makes sense.
> 
> The #AC bit doesn't use OR-logic, it's straight up shared, i.e. writes on
> one CPU are immediately visible on its sibling CPU.

That's less horrible than I read out of your initial explanation.

Thankfully all of this is meticulously documented in the SDM ...

Though it changes the picture radically. The truly shared MSR allows
regular software synchronization without IPIs and without an insane amount
of corner case handling.

So as you pointed out we need a per core state, which is influenced by:

 1) The global enablement switch

 2) Host induced #AC

 3) Guest induced #AC

    A) Guest has #AC handling

    B) Guest has no #AC handling

#1:

   - OFF: #AC is globally disabled

   - ON:  #AC is globally enabled

   - FORCE: same as ON but #AC is enforced on guests

#2:

   If the host triggers an #AC then the #AC has to be force disabled on the
   affected core independent of the state of #1. Nothing we can do about
   that and once the initial wave of #AC issues is fixed this should not
   happen on production systems. That disables #3 even for the #3.A case
   for simplicity sake.

#3:

   A) Guest has #AC handling
    
      #AC is forwarded to the guest. No further action required aside of
      accounting

   B) Guest has no #AC handling

      If #AC triggers the resulting action depends on the state of #1:

      	 - FORCE: Guest is killed with SIGBUS or whatever the virt crowd
	   	  thinks is the appropriate solution

         - ON: #AC triggered state is recorded per vCPU and the MSR is
	   	toggled on VMENTER/VMEXIT in software from that point on.

So the only interesting case is #3.B and #1.state == ON. There you need
serialization of the state and the MSR write between the cores, but only
when the vCPU triggered an #AC. Until then, nothing to do.

vmenter()
{
	if (vcpu->ac_disable)
		this_core_disable_ac();
}

vmexit()
{
	if (vcpu->ac_disable) {
		this_core_enable_ac();
}

this_core_dis/enable_ac() takes the global state into account and has the
necessary serialization in place.

Thanks,

	tglx
