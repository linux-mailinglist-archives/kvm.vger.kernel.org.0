Return-Path: <kvm+bounces-46540-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CFA7AB75C3
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 21:23:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4BB041BA1281
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 19:23:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60637294A12;
	Wed, 14 May 2025 19:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UJ+nSYMP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9428E28E576
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 19:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747250530; cv=none; b=jqAkXRpF45XKqToRpUB2YZGrTfvOukg6VnF+PlEudWSZkXa6UAjDpd/yJGLbwtLqFmPirix7t1wCcIC+bkMs24ZEod+pBLWE5zabf9//RwVNiiZEZ9HyOCIXsyKd+R/TIIu5Z1fyolwlvQK0FNh66+6aX+PUNd+xknuhu3Vc2CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747250530; c=relaxed/simple;
	bh=6GLh2vAUb131giOvQk8M/um3okSJGroCjyJghDkewc8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=mrUyHUGykjrttZOTuZlJaLhVo8Nm4xIpd9OcKSZ6Llztn+1Uud4x3QLYpN+Ns0WA6e6QPfxwe+bl6Pd+TqtEEBYC4oHJslDfZNHERjEuLPrn3Akn+WZUPMuOfvrQoOL5j7bXEiSk40efTyD0/JVDOwW48kGC5e4frzkTjaMLq9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UJ+nSYMP; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3da6f284ca5so2501525ab.1
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 12:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747250525; x=1747855325; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=c8ePtC5HFZo+bckSClZmheBHRBfYWwooCNAcmQiJQhY=;
        b=UJ+nSYMPX7xyaXdluGbrLXYlIgkX+ncmsGE1ZoopKj/U8aYSeceM5ClmY34DUvOXyf
         Jdf7ptUaJ8+ePDlJy+UNpxwSWbaxdASi+u0gYEZevbJVahqMlHbPtNGIvyJyiJ1zIBw1
         dSbtIkKdfB49tj3Ew57ph7EyrrnZONv2FtVwdAWuNMFOkjTnhFxbKILXFkgPl289t+Ph
         zYaKmTnc008o8tVFgk/ZMhj2Pyo869S3kj8OB1ownMrUBq+8X9XZwWSrcXNRaHaTmH1l
         RIxJqTomrn1FuuB8GOENr6Jg68fjGwAiBToF29W0+JKRn2cvte4X5j3kCg4VhJYheNei
         XTug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747250525; x=1747855325;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c8ePtC5HFZo+bckSClZmheBHRBfYWwooCNAcmQiJQhY=;
        b=nfDrgdvjj7M2fU5DS7FYm18SG8/aUVDD1/demOlygdHWZckbIKOTNecxfVm+G9Xuwn
         rfnemwCh5rm38G9Klq6IQDI6UJENEFtFgCz4VEKzPyqEI70VmQAhvn/7RVU8amd6ObGr
         9Iy5cZ+XpgqhvoFGQlpRDRk7pzyjDlbhnbFSvpq7M6emOARBd2i6sNt4V0QdEVxIAAXY
         GzgDykbEuj7KecMWldhh8CZ5F6hL6mxMBlrH/iUDv3S8Gc6Jz3LfJ2dbRAl0b3nEUakG
         mDzt/UC68obK7X6jAOcfuSrCSuIhcO96aArASBdf8AlMBj2gULA40wSEt2EiuJS6bPHQ
         yJZQ==
X-Forwarded-Encrypted: i=1; AJvYcCXkhIe9Krvb5Q0qyu+hc1dJxhZbeW6tzRl1ljC0hgysgjfHd1ebITYDSd3pDWejeySNmVw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXSnG84bU05kor5Sn1PFABjpWQ9EQQIL2jqh0MGXtj53cQFdCE
	wBKQY+kYwwOL+yGnlW3UbBV7rFUomO3iuSzl5skAMwT4KiejuGVTxjjW2OXq8vzngbE1oefjKzJ
	tqNPniQ==
X-Google-Smtp-Source: AGHT+IF1ogsTmn2Q4LFsh6tOmFxWnhQ3nGtiA78U3XsyCpRhWXAptzz3zxmhkhTqbmqZ1kXN3wTOk6bikL9+
X-Received: from ilbbt9.prod.google.com ([2002:a05:6e02:2489:b0:3d9:37ff:afd7])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6e02:178f:b0:3d6:cbad:235c
 with SMTP id e9e14a558f8ab-3db6f7ad141mr53575415ab.6.1747250525722; Wed, 14
 May 2025 12:22:05 -0700 (PDT)
Date: Wed, 14 May 2025 19:21:56 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250514192159.1751538-1-rananta@google.com>
Subject: [PATCH 0/3] KVM: arm64: Allow vGICv4 configuration per VM
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Raghavendra Rao Anata <rananta@google.com>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

When kvm-arm.vgic_v4_enable=1, KVM adds support for direct interrupt
injection by default to all the VMs in the system, aka GICv4. A
shortcoming of the GIC architecture is that there's an absolute limit on
the number of vPEs that can be tracked by the ITS. It is possible that
an operator is running a mix of VMs on a system, only wanting to provide
a specific class of VMs with hardware interrupt injection support.

To support this, introduce a GIC attribute, KVM_DEV_ARM_VGIC_CONFIG_GICV4,
for the userspace to enable or disable vGICv4 for a given VM.

The attribute allows the configuration only when vGICv4 is enabled in KVM,
else it acts a read-only attribute returning
KVM_DEV_ARM_VGIC_CONFIG_GICV4_UNAVAILABLE as the value.

On the other hand, if KVM has the vGICv4 enabled via the cmdline, the
VM absorbs this configuration by default to maintain the backward
compatibility. Userspace can get the attribute's value to check if the VM
has vGICv4 support if it sees KVM_DEV_ARM_VGIC_CONFIG_GICV4_ENABLE as the
value. As required, it can disable vGICv4 by setting
KVM_DEV_ARM_VGIC_CONFIG_GICV4_DISABLE as the value.

The patches are distrubuted as:

Patch-1 contains the KVM code that introduces the
KVM_DEV_ARM_VGIC_CONFIG_GICV4 attr, and adds all the support around it.

Patch-2 adds the documentation for the said attribute.

Patch-3 extends the vgic_init kvm/arm64 selftest that tests the get and
set of this attribute in various configurations.

Thank you.
Raghavendra

Raghavendra Rao Ananta (3):
  kvm: arm64: Add support for KVM_DEV_ARM_VGIC_CONFIG_GICV4 attr
  docs: kvm: devices/arm-vgic-v3: Document KVM_DEV_ARM_VGIC_CONFIG_GICV4
    attr
  KVM: selftests: Extend vgic_init to test GICv4 config attr

 .../virt/kvm/devices/arm-vgic-v3.rst          | 24 ++++++--
 arch/arm64/include/uapi/asm/kvm.h             |  7 +++
 arch/arm64/kvm/vgic/vgic-init.c               |  3 +
 arch/arm64/kvm/vgic/vgic-its.c                |  2 +-
 arch/arm64/kvm/vgic/vgic-kvm-device.c         | 39 +++++++++++++
 arch/arm64/kvm/vgic/vgic-mmio-v3.c            | 12 ++--
 arch/arm64/kvm/vgic/vgic-v3.c                 | 16 ++++-
 arch/arm64/kvm/vgic/vgic-v4.c                 |  8 +--
 include/kvm/arm_vgic.h                        |  5 ++
 tools/testing/selftests/kvm/arm64/vgic_init.c | 58 +++++++++++++++++++
 10 files changed, 157 insertions(+), 17 deletions(-)


base-commit: 0af2f6be1b4281385b618cb86ad946eded089ac8
--
2.49.0.1101.gccaa498523-goog


