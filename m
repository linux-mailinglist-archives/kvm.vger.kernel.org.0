Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 002CAFCF7F
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 21:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbfKNUQF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 15:16:05 -0500
Received: from mail-eopbgr730059.outbound.protection.outlook.com ([40.107.73.59]:60877
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727075AbfKNUQE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 15:16:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y6vfXvFNa9ECJCyMNa7+rq15Fs+gRmWTRav/tMAlIpr4VBj46zzaxwf/Q4JU0IYLu8+mkbg3xOMV2dZRZoKkBwYALSglhFcfOeTmNhYYlcxge2tfc/FeKJUBGgYQLWiviWTWoZ6V1R/v61QdT4sF5oBkHm8gIe/UbiUi3JxUXAy1cqKiPbhVQ+EodvMcrY68l6ussOLkjJbZMsf1bbqurg5A2E+0dZQ+FEQ4HAFGP15tH4+7pgvEt51FeUuhX+iJ8GvpXJHTsNJ5F24/iqRWNdmJvh8KKea2bETepiIutM10OAzQsQK1ym+ckSpmBCsf18GsItxUOhJmHTd15Cm3xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q0yNbkBrp7fGPPFlqtk6D5mmN/kWWkB5Y+oAT0DghOQ=;
 b=DWrGYLYkMV4brUSnl1VUcB0f/3T0nua+eWzoEzxSp42mPKtyMMM3mhItJN4muicVoq9eoeegw+CWuM4aGsrBZLGl/oIoUV44tZIjoQraDG70D4OvwFjuL77AP4Jh8vpoNIkM4PMtI5rAEDXkrhuBiWe5KMHTmAFHjN26UVf+Bnq0yqIm64Q+vL2DHiO1iECQilwTixnmza2TbVp6fw0IwRvlX6ClpeIsAQnRpPp4TPVGhoDtNMQMKtqdiKTuGije8Lhfx079OJPYNu8r8P+HxR49jxVlpmeHJy2huku0xEpxYEIZ4AKYp2GmNrSdUKX9DO2KBXple69PbefoD7iuiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q0yNbkBrp7fGPPFlqtk6D5mmN/kWWkB5Y+oAT0DghOQ=;
 b=H0pG0M6Aj/iLc1KwzqyT0y5/8l7U7PQWUVztSznbVwMpuZ9DyHfG6KxZfBBiuAQZKXveRUpV9PeAqn4jydGB4lAEGMxcTajbhnH9gbu5x5SXOooDrjT6MfsGHruY+U1oPs0AYFk2J2cHIg17JuoeA5joHi6lXmEF571biaeC+qg=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3739.namprd12.prod.outlook.com (10.255.172.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Thu, 14 Nov 2019 20:15:54 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2451.027; Thu, 14 Nov 2019
 20:15:54 +0000
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, joro@8bytes.org,
        vkuznets@redhat.com, rkagan@virtuozzo.com, graf@amazon.com,
        jschoenh@amazon.de, karahmed@amazon.de, rimasluk@amazon.com,
        jon.grimm@amd.com,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v5 18/18] svm: Allow AVIC with in-kernel irqchip mode
Date:   Thu, 14 Nov 2019 14:15:20 -0600
Message-Id: <1573762520-80328-19-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573762520-80328-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1573762520-80328-1-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN1PR12CA0099.namprd12.prod.outlook.com
 (2603:10b6:802:21::34) To DM6PR12MB3865.namprd12.prod.outlook.com
 (2603:10b6:5:1c8::18)
MIME-Version: 1.0
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [165.204.78.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 42d60048-2ef4-4401-9fdc-08d7693f73bc
X-MS-TrafficTypeDiagnostic: DM6PR12MB3739:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB37398B350894632272AF5F11F3710@DM6PR12MB3739.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 02213C82F8
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(1496009)(396003)(366004)(376002)(39860400002)(346002)(136003)(189003)(199004)(6506007)(25786009)(86362001)(6512007)(6436002)(8676002)(47776003)(7416002)(66066001)(6486002)(50226002)(4326008)(3846002)(8936002)(4720700003)(81156014)(2906002)(2870700001)(7736002)(66556008)(305945005)(66476007)(2616005)(6116002)(66946007)(186003)(316002)(14454004)(486006)(4744005)(478600001)(99286004)(81166006)(26005)(14444005)(66574012)(476003)(5660300002)(44832011)(386003)(446003)(52116002)(76176011)(23676004)(50466002)(6666004)(36756003)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3739;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KwTyJMSdfEWHkvGMPDuw0WL6PhDbBhSX2siRABEztbj70HkUS+UnJVOhA2yTWQO+0UX/eeUgadRFbatKiac298q5LJh9K9W08l/Agk5QbMIiJ9J/lnJ0HAMXJoaFn3KaqfBIydbnE3TVrVfg/AnHh102DGVCTryt/jf+Gew9qY7WDRcvwTbwbJExwNkbbEEB3rxDq5DRzLijxIFJyyt6KCGqT3GDjeIAgsCIS/vaXuNt9xhUenGMTFap0fnlgqy4quZwRS0AYAWCL9bllNNE+9KEJP2++T6z430jIauLGSoOzXGongeAz/rTFHSl11nAJoJM00Xgpn6v0FyEBHcLqA2hWgl6DLJCiPx2NN9ncJUFPbUh5rLeiXXx//mnv2byjUeh9Bu29Bj/ghultK/br19uC+U0CtmNuJ9ryoxZveqhEiSgMmZHsKKxP9FVqHwo
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42d60048-2ef4-4401-9fdc-08d7693f73bc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2019 20:15:54.5999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EdFDEzP7pIWYz5q751mrCYpTs6+ka8yyKF2ZcIsgHvN3A0K6uWkQvOfMf25wOOIbyLLb6uOnZV3Z6Oo8utYRxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3739
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Once run-time AVIC activate/deactivate is supported, and EOI workaround
for AVIC is implemented, we can remove the kernel irqchip split mode
requirement for AVIC.

Hence, remove the check for irqchip split mode when enabling AVIC.

Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 2dfdd7c..2cba5be 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5149,7 +5149,7 @@ static void svm_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
 
 static bool svm_get_enable_apicv(struct kvm *kvm)
 {
-	return avic && irqchip_split(kvm);
+	return avic;
 }
 
 static void svm_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr)
-- 
1.8.3.1

