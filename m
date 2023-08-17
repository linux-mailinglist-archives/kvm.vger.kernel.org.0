Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C552E77FDA0
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 20:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353192AbjHQSTU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 14:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353326AbjHQSS7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 14:18:59 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA3C82D5D;
        Thu, 17 Aug 2023 11:18:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nGxhvGSV7aNI6JN7rr+F4vYItkC+kmY5NQ7AOcMivUdiH6dCvt0RjtcQK8cYemnUYAegMPTfZ7O3DQoELcs/7kXTt95yMfPpT5kvVtL18BZAzOVF5gAixRdckPJqKzYVpun1gcmclqPbpY5YXQozU2TWn+mI3JKVu/BJTwA//NuvpstvTdrauvXCk7B4caX5IylBHRhno4kMCc8sR3iYyZTYm17iXIQ8QIQTVRYAQKHX6Jog0eFq819khULL8JL8R9oXpJmwkZisS24lmp3Jkf1vx6pNagowO1qTNzaUUeOTsDZVWrlB8fzudEDmNZxY4qN4NtWykZZQzdde6+AINg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kK2e/KnsfUt3rgaZKJSaeHztWbsANhBex6yVa/HrobU=;
 b=fFTFAB7+z8hORSigOehCTqGWw7g+pZ4rnglMMYqTmgxgeadeJ+WCL8WAcHjDGmoApngAjKWNvHZeX/gRCbUGPkEGrMhxDLI1Fn8UCV4EdYSCGyv6c4ATUJTDVSN+L3p2CGed11jOSDQFJ7oRsf4EGPOryd50JhA4M3QvNZmgg8CGmUtxljBSTY7Y05P9xGsLn9oBxE0hBvrFMhhvvfT3gtGnFnZBs8UgYDUQt3OWQI0E+TDnyL1rIm23ZOAsH208sgZhRDELptRGmc1sjnCF/bNLuZB2eXrvUXoLV5P9UsME8HvhmWNe4PrImru1VZk/vTHNdl20l9EWR6PM0pNLHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kK2e/KnsfUt3rgaZKJSaeHztWbsANhBex6yVa/HrobU=;
 b=JNLw0JJmgrWQAmZsIwPDnXqU7qq+nUx+lp6zBF8K6km8gaEGdL310kZnHQ27xlbt6TXplHxRaozHHQYjEHqh9tWz04cxl6gQQXUOAQRbp2IZANSq+kYbHkFf8yZ/sHDGOdl3Yyl9UTQbQQQDl8A0EU9bVr1tZwmZTPbhQyOevE4=
Received: from BN9PR03CA0304.namprd03.prod.outlook.com (2603:10b6:408:112::9)
 by DM8PR12MB5432.namprd12.prod.outlook.com (2603:10b6:8:32::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.31; Thu, 17 Aug
 2023 18:18:55 +0000
Received: from SN1PEPF00026367.namprd02.prod.outlook.com
 (2603:10b6:408:112:cafe::bd) by BN9PR03CA0304.outlook.office365.com
 (2603:10b6:408:112::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.17 via Frontend
 Transport; Thu, 17 Aug 2023 18:18:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00026367.mail.protection.outlook.com (10.167.241.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6699.14 via Frontend Transport; Thu, 17 Aug 2023 18:18:38 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Thu, 17 Aug
 2023 13:18:32 -0500
From:   John Allen <john.allen@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
        <seanjc@google.com>, <x86@kernel.org>, <thomas.lendacky@amd.com>,
        <bp@alien8.de>, John Allen <john.allen@amd.com>
Subject: [RFC PATCH v3 0/8] SVM guest shadow stack support
Date:   Thu, 17 Aug 2023 18:18:12 +0000
Message-ID: <20230817181820.15315-1-john.allen@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00026367:EE_|DM8PR12MB5432:EE_
X-MS-Office365-Filtering-Correlation-Id: a35e3f5e-cf79-486d-4b9e-08db9f4e6ad3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ic6TA+1ur32Dbwjth7dTKHE3N0yevYlqLfiJGOatiXGfucZ09kw3ftpgl4J0tp4JwQ89jDPftH024kqrk4DNuYa1QetXtRvtumjEM9TeMdBIM0VX+x36TBVBZmhHpILlkgtpAKwy3+pCKaJ0aSLTGtY2CmWh1lt9GLgetQUz0Ls/xQRhq3nqJWyfIk/tvVOMpjc3SY5+aTmqwKnu+bsJRFLwcAta3fLOcKJfvGPsKiQg8zW62bsv9gMoSUHWQmNnHZg96J49aXRlCCFFFwAThj+Cq56sgRfQx/3TozTP9Q/lO39cmVZAxhZ3f07UC4V0cC+DAztXZaC5oWO5DqIWCoMZZ3yDVgQ+dHFqyTWqsMCflN48ehXVliYAoI8rjeG9+TryTfA5/lk3cY4092kh8Te4iWC4rtHjsBlgP79Pn8BHYKKcgOTcGOBP5Bi6/MC64rKfff+ZVzpYggU2EX+/gfsEtzPL1SdnKSgLJYHGcExzSoZFcsntNzfClf3Bsdop5XR9EkUz2hI6sJQpqf8/rRESRIVg0XiKOtsoTObGBf22YvBrj5SWn+AJft94QCOr5DpF+yNsuSi0UOe3Pl1idnahbbqWzHvvSGwDGa4peuoZnqoltN5s4WQtt6xzAPoq0pGc6XE980Z0ZhtV6dy0qVR5w6o3lcMGkw+wFj10GhroVt82S3Ykp67l2B6YJSbv6jJjhpJUaz8neXEYTF62ot3BybXpe4KoiEIB6QBmf2hT2bgPZ4BHjF3Xbq3J2KDFgL2V6oo4wh2S134nZWAWRQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(136003)(396003)(39860400002)(82310400011)(1800799009)(186009)(451199024)(46966006)(36840700001)(40470700004)(40480700001)(40460700003)(47076005)(426003)(83380400001)(2906002)(336012)(36860700001)(70586007)(478600001)(70206006)(7696005)(54906003)(6916009)(316002)(6666004)(966005)(5660300002)(44832011)(16526019)(2616005)(8936002)(41300700001)(4326008)(8676002)(26005)(1076003)(86362001)(36756003)(82740400003)(81166007)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2023 18:18:38.7958
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a35e3f5e-cf79-486d-4b9e-08db9f4e6ad3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF00026367.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5432
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD Zen3 and newer processors support shadow stack, a feature designed to
protect against ROP (return-oriented programming) attacks in which an attacker
manipulates return addresses on the call stack in order to execute arbitrary
code. To prevent this, shadow stacks can be allocated that are only used by
control transfer and return instructions. When a CALL instruction is issued, it
writes the return address to both the program stack and the shadow stack. When
the subsequent RET instruction is issued, it pops the return address from both
stacks and compares them. If the addresses don't match, a control-protection
exception is raised.

Shadow stack and a related feature, Indirect Branch Tracking (IBT), are
collectively referred to as Control-flow Enforcement Technology (CET). However,
current AMD processors only support shadow stack and not IBT.

This series adds support for shadow stack in SVM guests and builds upon
the support added in the CET guest support patch series [1]. Additional
patches are required to support shadow stack enabled guests in qemu [2]
and glibc [3].

[1]: CET guest support patches (v5)
https://lore.kernel.org/all/20230803042732.88515-1-weijiang.yang@intel.com/

[2]: CET qemu patches
https://patchwork.ozlabs.org/project/qemu-devel/patch/20201013051935.6052-2-weijiang.yang@intel.com/

[3]: glibc tree containing necessary updates
https://gitlab.com/x86-glibc/glibc/-/tree/users/hjl/cet/master/

---

v2:
  - Rebased on v3 of the Intel CET virtualization series, dropping the
    patch that moved cet_is_msr_accessible to common code as that has
    been pulled into the Intel series.
  - Minor change removing curly brackets around if statement introduced
    in patch 6/6.
v3:
  - Rebased on v5 of the Intel CET virtualization series.
  - Add patch changing the name of vmplX_ssp SEV-ES save area fields to
    plX_ssp.
  - Merge this series intended for KVM with the separate guest kernel
    patch (now patch 7/8).
  - Update MSR passthrough code to conditionally pass through shadow
    stack MSRS based on both host and guest support.
  - Don't save PL0_SSP, PL1_SSP, and PL2_SSP MSRs on SEV-ES VMRUN as
    these are currently unused.
  
John Allen (8):
  KVM: x86: SVM: Emulate reads and writes to shadow stack MSRs
  KVM: x86: SVM: Update dump_vmcb with shadow stack save area additions
  KVM: x86: SVM: Pass through shadow stack MSRs
  KVM: SVM: Rename vmplX_ssp -> plX_ssp
  KVM: SVM: Save shadow stack host state on VMRUN
  KVM: SVM: Add MSR_IA32_XSS to the GHCB for hypervisor kernel
  x86/sev-es: Include XSS value in GHCB CPUID request
  KVM: SVM: Add CET features to supported_xss

 arch/x86/include/asm/svm.h   |  9 +++---
 arch/x86/kernel/sev-shared.c | 15 ++++++++++
 arch/x86/kvm/svm/sev.c       | 21 ++++++++++++--
 arch/x86/kvm/svm/svm.c       | 53 ++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h       |  2 +-
 5 files changed, 93 insertions(+), 7 deletions(-)

-- 
2.39.1

