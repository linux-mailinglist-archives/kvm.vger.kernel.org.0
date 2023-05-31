Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43B98718B84
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 22:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjEaU5K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 16:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjEaU5I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 16:57:08 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF95129
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 13:57:08 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-53fa2d0c2ebso49316a12.1
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 13:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685566627; x=1688158627;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hXSlW5uRq1euI1p2NcqjuOnX6YJKbiTwoTtcD+Lazoc=;
        b=WlPBJkA/uDDPtLHMI6CoAg/7iA4M2p6Cd5SHv5FCSNAB4VZpfbRDqCcvJW5chltA/s
         H9oOjT+4nPFyoQtr4e1dqUVmEihoRtKupba2QeP7qOFYHjTPA95oPVJIrZXvK4nfTcBM
         Vud07Spx23Z6jGjJl/PXYGBn8t11x4kOewJg2wX1A6THCQBch1beNqxsF2mFIR4fzo0L
         H5AWWD5pL5F5WT6a5+mAjHWDLK9eidHfHJS98oFI8unPRwkIPU+zhsPf3SgiGy4dI0En
         qhECjFaSr+sKSsndvNj+ADT9RU41LsOrWR2eJdSNaBJj9I6cR0XqiqsmAbxT00TLmckF
         C+ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685566627; x=1688158627;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hXSlW5uRq1euI1p2NcqjuOnX6YJKbiTwoTtcD+Lazoc=;
        b=P/6dk25gcmG4JlDoqvGak6wbBhu4Bm1HOSwS1rF7McB9a/GOn6eZt9y6xFmbLxgHyc
         VJFiqQItsxn1a3iJuOQhT23dsZwz57bhRLGV09UrvGcV1w3V0zZ4vZPQHNz30hwLpbjv
         mVrDUrSxZUKB2rRYEJ9QzyGh46a0s9IjD8l8S3kwP/eW7txTBZqQ+w1FnXH0suWcWa5X
         tNkTwfYv1We8HtMuW5GHOK/e10BIm8lKnU80a67DMmvsLhC29gmccxibjKW4YWR0/e6U
         0iAjqHI+JW5ImHzegU7SxVDFbmjc0z8JTjLScxTkLWhSL8Tz5GnhnBU547lnZ/oHfanB
         RFdQ==
X-Gm-Message-State: AC+VfDyzUIy4Nwp/GNwe9CwflLzRAk6c4i4pe20xSWsW5VpKPUPYUbXw
        u+VNN/Tb0x5TyAIevUE1rr+FqS2Fp+g=
X-Google-Smtp-Source: ACHHUZ5MNteJStw5d6MwlhgtN/xew5EFBwUW7lK5ST++f2ZsQOJXUDIi7koAFEyRovowCLdqlpveZFjN5bg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:78a:0:b0:528:948b:8989 with SMTP id
 132-20020a63078a000000b00528948b8989mr1325006pgh.9.1685566627647; Wed, 31 May
 2023 13:57:07 -0700 (PDT)
Date:   Wed, 31 May 2023 13:57:06 -0700
In-Reply-To: <20230327212635.1684716-2-coltonlewis@google.com>
Mime-Version: 1.0
References: <20230327212635.1684716-1-coltonlewis@google.com> <20230327212635.1684716-2-coltonlewis@google.com>
Message-ID: <ZHe0okW8G7Z2GrwV@google.com>
Subject: Re: [PATCH v3 1/2] KVM: selftests: Provide generic way to read system counter
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
> +uint64_t cycles_read(void);

I would prefer something like get_system_counter() or read_system_counter()
Pairing "read" after "cycles" can be read (lol) in past tense or current tense,
e.g. "the number of cycles that were read" versus "read the current number of
cycles".  I used guest_system_counter_read() in an example in v1[*], but that was
just me copy+pasting from the patch.

And "cycles" is typically used to describe latency and elapsed time, e.g. doing

	uint64_t time = cycles_to_ns(cycles_read());

looks valid at a glance, e.g. "convert that number of cycles that were read into
nanoseconds", but is nonsensical in most cases because it's current tense, and
there's no baseline time.

Sorry for not bringing this up in v2, I think I only looked at the implementation.

[*] https://lore.kernel.org/kvm/Y9LPhs1BgBA4+kBY@google.com

> +uint64_t cycles_to_ns(struct kvm_vcpu *vcpu, uint64_t cycles)
> +{
> +	TEST_ASSERT(cycles < 10000000000, "Conversion to ns may overflow");
> +	return cycles * NSEC_PER_SEC / timer_get_cntfrq();
> +}
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index ae1e573d94ce..adef76bebff3 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -1270,3 +1270,16 @@ void kvm_selftest_arch_init(void)
>  	host_cpu_is_intel = this_cpu_is_intel();
>  	host_cpu_is_amd = this_cpu_is_amd();
>  }
> +
> +uint64_t cycles_read(void)
> +{
> +	return rdtsc();
> +}
> +
> +uint64_t cycles_to_ns(struct kvm_vcpu *vcpu, uint64_t cycles)
> +{
> +	uint64_t tsc_khz = __vcpu_ioctl(vcpu, KVM_GET_TSC_KHZ, NULL);
> +
> +	TEST_ASSERT(cycles < 10000000000, "Conversion to ns may overflow");

Is it possible to calculate this programatically instead of hardcoding a magic
number?

> +	return cycles * NSEC_PER_SEC / (tsc_khz * 1000);
