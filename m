Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B83E3566FF
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 10:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349623AbhDGIlI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 04:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231909AbhDGIlG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 04:41:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB30C06174A;
        Wed,  7 Apr 2021 01:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=pm5+BhR2cUpRyMJC2aIbNNtM1LjZJ9DWAVkZw86zhBE=; b=CI5xZ1RXdGdwTpFA766l3JgwrG
        zo8qhk2L0zX9WsU/pD2KeXwR7ZZTV4YKaE8pXlTiusWDAOV4pdb6Vk/bTOwxJvLeqlciBH0xUjNVI
        Y8nZ6R0gfcYma3Omn2gStLFmxgcQ+dbIt4+r8E2qgQ1P9sz/wYzyNW8vmdzanUU7VqBiHKVKc8sMV
        1bCzhFMdws7SmGj0oIRWmQOMEhz6NxcNFmf3cP4Man4zI/x5gRrr4Ll9FusgaPXF4UHMwWjSlWvdY
        T3Lvl+/EARw7NcJ0m08ozE30L54q7PEPHQLYUwzdL/hFk/tNNQQVbg0aJSbKfGdh1XLSnoAY0i/4Y
        7CvDZlcQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lU3jG-00EBC2-NY; Wed, 07 Apr 2021 08:40:06 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 176E9300119;
        Wed,  7 Apr 2021 10:40:01 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 0237424403D8F; Wed,  7 Apr 2021 10:40:00 +0200 (CEST)
Date:   Wed, 7 Apr 2021 10:40:00 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        andi@firstfloor.org, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v4 06/16] KVM: x86/pmu: Reprogram guest PEBS event to
 emulate guest PEBS counter
Message-ID: <YG1v4KFCPSoKcoyd@hirez.programming.kicks-ass.net>
References: <20210329054137.120994-1-like.xu@linux.intel.com>
 <20210329054137.120994-7-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210329054137.120994-7-like.xu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 29, 2021 at 01:41:27PM +0800, Like Xu wrote:

> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 827886c12c16..3509b18478b9 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -74,11 +74,20 @@ static void kvm_perf_overflow_intr(struct perf_event *perf_event,
>  {
>  	struct kvm_pmc *pmc = perf_event->overflow_handler_context;
>  	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
> +	bool skip_pmi = false;
>  
>  	if (!test_and_set_bit(pmc->idx, pmu->reprogram_pmi)) {
> -		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
> +		if (perf_event->attr.precise_ip) {
> +			/* Indicate PEBS overflow PMI to guest. */
> +			skip_pmi = test_and_set_bit(GLOBAL_STATUS_BUFFER_OVF_BIT,
> +				(unsigned long *)&pmu->global_status);

Is there actual concurrency here, or did you forget to type __?

And in case you're using vim, use something like: set cino=(0:0

> +		} else
> +			__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
>  		kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
>  
> +		if (skip_pmi)
> +			return;
> +
>  		/*
>  		 * Inject PMI. If vcpu was in a guest mode during NMI PMI
>  		 * can be ejected on a guest mode re-entry. Otherwise we can't
