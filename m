Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 215A632D88E
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 18:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237058AbhCDRZI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 12:25:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233695AbhCDRYm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 12:24:42 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 620BCC061756
        for <kvm@vger.kernel.org>; Thu,  4 Mar 2021 09:24:02 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id u18so10333630plc.12
        for <kvm@vger.kernel.org>; Thu, 04 Mar 2021 09:24:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yEg9qQ9+Lh0kR3V9SEuUm28SfP2oct9m6aZdQ9sZc1A=;
        b=THVuTBpyCwu9YWCG7jYg5nbREA0QwBvrWEpolfxArJG8WKP/h0Fip0usH3PXPRiD0o
         urV33e+liUCmzCtbRedmIoP4mHUsv/urfbj9pv7aLfnJFzS5t3e9fRoLO7c2KWbaMaPg
         bvWLThStTEpHZccm+y8InV7sBBxcYcCm26SOfjw4q7CWouHaDSYBkqbB/hDLPkgjRIsI
         LyZdzYfQnOKwwD+EVHmwKi5kgqOOyrhpHqXLfb1X5wUwxCCafswD92lHLng71bJj77Bl
         15yn8iykRH4rieDrN2+99t/fQPU7rY9rC3P6xr6zdZiEWWpKesq7VTDP/yUraV3Hxoeq
         +0JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yEg9qQ9+Lh0kR3V9SEuUm28SfP2oct9m6aZdQ9sZc1A=;
        b=K3XPkBjZJCvMktwgLdX/ijZgLla77NQ6lMF4gqq4/JEVzLVQt0Oo6gfrhy6uKujLCu
         wZS9d4Dl5xkiPfqrs5UN27y0lf+S+Z7xw9e2ulOr5uVlKRevzeEv3SLTMmvdhD/CYWmF
         0rvt+gdD9c4Ov1+MAH46GLaO3NA8ZAxw675HAz9mzR9EVYFjfic0u/0Jzirc77Ab/68l
         Rpvacl2ljdCQl1RigVtpi7CrK66Pp4xoUg5qNzQTRvd85RYH9tFjmOb+lRpb3e6B+Qiw
         LMgUQMZIl9k7WCaW67EXbdrhLYIOQjs1p69LgYVHqgE1UAlSb4416SbWlmakfXmRYC5Q
         xE7g==
X-Gm-Message-State: AOAM5334D6lBJzYwo5xpsNDZ2mZ8yoNadGPrOzlnS2BgllU0hPgPEjho
        sip54SZLMiTTB9MjJzFTrpuqMg==
X-Google-Smtp-Source: ABdhPJwfPFA7trtIGjUv1OTpERHQQL1X64kdEtO6Bt2U6eyu5H/RMinMlpabgpREF29EKOOiK9ukIQ==
X-Received: by 2002:a17:90a:ff15:: with SMTP id ce21mr5631029pjb.172.1614878641748;
        Thu, 04 Mar 2021 09:24:01 -0800 (PST)
Received: from google.com ([2620:15c:f:10:9857:be95:97a2:e91c])
        by smtp.gmail.com with ESMTPSA id q4sm19465pfq.103.2021.03.04.09.23.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 09:24:01 -0800 (PST)
Date:   Thu, 4 Mar 2021 09:23:53 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     "Xu, Like" <like.xu@intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>, wei.w.wang@intel.com,
        Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
Subject: Re: [PATCH v3 7/9] KVM: vmx/pmu: Add Arch LBR emulation and its VMCS
 field
Message-ID: <YEEXqf3b4uaSdNKv@google.com>
References: <20210303135756.1546253-1-like.xu@linux.intel.com>
 <20210303135756.1546253-8-like.xu@linux.intel.com>
 <YD/GrQAl1NMPHXFj@google.com>
 <267c408c-6999-649b-d733-8d64f9cf0594@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <267c408c-6999-649b-d733-8d64f9cf0594@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 04, 2021, Xu, Like wrote:
> On 2021/3/4 1:26, Sean Christopherson wrote:
> > On Wed, Mar 03, 2021, Like Xu wrote:
> > > New VMX controls bits for Arch LBR are added. When bit 21 in vmentry_ctrl
> > > is set, VM entry will write the value from the "Guest IA32_LBR_CTL" guest
> > > state field to IA32_LBR_CTL. When bit 26 in vmexit_ctrl is set, VM exit
> > > will clear IA32_LBR_CTL after the value has been saved to the "Guest
> > > IA32_LBR_CTL" guest state field.
> > ...
> > 
> > > @@ -2529,7 +2532,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
> > >   	      VM_EXIT_LOAD_IA32_EFER |
> > >   	      VM_EXIT_CLEAR_BNDCFGS |
> > >   	      VM_EXIT_PT_CONCEAL_PIP |
> > > -	      VM_EXIT_CLEAR_IA32_RTIT_CTL;
> > > +	      VM_EXIT_CLEAR_IA32_RTIT_CTL |
> > > +	      VM_EXIT_CLEAR_IA32_LBR_CTL;
> > So, how does MSR_ARCH_LBR_CTL get restored on the host?  What if the host wants
> > to keep _its_ LBR recording active while the guest is running?
> 
> Thank you!
> 
> I will add "host_lbrctlmsr" field to "struct vcpu_vmx" and
> repeat the update/get_debugctlmsr() stuff.

I am not remotely confident that tracking LBRCTL via vcpu_vmx is correct, and
I'm far less confident that the existing DEBUGCTL logic is correct.  As Jim
pointed out[*], intel_pmu_handle_irq() can run at any time, and it's not at all
clear to me that the DEBUGCTL coming out of the NMI handler is guaranteed to be
the same value going in.  Ditto for LBRCTL.

Actually, NMIs aside, KVM's DEBUGCTL handling is provably broken since writing
/sys/devices/cpu/freeze_on_smi is propagated to other CPUs via IRQ, and KVM
snapshots DEBUCTL on vCPU load, i.e. runs with IRQs enabled long after grabbing
the value.

  WARNING: CPU: 5 PID: 0 at arch/x86/events/intel/core.c:4066 flip_smm_bit+0xb/0x30
  RIP: 0010:flip_smm_bit+0xb/0x30
  Call Trace:
   <IRQ>
   flush_smp_call_function_queue+0x118/0x1a0
   __sysvec_call_function+0x2c/0x90
   asm_call_irq_on_stack+0x12/0x20
   </IRQ>


So, rather than pile on more MSR handling that is at best dubious, and at worst
broken, I would like to see KVM properly integrate with perf to ensure KVM
restores the correct, fresh values of all MSRs that are owned by perf.  Or at
least add something that guarantees that intel_pmu_handle_irq() preserves the
MSRs.  As is, it's impossible to review these KVM changes without deep, deep
knowledge of what perf is doing.

https://lkml.kernel.org/r/20210209225653.1393771-1-jmattson@google.com
