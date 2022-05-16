Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05CB052912D
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 22:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240721AbiEPUZk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 16:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347233AbiEPUXe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 16:23:34 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 905C34B402
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 13:09:57 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id nk9-20020a17090b194900b001df2fcdc165so427529pjb.0
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 13:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wzx7NT/bkCjJnHFo5lwIctB7nDe602qxHRo5R1R5KC0=;
        b=AMws03KWgp7hhyS5yH0ZZgkyrQGUxWWjom10rEHGW9HVJe/B39vQdFbOzZDngRLz85
         11ztlJ90TsfQUyhk0y91m3LCis4j0lmBDTWy8wpzsiElk1XXuk6fnX788cAE6k8QrYwL
         yT0zTxFfM5QPl22vfnBxoEpoR2ZT9FwAzIynCVhKMued/cmd7czQiTSWJbnLSO8jhzlw
         6WSvtvN6wUH++ILH1ZQIUrxoVSwjrESLNF6kRwOXQ/lcD3Fp66CwtWMylB5F7do4Wmqj
         S4qD+3iee59hXjru6GsfvY4Z89JrB+dkWA6OcH6fkzib1ntLAajlQQMdEXjuzmzzOscb
         p/bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wzx7NT/bkCjJnHFo5lwIctB7nDe602qxHRo5R1R5KC0=;
        b=bBRirflrGpAm7aNkNQEfSGpW1SJ1TMkYyu9tFsRAtiplLhgtHugHfDthpV6dZIDj9w
         D6fVXO/ri6aP/5P7aNZEbEwyWJDkQ8hqxTJAy/uFSPdVnRfIHdx3RI+1IonBDvXQw1rS
         x62hmpIG9eECRw4lT3yLGrC1T4e/8Xm4bajJGpz18U0z0U6FOHSaLQRtLQs3XJ4Zb5XK
         yb8mX61fvCJ1+VYXGzhQpSBKqTF/vL01gqUJVLbIE8PLnLG21WRDlA5M65yhl1qUNJOK
         +UfrkcWrdxhTK5a0QbZZDw1DeVbcXFvO5opvSh64XraN5rxzBWV0mBZH/NlWCjKPJOUc
         Eh2Q==
X-Gm-Message-State: AOAM531hQfoFi5tzOW+KGFZg214KqVE+twlZ1kRfEDfi0WCBMCNVVBSQ
        EEq+5LmnXiXnz1yhPror+Vc+6A==
X-Google-Smtp-Source: ABdhPJz0Ftz1ke7eSHpyZ28XpMixfb3ZztfsWTYIdzRosBnT6uhFx3Dm1ZEtu6S5LaqcUQfV0PLhHA==
X-Received: by 2002:a17:903:1c9:b0:161:89e8:229 with SMTP id e9-20020a17090301c900b0016189e80229mr4616450plh.106.1652731796204;
        Mon, 16 May 2022 13:09:56 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p14-20020a170902780e00b00161a16f0050sm229094pll.222.2022.05.16.13.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 13:09:55 -0700 (PDT)
Date:   Mon, 16 May 2022 20:09:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 15/34] KVM: x86: hyper-v: Introduce
 kvm_hv_is_tlb_flush_hcall()
Message-ID: <YoKvkEfvyGJWNmAj@google.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
 <20220414132013.1588929-16-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220414132013.1588929-16-vkuznets@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 14, 2022, Vitaly Kuznetsov wrote:
> The newly introduced helper checks whether vCPU is performing a
> Hyper-V TLB flush hypercall. This is required to filter out L2 TLB
> flush hypercalls for processing.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/hyperv.h | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
> index d59f96700104..ca67c18cef2c 100644
> --- a/arch/x86/kvm/hyperv.h
> +++ b/arch/x86/kvm/hyperv.h
> @@ -170,6 +170,24 @@ static inline void kvm_hv_vcpu_empty_flush_tlb(struct kvm_vcpu *vcpu)
>  	tlb_flush_ring = kvm_hv_get_tlb_flush_ring(vcpu);
>  	tlb_flush_ring->read_idx = tlb_flush_ring->write_idx;
>  }
> +
> +static inline bool kvm_hv_is_tlb_flush_hcall(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> +	u16 code;
> +
> +	if (!hv_vcpu)
> +		return false;
> +
> +	code = is_64_bit_hypercall(vcpu) ? kvm_rcx_read(vcpu) :
> +		kvm_rax_read(vcpu);

Nit, can you align the two expressions?

	code = is_64_bit_hypercall(vcpu) ? kvm_rcx_read(vcpu) :
					   kvm_rax_read(vcpu);

> +
> +	return (code == HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE ||
> +		code == HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST ||
> +		code == HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX ||
> +		code == HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX);
> +}
> +
>  void kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu);
>  
>  
> -- 
> 2.35.1
> 
