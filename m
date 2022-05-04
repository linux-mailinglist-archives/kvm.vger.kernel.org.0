Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD4051B158
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 23:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378909AbiEDVv2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 17:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232308AbiEDVv1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 17:51:27 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7BF50B06
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 14:47:50 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id x23so2141833pff.9
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 14:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JGBYzFJimhJoad1idzTH3i0huCpJLlUvf/ClUW1YohE=;
        b=Fd0VCuyx81rIATkfzj1LFSVSpflcHe53RRSPXpEGiZLhs2CfyPUKlSdmKMgRgPuXJB
         aC2lYEm+gScd6h/QTZqEQmm2tt014kvIHi2cGRgXhM8WRp3zPN7FXiMDZo1WbDWuUKv9
         nKfAGeLN6XfbuIsfI6SuscFe3CAXPdndM6+85s01iI2cl7CFKF7v+v/zFzAsdMMoEduI
         CP06zWIqj0ki14Ng6mLL/j4nLrfwaEP8MVc+NT5AMByju2eRJZ8yLDMvlzcXLB3jKWqA
         ZnXge/u8D9WyE3PxtmFFioJ2XNZ0Nhw7HCPue+RHuDPevxPai7FqJZzES8gr7/9q2evQ
         hHxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JGBYzFJimhJoad1idzTH3i0huCpJLlUvf/ClUW1YohE=;
        b=FLonYsKJPwfT7ZPiawpOq92GXr+KgtV1Cgv/c/2WgJOheF3nImX6yBLCX421fz6vth
         gvpkqzJv/MubDes5cc1rikUkY9agdFBtohnHDeWaHIpg8f2QMbI2YZcQgT8BM1/w6UwA
         WJsd6RLvltwfmXoTFyPYSquJPaRxoNXH2YVUQ0btC/WLLeJ7dqjaGB1i1GwZPyJcYdEW
         d1qX+nFecfO/te1xcA5uMc8k40Xq9dr3smw/c5YpvohpDKVme/H/1Tcybs+Fgpn8R7an
         mCpkDOlydTUadE2bZAxQZ+p69+bQqclRvjWj1xuYQ0C09LbVAky039OIfWBoz0Y6SAoc
         Abnw==
X-Gm-Message-State: AOAM530JVwXW9OWeUN7EK0Rbw2J5gbCGTIKij0/IxtjcZxt3q50LX/nW
        leLpcLwrmbSMBa4a0pDzl7ZBbg==
X-Google-Smtp-Source: ABdhPJw1SaEbg06uganw6Cw3J+BiB3QyAdz5US+cDiaABZHNDFKYnWvCDn9OKGW5LoZD8ocsfB8Vrw==
X-Received: by 2002:a63:5747:0:b0:381:54b9:b083 with SMTP id h7-20020a635747000000b0038154b9b083mr19378108pgm.178.1651700869465;
        Wed, 04 May 2022 14:47:49 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m11-20020aa7900b000000b0050dc762812esm8726670pfo.8.2022.05.04.14.47.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 14:47:48 -0700 (PDT)
Date:   Wed, 4 May 2022 21:47:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jon Kohler <jon@nutanix.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: X86: correct trace_kvm_pv_tlb_flush stats
Message-ID: <YnL0gUcUq5MbWvdH@google.com>
References: <20220504182707.680-1-jon@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220504182707.680-1-jon@nutanix.com>
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

On Wed, May 04, 2022, Jon Kohler wrote:
> The trace point in record_steal_time() is above the conditional
> that fires kvm_vcpu_flush_tlb_guest(), so even when we might
> not be flushing tlb, we still record that we are.

No, it records whether not a TLB flush is needed.

> Fix by nestling trace_kvm_pv_tlb_flush() under appropriate
> conditional. This results in the stats for kvm:kvm_pv_tlb_flush,
> as trivially observable by perf stat -e "kvm:*" -a sleep Xs, in
> reporting the amount of times we actually do a pv tlb flush,
> instead of just the amount of times we happen to call
> record_steal_time().
> 
> Signed-off-by: Jon Kohler <jon@nutanix.com>
> ---
>  arch/x86/kvm/x86.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4790f0d7d40b..8d4e0e58ec34 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3410,9 +3410,9 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
>  
>  		vcpu->arch.st.preempted = 0;
>  
> -		trace_kvm_pv_tlb_flush(vcpu->vcpu_id,
> -				       st_preempted & KVM_VCPU_FLUSH_TLB);
>  		if (st_preempted & KVM_VCPU_FLUSH_TLB)
> +			trace_kvm_pv_tlb_flush(vcpu->vcpu_id,
> +				st_preempted & KVM_VCPU_FLUSH_TLB);

If you're going to trace only when a flush is needed, this should simply be:

			trace_kvm_pv_tlb_flush(vcpu->vcpu_id);

I haven't used this tracepoint often (at all?) so I don't have a strong preference,
but I can see the "no TLB flush needed" information being extremely valuable when
debugging a supsected TLB flushing bug.

>  			kvm_vcpu_flush_tlb_guest(vcpu);
>  
>  		if (!user_access_begin(st, sizeof(*st)))
> -- 
> 2.30.1 (Apple Git-130)
> 
