Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 629AF60F2B2
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 10:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234733AbiJ0ImA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 04:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234545AbiJ0Il7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 04:41:59 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2061.outbound.protection.outlook.com [40.107.94.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 434D6A7AB0;
        Thu, 27 Oct 2022 01:41:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FiPEu/HIyKHz+GIV5f7OqwXRSHlwH7FIJCB3G8ultTQkPiq1J4Wy2IHhL5RdU035EkvnEL2M+rCRUrvHpBsAaorGDZ0r/nniAQv0P2L88cnjZY2XjwTdS2cFGgIDFvW/yl3Q0f7MNKralKqK2d2/nNAwJErwIEwskQkDN5SbaBJr+RkMv+BCnObRZBHLqQxOqFoFnlLEXcFNRwdj9mHQPf7Unc2NWTYPNsD7KTJtvKVAA/Mez50c6A8KAIAdZX0zQzMa2+urysJRK+9oDT6SP9P8lTFciY+9FFHJVcGu+sR2QmW4DuEr/b4pazu5n2Ki7qX8W7ziHsSC+26vgGJ3Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4JIVj0zjYPR2ipBGy7fYbw8rqoj3UdBt8qcEMZGLI3U=;
 b=N6VdQqJ7v7FZPfCv1xbqiSOInnTnu6FFXh6U+GeSqx0kUsb3uKB7cZipP+x40Z6zRXGxLkHeBDC24zLLtmuOaKtX0aew/ibsb+hBGII/+MuxfajpcyT2acdyNd/ocTbP2O0fhKAoKNVxsgfJA7MsNj79df0iwKi1Yn/KcmsClWGYH6fG7rtv/uRibYP0osuVyIp2I17USRt39BKQD7+ECxLqhp5/ViqPS3PCeEDCIy0vpt3aD/j2rbkF5ncZprI39uEzQw4iOTXJ1ecmkE4Odi9LPrc2j9Wb+ppN1KXGT2FIpcR207xkLbHiU03lEI3o7eGoupMuXQt8mez4MTE3sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4JIVj0zjYPR2ipBGy7fYbw8rqoj3UdBt8qcEMZGLI3U=;
 b=4bjOUYwtFPaZQTva3ytrMhhBRXf03ih4x1wMbNybgLZXqxbENXwWZFhIbWbiJ2agnv7Ch9VmRPlb+WXlOfVqSWf+RKc0ur7q2uE0mjsSGHDxSLTQ47iL+RPtTXOMUIgyOR45bsx4XbVjG5sfF9TbUUTN6dIzRPx/oyJEVgqmqbw=
Received: from DM6PR08CA0053.namprd08.prod.outlook.com (2603:10b6:5:1e0::27)
 by CH0PR12MB5249.namprd12.prod.outlook.com (2603:10b6:610:d0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Thu, 27 Oct
 2022 08:41:55 +0000
Received: from DM6NAM11FT083.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1e0:cafe::d5) by DM6PR08CA0053.outlook.office365.com
 (2603:10b6:5:1e0::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28 via Frontend
 Transport; Thu, 27 Oct 2022 08:41:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT083.mail.protection.outlook.com (10.13.173.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5769.14 via Frontend Transport; Thu, 27 Oct 2022 08:41:55 +0000
Received: from BLR-L-SASHUKLA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 27 Oct
 2022 03:41:51 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <jmattson@google.com>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, <mail@maciej.szmigiero.name>,
        <mlevitsk@redhat.com>, <thomas.lendacky@amd.com>,
        <vkuznets@redhat.com>
Subject: [PATCHv5 5/8] KVM: SVM: Add VNMI support in inject_nmi
Date:   Thu, 27 Oct 2022 14:08:28 +0530
Message-ID: <20221027083831.2985-6-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221027083831.2985-1-santosh.shukla@amd.com>
References: <20221027083831.2985-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT083:EE_|CH0PR12MB5249:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d101d70-a7d1-4ed2-8b8f-08dab7f71a9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tRfYZfI+mrsNSld51Fq/gyK/6a0F42R1dc27PLGF0MnY/tbNo9MOkyOChg9FB95CJ4ugCsjgf/9q4qEztgZVHsHCpVvd/tP3ZXjbo7ucQoSVOA+d0S3XbH3T/Gs3im12xzonjv/shHAtbaEsAnK9D+dx9H4R6EUGW9iIMZHPlg6/r7wz5igdvjSnFxQRCw467IxuZf6RNt0Y/hoM9qyEX4+73OFl0g+g0emPeDd+EEoNFOGBqjIIJwOKNiLey+8lTyrtXE/dfchl2l5HEp6S6O/0SFZwA8kb/1rUzHUgrCOt4QqtDkZ284gtLTWymae2ZnkPnmvOGSXlUF4Ghq5Brl1He3gyAOKbquZJ6BXRhzlowMciBMeZqSTVxAgCk0FNYfOz5g27MUlGet128rEBQtY2/+PS08BUv3ZSu455k17ooEsFOUUGsccSvtkjwTvxyiBoc/sMjswl2wGwv8y58Jfh8IZ78OoHSKoZ3cgtBeazktmXpvla6A7DBpqo4hS1i5twltOJ/DMawt1avNUWPetQV99d32jsvmMWWhS7fDRqQouMIoIilHCfwcx8zufcMRQ+E3P12kFW0shXgKoHFgSOsiM9SWelNrjaJjOv5seIgzQXh6j/0GSJK9UFjNz0I3Bk5DZZlmA3VmL1E/miReFXtWRfCdzIBIQTajTYiVcFdaxFVHSfC5FjZLi3kvvNjHEKGpMOrl1BvayUUmrmj3kShXsQdRWieR9wNef4h6YvrOhXK1x8MmU7YgHC9qM85DtnVuZuELCBuUI5Hd8CpA1zAVD6voWv1OevptjIN7i5MezirBUTigN1jde8DQ9WixQ4dXJzYXbtSk3MVzZS/g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(39860400002)(396003)(136003)(451199015)(40470700004)(46966006)(36840700001)(47076005)(110136005)(40480700001)(26005)(426003)(5660300002)(40460700003)(41300700001)(70206006)(54906003)(36756003)(44832011)(316002)(8676002)(8936002)(6666004)(36860700001)(336012)(186003)(2906002)(16526019)(1076003)(4326008)(7696005)(82310400005)(81166007)(2616005)(478600001)(356005)(966005)(86362001)(70586007)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 08:41:55.6968
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d101d70-a7d1-4ed2-8b8f-08dab7f71a9e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT083.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5249
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Inject the NMI by setting V_NMI in the VMCB interrupt control. processor
will clear V_NMI to acknowledge processing has started and will keep the
V_NMI_MASK set until the processor is done with processing the NMI event.

Also, handle the nmi_l1_to_l2 case such that when it is true then
NMI to be injected originally comes from L1's VMCB12 EVENTINJ field.
So adding a check for that case.

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
---
v4:
- Added `nmi_l1_to_l2` check, discussion thread
https://lore.kernel.org/all/bf9e8a9c-5172-b61a-be6e-87a919442fbd@maciej.szmigiero.name/

v3:
- Removed WARN_ON check.

v2:
- Added WARN_ON check for vnmi pending.
- use `get_vnmi_vmcb` to get correct vmcb so to inject vnmi.

 arch/x86/kvm/svm/svm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 38fa51e0b70f..cf05a41779f3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3478,7 +3478,14 @@ static void pre_svm_run(struct kvm_vcpu *vcpu)
 static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb *vmcb = NULL;
 
+	if (is_vnmi_enabled(svm) && !svm->nmi_l1_to_l2) {
+		vmcb = get_vnmi_vmcb(svm);
+		vmcb->control.int_ctl |= V_NMI_PENDING;
+		++vcpu->stat.nmi_injections;
+		return;
+	}
 	svm->vmcb->control.event_inj = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_NMI;
 
 	if (svm->nmi_l1_to_l2)
-- 
2.25.1

