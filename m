Return-Path: <kvm+bounces-38200-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C2E6A3677A
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 22:26:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7E53518972D7
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 21:25:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F119B1D8E07;
	Fri, 14 Feb 2025 21:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DkCRsxkF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B55611C863D
	for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 21:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739568327; cv=none; b=cX86Sf3ynW4JTcyxIDxe8a1yUbMNx/AwknieNGtuRX2dpWdK7vMcFAEINkxzleQ4TOFJrRYvTmMRkcBGAEOK8VTnlMLXrH532rFGZR65hk/AgZkHJVk3eDwBkyxIwIwowyM+yKMkBOGG4F3B+gc+RFBWRnRxobtr/6PT5vrnwUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739568327; c=relaxed/simple;
	bh=t9rJ7Gb38F6/ysv9J142mBGPDz3KZfSzbI6ai0IqtTg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZNHX/6a2iOua+Pufse8G9CeSWiyHc3TgKbe/dW8CNoh6oBrA8AM5xpqmasRfe0sIHi+LYgRw7ZzKGg0nr64fBBpMCvsyMFDgDbr/IAJJ2FSIhVJ1BxeRukMNZXeWLeVZmR7PSQBsLZjEGROl/obTGpeGL2TpTISzibJfIskXj2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DkCRsxkF; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc1a4c150bso5112869a91.2
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 13:25:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739568325; x=1740173125; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=v5REmVFLDtwqRkt/qAmSseB1gfrB4wKnv7HvIcpb9RY=;
        b=DkCRsxkFpDBDpWzCFEtUGCZdViwkNzJRY8XjmhjRKLqXRYqQh3sK53ngkPQpDY26cc
         DoAyoR8i1xZDyWWpaUKXg0z5JC5tyPbmyo0maKPISUQIzU1WkoSxSosQCWVJMbpx8neC
         wtJ+Z2RHzb/51AdstdRF0uTIT8XO+93+6V60kng1F9Bfn6kc40AvFl+CP7rcKstAIJDv
         CJi+WLy/TvCMftY9Rv8gSCLT+ZjCFFCRpqUjAeceJEQGmSVYosQ54jlu2Z8KYStw38IY
         UNol14W+antJtOv+7Yjzh4qDAeWOD3JTWkzdqhYitzQbWqx2lCI4hV8xxXLekZOEiZCW
         EocA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739568325; x=1740173125;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v5REmVFLDtwqRkt/qAmSseB1gfrB4wKnv7HvIcpb9RY=;
        b=R6tHTH9baPWbNDX45ho4RrWPMpD6ZRTuUnj6v7/c6sb8hrPMl7p3YeVkRDWrABE1c6
         lN9YtbikVCm97wXssIHZ6snZjsu/2DbjmNuoDFyq77QcfxBEHdjJHwZrcA+uP6CXefvm
         VZIRCxd2lAq6tWSRofe45hqXRwWKyqTcWMBamMeArpvox/7bBoOIaKI0t4HxODv3S43g
         6uu8FfQy+1JkWsYzaVo1jGjPLaNT807GPe896dg2fHwO0VFjJTgYA0X9b9waEVucFqpy
         gLQ+9xQxDNUjDZ5WVmn+/Vfp9xNu3EMLozcRMiiZWUZcaE7D5lRjyVcMbUskU0K07lFa
         NsLw==
X-Gm-Message-State: AOJu0YwJGlP/RP+nEcVmDjSsx+KKrJnfH46WniDNM+MrNih2IAhH8epJ
	CxtTThyUfTEq0p56UarNaczOsvcUvH510CQKRCI1J81YRRXjSGOnEiCNnCSpzLlENIj1TwtI2up
	kfw==
X-Google-Smtp-Source: AGHT+IGp/R7UC/jPofgH5qTj3HRwZ5eKvH0w+P2Wlnjn6dhncbNW5t30WXG7IhXsT8XajAOFYQSkLF7KoWY=
X-Received: from pjbrr7.prod.google.com ([2002:a17:90b:2b47:b0:2fa:24c5:36e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:164a:b0:2fa:15ab:4df1
 with SMTP id 98e67ed59e1d1-2fc40f10292mr832438a91.8.1739568324924; Fri, 14
 Feb 2025 13:25:24 -0800 (PST)
Date: Fri, 14 Feb 2025 13:25:23 -0800
In-Reply-To: <20240907005440.500075-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240907005440.500075-1-mlevitsk@redhat.com>
Message-ID: <Z6-0wxPyAvLg9FRi@google.com>
Subject: Re: [kvm-unit-tests PATCH 0/5] Collection of tests for canonical
 checks on LA57 enabled CPUs
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Sep 06, 2024, Maxim Levitsky wrote:
> This is a set of tests that checks KVM and CPU behaviour in regard to
> canonical checks of various msrs, segment bases, instructions that
> were found to ignore CR4.LA57 on CPUs that support 5 level paging.

I have a variety of comments, but nothing that meaningfully changes the
functionality of the testcases (mostly cosmetic stuff).  I have very limited
cycles for KUT right now, so I'm going to send a v2 with my changes, but I'll
respond to each patch with my feedback/changes.  Please holler if anything is
too objectionable.

> Maxim Levitsky (5):
>   x86: add _safe and _fep_safe variants to segment base load
>     instructions
>   x86: add a few functions for gdt manipulation
>   x86: move struct invpcid_desc descriptor to processor.h
>   Add a test for writing canonical values to various msrs and fields
>   nVMX: add a test for canonical checks of various host state vmcs12
>     fields.
> 
>  lib/x86/desc.c      |  39 ++++-
>  lib/x86/desc.h      |   9 +-
>  lib/x86/msr.h       |  42 ++++++
>  lib/x86/processor.h |  58 +++++++-
>  x86/Makefile.x86_64 |   1 +
>  x86/canonical_57.c  | 346 ++++++++++++++++++++++++++++++++++++++++++++
>  x86/pcid.c          |   6 -
>  x86/vmx_tests.c     | 183 +++++++++++++++++++++++

There's no unittest.cfg change, which makes it annoyingly difficult to run the
new tests.

And there's already kinda sorta an LA57 test, la57.c, which just needs minor
tweaking to play nice with x86-64, so I think the easiest approach is to modify
la57.c to run on x86-64 and then lands these testcases there.

>  8 files changed, 667 insertions(+), 17 deletions(-)
>  create mode 100644 x86/canonical_57.c

