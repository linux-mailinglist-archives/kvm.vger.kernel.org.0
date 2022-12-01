Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB8063F519
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 17:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbiLAQTO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 11:19:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231612AbiLAQTM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 11:19:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9382962C8
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 08:18:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669911488;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ATAnPxZw9JrB6ZgKswURduyMrxlrAsIHm3XfHfJxwEY=;
        b=gGzmr2WqfXYjNX/O3OdTg6w91zf15qWhpiERFYzxAWCDmT3Ylj4pvloaRLaBv0oUW+2j8+
        o/hcWf7Wqh3yWH0ubHEEdHnl1Itba74CwB8GepTk2O2bw/AJfl7GfljXglZUh535rbYjg9
        nbLJDEdTBPkW0OypXodtL6ZuZh3v4WM=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-73-LRWb653APbeMJgXaJsv3og-1; Thu, 01 Dec 2022 11:18:07 -0500
X-MC-Unique: LRWb653APbeMJgXaJsv3og-1
Received: by mail-qv1-f72.google.com with SMTP id nk7-20020a056214350700b004c68c912c93so5762392qvb.16
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 08:18:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ATAnPxZw9JrB6ZgKswURduyMrxlrAsIHm3XfHfJxwEY=;
        b=BfXCdNFXdv/UIDhYkPjP9FV9mZnYm0dX9MinIa9lDeunllz3hATN1Y4HKgtiqSr+eu
         whV80DgIYMYT1Vx6do32YiTHS5sz89C37qiHhjXLvEMaj0iyZnQsR+o5vCop2v3xZyGd
         Oep10OHS8GSV7JqrNkMxJdiphQsbDOZE0iSy3RHjHYzgBE9M/V/v37ycfygxJaO7GpVt
         FQIds8ZvQga/CxgDqIQrsFBDFgz6vzr9G4W45yfM097Sq/jM2sgOZa9fFBVV5MkvwxGI
         +cUmxsEj87xfpRmmT3gq8GXXKx9zPI2Fk8OkuEYqs02eeHPmx9rIDPZp7gGkNBwDdZre
         J8bQ==
X-Gm-Message-State: ANoB5pkD/nkHdDER3dGF9XKb6P2uyIiIgSD6P/E3KXW/fkv64f09Ptlr
        Dj2kfr0jws6FfTp7VD4WqgCvHHNUI799kcOhLjoABV5JEDyt/PbN1QDp0WpFg4HX4DorKc3uxKk
        krVdHqT0bvIMW
X-Received: by 2002:a05:6214:2e09:b0:4bc:9d7f:d963 with SMTP id mx9-20020a0562142e0900b004bc9d7fd963mr45879003qvb.83.1669911487039;
        Thu, 01 Dec 2022 08:18:07 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7YysZg93criKt96dbmtJUFZorZjn3FnL/d0hBUQO11xahxpMLF844ZsXGqpbByT7HlKD2VIw==
X-Received: by 2002:a05:6214:2e09:b0:4bc:9d7f:d963 with SMTP id mx9-20020a0562142e0900b004bc9d7fd963mr45878975qvb.83.1669911486764;
        Thu, 01 Dec 2022 08:18:06 -0800 (PST)
Received: from [192.168.149.123] (58.254.164.109.static.wline.lns.sme.cust.swisscom.ch. [109.164.254.58])
        by smtp.gmail.com with ESMTPSA id y17-20020a05620a25d100b006e54251993esm3672718qko.97.2022.12.01.08.18.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 08:18:06 -0800 (PST)
Message-ID: <08c7eca0-b828-b1bd-b85c-babfc758c8a2@redhat.com>
Date:   Thu, 1 Dec 2022 17:18:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH v3 18/27] svm: move vmcb_ident to svm_lib.c
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
 <20221122161152.293072-19-mlevitsk@redhat.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
In-Reply-To: <20221122161152.293072-19-mlevitsk@redhat.com>
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
> Extract vmcb_ident to svm_lib.c
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>

Not sure if it holds for kvm unit tests, but indent of vmcb_set_seg
parameters seems a little bit off.

If that's fine:
Reviewed-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>

> ---
>  lib/x86/svm_lib.c | 54 +++++++++++++++++++++++++++++++++++++++++++++++
>  lib/x86/svm_lib.h |  4 ++++
>  x86/svm.c         | 54 -----------------------------------------------
>  x86/svm.h         |  1 -
>  4 files changed, 58 insertions(+), 55 deletions(-)
> 
> diff --git a/lib/x86/svm_lib.c b/lib/x86/svm_lib.c
> index c7194909..aed757a1 100644
> --- a/lib/x86/svm_lib.c
> +++ b/lib/x86/svm_lib.c
> @@ -109,3 +109,57 @@ bool setup_svm(void)
>  	setup_npt();
>  	return true;
>  }
> +
> +void vmcb_set_seg(struct vmcb_seg *seg, u16 selector,
> +			 u64 base, u32 limit, u32 attr)
> +{
> +	seg->selector = selector;
> +	seg->attrib = attr;
> +	seg->limit = limit;
> +	seg->base = base;
> +}
> +
> +void vmcb_ident(struct vmcb *vmcb)
> +{
> +	u64 vmcb_phys = virt_to_phys(vmcb);
> +	struct vmcb_save_area *save = &vmcb->save;
> +	struct vmcb_control_area *ctrl = &vmcb->control;
> +	u32 data_seg_attr = 3 | SVM_SELECTOR_S_MASK | SVM_SELECTOR_P_MASK
> +		| SVM_SELECTOR_DB_MASK | SVM_SELECTOR_G_MASK;
> +	u32 code_seg_attr = 9 | SVM_SELECTOR_S_MASK | SVM_SELECTOR_P_MASK
> +		| SVM_SELECTOR_L_MASK | SVM_SELECTOR_G_MASK;
> +	struct descriptor_table_ptr desc_table_ptr;
> +
> +	memset(vmcb, 0, sizeof(*vmcb));
> +	asm volatile ("vmsave %0" : : "a"(vmcb_phys) : "memory");
> +	vmcb_set_seg(&save->es, read_es(), 0, -1U, data_seg_attr);
> +	vmcb_set_seg(&save->cs, read_cs(), 0, -1U, code_seg_attr);
> +	vmcb_set_seg(&save->ss, read_ss(), 0, -1U, data_seg_attr);
> +	vmcb_set_seg(&save->ds, read_ds(), 0, -1U, data_seg_attr);
> +	sgdt(&desc_table_ptr);
> +	vmcb_set_seg(&save->gdtr, 0, desc_table_ptr.base, desc_table_ptr.limit, 0);
> +	sidt(&desc_table_ptr);
> +	vmcb_set_seg(&save->idtr, 0, desc_table_ptr.base, desc_table_ptr.limit, 0);
> +	ctrl->asid = 1;
> +	save->cpl = 0;
> +	save->efer = rdmsr(MSR_EFER);
> +	save->cr4 = read_cr4();
> +	save->cr3 = read_cr3();
> +	save->cr0 = read_cr0();
> +	save->dr7 = read_dr7();
> +	save->dr6 = read_dr6();
> +	save->cr2 = read_cr2();
> +	save->g_pat = rdmsr(MSR_IA32_CR_PAT);
> +	save->dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
> +	ctrl->intercept = (1ULL << INTERCEPT_VMRUN) |
> +		(1ULL << INTERCEPT_VMMCALL) |
> +		(1ULL << INTERCEPT_SHUTDOWN);
> +	ctrl->iopm_base_pa = virt_to_phys(io_bitmap);
> +	ctrl->msrpm_base_pa = virt_to_phys(msr_bitmap);
> +
> +	if (npt_supported()) {
> +		ctrl->nested_ctl = 1;
> +		ctrl->nested_cr3 = (u64)pml4e;
> +		ctrl->tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;
> +	}
> +}
> diff --git a/lib/x86/svm_lib.h b/lib/x86/svm_lib.h
> index f603ff93..3bb098dc 100644
> --- a/lib/x86/svm_lib.h
> +++ b/lib/x86/svm_lib.h
> @@ -49,7 +49,11 @@ static inline void clgi(void)
>  	asm volatile ("clgi");
>  }
>  
> +void vmcb_set_seg(struct vmcb_seg *seg, u16 selector,
> +				  u64 base, u32 limit, u32 attr);
> +
>  bool setup_svm(void);
> +void vmcb_ident(struct vmcb *vmcb);
>  
>  u64 *npt_get_pte(u64 address);
>  u64 *npt_get_pde(u64 address);
> diff --git a/x86/svm.c b/x86/svm.c
> index cf246c37..5e2c3a83 100644
> --- a/x86/svm.c
> +++ b/x86/svm.c
> @@ -63,15 +63,6 @@ void inc_test_stage(struct svm_test *test)
>  	barrier();
>  }
>  
> -static void vmcb_set_seg(struct vmcb_seg *seg, u16 selector,
> -			 u64 base, u32 limit, u32 attr)
> -{
> -	seg->selector = selector;
> -	seg->attrib = attr;
> -	seg->limit = limit;
> -	seg->base = base;
> -}
> -
>  static test_guest_func guest_main;
>  
>  void test_set_guest(test_guest_func func)
> @@ -85,51 +76,6 @@ static void test_thunk(struct svm_test *test)
>  	vmmcall();
>  }
>  
> -void vmcb_ident(struct vmcb *vmcb)
> -{
> -	u64 vmcb_phys = virt_to_phys(vmcb);
> -	struct vmcb_save_area *save = &vmcb->save;
> -	struct vmcb_control_area *ctrl = &vmcb->control;
> -	u32 data_seg_attr = 3 | SVM_SELECTOR_S_MASK | SVM_SELECTOR_P_MASK
> -		| SVM_SELECTOR_DB_MASK | SVM_SELECTOR_G_MASK;
> -	u32 code_seg_attr = 9 | SVM_SELECTOR_S_MASK | SVM_SELECTOR_P_MASK
> -		| SVM_SELECTOR_L_MASK | SVM_SELECTOR_G_MASK;
> -	struct descriptor_table_ptr desc_table_ptr;
> -
> -	memset(vmcb, 0, sizeof(*vmcb));
> -	asm volatile ("vmsave %0" : : "a"(vmcb_phys) : "memory");
> -	vmcb_set_seg(&save->es, read_es(), 0, -1U, data_seg_attr);
> -	vmcb_set_seg(&save->cs, read_cs(), 0, -1U, code_seg_attr);
> -	vmcb_set_seg(&save->ss, read_ss(), 0, -1U, data_seg_attr);
> -	vmcb_set_seg(&save->ds, read_ds(), 0, -1U, data_seg_attr);
> -	sgdt(&desc_table_ptr);
> -	vmcb_set_seg(&save->gdtr, 0, desc_table_ptr.base, desc_table_ptr.limit, 0);
> -	sidt(&desc_table_ptr);
> -	vmcb_set_seg(&save->idtr, 0, desc_table_ptr.base, desc_table_ptr.limit, 0);
> -	ctrl->asid = 1;
> -	save->cpl = 0;
> -	save->efer = rdmsr(MSR_EFER);
> -	save->cr4 = read_cr4();
> -	save->cr3 = read_cr3();
> -	save->cr0 = read_cr0();
> -	save->dr7 = read_dr7();
> -	save->dr6 = read_dr6();
> -	save->cr2 = read_cr2();
> -	save->g_pat = rdmsr(MSR_IA32_CR_PAT);
> -	save->dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
> -	ctrl->intercept = (1ULL << INTERCEPT_VMRUN) |
> -		(1ULL << INTERCEPT_VMMCALL) |
> -		(1ULL << INTERCEPT_SHUTDOWN);
> -	ctrl->iopm_base_pa = virt_to_phys(svm_get_io_bitmap());
> -	ctrl->msrpm_base_pa = virt_to_phys(svm_get_msr_bitmap());
> -
> -	if (npt_supported()) {
> -		ctrl->nested_ctl = 1;
> -		ctrl->nested_cr3 = (u64)npt_get_pml4e();
> -		ctrl->tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;
> -	}
> -}
> -
>  struct regs regs;
>  
>  struct regs get_regs(void)
> diff --git a/x86/svm.h b/x86/svm.h
> index 67f3205d..a4aabeb2 100644
> --- a/x86/svm.h
> +++ b/x86/svm.h
> @@ -55,7 +55,6 @@ bool default_finished(struct svm_test *test);
>  int get_test_stage(struct svm_test *test);
>  void set_test_stage(struct svm_test *test, int s);
>  void inc_test_stage(struct svm_test *test);
> -void vmcb_ident(struct vmcb *vmcb);
>  struct regs get_regs(void);
>  int __svm_vmrun(u64 rip);
>  void __svm_bare_vmrun(void);
> 

