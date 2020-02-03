Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABC34150A6A
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 16:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728472AbgBCP7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 10:59:05 -0500
Received: from mga18.intel.com ([134.134.136.126]:34615 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727152AbgBCP7F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Feb 2020 10:59:05 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Feb 2020 07:59:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,398,1574150400"; 
   d="scan'208";a="310758284"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 03 Feb 2020 07:59:04 -0800
Date:   Mon, 3 Feb 2020 07:59:04 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 01/61] KVM: x86: Return -E2BIG when
 KVM_GET_SUPPORTED_CPUID hits max entries
Message-ID: <20200203155903.GA19638@linux.intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
 <20200201185218.24473-2-sean.j.christopherson@intel.com>
 <87mu9zomnn.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mu9zomnn.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 03, 2020 at 01:55:40PM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index b1c469446b07..47ce04762c20 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -908,9 +908,14 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
> >  			goto out_free;
> >  
> >  		limit = cpuid_entries[nent - 1].eax;
> > -		for (func = ent->func + 1; func <= limit && nent < cpuid->nent && r == 0; ++func)
> > +		for (func = ent->func + 1; func <= limit && r == 0; ++func) {
> > +			if (nent >= cpuid->nent) {
> > +				r = -E2BIG;
> > +				goto out_free;
> > +			}
> >  			r = do_cpuid_func(&cpuid_entries[nent], func,
> >  				          &nent, cpuid->nent, type);
> > +		}
> >  
> >  		if (r)
> >  			goto out_free;
> 
> Is fixing a bug a valid reason for breaking buggy userspace? :-)
> Personally, I think so.

Linus usually disagrees :-)

> In particular, here the change is both the
> return value and the fact that we don't do copy_to_user() anymore so I
> think it's possible to meet a userspace which is going to get broken by
> the change.

Ugh, yeah, it would be possible.  Qemu (retries), CrosVM (hardcoded to
256 entries) and Firecracker (doesn't use the ioctl()) are all ok,
hopefully all other VMMs used in production environments follow suit.
