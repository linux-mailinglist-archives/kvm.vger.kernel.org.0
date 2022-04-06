Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD0574F6E84
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 01:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236977AbiDFXaO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 19:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230431AbiDFXaN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 19:30:13 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0925B6D957
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 16:28:16 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id ku13-20020a17090b218d00b001ca8fcd3adeso7284722pjb.2
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 16:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jrXUCayZtkLosRBI99j9NnPI/sW0MUNsKdRGEt96UG0=;
        b=nUn5aT1YTXye6uC/ecfQR2EfDRtOlSABjXvWa9JYIPsWTiZo+lqf9W4OLDemKbwzdJ
         VHUNKA5AQ1rXVatUPJLGq1FMmMtBDkmOkgPuvl33w4PawE5eOwWvW6GqeD0YnlDThsrs
         jqij5SxTPQgJHWbygPbwpIQKD8fczIrLetvJqijofu1WgwWcwAS2cEnnUmrTFHQeKTmg
         RC9fBwMzGYqH3j9rMYyUotick1OVBP4WKw+kvhel9vD/h4z28pSnRWSxA9frkXYAPKWg
         sdk21rPry4JxGHnBqgsNZEgOQz6uv8QbZ/oTWQFlEkAsATKWT7xbc5LbmhusWgxR87I6
         xH8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jrXUCayZtkLosRBI99j9NnPI/sW0MUNsKdRGEt96UG0=;
        b=5GW1df6UXPyd1ssfiUMGppWg3AHtckM0JSAR7g/BC4d3rTcReHzjhIkcFbMfjo5TdS
         Y/OwOUE6S/GelJINBJQh4RIYRvfVFeoLDLehsaNUc5jcU/MfHRQyeEoXmmD+VHe+Z/bG
         yOvXziK9CdlpXITUB+hS8qLGe2frVKzDgv/mQWFbIWzv0QR+rJE6y/n93LgeeIMaCQ1s
         b+EaRQz6GsKe7RzF2au656k+w2ceRxb6oH275Og/3YxSMysbOcZ3z69tBo6+WluXj8l5
         uvqG7sGAreJVMK2nCs4DqARHnZ+vVnp3ZUoqdlF0PhddmLduhyfMHbZUev4lOicq0GeQ
         IPwQ==
X-Gm-Message-State: AOAM532dQXIW/cS1YqNmVgKqkF6SU3JR+d94qeiK4waMKhts/WrqGBTR
        /fThtTTjddCpmirM7jwElH/m/FM2jMs3OQ==
X-Google-Smtp-Source: ABdhPJxu/SqIvOq3+ud7oDsue7KDrCeefdgnhKhyMsCv+Y7751nLaKmXmBT/HMJJJyKVi4Xh44fLNg==
X-Received: by 2002:a17:902:d4cc:b0:154:3a3b:4172 with SMTP id o12-20020a170902d4cc00b001543a3b4172mr10671498plg.165.1649287695328;
        Wed, 06 Apr 2022 16:28:15 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k6-20020a056a00134600b004faba67f9d4sm21039911pfu.197.2022.04.06.16.28.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 16:28:14 -0700 (PDT)
Date:   Wed, 6 Apr 2022 23:28:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>
Subject: Re: [RFC PATCH v5 074/104] KVM: x86: Add a switch_db_regs flag to
 handle TDX's auto-switched behavior
Message-ID: <Yk4iChT2sbtzSb8h@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <76c87a1d33bb3ec4a68fe3db2a840b6ddc951929.1646422845.git.isaku.yamahata@intel.com>
 <ea136ac6-53cf-cdc5-a741-acfb437819b1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea136ac6-53cf-cdc5-a741-acfb437819b1@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 05, 2022, Paolo Bonzini wrote:
> On 3/4/22 20:49, isaku.yamahata@intel.com wrote:
> >   	vcpu->arch.efer = EFER_SCE | EFER_LME | EFER_LMA | EFER_NX;
> > +	vcpu->arch.switch_db_regs = KVM_DEBUGREG_AUTO_SWITCH;
> >   	vcpu->arch.cr0_guest_owned_bits = -1ul;
> >   	vcpu->arch.cr4_guest_owned_bits = -1ul;
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 45e8a02e99bf..89d04cd64cd0 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -10084,7 +10084,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> >   	if (vcpu->arch.guest_fpu.xfd_err)
> >   		wrmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
> > -	if (unlikely(vcpu->arch.switch_db_regs)) {
> > +	if (unlikely(vcpu->arch.switch_db_regs & ~KVM_DEBUGREG_AUTO_SWITCH)) {
> >   		set_debugreg(0, 7);
> >   		set_debugreg(vcpu->arch.eff_db[0], 0);
> >   		set_debugreg(vcpu->arch.eff_db[1], 1);
> 
> I'm confused.  I'm probably missing something obvious, but where does
> KVM_DEBUGREG_AUTO_SWITCH affect the behavior of KVM?  vcpu_enter_guest
> would still write %db0-%db3 if KVM_DEBUGREG_BP_ENABLED is set, for
> example.
> 
> Do you mean:
> 
> 	if (unlikely(vcpu->arch.switch_db_regs) &&
> 	    !unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_AUTO_SWITCH)) {
> 
> ?

No, you're confused there's a crucial chunk of this patch that's missing.  The
host restore path was originally

        if (hw_breakpoint_active() &&
            !(vcpu->arch.switch_db_regs & KVM_DEBUGREG_AUTO_SWITCHED))
                hw_breakpoint_restore();

The TDX module context switches the guest _and_ host debug registers.  It restores
the host DRs because it needs to write _something_ to hide guest state, so it might
as well restore the host values.  The above was an optmization to avoid rewriting
all debug registers.

However, this patch was written before commit f85d40160691 ("KVM: X86: Disable
hardware breakpoints unconditionally before kvm_x86->run()").  I suspect that when
rebasing to newer KVM, the Intel folks discovered that DR7 isn't getting restored
because the GUEST_DR7 in the SEAM VMCS will hold the zero'd value.

But rather than completely drop the flag, KVM can still avoid writing everything
except DR7, i.e.

	if (hw_breakpoint_active()) {
		if (!(vcpu->arch.switch_db_regs & KVM_DEBUGREG_AUTO_SWITCH))
			hw_breakpoint_restore();
		else
			set_debugreg(__this_cpu_read(cpu_dr7), 7);
	}

with a comment explaining that DR7 always needs to be restored because it's
preemptively cleared to play nice with the non-instrumentable sections.
