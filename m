Return-Path: <kvm+bounces-32052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E6DC9D276C
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 14:55:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CCFEFB2B6AE
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 13:52:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FB381CDFB4;
	Tue, 19 Nov 2024 13:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BLTtKSQe"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2071.outbound.protection.outlook.com [40.107.101.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87E81CCEE4;
	Tue, 19 Nov 2024 13:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732024277; cv=fail; b=rMDXaV1H+2ylBfgSNbFRdoN8XrfX4G+Vgp1ANYPLLVpNoOUw5gLx4YIe/nIeotDHzE9+okI/ETirTJDBNpQqDCwsS3gdJMtkVmKVrIojwqLiKpZZFSlbRFom6IybULI2zDEKPuJB8sb5ayBECF4AmKjssaBRlw3SCrS1FbEqP/I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732024277; c=relaxed/simple;
	bh=JzxTlO/48NOqwjFC/MNMi3qoxBvSB1kI20dZziGeaww=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WVcj7Nn4fVES3Huk3xOlKqZxA0GRSzcKR4tLcIH8iqnOPRZjMYFg+5u9yHK9USJi2gAUvWKSu8enr/v04+CrgobbHJ74AGEQmUK6kWh9tF+BOIkDCawWw4NM2WTsEC+7RQYZieO6FfSKRdireqotjqrN1wQPmXP3gXx+AhPSqs0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BLTtKSQe; arc=fail smtp.client-ip=40.107.101.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rp/ReBP7BDnYAZFtMmauF63QW1GrRiNxD3gQZCpryhVnXa1a0KpzSQiAwZvzQFzep+IFQukewPINs3A3BTkuAj83WitEzQrCDIzVWbO8Ndu7+kbYS7+wCjMFKmAG+C4XeN1fKucHXd9E48nhIau2RuD0DjqoMoUOH81/zoPJ3Or+pJnFptwA7ybIzs7TqpfgwLVKb6wbep7LUEmfjCe7l0JuI/mDiBTy4ohjzif6VoD/WYfxfKFUEnzWXbdzBWbjsXtg3l0CfYmLCgt0gUzvEGUkgf9R2viQsHn3xpa7kuJnY135vvDPqpk3zIuKq5/Cdzro5461A6RPGtU+v3QBGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dT4NgBFU1zlgbkwQRicff6IXpdR5Hlt2CihWa2ckXeY=;
 b=Yhq4DBQOqVQCZNMESKOxrgMG61czc8kWB6jRraSqAC/rxoEoGLNP7mAeu1QBCDpavOCQpaECE6PWc/RDiW/S0HRz770Z39pLzW5zLf/vkiJFQ7KYXPzezw29NZ7ib9VNcJ5rTj1H5s/5v3zRM4Ghv1L1oLeLiV7BOmTprkDBEn1RlQKDC4TvZjgk8/HbnkG79ifgOEiGq8r/hw63vY2uN+IMmvH4C2K6ZshPwVZ4P1f1sdgfvd0fGSiFrpE2+wyYk6bwJBKrbGf9IRHpRAQdureJJpLBwBuoQkbaoI1tokI+wfMnLsm7VjX9J+Lbpsdj0fukHoF5LisEH2zD3fhDDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.12) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dT4NgBFU1zlgbkwQRicff6IXpdR5Hlt2CihWa2ckXeY=;
 b=BLTtKSQeq0V77yJSxcKVD984bWJzclPn4Tz5jLM/lGH8mXzqsAXQymPrXNhpeD25FCgHShc7gsl8EI6mRhPNg+V6jVRjQzg6jWqxmGEW2DZTgwteVCC6JlZQEihIOwMiITYjGM4cuRvyBoPXdJPaQ3upKKWAWiAH+ktoahKpp6Y=
Received: from BL1P223CA0012.NAMP223.PROD.OUTLOOK.COM (2603:10b6:208:2c4::17)
 by MW4PR12MB7190.namprd12.prod.outlook.com (2603:10b6:303:225::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.14; Tue, 19 Nov
 2024 13:51:10 +0000
Received: from BN3PEPF0000B071.namprd04.prod.outlook.com
 (2603:10b6:208:2c4:cafe::bc) by BL1P223CA0012.outlook.office365.com
 (2603:10b6:208:2c4::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.23 via Frontend
 Transport; Tue, 19 Nov 2024 13:51:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.12)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.12 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.12; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.12) by
 BN3PEPF0000B071.mail.protection.outlook.com (10.167.243.116) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8158.14 via Frontend Transport; Tue, 19 Nov 2024 13:51:10 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 19 Nov
 2024 07:51:09 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<ashish.kalra@amd.com>, <bp@alien8.de>, <pankaj.gupta@amd.com>,
	<liam.merwick@oracle.com>, <dionnaglaze@google.com>
Subject: [PATCH v2 1/2] KVM: Introduce KVM_EXIT_COCO exit type
Date: Tue, 19 Nov 2024 07:35:12 -0600
Message-ID: <20241119133513.3612633-2-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241119133513.3612633-1-michael.roth@amd.com>
References: <20241119133513.3612633-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B071:EE_|MW4PR12MB7190:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b3eed21-5ece-4f01-3cf9-08dd08a13998
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KWZIJMKMemwXn4mWKNfb2sG03MBl0Am579ZeVG0pnd6R0IBHI+wsPjxPwhlF?=
 =?us-ascii?Q?RcOzrl+ju9BIcJVhVUG4lNJYQgGmNToDyr4sOW9SpmzDLXIp5SelI/vT1ePq?=
 =?us-ascii?Q?gbztgYeZ9sX/ikpn0nUxbtsno9nRGyIJIaHh7YxjrvMXVRsiIBCJ5tniBUm2?=
 =?us-ascii?Q?2wtLzx8+9QitMzLTy2FdSPzymPFX36hlwLARnDwk8Z1iG44CUOsKBFrBNpws?=
 =?us-ascii?Q?uPFaw69HLwQtTGo+rCnZcq5IuuNDJLvn3Clfj76LU9PYND5JlrQnSB7t+LuY?=
 =?us-ascii?Q?6nTlqqHqS0inGx/pFtnhXj7ReyyqwVtoNEt08ZshpSriUl/NBruuyTpoRyU2?=
 =?us-ascii?Q?vTcKkCVP0cKzJaEVoJAdctwaoK7FBFGlO8pQuwVRvWVLY4i6mzeZ4fSIWwxc?=
 =?us-ascii?Q?N9e65FNeAz6YN8yEtuqTkKzFOGK3g7JNjK/wxYFn8WASDLrBuE1e2/XuwBt1?=
 =?us-ascii?Q?fOhDQrt+JF1TtU9Iu7fUPug4jJcV0yQnIB1/A1Z71q6YDvaeeB1IkRZIv3hJ?=
 =?us-ascii?Q?MeM1NEWqLHvGxHM+0WUsmyIqvbxzg/8LGCi2tm/PGeFbuH+A0rmry5MSf5T1?=
 =?us-ascii?Q?XCIPs1iJVhjggANuTXj52OQvWsxu1xy8b7fqt8f3zyD9pSrBJVJ8dSYPl+BU?=
 =?us-ascii?Q?iBQG+6I8qtD2T5o6idkjK0elbGieoEnPRRXTQtgRmibtqn3xtlGOqK2o6vW4?=
 =?us-ascii?Q?wZCLQJfy1asrxThb+rLfr3Vf3hfudB/vsWdEyFznxNPFkZzFavDhdBNNTxsC?=
 =?us-ascii?Q?7F+Vs1haUxkqxejg9cddAiyvNpb2l8WlUno7U/rdcT2FWibYd2nt8PwQ/CFo?=
 =?us-ascii?Q?EM40FB8xOzkLPSMk6yEzAlHi26/2bV87FbxaqJdgSwLA+46wcyLgohsN7iqU?=
 =?us-ascii?Q?1Y/PcXEkg2uaBtD4hH79/B4L060pq/PgHMLw5VKur2hW0ofwvtYFsGQdn7jC?=
 =?us-ascii?Q?xBbeEp6a1sNG4SbBFy9Qiw03C0aEJQIoq7K+hbIW5znnRB8h6g3sGsWFfl9J?=
 =?us-ascii?Q?rhpvwW1oIdeQQVb/Chy2oVCJINRUt8nLOf8FeVxsZckF3hZ5I0QjBsFL5hFs?=
 =?us-ascii?Q?NljvUbKmXLjxU6vOVZpQ9l/pHOyEhwUTDHbYHxMsA1FpEm578f9zqBrRTkjE?=
 =?us-ascii?Q?MqsNbpZ84w/HxctByKBh5agYQkPJj7WM7IGXG9T+Uwq8HCLIadKFf0ryOzBm?=
 =?us-ascii?Q?93+U1qo6+ZKn8Hm8Vwg2WCxp6NKpWadJrPDUmliD4reG/BAuOBpOMTeL9Ty1?=
 =?us-ascii?Q?9jZ/gHqVtHZ2fqUfkFGsXycwAmcVIqTs074fwiAt43M0wqAv+TVGK4nu3ZMW?=
 =?us-ascii?Q?8ddjHgJq6UnsAaKWiDK1GHt86zmxg67JDMirOI4xvu+UGSjG2Gurpa28EDj5?=
 =?us-ascii?Q?hGE8McMmFjxISyfb/KK/tQCetTFLfTNDp9S9jFz+cb6RIGFnPQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.12;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:atlvpn-bp.amd.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2024 13:51:10.4732
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b3eed21-5ece-4f01-3cf9-08dd08a13998
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.12];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B071.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7190

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
individual sub-types, similarly to KVM_CAP_EXIT_HYPERCALL.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 Documentation/virt/kvm/api.rst  | 119 ++++++++++++++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |   1 +
 arch/x86/kvm/x86.c              |  13 ++++
 include/uapi/linux/kvm.h        |  19 +++++
 4 files changed, 152 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 454c2aaa155e..664fba2739a9 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7173,6 +7173,107 @@ Please note that the kernel is allowed to use the kvm_run structure as the
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
+			__u32 ret;
+			__u32 pad1;
+			union {
+				struct {
+					__u64 gfn;
+					__u32 npages;
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
+determine which union type should be used for input/output. If the exit is
+successfully processed by userspace, `ret` should be set to 0 to indicate
+success. A non-zero `ret` value will be treated as an error unless there is
+specific handling associated with a particular error code in the per-union
+type documentation.
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
+        ``ENOSPC``.
+
+      - If the certificate cannot be immediately provided, userspace should set
+	`ret` to ``EAGAIN``, which will inform the guest to retry the request
+	later. One scenario where this would be useful is if the certificate
+	is in the process of being updated and cannot be fetched until the
+	update completes (see the NOTE below regarding how file-locking can
+	be used to orchestrate such updates between management/guests).
+
+      - If some other error occurred, userspace must set `ret` to ``EIO``.
+
+    NOTE: In the case of SEV-SNP, the endorsement key used by firmware may
+    change as a result of management activities like updating SEV-SNP firmware
+    or loading new endorsement keys, so some care should be taken to keep the
+    returned certificate data in sync with the actual endorsement key in use by
+    firmware at the time the attestation request is sent to SNP firmware. The
+    recommended scheme to do this is to use file locking (e.g. via fcntl()'s
+    F_OFD_SETLK) in the following manner:
+
+      - The VMM should obtain a shared/read or exclusive/write lock on the path
+	the certificate blob file resides at before reading it and returning it
+	to KVM, and continue to hold the lock until the attestation request is
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
 
 .. _cap_enable:
 
@@ -9017,6 +9118,24 @@ Do not use KVM_X86_SW_PROTECTED_VM for "real" VMs, and especially not in
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
index e159e44a6a1b..1b4fb019023e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1438,6 +1438,7 @@ struct kvm_arch {
 	struct kvm_x86_msr_filter __rcu *msr_filter;
 
 	u32 hypercall_exit_enabled;
+	u64 coco_exit_enabled;
 
 	/* Guest can access the SGX PROVISIONKEY. */
 	bool sgx_provisioning_allowed;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2e713480933a..c9bcc39725e0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -128,6 +128,8 @@ static u64 __read_mostly cr4_reserved_bits = CR4_RESERVED_BITS;
 #define KVM_X2APIC_API_VALID_FLAGS (KVM_X2APIC_API_USE_32BIT_IDS | \
                                     KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK)
 
+#define KVM_EXIT_COCO_VALID_MASK BIT_ULL(KVM_EXIT_COCO_REQ_CERTS)
+
 static void update_cr8_intercept(struct kvm_vcpu *vcpu);
 static void process_nmi(struct kvm_vcpu *vcpu);
 static void __kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
@@ -4782,6 +4784,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_READONLY_MEM:
 		r = kvm ? kvm_arch_has_readonly_mem(kvm) : 1;
 		break;
+	case KVM_CAP_EXIT_COCO:
+		r = KVM_EXIT_COCO_VALID_MASK;
+		break;
 	default:
 		break;
 	}
@@ -6743,6 +6748,14 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		mutex_unlock(&kvm->lock);
 		break;
 	}
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
index 502ea63b5d2e..f64abda153cf 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -135,6 +135,21 @@ struct kvm_xen_exit {
 	} u;
 };
 
+struct kvm_exit_coco {
+#define KVM_EXIT_COCO_REQ_CERTS		0
+#define KVM_EXIT_COCO_MAX		1
+	__u8 nr;
+	__u8 pad0[7];
+	__u32 ret;
+	__u32 pad1;
+	union {
+		struct {
+			__u64 gfn;
+			__u32 npages;
+		} req_certs;
+	};
+};
+
 #define KVM_S390_GET_SKEYS_NONE   1
 #define KVM_S390_SKEYS_MAX        1048576
 
@@ -178,6 +193,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_NOTIFY           37
 #define KVM_EXIT_LOONGARCH_IOCSR  38
 #define KVM_EXIT_MEMORY_FAULT     39
+#define KVM_EXIT_COCO             40
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -446,6 +462,8 @@ struct kvm_run {
 			__u64 gpa;
 			__u64 size;
 		} memory_fault;
+		/* KVM_EXIT_COCO */
+		struct kvm_exit_coco coco;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -933,6 +951,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_PRE_FAULT_MEMORY 236
 #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
 #define KVM_CAP_X86_GUEST_MODE 238
+#define KVM_CAP_EXIT_COCO 239
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
-- 
2.25.1


