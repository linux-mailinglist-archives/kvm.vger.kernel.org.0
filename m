Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C937711357
	for <lists+kvm@lfdr.de>; Thu, 25 May 2023 20:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233502AbjEYSMj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 May 2023 14:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233783AbjEYSMi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 May 2023 14:12:38 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFBFD119
        for <kvm@vger.kernel.org>; Thu, 25 May 2023 11:12:36 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-534107e73cfso1278748a12.1
        for <kvm@vger.kernel.org>; Thu, 25 May 2023 11:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685038356; x=1687630356;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3+IxoBoebOsPjsV+diUVwrxPrkn1mNdsKoZUJH//gMM=;
        b=asq73AO5EW4oiv2rz/cLLjTKTOMfwul5iEyKEl8XBvFpZk1slUgRJeAxEZiuyOH1il
         u6vWzpiV/+J0VP2thxrbC0sqUAY8L6T1NcUDmCBfLxl6d4IEhC0+Bjuld2ZOJpvagjNb
         L0xcP0fnuRpHSql/df5vWdxhu0Td5JGTOmuAxT8GCskaoktlIhL8NaZwrJ53m1zmSJr8
         MJnhsoTOl8hUPUXSB0Kkd+Ve89P/BiBAft9a1eXs7qZSCwL7jQbkiQIf3EGHP2Qv93he
         vM1Br6nOaSA/7+oc7SgfBTLePi7DLwbUGNSJ95gGLU8ytW/gI9SPrOsgpeGiuJTdA0cg
         jMTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685038356; x=1687630356;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3+IxoBoebOsPjsV+diUVwrxPrkn1mNdsKoZUJH//gMM=;
        b=Yb+b3qp/puSHVIf4Kd+2i0qQCqbxsVo99HLK92Q9KwLQb1Lg01bXkVAJbv1mlD2ALO
         ESLPRpvPo7NKscXrqPi4TDkhI57PJjK3f33gltIaD9iJH3ENR64WZc5nqYUTTIkRGFgp
         Xsp9mlfAcG1mR7kL/JRjlRDtb2t9SCWNvg9gbwUO7Xgto5ZPXqrIMF3K058j+6rHwMJ9
         0MyRxUQTgNvKLllrTG2dA9lG/rhJrkbIXofxrLposhG7QK00DCsfaLjg/zisUuXYXNMa
         28MSTxClceTapeRHFmBFWXVPqP5wGBJCRDKK//Llgy9xszfBSMYwxXoVoyTnlwVjxw+/
         fXtA==
X-Gm-Message-State: AC+VfDw2Ds1WHYPB5qDZfkqsgw6YPafMGumXRT0jFQPdgUEvdZjCSJkM
        dyZYm/8okj9rEyh4Px8KRMMR50yFzAs=
X-Google-Smtp-Source: ACHHUZ6bh9fTP225CcehXePeNmklaWj/m62wIsPxSDwvjGLsrPGwpHJr1bq64xWWbip8kwiimsbB77Woop4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:5b45:0:b0:53f:265a:a662 with SMTP id
 y5-20020a655b45000000b0053f265aa662mr691222pgr.4.1685038356418; Thu, 25 May
 2023 11:12:36 -0700 (PDT)
Date:   Thu, 25 May 2023 11:12:34 -0700
In-Reply-To: <20230420104622.12504-7-ljrcore@126.com>
Mime-Version: 1.0
References: <20230420104622.12504-1-ljrcore@126.com> <20230420104622.12504-7-ljrcore@126.com>
Message-ID: <ZG+lEmoiJqB9H5tg@google.com>
Subject: Re: [PATCH v2 6/7] KVM: selftests: Check gp event filters without
 affecting fixed event filters
From:   Sean Christopherson <seanjc@google.com>
To:     Jinrong Liang <ljr.kernel@gmail.com>
Cc:     Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <shuah@kernel.org>,
        Aaron Lewis <aaronlewis@google.com>,
        David Matlack <dmatlack@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Jinrong Liang <cloudliang@tencent.com>,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 20, 2023, Jinrong Liang wrote:
> From: Jinrong Liang <cloudliang@tencent.com>
> 
> From: Jinrong Liang <cloudliang@tencent.com>
> 
> Add a test to ensure that setting both generic and fixed performance
> event filters does not affect the consistency of the fixed performance
> filter behavior in KVM. This test helps to ensure that the fixed
> performance filter works as expected even when generic performance
> event filters are also set.
> 
> Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
> ---
>  .../selftests/kvm/x86_64/pmu_event_filter_test.c   | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> index 0f54c53d7fff..9be4c6f8fb7e 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> @@ -889,6 +889,7 @@ static void test_fixed_ctr_action_and_bitmap(struct kvm_vcpu *vcpu,
>  	uint32_t bitmap;
>  	uint64_t count;
>  	bool expected;
> +	struct kvm_pmu_event_filter *f;
>  
>  	/*
>  	 * Check the fixed performance counter can count normally works when
> @@ -902,6 +903,19 @@ static void test_fixed_ctr_action_and_bitmap(struct kvm_vcpu *vcpu,
>  			expected = fixed_ctr_is_allowed(fixed_ctr_idx, actions[i], bitmap);
>  			count = test_fixed_ctr_with_filter(vcpu, actions[i], bitmap);
>  
> +			TEST_ASSERT(expected == !!count,
> +				    "Fixed event filter does not work as expected.");
> +
> +			/*
> +			 * Check that setting both events[] and fixed_counter_bitmap
> +			 * does not affect the consistency of the fixed ctrs' behaviour.
> +			 *
> +			 * Note, the fixed_counter_bitmap rule has high priority.

"high" is ambiguous without a baseline.  I believe what you want to say is
"the fixed_counter_bitmap has higher priority than the events list".

> +			 */
> +			f = event_filter(actions[i]);
> +			f->fixed_counter_bitmap = bitmap;
> +			count = test_with_filter(vcpu, f);
> +
>  			TEST_ASSERT(expected == !!count,
>  				    "Fixed event filter does not work as expected.");
>  		}
> -- 
> 2.31.1
> 
