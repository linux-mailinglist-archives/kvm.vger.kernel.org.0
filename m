Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF51C5FCC24
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 22:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiJLUjp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 16:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiJLUjn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 16:39:43 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2079.outbound.protection.outlook.com [40.107.223.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 029311055D;
        Wed, 12 Oct 2022 13:39:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UlfTvTGRpNUF7msbyeFeveF3iJFPNxBivOjSMlwGYyFFrcuPX7ExFvrmPQClhLb+MlZCwrvas4xq+Nl6Vn5WYGNCyf9+8zpQrHwLBOj2+EQuAwDf3nfrlVCvPu6kqrryTdVrEASaEOpxPzsdspzObvJwiBVxgV541+1lk1SQFbbwwvBA9GLEdHOc037lOeLRJkRR0IpcrKgGgvhTm/2a+NJ6MgW0XU0EwiqcQC04Mz2PJRBg/B0jZ7dP3MtY2qVumQFuXZL1Md9gj/da4EgtQR7pfU6At6tyjQQezBWTd9eKJNHoSXGTheW8qy4q1++hgiY3C5U/TGnGH8jXYqcXTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rDy5XdG2giXsnsxTWpLkGrzfVfU/n2Cjvtls/vxEdYg=;
 b=hAiVhp8qvUvnqAI2nOO8kzGL5VapMkzMSbXKmOmSrqDYQrXNqO1cjGzpWSxiWW3nF97rFDiS718zIqUvQ4JXe2z8dwu3HiEUFgEfBttcsMlKHvkpR4UbqvzetgyVeYcCZ3yq506e+5Cp5wHMOgzWBHWXKX7svzeMk6sy9pfBbeO49dzVysuTgE29AAwBV659m/ZK79IAyAzabjsLP3O7t0kaBV2HtjlwRAUuRMQgdoJML/zsMjBE3A3UOfIS/8Cf8khvEETD/r92zPKyXkG0H1bwvUYt0YiZ0flbQHQny+Qixo2hCJl+JpXIa55+dVgszYHW6UR0txJ5FAjcEhG3mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rDy5XdG2giXsnsxTWpLkGrzfVfU/n2Cjvtls/vxEdYg=;
 b=WaXkQx+xue87lZ8RB2CGtQhKydO5xVXoY2jd9PMHyo9uBz7NFxBtZNXBUzln56uFUbe6OjnJy3PG8WwgO5775LI8bGO2QoFqMPeZHIRi5M6ww46S+ypPwIxUIQsLdGskuHXpq9HUJBp/TJyNNyq58Ln7lXgom9iyxHrB6N9MZvk=
Received: from DM6PR03CA0011.namprd03.prod.outlook.com (2603:10b6:5:40::24) by
 SN7PR12MB7023.namprd12.prod.outlook.com (2603:10b6:806:260::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.22; Wed, 12 Oct
 2022 20:39:40 +0000
Received: from DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:40:cafe::91) by DM6PR03CA0011.outlook.office365.com
 (2603:10b6:5:40::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.21 via Frontend
 Transport; Wed, 12 Oct 2022 20:39:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT033.mail.protection.outlook.com (10.13.172.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5723.20 via Frontend Transport; Wed, 12 Oct 2022 20:39:39 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 12 Oct
 2022 15:39:38 -0500
From:   John Allen <john.allen@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
        <seanjc@google.com>, <x86@kernel.org>, <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
Subject: [RFC PATCH 0/7] SVM guest shadow stack support
Date:   Wed, 12 Oct 2022 20:39:03 +0000
Message-ID: <20221012203910.204793-1-john.allen@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT033:EE_|SN7PR12MB7023:EE_
X-MS-Office365-Filtering-Correlation-Id: 8274820b-437c-43ce-a469-08daac91e29e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A7SYQGe17DRcOgRL0SzZqv6RPkXIJHzT337sDCaYOhc9ktg2ZRhiUNJ3aLL1oaFvUUsbrA2DaNFevmhe35KGR3srJh4MO/tqdxFG6lLLIqLotjzZu8X3v991sTCmgY6sa90nueXCrF3I1vuHLHk7i4TrYrA/ay8vJ33HxUBSvaGqSkTegOWYEEfOErrPgaQPiF0qSAhYkxeOE/hE64urWGL/gQYaxLlCyP29ksvg4AvlD/93Jl9XiX/qbAo4BSGnZcvEqMjm9lNMJsAiHBMvtnCGf6f6OXuu+db5RQXdl5j5q50nJDhEhvGot1suwvRNuYxPbeispExUy+4Ko0ChxYl/BqykF+m84CV0UWyfChVuLkl+3oakBlCHF6qG1no2QtOitJHpj2NM7Bs3ppcPEuxi+qI8wtwmNig3l+Qf3QdR6x0O36F5KxRuOv8l0SLAP3QVNmgcC0uRaXoUvwcRp4FdvRxKa/NbFgrDS5ATRoYXw7xzH72Wh/U6TFuO6lOm5eJqIxb345DR21nziohV50V94a16o09vSGQm9eNUZ35WpzNkBKgAHsbjfKx42fS4S+KAEOEE0E6tFvr0KYg7WWj3ClVm7wBpu4VeHp+YWQaiMvKCVV1hLomAp3gkTAFkPMh1yOthm1TjRC2NxUW/5wSIo8lKxnwAfPFIrlZ1MAAsM+jaDY0l67qdkZlGZtq8lGG1EX+xxnwRv6bub7viI9FTBxVp2FqY0cdXWCYb/po7+50vD+DJO4WjsLpj0ANayl+oJ9QaVtU9lexKbrAYZpGNAKL/4a/orucVbI2VqMfdeqojj0MXVj8kVhyq0Y+hyRujBDcWdvvBAhZEuS6F/jsoNTTRN76L5wbLlOnkb71zxvcgGsnqyTmGrIlHmb4i
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(136003)(396003)(346002)(451199015)(40470700004)(46966006)(36840700001)(26005)(316002)(82740400003)(81166007)(356005)(4326008)(8676002)(70206006)(70586007)(36860700001)(86362001)(40460700003)(36756003)(40480700001)(82310400005)(83380400001)(2616005)(7696005)(6666004)(54906003)(478600001)(966005)(8936002)(2906002)(6916009)(1076003)(44832011)(426003)(47076005)(336012)(186003)(16526019)(41300700001)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2022 20:39:39.7848
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8274820b-437c-43ce-a469-08daac91e29e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7023
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

This series adds support for shadow stack in SVM guests and builds upon the
support added in the CET guest support patch series [1] and the CET kernel
patch series [2]. Additional patches are required to support shadow stack
enabled guests in qemu [3] and glibc [4].

[1]: CET guest support patches
https://lore.kernel.org/all/20220616084643.19564-1-weijiang.yang@intel.com/

[2]: Latest CET kernel patches
https://lore.kernel.org/all/20220929222936.14584-1-rick.p.edgecombe@intel.com/

[3]: CET qemu patches
https://patchwork.ozlabs.org/project/qemu-devel/patch/20201013051935.6052-2-weijiang.yang@intel.com/

[4]: glibc tree containing necessary updates
https://gitlab.com/x86-glibc/glibc/-/tree/users/hjl/cet/master/

John Allen (7):
  KVM: x86: Move shared CET routine to common x86 kvm code
  KVM: x86: SVM: Emulate reads and writes to shadow stack MSRs
  KVM: x86: SVM: Update dump_vmcb with shadow stack save area additions
  KVM: x86: SVM: Pass through shadow stack MSRs
  KVM: SVM: Save shadow stack host state on VMRUN
  KVM: SVM: Add MSR_IA32_XSS to the GHCB for hypervisor kernel
  KVM: SVM: Add CET features to supported_xss

 arch/x86/include/asm/svm.h |  1 +
 arch/x86/kvm/svm/sev.c     | 25 ++++++++++-
 arch/x86/kvm/svm/svm.c     | 85 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h     |  2 +-
 arch/x86/kvm/vmx/vmx.c     | 32 ++------------
 arch/x86/kvm/x86.c         | 26 ++++++++++++
 arch/x86/kvm/x86.h         |  2 +
 7 files changed, 141 insertions(+), 32 deletions(-)

-- 
2.34.3

