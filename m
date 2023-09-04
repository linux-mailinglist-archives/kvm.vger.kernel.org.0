Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 094AD79153D
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 11:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241182AbjIDJzc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 05:55:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239443AbjIDJzb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 05:55:31 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2061e.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::61e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76F61BC;
        Mon,  4 Sep 2023 02:55:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L6HWEdQSODCI1eny8/r4f9UGcI4dFNB0kTK8NiqOSnbEolw73NsXFHIUosYGoT5G3vE659hkrPGbEcbnyGOuBd+rEyH9YqVSnFlwCIkCnXKns9xz6NdbtzNIZNJ7Ti6kOFJy2X8j0axouaBi0WwxoOvs05kelbrToy9poAt3L0MGV9clwhCdaY8UGPIa6iHuEHd6YRXJ6ztWCcftbCaFo8MgJYHM2DWQyB/BLZ8i50upV9eYIfv6AXhtkTs94B3P+TZ0nfjGS9xDYG6RhUSZc6AypT9YbKCPtclD9veF4y02zct3HF6aldi63KcCCb4ITUxSTvG5T67xWJere8G9ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fsXJp168FLJSsgGJAPsFyPbWw4UFllomazXENoUWkH4=;
 b=J61JgPlbUt/m19W/PhRKTyt/1mGfPcq0c8WG7veyaPCGwGWI86IZkvynYqCZfZsHDM42LZvKTB4PuF8AI/dFk6sEf47J1vXEEETxDTqMGVw7K+NtjUYwbYp18sXpaEoEdOGbum/1JgJ59VcQu7NZPf09FZBRKOZck9Cx6o6vkNocOpLP5tVDyMgnKmDE3jADNs3GhQ3jtoQEFywhU18qDVL/3T+RR6SY5dv9QBB4JqrTv4mSPMYtmTFaCtnWdTPOxOMsMEsPJVGZmYTxiBtQTrIpeuY4jvhAsSmusIz1d6rXPRRVZexHQDuEu7kziPOqMruKs7moOoHxsMi64ad79A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fsXJp168FLJSsgGJAPsFyPbWw4UFllomazXENoUWkH4=;
 b=EDADw724euAsscrX0mm8j4URq9g2XpiN7PMykoA3LA6PUcgPBnzBny44n653394fi32CWQnDjqnGHN+cyLHYaPCnU1jksSDNyS0RBu7g0OZm2Ux7wDCv2r8/2lyU5R0ErKUdfnf8Fm6aERUPywtjjachVN1t9ozUCCY3mue8iaI=
Received: from CH0PR04CA0075.namprd04.prod.outlook.com (2603:10b6:610:74::20)
 by PH8PR12MB6916.namprd12.prod.outlook.com (2603:10b6:510:1bd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.30; Mon, 4 Sep
 2023 09:54:46 +0000
Received: from DS2PEPF0000343D.namprd02.prod.outlook.com
 (2603:10b6:610:74:cafe::9d) by CH0PR04CA0075.outlook.office365.com
 (2603:10b6:610:74::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33 via Frontend
 Transport; Mon, 4 Sep 2023 09:54:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343D.mail.protection.outlook.com (10.167.18.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6768.25 via Frontend Transport; Mon, 4 Sep 2023 09:54:45 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 4 Sep
 2023 04:54:04 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>
CC:     <linux-doc@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
        <x86@kernel.org>, <pbonzini@redhat.com>, <peterz@infradead.org>,
        <bp@alien8.de>, <santosh.shukla@amd.com>, <ravi.bangoria@amd.com>,
        <thomas.lendacky@amd.com>, <nikunj@amd.com>,
        <manali.shukla@amd.com>
Subject: [PATCH 06/13] KVM: x86: Extend CPUID range to include new leaf
Date:   Mon, 4 Sep 2023 09:53:40 +0000
Message-ID: <20230904095347.14994-7-manali.shukla@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230904095347.14994-1-manali.shukla@amd.com>
References: <20230904095347.14994-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343D:EE_|PH8PR12MB6916:EE_
X-MS-Office365-Filtering-Correlation-Id: 64b2caca-44b6-4d67-c1d9-08dbad2cf845
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iWn1ohI0xK6jdbGkHnVfBc/xzCi0qLRiblFF6EssjR2gnRrDk8sFRdL42Ro6H1r6VwJaQHfZK7paBVEejT8Mo6aIW37vEax5Epwuh6XidBu6UcfyjCADMYLYKl21VEIQPGE6fwKYRU9rhb0lfnJg/8jzMj7tFKNFuBIbvqPPDQs9dKuW/eiaUBTXfJVR0pdkpQrlj/Y2rhVNCjnrwh3eFTeoCq8+FAYBJsN7VfoyduX+k7cnr8p2HhaaybesUWEafXlEfmdaDz10m+UVXBQgxAslkgY01u4qObLQTGqYdlMg4kYXGJl9nkZGhOgtE76eGaz/JvJAEOSxWBva8E52J+wE2ZWz/Xa5u4Wzn61/FLdG8qpCKjXTU3MWEja9or4eWNVXmt8A0TaSboKtbNkjxslOsmmcpD7uWBQSxTqC/0SYqaogvn3Nz7s3e9D53Ghgf8hkIAuvZI4xLWUzjrGh9MnWF/GbhoYmPIieUb57kJmR25Y6LaApd6o+r8lXeQ4aalceSAXibwQDwcbClh5EWaMdz0k1yDDpLWLpLleO+/aALhVO5d9AFEBHPobZOjjzvl14Nrx+9obtxbLuoqWQg6v35KwQI19GujFY2D8+sIFoWq35c9T2MBGYC0H2VDkF+HO6V1cLdfRrTqxdNXHOOpug8oRMcfh9305Ui9kneUzNZ8phBzrX9IdzJuO8yskn4KB6goGkgpzkukzqyhM5k2obL9OMGMYcn5AFG+inBE32ydXKXy36Dr7rTn3edNM5yaXLfEfKVK1yWBFAfgUUMg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(396003)(136003)(376002)(346002)(451199024)(1800799009)(186009)(82310400011)(40470700004)(36840700001)(46966006)(316002)(110136005)(36756003)(54906003)(2906002)(86362001)(70206006)(70586007)(40480700001)(8936002)(5660300002)(44832011)(4326008)(8676002)(41300700001)(40460700003)(36860700001)(426003)(2616005)(336012)(1076003)(26005)(16526019)(47076005)(966005)(478600001)(81166007)(356005)(82740400003)(7696005)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2023 09:54:45.7763
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 64b2caca-44b6-4d67-c1d9-08dbad2cf845
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS2PEPF0000343D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6916
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CPUID leaf 0x8000001b (EAX) provides information about
Instruction-Based sampling capabilities on AMD Platforms. Complete
description about 0x8000001b CPUID leaf is available in AMD
Programmer's Manual volume 3, Appendix E, section E.4.13.
https://bugzilla.kernel.org/attachment.cgi?id=304655

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/kvm/cpuid.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 0544e30b4946..1f4d505fb69d 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -771,6 +771,12 @@ void kvm_set_cpu_caps(void)
 		F(PERFMON_V2)
 	);
 
+	/*
+	 * Hide all IBS related features by default, it will be enabled
+	 * automatically when IBS virtualization is enabled
+	 */
+	kvm_cpu_cap_init_kvm_defined(CPUID_8000_001B_EAX, 0);
+
 	/*
 	 * Synthesize "LFENCE is serializing" into the AMD-defined entry in
 	 * KVM's supported CPUID if the feature is reported as supported by the
@@ -1252,6 +1258,11 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->eax = entry->ebx = entry->ecx = 0;
 		entry->edx = 0; /* reserved */
 		break;
+	/* AMD IBS capability */
+	case 0x8000001B:
+		entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
+		cpuid_entry_override(entry, CPUID_8000_001B_EAX);
+		break;
 	case 0x8000001F:
 		if (!kvm_cpu_cap_has(X86_FEATURE_SEV)) {
 			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
-- 
2.34.1

