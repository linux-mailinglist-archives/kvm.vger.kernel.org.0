Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 800784BB66E
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 11:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233926AbiBRKJl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 05:09:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233923AbiBRKJh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 05:09:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 455E83EAA0
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 02:09:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645178960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XHsrA51tA3vT398QL9pL8+F4Xpr1TIdT6DiOmwJYGxM=;
        b=G7+QkW1EnKaJuls15YRbyjbps9D1+LX0AdRMrUL0TmACIyJVolFkFks9fiLgI8+OjzWkqi
        fQ5KSfp8lMWxJ3wVFRo2A8b6GNnaUURQFY8fU/7eT4Pf9E7QW5VWdiMU8RWIK+iqvV+MB8
        DIuQpTGVYuRl6LkvV6iLOJgDizebhnU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-645u8sAxP-aLt-X_BIJBKQ-1; Fri, 18 Feb 2022 05:09:12 -0500
X-MC-Unique: 645u8sAxP-aLt-X_BIJBKQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D93A1006AA3;
        Fri, 18 Feb 2022 10:09:11 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F3131106222E;
        Fri, 18 Feb 2022 10:09:10 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pgonda@google.com
Subject: [PATCH] selftests: KVM: add sev_migrate_tests on machines without SEV-ES
Date:   Fri, 18 Feb 2022 05:09:10 -0500
Message-Id: <20220218100910.35767-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I managed to get hold of a machine that has SEV but not SEV-ES, and
sev_migrate_tests fails because sev_vm_create(true) returns ENOTTY.
Fix this, and while at it also return KSFT_SKIP on machines that do
not have SEV at all, instead of returning 0.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 .../selftests/kvm/x86_64/sev_migrate_tests.c  | 78 ++++++++++++++-----
 1 file changed, 57 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
index 2e5a42cb470b..d1dc1acf997c 100644
--- a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
+++ b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
@@ -21,6 +21,8 @@
 #define NR_LOCK_TESTING_THREADS 3
 #define NR_LOCK_TESTING_ITERATIONS 10000
 
+bool have_sev_es;
+
 static int __sev_ioctl(int vm_fd, int cmd_id, void *data, __u32 *fw_error)
 {
 	struct kvm_sev_cmd cmd = {
@@ -172,10 +174,18 @@ static void test_sev_migrate_parameters(void)
 		*sev_es_vm_no_vmsa;
 	int ret;
 
-	sev_vm = sev_vm_create(/* es= */ false);
-	sev_es_vm = sev_vm_create(/* es= */ true);
 	vm_no_vcpu = vm_create(VM_MODE_DEFAULT, 0, O_RDWR);
 	vm_no_sev = aux_vm_create(true);
+	ret = __sev_migrate_from(vm_no_vcpu->fd, vm_no_sev->fd);
+	TEST_ASSERT(ret == -1 && errno == EINVAL,
+		    "Migrations require SEV enabled. ret %d, errno: %d\n", ret,
+		    errno);
+
+	if (!have_sev_es)
+		goto out;
+
+	sev_vm = sev_vm_create(/* es= */ false);
+	sev_es_vm = sev_vm_create(/* es= */ true);
 	sev_es_vm_no_vmsa = vm_create(VM_MODE_DEFAULT, 0, O_RDWR);
 	sev_ioctl(sev_es_vm_no_vmsa->fd, KVM_SEV_ES_INIT, NULL);
 	vm_vcpu_add(sev_es_vm_no_vmsa, 1);
@@ -204,14 +214,10 @@ static void test_sev_migrate_parameters(void)
 		"SEV-ES migrations require UPDATE_VMSA. ret %d, errno: %d\n",
 		ret, errno);
 
-	ret = __sev_migrate_from(vm_no_vcpu->fd, vm_no_sev->fd);
-	TEST_ASSERT(ret == -1 && errno == EINVAL,
-		    "Migrations require SEV enabled. ret %d, errno: %d\n", ret,
-		    errno);
-
 	kvm_vm_free(sev_vm);
 	kvm_vm_free(sev_es_vm);
 	kvm_vm_free(sev_es_vm_no_vmsa);
+out:
 	kvm_vm_free(vm_no_vcpu);
 	kvm_vm_free(vm_no_sev);
 }
@@ -300,7 +306,6 @@ static void test_sev_mirror_parameters(void)
 	int ret;
 
 	sev_vm = sev_vm_create(/* es= */ false);
-	sev_es_vm = sev_vm_create(/* es= */ true);
 	vm_with_vcpu = aux_vm_create(true);
 	vm_no_vcpu = aux_vm_create(false);
 
@@ -310,6 +315,21 @@ static void test_sev_mirror_parameters(void)
 		"Should not be able copy context to self. ret: %d, errno: %d\n",
 		ret, errno);
 
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
+	if (!have_sev_es)
+		goto out;
+
+	sev_es_vm = sev_vm_create(/* es= */ true);
 	ret = __sev_mirror_create(sev_vm->fd, sev_es_vm->fd);
 	TEST_ASSERT(
 		ret == -1 && errno == EINVAL,
@@ -322,19 +342,10 @@ static void test_sev_mirror_parameters(void)
 		"Should not be able copy context to SEV-ES enabled VM. ret: %d, errno: %d\n",
 		ret, errno);
 
-	ret = __sev_mirror_create(vm_no_vcpu->fd, vm_with_vcpu->fd);
-	TEST_ASSERT(ret == -1 && errno == EINVAL,
-		    "Copy context requires SEV enabled. ret %d, errno: %d\n", ret,
-		    errno);
-
-	ret = __sev_mirror_create(vm_with_vcpu->fd, sev_vm->fd);
-	TEST_ASSERT(
-		ret == -1 && errno == EINVAL,
-		"SEV copy context requires no vCPUS on the destination. ret: %d, errno: %d\n",
-		ret, errno);
+	kvm_vm_free(sev_es_vm);
 
+out:
 	kvm_vm_free(sev_vm);
-	kvm_vm_free(sev_es_vm);
 	kvm_vm_free(vm_with_vcpu);
 	kvm_vm_free(vm_no_vcpu);
 }
@@ -393,11 +404,35 @@ static void test_sev_move_copy(void)
 	kvm_vm_free(sev_vm);
 }
 
+#define X86_FEATURE_SEV (1 << 1)
+#define X86_FEATURE_SEV_ES (1 << 3)
+
 int main(int argc, char *argv[])
 {
+	struct kvm_cpuid_entry2 *cpuid;
+
+	if (!kvm_check_cap(KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM) &&
+	    !kvm_check_cap(KVM_CAP_VM_COPY_ENC_CONTEXT_FROM)) {
+		print_skip("Capabilities not available");
+		exit(KSFT_SKIP);
+	}
+
+	cpuid = kvm_get_supported_cpuid_entry(0x80000000);
+	if (cpuid->eax < 0x8000001f) {
+		print_skip("AMD memory encryption not available");
+		exit(KSFT_SKIP);
+	}
+	cpuid = kvm_get_supported_cpuid_entry(0x8000001f);
+	if (!(cpuid->eax & X86_FEATURE_SEV)) {
+		print_skip("AMD SEV not available");
+		exit(KSFT_SKIP);
+	}
+	have_sev_es = !!(cpuid->eax & X86_FEATURE_SEV_ES);
+
 	if (kvm_check_cap(KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM)) {
 		test_sev_migrate_from(/* es= */ false);
-		test_sev_migrate_from(/* es= */ true);
+		if (have_sev_es)
+			test_sev_migrate_from(/* es= */ true);
 		test_sev_migrate_locking();
 		test_sev_migrate_parameters();
 		if (kvm_check_cap(KVM_CAP_VM_COPY_ENC_CONTEXT_FROM))
@@ -405,7 +440,8 @@ int main(int argc, char *argv[])
 	}
 	if (kvm_check_cap(KVM_CAP_VM_COPY_ENC_CONTEXT_FROM)) {
 		test_sev_mirror(/* es= */ false);
-		test_sev_mirror(/* es= */ true);
+		if (have_sev_es)
+			test_sev_mirror(/* es= */ true);
 		test_sev_mirror_parameters();
 	}
 	return 0;
-- 
2.31.1

