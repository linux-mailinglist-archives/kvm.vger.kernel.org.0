Return-Path: <kvm+bounces-11320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 084C0875634
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 19:40:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B1E441F21DE4
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 18:40:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4C7D1350DB;
	Thu,  7 Mar 2024 18:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NfEoQ1Yo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A69A1332AA
	for <kvm@vger.kernel.org>; Thu,  7 Mar 2024 18:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709836796; cv=none; b=KxLZai3mdjuSOXhO1Z9DHDUaTbyG+oOKcREdL47i6s4jXfuV/zfsHgC74kp3xcnz+YX5xpSIbz08Y4rahXm8ZwM45GOzvzsPAtCqSQKPT6I3qo6jR5nDXKkMATcCXg+m8q0CaGUbMbQbDC5QNhdoVycEWbfrp34Z5UuUXAc8OZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709836796; c=relaxed/simple;
	bh=akk9bHSXL2p2/76CztMO7vrfVTA+C6sHDz1aSSJxcrI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=pV5Bq8F29ctAn7sk7B/XTSpwGQelTpiQgj7JQ4ch8c8P3fkSfFolQT+OiiAkkDF8Aft/8mHb5imfiZlCDl3E1wwel5RY3jsbLngCu+CXPugfP4JRGhfRxqo37qHDYwkQZGcEJdEu0WxNiNaXdC3snC9giDneNYl0Lzt8BSmkiho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NfEoQ1Yo; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-7c495649efdso143380739f.2
        for <kvm@vger.kernel.org>; Thu, 07 Mar 2024 10:39:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709836794; x=1710441594; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vNMOfHTWILvXvO6xXs7ecY4oaxm2hms9W+5pBi1MYDs=;
        b=NfEoQ1Yo6n3j58/3C3jMnziJXVS8y4pbX98N8rbJGtfHItw0UgG29E4ZfIetKYj0u+
         bHBZZz3+aXa1dwhj2f6f1RVvSax7faSsMa2eb9KJXGPUVRXw+zLl6PVjZN+fjWvZ4y/D
         +y7tn2h2y91hkVOdy17Nb05s7lvSCvWHLFAzJimt8k8A0DvwsZID2ovUxNBksnh1eMWx
         mKXS+vi3+Z7C7+mEq5O68E/NHMziGx437B6mBjHL6zzjKq8RLlp1MlmF89z76wfpC8/U
         wlKbSpN/nMPuLdxxuTc3BX7/ZrZXp6Ui2pyRfkl6rV83PZ1dElqg2I/8g3/Rb+Q588/3
         ItYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709836794; x=1710441594;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vNMOfHTWILvXvO6xXs7ecY4oaxm2hms9W+5pBi1MYDs=;
        b=rfcGycKbWecFZzmX3eAyXvQFh7lqlqtoVERaRKX77OYs0COubzJFn/puSGBoXGxxhp
         NWREbmlSKPU/uS819vUaRr08XCNDiF5HtUZ1ikOF4X7ROMJmJIzZjVugWvKsonnrVQ0L
         g8SWQgilfIIXH7PUHDthe/fGkRfC8+NwPOJEctRH64KJ2CJ+KZ0+thUwzD/yWMaSNf/R
         LZDDDbiarRchvXiriGs0YCU4AFqbEUHgS4eSjyOHdXQCmrCDeaVz9xYM00NDHIf1n1s1
         bkgWXel18njNaT9OwJQQ3gksAKFBOZw3YQfxMm62+/cgJJe4CzH1AfcCmNBrBgxP7wkq
         ujHQ==
X-Gm-Message-State: AOJu0YxrwZwcXUNyqEXxICX1cn+G6opnfMYheGQTcRPEGbEOUgR7wIc3
	PiFYfJhQAstQtHrlKeKVKupjN4Oy9uvnC5eJT9P53a9Vh6vUSl6wgKNlPr3yVmpvyT1JKNpL/ND
	uHct2it2dV2KZV4PDdsqAIVpecrwvOMiHjBoaU5o8zERlrP/C4i50q4ffS+HkOrhVlZX9gm9WpH
	J5b19E5X6wLAA5NdwkFqLr3dSE6zlsi4v6zk07DBVBFrMyrA7d2/bl828=
X-Google-Smtp-Source: AGHT+IHn+sE1Yd5hWukLNm6By8efRqP8K6LAQ3UzMWo/06dXPuuyn1o2cC1Gk4A10pen0rB7atZJaPWELfUv2bnXlg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6638:16ca:b0:474:b9df:7315 with
 SMTP id g10-20020a05663816ca00b00474b9df7315mr1010188jat.2.1709836794515;
 Thu, 07 Mar 2024 10:39:54 -0800 (PST)
Date: Thu,  7 Mar 2024 18:39:04 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240307183907.1184775-1-coltonlewis@google.com>
Subject: [PATCH v4 0/3] Add arch_timer_edge_cases selftest
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Ricardo Koller <ricarkol@google.com>, kvmarm@lists.linux.dev, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Add arch_timer_edge_cases selftest to test various corner cases of the
ARM timers such as:

* timers above the max TVAL value
* timers in the past
* moving counters ahead and behind pending timers
* reprograming timers
* timers fired multiple times
* masking/unmasking using the timer control mask

These are intentionally unusual scenarios to stress compliance with
the arm architecture.

v4:
* Convert macros to functions where possible
* Remove magic numbers
* Improve naming of variables and types

v3:
https://lore.kernel.org/kvmarm/20231103192915.2209393-1-coltonlewis@google.com/

v2:
https://lore.kernel.org/kvmarm/20230928210201.1310536-1-coltonlewis@google.com/

v1:
https://lore.kernel.org/kvm/20230516213731.387132-1-coltonlewis@google.com/

Colton Lewis (3):
  KVM: arm64: selftests: Standardize GIC base addresses
  KVM: arm64: selftests: Guarantee interrupts are handled
  KVM: arm64: selftests: Add arch_timer_edge_cases selftest

 tools/testing/selftests/kvm/Makefile          |    1 +
 .../selftests/kvm/aarch64/arch_timer.c        |    8 +-
 .../kvm/aarch64/arch_timer_edge_cases.c       | 1102 +++++++++++++++++
 .../testing/selftests/kvm/aarch64/vgic_irq.c  |   23 +-
 .../kvm/aarch64/vpmu_counter_access.c         |    3 +-
 .../selftests/kvm/dirty_log_perf_test.c       |    5 +-
 .../kvm/include/aarch64/arch_timer.h          |   18 +-
 .../selftests/kvm/include/aarch64/gic.h       |    8 +-
 .../selftests/kvm/include/aarch64/vgic.h      |    3 +-
 tools/testing/selftests/kvm/lib/aarch64/gic.c |   12 +-
 .../testing/selftests/kvm/lib/aarch64/vgic.c  |    7 +-
 11 files changed, 1158 insertions(+), 32 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c

--
2.44.0.278.ge034bb2e1d-goog

