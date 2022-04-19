Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150B6507B57
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 22:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357831AbiDSU4y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 16:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241627AbiDSU4w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 16:56:52 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2061.outbound.protection.outlook.com [40.107.94.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EDD44198A;
        Tue, 19 Apr 2022 13:54:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TZ2rUBZ1ZRak/ogLvPCHq3APmceWnTinQbeAJigJeG9J0dEN3VSvCpyc0ntHF9W9cKhy3OWg9XyGs9gsz01xcSFz+Z8cZSIhY/O/R7xJQmazmPIvk3xVSLf5fh4JIg4gaC2u9SI8tj8rB6+gCPeeyVy5+hcRamfPzSg3UW1jO5HDtJ8J023ZKoZCWq6EWoMm9V/BBKXQE5o4AlBC2W4ePX7oqWA6227YoSHc1qCqIpHg1ygzWHtVrORHOFZNNh5kwfPe8+8Be7QgRbb0DkM+5OKa48TbzRvlv2KKfNdKUgVx8PBgM+veUcGzc7i4NA3LD2+BdAFsafncQKzZulLc5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0I5T1TI3oFeG2Yi+EYE1B/41ZEmefBBkZ/mExY/ufqc=;
 b=E+1jJv/661m40Hm4XLYACINqI7M/F9FCe1og6Vxkbej/2TueJkdG4TMQYhJNC3G32M4CdJk2fRxvTCuZpG9FqOS0/PPEAy4kMhC9Jz0yOfXaMoEA+gRB9V9Rz4zbFgm/GFOeWkPoG6ERsrrfCNlGvsjZA9qWFuZ7DlRFIPvyj2J+JjnKV5XD5ootAMvIoF+yVwMWNVyvCctkJ3PlcYEY/w3kMCkIjYJ+04BX7qHQBho0pswWfpVferr6NAbrpHgPaohtEchIcPW5h55BWd7F8lmkiJcQeBivyOVyIcCJAg7Rgzci3YlYy1uavPUYReXOcyw7NssX18eoEp/0hN+c2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=tencent.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0I5T1TI3oFeG2Yi+EYE1B/41ZEmefBBkZ/mExY/ufqc=;
 b=h5y3MNXBNNAzK2yUonM4ff8gD0pfeyzaVGH4dYP2xI/QBDISQm3+T/CTX4G4s3WOPX0g+KR70M8TC11dLRGulgAGh1np9xr3HAlNpbugNzW9LbUlJv6pQTUzPmp1TIN7+F4GM4/QO/gdoKBRuK1zGtUxOszdeBCDoFKfLqDukoc=
Received: from BN8PR12CA0017.namprd12.prod.outlook.com (2603:10b6:408:60::30)
 by BL1PR12MB5825.namprd12.prod.outlook.com (2603:10b6:208:394::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 20:54:07 +0000
Received: from BN8NAM11FT043.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:60:cafe::7b) by BN8PR12CA0017.outlook.office365.com
 (2603:10b6:408:60::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18 via Frontend
 Transport; Tue, 19 Apr 2022 20:54:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT043.mail.protection.outlook.com (10.13.177.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5164.19 via Frontend Transport; Tue, 19 Apr 2022 20:54:05 +0000
Received: from [127.0.1.1] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 19 Apr
 2022 15:53:58 -0500
Subject: [PATCH v2 1/2] x86/cpufeatures: Add virtual TSC_AUX feature bit
From:   Babu Moger <babu.moger@amd.com>
To:     <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <dave.hansen@linux.intel.com>, <hpa@zytor.com>,
        <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <vkuznets@redhat.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <wanpengli@tencent.com>, <joro@8bytes.org>, <babu.moger@amd.com>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>
Date:   Tue, 19 Apr 2022 15:53:52 -0500
Message-ID: <165040157111.1399644.6123821125319995316.stgit@bmoger-ubuntu>
User-Agent: StGit/1.1.dev103+g5369f4c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: acd5406d-185f-4049-fd91-08da2246be12
X-MS-TrafficTypeDiagnostic: BL1PR12MB5825:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB58257AF7BF61C6ADCAE371C495F29@BL1PR12MB5825.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GehxOuZmrhNcnaYT8U58rVUz32QkBBWnyLbOYMPS2aUUaz7FMVk8EPOVzyGHJVRxjg+FhxTia6DyWPsWkEzcAwTOE6ph2hJnCYz+XrI6JofWquQzA9X97jm7zfUvNmKgO0HQjLN5hUzKuIrSbtUmyBlwF30SIWyfeOSSChw+DP6tdJSF5I2G1CBi4hd5RPjFsh9LUQcqWcSulVhVtaxFBSq82DZ6DTVMqsF6jqblGFmExn7NOv8ZoWWuzt6+IrFifMdKOlh2Oli0xqSKRny9dgTwCkrmWwBI+CMJE3MxGcBmYiev2O9GfHqJFkGbVMy371vkMgNt3N6VaeNqTpoCTwq0P2g5cf/h7yooHrinL6fGq8XU2Pc5NsZBU0KYUJS9EdSASLzCX1SmrGY7jGiEfSzNO/BIQ7vfgjQMKQ27i6q6gUxTwUgbjZd1YNT973PRfZUOTEcaE4gOV/ilKG/1e6o1y/glPBDpazZk2kzO7qh9WEjS9Hl4by2KgGaAqVnxZyU7qqMQRmUCyf4koCGHOexBcBb3sDz38Yiim4gEtYQdY+3nGs03kdSP12MFui6NGdi6qR4yqr7n/Sa3kMl62DEBMPcV3l/yFOt5N4c9MUVevSy2k6zkkH36QnPHm8oEcrA/xxpTHFkAnuLF2fVpxEAz2YqlzxI/Kd1wztwNLu1D7Z5bQIqchIdfxeaqRbKTUySdr/gQLssiWIqp9gzbWPzmX6ydiFfoU4z1QCx5w+whRs3D/G7Qhy3yZ5ydH5sE9z1cy1+OxbdglUi81F9fBmOZZLbEWcOt91DW9+AU4rZrk3hqQJscW83ZoKYSYWQu
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(7916004)(40470700004)(36840700001)(46966006)(86362001)(16576012)(356005)(4326008)(6666004)(54906003)(966005)(8936002)(47076005)(70586007)(70206006)(9686003)(36860700001)(33716001)(7416002)(8676002)(110136005)(44832011)(103116003)(81166007)(2906002)(82310400005)(16526019)(316002)(508600001)(83380400001)(426003)(186003)(336012)(40460700003)(5660300002)(26005)(71626007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 20:54:05.7848
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: acd5406d-185f-4049-fd91-08da2246be12
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT043.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5825
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
Add the feature bit and also include it in the kvm for detection.=0A=
=0A=
Signed-off-by: Babu Moger <babu.moger@amd.com>=0A=
Acked-by: Borislav Petkov <bp@suse.de>=0A=
---=0A=
v2:=0A=
Fixed the text(commented by Boris).=0A=
Added Acked-by from Boris.=0A=
=0A=
v1:=0A=
https://lore.kernel.org/kvm/164937947020.1047063.14919887750944564032.stgit=
@bmoger-ubuntu/=0A=
=0A=
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

