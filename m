Return-Path: <kvm+bounces-21835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E8A38934D6F
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 14:50:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C1AA1F23330
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 12:50:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C890913C80B;
	Thu, 18 Jul 2024 12:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hIh81Z+e"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2080.outbound.protection.outlook.com [40.107.220.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F29954645
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 12:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721307041; cv=fail; b=hYDvF4MD3gAwL+QVNeLH3BkCuKx3xJ3j7arpJ613qVZbGe5FR1A4zqfJhbeTa52bI+nE4GP6RoitJMDE3yflleML+6/zjnewKQT8idhQW+RfeBou/brQdABNmKt4RGymteulOTHgsGAjGL1TPzFHQCbBZf2LiDe4ysv+mvRIRsw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721307041; c=relaxed/simple;
	bh=dRrAiEqGJ+PFxU2SacRPYf+eNnpT3zSs1Rj7qiNZ96A=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g/qZDeL7gZSdg5wSmquJY+inEYSkrCV55wzJD57fYc1QMo04h+r+10dV7rPAp46vqHOA0LvP8Snbts+fIwRqqEPzX3ypfr/JggwCVmvqyYZpDdT4b/99Tw60K52e9dLrsR8J8Yo+CGMt/lfdkWfXesiZXklEqNXzBnMxWLhTT14=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hIh81Z+e; arc=fail smtp.client-ip=40.107.220.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vEmVpfJwMGB/gBYpXLBdKo+nEj/vCAGFINH4AIW5+Qr8kiSHvsWPzRTRDYXwn6LQDSPrwMPu5jUiFDOKq0BONwG38Nl4OscN0WkChTuIjKwu513ytytWAvL5Z5L8/qvy/8MQTOayLmWqFM3uWPY3svu91MR+rF5JDxcUqZQLbm/26LOGBaQJEjupJAPda4J7DQTO7Y0+urCOQMGMuWJdReyVIux4t+bu3SaZ8DvIACVWPtMmB66fN+ZMdC5qjkgTw126G3njU20ofuq2oQ7RCOInnBwaOFOnH2oMo+XHieeRX+anFNYy1FlgvgUIa85SYs43r+cxYRzuxsStVOqYag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RQuSzXTYrrcnVDxg+JYjiTIRf/yuHkD0Ayi2lk30Wes=;
 b=Ff8WALyPxpZIQigmbuT8MAQXQhP7MeLXaurFRYzGvP8wEqnXiF4l752hgShWdw0+qmjWXNyPC85B/87XbF8oXNqPHz64CeW6PNS/986F+ok5LJaHfBMbZS5ELAi8tft/EM4F1cyVxzsMEfWFRofZsXzQq2qNOTdc/zYVUTiC8xMvoMue/2Rh3USwzfY1WUjy+UWgGzmiUHq+f3DezOB2p12bNaR4Hwtgm0CrrU5iV5fuXNTMpTnS/bbavhZUxw0fnRVAnwlgFpuYlR1ksPn8mqlJw0811PtKvaRxF92bB525nPI8h3ZGgf9Kdwf+7PMZ6BFtcIDcBpaVeQX1CMorkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RQuSzXTYrrcnVDxg+JYjiTIRf/yuHkD0Ayi2lk30Wes=;
 b=hIh81Z+eLlA0XLEFu4CO1T2yPGWTK6MyGJ2qQoGxW2BckHepwGDk27ZCK4z1SXtWSh2l56WCRFTUUP3PBQr//WTn65zPBqVjKR3kcuNOhC5odnUX4CIGRRSBnv6tw2KV0PmXlM1pnHkWjjJBmz07FPywxcr91fviTWIeLU18y5U=
Received: from CH2PR17CA0008.namprd17.prod.outlook.com (2603:10b6:610:53::18)
 by CH2PR12MB4198.namprd12.prod.outlook.com (2603:10b6:610:7e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.29; Thu, 18 Jul
 2024 12:50:34 +0000
Received: from CH3PEPF00000012.namprd21.prod.outlook.com
 (2603:10b6:610:53:cafe::e4) by CH2PR17CA0008.outlook.office365.com
 (2603:10b6:610:53::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.17 via Frontend
 Transport; Thu, 18 Jul 2024 12:50:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF00000012.mail.protection.outlook.com (10.167.244.117) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7784.5 via Frontend Transport; Thu, 18 Jul 2024 12:50:34 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 18 Jul
 2024 07:50:33 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christophersen
	<seanjc@google.com>, Michael Roth <michael.roth@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>, "Kim
 Phillips" <kim.phillips@amd.com>, Vasant Karasulli <vkarasulli@suse.de>
Subject: [kvm-unit-tests PATCH v2 04/16] x86/efi: Add support for running tests with UEFI in SEV-SNP environment
Date: Thu, 18 Jul 2024 07:49:20 -0500
Message-ID: <20240718124932.114121-5-papaluri@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240718124932.114121-1-papaluri@amd.com>
References: <20240718124932.114121-1-papaluri@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF00000012:EE_|CH2PR12MB4198:EE_
X-MS-Office365-Filtering-Correlation-Id: b1389027-174b-4503-33df-08dca72836e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ugk/poECxXF/MHPotrMIo4M3O93M0Dm5GxpyiruWuFoqMJ3pwBJyrZP7P2Qu?=
 =?us-ascii?Q?SyMB9W1ir6GUJaNioJHRlOJ8xlEw+wvBTblBREuipDx9xVIrdcGTVUAIV8TH?=
 =?us-ascii?Q?A3C/Vu894sJIEb9XOX4h335yxabgRy2pdCZQW2ZKhsS9Wsq8C9r6MY5NZSue?=
 =?us-ascii?Q?G/O2aflR8US4P79Df36j2FZCy+jTX+8NEpkcxmyU9Ch3ZFgAPX0Lkg2sNInt?=
 =?us-ascii?Q?uDD4wbnUeKH+4VkkYFzazMTFQHLAzy2gVoipln5505+NOFM966G3rxeUPbHA?=
 =?us-ascii?Q?cl/vgiSxU3TRwyDkAnF2/DOhURnIz4664VxqtTUN/LSwP13cipJZah8hvBtX?=
 =?us-ascii?Q?0WzGIaaywN0/BFV6uWbHV9yXca/EWeoQrnjxGIDpGPKA3rB5yKIfIDgOw5oo?=
 =?us-ascii?Q?ZioBCWCGxOfxaYEKsv/1aW2UjA/kdE94NsWBLuk4th6Ssn6GlPrR8H436iQK?=
 =?us-ascii?Q?mGuj5agyBHbUoIoaj9MFelHGun3iNZM+s98NFXrjIjBw+ATkfLIsCLY7llzW?=
 =?us-ascii?Q?6jg/ihUqe+cFL2RnB2R2luLbK4iGu6jI2t/AoJ70hFbUSW55jt234Pj0wPNa?=
 =?us-ascii?Q?v5iX432fjAF0ZqjrawIH4vaVWX01C2lDJ8rT8yny7oMw/A2DDYRKCStkL3nb?=
 =?us-ascii?Q?T20QNsoAIKH5d1Cw1rS87pnkqWS0t2cOkCEFN31jxADIZjXc8uSQrBAWRE7c?=
 =?us-ascii?Q?xjVdIlVCdvz5wdGPk1oRos+Ko7D/2QUKK189c/36VzR0rX4f3Dul6iLJdzCe?=
 =?us-ascii?Q?ojqZRuiJbYTrDV/bCGyVP/Vu25VyRq/rBhvED2pRncmXTwAxbgOG+zyXk4YW?=
 =?us-ascii?Q?/cgqShgs0Z7JExD2DDsuUQpD/V45SNFH5SGvv2piBGIqbxGxL1f4N+5shbgx?=
 =?us-ascii?Q?91UvoT1tbzCUiQo1LJ2qkusZO91+G7PLDfcnFbEcLTO7d2b/AAzU2PDWC1kg?=
 =?us-ascii?Q?OM4a/KpvDF++7xuxZnWqjylssrT5cCTjDvPNqXKJ3snn4JdcWX/TjWk21BfJ?=
 =?us-ascii?Q?WnLKrWuL82hSvc77jGSXiErUbu2H0rhNblf+87xkp45Bx6g4+gR5rMHlXnbm?=
 =?us-ascii?Q?4sAMYiPnXwyqk0V/s3QPr7q9cRWV9twH8mmHNGnvVyhdl63S1EcYaaKiU1NS?=
 =?us-ascii?Q?bgSSfyHloa76akBUfum29CVex3d4cH9fUo/OazwHKsT/BKTCncNU1GbAlWbo?=
 =?us-ascii?Q?viio1Nr7/h5AuTs+NW5OWu99bZbWEMB1DztlaX893faZDUNAEwGZoUEA3DH8?=
 =?us-ascii?Q?ZeGzA3z6Hj4G1m4ACN+PRFkU6+83doP6OcSqkkf3VyCR8pwZ/Shfxz4295lM?=
 =?us-ascii?Q?0e4IXtfOOjLydlpU+2M/jqdO+5JHiuc+uXd9n0UDqYGxiex8YKugMlhXtAjM?=
 =?us-ascii?Q?rYvnhFnFgfN5UVX7poeSP6SO7YOrahMAhXQBgxzxmew5Uf0AoOpKFWo6Uelq?=
 =?us-ascii?Q?lk9zGSeGl9pKCtJyGIFzfL6XJUjVhFgr?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2024 12:50:34.0417
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b1389027-174b-4503-33df-08dca72836e6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000012.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4198

SEV-SNP guests require different QEMU command line parameters in
comparison to SEV-ES, so adjust the QEMU options accordingly. It is
important to note that SEV-SNP guests have some additional requirements
versus an SEV/SEV-ES guest:
  - bios: SEV-SNP guests need a UEFI BIOS, and unlike with SEV-ES they
	  cannot be loaded via pflash and instead rely on -bios option.
  - cpu:  guest CPUID values are validated by SEV-SNP firmware and only
	  a strictly-validated set of features should be advertised to the
	  guest. This will usually require the use of an updated/architected
          QEMU CPU model version. "-cpu EPYC-v4" is used here as it has
          most common set of features compared to EPYC-Milan*/EPYC-Turin*/etc.
	  models.
  - memory-backend-memfd: To support freeing memory after it is
	  converted from shared->private, QEMU relies on
	  memory that can be discarded via FALLOC_FL_PUNCH_HOLE, which
	  is provided via object memory-backend-memfd.

Add these options to the QEMU cmdline (in x86/eri/run) for bringing up
SEV-SNP guest only when EFI_SNP is enabled.

Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
---
 x86/efi/README.md |  6 ++++++
 x86/efi/run       | 33 +++++++++++++++++++++++++--------
 2 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/x86/efi/README.md b/x86/efi/README.md
index af6e339c2cca..2c61dba336ec 100644
--- a/x86/efi/README.md
+++ b/x86/efi/README.md
@@ -34,6 +34,12 @@ the env variable `EFI_UEFI`:
 
     EFI_UEFI=/path/to/OVMF.fd ./x86/efi/run ./x86/msr.efi
 
+### Run SEV-SNP tests with UEFI
+
+To run SEV-SNP related unit tests with UEFI:
+
+    EFI_SNP=y ./x86/efi/run ./x86/amd_sev.efi
+
 ## Code structure
 
 ### Code from GNU-EFI
diff --git a/x86/efi/run b/x86/efi/run
index 85aeb94fe605..da74eef4bd58 100755
--- a/x86/efi/run
+++ b/x86/efi/run
@@ -18,6 +18,7 @@ source config.mak
 : "${EFI_TEST:=efi-tests}"
 : "${EFI_SMP:=1}"
 : "${EFI_CASE:=$(basename $1 .efi)}"
+: "${EFI_SNP:=n}"
 
 if [ ! -f "$EFI_UEFI" ]; then
 	echo "UEFI firmware not found: $EFI_UEFI"
@@ -54,11 +55,27 @@ cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_BINARY"
 # to x86/run. This `smp` flag overrides any previous `smp` flags (e.g.,
 # `-smp 4`). This is necessary because KVM-Unit-Tests do not currently support
 # SMP under UEFI. This last flag should be removed when this issue is resolved.
-"$TEST_DIR/run" \
-	-drive file="$EFI_UEFI",format=raw,if=pflash,readonly=on \
-	-drive file.dir="$EFI_TEST/$EFI_CASE/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
-	-net none \
-	-nographic \
-	-m 256 \
-	"$@" \
-	-smp "$EFI_SMP"
+if [ "$EFI_SNP" != "y" ]; then
+	"$TEST_DIR/run" \
+		-drive file="$EFI_UEFI",format=raw,if=pflash,readonly=on \
+		-drive file.dir="$EFI_TEST/$EFI_CASE/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
+		-net none \
+		-nographic \
+		-m 256 \
+		"$@" \
+		-smp "$EFI_SMP"
+
+else
+	"$TEST_DIR/run" \
+		-bios "${EFI_UEFI}" \
+		-drive file.dir="$EFI_TEST/$EFI_CASE/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
+		-net none \
+		-nographic \
+		-m 256 \
+		-object memory-backend-memfd,id=ram1,size=256M,share=true,prealloc=false \
+		-machine q35,confidential-guest-support=sev0,memory-backend=ram1 \
+		-object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1 \
+		-cpu EPYC-v4 \
+		"$@" \
+		-smp "$EFI_SMP"
+fi
-- 
2.34.1


