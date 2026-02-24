Return-Path: <kvm+bounces-71633-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WPjAB4TjnWnpSQQAu9opvQ
	(envelope-from <kvm+bounces-71633-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 18:44:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8088818AAF3
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 18:44:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3954F30D0246
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 17:43:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF0F03AA1A9;
	Tue, 24 Feb 2026 17:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xylueOVz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376623A9DB5
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 17:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771955014; cv=none; b=LgNPObn11kKfWr4VhgY9u6nATN/paPag8wd2gkbvhCpaogVyCYBbeBggvhBP4Dut7vqqV26lKl3ws/XpTXJoff0JLPZKsJ/Q+UbZKCRbX/pGnkFUqTM0W5Y4dpgtGyDFcVr1t70Sr7oVQl0xNrNeLInqCmf0i13dSEMkTySvv9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771955014; c=relaxed/simple;
	bh=CzXhE6NIlz4EonhiaZ5X2vjm+voehRbxgQYJDKg7pfY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F5EtVpgE1hgb0oA59ryeUDN+kKajp5SAFqGEFIjN02eurYenLsyrNxVMOqdQ1S6MOfIcBPmGx+Gy0sTPJbYOogGOc3HTb32dxanMkso9Gd0DtYZ9zwzH02xdoyRGvKgX04XiJWiYX1uBcuxWGedFF8OmybuwJtbaIERcwtD3760=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xylueOVz; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3562370038dso5148571a91.3
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 09:43:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771955012; x=1772559812; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7EJ6jDZkcc54+WfMFP83ReJ+Vv39B7Cq+a8KWyoH30M=;
        b=xylueOVzD3NHwth8hX+kofCnh4QGm1w6LBpFpTOTc0f2m8Mh77Kct3OBXyWoj2zN0X
         A4d6d8HzHwoFT/4gxQ3Ky1HBcjaBgXwwzTMzuX+mrj9ZFRFBTC0JMKH3ZKj86pF35ssP
         fWoTzA7qkTwTf3QsxNAjiVKjwfgVq4ijw2bXdtupgzUq0oabjhgJDG5xlPXSrEqfvHBQ
         S4KwfzQ0mUvAzpxIeqz48Df9pugb36b47rhhaWjLTR769eDpUuMTTRcgGIfg0viyavlp
         +r8iRa0plO7YpdcAHbsmm1GAb9+Ia4drPeZAlUSZ1H9L4+3Y4GKuIL9CpILxY6HkZh0x
         b5LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771955012; x=1772559812;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7EJ6jDZkcc54+WfMFP83ReJ+Vv39B7Cq+a8KWyoH30M=;
        b=Y/VoVsB1Yw1OmChX1nC9IQYd5aSpmGw16/bGv1Y25UQA+5DUo3s75Ki9PAvHYDXlRA
         GHkoK4NuSMov1hOw59Ytr5gelg7TdawNUM7jaJIlWJbkb9ZW32hsB8ajJVTWujpSRZWF
         HlZm2+1EUiZB1/TR1W2LCQTfeqAo3RXmuBLYehvLVvkDCGPNwyoYTR6I9EI3g8AsXXO3
         tZyVmH1w+RYOqgKE7nAPwzW1GJnefjSDGqGea2N9kdEqvq3Q2UezFDyix5cmurMcKhIo
         XW2Yvi2ty8scENXO7iaEMDEHn66rX3GuGG4A+2H1mJ8CVRuwa0xllprp0j5m6UmEZPtN
         HFPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXgrFf0NzYC+xApPi7TGyzw//PGfTq+iX168Uap8C/15P2BwZ75zjFthCbv2i1/qpJxYok=@vger.kernel.org
X-Gm-Message-State: AOJu0YxAanSMLrwcrNty2F7dMNLl5iCXIXITDysLZ9Q2Jte0MudFTrey
	c70kHE/MRTYPCIp2sRwpmmAW6BbM/V3vdBTMu9uXnLN9fmgmVZgOwVwya6QiR0WoqYoZXFk4MOX
	x6pMlmQ==
X-Received: from pjqs3.prod.google.com ([2002:a17:90a:ad83:b0:358:eb53:2d1a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b10:b0:356:2db3:1206
 with SMTP id 98e67ed59e1d1-358ae80a6a3mr10275503a91.13.1771955012397; Tue, 24
 Feb 2026 09:43:32 -0800 (PST)
Date: Tue, 24 Feb 2026 09:43:31 -0800
In-Reply-To: <20260224005500.1471972-6-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260224005500.1471972-1-jmattson@google.com> <20260224005500.1471972-6-jmattson@google.com>
Message-ID: <aZ3jQ1prL4dgG0-H@google.com>
Subject: Re: [PATCH v5 05/10] KVM: x86: nSVM: Redirect IA32_PAT accesses to
 either hPAT or gPAT
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71633-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8088818AAF3
X-Rspamd-Action: no action

On Mon, Feb 23, 2026, Jim Mattson wrote:
> +static void svm_set_pat(struct kvm_vcpu *vcpu, bool from_host, u64 data)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
> +	if (svm_pat_accesses_gpat(vcpu, from_host)) {
> +		vmcb_set_gpat(svm->vmcb, data);
> +	} else {
> +		svm->vcpu.arch.pat = data;
> +		if (npt_enabled) {
> +			vmcb_set_gpat(svm->vmcb01.ptr, data);
> +			if (is_guest_mode(&svm->vcpu) &&
> +			    !nested_npt_enabled(svm))
> +				vmcb_set_gpat(svm->vmcb, data);
> +		}
> +	}

Overall, this LGTM.  For this particular code, any objection to using early
returns to reduce indentation?  The else branch above is a bit gnarly, especially
when legacy_gpat_semantics comes along.

I.e. end up with this

  static void svm_set_pat(struct kvm_vcpu *vcpu, bool from_host, u64 data)
  {
	struct vcpu_svm *svm = to_svm(vcpu);

	if (svm_pat_accesses_gpat(vcpu, from_host)) {
		vmcb_set_gpat(svm->vmcb, data);
		return;
	}

	svm->vcpu.arch.pat = data;

	if (!npt_enabled)
		return;

	vmcb_set_gpat(svm->vmcb01.ptr, data);
	if (is_guest_mode(&svm->vcpu) &&
	    (svm->nested.legacy_gpat_semantics || !nested_npt_enabled(svm)))
		vmcb_set_gpat(svm->vmcb, data);
  }

I can fixup when applying (unless you and/or Yosry object).

