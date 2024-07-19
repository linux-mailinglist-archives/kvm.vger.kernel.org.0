Return-Path: <kvm+bounces-21973-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BB33E937E0D
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 01:44:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D199F1C21217
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 23:44:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53DEA149019;
	Fri, 19 Jul 2024 23:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FFGL7t+9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6378563E
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 23:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721432630; cv=none; b=Q8n9+Dp/AZJHJDeyPXp0nH5Foz0zYB/w/xjzd29KKI+BD59TlbtxUJjkvIZlGNSPjEkOBKos9QCLlLScsLkwjjZz8Js20gVyZKs5uI5AeqJR/vC8JK6CdDSGGMicfzz18zkJI4RWg8o6HzJ6/D5WrsiTG/OL3yLjbRraLnGfuA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721432630; c=relaxed/simple;
	bh=BnwkD7JlA3wmXN5BrEBBPWjBLeMDRCGHGyt5jyb1mnk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=M9pyu1wzhDYVAk4uU3EyfG8ZGPO95EIuyjCSqpXb33pbjzBjL6u2Fs2y7VHDehdW0qiVvfJQJO7B6y+JO4jwYeNXEGPFdGRSq5I/LrxplUySUIA71/Ty2/h72kkAv9Xvykfe3rQ+dSWR4kC1/MV8XX35qrNImNKx0hzioQtc1Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FFGL7t+9; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fc4abd4afdso23482355ad.2
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 16:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721432628; x=1722037428; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GQ8RivBIo75BrN+Ijd6URWso23XciyBNatHrUyqY5Ac=;
        b=FFGL7t+9VHuGwz60vM9cvkmt8iT2/0KHplM4nn3QMRKn1iRi3l6s4YNxErRYvHGTHe
         i0WUcCrazE+q9CyUxstr4eGkUgD7Ljg4NRrpd2VWSspmxfjWuqhxtbD9LgGZWCkAijaa
         xcQwKJ+q4kW1uicf5PIBs2jweWsLQ79xfSlzzGh+MabaUOc3hAE3zaiu6dZtYr8Y3FJj
         A3HDlOVsVtxT6V1JjANhaGjqMRf+Jx9768hDMHRwh8YWb1wRlLSu5VGSWFXmF+AtvykC
         ZjfckFjsXtQ5HIKDqNggIQe3j2eMduKHdlP+ajAAf7THTvpxxuxfHkefw9+2ZKusUE8A
         r8eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721432628; x=1722037428;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GQ8RivBIo75BrN+Ijd6URWso23XciyBNatHrUyqY5Ac=;
        b=cbyAE2UQh6qclL0o6tSk8J4YvjzBM9rR+UO7sLmda8vwoRROVdAB0akjRmI5HT5fjL
         J4N6emzEqfnSpTRnbDQzt91aF26k83gqqR7WEVTAliQJtX1cvaWmbcpOkMmNrp3a2qMi
         6QJmcMNsFKkgz3KsHreczVv8rNhn2ftJyF0u7QXLmMJjt/xBciRgjooFZETRCiiH2/NH
         aSLImsuAwvXQa8pSa6DNhkh6EyO1uNhkvBCqLiQu4MzMFLxjBCp3lov0d73yJ+GBsuZb
         BtidewNv5gEJQ0nQ78Ckx9nWN6HdeXvlIJqqGzZHjWjfuPZGp9exQcZSVIQ/HyG9XLa0
         4UiQ==
X-Gm-Message-State: AOJu0YzEeMMhU4Qj+VKJxcHHiz+WKUfRvAXL2EoMGmeGHhX11ExdftG2
	R+ueQ9tDZSKRRCR6Nk0K6hY4098LG8e1Un/L5ARoLgs2Am849Uw9anG1sL3cIoyy8vUbn2r/R48
	gxQ==
X-Google-Smtp-Source: AGHT+IFMH72YYuQamYsgopMC2DbqPeBfYDYeUR+OeGPgfIewS1lgEjCIJMOHMg0iIcOIVdwR5UAqnDPkHPg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e885:b0:1fb:7f2c:5642 with SMTP id
 d9443c01a7336-1fd7454ba9emr958365ad.4.1721432628263; Fri, 19 Jul 2024
 16:43:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Jul 2024 16:43:37 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.1089.g2a221341d9-goog
Message-ID: <20240719234346.3020464-1-seanjc@google.com>
Subject: [PATCH 0/8] KVM: x86: Fix ICR handling when x2AVIC is active
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"

I made the mistake of expanding my testing to run with and without AVIC
enabled, and to my surprise (wow, sarcasm), x2AVIC failed hard on the
xapic_state_test due to ICR issues.

AFAICT, the issue is that AMD splits the 64-bit ICR into the legacy ICR
and ICR2 fields when storing the ICR in the vAPIC (apparently "it's a
single 64-bit register" is open to intepretation).  Aside from causing
the selftest failure and potential live migration issues, botching the
format is quite bad, as KVM will mishandle incomplete virtualized IPIs,
e.g. generate IRQs to the wrong vCPU, drop IRQs, etc.

Patch 1 fixes are rather annoying wart where the xapic_state *deliberately*
skips reserved bit tests to work around a KVM bug.  *sigh*

I couldn't find anything definitive in the APM, my findings are based on
testing on Genoa.
 
Sean Christopherson (8):
  KVM: x86: Enforce x2APIC's must-be-zero reserved ICR bits
  KVM: x86: Move x2APIC ICR helper above kvm_apic_write_nodecode()
  KVM: x86: Re-split x2APIC ICR into ICR+ICR2 for AMD (x2AVIC)
  KVM: selftests: Open code vcpu_run() equivalent in guest_printf test
  KVM: selftests: Report unhandled exceptions on x86 as regular guest
    asserts
  KVM: selftests: Add x86 helpers to play nice with x2APIC MSR #GPs
  KVM: selftests: Skip ICR.BUSY test in xapic_state_test if x2APIC is
    enabled
  KVM: selftests: Test x2APIC ICR reserved bits

 arch/x86/include/asm/kvm_host.h               |  2 +
 arch/x86/kvm/lapic.c                          | 73 +++++++++++++------
 arch/x86/kvm/svm/svm.c                        |  2 +
 arch/x86/kvm/vmx/main.c                       |  2 +
 .../testing/selftests/kvm/guest_print_test.c  | 19 ++++-
 .../selftests/kvm/include/x86_64/apic.h       | 21 +++++-
 .../selftests/kvm/lib/x86_64/processor.c      |  8 +-
 .../selftests/kvm/x86_64/xapic_state_test.c   | 39 +++++-----
 8 files changed, 119 insertions(+), 47 deletions(-)


base-commit: 332d2c1d713e232e163386c35a3ba0c1b90df83f
-- 
2.45.2.1089.g2a221341d9-goog


