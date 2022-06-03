Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1A8553C304
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240141AbiFCApV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239969AbiFCAoV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:44:21 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE85422517
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:44:08 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id j8-20020a17090a3e0800b001e3425c05c4so3421501pjc.0
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=QYfBZhfEoxcJclTEblxPGQpJYzp1UV5q8tCK6+roE/8=;
        b=blkwkAJiFLQpO5lTvGJ0fd8MlLTj7DRKa2ciDUdUjjeocEdjh1CujZmGi3eQvhB9/0
         03KmLYLj/VbLhFVCyokMtxcK9FtPEYsFAed3qw/ZYuFHr/iQDq7kUVTQjmkuSQ5awre1
         VndiOzUP8fwCOHkZljMN5XDMmWh7UFWhdJYDFRKMTYw+EptAGfs1aWoFed9IhyAgtbQJ
         S92TXZTVOlp9+Giv+2/io2Sydw+Hx12FJQieNlF3hdHqNTLtI8/if+Volt4SF+hOviRh
         0gz/D9Sy6ZR3iThenp0yYC7+UaLyAOuu1kMaD6mIebsRbBLN+y76V+jqI/uJz70tZkOR
         Nb1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=QYfBZhfEoxcJclTEblxPGQpJYzp1UV5q8tCK6+roE/8=;
        b=wbD/uHM07hsGsuCT8ZNcwNlKYvDt9M7VNbqKgYR8Nqu5mX+7PTDPYNGo7yKF6EpXh6
         JNDOYFgGt9qeJAYHC8jQG9BBh2TWUKCUWbZiCLes+AvYVKikXtDdfO1M5wNG5KySeZ5f
         1slgZNVhSBb4NgC3rPWxSEnseIQZpavZ0FlbPBRz5Idmyyph09anjDW0AmfnymvSstMx
         sGyv460Kkkmmz+sJSnB0xEQveC8jtE5XyxL9/Hh6V+BSYOcXbCcUHqbI5tqqpiXq8xNO
         9zpnQgGeXbB9ZmGzX49vz5IzZhybCA1Rw0BETxTpl1OV7TARiztHJ5xxI2Z0yehO0fzd
         d4mg==
X-Gm-Message-State: AOAM5314jxYwLSNADar0olYCWkts55C0YNxBm5NUM1I3S0GROGANT63M
        MmbNUEnVyf8NLeKytn5e/fx5bi2u66k=
X-Google-Smtp-Source: ABdhPJyrGnwfof7h5GshLqPWCtDr100oxkl5tjjdVjCpQ0Hpd6yKmHeUV76RE8Np+HCadQKpn+quIAfWhjc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2311:b0:4e1:52bf:e466 with SMTP id
 h17-20020a056a00231100b004e152bfe466mr17323401pfh.77.1654217048323; Thu, 02
 Jun 2022 17:44:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:25 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-19-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 018/144] KVM: selftests: Use kvm_ioctl() helpers
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the recently introduced KVM-specific ioctl() helpers instead of open
coding calls to ioctl() just to pretty print the ioctl name.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/lib/aarch64/processor.c     |  4 +--
 tools/testing/selftests/kvm/lib/guest_modes.c |  2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 13 +++----
 .../selftests/kvm/lib/x86_64/processor.c      | 34 ++++++-------------
 .../kvm/x86_64/get_msr_index_features.c       | 16 +++------
 .../selftests/kvm/x86_64/mmio_warning_test.c  |  6 ++--
 6 files changed, 26 insertions(+), 49 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 6a041289fa80..d28cc12cea1d 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -469,8 +469,8 @@ void aarch64_get_supported_page_sizes(uint32_t ipa,
 	};
 
 	kvm_fd = open_kvm_dev_path_or_exit();
-	vm_fd = ioctl(kvm_fd, KVM_CREATE_VM, ipa);
-	TEST_ASSERT(vm_fd >= 0, "Can't create VM");
+	vm_fd = __kvm_ioctl(kvm_fd, KVM_CREATE_VM, ipa);
+	TEST_ASSERT(vm_fd >= 0, KVM_IOCTL_ERROR(KVM_CREATE_VM, vm_fd));
 
 	vcpu_fd = ioctl(vm_fd, KVM_CREATE_VCPU, 0);
 	TEST_ASSERT(vcpu_fd >= 0, "Can't create vcpu");
diff --git a/tools/testing/selftests/kvm/lib/guest_modes.c b/tools/testing/selftests/kvm/lib/guest_modes.c
index 8784013b747c..9ab27b4169bf 100644
--- a/tools/testing/selftests/kvm/lib/guest_modes.c
+++ b/tools/testing/selftests/kvm/lib/guest_modes.c
@@ -65,7 +65,7 @@ void guest_modes_append_default(void)
 		struct kvm_s390_vm_cpu_processor info;
 
 		kvm_fd = open_kvm_dev_path_or_exit();
-		vm_fd = ioctl(kvm_fd, KVM_CREATE_VM, 0);
+		vm_fd = __kvm_ioctl(kvm_fd, KVM_CREATE_VM, 0);
 		kvm_device_access(vm_fd, KVM_S390_VM_CPU_MODEL,
 				  KVM_S390_VM_CPU_PROCESSOR, &info, false);
 		close(vm_fd);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index ac8faf072288..4d2748e8428a 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -76,9 +76,8 @@ int kvm_check_cap(long cap)
 	int kvm_fd;
 
 	kvm_fd = open_kvm_dev_path_or_exit();
-	ret = ioctl(kvm_fd, KVM_CHECK_EXTENSION, cap);
-	TEST_ASSERT(ret >= 0, "KVM_CHECK_EXTENSION IOCTL failed,\n"
-		"  rc: %i errno: %i", ret, errno);
+	ret = __kvm_ioctl(kvm_fd, KVM_CHECK_EXTENSION, cap);
+	TEST_ASSERT(ret >= 0, KVM_IOCTL_ERROR(KVM_CHECK_EXTENSION, ret));
 
 	close(kvm_fd);
 
@@ -104,9 +103,8 @@ static void vm_open(struct kvm_vm *vm)
 		exit(KSFT_SKIP);
 	}
 
-	vm->fd = ioctl(vm->kvm_fd, KVM_CREATE_VM, vm->type);
-	TEST_ASSERT(vm->fd >= 0, "KVM_CREATE_VM ioctl failed, "
-		"rc: %i errno: %i", vm->fd, errno);
+	vm->fd = __kvm_ioctl(vm->kvm_fd, KVM_CREATE_VM, vm->type);
+	TEST_ASSERT(vm->fd >= 0, KVM_IOCTL_ERROR(KVM_CREATE_VM, vm->fd));
 }
 
 const char *vm_guest_mode_string(uint32_t i)
@@ -1070,8 +1068,7 @@ static int vcpu_mmap_sz(void)
 
 	ret = ioctl(dev_fd, KVM_GET_VCPU_MMAP_SIZE, NULL);
 	TEST_ASSERT(ret >= sizeof(struct kvm_run),
-		"%s KVM_GET_VCPU_MMAP_SIZE ioctl failed, rc: %i errno: %i",
-		__func__, ret, errno);
+		    KVM_IOCTL_ERROR(KVM_GET_VCPU_MMAP_SIZE, ret));
 
 	close(dev_fd);
 
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index bd9d1b63b848..6113cf6bb238 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -639,7 +639,7 @@ void vm_xsave_req_perm(int bit)
 	};
 
 	kvm_fd = open_kvm_dev_path_or_exit();
-	rc = ioctl(kvm_fd, KVM_GET_DEVICE_ATTR, &attr);
+	rc = __kvm_ioctl(kvm_fd, KVM_GET_DEVICE_ATTR, &attr);
 	close(kvm_fd);
 	if (rc == -1 && (errno == ENXIO || errno == EINVAL))
 		exit(KSFT_SKIP);
@@ -739,7 +739,6 @@ static struct kvm_cpuid2 *allocate_kvm_cpuid2(void)
 struct kvm_cpuid2 *kvm_get_supported_cpuid(void)
 {
 	static struct kvm_cpuid2 *cpuid;
-	int ret;
 	int kvm_fd;
 
 	if (cpuid)
@@ -748,9 +747,7 @@ struct kvm_cpuid2 *kvm_get_supported_cpuid(void)
 	cpuid = allocate_kvm_cpuid2();
 	kvm_fd = open_kvm_dev_path_or_exit();
 
-	ret = ioctl(kvm_fd, KVM_GET_SUPPORTED_CPUID, cpuid);
-	TEST_ASSERT(ret == 0, "KVM_GET_SUPPORTED_CPUID failed %d %d\n",
-		    ret, errno);
+	kvm_ioctl(kvm_fd, KVM_GET_SUPPORTED_CPUID, cpuid);
 
 	close(kvm_fd);
 	return cpuid;
@@ -780,9 +777,8 @@ uint64_t kvm_get_feature_msr(uint64_t msr_index)
 	buffer.entry.index = msr_index;
 	kvm_fd = open_kvm_dev_path_or_exit();
 
-	r = ioctl(kvm_fd, KVM_GET_MSRS, &buffer.header);
-	TEST_ASSERT(r == 1, "KVM_GET_MSRS IOCTL failed,\n"
-		"  rc: %i errno: %i", r, errno);
+	r = __kvm_ioctl(kvm_fd, KVM_GET_MSRS, &buffer.header);
+	TEST_ASSERT(r == 1, KVM_IOCTL_ERROR(KVM_GET_MSRS, r));
 
 	close(kvm_fd);
 	return buffer.entry.data;
@@ -947,9 +943,9 @@ static int kvm_get_num_msrs_fd(int kvm_fd)
 	int r;
 
 	nmsrs.nmsrs = 0;
-	r = ioctl(kvm_fd, KVM_GET_MSR_INDEX_LIST, &nmsrs);
-	TEST_ASSERT(r == -1 && errno == E2BIG, "Unexpected result from KVM_GET_MSR_INDEX_LIST probe, r: %i",
-		r);
+	r = __kvm_ioctl(kvm_fd, KVM_GET_MSR_INDEX_LIST, &nmsrs);
+	TEST_ASSERT(r == -1 && errno == E2BIG,
+		    "Unexpected result from KVM_GET_MSR_INDEX_LIST probe, r: %i", r);
 
 	return nmsrs.nmsrs;
 }
@@ -962,19 +958,16 @@ static int kvm_get_num_msrs(struct kvm_vm *vm)
 struct kvm_msr_list *kvm_get_msr_index_list(void)
 {
 	struct kvm_msr_list *list;
-	int nmsrs, r, kvm_fd;
+	int nmsrs, kvm_fd;
 
 	kvm_fd = open_kvm_dev_path_or_exit();
 
 	nmsrs = kvm_get_num_msrs_fd(kvm_fd);
 	list = malloc(sizeof(*list) + nmsrs * sizeof(list->indices[0]));
 	list->nmsrs = nmsrs;
-	r = ioctl(kvm_fd, KVM_GET_MSR_INDEX_LIST, list);
+	kvm_ioctl(kvm_fd, KVM_GET_MSR_INDEX_LIST, list);
 	close(kvm_fd);
 
-	TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_MSR_INDEX_LIST, r: %i",
-		r);
-
 	return list;
 }
 
@@ -1020,9 +1013,7 @@ struct kvm_x86_state *vcpu_save_state(struct kvm_vm *vm, uint32_t vcpuid)
 	nmsrs = kvm_get_num_msrs(vm);
 	list = malloc(sizeof(*list) + nmsrs * sizeof(list->indices[0]));
 	list->nmsrs = nmsrs;
-	r = ioctl(vm->kvm_fd, KVM_GET_MSR_INDEX_LIST, list);
-	TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_MSR_INDEX_LIST, r: %i",
-		    r);
+	kvm_ioctl(vm->kvm_fd, KVM_GET_MSR_INDEX_LIST, list);
 
 	state = malloc(sizeof(*state) + nmsrs * sizeof(state->msrs.entries[0]));
 	r = ioctl(vcpu->fd, KVM_GET_VCPU_EVENTS, &state->events);
@@ -1330,7 +1321,6 @@ uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
 struct kvm_cpuid2 *kvm_get_supported_hv_cpuid(void)
 {
 	static struct kvm_cpuid2 *cpuid;
-	int ret;
 	int kvm_fd;
 
 	if (cpuid)
@@ -1339,9 +1329,7 @@ struct kvm_cpuid2 *kvm_get_supported_hv_cpuid(void)
 	cpuid = allocate_kvm_cpuid2();
 	kvm_fd = open_kvm_dev_path_or_exit();
 
-	ret = ioctl(kvm_fd, KVM_GET_SUPPORTED_HV_CPUID, cpuid);
-	TEST_ASSERT(ret == 0, "KVM_GET_SUPPORTED_HV_CPUID failed %d %d\n",
-		    ret, errno);
+	kvm_ioctl(kvm_fd, KVM_GET_SUPPORTED_HV_CPUID, cpuid);
 
 	close(kvm_fd);
 	return cpuid;
diff --git a/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c b/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c
index 8aed0db1331d..4ef60adbe108 100644
--- a/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c
+++ b/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c
@@ -34,7 +34,7 @@ static int kvm_num_index_msrs(int kvm_fd, int nmsrs)
 
 static void test_get_msr_index(void)
 {
-	int old_res, res, kvm_fd, r;
+	int old_res, res, kvm_fd;
 	struct kvm_msr_list *list;
 
 	kvm_fd = open_kvm_dev_path_or_exit();
@@ -50,11 +50,8 @@ static void test_get_msr_index(void)
 
 	list = malloc(sizeof(*list) + old_res * sizeof(list->indices[0]));
 	list->nmsrs = old_res;
-	r = ioctl(kvm_fd, KVM_GET_MSR_INDEX_LIST, list);
+	kvm_ioctl(kvm_fd, KVM_GET_MSR_INDEX_LIST, list);
 
-	TEST_ASSERT(r == 0,
-		    "Unexpected result from KVM_GET_MSR_FEATURE_INDEX_LIST, r: %i",
-		    r);
 	TEST_ASSERT(list->nmsrs == old_res, "Expecting nmsrs to be identical");
 	free(list);
 
@@ -68,7 +65,7 @@ static int kvm_num_feature_msrs(int kvm_fd, int nmsrs)
 
 	list = malloc(sizeof(*list) + nmsrs * sizeof(list->indices[0]));
 	list->nmsrs = nmsrs;
-	r = ioctl(kvm_fd, KVM_GET_MSR_FEATURE_INDEX_LIST, list);
+	r = __kvm_ioctl(kvm_fd, KVM_GET_MSR_FEATURE_INDEX_LIST, list);
 	TEST_ASSERT(r == -1 && errno == E2BIG,
 		"Unexpected result from KVM_GET_MSR_FEATURE_INDEX_LIST probe, r: %i",
 				r);
@@ -81,15 +78,10 @@ static int kvm_num_feature_msrs(int kvm_fd, int nmsrs)
 struct kvm_msr_list *kvm_get_msr_feature_list(int kvm_fd, int nmsrs)
 {
 	struct kvm_msr_list *list;
-	int r;
 
 	list = malloc(sizeof(*list) + nmsrs * sizeof(list->indices[0]));
 	list->nmsrs = nmsrs;
-	r = ioctl(kvm_fd, KVM_GET_MSR_FEATURE_INDEX_LIST, list);
-
-	TEST_ASSERT(r == 0,
-		"Unexpected result from KVM_GET_MSR_FEATURE_INDEX_LIST, r: %i",
-		r);
+	kvm_ioctl(kvm_fd, KVM_GET_MSR_FEATURE_INDEX_LIST, list);
 
 	return list;
 }
diff --git a/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c b/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
index 9f55ccd169a1..31ae837fedb1 100644
--- a/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
+++ b/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
@@ -59,10 +59,10 @@ void test(void)
 
 	kvm = open("/dev/kvm", O_RDWR);
 	TEST_ASSERT(kvm != -1, "failed to open /dev/kvm");
-	kvmvm = ioctl(kvm, KVM_CREATE_VM, 0);
-	TEST_ASSERT(kvmvm != -1, "KVM_CREATE_VM failed");
+	kvmvm = __kvm_ioctl(kvm, KVM_CREATE_VM, 0);
+	TEST_ASSERT(kvmvm > 0, KVM_IOCTL_ERROR(KVM_CREATE_VM, kvmvm));
 	kvmcpu = ioctl(kvmvm, KVM_CREATE_VCPU, 0);
-	TEST_ASSERT(kvmcpu != -1, "KVM_CREATE_VCPU failed");
+	TEST_ASSERT(kvmcpu != -1, KVM_IOCTL_ERROR(KVM_CREATE_VCPU, kvmcpu));
 	run = (struct kvm_run *)mmap(0, 4096, PROT_READ|PROT_WRITE, MAP_SHARED,
 				    kvmcpu, 0);
 	tc.kvmcpu = kvmcpu;
-- 
2.36.1.255.ge46751e96f-goog

