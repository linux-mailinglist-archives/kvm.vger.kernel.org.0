Return-Path: <kvm+bounces-72741-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CB7vJsOFqGndvQAAu9opvQ
	(envelope-from <kvm+bounces-72741-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 20:19:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 481FF206FF8
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 20:19:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BD10A302A2FD
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 19:19:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD9B53DA5D5;
	Wed,  4 Mar 2026 19:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PyYgxrkW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E46635F174
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 19:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772651956; cv=none; b=Dy62vXjVktmLcoPRkRj4qcs3UO7EHhvgMZ/e2z8Vuk7TLljfFJkkzxkrJ39gRHQtFj+6sovufF6PdOSi377jmH06ib1OmoziUUrE9tL0Tsl8EDT0XDpp8M8Sz4riwosvJ8bYq9bbLyAGCO27PJvcieJwwjBKXmWXi45/HfAHGCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772651956; c=relaxed/simple;
	bh=AJfvmOdG9Q7H3f6F7/f1NLYvwstyCEC7CtDarcJ2/2w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Xo8gZp4vBzJpRgHULWE9/fKeub3ryvFyb7nY5F15VfK3itWLpGCrl2tXAgg7kGBWN3BC83okQAXZLPVe0s3hPxsUK/iSGgQPdhPTin75ajIC1pC5qmyvTX6HDtAc2OfZqxcsxdZvOaKWJk7hV3r3dkfEgkqtkAA9FnKCC8+Wsow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PyYgxrkW; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-358df8fbd1cso6551382a91.0
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2026 11:19:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772651954; x=1773256754; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bT4uLh5T3P+g3RwKfZTTZChmGlh1M0/cVeEK1fku5js=;
        b=PyYgxrkWq2UncuPuOHJGWG4j0UdmlzZiBnO9P41aNwlsca0UjE54tgIfojZm7U/7Qb
         2nz9iKSP7Qo7lnWNlcREzmqdGkxEAwOLX7zUs1PbYpZijZBWc1NOQcKno4FLpRT8DzGv
         Abypf4aAGIJEb7fENYMK045VVso7k4sf0qeAZkS0PWqoshFjG6aptmDcNYFUSG94ZQ5f
         jEUXEarnfPCgkEfQZINfCP64GzLy+XVkRheWwSjVd922ulA5ezin97ZhM19IP4VwvQ9/
         W1yyut3iZq00VkttM4wklYyZuofnnvgk5LVaSqoRWImFYcZxRWTkrFIg7cJoaVt/+IzI
         azDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772651954; x=1773256754;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bT4uLh5T3P+g3RwKfZTTZChmGlh1M0/cVeEK1fku5js=;
        b=MB8agaKnGpReWS/WBdN3g+hF0dprUi1K2F8NxPGmlcJXFnnthLe2psywAHJhEEtIFP
         IMI0+LqPdh2emgYnaOtENkT1Site30XwUF+w08zP+DhCeGpQTABbKk62QTMtACRg4dg7
         RlfjtAkb7gcijXQHXIbmtnC7b6t9eRZaqhf9YS8pCwtRMdyW8Y4B8EaARky5s7l883QG
         bWfJAR0V0qauO2a3WSEARw44+u0fIO29NI1oxHUGxe7Tu9+t6gTeoJWE+3YvL0s3hEKJ
         k7L7FyAWfufWjfMVrHJJWa0J93Ye9I7oesC/We0E6I+uFmn273QWwfUoeDv64iSuITQQ
         ZmxA==
X-Forwarded-Encrypted: i=1; AJvYcCVDfYpAfFbSWVeghWyYAPtA0sL1QPh73pj8gjvqtje1XLTYSJ0TUG8jql2Kb2NK4+idQxM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3zcc/22Iuo0LVL7RVo+Pf+XJm/z10whcbpth86maGfQzr7Rkm
	LpT5y49QP5CB4FC76QVaWkJrrt7s/P1HJzAkUCuasyc5Dn7Sfa4rWaRsBYgTQHr2rSmeWUNumlg
	RjHFDwQ==
X-Received: from pjvm12.prod.google.com ([2002:a17:90a:de0c:b0:354:c6d5:9b66])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4fc7:b0:356:7b41:d355
 with SMTP id 98e67ed59e1d1-359a69a0346mr2166086a91.1.1772651954103; Wed, 04
 Mar 2026 11:19:14 -0800 (PST)
Date: Wed, 4 Mar 2026 11:19:12 -0800
In-Reply-To: <20260304165012.13660-1-dssauerw@amazon.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260304165012.13660-1-dssauerw@amazon.de>
Message-ID: <aaiFsN3Jn_C5bTnd@google.com>
Subject: Re: [PATCH] x86: kvm: Initialize static calls before SMP boot
From: Sean Christopherson <seanjc@google.com>
To: David Sauerwein <dssauerw@amazon.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Woodhouse <dwmw@amazon.co.uk>, nh-open-source@amazon.com, 
	"Jan =?utf-8?Q?H=2E_Sch=C3=B6nherr?=" <jschoenh@amazon.de>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 481FF206FF8
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
	TAGGED_FROM(0.00)[bounces-72741-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Wed, Mar 04, 2026, David Sauerwein wrote:
> Updating static calls is expensive on wide SMP systems because all
> online CPUs need to act in a coordinated manner for code patching to
> work as expected.

Eww.  I am very, very against an early_initcall() in KVM, even if we pinky swear
we'll never use it for anything except prefetching static_call() targets.  The
initcall framework lacks the ability to express dependencies, and KVM most definitely
has dependencies on arch and subsys code.

I also don't like hacking KVM to workaround what is effectively a generic
infrastructure issue/limitation.

Have y'all looked at Valentin's series to defer IPIs?  I assume/hope deferring
IPIs would reduce the delay observed when doing the patching.

https://lore.kernel.org/all/20251010153839.151763-1-vschneid@redhat.com

