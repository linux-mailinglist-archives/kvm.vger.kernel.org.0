Return-Path: <kvm+bounces-72769-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qEANHv3SqGmlxgAAu9opvQ
	(envelope-from <kvm+bounces-72769-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 01:49:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1072620999F
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 01:49:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 89E4930451D0
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 00:48:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6B4C21CA13;
	Thu,  5 Mar 2026 00:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4YgFKjOv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272E71A8F84
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 00:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772671735; cv=none; b=j6Ao9QTOl8hJP4ryb1FbTKQfxl5admreDUm8dM9DP5SVzozC0U46U8KfFdCRnKsBI+DoI+WWTlv7mNaxfnPKtTGV2kKNhK0r7GziHQsdOmVyj4vQZhzMm83rg7fF3favWPMZMcPNZuODn+J3LeQ4BqNyOM0N+XHSYPbFpAMl5JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772671735; c=relaxed/simple;
	bh=DOY1pZDTmetMrLvXu23EYLMAO079YK4loEBBox7TB/4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=D5VYd8v8C0CvgDbkcwjaBOcig0QL4oTugdRwhuyJqmpxuYJELnvDMbXUb+c7pZMPg2vDVR09tY9jQ4ZL5GYQNcLh6FkL43aauKyTLgzuFmKrQRZ6HSwxpBmPYb7Xj0ZyWsWxXNEYWkFdxel5fAkAalrLS6r/amJu3EuMB+zYkX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4YgFKjOv; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-35845fcf0f5so8357297a91.0
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2026 16:48:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772671733; x=1773276533; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=B7R3O9rZNqF+n/MiqgWOMRtZOJH/frvyIvRcmsDt4vs=;
        b=4YgFKjOvfSOFe17k8Zaml2gptgyq8jnsYcGlEK3f0wSa+n3jWel7XjniHHfoJWYSfw
         wZAmnIKfccBDmv/RrADQSh+bC/euos9VLsR94sUDuTujLehL2Y0nqmEkpWHL18RIRtWc
         NmiDoMIHZJCOHjs2PER85a+n7/AvO85srDHQZz1eDvpeV1QErEU/5+F2fIRf4Cy82FO0
         xjCJY9fq809ASH8MBpGvy7ycm+09kRUEtYgeujqPJnIOG12jHWXk1Mkxe7VNKCCLcS+Z
         pdeHPJVjHoNs2+TL8m8Ca7siJZWkwps5hyJVB3/fWbL3S+sG1MSH+t2ums4W4P1/oHdw
         dz5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772671733; x=1773276533;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B7R3O9rZNqF+n/MiqgWOMRtZOJH/frvyIvRcmsDt4vs=;
        b=Kmyp2/6a28uvTyTYHeXhLfCwrsjOVB2I4J/vCVnkMTzQ2xYzzZ/3zTq3irQQCwzgJr
         lA5eG0yoP1tM2lEoj/LyNiAesvdnCJN0W5MKrmuNRfUMFKnlrj5YfUYa3lRURjVDuVyL
         yTPdF+VMFAczc2wS4dtUbz1j2Ge9fBYVl+8d/ifa6dD2Ub/6gUCe7lCpUaVE9KR0MuHt
         0r4pImZ4KTu2RnqGr3xqnYKN9Kdvwp1+satF1UUgfGU98HnkDwBtYUToWto/1veDRXFE
         8/RaLbjKj1WmK2XmVtzIhpb/Dq99cIzlFIvFpTrgb9g436JFCSSuuA9MmTzcj/VtcGUy
         +hbQ==
X-Forwarded-Encrypted: i=1; AJvYcCVXhNT/nX9e34xyOUhtBxXCHIZRLpQ1GNgknWrOHylgQDEfETs6dE8uR8U0yGQvpmvHEXI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxN9LKi1Mor39QF0lqnDXp2vsvwJmRYM0S8APKvnF9GlOGcOMv2
	Wl1lVId8k3dvrfCUt3/soTjVu/+S6YZrD+JEg/Ts1mtO93WvTcA8IgXqZthCk2dYqyrw6si0QZZ
	w+BtiXA==
X-Received: from pjbin21.prod.google.com ([2002:a17:90b:4395:b0:359:8a48:8814])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:48d1:b0:34a:be93:72ee
 with SMTP id 98e67ed59e1d1-359b1bd000dmr444707a91.8.1772671733379; Wed, 04
 Mar 2026 16:48:53 -0800 (PST)
Date: Wed, 4 Mar 2026 16:48:52 -0800
In-Reply-To: <aRQf1sQZ9Z3CTB8i@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251026201911.505204-1-xin@zytor.com> <20251026201911.505204-9-xin@zytor.com>
 <aRQf1sQZ9Z3CTB8i@intel.com>
Message-ID: <aajS9HFx5HabmCTq@google.com>
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
X-Rspamd-Queue-Id: 1072620999F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72769-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[18];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Wed, Nov 12, 2025, Chao Gao wrote:
> On Sun, Oct 26, 2025 at 01:18:56PM -0700, Xin Li (Intel) wrote:
> >From: Xin Li <xin3.li@intel.com>
> >
> >On a userspace MSR filter change, set FRED MSR intercepts.
> >
> >The eight FRED MSRs, MSR_IA32_FRED_RSP[123], MSR_IA32_FRED_STKLVLS,
> >MSR_IA32_FRED_SSP[123] and MSR_IA32_FRED_CONFIG, are all safe to
> >passthrough, because each has a corresponding host and guest field
> >in VMCS.
> 
> Sean prefers to pass through MSRs only when there is a reason to do that rather
> than just because it is free. My thinking is that RSPs and SSPs are per-task
> and are context-switched frequently, so we need to pass through them. But I am
> not sure if there is a reason for STKLVLS and CONFIG.

There are VMCS fields, at which point intercepting and emulating is probably
more work than just letting the guest access directly. :-/

Ah, and there needs to be VMCS fields because presumably everything needs to be
switch atomically, e.g. an NMI that arrives shortly after VM-Exit presumbably
consumes STKLVLS and CONFIG.

