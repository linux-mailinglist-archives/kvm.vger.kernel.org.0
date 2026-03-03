Return-Path: <kvm+bounces-72552-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MFIUD6wbp2m+dgAAu9opvQ
	(envelope-from <kvm+bounces-72552-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 18:34:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D34861F4AE0
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 18:34:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3977F3134DBC
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 17:32:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF0EE3E9F99;
	Tue,  3 Mar 2026 17:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MtUxZWMT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CB03A5E8B
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 17:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772559138; cv=none; b=JAI9SW6iKaY+0kVqjyUJJlP5Elr8D4Uv5A1m6Behp+ndFqdLbde8MeCcyBkWdGp/NamMNYySmj9scsC4tlX/q2zE3EL2e8HgyaVS/JFmxu7FmPePqeASM81iNAtqN06BxMPpruRfsVtoY0T+KHyDXB3cWazxTMjjEXS2LY9gWRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772559138; c=relaxed/simple;
	bh=yMGrdbIwWE2+eYJPYfoBl93xI3liydh55WwC6qSYchA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BZjQNu1VbGu4tY9Od6F51B1/tOlbEa4C5UCtuiNgfA43WScfmGZ22PtDrMgXq1e8a8R5Y4PkoeOcghtiUtZEyrslellnL35zR7xnmHAICHtZ/EoD5Gb9RsP9+B0TjkpUS66I5ocKtPxWMrSvX8R4e9iSQFUnWbnMyzK5+FrF31A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MtUxZWMT; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c70e8e7fe55so3682141a12.2
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 09:32:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772559135; x=1773163935; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aLBg7IZ3pN30EJup7ssRX35zrhsbqgqINeRfna2/jXs=;
        b=MtUxZWMThBb3FdAXJU+m4EOcD1Wxazl8uX/M4zjkiue16Hhrg9SykoWyuP2mQrr0VF
         vtswoKY2mZIBXYdXrVUCNoLSQ/HTj3tcbAuWADnzhfbOppMKiGDQFyOpTfrYyk5HHWYC
         eOulc89cVKweLpPw6AQVmUKkdVsnLfsJx7IDVtpvyYPiowIGN8rlSewnfzuSsR+lPM49
         5l4Hpp+76z0VH/piKzYyqq1Yuyhv7YhjYxxSGNIopXJ7ZflnqWk2KRaUqpputP1DJG5Q
         jhlkJm0qw9hVh/7+8XLRg/jE2NcpewRmLCQx/LHuKE6qBxnE79rGYkeRUkmGsjm23LUS
         O0LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772559135; x=1773163935;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aLBg7IZ3pN30EJup7ssRX35zrhsbqgqINeRfna2/jXs=;
        b=bghltN9MLPiwqwzcvSUzUttVOH5ONwWVI3twR97Cb8NgmHPo+PfxdSKE8217hHZGJ3
         4NLGpW/2knMVd97u60ZJxd8MXluqjSfy8hdZwNkgSX2CRPvo2cfZmN59r4/X6WMDsenP
         wrUrylRItvRJ5GfAWm2S1RxyBLxS1e1BjPp6crT4RWRpf0RvLeCT0o0RHa5z+06KRuUz
         ZUFpF7amT8UbFHSelwKBJqTW5SWuDzJ9R4x88KairMhZ1lC7O/MOP4iQq3PnkRsSqWzP
         Fnb9CT/vyfTa3HQiliukjxQCY71qSDDPrOCkVdQMqoOAQ6vg2goRHySiWYlwXXfvuusV
         FUZg==
X-Forwarded-Encrypted: i=1; AJvYcCUrpHJnz1/azTyxGXBefKS4ZrOWtDnbT2R4C27xilzhSjVdTGRuhhvs7V9xppPv4NyK8/U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx36hkyWhOx8+uU7uj+fYvC4LtAZTqAEtUsIxDZWXQ4ENiK9iAS
	cQUXaqPFCHyWlvtW2NK2zPC2WM180shsqm/bVd6O6GqhRVMnIOmKxSAy10/AzEQbXE7y8hCT6hk
	6Vrd2bQ==
X-Received: from pge15.prod.google.com ([2002:a05:6a02:2d0f:b0:bac:6acd:8182])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:2d42:b0:334:87c2:445
 with SMTP id adf61e73a8af0-395c3b0407fmr15851028637.36.1772559134744; Tue, 03
 Mar 2026 09:32:14 -0800 (PST)
Date: Tue, 3 Mar 2026 09:32:13 -0800
In-Reply-To: <20260224005500.1471972-10-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260224005500.1471972-1-jmattson@google.com> <20260224005500.1471972-10-jmattson@google.com>
Message-ID: <aacbHcUbG5WYgSaQ@google.com>
Subject: Re: [PATCH v5 09/10] KVM: x86: nSVM: Handle restore of legacy nested state
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: D34861F4AE0
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72552-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, Feb 23, 2026, Jim Mattson wrote:
> @@ -2075,9 +2076,15 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  
>  	svm_switch_vmcb(svm, &svm->nested.vmcb02);
>  
> -	if (nested_npt_enabled(svm) &&
> -	    (kvm_state->hdr.svm.flags & KVM_STATE_SVM_VALID_GPAT))
> -		vmcb_set_gpat(svm->vmcb, kvm_state->hdr.svm.gpat);
> +	svm->nested.legacy_gpat_semantics =
> +		nested_npt_enabled(svm) &&
> +		!(kvm_state->hdr.svm.flags & KVM_STATE_SVM_VALID_GPAT);
> +	if (nested_npt_enabled(svm)) {
> +		u64 g_pat = svm->nested.legacy_gpat_semantics ?
> +			    vcpu->arch.pat : kvm_state->hdr.svm.gpat;

This is all a bit gnarly, e.g. the indentation and wrapping, as well as the logic
(not that it's wrong, just a bit hard to follow the chain of events).

Rather than set legacy_gpat_semantics directly, what if we clear it by default,
and then set it %true in the exact path where KVM uses legacy semantics.

	svm->nested.legacy_gpat_semantics = false;
	if (nested_npt_enabled(svm)) {
		if (kvm_state->hdr.svm.flags & KVM_STATE_SVM_VALID_GPAT) {
			vmcb_set_gpat(svm->vmcb, kvm_state->hdr.svm.gpat);
		} else {
			svm->nested.legacy_gpat_semantics = true;
			vmcb_set_gpat(svm->vmcb, vcpu->arch.pat);
		}
	}

As a bonus, if the previous patch is deliberately "bad" and does:

	if (nested_npt_enabled(svm)) {
		if (kvm_state->hdr.svm.flags & KVM_STATE_SVM_VALID_GPAT)
			vmcb_set_gpat(svm->vmcb, kvm_state->hdr.svm.gpat);
	}

then the diff for this snippet shrinks to:

@@ -2025,9 +2026,14 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 
        svm_switch_vmcb(svm, &svm->nested.vmcb02);
 
+       svm->nested.legacy_gpat_semantics = false;
        if (nested_npt_enabled(svm)) {
-               if (kvm_state->hdr.svm.flags & KVM_STATE_SVM_VALID_GPAT)
+               if (kvm_state->hdr.svm.flags & KVM_STATE_SVM_VALID_GPAT) {
                        vmcb_set_gpat(svm->vmcb, kvm_state->hdr.svm.gpat);
+               } else {
+                       svm->nested.legacy_gpat_semantics = true;
+                       vmcb_set_gpat(svm->vmcb, vcpu->arch.pat);
+               }
        }
 
        nested_vmcb02_prepare_control(svm);

> +
> +		vmcb_set_gpat(svm->nested.vmcb02.ptr, g_pat);

I don't like the switch from svm->vmcb to svm->nested.vmcb02.ptr.  For better or
worse, the existing code uses svm->vmcb, so I think it makes sense to use that.
If we want to explicitly use vmcb02, then we should capture svm->nested.vmcb02.ptr
locally as vmcb02 (in a future cleanup patch).


> +	}
>  
>  	nested_vmcb02_prepare_control(svm, svm->vmcb->save.rip, svm->vmcb->save.cs.base);
>  
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 00dba10991a5..ac45702f566e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2727,7 +2727,8 @@ static bool svm_pat_accesses_gpat(struct kvm_vcpu *vcpu, bool from_host)
>  	 * with older kernels.
>  	 */
>  	WARN_ON_ONCE(from_host && vcpu->wants_to_run);
> -	return !from_host && is_guest_mode(vcpu) && nested_npt_enabled(svm);
> +	return !svm->nested.legacy_gpat_semantics && !from_host &&
> +		is_guest_mode(vcpu) && nested_npt_enabled(svm);

Align indentation (it's a shame return wasn't spelled retturn, it would save many
spaces).

