Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFE953BAC1
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 16:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235921AbiFBO2V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 10:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235945AbiFBO2O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 10:28:14 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2069.outbound.protection.outlook.com [40.107.243.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB88C13B8C2;
        Thu,  2 Jun 2022 07:28:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RX56qFR8kF5ZZn663C709B3H6Iui9upaHq27VCg/5xmr8BhLnQxdfrpwuAyIGLWoTwdHdYgifK5l0wuZ5EfrEaVTPbXRYPkihHoddfo0/1eTEyCB8vcPS305PXVJO0D/a/4gUmGwdFWwJzkRjLc7DYT7gwwXswjEcfsE1Q9YkyaoyXl7Suydxa1UQY4sEV9tXeHVBas9yKTUQqUwR431vCIrCNePvHT+Qod3yhG6ucZ41zo2oxUICrKKQqi41lWn2JRmfPbGi3kymijzrosYdVBmalYIpXgqc+F+1ji2XIcNPDxoZ/7/EPFSVH9Iy88Y+7UyrUKcWiQ2mOGXJUuXkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xvz62h4ce8x6Jlg0rnGiIt19HXPFdGmibPoOctF8Fig=;
 b=JSevWlUy80gC3WFeCkJasbn7roz7JIsb/7OPC+AYlPezETVw16f3ESY7yaF+5SiQbvuIgu3DDCUKG8FfqSoLTiN/fDn0jXY1HyHdgshkkZcRtHT1zCY+j3QBXz17ypheHbOGO9jeIswqNIrxExAamoOVu+6dggwCacq/JNPlciNcAQcUl3CIHtLIljhTxR4BWKAmp19bl7YJ1LD/fHB45JNKxYb3XOMUbxfCHD1SmWCXqzs7ZOdKUv11zwBbFNV6Isl3V7YcFejoYN9oY6qWu5Rbd7RoXlxP5fl1/GJeXfT58MR77UK9sAeQjUZtiXIiHPLDKJJvmWs/QAFVjWdT5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xvz62h4ce8x6Jlg0rnGiIt19HXPFdGmibPoOctF8Fig=;
 b=s3qRPgKytzfoLQHyLCqZ8lDSvyUTcJbpL84m9HeVcrb2FuJ+1sXMBqCI5FVH3DBZMLsrzCSjYDeA3cfSvfBcyGPymAW4G97sgoyBJ3F0n5+tb7Fw4ERFco4oeDBRtrHoEMA5pABqh48xpoG4lmw0kACAmcDstOWI8Ssp1bNHz34=
Received: from BN6PR19CA0116.namprd19.prod.outlook.com (2603:10b6:404:a0::30)
 by BN7PR12MB2802.namprd12.prod.outlook.com (2603:10b6:408:25::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.18; Thu, 2 Jun
 2022 14:28:02 +0000
Received: from BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:a0:cafe::c9) by BN6PR19CA0116.outlook.office365.com
 (2603:10b6:404:a0::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13 via Frontend
 Transport; Thu, 2 Jun 2022 14:28:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT022.mail.protection.outlook.com (10.13.176.112) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5314.12 via Frontend Transport; Thu, 2 Jun 2022 14:28:01 +0000
Received: from BLR-5CG113396M.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 2 Jun
 2022 09:27:57 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Santosh.Shukla@amd.com>
Subject: [PATCH 5/7] KVM: SVM: Add VNMI support in inject_nmi
Date:   Thu, 2 Jun 2022 19:56:18 +0530
Message-ID: <20220602142620.3196-6-santosh.shukla@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 2989aefa-0f97-46b2-2f6b-08da44a4197c
X-MS-TrafficTypeDiagnostic: BN7PR12MB2802:EE_
X-Microsoft-Antispam-PRVS: <BN7PR12MB28026A4D8026A15A044164EC87DE9@BN7PR12MB2802.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5bbQBT7ixgC8qmdKohj87BuTMry3f2+VdE1F7KCsrmJdHNCIldFIdAck3GpzmDzSLtGNR77KQ5wVkhbEy6QexOdj6+Il4tPav7PPF6ZIeJNaMN4CuTo8Le5BZq9VU3TMEi3aIK9JD9v14eMs8SO3DksSj47AliRqm7mV3FOkhlN9t/xxJkA0biEFFsT5KO3SzJ6ePj4ahS5uc7HtXM6Ahe4Yw1yd9uKUcbsuy8zRUuyFiegqeNEcWrzKR/MpE8qDn49uk9lfcML1KqggI/o7/tDYQh38KivIkLGcC+RoJwWBdbIytXy8Z3d1BDqIoFdOS7P/VkPnuSgiL5NMTLGyg044m4HuLGCzwL0z/JKu+XNNyOX7VoxNZrH9lk/lNbEgdzaGp8RSOZLW2dgylGFhkuvtVNe31O2iEtq9b0MJJVFA3gWg9ZF80MfSuPbgdoemA89dBm4KGemSOUjPSrWzbcAev4p9DeLzYt6/74pd1kDS4b4MfmJ/+BG5RIUogjbC1XoMEXPlNP40M/bONb/Le0CVtDR+OCluRj4cx38+qzp8M9/LHw8FrNrjuH7q3cLFm4tCpVSvwRcgoMq/+cjpgyOTtheZim+y7occVEEcR1CikDGwAJPEXcX9RBYI90laQwg2z+GSK4z0Lb8gr12RKHIeCmZi70craSR6SKKrnRAGkw9yyJAlM30WWN4idPFFOc4K2zWDqmpIS4Wu4Yp7LA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(36756003)(6666004)(508600001)(316002)(40460700003)(6916009)(54906003)(36860700001)(336012)(186003)(426003)(82310400005)(2906002)(16526019)(70586007)(1076003)(70206006)(2616005)(47076005)(4326008)(5660300002)(8936002)(44832011)(86362001)(83380400001)(81166007)(356005)(26005)(8676002)(7696005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 14:28:01.8459
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2989aefa-0f97-46b2-2f6b-08da44a4197c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2802
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Inject the NMI by setting V_NMI in the VMCB interrupt control. processor
will clear V_NMI to acknowledge processing has started and will keep the
V_NMI_MASK set until the processor is done with processing the NMI event.

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
---
 arch/x86/kvm/svm/svm.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a405e414cae4..200f979169e0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3385,11 +3385,16 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	++vcpu->stat.nmi_injections;
+	if (is_vnmi_enabled(svm->vmcb)) {
+		svm->vmcb->control.int_ctl |= V_NMI_PENDING;
+		return;
+	}
+
 	svm->vmcb->control.event_inj = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_NMI;
 	vcpu->arch.hflags |= HF_NMI_MASK;
 	if (!sev_es_guest(vcpu->kvm))
 		svm_set_intercept(svm, INTERCEPT_IRET);
-	++vcpu->stat.nmi_injections;
 }
 
 static void svm_inject_irq(struct kvm_vcpu *vcpu)
-- 
2.25.1

