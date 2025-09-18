Return-Path: <kvm+bounces-58047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A5524B86EAA
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 22:34:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A2CB5663FB
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 20:34:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4257C2EFDB1;
	Thu, 18 Sep 2025 20:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ugo19fez"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB65B2D0602
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 20:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758227678; cv=none; b=DGZmMongA1nb57NuPaM7BxuaVhOsE8552QQQ0Z73t93iLXHObPvId8YYR4aSPukt1RVtFeXHBRNFjr3LndgLg4cYH914ow0hlqecifz02nqVi1JR5Jud+B53dw2MGZRpbQF1aofjZEz5gfCroBvBAgyMjQsjn2/v7WL/XUSSejU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758227678; c=relaxed/simple;
	bh=TNlRLl4c9UDfjC84aA8G4KJ4ljf2HUpu3dv4ZBWDSDo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XuXX47P9F39RlGV7q+laB4LN67IXrlQqUSIlvT/tCEpnNtp7iIzCh9+LMzwA1JAUmxpuIFP2HC9O0/cGqsWuuG2ouYT9OVvxv4Xid5t3vxx1twoftBT/JhsaIi5hoorv3ytKHtNgZbGYVAalsttDWL8qm2mhMkkSojZmbGcC6Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ugo19fez; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32ec69d22b2so1428567a91.1
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 13:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758227676; x=1758832476; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XBODMdbQGpyv3o1i/C7a9yrUe2tedQBqvCU7igvUACQ=;
        b=ugo19fezcS05F1sa4Gdb4bUJmMsyB+r7GowBGWFuHWnHlHC339NBIMmjVN/yUt8zwn
         i9ErNkSKj4ubjF0DdJICGKPRbly27rhqkTliz32Ahhs3sbPY6d+oRIcaPOF+WSp8aEBW
         KTV1GxyIPzKHVHHQi7PgVPliBg1o2RM/r4V0miaA9Fa8Dhip6aOAXVkI5KRObW6IBSL1
         feEK5XBGHH4r5nSm5hhXLdkcA9G4wqDEYKT5KmLll5PyRL20FyIFI3fViNPFtNBZ8XcI
         WuyfM+CVld31MPFXXltv8sZTDtEevNnMwn03lvN/geUMcsFIO52PkmC9puLbh2KNNP6m
         ohWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758227676; x=1758832476;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XBODMdbQGpyv3o1i/C7a9yrUe2tedQBqvCU7igvUACQ=;
        b=LoSSGN32PQkfQk2q/WcGaouV4BmkO2TcXyidJr8rQhHOcsKi/6f5tFbg7FzsW4CUGK
         eEA823MOPOBs500nXR7hofyCxuzZIxY0Eg/t/VgHIDLJxrbj4Q41g2Cbj44/zBjsannN
         9nCHITabeST6SGg3Otwn/WVzeyGgF8l9JOi4yNWAVWvYliN5+wZalAxupZ8eAlMQMWrW
         ZTCgbe9CqfZEF4AQo9jQP7y3a7rN5S3jVFnUyRlrDsipBAfcKQ3UyXoujtCL7W3Gr8ex
         RGOz/mqglfsLb6ynJ0T5vLmx0+OcoqPNHgFVQPKZ14cP9Tji5LlfkS7husTHMcm02gIR
         RVLA==
X-Forwarded-Encrypted: i=1; AJvYcCWvD36NN4AApHqzgvsKJH2Q2XFXeCnfLiZEcerSQW/sVPm7qDJhoLconsLBg+2+6Z5N9H4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKIl/IN/fdZ3YKWXccQMBK759ibAAxn1flN59hYsuhRyZNX5B9
	7CtFk3Z5ImqBzgIHsMiD2HNDdvD/T91Ufbj9X9jEpi8cjsXw4tCSF5E0nzsHO4/+SiNIkIzw/W3
	TBsQGOg==
X-Google-Smtp-Source: AGHT+IERMigXNRqnLSigGWkoYGfo80aGu0GfE+30vipr87ezRtoiMl4FHd/dkvILTWnAeCpXl1EhKp58i6w=
X-Received: from pjyf8.prod.google.com ([2002:a17:90a:ec88:b0:330:429d:b28c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4cd1:b0:32e:e18a:3691
 with SMTP id 98e67ed59e1d1-33098386c95mr936918a91.35.1758227676194; Thu, 18
 Sep 2025 13:34:36 -0700 (PDT)
Date: Thu, 18 Sep 2025 13:34:34 -0700
In-Reply-To: <aMxiIRrDzIqNj2Do@AUSJOHALLEN.amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com> <20250912232319.429659-30-seanjc@google.com>
 <aMmynhOnU/VkcXwI@AUSJOHALLEN.amd.com> <aMnAVtWhxQipw9Er@google.com>
 <aMnJYWKf63Ay+pIA@AUSJOHALLEN.amd.com> <aMnY7NqhhnMYqu7m@google.com>
 <aMnq5ceM3l340UPH@AUSJOHALLEN.amd.com> <aMxiIRrDzIqNj2Do@AUSJOHALLEN.amd.com>
Message-ID: <aMxs2taghfiOQkTU@google.com>
Subject: Re: [PATCH v15 29/41] KVM: SEV: Synchronize MSR_IA32_XSS from the
 GHCB when it's valid
From: Sean Christopherson <seanjc@google.com>
To: John Allen <john.allen@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Sep 18, 2025, John Allen wrote:
> On Tue, Sep 16, 2025 at 05:55:33PM -0500, John Allen wrote:
> > On Tue, Sep 16, 2025 at 02:38:52PM -0700, Sean Christopherson wrote:
> > > On Tue, Sep 16, 2025, John Allen wrote:
> > > > On Tue, Sep 16, 2025 at 12:53:58PM -0700, Sean Christopherson wrote:
> > > > > On Tue, Sep 16, 2025, John Allen wrote:
> > > > > > On Fri, Sep 12, 2025 at 04:23:07PM -0700, Sean Christopherson wrote:
> > > > > > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > > > > > index 0cd77a87dd84..0cd32df7b9b6 100644
> > > > > > > --- a/arch/x86/kvm/svm/sev.c
> > > > > > > +++ b/arch/x86/kvm/svm/sev.c
> > > > > > > @@ -3306,6 +3306,9 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
> > > > > > >  	if (kvm_ghcb_xcr0_is_valid(svm))
> > > > > > >  		__kvm_set_xcr(vcpu, 0, kvm_ghcb_get_xcr0(ghcb));
> > > > > > >  
> > > > > > > +	if (kvm_ghcb_xss_is_valid(svm))
> > > > > > > +		__kvm_emulate_msr_write(vcpu, MSR_IA32_XSS, kvm_ghcb_get_xss(ghcb));
> > > > > > > +
> > > > > > 
> > > > > > It looks like this is the change that caused the selftest regression
> > > > > > with sev-es. It's not yet clear to me what the problem is though.
> > > > > 
> > > > > Do you see any WARNs in the guest kernel log?
> > > > > 
> > > > > The most obvious potential bug is that KVM is missing a CPUID update, e.g. due
> > > > > to dropping an XSS write, consuming stale data, not setting cpuid_dynamic_bits_dirty,
> > > > > etc.  But AFAICT, CPUID.0xD.1.EBX (only thing that consumes the current XSS) is
> > > > > only used by init_xstate_size(), and I would expect the guest kernel's sanity
> > > > > checks in paranoid_xstate_size_valid() to yell if KVM botches CPUID emulation.
> > > > 
> > > > Yes, actually that looks to be the case:
> > > > 
> > > > [    0.463504] ------------[ cut here ]------------
> > > > [    0.464443] XSAVE consistency problem: size 880 != kernel_size 840
> > > > [    0.465445] WARNING: CPU: 0 PID: 0 at arch/x86/kernel/fpu/xstate.c:638 paranoid_xstate_size_valid+0x101/0x140
> > > 
> > > Can you run with the below printk tracing in the host (and optionally tracing in
> > > the guest for its updates)?  Compile tested only.
> > 
> > Interesting, I see "Guest CPUID doesn't have XSAVES" times the number of
> > cpus followed by "XSS already set to val = 0, eliding updates" times the
> > number of cpus. This is with host tracing only. I can try with guest
> > tracing too in the morning.
> 
> Ok, I think I see the problem. The cases above where we were seeing the
> added print statements from kvm_set_msr_common were not situations where
> we were going through the __kvm_emulate_msr_write via
> sev_es_sync_from_ghcb. When we call __kvm_emulate_msr_write from this
> context, we never end up getting to kvm_set_msr_common because we hit
> the following statement at the top of svm_set_msr:
> 
> if (sev_es_prevent_msr_access(vcpu, msr))
> 	return vcpu->kvm->arch.has_protected_state ? -EINVAL : 0;

Gah, I was looking for something like that but couldn't find it, obviously.

> So I'm not sure if this would force using the original method of
> directly setting arch.ia32_xss or if there's some additional handling
> here that we need in this scenario to allow the msr access.

Does this fix things?  If so, I'll slot in a patch to extract setting XSS to
the helper, and then this patch can use that API.  I like the symmetry between
__kvm_set_xcr() and __kvm_set_xss(), and I especially like not doing a generic
end-around on svm_set_msr() by calling kvm_set_msr_common() directly.

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 945f7da60107..ace9f321d2c9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2213,6 +2213,7 @@ unsigned long kvm_get_cr8(struct kvm_vcpu *vcpu);
 void kvm_lmsw(struct kvm_vcpu *vcpu, unsigned long msw);
 int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr);
 int kvm_emulate_xsetbv(struct kvm_vcpu *vcpu);
+int __kvm_set_xss(struct kvm_vcpu *vcpu, u64 xss);
 
 int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr);
 int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr);
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 94d9acc94c9a..462aebc54135 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3355,7 +3355,7 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
                __kvm_set_xcr(vcpu, 0, kvm_ghcb_get_xcr0(svm));
 
        if (kvm_ghcb_xss_is_valid(svm))
-               __kvm_emulate_msr_write(vcpu, MSR_IA32_XSS, kvm_ghcb_get_xss(svm));
+               __kvm_set_xss(vcpu, kvm_ghcb_get_xss(svm));
 
        /* Copy the GHCB exit information into the VMCB fields */
        exit_code = kvm_ghcb_get_sw_exit_code(svm);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5bbc187ab428..9b81e92a8de5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1313,6 +1313,22 @@ int kvm_emulate_xsetbv(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_emulate_xsetbv);
 
+int __kvm_set_xss(struct kvm_vcpu *vcpu, u64 xss)
+{
+       if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
+               return KVM_MSR_RET_UNSUPPORTED;
+
+       if (xss & ~vcpu->arch.guest_supported_xss)
+               return 1;
+       if (vcpu->arch.ia32_xss == xss)
+               return 0;
+
+       vcpu->arch.ia32_xss = xss;
+       vcpu->arch.cpuid_dynamic_bits_dirty = true;
+       return 0;
+}
+EXPORT_SYMBOL_GPL(__kvm_set_xss);
+
 static bool kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
        return __kvm_is_valid_cr4(vcpu, cr4) &&
@@ -4119,16 +4135,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
                }
                break;
        case MSR_IA32_XSS:
-               if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
-                       return KVM_MSR_RET_UNSUPPORTED;
-
-               if (data & ~vcpu->arch.guest_supported_xss)
-                       return 1;
-               if (vcpu->arch.ia32_xss == data)
-                       break;
-               vcpu->arch.ia32_xss = data;
-               vcpu->arch.cpuid_dynamic_bits_dirty = true;
-               break;
+               return __kvm_set_xss(vcpu, data);
        case MSR_SMI_COUNT:
                if (!msr_info->host_initiated)
                        return 1;

