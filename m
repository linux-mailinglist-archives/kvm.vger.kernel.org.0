Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39E06618557
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 17:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbiKCQxS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 12:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiKCQxR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 12:53:17 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DBD1DD
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 09:53:16 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id g24so2495260plq.3
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 09:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3VNihJl4rIG/CKtSJtV/S/XMKVJKarlATfZrl5tjRkk=;
        b=EdjQL3F+O6Ash0ZDhtzJFFWfytiaBg8s2Z1H74Jw+Hmcu2R/ZI2YT9VVCNktrZ8JdG
         OHNU8Fr4lSF33Ti8g1y+Es5PHVm7I5oh5aXpyQytARdBFN+KIq3MyQ0D05kkA29AYd0A
         EnsC5OVct9KbweLipQ0s4PEpxXCfSkK05HRi1alTXSCwzoW6inI9lxdbsQOJj5jkCrzs
         G3YHMH4/QF5GV3ZWcBwFSOUtBMvrLYv7dGRurciQjP9FSxCTm1A76i4U4PersCWR2Jga
         FbKdAQ6Map7905WqnhWxt6oQXFyBw1uT73LIyRmVB0zbBFO/v4oYtPBWWAUz9YKCsa9y
         xOQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3VNihJl4rIG/CKtSJtV/S/XMKVJKarlATfZrl5tjRkk=;
        b=Xs0jwN3H3BlkJEc3B29raNUKdKAlWHY9kdaYltxMwPRPuK8qY24VVEO/PUT270epBo
         +YhXAoc83xdLLMywkIYsAG5lhELWj7Ehll9TBMPtxxezNgPgASGID5rKJo8eMlWoQtfp
         kd+fntLDvkzfP2TrrSnbH7SV135Dv+Pptz74DkyO8TQEZkaXkx6zKuo5u4vZGhtYaN3r
         2A47fOKVLwPO9JMHi5v900ANNk/DHwDV0uNlpH579C5/JfZvREI53E2y1nfC8JSIuCfp
         APhAQvJT1gfTyQGn9Zd79MlMqCViI3lgkgjrhV10LTMr3e4P58t5k1aCDMqZo/eHi2Jp
         SmOg==
X-Gm-Message-State: ACrzQf0oKmgbxOhyhDXigkon2n/t6uBSIAR0rmIcoUAXkYkXMzNQRb1o
        TVKf9B5v7h4FFYyIRhjm1AY6tA==
X-Google-Smtp-Source: AMsMyM5/jQhNsoX1nsJm8nky0aqb4gdGs9fH9qwIasnEGR0Yr3GTZqtWC2cB8kC/GOzGBGXD8inc0A==
X-Received: by 2002:a17:90b:2317:b0:213:26a3:246f with SMTP id mt23-20020a17090b231700b0021326a3246fmr33177624pjb.148.1667494395616;
        Thu, 03 Nov 2022 09:53:15 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c24-20020aa79538000000b0056bbcf88b93sm1000460pfp.42.2022.11.03.09.53.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 09:53:15 -0700 (PDT)
Date:   Thu, 3 Nov 2022 16:53:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Li <ercli@ucdavis.edu>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v5 05/15] KVM: nVMX: Let userspace set nVMX MSR to any
 _host_ supported value
Message-ID: <Y2Px90RQydMUoiRH@google.com>
References: <20220607213604.3346000-1-seanjc@google.com>
 <20220607213604.3346000-6-seanjc@google.com>
 <20221031163907.w64vyg5twzvv2nho@linux.intel.com>
 <Y2ABrnRzg729ZZNI@google.com>
 <20221101101801.zxcjswoesg2gltri@linux.intel.com>
 <Y2FePYteNrEfZ7D5@google.com>
 <20221102085414.fk2xss74jvtzs6mr@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102085414.fk2xss74jvtzs6mr@linux.intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 02, 2022, Yu Zhang wrote:
> On Tue, Nov 01, 2022 at 05:58:21PM +0000, Sean Christopherson wrote:
> > On Tue, Nov 01, 2022, Yu Zhang wrote:
> > > What I observed is that vmx->nested.msrs.secondary_ctls_high will be changed
> > > in vmx_adjust_secondary_exec_control(), which can be triggered after cpuid is
> > > set. 
> > 
> > Ugh, that path got overlooked when we yanked out KVM's manipulaton of VMX MSRs
> > in response to guest CPUID changes.  I wonder if we can get away with changing
> > KVM's behavior to only ensure a feature isn't exposed to L2 when it's not exposed
> > to L1.
> > 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 6b4266e949a3..cfc35d559d91 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -4523,8 +4523,8 @@ vmx_adjust_secondary_exec_control(struct vcpu_vmx *vmx, u32 *exec_control,
> >          * Update the nested MSR settings so that a nested VMM can/can't set
> >          * controls for features that are/aren't exposed to the guest.
> >          */
> > -       if (nested) {
> > -               if (enabled)
> > +       if (nested && !enabled)
> > +               if (exiting)
> >                         vmx->nested.msrs.secondary_ctls_high |= control;
> >                 else
> >                         vmx->nested.msrs.secondary_ctls_high &= ~control;
> > 
> 
> Indeed, this change can make sure a feature won't be exposed to L2, if L1
> does not have it.

No, that's not the goal of the change.  KVM already hides features in the VMX MSRs
if the base feature is not supported in L1 according to guest CPUID.  The problem
is that, currently, KVM also _forces_ features to be enabled in the VMX MSRs when
the base feature IS supported in L1 (CPUID).

Ideally, KVM should NEVER manipulate VMX MSRs in response to guest CPUID changes.
That's what I was referring to earlier by commits:

  8805875aa473 ("Revert "KVM: nVMX: Do not expose MPX VMX controls when guest MPX disabled"")
  9389d5774aca ("Revert "KVM: nVMX: Expose load IA32_PERF_GLOBAL_CTRL"")

E.g. if userspace sets VMX MSRs and then sets guest CPUID, KVM will override the
nVMX CPU model defined by userspace.  The scenario where userspace hides a "base"
feature but exposes the feature in the VMX MSRs is nonsensical, which is why I
think KVM can likely get away with force-disabling features.

The reverse is completely legitimate though: hiding a feature in VMX MSRs even if
the base feature is supported for L1, i.e. disallowing L1 from enabling the feature
in L2, is something that real VMMs will actually do, e.g. if the user doesn't trust
that KVM correctly handles all aspects of nested virtualization for the feature.

In other words, the behavior you're observing, where vmx->nested.msrs.secondary_ctls_high
is changed by vmx_adjust_secondary_exec_control(), is a completely separate bug
than the one below.

> But for the feature bits that L1 has, yet cleared from the
> vmcs_conf->nested.msrs.secondary_ctls_high in nested_vmx_setup_ctls_msrs(),
> there's no chance for userspace vmm to reset it again.
> 
> Well, I am not suggesting to give userspace vmm such permission(which I believe
> is incorrect). And IIUC, vmcs_conf->nested.msrs.secondary_ctls_high shall serve
> as a template to initialize vmx->nested.msrs.secondary_ctls_high. So maybe we
> shall not mask off some features in nested_vmx_setup_ctls_msrs() at the beginning.
>  
> > > Since KVM's config(vmcs_config->nested.secondary_ctls_high) is done during init
> > > by nested_vmx_setup_ctls_msrs(), which only kept a subset of the flags from the
> > > vmcs_confg->cpu_based_2nd_exec_ctrl, the vmx_restore_control_msr() could fail
> > > later, when userspace VMM tries to enable a feature(the only one I witnessed is
> > > SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE) by setting MSR_IA32_VMX_PROCBASED_CTLS2.
> > > Because the vmx->nested.msrs.secondary_ctls_high is updated by cpuid, but this
> > > bit is not taken from vmcs_conf->cpu_based_2nd_exec_ctrl by nested_vmx_setup_ctls_msrs()
> > > for vmcs_config->nested.secondary_ctls_high.
> > > 
> > > The failure can be fixed, simply by adding SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE in
> > > nested_vmx_setup_ctls_msrs(), e.g.
> > 
> > Assuming KVM actually supports user wait/pause in L2, this is an orthogonal bug
> > to the CPUID-based manipulation above.  KVM simply neglects to advertise to userspace
> > that ENABLE_USR_WAIT_PAUSE is supported for nested virtualization.
> > 
> > If KVM doesn't correctly support virtualizing user wait/pause for L2, then the
> > correct location to fix this is in vmx_secondary_exec_control().
> > 
> 
> Sorry, why vmx_secondary_exec_control()?

You missed the qualifier:

  If KVM doesn't correctly support virtualizing user wait/pause for L2

If KVM should NOT be exposing ENABLE_USR_WAIT_PAUSE to the L1 VMM, then NOT
propagating the feature to msrs->secondary_ctls_low is correct.  And if that's
the case, then vmx_secondary_exec_control() needs to be modified so that it does
NOT set ENABLE_USR_WAIT_PAUSE in vmx->nested.msrs.secondary_ctls_high.

> Could we just change nested_vmx_setup_ctls_msrs() like below:

If KVM correctly virtualizes the feature in a nested scenario, yes.  I haven't
looked into ENABLE_USR_WAIT_PAUSE enough to know whether or not KVM gets the
nested virtualization pieces correct, hence the above qualifier.

> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 0c62352dda6a..fa255391718c 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -6791,13 +6791,7 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
>         msrs->procbased_ctls_low &=
>                 ~(CPU_BASED_CR3_LOAD_EXITING | CPU_BASED_CR3_STORE_EXITING);
> 
> -       /*
> -        * secondary cpu-based controls.  Do not include those that
> -        * depend on CPUID bits, they are added later by
> -        * vmx_vcpu_after_set_cpuid.
> -        */
>         msrs->secondary_ctls_low = 0;
> -
>         msrs->secondary_ctls_high = vmcs_conf->cpu_based_2nd_exec_ctrl;
>         msrs->secondary_ctls_high &=
>                 SECONDARY_EXEC_DESC |
> @@ -6810,7 +6804,8 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
>                 SECONDARY_EXEC_ENABLE_INVPCID |
>                 SECONDARY_EXEC_RDSEED_EXITING |
>                 SECONDARY_EXEC_XSAVES |
> -               SECONDARY_EXEC_TSC_SCALING;
> +               SECONDARY_EXEC_TSC_SCALING |
> +               SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE;
> 
>         /*
>          * We can emulate "VMCS shadowing," even if the hardware
