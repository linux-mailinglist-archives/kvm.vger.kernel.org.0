Return-Path: <kvm+bounces-48589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ADCE6ACF7C3
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 21:22:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 036983AC075
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 19:22:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B158027AC24;
	Thu,  5 Jun 2025 19:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xlNQEyEm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CF01EBFE0
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 19:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749151354; cv=none; b=Pl42TLMPXYY3dlD8irNgLOYJDcHHO+8zLFpQ50AM8S8xJGoyfTk+uHoXdTiU638ZQr2iYYqH02sPfdS9F0WSNJtEjNhUeIwQTftgz2jnn4fKyikc0uYBMTRu+FpLIEFUyObw926B0rXPFw/h3lG5hMxAMsJ6qsjQzrSNXsO7DJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749151354; c=relaxed/simple;
	bh=R0T2srh6tblIdyflhQw11IZqxNpm/+qfBxHuBz/bYJo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Sg/9Jf77zJH58+pTv/PbmPyf9Y8MZRzFynuhpD+zDBsM06+hTbDlB4PDl39iSpspZwi2hu3sc++sIMnWV7Z5UNTEBH4iiPDwfzy94LnVW19SCvZb5I7tQC0x5A2MQBvjFacaYtZVfXN7htAEK1nEdSsIG0I5oMvAz/ItyEKQZNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xlNQEyEm; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-311a6b43ed7so1249388a91.1
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 12:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749151353; x=1749756153; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PHrjs+J8yXgU/ygD3drCkI/ekut6Ktm3dxm3sImbO1Q=;
        b=xlNQEyEmh3DoymgX/+/uVj6mteF1NnJ58U3A7wUhska7WgfBVeSstQNMs98/iBC302
         sbtYJVHpEEGmUO1KDyxiJ3BHicxZ+2rntAI2fWM6XQxkWGYZc7zlfDAum0X50LY+7gjX
         6aMdm61QvBR+qYGnd7pPYURhrjkO18fNx7DvwJDdlwsf/4TYroQJcdTXn67gkIQ8vlD6
         xEIW+icD5DxaP5sqdZl3UuyrUI4jIzMO9cOYjnyW6POAqmwQD3RAoal5JqUS9VJn7tUW
         kCOmDlh+TPsZOCQF8AiMuUZQvAerveyfAKMV6/23VzoHTtVS/+e36Ca1hTg4VfqVV2WV
         RFVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749151353; x=1749756153;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PHrjs+J8yXgU/ygD3drCkI/ekut6Ktm3dxm3sImbO1Q=;
        b=O+7bkttVegB0a2/Q0esmYl8VZQRPXAOon5eva5E9HUwLhONrYl78QJc13BNfzKnBIv
         kGG+3htvJylYA5x4Yujf+8RrS7duU5UGIJ8MO/O1AyTEw4Z08f4jLpP4r71aOQkgL6CL
         pKC6TB3P6+d/KRoqZY6oZmMlaihisLBD1d9q5LhaiU16YVCnNCrNYK+g3GkjZRG51Suz
         Ag4VVozUI0eTPjxmoJ67PR/TEnzaYDPrDPIKvdk4xcJ6j6BMsxGMJAjPs6+5M2ldY34C
         zTa4xmASORbC72QkacR/Gf43guz/l8goIE/6iUP5zbSi3R8/MDxlNVduG0NuRa+vR7tB
         folA==
X-Gm-Message-State: AOJu0Yx9WUnx3Dq0Im9b+3kvmr0jj+Mx5NnDpkGecoOgm+P01c38RpnL
	yRWevQYExBETgpSLgQZr5H+h5Be0S2lc+vEI08jN8l6waivJORy8XzVENJfqBT+PRq9SHCq4Wlq
	xSpqtmA==
X-Google-Smtp-Source: AGHT+IHxGv9NRD6zI1DFqXG/s6Kukc3jSqYXVVCovxqIX+DI61soYindb3ydWPxwq7n/PeO6xaGzKm5pKuE=
X-Received: from pjj13.prod.google.com ([2002:a17:90b:554d:b0:313:551:ac2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:38cc:b0:311:af8c:51cd
 with SMTP id 98e67ed59e1d1-3134740bc52mr1411981a91.18.1749151352743; Thu, 05
 Jun 2025 12:22:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  5 Jun 2025 12:22:18 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250605192226.532654-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 0/8] x86/svm: Make nSVM MSR test useful
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Fix the nSVM MSR interception test to actually detect failures, and expand
its coverage to test:

 - Out-of-range MSRs
 - With all other bits in the MSPRM clear
 - {RD,WR}MSR with interception *disabled*
 - That L1 and L2 see the same value for RDMSR when interception is disabled

v1: https://lore.kernel.org/all/20250529215713.3802116-1-seanjc@google.com

Sean Christopherson (8):
  x86: nSVM: Actually report missed MSR intercepts as failures
  x86: nSVM: Test MSRs just outside the ranges of the MSR Permissions
    Map
  x86: nSVM: Clean up variable types and names in test_msr_intercept()
  x86: Expand the suite of bitops to cover all set/clear operations
  x86: nVMX: Use set_bit() instead of test_and_set_bit() when return is
    ignored
  x86: nSVM: Set MSRPM bit on-demand when testing interception
  x86: nSVM: Verify disabling {RD,WR}MSR interception behaves as
    expected
  x86: nSVM: Verify L1 and L2 see same MSR value when interception is
    disabled

 lib/x86/asm/bitops.h |  86 +++++++++++++++-
 lib/x86/processor.h  |  12 ---
 x86/svm_tests.c      | 240 +++++++++++++++++++++++++++++++++----------
 x86/vmx_tests.c      |   4 +-
 4 files changed, 269 insertions(+), 73 deletions(-)


base-commit: 72d110d8286baf1b355301cc8c8bdb42be2663fb
-- 
2.50.0.rc0.604.gd4ff7b7c86-goog


