Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED64BD961C
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 17:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393052AbfJPP7n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 11:59:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:36652 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729646AbfJPP7n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 11:59:43 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Oct 2019 08:59:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,304,1566889200"; 
   d="scan'208";a="198994082"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 16 Oct 2019 08:59:42 -0700
Date:   Wed, 16 Oct 2019 08:59:42 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, H Peter Anvin <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
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
Message-ID: <20191016155942.GB5866@linux.intel.com>
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com>
 <1560897679-228028-10-git-send-email-fenghua.yu@intel.com>
 <alpine.DEB.2.21.1906262209590.32342@nanos.tec.linutronix.de>
 <20190626203637.GC245468@romley-ivt3.sc.intel.com>
 <alpine.DEB.2.21.1906262338220.32342@nanos.tec.linutronix.de>
 <20190925180931.GG31852@linux.intel.com>
 <alpine.DEB.2.21.1910161038210.2046@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1910161038210.2046@nanos.tec.linutronix.de>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 16, 2019 at 11:29:00AM +0200, Thomas Gleixner wrote:
> >   - Modify the #AC handler to test/set the same atomic variable as the
> >     sysfs knob.  This is the "disabled by kernel" flow.
> 
> That's the #AC in kernel handler, right?

Yes.

> >   - Modify the debugfs/sysfs knob to only allow disabling split-lock
> >     detection.  This is the "disabled globally" path, i.e. sends IPIs to
> >     clear MSR_TEST_CTRL.split_lock on all online CPUs.
> 
> Why only disable? What's wrong with reenabling it? The shiny new driver you
> are working on is triggering #AC. So in order to test the fix, you need to
> reboot the machine instead of just unloading the module, reenabling #AC and
> then loading the fixed one?

A re-enabling path adds complexity (though not much) and is undesirable
for a production environment as a split-lock issue in the kernel isn't
going to magically disappear.  And I thought that disable-only was also
your preferred implementation based on a previous comment[*], but that
comment may have been purely in the scope of userspace applications.

Anyways, my personal preference would be to keep things simple and not
support a re-enabling path.  But then again, I do 99.9% of my development
in VMs so my vote probably shouldn't count regarding the module issue.

[*] https://lkml.kernel.org/r/alpine.DEB.2.21.1904180832290.3174@nanos.tec.linutronix.de

> >   - Modify the resume/init flow to clear MSR_TEST_CTRL.split_lock if it's
> >     been disabled on *any* CPU via #AC or via the knob.
> 
> Fine.
> 
> >   - Remove KVM loading of MSR_TEST_CTRL, i.e. KVM *never* writes the CPU's
> >     actual MSR_TEST_CTRL.  KVM still emulates MSR_TEST_CTRL so that the
> >     guest can do WRMSR and handle its own #AC faults, but KVM doesn't
> >     change the value in hardware.
> > 
> >       * Allowing guest to enable split-lock detection can induce #AC on
> >         the host after it has been explicitly turned off, e.g. the sibling
> >         hyperthread hits an #AC in the host kernel, or worse, causes a
> >         different process in the host to SIGBUS.
> >
> >       * Allowing guest to disable split-lock detection opens up the host
> >         to DoS attacks.
> 
> Wasn't this discussed before and agreed on that if the host has AC enabled
> that the guest should not be able to force disable it? I surely lost track
> of this completely so my memory might trick me.

Yes, I was restating that point, or at least attempting to.
 
> The real question is what you do when the host has #AC enabled and the
> guest 'disabled' it and triggers #AC. Is that going to be silently ignored
> or is the intention to kill the guest in the same way as we kill userspace?
> 
> The latter would be the right thing, but given the fact that the current
> kernels easily trigger #AC today, that would cause a major wreckage in
> hosting scenarios. So I fear we need to bite the bullet and have a knob
> which defaults to 'handle silently' and allows to enable the kill mechanics
> on purpose. 'Handle silently' needs some logging of course, at least a per
> guest counter which can be queried and a tracepoint.
