Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38BDE554D74
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 16:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358715AbiFVOfq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 10:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358680AbiFVOfh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 10:35:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0CFA13C710
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 07:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655908532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mqHBzJ5IikLI/T/Qp0b//MpzSAkflYAqrEPzT2O75eE=;
        b=bifTo4NifPJ2cOUCuPzLWw+342SQxTrKosrDG7B+pjky1YooGoPOqheyl2taB/SAoUowVA
        cN826zogzPrc/iTNJGHLccecwRTStS6pAOAw9A9UzMIj3saclOabvXT1PQS9zV/NO8NYZh
        UnZbLUY9hszLLO91lIMj0QMVF9nQS80=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-2D0O1Yt2MqWPlM3wGFQ6bw-1; Wed, 22 Jun 2022 10:35:31 -0400
X-MC-Unique: 2D0O1Yt2MqWPlM3wGFQ6bw-1
Received: by mail-wm1-f70.google.com with SMTP id p6-20020a05600c358600b0039c873184b9so7931847wmq.4
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 07:35:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=mqHBzJ5IikLI/T/Qp0b//MpzSAkflYAqrEPzT2O75eE=;
        b=mjwj059yBYcvDLFYMfuJsoUpVHNmBmi4oc/nwTPZO3jTf+DvMVt/AqDOp/XZkeJvfS
         DwP1Latf69gudRjPkqX44k0xO1E+termCAmPdZGd0Dw6jTknhc70m6hBuR9BXPfaOtg4
         eLAPAcmS818q1vUixKNkdq2h0aLIruNzh/yyGJb3vDBCeKNHsCmTJ7aMNnCrbtll7PSQ
         Yk1cLqW+UHIdx+FBluvK6ayo61dR2q6RISh+bOLGc4vhjpEOZiZXpgaAQ9m4exSxzM0V
         rK/lMPVMRJ3l250DyKBfKlrO3MK6d4UJjN+WBOTqn3C4+/sRv4VZOGPxEkdri5CLpjoh
         55Gg==
X-Gm-Message-State: AJIora8qNu8zV2J1L3iBYIP6PotTjGmbECcg/J8DAyvlshODNMfsB8AK
        1DtkxDCX3rjuz+4l5sAd6Fx1ATeStfonblp1UvCfUpyVgI+0UJGI5FJNulS+CjhnVMVFpa31zPu
        wsQibHLsO/qqw
X-Received: by 2002:a5d:59a6:0:b0:21b:a234:8314 with SMTP id p6-20020a5d59a6000000b0021ba2348314mr2724829wrr.316.1655908529925;
        Wed, 22 Jun 2022 07:35:29 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uRzNKe1o2TRsk2pdleUVR343vFzLH3P88s0wFu9UOAwdJNQdDmkRYfBHgnvCVsa8OT7/f4qA==
X-Received: by 2002:a5d:59a6:0:b0:21b:a234:8314 with SMTP id p6-20020a5d59a6000000b0021ba2348314mr2724792wrr.316.1655908529685;
        Wed, 22 Jun 2022 07:35:29 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id p11-20020a05600c418b00b00397342e3830sm4923089wmh.0.2022.06.22.07.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 07:35:28 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Ilias Stamatis <ilstam@amazon.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, mail@anirudhrb.com,
        kumarpraveen@linux.microsoft.com, wei.liu@kernel.org,
        robert.bradford@intel.com, liuwe@microsoft.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Don't expose TSC scaling to L1 when on Hyper-V
In-Reply-To: <YrMenI1mTbqA9MaR@anrayabh-desk>
References: <20220613161611.3567556-1-anrayabh@linux.microsoft.com>
 <592ab920-51f3-4794-331f-8737e1f5b20a@redhat.com>
 <YqdsjW4/zsYaJahf@google.com> <YqipLpHI24NdhgJO@anrayabh-desk>
 <YqiwoOP4HX2LniI4@google.com> <87zgi5xh42.fsf@redhat.com>
 <YrMenI1mTbqA9MaR@anrayabh-desk>
Date:   Wed, 22 Jun 2022 16:35:27 +0200
Message-ID: <87r13gyde8.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Anirudh Rayabharam <anrayabh@linux.microsoft.com> writes:

> On Wed, Jun 22, 2022 at 10:00:29AM +0200, Vitaly Kuznetsov wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>> 
>> > On Tue, Jun 14, 2022, Anirudh Rayabharam wrote:
>> >> On Mon, Jun 13, 2022 at 04:57:49PM +0000, Sean Christopherson wrote:
>> 
>> ...
>> 
>> >> > 
>> >> > Any reason not to use the already sanitized vmcs_config?  I can't think of any
>> >> > reason why the nested path should blindly use the raw MSR values from hardware.
>> >> 
>> >> vmcs_config has the sanitized exec controls. But how do we construct MSR
>> >> values using them?
>> >
>> > I was thinking we could use the sanitized controls for the allowed-1 bits, and then
>> > take the required-1 bits from the CPU.  And then if we wanted to avoid the redundant
>> > RDMSRs in a follow-up patch we could add required-1 fields to vmcs_config.
>> >
>> > Hastily constructed and compile-tested only, proceed with caution :-)
>> 
>> Independently from "[PATCH 00/11] KVM: VMX: Support TscScaling and
>> EnclsExitingBitmap whith eVMCS" which is supposed to fix the particular
>> TSC scaling issue, I like the idea to make nested_vmx_setup_ctls_msrs()
>> use both allowed-1 and required-1 bits from vmcs_config. I'll pick up
>> the suggested patch and try to construct something for required-1 bits.
>
> I tried this patch today but it causes some regression which causes
> /dev/kvm to be unavailable in L1. I didn't get a chance to look into it
> closely but I am guessing it has something to do with the fact that
> vmcs_config reflects the config that L0 chose to use rather than what is
> available to use. So constructing allowed-1 MSR bits based on what bits
> are set in exec controls maybe isn't correct.

I've tried to pick it up but it's actually much harder than I think. The
patch has some minor issues ('&vmcs_config.nested' needs to be switched
to '&vmcs_conf->nested' in nested_vmx_setup_ctls_msrs()), but the main
problem is that the set of controls nested_vmx_setup_ctls_msrs() needs
is NOT a subset of vmcs_config (setup_vmcs_config()). I was able to
identify at least:

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5e14e4c40007..8076352174ad 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2483,8 +2483,14 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
              CPU_BASED_INVLPG_EXITING |
              CPU_BASED_RDPMC_EXITING;
 
-       opt = CPU_BASED_TPR_SHADOW |
+       opt = CPU_BASED_INTR_WINDOW_EXITING |
+             CPU_BASED_NMI_WINDOW_EXITING |
+             CPU_BASED_TPR_SHADOW |
+             CPU_BASED_USE_IO_BITMAPS |
              CPU_BASED_USE_MSR_BITMAPS |
+             CPU_BASED_MONITOR_TRAP_FLAG |
+             CPU_BASED_RDTSC_EXITING |
+             CPU_BASED_PAUSE_EXITING |
              CPU_BASED_ACTIVATE_SECONDARY_CONTROLS |
              CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
        if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_PROCBASED_CTLS,
@@ -2582,6 +2588,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 #endif
        opt = VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |
              VM_EXIT_LOAD_IA32_PAT |
+             VM_EXIT_SAVE_IA32_PAT |
              VM_EXIT_LOAD_IA32_EFER |
              VM_EXIT_CLEAR_BNDCFGS |
              VM_EXIT_PT_CONCEAL_PIP |
@@ -2604,7 +2611,11 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
                _pin_based_exec_control &= ~PIN_BASED_POSTED_INTR;
 
        min = VM_ENTRY_LOAD_DEBUG_CONTROLS;
-       opt = VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL |
+       opt =
+#ifdef CONFIG_X86_64
+             VM_ENTRY_IA32E_MODE |
+#endif
+             VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL |
              VM_ENTRY_LOAD_IA32_PAT |
              VM_ENTRY_LOAD_IA32_EFER |
              VM_ENTRY_LOAD_BNDCFGS |

but it is 1) not sufficient because some controls are smartly filtered
out just because we don't want them for L1 -- and this doesn't mean that
L2 doesn't need them and 2) because if we add some 'opt' controls to
setup_vmcs_config() we need to filter them out somewhere else.

I'm starting to think we may just want to store raw VMX MSR values in
vmcs_config first, then sanitize them (eVMCS, vmx preemtoion timer bug,
perf_ctrl bug,..) and then do the adjust_vmx_controls() magic. 

I'm not giving up yet but don't expect something small and backportable
to stable :-) 

-- 
Vitaly

