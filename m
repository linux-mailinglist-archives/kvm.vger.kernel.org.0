Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A702E5E5754
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 02:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbiIVAcc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 20:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiIVAca (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 20:32:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 009ABA98C5
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 17:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663806748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ccbp8BD4kcBiFdBToxQRh5neaOCPlEmQcd7egl4H6S4=;
        b=bYlAoSvaduzVe5t9/LGldBSmTwAg/2xGIS3H33LAIk4N6a3slai8nlZmVMJLQFM/BJQ3rS
        VAfxtJXjMP+nnx1yqG1j6iKzo9XRZFM8KLyB9MF4ZMUOOMJRD7T0kBrueLVlw9rEbdGc6f
        uzA8qp+A9ILtH53dlcOrH/S3+T4aRw0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-534-HcF3MiBoNYefjnk5N_Icpw-1; Wed, 21 Sep 2022 20:32:25 -0400
X-MC-Unique: HcF3MiBoNYefjnk5N_Icpw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C388C1C14B65;
        Thu, 22 Sep 2022 00:32:24 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-126.bne.redhat.com [10.64.54.126])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 61FEF2166B26;
        Thu, 22 Sep 2022 00:32:18 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, catalin.marinas@arm.com, bgardon@google.com,
        shuah@kernel.org, maz@kernel.org, andrew.jones@linux.dev,
        will@kernel.org, dmatlack@google.com, oliver.upton@linux.dev,
        peterx@redhat.com, pbonzini@redhat.com, zhenyzha@redhat.com,
        shan.gavin@gmail.com
Subject: [PATCH v3 0/6] KVM: arm64: Enable ring-based dirty memory tracking
Date:   Thu, 22 Sep 2022 08:32:08 +0800
Message-Id: <20220922003214.276736-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

The generic part has been comprehensive, meaning there isn't too much
work, needed to extend it to ARM64.

  PATCH[1]   introduces KVM_REQ_RING_SOFT_FULL for x86
  PATCH[2]   moves declaration of kvm_cpu_dirty_log_size()
  PATCH[3]   enables the feature on ARM64
  PATCH[4-6] improves kvm/selftests/dirty_log_test

v2: https://lore.kernel.org/lkml/YyiV%2Fl7O23aw5aaO@xz-m1.local/T/
v1: https://lore.kernel.org/lkml/20220819005601.198436-1-gshan@redhat.com

Testing
=======
(1) kvm/selftests/dirty_log_test
(2) Live migration by QEMU

Changelog
=========
v3:
  * Check KVM_REQ_RING_SOFT_RULL inside kvm_request_pending()  (Peter)
  * Move declaration of kvm_cpu_dirty_log_size()               (test-robot)
v2:
  * Introduce KVM_REQ_RING_SOFT_FULL                           (Marc)
  * Changelog improvement                                      (Marc)
  * Fix dirty_log_test without knowing host page size          (Drew)

Gavin Shan (6):
  KVM: x86: Introduce KVM_REQ_RING_SOFT_FULL
  KVM: x86: Move declaration of kvm_cpu_dirty_log_size() to
    kvm_dirty_ring.h
  KVM: arm64: Enable ring-based dirty memory tracking
  KVM: selftests: Use host page size to map ring buffer in
    dirty_log_test
  KVM: selftests: Clear dirty ring states between two modes in
    dirty_log_test
  KVM: selftests: Automate choosing dirty ring size in dirty_log_test

 Documentation/virt/kvm/api.rst               |  2 +-
 arch/arm64/include/uapi/asm/kvm.h            |  1 +
 arch/arm64/kvm/Kconfig                       |  1 +
 arch/arm64/kvm/arm.c                         |  8 +++
 arch/x86/include/asm/kvm_host.h              |  2 -
 arch/x86/kvm/mmu/mmu.c                       |  2 +
 arch/x86/kvm/x86.c                           | 19 +++----
 include/linux/kvm_dirty_ring.h               |  1 +
 include/linux/kvm_host.h                     |  1 +
 tools/testing/selftests/kvm/dirty_log_test.c | 53 ++++++++++++++------
 tools/testing/selftests/kvm/lib/kvm_util.c   |  2 +-
 virt/kvm/dirty_ring.c                        |  4 ++
 12 files changed, 69 insertions(+), 27 deletions(-)

-- 
2.23.0

