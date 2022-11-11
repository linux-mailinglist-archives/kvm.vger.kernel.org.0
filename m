Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B28B625EB1
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 16:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234191AbiKKPtS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 10:49:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234196AbiKKPtE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 10:49:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D2E53EE4
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 07:48:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668181685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=h3COesErds9Xwit3G5uHw6wMEFTnQKsDDl/1+9U6cDQ=;
        b=VVIOWe7BWyRdauL2XW/S+hIW2NBEqbqkjRibBLp09DqOrAR9RaFDRffGPkUpMLkpxEfze+
        4IFWFrBa6B831tXTXVQ0xj0pHYLsFH8lwWLN7vjyHUzTCfjBXRvylR4OB5FWfgcjrWkn6J
        VaE0ogjfzyhMOq7Pajy+jiGRobZYQjU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-324-F6vL_XFfPqyF9TCb18WqZQ-1; Fri, 11 Nov 2022 10:48:00 -0500
X-MC-Unique: F6vL_XFfPqyF9TCb18WqZQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0651738173D4;
        Fri, 11 Nov 2022 15:48:00 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 86356111F3BB;
        Fri, 11 Nov 2022 15:47:59 +0000 (UTC)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Yanan Wang <wangyanan55@huawei.com>, kvm@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: [PATCH v3 0/3] KVM: allow listener to stop all vcpus before
Date:   Fri, 11 Nov 2022 10:47:55 -0500
Message-Id: <20221111154758.1372674-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QEMU needs to perform memslots operations like merging and splitting,
and each operation requires more than a single ioctl.
Therefore if a vcpu is concurrently reading the same memslots,
it could end up reading something that was temporarly deleted.
For example, merging two memslots into one would imply:
DELETE(m1)
DELETE(m2)
CREATE(m1+m2)

And a vcpu could attempt to read m2 right after it is deleted, but
before the new one is created.

This approach is 100% QEMU-based. No KVM API modification is involved,
but implies that QEMU must make sure no new ioctl is running and all
vcpus are stopped.

The logic and code are basically taken from David Hildenbrand
proposal given a while ago while reviewing a previous attempt where
I suggested to solve the above problem directly in KVM by extending
its API.

This is the original code:
https://github.com/davidhildenbrand/qemu/commit/86b1bf546a8d00908e33f7362b0b61e2be8dbb7a

I just split the patch in three smaller patches, and used a
QemuLockCnt instead of counter + mutex.

RHBZ: https://bugzilla.redhat.com/show_bug.cgi?id=1979276

Emanuele
---
v3:
* minor fixes on comments and docs
* improved accel_ioctl_inhibit_begin
* drop QSIMPLEQ_REMOVE from kvm_commit

v2:
* use QemuEvent instead of spinning in ioctl_inhibit_begin
* move the blocker API in a separate file and header, so that other accel can
  use it if they want.

David Hildenbrand (1):
  kvm: Atomic memslot updates

Emanuele Giuseppe Esposito (2):
  accel: introduce accelerator blocker API
  KVM: keep track of running ioctls

 accel/accel-blocker.c          | 154 +++++++++++++++++++++++++++++++++
 accel/kvm/kvm-all.c            | 108 ++++++++++++++++++++---
 accel/meson.build              |   2 +-
 hw/core/cpu-common.c           |   2 +
 include/hw/core/cpu.h          |   3 +
 include/sysemu/accel-blocker.h |  56 ++++++++++++
 include/sysemu/kvm_int.h       |   8 ++
 7 files changed, 321 insertions(+), 12 deletions(-)
 create mode 100644 accel/accel-blocker.c
 create mode 100644 include/sysemu/accel-blocker.h

-- 
2.31.1

