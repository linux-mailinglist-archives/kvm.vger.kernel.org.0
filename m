Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 541992FD18D
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 14:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731292AbhATMwS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 07:52:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:43502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388569AbhATMRk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 07:17:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E1E9221FB;
        Wed, 20 Jan 2021 12:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611144281;
        bh=Pzo3xSZ9Vy5Qvjcr66tQ0SjBekmNDg1D5Mq3C0B8idU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XWDNFSjcNT+tU9SZ9rOhaoah6MHGHVCAhoLx9tjVF2OKKtEtGtfjbKUXObQaYOwkt
         ejsaVgl1QVAoEhM0UsqIVcX4rFfyKKJsYHfY650JuG+uhZJCbPF+Lqnj+LXbcRc37Y
         RFpgNM3dVWvd245u2nm7nGTBZkFwJ6dTbvReys/Kex9AwJaza0zPK7MSB8Vg89LwEn
         B7lNnBaR/knxGqXtZxu6I5W/ioLXA/bkHRwqTSP3/rpM55obokW7GxpU5xUhtsbzu9
         ejt1ky0KxB3vft7fkWEh6x7MFsXo0FQ98kuyVdpzwK0Wz+7budQSpcpyoLDOpADZnd
         kwLHFwRyho4Qw==
Date:   Wed, 20 Jan 2021 14:04:36 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v2 13/26] x86/sgx: Add helpers to expose ECREATE and
 EINIT to KVM
Message-ID: <YAgcVIzdFU3cl3SW@kernel.org>
References: <cover.1610935432.git.kai.huang@intel.com>
 <e9a350fac5b18ca69496d07fe25a7a2408d1a73a.1610935432.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9a350fac5b18ca69496d07fe25a7a2408d1a73a.1610935432.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 18, 2021 at 04:28:06PM +1300, Kai Huang wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> The bare-metal kernel must intercept ECREATE to be able to impose policies
> on guests.  When it does this, the bare-metal kernel runs ECREATE against
> the userspace mapping of the virtualized EPC.
> 
> Provide wrappers around __ecreate() and __einit() to hide the ugliness
> of overloading the ENCLS return value to encode multiple error formats
> in a single int.  KVM will trap-and-execute ECREATE and EINIT as part
> of SGX virtualization, and on an exception, KVM needs the trapnr so that
> it can inject the correct fault into the guest.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>  [Kai: Use sgx_update_lepubkeyhash() to update pubkey hash MSRs.]

If you have to go to this, please instead use co-developed-by.

> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
> v1->v2:
> 
>  - Refined commit msg based on Dave's comment.
>  - Added comment to explain why to use __uaccess_xxx().
> ---
>  arch/x86/include/asm/sgx.h     | 16 +++++++++
>  arch/x86/kernel/cpu/sgx/virt.c | 61 ++++++++++++++++++++++++++++++++++
>  2 files changed, 77 insertions(+)
>  create mode 100644 arch/x86/include/asm/sgx.h
> 
> diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
> new file mode 100644
> index 000000000000..0d643b985085
> --- /dev/null
> +++ b/arch/x86/include/asm/sgx.h
> @@ -0,0 +1,16 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_X86_SGX_H
> +#define _ASM_X86_SGX_H
> +
> +#include <linux/types.h>
> +
> +#ifdef CONFIG_X86_SGX_VIRTUALIZATION
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
> index 1e8620f20651..97f02e5235ca 100644
> --- a/arch/x86/kernel/cpu/sgx/virt.c
> +++ b/arch/x86/kernel/cpu/sgx/virt.c
> @@ -253,3 +253,64 @@ int __init sgx_virt_epc_init(void)
>  
>  	return misc_register(&sgx_virt_epc_dev);
>  }
> +
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
> +int sgx_virt_einit(void __user *sigstruct, void __user *token,
> +		   void __user *secs, u64 *lepubkeyhash, int *trapnr)

kdoc missing.

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
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(sgx_virt_einit);
> -- 
> 2.29.2
> 
> 

/Jarkko
