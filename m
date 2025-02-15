Return-Path: <kvm+bounces-38254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EEDDAA36B11
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:36:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5FF567A47FD
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:35:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82F5A7DA62;
	Sat, 15 Feb 2025 01:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pTUg9GHT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55461E56C
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 01:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739583399; cv=none; b=kZaKtgkofytzWL7IQt3TvOi48wEVNxf2awy4Zk1QccpzLN2LfVgcJxX+87ufY4rYy/jBOEC3GCKGUFC+vsZchxtaP1Hen8TTHbYXDjBkwMrtOu8/JWb8GktIEPG42aIXpIm2zvfxNO1c7f4LSgztwDpH0Gtk6uo1p1LSCHSoIDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739583399; c=relaxed/simple;
	bh=klNLW/VAUcEBXq+tYmuNl0L3u0Na2gR5/mHGgd9oQgA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=TCbKR9zB4aj9oVXehkLfpYmOMOUqKlTnDCdvY3+wILB9ZhB9FH/Z+e7e7GdosAyJClGtSgAxpqk0U0cOjSvDUjngfWcq16ZH4dkZ9U6chAkWy/SorsQ5cMewCzI4W60AcZZ52ZukrwWLr6QDeAEbOTyKkMu0dw7R0Rr547xq0fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pTUg9GHT; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-22109f29c99so77335ad.1
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:36:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739583397; x=1740188197; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HoNaWrGZbTRpWvamXHjY3yC2u6p0ATra9MtPMYaXqu4=;
        b=pTUg9GHTPCeoQWulsVZ2QmnW2pRu5x8I0y/un9qCNMDfQcwYXkd87Q9mjVlydlg4Tm
         cm1CIW7C6E0/8OICj0GhbCICGna3JXfB9pbeJ+6LS5lB7AIMjZQI6QCskKNC6CcKAGw/
         vr0lEITCWO2cY9zPn2DN2+2cer1u+RapEjkDtESiayY41vwBUcV4XkxkbULNP4LcQdra
         hJnPT+ldZQ74wcoUL7AEToANuCjY+a7wQ0VTD7PIBxkmAdjrcNZi6glbWCNWT/7kt8JY
         f51UrFwglWyz/CPQNeJEnPFYztH7tAb9+SVDwZlCweVhkwdBjddOYZS7YZTzgocCgNdo
         WNLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739583397; x=1740188197;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HoNaWrGZbTRpWvamXHjY3yC2u6p0ATra9MtPMYaXqu4=;
        b=Ed5txSVDJdhRUZbo7uvIkPmHsh4CxLN9YdihDHPSkPHPExczIlWaMzng/meFopaQIZ
         CJBVSsh1nxBlwJJORzRNDnzV1OR7xlNsCBGU5Iw9htbjgarkUyvvmZzmrnPP2wqIpCUM
         2BVlCGkDNa7bdA2pgDC+IA8PBsKUZHoNzakBEEmfFtYJjDs1QWrAHB1ijI2v44Yn75xm
         rzIiAkBpN20bkqPZMqTnNb21+Oz6QGYQa+bKDcHK+l99lwifhSipUVlkyKMJC529TBI5
         hD/DyU0bkCwzL0vwl4ysMhoBp0MeKtGwiAR2Kr299bxYAf9oe5U+sirlIm7sTPpagTir
         r/Yw==
X-Gm-Message-State: AOJu0YwaRy/v96QW4euMvJhkz1S3Sy887jy1rudeGz37xpWaVV/U8qq+
	cz02RGntepZ+SGBtRB9w/RWElrqH83XkbSMLhFA9uZVPW8xYyGcul7/Yw4ySeIVPLJ5DHsk8xcE
	LrQ==
X-Google-Smtp-Source: AGHT+IEn0UkBNfTe7rc4eTUWU6M53G/ocU5HyE4lgsHCVTlQCO3Jr6FgDib5H7lPwbdcXFIghNNTTFbwFZQ=
X-Received: from pjbok16.prod.google.com ([2002:a17:90b:1d50:b0:2ea:46ed:5d3b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:41c3:b0:21f:ba77:c45e
 with SMTP id d9443c01a7336-221040d8192mr18639915ad.45.1739583397594; Fri, 14
 Feb 2025 17:36:37 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Feb 2025 17:36:17 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250215013636.1214612-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v7 00/18] x86/pmu: Fixes and improvements
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Mingwei Zhang <mizhang@google.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

v7 of Dapeng's PMU fixes/cleanups series.  FWIW, I haven't gone through the
changes all that carefully, I mostly focused on the high level "what" and the
style.

This blows up without the per-CPU fixes:
https://lore.kernel.org/all/20250215012032.1206409-1-seanjc@google.com

v7:
 - Rewrite the changelog for the patch that shrinks the size of pmu_counter_t.
 - Cosmetic changes.

v6: https://lore.kernel.org/all/20240914101728.33148-1-dapeng1.mi@linux.intel.com

Dapeng Mi (17):
  x86: pmu: Remove blank line and redundant space
  x86: pmu: Refine fixed_events[] names
  x86: pmu: Align fields in pmu_counter_t to better pack the struct
  x86: pmu: Enlarge cnt[] length to 48 in check_counters_many()
  x86: pmu: Print measured event count if test fails
  x86: pmu: Fix potential out of bound access for fixed events
  x86: pmu: Fix cycles event validation failure
  x86: pmu: Use macro to replace hard-coded branches event index
  x86: pmu: Use macro to replace hard-coded ref-cycles event index
  x86: pmu: Use macro to replace hard-coded instructions event index
  x86: pmu: Enable and disable PMCs in loop() asm blob
  x86: pmu: Improve instruction and branches events verification
  x86: pmu: Improve LLC misses event verification
  x86: pmu: Adjust lower boundary of llc-misses event to 0 for legacy
    CPUs
  x86: pmu: Add IBPB indirect jump asm blob
  x86: pmu: Adjust lower boundary of branch-misses event
  x86: pmu: Optimize emulated instruction validation

Xiong Zhang (1):
  x86: pmu: Remove duplicate code in pmu_init()

 lib/x86/pmu.c |   5 -
 x86/pmu.c     | 423 ++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 342 insertions(+), 86 deletions(-)


base-commit: f77fb696cfd0e4a5562cdca189be557946bf522f
-- 
2.48.1.601.g30ceb7b040-goog


