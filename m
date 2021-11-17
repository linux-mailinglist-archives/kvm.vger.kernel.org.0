Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25219454B21
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 17:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239158AbhKQQlQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 11:41:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:54235 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233972AbhKQQlP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Nov 2021 11:41:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637167096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eydQiUa7hZpdalOq0NGj+uF1SZuDaKfN+HksLFgpoAk=;
        b=bu6OCiiYoJO+ib4mhcYtHnA1Xh01+9aNcMIkzv3ct2IAC8JoDLLuBGgr19NtPoUOd9pel1
        iq54ZGLz10lpwdI/IhD0CobvY3rpfot7XiCT7pQdsIDwTybs+rSS8gJsL60RUVpDhcJzQP
        XKlZ9UI8PAu9Mc1aK08lnalIIdYTN1w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-49-t9a_QVG5NOeRzHqt4laNEg-1; Wed, 17 Nov 2021 11:38:13 -0500
X-MC-Unique: t9a_QVG5NOeRzHqt4laNEg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C67541023F55;
        Wed, 17 Nov 2021 16:38:11 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4652C604CC;
        Wed, 17 Nov 2021 16:38:11 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pgonda@google.com, seanjc@google.com
Subject: [PATCH 2/4] selftests: sev_migrate_tests: add tests for KVM_CAP_VM_COPY_ENC_CONTEXT_FROM
Date:   Wed, 17 Nov 2021 11:38:07 -0500
Message-Id: <20211117163809.1441845-3-pbonzini@redhat.com>
In-Reply-To: <20211117163809.1441845-1-pbonzini@redhat.com>
References: <20211117163809.1441845-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I am putting the tests in sev_migrate_tests because the failure conditions are
very similar and some of the setup code can be reused, too.

The tests cover both successful creation of a mirror VM, and error
conditions.

Cc: Peter Gonda <pgonda@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 .../selftests/kvm/x86_64/sev_migrate_tests.c  | 106 ++++++++++++++++--
 1 file changed, 99 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
index 4a5d3728412b..986dc2ede61d 100644
--- a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
+++ b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
@@ -54,12 +54,15 @@ static struct kvm_vm *sev_vm_create(bool es)
 	return vm;
 }
 
-static struct kvm_vm *__vm_create(void)
+static struct kvm_vm *aux_vm_create(bool with_vcpus)
 {
 	struct kvm_vm *vm;
 	int i;
 
 	vm = vm_create(VM_MODE_DEFAULT, 0, O_RDWR);
+	if (!with_vcpus)
+		return vm;
+
 	for (i = 0; i < NR_MIGRATE_TEST_VCPUS; ++i)
 		vm_vcpu_add(vm, i);
 
@@ -93,7 +96,7 @@ static void test_sev_migrate_from(bool es)
 
 	src_vm = sev_vm_create(es);
 	for (i = 0; i < NR_MIGRATE_TEST_VMS; ++i)
-		dst_vms[i] = __vm_create();
+		dst_vms[i] = aux_vm_create(true);
 
 	/* Initial migration from the src to the first dst. */
 	sev_migrate_from(dst_vms[0]->fd, src_vm->fd);
@@ -157,7 +160,7 @@ static void test_sev_migrate_parameters(void)
 	sev_vm = sev_vm_create(/* es= */ false);
 	sev_es_vm = sev_vm_create(/* es= */ true);
 	vm_no_vcpu = vm_create(VM_MODE_DEFAULT, 0, O_RDWR);
-	vm_no_sev = __vm_create();
+	vm_no_sev = aux_vm_create(true);
 	sev_es_vm_no_vmsa = vm_create(VM_MODE_DEFAULT, 0, O_RDWR);
 	sev_ioctl(sev_es_vm_no_vmsa->fd, KVM_SEV_ES_INIT, NULL);
 	vm_vcpu_add(sev_es_vm_no_vmsa, 1);
@@ -198,11 +201,100 @@ static void test_sev_migrate_parameters(void)
 	kvm_vm_free(vm_no_sev);
 }
 
+static int __sev_mirror_create(int dst_fd, int src_fd)
+{
+	struct kvm_enable_cap cap = {
+		.cap = KVM_CAP_VM_COPY_ENC_CONTEXT_FROM,
+		.args = { src_fd }
+	};
+
+	return ioctl(dst_fd, KVM_ENABLE_CAP, &cap);
+}
+
+
+static void sev_mirror_create(int dst_fd, int src_fd)
+{
+	int ret;
+
+	ret = __sev_mirror_create(dst_fd, src_fd);
+	TEST_ASSERT(!ret, "Migration failed, ret: %d, errno: %d\n", ret, errno);
+}
+
+static void test_sev_mirror(bool es)
+{
+	struct kvm_vm *src_vm, *dst_vm;
+	struct kvm_sev_launch_start start = {
+		.policy = es ? SEV_POLICY_ES : 0
+	};
+	int i;
+
+	src_vm = sev_vm_create(es);
+	dst_vm = aux_vm_create(false);
+
+	sev_mirror_create(dst_vm->fd, src_vm->fd);
+
+	/* Check that we can complete creation of the mirror VM.  */
+	for (i = 0; i < NR_MIGRATE_TEST_VCPUS; ++i)
+		vm_vcpu_add(dst_vm, i);
+	sev_ioctl(dst_vm->fd, KVM_SEV_LAUNCH_START, &start);
+	if (es)
+		sev_ioctl(dst_vm->fd, KVM_SEV_LAUNCH_UPDATE_VMSA, NULL);
+
+	kvm_vm_free(src_vm);
+	kvm_vm_free(dst_vm);
+}
+
+static void test_sev_mirror_parameters(void)
+{
+	struct kvm_vm *sev_vm, *sev_es_vm, *vm_no_vcpu, *vm_with_vcpu;
+	int ret;
+
+	sev_vm = sev_vm_create(/* es= */ false);
+	sev_es_vm = sev_vm_create(/* es= */ true);
+	vm_with_vcpu = aux_vm_create(true);
+	vm_no_vcpu = aux_vm_create(false);
+
+	ret = __sev_mirror_create(sev_vm->fd, sev_es_vm->fd);
+	TEST_ASSERT(
+		ret == -1 && errno == EINVAL,
+		"Should not be able copy context to SEV enabled VM. ret: %d, errno: %d\n",
+		ret, errno);
+
+	ret = __sev_mirror_create(sev_es_vm->fd, sev_vm->fd);
+	TEST_ASSERT(
+		ret == -1 && errno == EINVAL,
+		"Should not be able copy context to SEV-ES enabled VM. ret: %d, errno: %d\n",
+		ret, errno);
+
+	ret = __sev_mirror_create(vm_no_vcpu->fd, vm_with_vcpu->fd);
+	TEST_ASSERT(ret == -1 && errno == EINVAL,
+		    "Copy context requires SEV enabled. ret %d, errno: %d\n", ret,
+		    errno);
+
+	ret = __sev_mirror_create(vm_with_vcpu->fd, sev_vm->fd);
+	TEST_ASSERT(
+		ret == -1 && errno == EINVAL,
+		"SEV copy context requires no vCPUS on the destination. ret: %d, errno: %d\n",
+		ret, errno);
+
+	kvm_vm_free(sev_vm);
+	kvm_vm_free(sev_es_vm);
+	kvm_vm_free(vm_with_vcpu);
+	kvm_vm_free(vm_no_vcpu);
+}
+
 int main(int argc, char *argv[])
 {
-	test_sev_migrate_from(/* es= */ false);
-	test_sev_migrate_from(/* es= */ true);
-	test_sev_migrate_locking();
-	test_sev_migrate_parameters();
+	if (kvm_check_cap(KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM)) {
+		test_sev_migrate_from(/* es= */ false);
+		test_sev_migrate_from(/* es= */ true);
+		test_sev_migrate_locking();
+		test_sev_migrate_parameters();
+	}
+	if (kvm_check_cap(KVM_CAP_VM_COPY_ENC_CONTEXT_FROM)) {
+		test_sev_mirror(/* es= */ false);
+		test_sev_mirror(/* es= */ true);
+		test_sev_mirror_parameters();
+	}
 	return 0;
 }
-- 
2.27.0


