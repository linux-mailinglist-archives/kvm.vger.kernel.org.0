Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECB5B10C135
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 02:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727516AbfK1BAC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 20:00:02 -0500
Received: from mga04.intel.com ([192.55.52.120]:27181 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726984AbfK1BAC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 20:00:02 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Nov 2019 17:00:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,251,1571727600"; 
   d="scan'208";a="199361861"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 27 Nov 2019 17:00:01 -0800
Date:   Wed, 27 Nov 2019 17:00:01 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Leonardo Bras <leonardo@linux.ibm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: Add separate helper for putting borrowed reference
 to kvm
Message-ID: <20191128010001.GJ22227@linux.intel.com>
References: <de313d549a5ae773aad6bbf04c20b395bea7811f.camel@linux.ibm.com>
 <20191126171416.GA22233@linux.intel.com>
 <0009c6c1bb635098fa68cb6db6414634555039fe.camel@linux.ibm.com>
 <e1a4218f-2a70-3de3-1403-dbebf8a8abdf@redhat.com>
 <bfa563e6a584bd85d3abe953ca088281dc0e167b.camel@linux.ibm.com>
 <6beeff56-7676-5dfd-a578-1732730f8963@redhat.com>
 <adcfe1b4c5b36b3c398a5d456da9543e0390cba3.camel@linux.ibm.com>
 <20191127194757.GI22227@linux.intel.com>
 <103b290917221baa10194c27c8e35b9803f3cafa.camel@linux.ibm.com>
 <41fe3962ce1f1d5f61db5f5c28584f68ad66b2b1.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41fe3962ce1f1d5f61db5f5c28584f68ad66b2b1.camel@linux.ibm.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 27, 2019 at 06:57:10PM -0300, Leonardo Bras wrote:
> On Wed, 2019-11-27 at 17:15 -0300, Leonardo Bras wrote:
> > > > > > So, suppose these threads, where:
> > > > > > - T1 uses a borrowed reference, and 
> > > > > > - T2 is releasing the reference (close, release):
> > > > > 
> > > > > Nit: T2 is releasing the *last* reference (as implied by your reference
> > > > > to close/release).
> > > > 
> > > > Correct.
> > > > 
> > > > > > T1                              | T2
> > > > > > kvm_get_kvm()                   |
> > > > > > ...                             | kvm_put_kvm()
> > > > > > kvm_put_kvm_no_destroy()        |
> > > > > > 
> > > > > > The above would not trigger a use-after-free bug, but will cause a
> > > > > > memory leak. Is my above understanding right?
> > > > > 
> > > > > Yes, this is correct.
> > > > > 
> > > > 
> > > > Then, what would not be a bug before (using kvm_put_kvm()) now is a
> > > > memory leak (using kvm_put_kvm_no_destroy()).
> > > 
> 
> Sorry, I missed some information on above example. 
> Suppose on that example that the reorder changes take place so that
> kvm_put_kvm{,_no_destroy}() always happens after the last usage of kvm
> (in the same syscall, let's say).

That can't happen, because the ioctl() holds a reference to KVM via its
file descriptor for /dev/kvm, and ioctl() in turn prevents the fd from
being closed.

> Before T1 and T2, refcount = 1;

This is what's impossible.  T1 must have an existing reference to get
into the ioctl(), and that reference cannot be dropped until the ioctl()
completes (and by completes I mean returns to userspace). Assuming no
other bugs, i.e. T2 has its own reference, then refcount >= 2.

> If T1 uses kvm_put_kvm_no_destroy():
> - T1 increases refcount (=2)
> - T2 decreases refcount (=1)
> - T1 decreases refcount, (=0) don't free kvm (memleak)
> 
> If T1 uses kvm_put_kvm():
> - T1 increases refcount (= 2)
> - T2 decreases refcount (= 1)
> - T1 decreases refcount, (= 0) frees kvm.
> 
> So using kvm_put_kvm_no_destroy() would introduce a memleak where it
> would have no bug.
> 
> > > No, using kvm_put_kvm_no_destroy() changes how a bug would manifest, as
> > > you note below.  Replacing kvm_put_kvm() with kvm_put_kvm_no_destroy()
> > > when the refcount is _guaranteed_ to be >1 has no impact on correctness.
> 
> Yes, you are correct. 
> But on the above case, kvm_put_kvm{,_no_destroy}() would be called
> with refcount == 1, and if reorder patch is applied, it would not cause
> any use-after-free error, even on kvm_put_kvm() case.
> 
> Is the above correct?

No, see above.
