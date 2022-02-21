Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6994BD3B1
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 03:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343552AbiBUCXL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Feb 2022 21:23:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343540AbiBUCXK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Feb 2022 21:23:10 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2065.outbound.protection.outlook.com [40.107.244.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3264A3B2A3;
        Sun, 20 Feb 2022 18:22:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BCJu/it5Iqq6yK0STUpPgDbG/nf9R64R/z+I+u6dMw/ktA65Hs9yz8lZuJbwnT4pg7cDaumBXBDoo7VyPqM57dOGVq2ssJg8nvfBEnW8J3fiNxm0qzgKKCOu0vVSGF9gCdyOaEQqyhm4YJVeGSSVqgNo2pFM22hv7EKmCollDumj/+BARZJrHizIotvvitrhA+xP2kqLjkeyMv5RMONgNHD1gDry7CqStmBg3JVHS70nxNs01cn2Lu3ik+/wjwkNzBca8r0DrnAR5v3xV2rrEJZQ5oIgOyHNSc2qNvYnziwA6GMyTZX1+bSnP4HrWDMHw1WZ6aKyVVihQ/QXrnS4zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bq6zmpAy6RU8n0nWYv2LMX7I87iOD25wY5cDesK2DaY=;
 b=iBGFNZBZBhrSwP2cZ/jrxKrPFDeIZ/vCaEKHdPq9hcrY4OP6jWm+BS2LWFTFF98/m047pgwXVeMxjCDefMC/e7C5Zzn4jHiLlF6TsZANokLezqy+lwCFajT3mJZxfEevf6PdNPJUj6kPi86MgUav+/XOLNYUzA1+H5ZAzS14G1CVmqrCNOjd/dPoULWo9+60o3ZTM9i/HRZpviCoRmc37HvFn7RtJyivPbiUFTQspEzsOzdQtryR40WL/IAqmFWID6ypinntvZnZCaV03sDzbvfvIQ8G461+OXCUY/weqVgO5F90JH/hmpLdSbOhRyJn1+43sipyf04ZfstjxfTqBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bq6zmpAy6RU8n0nWYv2LMX7I87iOD25wY5cDesK2DaY=;
 b=vn/3r6bgOZu7JtqpguVabOodPMnItTjthWbbK+BrUj3ZqCQGNi2mAAwJ04SwCEdi5skmHeAW1uRvSy4J8B2FYP3IA3dek+FHvbLWKcLMmvLq69xyrg5vTJXu8bjHw+irzR4oQBa72IDRjolF1zSH+vBwXhwKPscr9DvEspUvKSQ=
Received: from MWHPR1401CA0010.namprd14.prod.outlook.com
 (2603:10b6:301:4b::20) by DM5PR1201MB0092.namprd12.prod.outlook.com
 (2603:10b6:4:54::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Mon, 21 Feb
 2022 02:22:45 +0000
Received: from CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:4b:cafe::b) by MWHPR1401CA0010.outlook.office365.com
 (2603:10b6:301:4b::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14 via Frontend
 Transport; Mon, 21 Feb 2022 02:22:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT027.mail.protection.outlook.com (10.13.174.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4995.15 via Frontend Transport; Mon, 21 Feb 2022 02:22:44 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Sun, 20 Feb
 2022 20:22:42 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <seanjc@google.com>, <joro@8bytes.org>,
        <jon.grimm@amd.com>, <wei.huang2@amd.com>, <terry.bowman@amd.com>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>
Subject: [RFC PATCH 01/13] KVM: SVM: Add warning when encounter invalid APIC ID
Date:   Sun, 20 Feb 2022 20:19:10 -0600
Message-ID: <20220221021922.733373-2-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
References: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c453ca4d-aff2-452b-2fc5-08d9f4e10bb0
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0092:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB009245407A3E06593F000A5EF33A9@DM5PR1201MB0092.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GuL3cLc81Z/1FvdEFSpAHATZyigdBNFWEGq9p4FBD30uZRhntyqHLs2wb+n0z1og6goGXEvNJ/P36OtZ6Y7tGfSXB6edI8m0g/KmcvMjEtlTWrrn/Hg5ZtwUUWiusg++Sgd6tejozEcQBQVu2TJSJVEyJH1wATUoOPV2kaJlVVSqTOwpGRhPNpTeLk1o5SyqdyJW5CaW/M3xutTyLkLnoqB+AbbL2YhIrlTXBjG9ta81pI/+bERpwf4BrwgPul9AAgPNL3iLPaiN/e4lyC8O+tqLO7lxNF+95sEYeATVMStltCBTOmbE2p1/GY+OkEALEE0XAk3gUwHJ0QcyrIBHUDBoAm8fB59QYUfXacp7cmR8CrIloCQd3SCJbBOgH2g4fIpcHCne1B6s6YUKA3qc4GjagGcU8ypHqzs7cXn2yG78N8HLAmjfyQhofzeglXSZ7PwxWLeQXoQUJY73TSZN8o4Wg3WIfYIrW0IdnWYguSbBwFCppCiFgSsDqIF5mTH3W4HDbjmUKYHoV7iT2i14+S823iM2PKe/BJzQsR/jFqssJf2Ld7mhq+tkybhnthz3ecxSSK9NtWJfww5HEyXQwzkHTEdRA38aBAPcwfo7iJ3bgGA87eccz11JOjgwEYTWtyE7ZcGiY41ELk5AVX2QTq7QxuCSY0ajZCTXHEB59Ilb8Kmj8nUtfM8Pt0i0z5PDbYy11qKV3qbT/uL99zBJ9g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(4326008)(426003)(336012)(47076005)(40460700003)(83380400001)(4744005)(44832011)(36756003)(5660300002)(2906002)(8936002)(54906003)(110136005)(8676002)(7696005)(16526019)(186003)(26005)(70206006)(70586007)(2616005)(1076003)(81166007)(356005)(316002)(508600001)(6666004)(86362001)(36860700001)(82310400004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 02:22:44.8675
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c453ca4d-aff2-452b-2fc5-08d9f4e10bb0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0092
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Current logic checks if avic_get_physical_id_entry() fails to
get the entry, and return error. This could silently cause
AVIC to fail to operate.  Therefore, add WARN_ON to help
report this error.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm/avic.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index f07956f15d3b..472445aaaf42 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -447,8 +447,10 @@ static int avic_handle_apic_id_update(struct kvm_vcpu *vcpu)
 
 	old = avic_get_physical_id_entry(vcpu, vcpu->vcpu_id);
 	new = avic_get_physical_id_entry(vcpu, id);
-	if (!new || !old)
+	if (!new || !old) {
+		WARN_ON(1);
 		return 1;
+	}
 
 	/* We need to move physical_id_entry to new offset */
 	*new = *old;
-- 
2.25.1

