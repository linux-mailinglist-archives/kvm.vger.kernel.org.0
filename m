Return-Path: <kvm+bounces-40298-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DF30EA55ACA
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 00:12:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC7DC3A8562
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 23:12:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09A3927F4CA;
	Thu,  6 Mar 2025 23:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Cl0Q4Bd1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2043.outbound.protection.outlook.com [40.107.236.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8883427E1A5;
	Thu,  6 Mar 2025 23:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741302697; cv=fail; b=Qtb6jcQ1nyJ95tKnj7BB4jgYRbElqKHnonL7SMRf8TrxG6G1dMveblYu5fHqD76Y0mdDIPX8rmiVVptB4YadEFdR15UOTJHnc5WJwES+QqKO7fVk+pttjRsS1setIUuex23iBnpe6WgWyh1ENI5WMae9LYHvxA2u7rvE1IRTW2U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741302697; c=relaxed/simple;
	bh=LTlAm50khwx7MyGHDUe/J9IemorC42ny7oeVhuaTFEE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bvJoD0bd3VLy2e2MunTqu39H0fAHqXyFXHmcV1g8Hzd3LxOHASPM4oDgTshCbhS+BUhfZvfGc+JH5YLysF9JSuQTbzGBD94J1M9e6hMXjgZ1+BYWo+mSVZgbdOnFB4QiZdnl9wGv1YZFbQI4neZIaubnrBv9cIHyb50W6LCzqLc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Cl0Q4Bd1; arc=fail smtp.client-ip=40.107.236.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eVzH8ZRxkXdoEYuMRHCJ0bv6/a/4Sy5vjgHiI6qlPqYTFn6SKe6dSi85G0aInDDDVuoJjCAabqmia8KvPKm+471r7DepXpJ1ta7G9r4Ro0qaMnP1RRExtDge+TSh/iwVafy1eCzYTqdOPkvBInRxB94lX8IPxe/uc3xvsehFY6/dD/vxqCOhp/NwJPLy9q2NWS3o6PH5SnpqEbbph44VaR4jmmdpqdgGOxqGXt1+gHOfx90BGmAd5O+Wtf5a5ZZ6Tpme0snOEETzGAFkYykrA11/jCs59xLxpglbqTATehJKIE9DMbxIsNh/eHh/9nWW/L6kSMEoW6cMoYXKZ8i+Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2cNuKj6mGvdKVap2fHNknx2ahhzqXtraUwGyw/xoIZ4=;
 b=vPtmQKKkBCJkkNgkhXfsHfTQrUgdpbtad4LomL6eOjSy7fB9hQ1RDuz+4UtXnnVV8hhEWrCM1av9SkVkLnvdS1oUlkJsbpBWLzflv4yGGfKhcKayp1H44d18lWmrKkPoPzcc0zKa3nBwEkA8dBZlcwIe6yqRT7v4zWCn4jukCVVZJ+qrSEO8GCTWPUJflffs5YkAZOzBHnK8SGlYK7kZy81f66nsZQRV73nN15+Gi2myXgVOqQcM6alSzdXTX/lMS1NnuS7ey6ACKyXHP0f8Ktx0T4Mj+jLpHBWIXBAI11y4JiNffitMbV1xMfA+PC+ouGmLXHSta7fxw4iFgxwY0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2cNuKj6mGvdKVap2fHNknx2ahhzqXtraUwGyw/xoIZ4=;
 b=Cl0Q4Bd1e9dBL+y73JKxTi7rDJRmcSvWvtEug0ZRORv9RR9eF4ydVd4zS2BEa8CpVCGsHocvQOZ8YsXSv3RW8jXdtaX41Rebep7OjngoTwqkng0yqgHwppcJVx51mFLWdTFyoJlAr+KXFITib3K8su2SkQZmVHXEsT0P1w80Riw=
Received: from SN7PR04CA0179.namprd04.prod.outlook.com (2603:10b6:806:125::34)
 by SN7PR12MB8103.namprd12.prod.outlook.com (2603:10b6:806:355::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.22; Thu, 6 Mar
 2025 23:11:29 +0000
Received: from SN1PEPF000397AE.namprd05.prod.outlook.com
 (2603:10b6:806:125:cafe::5c) by SN7PR04CA0179.outlook.office365.com
 (2603:10b6:806:125::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.18 via Frontend Transport; Thu,
 6 Mar 2025 23:11:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000397AE.mail.protection.outlook.com (10.167.248.52) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8511.15 via Frontend Transport; Thu, 6 Mar 2025 23:11:29 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 6 Mar
 2025 17:11:27 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<aik@amd.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH v6 8/8] crypto: ccp: Move SEV/SNP Platform initialization to KVM
Date: Thu, 6 Mar 2025 23:11:19 +0000
Message-ID: <9bd5f652bd8a41a91cf296658c1f62142d56319a.1741300901.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1741300901.git.ashish.kalra@amd.com>
References: <cover.1741300901.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000397AE:EE_|SN7PR12MB8103:EE_
X-MS-Office365-Filtering-Correlation-Id: 2fbdf2f1-5d54-43f9-7622-08dd5d043a0a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|1800799024|36860700013|376014|7053199007|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dL4bS9YQ8CZSJN/Vn54qCK5R3Z3D2+yMXbvn8Mp3WF/+d/R+HltPKU+nKefX?=
 =?us-ascii?Q?r2AizsgqTLphulo51BwwGKTXFqTQoAMKc2Rdbfk6b+gvn3Y1YsRm+PNar2+K?=
 =?us-ascii?Q?ki6c42MvIlx9Ks5FgmD+wu6P1yjgAdsg4eB0jnNLa3FLYpZQCB96I/ZfUgOV?=
 =?us-ascii?Q?mE6YbP39qXzP0kpLQd805PUDAQIdbE1mAq618mkcNiXQ+LgXhHiA9La85ylS?=
 =?us-ascii?Q?Am/Eqc9P9NC4IT6fSYK6LdSmy3tQzOLvrw9J2g8N6IjKxcX7pTLx/vKoGBFP?=
 =?us-ascii?Q?WA8b56J66IqD0UjvL2ZbcK1N1+DbsUp3bBgpaeTjl+gMX2gLEF+aiyXxCYJ7?=
 =?us-ascii?Q?kFkpPnmOL99Dsfr9AiDdQpZ+3o98tAbKtnx0V8rRim2DtIIEwB1DE1d8oEoO?=
 =?us-ascii?Q?EI2coc3gU+JRzxay4XhE5QSoqQ+4vPSUeG+8xrkNW1Q7CiZ37caf0sU+WfrN?=
 =?us-ascii?Q?rDhywFpzv9aIk/F04Tpo5OFNGebNjlYU0pc7O5Nlt1GN87i0GghzBNoxHerw?=
 =?us-ascii?Q?ZIyD3GTUs95kBcOu6/8mE5+8rcvVvCUbPpH+Qq8ghk3iFwWI6PUj4UeGp240?=
 =?us-ascii?Q?faoXTzqk+s+q1TVXLL/Wnm5YI3tbkxTNZReet5Uwp188V1qiy7GOAmv3SWig?=
 =?us-ascii?Q?q1MlObHm5muStIV6YxBQ6PMcv8P8IWibNZ290xmVlPib+7kT7akMbU7qrcH1?=
 =?us-ascii?Q?d0G1m77kDyCYkOEcj8m04fO/zaikA+WyVqdzwwEKdr9OyVC+dLqdQXuORYd4?=
 =?us-ascii?Q?mjO1y/TD4eOviY8HUyveHQ4gkI3L75go0xq+VNGIht1HDO1AbHqXFxVen7PH?=
 =?us-ascii?Q?0f0nmb151XWu4F9XdI6IPnmmotsUQIE5xhYn7BgmT1yVr8LDkOOSeuG9HGlo?=
 =?us-ascii?Q?k8skpwDan0QU29o5U0rLKh5eLiNCNckCW2Q/XNARrN1rvNcUDXCjt7KsRZnt?=
 =?us-ascii?Q?YRZ6lpERWvToBIHtEL/Bagm3aTpO8U/+wGjIrywpde/aYGOw5/kK2mF3pm2E?=
 =?us-ascii?Q?xPJcqnRzW+jkAb6WTaMouJv7TkyeCPrDl+lFUbZaPB9e5dwKau0tp8fbgNFl?=
 =?us-ascii?Q?gdOTI1K4nb3N0SZhtDmGjsyNEzmp588E0603G7i4PqNxJQDOvZclOuUUVlzv?=
 =?us-ascii?Q?tl/4hTPNh1GCmNk1AMbfvdV8S9SZhGvesO+GTEMEG0h9CSSxlpjgtQueaK85?=
 =?us-ascii?Q?LJjnB0O/ow6dj3OZpZ6UvJ8puLEiaEiXiSiSDadhW/kiEPvm3JdFOmcAZive?=
 =?us-ascii?Q?DeDMAb95nuIQfHXNK9TNKXT37Nii4EAO4yaeBXncMOzp7+ucckt3vnsQbgeH?=
 =?us-ascii?Q?uYk0SWZmecU5AjuIpi6yC6VuvZ8pCW79hWiK6LIPSd+kxz2raaJPxJxXKYUk?=
 =?us-ascii?Q?TICAwu3D29C2UzF7gFOej0cLiyOutbQcmPIrTMW7uFu1M5xNWel46hV00C66?=
 =?us-ascii?Q?EwahmVYN/gzoUr/9TBrVDjQNVbF8/odjDb4sCM3A68oKcIYycwMKAMVetzaU?=
 =?us-ascii?Q?pCY7n2UUNHNtMpKjpIemVDc/CKv+Brb2JpkK?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(1800799024)(36860700013)(376014)(7053199007)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2025 23:11:29.0557
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fbdf2f1-5d54-43f9-7622-08dd5d043a0a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397AE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8103

From: Ashish Kalra <ashish.kalra@amd.com>

SNP initialization is forced during PSP driver probe purely because SNP
can't be initialized if VMs are running.  But the only in-tree user of
SEV/SNP functionality is KVM, and KVM depends on PSP driver for the same.
Forcing SEV/SNP initialization because a hypervisor could be running
legacy non-confidential VMs make no sense.

This patch removes SEV/SNP initialization from the PSP driver probe
time and moves the requirement to initialize SEV/SNP functionality
to KVM if it wants to use SEV/SNP.

Suggested-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Alexey Kardashevskiy <aik@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 671347702ae7..980b3d296dc6 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1347,10 +1347,6 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
 	if (sev->state == SEV_STATE_INIT)
 		return 0;
 
-	/*
-	 * Legacy guests cannot be running while SNP_INIT(_EX) is executing,
-	 * so perform SEV-SNP initialization at probe time.
-	 */
 	rc = __sev_snp_init_locked(&args->error);
 	if (rc && rc != -ENODEV)
 		return rc;
@@ -2524,9 +2520,7 @@ EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
 void sev_pci_init(void)
 {
 	struct sev_device *sev = psp_master->sev_data;
-	struct sev_platform_init_args args = {0};
 	u8 api_major, api_minor, build;
-	int rc;
 
 	if (!sev)
 		return;
@@ -2549,13 +2543,6 @@ void sev_pci_init(void)
 			 api_major, api_minor, build,
 			 sev->api_major, sev->api_minor, sev->build);
 
-	/* Initialize the platform */
-	args.probe = true;
-	rc = sev_platform_init(&args);
-	if (rc)
-		dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
-			args.error, rc);
-
 	return;
 
 err:
-- 
2.34.1


