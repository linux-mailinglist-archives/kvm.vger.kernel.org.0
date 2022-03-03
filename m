Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC31E4CCA35
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 00:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237291AbiCCXpU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 18:45:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231986AbiCCXpT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 18:45:19 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E3513DE0F
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 15:44:32 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id w37so6036174pga.7
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 15:44:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PFCXWc8pvRnOKeQh6fV/wDjA7xdq/FhBB89rRK/lzh0=;
        b=Ff0FuJHtf0lrp40vpHJNJP/zcXCdv6yaAIJ5ZEM151u39NuUmaXICxI+UbQ9+aT/GH
         cUy0oCTGS46L4XNVaqlwWariaJ+07hQOKaxshfQge+8S5UwLJxLZnU9SNKlzkpPxEY6O
         nTatiDLzUIOJO5J4xTkRup17XSMf38T5jUHZh5opDAAUaon21Ir9R+yvniUJrI0Eenbw
         I4gmecSzyVFvqK+PhPc8lOaMplyECGQQ02Jvl7qF2ZhtjnkBAaffOgVE/+D32YY11ILT
         1CLbRpbmPs0maYxv+0/jlL4yTExmZmg0rVg6FJ9V94k3xVnfQOGrOohqinZ1wU/uN/VQ
         AqPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PFCXWc8pvRnOKeQh6fV/wDjA7xdq/FhBB89rRK/lzh0=;
        b=KmNu9yp5gR9SLa/L0gwxbJ3CzF5/8mw2MkD153TI6ODw3XHPwOJOT8NK4DGsqFPDES
         2dv/z0SvDJhfoVEICyY3cbp2+d1wIQOxuoaInvCkvii9AwmuwRZ1RshQUVBBJrgk9HzB
         Uy4rff9WeFNBlFskKhLI8RpfWUDFRcQzeqqrUW//zGzZO0Lh8mA8q+/k2rvxbPP5dhI9
         ZY2Xbiguz6y8fMevhuSWFlzEZmTEHQZF45OFv/iB9YYZVK5SMA9DqoMqchjwEvFw8g+T
         MSUCN7m87LJetLUiGJ1JfWe0nruAEjUbl6U8NVoboOrnikvhiHWDymreaGxUHidYja8t
         A0jA==
X-Gm-Message-State: AOAM531KGA5/8161rVIgwfBgaRO9xIEFI/+drv2fVndUbVUG/gBk8KMU
        02t8yIDNVK8RD/bNMIq3DQnSNw==
X-Google-Smtp-Source: ABdhPJzBKA5q+7Y/gCz/WBKrB/JEyH6LUWBxEJGvbAr5VT/8TL8b+7ol0HoZTV0MH7TdBqEfzvNClA==
X-Received: by 2002:a05:6a00:1aca:b0:4e1:a2b6:5b9 with SMTP id f10-20020a056a001aca00b004e1a2b605b9mr40349021pfv.4.1646351071582;
        Thu, 03 Mar 2022 15:44:31 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a11-20020a63cd4b000000b00378b9167493sm2963275pgj.52.2022.03.03.15.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 15:44:30 -0800 (PST)
Date:   Thu, 3 Mar 2022 23:44:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>
Subject: Re: [PATCH v4 1/8] KVM: nVMX: Keep KVM updates to BNDCFGS ctrl bits
 across MSR write
Message-ID: <YiFS241NF6oXaHjf@google.com>
References: <4e678b4f-4093-fa67-2c4e-e25ec2ced6d5@redhat.com>
 <Yh5pYhDQbzWQOdIx@google.com>
 <b839fa78-c8ec-7996-dba7-685ea48ca33d@redhat.com>
 <Yh/Y3E4NTfSa4I/g@google.com>
 <4d4606f4-dbc9-d3a4-929e-0ea07182054c@redhat.com>
 <Yh/nlOXzIhaMLzdk@google.com>
 <YiAdU+pA/RNeyjRi@google.com>
 <78abcc19-0a79-4f8b-2eaf-c99b96efea42@redhat.com>
 <YiDps0lOKITPn4gv@google.com>
 <CALMp9eRGNfF0Sb6MTt2ueSmxMmHoF2EgT-0XR=ovteBMy6B2+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eRGNfF0Sb6MTt2ueSmxMmHoF2EgT-0XR=ovteBMy6B2+Q@mail.gmail.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 03, 2022, Jim Mattson wrote:
> On Thu, Mar 3, 2022 at 8:15 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Thu, Mar 03, 2022, Paolo Bonzini wrote:
> > > On 3/3/22 02:43, Sean Christopherson wrote:
> > > > > Maybe I can redirect you to a test case to highlight a possible
> > > > > regression in KVM, as seen by userspace;-)
> > > > Regressions aside, VMCS controls are not tied to CPUID, KVM should not be mucking
> > > > with unrelated things.  The original hack was to fix a userspace bug and should
> > > > never have been mreged.
> > >
> > > Note that it dates back to:
> > >
> > >     commit 5f76f6f5ff96587af5acd5930f7d9fea81e0d1a8
> > >     Author: Liran Alon <liran.alon@oracle.com>
> > >     Date:   Fri Sep 14 03:25:52 2018 +0300
> > >
> > >     KVM: nVMX: Do not expose MPX VMX controls when guest MPX disabled
> > >     Before this commit, KVM exposes MPX VMX controls to L1 guest only based
> > >     on if KVM and host processor supports MPX virtualization.
> > >     However, these controls should be exposed to guest only in case guest
> > >     vCPU supports MPX.
> > >
> > > It's not to fix a userspace bug, it's to support userspace that doesn't
> > > know about using KVM_SET_MSR for VMX features---which is okay since unlike
> > > KVM_SET_CPUID2 it's not a mandatory call.
> >
> > I disagree, IMO failure to properly configure the vCPU model is a userspace bug.
> > Maybe it was a userspace bug induced by a haphazard and/or poorly documented KVM
> > ABI, but it's still a userspace bug.  One could argue that KVM should disable/clear
> > VMX features if userspace clears a related CPUID feature, but _setting_ a VMX
> > feature based on CPUID is architecturally wrong.  Even if we consider one or both
> > cases to be desirable behavior in terms of creating a consistent vCPU model, forcing
> > a consistent vCPU model for this one case goes against every other ioctl in KVM's
> > ABI.
> >
> > If we consider it KVM's responsibility to propagate CPUID state to VMX MSRs, then
> > KVM has a bunch of "bugs".
> >
> >   X86_FEATURE_LM => VM_EXIT_HOST_ADDR_SPACE_SIZE, VM_ENTRY_IA32E_MODE, VMX_MISC_SAVE_EFER_LMA
> >
> >   X86_FEATURE_TSC => CPU_BASED_RDTSC_EXITING, CPU_BASED_USE_TSC_OFFSETTING,
> >                      SECONDARY_EXEC_TSC_SCALING
> >
> >   X86_FEATURE_INVPCID_SINGLE => SECONDARY_EXEC_ENABLE_INVPCID
> >
> >   X86_FEATURE_MWAIT => CPU_BASED_MONITOR_EXITING, CPU_BASED_MWAIT_EXITING
> >
> >   X86_FEATURE_INTEL_PT => SECONDARY_EXEC_PT_CONCEAL_VMX, SECONDARY_EXEC_PT_USE_GPA,
> >                           VM_EXIT_CLEAR_IA32_RTIT_CTL, VM_ENTRY_LOAD_IA32_RTIT_CTL
> >
> >   X86_FEATURE_XSAVES => SECONDARY_EXEC_XSAVES
> 
> I don't disagree with you, but this does beg the question, "What's
> going on with all of the invocations of cr4_fixed1_update()?"

Boo, I forgot legal CR4 is controlled via MSRs too.  Ha!  That's a bug in nVMX.
nVMX only checks msrs.cr4_fixed0/1, it doesn't check "cr4_reserved_bits", which
is KVM's set of host reserved bits.  That means userspace can bypass those reserved
bits by setting guest CPUID and/or VMX MSRs and loading CR4 via VM-Enter/VM-Exit.

The immediate nVMX bug can be fixed by calling kvm_is_valid_cr4(), which calls
back into nVMX to do the VMX MSR checks.

My vote would be to include nested_vmx_cr_fixed1_bits_update() in the quirk, but
keep the guest CPUID enforcement that's in kvm_is_valid_cr4().  I.e. let userspace
further restrict CR4, but don't let it allow nested VM-Enter/VM-Exit to load bits
that L1 can't set via MOV CR4.

I'll send this as a proper patch:

diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index c92cea0b8ccc..46dd1967ec08 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -285,8 +285,8 @@ static inline bool nested_cr4_valid(struct kvm_vcpu *vcpu, unsigned long val)
 }

 /* No difference in the restrictions on guest and host CR4 in VMX operation. */
-#define nested_guest_cr4_valid nested_cr4_valid
-#define nested_host_cr4_valid  nested_cr4_valid
+#define nested_guest_cr4_valid kvm_is_valid_cr4
+#define nested_host_cr4_valid  kvm_is_valid_cr4

 extern struct kvm_x86_nested_ops vmx_nested_ops;

