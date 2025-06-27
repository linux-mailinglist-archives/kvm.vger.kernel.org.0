Return-Path: <kvm+bounces-51023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 65F56AEBD51
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 18:29:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 010FD16AF71
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 16:28:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3F202EAB78;
	Fri, 27 Jun 2025 16:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kKsYs21G"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2068.outbound.protection.outlook.com [40.107.223.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7EC2E11AE;
	Fri, 27 Jun 2025 16:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751041628; cv=fail; b=YrdDDzD0Nxk2R7nPHFHv6snEgr2U1AG+Vp4K6rfg8eiE+t+j4Vs7GPLChb1MadAU879pVZsBHrqJW7nQ6qtG30Iuw30t73cziJ9FL1/tTcO13ZmcOTFWxjBLc1GiSRK4zvwYYabTBFQhjP/OAHqtyTnNJTz6Iw4oFqYbJFklzkY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751041628; c=relaxed/simple;
	bh=rPSBMBAZTdEx2HkEAh6qaXrLhLNblF4CP+FKgS8bOac=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o3YddliewW6t8aluPwaOZ1Xsd3lLWQC7PFX8Slv5dWMFI1lAvG1us1L5+oD/pC3eiDJTUvsTUZCS/LrT2p4E4GWPqki9ib69Bed7oYd8FJ/7CkrMi9CGmx0qwrYYx1E4BuZJ+FwssyfNO619YyQN6ADOnH5sialuTPUZjHzJMak=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kKsYs21G; arc=fail smtp.client-ip=40.107.223.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UU/RPfgZj13FPK4ZMMU8w0TEvRRuw7p3a73DBXjSz/PZtX6hfsTwzn6ECnJbeoZxrnIup7G1slczmN+8Vv8u2FG3xaLoG5Ee1uCb508ZaBXQ5Bgo2syJphs6P9pNjSD4MpG57uvqRyBKSk8j7ItKb6qL8tUgLWlX8T8s2gxEk6FU4COfdtU6Zs1NY8U75B/u6qM9xqZwh7r8l+8rwOPqdMUbjlpdkODO5hsmsx98h1MQRCXSVNa6M+bdRDdV2cNZnEWUTnpW83XN7p8Sma4Je1lu0GgdTp8N52NtRweDTBlwI79eT0+cKDANPKG8o7Ir+UVD8NXyVckZvDZXp0Jdjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iCmf/GH4DFPdIfAGuaxdW9mlHqnntHnWVuWc5kSsicE=;
 b=vqZAl8wfbsxM17XO0UQnv4NuT6MGg2BTdM/TTxmu8Fk+GneLdvmZ+7IT9KLVJjOBps2NOrTkyqaT+lDWV4bJyjm/Q32mjqIjHu3JmZ/4II8ntJtx3q/6weECeSAMZw0AyBlGHEhPdsaZ0iXrXUo8RoDUczF1y3oF5kdvkUq8F0ltrZGYDQW2kE+Q1BCe9y9bETFQijAwTKYrnH0GvREU6jck9xuFf3wb9CFlK/WGNB52KNrs3l6ByMvbPhpzfh9xIY9L2my9UF43U3GnEASB6uAGlSK4ATKMs/KhfNQ1DX5J+x2KDPey5pIh6pXzCtiL4G8BguI8jj9TrizmcvfXJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iCmf/GH4DFPdIfAGuaxdW9mlHqnntHnWVuWc5kSsicE=;
 b=kKsYs21GB3kFdW2zC2Agj2cB0F3kzZLTnOG0dzLBVmrBY555GlllIqCJGCrlw2l4HLKmRyAkMLkQqAcUMJZVtfnjkpLE+K6PKJdlXiIHcP/cfzcYq6ACC+SN7ugkAPUAZGIKBGPg/YZWhZ6bqdwjdyLFcg09YIKlYr1FT6fKIFI=
Received: from SA9PR13CA0117.namprd13.prod.outlook.com (2603:10b6:806:24::32)
 by IA1PR12MB6388.namprd12.prod.outlook.com (2603:10b6:208:388::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.23; Fri, 27 Jun
 2025 16:27:03 +0000
Received: from SN1PEPF000397B4.namprd05.prod.outlook.com
 (2603:10b6:806:24:cafe::8a) by SA9PR13CA0117.outlook.office365.com
 (2603:10b6:806:24::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8901.11 via Frontend Transport; Fri,
 27 Jun 2025 16:27:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000397B4.mail.protection.outlook.com (10.167.248.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8880.14 via Frontend Transport; Fri, 27 Jun 2025 16:27:03 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 27 Jun
 2025 11:26:56 -0500
From: Manali Shukla <manali.shukla@amd.com>
To: <kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-doc@vger.kernel.org>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>,
	<manali.shukla@amd.com>, <bp@alien8.de>, <peterz@infradead.org>,
	<mingo@redhat.com>, <mizhang@google.com>, <thomas.lendacky@amd.com>,
	<ravi.bangoria@amd.com>, <Sandipan.Das@amd.com>
Subject: [PATCH v1 11/11] perf/x86/amd: Remove exclude_guest check from perf_ibs_init()
Date: Fri, 27 Jun 2025 16:25:39 +0000
Message-ID: <20250627162550.14197-12-manali.shukla@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250627162550.14197-1-manali.shukla@amd.com>
References: <20250627162550.14197-1-manali.shukla@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B4:EE_|IA1PR12MB6388:EE_
X-MS-Office365-Filtering-Correlation-Id: f721fe4e-3bca-4c79-58d3-08ddb5977313
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?icb5t+mS7YwWe7tJEHrq4L7sMpYYMCXpjHJBd32lb7plS2+QlRjIE8DxwWNp?=
 =?us-ascii?Q?tWMSlaN/YOAlTfKkkUALe1EJaWDWjh8Lxhowq9WuLVZ9zgqPNLlGSGl6Y8Bi?=
 =?us-ascii?Q?mhbVsjjyjBiCAaEzUV+nQMiIswn4YiacwWLco6fEm0qJNIJIzuFw5Z3m3DNy?=
 =?us-ascii?Q?vZ5/pEK/bTzppTcth4lZEk+zjPQ/KocD3ZJWtMEnqq5MT64GOXerd5/Wt6LX?=
 =?us-ascii?Q?nruoMUxIQRxznPTvtqOgHNbRC9LkWg/SvFDokxdUp8MdYSD8JHIwTLeqJ3X5?=
 =?us-ascii?Q?TsZP7cPksBNh31mbQuNlHVxHEEDSN2vEHIhz8qV83yDNQXmn7hQfUNlo88d+?=
 =?us-ascii?Q?OWlf9Q/vxFEI1TFcwJzjEvOobLEeLqzEj6CM9x3Pwb7s3uLj/6TB1P5256bD?=
 =?us-ascii?Q?lFNttjA/XzVD2tL4CbJOLriBBln7mhXFJxVomplZHGQsodrxmp8bUrEOCN05?=
 =?us-ascii?Q?UrntQo6B4GOvL3S6+64q8BVqeZDdkWbBKEim8Umqr88cUhieSEzSs/J4xjs5?=
 =?us-ascii?Q?KJAnnCl07Is4X/THeTJx2Z3v+HBdT5ArSQHrqnBLp1D1c3/BW2ooGHmVtjp8?=
 =?us-ascii?Q?7BBZRptLLGfl0yfibHReT3vl2QDSg6Bt9ztHmXyE68LfY8trwWpKHrX6kxoG?=
 =?us-ascii?Q?Xlwz8ti/D4HAGNRDRhdHSzgl+h3sujKdMXLIWbSYXlvqP1ESt2WOeu9MPl5Z?=
 =?us-ascii?Q?yt4JqSg6C8k4RBqXZMcn6mkxG5P5CkZKy9Vov7z5mVZ3ryenyb2MUq+qwUPc?=
 =?us-ascii?Q?tB4FK4qlEe05zL7byAm1vSrFzny0lfTdzxHPnOgVu+cv5DjdGUwpIyG1qGFb?=
 =?us-ascii?Q?h/uIVNqPZAmi9HIb2rQV21YWd+loKmmz5eU/uZZoXsNEyf4otkbyGqOVYiU/?=
 =?us-ascii?Q?PjIK4lKZOsWRTsOO9eQW3PY8l3YG6TCMawEG9VUY+telQKWX3UssgnGGORvT?=
 =?us-ascii?Q?JQO4bjZAqEp5EnTGOkVnQ7xhOgkCnooWe9B8CDkRPbiH29h7Qibtu8Cn7b0v?=
 =?us-ascii?Q?PiubiZKkoqt8oZn/4GVLXrkrEQqb/0QZDcA8aXmP0MyW7+t/7C5V8oqOdDlp?=
 =?us-ascii?Q?BvrIQPvX4nZkFIuyKLnsQxUpYc//RhbHycol+VsMOOOaSx5baUYCiaz3/Wc4?=
 =?us-ascii?Q?ahONXGq/dXhGkEsIwmgLjZnUn91F7V62gDiDFAasm8Hre/gck1y8Vo6iczqA?=
 =?us-ascii?Q?QMit5RJjHA7jpdy87cyKEY+OREkn1q9ZLZpQ3FWC7wFgDisIgsDR9icbTy0I?=
 =?us-ascii?Q?v7I/NfvMmG5dRrUpIN6YqucXiHb0I3d9hh6gH+hnj4CmJkUWfbfm2a+z664h?=
 =?us-ascii?Q?GvgFqoUSXlcwuNNEBZ6irjcUaIEUHhApJziL9frVsAnB7BMa+YzXfSQ/CPe5?=
 =?us-ascii?Q?GDTi6LBfltG214FfKO1c2wUdlA2t4ulxixHnV1hXM7tlJMY2yXSGNUnflnwl?=
 =?us-ascii?Q?Ge3RgwB8YY/pbMGlzOxM1FheolqAyVrg4OQnJ5mRKN+37Ief/AwkYreeQ48t?=
 =?us-ascii?Q?SYdCGMQIDZAmKosfsc28rq8xm8ngYnsiBF+M?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2025 16:27:03.1166
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f721fe4e-3bca-4c79-58d3-08ddb5977313
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6388

Currently IBS driver doesn't allow the creation of IBS event with
exclue_guest set. As a result, amd_ibs_init() returns -EINVAL if
IBS event is created with exclude_guest set.

With the introduction of mediated PMU support, software-based handling
of exclude_guest is permitted for PMUs that have the
PERF_PMU_CAP_MEDIATED_VPMU capability.

Since ibs_op and ibs_fetch pmus has PERF_PMU_CAP_MEDIATED_VPMU
capability set, update perf_ibs_init() to remove exclude_guest check.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/events/amd/ibs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index 00c36ce16957..35dc5a578778 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -299,8 +299,7 @@ static int perf_ibs_init(struct perf_event *event)
 		return -EOPNOTSUPP;
 
 	/* handle exclude_{user,kernel} in the IRQ handler */
-	if (event->attr.exclude_host || event->attr.exclude_guest ||
-	    event->attr.exclude_idle)
+	if (event->attr.exclude_host || event->attr.exclude_idle)
 		return -EINVAL;
 
 	if (!(event->attr.config2 & IBS_SW_FILTER_MASK) &&
-- 
2.43.0


