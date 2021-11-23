Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32CE4459952
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 01:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbhKWAxt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 19:53:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20233 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231137AbhKWAxr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Nov 2021 19:53:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637628639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GYWpc8wIF+vbiXR1aT/+mXBapry/w/2RCjPepM+0J2A=;
        b=AvAd6qj0+CO50XHOvX11PNLGL6xgBIFDr350nC4crE3bWDU7eyD6GyKFWZ2+NwcT3qsNOm
        QxkhPvuV8fVgzYPZrA+j46HjlKK0Q76kZizc1KRUe2C5ZGi7nYT6NMcpoF9xNv45nZucEB
        BsNEvtC0KdpMwmayvH6JOD8UuOjcRFg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-126-0TyAnASaPXeFCxqzfirTTA-1; Mon, 22 Nov 2021 19:50:38 -0500
X-MC-Unique: 0TyAnASaPXeFCxqzfirTTA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C706879500;
        Tue, 23 Nov 2021 00:50:37 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F26D5C1C5;
        Tue, 23 Nov 2021 00:50:37 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pgonda@google.com, Sean Christopherson <seanjc@google.com>
Subject: [PATCH 02/12] selftests: sev_migrate_tests: free all VMs
Date:   Mon, 22 Nov 2021 19:50:26 -0500
Message-Id: <20211123005036.2954379-3-pbonzini@redhat.com>
In-Reply-To: <20211123005036.2954379-1-pbonzini@redhat.com>
References: <20211123005036.2954379-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ensure that the ASID are freed promptly, which becomes more important
when more tests are added to this file.

Cc: Peter Gonda <pgonda@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
index a66b9be30239..0cd7e2eaa895 100644
--- a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
+++ b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
@@ -149,6 +149,8 @@ static void test_sev_migrate_locking(void)
 
 	for (i = 0; i < NR_LOCK_TESTING_THREADS; ++i)
 		pthread_join(pt[i], NULL);
+	for (i = 0; i < NR_LOCK_TESTING_THREADS; ++i)
+		kvm_vm_free(input[i].vm);
 }
 
 static void test_sev_migrate_parameters(void)
@@ -165,7 +167,6 @@ static void test_sev_migrate_parameters(void)
 	sev_ioctl(sev_es_vm_no_vmsa->fd, KVM_SEV_ES_INIT, NULL);
 	vm_vcpu_add(sev_es_vm_no_vmsa, 1);
 
-
 	ret = __sev_migrate_from(sev_vm->fd, sev_es_vm->fd);
 	TEST_ASSERT(
 		ret == -1 && errno == EINVAL,
@@ -194,6 +195,12 @@ static void test_sev_migrate_parameters(void)
 	TEST_ASSERT(ret == -1 && errno == EINVAL,
 		    "Migrations require SEV enabled. ret %d, errno: %d\n", ret,
 		    errno);
+
+	kvm_vm_free(sev_vm);
+	kvm_vm_free(sev_es_vm);
+	kvm_vm_free(sev_es_vm_no_vmsa);
+	kvm_vm_free(vm_no_vcpu);
+	kvm_vm_free(vm_no_sev);
 }
 
 int main(int argc, char *argv[])
-- 
2.27.0


