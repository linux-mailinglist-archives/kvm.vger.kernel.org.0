Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E863E73A92D
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 21:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbjFVTxw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 15:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbjFVTxm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 15:53:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E16F51A4
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 12:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687463574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7vU8QPmdZqu4z7tpQFcomFouaY+QXdNIla3hFK3xbZM=;
        b=fV4uSOWl4gqR7cQBcQi/ZZ8Bm8Smq2jgPje/kMiYvgaG9GmAUQSIP4bspZaGAtJS9lWB4y
        DW3qB3FSi9EBXV4F7je9OHzy+XEFkcHMFMV3kNI/xP5IN5wJOKQ/tI2Obqd+a5in3hgTnX
        Fz2CuwJZLzzdShlWLKBVcTUAxHidBm8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-l9hCohxaP7WlVutRYV6Pkg-1; Thu, 22 Jun 2023 15:52:49 -0400
X-MC-Unique: l9hCohxaP7WlVutRYV6Pkg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 12BF1858290;
        Thu, 22 Jun 2023 19:52:48 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E991D2166B25;
        Thu, 22 Jun 2023 19:52:47 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] Final KVM fixes for Linux 6.4
Date:   Thu, 22 Jun 2023 15:52:47 -0400
Message-Id: <20230622195247.3984207-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit f211b45057d8b0264b494f1acebf2e8d7f9432c9:

  Merge tag 'kvm-x86-fixes-6.4' of https://github.com/kvm-x86/linux into HEAD (2023-06-03 15:16:58 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 2623b3dc875a3c92dd0e0775cd19fbaeef0574ca:

  Merge tag 'kvmarm-fixes-6.4-4' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2023-06-22 15:28:26 -0400)

A few remaining ARM patches, and a race condition fix that has had quite
a few eyes but I only managed to commit today due to some travelling
(commit 2230f9e1171a, "KVM: Avoid illegal stage2 mapping on invalid
memory slot").  The fix is relatively simple once you see it, and it's
been tested and reviewed thoroughly.

Paolo

----------------------------------------------------------------
ARM:

* Correctly save/restore PMUSERNR_EL0 when host userspace is using
  PMU counters directly

* Fix GICv2 emulation on GICv3 after the locking rework

* Don't use smp_processor_id() in kvm_pmu_probe_armpmu(), and
  document why

Generic:

* Avoid setting page table entries pointing to a deleted memslot if a
  host page table entry is changed concurrently with the deletion.

----------------------------------------------------------------
Gavin Shan (1):
      KVM: Avoid illegal stage2 mapping on invalid memory slot

Marc Zyngier (1):
      KVM: arm64: Restore GICv2-on-GICv3 functionality

Oliver Upton (1):
      KVM: arm64: Use raw_smp_processor_id() in kvm_pmu_probe_armpmu()

Paolo Bonzini (1):
      Merge tag 'kvmarm-fixes-6.4-4' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD

Reiji Watanabe (2):
      KVM: arm64: PMU: Restore the host's PMUSERENR_EL0
      KVM: arm64: PMU: Don't overwrite PMUSERENR with vcpu loaded

 arch/arm/include/asm/arm_pmuv3.h        |  5 +++++
 arch/arm64/include/asm/kvm_host.h       |  7 +++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 15 +++++++++++++--
 arch/arm64/kvm/hyp/vhe/switch.c         | 14 ++++++++++++++
 arch/arm64/kvm/pmu-emul.c               | 20 +++++++++++++++++++-
 arch/arm64/kvm/pmu.c                    | 27 +++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-init.c         | 11 +++++++----
 drivers/perf/arm_pmuv3.c                | 21 ++++++++++++++++++---
 virt/kvm/kvm_main.c                     | 20 +++++++++++++++++++-
 9 files changed, 129 insertions(+), 11 deletions(-)

