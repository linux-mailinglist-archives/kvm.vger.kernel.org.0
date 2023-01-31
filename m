Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51125682B13
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 12:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbjAaLDR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 06:03:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbjAaLDL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 06:03:11 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91BEF34019;
        Tue, 31 Jan 2023 03:03:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vCRGwPB48G8ENg7hpO4WTSPW8dw9Fpx61HJzCq4ErcE=; b=MpRQT7CLqyIGbs1gC+In9RUbkM
        sKXGBTlsXq+UNo/3A4QifDSq41T1OQcRWvnRXtrLdVTv1RFIjRh0p4oAr1hbfF3Jn2zK+YySZY+aK
        d+E6AJzaXxLhBWZNZ0hMZMZWsZMfSQ23RO/IXCO9EPCI0dvhidmdaM7hMLpU4+fwwFd9sQto9Benw
        KZtzzyJgf7mbfbojJLjQEeTCSBXyMXmOIGbK0OHFqqoZeWb945ve9k4lcUJdwSxk5up7tpI7uCbh7
        F2zorzXEXfsbcjU0D154FBYJWZn10zanD72QqgfYc6VUKVKrUvJFicSsAL+EUIIbksz0Hjwl7WmQq
        E9xRZysQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pMoPo-00BFYL-UW; Tue, 31 Jan 2023 11:03:05 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id EAC7430012F;
        Tue, 31 Jan 2023 12:03:04 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id CC065240A5DFC; Tue, 31 Jan 2023 12:03:04 +0100 (CET)
Date:   Tue, 31 Jan 2023 12:03:04 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jianfeng Gao <jianfeng.gao@intel.com>
Subject: Re: [PATCH v2] KVM: x86/pmu: Disable all vPMU features support on
 Intel hybrid CPUs
Message-ID: <Y9j1aA84e8WG+FCr@hirez.programming.kicks-ass.net>
References: <20230131085031.88939-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131085031.88939-1-likexu@tencent.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 31, 2023 at 04:50:31PM +0800, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> Disable KVM support for virtualizing PMUs on hosts with hybrid PMUs until
> KVM gains a sane way to enumeration the hybrid vPMU to userspace and/or
> gains a mechanism to let userspace opt-in to the dangers of exposing a
> hybrid vPMU to KVM guests.
> 
> Virtualizing a hybrid PMU, or at least part of a hybrid PMU, is possible,
> but it requires userspace to pin vCPUs to pCPUs to prevent migrating a
> vCPU between a big core and a little core, requires the VMM to accurately
> enumerate the topology to the guest (if exposing a hybrid CPU to the
> guest), and also requires the VMM to accurately enumerate the vPMU
> capabilities to the guest.
> 
> The last point is especially problematic, as KVM doesn't control which
> pCPU it runs on when enumerating KVM's vPMU capabilities to userspace.
> For now, simply disable vPMU support on hybrid CPUs to avoid inducing
> seemingly random #GPs in guests.
> 
> Reported-by: Jianfeng Gao <jianfeng.gao@intel.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Like Xu <likexu@tencent.com>

This seems reasonable; Paolo, will you take this through the KVM tree?

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

> ---
> v1: https://lore.kernel.org/all/20230120004051.2043777-1-seanjc@google.com/
>  arch/x86/kvm/pmu.h | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index 79988dafb15b..6a3995657e1e 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -166,9 +166,11 @@ static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
>  
>  	 /*
>  	  * For Intel, only support guest architectural pmu
> -	  * on a host with architectural pmu.
> +	  * on a non-hybrid host with architectural pmu.
>  	  */
> -	if ((is_intel && !kvm_pmu_cap.version) || !kvm_pmu_cap.num_counters_gp)
> +	if (!kvm_pmu_cap.num_counters_gp ||
> +	    (is_intel && (!kvm_pmu_cap.version ||
> +			  boot_cpu_has(X86_FEATURE_HYBRID_CPU))))
>  		enable_pmu = false;
>  
>  	if (!enable_pmu) {
> -- 
> 2.39.1
> 
