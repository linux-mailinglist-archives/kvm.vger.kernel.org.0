Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A11D3FC39E
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 10:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239780AbhHaHX5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 03:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239538AbhHaHX4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Aug 2021 03:23:56 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5752C061575;
        Tue, 31 Aug 2021 00:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YP6sLmbHZ4duSfp82g4uPYGB5Sa9IzFIjpbC3uLKhbA=; b=gXi1Ta1sRiqw9f0pfzVKNSvRTc
        ++Ja+GLsArYf7mZElfpA2Eu1ZME4zRyTaqRWDmEdBfH0bd/FqBv0xIeR2V97jUJENX95O/H8TFSRQ
        pmxF8uZ4FJaEozNlZ8WBQa5HEc+HLbW+ZY68A1mQTbMe1pWn/WkQxerBMpWv/Sdt9tSCqCfv63hWl
        O+qP7R0AK4u0g6ws5JOGjdNxO3XdL+vWW1DxXeSxnSsoJPxT7kNBTh1L8tDv1Q81qYMxskMFk6j/j
        QtoCMFxRMFcwGts3cNAN21GeNaxofh9ci/TGQPhzuRGJXKvGQAiPxzXvTmiffZTyJdgLq6Ys3nAHv
        OiqmRTFg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mKy52-000x7F-7R; Tue, 31 Aug 2021 07:21:25 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id CFDB63001F6;
        Tue, 31 Aug 2021 09:21:11 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id B60542CFB41A3; Tue, 31 Aug 2021 09:21:11 +0200 (CEST)
Date:   Tue, 31 Aug 2021 09:21:11 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Tianqiang Xu <skyele@sjtu.edu.cn>
Cc:     x86@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, kvm@vger.kernel.org, hpa@zytor.com,
        jarkko@kernel.org, dave.hansen@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org
Subject: Re: [PATCH 4/4] KVM guest implementation
Message-ID: <YS3YZ+0pJjNL4ouE@hirez.programming.kicks-ass.net>
References: <20210831015919.13006-1-skyele@sjtu.edu.cn>
 <20210831015919.13006-4-skyele@sjtu.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210831015919.13006-4-skyele@sjtu.edu.cn>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 31, 2021 at 09:59:19AM +0800, Tianqiang Xu wrote:
> Guest OS uses 'is_idle' field of kvm_steal_time to know if a pCPU
> is idle and decides whether to schedule a task to a preempted vCPU
> or not. If the pCPU is idle, scheduling a task to this pCPU will
> improve cpu utilization. If not, avoiding scheduling a task to this
> preempted vCPU can avoid host/guest switch, hence improving performance.
> 
> Guest OS invokes available_idle_cpu_sched() to get the value of
> 'is_idle' field of kvm_steal_time.
> 
> Other modules in kernel except kernel/sched/fair.c which invokes
> available_idle_cpu() is left unchanged, because other modules in
> kernel need the semantic provided by 'preempted' field of kvm_steal_time.

> ---
>  kernel/sched/fair.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)

Goes and replaces every single available_idle_cpu() in fair with the new
function that doesn't consider vCPU preemption.

So what do you reckon now happens in the oversubscribed virt scenario
where each CPU has multiple vCPUs?
