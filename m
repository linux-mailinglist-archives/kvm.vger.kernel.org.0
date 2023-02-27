Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10C1C6A3D70
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbjB0IvF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:51:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbjB0Iua (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:50:30 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on20614.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::614])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30EF210266;
        Mon, 27 Feb 2023 00:43:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B8DVkhNGIhDcpBdknfslgrLf/omZyqlTRHYE0GSM+cK1+9yogsRHoHb4wFTB2VpAb7ZMkQjsACkt5ud67cUHutJKy7z6gXGeKSB9DKmv5FZd84oA0WwwlUU4OFg2O3fzelqnsM6YXd81D8Xkgqa6ZK9aRm46GmtrxNRQViM59fkdIkbgrg1bkhRnB/yHGZi7nc6pcc+DzzHJrpvom3Uw++0OBWPVRLhN4G0+718d9jI/YqLYt7uo0hTQA38qy0NSIFzOdFcIrVpx8tjkqOk7ntA8w1/RlKqx8wwJi+8WMBEl8uUTeby2JEA7+oAB/zDw+TWV9XVP57eqmC7297VKJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wCjtjmUdub70yTg9UFMKx1gKdxsTkWLFgb+6eHx1Yxw=;
 b=TRGnSIG+OwUvuFCxrRwf2D2N+VwAgyXWtIDJx7MR+X20eKosdCTXg+tmUKISXtxOIF+uw6r92bgI0MYA9za6TQlkxMz6sIuYcsdim1MQmwokh4pcA0RAD/vPE0IBVjDGttD0R5V7g6oDrVjeZEhP1IFA9nHVNRU5PSS5f5ETTBcWMNxX2y4xIbS8V8SVlpXK5d8m65d57+oGMVipk+rprG4vkFj1Q42QQLnR/Vu48sfFmKWR3kKQY0Xj0nbkt9Qn/3eKqwFI/gxwT4Fe/JdLlVGkHBZ6AiljvNzVf1g86wuZ9DNrVXpk3wW0ycuQN0fYhF/rzYrU4FjYJzp+cLP5Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wCjtjmUdub70yTg9UFMKx1gKdxsTkWLFgb+6eHx1Yxw=;
 b=pByBlHiVt508TxuSyt0wKFkfxXPML2KlszyJllFn672vtvNkaOxJJMa3erxKz03pJ5DuLtgtpdsKATKOGwoRYHsfs9/86Ds5QsIWZH2uqEf6l6f9oMyvJ6X+bN2BzbVTLyKM8KKW6c8vULUNnQkRgIZFQ3fW/sTf8zyj9bI8S8M=
Received: from MW4PR03CA0034.namprd03.prod.outlook.com (2603:10b6:303:8e::9)
 by MW3PR12MB4476.namprd12.prod.outlook.com (2603:10b6:303:2d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29; Mon, 27 Feb
 2023 08:41:36 +0000
Received: from CO1NAM11FT071.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::51) by MW4PR03CA0034.outlook.office365.com
 (2603:10b6:303:8e::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29 via Frontend
 Transport; Mon, 27 Feb 2023 08:41:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT071.mail.protection.outlook.com (10.13.175.56) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6156.16 via Frontend Transport; Mon, 27 Feb 2023 08:41:36 +0000
Received: from BLR-L-SASHUKLA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 27 Feb
 2023 02:41:32 -0600
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, <mail@maciej.szmigiero.name>,
        <mlevitsk@redhat.com>, <thomas.lendacky@amd.com>,
        <vkuznets@redhat.com>
Subject: [PATCHv4 03/11] KVM: nSVM: Raise event on nested VM exit if L1 doesn't intercept IRQs
Date:   Mon, 27 Feb 2023 14:10:08 +0530
Message-ID: <20230227084016.3368-4-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230227084016.3368-1-santosh.shukla@amd.com>
References: <20230227084016.3368-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT071:EE_|MW3PR12MB4476:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c251765-0b27-4559-eea8-08db189e6fe5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jsf+jeg94uvSIUjn+2B8hcY1mc4UTBTM38YyfWtZDaH7c2gm/tlDYAwzM7RphDvSe4jNe/CnCaX9iQTGCpAo0YdXRO/c7BL+qe1nEwdt0xnPawwmJOnKAzc2SDZ9GSbetGCu342eyu7FulEiEx7AocHKDq6/sgcp6NiuhBBs3c7G/G0p6ctd2yA5RoOXlNFnkEKw35v8UPh+lgqJrowWkjh1k8EP4ptFzvtFeR5jTsvXmpzMvqpygk89j/ybfHEpA7RUh4V/rfmj+dKCGQ8YISvZ1B0QTAucRhLrdUTMymXVrnO3GOZ3ZlYqODLa9H2mp2elbSewBekCye8UFrVQqiJGDVuEzIFho101aR2S/gO35gojxgKAHFadvrz3GsT1jsYG6ppIxV2zUhM8tKE3qjafHQooEIAshBDGM3qjaPj2Nw+6ajU3Vu4MMKky/Ur+/bDJQ2xKHh/XrLs6oucU3oWsZ1Teh1/jt5lc/EAn94Ekh6H2EuCOJTJ2YYrL2zzza2BTjX2IAxSb3AYhw59mYFiGnj8pcKl6Df8TRSCkI/hrcippnJ3ZKedqIdUhLTKro6YxFl/yLwfaPD1bbG4JijDvtHyJFrruUzp7/Uradplq/uMw04Z8ZQyodAO3itOQpxCwW4v9/VzPevYTH7Ft4k3bIercxo6KOiVNAePsQdT4bgVm5XOKbhHLvvx+iG3L1X5VjtZ36Qf2dd3tmCjkkgj2XBPhgqbHGHVIge+QHCs=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39860400002)(396003)(136003)(451199018)(46966006)(40470700004)(36840700001)(2906002)(44832011)(1076003)(5660300002)(8936002)(36756003)(41300700001)(110136005)(40460700003)(54906003)(70206006)(70586007)(316002)(86362001)(40480700001)(966005)(7696005)(4326008)(8676002)(356005)(478600001)(82740400003)(6666004)(81166007)(36860700001)(82310400005)(26005)(186003)(2616005)(16526019)(336012)(47076005)(426003)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 08:41:36.2889
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c251765-0b27-4559-eea8-08db189e6fe5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT071.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4476
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

If the L1 doesn't intercept interrupts, then the KVM will use vmcb02's
V_IRQ for L1 (to detect an interrupt window)

In this case on nested VM exit KVM might need to copy the V_IRQ bit
from the vmcb02 to the vmcb01, to continue waiting for the
interrupt window.

To make it simple, just raise the KVM_REQ_EVENT request, which
execution will lead to the reenabling of the interrupt
window if needed.

Note that this is a theoretical bug because KVM already does raise
KVM_REQ_EVENT request on each nested VM exit because the nested
VM exit resets RFLAGS and the kvm_set_rflags() raises the
KVM_REQ_EVENT request in the response.

However raising this request explicitly, together with
documenting why this is needed, is still preferred.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
[reworded description as per Sean's v2 comment]
Signed-off-by: Santosh Shukla <Santosh.Shukla@amd.com>
---
v3:
Reworded commit description per Sean's v2 comment:
https://lore.kernel.org/all/Y9RypRsfpLteK51v@google.com/

 arch/x86/kvm/svm/nested.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 107258ed46ee..74e9e9e76d77 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1025,6 +1025,31 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 
 	svm_switch_vmcb(svm, &svm->vmcb01);
 
+	/* Note about synchronizing some of int_ctl bits from vmcb02 to vmcb01:
+	 *
+	 * V_IRQ, V_IRQ_VECTOR, V_INTR_PRIO_MASK, V_IGN_TPR:
+	 * If the L1 doesn't intercept interrupts, then
+	 * (even if the L1 does use virtual interrupt masking),
+	 * KVM will use the vmcb02's V_INTR to detect interrupt window.
+	 *
+	 * In this case, the KVM raises KVM_REQ_EVENT to ensure that interrupt
+	 * window is not lost and KVM implicitly V_IRQ bit from vmcb02 to vmcb01
+	 *
+	 * V_TPR:
+	 * If the L1 doesn't use virtual interrupt masking, then the L1's vTPR
+	 * is stored in the vmcb02 but its value doesn't need to be copied
+	 * from/to vmcb01 because it is copied from/to the TPR APIC's register
+	 * on each VM entry/exit.
+	 *
+	 * V_GIF:
+	 * If the nested vGIF is not used, KVM uses vmcb02's V_GIF for L1's
+	 * V_GIF, however, the L1 vGIF is reset to false on each VM exit, thus
+	 * there is no need to copy it from vmcb02 to vmcb01.
+	 */
+
+	if (!nested_exit_on_intr(svm))
+		kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
+
 	if (unlikely(svm->lbrv_enabled && (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))) {
 		svm_copy_lbrs(vmcb12, vmcb02);
 		svm_update_lbrv(vcpu);
-- 
2.25.1

