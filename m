Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5A2A60EB8A
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 00:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233497AbiJZWXd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 18:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233348AbiJZWX2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 18:23:28 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4BEBEB756
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 15:23:25 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id b11so9341064pjp.2
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 15:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MvOHvfFBj5xVXA9sW67Kiy7MMMPQotJvY1ZQTV38d+M=;
        b=Cei9HUh3lDTaZT8LV9ktj6fhyNgljqaT42YFMjJ1E9hcqPhcSWbewNyycqObRSHoKZ
         dFDUql6xZSzDUcLqcpAm3AzeziuDeUTq7/25Mh0OxPp24MmD9BncV5E0lPU011fF1+Zy
         K0s8okCcxL/YAzJU3q3W3i8+7UCgyVWfTrmaC3pD8NIaBj8mdqIYsuH4H+yqzQOqwWoF
         gbSX86AdNQSKr/G3SUIdC8rpVgGjjNNh2y5Ew1JS0vak/G1Yyh6octlLGu9wFddVkmHT
         wVO16ylHoFDiHYXcKhegcvgEjEfGAOEqqtEihlnh+tklyIjsOOCLD3xqN/dMQSvWopX+
         5odA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MvOHvfFBj5xVXA9sW67Kiy7MMMPQotJvY1ZQTV38d+M=;
        b=eAudAjov27MvGT+05OjrMxYjwhCXq4MUluX0Hk0Mzi1eo+yVmFMMwUhxV5S0HuLz2S
         WFy8npclg8hkXynBJT4OVUFvU6+JuJerFxy1RUnglmOpeQyeks0QHWmw23hWEPPS+a93
         EwCxvqrMzgfDXgk8jKfvnZ6xfefH8JIJBiMB7oGcfF405NJpVjO5QT2DFg0VNKTaBwdd
         WAemEtjpLVfNw3BRujvD07qHXfBnsj+XxQdNKf5REAQyLX1NqVPJPQm5cF9MRRKPbUOu
         zbo09cgA3GifrTnmkURy9MJgt0HuojcdAFCzRl9hwtLYdTvCJlKf9qqRncjnCvCAqnh7
         kn2w==
X-Gm-Message-State: ACrzQf0gruyPSClKTpIfpzzAkPVur6WeFwY2ZwH8jLjIo821V/gpGWvP
        oRiEg+1gu6LPhovEVMaJytg02g==
X-Google-Smtp-Source: AMsMyM5DtFempU0b3y4nR0FcfTRtrfOu1iOtXCU3iDtJMBIl2Co6CdH2L56hA2DEUIlLdHNLAW0cOg==
X-Received: by 2002:a17:902:8695:b0:17f:71ed:dac1 with SMTP id g21-20020a170902869500b0017f71eddac1mr46227207plo.127.1666823005140;
        Wed, 26 Oct 2022 15:23:25 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id t18-20020aa79472000000b0056bf5e54961sm3464935pfq.161.2022.10.26.15.23.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 15:23:24 -0700 (PDT)
Date:   Wed, 26 Oct 2022 22:23:21 +0000
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
Subject: Re: [PATCH v12 45/46] KVM: selftests: hyperv_svm_test: Introduce L2
 TLB flush test
Message-ID: <Y1mzWUx0bvv4YJJJ@google.com>
References: <20221021153521.1216911-1-vkuznets@redhat.com>
 <20221021153521.1216911-46-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021153521.1216911-46-vkuznets@redhat.com>
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

On Fri, Oct 21, 2022, Vitaly Kuznetsov wrote:
> Enable Hyper-V L2 TLB flush and check that Hyper-V TLB flush hypercalls
> from L2 don't exit to L1 unless 'TlbLockCount' is set in the Partition
> assist page.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  .../selftests/kvm/include/x86_64/svm.h        |  4 ++
>  .../selftests/kvm/x86_64/hyperv_svm_test.c    | 61 +++++++++++++++++--
>  2 files changed, 60 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/svm.h b/tools/testing/selftests/kvm/include/x86_64/svm.h
> index 483e6ae12f69..4803e1056055 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/svm.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/svm.h
> @@ -76,6 +76,10 @@ struct hv_vmcb_enlightenments {
>   */
>  #define HV_VMCB_NESTED_ENLIGHTENMENTS (1U << 31)
>  
> +/* Synthetic VM-Exit */
> +#define HV_SVM_EXITCODE_ENL			0xf0000000
> +#define HV_SVM_ENL_EXITCODE_TRAP_AFTER_FLUSH	(1)
> +
>  struct __attribute__ ((__packed__)) vmcb_control_area {
>  	u32 intercept_cr;
>  	u32 intercept_dr;
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
> index 1c3fc38b4f15..edb779615a79 100644
> --- a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
> @@ -25,6 +25,8 @@
>  
>  void l2_guest_code(void)
>  {
> +	u64 unused;
> +
>  	GUEST_SYNC(3);
>  	/* Exit to L1 */
>  	vmmcall();
> @@ -38,11 +40,30 @@ void l2_guest_code(void)
>  
>  	GUEST_SYNC(5);
>  
> +	/* L2 TLB flush tests */
> +	hyperv_hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE |
> +			 HV_HYPERCALL_FAST_BIT, 0x0,
> +			 HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES |
> +			 HV_FLUSH_ALL_PROCESSORS);
> +	rdmsr(MSR_FS_BASE);

Why doesn't the SVM test need to clobber GPRs?

> +	/*
> +	 * Note: hypercall status (RAX) is not preserved correctly by L1 after
> +	 * synthetic vmexit, use unchecked version.
> +	 */
> +	__hyperv_hypercall(HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE |
> +			   HV_HYPERCALL_FAST_BIT, 0x0,
> +			   HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES |
> +			   HV_FLUSH_ALL_PROCESSORS, &unused);
> +	/* Make sure we're not issuing Hyper-V TLB flush call again */
> +	__asm__ __volatile__ ("mov $0xdeadbeef, %rcx");

Heh, and a patch to vmmcall() itself "safe"...

> +
>  	/* Done, exit to L1 and never come back.  */
>  	vmmcall();
>  }
