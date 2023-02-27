Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56CC26A39CD
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 04:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbjB0Dy3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Feb 2023 22:54:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjB0Dy2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Feb 2023 22:54:28 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2040.outbound.protection.outlook.com [40.107.94.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC0DD33E;
        Sun, 26 Feb 2023 19:54:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EFeyxPdWhYCtmKRfNl2lfON/GJ5W2VosuUy7C8pMHX2FTGrFMFnLQmMRpYWLMgcM1zMkpjnLmRJWyPARtxWaToicjO4Or5uwRLQWvJMVrdbqWktQ0AQ1j3ohquDsE9+zxYdcsKU3Vd7B+tVg8pRx/98t5Xc9noUPPgFyyaTd4shPR9laFiLgdl6FVDouHSs774ECN51Ktq3TfoRdP19m0QGVWPJ+CE3T9NxYAmr2cyUQ0aTIThiIbGm8wNLS2Gv2GJUcZA11/YPykLceMpeTcaoaYSoOJxrfyvswHy/MmzGJrUPem5b6Sk2ilRidTMILpyGLQuE/RRFz27YLoq6aWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QQG4uXN3QDEsxDQT7P8E8qhn7MKctHdq5yfY2AnAMHs=;
 b=XzHpq37tW4OWSp+3qVAOjHqHETQ5EWbpsNe4HVcp4gdM0Ux9Gz9J/5V0/xK/a49NXofA0XbmHNLvpPE+3o8ZkmDBwrY0lttDIHCgFGq1sTRu4vneHJWjFpV6ZAcTqxYJC//YlzKwC6Ue3Blkw99qHC9LxtBStUuSpIkmOZo3A66inNANsMWZmnkLH31pZd1gKFNbstuFydSiS6DSSb6RMHgtpNy6CaTKK2F67QEkBVGVblELCiq2Ir44Ypqqi6X/Zryv8BnIQQLMTipvqrv6pDxhjfj+1utMDuHAI/vJ2F9hPOJc8NY1vcw4DFwMWQ5oIJl4QpmK7rEO5GFStSWFiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QQG4uXN3QDEsxDQT7P8E8qhn7MKctHdq5yfY2AnAMHs=;
 b=2UDpZoJEa3Au/jjjx8gm+GNfm31p61fq878fOKjkNjwYdVbPvD/t2JKtOan4nRhGzlPc3QAZ2GvdwCryEf1UgBOxVVrPfT8ResI9ChbUFKNqmkmbq+lkD9QUNJpKiNqjF7ijzLHkQRS2LKFFzHBENPQlkwBdnoaBqRSujNWp844=
Received: from MW4PR03CA0081.namprd03.prod.outlook.com (2603:10b6:303:b6::26)
 by DS7PR12MB6189.namprd12.prod.outlook.com (2603:10b6:8:9a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.26; Mon, 27 Feb
 2023 03:54:23 +0000
Received: from CO1NAM11FT095.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b6:cafe::31) by MW4PR03CA0081.outlook.office365.com
 (2603:10b6:303:b6::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.28 via Frontend
 Transport; Mon, 27 Feb 2023 03:54:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT095.mail.protection.outlook.com (10.13.174.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6156.14 via Frontend Transport; Mon, 27 Feb 2023 03:54:23 +0000
Received: from BLR-L-SASHUKLA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Sun, 26 Feb
 2023 21:54:15 -0600
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, <mail@maciej.szmigiero.name>,
        <mlevitsk@redhat.com>, <thomas.lendacky@amd.com>,
        <vkuznets@redhat.com>
Subject: [PATCHv3 00/10] SVM: virtual NMI 
Date:   Mon, 27 Feb 2023 09:23:50 +0530
Message-ID: <20230227035400.1498-1-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT095:EE_|DS7PR12MB6189:EE_
X-MS-Office365-Filtering-Correlation-Id: ba687fb8-b5ff-40f2-1d61-08db1876502e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eCVvlTtxbMl04Op3VAcqVSlGNTbfBSf3eusWABwXNogOWy+9JB9eTcM++ArdfOd258R6hk9zUdro4zqpTDnlZy2IF3IkCrRSD1j0lNd9Ve9Jg0grEOxJP73eMszyEWpb8ifbadAoUJS/Wumn8wl2TmUK5zTG/vMSo63+WGlcBDmAqyJ0y2h7iCoqyUesUhxpbfNs6+EJ5/zYJypHxJZTcvLN+qRYDX573JrF/gy4/1SC6e+2C2h8O2Y3TekkjjkxzT3wEtOIu/7+Z24tqsH/wFbsPrl3DJ9IUNiraw9R48meM9BPJcXkR8Z/nWjOyCiZiYvUiNo4deg/WVNiJN4NowpfnlQlcx7MM6ikf6U6V8MnsQfplUc7zOxUpSW4k12t0+TAz1cp9sDF7Sz17KFfpW0nxrVRxNNBFIlvS7JIVzbcu4HBlSemYVDol31WGqBFL2Fl1ooi0zzLYCOPu0WGPWWQGNtWOKx7gf4toGuDWivMJRjrxEhxJUsXNRbjLJdw7qhT/QlV/EWnndoAvAC1lkfHq3ADRGJjCRzrF8e9cplDhcqTWjbIdT9hGZRhBZUdQ/Y7A+e9u2UK7iJ46iSHlwyY7QeNlpAR5nMpJ+5QscgovcIz+bWOldLq6lmPC2KmImQ+/0pBu/jEfTAFrD3NszFPwj6xsNG3AP62JqUb4KLayFIxZxrQxblBH6gCbTqLILrTUePuDxyBXtAmRYfK+fAB/tXSU9sAQMd6FA4peKsNGp5yw6cXwAWYk3R+01AxB+QCC7DHz/J6Q8dQer8Mjw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(136003)(396003)(39860400002)(451199018)(36840700001)(46966006)(40470700004)(40480700001)(40460700003)(186003)(336012)(26005)(16526019)(6666004)(478600001)(1076003)(4743002)(426003)(2616005)(8676002)(316002)(70206006)(70586007)(4326008)(966005)(54906003)(7696005)(110136005)(81166007)(356005)(82740400003)(47076005)(86362001)(83380400001)(36860700001)(36756003)(44832011)(41300700001)(8936002)(82310400005)(5660300002)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 03:54:23.1589
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ba687fb8-b5ff-40f2-1d61-08db1876502e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT095.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6189
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2:
https://lore.kernel.org/all/0f56e139-4c7f-5220-a4a2-99f87f45fd83@amd.com/

v3:
 - 09/11: Clubbed x86_ops delayed NMI with vNMI changes into one,
   for better readability purpose (Sean Suggestion)
 - Series includes suggestion and fixes proposed in v2 series.
   Refer each patch for change history(v2-->v3).

Series based on [1] and tested on AMD EPYC-Genoa.


APM: ((Ch-15.21.10 - NMI Virtualization)
https://www.amd.com/en/support/tech-docs/amd64-architecture-programmers-manual-volumes-1-5

Past history and work refer v5-
https://lkml.org/lkml/2022/10/27/261

Thanks,
Santosh
[1] https://github.com/kvm-x86/linux branch kvm-x86/next(62ef199250cd46f)


Maxim Levitsky (2):
  KVM: nSVM: Raise event on nested VM exit if L1 doesn't intercept IRQs
  KVM: SVM: add wrappers to enable/disable IRET interception

Santosh Shukla (5):
  KVM: nSVM: Disable intercept of VINTR if saved RFLAG.IF is 0
  x86/cpu: Add CPUID feature bit for VNMI
  KVM: SVM: Add VNMI bit definition
  KVM: x86: add support for delayed virtual NMI injection interface
  KVM: nSVM: implement support for nested VNMI

Sean Christopherson (3):
  KVM: x86: Raise an event request when processing NMIs if an NMI is
    pending
  KVM: x86: Tweak the code and comment related to handling concurrent
    NMIs
  KVM: x86: Save/restore all NMIs when multiple NMIs are pending

 arch/x86/include/asm/cpufeatures.h |   1 +
 arch/x86/include/asm/kvm-x86-ops.h |   2 +
 arch/x86/include/asm/kvm_host.h    |  11 ++-
 arch/x86/include/asm/svm.h         |   9 ++
 arch/x86/kvm/svm/nested.c          |  73 +++++++++++++-
 arch/x86/kvm/svm/svm.c             | 152 +++++++++++++++++++++++------
 arch/x86/kvm/svm/svm.h             |  28 ++++++
 arch/x86/kvm/x86.c                 |  46 +++++++--
 8 files changed, 279 insertions(+), 43 deletions(-)

-- 
2.25.1

