Return-Path: <kvm+bounces-23462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A67FB949D29
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 02:59:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32A3028660C
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 00:59:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60E3C1EB39;
	Wed,  7 Aug 2024 00:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RBoprEJL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2059.outbound.protection.outlook.com [40.107.223.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C162D1E520;
	Wed,  7 Aug 2024 00:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722992343; cv=fail; b=KjW0ser+qwUOo5qG2w8OtykuKjgF3hT8VbWsaIAuwriBzzLVUc9n0OJijVdDSjZZ1W49RTAnpC9ARilRye2VX9j3He67E9Y0Zv3EUldeebRLY17cG3tSGfh2HhQsyHkElcDXHgIIpj8tB0HKDdvq0LJouV5TH4sOmYlXkWL8eYQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722992343; c=relaxed/simple;
	bh=QI8lcM155gvsN/0vpySkRHE5Uso3hpCbCzm1Za6gDHw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gBQRyBIV2fOBnLLA7116kSWh1OmvXskp6MzlOGYAiHlxXb03nk/ChIn+xiHDY7aRySvSwBp5/YlCllbB5O4hTgJw6vZuskp6FbnO+KC7Hv/XLrr5joCNJxYM6Va8romuDAF5e8TxQENTXhnXo1sJJus3ChuQcVShdBnEgXb5zQI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RBoprEJL; arc=fail smtp.client-ip=40.107.223.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mNkc0eHzxpNAjYddMHEPLRc6WP+QjXORyyU5+Vd25s59qIzMf6kp7vevA5ZiaY3p697tk2uxvRAl+EUG0DCOfSXR/hhF4jYP4DYY8WpmDzu+TN1WraWC33ECjcNCQVDQn95qa47fJS8+i4CQEp1Qq8diDkjc61yICjeeKynLVu9YCebqTmhgxoTV4M3vgyS+/7eQ36t4C2Uzmg3uP5S4mGHiLJgc9kSyOd1MDDDywR9HaTPjjx8dfyHSUBa9KLvdFmwDk1wYh+wDwoEytk5WvR9T4eNu4zNjujEAAdxr3GoNr3tbP9DEqf2DvMeazvSzjWzEKMHjtFxZlLpRVvnJqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tpm1292gyqgs6s3vVvds7fgnNH/TOdvo/ndkaO/+jLE=;
 b=u7JtBE9kHI+Ia8ZlF/nf/zM5fvCj1dEu43Qgv0BEWua9m8XdAyFGGBNnlc2HOt7h1LwWOSXXFfdAn0NWNK8KLrwMOjqzcddX0xo7KIE68R6dYhDygXuVK+m7VBgfJQs6NpR0J6QbaVdfVX6QkXiCXbYHw+ek+ZmGJq7lH1Qkm4DOTDcRfCURNNy//Srw20IoEt6wKm1asRdcRIZK+A6QwZSFy/+0VGpOyZJ5A485hhwlDqC3+RzQ0xMCrYftZn+507bAqT5y2rSCaMJKQ/vKZH3E9Y4x6AsfXlvAFnw2QREw+bObuuExU9+gHhcK/iCzujrit6OQ+a7VuFLQWm1G6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tpm1292gyqgs6s3vVvds7fgnNH/TOdvo/ndkaO/+jLE=;
 b=RBoprEJLC1Fxe1fWuPzIeVF2YYduuEXIvsO3MBfJ80c7wnx9aPUiZHZkY+Uz4cXY7Ti91xvUdkqnDASRkaVv7of8bb+hLWwxmgl9ZEFvVVrWvLH4ZYnVak3au/+VQFl392XHzx8MUvm53mRhBUIno4dDbQsGGFRJzon5KG72SfE=
Received: from SJ0PR03CA0067.namprd03.prod.outlook.com (2603:10b6:a03:331::12)
 by BY5PR12MB4274.namprd12.prod.outlook.com (2603:10b6:a03:206::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.27; Wed, 7 Aug
 2024 00:58:59 +0000
Received: from SN1PEPF0002BA4B.namprd03.prod.outlook.com
 (2603:10b6:a03:331:cafe::53) by SJ0PR03CA0067.outlook.office365.com
 (2603:10b6:a03:331::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.28 via Frontend
 Transport; Wed, 7 Aug 2024 00:58:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA4B.mail.protection.outlook.com (10.167.242.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7828.19 via Frontend Transport; Wed, 7 Aug 2024 00:58:58 +0000
Received: from ruby-9130host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 6 Aug
 2024 19:58:57 -0500
From: Melody Wang <huibo.wang@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Tom Lendacky <thomas.lendacky@amd.com>,
	"Ashish Kalra" <ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>,
	"Melody Wang" <huibo.wang@amd.com>
Subject: [PATCH 1/6] x86/sev: Define the #HV doorbell page structure
Date: Wed, 7 Aug 2024 00:57:55 +0000
Message-ID: <823068ef26dacb7c7936d87bb6d45db53ff1b272.1722989996.git.huibo.wang@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1722989996.git.huibo.wang@amd.com>
References: <cover.1722989996.git.huibo.wang@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4B:EE_|BY5PR12MB4274:EE_
X-MS-Office365-Filtering-Correlation-Id: ee23856f-b7dd-4bac-07f1-08dcb67c1ecd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ysEh8Bl8JXhPpD8lI1OuiU6pwmHP7y4FY436TE0Ip0yXnxAoyRjzlFv2y2j0?=
 =?us-ascii?Q?lOnTKxZrPswM+Wq6dPscUGHAFAvUzhpo6MoBIJObhL4jGKoEqY3DVCOGhRPX?=
 =?us-ascii?Q?CezloM5qz1xswEu+Z1Kob1LAth99/UZNHMx8e5MJLn2jzESbpuJ0b84hGMOs?=
 =?us-ascii?Q?yS80aZOmVx8bX9aQTeORty/FJpY0iy42aHMbnIIuWNpfirxEPOF836+UY+U8?=
 =?us-ascii?Q?m2IUvv6p0cCoYd1vSc2e/4hp+LTnAfgHtkCgPesOba0FJELfyq7x2blvzaAm?=
 =?us-ascii?Q?W1gUu/39i1ay8R/94sfJ3u/DnICjb3fKTvxuAKg0OoFHUi1EObi8liNJsrrA?=
 =?us-ascii?Q?y3kXQVCBKTqBz7eZty3dlcWcB1BXlejV4b3oYdOloaYQzhMwI5ts5mToIoan?=
 =?us-ascii?Q?WJ/cmdJItX3LL0+EdnLf1KJYuc3aN8g1HyT441c/p6LC9QFACm4FhbGp5yAX?=
 =?us-ascii?Q?xhnJAtxnvK+6S0/aPeiGjgIq6wS6mE//JvRu1f/M3MMPQDofgWsNPD9DLVJD?=
 =?us-ascii?Q?wjeqXTz9PwFB3aU8seuoIVoS1/RG0tiR2nNJTOOAgbq0J1aNTdU3+9eJc8ik?=
 =?us-ascii?Q?gKMyKrYqAam6slOF96WrmN+fHv1UKqESJLcRVNdo5I3QAs19skqyjhJrQ5M8?=
 =?us-ascii?Q?5V2R6d5+ctSr/JOGW0V3R09zzZnuIbSLo7mb+NiDyFK8mCPLQZkh3Ej1Wh5U?=
 =?us-ascii?Q?4SYBWGH1Mb7KvPsnJSRm0Mkxbbx1cAZQ4OEQjbmSX86NbOlzogUZ51su6axL?=
 =?us-ascii?Q?pXNcrxCD8mV63krb/0eYE3DRVQr8UhsYHPG0HX3LaqOeQ2llJsP3Ri1UqRMI?=
 =?us-ascii?Q?8h4wXn2W1nOogF1xG9hu6lb42MTGs1L8QPXOnQlmWLWEcQx8yBmNTDjO3l5N?=
 =?us-ascii?Q?SnldwBm/P4Wa8KaG5w7CvUmcSqm7VwZ2CzXBTu6DId80pzcQGqx8EFShJ4sn?=
 =?us-ascii?Q?Y2scshlpewcQalLHx+zh9X6pWL14ZXiVKrLZ0PM+CbMzLycAFepRPNpkGVU6?=
 =?us-ascii?Q?+Z8RxxsRkpW1IbCOrM/d7dvvvM6bCfl0HmC0INljp/d4Br3QsE57b28tY/pl?=
 =?us-ascii?Q?p02iDGE+54rSXWIq81fxPcGCeMhGmreelxk4AapcLYN57UNdxe3cT+BniXj9?=
 =?us-ascii?Q?cfDgZMgSMHpwFab/YEoKHJl3RwGNQQ1iXIvrcL/JLTdLfN/aJMMx39LQgt4n?=
 =?us-ascii?Q?vSwWRDCSvwpWgWlLcYhU+6zb47kzXH/5CI2qZwu82NIIJn4MK/aowWZ02Blc?=
 =?us-ascii?Q?lv0iuatxFMv7A5nSQ4Psbbe1aHlOuk7B+eFkRg22bK5AcH78saBGYAsGazFN?=
 =?us-ascii?Q?LTSqHxadg1BCVpJ73UHhcrsTeZBEmOwNNN2VEih5HaIU99UX7JxU8gOEE3GJ?=
 =?us-ascii?Q?+JalqQvyuey7oiV3Atw3T69dPSe+qIb0QoTPoCDxCf6bJffi4CYn8SkEAg6U?=
 =?us-ascii?Q?nml3vlIYJ3lnMFGORvP63RRAeJUa+uZL?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2024 00:58:58.7939
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ee23856f-b7dd-4bac-07f1-08dcb67c1ecd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4B.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4274

Restricted injection is a feature which enforces additional interrupt and event
injection security protections for a SEV-SNP guest. It disables all
hypervisor-based interrupt queuing and event injection of all vectors except
a new exception vector, #HV (28), which is reserved for SNP guest use, but
never generated by hardware. #HV is only allowed to be injected into VMSAs that
execute with Restricted Injection.

The guests running with the SNP restricted injection feature active limit the
host to ringing a doorbell with a #HV exception.

Define two fields in the #HV doorbell page: a pending event field, and an
EOI assist.

Create the structure definition for the #HV doorbell page as per GHCB
specification.

Co-developed-by: Thomas Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Thomas Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Melody Wang <huibo.wang@amd.com>
---
 arch/x86/include/asm/svm.h | 41 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index f0dea3750ca9..2b1f4c8daf19 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -516,6 +516,47 @@ struct ghcb {
 	u32 ghcb_usage;
 } __packed;
 
+/*
+ * Hypervisor doorbell page:
+ *
+ * Used when restricted injection is enabled for a VM. One page in size that
+ * is shared between the guest and hypervisor to communicate exception and
+ * interrupt events.
+ */
+struct hvdb_events {
+	/* First 64 bytes of HV doorbell page defined in GHCB specification */
+	union {
+		struct {
+			/* Interrupt vector being injected */
+			u8 vector;
+
+			/* Non-maskable event field (NMI, etc.) */
+			u8 nm_events;
+		};
+
+		struct {
+			/* Non-maskable event indicators */
+			u16 reserved1:		8,
+			    nmi:		1,
+			    mce:		1,
+			    reserved2:		5,
+			    no_further_signal:	1;
+		};
+
+		u16 pending_events;
+	};
+
+	u8 no_eoi_required;
+
+	u8 reserved3[61];
+};
+
+struct hvdb {
+	struct hvdb_events events;
+
+	/* Remainder of the page is for software use */
+	u8 reserved[PAGE_SIZE - sizeof(struct hvdb_events)];
+};
 
 #define EXPECTED_VMCB_SAVE_AREA_SIZE		744
 #define EXPECTED_GHCB_SAVE_AREA_SIZE		1032
-- 
2.34.1


