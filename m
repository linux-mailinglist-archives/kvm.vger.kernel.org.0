Return-Path: <kvm+bounces-20706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D16A091C962
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 00:57:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F9251C22C3F
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 22:57:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 121B7136E01;
	Fri, 28 Jun 2024 22:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q5uTL2yx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A2685285
	for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 22:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719615420; cv=none; b=AcuRzHsqghUqZRtl5zKNSlhIhNDA4R08L+FwQARTK+XpDVE3LWMpkKFZeT7rlVe+b7u3OJHI3y2c8SCSh2vvln0PSQ3np58pge9039NNrTsNz/XXMBIOsc5MsT0ECaQnkqgb3Xnx8dw0tSX7ADKvnma8Kip4oCKskEqn3aFZ2kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719615420; c=relaxed/simple;
	bh=R/ZZ01BUMJass6vcnzebJ4EDyiBiQSblYt72eT+mc3Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WxPK59R0UHDrE5OSJafB0fVx3VnP/J96VqPl1/DdrmJnkfrANn/NTl7/C7snDhll1Ca7B03F+e3SJ/z18oF3P8PZd+btI29SsOq8DjzAP99801ka29Xsz9JbyIy1vaGMe3vFbjFM3o6kx/VpCzZrg/ze9Ofg54QD62AE8Imp94g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q5uTL2yx; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2c7ef1fcf68so889496a91.1
        for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 15:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719615418; x=1720220218; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1TYj2TZPpVeCJnlW6WBsJe77ol7Kf1Aou5o5ttttPsE=;
        b=q5uTL2yxFq9cx/E40Fao7KshXnmA31MenDrqk4jepasfeC1nFtkK9H8FHT6k6aZHMN
         sycKBa8xDYyXD2o41UPxYN75DuNVUhVWQ1p5a+Jw3y1ZKhuICN3KWumPk9XxyGWXf/ji
         a+aSYFiMtaERtZP6Gc50+AAK7BapNX5zpCq5xu0PUIEDfMaUmo9Ub9ZWfW2ymxVtT3e4
         JWbLLjNfX9yg/L+bxu/BJ3M93IZiKcZH8zSICs/cf1pOOlLRk3uAkXlUAJEYxVRbKzeD
         ODz5HwjFa1pz0sEQm14T6uWrfYtMAz6+kYJpfXNrCQODjon1142W1RyBx9Elm+oPZ7XP
         ccMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719615418; x=1720220218;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1TYj2TZPpVeCJnlW6WBsJe77ol7Kf1Aou5o5ttttPsE=;
        b=UVScri/zim3tu/FRtRjnEZngwg1vknJzygpncfn1Beq9GluPjgjchejLy1ryMc7Maw
         JS+mgbRCAOIVk4zqI3bPaKYFYLBSIatEsSdGYewMYvm4nRt2fVdndAZYj3clGsKCiqEg
         6qd9fI8i6VFdAcqyK1HR5oF+1z5kBxVSQTxGykKHj0+lL6Bp7WTDsF4CFdVaNDMBE8iu
         oUdMJhKQixmgPZQ6GzPcK+kRrQDyohhneGMTwiuzh8Be1SVGrJ5KG2rbE3swXqBtXsgK
         pxgvVtMfkqWzKL4bbWw6pABWh125JggsI+8nRmgMJseLJcH/AOSL1ctRCXWHcfT90mm8
         GKNw==
X-Gm-Message-State: AOJu0Yycl/eSUEtHFwoHAp+xnkTqO3h2EJgAudct+yN8ZN7YPMu5mBRI
	aavh36dse6+68UOgMekGOx80MNZXygPI8r1NNtV+1RH7lEOxJLC6H+p5vcORutsthhkldukUb23
	mxg==
X-Google-Smtp-Source: AGHT+IFn3thlh78sPFpUcjjJ3e8afZkxEnFXZJx3Xg9r6LMlYwN6ZmN+hjdkits3bfwrxjFnEkhWWMrwp8o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4d85:b0:2c2:fed7:d797 with SMTP id
 98e67ed59e1d1-2c8507b2998mr74129a91.6.1719615418320; Fri, 28 Jun 2024
 15:56:58 -0700 (PDT)
Date: Fri, 28 Jun 2024 15:55:32 -0700
In-Reply-To: <20240628005558.3835480-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240628005558.3835480-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
Message-ID: <171961369481.227974.18088204748355236734.b4-ty@google.com>
Subject: Re: [PATCH 0/2] KVM: selftests: Fix PMU counters test flakiness
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 27 Jun 2024 17:55:55 -0700, Sean Christopherson wrote:
> v2 of Maxim's patch to fix the flakiness with the PMU counters test do to
> a single CLFLUSH not guaranteeing an LLC miss.
> 
> v2:
>  - Add a prep patch to tweak the macros in preparation for moving CLFUSH{,OPT}
>    into the loop.
>  - Keep the MFENCE (because paranoia doesn't hurt in this case).
> 
> [...]

Applied to kvm-x86 selftests, thanks!

[1/2] KVM: selftests: Rework macros in PMU counters test to prep for multi-insn loop
      https://github.com/kvm-x86/linux/commit/5bb9af07d37c
[2/2] KVM: selftests: Increase robustness of LLC cache misses in PMU counters test
      https://github.com/kvm-x86/linux/commit/4669de42aa6c

--
https://github.com/kvm-x86/linux/tree/next

