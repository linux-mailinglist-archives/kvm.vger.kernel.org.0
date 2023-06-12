Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9349572B68F
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 06:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234211AbjFLEgX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234180AbjFLEfi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:35:38 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2042.outbound.protection.outlook.com [40.107.95.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F14E7D;
        Sun, 11 Jun 2023 21:35:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D8i5nQwB/HjU+uPR828/aad7kv67DnXqL/PwyIwBcWrwYuqW011fPKDhrBAbJ0fbBakYlEMUgTB5CUJ9AzH5Ch2Ff61AjORrc1GDNaCLq2cM9p2vh6ALr2XlpTQ6hHuBQZJUNPB1+xl9eQ3WW4vBaXzRaVNfeIffq745W9bsXghgHsXy2lV1W3M+IyeFAw8SXvtn3quJQgJZJdz2RrybQO8L3uaxBdfPOZlo91IDvLdzQXIZeZaq2dcU/CY0wqgbpvGdU7rajYVqAnw1xkHhqzZf7UvqzXPk7IXErY6GydLewhUS6MJXIEiIpvYVtzqaIS5awSpmuxrs1taRV3FNeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d4wfb4qGv5SePlU/T9QnyyuYBpCMuLO/Bu9lKFk7jQ4=;
 b=mxljwh4NsMm32WvOFbJSJHL0ylcX1d3tdhyo4iCjX9mvNPVQUES/qGa95IZph+lPOVm5KB8vNAoKZSz8wdG6iVbtpnLFOSnqcgdvcfYe/Ebis9sIM2UOsICAoAJp8Vz+9GvN/syIcN7EMLOwdhyQSk53Ce6OKgmXB88AIOAzUTvtxmx/oBh65GOmChmksJJTESK4p797fJ2ZcxldRSj4PNSw3dryF+JimeijhxtOdROrU9mN1dAFmgNyEsEtuV/DB+zQhWGCC6oAf4kbNKrwQCvUW9irZPVJct1YFvEIItwhoVErrVp/NH1N6UVpLicqr//ouv9TxLAtoKgGWimKQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d4wfb4qGv5SePlU/T9QnyyuYBpCMuLO/Bu9lKFk7jQ4=;
 b=eovlZJ5kzFJCKFPxwIPETtb0LXJ4MaCToPGe1OCNAJbctz5UcYNvfG3x4JZe+fH8qKTXYh+RCmGgfuE3CHQSzOVNyLm/tvsczLH/XJWAqqN1j22UTRhMcDGLHb5+4Kc7Xq/dvGFbpYq0adbjC3cudDnFzN9FsOPhWAK6M2MCk8M=
Received: from DS7PR03CA0189.namprd03.prod.outlook.com (2603:10b6:5:3b6::14)
 by BY5PR12MB4225.namprd12.prod.outlook.com (2603:10b6:a03:211::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.46; Mon, 12 Jun
 2023 04:35:34 +0000
Received: from DM6NAM11FT093.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b6:cafe::2c) by DS7PR03CA0189.outlook.office365.com
 (2603:10b6:5:3b6::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.33 via Frontend
 Transport; Mon, 12 Jun 2023 04:35:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT093.mail.protection.outlook.com (10.13.172.235) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6477.29 via Frontend Transport; Mon, 12 Jun 2023 04:35:33 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:35:32 -0500
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
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH RFC v9 23/51] KVM: SEV: Select CONFIG_KVM_PROTECTED_VM when CONFIG_KVM_AMD_SEV=y
Date:   Sun, 11 Jun 2023 23:25:31 -0500
Message-ID: <20230612042559.375660-24-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230612042559.375660-1-michael.roth@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT093:EE_|BY5PR12MB4225:EE_
X-MS-Office365-Filtering-Correlation-Id: a2b78bd2-671e-412f-81fb-08db6afe7639
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b8s8DOnfa7UpiLqSFpaMNyRbN2WOU6/wyCDBQpLKX4nofNIqEs3XB20cx68Zj1BO1zofxGhbMrfKc9j4cNq0aIQiHt54BWFwdpIxbbjfBDGUoBrviKT7s2YLkb/qhygc6gzEeB/+5FNqZlqaA0sGXOx5siJ1r/E4ZjiYCPrfyuDLMUi8sF5zFBmQtMjOFOZhAnYMUuZDxgCwqf+W8dnRXQbOoIK8SNJVYbMo4JPd7/EAvVf0uy/bA+dHTNg67YBJIsH5cJTvSqlb3aHLprdOmAH+OIVCx0pyirRYiJBUSv/2BJYmnnZB/RyCASEtJjAGPDCBr6phfLbTU/96js/urRf5xlERlnOoeeZIUBY3IkZPfRdP7GCWh1qnZjS/AH9Rxk6ewM2uTvLybMf33YaYTnQ8hzPX8mSVGGZrgVn6rVLbyEhG2RSi9ID0IM0hvxWAibqcRf7zXjeRoHZsTHCNR7e8fbBhdelLzSxWtMoSBnkN9gomjPfvtqhFYffX9wnw6mmA764kRX4ZlCs4BJdJZHGb6a6Nsqmcfhc9B3VC7fE0FJ0jPCr+ivUMnJJGsS4Do6zM2IqDExMnEP9NTkj9nKjixW+/6M2rIxdytPcmXY7KmLuJVcAh/hxg/Y8dfcAQDXLmoKAuZXQcizKx73IeCgndkq7yp8M7TWi3RS0I3wfSQTd+gCvBrReqOlkKaVG2a9YfZNmOp8G9EqbhmFO1RI6sKf9S0qzCRhnPuAWnlfZLQQxESkHccDbPnrhlByqIVFjETccXriNr6bHmcZcugA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(39850400004)(396003)(346002)(136003)(451199021)(36840700001)(40470700004)(46966006)(40460700003)(478600001)(36860700001)(47076005)(16526019)(186003)(1076003)(26005)(2616005)(426003)(336012)(36756003)(81166007)(82310400005)(86362001)(356005)(82740400003)(40480700001)(6916009)(4326008)(70586007)(70206006)(41300700001)(316002)(44832011)(7406005)(7416002)(4744005)(2906002)(8676002)(8936002)(54906003)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:35:33.9993
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2b78bd2-671e-412f-81fb-08db6afe7639
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT093.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4225
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD SEV relies on the restricted/protected memory support to run guests
in some cases (such as SEV lazy-pinning), so make sure to enable that
support with the CONFIG_KVM_PROTECTED_VM build option.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 718010600956..638679a4e5dc 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -126,6 +126,7 @@ config KVM_AMD_SEV
 	bool "AMD Secure Encrypted Virtualization (SEV) support"
 	depends on KVM_AMD && X86_64
 	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
+	select KVM_PROTECTED_VM
 	help
 	  Provides support for launching Encrypted VMs (SEV) and Encrypted VMs
 	  with Encrypted State (SEV-ES) on AMD processors.
-- 
2.25.1

