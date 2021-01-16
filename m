Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F36E42F89B9
	for <lists+kvm@lfdr.de>; Sat, 16 Jan 2021 01:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728443AbhAPAB2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 19:01:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726969AbhAPAB2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 19:01:28 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0BD9C061793
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 16:00:33 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id cq1so5961985pjb.4
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 16:00:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GbcRTwO4Py9PCASiY1YuohO9XCn71Gsdi46hwQnWEl8=;
        b=u6hXBbQKO2N4x8nIBPEaVhO/0sCJTrI6FL+Ens0rAcn+RjZcf9pFfg3xgjKMB5F4u3
         C18ArZDs1Rircdgu01RJPaV2Mxub8HMgAdJrtCipPzVIvWwTsIfq1idVIGENwwnuU3VA
         5OG/JcczDt5zL45Na2Rm9t1Ap5idXZThyG9OCpub4m2iAfXul122zjKDY5cesZWA/jx/
         LTS5V9lsHOM2SLckp65DzRan3RpdRbVvHzvBc308gdiHoT7pLF2jZvQBbS9C6C1v8Aen
         NUhnOLuYEnmntPWE2NZ44W8TXKOfJmt7xKi1zmxEFgI9AIrTUBoHEO2fCdxRrqEuBH8k
         YNyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GbcRTwO4Py9PCASiY1YuohO9XCn71Gsdi46hwQnWEl8=;
        b=diHGeQww6lLCcTJ3AekUpNorYBLNsG5hHNaFl2oNQpqTzuIyBZWxqVc2kGTV2k+Ye1
         mLUtTZIsK7GL5DMucX6Kf3lE9Oo1nL2rO8VI5alc6aIivMWim13k+PkVNl7Bp2xk3eAN
         tO4GbajVh6FVbAuQIN7dYDXAQzo4BolJeY2UWXnv53jyGgA1YWqFdkDsEsMzQay5BRGh
         fbckFiaEmrDayQyRWM6qVmRI5zJAGBeOwRXxt0Ou7YyEvAFkvOBL8VHuI7RPBwnVJ+EB
         RSH9zmf8uyMJSRQnNDexYNuFq5ckxZgc2xmNmXzUbDITZBAb5ylq0hijXwNEeS6UM62k
         /WWw==
X-Gm-Message-State: AOAM531ZYbiSTliFGQDoh+e25ZLwKsRWoOPbFnDMxwtRrc2qwkp0SAIj
        zz9oQE95sRBnVa02ZEDRlV0v1Q==
X-Google-Smtp-Source: ABdhPJwW1D63rhPKUfuQucpNll3MeH9K0by+Htu81WVwB0qMY/SS1W07DD42HefctcLFL0htvuDj1g==
X-Received: by 2002:a17:90b:204:: with SMTP id fy4mr13136166pjb.57.1610755232980;
        Fri, 15 Jan 2021 16:00:32 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id a29sm9016193pfr.73.2021.01.15.16.00.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 16:00:31 -0800 (PST)
Date:   Fri, 15 Jan 2021 16:00:24 -0800
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
Subject: Re: [PATCH 2/6] KVM: selftests: Avoid flooding debug log while
 populating memory
Message-ID: <YAIsmMrB1hwX804F@google.com>
References: <20210112214253.463999-1-bgardon@google.com>
 <20210112214253.463999-3-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112214253.463999-3-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 12, 2021, Ben Gardon wrote:
> Peter Xu pointed out that a log message printed while waiting for the
> memory population phase of the dirty_log_perf_test will flood the debug
> logs as there is no delay after printing the message. Since the message
> does not provide much value anyway, remove it.

Does it provide value if something goes wrong?  E.g. if a vCPU doesn't finish,
how would one go about debugging?  Would it make sense to make the print
ratelimited instead of removing it altogether?
 
> Reviewed-by: Jacob Xu <jacobhxu@google.com>
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_perf_test.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index 16efe6589b43..15a9c45bdb5f 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> @@ -146,8 +146,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  	/* Allow the vCPU to populate memory */
>  	pr_debug("Starting iteration %lu - Populating\n", iteration);
>  	while (READ_ONCE(vcpu_last_completed_iteration[vcpu_id]) != iteration)
> -		pr_debug("Waiting for vcpu_last_completed_iteration == %lu\n",
> -			iteration);
> +		;
>  
>  	ts_diff = timespec_elapsed(start);
>  	pr_info("Populate memory time: %ld.%.9lds\n",
> @@ -171,9 +170,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>  
>  		pr_debug("Starting iteration %lu\n", iteration);
>  		for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
> -			while (READ_ONCE(vcpu_last_completed_iteration[vcpu_id]) != iteration)
> -				pr_debug("Waiting for vCPU %d vcpu_last_completed_iteration == %lu\n",
> -					 vcpu_id, iteration);
> +			while (READ_ONCE(vcpu_last_completed_iteration[vcpu_id])
> +			       != iteration)

I like the original better.  Poking out past 80 chars isn't the end of the world.

> +				;
>  		}
>  
>  		ts_diff = timespec_elapsed(start);
> -- 
> 2.30.0.284.gd98b1dd5eaa7-goog
> 
