Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBE96C60B7
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 08:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbjCWH2I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 03:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbjCWH1x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 03:27:53 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8AA12E0F2;
        Thu, 23 Mar 2023 00:27:47 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id om3-20020a17090b3a8300b0023efab0e3bfso1097405pjb.3;
        Thu, 23 Mar 2023 00:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679556467;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/exFJh7TDyJUezqCCRl00XWiJYsf32A2gpUIkspOS58=;
        b=Kz/YamGbw4zCdA969iHVRCjRubxnaiiRcL5s4LwndXlU1IIjhkhWD07DQc1HgW/yH5
         xsBY24Fcs9J3AnGIH/waxtl6ZWV8PRZI4Risxo46vzgFckkx2dE3bRAvzrbIRle5BOWG
         GYxpLSIzl1hz+AeK7nvrrTaXyYEkR1FvYTCveyklan/dlZOoOrg3r+O6DLZ4tIe43Z8j
         Kszcip4HxZKM0WaEjvv0s+arAivMenSKfZPAxWFuXpSfvWDVQtuQGHC6PnfEzKVNMiCn
         JYVy9lGEIIYbkitkGGYPtlkiYxaVrEw6JOkbXADt3my1lCG00ciaK9WMmmuPDHP2NMqU
         3d1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679556467;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/exFJh7TDyJUezqCCRl00XWiJYsf32A2gpUIkspOS58=;
        b=nACbVZYxHGCc+X0Vz2r9gc7osgZ6tPaoZxUwtp+9CTkmpoHe63OjKJSTKbMX02m5zz
         Pqf/JnEVZFUyrT8cUG1AvMDNmr7tktFiVs+sC6hVN2Ycv+cq2WDE0e+DdCTRJ6s7UWPT
         /RIyWpqfDQliODcfzJR+aLpy+I1wkVAjt+KiddU1HQu1EaiSkfzEJI3KFZZKF1wtGVbg
         4quoWj6CTU7qKOY9EsOKUl6aNYAKPypJLi961q0pW59FA1Vtd05v98KnPJ0FTrGZV2Fr
         ORSD8iMNbwzfuxDldseHC5mL4V/ezp1ibnhTthmiNLk/9m5x79yW86WziA2QU3YjvCpD
         pNoQ==
X-Gm-Message-State: AO0yUKWlS7S75O3rwZXJ/8c1IFdTVfWaLlAex/FpBJr0o2up9pfKQpNa
        1zdhUQdELhQp2H8vOfnzvwc=
X-Google-Smtp-Source: AK7set9SOgny1wyRdp5pTYJFSCj9pgt1QpmNB2Ddh7cULC9JcESMmDAgIcVUVWx4wMkNl2BUYHoWAQ==
X-Received: by 2002:a17:902:fa87:b0:1a1:b748:f360 with SMTP id lc7-20020a170902fa8700b001a1b748f360mr5451363plb.47.1679556467160;
        Thu, 23 Mar 2023 00:27:47 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c24d00b0017a032d7ae4sm11645447plg.104.2023.03.23.00.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 00:27:46 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jinrong Liang <cloudliang@tencent.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 5/7] KVM: selftests: Test Intel supported fixed counters bit mask
Date:   Thu, 23 Mar 2023 15:27:12 +0800
Message-Id: <20230323072714.82289-6-likexu@tencent.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230323072714.82289-1-likexu@tencent.com>
References: <20230323072714.82289-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Add a test to check that fixed counters enabled via guest
CPUID.0xA.ECX (instead of EDX[04:00]) work as normal as usual.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 .../selftests/kvm/x86_64/pmu_cpuid_test.c     | 63 +++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c b/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c
index c934144be287..79f2e144c6c6 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c
@@ -199,6 +199,27 @@ static void intel_guest_run_arch_event(uint8_t version, uint8_t max_gp_num,
 	GUEST_DONE();
 }
 
+static void intel_guest_run_fixed_counters(uint64_t supported_bitmask,
+					   uint8_t max_fixed_num)
+{
+	unsigned int i;
+
+	for (i = 0; i < max_fixed_num; i++) {
+		if (!(supported_bitmask & BIT_ULL(i)))
+			continue;
+
+		wrmsr(MSR_CORE_PERF_FIXED_CTR0 + i, 0);
+		wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, BIT_ULL(4 * i));
+		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, BIT_ULL(INTEL_PMC_IDX_FIXED + i));
+		__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
+		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
+
+		GUEST_SYNC(!!_rdpmc(RDPMC_FIXED_BASE | i));
+	}
+
+	GUEST_DONE();
+}
+
 static void test_arch_events_setup(struct kvm_vcpu *vcpu, uint8_t evt_vector,
 				   uint8_t unavl_mask, uint8_t idx)
 {
@@ -279,6 +300,47 @@ static uint64_t test_oob_fixed_counter_setup(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
+static void test_fixed_counters_setup(struct kvm_vcpu *vcpu, uint8_t edx_fix_num,
+				      uint32_t fixed_bitmask)
+{
+	struct kvm_cpuid_entry2 *entry;
+	uint8_t max_fixed_num = kvm_fixed_ctrs_num();
+	uint64_t supported_bitmask = 0;
+	unsigned int i;
+
+	entry = vcpu_get_cpuid_entry(vcpu, 0xa);
+	entry->ecx = fixed_bitmask;
+	entry->edx = (entry->edx & ~FIXED_CTR_NUM_MASK) | edx_fix_num;
+	vcpu_set_cpuid(vcpu);
+
+	for (i = 0; i < max_fixed_num; i++) {
+		if (entry->ecx & BIT_ULL(i) ||
+		    ((entry->edx & FIXED_CTR_NUM_MASK) > i))
+			supported_bitmask |= BIT_ULL(i);
+	}
+
+	vcpu_args_set(vcpu, 2, supported_bitmask, max_fixed_num);
+	vm_install_exception_handler(vcpu->vm, GP_VECTOR, guest_gp_handler);
+}
+
+static void intel_test_fixed_counters(void)
+{
+	const char *msg = "At least one fixed counter is not working as expected";
+	uint8_t edx, num = kvm_fixed_ctrs_num();
+	struct kvm_vcpu *vcpu;
+	uint32_t ecx;
+
+	for (edx = 0; edx <= num; edx++) {
+		/* KVM doesn't emulate more fixed counters than it can support. */
+		for (ecx = 0; ecx <= (BIT_ULL(num) - 1); ecx++) {
+			vcpu = new_vcpu(intel_guest_run_fixed_counters);
+			test_fixed_counters_setup(vcpu, edx, ecx);
+			run_vcpu(vcpu, msg, first_uc_arg_equals, (void *)true);
+			free_vcpu(vcpu);
+		}
+	}
+}
+
 static void intel_check_arch_event_is_unavl(uint8_t idx)
 {
 	const char *msg = "Unavailable arch event is counting.";
@@ -383,6 +445,7 @@ static void intel_test_pmu_cpuid(void)
 {
 	intel_test_arch_events();
 	intel_test_counters_num();
+	intel_test_fixed_counters();
 }
 
 int main(int argc, char *argv[])
-- 
2.40.0

