Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56F0F2FD18B
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 14:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730980AbhATMwQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 07:52:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:41712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733019AbhATMMT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 07:12:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B63F4221F8;
        Wed, 20 Jan 2021 12:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611144232;
        bh=jydP56RGccUU981cFKjyIMousKsvB5qV4Y5KKa4NB/o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hqPjPT+xCooKOBrfof5E7SkOhSX29q+xjU8cYETT2ISlPcN5qli4fg3PD99Ur8uA0
         SnXc9yZoEXVU6zP+xTMHac6vXh0JwstGO5/cegChwUv2qkRjUDBtUktJge4COLoQxQ
         DkVjBN3/XAP9Vv8xfBlekE/0qkh47QMfpQZ4WIC5n0NU3p+fDiqaA/FVIbakRUsbbN
         8l40J6RpaqfKLnbElpkd0HnPJkxOucfX1KtuuFAwaCXeGVSsZKCZIvkIZqZ+uWMuRe
         FgAImqOKNXcjqxTWMXCFmvHmEQOT7y4DDE5ffFmI2DlnNE0hZZOmB1uZ+Cg4r/unK5
         1+UPdTnHmkocw==
Date:   Wed, 20 Jan 2021 14:03:46 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v2 12/26] x86/sgx: Add helper to update
 SGX_LEPUBKEYHASHn MSRs
Message-ID: <YAgcIhkmw0lllD3G@kernel.org>
References: <cover.1610935432.git.kai.huang@intel.com>
 <5116fdc732e8e14b3378c44e3b461a43f330ed0c.1610935432.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5116fdc732e8e14b3378c44e3b461a43f330ed0c.1610935432.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 18, 2021 at 04:28:05PM +1300, Kai Huang wrote:
> Add a helper to update SGX_LEPUBKEYHASHn MSRs.  SGX virtualization also
> needs to update those MSRs based on guest's "virtual" SGX_LEPUBKEYHASHn
> before EINIT from guest.
> 
> Acked-by: Dave Hansen <dave.hansen@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/ioctl.c | 5 ++---
>  arch/x86/kernel/cpu/sgx/main.c  | 8 ++++++++
>  arch/x86/kernel/cpu/sgx/sgx.h   | 2 ++
>  3 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
> index e5977752c7be..1bae754268d1 100644
> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -495,7 +495,7 @@ static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
>  			 void *token)
>  {
>  	u64 mrsigner[4];
> -	int i, j, k;
> +	int i, j;
>  	void *addr;
>  	int ret;
>  
> @@ -544,8 +544,7 @@ static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
>  
>  			preempt_disable();
>  
> -			for (k = 0; k < 4; k++)
> -				wrmsrl(MSR_IA32_SGXLEPUBKEYHASH0 + k, mrsigner[k]);
> +			sgx_update_lepubkeyhash(mrsigner);
>  
>  			ret = __einit(sigstruct, token, addr);
>  
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index bdda631c975b..1cf1f0f058b8 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -697,6 +697,14 @@ static bool __init sgx_page_cache_init(void)
>  	return true;
>  }
>  
> +void sgx_update_lepubkeyhash(u64 *lepubkeyhash)
> +{
> +	int i;
> +
> +	for (i = 0; i < 4; i++)
> +		wrmsrl(MSR_IA32_SGXLEPUBKEYHASH0 + i, lepubkeyhash[i]);
> +}

Missing kdoc.

> +
>  static void __init sgx_init(void)
>  {
>  	int ret;
> diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
> index 509f2af33e1d..ccd4f145c464 100644
> --- a/arch/x86/kernel/cpu/sgx/sgx.h
> +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> @@ -83,4 +83,6 @@ void sgx_mark_page_reclaimable(struct sgx_epc_page *page);
>  int sgx_unmark_page_reclaimable(struct sgx_epc_page *page);
>  struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim);
>  
> +void sgx_update_lepubkeyhash(u64 *lepubkeyhash);
> +
>  #endif /* _X86_SGX_H */
> -- 
> 2.29.2
> 
> 

/Jarkko
