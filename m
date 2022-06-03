Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3133253C32E
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240187AbiFCApA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240041AbiFCAoW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:44:22 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4CE937A2D
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:44:17 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 35-20020a631563000000b003fc09751ce5so3040411pgv.10
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=OXQvDq5c+53444Ptu0CgkXQ3o+FDWBuSilxQ50BpCEk=;
        b=gAwOLU/9gNV9qZ+3OgdToMAUFmtOsQg0+7szKH5bmwaZ4zhwAvIbOMa+m31nlH5Sl7
         DWXxvV0CkQ51c5CMkjwmO3uUoBC8lqjQZONU7gaKEpEIXRdZSgl4OT6Pjdy2foCuvcPI
         2wYawDyrGCMdXi6CNt2n5MwP07TLsiK2TGZ1kZFhkLPu1t4Sx1Cu3Rl9YgoP8hKdfzeG
         7YRq4lQKg6mFRljpe+Dr02/hKLQWBmamm7C+Bi1Xhy/xIvbOU0g/KNpMPBXn4PDEu/LS
         fUddgCqxlBeWf3zDLKKiBl5jyz+mwyGWL16Jl86OAmbFghF54EAlKULKw0VICLsGng5g
         0rdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=OXQvDq5c+53444Ptu0CgkXQ3o+FDWBuSilxQ50BpCEk=;
        b=VRzsTsT264v9DTrrJibLdp02vXDr5j/psUj7hg4gwzlh5UikD9KdrPKE8xo0fDKMzs
         BEqzsgXMwXv94myeGX0f6DU245dSp8015nUOMTxGI6dd3tSEAIhk8+uvVNAfWa5wArDv
         koTpMOyQ3K8qQmaaQqfVKPksncQSsWesTMJAWBPfpBlntXL2RJ9taDwZWgibIXyzvONb
         PoezlPGivr3i791EotQuXMHVQAR0Fh45ctvzeCp8COc9jX4J4skEQPOlhq16XoG9uN6i
         c3+fnPteEDPpjiVz+vl97Qt+a4ezd3m7cTaDFIUZqEF9dVKuCuU5+Dgnu+56+qBWjn6b
         biGA==
X-Gm-Message-State: AOAM531O6+3BnP7b/sm+iHbfHKvpg2KxkSYojs3UAWdPWk2g4T44mE1W
        qYn2YJuMNU9JIUFNeWRBhtuIvy1tsF4=
X-Google-Smtp-Source: ABdhPJxWvqkRcE09cQJPwI9fgPyLh0yyxFOXswNUzliwdQqHPUn6K17rmTlZKxx6D6spi1/kFyPA6Wt+Tuc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:26cf:b0:4f6:fc52:7b6a with SMTP id
 p15-20020a056a0026cf00b004f6fc527b6amr74256027pfw.39.1654217057377; Thu, 02
 Jun 2022 17:44:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:30 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-24-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 023/144] KVM: selftests: Drop @test param from kvm_create_device()
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the two calls that pass @test=true to kvm_create_device() and drop
the @test param entirely.  The two removed calls don't check the return
value of kvm_create_device(), so other than verifying KVM doesn't explode,
which is extremely unlikely given that the non-test variant was _just_
called, they are pointless and provide no validation coverage.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/aarch64/vgic_init.c    | 14 ++++++--------
 .../testing/selftests/kvm/include/kvm_util_base.h  |  2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         | 12 ++++--------
 3 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index a4d015e1d2f6..48b795eadafd 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -65,7 +65,7 @@ static struct vm_gic vm_gic_create_with_vcpus(uint32_t gic_dev_type, uint32_t nr
 
 	v.gic_dev_type = gic_dev_type;
 	v.vm = vm_create_default_with_vcpus(nr_vcpus, 0, 0, guest_code, NULL);
-	v.gic_fd = kvm_create_device(v.vm, gic_dev_type, false);
+	v.gic_fd = kvm_create_device(v.vm, gic_dev_type);
 
 	return v;
 }
@@ -406,7 +406,7 @@ static void test_v3_typer_accesses(void)
 
 	v.vm = vm_create_default(0, 0, guest_code);
 
-	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
+	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3);
 
 	vm_vcpu_add_default(v.vm, 3, guest_code);
 
@@ -486,7 +486,7 @@ static void test_v3_last_bit_redist_regions(void)
 
 	v.vm = vm_create_default_with_vcpus(6, 0, 0, guest_code, vcpuids);
 
-	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
+	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3);
 
 	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
 			  KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
@@ -535,7 +535,7 @@ static void test_v3_last_bit_single_rdist(void)
 
 	v.vm = vm_create_default_with_vcpus(6, 0, 0, guest_code, vcpuids);
 
-	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
+	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3);
 
 	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
 			  KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
@@ -602,7 +602,7 @@ static void test_v3_its_region(void)
 	int its_fd, ret;
 
 	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS);
-	its_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_ITS, false);
+	its_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_ITS);
 
 	addr = 0x401000;
 	ret = _kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
@@ -655,13 +655,11 @@ int test_kvm_device(uint32_t gic_dev_type)
 	ret = _kvm_create_device(v.vm, gic_dev_type, true, &fd);
 	if (ret)
 		return ret;
-	v.gic_fd = kvm_create_device(v.vm, gic_dev_type, false);
+	v.gic_fd = kvm_create_device(v.vm, gic_dev_type);
 
 	ret = _kvm_create_device(v.vm, gic_dev_type, false, &fd);
 	TEST_ASSERT(ret && errno == EEXIST, "create GIC device twice");
 
-	kvm_create_device(v.vm, gic_dev_type, true);
-
 	/* try to create the other gic_dev_type */
 	other = VGIC_DEV_IS_V2(gic_dev_type) ? KVM_DEV_TYPE_ARM_VGIC_V3
 					     : KVM_DEV_TYPE_ARM_VGIC_V2;
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index c0199f3b59bb..6e1926abb248 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -485,7 +485,7 @@ void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num, ...);
 int _kvm_device_check_attr(int dev_fd, uint32_t group, uint64_t attr);
 int kvm_device_check_attr(int dev_fd, uint32_t group, uint64_t attr);
 int _kvm_create_device(struct kvm_vm *vm, uint64_t type, bool test, int *fd);
-int kvm_create_device(struct kvm_vm *vm, uint64_t type, bool test);
+int kvm_create_device(struct kvm_vm *vm, uint64_t type);
 int _kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
 		       void *val, bool write);
 int kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index a57958a39c1b..cb2e42aa1c03 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1642,18 +1642,14 @@ int _kvm_create_device(struct kvm_vm *vm, uint64_t type, bool test, int *fd)
 	return ret;
 }
 
-int kvm_create_device(struct kvm_vm *vm, uint64_t type, bool test)
+int kvm_create_device(struct kvm_vm *vm, uint64_t type)
 {
 	int fd, ret;
 
-	ret = _kvm_create_device(vm, type, test, &fd);
+	ret = _kvm_create_device(vm, type, false, &fd);
 
-	if (!test) {
-		TEST_ASSERT(!ret,
-			    "KVM_CREATE_DEVICE IOCTL failed, rc: %i errno: %i", ret, errno);
-		return fd;
-	}
-	return ret;
+	TEST_ASSERT(!ret, "KVM_CREATE_DEVICE IOCTL failed, rc: %i errno: %i", ret, errno);
+	return fd;
 }
 
 int _kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
-- 
2.36.1.255.ge46751e96f-goog

