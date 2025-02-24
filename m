Return-Path: <kvm+bounces-39016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CDB1BA4298B
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 18:26:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DDDAF168369
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 17:26:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63EE22641E9;
	Mon, 24 Feb 2025 17:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1Tbc2LLj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31EF4263F5E
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 17:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740417918; cv=none; b=KINsLJJp6fUMfnrla8qxdvyJjMmk8od3SL71IEg+o6R56orom5yXFbrFKfYKBJt028WxdkspFG6ahtqYpB+Tw6qTZV4dZUYqACgp8QG+n0JkzuONclZHLtcXPQCZkjMCwvE0uh8L1wWaErIScWvgkYkxeABVdOpWmiLXaOGJoC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740417918; c=relaxed/simple;
	bh=NWzpxnc/0vef1bFkym3rseydhD07eQ7MKsRp4QvA5XI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ElEoTZFEPgs9paiMBrXk9PwZhHsqDmkgaOOPB9o1hFeqPKa7DyZRBWrUgR62TCVHfirqGbspXe0Xicf80pkwhqKrGRzdOjbYdjPwHeVOFwvWfIa1vHpC4OnaMLIZL6O+tLHcGwl7nJ77a0pLXiYto0cY6KKSupi3TBGng3YMAOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1Tbc2LLj; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc0bc05b36so15153239a91.3
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 09:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740417916; x=1741022716; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fAbJdTbEhdOlcR0zdK0lBheZNea2bUpLHgY2vQ5ns/U=;
        b=1Tbc2LLj5UioCRmESOjoDIAClyZ3CvWNi68S2EJFXnye1g7MUfYfTHIthkumHKPUCs
         ez6dXDtaWZ7Z/+3I6qgl6Jc3Sn09UbGZfWcFIGmsEv9mMFJa1vbfN3Z+95d0NcVyWFch
         BpArZ5vSSr8GPEcRtEMoQNlG9g6hvWgr8CFv0xV25f0EQ3QCI2DdqZl38S5PsdwbWr5o
         8Ch2MpYXarNbPdKp89KKZIQiEFuPHXF5JwF9ZoleTx++qsz/hsp6hYqa8K3zCz8L8vHO
         XJIEQY1hA98yP1mpko3NDxNseqXr8KYXQNPD8aos0VhV+K24L11q+oQxXzi23v7FYCez
         6WVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740417916; x=1741022716;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fAbJdTbEhdOlcR0zdK0lBheZNea2bUpLHgY2vQ5ns/U=;
        b=BZrPaZN7norPH7YrDngikanjuS6kvvlanH62YxWGuuJUpG/WUGlkbpMTlx00o9icuG
         GKeuTIyA9hgxtXGqYbhIlJc/Ujf2lTw3tzulV19wjmBGAQcemDJKGCrFeUcDqoz4lMXq
         O+5HpGVNe1UgGw2VfwkHVmU1feZOYe6R11YxWWreNtArXP+tLz09LayhWPZ9stxDGUqr
         Pt92PpARw8M0VUsou94ZBnev5O0yjV9zccCKTmZKrKoJuqmaPqoXJi04ZOhYcMVuXJAe
         fxZKvYQS+70icv0f/gharPvmlQsFc9dH85SGC8Tsgx0nYZu0nm7hr8qZjWLnuJYSo/o8
         3x2Q==
X-Forwarded-Encrypted: i=1; AJvYcCUR/DA+GqvlPnXl5yxg+F3nkq106WsUBJeuNcuaot4z7bpz52bSwbUvUhtUSLbv4Og4R5g=@vger.kernel.org
X-Gm-Message-State: AOJu0YzprO6OHsV5IRpTa8yPUmsevCEPQrqT+Gu9K3d6Qy5sWeJsnlNu
	Y0IYFLMTLpGTgwvQCq9oK5WCij2aUKaw+7Ba8xeTAC0uuf8WXext8QmkVRDjCDcg1O3MTq9yAez
	9qg==
X-Google-Smtp-Source: AGHT+IGj8gToYAbblNP5TfdkeMegRBEJOUaRGM/lf4H1nDOwc2KCdn4XZRmRiBC/eauHGadfx6zDKJ72CNI=
X-Received: from pjbsx14.prod.google.com ([2002:a17:90b:2cce:b0:2f2:ea3f:34c3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:388b:b0:2fa:13f7:960
 with SMTP id 98e67ed59e1d1-2fce86ae5f1mr22729240a91.13.1740417916426; Mon, 24
 Feb 2025 09:25:16 -0800 (PST)
Date: Mon, 24 Feb 2025 09:23:53 -0800
In-Reply-To: <20241002235658.215903-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241002235658.215903-1-mlevitsk@redhat.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <174041741120.2350210.12346235509379336565.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH] pmu_lbr: drop check for MSR_LBR_TOS != 0
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="utf-8"

On Wed, 02 Oct 2024 19:56:58 -0400, Maxim Levitsky wrote:
> While this is not likely, it is valid for the MSR_LBR_TOS
> to contain 0 value, after a test which issues a series of branches, if the
> number of branches recorded was divisible by the number of LBR msrs.
> 
> This unfortunately depends on the compiler, the number of LBR registers,
> and it is not even deterministic between different runs of the test,
> because interrupts, rescheduling, and various other events can affect total
> number of branches done.
> 
> [...]

Applied to kvm-x86 next (and now pulled by Paolo), thanks!

[1/1] pmu_lbr: drop check for MSR_LBR_TOS != 0
      https://github.com/kvm-x86/kvm-unit-tests/commit/584a927eaf58

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

