Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04CDA546BEA
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 19:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349919AbiFJRz5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 13:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244289AbiFJRzy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 13:55:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2E4B03B3C2
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 10:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654883752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KWRY7NWS4wDn/R3vPtY9UepTUBiMvusiY2Rm4T+7aDw=;
        b=btUXQhsYiiHDtojC4i53ba+VW2DXJK6i9v4Tk7khwZdqeSDcsf561lai0j4X+DMdt4EcRC
        y+NRksafEqBU+wDm2PmxiD17DEb7N51MacLx7nQ+J6SdQtW19irvRsea0Y3M5bqDmurL8k
        yNe7N3GV5MpwMqAmoLIzEtgyaa0z5GY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-152-anO24VlGPESTHwRV7wvb1w-1; Fri, 10 Jun 2022 13:55:48 -0400
X-MC-Unique: anO24VlGPESTHwRV7wvb1w-1
Received: by mail-wr1-f70.google.com with SMTP id o18-20020a5d4a92000000b00213b4eebc25so5729627wrq.21
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 10:55:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KWRY7NWS4wDn/R3vPtY9UepTUBiMvusiY2Rm4T+7aDw=;
        b=M8PuAejGmUYPbOsztOsL7FvORTJ5soMkJcn+oApc1YCLxU+MYDmzVmnhXEcxq3pQK9
         N27R/iSJFDbjo0gXg++0My5srmowDDG7GLosefWF73/gNuTIBC/KPMWNnjeAzdK7WJxF
         +piMZK38dl6r+LDp4t5lcI/8F6YJuoEtt6FOugjW3nqamvfZjPEBYH9VH7U19s4tCL3w
         Rhgy+Qw9fQOFMIVDJ1UqTRezsCh0FoIF2Oc+9TJczntxRhtygKusH9pTpyycXN5MJM+U
         y80HkLmce+zHj/OHzbkDNlFAJpOwfPsg3LYuPWu/lSDY5HbZTFDq8gmCEZnK/AwXcL8W
         M+7g==
X-Gm-Message-State: AOAM532Obkpt2xXjGyRFXp+MNhVc3CNztTwqhIh3wHh52ZjwXZ38uWXi
        /nc2+EWKmplx430xjwuWIi5eQSH3xtlz8RkFqUu3T4Bz290koDBBUn8FXnHXu4G6LWsMYrGcRvM
        6wtLHXNvXnlYq
X-Received: by 2002:adf:d1ef:0:b0:215:89b0:9add with SMTP id g15-20020adfd1ef000000b0021589b09addmr37095496wrd.279.1654883747551;
        Fri, 10 Jun 2022 10:55:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyTU1WD1vucfggcjYM+5/ei4yCdY4DYKVZ6uhgefOKnp9YVsyRyk+q2paNuXDdniukntHnPRQ==
X-Received: by 2002:adf:d1ef:0:b0:215:89b0:9add with SMTP id g15-20020adfd1ef000000b0021589b09addmr37095477wrd.279.1654883747288;
        Fri, 10 Jun 2022 10:55:47 -0700 (PDT)
Received: from gator (cst2-173-67.cust.vodafone.cz. [31.30.173.67])
        by smtp.gmail.com with ESMTPSA id l188-20020a1c25c5000000b0039c6390730bsm3900528wml.29.2022.06.10.10.55.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 10:55:46 -0700 (PDT)
Date:   Fri, 10 Jun 2022 19:55:44 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 138/144] KVM: selftests: Move per-VM/per-vCPU nr pages
 calculation to __vm_create()
Message-ID: <20220610175544.b34q3m7jdqiltkpd@gator>
References: <20220603004331.1523888-1-seanjc@google.com>
 <20220603004331.1523888-139-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603004331.1523888-139-seanjc@google.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 03, 2022 at 12:43:25AM +0000, Sean Christopherson wrote:
...
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 508a5eafe15b..494bce490344 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -258,12 +258,45 @@ struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages)
>  	return vm;
>  }
>  
> -struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint64_t nr_pages)
> +static uint64_t vm_nr_pages_required(uint32_t nr_runnable_vcpus,
> +				     uint64_t extra_mem_pages)
>  {
> +	uint64_t nr_pages;
> +
> +	TEST_ASSERT(nr_runnable_vcpus,
> +		    "Use vm_create_barebones() for VMs that _never_ have vCPUs\n");
> +
> +	TEST_ASSERT(nr_runnable_vcpus <= kvm_check_cap(KVM_CAP_MAX_VCPUS),
> +		    "nr_vcpus = %d too large for host, max-vcpus = %d",
> +		    nr_runnable_vcpus, kvm_check_cap(KVM_CAP_MAX_VCPUS));
> +
> +	nr_pages = DEFAULT_GUEST_PHY_PAGES;
> +	nr_pages += nr_runnable_vcpus * DEFAULT_STACK_PGS;
> +
> +	/*
> +	 * Account for the number of pages needed for the page tables.  The
> +	 * maximum page table size for a memory region will be when the
> +	 * smallest page size is used. Considering each page contains x page
> +	 * table descriptors, the total extra size for page tables (for extra
> +	 * N pages) will be: N/x+N/x^2+N/x^3+... which is definitely smaller
> +	 * than N/x*2.
> +	 */
> +	nr_pages += (nr_pages + extra_mem_pages) / PTES_PER_MIN_PAGE * 2;
> +
> +	TEST_ASSERT(nr_runnable_vcpus <= kvm_check_cap(KVM_CAP_MAX_VCPUS),
> +		    "Host doesn't support %d vCPUs, max-vcpus = %d",
> +		    nr_runnable_vcpus, kvm_check_cap(KVM_CAP_MAX_VCPUS));

This assert is a repeat of the second assert above.

> +
> +	return vm_adjust_num_guest_pages(VM_MODE_DEFAULT, nr_pages);

We should use 'mode' here which means we need to pass it to this helper
from __vm_create.

> +}
> +
> +struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint32_t nr_runnable_vcpus,
> +			   uint64_t nr_extra_pages)
> +{
> +	uint64_t nr_pages = vm_nr_pages_required(nr_runnable_vcpus,
> +						 nr_extra_pages);
>  	struct kvm_vm *vm;
>  
> -	nr_pages = vm_adjust_num_guest_pages(VM_MODE_DEFAULT, nr_pages);
> -
>  	vm = ____vm_create(mode, nr_pages);
>  
>  	kvm_vm_elf_load(vm, program_invocation_name);
> @@ -297,27 +330,12 @@ struct kvm_vm *__vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus
>  				      uint64_t extra_mem_pages,
>  				      void *guest_code, struct kvm_vcpu *vcpus[])
>  {
> -	uint64_t vcpu_pages, extra_pg_pages, pages;
>  	struct kvm_vm *vm;
>  	int i;
>  
>  	TEST_ASSERT(!nr_vcpus || vcpus, "Must provide vCPU array");
>  
> -	/* The maximum page table size for a memory region will be when the
> -	 * smallest pages are used. Considering each page contains x page
> -	 * table descriptors, the total extra size for page tables (for extra
> -	 * N pages) will be: N/x+N/x^2+N/x^3+... which is definitely smaller
> -	 * than N/x*2.
> -	 */
> -	vcpu_pages = nr_vcpus * DEFAULT_STACK_PGS;
> -	extra_pg_pages = (DEFAULT_GUEST_PHY_PAGES + extra_mem_pages + vcpu_pages) / PTES_PER_MIN_PAGE * 2;
> -	pages = DEFAULT_GUEST_PHY_PAGES + vcpu_pages + extra_pg_pages;
> -
> -	TEST_ASSERT(nr_vcpus <= kvm_check_cap(KVM_CAP_MAX_VCPUS),
> -		    "nr_vcpus = %d too large for host, max-vcpus = %d",
> -		    nr_vcpus, kvm_check_cap(KVM_CAP_MAX_VCPUS));
> -
> -	vm = __vm_create(mode, pages);
> +	vm = __vm_create(mode, nr_vcpus, extra_mem_pages);
>  
>  	for (i = 0; i < nr_vcpus; ++i)
>  		vcpus[i] = vm_vcpu_add(vm, i, guest_code);
> diff --git a/tools/testing/selftests/kvm/s390x/resets.c b/tools/testing/selftests/kvm/s390x/resets.c
> index 43fa71d90232..4ba866047401 100644
> --- a/tools/testing/selftests/kvm/s390x/resets.c
> +++ b/tools/testing/selftests/kvm/s390x/resets.c
> @@ -205,7 +205,7 @@ static struct kvm_vm *create_vm(struct kvm_vcpu **vcpu)
>  {
>  	struct kvm_vm *vm;
>  
> -	vm = vm_create(DEFAULT_GUEST_PHY_PAGES);
> +	vm = vm_create(1);
>  
>  	*vcpu = vm_vcpu_add(vm, ARBITRARY_NON_ZERO_VCPU_ID, guest_code_initial);
>  
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> index 012741176ae4..ffa6a2f93de2 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> @@ -339,7 +339,7 @@ static void test_pmu_config_disable(void (*guest_code)(void))
>  	if (!(r & KVM_PMU_CAP_DISABLE))
>  		return;
>  
> -	vm = vm_create(DEFAULT_GUEST_PHY_PAGES);
> +	vm = vm_create(1);
>  
>  	vm_enable_cap(vm, KVM_CAP_PMU_CAPABILITY, KVM_PMU_CAP_DISABLE);
>  
> diff --git a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
> index afc063178c6a..8bcaf4421dc5 100644
> --- a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
> +++ b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
> @@ -78,13 +78,10 @@ static void run_vcpu(struct kvm_vcpu *vcpu)
>  static struct kvm_vm *create_vm(uint32_t nr_vcpus, uint32_t bsp_vcpu_id,
>  				struct kvm_vcpu *vcpus[])
>  {
> -	uint64_t vcpu_pages = (DEFAULT_STACK_PGS) * nr_vcpus;
> -	uint64_t extra_pg_pages = vcpu_pages / PTES_PER_MIN_PAGE * nr_vcpus;
> -	uint64_t pages = DEFAULT_GUEST_PHY_PAGES + vcpu_pages + extra_pg_pages;
>  	struct kvm_vm *vm;
>  	uint32_t i;
>  
> -	vm = vm_create(pages);
> +	vm = vm_create(nr_vcpus);
>  
>  	vm_ioctl(vm, KVM_SET_BOOT_CPU_ID, (void *)(unsigned long)bsp_vcpu_id);
>  
> diff --git a/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c b/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
> index e416af887ca0..4a962952212e 100644
> --- a/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
> +++ b/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
> @@ -98,7 +98,7 @@ int main(int argc, char *argv[])
>  		exit(KSFT_SKIP);
>  	}
>  
> -	vm = vm_create(DEFAULT_GUEST_PHY_PAGES + DEFAULT_STACK_PGS * NR_TEST_VCPUS);
> +	vm = vm_create(NR_TEST_VCPUS);
>  	vm_ioctl(vm, KVM_SET_TSC_KHZ, (void *) TEST_TSC_KHZ);
>  
>  	pthread_spin_init(&create_lock, PTHREAD_PROCESS_PRIVATE);
> -- 
> 2.36.1.255.ge46751e96f-goog
>

Thanks,
drew 

