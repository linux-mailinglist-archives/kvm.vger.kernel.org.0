Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCD93574AE
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 20:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239544AbhDGS7n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 14:59:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41650 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229512AbhDGS7l (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Apr 2021 14:59:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617821970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=NkCAWgC0VrbjMRUHCeE8lLva3Zw4UiswnpFOb19Ka4g=;
        b=O4oPzVfedPljaDmbAnG/+ryxfETShl8yvtcPQqM6y/maVfwaBopf8DhQDKKOlSZECJyVom
        TC6he1Px/h0J+7v9ZEv5Sw0librPl6vP11SueW5S2LUJvjlwb1/HH0UpTMo/7p1De46068
        uYC6iffpcSuBdPr0leN1C8vIj/lfOU0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-tRVJ4OjSPcu8CB9D7xiMKQ-1; Wed, 07 Apr 2021 14:59:26 -0400
X-MC-Unique: tRVJ4OjSPcu8CB9D7xiMKQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81A671006C85;
        Wed,  7 Apr 2021 18:59:25 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 370AC60CEA;
        Wed,  7 Apr 2021 18:59:20 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     alexandru.elisei@arm.com, nikos.nikoleris@arm.com,
        andre.przywara@arm.com, eric.auger@redhat.com
Subject: [PATCH kvm-unit-tests 0/8] arm/arm64: Prepare for target-efi
Date:   Wed,  7 Apr 2021 20:59:10 +0200
Message-Id: <20210407185918.371983-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series is a collection of patches derived from [1] that pave the
way for new targets, e.g. target-efi[2]. These patches mostly address
the elimination of memory map assumptions and they shouldn't have any
functional changes. The last two patches are a couple of patches not
related to the memory map, but they also prepare for bare metal targets.
I tossed them in since I don't think they should be too controversial.
This patch series is also available here [3].

[1] https://github.com/rhdrjones/kvm-unit-tests/commits/target-efi
[2] https://www.youtube.com/watch?v=kvaufVrL0J0
[3] https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/efiprep

Thanks,
drew


Andrew Jones (8):
  arm/arm64: Reorganize cstart assembler
  arm/arm64: Move setup_vm into setup
  pci-testdev: ioremap regions
  arm/arm64: mmu: Stop mapping an assumed IO region
  arm/arm64: mmu: Remove memory layout assumptions
  arm/arm64: setup: Consolidate memory layout assumptions
  chr-testdev: Silently fail init
  arm/arm64: psci: don't assume method is hvc

 arm/cstart.S           |  72 +++++++--------
 arm/cstart64.S         |  29 +++---
 arm/flat.lds           |  23 +++++
 arm/selftest.c         |  34 ++------
 lib/arm/asm/io.h       |   6 ++
 lib/arm/asm/mmu-api.h  |   1 +
 lib/arm/asm/mmu.h      |   1 +
 lib/arm/asm/page.h     |   2 +
 lib/arm/asm/psci.h     |   9 +-
 lib/arm/asm/setup.h    |   7 +-
 lib/arm/mmu.c          |  94 +++++++++++++++++---
 lib/arm/psci.c         |  17 +++-
 lib/arm/setup.c        | 194 +++++++++++++++++++++++++----------------
 lib/arm64/asm/io.h     |   6 ++
 lib/arm64/asm/mmu.h    |   1 +
 lib/arm64/asm/page.h   |   2 +
 lib/chr-testdev.c      |   5 +-
 lib/pci-host-generic.c |   5 +-
 lib/pci-host-generic.h |   4 +-
 lib/pci-testdev.c      |   4 +
 20 files changed, 339 insertions(+), 177 deletions(-)

-- 
2.26.3

