Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA3C454B1D
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 17:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235461AbhKQQlO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 11:41:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43919 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231923AbhKQQlM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Nov 2021 11:41:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637167093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=498U53CV99Ojk7idVc5JNNFWzkBV4ldodjVFge8QJj8=;
        b=GJENu3Qe0sJLify6mBYlVl/aQvM3unPm2C4I3TObk34YXhCzrVaoZkXT+B3bCG7gx4imEE
        V9I+HQYEl3T+ouuhxhuWWY0bzLFuRmf7x+dtU+7RHgEpl7jNOh0vrSfw57cIP7FJQvZeRf
        ah/nsalFSl5gUWOe236uJenq3FDzF0U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-454-6Ja81AaBPG6Qf-ucR9xaNw-1; Wed, 17 Nov 2021 11:38:12 -0500
X-MC-Unique: 6Ja81AaBPG6Qf-ucR9xaNw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B9DB1023F54;
        Wed, 17 Nov 2021 16:38:11 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B2F40604CC;
        Wed, 17 Nov 2021 16:38:10 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pgonda@google.com, seanjc@google.com
Subject: [PATCH 1/4] selftests: sev_migrate_tests: free all VMs
Date:   Wed, 17 Nov 2021 11:38:06 -0500
Message-Id: <20211117163809.1441845-2-pbonzini@redhat.com>
In-Reply-To: <20211117163809.1441845-1-pbonzini@redhat.com>
References: <20211117163809.1441845-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ensure that the ASID are freed promptly, which becomes more important
when more tests are added to this file.

Cc: Peter Gonda <pgonda@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
index 5ba325cd64bf..4a5d3728412b 100644
--- a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
+++ b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
@@ -162,7 +162,6 @@ static void test_sev_migrate_parameters(void)
 	sev_ioctl(sev_es_vm_no_vmsa->fd, KVM_SEV_ES_INIT, NULL);
 	vm_vcpu_add(sev_es_vm_no_vmsa, 1);
 
-
 	ret = __sev_migrate_from(sev_vm->fd, sev_es_vm->fd);
 	TEST_ASSERT(
 		ret == -1 && errno == EINVAL,
@@ -191,6 +190,12 @@ static void test_sev_migrate_parameters(void)
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


