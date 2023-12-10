Return-Path: <kvm+bounces-3997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF03480B9CC
	for <lists+kvm@lfdr.de>; Sun, 10 Dec 2023 09:13:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CF98BB20A7B
	for <lists+kvm@lfdr.de>; Sun, 10 Dec 2023 08:13:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F34006D3F;
	Sun, 10 Dec 2023 08:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="pR+oypzw"
X-Original-To: kvm@vger.kernel.org
Received: from AUS01-SY4-obe.outbound.protection.outlook.com (mail-sy4aus01olkn2175.outbound.protection.outlook.com [40.92.62.175])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A9EC5;
	Sun, 10 Dec 2023 00:13:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ksGonCfeaPwR6l5GxKxoTf6pnuz1Bjt0wtGjUOpjJf6cj4uLUkoo7i9+iZU069MuRND+1EMuEymxCokQ3aV/PXa7nFGpKj2mTN1fYNx4U9fI7E89R6P8RQA936lUW8mjzyV9LYXLfc0+yS2lAgzVqQnKUtfVHwFrSKDQhY4KXs5wwj+zzsDHpa8/zxBq/99Z+FqKs/+KFMFT3hF673nI5vaN+KvBNJBGKjdb42c5rm6ec0PiP7lTeJ3DKBupa1L+FbhF85Ocb/IIB42yOSlMwDq9YzMYUGm4apaiyWOKCvIWZHLOwR/Li/ich7zfIg7vCoSW8mz9lCoOrn90oMuNKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QPuHegOvjI1Wqy9bawitz85TcVTd7dRsokA5lEbAaHg=;
 b=CJJHfaihp31VcOb8dRdNImfqLJftgWnv8kkScbTIFaeSvgoh1/avnwQx38q+XkMMXlIPwsQmV8SC3a4ORVwHUubl3+Lqbq3VZcZCiA7JRgeCKJtxr7xXxunGCUHIdXRu41CHdH2Q2eGQCozVkOTOcWlvhhDqU3jWQGDsxSBv4sPyFni+Yr2lnfcCiijbs6/UeQXVtfiP9aPBmrquG0pW1nTKAXcO0PIjl8OsTxcDJfnsTD18Zh4QPnE85ZKgLNr/AYpja/XXsxJFDRCokptrgEzkK+J7VX0IqspcE4Pvzytg4hMzDrlUkm/ftXOS/9Y8IjwjwgtVO9fUoXLVRDwf5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QPuHegOvjI1Wqy9bawitz85TcVTd7dRsokA5lEbAaHg=;
 b=pR+oypzw3XWu2MtJ9PWqLyoJXpzYdwiWXRfzQoGX014y3p2dqrcyjSL2EBeHqLD1vEZtVAos/eVyYkRWKlWLHvsIHdv2cadY1a1AFthCw3Kddg2r+I5tnDOtdht9xAT70t3XseQXoeSjM/uWUi1gEpi9DNGJBkjSv2Hvw0+mfEhSPjcNmABUwkwai2eHlzUj9+/Hj0j5zpKMzvQCWxZefL2BKsVXtacDKYgOI+NAN24nCZyBtpWYoTfZ49y8vCgacGCBykd509lQMgjfUDjm+KxA3103CmrL2Out2aP8J2KqDVxrC7OJNBECn22Q0R+d66PnDcDgOCEU3vkmfX2EGA==
Received: from SYBPR01MB6870.ausprd01.prod.outlook.com (2603:10c6:10:13d::10)
 by MEYPR01MB7339.ausprd01.prod.outlook.com (2603:10c6:220:15f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.31; Sun, 10 Dec
 2023 08:12:53 +0000
Received: from SYBPR01MB6870.ausprd01.prod.outlook.com
 ([fe80::be5a:160f:5418:9deb]) by SYBPR01MB6870.ausprd01.prod.outlook.com
 ([fe80::be5a:160f:5418:9deb%5]) with mapi id 15.20.7068.030; Sun, 10 Dec 2023
 08:12:53 +0000
From: Tianyi Liu <i.pear@outlook.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	acme@kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	mark.rutland@arm.com,
	mlevitsk@redhat.com,
	maz@kernel.org,
	alexander.shishkin@linux.intel.com,
	jolsa@kernel.org,
	namhyung@kernel.org,
	irogers@google.com,
	adrian.hunter@intel.com,
	Tianyi Liu <i.pear@outlook.com>
Subject: [PATCH v3 1/5] KVM: Add arch specific interfaces for sampling guest callchains
Date: Sun, 10 Dec 2023 16:12:18 +0800
Message-ID:
 <SYBPR01MB6870FDFBB88F879C735198F39D88A@SYBPR01MB6870.ausprd01.prod.outlook.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <SYBPR01MB687069BFC9744585B4EEF8C49D88A@SYBPR01MB6870.ausprd01.prod.outlook.com>
References: <SYBPR01MB687069BFC9744585B4EEF8C49D88A@SYBPR01MB6870.ausprd01.prod.outlook.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN: [QSggTfQqFdbZg1h9Gs/NfozjCC3waagQZgTkdujY8Bxzr5XF3x6M1A==]
X-ClientProxiedBy: SG2PR01CA0125.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::29) To SYBPR01MB6870.ausprd01.prod.outlook.com
 (2603:10c6:10:13d::10)
X-Microsoft-Original-Message-ID: <20231210081218.2226-1-i.pear@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SYBPR01MB6870:EE_|MEYPR01MB7339:EE_
X-MS-Office365-Filtering-Correlation-Id: e6e3b1ce-4bc6-4d46-15a7-08dbf957cec1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	F3LN9hyPvN0CAVmU+CwhB+XgRrUEjHa4HI1zqe9BR1NM6xasWGUEsY21KafHRI3J6udF87Jntl/23EfJtc/Opb+vhobD14RLba1BTrlHBKYOmzbqq2koxkZRQyO47EL/bpUvwwpJs82XwF97jlhkabhXYL6QpsIGVVtU9lpA10RjaSs21fXg0BN0joIj17O6dK3xewzJ3XS8prVTjc6jURKdavKVp4MtSwUkCxXYXTcfMoFlZfpAgJUcjB64nhmc4a4vVp4s0GhSDaum5OMazYF/Hz6BtUzCXslKzjILBdQ5kiSCKp0NIZIbXdHPKNvnILwL0CqyYi4gvbrMTIUcPYDsYNFf3rXWgHjWybY4j2ZJ+PylNH/1lt9Nhd33yHflJVEkYE8KTeI4cQmMvGQ1K4L2u1Z50F4UtzZCsYcM2qBsvYnzn/tpBVJ8siv2xq+1biS8tCbKTX2LGHzeAv/VcTsmOfMam5OKlH5lRKcwojiBLArs8Oe7JqBihVrzmZmosCNboAUaeIUtAtQMILPIQBEAqiKd9nGVrjLHJXBtOGKZe6/c3uPc7dC3pBbQmuiORR8WwGUS3JF3ELuR7dNB4s+lH2ilIL9wYmogpQn+XtnqLXByGOk5o5pxnpH96IAN
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bfaX2bWF1FUPdvdpZQncA5I18O7ptYdkMt6nx0ifU5KnqRLHs7jrC+3OkApL?=
 =?us-ascii?Q?fxVTlDbFNn72Dgr495NNCmI0GGVNCwyXh5SRDIMZ+YvAumLvKeSjIS6RIdXL?=
 =?us-ascii?Q?emV8BuC3mmRl+747dOAiz70Irb619dO/nEdYGHcONsAOmRNuKAWwdB5beKkT?=
 =?us-ascii?Q?yZ6fP6TpDQmIVxP6tbJ5eYQn7oDlnoVJSpDlhv7f30cW+494lfvA71sweScc?=
 =?us-ascii?Q?nWl0lko9StWR7WmPnW8xWCG1IaEP2aKT3C4HVTVWuzPUi3GoiDxDN2/faDxv?=
 =?us-ascii?Q?+vEQgB2TljwIF90NxgO79kp2A3J078cl+fqJfsxNvSTYqnXUaneJVlA5pzh3?=
 =?us-ascii?Q?PPHOOwJCG3pmKG9P9jhludrHaSN/FNwo8a38f0oMUJpWsYPNPsa8ifY+tgWb?=
 =?us-ascii?Q?132mPYMtJ7rdjuxyj/URGu4IlgbwMGiW2piN4H9HCXrqpqNlntj+ieNbvpDE?=
 =?us-ascii?Q?hXKJM0EGhXxun4QgOmg2WkpeSkpSe7+Rq2qnlZ7r/2zGr7iD6oTC1DCkWVMH?=
 =?us-ascii?Q?ic9wKPovWHoDqBfBOZu/wwh3nV56p7NQEvt4WkuynEDGkkQr9eJg+iaxd1nK?=
 =?us-ascii?Q?E2yzjVwj5FnRiVcLe2DSQObzVeayPx+YciEM4VRnMmL99zWtbkbqRJB106wU?=
 =?us-ascii?Q?ZTS1y7nukBk2PnlNdXxQ2YuzUVRW3EjOn8p7cXE3PZgLsTX7WAMNO/yXN5SK?=
 =?us-ascii?Q?hPqpmQH4pPQNOax0EujHor/8aRPEK47rYrGW4rIJ31MBTuFs5Xmaw/SQYDIp?=
 =?us-ascii?Q?GTeFjal0mMrPF0F+dlkrRO5uRf9irmJz+E13bXrKIfHtxMzvAvlxzxnFAGjo?=
 =?us-ascii?Q?mXzGlLCvykaq4KEmdBJOD4PK4OM9olx8GjBypIVsNCx1CznBHZvhM5A1m5YL?=
 =?us-ascii?Q?ZyB3QC+/Gre5VNyFdhuSMQtnIVlkwigUwSf1j9NjeChFKTXd7K4/B/hPRMa7?=
 =?us-ascii?Q?XU8bgBRxNWBvhIyMeRQ3IaVbLBcl7O734I9D0RkV4LTul6ebVJ4h9s4JtbKx?=
 =?us-ascii?Q?CDx27lwSqItG36eMojY/u+ux7wm78BUNJbvaPx0kp/odVsYv4lI/6K1ajjmP?=
 =?us-ascii?Q?gKAOu5ilBDYqaWRtm2FivhJo5mlyJvTy+TvaGeo9Yk3kjjWGB6HQV63LoU+o?=
 =?us-ascii?Q?YF+yPTxyQDZIoI4os49NP8tgvMnS9fRQTXyA1cyeV1WamQW4eIXQ9SufosCw?=
 =?us-ascii?Q?L7XNF3jSwER7xay8v8Z46Fg1kCAsjn46YpMrZcRhsm/r69oYsuiqnU5C3g/R?=
 =?us-ascii?Q?v2dTFAh8nf4ZuhvQKY2o?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6e3b1ce-4bc6-4d46-15a7-08dbf957cec1
X-MS-Exchange-CrossTenant-AuthSource: SYBPR01MB6870.ausprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2023 08:12:53.2638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MEYPR01MB7339

This patch adds two architecture specific interfaces used by `perf kvm`:

- kvm_arch_vcpu_get_unwind_info: Return required data for unwinding
  at once; including ip address, frame pointer, whether the guest vCPU
  is running in 32 or 64 bits, and possibly the base addresses of
  the segments.

- kvm_arch_vcpu_read_virt: Read data from a virtual address of the
  guest vm.

`perf_kvm.h` has been added to the `include/linux/` directory to store
the interface structures between the perf events subsystem and the KVM
subsystem.

Since arm64 hasn't provided some foundational infrastructure, stub the
arm64 implementation for now because it's a bit complex.

The above interfaces require architecture support for
`CONFIG_GUEST_PERF_EVENTS`, which is only implemented by x86 and arm64
currently. For more architectures, they need to implement these interfaces
when enabling `CONFIG_GUEST_PERF_EVENTS`.

In terms of safety, guests are designed to be read-only in this feature,
and we will never inject page faults into the guests, ensuring that the
guests are not interfered by profiling. In extremely rare cases, if the
guest is modifying the page table, there is a possibility of reading
incorrect data. Additionally, if certain programs running in the guest OS
do not support frame pointers, it may also result in some erroneous data.
These erroneous data will eventually appear as `[unknown]` entries in the
report. It is sufficient as long as most of the records are correct for
profiling.

Signed-off-by: Tianyi Liu <i.pear@outlook.com>
---
 MAINTAINERS              |  1 +
 arch/arm64/kvm/arm.c     | 12 ++++++++++++
 arch/x86/kvm/x86.c       | 24 ++++++++++++++++++++++++
 include/linux/kvm_host.h |  5 +++++
 include/linux/perf_kvm.h | 18 ++++++++++++++++++
 5 files changed, 60 insertions(+)
 create mode 100644 include/linux/perf_kvm.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 788be9ab5b73..5ee36b4a9701 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16976,6 +16976,7 @@ F:	arch/*/kernel/*/perf_event*.c
 F:	arch/*/kernel/perf_callchain.c
 F:	arch/*/kernel/perf_event*.c
 F:	include/linux/perf_event.h
+F:	include/linux/perf_kvm.h
 F:	include/uapi/linux/perf_event.h
 F:	kernel/events/*
 F:	tools/lib/perf/
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e5f75f1f1085..5ae74b5c263a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -574,6 +574,18 @@ unsigned long kvm_arch_vcpu_get_ip(struct kvm_vcpu *vcpu)
 {
 	return *vcpu_pc(vcpu);
 }
+
+bool kvm_arch_vcpu_get_unwind_info(struct kvm_vcpu *vcpu, struct perf_kvm_guest_unwind_info *info)
+{
+	/* TODO: implement */
+	return false;
+}
+
+bool kvm_arch_vcpu_read_virt(struct kvm_vcpu *vcpu, gva_t addr, void *dest, unsigned int length)
+{
+	/* TODO: implement */
+	return false;
+}
 #endif
 
 static int kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2c924075f6f1..9341cd80f665 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13039,6 +13039,30 @@ unsigned long kvm_arch_vcpu_get_ip(struct kvm_vcpu *vcpu)
 	return kvm_rip_read(vcpu);
 }
 
+bool kvm_arch_vcpu_get_unwind_info(struct kvm_vcpu *vcpu, struct perf_kvm_guest_unwind_info *info)
+{
+	info->ip_pointer = kvm_rip_read(vcpu);
+	info->frame_pointer = kvm_register_read_raw(vcpu, VCPU_REGS_RBP);
+
+	info->is_guest_64bit = is_64_bit_mode(vcpu);
+	if (info->is_guest_64bit) {
+		info->segment_cs_base = 0;
+		info->segment_ss_base = 0;
+	} else {
+		info->segment_cs_base = get_segment_base(vcpu, VCPU_SREG_CS);
+		info->segment_ss_base = get_segment_base(vcpu, VCPU_SREG_SS);
+	}
+	return true;
+}
+
+bool kvm_arch_vcpu_read_virt(struct kvm_vcpu *vcpu, gva_t addr, void *dest, unsigned int length)
+{
+	struct x86_exception e;
+
+	/* Return true on success */
+	return kvm_read_guest_virt(vcpu, addr, dest, length, &e) == X86EMUL_CONTINUE;
+}
+
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 {
 	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4944136efaa2..6f5ff4209b0c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -41,6 +41,7 @@
 #include <linux/kvm_para.h>
 
 #include <linux/kvm_types.h>
+#include <linux/perf_kvm.h>
 
 #include <asm/kvm_host.h>
 #include <linux/kvm_dirty_ring.h>
@@ -1595,6 +1596,10 @@ static inline bool kvm_arch_intc_initialized(struct kvm *kvm)
 
 #ifdef CONFIG_GUEST_PERF_EVENTS
 unsigned long kvm_arch_vcpu_get_ip(struct kvm_vcpu *vcpu);
+bool kvm_arch_vcpu_get_unwind_info(struct kvm_vcpu *vcpu,
+				   struct perf_kvm_guest_unwind_info *info);
+bool kvm_arch_vcpu_read_virt(struct kvm_vcpu *vcpu, gva_t addr, void *dest,
+			     unsigned int length);
 
 void kvm_register_perf_callbacks(unsigned int (*pt_intr_handler)(void));
 void kvm_unregister_perf_callbacks(void);
diff --git a/include/linux/perf_kvm.h b/include/linux/perf_kvm.h
new file mode 100644
index 000000000000..e77eeebddabb
--- /dev/null
+++ b/include/linux/perf_kvm.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_PERF_KVM_H
+#define _LINUX_PERF_KVM_H
+
+/*
+ * Structures as interface between Perf Event and KVM subsystem.
+ * Add more members for new architectures if necessary.
+ */
+
+struct perf_kvm_guest_unwind_info {
+	unsigned long ip_pointer;
+	unsigned long frame_pointer;
+	bool is_guest_64bit;
+	unsigned long segment_cs_base;
+	unsigned long segment_ss_base;
+};
+
+#endif /* _LINUX_PERF_KVM_H */
-- 
2.34.1


