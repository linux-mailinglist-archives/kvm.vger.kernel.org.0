Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8C1D67F35E
	for <lists+kvm@lfdr.de>; Sat, 28 Jan 2023 01:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbjA1A4M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 19:56:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjA1A4L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 19:56:11 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4CB67EFC9
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 16:56:09 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id b24-20020a17090a551800b0022beefa7a23so10260821pji.5
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 16:56:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ozfLCO2npdrJynERlE33uFzCm7IMCruhdgNJtLeXOSI=;
        b=mOnVOXg0Bg8trfHG/KI0XYEB10fh1pEhOaGWO4suWOZoD0uLkBx6cZvncWPeKhxWpl
         s8JNOgbu3VVfb/i+VXrGQSfE84tyX6L1gCVea4RnHnKIJ6V61t2HbKBZQzmbNIWg4XWO
         VxbM8NyFedZ+KeLXTNN0UhZX83jt/7WNcdBWtNJgCZSqfAYdjq87Zga+SwIot/sGUJBn
         MJDUwp5dQUO+sKfNyb1U4n+uTVdr5MrWWrnydCxUC54OggxtAgKchqDfgKvw8cXnQVBP
         AdXC5YrIu4cb/WiVErTzD5KDjcfLfMvUgvbuoMohvNScg35DvTkZ/MoR/x4OknZpWzIT
         4uHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ozfLCO2npdrJynERlE33uFzCm7IMCruhdgNJtLeXOSI=;
        b=xbo19kG1afeEz4nkF3Foj58tuoFCb6ojDyeLJvFRGJl3meme64dDz6PYIjy64F+2ln
         TS1MFiZS7/RQbfaIiKGFJfB90jYU5WsEHiWnutlYBjeutXJDAuRwEjdhk4mF4JkkKpcy
         umLHKtYXO+JB2Gtg//W/M+f2ARtvlLtTZwtFjf5SCkGKRDm6zCgXzyBJ5ppouZfifJ4X
         PNUP+egzImtchYxVVXyHHnhW7FZWtWyKTu8SXiB9QqJsr2CvIBN/ZyFJwaX7Wue9kZkm
         +UvzBxu1cy0N6kfVuaOA/Z2Dq8ApufkImq4MlGDhltTpraHmwCZzuiSguyOG595Bnihx
         gGJQ==
X-Gm-Message-State: AO0yUKWp8n1cSqVQvuMdWMP8chB7ab9kY0t802YI5pjC2Udp+6Y0Q6/C
        w9AzY1wTPg5Ny4KItr8+36kNcavLGPB5gOJd7fc=
X-Google-Smtp-Source: AK7set9yz6vM0tEl3QtE4FycCZlMQAk2ym6nmhVybXzPJdelofjDNAX4kviO3aOqD4ycsfgrQ4VErw==
X-Received: by 2002:a05:6a21:33aa:b0:b9:14e:184b with SMTP id yy42-20020a056a2133aa00b000b9014e184bmr239387pzb.3.1674867369011;
        Fri, 27 Jan 2023 16:56:09 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i67-20020a639d46000000b004cc95c9bd97sm2938564pgd.35.2023.01.27.16.56.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 16:56:08 -0800 (PST)
Date:   Sat, 28 Jan 2023 00:56:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 03/11] KVM: nSVM: explicitly raise KVM_REQ_EVENT on
 nested VM exit if L1 doesn't intercept interrupts
Message-ID: <Y9RypRsfpLteK51v@google.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
 <20221129193717.513824-4-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129193717.513824-4-mlevitsk@redhat.com>
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

Shortlog is too long, maybe this?

  KVM: nSVM: Raise event on nested VM exit if L1 doesn't intercept IRQs

On Tue, Nov 29, 2022, Maxim Levitsky wrote:
> If the L2 doesn't intercept interrupts, then the KVM will use vmcb02's

s/the L2/L2, though don't you mean L1?

> V_IRQ for L1 (to detect the interrupt window)

"an interrupt window", i.e. there's not just one window.

> In this case on the nested VM exit KVM might need to copy the V_IRQ bit

s/the nested/nested

> from the vmcb02 to the vmcb01, to continue waiting for the
> interrupt window.
> 
> To make it simple, just raise the KVM_REQ_EVENT request, which
> execution will lead to the reenabling of the interrupt
> window if needed.
> 
> Note that this is a theoretical bug because the KVM already does raise

s/the KVM/KVM

> the KVM_REQ_EVENT request one each nested VM exit because the nested

s/the KVM_REQ_EVENT/KVM_REQ_EVENT, and s/one/on

> VM exit resets RFLAGS and the kvm_set_rflags() raises the
> KVM_REQ_EVENT request in the response.
> 
> However raising this request explicitly, together with
> documenting why this is needed, is still preferred.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index aad3145b2f62fe..e891318595113e 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1016,6 +1016,31 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>  
>  	svm_switch_vmcb(svm, &svm->vmcb01);
>  
> +	/* Note about synchronizing some of int_ctl bits from vmcb02 to vmcb01:

	/*
	 * Preferred block comment style...

> +	 *
> +	 * - V_IRQ, V_IRQ_VECTOR, V_INTR_PRIO_MASK, V_IGN_TPR:

Drop the "-" to be consistent with the rest of the paragraphs.

> +	 * If the L2 doesn't intercept interrupts, then
> +	 * (even if the L2 does use virtual interrupt masking),

KVM uses "L2" to refer to the thing running at L2.  I think what you are referring
to here is vmcb12?  And that's controlled by L1.

> +	 * KVM will use the vmcb02's V_INTR to detect interrupt window.

s/the vmcb02/vmcb02

Which of the V_INTR fields does this refer to?  Oooh, you're saying the KVM injects
a virtual interrupt into L2 using vmcb02 in order to determine when L2 has IRQs
enabled.

Why does KVM do that?  Why not pend the actual IRQ directly?  

> +	 *
> +	 * In this case, the KVM raises the KVM_REQ_EVENT to ensure that interrupt window

s/the KVM_REQ_EVENT/KVM_REQ_EVENT

> +	 * is not lost and this implicitly copies these bits from vmcb02 to vmcb01

Too many pronouns.  What do "this" and "these bits" refer to?

> +	 *
> +	 * V_TPR:
> +	 * If the L2 doesn't use virtual interrupt masking, then the L1's vTPR
> +	 * is stored in the vmcb02 but its value doesn't need to be copied from/to
> +	 * vmcb01 because it is copied from/to the TPR APIC's register on
> +	 * each VM entry/exit.
> +	 *
> +	 * V_GIF:
> +	 * - If the nested vGIF is not used, KVM uses vmcb02's V_GIF for L1's V_GIF,

Drop this "-" too.

> +	 * however, the L1 vGIF is reset to false on each VM exit, thus
> +	 * there is no need to copy it from vmcb02 to vmcb01.
> +	 */
> +
> +	if (!nested_exit_on_intr(svm))
> +		kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
> +
>  	if (unlikely(svm->lbrv_enabled && (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))) {
>  		svm_copy_lbrs(vmcb12, vmcb02);
>  		svm_update_lbrv(vcpu);
> -- 
> 2.26.3
> 
