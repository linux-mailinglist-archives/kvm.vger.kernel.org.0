Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA2B673D7FE
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 08:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbjFZGuk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 02:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjFZGuj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 02:50:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28CA6E53
        for <kvm@vger.kernel.org>; Sun, 25 Jun 2023 23:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687762189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=fYvIEwyzzG4pXA1ioSf53LM7nWsz6glb/hBkt2gcd0A=;
        b=cCm1rMEzPjI1n7SFDaRTb4k9t5xKqe7h5oWZXX18qY2SCy7WOEU4GRl28nJh7ycSdpMGPX
        CEYVqJLYo8nA1qfETDWG3K0mv7k9EePd06Mgyl3YYtrn4tM2D6sJQPVPHcljbmqiAcGa86
        HhGjVqORS5/2b58S2K0D5u31sqDnGJs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-152-Ci1AyDDlMq-nIANg3maySQ-1; Mon, 26 Jun 2023 02:49:43 -0400
X-MC-Unique: Ci1AyDDlMq-nIANg3maySQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C2AB4185A794;
        Mon, 26 Jun 2023 06:49:42 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 923F6200C0CD;
        Mon, 26 Jun 2023 06:49:42 +0000 (UTC)
From:   Shaoqin Huang <shahuang@redhat.com>
To:     qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     oliver.upton@linux.dev, salil.mehta@huawei.com,
        james.morse@arm.com, gshan@redhat.com,
        Shaoqin Huang <shahuang@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH v1 0/5] target/arm: Handle psci calls in userspace
Date:   Mon, 26 Jun 2023 02:49:04 -0400
Message-Id: <20230626064910.1787255-1-shahuang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The userspace SMCCC call filtering[1] provides the ability to forward the SMCCC
calls to the userspace. The vCPU hotplug[2] would be the first legitimate use
case to handle the psci calls in userspace, thus the vCPU hotplug can deny the
PSCI_ON call if the vCPU is not present now.

This series try to enable the userspace SMCCC call filtering, thus can handle
the SMCCC call in userspace. The first enabled SMCCC call is psci call, by using
the new added option 'user-smccc', we can enable handle psci calls in userspace.

qemu-system-aarch64 -machine virt,user-smccc=on

This series reuse the qemu implementation of the psci handling, thus the
handling process is very simple. But when handling psci in userspace when using
kvm, the reset vcpu process need to be taking care, the detail is included in
the patch05.

[1] lore.kernel.org/20230404154050.2270077-1-oliver.upton@linux.dev
[2] lore.kernel.org/20230203135043.409192-1-james.morse@arm.com

Shaoqin Huang (5):
  linux-headers: Update to v6.4-rc7
  linux-headers: Import arm-smccc.h from Linux v6.4-rc7
  target/arm: make psci call can be used by kvm
  arm/kvm: add skeleton implementation for userspace SMCCC call handling
  arm/kvm: add support for userspace psci calls handling

 docs/system/arm/virt.rst                      |   4 +
 hw/arm/virt.c                                 |  21 ++
 hw/intc/arm_gicv3_kvm.c                       |  10 +
 include/hw/arm/virt.h                         |   1 +
 include/standard-headers/linux/const.h        |   2 +-
 include/standard-headers/linux/virtio_blk.h   |  18 +-
 .../standard-headers/linux/virtio_config.h    |   6 +
 include/standard-headers/linux/virtio_net.h   |   1 +
 linux-headers/asm-arm64/kvm.h                 |  33 +++
 linux-headers/asm-riscv/kvm.h                 |  53 +++-
 linux-headers/asm-riscv/unistd.h              |   9 +
 linux-headers/asm-s390/unistd_32.h            |   1 +
 linux-headers/asm-s390/unistd_64.h            |   1 +
 linux-headers/asm-x86/kvm.h                   |   3 +
 linux-headers/linux/arm-smccc.h               | 240 ++++++++++++++++++
 linux-headers/linux/const.h                   |   2 +-
 linux-headers/linux/kvm.h                     |  12 +-
 linux-headers/linux/psp-sev.h                 |   7 +
 linux-headers/linux/userfaultfd.h             |  17 +-
 target/arm/helper.c                           |   3 +-
 target/arm/kvm.c                              | 146 +++++++++++
 21 files changed, 573 insertions(+), 17 deletions(-)
 create mode 100644 linux-headers/linux/arm-smccc.h

base-commit: e3660cc1e3cb136af50c0eaaeac27943c2438d1d
-- 
2.39.1

