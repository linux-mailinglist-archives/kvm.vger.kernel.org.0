Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B44D94A73ED
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 15:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235068AbiBBOyo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 09:54:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbiBBOyn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 09:54:43 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 166D9C061714
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 06:54:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4NRTu9NDuWycXo3UOkDQnCNFotEUhBoje0M8ZiXNNSQ=; b=T/X46IXWDiO8T/3ss4ddS8Ehoj
        Nqge0LGvoAkYjt5ncZ95rX34zhBpp6ek5vjmlAfuv1vimOx7yotX4gJ8SzBNM+w0p5uPZycL6zX8G
        3dm0ClDGo+adpS5JE6QbF8fLJkrCM7iq48GLY3nDlzOKoySKcK18vtH280EkDCYL6TKzV7++Yszyt
        azoSt1JQWXGSg3YMC9jt+YF5mi7ZrZ0SWEOBEhHkOnNOZV6WlS9vs3ESZLFevcjSaDDnx7iBGa62m
        0VFWmZVNXElxEJ6ZiWrY6GgTDltzTyqZLKOyjHF7O3tvuwOIsZoer5ZsHD4WCE2iRrIdBaRdrgNnS
        GA5IwVeg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nFH1S-00ErXA-Pv; Wed, 02 Feb 2022 14:54:15 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id B4209984C61; Wed,  2 Feb 2022 15:54:14 +0100 (CET)
Date:   Wed, 2 Feb 2022 15:54:14 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, tglx@linutronix.de,
        bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org, joro@8bytes.org
Subject: Re: [PATCH][v3] KVM: x86: refine kvm_vcpu_is_preempted
Message-ID: <20220202145414.GD20638@worktop.programming.kicks-ass.net>
References: <1642397842-46318-1-git-send-email-lirongqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1642397842-46318-1-git-send-email-lirongqing@baidu.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 17, 2022 at 01:37:22PM +0800, Li RongQing wrote:
> After support paravirtualized TLB shootdowns, steal_time.preempted
> includes not only KVM_VCPU_PREEMPTED, but also KVM_VCPU_FLUSH_TLB
> 
> and kvm_vcpu_is_preempted should test only with KVM_VCPU_PREEMPTED

This still fails to actually explain what the problem is, why did you
write this patch?

> 
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
> diff with v2: using andl and setnz
> diff with v1: clear 64bit rax
> 
>  arch/x86/kernel/kvm.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index b061d17..fe0aead 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -1025,8 +1025,9 @@ asm(
>  ".type __raw_callee_save___kvm_vcpu_is_preempted, @function;"
>  "__raw_callee_save___kvm_vcpu_is_preempted:"
>  "movq	__per_cpu_offset(,%rdi,8), %rax;"
> -"cmpb	$0, " __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax);"
> -"setne	%al;"
> +"movb	" __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax), %al;"
> +"andl	$" __stringify(KVM_VCPU_PREEMPTED) ", %eax;"
> +"setnz	%al;"

Isn't the below the simpler way of writing that same?

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index a438217cbfac..bc79adcf59ff 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -1025,7 +1025,7 @@ asm(
 ".type __raw_callee_save___kvm_vcpu_is_preempted, @function;"
 "__raw_callee_save___kvm_vcpu_is_preempted:"
 "movq	__per_cpu_offset(,%rdi,8), %rax;"
-"cmpb	$0, " __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax);"
+"testb	$" __stringify(KVM_VCPU_PREEMPTED) ", " __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax);"
 "setne	%al;"
 "ret;"
 ".size __raw_callee_save___kvm_vcpu_is_preempted, .-__raw_callee_save___kvm_vcpu_is_preempted;"
