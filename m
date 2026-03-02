Return-Path: <kvm+bounces-72431-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iE7UHcUTpml2KAAAu9opvQ
	(envelope-from <kvm+bounces-72431-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 23:48:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 369BB1E5E82
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 23:48:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A085330387C0
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 22:48:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 541802DECB2;
	Mon,  2 Mar 2026 22:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H4fbPVni"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B58282F19
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 22:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772491704; cv=none; b=bHbtvHipLLujz8NTShoseWUuqg2aXeBDvXmqUDn5TRGwVU6fKSK9Nqzyq/S7fZsIv7M+Yf7UW/v8pIGSjE2GKYgOyYmlANXQ+4SgA0QI8AUjL/eOQZTjkDEDprARE4hoavh23LPbFR3MnBN/93NU8Sg4s/vl7wmRaTsksmTqKEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772491704; c=relaxed/simple;
	bh=0UkKBP3tbA5m+vfGf0CgmiUvMch83YvZUflHAoNHaDs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nL816KSdJDPguYquFzy7Qut8676WwrsAcQtqrFUOZBum50Zl7O0nECWCShGd0p/X9vdRSJxMNdaL40Yhw8pENoi1gKT5uuvowdq5Se3pc6Ald/eSDPmTl5fMyGQuRqVmA9GyzpDbeQtYl36NGHCffOppKbtlwzPD0gwpg3w9Jqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H4fbPVni; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3595485abbbso3645509a91.2
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 14:48:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772491703; x=1773096503; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tXdycAUhqH01yNE4P3PLW9cPG6IWEHVkJ1VuHv/+FFM=;
        b=H4fbPVniIcjA2Zj/6gYS85yuAR5LGtkhq88NVF73+9KJ1ojRveFFdWKaDfxH1aHCgc
         Vq/+Lu7KhsyVaabq2v/KjDHlPQLNm0k6NB3BRNCNcoVYSbHwENXenso/e9r8i6VdJHRL
         44bQcFhw/cCthvShRSOAzPsTJRDAP1tE6KxgS348dRUsdGEPUf7CkNk5sB9TX3QQ9L6p
         x1QDcf4FvsispuQkps3wQKPvb6UNVFJO5Kcb8Xr5yZjlERJDe/LdD64jYraMYT2hR/k+
         2xgBbD47AcFtYxGQuWMLp2DRVWSsu2A1DnOd8TIKOGjT2CeIwVF2tH4QUHm/hlXhPB7j
         9XPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772491703; x=1773096503;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tXdycAUhqH01yNE4P3PLW9cPG6IWEHVkJ1VuHv/+FFM=;
        b=JG10WpY+FpNaM6z4iEwAqTEW//4uA8ecXZBIhJyQrjnj52dDfWVSxz0UEozdjgRKaZ
         utJ5v4sb4ehrbw7sz3NAhaGpPNKMxVxydMqwVkuYsEUnH2FbMlVss1fa4cGXNKNbXdXa
         Pbwi2Bb0cC8efsYASLvIFPt7HSmCMpBdRwE4JpuMGm2I4ZkI4j87vEbMV0lU1MEx8qQH
         Dgx49QOd31jZleFjZvGqOWiUHJTh03TJmdjPdunbKhYAGviCZKirdNV0VmY5WBeA5eyx
         9hTkIWRxq5IFuqKZOjPCYZ/ZWWy+PtV5ZDX5+Xp1HHDF/moMLQOE2GjHHTb64UKj3sRB
         hTXg==
X-Forwarded-Encrypted: i=1; AJvYcCXKFVZIZobaOBcLG2jPjkoEMTei1gimq22dXIoYhEfB3KInRvIfQ04K2O7o4Wjm+HAiJHk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyugn8XQblgPaOpMnO4rSYDJSSBuPjLX584ty6PndqzFPCLsaY+
	PHhMMWMc7QfMR9VBX9QU2jYkvv7NDyXRZJ+ISzDlBXin+HDV3C08ob6WN9AgvtF2a6zDW6ZcobQ
	jtZVL+g==
X-Received: from pjao9.prod.google.com ([2002:a17:90a:1689:b0:359:877f:98db])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:588c:b0:34e:630c:616c
 with SMTP id 98e67ed59e1d1-35965ce42fbmr10435047a91.31.1772491702576; Mon, 02
 Mar 2026 14:48:22 -0800 (PST)
Date: Mon, 2 Mar 2026 14:48:21 -0800
In-Reply-To: <CAO9r8zPvQ1+_HGNuRZJuOTQ_YJHgMB=52-68rHFXKF8mWy6CNw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260209195142.2554532-1-yosry.ahmed@linux.dev>
 <20260209195142.2554532-2-yosry.ahmed@linux.dev> <txfn2izdpaavep6yrcujlxkqrqf2gwk2ccb6dplwcfnsstdnie@lgx74e27nus7>
 <aaCO62eQiZX5pvSk@google.com> <CAO9r8zOcBbgtNzy6FizPe8Xm8W=jg3CR8pmdByfszfEM3rqzsA@mail.gmail.com>
 <aaI51_1_bR4zRTXY@google.com> <CAO9r8zPvQ1+_HGNuRZJuOTQ_YJHgMB=52-68rHFXKF8mWy6CNw@mail.gmail.com>
Message-ID: <aaYTtTBFmlzfb7tX@google.com>
Subject: Re: [PATCH v2 1/2] KVM: SVM: Triple fault L1 on unintercepted
 EFER.SVME clear by L2
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 369BB1E5E82
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
	TAGGED_FROM(0.00)[bounces-72431-lists,kvm=lfdr.de];
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
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Fri, Feb 27, 2026, Yosry Ahmed wrote:
> > > What if we key off vcpu->wants_to_run?
> >
> > That crossed my mind too.
> >
> > > It's less protection against false positives from things like
> > > kvm_vcpu_reset() if it didn't leave nested before clearing EFER, but
> > > more protection against the #VMEXIT case you mentioned. Also should be
> > > much lower on the fugliness scale imo.
> >
> > Yeah, I had pretty much the exact same thought process and assessment.  I suggested
> > the WRMSR approach because I'm not sure how I feel about using wants_to_run for
> > functional behavior.  But after realizing that hooking WRMSR won't handle RSM,
> > I'm solidly against my WRMSR idea.
> >
> > Honestly, I'm leaning slightly towards dropping this patch entirely since it's
> > not a bug fix.  But I'm definitely not completely against it either.  So what if
> > we throw it in, but plan on reverting if there are any more problems (that aren't
> > obviously due to goofs elsewhere in KVM).
> 
> I am okay with that.
> 
> >
> > Is this what you were thinking?
> 
> Yeah, exactly.

Nice.  No need for a v3, I'll fixup when applying (it might be a while before
this gets any "thanks", as I want to land it behind all of the stable@ fixes).

