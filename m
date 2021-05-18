Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79EB73873CE
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 10:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239694AbhERITO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 04:19:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:8106 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239422AbhERITO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 04:19:14 -0400
IronPort-SDR: aR3TF+HPlejVv59sFCLtPSyiOI9UgltUVM94+U5MyfYum8Ba9LzYc4m8tSSnDbJNFMkjqGqLky
 1NGpiwr3T77Q==
X-IronPort-AV: E=McAfee;i="6200,9189,9987"; a="197571294"
X-IronPort-AV: E=Sophos;i="5.82,309,1613462400"; 
   d="scan'208";a="197571294"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2021 01:17:54 -0700
IronPort-SDR: WodDe9c0niOvlDwYCJpuaYEdOR9Yl8vuIHGJ23Gs5puvuIpWMARt6RjRpyalZAKdH/jyydfXGh
 zE+W5PCe35Kg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,309,1613462400"; 
   d="scan'208";a="473348525"
Received: from michael-optiplex-9020.sh.intel.com (HELO localhost) ([10.239.159.172])
  by fmsmga002.fm.intel.com with ESMTP; 18 May 2021 01:17:53 -0700
Date:   Tue, 18 May 2021 16:31:36 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, seanjc@google.com,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: Re: [PATCH kvm-unit-tests] access: change CR0/CR4/EFER before TLB
 flushes
Message-ID: <20210518083136.GA20904@michael-OptiPlex-9020>
References: <20210410144234.32124-2-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210410144234.32124-2-pbonzini@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 10, 2021 at 04:42:34PM +0200, Paolo Bonzini wrote:

Hi, Paolo,
Has this patch been merged? We need this patch to fix the issue. Thanks!

> After CR0/CR4/EFER changes a stale TLB entry can be observed, because MOV
> to CR4 only invalidates TLB entries if CR4.SMEP is changed from 0 to 1.
> 
> The TLB is already flushed in ac_set_expected_status,
> but if kvm-unit-tests is migrated to another CPU and CR4 is
> changed after the flush, a stale entry can be used.
> 
> Reported-by: Yang Weijiang <weijiang.yang@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  x86/access.c | 25 ++++++++++++-------------
>  1 file changed, 12 insertions(+), 13 deletions(-)
> 
> diff --git a/x86/access.c b/x86/access.c
> index 66bd466..e5d5c00 100644
> --- a/x86/access.c
> +++ b/x86/access.c
> @@ -448,8 +448,6 @@ fault:
>  
>  static void ac_set_expected_status(ac_test_t *at)
>  {
> -    invlpg(at->virt);
> -
>      if (at->ptep)
>  	at->expected_pte = *at->ptep;
>      at->expected_pde = *at->pdep;
> @@ -561,6 +559,18 @@ static void __ac_setup_specific_pages(ac_test_t *at, ac_pool_t *pool,
>  	root = vroot[index];
>      }
>      ac_set_expected_status(at);
> +
> +    set_cr0_wp(F(AC_CPU_CR0_WP));
> +    set_efer_nx(F(AC_CPU_EFER_NX));
> +    set_cr4_pke(F(AC_CPU_CR4_PKE));
> +    if (F(AC_CPU_CR4_PKE)) {
> +        /* WD2=AD2=1, WD1=F(AC_PKU_WD), AD1=F(AC_PKU_AD) */
> +        write_pkru(0x30 | (F(AC_PKU_WD) ? 8 : 0) |
> +                   (F(AC_PKU_AD) ? 4 : 0));
> +    }
> +
> +    set_cr4_smep(F(AC_CPU_CR4_SMEP));
> +    invlpg(at->virt);
>  }
>  
>  static void ac_test_setup_pte(ac_test_t *at, ac_pool_t *pool)
> @@ -644,17 +654,6 @@ static int ac_test_do_access(ac_test_t *at)
>      *((unsigned char *)at->phys) = 0xc3; /* ret */
>  
>      unsigned r = unique;
> -    set_cr0_wp(F(AC_CPU_CR0_WP));
> -    set_efer_nx(F(AC_CPU_EFER_NX));
> -    set_cr4_pke(F(AC_CPU_CR4_PKE));
> -    if (F(AC_CPU_CR4_PKE)) {
> -        /* WD2=AD2=1, WD1=F(AC_PKU_WD), AD1=F(AC_PKU_AD) */
> -        write_pkru(0x30 | (F(AC_PKU_WD) ? 8 : 0) |
> -                   (F(AC_PKU_AD) ? 4 : 0));
> -    }
> -
> -    set_cr4_smep(F(AC_CPU_CR4_SMEP));
> -
>      if (F(AC_ACCESS_TWICE)) {
>  	asm volatile (
>  	    "mov $fixed2, %%rsi \n\t"
> -- 
> 2.30.1
