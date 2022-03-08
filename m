Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C94EF4D1D41
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 17:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348319AbiCHQeU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 11:34:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235098AbiCHQeT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 11:34:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 861CC33379
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 08:33:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646757201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=cvF6mTwU2sioCsPJ8tNKFYB0plPjCVi6fMhKN3lJBTA=;
        b=E4wemfCMQ7tqez6nU/GIYUJHRJi0n6J+BsjE5hBAaCw1cnXcNOvOYfMqs7dw6v7bDUN6ez
        06s8USVSm0om2Qg7AAHHzYaeh3RQE5GLKZ9OiWsNynnOI/V9FKyNbU8UP/7ff8VAPiqOLM
        EnpYpq4ygr5u/M0WtGG0jwULZno0ugA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-A8bHgDhLOYed5lrdnJg18A-1; Tue, 08 Mar 2022 11:33:20 -0500
X-MC-Unique: A8bHgDhLOYed5lrdnJg18A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2289E8145F6;
        Tue,  8 Mar 2022 16:33:19 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D6EAC797C3;
        Tue,  8 Mar 2022 16:33:18 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] KVM: use kvcalloc for array allocations
Date:   Tue,  8 Mar 2022 11:33:18 -0500
Message-Id: <20220308163318.819164-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of using array_size, use a function that takes care of the
multiplication.  While at it, switch to kvcalloc since this allocation
should not be very large.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/cpuid.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index afcdd4e693e5..419eb8e14f79 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1248,8 +1248,7 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
 	if (sanity_check_entries(entries, cpuid->nent, type))
 		return -EINVAL;
 
-	array.entries = vzalloc(array_size(sizeof(struct kvm_cpuid_entry2),
-					   cpuid->nent));
+	array.entries = kvcalloc(sizeof(struct kvm_cpuid_entry2), cpuid->nent, GFP_KERNEL);
 	if (!array.entries)
 		return -ENOMEM;
 
@@ -1267,7 +1266,7 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
 		r = -EFAULT;
 
 out_free:
-	vfree(array.entries);
+	kvfree(array.entries);
 	return r;
 }
 
-- 
2.31.1

