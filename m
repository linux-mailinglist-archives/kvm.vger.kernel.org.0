Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3242EC766
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 01:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbhAGAso (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 19:48:44 -0500
Received: from mga06.intel.com ([134.134.136.31]:4505 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbhAGAsn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 19:48:43 -0500
IronPort-SDR: m0zW+EqcDhplMwVBxQyb3jga75n9i52Pltw9kZIVCsOubGkjbKKp097xE4x/lHQLTCG9swxynp
 G0c2ltsbsksA==
X-IronPort-AV: E=McAfee;i="6000,8403,9856"; a="238903452"
X-IronPort-AV: E=Sophos;i="5.79,328,1602572400"; 
   d="scan'208";a="238903452"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 16:48:03 -0800
IronPort-SDR: mhCI1uAfnQQJGCV9dUPkVWE68a4BVR4lT0HS/KDddX7iWBWMu0wY5GOwQvAUvRiuKT1EVjdzkl
 t1xvcwtuxsoA==
X-IronPort-AV: E=Sophos;i="5.79,328,1602572400"; 
   d="scan'208";a="379493301"
Received: from naljabex-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.117.182])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 16:48:00 -0800
Date:   Thu, 7 Jan 2021 13:47:58 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, jarkko@kernel.org,
        luto@kernel.org, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH 03/23] x86/sgx: Introduce virtual EPC for use by KVM
 guests
Message-Id: <20210107134758.ba0b5d950282973eaefe1ded@intel.com>
In-Reply-To: <X/YfE28guNBxcpui@google.com>
References: <cover.1609890536.git.kai.huang@intel.com>
        <ace9d4cb10318370f6145aaced0cfa73dda36477.1609890536.git.kai.huang@intel.com>
        <2e424ff3-51cb-d6ed-6c5f-190e1d4fe21a@intel.com>
        <X/YfE28guNBxcpui@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> > > +static struct mutex virt_epc_lock;
> > > +static struct list_head virt_epc_zombie_pages;
> > 
> > What does the lock protect?
> 
> Effectively, the list of zombie SECS pages.  Not sure why I used a generic name.
> 
> > What are zombie pages?
> 
> My own terminology for SECS pages whose virtual EPC has been destroyed but can't
> be reclaimed due to them having child EPC pages in other virtual EPCs.
> 
> > BTW, if zombies are SECS-only, shouldn't that be in the name rather than
> > "epc"?
> 
> I used the virt_epc prefix/namespace to tag it as a global list.  I've no
> argument against something like zombie_secs_pages.

I'll change to zombie_secs_pages, and lock name to zombie_secs_pages_lock,
respectively.


[...]

> > > +static int sgx_virt_epc_free_page(struct sgx_epc_page *epc_page)
> > > +{
> > > +	int ret;
> > > +
> > > +	if (!epc_page)
> > > +		return 0;
> > 
> > I always worry about these.  Why is passing NULL around OK?
> 
> I suspect I did it to mimic kfree() behavior.  I don't _think_ the radix (now
> xarray) usage will ever encounter a NULL entry.

I'll remove the NULL page check.

> 
> > 
> > > +	ret = __eremove(sgx_get_epc_virt_addr(epc_page));
> > > +	if (ret) {
> > > +		/*
> > > +		 * Only SGX_CHILD_PRESENT is expected, which is because of
> > > +		 * EREMOVE-ing an SECS still with child, in which case it can
> > > +		 * be handled by EREMOVE-ing the SECS again after all pages in
> > > +		 * virtual EPC have been EREMOVE-ed. See comments in below in
> > > +		 * sgx_virt_epc_release().
> > > +		 */
> > > +		WARN_ON_ONCE(ret != SGX_CHILD_PRESENT);
> > > +		return ret;
> > > +	}
> > 
> > I find myself wondering what errors could cause the WARN_ON_ONCE() to be
> > hit.  The SDM indicates that it's only:
> > 
> > 	SGX_ENCLAVE_ACT If there are still logical processors executing
> > 			inside the enclave.
> > 
> > Should that be mentioned in the comment?
> 
> And faults, which are also spliced into the return value by the ENCLS macros.
> I do remember hitting this WARN when I broke things, though I can't remember
> whether it was a fault or the SGX_ENCLAVE_ACT scenario.  Probably the latter?

I'll add a comment saying that there should be no active logical processor
still running inside guest's enclave. We cannot handle SGX_ENCLAVE_ACT here
anyway.
