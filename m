Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D73F848C46C
	for <lists+kvm@lfdr.de>; Wed, 12 Jan 2022 14:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353356AbiALNJt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 08:09:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240733AbiALNJq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 08:09:46 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD782C06173F
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 05:09:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=oD/U/8qWYbQSNLeqFK0ErPfzksUGLjaqCHwLNE+dK2o=; b=cIIQZT+7YkwmwKsSsmzuKir/wN
        eqfLMV7fOx79QNE72LoOEgprAHnAZ7yx6f+/5+t0XZwgjQJojewoaUukPTrBJvTZ3uWFKLwkYhRle
        ePTJmJgqlA780yQSC0udiNr0TycRkCzOK7+oSRud6U0W3CbVXVZj1OMyjei1Z7zHhAynEmPAmZp28
        p4Bc69OCvjxYVrEadyk0RzQ4LROL22bUKgv6T6ohkQ+rb17blJ1VagOrhTwA81zvvO73DphDAgxFf
        GAzFLIA+delbwzGV0V5VxTJLeE+FpsQsBSXPYCmphC0aFiSKwZeZoStLi/ko0iGdiI/q4Id7urc89
        8cb1gkjA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n7dN4-000nx0-NV; Wed, 12 Jan 2022 13:08:58 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 97E253001FD;
        Wed, 12 Jan 2022 14:08:54 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 6D9FD2133FEF6; Wed, 12 Jan 2022 14:08:54 +0100 (CET)
Date:   Wed, 12 Jan 2022 14:08:54 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, tglx@linutronix.de,
        bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org, joro@8bytes.org
Subject: Re: [PATCH] KVM: X86: set vcpu preempted only if it is preempted
Message-ID: <Yd7S5rEYZg8v93NX@hirez.programming.kicks-ass.net>
References: <1641988921-3507-1-git-send-email-lirongqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1641988921-3507-1-git-send-email-lirongqing@baidu.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 12, 2022 at 08:02:01PM +0800, Li RongQing wrote:
> vcpu can schedule out when run halt instruction, and set itself
> to INTERRUPTIBLE and switch to idle thread, vcpu should not be
> set preempted for this condition

Uhhmm, why not? Who says the vcpu will run the moment it becomes
runnable again? Another task could be woken up meanwhile occupying the
real cpu.

> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> Signed-off-by: Wang GuangJu <wangguangju@baidu.com>
> ---
>  arch/x86/kvm/x86.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9f5dbf7..10d76bf 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4407,6 +4407,9 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
>  	if (vcpu->arch.st.preempted)
>  		return;
>  
> +	if (!vcpu->preempted)
> +		return;
> +
>  	/* This happens on process exit */
>  	if (unlikely(current->mm != vcpu->kvm->mm))
>  		return;
> -- 
> 2.9.4
> 
