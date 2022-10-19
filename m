Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75F5360511D
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 22:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbiJSUOO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 16:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbiJSUOM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 16:14:12 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E2801C73EC
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 13:14:11 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id w196so20530142oiw.8
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 13:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kqJOFlfwNgCDzAUg+3GKgd5GjZJIWzZ3Ope902HuuIc=;
        b=aamPcz5cH2f8vrWESZ8tn5FtLYZ0e2DUYmpGuRUSftaqxaK1qlNpUlih4yCfZesLbY
         k0GC/vrRRBwmINiUlgmBYLEoi54Rw1e61DBNjVJ3m1zIZqV5DlC0sj43HJPpaprwDQFF
         gtom64pXNAd5XfaKkKu8OfnRqwFcsGO59fopaEzxI+Ap7brT85i96IbVXUMNhS/1fYf3
         HQlTdAojQumAEuhFodP9w5LLXb7y33T4FKd9OcDEjDPXwPXKJ44Jpz94UUXC3PwQVjMl
         QA9RGuLFUuKtd1T2IrpyBNFCweBnL8MQXxLPcdSKwTw76yFEOuexU0IjNjvN+I5dIKJ0
         Skcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kqJOFlfwNgCDzAUg+3GKgd5GjZJIWzZ3Ope902HuuIc=;
        b=O+iRIdkaIICEhEsQUmBumQ+DGo4m5uQJbLIgZs6OzJ13Vq9aVIqG/0MWfJGA4YCdbr
         G5N/rxcZJ1ReV8FGtEcweLiQQm5efsFAoJ3AC/QK6VXLy+cijbfnBfBH8bXkqLxJOWJZ
         Sk2qgNW+MJO0C9/824El0/kDbov3BLAP15TWrdCL38PbuG668lr9SN+oRhd8MUMDrj05
         84m150+SIvDsnTVCWOEmcvJJSWtJOrLSlN+ITCco7bEiBLwCEQMh45K+7/wzJvKLCAQ+
         QBfuzcWvKimrxCAZiRArpRMqA9c0BcFByU6oyR3nUXvL/wkT/yRGXshwJHwQ2cAOPX1j
         wQGg==
X-Gm-Message-State: ACrzQf2/wxOCJUPwXU9HZjYeGTcJwL9zSN6+XfjAhfA3i7xG7kadtgwR
        dB+b2xpHaIt0yJtQvJz1wJYX/tqs5OuaRQ==
X-Google-Smtp-Source: AMsMyM6ZjthZ89X/AzB9A91vqAp+Yy+SUd6tr8hw1WsJG+8UbSs3dNoWv5Uxjsb5wSL4CoQUU7urSw==
X-Received: by 2002:a17:90b:278c:b0:20a:e1e6:5340 with SMTP id pw12-20020a17090b278c00b0020ae1e65340mr47245894pjb.239.1666210440194;
        Wed, 19 Oct 2022 13:14:00 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id q6-20020a170902dac600b0018542a1b553sm10954895plx.127.2022.10.19.13.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 13:13:59 -0700 (PDT)
Date:   Wed, 19 Oct 2022 20:13:56 +0000
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
Subject: Re: [PATCH v11 16/46] KVM: x86: hyper-v: Don't use
 sparse_set_to_vcpu_mask() in kvm_hv_send_ipi()
Message-ID: <Y1BahCzO4jxFC9Ey@google.com>
References: <20221004123956.188909-1-vkuznets@redhat.com>
 <20221004123956.188909-17-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221004123956.188909-17-vkuznets@redhat.com>
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
> @@ -2034,7 +2056,10 @@ static void kvm_send_ipi_to_many(struct kvm *kvm, u32 vector,
>  	unsigned long i;
>  
>  	kvm_for_each_vcpu(i, vcpu, kvm) {
> -		if (vcpu_bitmap && !test_bit(i, vcpu_bitmap))
> +		if (sparse_banks &&
> +		    !hv_is_vp_in_sparse_set(kvm_hv_get_vpindex(vcpu),
> +					    valid_bank_mask,
> +					    sparse_banks))

Nit, this fits on two lines and IMO is slightly easier on the eyes:

		if (sparse_banks &&
		    !hv_is_vp_in_sparse_set(kvm_hv_get_vpindex(vcpu),
					    valid_bank_mask, sparse_banks))
			continue;

>  			continue;
>  
>  		/* We fail only when APIC is disabled */
> @@ -2047,7 +2072,6 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  	struct kvm *kvm = vcpu->kvm;
>  	struct hv_send_ipi_ex send_ipi_ex;
>  	struct hv_send_ipi send_ipi;
> -	DECLARE_BITMAP(vcpu_mask, KVM_MAX_VCPUS);
>  	u64 valid_bank_mask;
>  	u64 sparse_banks[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
>  	u32 vector;
> @@ -2109,13 +2133,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  	if ((vector < HV_IPI_LOW_VECTOR) || (vector > HV_IPI_HIGH_VECTOR))
>  		return HV_STATUS_INVALID_HYPERCALL_INPUT;
>  
> -	if (all_cpus) {
> -		kvm_send_ipi_to_many(kvm, vector, NULL);
> -	} else {
> -		sparse_set_to_vcpu_mask(kvm, sparse_banks, valid_bank_mask, vcpu_mask);
> -
> -		kvm_send_ipi_to_many(kvm, vector, vcpu_mask);
> -	}
> +	kvm_hv_send_ipi_to_many(kvm, vector, all_cpus ? NULL : sparse_banks, valid_bank_mask);

Any objection to not using a ternary operator?

	if (all_cpus)
		kvm_hv_send_ipi_to_many(kvm, vector, NULL, 0);
	else
		kvm_hv_send_ipi_to_many(kvm, vector, sparse_banks, valid_bank_mask);

Mostly because it's somewhat arbitrary that earlier code ensures valid_bank_mask
is set in the all_cpus=true case, e.g. arguably KVM doesn't need to do the var_cnt
sanity check in the all_cpus case:

		all_cpus = send_ipi_ex.vp_set.format == HV_GENERIC_SET_ALL;
		if (all_cpus)
			goto check_and_send_ipi;

		valid_bank_mask = send_ipi_ex.vp_set.valid_bank_mask;
		if (hc->var_cnt != hweight64(valid_bank_mask))
			return HV_STATUS_INVALID_HYPERCALL_INPUT;

		if (!hc->var_cnt)
			goto ret_success;
