Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1AE451B337
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379633AbiEDW4x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379416AbiEDWyC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:54:02 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A745F79
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:50:18 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id x2-20020a63aa42000000b003aafe948eeeso1363887pgo.0
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=1smiTzplsA+5I+VbVQjMxietgrZ80FuScv91SEXkGbg=;
        b=JJgEx0eBp1ei1timWg3sxYWSP0yyAPZTmu5RWw7psUUdgXeY+Zh71zTqcd3I5LHWUl
         jitUEDO0ml/IwQcm24zPEfdUpyHqlolW2kTyOJvwI2GOZjwWRvFsMcfsr1EcXz2U48Q3
         nBF8hAzX6rXoVT5aFwiSQCBZ+Maa/p1FK/M6N9qPJlskM4vASu40zfxKDfmVEGzVhcN7
         ImB2gCx2ERMYa0WO75dIBLI39JduKKCw5oT/NYVqCW9xb6DrH4eLKFN05Xqq+dR6SSfA
         O5k+dpP+ZEX3oIqAQG8YD/7biZXjx8jeYrDfiMT3MY3XXLBk0qE5LcvRIGL/FHEfonRl
         dxww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=1smiTzplsA+5I+VbVQjMxietgrZ80FuScv91SEXkGbg=;
        b=ABAdZze0dmOnQal84HI/C510deuxwO/jEBwsDCc8Zjv8qPVsObKRQvzfesuANd8oUl
         0MLGaYWuO5rmdNX4c6PexDeTAxA1wti20baeFyZsaw7QMykbqsvG8HmOjNF83sKlps0K
         0AXMQCGzmIO+tMnVeOa+T6qmV0qyRIAhLmjFHr0uzjowYPNfTyoxMp4O4hcytOBI2WDK
         vmgfL9Nwwf8DaNXm5vdAabQqTWvGqQXnKW6IDkbsXfcUBFs9CsgSJpulkoJKo/o9lK3o
         8/3veu9Hm/l1Bj8oFM55RsyN0Dm1wmV7jjamt+sJTpFB2gMU1BAoyqHYE+UDoyWcA3LL
         fCBA==
X-Gm-Message-State: AOAM533MMnJ2va7Xoy0EMg6Q2BPvR3KD1m2fT1rwYhm2GF0XoDUamQS6
        KDRP/g4MBQRqXipuIDqasI1NvHrntF0=
X-Google-Smtp-Source: ABdhPJwzSUcbBefw5Pe7cLbTGcbH0fcQUXQS23VENgBdyOTw5t3zchmUuL+Rmzi/OVvBjFQHDuPVadaP+6w=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:801:b0:50d:ec66:fac0 with SMTP id
 m1-20020a056a00080100b0050dec66fac0mr16586722pfk.23.1651704618391; Wed, 04
 May 2022 15:50:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:47:33 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-28-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 027/128] KVM: selftests: Split get/set device_attr helpers
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

Split the get/set device_attr helpers instead of using a boolean param to
select between get and set.  Duplicating upper level wrappers is a very,
very small price to pay for improved readability.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/aarch64/arch_timer.c        |   8 +-
 .../testing/selftests/kvm/aarch64/vgic_init.c | 246 +++++++++---------
 .../selftests/kvm/include/kvm_util_base.h     | 105 +++++---
 .../testing/selftests/kvm/lib/aarch64/vgic.c  |  31 ++-
 tools/testing/selftests/kvm/lib/guest_modes.c |   4 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |  59 ++---
 .../kvm/system_counter_offset_test.c          |   4 +-
 7 files changed, 240 insertions(+), 217 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index f55c4c20d8b3..f04ca07c7f14 100644
--- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
@@ -349,10 +349,10 @@ static void test_run(struct kvm_vm *vm)
 static void test_init_timer_irq(struct kvm_vm *vm)
 {
 	/* Timer initid should be same for all the vCPUs, so query only vCPU-0 */
-	vcpu_access_device_attr(vm, 0, KVM_ARM_VCPU_TIMER_CTRL,
-				KVM_ARM_VCPU_TIMER_IRQ_PTIMER, &ptimer_irq, false);
-	vcpu_access_device_attr(vm, 0, KVM_ARM_VCPU_TIMER_CTRL,
-				KVM_ARM_VCPU_TIMER_IRQ_VTIMER, &vtimer_irq, false);
+	vcpu_device_attr_get(vm, 0, KVM_ARM_VCPU_TIMER_CTRL,
+			     KVM_ARM_VCPU_TIMER_IRQ_PTIMER, &ptimer_irq);
+	vcpu_device_attr_get(vm, 0, KVM_ARM_VCPU_TIMER_CTRL,
+			     KVM_ARM_VCPU_TIMER_IRQ_VTIMER, &vtimer_irq);
 
 	sync_global_to_guest(vm, ptimer_irq);
 	sync_global_to_guest(vm, vtimer_irq);
diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index 2425894b3775..0329aa04da31 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -33,13 +33,10 @@ struct vm_gic {
 static uint64_t max_phys_size;
 
 /* helper to access a redistributor register */
-static int access_v3_redist_reg(int gicv3_fd, int vcpu, int offset,
-				uint32_t *val, bool write)
+static int v3_redist_reg_get(int gicv3_fd, int vcpu, int offset, uint32_t *val)
 {
-	uint64_t attr = REG_OFFSET(vcpu, offset);
-
-	return _kvm_device_access(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_REDIST_REGS,
-				  attr, val, write);
+	return __kvm_device_attr_get(gicv3_fd, KVM_DEV_ARM_VGIC_GRP_REDIST_REGS,
+				     REG_OFFSET(vcpu, offset), val);
 }
 
 /* dummy guest code */
@@ -137,41 +134,41 @@ static void subtest_dist_rdist(struct vm_gic *v)
 
 	/* misaligned DIST and REDIST address settings */
 	addr = dist.alignment / 0x10;
-	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				 dist.attr, &addr, true);
+	ret = __kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    dist.attr, &addr);
 	TEST_ASSERT(ret && errno == EINVAL, "GIC dist base not aligned");
 
 	addr = rdist.alignment / 0x10;
-	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				 rdist.attr, &addr, true);
+	ret = __kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    rdist.attr, &addr);
 	TEST_ASSERT(ret && errno == EINVAL, "GIC redist/cpu base not aligned");
 
 	/* out of range address */
 	addr = max_phys_size;
-	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				 dist.attr, &addr, true);
+	ret = __kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    dist.attr, &addr);
 	TEST_ASSERT(ret && errno == E2BIG, "dist address beyond IPA limit");
 
-	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				 rdist.attr, &addr, true);
+	ret = __kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    rdist.attr, &addr);
 	TEST_ASSERT(ret && errno == E2BIG, "redist address beyond IPA limit");
 
 	/* Space for half a rdist (a rdist is: 2 * rdist.alignment). */
 	addr = max_phys_size - dist.alignment;
-	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				 rdist.attr, &addr, true);
+	ret = __kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    rdist.attr, &addr);
 	TEST_ASSERT(ret && errno == E2BIG,
 			"half of the redist is beyond IPA limit");
 
 	/* set REDIST base address @0x0*/
 	addr = 0x00000;
-	kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-			  rdist.attr, &addr, true);
+	kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    rdist.attr, &addr);
 
 	/* Attempt to create a second legacy redistributor region */
 	addr = 0xE0000;
-	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				 rdist.attr, &addr, true);
+	ret = __kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    rdist.attr, &addr);
 	TEST_ASSERT(ret && errno == EEXIST, "GIC redist base set again");
 
 	ret = __kvm_has_device_attr(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
@@ -179,9 +176,8 @@ static void subtest_dist_rdist(struct vm_gic *v)
 	if (!ret) {
 		/* Attempt to mix legacy and new redistributor regions */
 		addr = REDIST_REGION_ATTR_ADDR(NR_VCPUS, 0x100000, 0, 0);
-		ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-					 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION,
-					 &addr, true);
+		ret = __kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+					    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
 		TEST_ASSERT(ret && errno == EINVAL,
 			    "attempt to mix GICv3 REDIST and REDIST_REGION");
 	}
@@ -191,8 +187,8 @@ static void subtest_dist_rdist(struct vm_gic *v)
 	 * on first vcpu run instead.
 	 */
 	addr = rdist.size - rdist.alignment;
-	kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-			  dist.attr, &addr, true);
+	kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    dist.attr, &addr);
 }
 
 /* Test the new REDIST region API */
@@ -206,66 +202,66 @@ static void subtest_v3_redist_regions(struct vm_gic *v)
 	TEST_ASSERT(!ret, "Multiple redist regions advertised");
 
 	addr = REDIST_REGION_ATTR_ADDR(NR_VCPUS, 0x100000, 2, 0);
-	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	ret = __kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
 	TEST_ASSERT(ret && errno == EINVAL, "redist region attr value with flags != 0");
 
 	addr = REDIST_REGION_ATTR_ADDR(0, 0x100000, 0, 0);
-	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	ret = __kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
 	TEST_ASSERT(ret && errno == EINVAL, "redist region attr value with count== 0");
 
 	addr = REDIST_REGION_ATTR_ADDR(2, 0x200000, 0, 1);
-	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	ret = __kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
 	TEST_ASSERT(ret && errno == EINVAL,
 		    "attempt to register the first rdist region with index != 0");
 
 	addr = REDIST_REGION_ATTR_ADDR(2, 0x201000, 0, 1);
-	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	ret = __kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
 	TEST_ASSERT(ret && errno == EINVAL, "rdist region with misaligned address");
 
 	addr = REDIST_REGION_ATTR_ADDR(2, 0x200000, 0, 0);
-	kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-			  KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
 
 	addr = REDIST_REGION_ATTR_ADDR(2, 0x200000, 0, 1);
-	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	ret = __kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
 	TEST_ASSERT(ret && errno == EINVAL, "register an rdist region with already used index");
 
 	addr = REDIST_REGION_ATTR_ADDR(1, 0x210000, 0, 2);
-	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	ret = __kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
 	TEST_ASSERT(ret && errno == EINVAL,
 		    "register an rdist region overlapping with another one");
 
 	addr = REDIST_REGION_ATTR_ADDR(1, 0x240000, 0, 2);
-	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	ret = __kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
 	TEST_ASSERT(ret && errno == EINVAL, "register redist region with index not +1");
 
 	addr = REDIST_REGION_ATTR_ADDR(1, 0x240000, 0, 1);
-	kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-			  KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
 
 	addr = REDIST_REGION_ATTR_ADDR(1, max_phys_size, 0, 2);
-	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	ret = __kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
 	TEST_ASSERT(ret && errno == E2BIG,
 		    "register redist region with base address beyond IPA range");
 
 	/* The last redist is above the pa range. */
 	addr = REDIST_REGION_ATTR_ADDR(2, max_phys_size - 0x30000, 0, 2);
-	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	ret = __kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
 	TEST_ASSERT(ret && errno == E2BIG,
 		    "register redist region with top address beyond IPA range");
 
 	addr = 0x260000;
-	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
+	ret = __kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr);
 	TEST_ASSERT(ret && errno == EINVAL,
 		    "Mix KVM_VGIC_V3_ADDR_TYPE_REDIST and REDIST_REGION");
 
@@ -278,28 +274,28 @@ static void subtest_v3_redist_regions(struct vm_gic *v)
 
 	addr = REDIST_REGION_ATTR_ADDR(0, 0, 0, 0);
 	expected_addr = REDIST_REGION_ATTR_ADDR(2, 0x200000, 0, 0);
-	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, false);
+	ret = __kvm_device_attr_get(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
 	TEST_ASSERT(!ret && addr == expected_addr, "read characteristics of region #0");
 
 	addr = REDIST_REGION_ATTR_ADDR(0, 0, 0, 1);
 	expected_addr = REDIST_REGION_ATTR_ADDR(1, 0x240000, 0, 1);
-	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, false);
+	ret = __kvm_device_attr_get(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
 	TEST_ASSERT(!ret && addr == expected_addr, "read characteristics of region #1");
 
 	addr = REDIST_REGION_ATTR_ADDR(0, 0, 0, 2);
-	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, false);
+	ret = __kvm_device_attr_get(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
 	TEST_ASSERT(ret && errno == ENOENT, "read characteristics of non existing region");
 
 	addr = 0x260000;
-	kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-			  KVM_VGIC_V3_ADDR_TYPE_DIST, &addr, true);
+	kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V3_ADDR_TYPE_DIST, &addr);
 
 	addr = REDIST_REGION_ATTR_ADDR(1, 0x260000, 0, 2);
-	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	ret = __kvm_device_attr_set(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
 	TEST_ASSERT(ret && errno == EINVAL, "register redist region colliding with dist");
 }
 
@@ -351,8 +347,8 @@ static void test_v3_new_redist_regions(void)
 
 	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS);
 	subtest_v3_redist_regions(&v);
-	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
-			  KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
 
 	ret = run_vcpu(v.vm, 3);
 	TEST_ASSERT(ret == -ENXIO, "running without sufficient number of rdists");
@@ -364,8 +360,8 @@ static void test_v3_new_redist_regions(void)
 	subtest_v3_redist_regions(&v);
 
 	addr = REDIST_REGION_ATTR_ADDR(1, 0x280000, 0, 2);
-	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-			  KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
 
 	ret = run_vcpu(v.vm, 3);
 	TEST_ASSERT(ret == -EBUSY, "running without vgic explicit init");
@@ -377,17 +373,17 @@ static void test_v3_new_redist_regions(void)
 	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, NR_VCPUS);
 	subtest_v3_redist_regions(&v);
 
-	ret = _kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, dummy, true);
+	ret = __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, dummy);
 	TEST_ASSERT(ret && errno == EFAULT,
 		    "register a third region allowing to cover the 4 vcpus");
 
 	addr = REDIST_REGION_ATTR_ADDR(1, 0x280000, 0, 2);
-	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-			  KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
 
-	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
-			  KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
 
 	ret = run_vcpu(v.vm, 3);
 	TEST_ASSERT(!ret, "vcpu run");
@@ -408,56 +404,56 @@ static void test_v3_typer_accesses(void)
 
 	vm_vcpu_add_default(v.vm, 3, guest_code);
 
-	ret = access_v3_redist_reg(v.gic_fd, 1, GICR_TYPER, &val, false);
+	ret = v3_redist_reg_get(v.gic_fd, 1, GICR_TYPER, &val);
 	TEST_ASSERT(ret && errno == EINVAL, "attempting to read GICR_TYPER of non created vcpu");
 
 	vm_vcpu_add_default(v.vm, 1, guest_code);
 
-	ret = access_v3_redist_reg(v.gic_fd, 1, GICR_TYPER, &val, false);
+	ret = v3_redist_reg_get(v.gic_fd, 1, GICR_TYPER, &val);
 	TEST_ASSERT(ret && errno == EBUSY, "read GICR_TYPER before GIC initialized");
 
 	vm_vcpu_add_default(v.vm, 2, guest_code);
 
-	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
-			  KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
 
 	for (i = 0; i < NR_VCPUS ; i++) {
-		ret = access_v3_redist_reg(v.gic_fd, 0, GICR_TYPER, &val, false);
+		ret = v3_redist_reg_get(v.gic_fd, 0, GICR_TYPER, &val);
 		TEST_ASSERT(!ret && !val, "read GICR_TYPER before rdist region setting");
 	}
 
 	addr = REDIST_REGION_ATTR_ADDR(2, 0x200000, 0, 0);
-	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-			  KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
 
 	/* The 2 first rdists should be put there (vcpu 0 and 3) */
-	ret = access_v3_redist_reg(v.gic_fd, 0, GICR_TYPER, &val, false);
+	ret = v3_redist_reg_get(v.gic_fd, 0, GICR_TYPER, &val);
 	TEST_ASSERT(!ret && !val, "read typer of rdist #0");
 
-	ret = access_v3_redist_reg(v.gic_fd, 3, GICR_TYPER, &val, false);
+	ret = v3_redist_reg_get(v.gic_fd, 3, GICR_TYPER, &val);
 	TEST_ASSERT(!ret && val == 0x310, "read typer of rdist #1");
 
 	addr = REDIST_REGION_ATTR_ADDR(10, 0x100000, 0, 1);
-	ret = _kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	ret = __kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
 	TEST_ASSERT(ret && errno == EINVAL, "collision with previous rdist region");
 
-	ret = access_v3_redist_reg(v.gic_fd, 1, GICR_TYPER, &val, false);
+	ret = v3_redist_reg_get(v.gic_fd, 1, GICR_TYPER, &val);
 	TEST_ASSERT(!ret && val == 0x100,
 		    "no redist region attached to vcpu #1 yet, last cannot be returned");
 
-	ret = access_v3_redist_reg(v.gic_fd, 2, GICR_TYPER, &val, false);
+	ret = v3_redist_reg_get(v.gic_fd, 2, GICR_TYPER, &val);
 	TEST_ASSERT(!ret && val == 0x200,
 		    "no redist region attached to vcpu #2, last cannot be returned");
 
 	addr = REDIST_REGION_ATTR_ADDR(10, 0x20000, 0, 1);
-	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-			  KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
 
-	ret = access_v3_redist_reg(v.gic_fd, 1, GICR_TYPER, &val, false);
+	ret = v3_redist_reg_get(v.gic_fd, 1, GICR_TYPER, &val);
 	TEST_ASSERT(!ret && val == 0x100, "read typer of rdist #1");
 
-	ret = access_v3_redist_reg(v.gic_fd, 2, GICR_TYPER, &val, false);
+	ret = v3_redist_reg_get(v.gic_fd, 2, GICR_TYPER, &val);
 	TEST_ASSERT(!ret && val == 0x210,
 		    "read typer of rdist #1, last properly returned");
 
@@ -486,37 +482,37 @@ static void test_v3_last_bit_redist_regions(void)
 
 	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3);
 
-	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
-			  KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
 
 	addr = REDIST_REGION_ATTR_ADDR(2, 0x100000, 0, 0);
-	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-			  KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
 
 	addr = REDIST_REGION_ATTR_ADDR(2, 0x240000, 0, 1);
-	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-			  KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
 
 	addr = REDIST_REGION_ATTR_ADDR(2, 0x200000, 0, 2);
-	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-			  KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr);
 
-	ret = access_v3_redist_reg(v.gic_fd, 0, GICR_TYPER, &val, false);
+	ret = v3_redist_reg_get(v.gic_fd, 0, GICR_TYPER, &val);
 	TEST_ASSERT(!ret && val == 0x000, "read typer of rdist #0");
 
-	ret = access_v3_redist_reg(v.gic_fd, 1, GICR_TYPER, &val, false);
+	ret = v3_redist_reg_get(v.gic_fd, 1, GICR_TYPER, &val);
 	TEST_ASSERT(!ret && val == 0x100, "read typer of rdist #1");
 
-	ret = access_v3_redist_reg(v.gic_fd, 2, GICR_TYPER, &val, false);
+	ret = v3_redist_reg_get(v.gic_fd, 2, GICR_TYPER, &val);
 	TEST_ASSERT(!ret && val == 0x200, "read typer of rdist #2");
 
-	ret = access_v3_redist_reg(v.gic_fd, 3, GICR_TYPER, &val, false);
+	ret = v3_redist_reg_get(v.gic_fd, 3, GICR_TYPER, &val);
 	TEST_ASSERT(!ret && val == 0x310, "read typer of rdist #3");
 
-	ret = access_v3_redist_reg(v.gic_fd, 5, GICR_TYPER, &val, false);
+	ret = v3_redist_reg_get(v.gic_fd, 5, GICR_TYPER, &val);
 	TEST_ASSERT(!ret && val == 0x500, "read typer of rdist #5");
 
-	ret = access_v3_redist_reg(v.gic_fd, 4, GICR_TYPER, &val, false);
+	ret = v3_redist_reg_get(v.gic_fd, 4, GICR_TYPER, &val);
 	TEST_ASSERT(!ret && val == 0x410, "read typer of rdist #4");
 
 	vm_gic_destroy(&v);
@@ -535,26 +531,26 @@ static void test_v3_last_bit_single_rdist(void)
 
 	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3);
 
-	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
-			  KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
 
 	addr = 0x10000;
-	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-			  KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr);
 
-	ret = access_v3_redist_reg(v.gic_fd, 0, GICR_TYPER, &val, false);
+	ret = v3_redist_reg_get(v.gic_fd, 0, GICR_TYPER, &val);
 	TEST_ASSERT(!ret && val == 0x000, "read typer of rdist #0");
 
-	ret = access_v3_redist_reg(v.gic_fd, 3, GICR_TYPER, &val, false);
+	ret = v3_redist_reg_get(v.gic_fd, 3, GICR_TYPER, &val);
 	TEST_ASSERT(!ret && val == 0x300, "read typer of rdist #1");
 
-	ret = access_v3_redist_reg(v.gic_fd, 5, GICR_TYPER, &val, false);
+	ret = v3_redist_reg_get(v.gic_fd, 5, GICR_TYPER, &val);
 	TEST_ASSERT(!ret && val == 0x500, "read typer of rdist #2");
 
-	ret = access_v3_redist_reg(v.gic_fd, 1, GICR_TYPER, &val, false);
+	ret = v3_redist_reg_get(v.gic_fd, 1, GICR_TYPER, &val);
 	TEST_ASSERT(!ret && val == 0x100, "read typer of rdist #3");
 
-	ret = access_v3_redist_reg(v.gic_fd, 2, GICR_TYPER, &val, false);
+	ret = v3_redist_reg_get(v.gic_fd, 2, GICR_TYPER, &val);
 	TEST_ASSERT(!ret && val == 0x210, "read typer of rdist #3");
 
 	vm_gic_destroy(&v);
@@ -571,19 +567,19 @@ static void test_v3_redist_ipa_range_check_at_vcpu_run(void)
 
 	/* Set space for 3 redists, we have 1 vcpu, so this succeeds. */
 	addr = max_phys_size - (3 * 2 * 0x10000);
-	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr);
 
 	addr = 0x00000;
-	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-			KVM_VGIC_V3_ADDR_TYPE_DIST, &addr, true);
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V3_ADDR_TYPE_DIST, &addr);
 
 	/* Add the rest of the VCPUs */
 	for (i = 1; i < NR_VCPUS; ++i)
 		vm_vcpu_add_default(v.vm, i, guest_code);
 
-	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
-			  KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
 
 	/* Attempt to run a vcpu without enough redist space. */
 	ret = run_vcpu(v.vm, 2);
@@ -603,31 +599,31 @@ static void test_v3_its_region(void)
 	its_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_ITS);
 
 	addr = 0x401000;
-	ret = _kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
+	ret = __kvm_device_attr_set(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_ITS_ADDR_TYPE, &addr);
 	TEST_ASSERT(ret && errno == EINVAL,
 		"ITS region with misaligned address");
 
 	addr = max_phys_size;
-	ret = _kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
+	ret = __kvm_device_attr_set(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_ITS_ADDR_TYPE, &addr);
 	TEST_ASSERT(ret && errno == E2BIG,
 		"register ITS region with base address beyond IPA range");
 
 	addr = max_phys_size - 0x10000;
-	ret = _kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
+	ret = __kvm_device_attr_set(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_ITS_ADDR_TYPE, &addr);
 	TEST_ASSERT(ret && errno == E2BIG,
 		"Half of ITS region is beyond IPA range");
 
 	/* This one succeeds setting the ITS base */
 	addr = 0x400000;
-	kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
+	kvm_device_attr_set(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_ITS_ADDR_TYPE, &addr);
 
 	addr = 0x300000;
-	ret = _kvm_device_access(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-			  KVM_VGIC_ITS_ADDR_TYPE, &addr, true);
+	ret = __kvm_device_attr_set(its_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+				    KVM_VGIC_ITS_ADDR_TYPE, &addr);
 	TEST_ASSERT(ret && errno == EEXIST, "ITS base set again");
 
 	close(its_fd);
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index f9aeac540699..c508a860984f 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -460,6 +460,79 @@ static inline int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid)
 	return fd;
 }
 
+int __kvm_has_device_attr(int dev_fd, uint32_t group, uint64_t attr);
+
+static inline void kvm_has_device_attr(int dev_fd, uint32_t group, uint64_t attr)
+{
+	int ret = __kvm_has_device_attr(dev_fd, group, attr);
+
+	TEST_ASSERT(!ret, "KVM_HAS_DEVICE_ATTR failed, rc: %i errno: %i", ret, errno);
+}
+
+
+int __kvm_device_attr_access(int dev_fd, uint32_t group, uint64_t attr,
+			     void *val, unsigned long cmd);
+
+static inline int __kvm_device_attr_get(int dev_fd, uint32_t group,
+					uint64_t attr, void *val)
+{
+	return __kvm_device_attr_access(dev_fd, group, attr, val,
+					KVM_GET_DEVICE_ATTR);
+}
+
+static inline void kvm_device_attr_get(int dev_fd, uint32_t group,
+				       uint64_t attr, void *val)
+{
+	int ret = __kvm_device_attr_get(dev_fd, group, attr, val);
+
+	TEST_ASSERT(!ret, KVM_IOCTL_ERROR(KVM_GET_DEVICE_ATTR, ret));
+}
+
+static inline int __kvm_device_attr_set(int dev_fd, uint32_t group,
+					uint64_t attr, void *val)
+{
+	return __kvm_device_attr_access(dev_fd, group, attr, val,
+					KVM_SET_DEVICE_ATTR);
+}
+
+static inline void kvm_device_attr_set(int dev_fd, uint32_t group,
+				       uint64_t attr, void *val)
+{
+	int ret = __kvm_device_attr_set(dev_fd, group, attr, val);
+
+	TEST_ASSERT(!ret, KVM_IOCTL_ERROR(KVM_SET_DEVICE_ATTR, ret));
+}
+
+int __vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
+			   uint64_t attr);
+
+static inline void vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid,
+					uint32_t group, uint64_t attr)
+{
+	int ret = __vcpu_has_device_attr(vm, vcpuid, group, attr);
+
+	TEST_ASSERT(!ret, KVM_IOCTL_ERROR(KVM_HAS_DEVICE_ATTR, ret));
+}
+
+int __vcpu_device_attr_get(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
+			   uint64_t attr, void *val);
+void vcpu_device_attr_get(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
+			  uint64_t attr, void *val);
+int __vcpu_device_attr_set(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
+			   uint64_t attr, void *val);
+void vcpu_device_attr_set(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
+			  uint64_t attr, void *val);
+int __kvm_test_create_device(struct kvm_vm *vm, uint64_t type);
+int __kvm_create_device(struct kvm_vm *vm, uint64_t type);
+
+static inline int kvm_create_device(struct kvm_vm *vm, uint64_t type)
+{
+	int fd = __kvm_create_device(vm, type);
+
+	TEST_ASSERT(fd >= 0, KVM_IOCTL_ERROR(KVM_CREATE_DEVICE, fd));
+	return fd;
+}
+
 void *vcpu_map_dirty_ring(struct kvm_vm *vm, uint32_t vcpuid);
 
 /*
@@ -482,41 +555,9 @@ void *vcpu_map_dirty_ring(struct kvm_vm *vm, uint32_t vcpuid);
  */
 void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num, ...);
 
-int __kvm_has_device_attr(int dev_fd, uint32_t group, uint64_t attr);
-
-static inline void kvm_has_device_attr(int dev_fd, uint32_t group, uint64_t attr)
-{
-	int ret = __kvm_has_device_attr(dev_fd, group, attr);
-
-	TEST_ASSERT(!ret, "KVM_HAS_DEVICE_ATTR failed, rc: %i errno: %i", ret, errno);
-}
-
-int __kvm_test_create_device(struct kvm_vm *vm, uint64_t type);
-int __kvm_create_device(struct kvm_vm *vm, uint64_t type);
-int kvm_create_device(struct kvm_vm *vm, uint64_t type);
-int _kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
-		       void *val, bool write);
-int kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
-		      void *val, bool write);
 void kvm_irq_line(struct kvm_vm *vm, uint32_t irq, int level);
 int _kvm_irq_line(struct kvm_vm *vm, uint32_t irq, int level);
 
-int __vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
-			  uint64_t attr);
-
-static inline void vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid,
-					uint32_t group, uint64_t attr)
-{
-	int ret = __vcpu_has_device_attr(vm, vcpuid, group, attr);
-
-	TEST_ASSERT(!ret, KVM_IOCTL_ERROR(KVM_HAS_DEVICE_ATTR, ret));
-}
-
-int _vcpu_access_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
-			  uint64_t attr, void *val, bool write);
-int vcpu_access_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
-			 uint64_t attr, void *val, bool write);
-
 #define KVM_MAX_IRQ_ROUTES		4096
 
 struct kvm_irq_routing *kvm_gsi_routing_create(void);
diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
index 7925b4c5dad0..61da345c48ac 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/vgic.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
@@ -55,27 +55,26 @@ int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs,
 	if (gic_fd < 0)
 		return gic_fd;
 
-	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
-			0, &nr_irqs, true);
+	kvm_device_attr_get(gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS, 0, &nr_irqs);
 
-	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
-			KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
+	kvm_device_attr_set(gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
 
-	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-			KVM_VGIC_V3_ADDR_TYPE_DIST, &gicd_base_gpa, true);
+	kvm_device_attr_set(gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V3_ADDR_TYPE_DIST, &gicd_base_gpa);
 	nr_gic_pages = vm_calc_num_guest_pages(vm->mode, KVM_VGIC_V3_DIST_SIZE);
 	virt_map(vm, gicd_base_gpa, gicd_base_gpa,  nr_gic_pages);
 
 	/* Redistributor setup */
 	redist_attr = REDIST_REGION_ATTR_ADDR(nr_vcpus, gicr_base_gpa, 0, 0);
-	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
-			KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &redist_attr, true);
+	kvm_device_attr_set(gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			    KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &redist_attr);
 	nr_gic_pages = vm_calc_num_guest_pages(vm->mode,
 						KVM_VGIC_V3_REDIST_SIZE * nr_vcpus);
 	virt_map(vm, gicr_base_gpa, gicr_base_gpa,  nr_gic_pages);
 
-	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
-				KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
+	kvm_device_attr_set(gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
 
 	return gic_fd;
 }
@@ -88,14 +87,14 @@ int _kvm_irq_set_level_info(int gic_fd, uint32_t intid, int level)
 	uint64_t val;
 	int ret;
 
-	ret = _kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO,
-				 attr, &val, false);
+	ret = __kvm_device_attr_get(gic_fd, KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO,
+				    attr, &val);
 	if (ret != 0)
 		return ret;
 
 	val |= 1U << index;
-	ret = _kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO,
-				 attr, &val, true);
+	ret = __kvm_device_attr_set(gic_fd, KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO,
+				    attr, &val);
 	return ret;
 }
 
@@ -155,9 +154,9 @@ static void vgic_poke_irq(int gic_fd, uint32_t intid,
 	 * intid will just make the read/writes point to above the intended
 	 * register space (i.e., ICPENDR after ISPENDR).
 	 */
-	kvm_device_access(gic_fd, group, attr, &val, false);
+	kvm_device_attr_get(gic_fd, group, attr, &val);
 	val |= 1ULL << index;
-	kvm_device_access(gic_fd, group, attr, &val, true);
+	kvm_device_attr_set(gic_fd, group, attr, &val);
 }
 
 void kvm_irq_write_ispendr(int gic_fd, uint32_t intid, uint32_t vcpu)
diff --git a/tools/testing/selftests/kvm/lib/guest_modes.c b/tools/testing/selftests/kvm/lib/guest_modes.c
index 9ab27b4169bf..0be56c63aed6 100644
--- a/tools/testing/selftests/kvm/lib/guest_modes.c
+++ b/tools/testing/selftests/kvm/lib/guest_modes.c
@@ -66,8 +66,8 @@ void guest_modes_append_default(void)
 
 		kvm_fd = open_kvm_dev_path_or_exit();
 		vm_fd = __kvm_ioctl(kvm_fd, KVM_CREATE_VM, 0);
-		kvm_device_access(vm_fd, KVM_S390_VM_CPU_MODEL,
-				  KVM_S390_VM_CPU_PROCESSOR, &info, false);
+		kvm_device_attr_get(vm_fd, KVM_S390_VM_CPU_MODEL,
+				    KVM_S390_VM_CPU_PROCESSOR, &info);
 		close(vm_fd);
 		close(kvm_fd);
 		/* Starting with z13 we have 47bits of physical address */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index a7bc6b623871..c654c81f7d9d 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1645,16 +1645,8 @@ int __kvm_create_device(struct kvm_vm *vm, uint64_t type)
 	return err ? : create_dev.fd;
 }
 
-int kvm_create_device(struct kvm_vm *vm, uint64_t type)
-{
-	int fd = __kvm_create_device(vm, type);
-
-	TEST_ASSERT(fd >= 0, "KVM_CREATE_DEVICE IOCTL failed, rc: %i errno: %i", fd, errno);
-	return fd;
-}
-
-int _kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
-		      void *val, bool write)
+int __kvm_device_attr_access(int dev_fd, uint32_t group, uint64_t attr,
+			     void *val, unsigned long cmd)
 {
 	struct kvm_device_attr kvmattr = {
 		.group = group,
@@ -1662,20 +1654,32 @@ int _kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
 		.flags = 0,
 		.addr = (uintptr_t)val,
 	};
-	int ret;
 
-	ret = ioctl(dev_fd, write ? KVM_SET_DEVICE_ATTR : KVM_GET_DEVICE_ATTR,
-		    &kvmattr);
-	return ret;
+	return __kvm_ioctl(dev_fd, cmd, &kvmattr);
 }
 
-int kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
-		      void *val, bool write)
+int __vcpu_device_attr_get(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
+			   uint64_t attr, void *val)
 {
-	int ret = _kvm_device_access(dev_fd, group, attr, val, write);
+	return __kvm_device_attr_get(vcpu_get(vm, vcpuid)->fd, group, attr, val);
+}
+
+void vcpu_device_attr_get(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
+			  uint64_t attr, void *val)
+{
+	kvm_device_attr_get(vcpu_get(vm, vcpuid)->fd, group, attr, val);
+}
 
-	TEST_ASSERT(!ret, "KVM_SET|GET_DEVICE_ATTR IOCTL failed, rc: %i errno: %i", ret, errno);
-	return ret;
+int __vcpu_device_attr_set(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
+			   uint64_t attr, void *val)
+{
+	return __kvm_device_attr_set(vcpu_get(vm, vcpuid)->fd, group, attr, val);
+}
+
+void vcpu_device_attr_set(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
+			  uint64_t attr, void *val)
+{
+	kvm_device_attr_set(vcpu_get(vm, vcpuid)->fd, group, attr, val);
 }
 
 int __vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
@@ -1686,23 +1690,6 @@ int __vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
 	return __kvm_has_device_attr(vcpu->fd, group, attr);
 }
 
-int _vcpu_access_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
-			     uint64_t attr, void *val, bool write)
-{
-	struct vcpu *vcpu = vcpu_get(vm, vcpuid);
-
-	return _kvm_device_access(vcpu->fd, group, attr, val, write);
-}
-
-int vcpu_access_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
-			    uint64_t attr, void *val, bool write)
-{
-	int ret = _vcpu_access_device_attr(vm, vcpuid, group, attr, val, write);
-
-	TEST_ASSERT(!ret, "KVM_SET|GET_DEVICE_ATTR IOCTL failed, rc: %i errno: %i", ret, errno);
-	return ret;
-}
-
 /*
  * IRQ related functions.
  */
diff --git a/tools/testing/selftests/kvm/system_counter_offset_test.c b/tools/testing/selftests/kvm/system_counter_offset_test.c
index 2b10c53abf4f..5dd9d28efb97 100644
--- a/tools/testing/selftests/kvm/system_counter_offset_test.c
+++ b/tools/testing/selftests/kvm/system_counter_offset_test.c
@@ -39,8 +39,8 @@ static void check_preconditions(struct kvm_vm *vm)
 
 static void setup_system_counter(struct kvm_vm *vm, struct test_case *test)
 {
-	vcpu_access_device_attr(vm, VCPU_ID, KVM_VCPU_TSC_CTRL,
-				KVM_VCPU_TSC_OFFSET, &test->tsc_offset, true);
+	vcpu_device_attr_set(vm, VCPU_ID, KVM_VCPU_TSC_CTRL,
+			     KVM_VCPU_TSC_OFFSET, &test->tsc_offset);
 }
 
 static uint64_t guest_read_system_counter(struct test_case *test)
-- 
2.36.0.464.gb9c8b46e94-goog

