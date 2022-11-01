Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCB861512B
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 18:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbiKAR6a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 13:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiKAR60 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 13:58:26 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2E53645E
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 10:58:25 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id l6so13967931pjj.0
        for <kvm@vger.kernel.org>; Tue, 01 Nov 2022 10:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PSlM7tm98GJ6KQQBPng7urzfjnyPwOttoZ6TFnd/jVE=;
        b=tbiyQ/qH+nehgRPrhsXEOyMFfl0Nh6L1qRXhgwe2uAhYwwLIh+4vrx7SjEGwzAlgv+
         6bt1NpnPFq4ar1dxkygRW5xUck+xMUYcMqnOgiKbYR4L2jhUV1PqFMYC3Z0vzUXAjrTb
         DjrBH0VbMai3H9rAG0nv75s9+1te1RnvuTn3Ez37hKJwsW6htEBUfu7pMuHlCiaof7+X
         0Lq3kzKd+Q3fpRxvVBn6JmQSHF8BhDOWcg1AuDQlDJc+cCjnGVSe8z0FrRhcwLK97D/v
         MhoQekh5MJAMQk7n65oo7JlM2mShK+IsRa1Ij562KAUi5WPU3pfVdWYFshMx+1gGT7Q2
         7uew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PSlM7tm98GJ6KQQBPng7urzfjnyPwOttoZ6TFnd/jVE=;
        b=z5UOIWriiaNHqez3fl3X1NG2A13/GaxVqzZ+c85lFSjIBA/cXUBoD++Sb6RUa+Cn8o
         RkQsC+0TLC17Y3iYoBP6kPz8ItQM2JxP4aTZw+Ok/CdfmFgh+tEyo/xU8pObqAdBlfnn
         goW9L9f2q5nKkf3C/V/oUquYQvfPdQJesxgcY7wJ3ZodP/pwuFOV6Zk0hqAgUV/qxgiS
         6hEEMIsv6bbKjMpih1dfTNWGS1HR9M+nJ1+Krf9S6d5M+U1EmW5c9dVLf7fTaGhlCfXv
         sUMxsGmFD+p5RTsydE8E1Tn01zFJx6hJoNmV5d2dIDyV+VylF05dS2B/o8XfiFWPttT0
         lFVg==
X-Gm-Message-State: ACrzQf1ZiTdCRhVwY1VBfjf5gcz3cN9EfI4WI1h1c6xpG5Tc+wHw7qDG
        O0PXsMKgLKgZxQE156Pxx5RmRg==
X-Google-Smtp-Source: AMsMyM6ugcdQo4QoQpkqVPfIJKUqjKh5ecv1hn0GBLwlY/XMhuOE+o5JXOZAXwbLsTOMcDqatPuP4Q==
X-Received: by 2002:a17:902:dac5:b0:186:a687:e082 with SMTP id q5-20020a170902dac500b00186a687e082mr20966918plx.84.1667325505243;
        Tue, 01 Nov 2022 10:58:25 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id bb8-20020a170902bc8800b00179f370dbe7sm6614237plb.287.2022.11.01.10.58.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 10:58:24 -0700 (PDT)
Date:   Tue, 1 Nov 2022 17:58:21 +0000
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
Message-ID: <Y2FePYteNrEfZ7D5@google.com>
References: <20220607213604.3346000-1-seanjc@google.com>
 <20220607213604.3346000-6-seanjc@google.com>
 <20221031163907.w64vyg5twzvv2nho@linux.intel.com>
 <Y2ABrnRzg729ZZNI@google.com>
 <20221101101801.zxcjswoesg2gltri@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221101101801.zxcjswoesg2gltri@linux.intel.com>
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

On Tue, Nov 01, 2022, Yu Zhang wrote:
> On Mon, Oct 31, 2022 at 05:11:10PM +0000, Sean Christopherson wrote:
> > vmcs_config.nested never becomes out-of-date, it's read-only after __init (not
> > currently marked as such, that will be remedied soon).
> > 
> > The auditing performed by KVM is purely to guard against userspace enabling
> > features that KVM doesn't support.  KVM is not responsible for ensuring that the
> > vCPU's CPUID model match the VMX MSR model.
> 
> Do you mean the VMX MSR model shall not be changed after the cpuid updates?

No, I mean that the virtual CPU model (CPUID + VMX MSRs) that is presented to the
guest is the responsibility of host userspace.  KVM only cares about not enabling
bits/features that KVM doesn't supported.

> And for VMX MSR model, do you mean the vmx->nested.msrs or the ones in 
> vmcs_config->nested? 

vmx->nested.msrs.  vmcs_config->nested is effectively the VMX equivalent of
KVM_GET_SUPPORTED_CPUID.

> What I observed is that vmx->nested.msrs.secondary_ctls_high will be changed
> in vmx_adjust_secondary_exec_control(), which can be triggered after cpuid is
> set. 

Ugh, that path got overlooked when we yanked out KVM's manipulaton of VMX MSRs
in response to guest CPUID changes.  I wonder if we can get away with changing
KVM's behavior to only ensure a feature isn't exposed to L2 when it's not exposed
to L1.

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6b4266e949a3..cfc35d559d91 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4523,8 +4523,8 @@ vmx_adjust_secondary_exec_control(struct vcpu_vmx *vmx, u32 *exec_control,
         * Update the nested MSR settings so that a nested VMM can/can't set
         * controls for features that are/aren't exposed to the guest.
         */
-       if (nested) {
-               if (enabled)
+       if (nested && !enabled)
+               if (exiting)
                        vmx->nested.msrs.secondary_ctls_high |= control;
                else
                        vmx->nested.msrs.secondary_ctls_high &= ~control;


> Since KVM's config(vmcs_config->nested.secondary_ctls_high) is done during init
> by nested_vmx_setup_ctls_msrs(), which only kept a subset of the flags from the
> vmcs_confg->cpu_based_2nd_exec_ctrl, the vmx_restore_control_msr() could fail
> later, when userspace VMM tries to enable a feature(the only one I witnessed is
> SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE) by setting MSR_IA32_VMX_PROCBASED_CTLS2.
> Because the vmx->nested.msrs.secondary_ctls_high is updated by cpuid, but this
> bit is not taken from vmcs_conf->cpu_based_2nd_exec_ctrl by nested_vmx_setup_ctls_msrs()
> for vmcs_config->nested.secondary_ctls_high.
> 
> The failure can be fixed, simply by adding SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE in
> nested_vmx_setup_ctls_msrs(), e.g.

Assuming KVM actually supports user wait/pause in L2, this is an orthogonal bug
to the CPUID-based manipulation above.  KVM simply neglects to advertise to userspace
that ENABLE_USR_WAIT_PAUSE is supported for nested virtualization.

If KVM doesn't correctly support virtualizing user wait/pause for L2, then the
correct location to fix this is in vmx_secondary_exec_control().

> > > Another question is about the setting of secondary_ctls_high in
> > > nested_vmx_setup_ctls_msrs().  I saw there's a comment saying:
> > > 	"Do not include those that depend on CPUID bits, they are
> > > 	added later by vmx_vcpu_after_set_cpuid.".
> > 
> > That's a stale comment, see the very next commit, 8805875aa473 ("Revert "KVM: nVMX:
> > Do not expose MPX VMX controls when guest MPX disabled""), as well as the slightly
> > later commit 9389d5774aca ("Revert "KVM: nVMX: Expose load IA32_PERF_GLOBAL_CTRL
> > VM-{Entry,Exit} control"").
> > 
> 
> So the comment can be and shall be removed, right? 

Yep.

> > > 	if (cpu_has_vmx_vmfunc()) {
> > > 		msrs->secondary_ctls_high |=
> > > 			SECONDARY_EXEC_ENABLE_VMFUNC;
> > 
> > This one is still required.  KVM never enables VMFUNC for itself, i.e. it won't
> > be set in KVM's VMCS configuration.
> > 
> 
> My understanding is that, for VMFUNC, altough KVM does not support it,
> SECONDARY_EXEC_ENABLE_VMFUNC is still set in the secondary proc-based
> vm execution ctrol. KVM just uses different handlers for VMFUNC exits
> from L1(to inject the #UD) and L2(to emulate the eptp switching). So
> it doesn't matter if we do not clear this bit for vmcs_config->nested.
> procbased_ctls_high. 

Ah, you're right, I didn't realize KVM enables VMFUNC in L1.  Enabling VMFUNC for
L1 is silly though, it's trivial to clear the feature in vmx_secondary_exec_control().

That said, enabling VMFUNC in vmcs01 is an orthogonal topic, and it _is_ indeed
easier to keep the feature in the reference config.  Now that the nested config
is derived from the non-nested config, nested_vmx_setup_ctls_msrs() can do:

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 61a2e551640a..751cc67aa1a9 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6811,7 +6811,8 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
                SECONDARY_EXEC_ENABLE_INVPCID |
                SECONDARY_EXEC_RDSEED_EXITING |
                SECONDARY_EXEC_XSAVES |
-               SECONDARY_EXEC_TSC_SCALING;
+               SECONDARY_EXEC_TSC_SCALING |
+               SECONDARY_EXEC_ENABLE_VMFUNC;
 
        /*
         * We can emulate "VMCS shadowing," even if the hardware
@@ -6842,17 +6843,12 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
                }
        }
 
-       if (cpu_has_vmx_vmfunc()) {
-               msrs->secondary_ctls_high |=
-                       SECONDARY_EXEC_ENABLE_VMFUNC;
-               /*
-                * Advertise EPTP switching unconditionally
-                * since we emulate it
-                */
-               if (enable_ept)
-                       msrs->vmfunc_controls =
-                               VMX_VMFUNC_EPTP_SWITCHING;
-       }
+       /*
+        * Advertise EPTP switching if VMFUNC and EPT are supported, KVM
+        * emulates the actual EPTP switch in software.
+        */
+       if (cpu_has_vmx_vmfunc() && enable_ept)
+               msrs->vmfunc_controls = VMX_VMFUNC_EPTP_SWITCHING;
 
        /*
         * Old versions of KVM use the single-context version without
