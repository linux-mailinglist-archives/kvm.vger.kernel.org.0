Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45DB65898B2
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 09:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238009AbiHDHwo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 03:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239285AbiHDHwm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 03:52:42 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9227965541;
        Thu,  4 Aug 2022 00:52:40 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id iw1so18623001plb.6;
        Thu, 04 Aug 2022 00:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=iMUaXhnaWpxJvgS+MeqwxUCzILa7Wb9dW1Vcvdl4nOE=;
        b=HdFCAk4fUn+fKOKa1dZysuQQprUZxrEd1O4WOVFQgzl2c7q9vl/OqrY+okaZ7jShBd
         7oHdrx1TX+qqEj0pwkIAlgAmAqlpDf+Ny2G8L0FfGaH5aWs5Wc93RsI2J7IoCM/KmtH+
         ggkIFf815HUdsUcQ3X57CwwWtfE67tvSfjYH5oGgIjBqG0JFMlqrN9XGZYJeTvaxaFYg
         nlGS1y9Fv5xH07wKQdwM3SqSdyybi9WLPykQNlzzlvwiQwVzuAl3kOk7AFR2WX46x+qp
         iP5KhRijVi4Al3Z+FMpmFeMantDmkdThbwiVfWIYrMSRZp19QqIoR/PgutzoLdyvnYJO
         DHYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=iMUaXhnaWpxJvgS+MeqwxUCzILa7Wb9dW1Vcvdl4nOE=;
        b=uAAI6MO6JSpBHP3V7BSphLymWsJyX7ZHpo05nNjWgClEp0DaPvEshTvXd2vB6oIiPB
         IZWT3H89P5HbdWi9uBwJaC6CJ0xnCTXqBd/lZfeYW8Arx+OVu8WrEnvGbW6rzIFW/oOT
         hMx9GM41jm0Le/iZpnd2mvhBKhHQUxjhVAAWWXklHveSurtF/Lf1qK3S560zwzZqEqP9
         CzdqLqZQ1HeUOfPVhi1T68UUGI9wuamS0uzhuC4wvENUb66Ysd/RwJRfj9N1Miib4xVY
         I/LpPwmxbd3cTf3AMrI9ENfHVXpbd1IHNe6NF19mJllcOe7m9QwDQ/pOwv+0bPeP6G8f
         SkcA==
X-Gm-Message-State: ACgBeo29lA4s8m8vAzON2j2iycJzcHcuj2xqwexwcFXO/h9OVEHCecXj
        wICsMGRpMYvOwrpiKzg1NJU=
X-Google-Smtp-Source: AA6agR4lWkygkbSLOGmLvhfLoZZ1ap2xxaXC37bp8VBvAYIvG5/TmsnHKJXZfbwZjTms0ZnnC5PqmQ==
X-Received: by 2002:a17:902:efc3:b0:16f:1153:c509 with SMTP id ja3-20020a170902efc300b0016f1153c509mr686056plb.41.1659599560046;
        Thu, 04 Aug 2022 00:52:40 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id m14-20020a170902f64e00b0016dc0a6f576sm115353plg.250.2022.08.04.00.52.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Aug 2022 00:52:39 -0700 (PDT)
Message-ID: <41e0b2a0-c53d-870f-d619-4008eb222d42@gmail.com>
Date:   Thu, 4 Aug 2022 15:52:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v2 7/7] KVM: VMX: Simplify capability check when handling
 PERF_CAPABILITIES write
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>
References: <20220803192658.860033-1-seanjc@google.com>
 <20220803192658.860033-8-seanjc@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20220803192658.860033-8-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/8/2022 3:26 am, Sean Christopherson wrote:
> Explicitly check for the absence of host support for LBRs or PEBS when
> userspace attempts to enable said features by writing PERF_CAPABILITIES.
> Comparing host support against the incoming value is unnecessary and
> weird since the checks are buried inside an if-statement that verifies
> userspace wants to enable the feature.

If you mean this part in the KVM:

	case MSR_IA32_PERF_CAPABILITIES: {
		...
		if (data & ~msr_ent.data)
			return 1;
		...

then this patch brings a flaw, for example:

a user space can successfully set 0x1 on a host that reports a value of 0x5,
which should not happen since the semantics of 0x1 and 0x5 for LBR_FMT
may be completely different from the guest LBR driver's perspective.

For such a model-specific feature, it needs to write to PERF_CAPABILITIES
the exact value reported by the host/kvm.

A selftest is proposed in the hope of guarding this contract.

> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d7f8331d6f7e..0ada0ee234b7 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2323,15 +2323,13 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		if (data && !vcpu_to_pmu(vcpu)->version)
>   			return 1;
>   		if (data & PMU_CAP_LBR_FMT) {
> -			if ((data & PMU_CAP_LBR_FMT) !=
> -			    (vmx_get_perf_capabilities() & PMU_CAP_LBR_FMT))
> +			if (!(vmx_get_perf_capabilities() & PMU_CAP_LBR_FMT))
>   				return 1;
>   			if (!cpuid_model_is_consistent(vcpu))
>   				return 1;
>   		}
>   		if (data & PERF_CAP_PEBS_FORMAT) {
> -			if ((data & PERF_CAP_PEBS_MASK) !=
> -			    (vmx_get_perf_capabilities() & PERF_CAP_PEBS_MASK))
> +			if (!(vmx_get_perf_capabilities() & PERF_CAP_PEBS_MASK))
>   				return 1;
>   			if (!guest_cpuid_has(vcpu, X86_FEATURE_DS))
>   				return 1;
