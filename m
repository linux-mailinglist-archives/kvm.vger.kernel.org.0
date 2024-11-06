Return-Path: <kvm+bounces-30865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F48F9BE0F8
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 09:30:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E57F1F21C4F
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 08:30:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1280D1D47A6;
	Wed,  6 Nov 2024 08:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TVUhVZEY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0D119048D
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 08:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730881843; cv=none; b=oa3iZwr6fXITRUjkmevgDZ1JIP85nwVcQPxNiTRm279o8bZz1a7brDO/bY66QcXbEoGTlq9JOxchYk/KNRMVxozKRhLw6UGNUJTxtGamsPGuWnwaHotvKLQgvC4hUsbgbgWw7dQgVhR3hTTVjccJpfFsQWHLHrsqxXZru5zB5eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730881843; c=relaxed/simple;
	bh=uie5EwUupmfki0rGnZG5vo18XEMnIAkAeh6ikomY32c=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=u0V7ULHn/o0XLNsp2VUbIW0sMMTPMm07oe3vb9JwbRYfUZe0WN4E2pa4amZ35PgR0T1IahM8EzI78/1Y1Q7jVUxSsgABdmmKWi/rRmvos1vKEerabV9Z1mW+AH0kSqTW63N96lI5DuTws9/gZUshmQSAHyFUJ2drAhZcb+9XvnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TVUhVZEY; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6ea8a5e86e9so66475627b3.2
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2024 00:30:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730881841; x=1731486641; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AsoJeQT7lIbORupJmPx8o8UcNDx1QgoC4+ZDQJoGnSc=;
        b=TVUhVZEYtEqXoc1ShuMPTfomVS34sZY2fbqn3N3pBAzaj9Hsc/bpsOiF2TvuELxpPR
         Nw1V2BAeXycB/n5IValsF0O2D+bTCVbDHpH+beiAqFsW9lPJqwEqetA50R830SpZ3BTN
         lHLSGbkTDuuAOhwPGBUGQkdMTQ7OWXma7ZUS5Y8aq6bSoWFK8Y/QbZMMIRSjvcXmuTUZ
         56HAun4AwC0dfIBML5aPb+olpUjdHkWuH8Xc7HjScJ0jGtOAxBWgJZqh2A2wca0OsJpv
         zvdxenoi69/5QQvnXEx1EQJm+WKYly+uclSimnTnwrBeFFcIfV67sEkJDDl330KA/m8L
         K5YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730881841; x=1731486641;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AsoJeQT7lIbORupJmPx8o8UcNDx1QgoC4+ZDQJoGnSc=;
        b=LdFpXUqehh5zcKFoIni2SZRPVMC6spaACFxz54e7hxQZcIOZKCaKvCadmYE0x2h1sO
         0Bk4xRSG51W+dhB2I8j8jfDqKVimaA+Pn2mcoVEIA+C0F2GNTkkDfa5gcx2y8toC9uLo
         /dve4gHbjYa+KVRvCk37qfq1cGQ/SaXBINYJAKNnpXk/+XjdZCnoXfpkb9+FwUB0EVsd
         p2Bjm/jlkDI89sNJpBtcAIIv/BZHYnYADEdOBWNrp24h2XULtiXYWvFleADxKUe0hjo2
         eTajI+yeY6a1B2UisOdopljqTvhlLCf/hZDHOLPZUFrzYw8WTJ1rnlm6NxpyPleQjff+
         vkYg==
X-Gm-Message-State: AOJu0YwEJKoo4bHTtJdmrzbZjgnIcgwcxkmbwPXp5xi6ceFywTNfw9MB
	Cu4K0L+odaRNuy5JEfqKw9dwEfexiy6xmVzw5BzMtryTy2SEdLIy1Jf50+Xseq6MH9OxjFXjh6J
	YSPj5MW+um1pfsw1JLg5TSCJoXFfKseAVVlj6PmKk/XMz0UKTuUfenDnfmVYJRIPMzlosdG8qdt
	ZkthOt8lE7ffFdJ0/w4eztGZYI+IXSa4rPI7o+Cd5zcoYSgkJQ+ZrTeR4=
X-Google-Smtp-Source: AGHT+IFnO97LH4M7nakwImn7GhWO3dwEBs9GkzFartsysl46F+6jkXxf6aVj3MHFmDdtMe6k2kDQQQH6u4FDvb/Y/Q==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c96f])
 (user=jingzhangos job=sendgmr) by 2002:a81:c745:0:b0:6e3:f32:5fc8 with SMTP
 id 00721157ae682-6ea52319152mr944207b3.1.1730881839861; Wed, 06 Nov 2024
 00:30:39 -0800 (PST)
Date: Wed,  6 Nov 2024 00:30:31 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241106083035.2813799-1-jingzhangos@google.com>
Subject: [PATCH v3 0/4] Some fixes about vgic-its
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Kunkun Jiang <jiangkunkun@huawei.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Andre Przywara <andre.przywara@arm.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Shusen Li <lishusen2@huawei.com>, Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

This patch series addresses a critical issue in the VGIC ITS tables'
save/restore mechanism, accompanied by a comprehensive selftest for bug
reproduction and verification.

The fix is from Kunkun Jiang at [1]. Only a few typos are addressed.

The identified bug manifests as a failure in VM suspend/resume operations.
The root cause lies in the repeated suspend attempts often required for
successful VM suspension, coupled with concurrent device interrupt registration
and freeing. This concurrency leads to inconsistencies in ITS mappings before
the save operation, potentially leaving orphaned Device Translation Entries
(DTEs) and Interrupt Translation Entries (ITEs) in the respective tables.

During the subsequent restore operation, encountering these orphaned entries
can result in two error scenarios:
* EINVAL Error: If an orphaned entry lacks a corresponding collection ID, the
  restore operation fails with an EINVAL error.
* Mapping Corruption: If an orphaned entry possesses a valid collection ID, the
  restore operation may succeed but with incorrect or lost mappings,
  compromising system integrity.

The provided selftest facilitates the reproduction of both error scenarios:
* EINVAL Reproduction: Execute ./vgic_its_tables without any options.
* Mapping Corruption Reproduction: Execute ./vgic_its_tables -s
  The -s option enforces identical collection IDs for all mappings.
* A workaround within the selftest involves clearing the tables before the save
  operation using the command ./vgic_its_tables -c. With this, we can run the
  the selftest successfully on host w/o the fix.

---

* v2 -> v3:
  - Rebased to v6.12-rc6
  - Fixed some typos
  - Added a selftest for bug reproduction and verification

* v1 -> v2:
  - Replaced BUG_ON() with KVM_BUG_ON()

[1] https://lore.kernel.org/linux-arm-kernel/20240704142319.728-1-jiangkunkun@huawei.com

---

Jing Zhang (1):
  KVM: selftests: aarch64: Test VGIC ITS tables save/restore

Kunkun Jiang (3):
  KVM: arm64: vgic-its: Add a data length check in vgic_its_save_*
  KVM: arm64: vgic-its: Clear DTE when MAPD unmaps a device
  KVM: arm64: vgic-its: Clear ITE when DISCARD frees an ITE

 arch/arm64/kvm/vgic/vgic-its.c                |  44 +-
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/vgic_its_tables.c   | 566 ++++++++++++++++++
 .../kvm/include/aarch64/gic_v3_its.h          |   3 +-
 .../testing/selftests/kvm/include/kvm_util.h  |   4 +-
 .../selftests/kvm/lib/aarch64/gic_v3_its.c    |  24 +-
 6 files changed, 632 insertions(+), 10 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/vgic_its_tables.c


base-commit: 59b723cd2adbac2a34fc8e12c74ae26ae45bf230
-- 
2.47.0.277.g8800431eea-goog


