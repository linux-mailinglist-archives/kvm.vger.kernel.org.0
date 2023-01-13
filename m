Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 671AA66A5A1
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 23:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbjAMWDD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 17:03:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbjAMWCh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 17:02:37 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2046.outbound.protection.outlook.com [40.107.92.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C2D76808;
        Fri, 13 Jan 2023 14:02:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BlNzB4mjp7l8dVUIS6+lyWLLnIesWTqjP3/2daDeegunms00NS0UPtWn01uWPg6JHx7r5wUff1qCRrvDe9uvA+kjHGNfhosY4BzV9L/3NNwFXC7vO6LDNUbBlycry2c36jWaycWf0v5S41HqptlIxUuM8xYA6VcFrmvdBVcRU2vbxM1vOK5c765slyjopNkXJFm1M+H/sQCpHjWHfa0GxvJUottxt3f/KFITs17HddRpQX7jgQJ3FgPoPMKDKjijkPvM8jjpc0sWnZ4xPFzOLRSdo7wyugxv/ZdhgjUxei4IbYcjeb823ItBtBy35/dJLxA4RRaO77YvmH45CBvv1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NKDycVnZfRlgX0CLjScE7vgCoOPktCmR0T6UvKo1v14=;
 b=KopY7AouAyGD8/cuvL6z6wtx7HWShrICVpTCXAiyTqvru3zZRgSuzmYuKTuF+eUevH8dpAZPzw+fNlyFRQ1m6aZBdKSdxsYLxzxLf4K1xs5KMrWaojMvvvYcQkNiAoRbAodS2Ul9q79djU2VscRL/lZDQMhb8VwiBs8g7g0ycEfXUsQuN3PmBKp2XDwWKLIgvaXvgN8O6WO8G74JUIWskPjkuj1ie386E7fztjIq6P1X9uKKUia8tP9P4nneIHeQo/Nj+K9fFQ7epkwAU8VrQuYI5VUCa7H3lqv6SsmnYWsyPMoYqTKAA32zML1LYgo6qHfd4fxQlZ07CGhrmLFoVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NKDycVnZfRlgX0CLjScE7vgCoOPktCmR0T6UvKo1v14=;
 b=hfBMvjXmX2ww+AbqKHg+WTEx2zIQyy+tWGE5pz/EcOEt4qh+SO5BpwVmVQBuCtUYLGDTaMH0Pg0oxdHn3s6d6sPkCAmxH1Uyy7a2m5P6cDrtkpE4UfrYEzOrKcQe2HhsuCqQkTmtqaOq/s9ACWIHU4+VZ8wUZSQiUAe8f2QViXkaR6bpAt7RKje7nXPZoE8t9DBwnifLop5XPvBarfy7xgFArmK7nS2U6pKPGNsxurK0YjyllVjRYUSq2IoSVBfdEoJ5juklmw1EF0xZVwuW+fsmjBZVMW8qLNoJWnp2whhAGXA8fIqNTF8qBEVTV2jiZLVmo6y35q+lm9d0COlscg==
Received: from DS7PR03CA0227.namprd03.prod.outlook.com (2603:10b6:5:3ba::22)
 by BY5PR12MB4853.namprd12.prod.outlook.com (2603:10b6:a03:1da::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Fri, 13 Jan
 2023 22:02:19 +0000
Received: from DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ba:cafe::c3) by DS7PR03CA0227.outlook.office365.com
 (2603:10b6:5:3ba::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.16 via Frontend
 Transport; Fri, 13 Jan 2023 22:02:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT016.mail.protection.outlook.com (10.13.173.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Fri, 13 Jan 2023 22:02:19 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 13 Jan
 2023 14:02:05 -0800
Received: from dvt1-1.nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 13 Jan
 2023 14:02:05 -0800
From:   Kechen Lu <kechenl@nvidia.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>
CC:     <chao.gao@intel.com>, <shaoqin.huang@intel.com>,
        <vkuznets@redhat.com>, <kechenl@nvidia.com>,
        <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v5 6/6] KVM: selftests: Add tests for VM and vCPU cap KVM_CAP_X86_DISABLE_EXITS
Date:   Fri, 13 Jan 2023 22:01:14 +0000
Message-ID: <20230113220114.2437-7-kechenl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230113220114.2437-1-kechenl@nvidia.com>
References: <20230113220114.2437-1-kechenl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT016:EE_|BY5PR12MB4853:EE_
X-MS-Office365-Filtering-Correlation-Id: a1cd7d0e-6113-4817-ef89-08daf5b1d719
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jdreHZGAvBfiWDs77OIr3LfZGRR2U9JePJr2zJih3G6YO7UkhGDEcpLDeufoZxPKU7kOMJwlYR1MRPLVjYe2tRWcCSJTFe3f7nCSaFXdac7GyNrdOzUgEDmBTh33mahnrX0HX0SXdnKl6m6xr/lW2ZSjeZAk0zjvDJ8FH7PN5zlIHkX/KVe8qkXIgNa/d3SjJmuhvD0c8lnHpD9wLrQggXZ6lXIvr+SWvEFtb5w0/mmh8a3hG82z4EOEG81X207hoHSIPejWQlllj1Fc7cvr/AsaC/SO1nVdADoRfUmJgesr7KA6VtEl9OHQ9k+1OprxBOD1I2tsZXWwqc9YAH8SGizBCVTOhMQBzo0jZoZrWvrubynA5WkVBNOk/qD+TdjBuoe9cMIdBXx+WnOrimSED0De82yc4Xwu8tQpNOSfzFn8d0+6mAk7XYPWSMmZFAtf7j8QCbWZkHPUKfJ/EDeKoTTmhYZjd/RKuJrhrDA33n/8VzaxyO5a/TTcMBaQxB/TsXYIrDiyXELY9joPXMuCbJ/NQ+RA6/M0fSo0zqzWuvC5KsQQfd+mipWyW+rA7/z/2YJDgdQes2nDPbEf5F+BSnxxhn0IH20zoF4zGZ0L92tDJi3XxQ8ra9vottt/0oVRSzgIQGLimja4i4A/Fch4KjtfC9pzl8oEEPexSdeBkVC8eIIxA/LyhqNRlaBX4adZD4RLmEW5tDDMfzb6wI+k5g==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(39860400002)(396003)(451199015)(36840700001)(46966006)(40470700004)(7636003)(82740400003)(356005)(40480700001)(36756003)(40460700003)(82310400005)(86362001)(2616005)(110136005)(54906003)(316002)(26005)(1076003)(336012)(478600001)(186003)(6666004)(16526019)(7696005)(30864003)(36860700001)(2906002)(83380400001)(4326008)(41300700001)(8676002)(70206006)(70586007)(47076005)(426003)(8936002)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 22:02:19.1601
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1cd7d0e-6113-4817-ef89-08daf5b1d719
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4853
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add selftests for KVM cap KVM_CAP_X86_DISABLE_EXITS overriding flags
in VM and vCPU scope both works as expected.

Suggested-by: Chao Gao <chao.gao@intel.com>
Suggested-by: Shaoqin Huang <shaoqin.huang@intel.com>
Signed-off-by: Kechen Lu <kechenl@nvidia.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/disable_exits_test.c | 457 ++++++++++++++++++
 2 files changed, 458 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/disable_exits_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 1750f91dd936..eeeba35e2536 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -114,6 +114,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/sev_migrate_tests
 TEST_GEN_PROGS_x86_64 += x86_64/amx_test
 TEST_GEN_PROGS_x86_64 += x86_64/max_vcpuid_cap_test
 TEST_GEN_PROGS_x86_64 += x86_64/triple_fault_event_test
+TEST_GEN_PROGS_x86_64 += x86_64/disable_exits_test
 TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
 TEST_GEN_PROGS_x86_64 += demand_paging_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
diff --git a/tools/testing/selftests/kvm/x86_64/disable_exits_test.c b/tools/testing/selftests/kvm/x86_64/disable_exits_test.c
new file mode 100644
index 000000000000..dceba3bcef5f
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/disable_exits_test.c
@@ -0,0 +1,457 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Test per-VM and per-vCPU disable exits cap
+ * 1) Per-VM scope 
+ * 2) Per-vCPU scope
+ *
+ */
+
+#define _GNU_SOURCE /* for program_invocation_short_name */
+#include <pthread.h>
+#include <inttypes.h>
+#include <string.h>
+#include <time.h>
+#include <sys/ioctl.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "svm_util.h"
+#include "vmx.h"
+#include "processor.h"
+#include "asm/kvm.h"
+#include "linux/kvm.h"
+
+/* Arbitary chosen IPI vector value from sender to halter vCPU */
+#define IPI_VECTOR	 0xa5
+/* Number of HLTs halter vCPU thread executes */
+#define COUNT_HLT_EXITS	 10
+
+struct guest_stats {
+	uint32_t halter_apic_id;
+	volatile uint64_t hlt_count;
+	volatile uint64_t wake_count;
+};
+
+static u64 read_vcpu_stats_halt_exits(struct kvm_vcpu *vcpu)
+{
+	int i;
+	struct kvm_stats_header header;
+	u64 *stats_data;
+	u64 ret = 0;
+	struct kvm_stats_desc *stats_desc;
+	struct kvm_stats_desc *pdesc;
+	int stats_fd = vcpu_get_stats_fd(vcpu);
+
+	read_stats_header(stats_fd, &header);
+	if (header.num_desc == 0) {
+		fprintf(stderr,
+			"Cannot read halt exits since no KVM stats defined\n");
+		return ret;
+	}
+
+	stats_desc = read_stats_descriptors(stats_fd, &header);
+	for (i = 0; i < header.num_desc; ++i) {
+		pdesc = get_stats_descriptor(stats_desc, i, &header);
+		if (!strncmp(pdesc->name, "halt_exits", 10)) {
+			stats_data = malloc(pdesc->size * sizeof(*stats_data));
+			read_stat_data(stats_fd, &header, pdesc, stats_data,
+				pdesc->size);
+			ret = *stats_data;
+			free(stats_data);
+			break;
+		}
+	}
+	free(stats_desc);
+	return ret;
+}
+
+/* HLT multiple times in one vCPU */
+static void halter_guest_code(struct guest_stats *data)
+{
+	xapic_enable();
+	data->halter_apic_id = GET_APIC_ID_FIELD(xapic_read_reg(APIC_ID));
+
+	for (;;) {
+		data->hlt_count++;
+		asm volatile("sti; hlt; cli");
+		data->wake_count++;
+	}
+}
+
+static void halter_waiting_guest_code(struct guest_stats *data)
+{
+	uint64_t tsc_start = rdtsc();
+
+	xapic_enable();
+	data->halter_apic_id = GET_APIC_ID_FIELD(xapic_read_reg(APIC_ID));
+
+	for (;;) {
+		data->hlt_count++;
+		asm volatile("sti; hlt; cli");
+		data->wake_count++;
+		/* Wait for ~0.5sec for each HLT execution */
+		tsc_start = rdtsc();
+		while (rdtsc() - tsc_start < 2000000000);
+	}
+}
+
+/* Runs on halter vCPU when IPI arrives */
+static void guest_ipi_handler(struct ex_regs *regs)
+{
+	xapic_write_reg(APIC_EOI, 11);
+}
+
+/* Sender vCPU waits for ~1sec to assume HLT executed */
+static void sender_wait_loop(struct guest_stats *data, uint64_t old_hlt_count,
+		uint64_t old_wake_count)
+{
+	uint64_t tsc_start = rdtsc();
+	while (rdtsc() - tsc_start < 4000000000);
+	GUEST_ASSERT((data->wake_count != old_wake_count) &&
+		       	(data->hlt_count != old_hlt_count));
+}
+
+/* Sender vCPU loops sending IPI to halter vCPU every ~1sec */
+static void sender_guest_code(struct guest_stats *data)
+{
+	uint32_t icr_val;
+	uint32_t icr2_val;
+	uint64_t old_hlt_count = 0;
+	uint64_t old_wake_count = 0;
+
+	xapic_enable();
+	/* Init interrupt command register for sending IPIs */
+	icr_val = (APIC_DEST_PHYSICAL | APIC_DM_FIXED | IPI_VECTOR);
+	icr2_val = SET_APIC_DEST_FIELD(data->halter_apic_id);
+
+	for (;;) {
+		/*
+		 * Send IPI to halted vCPU
+		 * First IPI sends here as already waited before sender vCPU
+		 * thread creation
+		 */
+		xapic_write_reg(APIC_ICR2, icr2_val);
+		xapic_write_reg(APIC_ICR, icr_val);
+		sender_wait_loop(data, old_hlt_count, old_wake_count);
+		GUEST_ASSERT((data->wake_count != old_wake_count) &&
+			(data->hlt_count != old_hlt_count));
+		old_wake_count = data->wake_count;
+		old_hlt_count = data->hlt_count;
+	}
+}
+
+static void *vcpu_thread(void *arg)
+{
+	struct kvm_vcpu *vcpu = (struct kvm_vcpu *)arg;
+	int old;
+	int r;
+
+	r = pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS, &old);
+	TEST_ASSERT(r == 0,
+		"pthread_setcanceltype failed on vcpu_id=%u with errno=%d",
+	       	vcpu->id, r);
+	fprintf(stderr, "vCPU thread running vCPU %u\n", vcpu->id);
+	vcpu_run(vcpu);
+	return NULL;
+}
+
+static void cancel_join_vcpu_thread(pthread_t thread, struct kvm_vcpu *vcpu)
+{
+	void *retval;
+	int r;
+
+	r = pthread_cancel(thread);
+	TEST_ASSERT(r == 0,
+		"pthread_cancel on vcpu_id=%d failed with errno=%d",
+		vcpu->id, r);
+
+	r = pthread_join(thread, &retval);
+	TEST_ASSERT(r == 0,
+		"pthread_join on vcpu_id=%d failed with errno=%d",
+		vcpu->id, r);
+}
+
+/*
+ * Test case 1:
+ * Normal VM running with one vCPU keeps executing HLTs,
+ * another vCPU sending IPIs to wake it up, should expect
+ * all HLTs exiting to host
+ */
+static void test_vm_without_disable_exits_cap(void)
+{
+	int r;
+	int wait_secs;
+	const int first_halter_wait = 10;
+	uint64_t kvm_halt_exits;
+	struct kvm_vm *vm;
+	struct kvm_vcpu *halter_vcpu;
+	struct kvm_vcpu *sender_vcpu;
+	struct guest_stats *data;
+	vm_vaddr_t guest_stats_page_vaddr;
+	pthread_t threads[2];
+
+	/* Create VM */
+	vm = vm_create(2);
+
+	/* Add vCPU with loops halting */
+	halter_vcpu = vm_vcpu_add(vm, 0, halter_guest_code);
+
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(halter_vcpu);
+	vm_install_exception_handler(vm, IPI_VECTOR, guest_ipi_handler);
+	virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
+
+	/* Add vCPU with IPIs waking up halter vCPU */
+	sender_vcpu = vm_vcpu_add(vm, 1, sender_guest_code);
+
+	guest_stats_page_vaddr = vm_vaddr_alloc_page(vm);
+	data = addr_gva2hva(vm, guest_stats_page_vaddr);
+	memset(data, 0, sizeof(*data));
+
+	vcpu_args_set(halter_vcpu, 1, guest_stats_page_vaddr);
+	vcpu_args_set(sender_vcpu, 1, guest_stats_page_vaddr);
+
+	/* Start halter vCPU thread and wait for it to execute first HLT. */
+	r = pthread_create(&threads[0], NULL, vcpu_thread, halter_vcpu);
+	TEST_ASSERT(r == 0,
+		"pthread_create halter failed errno=%d", errno);
+	fprintf(stderr, "Halter vCPU thread started\n");
+
+	wait_secs = 0;
+	while ((wait_secs < first_halter_wait) && !data->hlt_count) {
+		sleep(1);
+		wait_secs++;
+	}
+	TEST_ASSERT(data->hlt_count,
+		"Halter vCPU did not execute first HLT within %d seconds",
+	       	first_halter_wait);
+	fprintf(stderr,
+		"Halter vCPU thread reported its first HLT executed "
+	       	"after %d seconds.\n",
+		wait_secs);
+
+	/* 
+	 * After guest halter vCPU executed first HLT, start the sender
+	 * vCPU thread to wakeup halter vCPU
+	 */
+	r = pthread_create(&threads[1], NULL, vcpu_thread, sender_vcpu);
+	TEST_ASSERT(r == 0, "pthread_create sender failed errno=%d", errno);
+
+	while (data->hlt_count < COUNT_HLT_EXITS);
+
+	cancel_join_vcpu_thread(threads[0], halter_vcpu);
+	cancel_join_vcpu_thread(threads[1], sender_vcpu);
+
+	kvm_halt_exits = read_vcpu_stats_halt_exits(halter_vcpu);
+	TEST_ASSERT(kvm_halt_exits == data->hlt_count,
+		"Halter vCPU had unmatched %lu halt exits - %lu HLTs "
+		"executed, when not disabling VM halt exits\n",
+	       	kvm_halt_exits, data->hlt_count);
+	fprintf(stderr, "Halter vCPU had %lu halt exits\n",
+		kvm_halt_exits);
+	fprintf(stderr, "Guest records %lu HLTs executed, "
+		"waked %lu times\n",
+		data->hlt_count, data->wake_count);
+
+	kvm_vm_free(vm);
+}
+
+/*
+ * Test case 2:
+ * VM scoped exits disabling, HLT instructions
+ * stay inside guest without exits
+ */
+static void test_vm_disable_exits_cap(void)
+{
+	int r;
+	uint64_t kvm_halt_exits;
+	struct kvm_vm *vm;
+	struct kvm_vcpu *halter_vcpu;
+	struct guest_stats *data;
+	vm_vaddr_t guest_stats_page_vaddr;
+	pthread_t halter_thread;
+
+	/* Create VM */
+	vm = vm_create(1);
+
+	/*
+	 * Before adding any vCPUs, enable the KVM_X86_DISABLE_EXITS cap
+	 * with flag KVM_X86_DISABLE_EXITS_HLT
+	 */
+	vm_enable_cap(vm, KVM_CAP_X86_DISABLE_EXITS,
+		KVM_X86_DISABLE_EXITS_HLT);
+
+	/* Add vCPU with loops halting */
+	halter_vcpu = vm_vcpu_add(vm, 0, halter_waiting_guest_code);
+
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(halter_vcpu);
+	vm_install_exception_handler(vm, IPI_VECTOR, guest_ipi_handler);
+	virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
+
+	guest_stats_page_vaddr = vm_vaddr_alloc_page(vm);
+	data = addr_gva2hva(vm, guest_stats_page_vaddr);
+	memset(data, 0, sizeof(*data));
+	vcpu_args_set(halter_vcpu, 1, guest_stats_page_vaddr);
+
+	/* Start halter vCPU thread and execute HLTs immediately */
+	r = pthread_create(&halter_thread, NULL, vcpu_thread, halter_vcpu);
+	TEST_ASSERT(r == 0,
+		"pthread_create halter failed errno=%d", errno);
+	fprintf(stderr, "Halter vCPU thread started\n");
+
+	while (data->hlt_count < COUNT_HLT_EXITS);
+
+	cancel_join_vcpu_thread(halter_thread, halter_vcpu);
+
+	kvm_halt_exits = read_vcpu_stats_halt_exits(halter_vcpu);
+	TEST_ASSERT(kvm_halt_exits == 0,
+		"Halter vCPU had unexpected halt exits occuring after "
+		"disabling VM-scoped halt exits cap\n");
+	fprintf(stderr, "Halter vCPU had %lu HLT exits\n",
+		kvm_halt_exits);
+	fprintf(stderr, "Guest records %lu HLTs executed\n",
+		data->hlt_count);
+
+	kvm_vm_free(vm);
+}
+
+/*
+ * Test case 3:
+ * VM overrides exits disable flags after vCPU created,
+ * which is not allowed
+ */
+static void test_vm_disable_exits_cap_with_vcpu_created(void)
+{
+	int r;
+	struct kvm_vm *vm;
+	struct kvm_enable_cap cap = {
+		.cap = KVM_CAP_X86_DISABLE_EXITS,
+		.args[0] = KVM_X86_DISABLE_EXITS_HLT | KVM_X86_DISABLE_EXITS_OVERRIDE,
+	};
+
+	/* Create VM */
+	vm = vm_create(1);
+	/* Add vCPU with loops halting */
+	vm_vcpu_add(vm, 0, halter_waiting_guest_code);
+
+	/*
+	 * After creating vCPU, the current VM-scoped ABI should 
+	 * discard the cap enable of KVM_CAP_X86_DISABLE_EXITS
+	 * and return non-zero. Since vm_enabled_cap() not able
+	 * to assert the return value, so use the __vm_ioctl()
+	 */
+	r = __vm_ioctl(vm, KVM_ENABLE_CAP, &cap);
+
+	TEST_ASSERT(r != 0,
+		"Setting VM-scoped KVM_CAP_X86_DISABLE_EXITS after "
+		"vCPUs created is not allowed, but it succeeds here\n");
+}
+
+/*
+ * Test case 4:
+ * vCPU scoped halt exits disabling and enabling tests,
+ * verify overides are working after vCPU created
+ */
+static void test_vcpu_toggling_disable_exits_cap(void)
+{
+	int r;
+	uint64_t kvm_halt_exits;
+	struct kvm_vm *vm;
+	struct kvm_vcpu *halter_vcpu;
+	struct kvm_vcpu *sender_vcpu;
+	struct guest_stats *data;
+	vm_vaddr_t guest_stats_page_vaddr;
+	pthread_t threads[2];
+
+	/* Create VM */
+	vm = vm_create(2);
+
+	/* Add vCPU with loops halting */
+	halter_vcpu = vm_vcpu_add(vm, 0, halter_waiting_guest_code);
+	/* Set KVM_CAP_X86_DISABLE_EXITS_HLT for halter vCPU */
+	vcpu_enable_cap(halter_vcpu, KVM_CAP_X86_DISABLE_EXITS,
+		KVM_X86_DISABLE_EXITS_HLT | KVM_X86_DISABLE_EXITS_OVERRIDE);
+
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(halter_vcpu);
+	vm_install_exception_handler(vm, IPI_VECTOR, guest_ipi_handler);
+
+	virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
+
+	/* Add vCPU with IPIs waking up halter vCPU */
+	sender_vcpu = vm_vcpu_add(vm, 1, sender_guest_code);
+
+	guest_stats_page_vaddr = vm_vaddr_alloc_page(vm);
+	data = addr_gva2hva(vm, guest_stats_page_vaddr);
+	memset(data, 0, sizeof(*data));
+
+	vcpu_args_set(halter_vcpu, 1, guest_stats_page_vaddr);
+	vcpu_args_set(sender_vcpu, 1, guest_stats_page_vaddr);
+
+	r = pthread_create(&threads[0], NULL, vcpu_thread, halter_vcpu);
+	TEST_ASSERT(r == 0,
+		"pthread_create halter failed errno=%d", errno);
+	fprintf(stderr, "Halter vCPU thread started with halt exits"
+		"disabled\n");
+
+	/* 
+	 * For the first phase of the running, halt exits
+	 * are disabled, halter vCPU executes HLT instruction
+	 * but never exits to host
+	 */
+	while (data->hlt_count < (COUNT_HLT_EXITS / 2));
+
+	cancel_join_vcpu_thread(threads[0], halter_vcpu);
+	/* 
+	 * Override and clean KVM_CAP_X86_DISABLE_EXITS flags 
+	 * for halter vCPU. Expect to see halt exits occurs then.
+	 */
+	vcpu_enable_cap(halter_vcpu, KVM_CAP_X86_DISABLE_EXITS,
+		KVM_X86_DISABLE_EXITS_OVERRIDE);
+
+	r = pthread_create(&threads[0], NULL, vcpu_thread, halter_vcpu);
+	TEST_ASSERT(r == 0,
+		"pthread_create halter failed errno=%d", errno);
+	fprintf(stderr, "Halter vCPU thread restarted and cleared "
+		"halt exits flag\n");
+
+	sleep(1);
+	/* 
+	 * Second phase of the test, after guest halter vCPU
+	 * reenabled halt exits, start the sender
+	 * vCPU thread to wakeup halter vCPU
+	 */
+	r = pthread_create(&threads[1], NULL, vcpu_thread, sender_vcpu);
+	TEST_ASSERT(r == 0, "pthread_create sender failed errno=%d", errno);
+
+	while (data->hlt_count < COUNT_HLT_EXITS);
+
+	cancel_join_vcpu_thread(threads[0], halter_vcpu);
+	cancel_join_vcpu_thread(threads[1], sender_vcpu);
+
+	kvm_halt_exits = read_vcpu_stats_halt_exits(halter_vcpu);
+	TEST_ASSERT(kvm_halt_exits == (COUNT_HLT_EXITS / 2),
+		"Halter vCPU had unexpected %lu halt exits, "
+		"there should be %d halt exits while "
+		"not disabling VM halt exits\n",
+	       	kvm_halt_exits, COUNT_HLT_EXITS / 2);
+	fprintf(stderr, "Halter vCPU had %lu halt exits\n",
+		kvm_halt_exits);
+	fprintf(stderr, "Guest records %lu HLTs executed, "
+		"waked %lu times\n",
+		data->hlt_count, data->wake_count);
+
+	kvm_vm_free(vm);
+}
+
+int main(int argc, char *argv[])
+{
+	fprintf(stderr, "VM-scoped tests start\n");
+	test_vm_without_disable_exits_cap();
+	test_vm_disable_exits_cap();
+	test_vm_disable_exits_cap_with_vcpu_created();
+	fprintf(stderr, "vCPU-scoped test starts\n");
+	test_vcpu_toggling_disable_exits_cap();
+	return 0;
+}
-- 
2.34.1

