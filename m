Return-Path: <kvm+bounces-5803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 37692826EF0
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 13:51:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5BC2D1C22676
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 12:51:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 668784643F;
	Mon,  8 Jan 2024 12:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DuyS+/xl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C3D45C05
	for <kvm@vger.kernel.org>; Mon,  8 Jan 2024 12:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704718064;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=w0Q64qRS24vLSDJ2TMtwfrBRVHYfXw6VdqdfXhfOLyM=;
	b=DuyS+/xlfDFoV5zwOGoUp0Icq+oI9o9Vu6tiwE34klW6TmCP0coknUv5Hf8w3Gay2k7Iea
	XVwRUwI6VM3UAymvq4uzsrJ+jYBY2F6HBiPquc36htZj11cmDArkNMVlgYt1XlcN7+BzXe
	afeB50OqXymkjM55f/Bp311B42oN4NI=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-404-XO9vZfuYOtOcTfuPGANvng-1; Mon,
 08 Jan 2024 07:47:41 -0500
X-MC-Unique: XO9vZfuYOtOcTfuPGANvng-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 49AA23C2AF72;
	Mon,  8 Jan 2024 12:47:41 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CCCF03C39;
	Mon,  8 Jan 2024 12:47:40 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: ajones@ventanamicro.com,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Alex Williamson <alex.williamson@redhat.com>,
	x86@kernel.org,
	kbingham@kernel.org
Subject: [PATCH v2 0/5] Replace CONFIG_HAVE_KVM with more appropriate symbols.
Date: Mon,  8 Jan 2024 07:47:35 -0500
Message-Id: <20240108124740.114453-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

CONFIG_HAVE_KVM is currently used with three meanings:

- some architectures use it to enabled the KVM config proper, depending
  on CPU capabilities (MIPS)

- some architectures use it to enable host-side code that is not part of
  the KVM module (x86)

- to enable common Kconfigs required by all architectures that support
  KVM, currently CONFIG_EVENTFD

These three meanings can be replaced respectively by an architecture-
specific Kconfig, by IS_ENABLED(CONFIG_KVM), or by a new Kconfig symbol
that is in turn selected by the architecture-specific "config KVM".
This is what each of the first three patches does.  After this,
CONFIG_HAVE_KVM is unused and can be removed.

This fixes architectures (PPC and RISC-V) that do not have CONFIG_HAVE_KVM=y
and therefore fail to select CONFIG_EVENTFD.  Patch 1, and probably patch 2
too, will be quickly applied to 6.8 to fix this build failure.  The rest
can be delayed to the early -rc period, or 6.9 if desired.

Paolo

Paolo Bonzini (5):
  KVM: introduce CONFIG_KVM_COMMON
  KVM: fix direction of dependency on MMU notifiers
  MIPS: introduce Kconfig for MIPS VZ
  x86, vfio, gdb: replace CONFIG_HAVE_KVM with IS_ENABLED(CONFIG_KVM)
  treewide: remove CONFIG_HAVE_KVM

 arch/arm64/Kconfig                       |  1 -
 arch/arm64/kvm/Kconfig                   |  4 +---
 arch/loongarch/Kconfig                   |  1 -
 arch/loongarch/kvm/Kconfig               |  3 +--
 arch/mips/Kconfig                        | 18 +++++++++---------
 arch/mips/kvm/Kconfig                    |  5 ++---
 arch/powerpc/kvm/Kconfig                 |  3 +--
 arch/riscv/kvm/Kconfig                   |  2 +-
 arch/s390/Kconfig                        |  1 -
 arch/s390/kvm/Kconfig                    |  4 +---
 arch/x86/Kconfig                         |  1 -
 arch/x86/include/asm/hardirq.h           |  2 +-
 arch/x86/include/asm/idtentry.h          |  2 +-
 arch/x86/include/asm/irq.h               |  2 +-
 arch/x86/include/asm/irq_vectors.h       |  2 +-
 arch/x86/kernel/idt.c                    |  2 +-
 arch/x86/kernel/irq.c                    |  4 ++--
 arch/x86/kvm/Kconfig                     |  5 +----
 drivers/vfio/vfio.h                      |  2 +-
 drivers/vfio/vfio_main.c                 |  4 ++--
 scripts/gdb/linux/constants.py.in        |  6 +++++-
 scripts/gdb/linux/interrupts.py          |  2 +-
 tools/arch/x86/include/asm/irq_vectors.h |  2 +-
 virt/kvm/Kconfig                         |  6 ++++--
 24 files changed, 38 insertions(+), 46 deletions(-)

-- 
2.39.1


