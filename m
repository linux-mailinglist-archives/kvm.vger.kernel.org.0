Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2BAF662B18
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 17:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232953AbjAIQXh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 11:23:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233994AbjAIQXP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 11:23:15 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D447BE26
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 08:23:14 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id r18so6200620pgr.12
        for <kvm@vger.kernel.org>; Mon, 09 Jan 2023 08:23:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5ihGUjj0LvNosmMvceFYhcU4jWooAyH8DgnkbRcWRKo=;
        b=EIuMuNifZAZt7Xli18hbSQdtUmE5TKUZdjdCU7GMvD8NGUWFAcckj69cyY8dTZxBuD
         Egb+HDHnj6bGA6owziVsrnqmc0mpn9N0YkWWbHJ34flGa0zPJjslIwxmRiixFe6FIxEM
         H1gd661Uz/0vdsrySY3t20Joh4eiK7Tx7N3BKzSIf6YiJDDAwl66HlKg4g52NoncmKDL
         U2vEY8X89MnQqwCH9V0bUgp2FBAz0J/nAe+ybMa1VUls2Z4XBIKc8+vXgvK2pLUxQPnF
         quQeZGOvULYjEQ4mrKYEhq0M7FyCn+ikBdJY39qb3r7CvWKfXnYIaWaEv89N+flWX+6C
         DLrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5ihGUjj0LvNosmMvceFYhcU4jWooAyH8DgnkbRcWRKo=;
        b=DNg4fEqi1tXSeVfwb26aCkfOzx9k7bw/i9k8YFauDzxwMxrpIPEhNeVabFitZAgK/3
         kfhdbmNM6cUItQoMwNDL/in98WhDEadWEHmaLt2rcW3bsnrjZ+hkQcPvdjbmEFqSPdVn
         KWF0jESmtY7AmLwWsrFsVNRgA6H2aOLnqMi6GLmDn+0CBherQz4WszFr8e8noH5rLV+S
         z6MTsftnhBvnabYQE6OD+AGcCiZ84k5TIO7C8APUxvl2m4Ee9enLbUfs4IId1farmTTT
         S9FiSjbvtT2ig5R22TuRX0hNwLuL/agFFJQnf+G1iHN7extNRaH+Cgj/BccQZC0HxySG
         i3Ag==
X-Gm-Message-State: AFqh2kr1iyCZ8s24QTlTey5qZAbAsn48gEoMGcj7bWR+8QNn2ag6epGC
        3PXMyndJj+wuU7T0ijREwrpkRg==
X-Google-Smtp-Source: AMrXdXtWhEqNqPFVl/uaozcZh8BZT/2gMbDUzsG0+IUAZVVYNTHPHhsB7FZRZ1pfjeUUe14I6OHAYQ==
X-Received: by 2002:aa7:973c:0:b0:574:8995:c0d0 with SMTP id k28-20020aa7973c000000b005748995c0d0mr655787pfg.1.1673281393473;
        Mon, 09 Jan 2023 08:23:13 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x4-20020a628604000000b00576f7bd92cdsm6474170pfd.14.2023.01.09.08.23.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 08:23:12 -0800 (PST)
Date:   Mon, 9 Jan 2023 16:23:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>,
        Gautam Menghani <gautammenghani201@gmail.com>,
        Zeng Guang <guang.zeng@intel.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] KVM: x86: update APIC_ID also when disabling
 x2APIC in kvm_lapic_set_base
Message-ID: <Y7w/bYP4VGqoVcjH@google.com>
References: <20230109130605.2013555-1-eesposit@redhat.com>
 <20230109130605.2013555-2-eesposit@redhat.com>
 <c61ce1a6393a108c76e53cb99249aba5ab318e07.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c61ce1a6393a108c76e53cb99249aba5ab318e07.camel@redhat.com>
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

On Mon, Jan 09, 2023, Maxim Levitsky wrote:
> On Mon, 2023-01-09 at 08:06 -0500, Emanuele Giuseppe Esposito wrote:
> > If KVM_SET_MSR firstly enables and then disables x2APIC, make sure
> > APIC_ID is actually updated correctly, since bits and offset differ from
> > xAPIC and x2APIC.
> > 
> > Currently this is not handled correctly, as kvm_set_apic_base() will
> > have msr_info->host_initiated, so switching from x2APIC to xAPIC won't
> > fail, but kvm_lapic_set_base() does not handle the case.
> > 
> > Fixes: 8d860bbeedef ("kvm: vmx: Basic APIC virtualization controls have three settings")
> > Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
> > ---
> >  arch/x86/kvm/lapic.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 4efdb4a4d72c..df0a50099aa2 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -2394,8 +2394,12 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
> >  		}
> >  	}
> >  
> > -	if (((old_value ^ value) & X2APIC_ENABLE) && (value & X2APIC_ENABLE))
> > -		kvm_apic_set_x2apic_id(apic, vcpu->vcpu_id);
> > +	if ((old_value ^ value) & X2APIC_ENABLE) {
> > +		if (value & X2APIC_ENABLE)
> > +			kvm_apic_set_x2apic_id(apic, vcpu->vcpu_id);
> > +		else
> > +			kvm_apic_set_xapic_id(apic, vcpu->vcpu_id);
> > +	}
> >  
> >  	if ((old_value ^ value) & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE)) {
> >  		kvm_vcpu_update_apicv(vcpu);
> 
> 
> I don't think that this patch is 100% needed in a strict sense, but I don't
> object to it either.

I'd prefer not to go this route, I assume/suspect there's a diffferent underlying
issue that is the real problem.

> The switch between x2apic and xapic mode is not allowed by X86 spec, while
> vise versa is allowed and I think that the spec says that in this case APIC
> ID is restored to its default value.

No, APIC ID is initialized on RESET, but AFAIK it's preserved for all other
transitions.  It's definitely preserved on INIT (doesn't touch the enable bit),
and this snippet from the SDM more or less says the APIC ID is preserved when it's
disabled in IA32_APIC_BASE.

  From the disabled state, the only valid x2APIC transition using IA32_APIC_BASE
  is to the xAPIC mode (EN= 1, EXTD = 0). Thus the only means to transition from
  x2APIC mode to xAPIC mode is a two-step process:

   - first transition from x2APIC mode to local APIC disabled mode (EN= 0, EXTD = 0),
   - followed by another transition from disabled mode to xAPIC mode (EN= 1, EXTD= 0).

  Consequently, all the APIC register states in the x2APIC, except for the x2APIC ID
  (32 bits), are not preserved across mode transitions.

And for RESET vs. INIT

  A reset in this state places the x2APIC in xAPIC mode. All APIC registers
  (including the local APIC ID register) are initialized as described in Section
  10.12.5.1.

  An INIT in this state keeps the x2APIC in the x2APIC mode. The state of the
  local APIC ID register is preserved (all 32 bits). However, all the other APIC
  registers are initialized as a result of the INIT transition.

Emanuele, what is the actual issue you are trying to fix?  E.g. is APICv left
inihibited after an emulated RESET?  Something else?  Stuffing APIC state from
userspace should do the right thing after commit ef40757743b4 ("KVM: x86: fix
APICv/x2AVIC disabled when vm reboot by itself") and this patch:

  https://lore.kernel.org/all/20230106011306.85230-33-seanjc@google.com
