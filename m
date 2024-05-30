Return-Path: <kvm+bounces-18396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E74128D4A2A
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 13:17:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 35E2EB21EC3
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 11:17:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E40F17D359;
	Thu, 30 May 2024 11:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="d6OYrEav"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2078.outbound.protection.outlook.com [40.107.244.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EEE1178364
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 11:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717067815; cv=fail; b=IWe9DtKqlh3QvjRXyWhjJ8EW5BwSZLAArWMh1n/KM4XN2LeIs+2YbnnLUTts5VLKfG49WM3G1NdqwaB12EBsP0+cPBDY9hUaSKUuq2Hu+8MgNI98+KjWvYyRk8Bc40kTJ28B6LZhwJ2QnQhvCyJiBXhIP/FaN6z8Px5c8clmsJ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717067815; c=relaxed/simple;
	bh=+kF6UX4zhPVjedafJ+WrA4oUAtmndADRae1TAP5g3VU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pfezicOQgqYQxKjY2FZppe9g4mZb0ThgdRk93kSs/jQFnHXhZEMWAyB/cXe4xkngf9Yr8ceXY1mhmPYo/en0+snrGCXsEJO8Ul1Y4X15urZ+4dyT4gdEmE6CWzg10xYb0hOYYWep1x8pBHrUi3cxUzM/eLFV6m87OFc3s18t0YU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=d6OYrEav; arc=fail smtp.client-ip=40.107.244.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UdgRTR3NmnNG4jQF+s94+lNxg/oRLzJ7/s5kLA6LlXlTuScqOnTQ11VtN0FYLI+T02r5DHErPAmUGB8JdX5szYAPfBWWu9iOLCo20oY8Q+2eTtjCyktlUtCf152mSMXOphCbSj2qHcFyhqQVNMgXtxJNHHbii3l/+yGIphTjOtXtpB1evAES68frHRo001ZYTDG2tapm9hRBjJYQlyOamm0da3N1lF+chdO8TuKCD1jfb4q8NBVp8QTm4MVLQ3KuuENG4C/3avXZrgpKC+WidEdKPPaMNJrLNE7qbPEIS0AJGIecFTxV1ou1pBKNxh+C0llTNcM/tgRssbevBkeI8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RQxGHIropzDaQyfNLj0B1lvQTCJ7A0dbvLxcw8dK1Nc=;
 b=iqfNwH9v4Eii4LF2qXjovv/vbQUB0dnOpoDpWiSaHRtMmVoy69YEEUSLcdxFmAsdMh06M4Q3eh6jv6CZOHKWS8ODOEE/LImdHSgyMRpi8IPfiSbJsSeVtVgkgzT4i59P/tjIcprIyH1OcVLpkU9Q1M8J8adgre3jFxE//4CqBi3lP+dVMDqAShBWaJ7Agd7RVHIvZIRChmSS5nq/kST3njO2Ag+RIh3uAfSBwrKheoeYhUrJBmcQGYbwIOjM40Ru/7EiUN4qNve8tw0wQLX3dEh0VMuho9PnJghdaPw3GoMiVUqmMJkJu+cZeO4as2MsOOLI7x+6IuOxzZvfeKjLeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RQxGHIropzDaQyfNLj0B1lvQTCJ7A0dbvLxcw8dK1Nc=;
 b=d6OYrEavVeK79obKcf2cJMNi5m0S0QK56AvGwdTmmXOBHRZc/hq+w6DGu8xNXgNBzrFaOnx28B2VGmd5rArAWmMNyHmH+OMpK871GUY8ycB2ImJzGockjCKk7w39mFtWnuLRMvAeip90ldfdPXJkK1Vnm7lOsx0fD0Dk2xg7LHc=
Received: from BN1PR14CA0001.namprd14.prod.outlook.com (2603:10b6:408:e3::6)
 by DM6PR12MB4219.namprd12.prod.outlook.com (2603:10b6:5:217::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.29; Thu, 30 May
 2024 11:16:50 +0000
Received: from BN2PEPF00004FBC.namprd04.prod.outlook.com
 (2603:10b6:408:e3:cafe::83) by BN1PR14CA0001.outlook.office365.com
 (2603:10b6:408:e3::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.18 via Frontend
 Transport; Thu, 30 May 2024 11:16:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN2PEPF00004FBC.mail.protection.outlook.com (10.167.243.182) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Thu, 30 May 2024 11:16:50 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:16:48 -0500
Received: from pankaj-M75q.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Thu, 30 May 2024 06:16:48 -0500
From: Pankaj Gupta <pankaj.gupta@amd.com>
To: <qemu-devel@nongnu.org>
CC: <brijesh.singh@amd.com>, <dovmurik@linux.ibm.com>, <armbru@redhat.com>,
	<michael.roth@amd.com>, <xiaoyao.li@intel.com>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>, <isaku.yamahata@intel.com>, <berrange@redhat.com>,
	<kvm@vger.kernel.org>, <anisinha@redhat.com>, <pankaj.gupta@amd.com>
Subject: [PATCH v4 07/31] i386/sev: Introduce 'sev-snp-guest' object
Date: Thu, 30 May 2024 06:16:19 -0500
Message-ID: <20240530111643.1091816-8-pankaj.gupta@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240530111643.1091816-1-pankaj.gupta@amd.com>
References: <20240530111643.1091816-1-pankaj.gupta@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Received-SPF: None (SATLEXMB03.amd.com: pankaj.gupta@amd.com does not
 designate permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBC:EE_|DM6PR12MB4219:EE_
X-MS-Office365-Filtering-Correlation-Id: 62d8bbdb-4034-430d-fc97-08dc809a00b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|36860700004|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZX8CFJlx8rJGk4AaipyT3CFUpmVPLAcbZh6btpZgTCFLBarsTXnfy1CkyYPp?=
 =?us-ascii?Q?V96uVd/HpYFCZ1oQmfPo5614Antty4RV1xI3oXiGjmO+RmSIianRcRPZSUrv?=
 =?us-ascii?Q?WzWwaIXeukXoLZGu4+XP0/Do4/ZgUgIWlQYuZ2CdFgi2gyuELVoTUuuFwRCM?=
 =?us-ascii?Q?a8ki/Jy17rQZaevW4w6E+TqAR6NwvPiSYzbcluhM5ZLi9BbMEHxPnHOLN1KL?=
 =?us-ascii?Q?byfVwWjltCKL2/rBSeLrq4a+7jYpjAn/5pjlYgdw9dv0Oe0M3jW369oqvKwu?=
 =?us-ascii?Q?QSMRSP3+FCpCZVE571ejdOaF+eF0285SdBhb3mBOuFEYBXYjeT7IUOyuZWKb?=
 =?us-ascii?Q?y21LQdXXE1nlal4BGCxPnVGVnKzEHOOjX7Tt60HzDq8ZzRqpAkZUTAoLiPH4?=
 =?us-ascii?Q?vYwZUcOqUHr7KwNFbDqonuLEGtMeQKR0JnqcY8QF7LaLKQIQz58eay5SmxDT?=
 =?us-ascii?Q?iK8oFJq0Pz+goR2/Jj95jx4I87VVf8CMjSHWjQd37jqj4eehIm4JoAAIkZlG?=
 =?us-ascii?Q?4CkZFBpp8l7/lUKd2ZuaZB2cYIbTv9iFx6LE0GQ3dL8MvekGHmiO53f+L1oV?=
 =?us-ascii?Q?XLoqh40DpcuD6VJ7G2MuAwjxuB2lvhzHcmSZRf2k8Jk4hLA4pw5kbHb18bZZ?=
 =?us-ascii?Q?y4ccRj78UUVGo7wB/c+NApKXAB+0ezhGcY4DEQi9KsAPNe2dMnKKOf63xXfJ?=
 =?us-ascii?Q?OFf3UNIwBMOHRu9TK8OXPPmp/lb3pAs5nrLqv5wCGBOYj9e0Mx3miU2sQYS1?=
 =?us-ascii?Q?7f1Uax2zGGLJqzoWwPT3VO+iAhbVvWIr2i6IAkN2jiAepWPLioAQAwG62zF6?=
 =?us-ascii?Q?iW2577HdfDNY62DefCrbXgc4s3urJyz2fkVDV/W6AWn3nRBCSmq12pa1w/l0?=
 =?us-ascii?Q?a0PY5nqR/wjdHY0gZt+bdyT9DSzXfpAUlaEMVG1ksTXPwJQq3RtrGGe9H78O?=
 =?us-ascii?Q?u/q9v5RpVMe09iuvCoTq6LOd+SPgwr5sdvR5K6yyahZTqyUCx1B2FAIJTtPC?=
 =?us-ascii?Q?K2XZ8YyXEXZr1Dh0cVyFwkZXcDhhq/Yc4ilUp41inyF695ISunfYo14HpXly?=
 =?us-ascii?Q?960vRQmsdWoFC0Evfw+WjA2S3NKNTmJVXMTTcFPD/ZITjWjJnIUau7x4zjdk?=
 =?us-ascii?Q?vwubTLlW32iXb+eBlPFsYtstxviO1ew08Q1ERhnj4Dv65W3nApDO5Zph4SFI?=
 =?us-ascii?Q?fI4jeAeLf2gXcIs5xQrmKqzo0OsnykQA6qiX0lCbekKHgoIu63AUf+Cu/awp?=
 =?us-ascii?Q?sFZ35/ZV9S29HikytkZb4+JKA3V1405ieGA1OUIk4cE8hq0nw3bdt61Jzf9t?=
 =?us-ascii?Q?OtrAoVUUnjnBeO8QS9Xf7vJhztU2VyQaiwG21nxFzUsw7h55k1Am2L7NpF5v?=
 =?us-ascii?Q?NrjB5TRLyp1iGj3Sgaphb7PJLzjU?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400017)(36860700004)(1800799015)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 11:16:50.4569
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 62d8bbdb-4034-430d-fc97-08dc809a00b3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBC.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4219

From: Brijesh Singh <brijesh.singh@amd.com>

SEV-SNP support relies on a different set of properties/state than the
existing 'sev-guest' object. This patch introduces the 'sev-snp-guest'
object, which can be used to configure an SEV-SNP guest. For example,
a default-configured SEV-SNP guest with no additional information
passed in for use with attestation:

  -object sev-snp-guest,id=sev0

or a fully-specified SEV-SNP guest where all spec-defined binary
blobs are passed in as base64-encoded strings:

  -object sev-snp-guest,id=sev0, \
    policy=0x30000, \
    init-flags=0, \
    id-block=YWFhYWFhYWFhYWFhYWFhCg==, \
    id-auth=CxHK/OKLkXGn/KpAC7Wl1FSiisWDbGTEKz..., \
    auth-key-enabled=on, \
    host-data=LNkCWBRC5CcdGXirbNUV1OrsR28s..., \
    guest-visible-workarounds=AA==, \

See the QAPI schema updates included in this patch for more usage
details.

In some cases these blobs may be up to 4096 characters, but this is
generally well below the default limit for linux hosts where
command-line sizes are defined by the sysconf-configurable ARG_MAX
value, which defaults to 2097152 characters for Ubuntu hosts, for
example.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Co-developed-by: Michael Roth <michael.roth@amd.com>
Acked-by: Markus Armbruster <armbru@redhat.com> (for QAPI schema)
Signed-off-by: Michael Roth <michael.roth@amd.com>
Co-developed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
---
 docs/system/i386/amd-memory-encryption.rst |  70 +++++-
 qapi/qom.json                              |  57 +++++
 target/i386/sev.c                          | 257 +++++++++++++++++++++
 target/i386/sev.h                          |   1 +
 4 files changed, 383 insertions(+), 2 deletions(-)

diff --git a/docs/system/i386/amd-memory-encryption.rst b/docs/system/i386/amd-memory-encryption.rst
index e9bc142bc1..5849ec8972 100644
--- a/docs/system/i386/amd-memory-encryption.rst
+++ b/docs/system/i386/amd-memory-encryption.rst
@@ -25,8 +25,8 @@ support for notifying a guest's operating system when certain types of VMEXITs
 are about to occur. This allows the guest to selectively share information with
 the hypervisor to satisfy the requested function.
 
-Launching
----------
+Launching (SEV and SEV-ES)
+--------------------------
 
 Boot images (such as bios) must be encrypted before a guest can be booted. The
 ``MEMORY_ENCRYPT_OP`` ioctl provides commands to encrypt the images: ``LAUNCH_START``,
@@ -161,6 +161,72 @@ The value of GCTX.LD is
 If kernel hashes are not used, or SEV-ES is disabled, use empty blobs for
 ``kernel_hashes_blob`` and ``vmsas_blob`` as needed.
 
+Launching (SEV-SNP)
+-------------------
+Boot images (such as bios) must be encrypted before a guest can be booted. The
+``MEMORY_ENCRYPT_OP`` ioctl provides commands to encrypt the images:
+``SNP_LAUNCH_START``, ``SNP_LAUNCH_UPDATE``, and ``SNP_LAUNCH_FINISH``. These
+three commands communicate with SEV-SNP firmware to generate a fresh memory
+encryption key for the VM, encrypt the boot images for a successful launch. For
+more details on the SEV-SNP firmware interfaces used by these commands please
+see the SEV-SNP Firmware ABI.
+
+``SNP_LAUNCH_START`` is called first to create a cryptographic launch context
+within the firmware. To create this context, the guest owner must provide a
+guest policy and other parameters as described in the SEV-SNP firmware
+specification. The launch parameters should be specified as described in the
+QAPI schema for the sev-snp-guest object.
+
+The ``SNP_LAUNCH_START`` uses the following parameters, which can be configured
+by the corresponding parameters documented in the QAPI schema for the
+'sev-snp-guest' object.
+
++--------+-------+----------+-------------------------------------------------+
+| key                       | type  | default  | meaning                      |
++---------------------------+-------------------------------------------------+
+| policy                    | hex   | 0x30000  | a 64-bit guest policy        |
++---------------------------+-------------------------------------------------+
+| guest-visible-workarounds | string| 0        | 16-byte base64 encoded string|
+|                           |       |          | for guest OS visible         |
+|                           |       |          | workarounds.                 |
++---------------------------+-------------------------------------------------+
+
+``SNP_LAUNCH_UPDATE`` encrypts the memory region using the cryptographic context
+created via the ``SNP_LAUNCH_START`` command. If required, this command can be
+called multiple times to encrypt different memory regions. The command also
+calculates the measurement of the memory contents as it encrypts.
+
+``SNP_LAUNCH_FINISH`` finalizes the guest launch flow. Optionally, while
+finalizing the launch the firmware can perform checks on the launch digest
+computing through the ``SNP_LAUNCH_UPDATE``. To perform the check the user must
+supply the id block, authentication blob and host data that should be included
+in the attestation report. See the SEV-SNP spec for further details.
+
+The ``SNP_LAUNCH_FINISH`` uses the following parameters, which can be configured
+by the corresponding parameters documented in the QAPI schema for the
+'sev-snp-guest' object.
+
++--------------------+-------+----------+-------------------------------------+
+| key                | type  | default  | meaning                             |
++--------------------+-------+----------+-------------------------------------+
+| id-block           | string| none     | base64 encoded ID block             |
++--------------------+-------+----------+-------------------------------------+
+| id-auth            | string| none     | base64 encoded authentication       |
+|                    |       |          | information                         |
++--------------------+-------+----------+-------------------------------------+
+| auth-key-enabled   | bool  | 0        | auth block contains author key      |
++--------------------+-------+----------+-------------------------------------+
+| host_data          | string| none     | host provided data                  |
++--------------------+-------+----------+-------------------------------------+
+
+To launch a SEV-SNP guest (additional parameters are documented in the QAPI
+schema for the 'sev-snp-guest' object)::
+
+  # ${QEMU} \
+    -machine ...,confidential-guest-support=sev0 \
+    -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1
+
+
 Debugging
 ---------
 
diff --git a/qapi/qom.json b/qapi/qom.json
index 056b38f491..d2f9b05cf4 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -928,6 +928,61 @@
             '*policy': 'uint32',
             '*handle': 'uint32',
             '*legacy-vm-type': 'bool' } }
+##
+# @SevSnpGuestProperties:
+#
+# Properties for sev-snp-guest objects.  Most of these are direct
+# arguments for the KVM_SNP_* interfaces documented in the Linux
+# kernel source under
+# Documentation/arch/x86/amd-memory-encryption.rst, which are in turn
+# closely coupled with the SNP_INIT/SNP_LAUNCH_* firmware commands
+# documented in the SEV-SNP Firmware ABI Specification (Rev 0.9).
+#
+# More usage information is also available in the QEMU source tree
+# under docs/amd-memory-encryption.
+#
+# @policy: the 'POLICY' parameter to the SNP_LAUNCH_START command, as
+#     defined in the SEV-SNP firmware ABI (default: 0x30000)
+#
+# @guest-visible-workarounds: 16-byte, base64-encoded blob to report
+#     hypervisor-defined workarounds, corresponding to the 'GOSVW'
+#     parameter of the SNP_LAUNCH_START command defined in the SEV-SNP
+#     firmware ABI (default: all-zero)
+#
+# @id-block: 96-byte, base64-encoded blob to provide the 'ID Block'
+#     structure for the SNP_LAUNCH_FINISH command defined in the
+#     SEV-SNP firmware ABI (default: all-zero)
+#
+# @id-auth: 4096-byte, base64-encoded blob to provide the 'ID
+#     Authentication Information Structure' for the SNP_LAUNCH_FINISH
+#     command defined in the SEV-SNP firmware ABI (default: all-zero)
+#
+# @auth-key-enabled: true if 'id-auth' blob contains the 'AUTHOR_KEY'
+#     field defined SEV-SNP firmware ABI (default: false)
+#
+# @host-data: 32-byte, base64-encoded, user-defined blob to provide to
+#     the guest, as documented for the 'HOST_DATA' parameter of the
+#     SNP_LAUNCH_FINISH command in the SEV-SNP firmware ABI (default:
+#     all-zero)
+#
+# @vcek-disabled: Guests are by default allowed to choose between VLEK
+#     (Versioned Loaded Endorsement Key) or VCEK (Versioned Chip
+#     Endorsement Key) when requesting attestation reports from
+#     firmware. Set this to true to disable the use of VCEK.
+#     (default: false) (since: 9.1)
+#
+# Since: 9.1
+##
+{ 'struct': 'SevSnpGuestProperties',
+  'base': 'SevCommonProperties',
+  'data': {
+            '*policy': 'uint64',
+            '*guest-visible-workarounds': 'str',
+            '*id-block': 'str',
+            '*id-auth': 'str',
+            '*auth-key-enabled': 'bool',
+            '*host-data': 'str',
+            '*vcek-disabled': 'bool' } }
 
 ##
 # @ThreadContextProperties:
@@ -1007,6 +1062,7 @@
     { 'name': 'secret_keyring',
       'if': 'CONFIG_SECRET_KEYRING' },
     'sev-guest',
+    'sev-snp-guest',
     'thread-context',
     's390-pv-guest',
     'throttle-group',
@@ -1077,6 +1133,7 @@
       'secret_keyring':             { 'type': 'SecretKeyringProperties',
                                       'if': 'CONFIG_SECRET_KEYRING' },
       'sev-guest':                  'SevGuestProperties',
+      'sev-snp-guest':              'SevSnpGuestProperties',
       'thread-context':             'ThreadContextProperties',
       'throttle-group':             'ThrottleGroupProperties',
       'tls-creds-anon':             'TlsCredsAnonProperties',
diff --git a/target/i386/sev.c b/target/i386/sev.c
index c141f4fed4..841b45f59b 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -42,6 +42,7 @@
 
 OBJECT_DECLARE_TYPE(SevCommonState, SevCommonStateClass, SEV_COMMON)
 OBJECT_DECLARE_TYPE(SevGuestState, SevGuestStateClass, SEV_GUEST)
+OBJECT_DECLARE_TYPE(SevSnpGuestState, SevSnpGuestStateClass, SEV_SNP_GUEST)
 
 struct SevCommonState {
     X86ConfidentialGuest parent_obj;
@@ -100,8 +101,26 @@ struct SevGuestStateClass {
     SevCommonStateClass parent_class;
 };
 
+struct SevSnpGuestState {
+    SevCommonState parent_obj;
+
+    /* configuration parameters */
+    char *guest_visible_workarounds;
+    char *id_block;
+    char *id_auth;
+    char *host_data;
+
+    struct kvm_sev_snp_launch_start kvm_start_conf;
+    struct kvm_sev_snp_launch_finish kvm_finish_conf;
+};
+
+struct SevSnpGuestStateClass {
+    SevCommonStateClass parent_class;
+};
+
 #define DEFAULT_GUEST_POLICY    0x1 /* disable debug */
 #define DEFAULT_SEV_DEVICE      "/dev/sev"
+#define DEFAULT_SEV_SNP_POLICY  0x30000
 
 #define SEV_INFO_BLOCK_GUID     "00f771de-1a7e-4fcb-890e-68c77e2fb44e"
 typedef struct __attribute__((__packed__)) SevInfoBlock {
@@ -1505,11 +1524,249 @@ static const TypeInfo sev_guest_info = {
     .class_init = sev_guest_class_init,
 };
 
+static void
+sev_snp_guest_get_policy(Object *obj, Visitor *v, const char *name,
+                         void *opaque, Error **errp)
+{
+    visit_type_uint64(v, name,
+                      (uint64_t *)&SEV_SNP_GUEST(obj)->kvm_start_conf.policy,
+                      errp);
+}
+
+static void
+sev_snp_guest_set_policy(Object *obj, Visitor *v, const char *name,
+                         void *opaque, Error **errp)
+{
+    visit_type_uint64(v, name,
+                      (uint64_t *)&SEV_SNP_GUEST(obj)->kvm_start_conf.policy,
+                      errp);
+}
+
+static char *
+sev_snp_guest_get_guest_visible_workarounds(Object *obj, Error **errp)
+{
+    return g_strdup(SEV_SNP_GUEST(obj)->guest_visible_workarounds);
+}
+
+static void
+sev_snp_guest_set_guest_visible_workarounds(Object *obj, const char *value,
+                                            Error **errp)
+{
+    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
+    struct kvm_sev_snp_launch_start *start = &sev_snp_guest->kvm_start_conf;
+    g_autofree guchar *blob;
+    gsize len;
+
+    g_free(sev_snp_guest->guest_visible_workarounds);
+
+    /* store the base64 str so we don't need to re-encode in getter */
+    sev_snp_guest->guest_visible_workarounds = g_strdup(value);
+
+    blob = qbase64_decode(sev_snp_guest->guest_visible_workarounds,
+                          -1, &len, errp);
+    if (!blob) {
+        return;
+    }
+
+    if (len != sizeof(start->gosvw)) {
+        error_setg(errp, "parameter length of %lu exceeds max of %lu",
+                   len, sizeof(start->gosvw));
+        return;
+    }
+
+    memcpy(start->gosvw, blob, len);
+}
+
+static char *
+sev_snp_guest_get_id_block(Object *obj, Error **errp)
+{
+    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
+
+    return g_strdup(sev_snp_guest->id_block);
+}
+
+static void
+sev_snp_guest_set_id_block(Object *obj, const char *value, Error **errp)
+{
+    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
+    struct kvm_sev_snp_launch_finish *finish = &sev_snp_guest->kvm_finish_conf;
+    gsize len;
+
+    g_free(sev_snp_guest->id_block);
+    g_free((guchar *)finish->id_block_uaddr);
+
+    /* store the base64 str so we don't need to re-encode in getter */
+    sev_snp_guest->id_block = g_strdup(value);
+
+    finish->id_block_uaddr =
+        (uint64_t)qbase64_decode(sev_snp_guest->id_block, -1, &len, errp);
+
+    if (!finish->id_block_uaddr) {
+        return;
+    }
+
+    if (len != KVM_SEV_SNP_ID_BLOCK_SIZE) {
+        error_setg(errp, "parameter length of %lu not equal to %u",
+                   len, KVM_SEV_SNP_ID_BLOCK_SIZE);
+        return;
+    }
+
+    finish->id_block_en = (len) ? 1 : 0;
+}
+
+static char *
+sev_snp_guest_get_id_auth(Object *obj, Error **errp)
+{
+    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
+
+    return g_strdup(sev_snp_guest->id_auth);
+}
+
+static void
+sev_snp_guest_set_id_auth(Object *obj, const char *value, Error **errp)
+{
+    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
+    struct kvm_sev_snp_launch_finish *finish = &sev_snp_guest->kvm_finish_conf;
+    gsize len;
+
+    g_free(sev_snp_guest->id_auth);
+    g_free((guchar *)finish->id_auth_uaddr);
+
+    /* store the base64 str so we don't need to re-encode in getter */
+    sev_snp_guest->id_auth = g_strdup(value);
+
+    finish->id_auth_uaddr =
+        (uint64_t)qbase64_decode(sev_snp_guest->id_auth, -1, &len, errp);
+
+    if (!finish->id_auth_uaddr) {
+        return;
+    }
+
+    if (len > KVM_SEV_SNP_ID_AUTH_SIZE) {
+        error_setg(errp, "parameter length:ID_AUTH %lu exceeds max of %u",
+                   len, KVM_SEV_SNP_ID_AUTH_SIZE);
+        return;
+    }
+}
+
+static bool
+sev_snp_guest_get_auth_key_en(Object *obj, Error **errp)
+{
+    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
+
+    return !!sev_snp_guest->kvm_finish_conf.auth_key_en;
+}
+
+static void
+sev_snp_guest_set_auth_key_en(Object *obj, bool value, Error **errp)
+{
+    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
+
+    sev_snp_guest->kvm_finish_conf.auth_key_en = value;
+}
+
+static bool
+sev_snp_guest_get_vcek_disabled(Object *obj, Error **errp)
+{
+    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
+
+    return !!sev_snp_guest->kvm_finish_conf.vcek_disabled;
+}
+
+static void
+sev_snp_guest_set_vcek_disabled(Object *obj, bool value, Error **errp)
+{
+    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
+
+    sev_snp_guest->kvm_finish_conf.vcek_disabled = value;
+}
+
+static char *
+sev_snp_guest_get_host_data(Object *obj, Error **errp)
+{
+    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
+
+    return g_strdup(sev_snp_guest->host_data);
+}
+
+static void
+sev_snp_guest_set_host_data(Object *obj, const char *value, Error **errp)
+{
+    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
+    struct kvm_sev_snp_launch_finish *finish = &sev_snp_guest->kvm_finish_conf;
+    g_autofree guchar *blob;
+    gsize len;
+
+    g_free(sev_snp_guest->host_data);
+
+    /* store the base64 str so we don't need to re-encode in getter */
+    sev_snp_guest->host_data = g_strdup(value);
+
+    blob = qbase64_decode(sev_snp_guest->host_data, -1, &len, errp);
+
+    if (!blob) {
+        return;
+    }
+
+    if (len != sizeof(finish->host_data)) {
+        error_setg(errp, "parameter length of %lu not equal to %lu",
+                   len, sizeof(finish->host_data));
+        return;
+    }
+
+    memcpy(finish->host_data, blob, len);
+}
+
+static void
+sev_snp_guest_class_init(ObjectClass *oc, void *data)
+{
+    object_class_property_add(oc, "policy", "uint64",
+                              sev_snp_guest_get_policy,
+                              sev_snp_guest_set_policy, NULL, NULL);
+    object_class_property_add_str(oc, "guest-visible-workarounds",
+                                  sev_snp_guest_get_guest_visible_workarounds,
+                                  sev_snp_guest_set_guest_visible_workarounds);
+    object_class_property_add_str(oc, "id-block",
+                                  sev_snp_guest_get_id_block,
+                                  sev_snp_guest_set_id_block);
+    object_class_property_add_str(oc, "id-auth",
+                                  sev_snp_guest_get_id_auth,
+                                  sev_snp_guest_set_id_auth);
+    object_class_property_add_bool(oc, "auth-key-enabled",
+                                   sev_snp_guest_get_auth_key_en,
+                                   sev_snp_guest_set_auth_key_en);
+    object_class_property_add_bool(oc, "vcek-required",
+                                   sev_snp_guest_get_vcek_disabled,
+                                   sev_snp_guest_set_vcek_disabled);
+    object_class_property_add_str(oc, "host-data",
+                                  sev_snp_guest_get_host_data,
+                                  sev_snp_guest_set_host_data);
+}
+
+static void
+sev_snp_guest_instance_init(Object *obj)
+{
+    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
+
+    /* default init/start/finish params for kvm */
+    sev_snp_guest->kvm_start_conf.policy = DEFAULT_SEV_SNP_POLICY;
+}
+
+/* guest info specific to sev-snp */
+static const TypeInfo sev_snp_guest_info = {
+    .parent = TYPE_SEV_COMMON,
+    .name = TYPE_SEV_SNP_GUEST,
+    .instance_size = sizeof(SevSnpGuestState),
+    .class_init = sev_snp_guest_class_init,
+    .instance_init = sev_snp_guest_instance_init,
+};
+
 static void
 sev_register_types(void)
 {
     type_register_static(&sev_common_info);
     type_register_static(&sev_guest_info);
+    type_register_static(&sev_snp_guest_info);
 }
 
 type_init(sev_register_types);
diff --git a/target/i386/sev.h b/target/i386/sev.h
index 668374eef3..bedc667eeb 100644
--- a/target/i386/sev.h
+++ b/target/i386/sev.h
@@ -22,6 +22,7 @@
 
 #define TYPE_SEV_COMMON "sev-common"
 #define TYPE_SEV_GUEST "sev-guest"
+#define TYPE_SEV_SNP_GUEST "sev-snp-guest"
 
 #define SEV_POLICY_NODBG        0x1
 #define SEV_POLICY_NOKS         0x2
-- 
2.34.1


