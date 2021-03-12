Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 074A83399FB
	for <lists+kvm@lfdr.de>; Sat, 13 Mar 2021 00:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235813AbhCLX3M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 18:29:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235775AbhCLX2k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 18:28:40 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F64C061574
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 15:28:40 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id d23so9421566plq.2
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 15:28:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Rexsar/MLrWMnJPV0oKDhtqxMBxx3fUYPkwMOcrII5M=;
        b=LgjG2h9VmgkZVqn1Urzuq9X3QpQIgcawOF88P6LcY9g1PfMIWtkWjS7pIJ0jOm/dYa
         0uRVenw0RblottlX1oQILQBYG+gRaTs7ObI4HVG9drb3hRT3+IAJyutjjj3o1XF51RJQ
         VvKyIBoVV1ZhhKCdWxoCCltGJjYaiLwgg8UxWgmnYUxvVSeonw8QNA9EpqMG0WZw/TSy
         GHmqXgTaj9MGPsg6XE0gkxvW6hzEZTN2Mw3o7hfEefbS8cjAnoRBFBzUL9mHMX35ZxeD
         FI2b62qWpSxW1GDybdct/qj/mPiVjJv1ahPYit52/5Dm9F+e1G6sKYCXTEiMEt4g6aZv
         GYDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Rexsar/MLrWMnJPV0oKDhtqxMBxx3fUYPkwMOcrII5M=;
        b=UTEAEnCoI3x8mUkUqDwJjYRUznwNxpr8ImuVxfXaX3MbANx8hVeNV3ifBBOrzLt0zi
         H8/3kfQZdjOMFJZjCdH/CD47UokMS6powrZA/fXGjedoPObCcy0JJ5HMHHSeIrSzyP0j
         VH7RoLxgGat4gRsZyXmP68kSIIvRSXkefiuOhc5YZoAEVykUBkx+QxXkWHVKyfFlLXME
         uP9MJNRArwQaJOu2PBXdaVK+VBAxDapPp4FFzzDXDYC1eNByI5mMT6esnlQdpq8pf8G/
         z2MYdfOrkPKJ5Nj3+/L/BHzqgZco8kN0nifAfOtCz15Zu28km0bRmnfTZT/e5TnZ0BYq
         rvFQ==
X-Gm-Message-State: AOAM531+O9ddvoZCiZLFQ/3sS3oIwTrA2P6S/WMU4r9tibbcNleOenIY
        eWyjAr/y8UJoQsdST3O7k8iMUw==
X-Google-Smtp-Source: ABdhPJxkAJbL/g7RyLYi2Un8wi64sJlNjkT0KCH9w4QxfkbTCTVGt6Xcu40Y7E6kgNuenfP1Co4ouQ==
X-Received: by 2002:a17:90a:b311:: with SMTP id d17mr675753pjr.228.1615591719540;
        Fri, 12 Mar 2021 15:28:39 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e1a6:2eeb:4e45:756])
        by smtp.gmail.com with ESMTPSA id l22sm6500984pfd.145.2021.03.12.15.28.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 15:28:38 -0800 (PST)
Date:   Fri, 12 Mar 2021 15:28:32 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] KVM: nVMX: Sync L2 guest CET states between L1/L2
Message-ID: <YEv5IFrh/HBUsMR/@google.com>
References: <20210304060740.11339-1-weijiang.yang@intel.com>
 <20210304060740.11339-2-weijiang.yang@intel.com>
 <YEEO9bcLnc0gyLyP@google.com>
 <20210308080108.GA1160@local-michael-cet-test.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210308080108.GA1160@local-michael-cet-test.sh.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 08, 2021, Yang Weijiang wrote:
> On Thu, Mar 04, 2021 at 08:46:45AM -0800, Sean Christopherson wrote:
> > On Thu, Mar 04, 2021, Yang Weijiang wrote:
> > > @@ -3375,6 +3391,12 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
> > >  	if (kvm_mpx_supported() &&
> > >  		!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
> > >  		vmx->nested.vmcs01_guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
> > > +	if (kvm_cet_supported() &&
> > > +		!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE)) {
> > 
> > Alignment.
> > 
> > > +		vmx->nested.vmcs01_guest_ssp = vmcs_readl(GUEST_SSP);
> > > +		vmx->nested.vmcs01_guest_s_cet = vmcs_readl(GUEST_S_CET);
> > > +		vmx->nested.vmcs01_guest_ssp_tbl = vmcs_readl(GUEST_INTR_SSP_TABLE);
> > > +	}
> > >  
> > >  	/*
> > >  	 * Overwrite vmcs01.GUEST_CR3 with L1's CR3 if EPT is disabled *and*
> > > @@ -4001,6 +4023,9 @@ static bool is_vmcs12_ext_field(unsigned long field)
> > >  	case GUEST_IDTR_BASE:
> > >  	case GUEST_PENDING_DBG_EXCEPTIONS:
> > >  	case GUEST_BNDCFGS:
> > > +	case GUEST_SSP:
> > > +	case GUEST_INTR_SSP_TABLE:
> > > +	case GUEST_S_CET:
> > >  		return true;
> > >  	default:
> > >  		break;
> > > @@ -4052,6 +4077,11 @@ static void sync_vmcs02_to_vmcs12_rare(struct kvm_vcpu *vcpu,
> > >  		vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS);
> > >  	if (kvm_mpx_supported())
> > >  		vmcs12->guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
> > > +	if (kvm_cet_supported()) {
> > 
> > Isn't the existing kvm_mpx_supported() check wrong in the sense that KVM only
> > needs to sync to vmcs12 if KVM and the guest both support MPX?  
> 
> For MPX, if guest_cpuid_has() is not efficent, can it be checked by BNDCFGS EN bit?
> E.g.:
> 
> if (kvm_mpx_supported() && (vmcs12->guest_bndcfgs & 1))
> 
> > Same would apply to CET. Not sure it'd be a net positive in terms of performance since
> > guest_cpuid_has() can be quite slow, but overwriting vmcs12 fields that technically don't exist
> > feels wrong.
> 
> For CET, can we get equivalent effect by checking vmcs12->guest_cr4.CET?
> E.g.:
> if (kvm_cet_supported() && (vmcs12->guest_cr4 & X86_CR4_CET))

No, because the existence of the fields does not depend on them being enabled.
E.g. things will go sideways if the values change while L2 is running, L2
disables CET, and then an exit occurs.

This is already a slow path, maybe the guest_cpuid_has() checks are a non-issue.


> 
> > 
> > > +		vmcs12->guest_ssp = vmcs_readl(GUEST_SSP);
> > > +		vmcs12->guest_s_cet = vmcs_readl(GUEST_S_CET);
> > > +		vmcs12->guest_ssp_tbl = vmcs_readl(GUEST_INTR_SSP_TABLE);
> > > +	}
> > >  
> > >  	vmx->nested.need_sync_vmcs02_to_vmcs12_rare = false;
> > >  }
> > > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> > > index 9d3a557949ac..36dc4fdb0909 100644
> > > --- a/arch/x86/kvm/vmx/vmx.h
> > > +++ b/arch/x86/kvm/vmx/vmx.h
> > > @@ -155,6 +155,9 @@ struct nested_vmx {
> > >  	/* to migrate it to L2 if VM_ENTRY_LOAD_DEBUG_CONTROLS is off */
> > >  	u64 vmcs01_debugctl;
> > >  	u64 vmcs01_guest_bndcfgs;
> > > +	u64 vmcs01_guest_ssp;
> > > +	u64 vmcs01_guest_s_cet;
> > > +	u64 vmcs01_guest_ssp_tbl;
> > >  
> > >  	/* to migrate it to L1 if L2 writes to L1's CR8 directly */
> > >  	int l1_tpr_threshold;
> > > -- 
> > > 2.26.2
> > > 
