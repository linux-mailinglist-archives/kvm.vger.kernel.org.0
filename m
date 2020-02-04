Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6762915159D
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 07:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgBDGDz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 01:03:55 -0500
Received: from mga05.intel.com ([192.55.52.43]:33401 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbgBDGDy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 01:03:54 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Feb 2020 22:03:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,398,1574150400"; 
   d="scan'208";a="235019745"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 03 Feb 2020 22:03:53 -0800
Date:   Mon, 3 Feb 2020 22:03:53 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM: VMX: Extend VMX's #AC handding
Message-ID: <20200204060353.GB31665@linux.intel.com>
References: <b2e2310d-2228-45c2-8174-048e18a46bb6@intel.com>
 <A2622E15-756D-434D-AF64-4F67781C0A74@amacapital.net>
 <0fe84cd6-dac0-2241-59e5-84cb83b7c42b@intel.com>
 <CALCETrXVNBhBCpcQaxxtc9zK3W9_NnM2_ttjj-A=oa6drsSp+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrXVNBhBCpcQaxxtc9zK3W9_NnM2_ttjj-A=oa6drsSp+w@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 03, 2020 at 10:49:50AM -0800, Andy Lutomirski wrote:
> On Sat, Feb 1, 2020 at 8:33 PM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> >
> > On 2/2/2020 1:56 AM, Andy Lutomirski wrote:
> > >
> > >
> > > There are two independent problems here.  First, SLD *can’t* be
> > > virtualized sanely because it’s per-core not per-thread.
> >
> > Sadly, it's the fact we cannot change. So it's better virtualized only when
> > SMT is disabled to make thing simple.
> >
> > > Second, most users *won’t want* to virtualize it correctly even if they
> > > could: if a guest is allowed to do split locks, it can DoS the system.
> >
> > To avoid DoS attack, it must use sld_fatal mode. In this case, guest are
> > forbidden to do split locks.
> >
> > > So I think there should be an architectural way to tell a guest that SLD
> > > is on whether it likes it or not. And the guest, if booted with sld=warn,
> > > can print a message saying “haha, actually SLD is fatal” and carry on.

Ya, but to make it architectural it needs to be actual hardware behavior.
I highly doubt we can get explicit documentation in the SDM regarding the
behavior of a hypervisor.  E.g. the "official" hypervisor CPUID bit and
CPUID range is documented in the SDM as simply being reserved until the
end of time.  Getting a bit reserved in the SDM does us no good as VMM
handling of the bit would still be determined by convention.

But, getting something in the SDM would serve our purposes, even if it's
too late to get it implemented for the first CPUs that support SLD.  It
would, in theory, require kernels to be prepared to handle a sticky SLD
bit and define a common way for VMMs to virtualize the behavior.

A sticky/lock bit in the MSR is probably the easiest to implement in
ucode?  That'd be easy for KVM to emulate, and then the kernel init code
would look something like:

static void split_lock_init(void)
{
        u64 test_ctrl_val;

        if (rdmsrl_safe(MSR_TEST_CTRL, &test_ctrl_val)) {
		sld_state = sld_off;
                return;
	}

        if (sld_state != sld_fatal &&
            (test_ctrl_val & MSR_TEST_CTRL_LOCK_DETECT) &&
            (test_ctrl_val & MSR_TEST_CTRL_LOCK_DETECT_STICKY)) {
		pr_crit("haha, actually SLD is fatal\n");
                sld_state = std_fatal;
                return;
        }

	...
}

> > OK. Let me sort it out.
> >
> > If SMT is disabled/unsupported, so KVM advertises SLD feature to guest.
> > below are all the case:
> >
> > -----------------------------------------------------------------------
> > Host    Guest   Guest behavior
> > -----------------------------------------------------------------------
> > 1. off          same as in bare metal
> > -----------------------------------------------------------------------
> > 2. warn off     allow guest do split lock (for old guest):
> >                 hardware bit set initially, once split lock
> >                 happens, clear hardware bit when vcpu is running
> >                 So, it's the same as in bare metal
> >
> > 3.      warn    1. user space: get #AC, then clear MSR bit, but
> >                    hardware bit is not cleared, #AC again, finally
> >                    clear hardware bit when vcpu is running.
> >                    So it's somehow the same as in bare-metal
> 
> Well, kind of, except that the warning is inaccurate -- there is no
> guarantee that the hardware bit will be set at all when the guest is
> running.  This doesn't sound *that* bad, but it does mean that the
> guest doesn't get the degree of DoS protection it thinks it's getting.
> 
> My inclination is that, the host mode is warn, then SLD should not be
> exposed to the guest at all and the host should fully handle it.

KVM can expose it to the guest.  KVM just needs to ensure SLD is turned
on prior to VM-Enter with vcpu->msr_test_ctrl.sld=1, which is easy enough.

> >                 2. kernel: same as in bare metal.
> >
> > 4.      fatal   same as in bare metal
> > ----------------------------------------------------------------------
> > 5.fatal off     guest is killed when split lock,
> >                 or forward #AC to guest, this way guest gets an
> >                 unexpected #AC
> 
> Killing the guest seems like the right choice.  But see below -- this
> is not ideal if the guest is new.
> 
> >
> > 6.      warn    1. user space: get #AC, then clear MSR bit, but
> >                    hardware bit is not cleared, #AC again,
> >                    finally guest is killed, or KVM forwards #AC
> >                    to guest then guest gets an unexpected #AC.
> >                 2. kernel: same as in bare metal, call die();
> >
> > 7.      fatal   same as in bare metal
> > ----------------------------------------------------------------------
> >
> > Based on the table above, if we want guest has same behavior as in bare
> > metal, we can set host to sld_warn mode.
> 
> I don't think this is correct.  If the host is in warn mode, then the
> guest behavior will be erratic.  I'm not sure it makes sense for KVM
> to expose such erratic behavior to the guest.

It's doable without introducing non-architectural behavior and without too
much pain on KVM's end.

https://lkml.kernel.org/r/20200204053552.GA31665@linux.intel.com

> > If we want prevent DoS from guest, we should set host to sld_fatal mode.
> >
> >
> > Now, let's analysis what if there is an architectural way to tell a
> > guest that SLD is forced on. Assume it's a SLD_forced_on cpuid bit.
> >
> > - Host is sld_off, SLD_forced_on cpuid bit is not set, no change for
> >    case #1
