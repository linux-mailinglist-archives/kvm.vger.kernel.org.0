Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E64515E5518
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 23:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbiIUVTN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 17:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiIUVTL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 17:19:11 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16CFA61C1
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 14:19:10 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id e67so1059793pgc.12
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 14:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=qn2Tyr5BBZtLc4Q3iyya3S9UpHREHtk3JzWAYU0n/Xs=;
        b=lrCrFnJwDqg8lDvVHSiB+LouuHDaJu2gqUZm46RhmQ6BqLAfOIqs39DLUFOH5A02O2
         /Qx9DbpVmcOTFg5n05d9GFQNcSgsYRHmcTyARBaMzZBW/ykLtS0C4r4FDt+rET9IJuI6
         /2/oNlWepPwjg/wX4KiSj6aqQpXn0bxMQ/OTpN2Cjx+/lRL7BWCMhgux3d4JdUYnHs7V
         zbefxEvtHUlFl8/nmUyQ/AWKEKOAzCbjAcbijwUG23yLWyA50QKka/yTpNU8E6f0Z7Mv
         5hHnB/QotfaoVRYtQ9mlTtabSiRs9NXGGU55wRi7wY+ltf9aoHqh9ARlfxX08c2jyo7O
         +nog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=qn2Tyr5BBZtLc4Q3iyya3S9UpHREHtk3JzWAYU0n/Xs=;
        b=i3UHX+SqH7vStai130mgWu8LZjYjS0ovECv9Bx3TPeTL5pZaOJ9itVHZ7sZKy8jnpa
         t5i8HZcPogVGad+I5D6nIlbP5JMtGxcT9yC9A2DUSA093wkpbmUDR1o+qllST/2kpFSD
         7kWdoiB4XkA8b2k2mRTMopdoQAGMnzufzbmQf9GVI3ab8qENbBSDlzCTYHsHEWC4Ic+y
         8dLPab7M1jL1tAte2pUoyMc98AW+TukX+MBHDhPM0eIXLyXhkRfVMaPkvLre91BGPEKM
         HcFexeUY6/cOVzYU4CfnDsRPj657FR3qW9/Bet4dMxNk3FMEq2+j2cqu1EOqiL+EaXsV
         TPBg==
X-Gm-Message-State: ACrzQf2bLjPtEvEUZWZr4tzZrXJ6aDq/eabc1nwMaq/u4lUqdao95joQ
        sFwva6guJUo/ttXu8d4kcxdKFw==
X-Google-Smtp-Source: AMsMyM7NDWr1OHvf4/DOTuO46c9LjjzZYkWEszB0swaN+tiWynXVjEvc8rod3Lqug5SO6bxMqtcDMA==
X-Received: by 2002:a63:8542:0:b0:43a:5ca7:c710 with SMTP id u63-20020a638542000000b0043a5ca7c710mr143996pgd.264.1663795150087;
        Wed, 21 Sep 2022 14:19:10 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id h5-20020a170902680500b00178b717a0a3sm2430996plk.69.2022.09.21.14.19.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 14:19:09 -0700 (PDT)
Date:   Wed, 21 Sep 2022 21:19:06 +0000
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
Subject: Re: [PATCH v10 18/39] KVM: x86: hyper-v: Introduce fast
 guest_hv_cpuid_has_l2_tlb_flush() check
Message-ID: <Yyt/ylgNjsgGTQMN@google.com>
References: <20220921152436.3673454-1-vkuznets@redhat.com>
 <20220921152436.3673454-19-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921152436.3673454-19-vkuznets@redhat.com>
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

On Wed, Sep 21, 2022, Vitaly Kuznetsov wrote:
> Introduce a helper to quickly check if KVM needs to handle VMCALL/VMMCALL
> from L2 in L0 to process L2 TLB flush requests.
> 
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/hyperv.h | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
> index 1b53dd4cff4d..3fff3a6f4bb9 100644
> --- a/arch/x86/kvm/hyperv.h
> +++ b/arch/x86/kvm/hyperv.h
> @@ -174,6 +174,13 @@ static inline void kvm_hv_vcpu_empty_flush_tlb(struct kvm_vcpu *vcpu)
>  	kfifo_reset_out(&tlb_flush_fifo->entries);
>  }
>  
> +static inline bool guest_hv_cpuid_has_l2_tlb_flush(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> +
> +	return hv_vcpu && (hv_vcpu->cpuid_cache.nested_eax & HV_X64_NESTED_DIRECT_FLUSH);

Nit, IMO this is long enough that it's worth wrapping to fit under the soft char limit.

	return hv_vcpu &&
	       (hv_vcpu->cpuid_cache.nested_eax & HV_X64_NESTED_DIRECT_FLUSH);

> +}
> +
>  static inline bool kvm_hv_is_tlb_flush_hcall(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> -- 
> 2.37.3
> 
