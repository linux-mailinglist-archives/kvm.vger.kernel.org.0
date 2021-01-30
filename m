Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02B643096AF
	for <lists+kvm@lfdr.de>; Sat, 30 Jan 2021 17:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbhA3QXA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Jan 2021 11:23:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:43874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232059AbhA3OuH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Jan 2021 09:50:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B225964D92;
        Sat, 30 Jan 2021 14:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612018165;
        bh=fqsyPAloyPRcdN+NG/JvaiNBXqj79bZje/9Yq93DFxQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rd5fGp0p8utHYoBZkYO1TDgkyI6M/qTRUPEudnTMLVaK140thak1T3pZiclyUYo1D
         ur1gU+FfnSTV7N5lDTxJVdxABSP4bRfkK65Qh233sh5JgNketJzvKmmIFlW6poynsA
         sKSemKFpiWvk80jE4opcTT9V71j2RxQSaY80oXtV0aMxApYlKodi7GAzAKXzvwShN7
         T/2ZY4nWa1IfujpgasBLk8NB9AgEFwY2lK9z1aO5O2bGxZDPFffMtc/kEk8BuCd/oS
         CSJY+lPJpNGk8S2RPWf7QMrawfScw5tItJAK6JyqH/Jd9YtY5t5ln04stWnxtEpc0l
         b7DHJ7wPxCdxw==
Date:   Sat, 30 Jan 2021 16:49:20 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v3 13/27] x86/sgx: Add helper to update
 SGX_LEPUBKEYHASHn MSRs
Message-ID: <YBVx8P1QfRspUvkC@kernel.org>
References: <cover.1611634586.git.kai.huang@intel.com>
 <db965546668e24857627a6695ee739aac5c15d3a.1611634586.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db965546668e24857627a6695ee739aac5c15d3a.1611634586.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 26, 2021 at 10:31:05PM +1300, Kai Huang wrote:
> Add a helper to update SGX_LEPUBKEYHASHn MSRs.  SGX virtualization also
> needs to update those MSRs based on guest's "virtual" SGX_LEPUBKEYHASHn
> before EINIT from guest.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>


Acked-by: Jarkko Sakkinen <jarkko@kernel.org>

/Jarkko

> ---
> v2->v3:
> 
>  - Added comment for sgx_update_lepubkeyhash(), per Jarkko and Dave.
> 
> ---
>  arch/x86/kernel/cpu/sgx/ioctl.c |  5 ++---
>  arch/x86/kernel/cpu/sgx/main.c  | 15 +++++++++++++++
>  arch/x86/kernel/cpu/sgx/sgx.h   |  2 ++
>  3 files changed, 19 insertions(+), 3 deletions(-)
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
> index 93d249f7bff3..b456899a9532 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -697,6 +697,21 @@ static bool __init sgx_page_cache_init(void)
>  	return true;
>  }
>  
> +
> +/*
> + * Update the SGX_LEPUBKEYHASH MSRs to the values specified by caller.
> + * Bare-metal driver requires to update them to hash of enclave's signer
> + * before EINIT. KVM needs to update them to guest's virtual MSR values
> + * before doing EINIT from guest.
> + */
> +void sgx_update_lepubkeyhash(u64 *lepubkeyhash)
> +{
> +	int i;
> +
> +	for (i = 0; i < 4; i++)
> +		wrmsrl(MSR_IA32_SGXLEPUBKEYHASH0 + i, lepubkeyhash[i]);
> +}
> +
>  static int __init sgx_init(void)
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
