Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 718387130A7
	for <lists+kvm@lfdr.de>; Sat, 27 May 2023 01:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237543AbjEZXvI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 19:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237412AbjEZXu7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 19:50:59 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9DF01A8
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 16:50:56 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-64d4ea109faso1647963b3a.1
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 16:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685145056; x=1687737056;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Bk1UDmvPC4i4QcCcByGound/sEkJg+oDBKjGWlXb8JU=;
        b=b/S5rioSyiILJQs6UKnM3duZoCNlAbzAiw9wfNE+A0VSgXSpbWDc9bAXYZ0cLdL+DZ
         2uEnOSwSL/9N6VTbCO+GDRzecVuGUcIp1MW7e/WVy3U+6EXro8ItKlYOl2uhHuvWrsOg
         p6JSZ3CtSyfneC1g5UW5/tU7cDnIK/CmNCczY+MlhjqwAH6wBmtxSHcNTRF6h6B+41uc
         vMBYdeJ0HzcoKczzVjIvuHERnJDS2dopnEyzqp2e/YZ8edaTDKqz8JbytR4XMFerZFBE
         FJlWWkSzYrPKODDIxJfZfd0LKpiUyKP6bhpDYzO3DCZ0YLH9zhVCqo48cSABG2v9SAmc
         ChFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685145056; x=1687737056;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Bk1UDmvPC4i4QcCcByGound/sEkJg+oDBKjGWlXb8JU=;
        b=eb+AyGKhcU4qRrXj0cweqizSOi9LKGGjT0ggg+iQragV3A6Iy5WqvNsRHgooXTUcXX
         6aU0Yma7F9uqKwmKM8K3jDZyZaLrSbcsU+7BI4ar0xolJMh372enyi9nKdgJkW4/wi5n
         H9YflkE9RHQvclliADf2eFgPJYbzm5/eN1SampcPqiAx0vl65IpQ+5e6GbFnq1yBdJpn
         DgLDZ76H6Y8UKGPaD7l/edzFzHG1ul2+5moDBvyGeGSEtdkcsmH9D+CZAG6b0SyFGrsS
         GBaHUIpIgBT6FvK39tIQaSdsjXspDYBJxcwwWdkMgj7rbDiW794VP5swNp7SLPAaEllP
         lLcQ==
X-Gm-Message-State: AC+VfDzmzM2a1aUzqWbLY0vuy4BKV+pkW5YOBM9dHpU3WnV77zPyYYeY
        TYhE/9le14AVwFBHtfzlHB9eDsjY6Is=
X-Google-Smtp-Source: ACHHUZ7ArsgmHv0yWzcONkKvqEmpBg7NHyT7G/Hn9x2wjF9AX2PY4+i2iveyzvhp6VelanZocecUjEBT6oY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1797:b0:64f:c0b1:6967 with SMTP id
 s23-20020a056a00179700b0064fc0b16967mr4749pfg.1.1685145056321; Fri, 26 May
 2023 16:50:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 26 May 2023 16:50:48 -0700
In-Reply-To: <20230526235048.2842761-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230526235048.2842761-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230526235048.2842761-4-seanjc@google.com>
Subject: [PATCH v2 3/3] KVM: selftests: Add test for race in kvm_recalculate_apic_map()
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
 .../kvm/x86_64/recalc_apic_map_race.c         | 76 +++++++++++++++++++
 2 files changed, 77 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/recalc_apic_map_race.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 7a5ff646e7e7..c9b8f16fb23f 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -116,6 +116,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/sev_migrate_tests
 TEST_GEN_PROGS_x86_64 += x86_64/amx_test
 TEST_GEN_PROGS_x86_64 += x86_64/max_vcpuid_cap_test
 TEST_GEN_PROGS_x86_64 += x86_64/triple_fault_event_test
+TEST_GEN_PROGS_x86_64 += x86_64/recalc_apic_map_race
 TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
 TEST_GEN_PROGS_x86_64 += demand_paging_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
diff --git a/tools/testing/selftests/kvm/x86_64/recalc_apic_map_race.c b/tools/testing/selftests/kvm/x86_64/recalc_apic_map_race.c
new file mode 100644
index 000000000000..09516548c11a
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/recalc_apic_map_race.c
@@ -0,0 +1,76 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * recalc_apic_map_race
+ *
+ * Test for a race condition in kvm_recalculate_apic_map().
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
+	 * Creating the max number of vCPUs supported by selftests so that KVM
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
+	kvm_vm_release(vm);
+
+	return 0;
+}
-- 
2.41.0.rc0.172.g3f132b7071-goog

