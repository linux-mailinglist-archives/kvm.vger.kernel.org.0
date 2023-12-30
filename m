Return-Path: <kvm+bounces-5373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 505C58207A8
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 18:26:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E24D1C215A4
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:26:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74A40BE67;
	Sat, 30 Dec 2023 17:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5mn+LMo0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2068.outbound.protection.outlook.com [40.107.96.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43814BA31;
	Sat, 30 Dec 2023 17:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NxnGdIPIErkme2Rfy4L5c1B8VakEQskps8WCA4dckysbXj9LijVRkKVjpIrApDJgnBk2iDK2rjrf3sjV/9KkQFSWfB19SilhrG3OyorvBMrqpnoAJTbrqE95/YjEpR4UwROV54meSkfcGA0xyCBVgStPYPt8s+f2ON8hSIycEejdgX6bTq+uO1IBTI0lfyrikQNUz31f12k76ow9DCfyNCbopecQMoQ4dHv6fJI450bEFdWlzolt8P0iVp3r3i8gJlqw6oHB1ZiPuYvVGTrM6PGPko5U0kjaaq0NXMu1Ie4Ca2GJt/eH+BoGZq8wpVI3eBhue0rfECC5PC0kF1yXfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XW04+E2Df2todv0ZCxN+pX2ofEBBzIcQaDGHiC98WyA=;
 b=ZScfZoV7R5VuhMxxW2hX3ht0UwN60/P61H8dqh1tNvH0Zx501jTEzP/2AtrX9YfUsIvY5sQfHP6AiKyQv1bz9NEcTSuyUEeek/OS4nl4i89VHAQBcaUluWo2sF7B0pVm9/YzXnYx+N7bZGq6NoXkOJiQV5Uw6mtOFEHnB+t4nqfMSHl9bVe7wOQJzS4d6NldnT4XrdZIQmtBDn34cxwRzLo9+1Thdm8ZWulPEutOB7at3d3B4E7WegC+6HSfho1rIbfvwooBV4rkjok+2F8lm4uH0A2Pf71UIOaKzEo2pBPNadvIogUN4dCE67RQcf4ndI+NngYVAPuIwJkuyNxC4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XW04+E2Df2todv0ZCxN+pX2ofEBBzIcQaDGHiC98WyA=;
 b=5mn+LMo0Egw+O2EM48keqkqpmTkGXauj7fKGPvzBHH1TLth5NAOcXQWhcXmN1wXV4JnjzOeccF89tLc20H+7Dws/KGoANHA9tYSai3q61l3EyelgwMiBTIX3tbzLEnkG7MNjOYgvSi5xgGmezQVhieX2s3B6rQBSLQIzdj9lXPA=
Received: from MN2PR03CA0006.namprd03.prod.outlook.com (2603:10b6:208:23a::11)
 by SJ2PR12MB8159.namprd12.prod.outlook.com (2603:10b6:a03:4f9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.23; Sat, 30 Dec
 2023 17:25:24 +0000
Received: from MN1PEPF0000ECD8.namprd02.prod.outlook.com
 (2603:10b6:208:23a:cafe::9b) by MN2PR03CA0006.outlook.office365.com
 (2603:10b6:208:23a::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22 via Frontend
 Transport; Sat, 30 Dec 2023 17:25:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000ECD8.mail.protection.outlook.com (10.167.242.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 17:25:23 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 11:25:23 -0600
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH v11 11/35] KVM: SEV: Select KVM_GENERIC_PRIVATE_MEM when CONFIG_KVM_AMD_SEV=y
Date: Sat, 30 Dec 2023 11:23:27 -0600
Message-ID: <20231230172351.574091-12-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231230172351.574091-1-michael.roth@amd.com>
References: <20231230172351.574091-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD8:EE_|SJ2PR12MB8159:EE_
X-MS-Office365-Filtering-Correlation-Id: 56ad104d-342d-4d10-6f00-08dc095c4e98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Qr+tQ5vtaZiWJawwOsIkeh8lMtzk6kIKV1xQmvkCrHhATUoyHOcg6Zy7U91A2c1p2Hjos3k+Lh5N1XE46BYPJF/kNGiYZro5ls8uRxnImJCMYpLf0Mb0HVikpNCnZu8oEx9VH1pU8G6K6qYrQKoX+8czbvF1qV1tw1MICDf1Tw8NbGJnIHxQdC5VpvVJohyr9xFqlQs85Fv68uL7rHHJQloJJNZUoOwByFdn5Z3R7dBrwL5Fs+LUMZBVqQP8oByQplYFZnyg0RYMMHp7+fiP5KCXPKCEvZm01HpFTf/sHE2xEl9w/SkKbESyRHtZ2Bo/rr4gCiwYqSGH3lmxzXOYcr65bZLdMMplopElGXezmmAsVS58NybQr0NeMcNKAP9qU97sJ140uqlVNn9IqgIKALSnnd/xTfpCHtGWTc376S8dbpPGoSTcDouOA41xArdeh4zEwnuys3dvIagg+Xuc8ttFb9p8htJwwuEBLYQ9wrjGBXXl/gbichWFjIUzSRz9zBMECCxewEIfBHrNCR/PTs2fbA6a7s10zxed2DR9aTuovmdB56aXMnrBKUbxSnFpcY2AFMlbNMoXQ8ApJbES3tcHKBrOjbKC/WfGaAKrP+E+Of2N4QUbnhc/v/TpfTkk7FebmYdbtb8qxbixnuyvSgytzx9LpK/bnpPT/OxuBZm63n7ddol3g0S0UI697CEqHOqeFsgfj9Q8Lq7Ce/s/ujyR4Yc1NIDPodu6CYlndNINT1W/ebYTx+vlIVANZYciSqd3H7fV2iwF3X5BA/FqYK02ub6LqyiDuAzyhBTHubw=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(346002)(39860400002)(376002)(136003)(230922051799003)(451199024)(1800799012)(186009)(82310400011)(64100799003)(36840700001)(40470700004)(46966006)(2906002)(4744005)(7406005)(7416002)(5660300002)(41300700001)(82740400003)(478600001)(36860700001)(2616005)(40460700003)(16526019)(426003)(336012)(40480700001)(26005)(1076003)(47076005)(8936002)(8676002)(36756003)(4326008)(44832011)(6916009)(356005)(70586007)(70206006)(81166007)(316002)(86362001)(54906003)(41533002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 17:25:23.9552
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 56ad104d-342d-4d10-6f00-08dc095c4e98
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD8.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8159

SEV-SNP relies on restricted/protected memory support to run guests, so
make sure to enable that support via the CONFIG_KVM_GENERIC_PRIVATE_MEM
config option.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index e807eb56dc08..4ec53d6d5773 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -124,6 +124,7 @@ config KVM_AMD_SEV
 	bool "AMD Secure Encrypted Virtualization (SEV) support"
 	depends on KVM_AMD && X86_64
 	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
+	select KVM_GENERIC_PRIVATE_MEM
 	help
 	  Provides support for launching Encrypted VMs (SEV) and Encrypted VMs
 	  with Encrypted State (SEV-ES) on AMD processors.
-- 
2.25.1


