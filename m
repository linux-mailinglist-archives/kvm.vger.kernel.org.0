Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9EE87414F9
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 17:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbjF1PaF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 11:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232098AbjF1PaA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 11:30:00 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFEAA268F;
        Wed, 28 Jun 2023 08:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yx7U6Q1zu/jZUmaTgwSAgFdK87Ilf4lSewGXSOlnpeM=; b=j/HFTVj/s4oubzmOZQkbXs2rGy
        m89lVq7Gr97cfnYWa6xARbldnNMVFMkRq8W1AjOORgsbE+JDe1bw/SVj909aNMoaQgR33VCyocwnB
        jMyRPT/RNe6DUCMNQAbSh+QXX1aa+EunTFd0+s08kp6YUsHL37mxE+tFruQTX09nNF/z4QHlhYdw/
        Q5Ev1yPX6SCK8BzGSUJsl0YZ9yclM8o4/U1hfdZUH6Q02BMUKP1h+1S3pQ/wYL/2iY2EjTmEFlAP+
        boThf77OadEYRu9XDFgab10EyNjLhgCEc6jrk8JIR2EiwsURk08sQ48aUNIfNGmiKUfXlxu01rmoL
        unCslgyg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qEX6M-005iuP-1l;
        Wed, 28 Jun 2023 15:29:02 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 16CA73002D6;
        Wed, 28 Jun 2023 17:29:01 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id F340423B2EE90; Wed, 28 Jun 2023 17:29:00 +0200 (CEST)
Date:   Wed, 28 Jun 2023 17:29:00 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        tglx@linutronix.de, bp@alien8.de, mingo@redhat.com, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, david@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        ashok.raj@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v12 20/22] x86/virt/tdx: Allow SEAMCALL to handle #UD and
 #GP
Message-ID: <20230628152900.GI2438817@hirez.programming.kicks-ass.net>
References: <cover.1687784645.git.kai.huang@intel.com>
 <c124550719716f1f7759c2bdea70f4722d8e0167.1687784645.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c124550719716f1f7759c2bdea70f4722d8e0167.1687784645.git.kai.huang@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 27, 2023 at 02:12:50AM +1200, Kai Huang wrote:
> diff --git a/arch/x86/virt/vmx/tdx/tdxcall.S b/arch/x86/virt/vmx/tdx/tdxcall.S
> index 49a54356ae99..757b0c34be10 100644
> --- a/arch/x86/virt/vmx/tdx/tdxcall.S
> +++ b/arch/x86/virt/vmx/tdx/tdxcall.S
> @@ -1,6 +1,7 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>  #include <asm/asm-offsets.h>
>  #include <asm/tdx.h>
> +#include <asm/asm.h>
>  
>  /*
>   * TDCALL and SEAMCALL are supported in Binutils >= 2.36.
> @@ -45,6 +46,7 @@
>  	/* Leave input param 2 in RDX */
>  
>  	.if \host
> +1:
>  	seamcall

So what registers are actually clobbered by SEAMCALL ? There's a
distinct lack of it in SDM Vol.2 instruction list :-(

>  	/*
>  	 * SEAMCALL instruction is essentially a VMExit from VMX root
> @@ -57,10 +59,23 @@
>  	 * This value will never be used as actual SEAMCALL error code as
>  	 * it is from the Reserved status code class.
>  	 */
> -	jnc .Lno_vmfailinvalid
> +	jnc .Lseamcall_out
>  	mov $TDX_SEAMCALL_VMFAILINVALID, %rax
> -.Lno_vmfailinvalid:
> +	jmp .Lseamcall_out
> +2:
> +	/*
> +	 * SEAMCALL caused #GP or #UD.  By reaching here %eax contains
> +	 * the trap number.  Convert the trap number to the TDX error
> +	 * code by setting TDX_SW_ERROR to the high 32-bits of %rax.
> +	 *
> +	 * Note cannot OR TDX_SW_ERROR directly to %rax as OR instruction
> +	 * only accepts 32-bit immediate at most.
> +	 */
> +	mov $TDX_SW_ERROR, %r12
> +	orq %r12, %rax
>  
> +	_ASM_EXTABLE_FAULT(1b, 2b)
> +.Lseamcall_out:

This is all pretty atrocious code flow... would it at all be possible to
write it like:

SYM_FUNC_START(...)

.if \host
1:	seamcall
	cmovc	%spare, %rax
2:
.else
	tdcall
.endif

	.....
	RET


3:
	mov $TDX_SW_ERROR, %r12
	orq %r12, %rax
	jmp 2b

	_ASM_EXTABLE_FAULT(1b, 3b)

SYM_FUNC_END()

That is, having all that inline in the hotpath is quite horrific.
