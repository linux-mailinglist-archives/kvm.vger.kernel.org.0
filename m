Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E305E6050C9
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 21:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbiJSTw3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 15:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbiJSTw0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 15:52:26 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7CE1D638D
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 12:52:20 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id t10-20020a17090a4e4a00b0020af4bcae10so967837pjl.3
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 12:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hnwB06qHFVpiyjYkVj8hLBRnRlHSm7STOnmVqd/nWMs=;
        b=NfGmDTqXy5LHjgivlWFDkeKrrRP0nhqXyYq+zER68SfYiZ/KZZx55AuFU2tETRwgAG
         CvvYny8VR6n3ncCR/48eWF3EybY8bqIo35OsVMApVLgRUjVki1Mm6DmQ7Tq5flL0mMYO
         mNF17c2CPXu6ixK/flyZnAE0D0cCSy9ooydINwO0X8LCNdRUR+h0UmMAazER/6XahBsA
         5YmNMtMm/j+kwF3tLuwcG76h9h6PH++x/Vu/SIXEFiffvTOz5HSUq7QAnuy27sy9AfV7
         lGNOZomSPfGgb0TR3KyQ425c8DWQ1f52ku7t8Xbl8Q5QdcZn6g9mForUsgYFK+tdNVDJ
         497w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hnwB06qHFVpiyjYkVj8hLBRnRlHSm7STOnmVqd/nWMs=;
        b=EDyvnNtmvl5wV069uhJGJ/J6aC9VcPF/NdHrj0I1ellepX/pUeZSbAnKpbQWYzKmia
         Js7eZlLabV/ca4VewTEslJCqhfV+p5AIzOuXmVQ+H+DvxVrQgKMQ3YhzjQjmOO17lEM5
         PlIhE9BltUB/LVyqfi7/Sa3z4a7iPo6V+9Np3V7WGKDPdtV1j7kTPJAn0vFEzRvHzC79
         NOqyOm3rzVGGawDUaRT0XPtaGsTYCHcTDur0zjPSSSx/Y702blQ2ZUcUdabnkAcnI7Xm
         g5+4Fs0R90BoQRZqafqUcpMWxl6o1Mo29uHDLzgt600Fl8chJIO0JdJwsCu8WDXXphED
         IoEg==
X-Gm-Message-State: ACrzQf1bpfOAWfjpJM1n+rxMB/Q4wbqrIxbnwi2JxaZf/KPEL4P8W8nN
        nJO4XSQGiA7r8DERu7pQBE551A==
X-Google-Smtp-Source: AMsMyM75YJZ2jZ3WYMp87mMgAHA1mh0zI14iepyX5OdZ2yLFzi/fYu9BTOwEEIdtpyMqh4eAabTBDQ==
X-Received: by 2002:a17:902:8c81:b0:178:a33f:8b8f with SMTP id t1-20020a1709028c8100b00178a33f8b8fmr10299902plo.50.1666209139843;
        Wed, 19 Oct 2022 12:52:19 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u14-20020a63d34e000000b0046b1dabf9a8sm10365023pgi.70.2022.10.19.12.52.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 12:52:19 -0700 (PDT)
Date:   Wed, 19 Oct 2022 19:52:16 +0000
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
Subject: Re: [PATCH v11 09/46] KVM: x86: hyper-v: Introduce TLB flush fifo
Message-ID: <Y1BVcDFt851sfSkU@google.com>
References: <20221004123956.188909-1-vkuznets@redhat.com>
 <20221004123956.188909-10-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221004123956.188909-10-vkuznets@redhat.com>
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

On Tue, Oct 04, 2022, Vitaly Kuznetsov wrote:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0539d216f760..7fb8bd42b13e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3388,7 +3388,7 @@ static void kvm_vcpu_flush_tlb_all(struct kvm_vcpu *vcpu)
>  	kvm_clear_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
>  }
>  
> -static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
> +void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)

kvm_vcpu_flush_tlb_guest() doesn't need to be exposed in this patch, i.e. can
remain static.  I think it can be restricted to x86.c even in the final form
(will follow-up in later patch).

>  {
>  	++vcpu->stat.tlb_flush;
>  
> @@ -3409,7 +3409,7 @@ static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
>  	 * Flushing all "guest" TLB is always a superset of Hyper-V's fine
>  	 * grained flushing.
>  	 */
> -	kvm_clear_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
> +	kvm_hv_vcpu_purge_flush_tlb(vcpu);
>  }
>  
>  
> @@ -10484,7 +10484,14 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  
>  		kvm_service_local_tlb_flush_requests(vcpu);
>  
> -		if (kvm_check_request(KVM_REQ_HV_TLB_FLUSH, vcpu))
> +		/*
> +		 * Fall back to a "full" guest flush if Hyper-V's precise
> +		 * flushing fails.  Note, Hyper-V's flushing is per-vCPU, but
> +		 * the flushes are considered "remote" and not "local" because
> +		 * the requests can be initiated from other vCPUs.
> +		 */
> +		if (kvm_check_request(KVM_REQ_HV_TLB_FLUSH, vcpu) &&
> +		    kvm_hv_vcpu_flush_tlb(vcpu))
>  			kvm_vcpu_flush_tlb_guest(vcpu);
>  
>  		if (kvm_check_request(KVM_REQ_REPORT_TPR_ACCESS, vcpu)) {
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index a784ff90740b..1ea28a7bdf2f 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -79,6 +79,7 @@ static inline unsigned int __shrink_ple_window(unsigned int val,
>  
>  #define MSR_IA32_CR_PAT_DEFAULT  0x0007040600070406ULL
>  
> +void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu);

As above, this is unnecessary.

>  void kvm_service_local_tlb_flush_requests(struct kvm_vcpu *vcpu);
>  int kvm_check_nested_events(struct kvm_vcpu *vcpu);
>  
> -- 
> 2.37.3
> 
