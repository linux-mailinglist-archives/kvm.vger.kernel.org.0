Return-Path: <kvm+bounces-15439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CF8D28AC091
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 20:08:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F35611C209E9
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 18:08:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72A623E479;
	Sun, 21 Apr 2024 18:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jNGIwzij"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2073.outbound.protection.outlook.com [40.107.95.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E903A8D2;
	Sun, 21 Apr 2024 18:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713722885; cv=fail; b=JpFjhFDvb6AO7dM9vaeZoB/ZK+F+xGTsc0WtJkznJwwyuz4XGIEZReyoXTHzWV4W+wmVC5LyHuoUmX4evWiU+6kGCHSoVTJb/3J2a9xAiN8Y/Z8Ew24GCsB6+sy3b6vDFgw9MNNb0s2GqG+6LzHjUisU3J7masNPNBIGjJ7Zblc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713722885; c=relaxed/simple;
	bh=FJCMQvRyfp5Z1IhuXUvGBSE2rK2rAfv2nhEopFQTfmA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oBxDcd8rI/1/WReUr1P+bK3rj+XkFYt7tNiw5wzorR5xg8e+7ck5/sWWpEpiWctGYbCR8YbhU8k79z8ZDhX1hzLiIMcIGd1ZcT4zr/kgrm7hRxrOhpC6on/1ciMKg2hWAomAVXLQFqOdieW028US07e/LlPD/kH51fG8y47/aC4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jNGIwzij; arc=fail smtp.client-ip=40.107.95.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aUET9UShXNzkoIumpCSTkHfkNbTLI8FoD2hpzMvjJ327upulYGzw3bJJdkXJ8zY1bj8JsonJm3Wa65ZuNKbzdS7vnqGoMwDTutQB2pSdjSoDPkhmNwiwtT5kVH8s7J5iUvHQ51YPLzf0yZ4kT0r/JzLfC3m/hHI+P+qqpVZsRtVQJQmNr0hVKqbUxi/7KT5CutZxnKaxdbyCZuj3wDptdKVQZZbgWk0lknBVttflr6vMXhBs0NfJHGwHApLcPXYXDMoQC6sLdsk2NiZkpMap/W39wmJguyw+BcxktALIz/ay13x5y2rnPL700t0c9xnBwzTUpmGyRBQuQMUgURKl2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cXRnpadbMHv81jR+cczjNT88FJu0zOLgWChtKNLc+po=;
 b=mmPxUQn63g704oM2HDmjqZrE0ovTfRwobZ4Tir+k9GSdRdUUfnItYDb1H1lviUWlpOEttneXhr6FBaKYxvUmiGtYAgFBNDVH4y4FR1UY4aziqXjagzj30rQNAuK/epQ25SZ4NwmGHey3s7J1hV1Xyf45kdmIC4SXufLSmI0p7kutnkPRiOffOi+iIWle0b040Y15fcgxTWVn3ic22Ap7dW0Wdz8MnqSpbBRuqNPN07IdYb05aK6t2KGv/9qs+QCusmQWQvS9VbO9CbRJpbiL+plzdq0JPyKRB0mOGGmBpmBqXXMNju6WgdcaHWsQMHT/+b2HLd16GLbn0Z6vlsQimw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cXRnpadbMHv81jR+cczjNT88FJu0zOLgWChtKNLc+po=;
 b=jNGIwzij1LL7OzMWrMyVixUzZqLyPKmKAE8joenzylDExAw8vvdnc9v03KuYB+Ki0jn2McxIaAVy1J4KPp6HD4YEINcPLvqqAwePERodS3Exlvg2gaFc2g+dtvoBmdpBhkfjW8Aydz7QuG2RO8vCNSK/GpXQ9a7BNIvXbNQxSdQ=
Received: from DS7PR03CA0266.namprd03.prod.outlook.com (2603:10b6:5:3b3::31)
 by PH7PR12MB8106.namprd12.prod.outlook.com (2603:10b6:510:2ba::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.39; Sun, 21 Apr
 2024 18:08:01 +0000
Received: from CY4PEPF0000FCBF.namprd03.prod.outlook.com
 (2603:10b6:5:3b3:cafe::36) by DS7PR03CA0266.outlook.office365.com
 (2603:10b6:5:3b3::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.23 via Frontend
 Transport; Sun, 21 Apr 2024 18:08:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000FCBF.mail.protection.outlook.com (10.167.242.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7519.19 via Frontend Transport; Sun, 21 Apr 2024 18:08:00 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 21 Apr
 2024 13:07:58 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: [PATCH v14 01/22] KVM: SEV: Select KVM_GENERIC_PRIVATE_MEM when CONFIG_KVM_AMD_SEV=y
Date: Sun, 21 Apr 2024 13:01:01 -0500
Message-ID: <20240421180122.1650812-2-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240421180122.1650812-1-michael.roth@amd.com>
References: <20240421180122.1650812-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCBF:EE_|PH7PR12MB8106:EE_
X-MS-Office365-Filtering-Correlation-Id: a1c03493-3d07-441d-f0f2-08dc622dfb3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kjNFs8omnqx05yyFPHINeNWf1DiSBVYTOi4Hv8QxeiuSNhfBnHh2M+vnSO5u?=
 =?us-ascii?Q?M7bE3U40N1xViU6dv8r6d/o8ItcsAIJ0soKG9DU/d77dw9kraiKbkepddsUX?=
 =?us-ascii?Q?hlsMYNzbT+mKuTKFrjeFrfyEuC0ZBa84bwtDLtuz8h0Qz9xJESen9eKosje5?=
 =?us-ascii?Q?ZfJL8bkeZD71WE/Do2UJvpOGjdzKs4kgbMDoTLf83cU5RTGaBaFpNii/8Fsc?=
 =?us-ascii?Q?pvjjFsWeShqYYEkvJmJRQik/ByWvUK0rqZ9djy7hLDRe0ct2xzPygysPq/fW?=
 =?us-ascii?Q?yDE3qF5Db6dUnjWPLoFwIeKR6VZ0iaxOoy4PRzRAgxdknt2WqU75CEOatGC7?=
 =?us-ascii?Q?HKiBl7TOPesnt2dtsabjmjuxDRj2M2xhxUNqONCucOlh+M1jPJmsFCmoHWHb?=
 =?us-ascii?Q?xEkka4TW4Ti+MLxESck58q5zXU7kNmwYQmbcunuaMNWqqBnBym6Mzb4mp8rH?=
 =?us-ascii?Q?rrxjdFkQXLk0c6tq3uW7g5Hn06ZpLr5I6z63AqmfIU+XERIK2uD0igWcAhF8?=
 =?us-ascii?Q?O6sGeHGPAJBrat4I4PuNGKvLZNO17WRaIp6nEaKPE3w+o5QmRYYJ1r5xaaAN?=
 =?us-ascii?Q?hUBwzhEJNle9koyLWQSp2snjx4gyJRhvt57r2r+pUKFmuHsp8JumIU2uspc6?=
 =?us-ascii?Q?wmIGrOQSPhs9H5O58WlxFZTz5JRFFjMfQoEAtG/3CynjnjWUU4W0GP6RAwv4?=
 =?us-ascii?Q?UkhW5Jvswye9RSoO5F64gO56CIbH+vGunAVLbb2h/uZCRGzCk9m1xj+M10RK?=
 =?us-ascii?Q?gpTY5eXtu0X9V3ASP49dfMz+buq35aTJeIVarFWEPUiirLS1MXFJAeBPqud4?=
 =?us-ascii?Q?DhV+izo07QbwXOQqahNPeLB/mEOvXWUkdb7Hf2AWOFwokSlyhyyX0Rl43GKk?=
 =?us-ascii?Q?3Ljd6M0QgXwHgYpLqPgU/KCNkJEMRmDZ7E7cG2OsqnKwsTqZ3F6zPW/yCPfQ?=
 =?us-ascii?Q?T77I/BkiXoQuI1XmuXc30SaICSZjnEEreN4F86gOTlPvQ2q23PiQ0jsSNpGn?=
 =?us-ascii?Q?vblNNWHTuBvNfVpfuer5AuTdl7wsrmYb3mpeZAOAT5GAR5i79/NE6u6vp0nH?=
 =?us-ascii?Q?AMS35MnTMw3W+7eGDjGaNKi4GZsPFlrUFIHWWywmA8akZfd949DeKYC0jVuL?=
 =?us-ascii?Q?N6KS3t4hqUBrS+pqWaPB0z7u1jTB1rN8sjQZ86qCW0bb3P6Hg9lreARYNMxU?=
 =?us-ascii?Q?KL7TOrop2j2Eq5MyCCrlGnGbImzPUFiS3hmBS7ms+ST8Y1zdCNJ5gzIqeBma?=
 =?us-ascii?Q?VMivlffhwKlnfMJkF1GaslytsPDB/74si4zRRK6mz4vDPJ74XU9HsJweL0FC?=
 =?us-ascii?Q?fXuv9yKSyeUo1EOlxBHKzaIsWPr2wMsLnxOnj6j/uhwn+VR6w2+f42sG4TR2?=
 =?us-ascii?Q?PvsAi6a4nj8GtUKvj38wriVgzLIQ?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(82310400014)(376005)(1800799015)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2024 18:08:00.6865
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1c03493-3d07-441d-f0f2-08dc622dfb3d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCBF.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8106

SEV-SNP relies on private memory support to run guests, so make sure to
enable that support via the CONFIG_KVM_GENERIC_PRIVATE_MEM config
option.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index d64fb2b3eb69..5e72faca4e8f 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -136,6 +136,7 @@ config KVM_AMD_SEV
 	depends on KVM_AMD && X86_64
 	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
 	select ARCH_HAS_CC_PLATFORM
+	select KVM_GENERIC_PRIVATE_MEM
 	help
 	  Provides support for launching Encrypted VMs (SEV) and Encrypted VMs
 	  with Encrypted State (SEV-ES) on AMD processors.
-- 
2.25.1


