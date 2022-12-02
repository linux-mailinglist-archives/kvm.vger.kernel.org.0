Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2693464044F
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 11:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbiLBKP7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 05:15:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231775AbiLBKP5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 05:15:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3132CCFC1
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 02:15:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669976104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1heyhO8OuC9kMg8eP05vDgj8KDcHfO/OAnezioiQNts=;
        b=RQYIZ2LHIwkEApkor8T0oVM6+04Syh40IaA6mrcpXBR41svFFNmvn99uCyxIwy2hmcyr4C
        RP8hVaRm6BaiXB7SwSdzrI//lRExmxwM2ruZsVmnKxsK+jXnq8WLCONDbIraDI6bHNbLtP
        K8o6RU+U+BqcvVoOxRKUBJzx/4HeQuE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-288-MpS7-seLNlWXS46JGvBimg-1; Fri, 02 Dec 2022 05:14:56 -0500
X-MC-Unique: MpS7-seLNlWXS46JGvBimg-1
Received: by mail-wm1-f69.google.com with SMTP id i187-20020a1c3bc4000000b003d06031f2cfso1291625wma.0
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 02:14:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1heyhO8OuC9kMg8eP05vDgj8KDcHfO/OAnezioiQNts=;
        b=yRnN5BhRGmiJQml1yuwuDWtMqhiSHSSv5UPC3fn8vI5sMvH7WdGLBGSbPWaftXelRW
         TMvr8JDgO8YAeSF5rQs9p/4Cox+0PSSqYhmm46Nv98w8dxcaAwBk8YSYF3M1VWxWYcc9
         zzGBLETL6RzgDyG/wFp7cRWbIMIG4yYKuqt0terqZ1uKoP88Z1/IJ64Ck27UgohVYvwi
         qoQRSgt4Lft6TLYUkfbRbkgjwUgJp8r98Xb9jKXvEi49/PK/bNOHNIkCJJoWcZ472FoY
         T4c/4gPDrY8fby5TpeCnjkJ9ouGLs6S9oLZvQdmemmFtFED59NxuHpCk4qJ5lEmNPrNU
         c8GA==
X-Gm-Message-State: ANoB5pmcBlipyp5CqaiDOcvcsNJ15bVvEHdtvAAHYNWLNkTXb1QFZ3s0
        mGNW6gUTQ3OhnZonrKXHc0Fl/4o9gOqG5T4B6UZW9oIdkaEh2KCv2lpNe+X/dcpI83rTSDejn0T
        YSLgi5V8PTxpk
X-Received: by 2002:adf:f681:0:b0:242:6af:8a2d with SMTP id v1-20020adff681000000b0024206af8a2dmr20631929wrp.188.1669976094844;
        Fri, 02 Dec 2022 02:14:54 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6hkjcul3VMwipYb9d1oKDu3Gxm6fBB87kKU0wh9cVHlplEHIcKbDYmrShKT3Mfi3H243W3gg==
X-Received: by 2002:adf:f681:0:b0:242:6af:8a2d with SMTP id v1-20020adff681000000b0024206af8a2dmr20631918wrp.188.1669976094575;
        Fri, 02 Dec 2022 02:14:54 -0800 (PST)
Received: from [192.168.149.123] (58.254.164.109.static.wline.lns.sme.cust.swisscom.ch. [109.164.254.58])
        by smtp.gmail.com with ESMTPSA id q14-20020adfdfce000000b00241cbb7f15csm6722996wrn.106.2022.12.02.02.14.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 02:14:54 -0800 (PST)
Message-ID: <cc9b054d-3d53-f6cb-2f67-53af48e5e405@redhat.com>
Date:   Fri, 2 Dec 2022 11:14:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH v3 19/27] svm: rewerite vm entry macros
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
 <20221122161152.293072-20-mlevitsk@redhat.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
In-Reply-To: <20221122161152.293072-20-mlevitsk@redhat.com>
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
> Make SVM VM entry macros to not use harcode regs label
> and also simplify them as much as possible
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  lib/x86/svm_lib.h | 71 +++++++++++++++++++++++++++++++++++++++++++++++
>  x86/svm.c         | 58 ++++++++++++--------------------------
>  x86/svm.h         | 70 ++--------------------------------------------
>  x86/svm_tests.c   | 24 ++++++++++------
>  4 files changed, 106 insertions(+), 117 deletions(-)
> 
> diff --git a/lib/x86/svm_lib.h b/lib/x86/svm_lib.h
> index 3bb098dc..f9c2b352 100644
> --- a/lib/x86/svm_lib.h
> +++ b/lib/x86/svm_lib.h
> @@ -66,4 +66,75 @@ u8 *svm_get_io_bitmap(void);
>  #define MSR_BITMAP_SIZE 8192
>  
>  
> +struct svm_gprs {
> +	u64 rax;
> +	u64 rbx;
> +	u64 rcx;
> +	u64 rdx;
> +	u64 rbp;
> +	u64 rsi;
> +	u64 rdi;
> +	u64 r8;
> +	u64 r9;
> +	u64 r10;
> +	u64 r11;
> +	u64 r12;
> +	u64 r13;
> +	u64 r14;
> +	u64 r15;
> +	u64 rsp;
> +};
> +
> +#define SWAP_GPRS \
> +	"xchg %%rbx, 0x08(%%rax)\n"           \
> +	"xchg %%rcx, 0x10(%%rax)\n"           \
> +	"xchg %%rdx, 0x18(%%rax)\n"           \
> +	"xchg %%rbp, 0x20(%%rax)\n"           \
> +	"xchg %%rsi, 0x28(%%rax)\n"           \
> +	"xchg %%rdi, 0x30(%%rax)\n"           \
> +	"xchg %%r8,  0x38(%%rax)\n"           \
> +	"xchg %%r9,  0x40(%%rax)\n"           \
> +	"xchg %%r10, 0x48(%%rax)\n"           \
> +	"xchg %%r11, 0x50(%%rax)\n"           \
> +	"xchg %%r12, 0x58(%%rax)\n"           \
> +	"xchg %%r13, 0x60(%%rax)\n"           \
> +	"xchg %%r14, 0x68(%%rax)\n"           \
> +	"xchg %%r15, 0x70(%%rax)\n"           \
> +	\
> +
> +
> +#define __SVM_VMRUN(vmcb, regs, label)        \
> +{                                             \
> +	u32 dummy;                            \
> +\
> +	(vmcb)->save.rax = (regs)->rax;       \
> +	(vmcb)->save.rsp = (regs)->rsp;       \
> +\
> +	asm volatile (                        \
> +		"vmload %%rax\n"              \
> +		"push %%rbx\n"                \
> +		"push %%rax\n"                \
> +		"mov %%rbx, %%rax\n"          \
> +		SWAP_GPRS                     \
> +		"pop %%rax\n"                 \
> +		".global " label "\n"         \
> +		label ": vmrun %%rax\n"       \
> +		"vmsave %%rax\n"              \
> +		"pop %%rax\n"                 \
> +		SWAP_GPRS                     \
> +		: "=a"(dummy),                \
> +		  "=b"(dummy)                 \
> +		: "a" (virt_to_phys(vmcb)),   \
> +		  "b"(regs)                   \
> +		/* clobbers*/                 \
> +		: "memory"                    \
> +	);                                    \
> +\
> +	(regs)->rax = (vmcb)->save.rax;       \
> +	(regs)->rsp = (vmcb)->save.rsp;       \
> +}
> +
> +#define SVM_VMRUN(vmcb, regs) \
> +	__SVM_VMRUN(vmcb, regs, "vmrun_dummy_label_%=")
> +
>  #endif /* SRC_LIB_X86_SVM_LIB_H_ */
> diff --git a/x86/svm.c b/x86/svm.c
> index 5e2c3a83..220bce66 100644
> --- a/x86/svm.c
> +++ b/x86/svm.c
> @@ -76,16 +76,13 @@ static void test_thunk(struct svm_test *test)
>  	vmmcall();
>  }
>  
> -struct regs regs;
> +static struct svm_gprs regs;
>  
> -struct regs get_regs(void)
> +struct svm_gprs *get_regs(void)
>  {
> -	return regs;
> +	return &regs;
>  }
>  
> -// rax handled specially below
> -
> -
>  struct svm_test *v2_test;
>  
>  
> @@ -94,16 +91,10 @@ u64 guest_stack[10000];
>  int __svm_vmrun(u64 rip)
>  {
>  	vmcb->save.rip = (ulong)rip;
> -	vmcb->save.rsp = (ulong)(guest_stack + ARRAY_SIZE(guest_stack));
> +	regs.rsp = (ulong)(guest_stack + ARRAY_SIZE(guest_stack));
>  	regs.rdi = (ulong)v2_test;
>  
> -	asm volatile (
> -		      ASM_PRE_VMRUN_CMD
> -		      "vmrun %%rax\n\t"               \
> -		      ASM_POST_VMRUN_CMD
> -		      :
> -		      : "a" (virt_to_phys(vmcb))
> -		      : "memory", "r15");
> +	SVM_VMRUN(vmcb, &regs);
>  
>  	return (vmcb->control.exit_code);
>  }
> @@ -113,43 +104,28 @@ int svm_vmrun(void)
>  	return __svm_vmrun((u64)test_thunk);
>  }
>  
> -extern u8 vmrun_rip;
> -
>  static noinline void test_run(struct svm_test *test)
>  {
> -	u64 vmcb_phys = virt_to_phys(vmcb);
> -
>  	cli();
>  	vmcb_ident(vmcb);
>  
>  	test->prepare(test);
>  	guest_main = test->guest_func;
>  	vmcb->save.rip = (ulong)test_thunk;
> -	vmcb->save.rsp = (ulong)(guest_stack + ARRAY_SIZE(guest_stack));
> +	regs.rsp = (ulong)(guest_stack + ARRAY_SIZE(guest_stack));
>  	regs.rdi = (ulong)test;
>  	do {
> -		struct svm_test *the_test = test;
> -		u64 the_vmcb = vmcb_phys;
> -		asm volatile (
> -			      "clgi;\n\t" // semi-colon needed for LLVM compatibility
> -			      "sti \n\t"
> -			      "call *%c[PREPARE_GIF_CLEAR](%[test]) \n \t"
> -			      "mov %[vmcb_phys], %%rax \n\t"
> -			      ASM_PRE_VMRUN_CMD
> -			      ".global vmrun_rip\n\t"		\
> -			      "vmrun_rip: vmrun %%rax\n\t"    \
> -			      ASM_POST_VMRUN_CMD
> -			      "cli \n\t"
> -			      "stgi"
> -			      : // inputs clobbered by the guest:
> -				"=D" (the_test),            // first argument register
> -				"=b" (the_vmcb)             // callee save register!
> -			      : [test] "0" (the_test),
> -				[vmcb_phys] "1"(the_vmcb),
> -				[PREPARE_GIF_CLEAR] "i" (offsetof(struct svm_test, prepare_gif_clear))
> -			      : "rax", "rcx", "rdx", "rsi",
> -				"r8", "r9", "r10", "r11" , "r12", "r13", "r14", "r15",
> -				"memory");
> +
> +		clgi();
> +		sti();
> +
> +		test->prepare_gif_clear(test);
> +
> +		__SVM_VMRUN(vmcb, &regs, "vmrun_rip");
> +
> +		cli();
> +		stgi();
> +
>  		++test->exits;
>  	} while (!test->finished(test));
>  	sti();
> diff --git a/x86/svm.h b/x86/svm.h
> index a4aabeb2..6f809ce3 100644
> --- a/x86/svm.h
> +++ b/x86/svm.h
> @@ -23,26 +23,6 @@ struct svm_test {
>  	bool on_vcpu_done;
>  };
>  
> -struct regs {
> -	u64 rax;
> -	u64 rbx;
> -	u64 rcx;
> -	u64 rdx;
> -	u64 cr2;
> -	u64 rbp;
> -	u64 rsi;
> -	u64 rdi;
> -	u64 r8;
> -	u64 r9;
> -	u64 r10;
> -	u64 r11;
> -	u64 r12;
> -	u64 r13;
> -	u64 r14;
> -	u64 r15;
> -	u64 rflags;
> -};
> -
>  typedef void (*test_guest_func)(struct svm_test *);
>  
>  int run_svm_tests(int ac, char **av, struct svm_test *svm_tests);
> @@ -55,58 +35,12 @@ bool default_finished(struct svm_test *test);
>  int get_test_stage(struct svm_test *test);
>  void set_test_stage(struct svm_test *test, int s);
>  void inc_test_stage(struct svm_test *test);
> -struct regs get_regs(void);
> +struct svm_gprs *get_regs(void);
>  int __svm_vmrun(u64 rip);
>  void __svm_bare_vmrun(void);
>  int svm_vmrun(void);
>  void test_set_guest(test_guest_func func);
>  
>  extern struct vmcb *vmcb;
> -
> -
> -#define SAVE_GPR_C                              \
> -        "xchg %%rbx, regs+0x8\n\t"              \
> -        "xchg %%rcx, regs+0x10\n\t"             \
> -        "xchg %%rdx, regs+0x18\n\t"             \
> -        "xchg %%rbp, regs+0x28\n\t"             \
> -        "xchg %%rsi, regs+0x30\n\t"             \
> -        "xchg %%rdi, regs+0x38\n\t"             \
> -        "xchg %%r8, regs+0x40\n\t"              \
> -        "xchg %%r9, regs+0x48\n\t"              \
> -        "xchg %%r10, regs+0x50\n\t"             \
> -        "xchg %%r11, regs+0x58\n\t"             \
> -        "xchg %%r12, regs+0x60\n\t"             \
> -        "xchg %%r13, regs+0x68\n\t"             \
> -        "xchg %%r14, regs+0x70\n\t"             \
> -        "xchg %%r15, regs+0x78\n\t"
> -
> -#define LOAD_GPR_C      SAVE_GPR_C
> -
> -#define ASM_PRE_VMRUN_CMD                       \
> -                "vmload %%rax\n\t"              \
> -                "mov regs+0x80, %%r15\n\t"      \
> -                "mov %%r15, 0x170(%%rax)\n\t"   \
> -                "mov regs, %%r15\n\t"           \
> -                "mov %%r15, 0x1f8(%%rax)\n\t"   \
> -                LOAD_GPR_C                      \
> -
> -#define ASM_POST_VMRUN_CMD                      \
> -                SAVE_GPR_C                      \
> -                "mov 0x170(%%rax), %%r15\n\t"   \
> -                "mov %%r15, regs+0x80\n\t"      \
> -                "mov 0x1f8(%%rax), %%r15\n\t"   \
> -                "mov %%r15, regs\n\t"           \
> -                "vmsave %%rax\n\t"              \
> -
> -
> -
> -#define SVM_BARE_VMRUN \
> -	asm volatile ( \
> -		ASM_PRE_VMRUN_CMD \
> -                "vmrun %%rax\n\t"               \
> -		ASM_POST_VMRUN_CMD \
> -		: \
> -		: "a" (virt_to_phys(vmcb)) \
> -		: "memory", "r15") \
> -
> +extern struct svm_test svm_tests[];

svm_tests[] has nothing to do with the patch here, and it's probably
also useless? I see it is being deleted in patch 23...

>  #endif
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index 712d24e2..70e41300 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -399,7 +399,7 @@ static bool msr_intercept_finished(struct svm_test *test)
>  		 * RCX holds the MSR index.
>  		 */
>  		printf("%s 0x%lx #GP exception\n",
> -		       exit_info_1 ? "WRMSR" : "RDMSR", get_regs().rcx);
> +		       exit_info_1 ? "WRMSR" : "RDMSR", get_regs()->rcx);
>  	}
>  
>  	/* Jump over RDMSR/WRMSR instruction */
> @@ -415,9 +415,9 @@ static bool msr_intercept_finished(struct svm_test *test)
>  	 */
>  	if (exit_info_1)
>  		test->scratch =
> -			((get_regs().rdx << 32) | (vmcb->save.rax & 0xffffffff));
> +			((get_regs()->rdx << 32) | (get_regs()->rax & 0xffffffff));
>  	else
> -		test->scratch = get_regs().rcx;
> +		test->scratch = get_regs()->rcx;
>  
>  	return false;
>  }
> @@ -1842,7 +1842,7 @@ static volatile bool host_rflags_set_tf = false;
>  static volatile bool host_rflags_set_rf = false;
>  static u64 rip_detected;
>  
> -extern u64 *vmrun_rip;
> +extern u64 vmrun_rip;
>  
>  static void host_rflags_db_handler(struct ex_regs *r)
>  {
> @@ -2878,6 +2878,8 @@ static void svm_lbrv_test0(void)
>  
>  static void svm_lbrv_test1(void)
>  {
> +	struct svm_gprs *regs = get_regs();
> +
>  	report(true, "Test that without LBRV enabled, guest LBR state does 'leak' to the host(1)");
>  
>  	vmcb->save.rip = (ulong)svm_lbrv_test_guest1;
> @@ -2885,7 +2887,7 @@ static void svm_lbrv_test1(void)
>  
>  	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
>  	DO_BRANCH(host_branch1);
> -	SVM_BARE_VMRUN;
> +	SVM_VMRUN(vmcb, regs);
>  	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
>  
>  	if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
> @@ -2900,6 +2902,8 @@ static void svm_lbrv_test1(void)
>  
>  static void svm_lbrv_test2(void)
>  {
> +	struct svm_gprs *regs = get_regs();
> +
>  	report(true, "Test that without LBRV enabled, guest LBR state does 'leak' to the host(2)");
>  
>  	vmcb->save.rip = (ulong)svm_lbrv_test_guest2;
> @@ -2908,7 +2912,7 @@ static void svm_lbrv_test2(void)
>  	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
>  	DO_BRANCH(host_branch2);
>  	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
> -	SVM_BARE_VMRUN;
> +	SVM_VMRUN(vmcb, regs);
>  	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
>  	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
>  
> @@ -2924,6 +2928,8 @@ static void svm_lbrv_test2(void)
>  
>  static void svm_lbrv_nested_test1(void)
>  {
> +	struct svm_gprs *regs = get_regs();
> +
>  	if (!lbrv_supported()) {
>  		report_skip("LBRV not supported in the guest");
>  		return;
> @@ -2936,7 +2942,7 @@ static void svm_lbrv_nested_test1(void)
>  
>  	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
>  	DO_BRANCH(host_branch3);
> -	SVM_BARE_VMRUN;
> +	SVM_VMRUN(vmcb, regs);
>  	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
>  	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
>  
> @@ -2957,6 +2963,8 @@ static void svm_lbrv_nested_test1(void)
>  
>  static void svm_lbrv_nested_test2(void)
>  {
> +	struct svm_gprs *regs = get_regs();
> +
>  	if (!lbrv_supported()) {
>  		report_skip("LBRV not supported in the guest");
>  		return;
> @@ -2972,7 +2980,7 @@ static void svm_lbrv_nested_test2(void)
>  
>  	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
>  	DO_BRANCH(host_branch4);
> -	SVM_BARE_VMRUN;
> +	SVM_VMRUN(vmcb, regs);
>  	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
>  	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
>  
> 

