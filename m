Return-Path: <kvm+bounces-73099-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aNXMDn8Eq2nDZQEAu9opvQ
	(envelope-from <kvm+bounces-73099-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 17:44:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B297E2254E4
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 17:44:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 88926304C7C2
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 16:42:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92D4A37883C;
	Fri,  6 Mar 2026 16:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mVliGTI5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077EA2BEC27
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 16:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772815326; cv=none; b=qkA8owHf0gJtck/y5OlpicOmidxZqpGxG9gzuE/B/vdIG0IAmQrn1jdpQAWxfuP9oVV+kzfCB5YflSZefzWoNxhZXHxgmld2l9lBPoZzHIgo1h3NG8dEH3sgkGgI/7MSsTu5A1x927bw/y9a+4Ta7kSQZ3VnPvVe4pvuggeeqOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772815326; c=relaxed/simple;
	bh=TADcOpWEvJLAOeAtgeTIyGynHje+264iN18XJs1JvqQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sPcqHP0Udx5aDZwLxUtoFMosHIHeaZqAt7PHRVAPb48BDCPwQK3he/vpUSMcTBI43rGlj2COLdIF2ZsTDwI0X3BtwOe0FpmjjeNxSIDkQFmYRqvuTyYvNtrWcEPMvHkOEV8HwBpD3ojqe87CbeFdlE6rbgjldF4PDS3Qhbuej+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mVliGTI5; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ae4b96c259so64121245ad.1
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 08:42:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772815322; x=1773420122; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rk41VVSwMD1I02bvg41LBcCUW/2xACIjrkOSKPXzHO4=;
        b=mVliGTI5JTgh3CAMVxKs/qq1k/DC8HxRd4OcT1gfk04ZLhQ/6UgjuwlBCJpjPrh2ox
         wpiE5nL7sFR8phPOer+DPLHLJg7FS9UexGGijHESDjYcQlsfoPJ0i9OZ2xOA2olxli7s
         Eos2aTFCE8SSkYo0yfCYB/geSIYZjGp+ae9YQnScYVWpj8bsJkIOfp7ezEZue+hX+Wg+
         EGA6TjgS0OdAQ6Z8WedkqMOKrsi/86LuCM1hk55qEeMNhMHaEktu9P11I0Ircp9FLQ1H
         0ybiYE8IEh5/o4LCz5J4b8Pk36Q9g2UDjys0Vsha4A85RIH3InCB0NIO92d/fqJMykHF
         JCHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772815322; x=1773420122;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rk41VVSwMD1I02bvg41LBcCUW/2xACIjrkOSKPXzHO4=;
        b=VLK5PjfBIJ0Dol7NKnA9kZcPxU60e+gHOdtjuhrS63wPUWCYmFkp6D+lN63H1PW2mU
         rL8wyBKtLJohw9s7Nk9zPmlIp/k15ZQxHMLUbYfUGAUKCoai4Nk+Zx/xt2V/HE2rvyds
         lik6ZGFEiAzDzTBkPwMf8Cd20aML5LsputijCFX/T3LqaHFFIk2fFHYgpw/cjQggn3hi
         FLmnUSrgAV76ek5nhE6hytwakf1MuyFbxF/Pddddag7L1mcbzBRGuezDki7VphJDqjMh
         Jv7oOUW+fYJiWDyMx4j55uABf+GkfwYiba2oXOfy9uIQzA2PUOvQZsc/Q/84echIaKPb
         mY+g==
X-Forwarded-Encrypted: i=1; AJvYcCUnd4qYP4ejkd+pU1ZQQGqMmBV5gb0tfjIjKYOQbQGA6fTqBkk9b2jqyNk6MyR07zXGyqg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzD4t965O4BBTxQTV/enlHze8xR2OZFi/HyisdkGifGMqbfkGNY
	8+KsKkrhe7ApLxjGrIFoO3DeT88X0+FisRSlPIcR5X6y6FQm0vGEcFKchW7TYjtBS7NQORdoLkp
	rdanOxQ==
X-Received: from plch14.prod.google.com ([2002:a17:902:f2ce:b0:2ae:3b56:7c6a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:4b2d:b0:2ae:525a:f971
 with SMTP id d9443c01a7336-2ae82a0a890mr26503905ad.23.1772815321672; Fri, 06
 Mar 2026 08:42:01 -0800 (PST)
Date: Fri, 6 Mar 2026 08:42:00 -0800
In-Reply-To: <aactOOfirdVRYfNS@acer-nitro-anv15-41>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260209161527.31978-1-shaikhkamal2012@gmail.com>
 <20260211120944.-eZhmdo7@linutronix.de> <aYyhfvC_2s000P7H@google.com> <aactOOfirdVRYfNS@acer-nitro-anv15-41>
Message-ID: <aasD2OHkQN3kdRba@google.com>
Subject: Re: [PATCH] KVM: mmu_notifier: make mn_invalidate_lock non-sleeping
 for non-blocking invalidations
From: Sean Christopherson <seanjc@google.com>
To: shaikh kamaluddin <shaikhkamal2012@gmail.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: B297E2254E4
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
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73099-lists,kvm=lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.932];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Wed, Mar 04, 2026, shaikh kamaluddin wrote:
> On Wed, Feb 11, 2026 at 07:34:22AM -0800, Sean Christopherson wrote:
> > On Wed, Feb 11, 2026, Sebastian Andrzej Siewior wrote:
> > It's not at all clear to me that switching mmu_lock to a raw lock would be a net
> > positive for PREEMPT_RT.  OOM-killing a KVM guest in a PREEMPT_RT seems like a
> > comically rare scenario.  Whereas contending mmu_lock in normal operation is
> > relatively common (assuming there are even use cases for running VMs with a
> > PREEMPT_RT host kernel).
> > 
> > In fact, the only reason the splat happens is because mmu_notifiers somewhat
> > artificially forces an atomic context via non_block_start() since commit
> > 
> >   ba170f76b69d ("mm, notifier: Catch sleeping/blocking for !blockable")
> > 
> > Given the massive amount of churn in KVM that would be required to fully eliminate
> > the splat, and that it's not at all obvious that it would be a good change overall,
> > at least for now:
> > 
> > NAK
> > 
> > I'm not fundamentally opposed to such a change, but there needs to be a _lot_
> > more analysis and justification beyond "fix CONFIG_DEBUG_ATOMIC_SLEEP=y".
> >
> Hi Sean,
> Thanks for the detailed explanation and for spelling out the border
> issue.
> Understood on both points:
> 	1. The changelog wording was too strong; PREEMPT_RT changes
> 	spin_lock() semantics, and the splat is fundamentally due to
> 	spinlocks becoming sleepable there.
> 	2. Converting only mm_invalidate_lock to raw is insufficient
> 	since KVM can still take the mmu_lock (and other sleeping locks
> 	RT) in invalidate_range_start() when the invalidation hits a
> 	memslot.
> Given the above, it shounds like "convert locks to raw" is not the right
> direction without sinificat rework and justification.
> Would an acceptable direction be to handle the !blockable notifier case
> by deferring the heavyweight invalidation work(anything that take
> mmu_lock/may sleep on RT) to a context that may block(e.g. queued work),
> while keeping start()/end() accounting consisting with memslot changes ?

No, because the _only_ case where the invalidation is non-blockable is when the
kernel is OOM-killing.  Deferring the invalidations when we're OOM is likely to
make the problem *worse*.

That's the crux of my NAK.  We'd be making KVM and kernel behavior worse to "fix"
a largely hypothetical issue (OOM-killing a KVM guest in a RT kernel).

