Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA90669811F
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 17:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjBOQow (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 11:44:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjBOQou (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 11:44:50 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8185020D13
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 08:44:49 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id u6-20020a170903124600b00188cd4769bcso10954316plh.0
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 08:44:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=t8DMcJvXOt1uVMYd5lzHsJnF9jrZA0JOd1Wq9dyU57Y=;
        b=WoRu9NpYfvK6J7R6Hjg/lqXmtWSjFmIjHU2Co8CI2GzDjhbDr+vBMUWmeO1JI0psis
         L86WT9EvkHym4MiCd+N49yB7UaWK4XEkKss6gjM2GjoxmzxLW6DofNQ0BScuDnGDWTkL
         m203gZvFo7D0YemQZg96lVgyrB2rwF3q9QkcSVLcbUGCR7yexx/c0+bAQDYQFYroDKUU
         MZWQByGYoptU9v021DZtiGN1+sbig7mL/ZWIvMCkJMUKZDFvyBBLtyUvouKFwwym4Ib+
         5iJqFRO9/VLw8UKxjgH46tUGdUKGWgry3LhdlTKTaIHzy71rmAqj20l0dfvkyECUsZby
         hvKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t8DMcJvXOt1uVMYd5lzHsJnF9jrZA0JOd1Wq9dyU57Y=;
        b=SorN9zJFumN+nH2G1OIrqr4B8NThxF29c9OfQJvQ8GM/oguZS9RAaYlPK6K8e5913P
         dR6Bko3cmiwJS8SskXx3ySA+f7DyBf6sZrkudHfnviL4jhfGtjbY9FO1Omj/x9l78/zu
         BDmaF1nw8vnw9PloR/5+ZTnB7QWqu3jcRecfv4uEtcnnenllNm2yC5z+ki8aiYx8feHq
         0ixrWf8rHpA3rXjgjw0toQVfo/TZeUDLvRcaYwN6kSC0+ROjP8StYgBHdP80QLrcPmrr
         3pgbHnTCECIXXK6r86Pukxqn5KYGVVLden2LieTkKeDc6X1Y/4RgcmBc9kMiPsUb+fP3
         V6Kg==
X-Gm-Message-State: AO0yUKXk6WDyao7N1WarQ1mtkEXwRr2Z6wDD4iLJxVzjHsobBcS+oVua
        PEbqTPUOut5NMeAwfbyeM0LRaCzjXk4=
X-Google-Smtp-Source: AK7set9mz6oE4Te7rt9n1BbiU/9ZQWLHMawumtBwjGTY9V0SWl+h2f3S7YMuaoevJRHcJm0SIwnMhfdvhvA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:bf0b:0:b0:4ce:ca8b:432b with SMTP id
 v11-20020a63bf0b000000b004ceca8b432bmr244899pgf.10.1676479488932; Wed, 15 Feb
 2023 08:44:48 -0800 (PST)
Date:   Wed, 15 Feb 2023 08:44:47 -0800
In-Reply-To: <Y+yJU2pE4IyuIwOQ@linux.dev>
Mime-Version: 1.0
References: <20230215011614.725983-1-amoorthy@google.com> <20230215011614.725983-2-amoorthy@google.com>
 <Y+yJU2pE4IyuIwOQ@linux.dev>
Message-ID: <Y+0L/x2YgiEgm9bt@google.com>
Subject: Re: [PATCH 1/8] selftests/kvm: Fix bug in how demand_paging_test
 calculates paging rate
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Anish Moorthy <amoorthy@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Houghton <jthoughton@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 15, 2023, Oliver Upton wrote:
> Hi Anish,
> 
> On Wed, Feb 15, 2023 at 01:16:07AM +0000, Anish Moorthy wrote:
> > Currently we're dividing tv_nsec by 1E8, not 1E9.
> > 
> > Reported-by: James Houghton <jthoughton@google.com>
> > Signed-off-by: Anish Moorthy <amoorthy@google.com>
> > ---
> >  tools/testing/selftests/kvm/demand_paging_test.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> > index b0e1fc4de9e29..6809184ce2390 100644
> > --- a/tools/testing/selftests/kvm/demand_paging_test.c
> > +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> > @@ -194,7 +194,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
> >  		ts_diff.tv_sec, ts_diff.tv_nsec);
> >  	pr_info("Overall demand paging rate: %f pgs/sec\n",
> >  		memstress_args.vcpu_args[0].pages * nr_vcpus /
> > -		((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / 100000000.0));
> > +		((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / 1E9));
> 
> Use NSEC_PER_SEC instead so the conversion taking place is immediately
> obvious.

And please post this separately, it's a fix that's independent of the rest of the
series and can/should be applied sooner than later.

Thanks!
