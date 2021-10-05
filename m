Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABBC42281A
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 15:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234274AbhJENly (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 09:41:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36405 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233975AbhJENlx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 09:41:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633441202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xkZ7lrOc52SpIlQsoFwfbYAFQ2eYBcXDLzHRnbVjlKk=;
        b=XcZ4+rj2yAAOSyJlh8RlYvuPwOzds/sOj2M3yebzFbxNjYM9Fdh9eTS5QkRemdA+pfeW4s
        pTYt0tq5Gz30kXNcp9KVoHsojjIk53IrEZ+scZgS5EuZ8Bsi8eKYP8qZ++hjxdGcUUQZOz
        Gz6Rk3AQL6JsGA9g1OUGM9JJZg+aJ9s=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-D1j2PHx0Ms2LK1jzQhtuqg-1; Tue, 05 Oct 2021 09:40:01 -0400
X-MC-Unique: D1j2PHx0Ms2LK1jzQhtuqg-1
Received: by mail-ed1-f69.google.com with SMTP id 14-20020a508e4e000000b003d84544f33eso20699129edx.2
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 06:40:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xkZ7lrOc52SpIlQsoFwfbYAFQ2eYBcXDLzHRnbVjlKk=;
        b=766m0OaxMDE0Wbl9Fujp98w2rQ7VBPnncGloZkzwE2yHjM5fwT75Ao99BcBGD4Is46
         90VmzS76EeL2GDrnZ3indnZEJkF+7HJ0z4ozbAVZ3EWTOePx3mSdy7BCaBYtCTH8jkn+
         qEWGwIIUoFqPPQicAGDitmLPQ78/VOwrbDWuyot1iqW7UN3BsI7Y59X5M/Fpe3nqCtZS
         ccOLYkFlJHGdTg8Az1ankoWs6/S1E615r9XEIK+U3JzIp2QWwYWLsWs0GjG7bIKJhXq6
         SwkvpQE8edwZ/Yhn/FL5TypAStRP9GdFILyLa6uFM1BWtWrAEKVRZ5w4wif7ZA1y36le
         1e2Q==
X-Gm-Message-State: AOAM530T8PL3oA/I5vztOJIMUapjXOunNSI2A6rFAbNnEsnPcrklDcvE
        MB7xicIi1pF9S7XGYQnpMfbWwL2Hy/g1dJ8NnjOGfsl1L0fO5dEdsdX2RI7Q+nowEOaruSpGI9o
        KV0C3NjkKdnyT
X-Received: by 2002:a17:906:12d8:: with SMTP id l24mr23896102ejb.126.1633441200328;
        Tue, 05 Oct 2021 06:40:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz39b9xeb88B+Tq2u6NemnrgpudLSmPjVmR28IuPv0hGV6cYhkyqIPK48utmKUQViIcG4HDIg==
X-Received: by 2002:a17:906:12d8:: with SMTP id l24mr23896080ejb.126.1633441200099;
        Tue, 05 Oct 2021 06:40:00 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id w11sm2174150edl.87.2021.10.05.06.39.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 06:39:59 -0700 (PDT)
Date:   Tue, 5 Oct 2021 15:39:57 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 08/11] selftests: KVM: Create helper for making SMCCC
 calls
Message-ID: <20211005133957.q2a52s5mbthj6b4k@gator.home>
References: <20210923191610.3814698-1-oupton@google.com>
 <20210923191610.3814698-9-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210923191610.3814698-9-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 23, 2021 at 07:16:07PM +0000, Oliver Upton wrote:
> The PSCI and PV stolen time tests both need to make SMCCC calls within
> the guest. Create a helper for making SMCCC calls and rework the
> existing tests to use the library function.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  .../testing/selftests/kvm/aarch64/psci_test.c | 25 ++++++-------------
>  .../selftests/kvm/include/aarch64/processor.h | 22 ++++++++++++++++
>  .../selftests/kvm/lib/aarch64/processor.c     | 25 +++++++++++++++++++
>  tools/testing/selftests/kvm/steal_time.c      | 13 +++-------
>  4 files changed, 58 insertions(+), 27 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
> index 018c269990e1..cebea7356e5a 100644
> --- a/tools/testing/selftests/kvm/aarch64/psci_test.c
> +++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
> @@ -26,32 +26,23 @@
>  static uint64_t psci_cpu_on(uint64_t target_cpu, uint64_t entry_addr,
>  			    uint64_t context_id)
>  {
> -	register uint64_t x0 asm("x0") = PSCI_0_2_FN64_CPU_ON;
> -	register uint64_t x1 asm("x1") = target_cpu;
> -	register uint64_t x2 asm("x2") = entry_addr;
> -	register uint64_t x3 asm("x3") = context_id;
> +	struct arm_smccc_res res;
>  
> -	asm("hvc #0"
> -	    : "=r"(x0)
> -	    : "r"(x0), "r"(x1), "r"(x2), "r"(x3)
> -	    : "memory");
> +	smccc_hvc(PSCI_0_2_FN64_CPU_ON, target_cpu, entry_addr, context_id,
> +		  0, 0, 0, 0, &res);
>  
> -	return x0;
> +	return res.a0;
>  }
>  
>  static uint64_t psci_affinity_info(uint64_t target_affinity,
>  				   uint64_t lowest_affinity_level)
>  {
> -	register uint64_t x0 asm("x0") = PSCI_0_2_FN64_AFFINITY_INFO;
> -	register uint64_t x1 asm("x1") = target_affinity;
> -	register uint64_t x2 asm("x2") = lowest_affinity_level;
> +	struct arm_smccc_res res;
>  
> -	asm("hvc #0"
> -	    : "=r"(x0)
> -	    : "r"(x0), "r"(x1), "r"(x2)
> -	    : "memory");
> +	smccc_hvc(PSCI_0_2_FN64_AFFINITY_INFO, target_affinity, lowest_affinity_level,
> +		  0, 0, 0, 0, 0, &res);
>  
> -	return x0;
> +	return res.a0;
>  }
>  
>  static void guest_main(uint64_t target_cpu)
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index c0273aefa63d..e6b7cb65d158 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -132,4 +132,26 @@ void vm_install_sync_handler(struct kvm_vm *vm,
>  
>  #define isb()	asm volatile("isb" : : : "memory")
>  
> +/**
> + * struct arm_smccc_res - Result from SMC/HVC call
> + * @a0-a3 result values from registers 0 to 3
> + */
> +struct arm_smccc_res {
> +	unsigned long a0;
> +	unsigned long a1;
> +	unsigned long a2;
> +	unsigned long a3;
> +};
> +
> +/**
> + * smccc_hvc - Invoke a SMCCC function using the hvc conduit
> + * @function_id: the SMCCC function to be called
> + * @arg0-arg6: SMCCC function arguments, corresponding to registers x1-x7
> + * @res: pointer to write the return values from registers x0-x3
> + *
> + */
> +void smccc_hvc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
> +	       uint64_t arg2, uint64_t arg3, uint64_t arg4, uint64_t arg5,
> +	       uint64_t arg6, struct arm_smccc_res *res);
> +
>  #endif /* SELFTEST_KVM_PROCESSOR_H */
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index 632b74d6b3ca..f77430e2d688 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -426,3 +426,28 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
>  	assert(vector < VECTOR_NUM);
>  	handlers->exception_handlers[vector][0] = handler;
>  }
> +
> +void smccc_hvc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
> +	       uint64_t arg2, uint64_t arg3, uint64_t arg4, uint64_t arg5,
> +	       uint64_t arg6, struct arm_smccc_res *res)
> +{
> +	asm volatile("mov   w0, %w[function_id]\n"
> +		     "mov   x1, %[arg0]\n"
> +		     "mov   x2, %[arg1]\n"
> +		     "mov   x3, %[arg2]\n"
> +		     "mov   x4, %[arg3]\n"
> +		     "mov   x5, %[arg4]\n"
> +		     "mov   x6, %[arg5]\n"
> +		     "mov   x7, %[arg6]\n"
> +		     "hvc   #0\n"
> +		     "mov   %[res0], x0\n"
> +		     "mov   %[res1], x1\n"
> +		     "mov   %[res2], x2\n"
> +		     "mov   %[res3], x3\n"
> +		     : [res0] "=r"(res->a0), [res1] "=r"(res->a1),
> +		       [res2] "=r"(res->a2), [res3] "=r"(res->a3)
> +		     : [function_id] "r"(function_id), [arg0] "r"(arg0),
> +		       [arg1] "r"(arg1), [arg2] "r"(arg2), [arg3] "r"(arg3),
> +		       [arg4] "r"(arg4), [arg5] "r"(arg5), [arg6] "r"(arg6)
> +		     : "x0", "x1", "x2", "x3", "x4", "x5", "x6", "x7");
> +}
> diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
> index ecec30865a74..5d52b82226c5 100644
> --- a/tools/testing/selftests/kvm/steal_time.c
> +++ b/tools/testing/selftests/kvm/steal_time.c
> @@ -120,17 +120,10 @@ struct st_time {
>  
>  static int64_t smccc(uint32_t func, uint32_t arg)
>  {
> -	unsigned long ret;
> +	struct arm_smccc_res res;
>  
> -	asm volatile(
> -		"mov	x0, %1\n"
> -		"mov	x1, %2\n"
> -		"hvc	#0\n"
> -		"mov	%0, x0\n"
> -	: "=r" (ret) : "r" (func), "r" (arg) :
> -	  "x0", "x1", "x2", "x3");
> -
> -	return ret;
> +	smccc_hvc(func, arg, 0, 0, 0, 0, 0, 0, &res);
> +	return res.a0;
>  }
>  
>  static void check_status(struct st_time *st)
> -- 
> 2.33.0.685.g46640cef36-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

