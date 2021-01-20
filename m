Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF2362FD18A
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 14:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730853AbhATMwP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 07:52:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:41714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733032AbhATMMT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 07:12:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5796206FA;
        Wed, 20 Jan 2021 12:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611144194;
        bh=sC2PxQvUDtcs5J/v19cP7uzTYaXO57aX4kf6Gys29xs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ERcW3ZBid0oBHUaXk+9PWhpGdRFtMdJsuAOu6PuIv95/s3KR9ssa35UpUGYlqvbor
         3VQMmJVkbN1tm7tssfwShQ7NXISRD+AMAv3WkvM5SBut2rcVf8sVZ0N0o4ObH3UnKP
         IwGWWm3LDyeMNQznYvSmmEpdX5NMsCfc5I7ZinxQeYqUgFZv5hRqGivHaU6ggG9qyM
         WTnKN49JV6c4cfX+uSc7IKt6FNsU8srBTcmnwZd3yZvViP7W1DTcvrcfrFa9KSstym
         dXj287tbNJB3tadq6AdyD7YyOAa5OL3KQWuhbEeDXe6dxCk8lJMASdPiRQTzxtEoGQ
         EGKC0Tfko/ddw==
Date:   Wed, 20 Jan 2021 14:03:08 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v2 11/26] x86/sgx: Add encls_faulted() helper
Message-ID: <YAgb/MhaNLVwBS8K@kernel.org>
References: <cover.1610935432.git.kai.huang@intel.com>
 <e36ac729b227d728e2b0d1a48cfbbeca4523f1a5.1610935432.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e36ac729b227d728e2b0d1a48cfbbeca4523f1a5.1610935432.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 18, 2021 at 04:28:04PM +1300, Kai Huang wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Add a helper to extract the fault indicator from an encoded ENCLS return
> value.  SGX virtualization will also need to detect ENCLS faults.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Acked-by: Dave Hansen <dave.hansen@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/encls.h | 14 +++++++++++++-
>  arch/x86/kernel/cpu/sgx/ioctl.c |  2 +-
>  2 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/encls.h b/arch/x86/kernel/cpu/sgx/encls.h
> index be5c49689980..55919a2b01b0 100644
> --- a/arch/x86/kernel/cpu/sgx/encls.h
> +++ b/arch/x86/kernel/cpu/sgx/encls.h
> @@ -40,6 +40,18 @@
>  	} while (0);							  \
>  }
>  
> +/*
> + * encls_faulted() - Check if an ENCLS leaf faulted given an error code
> + * @ret		the return value of an ENCLS leaf function call
> + *
> + * Return:
> + *	%true if @ret indicates a fault, %false otherwise

Follow here the style of commenting as in ioctl.c, for the return value.
It has optimal readability both as text, and also when converted to HTML.
See sgx_ioc_enclave_add_pages() for an example.

> + */
> +static inline bool encls_faulted(int ret)
> +{
> +	return ret & ENCLS_FAULT_FLAG;
> +}
> +
>  /**
>   * encls_failed() - Check if an ENCLS function failed
>   * @ret:	the return value of an ENCLS function call
> @@ -50,7 +62,7 @@
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

/Jarkko
