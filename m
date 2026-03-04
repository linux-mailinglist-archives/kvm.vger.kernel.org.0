Return-Path: <kvm+bounces-72637-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qI2TCdGIp2nliAAAu9opvQ
	(envelope-from <kvm+bounces-72637-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 02:20:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B95A51F92ED
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 02:20:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3A5D5306B5AE
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 01:20:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58A913093C3;
	Wed,  4 Mar 2026 01:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AVYh89Ce"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E5430B520
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 01:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772587207; cv=none; b=lZJPgzYG4GZaAx77coKUJMlJ+1i66A1KIutyrHq8ALfLbZzqTVTZi8PIlgqIzcnRTGw3BZNCSp2SqGHK3Xq0MxpHdceu7tddRsKw+mCviRdLoI1XGvMRlZTj+Y5wOzbS7FHJv+ro7RyxEQRTFXQd2VF/+aZ8cGApKqAuv89WoeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772587207; c=relaxed/simple;
	bh=WXtNWyzEy6zmJ8lPvjTixTQyzkBBKDWeUk0mIbYM6lM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NcNEoqBPcomyW/PwDT4CWmuOdkM6Xlo21Y28ZDZIch1UirUAbu5CDz1C/maeaznB2AJHRTgFCR14OhaYnbZ1NkaIbwDv/vdx2UjYoNmLV/sieYVdDidTe4Yx4aV85b92fBfCCWKStcP6UPxJMiy1Ce4fQXvD+XQCI9jfQMTEhoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AVYh89Ce; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-358e95e81aeso29556210a91.0
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 17:20:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772587205; x=1773192005; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oBoM0J3CXqbdN4xxDEVBLdipwHOmKkbJsAA0VcnSKH4=;
        b=AVYh89CeKwddx8fOlOVE8Y7ChQOfNPOgOhJPuPyiFE+6TFhQjTe3Ef4T41NcucWf5v
         oaiou3oPUNz+O82YzVVy1J+RGfIdGo+Kt3Qt6UgTkzhDovwjweyIvoIc99aqokj2l8ez
         Fbq4cad7mA+zUGkS7Qnpz9bz5q0WDMKt4sMvnYC/PMoUdF+MgGD1MNNTxsEYWZLevZsq
         FJgMZf0qdPzCQpSR5HW4KydqPAJtch7Mw8HJ5KRRcAv8f0CqwqfmFtDmC6JIBdiTGw9I
         4htPb/hiuGQoBaSURxGHsqV5Gzz2qcFqgu2Y2y/Ufq7h7RRznFOOu0a0OqK9VSI/kgee
         WavQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772587205; x=1773192005;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oBoM0J3CXqbdN4xxDEVBLdipwHOmKkbJsAA0VcnSKH4=;
        b=k3vHYLpZR1tB6imdiWUmB9lUODTu4TmqQSEmTUTLGEWcl2SKZiS04jzUzkRGPaNZEb
         VHjYy2711wF92iOKvQKWPOY7UQYXGPZDRFudw9+nTuKo/HKUJ0ucIk5nIb/QIrSA+6q/
         NGSYnx/oucKbl4ftVJr6z9dNyOlCpw787P5IM7iu2XZokVClbXdUBA8z+z4YLvZwhVfF
         uyrS2doWKdJDgOm9AVTnHh59mNWq0tJpDIG2YMG4AoOt4ookOmYQE1adkrrp/0dFdkNj
         12IDpEo+ZZ0GOdq2P0EXJoiZPS+V56MpPOKb68gGKIkQJGryJVUDDYT82CZk5tzGNwwk
         8Z0A==
X-Forwarded-Encrypted: i=1; AJvYcCX3linUzk9JviDLdZlihYQ1OpLPqg/TX3fPXaDZHEzd5ot3rrz3loz9YU88JCZmk2os3vI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzGOnzKBc3glo8u+XDoP5qJjTJGCTcNh/UwNYZW9afzO4dvFxr
	4ofDiSoGGrrb9+HK/pwbBu6ncxDtStO2aDmbvuRCy++0ozeVQF5o/neyexpFozFX1MvZu47uwGJ
	nmO6l1Q==
X-Received: from pjbdj7.prod.google.com ([2002:a17:90a:d2c7:b0:359:81f5:3dea])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c11:b0:359:94af:586b
 with SMTP id 98e67ed59e1d1-359a6a7ccc1mr392361a91.33.1772587205387; Tue, 03
 Mar 2026 17:20:05 -0800 (PST)
Date: Tue, 3 Mar 2026 17:20:04 -0800
In-Reply-To: <j4t4v6n6hg5d7qxz722yecwtafphf55xgyrs5bnyowwa7emzfp@ceajjnpem4vk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260304002223.1105129-1-seanjc@google.com> <20260304002223.1105129-3-seanjc@google.com>
 <j4t4v6n6hg5d7qxz722yecwtafphf55xgyrs5bnyowwa7emzfp@ceajjnpem4vk>
Message-ID: <aaeIxLBM1rUeSPs3@google.com>
Subject: Re: [PATCH v5 2/2] KVM: nSVM: Always intercept VMMCALL when L2 is active
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: B95A51F92ED
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72637-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6]
X-Rspamd-Action: no action

On Wed, Mar 04, 2026, Yosry Ahmed wrote:
> On Tue, Mar 03, 2026 at 04:22:23PM -0800, Sean Christopherson wrote:
> > Always intercept VMMCALL now that KVM properly synthesizes a #UD as
> > appropriate, i.e. when L1 doesn't want to intercept VMMCALL, to avoid
> > putting L2 into an infinite #UD loop if KVM_X86_QUIRK_FIX_HYPERCALL_INSN
> > is enabled.
> > 
> > By letting L2 execute VMMCALL natively and thus #UD, for all intents and
> > purposes KVM morphs the VMMCALL intercept into a #UD intercept (KVM always
> > intercepts #UD).  When the hypercall quirk is enabled, KVM "emulates"
> > VMMCALL in response to the #UD by trying to fixup the opcode to the "right"
> > vendor, then restarts the guest, without skipping the VMMCALL.  As a
> > result, the guest sees an endless stream of #UDs since it's already
> > executing the correct vendor hypercall instruction, i.e. the emulator
> > doesn't anticipate that the #UD could be due to lack of interception, as
> > opposed to a truly undefined opcode.
> > 
> > Fixes: 0d945bd93511 ("KVM: SVM: Don't allow nested guest to VMMCALL into host")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/svm/hyperv.h | 4 ----
> >  arch/x86/kvm/svm/nested.c | 7 -------
> >  2 files changed, 11 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/hyperv.h b/arch/x86/kvm/svm/hyperv.h
> > index 9af03970d40c..f70d076911a6 100644
> > --- a/arch/x86/kvm/svm/hyperv.h
> > +++ b/arch/x86/kvm/svm/hyperv.h
> > @@ -51,10 +51,6 @@ static inline bool nested_svm_is_l2_tlb_flush_hcall(struct kvm_vcpu *vcpu)
> >  void svm_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu);
> >  #else /* CONFIG_KVM_HYPERV */
> >  static inline void nested_svm_hv_update_vm_vp_ids(struct kvm_vcpu *vcpu) {}
> > -static inline bool nested_svm_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu)
> > -{
> > -	return false;
> > -}
> 
> Why is this dropped? We still need it for vmmcall_interception under
> !CONFIG_KVM_HYPERV, right?

Nope, because vmmcall_interception() uses nested_svm_is_l2_tlb_flush_hcall(), and
the previous patch created a stub for that one.  I.e. only the non-stub
CONFIG_KVM_HYPERV=y version references nested_svm_l2_tlb_flush_enabled().

