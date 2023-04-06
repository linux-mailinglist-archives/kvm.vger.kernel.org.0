Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 867996D936D
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 11:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235037AbjDFJ7D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 05:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236815AbjDFJ6g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 05:58:36 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCFD5F2
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 02:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=CjLt84RiRyxldXMKUF4cmFCuGUjjQ0mfTSV3z2MLGa0=; b=di3XEW1BnkbllOXQU7WwCLekOO
        tpqNLlkfEtNuCUmB98FaYNklfRddZyF48hLUVaNq1VXe8t7GRMMtFyAUUKbF2h0jpr4Duk32nDv/a
        VV8wlF8qQTurX0voiK26y8zxUX8KROsjyS0xf1OBQrJ1wVY0Nx1ijf/FK7IwFOob28VzdqR0oIbvI
        0oZjtzlkpTbqbDn3Nac4xfjQ1adNxi/DbBvxfcqmvKhNb1AsiohafnF+rUmZSoU8Yv9l75hdft1Il
        IIHCeOB4kLt6EB8ra0WHEfVdVBHCDUOzXLllz+4pt8eWLvNMOJnkgF1wGdZdT2M+i7Xbhkhj0iNmw
        cicYNr+g==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pkMMi-00AUYY-2s;
        Thu, 06 Apr 2023 09:57:14 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id D1A9F30008D;
        Thu,  6 Apr 2023 11:57:11 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id B7BC220B6A7D6; Thu,  6 Apr 2023 11:57:11 +0200 (CEST)
Date:   Thu, 6 Apr 2023 11:57:11 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     lirongqing@baidu.com
Cc:     pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        kvm@vger.kernel.org, seanjc@google.com
Subject: Re: [PATCH][v2] x86/kvm: Don't check vCPU preempted if vCPU has
 dedicated pCPU and non-trap HLT
Message-ID: <20230406095711.GH386572@hirez.programming.kicks-ass.net>
References: <1680766393-46220-1-git-send-email-lirongqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1680766393-46220-1-git-send-email-lirongqing@baidu.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 06, 2023 at 03:33:13PM +0800, lirongqing@baidu.com wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> Check whether vCPU is preempted or not only when HLT is trapped or
> there is not realtime hint. In other words, it is unnecessary to check
> preemption when vCPU has realtime hint (which means vCPU has dedicated
> pCP) and has not PV_UNHALT (which means unintercepted HLT), because
> vCPU should not to be marked as preempted in this setup.

To what benefit?

> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
> diff with v1: rewrite changelog and indentation
> 
>  arch/x86/kernel/kvm.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 1cceac5..25398d2 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -820,8 +820,10 @@ static void __init kvm_guest_init(void)
>  		has_steal_clock = 1;
>  		static_call_update(pv_steal_clock, kvm_steal_clock);
>  
> -		pv_ops.lock.vcpu_is_preempted =
> -			PV_CALLEE_SAVE(__kvm_vcpu_is_preempted);
> +		if (kvm_para_has_feature(KVM_FEATURE_PV_UNHALT) ||
> +			!kvm_para_has_hint(KVM_HINTS_REALTIME))

This is atrocious coding style, please align on the (.

> +			pv_ops.lock.vcpu_is_preempted =
> +				PV_CALLEE_SAVE(__kvm_vcpu_is_preempted);
>  	}
>  
>  	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
> -- 
> 2.9.4
> 
