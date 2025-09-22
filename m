Return-Path: <kvm+bounces-58385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1D9AB9231E
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 18:19:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F3D717C3D2
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 16:19:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 149A6311595;
	Mon, 22 Sep 2025 16:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yoWj5L4F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1E93054E6
	for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 16:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758557936; cv=none; b=DAVj7gGCVDf+YaKhCJaw0+f0YHdbJGj6gga7ok1SOBmJ5fX2cs+mkhvTPpSh8abEDWMdQZNuxDe1ZLKMU+TIet3f17vE2T+QJMiPHL7qPKKDS0hLrgJX3y30ihGB/D2I6VidWHgWPRcAj1SJTEF5IyhuixWyqremnHH1867YkG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758557936; c=relaxed/simple;
	bh=j0tbiuJYe5u+nQX+pGPGDa6eS/5NF6pL5f+1Wtk2GhQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CtLVjEdHdAr9rBYIE1Vw+QlkFqpZxaeB13SMW1F+S74UtYoCePZQRyzMYC7tRJB5GPf9oJ8lrwlCS1y4Yo8gnENfqkDizEBAYiJCbB571sAc6GunwYT43KSPVNZYKNt0uz4x79Lw9H503WN7Nn4alp6nHRxi3MSWFlyrYTQS+Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yoWj5L4F; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32ee4998c50so4555327a91.3
        for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 09:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758557934; x=1759162734; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Tft9W6H590i+BfaoCmKikwuvny4xpJFLnNN0qVKuogY=;
        b=yoWj5L4F7vXAzz4uPZZjNdaoDAuvqq+qUhPBTIJA1nR6GKRqd6iJwDTG/fUfNBpge6
         ppgJepeFWatU+DfCwNqqTiAKmRdlw+DLAlx7Hu7bUIHQ6WvjSZoOXgtZTLkjBEy4Zccw
         ZgSkMcyXVhQCLvNNGoAYL1b6hdP1Sh9lYWLlnqmY1rjDjK50yU5wp+66Ef8oQgtpLrFj
         dDgMS/MXnbX56VcX46jsSu+HxgLkBgycWxaqHY6kcJmBtOU2pozFIQYahj/rCYdRwf0x
         naHHGb1GqBRqjR9v/WqusOmTcVYyH7bsUYEd7wDgHN+s8RWZVJAm7YHrmC6I9qabGuiN
         yEkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758557934; x=1759162734;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tft9W6H590i+BfaoCmKikwuvny4xpJFLnNN0qVKuogY=;
        b=tmer9W422iYc582wcO9qlpCLb15ILt4EpWRrXzPf9md4fHKcjI8LVlw1J99++cIgQP
         QnV5mcVrKnqo024feksFcXW1edoSHyU6rU1l1TFfBCIHXIgfRXbjmfOz8IccqwHdFxji
         1L6nSQu8/P4TiyI0x3TXgCJzWygj6KZ8gZ+pqg1bzEhbd/qF4ZNhUxNRhYfTrUcpJOTi
         lbE4Tx7MYcQyHmu+yixq+C/vzNJSjqqFTIzsOcu7hNQKd9wG1XGxpwg/kNwIRPWdgNUI
         PG0gfBEcOkS4gcvwaDc2Ecwze9OnRl/bdywJz8F4sBJn+czQIq5YcCSAXNdvoxJLl8ML
         o5iw==
X-Forwarded-Encrypted: i=1; AJvYcCWcJ4xuGRipyXY0EFM1xGPKEYc7mNckAmwfXigab24AP1Bsa52poK2duZrxgbvGlJV1AJg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgdYhL5UjK5EkkN5Yvwgi31OntKqR/rl6MGEZwJ621hLJoVi+p
	+n6GXCtshbjWeSG2Zow0yqaE+Iq3/iW+uKLEGMGTzXb87wsaYPY7apMgIediDFJUqBZwVgqmqEI
	a4TwQkQ==
X-Google-Smtp-Source: AGHT+IHymzkiG3BEJ+XaoDM3SA3RGhdAZTXLVSYm5PvTzbo/cud73Uypt1Fvj4jCfCqaDHU1pkLP0SVJFnI=
X-Received: from pjur6.prod.google.com ([2002:a17:90a:d406:b0:32e:749d:fcc6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d40b:b0:32e:345c:54fe
 with SMTP id 98e67ed59e1d1-3309834fdfcmr16169001a91.20.1758557933895; Mon, 22
 Sep 2025 09:18:53 -0700 (PDT)
Date: Mon, 22 Sep 2025 09:18:52 -0700
In-Reply-To: <8bf4690c-36ce-46cf-8646-5238ad65086a@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com> <20250919223258.1604852-23-seanjc@google.com>
 <8bf4690c-36ce-46cf-8646-5238ad65086a@linux.intel.com>
Message-ID: <aNF27N2SCsoEx7Pt@google.com>
Subject: Re: [PATCH v16 22/51] KVM: x86/mmu: Pretty print PK, SS, and SGX
 flags in MMU tracepoints
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 22, 2025, Binbin Wu wrote:
> 
> 
> On 9/20/2025 6:32 AM, Sean Christopherson wrote:
> > Add PK (Protection Keys), SS (Shadow Stacks), and SGX (Software Guard
> > Extensions) to the set of #PF error flags handled via
> > kvm_mmu_trace_pferr_flags.  While KVM doesn't expect PK or SS #PFs
> Also SGX.

Huh.  I deliberately omitted SGX from this particular statement, as KVM supports
SGX virtualization with shadow paging.  I.e. KVM "expects" PFERR_SGX in the sense
that an EPCM violation on SGX2 hardware will show up in KVM.

Typing that out made me realize that, unless I'm forgetting/missing code, KVM
doesn't actually do the right thing with respect to intercepted #PFs with PFERR_SGX.
On SGX2 hardware, an EPCM permissions violation will trigger a #PF(SGX).  KVM isn't
aware that such exceptions effectively have nothing to do with software-visibile
page tables.  And so I'm pretty sure an EPCM violation on SGX2 hardware would put
the vCPU into an infinite loop due to KVM not realizing the #PF (ugh, or #GP if
the guest CPU model is only SGX1) should be injected into the guest, (KVM will
think the fault is spurious).

To fix that, we'd need something like the below (completely untested).  But for
this patch, the changelog is "correct", i.e. observing SGX #PFs shouldn't be
impossible.

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 08845c1d7a62..99cc790615fd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5175,12 +5175,52 @@ static bool is_xfd_nm_fault(struct kvm_vcpu *vcpu)
               !kvm_is_cr0_bit_set(vcpu, X86_CR0_TS);
 }
 
+static int vmx_handle_page_fault(struct kvm_vcpu *vcpu, u32 error_code)
+{
+       unsigned long cr2 = vmx_get_exit_qual(vcpu);
+
+       if (vcpu->arch.apf.host_apf_flags)
+               goto handle_pf;
+
+       /* When using EPT, KVM intercepts #PF only to detect illegal GPAs. */
+       WARN_ON_ONCE(enable_ept && !allow_smaller_maxphyaddr);
+
+       /*
+        * On SGX2 hardware, EPCM violations are delivered as #PF with the SGX
+        * flag set in the error code (SGX1 harware generates #GP(0)).  EPCM
+        * violations have nothing to do with shadow paging and can never be
+        * resolved by KVM; always reflect them into the guest.
+        */
+       if (error_code & PFERR_SGX_MASK) {
+               WARN_ON_ONCE(!IS_ENABLED_(CONFIG_X86_SGX_KVM) ||
+                            !cpu_feature_enabled(X86_FEATURE_SGX2));
+               if (guest_cpu_cap_has(vcpu, X86_FEATURE_SGX2))
+                       kvm_fixup_and_inject_pf_error(vcpu, cr2, error_code);
+               else
+                       kvm_inject_gp(vcpu, 0);
+               return 1;
+       }
+
+       /*
+        * If EPT is enabled, fixup and inject the #PF.  KVM intercepts #PFs
+        * only to set PFERR_RSVD as appropriate (hardware won't set RSVD due
+        * to the GPA being legal with respect to host.MAXPHYADDR).
+        */
+       if (enable_ept) {
+               kvm_fixup_and_inject_pf_error(vcpu, cr2, error_code);
+               return 1;
+       }
+
+handle_pf:
+       return kvm_handle_page_fault(vcpu, error_code, cr2, NULL, 0);
+}
+
 static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 {
        struct vcpu_vmx *vmx = to_vmx(vcpu);
        struct kvm_run *kvm_run = vcpu->run;
        u32 intr_info, ex_no, error_code;
-       unsigned long cr2, dr6;
+       unsigned long dr6;
        u32 vect_info;
 
        vect_info = vmx->idt_vectoring_info;
@@ -5255,19 +5295,8 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
                return 0;
        }
 
-       if (is_page_fault(intr_info)) {
-               cr2 = vmx_get_exit_qual(vcpu);
-               if (enable_ept && !vcpu->arch.apf.host_apf_flags) {
-                       /*
-                        * EPT will cause page fault only if we need to
-                        * detect illegal GPAs.
-                        */
-                       WARN_ON_ONCE(!allow_smaller_maxphyaddr);
-                       kvm_fixup_and_inject_pf_error(vcpu, cr2, error_code);
-                       return 1;
-               } else
-                       return kvm_handle_page_fault(vcpu, error_code, cr2, NULL, 0);
-       }
+       if (is_page_fault(intr_info))
+               return vmx_handle_page_fault(vcpu, error_code);
 
        ex_no = intr_info & INTR_INFO_VECTOR_MASK;


