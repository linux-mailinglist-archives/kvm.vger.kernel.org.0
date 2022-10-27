Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D00D60F2BD
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 10:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234467AbiJ0InR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 04:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233500AbiJ0InP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 04:43:15 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2045.outbound.protection.outlook.com [40.107.243.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55CD915818D;
        Thu, 27 Oct 2022 01:43:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XyTOurlTwsokNnhQHDo2Un9vGhfv3mmhT0eJYOsd9SKvie9GEVWVXSJGiVULlH6LEBH717K1Mb+1o8T+0LNu7XXIsw+Z/46QUPN876280Y4tDzUsfC6g0bGsp+BVGRUPRsV+cttoATwX9a/3XbQdOur+IX7Y31v4bEhcI6LJiIjh5aEds0pSjqTVa+3qAhNmEIfeyAkz4aGO2Q2fJAuW/VVw+3/ZuZUVEQm5VWVCzOrgC5KeB2mOGtWFEJ/Z73ivCEEva/Xvzu76wXKnjfNBJNf7VrAo7VHAOErToY9bNU7sb9TWGQcgbWJQTjb+VrwFWgR6bXO0f8YCjdPPB9WHEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mr5n5WfkkqTMhXEC5M5qqGOn9wh7E6FMVuYJGGh8L4Y=;
 b=S+Q6jb6J5cBdkfRTKUA3X7YMRKifnO1oaKFIzyl0EcFxFgUnJOwIjv7k5MZ3zRM0/2RJHxNQDgfZU3zKgiAdxbaO3h35cJXAMHscDbq8jWxV23l2Tos9Ti++vcQN04nTmMgzH8Md8sV3qiVP38AwoCo72JAJqhCLencEghHRZxHqjx6heoLiveSBMJAzmzumTsxtOU+1Zii+Q3y8UbhLWEXVpEmF9stfQACUtKOm7ZBpjUYm3nVWyNbxlrWqQz+8nfaJUG5oreJVNveh4W2tjtmyfop/jzFX8ira0lE0D9xcaAszIuzLSkS7LSoaa5RFnv6y1T+3cnuy9vNrHKkK8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mr5n5WfkkqTMhXEC5M5qqGOn9wh7E6FMVuYJGGh8L4Y=;
 b=WiVT5d2T9ublpmIZzzE6+ei4tbUCDIEoUu7HKSFjYQeEwcDxyd6biFtW8748tBb0GlcQd3MlqH7XTloO8+8XCzpW0vVSny7lcZTmyoDm6ifLSohaUZNi7i+NqvaJ6joh1jeh8pmQl3JFDHPrkDqKzOpihUP4b0cBMq1xIeQFLk4=
Received: from DM5PR07CA0100.namprd07.prod.outlook.com (2603:10b6:4:ae::29) by
 SA1PR12MB7149.namprd12.prod.outlook.com (2603:10b6:806:29c::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.28; Thu, 27 Oct 2022 08:43:12 +0000
Received: from DM6NAM11FT080.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ae:cafe::1d) by DM5PR07CA0100.outlook.office365.com
 (2603:10b6:4:ae::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26 via Frontend
 Transport; Thu, 27 Oct 2022 08:43:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT080.mail.protection.outlook.com (10.13.173.105) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5769.14 via Frontend Transport; Thu, 27 Oct 2022 08:43:12 +0000
Received: from BLR-L-SASHUKLA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 27 Oct
 2022 03:43:07 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <jmattson@google.com>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, <mail@maciej.szmigiero.name>,
        <mlevitsk@redhat.com>, <thomas.lendacky@amd.com>,
        <vkuznets@redhat.com>
Subject: [PATCHv5 7/8] KVM: nSVM: emulate VMEXIT_INVALID case for nested VNMI
Date:   Thu, 27 Oct 2022 14:08:30 +0530
Message-ID: <20221027083831.2985-8-santosh.shukla@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT080:EE_|SA1PR12MB7149:EE_
X-MS-Office365-Filtering-Correlation-Id: 91e018ba-c8c6-4694-779b-08dab7f7481b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cmdFD39GY8NtlTIvvCvqo8gQSjkE04gwkd/zdZDRMdh2AdOueTEQmCRM+EyzDH9QLvPVVBmoxekeNT7CkdPbBeqjcttb7w3TK3DRgPGnGVaK33n7Bmpk6Ik1VhsceEnENpjdcZfkgYXDdtZeAWE2I/dyvsR3LocPvsDdPXPRMo+QUX+V2ODHewl8E9Bsh2ZwQLJFOv55Fu9W9F7+3wx9WhJk7ntzuoeAU1IN4rrbmyZ/0GV37H4l/q9zAnt9iCQ29q3RYAbVf2ygLazEfQLib4FfOUVFawhgzcuCOdUtM0fzm+tkTRP4L3mZMxZ/av7ar7KHwducocrlZ/SqugL/sADtxQYsY+bMW/SDcITOpji8brzFzLYykL6s25Cf9Vl8y5ozRLciL+ES01U1qc36DK1hfl/YRZMapO0QS8ZpLvw73eatuk73sGgJPoHZh+/rGfKk/Kz86xahXACW2HQRA/6hhw+8yX+iU0/T08qT/sX8cec3OmQxNFXqoBkC7Z0pWITz8n/YNoQlQHCGUAwS3XgCdTtdFf9c6N6FlOJoPgiEZcQZAMF+eTQRt1jUrOJnCxTkNqzqaSB7W9kjZELQz+5CZdzTUyHrSt0QI+dgKhYyoqwVrV780v1YYEN10C+WHhrZCDxkFZd7pC00Fhq1+1yHP+/muWVxTzv4V+7MLVeHN/XqtdqbuYi0NIOZd0iQ/BcuxLCTnkIfhuO6mgk/Ptr6yaeMG0kBPCTI6lWOhX/fnOmdvxZFx47OIFQ2bxsmSxydR6jQIpQ+ky6qelG9zxrNU8cTM93Le0AjwFCnQ3ZfaSYp+TXO57QQc5XvN79K
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(39860400002)(136003)(451199015)(46966006)(40470700004)(36840700001)(7696005)(2616005)(186003)(36756003)(1076003)(336012)(36860700001)(478600001)(426003)(356005)(82740400003)(6666004)(83380400001)(81166007)(16526019)(70206006)(40460700003)(47076005)(40480700001)(316002)(8936002)(110136005)(4326008)(54906003)(26005)(82310400005)(5660300002)(41300700001)(4744005)(70586007)(2906002)(8676002)(44832011)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 08:43:12.0130
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 91e018ba-c8c6-4694-779b-08dab7f7481b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT080.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7149
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If NMI virtualization enabled and NMI_INTERCEPT is unset then next vm
entry will exit with #INVALID exit reason.

In order to emulate above (VMEXIT(#INVALID)) scenario for nested
environment, extending check for V_NMI_ENABLE, NMI_INTERCEPT bit in func
__nested_vmcb_check_controls.

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
---
 arch/x86/kvm/svm/nested.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index d1c22c89427e..e94ec6dee661 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -274,6 +274,11 @@ static bool __nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 	if (CC(!nested_svm_check_tlb_ctl(vcpu, control->tlb_ctl)))
 		return false;
 
+	if (CC((control->int_ctl & V_NMI_ENABLE) &&
+		!vmcb12_is_intercept(control, INTERCEPT_NMI))) {
+		return false;
+	}
+
 	return true;
 }
 
-- 
2.25.1

