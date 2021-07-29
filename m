Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 847353DAAD0
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 20:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhG2SPg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 14:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbhG2SPf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 14:15:35 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1377C061765
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 11:15:32 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id ds11-20020a17090b08cbb0290172f971883bso16999285pjb.1
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 11:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1VgSvIUg18Pmu6bXQr/jLLZHZW93wmUUl7jcbNMrRlE=;
        b=c7Xg5u/SFv0fecvDSkWBz6Or6adxwzBui7Dq/4a59U/xMEjg8w8P/kAEQXWhvAovjQ
         mih0wxsqaaPUB38HpOf6y50jYJ1C6e8XQM9falOaY4Fd0q17yJ/nhIkfIDEuzVcsxbRz
         kvROAVdZuCjR8xG4APDxgAbdiPartFPWfak43cWy4fPI+1UJB5FUXt+eLbQsvvXBFlfp
         B4KDcEVK3fIjhSOHocLlUFwNxs/i6Dp7v1xyvKf9Drcyw2B00s539e59q+vyeXJnKl6W
         O1sHXA7YJOKy+Vsb8WiCC5HtnjMZRby+Aq/UMM4dG8IMO5uDH8jNlPd1eWPoHzr0e+QL
         ppyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1VgSvIUg18Pmu6bXQr/jLLZHZW93wmUUl7jcbNMrRlE=;
        b=N7NKpu4neNdXBh555OFOr6llGJrQde9x0R/4ZItpPb/Wp+vXl6N4F3lr1oWbfxYEg9
         LCCC9LSVQoA2r88xz0VgtpZxbTIhXk/56D1Crym4XT5wByyqkCb33XjX4q2Y2pzVo5FB
         1sRy7CXt7gjg7ZUMmHXa8QBNiTQ7+YRBBkbChsQZaHXtaaaamPl7Jvr/ytjU6n2R4sNR
         X/aD3ZK4wEJ4SL3UzltAJ3E/5lmufTuIG2l03SCV3m5JCHAFSwA+qHbU0j+cy573uwLq
         oJngNypbGRWHydoXx3xKJmRjEz6yR+ghDaaaZCAHRiQPPOow1dST108Jvk+7xOhRZcOP
         n0WA==
X-Gm-Message-State: AOAM532kNNXbEZUh4n34X3SxqnB4qRO9c03ebW9bgxapQADNH//jEoNi
        6/4LWTuBftPMNodjQj2BoaKOxUiEHfgZig==
X-Google-Smtp-Source: ABdhPJxeL54Xfvacu7ArTo3B5iH93qHeEnG4cdgRdD0aAvS5WWEXUwctrS4C2oSGWKL/TIsmgOIT0A==
X-Received: by 2002:a17:902:c402:b029:12b:5175:1ddd with SMTP id k2-20020a170902c402b029012b51751dddmr5870494plk.67.1627582531986;
        Thu, 29 Jul 2021 11:15:31 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id i8sm4638520pfk.18.2021.07.29.11.15.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 11:15:31 -0700 (PDT)
Date:   Thu, 29 Jul 2021 18:15:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, maz@kernel.org, drjones@redhat.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com,
        yuzenghui@huawei.com, vkuznets@redhat.com
Subject: Re: [PATCH v4 3/6] KVM: selftests: Introduce UCALL_UNHANDLED for
 unhandled vector reporting
Message-ID: <YQLwP9T4hevAqa7w@google.com>
References: <20210611011020.3420067-1-ricarkol@google.com>
 <20210611011020.3420067-4-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210611011020.3420067-4-ricarkol@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 10, 2021, Ricardo Koller wrote:
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index fcd8e3855111..beb76d6deaa9 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -349,6 +349,7 @@ enum {
>  	UCALL_SYNC,
>  	UCALL_ABORT,
>  	UCALL_DONE,
> +	UCALL_UNHANDLED,
>  };

...

> @@ -1254,16 +1254,13 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
>  
>  void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid)
>  {
> -	if (vcpu_state(vm, vcpuid)->exit_reason == KVM_EXIT_IO
> -		&& vcpu_state(vm, vcpuid)->io.port == UNEXPECTED_VECTOR_PORT
> -		&& vcpu_state(vm, vcpuid)->io.size == 4) {
> -		/* Grab pointer to io data */
> -		uint32_t *data = (void *)vcpu_state(vm, vcpuid)
> -			+ vcpu_state(vm, vcpuid)->io.data_offset;
> -
> -		TEST_ASSERT(false,
> -			    "Unexpected vectored event in guest (vector:0x%x)",
> -			    *data);
> +	struct ucall uc;
> +
> +	if (get_ucall(vm, vcpuid, &uc) == UCALL_UNHANDLED) {

UCALL_UNHANDLED is a bit of an odd name.  Without the surrounding context, I would
have no idea that it's referring to an unhandled event, e.g. my gut reaction would
be that it means the ucall itself was unhandled.  Maybe UCALL_UNHANDLED_EVENT?
It's rather long, but I don't think that will be problematic for any of the code.


> +		uint64_t vector = uc.args[0];
> +
> +		TEST_FAIL("Unexpected vectored event in guest (vector:0x%lx)",
> +			  vector);
>  	}
>  }
>  
> -- 
> 2.32.0.272.g935e593368-goog
> 
