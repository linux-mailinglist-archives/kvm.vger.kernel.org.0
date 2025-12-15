Return-Path: <kvm+bounces-65989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 212BDCBF1FE
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 18:07:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 84063304842F
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 17:00:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58252341642;
	Mon, 15 Dec 2025 16:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FKGk2RqP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A2D341073
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 16:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765817519; cv=none; b=aK08Oy10FAXNc4k7lYXE5S8csPTb5uqdNP6a5YNoLiaSY8+TuGjgwI+8y16dgQmNnnXbXXShXdt9i+8sJBgDVPqp69R0cGstaAlzL9OL5rsMl8CdI0qPi3WD2N0ou/VoEcqkt/JXj7Kkj59GM+fe62TUb8AegFcyConV7yxZIf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765817519; c=relaxed/simple;
	bh=kU9NExtTi+tE1/KxnF4R8dBMbcDHnu2R/mzeJ9uVPQs=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=sdDtrKDHZnj2qbN3GuC0Lg18SViAFdwZWcYbfyLfp/v7WjgkjNvJu4L+kR05LXZ6B8gMj2PUNLDsxABr5727XHa9u/Cdh0IzJM81r5aIMm66Bo9Oee8gWY5SR5cj4xsdnfBF0Dri+J23LtGoTaZQYnx1lvtxBtJM0ijzPusHvvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FKGk2RqP; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-477c49f273fso43575435e9.3
        for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 08:51:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765817516; x=1766422316; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=k4K0A7tw0piWVnb/7q48qsAOBuaPwaaJnbI388C3EIk=;
        b=FKGk2RqPxZx2DRCPit+qjSg3sXkG93mnZYjXkdStQA0R6xQIzdLUTAfR2nt1KcfysL
         DGkiGOqt9LC4iLI5HUQ0pwQ4y8bvcxCtAPrB9Q5Ht3nK2f5i3kxlL2cUHyOI2opsGorY
         8gba7BjdwggyR69A+rcSPRiPgzWn+CfdMnojKcNz0kA6ZKYYclLB+WWo8LBbpBlJX7Zf
         EHwtzAbMUfl0Mu9w6OBjgRCmWQzIElg04bZuGQesTE8X0Iz9xq1X8wihKAKxTta6lgMv
         ltX3wEnml0/r4pFV6skAFndLS4PPH2j2450Vl4Mmmfxvmilg300IsblNIswZrfoxaDzB
         JzCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765817516; x=1766422316;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k4K0A7tw0piWVnb/7q48qsAOBuaPwaaJnbI388C3EIk=;
        b=qJfKmQjljRegwqsG4QKV3houd+9Zc914KlbgC8zn50u7t7efHhVuVkI6nZN7P00xQ/
         6YPWSLYap6/rBeDsPofOEfcpUC2RTmL9Fge6mBVL2wqZ+Y/ZyULuZdiWGmnK9z65pSPt
         GWdLyMg2UV0GU82YSK6SxPrfpBxzjt1IGIkI+djIN7Cqjjkew8pH71ztsfieds1YbwyJ
         gGRrtHXi8xxBECviAnr8xsHPL0UaoIHJSixaV9HZ18ACwR2IdK/qzYXk7A0//XHZU3Xb
         Od/WJhnpg+/EdfSZdB1HPdrzwjVbks97lRYYhRlRwlrPkcDKGAygjaqwjy2YEwZmoVaJ
         88+A==
X-Gm-Message-State: AOJu0Yxe3UlwE7pvzjX5AFVqqzLdj6ggHrfr/EumrvAUKs2rdVvX6qS3
	2OWe7+vxt3u1MfzpLrfTpLTXLnNnlKl2QnUHrdm1eX4djQaUd8tt0eI+lsjfUrFI86jYVjfEby3
	z/RGOSv06E2mEeM+BibUVDPVgKUDas5RDoPzkfg7izMXaHYwpa4Yn/Wef/RdieMpEmkHT3yJbMg
	P/M2HEIJ4m1Kh6QvoqpN1ALVpNgZQ=
X-Google-Smtp-Source: AGHT+IGNq+OOelN0gNt5/INxptKwNuOhXBeg9PpZV5h/y2ooLGgWvT+8nQuHYF+Ar/8EPep76SDOriq1fw==
X-Received: from wmpo6.prod.google.com ([2002:a05:600c:3386:b0:475:d804:bfd2])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:840f:b0:479:1a09:1c4a
 with SMTP id 5b1f17b1804b1-47a96378c50mr93572455e9.31.1765817516238; Mon, 15
 Dec 2025 08:51:56 -0800 (PST)
Date: Mon, 15 Dec 2025 16:51:50 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251215165155.3451819-1-tabba@google.com>
Subject: [PATCH v2 0/5] KVM: selftests: Alignment fixes and arm64 MMU cleanup
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, 
	pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

v2:
- Resend to correct partial To/Cc lists. The previous versions were
  inadvertently sent to disjoint subsets of the maintainers and lists
  (kvmarm vs kvm-riscv). Apologies for the noise and the duplicate
  threads.
- No code changes.

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


