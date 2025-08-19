Return-Path: <kvm+bounces-55032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B3823B2CC54
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 20:45:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 80283560440
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 18:45:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A6C531CA65;
	Tue, 19 Aug 2025 18:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PQWxKkIO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B732D23C50F
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 18:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755629146; cv=none; b=Vm2/PgVCdMzd+k32UAWHxPUAqX97CVdXuyo6Y24Vce+Dguur9ght6O9d26HaQIZiKYXPCqQW0RLbfXtPyB31FtS/h4anHa1RSWzq5oOOOK1e6cjopJBHO/JOUIKXEs9uijsaXOvy7CQSBskMNvzRdcBAIQFUSTeU/7VDrxsZ/rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755629146; c=relaxed/simple;
	bh=TTL4EqUCNjyV/uP44MW11hKcEj7eoV7nSrj6UfFEI+g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YedmXbsWffrHPEOG9ioSyzBd6kEbVCqDquC7XtXirgftnnx73ypFTLEtKef/F9yIWIHpZdcKj7qixG8jX3wGSufx7pB5FwASAb9Y4JknvAKqPNEuV2JjJ1DRVXRSjsI5GWN5Tb2mxTcY737yZsUW2GIgnDTKEI8saPxzsUc0ww0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PQWxKkIO; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b471757d82fso4489406a12.3
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 11:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755629144; x=1756233944; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dL5HtHdhdJWG4Dezo4hkSgPof2Jcf7TXqbAhrXxjT58=;
        b=PQWxKkIOz4zUHwLz5BVnL/cliy0zNUjcYSsCuURB/yCkHLfW/U7hHtTcq4j1WQpHPS
         nDfq5dC3Bh8pPiH6fv19vwI1uktTTglJ4r/vllObfIyFaXlMwm34WBCQlb3HEMim4OK8
         RexfOhIkgQehp/tnykiuEaup5EWUSn8hAuv8sIZEqtzFf+lfluRpuD2GlljcM/RYspUT
         Uznr+dcqNAOU6a265Hvh5e+0bFTFntyrdJPTjX/3JWcgs0j2ZRQXflGcbSLkLIheOJuu
         ERIdU/9ZRICOfa4q8LgJgE4NnNM7d9TtCWmRdCNq3E5TyirMxJxVrm9nhQPfN3aJgc6x
         TvJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755629144; x=1756233944;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dL5HtHdhdJWG4Dezo4hkSgPof2Jcf7TXqbAhrXxjT58=;
        b=tiVO5rfMcKd7ZOeLd0Fri8TIjqIlShVISp5QSGl8OcUP1S2xvkcwbxJjdNNElnGRe4
         uQcfQTu0dDz/P44LsptCA3K0Qz/fdRlHo9RVLryojH00ddfX4C2QxqN9U6m+vryLPL44
         9LQJbkQz0BnX/DE9ckjPEu7Loziq+yQ7rFhKTU+ucs1AdlPqukmQicuJJ0gJ4NCy2NcK
         jAMNo7q/2Vx8KR+m8xUHzZ/2Rt0dOF/I6bA6qKMqJFu7ktpYLSNNM1IZD3Xbo1XKZOEY
         kV/KbDOr5kPjRdE0d4W35VXG+aoRTFIPm/i122gV3f0er1Uv0u/Bz8mV0ofxjb1fmuEx
         cuVA==
X-Forwarded-Encrypted: i=1; AJvYcCXj4m0kz1h64ChrSCjv0HiTk37gF3tea8KEB+Eiav2ClGETJrPwyTVlvUXHTiIz0TFwwiQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8k8bcF99OS8/PXb+cLrpMk7LwJa8Ez38KZMivGzK+kC4leruV
	jDQP6GoNAE6/QJMB212CgJHDBK1y8yukzTB0INEIyWOvUCaNo1Yk5WkCkSCfFbzY76Y76OsWJ8i
	EmoLUHg==
X-Google-Smtp-Source: AGHT+IHZ+b7fcv57ZQ8qNEhtUAa7AZF+5/24y9I69qzT4UEvUDk0IsdsCOq8kpM4DLUHcBRQMxFilCKwUEc=
X-Received: from pfkh2.prod.google.com ([2002:a05:6a00:2:b0:76e:287a:90e0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:938c:b0:239:374d:d729
 with SMTP id adf61e73a8af0-2431b7f6d10mr527097637.7.1755629144051; Tue, 19
 Aug 2025 11:45:44 -0700 (PDT)
Date: Tue, 19 Aug 2025 11:45:42 -0700
In-Reply-To: <77edb8d9-4093-49fe-963c-56da76514d4c@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250812025606.74625-1-chao.gao@intel.com> <20250812025606.74625-18-chao.gao@intel.com>
 <aKSiNh43UCosGIVh@google.com> <77edb8d9-4093-49fe-963c-56da76514d4c@zytor.com>
Message-ID: <aKTGVvOb8PZ7mzVr@google.com>
Subject: Re: [PATCH v12 17/24] KVM: VMX: Set up interception for CET MSRs
From: Sean Christopherson <seanjc@google.com>
To: Xin Li <xin@zytor.com>
Cc: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	mlevitsk@redhat.com, rick.p.edgecombe@intel.com, weijiang.yang@intel.com, 
	Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Aug 19, 2025, Xin Li wrote:
> On 8/19/2025 9:11 AM, Sean Christopherson wrote:
> > On Mon, Aug 11, 2025, Chao Gao wrote:
> > > From: Yang Weijiang <weijiang.yang@intel.com>
> > > 
> > > Enable/disable CET MSRs interception per associated feature configuration.
> > > 
> > > Shadow Stack feature requires all CET MSRs passed through to guest to make
> > > it supported in user and supervisor mode
> > 
> > I doubt that SS _requires_ CET MSRs to be passed through.  IIRC, the actual
> > reason for passing through most of the MSRs is that they are managed via XSAVE,
> > i.e. _can't_ be intercepted without also intercepting XRSTOR.
> > 
> > > while IBT feature only depends on
> > > MSR_IA32_{U,S}_CETS_CET to enable user and supervisor IBT.
> > > 
> > > Note, this MSR design introduced an architectural limitation of SHSTK and
> > > IBT control for guest, i.e., when SHSTK is exposed, IBT is also available
> > > to guest from architectural perspective since IBT relies on subset of SHSTK
> > > relevant MSRs.
> > > 
> > > Suggested-by: Sean Christopherson <seanjc@google.com>
> > > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > > Tested-by: Mathias Krause <minipli@grsecurity.net>
> > > Tested-by: John Allen <john.allen@amd.com>
> > > Signed-off-by: Chao Gao <chao.gao@intel.com>
> > > ---
> > >   arch/x86/kvm/vmx/vmx.c | 20 ++++++++++++++++++++
> > >   1 file changed, 20 insertions(+)
> > > 
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > index bd572c8c7bc3..130ffbe7dc1a 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -4088,6 +4088,8 @@ void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu)
> > >   void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
> > >   {
> > > +	bool set;
> > 
> > s/set/intercept
> > 
> 
> Maybe because you asked me to change "flag" to "set" when reviewing FRED
> patches, however "intercept" does sound better, and I just changed it :)

Ah crud.  I had a feeling I was flip-flopping.  I obviously don't have a strong
preference.

> > > +
> > >   	if (!cpu_has_vmx_msr_bitmap())
> > >   		return;
> > > @@ -4133,6 +4135,24 @@ void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
> > >   		vmx_set_intercept_for_msr(vcpu, MSR_IA32_FLUSH_CMD, MSR_TYPE_W,
> > >   					  !guest_cpu_cap_has(vcpu, X86_FEATURE_FLUSH_L1D));
> > > +	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
> > > +		set = !guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK);
> > > +
> > > +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP, MSR_TYPE_RW, set);
> > > +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP, MSR_TYPE_RW, set);
> > > +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP, MSR_TYPE_RW, set);
> > > +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP, MSR_TYPE_RW, set);
> > > +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_INT_SSP_TAB, MSR_TYPE_RW, set);
> > 
> > MSR_IA32_INT_SSP_TAB isn't managed via XSAVE, so why is it being passed through?
> 
> It's managed in VMCS host and guest areas, i.e. HOST_INTR_SSP_TABLE and
> GUEST_INTR_SSP_TABLE, if the "load CET" bits are set in both VM entry
> and exit controls.

Ah, "because it's essentially free".  Unless there's a true need to pass it through,
I think it makes sense to intercept.  Merging KVM's bitmap with vmcs12's bitmap
isn't completely free (though it's quite cheap).  More importantly, this is technically
wrong due to MSR_IA32_INT_SSP_TAB not existing if the vCPU doesn't have LM.  That's
obviously easy to solve, I just don't see the point.

