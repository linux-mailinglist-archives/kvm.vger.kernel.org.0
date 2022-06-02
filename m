Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87DC853BAB7
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 16:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235912AbiFBO16 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 10:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235899AbiFBO1z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 10:27:55 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2054.outbound.protection.outlook.com [40.107.100.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8003C133925;
        Thu,  2 Jun 2022 07:27:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OmRRWxx9zaS67HvCtgJQuCp7RIledLbUs4u1BQUwqiILQa0YhnD5wC8d/I6fqCpngtzXMQGkT8PuxW05ppxxg7yu4zgrm2HQhEckKEKLO2MMMJjgvruxm1ZaKKMBaWOzVPGZh7Np+ZoZ05XOO3ApHeQ9bpA+C6CsscJ40tXG4GQURYinI4jo+123mBq7ZvxZ8flyqnC+LxA3Lk3xHXdg2urget/JHprUZSxWihPulQi4puURjYA94tVdjKfyJNQs64JF5oayw+IePXb/akUCLpIUYiWCzFHy8sK8I6dd47V4LkIDzj3j0yyevcdZKsorWIvmynAq0xtqiGPmzI6Vew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mlD+4SbguM0bIQlqJuEe0HNi3zDkdGvdNbQfXS3Wgws=;
 b=Jd1rvXYqw5DpzuOcHtlpLYr/T3YCpWc98VNcCiaw3Ytf4SXjQhEc3TYA763vnunq49fE36LHzp0nsEAw3x3vUls+bmpHvvTASOg8H/ec+Cz9NXS7P58ER7AikAK3DyjXOrrkCU5HcQvHD8Mpc78YWol5tmJRaq3KaIUTzFbdgpx0XetnQU4qJHu+TWEvBnbb8fKV+/613jI7/DmT6QNNOVL9gisJutLSw8iC1UsF5tSEzAGpW4EkDWTasMqZgM84RSGxoawOoBWJNHmjsoPYuq0MDhJMEfrd6O5wLE+e3t9ybGx5xADra3ZpV/2e5zndE783SDFwDGLMi1WZGlhIYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mlD+4SbguM0bIQlqJuEe0HNi3zDkdGvdNbQfXS3Wgws=;
 b=xZZy3siqUawgWg6A+M6LkDATURljxb6PbCmwJunLhu0pAS3wNkBSiou3QKOcO+pnRqf7z7V/oN9zmVDYbsSMqQ2Em9gx9gTzza2YsaJwgMdtiHt3rt5LptLgKlhYLBrl72xKarFcHUQYJCg3fx4OeuZ/i3Hy9OYsOkXtHpoDa3o=
Received: from BN9PR03CA0268.namprd03.prod.outlook.com (2603:10b6:408:ff::33)
 by BY5PR12MB4307.namprd12.prod.outlook.com (2603:10b6:a03:20c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Thu, 2 Jun
 2022 14:27:45 +0000
Received: from BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ff:cafe::3c) by BN9PR03CA0268.outlook.office365.com
 (2603:10b6:408:ff::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13 via Frontend
 Transport; Thu, 2 Jun 2022 14:27:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT010.mail.protection.outlook.com (10.13.177.53) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5314.12 via Frontend Transport; Thu, 2 Jun 2022 14:27:45 +0000
Received: from BLR-5CG113396M.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 2 Jun
 2022 09:27:40 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Santosh.Shukla@amd.com>
Subject: [PATCH 4/7] KVM: SVM: Report NMI not allowed when Guest busy handling VNMI
Date:   Thu, 2 Jun 2022 19:56:17 +0530
Message-ID: <20220602142620.3196-5-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220602142620.3196-1-santosh.shukla@amd.com>
References: <20220602142620.3196-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da666443-c178-4b50-0226-08da44a40f8e
X-MS-TrafficTypeDiagnostic: BY5PR12MB4307:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB430791AE93D2465101C99F4487DE9@BY5PR12MB4307.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vnx2e6VXePlCDnKvVIDaR7zLZy0fq3nTpQNwZzzO04aPw39ovMFrD7tgie4l9ocpbri2JYFwqkVt/0YUdpaWZWVvRnz3U15X74+6yil+RCddc9H/V/m2csA+t7djEhpEIPr/IHTP6uDct7s7ZRCNDSN15kb0G3Dudf/nNnsd1VMMBXqjHjZB/sqvpbJBgBPHa2MvnOuWpMS5dfZa1TP2wNM/Cr4GSlB+Fr5VN3DSyAIwdhicuIQPjYvKsKe8lw+/Xvl34/W0XDcNQRyI0ABjRBLcghgXU5kzfHYyZ/r6NvL8f7GJGa2b9oqDX6HIn93ljPRHqts9qYWmN4ulIvCSQE4o2mYJge0jW4wa9DUXnDyMPeep6mAfo5CdKTbxSM000U4Owtb6aThRgWnz0iUd5S/mNzxsW06nsaiZRn4jLJuLjIFClJmAvIxrO4yQGCtDdQcLBmwI8nmXicikRlvKg67pvuCu7tzPI5Jl9w4KVDovik0zbtc+G0atf0rdo1pD7kDtBhDgqmdqTvArHnhXcaj81pm+eApb1U1XvYlbP4uBxLjOeemAHQNcp1hBIRKVwhd8p5UqK8k1IMezjaNzcGN3T4aAYWK+WsveWJCqemsE+YPWxG7VonwCvDZX/ROIxV2lksAoRPxdF5ni8RLo9ldXkdYZIamqLfk1zBeqkx1n7hr0hvyOIVGi88Enioyq1k6ONZeZ5dAIrWTMFMdSWg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(70206006)(6916009)(54906003)(36756003)(4326008)(36860700001)(6666004)(40460700003)(8676002)(316002)(86362001)(82310400005)(70586007)(26005)(7696005)(8936002)(186003)(1076003)(81166007)(16526019)(2616005)(508600001)(5660300002)(356005)(4744005)(2906002)(44832011)(336012)(426003)(47076005)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 14:27:45.1855
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: da666443-c178-4b50-0226-08da44a40f8e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4307
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In the VNMI case, Report NMI is not allowed when the processor set the
V_NMI_MASK to 1 which means the Guest is busy handling VNMI.

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
---
 arch/x86/kvm/svm/svm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d67a54517d95..a405e414cae4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3483,6 +3483,9 @@ bool svm_nmi_blocked(struct kvm_vcpu *vcpu)
 	struct vmcb *vmcb = svm->vmcb;
 	bool ret;
 
+	if (is_vnmi_enabled(vmcb) && is_vnmi_mask_set(vmcb))
+		return true;
+
 	if (!gif_set(svm))
 		return true;
 
@@ -3618,6 +3621,9 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (is_vnmi_enabled(svm->vmcb) && is_vnmi_mask_set(svm->vmcb))
+		return;
+
 	if ((vcpu->arch.hflags & (HF_NMI_MASK | HF_IRET_MASK)) == HF_NMI_MASK)
 		return; /* IRET will cause a vm exit */
 
-- 
2.25.1

