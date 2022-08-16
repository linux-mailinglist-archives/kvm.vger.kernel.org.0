Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F195596626
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 01:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237732AbiHPXrR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 19:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237709AbiHPXrQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 19:47:16 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67585923EE
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 16:47:15 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id g18so2098279pju.0
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 16:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=5I6RTqDOYa53Ga5yT1kW46Vdp+Uz59TMTU49zrpVpZ4=;
        b=XahC66DdGn+agQI0pc31yzizJMJ1Zho5LoiD2Cv4NyhYTfefAwh8HaiN/xupDWdH6r
         yJ5aYpR/gmfekm+vnC/fmYLvaVMcGQ5+jn+fFxplgl9E3gmebFB2awxHH5IUdee+NSmn
         fIW6f4yoCI+mEBfGf839i2GbCPD02qg4wLE3XK8cIZdLoOiD2/mJlGt2XIKFudNTsgh0
         /7BJfQyRpZAKlQnNfbP+Y/gQ0yc4qHMpxpGaHEVeYttVDnWfJEUbVT37PVKtNAfvBIXD
         iLERMw1UEbXLf1XYfJBGSEjELqN9l+3hbnq+0LYuEE3jdiZAe0KJ/2k67LU4vDZoVY9E
         OGmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=5I6RTqDOYa53Ga5yT1kW46Vdp+Uz59TMTU49zrpVpZ4=;
        b=KMEETEgcwyJrdWClKrFeD6HIDfTXkHJ9sToi+gcXEQ34RoX9X9TuNW34QeI+WhIdPA
         P3WZ4phSZnJ27iJzMUWOuPeB59weXjgSWFOJOFqsmXOy4lTyPm0sif2izQJglsqg8vss
         iNSmXZghsCkm615H7p/akjJ5a/I4zjdIqqzZktCrq/Rc8PJzcmtf026PcyC9lChvCL/n
         cXsTy49HOAOrAQOQyTlXYjVLHygPFpa4I0RdQdSQCRV9icINFwB0H254LPLZ8U/vroBe
         plli9ErrMkixUMvrhPxn+e5ogbmcByVZbzWKfcgDd/qXjp5saD9q7npUY3DBPNxKuplN
         HObw==
X-Gm-Message-State: ACgBeo274hlBe+t275zP5OsoiFgZWwYJe5CSbtr+nK0KTI+MV8TJWJav
        CHPhGc7HHM29EqvEGcTTJ+oaUA==
X-Google-Smtp-Source: AA6agR7HdHtLueviC0KVRh+biXQgWknzwM4mBFRz1dXCwE2JSiJE9mBG4zYniBpBTfTFeriAX2cxsQ==
X-Received: by 2002:a17:90b:38cf:b0:1f5:6e50:5abc with SMTP id nn15-20020a17090b38cf00b001f56e505abcmr941088pjb.83.1660693634838;
        Tue, 16 Aug 2022 16:47:14 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id o3-20020a170902778300b0016d5b7fb02esm9603498pll.60.2022.08.16.16.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 16:47:14 -0700 (PDT)
Date:   Tue, 16 Aug 2022 23:47:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        mlevitsk@redhat.com, vkuznets@redhat.com
Subject: Re: [PATCH v2 6/9] KVM: x86: make vendor code check for all nested
 events
Message-ID: <Yvwsf61D8wbwkAh7@google.com>
References: <20220811210605.402337-1-pbonzini@redhat.com>
 <20220811210605.402337-7-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220811210605.402337-7-pbonzini@redhat.com>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 11, 2022, Paolo Bonzini wrote:
> Interrupts, NMIs etc. sent while in guest mode are already handled
> properly by the *_interrupt_allowed callbacks, but other events can
> cause a vCPU to be runnable that are specific to guest mode.
> 
> In the case of VMX there are two, the preemption timer and the
> monitor trap.  The VMX preemption timer is already special cased via
> the hv_timer_pending callback, but the purpose of the callback can be
> easily extended to MTF or in fact any other event that can occur only
> in guest mode.
> 
> Rename the callback and add an MTF check; kvm_arch_vcpu_runnable()
> now will return true if an MTF is pending, without relying on
> kvm_vcpu_running()'s call to kvm_check_nested_events().  Until that call
> is removed, however, the patch introduces no functional change.
> 
> Reported-by: Maxim Levitsky <mlevitsk@redhat.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 2 +-
>  arch/x86/kvm/vmx/nested.c       | 9 ++++++++-
>  arch/x86/kvm/x86.c              | 8 ++++----
>  3 files changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 5ffa578cafe1..293ff678fff5 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1636,7 +1636,7 @@ struct kvm_x86_nested_ops {
>  	int (*check_events)(struct kvm_vcpu *vcpu);
>  	bool (*handle_page_fault_workaround)(struct kvm_vcpu *vcpu,
>  					     struct x86_exception *fault);
> -	bool (*hv_timer_pending)(struct kvm_vcpu *vcpu);
> +	bool (*has_events)(struct kvm_vcpu *vcpu);
>  	void (*triple_fault)(struct kvm_vcpu *vcpu);
>  	int (*get_state)(struct kvm_vcpu *vcpu,
>  			 struct kvm_nested_state __user *user_kvm_nested_state,
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index ddd4367d4826..9631cdcdd058 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3876,6 +3876,13 @@ static bool nested_vmx_preemption_timer_pending(struct kvm_vcpu *vcpu)
>  	       to_vmx(vcpu)->nested.preemption_timer_expired;
>  }
>  
> +static bool vmx_has_nested_events(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +
> +	return nested_vmx_preemption_timer_pending(vcpu) || vmx->nested.mtf_pending;

How about:

	return nested_vmx_preemption_timer_pending(vcpu) ||
	       to_vmx(vcpu)->nested.mtf_pending;

to use less lines and honor the 80 char soft-limit?
