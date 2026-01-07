Return-Path: <kvm+bounces-67268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 491F7D00005
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 21:26:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8F0FB30133EE
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 20:26:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60563338585;
	Wed,  7 Jan 2026 20:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NkGzPQ7l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D1F2DEA7A
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 20:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767817598; cv=none; b=lydToixi5d6zbT+Ay35Cs6LyHbsvgDJ3jRHPiW74j4227LFlYT4TPwnm6g4+yayZgQImgqC4lQReuPe7Vle9b2JVwskcfpNZ/nEiDUlFbcOGOSF0sqje2lqIVQsUpkTjIkL7CTGZlow51+Dk3Gv4B/gIzrxfSx6TlABkW+O/F1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767817598; c=relaxed/simple;
	bh=YWyxU/k0Mp4ZkLGCfAsfY27rBV1JmN5lmhmwnKWE8mI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hkHMzZlfKHyEhAUEga39Czfxg1vINojdruFB5Dh90U0cRpeIrkTdho5bj1C56/vdeaLPe7eGcd53i3dPw0Dhov71HNvR/IY9Wm74DwtDeZCJ3MQ+ZD7oir4vOOoCaTIiR247EdwnySE46Y0KDqtXkWWCE8L3u7MY2RCnMepyfF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NkGzPQ7l; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a0fe4ade9eso27765445ad.0
        for <kvm@vger.kernel.org>; Wed, 07 Jan 2026 12:26:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767817597; x=1768422397; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CsoItjovREIZYxetg6rcpfyKc8gupMs4pUCId31XNsM=;
        b=NkGzPQ7lvyih1LO8fVbTlKiZ75L4lcIA2/ploBjB7Sgk9mkcw1B7xFFpFtT5OqbFgj
         6qZLIyL7HbvJXSpF0qzEhE0oEC7sPwEAMh4mvt23KIVsCB7mY7z4TKHJb0u18s6s2Vwe
         CeGnNqaVSOna3OUY/8lKzaeWv86rR32it8bE+7PtwdzpWeOPQLKlqH4apNsTlk7KkhGT
         dqDMcSr1i1YHf4XeiPI7Z2LB9QzRm45OMivwQKM0bQONVo++JqjRkyOFqdNB3eFpHTfu
         9E+hr2f22sTnPn6mp1geN/or0vsVRjONBIWHrdsUokvoxjENUCczc/7Tx71KzQ/xc1fk
         aUYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767817597; x=1768422397;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CsoItjovREIZYxetg6rcpfyKc8gupMs4pUCId31XNsM=;
        b=sFTGexRmDNGFA4o5JLvWPC8/NSfD0J6fy803OzgvOo2wNL+WJM4+uvVOgsEeFGiTIZ
         wAm0T+lKeuzWrWbDjT0KIiMXd6X+yhghKQIpQebSA/DHCnwJegEKcd1idUaHOztwjnIl
         60GCyQR/2BnMrXkPSlW6b5ClCohzww7WHpCOwzs7c8N63644Rb+m2xtVEU5h1vdQ/ZqH
         22ojgm5dpzRF7fjWBVz9vkgwlWgkRiuH6rifMymIkkSXEMBjf73MsGeQq8YPz74rQ4E1
         R6Iv9fbR9XuFnr662GerghIrAODcr+bbTXAuQg1pga2L42TZ7VyJonoWIyzvv0SZUQXk
         Pz/A==
X-Forwarded-Encrypted: i=1; AJvYcCU+El4gvDk0NakkN96Vw+XNPsKqJYhXbguLPhWv//eLLYAzV2gFEOmHFNXNaX/bWd02QvA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxcdo+EaNYrO0ZsOFp2VxZ7ue6s3uo8zNwzjtRukOur8LTVByF2
	pAyv4pCvR24UwyE+8yW0hWvv363WsRCAS2mzcFdkn8FR7Vugh6Nc49nLKpRD3zmwVvFUGzyqTOr
	nztUOSw==
X-Google-Smtp-Source: AGHT+IGTQp8h1kLtlKev9LhcYdbZPkpIr4HJH3gtESE8OQAlg41p7sVR2D1YicwFAm7r4ks6pGsYokdc19I=
X-Received: from plbbh11.prod.google.com ([2002:a17:902:a98b:b0:2a0:dab8:9117])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2a85:b0:2a0:8f6f:1a0d
 with SMTP id d9443c01a7336-2a3ee4c0fefmr34205855ad.61.1767817596631; Wed, 07
 Jan 2026 12:26:36 -0800 (PST)
Date: Wed, 7 Jan 2026 12:26:35 -0800
In-Reply-To: <shaevlgw5h7i3oxtoj6yqun3mklwdi6nng3noypxeqevnuqlcu@urfhn55x7owk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251230205641.4092235-1-seanjc@google.com> <shaevlgw5h7i3oxtoj6yqun3mklwdi6nng3noypxeqevnuqlcu@urfhn55x7owk>
Message-ID: <aV7Be9k2KBEQCisT@google.com>
Subject: Re: [PATCH] KVM: x86: Disallow setting CPUID and/or feature MSRs if
 L2 is active
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 02, 2026, Yosry Ahmed wrote:
> On Tue, Dec 30, 2025 at 12:56:41PM -0800, Sean Christopherson wrote:

> > diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> > index fdab0ad49098..9084e0dfa15c 100644
> > --- a/arch/x86/kvm/x86.h
> > +++ b/arch/x86/kvm/x86.h
> > @@ -172,9 +172,9 @@ static inline void kvm_nested_vmexit_handle_ibrs(struct kvm_vcpu *vcpu)
> >  		indirect_branch_prediction_barrier();
> >  }
> >  
> > -static inline bool kvm_vcpu_has_run(struct kvm_vcpu *vcpu)
> > +static inline bool kvm_can_set_cpuid_and_feature_msrs(struct kvm_vcpu *vcpu)
> >  {
> > -	return vcpu->arch.last_vmentry_cpu != -1;
> > +	return vcpu->arch.last_vmentry_cpu == -1 && !is_guest_mode(vcpu);
> >  }
> 
> To make this self-contained (e.g. for readers not coming from
> kvm_set_cpuid()), should we add a comment here about is_guest_mode()
> only possibly being true with last_vmentry_cpu == -1 if userspace does
> the set CPUID, set nested state, set CPUID again dance?

Ya.  If this looks good, I'll add it when applying.

/*
 * Disallow modifying CPUID and feature MSRs, which affect the core virtual CPU
 * model exposed to the guest and virtualized by KVM, if the vCPU has already
 * run or is in guest mode (L2).  In both cases, KVM has already consumed the
 * current virtual CPU model, and doesn't support "unwinding" to react to the
 * new model.
 *
 * Note, the only way is_guest_mode() can be true with 'last_vmentry_cpu == -1'
 * is if userspace sets CPUID and feature MSRs (to enable VMX/SVM), then sets
 * nested state, and then attempts to set CPUID and/or feature MSRs *again*.
 */
static inline bool kvm_can_set_cpuid_and_feature_msrs(struct kvm_vcpu *vcpu)
{
	return vcpu->arch.last_vmentry_cpu == -1 && !is_guest_mode(vcpu);
}

