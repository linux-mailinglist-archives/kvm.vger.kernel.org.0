Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77B19780193
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 01:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356034AbjHQXT2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 19:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356030AbjHQXTK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 19:19:10 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170B43590
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 16:19:09 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-6887a2d5878so563798b3a.1
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 16:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692314348; x=1692919148;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lGC6vdxKDN9BohL/o+ZRVF0q8i5Ok2MT10XfZwQf458=;
        b=Dp+YwzbbsAirrksZu+c3DLB/I5qhYsNvx0o8rgt4BchsRyEhzA2A9bGAh5CvxgwBaF
         clJ5QoIjEJSHoDzwSDEaFL+X1MiI9kYAqQsYJqRaQPTkOfzL/K8uEfdoTstWYTEy8/+J
         WJxqWANlEFA16vgliDtWECn3kHJbU27B1RaylqmcRNBwhxBgT629UY/z1jGsu/6JmcML
         Y7NP09Eq4VG8xb0oXWF3647Ij4adm6zYLhQi7x1St4m5/1awvhlo/D1mGoS+YgPUJGQn
         O4Q6XxvmxM1TzH8145o9fLo+qfNP8yaB+jN2qowYodSZmp8q1VlgvJVudZPKHnC/N1NJ
         0/vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692314348; x=1692919148;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lGC6vdxKDN9BohL/o+ZRVF0q8i5Ok2MT10XfZwQf458=;
        b=NblXthWUtuHJHGyJhrJ0Z5zrDwUnrr6eSSBcBARyg2IwpXBwlXuTgcnZr75Txl6DZD
         M9UWkk7jGIJDWPrvEJb9GBid9AEGa7QQbRRWZhPncE3EXk8QulmgsrPLeoUvgf+3nOtt
         sSsgCYE5cHzDEb0SJQ01JTD9WOdUpdMk8rUyd69i2UAcZCspYPPTyQvRfxM25mlytUba
         +3s+lqOm7uCZcAFMU+Kb6Oragv5DraSKxQGf8+9v22arCiWfEwJoifakiuejK2MCpdpT
         d/FB6Dv/q8u5rSwb6Yt+mSlPIZrIm/LYQ/x+mXObQvftlKvUEYppSIzDLQeha6txMo4o
         Lopg==
X-Gm-Message-State: AOJu0YyWRKVPJeL5AhPKe18qHdSVOXQ4apfvfm4DxtDk7cNczFtrq/zl
        NxIgyddMSoXOtmmztbzOs7+83B3vAvI=
X-Google-Smtp-Source: AGHT+IGM5vFw5JmAB7UOmc5XD7z5MPr3M6/nO7JzceMraIy4hBCCljGQmH0ICYq7HwlApxyNK4TpwsRPCxo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d26:b0:687:94c2:106 with SMTP id
 fa38-20020a056a002d2600b0068794c20106mr455981pfb.5.1692314348397; Thu, 17 Aug
 2023 16:19:08 -0700 (PDT)
Date:   Thu, 17 Aug 2023 16:19:06 -0700
In-Reply-To: <20230814115108.45741-8-cloudliang@tencent.com>
Mime-Version: 1.0
References: <20230814115108.45741-1-cloudliang@tencent.com> <20230814115108.45741-8-cloudliang@tencent.com>
Message-ID: <ZN6q6tfYRXaU6Fg+@google.com>
Subject: Re: [PATCH v3 07/11] KVM: selftests: Test Intel supported fixed
 counters bit mask
From:   Sean Christopherson <seanjc@google.com>
To:     Jinrong Liang <ljr.kernel@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Like Xu <likexu@tencent.com>,
        David Matlack <dmatlack@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 14, 2023, Jinrong Liang wrote:
> +static void intel_test_fixed_counters(void)
> +{
> +	uint8_t nr_fixed_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +	uint32_t ecx;
> +	uint8_t edx;
> +
> +	for (edx = 0; edx <= nr_fixed_counters; edx++) {
> +		/* KVM doesn't emulate more fixed counters than it can support. */
> +		for (ecx = 0; ecx <= (BIT_ULL(nr_fixed_counters) - 1); ecx++) {
> +			vm = pmu_vm_create_with_one_vcpu(&vcpu,
> +							 intel_guest_run_fixed_counters);
> +			test_fixed_counters_setup(vcpu, ecx, edx);
> +			kvm_vm_free(vm);

Same comments as a previous patch, either use a helper or open code, don't mix
both.

> +		}
> +	}
> +}
> +
>  int main(int argc, char *argv[])
>  {
>  	TEST_REQUIRE(get_kvm_param_bool("enable_pmu"));
> @@ -293,6 +352,7 @@ int main(int argc, char *argv[])
>  
>  	intel_test_arch_events();
>  	intel_test_counters_num();
> +	intel_test_fixed_counters();
>  
>  	return 0;
>  }
> -- 
> 2.39.3
> 
