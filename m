Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1022A27747E
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 16:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728380AbgIXO6b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 10:58:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57688 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728383AbgIXO62 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Sep 2020 10:58:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600959507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3FsVVZ/2CXeiMiDnOQGnRlUEYa5V0ZjIHEUV17wU5y0=;
        b=CVX7E3QaPagS+r+jlnJs/wwzndL2D3BpQsPYK3BynHh4Qtbf8kvrc4CQONunMBW+SvYlEL
        cqhrHyAkK1nOgS5QS7nbp4wU6AwyQPk/TikhBmayTHDZh0rZ1fWPJ5noAoJzIWYQ73tMzT
        eDiyAWtDoc5Mp1b7lA1OTQpl/g07wV8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-72-UEvE9EtPOiS63v-GgFcrDg-1; Thu, 24 Sep 2020 10:58:25 -0400
X-MC-Unique: UEvE9EtPOiS63v-GgFcrDg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B87D1084CA7;
        Thu, 24 Sep 2020 14:58:24 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.192.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 92FEC5576C;
        Thu, 24 Sep 2020 14:58:19 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Jon Doron <arilou@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 7/7] KVM: selftests: test KVM_GET_SUPPORTED_HV_CPUID as a system ioctl
Date:   Thu, 24 Sep 2020 16:57:57 +0200
Message-Id: <20200924145757.1035782-8-vkuznets@redhat.com>
In-Reply-To: <20200924145757.1035782-1-vkuznets@redhat.com>
References: <20200924145757.1035782-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_GET_SUPPORTED_HV_CPUID is now supported as both vCPU and VM ioctl,
test that.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  2 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 26 +++++++++++
 .../selftests/kvm/x86_64/hyperv_cpuid.c       | 46 +++++++++++++------
 3 files changed, 59 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 919e161dd289..59482e4eb308 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -112,6 +112,8 @@ void vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid, unsigned long ioctl,
 int _vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid, unsigned long ioctl,
 		void *arg);
 void vm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
+void kvm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
+int _kvm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
 void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
 void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
 void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 74776ee228f2..d49e24a15836 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1518,6 +1518,32 @@ void vm_ioctl(struct kvm_vm *vm, unsigned long cmd, void *arg)
 		cmd, ret, errno, strerror(errno));
 }
 
+/*
+ * KVM system ioctl
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   cmd - Ioctl number
+ *   arg - Argument to pass to the ioctl
+ *
+ * Return: None
+ *
+ * Issues an arbitrary ioctl on a KVM fd.
+ */
+void kvm_ioctl(struct kvm_vm *vm, unsigned long cmd, void *arg)
+{
+	int ret;
+
+	ret = ioctl(vm->kvm_fd, cmd, arg);
+	TEST_ASSERT(ret == 0, "KVM ioctl %lu failed, rc: %i errno: %i (%s)",
+		cmd, ret, errno, strerror(errno));
+}
+
+int _kvm_ioctl(struct kvm_vm *vm, unsigned long cmd, void *arg)
+{
+	return ioctl(vm->kvm_fd, cmd, arg);
+}
+
 /*
  * VM Dump
  *
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
index 8b24cb2e6a19..414b7587f0f9 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
@@ -102,20 +102,23 @@ static void test_hv_cpuid(struct kvm_cpuid2 *hv_cpuid_entries)
 
 }
 
-void test_hv_cpuid_e2big(struct kvm_vm *vm)
+void test_hv_cpuid_e2big(struct kvm_vm *vm, bool system)
 {
 	static struct kvm_cpuid2 cpuid = {.nent = 0};
 	int ret;
 
-	ret = _vcpu_ioctl(vm, VCPU_ID, KVM_GET_SUPPORTED_HV_CPUID, &cpuid);
+	if (!system)
+		ret = _vcpu_ioctl(vm, VCPU_ID, KVM_GET_SUPPORTED_HV_CPUID, &cpuid);
+	else
+		ret = _kvm_ioctl(vm, KVM_GET_SUPPORTED_HV_CPUID, &cpuid);
 
 	TEST_ASSERT(ret == -1 && errno == E2BIG,
-		    "KVM_GET_SUPPORTED_HV_CPUID didn't fail with -E2BIG when"
-		    " it should have: %d %d", ret, errno);
+		    "%s KVM_GET_SUPPORTED_HV_CPUID didn't fail with -E2BIG when"
+		    " it should have: %d %d", system ? "KVM" : "vCPU", ret, errno);
 }
 
 
-struct kvm_cpuid2 *kvm_get_supported_hv_cpuid(struct kvm_vm *vm)
+struct kvm_cpuid2 *kvm_get_supported_hv_cpuid(struct kvm_vm *vm, bool system)
 {
 	int nent = 20; /* should be enough */
 	static struct kvm_cpuid2 *cpuid;
@@ -129,7 +132,10 @@ struct kvm_cpuid2 *kvm_get_supported_hv_cpuid(struct kvm_vm *vm)
 
 	cpuid->nent = nent;
 
-	vcpu_ioctl(vm, VCPU_ID, KVM_GET_SUPPORTED_HV_CPUID, cpuid);
+	if (!system)
+		vcpu_ioctl(vm, VCPU_ID, KVM_GET_SUPPORTED_HV_CPUID, cpuid);
+	else
+		kvm_ioctl(vm, KVM_GET_SUPPORTED_HV_CPUID, cpuid);
 
 	return cpuid;
 }
@@ -150,22 +156,32 @@ int main(int argc, char *argv[])
 		exit(KSFT_SKIP);
 	}
 
-	for (stage = 0; stage < 2; stage++) {
+	vm = vm_create_default(VCPU_ID, 0, guest_code);
+
+	for (stage = 0; stage < 4; stage++) {
+		bool do_sys_ioctl = stage > 1;
+
+		/* Stages 0/1 test vCPU ioctl, stages 2/3 system ioctl */
+		if (do_sys_ioctl && !kvm_check_cap(KVM_CAP_SYS_HYPERV_CPUID)) {
+			print_skip("KVM_CAP_SYS_HYPERV_CPUID not supported");
+			break;
+		}
 
-		vm = vm_create_default(VCPU_ID, 0, guest_code);
 		switch (stage) {
 		case 0:
-			test_hv_cpuid_e2big(vm);
-			continue;
+		case 2:
+			test_hv_cpuid_e2big(vm, do_sys_ioctl);
+			break;
 		case 1:
+		case 3:
+			hv_cpuid_entries = kvm_get_supported_hv_cpuid(vm, do_sys_ioctl);
+			test_hv_cpuid(hv_cpuid_entries);
+			free(hv_cpuid_entries);
 			break;
 		}
-
-		hv_cpuid_entries = kvm_get_supported_hv_cpuid(vm);
-		test_hv_cpuid(hv_cpuid_entries);
-		free(hv_cpuid_entries);
-		kvm_vm_free(vm);
 	}
 
+	kvm_vm_free(vm);
+
 	return 0;
 }
-- 
2.25.4

