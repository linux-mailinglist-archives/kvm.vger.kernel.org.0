Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B342718B85
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 23:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjEaVB5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 17:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjEaVB4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 17:01:56 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCBB7129
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 14:01:54 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-64d20f79776so92046b3a.1
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 14:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685566914; x=1688158914;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RPsQ6EPYMUiLgeo2zRMT4VhAI4osohelzR0bNFLX/6I=;
        b=6ppTg/Sxxij0t2Q5oVqrK15yvdk9vC2x4rFDKFdREe/HzsyfCs/7IGLwF0V1v1sVx1
         EzpP8m1SWfp6OfuOZzC0Ki5sgd4Ezz1flmUt78JIfWRKlspLaVMsraus3/9Fit/j9M8s
         yieCFPjxx/qaODb/k3JlCLGiNY/RI6VMkbWhDoNQzvpHFZ9mLRaCtaCpBnE/WUlvxtwJ
         j00F4dtUDdVNzf7meCs0Kx4ezQiT4NZ1xfVug4jpX3NiCtYXesUBUcE61ep+qQCvH+Mz
         /RTe3K9j4ijMxFa6XL6Bu5n7/WAfYkoQMvmIi2Ubw4nu2VDHWUUXEpcuTmM+fpItOMR0
         FImQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685566914; x=1688158914;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RPsQ6EPYMUiLgeo2zRMT4VhAI4osohelzR0bNFLX/6I=;
        b=mH76mFrx60W0iqHPrFHPBPYHbDZQr0cS4SbmUDb/u7Yxsvala4o7zo6ORxOZdEl2fC
         lvs+s71xIO9rc5Mjz9YuM4Ch37vloZLrZOCxjpvAX6nEbW4g00TKMEV3OnNPBUBx+UfQ
         GV84djImcNByjysyMvYwy0NkJqMLy7Dgjgl1aw0QYXXhc1E9AuHNuQPlii+KPiHyUkVu
         TVKWPxGojVD3/vkBBNhpfCMLd5yW+laV6IuI6XRTWu2EZJ0S11P9M3paEy2pHw1hue8s
         8p/WDxjg3EJOIa6aIJeGBmDgcVgrfAdk2HvyQk5Zjntmij1TVuP/Dd2je3OprDIH9isB
         bxAQ==
X-Gm-Message-State: AC+VfDxum2Hvx3K5GCvDOZk8mz4ZG1r1ESKsqT4ZKjiHqIPhXCcEUWRH
        ueg4GIooNInb6/EDsL6xiy4VRjRf8DY=
X-Google-Smtp-Source: ACHHUZ46Izem4cMqgFx0bm1zSUtrk3N+KaIRpgepafMGONB2yahZ87gDruNIkNVwtrgBQ1vLcw3nrUdUdiI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:3918:b0:641:31b1:e78c with SMTP id
 fh24-20020a056a00391800b0064131b1e78cmr2540104pfb.5.1685566914276; Wed, 31
 May 2023 14:01:54 -0700 (PDT)
Date:   Wed, 31 May 2023 14:01:52 -0700
In-Reply-To: <20230327212635.1684716-3-coltonlewis@google.com>
Mime-Version: 1.0
References: <20230327212635.1684716-1-coltonlewis@google.com> <20230327212635.1684716-3-coltonlewis@google.com>
Message-ID: <ZHe1wEIYC6qsgupI@google.com>
Subject: Re: [PATCH v3 2/2] KVM: selftests: Print summary stats of memory
 latency distribution
From:   Sean Christopherson <seanjc@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Marc Zyngier <maz@kernel.org>, Ben Gardon <bgardon@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 27, 2023, Colton Lewis wrote:
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index f65e491763e0..d441f485e9c6 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -219,4 +219,14 @@ uint32_t guest_get_vcpuid(void);
>  uint64_t cycles_read(void);
>  uint64_t cycles_to_ns(struct kvm_vcpu *vcpu, uint64_t cycles);
> 
> +#define MEASURE_CYCLES(x)			\
> +	({					\
> +		uint64_t start;			\
> +		start = cycles_read();		\
> +		isb();				\

Would it make sense to put the necessary barriers inside the cycles_read() (or
whatever we end up calling it)?  Or does that not make sense on ARM?

> +		x;				\
> +		dsb(nsh);			\
> +		cycles_read() - start;		\
> +	})
> +
>  #endif /* SELFTEST_KVM_PROCESSOR_H */

...

> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index 5d977f95d5f5..7352e02db4ee 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -1137,4 +1137,14 @@ void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
>  uint64_t cycles_read(void);
>  uint64_t cycles_to_ns(struct kvm_vcpu *vcpu, uint64_t cycles);
> 
> +#define MEASURE_CYCLES(x)			\
> +	({					\
> +		uint64_t start;			\
> +		start = cycles_read();		\
> +		asm volatile("mfence");		\

This is incorrect as placing the barrier after the RDTSC allows the RDTSC to be
executed before earlier loads, e.g. could measure memory accesses from whatever
was before MEASURE_CYCLES().  And per the kernel's rdtsc_ordered(), it sounds like
RDTSC can only be hoisted before prior loads, i.e. will be ordered with respect
to future loads and stores.

> +		x;				\
> +		asm volatile("mfence");		\
> +		cycles_read() - start;		\
> +	})
