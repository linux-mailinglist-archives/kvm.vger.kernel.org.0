Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27A4077FD9E
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 20:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353326AbjHQSTV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 14:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353589AbjHQSTF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 14:19:05 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2089.outbound.protection.outlook.com [40.107.223.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A8E42D59;
        Thu, 17 Aug 2023 11:19:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IXFoOkXEe2z74ug0gDdhhHA12WCdMs/s1x87c9VEqUbC0CyTxR1SbOtyQo0yQ+Tl/zEOpXFrE3hfPFfcNBeWrJZ7IyesG9DsEH1X394bwRWkjsOaZ1DPyIzeh8OAeGIC6i4Oll0oLxrQXmFij/bFRd+4GChbJ5bcQy5P6FkI67+2Lady86ZFW5/XCqIsNWGRBn/QM0Md0fHnkN+ny2NrRPUl5fhraEYKDLx0PbK8Y/Uwm6Y0zJoGcmkwRZcCnd4YyiW751tgEfnFzfq3Wn5ZeeQ8Tn61LBKvlHcKTMbU6cd9j8LI0zwsXFHjxN3SHQczdHDnl1OMD0zQlshdJJxNRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZIXTYWpyap8gmMbngRhmC72R8ofQZSMGoDBTBllbesk=;
 b=YmInD+7XwEcxCqQr9/piiCNY63pprCo+NW5bKo6spocQ0avUnvQKuDH08mzsrsp+HUNSz70l2XPGlIEdhaHofumGdVIfd7yphfMV9CVYLxV/c6hg/NsVwRcmWxbnRp3VPnvgepeKNJpAN/ARXtYfi6/ANoGPATPIQJRLPTxPnawL5gTWuinl4nNfVvCewXU3tELDX3fETn9IcgBF65d8hZmBun8Rxv/XDkj06bMjCKp5LgWvzpHm8R25pxeXXPjyWutD6qgOU6hc1OiDsYdngpApz2JJ/7WW5RCPd8VBgYvUZ/Xs0JhZn6sHYRlBpky/z2UMd7obf7ba9JlVOmldxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZIXTYWpyap8gmMbngRhmC72R8ofQZSMGoDBTBllbesk=;
 b=xL8yQi4b7fJgJqA7L+Bt8fuNSmEWFMmRm9FI/WTeLeAD77KpcOd+uJJoAHKDeIv6p4Ij5sYVjGdPpmP6R/Vxv1laohtkKvaVoWvHyRuTeVqg8/MrY9O23ajtpPQKPFf+BvHWcsl5YBNxKZa03s5Te3jEEzUKS/ojU/TB83yHwbM=
Received: from SA1P222CA0003.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:22c::31)
 by DM6PR12MB4043.namprd12.prod.outlook.com (2603:10b6:5:216::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.31; Thu, 17 Aug
 2023 18:19:02 +0000
Received: from SN1PEPF00026368.namprd02.prod.outlook.com
 (2603:10b6:806:22c:cafe::3b) by SA1P222CA0003.outlook.office365.com
 (2603:10b6:806:22c::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.33 via Frontend
 Transport; Thu, 17 Aug 2023 18:19:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00026368.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6699.14 via Frontend Transport; Thu, 17 Aug 2023 18:18:55 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Thu, 17 Aug
 2023 13:18:35 -0500
From:   John Allen <john.allen@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
        <seanjc@google.com>, <x86@kernel.org>, <thomas.lendacky@amd.com>,
        <bp@alien8.de>, John Allen <john.allen@amd.com>
Subject: [RFC PATCH v3 1/8] KVM: x86: SVM: Emulate reads and writes to shadow stack MSRs
Date:   Thu, 17 Aug 2023 18:18:13 +0000
Message-ID: <20230817181820.15315-2-john.allen@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230817181820.15315-1-john.allen@amd.com>
References: <20230817181820.15315-1-john.allen@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00026368:EE_|DM6PR12MB4043:EE_
X-MS-Office365-Filtering-Correlation-Id: c278ec5d-db6b-49fd-c1e2-08db9f4e6f1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o1q/F0Y7NE8xy+jw77GTqIYyrNuGQuKcwTcS2MzB3yKaUeVLdvqaLJGlgfJg1JUfdVZyuUgQiwCq21FG4GWID6YzcaUyOAJvblwb1HD61DZTCe8F/xmuKQCEUqwFhdwpblWZFMUPGMy0IswQ/p7kJVIIHLFE1CGtYNb4Y4LMovf4/9+VdQqD30R46fnfjRiVJrlE6TvPAjYwDp6kpGNwhgz0C9ix/VkHLHTBr/lkC2OY94Q0zMK5wgBUEqU8gKzycSd81SfVmNGhR0kHUO46sAp1r/ie1g8fc6kBeuahDtdCt4XUrhxo3EiymAsyJLUgNGXY5Duzl+xx2s8oC4+g6jE+PgSx4m8RaUClYqMIkqIrPAVgjCpuCPBfckCrrJba17xHypL0YKvPUNFuvFfBcVnyDind3B2VUmI6smvtgyCffBudqBw7a6qIt4mN7RbAv3NIvCwpiX0DGIwuct6G6gRQrFYdNAJX49otSjgQVoXhj++tXPGBvnZ3kM3MC7WH+bhFQ7TWUOdAMueOD1JGPQrVipaPUAo2UXuNt0r1pJf8G1Og5JSIEk+ZKjldNt1Jw5JM3G1vxhBABx1pfAxBtyeB079cC/fgvS0BVhubkcWt/ZkQ1ytu1zKx09keYpC+5j2Nxkgl6FG172OwJrN5zcDbS5Gj5LcP5RFmjMYzSTtaCDbZHXswxSTQ5wVSQyjZMWQOd4Gqm3LbAbOeHfRzWJNpXb716tF0VBQwgD69vpqoHutb38M8fnzTYSwqlacrJ14SvrWj64kDYy1a0NKF4g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(396003)(346002)(136003)(39860400002)(451199024)(82310400011)(186009)(1800799009)(36840700001)(46966006)(40470700004)(36756003)(86362001)(40460700003)(40480700001)(83380400001)(5660300002)(8936002)(8676002)(4326008)(2906002)(44832011)(41300700001)(1076003)(26005)(6666004)(7696005)(2616005)(16526019)(336012)(36860700001)(426003)(47076005)(478600001)(82740400003)(356005)(81166007)(966005)(6916009)(70206006)(70586007)(316002)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2023 18:18:55.9571
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c278ec5d-db6b-49fd-c1e2-08db9f4e6f1c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF00026368.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4043
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set up interception of shadow stack MSRs. In the event that shadow stack
is unsupported on the host or the MSRs are otherwise inaccessible, the
interception code will return an error. In certain circumstances such as
host initiated MSR reads or writes, the interception code will get or
set the requested MSR value.

Signed-off-by: John Allen <john.allen@amd.com>
---
v3:
  - Updated to depend on the new x86 common msr handling introduced in
    v5 of Weijiang Yang's series:
    https://lore.kernel.org/all/20230803042732.88515-12-weijiang.yang@intel.com/
---
 arch/x86/kvm/svm/svm.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8652e86fbfb2..57864e83f634 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2833,6 +2833,15 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (guest_cpuid_is_intel(vcpu))
 			msr_info->data |= (u64)svm->sysenter_esp_hi << 32;
 		break;
+	case MSR_IA32_S_CET:
+		msr_info->data = svm->vmcb->save.s_cet;
+		break;
+	case MSR_IA32_INT_SSP_TAB:
+		msr_info->data = svm->vmcb->save.isst_addr;
+		break;
+	case MSR_KVM_GUEST_SSP:
+		msr_info->data = svm->vmcb->save.ssp;
+		break;
 	case MSR_TSC_AUX:
 		msr_info->data = svm->tsc_aux;
 		break;
@@ -3050,6 +3059,15 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		svm->vmcb01.ptr->save.sysenter_esp = (u32)data;
 		svm->sysenter_esp_hi = guest_cpuid_is_intel(vcpu) ? (data >> 32) : 0;
 		break;
+	case MSR_IA32_S_CET:
+		svm->vmcb->save.s_cet = data;
+		break;
+	case MSR_IA32_INT_SSP_TAB:
+		svm->vmcb->save.isst_addr = data;
+		break;
+	case MSR_KVM_GUEST_SSP:
+		svm->vmcb->save.ssp = data;
+		break;
 	case MSR_TSC_AUX:
 		/*
 		 * TSC_AUX is usually changed only during boot and never read
-- 
2.39.1

