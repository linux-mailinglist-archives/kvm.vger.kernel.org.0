Return-Path: <kvm+bounces-63242-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 75865C5EE04
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 19:34:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A55DD351E10
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 18:26:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5821532570F;
	Fri, 14 Nov 2025 18:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D7sh1WEX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145702FB967
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 18:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763144756; cv=none; b=pGMhTZsLwkJm6xxycbDHRjLFb4W7zhat3uq+Ij3w3j1jVBWU6KDMNYpG5xaqrmUIplH8tzZd7r2SOoMaRVEZqMF9tGA0F4yLV8nBYndtyrR7fbA2DJDl7cktrospSduAEs/ByMMXG6cNTjKlY05SPC9cm0BtESMjnPDhUyno/fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763144756; c=relaxed/simple;
	bh=TyDm6Trk2TRmYtcoRtnafyvYid4VPbQoPvuDmcSverI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RFWfk0vIrpNHUZF3qh+FlDiRwL+cMZpAt3fYxB1WDL9w7SobfBIWFoupfxS8Tgtq6udI0jgLXtsMM601N83xZespTLPT6/EGwZL6m/dyTkwR8WsdzMoSNuuNA3VrrLG3Xy3ntO7JW1JiarUYIzuk4ODGZrYUFgWilOg7zQkR7MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D7sh1WEX; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-343fb64cea6so1806879a91.3
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 10:25:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763144754; x=1763749554; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CkxnX60eCRTyJOeHwP1COZ+iHv5clr9FGEnLCxZG7aE=;
        b=D7sh1WEXlwyxjxSjvC8F0q4QVXNZWnmHR3V8VYzPaCurHrRrrbSjC0qrQHVAzbWIXe
         im5pnKetIw9NH9eGIzgCyULr8DQ/+ljw4j0nIDJ5/SQRn7sHqZg7oUDrTjFOuZpX97O2
         Ep2pzwJiBQMBsS5ITeetrcW3fHuSEYheNSwPMQgYB5H5GN+cH1FdiAArku1g65GBfZ6e
         qoaBLm628g3Tlac6NTrlK2aQRCGnU0Uic23kNV7CIatID9Kzeu9hH2BlHy4gtwo+H2JU
         /UnMwdGxZOrgtWQXWQ9ugikq5O8KspLL1MEVsCp85gfO1lAOFxvDQJwG2CCWK8ijck/F
         Jrcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763144754; x=1763749554;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CkxnX60eCRTyJOeHwP1COZ+iHv5clr9FGEnLCxZG7aE=;
        b=iSl6EvRe5KArxFjK6bsh7h3B7nzL15UmVxjeW9w7YUfQWrZ21tVTBf7OmZmf0FGMQc
         H8F8kFooBcB6CXO34AWbW1QwSeP9SqAiXQ/J4L1RVB+b2i7WUhcWiogJtfx6TLOHThQS
         v65bDdEhyvflLmwTyvHGUWwMfRxMh4RuMbOyDM6PibGY08LxLVkDnow1QshPjIg/B3UF
         Jxa+PPkoEtGNWRiOFBYZkQwe2rFZoQXj3CS0DcZC1Vp3S/OcQSmCTsJ5746vhwaMnUUl
         8qvMC+p3S/dt9knh6cUbrQ32AtqQNXbSHIhN/tyDwnMcimbgq2PQLKNtGIjFjMgbwWH+
         o0Pg==
X-Gm-Message-State: AOJu0Yy/A2OLMb3UoDpGV8ze45LHmtXW6pPN0ICWqGgfotiIljKPWtj6
	2LwJ4+X8RFE1pP7MSZnKv+gRQK1Xhx/afMeko63LqOp1VjLWd8CEg1/11+WARq+phKpP+RzKvHq
	4oUB7hw==
X-Google-Smtp-Source: AGHT+IEBbKG0iCMT8+liEbbKW7D6/cQKYjduaL41NtO3r/DiZWkEZg44si39Rqhc20QIfNAfZk3WsYo6DL4=
X-Received: from pjbfv24.prod.google.com ([2002:a17:90b:e98:b0:340:b55d:7a07])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1d43:b0:340:bfcd:6af8
 with SMTP id 98e67ed59e1d1-343f9e906d0mr4502734a91.4.1763144754348; Fri, 14
 Nov 2025 10:25:54 -0800 (PST)
Date: Fri, 14 Nov 2025 10:25:45 -0800
In-Reply-To: <20250915215432.362444-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250915215432.362444-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <176314469132.1828515.1099412303366772472.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH v2 0/4] Better backtraces for leaf functions
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Andrew Jones <andrew.jones@linux.dev>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Eric Auger <eric.auger@redhat.com>, 
	Thomas Huth <thuth@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Mathias Krause <minipli@grsecurity.net>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="utf-8"

On Mon, 15 Sep 2025 23:54:28 +0200, Mathias Krause wrote:
> This is v2 of [1], trying to enhance backtraces involving leaf
> functions.
> 
> This version fixes backtraces on ARM and ARM64 as well, as ARM currently
> fails hard for leaf functions lacking a proper stack frame setup, making
> it dereference invalid pointers. ARM64 just skips frames, much like x86
> does.
> 
> [...]

Applied to kvm-x86 next, thanks!

P.S. This also prompted me to get pretty_print_stacks.py working in my
     environment, so double thanks!

[1/4] Makefile: Provide a concept of late CFLAGS
      https://github.com/kvm-x86/kvm-unit-tests/commit/816fe2d45aed
[2/4] x86: Better backtraces for leaf functions
      https://github.com/kvm-x86/kvm-unit-tests/commit/f01ea38a385a
[3/4] arm64: Better backtraces for leaf functions
      https://github.com/kvm-x86/kvm-unit-tests/commit/da1804215c8e
[4/4] arm: Fix backtraces involving leaf functions
      https://github.com/kvm-x86/kvm-unit-tests/commit/c885c94f523e

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

