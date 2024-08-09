Return-Path: <kvm+bounces-23748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B78694D660
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 20:38:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5FF461C21D2A
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 18:38:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54DB115665D;
	Fri,  9 Aug 2024 18:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RWmJJ99s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057D513C8F4
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 18:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723228698; cv=none; b=XGgLd1wrKBBxqQkg8MYzsUf98UX36ahHFQrCQKf2Cwr+jHq6DTIjbOVsZWB7WQGKgMky0utuGDjxGVk+AP6ZsRQLNCeQbUvlnxdAItXgrO2tjKQHsBEuQj25awK32LwyYL8knRfj2BsSqIfw7Aq9U+hvV55MclGGRe4f2u81E20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723228698; c=relaxed/simple;
	bh=WgFcAp2Lf8zyPmmusFZaXFyM7LQjQCGcA8kgp6zTh1w=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=hLz9dezzPxOly2u1WBxzdzUS7/AbmfPKngZWor+uni7SlXOiz1vfhVB8blT0J4XqWkRo7cEtzonAOTDFIoFGnpqhC6b79Im4BhHcxElDSZQf4zRcAoqV8Nde12HTvFdFo2GueA3c7gceFY215JPEOeFOryR82TOadSpZLQx2CRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RWmJJ99s; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e0be470f76bso3974193276.3
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 11:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723228696; x=1723833496; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9QpRWP4XLNMJiIvVol8OxLNovEZIjUaHM/c1cDtRmx0=;
        b=RWmJJ99sMvonYDp8mU7bjPKpMW4xKK3Rkh4u2cLCdRQFZxTjbx+0INiW2zr4o7nzaD
         VKMXzWzaUT0sNindNAWMtNIIWamxU2N4gWJ5xf6wnSsGUud3iwC8YjSDXSS8Fa6gAkPW
         v95UlCeStEqFBqsm/cR2wh7zdEdgIV46R0j88Yx76pftG4hvJbKnRaCkHwjxPo4x+1IJ
         piiHkH6YFzHVUJy3eWM6n3nIxUMxVQkXvIUirApc4NkO+7O/8HI/fGv+pXpBy2Kgs/lw
         +5fi0iSZJwV6dcKfdhDrC9NaC3V2UFXwqhMkjxQloI7yw5n8y6tW6g4gi8jcAlAVLfTv
         FkUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723228696; x=1723833496;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9QpRWP4XLNMJiIvVol8OxLNovEZIjUaHM/c1cDtRmx0=;
        b=Ik17Nylu3m+js2rWs/c9BJZ0ySdrEJg+D/EckW+5qEWd7ycNR4YzhgASeVMqwAa6/A
         6Y1C24jv5hzyhTCfTCNierPLMenuc4sWAKDzWOETsLoZZ6Z6OQoL8lg35pLnJ9rDt/Up
         N3bjhGxOPHmA6esYkI81n1vmJ4AwoY78kTLwm439C4UyvYyIvgU4k8Ceq3jTbTr50NJN
         BXFoubekit5bSAk8ZjfcnC3UnH5Y3u4CYXocXvE6aAxjbVdo/wrwlVpZ6vMKylwTwjqD
         fGCaHIn7ecX1WhYk3Z8x9N8vTv7wp9ivxah9BfQU5o8ZYEow1hkf+j775qts6yCqsI3b
         GoYw==
X-Gm-Message-State: AOJu0Yy2LmZHqK/hCYEJQZTNO/iZj5aIo8TXbJdp+h/VTcE046+zrhdv
	a2O/CSwcI6kfX8C5OhgtIkYV75Ofl+vrDgrt5ZjkNH8+V6c+94OaW93YypupOUoy9mZ9zmsU+sX
	OoQUpsqtE/hsoOgGrH4N8ssrDngvFzA225vifFWSb7CMAWcvAaHUyOmID/Xg6X2benViuMba2Y4
	o70aeJ+6k05BJ/8chpcSznH848YDLwwjqESP2elq3FpzXdGW+TL9M7/yc=
X-Google-Smtp-Source: AGHT+IEQzaYfkd9MJCLSU0EZ0iwERGwinl3PjreNXMmt5xE9iCRLweaZNLIudRz1qRDKokEE+0gqU4sbJ8n0hwOLfQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a25:ab93:0:b0:e03:b0b4:9456 with SMTP
 id 3f1490d57ef6-e0eb9a107c8mr23264276.7.1723228695743; Fri, 09 Aug 2024
 11:38:15 -0700 (PDT)
Date: Fri,  9 Aug 2024 18:38:00 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809183802.3572177-1-coltonlewis@google.com>
Subject: [PATCH v5 0/2] Add arch_timer_edge_cases selftest
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Ricardo Koller <ricarkol@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, kvmarm@lists.linux.dev, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Add arch_timer_edge_cases selftest to test various corner cases of the
ARM timers such as:

* timers above the max TVAL value
* timers in the past
* moving counters ahead and behind pending timers
* reprogramming timers
* timers fired multiple times
* masking/unmasking using the timer control mask

These are intentionally unusual scenarios to stress compliance with
the arm architecture.

v5:
* Drop previous patch 1 standardizing GIC addresses as this has now been
  done by another series
* Fix shortlog message for patch on arch_timer test
* Comment ISB use appropriately
* Rename gic_wfi() helper to wfi() as WFI instructions don't imply a GIC

v4:
https://lore.kernel.org/kvmarm/20240307183907.1184775-1-coltonlewis@google.com/

v3:
https://lore.kernel.org/kvmarm/20231103192915.2209393-1-coltonlewis@google.com/

v2:
https://lore.kernel.org/kvmarm/20230928210201.1310536-1-coltonlewis@google.com/

v1:
https://lore.kernel.org/kvm/20230516213731.387132-1-coltonlewis@google.com/

Colton Lewis (2):
  KVM: selftests: Ensure pending interrupts are handled in arch_timer
    test
  KVM: arm64: selftests: Add arch_timer_edge_cases selftest

 tools/testing/selftests/kvm/Makefile          |    1 +
 .../kvm/aarch64/arch_timer_edge_cases.c       | 1099 +++++++++++++++++
 .../testing/selftests/kvm/aarch64/vgic_irq.c  |   11 +-
 .../kvm/include/aarch64/arch_timer.h          |   18 +-
 .../selftests/kvm/include/aarch64/processor.h |    3 +
 .../selftests/kvm/lib/aarch64/processor.c     |    6 +
 6 files changed, 1131 insertions(+), 7 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c

--
2.46.0.76.ge559c4bf1a-goog

