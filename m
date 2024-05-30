Return-Path: <kvm+bounces-18414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 756608D4A48
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 13:19:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D592E1F21A6A
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 11:19:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4350174EF4;
	Thu, 30 May 2024 11:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zFISbCgf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2088.outbound.protection.outlook.com [40.107.93.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB5C1822C2
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 11:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717067826; cv=fail; b=VvnVDhuyKkKMcQVaCgRo281GdPg/9CEAqcL8eQK1iE5RevxTYpZfP1qRc/KuIT/QQmA/TD9uq5lXTSccYF7pnKtms6nqGUWdPpm7FWZa5LSHOgx+N+AxvJRMrSoGCoPuBvEY3yguS/sl2ivLUV7+KZ8EV4drg0s4Oo9f9Stel68=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717067826; c=relaxed/simple;
	bh=ILtW3Z0OCyD1YgNmg84z7sHpvoCogTL4y34jhDSiPqE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Sa8mNGXlaUiDML+kZVSgn4nIbAP5HH6v3g8zndMRmJbi1XXzhwE1wZxt22UrkzAr10jgv51nC1G+nC0rZUipiGDuv2xyhwPA/esvtO2N1s4sf/n0GnH5mkuBvCKHJ+42CtLUY/C7Tk/Xshh7vVyscYlsCbfiX37eR9fMXotyWvE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zFISbCgf; arc=fail smtp.client-ip=40.107.93.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XtpMXZpGIc3oplYgyC1KbZ0h4Refes5lfC5E7qNeNBJZsZ8pW7sgbu+84kUoq3Q5MvDAyF9Hmk4YYvjX+h4HOkgjYo/6QxvObywlkjT/3jhUmrVSRvzThqc3ztrp8ddZ2lDN5DCSL9856sRy3JMvPFyEBpcN+Bi6K2E3L2WnfXRxj+aal6tGEJ08tOfBfLjByXGfiSVKQhkUMcXxgBLnvTTa3K71aUbeQAUqrRUyFYh53A5YZiNro5ad3gpk8tpZSznXRIO1kTb+hPy7AcVpZ5cQrntPhqYlxsWGsdOWTpGVtb431xHWMOExz9mU+HxQebZY2IJYfz0HsEa5PrLpZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=91QkMbXQQW9VkoJrrFc6mXK72hrtmnB4NuTd0ujUGoM=;
 b=NIy4XkoG2wpaVETNjhNFvGn2GZs3fYdcOgNSc0wSGFLRt3asZpGib3B5jLTHBXZ06QsxrIAcm/sW948iPMWA/RGC/iiiRJuSlpAgVEWS2DWjXs5jz48njxYAcsdezcbKjKhMyRWGeDRK7fSB/ydhD2EpblXr13GCl5NSLDeK58k4/84tFDv8hdAaaJySoDkquewXD9+8/bJTL7cf1P5krL5XVMJxt976MhOEM0irif+BpaSnaaQatWR3oeUXotcz7SaEe+c22oZdiiQS8OEBYGiJqtwUucAnGv+e0+AjlYku+Du8KMZufpjbskJLcxuYqZMrxF9yq7z6u4Y9fL+0ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=91QkMbXQQW9VkoJrrFc6mXK72hrtmnB4NuTd0ujUGoM=;
 b=zFISbCgf3s1wo6dCdcsiZOCP3iwKLcNe9UiMeP6Fr0IB4zTId9W5nGM0ROVmeE7bepeVaCeCCF2QG0+szki86NcaQJUkmSZrYDVT63ArxTr0LTbrJPQJlR5GcTc3nJsytiKs5IdbnN7Frq0iKp0oxZjYx+ROGigOZEGHF1voG9w=
Received: from BN9PR03CA0677.namprd03.prod.outlook.com (2603:10b6:408:10e::22)
 by PH7PR12MB5902.namprd12.prod.outlook.com (2603:10b6:510:1d6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Thu, 30 May
 2024 11:17:01 +0000
Received: from BN3PEPF0000B077.namprd04.prod.outlook.com
 (2603:10b6:408:10e:cafe::d) by BN9PR03CA0677.outlook.office365.com
 (2603:10b6:408:10e::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.20 via Frontend
 Transport; Thu, 30 May 2024 11:17:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B077.mail.protection.outlook.com (10.167.243.122) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Thu, 30 May 2024 11:17:01 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:17:00 -0500
Received: from pankaj-M75q.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Thu, 30 May 2024 06:17:00 -0500
From: Pankaj Gupta <pankaj.gupta@amd.com>
To: <qemu-devel@nongnu.org>
CC: <brijesh.singh@amd.com>, <dovmurik@linux.ibm.com>, <armbru@redhat.com>,
	<michael.roth@amd.com>, <xiaoyao.li@intel.com>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>, <isaku.yamahata@intel.com>, <berrange@redhat.com>,
	<kvm@vger.kernel.org>, <anisinha@redhat.com>, <pankaj.gupta@amd.com>
Subject: [PATCH v4 26/31] i386/sev: Invoke launch_updata_data() for SNP class
Date: Thu, 30 May 2024 06:16:38 -0500
Message-ID: <20240530111643.1091816-27-pankaj.gupta@amd.com>
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
Received-SPF: None (SATLEXMB04.amd.com: pankaj.gupta@amd.com does not
 designate permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B077:EE_|PH7PR12MB5902:EE_
X-MS-Office365-Filtering-Correlation-Id: 58bfb315-a9dc-4630-1208-08dc809a073f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|36860700004|1800799015|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BlWZLDa5ghDtJPzZSeew2LmctDFxgqZuGTzMJA0MG9C++kkAe7Lik+XCPJU7?=
 =?us-ascii?Q?NaEQIAltmT0P5hrWrsQV94/7w9Fp3NH+s4vO7vip0absHxDXw+rCZsIWGG8U?=
 =?us-ascii?Q?DX2+lCmMan6yztdHoI6FpgC8AQZkF3VapwX7aE5o3RBRijNPF4iqfPvUC8zX?=
 =?us-ascii?Q?j5RTyjcBFuMSAX6XFZWx6JfdoHi959lvIbzD43KGi1HezMKOQM4210iwClJV?=
 =?us-ascii?Q?598coUPHyx6m+jw2jKCHZkrgMj0iRgqPmmtf0CMtjz95r4RXmfUNt7168s9K?=
 =?us-ascii?Q?g3z0I44Y6qer0wccUeUxKLMQ5vExBSZe3X8QHYwRY3pjbPPFyFv0nP5rMLzz?=
 =?us-ascii?Q?AGZYPCOIu91z8ZNm3LPl7eVozPqjy/4K8Tvb9eJUt8juDLStPSOOqnyDocH4?=
 =?us-ascii?Q?OI4rmvvqK+ZBx/p85zBtEE7YTduv3Boh85HrPTmLcVaZIyqW21TGAo3P4K2X?=
 =?us-ascii?Q?RQ5q55QCxccQMEgRXnZTnIgUR8fuJvjuTPN45gCZNAoD4+EnpRtFw55yv9SJ?=
 =?us-ascii?Q?cRT/iOayAHfXpkh6SSwdtuX7MRA5rl5Wg2hJ4Q4bka6zFVx2H2cXwmLFUsem?=
 =?us-ascii?Q?12wYXRqKgUrj2uNjfojBGhFUekk9ufyufRH58k7QXqmQEB4s0qZWPqJHHGlF?=
 =?us-ascii?Q?vya9m0E6C6zStwZ29f644oqd2cUQkLns0mkfbLXT2lr0jbcwhncYohZg7gef?=
 =?us-ascii?Q?IsGxHKcynsjx2XsLTFAtCdgqBaRMPdWu8xdCqh9HN0YEiokME5Mjrtv5+m1L?=
 =?us-ascii?Q?xf4IymnvJ8FxiADw4ldq4izbA5DyK5iosEmYZ89Qdw/jP6pInM5gam8hw/mX?=
 =?us-ascii?Q?rwPKi6GWNaAXh2RoHhQOEf4QKTgdtMhPVE5PA3l7PfK/k+HtJBLwPRczhQwC?=
 =?us-ascii?Q?f4gDvl9ZSgvjrkc4lSTQ62cWke6yGw6mSAb8ixdgehr7YruZwH4isx5vRC2C?=
 =?us-ascii?Q?SvBg41BKRMPJ08E8N7fSdQ0gX2m18/f+VxGeWXKVP87fn/PVk4zxxHvO1m+a?=
 =?us-ascii?Q?h53f46QyKMFj6UIODSEQCC/TeI3f2NDV/MYYuivD2aNgNJxH+cBfFBXg5l3N?=
 =?us-ascii?Q?qXZOMOqnFsk3/IXbk/LZboTHTmeDSBfbH1BeV+09CZ6y2djgayTyKd3rNxTs?=
 =?us-ascii?Q?e5ODypKS1pASc1oef7Gru8bGpHuE2Okqrt1m/Wc1heIjGv/uYiru1jP/n/88?=
 =?us-ascii?Q?Ux0vF34zzRK5kewTfn+L3g10cVaXVNVdWXUytbQ2rm2RTrtn+pKd98G8HQoh?=
 =?us-ascii?Q?QLkCnZEyzp3Zx7xAty3Nxp/v5GmznJmpv406m8rELaiI1NqAoB6gsV7FoIQn?=
 =?us-ascii?Q?kRQ561Nc3/2CP668wwDEW/flNofkbyWVYEAVqoJDHh45Q1NzhhnZPvHdqzIa?=
 =?us-ascii?Q?g1P09v68RJHU4lNscgATg3GsfSSh?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(36860700004)(1800799015)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 11:17:01.4191
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 58bfb315-a9dc-4630-1208-08dc809a073f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B077.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5902

Invoke as sev_snp_launch_update_data() for SNP object.

Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
---
 target/i386/sev.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 7a0c2ee10f..7d2f67e2f3 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -1108,6 +1108,14 @@ snp_launch_update_data(uint64_t gpa, void *hva,
     return 0;
 }
 
+static int
+sev_snp_launch_update_data(hwaddr gpa, uint8_t *ptr, uint64_t len)
+{
+       int ret = snp_launch_update_data(gpa, ptr, len,
+                                         KVM_SEV_SNP_PAGE_TYPE_NORMAL);
+       return ret;
+}
+
 static int
 sev_snp_cpuid_info_fill(SnpCpuidInfo *snp_cpuid_info,
                         const KvmCpuidInfo *kvm_cpuid_info)
@@ -2282,6 +2290,7 @@ sev_snp_guest_class_init(ObjectClass *oc, void *data)
 
     klass->launch_start = sev_snp_launch_start;
     klass->launch_finish = sev_snp_launch_finish;
+    klass->launch_update_data = sev_snp_launch_update_data;
     klass->kvm_init = sev_snp_kvm_init;
     x86_klass->kvm_type = sev_snp_kvm_type;
 
-- 
2.34.1


