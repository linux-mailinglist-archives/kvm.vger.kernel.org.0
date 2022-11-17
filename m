Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43C6A62E5AE
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 21:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239637AbiKQUPn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 15:15:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234714AbiKQUPi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 15:15:38 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9B3391C8
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 12:15:37 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id j12so2666492plj.5
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 12:15:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FKaAaO2JiMXd5BO9cYY7mxY69aMokGH42PJ3aty1JqY=;
        b=b2GRdnqhU3pD4/8xEoqXhW40FmR/j4VcJDQI0DoSgquAn8sdmxhfqCapIWlJUgZQa3
         VOPX8HKFBU1JnJhN0pZK9xNsmeL42aOG/MvHjHrx2rjU9G28jysShLjz2Z7S+IjjZJ/5
         h1xgtzS6hsdOASV3BvQ9XTeSyDuRRfsMk4v/7V4TvvUhPUNCbq2F2eqD0squ9u0/TqWj
         2RX7RYBmAVHwkJvpqq98cvSIbFe0GE4zA59mvHW2JHTrV6R827O7l2a5W8EVe1CBLlzA
         o9W8fwZW4RqPAg2Mv978U7pPzrQuFsKfbDlur+7CzSuRFBooX1h/IwV0t/LGD4HOTFTO
         a+0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FKaAaO2JiMXd5BO9cYY7mxY69aMokGH42PJ3aty1JqY=;
        b=xPENPNzCMjkKjNWPjxZqRYPCqkRWbKY3GL03+ksTT12Nv6syAcpcVzn1mZ4q7u7sHE
         K6ipztGbHz+adCQ58e8TvGjofLbHaRez9ugZLFh4rMZ/FgbZ/K9TQeBzS1CS5bgZxzr6
         jt6JW/ZVEw24ySCAq2Xa1ZHpYVEbjuC419v/0iFZyd2As9hUDsbGOFFchL3hM2Sp7Pc5
         5mH3fqMmMEAt0wla0HGk+6XzqnZdm7iXEobuzK+3PiwlX3beU1fQWu7Te15TwI/Cfi5X
         tSob/6eqT3ytS1EQGkF+o21ATepVK1jhbOqc3GZOCvqCWa2nVE70jmzO9yklqndLvczo
         TzUg==
X-Gm-Message-State: ANoB5pnW1JeeNsGbzZnbIF57cwW4YgxAdYzDF9Sbcqi/8d2wpzcqLtB1
        lTO5dteWYgr8qSWpFzQ2/PEGaQ==
X-Google-Smtp-Source: AA0mqf67QuuiMrO2wXKHK/2youUeCOiE4VcDC4sZ2fePMEKQnBUNLWkjduVFKIPt/ZfMPcbZeXHsxw==
X-Received: by 2002:a17:902:c7d2:b0:17f:6aef:3c83 with SMTP id r18-20020a170902c7d200b0017f6aef3c83mr4361887pla.9.1668716136647;
        Thu, 17 Nov 2022 12:15:36 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id t5-20020a6564c5000000b0046ae5cfc3d5sm1373035pgv.61.2022.11.17.12.15.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 12:15:36 -0800 (PST)
Date:   Thu, 17 Nov 2022 20:15:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sandipan Das <sandipan.das@amd.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jing Liu <jing2.liu@intel.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Wyes Karny <wyes.karny@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Babu Moger <babu.moger@amd.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org
Subject: Re: [PATCH 04/13] KVM: nSVM: clean up copying of int_ctl fields back
 to vmcb01/vmcb12
Message-ID: <Y3aWZJo8M2li/7BB@google.com>
References: <20221117143242.102721-1-mlevitsk@redhat.com>
 <20221117143242.102721-5-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117143242.102721-5-mlevitsk@redhat.com>
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

On Thu, Nov 17, 2022, Maxim Levitsky wrote:
> Clean up the nested_sync_int_ctl_from_vmcb02:
> 
> 1. The comment about preservation of V_IRQ is wrong: when the L2 doesn't
>    use virtual interrupt masking, then the field just doesn't exist in
>    vmcb12 thus it should not be touched at all.
>    Since it is unused in this case, touching it doesn't matter that much,
>    so the bug is theoretical.
> 
> 2. When the L2 doesn't use virtual interrupt masking, then in the *theory*
>    if KVM uses the feature, it should copy the changes to V_IRQ* bits from
>    vmcb02 to vmcb01.
> 
>    In practise, KVM only uses it for detection of the interrupt window,
>    and it happens to re-open it on each nested VM exit because
>    kvm_set_rflags happens to raise the KVM_REQ_EVENT.
>    Do this explicitly.
> 
> 3. Add comment on why we don't need to copy V_GIF from vmcb02 to vmcb01
>    when nested guest doesn't use nested V_GIF (and thus L1's GIF is in
>    vmcb02 while nested), even though it can in theory affect L1's GIF.
> 
> 4. Add support code to also copy some bits of int_ctl from
>    vmcb02 to vmcb01.
>    Currently there are none.

Unless it's impossible for whatever reason, this patch should be split into
multiple patches.  IIUC, there are at least 2 different functional changes being
made, they just happen to not have any actual impact on things.

> No (visible) functional change is intended.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c | 47 ++++++++++++++++++++++++++-------------
>  1 file changed, 32 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 54eb152e2b60b6..1f2b8492c8782f 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -410,28 +410,45 @@ void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
>  static void nested_sync_int_ctl_from_vmcb02(struct vcpu_svm *svm,
>  					    struct vmcb *vmcb12)
>  {
> -	u32 mask;
> +	struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
> +	struct vmcb *vmcb01 = svm->vmcb01.ptr;
> +
> +	/* bitmask of bits of int_ctl that we copy from vmcb02 to vmcb12*/
> +	u32 l2_to_l1_mask = 0;
> +	/* bitmask of bits of int_ctl that we copy from vmcb02 to vmcb01*/
> +	u32 l2_to_l0_mask = 0;
>  
> -	/* Only a few fields of int_ctl are written by the processor.  */

Can this comment be kept in some form?  I found it super useful when reading this
code just now.

> -	mask = V_IRQ_MASK | V_TPR_MASK;
> -	if (!(svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK) &&
> -	    svm_is_intercept(svm, INTERCEPT_VINTR)) {
> +	if (svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK)
> +		l2_to_l1_mask |= V_IRQ_MASK | V_TPR_MASK;
> +	else {
>  		/*
> -		 * In order to request an interrupt window, L0 is usurping
> -		 * svm->vmcb->control.int_ctl and possibly setting V_IRQ
> -		 * even if it was clear in L1's VMCB.  Restoring it would be
> -		 * wrong.  However, in this case V_IRQ will remain true until
> -		 * interrupt_window_interception calls svm_clear_vintr and
> -		 * restores int_ctl.  We can just leave it aside.
> +		 * If IRQ window was opened while in L2, it must be reopened
> +		 * after the VM exit
> +		 *
> +		 * vTPR value doesn't need to be copied from vmcb02 to vmcb01
> +		 * because it is synced from/to apic registers on each VM exit
>  		 */
> -		mask &= ~V_IRQ_MASK;
> +		if (vmcb02->control.int_ctl & V_IRQ_MASK)
> +			kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
>  	}
>  
>  	if (nested_vgif_enabled(svm))
> -		mask |= V_GIF_MASK;
> +		l2_to_l1_mask |= V_GIF_MASK;
> +	else
> +		/* There is no need to sync V_GIF from vmcb02 to vmcb01
> +		 * because GIF is cleared on VMexit, thus even though
> +		 * nested guest can control host's GIF, on VM exit
> +		 * its set value is lost
> +		 */
> +		;

The "else ... ;" is unnecessary, just throw the block comment above the nested
vGIF if-statment, e.g. if I'm understanding everything, this?

	/*
	 * If nested vGIF is not enabled, L2 has access to L1's "real" GIF.  In
	 * this case, there's no need to sync V_GIF from vmcb02 to vmcb01
	 * because GIF is cleared on VM-Exit, thus any changes made by L2 are
	 * overwritten on VM-Exit to L1.
	 */
	if (nested_vgif_enabled(svm))
		l2_to_l1_mask |= V_GIF_MASK;

> +
> +	vmcb12->control.int_ctl =
> +		(svm->nested.ctl.int_ctl & ~l2_to_l1_mask) |
> +		(vmcb02->control.int_ctl & l2_to_l1_mask);
>  
> -	vmcb12->control.int_ctl        &= ~mask;
> -	vmcb12->control.int_ctl        |= svm->vmcb->control.int_ctl & mask;
> +	vmcb01->control.int_ctl =
> +		(vmcb01->control.int_ctl & ~l2_to_l0_mask) |
> +		(vmcb02->control.int_ctl & l2_to_l0_mask);

No need for wrapping immediately after the "=", these all fit under the soft limit:

	vmcb12->control.int_ctl = (svm->nested.ctl.int_ctl & ~l2_to_l1_mask) |
				  (vmcb02->control.int_ctl & l2_to_l1_mask);

	vmcb01->control.int_ctl = (vmcb01->control.int_ctl & ~l2_to_l0_mask) |
				  (vmcb02->control.int_ctl & l2_to_l0_mask);
