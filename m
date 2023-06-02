Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACA2720C5F
	for <lists+kvm@lfdr.de>; Sat,  3 Jun 2023 01:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236920AbjFBXdN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 19:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236868AbjFBXdJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 19:33:09 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C70E42
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 16:33:08 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-5341081a962so2545754a12.2
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 16:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685748788; x=1688340788;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=j6nYf/jOBntGS2igA5vSyIxcer0Y2dnZYEhcRt0bNGM=;
        b=Wi3H0k9BpFJWJAoAjhZGH+/ORYMPc9rbgUFp0V7StYibnfR5Xj/2eL6uRo+vy2ORjC
         t7IhWOLboZOtaFGAZUE5ovIvkiLsDV+67SAoJ01MJRK09U02fJoLAa4AUpOGsfC1kS7P
         +hjP1kmcc8hDU9rMT9LiNwBTg5BYbmCeWKvHScZv9HRM/kblDg9yNpxucaTAI3D5S7nI
         jQFbapqcnP3k3m32lzqRcCZH4s+IoewCx1fJp3P83YZ2/GpgKpGBLg6fcwxRiNZHIxPk
         9nAJ5vbHtv8f6sqcuBQySNHOow5IdMVwxGuFB065jqUKW3dyVjnL9DouUtA0ENGMulPM
         nIDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685748788; x=1688340788;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j6nYf/jOBntGS2igA5vSyIxcer0Y2dnZYEhcRt0bNGM=;
        b=YqPuFCDhItDZxy0q83PdUcbPNCPjDnOJjN+dihlzBu90CHQJybPv0KmIYc8egD4Ymm
         1yhKcRaFzDQawk41GNMXdq8rl4DCIo+sQaaI3kZ2aBQSXBimuuv9qGu++21c9EOGxku/
         Kxpkqc/dQHLBul+5HjbJjrlxXTgjSlrrIMuwsbwT5eheDXR5os00jmV3VlOYij3OdCtN
         iYsuMz+kiyf6+vIfYr/J+drrywcPyjpF4wERmVv9/Tw9twvT8dg0fYU7mzK5pUCcJQV/
         p4CkNhdMwnycpNWzUWLZLSksHCfRgeXbS5feZ+YFKIyb8MXMbCyGahg0yEEiCsgTni0b
         arJA==
X-Gm-Message-State: AC+VfDx6/MpHYu9UVd0LExuiHMVEGF8Y/p7Ovf9rEJZaOuG8RKTSGAWz
        NqLakcXq4WKI0ztNOG6Ajja34mp1Vos=
X-Google-Smtp-Source: ACHHUZ5RQW9bPamlFEzYIenvVcUlgxBxW5xO/KEOYWb6HOpyK20P4kwc3nv+mQDuMb0Bq7zPa45xizLoZzA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:4284:0:b0:542:96b5:b5e4 with SMTP id
 j4-20020a654284000000b0054296b5b5e4mr648446pgp.11.1685748787993; Fri, 02 Jun
 2023 16:33:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  2 Jun 2023 16:32:50 -0700
In-Reply-To: <20230602233250.1014316-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230602233250.1014316-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.rc2.161.g9c6817b8e7-goog
Message-ID: <20230602233250.1014316-4-seanjc@google.com>
Subject: [PATCH v3 3/3] KVM: selftests: Add test for race in kvm_recalculate_apic_map()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>
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

From: Michal Luczaj <mhal@rbox.co>

Keep switching between LAPIC_MODE_X2APIC and LAPIC_MODE_DISABLED during
APIC map construction to hunt for TOCTOU bugs in KVM.  KVM's optimized map
recalc makes multiple passes over the list of vCPUs, and the calculations
ignore vCPU's whose APIC is hardware-disabled, i.e. there's a window where
toggling LAPIC_MODE_DISABLED is quite interesting.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../kvm/x86_64/recalc_apic_map_test.c         | 74 +++++++++++++++++++
 2 files changed, 75 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/recalc_apic_map_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 7a5ff646e7e7..4761b768b773 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -116,6 +116,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/sev_migrate_tests
 TEST_GEN_PROGS_x86_64 += x86_64/amx_test
 TEST_GEN_PROGS_x86_64 += x86_64/max_vcpuid_cap_test
 TEST_GEN_PROGS_x86_64 += x86_64/triple_fault_event_test
+TEST_GEN_PROGS_x86_64 += x86_64/recalc_apic_map_test
 TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
 TEST_GEN_PROGS_x86_64 += demand_paging_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
diff --git a/tools/testing/selftests/kvm/x86_64/recalc_apic_map_test.c b/tools/testing/selftests/kvm/x86_64/recalc_apic_map_test.c
new file mode 100644
index 000000000000..4c416ebe7d66
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/recalc_apic_map_test.c
@@ -0,0 +1,74 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Test edge cases and race conditions in kvm_recalculate_apic_map().
+ */
+
+#include <sys/ioctl.h>
+#include <pthread.h>
+#include <time.h>
+
+#include "processor.h"
+#include "test_util.h"
+#include "kvm_util.h"
+#include "apic.h"
+
+#define TIMEOUT		5	/* seconds */
+
+#define LAPIC_DISABLED	0
+#define LAPIC_X2APIC	(MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE)
+#define MAX_XAPIC_ID	0xff
+
+static void *race(void *arg)
+{
+	struct kvm_lapic_state lapic = {};
+	struct kvm_vcpu *vcpu = arg;
+
+	while (1) {
+		/* Trigger kvm_recalculate_apic_map(). */
+		vcpu_ioctl(vcpu, KVM_SET_LAPIC, &lapic);
+		pthread_testcancel();
+	}
+
+	return NULL;
+}
+
+int main(void)
+{
+	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
+	struct kvm_vcpu *vcpuN;
+	struct kvm_vm *vm;
+	pthread_t thread;
+	time_t t;
+	int i;
+
+	kvm_static_assert(KVM_MAX_VCPUS > MAX_XAPIC_ID);
+
+	/*
+	 * Create the max number of vCPUs supported by selftests so that KVM
+	 * has decent amount of work to do when recalculating the map, i.e. to
+	 * make the problematic window large enough to hit.
+	 */
+	vm = vm_create_with_vcpus(KVM_MAX_VCPUS, NULL, vcpus);
+
+	/*
+	 * Enable x2APIC on all vCPUs so that KVM doesn't bail from the recalc
+	 * due to vCPUs having aliased xAPIC IDs (truncated to 8 bits).
+	 */
+	for (i = 0; i < KVM_MAX_VCPUS; i++)
+		vcpu_set_msr(vcpus[i], MSR_IA32_APICBASE, LAPIC_X2APIC);
+
+	ASSERT_EQ(pthread_create(&thread, NULL, race, vcpus[0]), 0);
+
+	vcpuN = vcpus[KVM_MAX_VCPUS - 1];
+	for (t = time(NULL) + TIMEOUT; time(NULL) < t;) {
+		vcpu_set_msr(vcpuN, MSR_IA32_APICBASE, LAPIC_X2APIC);
+		vcpu_set_msr(vcpuN, MSR_IA32_APICBASE, LAPIC_DISABLED);
+	}
+
+	ASSERT_EQ(pthread_cancel(thread), 0);
+	ASSERT_EQ(pthread_join(thread, NULL), 0);
+
+	kvm_vm_free(vm);
+
+	return 0;
+}
-- 
2.41.0.rc2.161.g9c6817b8e7-goog

