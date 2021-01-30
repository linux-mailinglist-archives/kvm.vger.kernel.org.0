Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADBD2309609
	for <lists+kvm@lfdr.de>; Sat, 30 Jan 2021 15:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbhA3Orz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Jan 2021 09:47:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:43544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231968AbhA3Oql (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Jan 2021 09:46:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB8FB64E10;
        Sat, 30 Jan 2021 14:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612017948;
        bh=L3INuMU+44EETVJjYr2RsN8bk9068iAb8KnZxHT5Shg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p0SnubWBPNJ7YCUmUsIEmOUQn7ELNusAMeRITrNR6ZVTxR7Lh4zE7CQHrbQLRS6vg
         ZPhOsfMIQyWa1XfvZG7pPZP/aS57WMOFRBXrAggIVB8j7CsrT4kDpr8PAwplWOqzFC
         dDujj+i1xN0wFNda1E1tyBC6zn80/Eii9C98L6wr/7iNco2HCfF+gaFhxFylxvdS9r
         MP0PaJB3150f3e3z7QSgyvYTAiggERocsoNrH7RmHuxoKaIZZQCy4/6h3abgkAC4c0
         5hFyQe8CGaHYs7HAe5162WJGVHJBIFQGIT2dbGLcnPaJ+SLf1NJna03icjF/MvM/or
         P7F9vzwz6dBXA==
Date:   Sat, 30 Jan 2021 16:45:43 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v3 08/27] x86/sgx: Initialize virtual EPC driver even
 when SGX driver is disabled
Message-ID: <YBVxF2kAl7VzeRPS@kernel.org>
References: <cover.1611634586.git.kai.huang@intel.com>
 <5076ed2c486ac33bfd87dc0e17047a1673692b53.1611634586.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5076ed2c486ac33bfd87dc0e17047a1673692b53.1611634586.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 26, 2021 at 10:31:00PM +1300, Kai Huang wrote:
> Modify sgx_init() to always try to initialize the virtual EPC driver,
> even if the bare-metal SGX driver is disabled.  The bare-metal driver
> might be disabled if SGX Launch Control is in locked mode, or not
> supported in the hardware at all.  This allows (non-Linux) guests that
> support non-LC configurations to use SGX.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
> v2->v3:
> 
>  - Changed from sgx_virt_epc_init() to sgx_vepc_init().
> 
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 21c2ffa13870..93d249f7bff3 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -12,6 +12,7 @@
>  #include "driver.h"
>  #include "encl.h"
>  #include "encls.h"
> +#include "virt.h"
>  
>  struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
>  static int sgx_nr_epc_sections;
> @@ -712,7 +713,8 @@ static int __init sgx_init(void)
>  		goto err_page_cache;
>  	}
>  
> -	ret = sgx_drv_init();
> +	/* Success if the native *or* virtual EPC driver initialized cleanly. */
> +	ret = !!sgx_drv_init() & !!sgx_vepc_init();

If would create more dumb code and just add

ret = sgx_vepc_init()
if (ret)
        goto err_kthread;

>  	if (ret)
>  		goto err_kthread;
>  
> -- 
> 2.29.2
> 

/Jarkko
> 
