Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 688905958E4
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 12:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234995AbiHPKtE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 06:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235116AbiHPKsr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 06:48:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CE8881262E
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 03:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660644777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=nzyKu/psvDBVanFqJ0RAMtVFHYX2Lw3qT+w5UEGNlPQ=;
        b=Rk27JW8NppqpTiqKE4ueval4wDh4IKuRHL9cZc1SZY42yao0dJYOhew36CAObPlqryCihv
        8T1qcwMHRsWFxrwJ4hgf6LN0tFMZ4gFy2oXnePS4SQLZVRmh7HHb1Ct8XiYp1VYUQ5PphL
        cIzCWIax7YZJNB4K9b2/pzhAfovnowY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-352-0lGeHv11NaafYUcOMstNWA-1; Tue, 16 Aug 2022 06:12:56 -0400
X-MC-Unique: 0lGeHv11NaafYUcOMstNWA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 161F4101A586;
        Tue, 16 Aug 2022 10:12:56 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C0113400E403;
        Tue, 16 Aug 2022 10:12:55 +0000 (UTC)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: [RFC PATCH 0/2] accel/kvm: extend kvm memory listener to support
Date:   Tue, 16 Aug 2022 06:12:48 -0400
Message-Id: <20220816101250.1715523-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The aim of this serie is to prepare kvm memory listener to support atomic
memslots update. In order to do that, QEMU should take care of sending all
memslot updates in a single ioctl, so that they can all be processed
atomically.

In order to do that, implement kml->begin() and kml->commit() callbacks, and
change the logic by replacing every ioctl invocation in ->region_* and ->log_*
so that the struct kvm_userspace_memory_region are queued in a linked list that
is then traversed and processed in ->commit.

Patch 1 ensures that ->region_* and ->log_* are always wrapped by ->begin and
->commit.

Emanuele Giuseppe Esposito (2):
  softmmu/memory: add missing begin/commit callback calls
  kvm/kvm-all.c: listener should delay kvm_vm_ioctl to the commit phase

 accel/kvm/kvm-all.c       | 99 ++++++++++++++++++++++++++++-----------
 include/sysemu/kvm_int.h  |  6 +++
 linux-headers/linux/kvm.h |  9 ++++
 softmmu/memory.c          |  2 +
 4 files changed, 89 insertions(+), 27 deletions(-)

-- 
2.31.1

