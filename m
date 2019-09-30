Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 052DEC23E7
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2019 17:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731824AbfI3PEf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 11:04:35 -0400
Received: from mga05.intel.com ([192.55.52.43]:24678 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726314AbfI3PEf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 11:04:35 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Sep 2019 08:04:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,567,1559545200"; 
   d="scan'208";a="195349054"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga006.jf.intel.com with ESMTP; 30 Sep 2019 08:04:30 -0700
Date:   Mon, 30 Sep 2019 08:04:30 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reto Buerki <reet@codelabs.ch>,
        Liran Alon <liran.alon@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH v2 8/8] KVM: x86: Fold decache_cr3() into cache_reg()
Message-ID: <20190930150430.GA14693@linux.intel.com>
References: <20190927214523.3376-1-sean.j.christopherson@intel.com>
 <20190927214523.3376-9-sean.j.christopherson@intel.com>
 <87a7am3v9u.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a7am3v9u.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 30, 2019 at 12:58:53PM +0200, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > Handle caching CR3 (from VMX's VMCS) into struct kvm_vcpu via the common
> > cache_reg() callback and drop the dedicated decache_cr3().  The name
> > decache_cr3() is somewhat confusing as the caching behavior of CR3
> > follows that of GPRs, RFLAGS and PDPTRs, (handled via cache_reg()), and
> > has nothing in common with the caching behavior of CR0/CR4 (whose
> > decache_cr{0,4}_guest_bits() likely provided the 'decache' verbiage).
> >
> > Note, this effectively adds a BUG() if KVM attempts to cache CR3 on SVM.
> > Opportunistically add a WARN_ON_ONCE() in VMX to provide an equivalent
> > check.
> 
> Just to justify my idea of replacing such occasions with
> KVM_INTERNAL_ERROR by setting a special 'kill ASAP' bit somewhere:
> 
> This WARN_ON_ONCE() falls in the same category (IMO).

Maybe something like KVM_BUG_ON?  E.g.:

#define KVM_BUG_ON(kvm, cond)		\
({					\
	int r;				\
					\
	if (r = WARN_ON_ONCE(cond))	\
		kvm->vm_bugged = true;	\
	r;				\
)}
	

> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---

...

> Reviewed (and Tested-On-Amd-By:): Vitaly Kuznetsov <vkuznets@redhat.com>

Thanks for the reviews and for testing on AMD!
