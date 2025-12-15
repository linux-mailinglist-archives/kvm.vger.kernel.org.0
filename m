Return-Path: <kvm+bounces-65980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A32CCBED0F
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 17:02:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1AAE03070142
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 15:55:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6068230BB88;
	Mon, 15 Dec 2025 15:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fQqzj/cB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916B530F531
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 15:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765814147; cv=none; b=RspjF+fhWfjiUG/EHS0ADQ4jmW1Ml0/PONsmPC6BQKt1OqP6XMADdozwx98fA4VPBDerSuT4RFWJ2wTvmErOf+27PQjIJ00t9sLaGkbewgJCjP/QlD33u/JwP5PFsvEnHfynyAEOX2c4eoR/Ci+NNRdLe6BjkDHHex6SzpzOZEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765814147; c=relaxed/simple;
	bh=QLYTCjX2EZ84iw7nVlOSDJ86AmUekPGCFfsO1BJfBhI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=R0HZkQDfaQZAo/3tn7PNMZsuz8kU5csl/dHF/nFhkN4c5BGNkCWPwn91mIdO2xGJq3+LC+rSYpbtkelXa2uah/P+PNpnOY0aPPL1ln6mmEMvFUqf8udl3MwgFVGi1kIj4yZtyX9cB+pPMpdGLed8GcTKMWjzXSOd7pFQL9wEy4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fQqzj/cB; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-430fb8d41acso508530f8f.1
        for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 07:55:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765814144; x=1766418944; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bw36UYHiJwTnMGEVt20djLkGP5pKUV/ucx4MipOtVRg=;
        b=fQqzj/cBcSf/atyFBlbzgifsWOzxlMREZdGYiGtiUOcb31A121dTfAftKqvhjwjpCf
         ZeCvFlTTqxZmuKLMKHNcFkjSZA0m3KPTBr+zRgmNXKLRsUaFthCevOuLpPinRXXSjPvi
         +mlbQmukxhAztjo/zmQdlM5X6Bhc1490v+HqDJLQ2W7my19UOGTFxsNgd0VHfYqTnHmg
         t5Gaq1cAuNC3dp9WAPebGHlHMuDdRQQ7lLXE1nN9FfpnlDkixk9/mrXUC2kqu/621M2t
         IRbHL+cUHPQNi7kOkrbYhtix7E9pAP73J9qfACl0OONgf9UNwh1DjaMInPSSykpoF05m
         SQZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765814144; x=1766418944;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bw36UYHiJwTnMGEVt20djLkGP5pKUV/ucx4MipOtVRg=;
        b=c5i+QvnQ0AXvJVUKUFae/Wr00iCXE40qy80dSfN/ymLGRpRCNo93NluEzJzKFTf0jI
         QBsDkFzxOmqTaBEGvSx7PLz88ATt1g/YyHXM5XDIY9cJSQJ1fP33NGfHcuZ6EXZ1jZEC
         1QFV+2tntqQOzL7o7s0epOxqRuc7LoNjQsSrki7ISZOyKcfZBaefwCSO8og/XscdDcJ3
         vqqbUpYsA3V2ryK7LMiTWHr5l76f32ZMbR1pF+ruRKzyNUntHplKocnD6JkRZMVIZnWL
         lX1DDLRndfrEbOGWeKuVHb7IJs7SQScdJMoL0gPyrgjpxzpPyOMSFsGEPGF5Jg7lJ3It
         QUQQ==
X-Gm-Message-State: AOJu0YxB9zwAkOSKuTGxxbOuTLvMAgcvER8rG7AB1fa1T601NKYBK0JT
	CmMf9snGZRr88s0Dt3Z/iPXSLt2C5trbMnF8AzlNeDXnvolfVZaob+z8/0B9W1KFiWuXXfbZpWq
	KM9DVT3+yntQim/EVYhn7HNt1B/QgqPo1CPrzmKq2m9i0/dXC9pKBieQQP7hP1iVk3xfj+Zko4r
	MUSYHIRuSMd0T5CJk4a4xOx6SO7G4=
X-Google-Smtp-Source: AGHT+IG6+F6Un10L9/EjIC++FIOUIVfTuu7QmmdObJt5Z2W5GEqSeoJWiEHDWPn2o3uOCFFO3GyVjgiaTg==
X-Received: from wrbee4.prod.google.com ([2002:a05:6000:2104:b0:42f:b38a:60db])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2303:b0:430:fd84:317a
 with SMTP id ffacd0b85a97d-430fd843502mr3958203f8f.38.1765814143740; Mon, 15
 Dec 2025 07:55:43 -0800 (PST)
Date: Mon, 15 Dec 2025 15:55:37 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251215155542.3195173-1-tabba@google.com>
Subject: [PATCH v1 0/5] KVM: selftests: Alignment fixes and arm64 MMU cleanup
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Cc: tabba@google.com
Content-Type: text/plain; charset="UTF-8"

This series tidies up a few things in the KVM selftests. It addresses an
error in memory alignment, hardens the arm64 MMU configuration for
selftests, and fixes minor documentation issues.

First, for arm64, the series explicitly disables translation table walks
for the unused upper virtual address range (TTBR1). Since selftests run
entirely in the lower range (TTBR0), leaving TTBR1 uninitialized but
active could lead to unpredictable behavior if guest code accesses high
addresses. We set EPD1 (and TBI1) to ensure such accesses
deterministically generate translation faults.

Second, the series fixes the `page_align()` implementation in both arm64
and riscv. The previous version incorrectly rounded up already-aligned
addresses to the *next* page, potentially wasting memory or causing
unexpected gaps. After fixing the logic in the arch-specific files, the
function is moved to the common `kvm_util.h` header to eliminate code
duplication.

Finally, a few comments and argument descriptions in `kvm_util` are
updated to match the actual code implementation.

Based on Linux 6.19-rc1.

Cheers,
/fuad

Fuad Tabba (5):
  KVM: arm64: selftests: Disable unused TTBR1_EL1 translations
  KVM: arm64: selftests: Fix incorrect rounding in page_align()
  KVM: riscv: selftests: Fix incorrect rounding in page_align()
  KVM: selftests: Move page_align() to shared header
  KVM: selftests: Fix typos and stale comments in kvm_util

 tools/testing/selftests/kvm/include/arm64/processor.h | 4 ++++
 tools/testing/selftests/kvm/include/kvm_util.h        | 9 +++++++--
 tools/testing/selftests/kvm/lib/arm64/processor.c     | 7 ++-----
 tools/testing/selftests/kvm/lib/kvm_util.c            | 2 +-
 tools/testing/selftests/kvm/lib/riscv/processor.c     | 5 -----
 5 files changed, 14 insertions(+), 13 deletions(-)


base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
-- 
2.52.0.239.gd5f0c6e74e-goog


