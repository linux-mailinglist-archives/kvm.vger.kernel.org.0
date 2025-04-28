Return-Path: <kvm+bounces-44601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9075DA9F9F8
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 21:52:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DD0D3B41B7
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 19:52:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C14D2973D2;
	Mon, 28 Apr 2025 19:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4ADxLgO9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2088.outbound.protection.outlook.com [40.107.100.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981E51C2DB2;
	Mon, 28 Apr 2025 19:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745869967; cv=fail; b=KHtkYilmkL8gIQe409hbd7Wh3oFe+CDJPf8b+17uED6GZeGfAFNEdXWFVgO2tCCRgSy1PkN3RCZUkNJRjBGsE3zCRMBOuKnrnRQl0BRpF7iO36WqfldHEtHMK8+XzTcEXxFMQwYZDrBYinQIHVdVteWHz0OwdLsYymrIFp9O8z4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745869967; c=relaxed/simple;
	bh=7ISCVfWMXf1HMLtnq1/jSHrsFSpy9FOIHXOntmAaGbY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X5usWhhNkEOn8AwbXpgzggWv3BJ0qwrQpRnl9DIbwzL2YmJE7BhReTs3ZrKiH6SFWgmj/aufLEVpFjy/RGUDLOdXf4cWZ4Y01o/UWEZyMW9gjcIcpYXvamPV/EtGzEqPRN2oDFs594Ev0OVdWRcSgX6a6l7LdeKQDG/Gp9njqTQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4ADxLgO9; arc=fail smtp.client-ip=40.107.100.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YfKLDifX8p6SIY6AUnwdaj70G0ToEYaAnG3IDPc9s4uJx8h0UdrqsnYOmndRq793Ovv7ewL+P2g1t+cwJT/qqB2+ZBDrXH9Aref99SvZrJAxib3m1bl6b4w9R/mc0zEe6KXy3JE2EDoPn+ebpgI1652DmNWHKeCSe/hIosGbfrZN77OwX0FQwZQzQd/bXOLGuaw+XZQqZVKTBklL+feczUMy3TryXkEz0ka45BS2+PO4+gqXGhYBhIote2/cH/RYPb7WShzOFHZTVfQmNNVTao4jiyQseUgZ4xaQCf/QlYnZDNXnPSRvRXllDshiEI4o62Aji50NIi83uwF6Pujdqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VIvMp/OQQBZfE5ZC595qTVOwLe5SLWsIu9ABySFE3zA=;
 b=vZXTvCrKn9ueAweG9dfn4QR/pVkfwJcH/260Y5PBiZSjFwjRRpYT87Myza++CktXJD4RUehx1HQ6mpcaDY9g5QX52E10RH8zZaDM0Fh3muOMmqD+dr546aalT2c+OWYs/DZJ8Li+1cHNAz8VRtVF2yW6BS8GHx0ds2tcH8+Rxq5o/cpc7kY206NpxFKI4NpKN+jGegKIuxOSeoqqhl70wQgUQ8T/BUQASNgTiFQ/zK4zfzgH8iYyuxF9drsNLwOQUHVmUb8y07qonP59nmPef/0f1xSEBnLKV+6PHAifLE/qivi7QmUlx5LtsWM3T52gZt9xOuCxj3qOWy1vK83NhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VIvMp/OQQBZfE5ZC595qTVOwLe5SLWsIu9ABySFE3zA=;
 b=4ADxLgO9V55wUYIVz8P2S65wWXlsZI4pTneSlXhgx7dbKeKkC0HiovQZEbYdbQH/IKkPWub5xOXe9veSad1SkDqaIbbDUHinzWNoneJ6ynW9uz60EXWN/fL7W/giUFBJFI5mc4NtkzhkOAFiGa4z4n5P14BgG5d02Wa/6VV93pw=
Received: from BY3PR05CA0023.namprd05.prod.outlook.com (2603:10b6:a03:254::28)
 by SJ2PR12MB8064.namprd12.prod.outlook.com (2603:10b6:a03:4cc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.33; Mon, 28 Apr
 2025 19:52:41 +0000
Received: from SJ5PEPF000001EB.namprd05.prod.outlook.com
 (2603:10b6:a03:254:cafe::99) by BY3PR05CA0023.outlook.office365.com
 (2603:10b6:a03:254::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.8 via Frontend Transport; Mon,
 28 Apr 2025 19:52:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001EB.mail.protection.outlook.com (10.167.242.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8678.33 via Frontend Transport; Mon, 28 Apr 2025 19:52:41 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 28 Apr
 2025 14:52:40 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <liam.merwick@oracle.com>,
	<dionnaglaze@google.com>, <huibo.wang@amd.com>
Subject: [PATCH v6 2/2] KVM: SEV: Add KVM_SEV_SNP_ENABLE_REQ_CERTS command
Date: Mon, 28 Apr 2025 14:51:13 -0500
Message-ID: <20250428195113.392303-3-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250428195113.392303-1-michael.roth@amd.com>
References: <20250428195113.392303-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001EB:EE_|SJ2PR12MB8064:EE_
X-MS-Office365-Filtering-Correlation-Id: fe957a1b-be82-4336-4572-08dd868e3c69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JBblDicPK4LsUyz4ycPjYQnPtYF6yRCdW8qIG0vfXHwUAG9XESQLx/TJxVFa?=
 =?us-ascii?Q?wkY+mv5a8eKdm2/I/lWJVqKo95UCTZzsor+hY13Ns3uu5KqWjgN99/XBp8Je?=
 =?us-ascii?Q?huUNVF2UNwltuD+XISnZs8K28lO58t0OApb0cCjAsz6ipk3cHmx7jt/WTk+p?=
 =?us-ascii?Q?32akF7a3S3GnOvdeLGDsmUctZyNLVjv3dppUlfhm5dGjMWUGJNQ7O0ZYTgZN?=
 =?us-ascii?Q?WUTF6D/kcpjaOwvbpGMt/O0bw5Ntu2+9JdphJatr1QIOvMNWfMoVirog6U1w?=
 =?us-ascii?Q?uibFy1SGVvPEWwl08uGKvotFBMk6+9cb5TCEs6WeEUWm3qcC9SDXuwZGyfM0?=
 =?us-ascii?Q?Fsf5GduoA8Q/t/38hQCkzh3JbxvIJfYpNsAkjvxXUolZst9p5HkUKo3vxJ94?=
 =?us-ascii?Q?2MGisUbw5JJLXc3fQXEEli+VLwQSTNkPLZ4DEaKxVWV8x9otxNXapVY/RgXk?=
 =?us-ascii?Q?eEB5mhAvYsASOAJMNIZpg4/GxzqpcWj3KZwwEo99UYOV3q0Cxp63Yp7AGyOY?=
 =?us-ascii?Q?xdNTFvVVORhkgKRbRma+StmNNczZxPZGN0sBIz6zKHkoemBgmpt/ohyDnHuk?=
 =?us-ascii?Q?YfovvlPKbgHnqIv7wzdvAMSWU77TyIBHusupbOLBpkzEPtAc5eBGBFeMwWPZ?=
 =?us-ascii?Q?pLvxn+7PwKdlPwo4m1ovpSIBabakyCmFMzJCQWtL64QRrNWE+O/sJLpEKi0I?=
 =?us-ascii?Q?ZI/2nSkaVy+5nXkNPVslWl9ZLWMnEbL9HyylGUE74uT/JGIVWRoC3A/AkHEz?=
 =?us-ascii?Q?KsaDNHcjKerbqKSBkAgmczfPGupfga8Xu+6YUYmy/no8AdIBCWrsspoMZN/E?=
 =?us-ascii?Q?VT/sGvufSYqs59HftpsbT6A4y189Y645SgW+eDBjMxS3ym4PbdqjaiFMokOB?=
 =?us-ascii?Q?2twmUXfzClhZ1qEH9nqrG/HO+MGketKjwCMELB6855PLMcGRkBMbnC8qJKx5?=
 =?us-ascii?Q?XEOVpjk+3C1ghGDUwpxkgAUIoIsHicrcOwEPMfc9w8ZG9tiVI9ESEdSSd9et?=
 =?us-ascii?Q?Sc793rnR0/e3hv1PTAaRec/cy+Am3TTxOz58an/vnGt1Nk1FFDehT4c5HegA?=
 =?us-ascii?Q?qqkSJIvadhV4ivHCNO8/RYzOAHtzJD+Om9+pnbfV2kM52lGrNh35RcAW+wua?=
 =?us-ascii?Q?GaaX4DhkPeOWP/yyxhAMcPGRf9SiAbxlNlGjd3izFHvrCPOqL8yrIdvdhLHk?=
 =?us-ascii?Q?0WG62ci/PfOb2DL3jwKgSVayIYuWPQZe6zyCUBnbBbgfpHbXp4afGU06G9pN?=
 =?us-ascii?Q?uDYo3fJr1UOnMyrq5nHFS7d2qqQBHd85FdxoGOHdW2DzB/wKQHMdAeuM3mox?=
 =?us-ascii?Q?ntMzuLYwLhi7+1wtnIM40SExc67LFjonOmbtUFSOaboHWWhBvol09fCcI/iy?=
 =?us-ascii?Q?rHsNdI7LuftouBt5sNfx3+lESbXhYMFcH0Yd6na/nDf8t658TqdUFTvmESMG?=
 =?us-ascii?Q?70oJnUj3lBbGdu02DfGlSg1iZoc8m8ZSEnrnxKQQEKbOQNaO7WcPD2qb1cdT?=
 =?us-ascii?Q?rvh16KrfTqmQnwFi/y64eaMtBA/GfDDO0es5?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2025 19:52:41.2085
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fe957a1b-be82-4336-4572-08dd868e3c69
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001EB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8064

Introduce a new command for KVM_MEMORY_ENCRYPT_OP ioctl that can be used
to enable fetching of endorsement key certificates from userspace via
the new KVM_EXIT_SNP_REQ_CERTS exit type. Also introduce a new
KVM_X86_SEV_SNP_REQ_CERTS KVM device attribute so that userspace can
query whether the kernel supports the new command/exit.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 .../virt/kvm/x86/amd-memory-encryption.rst      | 17 ++++++++++++++++-
 arch/x86/include/uapi/asm/kvm.h                 |  2 ++
 arch/x86/kvm/svm/sev.c                          | 17 ++++++++++++++++-
 3 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index 1ddb6a86ce7f..cd680f129431 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -572,6 +572,17 @@ Returns: 0 on success, -negative on error
 See SNP_LAUNCH_FINISH in the SEV-SNP specification [snp-fw-abi]_ for further
 details on the input parameters in ``struct kvm_sev_snp_launch_finish``.
 
+21. KVM_SEV_SNP_ENABLE_REQ_CERTS
+--------------------------------
+
+The KVM_SEV_SNP_ENABLE_REQ_CERTS command will configure KVM to exit to
+userspace with a ``KVM_EXIT_SNP_REQ_CERTS`` exit type as part of handling
+a guest attestation report, which will to allow userspace to provide a
+certificate corresponding to the endorsement key used by firmware to sign
+that attestation report.
+
+Returns: 0 on success, -negative on error
+
 Device attribute API
 ====================
 
@@ -579,11 +590,15 @@ Attributes of the SEV implementation can be retrieved through the
 ``KVM_HAS_DEVICE_ATTR`` and ``KVM_GET_DEVICE_ATTR`` ioctls on the ``/dev/kvm``
 device node, using group ``KVM_X86_GRP_SEV``.
 
-Currently only one attribute is implemented:
+The following attributes are currently implemented:
 
 * ``KVM_X86_SEV_VMSA_FEATURES``: return the set of all bits that
   are accepted in the ``vmsa_features`` of ``KVM_SEV_INIT2``.
 
+* ``KVM_X86_SEV_SNP_REQ_CERTS``: return a value of 1 if the kernel supports the
+  ``KVM_EXIT_SNP_REQ_CERTS`` exit, which allows for fetching endorsement key
+  certificates from userspace for each SNP attestation request the guest issues.
+
 Firmware Management
 ===================
 
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 225a12e0d5d6..24045279dbea 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -468,6 +468,7 @@ struct kvm_sync_regs {
 /* vendor-specific groups and attributes for system fd */
 #define KVM_X86_GRP_SEV			1
 #  define KVM_X86_SEV_VMSA_FEATURES	0
+#  define KVM_X86_SEV_SNP_REQ_CERTS	1
 
 struct kvm_vmx_nested_state_data {
 	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
@@ -708,6 +709,7 @@ enum sev_cmd_id {
 	KVM_SEV_SNP_LAUNCH_START = 100,
 	KVM_SEV_SNP_LAUNCH_UPDATE,
 	KVM_SEV_SNP_LAUNCH_FINISH,
+	KVM_SEV_SNP_ENABLE_REQ_CERTS,
 
 	KVM_SEV_NR_MAX,
 };
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index b74e2be2cbaf..d5b4f308ab3a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2123,7 +2123,9 @@ int sev_dev_get_attr(u32 group, u64 attr, u64 *val)
 	case KVM_X86_SEV_VMSA_FEATURES:
 		*val = sev_supported_vmsa_features;
 		return 0;
-
+	case KVM_X86_SEV_SNP_REQ_CERTS:
+		*val = sev_snp_enabled ? 1 : 0;
+		return 0;
 	default:
 		return -ENXIO;
 	}
@@ -2535,6 +2537,16 @@ static int snp_launch_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static int snp_enable_certs(struct kvm *kvm)
+{
+	if (kvm->created_vcpus || !sev_snp_guest(kvm))
+		return -EINVAL;
+
+	to_kvm_sev_info(kvm)->snp_certs_enabled = true;
+
+	return 0;
+}
+
 int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -2640,6 +2652,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_SNP_LAUNCH_FINISH:
 		r = snp_launch_finish(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_ENABLE_REQ_CERTS:
+		r = snp_enable_certs(kvm);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
-- 
2.25.1


