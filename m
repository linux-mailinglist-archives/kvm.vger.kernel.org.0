Return-Path: <kvm+bounces-5344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ADB97820727
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:22:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63EF7281DF2
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 16:22:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C195C148;
	Sat, 30 Dec 2023 16:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="N/ZA3KNl"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2061.outbound.protection.outlook.com [40.107.243.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75358DDBB;
	Sat, 30 Dec 2023 16:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MgEgkSlH2qQC46S7qx1BvbshBifjSObcqdPSnrgVKhxNgp6d9PrJc8XH8xNxy3gLTCZaXSUmlfJGVpf9/OJvsUE12VpbTh4cyvR79KYnHYRc5xDbGo9lMsKHO7G9HN+yOeAWBMi8w5NyzRoTUhdbq+GTL1sOT0dg1w8zJCDFXU3maYycRO8JheKO7TtX2cnL/70qnC/1HO2C7R1OR4vSlZM1wEmfMp5cAy+tp6wYIUgdIptNmEEhfW7RevrYQOEMznFYsc0Qijsgi/Gw7ufS909rj7f10dDcWqwjDb8lLuMeSZBbz/6tznfa77pCOc5cGqRpiEnQc1ZO0myUZHPuXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6opTrVbMTwh0pCjoKcZ2ovTnQR+ThGWQn4V5Y5Vn2+g=;
 b=Xj2F2kXhj6tWM6mySt5fHs6hDzMLOU+SHHxcpWEEzR4+cs29qmBZ6Xn5X3ONTwCazu6tSFIZwFuEAL4Vyv4wCnHgfmelnLv8OvfXBYEsOr92naFU7t26vcm/FF9LMPVPj09bcQMySOh8u3WBC0uDIKmodILT1PkmMcDWnc3ISnLhY2asXt52muuW2RR8knF96Y53DPQIBNS0zbCKJeWLYm9DX9TF8wG/kb3QBpktwjz+oRtWqgvoBQggsMrtbgzW/qtojH/jB/PuaDPqRkWfbHK5l7zd37aotu7/RpbxQBpiHoOpOKXKGOYm8Q/nSgUg6+GsNc3nL6VWvRRY+GAL3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6opTrVbMTwh0pCjoKcZ2ovTnQR+ThGWQn4V5Y5Vn2+g=;
 b=N/ZA3KNlEAb10zB2tIFTyshYzwcm5e79oJCNzk/YypiRZ1vxvdetjTroP4jdNk3kJ0M+6xEGrGYowlKiaqYN38XkiG8+8C42pMcTKcSkeqCoOGKkQkLShmgUk2axLZBX7St2kWseyqnfQzUu21/xioeJjeilMZYaq1dwr0OqREs=
Received: from CH0PR03CA0095.namprd03.prod.outlook.com (2603:10b6:610:cd::10)
 by PH7PR12MB6587.namprd12.prod.outlook.com (2603:10b6:510:211::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22; Sat, 30 Dec
 2023 16:21:47 +0000
Received: from DS3PEPF000099E0.namprd04.prod.outlook.com
 (2603:10b6:610:cd:cafe::28) by CH0PR03CA0095.outlook.office365.com
 (2603:10b6:610:cd::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.27 via Frontend
 Transport; Sat, 30 Dec 2023 16:21:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099E0.mail.protection.outlook.com (10.167.17.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 16:21:46 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 10:21:45 -0600
From: Michael Roth <michael.roth@amd.com>
To: <x86@kernel.org>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<jmattson@google.com>, <luto@kernel.org>, <dave.hansen@linux.intel.com>,
	<slp@redhat.com>, <pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH v1 09/26] x86/fault: Dump RMP table information when RMP page faults occur
Date: Sat, 30 Dec 2023 10:19:37 -0600
Message-ID: <20231230161954.569267-10-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231230161954.569267-1-michael.roth@amd.com>
References: <20231230161954.569267-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099E0:EE_|PH7PR12MB6587:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c7bcbe1-080a-48a2-b4dc-08dc09536b2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	xsVM5EJUnRzX0LhSBZKkIUCb39qY1rH2PwTJPXV9pw4fK07Bxj9q62WGFk5EYouBLq86P9ESdKb6k8Zc68ci/UOHqNek0WK+jYnafJNVnSaorzKjtGuhtOfy8y/Wncpa9c1cE0YDC7tReij/6wrBpuIwN1+FTv1ajSUmPxI5gtdYMrzdxEwu4FQtplJf04y05SQt0LbsTr3vw++Uksoouns1XwT9Tdfh4N9AL7sABGkRvbYj097dm+DNzuT8vSH71kKQ3LWuO6ytXPXgOMPB1k1heTLlVnSPNa0eKlZ9arMgxBB2im4igNcbrgE6zIpBjGfQOdIMV4TYBHNPoTSEEJTE5ZDFQNyip5QyWCeOTLOzY22F9g+9j5hXXUW5Wu6W5HA18l41WBtATOXRTM27fEA/gefHsAVUBEFD0CXRBQXlpC4O0zvkrt0Ta7k9xgiA1j3awIB22x9yT7l8d2dee4+vNMCO7bRf59SAYJeViF/IM17hPIwpoxnaxDpkxrC/uENpLwYmrtq41YzU4BdPLpGi+qBhOVuVT6QeIRm5c1nrvk8wQGpx7QWj3twK0qltDEALVZjiKkNGfnTSrtvd2gDq4MqUrbRTc7uETOYKvsTXS8jcYppvmrOGTPFIPcG4DzIBdQXSGhGIAlLPNlm/pTInLqd6p/LJZ1ruLPmUHEUDz3i3sj1x8+kV2+4c5Ep3nCwgmjFPqP+oI5CKxzsnQ3GSwOvTanET83ShulDfQ48RWgblvcidyXsaElbOm15s/4V5NKh48wM6SzJnZ3BfsQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(396003)(346002)(376002)(136003)(230922051799003)(82310400011)(186009)(64100799003)(451199024)(1800799012)(40470700004)(46966006)(36840700001)(40480700001)(40460700003)(41300700001)(2906002)(7416002)(7406005)(5660300002)(44832011)(8676002)(4326008)(316002)(6916009)(54906003)(70206006)(70586007)(8936002)(36756003)(86362001)(82740400003)(81166007)(356005)(478600001)(6666004)(47076005)(36860700001)(1076003)(26005)(2616005)(426003)(16526019)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 16:21:46.4079
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c7bcbe1-080a-48a2-b4dc-08dc09536b2d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099E0.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6587

RMP faults on kernel addresses are fatal and should never happen in
practice. They indicate a bug in the host kernel somewhere. Userspace
RMP faults shouldn't occur either, since even for VMs the memory used
for private pages is handled by guest_memfd and by design is not
mappable by userspace.

Dump RMP table information about the PFN corresponding to the faulting
HVA to help diagnose any issues of this sort when show_fault_oops() is
triggered by an RMP fault.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/mm/fault.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 7858b9515d4a..8f33ec12984e 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -34,6 +34,7 @@
 #include <asm/kvm_para.h>		/* kvm_handle_async_pf		*/
 #include <asm/vdso.h>			/* fixup_vdso_exception()	*/
 #include <asm/irq_stack.h>
+#include <asm/sev.h>			/* snp_dump_hva_rmpentry()	*/
 
 #define CREATE_TRACE_POINTS
 #include <asm/trace/exceptions.h>
@@ -580,6 +581,9 @@ show_fault_oops(struct pt_regs *regs, unsigned long error_code, unsigned long ad
 	}
 
 	dump_pagetable(address);
+
+	if (error_code & X86_PF_RMP)
+		snp_dump_hva_rmpentry(address);
 }
 
 static noinline void
-- 
2.25.1


