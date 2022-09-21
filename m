Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12B645E5580
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 23:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbiIUVvb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 17:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbiIUVv1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 17:51:27 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98975A1D13
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 14:51:24 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id rt12so5386108pjb.1
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 14:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=NgbONa/JLrIJmOkn0CBqxCxDowwxjWoWs2Rsui1X0KI=;
        b=FWvucp8C7NSejl3BHBuBIg1NxNS9DZ7c3Jqiurti4tcdCRdol5m+vQG7QltXtbcpzO
         3W8gW2CM5N/6HEp9HPytppWqpt5fBPeCs+S6iBx4sgOwxARDlAap6uU8dwB7mR4Y517/
         FXVYd6oYAFBlRI595Ey9sRfrSmUc4V/5ETJRgnmBaggNifM7/By7p2mz3nFaH6Cx0U+F
         4i0qjMYR2VoMH7ymgzavCcCWQ52bQPD5/gPQhzyrqpv9jI5BPMMtE1pn+vP3+vRGQ7Jr
         hBwB1GqpxY+XzwuwUMUivArA4YEw91XTSZYBHS0hbbZgVbzHMz2fgrLg3bOv1uRCbGbU
         i8Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=NgbONa/JLrIJmOkn0CBqxCxDowwxjWoWs2Rsui1X0KI=;
        b=f1C1Q1q2h/M2jlESABIMHIEUH9ZjmYKU0T8rFfRABSnLVy+4YjbURVJUDoA4Xv6h78
         U9/Hmnx8CpAfOE1bptmzYiGHnRt7oYwrrCQYGJ39eVUiLVZsfBHDgQkvENMr5eTvPEz0
         Unt5aqzj+mfsedU8WXRg1JcIAdRNXj05J5CYu8Y/BuOnfZG10BfhzHVKXPzZ60BZJiUN
         LvcIvBCkYHPza7Qjc1wQixE5w3QCcsvmxQtLJnMz9PFUL6LNAFBuBBPop9kwHArmGxdO
         K4ZnZxCeuoEClznKJsIaePBw1phLl7a28lueLd5oRcGBlcDNn4OfHto/ED4VfWgteYPk
         y3zA==
X-Gm-Message-State: ACrzQf3AfWCAio6D3AAfsObZXBpkSOUZLbT4tisWV2EF3qvwVpx/SxuL
        KyN0+5C3Pw37etnrJUnDUkJ9gg==
X-Google-Smtp-Source: AMsMyM4aIDcK41T2ZRt2R6AWvsRZzPd8M+xtr9rkQdV+bvj+aCThLN/hvruZIVlUapXGsf2BGYbBQQ==
X-Received: by 2002:a17:902:7e42:b0:178:489:86ac with SMTP id a2-20020a1709027e4200b00178048986acmr214779pln.68.1663797084005;
        Wed, 21 Sep 2022 14:51:24 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id j6-20020a17090276c600b001789b724712sm2439580plt.232.2022.09.21.14.51.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 14:51:23 -0700 (PDT)
Date:   Wed, 21 Sep 2022 21:51:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
Subject: Re: [PATCH v10 25/39] KVM: selftests: Move the function doing
 Hyper-V hypercall to a common header
Message-ID: <YyuHWNdZq9/oYTZ+@google.com>
References: <20220921152436.3673454-1-vkuznets@redhat.com>
 <20220921152436.3673454-26-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921152436.3673454-26-vkuznets@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Vipin

On Wed, Sep 21, 2022, Vitaly Kuznetsov wrote:
> All Hyper-V specific tests issuing hypercalls need this.
> 
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  .../selftests/kvm/include/x86_64/hyperv.h      | 16 ++++++++++++++++
>  .../selftests/kvm/x86_64/hyperv_features.c     | 18 +-----------------
>  2 files changed, 17 insertions(+), 17 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/hyperv.h b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> index f0a8a93694b2..285e9ff73573 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> @@ -185,6 +185,22 @@
>  /* hypercall options */
>  #define HV_HYPERCALL_FAST_BIT		BIT(16)
>  
> +static inline uint8_t hyperv_hypercall(u64 control, vm_vaddr_t input_address,
> +				       vm_vaddr_t output_address,
> +				       uint64_t *hv_status)
> +{
> +	uint8_t vector;

Newline after the variable declaration.

> +	/* Note both the hypercall and the "asm safe" clobber r9-r11. */
> +	asm volatile("mov %[output_address], %%r8\n\t"
> +		     KVM_ASM_SAFE("vmcall")
> +		     : "=a" (*hv_status),
> +		       "+c" (control), "+d" (input_address),
> +		       KVM_ASM_SAFE_OUTPUTS(vector)
> +		     : [output_address] "r"(output_address)
> +		     : "cc", "memory", "r8", KVM_ASM_SAFE_CLOBBERS);
> +	return vector;
> +}
> +
>  /* Proper HV_X64_MSR_GUEST_OS_ID value */
>  #define HYPERV_LINUX_OS_ID ((u64)0x8100 << 48)
>  
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> index 1144bd1ea626..c464d324cde0 100644
> --- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> @@ -13,22 +13,6 @@
>  #include "processor.h"
>  #include "hyperv.h"
>  
> -static inline uint8_t hypercall(u64 control, vm_vaddr_t input_address,
> -				vm_vaddr_t output_address, uint64_t *hv_status)
> -{
> -	uint8_t vector;
> -
> -	/* Note both the hypercall and the "asm safe" clobber r9-r11. */
> -	asm volatile("mov %[output_address], %%r8\n\t"
> -		     KVM_ASM_SAFE("vmcall")
> -		     : "=a" (*hv_status),
> -		       "+c" (control), "+d" (input_address),
> -		       KVM_ASM_SAFE_OUTPUTS(vector)
> -		     : [output_address] "r"(output_address)
> -		     : "cc", "memory", "r8", KVM_ASM_SAFE_CLOBBERS);
> -	return vector;
> -}
> -
>  struct msr_data {
>  	uint32_t idx;
>  	bool available;
> @@ -78,7 +62,7 @@ static void guest_hcall(vm_vaddr_t pgs_gpa, struct hcall_data *hcall)
>  		input = output = 0;
>  	}
>  
> -	vector = hypercall(hcall->control, input, output, &res);
> +	vector = hyperv_hypercall(hcall->control, input, output, &res);
>  	if (hcall->ud_expected)
>  		GUEST_ASSERT_2(vector == UD_VECTOR, hcall->control, vector);
>  	else

Just out of sight here, but I broke this code in commit cc5851c6be86 ("KVM: selftests:
Use exception fixup for #UD/#GP Hyper-V MSR/hcall tests").  I got too fancy and
inverted the ud_expected logic when checking the result.  The broken code skips the
check when #UD _not_ expected.

I.e. this

	if (hcall->ud_expected)
		GUEST_ASSERT_2(vector == UD_VECTOR, hcall->control, vector);
	else
		GUEST_ASSERT_2(!vector, hcall->control, vector);

	GUEST_ASSERT_2(!hcall->ud_expected || res == hcall->expect,
			hcall->expect, res);

should be

	if (hcall->ud_expected) {
		GUEST_ASSERT_2(vector == UD_VECTOR, hcall->control, vector);
	} else {
		GUEST_ASSERT_2(!vector, hcall->control, vector);
		GUEST_ASSERT_2(res == hcall->expect, hcall->expect, res);
	}

The reason I bring this up here is because of the reason the test passes: gcc
zeros RAX before the hypercall (not entirely sure why), and so res=0 on #UD due
to nothing changing RAX.  But clang doesn't zero RAX and so the test fails due
to RAX holding garbage (probably '1' from the lower 32 bits of HV_X64_MSR_HYPERCALL).

So, what do you think about explicitly setting hv_status, e.g. to -EFAULT, prior
to the hypercall, both to defend against selftest bugs and to verify that _KVM_
actually zeros the result?

