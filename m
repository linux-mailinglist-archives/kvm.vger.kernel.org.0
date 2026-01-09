Return-Path: <kvm+bounces-67645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E8E2FD0C851
	for <lists+kvm@lfdr.de>; Sat, 10 Jan 2026 00:19:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9C06B302E84B
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 23:19:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACAE531E11C;
	Fri,  9 Jan 2026 23:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vcrnPNJE"
X-Original-To: kvm@vger.kernel.org
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012033.outbound.protection.outlook.com [52.101.53.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7308726E71E;
	Fri,  9 Jan 2026 23:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768000759; cv=fail; b=dVSR+xFADTqCOlvsSSVpIbGvLqYNJdDlFfDTscV4poe0C50+KAys67J2eHuYmXTyIeknry0D92Yvjnzt5UYtJNpNglZmOxC/rxEg7FXnz/ut1C9jfh6Ma/t/8CB3jmm8bzbEU9Onsd6DUQhdEGYvDo8CSYId3f9a94w9FIwbHSQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768000759; c=relaxed/simple;
	bh=lQ6uK0UOu4zfWkxcGb67bjw1bGkFTw+Zpi9m5yqVUOM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ny1exaIxf7SuXHDmDbPTNz2RWwg9XrroR1NvoLNK1Brta4l8c8TPzt1CBf3IRQRD0Tc3lpW11kcCHB8hI5GwKlWtbtBxYHShp7ADSPPq6i56MPhU/ICtL54LpboWMYMnV7uM3/LJtBMLGZ4Wwt7fa8SmZFJvg/ETMZVzN7NpNC8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vcrnPNJE; arc=fail smtp.client-ip=52.101.53.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tBHMN79kGa44k3/olEqwraOhI0/yG6NEtY8/7ChlaHrJPLOS3i8wyTuksNpRdlAlRBzpFix1oQdPv51MS/n12LnrukYN0KYbQTOizalaL+LimNPl6WONF62jPGQI241sn1t+X8n731FS96x8gk+EJxGUXY3Ya3Kcej+AsBqXbgNs3zRmGpfAiHXTFacy2A62MVteay486FyU4NKJ8fI2tDXVNHRkD2Npidkfcyj/DVs705trtCTlQ/4XxFqhEM9BoaN4eCSgej8ol90llIRJceVqyTEwohPoPQmKnhLI3ERW5sylIXNmAUWguWqiPrIqkXwJpbu1uZrCH9BN7qJNbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8/zZfcXYHWnvgAZRHCAl/SBnBIbOGpORUjKHESvIY4M=;
 b=rZ2xd8GMNWXoVLG19zUruZXRMHGPUseP2qZSiNWNOk3RF502/7Kmipq3Vli+Oni41SzBcrj/Op6MngBoaWUif6Pi2JnCDCAhASyRZ57sZRSmb90c/VRKjpFQducfImbvcEnOFfNqiWJjoPLafiE4vz9lnOiXUwsdwUPCfjUIM5Gv3PD0ZW7PGjTYufQkcfC7RG8qn+1Xz6jHSqfxJchBCLLqkhM0mhEOn5xcmho9tywefvrRRFusQOErRV81+cTVHQYjnD/z1ZwyXAmLdkY9laO1sAdNgaPCbZx4xyKCxghG1m1AZlKZkbYcHm68ZJ9UqANbDa3Dab//NOwLlXl1WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8/zZfcXYHWnvgAZRHCAl/SBnBIbOGpORUjKHESvIY4M=;
 b=vcrnPNJEmP++TC1GYsX0vPCTTKb2mbBKjHCO7lYMRPpJaYYBYzIq7p0xcAi+pHI5zgmx9XqkIfIcuY0NcwrDSOzOS53CkmD8qupUjKZts2uTlLe2dqpNqJ6WfSs87D3PMcZd/+GaX2XQH8Dup8uZxoYLpk30HqeZ0JD2QsT5emw=
Received: from BYAPR08CA0014.namprd08.prod.outlook.com (2603:10b6:a03:100::27)
 by MN0PR12MB6318.namprd12.prod.outlook.com (2603:10b6:208:3c1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.5; Fri, 9 Jan
 2026 23:19:14 +0000
Received: from SJ1PEPF00002316.namprd03.prod.outlook.com
 (2603:10b6:a03:100:cafe::c0) by BYAPR08CA0014.outlook.office365.com
 (2603:10b6:a03:100::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.5 via Frontend Transport; Fri, 9
 Jan 2026 23:19:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00002316.mail.protection.outlook.com (10.167.242.170) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Fri, 9 Jan 2026 23:19:12 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 9 Jan
 2026 17:18:58 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <liam.merwick@oracle.com>, <huibo.wang@amd.com>
Subject: [PATCH v7 2/2] KVM: SEV: Add KVM_SEV_SNP_ENABLE_REQ_CERTS command
Date: Fri, 9 Jan 2026 17:17:33 -0600
Message-ID: <20260109231732.1160759-3-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260109231732.1160759-1-michael.roth@amd.com>
References: <20260109231732.1160759-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002316:EE_|MN0PR12MB6318:EE_
X-MS-Office365-Filtering-Correlation-Id: 0081eafa-fd40-4bf7-6d01-08de4fd5802f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qHtrC5DGFrhwS5NxWHEOhz9FqPYlADqrmFqOnRYsWLqqk6RGSmJHPrm7d3ld?=
 =?us-ascii?Q?HzP9WlxbvdL1JGdog3o/F+i2JqYYCIKgy3EQI/0nfAEg2YMwegF4kSa4WSbR?=
 =?us-ascii?Q?t2LPFAegaXmvuVR18obNC1uBW0FUR8RNEsMG5ikF7AOMQqPSmBigl1KrRwN2?=
 =?us-ascii?Q?DEynofZIMMm0faKAP8dTv7YAISKRAAA9m9yxeYJEe8XBuVYBREeBRqdAKlvo?=
 =?us-ascii?Q?g/Tg+ZTK50JvLjIlyTWPwNWY9jjwgWUiS3hQXtE9sbFZxk+YRlidiNeiS//2?=
 =?us-ascii?Q?OBi1QVG9q6o3hAIZ13h40aBaWkHNI5cQGkM2UFbV+qaf8XC4bHcZbapVK47Q?=
 =?us-ascii?Q?gvo+Z55TTcRkxwL/bA+Wnwjv+BlCnV1UfqLb8pxAJKtcvPBZjR2gAhyGaPOS?=
 =?us-ascii?Q?Ru5hQPSdmFv7nFWjFwC8N9krzBoMtQgOC5CkCKOpv+ULJnSn9Jm8U3SkfNe0?=
 =?us-ascii?Q?WNEukaW44F587rS2o+LXUvPrVC+cltjn35I1BpiNFS7Eu23z9E9m9WygRks1?=
 =?us-ascii?Q?hoo7m1C7Zzb1TxrGBx2YMrpSFi3wrijdehADcdoWcnyW7DDYDOR09hxTfBlI?=
 =?us-ascii?Q?azKOI6qWmhg4AIo4dYDPtlcOIqUEXSYKaY+OBzDpaeFxJY8Vl10SmQI5Xc9H?=
 =?us-ascii?Q?lQl4x56Oo1xg/c9L8mvutC6ItabNB9+9Vn8lTXgzr0vR9a8+uGTmCrqmcu0y?=
 =?us-ascii?Q?+BltvqByQ4yGQdek3mSL2WIg4r0la34PeEvAXFq7cPGXwSJPe2TL4CIdrKpN?=
 =?us-ascii?Q?i/dFIxjaXB4x7WW8nLDGXfgxq+X6k2AhbzCgrEOa4Lqnw5a6lBBoyw9sTm1I?=
 =?us-ascii?Q?MMOBntoJwB46ifhUajkG+qd5EELkwT0iUxYJmc0sr+LWFgEeqiXExgKjj07K?=
 =?us-ascii?Q?jALSd+BLq0IC+HGPwP4sqQooJup3pg86RMv5Kl96/X89c7UBezl6MzjpxAkx?=
 =?us-ascii?Q?dNFE3k+7ywqw1o/e8BIuk2LVAiVlGk/jvtOTuy2KrxcFtYNP6igOrkPhjRm7?=
 =?us-ascii?Q?F9v+bVugZRzIwkSEZW6B0pHC7IeaemF5s4AFA7/FlelanKfr72eAADt2tjei?=
 =?us-ascii?Q?ox4pxZqE+Zi5Y/sWEuSsM3oxEZWsU5fBcRtBwgGWZoBVy1nBey+CzitpbKVT?=
 =?us-ascii?Q?35OlGoGZUr6t0wRBIPCaT5sSZNgRvsdEcsONV/0So5YmPVzk2JowirVyfTZR?=
 =?us-ascii?Q?rVvcCbjZFKIGps/gfkUDHqgGPenl/WzrsESgJOW6waL1Kd49awZ3xU854mOK?=
 =?us-ascii?Q?70tXoHsZoQaIKuWYrkk33pEMxNGRao/PxVO6G1pdRy/Xm4Q2DMxMdOTcl8hv?=
 =?us-ascii?Q?8+Jn2pFfJPwFByslt6woFsRWDH5udnnBwm5lvMyV6eOuPrloYHJvcoKchsWU?=
 =?us-ascii?Q?gcTwkhSwbwoOfL3rMcBzfEx0SyXqJwiIWBSfnlCO6HMUH7IaScpP5BkP8KMr?=
 =?us-ascii?Q?eXVrT0PXwOjKxZGiHuISIUmz0Ogg6NK0Q36as/frIfE/eqAu81Z9EkzHp5yA?=
 =?us-ascii?Q?rSJ2lKn+94HVAnv1xo4nd+15Wp7pLE/hyLDshfgglA5MWHj9quOGqK1b+6Mw?=
 =?us-ascii?Q?lnFMBWnSgJeq9wBhmjA=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 23:19:12.9064
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0081eafa-fd40-4bf7-6d01-08de4fd5802f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002316.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6318

Introduce a new command for KVM_MEMORY_ENCRYPT_OP ioctl that can be used
to enable fetching of endorsement key certificates from userspace via
the new KVM_EXIT_SNP_REQ_CERTS exit type. Also introduce a new
KVM_X86_SEV_SNP_REQ_CERTS KVM device attribute so that userspace can
query whether the kernel supports the new command/exit.

Suggested-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
Tested-by: Liam Merwick <liam.merwick@oracle.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 .../virt/kvm/x86/amd-memory-encryption.rst    | 52 ++++++++++++++++++-
 arch/x86/include/uapi/asm/kvm.h               |  2 +
 arch/x86/kvm/svm/sev.c                        | 16 ++++++
 3 files changed, 69 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index 1ddb6a86ce7f..543b5e5dd8d4 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -572,6 +572,52 @@ Returns: 0 on success, -negative on error
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
+NOTE: The endorsement key used by firmware may change as a result of
+management activities like updating SEV-SNP firmware or loading new
+endorsement keys, so some care should be taken to keep the returned
+certificate data in sync with the actual endorsement key in use by
+firmware at the time the attestation request is sent to SNP firmware. The
+recommended scheme to do this is to use file locking (e.g. via fcntl()'s
+F_OFD_SETLK) in the following manner:
+
+  - Prior to obtaining/providing certificate data as part of servicing an
+    exit type of ``KVM_EXIT_SNP_REQ_CERTS``, the VMM should obtain a
+    shared/read or exclusive/write lock on the certificate blob file before
+    reading it and returning it to KVM, and continue to hold the lock until
+    the attestation request is actually sent to firmware. To facilitate
+    this, the VMM can set the ``immediate_exit`` flag of kvm_run just after
+    supplying the certificate data, and just before resuming the vCPU.
+    This will ensure the vCPU will exit again to userspace with ``-EINTR``
+    after it finishes fetching the attestation request from firmware, at
+    which point the VMM can safely drop the file lock.
+
+  - Tools/libraries that perform updates to SNP firmware TCB values or
+    endorsement keys (e.g. via /dev/sev interfaces such as ``SNP_COMMIT``,
+    ``SNP_SET_CONFIG``, or ``SNP_VLEK_LOAD``, see
+    Documentation/virt/coco/sev-guest.rst for more details) in such a way
+    that the certificate blob needs to be updated, should similarly take an
+    exclusive lock on the certificate blob for the duration of any updates
+    to endorsement keys or the certificate blob contents to ensure that
+    VMMs using the above scheme will not return certificate blob data that
+    is out of sync with the endorsement key used by firmware at the time
+    the attestation request is actually issued.
+
+This scheme is recommended so that tools can use a fairly generic/natural
+approach to synchronizing firmware/certificate updates via file-locking,
+which should make it easier to maintain interoperability across
+tools/VMMs/vendors.
+
 Device attribute API
 ====================
 
@@ -579,11 +625,15 @@ Attributes of the SEV implementation can be retrieved through the
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
index 7ceff6583652..b2c928c5965d 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -503,6 +503,7 @@ struct kvm_sync_regs {
 #define KVM_X86_GRP_SEV			1
 #  define KVM_X86_SEV_VMSA_FEATURES	0
 #  define KVM_X86_SNP_POLICY_BITS	1
+#  define KVM_X86_SEV_SNP_REQ_CERTS	2
 
 struct kvm_vmx_nested_state_data {
 	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
@@ -743,6 +744,7 @@ enum sev_cmd_id {
 	KVM_SEV_SNP_LAUNCH_START = 100,
 	KVM_SEV_SNP_LAUNCH_UPDATE,
 	KVM_SEV_SNP_LAUNCH_FINISH,
+	KVM_SEV_SNP_ENABLE_REQ_CERTS,
 
 	KVM_SEV_NR_MAX,
 };
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2405c6fad95c..695463bc6c5b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2161,6 +2161,9 @@ int sev_dev_get_attr(u32 group, u64 attr, u64 *val)
 		*val = snp_supported_policy_bits;
 		return 0;
 
+	case KVM_X86_SEV_SNP_REQ_CERTS:
+		*val = sev_snp_enabled ? 1 : 0;
+		return 0;
 	default:
 		return -ENXIO;
 	}
@@ -2577,6 +2580,16 @@ static int snp_launch_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
@@ -2682,6 +2695,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
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


