Return-Path: <kvm+bounces-71185-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MK+nKODLlGluHwIAu9opvQ
	(envelope-from <kvm+bounces-71185-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 21:13:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CA88014FE30
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 21:13:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C56FB3011D5E
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 20:12:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E849B378831;
	Tue, 17 Feb 2026 20:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4y4eElFq"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012056.outbound.protection.outlook.com [52.101.43.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E3F3783C6;
	Tue, 17 Feb 2026 20:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771359117; cv=fail; b=HiGRY8gPWmbRcxHi3nU7SnxOKjKkHF8FHfCDnpPllcw2RN6qQSfO8vUVQUmdxX1ccMOu1FL3XGA8oyQM01e2pBclD9R7Fo7MMzmKEye1ayg6ojCANWBhMLe2AD5RvCPOLZM2cyKzWHqn0C4v71knjLc84EYJ8mgDNJ7jb5lmCLA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771359117; c=relaxed/simple;
	bh=B0OXcxvl7b7H37/bSw9q4ws48CrUSYMJ4KNnIElYick=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AVCt+MAjGSVOaAE3zXDhJBl03Y2p+S8rFMOv7P6Mt13w+U5mmHnOicYEytMUiW7kN/3YOOTDlgGsQXitKA+G9aF2kJaBgMsZo5uYY2cytgLd4J5LEVyL08P2DntVnzWoMxU6xVfeqJ071cwP6MJNwMrEuCC5gPQD/eaPWdnqCqU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4y4eElFq; arc=fail smtp.client-ip=52.101.43.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ITFG+yVtF9kemd4/HWHeDc5Dk+nyqQYk4ZQI0cTGyViw7l4AVwjpzxKe+3zYbyHOjGM5l7Y1vDLMcczfsTrctYp0/0TjooB7XtUI8lBCC+WGpK4AIlVob94/1rRiLBDSkLOHATHM0LGCyV2yO79fbnClh4CP3vyq3CGjrSgHVEbhooywcYqEiyQD18j4iL9T8eQwLi/8eNnBtWunBux4F27/u5FKaxWJF+1qP/YMkZyuTz08DuXDPyQ0sj0x9I3H5D71fN6EJ0lxblZdSttc5jrVX0LlKHizuKfmoSFLoeA4XjETDl5YHB7g//AGVELlORewAqAj5ADeJZRPNI1qoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9OopiRyGXJgKP709R9DvIEBsffFv53x5Q4m8igvCf0g=;
 b=C1zC3vzi7PKGZIk2205TQ7u+N4LqSb0YtScnQw0DGpTOTS/ayezSWpno8mPhWW9QCXwqsuM+4mwceCNHQF6svfm7A/VCt8/MMYc0FuO9nowiNy990rsNqKFVwd9u2HGR0XkWvYwnuDKmLenvY2WQLfaI7jY8BALgjZcguS59e4ZiaNIMBiUnSqGnFt2P4Sfoldl0h8Ptus0eELZ2c5sUKgof/VgMKtG1e7k1yVHr50tNjwnonNMDF11Zgcd018wUJXtbYl1LhzlFLjX5CC4UkEJzbvov9SRGRPh4MvtFAx9nJp6CiC1Ev57n5Sw4J5nnBjxgxryk+s5MQolq4C8fjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9OopiRyGXJgKP709R9DvIEBsffFv53x5Q4m8igvCf0g=;
 b=4y4eElFqEdyt31UrI8rb6C1q3bXYIXV1drbhPS6PnsmqsFeIVIrnODmhikoADRtYxbFweP+0he70lU6kT2JLLA4eEH/vWT5mtYPKw/medEXLFHCiFnKp/Y4dbdV4GngdvSphV3lIeZ8rZSwYTGgQb1vSNseiYqwQNmJyNlaFRTE=
Received: from MN2PR20CA0059.namprd20.prod.outlook.com (2603:10b6:208:235::28)
 by LV8PR12MB9183.namprd12.prod.outlook.com (2603:10b6:408:193::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Tue, 17 Feb
 2026 20:11:46 +0000
Received: from BL6PEPF0001AB53.namprd02.prod.outlook.com
 (2603:10b6:208:235:cafe::3a) by MN2PR20CA0059.outlook.office365.com
 (2603:10b6:208:235::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.13 via Frontend Transport; Tue,
 17 Feb 2026 20:11:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0001AB53.mail.protection.outlook.com (10.167.241.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Tue, 17 Feb 2026 20:11:46 +0000
Received: from nigeria-2635-os.aus-spse (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 17 Feb
 2026 14:11:43 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <peterz@infradead.org>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <ardb@kernel.org>
CC: <pbonzini@redhat.com>, <aik@amd.com>, <Michael.Roth@amd.com>,
	<KPrateek.Nayak@amd.com>, <Tycho.Andersen@amd.com>,
	<Nathan.Fontenot@amd.com>, <jackyli@google.com>, <pgonda@google.com>,
	<rientjes@google.com>, <jacobhxu@google.com>, <xin@zytor.com>,
	<pawan.kumar.gupta@linux.intel.com>, <babu.moger@amd.com>,
	<dyoung@redhat.com>, <nikunj@amd.com>, <john.allen@amd.com>,
	<darwi@linutronix.de>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH 6/6] x86/sev: Add debugfs support for RMPOPT
Date: Tue, 17 Feb 2026 20:11:34 +0000
Message-ID: <f34a0d2804bbe7b320bb6c203960aaa3139dd57a.1771321114.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1771321114.git.ashish.kalra@amd.com>
References: <cover.1771321114.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB53:EE_|LV8PR12MB9183:EE_
X-MS-Office365-Filtering-Correlation-Id: ed5f0ce5-a96f-4853-68b8-08de6e60c6c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GwIbYjXDus9MyxZDav3UcYFT+EsdLwEiDUXUMYRKpj1eC579K4jC/FuLvd7e?=
 =?us-ascii?Q?/vA802X1Ykv6L4I3dx674Ggs2mg87KMlQW87xjZLLPwsI6e4tTpcoP+ONyvb?=
 =?us-ascii?Q?mxXQCwMZy9cFrnpwmVwABkM+Ryf4JiyxFjyx5QOfFWKH07fhsMbNEYnUYdzk?=
 =?us-ascii?Q?530Cm1md27RwAQhJylUBXZop95vNFQWL4//2TCeF1lt5FOY9kRUSGuyd9Bwq?=
 =?us-ascii?Q?Vl7SY1LhShcWznmw0t3JieCLNdVVoFe+4UDq7vlVuxwjJgPmxfKgMiH2rc8K?=
 =?us-ascii?Q?YV/wEtcDzqVNEt1VpUkjwZCcky2Hp57HtPFupgdg/o5YprubWV091zIoId5d?=
 =?us-ascii?Q?APLqVoqCiy+Kj4j9zO7LnJDQHQzK7JzHP3/sY9apotMhX/JLQnseanhH2AeE?=
 =?us-ascii?Q?HQAqA0Y3IlgkA91wVnST1KKvV+6cZXNM2UiFYamVbSoO1UByBVJIMpZkLEwi?=
 =?us-ascii?Q?7OSU6CvQ7sccEbC4yOoI3iVd8wTdcD1mv4WvyH0oAShyiOIsKbQYGe+Xj97v?=
 =?us-ascii?Q?Vw5/8ZPIOGI6+P4yTNCMV6qIXZ/C4pcD5j2b2hghLVhMAJb2A/wiUFeskCHd?=
 =?us-ascii?Q?unoTjqYQVE8Q2RG7iLdYeZ7xx0eiafEY3C3cw730HMnCK8V1cdaEaH7ST2wX?=
 =?us-ascii?Q?URkFdb4J2nPT/PDJU6JWZcS8wNXuRtWy2dOBwypb1uWy4bz7Ds1qbnJodRwI?=
 =?us-ascii?Q?4CrsEwoQDcBUTbngpbwJ71B062rqtWRAs4gnfVWL9bjpcwQ48KZzPwM3ZUm8?=
 =?us-ascii?Q?v3YZ//a/T0nONpl9BXncjgSHSlqGz1m70HF70FAFpNPnkzzKXRkemiPr6HDM?=
 =?us-ascii?Q?12RTRSx4sO/9BBR5iHE52CtkLW3qcT9M5GqR5WYGbbw8zjvfC9NFJS4QS+a/?=
 =?us-ascii?Q?Y+sNbGHYY6frVukkpSfIuUDVZweOoE3nUFQMTDnDD08WOk1RW1uPETGE2pTd?=
 =?us-ascii?Q?DbB4+ZZjHr13ylUgs4iqsmUeRkfk+kOWkXDUwL0mQZXBgONYC6AbPmKxOAkq?=
 =?us-ascii?Q?yeWimUwLaXzf8SUHma+7G8mpGCn5mIIwyKEyXbSR4o4uqko5+13Xbm7XdRiS?=
 =?us-ascii?Q?HPcCQGJEXH3R28SIqT6Xv/CSHQ3EvXjLYU4GlEfCXnDvjbwhwjMmuy6Qat/p?=
 =?us-ascii?Q?mOOhEbTRp5pMO5idEthdXvdNlSTNY6HQfWQRgIJNEfrSOrxBrln04lmmrkCC?=
 =?us-ascii?Q?NqbsVRI+2nVuaeWlab7La7gnMasXnlr1zPrPb7miWio20zE7OMjcicKzwlkC?=
 =?us-ascii?Q?3CC3RGFIbJUV+Oyae3iD2u1T8V9n1oYJhWHPXNSr2c1Ggyps0YCYLXfxk082?=
 =?us-ascii?Q?2q0Jk3ShHE9M5/8DkSztAoIUPt6FmhdxWMW5j/URGcoK3iKYSwFs9SKSsDAP?=
 =?us-ascii?Q?xXk4GvrgIAohpbNT8MnZ5VXhJdVodiP49sqhSWIYe2nvJq4EDl9RPt5ZfvED?=
 =?us-ascii?Q?JVsa0cQfSjhZ2AxQSDTWmZQpPNCOf77CJDcNDAAksrQo5VJBjvsGPXYZkXeA?=
 =?us-ascii?Q?1eXbdDmiyrbYUad4Rq0U0ZjXShlDMq27j9eKv5AkUbr8g71GcCk21DPyhpQW?=
 =?us-ascii?Q?6Bq6ZflzL7cTVomncInQEc3MTPKb7uapOtuQAUnrv1x9jwUfDGTT4wFJK3ND?=
 =?us-ascii?Q?O8VBl7aTLDbXyILrRyfydEzkI3GFT7vpAer8uepjEF052crNAfPUiwz/MdrZ?=
 =?us-ascii?Q?UKl/OGW4xm071G2dTdLuQf/GEjA=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	TnUfdQVPJ2YUzY/jTGsueRucKsrB2952hZSnnH3rMRJGYhPMvFB9guGgGPDxGFA+fQdCc+Y7OOPEIyvaN70kGe8rIjCSjh/HzWjDBEvQK1KlldHs0bCClGStM8Cx6jHNAjYFsfzzukNSY/0LadQ4FYeYgjaSX/AXn4g9Skf+rZoPDG6H4xDuzZq9Tp08HMIrI42nZ3ZMphwPf2Aji3eTRmmUP0DENvc128au3plDUa8w8FFMupNZph6WzCJ5SdDjIXf4+hAmWMLCv7GB1+7GwiY3SGx1pe+6hV00Tw02WVksfjmaz2nMNYqe8ozX60wI/tqcwSHNAFKw76z+FGgZJ8bERYY/KQLJ6jzIq4pJ/YhXgZ+qRXh7GmxBxjCbpCZhYw8Jlxud5hmIx0suX3T+biqUl8LgP/Fj/HX+kitgUcVYd5xDq0jsWGPMQBUw/3ez
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2026 20:11:46.3201
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed5f0ce5-a96f-4853-68b8-08de6e60c6c1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB53.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9183
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_TWELVE(0.00)[33];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7];
	TO_DN_NONE(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Ashish.Kalra@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71185-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[amd.com:+]
X-Rspamd-Queue-Id: CA88014FE30
X-Rspamd-Action: no action

From: Ashish Kalra <ashish.kalra@amd.com>

Add a debugfs interface to report per-CPU RMPOPT status across all
system RAM.

To dump the per-CPU RMPOPT status for all system RAM:

/sys/kernel/debug/rmpopt# cat rmpopt-table

Memory @  0GB: CPU(s): none
Memory @  1GB: CPU(s): none
Memory @  2GB: CPU(s): 0-1023
Memory @  3GB: CPU(s): 0-1023
Memory @  4GB: CPU(s): none
Memory @  5GB: CPU(s): 0-1023
Memory @  6GB: CPU(s): 0-1023
Memory @  7GB: CPU(s): 0-1023
...
Memory @1025GB: CPU(s): 0-1023
Memory @1026GB: CPU(s): 0-1023
Memory @1027GB: CPU(s): 0-1023
Memory @1028GB: CPU(s): 0-1023
Memory @1029GB: CPU(s): 0-1023
Memory @1030GB: CPU(s): 0-1023
Memory @1031GB: CPU(s): 0-1023
Memory @1032GB: CPU(s): 0-1023
Memory @1033GB: CPU(s): 0-1023
Memory @1034GB: CPU(s): 0-1023
Memory @1035GB: CPU(s): 0-1023
Memory @1036GB: CPU(s): 0-1023
Memory @1037GB: CPU(s): 0-1023
Memory @1038GB: CPU(s): none

Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/virt/svm/sev.c | 101 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 100 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 0f71a045e4aa..c5a11f574e42 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -21,6 +21,8 @@
 #include <linux/nospec.h>
 #include <linux/kthread.h>
 #include <linux/configfs.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
 
 #include <asm/sev.h>
 #include <asm/processor.h>
@@ -151,6 +153,13 @@ struct rmpopt_socket_config {
 
 static atomic_t rmpopt_in_progress = ATOMIC_INIT(0);
 
+static cpumask_t rmpopt_cpumask;
+static struct dentry *rmpopt_debugfs;
+
+struct seq_paddr {
+	phys_addr_t next_seq_paddr;
+};
+
 #undef pr_fmt
 #define pr_fmt(fmt)	"SEV-SNP: " fmt
 
@@ -547,9 +556,14 @@ static void get_cpumask_of_primary_threads(cpumask_var_t cpulist)
  */
 static void rmpopt(void *val)
 {
+	bool optimized;
+
 	asm volatile(".byte 0xf2, 0x0f, 0x01, 0xfc\n\t"
-		     : : "a" ((u64)val & PUD_MASK), "c" ((u64)val & 0x1)
+		     : "=@ccc" (optimized)
+		     : "a" ((u64)val & PUD_MASK), "c" ((u64)val & 0x1)
 		     : "memory", "cc");
+
+	assign_cpu(smp_processor_id(), &rmpopt_cpumask, optimized);
 }
 
 static int rmpopt_kthread(void *__unused)
@@ -672,6 +686,89 @@ static int rmpopt_configfs_setup(void)
 	return ret;
 }
 
+/*
+ * start() can be called multiple times if allocated buffer has overflowed
+ * and bigger buffer is allocated.
+ */
+static void *rmpopt_table_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	phys_addr_t end_paddr = ALIGN(PFN_PHYS(max_pfn), PUD_SIZE);
+	struct seq_paddr *p = seq->private;
+
+	if (*pos == 0) {
+		p->next_seq_paddr = ALIGN_DOWN(PFN_PHYS(min_low_pfn), PUD_SIZE);
+		return &p->next_seq_paddr;
+	}
+
+	if (p->next_seq_paddr == end_paddr)
+		return NULL;
+
+	return &p->next_seq_paddr;
+}
+
+static void *rmpopt_table_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	phys_addr_t end_paddr = ALIGN(PFN_PHYS(max_pfn), PUD_SIZE);
+	phys_addr_t *curr_paddr = v;
+
+	(*pos)++;
+	if (*curr_paddr == end_paddr)
+		return NULL;
+	*curr_paddr += PUD_SIZE;
+
+	return curr_paddr;
+}
+
+static void rmpopt_table_seq_stop(struct seq_file *seq, void *v)
+{
+}
+
+static int rmpopt_table_seq_show(struct seq_file *seq, void *v)
+{
+	phys_addr_t *curr_paddr = v;
+
+	seq_printf(seq, "Memory @%3lluGB: ", *curr_paddr >> PUD_SHIFT);
+
+	cpumask_clear(&rmpopt_cpumask);
+	on_each_cpu_mask(cpu_online_mask, rmpopt,
+			 (void *)(*curr_paddr | RMPOPT_FUNC_REPORT_STATUS),
+			 true);
+
+	if (cpumask_empty(&rmpopt_cpumask))
+		seq_puts(seq, "CPU(s): none\n");
+	else
+		seq_printf(seq, "CPU(s): %*pbl\n", cpumask_pr_args(&rmpopt_cpumask));
+
+	return 0;
+}
+
+static const struct seq_operations rmpopt_table_seq_ops = {
+	.start = rmpopt_table_seq_start,
+	.next = rmpopt_table_seq_next,
+	.stop = rmpopt_table_seq_stop,
+	.show = rmpopt_table_seq_show
+};
+
+static int rmpopt_table_open(struct inode *inode, struct file *file)
+{
+	return seq_open_private(file, &rmpopt_table_seq_ops, sizeof(struct seq_paddr));
+}
+
+static const struct file_operations rmpopt_table_fops = {
+	.open = rmpopt_table_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release_private,
+};
+
+static void rmpopt_debugfs_setup(void)
+{
+	rmpopt_debugfs = debugfs_create_dir("rmpopt", NULL);
+
+	debugfs_create_file("rmpopt-table", 0444, rmpopt_debugfs,
+			    NULL, &rmpopt_table_fops);
+}
+
 static void __configure_rmpopt(void *val)
 {
 	u64 rmpopt_base = ((u64)val & PUD_MASK) | MSR_AMD64_RMPOPT_ENABLE;
@@ -849,6 +946,8 @@ static __init void configure_and_enable_rmpopt(void)
 
 	rmpopt_configfs_setup();
 
+	rmpopt_debugfs_setup();
+
 free_cpumask:
 	free_cpumask_var(primary_threads_cpulist);
 }
-- 
2.43.0


