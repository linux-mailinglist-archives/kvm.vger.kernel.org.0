Return-Path: <kvm+bounces-36705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE94FA20069
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 23:21:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 59C921659BE
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 22:21:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65EF61DC05F;
	Mon, 27 Jan 2025 22:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kOLmEr/I"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6AA1D932F
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 22:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738016453; cv=none; b=RtyUP6A0dBoJ/iLsla+6mk+qQWOINtS57GSPLaJ/wBXtqKDWEkc2xUiGrkE2OgxUzm064zF9mY7qMCEgkZfFZv+ANnme/Icbxf44lLgb76cRcVmHRpXfI+bq5EoVy6vBjPQSvsmHDUh1gk+/I6DVYlKDxG2gS+r7mKe6GLvcQX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738016453; c=relaxed/simple;
	bh=YR+PMK0VyLwKWhT0xbtwEKZ7//CuT8dMl7x5cZfrnYo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=miWonoiSpYGZ/Vikn4gEqcFUrCz/YlwhLt/8jJYkwPRBYHd+SyIKEe4ckRNe8/wq/Ie0QZMSI5/O8LY3+8BfprJir5Edv5ohMkX6xB3qxjQxk0OAJsAIGUsZV0ZOIbOEaNF78nM/kPn3FRj4BqYip3EIL0l2NKH4xBOIlVtLQGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kOLmEr/I; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-5f353512c1bso1366799eaf.0
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 14:20:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738016451; x=1738621251; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VGVx2inDcPb4kyuc5g9Cp41GlSlePFgSKTBuQPtRjD4=;
        b=kOLmEr/I2Z7b+qq6+hyriOttQstMPZOWEPNMk6gAp59FyaoEAo9IauQisSA+g6Gqxk
         8G6tzvxDoHGr1HeY4O/0Ee5eE0wdbzeH6o9kxbgPwXyBmar4jcfbx89IbWVLWpZNMRlo
         Qdusesw7ECaWP3asFScycj9kC/uS8AKKLfMTlinPl+td8/BGK4qx6rWPvv0SzTazxPIN
         IvnaBJ/GLJWgv0ea2lelHayDGdOQ+fSDeqGzIBHizdqSNjzsVr5yjvbVEtp6PKufwQW3
         fTgOcmlIC4hMndIE2f4hQOuDgJ3DnEwU7it3COVo489dcwCCPwQDb3jdMjYtrQLvNlDa
         aoxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738016451; x=1738621251;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VGVx2inDcPb4kyuc5g9Cp41GlSlePFgSKTBuQPtRjD4=;
        b=SsF8PCVBCjcXgT1XrwdW0dKS/7gP6wceirWyhQXtYneZkTNm2Rdux/s7LUKLptg8J9
         zWOxwVQ4SCutsV2JV3/wttzIkEc6VGq7gxgZqHRgCLWZy6+FaWYhMJiI24pLZWwE560j
         fGiMnLzbwEYRqNofSSQC/0GARcFk7bHRNLMEbvJ9OC279uoZbGle/t5im60V2eMPMALz
         C+Oz8UTmb1Y8uq3w707PlPL7xD1lHgfJvL1RZjPCcrw+NtAPw8aYHMgUR7M4nO9uWzQW
         eXo9g/pmA28t0BwHVQ0Pv4C/jJaFEO58pAWayJ1g4Dyv1LhYaYfCJNtIRAWe/3PNW3vw
         RLww==
X-Gm-Message-State: AOJu0YyPgk0Cg9S8EbwzT6vCSnEQE8IWSzwOaVXul4OxRbpEMu81tFJ2
	WCkzGxO8ROyfCbPNxFFlYWtFYk9ksg6VHeCGtFQCIFsYWa2ZgNADG6SXU0st0mzTmPEq/5CTfzR
	DsC0jVBhOe62CYOkh5QnW2nAGRBFXxrfgVthMPDawWBehvLqXeKd1KnDI9EewVrLY3aptE2Nnpk
	QgzUMrisLJ6vFKP7Jz6q70M3Eue7ycKwIOLU+YybnrPhvQ4vFbNj+GoWs=
X-Google-Smtp-Source: AGHT+IEyp+zn4K8xvMBme9w+olqOdC2WoYBUbvWUqnKRlZMr1gAx+eFOYXOnePYqDL8MpO28ip3SYaynWBZeMCj6Qg==
X-Received: from oabnw13.prod.google.com ([2002:a05:6870:bb0d:b0:2b2:2b44:5abb])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6871:3a88:b0:29e:2422:49f9 with SMTP id 586e51a60fabf-2b1c0aee5efmr22900341fac.25.1738016450898;
 Mon, 27 Jan 2025 14:20:50 -0800 (PST)
Date: Mon, 27 Jan 2025 22:20:26 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.262.g85cc9f2d1e-goog
Message-ID: <20250127222031.3078945-1-coltonlewis@google.com>
Subject: [RFC PATCH 0/4] PMU partitioning driver support
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

This series introduces support in the ARM PMUv3 driver for
partitioning PMU counters into two separate ranges by taking advantage
of the MDCR_EL2.HPMN register field.

The advantage of a partitioned PMU would be to allow KVM guests direct
access to a subset of PMU functionality, greatly reducing the overhead
of performance monitoring in guests.

While this series could be accepted on its own merits, practically
there is a lot more to be done before it will be fully useful, so I'm
sending as an RFC for now.

This patch is based on v6.13-rc7. It needs a small additional change
after Oliver's Debug cleanups series going into 6.14, specifically
this patch [1], because it changes kvm_arm_setup_mdcr_el2() to
initialize HPMN from a cached value read early in the boot process
instead of reading from the register. The only sensible way I can see
to deal with this is returning to reading the register.

[1] https://lore.kernel.org/kvmarm/20241219224116.3941496-3-oliver.upton@linux.dev/

Colton Lewis (4):
  perf: arm_pmuv3: Introduce module param to partition the PMU
  KVM: arm64: Make guests see only counters they can access
  perf: arm_pmuv3: Generalize counter bitmasks
  perf: arm_pmuv3: Keep out of guest counter partition

 arch/arm/include/asm/arm_pmuv3.h              |  10 ++
 arch/arm64/include/asm/arm_pmuv3.h            |  10 ++
 arch/arm64/kvm/pmu-emul.c                     |   8 +-
 drivers/perf/arm_pmuv3.c                      | 113 ++++++++++++++++--
 include/linux/perf/arm_pmu.h                  |   2 +
 include/linux/perf/arm_pmuv3.h                |  34 +++++-
 .../kvm/aarch64/vpmu_counter_access.c         |   2 +-
 7 files changed, 160 insertions(+), 19 deletions(-)


base-commit: 5bc55a333a2f7316b58edc7573e8e893f7acb532
--
2.48.1.262.g85cc9f2d1e-goog

