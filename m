Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 609CD722536
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 14:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbjFEMHw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 08:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjFEMHv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 08:07:51 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5702292;
        Mon,  5 Jun 2023 05:07:50 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1685966868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KXCmDfvj9l+154x1gPShTvQOI2Ax76Udy+UmUVwfA9A=;
        b=EHRctzJyGTaUBHd5gaBmROCxEN4c1Oe/9jBSeNe9frLeCG4bn61BHCqeXrmHqPsPkqAKFa
        11LI8UGe1726OEEwo/Gh7jxQa+HR5GExjqMk0Y6p8IqDHCG4AMSdqllsX5d6vJZ+nT03iV
        2zSweQ483LCOJpnJAF23v8Qkj7ouqeyEpPpBNPEp5cmO1TlvPYkfxMkzDNiSGTo92yNvhQ
        4qTeY7N4s9zcB4t+wdrWFKD73D7/UYFy5KfGGziV70E3UzdmhUhe/00m4fy+GH0A93xEAz
        ibNw80DhnPCcHdAKj7eieCgYBVxHQZzDyN+FLaLloX9SvRsL1HvWtwqMTtfGmA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1685966868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KXCmDfvj9l+154x1gPShTvQOI2Ax76Udy+UmUVwfA9A=;
        b=bi7gJKNK43gslB/6sAajAZsqNLxl8cIkdUxehfFmm6TB9ooPuOegaNSD/p7HKhgJg4OLIn
        bKTx4VcD0SWKG+CA==
To:     Xin Li <xin3.li@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, peterz@infradead.org, andrew.cooper3@citrix.com,
        seanjc@google.com, pbonzini@redhat.com, ravi.v.shankar@intel.com,
        jiangshanlai@gmail.com, shan.kang@intel.com
Subject: Re: [PATCH v8 02/33] x86/fred: make unions for the cs and ss fields
 in struct pt_regs
In-Reply-To: <20230410081438.1750-3-xin3.li@intel.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-3-xin3.li@intel.com>
Date:   Mon, 05 Jun 2023 14:07:48 +0200
Message-ID: <87o7lu6rjf.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 10 2023 at 01:14, Xin Li wrote:
> +	union {
> +		unsigned long  csx;	/* cs extended: CS + any fields above it */
> +		struct __attribute__((__packed__)) {
> +			unsigned short cs;	/* CS selector proper */
> +			unsigned int current_stack_level: 2;
> +			unsigned int __csx_resv1	: 6;
> +			unsigned int interrupt_shadowed	: 1;
> +			unsigned int software_initiated	: 1;
> +			unsigned int __csx_resv2	: 2;
> +			unsigned int nmi		: 1;
> +			unsigned int __csx_resv3	: 3;
> +			unsigned int __csx_resv4	: 32;
> +		};
> +	};
>  	unsigned long flags;
>  	unsigned long sp;
> -	unsigned long ss;
> +	union {
> +		unsigned long  ssx;	/* ss extended: SS + any fields above it */
> +		struct __attribute__((__packed__)) {
> +			unsigned short ss;	/* SS selector proper */
> +			unsigned int __ssx_resv1	: 16;
> +			unsigned int vector		: 8;
> +			unsigned int __ssx_resv2	: 8;
> +			unsigned int type		: 4;
> +			unsigned int __ssx_resv3	: 4;
> +			unsigned int enclv		: 1;
> +			unsigned int long_mode		: 1;
> +			unsigned int nested		: 1;
> +			unsigned int __ssx_resv4	: 1;
> +			unsigned int instr_len		: 4;
> +		};
> +	};

This does not match section

    5.2.1 Saving Information on the Regular Stack?

of version 4 and later of the specification.

Thanks,

        tglx
