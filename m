Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46C196762E4
	for <lists+kvm@lfdr.de>; Sat, 21 Jan 2023 03:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjAUCIt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 21:08:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjAUCIo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 21:08:44 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2082.outbound.protection.outlook.com [40.107.220.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C11770C6B;
        Fri, 20 Jan 2023 18:08:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CVCUc9VS94BuNLynz4eKSrwJ1LfOGSX3/GUCz6aB9sY/1XVxMt2JKZLWvDt9EwBCNteW93nKLZQ9/xHYG3L32XTQQeFD/zn4YqR7AolXzn54UnerD+S0FzvVIe8iMt+1M+8hgW1GpPoSEJAwlNeZyU7WlnH+eladKUspZwl0xd5M78mzWmZXltnEeQMNdfIk/lmxQo7wzLJHZfdIFiXGMMmVZ7QL8/mWyq3cYRtGragODhi7JDkuIgsCw9Ovz0odjyDnDgHAGiIZQ3Fl6QJfzrdTZ26qcJcYSIuJmgP8BiKfdRBinuGIgtvPxlmKprgPfd3tnijRZfxJ+iHLVIXt8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SBELM1s2FXDCN1vghPgHk9ygS4+iUOF75gmUWGNa8YI=;
 b=b6DWgK345/zpvO4qImQQYDq5vWYWRZf4GRpYFJjbQUMaGFK+OYMDHvt7vikPb6UHzKXX6sDbRxW7QOE4Kf0FTyTScJFkopB/5JXs1YCNBA7s6d2LyFxow0keReFzCUfDnMhpk8hwXUjtGFt4z1+bdEFfJIZt0q8OreLKwbZqc4XWXBHxNyWKaGli2g9RrgFFx8tbkI0scBx2YxEK3O8jKMuWyz2cHj+Yyn7cNfiD/wtfIBTTlpMyUQGBy0Lly43q+e09Sb+JFwwfg+SNl1uJydbb3Yy/zE2Y9Oswkrvmrs0TsT+vfVlyLUG2GGt3vjifYCpdexIBgJ+b/okk+PFNSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SBELM1s2FXDCN1vghPgHk9ygS4+iUOF75gmUWGNa8YI=;
 b=tsMV7ftRlbZfsykJfy/N6ytFVYFsuF1Xkcz071Mhq4cNyXlhNMfstqoHr8ML8PvOJCl7GF7GdY6V+7sbZ8Y/aSb/UDSlJnsT1K9f1rXUGf03Orv0oSan8tzSNbhAWcNHgjEyW296SKxPkzQRuiNXhaIJuz1NRGV/an4/fcCst3Om4/Z+ABdoPQtcq7RMqUOvG7fG7eX8t5KNWgOPzo+wgK3XuDIzZUuMK+nrho2kqb8EPxwMOVBFPhQrPyKEWglqwXNYmffZ6LLmQc4KeAy8Ek/bvvNcph2G2/h/cwU/bOFz4X7ZK59PSCb07Z6H3+kAj6wnZx6DZIj7iJKEm7wT3A==
Received: from DM6PR03CA0074.namprd03.prod.outlook.com (2603:10b6:5:333::7) by
 SA0PR12MB4430.namprd12.prod.outlook.com (2603:10b6:806:70::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.27; Sat, 21 Jan 2023 02:08:31 +0000
Received: from DM6NAM11FT109.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:333:cafe::60) by DM6PR03CA0074.outlook.office365.com
 (2603:10b6:5:333::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27 via Frontend
 Transport; Sat, 21 Jan 2023 02:08:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT109.mail.protection.outlook.com (10.13.173.178) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6023.16 via Frontend Transport; Sat, 21 Jan 2023 02:08:31 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 20 Jan
 2023 18:08:20 -0800
Received: from dvt1-1.nvidia.com (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 20 Jan
 2023 18:08:20 -0800
From:   Kechen Lu <kechenl@nvidia.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>
CC:     <zhi.wang.linux@gmail.com>, <chao.gao@intel.com>,
        <shaoqin.huang@intel.com>, <vkuznets@redhat.com>,
        <kechenl@nvidia.com>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v6 6/6] KVM: selftests: Add tests for VM and vCPU cap KVM_CAP_X86_DISABLE_EXITS
Date:   Sat, 21 Jan 2023 02:07:38 +0000
Message-ID: <20230121020738.2973-7-kechenl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230121020738.2973-1-kechenl@nvidia.com>
References: <20230121020738.2973-1-kechenl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT109:EE_|SA0PR12MB4430:EE_
X-MS-Office365-Filtering-Correlation-Id: 7330a4eb-b44c-490d-f0c3-08dafb5464ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ar0xGZ+HyYYWQyySeX1mdROw8RjTLsC4BAJhanCoAmhJocsgpaovU/bfdie9FSuCDYkw4mwOKO5Hte23eKaL1OXgenUHT8fT6CxAZSFUL7I3g/ZUBPn/KVTQ+4w8+NVCxzop0VOYK8OLVBQJRAPqpqh1V4omLIN46G5oS0d3USqVBtMTtBu3ouD++qTSNIRcS4LCtpF+dJE4ivZTDOOOI2tm6SIsaLqBsWsPRQRRbasFCzfeXSoE+AFIE9A/DLhnErwbSGWr/4FHCLs9V91wzUpra1dvqUjOeo/ZjWbnSdwnPvuicRx01Y2NOiHsjT/wEDefX5wZpDJGzRy3od4nRJUgDPAozSmPgQruYP+FVBc9XbYbuFB2rOtPme31gc5WU487YbbAMSyiofYRwxC3dGDj3Hx2NpLpZQ8Xca78p45ixhFIElfRenrEW4V6Z8VkjcD2i/P7qKbi7EQT7b41a2bhVwGCXbHuuwmzHpOvYJIIvROl9eYQYKGBxe/IxVSvA9pKFawD/K9nSP3clIxLGsmbeCyNGN1H1t+evUzMC1FwIcOhcAQYRqOoffO3mLPTBr5WDOsv2RBtAQsTQ6ZOWH/Yo2YlUVTNzde7jw0/bPN/YcZgyVB9dMk0tRznWrE6/ZSq0zaY9cWQa21Ru+4Uj2uRoLNLZqKwbG22Vihe2QYvAJjCiPDfhMIG0TQD020svukdJ+MVry3YSwz1TJsAqg==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(346002)(396003)(451199015)(46966006)(40470700004)(36840700001)(5660300002)(30864003)(8936002)(4326008)(8676002)(82310400005)(70586007)(70206006)(36860700001)(6666004)(186003)(26005)(54906003)(2906002)(16526019)(316002)(7696005)(478600001)(36756003)(2616005)(110136005)(83380400001)(41300700001)(356005)(40460700003)(82740400003)(40480700001)(1076003)(86362001)(7636003)(47076005)(336012)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2023 02:08:31.4211
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7330a4eb-b44c-490d-f0c3-08dafb5464ef
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT109.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4430
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add selftests for KVM cap KVM_CAP_X86_DISABLE_EXITS overriding flags
in VM and vCPU scope both working as expected.

Suggested-by: Chao Gao <chao.gao@intel.com>
Suggested-by: Shaoqin Huang <shaoqin.huang@intel.com>
Suggested-by: Zhi Wang <zhi.wang.linux@gmail.com>
Signed-off-by: Kechen Lu <kechenl@nvidia.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/disable_exits_test.c | 363 ++++++++++++++++++
 2 files changed, 364 insertions(+)
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
index 000000000000..74a2152b35dd
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/disable_exits_test.c
@@ -0,0 +1,363 @@
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
+/* Arbitrary chosen IPI vector value from sender to halter vCPU */
+#define IPI_VECTOR	 0xa5
+/* Number of HLTs halter vCPU thread executes */
+#define LOOP_DURATION	 3
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
+
+	while (rdtsc() - tsc_start < 4000000000) {
+		if ((data->wake_count != old_wake_count) &&
+			(data->hlt_count != old_hlt_count))
+			break;
+	}
+	GUEST_ASSERT((data->wake_count != old_wake_count) &&
+			(data->hlt_count != old_hlt_count));
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
+		vcpu->id, r);
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
+static void vm_run_with_threads(struct kvm_vcpu *halter_vcpu,
+		struct kvm_vcpu *sender_vcpu)
+{
+	int r;
+	pthread_t threads[2];
+
+	/* Start halter vCPU thread and wait for it to execute first HLT. */
+	r = pthread_create(&threads[0], NULL, vcpu_thread, halter_vcpu);
+	TEST_ASSERT(r == 0,
+		"pthread_create halter failed errno=%d", errno);
+	fprintf(stderr, "Halter vCPU thread started\n");
+
+	sleep(1);
+
+	/*
+	 * After guest halter vCPU executed first HLT, start the sender
+	 * vCPU thread to wakeup halter vCPU
+	 */
+	r = pthread_create(&threads[1], NULL, vcpu_thread, sender_vcpu);
+	TEST_ASSERT(r == 0, "pthread_create sender failed errno=%d", errno);
+
+	sleep(LOOP_DURATION);
+
+	cancel_join_vcpu_thread(threads[0], halter_vcpu);
+	cancel_join_vcpu_thread(threads[1], sender_vcpu);
+}
+
+/*
+ * Test case 1:
+ * Normal VM running with one vCPU keeps executing HLTs,
+ * another vCPU sending IPIs to wake it up, should expect
+ * all HLTs exiting to host
+ * and Test case 2:
+ * VM scoped exits disabling, HLT instructions
+ * stay inside guest without exits
+ */
+static void test_vm_disable_exits_cap(bool cap_enabled)
+{
+	uint64_t kvm_halt_exits;
+	struct kvm_vm *vm;
+	struct kvm_vcpu *halter_vcpu;
+	struct kvm_vcpu *sender_vcpu;
+	struct guest_stats *data;
+	vm_vaddr_t guest_stats_page_vaddr;
+
+	/* Create VM */
+	vm = vm_create(2);
+
+	/*
+	 * Before adding any vCPUs, enable the KVM_X86_DISABLE_EXITS cap
+	 * with flag KVM_X86_DISABLE_EXITS_HLT
+	 */
+	if (cap_enabled)
+		vm_enable_cap(vm, KVM_CAP_X86_DISABLE_EXITS,
+			KVM_X86_DISABLE_EXITS_HLT);
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
+	vm_run_with_threads(halter_vcpu, sender_vcpu);
+	kvm_halt_exits = read_vcpu_stats_halt_exits(halter_vcpu);
+	if (cap_enabled)
+		TEST_ASSERT(kvm_halt_exits == 0,
+		"Halter vCPU had unexpected halt exits occurring after disabling VM-scoped halt exits cap\n");
+	else
+		TEST_ASSERT(kvm_halt_exits == data->hlt_count,
+		"Halter vCPU had unmatched %lu halt exits - %lu HLTs executed, when not disabling VM halt exits\n",
+		kvm_halt_exits, data->hlt_count);
+	fprintf(stderr, "Halter vCPU had %lu halt exits\n",
+		kvm_halt_exits);
+	fprintf(stderr, "Guest records %lu HLTs executed, waked %lu times\n",
+		data->hlt_count, data->wake_count);
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
+	vm_vcpu_add(vm, 0, halter_guest_code);
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
+		"Setting VM-scoped KVM_CAP_X86_DISABLE_EXITS after vCPUs created is not allowed, but it succeeds here\n");
+}
+
+/*
+ * Test case 4:
+ * vCPU scoped halt exits disabling and enabling tests,
+ * verify overides are working after vCPU created
+ */
+static void test_vcpu_toggling_disable_exits_cap(void)
+{
+	uint64_t kvm_halt_exits;
+	uint64_t kvm_halt_exits_in_guest;
+	struct kvm_vm *vm;
+	struct kvm_vcpu *halter_vcpu;
+	struct kvm_vcpu *sender_vcpu;
+	struct guest_stats *data;
+	vm_vaddr_t guest_stats_page_vaddr;
+
+	/* Create VM */
+	vm = vm_create(2);
+
+	/* Add vCPU with loops halting */
+	halter_vcpu = vm_vcpu_add(vm, 0, halter_guest_code);
+	/* Set KVM_CAP_X86_DISABLE_EXITS_HLT for halter vCPU */
+	vcpu_enable_cap(halter_vcpu, KVM_CAP_X86_DISABLE_EXITS,
+		KVM_X86_DISABLE_EXITS_HLT | KVM_X86_DISABLE_EXITS_OVERRIDE);
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
+	/*
+	 * For the first phase of the running, halt exits
+	 * are disabled, halter vCPU executes HLT instruction
+	 * but never exits to host
+	 */
+	vm_run_with_threads(halter_vcpu, sender_vcpu);
+	kvm_halt_exits_in_guest = data->hlt_count;
+	fprintf(stderr, "Guest records %lu HLTs with halt exits disabled\n",
+		data->hlt_count);
+	/*
+	 * Override and clean KVM_CAP_X86_DISABLE_EXITS flags
+	 * for halter vCPU. Expect to see halt exits occurs then.
+	 */
+	vcpu_enable_cap(halter_vcpu, KVM_CAP_X86_DISABLE_EXITS,
+		KVM_X86_DISABLE_EXITS_OVERRIDE);
+	/*
+	 * Second phase of the test, after guest halter vCPU
+	 * reenabled halt exits, start the sender
+	 * vCPU thread to wakeup halter vCPU
+	 */
+	vm_run_with_threads(halter_vcpu, sender_vcpu);
+	kvm_halt_exits = read_vcpu_stats_halt_exits(halter_vcpu);
+	TEST_ASSERT(kvm_halt_exits == data->hlt_count - kvm_halt_exits_in_guest,
+		"Halter vCPU had unexpected %lu (should be %lu) halt exits\n",
+		kvm_halt_exits, data->hlt_count - kvm_halt_exits_in_guest);
+	fprintf(stderr, "Halter vCPU had %lu halt exits\n",
+		kvm_halt_exits);
+	fprintf(stderr, "Guest records %lu HLTs executed, waked %lu times\n",
+		data->hlt_count, data->wake_count);
+
+	kvm_vm_free(vm);
+}
+
+int main(int argc, char *argv[])
+{
+	fprintf(stderr, "VM-scoped tests start\n");
+	test_vm_disable_exits_cap(false);
+	test_vm_disable_exits_cap(true);
+	test_vm_disable_exits_cap_with_vcpu_created();
+	fprintf(stderr, "vCPU-scoped test starts\n");
+	test_vcpu_toggling_disable_exits_cap();
+	return 0;
+}
-- 
2.34.1

