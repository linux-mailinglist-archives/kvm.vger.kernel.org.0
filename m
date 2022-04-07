Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 847734F86D6
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 20:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346734AbiDGSEn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 14:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234009AbiDGSEl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 14:04:41 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1524CC74BD
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 11:02:41 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id j17so4682951pfi.9
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 11:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zbKPegUyU45rH7gKXzXri3LhcGQyiXiZ1PMj8OU0FUE=;
        b=WMCAx2IfBApetXXM+o1hQqfbJJFX3JosvV/3p1o7C8/ibPs7xeX4qidxmU+Fvco93Y
         4pk+iLH4xmNMXIh+8wTSS36ZAK4Shtfyz5i5XfjD/iZGMnhsvT7TvSz/fNqjrlVwID7e
         5I+lfT5wZ9s20r5rj0lth1+csSfBiNebQzYfuPLpYtAVYVvPr7APYIe/PufbSYn9bLuO
         GXHIqnRxPdYvDe+mLtl693jF5vJ8gyREX5JC2k+RAPwyQy3yZbO6yseboHoWrzXy7TEl
         W4LU/O5IriVnhmUPr68/P/OP/5WPKJ1VB9ds3/BLJfc4q7j50pbQd+WLLlwMRPdi/PS6
         5ZnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zbKPegUyU45rH7gKXzXri3LhcGQyiXiZ1PMj8OU0FUE=;
        b=qCjYJS2heZQHzn437152fBbBqxKInos9iATDFo2x+0qXEoySG7ntTgt8ESZOqVYxlX
         yT0VbglV2h4P5OXWUTY2+5jT83xGdnOttJ+C11PZSG/KVX1BLlT9nSyu3sO6AAAhZe7G
         sgo2KrpiT2hRlvxPGx4uwEJLHTwO3i/9LXVuszkw+gYNbdNzycu+YYwfOVH/v8XAC4ds
         uG2OYtxFkgWd07IeYu/n0XkRXvHSbIrt6jMR5tlQ42wrN0pKcgIcCNerc6GXNEGeOVpL
         Vl/slJuhjkPEiOGZ1m/S6SUmQVDWPkI5Q6DI5GnjtKRNVDoIKLyoL4P8aajxDgHVam1E
         6uPw==
X-Gm-Message-State: AOAM533/De5ZT7rqtFHLmh20/fLQuh9xdfMrn/D2rlxspys0Iaug78EE
        2rYKPBh20QTo+GMdV4foMrQnFg==
X-Google-Smtp-Source: ABdhPJxpRm9mSw+aTuqx1VxQurUVq7hqNTK0hkzfMmj9tFaZLwawtq+kEVdY+TdodFQhTaaG5iN2uA==
X-Received: by 2002:a63:2b0d:0:b0:386:322:f05c with SMTP id r13-20020a632b0d000000b003860322f05cmr12320393pgr.11.1649354560357;
        Thu, 07 Apr 2022 11:02:40 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h13-20020a056a00230d00b004f427ffd485sm26051672pfh.143.2022.04.07.11.02.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 11:02:39 -0700 (PDT)
Date:   Thu, 7 Apr 2022 18:02:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/31] KVM: x86: hyper-v: Resurrect dedicated
 KVM_REQ_HV_TLB_FLUSH flag
Message-ID: <Yk8nPJ45PJzN9o+L@google.com>
References: <20220407155645.940890-1-vkuznets@redhat.com>
 <20220407155645.940890-2-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407155645.940890-2-vkuznets@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 07, 2022, Vitaly Kuznetsov wrote:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e9647614dc8c..3c54f6804b7b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3341,7 +3341,12 @@ void kvm_service_local_tlb_flush_requests(struct kvm_vcpu *vcpu)
>  	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
>  		kvm_vcpu_flush_tlb_current(vcpu);
>  
> -	if (kvm_check_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu))
> +	if (kvm_check_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu)) {
> +		kvm_vcpu_flush_tlb_guest(vcpu);
> +		kvm_clear_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
> +	}
> +
> +	if (kvm_check_request(KVM_REQ_HV_TLB_FLUSH, vcpu))
>  		kvm_vcpu_flush_tlb_guest(vcpu);

It'd be slightly more performant to do:

	if (kvm_check_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu)) {
		kvm_vcpu_flush_tlb_guest(vcpu);
		kvm_clear_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
	} else if (kvm_check_request(KVM_REQ_HV_TLB_FLUSH, vcpu)) {
		kvm_hv_vcpu_flush_tlb(vcpu);
	}

And then when the code becomes


	if (kvm_check_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu)) {
		kvm_vcpu_flush_tlb_guest(vcpu);
		if (kvm_check_request(KVM_REQ_HV_TLB_FLUSH, vcpu))
			kvm_hv_vcpu_empty_flush_tlb(vcpu);
	} else if (kvm_check_request(KVM_REQ_HV_TLB_FLUSH, vcpu)) {
		kvm_hv_vcpu_flush_tlb(vcpu);
	}

the elif will help unsuspecting readers see that the HV_TLB_FLUSH request is
cleared by kvm_check_request() in the TLB_FLUSH_GUEST path.

The elif could result in having to bail from VM-Entry if the request becomes
pending after the check/clear inside TLB_FLUSH_GUEST, but that should be a very
rare case.

>  }
>  EXPORT_SYMBOL_GPL(kvm_service_local_tlb_flush_requests);
> -- 
> 2.35.1
> 
