Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5670A699D69
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 21:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbjBPUNT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 15:13:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjBPUNR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 15:13:17 -0500
Received: from out-243.mta1.migadu.com (out-243.mta1.migadu.com [IPv6:2001:41d0:203:375::f3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E41B4C6D7
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 12:13:16 -0800 (PST)
Date:   Thu, 16 Feb 2023 20:13:10 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1676578394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IuZx0hGMQ8pIcBm1YZvc/96vmy+e9sRNwryOaTY8vek=;
        b=fgVkch1YN0olN+KwSx67+W4ojMkrV42x57Dv6vPCSG43e3BkTLwvc8p0XWj3uh1ndrLm/c
        TV/Vi6b0sKEmJdwboRSdnn+lD2WGOmoI6iE+yAxLhRFl0M7A1lWomnoFGYMIJFGvfPF1zZ
        d6wZlG5H3zobEBwR6xsWQAdsXX9Qjb8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, jthoughton@google.com,
        seanjc@google.com
Subject: Re: [PATCH] selftests/kvm: Fix bug in how demand_paging_test
 calculates paging rate
Message-ID: <Y+6OVtw1kEO99Gah@linux.dev>
References: <20230216200218.1028943-1-amoorthy@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230216200218.1028943-1-amoorthy@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The shortlog doesn't give any hint as to what the bug actually is.
Maybe:

  KVM: selftests: Fix nsec to sec conversion in demand_paging_test

On Thu, Feb 16, 2023 at 08:02:18PM +0000, Anish Moorthy wrote:
> The current denominator is 1E8, not 1E9 as it should be.

  demand_paging_test uses 1E8 as the denominator to convert nanoseconds
  to seconds, which is wrong. Use NSEC_PER_SEC instead to fix the issue
  and make the conversion obvious.

> Reported-by: James Houghton <jthoughton@google.com>
> Signed-off-by: Anish Moorthy <amoorthy@google.com>

Bikeshedding aside:

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

> ---
>  tools/testing/selftests/kvm/demand_paging_test.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> index b0e1fc4de9e29..2439c4043fed6 100644
> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> @@ -194,7 +194,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  		ts_diff.tv_sec, ts_diff.tv_nsec);
>  	pr_info("Overall demand paging rate: %f pgs/sec\n",
>  		memstress_args.vcpu_args[0].pages * nr_vcpus /
> -		((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / 100000000.0));
> +		((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / NSEC_PER_SEC));
>  
>  	memstress_destroy_vm(vm);
>  
> -- 
> 2.39.2.637.g21b0678d19-goog
> 

-- 
Thanks,
Oliver
