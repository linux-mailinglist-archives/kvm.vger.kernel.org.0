Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15AF1651DF5
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 10:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233324AbiLTJtQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 04:49:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233482AbiLTJtE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 04:49:04 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5775D15FEC;
        Tue, 20 Dec 2022 01:48:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=CDEWKy3f1j+rMvWE2BFmn93ICBXtlTPwxsYai1OPD+w=; b=DNNtWJsE1HRjRGp2bWBHoH9eEU
        bH2i4QKHD5hYgFy3K9O1oPoK5JmsiYbaoQWHVUd7VXqfM9S5QmRp+B2wXvYlrd/xFizgui2TaQxTm
        mp15icy2JW8AyhrVD0PwOaD6JVAM8HNJTQ6ZmlHHwL3kIrsrzb5aO0q58KxZLGp8ytxnaVznSx9ug
        L6jYdReo0bN5N1g78yESk2MwmePNaiRfkWcDkowMEwWaO0WSBOsb38EMGIXtaFaf/iypnciwE/ZJx
        QqF2MQNCt0boiRWkZsFrB+xqRcPEO/nvrbGs9cRZeEyA42jsdFzZvWaV8j0lJnz68nM+Qk6K7iojv
        aRMc77Ng==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p7ZF1-001fWO-3x; Tue, 20 Dec 2022 09:48:55 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 634E6300322;
        Tue, 20 Dec 2022 10:48:44 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 4C0172C5F840A; Tue, 20 Dec 2022 10:48:44 +0100 (CET)
Date:   Tue, 20 Dec 2022 10:48:44 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Xin Li <xin3.li@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: Re: [RFC PATCH 23/32] x86/fred: update MSR_IA32_FRED_RSP0 during
 task switch
Message-ID: <Y6GE/Fnl1tuER1fF@hirez.programming.kicks-ass.net>
References: <20221220063658.19271-1-xin3.li@intel.com>
 <20221220063658.19271-24-xin3.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221220063658.19271-24-xin3.li@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 19, 2022 at 10:36:49PM -0800, Xin Li wrote:
> From: "H. Peter Anvin (Intel)" <hpa@zytor.com>
> 
> MSR_IA32_FRED_RSP0 is used during ring 3 event delivery, and needs to
> be updated to point to the top of next task stack during task switch.
> 
> Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
> Signed-off-by: Xin Li <xin3.li@intel.com>
> ---
>  arch/x86/include/asm/switch_to.h | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/switch_to.h b/arch/x86/include/asm/switch_to.h
> index c08eb0fdd11f..c28170d4fbba 100644
> --- a/arch/x86/include/asm/switch_to.h
> +++ b/arch/x86/include/asm/switch_to.h
> @@ -71,9 +71,13 @@ static inline void update_task_stack(struct task_struct *task)
>  	else
>  		this_cpu_write(cpu_tss_rw.x86_tss.sp1, task->thread.sp0);
>  #else
> -	/* Xen PV enters the kernel on the thread stack. */
> -	if (static_cpu_has(X86_FEATURE_XENPV))
> +	if (cpu_feature_enabled(X86_FEATURE_FRED)) {
> +		wrmsrl(MSR_IA32_FRED_RSP0,
> +		       task_top_of_stack(task) + TOP_OF_KERNEL_STACK_PADDING);

Urgh, I'm assuming this is a *fast* MSR ?

> +	} else if (static_cpu_has(X86_FEATURE_XENPV)) {
> +		/* Xen PV enters the kernel on the thread stack. */
>  		load_sp0(task_top_of_stack(task));
> +	}
>  #endif


