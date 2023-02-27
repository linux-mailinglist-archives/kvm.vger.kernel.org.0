Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 258D16A39D2
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 04:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbjB0DzV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Feb 2023 22:55:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbjB0DzT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Feb 2023 22:55:19 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0857118165;
        Sun, 26 Feb 2023 19:54:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QydOKSIaWzLnm8U+iBcgwsna1cMx60r/5V42JQAgRJ1u4EqUs/mCxj26QujRex3lp1rQahKtYiiNDYqjEmZ76k/n51KTf3XHjYofsN+pMdKvJGsdG0yfbUsO9CKBhvNJH760p6NTB6FGjSMrZVX8x3rlTiroTQPj+8zNPOVCba7W9cxHFZjngCmEskWEmaU11138iKXSwJrbl6I6q+mQMVv61O2oYOWrvc6Tpfxc6wa8BEh/Dk5CCC9Ml3tyb3J/1mQpEIw0bzBJv0rYvw8eqnwHkA1vS6r2Ss4/HTskfXUhkp8vIwNuUyYL3RWEKO0Ig1nog7txPsFkzVAW3sPIVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JyH9v9BOX1ih55cDoML8MMxJytu22tVxlxjFFEiKtYg=;
 b=XtpgRxEg9V3kqgpoo05v0I1x3+uhw4V7UlK3V9QCepJlHY7nJ1OnbvhuhuQB4nQa0Qu4mWHctVu2OF1bLHaIvq3F1KNGhZRabCCCoV/ITglRQX2dOZ6PxuFnGE5/PNPN5aos8Y1fBqxh47ZdkpWyjMN9zqc6ZpQ3BlEccnp++hnuJTnMerYKMn74EJ+7Wg9eXPXJctqNAw+qCBfbY/wn21+oetJYNGls7frPb0ENFYZFFJVtW4Z65hA6wN8EF6QQgfD7sz0XPrXH0u09SJ33qvnwnUYDCS7ulauw6wH3uz535XsSyIrd92DluC2P8T4T0x2XkNDzChPWwXKOhlt6uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JyH9v9BOX1ih55cDoML8MMxJytu22tVxlxjFFEiKtYg=;
 b=fdBm7atY82tqmhilix31+TFSnhATAeQHWCmlc/L7q95mYdtIcCp1sgNQRaUj01JbFca6g2Hn6QLhDPMdeM0GYHYWtAJZTLn7M4d2QbrHfnu99Unl90KHf1b0YBrSKXuRi3I8lLWdvMg9R8gX2XJHiYOk2eES2FWgDs8r1up1Prc=
Received: from DM6PR11CA0027.namprd11.prod.outlook.com (2603:10b6:5:190::40)
 by PH7PR12MB7332.namprd12.prod.outlook.com (2603:10b6:510:20f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.27; Mon, 27 Feb
 2023 03:54:54 +0000
Received: from DM6NAM11FT069.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:190:cafe::d7) by DM6PR11CA0027.outlook.office365.com
 (2603:10b6:5:190::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.27 via Frontend
 Transport; Mon, 27 Feb 2023 03:54:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT069.mail.protection.outlook.com (10.13.173.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6156.16 via Frontend Transport; Mon, 27 Feb 2023 03:54:54 +0000
Received: from BLR-L-SASHUKLA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Sun, 26 Feb
 2023 21:54:49 -0600
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, <mail@maciej.szmigiero.name>,
        <mlevitsk@redhat.com>, <thomas.lendacky@amd.com>,
        <vkuznets@redhat.com>
Subject: [PATCHv3 02/10] KVM: nSVM: Raise event on nested VM exit if L1 doesn't intercept IRQs
Date:   Mon, 27 Feb 2023 09:23:52 +0530
Message-ID: <20230227035400.1498-3-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230227035400.1498-1-santosh.shukla@amd.com>
References: <20230227035400.1498-1-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT069:EE_|PH7PR12MB7332:EE_
X-MS-Office365-Filtering-Correlation-Id: 6486b227-50df-45a2-8717-08db18766287
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gWv6XLduXgw2CFtKX2+SsEcsL8LfwVVxVQkouwRKa057IKxTl8vG/JApbAmOEkr61ky2sIMMrDwwpbZ7Fkx83k2QtqTmgnfpRfhaySEO+OBMqULjKX1PE81fc4nFK+WBIbA3EkRgHLIBVjexj7sC7MCAflwFUc5C7jJrrM6FR2gaR0QX0J4D8CD+GBAClTPOpjY2Ai5WtYzmGZTZs8XMT+hVsUzsb/D3voJ75yVwzr3EnpTFClBDDAcePdO9KZ3HWW4JrscW7S4W8AUe3nNwWdkts60dTF1P0HUkJtPXYjCV3KnpXekwtXkNXX7oeE4HUOeDBi4FKq3ZA14cdP7y4EmiURpEZLuLSEFqgXoaNHSM2aLQTqgy6J47wDGLbD5iSEJLN+BT1O2FCoue9AobcteqYphn5+hpkDpWDmrNK2yDf0HVXfuxgnNbvk1auDiBleQuD5HMaAZk94NMXW/22Mi8JYrxIz6K+gGL9xlKEfIjWw/s2RbBALlgNDzu+lc+Ql5z6LDCvVBRF2+QzAthZcXuAczTArrKY/VvZIlhGNOPjINzH9d+qLH3QMjsn/eSVJM2bjb2NxVd98SemrFe6rFWpZVw6Kef194XgcwF0Av56JG+d1k5FsSI/GrsnmioCSdDZbCn+tQGDNu2JZ/W3QPzHNAIKZXvj/pOcGpv3qfRzXISxikLkOrIcPgnG7gaLyzTnXVD70pGmCuZxjyI1W365P3FuuSf4Y6f0Bwegl8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(396003)(376002)(136003)(451199018)(36840700001)(40470700004)(46966006)(70586007)(4326008)(70206006)(83380400001)(47076005)(41300700001)(426003)(36860700001)(82740400003)(316002)(36756003)(16526019)(8676002)(336012)(81166007)(8936002)(110136005)(54906003)(2616005)(5660300002)(44832011)(356005)(7696005)(966005)(86362001)(478600001)(186003)(26005)(40460700003)(82310400005)(40480700001)(2906002)(1076003)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 03:54:54.0688
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6486b227-50df-45a2-8717-08db18766287
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT069.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7332
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
https://lore.kernel.org/all/Y9hybI65So5X2LFg@google.com/
suggested vt Sean.

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

