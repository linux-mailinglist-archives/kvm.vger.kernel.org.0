Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 208F96403AF
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 10:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232734AbiLBJqs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 04:46:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231929AbiLBJqq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 04:46:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F49CBA47
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 01:45:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669974328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vs/GvINaqleT42xK+sAHMR44kcNAbF8iVklCs9j6Pp8=;
        b=LA2ndothNehkHbXYGS7OrQSN6jOc4juWD2FYHd71B6763lzxtTddXQbZsjqCbJ39RWJmvX
        /HmMZEPP+MsVtntLtEVxAQtYxhhZbfFnUp32hGBvTANCq3PEtUTLVqOTz+/G2KtI7e9Fmk
        Iu1l5rEHs9n65SYa5tl1g6pT99BZtts=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-32-7z8_SGoDPj2gN50SriCMCw-1; Fri, 02 Dec 2022 04:45:26 -0500
X-MC-Unique: 7z8_SGoDPj2gN50SriCMCw-1
Received: by mail-wm1-f69.google.com with SMTP id o5-20020a05600c510500b003cfca1a327fso2241060wms.8
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 01:45:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vs/GvINaqleT42xK+sAHMR44kcNAbF8iVklCs9j6Pp8=;
        b=j0pHZkBIGgeZ7Dv8iGrULaV6yAgqJSADDMxGpa+7Gm3ZVxCqBjJFgrrt8qeXqdd23u
         2ZxlO3GmN0kn/L58Ucrs7W12r1S8EJ0IyJhHKzs0y1bOyt1p5RJT2lQFriJC5B2mBnny
         5U2s1OKrjUw9IsXNCf3dGB9eYqx1jxePeHW/ivKbfKfBzEgiFvLgBzS2VHlcl713s6ae
         /ncsQIjm1+vKM+6ZN8dQmdiXWi2vnkThbwWttmArLQuszsrj8eXBzejv4hiUd9aV6lld
         2he6pJKnyNnTMRXfk+bKq8SCeEH3zvieOllTil6nfba7atmyrpbFIG/D86y7LRw7gy7a
         a7zg==
X-Gm-Message-State: ANoB5pmKqKoD2tpS5cAHx0h8LJyEzKA4c4Ve3U7ygxDdf4pwnE0534uq
        ieapscopITwXDhYb7OqcNphZkqJjVQduFBCdwo/gyuhFOHmToAiR5FyAjnnk+LvLqFtwihoMRAX
        Xjk3SARqu4MZ9
X-Received: by 2002:a05:600c:538d:b0:3d0:47c:b2ac with SMTP id hg13-20020a05600c538d00b003d0047cb2acmr38308049wmb.52.1669974325818;
        Fri, 02 Dec 2022 01:45:25 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5kctKjCa7kg5FrD9r1VB9W9ShrkqeJE8B4eUyPfRKAGtZI4OjGAwmNFlcAtfcBS6EtmfMQPg==
X-Received: by 2002:a05:600c:538d:b0:3d0:47c:b2ac with SMTP id hg13-20020a05600c538d00b003d0047cb2acmr38308035wmb.52.1669974325582;
        Fri, 02 Dec 2022 01:45:25 -0800 (PST)
Received: from [192.168.149.123] (58.254.164.109.static.wline.lns.sme.cust.swisscom.ch. [109.164.254.58])
        by smtp.gmail.com with ESMTPSA id n187-20020a1ca4c4000000b003d005aab31asm8268154wme.40.2022.12.02.01.45.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 01:45:23 -0800 (PST)
Message-ID: <297e66f8-3e6d-bcd4-2ce4-aeb25f6cb699@redhat.com>
Date:   Fri, 2 Dec 2022 10:45:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH v3 21/27] svm: cleanup the default_prepare
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
 <20221122161152.293072-22-mlevitsk@redhat.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
In-Reply-To: <20221122161152.293072-22-mlevitsk@redhat.com>
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
> default_prepare only calls vmcb_indent, which is called before
> each test anyway
> 
> Also don't call this now empty function from other
> .prepare functions
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  x86/svm.c       |  1 -
>  x86/svm_tests.c | 18 ------------------
>  2 files changed, 19 deletions(-)
> 
> diff --git a/x86/svm.c b/x86/svm.c
> index 2ab553a5..5667402b 100644
> --- a/x86/svm.c
> +++ b/x86/svm.c
> @@ -30,7 +30,6 @@ bool default_supported(void)
>  
>  void default_prepare(struct svm_test *test)
>  {
> -	vmcb_ident(vmcb);
>  }

Makes sense removing it, but maybe remove the function alltogether since
it is not used anymore and then change test_run() to handle ->prepare ==
NULL?

>  
>  void default_prepare_gif_clear(struct svm_test *test)
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index 70e41300..3b68718e 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -69,7 +69,6 @@ static bool check_vmrun(struct svm_test *test)
>  
>  static void prepare_rsm_intercept(struct svm_test *test)
>  {
> -	default_prepare(test);
>  	vmcb->control.intercept |= 1 << INTERCEPT_RSM;
>  	vmcb->control.intercept_exceptions |= (1ULL << UD_VECTOR);
>  }
> @@ -115,7 +114,6 @@ static bool finished_rsm_intercept(struct svm_test *test)
>  
>  static void prepare_cr3_intercept(struct svm_test *test)
>  {
> -	default_prepare(test);
>  	vmcb->control.intercept_cr_read |= 1 << 3;
>  }
>  
> @@ -149,7 +147,6 @@ static void corrupt_cr3_intercept_bypass(void *_test)
>  
>  static void prepare_cr3_intercept_bypass(struct svm_test *test)
>  {
> -	default_prepare(test);
>  	vmcb->control.intercept_cr_read |= 1 << 3;
>  	on_cpu_async(1, corrupt_cr3_intercept_bypass, test);
>  }
> @@ -169,7 +166,6 @@ static void test_cr3_intercept_bypass(struct svm_test *test)
>  
>  static void prepare_dr_intercept(struct svm_test *test)
>  {
> -	default_prepare(test);
>  	vmcb->control.intercept_dr_read = 0xff;
>  	vmcb->control.intercept_dr_write = 0xff;
>  }
> @@ -310,7 +306,6 @@ static bool check_next_rip(struct svm_test *test)
>  
>  static void prepare_msr_intercept(struct svm_test *test)
>  {
> -	default_prepare(test);
>  	vmcb->control.intercept |= (1ULL << INTERCEPT_MSR_PROT);
>  	vmcb->control.intercept_exceptions |= (1ULL << GP_VECTOR);
>  	memset(svm_get_msr_bitmap(), 0xff, MSR_BITMAP_SIZE);
> @@ -711,7 +706,6 @@ static bool tsc_adjust_supported(void)
>  
>  static void tsc_adjust_prepare(struct svm_test *test)
>  {
> -	default_prepare(test);
>  	vmcb->control.tsc_offset = TSC_OFFSET_VALUE;
>  
>  	wrmsr(MSR_IA32_TSC_ADJUST, -TSC_ADJUST_VALUE);
> @@ -811,7 +805,6 @@ static void svm_tsc_scale_test(void)
>  
>  static void latency_prepare(struct svm_test *test)
>  {
> -	default_prepare(test);
>  	runs = LATENCY_RUNS;
>  	latvmrun_min = latvmexit_min = -1ULL;
>  	latvmrun_max = latvmexit_max = 0;
> @@ -884,7 +877,6 @@ static bool latency_check(struct svm_test *test)
>  
>  static void lat_svm_insn_prepare(struct svm_test *test)
>  {
> -	default_prepare(test);
>  	runs = LATENCY_RUNS;
>  	latvmload_min = latvmsave_min = latstgi_min = latclgi_min = -1ULL;
>  	latvmload_max = latvmsave_max = latstgi_max = latclgi_max = 0;
> @@ -965,7 +957,6 @@ static void pending_event_prepare(struct svm_test *test)
>  {
>  	int ipi_vector = 0xf1;
>  
> -	default_prepare(test);
>  
>  	pending_event_ipi_fired = false;
>  
> @@ -1033,8 +1024,6 @@ static bool pending_event_check(struct svm_test *test)
>  
>  static void pending_event_cli_prepare(struct svm_test *test)
>  {
> -	default_prepare(test);
> -
>  	pending_event_ipi_fired = false;
>  
>  	handle_irq(0xf1, pending_event_ipi_isr);
> @@ -1139,7 +1128,6 @@ static void timer_isr(isr_regs_t *regs)
>  
>  static void interrupt_prepare(struct svm_test *test)
>  {
> -	default_prepare(test);
>  	handle_irq(TIMER_VECTOR, timer_isr);
>  	timer_fired = false;
>  	set_test_stage(test, 0);
> @@ -1272,7 +1260,6 @@ static void nmi_handler(struct ex_regs *regs)
>  
>  static void nmi_prepare(struct svm_test *test)
>  {
> -	default_prepare(test);
>  	nmi_fired = false;
>  	handle_exception(NMI_VECTOR, nmi_handler);
>  	set_test_stage(test, 0);
> @@ -1450,7 +1437,6 @@ static void my_isr(struct ex_regs *r)
>  
>  static void exc_inject_prepare(struct svm_test *test)
>  {
> -	default_prepare(test);
>  	handle_exception(DE_VECTOR, my_isr);
>  	handle_exception(NMI_VECTOR, my_isr);
>  }
> @@ -1519,7 +1505,6 @@ static void virq_isr(isr_regs_t *regs)
>  static void virq_inject_prepare(struct svm_test *test)
>  {
>  	handle_irq(0xf1, virq_isr);
> -	default_prepare(test);
>  	vmcb->control.int_ctl = V_INTR_MASKING_MASK | V_IRQ_MASK |
>  		(0x0f << V_INTR_PRIO_SHIFT); // Set to the highest priority
>  	vmcb->control.int_vector = 0xf1;
> @@ -1682,7 +1667,6 @@ static void reg_corruption_isr(isr_regs_t *regs)
>  
>  static void reg_corruption_prepare(struct svm_test *test)
>  {
> -	default_prepare(test);
>  	set_test_stage(test, 0);
>  
>  	vmcb->control.int_ctl = V_INTR_MASKING_MASK;
> @@ -1877,7 +1861,6 @@ static void host_rflags_db_handler(struct ex_regs *r)
>  
>  static void host_rflags_prepare(struct svm_test *test)
>  {
> -	default_prepare(test);
>  	handle_exception(DB_VECTOR, host_rflags_db_handler);
>  	set_test_stage(test, 0);
>  }
> @@ -2610,7 +2593,6 @@ static void svm_vmload_vmsave(void)
>  
>  static void prepare_vgif_enabled(struct svm_test *test)
>  {
> -	default_prepare(test);
>  }
>  
>  static void test_vgif(struct svm_test *test)
> 

