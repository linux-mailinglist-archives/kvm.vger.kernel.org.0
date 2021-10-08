Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3A1427440
	for <lists+kvm@lfdr.de>; Sat,  9 Oct 2021 01:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243808AbhJHXjf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 19:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231927AbhJHXje (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 19:39:34 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1DCC061755
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 16:37:39 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id r2so4512274pgl.10
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 16:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BuBI5iKefFRLCj8qSEOtaFgIHAVN2JvTa8QX6WSBdcw=;
        b=k7X1jnqkw6qOgoEgLYUI53gHlllgX3jCrlrqhnqLu9rm9Fcepxybi/bwISx5zAYVPK
         hUbXS36G5USw9ubyrTT64Ka7gfAZjSMQ6iDFjqRBhWfkS3SbhascneGY/B9xz5InOtA7
         iPUWVyee2lFIKYmEe/ZKa3xXHXUVoa+SyF8o5AAOfJb17luM31YMo6v3eZ9ACYpmxDpX
         uX4XmDvbCpVg0CBCl/qgqExwKlrJmfTY54T65bjZ12TfS/NlvPd2puXSYR4HMzFSB6Js
         ERNFyta4LO0OVZum+a60RT5EV45+jLshXvRxabTXwg0OJ4DADsfuynSeVq3a5VUJIsG6
         5Yuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BuBI5iKefFRLCj8qSEOtaFgIHAVN2JvTa8QX6WSBdcw=;
        b=iR2gNr6wSNgwo0QeGmrT3SEKNoFlfdbR5yqhKCt3fcDnGJvIzN3BQmN3Xb+OEXNuti
         oTayjPvIbPyoM3hKz82wHIkfrqnPwDVUmKi5GPXn8PBJ+2f3ONYNf43P4Vk1tPxWHMeE
         qemzg+GMrh7W0tBi+Uu0CYQBEoJa8IpMb3vw3PMfErWL4oB4cNsFuOwy3tZGTFjsmtNX
         eh/vqXvHU9GFSqafnq4Ie+bzjoMF0hydxCZxG4JN0iIXJW5KxAYs01gWS3jUVQWNsI6l
         DZOJbBSYiYs8G6KkzkR1t3U0ObDWt5bQOCoRRF0Pk7S715j7hXR4gk/uK0yR24XeTeUN
         L3VQ==
X-Gm-Message-State: AOAM532jRk7Mmr6b6R5tQR73t29HyM15VTG02gLJKOZABM34oXhUzNI9
        1+xBrE+AqKEuDJQtema46UlYbDvrgFXn6Q==
X-Google-Smtp-Source: ABdhPJxJZmJvQikayXcv/x9id0NaFsL6SB6DmQJy0rJeP+KMjRSC0aZ8Npy16gr4d4ApnR0KNR9W0g==
X-Received: by 2002:a05:6a00:2146:b0:44c:2922:8abf with SMTP id o6-20020a056a00214600b0044c29228abfmr12621503pfk.27.1633736258255;
        Fri, 08 Oct 2021 16:37:38 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k1sm261987pjj.54.2021.10.08.16.37.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 16:37:37 -0700 (PDT)
Date:   Fri, 8 Oct 2021 23:37:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v2 5/6] KVM: nVMX: don't fail nested VM entry on invalid
 guest state if !from_vmentry
Message-ID: <YWDWPbgJik5spT1D@google.com>
References: <20210830125539.1768833-1-mlevitsk@redhat.com>
 <20210830125539.1768833-6-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210830125539.1768833-6-mlevitsk@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 30, 2021, Maxim Levitsky wrote:
> It is possible that when non root mode is entered via special entry
> (!from_vmentry), that is from SMM or from loading the nested state,
> the L2 state could be invalid in regard to non unrestricted guest mode,
> but later it can become valid.
> 
> (for example when RSM emulation restores segment registers from SMRAM)
> 
> Thus delay the check to VM entry, where we will check this and fail.

And then do what?  Won't invalidate state send KVM into handle_invalid_guest_state(),
which we very much don't want to do for L2?  E.g. this is meant to fire, but won't
because nested_run_pending is false for the !from_vmentry paths.

	/*
	 * We should never reach this point with a pending nested VM-Enter, and
	 * more specifically emulation of L2 due to invalid guest state (see
	 * below) should never happen as that means we incorrectly allowed a
	 * nested VM-Enter with an invalid vmcs12.
	 */
	if (KVM_BUG_ON(vmx->nested.nested_run_pending, vcpu->kvm))
		return -EIO;

> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 7 ++++++-
>  arch/x86/kvm/vmx/vmx.c    | 5 ++++-
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index bc6327950657..1a05ae83dae5 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2546,8 +2546,13 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>  	 * Guest state is invalid and unrestricted guest is disabled,
>  	 * which means L1 attempted VMEntry to L2 with invalid state.
>  	 * Fail the VMEntry.
> +	 *
> +	 * However when force loading the guest state (SMM exit or
> +	 * loading nested state after migration, it is possible to
> +	 * have invalid guest state now, which will be later fixed by
> +	 * restoring L2 register state
>  	 */
> -	if (CC(!vmx_guest_state_valid(vcpu))) {
> +	if (CC(from_vmentry && !vmx_guest_state_valid(vcpu))) {
>  		*entry_failure_code = ENTRY_FAIL_DEFAULT;
>  		return -EINVAL;
>  	}
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 1c113195c846..02d061f5956a 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6624,7 +6624,10 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  	 * consistency check VM-Exit due to invalid guest state and bail.
>  	 */
>  	if (unlikely(vmx->emulation_required)) {
> -		vmx->fail = 0;
> +
> +		/* We don't emulate invalid state of a nested guest */
> +		vmx->fail = is_guest_mode(vcpu);

This is contradictory and wrong.  (a) it's impossible to have both a VM-Fail and
VM-Exit, (b) vmcs.EXIT_REASON is not modified on VM-Fail, and (c) emulation_required
refers to guest state and guest state checks are always VM-Exits, not VM-Fails.

I don't understand this change, AFAICT vmx->fail won't actually be consumed as
either the above KVM_BUG_ON() will be hit or KVM will incorrectly emulate L2
state.

> +
>  		vmx->exit_reason.full = EXIT_REASON_INVALID_STATE;
>  		vmx->exit_reason.failed_vmentry = 1;
>  		kvm_register_mark_available(vcpu, VCPU_EXREG_EXIT_INFO_1);
> -- 
> 2.26.3
> 
