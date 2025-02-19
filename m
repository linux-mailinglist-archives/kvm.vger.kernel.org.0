Return-Path: <kvm+bounces-38583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CAE7A3C367
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 16:18:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F4DF1737E6
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 15:17:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D68C919D074;
	Wed, 19 Feb 2025 15:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="j8tLaNZD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2052.outbound.protection.outlook.com [40.107.92.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418AF15CD52;
	Wed, 19 Feb 2025 15:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739978249; cv=fail; b=TnNT7A9TIxu6DC7UxwI8y4WjJ/MpTW2y8Ib24Hn551bSYh6SeBuBsI6v5RPzVm5zEO4RYgEOE0B/lbcPuML4b1sR7jKdrBFQpUiW7q/ChUCJJsA70IPYbQ89987E1J9uU5xMRP+IiBEEppXFkllkuO5pxGoWCc6Sh2bYVgnS+V4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739978249; c=relaxed/simple;
	bh=GiD92QTI1lQCDhYLWVFvA0fobonex8emWTT1UBXUuXU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=buhVQFJpE+C+WSGQay/S9LDY42v7uJ8PXvJyKv0Md/NxfhC4F0tI9jDXhfaoiiLnvmYZ633QbXpqk9JLC6cJ/ubYKTSIHLAUPn5VXBHD/fk7jDrpwAGw8s1THty4LoBZK+hFS5Wl3MDB3nrGPgyPjEij8sUK8i85NTyEC04rvLk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=j8tLaNZD; arc=fail smtp.client-ip=40.107.92.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oOpbxy83fGk0baCYHg36JsM4AoQlqpwCoqDdoHan12sYP3KMI6vHfAsKup8cFWisEZWclqO5bsZFbqC7XP+q3b0y+gsKHphrcoN5s6uszyvyOnQDoqjNMyq9f9ds6aFaxDLKWFEPMF6FI/q13E3S8mEkObQuOA+IjElp9hnFX24W8OI6Hb1BaBeh4uLLty8zmeHZGfofPsYdrxsMMdn1Rsx94Ukkw5JPSNGJIqahnXRrJjnCjy4hQVQhFtc8XzY2eaDXas8pX//Rr/WRQ7IIOpSQbhWmpi2qz5w2TdcAPs83FDCUOP5SHaBRuC9SL3tb5Iv5tEwqWDyBAPhs3NoVHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FqzRAzkEnaUI7kyzohCGkImnRdhkz0y7C92/23/lPaE=;
 b=k2Lha3aMgNQ9RXG69nhgmCV8uSPNldsT6qIFN9wRg4MtmO6+SM+d1ZKHuUog+4Sv275KY+oEvPCSGwktc/KKXjzEsBcIAmvoL+uce2IPgWsNah/ZroDTI6bGyd0pk3c736jRDd3I1UR+DcUZEkJ2qs2zbX5J74ZtKjIBRW5+UOnvxbUGXOL0Ns5grYlJyuzl7y3cT7IA8tK4uvrLHDE0CvuljOo3d557Dq/9BlgJ0sY2aWKOsenafk7MHMmcoAVSvnEYk40DxrUvV0xuTJDnc9Lx8neZ0fsz1o3W0u3d4KrHxwY4pj8dF/KxoXarmyn2NCY8h5eNljuXIRh97Vi32Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FqzRAzkEnaUI7kyzohCGkImnRdhkz0y7C92/23/lPaE=;
 b=j8tLaNZDeZhRyil8J0spD0cb6RPwNgNJyURDusz+q4OfUNGx7qjRpq/n9P4Ikdn4taE6+RP/YKIkVSASgHKd1hsOIbFovQwWdyHdo1wJgwmuXJ+H6Tgl5tuK0NosfiKy4cd3KkNlVn7hqf2DoRlw4CImP7jjGbyzYR1TdSnBXqM=
Received: from CH2PR20CA0030.namprd20.prod.outlook.com (2603:10b6:610:58::40)
 by PH8PR12MB6674.namprd12.prod.outlook.com (2603:10b6:510:1c1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Wed, 19 Feb
 2025 15:17:18 +0000
Received: from CH1PEPF0000A34A.namprd04.prod.outlook.com
 (2603:10b6:610:58:cafe::e5) by CH2PR20CA0030.outlook.office365.com
 (2603:10b6:610:58::40) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.14 via Frontend Transport; Wed,
 19 Feb 2025 15:17:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000A34A.mail.protection.outlook.com (10.167.244.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8466.11 via Frontend Transport; Wed, 19 Feb 2025 15:17:18 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 19 Feb
 2025 09:17:17 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <ashish.kalra@amd.com>, <liam.merwick@oracle.com>,
	<pankaj.gupta@amd.com>, <dionnaglaze@google.com>, <huibo.wang@amd.com>
Subject: [PATCH v5 1/1] KVM: Introduce KVM_EXIT_SNP_REQ_CERTS for SNP certificate-fetching
Date: Wed, 19 Feb 2025 09:15:05 -0600
Message-ID: <20250219151505.3538323-2-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250219151505.3538323-1-michael.roth@amd.com>
References: <20250219151505.3538323-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A34A:EE_|PH8PR12MB6674:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cad47da-b0b2-4191-b14e-08dd50f88019
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7GjNTIn375Kg96xOksCZljPCwZS0nlyzpjiNsjE50ZGpiA3w1WoOJp+WbYre?=
 =?us-ascii?Q?eLRWfAfodr0FyRWFo5+cI484Bf+9jRwC+x4gI3LvG2CJ+M+oeriDEEICENdb?=
 =?us-ascii?Q?sBcTKXjO+DVh9RxGTxUen4ZroMnt+VYmBF4Ey0XiABEzcNaVVk18xLN6MYFJ?=
 =?us-ascii?Q?NKrTQY9RvKWbAJgg74vF6HZlWXnmJPCaxQimydD00Y7ORj6Qo1mXphQ96RRs?=
 =?us-ascii?Q?tFo3h0CZobM5IBRFTgMyVCS1jvskiMqxqH071K9MG4ozDq6tgXTyyVs+bhBf?=
 =?us-ascii?Q?m5sy9xgWwZhNPmIXqPdoWA64Yp4cDzUYGckzN/3mZEqNMlBli1FqnEb54xcW?=
 =?us-ascii?Q?rUdvOEv6vooAYujkvGGtgJ7jCr9FZHXE7ECQRf6VfVPJtGrFZf6K+9mDVA6u?=
 =?us-ascii?Q?q4zDmaYxdZsx2WMyl4xyzBzGtbQEwDK/kyAuznX34K+aDeQ3W3vMDDH4aOl2?=
 =?us-ascii?Q?1OuKnMrnmnjYoQgDTRtFMPlifmhiXQrMjFs44+VZCxbPlNsLN9xfVAjCzJV2?=
 =?us-ascii?Q?QAyCr9ZsT33DvQ0e3gnayvCqo+6ZHl32F276hPqKIO3tdsXRFHJ1oSbolHla?=
 =?us-ascii?Q?zHNMD71zAx10nGgpDezpTTcuYWLzPouJ3qmkIVkm0Hdoc1XgYfCieQhX9frg?=
 =?us-ascii?Q?qOFoK3rZKny34IJkHwnWRiM4zetoV90gRVo3ONaV6DRPf+Vu1NA5HrGP9Dad?=
 =?us-ascii?Q?r6jU1zV+pg0Gb1Z8HI5odvsah7iBGE7/ZZVee1ABPv4blcSW9Wf4y7IF9/1q?=
 =?us-ascii?Q?mFEKHw7TnrP69/zioNdhbjZEE8lsbU1eDcdF+s61SHF/vIiDMUeBn0y9YibR?=
 =?us-ascii?Q?tz6DBy3C7clcpL0L456u9c97U0Te9MZmuisnlO7LmdzPDdBCJjOJ2EYVezdG?=
 =?us-ascii?Q?JV9AgNMMG2CMI9dd0tBC9WZ151ZsPXjQWX0SHrl8gpx8q+l6wEey3BDwpcPI?=
 =?us-ascii?Q?Tu+qjlxn0OG5n2GClW3LEMbSL9NH8Sr2VxLvA0nlqDLZXZhXaWOGa7gLrlVQ?=
 =?us-ascii?Q?s16w2CuoM+9l4Gk2KeS0x5q6K2+bkw2zV2dfBV3m5bSSjqBSjU1HCqsj0dFH?=
 =?us-ascii?Q?aCULpzhwN7cZ2nqAoozhu7uTHN2ygc3aUkL6FuUEuWLL/Vb6d+tU7d4O8IJL?=
 =?us-ascii?Q?6Yai1Is4XzhgAKDsFP2FUgIHH3J6EoVDjqMFHbit9e/dVtbvgB+sxMrXXs3V?=
 =?us-ascii?Q?LiIGtveoNfvR1KHffyQPFBEzPMGkcUXAF7ojcGJPuQizgyk9LYgMdEwmdqQ1?=
 =?us-ascii?Q?c5i3JH9frLKlIY/HMGC0hKVn85zLbLp5owq5UR9SJeS9us9QC+m3nvGARh/j?=
 =?us-ascii?Q?RzJx5999uz65o49XbKNTgyiTXqC1635jhsZi/oLajF/Aanu6R7jU8vZ/31F2?=
 =?us-ascii?Q?Lt7rnUDAkawEMnWEvXMin/UqCf/+qSluiKenFi8idjzHhdKqL5GN8y2apIQl?=
 =?us-ascii?Q?gPLhCHWRViV9t3WyKjD77OolOceHhOVp3UzyMQzpeCa3NgxIz5Jx2v3sFuoW?=
 =?us-ascii?Q?jrbsx5r8k0f/kho=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2025 15:17:18.7132
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cad47da-b0b2-4191-b14e-08dd50f88019
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A34A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6674

For SEV-SNP, the host can optionally provide a certificate table to the
guest when it issues an attestation request to firmware (see GHCB 2.0
specification regarding "SNP Extended Guest Requests"). This certificate
table can then be used to verify the endorsement key used by firmware to
sign the attestation report.

While it is possible for guests to obtain the certificates through other
means, handling it via the host provides more flexibility in being able
to keep the certificate data in sync with the endorsement key throughout
host-side operations that might resulting in the endorsement key
changing.

In the case of KVM, userspace will be responsible for fetching the
certificate table and keeping it in sync with any modifications to the
endorsement key by other userspace management tools. Define a new
KVM_EXIT_SNP_REQ_CERTS event where userspace is provided with the GPA of
the buffer the guest has provided as part of the attestation request so
that userspace can write the certificate data into it while relying on
filesystem-based locking to keep the certificates up-to-date relative to
the endorsement keys installed/utilized by firmware at the time the
certificates are fetched.

Also introduce a KVM_CAP_EXIT_SNP_REQ_CERTS capability to enable/disable
the exit for cases where userspace does not support
certificate-fetching, in which case KVM will fall back to returning an
empty certificate table if the guest provides a buffer for it.

  [Melody: Update the documentation scheme about how file locking is
  expected to happen.]

Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
Tested-by: Liam Merwick <liam.merwick@oracle.com>
Tested-by: Dionna Glaze <dionnaglaze@google.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Melody Wang <huibo.wang@amd.com>
---
 Documentation/virt/kvm/api.rst  | 100 ++++++++++++++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |   1 +
 arch/x86/kvm/svm/sev.c          |  43 ++++++++++++--
 arch/x86/kvm/x86.c              |  11 ++++
 include/uapi/linux/kvm.h        |  10 ++++
 include/uapi/linux/sev-guest.h  |   8 +++
 6 files changed, 167 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 2b52eb77e29c..4d8aa274b65f 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7179,6 +7179,89 @@ Please note that the kernel is allowed to use the kvm_run structure as the
 primary storage for certain register types. Therefore, the kernel may use the
 values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
 
+::
+
+		/* KVM_EXIT_SNP_REQ_CERTS */
+		struct kvm_exit_snp_req_certs {
+			__u64 gfn;
+			__u32 npages;
+			__u32 ret;
+		};
+
+This event provides a way to request certificate data from userspace and
+have it written into guest memory. This is intended to handle attestation
+requests made by SEV-SNP guests (using the Extended Guest Requests GHCB
+command as defined by the GHCB 2.0 specification for SEV-SNP guests),
+where additional certificate data corresponding to the endorsement key
+used by firmware to sign an attestation report can be optionally provided
+by userspace to pass along to the guest together with the
+firmware-provided attestation report.
+
+KVM will supply in `gfn` the non-private guest page that userspace should
+use to write the contents of certificate data. The format of this
+certificate data is defined in the GHCB 2.0 specification (see section
+"SNP Extended Guest Request"). KVM will also supply in `npages` the
+number of contiguous pages available for writing the certificate data
+into.
+
+  - If the supplied number of pages is sufficient, userspace must write
+    the certificate table blob (in the format defined by the GHCB spec)
+    into the address corresponding to `gfn` and set `ret` to 0 to indicate
+    success. If no certificate data is available, then userspace can
+    either write an empty certificate table into the address corresponding
+    to `gfn`, or it can disable ``KVM_EXIT_SNP_REQ_CERTS`` (via
+    ``KVM_CAP_EXIT_SNP_REQ_CERTS``), in which case KVM will handle
+    returning an empty certificate table to the guest.
+
+  - If the number of pages supplied is not sufficient, userspace must set
+    the required number of pages in `npages` and then set `ret` to
+    ``ENOSPC``.
+
+  - If the certificate cannot be immediately provided, userspace should set
+    `ret` to ``EAGAIN``, which will inform the guest to retry the request
+    later. One scenario where this would be useful is if the certificate
+    is in the process of being updated and cannot be fetched until the
+    update completes (see the NOTE below regarding how file-locking can
+    be used to orchestrate such updates between management/guests).
+
+  - If some other error occurred, userspace must set `ret` to ``EIO``.
+    (This is to reserve special meaning for unused error codes in the
+    future.)
+
+NOTE: The endorsement key used by firmware may change as a result of
+management activities like updating SEV-SNP firmware or loading new
+endorsement keys, so some care should be taken to keep the returned
+certificate data in sync with the actual endorsement key in use by
+firmware at the time the attestation request is sent to SNP firmware. The
+recommended scheme to do this is to use file locking (e.g. via fcntl()'s
+F_OFD_SETLK) in the following manner:
+
+  - The VMM should obtain a shared/read or exclusive/write lock on the
+  certificate blob file before reading it and returning it to KVM, and
+  continue to hold the lock until the attestation request is actually
+  sent to firmware. To facilitate this, the VMM can set the
+  ``immediate_exit`` flag of kvm_run just after supplying the
+  certificate data, and just before and resuming the vCPU. This will
+  ensure the vCPU will exit again to userspace with ``-EINTR`` after
+  it finishes fetching the attestation request from firmware, at which
+  point the VMM can safely drop the file lock.
+
+  - Tools/libraries that perform updates to SNP firmware TCB values or
+    endorsement keys (e.g. via /dev/sev interfaces such as ``SNP_COMMIT``,
+    ``SNP_SET_CONFIG``, or ``SNP_VLEK_LOAD``, see
+    Documentation/virt/coco/sev-guest.rst for more details) in such a way
+    that the certificate blob needs to be updated, should similarly take an
+    exclusive lock on the certificate blob for the duration of any updates
+    to endorsement keys or the certificate blob contents to ensure that
+    VMMs using the above scheme will not return certificate blob data that
+    is out of sync with the endorsement key used by firmware.
+
+This scheme is recommended so that tools could naturally opt to use
+it rather than every service provider coming up with a different solution
+that they will need to work into some custom QEMU/VMM (or other related
+management tools that handle firmware updates/configuration) to solve the
+same problem, but userspace will need to ensure all such tools are using
+this scheme in order for it to work as intended.
 
 .. _cap_enable:
 
@@ -9024,6 +9107,23 @@ Do not use KVM_X86_SW_PROTECTED_VM for "real" VMs, and especially not in
 production.  The behavior and effective ABI for software-protected VMs is
 unstable.
 
+8.42 KVM_CAP_EXIT_SNP_REQ_CERTS
+-------------------------------
+
+:Capability: KVM_CAP_EXIT_SNP_REQ_CERTS
+:Architectures: x86
+:Type: vm
+
+This capability, if enabled, will cause KVM to exit to userspace with
+KVM_EXIT_SNP_REQ_CERTS exit reason to allow for fetching SNP attestation
+certificates from userspace.
+
+Calling KVM_CHECK_EXTENSION for this capability will return a non-zero
+value to indicate KVM support for KVM_EXIT_SNP_REQ_CERTS.
+
+The 1st argument to KVM_ENABLE_CAP should be 1 to indicate userspace support
+for handling this event.
+
 9. Known KVM API problems
 =========================
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0b7af5902ff7..8b11d1a64378 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1459,6 +1459,7 @@ struct kvm_arch {
 	struct kvm_x86_msr_filter __rcu *msr_filter;
 
 	u32 hypercall_exit_enabled;
+	bool snp_certs_enabled;
 
 	/* Guest can access the SGX PROVISIONKEY. */
 	bool sgx_provisioning_allowed;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0dbb25442ec1..a18e8eed533b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4088,6 +4088,30 @@ static int snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_
 	return ret;
 }
 
+static int snp_complete_req_certs(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb_control_area *control = &svm->vmcb->control;
+
+	if (vcpu->run->snp_req_certs.ret) {
+		if (vcpu->run->snp_req_certs.ret == ENOSPC) {
+			vcpu->arch.regs[VCPU_REGS_RBX] = vcpu->run->snp_req_certs.npages;
+			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
+						SNP_GUEST_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN, 0));
+		} else if (vcpu->run->snp_req_certs.ret == EAGAIN) {
+			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
+						SNP_GUEST_ERR(SNP_GUEST_VMM_ERR_BUSY, 0));
+		} else {
+			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
+						SNP_GUEST_ERR(SNP_GUEST_VMM_ERR_GENERIC, 0));
+		}
+
+		return 1; /* resume guest */
+	}
+
+	return snp_handle_guest_req(svm, control->exit_info_1, control->exit_info_2);
+}
+
 static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)
 {
 	struct kvm *kvm = svm->vcpu.kvm;
@@ -4103,12 +4127,10 @@ static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t r
 	/*
 	 * As per GHCB spec, requests of type MSG_REPORT_REQ also allow for
 	 * additional certificate data to be provided alongside the attestation
-	 * report via the guest-provided data pages indicated by RAX/RBX. The
-	 * certificate data is optional and requires additional KVM enablement
-	 * to provide an interface for userspace to provide it, but KVM still
-	 * needs to be able to handle extended guest requests either way. So
-	 * provide a stub implementation that will always return an empty
-	 * certificate table in the guest-provided data pages.
+	 * report via the guest-provided data pages indicated by RAX/RBX. If
+	 * userspace enables KVM_EXIT_SNP_REQ_CERTS, then exit to userspace
+	 * to fetch the certificate data. Otherwise, return an empty certificate
+	 * table in the guest-provided data pages.
 	 */
 	if (msg_type == SNP_MSG_REPORT_REQ) {
 		struct kvm_vcpu *vcpu = &svm->vcpu;
@@ -4124,6 +4146,15 @@ static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t r
 		if (!PAGE_ALIGNED(data_gpa))
 			goto request_invalid;
 
+		if (vcpu->kvm->arch.snp_certs_enabled) {
+			vcpu->run->exit_reason = KVM_EXIT_SNP_REQ_CERTS;
+			vcpu->run->snp_req_certs.gfn = gpa_to_gfn(data_gpa);
+			vcpu->run->snp_req_certs.npages = data_npages;
+			vcpu->run->snp_req_certs.ret = 0;
+			vcpu->arch.complete_userspace_io = snp_complete_req_certs;
+			return 0; /* fetch certs from userspace */
+		}
+
 		/*
 		 * As per GHCB spec (see "SNP Extended Guest Request"), the
 		 * certificate table is terminated by 24-bytes of zeroes.
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 02159c967d29..67ff4a89ac81 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4774,6 +4774,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_READONLY_MEM:
 		r = kvm ? kvm_arch_has_readonly_mem(kvm) : 1;
 		break;
+	case KVM_CAP_EXIT_SNP_REQ_CERTS:
+		r = 1;
+		break;
 	default:
 		break;
 	}
@@ -6734,6 +6737,14 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		mutex_unlock(&kvm->lock);
 		break;
 	}
+	case KVM_CAP_EXIT_SNP_REQ_CERTS:
+		if (cap->args[0] != 1) {
+			r = -EINVAL;
+			break;
+		}
+		kvm->arch.snp_certs_enabled = true;
+		r = 0;
+		break;
 	default:
 		r = -EINVAL;
 		break;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 45e6d8fca9b9..83c4e6929df7 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -135,6 +135,12 @@ struct kvm_xen_exit {
 	} u;
 };
 
+struct kvm_exit_snp_req_certs {
+	__u64 gfn;
+	__u32 npages;
+	__u32 ret;
+};
+
 #define KVM_S390_GET_SKEYS_NONE   1
 #define KVM_S390_SKEYS_MAX        1048576
 
@@ -178,6 +184,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_NOTIFY           37
 #define KVM_EXIT_LOONGARCH_IOCSR  38
 #define KVM_EXIT_MEMORY_FAULT     39
+#define KVM_EXIT_SNP_REQ_CERTS    40
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -446,6 +453,8 @@ struct kvm_run {
 			__u64 gpa;
 			__u64 size;
 		} memory_fault;
+		/* KVM_EXIT_SNP_REQ_CERTS */
+		struct kvm_exit_snp_req_certs snp_req_certs;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -929,6 +938,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_PRE_FAULT_MEMORY 236
 #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
 #define KVM_CAP_X86_GUEST_MODE 238
+#define KVM_CAP_EXIT_SNP_REQ_CERTS 239
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
diff --git a/include/uapi/linux/sev-guest.h b/include/uapi/linux/sev-guest.h
index fcdfea767fca..4c4ed8bc71d7 100644
--- a/include/uapi/linux/sev-guest.h
+++ b/include/uapi/linux/sev-guest.h
@@ -95,5 +95,13 @@ struct snp_ext_report_req {
 
 #define SNP_GUEST_VMM_ERR_INVALID_LEN	1
 #define SNP_GUEST_VMM_ERR_BUSY		2
+/*
+ * The GHCB spec essentially states that all non-zero error codes other than
+ * those explicitly defined above should be treated as an error by the guest.
+ * Define a generic error to cover that case, and choose a value that is not
+ * likely to overlap with new explicit error codes should more be added to
+ * the GHCB spec later.
+ */
+#define SNP_GUEST_VMM_ERR_GENERIC       ((u32)~0U)
 
 #endif /* __UAPI_LINUX_SEV_GUEST_H_ */
-- 
2.25.1


