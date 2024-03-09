Return-Path: <kvm+bounces-11436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4990876E9B
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 02:36:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 656762878B8
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 01:36:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80A6D17545;
	Sat,  9 Mar 2024 01:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X6U0MnFs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C72211187
	for <kvm@vger.kernel.org>; Sat,  9 Mar 2024 01:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709948205; cv=none; b=B2DXbMGPVRl/Z3xL4Uf3N9fzHCHUDKUqON9fOWxjATNcskG7Pgat2tN8RqbBoSzZmLsE1SzpwnM0g++1qdnptJr5BiR7qwqgIZ4PEtwVLrZFfX76NOuQVNwEm4n3w+CFQVuSHhvA/gmhlYnc+jm3vinDtr/j6bIdFFEZwTT3zLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709948205; c=relaxed/simple;
	bh=KNAhwOBL8cw8T6ZXppejn/QBiDWrlTqw/s/Csa4uJDM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=fvLd5AeQNzJpZ49P0WPddPvRFeuKNrRfwEvkVRxVVeBPJd/wa0ejhScInMaTUaK0WDuBWIidsLuoqc6RJdcTnS2DLSME/GOMAJdclTMjjvDL81/cUBL2wTkPNdINzM4WTVfF5yExTIuL5SYQ6WAyciSOZFmPpsvul9rTZW6GAeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X6U0MnFs; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6e673910497so550177b3a.0
        for <kvm@vger.kernel.org>; Fri, 08 Mar 2024 17:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709948204; x=1710553004; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bZoHkUtSLo4x8GP9qkez26jA5e/nyhOVKeVVLDBsGLg=;
        b=X6U0MnFs8be3Ny6CTWgAFNDnYe1pHGmbSbgNO35iJBkgn6+INrAQ+sV5hNC5xvv0kn
         uznpg3T4TCGmTbsroBxnglj753clltYUclxpNh3HzsF7n64uMTAz7IDnGLpfiCb0IqBe
         qdaNbRVSjNsSOYoM5nGW/wq0iCzJBD+wKYctAgcuKMO/DPr6IRyukyjZhVIVGX5Chp8Q
         sthisM39MylnC/d+gmzaTA7TdCv8K0wsKutwXS5Nr4fYSwJFQNYQN06E+NWGpMexj+Vh
         po8P2Tm77I85P/Typ04YM3PwmPNHNwuscSh8NiM4tXktel+hmZkDJ4DldK+8cFKJJ05y
         8shg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709948204; x=1710553004;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bZoHkUtSLo4x8GP9qkez26jA5e/nyhOVKeVVLDBsGLg=;
        b=M82Ugv9JNDS6f0g/DLOpnxWB4CnKrUQmu4OkCJ82mN8CJT6dT+1IZ/2oNdwPrVazjm
         sHWWOHw4v6Yx4HOOUDes7azGVY0H5JUzBeIyy5FZjJ9ZF13ioKqmlcQE7TMeJ5LceUIP
         turDd2qQjiyyRhAKvcfpAAOoFd2Xl6MqKKe7XGNO2kBgT0GUSAwtN0v7IXit8/Lezz/z
         O0TOpdNKBMLPHkQH+83xmvHo/w0CIZ3oJ/FaLezcZldSv3I/PYyXr2iEafaH00FYuRpl
         JQ589fnNPvXgybfzQk3tN5/XQ8tO+NHRjJwLy8txEPUBFZk0TCWF5RwOCe/D4LSSul/k
         YI8A==
X-Gm-Message-State: AOJu0YwRzon61tqztcUfMUbLVE0He0H74I/4a6oZcMuiQno4ymeeEAAz
	MrkpMIKtN7ZWDoLC8uz87WUnSCV6qmgXtleC2RzsIOu5skNt5EALTCotfbBA/jxAURiYcqw6ZAh
	l2Q==
X-Google-Smtp-Source: AGHT+IGuMWGprHd2f3WGnkKUh0RfOvaJp2hNLz6lArkJPZN/8TUkyANMs0O8AsihYk8e+SL2JDrTH3IviPc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:c95:b0:6e6:6dd5:7a40 with SMTP id
 a21-20020a056a000c9500b006e66dd57a40mr53380pfv.0.1709948203703; Fri, 08 Mar
 2024 17:36:43 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  8 Mar 2024 17:36:39 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240309013641.1413400-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: x86/pmu: Globally enable GP counters at "RESET"
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Babu Moger <babu.moger@amd.com>, Sandipan Das <sandipan.das@amd.com>, 
	Like Xu <like.xu.linux@gmail.com>, Mingwei Zhang <mizhang@google.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Globally enable GP counters in PERF_GLOBAL_CTRL when refreshing a vCPU's
PMU to emulate the architecturally defined post-RESET behavior of the MSR.

Extend pmu_counters_test.c to verify the behavior.

Note, this is slightly different than what I "posted" before: it keeps
PERF_GLOBAL_CTRL '0' if there are no counters.  That's technically not
what the SDM dictates, but I went with the common sense route of
interpreting the SDM to mean "globally enable all GP counters".

I figured it was much more likely that the SDM writers didn't think
about virtual CPUs that can have a PMU without any GP counters, versus
Intel really wanting to set _all_ bits in PERF_GLOBAL_CTRL :-)

Sean Christopherson (2):
  KVM: x86/pmu: Set enable bits for GP counters in PERF_GLOBAL_CTRL at
    "RESET"
  KVM: selftests: Verify post-RESET value of PERF_GLOBAL_CTRL in PMCs
    test

 arch/x86/kvm/pmu.c                            | 16 +++++++++++++--
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 20 ++++++++++++++++++-
 2 files changed, 33 insertions(+), 3 deletions(-)


base-commit: 964d0c614c7f71917305a5afdca9178fe8231434
-- 
2.44.0.278.ge034bb2e1d-goog


