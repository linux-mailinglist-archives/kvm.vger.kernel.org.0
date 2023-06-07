Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55B84725749
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 10:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235614AbjFGITO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 04:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231634AbjFGITM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 04:19:12 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69FD895;
        Wed,  7 Jun 2023 01:19:11 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 41be03b00d2f7-53f9a376f3eso6335274a12.0;
        Wed, 07 Jun 2023 01:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686125951; x=1688717951;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vUw3pvnoCDVchEZbcmCMTv1rymUUdjuYDIrMsGD+/vI=;
        b=ey0J6ANpBPU0w/BzCNPygbd0EqLpxTSaoSbtOWNdKLZgVbYtVmKZ4oCL+Ihkwvx+h0
         PFrgIvMcbggz9qJV/DXgN2rDn1Ai+SEOz0QmuzffLK57HjToRAuJ2CabTwEzTjtcxkMf
         yIsUXJe8pKuIWazuESc7Hcgor65NDlMn+Yi+k1hIftWrwrdLdhOvXULKpVXFVnX1qNt/
         4drGEqES7nevWDaLxjLUAJbyPhoZ81hIwKbvk5iv7odV3OkFs7IQOi8pTjRsD1XBbE/I
         8Mj8dNQ0rrVyM2qGvrgbmfe8AbjeHmj+EFIltzlQ+uyV6t3fiuBoxtHfK6pjjQliwJN5
         frIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686125951; x=1688717951;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vUw3pvnoCDVchEZbcmCMTv1rymUUdjuYDIrMsGD+/vI=;
        b=B90smRmfPURvbKwA4wkHWRa1/5ksqVv3sloO8P4Kv34r5ECMZMlq6GlIPLemjPe931
         wAQ20mlj3iBIYf1Z7s2/l6w5h9eGdyPZS7n5aA9PrpI1rD6Mdz/KI6+wOjsjykgPIhGd
         p0qRBoyEBpxUD/QIwoQBZRNCgqgdqTKo0CqWpvpYv5ZzbzgV2g40bNFi9fIAS/AcvQ0z
         UKP4xs2JMsfw6n+rPg0363B9Qrv5Dr19NRYuhQNXpOh8L2IN8bnoyNvf2nYHCVMFU/EQ
         4s/vo0VAc4ZWI80oq9TbpwbVBWHDyC38jP9ka6o8WyAFfa7Rp5kLn+jvlQvuUqS8JdFt
         72BQ==
X-Gm-Message-State: AC+VfDyRITa5DBkvTn0oj6ipkWYczqD5xN67vqmMkzFyUpYygWjc0gKV
        UFXexm625IrQJ47vrEgolnc=
X-Google-Smtp-Source: ACHHUZ4qmDkzQEmUezZ5ox34Ji3uK6GPUG9y+XZtEzqn6r49SY1/XX0eQs5VU+AQEYa71u+2zuFYjA==
X-Received: by 2002:a17:903:32c7:b0:1b0:4c32:5d6d with SMTP id i7-20020a17090332c700b001b04c325d6dmr5788432plr.31.1686125950586;
        Wed, 07 Jun 2023 01:19:10 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id i16-20020a170902c95000b001b1866f7b5csm9801505pla.138.2023.06.07.01.19.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 01:19:09 -0700 (PDT)
Date:   Wed, 7 Jun 2023 01:19:08 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com, isaku.yamahata@gmail.com
Subject: Re: [PATCH v11 06/20] x86/virt/tdx: Handle SEAMCALL running out of
 entropy error
Message-ID: <20230607081908.GE2244082@ls.amr.corp.intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
 <9b3582c9f3a81ae68b32d9997fcd20baecb63b9b.1685887183.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9b3582c9f3a81ae68b32d9997fcd20baecb63b9b.1685887183.git.kai.huang@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05, 2023 at 02:27:19AM +1200,
Kai Huang <kai.huang@intel.com> wrote:

> Certain SEAMCALL leaf functions may return error due to running out of
> entropy, in which case the SEAMCALL should be retried as suggested by
> the TDX spec.
> 
> Handle this case in SEAMCALL common function.  Mimic the existing
> rdrand_long() to retry RDRAND_RETRY_LOOPS times.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
> 
> v10 -> v11:
>  - New patch
> 
> ---
>  arch/x86/virt/vmx/tdx/tdx.c | 15 ++++++++++++++-
>  arch/x86/virt/vmx/tdx/tdx.h | 17 +++++++++++++++++
>  2 files changed, 31 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index e82713dd5d54..e62e978eba1b 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -15,6 +15,7 @@
>  #include <linux/smp.h>
>  #include <asm/msr-index.h>
>  #include <asm/msr.h>
> +#include <asm/archrandom.h>
>  #include <asm/tdx.h>
>  #include "tdx.h"
>  
> @@ -33,12 +34,24 @@ static int __always_unused seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
>  				    struct tdx_module_output *out)
>  {
>  	int cpu, ret = 0;
> +	int retry;
>  	u64 sret;
>  
>  	/* Need a stable CPU id for printing error message */
>  	cpu = get_cpu();
>  
> -	sret = __seamcall(fn, rcx, rdx, r8, r9, out);
> +	/*
> +	 * Certain SEAMCALL leaf functions may return error due to
> +	 * running out of entropy, in which case the SEAMCALL should
> +	 * be retried.  Handle this in SEAMCALL common function.
> +	 *
> +	 * Mimic the existing rdrand_long() to retry
> +	 * RDRAND_RETRY_LOOPS times.
> +	 */
> +	retry = RDRAND_RETRY_LOOPS;
> +	do {
> +		sret = __seamcall(fn, rcx, rdx, r8, r9, out);
> +	} while (sret == TDX_RND_NO_ENTROPY && --retry);
>  
>  	/* Save SEAMCALL return code if the caller wants it */
>  	if (seamcall_ret)
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index 48ad1a1ba737..55dbb1b8c971 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -4,6 +4,23 @@
>  
>  #include <linux/types.h>
>  
> +/*
> + * This file contains both macros and data structures defined by the TDX
> + * architecture and Linux defined software data structures and functions.
> + * The two should not be mixed together for better readability.  The
> + * architectural definitions come first.
> + */
> +
> +/*
> + * TDX SEAMCALL error codes
> + */
> +#define TDX_RND_NO_ENTROPY	0x8000020300000000ULL
> +
> +/*
> + * Do not put any hardware-defined TDX structure representations below
> + * this comment!
> + */
> +
>  struct tdx_module_output;
>  u64 __seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
>  	       struct tdx_module_output *out);
> -- 
> 2.40.1
> 

Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
