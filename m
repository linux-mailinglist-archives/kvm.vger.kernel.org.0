Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A65B5FCC29
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 22:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiJLUkE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 16:40:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbiJLUjz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 16:39:55 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2042.outbound.protection.outlook.com [40.107.101.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 152E83385B;
        Wed, 12 Oct 2022 13:39:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GOQv7rJiX5U51Lt2+6vRQSg1Y65fG+tl0p2wVGgfL+0HFrdbpyFoF/SMVeZdc2Uk1rXQMawtm8wy3z7C2b/jc+PA5KJ0pk9IKhd1MEtTJ9UG/nxCcJs8ACxUWS6MCYw0qY+wN7ysycA4kX6V5roxv3h0b9vY8b9tIoc4sTUvZo39D2ZFCADQr5P/H6CBVWOluzvyWot2Kk6GaS/gMTQyMxRC2yP9XjYSA7rQWlC3uk5QEme8uzfeDpTtx1wZ39GA+UBdxoVsqz3Amaid625KDd2xU7elcoFI7Q30yw1g8IJlBkfDdnBNhVxt8pYBWaVDIyVRfJjBn2m9m91SAbhkaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VyNX6z8e4gthdHPGuuJfzgsp0mXlE0tSFRHic2tYWq0=;
 b=oAAkrFYl9jy0rCiZgirTukFp37haqhD1UqJ2KX3JMCJkOuO29mlK5R1vBXrMcIO/mm7XWyY4o9nLPjqqpoZlJsEgrzABEScYgB4ageh+sCs6mPWIihxQxtEY9ePtsG0/BUaopOeYYnvhM5Cjbpu5M1B+8kULjf7WV91cL4N+XdVw2gtZgGUqjxSd7b2fTt0pS5srxsz40q3HSeDEZMKTtZFrJvuPzmtAf32G6jOSDMRjVHpEjtZBbY6WCWof797sprob0llfCaH/OnUQhxvvOhyfBK55Cullob2DO9/YepriygWJ+Z+4e4+54IwNxlbnT5NSlmn84ACNKDWGGRo1LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VyNX6z8e4gthdHPGuuJfzgsp0mXlE0tSFRHic2tYWq0=;
 b=NsG53Q0F164sZR5n1qb91wL6jFJvc2M6aMzly9WFH8GLZZ/PQMj4CjnUeCFpzQmq/uEav9YIHcATFhXrSBTpXzZ0L22mtkX0pcclzkyFZivwrkWQg86Fk24MTsBGGwJe/Pi+bV9JyFZTq1GEuZsB5+mQBAc/AQJyDsDQ1AFb7is=
Received: from DM6PR14CA0061.namprd14.prod.outlook.com (2603:10b6:5:18f::38)
 by SA1PR12MB7318.namprd12.prod.outlook.com (2603:10b6:806:2b3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Wed, 12 Oct
 2022 20:39:49 +0000
Received: from DM6NAM11FT093.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:18f:cafe::4a) by DM6PR14CA0061.outlook.office365.com
 (2603:10b6:5:18f::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.21 via Frontend
 Transport; Wed, 12 Oct 2022 20:39:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT093.mail.protection.outlook.com (10.13.172.235) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5723.20 via Frontend Transport; Wed, 12 Oct 2022 20:39:48 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 12 Oct
 2022 15:39:47 -0500
From:   John Allen <john.allen@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
        <seanjc@google.com>, <x86@kernel.org>, <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
Subject: [RFC PATCH 3/7] KVM: x86: SVM: Update dump_vmcb with shadow stack save area additions
Date:   Wed, 12 Oct 2022 20:39:06 +0000
Message-ID: <20221012203910.204793-4-john.allen@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221012203910.204793-1-john.allen@amd.com>
References: <20221012203910.204793-1-john.allen@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT093:EE_|SA1PR12MB7318:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c059ffa-4a4c-4f7c-d672-08daac91e811
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 09tpuXlirux46t3RgwFYEFWXvCdWEkjmZ3Bw/pr64wUbl1k7sFTc6dckDKq6bE2if9R4o5cUjbA+6Uhm1CniyzqGjgjIIsvWJU+WrNtA88QVXl1zTJOnGEoHkoCKbjLagHa8zqyTrLGyPI5NBhQUbRPhEt91FywMWPj8v7X1niZCxmBfHsXjL7wWIu99f4F+Q3nBrBpYnZ/s+XV0J0Cpu/c+HNkxqyNFZstLi+HS8uC+ImA3kZd1I2XRr5eXGMbsiH7JAi77A81hukzEMGcKIhgJw/Zlbgc48dUq4Hav3Mb1ueKnxhiC0Y/sho+NtqaSp779FCbRaElI21D/3eH1HoRWCpKZvcbZOl23z5duen2Ttx7lh1b2M93t6a0yw+59HANUrbk/RRG2Eh+zrdTDN3IYEa9plUoMVXof08WK1KXjafMTxm+KKvLoUltzcDjaGBqQNvITKOLwbbqZqezEs1XHT9Z8mNk+xHVUh5VNJhuP1gAA7idEjBZyt8kkIlhjCbTXoOH1NcBecjRdFwIxgmU258/OLe0PAE0yRnVu0HRt4cL9vJr2B98n10K8l2rLQPPyx9XMIg49HJKU5ZlXJonmd1Saw9U7sly5bFUoVjHWh2+oTOfK5BvXrFV1qx/DOiyF8NO42JM6kbgenI1LO4ND6ncwk33J7IUyYmoIMZ3sb33r4LImbRFdjW+u1Maq97N2zSfkshHCGWjTQXXdeWwHkf26hJrliNjH12J2N2as5v5aM5xCvh8WWo/hGqjMaEl86rdVVDmUuZnt8RZ98DM+mCSJChjsDVE+1kHNQAedQ6tfZ1BYuOY4jZTYLYX6
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(376002)(346002)(136003)(451199015)(46966006)(40470700004)(36840700001)(26005)(7696005)(36860700001)(82740400003)(4326008)(316002)(8676002)(70206006)(70586007)(81166007)(86362001)(40460700003)(36756003)(40480700001)(356005)(186003)(16526019)(6666004)(2616005)(478600001)(6916009)(2906002)(54906003)(47076005)(82310400005)(5660300002)(336012)(41300700001)(1076003)(8936002)(426003)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2022 20:39:48.9440
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c059ffa-4a4c-4f7c-d672-08daac91e811
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT093.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7318
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
index 1f31a991c745..411c815d2d91 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3372,6 +3372,10 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
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
2.34.3

