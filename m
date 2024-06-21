Return-Path: <kvm+bounces-20281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A113D9126EC
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 15:45:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 313E81F26FF8
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 13:45:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66E2F374DD;
	Fri, 21 Jun 2024 13:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="z9BmFa+i"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2055.outbound.protection.outlook.com [40.107.243.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C370C2BB05;
	Fri, 21 Jun 2024 13:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718977503; cv=fail; b=Y9DYbmSIChYnHGIEJ7QXyMaARg5GM5qoCZOn/kUqpjWWh6gvhEKfbusLBSTwiT9tzPQeIGeG+b1Za3yAh1rIZsBDpgO9rkZymLl0yhdcaYTpwC5O3Y+cXYxLIlLZDEcYCUrvCP7abNU/3XJ2RMTCvDzog/Je8PGsELRiOddT3EA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718977503; c=relaxed/simple;
	bh=p0Fl43iD/jg4aikoF7FA7LLjLiCdQe1TQOIuHhw9LWE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KIYPnPVK5++IjC7tYjJa0edhcv8/3WDQhcvv2Bt4X1UiS07qQ4Zx6fSL8extOKY3s+jht/6v+6Tip0ZWzL7q95TqjP2ipp7NLkrQO4DRC1OczacUEWb0levM9nBxvNrc3OmCgIGFZNIXQHoatjatnYofXQp8WOPFWzGQdfJ5MMU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=z9BmFa+i; arc=fail smtp.client-ip=40.107.243.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ey1/3ly8LFwKxpNol3rQaG048BZt6qSjdMzIhnBMapXD7l26oYKDw7HIRedU31LW7WArXqH5jD5rQ3Cv56y/bsbu8GJLcXZgqo/wZPtVhq4avKrwqmvjgokIaX0/2MRMQGE4LotrnpL0z05UL+tg6D3FRTXJLAuyR9RACTxOddJEDZkL95i+9uedibyQuTNgCUkALiYjjaKr3zUChPhVyMfxZYukUZ5Qjjiif9CPd2T6Y57cxI2WTHBvgqPjZsracoXyFMraAYCR3wLSP/WveN8HmyEuw56FApguoaxMHGNt2K7BqNEUs1HucLnN+S1EtlT6qxHHiIDQc2VTab8dZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1rFHjJ7FA6xCIfBuTgTQX3oWquuruZMWrjWs98o694E=;
 b=Ae3+2w5YHFkvr4wCPEabGhgMdhIUAMIZz7q7nkGFy/ez7zOOfKaFYLmX+GmFyeASWWTg4Y+FD7wDZgWGuzBG7G989lxpYlZMx42n+hhoQPeJ+CNKfnZhJFdC6kQWn6FHihaFINLMBpSgpSqngS/xLcSoN7flqpNVktr45EU5/btUZGMCVRTi7NJLFAaE7DLjx/xSiEdjxF/bpHuzf2oSqI81SzoUpHK6/vAAzhk5D+6BtBVTFxy0JuNTfR+Q0dy/j2aqULf3AXmoTDDMoa9UeBnzQKiLL+VPWizBM307YWVKvV4BRjpfIaqSGhIAga3Z8lhOwAfHWLkl5x5Ll49oJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1rFHjJ7FA6xCIfBuTgTQX3oWquuruZMWrjWs98o694E=;
 b=z9BmFa+ifGogN9f3P/lxrVIeL3nIGBv/B20gCpkxYzVtBs5E4kBpI4QCo9bPfIYW/1XBkWmk08lOus/b1kcvA7bgyfVemBgxi6s71WO2ldswi42U3r5ykL+aKaaAHMKGxIAWSvKH7SFOrrax5SC126cNR3BFPd7KPykyBGCx8vo=
Received: from DS0PR17CA0002.namprd17.prod.outlook.com (2603:10b6:8:191::25)
 by LV2PR12MB5942.namprd12.prod.outlook.com (2603:10b6:408:171::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Fri, 21 Jun
 2024 13:44:58 +0000
Received: from CY4PEPF0000EE38.namprd03.prod.outlook.com
 (2603:10b6:8:191:cafe::8d) by DS0PR17CA0002.outlook.office365.com
 (2603:10b6:8:191::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.37 via Frontend
 Transport; Fri, 21 Jun 2024 13:44:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE38.mail.protection.outlook.com (10.167.242.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Fri, 21 Jun 2024 13:44:58 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 21 Jun
 2024 08:44:57 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<ashish.kalra@amd.com>, <bp@alien8.de>, <pankaj.gupta@amd.com>,
	<liam.merwick@oracle.com>
Subject: [PATCH v1 4/5] KVM: Introduce KVM_EXIT_COCO exit type
Date: Fri, 21 Jun 2024 08:40:40 -0500
Message-ID: <20240621134041.3170480-5-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240621134041.3170480-1-michael.roth@amd.com>
References: <20240621134041.3170480-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE38:EE_|LV2PR12MB5942:EE_
X-MS-Office365-Filtering-Correlation-Id: 29723535-fb6f-4043-ab0c-08dc91f8574e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|82310400023|376011|36860700010|1800799021|7416011;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VVClA9Ep78FcsYkE6UvoAwyCh/9+AoPSDfG2gHiZ2Lm/B069Im802/qamTdu?=
 =?us-ascii?Q?CdiAEewDKCgLyQNbFFzdwJPLhN4Igyj+hGld3YrKQaLdARWtokdvRQA0yMAb?=
 =?us-ascii?Q?F8UeiZ2/wVtL91RDgH/GPaXdLD0b3/smHrMkrupDNAYtPmYl7M2jvgKv890J?=
 =?us-ascii?Q?LJi2HnmvPaZcRe/G8GvlSQijbBKvK/rt1PmFhz8dQYboNQxE0eH7U/AMiiZI?=
 =?us-ascii?Q?RExPGA0YPlxlNs9IP4fwDQsFS/ZzT6nIiuXdPqggT8cLm+mcWO2X7vgAIvP+?=
 =?us-ascii?Q?C/F+cC7VGYTSOYlFhy7lg+DD5sBJkDoNkkBx/PlKLoLR5RyQ8BIoCX/AbANS?=
 =?us-ascii?Q?0Uth00R6Cbeb6KIChfKi2NgLH1LTZQlCCnk126AI/99mSiK751pVS4PMDgtJ?=
 =?us-ascii?Q?XcnpaqEwazere78xB+WC/REIj9+15ec+S/xF31GhbFrWa8kIngljSW24tpUF?=
 =?us-ascii?Q?e1ZXvIZYwZ/JKckGhcSmw4+BwnN2k2jpjXbwKwkauc49hVmhatBhuDAhFDmO?=
 =?us-ascii?Q?rQgQ1hrpFAhEWM0u4M2RmH541F1xhgWJl+m9+Bug6LbUeZ7U3L2oHLAbmGV/?=
 =?us-ascii?Q?i3H5FcSOPjHg6F+SZBvWOe3UBse7hSrhxMkH8HKYb3AaTr6JmbBvyYbJBdqV?=
 =?us-ascii?Q?Zg92JRiJ5bv3TjpCbtUxtMMrIh9Z/ea3posgabakmLPIXQRE4rQMPdIMFpPE?=
 =?us-ascii?Q?6adIEH1Hp8ZoYze+1lP2Ir7QCr/1tWx3zT2/QAa32pqNjG5xyj2ANSyiCg8B?=
 =?us-ascii?Q?TL88DLYLU1wsXLCWXQqRiEr3sVfPdKrpb4HfFP71863QY6icAqnK4rwt4sVF?=
 =?us-ascii?Q?qSNO/N2EpKR3ZaeDpfVkMSuPTbI/2Qe4Or+Jr2TDWh4r/Q54jBCRSMcAfRU6?=
 =?us-ascii?Q?V9qId7PfXPIoxlxXHSZT7dLTKu+UTyiZm6+P1oryA3hvP3xvao71X45M0V4l?=
 =?us-ascii?Q?Hgo0mKWnAhkzr9+YEVgJ2LG7nAF9UFF+lht03RsIEC262NbyYfuI1wIDnq7m?=
 =?us-ascii?Q?VfxPfWXGXFrC+8lsS1kq2wT4HNqTazHKC54CsOlMLoCjvBTlTgF2Aobz+5jK?=
 =?us-ascii?Q?JoX9cd5fUhR4BH983Fyy400FNiO96plB36AcRZvKKD1uzCx0SNF90DYOWa/n?=
 =?us-ascii?Q?R59df7e39nUwEDk6unAbG5yTcTW+5vbooLevFv4hTJVj8K6uz9yVXG9QuA7M?=
 =?us-ascii?Q?wywe7s2X6MhJ1i2ZL7O5LJTVFK13yEUJf4/X7De75KzlAXB6rNGxpVnz2Oxn?=
 =?us-ascii?Q?ZZlxbtVzJH/CMp2pU1+LBKE/8zJcIL5lcySzC+0Dxg4OEIWWZfxXJcc3JCoU?=
 =?us-ascii?Q?BbTbwMJ7Vg4c538PATaL+XTRiQ/xRgjhIdWU3zsqBMEIonBHfS7K92PqdSP4?=
 =?us-ascii?Q?DUpz7H7ODa5K/nTDl9L1KzoEkuz2z6pACxPa1skQ8R6WOE0yTQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230037)(82310400023)(376011)(36860700010)(1800799021)(7416011);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 13:44:58.1208
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 29723535-fb6f-4043-ab0c-08dc91f8574e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE38.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5942

Confidential VMs have a number of additional requirements on the host
side which might involve interactions with userspace. One such case is
with SEV-SNP guests, where the host can optionally provide a certificate
table to the guest when it issues an attestation request to firmware
(see GHCB 2.0 specification regarding "SNP Extended Guest Requests").
This certificate table can then be used to verify the endorsement key
used by firmware to sign the attestation report.

While it is possible for guests to obtain the certificates through other
means, handling it via the host provides more flexibility in being able
to keep the certificate data in sync with the endorsement key throughout
host-side operations that might resulting in the endorsement key
changing.

In the case of KVM, userspace will be responsible for fetching the
certificate table and keeping it in sync with any modifications to the
endorsement key. Define a new KVM_EXIT_* event where userspace is
provided with the GPA of the buffer the guest has provided as part of
the attestation request so that userspace can write the certificate data
into it.

Since there is potential for additional CoCo-related events in the
future, introduce this in the form of a more general KVM_EXIT_COCO exit
type that handles multiple sub-types, similarly to KVM_EXIT_HYPERCALL,
and then define a KVM_EXIT_COCO_REQ_CERTS sub-type to handle the actual
certificate-fetching mentioned above.

Also introduce a KVM_CAP_EXIT_COCO capability to enable/disable
individual sub-types, similarly to KVM_CAP_EXIT_HYPERCALL. Since actual
support for KVM_EXIT_COCO_REQ_CERTS will be enabled in a subsequent
patch, don't yet allow it to be enabled.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 Documentation/virt/kvm/api.rst  | 109 ++++++++++++++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |   1 +
 arch/x86/kvm/x86.c              |  13 ++++
 include/uapi/linux/kvm.h        |  20 ++++++
 4 files changed, 143 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index ecfa25b505e7..2eea9828d9aa 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7122,6 +7122,97 @@ Please note that the kernel is allowed to use the kvm_run structure as the
 primary storage for certain register types. Therefore, the kernel may use the
 values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
 
+::
+
+		/* KVM_EXIT_COCO */
+		struct kvm_exit_coco {
+		#define KVM_EXIT_COCO_REQ_CERTS			0
+		#define KVM_EXIT_COCO_MAX			1
+			__u8 nr;
+			__u8 pad0[7];
+			union {
+				struct {
+					__u64 gfn;
+					__u32 npages;
+		#define KVM_EXIT_COCO_REQ_CERTS_ERR_INVALID_LEN		1
+		#define KVM_EXIT_COCO_REQ_CERTS_ERR_GENERIC		(1 << 31)
+					__u32 ret;
+				} req_certs;
+			};
+		};
+
+KVM_EXIT_COCO events are intended to handle cases where a confidential
+VM requires some action on the part of userspace, or cases where userspace
+needs to be informed of some activity relating to a confidential VM.
+
+A `kvm_exit_coco` structure is defined to encapsulate the data to be sent to
+or returned by userspace. The `nr` field defines the specific type of event
+that needs to be serviced, and that type is used as a discriminator to
+determine which union type should be used for input/output.
+
+The parameters for each of these event/union types are documented below:
+
+  - ``KVM_EXIT_COCO_REQ_CERTS``
+
+    This event provides a way to request certificate data from userspace and
+    have it written into guest memory. This is intended primarily to handle
+    attestation requests made by SEV-SNP guests (using the Extended Guest
+    Requests GHCB command as defined by the GHCB 2.0 specification for SEV-SNP
+    guests), where additional certificate data corresponding to the
+    endorsement key used by firmware to sign an attestation report can be
+    optionally provided by userspace to pass along to the guest together with
+    the firmware-provided attestation report.
+
+    In the case of ``KVM_EXIT_COCO_REQ_CERTS`` events, the `req_certs` union
+    type is used. KVM will supply in `gfn` the non-private guest page that
+    userspace should use to write the contents of certificate data. In the
+    case of SEV-SNP, the format of this certificate data is defined in the
+    GHCB 2.0 specification (see section "SNP Extended Guest Request"). KVM
+    will also supply in `npages` the number of contiguous pages available
+    for writing the certificate data into.
+
+      - If the supplied number of pages is sufficient, userspace must write
+        the certificate table blob (in the format defined by the GHCB spec)
+        into the address corresponding to `gfn` and set `ret` to 0 to indicate
+        success. If no certificate data is available, then userspace can
+        either write an empty certificate table into the address corresponding
+        to `gfn`, or it can disable ``KVM_EXIT_COCO_REQ_CERTS`` (via
+        ``KVM_CAP_EXIT_COCO``), in which case KVM will handle returning an
+        empty certificate table to the guest.
+
+      - If the number of pages supplied is not sufficient, userspace must set
+        the required number of pages in `npages` and then set `ret` to
+        ``KVM_EXIT_COCO_REQ_CERTS_ERR_INVALID_LEN``.
+
+      - If some other error occurred, userspace must set `ret` to
+        ``KVM_EXIT_COCO_REQ_CERTS_ERR_GENERIC``.
+
+    NOTE: In the case of SEV-SNP, the endorsement key used by firmware may
+    change as a result of management activities like updating SEV-SNP firmware
+    or loading new endorsement keys, so some care should be taken to keep the
+    returned certificate data in sync with the actual endorsement key in use by
+    firmware at the time the attestation request is sent to SNP firmware. The
+    recommended scheme to do this is:
+
+      - The VMM should obtain a shared or exclusive lock on the path the
+        certificate blob file resides at before reading it and returning it to
+        KVM, and continue to hold the lock until the attestation request is
+        actually sent to firmware. To facilitate this, the VMM can set the
+        ``immediate_exit`` flag of kvm_run just after supplying the certificate
+        data, and just before and resuming the vCPU. This will ensure the vCPU
+        will exit again to userspace with ``-EINTR`` after it finishes fetching
+        the attestation request from firmware, at which point the VMM can
+        safely drop the file lock.
+
+      - Tools/libraries that perform updates to SNP firmware TCB values or
+        endorsement keys (e.g. via /dev/sev interfaces such as ``SNP_COMMIT``,
+        ``SNP_SET_CONFIG``, or ``SNP_VLEK_LOAD``, see
+        Documentation/virt/coco/sev-guest.rst for more details) in such a way
+        that the certificate blob needs to be updated, should similarly take an
+        exclusive lock on the certificate blob for the duration of any updates
+        to endorsement keys or the certificate blob contents to ensure that
+        VMMs using the above scheme will not return certificate blob data that
+        is out of sync with the endorsement key used by firmware.
 
 6. Capabilities that can be enabled on vCPUs
 ============================================
@@ -8895,6 +8986,24 @@ Do not use KVM_X86_SW_PROTECTED_VM for "real" VMs, and especially not in
 production.  The behavior and effective ABI for software-protected VMs is
 unstable.
 
+8.42 KVM_CAP_EXIT_COCO
+----------------------
+
+:Capability: KVM_CAP_EXIT_COCO
+:Architectures: x86
+:Type: vm
+
+This capability, if enabled, will cause KVM to exit to userspace with
+KVM_EXIT_COCO exit reason to process certain events related to confidential
+guests.
+
+Calling KVM_CHECK_EXTENSION for this capability will return a bitmask of
+KVM_EXIT_COCO event types that can be configured to exit to userspace.
+
+The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
+of the result of KVM_CHECK_EXTENSION.  KVM will forward to userspace
+the event types whose corresponding bit is in the argument.
+
 9. Known KVM API problems
 =========================
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index cef323c801f2..4b90208f9df0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1429,6 +1429,7 @@ struct kvm_arch {
 	struct kvm_x86_msr_filter __rcu *msr_filter;
 
 	u32 hypercall_exit_enabled;
+	u64 coco_exit_enabled;
 
 	/* Guest can access the SGX PROVISIONKEY. */
 	bool sgx_provisioning_allowed;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a6968eadd418..94c3a82b02c7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -125,6 +125,8 @@ static u64 __read_mostly cr4_reserved_bits = CR4_RESERVED_BITS;
 #define KVM_X2APIC_API_VALID_FLAGS (KVM_X2APIC_API_USE_32BIT_IDS | \
                                     KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK)
 
+#define KVM_EXIT_COCO_VALID_MASK 0
+
 static void update_cr8_intercept(struct kvm_vcpu *vcpu);
 static void process_nmi(struct kvm_vcpu *vcpu);
 static void __kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
@@ -4826,6 +4828,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_VM_TYPES:
 		r = kvm_caps.supported_vm_types;
 		break;
+	case KVM_CAP_EXIT_COCO:
+		r = KVM_EXIT_COCO_VALID_MASK;
+		break;
 	default:
 		break;
 	}
@@ -6748,6 +6753,14 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 		mutex_unlock(&kvm->lock);
 		break;
+	case KVM_CAP_EXIT_COCO:
+		if (cap->args[0] & ~KVM_EXIT_COCO_VALID_MASK) {
+			r = -EINVAL;
+			break;
+		}
+		kvm->arch.coco_exit_enabled = cap->args[0];
+		r = 0;
+		break;
 	default:
 		r = -EINVAL;
 		break;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index e5af8c692dc0..8a3a76679224 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -135,6 +135,22 @@ struct kvm_xen_exit {
 	} u;
 };
 
+struct kvm_exit_coco {
+#define KVM_EXIT_COCO_REQ_CERTS		0
+#define KVM_EXIT_COCO_MAX		1
+	__u8 nr;
+	__u8 pad0[7];
+	union {
+		struct {
+			__u64 gfn;
+			__u32 npages;
+#define KVM_EXIT_COCO_REQ_CERTS_ERR_INVALID_LEN		1
+#define KVM_EXIT_COCO_REQ_CERTS_ERR_GENERIC		(1 << 31)
+			__u32 ret;
+		} req_certs;
+	};
+};
+
 #define KVM_S390_GET_SKEYS_NONE   1
 #define KVM_S390_SKEYS_MAX        1048576
 
@@ -178,6 +194,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_NOTIFY           37
 #define KVM_EXIT_LOONGARCH_IOCSR  38
 #define KVM_EXIT_MEMORY_FAULT     39
+#define KVM_EXIT_COCO             40
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -433,6 +450,8 @@ struct kvm_run {
 			__u64 gpa;
 			__u64 size;
 		} memory_fault;
+		/* KVM_EXIT_COCO */
+		struct kvm_exit_coco coco;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -918,6 +937,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_GUEST_MEMFD 234
 #define KVM_CAP_VM_TYPES 235
 #define KVM_CAP_PRE_FAULT_MEMORY 236
+#define KVM_CAP_EXIT_COCO 237
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
-- 
2.25.1


