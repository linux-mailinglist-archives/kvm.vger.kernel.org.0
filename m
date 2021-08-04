Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29E823DFFC5
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 13:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237432AbhHDLDg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 07:03:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58108 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235764AbhHDLDf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Aug 2021 07:03:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628075002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S1iL8Km0oaU1hyCCL5LNwK2V4oZKfOIQ2vsQgM5B4Go=;
        b=VQdqtEFkSPnQmezoBacTC4SxggA6qP/67ubsz/sPhxCXOEUM4u3VjsixsGlA8AMplujGdv
        TjdXWjaGfGPxPGxAVGhfqERU6kb6/ITyYiY8A5soT0sKDXmbwDjCHiO9Sj+YCwIbFcdbHM
        1rgadCqhgyA/mG940pJN2R5/jsatt2c=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-xtli3RX1MMuoQPerOub5Cg-1; Wed, 04 Aug 2021 07:03:21 -0400
X-MC-Unique: xtli3RX1MMuoQPerOub5Cg-1
Received: by mail-ej1-f71.google.com with SMTP id ne21-20020a1709077b95b029057eb61c6fdfso679952ejc.22
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 04:03:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S1iL8Km0oaU1hyCCL5LNwK2V4oZKfOIQ2vsQgM5B4Go=;
        b=du3yQomU6FPUhkTIinelD8Hgz6E50Fwsli43Ew+7sG+B3KwrvrJ9gGP9AV/MzOZow8
         3shAjuOI69xdPPJIcfwrfcGkiJJMrEVjNXJCzP1IvauykwfW3x+JY6NzZjPvvGoZzTA0
         CGvUH382rZTfWBnveRUi9i0kUc4eb3H3icAFZey0ojqQiDJ1H6bfSyVks3BWUdTkNB0n
         yxht93AEu6XqGmDiXF2yhKP02GY8g47m8L3covMt0X74cdP3GIIPpZhFGgPJozV5j+C1
         ydMFNa+r96XBUMQGPi2dvjTjIlW4xHLSuzaRjkmatpMPihuTYYfqIDjWdstMERCkhMDD
         h0kQ==
X-Gm-Message-State: AOAM532uzdb13y2ncOil0Y7nG8+ZoyJcSuhR6g33Sm8XCnSPlwnmCgrF
        Wjseia7OrcDrJjqs1vzKq/7AgI8SmxJcHWtcJ16SkMcEWMQGTp780SMR16cm17eKxyKbp+XsLel
        OqfGgoeKyGUsd
X-Received: by 2002:aa7:c042:: with SMTP id k2mr31971977edo.104.1628075000463;
        Wed, 04 Aug 2021 04:03:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJytmqyypODz5oMdPE5pY9yGVOKv6+wiZO2uHQgs8zCZ3FrZMIHAYmG5P5O16ooSFth4kPz6sQ==
X-Received: by 2002:aa7:c042:: with SMTP id k2mr31971957edo.104.1628075000291;
        Wed, 04 Aug 2021 04:03:20 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id fr4sm571351ejc.42.2021.08.04.04.03.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 04:03:19 -0700 (PDT)
Date:   Wed, 4 Aug 2021 13:03:17 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v6 20/21] selftests: KVM: Test physical counter offsetting
Message-ID: <20210804110317.z7iqgbtbiyfvy45h@gator.home>
References: <20210804085819.846610-1-oupton@google.com>
 <20210804085819.846610-21-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210804085819.846610-21-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 04, 2021 at 08:58:18AM +0000, Oliver Upton wrote:
> Test that userspace adjustment of the guest physical counter-timer
> results in the correct view within the guest.
> 
> Cc: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  .../selftests/kvm/include/aarch64/processor.h | 12 +++++++
>  .../kvm/system_counter_offset_test.c          | 31 +++++++++++++++++--
>  2 files changed, 40 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index 3168cdbae6ee..7f53d90e9512 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -141,4 +141,16 @@ static inline uint64_t read_cntvct_ordered(void)
>  	return r;
>  }
>  
> +static inline uint64_t read_cntpct_ordered(void)
> +{
> +	uint64_t r;
> +
> +	__asm__ __volatile__("isb\n\t"
> +			     "mrs %0, cntpct_el0\n\t"
> +			     "isb\n\t"
> +			     : "=r"(r));
> +
> +	return r;
> +}
> +
>  #endif /* SELFTEST_KVM_PROCESSOR_H */
> diff --git a/tools/testing/selftests/kvm/system_counter_offset_test.c b/tools/testing/selftests/kvm/system_counter_offset_test.c
> index ac933db83d03..82d26a45cc48 100644
> --- a/tools/testing/selftests/kvm/system_counter_offset_test.c
> +++ b/tools/testing/selftests/kvm/system_counter_offset_test.c
> @@ -57,6 +57,9 @@ static uint64_t host_read_guest_system_counter(struct test_case *test)
>  
>  enum arch_counter {
>  	VIRTUAL,
> +	PHYSICAL,
> +	/* offset physical, read virtual */
> +	PHYSICAL_READ_VIRTUAL,
>  };
>  
>  struct test_case {
> @@ -68,32 +71,54 @@ static struct test_case test_cases[] = {
>  	{ .counter = VIRTUAL, .offset = 0 },
>  	{ .counter = VIRTUAL, .offset = 180 * NSEC_PER_SEC },
>  	{ .counter = VIRTUAL, .offset = -180 * NSEC_PER_SEC },
> +	{ .counter = PHYSICAL, .offset = 0 },
> +	{ .counter = PHYSICAL, .offset = 180 * NSEC_PER_SEC },
> +	{ .counter = PHYSICAL, .offset = -180 * NSEC_PER_SEC },
> +	{ .counter = PHYSICAL_READ_VIRTUAL, .offset = 0 },
> +	{ .counter = PHYSICAL_READ_VIRTUAL, .offset = 180 * NSEC_PER_SEC },
> +	{ .counter = PHYSICAL_READ_VIRTUAL, .offset = -180 * NSEC_PER_SEC },
>  };
>  
>  static void check_preconditions(struct kvm_vm *vm)
>  {
> -	if (vcpu_has_reg(vm, VCPU_ID, KVM_REG_ARM_TIMER_OFFSET))
> +	if (vcpu_has_reg(vm, VCPU_ID, KVM_REG_ARM_TIMER_OFFSET) &&
> +	    !_vcpu_has_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
> +				   KVM_ARM_VCPU_TIMER_OFFSET))
>  		return;
>  
> -	print_skip("KVM_REG_ARM_TIMER_OFFSET not supported; skipping test");
> +	print_skip("KVM_REG_ARM_TIMER_OFFSET|KVM_ARM_VCPU_TIMER_OFFSET not supported; skipping test");
>  	exit(KSFT_SKIP);
>  }
>  
>  static void setup_system_counter(struct kvm_vm *vm, struct test_case *test)
>  {
> +	uint64_t cntvoff, cntpoff;
>  	struct kvm_one_reg reg = {
>  		.id = KVM_REG_ARM_TIMER_OFFSET,
> -		.addr = (__u64)&test->offset,
> +		.addr = (__u64)&cntvoff,
>  	};
>  
> +	if (test->counter == VIRTUAL) {
> +		cntvoff = test->offset;
> +		cntpoff = 0;
> +	} else {
> +		cntvoff = 0;
> +		cntpoff = test->offset;
> +	}
> +
>  	vcpu_set_reg(vm, VCPU_ID, &reg);
> +	vcpu_access_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
> +				KVM_ARM_VCPU_TIMER_OFFSET, &cntpoff, true);
>  }
>  
>  static uint64_t guest_read_system_counter(struct test_case *test)
>  {
>  	switch (test->counter) {
>  	case VIRTUAL:
> +	case PHYSICAL_READ_VIRTUAL:
>  		return read_cntvct_ordered();
> +	case PHYSICAL:
> +		return read_cntpct_ordered();
>  	default:
>  		GUEST_ASSERT(0);
>  	}
> -- 
> 2.32.0.605.g8dce9f2422-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

