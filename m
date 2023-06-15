Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30180730F85
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 08:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243102AbjFOGjX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 02:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243895AbjFOGiq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 02:38:46 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20622.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::622])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6565626A4;
        Wed, 14 Jun 2023 23:38:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pr3cU8R1VNHsJJH6un03a4K6FU0Adodzo1rjJfj2fa0gEpYWJoE1q9RZ95R9FTd8Eq4BKwFMZV0TfeicOLPhwskDKdNY6Gu7USLFmyPpjEQPRndVicAtI/g7+IOgfJfY274xTqXDbodIcfoWg3y3XoSE+icxbbxF+WvHAGHkduL6/ElOpLunctXG1eDRMai+FYfuBoO9TyaU6o//TvuX6u77hE2DYhP98o6msdUX1UEFfJLPAHzCW8yphwHdhTb6668KLW6llNWx2LS56tT4dus8gfXK+6cy96SNXKl3KgXTLOPqpcwQwK0+2fAHKjTy3PjdpDzW/qRoiZmbakY9Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NkQmf6uQdkxeRWKxuN2je/sg3NJ1ggpUZAgHuCdyYpY=;
 b=au/vV0ciLi2Ifm606YaR/XlzeNN6PutHztsy+EWIpa/DqX61rQ5qbzCOozBAKl0UGDW/iSx4o8O3rdTKiR0g/YpWl06gsrUfZiSXNbiN/nl7jcsNhFXHIvgv0nPbRysQf0Is+HGEd6c5oqyBp9a1xynV66XrgyP5HBgpK9l9LKrnQgNn0YDtV7RLhQDkCJEUkszYat+D3lBDUSx79c1+wNp3mjVzForJiD4a/jxt8xO5g3e8Znr9+urhA9zVXRMjLo7ENqXbOjSrylb9cExsafOJx2AkOn6Fj7HmRxc8zVVsK+Wjn38Rqa3hl14sBQZ5osUO9JvF8vsqYSsb3UbJxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NkQmf6uQdkxeRWKxuN2je/sg3NJ1ggpUZAgHuCdyYpY=;
 b=VybFl6ZT29Ciw0vc4M7TYUvnrNXegAkGzDXCVovGPB1oc+GOpUwRg49eGdzwEtjdQR7FmoWF9QQh0GHc13bX7w5nsEs994wOwryCAOUUq0RnVYa8oSM6QBX7q91tgkD63Fw+2SZvcXWiuoO6fkfsH6IujBuwRufjt76de7f9jaY=
Received: from CYZPR19CA0022.namprd19.prod.outlook.com (2603:10b6:930:8e::25)
 by CH0PR12MB5265.namprd12.prod.outlook.com (2603:10b6:610:d0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Thu, 15 Jun
 2023 06:38:23 +0000
Received: from CY4PEPF0000EE3E.namprd03.prod.outlook.com
 (2603:10b6:930:8e:cafe::8d) by CYZPR19CA0022.outlook.office365.com
 (2603:10b6:930:8e::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37 via Frontend
 Transport; Thu, 15 Jun 2023 06:38:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE3E.mail.protection.outlook.com (10.167.242.18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.27 via Frontend Transport; Thu, 15 Jun 2023 06:38:23 +0000
Received: from aiemdeew.1.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Thu, 15 Jun
 2023 01:38:18 -0500
From:   Alexey Kardashevskiy <aik@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        "Alexey Kardashevskiy" <aik@amd.com>
Subject: [PATCH kernel 0/9] KVM: SEV: Enable AMD SEV-ES DebugSwap
Date:   Thu, 15 Jun 2023 16:37:48 +1000
Message-ID: <20230615063757.3039121-1-aik@amd.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3E:EE_|CH0PR12MB5265:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bd949f2-2fad-4d3d-9bf4-08db6d6b1e06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JrDhvqTrj7uy0Asl5BXgLrXZXUoWh1K2oftzc5sAe46hsJnRXITehQ8P7wUXolOJIZmfb+gZiC0KEUrPO/pLHd3y8tWtpNB0gGxmK5Vr/z7H648UhfAaqX4bqXg7x+raZsqrx8yEQUIlaPkqANmvwnGNO+V9VqnXiIwsIZeIeI2qLq97P5lNs1h2Y3bO/AahmDhE7axuvDfpZU75e+Q6ObOb+QZkpXyQS6ll8yYh/nheft9R9haQUfz2/G6ZcTe1mtwhv6p8kzqG8QzPBdHe0fMYA3G0PBj+yHxM8aElAYXhJYyiinDYzcso3ujQD1VcwE7jJP8aKSU+RHDp+/uvwccNYn+NPW0mGYWDltWbLKJvb3T1+483AfgMBSLc44aWV2src8nqcv3WZ1vZorKx4Fc8OzObl2aGN9vYcshN7AhQ/sPZxSEoTbEp/Q08UKeNcezulTqVTfzWqcmSLPjNokIgzMdcsUhzqUZ2Z7gbWW7IH3Cl4OId2CBlmkIV/GgfUw/z9Wr9XUDyzf4F2QBPNtMhAfbju+613E5NovUgIOPmbQ6MaTQTDDNHkNZZThq/p/xP6bm8+T0q1MVeP4GX6ChWd2lYcD1BtV+pNKkyXGPGQfuNTfMONgTt6edAVOY/Ey+QA3uZOcwVSO5Q9jWIKhO2BBvTFC3RjSyJ3XCSljL8wrq5DoQSkOi8yaVqTj7812+xxbRSgYteA7NF71kA1opHOyfLA5riloN1VVZnrKv/DeiDt3+NKZmLo+iV9Ntg7HxKzt7r+7m9O0S2Pgs9pMqRKPeSqC9HmLhp1MbWD1c=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(136003)(346002)(376002)(451199021)(36840700001)(46966006)(40470700004)(54906003)(82310400005)(8676002)(41300700001)(6666004)(8936002)(6916009)(70206006)(316002)(36756003)(4326008)(70586007)(40460700003)(478600001)(26005)(36860700001)(47076005)(40480700001)(82740400003)(5660300002)(966005)(83380400001)(1076003)(186003)(16526019)(2906002)(426003)(81166007)(356005)(336012)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 06:38:23.4797
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bd949f2-2fad-4d3d-9bf4-08db6d6b1e06
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000EE3E.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5265
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is to use another AMD SEV-ES hardware assisted register swap,
more detail in 6/9. In the process it's been suggested to fix other
things, here is the attempt, with the great help of amders.

The previous conversation is here:
https://lore.kernel.org/r/20230411125718.2297768-1-aik@amd.com 

This is based on sha1
6e2e1e779912 Ingo Molnar "Merge branch into tip/master: 'x86/sgx'".

The tree is here: https://github.com/aik/linux/tree/debugswap

Please comment. Thanks.


Alexey Kardashevskiy (6):
  KVM: SEV: move set_dr_intercepts/clr_dr_intercepts from the header
  KVM: SEV: Move SEV's GP_VECTOR intercept setup to SEV
  KVM: SEV-ES: explicitly disable debug
  KVM: SVM/SEV/SEV-ES: Rework intercepts
  KVM: SEV: Enable data breakpoints in SEV-ES
  KVM: SEV-ES: Eliminate #DB intercept when DebugSwap enabled

Sean Christopherson (3):
  KVM: SVM: Rewrite sev_es_prepare_switch_to_guest()'s comment about
    swap types
  KVM: SVM: Don't defer NMI unblocking until next exit for SEV-ES guests
  KVM: SVM: Don't try to pointlessly single-step SEV-ES guests for NMI
    window

 arch/x86/include/asm/cpufeatures.h       |  1 +
 arch/x86/include/asm/svm.h               |  1 +
 arch/x86/kvm/svm/svm.h                   | 42 ----------
 tools/arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/kvm/svm/sev.c                   | 86 +++++++++++++++++---
 arch/x86/kvm/svm/svm.c                   | 70 ++++++++++++++--
 6 files changed, 137 insertions(+), 64 deletions(-)

-- 
2.40.1

