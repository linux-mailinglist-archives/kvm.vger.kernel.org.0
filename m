Return-Path: <kvm+bounces-8227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D42E684CD1B
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 15:44:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 133541C22BB2
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 14:44:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 985347E762;
	Wed,  7 Feb 2024 14:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c/1vc146"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C9D7E779
	for <kvm@vger.kernel.org>; Wed,  7 Feb 2024 14:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707317069; cv=none; b=NQjcVCIXOR+cwfNZsuf/EY61IY4E2qN2sUOWD1avgUNUx1Wzs8TAegl9fSZXH83X/qjYxL/Zl/OiiSyE9CBluEaf53Hn6XrcKrgO7n+Mgr6RsJ7iGbvPOdJ7n+nli2tp784L2izAEC5YSHWYSrsY1HxsFT48dzPghi0zRp7dxqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707317069; c=relaxed/simple;
	bh=uxQwTzZxlSgUDCK/K3VvROXmTUugtOKyUPaFRh0caQo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WqKLTmSiUY5iZSNbG0kFzxoWkK7vzV3q1mbPxA7L2m9U+s+IXj0VqbjHXDfpULfT02cT3kmNmtjkpp2GHnCGWgudTYLeS996hSNdU2JWTQxP8qpgAcfansqNNI0vTYYahrcLsrvC3mPEIKTeNOiZ5QIxPy45GoqlzlotdvOgFCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c/1vc146; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-296edafe8fdso260215a91.0
        for <kvm@vger.kernel.org>; Wed, 07 Feb 2024 06:44:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707317067; x=1707921867; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lZHAUjLUiH8dEIm5GRCfRsiGf0PsZiDDo2l2QAJaJxU=;
        b=c/1vc146QfyuQhsZ3HABmkPzE0U5W2DdfEeP0tBd2ZglkE6/adhB0UicGcluZGwEDf
         YgDoPha3JM69/IaWebpIsrIR3dCYUI51CbRHL15itQtHc/k6nvKtZtqDAqC2JCAPQf4U
         CG3qH6X4rJ9K77DcgW38Bs64ja8PdVDLjsITjRIs4stpkEnPhyefGz30wdK3CrHZ48/0
         QpZ1IIfw7r2v0ZgMYmu5uXLbqv6EsjOdBrZJFQ3UfNy1tgMT9D9lpok3utWc7h9IAcwI
         Hbq83OuhxEgG/msvQcRSrSZwNNrjHs9fjHfQSOpCx3N4h//sQ5b+FvZ+CNVIsD/mHj4z
         IPrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707317067; x=1707921867;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lZHAUjLUiH8dEIm5GRCfRsiGf0PsZiDDo2l2QAJaJxU=;
        b=KO4HfRE8QxvFY/7W5PyOTI12DD3Fu0XxOAbUeWJuOWWw9uIJGQEuprNA5fbwRqqiSY
         Zeh56bFIKd8EnitmrlZZujjiLRE/MADNU+s8Ldxm94dIGdUmW7K7OnNJY0MU77bbhxVX
         /fhCleqqHR/YXbaWslv9mK8cBUQMjRevM8YreFxYTPvyh3WvTZ9H0HAKZTG9FXdFBjKL
         FiQUmGusz6NCGWDJqDMfXc5bNZVgMgem1jlFFOjZWrMZhN0QUW+/VhkQra6jYNlTMxyk
         YkxfoljgwbScBJvJd0Jte0uujKj9t0TK5GrBtMJ5d80z5iSipVJ7po7UQZoxRw5lZClt
         yCnA==
X-Gm-Message-State: AOJu0YypFUHG9FqYDzGMGfmAuIiwZ1cGqlwOwsBqG6ooXPRv5HbZPdeR
	68Ez+WNIhSoxhF+Desgndo/3mZpQ/7Jiwk6aOT5z8XL4prmTCdwvK7kB26DjCr4aPjGpSGhyLEM
	0LQ==
X-Google-Smtp-Source: AGHT+IHJ3xQYza6axYZazPyvDXJ9Z+pBD1sKt6fyMMXS66kejFjyD2p9PHqYh261s8lRSJdrkToqcw49p6k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:5284:b0:296:7901:3844 with SMTP id
 si4-20020a17090b528400b0029679013844mr45687pjb.0.1707317067444; Wed, 07 Feb
 2024 06:44:27 -0800 (PST)
Date: Wed, 7 Feb 2024 06:44:25 -0800
In-Reply-To: <6fdbeed0-980e-4371-a448-0c215c4bc48e@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240202231831.354848-1-seanjc@google.com> <170724566758.385340.17150738546447592707.b4-ty@google.com>
 <6fdbeed0-980e-4371-a448-0c215c4bc48e@redhat.com>
Message-ID: <ZcOXSZ2OPL5WCcRM@google.com>
Subject: Re: [PATCH] KVM: selftests: Fix a semaphore imbalance in the dirty
 ring logging test
From: Sean Christopherson <seanjc@google.com>
To: Eric Auger <eauger@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 07, 2024, Eric Auger wrote:
> Hi Sean,
> 
> On 2/6/24 22:36, Sean Christopherson wrote:
> > On Fri, 02 Feb 2024 15:18:31 -0800, Sean Christopherson wrote:
> >> When finishing the final iteration of dirty_log_test testcase, set
> >> host_quit _before_ the final "continue" so that the vCPU worker doesn't
> >> run an extra iteration, and delete the hack-a-fix of an extra "continue"
> >> from the dirty ring testcase.  This fixes a bug where the extra post to
> >> sem_vcpu_cont may not be consumed, which results in failures in subsequent
> >> runs of the testcases.  The bug likely was missed during development as
> >> x86 supports only a single "guest mode", i.e. there aren't any subsequent
> >> testcases after the dirty ring test, because for_each_guest_mode() only
> >> runs a single iteration.
> >>
> >> [...]
> > 
> > Applied to kvm-x86 selftests, thanks!
> Do you plan to send this branch to Paolo for v6.8?

That wasn't my initial plan, but looking at what's in there, the only thing that
isn't a fix is Andrew's series to remove redundant newlines.  So yeah, I'll send
this along for 6.8.

