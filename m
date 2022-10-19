Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFC56052E7
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 00:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbiJSWT3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 18:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbiJSWT0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 18:19:26 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 873AB1088
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 15:19:22 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id z20so18546286plb.10
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 15:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=z4YnSEPLti5++1d+/gxvsHMlivYPnWvSShn2YRgOKDQ=;
        b=bgXvbpNck6JaVV+ruo1CFDxdJ7YsYPAD1ymB7Tqr6h2QPBc718SyOrorombXW5IUsH
         xIBydOXVYYgCtN/o1DfwN57WsmDx0gZ1BvrhW4SJos9tl7O8oXf8d+Lf+JMT5GyLaAwP
         T4q3oGEHY8d7kLecabPsnIElNYkRuBgap+u49+zBR05R3jz15Ed5iY3Nu2xs66s4NzDi
         3I1KAhOTc80G0XAW2e8Xnst0JhBRHvwk7rHv32QCpP5x+YCK2u9CuURcW9b1jaiVGh3/
         Esbo1Ta/Fcy6HG1MYPY3J+UD6eviKmmLvF2luSbWaUqD4dehRlrmMUYnDQz3WbbUWe6f
         W11Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z4YnSEPLti5++1d+/gxvsHMlivYPnWvSShn2YRgOKDQ=;
        b=nnznD6heIDmkd0D8staFYzm5b/mg94N6+xLvV78aFrA43Q7bFGROIImKaFZtU5LhoU
         IDaCSCWSc7COs38QV4ZPIY5kBXjqDEeP37am6YPml9Cqt8GFwT55ZLrRZzn/IHpHJuj0
         CNpGDgdHo9SCLRQ7jZ4GjI37SzDmVfwwT2MpQJP53txXlvGHDt7QPkwASITuVTI5GKal
         egRwP+I7T6ga9PMXPxwhd9j1KmKoNL9GHzce22QfYhPicCdzThjFkbxDbyzUPOoqLUPb
         YiCNSHJibpto1DDB2qoNMaeNsyDmVdOjw/jwlWtA/TTXorxv/Bnry2Br0OZcrytFrCiU
         eoFQ==
X-Gm-Message-State: ACrzQf24WnTs4ojFo6th28moW4hBw+AJldx2/z6Gs9WV1weLXb9KRY+k
        w8fgTKCTf+7rgZmQ1Ix3ZZnCwcgFuLCdcw==
X-Google-Smtp-Source: AMsMyM4wOGZ6Mzbvx+vtNxRRKJcvtr2w2MQf3Xv/TVwQqz9YK42hyOCsSWd9A7ktbshogZ+wXWYy/Q==
X-Received: by 2002:a17:90b:4c42:b0:20d:7820:2e4e with SMTP id np2-20020a17090b4c4200b0020d78202e4emr47808393pjb.40.1666217961925;
        Wed, 19 Oct 2022 15:19:21 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x7-20020a170902a38700b0017e93c158d7sm11141360pla.214.2022.10.19.15.19.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 15:19:21 -0700 (PDT)
Date:   Wed, 19 Oct 2022 22:19:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 44/46] KVM: selftests: evmcs_test: Introduce L2 TLB
 flush test
Message-ID: <Y1B35gupSqXAvAOZ@google.com>
References: <20221004123956.188909-1-vkuznets@redhat.com>
 <20221004123956.188909-45-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221004123956.188909-45-vkuznets@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 04, 2022, Vitaly Kuznetsov wrote:
> @@ -64,15 +67,33 @@ void l2_guest_code(void)
>  	vmcall();
>  	rdmsr_gs_base(); /* intercepted */
>  
> +	/* L2 TLB flush tests */
> +	hyperv_hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE | HV_HYPERCALL_FAST_BIT, 0x0,
> +			   HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES | HV_FLUSH_ALL_PROCESSORS);

Alignment is funky.

> +	rdmsr_fs_base();
> +	/*
> +	 * Note: hypercall status (RAX) is not preserved correctly by L1 after
> +	 * synthetic vmexit, use unchecked version.

Nice...

> +	 */
> +	__hyperv_hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE | HV_HYPERCALL_FAST_BIT, 0x0,
> +			   HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES | HV_FLUSH_ALL_PROCESSORS,
> +			   &unused);
> +	/* Make sure we're no issuing Hyper-V TLB flush call again */
> +	__asm__ __volatile__ ("mov $0xdeadbeef, %rcx");
> +
>  	/* Done, exit to L1 and never come back.  */
>  	vmcall();
>  }
>  
> -void guest_code(struct vmx_pages *vmx_pages, struct hyperv_test_pages *hv_pages)
> +void guest_code(struct vmx_pages *vmx_pages, struct hyperv_test_pages *hv_pages,
> +		vm_vaddr_t hv_hcall_page_gpa)
>  {
>  #define L2_GUEST_STACK_SIZE 64
>  	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
>  
> +	wrmsr(HV_X64_MSR_GUEST_OS_ID, HYPERV_LINUX_OS_ID);
> +	wrmsr(HV_X64_MSR_HYPERCALL, hv_hcall_page_gpa);
> +
>  	x2apic_enable();
>  
>  	GUEST_SYNC(1);
> @@ -102,6 +123,14 @@ void guest_code(struct vmx_pages *vmx_pages, struct hyperv_test_pages *hv_pages)
>  	vmwrite(PIN_BASED_VM_EXEC_CONTROL, vmreadz(PIN_BASED_VM_EXEC_CONTROL) |
>  		PIN_BASED_NMI_EXITING);
>  
> +	/* L2 TLB flush setup */
> +	current_evmcs->partition_assist_page = hv_pages->partition_assist_gpa;
> +	current_evmcs->hv_enlightenments_control.nested_flush_hypercall = 1;
> +	current_evmcs->hv_vm_id = 1;
> +	current_evmcs->hv_vp_id = 1;
> +	current_vp_assist->nested_control.features.directhypercall = 1;
> +	*(u32 *)(hv_pages->partition_assist) = 0;
> +
>  	GUEST_ASSERT(!vmlaunch());

Pre-existing code, but would it make sense to add an assert here to verify L2
exited due to an NMI?  Feel free to ignore this for now if it's not straightforward,
this series is plenty big :-)
