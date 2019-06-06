Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE353778C
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 17:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729077AbfFFPOV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 11:14:21 -0400
Received: from mga05.intel.com ([192.55.52.43]:11711 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728812AbfFFPOV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 11:14:21 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 08:14:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,559,1557212400"; 
   d="scan'208";a="182339995"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga002.fm.intel.com with ESMTP; 06 Jun 2019 08:14:20 -0700
Date:   Thu, 6 Jun 2019 08:14:20 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 5/5] KVM: VMX: Handle NMIs, #MCs and async #PFs in common
 irqs-disabled fn
Message-ID: <20190606151420.GB23169@linux.intel.com>
References: <20190420055059.16816-1-sean.j.christopherson@intel.com>
 <20190420055059.16816-6-sean.j.christopherson@intel.com>
 <746c7e2c-176f-d772-e37d-41bb9f524dd6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <746c7e2c-176f-d772-e37d-41bb9f524dd6@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 06, 2019 at 03:20:49PM +0200, Paolo Bonzini wrote:
> On 20/04/19 07:50, Sean Christopherson wrote:
> > Per commit 1b6269db3f833 ("KVM: VMX: Handle NMIs before enabling
> > interrupts and preemption"), NMIs are handled directly in vmx_vcpu_run()
> > to "make sure we handle NMI on the current cpu, and that we don't
> > service maskable interrupts before non-maskable ones".  The other
> > exceptions handled by complete_atomic_exit(), e.g. async #PF and #MC,
> > have similar requirements, and are located there to avoid extra VMREADs
> > since VMX bins hardware exceptions and NMIs into a single exit reason.
> > 
> > Clean up the code and eliminate the vaguely named complete_atomic_exit()
> > by moving the interrupts-disabled exception and NMI handling into the
> > existing handle_external_intrs() callback, and rename the callback to
> > a more appropriate name.
> > 
> > In addition to improving code readability, this also ensures the NMI
> > handler is run with the host's debug registers loaded in the unlikely
> > event that the user is debugging NMIs.  Accuracy of the last_guest_tsc
> > field is also improved when handling NMIs (and #MCs) as the handler
> > will run after updating said field.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Very nice, just some changes I'd like to propose. "atomic" is Linux 
> lingo for "irqs disabled", so I'd like to rename the handler to 

The code disagrees, e.g.

  /*
   * Are we running in atomic context?  WARNING: this macro cannot
   * always detect atomic context; in particular, it cannot know about
   * held spinlocks in non-preemptible kernels.  Thus it should not be
   * used in the general case to determine whether sleeping is possible.
   * Do not use in_atomic() in driver code.
   */
  #define in_atomic()	(preempt_count() != 0)

and

  void ___might_sleep(...)
  {
	...

	printk(KERN_ERR
		"in_atomic(): %d, irqs_disabled(): %d, pid: %d, name: %s\n",
			in_atomic(), irqs_disabled(),
			current->pid, current->comm);
  }

and

  static inline void *kmap_atomic(struct page *page)
  {
	preempt_disable();
	pagefault_disable();
	return page_address(page);
  }

My interpretation of things is that the kernel's definition of an atomic
context is with respect to preemption.  Disabling IRQs would also provide
atomicity, but the reverse is not true, i.e. entering an atomic context
does not imply IRQs are disabled.

As it pertains to KVM, we specifically care about IRQs being disabled,
e.g. VMX needs to ensure #MC and NMI are handled before any pending IRQs,
and both VMX and SVM need to ensure a pending perf interrupt is handled
in the callback.

And if "atomic" is interpreted as "IRQs disabled", one could argue that
the SVM behavior is buggy since enabling IRQs would break atomicity.

> handle_exit_atomic so it has a correspondance with handle_exit.  
> Likewise we could have handle_exception_nmi_atomic and 
> handle_external_interrupt_atomic.
