Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E06F4732FD
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 18:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241330AbhLMReg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 12:34:36 -0500
Received: from mail-dm6nam11on2069.outbound.protection.outlook.com ([40.107.223.69]:11680
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235736AbhLMRef (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 12:34:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bgBRjz3kvCebID9fkzrrpoA2CjhhTrzi+EmUoUIj2BwCIBMYi1bNdlCWJD18YslLjxOcsY63y13wC2mA/55jAZnU+wvsPptNw/3YXiNqZpcZOQuw1yqLFIkCjV88IoY+N4k2oXwZQChNvW7nidb2Ymksh4+BD01NeIoyhkSBP0mw0+KKkU4s49XTcPuDpvEHcrCLM4yc9Ksus6ECbZUK1dk36jAx01QmkpRsxFV2u+dLvnA30t8hgxADB8zVy7T2Ap8SM22vcyVKY9dxOHiPrwqo8x3trGWZI230TG/7K+nOXNh3EmAg3Wfy+v2azaCOGIdBELn0HLs9izyi2YGDaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mgEFxvgeHx9umd/DLkt+jbmN7BQarcKCgNB0WDkbZEM=;
 b=b9ABNoKYJS7gC9pbQhhSUduz8hFRIfRwu5sHZzfxvxC3MJv4qc7VUh9vQ8sjmPRI+z6WqlSrg8au18EZNU2FGQfzFHlhlRko7+rCfXDMcEkVoXkz6kFwWggyq74/b29hVf11ydBzEp2pqhZhFR+4llUTAwTGcFvfAMN3IIG6fli6CWmsmlmBC3qJVyrQDiUN6KBoVCn6Gcx5F/w9UTrf218Yq1un2zZU/q+SELFFHa55D42ZXjoI08Ya3VfBNw1SB8aZExEjdCb3QRUp165933aNIxcJmJzrwh1CHy2nDFkVuB3/l+ath25Rs4ZFTTeC1qSJ8VXZh39MnDfYzBgHTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mgEFxvgeHx9umd/DLkt+jbmN7BQarcKCgNB0WDkbZEM=;
 b=TNb3hJBz5xO+OBEtGXSMxRbFmTGFmaTLgBb7YKN7OuqmsbN9mv8yTVAAEiNLHV7JbbYhNNAgsQGCT4mWHN8YovyRPvZt4TKwZMTtLTRKJReYMgNuTwUhBuJFAgQMcPpTkhWPAAu2INlDU1cg/aeQoe+Vg4MZxpOUrjZcdf3tMzg=
Received: from BN6PR17CA0034.namprd17.prod.outlook.com (2603:10b6:405:75::23)
 by CH2PR12MB4648.namprd12.prod.outlook.com (2603:10b6:610:e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11; Mon, 13 Dec
 2021 17:34:33 +0000
Received: from BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:75:cafe::2a) by BN6PR17CA0034.outlook.office365.com
 (2603:10b6:405:75::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11 via Frontend
 Transport; Mon, 13 Dec 2021 17:34:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT010.mail.protection.outlook.com (10.13.177.53) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4778.13 via Frontend Transport; Mon, 13 Dec 2021 17:34:33 +0000
Received: from sbrijesh-desktop.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Mon, 13 Dec
 2021 11:34:23 -0600
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Sean Christopherson" <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Andy Lutomirski" <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Peter Gonda <pgonda@google.com>,
        Borislav Petkov <bp@alien8.de>, <hpa@zytor.com>,
        <marcorr@google.com>, Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH 0/4] Create multiple save area for SEV guests
Date:   Mon, 13 Dec 2021 11:33:52 -0600
Message-ID: <20211213173356.138726-1-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 881bdfe5-6ba6-4152-7c3e-08d9be5ed370
X-MS-TrafficTypeDiagnostic: CH2PR12MB4648:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB4648773DA4A16ED0A7E9BD5EE5749@CH2PR12MB4648.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DlTxeILy/tU9UB3B6YQvbeJurlr13g6Ylj+yl0Z1vprOFTldOFTXClxCgLLJGoRggfLw4F350F1D6xWdnnoN3HYc7t2tGqu19dsoZEkamRSXi2fHNeFa7buJA+L7WNC0tHQ2t6OMNiry0B76Nn30jOG1dCQpsZep56bIM26XpZq9+IhNP2oJkKQl2nSj5Kbz+rwRrq/WUhO+ZkpUngcRo91hsO9JLkHU1f32Tc180P7c7o26rkqps7sY2vWj61Uo0PH0wx7n2gJKOtnk931uKSkDd2lHc0X4n5ja3cfBrwwVXNWsVsUyaISANBH7o0X+7xt3nB/WiNfSlYq++39vjAL1DsN2W6x83iGy4YCGaqvAVKsWb47ZkUroWalLVgzLmyRWIb4oqRw8GxROFK0uJaS//CChhFvgLBC41jXbdUZXlwMfwURlbcG1hQzJoY3LSKC4MfZMsG57EHwVwNOZ2t7Q5vshvzirmAny+xIo22Tkx3cLr3jrnDiordINOl/fVLg+pD71wYynSK4shvqdvhiaNNOVaV7XVwlvlAR6n/mc7NYYck7nCKJrWQEenwafTAzYBM5dO2pXdFaMXSA4ViB9w2S3mAJqPFokMv3XDV1pTQ1yMoY3bL8xEKtt2RS+3hsAh8D90JjiNuBK0zjIfT7nJejKpBMF5PlVJ9oRN19tUFB1QjXSA2wW1zxFW2gU+r2kBkNlGMs9TXwN5GX910TptwERSI4ftLUSmo7PDTjfQTAJwEIh0SzDyTE24eGRFBUE0zoa34wwrwV1OdzQBMfcVajBmk2w0v11VMCOlGr8amBXP+5WyqXEfhiJJ8b+EbJ9ZOCfK4c9nZSCWO8y/G1AfJVJ9G8sgmeEYo3pUjapkoL0r4cjOGId0Isg4YLa
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(316002)(336012)(54906003)(81166007)(70206006)(2616005)(36756003)(6916009)(70586007)(4744005)(1076003)(5660300002)(47076005)(86362001)(7416002)(8676002)(26005)(16526019)(83380400001)(44832011)(8936002)(82310400004)(2906002)(4326008)(356005)(36860700001)(40460700001)(508600001)(426003)(186003)(7696005)(6666004)(966005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2021 17:34:33.2769
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 881bdfe5-6ba6-4152-7c3e-08d9be5ed370
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4648
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The patches in this series are taken from the SNP guest series [1]. It defines
multiple save area as needed by the SEV-ES/SEV-SNP guest and adjust usage accordingly.

No functional change.
 
[1] https://lore.kernel.org/linux-mm/20211210154332.11526-21-brijesh.singh@amd.com/

Series is based on kvm tree:
 1c10f4b4877f (origin/queue) KVM: SVM: Nullify vcpu_(un)blocking() hooks if AVIC is disabled

Brijesh Singh (1):
  KVM: SVM: Define sev_features and vmpl field in the VMSA

Tom Lendacky (3):
  KVM: SVM: Create a separate mapping for the SEV-ES save area
  KVM: SVM: Create a separate mapping for the GHCB save area
  KVM: SVM: Update the SEV-ES save area mapping

 arch/x86/include/asm/svm.h | 171 ++++++++++++++++++++++++++++++++-----
 arch/x86/kvm/svm/sev.c     |  24 +++---
 arch/x86/kvm/svm/svm.c     |   4 +-
 arch/x86/kvm/svm/svm.h     |   2 +-
 4 files changed, 163 insertions(+), 38 deletions(-)

-- 
2.25.1

