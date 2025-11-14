Return-Path: <kvm+bounces-63126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A837AC5AB8D
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:13:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 806D73B7B0F
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:13:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DD4E2066F7;
	Fri, 14 Nov 2025 00:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ni24fyzc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49A81DE4EF
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763079183; cv=none; b=NPdSFq2ygoqGu5ghywqecBAfVf84c9UYS+WtoNWzJ5CHonbz9qck6ZIBu1h5Xsq2LN3YEQx313r2Ir4GiSt3zHqk6GufKFEYkL2zkHff0dpv591npxEp5deg1qxp/ClcGQkuPVAN1/TXjzBjhk4tX6/L4IZBz3Kh2SiTc6+nA88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763079183; c=relaxed/simple;
	bh=jzPOpXWQ6w28hjzAXQbN59rZG+ijeK0HxbLsXlRlNVA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ls4yPA37iaFTFHqyouASf4c6K1GooHXIidSOcQNUZyK7kn90YSWEUvghce96Rc9/wMzcXsFcFvPp/xON6Ao/I+E78KwhhvkjU7TdkXqzUhzYIiLPusRFrbnPm6HKod52OFH472+nRY/JnrAEqX3y6b+to4PvAfFUa8//gSGsVbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ni24fyzc; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-ba4c6ac8406so1179309a12.0
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 16:13:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763079181; x=1763683981; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aqPMD3V9nYkj7vgHuSnm+b/yL58/l+NqXWcrdffiuWg=;
        b=ni24fyzcSihuM4g7vddiZUfXqnwgIFTa+QfeDQAeMVSmhaBlhTVTvmImiNo6rqRrXN
         +PTldIO5FWi6VqTfcPjRF/ma5heyczNyMWq9BFtWdYQNk0nHWxc1/x6oo6X/BK0E5g15
         CgkiRs2H+NV+ojRyvybcfhtgs7eYIy4O3HZeHv3mEHTcQ9NpXbggTktSBz2QGM6KeWko
         TCQgtTFodZZL8A7yxA2UoVFAtwFWWrbpzxvdkb7F7s8i4JAr+CAvD1130lFRKkLT+sqC
         Bps17Bbpw9KaMVjiH8s1akHvsT5mlViVSlA6E9cIZcnQJwfoB1ZR3kaiJ2odN5t4yjbn
         jHsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763079181; x=1763683981;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aqPMD3V9nYkj7vgHuSnm+b/yL58/l+NqXWcrdffiuWg=;
        b=v7fmL2LqjpjWcpSL8/UQ5q1YlYIvQaMpYY92tBm1zCTbmboVhLSnmIP94bOxU+uIEy
         2Hy0/Lr1B6i7qj2EKsCYAOYSiLsRzeWbxF9or4p56GxyV/+Q/IqHvgHr1BEV54+ttzyp
         v2wCRhiU4gtSSYioyWsDWw4zgl437LC22DQS0H52WPgMBrErJr95hos+qcXrEl+XvT9L
         sMwicvKbVp7yN81DVhxafwtl23wUm3bfqTPbmfXXwBEI6Hiv+LM1luB9dpbWIr/qqy+Z
         rQLKLu8f6oT5ROM6cuMOqODHjjoraCDYuji7uxJ+gVeroGpSEOQdLSi4GOfRSYb5X05u
         2Tmw==
X-Gm-Message-State: AOJu0YwyeINurqRYcltHajoI3jxc3WoRqQhtqSKQGSN4Rrr5Ilx2wbr8
	h+B3tG1SdETPUXjn4s354Z1J1uwtWrTypyNPPKmBoTedtK4Y8CXkbFPHlNZC0zfDpe8rSAbDKE2
	P4kgaYQ==
X-Google-Smtp-Source: AGHT+IG11UZPlCGm5ad4TyUAa+dIQZ8kkCI9Sx9xIbLhfOMpRX3cOe3y3IgKU3sHQB2NjSyMFZVG9d6QM0I=
X-Received: from pjuf3.prod.google.com ([2002:a17:90a:ce03:b0:339:e59f:e26])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c51:b0:341:c964:125b
 with SMTP id 98e67ed59e1d1-343fa7326bbmr971876a91.31.1763079181115; Thu, 13
 Nov 2025 16:13:01 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 16:12:41 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251114001258.1717007-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v3 00/17] x86: Improve CET tests
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, Chao Gao <chao.gao@intel.com>, 
	Mathias Krause <minipli@grsecurity.net>
Content-Type: text/plain; charset="UTF-8"

I didn't want to miss out on the fun :-)

v3:
 - Run the test if only one of SHSTK or IBT is supported (e.g. to test
   SHSTK on AMD).
 - Rename the test from "intel_cet" to just "cet".
 - Add an endbr64 in the user_mode trampoline (the test was getting false
   passes without ever reaching cet_shstk_far_ret() due to getting the
   expected #CP).
 - Add testcases to verify KVM rejects emulation as expected.
 - Add a comment explaining the SHSTK PTE magic (I forgot about the magic
   and spent a long time trying to figure out how the user_mode trampoline
   was succeeding if the SHSTK wasn't writable, *sigh*)

Chao Gao (7):
  x86: cet: Remove unnecessary memory zeroing for shadow stack
  x86: cet: Directly check for #CP exception in run_in_user()
  x86: cet: Validate #CP error code
  x86: cet: Use report_skip()
  x86: cet: Drop unnecessary casting
  x86: cet: Validate writing unaligned values to SSP MSR causes #GP
  x86: cet: Validate CET states during VMX transitions

Mathias Krause (5):
  x86: cet: Make shadow stack less fragile
  x86: cet: Simplify IBT test
  x86: cet: Use symbolic values for the #CP error codes
  x86: cet: Test far returns too
  x86: Avoid top-most page for vmalloc on x86-64

Sean Christopherson (4):
  x86/run_in_user: Add an "end branch" marker on the user_mode
    destination
  x86/cet: Run SHSTK and IBT tests as appropriate if either feature is
    supported
  x86/cet: Drop the "intel_" prefix from the CET testcase
  x86/cet: Add testcases to verify KVM rejects emulation of CET
    instructions

Yang Weijiang (1):
  x86: cet: Pass virtual addresses to invlpg

 lib/x86/msr.h      |   1 +
 lib/x86/usermode.c |   7 ++
 lib/x86/vm.c       |   2 +
 x86/cet.c          | 272 +++++++++++++++++++++++++++++++++++----------
 x86/lam.c          |  10 +-
 x86/unittests.cfg  |   9 +-
 x86/vmx.h          |   8 +-
 x86/vmx_tests.c    |  81 ++++++++++++++
 8 files changed, 326 insertions(+), 64 deletions(-)


base-commit: af582a4ebaf7828c200dc7150aa0dbccb60b08a7
-- 
2.52.0.rc1.455.g30608eb744-goog


