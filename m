Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7437F4F1C00
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 23:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379802AbiDDVVA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 17:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379496AbiDDRQU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 13:16:20 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A410914019
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 10:14:24 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id m12-20020a17090b068c00b001cabe30a98dso1081497pjz.4
        for <kvm@vger.kernel.org>; Mon, 04 Apr 2022 10:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=f7CZTXIAAoKnaeTzl2cBEFXf6R/B35g02/GjhJjJB74=;
        b=eBZWszMfrYAS1A0VrXpWNQWYDljGRJ+69p04Uob5nwN5mkb+RRRbhGQtuSACDJkmvd
         JzPqoBdgGu43CiEvMKn6MoJcRQCsl7Owmu3MNRPIYKMky87OkSaEID6ZI70cN+xFHfx5
         ZxAL+FJLp9ve4zSfapVXowsj+6Ldxi2KIv9zTO/Uf8ZtGfgDzG/o8faLsk22qy3LIdgI
         2FPf//bfqpfCAuXBJpK7xeekXuFiEuJ24MyqK4BXHra2TdclI296/kmZ9f5cwYj4K+7B
         g9g8MWWBtQB00iQfM4jblH3lazcS3nWsLZzRPoAvtYHlPcGNcHEHkXEhancJVBtgTKuU
         /Smg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f7CZTXIAAoKnaeTzl2cBEFXf6R/B35g02/GjhJjJB74=;
        b=PjIRHEtNU3qVosfWFJtc7/8XOI1GXvn71PKkPKlFPRZwHaqUeptFJevy7WwiS255OD
         anxRMWv7h9Y5ziw0c8lCr0IIKeG7nGCgsRNuF9FLC1nwxFUcF3GcfnNPsHUJ6wf0e9EH
         l9q6GV6HYQk5Ji7Z1hKO/VPhI6QISRUcxsrqQXl+nUFhmpw2/TA1iD45RdF45q8haALY
         t2q9+7P85KGPo9i/GrFil9i6joXsuI/25qoKWgwXMbXnk6YS832eqMoX8m6GuKs6G3SK
         U7OldI+3jHt1HlRmSu7yBjh4fk04tawI6uSI2PiLa69en28t1JaxURfcb3MHW0q+db9j
         Z90Q==
X-Gm-Message-State: AOAM530OHVDpaWivjeiKtgCJY/SgDnD+GZI4UCfFohg4NeXQUK24YLvb
        Xj26EumTGqv2wy8cAuTczYZ1pQ==
X-Google-Smtp-Source: ABdhPJzu6dtSeMV3rRz4ufVwNX4oy3lmvg6rRBEM4WSW1CYCt5tL39H9tp7VwplJzx+C40xvVWwSwg==
X-Received: by 2002:a17:90b:713:b0:1c6:c8f5:6138 with SMTP id s19-20020a17090b071300b001c6c8f56138mr207055pjz.138.1649092463964;
        Mon, 04 Apr 2022 10:14:23 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id o11-20020a17090aac0b00b001cab1712455sm50391pjq.40.2022.04.04.10.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 10:14:23 -0700 (PDT)
Date:   Mon, 4 Apr 2022 17:14:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH 6/8] KVM: SVM: Re-inject INTn instead of retrying the
 insn on "failure"
Message-ID: <Yksna20cSyO8MvOq@google.com>
References: <20220402010903.727604-1-seanjc@google.com>
 <20220402010903.727604-7-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220402010903.727604-7-seanjc@google.com>
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

On Sat, Apr 02, 2022, Sean Christopherson wrote:
> Re-inject INTn software interrupts instead of retrying the instruction if
> the CPU encountered an intercepted exception while vectoring the INTn,
> e.g. if KVM intercepted a #PF when utilizing shadow paging.  Retrying the
> instruction is architecturally wrong e.g. will result in a spurious #DB
> if there's a code breakpoint on the INT3/O, and lack of re-injection also
> breaks nested virtualization, e.g. if L1 injects a software interrupt and
> vectoring the injected interrupt encounters an exception that is
> intercepted by L0 but not L1.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/svm.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index ecc828d6921e..00b1399681d1 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3425,14 +3425,24 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
>  static void svm_inject_irq(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> +	u32 type;
>  
>  	WARN_ON(!gif_set(svm));
>  
> +	if (vcpu->arch.interrupt.soft) {
> +		if (svm_update_soft_interrupt_rip(vcpu))
> +			return;
> +
> +		type = SVM_EVTINJ_TYPE_SOFT;
> +	} else {
> +		type = SVM_EVTINJ_TYPE_INTR;
> +	}
> +
>  	trace_kvm_inj_virq(vcpu->arch.interrupt.nr);
>  	++vcpu->stat.irq_injections;
>  
>  	svm->vmcb->control.event_inj = vcpu->arch.interrupt.nr |
> -		SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_INTR;
> +				       SVM_EVTINJ_VALID | type;
>  }
>  
>  void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
> @@ -3787,9 +3797,13 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
>  	case SVM_EXITINTINFO_TYPE_INTR:
>  		kvm_queue_interrupt(vcpu, vector, false);
>  		break;
> +	case SVM_EXITINTINFO_TYPE_SOFT:
> +		kvm_queue_interrupt(vcpu, vector, true);

I believe this patch is wrong, it needs to also tweak the soft_int_injected logic
to look for SVM_EXITINTINFO_TYPE_EXEPT _or_ SVM_EXITINTINFO_TYPE_SOFT, e.g. if the
SOFT-type interrupt doesn't complete due to a non-legacy-exception exit, e.g. #NPF.

> +		break;
>  	default:
>  		break;
>  	}
> +
>  }
