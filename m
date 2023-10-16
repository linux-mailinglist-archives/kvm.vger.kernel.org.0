Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEF8A7CA992
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233803AbjJPNeV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233853AbjJPNeI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:34:08 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2083.outbound.protection.outlook.com [40.107.94.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB362128;
        Mon, 16 Oct 2023 06:34:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WT3EnXEn88VbDl5+qAV9Xuc5J6aFadnjZ2CPBpc+a9s0yq+gls96fo7jIcYXqLZICKNR8l4/SuFennUcJbb/1aMRa1fIeOdD44jS1Onkuu+Qeb0/tzZac9EojJqLpbUFRhnAXu/vplzABNfFHnNs8LqFpcCLSTQQTEaANBn9WUlI6KaEKx5BlbYa7kLREgtyFDhxnuh2PBVgkEDpx26b1v9G6zgsmOuFnGMnF6AQGX6cBZ9+C6eH0pHNSrPVpB12ZOJLIAFW4DkbCk0luCI03ys0IH+0enrzaz7D4rxhSAEXwcPpzux1bd+4fntaf9lmHxchy915FXxefg+/SxBPxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wsAfKNMAPFhTgdRyhK+t5rk/oQLLqXKvgTPOydWXrvk=;
 b=f8wAve2bYczAN73Pf47eqyTFwOeKhdb4WZMT6ClSuBS7FwBjFfqaSyUoAViBJG9vCWu1JNrYnrv6iMB2szhCbuMaywQFbZ4xdhviwLpStv1vbGHHi1CabyFk1u21P/PzO+ugMKB6XxuiGvEstMnWJTgCEDIN1wfIcdzFpozwCeS7rZ61sLUt4CRJhYl6Xup+h3Vz4vCq7VaCZTZy7zsr2Ql+cYzgiZFCLC7z9UvEO0+VbiX9bQc4RwLPA/d5gTOt4lHgmfqovP8B7/506abl0df14C1RRzoRMopdmmMohSWf70g1MsFEhHeI/ToFxoCSHTHIPMt+INpcGxOTT3SfKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wsAfKNMAPFhTgdRyhK+t5rk/oQLLqXKvgTPOydWXrvk=;
 b=suN6sdi9dmnU4yOmo+0lMVpySg9oNSHiBZkemMRL/nBIIFLB3Q+UHiD9NXZoliaezapXyvnzhn7Tw7mKrSwpH+xxwEUywiGbI96pvS4g4tIXexlefQZFfVy6APiSP+FRvA9pXxZYT88H9Vkt7W0Z9yP4FoEfnadh//oLgFA013o=
Received: from CH0PR03CA0023.namprd03.prod.outlook.com (2603:10b6:610:b0::28)
 by LV3PR12MB9331.namprd12.prod.outlook.com (2603:10b6:408:219::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Mon, 16 Oct
 2023 13:34:04 +0000
Received: from MWH0EPF000989E6.namprd02.prod.outlook.com
 (2603:10b6:610:b0:cafe::12) by CH0PR03CA0023.outlook.office365.com
 (2603:10b6:610:b0::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35 via Frontend
 Transport; Mon, 16 Oct 2023 13:34:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000989E6.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:34:03 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:34:00 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>, <jmattson@google.com>,
        <luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <jarkko@kernel.org>, <ashish.kalra@amd.com>,
        <nikunj.dadhania@amd.com>, <pankaj.gupta@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH v10 20/50] KVM: SEV: Select CONFIG_KVM_SW_PROTECTED_VM when CONFIG_KVM_AMD_SEV=y
Date:   Mon, 16 Oct 2023 08:27:49 -0500
Message-ID: <20231016132819.1002933-21-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231016132819.1002933-1-michael.roth@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000989E6:EE_|LV3PR12MB9331:EE_
X-MS-Office365-Filtering-Correlation-Id: f63d2624-af08-4c51-2777-08dbce4c903f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hQIUvsCU4k8v4G5jN9HSHJVQLA/rQk1bBWq2rc5btrIDxdOuWHDDW8gTYbg7Gch+9L7/I+v0607Gu+B98c/P7xTJV5UbuDe4nd1CwowLID47d+4RCAKbhzsLttwWf4WoNryw75TEVA6Ab/fSStEgKNjdufBbyQ5xM/d4NLqJlfgaOyhhpj0Ts2SpdQzgNxJ/b/r6+P/al9qJgE+uHHCgjbFs+DCV9nvDAomCe8QOTHPoNSvmKKOohEbMsBv3ssmxktmeOkuXBB3YnztlqxbTTT4Fnsiz5friA2S5fQwBUZ2B4eEPmmarK3Z+S1VqHMj+2kZ3l13KZ7U7bNKzFZ84iSqOjNG+92ScSbpLfMVH29EHAiR1Ural6k+6GlhniGgZH4bhtbHAMBno7ePQRv9HaJh9JgnBfvhYxCRWvmn2tjAfdCq9y95W9BQM8q8HeYh8XcHdq4MFPEyeTNyqpvB8jmy+xxcqZZYt66CxzJU9OaxacqsoXRsFvXtGexZ+hnHgdYSBqjyD1nGgMO26TBBCaQtWv5ek1d2WSjNBMQmvQEajXNLeSUYWxmWhEkz0EjfO3zT0vOllkU7TAHfezpACSsLeB9+e+Z+IRa10hdXPFCusZczDqR/KRzzFQu3YCEWNUfYT9htrh+hfNcxbSFqdUJMDf57mQcp2YR9DULXy3uYraBeE1zN6/8g4hhPjMAT1k9VBQA1keziIXBPOAze/k7BFKSDYMiQgHV1a3tEgr+wvKdIbgvob9t9N3Hfma0zavQjoHYgNofOL8cnmcM2+0A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(346002)(39860400002)(136003)(376002)(230922051799003)(451199024)(82310400011)(1800799009)(186009)(64100799003)(46966006)(40470700004)(36840700001)(40480700001)(5660300002)(44832011)(40460700003)(6666004)(2906002)(1076003)(26005)(36756003)(336012)(2616005)(16526019)(426003)(4744005)(356005)(81166007)(86362001)(82740400003)(36860700001)(47076005)(7406005)(7416002)(54906003)(316002)(6916009)(70586007)(70206006)(8936002)(4326008)(8676002)(41300700001)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:34:03.4232
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f63d2624-af08-4c51-2777-08dbce4c903f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: MWH0EPF000989E6.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9331
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SEV-SNP relies on the restricted/protected memory support to run guests,
so make sure to enable that support with the
CONFIG_KVM_SW_PROTECTED_VM build option.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 8452ed0228cb..71dc506aa3fb 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -126,6 +126,7 @@ config KVM_AMD_SEV
 	bool "AMD Secure Encrypted Virtualization (SEV) support"
 	depends on KVM_AMD && X86_64
 	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
+	select KVM_SW_PROTECTED_VM
 	help
 	  Provides support for launching Encrypted VMs (SEV) and Encrypted VMs
 	  with Encrypted State (SEV-ES) on AMD processors.
-- 
2.25.1

