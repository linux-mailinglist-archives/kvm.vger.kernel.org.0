Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B302551B333
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381612AbiEDXFW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 19:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379960AbiEDW7f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:59:35 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F89754BE9
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:52:40 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id t14-20020a1709028c8e00b0015cf7e541feso1376488plo.1
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=q6AIj817CevNnhok7TpRrpYhOGlmlSTBBZ+O77AbXM4=;
        b=j1qEmO9OjecSXax05N2m5U41H3uhMxD63Px2oDCRHoaj82dAvrkb6W4Sq2/n/sJbJM
         eIJkTe9PD3zvOE4J3rjo7Ha1lvSCLCzGoj+RMW9EVQJUVWB/rIJK2yopfb2b8vVGGzHf
         Ie7dk/mSVW834eTbZkIWAfzBllpqJXclOBFMocw69MzEJaaLb8xpN6DHbDDfLSiLBirn
         3oSs4AMLx9GYJK/f/1PrSH7acvSXt/PQ1dgAJkQo/Bi5PF7IzxUkDXKxgEw88ptCSEQ+
         ta9u2IRASLm3xslhhmL4qLKZItYF0Yrd0Z8/lBNz917rp5Oy4BsZgy9JfFUL9fmUwQkw
         171w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=q6AIj817CevNnhok7TpRrpYhOGlmlSTBBZ+O77AbXM4=;
        b=aozVDE/fJ7ICX7cn75vta+3Tsh2rC8XWPAkSXgTohMYFeJTRXJAjcBU8LiLMRr0W5J
         5nF9zyAFCuw3PGtAt1zq1qeb4+Hga9ECol17XwpZnlNuujmW4avQM/FlCc1+r1GSAd/J
         6/ZLZgUx9DD6iqY2LDi1TIe9dRkiWRpigGlkTkKo2mm9HzMcTBHpkKNr6wYJwcLJp+oG
         rGuslj3Su1O1YC+8sIX5wVVZYy9Qie1g8//fRbCIA3F/nB4/3ms+gqeMngrVbYYnl8Kg
         VG5IFNbUsV8RVSmo/LZ1CiqoiRSHqkvsUfCBYRxAyBbl+MGMja8JvqCx6hBz4E7uOtYJ
         v7Uw==
X-Gm-Message-State: AOAM5335v1FC9iD7g/5nf3wSj9nGgAzklaESp3RD6eo6363jwodoZKuY
        0l34QK8QIu7gczT7SNAykE5zXgMSm+I=
X-Google-Smtp-Source: ABdhPJyJLvij56MuiBVWtggNFnwOLahy86p2YU+mp6YYF+39YDpo2d3zxpWSNmKlBL+RNhgovKqLO560wXQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1ac8:b0:4fa:917f:c1aa with SMTP id
 f8-20020a056a001ac800b004fa917fc1aamr23244208pfv.2.1651704741153; Wed, 04 May
 2022 15:52:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:48:45 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-100-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 099/128] KVM: selftests: Convert steal_time away from VCPU_ID
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert steal_time to use vm_create_with_vcpus() and pass around a
'struct kvm_vcpu' object instead of requiring that the index into the
array of vCPUs for a given vCPU is also the ID of the vCPU.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/steal_time.c | 123 ++++++++++++-----------
 1 file changed, 62 insertions(+), 61 deletions(-)

diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index 741892cec1ea..2aca51d83079 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -58,36 +58,34 @@ static void guest_code(int cpu)
 	GUEST_DONE();
 }
 
-static void steal_time_init(struct kvm_vm *vm)
+static bool is_steal_time_supported(struct kvm_vcpu *vcpu)
 {
-	int i;
+	struct kvm_cpuid_entry2 *cpuid = kvm_get_supported_cpuid_entry(KVM_CPUID_FEATURES);
 
-	if (!(kvm_get_supported_cpuid_entry(KVM_CPUID_FEATURES)->eax &
-	      KVM_FEATURE_STEAL_TIME)) {
-		print_skip("steal-time not supported");
-		exit(KSFT_SKIP);
-	}
+	return cpuid && (cpuid->eax & KVM_FEATURE_STEAL_TIME);
+}
 
-	for (i = 0; i < NR_VCPUS; ++i) {
-		int ret;
+static void steal_time_init(struct kvm_vcpu *vcpu, uint32_t i)
+{
+	int ret;
 
-		/* ST_GPA_BASE is identity mapped */
-		st_gva[i] = (void *)(ST_GPA_BASE + i * STEAL_TIME_SIZE);
-		sync_global_to_guest(vm, st_gva[i]);
+	/* ST_GPA_BASE is identity mapped */
+	st_gva[i] = (void *)(ST_GPA_BASE + i * STEAL_TIME_SIZE);
+	sync_global_to_guest(vcpu->vm, st_gva[i]);
 
-		ret = _vcpu_set_msr(vm, i, MSR_KVM_STEAL_TIME, (ulong)st_gva[i] | KVM_STEAL_RESERVED_MASK);
-		TEST_ASSERT(ret == 0, "Bad GPA didn't fail");
+	ret = _vcpu_set_msr(vcpu->vm, vcpu->id, MSR_KVM_STEAL_TIME,
+			    (ulong)st_gva[i] | KVM_STEAL_RESERVED_MASK);
+	TEST_ASSERT(ret == 0, "Bad GPA didn't fail");
 
-		vcpu_set_msr(vm, i, MSR_KVM_STEAL_TIME, (ulong)st_gva[i] | KVM_MSR_ENABLED);
-	}
+	vcpu_set_msr(vcpu->vm, vcpu->id, MSR_KVM_STEAL_TIME, (ulong)st_gva[i] | KVM_MSR_ENABLED);
 }
 
-static void steal_time_dump(struct kvm_vm *vm, uint32_t vcpuid)
+static void steal_time_dump(struct kvm_vm *vm, uint32_t vcpu_idx)
 {
-	struct kvm_steal_time *st = addr_gva2hva(vm, (ulong)st_gva[vcpuid]);
+	struct kvm_steal_time *st = addr_gva2hva(vm, (ulong)st_gva[vcpu_idx]);
 	int i;
 
-	pr_info("VCPU%d:\n", vcpuid);
+	pr_info("VCPU%d:\n", vcpu_idx);
 	pr_info("    steal:     %lld\n", st->steal);
 	pr_info("    version:   %d\n", st->version);
 	pr_info("    flags:     %d\n", st->flags);
@@ -165,49 +163,50 @@ static void guest_code(int cpu)
 	GUEST_DONE();
 }
 
-static void steal_time_init(struct kvm_vm *vm)
+static bool is_steal_time_supported(struct kvm_vcpu *vcpu)
 {
 	struct kvm_device_attr dev = {
 		.group = KVM_ARM_VCPU_PVTIME_CTRL,
 		.attr = KVM_ARM_VCPU_PVTIME_IPA,
 	};
-	int i, ret;
 
-	ret = __vcpu_ioctl(vm, 0, KVM_HAS_DEVICE_ATTR, &dev);
-	if (ret != 0 && errno == ENXIO) {
-		print_skip("steal-time not supported");
-		exit(KSFT_SKIP);
-	}
-
-	for (i = 0; i < NR_VCPUS; ++i) {
-		uint64_t st_ipa;
+	return !__vcpu_ioctl(vcpu->vm, vcpu->id, KVM_HAS_DEVICE_ATTR, &dev);
+}
 
-		vcpu_ioctl(vm, i, KVM_HAS_DEVICE_ATTR, &dev);
+static void steal_time_init(struct kvm_vcpu *vcpu, uint32_t i)
+{
+	struct kvm_vm *vm = vcpu->vm;
+	uint64_t st_ipa;
+	int ret;
 
-		dev.addr = (uint64_t)&st_ipa;
+	struct kvm_device_attr dev = {
+		.group = KVM_ARM_VCPU_PVTIME_CTRL,
+		.attr = KVM_ARM_VCPU_PVTIME_IPA,
+		.addr = (uint64_t)&st_ipa,
+	};
 
-		/* ST_GPA_BASE is identity mapped */
-		st_gva[i] = (void *)(ST_GPA_BASE + i * STEAL_TIME_SIZE);
-		sync_global_to_guest(vm, st_gva[i]);
+	vcpu_ioctl(vm, vcpu->id, KVM_HAS_DEVICE_ATTR, &dev);
 
-		st_ipa = (ulong)st_gva[i] | 1;
-		ret = __vcpu_ioctl(vm, i, KVM_SET_DEVICE_ATTR, &dev);
-		TEST_ASSERT(ret == -1 && errno == EINVAL, "Bad IPA didn't report EINVAL");
+	/* ST_GPA_BASE is identity mapped */
+	st_gva[i] = (void *)(ST_GPA_BASE + i * STEAL_TIME_SIZE);
+	sync_global_to_guest(vm, st_gva[i]);
 
-		st_ipa = (ulong)st_gva[i];
-		vcpu_ioctl(vm, i, KVM_SET_DEVICE_ATTR, &dev);
+	st_ipa = (ulong)st_gva[i] | 1;
+	ret = __vcpu_ioctl(vm, vcpu->id, KVM_SET_DEVICE_ATTR, &dev);
+	TEST_ASSERT(ret == -1 && errno == EINVAL, "Bad IPA didn't report EINVAL");
 
-		ret = __vcpu_ioctl(vm, i, KVM_SET_DEVICE_ATTR, &dev);
-		TEST_ASSERT(ret == -1 && errno == EEXIST, "Set IPA twice without EEXIST");
+	st_ipa = (ulong)st_gva[i];
+	vcpu_ioctl(vm, vcpu->id, KVM_SET_DEVICE_ATTR, &dev);
 
-	}
+	ret = __vcpu_ioctl(vm, vcpu->id, KVM_SET_DEVICE_ATTR, &dev);
+	TEST_ASSERT(ret == -1 && errno == EEXIST, "Set IPA twice without EEXIST");
 }
 
-static void steal_time_dump(struct kvm_vm *vm, uint32_t vcpuid)
+static void steal_time_dump(struct kvm_vm *vm, uint32_t vcpu_idx)
 {
-	struct st_time *st = addr_gva2hva(vm, (ulong)st_gva[vcpuid]);
+	struct st_time *st = addr_gva2hva(vm, (ulong)st_gva[vcpu_idx]);
 
-	pr_info("VCPU%d:\n", vcpuid);
+	pr_info("VCPU%d:\n", vcpu_idx);
 	pr_info("    rev:     %d\n", st->rev);
 	pr_info("    attr:    %d\n", st->attr);
 	pr_info("    st_time: %ld\n", st->st_time);
@@ -231,15 +230,13 @@ static void *do_steal_time(void *arg)
 	return NULL;
 }
 
-static void run_vcpu(struct kvm_vm *vm, uint32_t vcpuid)
+static void run_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct ucall uc;
 
-	vcpu_args_set(vm, vcpuid, 1, vcpuid);
+	vcpu_run(vcpu->vm, vcpu->id);
 
-	vcpu_ioctl(vm, vcpuid, KVM_RUN, NULL);
-
-	switch (get_ucall(vm, vcpuid, &uc)) {
+	switch (get_ucall(vcpu->vm, vcpu->id, &uc)) {
 	case UCALL_SYNC:
 	case UCALL_DONE:
 		break;
@@ -248,12 +245,13 @@ static void run_vcpu(struct kvm_vm *vm, uint32_t vcpuid)
 			    __FILE__, uc.args[1]);
 	default:
 		TEST_ASSERT(false, "Unexpected exit: %s",
-			    exit_reason_str(vcpu_state(vm, vcpuid)->exit_reason));
+			    exit_reason_str(vcpu->run->exit_reason));
 	}
 }
 
 int main(int ac, char **av)
 {
+	struct kvm_vcpu *vcpus[NR_VCPUS];
 	struct kvm_vm *vm;
 	pthread_attr_t attr;
 	pthread_t thread;
@@ -273,26 +271,29 @@ int main(int ac, char **av)
 	pthread_attr_setaffinity_np(&attr, sizeof(cpu_set_t), &cpuset);
 	pthread_setaffinity_np(pthread_self(), sizeof(cpu_set_t), &cpuset);
 
-	/* Create a one VCPU guest and an identity mapped memslot for the steal time structure */
-	vm = vm_create_default(0, 0, guest_code);
+	/* Create a VM and an identity mapped memslot for the steal time structure */
+	vm = vm_create_with_vcpus(NR_VCPUS, guest_code, vcpus);
 	gpages = vm_calc_num_guest_pages(VM_MODE_DEFAULT, STEAL_TIME_SIZE * NR_VCPUS);
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, ST_GPA_BASE, 1, gpages, 0);
 	virt_map(vm, ST_GPA_BASE, ST_GPA_BASE, gpages);
 	ucall_init(vm, NULL);
 
-	/* Add the rest of the VCPUs */
-	for (i = 1; i < NR_VCPUS; ++i)
-		vm_vcpu_add(vm, i, guest_code);
-
-	steal_time_init(vm);
+	if (!is_steal_time_supported(vcpus[0])) {
+		print_skip("steal-time not supported");
+		exit(KSFT_SKIP);
+	}
 
 	/* Run test on each VCPU */
 	for (i = 0; i < NR_VCPUS; ++i) {
+		steal_time_init(vcpus[i], i);
+
+		vcpu_args_set(vm, vcpus[i]->id, 1, i);
+
 		/* First VCPU run initializes steal-time */
-		run_vcpu(vm, i);
+		run_vcpu(vcpus[i]);
 
 		/* Second VCPU run, expect guest stolen time to be <= run_delay */
-		run_vcpu(vm, i);
+		run_vcpu(vcpus[i]);
 		sync_global_from_guest(vm, guest_stolen_time[i]);
 		stolen_time = guest_stolen_time[i];
 		run_delay = get_run_delay();
@@ -313,7 +314,7 @@ int main(int ac, char **av)
 			    MIN_RUN_DELAY_NS, run_delay);
 
 		/* Run VCPU again to confirm stolen time is consistent with run_delay */
-		run_vcpu(vm, i);
+		run_vcpu(vcpus[i]);
 		sync_global_from_guest(vm, guest_stolen_time[i]);
 		stolen_time = guest_stolen_time[i] - stolen_time;
 		TEST_ASSERT(stolen_time >= run_delay,
-- 
2.36.0.464.gb9c8b46e94-goog

