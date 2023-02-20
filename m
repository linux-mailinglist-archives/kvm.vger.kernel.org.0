Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D558869D3BB
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 20:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233052AbjBTTDl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 14:03:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233034AbjBTTDf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 14:03:35 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on20618.outbound.protection.outlook.com [IPv6:2a01:111:f400:7ea9::618])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E6E22027;
        Mon, 20 Feb 2023 11:03:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Us5oc+c0EjiEBa80509rTHcthGEwyqHLk6lKfA2CmCm+GF3bdAP9GqimCNw5w1N1k4zMVzU1cFFebw4+rNahCo8HdNdN/IgcyOXurp3QuK28DcHQDx4i+YHLEyPAFCeudbE1R5ziSIHpzyj0YUYHpzVN3b/zzS8WySYn7h1cZAISEsyoQtfZTWnLWWe9zMKeMRLKnqIIQ0zNybc2gyJZjIqgEqvAediOPXuFAYHL4qadkeWEYAHakr3ZP726NNb70R2T4O1tedOaoCL9uPoLnRXECYptcDKLBroSM+Gx+46DG4tsAaLVJnv1RmzGfNTSqms0LW/JQrllebH3BZFw+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LopXYiYyykv0LOA+8gvAgfurQClPV2ZL2OUbKE6L/Ic=;
 b=CFPbLXvZBN/tZM5QZI2AoleBlb70IloHefT7SMzI34JMaNhitFmsDAPcosRc13mSAXidsOjdccTb/R9wd2HfyLNmpnCG++ORDbgd6x6g84VYGfxLGA1432/ZagWhwbWzSEDPIFpC47UHsKm5S2t2FvJ+0guDPKZxWCTIjZPVEywuEkPQWNIredhw+oyTW6yU9Q7ax89N7ARneeDA18Hi/2xuGOJ11W2SyVWAVHBYaBnY2Vs7wAPcnOlcaJKEgd8vdIDnAUWNJDmb6li1xXo+XYlTuMnjvFhA0I+zLwWAg/gyGNmsJw6gMqEqlNEXq7uk09qWBd5cB+TMM09OWzESXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LopXYiYyykv0LOA+8gvAgfurQClPV2ZL2OUbKE6L/Ic=;
 b=sH3qZDr5v+nqc6H9IC9VmZRpvGVel9X7mvS7ym8dKX683tsrVnY33yMVNyrw/Ze1CYEPsQIjrHjv2jMeuCzOAAX4deq3kDlcqNOKs5XMrniEaaFGJkyNjtpbjOkAaMbJDhlpmuZOpisaGUMYkya4yvQWJFghPegUYxVK+dd/caU=
Received: from MW2PR16CA0049.namprd16.prod.outlook.com (2603:10b6:907:1::26)
 by SA1PR12MB8642.namprd12.prod.outlook.com (2603:10b6:806:383::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 19:00:20 +0000
Received: from CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:1:cafe::b) by MW2PR16CA0049.outlook.office365.com
 (2603:10b6:907:1::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 19:00:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT036.mail.protection.outlook.com (10.13.174.124) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.21 via Frontend Transport; Mon, 20 Feb 2023 19:00:20 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 13:00:19 -0600
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
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>
Subject: [PATCH RFC v8 53/56] KVM: SVM: Make VMSAVE target area memory allocation SNP safe
Date:   Mon, 20 Feb 2023 12:38:44 -0600
Message-ID: <20230220183847.59159-54-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230220183847.59159-1-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT036:EE_|SA1PR12MB8642:EE_
X-MS-Office365-Filtering-Correlation-Id: b711566e-bba1-4401-6bce-08db1374b6b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wBDpVUHt03FwxxTaPXUM5WKI/7ajoFeBvmHUw9lALTFPQmWsVobxRpfWFo4S7EgzDgI3GZgh3SQQ7FviTTEMzeIzlCNjAhuunbV4efECxzlvdj1OBp1PebjOC1lopUUjDc4hNUO7u0gqMFAUcFyCp43wz/Ag2M9T0bRSclGLODiXn2m+QWcj0M4EHoGj/qeCXA2tOA567v07/WME+lkXKLT8/1ZxSJHf+sn0ZT36cGQeiDbp8Ed8FHwkpziQZsafGRIp0FO6Uy2T5aFLYnCTJnj5RuI3NT/YO7JCXxA8XpFJjJRuLOV9fYCd5jk0ZVG9ea3Q8Y0LcOVTXNQ6Mv18U9M4hoT0WInFdBQ9rq1U6mVAG6w7EkTfegh1syBDJX9zzJIuC/UY4rkEoHUM2A0EqGm+xANSipgo4ldprikIHOYpDyUWxtnlogjyYMOrjhjcPqK2mrBB+78KTY3luBKh1koJZyOwz3dimqXxtvQoRNuWlSPAfMskVu31KTIrqeq+iXq+xdGlvg270aUHWUt/+udj8wJ2hTX2PuH3wC6p1XkGQRSVHzeCJ6vMCiG3Jg7qsqyQ7bO483ir2QxShrILUCVNlpmRL/h/QWdIlm2TajAyHCN2Oa5Xbg6zWljvroaE2nUbgRAXe3WFGeCVZGXYqpPy0gUpDa+87l8G9j6MqzhZLYOdtAEKFEO9raC+GgfbbD2KsPJzBrbH0d1mqf/DTcF1W7stFSWvhr8SXNlij10=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(376002)(346002)(136003)(451199018)(40470700004)(36840700001)(46966006)(40460700003)(54906003)(70206006)(70586007)(316002)(83380400001)(8936002)(8676002)(41300700001)(6666004)(6916009)(4326008)(2616005)(1076003)(186003)(426003)(16526019)(26005)(47076005)(356005)(478600001)(336012)(40480700001)(36756003)(82310400005)(86362001)(2906002)(82740400003)(7416002)(7406005)(5660300002)(36860700001)(44832011)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 19:00:20.3644
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b711566e-bba1-4401-6bce-08db1374b6b0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8642
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Implement a workaround for an SNP erratum where the CPU will incorrectly
signal an RMP violation #PF if a hugepage (2mb or 1gb) collides with the
RMP entry of the VMSAVE target page.

When SEV-SNP is globally enabled, the CPU marks the VMSAVE target page
as "InUse" while the VMSAVE instruction is executing. If another
CPU writes to a different page in the same 2MB region while the VMSAVE
is executing, the CPU will throw an RMP violation #PF.

Use the snp safe generic allocator for allocating the VMSA target
page which will ensure that the page returned is not a hugepage, as it
is already being used for the allocating the VMCB, VMSA and AVIC backing
page.

Co-developed-by: Marc Orr <marcorr@google.com>
Signed-off-by: Marc Orr <marcorr@google.com>
Reported-by: Alper Gun <alpergun@google.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3fe5f13b5f3a..8bda31a61757 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -665,7 +665,7 @@ static int svm_cpu_init(int cpu)
 	int ret = -ENOMEM;
 
 	memset(sd, 0, sizeof(struct svm_cpu_data));
-	sd->save_area = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	sd->save_area = snp_safe_alloc_page(NULL);
 	if (!sd->save_area)
 		return ret;
 
-- 
2.25.1

