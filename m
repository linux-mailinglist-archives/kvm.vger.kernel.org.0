Return-Path: <kvm+bounces-72381-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GMoTBZelpWngCwAAu9opvQ
	(envelope-from <kvm+bounces-72381-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 15:58:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C15FC1DB466
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 15:58:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C22A83051497
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 14:53:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3773E40149D;
	Mon,  2 Mar 2026 14:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Eppqsdpe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC7D3FB050
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 14:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772463215; cv=none; b=NXIeB1LAraYLQHBs59FDY//DC+LBtEsSDGp9JC7yXPoCitGNbYj8F4/pPuukoLEan04M7OivK6SO6DrlfJeHFDl1ZK9vGomRSJLAUlzH6fHAELhKwLd2Zb+KnyJ45hy6qVQ973c834P07RtFUGxjQ5GhdgxDIweppjrw8U69LfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772463215; c=relaxed/simple;
	bh=6ExRMPFgIfFtm73b8MmQlt2f6XqOd4ntkJPefGvIjkk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hhrU5fIYOOf3cMOUPeT/k6QzL3oU3LLYmjhR4KqJLxIHrp1gDcDhY0ISmpN6b2WECr1L2sKSFFSBeHXXWV9B4TcEaVFagPP5o/SaEj5t87yBFvyEx7mxpHWSkxXldNrb1b1nSjQx+LgeLKvrUOH2Qz5P5Gw2x5HwsZvxOrzjTEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Eppqsdpe; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3598733bec0so8976021a91.2
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 06:53:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772463214; x=1773068014; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hp04vGRTMSOv92SowVVT4dSiJozA1zhnX0e0dsa/0Oo=;
        b=EppqsdpemHwPiT97Vjztdbott2L/6s3eyjTL6aM9WGegGV7XzS96XZF8PeMOvJnPGA
         CL9BjjuP/qtbvjfLmRtDI6PJApSBUmSG5HryIf7X8oCTGUR6JUaOcGuI8uZ9vvROs1jO
         6nprj/ZhVCJKQhbRp0b6jzYDsXPwOiD09GPhzTwIcduVmOK0TC1XQN9vC+bPNs0N6YEm
         TnZQ4o5P3Vf+338W23muIm6vL5XyXAh68GSkziq/epXjXocJ7+pjwGoZCbbpoWImvcKw
         z4Cwtk15Pf7nQ/oUSuzLDaiIq51CxLaPJyyrG4CXGAOcHTfQiFI2EzA6tKlxm1oMK3xo
         y2mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772463214; x=1773068014;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Hp04vGRTMSOv92SowVVT4dSiJozA1zhnX0e0dsa/0Oo=;
        b=L2FjxXoj9+wh2Jzh5Ommo0H6PyFwJYoip/bz0ZUDXJ+rSDw7EyIhGhWQ0pd4oPw6Oe
         cYZxIEjKxxop2KkvAS3M26/h4yt5wli0wIhbG7pXcApgG6S5mDLbmJY8ZPYZqzGDV3ij
         xKBNSkcxTGYDSRm0a8vXI8OPwaf9uCIb93735fBUf2jlZffF9f9smUJd3vKdfXVr8IBC
         rMiJDMMkoKc2IsaoHA1xF7Y55NLTZterTiZziX90wLMBaSbMguXcEDEwyMtmMXFWn26P
         C7bUpqBPv6a36iLTvOP+7peN0VG8g/KkPydoNIOtMh1chJCt76tMulU3ohXMDxJeoZ+r
         XuIg==
X-Gm-Message-State: AOJu0Yx55GOMfjZ0knQvTX2BvuRr9qaC1gG3nzWg4Q5ibgoLLSAyxasG
	w1NS4RCNwkT7RCXv+xVng3Iy05aWAbrYJoVTsJnWWxZqEMnxYRn0ocAJShLmRJjoa5jnhRC5EPs
	j6Jk92A==
X-Received: from pjev23.prod.google.com ([2002:a17:90a:e17:b0:359:7984:d6f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4d8d:b0:354:a546:5edd
 with SMTP id 98e67ed59e1d1-35965c49839mr11157040a91.11.1772463213614; Mon, 02
 Mar 2026 06:53:33 -0800 (PST)
Date: Mon, 2 Mar 2026 06:53:30 -0800
In-Reply-To: <CABgObfaV27kPyGH1dDa-f1XaiqP_uM1cCFmSfnrakFD68u0hPg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260207041011.913471-1-seanjc@google.com> <20260207041011.913471-3-seanjc@google.com>
 <CABgObfZeV6D-2cEht1300xNgxYtz=mi6oX4-D8x7exittEe22Q@mail.gmail.com>
 <CABgObfbKh1Tbzv63GfopW3KQhYtfAGgXXBgGn6EiR2kSBgH_jA@mail.gmail.com>
 <aYp86UFynnoBLy3m@google.com> <aaInA0WGEM3fVCNs@google.com> <CABgObfaV27kPyGH1dDa-f1XaiqP_uM1cCFmSfnrakFD68u0hPg@mail.gmail.com>
Message-ID: <aaWkaoEemeI3rYal@google.com>
Subject: Re: [GIT PULL] KVM: Generic changes for 6.20
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C15FC1DB466
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72381-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Sat, Feb 28, 2026, Paolo Bonzini wrote:
> On Sat, Feb 28, 2026 at 12:21=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > Finally got around to prepping a v2, and I realized that vcpu->mutex is=
n't held
> > when kvm_alloc_apic_access_page() is called, and thus isn't (currently)=
 taken
> > outside kvm->slots_arch_lock.
>=20
> It is, via kvm_mmu_new_pgd (kvm_mmu_reload -> kvm_mmu_load ->
> mmu_alloc_shadow_roots -> mmu_first_shadow_root_alloc).  In fact
> commit b10a038e added slots_arch_lock exactly to have something that
> could be taken within the SRCU critical section, and thus within
> vcpu->mutex :)

Oh, right, duh.  I was fixated on kvm_alloc_apic_access_page() and didn't t=
hink
about the "other" side of the lock (i.e. the whole reason the lock exists..=
.).

Oof, and it's also taken via

  kvm_inhibit_apic_access_page()
  |
  -> __x86_set_memory_region()
     |
     -> kvm_set_internal_memslot()
        |
        -> kvm_set_memory_region()
           |
           -> kvm_set_memslot()

So I was right about kvm_alloc_apic_access_page(), and wrong about everythi=
ng
else.  Go me.

> (slots_arch_lock is also taken inside slots_lock, and therefore it
> must be taken inside vcpu->mutex transitively; but more to the point
> it exists specifically to be taken during KVM_RUN).

