Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5BE12F4D4F
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 15:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbhAMOi5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 09:38:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38891 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725771AbhAMOi4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 09:38:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610548649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5zMyeAIJV4DWJz8SQHo1S/srnhlPuLS/oU/oJkunMYQ=;
        b=LyeaCS9WE3s98pQj2TXMgElE6RK52m4Zx09vm29Wq1CGk1wpULFYBx1bRMq9MTQBhWI6/X
        0Sy864bmnenwR7fEKbBQKAw2lM9xGeZGt7iHivABHehZHJQXZausJAKSJF/2NO5HrUFYTP
        cVLc78xKXJ5VuY2mi2m+afUtYh8PRFc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-EHc_DoUMMDqgSPN9Vn4L0Q-1; Wed, 13 Jan 2021 09:37:28 -0500
X-MC-Unique: EHc_DoUMMDqgSPN9Vn4L0Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C3E6D80A5C0;
        Wed, 13 Jan 2021 14:37:26 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2AAFE5C3E0;
        Wed, 13 Jan 2021 14:37:24 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 1/7] selftests: kvm: Move kvm_get_supported_hv_cpuid() to common code
Date:   Wed, 13 Jan 2021 15:37:15 +0100
Message-Id: <20210113143721.328594-2-vkuznets@redhat.com>
In-Reply-To: <20210113143721.328594-1-vkuznets@redhat.com>
References: <20210113143721.328594-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_get_supported_hv_cpuid() may come handy in all Hyper-V related tests.
Split it off hyperv_cpuid test, create system-wide and vcpu versions.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/include/x86_64/processor.h  |  3 ++
 .../selftests/kvm/lib/x86_64/processor.c      | 33 +++++++++++++++++++
 .../selftests/kvm/x86_64/hyperv_cpuid.c       | 31 ++---------------
 3 files changed, 39 insertions(+), 28 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 90cd5984751b..53c634a462f2 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -391,6 +391,9 @@ bool set_cpuid(struct kvm_cpuid2 *cpuid, struct kvm_cpuid_entry2 *ent);
 uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
 		       uint64_t a3);
 
+struct kvm_cpuid2 *kvm_get_supported_hv_cpuid(void);
+struct kvm_cpuid2 *vcpu_get_supported_hv_cpuid(struct kvm_vm *vm, uint32_t vcpuid);
+
 /*
  * Basic CPU control in CR0
  */
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 95e1a757c629..efb540c90732 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1224,3 +1224,36 @@ uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
 		     : "b"(a0), "c"(a1), "d"(a2), "S"(a3));
 	return r;
 }
+
+struct kvm_cpuid2 *kvm_get_supported_hv_cpuid(void)
+{
+	static struct kvm_cpuid2 *cpuid;
+	int ret;
+	int kvm_fd;
+
+	if (cpuid)
+		return cpuid;
+
+	cpuid = allocate_kvm_cpuid2();
+	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
+	if (kvm_fd < 0)
+		exit(KSFT_SKIP);
+
+	ret = ioctl(kvm_fd, KVM_GET_SUPPORTED_HV_CPUID, cpuid);
+	TEST_ASSERT(ret == 0, "KVM_GET_SUPPORTED_HV_CPUID failed %d %d\n",
+		    ret, errno);
+
+	close(kvm_fd);
+	return cpuid;
+}
+
+struct kvm_cpuid2 *vcpu_get_supported_hv_cpuid(struct kvm_vm *vm, uint32_t vcpuid)
+{
+	static struct kvm_cpuid2 *cpuid;
+
+	cpuid = allocate_kvm_cpuid2();
+
+	vcpu_ioctl(vm, vcpuid, KVM_GET_SUPPORTED_HV_CPUID, cpuid);
+
+	return cpuid;
+}
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
index 88a595b7fbdd..7e2d2d17d2ed 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
@@ -125,30 +125,6 @@ void test_hv_cpuid_e2big(struct kvm_vm *vm, bool system)
 		    " it should have: %d %d", system ? "KVM" : "vCPU", ret, errno);
 }
 
-
-struct kvm_cpuid2 *kvm_get_supported_hv_cpuid(struct kvm_vm *vm, bool system)
-{
-	int nent = 20; /* should be enough */
-	static struct kvm_cpuid2 *cpuid;
-
-	cpuid = malloc(sizeof(*cpuid) + nent * sizeof(struct kvm_cpuid_entry2));
-
-	if (!cpuid) {
-		perror("malloc");
-		abort();
-	}
-
-	cpuid->nent = nent;
-
-	if (!system)
-		vcpu_ioctl(vm, VCPU_ID, KVM_GET_SUPPORTED_HV_CPUID, cpuid);
-	else
-		kvm_ioctl(vm, KVM_GET_SUPPORTED_HV_CPUID, cpuid);
-
-	return cpuid;
-}
-
-
 int main(int argc, char *argv[])
 {
 	struct kvm_vm *vm;
@@ -167,7 +143,7 @@ int main(int argc, char *argv[])
 	/* Test vCPU ioctl version */
 	test_hv_cpuid_e2big(vm, false);
 
-	hv_cpuid_entries = kvm_get_supported_hv_cpuid(vm, false);
+	hv_cpuid_entries = vcpu_get_supported_hv_cpuid(vm, VCPU_ID);
 	test_hv_cpuid(hv_cpuid_entries, false);
 	free(hv_cpuid_entries);
 
@@ -177,7 +153,7 @@ int main(int argc, char *argv[])
 		goto do_sys;
 	}
 	vcpu_enable_evmcs(vm, VCPU_ID);
-	hv_cpuid_entries = kvm_get_supported_hv_cpuid(vm, false);
+	hv_cpuid_entries = vcpu_get_supported_hv_cpuid(vm, VCPU_ID);
 	test_hv_cpuid(hv_cpuid_entries, true);
 	free(hv_cpuid_entries);
 
@@ -190,9 +166,8 @@ int main(int argc, char *argv[])
 
 	test_hv_cpuid_e2big(vm, true);
 
-	hv_cpuid_entries = kvm_get_supported_hv_cpuid(vm, true);
+	hv_cpuid_entries = kvm_get_supported_hv_cpuid();
 	test_hv_cpuid(hv_cpuid_entries, nested_vmx_supported());
-	free(hv_cpuid_entries);
 
 out:
 	kvm_vm_free(vm);
-- 
2.29.2

