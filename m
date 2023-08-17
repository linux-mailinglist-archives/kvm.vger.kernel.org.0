Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B777977FDA3
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 20:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354243AbjHQSTW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 14:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353884AbjHQSTT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 14:19:19 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2076.outbound.protection.outlook.com [40.107.100.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259DA2D58;
        Thu, 17 Aug 2023 11:19:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GyDxmOEvvnMTZeK0+9v2GCkZS+Jm33KQk5zFM9/LBtcjVlMQaJ+InMB9pK4Ijwwsz7M4sUBXQkRRu2BCdIynAeQiwj2vck9WR82Yzw2C23Keao8VgobG1t+nsr+uoFbHcCNxofJaVfkdtuIf5JcI5dR5g0kXAV7ChdTfKyer+SuamM26EQyc8BPVIhZvGL2+PzAG5QVMqETWuWNXEA3yJw4Z5hStg6evcmbGCshNDnu1lJKp+bjvy1lBxZt6rmf/BzpUL9UqjW5J/DZ06V6OUz5B8sv0+4Z4SY9fjyMKxLR50szt5lB7HONDSnc9LHJLGLDVzzXf/XD4ci8uQYRyKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lg+fY/TPZAKbhggrbz33jHVbwo7q85OxXIEkVMyi2fg=;
 b=XQCTHuCtQol0cbjLdQnkUXK93fylvEHHxC2IWQ9tG/DqGoChuNSZJxmQWoR52zG9BLHujqymyhMLsSaUozcJPvPVkBB1EhRz2jasUH8he2YVcbV2X2PAgTPiYSln8qLQ06Gxfp34WqgVZAq0bOezM4q4O76rnnR7pBQZT2qRaLBddbLS4UtD3KkcUYfdtP062C4bNy7RMA7moT2ASC2PipAUa+eOcjYXKQFhMlOZWL/Odxu807tRjRXISkP7f2Lgss1kXOjGkGj0a806Ic5zYLVtPSUXiLFjbbM1GJwiA0ccffwsTEJxYdz8UfMwep/zaLNnc+f2IIGfc2ENHmTcmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lg+fY/TPZAKbhggrbz33jHVbwo7q85OxXIEkVMyi2fg=;
 b=z5/OSUvX4A4N9lsoTx9BWnmHG5FHxHrut7UEFYvgqE4oKpptBn6K/TUejtTowtmcMY/8rGfD8XMkVPAiJ30NwQw95Rgts2iKFXwaPGPxb2ThDtirteU8hHXt9RbAx++83STmSq0OcXMusBFIVsY8sOuh+dWi+KoritBeErTwZEo=
Received: from SA1P222CA0029.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:22c::24)
 by DM4PR12MB6304.namprd12.prod.outlook.com (2603:10b6:8:a2::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6678.30; Thu, 17 Aug 2023 18:19:15 +0000
Received: from SN1PEPF00026368.namprd02.prod.outlook.com
 (2603:10b6:806:22c:cafe::6f) by SA1P222CA0029.outlook.office365.com
 (2603:10b6:806:22c::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.33 via Frontend
 Transport; Thu, 17 Aug 2023 18:19:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00026368.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6699.14 via Frontend Transport; Thu, 17 Aug 2023 18:19:15 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Thu, 17 Aug
 2023 13:18:55 -0500
From:   John Allen <john.allen@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
        <seanjc@google.com>, <x86@kernel.org>, <thomas.lendacky@amd.com>,
        <bp@alien8.de>, John Allen <john.allen@amd.com>
Subject: [RFC PATCH v3 2/8] KVM: x86: SVM: Update dump_vmcb with shadow stack save area additions
Date:   Thu, 17 Aug 2023 18:18:14 +0000
Message-ID: <20230817181820.15315-3-john.allen@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230817181820.15315-1-john.allen@amd.com>
References: <20230817181820.15315-1-john.allen@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00026368:EE_|DM4PR12MB6304:EE_
X-MS-Office365-Filtering-Correlation-Id: 9dec0118-55d2-4bde-cd35-08db9f4e771c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: myON7DmcchKfQb35OwW/kOwuYphmQCHoHiOiQEGaUp49kP/f3LkQRdo5+MOBjPRCQNTT5OhM938gAOMC8POVIFrsF2C4q6fGI2k4yrjTbNU3n3qnxt2pk6YsNaGqRMJXT+84g8jSYhRzfVYQfya6glcNk7iPeYwBdeUOPgQ+TdvSHriWpsPC2MnIWQPe4IDiWrlErQEiTGm8d1y5LZKpzU/NfmR8B9ADfiRX9pwpQvFjUL8WB3iz57vkUXhQ6SvbdKEC1Wy7DEVC+xl4WQ9kRgde3feUmTDn5yUhxO8fWiSQN8sfWNxKYQ7ATtFfws2jy8ic9vpedd2TbU7dqjBTAb417Jn6JGjPNkyo+xNjYwpr6Dy4l3s/rYI4i/5iqkEInSyg63tn+BGon65d4VDBX9wi1s0Xnl9YYqe0/ivXcwFBzNrTSoHGEu/IYamnVKrXBgtBP6YqfsCVYPLAa9/vJgaUmyDQQg8rUcr1ER1woYps2nuzG90PZi1HYhd90kJAAcFQtoIoCFmBa0SAE3cN10LrboLNMCTVBLGoH54F2bI0GgGXcJ0cRor91AOCsEhi/4i9Gink+Ne2SFL6jmx61MzJ4bCZVJX156dcwHQA/VA2EFqd2pPucrP6fh9c2JeMd4fgHNGjg5RckYTNrz0f6/ig9RRhobKIS4g0SkfxCKZfCinGER15B97UWfRmkBhxqRrdqqTRpluyGdrOUdewRRYlHTPK78b0mgu1ba9LdDlmkkXBO+4W7KfjglW+TasRJn560EaLGPxPtAuAUwaQ6g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(39860400002)(396003)(136003)(451199024)(186009)(1800799009)(82310400011)(46966006)(40470700004)(36840700001)(316002)(54906003)(82740400003)(356005)(81166007)(70206006)(70586007)(6916009)(5660300002)(41300700001)(36860700001)(44832011)(47076005)(8676002)(8936002)(4326008)(26005)(40460700003)(2906002)(16526019)(478600001)(40480700001)(336012)(426003)(86362001)(36756003)(6666004)(7696005)(1076003)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2023 18:19:15.7073
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dec0118-55d2-4bde-cd35-08db9f4e771c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF00026368.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6304
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add shadow stack VMCB save area fields to dump_vmcb. Only include S_CET,
SSP, and ISST_ADDR. Since there currently isn't support to decrypt and
dump the SEV-ES save area, exclude PL0_SSP, PL1_SSP, PL2_SSP, PL3_SSP, and
U_CET which are only inlcuded in the SEV-ES save area.

Signed-off-by: John Allen <john.allen@amd.com>
---
 arch/x86/kvm/svm/svm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 57864e83f634..1ac5b51c3f2c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3386,6 +3386,10 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	       "rip:", save->rip, "rflags:", save->rflags);
 	pr_err("%-15s %016llx %-13s %016llx\n",
 	       "rsp:", save->rsp, "rax:", save->rax);
+	pr_err("%-15s %016llx %-13s %016llx\n",
+	       "s_cet:", save->s_cet, "ssp:", save->ssp);
+	pr_err("%-15s %016llx\n",
+	       "isst_addr:", save->isst_addr);
 	pr_err("%-15s %016llx %-13s %016llx\n",
 	       "star:", save01->star, "lstar:", save01->lstar);
 	pr_err("%-15s %016llx %-13s %016llx\n",
-- 
2.39.1

