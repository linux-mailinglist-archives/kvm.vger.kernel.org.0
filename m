Return-Path: <kvm+bounces-18491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C82038D598C
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 06:39:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D9915B25FE7
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 04:39:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 155C08063C;
	Fri, 31 May 2024 04:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nQiM5mja"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2040.outbound.protection.outlook.com [40.107.244.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4D080635;
	Fri, 31 May 2024 04:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717130123; cv=fail; b=h8d6YQiqZKXC3Sou5Fj4vsxRdnUjRsR5gD9EoLh0s3BSFykjlOot0bEcduqt8wBu2RJjZ5IGSklR1m/sNh9nUsFj3F2qsZL5HbVuUZ2paRGIdTCDNqQjufBhsutGBj84slEIGfhowcCzJx+LIbi5RdATzIoxe1G8EPpaFeteXKk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717130123; c=relaxed/simple;
	bh=vnPjgsazrE0DLG/RAQFERCMwjQJODdgEwWkp1VPdOSg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MYzkOtN4OGmmToxFb3zB0YK/PZ78VwGW8sAoAGJtQXTEc6XefSTsErAtfYJbOTl5/IWpSlNb73+VhTDo+nTO/vzDdf0WfkWvNtT5NVcaFxWQmYkYWFKM+h6ugVfD5s0L2rAy4fJP1/PNFcyTcVV4KrU+AWxGMEL0sy0Z9Fe6h38=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nQiM5mja; arc=fail smtp.client-ip=40.107.244.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kIVcmELYfvONud3j4LmqueE4TIrhpTUqOYt1n33zUZZbqtO/73D1QXkftYEIRzVuZ/GMVoVeq/rpStzKXyYKu6hBtKblIgAyUKeG2et3hjX7Vs1sJ78Eh683gWTh71xwTwWuhR1SuuRLIP1AeDvFfcTXxbsqcERCbykojL4rTE9PVai1nB5DmB76ublUFssox2xxCP74B3CnxTrXw334ifhN1qarztDWYXQrwpgMNiz51GEeVc5kAafjvpgSNuKfVkA5y16CAi0Px50flG4+FRzrYR2L1aC5+zXdMjJ3c0MVvJBjWsxKkBzbnB/rJZPP13N6knjhmphJGCyWMp/pWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E6Lxe5JM+FwSNitnLsD3ANphwWwHa5rTM9keIbTAN0o=;
 b=K2G6IWYePPmAMPZrkwTW0vmROcw1jtW2jF0K4MFMy5Z5wPmSHMsTpskkDRS203giuSMxHE/2Dt7idp5cBYQYyoPusr4BijttaXtCKtThJhLS5y4CYsmWg4UbZUdHnIrvp3q1UX8PKLdss+Tpr8YJJWlN4G1lIBlPGbi92UMeTf5UpDbZOEBDyvpRl8eIR9UhOXD10ExocFRLCRbBOUtf/FhXAJ4t36H+Foz9saggROKt56Xsa8WQ7lhOSmNHQl221pne5xoWKDm9xy/KmVL3i1f+smPOou/caN8q+U/y7Z0kAw49lk7jCLGUDJ2lXlCjr1gi2hAKdt6oI0ziHz6kgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E6Lxe5JM+FwSNitnLsD3ANphwWwHa5rTM9keIbTAN0o=;
 b=nQiM5mjaLhb8XVlcVS8efT/T2Pup1VcqGCRiy4A54Dwis3AC6maEZ8B3dEWCpUwJJFsSIqW9p/VeBuUzsxq6bmHGJXflzwetFjIzWdxEfALBwpPZ41NLEChR8C8DFHB7l1n7zd3aWau+Y0dz2oFh1We79dTnNDZLKp4GhtC5ozQ=
Received: from DM6PR03CA0013.namprd03.prod.outlook.com (2603:10b6:5:40::26) by
 BL1PR12MB5756.namprd12.prod.outlook.com (2603:10b6:208:393::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7633.19; Fri, 31 May 2024 04:35:19 +0000
Received: from DS3PEPF000099D4.namprd04.prod.outlook.com
 (2603:10b6:5:40:cafe::91) by DM6PR03CA0013.outlook.office365.com
 (2603:10b6:5:40::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.22 via Frontend
 Transport; Fri, 31 May 2024 04:35:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099D4.mail.protection.outlook.com (10.167.17.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Fri, 31 May 2024 04:35:19 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 23:34:50 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v9 22/24] x86/sev: Mark Secure TSC as reliable
Date: Fri, 31 May 2024 10:00:36 +0530
Message-ID: <20240531043038.3370793-23-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240531043038.3370793-1-nikunj@amd.com>
References: <20240531043038.3370793-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D4:EE_|BL1PR12MB5756:EE_
X-MS-Office365-Filtering-Correlation-Id: e857bd07-0a99-4b32-99b3-08dc812b13d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|82310400017|36860700004|376005|7416005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Bqz8vnDFXAMogvlQjFPsC3qKR/dXVL/jx5TOaio/J5HAp2KqClZU0hlkIU0F?=
 =?us-ascii?Q?CvoYsQ04VEIYTUWk8PN36HGniw8E7RotAIxUDtGeQ6tPWm6rXA8D8yHrzOYg?=
 =?us-ascii?Q?JTu7e4R8Z6NcwRbrxYNPHt+rj9EFi+OggQoHpWhIHyoLQRRrj/V78NFpO2Oc?=
 =?us-ascii?Q?lzcvABE3QF2Adh4Zo+7pwkCj47n5rJ/AaC0FO8viXUz7LK2IxCGtuxPvgAaK?=
 =?us-ascii?Q?gbIMumQDdUeMSQlUcVIbhXZM68FzpCKvxdEoteW6utOGqtS3JwqaDRgnS6Sg?=
 =?us-ascii?Q?W4g72VuWCEbXUqhtnAomzWkIww70FLC7G2k9h7hjFzCdg4yd1pDlLDlk+y6w?=
 =?us-ascii?Q?3jeFtxRZoC1NllydzOU4fpixCL06RrWdhH8J2wwnTQpBFS2lGJxhi0imhyT7?=
 =?us-ascii?Q?nPcgC9vLHnxWBeq1wuu/N8wb7cw4AcMRqjVb0fhJR1gT7cgL8rCBNZy/zOLt?=
 =?us-ascii?Q?SDCx2h29UkNAgfNk8tZw18MPmc1mWKlCSRRiPSF7bhgoDS6ltfeMD4UPIkOh?=
 =?us-ascii?Q?ibpeAmjtScpFpp3RE3gzhIS3F8TNoqva3UV0qd/YOtHYseXKhQVcUt7s3Trz?=
 =?us-ascii?Q?I8CuCpfTivfE4Gl+/cqANcAJb4LPRdHMExLynjfx6qPfT0r9ajdeWvnbl3oT?=
 =?us-ascii?Q?Vf6Kt2N1U96kmWd/PKLXRG71nSmE8BvOmZxgHdTprlEVks5F82e2B7O/EGj1?=
 =?us-ascii?Q?c5cGIxyKh3F/fXZTK6C+166XFrjtaEQZtZC0fxKTzRfIyb7TH1ihhI0sPjAR?=
 =?us-ascii?Q?8/cuS7xj83vB44AL7Sa2L8fH3vX8UJ95wQM0L/bhmQmOAK0GTxrrXnCd3tyT?=
 =?us-ascii?Q?zZ9mYVv3lrwcMeLC4eZQi+tPiz7SEZUvps/xyOU9dU+V0xT9R0yFo719EZ9y?=
 =?us-ascii?Q?+7bPx+xIeIbj0/suR+UkuYKbisNibZ6ZGXoBpMhF2YrQm0hYugoe9qZXUvEO?=
 =?us-ascii?Q?rBjdvYi/Las+pD9Aa96B2M605UJaM4l5TWTE8rGdgsF3V8FUaGk4d2QJqy1a?=
 =?us-ascii?Q?kshqx0OxqN6F1lSAtnOcUUMlE3Tw8tZebfNE+H4aPy3vJjY8cSP6IOVNz0F/?=
 =?us-ascii?Q?pQ58PIjx7RiqHUlTGGzsmUhFEY6jChoctim+oc1C5TvgZqQdcbirRoPENnC1?=
 =?us-ascii?Q?ZPw2a7PwgQ+ltcOs+uaddnau6XbLPPjYDV99E6Z9YQmiGMzDof+3Tf642R0r?=
 =?us-ascii?Q?mwvu2BDdjZpHKaaolAftnZEqlDKSlPEbCbHdZQCs9/FdfNmMy4ZKOlZES6sj?=
 =?us-ascii?Q?xHKWlm4rywuoaOokXxtcpmEzMmZBkJqHMNtfzYl5KNFa15ROQgrNDaJjHn/+?=
 =?us-ascii?Q?onuzWoBMB/PMlzqUryjJpzTW863dDrlmuTMtU2H/5tpX7EMNaduGJNS77Kiz?=
 =?us-ascii?Q?+RbrY/AJlp1IeiN7oNeUUgwtFztm?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(82310400017)(36860700004)(376005)(7416005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 04:35:19.5147
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e857bd07-0a99-4b32-99b3-08dc812b13d7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D4.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5756

AMD SNP guests may have Secure TSC feature enabled. Use the Secure TSC
as the only reliable clock source in SEV-SNP guests when enabled,
bypassing unstable calibration.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
---
 arch/x86/mm/mem_encrypt_amd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.c
index 422602f6039b..e275741eb073 100644
--- a/arch/x86/mm/mem_encrypt_amd.c
+++ b/arch/x86/mm/mem_encrypt_amd.c
@@ -510,6 +510,10 @@ void __init sme_early_init(void)
 		 */
 		x86_init.resources.dmi_setup = snp_dmi_setup;
 	}
+
+	/* Mark the TSC as reliable when Secure TSC is enabled */
+	if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
+		setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
 }
 
 void __init mem_encrypt_free_decrypted_mem(void)
-- 
2.34.1


