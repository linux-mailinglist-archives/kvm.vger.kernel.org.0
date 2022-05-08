Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03DC251EAF3
	for <lists+kvm@lfdr.de>; Sun,  8 May 2022 04:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387757AbiEHCnu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 May 2022 22:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiEHCnr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 May 2022 22:43:47 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2080.outbound.protection.outlook.com [40.107.244.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3CA6101DA;
        Sat,  7 May 2022 19:39:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aIQI6ILxDlQgB43C9z/OhV4pV1lkf75B8fLTB3Z12jxXBu2mC4Rxs2jh+zWtTeSr9YcE+FrB+8QZPewR3IivLmV9uWRi66WlQdfOpM0O6T/r9Rck2SX1cgWVtOgnhdDaq8JoVHX12z6313L69TQr5FoepAICS7/s+56QI1XxWItUaGjoGiG6wV+3DlDAhdWqiqlVodeWnb2Y9Rkd3CbUu5/zrP1b8TAPVB7C0DG4DFtIZgvj1ndQ2GOM01UWTD2fd0HY2a1QrNE+o+z7eHtZ2l0MKtf/UXf7FI7RRoBMCRAdAgobB33B0cSRFEO3yrUiU9MxwgyMR1LqdWm8otE3kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zrKLmin+Y3rg1ejF/unvYfSFsQeZY9vC3zcUGnbWEUk=;
 b=khf3iuc49bnfnLaHL/rjw3ntTQecXnsXF9e8wu+2mO2XGD1xdQoxdjVtNBv/LUcCldo+A8nZ/j7vczBNJqiz/cINdAzo4sldWaX8c+imo5kET+nTcS62Vgs42Ez0rzZACcymodtVBGx4sLYgHQbRiQEwEBp1AXEF6rakt2RDGmZ5W4tKbz/2AdYaESP0Y3RI4RX+4QOIbCf3sncHpXg5dlWYd8OuKn/nSFWJYSnQy6RM4zrDNNPeUK9USjFhFObQpN8AfBUSFv3ITBaPR30G5TIRTFcKIJUSbK6ICzQs3QNsFPv2C/ddx4hnRUARhtZzu+o6qhaE4hgyDb3tzXlzoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zrKLmin+Y3rg1ejF/unvYfSFsQeZY9vC3zcUGnbWEUk=;
 b=4h4C/mKxIiTGghYieu5R6jq6Z8OHOzwDTRu+aoYEoltsiv+DHZ6OgNEnerjlcAtGjpbe3hptvgmzqi992dVl96VhVNVATwzoQO8P+F481IeSIDKu0jjlWKntMdWWOBmYj6YZae3b2plDoqtDriep5a4oCTvUwy6pCE/1zs1vD3Q=
Received: from MW4P222CA0020.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::25)
 by MWHPR12MB1775.namprd12.prod.outlook.com (2603:10b6:300:109::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20; Sun, 8 May
 2022 02:39:48 +0000
Received: from CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::a8) by MW4P222CA0020.outlook.office365.com
 (2603:10b6:303:114::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13 via Frontend
 Transport; Sun, 8 May 2022 02:39:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT010.mail.protection.outlook.com (10.13.175.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5227.15 via Frontend Transport; Sun, 8 May 2022 02:39:48 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sat, 7 May
 2022 21:39:46 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v4 00/15] Introducing AMD x2AVIC and hybrid-AVIC modes
Date:   Sat, 7 May 2022 21:39:15 -0500
Message-ID: <20220508023930.12881-1-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1be14f50-d55c-46ce-30ca-08da309c04f0
X-MS-TrafficTypeDiagnostic: MWHPR12MB1775:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB1775CEB33DB4EC0C09A2CB13F3C79@MWHPR12MB1775.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6F8+YTmxB44/hQNxQpsODXGPNd+leEtkF3NqwGzSVTkPFrRsHzbX2yyHsarYqLyT8h+DOh4S9eTlrtvPIu82dKAOqcF7bOvDb1B+pTx2Pa+nCh6rRsoY+3826GD4RSCEPQVs7Xk9a/RZ9SXagUkPPKxuR03fDnKFHHKy2tYH5LhjKfq3UUbdMnE7kRd49SPXPGtsbWTH3HSGkIncWFnapZHfJzA0tP9eV3Q9JrL2Yfxh4shqhCjSnIMacf2hkBOiBBlnb5wLo9BaI32t1gf6D9mq0mJCeK1gcD8IuDomheP6rC7+v2l/UB8EsPKEmt5TUnHiUrpmCsKeU6D3S2g8/kWbO07bpg8Jtgvz0b5SE5SLIAcaVA/x0bbTc2CtN/Et1Bps94zs0s7L1/vCSLHhlFqEsWRJAU6RfW76iF98Zj9No30rVsnkMIC0naFO/8jqFyvmpWP/aLXfwP8tMI7n0cL1sjcz3m5mot7vrmlVOxwdGZoky1nCfh1ayKLNhgMwaGD6OTuWSXxXBT4e7VFALGof1sD14HH0wU8h0E1MnuqhYbwY/0mAA/ZvjwMyxWYrAVmTcEuFBlxhg+90hsZ7LijogrLeE3r2uvpgfj14VvQrBpqmx1y1Wjz4qOPEFqnyUCwrJpql5BZIcAJ1BBp+rZlaytNXRMpI9o7W/XaJAkZA411llwnA//t8/iLPro0zw8MvvNup3sggG2i/PP7EK/r4wlQj6J0fv71co5CH0a1kCVTf/fHUV351ZwiRAlcgZ8hAaao/Kz52IKfyeGJfQvn3efWEWll21msgNI10jn0=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(83380400001)(8936002)(47076005)(2906002)(336012)(426003)(36860700001)(16526019)(356005)(44832011)(26005)(40460700003)(6666004)(36756003)(508600001)(81166007)(5660300002)(86362001)(2616005)(316002)(1076003)(54906003)(4326008)(110136005)(70586007)(70206006)(82310400005)(8676002)(186003)(7696005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 02:39:48.0353
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1be14f50-d55c-46ce-30ca-08da309c04f0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1775
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introducing support for AMD x2APIC virtualization. This feature is
indicated by the CPUID Fn8000_000A EDX[14], and it can be activated
by setting bit 31 (enable AVIC) and bit 30 (x2APIC mode) of VMCB
offset 60h.

With x2AVIC support, the guest local APIC can be fully virtualized in
both xAPIC and x2APIC modes, and the mode can be changed during runtime.
For example, when AVIC is enabled, the hypervisor set VMCB bit 31
to activate AVIC for each vCPU. Then, it keeps track of each vCPU's
APIC mode, and updates VMCB bit 30 to enable/disable x2APIC
virtualization mode accordingly.

Besides setting bit VMCB bit 30 and 31, for x2AVIC, kvm_amd driver needs
to disable interception for the x2APIC MSR range to allow AVIC hardware
to virtualize register accesses.

This series also introduce a partial APIC virtualization (hybrid-AVIC)
mode, where APIC register accesses are trapped (i.e. not virtualized
by hardware), but leverage AVIC doorbell for interrupt injection.
This eliminates need to disable x2APIC in the guest on system without
x2AVIC support. (Note: suggested by Maxim)

Regards,
Suravee

Testing for v4:
  * Tested booting a Linux VM with x2APIC physical and logical modes upto 512 vCPUs.
  * Test enable AVIC in L0 with xAPIC and x2AVIC modes in L1 and launch L2 guest
  * Test partial AVIC mode by launching a VM with x2APIC mode

Changes from v3:
(https://lore.kernel.org/lkml/ff67344c0efe06d1422aa84e56738a0812c69bfc.camel@redhat.com/T/)
 * Patch  3 : Update logic force_avic
 * Patch  8 : Move logic for handling APIC disable to common code (new)
 * Patch  9 : Only call avic_refresh_apicv_exec_ctrl
 * Patch 12 : Remove APICV_INHIBIT_REASON_X2APIC, and add more comment for hybrid-AVIC mode

Suravee Suthikulpanit (15):
  x86/cpufeatures: Introduce x2AVIC CPUID bit
  KVM: x86: lapic: Rename [GET/SET]_APIC_DEST_FIELD to
    [GET/SET]_XAPIC_DEST_FIELD
  KVM: SVM: Detect X2APIC virtualization (x2AVIC) support
  KVM: SVM: Update max number of vCPUs supported for x2AVIC mode
  KVM: SVM: Update avic_kick_target_vcpus to support 32-bit APIC ID
  KVM: SVM: Do not support updating APIC ID when in x2APIC mode
  KVM: SVM: Adding support for configuring x2APIC MSRs interception
  KVM: x86: Deactivate APICv on vCPU with APIC disabled
  KVM: SVM: Refresh AVIC configuration when changing APIC mode
  KVM: SVM: Introduce helper functions to (de)activate AVIC and x2AVIC
  KVM: SVM: Do not throw warning when calling avic_vcpu_load on a
    running vcpu
  KVM: SVM: Introduce hybrid-AVIC mode
  KVM: x86: Warning APICv inconsistency only when vcpu APIC mode is
    valid
  KVM: SVM: Use target APIC ID to complete x2AVIC IRQs when possible
  KVM: SVM: Add AVIC doorbell tracepoint

 arch/x86/hyperv/hv_apic.c          |   2 +-
 arch/x86/include/asm/apicdef.h     |   4 +-
 arch/x86/include/asm/cpufeatures.h |   1 +
 arch/x86/include/asm/kvm_host.h    |   1 -
 arch/x86/include/asm/svm.h         |  21 +++-
 arch/x86/kernel/apic/apic.c        |   2 +-
 arch/x86/kernel/apic/ipi.c         |   2 +-
 arch/x86/kvm/lapic.c               |   6 +-
 arch/x86/kvm/svm/avic.c            | 191 ++++++++++++++++++++++++++---
 arch/x86/kvm/svm/svm.c             |  56 +++++----
 arch/x86/kvm/svm/svm.h             |   6 +-
 arch/x86/kvm/trace.h               |  18 +++
 arch/x86/kvm/x86.c                 |   8 +-
 13 files changed, 262 insertions(+), 56 deletions(-)

-- 
2.25.1

