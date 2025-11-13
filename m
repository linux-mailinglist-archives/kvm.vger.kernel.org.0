Return-Path: <kvm+bounces-63051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A29DC5A133
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 22:16:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 3B8713570CF
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 21:14:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B44FC323401;
	Thu, 13 Nov 2025 21:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ktvq+WeH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04253322C63
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 21:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763068436; cv=none; b=M9icZSBO4/pfMsL3iVRsu4teKD7d5sVG1lDxtCI3M0ZK/VaY45sXyglXxjKW/hpboIlwwxkPBFGEPQsapxi/Z3sdxR//fs09tErenVqDmyLdDniJTuP0WCHE0/KEwc9BcRgEOqGw31nZmXJiw6YkP3Hi2KRthDEow/UKdaBBboM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763068436; c=relaxed/simple;
	bh=DnIexTHpzvjBGBFzV8QE9KCINTHDtVxr4Hsraeu6cnE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GmiSY1P93oNW4vMpMANbH/TgdYXa70GI8S0m/k99RsOI25DWzuZ5SnWmWwxH6FFvOpye7n5snSwzYxTKCIggNMHox0SfUXI6qviYhQ6QuMOuEvIFffE4RRhUdf+WvDVn810rCo7RXZ3ECMFmS4h7K/QBT8+m5kZQpM0U1P+WtP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ktvq+WeH; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34176460924so1190204a91.3
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 13:13:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763068434; x=1763673234; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MhA8XeDcLItuSts88+qBJgae963RL9ht3JVZVuBMQ7c=;
        b=ktvq+WeHDGFii1nA7X/ElyHOQ+1GbRTar7SAtDlD62Gl+4AAq/5CEZeOvv7878bkPs
         ggE7JU9B3lCR1uaAh0OtYIHr7EecJ3BBbnVLxH6+COQGt+UAZRdlGYU3TjHpll8JqSBS
         3vs4AE/Okx7lU56+7Ir8Xa8avG+I5dtPnFp7IhEkKaAshVnw3/eGET4OPxbEBMjkuMJj
         jx0JfYGaHBwto9fyvwnQQP44wb/zINYSip4D6WOPrDQoElEY4OjrBiUE74WKYHSWVTvn
         RtE+ERJZZQKTXBCV7/pucZfx4dOVwz4uMjJsolV9K7CID2X2QcMYgtd0ascdgHJOOCym
         Jn4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763068434; x=1763673234;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MhA8XeDcLItuSts88+qBJgae963RL9ht3JVZVuBMQ7c=;
        b=q3tbXTKUNIARF3LpAY6p5CxhEbdeho2e0LLJR6MRohKWR/Hl0ozOpjzv0OZS3grKgO
         QukWemIFSOBC869apaTvL7ZBZAmKEzCiejIgYRIOAHWCguskN7AhCop27E2PexYT1map
         Xm8j09e1U9TMAFYoVSc1IhrCK4iOkk0qAU5do3q7lrypub4CfNdC0iatqgNEpuMAN95W
         XjoueOHlIrYmGVS2kRc7cYqo4U+++zDcIIUPLvYOURndlL8CjvDnnJ20hO/PXEXKsrnr
         G8bLJUM5LD8Wbne1vpFLvAFMBbGdx6rSx0Fe6N8NHofUzvq7GKO0JWI0Fz6vyK2wJkNm
         jL6Q==
X-Gm-Message-State: AOJu0YwSvIHglAHgROYZuoBSx8KWYH72+QWrFpmyIvVj1lP9R2t6mTVs
	tN7XetFwTXlDKd+Wfq5LgUyKZsUV575MsjA8urCx5sdgD8YQSAFk40O7jwCrC26plyHVMNDPQo5
	MKRYfsA==
X-Google-Smtp-Source: AGHT+IGHGC2EocwEKjKPYlAnEjFxu0WXmQhmLW3g8ducLttMJdS8O+5mLxZoN+tlVzLn0h1TTBSUPhIWfbA=
X-Received: from pjbcm23.prod.google.com ([2002:a17:90a:fa17:b0:340:b55d:7a07])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e18c:b0:336:b60f:3936
 with SMTP id 98e67ed59e1d1-343f9e9f23bmr819967a91.12.1763068434308; Thu, 13
 Nov 2025 13:13:54 -0800 (PST)
Date: Thu, 13 Nov 2025 13:13:52 -0800
In-Reply-To: <72da0532-908b-40c2-a4e4-7ef1895547c7@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251110063212.34902-1-dongli.zhang@oracle.com>
 <aRScMffMkpsdi5vs@google.com> <72da0532-908b-40c2-a4e4-7ef1895547c7@oracle.com>
Message-ID: <aRZKEC4n9hpLVCRp@google.com>
Subject: Re: [PATCH v2 1/1] KVM: VMX: configure SVI during runtime APICv activation
From: Sean Christopherson <seanjc@google.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	chao.gao@intel.com, pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, joe.jin@oracle.com, 
	alejandro.j.jimenez@oracle.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 12, 2025, Dongli Zhang wrote:
> Hi Sean,
> 
> On 11/12/25 6:47 AM, Sean Christopherson wrote:
> > On Sun, Nov 09, 2025, Dongli Zhang wrote:
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 91b6f2f3edc2..653b8b713547 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -4430,6 +4430,14 @@ void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
> >                                                  kvm_vcpu_apicv_active(vcpu));
> >  
> >         vmx_update_msr_bitmap_x2apic(vcpu);
> > +
> > +       /*
> > +        * Refresh SVI if APICv is enabled, as any changes KVM made to vISR
> > +        * while APICv was disabled need to be reflected in SVI, e.g. so that
> > +        * the next accelerated EOI will clear the correct vector in vISR.
> > +        */
> > +       if (kvm_vcpu_apicv_active(vcpu))
> > +               kvm_apic_update_hwapic_isr(vcpu);
> >  }
> >  
> >  static u32 vmx_exec_control(struct vcpu_vmx *vmx)
> > @@ -6880,7 +6888,7 @@ void vmx_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
> >  
> >         /*
> >          * If L2 is active, defer the SVI update until vmcs01 is loaded, as SVI
> > -        * is only relevant for if and only if Virtual Interrupt Delivery is
> > +        * is only relevant for L2 if and only if Virtual Interrupt Delivery is
> >          * enabled in vmcs12, and if VID is enabled then L2 EOIs affect L2's
> >          * vAPIC, not L1's vAPIC.  KVM must update vmcs01 on the next nested
> >          * VM-Exit, otherwise L1 with run with a stale SVI.
> 
> 
> As a quick reply, the idea is to call kvm_apic_update_hwapic_isr() in
> vmx_refresh_apicv_exec_ctrl(), instead of __kvm_vcpu_update_apicv().
> 
> I think the below case doesn't work:
> 
> 1. APICv is activated when vCPU is in L2.
> 
> kvm_vcpu_update_apicv()
> -> __kvm_vcpu_update_apicv()
>    -> vmx_refresh_apicv_exec_ctrl()
> 
> vmx_refresh_apicv_exec_ctrl() returns after setting:
> vmx->nested.update_vmcs01_apicv_status = true.
> 
> 
> 2. On exit from L2 to L1, __nested_vmx_vmexit() requests for KVM_REQ_APICV_UPDATE.
> 
> __nested_vmx_vmexit()
> -> leave_guest_mode(vcpu)
> -> kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu)
> 
> 
> 3. vCPU processes KVM_REQ_APICV_UPDATE again.
> 
> This time, __kvm_vcpu_update_apicv() returns without calling
> refresh_apicv_exec_ctrl(), because (apic->apicv_active == activate).
> 
> vmx_refresh_apicv_exec_ctrl() doesn't get any chance to be called.

Oof, that's nasty.

> In order to call kvm_apic_update_hwapic_isr() in vmx_refresh_apicv_exec_ctrl(),
> we may need to resolve the issue mentioned by Chao, for instance, with something
> like:
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index bcea087b642f..1725c6a94f99 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -19,6 +19,7 @@
>  #include "trace.h"
>  #include "vmx.h"
>  #include "smm.h"
> +#include "x86_ops.h"
> 
>  static bool __read_mostly enable_shadow_vmcs = 1;
>  module_param_named(enable_shadow_vmcs, enable_shadow_vmcs, bool, S_IRUGO);
> @@ -5216,7 +5217,7 @@ void __nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32
> vm_exit_reason,
> 
>         if (vmx->nested.update_vmcs01_apicv_status) {
>                 vmx->nested.update_vmcs01_apicv_status = false;
> -               kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
> +               vmx_refresh_apicv_exec_ctrl(vcpu);
>         }

Hmm, what if we go the opposite direction and bundle the vISR update into
KVM_REQ_APICV_UPDATE?  Then we can drop nested.update_vmcs01_hwapic_isr, and
hopefully avoid similar ordering issues in the future.

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 564f5af5ae86..7bf44a8111e5 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5168,11 +5168,6 @@ void __nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
                kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
        }
 
-       if (vmx->nested.update_vmcs01_hwapic_isr) {
-               vmx->nested.update_vmcs01_hwapic_isr = false;
-               kvm_apic_update_hwapic_isr(vcpu);
-       }
-
        if ((vm_exit_reason != -1) &&
            (enable_shadow_vmcs || nested_vmx_is_evmptr12_valid(vmx)))
                vmx->nested.need_vmcs12_to_shadow_sync = true;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6f374c815ce2..64edf47bed02 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6907,7 +6907,7 @@ void vmx_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
                 */
                WARN_ON_ONCE(vcpu->wants_to_run &&
                             nested_cpu_has_vid(get_vmcs12(vcpu)));
-               to_vmx(vcpu)->nested.update_vmcs01_hwapic_isr = true;
+               to_vmx(vcpu)->nested.update_vmcs01_apicv_status = true;
                return;
        }
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index bc3ed3145d7e..17bd43d6faaf 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -135,7 +135,6 @@ struct nested_vmx {
        bool reload_vmcs01_apic_access_page;
        bool update_vmcs01_cpu_dirty_logging;
        bool update_vmcs01_apicv_status;
-       bool update_vmcs01_hwapic_isr;
 
        /*
         * Enlightened VMCS has been enabled. It does not mean that L1 has to
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9c2e28028c2b..445bf22ee519 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11218,8 +11218,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
                if (kvm_check_request(KVM_REQ_HV_STIMER, vcpu))
                        kvm_hv_process_stimers(vcpu);
 #endif
-               if (kvm_check_request(KVM_REQ_APICV_UPDATE, vcpu))
+               if (kvm_check_request(KVM_REQ_APICV_UPDATE, vcpu)) {
                        kvm_vcpu_update_apicv(vcpu);
+                       kvm_apic_update_hwapic_isr(vcpu);
+               }
                if (kvm_check_request(KVM_REQ_APF_READY, vcpu))
                        kvm_check_async_pf_completion(vcpu);

