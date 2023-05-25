Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B25A7112C5
	for <lists+kvm@lfdr.de>; Thu, 25 May 2023 19:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232904AbjEYRqu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 May 2023 13:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240003AbjEYRqj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 May 2023 13:46:39 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3389D1AB
        for <kvm@vger.kernel.org>; Thu, 25 May 2023 10:46:17 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5659d102318so4928657b3.3
        for <kvm@vger.kernel.org>; Thu, 25 May 2023 10:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685036776; x=1687628776;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6xpqqXPrAvFJvmn1X4m04iFO9lqyLz151DsCgMF2J2A=;
        b=vsGHJndszpsQgsdTVc/Azi40HECtyqi5XkDlxGBY6rgqlIl1PWECEjZy+H+NbkelvI
         +2l57sQdXnaIZSlMjZhOTiV6TEQKfdPsAvNE3iG2iq2G3Y7SCMqyQj/kw2tufMtbMCcA
         o7wBhpZIWOYH0dgYE6ChQUtyv0bo7CDTBOEOVj63onjziAuTcrTf8A9x2LB1DwJymdCN
         To1ewi+4lz8kZPupTR1kWQ4hC4Ulo4tXxWHQtFUJ3gadgLqiWxqFCExouCIyJUtqnC8B
         hd9nf4QGoSu8fdDf0plkasadfslHp+FzcHo3IqGNHNjurioOjg97iT4oMCDmBejQnJmi
         KS4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685036776; x=1687628776;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6xpqqXPrAvFJvmn1X4m04iFO9lqyLz151DsCgMF2J2A=;
        b=N4trMt7yDG2fA7oD9WPTdVRwJQltpSTAFefgvCfOzjordQAX6uIfpsM7ZwpUveXr3G
         CWDfZdEIlrjnql35mwv5Rq6WldN0DKPYeHYo/xfL99nzmKtHX7333jTpcZv6rxWqWbN7
         F14yESbzuVQ3meM8Xou9aNC0JkH/PHa4e/MNfLUK9yFnfRfUzeBV1MnTrCRyP4i8O7lJ
         h8sLldG1CFRWWEoL6HqOJ4idVfUBfVxJNvIP+ZPiapZphmJbS8keimZie0MUl/gAstH2
         PJ23+dUVnxSbOTs1G2KU54322oTwYCPxJXBiOnMjKxrVEphyhB2lj8ZLoU5cE215BN7H
         GJ3g==
X-Gm-Message-State: AC+VfDxVhnNgl/RFwxZFGHBCZt2UQ3rzDx+cTWlEGrAKHLEt5NJyzpEY
        C9zw+znIIPWePH+ZoidXlea5W97+sFs=
X-Google-Smtp-Source: ACHHUZ6uecTzKvghpOusKXyvvuAFO92WI6ZAoaZZajrASjfWuYLGwgqWAH1KX8n/LYSi4fQ+kXcbOnBKe+w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b606:0:b0:561:c4ef:1def with SMTP id
 u6-20020a81b606000000b00561c4ef1defmr227363ywh.0.1685036776503; Thu, 25 May
 2023 10:46:16 -0700 (PDT)
Date:   Thu, 25 May 2023 10:46:15 -0700
In-Reply-To: <20230420104622.12504-4-ljrcore@126.com>
Mime-Version: 1.0
References: <20230420104622.12504-1-ljrcore@126.com> <20230420104622.12504-4-ljrcore@126.com>
Message-ID: <ZG+e55VbXd/YCnnV@google.com>
Subject: Re: [PATCH v2 3/7] KVM: selftests: Test unavailable event filters are rejected
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
> Adds unsupported input test cases for PMU filter. Specifically,
> it tests the input of unsupported "action" values, unsupported
> "flags" values, and unsupported "nevents" values, which should
> all return an error, as they are currently unsupported by the
> filter. Additionally, the patch tests setting non-exist fixed
> counters in the fixed bitmap doesn't fail.
> 
> This change aims to improve the testing of the PMU filter and
> ensure that it functions correctly in all supported use cases.
> The patch has been tested and verified to function correctly.
> 
> Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
> ---
>  .../kvm/x86_64/pmu_event_filter_test.c        | 52 +++++++++++++++++++
>  1 file changed, 52 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> index 4e87eea6986b..a3d5c30ce914 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> @@ -27,6 +27,10 @@
>  #define ARCH_PERFMON_BRANCHES_RETIRED		5
>  
>  #define NUM_BRANCHES 42
> +#define FIXED_CTR_NUM_MASK				GENMASK_ULL(4, 0)
> +#define PMU_EVENT_FILTER_INVALID_ACTION		(KVM_PMU_EVENT_DENY + 1)
> +#define PMU_EVENT_FILTER_INVALID_FLAGS			(KVM_PMU_EVENT_FLAG_MASKED_EVENTS + 1)
> +#define PMU_EVENT_FILTER_INVALID_NEVENTS		(MAX_FILTER_EVENTS + 1)
>  
>  /*
>   * This is how the event selector and unit mask are stored in an AMD
> @@ -743,10 +747,22 @@ static int run_filter_test(struct kvm_vcpu *vcpu, const uint64_t *events,
>  	return r;
>  }
>  
> +static uint8_t get_kvm_supported_fixed_num(void)
> +{
> +	const struct kvm_cpuid_entry2 *kvm_entry;
> +
> +	if (host_cpu_is_amd)
> +		return 0;
> +
> +	kvm_entry = get_cpuid_entry(kvm_get_supported_cpuid(), 0xa, 0);
> +	return kvm_entry->edx & FIXED_CTR_NUM_MASK;

Ah, I got ahead of myself.  This is where the KVM_X86_PROPERTY comes in.
