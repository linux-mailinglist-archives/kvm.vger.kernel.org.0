Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5589056C9A3
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 15:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiGINoN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Jul 2022 09:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiGINoG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Jul 2022 09:44:06 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2050.outbound.protection.outlook.com [40.107.94.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B307248E3;
        Sat,  9 Jul 2022 06:44:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mmf9/efocHgiG80i+8i0giLWzDFhFXcxLQmHwrlrRi1F7SAaAocjAK3U4iwBpiw6b9Db2vWY7zJ+A1u88aSnd0grfQPqOK6Fsm9fEqQiGtkhSrJQQU+RdQvSyoaJ7OWdA+U4bFFKV1jsJxm+1DhaYa/1D286cBABkpd/vEedVoLG6v4tz8ab05zqJduuWNe1K9A5E7uJiNPssHYmvXPBhZNSxY4IkUVCpqV+PwYNorrSDgiBjXvZRrhxbHlLME5O7mdfd0qDma4vALmfQpDHXJ8BMhaFmFoTgdqdxPZ8Wrr4zNaQYtIj2ZjKpLfejaMsMDeEfJxt0qWBs8Jtjalnxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zIJcqnDf62cs+J0uXCW1ySwJTy+QvBkF5HasLXwE7Ug=;
 b=eO7d/9Y1mBW9s+pEr4rUAIRYVB/PvNdhp3rKoxF3Ij9mEu2icd1SGiHLAE/t1lVm5xYGacYDRkAep/ZQji8m9ZhNSY4e2KsNfQWgw7RtxLKsIGR9r/f5MecVOj12pAoSQxsM3/mNz8BlDvlApXS3QZ6NfNHA21RcC6w1p/JdmnxGVm8QI4aUqomLuftl1VDbvpVtt8VVYXOTumq8RFm8UcW+ekN0oHpIvQR10HTKgsz3QM5pywNW8DyjzfNGhed1rwcVculTrnegxl8H2Szpm0kcrNoq0acgvhLFfwuyDrA6utgDVfF+kXUhUdi8Co3RqH2rOpNgF+6tDCxnUrCcVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zIJcqnDf62cs+J0uXCW1ySwJTy+QvBkF5HasLXwE7Ug=;
 b=z40a9CORtL9pgUazCVVC21mTlhEJhKY3NaA+qccQRHHOObifbrd887lwXY6g9Dho5+v39kifWQktEkg3hP9FAYgMA/jD0VXPcyKX3svronpvGk6zXIBFK3z9yjE3IXJE50pB9EUsZGzrF+Cd40/mnRrGx4Gd09LDxE6e+SsHUQ0=
Received: from DS7PR05CA0038.namprd05.prod.outlook.com (2603:10b6:8:2f::23) by
 DS7PR12MB5909.namprd12.prod.outlook.com (2603:10b6:8:7a::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5417.20; Sat, 9 Jul 2022 13:44:01 +0000
Received: from DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2f:cafe::a5) by DS7PR05CA0038.outlook.office365.com
 (2603:10b6:8:2f::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.6 via Frontend
 Transport; Sat, 9 Jul 2022 13:44:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT004.mail.protection.outlook.com (10.13.172.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5417.15 via Frontend Transport; Sat, 9 Jul 2022 13:44:01 +0000
Received: from BLR-5CG113396M.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Sat, 9 Jul
 2022 08:43:57 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Santosh.Shukla@amd.com>
Subject: [PATCHv2 4/7] KVM: SVM: Report NMI not allowed when Guest busy handling VNMI
Date:   Sat, 9 Jul 2022 19:12:27 +0530
Message-ID: <20220709134230.2397-5-santosh.shukla@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: cc07e539-33aa-4dd7-1258-08da61b11508
X-MS-TrafficTypeDiagnostic: DS7PR12MB5909:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s+0pDCeO6SDbFP6MMMiB6RK9KoLfaC6kyzrqYA/SVfRX0t+4QNyEGfA2W22a80pgJW/rZB8QWm8/zZHJxXFJJyDQpqupbl1lJrZB7JnMZa7FnEvjGC8LzFZvzsMe34TANcsiHFm0M1rTR+dqY3LvDHq520XZ8v8yzYU8TrgPFouN40I4/j2XtpO8PBIeJOYtc6ZlKzfq5gjsUycZlUKHDlXG2Fkko4021Xc5qIcjAhjCK3Nirz9dutlVbdmbn1uO3q5r8/Bb6T3dyWqDvqVa6PHbV4Efzx2cWfINXkfRZ5gIJUF+Vb5bAj4gGXpmr3UYBlOaJh3Z5mcSs12E9GngbRMfVsqkr5BSt3jLi1y+s/7X0fSejW3ftue0BOX2U6+LNQQaXTmDN1NhdWWLfEZu3eLwgqjDUq2yAxBNy1sCk96BHgATEpKYuzfzMqhrMhJhNM9Qecp0ksP9WI7lVlbePqD37PxQMCZCS+NiL3yC4pzt+Cv2Fma3flioih1oJzYb219AAEvgBSSDlAUzxZGRkSIhcA+9Y962wt9OVApM0VScR/hhvKL6qXbT5FW+6xO3SD1Bxy5Q5PQWBuh3ySxoo93kJsMy62IvwFfmcFJvHACuqryF6izIB7U4zNeA/GeZY0i8qtZ+m/6CYvkfd8kEZd8QoyRDB8GVynZO2RoRlBdcEwniK/3HbsLhPnnCdHFMc1K7r3kOddqW4/+gAlxZMNq5FxZJFNlrd2Usb52a4IS+MXct8eeQXRT4RKWxBM1wfhz/4V1l9VJVXJwN68OsPjFiLhDIaMj7FVeM8aSRIuNxAm5flS9zAJLNUD1UTQCaV5gl0O8VcgP1ARSqRi4AjsQjm4YNuLK5AId2K62XFGn2y/93+8fN0CydPHo8Flcf
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(136003)(346002)(396003)(46966006)(36840700001)(40470700004)(336012)(2616005)(186003)(1076003)(2906002)(8936002)(83380400001)(26005)(47076005)(426003)(36756003)(16526019)(44832011)(6666004)(5660300002)(41300700001)(7696005)(82310400005)(478600001)(34020700004)(40460700003)(81166007)(356005)(86362001)(82740400003)(54906003)(316002)(6916009)(36860700001)(4326008)(70206006)(40480700001)(8676002)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2022 13:44:01.5052
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc07e539-33aa-4dd7-1258-08da61b11508
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5909
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
v2:
- Moved vnmi check after is_guest_mode() in func _nmi_blocked().
- Removed is_vnmi_mask_set check from _enable_nmi_window().
as it was a redundent check.

 arch/x86/kvm/svm/svm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3574e804d757..44c1f2317b45 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3480,6 +3480,9 @@ bool svm_nmi_blocked(struct kvm_vcpu *vcpu)
 	if (is_guest_mode(vcpu) && nested_exit_on_nmi(svm))
 		return false;
 
+	if (is_vnmi_enabled(svm) && is_vnmi_mask_set(svm))
+		return true;
+
 	ret = (vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK) ||
 	      (vcpu->arch.hflags & HF_NMI_MASK);
 
@@ -3609,6 +3612,9 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (is_vnmi_enabled(svm))
+		return;
+
 	if ((vcpu->arch.hflags & (HF_NMI_MASK | HF_IRET_MASK)) == HF_NMI_MASK)
 		return; /* IRET will cause a vm exit */
 
-- 
2.25.1

