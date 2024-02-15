Return-Path: <kvm+bounces-8716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C7163855883
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 02:00:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D02728BC23
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 01:00:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A53B9137E;
	Thu, 15 Feb 2024 01:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lAr9KvXK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77ED3A50
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 01:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707958810; cv=none; b=SdkkjVcnJGR41saMsfOddYio46smgVKV4eBg34TU6B1iLeZNvy/jDYwcPwHur1WE4YtIpuZjOVGTHuk1xTS2IdNvOUH1cFNkqpUw0faq1VYBqlpIFsvoBSd4kZqN08r9TT5aJmNeIbW3YGne/PeYZ+SEm+29xStYxtB4nu7TNeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707958810; c=relaxed/simple;
	bh=7ekzgG3CaaN8Upth91WUvnRta1oqNcnH4L+iJ4pODBU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=LT+EkxH4DWfZxOlt6xw3iXx4pdAthNn/LWQjNyxpWkEFGQybwa2ot0Tieq1W/S/04d8aasavJP3IkcJ882rOdsTUz3Jops/W7dZGLUtXqGWiETNgFHexTmP/GVJxsfqmtFBonbssB0IqwH9eV1zPqzPvj734/vjryGVTzIyy+I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lAr9KvXK; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6e0e690a604so404747b3a.0
        for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 17:00:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707958809; x=1708563609; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4YwMoxpPdGIXr65qlRk5ePgKg8TaGLQF6RmLNsWlQrs=;
        b=lAr9KvXKWB7GQoTN8FeQY/M1Md6EJeMV2WRkbAxuURGsWqX6CZNXwiwPEwXsdmtFqN
         MwXzsPp6wCndeaSZMf6Bbu+HjPzFBStYfeagqXXtlFo2jngSLctujL1Mc6YzLM2QBykX
         d0rt4jLY1rGCNpC8SuMAzqLQ0mhvPRWtL1L6Ijei4ScAi9+pfiMk1mFIswKHjjp6K/pv
         rkwsyD6yGheSJqDJ4+Afve/Tj7senUTa20iNW7dLjBVHWFmKnGGTGyWBWBhmzPaDWm3n
         fxS23O1L2FWf8y92204hlP9LTUiS23Gja9/nsPbfQYbO67ClEu/nQZzRMCw7eghuWzQZ
         ZQJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707958809; x=1708563609;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4YwMoxpPdGIXr65qlRk5ePgKg8TaGLQF6RmLNsWlQrs=;
        b=Z1/Tez8XD6t1HmhPKZzv4CKKD1PB5wbTndBN46BfO3UhIVlpbPDV6MlN327zq/ATH4
         yuc8MnBGogJzNvEH8cn9tnl6fcJFUd5iPUKVhuYtI0WdsS0UoXO0KiHeH31fTcyc7MEI
         tPGmdkvRCOeTV3jg++BA8DB2LeFhRwFGAO0Rx3X46l3dY67zZG7JUg4hxcGVSQkXXCrT
         Lzonb5v0OjA5h+Xv/NNZM14RbtQgK9Gf/8/RAjwpadJ1Pcq+xfls1BAC6P8XbNCuAxzc
         VW+MHSZh+1U7M3YTSSLJJewDZVcXeKhDmo03yQNDqeRiPBggVltjOxUI72clEBitoVYp
         S8qg==
X-Gm-Message-State: AOJu0Yxo1hzTaMkHObOLv9DpcDntk3jY+c1j/oPbp9LQfa9f5a1QCU3N
	/E/VSh6myTN9Zbl1kRtzuI92HPmovwYHZeQtSw4hb/b2Axgabnu1mAk4pAR9Zjrwo+66DOOFgbg
	/iQ==
X-Google-Smtp-Source: AGHT+IHbgxWGeAcTLvyyR5JGefTEZ9NtWIBrEe+y525as1+L1R1b5n5OWHixhWFd8MZyMusPNUnZI0T78SM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:4f8f:b0:6e0:e2f8:cf40 with SMTP id
 ld15-20020a056a004f8f00b006e0e2f8cf40mr40419pfb.0.1707958808772; Wed, 14 Feb
 2024 17:00:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 14 Feb 2024 17:00:02 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.687.g38aa6559b0-goog
Message-ID: <20240215010004.1456078-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: x86: Fix dirty logging of emulated atomics
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Pasha Tatashin <tatashin@google.com>, 
	Michael Krebs <mkrebs@google.com>
Content-Type: text/plain; charset="UTF-8"

Fix a bug in KVM's emulator where the target page of an atomic write isn't
marked dirty, and enhance the dirty_log_test selftest to serve as
a regression test by conditionally doing forced emulation of guest writes.

Note, the selftest depends on several patches that are sitting in
`kvm-x86 pmu`, so I'll likely take the selftest through that branch (eww).

Sean Christopherson (2):
  KVM: x86: Mark target gfn of emulated atomic instruction as dirty
  KVM: selftests: Test forced instruction emulation in dirty log test
    (x86 only)

 arch/x86/kvm/x86.c                           | 10 ++++++
 tools/testing/selftests/kvm/dirty_log_test.c | 36 ++++++++++++++++++--
 2 files changed, 43 insertions(+), 3 deletions(-)


base-commit: 7455665a3521aa7b56245c0a2810f748adc5fdd4
-- 
2.43.0.687.g38aa6559b0-goog


