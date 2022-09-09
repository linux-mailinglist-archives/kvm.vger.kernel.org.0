Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB7A5B3161
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 10:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbiIIIME (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 04:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbiIIIMA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 04:12:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB29B2851
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 01:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662711117;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=COWWLahwGCQZa3I1la+bchyz+uJtHt4CBEA8bUq8Yiw=;
        b=bZPWH3eyla99T9KFp3tYK3tqv8dnrNT0EqLr++Wms1pUmWXAOZnCmg2iGIztucdIYsZ/k/
        6G2kHWgBbn6IaRsAOMx0wT1aHYyABukDYCab67V13SCm0Mj87BNcLChPLzhS072oMRi8dL
        qZ92UYpTIKmcrubhreCJ0sRoIcB7qng=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-59-1TmXxAe7NwCAOJ8FWP0olQ-1; Fri, 09 Sep 2022 04:11:56 -0400
X-MC-Unique: 1TmXxAe7NwCAOJ8FWP0olQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CBB07811E76;
        Fri,  9 Sep 2022 08:11:55 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF5DA4011A3E;
        Fri,  9 Sep 2022 08:11:51 +0000 (UTC)
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
Subject: [RFC PATCH v2 0/3] accel/kvm: extend kvm memory listener to support
Date:   Fri,  9 Sep 2022 04:11:47 -0400
Message-Id: <20220909081150.709060-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
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

---
v2:
- remove patch 1, as it is useless
- patch 2: instead of a linked list, use kvm_userspace_memory_region_list
- kvm_userspace_memory_region_list: add padding

Emanuele Giuseppe Esposito (3):
  linux-headers/linux/kvm.h: introduce kvm_userspace_memory_region_list
    ioctl
  accel/kvm/kvm-all.c: pass kvm_userspace_memory_region_entry instead
  kvm/kvm-all.c: listener should delay kvm_vm_ioctl to the commit phase

 accel/kvm/kvm-all.c       | 116 +++++++++++++++++++++++++++++---------
 include/sysemu/kvm_int.h  |   8 +++
 linux-headers/linux/kvm.h |  20 +++++++
 3 files changed, 117 insertions(+), 27 deletions(-)

-- 
2.31.1

