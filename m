Return-Path: <kvm+bounces-72631-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mLhCMGqAp2lJiAAAu9opvQ
	(envelope-from <kvm+bounces-72631-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 01:44:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FA841F8F9C
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 01:44:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0F2D33035A64
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 00:44:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF9F42FE053;
	Wed,  4 Mar 2026 00:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t8cOi5ey"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1785B1C5486
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 00:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772585062; cv=none; b=XAzzZt5W0A9LQznTM/Xenk4Pokwn2lx5UStT9hruFtrFT2pFuEEGpf/GuRms2+E2HeLuSlOvhFXmKUVHv1r4QNq7hrGloSYPmvqicH8BA6Jc2uuBvG7Cd6fC57ziLntjWwHzaMI8Ky/Bszvee3GoOf84zrI0mCIUaalFKYVGhOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772585062; c=relaxed/simple;
	bh=8EUfImJqXCjwEv07osmggtN7dOfogWe0w9ZDpEIMa58=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HWMsS0AcMzHiD/E69twighU36ZXh0ItOXFIs/MfTyMeT4qhRdoKZ4jLtOIlvCxAwa3VLuTMcD8EJjApSllBkbypXn196oZm5oKhB8eJRqlKMvcxZEsxvoJsJkoFEweP06raLB0FdfzR3iZ3e7Sqz5RARkxqYIEh1yfv+6weWw5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t8cOi5ey; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c6fd07933aaso3351201a12.0
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 16:44:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772585060; x=1773189860; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2TShG9/ZQ57MX/DikZ+o/2CGuAlBGVqbkJk365Mxb28=;
        b=t8cOi5eyGUfddZApwlSXf16xFCFV2yhoeqxi73ZzjREe9QCD3FlSIgsMG8UgIbdjpC
         884Pbwmt7J8eW1+b69A/MfJsRxaJ6hLURkTXZFRa+hxYaZCSo+CqoU06jamEiyUFrl0i
         ufgbTuCL1BVbLj/Wivfk2oochP3rt0gHXc9vDcZYIwCh+jYB3yz9a8DRS6Rsx0ZObCm4
         4nNuF29IKv7jYOg6snvJeBTkbfscwxId0RB6ndVAYFQbhe9deL5Sf8lRWK84Nc4O437e
         7fEfqJVBCoYffgQKg6u2kZBRGWVjd+XceqwCY4A6UYXOczMV2Dr3nicv0S6zUgF0DFTY
         dX9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772585060; x=1773189860;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2TShG9/ZQ57MX/DikZ+o/2CGuAlBGVqbkJk365Mxb28=;
        b=Ix6vXheLkB9Ys1GHfAeZiYbYyRBp81mobPFgi0TVLsvTMsol2hI8rj8mchAKArdozY
         CKFX7cj9zfoIzFpvKKLje8tTmXH1mTTgkyFS49+BCZytMaPorYKHRtvzhFtcATXUIkH/
         TJqRLkEFxvAxDXKtg3NnGADjnFBhVc9Ps7go9Rvi/YBN548dpZX62/YrAZrgzQc4tumr
         gSFwnxxmI9deM44R0m+2wOCy6z6zpGOL1BPY0WMwS+0ylPLK1lEh6Ofn33g3XEWaJBwd
         S4yXIJSPZJ8/wpOUK7yrRmEWvLuCo5o8jxIp3k4I8Y7Xm3RFyVOUBr+xcvWgSakJp6Zy
         kMnw==
X-Forwarded-Encrypted: i=1; AJvYcCXuKspx1oIqLMxXuxIyrKaiCTEnx23LSOstM/D3swMfCXCpH6qrK7+rhCKydp7ywSBYev8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGQdFpaE28FW2FhNPxf1daKzyTF5cL7Bi3/4MQqh+v2uVf9Ye1
	GWWuZL3f9bC35ZOiUkiNFeFO8HyJ7TK83n4rdDUpY9aQK+I4Sm2WB8MAw14YsP7B/yBqDM7Lt91
	E9h/Waw==
X-Received: from pgbfq7.prod.google.com ([2002:a05:6a02:2987:b0:c6e:18ac:7af8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:d794:b0:393:e25b:7d77
 with SMTP id adf61e73a8af0-3982dd55feemr145106637.13.1772585060135; Tue, 03
 Mar 2026 16:44:20 -0800 (PST)
Date: Tue, 3 Mar 2026 16:44:18 -0800
In-Reply-To: <CAO9r8zMDQkHAMKVewDgvH6_WAHo5eL4=Xwf7h=87JPOJPYQAFQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260303003421.2185681-1-yosry@kernel.org> <20260303003421.2185681-4-yosry@kernel.org>
 <aacOPmIS7HUtzJA6@google.com> <CAO9r8zMDQkHAMKVewDgvH6_WAHo5eL4=Xwf7h=87JPOJPYQAFQ@mail.gmail.com>
Message-ID: <aaeAYv2i7wjGahY4@google.com>
Subject: Re: [PATCH v7 03/26] KVM: SVM: Add missing save/restore handling of
 LBR MSRs
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 4FA841F8F9C
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
	TAGGED_FROM(0.00)[bounces-72631-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Tue, Mar 03, 2026, Yosry Ahmed wrote:
> > > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > So all in all (not yet tested), this?  If this is the only issue in the series,
> > or at least in the stable@ part of the series, no need for a v8 (I've obviously
> > already done the fixup).
> 
> Looks good with a minor nit below (could be a followup).
> 
> > @@ -3075,6 +3075,38 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
> >                 vmcb_mark_dirty(svm->vmcb, VMCB_LBR);
> >                 svm_update_lbrv(vcpu);
> >                 break;
> > +       case MSR_IA32_LASTBRANCHFROMIP:
> > +               if (!lbrv)
> > +                       return KVM_MSR_RET_UNSUPPORTED;
> > +               if (!msr->host_initiated)
> > +                       return 1;
> > +               svm->vmcb->save.br_from = data;
> > +               vmcb_mark_dirty(svm->vmcb, VMCB_LBR);
> > +               break;
> > +       case MSR_IA32_LASTBRANCHTOIP:
> > +               if (!lbrv)
> > +                       return KVM_MSR_RET_UNSUPPORTED;
> > +               if (!msr->host_initiated)
> > +                       return 1;
> > +               svm->vmcb->save.br_to = data;
> > +               vmcb_mark_dirty(svm->vmcb, VMCB_LBR);
> > +               break;
> > +       case MSR_IA32_LASTINTFROMIP:
> > +               if (!lbrv)
> > +                       return KVM_MSR_RET_UNSUPPORTED;
> > +               if (!msr->host_initiated)
> > +                       return 1;
> > +               svm->vmcb->save.last_excp_from = data;
> > +               vmcb_mark_dirty(svm->vmcb, VMCB_LBR);
> > +               break;
> > +       case MSR_IA32_LASTINTTOIP:
> > +               if (!lbrv)
> > +                       return KVM_MSR_RET_UNSUPPORTED;
> > +               if (!msr->host_initiated)
> > +                       return 1;
> > +               svm->vmcb->save.last_excp_to = data;
> > +               vmcb_mark_dirty(svm->vmcb, VMCB_LBR);
> > +               break;
> 
> There's so much repeated code here. 

Ya :-(

> We can use gotos to share code, but I am not sure if that's a strict
> improvement. We can also use a helper, perhaps?


Where's your sense of adventure?

	case MSR_IA32_LASTBRANCHFROMIP:
	case MSR_IA32_LASTBRANCHTOIP:
	case MSR_IA32_LASTINTFROMIP:
	case MSR_IA32_LASTINTTOIP:
		if (!lbrv)
			return KVM_MSR_RET_UNSUPPORTED;
		if (!msr->host_initiated)
			return 1;
		*(&svm->vmcb->save.br_from + (ecx - MSR_IA32_LASTBRANCHFROMIP)) = data;
		vmcb_mark_dirty(svm->vmcb, VMCB_LBR);
		break;

Jokes aside, maybe this, to dedup get() at the same time?

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 68b747a94294..f1811105e89f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2720,6 +2720,23 @@ static int svm_get_feature_msr(u32 msr, u64 *data)
        return 0;
 }
 
+static __always_inline u64 *svm_vmcb_lbr(struct vcpu_svm *svm, u32 msr)
+{
+       switch (msr) {
+       case MSR_IA32_LASTBRANCHFROMIP:
+               return &svm->vmcb->save.br_from;
+       case MSR_IA32_LASTBRANCHTOIP:
+               return &svm->vmcb->save.br_to;
+       case MSR_IA32_LASTINTFROMIP:
+               return &svm->vmcb->save.last_excp_from;
+       case MSR_IA32_LASTINTTOIP:
+               return &svm->vmcb->save.last_excp_to;
+       default:
+               break;
+       }
+       BUILD_BUG();
+}
+
 static bool sev_es_prevent_msr_access(struct kvm_vcpu *vcpu,
                                      struct msr_data *msr_info)
 {
@@ -2838,16 +2855,10 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
                msr_info->data = lbrv ? svm->vmcb->save.dbgctl : 0;
                break;
        case MSR_IA32_LASTBRANCHFROMIP:
-               msr_info->data = lbrv ? svm->vmcb->save.br_from : 0;
-               break;
        case MSR_IA32_LASTBRANCHTOIP:
-               msr_info->data = lbrv ? svm->vmcb->save.br_to : 0;
-               break;
        case MSR_IA32_LASTINTFROMIP:
-               msr_info->data = lbrv ? svm->vmcb->save.last_excp_from : 0;
-               break;
        case MSR_IA32_LASTINTTOIP:
-               msr_info->data = lbrv ? svm->vmcb->save.last_excp_to : 0;
+               msr_info->data = lbrv ? *svm_vmcb_lbr(svm, msr_info->index) : 0;
                break;
        case MSR_VM_HSAVE_PA:
                msr_info->data = svm->nested.hsave_msr;
@@ -3122,35 +3133,14 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
                svm_update_lbrv(vcpu);
                break;
        case MSR_IA32_LASTBRANCHFROMIP:
-               if (!lbrv)
-                       return KVM_MSR_RET_UNSUPPORTED;
-               if (!msr->host_initiated)
-                       return 1;
-               svm->vmcb->save.br_from = data;
-               vmcb_mark_dirty(svm->vmcb, VMCB_LBR);
-               break;
        case MSR_IA32_LASTBRANCHTOIP:
-               if (!lbrv)
-                       return KVM_MSR_RET_UNSUPPORTED;
-               if (!msr->host_initiated)
-                       return 1;
-               svm->vmcb->save.br_to = data;
-               vmcb_mark_dirty(svm->vmcb, VMCB_LBR);
-               break;
        case MSR_IA32_LASTINTFROMIP:
-               if (!lbrv)
-                       return KVM_MSR_RET_UNSUPPORTED;
-               if (!msr->host_initiated)
-                       return 1;
-               svm->vmcb->save.last_excp_from = data;
-               vmcb_mark_dirty(svm->vmcb, VMCB_LBR);
-               break;
        case MSR_IA32_LASTINTTOIP:
                if (!lbrv)
                        return KVM_MSR_RET_UNSUPPORTED;
                if (!msr->host_initiated)
                        return 1;
-               svm->vmcb->save.last_excp_to = data;
+               *svm_vmcb_lbr(svm, ecx) = data;
                vmcb_mark_dirty(svm->vmcb, VMCB_LBR);
                break;
        case MSR_VM_HSAVE_PA:

