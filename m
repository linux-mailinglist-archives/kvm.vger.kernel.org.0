Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9005E640483
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 11:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233271AbiLBKXQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 05:23:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233001AbiLBKXO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 05:23:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60E5DCD7B4
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 02:22:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669976535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GIEsYQePI5kV4DQq+ycROhBr0Mvbsz8l50TBjricZ0M=;
        b=KMIr1i6cr6p/atwj1t8qicsaTMrIysw2GoN3LLWjCNDl69uTuXl5OLyfIfwAswmi+QLezr
        fwwnu3hj5gzlzm+im4fDlXSvAFieRxXjBi3y67BGYPFZxFWPkCXRVUG7LlvubxSEdi5r0P
        vDWLa+Rz3enblJI9CGH0Edf1Cwvy7qo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-368-cJxtmUoSOQe0kLcApRyYVQ-1; Fri, 02 Dec 2022 05:22:13 -0500
X-MC-Unique: cJxtmUoSOQe0kLcApRyYVQ-1
Received: by mail-wr1-f71.google.com with SMTP id s1-20020adfa281000000b00241f7467851so966974wra.17
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 02:22:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GIEsYQePI5kV4DQq+ycROhBr0Mvbsz8l50TBjricZ0M=;
        b=7qSC10DHIv3rCnzcOwAimSkvakjLX1pBLNbNkjiGkmy77PRVnGNE9eBgBx8416vXFV
         9tzE2GJ1smQrgpcDZpw98LainVCfYkPu66zFl2+LxU+Rb8cGju4qRkG9QT+3e3h8rwIi
         PJ46D1+QyI5jrZnZWFCEXjQf3iXzAH9u2akydMOzXuPBqKIc0zLahwFlqNYFH3ivgWuS
         9ClkdvwEsYRS0MQQqYLStc0tOivBjdO3VwbMvHE545jX8lqOMwAJl8QjOSt1G/hfpyHn
         8G1nrs3E7fDKw+ITvT5MYjnAZyU1ADZuX70AefRdb8HKTDApskxVChqHG9k+vHQ/GujC
         lWuw==
X-Gm-Message-State: ANoB5pnSOc4RN4wkC9cgHImwc8BZg4I2SMYdlnRH6yxUCTTRzIHRFRap
        2SaGOan1MRmeov49/WQ26k0DDaR4ZszWTRQx6lj1tw0+x2S15DCOIK1N76jFi09Hbwzsa1pnPrd
        v6iOagbvKH8R4
X-Received: by 2002:a5d:4c4a:0:b0:236:6101:7b7d with SMTP id n10-20020a5d4c4a000000b0023661017b7dmr30780088wrt.484.1669976530992;
        Fri, 02 Dec 2022 02:22:10 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7ya9W73u55cViEkMv8kkWDevwoin7fEYZnci4K59QOZBlxsMifBd4NcV6y+GqwYA+WBghx1A==
X-Received: by 2002:a5d:4c4a:0:b0:236:6101:7b7d with SMTP id n10-20020a5d4c4a000000b0023661017b7dmr30780057wrt.484.1669976530004;
        Fri, 02 Dec 2022 02:22:10 -0800 (PST)
Received: from [192.168.149.123] (58.254.164.109.static.wline.lns.sme.cust.swisscom.ch. [109.164.254.58])
        by smtp.gmail.com with ESMTPSA id bk4-20020a0560001d8400b00241da0e018dsm6504217wrb.29.2022.12.02.02.22.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 02:22:09 -0800 (PST)
Message-ID: <56825534-f085-26fa-cfca-db411ad14239@redhat.com>
Date:   Fri, 2 Dec 2022 11:22:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH v3 25/27] svm: move nested vcpu to test
 context
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
 <20221122161152.293072-26-mlevitsk@redhat.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
In-Reply-To: <20221122161152.293072-26-mlevitsk@redhat.com>
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
> This moves vcpu0 into svm_test_context and renames it to vcpu
> to show that this is the current test vcpu
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>

Those are exactly the same changes that you did in patch 22. Maybe
squash them together? Reordering the patches of course.

> ---
>  x86/svm.c       |  26 +-
>  x86/svm.h       |   5 +-
>  x86/svm_npt.c   |  54 ++--
>  x86/svm_tests.c | 753 ++++++++++++++++++++++++++++--------------------
>  4 files changed, 486 insertions(+), 352 deletions(-)
> 
> diff --git a/x86/svm.c b/x86/svm.c
> index 06d34ac4..a3279545 100644
> --- a/x86/svm.c
> +++ b/x86/svm.c
> @@ -16,8 +16,6 @@
>  #include "apic.h"
>  #include "svm_lib.h"
>  
> -struct svm_vcpu vcpu0;
> -
>  bool smp_supported(void)
>  {
>  	return cpu_count() > 1;
> @@ -78,11 +76,11 @@ static void test_thunk(struct svm_test_context *ctx)
>  
>  int __svm_vmrun(struct svm_test_context *ctx, u64 rip)
>  {
> -	vcpu0.vmcb->save.rip = (ulong)rip;
> -	vcpu0.regs.rdi = (ulong)ctx;
> -	vcpu0.regs.rsp = (ulong)(vcpu0.stack);
> -	SVM_VMRUN(&vcpu0);
> -	return vcpu0.vmcb->control.exit_code;
> +	ctx->vcpu->vmcb->save.rip = (ulong)rip;
> +	ctx->vcpu->regs.rdi = (ulong)ctx;
> +	ctx->vcpu->regs.rsp = (ulong)(ctx->vcpu->stack);
> +	SVM_VMRUN(ctx->vcpu);
> +	return ctx->vcpu->vmcb->control.exit_code;
>  }
>  
>  int svm_vmrun(struct svm_test_context *ctx)
> @@ -92,7 +90,7 @@ int svm_vmrun(struct svm_test_context *ctx)
>  
>  static noinline void test_run(struct svm_test_context *ctx)
>  {
> -	svm_vcpu_ident(&vcpu0);
> +	svm_vcpu_ident(ctx->vcpu);
>  
>  	if (ctx->test->v2) {
>  		ctx->test->v2(ctx);
> @@ -103,9 +101,9 @@ static noinline void test_run(struct svm_test_context *ctx)
>  
>  	ctx->test->prepare(ctx);
>  	guest_main = ctx->test->guest_func;
> -	vcpu0.vmcb->save.rip = (ulong)test_thunk;
> -	vcpu0.regs.rsp = (ulong)(vcpu0.stack);
> -	vcpu0.regs.rdi = (ulong)ctx;
> +	ctx->vcpu->vmcb->save.rip = (ulong)test_thunk;
> +	ctx->vcpu->regs.rsp = (ulong)(ctx->vcpu->stack);
> +	ctx->vcpu->regs.rdi = (ulong)ctx;
>  	do {
>  
>  		clgi();
> @@ -113,7 +111,7 @@ static noinline void test_run(struct svm_test_context *ctx)
>  
>  		ctx->test->prepare_gif_clear(ctx);
>  
> -		__SVM_VMRUN(&vcpu0, "vmrun_rip");
> +		__SVM_VMRUN(ctx->vcpu, "vmrun_rip");
>  
>  		cli();
>  		stgi();
> @@ -182,13 +180,15 @@ int run_svm_tests(int ac, char **av, struct svm_test *svm_tests)
>  		return 0;
>  
>  	struct svm_test_context ctx;
> +	struct svm_vcpu vcpu;
>  
> -	svm_vcpu_init(&vcpu0);
> +	svm_vcpu_init(&vcpu);
>  
>  	for (; svm_tests[i].name != NULL; i++) {
>  
>  		memset(&ctx, 0, sizeof(ctx));
>  		ctx.test = &svm_tests[i];
> +		ctx.vcpu = &vcpu;
>  
>  		if (!test_wanted(svm_tests[i].name, av, ac))
>  			continue;
> diff --git a/x86/svm.h b/x86/svm.h
> index 961c4de3..ec181715 100644
> --- a/x86/svm.h
> +++ b/x86/svm.h
> @@ -12,6 +12,9 @@ struct svm_test_context {
>  	ulong scratch;
>  	bool on_vcpu_done;
>  	struct svm_test *test;
> +
> +	/* TODO: test cases currently are single threaded */
> +	struct svm_vcpu *vcpu;
>  };
>  
>  struct svm_test {
> @@ -44,6 +47,4 @@ int svm_vmrun(struct svm_test_context *ctx);
>  void test_set_guest(test_guest_func func);
>  
>  
> -extern struct svm_vcpu vcpu0;
> -
>  #endif
> diff --git a/x86/svm_npt.c b/x86/svm_npt.c
> index fc16b4be..39fd7198 100644
> --- a/x86/svm_npt.c
> +++ b/x86/svm_npt.c
> @@ -27,23 +27,26 @@ static void npt_np_test(struct svm_test_context *ctx)
>  
>  static bool npt_np_check(struct svm_test_context *ctx)
>  {
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
>  	u64 *pte = npt_get_pte((u64) scratch_page);
>  
>  	*pte |= 1ULL;
>  
> -	return (vcpu0.vmcb->control.exit_code == SVM_EXIT_NPF)
> -	    && (vcpu0.vmcb->control.exit_info_1 == 0x100000004ULL);
> +	return (vmcb->control.exit_code == SVM_EXIT_NPF)
> +	    && (vmcb->control.exit_info_1 == 0x100000004ULL);
>  }
>  
>  static void npt_nx_prepare(struct svm_test_context *ctx)
>  {
>  	u64 *pte;
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
>  
>  	ctx->scratch = rdmsr(MSR_EFER);
>  	wrmsr(MSR_EFER, ctx->scratch | EFER_NX);
>  
>  	/* Clear the guest's EFER.NX, it should not affect NPT behavior. */
> -	vcpu0.vmcb->save.efer &= ~EFER_NX;
> +	vmcb->save.efer &= ~EFER_NX;
>  
>  	pte = npt_get_pte((u64) null_test);
>  
> @@ -53,13 +56,14 @@ static void npt_nx_prepare(struct svm_test_context *ctx)
>  static bool npt_nx_check(struct svm_test_context *ctx)
>  {
>  	u64 *pte = npt_get_pte((u64) null_test);
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
>  
>  	wrmsr(MSR_EFER, ctx->scratch);
>  
>  	*pte &= ~PT64_NX_MASK;
>  
> -	return (vcpu0.vmcb->control.exit_code == SVM_EXIT_NPF)
> -	    && (vcpu0.vmcb->control.exit_info_1 == 0x100000015ULL);
> +	return (vmcb->control.exit_code == SVM_EXIT_NPF)
> +	    && (vmcb->control.exit_info_1 == 0x100000015ULL);
>  }
>  
>  static void npt_us_prepare(struct svm_test_context *ctx)
> @@ -80,11 +84,12 @@ static void npt_us_test(struct svm_test_context *ctx)
>  static bool npt_us_check(struct svm_test_context *ctx)
>  {
>  	u64 *pte = npt_get_pte((u64) scratch_page);
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
>  
>  	*pte |= (1ULL << 2);
>  
> -	return (vcpu0.vmcb->control.exit_code == SVM_EXIT_NPF)
> -	    && (vcpu0.vmcb->control.exit_info_1 == 0x100000005ULL);
> +	return (vmcb->control.exit_code == SVM_EXIT_NPF)
> +	    && (vmcb->control.exit_info_1 == 0x100000005ULL);
>  }
>  
>  static void npt_rw_prepare(struct svm_test_context *ctx)
> @@ -107,11 +112,12 @@ static void npt_rw_test(struct svm_test_context *ctx)
>  static bool npt_rw_check(struct svm_test_context *ctx)
>  {
>  	u64 *pte = npt_get_pte(0x80000);
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
>  
>  	*pte |= (1ULL << 1);
>  
> -	return (vcpu0.vmcb->control.exit_code == SVM_EXIT_NPF)
> -	    && (vcpu0.vmcb->control.exit_info_1 == 0x100000007ULL);
> +	return (vmcb->control.exit_code == SVM_EXIT_NPF)
> +	    && (vmcb->control.exit_info_1 == 0x100000007ULL);
>  }
>  
>  static void npt_rw_pfwalk_prepare(struct svm_test_context *ctx)
> @@ -127,12 +133,13 @@ static void npt_rw_pfwalk_prepare(struct svm_test_context *ctx)
>  static bool npt_rw_pfwalk_check(struct svm_test_context *ctx)
>  {
>  	u64 *pte = npt_get_pte(read_cr3());
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
>  
>  	*pte |= (1ULL << 1);
>  
> -	return (vcpu0.vmcb->control.exit_code == SVM_EXIT_NPF)
> -	    && (vcpu0.vmcb->control.exit_info_1 == 0x200000007ULL)
> -	    && (vcpu0.vmcb->control.exit_info_2 == read_cr3());
> +	return (vmcb->control.exit_code == SVM_EXIT_NPF)
> +	    && (vmcb->control.exit_info_1 == 0x200000007ULL)
> +	    && (vmcb->control.exit_info_2 == read_cr3());
>  }
>  
>  static void npt_l1mmio_prepare(struct svm_test_context *ctx)
> @@ -178,11 +185,12 @@ static void npt_rw_l1mmio_test(struct svm_test_context *ctx)
>  static bool npt_rw_l1mmio_check(struct svm_test_context *ctx)
>  {
>  	u64 *pte = npt_get_pte(0xfee00080);
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
>  
>  	*pte |= (1ULL << 1);
>  
> -	return (vcpu0.vmcb->control.exit_code == SVM_EXIT_NPF)
> -	    && (vcpu0.vmcb->control.exit_info_1 == 0x100000007ULL);
> +	return (vmcb->control.exit_code == SVM_EXIT_NPF)
> +	    && (vmcb->control.exit_info_1 == 0x100000007ULL);
>  }
>  
>  static void basic_guest_main(struct svm_test_context *ctx)
> @@ -193,6 +201,7 @@ static void __svm_npt_rsvd_bits_test(struct svm_test_context *ctx,
>  				     u64 * pxe, u64 rsvd_bits, u64 efer,
>  				     ulong cr4, u64 guest_efer, ulong guest_cr4)
>  {
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
>  	u64 pxe_orig = *pxe;
>  	int exit_reason;
>  	u64 pfec;
> @@ -200,8 +209,8 @@ static void __svm_npt_rsvd_bits_test(struct svm_test_context *ctx,
>  	wrmsr(MSR_EFER, efer);
>  	write_cr4(cr4);
>  
> -	vcpu0.vmcb->save.efer = guest_efer;
> -	vcpu0.vmcb->save.cr4 = guest_cr4;
> +	vmcb->save.efer = guest_efer;
> +	vmcb->save.cr4 = guest_cr4;
>  
>  	*pxe |= rsvd_bits;
>  
> @@ -227,10 +236,10 @@ static void __svm_npt_rsvd_bits_test(struct svm_test_context *ctx,
>  
>  	}
>  
> -	report(vcpu0.vmcb->control.exit_info_1 == pfec,
> +	report(vmcb->control.exit_info_1 == pfec,
>  	       "Wanted PFEC = 0x%lx, got PFEC = %lx, PxE = 0x%lx.  "
>  	       "host.NX = %u, host.SMEP = %u, guest.NX = %u, guest.SMEP = %u",
> -	       pfec, vcpu0.vmcb->control.exit_info_1, *pxe,
> +	       pfec, vmcb->control.exit_info_1, *pxe,
>  	       !!(efer & EFER_NX), !!(cr4 & X86_CR4_SMEP),
>  	       !!(guest_efer & EFER_NX), !!(guest_cr4 & X86_CR4_SMEP));
>  
> @@ -311,6 +320,7 @@ static void svm_npt_rsvd_bits_test(struct svm_test_context *ctx)
>  {
>  	u64 saved_efer, host_efer, sg_efer, guest_efer;
>  	ulong saved_cr4, host_cr4, sg_cr4, guest_cr4;
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
>  
>  	if (!npt_supported()) {
>  		report_skip("NPT not supported");
> @@ -319,8 +329,8 @@ static void svm_npt_rsvd_bits_test(struct svm_test_context *ctx)
>  
>  	saved_efer = host_efer = rdmsr(MSR_EFER);
>  	saved_cr4 = host_cr4 = read_cr4();
> -	sg_efer = guest_efer = vcpu0.vmcb->save.efer;
> -	sg_cr4 = guest_cr4 = vcpu0.vmcb->save.cr4;
> +	sg_efer = guest_efer = vmcb->save.efer;
> +	sg_cr4 = guest_cr4 = vmcb->save.cr4;
>  
>  	test_set_guest(basic_guest_main);
>  
> @@ -352,8 +362,8 @@ skip_pte_test:
>  
>  	wrmsr(MSR_EFER, saved_efer);
>  	write_cr4(saved_cr4);
> -	vcpu0.vmcb->save.efer = sg_efer;
> -	vcpu0.vmcb->save.cr4 = sg_cr4;
> +	vmcb->save.efer = sg_efer;
> +	vmcb->save.cr4 = sg_cr4;
>  }
>  
>  #define NPT_V1_TEST(name, prepare, guest_code, check)				\
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index 6041ac24..bd92fcee 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -44,33 +44,36 @@ static void null_test(struct svm_test_context *ctx)
>  
>  static bool null_check(struct svm_test_context *ctx)
>  {
> -	return vcpu0.vmcb->control.exit_code == SVM_EXIT_VMMCALL;
> +	return ctx->vcpu->vmcb->control.exit_code == SVM_EXIT_VMMCALL;
>  }
>  
>  static void prepare_no_vmrun_int(struct svm_test_context *ctx)
>  {
> -	vcpu0.vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMRUN);
> +	ctx->vcpu->vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMRUN);
>  }
>  
>  static bool check_no_vmrun_int(struct svm_test_context *ctx)
>  {
> -	return vcpu0.vmcb->control.exit_code == SVM_EXIT_ERR;
> +	return ctx->vcpu->vmcb->control.exit_code == SVM_EXIT_ERR;
>  }
>  
>  static void test_vmrun(struct svm_test_context *ctx)
>  {
> -	asm volatile ("vmrun %0" : : "a"(virt_to_phys(vcpu0.vmcb)));
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
> +	asm volatile ("vmrun %0" : : "a"(virt_to_phys(vmcb)));
>  }
>  
>  static bool check_vmrun(struct svm_test_context *ctx)
>  {
> -	return vcpu0.vmcb->control.exit_code == SVM_EXIT_VMRUN;
> +	return ctx->vcpu->vmcb->control.exit_code == SVM_EXIT_VMRUN;
>  }
>  
>  static void prepare_rsm_intercept(struct svm_test_context *ctx)
>  {
> -	vcpu0.vmcb->control.intercept |= 1 << INTERCEPT_RSM;
> -	vcpu0.vmcb->control.intercept_exceptions |= (1ULL << UD_VECTOR);
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +	vmcb->control.intercept |= 1 << INTERCEPT_RSM;
> +	vmcb->control.intercept_exceptions |= (1ULL << UD_VECTOR);
>  }
>  
>  static void test_rsm_intercept(struct svm_test_context *ctx)
> @@ -85,24 +88,25 @@ static bool check_rsm_intercept(struct svm_test_context *ctx)
>  
>  static bool finished_rsm_intercept(struct svm_test_context *ctx)
>  {
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
>  	switch (get_test_stage(ctx)) {
>  	case 0:
> -		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_RSM) {
> +		if (vmcb->control.exit_code != SVM_EXIT_RSM) {
>  			report_fail("VMEXIT not due to rsm. Exit reason 0x%x",
> -				    vcpu0.vmcb->control.exit_code);
> +				    vmcb->control.exit_code);
>  			return true;
>  		}
> -		vcpu0.vmcb->control.intercept &= ~(1 << INTERCEPT_RSM);
> +		vmcb->control.intercept &= ~(1 << INTERCEPT_RSM);
>  		inc_test_stage(ctx);
>  		break;
>  
>  	case 1:
> -		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_EXCP_BASE + UD_VECTOR) {
> +		if (vmcb->control.exit_code != SVM_EXIT_EXCP_BASE + UD_VECTOR) {
>  			report_fail("VMEXIT not due to #UD. Exit reason 0x%x",
> -				    vcpu0.vmcb->control.exit_code);
> +				    vmcb->control.exit_code);
>  			return true;
>  		}
> -		vcpu0.vmcb->save.rip += 2;
> +		vmcb->save.rip += 2;
>  		inc_test_stage(ctx);
>  		break;
>  
> @@ -114,7 +118,9 @@ static bool finished_rsm_intercept(struct svm_test_context *ctx)
>  
>  static void prepare_cr3_intercept(struct svm_test_context *ctx)
>  {
> -	vcpu0.vmcb->control.intercept_cr_read |= 1 << 3;
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
> +	vmcb->control.intercept_cr_read |= 1 << 3;
>  }
>  
>  static void test_cr3_intercept(struct svm_test_context *ctx)
> @@ -124,7 +130,8 @@ static void test_cr3_intercept(struct svm_test_context *ctx)
>  
>  static bool check_cr3_intercept(struct svm_test_context *ctx)
>  {
> -	return vcpu0.vmcb->control.exit_code == SVM_EXIT_READ_CR3;
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +	return vmcb->control.exit_code == SVM_EXIT_READ_CR3;
>  }
>  
>  static bool check_cr3_nointercept(struct svm_test_context *ctx)
> @@ -147,7 +154,9 @@ static void corrupt_cr3_intercept_bypass(void *_ctx)
>  
>  static void prepare_cr3_intercept_bypass(struct svm_test_context *ctx)
>  {
> -	vcpu0.vmcb->control.intercept_cr_read |= 1 << 3;
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
> +	vmcb->control.intercept_cr_read |= 1 << 3;
>  	on_cpu_async(1, corrupt_cr3_intercept_bypass, ctx);
>  }
>  
> @@ -166,8 +175,10 @@ static void test_cr3_intercept_bypass(struct svm_test_context *ctx)
>  
>  static void prepare_dr_intercept(struct svm_test_context *ctx)
>  {
> -	vcpu0.vmcb->control.intercept_dr_read = 0xff;
> -	vcpu0.vmcb->control.intercept_dr_write = 0xff;
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
> +	vmcb->control.intercept_dr_read = 0xff;
> +	vmcb->control.intercept_dr_write = 0xff;
>  }
>  
>  static void test_dr_intercept(struct svm_test_context *ctx)
> @@ -251,7 +262,8 @@ static void test_dr_intercept(struct svm_test_context *ctx)
>  
>  static bool dr_intercept_finished(struct svm_test_context *ctx)
>  {
> -	ulong n = (vcpu0.vmcb->control.exit_code - SVM_EXIT_READ_DR0);
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +	ulong n = (vmcb->control.exit_code - SVM_EXIT_READ_DR0);
>  
>  	/* Only expect DR intercepts */
>  	if (n > (SVM_EXIT_MAX_DR_INTERCEPT - SVM_EXIT_READ_DR0))
> @@ -267,7 +279,7 @@ static bool dr_intercept_finished(struct svm_test_context *ctx)
>  	ctx->scratch = (n % 16);
>  
>  	/* Jump over MOV instruction */
> -	vcpu0.vmcb->save.rip += 3;
> +	vmcb->save.rip += 3;
>  
>  	return false;
>  }
> @@ -284,7 +296,8 @@ static bool next_rip_supported(void)
>  
>  static void prepare_next_rip(struct svm_test_context *ctx)
>  {
> -	vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_RDTSC);
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +	vmcb->control.intercept |= (1ULL << INTERCEPT_RDTSC);
>  }
>  
>  
> @@ -299,15 +312,17 @@ static bool check_next_rip(struct svm_test_context *ctx)
>  {
>  	extern char exp_next_rip;
>  	unsigned long address = (unsigned long)&exp_next_rip;
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
>  
> -	return address == vcpu0.vmcb->control.next_rip;
> +	return address == vmcb->control.next_rip;
>  }
>  
>  
>  static void prepare_msr_intercept(struct svm_test_context *ctx)
>  {
> -	vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_MSR_PROT);
> -	vcpu0.vmcb->control.intercept_exceptions |= (1ULL << GP_VECTOR);
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +	vmcb->control.intercept |= (1ULL << INTERCEPT_MSR_PROT);
> +	vmcb->control.intercept_exceptions |= (1ULL << GP_VECTOR);
>  	memset(svm_get_msr_bitmap(), 0xff, MSR_BITMAP_SIZE);
>  }
>  
> @@ -359,12 +374,13 @@ static void test_msr_intercept(struct svm_test_context *ctx)
>  
>  static bool msr_intercept_finished(struct svm_test_context *ctx)
>  {
> -	u32 exit_code = vcpu0.vmcb->control.exit_code;
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +	u32 exit_code = vmcb->control.exit_code;
>  	u64 exit_info_1;
>  	u8 *opcode;
>  
>  	if (exit_code == SVM_EXIT_MSR) {
> -		exit_info_1 = vcpu0.vmcb->control.exit_info_1;
> +		exit_info_1 = vmcb->control.exit_info_1;
>  	} else {
>  		/*
>  		 * If #GP exception occurs instead, check that it was
> @@ -374,7 +390,7 @@ static bool msr_intercept_finished(struct svm_test_context *ctx)
>  		if (exit_code != (SVM_EXIT_EXCP_BASE + GP_VECTOR))
>  			return true;
>  
> -		opcode = (u8 *)vcpu0.vmcb->save.rip;
> +		opcode = (u8 *)vmcb->save.rip;
>  		if (opcode[0] != 0x0f)
>  			return true;
>  
> @@ -394,11 +410,11 @@ static bool msr_intercept_finished(struct svm_test_context *ctx)
>  		 * RCX holds the MSR index.
>  		 */
>  		printf("%s 0x%lx #GP exception\n",
> -		       exit_info_1 ? "WRMSR" : "RDMSR", vcpu0.regs.rcx);
> +		       exit_info_1 ? "WRMSR" : "RDMSR", ctx->vcpu->regs.rcx);
>  	}
>  
>  	/* Jump over RDMSR/WRMSR instruction */
> -	vcpu0.vmcb->save.rip += 2;
> +	vmcb->save.rip += 2;
>  
>  	/*
>  	 * Test whether the intercept was for RDMSR/WRMSR.
> @@ -410,9 +426,9 @@ static bool msr_intercept_finished(struct svm_test_context *ctx)
>  	 */
>  	if (exit_info_1)
>  		ctx->scratch =
> -			((vcpu0.regs.rdx << 32) | (vcpu0.regs.rax & 0xffffffff));
> +			((ctx->vcpu->regs.rdx << 32) | (ctx->vcpu->regs.rax & 0xffffffff));
>  	else
> -		ctx->scratch = vcpu0.regs.rcx;
> +		ctx->scratch = ctx->vcpu->regs.rcx;
>  
>  	return false;
>  }
> @@ -425,7 +441,9 @@ static bool check_msr_intercept(struct svm_test_context *ctx)
>  
>  static void prepare_mode_switch(struct svm_test_context *ctx)
>  {
> -	vcpu0.vmcb->control.intercept_exceptions |= (1ULL << GP_VECTOR)
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
> +	vmcb->control.intercept_exceptions |= (1ULL << GP_VECTOR)
>  		|  (1ULL << UD_VECTOR)
>  		|  (1ULL << DF_VECTOR)
>  		|  (1ULL << PF_VECTOR);
> @@ -490,17 +508,18 @@ static void test_mode_switch(struct svm_test_context *ctx)
>  static bool mode_switch_finished(struct svm_test_context *ctx)
>  {
>  	u64 cr0, cr4, efer;
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
>  
> -	cr0  = vcpu0.vmcb->save.cr0;
> -	cr4  = vcpu0.vmcb->save.cr4;
> -	efer = vcpu0.vmcb->save.efer;
> +	cr0  = vmcb->save.cr0;
> +	cr4  = vmcb->save.cr4;
> +	efer = vmcb->save.efer;
>  
>  	/* Only expect VMMCALL intercepts */
> -	if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL)
> +	if (vmcb->control.exit_code != SVM_EXIT_VMMCALL)
>  		return true;
>  
>  	/* Jump over VMMCALL instruction */
> -	vcpu0.vmcb->save.rip += 3;
> +	vmcb->save.rip += 3;
>  
>  	/* Do sanity checks */
>  	switch (ctx->scratch) {
> @@ -534,8 +553,9 @@ static bool check_mode_switch(struct svm_test_context *ctx)
>  static void prepare_ioio(struct svm_test_context *ctx)
>  {
>  	u8 *io_bitmap = svm_get_io_bitmap();
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
>  
> -	vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_IOIO_PROT);
> +	vmcb->control.intercept |= (1ULL << INTERCEPT_IOIO_PROT);
>  	ctx->scratch = 0;
>  	memset(io_bitmap, 0, 8192);
>  	io_bitmap[8192] = 0xFF;
> @@ -617,19 +637,20 @@ static bool ioio_finished(struct svm_test_context *ctx)
>  {
>  	unsigned port, size;
>  	u8 *io_bitmap = svm_get_io_bitmap();
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
>  
>  	/* Only expect IOIO intercepts */
> -	if (vcpu0.vmcb->control.exit_code == SVM_EXIT_VMMCALL)
> +	if (vmcb->control.exit_code == SVM_EXIT_VMMCALL)
>  		return true;
>  
> -	if (vcpu0.vmcb->control.exit_code != SVM_EXIT_IOIO)
> +	if (vmcb->control.exit_code != SVM_EXIT_IOIO)
>  		return true;
>  
>  	/* one step forward */
>  	ctx->scratch += 1;
>  
> -	port = vcpu0.vmcb->control.exit_info_1 >> 16;
> -	size = (vcpu0.vmcb->control.exit_info_1 >> SVM_IOIO_SIZE_SHIFT) & 7;
> +	port = vmcb->control.exit_info_1 >> 16;
> +	size = (vmcb->control.exit_info_1 >> SVM_IOIO_SIZE_SHIFT) & 7;
>  
>  	while (size--) {
>  		io_bitmap[port / 8] &= ~(1 << (port & 7));
> @@ -649,7 +670,9 @@ static bool check_ioio(struct svm_test_context *ctx)
>  
>  static void prepare_asid_zero(struct svm_test_context *ctx)
>  {
> -	vcpu0.vmcb->control.asid = 0;
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
> +	vmcb->control.asid = 0;
>  }
>  
>  static void test_asid_zero(struct svm_test_context *ctx)
> @@ -659,12 +682,16 @@ static void test_asid_zero(struct svm_test_context *ctx)
>  
>  static bool check_asid_zero(struct svm_test_context *ctx)
>  {
> -	return vcpu0.vmcb->control.exit_code == SVM_EXIT_ERR;
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
> +	return vmcb->control.exit_code == SVM_EXIT_ERR;
>  }
>  
>  static void sel_cr0_bug_prepare(struct svm_test_context *ctx)
>  {
> -	vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_SELECTIVE_CR0);
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
> +	vmcb->control.intercept |= (1ULL << INTERCEPT_SELECTIVE_CR0);
>  }
>  
>  static bool sel_cr0_bug_finished(struct svm_test_context *ctx)
> @@ -692,7 +719,9 @@ static void sel_cr0_bug_test(struct svm_test_context *ctx)
>  
>  static bool sel_cr0_bug_check(struct svm_test_context *ctx)
>  {
> -	return vcpu0.vmcb->control.exit_code == SVM_EXIT_CR0_SEL_WRITE;
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
> +	return vmcb->control.exit_code == SVM_EXIT_CR0_SEL_WRITE;
>  }
>  
>  #define TSC_ADJUST_VALUE    (1ll << 32)
> @@ -706,7 +735,9 @@ static bool tsc_adjust_supported(void)
>  
>  static void tsc_adjust_prepare(struct svm_test_context *ctx)
>  {
> -	vcpu0.vmcb->control.tsc_offset = TSC_OFFSET_VALUE;
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
> +	vmcb->control.tsc_offset = TSC_OFFSET_VALUE;
>  
>  	wrmsr(MSR_IA32_TSC_ADJUST, -TSC_ADJUST_VALUE);
>  	int64_t adjust = rdmsr(MSR_IA32_TSC_ADJUST);
> @@ -758,17 +789,18 @@ static void svm_tsc_scale_run_testcase(struct svm_test_context *ctx,
>  				       double tsc_scale, u64 tsc_offset)
>  {
>  	u64 start_tsc, actual_duration;
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
>  
>  	guest_tsc_delay_value = (duration << TSC_SHIFT) * tsc_scale;
>  
>  	test_set_guest(svm_tsc_scale_guest);
> -	vcpu0.vmcb->control.tsc_offset = tsc_offset;
> +	vmcb->control.tsc_offset = tsc_offset;
>  	wrmsr(MSR_AMD64_TSC_RATIO, (u64)(tsc_scale * (1ULL << 32)));
>  
>  	start_tsc = rdtsc();
>  
>  	if (svm_vmrun(ctx) != SVM_EXIT_VMMCALL)
> -		report_fail("unexpected vm exit code 0x%x", vcpu0.vmcb->control.exit_code);
> +		report_fail("unexpected vm exit code 0x%x", vmcb->control.exit_code);
>  
>  	actual_duration = (rdtsc() - start_tsc) >> TSC_SHIFT;
>  
> @@ -839,6 +871,7 @@ start:
>  static bool latency_finished(struct svm_test_context *ctx)
>  {
>  	u64 cycles;
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
>  
>  	tsc_end = rdtsc();
>  
> @@ -852,7 +885,7 @@ static bool latency_finished(struct svm_test_context *ctx)
>  
>  	vmexit_sum += cycles;
>  
> -	vcpu0.vmcb->save.rip += 3;
> +	vmcb->save.rip += 3;
>  
>  	runs -= 1;
>  
> @@ -863,7 +896,10 @@ static bool latency_finished(struct svm_test_context *ctx)
>  
>  static bool latency_finished_clean(struct svm_test_context *ctx)
>  {
> -	vcpu0.vmcb->control.clean = VMCB_CLEAN_ALL;
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
> +	vmcb->control.clean = VMCB_CLEAN_ALL;
> +
>  	return latency_finished(ctx);
>  }
>  
> @@ -886,7 +922,9 @@ static void lat_svm_insn_prepare(struct svm_test_context *ctx)
>  
>  static bool lat_svm_insn_finished(struct svm_test_context *ctx)
>  {
> -	u64 vmcb_phys = virt_to_phys(vcpu0.vmcb);
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
> +	u64 vmcb_phys = virt_to_phys(vmcb);
>  	u64 cycles;
>  
>  	for ( ; runs != 0; runs--) {
> @@ -957,6 +995,7 @@ static void pending_event_ipi_isr(isr_regs_t *regs)
>  static void pending_event_prepare(struct svm_test_context *ctx)
>  {
>  	int ipi_vector = 0xf1;
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
>  
>  	pending_event_ipi_fired = false;
>  
> @@ -964,8 +1003,8 @@ static void pending_event_prepare(struct svm_test_context *ctx)
>  
>  	pending_event_guest_run = false;
>  
> -	vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_INTR);
> -	vcpu0.vmcb->control.int_ctl |= V_INTR_MASKING_MASK;
> +	vmcb->control.intercept |= (1ULL << INTERCEPT_INTR);
> +	vmcb->control.int_ctl |= V_INTR_MASKING_MASK;
>  
>  	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL |
>  		       APIC_DM_FIXED | ipi_vector, 0);
> @@ -980,16 +1019,18 @@ static void pending_event_test(struct svm_test_context *ctx)
>  
>  static bool pending_event_finished(struct svm_test_context *ctx)
>  {
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
>  	switch (get_test_stage(ctx)) {
>  	case 0:
> -		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_INTR) {
> +		if (vmcb->control.exit_code != SVM_EXIT_INTR) {
>  			report_fail("VMEXIT not due to pending interrupt. Exit reason 0x%x",
> -				    vcpu0.vmcb->control.exit_code);
> +				    vmcb->control.exit_code);
>  			return true;
>  		}
>  
> -		vcpu0.vmcb->control.intercept &= ~(1ULL << INTERCEPT_INTR);
> -		vcpu0.vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
> +		vmcb->control.intercept &= ~(1ULL << INTERCEPT_INTR);
> +		vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
>  
>  		if (pending_event_guest_run) {
>  			report_fail("Guest ran before host received IPI\n");
> @@ -1067,19 +1108,21 @@ static void pending_event_cli_test(struct svm_test_context *ctx)
>  
>  static bool pending_event_cli_finished(struct svm_test_context *ctx)
>  {
> -	if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
> +	if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
>  		report_fail("VM_EXIT return to host is not EXIT_VMMCALL exit reason 0x%x",
> -			    vcpu0.vmcb->control.exit_code);
> +			    vmcb->control.exit_code);
>  		return true;
>  	}
>  
>  	switch (get_test_stage(ctx)) {
>  	case 0:
> -		vcpu0.vmcb->save.rip += 3;
> +		vmcb->save.rip += 3;
>  
>  		pending_event_ipi_fired = false;
>  
> -		vcpu0.vmcb->control.int_ctl |= V_INTR_MASKING_MASK;
> +		vmcb->control.int_ctl |= V_INTR_MASKING_MASK;
>  
>  		/* Now entering again with VINTR_MASKING=1.  */
>  		apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL |
> @@ -1206,32 +1249,34 @@ static void interrupt_test(struct svm_test_context *ctx)
>  
>  static bool interrupt_finished(struct svm_test_context *ctx)
>  {
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
>  	switch (get_test_stage(ctx)) {
>  	case 0:
>  	case 2:
> -		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
> +		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
>  			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
> -				    vcpu0.vmcb->control.exit_code);
> +				    vmcb->control.exit_code);
>  			return true;
>  		}
> -		vcpu0.vmcb->save.rip += 3;
> +		vmcb->save.rip += 3;
>  
> -		vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_INTR);
> -		vcpu0.vmcb->control.int_ctl |= V_INTR_MASKING_MASK;
> +		vmcb->control.intercept |= (1ULL << INTERCEPT_INTR);
> +		vmcb->control.int_ctl |= V_INTR_MASKING_MASK;
>  		break;
>  
>  	case 1:
>  	case 3:
> -		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_INTR) {
> +		if (vmcb->control.exit_code != SVM_EXIT_INTR) {
>  			report_fail("VMEXIT not due to intr intercept. Exit reason 0x%x",
> -				    vcpu0.vmcb->control.exit_code);
> +				    vmcb->control.exit_code);
>  			return true;
>  		}
>  
>  		sti_nop_cli();
>  
> -		vcpu0.vmcb->control.intercept &= ~(1ULL << INTERCEPT_INTR);
> -		vcpu0.vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
> +		vmcb->control.intercept &= ~(1ULL << INTERCEPT_INTR);
> +		vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
>  		break;
>  
>  	case 4:
> @@ -1289,22 +1334,24 @@ static void nmi_test(struct svm_test_context *ctx)
>  
>  static bool nmi_finished(struct svm_test_context *ctx)
>  {
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
>  	switch (get_test_stage(ctx)) {
>  	case 0:
> -		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
> +		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
>  			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
> -				    vcpu0.vmcb->control.exit_code);
> +				    vmcb->control.exit_code);
>  			return true;
>  		}
> -		vcpu0.vmcb->save.rip += 3;
> +		vmcb->save.rip += 3;
>  
> -		vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_NMI);
> +		vmcb->control.intercept |= (1ULL << INTERCEPT_NMI);
>  		break;
>  
>  	case 1:
> -		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_NMI) {
> +		if (vmcb->control.exit_code != SVM_EXIT_NMI) {
>  			report_fail("VMEXIT not due to NMI intercept. Exit reason 0x%x",
> -				    vcpu0.vmcb->control.exit_code);
> +				    vmcb->control.exit_code);
>  			return true;
>  		}
>  
> @@ -1391,22 +1438,24 @@ static void nmi_hlt_test(struct svm_test_context *ctx)
>  
>  static bool nmi_hlt_finished(struct svm_test_context *ctx)
>  {
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
>  	switch (get_test_stage(ctx)) {
>  	case 1:
> -		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
> +		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
>  			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
> -				    vcpu0.vmcb->control.exit_code);
> +				    vmcb->control.exit_code);
>  			return true;
>  		}
> -		vcpu0.vmcb->save.rip += 3;
> +		vmcb->save.rip += 3;
>  
> -		vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_NMI);
> +		vmcb->control.intercept |= (1ULL << INTERCEPT_NMI);
>  		break;
>  
>  	case 2:
> -		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_NMI) {
> +		if (vmcb->control.exit_code != SVM_EXIT_NMI) {
>  			report_fail("VMEXIT not due to NMI intercept. Exit reason 0x%x",
> -				    vcpu0.vmcb->control.exit_code);
> +				    vmcb->control.exit_code);
>  			return true;
>  		}
>  
> @@ -1449,40 +1498,42 @@ static void exc_inject_test(struct svm_test_context *ctx)
>  
>  static bool exc_inject_finished(struct svm_test_context *ctx)
>  {
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
>  	switch (get_test_stage(ctx)) {
>  	case 0:
> -		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
> +		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
>  			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
> -				    vcpu0.vmcb->control.exit_code);
> +				    vmcb->control.exit_code);
>  			return true;
>  		}
> -		vcpu0.vmcb->save.rip += 3;
> -		vcpu0.vmcb->control.event_inj = NMI_VECTOR |
> +		vmcb->save.rip += 3;
> +		vmcb->control.event_inj = NMI_VECTOR |
>  						SVM_EVTINJ_TYPE_EXEPT |
>  						SVM_EVTINJ_VALID;
>  		break;
>  
>  	case 1:
> -		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_ERR) {
> +		if (vmcb->control.exit_code != SVM_EXIT_ERR) {
>  			report_fail("VMEXIT not due to error. Exit reason 0x%x",
> -				    vcpu0.vmcb->control.exit_code);
> +				    vmcb->control.exit_code);
>  			return true;
>  		}
>  		report(count_exc == 0, "exception with vector 2 not injected");
> -		vcpu0.vmcb->control.event_inj = DE_VECTOR |
> +		vmcb->control.event_inj = DE_VECTOR |
>  						SVM_EVTINJ_TYPE_EXEPT |
>  						SVM_EVTINJ_VALID;
>  		break;
>  
>  	case 2:
> -		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
> +		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
>  			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
> -				    vcpu0.vmcb->control.exit_code);
> +				    vmcb->control.exit_code);
>  			return true;
>  		}
> -		vcpu0.vmcb->save.rip += 3;
> +		vmcb->save.rip += 3;
>  		report(count_exc == 1, "divide overflow exception injected");
> -		report(!(vcpu0.vmcb->control.event_inj & SVM_EVTINJ_VALID),
> +		report(!(vmcb->control.event_inj & SVM_EVTINJ_VALID),
>  		       "eventinj.VALID cleared");
>  		break;
>  
> @@ -1509,11 +1560,13 @@ static void virq_isr(isr_regs_t *regs)
>  
>  static void virq_inject_prepare(struct svm_test_context *ctx)
>  {
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
>  	handle_irq(0xf1, virq_isr);
>  
> -	vcpu0.vmcb->control.int_ctl = V_INTR_MASKING_MASK | V_IRQ_MASK |
> +	vmcb->control.int_ctl = V_INTR_MASKING_MASK | V_IRQ_MASK |
>  		(0x0f << V_INTR_PRIO_SHIFT); // Set to the highest priority
> -	vcpu0.vmcb->control.int_vector = 0xf1;
> +	vmcb->control.int_vector = 0xf1;
>  	virq_fired = false;
>  	set_test_stage(ctx, 0);
>  }
> @@ -1563,66 +1616,68 @@ static void virq_inject_test(struct svm_test_context *ctx)
>  
>  static bool virq_inject_finished(struct svm_test_context *ctx)
>  {
> -	vcpu0.vmcb->save.rip += 3;
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
> +	vmcb->save.rip += 3;
>  
>  	switch (get_test_stage(ctx)) {
>  	case 0:
> -		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
> +		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
>  			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
> -				    vcpu0.vmcb->control.exit_code);
> +				    vmcb->control.exit_code);
>  			return true;
>  		}
> -		if (vcpu0.vmcb->control.int_ctl & V_IRQ_MASK) {
> +		if (vmcb->control.int_ctl & V_IRQ_MASK) {
>  			report_fail("V_IRQ not cleared on VMEXIT after firing");
>  			return true;
>  		}
>  		virq_fired = false;
> -		vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_VINTR);
> -		vcpu0.vmcb->control.int_ctl = V_INTR_MASKING_MASK | V_IRQ_MASK |
> +		vmcb->control.intercept |= (1ULL << INTERCEPT_VINTR);
> +		vmcb->control.int_ctl = V_INTR_MASKING_MASK | V_IRQ_MASK |
>  			(0x0f << V_INTR_PRIO_SHIFT);
>  		break;
>  
>  	case 1:
> -		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VINTR) {
> +		if (vmcb->control.exit_code != SVM_EXIT_VINTR) {
>  			report_fail("VMEXIT not due to vintr. Exit reason 0x%x",
> -				    vcpu0.vmcb->control.exit_code);
> +				    vmcb->control.exit_code);
>  			return true;
>  		}
>  		if (virq_fired) {
>  			report_fail("V_IRQ fired before SVM_EXIT_VINTR");
>  			return true;
>  		}
> -		vcpu0.vmcb->control.intercept &= ~(1ULL << INTERCEPT_VINTR);
> +		vmcb->control.intercept &= ~(1ULL << INTERCEPT_VINTR);
>  		break;
>  
>  	case 2:
> -		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
> +		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
>  			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
> -				    vcpu0.vmcb->control.exit_code);
> +				    vmcb->control.exit_code);
>  			return true;
>  		}
>  		virq_fired = false;
>  		// Set irq to lower priority
> -		vcpu0.vmcb->control.int_ctl = V_INTR_MASKING_MASK | V_IRQ_MASK |
> +		vmcb->control.int_ctl = V_INTR_MASKING_MASK | V_IRQ_MASK |
>  			(0x08 << V_INTR_PRIO_SHIFT);
>  		// Raise guest TPR
> -		vcpu0.vmcb->control.int_ctl |= 0x0a & V_TPR_MASK;
> +		vmcb->control.int_ctl |= 0x0a & V_TPR_MASK;
>  		break;
>  
>  	case 3:
> -		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
> +		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
>  			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
> -				    vcpu0.vmcb->control.exit_code);
> +				    vmcb->control.exit_code);
>  			return true;
>  		}
> -		vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_VINTR);
> +		vmcb->control.intercept |= (1ULL << INTERCEPT_VINTR);
>  		break;
>  
>  	case 4:
>  		// INTERCEPT_VINTR should be ignored because V_INTR_PRIO < V_TPR
> -		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
> +		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
>  			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
> -				    vcpu0.vmcb->control.exit_code);
> +				    vmcb->control.exit_code);
>  			return true;
>  		}
>  		break;
> @@ -1673,10 +1728,12 @@ static void reg_corruption_isr(isr_regs_t *regs)
>  
>  static void reg_corruption_prepare(struct svm_test_context *ctx)
>  {
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
>  	set_test_stage(ctx, 0);
>  
> -	vcpu0.vmcb->control.int_ctl = V_INTR_MASKING_MASK;
> -	vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_INTR);
> +	vmcb->control.int_ctl = V_INTR_MASKING_MASK;
> +	vmcb->control.intercept |= (1ULL << INTERCEPT_INTR);
>  
>  	handle_irq(TIMER_VECTOR, reg_corruption_isr);
>  
> @@ -1705,6 +1762,8 @@ static void reg_corruption_test(struct svm_test_context *ctx)
>  
>  static bool reg_corruption_finished(struct svm_test_context *ctx)
>  {
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
>  	if (isr_cnt == 10000) {
>  		report_pass("No RIP corruption detected after %d timer interrupts",
>  			    isr_cnt);
> @@ -1712,9 +1771,9 @@ static bool reg_corruption_finished(struct svm_test_context *ctx)
>  		goto cleanup;
>  	}
>  
> -	if (vcpu0.vmcb->control.exit_code == SVM_EXIT_INTR) {
> +	if (vmcb->control.exit_code == SVM_EXIT_INTR) {
>  
> -		void *guest_rip = (void *)vcpu0.vmcb->save.rip;
> +		void *guest_rip = (void *)vmcb->save.rip;
>  
>  		sti_nop_cli();
>  
> @@ -1782,8 +1841,10 @@ static volatile bool init_intercept;
>  
>  static void init_intercept_prepare(struct svm_test_context *ctx)
>  {
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
>  	init_intercept = false;
> -	vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_INIT);
> +	vmcb->control.intercept |= (1ULL << INTERCEPT_INIT);
>  }
>  
>  static void init_intercept_test(struct svm_test_context *ctx)
> @@ -1793,11 +1854,13 @@ static void init_intercept_test(struct svm_test_context *ctx)
>  
>  static bool init_intercept_finished(struct svm_test_context *ctx)
>  {
> -	vcpu0.vmcb->save.rip += 3;
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
> +	vmcb->save.rip += 3;
>  
> -	if (vcpu0.vmcb->control.exit_code != SVM_EXIT_INIT) {
> +	if (vmcb->control.exit_code != SVM_EXIT_INIT) {
>  		report_fail("VMEXIT not due to init intercept. Exit reason 0x%x",
> -			    vcpu0.vmcb->control.exit_code);
> +			    vmcb->control.exit_code);
>  
>  		return true;
>  	}
> @@ -1894,14 +1957,16 @@ static void host_rflags_test(struct svm_test_context *ctx)
>  
>  static bool host_rflags_finished(struct svm_test_context *ctx)
>  {
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
>  	switch (get_test_stage(ctx)) {
>  	case 0:
> -		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
> +		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
>  			report_fail("Unexpected VMEXIT. Exit reason 0x%x",
> -				    vcpu0.vmcb->control.exit_code);
> +				    vmcb->control.exit_code);
>  			return true;
>  		}
> -		vcpu0.vmcb->save.rip += 3;
> +		vmcb->save.rip += 3;
>  		/*
>  		 * Setting host EFLAGS.TF not immediately before VMRUN, causes
>  		 * #DB trap before first guest instruction is executed
> @@ -1909,14 +1974,14 @@ static bool host_rflags_finished(struct svm_test_context *ctx)
>  		host_rflags_set_tf = true;
>  		break;
>  	case 1:
> -		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL ||
> +		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL ||
>  		    host_rflags_guest_main_flag != 1) {
>  			report_fail("Unexpected VMEXIT or #DB handler"
>  				    " invoked before guest main. Exit reason 0x%x",
> -				    vcpu0.vmcb->control.exit_code);
> +				    vmcb->control.exit_code);
>  			return true;
>  		}
> -		vcpu0.vmcb->save.rip += 3;
> +		vmcb->save.rip += 3;
>  		/*
>  		 * Setting host EFLAGS.TF immediately before VMRUN, causes #DB
>  		 * trap after VMRUN completes on the host side (i.e., after
> @@ -1925,21 +1990,21 @@ static bool host_rflags_finished(struct svm_test_context *ctx)
>  		host_rflags_ss_on_vmrun = true;
>  		break;
>  	case 2:
> -		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL ||
> +		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL ||
>  		    rip_detected != (u64)&vmrun_rip + 3) {
>  			report_fail("Unexpected VMEXIT or RIP mismatch."
>  				    " Exit reason 0x%x, RIP actual: %lx, RIP expected: "
> -				    "%lx", vcpu0.vmcb->control.exit_code,
> +				    "%lx", vmcb->control.exit_code,
>  				    (u64)&vmrun_rip + 3, rip_detected);
>  			return true;
>  		}
>  		host_rflags_set_rf = true;
>  		host_rflags_guest_main_flag = 0;
>  		host_rflags_vmrun_reached = false;
> -		vcpu0.vmcb->save.rip += 3;
> +		vmcb->save.rip += 3;
>  		break;
>  	case 3:
> -		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL ||
> +		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL ||
>  		    rip_detected != (u64)&vmrun_rip ||
>  		    host_rflags_guest_main_flag != 1 ||
>  		    host_rflags_db_handler_flag > 1 ||
> @@ -1947,13 +2012,13 @@ static bool host_rflags_finished(struct svm_test_context *ctx)
>  			report_fail("Unexpected VMEXIT or RIP mismatch or "
>  				    "EFLAGS.RF not cleared."
>  				    " Exit reason 0x%x, RIP actual: %lx, RIP expected: "
> -				    "%lx", vcpu0.vmcb->control.exit_code,
> +				    "%lx", vmcb->control.exit_code,
>  				    (u64)&vmrun_rip, rip_detected);
>  			return true;
>  		}
>  		host_rflags_set_tf = false;
>  		host_rflags_set_rf = false;
> -		vcpu0.vmcb->save.rip += 3;
> +		vmcb->save.rip += 3;
>  		break;
>  	default:
>  		return true;
> @@ -1986,6 +2051,8 @@ static void svm_cr4_osxsave_test_guest(struct svm_test_context *ctx)
>  
>  static void svm_cr4_osxsave_test(struct svm_test_context *ctx)
>  {
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
>  	if (!this_cpu_has(X86_FEATURE_XSAVE)) {
>  		report_skip("XSAVE not detected");
>  		return;
> @@ -1995,7 +2062,7 @@ static void svm_cr4_osxsave_test(struct svm_test_context *ctx)
>  		unsigned long cr4 = read_cr4() | X86_CR4_OSXSAVE;
>  
>  		write_cr4(cr4);
> -		vcpu0.vmcb->save.cr4 = cr4;
> +		vmcb->save.cr4 = cr4;
>  	}
>  
>  	report(this_cpu_has(X86_FEATURE_OSXSAVE), "CPUID.01H:ECX.XSAVE set before VMRUN");
> @@ -2035,6 +2102,7 @@ static void basic_guest_main(struct svm_test_context *ctx)
>  	u64 tmp, mask;							\
>  	u32 r;								\
>  	int i;								\
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;				\
>  									\
>  	for (i = start; i <= end; i = i + inc) {			\
>  		mask = 1ull << i;					\
> @@ -2043,13 +2111,13 @@ static void basic_guest_main(struct svm_test_context *ctx)
>  		tmp = val | mask;					\
>  		switch (cr) {						\
>  		case 0:							\
> -			vcpu0.vmcb->save.cr0 = tmp;				\
> +			vmcb->save.cr0 = tmp;				\
>  			break;						\
>  		case 3:							\
> -			vcpu0.vmcb->save.cr3 = tmp;				\
> +			vmcb->save.cr3 = tmp;				\
>  			break;						\
>  		case 4:							\
> -			vcpu0.vmcb->save.cr4 = tmp;				\
> +			vmcb->save.cr4 = tmp;				\
>  		}							\
>  		r = svm_vmrun(ctx);					\
>  		report(r == exit_code, "Test CR%d %s%d:%d: %lx, wanted exit 0x%x, got 0x%x", \
> @@ -2062,39 +2130,40 @@ static void test_efer(struct svm_test_context *ctx)
>  	/*
>  	 * Un-setting EFER.SVME is illegal
>  	 */
> -	u64 efer_saved = vcpu0.vmcb->save.efer;
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +	u64 efer_saved = vmcb->save.efer;
>  	u64 efer = efer_saved;
>  
>  	report (svm_vmrun(ctx) == SVM_EXIT_VMMCALL, "EFER.SVME: %lx", efer);
>  	efer &= ~EFER_SVME;
> -	vcpu0.vmcb->save.efer = efer;
> +	vmcb->save.efer = efer;
>  	report (svm_vmrun(ctx) == SVM_EXIT_ERR, "EFER.SVME: %lx", efer);
> -	vcpu0.vmcb->save.efer = efer_saved;
> +	vmcb->save.efer = efer_saved;
>  
>  	/*
>  	 * EFER MBZ bits: 63:16, 9
>  	 */
> -	efer_saved = vcpu0.vmcb->save.efer;
> +	efer_saved = vmcb->save.efer;
>  
> -	SVM_TEST_REG_RESERVED_BITS(ctx, 8, 9, 1, "EFER", vcpu0.vmcb->save.efer,
> +	SVM_TEST_REG_RESERVED_BITS(ctx, 8, 9, 1, "EFER", vmcb->save.efer,
>  				   efer_saved, SVM_EFER_RESERVED_MASK);
> -	SVM_TEST_REG_RESERVED_BITS(ctx, 16, 63, 4, "EFER", vcpu0.vmcb->save.efer,
> +	SVM_TEST_REG_RESERVED_BITS(ctx, 16, 63, 4, "EFER", vmcb->save.efer,
>  				   efer_saved, SVM_EFER_RESERVED_MASK);
>  
>  	/*
>  	 * EFER.LME and CR0.PG are both set and CR4.PAE is zero.
>  	 */
> -	u64 cr0_saved = vcpu0.vmcb->save.cr0;
> +	u64 cr0_saved = vmcb->save.cr0;
>  	u64 cr0;
> -	u64 cr4_saved = vcpu0.vmcb->save.cr4;
> +	u64 cr4_saved = vmcb->save.cr4;
>  	u64 cr4;
>  
>  	efer = efer_saved | EFER_LME;
> -	vcpu0.vmcb->save.efer = efer;
> +	vmcb->save.efer = efer;
>  	cr0 = cr0_saved | X86_CR0_PG | X86_CR0_PE;
> -	vcpu0.vmcb->save.cr0 = cr0;
> +	vmcb->save.cr0 = cr0;
>  	cr4 = cr4_saved & ~X86_CR4_PAE;
> -	vcpu0.vmcb->save.cr4 = cr4;
> +	vmcb->save.cr4 = cr4;
>  	report(svm_vmrun(ctx) == SVM_EXIT_ERR, "EFER.LME=1 (%lx), "
>  	       "CR0.PG=1 (%lx) and CR4.PAE=0 (%lx)", efer, cr0, cr4);
>  
> @@ -2105,31 +2174,31 @@ static void test_efer(struct svm_test_context *ctx)
>  	 * SVM_EXIT_ERR.
>  	 */
>  	cr4 = cr4_saved | X86_CR4_PAE;
> -	vcpu0.vmcb->save.cr4 = cr4;
> +	vmcb->save.cr4 = cr4;
>  	cr0 &= ~X86_CR0_PE;
> -	vcpu0.vmcb->save.cr0 = cr0;
> +	vmcb->save.cr0 = cr0;
>  	report(svm_vmrun(ctx) == SVM_EXIT_ERR, "EFER.LME=1 (%lx), "
>  	       "CR0.PG=1 and CR0.PE=0 (%lx)", efer, cr0);
>  
>  	/*
>  	 * EFER.LME, CR0.PG, CR4.PAE, CS.L, and CS.D are all non-zero.
>  	 */
> -	u32 cs_attrib_saved = vcpu0.vmcb->save.cs.attrib;
> +	u32 cs_attrib_saved = vmcb->save.cs.attrib;
>  	u32 cs_attrib;
>  
>  	cr0 |= X86_CR0_PE;
> -	vcpu0.vmcb->save.cr0 = cr0;
> +	vmcb->save.cr0 = cr0;
>  	cs_attrib = cs_attrib_saved | SVM_SELECTOR_L_MASK |
>  		SVM_SELECTOR_DB_MASK;
> -	vcpu0.vmcb->save.cs.attrib = cs_attrib;
> +	vmcb->save.cs.attrib = cs_attrib;
>  	report(svm_vmrun(ctx) == SVM_EXIT_ERR, "EFER.LME=1 (%lx), "
>  	       "CR0.PG=1 (%lx), CR4.PAE=1 (%lx), CS.L=1 and CS.D=1 (%x)",
>  	       efer, cr0, cr4, cs_attrib);
>  
> -	vcpu0.vmcb->save.cr0 = cr0_saved;
> -	vcpu0.vmcb->save.cr4 = cr4_saved;
> -	vcpu0.vmcb->save.efer = efer_saved;
> -	vcpu0.vmcb->save.cs.attrib = cs_attrib_saved;
> +	vmcb->save.cr0 = cr0_saved;
> +	vmcb->save.cr4 = cr4_saved;
> +	vmcb->save.efer = efer_saved;
> +	vmcb->save.cs.attrib = cs_attrib_saved;
>  }
>  
>  static void test_cr0(struct svm_test_context *ctx)
> @@ -2137,37 +2206,39 @@ static void test_cr0(struct svm_test_context *ctx)
>  	/*
>  	 * Un-setting CR0.CD and setting CR0.NW is illegal combination
>  	 */
> -	u64 cr0_saved = vcpu0.vmcb->save.cr0;
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
> +	u64 cr0_saved = vmcb->save.cr0;
>  	u64 cr0 = cr0_saved;
>  
>  	cr0 |= X86_CR0_CD;
>  	cr0 &= ~X86_CR0_NW;
> -	vcpu0.vmcb->save.cr0 = cr0;
> +	vmcb->save.cr0 = cr0;
>  	report (svm_vmrun(ctx) == SVM_EXIT_VMMCALL, "Test CR0 CD=1,NW=0: %lx",
>  		cr0);
>  	cr0 |= X86_CR0_NW;
> -	vcpu0.vmcb->save.cr0 = cr0;
> +	vmcb->save.cr0 = cr0;
>  	report (svm_vmrun(ctx) == SVM_EXIT_VMMCALL, "Test CR0 CD=1,NW=1: %lx",
>  		cr0);
>  	cr0 &= ~X86_CR0_NW;
>  	cr0 &= ~X86_CR0_CD;
> -	vcpu0.vmcb->save.cr0 = cr0;
> +	vmcb->save.cr0 = cr0;
>  	report (svm_vmrun(ctx) == SVM_EXIT_VMMCALL, "Test CR0 CD=0,NW=0: %lx",
>  		cr0);
>  	cr0 |= X86_CR0_NW;
> -	vcpu0.vmcb->save.cr0 = cr0;
> +	vmcb->save.cr0 = cr0;
>  	report (svm_vmrun(ctx) == SVM_EXIT_ERR, "Test CR0 CD=0,NW=1: %lx",
>  		cr0);
> -	vcpu0.vmcb->save.cr0 = cr0_saved;
> +	vmcb->save.cr0 = cr0_saved;
>  
>  	/*
>  	 * CR0[63:32] are not zero
>  	 */
>  	cr0 = cr0_saved;
>  
> -	SVM_TEST_REG_RESERVED_BITS(ctx, 32, 63, 4, "CR0", vcpu0.vmcb->save.cr0, cr0_saved,
> +	SVM_TEST_REG_RESERVED_BITS(ctx, 32, 63, 4, "CR0", vmcb->save.cr0, cr0_saved,
>  				   SVM_CR0_RESERVED_MASK);
> -	vcpu0.vmcb->save.cr0 = cr0_saved;
> +	vmcb->save.cr0 = cr0_saved;
>  }
>  
>  static void test_cr3(struct svm_test_context *ctx)
> @@ -2176,37 +2247,39 @@ static void test_cr3(struct svm_test_context *ctx)
>  	 * CR3 MBZ bits based on different modes:
>  	 *   [63:52] - long mode
>  	 */
> -	u64 cr3_saved = vcpu0.vmcb->save.cr3;
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
> +	u64 cr3_saved = vmcb->save.cr3;
>  
>  	SVM_TEST_CR_RESERVED_BITS(ctx, 0, 63, 1, 3, cr3_saved,
>  				  SVM_CR3_LONG_MBZ_MASK, SVM_EXIT_ERR, "");
>  
> -	vcpu0.vmcb->save.cr3 = cr3_saved & ~SVM_CR3_LONG_MBZ_MASK;
> +	vmcb->save.cr3 = cr3_saved & ~SVM_CR3_LONG_MBZ_MASK;
>  	report(svm_vmrun(ctx) == SVM_EXIT_VMMCALL, "Test CR3 63:0: %lx",
> -	       vcpu0.vmcb->save.cr3);
> +	       vmcb->save.cr3);
>  
>  	/*
>  	 * CR3 non-MBZ reserved bits based on different modes:
>  	 *   [11:5] [2:0] - long mode (PCIDE=0)
>  	 *          [2:0] - PAE legacy mode
>  	 */
> -	u64 cr4_saved = vcpu0.vmcb->save.cr4;
> +	u64 cr4_saved = vmcb->save.cr4;
>  	u64 *pdpe = npt_get_pml4e();
>  
>  	/*
>  	 * Long mode
>  	 */
>  	if (this_cpu_has(X86_FEATURE_PCID)) {
> -		vcpu0.vmcb->save.cr4 = cr4_saved | X86_CR4_PCIDE;
> +		vmcb->save.cr4 = cr4_saved | X86_CR4_PCIDE;
>  		SVM_TEST_CR_RESERVED_BITS(ctx, 0, 11, 1, 3, cr3_saved,
>  					  SVM_CR3_LONG_RESERVED_MASK, SVM_EXIT_VMMCALL, "(PCIDE=1) ");
>  
> -		vcpu0.vmcb->save.cr3 = cr3_saved & ~SVM_CR3_LONG_RESERVED_MASK;
> +		vmcb->save.cr3 = cr3_saved & ~SVM_CR3_LONG_RESERVED_MASK;
>  		report(svm_vmrun(ctx) == SVM_EXIT_VMMCALL, "Test CR3 63:0: %lx",
> -		       vcpu0.vmcb->save.cr3);
> +		       vmcb->save.cr3);
>  	}
>  
> -	vcpu0.vmcb->save.cr4 = cr4_saved & ~X86_CR4_PCIDE;
> +	vmcb->save.cr4 = cr4_saved & ~X86_CR4_PCIDE;
>  
>  	if (!npt_supported())
>  		goto skip_npt_only;
> @@ -2218,44 +2291,46 @@ static void test_cr3(struct svm_test_context *ctx)
>  				  SVM_CR3_LONG_RESERVED_MASK, SVM_EXIT_NPF, "(PCIDE=0) ");
>  
>  	pdpe[0] |= 1ULL;
> -	vcpu0.vmcb->save.cr3 = cr3_saved;
> +	vmcb->save.cr3 = cr3_saved;
>  
>  	/*
>  	 * PAE legacy
>  	 */
>  	pdpe[0] &= ~1ULL;
> -	vcpu0.vmcb->save.cr4 = cr4_saved | X86_CR4_PAE;
> +	vmcb->save.cr4 = cr4_saved | X86_CR4_PAE;
>  	SVM_TEST_CR_RESERVED_BITS(ctx, 0, 2, 1, 3, cr3_saved,
>  				  SVM_CR3_PAE_LEGACY_RESERVED_MASK, SVM_EXIT_NPF, "(PAE) ");
>  
>  	pdpe[0] |= 1ULL;
>  
>  skip_npt_only:
> -	vcpu0.vmcb->save.cr3 = cr3_saved;
> -	vcpu0.vmcb->save.cr4 = cr4_saved;
> +	vmcb->save.cr3 = cr3_saved;
> +	vmcb->save.cr4 = cr4_saved;
>  }
>  
>  /* Test CR4 MBZ bits based on legacy or long modes */
>  static void test_cr4(struct svm_test_context *ctx)
>  {
> -	u64 cr4_saved = vcpu0.vmcb->save.cr4;
> -	u64 efer_saved = vcpu0.vmcb->save.efer;
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
> +	u64 cr4_saved = vmcb->save.cr4;
> +	u64 efer_saved = vmcb->save.efer;
>  	u64 efer = efer_saved;
>  
>  	efer &= ~EFER_LME;
> -	vcpu0.vmcb->save.efer = efer;
> +	vmcb->save.efer = efer;
>  	SVM_TEST_CR_RESERVED_BITS(ctx, 12, 31, 1, 4, cr4_saved,
>  				  SVM_CR4_LEGACY_RESERVED_MASK, SVM_EXIT_ERR, "");
>  
>  	efer |= EFER_LME;
> -	vcpu0.vmcb->save.efer = efer;
> +	vmcb->save.efer = efer;
>  	SVM_TEST_CR_RESERVED_BITS(ctx, 12, 31, 1, 4, cr4_saved,
>  				  SVM_CR4_RESERVED_MASK, SVM_EXIT_ERR, "");
>  	SVM_TEST_CR_RESERVED_BITS(ctx, 32, 63, 4, 4, cr4_saved,
>  				  SVM_CR4_RESERVED_MASK, SVM_EXIT_ERR, "");
>  
> -	vcpu0.vmcb->save.cr4 = cr4_saved;
> -	vcpu0.vmcb->save.efer = efer_saved;
> +	vmcb->save.cr4 = cr4_saved;
> +	vmcb->save.efer = efer_saved;
>  }
>  
>  static void test_dr(struct svm_test_context *ctx)
> @@ -2263,27 +2338,29 @@ static void test_dr(struct svm_test_context *ctx)
>  	/*
>  	 * DR6[63:32] and DR7[63:32] are MBZ
>  	 */
> -	u64 dr_saved = vcpu0.vmcb->save.dr6;
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
>  
> -	SVM_TEST_REG_RESERVED_BITS(ctx, 32, 63, 4, "DR6", vcpu0.vmcb->save.dr6, dr_saved,
> +	u64 dr_saved = vmcb->save.dr6;
> +
> +	SVM_TEST_REG_RESERVED_BITS(ctx, 32, 63, 4, "DR6", vmcb->save.dr6, dr_saved,
>  				   SVM_DR6_RESERVED_MASK);
> -	vcpu0.vmcb->save.dr6 = dr_saved;
> +	vmcb->save.dr6 = dr_saved;
>  
> -	dr_saved = vcpu0.vmcb->save.dr7;
> -	SVM_TEST_REG_RESERVED_BITS(ctx, 32, 63, 4, "DR7", vcpu0.vmcb->save.dr7, dr_saved,
> +	dr_saved = vmcb->save.dr7;
> +	SVM_TEST_REG_RESERVED_BITS(ctx, 32, 63, 4, "DR7", vmcb->save.dr7, dr_saved,
>  				   SVM_DR7_RESERVED_MASK);
>  
> -	vcpu0.vmcb->save.dr7 = dr_saved;
> +	vmcb->save.dr7 = dr_saved;
>  }
>  
>  /* TODO: verify if high 32-bits are sign- or zero-extended on bare metal */
> -#define	TEST_BITMAP_ADDR(ctx, save_intercept, type, addr, exit_code,		\
> +#define	TEST_BITMAP_ADDR(ctx, save_intercept, type, addr, exit_code,	\
>  			 msg) {						\
> -		vcpu0.vmcb->control.intercept = saved_intercept | 1ULL << type; \
> +		ctx->vcpu->vmcb->control.intercept = saved_intercept | 1ULL << type; \
>  		if (type == INTERCEPT_MSR_PROT)				\
> -			vcpu0.vmcb->control.msrpm_base_pa = addr;		\
> +			ctx->vcpu->vmcb->control.msrpm_base_pa = addr;	\
>  		else							\
> -			vcpu0.vmcb->control.iopm_base_pa = addr;		\
> +			ctx->vcpu->vmcb->control.iopm_base_pa = addr;	\
>  		report(svm_vmrun(ctx) == exit_code,			\
>  		       "Test %s address: %lx", msg, addr);		\
>  	}
> @@ -2306,7 +2383,9 @@ static void test_dr(struct svm_test_context *ctx)
>   */
>  static void test_msrpm_iopm_bitmap_addrs(struct svm_test_context *ctx)
>  {
> -	u64 saved_intercept = vcpu0.vmcb->control.intercept;
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
> +	u64 saved_intercept = vmcb->control.intercept;
>  	u64 addr_beyond_limit = 1ull << cpuid_maxphyaddr();
>  	u64 addr = virt_to_phys(svm_get_msr_bitmap()) & (~((1ull << 12) - 1));
>  	u8 *io_bitmap = svm_get_io_bitmap();
> @@ -2348,7 +2427,7 @@ static void test_msrpm_iopm_bitmap_addrs(struct svm_test_context *ctx)
>  	TEST_BITMAP_ADDR(ctx, saved_intercept, INTERCEPT_IOIO_PROT, addr,
>  			 SVM_EXIT_VMMCALL, "IOPM");
>  
> -	vcpu0.vmcb->control.intercept = saved_intercept;
> +	vmcb->control.intercept = saved_intercept;
>  }
>  
>  /*
> @@ -2378,22 +2457,24 @@ static void test_canonicalization(struct svm_test_context *ctx)
>  	u64 saved_addr;
>  	u64 return_value;
>  	u64 addr_limit;
> -	u64 vmcb_phys = virt_to_phys(vcpu0.vmcb);
> +
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +	u64 vmcb_phys = virt_to_phys(vmcb);
>  
>  	addr_limit = (this_cpu_has(X86_FEATURE_LA57)) ? 57 : 48;
>  	u64 noncanonical_mask = NONCANONICAL & ~((1ul << addr_limit) - 1);
>  
> -	TEST_CANONICAL_VMLOAD(ctx, vcpu0.vmcb->save.fs.base, "FS");
> -	TEST_CANONICAL_VMLOAD(ctx, vcpu0.vmcb->save.gs.base, "GS");
> -	TEST_CANONICAL_VMLOAD(ctx, vcpu0.vmcb->save.ldtr.base, "LDTR");
> -	TEST_CANONICAL_VMLOAD(ctx, vcpu0.vmcb->save.tr.base, "TR");
> -	TEST_CANONICAL_VMLOAD(ctx, vcpu0.vmcb->save.kernel_gs_base, "KERNEL GS");
> -	TEST_CANONICAL_VMRUN(ctx, vcpu0.vmcb->save.es.base, "ES");
> -	TEST_CANONICAL_VMRUN(ctx, vcpu0.vmcb->save.cs.base, "CS");
> -	TEST_CANONICAL_VMRUN(ctx, vcpu0.vmcb->save.ss.base, "SS");
> -	TEST_CANONICAL_VMRUN(ctx, vcpu0.vmcb->save.ds.base, "DS");
> -	TEST_CANONICAL_VMRUN(ctx, vcpu0.vmcb->save.gdtr.base, "GDTR");
> -	TEST_CANONICAL_VMRUN(ctx, vcpu0.vmcb->save.idtr.base, "IDTR");
> +	TEST_CANONICAL_VMLOAD(ctx, vmcb->save.fs.base, "FS");
> +	TEST_CANONICAL_VMLOAD(ctx, vmcb->save.gs.base, "GS");
> +	TEST_CANONICAL_VMLOAD(ctx, vmcb->save.ldtr.base, "LDTR");
> +	TEST_CANONICAL_VMLOAD(ctx, vmcb->save.tr.base, "TR");
> +	TEST_CANONICAL_VMLOAD(ctx, vmcb->save.kernel_gs_base, "KERNEL GS");
> +	TEST_CANONICAL_VMRUN(ctx, vmcb->save.es.base, "ES");
> +	TEST_CANONICAL_VMRUN(ctx, vmcb->save.cs.base, "CS");
> +	TEST_CANONICAL_VMRUN(ctx, vmcb->save.ss.base, "SS");
> +	TEST_CANONICAL_VMRUN(ctx, vmcb->save.ds.base, "DS");
> +	TEST_CANONICAL_VMRUN(ctx, vmcb->save.gdtr.base, "GDTR");
> +	TEST_CANONICAL_VMRUN(ctx, vmcb->save.idtr.base, "IDTR");
>  }
>  
>  /*
> @@ -2442,12 +2523,14 @@ asm("guest_rflags_test_guest:\n\t"
>  
>  static void svm_test_singlestep(struct svm_test_context *ctx)
>  {
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
>  	handle_exception(DB_VECTOR, guest_rflags_test_db_handler);
>  
>  	/*
>  	 * Trap expected after completion of first guest instruction
>  	 */
> -	vcpu0.vmcb->save.rflags |= X86_EFLAGS_TF;
> +	vmcb->save.rflags |= X86_EFLAGS_TF;
>  	report (__svm_vmrun(ctx, (u64)guest_rflags_test_guest) == SVM_EXIT_VMMCALL &&
>  		guest_rflags_test_trap_rip == (u64)&insn2,
>  		"Test EFLAGS.TF on VMRUN: trap expected  after completion of first guest instruction");
> @@ -2455,18 +2538,18 @@ static void svm_test_singlestep(struct svm_test_context *ctx)
>  	 * No trap expected
>  	 */
>  	guest_rflags_test_trap_rip = 0;
> -	vcpu0.vmcb->save.rip += 3;
> -	vcpu0.vmcb->save.rflags |= X86_EFLAGS_TF;
> -	report(__svm_vmrun(ctx, vcpu0.vmcb->save.rip) == SVM_EXIT_VMMCALL &&
> +	vmcb->save.rip += 3;
> +	vmcb->save.rflags |= X86_EFLAGS_TF;
> +	report(__svm_vmrun(ctx, vmcb->save.rip) == SVM_EXIT_VMMCALL &&
>  		guest_rflags_test_trap_rip == 0,
>  		"Test EFLAGS.TF on VMRUN: trap not expected");
>  
>  	/*
>  	 * Let guest finish execution
>  	 */
> -	vcpu0.vmcb->save.rip += 3;
> -	report(__svm_vmrun(ctx, vcpu0.vmcb->save.rip) == SVM_EXIT_VMMCALL &&
> -		vcpu0.vmcb->save.rip == (u64)&guest_end,
> +	vmcb->save.rip += 3;
> +	report(__svm_vmrun(ctx, vmcb->save.rip) == SVM_EXIT_VMMCALL &&
> +		vmcb->save.rip == (u64)&guest_end,
>  		"Test EFLAGS.TF on VMRUN: guest execution completion");
>  }
>  
> @@ -2538,7 +2621,8 @@ static void svm_vmrun_errata_test(struct svm_test_context *ctx)
>  
>  static void vmload_vmsave_guest_main(struct svm_test_context *ctx)
>  {
> -	u64 vmcb_phys = virt_to_phys(vcpu0.vmcb);
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +	u64 vmcb_phys = virt_to_phys(vmcb);
>  
>  	asm volatile ("vmload %0" : : "a"(vmcb_phys));
>  	asm volatile ("vmsave %0" : : "a"(vmcb_phys));
> @@ -2546,7 +2630,8 @@ static void vmload_vmsave_guest_main(struct svm_test_context *ctx)
>  
>  static void svm_vmload_vmsave(struct svm_test_context *ctx)
>  {
> -	u32 intercept_saved = vcpu0.vmcb->control.intercept;
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +	u32 intercept_saved = vmcb->control.intercept;
>  
>  	test_set_guest(vmload_vmsave_guest_main);
>  
> @@ -2554,49 +2639,49 @@ static void svm_vmload_vmsave(struct svm_test_context *ctx)
>  	 * Disabling intercept for VMLOAD and VMSAVE doesn't cause
>  	 * respective #VMEXIT to host
>  	 */
> -	vcpu0.vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMLOAD);
> -	vcpu0.vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMSAVE);
> +	vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMLOAD);
> +	vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMSAVE);
>  	svm_vmrun(ctx);
> -	report(vcpu0.vmcb->control.exit_code == SVM_EXIT_VMMCALL, "Test "
> +	report(vmcb->control.exit_code == SVM_EXIT_VMMCALL, "Test "
>  	       "VMLOAD/VMSAVE intercept: Expected VMMCALL #VMEXIT");
>  
>  	/*
>  	 * Enabling intercept for VMLOAD and VMSAVE causes respective
>  	 * #VMEXIT to host
>  	 */
> -	vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_VMLOAD);
> +	vmcb->control.intercept |= (1ULL << INTERCEPT_VMLOAD);
>  	svm_vmrun(ctx);
> -	report(vcpu0.vmcb->control.exit_code == SVM_EXIT_VMLOAD, "Test "
> +	report(vmcb->control.exit_code == SVM_EXIT_VMLOAD, "Test "
>  	       "VMLOAD/VMSAVE intercept: Expected VMLOAD #VMEXIT");
> -	vcpu0.vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMLOAD);
> -	vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_VMSAVE);
> +	vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMLOAD);
> +	vmcb->control.intercept |= (1ULL << INTERCEPT_VMSAVE);
>  	svm_vmrun(ctx);
> -	report(vcpu0.vmcb->control.exit_code == SVM_EXIT_VMSAVE, "Test "
> +	report(vmcb->control.exit_code == SVM_EXIT_VMSAVE, "Test "
>  	       "VMLOAD/VMSAVE intercept: Expected VMSAVE #VMEXIT");
> -	vcpu0.vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMSAVE);
> +	vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMSAVE);
>  	svm_vmrun(ctx);
> -	report(vcpu0.vmcb->control.exit_code == SVM_EXIT_VMMCALL, "Test "
> +	report(vmcb->control.exit_code == SVM_EXIT_VMMCALL, "Test "
>  	       "VMLOAD/VMSAVE intercept: Expected VMMCALL #VMEXIT");
>  
> -	vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_VMLOAD);
> +	vmcb->control.intercept |= (1ULL << INTERCEPT_VMLOAD);
>  	svm_vmrun(ctx);
> -	report(vcpu0.vmcb->control.exit_code == SVM_EXIT_VMLOAD, "Test "
> +	report(vmcb->control.exit_code == SVM_EXIT_VMLOAD, "Test "
>  	       "VMLOAD/VMSAVE intercept: Expected VMLOAD #VMEXIT");
> -	vcpu0.vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMLOAD);
> +	vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMLOAD);
>  	svm_vmrun(ctx);
> -	report(vcpu0.vmcb->control.exit_code == SVM_EXIT_VMMCALL, "Test "
> +	report(vmcb->control.exit_code == SVM_EXIT_VMMCALL, "Test "
>  	       "VMLOAD/VMSAVE intercept: Expected VMMCALL #VMEXIT");
>  
> -	vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_VMSAVE);
> +	vmcb->control.intercept |= (1ULL << INTERCEPT_VMSAVE);
>  	svm_vmrun(ctx);
> -	report(vcpu0.vmcb->control.exit_code == SVM_EXIT_VMSAVE, "Test "
> +	report(vmcb->control.exit_code == SVM_EXIT_VMSAVE, "Test "
>  	       "VMLOAD/VMSAVE intercept: Expected VMSAVE #VMEXIT");
> -	vcpu0.vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMSAVE);
> +	vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMSAVE);
>  	svm_vmrun(ctx);
> -	report(vcpu0.vmcb->control.exit_code == SVM_EXIT_VMMCALL, "Test "
> +	report(vmcb->control.exit_code == SVM_EXIT_VMMCALL, "Test "
>  	       "VMLOAD/VMSAVE intercept: Expected VMMCALL #VMEXIT");
>  
> -	vcpu0.vmcb->control.intercept = intercept_saved;
> +	vmcb->control.intercept = intercept_saved;
>  }
>  
>  static void prepare_vgif_enabled(struct svm_test_context *ctx)
> @@ -2610,45 +2695,47 @@ static void test_vgif(struct svm_test_context *ctx)
>  
>  static bool vgif_finished(struct svm_test_context *ctx)
>  {
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
>  	switch (get_test_stage(ctx))
>  		{
>  		case 0:
> -			if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
> +			if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
>  				report_fail("VMEXIT not due to vmmcall.");
>  				return true;
>  			}
> -			vcpu0.vmcb->control.int_ctl |= V_GIF_ENABLED_MASK;
> -			vcpu0.vmcb->save.rip += 3;
> +			vmcb->control.int_ctl |= V_GIF_ENABLED_MASK;
> +			vmcb->save.rip += 3;
>  			inc_test_stage(ctx);
>  			break;
>  		case 1:
> -			if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
> +			if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
>  				report_fail("VMEXIT not due to vmmcall.");
>  				return true;
>  			}
> -			if (!(vcpu0.vmcb->control.int_ctl & V_GIF_MASK)) {
> +			if (!(vmcb->control.int_ctl & V_GIF_MASK)) {
>  				report_fail("Failed to set VGIF when executing STGI.");
> -				vcpu0.vmcb->control.int_ctl &= ~V_GIF_ENABLED_MASK;
> +				vmcb->control.int_ctl &= ~V_GIF_ENABLED_MASK;
>  				return true;
>  			}
>  			report_pass("STGI set VGIF bit.");
> -			vcpu0.vmcb->save.rip += 3;
> +			vmcb->save.rip += 3;
>  			inc_test_stage(ctx);
>  			break;
>  		case 2:
> -			if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
> +			if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
>  				report_fail("VMEXIT not due to vmmcall.");
>  				return true;
>  			}
> -			if (vcpu0.vmcb->control.int_ctl & V_GIF_MASK) {
> +			if (vmcb->control.int_ctl & V_GIF_MASK) {
>  				report_fail("Failed to clear VGIF when executing CLGI.");
> -				vcpu0.vmcb->control.int_ctl &= ~V_GIF_ENABLED_MASK;
> +				vmcb->control.int_ctl &= ~V_GIF_ENABLED_MASK;
>  				return true;
>  			}
>  			report_pass("CLGI cleared VGIF bit.");
> -			vcpu0.vmcb->save.rip += 3;
> +			vmcb->save.rip += 3;
>  			inc_test_stage(ctx);
> -			vcpu0.vmcb->control.int_ctl &= ~V_GIF_ENABLED_MASK;
> +			vmcb->control.int_ctl &= ~V_GIF_ENABLED_MASK;
>  			break;
>  		default:
>  			return true;
> @@ -2688,31 +2775,35 @@ static void pause_filter_run_test(struct svm_test_context *ctx,
>  				  int pause_iterations, int filter_value,
>  				  int wait_iterations, int threshold)
>  {
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
>  	test_set_guest(pause_filter_test_guest_main);
>  
>  	pause_test_counter = pause_iterations;
>  	wait_counter = wait_iterations;
>  
> -	vcpu0.vmcb->control.pause_filter_count = filter_value;
> -	vcpu0.vmcb->control.pause_filter_thresh = threshold;
> +	vmcb->control.pause_filter_count = filter_value;
> +	vmcb->control.pause_filter_thresh = threshold;
>  	svm_vmrun(ctx);
>  
>  	if (filter_value <= pause_iterations || wait_iterations < threshold)
> -		report(vcpu0.vmcb->control.exit_code == SVM_EXIT_PAUSE,
> +		report(vmcb->control.exit_code == SVM_EXIT_PAUSE,
>  		       "expected PAUSE vmexit");
>  	else
> -		report(vcpu0.vmcb->control.exit_code == SVM_EXIT_VMMCALL,
> +		report(vmcb->control.exit_code == SVM_EXIT_VMMCALL,
>  		       "no expected PAUSE vmexit");
>  }
>  
>  static void pause_filter_test(struct svm_test_context *ctx)
>  {
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
>  	if (!pause_filter_supported()) {
>  		report_skip("PAUSE filter not supported in the guest");
>  		return;
>  	}
>  
> -	vcpu0.vmcb->control.intercept |= (1 << INTERCEPT_PAUSE);
> +	vmcb->control.intercept |= (1 << INTERCEPT_PAUSE);
>  
>  	// filter count more that pause count - no VMexit
>  	pause_filter_run_test(ctx, 10, 9, 0, 0);
> @@ -2738,10 +2829,12 @@ static void pause_filter_test(struct svm_test_context *ctx)
>  /* If CR0.TS and CR0.EM are cleared in L2, no #NM is generated. */
>  static void svm_no_nm_test(struct svm_test_context *ctx)
>  {
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
>  	write_cr0(read_cr0() & ~X86_CR0_TS);
>  	test_set_guest((test_guest_func)fnop);
>  
> -	vcpu0.vmcb->save.cr0 = vcpu0.vmcb->save.cr0 & ~(X86_CR0_TS | X86_CR0_EM);
> +	vmcb->save.cr0 = vmcb->save.cr0 & ~(X86_CR0_TS | X86_CR0_EM);
>  	report(svm_vmrun(ctx) == SVM_EXIT_VMMCALL,
>  	       "fnop with CR0.TS and CR0.EM unset no #NM excpetion");
>  }
> @@ -2872,20 +2965,21 @@ static void svm_lbrv_test0(struct svm_test_context *ctx)
>  
>  static void svm_lbrv_test1(struct svm_test_context *ctx)
>  {
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
>  
>  	report(true, "Test that without LBRV enabled, guest LBR state does 'leak' to the host(1)");
>  
> -	vcpu0.vmcb->save.rip = (ulong)svm_lbrv_test_guest1;
> -	vcpu0.vmcb->control.virt_ext = 0;
> +	vmcb->save.rip = (ulong)svm_lbrv_test_guest1;
> +	vmcb->control.virt_ext = 0;
>  
>  	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
>  	DO_BRANCH(host_branch1);
> -	SVM_VMRUN(&vcpu0);
> +	SVM_VMRUN(ctx->vcpu);
>  	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
>  
> -	if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
> +	if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
>  		report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
> -		       vcpu0.vmcb->control.exit_code);
> +		       vmcb->control.exit_code);
>  		return;
>  	}
>  
> @@ -2895,21 +2989,23 @@ static void svm_lbrv_test1(struct svm_test_context *ctx)
>  
>  static void svm_lbrv_test2(struct svm_test_context *ctx)
>  {
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
>  	report(true, "Test that without LBRV enabled, guest LBR state does 'leak' to the host(2)");
>  
> -	vcpu0.vmcb->save.rip = (ulong)svm_lbrv_test_guest2;
> -	vcpu0.vmcb->control.virt_ext = 0;
> +	vmcb->save.rip = (ulong)svm_lbrv_test_guest2;
> +	vmcb->control.virt_ext = 0;
>  
>  	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
>  	DO_BRANCH(host_branch2);
>  	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
> -	SVM_VMRUN(&vcpu0);
> +	SVM_VMRUN(ctx->vcpu);
>  	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
>  	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
>  
> -	if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
> +	if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
>  		report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
> -		       vcpu0.vmcb->control.exit_code);
> +		       vmcb->control.exit_code);
>  		return;
>  	}
>  
> @@ -2919,32 +3015,34 @@ static void svm_lbrv_test2(struct svm_test_context *ctx)
>  
>  static void svm_lbrv_nested_test1(struct svm_test_context *ctx)
>  {
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
>  	if (!lbrv_supported()) {
>  		report_skip("LBRV not supported in the guest");
>  		return;
>  	}
>  
>  	report(true, "Test that with LBRV enabled, guest LBR state doesn't leak (1)");
> -	vcpu0.vmcb->save.rip = (ulong)svm_lbrv_test_guest1;
> -	vcpu0.vmcb->control.virt_ext = LBR_CTL_ENABLE_MASK;
> -	vcpu0.vmcb->save.dbgctl = DEBUGCTLMSR_LBR;
> +	vmcb->save.rip = (ulong)svm_lbrv_test_guest1;
> +	vmcb->control.virt_ext = LBR_CTL_ENABLE_MASK;
> +	vmcb->save.dbgctl = DEBUGCTLMSR_LBR;
>  
>  	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
>  	DO_BRANCH(host_branch3);
> -	SVM_VMRUN(&vcpu0);
> +	SVM_VMRUN(ctx->vcpu);
>  	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
>  	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
>  
> -	if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
> +	if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
>  		report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
> -		       vcpu0.vmcb->control.exit_code);
> +		       vmcb->control.exit_code);
>  		return;
>  	}
>  
> -	if (vcpu0.vmcb->save.dbgctl != 0) {
> +	if (vmcb->save.dbgctl != 0) {
>  		report(false,
>  		       "unexpected virtual guest MSR_IA32_DEBUGCTLMSR value 0x%lx",
> -		       vcpu0.vmcb->save.dbgctl);
> +		       vmcb->save.dbgctl);
>  		return;
>  	}
>  
> @@ -2954,28 +3052,30 @@ static void svm_lbrv_nested_test1(struct svm_test_context *ctx)
>  
>  static void svm_lbrv_nested_test2(struct svm_test_context *ctx)
>  {
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
>  	if (!lbrv_supported()) {
>  		report_skip("LBRV not supported in the guest");
>  		return;
>  	}
>  
>  	report(true, "Test that with LBRV enabled, guest LBR state doesn't leak (2)");
> -	vcpu0.vmcb->save.rip = (ulong)svm_lbrv_test_guest2;
> -	vcpu0.vmcb->control.virt_ext = LBR_CTL_ENABLE_MASK;
> +	vmcb->save.rip = (ulong)svm_lbrv_test_guest2;
> +	vmcb->control.virt_ext = LBR_CTL_ENABLE_MASK;
>  
> -	vcpu0.vmcb->save.dbgctl = 0;
> -	vcpu0.vmcb->save.br_from = (u64)&host_branch2_from;
> -	vcpu0.vmcb->save.br_to = (u64)&host_branch2_to;
> +	vmcb->save.dbgctl = 0;
> +	vmcb->save.br_from = (u64)&host_branch2_from;
> +	vmcb->save.br_to = (u64)&host_branch2_to;
>  
>  	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
>  	DO_BRANCH(host_branch4);
> -	SVM_VMRUN(&vcpu0);
> +	SVM_VMRUN(ctx->vcpu);
>  	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
>  	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
>  
> -	if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
> +	if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
>  		report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
> -		       vcpu0.vmcb->control.exit_code);
> +		       vmcb->control.exit_code);
>  		return;
>  	}
>  
> @@ -3005,6 +3105,8 @@ static void dummy_nmi_handler(struct ex_regs *regs)
>  static void svm_intr_intercept_mix_run_guest(struct svm_test_context *ctx,
>  					     volatile int *counter, int expected_vmexit)
>  {
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
>  	if (counter)
>  		*counter = 0;
>  
> @@ -3021,8 +3123,8 @@ static void svm_intr_intercept_mix_run_guest(struct svm_test_context *ctx,
>  	if (counter)
>  		report(*counter == 1, "Interrupt is expected");
>  
> -	report(vcpu0.vmcb->control.exit_code == expected_vmexit, "Test expected VM exit");
> -	report(vcpu0.vmcb->save.rflags & X86_EFLAGS_IF, "Guest should have EFLAGS.IF set now");
> +	report(vmcb->control.exit_code == expected_vmexit, "Test expected VM exit");
> +	report(vmcb->save.rflags & X86_EFLAGS_IF, "Guest should have EFLAGS.IF set now");
>  	cli();
>  }
>  
> @@ -3038,12 +3140,14 @@ static void svm_intr_intercept_mix_if_guest(struct svm_test_context *ctx)
>  
>  static void svm_intr_intercept_mix_if(struct svm_test_context *ctx)
>  {
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
>  	// make a physical interrupt to be pending
>  	handle_irq(0x55, dummy_isr);
>  
> -	vcpu0.vmcb->control.intercept |= (1 << INTERCEPT_INTR);
> -	vcpu0.vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
> -	vcpu0.vmcb->save.rflags &= ~X86_EFLAGS_IF;
> +	vmcb->control.intercept |= (1 << INTERCEPT_INTR);
> +	vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
> +	vmcb->save.rflags &= ~X86_EFLAGS_IF;
>  
>  	test_set_guest(svm_intr_intercept_mix_if_guest);
>  	cli();
> @@ -3072,11 +3176,13 @@ static void svm_intr_intercept_mix_gif_guest(struct svm_test_context *ctx)
>  
>  static void svm_intr_intercept_mix_gif(struct svm_test_context *ctx)
>  {
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
>  	handle_irq(0x55, dummy_isr);
>  
> -	vcpu0.vmcb->control.intercept |= (1 << INTERCEPT_INTR);
> -	vcpu0.vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
> -	vcpu0.vmcb->save.rflags &= ~X86_EFLAGS_IF;
> +	vmcb->control.intercept |= (1 << INTERCEPT_INTR);
> +	vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
> +	vmcb->save.rflags &= ~X86_EFLAGS_IF;
>  
>  	test_set_guest(svm_intr_intercept_mix_gif_guest);
>  	cli();
> @@ -3102,11 +3208,13 @@ static void svm_intr_intercept_mix_gif_guest2(struct svm_test_context *ctx)
>  
>  static void svm_intr_intercept_mix_gif2(struct svm_test_context *ctx)
>  {
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
>  	handle_irq(0x55, dummy_isr);
>  
> -	vcpu0.vmcb->control.intercept |= (1 << INTERCEPT_INTR);
> -	vcpu0.vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
> -	vcpu0.vmcb->save.rflags |= X86_EFLAGS_IF;
> +	vmcb->control.intercept |= (1 << INTERCEPT_INTR);
> +	vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
> +	vmcb->save.rflags |= X86_EFLAGS_IF;
>  
>  	test_set_guest(svm_intr_intercept_mix_gif_guest2);
>  	svm_intr_intercept_mix_run_guest(ctx, &dummy_isr_recevied, SVM_EXIT_INTR);
> @@ -3131,11 +3239,13 @@ static void svm_intr_intercept_mix_nmi_guest(struct svm_test_context *ctx)
>  
>  static void svm_intr_intercept_mix_nmi(struct svm_test_context *ctx)
>  {
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
>  	handle_exception(2, dummy_nmi_handler);
>  
> -	vcpu0.vmcb->control.intercept |= (1 << INTERCEPT_NMI);
> -	vcpu0.vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
> -	vcpu0.vmcb->save.rflags |= X86_EFLAGS_IF;
> +	vmcb->control.intercept |= (1 << INTERCEPT_NMI);
> +	vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
> +	vmcb->save.rflags |= X86_EFLAGS_IF;
>  
>  	test_set_guest(svm_intr_intercept_mix_nmi_guest);
>  	svm_intr_intercept_mix_run_guest(ctx, &nmi_recevied, SVM_EXIT_NMI);
> @@ -3157,8 +3267,10 @@ static void svm_intr_intercept_mix_smi_guest(struct svm_test_context *ctx)
>  
>  static void svm_intr_intercept_mix_smi(struct svm_test_context *ctx)
>  {
> -	vcpu0.vmcb->control.intercept |= (1 << INTERCEPT_SMI);
> -	vcpu0.vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
> +	vmcb->control.intercept |= (1 << INTERCEPT_SMI);
> +	vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
>  	test_set_guest(svm_intr_intercept_mix_smi_guest);
>  	svm_intr_intercept_mix_run_guest(ctx, NULL, SVM_EXIT_SMI);
>  }
> @@ -3215,14 +3327,16 @@ static void handle_exception_in_l2(struct svm_test_context *ctx, u8 vector)
>  
>  static void handle_exception_in_l1(struct svm_test_context *ctx, u32 vector)
>  {
> -	u32 old_ie = vcpu0.vmcb->control.intercept_exceptions;
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
> +	u32 old_ie = vmcb->control.intercept_exceptions;
>  
> -	vcpu0.vmcb->control.intercept_exceptions |= (1ULL << vector);
> +	vmcb->control.intercept_exceptions |= (1ULL << vector);
>  
>  	report(svm_vmrun(ctx) == (SVM_EXIT_EXCP_BASE + vector),
>  		"%s handled by L1",  exception_mnemonic(vector));
>  
> -	vcpu0.vmcb->control.intercept_exceptions = old_ie;
> +	vmcb->control.intercept_exceptions = old_ie;
>  }
>  
>  static void svm_exception_test(struct svm_test_context *ctx)
> @@ -3235,10 +3349,10 @@ static void svm_exception_test(struct svm_test_context *ctx)
>  		test_set_guest((test_guest_func)t->guest_code);
>  
>  		handle_exception_in_l2(ctx, t->vector);
> -		svm_vcpu_ident(&vcpu0);
> +		svm_vcpu_ident(ctx->vcpu);
>  
>  		handle_exception_in_l1(ctx, t->vector);
> -		svm_vcpu_ident(&vcpu0);
> +		svm_vcpu_ident(ctx->vcpu);
>  	}
>  }
>  
> @@ -3250,11 +3364,13 @@ static void shutdown_intercept_test_guest(struct svm_test_context *ctx)
>  }
>  static void svm_shutdown_intercept_test(struct svm_test_context *ctx)
>  {
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
>  	test_set_guest(shutdown_intercept_test_guest);
> -	vcpu0.vmcb->save.idtr.base = (u64)alloc_vpage();
> -	vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_SHUTDOWN);
> +	vmcb->save.idtr.base = (u64)alloc_vpage();
> +	vmcb->control.intercept |= (1ULL << INTERCEPT_SHUTDOWN);
>  	svm_vmrun(ctx);
> -	report(vcpu0.vmcb->control.exit_code == SVM_EXIT_SHUTDOWN, "shutdown test passed");
> +	report(vmcb->control.exit_code == SVM_EXIT_SHUTDOWN, "shutdown test passed");
>  }
>  
>  /*
> @@ -3264,7 +3380,9 @@ static void svm_shutdown_intercept_test(struct svm_test_context *ctx)
>  
>  static void exception_merging_prepare(struct svm_test_context *ctx)
>  {
> -	vcpu0.vmcb->control.intercept_exceptions |= (1ULL << GP_VECTOR);
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
> +	vmcb->control.intercept_exceptions |= (1ULL << GP_VECTOR);
>  
>  	/* break UD vector idt entry to get #GP*/
>  	boot_idt[UD_VECTOR].type = 1;
> @@ -3277,15 +3395,17 @@ static void exception_merging_test(struct svm_test_context *ctx)
>  
>  static bool exception_merging_finished(struct svm_test_context *ctx)
>  {
> -	u32 vec = vcpu0.vmcb->control.exit_int_info & SVM_EXITINTINFO_VEC_MASK;
> -	u32 type = vcpu0.vmcb->control.exit_int_info & SVM_EXITINTINFO_TYPE_MASK;
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
> +	u32 vec = vmcb->control.exit_int_info & SVM_EXITINTINFO_VEC_MASK;
> +	u32 type = vmcb->control.exit_int_info & SVM_EXITINTINFO_TYPE_MASK;
>  
> -	if (vcpu0.vmcb->control.exit_code != SVM_EXIT_EXCP_BASE + GP_VECTOR) {
> +	if (vmcb->control.exit_code != SVM_EXIT_EXCP_BASE + GP_VECTOR) {
>  		report(false, "unexpected VM exit");
>  		goto out;
>  	}
>  
> -	if (!(vcpu0.vmcb->control.exit_int_info & SVM_EXITINTINFO_VALID)) {
> +	if (!(vmcb->control.exit_int_info & SVM_EXITINTINFO_VALID)) {
>  		report(false, "EXITINTINFO not valid");
>  		goto out;
>  	}
> @@ -3320,8 +3440,10 @@ static bool exception_merging_check(struct svm_test_context *ctx)
>  
>  static void interrupt_merging_prepare(struct svm_test_context *ctx)
>  {
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
> +
>  	/* intercept #GP */
> -	vcpu0.vmcb->control.intercept_exceptions |= (1ULL << GP_VECTOR);
> +	vmcb->control.intercept_exceptions |= (1ULL << GP_VECTOR);
>  
>  	/* set local APIC to inject external interrupts */
>  	apic_setup_timer(TIMER_VECTOR, APIC_LVT_TIMER_PERIODIC);
> @@ -3342,16 +3464,17 @@ static void interrupt_merging_test(struct svm_test_context *ctx)
>  
>  static bool interrupt_merging_finished(struct svm_test_context *ctx)
>  {
> +	struct vmcb *vmcb = ctx->vcpu->vmcb;
>  
> -	u32 vec = vcpu0.vmcb->control.exit_int_info & SVM_EXITINTINFO_VEC_MASK;
> -	u32 type = vcpu0.vmcb->control.exit_int_info & SVM_EXITINTINFO_TYPE_MASK;
> -	u32 error_code = vcpu0.vmcb->control.exit_info_1;
> +	u32 vec = vmcb->control.exit_int_info & SVM_EXITINTINFO_VEC_MASK;
> +	u32 type = vmcb->control.exit_int_info & SVM_EXITINTINFO_TYPE_MASK;
> +	u32 error_code = vmcb->control.exit_info_1;
>  
>  	/* exit on external interrupts is disabled, thus timer interrupt
>  	 * should be attempted to be delivered, but due to incorrect IDT entry
>  	 * an #GP should be raised
>  	 */
> -	if (vcpu0.vmcb->control.exit_code != SVM_EXIT_EXCP_BASE + GP_VECTOR) {
> +	if (vmcb->control.exit_code != SVM_EXIT_EXCP_BASE + GP_VECTOR) {
>  		report(false, "unexpected VM exit");
>  		goto cleanup;
>  	}
> @@ -3363,7 +3486,7 @@ static bool interrupt_merging_finished(struct svm_test_context *ctx)
>  	}
>  
>  	/* Original interrupt should be preserved in EXITINTINFO */
> -	if (!(vcpu0.vmcb->control.exit_int_info & SVM_EXITINTINFO_VALID)) {
> +	if (!(vmcb->control.exit_int_info & SVM_EXITINTINFO_VALID)) {
>  		report(false, "EXITINTINFO not valid");
>  		goto cleanup;
>  	}
> 

