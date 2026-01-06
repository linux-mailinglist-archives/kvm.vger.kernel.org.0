Return-Path: <kvm+bounces-67102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DE0FACF7811
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 10:24:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 820B63040D28
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 09:24:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F267C313E03;
	Tue,  6 Jan 2026 09:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NqvI1/2X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5071331618B
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 09:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767691471; cv=none; b=kBeMyT+hK8Hlsei0P0ADh8BtS6Hf6BhJQN+bUpdnUU9beiCwjn5smJRPavzddb8I8q9NsJ1fnLWq5glyf/ppSoQXWokUceQEdcs5S4bWIQAjamA+cGBa1ZFLi7xvdV5Sj9oyKrkVkN1D+YB2bpiKLl+D18DCDR3/vtQ9rh13KDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767691471; c=relaxed/simple;
	bh=hMrKzPKwz67JgoKxLU1YaBlRJJnDreZeCQvtwVIB3NA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=gVw715f3DMURa6pP0CwIy6s2JMm1vHbEPTv7JF4WNAjiEsxxnECVtksxq4ZG71b5HmBHcUCf9YtwT727S7BwGGmWFat727+NI4F2zhWf7rAjeFM/KSkXAOKCCu1KV4fexckxwkCtw4gtQJetL8Rc6D3Ia57qpUK00rjrir6trGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NqvI1/2X; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-47d62cc05daso4834595e9.3
        for <kvm@vger.kernel.org>; Tue, 06 Jan 2026 01:24:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767691466; x=1768296266; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+LqF8/lht1o9n/0GpUByxOJv4W80ArGZN3sXAN7aJgw=;
        b=NqvI1/2XwNe4EtPdJDz1vJ4zdW8VMhU98+fKXsiJapaqW75N7dBPwGu5lsARwOL7xB
         gKtxkihM6Gn7vKMa7AqaBrOOrU6SA3UwHYaOBXcb3zbg01XnVzuGN9EujmcgmRMyIwQO
         93Zyw0GUkRe2utZJGB/NGleHxpIPm5GU2ECwPtkfntQAAIZu76KxPPyBvuCkxlZbV6Er
         PyQZthwzFaorleNbqWfBDpfmDS1SRzKOSMd/AvaNZuhR6fnYdzknfdhSFd/Vnx8dNXh7
         VDkYEC3X9I8iPhRksnbmtIz7cKcSrSnH5HCtqMd9S9Xz6QRwAdjOGPar77+4XS90xuXr
         /nog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767691466; x=1768296266;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+LqF8/lht1o9n/0GpUByxOJv4W80ArGZN3sXAN7aJgw=;
        b=V6RncxnZE0XUShojdc+1YDKL0QKqNc3MRKOUB666pWaqBq4Z0jnw9AJue1vAJxxj13
         tPS1FbjoPefgDWniqyzSiSzK3UFoGD0HYPx0fNS5FL4xJW8o7XXY3IW+0AF7azG65q9c
         58PQky2inf6WELQi5Jy5nXd/a30EyUf/uGUOxmniZH24j2G8A5zV/CoyuZ8HdDyFQSGb
         6zhtLOb01eDD1qIoNppiPsBbVF0XYCtSc3XSpHXFsGuSfirlrPp2RKST94FBSNbMvGkm
         Z6AvjmD0I27Nc0cNblmlyYo/TpVBKmxqDbOhxNn3n9r5aO61S38IUCNjixOjQyo0UnhJ
         5bMA==
X-Gm-Message-State: AOJu0YyV2exfhR58EGIPc4y/laQPyTVbzED2//SQ4Q248P4V1fhujVcd
	4y76AYo3nv296iQU8ue+KayPrCCzxcpXl6QY7b77j4yTt2CxkvyXlMMUyqXXGQsnCqN1MHGQ9Aq
	j0XxnigkowN1SDC3ryRimf/Re4pBp2Usg+BkwcDWOvTzl9V9A/AJH++L9YPjAv7op3nyhIAdD5s
	35G25i7quDZwQEgKhM3JD7qFNDXP0=
X-Google-Smtp-Source: AGHT+IGJDvWpfC1ugVJSYdWQcUeMnYmXOhwJri2fdiSaOwSbZ5cVH4Myj4tyQgT04GoXs3XHWR0vuJXjyQ==
X-Received: from wmbdu14.prod.google.com ([2002:a05:600c:634e:b0:477:9b3e:67e3])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3555:b0:479:33be:b23e
 with SMTP id 5b1f17b1804b1-47d7f090045mr30939095e9.17.1767691466044; Tue, 06
 Jan 2026 01:24:26 -0800 (PST)
Date: Tue,  6 Jan 2026 09:24:20 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20260106092425.1529428-1-tabba@google.com>
Subject: [PATCH v3 0/5] KVM: selftests: Alignment fixes and arm64 MMU cleanup
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, 
	pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org, 
	itaru.kitayama@fujitsu.com, andrew.jones@linux.dev, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Changes from v2 [1]:
- Collected Reviewed-by tags from the previous version (thanks!)
- Rebased on 6.19-rc4
- No code changes

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

Based on Linux 6.19-rc4.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20251215165155.3451819-1-tabba@google.com/

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


base-commit: 9ace4753a5202b02191d54e9fdf7f9e3d02b85eb
-- 
2.52.0.351.gbe84eed79e-goog


