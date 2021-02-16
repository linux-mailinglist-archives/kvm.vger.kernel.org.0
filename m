Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3B3331C76F
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 09:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbhBPIiQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 03:38:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:44064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229944AbhBPIgc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Feb 2021 03:36:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CED164DAF;
        Tue, 16 Feb 2021 08:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613464540;
        bh=tVT3AoqFxbTj4f/8qoqQrzOb0nYSW8gDU+ATKen7DJ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AHWDo+qNgP4wOSk5C27CNMG3Gg92OespKczTiLicz7OpoxvB3nEIsdqbQzXMwppyh
         6pWbEjdS6mUzQ97wsCzCvVxoVHmaszc4TzpuWE7nlkxZh75sJnGf0Bj5rZH8EfLFgl
         z8eCFmx82Gnv0UjwPDVtAV4rFqrFGcksHeLVcKr3rvhq9vAnn/GymfA/DIUlwFsSCY
         aJ9Z2A/tvf75qurr8DGxdmJqb8KflGTT7DhbSyol2QJ/NJnWq7k4n2tizUHJiR86Pf
         ZIjqG7okrsnBm3LWaq12VI4uxJcxwafbLWUBOA4aFPeSjZ3vT68uR0YjDtFNLuwVCN
         38GWVAKCJ4iNg==
Date:   Tue, 16 Feb 2021 10:35:27 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "seanjc@google.com" <seanjc@google.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [RFC PATCH v5 13/26] x86/sgx: Add helpers to expose ECREATE and
 EINIT to KVM
Message-ID: <YCuDz3jzQkc5j23T@kernel.org>
References: <cover.1613221549.git.kai.huang@intel.com>
 <4b8921da8e0d037b1e99d5cc92eea8f8470cf2e0.1613221549.git.kai.huang@intel.com>
 <YCs3IZ/Edv6AeIYo@kernel.org>
 <YCs3Wt+il5+pnwCV@kernel.org>
 <87b9c4bfe61545c0803f7a46b177e10e@intel.com>
 <YCuDSj3t5KlUi6b5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YCuDSj3t5KlUi6b5@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 16, 2021 at 10:33:17AM +0200, Jarkko Sakkinen wrote:
> On Tue, Feb 16, 2021 at 04:55:49AM +0000, Huang, Kai wrote:
> > > 
> > > On Tue, Feb 16, 2021 at 05:08:20AM +0200, Jarkko Sakkinen wrote:
> > > > On Sun, Feb 14, 2021 at 02:29:15AM +1300, Kai Huang wrote:
> > > > > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > > > >
> > > > > The host kernel must intercept ECREATE to be able to impose policies
> > > > > on guests.  When it does this, the host kernel runs ECREATE against
> > > > > the userspace mapping of the virtualized EPC.
> > > > >
> > > > > Provide wrappers around __ecreate() and __einit() to hide the
> > > > > ugliness of overloading the ENCLS return value to encode multiple
> > > > > error formats in a single int.  KVM will trap-and-execute ECREATE
> > > > > and EINIT as part of SGX virtualization, and on an exception, KVM
> > > > > needs the trapnr so that it can inject the correct fault into the guest.
> > > > >
> > > > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > > > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > > > > ---
> > > > > v4->v5:
> > > > >
> > > > >  - No code change.
> > > > >
> > > > > v3->v4:
> > > > >
> > > > >  - Added one new line before last return in sgx_virt_einit(), per Jarkko.
> > > > >
> > > > > v2->v3:
> > > > >
> > > > >  - Added kdoc for sgx_virt_ecreate() and sgx_virt_einit(), per Jarkko.
> > > > >  - Changed to use CONFIG_X86_SGX_KVM.
> > > > >
> > > > > ---
> > > > >  arch/x86/include/asm/sgx.h     | 16 ++++++
> > > > >  arch/x86/kernel/cpu/sgx/virt.c | 94
> > > > > ++++++++++++++++++++++++++++++++++
> > > > >  2 files changed, 110 insertions(+)
> > > > >  create mode 100644 arch/x86/include/asm/sgx.h
> > > > >
> > > > > diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
> > > > > new file mode 100644 index 000000000000..8a3ea3e1efbe
> > > > > --- /dev/null
> > > > > +++ b/arch/x86/include/asm/sgx.h
> > > > > @@ -0,0 +1,16 @@
> > > > > +/* SPDX-License-Identifier: GPL-2.0 */ #ifndef _ASM_X86_SGX_H
> > > > > +#define _ASM_X86_SGX_H
> > > > > +
> > > > > +#include <linux/types.h>
> > > > > +
> > > > > +#ifdef CONFIG_X86_SGX_KVM
> > > > > +struct sgx_pageinfo;
> > > > > +
> > > > > +int sgx_virt_ecreate(struct sgx_pageinfo *pageinfo, void __user *secs,
> > > > > +		     int *trapnr);
> > > > > +int sgx_virt_einit(void __user *sigstruct, void __user *token,
> > > > > +		   void __user *secs, u64 *lepubkeyhash, int *trapnr);
> > > >
> > > > s/virt/vepc/g
> > 
> > No. The two are related to enclave construction (from guest), not EPC. 
> > 
> > For instance, what does ECREATE mean for virtual EPC? ECREATE is meaningful for enclave.
> > 
> > > >
> > > > > +#endif
> > > > > +
> > > > > +#endif /* _ASM_X86_SGX_H */
> > > > > diff --git a/arch/x86/kernel/cpu/sgx/virt.c
> > > > > b/arch/x86/kernel/cpu/sgx/virt.c index 47542140f8c1..016bad7cff8d
> > > > > 100644
> > > > > --- a/arch/x86/kernel/cpu/sgx/virt.c
> > > > > +++ b/arch/x86/kernel/cpu/sgx/virt.c
> > > >
> > > > Rename as vepc.c.
> > 
> > No. This file contains more than virtual EPC implementation, but also other staff like sgx_virt_ecreate()/sgx_virt_einit(), which are used by KVM to run ECREATE/EINIT on behalf of guest.
> > 
> > > >
> > > > > @@ -257,3 +257,97 @@ int __init sgx_vepc_init(void)
> > > > >
> > > > >  	return misc_register(&sgx_vepc_dev);  }
> > > > > +
> > > > > +/**
> > > > > + * sgx_virt_ecreate() - Run ECREATE on behalf of guest
> > > > > + * @pageinfo:	Pointer to PAGEINFO structure
> > > > > + * @secs:	Userspace pointer to SECS page
> > > > > + * @trapnr:	trap number injected to guest in case of ECREATE error
> > > > > + *
> > > > > + * Run ECREATE on behalf of guest after KVM traps ECREATE for the
> > > > > +purpose
> > > > > + * of enforcing policies of guest's enclaves, and return the trap
> > > > > +number
> > > > > + * which should be injected to guest in case of any ECREATE error.
> > > > > + *
> > > > > + * Return:
> > > > > + * - 0: 	ECREATE was successful.
> > > > > + * - -EFAULT:	ECREATE returned error.
> > > > > + */
> > > > > +int sgx_virt_ecreate(struct sgx_pageinfo *pageinfo, void __user *secs,
> > > > > +		     int *trapnr)
> > > > > +{
> > > > > +	int ret;
> > > > > +
> > > > > +	/*
> > > > > +	 * @secs is userspace address, and it's not guaranteed @secs points at
> > > > > +	 * an actual EPC page. It's also possible to generate a kernel mapping
> > > > > +	 * to physical EPC page by resolving PFN but using __uaccess_xx() is
> > > > > +	 * simpler.
> > > > > +	 */
> > > > > +	__uaccess_begin();
> > > > > +	ret = __ecreate(pageinfo, (void *)secs);
> > > > > +	__uaccess_end();
> > > > > +
> > > > > +	if (encls_faulted(ret)) {
> > > > > +		*trapnr = ENCLS_TRAPNR(ret);
> > > > > +		return -EFAULT;
> > > > > +	}
> > > > > +
> > > > > +	/* ECREATE doesn't return an error code, it faults or succeeds. */
> > > > > +	WARN_ON_ONCE(ret);
> > > >
> > > > Empty line.
> > > >
> > > > > +	return 0;
> > > > > +}
> > > > > +EXPORT_SYMBOL_GPL(sgx_virt_ecreate);
> > > > > +
> > > > > +static int __sgx_virt_einit(void __user *sigstruct, void __user *token,
> > > > > +			    void __user *secs)
> > > > > +{
> > > > > +	int ret;
> > > > > +
> > > > > +	__uaccess_begin();
> > > > > +	ret =  __einit((void *)sigstruct, (void *)token, (void *)secs);
> > > > > +	__uaccess_end();
> > > >
> > > > Ditto.
> > > >
> > > > > +	return ret;
> > > > > +}
> > > > > +
> > > > > +/**
> > > > > + * sgx_virt_einit() - Run EINIT on behalf of guest
> > > > > + * @sigstruct:		Userspace pointer to SIGSTRUCT structure
> > > > > + * @token:		Userspace pointer to EINITTOKEN structure
> > > > > + * @secs:		Userspace pointer to SECS page
> > > > > + * @lepubkeyhash:	Pointer to guest's *virtual* SGX_LEPUBKEYHASH MSR
> > > > > + * 			values
> > > > > + * @trapnr:		trap number injected to guest in case of EINIT error
> > > > > + *
> > > > > + * Run EINIT on behalf of guest after KVM traps EINIT. If SGX_LC is
> > > > > +available
> > > > > + * in host, SGX driver may rewrite the hardware values at wish,
> > > > > +therefore KVM
> > > > > + * needs to update hardware values to guest's virtual MSR values in
> > > > > +order to
> > > > > + * ensure EINIT is executed with expected hardware values.
> > > > > + *
> > > > > + * Return:
> > > > > + * - 0: 	EINIT was successful.
> > > > > + * - -EFAULT:	EINIT returned error.
> > > > > + */
> > > > > +int sgx_virt_einit(void __user *sigstruct, void __user *token,
> > > > > +		   void __user *secs, u64 *lepubkeyhash, int *trapnr) {
> > > > > +	int ret;
> > > > > +
> > > > > +	if (!boot_cpu_has(X86_FEATURE_SGX_LC)) {
> > > > > +		ret = __sgx_virt_einit(sigstruct, token, secs);
> > > > > +	} else {
> > > > > +		preempt_disable();
> > > > > +
> > > > > +		sgx_update_lepubkeyhash(lepubkeyhash);
> > > > > +
> > > > > +		ret = __sgx_virt_einit(sigstruct, token, secs);
> > > > > +		preempt_enable();
> > > > > +	}
> > > > > +
> > > > > +	if (encls_faulted(ret)) {
> > > > > +		*trapnr = ENCLS_TRAPNR(ret);
> > > > > +		return -EFAULT;
> > > > > +	}
> > > > > +
> > > > > +	return ret;
> > > > > +}
> > > > > +EXPORT_SYMBOL_GPL(sgx_virt_einit);
> > > 
> > > Remove exports.
> > 
> > Why? KVM needs to use them in later patches.
> 
> Because they are only required for LKM's.

I mean when LKM needs to call kernel functions.

Right, KVM can be compiled as LKM.

/Jarkko
