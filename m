Return-Path: <kvm+bounces-35888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ADB46A15A12
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 00:42:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4AB017A4F29
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 23:42:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 874F81DED4F;
	Fri, 17 Jan 2025 23:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xp4AkVxU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451511DE2A6
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 23:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737157327; cv=none; b=YGoGn8fuv+ZXpl5syvbgVXpjfmLcjmsQeDZBT8KFTBMPEJQ7JmYWn3Y7EceyRWfVerxqT8aHk2uhJyGFaTqRtRFSMM/y29FOTVuKQ3KyZIYM9TS1pJVE3g6S80qMo1db6RxzXrYuN6PJJ2OhpUQ69UftPzlC3U577DfkiF7j/LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737157327; c=relaxed/simple;
	bh=rStiQ/fccUcpctaXQAR/pzkKBByUunJBOB9dCsHBCK8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=lwh/o7+JZDlpg5LaGmltac+qQMo2owPkMnzkQ2krfELRQNcI9gkNfJC2KOhfn1P5TEnvb4UQpNNqq4R/ogmkcbu+LYdH32WrWNyzdKJlAhFUfEoP/0fplz39kePIhdwSjI0v5Wafs1D5lu/iXs+p74R6ku+F+buK66OOnsaw7wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Xp4AkVxU; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ee9f66cb12so5243140a91.1
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 15:42:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737157325; x=1737762125; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Suwwci6Z3oSWd93u/s2RL+pxTNcRUFQgijnV23Hb+68=;
        b=Xp4AkVxUqFo1GPOe5LOI3f13UMj2CzaNMpNZAhGrIAGWg35H6FM/MHaBZ/qdxim/iA
         JVgNE8GGqzhdgMtcwR2C5l91y7hzgH0Ac6P3DcgxQjaKwt/2n9Qy0ac5pMC2QCbcTjKs
         HBvNErvDsu+DgKfC3VQd0UkVNDsQwUUBGoj5gVMRut39AblGRewDBT7+HVs62XbfxVmV
         QMTPWRKKBs/RcAIOqRy0im7ioZw8HNlz8IDf1pl86w2XcONy1Mf69H/XzdlkAdVo/RAa
         dVQE3JpO4fZ3ZQ1XbGV8v5+Npr/Y+Mug0bFyL8mskDe55FFfGMmJ8T4/xvE2E/TfAib9
         i8nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737157325; x=1737762125;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Suwwci6Z3oSWd93u/s2RL+pxTNcRUFQgijnV23Hb+68=;
        b=X9PiOghC/sTmRoeDcFQlWUo7HoAxFa5RSBRLJG9eNa200/Tp6PeGoKCtQ04a0wsZxa
         Y9rGi5t2ddhNhzjnIYliXM3HHZppcRvzEnmHL9W8vuc/dTRSkowZZW5lbcY+9g7xD69J
         EdFvOGPUB20FIyMPNmqqabNNioNPKROdYWsnLcXuch/ntp/w26d23ylEs4fUDQjsmMs3
         9DUeGL/SCIPL5PWbn89QFPytx6EpzrOPi4fqdGCh/AHJox7gELAAvfYwQNmojFC1QAEO
         Yz8e70w0HAHo7So29MhBCq+4o82wRMwqn2d+xasJrGlnWYJU8CFR288KD1rHd63tq2Pj
         ZFhQ==
X-Gm-Message-State: AOJu0YzOdH73fPMwlo6MUt9aElsHWQxgBhySCH/eaH6smw7x/lZB7521
	wTetmfR00lf1ulpdK+KyXbDgctGb8dp3eZH639hQ9M4UJRrYMRWqk3GuSsj0rkAIPDm52YK1u2a
	Zfw==
X-Google-Smtp-Source: AGHT+IH3sThoJCsgXeUwF6aK+fofCIh4K84bCruncAmwnf/C3ocp5JI8pkKhKkdSYsK+4GwI9o+vHxHS3oc=
X-Received: from pjwx14.prod.google.com ([2002:a17:90a:c2ce:b0:2ef:d283:5089])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4d01:b0:2ee:94d1:7a9d
 with SMTP id 98e67ed59e1d1-2f782d73246mr5571872a91.32.1737157325597; Fri, 17
 Jan 2025 15:42:05 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 Jan 2025 15:41:58 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250117234204.2600624-1-seanjc@google.com>
Subject: [PATCH 0/5] KVM: selftests: Fix PMC checks in PMU counters test
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel test robot <oliver.sang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Fix a flaw in the Intel PMU counters test where it asserts that an event is
counting correctly without actually knowing what the event counts given the
underlying hardware.

The bug manifests as failures with the Top-Down Slots architectural event
when running CPUs that doesn't actually support that arch event (pre-ICX).
The arch event encoding still counts _something_, just not Top-Down Slots
(I haven't bothered to look up what it was counting).  The passed by sheer
dumb luck until an unrelated change caused the count of the unknown event
to drop.

All credit to Dapeng for hunting down the problem.

Sean Christopherson (5):
  KVM: selftests: Make Intel arch events globally available in PMU
    counters test
  KVM: selftests: Only validate counts for hardware-supported arch
    events
  KVM: selftests: Remove dead code in Intel PMU counters test
  KVM: selftests: Drop the "feature event" param from guest test helpers
  KVM: selftests: Print out the actual Top-Down Slots count on failure

 .../selftests/kvm/x86/pmu_counters_test.c     | 143 ++++++++++--------
 1 file changed, 83 insertions(+), 60 deletions(-)


base-commit: eb723766b1030a23c38adf2348b7c3d1409d11f0
-- 
2.48.0.rc2.279.g1de40edade-goog


