Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0A72EC326
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 19:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbhAFSSr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 13:18:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbhAFSSq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 13:18:46 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 807B2C06134D
        for <kvm@vger.kernel.org>; Wed,  6 Jan 2021 10:18:06 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id 30so2786741pgr.6
        for <kvm@vger.kernel.org>; Wed, 06 Jan 2021 10:18:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NEQ1MYnzF7TcdKZy8VrpaLMbduBeyVlT2e+TUjGJNaY=;
        b=iu2xU/sL+lzjuV36ffQZ0YAqQWFpHHC6727dMgaSbthN5GmXYmsL6Rr3HpwPZhlGLt
         w20l0v+maGbJ9s561bYl2QYluVVRXvGQ9dQUEmf/8XRWgWGemBW72rqWKTHN09Sx5KA5
         e+5TQ2d3021Ppbj4J3B721FFIKQcA1uU+fhSLwGxItiFH2nh9m7Hur2jHLLiapdyKz8j
         0G1yl8O/VdIW+uF9HS33A+Nwtx3pHTvD5C0bEPQFDQHj6HYtzWW3kkfUp2ZdIYlpwHY6
         5xXyKJR7m1XXYWM9gpDJKv09wSVwrsAh++gVXHjzY65wYLLPI0gHlh4hue8WDbLOe1Zt
         mY4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NEQ1MYnzF7TcdKZy8VrpaLMbduBeyVlT2e+TUjGJNaY=;
        b=SzTFXI/6WmN/FOwli79YmGGWqXgO72LpVMoWKUhnTlgS0YPTkBc5Y9rdodjN6PXl1j
         sw7KyM+6DNpo4yIUHKQXO/tL7edDqnN8WQ3cisZeLPozWmTltbOHG0m/iCf9OUuAr2vc
         V0jxQmgMw0A53sAos2SaSeVrCX4tOJpmKomb/RY8k0vnlxx+tva6youBvESk1/6PHfmi
         +ny4rWo7pJk9YM2So2TWN3ufBTvrRiq+DoAlCGUOQNghc+d/N1t8HGetCV7SsftMAB1W
         v4Nedt7Rgk3b2y2Fcs6KqLW/S9CJ6Tz3dFdn4LzWrMBIW/+YCuGciCgT3Oabv7ilMxxy
         zlDw==
X-Gm-Message-State: AOAM532przvAIHnVvKDtBElADRKBTyw1uNf5Moy9U85uacdwnVe/4d2/
        3Sydk7l2WOdywvvTe+88Xrju8w==
X-Google-Smtp-Source: ABdhPJzWxEaJoeIdiAMVUQ6wh2XJjam5RTKI+/OrWwshNKclDY1a5VsU6KFumG3nQky5srpujj9LlQ==
X-Received: by 2002:aa7:8f0e:0:b029:19e:5a34:8c85 with SMTP id x14-20020aa78f0e0000b029019e5a348c85mr5037655pfr.22.1609957085794;
        Wed, 06 Jan 2021 10:18:05 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id b5sm4011415pga.54.2021.01.06.10.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 10:18:05 -0800 (PST)
Date:   Wed, 6 Jan 2021 10:17:58 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] KVM: nVMX: fix for disappearing L1->L2 event
 injection on L1 migration
Message-ID: <X/X+1q6H/q1Ez6zE@google.com>
References: <20210106105306.450602-1-mlevitsk@redhat.com>
 <20210106105306.450602-3-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210106105306.450602-3-mlevitsk@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 06, 2021, Maxim Levitsky wrote:
> If migration happens while L2 entry with an injected event to L2 is pending,
> we weren't including the event in the migration state and it would be
> lost leading to L2 hang.

But the injected event should still be in vmcs12 and KVM_STATE_NESTED_RUN_PENDING
should be set in the migration state, i.e. it should naturally be copied to
vmcs02 and thus (re)injected by vmx_set_nested_state().  Is nested_run_pending
not set?  Is the info in vmcs12 somehow lost?  Or am I off in left field...
 
> Fix this by queueing the injected event in similar manner to how we queue
> interrupted injections.
> 
> This can be reproduced by running an IO intense task in L2,
> and repeatedly migrating the L1.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index e2f26564a12de..2ea0bb14f385f 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2355,12 +2355,12 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>  	 * Interrupt/Exception Fields
>  	 */
>  	if (vmx->nested.nested_run_pending) {
> -		vmcs_write32(VM_ENTRY_INTR_INFO_FIELD,
> -			     vmcs12->vm_entry_intr_info_field);
> -		vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE,
> -			     vmcs12->vm_entry_exception_error_code);
> -		vmcs_write32(VM_ENTRY_INSTRUCTION_LEN,
> -			     vmcs12->vm_entry_instruction_len);
> +		if ((vmcs12->vm_entry_intr_info_field & VECTORING_INFO_VALID_MASK))
> +			vmx_process_injected_event(&vmx->vcpu,
> +						   vmcs12->vm_entry_intr_info_field,
> +						   vmcs12->vm_entry_instruction_len,
> +						   vmcs12->vm_entry_exception_error_code);
> +
>  		vmcs_write32(GUEST_INTERRUPTIBILITY_INFO,
>  			     vmcs12->guest_interruptibility_info);
>  		vmx->loaded_vmcs->nmi_known_unmasked =
> -- 
> 2.26.2
> 
