Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5937801A0
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 01:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356049AbjHQXWK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 19:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356056AbjHQXV4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 19:21:56 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E69D3588
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 16:21:55 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1bddb67390dso5134135ad.2
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 16:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692314514; x=1692919314;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=J/Ket07XbmLUgM3VqVLd+avv0k+hdZ+nbF7OKnE9uLA=;
        b=C0/fo/TnxgkaozGTCbWg7JOuiOM2gCqolP7CiEHXYuJTHmXfCvzk/iIlGSuZ8mxOD4
         9UDNt1pw+hHdn3ptUHCT4nS+KkjdMZndQVOPnsthBwS0kkPuEYfqmNYniayZQE2IurvE
         lZzhNxZDcdfiJVkDC3/9YM5l3P4prfa3eLJMxtezrBmq/6r/jZ0QMLZJtn+TgcztaU+t
         moMlzo14ss2izBJ7FYQICtap3WwMqic7TsqX1s8YdLwKdaxzqWAwXoJ4mvxpBHsZ1v/m
         grhZYFd7Pi929N34j48X/G4H74IhUenSyOH2NcnwjdZfSe97zTehJ2CRaP+KtmVBntYp
         69hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692314514; x=1692919314;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J/Ket07XbmLUgM3VqVLd+avv0k+hdZ+nbF7OKnE9uLA=;
        b=XmwwHsmNJnAUv4eZUXoSQd0rCfNgWqy3VAuvQTA5M0dX0nOwI71xGphNe31oL593YN
         o303HmYiltm1DWMY56cVvSkalg6zoYOU/HM+5LnCs3hPr2/TaQPs8dR0KdGAaSTdIPsg
         KNYEpJ0FS2/rE2l4bf0W2sNvySqxs82kxaSdeU0f550XPTMIpan/1nnlpb1P6mxG/roZ
         fauKMM2QjUw7DDeW45LRg1X8HwO2pEboml2rVdzV8kF/wrTzOCSWMIRx/8D7lSHdpjjf
         WCeBj6iJ/A5WfPZB0qPqabRJO9iP03oZntJVUJiAl01SnuAeGncw6bDUEMY/+90he4PQ
         boEA==
X-Gm-Message-State: AOJu0YzRhXR3v3WxvkgDKNpnuGOQT+1dsb5Ch9TMkL5sTKIEYgtjLTn9
        PLwO6KzmM9gm9hNW7hZH5qaXgWZCN7k=
X-Google-Smtp-Source: AGHT+IFwlRuZws0TUSBB0piRCroR1sbXv/PMBgDKcvlbHoPucUENcJYr+9Aq4nF/bE28mqN1lz5DU+tRajo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f145:b0:1bf:cc5:7b57 with SMTP id
 d5-20020a170902f14500b001bf0cc57b57mr305994plb.3.1692314514660; Thu, 17 Aug
 2023 16:21:54 -0700 (PDT)
Date:   Thu, 17 Aug 2023 16:21:53 -0700
In-Reply-To: <20230814115108.45741-9-cloudliang@tencent.com>
Mime-Version: 1.0
References: <20230814115108.45741-1-cloudliang@tencent.com> <20230814115108.45741-9-cloudliang@tencent.com>
Message-ID: <ZN6rkW4DHFI1v1vL@google.com>
Subject: Re: [PATCH v3 08/11] KVM: selftests: Test consistency of PMU MSRs
 with Intel PMU version
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
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 14, 2023, Jinrong Liang wrote:
> @@ -341,6 +347,66 @@ static void intel_test_fixed_counters(void)
>  	}
>  }
>  
> +static void intel_guest_check_pmu_version(uint8_t version)
> +{
> +	switch (version) {
> +	case 0:
> +		GUEST_SYNC(wrmsr_safe(MSR_INTEL_ARCH_PMU_GPCTR, 0xffffull));
> +	case 1:
> +		GUEST_SYNC(wrmsr_safe(MSR_CORE_PERF_GLOBAL_CTRL, 0x1ull));
> +	case 2:
> +		/*
> +		 * AnyThread Bit is only supported in version 3
> +		 *
> +		 * The strange thing is that when version=0, writing ANY-Any
> +		 * Thread bit (bit 21) in MSR_P6_EVNTSEL0 and MSR_P6_EVNTSEL1
> +		 * will not generate #GP. While writing ANY-Any Thread bit
> +		 * (bit 21) in MSR_P6_EVNTSEL0+x (MAX_GP_CTR_NUM > x > 2) to
> +		 * ANY-Any Thread bit (bit 21) will generate #GP.
> +		 */
> +		if (version == 0)
> +			break;
> +
> +		GUEST_SYNC(wrmsr_safe(MSR_P6_EVNTSEL0,
> +				      ARCH_PERFMON_EVENTSEL_ANY));
> +		break;
> +	default:
> +		/* KVM currently supports up to pmu version 2 */
> +		GUEST_SYNC(GP_VECTOR);

This seems largely pointless, but I suppose it doesn't hurt anything.

> +	}
> +
> +	GUEST_DONE();
> +}
> +
> +static void test_pmu_version_setup(struct kvm_vcpu *vcpu, uint8_t version,
> +				   uint64_t expected)
> +{
> +	uint64_t msr_val = 0;
> +
> +	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_VERSION, version);
> +
> +	vcpu_args_set(vcpu, 1, version);
> +	while (run_vcpu(vcpu, &msr_val) != UCALL_DONE)
> +		TEST_ASSERT_EQ(expected, msr_val);
> +}
> +
> +static void intel_test_pmu_version(void)
> +{
> +	uint8_t unsupported_version = kvm_cpu_property(X86_PROPERTY_PMU_VERSION) + 1;
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +	uint8_t version;
> +
> +	TEST_REQUIRE(kvm_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS) > 2);
> +
> +	for (version = 0; version <= unsupported_version; version++) {
> +		vm = pmu_vm_create_with_one_vcpu(&vcpu,
> +						 intel_guest_check_pmu_version);
> +		test_pmu_version_setup(vcpu, version, GP_VECTOR);

Why pass GP_VECTOR?  It's the _only_ expected result, just have the guest assert
that it got a #GP...

> +		kvm_vm_free(vm);

Again, stop making half-baked helpers.

> +	}
> +}
> +
>  int main(int argc, char *argv[])
>  {
>  	TEST_REQUIRE(get_kvm_param_bool("enable_pmu"));
> @@ -353,6 +419,7 @@ int main(int argc, char *argv[])
>  	intel_test_arch_events();
>  	intel_test_counters_num();
>  	intel_test_fixed_counters();
> +	intel_test_pmu_version();
>  
>  	return 0;
>  }
> -- 
> 2.39.3
> 
