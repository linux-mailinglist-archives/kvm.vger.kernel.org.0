Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 245A1309645
	for <lists+kvm@lfdr.de>; Sat, 30 Jan 2021 16:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232023AbhA3PeQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Jan 2021 10:34:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:44074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232153AbhA3Ow3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Jan 2021 09:52:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07FA264E08;
        Sat, 30 Jan 2021 14:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612018306;
        bh=Udib9so7iafy8RsHhAHi7ZH+XeRZQ1q3sxomJhKNo1Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fKsK9xlv2ZdeuRZYSdGKP5/kZNMrkJbqJZ1K0fymKud7tZopksisUV8K9+RPdUPju
         eW5gPAXLVFO82ylnhrANERnR723nnTLYerry40gf/DuYvz40OntHWjrbYJ42LNaq5z
         IyL9/t4v2MBzazhv2s36qMRHoaEbaiCD1Fpbvs8/zIm5HbAQh71datLLTg26PPqtPF
         ebVDhsSOYR2cl2GeqG7ziJL3cf7ZfNteaxX6NcDxDfbgl79/iGXpCHsnoBKPWrPnDE
         mjv2Wyk9LEy7pKvtijVFlVTRZMLU8Hjosv+k6oYqAWFjPV/FoUCIx3SQZBM2IfyRuk
         /HX983BFLfQIQ==
Date:   Sat, 30 Jan 2021 16:51:41 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v3 14/27] x86/sgx: Add helpers to expose ECREATE and
 EINIT to KVM
Message-ID: <YBVyfQQPo18Fyv64@kernel.org>
References: <cover.1611634586.git.kai.huang@intel.com>
 <e807033e3d56ede1177d7a1af34477678bfbfff9.1611634586.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e807033e3d56ede1177d7a1af34477678bfbfff9.1611634586.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 26, 2021 at 10:31:06PM +1300, Kai Huang wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> The bare-metal kernel must intercept ECREATE to be able to impose policies
> on guests.  When it does this, the bare-metal kernel runs ECREATE against
> the userspace mapping of the virtualized EPC.

I guess Andy's earlier comment applies here, i.e. SGX driver?

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
> v2->v3:
> 
>  - Added kdoc for sgx_virt_ecreate() and sgx_virt_einit(), per Jarkko.
>  - Changed to use CONFIG_X86_SGX_KVM.
> 
> ---
>  arch/x86/include/asm/sgx.h     | 16 ++++++
>  arch/x86/kernel/cpu/sgx/virt.c | 93 ++++++++++++++++++++++++++++++++++
>  2 files changed, 109 insertions(+)
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
> +#endif
> +
> +#endif /* _ASM_X86_SGX_H */
> diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
> index e1ad7856d878..0f5b0e4e33dd 100644
> --- a/arch/x86/kernel/cpu/sgx/virt.c
> +++ b/arch/x86/kernel/cpu/sgx/virt.c
> @@ -252,3 +252,96 @@ int __init sgx_vepc_init(void)
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
> +	return ret;
> +}
> +
> +/**
> + * sgx_virt_ecreate() - Run EINIT on behalf of guest
> + * @sigstruct:		Userspace pointer to SIGSTRUCT structure
> + * @token:		Userspace pointer to EINITTOKEN structure
> + * @secs:		Userspace pointer to SECS page
> + * @lepubkeyhash:	Pointer to guest's *virtual* SGX_LEPUBKEYHASH MSR
> + * 			values
> + * @trapnr:		trap number injected to guest in case of EINIT error
> + *
> + * Run EINIT on behalf of guest after KVM traps EINIT. If SGX_LC is available
> + * in host, bare-metal driver may rewrite the hardware values, therefore KVM
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

Empty line here before return. Applies also to sgx_virt_ecreate().

> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(sgx_virt_einit);
> -- 
> 2.29.2

Great work. I think this patch sets is shaping up.

/Jarkko
> 
> 
