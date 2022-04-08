Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9AD74F8CC0
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 05:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233159AbiDHBAA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 21:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiDHA75 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 20:59:57 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2047.outbound.protection.outlook.com [40.107.93.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54FF53024F2;
        Thu,  7 Apr 2022 17:57:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q/w50OgND1hfjpzXSppcRnh3HpnkU3n7we6teSeDatWeqDBm67tloiAASMtc1uldn4fWn5EviPWweURmlX82cQXtl3ubJCsft6LcEP2bB+KxOq+9CMMqj9LB0H0DvS2D8sRlnzjxLYKCDLlbVKywk0jW/uu9pyStYwa9pXGXa1T+zkRlkHl4M9TQjdPRG2saL3U9LB25KLV+iXqlkzEl7dFLyQ1MWHDbbvz2yxKQbN/FmosrNo3HEr+weNpPkCPDnVi5MHmexiQ/ZvndaPlJJGPE3NwMwGLdL/0Tlf/zt/Nze5kaeLTNGLpDLu9q4d7xTek39IcF78zuctZrxjIHhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6gl3/+Ur8bi6XeKv4AMOY8Eoo43SLooo6EIRFD6MUQk=;
 b=Y/X+P/GpC+XoL+b8WXtS5SrlPTLpAibmuNj9XWdup4IxoAyqHTBEpXz0i9tPL+JeCOpc6wgTjnParkqOePZmFlp534SiJG/LtqHKsjHH6vuP1tU3MEYL0em1dU205wU1JYR7t6ifHh5DaTRUISu+luLIYBW9tm+uvmVCrivnoY9ivWSHjmpoaUM5ZSHJ73OJGWXeNhsTYR4kkssOowfAj6kcS6EU7r+pUFKA2lnhEz0ghelIHEasDCqB1HF0RvbzGjC+INT6ed7Vn3nmVZJFloN3xgTUZCvzfEP1Imo5RCCZk4BjMVldBrzQTL6A/zNYS8idc7t52LI0iKBNf0f4/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=zytor.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6gl3/+Ur8bi6XeKv4AMOY8Eoo43SLooo6EIRFD6MUQk=;
 b=yXyUOJepNcCtjhx5TJKlICvBa89rvOFPUKhvtO+WQDi11T7/YBbSCKxHTTUuae9oY3tzR/9YL1DpY4pjW/1zPpe37/3gH+3sJWRtx5bmzoZ1U7VJ5MOD3LWf1SYP7M0d4vjQChWrBcIqk8I3ziZ9BAVS74aL5/RyXh/86XihUJc=
Received: from BN6PR17CA0058.namprd17.prod.outlook.com (2603:10b6:405:75::47)
 by BYAPR12MB2630.namprd12.prod.outlook.com (2603:10b6:a03:67::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Fri, 8 Apr
 2022 00:57:53 +0000
Received: from BN8NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:75:cafe::91) by BN6PR17CA0058.outlook.office365.com
 (2603:10b6:405:75::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21 via Frontend
 Transport; Fri, 8 Apr 2022 00:57:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT003.mail.protection.outlook.com (10.13.177.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5144.20 via Frontend Transport; Fri, 8 Apr 2022 00:57:53 +0000
Received: from [127.0.1.1] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 7 Apr
 2022 19:57:51 -0500
Subject: [PATCH 1/2] x86/cpufeatures: Add virtual TSC_AUX feature bit
From:   Babu Moger <babu.moger@amd.com>
To:     <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <dave.hansen@linux.intel.com>, <hpa@zytor.com>,
        <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <vkuznets@redhat.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <wanpengli@tencent.com>, <joro@8bytes.org>, <babu.moger@amd.com>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>
Date:   Thu, 7 Apr 2022 19:57:50 -0500
Message-ID: <164937947020.1047063.14919887750944564032.stgit@bmoger-ubuntu>
User-Agent: StGit/1.1.dev103+g5369f4c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 56eb1209-17fb-4e0f-9730-08da18facfca
X-MS-TrafficTypeDiagnostic: BYAPR12MB2630:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB26309FBC262BF7EF5A6FD23495E99@BYAPR12MB2630.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b931W7yx4Ot4eclmGsOc4lcxwaq0zg8z6PB97lFLl7rAecdyvwb2i4paht5KTtIiSF84iADY5xuNb+JP5dOO6FGNTryRUbW+H0iLEs3TJSOw7hifpxBi9tI/yc8WKXzjrmgoRUCcaVk0Dk5Sxl0ccTHPqXmWAm53lbvmlVqSxwYy3blg7Mmi3ewBIhP4QiS9fOvj3kGwEtZ/Vfk78xfOZg2ozwn+cYGMdvrEATWq6603WUJgH7Tcdo8YwedrACGEgVvY5N5zMG1Yr285QCWGXUWHJntCa2qFu0JGc73X7jwCNkmb6xzCs1nk/+WL90X3jso8vYjRhzmE0yGTMxOot7RHI4apKlQ/MhldTbEnSQQxtJFn/JQagmSRpzISUVa2eIIRxnC0+fCIZYDAg2pBNLDh+HbjJ4ZQJ1rQQs4HrHqKnf+LimORd4q95gBvY51KLCwyloRnQYmn+sbEMNuK6ki3Tuu+80dr1Ja/ZjQs/AFe6JUfUHVYSxsk8WB+bF4EAexrMGjeD1gwrUYkcYi9zgX1sTHT0uNa5C1GAEvPr2GJO2v3w+qTbLY2y5T9R7U4OM2qMsDdI85X9B0j/56WSwiwZcEj5CZ1LhTiF4L9KnqEFM0VeVdEaX9GVUU415AZ+I0vzuLqX9T4kN0JTiBJLNmHw97b9WQsvBfmwRhKLUbKoQUIALXCsPiZWwYq5zP03Og5VskdQCT4m+zviPgjNkffhzo4VR0j9ZzqNhOhnJo=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(7916004)(4636009)(36840700001)(40470700004)(46966006)(16526019)(336012)(33716001)(81166007)(26005)(186003)(44832011)(47076005)(70586007)(82310400005)(316002)(70206006)(8676002)(4326008)(83380400001)(54906003)(16576012)(110136005)(9686003)(426003)(7416002)(5660300002)(508600001)(103116003)(36860700001)(356005)(2906002)(40460700003)(8936002)(86362001)(71626007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 00:57:53.2772
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 56eb1209-17fb-4e0f-9730-08da18facfca
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2630
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The TSC_AUX Virtualization feature allows AMD SEV-ES guests to securely use=
=0A=
TSC_AUX (auxiliary time stamp counter data) MSR in RDTSCP and RDPID=0A=
instructions.=0A=
=0A=
The TSC_AUX MSR is typically initialized to APIC ID or another unique=0A=
identifier so that software can quickly associate returned TSC value=0A=
with the logical processor.=0A=
=0A=
Adds the feature bit and also include it in the kvm for detection.=0A=
=0A=
Signed-off-by: Babu Moger <babu.moger@amd.com>=0A=
---=0A=
 arch/x86/include/asm/cpufeatures.h |    1 +=0A=
 arch/x86/kvm/cpuid.c               |    2 +-=0A=
 2 files changed, 2 insertions(+), 1 deletion(-)=0A=
=0A=
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpuf=
eatures.h=0A=
index 73e643ae94b6..1bc66a17a95a 100644=0A=
--- a/arch/x86/include/asm/cpufeatures.h=0A=
+++ b/arch/x86/include/asm/cpufeatures.h=0A=
@@ -405,6 +405,7 @@=0A=
 #define X86_FEATURE_SEV			(19*32+ 1) /* AMD Secure Encrypted Virtualizatio=
n */=0A=
 #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* "" VM Page Flush MSR is su=
pported */=0A=
 #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualizat=
ion - Encrypted State */=0A=
+#define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* Virtual TSC_AUX */=0A=
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced ca=
che coherency */=0A=
 =0A=
 /*=0A=
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c=0A=
index b24ca7f4ed7c..99a4c078b397 100644=0A=
--- a/arch/x86/kvm/cpuid.c=0A=
+++ b/arch/x86/kvm/cpuid.c=0A=
@@ -674,7 +674,7 @@ void kvm_set_cpu_caps(void)=0A=
 =0A=
 	kvm_cpu_cap_mask(CPUID_8000_001F_EAX,=0A=
 		0 /* SME */ | F(SEV) | 0 /* VM_PAGE_FLUSH */ | F(SEV_ES) |=0A=
-		F(SME_COHERENT));=0A=
+		F(V_TSC_AUX) | F(SME_COHERENT));=0A=
 =0A=
 	kvm_cpu_cap_mask(CPUID_C000_0001_EDX,=0A=
 		F(XSTORE) | F(XSTORE_EN) | F(XCRYPT) | F(XCRYPT_EN) |=0A=
=0A=

