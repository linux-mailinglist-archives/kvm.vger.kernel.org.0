Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 475CD546C53
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 20:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347484AbiFJS1x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 14:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346713AbiFJS1r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 14:27:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A2D762F3AA
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 11:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654885665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iQGuB3fjCueVFQOgyR6wG18OiWcaLtLIcmA2PIZUG5w=;
        b=NX2Tv2lZrjt6JPHz77Ak2vCh6PPAkINh+KVloZHd8VpSf7ueuCSrHzfo2l2FaIAc0bw16s
        nVmfkgzQSdWUnOmyslpDt348XnacwQKocyYm4M3QDb/xWQmFr4VGq/3iCqhjuJlC1tksIH
        XoaGoxyCnJiCLfZeZdw8MY6WDfQXUbI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-104-pMSmRdstMl-5PSjJsPZ0rg-1; Fri, 10 Jun 2022 14:27:44 -0400
X-MC-Unique: pMSmRdstMl-5PSjJsPZ0rg-1
Received: by mail-wr1-f69.google.com with SMTP id ay4-20020a5d6f04000000b002183e363f9bso4261898wrb.22
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 11:27:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iQGuB3fjCueVFQOgyR6wG18OiWcaLtLIcmA2PIZUG5w=;
        b=yeHNKrqPsC9jkxgW9cH7VUhEEGAjmuZTZobDgyErbr+axr31fQFGWORv7tpG0pezXe
         GSzrtdyf9SsBQvw6mrpA4LJCaQtl62rooUHJr3zgN6c7Djy/PoO+i4rB8Wa7KNZUsMoD
         UdbRqDgt0a5oonxvI57RDXkxbHkYjpyQzUftF2bld7LVy/cR9GJhexspZ9pIzJiHoBWL
         t9BEMEktyan03AYeVEXX1+VQwyYK9Yx50RiXzupzD4wlUimd513bhy2wvVjSVeUaB21M
         LPFD0Ab2N/ZJRlmIuvtXEaJy2lHcDT+wTY/A0b/IPl8DzxFpB8n1yLXSCOPjMDdjVzg5
         uKBA==
X-Gm-Message-State: AOAM533mL28h9Rlzld+sMHe7oMtFaKgQ3UmaPY4U4nhohmfZj26saJN0
        bQPE/50o6v1C9CPCnaBrsSs62zKo2gT56oWbg1PZxtcGFmftu8nTmvj3FtwBg9VYxsO2t1aw+OR
        5cLIq1WSqEOHJ
X-Received: by 2002:adf:f902:0:b0:20e:66db:b9d2 with SMTP id b2-20020adff902000000b0020e66dbb9d2mr46463523wrr.682.1654885663418;
        Fri, 10 Jun 2022 11:27:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyX4EXaej+yGAWQmkEZ9A2zAX6cZF9MyE1XjwvMy3Fp/lkBifZE9xTQsa/UfnKVvLr0ZyWptQ==
X-Received: by 2002:adf:f902:0:b0:20e:66db:b9d2 with SMTP id b2-20020adff902000000b0020e66dbb9d2mr46463503wrr.682.1654885663182;
        Fri, 10 Jun 2022 11:27:43 -0700 (PDT)
Received: from gator (cst2-173-67.cust.vodafone.cz. [31.30.173.67])
        by smtp.gmail.com with ESMTPSA id 2-20020a05600c228200b0039482d95ab7sm3798920wmf.24.2022.06.10.11.27.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 11:27:42 -0700 (PDT)
Date:   Fri, 10 Jun 2022 20:27:41 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 143/144] KVM: selftests: Add TEST_REQUIRE macros to
 reduce skipping copy+paste
Message-ID: <20220610182741.iwjjwgwgsu5jrpqh@gator>
References: <20220603004331.1523888-1-seanjc@google.com>
 <20220603004331.1523888-144-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603004331.1523888-144-seanjc@google.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 03, 2022 at 12:43:30AM +0000, Sean Christopherson wrote:
...
> diff --git a/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c b/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c
> index 1e366fdfe7be..d09b3cbcadc6 100644
> --- a/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c
> +++ b/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c
> @@ -25,10 +25,7 @@ int main(int argc, char *argv[])
>  	 * will cover the "regular" list of MSRs, the coverage here is purely
>  	 * opportunistic and not interesting on its own.
>  	 */
> -	if (!kvm_check_cap(KVM_CAP_GET_MSR_FEATURES)) {

I guess this one was missed on the initial conversion of kvm_check_cap to
kvm_has_cap, but it doesn't matter.

> -		print_skip("KVM_CAP_GET_MSR_FEATURES not supported");
> -		exit(KSFT_SKIP);
> -	}
> +	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GET_MSR_FEATURES));
>  
>  	(void)kvm_get_msr_index_list();
>
...  
> @@ -70,17 +70,12 @@ int main(int argc, char *argv[])
>  {
>  	struct kvm_vcpu *vcpu;
>  	struct kvm_vm *vm;
> -	int rv;
>  	uint64_t msr_platform_info;
>  
>  	/* Tell stdout not to buffer its content */
>  	setbuf(stdout, NULL);
>  
> -	rv = kvm_check_cap(KVM_CAP_MSR_PLATFORM_INFO);

Also missed and also doesn't matter.

> -	if (!rv) {
> -		print_skip("KVM_CAP_MSR_PLATFORM_INFO not supported");
> -		exit(KSFT_SKIP);
> -	}
> +	TEST_REQUIRE(kvm_has_cap(KVM_CAP_MSR_PLATFORM_INFO));
>  
>  	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
>  
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> index ffa6a2f93de2..de9ee00d84cf 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> @@ -417,39 +417,24 @@ static bool use_amd_pmu(void)
>  
>  int main(int argc, char *argv[])
>  {
> -	void (*guest_code)(void) = NULL;
> +	void (*guest_code)(void);
>  	struct kvm_vcpu *vcpu;
>  	struct kvm_vm *vm;
> -	int r;
>  
>  	/* Tell stdout not to buffer its content */
>  	setbuf(stdout, NULL);
>  
> -	r = kvm_check_cap(KVM_CAP_PMU_EVENT_FILTER);

Also missed and ...

> -	if (!r) {
> -		print_skip("KVM_CAP_PMU_EVENT_FILTER not supported");
> -		exit(KSFT_SKIP);
> -	}
> +	TEST_REQUIRE(kvm_check_cap(KVM_CAP_PMU_EVENT_FILTER));

... got carried into the TEST_REQUIRE, so it sort of matters.

Thanks,
drew

