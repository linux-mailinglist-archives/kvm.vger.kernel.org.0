Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E44AB38323F
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 16:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239829AbhEQOql (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 10:46:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59337 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240102AbhEQOlJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 May 2021 10:41:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621262393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6kIdcUmp0r2WYnKZLj1RjFphLqUVXo6zTFWvfj/yTTo=;
        b=OaNaoXqb+cJbA1JReXpfsDQ/JgLa3lmcjtZTERWYaOfOo9T9nbModKFMEyfL281DgaY61d
        rhifAeIkXBW7hvdAYDF8N/egnHQ1kc0hz7nlqPofsPu99Zc/ka/qsi5fO7tCtz5rUrp9bA
        rjws+NYqVGbCgWvr+VDKGJLqZpVF7DY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-rBk7TUJYMmGPukhYO0FXJA-1; Mon, 17 May 2021 10:39:50 -0400
X-MC-Unique: rBk7TUJYMmGPukhYO0FXJA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2C99ABBF1D
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 14:39:03 +0000 (UTC)
Received: from gator.redhat.com (unknown [10.40.192.248])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 29FA95D6D7;
        Mon, 17 May 2021 14:39:01 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PULL kvm-unit-tests 00/10] arm/arm64: target-efi prep
Date:   Mon, 17 May 2021 16:38:50 +0200
Message-Id: <20210517143900.747013-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The patches mostly prepare kvm-unit-tests/arm for targeting EFI
platforms. The actually EFI support will come in another series,
but these patches are good for removing assumptions from our memory
maps and about our PSCI conduit, even if we never merged EFI support.

Thanks,
drew


The following changes since commit 9e7a5929569d61414feefcb1d8024e7685cb7eb3:

  arm: add eabi version of 64-bit division functions (2021-05-12 15:52:24 +0200)

are available in the Git repository at:

  https://gitlab.com/rhdrjones/kvm-unit-tests.git arm/queue

for you to fetch changes up to bd5bd1577dcc298cafaf0e26d318a628e650b2a7:

  arm/arm64: psci: Don't assume method is hvc (2021-05-17 16:08:24 +0200)

----------------------------------------------------------------
Alexandru Elisei (1):
      configure: arm: Replace --vmm with --target

Andrew Jones (9):
      arm/arm64: Reorganize cstart assembler
      arm/arm64: Move setup_vm into setup
      pci-testdev: ioremap regions
      arm64: micro-bench: ioremap userspace_emulated_addr
      arm/arm64: mmu: Stop mapping an assumed IO region
      arm/arm64: mmu: Remove memory layout assumptions
      arm/arm64: setup: Consolidate memory layout assumptions
      chr-testdev: Silently fail init
      arm/arm64: psci: Don't assume method is hvc

 arm/cstart.S                |  92 +++++++++++++++--------
 arm/cstart64.S              |  45 ++++++++---
 arm/flat.lds                |  23 ++++++
 arm/micro-bench.c           |  26 ++++---
 arm/selftest.c              |  34 ++-------
 configure                   |  30 +++++---
 lib/arm/asm/io.h            |   6 ++
 lib/arm/asm/mmu.h           |   3 +
 lib/arm/asm/page.h          |   2 +
 lib/arm/asm/pgtable-hwdef.h |   1 +
 lib/arm/asm/psci.h          |  10 ++-
 lib/arm/asm/setup.h         |   7 +-
 lib/arm/mmu.c               |  53 ++++++++-----
 lib/arm/psci.c              |  35 +++++++--
 lib/arm/setup.c             | 177 ++++++++++++++++++++++++++------------------
 lib/arm64/asm/io.h          |   6 ++
 lib/arm64/asm/mmu.h         |   1 +
 lib/arm64/asm/page.h        |   2 +
 lib/chr-testdev.c           |   5 +-
 lib/pci-host-generic.c      |   5 +-
 lib/pci-host-generic.h      |   4 +-
 lib/pci-testdev.c           |   4 +
 22 files changed, 372 insertions(+), 199 deletions(-)

