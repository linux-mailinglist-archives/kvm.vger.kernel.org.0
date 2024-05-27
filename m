Return-Path: <kvm+bounces-18157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B8D48CF90D
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 08:28:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 71C611C20B57
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 06:28:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 916E417C79;
	Mon, 27 May 2024 06:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=t-8ch.de header.i=@t-8ch.de header.b="WnWYpRk8"
X-Original-To: kvm@vger.kernel.org
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD99117BB6
	for <kvm@vger.kernel.org>; Mon, 27 May 2024 06:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.69.126.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716791288; cv=none; b=qUFhGHR5ibv/ztuP0QSuCUiMSHTsf73VNiTNqXujaj5zSQHH5sIfjtZBwxw3fyYMLqBlZH8twv5nZoiFVQUuDu7oqEKjBLYjXJyo2Bzv2p4i1/sqCVPJlB1B5gJswx4JLzHSvGK96lKP2v/dp/GdGWigxscJocDA4hP91GXpv3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716791288; c=relaxed/simple;
	bh=jS5+tWV1ahyUgtn/S1gImAhsQfwDBISaxk4G8lxGqTc=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=cG/T8XnI0Lflr9hCNMyfgdYG75Czk0ilqctG/sSHXD6mCogx9Y3/EfdilGSLLKhnMFOn4LCymio95LC7YQn1FhqwAE05eXpPaZvDdywTLxaABPm/SIbdazQ3dcMFI4L+p+IqgwpbIdZDV2+Z1BolTxZKxGD3+7c/PC7lukd2ZIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=t-8ch.de; spf=pass smtp.mailfrom=t-8ch.de; dkim=pass (1024-bit key) header.d=t-8ch.de header.i=@t-8ch.de header.b=WnWYpRk8; arc=none smtp.client-ip=159.69.126.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=t-8ch.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=t-8ch.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=t-8ch.de; s=mail;
	t=1716791283; bh=jS5+tWV1ahyUgtn/S1gImAhsQfwDBISaxk4G8lxGqTc=;
	h=From:Subject:Date:To:Cc:From;
	b=WnWYpRk8Gh7omZF+DL/NlfWABvlT8Qi0npBawdDMDN8kgb6Uu3HTdbCvulODMLWC0
	 OPUD8B0gKu8QoBpc3Ga9B7I/N1AvZC9Elr10SMeNivKiSynF83j6NKD0YacHMMJig5
	 bRZ1/WiFa64NPZEdYL/Lhf8w9LTX9g31CH49U6LI=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas@t-8ch.de>
Subject: [PATCH v8 0/8] update linux headers to v6.10-rc1 and shutdown
 support for pvpanic
Date: Mon, 27 May 2024 08:27:46 +0200
Message-Id: <20240527-pvpanic-shutdown-v8-0-5a28ec02558b@t-8ch.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAOInVGYC/33QzWrEIBQF4FcZXNdy1Xv96arvMXShxjRukpCk6
 ZQh714zUCYE6fJc+M5B72xOU04ze7vc2ZTWPOehL8G+XFjsfP+ZeG5KZhKkEgKQj+vo+xz53H0
 tzfDdc5AJA8aADh0rbJxSm2+PyutHyV2el2H6eSysYr/+U7YKDqVRkRJkrBPhfeE2dq9NYnvXK
 g9e2oqXxVsFyqmAFIM+eXX0ruJV8dF5aZ1sI0l18vjnEQSYisd9XxCANwnBipOng6/uU/EtedA
 QrIkGT14/vYTa+3XxThNZ8BHInP/PPL2SquJN8eijaBtC3ej24Ldt+wVpmDKGLwIAAA==
To: "Michael S. Tsirkin" <mst@redhat.com>, 
 Cornelia Huck <cohuck@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>
Cc: qemu-devel@nongnu.org, 
 Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, kvm@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas@t-8ch.de>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1716791282; l=5638;
 i=thomas@t-8ch.de; s=20221212; h=from:subject:message-id;
 bh=jS5+tWV1ahyUgtn/S1gImAhsQfwDBISaxk4G8lxGqTc=;
 b=8xPidmDShbYSEsGFCGCOFycfN1dSSfrWfdM2iqWYT9aHS2rq/T5UPD5TkX5b3+9dFeZK8YT9z
 lLmVEEoyC/xDVHo4jfC9YWMo/3QKW7Pzic5t2y+8lKpuZ4G0RYRgy5V
X-Developer-Key: i=thomas@t-8ch.de; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=

Shutdown requests are normally hardware dependent.
By extending pvpanic to also handle shutdown requests, guests can
submit such requests with an easily implementable and cross-platform
mechanism.

The background is the usage of minimal Linux kernels with different
architectures for testing purposes.
Poweroff support varies highly per architecture and requires a bunch of
code to be compiled to work.
pvpanic on the other hand is very small and uniform.

Patch 1 is a fix for scripts/update-linux-headers.sh
Patch 2 updates the bundled linux headers to Linux v6.10-rc1.

Patch 3 and 4 are general cleanups, which seem useful even without this
proposal being implemented.
They should also be ready to be picked up from the series on their own.

The remaining patches implement the new functionality and update the
docs.

The matching driver for Linux is part of Linux v6.10-rc1.

To: Michael S. Tsirkin <mst@redhat.com>
To: Cornelia Huck <cohuck@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
To: Thomas Huth <thuth@redhat.com>
To: Laurent Vivier <lvivier@redhat.com>
To: Eric Blake <eblake@redhat.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: qemu-devel@nongnu.org
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Cc: kvm@vger.kernel.org
Signed-off-by: Thomas Weißschuh <thomas@t-8ch.de>

Changes in v8:
- Import linux headers from v6.10-rc1 (and update series subject)
- Use PVPANIC_SHUTDOWN from new linux headers
- Update Since: tag in QAPI to 9.1
- Link to v7: https://lore.kernel.org/r/20240323-pvpanic-shutdown-v7-0-4ac1fd546d6f@t-8ch.de

Changes in v7:
- Keep standard-header/pvpanic.h
- Predefine PVPANIC_SHUTDOWN in include/hw/misc/pvpanic.h
- Fix alignment in QAPI to comply with newly enforced layout
- Update Since: tag in QAPI to 9.0
- Drop note from pvpanic spec about missing implementation
- Link to v6: https://lore.kernel.org/r/20240208-pvpanic-shutdown-v6-0-965580ac057b@t-8ch.de

Changes in v6:
- Replace magic constant "4" in tests with PVPANIC_SHUTDOWN
- Link to v5: https://lore.kernel.org/r/20240129-pvpanic-shutdown-v5-0-f5a060b87c74@t-8ch.de

Changes in v5:
- Add patch from Alejandro to emit a QMP event.
- Update cover letter.
- Add tests.
- Link to v4: https://lore.kernel.org/r/20240107-pvpanic-shutdown-v4-0-81500a7e4081@t-8ch.de

Changes in v4:
- Rebase on 8.2 master
- Resend after tree reopened and holidays
- Link to v3: https://lore.kernel.org/r/20231129-pvpanic-shutdown-v3-0-c9a2892fc523@t-8ch.de

Changes in v3:
- Drop from Linux imported pvpanic header as discussed with Cornelia and
  requested by Greg
- Link to v2: https://lore.kernel.org/r/20231128-pvpanic-shutdown-v2-0-830393b45cb6@t-8ch.de

Changes in v2:
- Remove RFC status
- Add Ack from Thomas to 2nd patch
- Fix typo in title of 2nd patch
- Link to v1: https://lore.kernel.org/r/20231104-pvpanic-shutdown-v1-0-02353157891b@t-8ch.de

---
Alejandro Jimenez (1):
      pvpanic: Emit GUEST_PVSHUTDOWN QMP event on pvpanic shutdown signal

Thomas Weißschuh (7):
      scripts/update-linux-headers: Copy setup_data.h to correct directory
      linux-headers: update to 6.10-rc1
      hw/misc/pvpanic: centralize definition of supported events
      tests/qtest/pvpanic: use centralized definition of supported events
      hw/misc/pvpanic: add support for normal shutdowns
      tests/qtest/pvpanic: add tests for pvshutdown event
      Revert "docs/specs/pvpanic: mark shutdown event as not implemented"

 docs/specs/pvpanic.rst                      |   2 +-
 hw/misc/pvpanic-isa.c                       |   3 +-
 hw/misc/pvpanic-pci.c                       |   3 +-
 hw/misc/pvpanic.c                           |   8 +-
 include/hw/misc/pvpanic.h                   |   4 +
 include/standard-headers/linux/ethtool.h    |  55 +++++++++++
 include/standard-headers/linux/pci_regs.h   |   6 ++
 include/standard-headers/linux/pvpanic.h    |   7 +-
 include/standard-headers/linux/virtio_bt.h  |   1 -
 include/standard-headers/linux/virtio_mem.h |   2 +
 include/standard-headers/linux/virtio_net.h | 143 ++++++++++++++++++++++++++++
 include/sysemu/runstate.h                   |   1 +
 linux-headers/asm-generic/unistd.h          |   5 +-
 linux-headers/asm-loongarch/kvm.h           |   4 +
 linux-headers/asm-mips/unistd_n32.h         |   1 +
 linux-headers/asm-mips/unistd_n64.h         |   1 +
 linux-headers/asm-mips/unistd_o32.h         |   1 +
 linux-headers/asm-powerpc/unistd_32.h       |   1 +
 linux-headers/asm-powerpc/unistd_64.h       |   1 +
 linux-headers/asm-riscv/kvm.h               |   1 +
 linux-headers/asm-s390/unistd_32.h          |   1 +
 linux-headers/asm-s390/unistd_64.h          |   1 +
 linux-headers/asm-x86/kvm.h                 |   4 +-
 linux-headers/asm-x86/unistd_32.h           |   1 +
 linux-headers/asm-x86/unistd_64.h           |   1 +
 linux-headers/asm-x86/unistd_x32.h          |   2 +
 linux-headers/linux/kvm.h                   |   4 +-
 linux-headers/linux/stddef.h                |   8 ++
 linux-headers/linux/vhost.h                 |  15 +--
 qapi/run-state.json                         |  14 +++
 scripts/update-linux-headers.sh             |   2 +-
 system/runstate.c                           |   6 ++
 tests/qtest/pvpanic-pci-test.c              |  44 ++++++++-
 tests/qtest/pvpanic-test.c                  |  34 ++++++-
 34 files changed, 361 insertions(+), 26 deletions(-)
---
base-commit: 60b54b67c63d8f076152e0f7dccf39854dfc6a77
change-id: 20231104-pvpanic-shutdown-02e4b4cb4949

Best regards,
-- 
Thomas Weißschuh <thomas@t-8ch.de>


