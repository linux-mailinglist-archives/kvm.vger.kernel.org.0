Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 845884B5B16
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 21:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiBNUTS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 15:19:18 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:35276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbiBNUTQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 15:19:16 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CFDF3D496
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 12:19:00 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id u5so218772ple.3
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 12:19:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xpr2XqNl9BTZSWJqDBxtkmtGAtSR7lvQI3IQ95FLzRc=;
        b=ihZOk0NsZueKU0S8703uLnv5N1SYkL9saoPYSuS3tO3eUTmikZvx4aqT2+9I4JT7Ps
         JNNGEGB1P41JgcznzUb8yWAkh6ex7W+M9rUabahyFoNS3bJw5fjFSR6It05NZbxr3xzo
         Kq1M1hmaSyaOIHFmuEONOcoDTxNPbZmyTasMuTPmAqq8YzzeUIYUNH1zdvfOanOoXntD
         FgSW038LX6CVug/ZzBJB6ivunwu3QHHogj2C6x/CSH904ynGh75GF9GeVRgjO20YFGkz
         DvhXIt9HAvl0MzGBEuKGwLh9ZEN0LclvWK3ClGNbdcnMrnFcePtLiPtY2i4+9oIybcRH
         2LnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xpr2XqNl9BTZSWJqDBxtkmtGAtSR7lvQI3IQ95FLzRc=;
        b=etZiCNvyOmopy2yyBnxW9utU9EGMAjMJVUyqO77ur+h7szNgoODltU0sAYZON/jATi
         UgtewSTdbm6PHXNXiTLfrv0c0IYpdE3I6zrumypirjH2gs82BiuiWY/BGaRj9ou+YpxH
         xFIIgSosox9wFSjsc+vaTwa3s9pUg7/F3IaB63MC4/nOz6K64Ur/q5E0IGWZVGJmzs87
         3qyedgPWKbXehgODTqeyn6tBOBHhPPuCTq3yyFZk3BwnRuveNf2ycL5eRlZS8v15PwoK
         7uRz+EmwQ6uyfHbz08whtkgGmgKB42JIhAi71rJq5wm9WDhhITDNP9fEIj8i0+/GNfXo
         SErA==
X-Gm-Message-State: AOAM530eYDhzV7FH6nLJ1JjJ9Rsol1GFXZH0CQ9hALfdk9jgFLsuUG8p
        qJRYFUObIXyayg48Zo5E3iBAyw==
X-Google-Smtp-Source: ABdhPJxKGmze2RSWdf2dvTTli9TpoQJviegd2hdMibEJwPio1bimMTXH62j9s79jcvfSKURgGLVqbA==
X-Received: by 2002:a17:902:a512:: with SMTP id s18mr536070plq.51.1644869610984;
        Mon, 14 Feb 2022 12:13:30 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j14sm9002130pfa.81.2022.02.14.12.13.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 12:13:30 -0800 (PST)
Date:   Mon, 14 Feb 2022 20:13:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Dunn <daviddunn@google.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, like.xu.linux@gmail.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH v6 3/3] KVM: selftests: Verify disabling PMU
 virtualization via KVM_CAP_CONFIG_PMU
Message-ID: <Ygq35t775X2eTzFA@google.com>
References: <20220209172945.1495014-1-daviddunn@google.com>
 <20220209172945.1495014-4-daviddunn@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209172945.1495014-4-daviddunn@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 09, 2022, David Dunn wrote:
> On a VM with PMU disabled via KVM_CAP_PMU_CONFIG, the PMU will not be
> usable by the guest.  On Intel, this causes a #GP.  And on AMD, the
> counters no longer increment.
> 
> KVM_CAP_PMU_CONFIG must be invoked on a VM prior to creating VCPUs.
> 
> Signed-off-by: David Dunn <daviddunn@google.com>
> ---
>  .../kvm/x86_64/pmu_event_filter_test.c        | 35 +++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> index c715adcbd487..7a4b99684d9d 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> @@ -325,6 +325,39 @@ static void test_not_member_allow_list(struct kvm_vm *vm)
>  	TEST_ASSERT(!count, "Disallowed PMU Event is counting");
>  }
>  
> +/*
> + * Verify KVM_CAP_PMU_DISABLE prevents the use of the PMU.
> + *
> + * Note that KVM_CAP_PMU_CAPABILITY must be invoked prior to creating VCPUs.
> + */
> +static void test_pmu_config_disable(void (*guest_code)(void))
> +{
> +	int r;
> +	struct kvm_vm *vm;
> +	struct kvm_enable_cap cap = { 0 };
> +	bool sane;
> +
> +	r = kvm_check_cap(KVM_CAP_PMU_CAPABILITY);
> +	if ((r & KVM_CAP_PMU_DISABLE) == 0)

Preferred style is

	if (!(r & KVM_CAP_PMU_DISABLE))
		return;

Bonus points if you a helper to allow retrieving module params, then this could
be:

	TEST_ASSERT(!!(r & KVM_CAP_PMU_DISABLE) == enable_pmu);

	if (!(r & KVM_CAP_PMU_DISABLE))
		return;

> +		return;
> +
> +	vm = vm_create_without_vcpus(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
> +
> +	cap.cap = KVM_CAP_PMU_CAPABILITY;
> +	cap.args[0] = KVM_CAP_PMU_DISABLE;
> +	r = vm_enable_cap(vm, &cap);
> +	TEST_ASSERT(r == 0, "Failed KVM_CAP_PMU_DISABLE.");
> +
> +	vm_vcpu_add_default(vm, VCPU_ID, guest_code);
> +	vm_init_descriptor_tables(vm);
> +	vcpu_init_descriptor_tables(vm, VCPU_ID);
> +
> +	sane = sanity_check_pmu(vm);
> +	TEST_ASSERT(!sane, "Guest should not be able to use disabled PMU.");

Using a local boolean loses context, e.g.

	TEST_ASSERT(!sanity_check_pmu(vm),
		    "...");

will show exactly what failed in the error messages, where as "!sane" doesn't
provide much help to the user.

> +
> +	kvm_vm_free(vm);
> +}
> +
>  /*
>   * Check for a non-zero PMU version, at least one general-purpose
>   * counter per logical processor, an EBX bit vector of length greater
> @@ -430,5 +463,7 @@ int main(int argc, char *argv[])
>  
>  	kvm_vm_free(vm);
>  
> +	test_pmu_config_disable(guest_code);
> +
>  	return 0;
>  }
> -- 
> 2.35.0.263.gb82422642f-goog
> 
