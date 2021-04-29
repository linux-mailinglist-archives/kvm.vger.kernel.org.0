Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E51D36EE4C
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 18:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240748AbhD2Qma (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 12:42:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43700 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233099AbhD2Qm3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Apr 2021 12:42:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619714502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=KJvPIMRIaEUaTRVTXR0nZcXfhBmX/xq1gsZgnD2mQyg=;
        b=DP6ld4Q0wi3klN3RBagLgIncNpgmjQ5AN9yI2Xj5vwd9IGypQXMzxcYwsgrLNpzlPzR7L4
        vIBQL6BUwndeEShqk4SN8efdQhIc5atUI99+dq3thCqxQyf3Mwe0FllZP5o2zcZznRrMms
        bCOTwqi57Ewmr8VdEtt6/NlPcTfCWqw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-5vcgWDx7O0Ge58de1s8vJw-1; Thu, 29 Apr 2021 12:41:39 -0400
X-MC-Unique: 5vcgWDx7O0Ge58de1s8vJw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 865F91B18BC8;
        Thu, 29 Apr 2021 16:41:38 +0000 (UTC)
Received: from gator.redhat.com (unknown [10.40.192.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF3DF64184;
        Thu, 29 Apr 2021 16:41:31 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     alexandru.elisei@arm.com, nikos.nikoleris@arm.com,
        andre.przywara@arm.com, eric.auger@redhat.com
Subject: [PATCH kvm-unit-tests v3 0/8] arm/arm64: Prepare for target-efi
Date:   Thu, 29 Apr 2021 18:41:22 +0200
Message-Id: <20210429164130.405198-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v3:
 - Picked up Alex's r-b on patch 1 and 5
 - Removed useless cast in pci_host_bridge_get_paddr [Andre]
 - Added XN bits when mapping I/O pages [Alex]
 - Tweaks to patch 6 suggested by Alex and myself
 - Improved patch 8 commit message and changed psci-invoke's input
   and output parameter types

v2:
 - Addressed all comments from Nikos and Alex
 - The biggest changes are
   * dropping the weird persistent map stuff that I never liked by taking
     Alex's suggestion to just create the idmap early
   * adding mem_region_add() to clean up memory region adding code, also
     improved the assignment of region fields
 - Also, while we found that we still have a memory map assumption
   (3G-4G reserved for virtual memory allocation), I only make that
   assumption clear. I've left removing it for an additional patch
   for another day.
 - Added psci_invoke_none() to use prior to the PSCI method being set
 - Added r-b's for each patch given, unless the commit changed too much
 - Didn't take Alex's suggestion to use x5 for stacktop when calling
   setup from start. I prefer explicitly loading it again.


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
  arm/arm64: psci: Don't assume method is hvc

 arm/cstart.S                |  92 ++++++++++++-------
 arm/cstart64.S              |  45 ++++++---
 arm/flat.lds                |  23 +++++
 arm/selftest.c              |  34 ++-----
 lib/arm/asm/io.h            |   6 ++
 lib/arm/asm/mmu.h           |   3 +
 lib/arm/asm/page.h          |   2 +
 lib/arm/asm/pgtable-hwdef.h |   1 +
 lib/arm/asm/psci.h          |  10 +-
 lib/arm/asm/setup.h         |   7 +-
 lib/arm/mmu.c               |  53 +++++++----
 lib/arm/psci.c              |  35 +++++--
 lib/arm/setup.c             | 177 +++++++++++++++++++++---------------
 lib/arm64/asm/io.h          |   6 ++
 lib/arm64/asm/mmu.h         |   1 +
 lib/arm64/asm/page.h        |   2 +
 lib/chr-testdev.c           |   5 +-
 lib/pci-host-generic.c      |   5 +-
 lib/pci-host-generic.h      |   4 +-
 lib/pci-testdev.c           |   4 +
 20 files changed, 335 insertions(+), 180 deletions(-)

-- 
2.30.2

