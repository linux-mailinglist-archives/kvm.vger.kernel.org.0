Return-Path: <kvm+bounces-33886-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DF719F3E8E
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 00:58:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 393C1188BB44
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 23:58:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1C1A1D45F2;
	Mon, 16 Dec 2024 23:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hZ6UgaPe"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2073.outbound.protection.outlook.com [40.107.100.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB0B1D63D9;
	Mon, 16 Dec 2024 23:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734393512; cv=fail; b=cZXCpXW/0tMSuvIIftZxzhoc11YMUgfCzg3kqzYthLpRQCwgUyhY3EbZPrVot2wD9IcV/Ai+9LEaO16rMWFA+pes9YJ9o7thQ+i9opHV3gN1cI2HcxVRco425LNVvxyPt7mNLaFO6pOw9zVjVhgoS1fq7Bypilsrd7ys9oreDs8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734393512; c=relaxed/simple;
	bh=e3L9DsLMZta3TZFGP3V8ILR11hrCz4RTozquZEk9UcQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dj5A9tnrmnamTh9D1qOSuzeLkss00OXQ9i3cj9OztJu/WohnbBIJs7vdVvT1mUWLMVRscMahAeOAJ6bTK6wL2esyAqcdHPggHXzuCqh+gNU6blqdtsGi6Q/Uu58zYpZuYZTtrglYlVyBsR0MugocdTqdaQ+L3D5EH/Gf/MfhJ0g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hZ6UgaPe; arc=fail smtp.client-ip=40.107.100.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j1XvHmktB8FPpMBzMz3bT732oVcUAgfU7K3KC0CKGCCnz7stwDO89IUDtFhWHlFpYN+DfAFRMoaYcTuN/brQodg5yy6EZ+qb0YUrTBkasvB+C1L5YQoG4LZwj8uiQweHzaLwG0PIUH1I/NBw1CMjrCizFgDPrGstx/+W7jF/iU3Z7sTqYzykxzi5dY3a97eV0/eUOp1ohcVfL6A8vCphSVGxluISvaER5A/7ZJv1V0VQCih3DfXU6uUbZoM1XyXxEy/x0g4ZR/EpqLRdRfqCVypu91JBO7qb3JvYTaDF8O0j9vTftunMIRIANKO55LNdT9JUgticqzJYcVdz0mnt4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wsggXyd3M7q7o8HxFouKHNcmagYw1VBF1z16lrf7JSA=;
 b=tZH9haKVWtwNHIhXssxAb5EzmQKYhg9kPxBMVO7h0Viz7xdzh7m5gYSqCaho7hHzQOvBpZoSujEzz93rf2ICX/MM1WmqueKQ/F5ZbBVfudMgjpJAvKmiXaKX+Zd3YbGhJpvePVZKpaSbbDjPUDQIuZJiXt+f1hwXyv0Zx9VXMcxrL6Dm356+Ev0sWcQhMwiPxeRB/XYXky//NHUwROK2VyPCr7f0BYWODoxeolxTqNpVyIZgT/leOiDDtczxZgsz09YzjsN60vEkver3jCVJz/Nxz4k9umyhq035hZsBGFPUJjvPKQHxYIPT2ILZTLgiw+HrCzGz1fOzBjJGl4QurA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wsggXyd3M7q7o8HxFouKHNcmagYw1VBF1z16lrf7JSA=;
 b=hZ6UgaPeoTNfDhlUyJksKXYUcnUeeztttnVWBIwViyL/ZpLDaXpQKmsJjZXtuXVSwZHKjGxZvyEu1iw1OMDEV8ZMtHBkEV3GIDTKET3excdoLV8YL/HFOIZ4joHa+okowhMCCCcdcYopvLFlytCxbKEpgO0Ou6rc0mJy5i7WTbI=
Received: from MW4PR04CA0156.namprd04.prod.outlook.com (2603:10b6:303:85::11)
 by PH8PR12MB6697.namprd12.prod.outlook.com (2603:10b6:510:1cc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.21; Mon, 16 Dec
 2024 23:58:27 +0000
Received: from SJ5PEPF00000208.namprd05.prod.outlook.com
 (2603:10b6:303:85:cafe::94) by MW4PR04CA0156.outlook.office365.com
 (2603:10b6:303:85::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8251.20 via Frontend Transport; Mon,
 16 Dec 2024 23:58:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF00000208.mail.protection.outlook.com (10.167.244.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8251.15 via Frontend Transport; Mon, 16 Dec 2024 23:58:26 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 16 Dec
 2024 17:58:24 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH v2 3/9] crypto: ccp: Reset TMR size at SNP Shutdown
Date: Mon, 16 Dec 2024 23:58:15 +0000
Message-ID: <3169b517645a1dea2926f71bcd1ad6ad447531af.1734392473.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1734392473.git.ashish.kalra@amd.com>
References: <cover.1734392473.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000208:EE_|PH8PR12MB6697:EE_
X-MS-Office365-Filtering-Correlation-Id: fa8295ee-1a4e-41d4-21b6-08dd1e2d8843
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|7416014|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EcvK93V3C0OzJuNmJYSVV+Y8CHn4lSeJyJGdfy5ExG0C6+FLWED3g1FYcguu?=
 =?us-ascii?Q?ccnN5KB/A4k9oJ7o9NsTNpBYlbObedhKCuord+NT0nw2S9bm9PcQ/bPBxyxi?=
 =?us-ascii?Q?kutgblhib034M1BmgHDzMjhS1OvZYqKXN8iWGIj4Dlw28UL3EB1jQxRbF48f?=
 =?us-ascii?Q?5T2NPYdncrD8CoBKFlre3xUa/6Ga5Opv3h/nE3cEW6n/qhNCw63RKiH2kOTt?=
 =?us-ascii?Q?P6OPuSrnvNyt7N72kTR/KCYIXo/MPaR19cEUHtrjiW7GlmTeNs3WKYIv0un0?=
 =?us-ascii?Q?VvkV+wLfosn0eWflYIDodCTn9I8uIfk6/EIESwq1E5mP0T+fSoFeWkIkMG1o?=
 =?us-ascii?Q?6iZqOak8aArv8g8lOjm1xq4D7DCmN4QRvio1zz3d5aaaAFchfbHxjh8am6GN?=
 =?us-ascii?Q?YaR7Hsnqcl9rB5y+h0XuTfgWMCH7B5Zf9R9n0V2QTNgGMh4hLi6aWCo8OBOR?=
 =?us-ascii?Q?m4Y9Fnyvoj981MC0A4tw9pAOd/QQMOk7gGh6c1oiCz8rYRzTxXgF6uNaywoj?=
 =?us-ascii?Q?XSKH67jmGvuiFu1UCuUvjMC8y5obvMAbOFKqZcZ8Y/vrOeOoMr5ABw3UBtsL?=
 =?us-ascii?Q?j8XYTbQS4VmSb0rFdB4XHt+HIglSQ1g4U7Gv122fhQNaDxZQMugOddRmfUeU?=
 =?us-ascii?Q?LXqWh67y8JuFUu35AsERpcxYXlvoGUtfAQ4hp3kINqfZAJYuNPRZTMNOXqs6?=
 =?us-ascii?Q?KUitv7ySl3j+5E+ofmitWtydZl6qLmAFnx8Xe4YC1Oa5n2BADlDpWr5Isvq9?=
 =?us-ascii?Q?92TtiWP4AqdO9jvs7W3e/7IKh8Bzs+H3VRDkuOEH2kV1uFo6f0Xq7n8JXBGl?=
 =?us-ascii?Q?aTRn4ZeC/csOvTuBWq5uSchoNf/9QVYfCaNBJb+j85EtelAQBsKYfTwwIjB4?=
 =?us-ascii?Q?vGfDd4Gzy+CniYtkwi9pL6PevEcBVeLvWk5EAq26bRDsb7NX+aRC8qtqhiWH?=
 =?us-ascii?Q?vR1B85OXobdozCs4+M4cqklUvo7Fkv9z0oWxaDCu6JYuevyO1HNxRMXGR0xW?=
 =?us-ascii?Q?ZfRYarRPhWYTqJv2FCEwAw9zh6q/ksahvUH5qHFM0+9agd34DXN1R7FGnL5J?=
 =?us-ascii?Q?BVCtM6Slu3952s9i85WocSRjJd141TiEX0VSwLO0yNiYxYw30ryiqhs+Ij4t?=
 =?us-ascii?Q?QFEixbl+Uj0IA/IM3vMKLwtelS/mZ9KUxKuBDVjMxFg4bYr+CPQJ5Wf0cHID?=
 =?us-ascii?Q?WBabpEowhkP4uTg0+ZQj4GyTUoPoHVIJSVKvBbuQYr2HZxaJPMGHBqaSqeHZ?=
 =?us-ascii?Q?TZ91JpCZlyrueTC+u5ykNR3VFoEJEIU8WylThKH4/7N0wdPWiermTJxylBY6?=
 =?us-ascii?Q?vvAmCSKD7Hf3SroiglKOxPDRQoTq5aDoe8RP8Snir1IkX69YGCBJ8oCqIWK9?=
 =?us-ascii?Q?b/kZyyiyV1o/YH2TdAkiAUGjNQS1b0y3m6ktYA4DHBxvMLkz6KzEVsVsB4+3?=
 =?us-ascii?Q?8IiYcWTL6u9YLQU3D6TD8URFLy9nLbdgDB777LI8kxD8qFF+HXbRLdpKc4C+?=
 =?us-ascii?Q?xjXiZLBJ41+XSPA=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(7416014)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2024 23:58:26.3378
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fa8295ee-1a4e-41d4-21b6-08dd1e2d8843
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000208.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6697

From: Ashish Kalra <ashish.kalra@amd.com>

When SEV-SNP is enabled the TMR needs to be 2MB aligned and 2MB sized,
ensure that TMR size is reset back to default when SNP is shutdown as
SNP initialization and shutdown as part of some SNP ioctls may leave
TMR size modified and cause subsequent SEV only initialization to fail.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 0ec2e8191583..9632a9a5c92e 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1751,6 +1751,9 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
 	sev->snp_initialized = false;
 	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
 
+	/* Reset TMR size back to default */
+	sev_es_tmr_size = SEV_TMR_SIZE;
+
 	return ret;
 }
 
-- 
2.34.1


