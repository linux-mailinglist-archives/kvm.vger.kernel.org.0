Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC00E2F89C0
	for <lists+kvm@lfdr.de>; Sat, 16 Jan 2021 01:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725863AbhAPADj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 19:03:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbhAPADi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 19:03:38 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247CAC0613D3
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 16:02:58 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id c22so6997767pgg.13
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 16:02:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WFx/F2a337GN3zwqNOD7iXQOOHYeEmZ62a3KeLo+VSA=;
        b=FAl4ne1TgJ+b6aXfP13BMx6boigr8gF546SOdYwutRbfGMrVLhW5/YQjeSCWv9MnJK
         fjFVkqfMPw5o20cOsu/oHvxPktKjsd2hCc5ZJDnT4CU74ljPGK9iapSbE39IM4+oTtZu
         jOXOPR9Y4ji6K0HpHLeXAAkA2XA1e9IbLr0+pXxq8NJt4mk80e3WpXtsnpODU+ickgi/
         F75TATcI3RC/TvTZKJD1polGq28uoA2F/c8kxHWW1OKWwWztzfvZjLadeWFKbCQ6w+kr
         eL2dc8CPW+8iU1nxypJStahsZHCbLeJjtmtcyvhtCbv8MhVpK2uWkC+HNfHsch/Qr0L5
         aRSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WFx/F2a337GN3zwqNOD7iXQOOHYeEmZ62a3KeLo+VSA=;
        b=LejbimbLUBiQLVv5S2idgjCae2dTFz1JcMM4BFpNjSckDac6Mu2bVs0egrJHqvTJKo
         jjzaN85oM0ub0WLhXUbOfdL56fJI+a46+qO82aZBufporLnKDGFd2a5ZiTIBR+MVxrHr
         eqHOmSo4n0M4upIuRptcjpxzQtke08wL4zT/u5WG752RNKQQiPwW2eZm9a7kUt5vj2n0
         dQNtEQ8BL98BpX1/q5oxomOMGPhAXntrMLOSS7f1aZG18ilxBNTWM+nHnC7tKbdAP+Hy
         6sLRMh6XkVXOL/Q7LP2I1lkhG31S6gIcIkyBVH29oSo7NyKsizL1kbZq1r1VqOpsGARz
         PRjg==
X-Gm-Message-State: AOAM530tWnvZe+iLhlY7Ewc6wNvs4NxY4yZOQyYRU5SeJxLQrGKsv7JP
        LzixMSHudQu4h43IYkuhjuebcg==
X-Google-Smtp-Source: ABdhPJz5JLyoykloTcJIV6mJIvCkLo2bUWGXy25NqJDkE7lNF5Uy2EU7DNr/+lXYQrUVAjngZjTEzw==
X-Received: by 2002:a62:cd49:0:b029:1b5:4e48:6f1a with SMTP id o70-20020a62cd490000b02901b54e486f1amr1640904pfg.14.1610755377518;
        Fri, 15 Jan 2021 16:02:57 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id 19sm8981531pfu.85.2021.01.15.16.02.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 16:02:56 -0800 (PST)
Date:   Fri, 15 Jan 2021 16:02:50 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Huth <thuth@redhat.com>, Jacob Xu <jacobhxu@google.com>,
        Makarand Sonare <makarandsonare@google.com>
Subject: Re: [PATCH 4/6] KVM: selftests: Fix population stage in
 dirty_log_perf_test
Message-ID: <YAItKpyPGkxevK2T@google.com>
References: <20210112214253.463999-1-bgardon@google.com>
 <20210112214253.463999-5-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112214253.463999-5-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 12, 2021, Ben Gardon wrote:
> Currently the population stage in the dirty_log_perf_test does nothing
> as the per-vCPU iteration counters are not initialized and the loop does
> not wait for each vCPU. Remedy those errors.
> 
> Reviewed-by: Jacob Xu <jacobhxu@google.com>
> Reviewed-by: Makarand Sonare <makarandsonare@google.com>
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_perf_test.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index 3875f22d7283..fb6eb7fa0b45 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> @@ -139,14 +139,19 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  
>  	clock_gettime(CLOCK_MONOTONIC, &start);
>  	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
> +		vcpu_last_completed_iteration[vcpu_id] = -1;
> +
>  		pthread_create(&vcpu_threads[vcpu_id], NULL, vcpu_worker,
>  			       &perf_test_args.vcpu_args[vcpu_id]);
>  	}
>  
> -	/* Allow the vCPU to populate memory */
> +	/* Allow the vCPUs to populate memory */
>  	pr_debug("Starting iteration %d - Populating\n", iteration);
> -	while (READ_ONCE(vcpu_last_completed_iteration[vcpu_id]) != iteration)
> -		;
> +	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
> +		while (READ_ONCE(vcpu_last_completed_iteration[vcpu_id]) !=
> +		       iteration)

Same comment as earlier.  I vote to let this poke out, or shorten the variables
so that the lines aren't so long.

> +			;
> +	}
>  
>  	ts_diff = timespec_elapsed(start);
>  	pr_info("Populate memory time: %ld.%.9lds\n",
> -- 
> 2.30.0.284.gd98b1dd5eaa7-goog
> 
