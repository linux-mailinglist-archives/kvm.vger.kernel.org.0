Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407AC31C5B8
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 04:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbhBPDJM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Feb 2021 22:09:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:39988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhBPDJL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Feb 2021 22:09:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCBED64D9D;
        Tue, 16 Feb 2021 03:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613444910;
        bh=PEZDoewzicDcK1rp22MAeNU/BCgJy7YEanIWt6BZX+Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G0BdwyUPJpRwk/U5EL7x097w+tm0+b6ItMVTMvhlZQVWPCzrgnhI+Tcv3m6FmbcIK
         DEN8QhjsV/1Sr5G8JcCXtmlO29jeOUI94ngvSdsnOR4IAOD4D0G1lt/0EdwjCOLx4W
         DKodPCUMXGf/mRKt8nOaH9iL4PDubQnNXN27lqL1IaiB1Bp8pq7t8LZavevqHQrSEf
         uNrv8hoGtCOmaiYR+qbf1j7aXa4+4qfF80IJGKuA7gxVLtWmjkGwCeZ5/VUZYF/0fB
         jltmBzvuf55UNxyt27xMZ0MlP64LLvnYU+rU4CjjedZQ1ZlAqGDs+Z4lY+j5Two02T
         hp9zBZWdMI2Qg==
Date:   Tue, 16 Feb 2021 05:08:17 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        rick.p.edgecombe@intel.com, haitao.huang@intel.com,
        pbonzini@redhat.com, bp@alien8.de, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v5 13/26] x86/sgx: Add helpers to expose ECREATE and
 EINIT to KVM
Message-ID: <YCs3IZ/Edv6AeIYo@kernel.org>
References: <cover.1613221549.git.kai.huang@intel.com>
 <4b8921da8e0d037b1e99d5cc92eea8f8470cf2e0.1613221549.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b8921da8e0d037b1e99d5cc92eea8f8470cf2e0.1613221549.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Feb 14, 2021 at 02:29:15AM +1300, Kai Huang wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> The host kernel must intercept ECREATE to be able to impose policies on
> guests.  When it does this, the host kernel runs ECREATE against the
> userspace mapping of the virtualized EPC.
> 
> Provide wrappers around __ecreate() and __einit() to hide the ugliness
> of overloading the ENCLS return value to encode multiple error formats
> in a single int.  KVM will trap-and-execute ECREATE and EINIT as part
> of SGX virtualization, and on an exception, KVM needs the trapnr so that
> it can inject the correct fault into the guest.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
> v4->v5:
> 
>  - No code change.
> 
> v3->v4:
> 
>  - Added one new line before last return in sgx_virt_einit(), per Jarkko.
> 
> v2->v3:
> 
>  - Added kdoc for sgx_virt_ecreate() and sgx_virt_einit(), per Jarkko.
>  - Changed to use CONFIG_X86_SGX_KVM.
> 
> ---
>  arch/x86/include/asm/sgx.h     | 16 ++++++
>  arch/x86/kernel/cpu/sgx/virt.c | 94 ++++++++++++++++++++++++++++++++++
>  2 files changed, 110 insertions(+)
>  create mode 100644 arch/x86/include/asm/sgx.h
> 
> diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
> new file mode 100644
> index 000000000000..8a3ea3e1efbe
> --- /dev/null
> +++ b/arch/x86/include/asm/sgx.h
> @@ -0,0 +1,16 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_X86_SGX_H
> +#define _ASM_X86_SGX_H
> +
> +#include <linux/types.h>
> +
> +#ifdef CONFIG_X86_SGX_KVM
> +struct sgx_pageinfo;
> +
> +int sgx_virt_ecreate(struct sgx_pageinfo *pageinfo, void __user *secs,
> +		     int *trapnr);
> +int sgx_virt_einit(void __user *sigstruct, void __user *token,
> +		   void __user *secs, u64 *lepubkeyhash, int *trapnr);

s/virt/vepc/g

> +#endif
> +
> +#endif /* _ASM_X86_SGX_H */
> diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
> index 47542140f8c1..016bad7cff8d 100644
> --- a/arch/x86/kernel/cpu/sgx/virt.c
> +++ b/arch/x86/kernel/cpu/sgx/virt.c

Rename as vepc.c.

> @@ -257,3 +257,97 @@ int __init sgx_vepc_init(void)
>  
>  	return misc_register(&sgx_vepc_dev);
>  }
> +
> +/**
> + * sgx_virt_ecreate() - Run ECREATE on behalf of guest
> + * @pageinfo:	Pointer to PAGEINFO structure
> + * @secs:	Userspace pointer to SECS page
> + * @trapnr:	trap number injected to guest in case of ECREATE error
> + *
> + * Run ECREATE on behalf of guest after KVM traps ECREATE for the purpose
> + * of enforcing policies of guest's enclaves, and return the trap number
> + * which should be injected to guest in case of any ECREATE error.
> + *
> + * Return:
> + * - 0: 	ECREATE was successful.
> + * - -EFAULT:	ECREATE returned error.
> + */
> +int sgx_virt_ecreate(struct sgx_pageinfo *pageinfo, void __user *secs,
> +		     int *trapnr)
> +{
> +	int ret;
> +
> +	/*
> +	 * @secs is userspace address, and it's not guaranteed @secs points at
> +	 * an actual EPC page. It's also possible to generate a kernel mapping
> +	 * to physical EPC page by resolving PFN but using __uaccess_xx() is
> +	 * simpler.
> +	 */
> +	__uaccess_begin();
> +	ret = __ecreate(pageinfo, (void *)secs);
> +	__uaccess_end();
> +
> +	if (encls_faulted(ret)) {
> +		*trapnr = ENCLS_TRAPNR(ret);
> +		return -EFAULT;
> +	}
> +
> +	/* ECREATE doesn't return an error code, it faults or succeeds. */
> +	WARN_ON_ONCE(ret);

Empty line.

> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(sgx_virt_ecreate);
> +
> +static int __sgx_virt_einit(void __user *sigstruct, void __user *token,
> +			    void __user *secs)
> +{
> +	int ret;
> +
> +	__uaccess_begin();
> +	ret =  __einit((void *)sigstruct, (void *)token, (void *)secs);
> +	__uaccess_end();

Ditto.

> +	return ret;
> +}
> +
> +/**
> + * sgx_virt_einit() - Run EINIT on behalf of guest
> + * @sigstruct:		Userspace pointer to SIGSTRUCT structure
> + * @token:		Userspace pointer to EINITTOKEN structure
> + * @secs:		Userspace pointer to SECS page
> + * @lepubkeyhash:	Pointer to guest's *virtual* SGX_LEPUBKEYHASH MSR
> + * 			values
> + * @trapnr:		trap number injected to guest in case of EINIT error
> + *
> + * Run EINIT on behalf of guest after KVM traps EINIT. If SGX_LC is available
> + * in host, SGX driver may rewrite the hardware values at wish, therefore KVM
> + * needs to update hardware values to guest's virtual MSR values in order to
> + * ensure EINIT is executed with expected hardware values.
> + *
> + * Return:
> + * - 0: 	EINIT was successful.
> + * - -EFAULT:	EINIT returned error.
> + */
> +int sgx_virt_einit(void __user *sigstruct, void __user *token,
> +		   void __user *secs, u64 *lepubkeyhash, int *trapnr)
> +{
> +	int ret;
> +
> +	if (!boot_cpu_has(X86_FEATURE_SGX_LC)) {
> +		ret = __sgx_virt_einit(sigstruct, token, secs);
> +	} else {
> +		preempt_disable();
> +
> +		sgx_update_lepubkeyhash(lepubkeyhash);
> +
> +		ret = __sgx_virt_einit(sigstruct, token, secs);
> +		preempt_enable();
> +	}
> +
> +	if (encls_faulted(ret)) {
> +		*trapnr = ENCLS_TRAPNR(ret);
> +		return -EFAULT;
> +	}
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(sgx_virt_einit);
> -- 
> 2.29.2
> 
> 

/Jarkko
