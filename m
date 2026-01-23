Return-Path: <kvm+bounces-69015-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wFiFJV+5c2n/yAAAu9opvQ
	(envelope-from <kvm+bounces-69015-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 19:09:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E82A79617
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 19:09:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 72E413073DCA
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 18:06:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7545542048;
	Fri, 23 Jan 2026 18:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3CRGvG/s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB892652B0
	for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 18:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769191596; cv=none; b=IM2WApu56VfCzU3OBCrqgmC+sDggUr8nJEJwWfdBJYSydfcjP94GWcMz1D/pU/RKnodii5x9gTDXikXcnIH6pyEEbC1Qd4oIvZqCHpNV7twGQHP72zAiDW8KmcQw3jsbxeaa0J9mi5IqBlKWZ3ggBZXLLBcYWEAnFq6KgQndBKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769191596; c=relaxed/simple;
	bh=HBMBI2gTN3EKvqTY78cLZchezunqrr5qT9xDj/LI76M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=c+9W08DKoIfVuiKI7KEzap3Y6CG1MthMObJb0MelxlN0Jyhxb5GDBp3x/w5gKv9FVfAuD+W2C0PE/BQb5bSxZxg7Ub5EOrFKS8oxq1w3sIK0udektDKaf0Zdj/miju4lZwVa4vhywY70DakoT/AuehTUVvPZdd/WKbuKfRRKlWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3CRGvG/s; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-352e214cce9so1792679a91.1
        for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 10:06:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769191594; x=1769796394; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5kWxxolVgEbWZqXlOySF2Dt4v7LfEshZxevNTBFqVG4=;
        b=3CRGvG/sSI7df3oq12VtjLJqMwHqmRpkF+4jTwEQvyOO0URokXcvYxH6GdxP9fr/Gc
         sTL8mama97DYoqPkOtO8rjF1REAaen2dlshfosSMNqfQ71SzXEZ8DdPTjTGjZ63JNEjK
         1aUtqjpyBIoVM295vUkeegKoN6IJFa6UCj0p/cHFrKMVjsawRl5/eE5flQ8XaPaYlkpC
         AnhYHgDjIXpIv7by2aHRLusNP6CwMLWrPn3XH00RTODhTvgObietY4Wcvmt9ciwu4Yx1
         osh3OUfSoKcbRh1IqxgnovRhV+9RDyYgShBclshzf7VcM3UfO8uTglUuK0JdjDvkmGW9
         wXow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769191594; x=1769796394;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5kWxxolVgEbWZqXlOySF2Dt4v7LfEshZxevNTBFqVG4=;
        b=JTNcG/nd91DFEAuxtAu0Kv0f7dk4fnNLenAcTpaOe1lKbpZMPHV0cb0frnCYTtcgcW
         8jlTK50LK8xRrsQwk1tlsGkJqcsZVP2QCoguV0qRWBaVDuCgA8zoJ842utk9/wPlF3xB
         Suid7qIIpg74xsrpKtT2/DlewbhK9XcL7y2TDb8fItMcUMee3EPZNEIfVEzC4Np2U/XO
         0l9MJjtnF0qaEtyqA39c5C9O98mGag875lMapxpUAzWAZ/F+y6HAobr/Mw90dvw329wy
         RpMjHMHpvBnPpyaDXDlDBhTxj7MYXoPY8478iXjITxMVE3cc3x4hw+0bqluag4i8iRUO
         Ku1A==
X-Forwarded-Encrypted: i=1; AJvYcCWk/VmxHh1spFDI98KDcctEJeQuGDUU4SOP9kusBSPejy0am64i2PjZ2FMvJbe1VM09Awo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwL4z0OuZKdGvvPlIMtLPDfXzeDCgVA6DYdiHrSG0+puF2abG4y
	ti1tJNZ/JNeo0d8T8crfBPCiS18HGrNKBu2X5W6u525h1kf5teJWCs6Z3Ijyi6lgvcN4GqV/Y8F
	0A4CGoQ==
X-Received: from pjbcp7.prod.google.com ([2002:a17:90a:fb87:b0:34c:567d:ede4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d85:b0:341:8ad7:5f7a
 with SMTP id 98e67ed59e1d1-35368b470d3mr3144376a91.18.1769191594234; Fri, 23
 Jan 2026 10:06:34 -0800 (PST)
Date: Fri, 23 Jan 2026 10:06:32 -0800
In-Reply-To: <20251120050720.931449-3-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251120050720.931449-1-zhao1.liu@intel.com> <20251120050720.931449-3-zhao1.liu@intel.com>
Message-ID: <aXO4qPQlkqKeW6Sz@google.com>
Subject: Re: [PATCH 2/4] KVM: x86: Advertise AMX CPUIDs in subleaf 0x1E.0x1 to userspace
From: Sean Christopherson <seanjc@google.com>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Xudong Hao <xudong.hao@intel.com>
Content-Type: text/plain; charset="us-ascii"
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
	TAGGED_FROM(0.00)[bounces-69015-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[12];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3E82A79617
X-Rspamd-Action: no action

On Thu, Nov 20, 2025, Zhao Liu wrote:
> Define and pass AMX CPUIDs (0x1E.0x1) through to userspace.

Similar to the PASSTHROUGH_F() thing in the first patch, these aren't strictly
being passed through.  In practice, they are passed through as of the current
code base due to the features residing in KVM-only words, but I'd like to avoid
stating that features are being passed through unless KVM very deliberately wants
to ignore the kernel.

As before, I'll tweak when applying.  Same goes for patches 3 and 4.

