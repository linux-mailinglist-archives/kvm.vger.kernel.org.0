Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA09010B6FF
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 20:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbfK0Tr7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 14:47:59 -0500
Received: from mga02.intel.com ([134.134.136.20]:54359 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbfK0Tr6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 14:47:58 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Nov 2019 11:47:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,250,1571727600"; 
   d="scan'208";a="206984788"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga007.fm.intel.com with ESMTP; 27 Nov 2019 11:47:57 -0800
Date:   Wed, 27 Nov 2019 11:47:57 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Leonardo Bras <leonardo@linux.ibm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: Add separate helper for putting borrowed reference
 to kvm
Message-ID: <20191127194757.GI22227@linux.intel.com>
References: <20191021225842.23941-1-sean.j.christopherson@intel.com>
 <de313d549a5ae773aad6bbf04c20b395bea7811f.camel@linux.ibm.com>
 <20191126171416.GA22233@linux.intel.com>
 <0009c6c1bb635098fa68cb6db6414634555039fe.camel@linux.ibm.com>
 <e1a4218f-2a70-3de3-1403-dbebf8a8abdf@redhat.com>
 <bfa563e6a584bd85d3abe953ca088281dc0e167b.camel@linux.ibm.com>
 <6beeff56-7676-5dfd-a578-1732730f8963@redhat.com>
 <adcfe1b4c5b36b3c398a5d456da9543e0390cba3.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adcfe1b4c5b36b3c398a5d456da9543e0390cba3.camel@linux.ibm.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 27, 2019 at 04:25:55PM -0300, Leonardo Bras wrote:
> On Wed, 2019-11-27 at 19:32 +0100, Paolo Bonzini wrote:
> > On 27/11/19 19:24, Leonardo Bras wrote:
> > > By what I could undestand up to now, these functions that use borrowed
> > > references can only be called while the reference (file descriptor)
> > > exists. 
> > > So, suppose these threads, where:
> > > - T1 uses a borrowed reference, and 
> > > - T2 is releasing the reference (close, release):
> > 
> > Nit: T2 is releasing the *last* reference (as implied by your reference
> > to close/release).
> 
> Correct.
> 
> > 
> > > T1				| T2
> > > kvm_get_kvm()			|
> > > ...				| kvm_put_kvm()
> > > kvm_put_kvm_no_destroy()	|
> > > 
> > > The above would not trigger a use-after-free bug, but will cause a
> > > memory leak. Is my above understanding right?
> > 
> > Yes, this is correct.
> > 
> 
> Then, what would not be a bug before (using kvm_put_kvm()) now is a
> memory leak (using kvm_put_kvm_no_destroy()).

No, using kvm_put_kvm_no_destroy() changes how a bug would manifest, as
you note below.  Replacing kvm_put_kvm() with kvm_put_kvm_no_destroy()
when the refcount is _guaranteed_ to be >1 has no impact on correctness.

> And it's the price to avoid use-after-free on other cases, which is a
> worse bug. Ok, I get it. 
> 
> > Paolo
> 
> On Tue, 2019-11-26 at 10:14 -0800, Sean Christopherson wrote:
> > If one these kvm_put_kvm() calls did unexpectedly free @kvm (due to 
> > a bug somewhere else), KVM would still hit a use-after-free scenario 
> > as the caller still thinks @kvm is valid.  Currently, this would 
> > only happen on a subsequent ioctl() on the caller's file descriptor
> > (which holds a pointer to @kvm), as the callers of these functions
> > don't directly dereference @kvm after the functions return.  But, 
> > not deferencing @kvm isn't deliberate or functionally required, it's
> > just how the code happens to be written.
> 
> So, testing if the kvm reference is valid before running ioctl would be
> enough to avoid these bugs?

No, the only way to avoid use-after-free bugs of this nature is to not
screw up the refcounting :-)  This funky "borrowed reference" pattern is
not very common.  It's necessary here because KVM needs to take an extra
reference to itself on behalf of the child device before installing the
child's file descriptor, because once the fd is installed it can be
closed by userspace and free the child's reference.  The error path,
which uses kvm_put_kvm_no_destroy(), is used if and only if installing
the fd fails, in which case the extra reference is deliberately thrown
away.

kvm_put_kvm_no_destroy() is asserting "N > 0" as a way to detect a
refcounting bug that wouldn't be detected (until later) by the normal
refcounting behavior, which asserts "N >= 0".

> Is it possible? 

No.  Similar to above, userspace gets a fd by doing open("/dev/kvm"), and
the semantics of KVM are such that each fd is a reference to KVM. From
userspace's perspective, having a valid fd *is* how it knows that it has
a valid KVM reference.

> Humm, but if it frees kvm before running ->release(), would it mean the
> VM is destroyed incorrectly, and will probably crash?

More than likely the host will crash due to corrupting memory.  The guest
will crash too, but that's a secondary concern.
