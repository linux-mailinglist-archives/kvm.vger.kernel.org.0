Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69DC6619B36
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 16:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbiKDPQM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 11:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbiKDPQG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 11:16:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D96A8B2F
        for <kvm@vger.kernel.org>; Fri,  4 Nov 2022 08:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667574901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=yNRgkiw9kqk8+TAZEiM/c0dMRWtp1q/0gNjaX48prUY=;
        b=h5OKLVhT5OkvrhBmepk2sZCFVkpGj/Nq1QLGoWz5Hn7z0mly0Z7NNVsk+chWTC5WeMX+s0
        MWwZRRU12Yw54CDde19zYElzQRd5cD78guOYhGxLxCr/r+UXeoEZjDYOuhlX7Ez7pdaOMT
        q21i39I0QeKxQmG503E0UFx8Y+3i4AE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-353--IgcZaIzP8yUtJxH_iEFAQ-1; Fri, 04 Nov 2022 11:14:57 -0400
X-MC-Unique: -IgcZaIzP8yUtJxH_iEFAQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1952C800B30;
        Fri,  4 Nov 2022 15:14:56 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 94018C1908B;
        Fri,  4 Nov 2022 15:14:55 +0000 (UTC)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Yanan Wang <wangyanan55@huawei.com>, kvm@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: [RFC PATCH 0/3] KVM: allow listener to stop all vcpus before
Date:   Fri,  4 Nov 2022 11:14:51 -0400
Message-Id: <20221104151454.136551-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

David Hildenbrand (1):
  kvm: Atomic memslot updates

Emanuele Giuseppe Esposito (2):
  KVM: keep track of running ioctls
  KVM: keep track of running vcpu ioctls

 accel/kvm/kvm-all.c      | 175 ++++++++++++++++++++++++++++++++++++---
 hw/core/cpu-common.c     |   2 +
 include/hw/core/cpu.h    |   3 +
 include/sysemu/kvm_int.h |   8 ++
 4 files changed, 177 insertions(+), 11 deletions(-)

-- 
2.31.1

