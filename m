Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28A7E63E7BE
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 03:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbiLACVE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 21:21:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbiLACUh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 21:20:37 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2051.outbound.protection.outlook.com [40.107.220.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6989AA06DC;
        Wed, 30 Nov 2022 18:20:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JxuX11oGnIczeVXarRuWs7JXjyTYc4NicDst4aJ5lT2VY0CDMXweEnqhC2nd9o+e27LKsaAXElGR+X027CJPvibBHYAaEu0ynlN794YNuCwcFI7rMX5c13Ltbe/nIgPhY7/aHC2itUqbdefdhQXdkDjRpeomYhrGoIdmudWBgyhdcT1hwPlJLFmo5jBQ7DijWBWiKXXHuDRfBBvVGRCyFFARPU36B8MgghtA0mIgvj1rpMJc196IhNni3ovqou0APGxsEw4h9jraWnEOiEMNQauz581Thh2FfavC8g9vieIF70wJ8fnE/X2YuVUswT6D6TmBuVMDFQjpbEhHJJvsYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+bYxR5yuYLYrclHRyGyxdxA/JKX5ptamh41JFPYIPXg=;
 b=JuxqPmhH2CQrlC6MiPxFkYI+ja1Jfn3PV6JHT2ZgUoDZMOTNWV0OguGVRDOpQ7lpHjXjMLlqacar4tTjx0ZqFQMzOKPUAtqufbBp9HjHvF3BCb5hkxYovZVIt64lXQDp3VAuUstvllPYe8kCVASHP1xERr21l7lDTYXEUJAcsvCi+5uHp1Yn4Cjuz1A5xtS8ryAdW9Lr2B2oUGWt6pZW2Bl7pB42C105X4gIbQLP1ZxdRCzO6Zj/UVI7pZxo73tXiu8rbGTC30lL1NtJWqriL1vaQu+het5EzuxeCV2EmQw0Z6gxy683XbhJ0aZhrVO9vpv3HFkU+ZpYk04I7EUsKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+bYxR5yuYLYrclHRyGyxdxA/JKX5ptamh41JFPYIPXg=;
 b=qFUvWYAY6cSi3bztTjO+PUx50FXCubAdvkaiaRscaLEQKHTajFiDTKP5C8ctmH1sJJhJOvfHHyvGrxkJgtmfwAiTGDJ2iNqap5ocNrOsOtcJbUKqqc57jRmf/u9Zj0/0kUMxZ4e5EPSIE1DyKUGVkT9CqOsKejWQ6/ozgYaLy00=
Received: from BN9PR03CA0331.namprd03.prod.outlook.com (2603:10b6:408:f6::6)
 by BN9PR12MB5384.namprd12.prod.outlook.com (2603:10b6:408:105::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Thu, 1 Dec
 2022 02:20:21 +0000
Received: from BN8NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f6:cafe::c2) by BN9PR03CA0331.outlook.office365.com
 (2603:10b6:408:f6::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23 via Frontend
 Transport; Thu, 1 Dec 2022 02:20:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT053.mail.protection.outlook.com (10.13.177.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5857.22 via Frontend Transport; Thu, 1 Dec 2022 02:20:21 +0000
Received: from aiemdeew.1.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 30 Nov
 2022 20:19:59 -0600
From:   Alexey Kardashevskiy <aik@amd.com>
To:     Alexey Kardashevskiy <aik@amd.com>
CC:     <kvm@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Sterritt <sterritt@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Dave Hansen" <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        "Andrew Cooper" <andrew.cooper3@citrix.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH kernel 0/3] KVM: SEV: Enable AMD SEV-ES DebugSwap
Date:   Thu, 1 Dec 2022 13:19:45 +1100
Message-ID: <20221201021948.9259-1-aik@amd.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT053:EE_|BN9PR12MB5384:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ead1a0d-c20c-4531-4be3-08dad34298bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fX8GqTZwHf9deCj86gvtg9oc2CHO7pZLs9Eu+co17aQL8URxBmlD1rIc1twnL2w6b4JqPRwDfEOZY965OkISYslRUY6/0M8juXV06xJxKYzt38HerV/KweWnApBCBviDHIOuf7sQiW8M633HLJysk2+JYBZATtu4ZztkatPNLJDwLfCdxVcLUsgv5KBY++7MY+aY2kxujAFZi+5uRQVH96uU1SblAMv38djKcsWJ+QRAamfOTlmOSmgkp8IQ4+T/sDxLrcxqHmjQ6nXhQDP42h0v/AoWOeG0jcZIS+jGMquHgdLDzUkPIJT8NbtGdKdoM2dv67ttG6f7fdTLz1zmSrmCtnHWvWmsVXcL4ByV+jdiO/kcNlMWtnLHlZQ6wYnMDyRW9O8M7OpO5oO/qbcBHfXQEVL8GgANDkybBm0+OhWguEoyGT0rVN3PHkeovjofKgSESBmQ46DQFN5uiNOioljHzfv9TSeNMeSe4wtZ/XIwNrR6VrebKPPfACsApsm9chWXgzV8cwGyLegin8GxS7970pHhjSupmzAEZSaj7NUwYSexyshyA0UdyYAvSm+i4efFRz951+ubtbrr9w3dDV4pyU9j9wMrXDMQaRW+NUeCAwY8iqnbvvsgvQxozLMid/fQZ+qDeGbe82uCnzAoYsnCYhlINSyWvweLMO+rwZsCt4+w77Cj6f2zCMJbQ2A8vNHgPoNkrfl1lQhAdweNP3QWMAgkVu2YBlyguWT9LHpbreunv2qJ3VtntLBuQKRZZeJ9lN8y00pikXTF3wZqoPk8c0t7DYf6Ib+RlEkiVEXw6r1/2n5F902CILcuFFKw
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(376002)(346002)(451199015)(36840700001)(46966006)(40470700004)(37006003)(6666004)(478600001)(966005)(41300700001)(70586007)(2616005)(1076003)(6200100001)(336012)(16526019)(4326008)(6862004)(8936002)(8676002)(70206006)(7416002)(4744005)(47076005)(426003)(5660300002)(83380400001)(2906002)(7049001)(36756003)(40480700001)(82740400003)(356005)(81166007)(54906003)(36860700001)(316002)(26005)(186003)(82310400005)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 02:20:21.0009
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ead1a0d-c20c-4531-4be3-08dad34298bf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5384
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is to use another AMD SEV-ES hardware assisted register swap,
more detail in 2/3. The patches are fairly independend but required in
this order.

This is based on sha1 ef4d3ea40565 and requires something like this:
https://lkml.org/lkml/2022/11/29/1229

This patchset is pushed out at
https://github.com/aik/linux/commits/debugswap

Please comment. Thanks.



Alexey Kardashevskiy (3):
  x86/amd/dr_addr_mask: Cache values in percpu variables
  KVM: SEV: Enable DebugSwap
  x86/sev: Do not handle #VC for DR7 read/write

 arch/x86/include/asm/debugreg.h |  1 +
 arch/x86/include/asm/svm.h      |  1 +
 arch/x86/kvm/svm/svm.h          | 18 ++++++++---
 arch/x86/kernel/cpu/amd.c       | 32 ++++++++++++++++++++
 arch/x86/kernel/sev.c           |  6 ++++
 arch/x86/kvm/svm/sev.c          | 22 +++++++++++++-
 arch/x86/kvm/svm/svm.c          |  6 ++--
 7 files changed, 78 insertions(+), 8 deletions(-)

-- 
2.38.1

