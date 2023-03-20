Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96CD26C1D18
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 18:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233234AbjCTRBe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 13:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232335AbjCTRA5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 13:00:57 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA7C359D5;
        Mon, 20 Mar 2023 09:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xUjMSY53uMdsGZ0tizNy5AVlfeAaFc1zEGpMOuRlVlg=; b=JJcwL0o8UaiHNXVFL1G8rZFMV7
        XEkgtY98/izFYZDdg5FFCHPjzY7Ov4B7LNHgJEBaOmDBIbqMkm5x1rNgT8nR7P/p5FNXa4w7aBOwq
        uvoZVtzqJ0l8iqwzEsM9V3GwsG24pN1XNuZRFvIeJRsyq2khEpuWnPZifb07wXYFPPvIKGLS/rJ1o
        vL9oj6GOoe7ylIU/l+l1xUBxieCRwn40akxle0qoOrRK99fjNJAlN5Dd3kc6Wg8YxoJR28Fnv5gak
        e+6SBgdEqwldOVIEgCrf3n0vuHDZOANL+v5FGEb36YLE/iauSCo+Aznvm6FEInqopGhfN2n03f7Cq
        ZGB0W01g==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1peIkM-003zsw-0N;
        Mon, 20 Mar 2023 16:52:34 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A0F44300642;
        Mon, 20 Mar 2023 17:52:33 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 88FC5200A76E5; Mon, 20 Mar 2023 17:52:33 +0100 (CET)
Date:   Mon, 20 Mar 2023 17:52:33 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Xin Li <xin3.li@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: Re: [PATCH v5 23/34] x86/fred: update MSR_IA32_FRED_RSP0 during task
 switch
Message-ID: <20230320165233.GS2194297@hirez.programming.kicks-ass.net>
References: <20230307023946.14516-1-xin3.li@intel.com>
 <20230307023946.14516-24-xin3.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230307023946.14516-24-xin3.li@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 06, 2023 at 06:39:35PM -0800, Xin Li wrote:
> From: "H. Peter Anvin (Intel)" <hpa@zytor.com>
> 
> MSR_IA32_FRED_RSP0 is used during ring 3 event delivery, and needs to
> be updated to point to the top of next task stack during task switch.
> 
> Update MSR_IA32_FRED_RSP0 with WRMSR instruction for now, and will use
> WRMSRNS/WRMSRLIST for performance once it gets upstreamed.
> 
> Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
> Tested-by: Shan Kang <shan.kang@intel.com>
> Signed-off-by: Xin Li <xin3.li@intel.com>
> ---
>  arch/x86/include/asm/switch_to.h | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/switch_to.h b/arch/x86/include/asm/switch_to.h
> index 5c91305d09d2..00fd85abc1d2 100644
> --- a/arch/x86/include/asm/switch_to.h
> +++ b/arch/x86/include/asm/switch_to.h
> @@ -68,9 +68,16 @@ static inline void update_task_stack(struct task_struct *task)
>  #ifdef CONFIG_X86_32
>  	this_cpu_write(cpu_tss_rw.x86_tss.sp1, task->thread.sp0);
>  #else
> -	/* Xen PV enters the kernel on the thread stack. */
> -	if (cpu_feature_enabled(X86_FEATURE_XENPV))
> +	if (cpu_feature_enabled(X86_FEATURE_FRED)) {
> +		/*
> +		 * Will use WRMSRNS/WRMSRLIST for performance once it's upstreamed.
> +		 */
> +		wrmsrl(MSR_IA32_FRED_RSP0,
> +		       task_top_of_stack(task) + TOP_OF_KERNEL_STACK_PADDING);
> +	} else if (cpu_feature_enabled(X86_FEATURE_XENPV)) {

Whee, so hardware will really only ever look at this when RSP0? I don't
need to worry about exceptions during context switch?
