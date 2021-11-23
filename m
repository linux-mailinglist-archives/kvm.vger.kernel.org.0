Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF5845995C
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 01:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233289AbhKWAyO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 19:54:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:49012 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232413AbhKWAxv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Nov 2021 19:53:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637628643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L2sSiLDkmJxVB+ui1aI1RCwbyrOWH4l2YwJAsXeXaMY=;
        b=cQrT8FHtVG8aqREmHA+zfX5IcBLsJH3ret3VFQIx55EJZ3Wus6c8uE7g38mPsbUpVBc/6F
        iQKM//xKPVm0B4qHg+z9YHzxqKh8CvIbybnHP4jtxrY2ldMuAro6PZWBFCuzqEFHICxil9
        EHhEfxDoReKgliBFwUfB9i36vNmTuwU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-173-v0QVHJ0NO_eRCq4RmChAew-1; Mon, 22 Nov 2021 19:50:38 -0500
X-MC-Unique: v0QVHJ0NO_eRCq4RmChAew-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 158F61023F4E;
        Tue, 23 Nov 2021 00:50:37 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA58C5C1C5;
        Tue, 23 Nov 2021 00:50:36 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pgonda@google.com
Subject: [PATCH 01/12] selftests: fix check for circular KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM
Date:   Mon, 22 Nov 2021 19:50:25 -0500
Message-Id: <20211123005036.2954379-2-pbonzini@redhat.com>
In-Reply-To: <20211123005036.2954379-1-pbonzini@redhat.com>
References: <20211123005036.2954379-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM leaves the source VM in a dead state,
so migrating back to the original source VM fails the ioctl.  Adjust
the test.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
index 5ba325cd64bf..a66b9be30239 100644
--- a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
+++ b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
@@ -89,7 +89,7 @@ static void test_sev_migrate_from(bool es)
 {
 	struct kvm_vm *src_vm;
 	struct kvm_vm *dst_vms[NR_MIGRATE_TEST_VMS];
-	int i;
+	int i, ret;
 
 	src_vm = sev_vm_create(es);
 	for (i = 0; i < NR_MIGRATE_TEST_VMS; ++i)
@@ -102,7 +102,10 @@ static void test_sev_migrate_from(bool es)
 		sev_migrate_from(dst_vms[i]->fd, dst_vms[i - 1]->fd);
 
 	/* Migrate the guest back to the original VM. */
-	sev_migrate_from(src_vm->fd, dst_vms[NR_MIGRATE_TEST_VMS - 1]->fd);
+	ret = __sev_migrate_from(src_vm->fd, dst_vms[NR_MIGRATE_TEST_VMS - 1]->fd);
+	TEST_ASSERT(ret == -1 && errno == EIO,
+		    "VM that was migrated from should be dead. ret %d, errno: %d\n", ret,
+		    errno);
 
 	kvm_vm_free(src_vm);
 	for (i = 0; i < NR_MIGRATE_TEST_VMS; ++i)
-- 
2.27.0


