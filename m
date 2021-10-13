Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B804842CD3C
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 00:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbhJMWGP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 18:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbhJMWGO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 18:06:14 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC74FC061570
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 15:04:10 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id lk8-20020a17090b33c800b001a0a284fcc2so5483124pjb.2
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 15:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1uAy4QqdpHe1zInBEePZ5jB1vNfEUO2hPy9MxH3IjEE=;
        b=fvqEEcDvQzc1r7JjpME6JDYPaevCntj2xyFKcb12nTXz9KnFTuErtoYckmovsD0sbs
         c5zAMcGiF1pU8HTaoiD4M0RD5GrYSzWTh1ErpsH952XXx6ijr7I9IAe0zVlwM/M0g9x1
         IPuo6PCNrhkjOxbKeisetTQysClRuWJXaI7svDHiDH3enY+XQdpXJyUT1BwRbIgCjHOi
         7oNcrojMJ8KQm6esv6y0HgpuK+nZcApY+oVK9reicJboACnBb+5o+4aUo3fXxp6FPYhJ
         oMdZ5tV6MsN2MhqwgsyUAevFvmjvRrBtmtugTNrXK8tbc9dgR5fRwj+v64f74QyiFT4X
         fUHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1uAy4QqdpHe1zInBEePZ5jB1vNfEUO2hPy9MxH3IjEE=;
        b=XO4QVVFr5t5IIs5tdw2PdOp261BStBjCbfXux3nhkqNpVivYN/YZDIzJQkk//oUiPz
         haiFRCHLZbtSyuMwie7F16oG0TfEfHmxk1ZH2jZuCorA9JA9Knws+3yb2b5L/Wt037q1
         Lx4Cq+qUvRi9i0x3MIqkPOIRsBpTWleWLbzosHi4hj6TAQF8Pkcx1ArKm5wdLdy4IDfJ
         TSeiyidi4Z+fzpuq4JDnipE2jSRlvp9jQ8CBS+KcMkrl7MWFT28WCnFUB9BoTGAEnbwI
         GN0XlrCxYJvPMbWB9smvDurS8VIw93QGECxQ41CXxblal3XCSrjOJmJRDLCxuGYop6cr
         KDaQ==
X-Gm-Message-State: AOAM532o2vz4fAIMAkRs0a6nUrAirKB2Bg0ePLe1yM2BmIHUcD7aqAy0
        uqagspWJC+YAOGiMyd0SApiZiQ==
X-Google-Smtp-Source: ABdhPJzaN8CTMvCT9z9o515waYH/h1r8/GSh6bKmejgmRT732Uw2yoJlHuDy/AhTFTp+EqMLxnD6RQ==
X-Received: by 2002:a17:903:2451:b0:13f:297b:829e with SMTP id l17-20020a170903245100b0013f297b829emr1518902pls.45.1634162650084;
        Wed, 13 Oct 2021 15:04:10 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k127sm445927pfd.1.2021.10.13.15.04.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 15:04:09 -0700 (PDT)
Date:   Wed, 13 Oct 2021 22:04:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH v4 3/5] KVM: SVM: Add support to handle AP reset MSR
 protocol
Message-ID: <YWdX1WXE3AOPFC6d@google.com>
References: <20210929155330.5597-1-joro@8bytes.org>
 <20210929155330.5597-4-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929155330.5597-4-joro@8bytes.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 29, 2021, Joerg Roedel wrote:
>  #define PFERR_PRESENT_BIT 0
>  #define PFERR_WRITE_BIT 1
> @@ -908,6 +913,8 @@ struct kvm_vcpu_arch {
>  #if IS_ENABLED(CONFIG_HYPERV)
>  	hpa_t hv_root_tdp;
>  #endif
> +
> +	enum ap_reset_hold_type reset_hold_type;


Apologies for very belated feedback...

This living in kvm_vcpu_arch came about from feedback (see bottom) that _if_
kvm_emulate_ap_reset_hold() is in x86.c, so should the hold type information.


But clearing the hold in SEV here...

>  void sev_es_unmap_ghcb(struct vcpu_svm *svm)
>  {
> +	/* Clear any indication that the vCPU is in a type of AP Reset Hold */
> +	svm->vcpu.arch.reset_hold_type = AP_RESET_HOLD_NONE;
> +
>  	if (!svm->ghcb)
>  		return;

makes this completely unbalanced, i.e. common x86 doesn't clear the reset_hold_type
when the vCPU is awakened, despite it being set in common x86.  More at the end.

> -int kvm_emulate_ap_reset_hold(struct kvm_vcpu *vcpu)
> +int kvm_emulate_ap_reset_hold(struct kvm_vcpu *vcpu,
> +			      enum ap_reset_hold_type type)
>  {
>  	int ret = kvm_skip_emulated_instruction(vcpu);
>  
> +	vcpu->arch.reset_hold_type = type;
> +
>  	return __kvm_vcpu_halt(vcpu, KVM_MP_STATE_AP_RESET_HOLD, KVM_EXIT_AP_RESET_HOLD) && ret;
>  }
>  EXPORT_SYMBOL_GPL(kvm_emulate_ap_reset_hold);

...

On Thu, Jul 15, 2021, Tom Lendacky wrote:
> On 7/15/21 10:45 AM, Sean Christopherson wrote:
> > On Thu, Jul 15, 2021, Tom Lendacky wrote:
> >> On 7/14/21 3:17 PM, Sean Christopherson wrote:
> >>>> +        case GHCB_MSR_AP_RESET_HOLD_REQ:
> >>>> +                svm->ap_reset_hold_type = AP_RESET_HOLD_MSR_PROTO;
> >>>> +                ret = kvm_emulate_ap_reset_hold(&svm->vcpu);
> >>>
> >>> The hold type feels like it should be a param to kvm_emulate_ap_reset_hold().
> >>
> >> I suppose it could be, but then the type would have to be tracked in the
> >> kvm_vcpu_arch struct instead of the vcpu_svm struct, so I opted for the
> >> latter. Maybe a helper function, sev_ap_reset_hold(), that sets the type
> >> and then calls kvm_emulate_ap_reset_hold(), but I'm not seeing a big need
> >> for it.
> >
> > Huh.  Why is kvm_emulate_ap_reset_hold() in x86.c?  That entire concept is very
> > much SEV specific.  And if anyone argues its not SEV specific, then the hold type
> > should also be considered generic, i.e. put in kvm_vcpu_arch.
>
> That was based on review comments where it was desired that the halt be
> identified as specifically from the AP reset hold vs a normal halt.

The reason I emphasized "if", is that IMO this patch goes in the wrong direction.
My feedback here was that kvm_emulate_ap_reset_hold() and reset_hold_type should
tied together.  I completely agree with the review comments Tom mentioned, but IMO
adding a common kvm_emulate_ap_reset_hold() was the wrong solution.  That's very
much an SEV specific concept, as demonstrated by this patch.

Rather than put more stuff into x86 that really belongs to SEV, what about moving
kvm_emulate_ap_reset_hold() into sev.c and instead exporting __kvm_vcpu_halt()?

Note, there's a conflict there with a proposed function rename[*], but it's minor
and should be trivial to resolve depending how which series wins the race.

[*] https://lkml.kernel.org/r/20211009021236.4122790-13-seanjc@google.com
