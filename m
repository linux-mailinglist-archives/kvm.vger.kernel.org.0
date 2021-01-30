Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 213843096B0
	for <lists+kvm@lfdr.de>; Sat, 30 Jan 2021 17:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232093AbhA3QX1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Jan 2021 11:23:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:43800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232057AbhA3OtZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Jan 2021 09:49:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7402064E08;
        Sat, 30 Jan 2021 14:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612018125;
        bh=Fxe+h4h2I56uRKHo6E+MXqyOQrHLGu/e54u3oRDGbOE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nREkc/P+mJT3fDoC3eDuuCiIhQfUqSSrKHwpJh2TDwFkdT8nWThC3G711XU8IVXDz
         biAglIyim3+kq+as9TUe8vsqzpXeiliNOvxDv1hoOqBZ01EVOY+lVCfsWQUf0woHVY
         oFFTltNKpK+wYTYVl28VASVzWijAkbmHHNqlPfg6gu1OSdY6xmxnghLOr107Q/vLqo
         957iXxPpjoqJ0nU8ejB4ErXCzBGPvtB3aueZV4eieOWaJX/VtrX96IDbtAa/AM4RKw
         x8iI8VMmuZmCCXOYtzq3tJStrQF6nd8GIiNB6nzU/GCIX0zuhZBmcq16u9VHySL1XC
         Il4uKjfZ7Qqlg==
Date:   Sat, 30 Jan 2021 16:48:40 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v3 12/27] x86/sgx: Add encls_faulted() helper
Message-ID: <YBVxyCqGBpxmS9Vq@kernel.org>
References: <cover.1611634586.git.kai.huang@intel.com>
 <c6d0ac25206db0022aad3c2aba98f39e1a0bf344.1611634586.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6d0ac25206db0022aad3c2aba98f39e1a0bf344.1611634586.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 26, 2021 at 10:31:04PM +1300, Kai Huang wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Add a helper to extract the fault indicator from an encoded ENCLS return
> value.  SGX virtualization will also need to detect ENCLS faults.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Acked-by: Dave Hansen <dave.hansen@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>


Acked-by: Jarkko Sakkinen <jarkko@kernel.org>

/Jarkko

> ---
> v2->v3:
> 
>  - Changed commenting style for return value, per Jarkko.
> 
> ---
>  arch/x86/kernel/cpu/sgx/encls.h | 15 ++++++++++++++-
>  arch/x86/kernel/cpu/sgx/ioctl.c |  2 +-
>  2 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/encls.h b/arch/x86/kernel/cpu/sgx/encls.h
> index be5c49689980..3219d011ee28 100644
> --- a/arch/x86/kernel/cpu/sgx/encls.h
> +++ b/arch/x86/kernel/cpu/sgx/encls.h
> @@ -40,6 +40,19 @@
>  	} while (0);							  \
>  }
>  
> +/*
> + * encls_faulted() - Check if an ENCLS leaf faulted given an error code
> + * @ret 	the return value of an ENCLS leaf function call
> + *
> + * Return:
> + * - true:	ENCLS leaf faulted.
> + * - false:	Otherwise.
> + */
> +static inline bool encls_faulted(int ret)
> +{
> +	return ret & ENCLS_FAULT_FLAG;
> +}
> +
>  /**
>   * encls_failed() - Check if an ENCLS function failed
>   * @ret:	the return value of an ENCLS function call
> @@ -50,7 +63,7 @@
>   */
>  static inline bool encls_failed(int ret)
>  {
> -	if (ret & ENCLS_FAULT_FLAG)
> +	if (encls_faulted(ret))
>  		return ENCLS_TRAPNR(ret) != X86_TRAP_PF;
>  
>  	return !!ret;
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
> index 90a5caf76939..e5977752c7be 100644
> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -568,7 +568,7 @@ static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
>  		}
>  	}
>  
> -	if (ret & ENCLS_FAULT_FLAG) {
> +	if (encls_faulted(ret)) {
>  		if (encls_failed(ret))
>  			ENCLS_WARN(ret, "EINIT");
>  
> -- 
> 2.29.2
> 
> 
