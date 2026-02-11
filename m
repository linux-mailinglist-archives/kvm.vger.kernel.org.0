Return-Path: <kvm+bounces-70846-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KBT/Ch+GjGmfqAAAu9opvQ
	(envelope-from <kvm+bounces-70846-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 14:37:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C20F5124D3E
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 14:37:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 91D983026C1D
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 13:36:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D217823BCE3;
	Wed, 11 Feb 2026 13:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K0znE1K7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2024427E7DA
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 13:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770817007; cv=none; b=IlX6SGyJ6sNfQfpXaynjZlegjoVuDinw+sKFQhfgFt65LShqQDMPiBwpbxKT9bgfkS2uzAS08qUDIWvqbdZjSmO7FxaEo6izPl9gUKP723oK0MM/Ukk2H6QNELm7o7LmFHQnc6pqMzCalfkf2gjy43VOmOXZvK+JzG5pTGHn2Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770817007; c=relaxed/simple;
	bh=Ah5LbfpncANcEq/zVhooYt0wsrNtKBkvnVSsoRm6y4o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tFxygbcs8nM5InpuJQZTvFinQWCQVukZLyU8ol7Kxd08M7fvH2GGrzP8XNVL5r+57wgMrz+UQy33FfEK+uQ32rS8rE2CKf21sa5KhcXl3LmfiVlsYvGEi68p6hCKnhLtx25PeWXY5N6/ka1F4k+YNOBJ+VInrg8ovbKVI2qcOyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K0znE1K7; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2aae0d40a47so117144195ad.2
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 05:36:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770817005; x=1771421805; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=T07RIz9SdZ2hZEJW4G1VJQ8NJdlmo3HHIX+EMR3i764=;
        b=K0znE1K7E6L2vHUbsSnr5ra0pNCfmKhObTUKsQB43YZMwj+bjIc5btO8xQv+U1zS9j
         lbxyUrl6mXi7nlx7O1J2XNnsAcXfrFzehY//NRm0D+exWngKzppVaOBOFWfFiE/NazqH
         /GCJ87iv2o0dmMkFWhsnsHOZrsSsU8uVUu4iUvezve22oqqsY4Wulr4TvE+QCbkJ0uOp
         nfSfKVit5brgHSW8QorIXSEsO0u7QRcWtbG/rp30iY1bpx5kAY9WX3xYchJ44NklyOmD
         OtT7+0ZRkYJ/ZTiR0ngf8oykS1WhcRsU+w3A9n1dY9l/eP9p5Ocx8zGiR/88j09tk6A2
         zqVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770817005; x=1771421805;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T07RIz9SdZ2hZEJW4G1VJQ8NJdlmo3HHIX+EMR3i764=;
        b=bXKHl61l9BRMlMQc2qco8uX5yXseuFcPLJ6aEn34CsaVQ5hGm8vy0t05N8AsWLjJVk
         IW43WqdFrnx2xAcGM0q3aHoKZvsD7b64aQGfM9o2qoGNWYsvQsvCO3UPvZ2L+M398J8B
         dQ9EXqX5e/wsa8y+I6Uhq6JFTfqcPLPqtmNjniTpJntwAQgaf1jt3lqt3cGjOgOHfz+I
         4+wWzDuo1X1Pzwqs7gZJKoxf5L1WJdYzOavMzfsavX3Ed5rBiRvRBfUl8zJmc+SFhwBn
         s8dnS/i10WzNs3xBWRjrRfhaJ9ahz/bDj8urvDvr2fuUA+RcGQjRJZO5FNxlYhwLkIjt
         1C8w==
X-Forwarded-Encrypted: i=1; AJvYcCXvcf9RdkoKsNixxxtC77451LvSDsNCSJYdVdVN3RlJVn5ykRxbDPUvUKDWaaFm9gUBClQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhOYsiFBT6vzDfPU+pWjoJzrZZmHLEob21R9XNuvGbIVJb5TX7
	xMCk2huXOjicmTIenxablJis/36SL7dVNYXryRURtAezTQKTzuD5jty5i6XDN/RFBkgUWaVXM0z
	KZ58otg==
X-Received: from plbcp16.prod.google.com ([2002:a17:902:e790:b0:29f:68b:3550])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:ac6:b0:2a2:ecb6:55ac
 with SMTP id d9443c01a7336-2ab275fa5d0mr28639535ad.7.1770817005314; Wed, 11
 Feb 2026 05:36:45 -0800 (PST)
Date: Wed, 11 Feb 2026 05:36:42 -0800
In-Reply-To: <2af5e3a8-f520-40fd-96a5-28555c3e4a5e@citrix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260211102928.100944-1-ubizjak@gmail.com> <2af5e3a8-f520-40fd-96a5-28555c3e4a5e@citrix.com>
Message-ID: <aYyF6sf6IQs47Vxu@google.com>
Subject: Re: [PATCH 1/2] KVM: VMX: Drop obsolete branch hint prefixes from
 inline asm
From: Sean Christopherson <seanjc@google.com>
To: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: ubizjak@gmail.com, bp@alien8.de, dave.hansen@linux.intel.com, 
	hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	mingo@kernel.org, pbonzini@redhat.com, tglx@kernel.org, x86@kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[gmail.com,alien8.de,linux.intel.com,zytor.com,vger.kernel.org,kernel.org,redhat.com];
	TAGGED_FROM(0.00)[bounces-70846-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C20F5124D3E
X-Rspamd-Action: no action

On Wed, Feb 11, 2026, Andrew Cooper wrote:
> > Remove explicit branch hint prefixes (.byte 0x2e / 0x3e) from VMX
> > inline assembly sequences.
> >
> > These prefixes (CS/DS segment overrides used as branch hints on
> > very old x86 CPUs) have been ignored by modern processors for a
> > long time. Keeping them provides no measurable benefit and only
> > enlarges the generated code.
> 
> It's actually worse than this.
> 
> The branch-taken hint has new meaning in Lion Cove cores and later,
> along with a warning saying "performance penalty for misuse".

Well that's just lovely.  Sounds like maybe this should be tagged for stable@?

