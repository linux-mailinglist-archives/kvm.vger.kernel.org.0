Return-Path: <kvm+bounces-41445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61D00A67DBE
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 21:08:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B4AEA177B25
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 20:08:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E82D20D4E3;
	Tue, 18 Mar 2025 20:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zsRWIM2W"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2086.outbound.protection.outlook.com [40.107.243.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B8D20FA8B;
	Tue, 18 Mar 2025 20:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742328480; cv=fail; b=o6m69s02DERI47WitOwpLpfqKbt2k1vtFp9z2b2/dJNpi4Kat5sRRDlSACRbQKnvH/0Sis5gh8BSyLNuYc++vLC+lK5j+KjnxW9OQWhCh28yi7AZq9CX7d+l1dsR/G8/wRIPnvm40OI4Rn0GV1uv0octvY/SMKXfhNsNP6R1z/Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742328480; c=relaxed/simple;
	bh=zqQQvA8CAHPPkhgO7k4KWmXl9/xaD6+oRkBhDb+o2ro=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XRO7AiRIdpI1V1I3sby52jdP35xx2wGhjMCE4Pw9yglYqqU5tFBYe2OyPH/zX1pBrr5yXn0JCPzeUVCoXt10xfZGHG/GAqPVoBus8iGuVGXbXOVRh0aG0txWq/iF1IcW0hwtPUGHYJHghkwpHz2/5PmYq3C2ceVPe2QVtSWf10U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zsRWIM2W; arc=fail smtp.client-ip=40.107.243.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J0dKsjJJ+E+OfqX/m4nwUsPPIN4FmI5HAv5JiQhOAkvWVPbwQuHoLhP03K0eqbYMBYkrvxK/NV3TyEjv1dJZ4srA2apmbk5K7rNEzhnY7iCcMeE0AorO02FzuK4W0DPFgTjQPZjiu8spoFsX2AvwSta76+Vdf+fG7J3EoAfAcmdFZD5+RDa8XXuunK8H+4OmjvwGxOgApiJzY1nDRSyvRKH21qxWHDhEQTIfpraA7H65Eq3yqWiN0uxsUdpR7HxUB/FS90YAX+CMDDt2qkwsMn/fIwRJ07I1ojTeGSaIOxqQCpwKP857qNNP/UUg7JiGIynspyiTYeOCGOTbj1uV/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FvAeSZVG6nFvmr9HhvuZDFWIRqCsCaxHOfMR/Q2dvpU=;
 b=w/WMN6DXOdd4Y6GKMMtZ9eTR0bZ1ypcFTNsTVQCx1Wf2WO6zmAHyXpyKmcjBkfFh9NCal/XiLRX2nNeMEmUoo93PWb91JJF/p20Au1YXYQdaI1xPTuAoQmSAukMZLKWrlFzIXLxgkgPag0OZTgR/r7rG73HQZPGYsg7JBsQlXqzEO1FHzlcvUtHzXDCdLfe+dra7RRnJ3+T0zQZc8u45HGwI7m53QLcjAwu8wwuU5q48/9UYP1j8DLqbzLF+tUyHeLOQpYP8hqZR98BJVTqX0Gdaoqk54GRQ4t5GCVRLjUYHIf1EN8epUX9kpQNS6qCE1YvgqrLZjO6Y7U2N4az7VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FvAeSZVG6nFvmr9HhvuZDFWIRqCsCaxHOfMR/Q2dvpU=;
 b=zsRWIM2W4vTg4hQC+Wcuvd4lTeGo7pJKxItAP2VMgYjzp4CT70q869cRvdZ3lMt2F4R18tMEbkbEZAOHb30E9/SXmZb/jeTpQm6NiNdqLUMYeAPM1Vf/rtzvhxuUOKuRY/RQ9KJJ2+c7PLLc/UBG9WE1ynVOz+vf/kbKRTW1jZE=
Received: from SJ0PR03CA0012.namprd03.prod.outlook.com (2603:10b6:a03:33a::17)
 by PH0PR12MB7472.namprd12.prod.outlook.com (2603:10b6:510:1e9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.28; Tue, 18 Mar
 2025 20:07:50 +0000
Received: from SJ1PEPF00002315.namprd03.prod.outlook.com
 (2603:10b6:a03:33a:cafe::d5) by SJ0PR03CA0012.outlook.office365.com
 (2603:10b6:a03:33a::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.31 via Frontend Transport; Tue,
 18 Mar 2025 20:07:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00002315.mail.protection.outlook.com (10.167.242.169) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8534.20 via Frontend Transport; Tue, 18 Mar 2025 20:07:49 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 18 Mar
 2025 15:07:47 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <bp@alien8.de>,
	<thomas.lendacky@amd.com>, <john.allen@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <michael.roth@amd.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH v2] crypto: ccp: Abort doing SEV INIT if SNP INIT fails
Date: Tue, 18 Mar 2025 20:07:38 +0000
Message-ID: <20250318200738.5268-1-Ashish.Kalra@amd.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002315:EE_|PH0PR12MB7472:EE_
X-MS-Office365-Filtering-Correlation-Id: d0f0dd02-a42f-492b-0a52-08dd66588ef8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CzXkdgNedj6rdVdzoEpVDMcF6lpCoehT1kyqkhnLGqXgP2zxN3Xjcd/4A1aN?=
 =?us-ascii?Q?rJco1BHbvIKdJuSo/Rd6isYvJz/gHkH4uayGTzLQ0Q0EcuxvJUOi9BPQSexF?=
 =?us-ascii?Q?f0nx6nluYn4LOSxbfQp+wDRfqu7vnqA+v/zEzo/ag711znUW692ndtT0NzZF?=
 =?us-ascii?Q?fUqfLk8unW2rBAux7LOCG2buLZkK1QXL97z7MNZn841qEOsLhQT0mSdaAmO0?=
 =?us-ascii?Q?lulvPmo7pjj82sYQrCMz8V5+3hV0mDs6Xiihm6y0cvrbkTNVW1QaIuyh/+va?=
 =?us-ascii?Q?sPeBshBiNZLHw+k3VLieWr0jc+w3kdAUnJ6U7NOm/o7NF9vL8Q6dHffmkHoU?=
 =?us-ascii?Q?uHjGM16669tZfSr3jnvsm3Eb6v/cinPto7lK2tjPD6gUc9FigEPMNbazADpS?=
 =?us-ascii?Q?giIcurhNd0G1xub/mU70/HmBx/uiJZH3YUhwL08/IozD1CaiVnh0zjdqIaNb?=
 =?us-ascii?Q?WNezF/pnFkgYXG7lPOwFgUm2N7EemKrJMW3VOl9DoB/9sZtgN3nmxhXphbr5?=
 =?us-ascii?Q?lgrvi8dV8OcmxVpyHdXqZcoaX7AwHVWBNM+5Ht8XX+F13GXVG6t4+ycRSTNE?=
 =?us-ascii?Q?IUAvdA9JRSvO9Ta5K150HDzcC2mDyCnQKPTdo4dSg7qjW2rv6OjZK6nN6GJJ?=
 =?us-ascii?Q?n1pG5Jvk07BF1d8qdijejUSlbIaBv7kVGIRqtqpEMaJcha5YVWOVQ30YLKF1?=
 =?us-ascii?Q?zBOv7bl+cepFLPZ3VmK4h8WBMok1WUbxbxnWH4+6Ha8UfBi6xl2I2M8E3v9M?=
 =?us-ascii?Q?zk6QtDH6QOsTCiuMA7fjrG0/Nz1CMAwFJiqhOeDUEaYdh781yThJy78lhwdn?=
 =?us-ascii?Q?sWf4nuNgBB44KXtKpqkv7Kgusk+9/iopX8UnIhiRlnsSFCgev+kQX54tIbg7?=
 =?us-ascii?Q?ABoHfaMnsOM92jZ86evxfbsRpT8Znd2+ivObq5AQEq+cUzlKiX8jhrixspXg?=
 =?us-ascii?Q?7+o5EplsNS6gZbWIHu9C/ozQLSJMGu0ewKuvgNGlIeg8Qgbg/iTtgrmYCeUG?=
 =?us-ascii?Q?zgGswbZowKoCG+1xmUMXRTzNFdANqm1pvSRpBjb0fB3OI1T6ixWf3zPSid1f?=
 =?us-ascii?Q?Lkksc9SGBn3KE1JngAh6X4H4p1s0YiZukcgRHUeHtIgqPyFOD9XSYSALI9YI?=
 =?us-ascii?Q?gaZLc9P9G2e372q4qaMkuEAnN6HM02GPUcPAqSlw3NErDAB7G1E5nyf84QcB?=
 =?us-ascii?Q?lSfaJ31nV3xhvZJvngFHmztXq7WXeePeYRgzIkebU2mUP8QA5jMT5E+MtcA7?=
 =?us-ascii?Q?rpdpaoh17hDFR6B0Spcipk6Ej7sCRaY9xr8EbEC+2splNBAUn1tkuKvSNo8v?=
 =?us-ascii?Q?9KirwcGDvWEQgBCZqPe3AqT1W9sLRpXVipe2sNCgSak1QBBuCyHsxSrtC7FN?=
 =?us-ascii?Q?wfOo8MzymD3PD+u21CtuUsiZQPxNduh/m3J6LFtJuKE4ZT4Wc6UlB70xgZQ3?=
 =?us-ascii?Q?iCDbOMH8XzqgqvSujQeN2RMs/v1SwhyVZVYkbOjbDNrNWDB6DoSJTcwMSU4r?=
 =?us-ascii?Q?LgT9XUoKkxfPw90=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2025 20:07:49.6847
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d0f0dd02-a42f-492b-0a52-08dd66588ef8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002315.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7472

From: Ashish Kalra <ashish.kalra@amd.com>

If SNP host support (SYSCFG.SNPEn) is set, then the RMP table must
be initialized before calling SEV INIT.

In other words, if SNP_INIT(_EX) is not issued or fails then
SEV INIT will fail if SNP host support (SYSCFG.SNPEn) is enabled.

Fixes: 1ca5614b84eed ("crypto: ccp: Add support to initialize the AMD-SP for SEV-SNP")
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>

v2:
- Fix commit logs.
---
 drivers/crypto/ccp/sev-dev.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 2e87ca0e292a..a0e3de94704e 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1112,7 +1112,7 @@ static int __sev_snp_init_locked(int *error)
 	if (!sev_version_greater_or_equal(SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR)) {
 		dev_dbg(sev->dev, "SEV-SNP support requires firmware version >= %d:%d\n",
 			SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR);
-		return 0;
+		return -EOPNOTSUPP;
 	}
 
 	/* SNP_INIT requires MSR_VM_HSAVE_PA to be cleared on all CPUs. */
@@ -1325,12 +1325,9 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
 	 */
 	rc = __sev_snp_init_locked(&args->error);
 	if (rc && rc != -ENODEV) {
-		/*
-		 * Don't abort the probe if SNP INIT failed,
-		 * continue to initialize the legacy SEV firmware.
-		 */
 		dev_err(sev->dev, "SEV-SNP: failed to INIT rc %d, error %#x\n",
 			rc, args->error);
+		return rc;
 	}
 
 	/* Defer legacy SEV/SEV-ES support if allowed by caller/module. */
-- 
2.34.1


