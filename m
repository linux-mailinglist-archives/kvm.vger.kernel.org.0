Return-Path: <kvm+bounces-72692-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4MwZL5NZqGlxtgAAu9opvQ
	(envelope-from <kvm+bounces-72692-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 17:10:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6154B203DC1
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 17:10:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AAD2F3383DA9
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 15:43:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 242E034CFC8;
	Wed,  4 Mar 2026 15:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gDq38F3r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F840188735
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 15:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772638768; cv=none; b=TVGeiFSKltctuIfE+ppBDr5VuB3yEj/wEDQjPK98qC9eWUyO35I5HOBLcSnhxtL1h/Gct7Ml0MxbWZZH6LpFaeqhJj38+qQH1S638XxjQf2BONcIS5y4HubmyHLQD/p79brlQPeSugny6F6k3MBPl7DRPzkYCsMPVb2aRi6OIFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772638768; c=relaxed/simple;
	bh=AwQySQ6RU/E0+QND+fYEQvAaI0LFcEIbgSecZ8phsbg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OqOjhl+HLC8E1AVDKhPAJwkEJnr5xedk8piIdj2iqied4bA2mUmh9yMkMZ6x/ZyqNmGPeJgCrPLOsT3D9ft8OmsnGhaJmI+Wnoo7KCAf/O3EEGDy9jJ7l7/uQPREcdof3a6PXnWYFQ7WnvLPA9cDr8arV3nuNQnbCEda1Igd7uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gDq38F3r; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3594620fe97so33652534a91.1
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2026 07:39:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772638767; x=1773243567; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4obgg0pL0Jwl8Tcok03QPH04x1vAD8j3dmd1EmRfQ2U=;
        b=gDq38F3rsuckH0rPx7rhpJFYxvQ6WBwP0N6fJCqdVi26RQZxk4I7JoW5g9SceqoUR9
         5iihYF5ntaRW9pamVgpgtiso38tLeDHyYRnGntMqTjWGN35G5Kx3SFRMXmyvUUiu1T7B
         yCYrZCyo1PdH8TpFTcDELiwsuT8IfxB1CgoXxdHSuIDPfHrReqlLG5ipwlL71L48QYaJ
         e4gETHY5c2rbmvkikHZFOmIAAoHLuqVIKJBgHtUWk7oL/z6OhCxHp4rJ62pxOhggnIfU
         iqQIm5xa31TQNRyEjb7iBH4eXrfn363JYDAKXF5d4/gvEQgnq1KZ+h/yBtDrIdEfwIgN
         Cfbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772638767; x=1773243567;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4obgg0pL0Jwl8Tcok03QPH04x1vAD8j3dmd1EmRfQ2U=;
        b=no19qwclyEDUz++w7zJukVm/0LApr6TqdqstO0TO8DZ92rIE8sVP40EpEzys2NBraJ
         cZs52+YInGkXKRK+qcRY7xCwg058DRzEGwIVRBUVR4r4INlgxUkWvEEh6orHmUzBSPWv
         rBXbSKx/g20id1QJm23tSLV8Nk43UkA7o4LBcigTg8DwOGyWCxR14MDLQgt5EfFsRcux
         wLHpIwhJ6fd4m/01RNDI+wDekL/z5dwwgx7y7eJALldWyCWGzboMYF/Jenbgrb+z9lvC
         JkRgwo877Vr3SQ/yKhQwzsKDhNKQ7M8ykY4y/M/wr4zf7BQfpM34QcI/5SHcIDI9CBtb
         ewPg==
X-Forwarded-Encrypted: i=1; AJvYcCWJy/oqNNAiv+8Fpfqk0CaNHRjp+GuUqKn9XLGiWfTKqM4RrKvUdcij1B3YKypcV4O9t1E=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJB+wsm+g3TDGnrpKcs75xkWCUtTcl7m6A9hwKhpvgmoD2vG83
	kDkg/vqphEn8/QRl/JGjI6yu/ulN6LLf79ONHjGT+ts81c9yNf0hTgzamKrxoGCU1pbpEYojnrz
	h9u+Jhg==
X-Received: from pgbcs14.prod.google.com ([2002:a05:6a02:418e:b0:c63:5306:c11d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:a124:b0:366:5d1a:c737
 with SMTP id adf61e73a8af0-3982deccfb6mr2418979637.16.1772638766352; Wed, 04
 Mar 2026 07:39:26 -0800 (PST)
Date: Wed, 4 Mar 2026 07:39:24 -0800
In-Reply-To: <20250806215133.43475-2-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250806215133.43475-1-jthoughton@google.com> <20250806215133.43475-2-jthoughton@google.com>
Message-ID: <aahSLC2-KNA9zC_F@google.com>
Subject: Re: [PATCH 1/2] KVM: Add fault injection for some MMU operations
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Akinobu Mita <akinobu.mita@gmail.com>, 
	David Matlack <dmatlack@google.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 6154B203DC1
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72692-lists,kvm=lfdr.de];
	FREEMAIL_CC(0.00)[redhat.com,gmail.com,google.com,vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Wed, Aug 06, 2025, James Houghton wrote:
> Provide fault injection hooks for three operations:
> 1. For all architectures, retries due to invalidation notifiers.
> 2. For x86, TDP MMU cmpxchg updates for SPTEs.
> 3. For x86, TDP MMU SPTE iteration rescheduling.
> 
> For all of these, fault injection can induce the uncommon cases: (1)
> that an invalidation occurred, (2) a cmpxchg failed, and (3) that the
> MMU lock is contended.

...

> @@ -689,7 +691,8 @@ static inline int __must_check __tdp_mmu_set_spte_atomic(struct kvm *kvm,
>  		 * operates on fresh data, e.g. if it retries
>  		 * tdp_mmu_set_spte_atomic()
>  		 */
> -		if (!try_cmpxchg64(sptep, &iter->old_spte, new_spte))
> +		if (tdp_mmu_cmpxchg_should_fail() ||
> +		    !try_cmpxchg64(sptep, &iter->old_spte, new_spte))

As discovered internally, this can cause the WARN_ON_ONCE() at the end of
kvm_tdp_mmu_zap_possible_nx_huge_page() to fire, because the flow *guarantees*
success.

Thinking about this all a bit more, while I *really* like the idea of triggering
uncommon paths in theory, I'm having strong reservations about enabling this in
upstream, as I'm worried the signal:noise ratio could be abysmal.

For many configurations and setups, mmu_notifier invalidations and MMU lock
contention is actually quite common, i.e. in the aggregate, KVM actually gets
good coverage of those paths.  Giving userspace a way to deliberate induce retry
for those cases doesn't seem like it will add much value, while at the same time
it could lead to a rash of "bugs" due to e.g. syzkaller setting extreme retry
percentages and manufacturing scenarios like stuck tasks that can't happen in
practice.

The CMPXCHG thing definitely has value, but as above even that is error prone to
some degree.

So if we want to take this forward, I think we should limit it to CMPXCHG, figure
out a clean way for callers to prevent failure injection, and set a fairly high
bar for extending failure injection to other areas.  E.g. as was the case with
the CMPXCHG injection, a real KVM bug that is extremely rare in practice, but
relatively easy to trigger with artificial failure.

