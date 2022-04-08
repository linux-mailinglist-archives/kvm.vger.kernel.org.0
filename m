Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA81A4F9AC9
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 18:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233036AbiDHQih (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 12:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232916AbiDHQid (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 12:38:33 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1491EEE4C5
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 09:36:29 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id c23so8388377plo.0
        for <kvm@vger.kernel.org>; Fri, 08 Apr 2022 09:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pfTINF2/xfnGZVEw3z7BP1PK6XdQNXLNLCDBaw1lD30=;
        b=k3QEquPd6TbgYblR0v+H84O27eBKCRbzHIFxGdsYYB40L1E1Hg8j/KLx93Xi7dKNj/
         wSrZGo7VSZ27nRZuzyDGEFtUNlcz8DME06ys8Pf1kpzaYQJ4Yv/9J7YOJ2xt9yXAmUXJ
         XDgu5LFZ+RYji5fR2baD2MzYNqx3kQpm9QDaNfg0B1qQ1XuB7o3E1RlAJ96H+hBmftyH
         r4xacVo/0CRgDYxd4qWVcXs0kY5uTQhRzpirhWzT7XkVLveECKs4GK9GE/IfWKnL0g/o
         YmHn4NWd8SeJ2fpGKVQMT+3J7e9eQ80vgoql8JPSY7wVl/0ur/7XelAmQ3kL1ISVvkt3
         d8Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pfTINF2/xfnGZVEw3z7BP1PK6XdQNXLNLCDBaw1lD30=;
        b=n8lQCO0gZPeR8sMNqBReYnmlrEREuxThDNio63Zh1PC+ozuzkYVu7j9BEK2SfcO86O
         8+6C6iZH31Mu/bEpXkpv71/G7exjWuxx4zlwjKk/Dzko/iyGjSoplGWOvOvhtgt2muUb
         S9CvsspLeUpS4mZxwx7HDbI/sAX0X03XrTMt2YnVt5aL8cQssSpRg3jT+jVDSbo31ipH
         /S6SJdzs6220HJvS7I7jXxtS7n09W0Qg0iNVIJP2W3n2N+NeiEoRse3xKPiLmZe7ljCX
         DpkVUCC4fzajDHF7cYxkd+RtAzJeBftiimhCMoWaCZOzT+qAkAnHI0UDoOAwjUSTmiW4
         UcLw==
X-Gm-Message-State: AOAM5316QyD8gx7YPZjLYBqah/QL4d455ECEAmJ+wmevDa2iALzwKY3y
        tMoWIL0ci36dz32Ped9R6Wnhlw==
X-Google-Smtp-Source: ABdhPJy2KFW8FNw7hgTBTNpq63UwbSqcFK5XldeiM0tVPoz8diTDX0olaI5+v9g/NsDXbO+BJHk2vA==
X-Received: by 2002:a17:902:e546:b0:157:832:2c0a with SMTP id n6-20020a170902e54600b0015708322c0amr8979222plf.37.1649435788330;
        Fri, 08 Apr 2022 09:36:28 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id o32-20020a635d60000000b0039cd48c7f6asm4585009pgm.32.2022.04.08.09.36.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 09:36:27 -0700 (PDT)
Date:   Fri, 8 Apr 2022 16:36:24 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>
Subject: Re: [RFC PATCH v5 076/104] KVM: x86: Add option to force LAPIC
 expiration wait
Message-ID: <YlBkiOmTGk8VlWFh@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <52b0451a4ffba54455acf710b443715ac16effd4.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52b0451a4ffba54455acf710b443715ac16effd4.1646422845.git.isaku.yamahata@intel.com>
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

On Fri, Mar 04, 2022, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Add an option to skip the IRR check-in kvm_wait_lapic_expire().  This
> will be used by TDX to wait if there is an outstanding notification for
> a TD, i.e. a virtual interrupt is being triggered via posted interrupt
> processing.  KVM TDX doesn't emulate PI processing, i.e. there will
> never be a bit set in IRR/ISR, so the default behavior for APICv of
> querying the IRR doesn't work as intended.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/lapic.c   | 4 ++--
>  arch/x86/kvm/lapic.h   | 2 +-
>  arch/x86/kvm/svm/svm.c | 2 +-
>  arch/x86/kvm/vmx/vmx.c | 2 +-
>  4 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 9322e6340a74..d49f029ef0e3 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1620,12 +1620,12 @@ static void __kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
>  		__wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
>  }
>  
> -void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
> +void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu, bool force_wait)
>  {
>  	if (lapic_in_kernel(vcpu) &&
>  	    vcpu->arch.apic->lapic_timer.expired_tscdeadline &&
>  	    vcpu->arch.apic->lapic_timer.timer_advance_ns &&
> -	    lapic_timer_int_injected(vcpu))
> +	    (force_wait || lapic_timer_int_injected(vcpu)))
>  		__kvm_wait_lapic_expire(vcpu);

If the guest_apic_protected idea works, rather than require TDX to tell the local
APIC that it should wait, the common code can instead assume a timer IRQ is pending
if the IRR holds garbage.

Again, compile tested only...

From: Sean Christopherson <seanjc@google.com>
Date: Fri, 8 Apr 2022 09:24:39 -0700
Subject: [PATCH] KVM: x86: Assume timer IRQ was injected if APIC state is
 proteced

If APIC state is protected, i.e. the vCPU is a TDX guest, assume a timer
IRQ was injected when deciding whether or not to busy wait in the "timer
advanced" path.  The "real" vIRR is not readable/writable, so trying to
query for a pending timer IRQ will return garbage.

Note, TDX can scour the PIR if it wants to be more precise and skip the
"wait" call entirely.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 50a483abc0fe..e5555dce8db8 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1531,8 +1531,17 @@ static void apic_update_lvtt(struct kvm_lapic *apic)
 static bool lapic_timer_int_injected(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
-	u32 reg = kvm_lapic_get_reg(apic, APIC_LVTT);
+	u32 reg;

+	/*
+	 * Assume a timer IRQ was "injected" if the APIC is protected.  KVM's
+	 * copy of the vIRR is bogus, it's the responsibility of the caller to
+	 * precisely check whether or not a timer IRQ is pending.
+	 */
+	if (apic->guest_apic_protected)
+		return true;
+
+	reg  = kvm_lapic_get_reg(apic, APIC_LVTT);
 	if (kvm_apic_hw_enabled(apic)) {
 		int vec = reg & APIC_VECTOR_MASK;
 		void *bitmap = apic->regs + APIC_ISR;

base-commit: 33f2439cd63c84fcbc8b4cdd4eb731e83deead90
--
