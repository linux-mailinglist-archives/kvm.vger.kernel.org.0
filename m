Return-Path: <kvm+bounces-73090-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AIQHEJf6qmmcZAEAu9opvQ
	(envelope-from <kvm+bounces-73090-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 17:02:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 98C2B224786
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 17:02:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2596E317A946
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 15:54:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C91A53EBF29;
	Fri,  6 Mar 2026 15:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kS9SQa4o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13593B8959
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 15:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772812471; cv=none; b=ZvHMwZG1SATj7DQ0qZ62ku8kbCXmn9SUsul9Oiy3qPkKlM8HxJ2sanfaeVnO7iLTsOxbLM9sImMUy0+Z1FAIcGvNhr1AX7n/QuU5Rrr7Fhsd5iHQyj7wIfvOXJCDKPAGApzFcfZfX86ebvfJEo94mIt9i2YbEadA4NizQpW42DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772812471; c=relaxed/simple;
	bh=DCdYafJ1q85ldEBfRTNqL/Y3XaF2wiN51HteaKHK1yo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uWR4kpJfZgy5iPkX80sqCdG9o5Uv3N2BS6fLqEEQWIWJScxJBuw5l7kjAjAQenQ4uyS3mCsxH5uDtFz5asbK/qqbkJff/s4285niiqJ0AyRoz2Fw1FEbiVKqPejLf7A0jBd0AA5/QJkfeKPnhHzoqAF2awmVujymlfWqDDXDFm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kS9SQa4o; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-8297d2c1e64so1005407b3a.2
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 07:54:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772812469; x=1773417269; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/X89hp+5U+/q1xbg5uksPepQg6bue5vmq9BCayk/Rl4=;
        b=kS9SQa4o10cSJ2+NsKla5FLvy1bxQNCsx70vkV8CEU0wNnbpDNa8912g/x6MVME/TV
         GvL1qHmPaUSnx8FYiHymJJ/di/Mt8wScksgj/mv9IvYrxExH3r/GFgE0MPW9KBDLVCI6
         7KUOFV872krAkndgS1Qf5GkWOF86fEQH9B5q08TEBuNdbb6M8GRKFetJ9fiGohIvHA0g
         h4comjQGPbCuu8s6GtHpFjbjNoeP4QyM+pvCtxA7bBvIoizkxTNz+v7MCbIlt9pfzIJa
         yh0Mt24fw4SX2qkyynKR6gNc0oyETdIIBwybnvyb/Dt2kqVoDfDbmPa5Ga2tB7DkIt9U
         7ejw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772812469; x=1773417269;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/X89hp+5U+/q1xbg5uksPepQg6bue5vmq9BCayk/Rl4=;
        b=HAHMPdlMVC1zQr1c0mjomwSaSHn7K/q8OAuS0IG54NNVGozjW5a/CIANGLrIcclvO3
         o736wDJCN28CpH91igRaHPtJ/0CFQ2K3cFdOi3V/1D2v/35+ywozmyXnGG+EuXdRvBtO
         CupPEEliWEvTIaxbPj11wcCnkTnsoz6xxroQNBW3p9I6lOKUsQK9FZZpsZwYRpJtsiPy
         khIas12vEu64ChbISNa5W6fpcAUJcMnhDOm56uwc8Uy6UVlbAPb7BxO06c+0H+lnRI99
         2GqUi8BG7B+a8AaoC7Mewt7nFMUPWXLkCaPs54pmkXjcCJj9ZI813lvW0onvYtPi+fP2
         6wdg==
X-Forwarded-Encrypted: i=1; AJvYcCXTp7Z3BC6ijSGl6u3JeSy9paKT8ikhfs16raqUc3rEh8x7crmqBi01S+WNIOc6bJs13n8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2IIhnIpSdeBbnnROyTUla99BeupQ3304FerM5yqRSMOYdFaAK
	zvfbtPXm1MzilKvohqxE+IVKIVU65XOUU6Mx/R1tP1+KFT2W+RtVHrjNDhEnz5y58fbehJJQaVb
	InCIMSA==
X-Received: from pfbfa30.prod.google.com ([2002:a05:6a00:2d1e:b0:829:9a65:4170])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1a8c:b0:800:8fdf:1a54
 with SMTP id d2e1a72fcca58-829a2f4a0bbmr2373665b3a.34.1772812469067; Fri, 06
 Mar 2026 07:54:29 -0800 (PST)
Date: Fri, 6 Mar 2026 07:54:27 -0800
In-Reply-To: <aao8SbZMHT302dDS@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251026201911.505204-1-xin@zytor.com> <20251026201911.505204-9-xin@zytor.com>
 <aRQf1sQZ9Z3CTB8i@intel.com> <aajS9HFx5HabmCTq@google.com> <aao8SbZMHT302dDS@intel.com>
Message-ID: <aar4s6pGYOlKQp4Q@google.com>
Subject: Re: [PATCH v9 08/22] KVM: VMX: Set FRED MSR intercepts
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: "Xin Li (Intel)" <xin@zytor.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, luto@kernel.org, 
	peterz@infradead.org, andrew.cooper3@citrix.com, hch@infradead.org, 
	sohil.mehta@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 98C2B224786
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
	TAGGED_FROM(0.00)[bounces-73090-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[18];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.928];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,intel.com:email]
X-Rspamd-Action: no action

On Fri, Mar 06, 2026, Chao Gao wrote:
> On Wed, Mar 04, 2026 at 04:48:52PM -0800, Sean Christopherson wrote:
> >On Wed, Nov 12, 2025, Chao Gao wrote:
> >> On Sun, Oct 26, 2025 at 01:18:56PM -0700, Xin Li (Intel) wrote:
> >> >From: Xin Li <xin3.li@intel.com>
> >> >
> >> >On a userspace MSR filter change, set FRED MSR intercepts.
> >> >
> >> >The eight FRED MSRs, MSR_IA32_FRED_RSP[123], MSR_IA32_FRED_STKLVLS,
> >> >MSR_IA32_FRED_SSP[123] and MSR_IA32_FRED_CONFIG, are all safe to
> >> >passthrough, because each has a corresponding host and guest field
> >> >in VMCS.
> >> 
> >> Sean prefers to pass through MSRs only when there is a reason to do that rather
> >> than just because it is free. My thinking is that RSPs and SSPs are per-task
> >> and are context-switched frequently, so we need to pass through them. But I am
> >> not sure if there is a reason for STKLVLS and CONFIG.
> >
> >There are VMCS fields, at which point intercepting and emulating is probably
> >more work than just letting the guest access directly. :-/
> 
> Just drop the MSR intercepting code and everything should work, right? KVM
> needs to handle userspace writes anyway. so, there is no "more work" to me.

True.  I was thinking KVM would need to marshall the value to/from the hardware
MSR, but that's obviously not necessary :-)  (and also would be comically wrong).

After working through the various implications, I think it makes to adjust the
"rule" to be "if necessary for performance OR it's _completely_ free (minus the
interception toggling)" (and in both cases, obviously disabling interception needs
to be functionally safe/correct too).  Because I think we'll end up with confusing
code if we limit disable interception only for performance reasons.

E.g. I can't imagine MSR_IA32_S_CET will get modified post-boot, so by the
performance-only rule, KVM should always intercept S_CET.  But MSR_IA32_U_CET
can be read/written much more frequency, and so should be passed through.  And
then we'd end up intercept S_CET but not U_CET, which _looks_ wrong.

The FRED MSRs fall into the same boat.  Intercepting only STKLVLS and CONFIG is
likely a-ok from a performance perspective, but once this is all merged and folks
that weren't part of this discussion come along, readers will likely be wondering
why STKLVLS and CONFIG are "missing".

All in all, unless someone has an functional or performance argument against
disabling interception, I think it makes sense to disabling interception for all
FRED MSRs that are context switched by hardware.

