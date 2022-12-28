Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A36CF65759B
	for <lists+kvm@lfdr.de>; Wed, 28 Dec 2022 12:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbiL1LF3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Dec 2022 06:05:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiL1LFH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Dec 2022 06:05:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8EBE635C
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 03:04:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672225455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=TUX0sXEcAN0K1aU6BJZ1TjOIBQmXMpyyj+laRKo6qDQ=;
        b=hUY3pKnNnUZmFVBO+bFII4UDaI9hFc9t/p8HnuEg1w2fo2jZ8T+ylZ972h7fXKDFqVL+Jn
        AmFK4DOG9Qvt9S0wkqMKAsNr33zFB01kyz0uF/RU8ZMkJvgLtRttPT7zXK700pUZEW8ap1
        KvWoa4FMwTF+qbMXja7SKnrkGbLWb+k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-391-GvfkGOrYPuecNGvFWr0C4g-1; Wed, 28 Dec 2022 06:04:12 -0500
X-MC-Unique: GvfkGOrYPuecNGvFWr0C4g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B41C585D066;
        Wed, 28 Dec 2022 11:04:11 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 98C4A40AE1EA;
        Wed, 28 Dec 2022 11:04:11 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH] Documentation: kvm: clarify SRCU locking order
Date:   Wed, 28 Dec 2022 06:04:10 -0500
Message-Id: <20221228110410.1682852-2-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently only the locking order of SRCU vs kvm->slots_arch_lock
and kvm->slots_lock is documented.  Extend this to kvm->lock
since Xen emulation got it terribly wrong.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/locking.rst | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index 845a561629f1..a3ca76f9be75 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -16,17 +16,26 @@ The acquisition orders for mutexes are as follows:
 - kvm->slots_lock is taken outside kvm->irq_lock, though acquiring
   them together is quite rare.
 
-- Unlike kvm->slots_lock, kvm->slots_arch_lock is released before
-  synchronize_srcu(&kvm->srcu).  Therefore kvm->slots_arch_lock
-  can be taken inside a kvm->srcu read-side critical section,
-  while kvm->slots_lock cannot.
-
 - kvm->mn_active_invalidate_count ensures that pairs of
   invalidate_range_start() and invalidate_range_end() callbacks
   use the same memslots array.  kvm->slots_lock and kvm->slots_arch_lock
   are taken on the waiting side in install_new_memslots, so MMU notifiers
   must not take either kvm->slots_lock or kvm->slots_arch_lock.
 
+For SRCU:
+
+- ``synchronize_srcu(&kvm->srcu)`` is called _inside_
+  the kvm->slots_lock critical section, therefore kvm->slots_lock
+  cannot be taken inside a kvm->srcu read-side critical section.
+  Instead, kvm->slots_arch_lock is released before the call
+  to ``synchronize_srcu()`` and _can_ be taken inside a
+  kvm->srcu read-side critical section.
+
+- kvm->lock is taken inside kvm->srcu, therefore
+  ``synchronize_srcu(&kvm->srcu)`` cannot be called inside
+  a kvm->lock critical section.  If you cannot delay the
+  call until after kvm->lock is released, use ``call_srcu``.
+
 On x86:
 
 - vcpu->mutex is taken outside kvm->arch.hyperv.hv_lock
-- 
2.31.1

