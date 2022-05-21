Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E117652F93F
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 08:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344858AbiEUGbo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 May 2022 02:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244691AbiEUGbk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 May 2022 02:31:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BB2C949920
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 23:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653114697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zHLMnhFySsFtf9jU9mylcGPoZOFPA7Ix+k7LYTrmjHI=;
        b=Wo/Feb6Z2eEpEVVCLMc/ZsAiHAWFYiC4h2gdcLN68jvZMnbmRVzARINWNboilkejXuHoWB
        PGsy92nDYCBcdeXs+LXF6gJshDyf6Qr4D50ObHcHrogY4ZuFVmpjOogAABbIa7hKUtmpM1
        oEc/WkzjZ+4AO7jfBtOliQtlIkCS/cA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-A_xWFjfdPsmzqH_86f1x9Q-1; Sat, 21 May 2022 02:31:34 -0400
X-MC-Unique: A_xWFjfdPsmzqH_86f1x9Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C7BF5185A7A4;
        Sat, 21 May 2022 06:31:33 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AB03EC4C7A0;
        Sat, 21 May 2022 06:31:33 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] Final batch of KVM fixes for 5.18
Date:   Sat, 21 May 2022 02:31:33 -0400
Message-Id: <20220521063133.70137-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 053d2290c0307e3642e75e0185ddadf084dc36c1:

  KVM: VMX: Exit to userspace if vCPU has injected exception and invalid state (2022-05-06 13:08:06 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 9f46c187e2e680ecd9de7983e4d081c3391acc76:

  KVM: x86/mmu: fix NULL pointer dereference on guest INVPCID (2022-05-20 13:49:52 -0400)

Sorry for the relatively large change so close to the release, but in
terms of lines added it's mostly selftests.

----------------------------------------------------------------
ARM:
* Correctly expose GICv3 support even if no irqchip is created
  so that userspace doesn't observe it changing pointlessly
  (fixing a regression with QEMU)

* Don't issue a hypercall to set the id-mapped vectors when
  protected mode is enabled (fix for pKVM in combination with
  CPUs affected by Spectre-v3a)

x86: Five oneliners, of which the most interesting two are:

* a NULL pointer dereference on INVPCID executed with
  paging disabled, but only if KVM is using shadow paging

* an incorrect bsearch comparison function which could truncate
  the result and apply PMU event filtering incorrectly.  This one
  comes with a selftests update too.

----------------------------------------------------------------
Aaron Lewis (3):
      kvm: x86/pmu: Fix the compare function used by the pmu event filter
      selftests: kvm/x86: Add the helper function create_pmu_event_filter
      selftests: kvm/x86: Verify the pmu event filter matches the correct event

Marc Zyngier (1):
      KVM: arm64: vgic-v3: Consistently populate ID_AA64PFR0_EL1.GIC

Paolo Bonzini (2):
      Merge tag 'kvmarm-fixes-5.18-3' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      KVM: x86/mmu: fix NULL pointer dereference on guest INVPCID

Quentin Perret (1):
      KVM: arm64: Don't hypercall before EL2 init

Sean Christopherson (2):
      KVM: x86/mmu: Update number of zapped pages even if page list is stable
      KVM: Free new dirty bitmap if creating a new memslot fails

Wanpeng Li (1):
      KVM: eventfd: Fix false positive RCU usage warning

Yury Norov (1):
      KVM: x86: hyper-v: fix type of valid_bank_mask

 arch/arm64/kvm/arm.c                               |  3 +-
 arch/arm64/kvm/sys_regs.c                          |  3 +-
 arch/x86/kvm/hyperv.c                              |  4 +--
 arch/x86/kvm/mmu/mmu.c                             | 16 ++++++----
 arch/x86/kvm/pmu.c                                 |  7 ++--
 .../selftests/kvm/x86_64/pmu_event_filter_test.c   | 37 +++++++++++++++++++---
 virt/kvm/eventfd.c                                 |  3 +-
 virt/kvm/kvm_main.c                                |  2 +-
 8 files changed, 56 insertions(+), 19 deletions(-)

