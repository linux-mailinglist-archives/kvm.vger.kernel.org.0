Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 789805A6B53
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 19:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiH3RyG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 13:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbiH3Rx1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 13:53:27 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B829C2F7
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 10:50:54 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id r22so11331160pgm.5
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 10:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=YV/f5sqbKEGWBuvtfcm8tiZZc5uH22weT2bMAIJ+E6o=;
        b=ZMdpOak96virr1fYYhL/yKe+y0694FCFTHASlf+g2MT2vqnWV2UlratX4rqVrcYi8n
         Cx30bnwgOdk9t1/GVvWA5X1AVpPU8i6ONiSQvIzCqpyTCI580nuKZI9TOnzzeDu159B7
         I7tURtKM7JulRI6tfitCB7brGnvvKqQfl/+zHmac3Av9yblW4Vstj7sEzNOE5DRk2kHR
         gmSPjnrgsPX6u5fD3IC+bfouEdjsw0h+GFDUjmy47NeQSjCzQYl6meA+DAwarqoujl+P
         rWJzboEX7l4chW3OZGlVHziGIOLOUG2h2bXncMXIAyHlM6HZMGoIW+2wf1mRLw8OL9nK
         z9iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=YV/f5sqbKEGWBuvtfcm8tiZZc5uH22weT2bMAIJ+E6o=;
        b=EUOKiIsnBl1cx+e2z/SVsqbthFwyj4ee24FIYHmKu3Da8w3wzejjla6XeqmPiBRK2c
         F5zSlurgggfOxJW1Yvu6qu1feQ7opqlMgOhEpz6xz2Ntu1zU6Y55ojwnR5SHLab1WTiP
         a9YNOHRm4/w/lOLfNqdhVSNdVHLGNJCV6zSNYIni6jq+zq8JKLRLC/QhTg5tOTxMausR
         eLprs9tL2DeqTVmppu9KBuQ8J0gzt3IiCYTa2fbndGFOhSMGZUTnP8NSceAOWBwmP2WZ
         AjE6QpakkHPzWaYmqj+wnk1F3jxr8nR+BJAYRJohNyCkDMkbWf7ui9vD+obKXlIu+hGS
         kPQg==
X-Gm-Message-State: ACgBeo1JPA1ISJpMTe9xo4cJq1RhsIAMebwcirIrbLwJCSSOzL5dtFWk
        ggaQkZFpUI7p+pRmOKZ5V8ZwdTyqfnYeNg==
X-Google-Smtp-Source: AA6agR7qc1K9kDv0X0SZZtIw5hC84df7zBBoNGZqaC4KZQb3eZkQzVTWu8J3CrDvrLyuL7nxaLXATw==
X-Received: by 2002:a63:4f24:0:b0:429:aee9:f59a with SMTP id d36-20020a634f24000000b00429aee9f59amr18155504pgb.180.1661881853427;
        Tue, 30 Aug 2022 10:50:53 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u123-20020a626081000000b0053813de1fdasm5869347pfb.28.2022.08.30.10.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 10:50:52 -0700 (PDT)
Date:   Tue, 30 Aug 2022 17:50:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH RESEND v2 5/8] KVM: x86/pmu: Defer reprogram_counter() to
 kvm_pmu_handle_event()
Message-ID: <Yw5N+eGfOsCgtHpw@google.com>
References: <20220823093221.38075-1-likexu@tencent.com>
 <20220823093221.38075-6-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823093221.38075-6-likexu@tencent.com>
X-Spam-Status: No, score=-14.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 23, 2022, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> During a KVM-trap from vm-exit to vm-entry, requests from different
> sources will try to create one or more perf_events via reprogram_counter(),
> which will allow some predecessor actions to be undone posteriorly,
> especially repeated calls to some perf subsystem interfaces. These
> repetitive calls can be omitted because only the final state of the
> perf_event and the hardware resources it occupies will take effect
> for the guest right before the vm-entry.
> 
> To realize this optimization, KVM marks the creation requirements via
> an inline version of reprogram_counter(), and then defers the actual
> execution with the help of vcpu KVM_REQ_PMU request.

Use imperative mood and state what change is being made, not what KVM's behavior
is as a result of the change.

And this is way more complicated than it needs to be, and it also neglects to
call out that the deferred logic is needed for a bug fix.  IIUC:

  Batch reprogramming PMU counters by setting KVM_REQ_PMU and thus deferring
  reprogramming kvm_pmu_handle_event() to avoid reprogramming a counter
  multiple times during a single VM-Exit.

  Deferring programming will also allow KVM to fix a bug where immediately
  reprogramming a counter can result in sleeping (taking a mutex) while
  interrupts are disabled in the VM-Exit fastpath.

> Opportunistically update related comments to avoid misunderstandings.
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index d9b9a0f0db17..6940cbeee54d 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -101,7 +101,7 @@ static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
>  	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
>  	bool skip_pmi = false;
>  
> -	/* Ignore counters that have been reprogrammed already. */
> +	/* Ignore counters that have not been reprogrammed. */

Eh, just drop this comment, it's fairly obvious what the code is doing and your
suggested comment is wrong in the sense that the counters haven't actually been
reprogrammed, i.e. it should be:

	/* Ignore counters that don't need to be reprogrammed. */

but IMO that's pretty obvious.

>  	if (test_and_set_bit(pmc->idx, pmu->reprogram_pmi))
>  		return;
>  
> @@ -293,7 +293,7 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
>  	return allow_event;
>  }
>  
> -void reprogram_counter(struct kvm_pmc *pmc)
> +static void __reprogram_counter(struct kvm_pmc *pmc)

This is misleading.  Double-underscore variants are usually inner helpers, whereas
these have a different relationship.

Instaed of renaming reprogram_counter(), how about introcuing

	kvm_pmu_request_counter_reprogam()

to make it obvious that KVM is _requesting_ a reprogram and not actually doing
the reprogram.
