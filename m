Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7AD47CA9E0
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233843AbjJPNkT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233944AbjJPNkD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:40:03 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2059.outbound.protection.outlook.com [40.107.100.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B69E9198;
        Mon, 16 Oct 2023 06:39:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=joQuYQfr2jx5xIfYtwUycRSQVgwNPBobfID1cEKPpMcvQWvV7CImhbOYmwe7KaY5L6dwHYKb9cS9kOYml3x1A5XFKVHnTNi/8Dkh0MFH7QpkLkD9egBd6GP57M/B2lH6+0xZWMMhc6m8U5LI3BYX6iuni8p1Yb3WPVNHAPWq7necEi03zGTXyIkRNb/dU3jcFRRafGH22pmjcag/ALyYREqyatghAbrMa5fcwRFfGYOE6vV+Qdd65oYfmN49J2URhW6OhuiJkbY+OmeCB2d7Nf8Ekmq+QUvWCWlPzsACZd9YuHRaMLL9eAx1kKbMPtg/Aok/EvoOVd4Yf8/qEKRPMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=grPGNJHeh+fkzLl1ka1MoAHWzVZEeOTMwibxvprf8Vc=;
 b=CruOpnG3WRDkDgl1G9CdcvaqT2eSglrPfCR/X3ASQUpdMdeTpf+dIE9PgDq7lq9eo1u1XiBPBfik70JuV4Li3nH9mERJUty8wykIJefauixiwgZSW20dgAe6O/25kkYzrUoiMa3DGXoY88x9IJLCuWgGDXhE+T5FBz6ddGFz1oIEQk/SU3xrRPW+dA/g2V89Vd1HxBUIkx3tPT2nbMlra33DucjZL8vgRgKv51FKKnFJkqXToryrklU9y23uMtRLJJweCkSVCqpC2H4jEwMCeQDM9cz234mCX+iD9DCJq9bFa5i5tivxW1/EmaLZyXpjnqBiZgiUfyDKC86W1DBPUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=grPGNJHeh+fkzLl1ka1MoAHWzVZEeOTMwibxvprf8Vc=;
 b=CnGs34fjmnDnSUjZh+2//HBD45jTJgst1I3Ephl2KEcmiLksDNaWWaDsvwTv8QInUXrcEj5qbD+ajNbV4jg3NLnrA6f2ahHvzWZrsFnGQ3iyfW1e0eYE/8aOeEDczX8KgJqqn4FrH0zq377B7v5DoXjD4t/1qoKCqKZhDGyKnAw=
Received: from BL1PR13CA0396.namprd13.prod.outlook.com (2603:10b6:208:2c2::11)
 by MN2PR12MB4341.namprd12.prod.outlook.com (2603:10b6:208:262::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.34; Mon, 16 Oct
 2023 13:39:55 +0000
Received: from BL02EPF0001A0FC.namprd03.prod.outlook.com
 (2603:10b6:208:2c2:cafe::ac) by BL1PR13CA0396.outlook.office365.com
 (2603:10b6:208:2c2::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.17 via Frontend
 Transport; Mon, 16 Oct 2023 13:39:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0001A0FC.mail.protection.outlook.com (10.167.242.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:39:55 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:39:41 -0500
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
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v10 32/50] KVM: SEV: Add support to handle MSR based Page State Change VMGEXIT
Date:   Mon, 16 Oct 2023 08:28:01 -0500
Message-ID: <20231016132819.1002933-33-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FC:EE_|MN2PR12MB4341:EE_
X-MS-Office365-Filtering-Correlation-Id: 4be8e5b6-169e-4697-400c-08dbce4d623d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fvDOup1UHgZc/uOSlGG8nIRJN2BN/BYiEzMjmU85mgKhNQGRGhhMJ32mJ36cLkbHfk+epY9wjo3lSJJenw5/+3B/kFmbU8oOcM8N1+zrAtYJeaE+zQ7wyrxGhAVTakPOUVclckOSeAUMd3+VZPTudJi8M2aaDELejA7U59FEYvwKsfS35aMCTrUtAp8OX0wHUXv2fmpRw5xLygDK0XBpiwKTX/iumTjuUimocdWA2UhEYKZKCH3PA4UZwPTRI77wjT7/jiTgAwb6Ws7WkP5PqOa6AI8UGeITvYfAk6d1CJvy2+pZU112R+jW++fbtd5kAZVo/ShOk0QGNTPe86M+LnnmNW+xLIPwNgnCOavNE5ue55k2Xx7e32EXCS9I3yJhi5t/zdL5bMi67zGveaukD6uGuAb1+c9c30socIQ6FQSGQ5O8cJ1dSdxbcHx514vpmVyXoXhvSxO8BSWMKiQRYSafuuVAWGuxqkPWlSVWtrHxzUCEhlx+pDGYHorvXzYcrr9x6WWaT2lEYE8/fjIsNiklBPlAUaC0Tg3cEa7aBHayhfaO99YFiMV4c4vTSv9pnLlEwStV5YcoVzboo2nLSkgBlcOfVjNlsMhYm1b+rBL9Ch3zAWaakdXZm6vlBXhujyGdHIy9gi84BhLm6J5lJGZKhLDYLlxFxZYZk5H30qtHnMohrGo6Aq2K0SC3r3pV4Pyqe/PfAJw367oNRbierIodYLEvP2+zR7r1u0gjzHIABkwnuTdC2Mz+3cOfIoQN26i1fHcFm6eDfjoK/74o7A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(396003)(136003)(39860400002)(346002)(230922051799003)(1800799009)(64100799003)(82310400011)(186009)(451199024)(46966006)(40470700004)(36840700001)(40460700003)(1076003)(26005)(16526019)(336012)(2616005)(6666004)(426003)(36860700001)(83380400001)(47076005)(7406005)(44832011)(4326008)(7416002)(8676002)(5660300002)(41300700001)(2906002)(478600001)(8936002)(70206006)(6916009)(54906003)(316002)(82740400003)(81166007)(356005)(70586007)(40480700001)(86362001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:39:55.8260
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4be8e5b6-169e-4697-400c-08dbce4d623d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0001A0FC.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4341
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

SEV-SNP VMs can ask the hypervisor to change the page state in the RMP
table to be private or shared using the Page State Change MSR protocol
as defined in the GHCB specification.

When using gmem, private/shared memory is allocated through separate
pools, and KVM relies on userspace issuing a KVM_SET_MEMORY_ATTRIBUTES
KVM ioctl to tell KVM MMU whether or not a particular GFN should be
backed by private memory or not.

Forward these page state change requests to userspace so that it can
issue the expected KVM ioctls. The KVM MMU will handle updating the RMP
entries when it is ready to map a private page into a guest.

Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/svm/sev.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index d9c3ecef2710..4890e910e6e0 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3269,6 +3269,15 @@ static void set_ghcb_msr(struct vcpu_svm *svm, u64 value)
 	svm->vmcb->control.ghcb_gpa = value;
 }
 
+static int snp_complete_psc_msr_protocol(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	set_ghcb_msr(svm, vcpu->run->vmgexit.ghcb_msr);
+
+	return 1; /* resume */
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -3369,6 +3378,13 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 				  GHCB_MSR_INFO_POS);
 		break;
 	}
+	case GHCB_MSR_PSC_REQ:
+		vcpu->run->exit_reason = KVM_EXIT_VMGEXIT;
+		vcpu->run->vmgexit.ghcb_msr = control->ghcb_gpa;
+		vcpu->arch.complete_userspace_io = snp_complete_psc_msr_protocol;
+
+		ret = -1;
+		break;
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
-- 
2.25.1

