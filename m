Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A182283EFB
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 20:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729141AbgJESsn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 14:48:43 -0400
Received: from mga04.intel.com ([192.55.52.120]:6073 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbgJESsm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Oct 2020 14:48:42 -0400
IronPort-SDR: 7zcPUNdQjXrXvJPuSiRRSbLjR0qMtGvOzFRAv8upB209E2ULv30Zwpy433O2nK3gcjPX23Nmzt
 AMU5wCDafiMQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9765"; a="161223978"
X-IronPort-AV: E=Sophos;i="5.77,340,1596524400"; 
   d="scan'208";a="161223978"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 11:48:36 -0700
IronPort-SDR: pwdHY0+Clex6uhiQvof1tlh+ZaTorD5tBhzBp13QuXfmQhYbhxrk1rlflHdcUNlRaW+BpzA2ca
 mig0mG0rW8rw==
X-IronPort-AV: E=Sophos;i="5.77,340,1596524400"; 
   d="scan'208";a="516318049"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 09:37:48 -0700
Date:   Mon, 5 Oct 2020 09:37:44 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: filter guest NX capability for cpuid2
Message-ID: <20201005163743.GE11938@linux.intel.com>
References: <20201005145921.84848-1-tianjia.zhang@linux.alibaba.com>
 <87ft6s8zdg.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ft6s8zdg.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 05, 2020 at 05:29:47PM +0200, Vitaly Kuznetsov wrote:
> Tianjia Zhang <tianjia.zhang@linux.alibaba.com> writes:
> 
> > Original KVM_SET_CPUID has removed NX on non-NX hosts as it did
> > before. but KVM_SET_CPUID2 does not. The two should be consistent.
> >
> > Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> > ---
> >  arch/x86/kvm/cpuid.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 3fd6eec202d7..3e7ba2b11acb 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -257,6 +257,7 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
> >  		goto out;
> >  	}
> >  
> > +	cpuid_fix_nx_cap(vcpu);
> >  	kvm_update_cpuid_runtime(vcpu);
> >  	kvm_vcpu_after_set_cpuid(vcpu);
> >  out:
> 
> I stumbled upon this too and came to the conclusion this is
> intentional, e.g. see this:
> 
> commit 0771671749b59a507b6da4efb931c44d9691e248
> Author: Dan Kenigsberg <danken@qumranet.com>
> Date:   Wed Nov 21 17:10:04 2007 +0200
> 
>     KVM: Enhance guest cpuid management
> 
> ...
> 
>     [avi: fix original KVM_SET_CPUID not removing nx on non-nx hosts as it did
>           before]
> 
> but this is a very, very old story.

Doesn't mean it's bogus though :-)  _If_ we want to extend this behavior to
KVM_SET_CPUID2, there should be a justified need.
