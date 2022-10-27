Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4FBF60F2A1
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 10:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234984AbiJ0IjA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 04:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234581AbiJ0Iiz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 04:38:55 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2053.outbound.protection.outlook.com [40.107.223.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE4C9E0DD;
        Thu, 27 Oct 2022 01:38:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k0xE2niaZ9cLrQavI/oCKqNYNwQYslH3PFecVqA5eQ0uromXlza4Sr7cQWB/2TzQt+QTO/PD/37hPYOigv3z1I6ql+mEcebMvU96siITGzaZ1stfo57DkZwLX3a+WczrI+odT9POiNmBqOI17F95WIAPsb5fIwaiA8L+LF45HfP1+NAq5YGy+MXJS9+86qudY/NZmKKA8mLgjf93VBG5iONnIX8I7HLVGRhJpDK9TSPc/haU6Ncoh/Ek8n8go8vMqwDEPxaKqh6FHJ0BByYpVEimkst6zQVydVXcbpXbMgTBMdudH1aOfHefwqVn048WEfeWhIhyCz/AKs3jTNzjag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KW7/HrI9QAciw94gPmrgMRO9PF8ddtfgkudQouwfPgo=;
 b=nyVx/nefnsLpuhF7edc/CZn2xCqU9LjQCiQ+RrwG5mUZixYf7MFXy07IV3M0C5TOnph1tHa2db9C9/39HnkeBHZ0rQ1Fs5ZPS+KopYOlG2/j5hXgxypUzNbCwUDebV8w5kzIFLuolC5itGBtkQT6WOgpoOrUyor864dgCG1/xcIWTKwGgV3bhqTWk0MhYUCT5ZX2+vJPtiO8ZkEYVfDU8DyYCPfBbTdKo3XXcrZ17fdQ4vZq542HKh/qglY9iHBh5f+4zQ3S6NGULOsgaQSOQDsLDq+UbxIr8NLFDoHJJcRfW/TeCGYwnuH4QVqPfAAy8vBW0qU2FkxaRp4wgD5piQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KW7/HrI9QAciw94gPmrgMRO9PF8ddtfgkudQouwfPgo=;
 b=gxpO48i4uk/gN/eW0cUQZYSaPHP23ppy8RJaO5cuqiKHUPjQVD9uOKZdutzieWu+WVnLMwReaJiBAGxJ5zvnCxeAkcKLdimtVs8Hs7dm9g71eUbywx/NUjijvsGcp9HzR829kBS/5GQlgdkQBD8PCjAgVBDl7Qt+ty6kmmmWdBQ=
Received: from BN8PR16CA0027.namprd16.prod.outlook.com (2603:10b6:408:4c::40)
 by MW4PR12MB5667.namprd12.prod.outlook.com (2603:10b6:303:18a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Thu, 27 Oct
 2022 08:38:51 +0000
Received: from BN8NAM11FT098.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:4c:cafe::a) by BN8PR16CA0027.outlook.office365.com
 (2603:10b6:408:4c::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21 via Frontend
 Transport; Thu, 27 Oct 2022 08:38:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT098.mail.protection.outlook.com (10.13.177.196) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5746.16 via Frontend Transport; Thu, 27 Oct 2022 08:38:51 +0000
Received: from BLR-L-SASHUKLA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 27 Oct
 2022 03:38:46 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <jmattson@google.com>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>, <mail@maciej.szmigiero.name>,
        <mlevitsk@redhat.com>, <thomas.lendacky@amd.com>,
        <vkuznets@redhat.com>
Subject: [PATCHv5 0/8] Virtual NMI feature
Date:   Thu, 27 Oct 2022 14:08:23 +0530
Message-ID: <20221027083831.2985-1-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT098:EE_|MW4PR12MB5667:EE_
X-MS-Office365-Filtering-Correlation-Id: f74b258a-6f7e-44c2-861c-08dab7f6ac9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hSyRyiNrHzaMbd2bZDWszpiZfEo7jx8/bySS73nw8Zy7z0sKUEpduWJ4FT//PSFfpTAUpo8a6L9ga6rPahVFU0nsvAZZl+avAtGT1+OlMU67nXd7P3NGPOEyKPQeYBeW9yIqLs31nG21iohFgxejMC+FvDt2ZqUwAlqxmbGi/9vws+iZeWYz7fiwY8cPGgzReDNRcmnTO+KU7n9HJuFK1cPKQ2gScqwYhxj+GmCduQNFhl/D6kzWEHSKMxvllpK5wTpIzI8w3Biti7mg0GDLgejEoEwTnZ2mkPKA2bdit9ZKAJxOBh20AQwAPanvN9wQGYff19646muWd9OPtdCUWjtLcrZOzlS2YMePf4MsdYxp85egVUBKKWKw+Pay6Bbv387e6XgE9TBaeP39QYZN/YId+6COTnNJpRBGTxM4EFJLBeHLb75Se8QBvjYl+txwYwXNuDnoG2udFJjRZJWEwu2as1vHwU/1jNqiz+GJbuah11B0LH9Q5+B6k9I9GWf1KkrA64oKZaLSuYi5+ABt40plTbEGAtLA779A2NOxb7dSZPXpy3SX0bBDZ8tt59x4mkXUJXM1Ky0DLHbQQwed6ZO4xD6cbnWI6+w1dRL9QI2jBOPqkkJFJSdm/ASicnph6yP/N/+9ShfLdnxRCV1qxzatDVN1wHb0+5/B9DiVnHSroEffiMoKotPGTNiDbXHTGf74xFAaZl78IYL6V3r2alZa1Z80cwUCD6br27rHcYYEBSzr6QVH0/ry3QVeBTtf9cgxsJFEPq3FeaR2yUyMErqDoZFTqBV5fBzY59DG33kfHT+5BEiV0iuiJIyrPv34dAWZXPHYCxahtVEg8SHL4TKX0PIGNTnJx6znclYaWklnX+AqBTv0sXn6pK8264xL
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(39860400002)(136003)(396003)(451199015)(36840700001)(46966006)(40470700004)(4326008)(40460700003)(336012)(8676002)(1076003)(6666004)(186003)(86362001)(110136005)(36860700001)(54906003)(81166007)(44832011)(40480700001)(478600001)(41300700001)(5660300002)(356005)(7696005)(70586007)(83380400001)(82310400005)(16526019)(70206006)(2906002)(82740400003)(2616005)(8936002)(47076005)(426003)(26005)(316002)(966005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 08:38:51.1785
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f74b258a-6f7e-44c2-861c-08dab7f6ac9e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT098.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5667
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VNMI Spec is at [1].

Change History:

v5 (6.1-rc2)
01,02,06 - Renamed s/X86_FEATURE_V_NMI/X86_FEATURE_AMD_VNMI (Jim Mattson)

v4 (v6.0-rc3):
https://lore.kernel.org/all/20220829100850.1474-1-santosh.shukla@amd.com/

v3 (rebased on eb555cb5b794f):
https://lore.kernel.org/all/20220810061226.1286-1-santosh.shukla@amd.com/

v2:
https://lore.kernel.org/lkml/20220709134230.2397-7-santosh.shukla@amd.com/T/#m4bf8a131748688fed00ab0fefdcac209a169e202

v1:
https://lore.kernel.org/all/20220602142620.3196-1-santosh.shukla@amd.com/

Description:
Currently, NMI is delivered to the guest using the Event Injection
mechanism [2]. The Event Injection mechanism does not block the delivery
of subsequent NMIs. So the Hypervisor needs to track the NMI delivery
and its completion(by intercepting IRET) before sending a new NMI.

Virtual NMI (VNMI) allows the hypervisor to inject the NMI into the guest
w/o using Event Injection mechanism meaning not required to track the
guest NMI and intercepting the IRET. To achieve that,
VNMI feature provides virtualized NMI and NMI_MASK capability bits in
VMCB intr_control -
V_NMI(11) - Indicates whether a virtual NMI is pending in the guest.
V_NMI_MASK(12) - Indicates whether virtual NMI is masked in the guest.
V_NMI_ENABLE(26) - Enables the NMI virtualization feature for the guest.

When Hypervisor wants to inject NMI, it will set V_NMI bit, Processor will
clear the V_NMI bit and Set the V_NMI_MASK which means the Guest is
handling NMI, After the guest handled the NMI, The processor will clear
the V_NMI_MASK on the successful completion of IRET instruction
Or if VMEXIT occurs while delivering the virtual NMI.

If NMI virtualization enabled and NMI_INTERCEPT bit is unset
then HW will exit with #INVALID exit reason.

To enable the VNMI capability, Hypervisor need to program
V_NMI_ENABLE bit 1.

The presence of this feature is indicated via the CPUID function
0x8000000A_EDX[25].

Testing -
* Used qemu's `inject_nmi` for testing.
* tested with and w/o AVIC case.
* tested with kvm-unit-test
* tested with vGIF enable and disable.
* tested nested env:
  - L1+L2 using vnmi
  - L1 using vnmi and L2 not


Thanks,
Santosh
[1] https://www.amd.com/en/support/tech-docs/amd64-architecture-programmers-manual-volumes-1-5
(Ch-15.21.10 - NMI Virtualization)

[2] https://www.amd.com/en/support/tech-docs/amd64-architecture-programmers-manual-volumes-1-5
(Ch-15.20 - Event Injection)


Santosh Shukla (8):
  x86/cpu: Add CPUID feature bit for VNMI
  KVM: SVM: Add VNMI bit definition
  KVM: SVM: Add VNMI support in get/set_nmi_mask
  KVM: SVM: Report NMI not allowed when Guest busy handling VNMI
  KVM: SVM: Add VNMI support in inject_nmi
  KVM: nSVM: implement nested VNMI
  KVM: nSVM: emulate VMEXIT_INVALID case for nested VNMI
  KVM: SVM: Enable VNMI feature

 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/svm.h         |  7 +++
 arch/x86/kvm/svm/nested.c          | 32 ++++++++++++++
 arch/x86/kvm/svm/svm.c             | 44 ++++++++++++++++++-
 arch/x86/kvm/svm/svm.h             | 68 ++++++++++++++++++++++++++++++
 5 files changed, 151 insertions(+), 1 deletion(-)

-- 
2.25.1

