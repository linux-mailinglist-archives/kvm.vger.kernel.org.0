Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63DA8608E38
	for <lists+kvm@lfdr.de>; Sat, 22 Oct 2022 17:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbiJVPsl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Oct 2022 11:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiJVPsd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Oct 2022 11:48:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D030EAE4F
        for <kvm@vger.kernel.org>; Sat, 22 Oct 2022 08:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666453708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=OPS/W9EriOxXRzwj2N2ZjlWHOy5hj1Gjuemf2SY5Ke0=;
        b=EAFK8OEM90I7IhyDUen80GO9ZRc1GwsVrvNjFUYeZV7N9CkJzzZywFzmU9Ac/GO9bdclg4
        Z1vJjPdyQ6n4fOr2u6b13qeDqFrVeP1cLzOr6lXr+s0YW7G4NudhOrnV6PWtDgjAZbUdGQ
        UB7+u7lPr+Dth32AHBX+bW4zlg2DBSQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-HeEXPnPlOyOnOd3OwjkhyQ-1; Sat, 22 Oct 2022 11:48:26 -0400
X-MC-Unique: HeEXPnPlOyOnOd3OwjkhyQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7FAD4811E7A;
        Sat, 22 Oct 2022 15:48:26 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 392F840C6EC2;
        Sat, 22 Oct 2022 15:48:25 +0000 (UTC)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: [PATCH 0/2] KVM: stop all vcpus before modifying memslots
Date:   Sat, 22 Oct 2022 11:48:21 -0400
Message-Id: <20221022154823.1823193-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

To solve this problem, use the newly introduced kvm API:
KVM_KICK_ALL_RUNNING_VCPUS and KVM_RESUME_ALL_KICKED_VCPUS.
This new API allows the userspace to respectively stop and resume all running vcpus. A "running" vcpu is a vcpu that is executing
the KVM_RUN ioctl.

While KVM already handles the case of KVM_RUN being called after
KVM_KICK_ALL_RUNNING_VCPUS is invoked but before KVM_RESUME_ALL_KICKED_VCPUS by simply returning immediately,
QEMU also avoids that using the event API.

This is the simplest solution, pausing all vcpus in the kvm
side, so that:
- QEMU just needs to call the new API before making memslots
changes, keeping modifications to the minimum
- dirty page updates are also performed when vcpus are blocked, so
there is no time window between the dirty page ioctl and memslots
modifications, since vcpus are all stopped.
- no need to modify the existing memslots API

This series requires the KVM serie "KVM: API to block and resume all running vcpus in a vm".

Emanuele Giuseppe Esposito (2):
  linux-headers/linux/kvm.h: introduce kvm_userspace_memory_region_list
    ioctl
  accel/kvm: introduce begin/commit listener callbacks

 accel/kvm/kvm-all.c       | 50 +++++++++++++++++++++++++++++++++++++++
 linux-headers/linux/kvm.h |  3 +++
 2 files changed, 53 insertions(+)

-- 
2.31.1

