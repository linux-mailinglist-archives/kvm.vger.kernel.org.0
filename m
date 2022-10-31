Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A378612E57
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 01:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbiJaAiy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Oct 2022 20:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJaAiw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Oct 2022 20:38:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F1355FB4
        for <kvm@vger.kernel.org>; Sun, 30 Oct 2022 17:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667176680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=fgF5TY0n6sdFTb9p1pcGikisWxsgRlr4pwfzGzDB+f0=;
        b=DD/zUexSuf30r4S1E2usNg1o2GHLZL0ue8Z5JIxPLbAj7zO4gLUS8c2n5jsydV1FtiZ2Zb
        Q/E9IuP466QCS/E14nGgA+ueS6UB1UPFekqfDunWZNAkzL24PMIDmg+75VCsxsqaVjOrNE
        d1PJUJNLuzcwsFFqeGnR0rKRCLNyjDc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-vyGWONLmOWKYKYbzbW_20w-1; Sun, 30 Oct 2022 20:37:56 -0400
X-MC-Unique: vyGWONLmOWKYKYbzbW_20w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 69D2C185A7A3;
        Mon, 31 Oct 2022 00:37:55 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-151.bne.redhat.com [10.64.54.151])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A18A40C958D;
        Mon, 31 Oct 2022 00:37:48 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev, ajones@ventanamicro.com, maz@kernel.org,
        bgardon@google.com, catalin.marinas@arm.com, dmatlack@google.com,
        will@kernel.org, pbonzini@redhat.com, peterx@redhat.com,
        oliver.upton@linux.dev, seanjc@google.com, james.morse@arm.com,
        shuah@kernel.org, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: [PATCH v7 0/9] KVM: arm64: Enable ring-based dirty memory tracking
Date:   Mon, 31 Oct 2022 08:36:12 +0800
Message-Id: <20221031003621.164306-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series enables the ring-based dirty memory tracking for ARM64.
The feature has been available and enabled on x86 for a while. It
is beneficial when the number of dirty pages is small in a checkpointing
system or live migration scenario. More details can be found from
fb04a1eddb1a ("KVM: X86: Implement ring-based dirty memory tracking").

v6: https://lore.kernel.org/kvmarm/20221011061447.131531-1-gshan@redhat.com/
v5: https://lore.kernel.org/all/20221005004154.83502-1-gshan@redhat.com/
v4: https://lore.kernel.org/kvmarm/20220927005439.21130-1-gshan@redhat.com/
v3: https://lore.kernel.org/r/20220922003214.276736-1-gshan@redhat.com
v2: https://lore.kernel.org/lkml/YyiV%2Fl7O23aw5aaO@xz-m1.local/T/
v1: https://lore.kernel.org/lkml/20220819005601.198436-1-gshan@redhat.com

Testing
=======
(1) kvm/selftests/dirty_log_test
(2) Live migration by QEMU

Changelog
=========
v7:
  * Cut down #ifdef, avoid using 'container_of()', move the
    dirty-ring check after KVM_REQ_VM_DEAD, add comments
    for kvm_dirty_ring_check_request(), use tab character
    for KVM event definitions in kvm_host.h in PATCH[v7 01]    (Sean)
  * Add PATCH[v7 03] to recheck if the capability has
    been advertised prior to enable RING/RING_ACEL_REL         (Sean)
  * Improve the description about capability RING_WITH_BITMAP,
    rename kvm_dirty_ring_exclusive() to kvm_use_dirty_bitmap()
    in PATCH[v7 04/09]                                         (Peter/Oliver/Sean)
  * Add PATCH[v7 05/09] to improve no-running-vcpu report      (Marc/Sean)
  * Improve commit messages                                    (Sean/Oliver)
v6:
  * Add CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP, for arm64
    to advertise KVM_CAP_DIRTY_RING_WITH_BITMAP in
    PATCH[v6 3/8]                                              (Oliver/Peter)
  * Add helper kvm_dirty_ring_exclusive() to check if
    traditional bitmap-based dirty log tracking is
    exclusive to dirty-ring in PATCH[v6 3/8]                   (Peter)
  * Enable KVM_CAP_DIRTY_RING_WITH_BITMAP in PATCH[v6 5/8]     (Gavin)
v5:
  * Drop empty stub kvm_dirty_ring_check_request()             (Marc/Peter)
  * Add PATCH[v5 3/7] to allow using bitmap, indicated by
    KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP                        (Marc/Peter)
v4:
  * Commit log improvement                                     (Marc)
  * Add helper kvm_dirty_ring_check_request()                  (Marc)
  * Drop ifdef for kvm_cpu_dirty_log_size()                    (Marc)
v3:
  * Check KVM_REQ_RING_SOFT_RULL inside kvm_request_pending()  (Peter)
  * Move declaration of kvm_cpu_dirty_log_size()               (test-robot)
v2:
  * Introduce KVM_REQ_RING_SOFT_FULL                           (Marc)
  * Changelog improvement                                      (Marc)
  * Fix dirty_log_test without knowing host page size          (Drew)

Gavin Shan (9):
  KVM: x86: Introduce KVM_REQ_DIRTY_RING_SOFT_FULL
  KVM: Move declaration of kvm_cpu_dirty_log_size() to kvm_dirty_ring.h
  KVM: Check KVM_CAP_DIRTY_LOG_{RING, RING_ACQ_REL} prior to enabling
    them
  KVM: Support dirty ring in conjunction with bitmap
  KVM: arm64: Improve no-running-vcpu report for dirty ring
  KVM: arm64: Enable ring-based dirty memory tracking
  KVM: selftests: Use host page size to map ring buffer in
    dirty_log_test
  KVM: selftests: Clear dirty ring states between two modes in
    dirty_log_test
  KVM: selftests: Automate choosing dirty ring size in dirty_log_test

 Documentation/virt/kvm/api.rst               | 33 +++++++++---
 arch/arm64/include/uapi/asm/kvm.h            |  1 +
 arch/arm64/kvm/Kconfig                       |  2 +
 arch/arm64/kvm/arm.c                         |  3 ++
 arch/arm64/kvm/mmu.c                         | 14 ++++++
 arch/arm64/kvm/vgic/vgic-init.c              |  4 +-
 arch/arm64/kvm/vgic/vgic-irqfd.c             |  4 +-
 arch/arm64/kvm/vgic/vgic-its.c               |  2 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c           | 18 ++-----
 arch/arm64/kvm/vgic/vgic.c                   | 10 ++++
 arch/arm64/kvm/vgic/vgic.h                   |  1 -
 arch/x86/include/asm/kvm_host.h              |  2 -
 arch/x86/kvm/x86.c                           | 15 +++---
 include/kvm/arm_vgic.h                       |  1 +
 include/linux/kvm_dirty_ring.h               | 25 +++++----
 include/linux/kvm_host.h                     | 10 ++--
 include/uapi/linux/kvm.h                     |  1 +
 tools/testing/selftests/kvm/dirty_log_test.c | 53 ++++++++++++++------
 tools/testing/selftests/kvm/lib/kvm_util.c   |  2 +-
 virt/kvm/Kconfig                             |  8 +++
 virt/kvm/dirty_ring.c                        | 44 ++++++++++++++--
 virt/kvm/kvm_main.c                          | 39 +++++++++-----
 22 files changed, 208 insertions(+), 84 deletions(-)

-- 
2.23.0

