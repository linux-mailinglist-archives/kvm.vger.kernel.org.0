Return-Path: <kvm+bounces-65916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C1E04CBA253
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 02:07:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E5B60300A6E5
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 01:07:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37BAB23E358;
	Sat, 13 Dec 2025 01:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RdLbmk8S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01DD81F3B85
	for <kvm@vger.kernel.org>; Sat, 13 Dec 2025 01:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765588030; cv=none; b=RM4P8R57z3GiW3zSekm4DDNNu1o6oAECS+PZQdwME8TVB4xg0XR2cYUrqeD/bJvYg+PWQL74bcJVFskgkPO8rFknNp7WwBcZteBc2jTeNyMyKb+aj8l8QWbI4rCWGrFr6zKfluzZYZq1lR4HJzXkpmSiWGo1uSbDEZxDqx4uXtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765588030; c=relaxed/simple;
	bh=kmXLobmCXS3R8kh3ZgeIP8Mu5I1AXodDia4mNYvs8wE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KyZBoYAlHBVOo56CTLhsyrYeHR6O8bMktaIyiwGuvNUcfcm6nh7Wx1XR7iRVk0nlm6y89yi4wQ0ZJ8MA/G6yMCLLbRnWv2EPfaRVy3atPA9xAEdtTrCNleiOb7GMETLp5yT2rdj6qSqV3/P1I+hHj4/TWishGPaT96OFW3E5njM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RdLbmk8S; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-299ddb0269eso22378125ad.0
        for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 17:07:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765588028; x=1766192828; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9Hwyd1rimjLYvRaRvg8sNpXmW9eOFzclIP8X3X+ApI4=;
        b=RdLbmk8SSxGLeaNBqn4s+OqC3O1/jHeJu6suMl3zVRt8zJtduKUDQa+CqlNYIw38Iz
         ppiMD1FpTSXaP4E0OM8uQadbU+IKlkHQ/gauKm1GC1Zcvq65EUqSqTwE+xS5ins7DVX/
         DhYMHb1PxVao2VCn31nVsCTUaf8HQZ5FTScXQfV3k1UrLxeQ8t2x2d9W6uOZ6dKFh+EL
         5f1uNjXrs0pgZXRs/kel8G4e/sbHdPbz6zVhqLlby1gQU4a2R7g1R4kYms9dXQgRUV8E
         9MShJQptl2dsENtCcHpQnFpIpkuIUXA1MW3XuScoQMVc17RE6QfokNV/WHsgd+6MuBRo
         2Mcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765588028; x=1766192828;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9Hwyd1rimjLYvRaRvg8sNpXmW9eOFzclIP8X3X+ApI4=;
        b=EXpJWFagrX66IZCIhlwUA4SeAZevQW71dPa1Ul/lA5fryrbbYvQxlQW3XPTIcMfC29
         KRn6Ut72nzAUwuic9BaOY57Qfho0R7g7Oo34JQ44X5nXX+ITR4zSq7QPBNNqtuLlvobx
         raFa71NtpCQc/s5vUWWGW2KgWthfT0JrNB/OnIUN0xANcgBe4QsGorCMCgMuq1EgPpH3
         Ao2ILTH3giZFqNt1//H4NaP7RX5hMVxll6H6brftzG4lnYOm2Sm/vnN5NulyKsgN0t+i
         7cWlQc6DzblMlj8LeCrZpQT82StOCi/n5xPfzkPEmJib3agPgsKNW3mPD+fxre8mCK3m
         UP0w==
X-Forwarded-Encrypted: i=1; AJvYcCUM9cuv9ALMjKKC3Xbp93kY5FAxvv81ZidlnqmGcLXrMLyX+tVyt5FrW+0XQ73ckkEOY/0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwAUgV/4tRPG+QFTrxQVST7WsPJBChypSVoENUMNZLo9zUPIYBy
	b0gfgH8RV7ctuGN5LgzI1kFXgXIEbnrBfGbihg3jq2zJnK9oGtjsIrFrYh4LJNsugmxj7neqsy3
	v40OFhg==
X-Google-Smtp-Source: AGHT+IHCiEhmID2LaoVd+RXtq+vAyKTjDZ3vK41d/P6PUu3il4TQ94p4+XlM4I+BZqfDZdpsO3eNObnjorI=
X-Received: from plcj20.prod.google.com ([2002:a17:902:f254:b0:2a0:81d1:64f4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1a68:b0:274:3db8:e755
 with SMTP id d9443c01a7336-29f2404b18emr31791315ad.30.1765588028118; Fri, 12
 Dec 2025 17:07:08 -0800 (PST)
Date: Fri, 12 Dec 2025 17:07:06 -0800
In-Reply-To: <sjxsi4udjj6acl5sm6u7vqxrplo5oshwgaoor2wmm3iza5h5fj@cbnzxcmwliwy>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251110222922.613224-1-yosry.ahmed@linux.dev>
 <20251110222922.613224-5-yosry.ahmed@linux.dev> <aThN-xUbQeFSy_F7@google.com>
 <nyuyxccvnhscbo7qtlbsfl2fgxwood24nn4bvskhfqghgli3jo@xsv4zbdkolij>
 <aThp19OAXDoZlk3k@google.com> <fg5ipm56ejqp7p2j2lo5i5ouktzqggo3663eu4tna74u6paxpg@lque35ixlzje>
 <aThtjYG3OZTtdwUA@google.com> <pit2u5dpjpchsbz3pyujk62smysco5z37i3z3qosdscx6bddqj@i6fjafx5fxlz>
 <aTxftw3XcIrwyTzK@google.com> <sjxsi4udjj6acl5sm6u7vqxrplo5oshwgaoor2wmm3iza5h5fj@cbnzxcmwliwy>
Message-ID: <aTy8OhCEcNjpkg_u@google.com>
Subject: Re: [PATCH v2 04/13] KVM: nSVM: Fix consistency checks for NP_ENABLE
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Dec 12, 2025, Yosry Ahmed wrote:
> On Fri, Dec 12, 2025 at 10:32:23AM -0800, Sean Christopherson wrote:
> > On Tue, Dec 09, 2025, Yosry Ahmed wrote:
> > > Do I keep that as-is, or do you prefer that I also sanitize these fields
> > > when copying to the cache in nested_copy_vmcb_control_to_cache()?
> > 
> > I don't think I follow.  What would the sanitization look like?  Note, I don't
> > think we need to completely sanitize _every_ field.  The key fields are ones
> > where KVM consumes and/or acts on the field.
> 
> Patch 12 currently sanitizes what is copied from VMCB12 to VMCB02 for
> int_vector, int_state, and event_inj in nested_vmcb02_prepare_control():
> 
> @@ -890,9 +893,9 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>  		(svm->nested.ctl.int_ctl & int_ctl_vmcb12_bits) |
>  		(vmcb01->control.int_ctl & int_ctl_vmcb01_bits);
> 
> -	vmcb02->control.int_vector          = svm->nested.ctl.int_vector;
> -	vmcb02->control.int_state           = svm->nested.ctl.int_state;
> -	vmcb02->control.event_inj           = svm->nested.ctl.event_inj;
> +	vmcb02->control.int_vector          = svm->nested.ctl.int_vector & SVM_INT_VECTOR_MASK;
> +	vmcb02->control.int_state           = svm->nested.ctl.int_state & SVM_INTERRUPT_SHADOW_MASK;
> +	vmcb02->control.event_inj           = svm->nested.ctl.event_inj & ~SVM_EVTINJ_RESERVED_BITS;
>  	vmcb02->control.event_inj_err       = svm->nested.ctl.event_inj_err;
> 
> My question was: given this:
> 
> > I want to solidify sanitizing the cache as standard behavior
> 
> Do you prefer that I move this sanitization when copying from L1's
> VMCB12 to the cached VMCB12 in nested_copy_vmcb_control_to_cache()?

Hmm, good question.  Probably?  If the main motivation for sanitizing is to
guard against effectively exposing new features unintentionally via vmcs12, then
it seems like the safest option is to ensure the "bad" bits are _never_ set in
KVM-controlled state.

> I initially made it part of nested_vmcb02_prepare_control() as it
> already filters what to pick from the VMCB12 for some other related
> fields like int_ctl based on what features are exposed to the guest.

