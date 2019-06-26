Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D37F7573DD
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 23:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbfFZVr4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 17:47:56 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50412 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726223AbfFZVr4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 17:47:56 -0400
Received: from p5b06daab.dip0.t-ipconnect.de ([91.6.218.171] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hgFlW-00088d-0n; Wed, 26 Jun 2019 23:47:42 +0200
Date:   Wed, 26 Jun 2019 23:47:40 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Fenghua Yu <fenghua.yu@intel.com>
cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        H Peter Anvin <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Christopherson Sean J <sean.j.christopherson@intel.com>,
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
In-Reply-To: <20190626203637.GC245468@romley-ivt3.sc.intel.com>
Message-ID: <alpine.DEB.2.21.1906262338220.32342@nanos.tec.linutronix.de>
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com> <1560897679-228028-10-git-send-email-fenghua.yu@intel.com> <alpine.DEB.2.21.1906262209590.32342@nanos.tec.linutronix.de> <20190626203637.GC245468@romley-ivt3.sc.intel.com>
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

On Wed, 26 Jun 2019, Fenghua Yu wrote:

> On Wed, Jun 26, 2019 at 10:20:05PM +0200, Thomas Gleixner wrote:
> > On Tue, 18 Jun 2019, Fenghua Yu wrote:
> > > +
> > > +static atomic_t split_lock_debug;
> > > +
> > > +void split_lock_disable(void)
> > > +{
> > > +	/* Disable split lock detection on this CPU */
> > > +	this_cpu_and(msr_test_ctl_cached, ~MSR_TEST_CTL_SPLIT_LOCK_DETECT);
> > > +	wrmsrl(MSR_TEST_CTL, this_cpu_read(msr_test_ctl_cached));
> > > +
> > > +	/*
> > > +	 * Use the atomic variable split_lock_debug to ensure only the
> > > +	 * first CPU hitting split lock issue prints one single complete
> > > +	 * warning. This also solves the race if the split-lock #AC fault
> > > +	 * is re-triggered by NMI of perf context interrupting one
> > > +	 * split-lock warning execution while the original WARN_ONCE() is
> > > +	 * executing.
> > > +	 */
> > > +	if (atomic_cmpxchg(&split_lock_debug, 0, 1) == 0) {
> > > +		WARN_ONCE(1, "split lock operation detected\n");
> > > +		atomic_set(&split_lock_debug, 0);
> > 
> > What's the purpose of this atomic_set()?
> 
> atomic_set() releases the split_lock_debug flag after WARN_ONCE() is done.
> The same split_lock_debug flag will be used in sysfs write for atomic
> operation as well, as proposed by Ingo in https://lkml.org/lkml/2019/4/25/48

Your comment above lacks any useful information about that whole thing.

> So that's why the flag needs to be cleared, right?

Errm. No.

CPU 0					CPU 1
					
hits AC					hits AC
  if (atomic_cmpxchg() == success)	  if (atomic_cmpxchg() == success)
  	warn()	       	  		     warn()

So only one of the CPUs will win the cmpxchg race, set te variable to 1 and
warn, the other and any subsequent AC on any other CPU will not warn
either. So you don't need WARN_ONCE() at all. It's redundant and confusing
along with the atomic_set().

Whithout reading that link [1], what Ingo proposed was surely not the
trainwreck which you decided to put into that debugfs thing.

Thanks,

	tglx

[1] lkml.org sucks. We have https://lkml.kernel.org/r/$MESSAGEID for
    that. That actually works.
