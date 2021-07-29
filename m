Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71AB83DAED5
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 00:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233043AbhG2W1n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 18:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232169AbhG2W1i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 18:27:38 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124EEC061765
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 15:27:34 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id q2so8656391plr.11
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 15:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=U7V9Ap3CLbBdQCnG02pu0xdSqMhicUYByn9SxkAU8rw=;
        b=Ffk8XpysnuqjpLBT6TZqn4W5/OEbtQF8oVqJwVgwx/tfDyKtg04s3+tvbENJTzrV5J
         4NJrhbizq83pOW9DriO0IT1D4PRHNil84BWsETrNpx1o81V0zVMAYWrhvFiYbCRUk2MD
         zG5yXj3ZhDiLFDAKQK4BizaWGfbivzK8Ia7+s06Ffs9L6mTHg6b2P3eFLnVlrfwT7WPO
         zByAMI0AQb70/64I2++woOOagf26a1zTqhRimG2LA8iijcdW37HJhjl3r+9q2qJIk7SM
         e9i3dvi3rB1sEJuHMPEhTCJ5YGvU3pkRsprjZZm28ZHEaP82OdR6kEcxqbW5GzfTj/Ng
         aG5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U7V9Ap3CLbBdQCnG02pu0xdSqMhicUYByn9SxkAU8rw=;
        b=jpmA6wCT54NQkPqs2k9i4uLseHXoo8tTgzQL/tQ1uuB73pL8Wf47z1WPZKSni9m2AB
         JS/HZ9XEUYAWhqy1ytuhPqoTzSEUVmU8d2mBxslpaqz6Bk/x2pl7Y9vaHv49tQNrQxvR
         czWbsXTqspd+Gbf4NawJk0oLJdx+A9UZeK2e1w/fwRK5sD8t5sIdgipoHxS1Q8nPTHWR
         wG5rIoQX7vtoxNZ6X+jnCNoMR9x4pQ5fJZlzNZS9/je3xmn6CdOp22mz0V8sk9ZEzhhP
         zyzuU36sFWX4djwVaJOAiKuRXlzrAENtgeOvv0jDS3Xe7rMLCCxwq3hYGDd5HCnAw+H9
         W+bw==
X-Gm-Message-State: AOAM533b+pI3buKge4pGVcrvhDSupPA2qH+6GWxprDi7QZzg/E2Lm3HA
        K8V5Ci24j+OOOQNrJJUI3H1D2Q==
X-Google-Smtp-Source: ABdhPJwUIJmnIsqgtiT+cHGl4vPiaiiOn9b6WyOeTGaDzqUNureByRM1AZxpT7XVVs9zcWtSUdzInA==
X-Received: by 2002:a17:902:d492:b029:12b:dd74:5c79 with SMTP id c18-20020a170902d492b029012bdd745c79mr6407841plg.45.1627597653314;
        Thu, 29 Jul 2021 15:27:33 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z124sm5138144pgb.6.2021.07.29.15.27.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 15:27:32 -0700 (PDT)
Date:   Thu, 29 Jul 2021 22:27:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Edmondson <david.edmondson@oracle.com>
Cc:     linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH v3 1/3] KVM: x86: kvm_x86_ops.get_exit_info should
 include the exit reason
Message-ID: <YQMrUOjZMD1eiIeE@google.com>
References: <20210729133931.1129696-1-david.edmondson@oracle.com>
 <20210729133931.1129696-2-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210729133931.1129696-2-david.edmondson@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Shortlog is a bit odd, "should" is subjective and makes this sound like a bug fix.

  KVM: x86: Get exit_reason as part of kvm_x86_ops.get_exit_info

On Thu, Jul 29, 2021, David Edmondson wrote:
> Extend the get_exit_info static call to provide the reason for the VM
> exit. Modify relevant trace points to use this rather than extracting
> the reason in the caller.
> 
> Signed-off-by: David Edmondson <david.edmondson@oracle.com>
> ---
> -static void svm_get_exit_info(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2,
> +static void svm_get_exit_info(struct kvm_vcpu *vcpu, u64 *reason,
> +			      u64 *info1, u64 *info2,
>  			      u32 *intr_info, u32 *error_code)
>  {
>  	struct vmcb_control_area *control = &to_svm(vcpu)->vmcb->control;
>  
> +	*reason = control->exit_code;
>  	*info1 = control->exit_info_1;
>  	*info2 = control->exit_info_2;
>  	*intr_info = control->exit_int_info;

...

> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index b484141ea15b..2228565beda2 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -273,11 +273,11 @@ TRACE_EVENT(kvm_apic,
>  
>  #define TRACE_EVENT_KVM_EXIT(name)					     \
>  TRACE_EVENT(name,							     \
> -	TP_PROTO(unsigned int exit_reason, struct kvm_vcpu *vcpu, u32 isa),  \
> -	TP_ARGS(exit_reason, vcpu, isa),				     \
> +	TP_PROTO(struct kvm_vcpu *vcpu, u32 isa),			     \
> +	TP_ARGS(vcpu, isa),						     \
>  									     \
>  	TP_STRUCT__entry(						     \
> -		__field(	unsigned int,	exit_reason	)	     \
> +		__field(	u64,		exit_reason	)	     \

Converting to a u64 is unnecessary and misleading.  vmcs.EXIT_REASON and
vmcb.EXIT_CODE are both u32s, a.k.a. unsigned ints.  There is vmcb.EXIT_CODE_HI,
but that's not being included, and AFAICT isn't even sanity checked by KVM.

>  		__field(	unsigned long,	guest_rip	)	     \
>  		__field(	u32,	        isa             )	     \
>  		__field(	u64,	        info1           )	     \
