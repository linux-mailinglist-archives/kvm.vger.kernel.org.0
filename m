Return-Path: <kvm+bounces-36077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62D0CA1746F
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 22:59:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 64BC63A49E5
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 21:59:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BC011F0E21;
	Mon, 20 Jan 2025 21:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qfAuTrb6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2053.outbound.protection.outlook.com [40.107.94.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591861EEA5F;
	Mon, 20 Jan 2025 21:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737410341; cv=fail; b=Ewg8QJ07Knh2CqfAGeL4HlexXymHQT4zsISdpvJH7TjNxX9Hl+ugcizyOl1KTX1VpLozeoEBjwuEP89DqvsjSVQnrozVdkjJ+phXg5pE5dm1vPwFDtGZJ5puwMG3CSFcoI0pAJWyNo2viFk2p48YLzoAM/vmoWnPO1EDUWUV6Y4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737410341; c=relaxed/simple;
	bh=b/OLMe+FYW+hkZOERR+pNvn9uQCgFMyQ4DpQoPpGrWk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hMVXkv8ezn/BQBNymUr/sUEMlTnIfG3nrxsRu3YFPkaT2E0aRqtd8ALzwfBXfGjR44GOkjgi17ePxXjQebruKh51c/C1XolHATCsSDctVAaYF/wiCFQkX8QH2cPc9xt3Fj+zwAlx6lk2pWw6LJhm/C23jxHFPQDAqhjod7dyqbM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=qfAuTrb6; arc=fail smtp.client-ip=40.107.94.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IznVciXw92r96GGHpCWq1sormYODoUTzQLzN2S1KryhrzLVdPr5WNl5/9ZIB3uF4OmFlvcPTJ1Xd79NXxsjy3yz4QvYzwMwbJWyIYCwbe/YuMTuNxSvD9nrVD2zxu2QJUmKt17+zYAIrRikqau4bKNQaM+HwqHeKVA6e9RfwSXnOu93zzacoZq/prxsKucSJ8XyRZqkso1t3AW29rkMumlaq7VfqD9o6Z4k2OKuWH8fQvqj1a9JJ4Zcp27vymeVoA5aKeFt8bkgd2pLZLXkLRQWt8Uv6x026Te0bECFuWm7x6wRPMp6Crz8e0TsEBHB+JcQh/jAeCFrBKaNJsr50jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UPFXU1eAYzjLNNmEDsQ4k2c2UsG7Z5AD3BunyFtPzMo=;
 b=CguAP8zhC5XQJ3EEtlLwm/qhvloZuEVsxiYUa0DtalUEiuta67b6L6Fv+w9eDTyX+rWqkrwrWbQ93RN3KwGWthqaf8jwA3s1MuSAMuqicK/gza+ZpIEZirnIL6OE5PeCIcMGDe4SuFe/ce30Dz3G9+4k6Md3ic/I1P7c6/N0NmQIzyEcmxot2ahKBkq9SOkdFDVKt5ANXWHF2FJxffGAEXx6eTq9Z7ix+L1srH/vFqUxLCtiUzFVhXNUUNQRCYesklUb4YDtSjPa46dHNbEz1czOfhN/9LnRYQt/lOqbG3XYlnPuC9aJka7BnMNAUnkkEgmC/2P75W5dVAy65bwLDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UPFXU1eAYzjLNNmEDsQ4k2c2UsG7Z5AD3BunyFtPzMo=;
 b=qfAuTrb6RYsxWrM1fldNtr7uH8q8gUSwcfWa1vqCqpq0JlKZ6rIv/nK3Zp7eR2gi10Gkd7JlFECCwaKrpf2PMmT60Yw0Gbz0GpnzksRBU5MDZFdpnzsbdvFNAAE1gTUOpznNK5dp4LNVqhlRS2hE4iTvuTTWKcr0PoE1cXqsSaQ=
Received: from MN0P222CA0003.NAMP222.PROD.OUTLOOK.COM (2603:10b6:208:531::13)
 by MN6PR12MB8544.namprd12.prod.outlook.com (2603:10b6:208:47f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.22; Mon, 20 Jan
 2025 21:58:55 +0000
Received: from MN1PEPF0000F0E3.namprd04.prod.outlook.com
 (2603:10b6:208:531:cafe::c) by MN0P222CA0003.outlook.office365.com
 (2603:10b6:208:531::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8356.22 via Frontend Transport; Mon,
 20 Jan 2025 21:58:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000F0E3.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8377.8 via Frontend Transport; Mon, 20 Jan 2025 21:58:54 +0000
Received: from ruby-9130host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 20 Jan
 2025 15:58:49 -0600
From: Melody Wang <huibo.wang@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>,
	<roedel@suse.de>, Tom Lendacky <thomas.lendacky@amd.com>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <pankaj.gupta@amd.com>,
	<dionnaglaze@google.com>, Michael Roth <michael.roth@amd.com>, Melody Wang
	<huibo.wang@amd.com>
Subject: [PATCH v4 1/1] KVM: Introduce KVM_EXIT_SNP_REQ_CERTS for SNP certificate-fetching
Date: Mon, 20 Jan 2025 21:58:18 +0000
Message-ID: <20250120215818.522175-2-huibo.wang@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250120215818.522175-1-huibo.wang@amd.com>
References: <20250120215818.522175-1-huibo.wang@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E3:EE_|MN6PR12MB8544:EE_
X-MS-Office365-Filtering-Correlation-Id: 98c794b5-9cd6-49fb-a11a-08dd399da233
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HR5m6moJIcoYis+eMpOvaNANNysQ4a58CtjseywQYRw9S1l3dHxl1PuNy633?=
 =?us-ascii?Q?tHRHILxBHLb077BvBFBWCd+xq9KfLWYq8xavVm20iOMvzl5LBKUFzGoTuWh9?=
 =?us-ascii?Q?iTT8DE9pswOCtG3mESgppPyZHvvTitAYuOJqpnBvHBJMQKhoSxmmTrRgUKDT?=
 =?us-ascii?Q?NKsz5XWzFQVwca2W9Lw4EJgg0tO/4KCjckjRkeN4wG/RowQ2oS7EoaFRfhoE?=
 =?us-ascii?Q?LApcbu4MIfiPVKE5U1pUu+y7N0bjcWuORV8nrgyma6Vu25pEjsILkdyzKRYp?=
 =?us-ascii?Q?VL8cU2AgMPTHEcWtZIt5GM/42p+qdZ2uxf9h7KaLMy/Bfb/GMK3o/MGykNc6?=
 =?us-ascii?Q?KgFUfXH6dhdJLe/jtW4TGbQbmt9GqXLCtG2RJpIK5QgcX1MXC7orEePxKk3c?=
 =?us-ascii?Q?p33Lc1b3OyB7IP+nkItOb+Ijx9bX1gaO5wvDnWX+ph+ycZ9bzX0XoY8IFi4R?=
 =?us-ascii?Q?spbvF9J566X9fMvS/3xqkBOGcyWuZrHvqcLcKL+idibcf256iIKi4S2AXhMf?=
 =?us-ascii?Q?g6D2YG8fWRcNv3TWsk9SDj19HAyznGoplU6yeZAwosBpGznBTFyyPzzohkta?=
 =?us-ascii?Q?D9wLu+f3ZDDnM1Lul7Zsyi14cN2ocwGFlIfCdt+qbGUxoHr3AUAb+fY8xD/J?=
 =?us-ascii?Q?EHdb8q9y0VzmsbrESjH6uFBYGhVDT9qN+0b1FO4azRAuzyWP74zN46jj6uKK?=
 =?us-ascii?Q?kWqt6raBAEOCaPsN/i+OaIQfPjHjclsUA5aGs/VGeoYCg+p2LSaDgkLAYbuj?=
 =?us-ascii?Q?qpCGVuhNZ5QZhDWLQCRDcQqY1NhjGmmYBbWJ0NTnwHf93nyGH/C3WyJT0CO2?=
 =?us-ascii?Q?GJ43c2LxyncSgtGpe7glGc5ZNFXSWcOkhyx853HZnQ3+70KEHhzT3Qdl7kz8?=
 =?us-ascii?Q?khNl16mRGdtf+T1Jlc/Uh5jdAJ2aTQbjeuzgAQIK++JzedKpChb2D95Q4LkI?=
 =?us-ascii?Q?Z7gEDp2ylpz60rVbErVJKP9N6ZY81Xf+f+w9PVLdVQjpqqfZRJRLsA3R0Ywf?=
 =?us-ascii?Q?I7dHB8G23qghDd/6CuScvWdGlLU9MDIC9ndBMU7jRzZbb5TaeFYnXB/QYOFb?=
 =?us-ascii?Q?NfR2rC79ty6zenG+XxJhQFirt/bMvHY65pRnLynsLMxD+ZbvJhhVuqqKjfOM?=
 =?us-ascii?Q?IOQgSmGhgdXE7gvW/gINuLkXbzGFOgRBrMIMy1ge3Yf+IuAdenObtLM6+UpV?=
 =?us-ascii?Q?LOlhmciK3Kz2BMOs4kZwHWqEggSEqH8ONGZAxdMXbTyV0DeFVNxK+LaDu9VA?=
 =?us-ascii?Q?1JT1ctlX3nSq9dgMHyHz3G4Ha2iX6ih/ZxI3GmF9a/u29emBCdUGB/ZOCoyp?=
 =?us-ascii?Q?xOA33sWvPsDeKOFHzTw2lpI5GVdsl2R5xjfX9LZ+i7AItrPuyMNI3gRyIdfO?=
 =?us-ascii?Q?EVJik/TEmxLv8LPSkAR1Ph6DjJGdqKNAoNEVVTH/geawLs5sob0U3IX9BNhB?=
 =?us-ascii?Q?v5ldPXr63eejDbH0BnlCldMfVXD+mMa1N6ShVDMlaFfl8vEbNQbB7VMkZmR/?=
 =?us-ascii?Q?ryIg+oQBlYD0Xzw=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2025 21:58:54.9794
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 98c794b5-9cd6-49fb-a11a-08dd399da233
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E3.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8544

From: Michael Roth <michael.roth@amd.com>

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

Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Melody Wang <huibo.wang@amd.com>
---
 Documentation/virt/kvm/api.rst  | 106 ++++++++++++++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |   1 +
 arch/x86/kvm/svm/sev.c          |  43 +++++++++++--
 arch/x86/kvm/x86.c              |  11 ++++
 include/uapi/linux/kvm.h        |  10 +++
 include/uapi/linux/sev-guest.h  |   8 +++
 6 files changed, 173 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index f15b61317aad..f00db1e4c6cc 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7176,6 +7176,95 @@ Please note that the kernel is allowed to use the kvm_run structure as the
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
+that they will need to work into some custom QEMU/VMM to solve the same
+problem.
+
+However, userspace is free to implement their own completely separate
+mechanism for handing all this and completely ignore file locking. QEMU is
+only trying to play nice with this above-mentioned reference implementation
+and cooperative management tools, and not trying to profess to provide any
+sort of synchronization for cases where those sorts of management-level
+updates are performed without utilizing this reference implementation for
+synchronization.
 
 .. _cap_enable:
 
@@ -9020,6 +9109,23 @@ Do not use KVM_X86_SW_PROTECTED_VM for "real" VMs, and especially not in
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
index e159e44a6a1b..dae1a572d770 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1438,6 +1438,7 @@ struct kvm_arch {
 	struct kvm_x86_msr_filter __rcu *msr_filter;
 
 	u32 hypercall_exit_enabled;
+	bool snp_certs_enabled;
 
 	/* Guest can access the SGX PROVISIONKEY. */
 	bool sgx_provisioning_allowed;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 943bd074a5d3..4896c34ed318 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4064,6 +4064,30 @@ static int snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_
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
@@ -4079,12 +4103,10 @@ static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t r
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
@@ -4100,6 +4122,15 @@ static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t r
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
index c79a8cc57ba4..cdcdc5359a87 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4782,6 +4782,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_READONLY_MEM:
 		r = kvm ? kvm_arch_has_readonly_mem(kvm) : 1;
 		break;
+	case KVM_CAP_EXIT_SNP_REQ_CERTS:
+		r = 1;
+		break;
 	default:
 		break;
 	}
@@ -6743,6 +6746,14 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
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
index 502ea63b5d2e..dcaadd6f5b18 100644
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
@@ -933,6 +942,7 @@ struct kvm_enable_cap {
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
2.34.1


