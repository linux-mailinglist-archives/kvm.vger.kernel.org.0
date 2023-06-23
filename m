Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20B9573C41F
	for <lists+kvm@lfdr.de>; Sat, 24 Jun 2023 00:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjFWWa2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 18:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbjFWWa0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 18:30:26 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B132693
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 15:30:22 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bfee66a6398so1433712276.3
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 15:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687559421; x=1690151421;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ppnF/aw1UnKTB9rbk7d1XJO3FUzzFPQL3mAmvvlJvvk=;
        b=MTDj+PfQEs89HXO3zua52f+xW70UlbpERfN9PVQS2ScE+E5cqLfBWGAeiFNwLI+h8W
         rnw02hXt7OWkMK4GD8ae4hlslf9skO74QM4px4MRHqYJTsbOhLPOcIgUocHbVtAFbyb2
         LEuUv2xkfmEHiRMecz+e1Iwh1NALy7IdIK4Nvs13PhIrkKg1Q6hA9TH+4m947l8ftcFP
         ucN2XPaM8nRku3j+cae3v4t55rwmD76H75jFQzhvtNiw3xXKk/z6t6pK2pB42WeG97Rc
         +BDJ9dv30gyz0cEUazriP1GfHMYv6Sg4wfZIVgKzRLHDERIdNxr//tUbZVOfjwm9mncj
         D87g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687559421; x=1690151421;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ppnF/aw1UnKTB9rbk7d1XJO3FUzzFPQL3mAmvvlJvvk=;
        b=gEKNHh61R5ztW5nqHqBYYk9pa1+9neRoKReVvQ+6Mo/xGXwh5auLJILqFrhyyNEiHR
         iuSjR63AvzYx1rcMCVc4At1LA+H1uav2f29eDZVtqsyHNa3x1AtGZrrWIy++o5+vty17
         MHcMT4cjQNw8U0+9w/nddC7HOfylXFO3sQjQEsf5zP3PT2I+5Q1HJmQ+lw6TCAU0F/hY
         y1HsrLmOSwmuw8bqlgxkFDJeB5xlqyr6YZFis1t9BdD9+k8PwLO9uxI2nGnd9K9StE7F
         olG7+uiptuamm8rCiKVSyVUIXDsJtDDlvhf3WpHMm14hZPgwvOhWmS2Qr9m6DjCOc/Xd
         fujg==
X-Gm-Message-State: AC+VfDw4xyJedabP2i5/ygKnVeR7JWzkjNUSICZs1aKA5k9e74ItfJ/D
        JMgRrv0eSLKLrMjqclMa+ub7RCuj7AE=
X-Google-Smtp-Source: ACHHUZ5XST1V6QTVzRp4iXxtDryo3DAimovkh8fN5aBSif2NZ8wPonUnuPKMV/WXEiTr99p6wVqEVPNbQlU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:711:0:b0:bac:fd27:28c1 with SMTP id
 g17-20020a5b0711000000b00bacfd2728c1mr9819038ybq.0.1687559421504; Fri, 23 Jun
 2023 15:30:21 -0700 (PDT)
Date:   Fri, 23 Jun 2023 15:30:19 -0700
In-Reply-To: <20230511040857.6094-17-weijiang.yang@intel.com>
Mime-Version: 1.0
References: <20230511040857.6094-1-weijiang.yang@intel.com> <20230511040857.6094-17-weijiang.yang@intel.com>
Message-ID: <ZJYc+4fN3K+h8VhM@google.com>
Subject: Re: [PATCH v3 16/21] KVM:x86: Save/Restore GUEST_SSP to/from SMM
 state save area
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        rppt@kernel.org, binbin.wu@linux.intel.com,
        rick.p.edgecombe@intel.com, john.allen@amd.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 11, 2023, Yang Weijiang wrote:
> Save GUEST_SSP to SMM state save area when guest exits to SMM
> due to SMI and restore it VMCS field when guest exits SMM.

This fails to answer "Why does KVM need to do this?"

> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/smm.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
> index b42111a24cc2..c54d3eb2b7e4 100644
> --- a/arch/x86/kvm/smm.c
> +++ b/arch/x86/kvm/smm.c
> @@ -275,6 +275,16 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu,
>  	enter_smm_save_seg_64(vcpu, &smram->gs, VCPU_SREG_GS);
>  
>  	smram->int_shadow = static_call(kvm_x86_get_interrupt_shadow)(vcpu);
> +
> +	if (kvm_cet_user_supported()) {

This is wrong, KVM should not save/restore state that doesn't exist from the guest's
perspective, i.e. this needs to check guest_cpuid_has().

On a related topic, I would love feedback on my series that adds a framework for
features like this, where KVM needs to check guest CPUID as well as host support.

https://lore.kernel.org/all/20230217231022.816138-1-seanjc@google.com

> +		struct msr_data msr;
> +
> +		msr.index = MSR_KVM_GUEST_SSP;
> +		msr.host_initiated = true;

Huh?

> +		/* GUEST_SSP is stored in VMCS at vm-exit. */

(a) this is not VMX code, i.e. referencing the VMCS is wrong, and (b) how the
guest's SSP is managed is irrelevant, all that matters is that KVM can get the
current guest value.

> +		static_call(kvm_x86_get_msr)(vcpu, &msr);
> +		smram->ssp = msr.data;
> +	}
>  }
>  #endif
>  
> @@ -565,6 +575,16 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
>  	static_call(kvm_x86_set_interrupt_shadow)(vcpu, 0);
>  	ctxt->interruptibility = (u8)smstate->int_shadow;
>  
> +	if (kvm_cet_user_supported()) {
> +		struct msr_data msr;
> +
> +		msr.index = MSR_KVM_GUEST_SSP;
> +		msr.host_initiated = true;
> +		msr.data = smstate->ssp;
> +		/* Mimic host_initiated access to bypass ssp access check. */

No, masquerading as a host access is all kinds of wrong.  I have no idea what
check you're trying to bypass, but whatever it is, it's wrong.  Per the SDM, the
SSP field in SMRAM is writable, which means that KVM needs to correctly handle
the scenario where SSP holds garbage, e.g. a non-canonical address.

Why can't this use kvm_get_msr() and kvm_set_msr()?
