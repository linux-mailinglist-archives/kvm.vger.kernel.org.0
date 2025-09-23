Return-Path: <kvm+bounces-58460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DAF8B9448E
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 07:07:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0697C3B9F40
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 05:07:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CBF130E829;
	Tue, 23 Sep 2025 05:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Hrw+0XSb"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010016.outbound.protection.outlook.com [40.93.198.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A19630E0F7;
	Tue, 23 Sep 2025 05:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758603985; cv=fail; b=VckCvNcXcT1Z4WNfB+Nl57d3PKbBJr+j9e+MB25MLjATq7JuPdLKlAZ+7Hkr2s+2CTvLh/cTJovN/VJWSMsYZ392lYszFzJAoyY/SQ5vrXvDXu5d0hGRSAiYHn3L7EHYKiWvtXcdoTnxVnD8CiPr6Vla/9h8fSnNjZtZGqvPVsc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758603985; c=relaxed/simple;
	bh=aARKfMFuixWbmbGswMqgX0cH9S6FOi9sn+SSXn5e6NQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lXQxNEj7cDd8d3WDpgSSvBpDcFmHt34pBGyMYbycDbcOUxJp73vItxxB/4OfVgHiYJFcfOAg6ojiOghexQGggL7IUMBVgCTspbSluLU59Lu+5UxJ+6/N0xMLGFMGCz5A+Do1UDRGlfvoiaJ64v8HzhlqzoGodSryUDTHBfLNpDI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Hrw+0XSb; arc=fail smtp.client-ip=40.93.198.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZMPOFLXDdM10t25touqNDoSN1HTSUED+hQRvUd04CFVTVj3pg53vIbMZMWMFsXqHwRYkz8WTjuq654itNmxGePMbZgNECoqYt6BZmUza974aM2O442L9lN+fFIIKke5y1+LfvamHnyfPpuf475FIL8CimK2hF9s6dM9s8OVudpdddmFPWuSpbU6KGxBbzwFI3X+q9/MA7/nobfzjwftApEBq6JLAqCqzdb0/HnpLgN+Te3PG59J4DVVQhFffz4mhib2ygsQQOtfy80eBoe3mXgsd8lj45EIna/OMAP3jPyIwqpe09HUzCiVbJ6/AoIYbyJduwMdiB1xLPC92EcOIGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AQoCDSd0jZErkZvsv3suwuSpp8XBuAW7PMsHWt43O3Y=;
 b=ureZx5VbUtPOrR5HfIfr1NpPm7RD38uYu5gPc8pAhAu6sqUSb0gdN+O/qf9Ev3hU95RDqaNFYP0QXnCcwJdObmdxZVtlseDkiHxBa7TQ+h+s1fwCHestvsTxD4ABuYGpdkExV5XvFPsVhgdx/poij6yHYoVrgNgoCBvyCUjz3t7qvTobZzl7qHtj9wB1DIHT2zWKs7AzXRh2aQS1LQqQle2MwC/nsG8GKrLKWSEpHrCxoYKPjUhtJL0mi5wIKrU/TzrGGDlmJpq0MJm370ay1oov0Vxi99j1I3tBoZVXd4mkPpdTjhTenXyGtTFthARycOdxe9QhtpNBtmTQsm8Q1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AQoCDSd0jZErkZvsv3suwuSpp8XBuAW7PMsHWt43O3Y=;
 b=Hrw+0XSbOJy+TS3f/21NDUazY10GfP6sXHbnVJQ2y0bQ4T3JQ/6FqsZJBh/7F8h608vL0TK8ISif734sJ/by/R+CP7e9toez6fLHhVTpQqfUpLJ8TORLvIIBkNvMPT5Ifl6/K8PjZPjXC3d56+aiScE2MITxzn3cypsquPggyv0=
Received: from BYAPR02CA0016.namprd02.prod.outlook.com (2603:10b6:a02:ee::29)
 by SA3PR12MB8802.namprd12.prod.outlook.com (2603:10b6:806:314::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 23 Sep
 2025 05:06:20 +0000
Received: from MWH0EPF000971E4.namprd02.prod.outlook.com
 (2603:10b6:a02:ee:cafe::b4) by BYAPR02CA0016.outlook.office365.com
 (2603:10b6:a02:ee::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.20 via Frontend Transport; Tue,
 23 Sep 2025 05:06:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000971E4.mail.protection.outlook.com (10.167.243.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Tue, 23 Sep 2025 05:06:19 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 satlexmb07.amd.com (10.181.42.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 22:06:15 -0700
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <Thomas.Lendacky@amd.com>,
	<nikunj@amd.com>, <Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <bp@alien8.de>, <David.Kaplan@amd.com>,
	<huibo.wang@amd.com>, <naveen.rao@amd.com>, <tiala@microsoft.com>
Subject: [RFC PATCH v2 10/17] KVM: SVM: Set VGIF in VMSA area for Secure AVIC guests
Date: Tue, 23 Sep 2025 10:33:10 +0530
Message-ID: <20250923050317.205482-11-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250923050317.205482-1-Neeraj.Upadhyay@amd.com>
References: <20250923050317.205482-1-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E4:EE_|SA3PR12MB8802:EE_
X-MS-Office365-Filtering-Correlation-Id: d8658dba-d3f6-426a-3dca-08ddfa5eeef5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WedGPH8BkqoLskNQqeRdTKYc3f9hdMvRIMFfGq5XU1uaAC9JLUm+aOdOt1VQ?=
 =?us-ascii?Q?ZAuTvvUtQvSMUYnDZbcA+wrd6JxS+sp4MkVUwiazFtZekePqB6EF585pIDhW?=
 =?us-ascii?Q?sIrYBs0aY2dDEkFiq6iR3U2QmMXW3CEPjWWCrfZbmcmH/oqHFBXy0rEoVjHW?=
 =?us-ascii?Q?I1zDaQpnYlAd3VyZ42TKKblP4H5HTSPeZ0FVf3qCa7svrIspPsebESiMVuKy?=
 =?us-ascii?Q?yHm0I/iPBlx8RdTJHL396h6TSYooLkwJbxWgFqkQGx1KsFVA4oqeZ20QnQp+?=
 =?us-ascii?Q?pV88j022ff+/XqVZeTW4n+lf2++0yH4xBQrKj+0MTmoQEjqEG+g6uMs0HJSQ?=
 =?us-ascii?Q?K0kl6ANl7kl82AR249rjteK/B7rWJDmAf7GsT43pWYHtwQ8YSrJP+Gn0UwYm?=
 =?us-ascii?Q?/cQsgwdditRUjjzErCiT156quntS1f3/NtPtr6YA8c5LTbUSQ8AdzcFwNa4X?=
 =?us-ascii?Q?eJSDd1f/QXi22G7/cYNwnOQWw6hkn3/FgCNrSpWNl6WdCCD90Br0bYJVxPbH?=
 =?us-ascii?Q?wDJFTh92qC1C9cgFP+vrJmhFLKL6svjXOZaGbMI0a9OKSh1xmz9gnwobkxpn?=
 =?us-ascii?Q?7peKpGxPzHoQq9sLJfo23w5HvQZR+IOcsWRNFJ0sFqxE1fch6yQg92QezlaA?=
 =?us-ascii?Q?gDW3aXLO25uFt/4WfNb0mtnsXZ/YFkkjFER8ZumeGybgXFWLfTyysOUCYcjZ?=
 =?us-ascii?Q?W81uTUsVMpdI88so30DVXfIFQYGdWRo7q/E7BsejjUlB9IX0lxl3hoDDO9h4?=
 =?us-ascii?Q?vrA/17EkzOTZDJe33FzkzQCLQ9FKNxPGkW+90Isn+LOie2aY+McgbF3thbPu?=
 =?us-ascii?Q?84ce7ETDVcXIQj0Z/HNtjE7zYYfJg+ZniZ4V6bKPDbUI+DSrTSTkH5m80vs8?=
 =?us-ascii?Q?9DCNGJFf7CxgDXNRwRzZuadC2/h3Id6tfyFd8rO23TZaOM8AFIcRHCSqDUVJ?=
 =?us-ascii?Q?SzAJHU6T2e95saVj5BqUlmlkmXEDS0KmKLTR8WG0m0FIjktAQ7ouku5+piUh?=
 =?us-ascii?Q?mkWovlz+cs2VN81M6HR1LJQliWjTA6wgvut7x/hNL9csuZd535cvmEw+5prt?=
 =?us-ascii?Q?V7OZqoFElIwgWgAsFfjKEWh2RZfZ/proiNbLxpXUbnzEyMK7vwrsZQik+f4A?=
 =?us-ascii?Q?GYJmReEM7lf3ACm+qeCxnjpObBtsv4ese4mFL5/j212MWgZfw+jNvUpyOM3d?=
 =?us-ascii?Q?eeEPzpDrdXBiWkaAJAQrscYUSd0+uxPrwzw9bcdglLvBXt6JWADcL6z/PU43?=
 =?us-ascii?Q?DwdOFNdX2GgkAdpndwi7JU6lPuUT9zUUlca5zeX72umCFyEr/xauxYA9KHB7?=
 =?us-ascii?Q?naHZwBQIVjoD8q4Jhax3fpWHYZvFkPzm6Fd4ZaTUbpFrqINo+Cenrx+4F8Ug?=
 =?us-ascii?Q?N/Gish/N/oOqMraXSo1ssXwSUOd6zFVT/vwxD3Qf5uTXtwbaB320ITO7zPGt?=
 =?us-ascii?Q?6IcW4nb0VWNjo8UsRPSIPhcidW+H95w3l0hClDCeYJavsSmz3Ig7aMfI9K5G?=
 =?us-ascii?Q?TW2pbNObaEuqZ8YrhIZeQhfnTHhck+4aZgt2?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 05:06:19.7950
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d8658dba-d3f6-426a-3dca-08ddfa5eeef5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8802

From: Kishon Vijay Abraham I <kvijayab@amd.com>

Unlike standard SVM which uses the V_GIF (Virtual Global Interrupt Flag)
bit in the VMCB, Secure AVIC ignores this field.

Instead, the hardware requires an equivalent V_GIF bit to be set within
the vintr_ctrl field of the VMSA (Virtual Machine Save Area). Failure
to set this bit will cause the hardware to block all interrupt delivery,
rendering the guest non-functional.

To enable interrupts for Secure AVIC guests, modify sev_es_sync_vmsa()
to unconditionally set the V_GIF_MASK in the VMSA's vintr_ctrl field
whenever Secure AVIC is active. This ensures the hardware correctly
identifies the guest as interruptible.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/kvm/svm/sev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 837ab55a3330..2dee210efb37 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -884,6 +884,9 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 
 	save->sev_features = sev->vmsa_features;
 
+	if (sev_savic_active(vcpu->kvm))
+		save->vintr_ctrl |= V_GIF_MASK;
+
 	/*
 	 * Skip FPU and AVX setup with KVM_SEV_ES_INIT to avoid
 	 * breaking older measurements.
-- 
2.34.1


