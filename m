Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0CAD6662D3
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 19:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234740AbjAKSbd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 13:31:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235225AbjAKSbS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 13:31:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4E3373AB
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 10:30:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673461837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=DsHR+gK9NXOoSaKdGDYaK34gTAYNmEFxKqyOr6ZMcO4=;
        b=XvKYhcsNoXuK3xFNDIhTijClPODc7arTJxiaDO738c5JXvxl7J5XxmxLDDCWdiqTBgw8pS
        YUxkmQuoVc+1BqDJAi0mR3sn76rKD9HqCo6qMbhwp1NkDqP3E+UftOEsiX1I8dU0zkgalC
        eThmgrNfPtaqIkUm+9ns+Jzfy+lYpJM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-lodOvzh5NXicVlPIqy2l4A-1; Wed, 11 Jan 2023 13:30:33 -0500
X-MC-Unique: lodOvzh5NXicVlPIqy2l4A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9B8708030A0;
        Wed, 11 Jan 2023 18:30:32 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 777C7140EBF5;
        Wed, 11 Jan 2023 18:30:32 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dwmw@amazon.co.uk, seanjc@google.com
Subject: [PATCH] Documentation: kvm: fix SRCU locking order docs
Date:   Wed, 11 Jan 2023 13:30:31 -0500
Message-Id: <20230111183031.2449668-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm->srcu is taken in KVM_RUN and several other vCPU ioctls, therefore
vcpu->mutex is susceptible to the same deadlock that is documented
for kvm->slots_lock.  The same holds for kvm->lock, since kvm->lock
is held outside vcpu->mutex.  Fix the documentation and rearrange it
to highlight the difference between these locks and kvm->slots_arch_lock,
and how kvm->slots_arch_lock can be useful while processing a vmexit.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/locking.rst | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index 897ca39b72bf..53826098183e 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -24,17 +24,18 @@ The acquisition orders for mutexes are as follows:
 
 For SRCU:
 
-- ``synchronize_srcu(&kvm->srcu)`` is called _inside_
-  the kvm->slots_lock critical section, therefore kvm->slots_lock
-  cannot be taken inside a kvm->srcu read-side critical section.
-  Instead, kvm->slots_arch_lock is released before the call
-  to ``synchronize_srcu()`` and _can_ be taken inside a
-  kvm->srcu read-side critical section.
-
-- kvm->lock is taken inside kvm->srcu, therefore
-  ``synchronize_srcu(&kvm->srcu)`` cannot be called inside
-  a kvm->lock critical section.  If you cannot delay the
-  call until after kvm->lock is released, use ``call_srcu``.
+- ``synchronize_srcu(&kvm->srcu)`` is called inside critical sections
+  for kvm->lock, vcpu->mutex and kvm->slots_lock.  These locks _cannot_
+  be taken inside a kvm->srcu read-side critical section; that is, the
+  following is broken::
+
+      srcu_read_lock(&kvm->srcu);
+      mutex_lock(&kvm->slots_lock);
+
+- kvm->slots_arch_lock instead is released before the call to
+  ``synchronize_srcu()``.  It _can_ therefore be taken inside a
+  kvm->srcu read-side critical section, for example while processing
+  a vmexit.
 
 On x86:
 
-- 
2.39.0

