Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A91A16A3DB6
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 10:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjB0JDP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 04:03:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjB0JCz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 04:02:55 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2065.outbound.protection.outlook.com [40.107.92.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3AE41F4BB;
        Mon, 27 Feb 2023 00:53:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TCemRrSAPpDEKo8YkqsWOKpaIHBVjyNrcXdOR4m7O7rR7p+w3vNHOlfTqHvVuecAzbaRkxLFxSADGeSzoneo9vCn+iPqI/1phPi0HuwbotNVEF+R1cluqpj1YtfI5h8cY+wUakVCf9zvsMceF9KT0cD212ooxgjce/pcxqoJh+AXbtfxersouNSrHOhBBxxSRyUH5Lo2AQBHg1UdRA8O8X51uhwgq0Br9ubOLuXIBBEb0iOSBC5rgX/TAKKq13NXcjJXLfI+dFpwPSf1noEsOGwnxFQqWDr04TcMUl90qPU43d7EQkipnRBBB87S024o46qF0eC1mluNSEK1wgaUgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XlmIf/P60YprCqUBKVFw864eYpTeI/yHzo1Q6pAK20I=;
 b=mie524zwp80tFDKV88AD+MJwJ4Ruv6dnnzEvJO/NIgNYNrn1dxQBLOuLAq1rRVtGA/hNfi8PZACeLZBlduiJgnbaCxQpKTpbQBRcYV2YIFV+dP4olew8GYntspv7Bfo3ECUXHvhoAJvipt91/J2ae3UDWfBtQfvOlrVwtIOZeXKwByw+BoS3CD4GTD2O0OgTE/suC2IFtnHtlA5cVIPpqUszzen9w24gq4Ypsa8UbKiH51rzPJaL6E57Ez/m7xMQ7oWPZI2+MaOxryv06Rla+Es9yi2mZIif+HLvP5C899p+7/Y09uW7aXLkl9LPwwkACPRxBtOeA/YeDqT9iOLwkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XlmIf/P60YprCqUBKVFw864eYpTeI/yHzo1Q6pAK20I=;
 b=NX9xg/GjfXlMZgqVlFlVIduK5l8kPBo7T+hirZQOF6LtjuLDzL83dgtmJIAle4GIQF3LJHaQirx0ajO8IQ6HkIwnzYyjzMNWhEq1w5xWK5oCkMHL9d6rsH0FQy3WJ6IotPJB1CxNsM43T2DlI5o6Z16H/pbLtauqOvkCSogEJfw=
Received: from MW4PR04CA0063.namprd04.prod.outlook.com (2603:10b6:303:6b::8)
 by DM4PR12MB5279.namprd12.prod.outlook.com (2603:10b6:5:39f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.26; Mon, 27 Feb
 2023 08:40:30 +0000
Received: from CO1NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::f2) by MW4PR04CA0063.outlook.office365.com
 (2603:10b6:303:6b::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.28 via Frontend
 Transport; Mon, 27 Feb 2023 08:40:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT048.mail.protection.outlook.com (10.13.175.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6156.12 via Frontend Transport; Mon, 27 Feb 2023 08:40:30 +0000
Received: from BLR-L-SASHUKLA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 27 Feb
 2023 02:40:26 -0600
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, <mail@maciej.szmigiero.name>,
        <mlevitsk@redhat.com>, <thomas.lendacky@amd.com>,
        <vkuznets@redhat.com>
Subject: [PATCHv4 00/11] SVM: virtual NMI 
Date:   Mon, 27 Feb 2023 14:10:05 +0530
Message-ID: <20230227084016.3368-1-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT048:EE_|DM4PR12MB5279:EE_
X-MS-Office365-Filtering-Correlation-Id: fe55d14d-7560-4633-989e-08db189e48b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: quhFN33SGa1PglohwpobHrQ5cBOYjcp9xq+//jyzH4EmKUzEqRa/z5Z/L7rSHBNd4nYeE/Ykmplj6Gq6xZfLa8YcXI+U7aBTHKLgaX8pvWGZSgY+w8k9wpiRMgTQlYRh7zo0P8Ak99mci6U6Fg9t/n1BuQvHDJyxb9FuXHJHNaptx1QkoByZaKzVEgTihQTb6UYfWer1u7bZwW5AMKJDBaVjdb62eG53dyjB6tMFPVgPqyNDNgqwEShfOF2h/85n6jOeqH0iB6TuaMFJP71v4qkMtiFNoFUE6xcJB4AlK22ZXGYsQGLsOYY2sAGOGRsZ80GqVUDrtFRawoSlOWxAeIRMQKNS4AVaNqm1dhf1N9YPe/4Tb66wtcuRa3FD6N81xdjBFlBY8BVncRUJlh2VrtfJTcYoj9i7r9JzNztEyxOHcoHSifl2sFKQ4VYZDqQNtYJXShRu+jfM6ILqjyKkgvKCon08rPMFAsztJZcXVKojN/F9xDHVdaKOUqjv8rUAEhpGNmq1YgpVQkhWgBsj4umd3ZJuAbpraWq1iagPzbHvT2uJ1oDg36ljVpjUkELVPaeABZYRM3K6VFD2OkKszYhkFg/Yf3uUd9Yz2X47DoC6JhbrrIezwyTP3qMYN+gYfAoOGytyuWadpfhBmPwHh4Vv3E0HTwy8pv76kKTqFQxMNXSTssNMdL0h/uSndFfxBxY5QL6BgvdFmYI8gE8tSBa4cu8JxY3Tq6lzUuN4YsrDkURPL+XspFouv9m0wzJEGgqawtHITiNhUOAvxyzzHg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(376002)(396003)(451199018)(36840700001)(46966006)(40470700004)(44832011)(36756003)(40460700003)(5660300002)(478600001)(83380400001)(86362001)(336012)(82310400005)(47076005)(426003)(6666004)(2616005)(7696005)(966005)(1076003)(4743002)(186003)(26005)(16526019)(356005)(70206006)(8676002)(4326008)(70586007)(40480700001)(8936002)(36860700001)(54906003)(110136005)(81166007)(41300700001)(82740400003)(2906002)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 08:40:30.5123
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fe55d14d-7560-4633-989e-08db189e48b3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5279
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
https://lore.kernel.org/all/20230227035400.1498-1-santosh.shukla@amd.com/
 - 09/11: Clubbed x86_ops delayed NMI with vNMI changes into one,
   for better readability purpose (Sean Suggestion)
 - Series includes suggestion and fixes proposed in v2 series.
   Refer each patch for change history(v2-->v3).

v4:
 - Missed sending 01/11 patch in v3.

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

Santosh Shukla (6):
  KVM: nSVM: Don't sync vmcb02 V_IRQ back to vmcb12 if KVM (L0) is
    intercepting VINTR
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
 arch/x86/kvm/svm/nested.c          |  94 +++++++++++++++---
 arch/x86/kvm/svm/svm.c             | 152 +++++++++++++++++++++++------
 arch/x86/kvm/svm/svm.h             |  28 ++++++
 arch/x86/kvm/x86.c                 |  46 +++++++--
 8 files changed, 289 insertions(+), 54 deletions(-)

-- 
2.25.1

