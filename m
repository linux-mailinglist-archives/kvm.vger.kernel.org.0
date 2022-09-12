Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB3795B558D
	for <lists+kvm@lfdr.de>; Mon, 12 Sep 2022 09:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiILHwf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Sep 2022 03:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiILHwe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Sep 2022 03:52:34 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2063.outbound.protection.outlook.com [40.107.94.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78FB320BF9
        for <kvm@vger.kernel.org>; Mon, 12 Sep 2022 00:52:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lqsED0T5D1zUucJkpCfmUtd6Kr0iCKPkOVr99mjfQa9ATk6ygfn6LhT6MUiiUDvRA5XcUzX8oGupujLtoJ/FbvKeL1bJGX0Z21djMxxnsNH2UIpZ/qspvACJxhBraf7rK5TbNzILhWX2MoH/lzg5nqRpZi4PrPSxVm2dnktXnXy6j6kA+I2bsMgYT9UzewbNRjX8NntcM/tvjjPhSKggxc3aD6NC+fIoJvH0zBVNUjLC1wbT73v04W2HUqXAKL9+o2C53cUt06NdGSyF+o72NtfJp496K4HxicmNyPoX1jnFQAlk3UPlh36UrjvGDAqQ+YoXcAiWoVulrE4u4Zksew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BweyDEVV6ahBr0M0FrfQUZcJATKyKqjO7adECLw7slw=;
 b=UbS1e6O0VbeK45bHFkn+Y+tsyTwaTJ1G79gQpRu5qFpCWjaKZB9notYC1lbhggMoi6RWkzgD9JE+rrXobK0W7NMdazwkmjE2RGQbH0GbPLJ9QtCiWKdRZz9qgwjmR1MFtA4+SlNbNBMcKPLblSJBjUs5Q6kFCIBw9ayzUPlX2+VCEHht1z/lYrhVsflYWn6b9s3YqcB23KNryor+Qcx2bBu+aNb2OfggyFgYJC94yyDsuBxxcA7cUeUIJ4iRH9NBudB7b0aFw9zMkSMhb0U27rnhE3TkLJFwyasJx4PKVqbM1Ss8PH2mkGue4dMp7DYLsbxxd8Dcj7GHwTlH7kgKTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BweyDEVV6ahBr0M0FrfQUZcJATKyKqjO7adECLw7slw=;
 b=ZFH/A2WwevIkcVPRo5xUXUgYxlFCH538Q1XPv4hOrXkeI1Nr2etJjx48xLWpmADm32EDSeUmV84VHLNwmWYpou46a2yt/UQm5pGjWNrsKYnV08mpdgG7QFCRpsOCqn7vsdAlIVkdUrPfbFeZjGsw2RBmcyK8lNuRCfZJpkRTV5Y=
Received: from DM6PR02CA0076.namprd02.prod.outlook.com (2603:10b6:5:1f4::17)
 by CH0PR12MB5313.namprd12.prod.outlook.com (2603:10b6:610:d4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Mon, 12 Sep
 2022 07:52:31 +0000
Received: from DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1f4:cafe::74) by DM6PR02CA0076.outlook.office365.com
 (2603:10b6:5:1f4::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14 via Frontend
 Transport; Mon, 12 Sep 2022 07:52:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT033.mail.protection.outlook.com (10.13.172.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5612.13 via Frontend Transport; Mon, 12 Sep 2022 07:52:31 +0000
Received: from khorne.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 12 Sep
 2022 02:52:30 -0500
From:   Alexey Kardashevskiy <aik@amd.com>
To:     <kvm@vger.kernel.org>
CC:     Alexey Kardashevskiy <aik@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH kernel] KVM: SVM: Fix function name in comment
Date:   Mon, 12 Sep 2022 02:52:19 -0500
Message-ID: <20220912075219.70379-1-aik@amd.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT033:EE_|CH0PR12MB5313:EE_
X-MS-Office365-Filtering-Correlation-Id: 24d75549-8a4f-4b8a-1b42-08da9493bf61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XgaErZHPYYe/MsQc7dWfXCQCClS/CzlK8uN8gXcLwJM95ouwX6yUnQUfRtB2fdj0rQmo5KEs4+K0snBGaf6xQ+yT/Pgg8HSA+zLKzWIWHkRQAyLY0leDKyGsdO1FTGirXQ/0ItppcEEr8a9MVq83S2qet9eTasjgucrbYhfuJHz9CmG0CTT/YqLLEPb2l7FxLTevhCCkd470E6/8iirSovbnffMl2AnHcm9xOzUJE55DZtYf1nx8ODy+dWdxD2uaZH0rucZRX04+TWXO5QUyr/JtLJuT4OZ0C2VrDY0RC5NtIVTxsqIua/yyv6v0jKNHnh4K9zY5j1QP6clcGZaSZOlSgbJM1zC4tj+uAX1U9fENM8VY0YXe5XnM5S5R8VK6CDBCdu38hr5ePgmAiCkWvMb+2eDsaQIBTM5YhXfGw+660SpBe2i2LwLN/dN8Nk2Uh1s6naQSZOcoWJceYxINq1MdApcZHwD/+yqI7UuTJSvQ3ZrCHQ3jGmasAbi3fpZ3L+on45y9HtJ7bkV8j+Bl9MBitJIuljq4j5KFSQJNJUjLkRuRABscZ0MXL7rLytopKv84udNwgTwOQiZrW1TDZbyt26PXbZBxlIMyN0sQOnSLhX70wG9H0laIWe5JVF253Swkp1mi/a7NjJoCz0qBas8CWvjY8GD6nALcEMBXbOmTgwYTDeTYOelacstes5XE2KYzhTvjfWeafma9yx0yrzIpRbiPb3TK3e+YQqNGmIJS5pFnO5lGWGlvlr2sTE7fsxAAuKOylKHl0Hk/LT3EjUpx3hZKqREmGYGDycwRKxk=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(376002)(136003)(396003)(46966006)(36840700001)(40470700004)(7696005)(478600001)(41300700001)(26005)(83380400001)(186003)(2616005)(426003)(16526019)(47076005)(336012)(1076003)(8936002)(5660300002)(4744005)(40480700001)(82310400005)(40460700003)(2906002)(6916009)(316002)(54906003)(6666004)(4326008)(70586007)(70206006)(8676002)(82740400003)(81166007)(36860700001)(356005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 07:52:31.7168
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 24d75549-8a4f-4b8a-1b42-08da9493bf61
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5313
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A recent renaming patch missed 1 spot, fix it.

This should cause no behavioural change.

Fixes: 23e5092b6e2a ("KVM: SVM: Rename hook implementations to conform to kvm_x86_ops' names")
Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 arch/x86/kvm/svm/sev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 28064060413a..3b99a690b60d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3015,7 +3015,7 @@ void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
 	/*
 	 * As an SEV-ES guest, hardware will restore the host state on VMEXIT,
 	 * of which one step is to perform a VMLOAD.  KVM performs the
-	 * corresponding VMSAVE in svm_prepare_guest_switch for both
+	 * corresponding VMSAVE in svm_prepare_switch_to_guest for both
 	 * traditional and SEV-ES guests.
 	 */
 
-- 
2.20.1

