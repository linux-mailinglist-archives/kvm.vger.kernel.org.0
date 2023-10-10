Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDD677C408B
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 22:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbjJJUDL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 16:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234412AbjJJUDJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 16:03:09 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2073.outbound.protection.outlook.com [40.107.93.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386CDAF;
        Tue, 10 Oct 2023 13:03:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=auKuW2x0kjWWVj44538CM/C/5hvU9GUt8TCUwDCz/UYmHCITPn9WPmBE9t/bsI1BEsVrdYTKx+KDao1gFg14xY1PLyeKFdqHvZW/dyZko0AEfuyhPktmzRu4TJ9b8nglAEQTKt1Kt6vxD/n+ZudXE6NXjrBT4sWmXJgBM97MdHFE+Bd6bsczxLKifxDWJDRDmpvGmVisuxH9BxA01aKJRpEOp+yBSjtMhx8CKVm+DTX2QYs+8DOON1OIfI/+XO/B/MRj9QpnzOI7+fUVTD5Au9R2V+G0F3zgBvoj92DHAXjKAvfOPtTzG6TKjKTbj8vPUxYe/V0Hc/qqAIUjOH+hbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LCDAeu+oFRntxZX3V+OPEPdSGNwKWbI5/06oJfaJqhs=;
 b=aKWNJebbDK9iAIR7iKe26aLXv1l260TNc42Ig8jy1ppoBQ9pNBB95qQxju3bq3MCBQM/UjpDeDRNPvEtCLqC/32UAoQ3P8gy2mM2pl2IHw7w5hp3Bth3csWi4WWa0/HxbeVas27EutOCrGsy9KN1vO7aXYU7+BKYXImDc9iy7+8PWZQivZGyg+31+xcBh1Hsty2YY+OkLt3EvSaqfRYC5RwDUIz8X/2qVUo+HqfH45GL8mwOa8R+HvmcmjVhDo5wjbRdxH45sSkFGZAzxBI2gaHwLt4egNMTV92vCu+QSW0FqurEHdfLW2DovuilR2OzTas4FvLhgLUG8VMO3OH4Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LCDAeu+oFRntxZX3V+OPEPdSGNwKWbI5/06oJfaJqhs=;
 b=bIMHhtFEBN3/fHTgksvEzs+OanIRntpaNeRg+pbdJ4MDJGllo/I1Hodat8WrIKJIQBVl9+ckhOOPRqvCcR3ULQbvV6yjvVkiRmzjITOhlS04xBcaeOUoJpQLPNtdqoKL++0uMeKhp3Hch5twuKu1w8MVuKN3wXWNNB5kbRsioso=
Received: from CH2PR19CA0005.namprd19.prod.outlook.com (2603:10b6:610:4d::15)
 by SA1PR12MB8888.namprd12.prod.outlook.com (2603:10b6:806:38a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.36; Tue, 10 Oct
 2023 20:03:02 +0000
Received: from DS2PEPF00003439.namprd02.prod.outlook.com
 (2603:10b6:610:4d:cafe::16) by CH2PR19CA0005.outlook.office365.com
 (2603:10b6:610:4d::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38 via Frontend
 Transport; Tue, 10 Oct 2023 20:03:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF00003439.mail.protection.outlook.com (10.167.18.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.14 via Frontend Transport; Tue, 10 Oct 2023 20:03:01 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Tue, 10 Oct
 2023 15:03:00 -0500
From:   John Allen <john.allen@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
        <seanjc@google.com>, <x86@kernel.org>, <thomas.lendacky@amd.com>,
        <bp@alien8.de>, John Allen <john.allen@amd.com>
Subject: [PATCH 2/9] KVM: x86: SVM: Update dump_vmcb with shadow stack save area additions
Date:   Tue, 10 Oct 2023 20:02:13 +0000
Message-ID: <20231010200220.897953-3-john.allen@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231010200220.897953-1-john.allen@amd.com>
References: <20231010200220.897953-1-john.allen@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003439:EE_|SA1PR12MB8888:EE_
X-MS-Office365-Filtering-Correlation-Id: d1159e21-e12e-42e8-bba3-08dbc9cbe860
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /Rr5kbKDaMhrf1CmIR3M05b3YFBHg6kU7oOgyxSKCa4jdnw40vqzo0f/Wvt7S+Oy5BwUCVY1RBogPfCVIoCQRd3/uyGyqTO9IiqpoUlOAa014h8mD4xkhZV+9csbwl+/DSEIrsJpi6uqM6vFbhgsKDyMs34zMWtL52AXArbdKWSXEFNl3mVPhH8VUOlFMdkp7gV1Tv6mjtQN0cFnX4Y1w0Y+sLJI+iERMn9AWH5uzzBAN527q8CGbZco03qkV2w3zjpeARKHPXwlkxmtMyccZln6Qbr+LmYfmPcBh1K/mFIK/XlQlgBSjkgcLnfWhI4vsfy4ELRVIFKNzUDV7VnNqPQNsXV0qcuKb9doPgjNKkDeK0AwqgrkgJ9Pyy0ltoWekfdK4nW2jTVN1vG5Sv5E6BuPnBtDCfhQfuLWf70pNgSVRiaaZipddlv2i4CKIBPvRJjZvj2Cpe+UNkq1x6zKdfkYaXvnTT422Wd1AcW8SzxBJaJNRTRrc68+YJ0Leuuk7UXo4AWhYfrLlGBVX6K7RzTl3U03z7mLokoHn0u8V9S5UVRbhFK5zTJ15dukWHqeGfWZPwCVaBq1sFW0zLO2JDiijFp6LNPMYknT+VFvDzTDMpOPa8nrMvHan7dhw9krB0cDX9PG9YTnzRZkRpwbXhQKW0IO0lA8KVGakhPpBkAfYPM/18tD+ya0KNDDF0WgoB6S8DqA0smAinXJVvK5bo/jF6NIIUsyJHGvG6ApN2OM4VM9rq36XkXGI0NMaPJXbhvmZoMllSJzzDQEEwKETw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(136003)(39860400002)(396003)(346002)(230922051799003)(64100799003)(186009)(451199024)(1800799009)(82310400011)(40470700004)(36840700001)(46966006)(16526019)(426003)(26005)(1076003)(81166007)(336012)(2616005)(40460700003)(86362001)(36860700001)(40480700001)(36756003)(82740400003)(356005)(6666004)(8936002)(4326008)(478600001)(44832011)(2906002)(7696005)(47076005)(8676002)(5660300002)(6916009)(316002)(41300700001)(70206006)(70586007)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2023 20:03:01.6317
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d1159e21-e12e-42e8-bba3-08dbc9cbe860
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS2PEPF00003439.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8888
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add shadow stack VMCB save area fields to dump_vmcb. Only include S_CET,
SSP, and ISST_ADDR. Since there currently isn't support to decrypt and
dump the SEV-ES save area, exclude PL0_SSP, PL1_SSP, PL2_SSP, PL3_SSP, and
U_CET which are only inlcuded in the SEV-ES save area.

Signed-off-by: John Allen <john.allen@amd.com>
---
 arch/x86/kvm/svm/svm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6a0d225311bc..e435e4fbadda 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3416,6 +3416,10 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	       "rip:", save->rip, "rflags:", save->rflags);
 	pr_err("%-15s %016llx %-13s %016llx\n",
 	       "rsp:", save->rsp, "rax:", save->rax);
+	pr_err("%-15s %016llx %-13s %016llx\n",
+	       "s_cet:", save->s_cet, "ssp:", save->ssp);
+	pr_err("%-15s %016llx\n",
+	       "isst_addr:", save->isst_addr);
 	pr_err("%-15s %016llx %-13s %016llx\n",
 	       "star:", save01->star, "lstar:", save01->lstar);
 	pr_err("%-15s %016llx %-13s %016llx\n",
-- 
2.40.1

