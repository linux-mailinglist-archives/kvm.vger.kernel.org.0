Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 469646404A7
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 11:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233016AbiLBK3L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 05:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232508AbiLBK3J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 05:29:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A47F41EEE8
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 02:28:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669976882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q5FUqyn1O0bDkZP37DyI12JQ1507j3lFJ1u2Q6lXeNg=;
        b=JMWVDlfpV2tQvm4ckyaNWC701jNY5HFEH76udNW7ElvZDMgZzVbRA9KcfDxVUzLcTd2uOJ
        T6mZs+UUrbKG9gTtqnprwKfvCVScvC/pF4kgMar19HON58p4OQVrJzqCexPlJjhsxcBCxc
        HB3SG2e4ZpFiRMSkJoMlwL66PQfbJ6c=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-556-48aO-7flOn2lxdian5wNpQ-1; Fri, 02 Dec 2022 05:28:01 -0500
X-MC-Unique: 48aO-7flOn2lxdian5wNpQ-1
Received: by mail-qv1-f72.google.com with SMTP id on28-20020a056214449c00b004bbf12d7976so14916154qvb.18
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 02:28:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q5FUqyn1O0bDkZP37DyI12JQ1507j3lFJ1u2Q6lXeNg=;
        b=JLhAUhHnTDyFK/FhyNN32UCP6EhR+n4SQRACLcTopw3pRhtI2fQX9jjJvkQAwyx5Bk
         u1Ns0RghZXCR8JTooG4+VdLAfjnv4oP5etRlNwXAXTSMoGbgzm6qiA9k8HOQTwX7Rby+
         v3/E8Tx7Xme7xIebVx3BZSWFqDPMyL+ktDkUzuFYyJ6jVozxqExMIH5AKz1ebINwZ2qi
         N/yAbIRxOvlS5h+V30Gng6I9pb13eL3+wJbHYNmCViWWNVaXhXNktG2px01O4u4cfiw/
         t3V/W40K3aNHnm25/YqSBxTnOB/hic9Zs01U7eCIL4iCrgbusq+ylwSYdjkHDtgTgzKT
         RC6A==
X-Gm-Message-State: ANoB5pmPZtVsdZ4JxCT2W0/LUJfmarhXZio2IUEZWu0zVHJqDlf1o+aH
        6EGdBymKt64iM0uNc0ezt5JzXmsdPwCyWLqQEaRR1C2k+sW7AThs7vz1DDg3WcojPInxgo9TOpS
        XMB2EsDh5nXiw
X-Received: by 2002:a05:622a:5a94:b0:3a6:89af:f9d9 with SMTP id fz20-20020a05622a5a9400b003a689aff9d9mr13129110qtb.689.1669976880842;
        Fri, 02 Dec 2022 02:28:00 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5K51Xyj0fMKlksNWYTehChcJhoHaXvaaRZIBjlDRyd4BRiaFgpfGGth+7zt1pG7T4wRjYeXg==
X-Received: by 2002:a05:622a:5a94:b0:3a6:89af:f9d9 with SMTP id fz20-20020a05622a5a9400b003a689aff9d9mr13129080qtb.689.1669976880253;
        Fri, 02 Dec 2022 02:28:00 -0800 (PST)
Received: from [192.168.149.123] (58.254.164.109.static.wline.lns.sme.cust.swisscom.ch. [109.164.254.58])
        by smtp.gmail.com with ESMTPSA id q34-20020a05620a2a6200b006fa4cefccd6sm96157qkp.13.2022.12.02.02.27.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 02:27:59 -0800 (PST)
Message-ID: <5fe7beb6-8869-e15c-0a90-c8fd16bb8ddb@redhat.com>
Date:   Fri, 2 Dec 2022 11:27:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH v3 24/27] svm: use svm_test_context in v2
 tests
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Nico Boehr <nrb@linux.ibm.com>,
        Cathy Avery <cavery@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
References: <20221122161152.293072-1-mlevitsk@redhat.com>
 <20221122161152.293072-25-mlevitsk@redhat.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
In-Reply-To: <20221122161152.293072-25-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 22/11/2022 um 17:11 schrieb Maxim Levitsky:
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>

Reviewed-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
> ---
>  x86/svm.c       |  14 +--
>  x86/svm.h       |   7 +-
>  x86/svm_npt.c   |  20 ++--
>  x86/svm_tests.c | 262 ++++++++++++++++++++++++------------------------
>  4 files changed, 152 insertions(+), 151 deletions(-)
> 
> diff --git a/x86/svm.c b/x86/svm.c
> index 6381dee9..06d34ac4 100644
> --- a/x86/svm.c
> +++ b/x86/svm.c
> @@ -76,21 +76,18 @@ static void test_thunk(struct svm_test_context *ctx)
>  }
>  
>  
> -struct svm_test_context *v2_ctx;
> -
> -
> -int __svm_vmrun(u64 rip)
> +int __svm_vmrun(struct svm_test_context *ctx, u64 rip)
>  {
>  	vcpu0.vmcb->save.rip = (ulong)rip;
> -	vcpu0.regs.rdi = (ulong)v2_ctx;
> +	vcpu0.regs.rdi = (ulong)ctx;
>  	vcpu0.regs.rsp = (ulong)(vcpu0.stack);
>  	SVM_VMRUN(&vcpu0);
>  	return vcpu0.vmcb->control.exit_code;
>  }
>  
> -int svm_vmrun(void)
> +int svm_vmrun(struct svm_test_context *ctx)
>  {
> -	return __svm_vmrun((u64)test_thunk);
> +	return __svm_vmrun(ctx, (u64)test_thunk);
>  }
>  
>  static noinline void test_run(struct svm_test_context *ctx)
> @@ -98,8 +95,7 @@ static noinline void test_run(struct svm_test_context *ctx)
>  	svm_vcpu_ident(&vcpu0);
>  
>  	if (ctx->test->v2) {
> -		v2_ctx = ctx;
> -		ctx->test->v2();
> +		ctx->test->v2(ctx);
>  		return;
>  	}
>  
> diff --git a/x86/svm.h b/x86/svm.h
> index 01d07a54..961c4de3 100644
> --- a/x86/svm.h
> +++ b/x86/svm.h
> @@ -23,7 +23,7 @@ struct svm_test {
>  	bool (*finished)(struct svm_test_context *ctx);
>  	bool (*succeeded)(struct svm_test_context *ctx);
>  	/* Alternative test interface. */
> -	void (*v2)(void);
> +	void (*v2)(struct svm_test_context *ctx);
>  	int on_vcpu;
>  };
>  
> @@ -39,9 +39,8 @@ bool default_finished(struct svm_test_context *ctx);
>  int get_test_stage(struct svm_test_context *ctx);
>  void set_test_stage(struct svm_test_context *ctx, int s);
>  void inc_test_stage(struct svm_test_context *ctx);
> -int __svm_vmrun(u64 rip);
> -void __svm_bare_vmrun(void);
> -int svm_vmrun(void);
> +int __svm_vmrun(struct svm_test_context *ctx, u64 rip);
> +int svm_vmrun(struct svm_test_context *ctx);
>  void test_set_guest(test_guest_func func);
>  
>  
> diff --git a/x86/svm_npt.c b/x86/svm_npt.c
> index fe6cbb29..fc16b4be 100644
> --- a/x86/svm_npt.c
> +++ b/x86/svm_npt.c
> @@ -189,7 +189,8 @@ static void basic_guest_main(struct svm_test_context *ctx)
>  {
>  }
>  
> -static void __svm_npt_rsvd_bits_test(u64 * pxe, u64 rsvd_bits, u64 efer,
> +static void __svm_npt_rsvd_bits_test(struct svm_test_context *ctx,
> +				     u64 * pxe, u64 rsvd_bits, u64 efer,
>  				     ulong cr4, u64 guest_efer, ulong guest_cr4)
>  {
>  	u64 pxe_orig = *pxe;
> @@ -204,7 +205,7 @@ static void __svm_npt_rsvd_bits_test(u64 * pxe, u64 rsvd_bits, u64 efer,
>  
>  	*pxe |= rsvd_bits;
>  
> -	exit_reason = svm_vmrun();
> +	exit_reason = svm_vmrun(ctx);
>  
>  	report(exit_reason == SVM_EXIT_NPF,
>  	       "Wanted #NPF on rsvd bits = 0x%lx, got exit = 0x%x", rsvd_bits,
> @@ -236,7 +237,8 @@ static void __svm_npt_rsvd_bits_test(u64 * pxe, u64 rsvd_bits, u64 efer,
>  	*pxe = pxe_orig;
>  }
>  
> -static void _svm_npt_rsvd_bits_test(u64 * pxe, u64 pxe_rsvd_bits, u64 efer,
> +static void _svm_npt_rsvd_bits_test(struct svm_test_context *ctx,
> +				    u64 * pxe, u64 pxe_rsvd_bits, u64 efer,
>  				    ulong cr4, u64 guest_efer, ulong guest_cr4)
>  {
>  	u64 rsvd_bits;
> @@ -277,7 +279,7 @@ static void _svm_npt_rsvd_bits_test(u64 * pxe, u64 pxe_rsvd_bits, u64 efer,
>  		else
>  			guest_cr4 &= ~X86_CR4_SMEP;
>  
> -		__svm_npt_rsvd_bits_test(pxe, rsvd_bits, efer, cr4,
> +		__svm_npt_rsvd_bits_test(ctx, pxe, rsvd_bits, efer, cr4,
>  					 guest_efer, guest_cr4);
>  	}
>  }
> @@ -305,7 +307,7 @@ static u64 get_random_bits(u64 hi, u64 low)
>  	return rsvd_bits;
>  }
>  
> -static void svm_npt_rsvd_bits_test(void)
> +static void svm_npt_rsvd_bits_test(struct svm_test_context *ctx)
>  {
>  	u64 saved_efer, host_efer, sg_efer, guest_efer;
>  	ulong saved_cr4, host_cr4, sg_cr4, guest_cr4;
> @@ -330,22 +332,22 @@ static void svm_npt_rsvd_bits_test(void)
>  	if (cpuid_maxphyaddr() >= 52)
>  		goto skip_pte_test;
>  
> -	_svm_npt_rsvd_bits_test(npt_get_pte((u64) basic_guest_main),
> +	_svm_npt_rsvd_bits_test(ctx, npt_get_pte((u64) basic_guest_main),
>  				get_random_bits(51, cpuid_maxphyaddr()),
>  				host_efer, host_cr4, guest_efer, guest_cr4);
>  
>  skip_pte_test:
> -	_svm_npt_rsvd_bits_test(npt_get_pde((u64) basic_guest_main),
> +	_svm_npt_rsvd_bits_test(ctx, npt_get_pde((u64) basic_guest_main),
>  				get_random_bits(20, 13) | PT_PAGE_SIZE_MASK,
>  				host_efer, host_cr4, guest_efer, guest_cr4);
>  
> -	_svm_npt_rsvd_bits_test(npt_get_pdpe((u64) basic_guest_main),
> +	_svm_npt_rsvd_bits_test(ctx, npt_get_pdpe((u64) basic_guest_main),
>  				PT_PAGE_SIZE_MASK |
>  				(this_cpu_has(X86_FEATURE_GBPAGES) ?
>  				 get_random_bits(29, 13) : 0), host_efer,
>  				host_cr4, guest_efer, guest_cr4);
>  
> -	_svm_npt_rsvd_bits_test(npt_get_pml4e(), BIT_ULL(8),
> +	_svm_npt_rsvd_bits_test(ctx, npt_get_pml4e(), BIT_ULL(8),
>  				host_efer, host_cr4, guest_efer, guest_cr4);
>  
>  	wrmsr(MSR_EFER, saved_efer);
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index c29e9a5d..6041ac24 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -753,7 +753,8 @@ static void svm_tsc_scale_guest(struct svm_test_context *ctx)
>  		cpu_relax();
>  }
>  
> -static void svm_tsc_scale_run_testcase(u64 duration,
> +static void svm_tsc_scale_run_testcase(struct svm_test_context *ctx,
> +				       u64 duration,
>  				       double tsc_scale, u64 tsc_offset)
>  {
>  	u64 start_tsc, actual_duration;
> @@ -766,7 +767,7 @@ static void svm_tsc_scale_run_testcase(u64 duration,
>  
>  	start_tsc = rdtsc();
>  
> -	if (svm_vmrun() != SVM_EXIT_VMMCALL)
> +	if (svm_vmrun(ctx) != SVM_EXIT_VMMCALL)
>  		report_fail("unexpected vm exit code 0x%x", vcpu0.vmcb->control.exit_code);
>  
>  	actual_duration = (rdtsc() - start_tsc) >> TSC_SHIFT;
> @@ -775,7 +776,7 @@ static void svm_tsc_scale_run_testcase(u64 duration,
>  	       duration, actual_duration);
>  }
>  
> -static void svm_tsc_scale_test(void)
> +static void svm_tsc_scale_test(struct svm_test_context *ctx)
>  {
>  	int i;
>  
> @@ -796,11 +797,11 @@ static void svm_tsc_scale_test(void)
>  		report_info("duration=%d, tsc_scale=%d, tsc_offset=%ld",
>  			    duration, (int)(tsc_scale * 100), tsc_offset);
>  
> -		svm_tsc_scale_run_testcase(duration, tsc_scale, tsc_offset);
> +		svm_tsc_scale_run_testcase(ctx, duration, tsc_scale, tsc_offset);
>  	}
>  
> -	svm_tsc_scale_run_testcase(50, 255, rdrand());
> -	svm_tsc_scale_run_testcase(50, 0.0001, rdrand());
> +	svm_tsc_scale_run_testcase(ctx, 50, 255, rdrand());
> +	svm_tsc_scale_run_testcase(ctx, 50, 0.0001, rdrand());
>  }
>  
>  static void latency_prepare(struct svm_test_context *ctx)
> @@ -1983,7 +1984,7 @@ static void svm_cr4_osxsave_test_guest(struct svm_test_context *ctx)
>  	write_cr4(read_cr4() & ~X86_CR4_OSXSAVE);
>  }
>  
> -static void svm_cr4_osxsave_test(void)
> +static void svm_cr4_osxsave_test(struct svm_test_context *ctx)
>  {
>  	if (!this_cpu_has(X86_FEATURE_XSAVE)) {
>  		report_skip("XSAVE not detected");
> @@ -2000,7 +2001,7 @@ static void svm_cr4_osxsave_test(void)
>  	report(this_cpu_has(X86_FEATURE_OSXSAVE), "CPUID.01H:ECX.XSAVE set before VMRUN");
>  
>  	test_set_guest(svm_cr4_osxsave_test_guest);
> -	report(svm_vmrun() == SVM_EXIT_VMMCALL,
> +	report(svm_vmrun(ctx) == SVM_EXIT_VMMCALL,
>  	       "svm_cr4_osxsave_test_guest finished with VMMCALL");
>  
>  	report(this_cpu_has(X86_FEATURE_OSXSAVE), "CPUID.01H:ECX.XSAVE set after VMRUN");
> @@ -2011,7 +2012,7 @@ static void basic_guest_main(struct svm_test_context *ctx)
>  }
>  
>  
> -#define SVM_TEST_REG_RESERVED_BITS(start, end, inc, str_name, reg, val,	\
> +#define SVM_TEST_REG_RESERVED_BITS(ctx, start, end, inc, str_name, reg, val,	\
>  				   resv_mask)				\
>  {									\
>  	u64 tmp, mask;							\
> @@ -2023,12 +2024,12 @@ static void basic_guest_main(struct svm_test_context *ctx)
>  			continue;					\
>  		tmp = val | mask;					\
>  		reg = tmp;						\
> -		report(svm_vmrun() == SVM_EXIT_ERR, "Test %s %d:%d: %lx", \
> +		report(svm_vmrun(ctx) == SVM_EXIT_ERR, "Test %s %d:%d: %lx", \
>  		       str_name, end, start, tmp);			\
>  	}								\
>  }
>  
> -#define SVM_TEST_CR_RESERVED_BITS(start, end, inc, cr, val, resv_mask,	\
> +#define SVM_TEST_CR_RESERVED_BITS(ctx, start, end, inc, cr, val, resv_mask,	\
>  				  exit_code, test_name)			\
>  {									\
>  	u64 tmp, mask;							\
> @@ -2050,13 +2051,13 @@ static void basic_guest_main(struct svm_test_context *ctx)
>  		case 4:							\
>  			vcpu0.vmcb->save.cr4 = tmp;				\
>  		}							\
> -		r = svm_vmrun();					\
> +		r = svm_vmrun(ctx);					\
>  		report(r == exit_code, "Test CR%d %s%d:%d: %lx, wanted exit 0x%x, got 0x%x", \
>  		       cr, test_name, end, start, tmp, exit_code, r);	\
>  	}								\
>  }
>  
> -static void test_efer(void)
> +static void test_efer(struct svm_test_context *ctx)
>  {
>  	/*
>  	 * Un-setting EFER.SVME is illegal
> @@ -2064,10 +2065,10 @@ static void test_efer(void)
>  	u64 efer_saved = vcpu0.vmcb->save.efer;
>  	u64 efer = efer_saved;
>  
> -	report (svm_vmrun() == SVM_EXIT_VMMCALL, "EFER.SVME: %lx", efer);
> +	report (svm_vmrun(ctx) == SVM_EXIT_VMMCALL, "EFER.SVME: %lx", efer);
>  	efer &= ~EFER_SVME;
>  	vcpu0.vmcb->save.efer = efer;
> -	report (svm_vmrun() == SVM_EXIT_ERR, "EFER.SVME: %lx", efer);
> +	report (svm_vmrun(ctx) == SVM_EXIT_ERR, "EFER.SVME: %lx", efer);
>  	vcpu0.vmcb->save.efer = efer_saved;
>  
>  	/*
> @@ -2075,9 +2076,9 @@ static void test_efer(void)
>  	 */
>  	efer_saved = vcpu0.vmcb->save.efer;
>  
> -	SVM_TEST_REG_RESERVED_BITS(8, 9, 1, "EFER", vcpu0.vmcb->save.efer,
> +	SVM_TEST_REG_RESERVED_BITS(ctx, 8, 9, 1, "EFER", vcpu0.vmcb->save.efer,
>  				   efer_saved, SVM_EFER_RESERVED_MASK);
> -	SVM_TEST_REG_RESERVED_BITS(16, 63, 4, "EFER", vcpu0.vmcb->save.efer,
> +	SVM_TEST_REG_RESERVED_BITS(ctx, 16, 63, 4, "EFER", vcpu0.vmcb->save.efer,
>  				   efer_saved, SVM_EFER_RESERVED_MASK);
>  
>  	/*
> @@ -2094,7 +2095,7 @@ static void test_efer(void)
>  	vcpu0.vmcb->save.cr0 = cr0;
>  	cr4 = cr4_saved & ~X86_CR4_PAE;
>  	vcpu0.vmcb->save.cr4 = cr4;
> -	report(svm_vmrun() == SVM_EXIT_ERR, "EFER.LME=1 (%lx), "
> +	report(svm_vmrun(ctx) == SVM_EXIT_ERR, "EFER.LME=1 (%lx), "
>  	       "CR0.PG=1 (%lx) and CR4.PAE=0 (%lx)", efer, cr0, cr4);
>  
>  	/*
> @@ -2107,7 +2108,7 @@ static void test_efer(void)
>  	vcpu0.vmcb->save.cr4 = cr4;
>  	cr0 &= ~X86_CR0_PE;
>  	vcpu0.vmcb->save.cr0 = cr0;
> -	report(svm_vmrun() == SVM_EXIT_ERR, "EFER.LME=1 (%lx), "
> +	report(svm_vmrun(ctx) == SVM_EXIT_ERR, "EFER.LME=1 (%lx), "
>  	       "CR0.PG=1 and CR0.PE=0 (%lx)", efer, cr0);
>  
>  	/*
> @@ -2121,7 +2122,7 @@ static void test_efer(void)
>  	cs_attrib = cs_attrib_saved | SVM_SELECTOR_L_MASK |
>  		SVM_SELECTOR_DB_MASK;
>  	vcpu0.vmcb->save.cs.attrib = cs_attrib;
> -	report(svm_vmrun() == SVM_EXIT_ERR, "EFER.LME=1 (%lx), "
> +	report(svm_vmrun(ctx) == SVM_EXIT_ERR, "EFER.LME=1 (%lx), "
>  	       "CR0.PG=1 (%lx), CR4.PAE=1 (%lx), CS.L=1 and CS.D=1 (%x)",
>  	       efer, cr0, cr4, cs_attrib);
>  
> @@ -2131,7 +2132,7 @@ static void test_efer(void)
>  	vcpu0.vmcb->save.cs.attrib = cs_attrib_saved;
>  }
>  
> -static void test_cr0(void)
> +static void test_cr0(struct svm_test_context *ctx)
>  {
>  	/*
>  	 * Un-setting CR0.CD and setting CR0.NW is illegal combination
> @@ -2142,20 +2143,20 @@ static void test_cr0(void)
>  	cr0 |= X86_CR0_CD;
>  	cr0 &= ~X86_CR0_NW;
>  	vcpu0.vmcb->save.cr0 = cr0;
> -	report (svm_vmrun() == SVM_EXIT_VMMCALL, "Test CR0 CD=1,NW=0: %lx",
> +	report (svm_vmrun(ctx) == SVM_EXIT_VMMCALL, "Test CR0 CD=1,NW=0: %lx",
>  		cr0);
>  	cr0 |= X86_CR0_NW;
>  	vcpu0.vmcb->save.cr0 = cr0;
> -	report (svm_vmrun() == SVM_EXIT_VMMCALL, "Test CR0 CD=1,NW=1: %lx",
> +	report (svm_vmrun(ctx) == SVM_EXIT_VMMCALL, "Test CR0 CD=1,NW=1: %lx",
>  		cr0);
>  	cr0 &= ~X86_CR0_NW;
>  	cr0 &= ~X86_CR0_CD;
>  	vcpu0.vmcb->save.cr0 = cr0;
> -	report (svm_vmrun() == SVM_EXIT_VMMCALL, "Test CR0 CD=0,NW=0: %lx",
> +	report (svm_vmrun(ctx) == SVM_EXIT_VMMCALL, "Test CR0 CD=0,NW=0: %lx",
>  		cr0);
>  	cr0 |= X86_CR0_NW;
>  	vcpu0.vmcb->save.cr0 = cr0;
> -	report (svm_vmrun() == SVM_EXIT_ERR, "Test CR0 CD=0,NW=1: %lx",
> +	report (svm_vmrun(ctx) == SVM_EXIT_ERR, "Test CR0 CD=0,NW=1: %lx",
>  		cr0);
>  	vcpu0.vmcb->save.cr0 = cr0_saved;
>  
> @@ -2164,12 +2165,12 @@ static void test_cr0(void)
>  	 */
>  	cr0 = cr0_saved;
>  
> -	SVM_TEST_REG_RESERVED_BITS(32, 63, 4, "CR0", vcpu0.vmcb->save.cr0, cr0_saved,
> +	SVM_TEST_REG_RESERVED_BITS(ctx, 32, 63, 4, "CR0", vcpu0.vmcb->save.cr0, cr0_saved,
>  				   SVM_CR0_RESERVED_MASK);
>  	vcpu0.vmcb->save.cr0 = cr0_saved;
>  }
>  
> -static void test_cr3(void)
> +static void test_cr3(struct svm_test_context *ctx)
>  {
>  	/*
>  	 * CR3 MBZ bits based on different modes:
> @@ -2177,11 +2178,11 @@ static void test_cr3(void)
>  	 */
>  	u64 cr3_saved = vcpu0.vmcb->save.cr3;
>  
> -	SVM_TEST_CR_RESERVED_BITS(0, 63, 1, 3, cr3_saved,
> +	SVM_TEST_CR_RESERVED_BITS(ctx, 0, 63, 1, 3, cr3_saved,
>  				  SVM_CR3_LONG_MBZ_MASK, SVM_EXIT_ERR, "");
>  
>  	vcpu0.vmcb->save.cr3 = cr3_saved & ~SVM_CR3_LONG_MBZ_MASK;
> -	report(svm_vmrun() == SVM_EXIT_VMMCALL, "Test CR3 63:0: %lx",
> +	report(svm_vmrun(ctx) == SVM_EXIT_VMMCALL, "Test CR3 63:0: %lx",
>  	       vcpu0.vmcb->save.cr3);
>  
>  	/*
> @@ -2197,11 +2198,11 @@ static void test_cr3(void)
>  	 */
>  	if (this_cpu_has(X86_FEATURE_PCID)) {
>  		vcpu0.vmcb->save.cr4 = cr4_saved | X86_CR4_PCIDE;
> -		SVM_TEST_CR_RESERVED_BITS(0, 11, 1, 3, cr3_saved,
> +		SVM_TEST_CR_RESERVED_BITS(ctx, 0, 11, 1, 3, cr3_saved,
>  					  SVM_CR3_LONG_RESERVED_MASK, SVM_EXIT_VMMCALL, "(PCIDE=1) ");
>  
>  		vcpu0.vmcb->save.cr3 = cr3_saved & ~SVM_CR3_LONG_RESERVED_MASK;
> -		report(svm_vmrun() == SVM_EXIT_VMMCALL, "Test CR3 63:0: %lx",
> +		report(svm_vmrun(ctx) == SVM_EXIT_VMMCALL, "Test CR3 63:0: %lx",
>  		       vcpu0.vmcb->save.cr3);
>  	}
>  
> @@ -2213,7 +2214,7 @@ static void test_cr3(void)
>  	/* Clear P (Present) bit in NPT in order to trigger #NPF */
>  	pdpe[0] &= ~1ULL;
>  
> -	SVM_TEST_CR_RESERVED_BITS(0, 11, 1, 3, cr3_saved,
> +	SVM_TEST_CR_RESERVED_BITS(ctx, 0, 11, 1, 3, cr3_saved,
>  				  SVM_CR3_LONG_RESERVED_MASK, SVM_EXIT_NPF, "(PCIDE=0) ");
>  
>  	pdpe[0] |= 1ULL;
> @@ -2224,7 +2225,7 @@ static void test_cr3(void)
>  	 */
>  	pdpe[0] &= ~1ULL;
>  	vcpu0.vmcb->save.cr4 = cr4_saved | X86_CR4_PAE;
> -	SVM_TEST_CR_RESERVED_BITS(0, 2, 1, 3, cr3_saved,
> +	SVM_TEST_CR_RESERVED_BITS(ctx, 0, 2, 1, 3, cr3_saved,
>  				  SVM_CR3_PAE_LEGACY_RESERVED_MASK, SVM_EXIT_NPF, "(PAE) ");
>  
>  	pdpe[0] |= 1ULL;
> @@ -2235,7 +2236,7 @@ skip_npt_only:
>  }
>  
>  /* Test CR4 MBZ bits based on legacy or long modes */
> -static void test_cr4(void)
> +static void test_cr4(struct svm_test_context *ctx)
>  {
>  	u64 cr4_saved = vcpu0.vmcb->save.cr4;
>  	u64 efer_saved = vcpu0.vmcb->save.efer;
> @@ -2243,47 +2244,47 @@ static void test_cr4(void)
>  
>  	efer &= ~EFER_LME;
>  	vcpu0.vmcb->save.efer = efer;
> -	SVM_TEST_CR_RESERVED_BITS(12, 31, 1, 4, cr4_saved,
> +	SVM_TEST_CR_RESERVED_BITS(ctx, 12, 31, 1, 4, cr4_saved,
>  				  SVM_CR4_LEGACY_RESERVED_MASK, SVM_EXIT_ERR, "");
>  
>  	efer |= EFER_LME;
>  	vcpu0.vmcb->save.efer = efer;
> -	SVM_TEST_CR_RESERVED_BITS(12, 31, 1, 4, cr4_saved,
> +	SVM_TEST_CR_RESERVED_BITS(ctx, 12, 31, 1, 4, cr4_saved,
>  				  SVM_CR4_RESERVED_MASK, SVM_EXIT_ERR, "");
> -	SVM_TEST_CR_RESERVED_BITS(32, 63, 4, 4, cr4_saved,
> +	SVM_TEST_CR_RESERVED_BITS(ctx, 32, 63, 4, 4, cr4_saved,
>  				  SVM_CR4_RESERVED_MASK, SVM_EXIT_ERR, "");
>  
>  	vcpu0.vmcb->save.cr4 = cr4_saved;
>  	vcpu0.vmcb->save.efer = efer_saved;
>  }
>  
> -static void test_dr(void)
> +static void test_dr(struct svm_test_context *ctx)
>  {
>  	/*
>  	 * DR6[63:32] and DR7[63:32] are MBZ
>  	 */
>  	u64 dr_saved = vcpu0.vmcb->save.dr6;
>  
> -	SVM_TEST_REG_RESERVED_BITS(32, 63, 4, "DR6", vcpu0.vmcb->save.dr6, dr_saved,
> +	SVM_TEST_REG_RESERVED_BITS(ctx, 32, 63, 4, "DR6", vcpu0.vmcb->save.dr6, dr_saved,
>  				   SVM_DR6_RESERVED_MASK);
>  	vcpu0.vmcb->save.dr6 = dr_saved;
>  
>  	dr_saved = vcpu0.vmcb->save.dr7;
> -	SVM_TEST_REG_RESERVED_BITS(32, 63, 4, "DR7", vcpu0.vmcb->save.dr7, dr_saved,
> +	SVM_TEST_REG_RESERVED_BITS(ctx, 32, 63, 4, "DR7", vcpu0.vmcb->save.dr7, dr_saved,
>  				   SVM_DR7_RESERVED_MASK);
>  
>  	vcpu0.vmcb->save.dr7 = dr_saved;
>  }
>  
>  /* TODO: verify if high 32-bits are sign- or zero-extended on bare metal */
> -#define	TEST_BITMAP_ADDR(save_intercept, type, addr, exit_code,		\
> +#define	TEST_BITMAP_ADDR(ctx, save_intercept, type, addr, exit_code,		\
>  			 msg) {						\
>  		vcpu0.vmcb->control.intercept = saved_intercept | 1ULL << type; \
>  		if (type == INTERCEPT_MSR_PROT)				\
>  			vcpu0.vmcb->control.msrpm_base_pa = addr;		\
>  		else							\
>  			vcpu0.vmcb->control.iopm_base_pa = addr;		\
> -		report(svm_vmrun() == exit_code,			\
> +		report(svm_vmrun(ctx) == exit_code,			\
>  		       "Test %s address: %lx", msg, addr);		\
>  	}
>  
> @@ -2303,48 +2304,48 @@ static void test_dr(void)
>   * Note: Unallocated MSRPM addresses conforming to consistency checks, generate
>   * #NPF.
>   */
> -static void test_msrpm_iopm_bitmap_addrs(void)
> +static void test_msrpm_iopm_bitmap_addrs(struct svm_test_context *ctx)
>  {
>  	u64 saved_intercept = vcpu0.vmcb->control.intercept;
>  	u64 addr_beyond_limit = 1ull << cpuid_maxphyaddr();
>  	u64 addr = virt_to_phys(svm_get_msr_bitmap()) & (~((1ull << 12) - 1));
>  	u8 *io_bitmap = svm_get_io_bitmap();
>  
> -	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_MSR_PROT,
> +	TEST_BITMAP_ADDR(ctx, saved_intercept, INTERCEPT_MSR_PROT,
>  			 addr_beyond_limit - 2 * PAGE_SIZE, SVM_EXIT_ERR,
>  			 "MSRPM");
> -	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_MSR_PROT,
> +	TEST_BITMAP_ADDR(ctx, saved_intercept, INTERCEPT_MSR_PROT,
>  			 addr_beyond_limit - 2 * PAGE_SIZE + 1, SVM_EXIT_ERR,
>  			 "MSRPM");
> -	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_MSR_PROT,
> +	TEST_BITMAP_ADDR(ctx, saved_intercept, INTERCEPT_MSR_PROT,
>  			 addr_beyond_limit - PAGE_SIZE, SVM_EXIT_ERR,
>  			 "MSRPM");
> -	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_MSR_PROT, addr,
> +	TEST_BITMAP_ADDR(ctx, saved_intercept, INTERCEPT_MSR_PROT, addr,
>  			 SVM_EXIT_VMMCALL, "MSRPM");
>  	addr |= (1ull << 12) - 1;
> -	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_MSR_PROT, addr,
> +	TEST_BITMAP_ADDR(ctx, saved_intercept, INTERCEPT_MSR_PROT, addr,
>  			 SVM_EXIT_VMMCALL, "MSRPM");
>  
> -	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_IOIO_PROT,
> +	TEST_BITMAP_ADDR(ctx, saved_intercept, INTERCEPT_IOIO_PROT,
>  			 addr_beyond_limit - 4 * PAGE_SIZE, SVM_EXIT_VMMCALL,
>  			 "IOPM");
> -	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_IOIO_PROT,
> +	TEST_BITMAP_ADDR(ctx, saved_intercept, INTERCEPT_IOIO_PROT,
>  			 addr_beyond_limit - 3 * PAGE_SIZE, SVM_EXIT_VMMCALL,
>  			 "IOPM");
> -	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_IOIO_PROT,
> +	TEST_BITMAP_ADDR(ctx, saved_intercept, INTERCEPT_IOIO_PROT,
>  			 addr_beyond_limit - 2 * PAGE_SIZE - 2, SVM_EXIT_VMMCALL,
>  			 "IOPM");
> -	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_IOIO_PROT,
> +	TEST_BITMAP_ADDR(ctx, saved_intercept, INTERCEPT_IOIO_PROT,
>  			 addr_beyond_limit - 2 * PAGE_SIZE, SVM_EXIT_ERR,
>  			 "IOPM");
> -	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_IOIO_PROT,
> +	TEST_BITMAP_ADDR(ctx, saved_intercept, INTERCEPT_IOIO_PROT,
>  			 addr_beyond_limit - PAGE_SIZE, SVM_EXIT_ERR,
>  			 "IOPM");
>  	addr = virt_to_phys(io_bitmap) & (~((1ull << 11) - 1));
> -	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_IOIO_PROT, addr,
> +	TEST_BITMAP_ADDR(ctx, saved_intercept, INTERCEPT_IOIO_PROT, addr,
>  			 SVM_EXIT_VMMCALL, "IOPM");
>  	addr |= (1ull << 12) - 1;
> -	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_IOIO_PROT, addr,
> +	TEST_BITMAP_ADDR(ctx, saved_intercept, INTERCEPT_IOIO_PROT, addr,
>  			 SVM_EXIT_VMMCALL, "IOPM");
>  
>  	vcpu0.vmcb->control.intercept = saved_intercept;
> @@ -2354,16 +2355,16 @@ static void test_msrpm_iopm_bitmap_addrs(void)
>   * Unlike VMSAVE, VMRUN seems not to update the value of noncanonical
>   * segment bases in the VMCB.  However, VMENTRY succeeds as documented.
>   */
> -#define TEST_CANONICAL_VMRUN(seg_base, msg)				\
> +#define TEST_CANONICAL_VMRUN(ctx, seg_base, msg)				\
>  	saved_addr = seg_base;						\
>  	seg_base = (seg_base & ((1ul << addr_limit) - 1)) | noncanonical_mask; \
> -	return_value = svm_vmrun();					\
> +	return_value = svm_vmrun(ctx);					\
>  	report(return_value == SVM_EXIT_VMMCALL,			\
>  	       "Successful VMRUN with noncanonical %s.base", msg);	\
>  	seg_base = saved_addr;
>  
>  
> -#define TEST_CANONICAL_VMLOAD(seg_base, msg)				\
> +#define TEST_CANONICAL_VMLOAD(ctx, seg_base, msg)				\
>  	saved_addr = seg_base;						\
>  	seg_base = (seg_base & ((1ul << addr_limit) - 1)) | noncanonical_mask; \
>  	asm volatile ("vmload %0" : : "a"(vmcb_phys) : "memory");	\
> @@ -2372,7 +2373,7 @@ static void test_msrpm_iopm_bitmap_addrs(void)
>  	       "Test %s.base for canonical form: %lx", msg, seg_base);	\
>  	seg_base = saved_addr;
>  
> -static void test_canonicalization(void)
> +static void test_canonicalization(struct svm_test_context *ctx)
>  {
>  	u64 saved_addr;
>  	u64 return_value;
> @@ -2382,17 +2383,17 @@ static void test_canonicalization(void)
>  	addr_limit = (this_cpu_has(X86_FEATURE_LA57)) ? 57 : 48;
>  	u64 noncanonical_mask = NONCANONICAL & ~((1ul << addr_limit) - 1);
>  
> -	TEST_CANONICAL_VMLOAD(vcpu0.vmcb->save.fs.base, "FS");
> -	TEST_CANONICAL_VMLOAD(vcpu0.vmcb->save.gs.base, "GS");
> -	TEST_CANONICAL_VMLOAD(vcpu0.vmcb->save.ldtr.base, "LDTR");
> -	TEST_CANONICAL_VMLOAD(vcpu0.vmcb->save.tr.base, "TR");
> -	TEST_CANONICAL_VMLOAD(vcpu0.vmcb->save.kernel_gs_base, "KERNEL GS");
> -	TEST_CANONICAL_VMRUN(vcpu0.vmcb->save.es.base, "ES");
> -	TEST_CANONICAL_VMRUN(vcpu0.vmcb->save.cs.base, "CS");
> -	TEST_CANONICAL_VMRUN(vcpu0.vmcb->save.ss.base, "SS");
> -	TEST_CANONICAL_VMRUN(vcpu0.vmcb->save.ds.base, "DS");
> -	TEST_CANONICAL_VMRUN(vcpu0.vmcb->save.gdtr.base, "GDTR");
> -	TEST_CANONICAL_VMRUN(vcpu0.vmcb->save.idtr.base, "IDTR");
> +	TEST_CANONICAL_VMLOAD(ctx, vcpu0.vmcb->save.fs.base, "FS");
> +	TEST_CANONICAL_VMLOAD(ctx, vcpu0.vmcb->save.gs.base, "GS");
> +	TEST_CANONICAL_VMLOAD(ctx, vcpu0.vmcb->save.ldtr.base, "LDTR");
> +	TEST_CANONICAL_VMLOAD(ctx, vcpu0.vmcb->save.tr.base, "TR");
> +	TEST_CANONICAL_VMLOAD(ctx, vcpu0.vmcb->save.kernel_gs_base, "KERNEL GS");
> +	TEST_CANONICAL_VMRUN(ctx, vcpu0.vmcb->save.es.base, "ES");
> +	TEST_CANONICAL_VMRUN(ctx, vcpu0.vmcb->save.cs.base, "CS");
> +	TEST_CANONICAL_VMRUN(ctx, vcpu0.vmcb->save.ss.base, "SS");
> +	TEST_CANONICAL_VMRUN(ctx, vcpu0.vmcb->save.ds.base, "DS");
> +	TEST_CANONICAL_VMRUN(ctx, vcpu0.vmcb->save.gdtr.base, "GDTR");
> +	TEST_CANONICAL_VMRUN(ctx, vcpu0.vmcb->save.idtr.base, "IDTR");
>  }
>  
>  /*
> @@ -2410,16 +2411,16 @@ static void guest_rflags_test_db_handler(struct ex_regs *r)
>  	r->rflags &= ~X86_EFLAGS_TF;
>  }
>  
> -static void svm_guest_state_test(void)
> +static void svm_guest_state_test(struct svm_test_context *ctx)
>  {
>  	test_set_guest(basic_guest_main);
> -	test_efer();
> -	test_cr0();
> -	test_cr3();
> -	test_cr4();
> -	test_dr();
> -	test_msrpm_iopm_bitmap_addrs();
> -	test_canonicalization();
> +	test_efer(ctx);
> +	test_cr0(ctx);
> +	test_cr3(ctx);
> +	test_cr4(ctx);
> +	test_dr(ctx);
> +	test_msrpm_iopm_bitmap_addrs(ctx);
> +	test_canonicalization(ctx);
>  }
>  
>  extern void guest_rflags_test_guest(struct svm_test_context *ctx);
> @@ -2439,7 +2440,7 @@ asm("guest_rflags_test_guest:\n\t"
>      "pop %rbp\n\t"
>      "ret");
>  
> -static void svm_test_singlestep(void)
> +static void svm_test_singlestep(struct svm_test_context *ctx)
>  {
>  	handle_exception(DB_VECTOR, guest_rflags_test_db_handler);
>  
> @@ -2447,7 +2448,7 @@ static void svm_test_singlestep(void)
>  	 * Trap expected after completion of first guest instruction
>  	 */
>  	vcpu0.vmcb->save.rflags |= X86_EFLAGS_TF;
> -	report (__svm_vmrun((u64)guest_rflags_test_guest) == SVM_EXIT_VMMCALL &&
> +	report (__svm_vmrun(ctx, (u64)guest_rflags_test_guest) == SVM_EXIT_VMMCALL &&
>  		guest_rflags_test_trap_rip == (u64)&insn2,
>  		"Test EFLAGS.TF on VMRUN: trap expected  after completion of first guest instruction");
>  	/*
> @@ -2456,7 +2457,7 @@ static void svm_test_singlestep(void)
>  	guest_rflags_test_trap_rip = 0;
>  	vcpu0.vmcb->save.rip += 3;
>  	vcpu0.vmcb->save.rflags |= X86_EFLAGS_TF;
> -	report(__svm_vmrun(vcpu0.vmcb->save.rip) == SVM_EXIT_VMMCALL &&
> +	report(__svm_vmrun(ctx, vcpu0.vmcb->save.rip) == SVM_EXIT_VMMCALL &&
>  		guest_rflags_test_trap_rip == 0,
>  		"Test EFLAGS.TF on VMRUN: trap not expected");
>  
> @@ -2464,7 +2465,7 @@ static void svm_test_singlestep(void)
>  	 * Let guest finish execution
>  	 */
>  	vcpu0.vmcb->save.rip += 3;
> -	report(__svm_vmrun(vcpu0.vmcb->save.rip) == SVM_EXIT_VMMCALL &&
> +	report(__svm_vmrun(ctx, vcpu0.vmcb->save.rip) == SVM_EXIT_VMMCALL &&
>  		vcpu0.vmcb->save.rip == (u64)&guest_end,
>  		"Test EFLAGS.TF on VMRUN: guest execution completion");
>  }
> @@ -2492,7 +2493,7 @@ static void gp_isr(struct ex_regs *r)
>  	r->rip += 3;
>  }
>  
> -static void svm_vmrun_errata_test(void)
> +static void svm_vmrun_errata_test(struct svm_test_context *ctx)
>  {
>  	unsigned long *last_page = NULL;
>  
> @@ -2543,7 +2544,7 @@ static void vmload_vmsave_guest_main(struct svm_test_context *ctx)
>  	asm volatile ("vmsave %0" : : "a"(vmcb_phys));
>  }
>  
> -static void svm_vmload_vmsave(void)
> +static void svm_vmload_vmsave(struct svm_test_context *ctx)
>  {
>  	u32 intercept_saved = vcpu0.vmcb->control.intercept;
>  
> @@ -2555,7 +2556,7 @@ static void svm_vmload_vmsave(void)
>  	 */
>  	vcpu0.vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMLOAD);
>  	vcpu0.vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMSAVE);
> -	svm_vmrun();
> +	svm_vmrun(ctx);
>  	report(vcpu0.vmcb->control.exit_code == SVM_EXIT_VMMCALL, "Test "
>  	       "VMLOAD/VMSAVE intercept: Expected VMMCALL #VMEXIT");
>  
> @@ -2564,34 +2565,34 @@ static void svm_vmload_vmsave(void)
>  	 * #VMEXIT to host
>  	 */
>  	vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_VMLOAD);
> -	svm_vmrun();
> +	svm_vmrun(ctx);
>  	report(vcpu0.vmcb->control.exit_code == SVM_EXIT_VMLOAD, "Test "
>  	       "VMLOAD/VMSAVE intercept: Expected VMLOAD #VMEXIT");
>  	vcpu0.vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMLOAD);
>  	vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_VMSAVE);
> -	svm_vmrun();
> +	svm_vmrun(ctx);
>  	report(vcpu0.vmcb->control.exit_code == SVM_EXIT_VMSAVE, "Test "
>  	       "VMLOAD/VMSAVE intercept: Expected VMSAVE #VMEXIT");
>  	vcpu0.vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMSAVE);
> -	svm_vmrun();
> +	svm_vmrun(ctx);
>  	report(vcpu0.vmcb->control.exit_code == SVM_EXIT_VMMCALL, "Test "
>  	       "VMLOAD/VMSAVE intercept: Expected VMMCALL #VMEXIT");
>  
>  	vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_VMLOAD);
> -	svm_vmrun();
> +	svm_vmrun(ctx);
>  	report(vcpu0.vmcb->control.exit_code == SVM_EXIT_VMLOAD, "Test "
>  	       "VMLOAD/VMSAVE intercept: Expected VMLOAD #VMEXIT");
>  	vcpu0.vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMLOAD);
> -	svm_vmrun();
> +	svm_vmrun(ctx);
>  	report(vcpu0.vmcb->control.exit_code == SVM_EXIT_VMMCALL, "Test "
>  	       "VMLOAD/VMSAVE intercept: Expected VMMCALL #VMEXIT");
>  
>  	vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_VMSAVE);
> -	svm_vmrun();
> +	svm_vmrun(ctx);
>  	report(vcpu0.vmcb->control.exit_code == SVM_EXIT_VMSAVE, "Test "
>  	       "VMLOAD/VMSAVE intercept: Expected VMSAVE #VMEXIT");
>  	vcpu0.vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMSAVE);
> -	svm_vmrun();
> +	svm_vmrun(ctx);
>  	report(vcpu0.vmcb->control.exit_code == SVM_EXIT_VMMCALL, "Test "
>  	       "VMLOAD/VMSAVE intercept: Expected VMMCALL #VMEXIT");
>  
> @@ -2683,7 +2684,9 @@ static void pause_filter_test_guest_main(struct svm_test_context *ctx)
>  
>  }
>  
> -static void pause_filter_run_test(int pause_iterations, int filter_value, int wait_iterations, int threshold)
> +static void pause_filter_run_test(struct svm_test_context *ctx,
> +				  int pause_iterations, int filter_value,
> +				  int wait_iterations, int threshold)
>  {
>  	test_set_guest(pause_filter_test_guest_main);
>  
> @@ -2692,7 +2695,7 @@ static void pause_filter_run_test(int pause_iterations, int filter_value, int wa
>  
>  	vcpu0.vmcb->control.pause_filter_count = filter_value;
>  	vcpu0.vmcb->control.pause_filter_thresh = threshold;
> -	svm_vmrun();
> +	svm_vmrun(ctx);
>  
>  	if (filter_value <= pause_iterations || wait_iterations < threshold)
>  		report(vcpu0.vmcb->control.exit_code == SVM_EXIT_PAUSE,
> @@ -2702,7 +2705,7 @@ static void pause_filter_run_test(int pause_iterations, int filter_value, int wa
>  		       "no expected PAUSE vmexit");
>  }
>  
> -static void pause_filter_test(void)
> +static void pause_filter_test(struct svm_test_context *ctx)
>  {
>  	if (!pause_filter_supported()) {
>  		report_skip("PAUSE filter not supported in the guest");
> @@ -2712,20 +2715,20 @@ static void pause_filter_test(void)
>  	vcpu0.vmcb->control.intercept |= (1 << INTERCEPT_PAUSE);
>  
>  	// filter count more that pause count - no VMexit
> -	pause_filter_run_test(10, 9, 0, 0);
> +	pause_filter_run_test(ctx, 10, 9, 0, 0);
>  
>  	// filter count smaller pause count - no VMexit
> -	pause_filter_run_test(20, 21, 0, 0);
> +	pause_filter_run_test(ctx, 20, 21, 0, 0);
>  
>  
>  	if (pause_threshold_supported()) {
>  		// filter count smaller pause count - no VMexit +  large enough threshold
>  		// so that filter counter resets
> -		pause_filter_run_test(20, 21, 1000, 10);
> +		pause_filter_run_test(ctx, 20, 21, 1000, 10);
>  
>  		// filter count smaller pause count - no VMexit +  small threshold
>  		// so that filter doesn't reset
> -		pause_filter_run_test(20, 21, 10, 1000);
> +		pause_filter_run_test(ctx, 20, 21, 10, 1000);
>  	} else {
>  		report_skip("PAUSE threshold not supported in the guest");
>  		return;
> @@ -2733,13 +2736,13 @@ static void pause_filter_test(void)
>  }
>  
>  /* If CR0.TS and CR0.EM are cleared in L2, no #NM is generated. */
> -static void svm_no_nm_test(void)
> +static void svm_no_nm_test(struct svm_test_context *ctx)
>  {
>  	write_cr0(read_cr0() & ~X86_CR0_TS);
>  	test_set_guest((test_guest_func)fnop);
>  
>  	vcpu0.vmcb->save.cr0 = vcpu0.vmcb->save.cr0 & ~(X86_CR0_TS | X86_CR0_EM);
> -	report(svm_vmrun() == SVM_EXIT_VMMCALL,
> +	report(svm_vmrun(ctx) == SVM_EXIT_VMMCALL,
>  	       "fnop with CR0.TS and CR0.EM unset no #NM excpetion");
>  }
>  
> @@ -2794,7 +2797,7 @@ extern u64 host_branch4_from, host_branch4_to;
>  
>  u64 dbgctl;
>  
> -static void svm_lbrv_test_guest1(void)
> +static void svm_lbrv_test_guest1(struct svm_test_context *ctx)
>  {
>  	/*
>  	 * This guest expects the LBR to be already enabled when it starts,
> @@ -2818,7 +2821,7 @@ static void svm_lbrv_test_guest1(void)
>  	asm volatile ("vmmcall\n");
>  }
>  
> -static void svm_lbrv_test_guest2(void)
> +static void svm_lbrv_test_guest2(struct svm_test_context *ctx)
>  {
>  	/*
>  	 * This guest expects the LBR to be disabled when it starts,
> @@ -2852,7 +2855,7 @@ static void svm_lbrv_test_guest2(void)
>  	asm volatile ("vmmcall\n");
>  }
>  
> -static void svm_lbrv_test0(void)
> +static void svm_lbrv_test0(struct svm_test_context *ctx)
>  {
>  	report(true, "Basic LBR test");
>  	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
> @@ -2867,7 +2870,7 @@ static void svm_lbrv_test0(void)
>  	check_lbr(&host_branch0_from, &host_branch0_to);
>  }
>  
> -static void svm_lbrv_test1(void)
> +static void svm_lbrv_test1(struct svm_test_context *ctx)
>  {
>  
>  	report(true, "Test that without LBRV enabled, guest LBR state does 'leak' to the host(1)");
> @@ -2890,7 +2893,7 @@ static void svm_lbrv_test1(void)
>  	check_lbr(&guest_branch0_from, &guest_branch0_to);
>  }
>  
> -static void svm_lbrv_test2(void)
> +static void svm_lbrv_test2(struct svm_test_context *ctx)
>  {
>  	report(true, "Test that without LBRV enabled, guest LBR state does 'leak' to the host(2)");
>  
> @@ -2914,7 +2917,7 @@ static void svm_lbrv_test2(void)
>  	check_lbr(&guest_branch2_from, &guest_branch2_to);
>  }
>  
> -static void svm_lbrv_nested_test1(void)
> +static void svm_lbrv_nested_test1(struct svm_test_context *ctx)
>  {
>  	if (!lbrv_supported()) {
>  		report_skip("LBRV not supported in the guest");
> @@ -2949,7 +2952,7 @@ static void svm_lbrv_nested_test1(void)
>  	check_lbr(&host_branch3_from, &host_branch3_to);
>  }
>  
> -static void svm_lbrv_nested_test2(void)
> +static void svm_lbrv_nested_test2(struct svm_test_context *ctx)
>  {
>  	if (!lbrv_supported()) {
>  		report_skip("LBRV not supported in the guest");
> @@ -2999,7 +3002,8 @@ static void dummy_nmi_handler(struct ex_regs *regs)
>  }
>  
>  
> -static void svm_intr_intercept_mix_run_guest(volatile int *counter, int expected_vmexit)
> +static void svm_intr_intercept_mix_run_guest(struct svm_test_context *ctx,
> +					     volatile int *counter, int expected_vmexit)
>  {
>  	if (counter)
>  		*counter = 0;
> @@ -3007,7 +3011,7 @@ static void svm_intr_intercept_mix_run_guest(volatile int *counter, int expected
>  	sti();  // host IF value should not matter
>  	clgi(); // vmrun will set back GI to 1
>  
> -	svm_vmrun();
> +	svm_vmrun(ctx);
>  
>  	if (counter)
>  		report(!*counter, "No interrupt expected");
> @@ -3032,7 +3036,7 @@ static void svm_intr_intercept_mix_if_guest(struct svm_test_context *ctx)
>  	report(0, "must not reach here");
>  }
>  
> -static void svm_intr_intercept_mix_if(void)
> +static void svm_intr_intercept_mix_if(struct svm_test_context *ctx)
>  {
>  	// make a physical interrupt to be pending
>  	handle_irq(0x55, dummy_isr);
> @@ -3044,7 +3048,7 @@ static void svm_intr_intercept_mix_if(void)
>  	test_set_guest(svm_intr_intercept_mix_if_guest);
>  	cli();
>  	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_FIXED | 0x55, 0);
> -	svm_intr_intercept_mix_run_guest(&dummy_isr_recevied, SVM_EXIT_INTR);
> +	svm_intr_intercept_mix_run_guest(ctx, &dummy_isr_recevied, SVM_EXIT_INTR);
>  }
>  
>  
> @@ -3066,7 +3070,7 @@ static void svm_intr_intercept_mix_gif_guest(struct svm_test_context *ctx)
>  	report(0, "must not reach here");
>  }
>  
> -static void svm_intr_intercept_mix_gif(void)
> +static void svm_intr_intercept_mix_gif(struct svm_test_context *ctx)
>  {
>  	handle_irq(0x55, dummy_isr);
>  
> @@ -3077,7 +3081,7 @@ static void svm_intr_intercept_mix_gif(void)
>  	test_set_guest(svm_intr_intercept_mix_gif_guest);
>  	cli();
>  	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_FIXED | 0x55, 0);
> -	svm_intr_intercept_mix_run_guest(&dummy_isr_recevied, SVM_EXIT_INTR);
> +	svm_intr_intercept_mix_run_guest(ctx, &dummy_isr_recevied, SVM_EXIT_INTR);
>  }
>  
>  // subtest: test that a clever guest can trigger an interrupt by setting GIF
> @@ -3096,7 +3100,7 @@ static void svm_intr_intercept_mix_gif_guest2(struct svm_test_context *ctx)
>  	report(0, "must not reach here");
>  }
>  
> -static void svm_intr_intercept_mix_gif2(void)
> +static void svm_intr_intercept_mix_gif2(struct svm_test_context *ctx)
>  {
>  	handle_irq(0x55, dummy_isr);
>  
> @@ -3105,7 +3109,7 @@ static void svm_intr_intercept_mix_gif2(void)
>  	vcpu0.vmcb->save.rflags |= X86_EFLAGS_IF;
>  
>  	test_set_guest(svm_intr_intercept_mix_gif_guest2);
> -	svm_intr_intercept_mix_run_guest(&dummy_isr_recevied, SVM_EXIT_INTR);
> +	svm_intr_intercept_mix_run_guest(ctx, &dummy_isr_recevied, SVM_EXIT_INTR);
>  }
>  
>  
> @@ -3125,7 +3129,7 @@ static void svm_intr_intercept_mix_nmi_guest(struct svm_test_context *ctx)
>  	report(0, "must not reach here");
>  }
>  
> -static void svm_intr_intercept_mix_nmi(void)
> +static void svm_intr_intercept_mix_nmi(struct svm_test_context *ctx)
>  {
>  	handle_exception(2, dummy_nmi_handler);
>  
> @@ -3134,7 +3138,7 @@ static void svm_intr_intercept_mix_nmi(void)
>  	vcpu0.vmcb->save.rflags |= X86_EFLAGS_IF;
>  
>  	test_set_guest(svm_intr_intercept_mix_nmi_guest);
> -	svm_intr_intercept_mix_run_guest(&nmi_recevied, SVM_EXIT_NMI);
> +	svm_intr_intercept_mix_run_guest(ctx, &nmi_recevied, SVM_EXIT_NMI);
>  }
>  
>  // test that pending SMI will be handled when guest enables GIF
> @@ -3151,12 +3155,12 @@ static void svm_intr_intercept_mix_smi_guest(struct svm_test_context *ctx)
>  	report(0, "must not reach here");
>  }
>  
> -static void svm_intr_intercept_mix_smi(void)
> +static void svm_intr_intercept_mix_smi(struct svm_test_context *ctx)
>  {
>  	vcpu0.vmcb->control.intercept |= (1 << INTERCEPT_SMI);
>  	vcpu0.vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
>  	test_set_guest(svm_intr_intercept_mix_smi_guest);
> -	svm_intr_intercept_mix_run_guest(NULL, SVM_EXIT_SMI);
> +	svm_intr_intercept_mix_run_guest(ctx, NULL, SVM_EXIT_SMI);
>  }
>  
>  static void svm_l2_ac_test(void)
> @@ -3198,30 +3202,30 @@ static void svm_exception_handler(struct ex_regs *regs)
>  	vmmcall();
>  }
>  
> -static void handle_exception_in_l2(u8 vector)
> +static void handle_exception_in_l2(struct svm_test_context *ctx, u8 vector)
>  {
>  	handler old_handler = handle_exception(vector, svm_exception_handler);
>  	svm_exception_test_vector = vector;
>  
> -	report(svm_vmrun() == SVM_EXIT_VMMCALL,
> +	report(svm_vmrun(ctx) == SVM_EXIT_VMMCALL,
>  		"%s handled by L2", exception_mnemonic(vector));
>  
>  	handle_exception(vector, old_handler);
>  }
>  
> -static void handle_exception_in_l1(u32 vector)
> +static void handle_exception_in_l1(struct svm_test_context *ctx, u32 vector)
>  {
>  	u32 old_ie = vcpu0.vmcb->control.intercept_exceptions;
>  
>  	vcpu0.vmcb->control.intercept_exceptions |= (1ULL << vector);
>  
> -	report(svm_vmrun() == (SVM_EXIT_EXCP_BASE + vector),
> +	report(svm_vmrun(ctx) == (SVM_EXIT_EXCP_BASE + vector),
>  		"%s handled by L1",  exception_mnemonic(vector));
>  
>  	vcpu0.vmcb->control.intercept_exceptions = old_ie;
>  }
>  
> -static void svm_exception_test(void)
> +static void svm_exception_test(struct svm_test_context *ctx)
>  {
>  	struct svm_exception_test *t;
>  	int i;
> @@ -3230,10 +3234,10 @@ static void svm_exception_test(void)
>  		t = &svm_exception_tests[i];
>  		test_set_guest((test_guest_func)t->guest_code);
>  
> -		handle_exception_in_l2(t->vector);
> +		handle_exception_in_l2(ctx, t->vector);
>  		svm_vcpu_ident(&vcpu0);
>  
> -		handle_exception_in_l1(t->vector);
> +		handle_exception_in_l1(ctx, t->vector);
>  		svm_vcpu_ident(&vcpu0);
>  	}
>  }
> @@ -3244,12 +3248,12 @@ static void shutdown_intercept_test_guest(struct svm_test_context *ctx)
>  	report_fail("should not reach here\n");
>  
>  }
> -static void svm_shutdown_intercept_test(void)
> +static void svm_shutdown_intercept_test(struct svm_test_context *ctx)
>  {
>  	test_set_guest(shutdown_intercept_test_guest);
>  	vcpu0.vmcb->save.idtr.base = (u64)alloc_vpage();
>  	vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_SHUTDOWN);
> -	svm_vmrun();
> +	svm_vmrun(ctx);
>  	report(vcpu0.vmcb->control.exit_code == SVM_EXIT_SHUTDOWN, "shutdown test passed");
>  }
>  
> 

