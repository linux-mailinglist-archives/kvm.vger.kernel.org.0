Return-Path: <kvm+bounces-72826-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sAVRIfyiqWl5BQEAu9opvQ
	(envelope-from <kvm+bounces-72826-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 16:36:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DFA1E214A1A
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 16:36:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A830C309AA70
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 15:35:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34A7F3C3C14;
	Thu,  5 Mar 2026 15:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JLZdnS1n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19933C276F
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 15:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772724916; cv=none; b=HzHFI58Z7mEJBnqFgCQbnVGZqsq/HL0/bpz6AHdY3jfS2Vp39q5L885a90LVnvExUhVzXuWdQIpN+cA+iRmxW8sJuqunFC5POLXFxWGhdNA3iGFzLVKOSFllEi0Z+GfGGxymXELB7Ks/wjZbcn1Wsalh8fONsR8M9JSarsdftJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772724916; c=relaxed/simple;
	bh=xPxR7A1KpL6unFCuzXfwTzWyLcM4UNIGR0JOSYbIUDM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hkkw6Ue3bZEf1WIfe7zUJ4R54yIZcQHgWvVhfNAthqViRLtw+pHqk0CR033o8J5D3uq5W9zcvYuDw1OnDZIndiDwRzZPRkUTK+wVHSjoIicWJBDsK44YoDKycELjp1DWhuhcTsK0u8GEabNSq5gBWu4P6b3Qh2bmeAKnpERxObU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JLZdnS1n; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c737b6686ddso1136067a12.3
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 07:35:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772724914; x=1773329714; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Nb1Po5uhA8ajtfdop0hCLXdvKmdr6sjlbz1AVD84as4=;
        b=JLZdnS1nC/l4jr9dJj9Fq1IrWvMm6ttJo6dxGgsE22hy2Zs1qDPCN1ORDIMxbuRrG5
         lESbKZKQ2ntD+dV8xS0UIODaHYsq7EDnAZYzJIthmBj/3AhoPhVv4lpEE6CeJHzssyOp
         dMeXcHNpfIw77lNX9s96/LbaCY3bsvqnMSgihGYxuxrLbjM9etmm1B3Z158psDNtIXNI
         idIaeFtSFkxQV0eS2p35KKgY+z72iVS1kcxiqm+87ACMBi9tDZnjPU/6heQ5JFXOr6Aj
         QpHlD1CcciDvE/+yEmgLPdLK8RSD2eslMkUoNkIqvHIZUv8o3wZA+kU4vzhQPnnoLZRj
         rUeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772724914; x=1773329714;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nb1Po5uhA8ajtfdop0hCLXdvKmdr6sjlbz1AVD84as4=;
        b=DwCS6/rsv2gMgISV3Y6LzHj5QXWWGOrYyrV9penWrlUjtJf7tm1OnoxZLwpVBuKRDy
         p32V5dqoma+2Lha3lqsOwYNbAV2JfFR5wy++WDb2j73mbxVuFxqAQ1oc+E2wEylbu9E4
         XlxpxhWZoEqQvHVs7J3Dpvu0nFCD4kVSVVhpx1KOPdlDySE5n/xlxK9KCclR8vdkGywC
         6UoVBcE7bznK8VxsgYOmgki+bo8mHMpL4ghsdZWrHdf006owS0UwMvnjZo3fKiv9iCnQ
         jf2qdYHVSwGmyG7ue0HuRjevZ5sp+Ck3ldNQcao5xDxc5YIhJaGCjAeEbBoONDBEeV2H
         fK4A==
X-Forwarded-Encrypted: i=1; AJvYcCVawBlvIrd0YMBpMBcAXmzapT8YlcksbXg6Yn1f7TxDoSjBET0Ak3Ix++RQZ8pSBMii4YU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWmjWejaYZaSeS0Z6yQr/5z5VUKnUUfzNl0+4681/Oxz8t4RI1
	9vp8RgzFXEDbm3dDPuxYi5eCkaM+LLbQ497BWXilmmRHhWvyA+wczcem+xMHLQB99g0x027UDYP
	KXLrpMA==
X-Received: from pjbof5.prod.google.com ([2002:a17:90b:39c5:b0:359:86b9:176d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1a91:b0:359:7c55:c160
 with SMTP id 98e67ed59e1d1-359a69da7d6mr5554358a91.13.1772724913982; Thu, 05
 Mar 2026 07:35:13 -0800 (PST)
Date: Thu, 5 Mar 2026 07:35:12 -0800
In-Reply-To: <263F364B-D516-40B3-B065-A5369BFB1A7F@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251026201911.505204-1-xin@zytor.com> <20251026201911.505204-16-xin@zytor.com>
 <aR1xNLrhqEWu+rmE@intel.com> <aajVJlU2Zg4Djqqz@google.com> <263F364B-D516-40B3-B065-A5369BFB1A7F@zytor.com>
Message-ID: <aamisPkG1JZ2UDdQ@google.com>
Subject: Re: [PATCH v9 15/22] KVM: x86: Mark CR4.FRED as not reserved
From: Sean Christopherson <seanjc@google.com>
To: Xin Li <xin@zytor.com>
Cc: Chao Gao <chao.gao@intel.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, luto@kernel.org, 
	peterz@infradead.org, andrew.cooper3@citrix.com, hch@infradead.org, 
	sohil.mehta@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: DFA1E214A1A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72826-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[18];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
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

On Wed, Mar 04, 2026, Xin Li wrote:
> 
> >> 2. mk_cr_64() drops the high 32 bits of the new CR4 value. So, CR4.FRED is always
> >>   dropped. This may need an update.
> > 
> > Ugh, I didn't realize FRED broke into bits 63:32.  Yeah, that needs to be updated,
> > and _that_ one is unique to the emulator.
> > 
> > Unless Chao and I can't read code and are missing magic, KVM's virtualization of
> > FRED is quite lacking.
> > 
> > More importantly, I don't see *any* tests.  At a bare minimum, KVM's msrs_test
> > needs to be updated too get coverage for userspace vs. guest accesses, save/restore
> > needs to be covered (maybe nothing additional required?), and there need to be
> > negative tests for things like leaving 64-bit mode with FRED=1.  We can probably
> > get enough confidence in the "happy" paths just by running VMs, but even then I
> > would ideally like to see tests for edge cases that are relatively rare when just
> > running a VM.
> > 
> > I'm straight up not going to look at new versions if there aren't tests.  Like
> > CET before it, both Intel and AMD are pushing FRED and want to get it merged,
> > yet no one is providing tests.  That's not going to fly this time, as I don't
> > have the bandwidth to help write the number of testcases FRED warrants.
> 
> I must admit the issues Chao raised were a clear oversight on my part.
> 
> I wrote some basic functionality unit tests in kernel selftests, which were
> included in v1 and v2.
> 
> Later I started to create FRED tests in kvm-unit-tests and extended one
> nested test case to CET:
> 
> https://lore.kernel.org/kvm/aJ9DB12YVJEyDORD@intel.com/
> 
> I planned to send out these new kvm unit tests (not just FRED tests) after
> KVM FRED patch series gets merged.

Definitely send them before.  Even if no one outside of Intel can run them (I
forget when FRED hardware is coming), people like me can at least see what you're
testing, which makes it more likely that we'll spot bugs.  E.g. in this case, the
lack of negative tests for CR4.FRED is a big red flag.

