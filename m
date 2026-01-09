Return-Path: <kvm+bounces-67536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CEC07D07C58
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 09:23:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 90AB53047913
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 08:22:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E76431691C;
	Fri,  9 Jan 2026 08:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sqdDrZVC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36E82ECEAE
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 08:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767946952; cv=none; b=joylDg6Bil6hJAlK9w9jk+Mdi6aKUUD3UhW9C1OUjnvLYl3ff8atu9SUe8zXkSu1kd0oTjhnC7VO8jkD3gJXt9DdaVR68zFDBIGzP21WPq5xlTzBNMKy6v3MnFSgmZjzgMBxUa9JnXVyvBKFmE8A4Ugp11kpOyrvMxXdGipWFSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767946952; c=relaxed/simple;
	bh=7+hBAtEjizRvOWyCo7oHDoORCJhFCsVGIJjJxvMGurc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ZUD3KprAQkKeUoBayMhXZtRYOXQRvKxrFRMBmR2/107yoWvCyUmP/nNDMlZ4cquD2JEcNNa2YHWyuzxXwkerob3LDZVkE2Cu059Cj/bdiJtjr2bekYu6trl2vG/05PtNY8Ac7kRjXLyIWqMbJYIE4te3OqrCg5SQPD9hkzubtuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sqdDrZVC; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-47d28e7960fso43563595e9.0
        for <kvm@vger.kernel.org>; Fri, 09 Jan 2026 00:22:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767946939; x=1768551739; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BMgUtghnuAy1sqqzoIvEfRuLHghrW+zp1tKrLf8u880=;
        b=sqdDrZVCWmYAffQYV6k++HeAyk9WZtZDbXRorR5svodvsqRjJhZ1rgZ+BTWUUMt7D9
         JZAPR1GmAnO4tN3V5nu3CahKDoKCRLGcuGtSgjzn8MQCgpM0R+XACawqdkezQCydrMa0
         SlroSUkcI4W6or3Sv9Z/D0OEcPp2hFblkSJ5D5yQBpIyft5aiI7G1S+hTODZRT0MgWMA
         6XboDirmXP8ZjKvAz5Ymtp3mh1pehTjHp7JXhRgfkw015H9baBxXEcCp1QJspVaYI6Pq
         N5JUTSFvIMqlOlN4bN3QJn0ufpV5HJedhbEGo6d9AD7gWEpaLLhBs6Z3uU3uhhv/Os95
         O+kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767946939; x=1768551739;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BMgUtghnuAy1sqqzoIvEfRuLHghrW+zp1tKrLf8u880=;
        b=SEnCSfauWESeldqyKQGfpSfJGa2QhQuGJrQQfPIkLRNO9hRoCRCEY3vlnR6mdUnaps
         qtP6VrVFX/SArWEALpC0AWuN+HNEhCdUJv+ACnYn/Dmfq7gPom2XsOZtHfIQUpQ7TgaH
         PUw7/dlIZ4fE8bpk6ArgdmkmBjuBlxmEJFx1H6nhnP1qti5/vEMWVENGAddf6xbYoDxy
         IRnBom2+iExNIDs51dtxuFzmdQM13f4youWRCObSa+6quPP+c11bKuXHkH+3Uq/HxiyL
         c3Q8kvuCG6wzHMk+HuD9FJUb2gQHWtCNee3QM/QNcxqm0M9u9zwPR74PCf2npuC4UoTB
         RiOw==
X-Gm-Message-State: AOJu0YxsZI8fH0PLevZjxUcibH/GUKqyW/VEJj6lU4eDtv23aOboHV4i
	KanF8zePOJwV+WiCL7APszg/vYMnmqq5c9JgE5OaGbewRuTpKo3tc2JFE1g5WjiKiox5hzx3j5x
	PB+zHFAhV78oQB7Dhg4cHTG7cLQ26F1eh6migLP0ElWKxkjVBfhE5m+p1yEpo0Z8Tr61xH504P4
	Peoneqzhla9bbNNaJ2Kc+8sqsbpV4=
X-Google-Smtp-Source: AGHT+IEEqNYMoHeY+3DwmkTCwwRtWsTJKfrOQfXfQ55U2Jju+BCRFWy02s7qCZ5He0miV9LurIPAHvpnNA==
X-Received: from wrbgz29.prod.google.com ([2002:a05:6000:481d:b0:431:1c7:f966])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4fd2:b0:47b:deb9:f8a
 with SMTP id 5b1f17b1804b1-47d84b40a99mr108297505e9.30.1767946939194; Fri, 09
 Jan 2026 00:22:19 -0800 (PST)
Date: Fri,  9 Jan 2026 08:22:13 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260109082218.3236580-1-tabba@google.com>
Subject: [PATCH v4 0/5] KVM: selftests: Alignment fixes and arm64 MMU cleanup
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, 
	pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org, 
	atish.patra@linux.dev, itaru.kitayama@fujitsu.com, andrew.jones@linux.dev, 
	seanjc@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Changes from v3 [1]:
- Renamed page_align() to vm_page_align() (Sean)

This series tidies up a few things in the KVM selftests. It addresses an
error in memory alignment, hardens the arm64 MMU configuration for
selftests, and fixes minor documentation issues.

First, for arm64, the series explicitly disables translation table walks
for the unused upper virtual address range (TTBR1). Since selftests run
entirely in the lower range (TTBR0), leaving TTBR1 uninitialized but
active could lead to unpredictable behavior if guest code accesses high
addresses. We set EPD1 and TBI1 to ensure such accesses
deterministically generate translation faults.

Second, the series fixes the `page_align()` implementation in both arm64
and riscv. The previous version incorrectly rounded up already-aligned
addresses to the *next* page, potentially wasting memory or causing
unexpected gaps. After fixing the logic in the arch-specific files, the
function is moved to the common `kvm_util.h` header to eliminate code
duplication, and renamed to vm_page_align() to make it clear that the
alignment is done with respect to the guest's base page size.

Finally, a few comments and argument descriptions in `kvm_util` are
updated to match the actual code implementation.

Based on Linux 6.19-rc4.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260106092425.1529428-1-tabba@google.com/

Fuad Tabba (5):
  KVM: arm64: selftests: Disable unused TTBR1_EL1 translations
  KVM: arm64: selftests: Fix incorrect rounding in page_align()
  KVM: riscv: selftests: Fix incorrect rounding in page_align()
  KVM: selftests: Move page_align() to shared header
  KVM: selftests: Fix typos and stale comments in kvm_util

 tools/testing/selftests/kvm/include/arm64/processor.h | 4 ++++
 tools/testing/selftests/kvm/include/kvm_util.h        | 9 +++++++--
 tools/testing/selftests/kvm/lib/arm64/processor.c     | 9 +++------
 tools/testing/selftests/kvm/lib/kvm_util.c            | 2 +-
 tools/testing/selftests/kvm/lib/riscv/processor.c     | 7 +------
 5 files changed, 16 insertions(+), 15 deletions(-)


base-commit: 9ace4753a5202b02191d54e9fdf7f9e3d02b85eb
-- 
2.52.0.457.g6b5491de43-goog


