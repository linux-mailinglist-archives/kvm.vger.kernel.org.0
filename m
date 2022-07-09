Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9494456C9A5
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 15:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiGINpD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Jul 2022 09:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiGINo7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Jul 2022 09:44:59 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2042.outbound.protection.outlook.com [40.107.93.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3A54EB1;
        Sat,  9 Jul 2022 06:44:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LGReujOR4lJx0Jtay6STlHIQeSn4fiwTeVUPwwftSNP1ioSsThfm0aNxgHOzM+3cB6hHznz9+LvJEtET/1uxZnztQEQRZsH2dH35Y4bn5nrrad40GTh7LIB2LpFKmggWACMl/01Z5yuxGXJac2YmtOj3qCB14HU0ZuUvdK3rkUgj7sQqBnWBjfgS395TUcpA1URIedAfDmKMldl6kYVBYsLdeAxCXPx6jaqBe8/jilVFzLthDm1gkkt/jkC7kaXw/yXddX0okfsW19GyazPpXYN/66zDChwVX6/QbGi6+r6UioYdPGlQldN+1SxOLI1HcN1ZyhEsos5qnilkUtoxVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TxTTgQsSUO34lolM077g7Ih15YWqfRj7bZ7El5eKOI0=;
 b=K1w+wi9W9aaYjy8NDHs/O5pAoGa2qBDBzv4LcVgmXa2VHfsovPCcFo0gct/4/WD7cF2tTJUoZ/Jxg9cyLF/5TU9+Mj7zywvd9TabyMxd+yFXr7LuFA1FTayZW3KCfL4ylVa2P1wt6VV/jfNq7P4POPpY8fOnimGQ4AMuDnXOTba5MgLE4KsEoD4615oAk5uSdjkX6Mjm+hnu1a7SKRVP0+3kfqhs6wgJ9dxPzrW7doPFQI5kZLD+5yPeJihckvx0jT/tU4saq56PG5d5oNm+RlI5nK6XNBlshrgC4kbx1zsYiOhnZChYWIxpUJGevw7pWSjbwu+MYWs85QDykk5mcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TxTTgQsSUO34lolM077g7Ih15YWqfRj7bZ7El5eKOI0=;
 b=uFVEcx6cVGDMQrAKinw6lstkCMU1UD7Tkzyz5rG04eQGyLCQdZG3qXJr1mbFp15njK66w6ifG/td/BiZlnrTxdZmdkAt7rms3J50UQhJVn66tbe7hJgBu4fSveV783+XRH3Xhrbkuhstj86dE7H7sP30vO+7sSAJtmII07g0Zxk=
Received: from BN6PR2001CA0002.namprd20.prod.outlook.com
 (2603:10b6:404:b4::12) by BN6PR12MB1603.namprd12.prod.outlook.com
 (2603:10b6:405:b::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Sat, 9 Jul
 2022 13:44:56 +0000
Received: from BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:b4:cafe::18) by BN6PR2001CA0002.outlook.office365.com
 (2603:10b6:404:b4::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.25 via Frontend
 Transport; Sat, 9 Jul 2022 13:44:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT017.mail.protection.outlook.com (10.13.177.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5417.15 via Frontend Transport; Sat, 9 Jul 2022 13:44:56 +0000
Received: from BLR-5CG113396M.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Sat, 9 Jul
 2022 08:44:52 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Santosh.Shukla@amd.com>
Subject: [PATCHv2 7/7] KVM: SVM: Enable VNMI feature
Date:   Sat, 9 Jul 2022 19:12:30 +0530
Message-ID: <20220709134230.2397-8-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220709134230.2397-1-santosh.shukla@amd.com>
References: <20220709134230.2397-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76cec911-0b31-4e05-d996-08da61b135b7
X-MS-TrafficTypeDiagnostic: BN6PR12MB1603:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QXp38N2uw/Z1eGtdaIKlCsxcafX/Y/TKuKXezHjhVBuuMaB6heVuRsxRTHlKtGx0FHU4Ed/HlSUpF+pVuSEoRufS85HBwcxPezjddhFMlQ22OwHqKMWoEv5oOCBYjg7W6PsKtw3qhtobGGwKVM5FK3jzcUaEHK5qmEN9c3tH7uMddIYVQurfuexkfe3o33zmN5QQ+JFl6GPFqrIM56ejK8KcpWfHYzkHfijnaDuLjPcV43JtUFijraMkoRg9j7eC7IzJIUXyqIXpDwa+uffWS2uRC+QUniHKPmJrn5tiiiTLhyGAy3KEfqe+e/p8F9y8Mz4xNcQzjfIZFgkrRBHuqSKUAsxVPF40hI2gw01FkciCk1Xi/dymVjqa7f6PFWKxrSgysm9R382KNIiWgG9s7ak5Q+uXLl2WOoIG1TRRx1JVBw+Dijz93Nwy3Gbddg23JFjp6MqKoTesMgWxP6VUqfhAdcT5lTDozgPKHqzMoOIRw7noarXInQ/NUlh5LBKQf+x196wlYzjdKKp3D1KjzKm2E8f8sz+tZanQxXRS9ZlKKFMF3Tln88RL2h8mLcUnLQHXFBxhQaUm+IJwtGnvzj5w7WZgca0+8eqQ7hA5Gh7OYZEh1zr9wTzIUnbdqTMK0wc2/hrWnMsLCeMEAeFTQOAushIttrQfZZ2Y1avdl0ZI9Hyq1/YvhblHCtE0Z2LYPgT7HdvUPvpyHjuLXpD25qRs5MmSKgP2LH7Ux2IpWXlGqyRTc21g2ckDwgWMCUomLPbItGy66bzr+i5Qng0D+nZ4ToJXgaewWOTpASNmQgmUwgEqWFb37cqAuyuQWnYmKEHnMDPEpVHoxZqNbkU3qsqgZexJ2igtydKvD2y/nKBkpS0B1/liSjaPRH1RbfLN
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(136003)(376002)(39860400002)(46966006)(36840700001)(40470700004)(186003)(16526019)(2616005)(336012)(47076005)(86362001)(1076003)(40480700001)(356005)(34020700004)(40460700003)(36860700001)(426003)(82740400003)(70586007)(70206006)(36756003)(8676002)(8936002)(41300700001)(2906002)(44832011)(4326008)(54906003)(316002)(478600001)(6916009)(7696005)(82310400005)(81166007)(6666004)(5660300002)(26005)(4744005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2022 13:44:56.4068
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 76cec911-0b31-4e05-d996-08da61b135b7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1603
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enable the NMI virtualization (V_NMI_ENABLE) in the VMCB interrupt
control when the vnmi module parameter is set.

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
---
 arch/x86/kvm/svm/svm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d81ad913542d..536aa392252b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1208,6 +1208,9 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	if (kvm_vcpu_apicv_active(vcpu))
 		avic_init_vmcb(svm, vmcb);
 
+	if (vnmi)
+		svm->vmcb->control.int_ctl |= V_NMI_ENABLE;
+
 	if (vgif) {
 		svm_clr_intercept(svm, INTERCEPT_STGI);
 		svm_clr_intercept(svm, INTERCEPT_CLGI);
-- 
2.25.1

