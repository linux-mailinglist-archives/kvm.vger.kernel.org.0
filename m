Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE69452D083
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 12:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236677AbiESK1d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 06:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236657AbiESK1b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 06:27:31 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2064.outbound.protection.outlook.com [40.107.102.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90BC1A7E17;
        Thu, 19 May 2022 03:27:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lZ5p7tTB9l1lcEG0fATel8SO/J5Zub3p33GQG5y+Huikagy6vLX/xaFP5cMX7rbkmWA84NHdT90UYa8sC0NsRMmyRgyC/uyyVwkau/gumdTqjHagsqQeyOIu4FiBbLvjUvUBZ6m8hsIApRwTdOCEQuV9OQ0ypD/oAEhP41jf0ho3SApXsjNbz5KsHXJLSkASIWOQLfKw6ZZKYSAtZojzPJFPxfLs1fP300pol6yH34biopYzPaazhiKC2VG1JEA4LRNr4Ra7SG3pf451VTwwWKRlZiXgtgaGgqPn8WoSsWI5R0om64MOGLWZPziRMOJI+XIbZujFqqsS2dPrsOEaMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L1GZUc+a/RfcBpIQXTpCzGopGgv8uI+RvHoeSs3/zMM=;
 b=nvgkPHkVdZHLdgKiurdH6Nr+3offtPQlnuz9pdRwsTulFGs5akrDCC+NDqbTcgvGDbS9NqA66rZA6M+V/IzuW0h82hZ/wCRws+KmhJ/2maIhxRPObaJlnq0Iy0yuVL6uyeN3nOXZQ+r87POdwA50GeZJT9kEtDNRK1GgxH+LrkGVGqL/7PXgcK30T9rYYkp0SJ14Rm+fxdkeregkSZv/Es2etOuS+zCr04Zum0gnjRZ21ggb29Jk3Vp83lAZPFGEJknwHxB62LUkMx4CSxluAYBsncciugG7lmzMCzT4yGlI2xOu7CdLcvVOSTo9MyGM35aNMt6HoCQ1dDJMzImskQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L1GZUc+a/RfcBpIQXTpCzGopGgv8uI+RvHoeSs3/zMM=;
 b=e1SyuZKXgFMxCJcP3Nf/uc6lN4hW3jbzmNsTaKp4RXIT6Y1SW8H+mt+R2/dUe7pbsNNYwaqgC3yoxF803l7GgUkcpMuPkhgZiDKwa4b0G+tZrxJynZ52FRiOyc/KnQmSmsf2xSnQcg92a2hSeqlcJC5EDbGmcqtrOdKhmz1orzI=
Received: from DM5PR18CA0056.namprd18.prod.outlook.com (2603:10b6:3:22::18) by
 BL0PR12MB4690.namprd12.prod.outlook.com (2603:10b6:208:8e::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5273.13; Thu, 19 May 2022 10:27:27 +0000
Received: from DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:22:cafe::a4) by DM5PR18CA0056.outlook.office365.com
 (2603:10b6:3:22::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.26 via Frontend
 Transport; Thu, 19 May 2022 10:27:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT066.mail.protection.outlook.com (10.13.173.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5273.14 via Frontend Transport; Thu, 19 May 2022 10:27:27 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 19 May
 2022 05:27:26 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v6 00/17] Introducing AMD x2AVIC and hybrid-AVIC modes
Date:   Thu, 19 May 2022 05:26:52 -0500
Message-ID: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3bff36d6-f0b7-4df4-c296-08da39822c0f
X-MS-TrafficTypeDiagnostic: BL0PR12MB4690:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB4690BC473354D7E590C30D1AF3D09@BL0PR12MB4690.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XvVeQqZQHsII8SnRRCw4CZK8UQ3iSuS0Nc8KkiRLI9gPInHrHIA7eqv5UYFG5TL5DRqzBt0zK21i4FVOyqq+Hmj8Nz/xc9ktp8Kna33k2TRiOUG35TsLlnQ0USRzdY6Lkcf8qFt/S4Byhwg4/0HUP5DEnjf0z6KLJThYwi815c9MosC5jpgFiwvvUA6gwXjurbYfCtUI0bKae5AegddGvyirwT67RFBzHPqpTXHawsiC65pCnwwsdEhAwYPemmIiUmD+e4RxjU9UnEr52CQ+3FCAH2FgClscYITO+HpTn8Sfllx/sPSTRjCh75L0+1sYwXiqswV81KKUCOYPFH9FTQ7TmfJGuDhIdNG5Wj7G1Av01KDz5PNHKwaBuKkP1Ysb/vA37n4DQ9eYgp6UEC7dagkcmtx3+lmB9+csfyKar06Bj05xd/6akhpQ2PYV7c+jGzg8CyX0bTRVZxnrIlDo+Q/fQIc7hk8S8fSxhUtmnsyMBV7QsKWPSDXXakfG4egKBxWPcfSjJhIxLpOU5QbGOu/EAx2ZJRTbKPx0jDs1gpLVw6chbtb0MDbl+gL4Aw4xIhoWxdK+H4WqShDmqqu04VMPlwrvDf3alFyTrISK4el4MWUDZCPay30uKcSGWxC9ApKAtgsBrcGhLQt5UdL42Xg0QmXyeGqK1TDFTYkijD8Ho0sXPahrgdfGaGgKZpFL0LEDoRgCQ64FW3zVHnivPSmIrLxlEUQkvEJPVg73mIc4wCKTlJEOO4mD+shpIm+kn19P8vJRh4lzSBqyoOzkQUnxCr+iR3ttY+IrIAQ0pHA613pFPJiYdo2Xuq/cLh6Cj4jJYNmObwSdAx4hQqMetw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(16526019)(8676002)(186003)(2616005)(2906002)(83380400001)(5660300002)(508600001)(7696005)(36756003)(8936002)(44832011)(70206006)(86362001)(336012)(316002)(426003)(6666004)(40460700003)(36860700001)(4326008)(54906003)(110136005)(26005)(47076005)(70586007)(1076003)(81166007)(356005)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 10:27:27.3014
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bff36d6-f0b7-4df4-c296-08da39822c0f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4690
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

Testing for v5:
  * Test partial AVIC mode by launching a VM with x2APIC mode
  * Tested booting a Linux VM with x2APIC physical and logical modes upto 512 vCPUs.
  * Test the following nested SVM test use cases:

             L0     |    L1   |   L2
       ----------------------------------
               AVIC |    APIC |    APIC
               AVIC |    APIC |  x2APIC
        hybrid-AVIC |  x2APIC |    APIC
        hybrid-AVIC |  x2APIC |  x2APIC
             x2AVIC |    APIC |    APIC
             x2AVIC |    APIC |  x2APIC
             x2AVIC |  x2APIC |    APIC
             x2AVIC |  x2APIC |  x2APIC

Changes from v5:
(https://lore.kernel.org/lkml/20220518162652.100493-1-suravee.suthikulpanit@amd.com/T/#t)
  * Re-order patch 16 to 10
  * Patch 11: Update commit message

Changes from v4:
(https://lore.kernel.org/lkml/20220508023930.12881-5-suravee.suthikulpanit@amd.com/T/)
  * Patch  3: Move enum_avic_modes definition to svm.h
  * Patch 10: Rename avic_set_x2apic_msr_interception to
              svm_set_x2apic_msr_interception and move it to svm.c
              to simplify the struct svm_direct_access_msrs declaration.
  * Patch 16: New from Maxim 
  * Patch 17: New from Maxim 

Best Regards,
Suravee

Maxim Levitsky (2):
  KVM: x86: nSVM: always intercept x2apic msrs
  KVM: x86: nSVM: optimize svm_set_x2apic_msr_interception

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
  KVM: SVM: Introduce logic to (de)activate x2AVIC mode
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
 arch/x86/include/asm/svm.h         |  16 ++-
 arch/x86/kernel/apic/apic.c        |   2 +-
 arch/x86/kernel/apic/ipi.c         |   2 +-
 arch/x86/kvm/lapic.c               |   6 +-
 arch/x86/kvm/svm/avic.c            | 178 ++++++++++++++++++++++++++---
 arch/x86/kvm/svm/nested.c          |   5 +
 arch/x86/kvm/svm/svm.c             |  75 ++++++++----
 arch/x86/kvm/svm/svm.h             |  25 +++-
 arch/x86/kvm/trace.h               |  18 +++
 arch/x86/kvm/x86.c                 |   8 +-
 14 files changed, 291 insertions(+), 52 deletions(-)

-- 
2.25.1

