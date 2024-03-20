Return-Path: <kvm+bounces-12242-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 207F8880DBF
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:51:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8A31F1F2282B
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:51:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 751643FB97;
	Wed, 20 Mar 2024 08:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vq8luqD9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2085.outbound.protection.outlook.com [40.107.94.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1013FB8C
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710924562; cv=fail; b=WK3KoWQbqockDDquiOMzKVgpYJf1BDyiFDVnCWhMYsoe7Zh14JFBOUDH/IEkjKYgv2j5QdidGKQJJxqaVXFLd/gxSfL4oIs1tDUQdwSlNtgVFqiocQUsLv/5NKFJ0koCyuzPA7LfJPXjhtoy8WLMyplkZ/M4mT68rpjAAdy/mpM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710924562; c=relaxed/simple;
	bh=o2e4u0cB96+EpJue2zBbSH9CW59fwSOKvEI685qg9gA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EZGj4m18LjQ77rZFAlcoBujC8c8+5NVADZ8cCnPf3wXWXEDQb9ghBhrQRq5Mn8rHA3fELF5Nljf+RU9bimpAU5Z4a3Y4sNGJUz0G7JDl+hSz4oN2I9lDalo4pPXAMHlQrJ2QbtyqayWuqKzs/Ybxv0tVreEJa18SyFHilOGEGs8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vq8luqD9; arc=fail smtp.client-ip=40.107.94.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OgdgrGdmxHlC58XtUZZn91tIBW8ukDEOVhOihBRLopFhvVBcUQs5jhTcS7eyVUsQf4pG0Ze6gxDcBw4ES1GYXKRY+y7qazmKjSby1xiyF+3C8XES4QVgqdf1rsiOYKFQIhG+QJefRZUBw3nEn36ebPmnJTSu0YNZKlygw5QGUfNbD4kQobRbLCxKTAX1yJpwuVYiiZVYl2e4KTvGUP97qzukMaY3MRDatVr3ryJ8A2AujVFt9ij8pqNnECxjl/p9CvPkVVUxf6O3W6TFxcEiG1D/TnklghO7WIZx7S1Xi1QC6adc11svpAthwixFTCjwoB5m5ZOoREe2lFdcg/Isfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jnMw7Oea0EMkYL0wE15+n1cEbuW+y1dR9qORsyxIdj4=;
 b=AfARDZZRHCW38+mCrLO5zz3zv3Z52KjYogtc5V7TKRFbGvqAR6MjbbSU2a2dSVJV5VrwjSOxfqW7Day1RcovKbyTtY+6TscQ3H9VrlCw8KkzkX51MFYG6/P3OLlh81wh50J1rWc+7W7+xlF4X265KSSC1yiCr4/x184qLENVYrS/eX3U1kQ+Lwp4uGdX8OhlFzFWfsSQdKSG34UgbGTL3Th8XYCVNkdO3gUvN+9ya9szUJy02SX5kFzHCbf25ncKDX/kTOtrC0EkWWlmwKCE0GCGbQvZsKQpYcZx8XuRlIm0kqQ+SOUTF3wdSIi1HlZLvZyM2EzYfNK+vptteDKAOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jnMw7Oea0EMkYL0wE15+n1cEbuW+y1dR9qORsyxIdj4=;
 b=vq8luqD9zvjJggzzZIGor+JuZ9VbptosnMDQGEVHZid09pvLtyiXi0UX6+s8ZXdtmb/DotIE2ssJlU1QPuEZYjQdJLvAfR2e048xxceSpf2EzPrr9N5+H8OCIOTzGppHb4VH83qUhEMnjwMrl9yzh3cXC8X4Nq+mTDM78Fc20dg=
Received: from BYAPR05CA0018.namprd05.prod.outlook.com (2603:10b6:a03:c0::31)
 by CH3PR12MB8073.namprd12.prod.outlook.com (2603:10b6:610:126::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.28; Wed, 20 Mar
 2024 08:49:19 +0000
Received: from MWH0EPF000A6730.namprd04.prod.outlook.com
 (2603:10b6:a03:c0:cafe::b1) by BYAPR05CA0018.outlook.office365.com
 (2603:10b6:a03:c0::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.11 via Frontend
 Transport; Wed, 20 Mar 2024 08:49:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A6730.mail.protection.outlook.com (10.167.249.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 08:49:18 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 03:49:10 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>
Subject: [PATCH v3 30/49] i386/cpu: Set SEV-SNP CPUID bit when SNP enabled
Date: Wed, 20 Mar 2024 03:39:26 -0500
Message-ID: <20240320083945.991426-31-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240320083945.991426-1-michael.roth@amd.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6730:EE_|CH3PR12MB8073:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c2a77f3-3efe-402f-c50e-08dc48baa14c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	r0utBL8zQm24tCwVnwi73En871KgeNK/pivl0pocp1TZHRFHyZgibzGcyTsGfICeYRtWTIZ689vyGh9EHOdbxZyfU7R2zc6piJcpiQSmOjXi3BY+3Gzu4qFeoHljPsdJ8YRZ/qslES1DnPvo/faZ8l1ZLlFq5NJIqA2QNPPCXldGGjyfXwL14Xub1+0eU92lSQ6I4bKlMjor1jEW8vFicU3XGCMatXO4IY9BdsEsMiSlu/G5kQnaqFL1j3/z7vna2scKTzJAO31C21ZpssHrcpzeqyKPUscka/iweeK/ZwcsyP+MP8tx5wRUIp0D42Os2CduxxBW6/DC3xjw25EclDakHRHOLKtLcvTluWsIsxhuTfXE29bG+xswIer1aK4EaniZ6lrOufFn4qQyMGNtDRsegU7dsUhEjmN0dAIRW2vp1zkZ5aPYQoVps77GXRw+Vn/+Nd9Bba7PkB8HUE1vk3BhLzRu2EpKTZtUfP2vuwwYA8E9BmivpaHdjQb9l1o6NgD5XxrBoaLZPUex5f3UA/ztm8HEj9Wwd0bGEdb9ffiTyPWk9fwKrN5uf5vPJ6gqJlEpzFt3Z8d47I7bFWQUpYVdYRz3k9eC+lJMgwXrsnrpJpcbBFJoOhEIsvAqgRYJWKfQhg/k6MJ2Ck7PC4YxgTiut/M/lMI/yCuSZNfK/9812JzDHDrwQoj/tIN8277CZf+zvaNBDCCftEXliVUhU/6cn/1yTy3MYOtPiipFi11OzegOT/rC/VDPdcnQD+tG
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(36860700004)(1800799015)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:49:18.5328
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c2a77f3-3efe-402f-c50e-08dc48baa14c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6730.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8073

SNP guests will rely on this bit to determine certain feature support.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 target/i386/cpu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 33760a2ee1..3fdaac3472 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6664,6 +6664,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         if (sev_enabled()) {
             *eax = 0x2;
             *eax |= sev_es_enabled() ? 0x8 : 0;
+            *eax |= sev_snp_enabled() ? 0x10 : 0;
             *ebx = sev_get_cbit_position() & 0x3f; /* EBX[5:0] */
             *ebx |= (sev_get_reduced_phys_bits() & 0x3f) << 6; /* EBX[11:6] */
         }
-- 
2.25.1


