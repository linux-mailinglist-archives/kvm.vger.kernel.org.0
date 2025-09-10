Return-Path: <kvm+bounces-57199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CA52B51789
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 15:02:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D08447AFB00
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 13:00:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CD531A9FB5;
	Wed, 10 Sep 2025 13:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RKBJSlnf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2042.outbound.protection.outlook.com [40.107.212.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34FC1957FC;
	Wed, 10 Sep 2025 13:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757509340; cv=fail; b=HL9LUzLZ33AOYRQg2PVFGemz/DCx80yAXc0K62ExARm81T6HdZfLdCoiB0GW3njBx2Rj/n4RoqpHXTtbGjVsF0YOGKWLEjCZQrlrNQx6GuHyMkDFoGQcSrV3vJzxDWgtz9tR4ULW4G8okKjj+gdMLAsnqZUvnFis4J/+i9/+XHY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757509340; c=relaxed/simple;
	bh=xNtg2VA3opUiXvctaInLw3olPZeSwMtSFcgEg/iPYNU=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=hN/2pvwKqLyT2xY6Hb6ZEwDkCT9mj7PAm5rZn18W8Yg4TNwHBfWFEq9/HcPDHBxNOqS85kyT49e/jYD5HaEThszlviUSsjCwDHLQ+j9P9if3Ydy+j3uzdGiFMIHrbUULmH5XFdTYLlbl3cZwKR4P3TXY8j8Bk3Rj/Z67PGHm+J8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RKBJSlnf; arc=fail smtp.client-ip=40.107.212.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V5FedJmBIdrXHD8F30OlAXbuf3sEfe37A78DeQnnS6hc/oHnev3dxb9/v60zzzxH/cYI7ufdM0xZw1k5knqS1Gaz2VlF10ghedmi0YjTvJHyH4v3BKmbrPOKfJrzUPXfNM9NLUd29hxWQeX+VAJGFvnqn03s6jmCitkOzu2WNXC/ib12lHy/ke30HG/fQReX8O+hTKHZ1EBSQQu9LAvjQnFAAa7hiwQw2K6a7eQ+x01Ky7P7EVjEE7jtrHAoPu+QW1aKSJJJJROr5cR1xGg6AlZiyX357OA1xAmhT6CCgO64QiLfeAa+5WbC+2lppqL2HJKdcvFWsoMh6iUE7TmZIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NyXE6e1zvswoEfzIcRHGBH79axWpMty3CfosNKwsfYQ=;
 b=xC+OPtopxqb2WZX/edqVfEpHmtIvgIF9IU1xGE9bLQ/fVZ6Lwi83gSp5V/q04d/Kx/lsBrgWdSh7JUSVAPU79BYPYMBfqwlUuzmr+uHJ1CFm3f4/abQhDALeapLc8LE483XuANBJhFqxAjAWWwUoq7X6x+RBd30vq9QV6gI3XZo1g1eXLzR0Fq1IJx46YM9uonMnoCEiOoIcMvXwNlwZcNmWAaduy9cw7c2wjy4+XGQs96cC9SoVPhA7H2UK6qBBgqJm8MKGvZQ8rcinC/SQpCV386ibORCtsZlK5NVXXIIl/WH3hZHRTK/m8tQmWMcxLW9UX76oYsiD3XDHhNfwbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NyXE6e1zvswoEfzIcRHGBH79axWpMty3CfosNKwsfYQ=;
 b=RKBJSlnf0FOkEA58ILSV66sjnCGVTIypM50Yir1gisTunvjjaidYdEWpqndX4sMmjXX6Abb+xC7oZySZ/p9nUrRO1g4boMFRJPBCfxEU9JCzx/2EkHkdu2BeqSeXghCuvr8aH57QdA9OBjPzlVLiYhOWUC4GQVi8ajjWhvp1XLg=
Received: from BYAPR05CA0086.namprd05.prod.outlook.com (2603:10b6:a03:e0::27)
 by SA5PPF6CDAEAF48.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8cf) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 13:02:13 +0000
Received: from SJ1PEPF00002326.namprd03.prod.outlook.com
 (2603:10b6:a03:e0:cafe::56) by BYAPR05CA0086.outlook.office365.com
 (2603:10b6:a03:e0::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.14 via Frontend Transport; Wed,
 10 Sep 2025 13:02:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00002326.mail.protection.outlook.com (10.167.242.89) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Wed, 10 Sep 2025 13:02:13 +0000
Received: from BLR-L1-NDADHANI (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 10 Sep
 2025 06:02:08 -0700
From: Nikunj A Dadhania <nikunj@amd.com>
To: Manali Shukla <manali.shukla@amd.com>, <kvm@vger.kernel.org>,
	<linux-perf-users@vger.kernel.org>, <linux-doc@vger.kernel.org>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <manali.shukla@amd.com>,
	<bp@alien8.de>, <peterz@infradead.org>, <mingo@redhat.com>,
	<mizhang@google.com>, <thomas.lendacky@amd.com>, <ravi.bangoria@amd.com>,
	<Sandipan.Das@amd.com>
Subject: Re: [PATCH v2 06/12] x86/cpufeatures: Add CPUID feature bit for
 VIBS in SVM/SEV guests
In-Reply-To: <20250901052304.209199-1-manali.shukla@amd.com>
References: <20250901051656.209083-1-manali.shukla@amd.com>
 <20250901052304.209199-1-manali.shukla@amd.com>
Date: Wed, 10 Sep 2025 13:01:50 +0000
Message-ID: <85v7lq31hd.fsf@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002326:EE_|SA5PPF6CDAEAF48:EE_
X-MS-Office365-Filtering-Correlation-Id: d680d1f6-8427-42c9-6aeb-08ddf06a42c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0ob8iHEoNNxMFVjV7+pJVMcESbStuYjzLfkYmjhHmNmYuHB1l5s7MOOSZh0H?=
 =?us-ascii?Q?5gv+0YHgljYRQcnOSUZtKUeVxP5i9VYp1uefjUjJOOc7wkm5WiT0zLFPnzvr?=
 =?us-ascii?Q?v8BkpBJe8S6CsH7Q6zcIwD0tKZE/xr5BRn3E9cBdjC0d9sfGMz4zP//foQME?=
 =?us-ascii?Q?fhwgDvDSyP/OD3Hod46MgDZ2zXEPgq5J0NX3G1pjaIHkLIT+IqGKS+r4EhTR?=
 =?us-ascii?Q?TShRacUq5DoZNck4joIkkK/F5cmnvSQ9DRxz8GSaPPvMfF+50ayNPhCvcYoO?=
 =?us-ascii?Q?aursFEXSTnfvsNa2n5EMvYkeqPP6Qi2M2/CsKLOZE/mJAwQW+GMhDKVvDPZn?=
 =?us-ascii?Q?aM/PiJbfIbySgNQeS1Fl0IyILJlkMiaorJ4UMM/nWhIc+eIrIh1TLh2zYGJF?=
 =?us-ascii?Q?566QDKISUN9rScASu0BIym6GrHufVuyKuchfgSkasmdQWOnOs+7I3sCn5Wuo?=
 =?us-ascii?Q?9ReFh1ISApgCbNamLlh6VTGLmg6jSBSK+WvQJdjbKmcyi6VaWVRcoxiF1Vxa?=
 =?us-ascii?Q?i4z1k3RWSp3ninnLIfz318tIhVjNOGLlhc4V6H18V1HjzIFz6VCuKECcjYsm?=
 =?us-ascii?Q?U6yF+tnfs4imtWEMyT08AViCyKTp+YCi5UaTzE+21qgVd2u4KKTXLNp1vxCF?=
 =?us-ascii?Q?hApr2/6+s4Y5wvRsqH96/T2nz4S2BTKCT/xEF+r23QNM+ZF/A3ulmaVE1X1f?=
 =?us-ascii?Q?Vvl54/wiidO9RRTsgzIq3saR8t7OqwuCp3DK5yYjd1Yr/dm73Cwqe92uKgFk?=
 =?us-ascii?Q?ipJYfUzpvwQQsZjrksmCIzcSz74kGL6xXWX+EfkfKel7oPg8uk93esLTO9WP?=
 =?us-ascii?Q?RzyKIidrRicjM6gTCgPbtnyqeARGFIgmZw8aZ/2lresUD2nfruT9YueBRkgy?=
 =?us-ascii?Q?Xz47HmzarxYpXf8f4d89Jy/Be4wl5WTp6aDlq/On1XeSZsKFJ3+UELknSYJk?=
 =?us-ascii?Q?FxmQQY8InqCln+oVaxGUoAZ9TgZIQ4XuHSSyGC72UF1pu/d856NfUyrVxWda?=
 =?us-ascii?Q?nzxf+70wwMWV6kc4k8No2sQ/L+oomU/Nh9cHycmpaHUL2zXtO934UeSitf+r?=
 =?us-ascii?Q?7y+izSiK77yqvebAQz8AX9VlDRrKNFHOYwt2O+RPTavMZstFadHZn6gqVRpT?=
 =?us-ascii?Q?9arGmvMivfTQrJkSUwdPv25+Reo/6/Wu3CtgiSQRF5MNbyiRAOcQaAEjP1nO?=
 =?us-ascii?Q?hfnWGybNJHliZYg0mQeLykswUIdp21WJNVXKN6JQAmNpnky1pmytPCONCkDh?=
 =?us-ascii?Q?p0VsswNQPP2m2YwDlA9vt4QFV/msO9ZyEE/q6t1wfA9gOsMOokwnYeEy7DfV?=
 =?us-ascii?Q?ZWdf4X7THLa3u1X57Mq2jWD0Yo1MLA4VpyE2ZsB7NILvU8jFw87GC9GxhkL6?=
 =?us-ascii?Q?FwWBz1tHSMJANJ6X5DzxRal3tWp1uXAU2a8M3v3K/hwDueivNznhlNb4b2+C?=
 =?us-ascii?Q?dxyrKpdPbx/oD8hM7LH//HIWMvQIJDR+wr4avm7QZKJ9VmK7w3zYf5/oJEy7?=
 =?us-ascii?Q?j3epUD8UEO/FrIbH6wy5rrBCZCA9Rp+JlhEz?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 13:02:13.2573
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d680d1f6-8427-42c9-6aeb-08ddf06a42c5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002326.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF6CDAEAF48

Manali Shukla <manali.shukla@amd.com> writes:

> From: Santosh Shukla <santosh.shukla@amd.com>
>
> The virtualized IBS (VIBS) feature allows the guest to collect IBS
> samples without exiting the guest.
>
> Presence of the VIBS feature is indicated via CPUID function
> 0x8000000A_EDX[26].
>
> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
> Signed-off-by: Manali Shukla <manali.shukla@amd.com>
> ---
>  arch/x86/include/asm/cpufeatures.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 0dd44cbf7196..3c31dea00671 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -379,6 +379,7 @@
>  #define X86_FEATURE_V_SPEC_CTRL		(15*32+20) /* "v_spec_ctrl" Virtual SPEC_CTRL */
>  #define X86_FEATURE_VNMI		(15*32+25) /* "vnmi" Virtual NMI */
>  #define X86_FEATURE_EXTLVT		(15*32+27) /* Extended Local vector Table */
> +#define X86_FEATURE_VIBS		(15*32+26) /* Virtual IBS */

Please move before EXTLVT to maintain bit position order

Regards,
Nikunj

>  #define X86_FEATURE_SVME_ADDR_CHK	(15*32+28) /* SVME addr check */
>  #define X86_FEATURE_BUS_LOCK_THRESHOLD	(15*32+29) /* Bus lock threshold */
>  #define X86_FEATURE_IDLE_HLT		(15*32+30) /* IDLE HLT intercept */
> -- 
> 2.43.0

