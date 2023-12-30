Return-Path: <kvm+bounces-5405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AFB2F82080C
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 18:38:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D06151C227F5
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:38:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 324D1C143;
	Sat, 30 Dec 2023 17:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XLDAyPLO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2088.outbound.protection.outlook.com [40.107.93.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4DFC2E9;
	Sat, 30 Dec 2023 17:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=noxf8xEUz1X/mfbfLT3AknjoscWo5K/gAzS40VrPii2AbziRvmytBS1nf6/a7qNdZqR8yqa0j2OVUX441evNdS2tltUR81kZP02l8m1u107kN9zj8AOwiLB5Tmx+OE8S3wNE5M7XlG1NzR5yyvwnW8Ay/UHo0hdHFyYo07NKzLUKXcnAskuPOTt7wva/eL+SWiW9neDtJpv3kamtTFAKV3H651A4yVc73coEM2lP4k6vzU+SN7byl4dswBOcXPksuC5YLkzZr4tnv2t8E/ETgLsYNBPqYxGfIMy433SvZqyMNZendlCc4ub4vQv9HZyVy+2nkuBzXXC7ta6YmT4lpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BDCPJTqCpUJhpZ4QlcL8nQ30xiHgJU5MrcKeNbER+A8=;
 b=TpGIkONhD1puUv9eMT2z4JGtu1gYDIlyjAVBvod5/MYs6pGnFHWzBY/v92WkCE+OtXj5iaW4OyJI/Nloj2z38uSzKuFRPkOyHIvuagCQWvV9VQgJtRvHLCqMSZtI5N7CCyIm0FsjRyZQMR8zBCw7MMHgaXFegw1bIx7W3rk4Mmhu98eo8S8SWV5lGP9Z+HIq9wvp9rmzl85BYVYnWv+3zEi2sf0DdqqhF+dNWd2/jzD62BZgXLITIXPHP8dBvBIhCvaqJEA4EJprIRr9zWsFZT4A54L14O81Uu/eU7sARxZhDJ4a2X9EDPhaudjPne52Xf8lSVmHX50i+6VbhckwaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BDCPJTqCpUJhpZ4QlcL8nQ30xiHgJU5MrcKeNbER+A8=;
 b=XLDAyPLO8zWt9/g/JWkce5n1TUxrEe0uGBHrTSWD22E2ITGcOggk0sZG4ePsd7fSKa/LvHr+CF1Nmz3H6EcqWI2J1s1FhuRGtQcX1Mh66Pci38clW1ACBFK8SuVAExLPnuOJ9ZTGfxTZCqDw1g/kppyRFHvkY+eKZgK1owPWkBk=
Received: from DS7PR03CA0112.namprd03.prod.outlook.com (2603:10b6:5:3b7::27)
 by LV3PR12MB9412.namprd12.prod.outlook.com (2603:10b6:408:211::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22; Sat, 30 Dec
 2023 17:36:31 +0000
Received: from CY4PEPF0000FCC2.namprd03.prod.outlook.com
 (2603:10b6:5:3b7:cafe::48) by DS7PR03CA0112.outlook.office365.com
 (2603:10b6:5:3b7::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.20 via Frontend
 Transport; Sat, 30 Dec 2023 17:36:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000FCC2.mail.protection.outlook.com (10.167.242.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 17:36:30 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 11:36:29 -0600
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v11 08/35] KVM: x86: Define RMP page fault error bits for #NPF
Date: Sat, 30 Dec 2023 11:23:24 -0600
Message-ID: <20231230172351.574091-9-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC2:EE_|LV3PR12MB9412:EE_
X-MS-Office365-Filtering-Correlation-Id: fc980c27-6a4d-4243-8ec3-08dc095ddc08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	GdRg8ruTviy0V6Pzi1T+MG3pXD1VG678iTBd/fg3j4UnasdFznF7sZIhhyH1qp91Xoj3Tif0gw+Sir81uW6eb9IItx7FcpzIoGlrL2z7xKA5rbj1GXJEEUrIOW+924ypNmbghAbOLiwk4if5vbjlwH549fOdtRMXwNbQVUQFBRO2D7CntxnTQEbFvd7NsMlDZBNoQCRe8I+unulKsqg3+EMfoTvOJBrUF0KDQCOSYd3Ag7C8nXM8ChPcy3DaL0qrbYTtxBav1VmhdAFc3gYt+o618E5+SSJAjt8UBdgY0URslCVnA0Z3o4CL0TxEqySO42mpY1DNYaNzPSIMPUZwfk+QYyuXL6WAddLHCZZI1Gul9n1GYLjqSDg3V4UFZ7hWAUqNQIxiRWNgcO3tI5pPGygveUUEupgFhbsuXHc2QIPanZ8XlPYce71bKamYSZlDk2jmi+DaZKdZb4w1tp3yqe0lyQqZRHrO9WU9DzGHBSTyyTloBYGbd7x1UZ+6IPHQ9uoY91BT8ONaGXgEHKqvnuWhEEJSfgMmdNnZrHjQQxetcwsdum4zpTXmcCf2cZLBoSOcGSBUqTTXYZDqFz1H3YznfZERw14Kw9Vudk8evdYBhUlCdMMU9jlcsByTRyzJVud0SwIAjTXavYVApU6AuBEWRCKIJD+d5WL6Ff5y+zOCd/NttFHlZMqJeUeMI9oHcWcPWsVG0tzCryQA1O5Q/rrGN6+wzFWShkEAhLpNY+ySu5CY/gwA+B1T8c8xIZwBGSgaDNfrH8OEAF/DGirOmQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(346002)(136003)(39860400002)(376002)(230922051799003)(451199024)(1800799012)(64100799003)(82310400011)(186009)(40470700004)(46966006)(36840700001)(40480700001)(426003)(83380400001)(16526019)(1076003)(26005)(2616005)(40460700003)(336012)(478600001)(6666004)(47076005)(41300700001)(316002)(54906003)(70206006)(70586007)(6916009)(36756003)(44832011)(4326008)(8936002)(8676002)(36860700001)(356005)(81166007)(86362001)(82740400003)(2906002)(5660300002)(7416002)(7406005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 17:36:30.6830
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fc980c27-6a4d-4243-8ec3-08dc095ddc08
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9412

From: Brijesh Singh <brijesh.singh@amd.com>

When SEV-SNP is enabled globally, the hardware places restrictions on all
memory accesses based on the RMP entry, whether the hypervisor or a VM,
performs the accesses. When hardware encounters an RMP access violation
during a guest access, it will cause a #VMEXIT(NPF) with a number of
additional bits set to indicate the reasons for the #NPF. Define those
here.

See APM2 section 16.36.10 for more details.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: add some additional details to commit message]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/kvm_host.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e38cab5dccae..843695217b4b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -262,9 +262,13 @@ enum x86_intercept_stage;
 #define PFERR_FETCH_BIT 4
 #define PFERR_PK_BIT 5
 #define PFERR_SGX_BIT 15
+#define PFERR_GUEST_RMP_BIT 31
 #define PFERR_GUEST_FINAL_BIT 32
 #define PFERR_GUEST_PAGE_BIT 33
 #define PFERR_IMPLICIT_ACCESS_BIT 48
+#define PFERR_GUEST_ENC_BIT 34
+#define PFERR_GUEST_SIZEM_BIT 35
+#define PFERR_GUEST_VMPL_BIT 36
 
 #define PFERR_PRESENT_MASK	BIT(PFERR_PRESENT_BIT)
 #define PFERR_WRITE_MASK	BIT(PFERR_WRITE_BIT)
@@ -276,6 +280,10 @@ enum x86_intercept_stage;
 #define PFERR_GUEST_FINAL_MASK	BIT_ULL(PFERR_GUEST_FINAL_BIT)
 #define PFERR_GUEST_PAGE_MASK	BIT_ULL(PFERR_GUEST_PAGE_BIT)
 #define PFERR_IMPLICIT_ACCESS	BIT_ULL(PFERR_IMPLICIT_ACCESS_BIT)
+#define PFERR_GUEST_RMP_MASK	BIT_ULL(PFERR_GUEST_RMP_BIT)
+#define PFERR_GUEST_ENC_MASK	BIT_ULL(PFERR_GUEST_ENC_BIT)
+#define PFERR_GUEST_SIZEM_MASK	BIT_ULL(PFERR_GUEST_SIZEM_BIT)
+#define PFERR_GUEST_VMPL_MASK	BIT_ULL(PFERR_GUEST_VMPL_BIT)
 
 #define PFERR_NESTED_GUEST_PAGE (PFERR_GUEST_PAGE_MASK |	\
 				 PFERR_WRITE_MASK |		\
-- 
2.25.1


