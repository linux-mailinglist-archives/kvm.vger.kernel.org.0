Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C657D5FBB3C
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 21:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbiJKTSh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 15:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiJKTSg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 15:18:36 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F567B2B3
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 12:18:34 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id s206so13631713pgs.3
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 12:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tN++RzycQhI0zOp3/Gpp2COjyDOKXNStECTnSP6UROw=;
        b=IyC7A4pZD44WrZ37I0tOZ64uJmBOj3T0Y6/d8vwNtfoAks/qFvpZ3aqeTRcz0CIYUA
         tVbhNkt+bZ8STsTHo+X99qTpNQeiWf/Fq9tf0E6hb4xsP3X7JEI47VZ4K5JKBiR2Ct4D
         4pC+ttie49WcFkKYXXETNWfwglxIYDq00ShX9Rgwc4sSZjVCjZaR4iM9wjVYZeZhsafT
         sDslrO6ecAGv7q1ESrKhsfj5mw+46uHk/pBArm1Vc8ZgVrWD2oi4TYbjLnyvMEzfsxox
         bE1QwJs5lO8VblHTeCGMbTBSf7IR4XJ42XC1gki7p7imZIAPvXQDutmGZq+sXl9cv8bo
         XGqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tN++RzycQhI0zOp3/Gpp2COjyDOKXNStECTnSP6UROw=;
        b=mMurjLqkVIJIX9rq1BXt9k2MuVGi7fO74v40ZPtwggtddc/xI73FxAIs8U6kJ7/o5q
         nWYxYF7EmyaND4gUZGumrkFKaQknu9IG62ZKS668VWcIAHRtsy03ksNVeKMfZ1vc8FZ0
         2LQ6pKph/akwHSdOkavBbPUhWvYLxtksst/VyHAWIlV9pUKqQrXWoAB2jG5J+9ORWHkS
         riy0YiDOLr2VdEkrlNH6wdy+ZOkjGwVwG8SwMgm1JlDO/7dB/V6ZQkUSMOXuijlDM/62
         /FzGiqKECsTnhPueCsycgqkm/TLOXayfJvOXOMLaCUaNxXsvQtNfXtJ2dbGoL1H4AKSz
         MgDg==
X-Gm-Message-State: ACrzQf0xGP6m6kOuBE23gU5Gviw4W/khP3ACikwpiPM2MSbIrrJfuTbv
        EZSpKe6yFK3DQkkXxE6HYJo7IXEDYilhvw==
X-Google-Smtp-Source: AMsMyM4YQ4sfPYLUzw55FberGjLaMi/YCNqWtb/vNksc4dhyg3jGtswU1Y/i8QjYx5BlqBuD2nxppA==
X-Received: by 2002:a63:f349:0:b0:43a:b82b:1173 with SMTP id t9-20020a63f349000000b0043ab82b1173mr22747244pgj.534.1665515914419;
        Tue, 11 Oct 2022 12:18:34 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id ix21-20020a170902f81500b001750792f20asm844033plb.238.2022.10.11.12.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 12:18:34 -0700 (PDT)
Date:   Tue, 11 Oct 2022 19:18:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 4/6] KVM: selftests: Rename 'msr->availble' to
 'msr->fault_exepected' in hyperv_features test
Message-ID: <Y0XBhsbvy60b8Zy9@google.com>
References: <20220922143655.3721218-1-vkuznets@redhat.com>
 <20220922143655.3721218-5-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922143655.3721218-5-vkuznets@redhat.com>
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

Nit, s/availble,/available

On Thu, Sep 22, 2022, Vitaly Kuznetsov wrote:
> It may not be clear what 'msr->availble' means. The test actually

Same typo here.

> checks that accessing the particular MSR doesn't cause #GP, rename
> the varialble accordingly.

s/varialble/variable

At least you're consistent :-)

> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  .../selftests/kvm/x86_64/hyperv_features.c    | 96 +++++++++----------
>  1 file changed, 48 insertions(+), 48 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> index 79ab0152d281..1383b979e90b 100644
> --- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> @@ -33,7 +33,7 @@ static inline uint8_t hypercall(u64 control, vm_vaddr_t input_address,
>  
>  struct msr_data {
>  	uint32_t idx;
> -	bool available;
> +	bool fault_expected;
>  	bool write;
>  	u64 write_val;
>  };
> @@ -56,10 +56,10 @@ static void guest_msr(struct msr_data *msr)
>  	else
>  		vector = wrmsr_safe(msr->idx, msr->write_val);
>  
> -	if (msr->available)
> -		GUEST_ASSERT_2(!vector, msr->idx, vector);
> -	else
> +	if (msr->fault_expected)
>  		GUEST_ASSERT_2(vector == GP_VECTOR, msr->idx, vector);
> +	else
> +		GUEST_ASSERT_2(!vector, msr->idx, vector);
>  	GUEST_DONE();
>  }
>  
> @@ -153,12 +153,12 @@ static void guest_test_msrs_access(void)
>  			 */
>  			msr->idx = HV_X64_MSR_GUEST_OS_ID;
>  			msr->write = 0;
> -			msr->available = 0;
> +			msr->fault_expected = 1;

Since all of these are getting inverted, opportunistically use "true" instead of "1"?
