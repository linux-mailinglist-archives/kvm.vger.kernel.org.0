Return-Path: <kvm+bounces-32586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D2BCE9DAE6D
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 21:19:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 98FBB281AA7
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 20:19:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35107202F87;
	Wed, 27 Nov 2024 20:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="whpORLD3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A3F2CCC0
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 20:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732738782; cv=none; b=lHy3LC4/vBJHExpFT9rodKN9U+q7x41Sn6gxBKZuW6W9RlJl7pBvEkJ0WeW7E7sgcKiQDig0Tnq28vj3bH2HB+m6PNsIaOYN/k0RjHjzGvZNRTREnlUImmmmoCj0BtX5GtaU0RIZWWgUj1DOCO6G2EtxcCrr4weuRogcEhj4eX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732738782; c=relaxed/simple;
	bh=cZIr0NX9dk9LuRpx9zaviH35JYPFTsqln4N8+nEEr48=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=SyTtasYRONMTqsQtyt4zmvYiOsTViA9VGS7W8wVcTjs3K7P9VhnWvyTcLB2AnnVKZl8IfbQgqJMZUNg5CuooXS4oGbMdqhpYnvW5IT9HYpnat3Py7XvFjETKvwikJbfBke9m2eOz4e2B0+IlbJs73m0p9KVyBHusMEYJ6C4iZAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=whpORLD3; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2edeef8a994so142330a91.2
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 12:19:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732738780; x=1733343580; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rT4zjpukNMrZ59TBU0pFDQFdJ4yGdJlRWZyR3xY1kfk=;
        b=whpORLD31XahUIV8t+jqg/KrPjwbfVw0mBQ+qayCcZBwnwt5eHS+G6NElT3f1p6uOd
         7qEZLNeWojpLc53zqhtgWCi2XzbAjnNfV/DH2CeWPfTsz84/gMuzdQupfl+cNU7fowRy
         3H/LkiPjX5eKudl+2nJBmiUbvH0FXkAcO3h4gRJ7097EuKIPWWi5ivZiPqJX8uuTm+YS
         r/ZVC2I7VGJ3sk8M1nPEyFQPIsniopxEo2ajZSUFF/rDfC7cPIBl7WBxfk9ezCXq3spD
         yTD1WjZQdjJSd7AR0pJGvIiHQ7quPstFInycfLD76yw1k/fvz6dBjF2eIdnsGls3hnmH
         vOfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732738780; x=1733343580;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rT4zjpukNMrZ59TBU0pFDQFdJ4yGdJlRWZyR3xY1kfk=;
        b=RKnMuOyarH1xUxr0stHuVa+4ZWdNyeWuKsuKOt9KpIZJExiy4KtlloHLhvf2B7tjYr
         3RDS0ifK5c+LYzkT38ClIEQx73pA5QVoOwbti9Qn6ypjNMrHrxlw6DzEDBGD6MeNYaxO
         spbjne58IKDD64XHtcmqQC4jffdnUFruPqEBPzSxQiVWAICGCurpoH8L1quACVz429gW
         DC3Gnl+w+RbqALdTkGKscpOs6Pfn9+W0gnwWCviW8tJ2LgxIORnTE9DftbNFo2HiHsk+
         TVNQLym+VDACfqvFQ7i2bXlvkKNXLDz1fmnFNZsEZvVy14Wqr/REeJnKo7Xz8D1EvDmJ
         KVIg==
X-Gm-Message-State: AOJu0YyIrp7nnjpJOxUKJV0uj4/zBCtmBOvOXcTqF61/RHcMjI6+bWVh
	iqchoiCJFNM/OTstrK99SISpBMXuGsV8yx8k0/kutjQVOtkVxzikpfhI0sKtCSVwviq2j9GBhv1
	moRWjupS0guNDOZkpqG/TtG0XcIYDjMaJclZ+DgMBZZSHzRXIqYrFFcLy0pa9gaMg6c1c/7sNUt
	QnZ7QpjNeSxPtw+Z7PLxMRUtNVturdHlcRnnx0Lwo3QueAxeMVpg==
X-Google-Smtp-Source: AGHT+IFF9SISsQin2cXQYuvoKGPLVcSzWy4x+OmruqK1X9Zi30JH+zqeb4eAp9OwVYA5R2/bkKasEdnuhztwPWNZ
X-Received: from pjbsw6.prod.google.com ([2002:a17:90b:2c86:b0:2ea:39f4:8c56])
 (user=aaronlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1850:b0:2ea:3ab5:cb9d with SMTP id 98e67ed59e1d1-2ee08e9928amr5782768a91.8.1732738780231;
 Wed, 27 Nov 2024 12:19:40 -0800 (PST)
Date: Wed, 27 Nov 2024 20:19:14 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241127201929.4005605-1-aaronlewis@google.com>
Subject: [PATCH 00/15] Unify MSR intercepts in x86
From: Aaron Lewis <aaronlewis@google.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com, jmattson@google.com, seanjc@google.com, 
	Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

The goal of this series is to unify MSR intercepts into common code between
VMX and SVM.

The high level structure of this series is to:
 1. Modify SVM MSR intercepts to adopt how VMX does it.
 2. Hoist the newly updated SVM MSR intercept implementation to common x86 code.
 3. Hoist the VMX MSR intercept implementation to common x86 code.

Aaron Lewis (8):
  KVM: SVM: Invert the polarity of the "shadow" MSR interception bitmaps
  KVM: SVM: Track MSRPM as "unsigned long", not "u32"
  KVM: x86: SVM: Adopt VMX style MSR intercepts in SVM
  KVM: SVM: Don't "NULL terminate" the list of possible passthrough MSRs
  KVM: x86: Track possible passthrough MSRs in kvm_x86_ops
  KVM: x86: Move ownership of passthrough MSR "shadow" to common x86
  KVM: x86: Hoist SVM MSR intercepts to common x86 code
  KVM: x86: Hoist VMX MSR intercepts to common x86 code

Anish Ghulati (2):
  KVM: SVM: Disable intercepts for all direct access MSRs on MSR filter changes
  KVM: SVM: Delete old SVM MSR management code

Sean Christopherson (5):
  KVM: x86: Use non-atomic bit ops to manipulate "shadow" MSR intercepts
  KVM: SVM: Use non-atomic bit ops to manipulate MSR interception bitmaps
  KVM: SVM: Pass through GHCB MSR if and only if VM is SEV-ES
  KVM: SVM: Drop "always" flag from list of possible passthrough MSRs
  KVM: VMX: Make list of possible passthrough MSRs "const"

 arch/x86/include/asm/kvm-x86-ops.h |   5 +-
 arch/x86/include/asm/kvm_host.h    |  18 ++
 arch/x86/kvm/svm/sev.c             |  11 +-
 arch/x86/kvm/svm/svm.c             | 300 ++++++++++++-----------------
 arch/x86/kvm/svm/svm.h             |  30 +--
 arch/x86/kvm/vmx/main.c            |  30 +++
 arch/x86/kvm/vmx/vmx.c             | 144 +++-----------
 arch/x86/kvm/vmx/vmx.h             |  11 +-
 arch/x86/kvm/x86.c                 | 129 ++++++++++++-
 arch/x86/kvm/x86.h                 |   3 +
 10 files changed, 358 insertions(+), 323 deletions(-)

-- 
2.47.0.338.g60cca15819-goog


