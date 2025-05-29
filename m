Return-Path: <kvm+bounces-48009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CC4FAC83BE
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 23:57:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 222473BDFCF
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 21:57:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F36F29372F;
	Thu, 29 May 2025 21:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ktvyC58U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A461227BAD
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 21:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748555838; cv=none; b=gTjZXW6s/BYWx94LgMnNfJviXDP4KasY/O/xek15tC+u7e00q7izpyytYDfb3SEy6UXYqZugOrj9cFbCJh61+PWv2syikz39AH/aLorXyQOvys4tDLPXnwuwnejHPO8yyQMlEm8Ssn5oDBtQarOsfEKWEQrPUTMiDqWVxDxZyLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748555838; c=relaxed/simple;
	bh=C7MwUOeLN9sdZgY5oh8m1g50QnyUGiBTBeemP11r5HM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=K0soXHhuOytmnoDtHAGSbZl+Qdi+lg7tDg7yCzFm9xpAfSr5GRaFeW1qDUN5ty9VHpNweXkLAsOtQCRyv+0vRFlW+vncG7ucWUTb4DJu3CyZo/uIyJWLYLDabioftcSh9xjoyfDyZnuHxEK/4/k4OD59vvwX02pQsThHqVpS5Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ktvyC58U; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7401179b06fso1046977b3a.1
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 14:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748555835; x=1749160635; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xM4epPIf57Hi+mr1+5B9fKY2eFy4O/ARTr72jJ20KHQ=;
        b=ktvyC58UVlXjN9TvxxLmJyYXsW8EqNInVuRe0Yv7/R20Cm9fxBxEQ1VjMmRybZUqfC
         E8TE1k7PTFtfhYTmblz+R6ftk/4lAvy8ARpXehsk1Y5mqar39uz74chmp4Thl5eZiHLz
         MYKfwzl9Wr2OhHF70H8C3BGqUsMZ4GsCGJ7nEH9Wif9uECz5hVXSX32HQvy7yaCGDhaF
         0SzYxxY89wY/MJ0Me2CksEmO6VfVKcBYCN9lnf90IOyqCLcCOgA+RTMmxLw1fs5hkYNE
         QsFIe1fk7avqc0mfRc+p18pM98VaProeCbKoIKKW96rG78OEg1UfINY3EPS07fkl9br/
         FXBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748555835; x=1749160635;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xM4epPIf57Hi+mr1+5B9fKY2eFy4O/ARTr72jJ20KHQ=;
        b=ebsXSUKuZT7Ytsro5jaEMNpq+QTcBM0KvnCDG8S2f4XjrDpJ7mm8juZs3bGrXOPmkf
         9BVo4WNgsreMPsX0ySbV+R7sen97Wzr4e+p/J8616FEJ5FFFJjY+ojJMtxSkosqYa6ma
         5ip6KgLAVfCi5Imjy1+Y+f2tujgU/FoxU21rrSvUv4hhH7CF2GwCTR5XkvBiW2xoHh+O
         Wuf49p+4KS+rMEVaegkFCJQAVA3Z8Rs3ZylpUaxe20Yd3mlemEJRFlFhMFkzmeBENwOE
         nBqP25nm/+EJZjiSomzY2tDEd88keIbA1v203SsaHansvVJGsimnoW3S+071Q3XFMagj
         3oyg==
X-Gm-Message-State: AOJu0YxzO/jHqBBs9t5qhcQxmlf4I9p9TUrRRiw50NvyDd4y3Xj88Bbn
	lCOWhN4b3SyluXbi02N2mBm9uq+rlcB/WfyHQmxg3uWWFK6+pMbYd4wV6Nm9MniX9G4xwzrxnQ4
	VrlJQ4g==
X-Google-Smtp-Source: AGHT+IG4km73jCFH5F771HtdWBCtx3aAxlb/7etr9Oi0MS6z/Ku6aFlzLVUYyP/RcEtD0CsU7sIrC33Pg64=
X-Received: from pfbfb32.prod.google.com ([2002:a05:6a00:2da0:b0:746:b3ff:c624])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:a13:b0:742:a23e:2a67
 with SMTP id d2e1a72fcca58-747bd9e6da6mr1314096b3a.16.1748555835625; Thu, 29
 May 2025 14:57:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 May 2025 14:57:11 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250529215713.3802116-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 0/2] x86/svm: Make nSVM MSR test useful
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Fix the nSVM MSR interception test to actually detect failures, and expand
its coverage to include out-of-range MSRs.

Sean Christopherson (2):
  x86/svm: Actually report missed MSR intercepts as failures
  x86/svm: Test MSRs just outside the ranges of the MSR Permissions Map

 x86/svm_tests.c | 83 ++++++++++++++++++-------------------------------
 1 file changed, 30 insertions(+), 53 deletions(-)


base-commit: 72d110d8286baf1b355301cc8c8bdb42be2663fb
-- 
2.49.0.1204.g71687c7c1d-goog


