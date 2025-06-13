Return-Path: <kvm+bounces-49446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2C42AD920E
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 17:55:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF6FE3B18CD
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 15:53:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 839E32116FB;
	Fri, 13 Jun 2025 15:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZCK3LNHG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D7820E71C
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 15:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749829965; cv=none; b=f0+zpunfJMWA5TR5SSCRoI2j5gSgSzDo2M5+RN28QpydL52jCXm4gBXAJFpDw+RWeQgJXmfUiiAzGk3XBy8EvGnfj7OAClGvF3FpqzLgC5feXqBJWHn+VDblrbxSwQzdZUDhJTRcGGNGt11L9wgmTD++GSVO7QIAsZUwxGs1m0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749829965; c=relaxed/simple;
	bh=V4PzPoOaCC/sYPuHFfUusk0N9pEzRvJQTvYtVPBjpKI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=aX9Hxawb0fl7QnG7bLMNJ5k9zYaF+yyzCHnQwol3/fqR04Y22t1lKEMpsVbny5A3vjfOWsC7uy3UITDSih4UjY/xJAOiEimc7A/RlQ49G1vYQb6MxNouiEltUC+0V4794XX4DVlVaCDixS4TWHKD5onUEKO4p2YH6UUWlKGdIIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZCK3LNHG; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-86d126265baso218972239f.0
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 08:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749829963; x=1750434763; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=npODHkhgO8HUf/TrEhpf2O2lbg1BmEemgLQdrUWSQ3w=;
        b=ZCK3LNHGrLD+35bUWg07+vJ5HEnTCDFiJuhzScxlnZa/o1bk1IC27FP91TGqLiuU6o
         2E6QvhSEZSlYRnjwK4iKlreqlLxaXmNoHHFlu98mb5CuYpiX7QWw0AwVjBHoPAgFJQEB
         foJCHoNPcZoIQGZWvzZm6F3ywbz87AeIpOZ86Bo6U/ecitBvJ2Mh8M1Y3fmvlKSGnYgy
         fURwVP98hMmzSwQS2NYT110pEZopSlxlZuxQUppW/MqY94H8pPCJRsa3b0vbR/x3io6e
         obB72x2CtXhh9oXDglyigDBLJv/LVu59NLxaRryPYbWBmnC6z5yMlsUKGK5+gUl4Igrw
         Wr/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749829963; x=1750434763;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=npODHkhgO8HUf/TrEhpf2O2lbg1BmEemgLQdrUWSQ3w=;
        b=PPyxV8iUxl2z8P6QuXlmnnBWZozBfJsgDBzcHmac2V/tBQHxJG3X66HcXfObeWt+r9
         PAeNC/fRvzNF3g9Ae/3AO486LkYAHoVh5QROSPTQEmWt1S//Smas1Vga8ax8BDOXmqZt
         gaEKfwx14aayCnaBoSDIQaT0H+qjB+uejVEyxCLMyRB2J4NepujdXVjdBE6E87W3x4C0
         9BoTkYVkS8HUWUXrPZ1Z8YHhgsbpFVof9kBJW4Rt5ToGZBJ+vkRdltTA5P62Zt2tud7+
         kyL1HXkgtekJVaS7Cj9fVcjVoLDBPrNSyyyEv676nFM2ydtKur8JRwVmmCnWeHAqC5GE
         ourA==
X-Forwarded-Encrypted: i=1; AJvYcCU4niLb7xNZdNbUP7dUvOP3PQqu4d53+4zSa14bxEB3y3KyHhPOQXQ/hI/NwWxwF5bu4zw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwI+CR8oEp0v7pTwPYm4mlaTxXKI83nYXMd5BlZH9A4wiU8VixE
	z9tXvKwN9s4P9wsrL5aqwV6BbgkPO8atF46HNLZtiVu6MxUbeEaT702c9uPsHK/eIy/TfrVZDjz
	HW6hiJQYfDA==
X-Google-Smtp-Source: AGHT+IE/scb/Nv+7qkIju6i+DJdpAZR1xpyikSby5hJxXtJQQBp8fzkrPzsEKKxna1nAOeTY0IfW56wNZKrb
X-Received: from iovg22.prod.google.com ([2002:a05:6602:3d6:b0:875:c65d:8b3])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6602:3811:b0:861:7d39:d4d3
 with SMTP id ca18e2360f4ac-875d3c31a6fmr486593739f.3.1749829963134; Fri, 13
 Jun 2025 08:52:43 -0700 (PDT)
Date: Fri, 13 Jun 2025 15:52:34 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.rc2.692.g299adb8693-goog
Message-ID: <20250613155239.2029059-1-rananta@google.com>
Subject: [PATCH v3 0/4] KVM: arm64: Add attribute to control GICD_TYPER2.nASSGIcap
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Raghavendra Rao Anata <rananta@google.com>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

A shortcoming of the GIC architecture is that there's an absolute limit on
the number of vPEs that can be tracked by the ITS. It is possible that
an operator is running a mix of VMs on a system, only wanting to provide
a specific class of VMs with hardware interrupt injection support.

The series introduces KVM_DEV_ARM_VGIC_FEATURE_nASSGIcap vGIC attribute to allow
the userspace to control GICD_TYPER2.nASSGIcap (GICv4.1) on a per-VM basis.

v1: https://lore.kernel.org/kvmarm/20250514192159.1751538-1-rananta@google.com/

v1 -> v2: https://lore.kernel.org/all/20250531012545.709887-1-oliver.upton@linux.dev/
 - Drop all use of GICv4 in the UAPI and KVM-internal helpers in favor
   of nASSGIcap. This changes things around to model a guest feature,
   not a host feature.

 - Consolidate UAPI into a single attribute and expect userspace to use
   to read the attribute for discovery, much like we do with the ID
   registers

 - Squash documentation together with implementation

 - Clean up maintenance IRQ attribute handling, which I ran into as part
   of reviewing this series

v2 -> v3:
 - Update checks in vgic-v3.c and vgic-v4.c to also include nASSGIcap (via
   vgic_supports_direct_sgis()) that's configured by the userspace. (Oliver)

Oliver Upton (2):
  KVM: arm64: Disambiguate support for vSGIs v. vLPIs
  KVM: arm64: vgic-v3: Consolidate MAINT_IRQ handling

Raghavendra Rao Ananta (2):
  KVM: arm64: Introduce attribute to control GICD_TYPER2.nASSGIcap
  KVM: arm64: selftests: Add test for nASSGIcap attribute

 .../virt/kvm/devices/arm-vgic-v3.rst          | 29 ++++++
 arch/arm64/include/uapi/asm/kvm.h             |  3 +
 arch/arm64/kvm/vgic/vgic-init.c               |  7 +-
 arch/arm64/kvm/vgic/vgic-kvm-device.c         | 88 +++++++++++++------
 arch/arm64/kvm/vgic/vgic-mmio-v3.c            | 24 +++--
 arch/arm64/kvm/vgic/vgic-v3.c                 |  5 +-
 arch/arm64/kvm/vgic/vgic-v4.c                 |  6 +-
 arch/arm64/kvm/vgic/vgic.c                    |  4 +-
 arch/arm64/kvm/vgic/vgic.h                    |  7 ++
 include/kvm/arm_vgic.h                        |  3 +
 tools/testing/selftests/kvm/arm64/vgic_init.c | 41 +++++++++
 11 files changed, 176 insertions(+), 41 deletions(-)


base-commit: 19272b37aa4f83ca52bdf9c16d5d81bdd1354494
--
2.50.0.rc2.692.g299adb8693-goog


