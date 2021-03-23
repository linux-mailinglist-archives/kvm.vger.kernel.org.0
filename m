Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9468B3463D9
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 16:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232907AbhCWP4u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 11:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232823AbhCWP4f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 11:56:35 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1328C061763
        for <kvm@vger.kernel.org>; Tue, 23 Mar 2021 08:56:35 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id n11so12143452pgm.12
        for <kvm@vger.kernel.org>; Tue, 23 Mar 2021 08:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IB7zf1R6bjb743xZ3yYB40a3jvRkNLGZGF69Se67w24=;
        b=s8c4dcLK+4AXHOn9nzjP9vwGRY6Em1440uG7EVt1LRzRtFbLKVDsg4o3V0Out1eH9U
         zORK6mgiUCBhKturU77wwUs0Vm0YdxUeGEaoypQpJY6Qyy61PrmuIPwH1nxIV6/XWUIo
         He6ROxXeT45KsHan/LX8pfTaWGHDTOROZA3113p7y67rvYHFeGESlunILhwkMVv+MWYK
         fqr5nDGnx7W1rTwC8txtieC33Xm/A1FvTT9+ok5uQPVRM8hbbifPtg7ioTWIy/LfWcgW
         v1ghGwLI3JYh4CgO9mbtjz/o1I5c8wCewBnZyn2/j40ZRqh8hWQpTNeMfOkFzZsUjFNw
         r1Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IB7zf1R6bjb743xZ3yYB40a3jvRkNLGZGF69Se67w24=;
        b=jNh1wh2PbXtpB/G0/iYvtdoxX5XogpkfgK6XB827jQqWQXLCpZejt7lGOT+SaiHN/v
         ujC3CVgtZ9FuWpSg+4zpSTxoxrbr0gPFL92jve6wRLhDNOTN2kSOhnZlSJ0aczNG139E
         uCih2d6ohBJamQ1EQ35/juXHruLrJ+77MbPeufIDI4VRb0PhUwoFYD6lEucTdTNYHAAm
         HubE4p9VgtnIRzb9moJ5Uq+uvq66PoCAnzoFlA024agaO3OtBJd0szM6Wf9ba/faNfcK
         l3aJmQT0MsXQxbDMtL18WgPxcq3AYST1AubZhO1kVBzJ9kyoQPjBSCLNusJ8AdgnftZ+
         7UKA==
X-Gm-Message-State: AOAM530ReBdW+ftPb8Ellmq58mTQWEe8/CS0XrnPtrYcLAhGP2Gjq3Is
        c/yrAFdlCmurS+1KpO2HL6V1rA==
X-Google-Smtp-Source: ABdhPJxFTHVj140MGkcJ8SQQQfy90L68lc/1EOpcPzEdAiWGTTzevUuiAEkdQMU4HmUDHYW4zkUl8g==
X-Received: by 2002:a17:902:d201:b029:e6:bba:52b3 with SMTP id t1-20020a170902d201b02900e60bba52b3mr6446418ply.51.1616514994988;
        Tue, 23 Mar 2021 08:56:34 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id v26sm16926093pff.195.2021.03.23.08.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 08:56:34 -0700 (PDT)
Date:   Tue, 23 Mar 2021 15:56:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] KVM: nVMX: Sync L2 guest CET states between L1/L2
Message-ID: <YFoPro1bw07YEaXe@google.com>
References: <20210315071841.7045-1-weijiang.yang@intel.com>
 <20210315071841.7045-2-weijiang.yang@intel.com>
 <YE+PF1zfkZTTgwxn@google.com>
 <20210316090347.GA13548@local-michael-cet-test.sh.intel.com>
 <20210323004305.GA3647@local-michael-cet-test.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323004305.GA3647@local-michael-cet-test.sh.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 23, 2021, Yang Weijiang wrote:
> On Tue, Mar 16, 2021 at 05:03:47PM +0800, Yang Weijiang wrote:
> 
> Hi, Sean,
> Could you respond my below rely? I'm not sure how to proceed, thanks!
> 
> > On Mon, Mar 15, 2021 at 09:45:11AM -0700, Sean Christopherson wrote:
> > > On Mon, Mar 15, 2021, Yang Weijiang wrote:

...

> > > > @@ -2556,6 +2563,15 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
> > > >  	if (kvm_mpx_supported() && (!vmx->nested.nested_run_pending ||
> > > >  	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
> > > >  		vmcs_write64(GUEST_BNDCFGS, vmx->nested.vmcs01_guest_bndcfgs);
> > > > +
> > > > +	if (kvm_cet_supported() && (!vmx->nested.nested_run_pending ||
> > > > +	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE))) {
> > > 
> > > Not your code per se, since this pattern comes from BNDCFGS and DEBUGCTL, but I
> > > don't see how loading vmcs01 state in this combo is correct:
> > > 
> > >     a. kvm_xxx_supported()              == 1
> > >     b. nested_run_pending               == false
> > >     c. vm_entry_controls.load_xxx_state == true
> > > 
> > > nested_vmx_enter_non_root_mode() only snapshots vmcs01 if 
> > > vm_entry_controls.load_xxx_state == false, which means the above combo is
> > > loading stale values (or more likely, zeros).
> > > 
> > > I _think_ nested_vmx_enter_non_root_mode() just needs to snapshot vmcs01 if
> > > nested_run_pending=false.  For migration, if userspace restores MSRs after
> > > KVM_SET_NESTED_STATE, then what's done here is likely irrelevant.  If userspace
> > > restores MSRs before nested state, then vmcs01 will hold the desired value since
> > > setting MSRs would have written the value into vmcs01.
> > 
> > Then the code nested_vmx_enter_non_root_mode() would look like:
> > 
> > if (kvm_cet_supported() && !vmx->nested.nested_run_pending &&
> >     !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE)) {
> > 	...
> >     }
> > 
> > I have another concern now, if vm_entry_controls.load_cet_state == false, and L1
> > updated vmcs fields, so the latest states are in vmcs12, but they cannot
> > be synced to vmcs02 because in prepare_vmcs02_rare():
> > 
> > if (kvm_cet_supported() && vmx->nested.nested_run_pending &&
> >     (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE)) {
> > 	...
> >     }
> > 
> > so L2 got stale status. IMO, L1 guest sets vm_entry_controls.load_cet_state == false
> > should be rare case. We can even igore this case :-)

Yes, that's an L1 bug if it expects L2 state to come from vmcs12 in that case.
Architecturally, the vcms12 value won't be visible to L2 until L1 enables the
VM-Entry control, at which point KVM would detect the refreshed vmcs12 and sync
the "rare" fields.

> > > I suspect no one has reported this issue because guests simply don't use MPX,
> > > and up until the recent LBR stuff, KVM effectively zeroed out DEBUGCTL for the
> > > guest.
> > > 
> > So for MPX and DEBUGCTL, is it worth some separate fix patch?

Yes, assuming my analysis is correct.  That doesn't necessarily need to be your
responsibility, though patches are of course welcome :-)

Jim, Paolo, any thoughts?

> > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > > index 45622e9c4449..4184ff601120 100644
> > > --- a/arch/x86/kvm/vmx/nested.c
> > > +++ b/arch/x86/kvm/vmx/nested.c
> > > @@ -3298,10 +3298,11 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
> > >         if (likely(!evaluate_pending_interrupts) && kvm_vcpu_apicv_active(vcpu))
> > >                 evaluate_pending_interrupts |= vmx_has_apicv_interrupt(vcpu);
> > > 
> > > -       if (!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
> > > +       if (!vmx->nested.nested_run_pending ||
> > > +           !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
> > >                 vmx->nested.vmcs01_debugctl = vmcs_read64(GUEST_IA32_DEBUGCTL);
> > > -       if (kvm_mpx_supported() &&
> > > -               !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
> > > +       if (kvm_mpx_supported() && (!vmx->nested.nested_run_pending ||
> > > +           !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
> > >                 vmx->nested.vmcs01_guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
> > > 
> > >         /*
> > > 
> > > 
> > > Side topic, all of this code is broken for SMM emulation.  SMI+RSM don't do a
> > > full VM-Exit -> VM-Entry; the CPU forcefully exits non-root, but most state that
> > > is loaded from the VMCS is left untouched.  It's the SMI handler's responsibility
> > > to not enable features, e.g. to not set CR4.CET.  For sane use cases, this
> > > probably doesn't matter as vmcs12 will be configured to context switch state,
> > > but if L1 is doing anything out of the ordinary, SMI+RSM will corrupt state.
> > > 
> > > E.g. if L1 enables MPX in the guest, does not intercept L2 writes to BNDCFGS,
> > > and does not load BNDCFGS on VM-Entry, then SMI+RSM would corrupt BNDCFGS since
> > > the SMI "exit" would clear BNDCFGS, and the RSM "entry" would load zero.  This
> > > is 100% contrived, and probably doesn't impact real world use cases, but it
> > > still bugs me :-)
> > 
> > Exactly, should it be fixed by separate patch or leave it as is?

Definitely leave it for now, properly fixing the SMI+RSM code goes far beyond
basic CET support.
