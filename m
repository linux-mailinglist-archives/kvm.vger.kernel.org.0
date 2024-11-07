Return-Path: <kvm+bounces-31184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 068AA9C112E
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 22:42:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA49F2822E2
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 21:42:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB75A218D61;
	Thu,  7 Nov 2024 21:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="28SAWGoF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8481DBB0D
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 21:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731015703; cv=none; b=sUa2pGHP11E7p8j2GwjniGUfNYRYVTebl4yGB469PBkN//6pfiu2Pev27Lluxn4ezCV3klxuAZEvPOic+UPm2ouR3OaW4BTbhweFXXEtgzA9CAl2BpLoVBoM5hh/t7kTzpLlswb1PeGXDqjkczd/6ccfBX1bcOuMq5ZcEDicmsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731015703; c=relaxed/simple;
	bh=q4ZHQxgTV8bsJCCWyN3hyqsECD5J82qaLuxwVTYXRD0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=EdsorU7agEz8ONRq72nsp2aE62m6YzvFJhhLaZuaqxHDzUFscX8EUospnO/mlnC6881bP4yJ4e2XgUapbVy7FWFLvIxwaKaa55MZFncU1p3Tv8hYq/iye1MeDcbM4F6Vg0xG/FpgmoH6+q8NcDmFKBamVsek900AIWyo75QpohA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=28SAWGoF; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e0b8fa94718so2720979276.0
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2024 13:41:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731015700; x=1731620500; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=U/2V0k0nsK2UijeufbuSOipQUsU110T9hQl5WTfC5qM=;
        b=28SAWGoF31StF+1bc6gj6Z8f4uP0EVBPEfLrcABy693csEES1PQ/GuR8wSGYFBgY+c
         3kVGN9MP4qN0UEAZbDCZcWAI5K/rqGsvL5jcjLvIX75yyzWUSVDzemU1oOH+6BamN8jc
         EXoHKAagfzc0NPmLe3bMR4y/8Tkbi5vctWcIiozPXU2/D9/ebINZXYPiHoe2A9BpU22G
         E/6dkMeicXlsdxh81oDrEl/cexatb+jntqfO/SbaiDlaJXF4cpE7ye9kaj6UmG1pELTD
         VwhQRVvBqyFgiQysCYobGrffFLKtpiWNzrtKYymgZbQUkXmfBlEYq7leWFRXTgC13jft
         KUTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731015700; x=1731620500;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U/2V0k0nsK2UijeufbuSOipQUsU110T9hQl5WTfC5qM=;
        b=uQu0qa4IbIXrlib1GHxhWoogdKDkXmBFafQvaKv2KA1pTMT22iaUSWDcleSzEd/MsD
         k1Z+c6SIqcAml1cAdmVKhPhJ2Kq4Jdxw/rzWiV93lYqUyyUXWBuruBqwZV0fVVqiBbbS
         nY8AeETJEdnlvdnWc+ppXsXJhTkY09ZI5PbL3eer2LA48GjGXZCZ5ljbkHnGYETZGePr
         nyfhGh02IFghYwtWeK2r90NjHuk8Poy9eVzX41diiq18oWCTIPikNjRYQ+0Z8teuNpHY
         jRZmXlNMSHd1LUOzsFcECL0nHKJo7yfNXkFZJjZ15YOojcVX29V0D4nOvW/Qc7u8VXgu
         N9qQ==
X-Gm-Message-State: AOJu0YyaRCERiy6NY1aNo38yNI9VZ93XF+4EYlPSqf7Q7iGgr4L54lRe
	dLTCMs3SJyBkzqo6J13kaCoeWjwpbF+SVtrIs0jlaUa3QetxOnuBqo/4A/vgqPg+Ih85mkM2cRF
	OlmjeMqWOithUQ++Kw8aKcwi7F+mMRAO3hEHAYASRTM97Px1erplHmC8Z/9/Lgzy32Jh+MzlHCr
	y3VInZGDCuC4PSnOYfmiDPW7ySadikPpb9DWi3N2iZDDZoTZAt/b0t3+Y=
X-Google-Smtp-Source: AGHT+IHQa4/WDLxhwkTlxQKoJnSpSbWPLr4U+354oC+COKsIp0AWg/aYpXuPUvHJ5Ube9TvWVckE07rwKroGFx7ioQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c96f])
 (user=jingzhangos job=sendgmr) by 2002:a25:aaea:0:b0:e2b:d28f:bf28 with SMTP
 id 3f1490d57ef6-e337f844036mr1537276.2.1731015699859; Thu, 07 Nov 2024
 13:41:39 -0800 (PST)
Date: Thu,  7 Nov 2024 13:41:32 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241107214137.428439-1-jingzhangos@google.com>
Subject: [PATCH v4 0/5] Some fixes about vgic-its
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Kunkun Jiang <jiangkunkun@huawei.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Andre Przywara <andre.przywara@arm.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Shusen Li <lishusen2@huawei.com>, Eric Auger <eauger@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

This patch series addresses a critical issue in the VGIC ITS tables'
save/restore mechanism, accompanied by a comprehensive selftest for bug
reproduction and verification.

The fix is originally from Kunkun Jiang at [1]. 

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

* v3 -> v4:
  - Added two helper functions for table entry read/write in guest memory.
  - Move selftest as the first patch to easily run on a host without the fix.

* v2 -> v3:
  - Rebased to v6.12-rc6
  - Fixed some typos
  - Added a selftest for bug reproduction and verification

* v1 -> v2:
  - Replaced BUG_ON() with KVM_BUG_ON()

[1] https://lore.kernel.org/linux-arm-kernel/20240704142319.728-1-jiangkunkun@huawei.com

---

Jing Zhang (2):
  KVM: selftests: aarch64: Add VGIC selftest for save/restore ITS table
    mappings
  KVM: arm64: vgic-its: Add read/write helpers on ITS table entries.

Kunkun Jiang (3):
  KVM: arm64: vgic-its: Add a data length check in vgic_its_save_*
  KVM: arm64: vgic-its: Clear DTE when MAPD unmaps a device
  KVM: arm64: vgic-its: Clear ITE when DISCARD frees an ITE

 arch/arm64/kvm/vgic/vgic-its.c                |  31 +-
 arch/arm64/kvm/vgic/vgic.h                    |  23 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/vgic_its_tables.c   | 565 ++++++++++++++++++
 .../kvm/include/aarch64/gic_v3_its.h          |   3 +-
 .../testing/selftests/kvm/include/kvm_util.h  |   4 +-
 .../selftests/kvm/lib/aarch64/gic_v3_its.c    |  24 +-
 7 files changed, 631 insertions(+), 20 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/vgic_its_tables.c


base-commit: 59b723cd2adbac2a34fc8e12c74ae26ae45bf230
-- 
2.47.0.277.g8800431eea-goog


