Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA7F525653
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 22:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358340AbiELUXq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 16:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358350AbiELUXp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 16:23:45 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2058.outbound.protection.outlook.com [40.107.237.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC23E25BA47;
        Thu, 12 May 2022 13:23:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YMvGtyTdy9WpMdK9bysnNdVx8uwf88+ydhMHutxHuGOrImvgXMAQMAoJ3opLEGNjdbvpIiARcyja5ftv9Y78uDyl8RSGg6XgRW4DZMOY3+n3LSJUDP/nLQFVajq8qt0Zx+dcQSBsqNfTwMx6dwak3m16l5c0N3UEQR93iWzbtb5rkbiP2XGwq+NTxUwazmZQ2+6DgtQJvWTQhe+14n1rAMBWit/Je86/1vN+se3ZECFdFFHnzOsyqyEhePNtNzk8O9R4izT0Q76E7QAGmwlMGnpJNU7FWLIX6biX+d/IHHiKomYMCCSdqN4Iy69zLsKPlM0HQuGFxC4LtfGF4J9Dvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=URb+jR8YpSJVIBqtQbIswBfHt/MxDCivTm9mMVgYpG8=;
 b=Zi5fJMhbq35k0YcS8LeAOFEoYJ0Og+jEaTPJ8ETX8tscFIaJG+HqnpFgbvn9qE1skjVHurNknt6PClPAXRIW6FO9XcYEt5IZW4y/1+l9O9p1ZN3S0hZfOYD2CBTDoxISdhq1jRhzyJoGr45Uev2+EKvXXkwcEZwXv9Zrcr5qUCyKcv/8yCkxOlIfVSaMHZJVa44NNXuEQFTcRjmrTsxGdoC5YjU0RlEigy5dNbUE3c296enRKv/u2lhNkNyCNVcfy1dYhoM7l7mnnfAnt8zDiuN6zyxppOft/eS+3q4NAV2RnNZ4kxVeH5bX0FJIcJnvua4Gofx8ViqXpXksaQW9/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=URb+jR8YpSJVIBqtQbIswBfHt/MxDCivTm9mMVgYpG8=;
 b=dV5rGdkYo1z56CoGlBB9vHNALOdIBLDSQJHm20G0EbpUnUqqsUeXJk3WxcCnI4MHXqSxWkVNhH/gULYlA8tKjdbAeSb067IrK4HHh7HC+b1r89BcftdlTeWhQK+mAIIEmWuapTUwNeo8PhiPJbXKpvAeoRgCAZL8kgTl0ot6Gsg=
Received: from MW4PR03CA0247.namprd03.prod.outlook.com (2603:10b6:303:b4::12)
 by BN6PR1201MB0020.namprd12.prod.outlook.com (2603:10b6:405:56::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Thu, 12 May
 2022 20:23:39 +0000
Received: from CO1NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b4:cafe::72) by MW4PR03CA0247.outlook.office365.com
 (2603:10b6:303:b4::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23 via Frontend
 Transport; Thu, 12 May 2022 20:23:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT026.mail.protection.outlook.com (10.13.175.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5250.13 via Frontend Transport; Thu, 12 May 2022 20:23:39 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 12 May 2022 15:23:36 -0500
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     <pbonzini@redhat.com>
CC:     <seanjc@google.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>, <joro@8bytes.org>, <Thomas.Lendacky@amd.com>,
        <bp@alien8.de>, <x86@kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <theflow@google.com>,
        <rientjes@google.com>, <pgonda@google.com>, <john.allen@amd.com>
Subject: [PATCH] KVM: SVM: Use kzalloc for sev ioctl interfaces to prevent kernel memory leak.
Date:   Thu, 12 May 2022 20:23:28 +0000
Message-ID: <20220512202328.2453895-1-Ashish.Kalra@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06114310-6f7f-47f2-27a9-08da34554d09
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0020:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1201MB002074DBB6058E08230C598C8ECB9@BN6PR1201MB0020.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mXBdkxjUByu26dcvWzAjwZJyo/C57S4hVSRpXkaX2Qq8TcnAqGpy2srmwukxSB577KezUoyCN/LM0teERZ5BVJPbtSwhFXryPdAOeupvfL0AoaYqxjFHGfDAN+jDLnb1/FFb0tSkv1DEaEaQfxoPHkvYjtvIqyaqlTaqSfKzSdvDr820UFsGAX67EuGVEoT7tXnqJgu/UyWGsdaEm5ah03jYIx0nP9yjDW44OD9LM/KT8jNuRQurSRzjh2flQMw4bHWWPBswcNZBJiSpvLsiQPzPLzbkONY7yT7EWZ6PkuclI+/WvQl+VlN5SkW0tWgUnqliDC5fCZnhk4zBWjIJBTqNiT5eJY/S96e/6kplgjhQ4uLzm6jSU8sFATzOKCuEP0Lcj49vf4oRrBddSuwp+LWtyGoD9to14RVIXqD9c6KWTVWzux8MKApAs3PwCl8X/XKyk6CXvNLfp8buByVMtJuejKP6lSbqJABzb5omdtM8Yr4eJt5ktvhdnCQovFx0jlzAKbBTGyKQUgTcSWW/NLvo9g4qTjfDZffV3HpvCWtWzDbAc7yKG0ixTtx5bxx/RmdC7Hfr77tXJFym8wHzxQBXizdA7+/WvUjE6BLIMWg+fA62rdoANjdfZQMMfNzd1ZDj+ANL0UJJyqgVCkWn2/Xi1ZtqGLYgo+C7jElX5ckmoG/q0MLYg3wwwyEXdeDDQZp8KjRQCQsDz4oENcUWig==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(2616005)(54906003)(336012)(36860700001)(82310400005)(1076003)(6916009)(70206006)(40460700003)(70586007)(8936002)(426003)(508600001)(7696005)(47076005)(8676002)(36756003)(186003)(4326008)(16526019)(6666004)(316002)(5660300002)(86362001)(26005)(2906002)(7416002)(356005)(83380400001)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2022 20:23:39.3938
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 06114310-6f7f-47f2-27a9-08da34554d09
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0020
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

For some sev ioctl interfaces, the length parameter that is passed maybe
less than or equal to SEV_FW_BLOB_MAX_SIZE, but larger than the data
that PSP firmware returns. In this case, kmalloc will allocate memory
that is the size of the input rather than the size of the data.
Since PSP firmware doesn't fully overwrite the allocated buffer, these
sev ioctl interface may return uninitialized kernel slab memory.

Reported-by: Andy Nguyen <theflow@google.com>
Suggested-by: David Rientjes <rientjes@google.com>
Suggested-by: Peter Gonda <pgonda@google.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/svm/sev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7c392873626f..d93dab5c9ce1 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -688,7 +688,7 @@ static int sev_launch_measure(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		if (params.len > SEV_FW_BLOB_MAX_SIZE)
 			return -EINVAL;
 
-		blob = kmalloc(params.len, GFP_KERNEL_ACCOUNT);
+		blob = kzalloc(params.len, GFP_KERNEL_ACCOUNT);
 		if (!blob)
 			return -ENOMEM;
 
@@ -808,7 +808,7 @@ static int __sev_dbg_decrypt_user(struct kvm *kvm, unsigned long paddr,
 	if (!IS_ALIGNED(dst_paddr, 16) ||
 	    !IS_ALIGNED(paddr,     16) ||
 	    !IS_ALIGNED(size,      16)) {
-		tpage = (void *)alloc_page(GFP_KERNEL);
+		tpage = (void *)alloc_page(GFP_KERNEL | __GFP_ZERO);
 		if (!tpage)
 			return -ENOMEM;
 
@@ -1094,7 +1094,7 @@ static int sev_get_attestation_report(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		if (params.len > SEV_FW_BLOB_MAX_SIZE)
 			return -EINVAL;
 
-		blob = kmalloc(params.len, GFP_KERNEL_ACCOUNT);
+		blob = kzalloc(params.len, GFP_KERNEL_ACCOUNT);
 		if (!blob)
 			return -ENOMEM;
 
-- 
2.25.1

