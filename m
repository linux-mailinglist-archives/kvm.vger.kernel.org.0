Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4EC2EC670
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 23:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbhAFW7Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 17:59:25 -0500
Received: from mga18.intel.com ([134.134.136.126]:38024 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726371AbhAFW7Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 17:59:25 -0500
IronPort-SDR: t/mLkB9S6FzBFJ4k5xb4NUOjromO0K4iwspl3k4Oq5CrhkbwPfTZM4/DYrLdoIdqKZRjxjoDUz
 Km30a7D/A/7g==
X-IronPort-AV: E=McAfee;i="6000,8403,9856"; a="165044821"
X-IronPort-AV: E=Sophos;i="5.79,328,1602572400"; 
   d="scan'208";a="165044821"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 14:58:44 -0800
IronPort-SDR: IusFO7RdEcRgkXbiUXRFSUyW0kAxwjbz3znxvh7G1dg5pA+c2mLbX4oMRkz8ixm0za/GjNIZuF
 yC4RhfrP2Mqw==
X-IronPort-AV: E=Sophos;i="5.79,328,1602572400"; 
   d="scan'208";a="462828307"
Received: from vastrong-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.230.243])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 14:58:41 -0800
Date:   Thu, 7 Jan 2021 11:58:39 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        <linux-sgx@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>, <jarkko@kernel.org>, <luto@kernel.org>,
        <haitao.huang@intel.com>, <pbonzini@redhat.com>, <bp@alien8.de>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>
Subject: Re: [RFC PATCH 11/23] x86/sgx: Add helpers to expose ECREATE and
 EINIT to KVM
Message-Id: <20210107115839.0767102e8186e9bc89fa0a61@intel.com>
In-Reply-To: <7df437ee-e1f3-440c-377b-dbe39820fd44@intel.com>
References: <cover.1609890536.git.kai.huang@intel.com>
        <6b29d1ee66715b40aba847b31cbdac71cbb22524.1609890536.git.kai.huang@intel.com>
        <863820fc-f0d2-6be6-52db-ab3eefe36f64@intel.com>
        <X/Yl9UTLhYHg6AVi@google.com>
        <7df437ee-e1f3-440c-377b-dbe39820fd44@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 6 Jan 2021 13:23:37 -0800 Dave Hansen wrote:
> On 1/6/21 1:04 PM, Sean Christopherson wrote:
> > On Wed, Jan 06, 2021, Dave Hansen wrote:
> >> On 1/5/21 5:56 PM, Kai Huang wrote:
> >>> From: Sean Christopherson <sean.j.christopherson@intel.com>
> >>>
> >>> Provide wrappers around __ecreate() and __einit() to hide the ugliness
> >>> of overloading the ENCLS return value to encode multiple error formats
> >>> in a single int.  KVM will trap-and-execute ECREATE and EINIT as part
> >>> of SGX virtualization, and on an exception, KVM needs the trapnr so that
> >>> it can inject the correct fault into the guest.
> >>
> >> This is missing a bit of a step about how and why ECREATE needs to be
> >> run in the host in the first place.
> > 
> > There's (hopefully) good info in the KVM usage patch that can be borrowed:
> > 
> >   Add an ECREATE handler that will be used to intercept ECREATE for the
> >   purpose of enforcing and enclave's MISCSELECT, ATTRIBUTES and XFRM, i.e.
> >   to allow userspace to restrict SGX features via CPUID.  ECREATE will be
> >   intercepted when any of the aforementioned masks diverges from hardware
> >   in order to enforce the desired CPUID model, i.e. inject #GP if the
> >   guest attempts to set a bit that hasn't been enumerated as allowed-1 in
> >   CPUID.
> 
> OK, so in plain language: the bare-metal kernel must intercept ECREATE
> to be able to impose policies on guests.  When it does this, the
> bare-metal kernel runs ECREATE against the userspace mapping of the
> virtualized EPC.

Thanks. I'll add this to commit message.

> 
> >>> diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
> >>> new file mode 100644
> >>> index 000000000000..0d643b985085
> >>> --- /dev/null
> >>> +++ b/arch/x86/include/asm/sgx.h
> >>> @@ -0,0 +1,16 @@
> >>> +/* SPDX-License-Identifier: GPL-2.0 */
> >>> +#ifndef _ASM_X86_SGX_H
> >>> +#define _ASM_X86_SGX_H
> >>> +
> >>> +#include <linux/types.h>
> >>> +
> >>> +#ifdef CONFIG_X86_SGX_VIRTUALIZATION
> >>> +struct sgx_pageinfo;
> >>> +
> >>> +int sgx_virt_ecreate(struct sgx_pageinfo *pageinfo, void __user *secs,
> >>> +		     int *trapnr);
> >>> +int sgx_virt_einit(void __user *sigstruct, void __user *token,
> >>> +		   void __user *secs, u64 *lepubkeyhash, int *trapnr);
> >>> +#endif
> >>> +
> >>> +#endif /* _ASM_X86_SGX_H */
> >>> diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
> >>> index d625551ccf25..4e9810ba9259 100644
> >>> --- a/arch/x86/kernel/cpu/sgx/virt.c
> >>> +++ b/arch/x86/kernel/cpu/sgx/virt.c
> >>> @@ -261,3 +261,58 @@ int __init sgx_virt_epc_init(void)
> >>>  
> >>>  	return misc_register(&sgx_virt_epc_dev);
> >>>  }
> >>> +
> >>> +int sgx_virt_ecreate(struct sgx_pageinfo *pageinfo, void __user *secs,
> >>> +		     int *trapnr)
> >>> +{
> >>> +	int ret;
> >>> +
> >>> +	__uaccess_begin();
> >>> +	ret = __ecreate(pageinfo, (void *)secs);
> >>> +	__uaccess_end();
> >>
> >> The __uaccess_begin/end() worries me.  There are *very* few of these in
> >> the kernel and it seems like something we want to use as sparingly as
> >> possible.
> >>
> >> Why don't we just use the kernel mapping for 'secs' and not have to deal
> >> with stac/clac?
> > 
> > The kernel mapping isn't readily available. 
> 
> Oh, duh.  There's no kernel mapping for EPC... it's not RAM in the first
> place.
> 
> > At this point, it's not even
> > guaranteed that @secs points at an EPC page.  Unlike the driver code, where the
> > EPC page is allocated on-demand by the kernel, the pointer here is userspace
> > (technically guest) controlled.  The caller (KVM) is responsible for ensuring
> > it's a valid userspace address, but the SGX/EPC specific checks are mostly
> > deferred to hardware.
> 
> Ahh, got it.  Kai, could we get some of this into comments or the changelog?

Yes I'll add some into comments.
