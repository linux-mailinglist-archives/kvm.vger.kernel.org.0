Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCFA298337
	for <lists+kvm@lfdr.de>; Sun, 25 Oct 2020 19:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1418331AbgJYSxq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Oct 2020 14:53:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42717 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1417005AbgJYSxn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 25 Oct 2020 14:53:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603652021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VrcnpBHn5t+Btl97z9jvdq3FNw8fdJ9uB7f9070VgDQ=;
        b=iz/aBRtjK3wqpXyHfpf7NLKR5wV72/y0d3tALSlVBGbBN08iZt4jplHgzq9mqq0XCdD/lQ
        L7wKNsm+ufLQDE9FhlyL4M1h3ZS+UKyU1mki5siJqJrkMEgZAyv2dK3aYUIBV7cJvexHkZ
        s+r6Hvk53NRi5S0wn8DsVkPyPgI969A=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-eb5_13N4NKWNxc2ED6c69A-1; Sun, 25 Oct 2020 14:53:39 -0400
X-MC-Unique: eb5_13N4NKWNxc2ED6c69A-1
Received: by mail-qt1-f197.google.com with SMTP id d6so4938467qtp.2
        for <kvm@vger.kernel.org>; Sun, 25 Oct 2020 11:53:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VrcnpBHn5t+Btl97z9jvdq3FNw8fdJ9uB7f9070VgDQ=;
        b=d5IfzlCbt9/nbqZIyk3ZYG+siqteBf4iE8sRcj6g7phg3n86bB2wvSAyGpEkwtAg8h
         Wghc/5Kco/4Ac4F8b/xJ/fwcKdIbbMZWtbIVUUX7/daQ8CqjgK5KT4vvq24HlG5WLMOm
         LWyif7JXF32PqktIhSgR7+QfOfslKDGbYJjFjOwkuxYc1UnAihX1/FdGmbobEu0gSYtQ
         MbtDjNK7m8FZf87KilrLt/HvJ8la/OXC5lps8EhjOqna1a5mIBZXvM2klPxRGnBIEgsw
         Z/4FMOQS7HrqBEv4wAIlrry9lcI3WlA6+PhaMjQC9mqkcqBlLRKRR4w/BEplFKNnrYSO
         Z92w==
X-Gm-Message-State: AOAM530y75H8W95HjPPKbufaaPaqRctHY3mBbeXzXnEccEeunhHkzusM
        K6jXPv8Wqk1r9BBzL/cPF/0+l1SAo7sNHMSBLIlHeC1+XtK0zEXO4EXVbn8IOhSQE6pDMJ6BV42
        xWs9HNv4+jTtI
X-Received: by 2002:aed:2d62:: with SMTP id h89mr13213913qtd.108.1603652019219;
        Sun, 25 Oct 2020 11:53:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxYDlptSJ6GU33UiUx9KGSnwRp59ERcPYRR25wYM2MrcjvAUTN1PTGqDdcwUWD4EpoaK/i3ig==
X-Received: by 2002:aed:2d62:: with SMTP id h89mr13213894qtd.108.1603652018972;
        Sun, 25 Oct 2020 11:53:38 -0700 (PDT)
Received: from xz-x1.redhat.com (toroon474qw-lp140-04-174-95-215-133.dsl.bell.ca. [174.95.215.133])
        by smtp.gmail.com with ESMTPSA id y3sm5305224qto.2.2020.10.25.11.53.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2020 11:53:38 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 1/2] KVM: selftests: Add get featured msrs test case
Date:   Sun, 25 Oct 2020 14:53:33 -0400
Message-Id: <20201025185334.389061-2-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201025185334.389061-1-peterx@redhat.com>
References: <20201025185334.389061-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Try to fetch any supported featured msr.  Currently it won't fail, so at least
we can check against valid ones (which should be >0).

This reproduces [1] too by trying to fetch one invalid msr there.

[1] https://bugzilla.kernel.org/show_bug.cgi?id=209845

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  3 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 14 +++++
 .../testing/selftests/kvm/x86_64/state_test.c | 58 +++++++++++++++++++
 3 files changed, 75 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 919e161dd289..e34cf263b20a 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -66,6 +66,9 @@ int vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap);
 
 struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm);
 struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm);
+void kvm_vm_get_msr_feature_index_list(struct kvm_vm *vm,
+				       struct kvm_msr_list *list);
+int kvm_vm_get_feature_msrs(struct kvm_vm *vm, struct kvm_msrs *msrs);
 void kvm_vm_free(struct kvm_vm *vmp);
 void kvm_vm_restart(struct kvm_vm *vmp, int perm);
 void kvm_vm_release(struct kvm_vm *vmp);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 74776ee228f2..3c16fa044335 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -132,6 +132,20 @@ static const struct vm_guest_mode_params vm_guest_mode_params[] = {
 _Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_params) == NUM_VM_MODES,
 	       "Missing new mode params?");
 
+void kvm_vm_get_msr_feature_index_list(struct kvm_vm *vm,
+				       struct kvm_msr_list *list)
+{
+	int r = ioctl(vm->kvm_fd, KVM_GET_MSR_FEATURE_INDEX_LIST, list);
+
+	TEST_ASSERT(r == 0, "KVM_GET_MSR_FEATURE_INDEX_LIST failed: %d\n",
+		    -errno);
+}
+
+int kvm_vm_get_feature_msrs(struct kvm_vm *vm, struct kvm_msrs *msrs)
+{
+	return ioctl(vm->kvm_fd, KVM_GET_MSRS, msrs);
+}
+
 /*
  * VM Create
  *
diff --git a/tools/testing/selftests/kvm/x86_64/state_test.c b/tools/testing/selftests/kvm/x86_64/state_test.c
index f6c8b9042f8a..7ce9920e526a 100644
--- a/tools/testing/selftests/kvm/x86_64/state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/state_test.c
@@ -152,6 +152,61 @@ static void __attribute__((__flatten__)) guest_code(void *arg)
 	GUEST_DONE();
 }
 
+#define  KVM_MSR_FEATURE_N  64
+
+static int test_kvm_get_feature_msr_one(struct kvm_vm *vm, __u32 index,
+					struct kvm_msrs *msrs)
+{
+	msrs->nmsrs = 1;
+	msrs->entries[0].index = index;
+	return kvm_vm_get_feature_msrs(vm, msrs);
+}
+
+static void test_kvm_get_msr_features(struct kvm_vm *vm)
+{
+	struct kvm_msr_list *msr_list;
+	struct kvm_msrs *msrs;
+	int i, ret, sum;
+
+	if (!kvm_check_cap(KVM_CAP_GET_MSR_FEATURES)) {
+		pr_info("skipping kvm get msr features test\n");
+		return;
+	}
+
+	msr_list = calloc(1, sizeof(struct kvm_msr_list) +
+			  sizeof(__u32) * KVM_MSR_FEATURE_N);
+	msr_list->nmsrs = KVM_MSR_FEATURE_N;
+
+	TEST_ASSERT(msr_list, "msr_list allocation failed\n");
+
+	kvm_vm_get_msr_feature_index_list(vm, msr_list);
+
+	msrs = calloc(1, sizeof(struct kvm_msrs) +
+		      sizeof(struct kvm_msr_entry));
+
+	TEST_ASSERT(msrs, "msr entries allocation failed\n");
+
+	sum = 0;
+	for (i = 0; i < msr_list->nmsrs; i++) {
+		ret = test_kvm_get_feature_msr_one(vm, msr_list->indices[i],
+						    msrs);
+		TEST_ASSERT(ret >= 0, "KVM_GET_MSR failed: %d\n", ret);
+		sum += ret;
+	}
+	TEST_ASSERT(sum > 0, "KVM_GET_MSR has no feature msr\n");
+
+	/*
+	 * Test invalid msr.  Note the retcode can be either 0 or 1 depending
+	 * on kvm.ignore_msrs
+	 */
+	ret = test_kvm_get_feature_msr_one(vm, (__u32)-1, msrs);
+	TEST_ASSERT(ret >= 0 && ret <= 1,
+		    "KVM_GET_MSR on invalid msr error: %d\n", ret);
+
+	free(msrs);
+	free(msr_list);
+}
+
 int main(int argc, char *argv[])
 {
 	vm_vaddr_t nested_gva = 0;
@@ -168,6 +223,9 @@ int main(int argc, char *argv[])
 	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
 	run = vcpu_state(vm, VCPU_ID);
 
+	/* Test KVM_GET_MSR for VM */
+	test_kvm_get_msr_features(vm);
+
 	vcpu_regs_get(vm, VCPU_ID, &regs1);
 
 	if (kvm_check_cap(KVM_CAP_NESTED_STATE)) {
-- 
2.26.2

