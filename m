Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3C25A46CC
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 12:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiH2KJc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 06:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiH2KJ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 06:09:29 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2055.outbound.protection.outlook.com [40.107.102.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31BF5FAE2;
        Mon, 29 Aug 2022 03:09:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KYRMjLRc21qvqgbcLNmtCFYjVXfhwAc7/hqfhvJ8IY58UGjUmXaXEs1wYLIcq3bHhJUG1aYT2iJ4KcVFN4iLiAUym60jTjJSRp2VyCGl2BNH+OwJmNK2Z5NsXBOXfS0xJr4hMxsNgOO5vBAVRb8MvHs+Fp/rcajCMUdrPbpYVE2m7g7MOjcc6IzK6hJ1tGHONtUhPFAKHdytgw3ygr+HTiN6OsuH0rxQ/eM0pU3a4l8502en4Nirh77JoyRgQA979lZAQCElkN/Uv/kVoyfUP16e5pmFYSEhFl9B/PPaWRdFqJ1W8Uqb1JVNjZhHmhADpV0KZOrUiWAjR411ftV9Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P+VrzahtWxhm/ITG96+cofBON4O50HRBJtsZ3IkRRA8=;
 b=Z+BPdtu+C/Mf4CJpKeqy9huOqr+rz2dgjbdgReJDqEjEJn/cxtcksOAk3DSqlc5TFE3TJwEeL94fgBBUXH/0ofcKj1NRnCu8raBBwcXey12M/nF+ur8BWfpME+Nke0sC/8Hm+FG7sw4ISBfxq0VeAbsDyEeL9YHciWxeSXqUR8h8S5sPUv3ItuskfkEeWOF0L48vbr8zmyk/gaexSrZJSyw2tOdqQMZyC3snXJzToLJhqsvGydsT97HzhV1yMm2BUrizRn5go9LebEJmwa4RYcnkoJceQkd39wOtTE6m+8ChFW2O/ENebuWbKIhp3UN89Czd+xacJInYdOc790VXUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P+VrzahtWxhm/ITG96+cofBON4O50HRBJtsZ3IkRRA8=;
 b=Ods2eqksqC5Q6KWtHJ0u1y8SUt1NT3spOWmOJFDNA2hmQzKpKgb3JL66rBta4feTHPM5QXfGiVTmnp4EF1hIndEcgfkCjW7/ffVHLkg31IOMyxso7iQ7Q6xal9WSU10LqCplHrwbSRXcLxgNGHHCF0sxc2ZJB1/kND7Izdarsqs=
Received: from MW3PR06CA0025.namprd06.prod.outlook.com (2603:10b6:303:2a::30)
 by LV2PR12MB5797.namprd12.prod.outlook.com (2603:10b6:408:17b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.23; Mon, 29 Aug
 2022 10:09:25 +0000
Received: from CO1PEPF00001A61.namprd05.prod.outlook.com
 (2603:10b6:303:2a:cafe::38) by MW3PR06CA0025.outlook.office365.com
 (2603:10b6:303:2a::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14 via Frontend
 Transport; Mon, 29 Aug 2022 10:09:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF00001A61.mail.protection.outlook.com (10.167.241.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5588.7 via Frontend Transport; Mon, 29 Aug 2022 10:09:25 +0000
Received: from BLR-5CG113396M.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 29 Aug
 2022 05:09:13 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <santosh.shukla@amd.com>,
        <mlevitsk@redhat.com>, <mail@maciej.szmigiero.name>
Subject: [PATCHv4 0/8] Virtual NMI feature 
Date:   Mon, 29 Aug 2022 15:38:42 +0530
Message-ID: <20220829100850.1474-1-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dca96cdf-3361-441b-0f88-08da89a68d74
X-MS-TrafficTypeDiagnostic: LV2PR12MB5797:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IU3EC/oNL0Gdr8qtHsrUxXVlvFDRyxgTVODszEn8fSY9eJA3gii99TYM920p/JDQyWoPkzVAH6GSTkWBnZ0DsELqPmH/Lq/apJGfttmlrIRNnaASivH60Qypex+5cUCOpYlhWObpFZ6hIzONk7yG2j6xUiJhEARiv+gTGkq6Zb8i1rAnqaPZQiGFAzNxedYnDaI1xzC0jtaA/3Mf4c9i7YnYdHERfFlEj1CPtrn+7WSwJTkv8BspdMRzopOnGZBaozvNy9GckmppPH2UInU0Qtea8ed1L1knZKp8tw/0lX5Ljoh776Kb5I1KumRIFbviZweuKpmIA2Nq74Pb9cTed35NyWwZl0rUw1cmD+LJBgGuDtC3aGKVE2zJgWi7k+keScvM0HWDlgVzZWXWXvXzJibndu2CDcb5+taVduCqix1RyQU8sz7Or0xSXn3E/wdoqEzfS1pIVy/seXZYW+O/HOn/qlS/3HwQWOiznVjMRPSGjnTqxNMoUJRXa287x7e6zpX2WECM5ZUvvtKv98kPXyYZxfPKeOi1f4oQGgiLytF5K9YUnTVCq+PLf1O9LwspSZHadIkrHUHO05+AHwNOkiPEJTiIbhz78Fd2Fcp7A1LTcHQ6jc2W7896HNsa7lPdGFvxGH6ohlP7rZa9FnFdVg6A942oO3PVwm0tRSrEi7K6F7LX3qtXyXpH+RoTb1x1EAo6qBwWfYEJjzJTPV/IdVtWZWX3x5I/tVhXAKsg3j2N0GCmfEL2O+wNz+KIw/pZac7WPUE+pY4O2e5VTyrvkallF/2tUWWETss+lUWn/ZXezl25jIFdLyKTZJhiuCW+7A0PPIOY3EgGORHJM9tlORAqoWPohKWINq8vif4rvYT1ksP8NumAcHozUmzNcsfW
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(39860400002)(396003)(136003)(46966006)(36840700001)(40470700004)(2616005)(336012)(47076005)(16526019)(40460700003)(70206006)(426003)(36756003)(1076003)(40480700001)(83380400001)(186003)(316002)(54906003)(4326008)(36860700001)(6916009)(2906002)(4743002)(7696005)(82310400005)(356005)(70586007)(8936002)(5660300002)(44832011)(478600001)(966005)(86362001)(26005)(6666004)(41300700001)(81166007)(8676002)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2022 10:09:25.5242
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dca96cdf-3361-441b-0f88-08da89a68d74
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF00001A61.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5797
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Change History:

v4 (v6.0-rc3):
05 - added nmi_l1_to_l2 check (Review comment from Maciej).

v3 (rebased on eb555cb5b794f):
https://lore.kernel.org/all/20220810061226.1286-1-santosh.shukla@amd.com/

v2:
https://lore.kernel.org/lkml/20220709134230.2397-7-santosh.shukla@amd.com/T/#m4bf8a131748688fed00ab0fefdcac209a169e202

v1:
https://lore.kernel.org/all/20220602142620.3196-1-santosh.shukla@amd.com/

Description:
Currently, NMI is delivered to the guest using the Event Injection
mechanism [1]. The Event Injection mechanism does not block the delivery
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
[1] https://www.amd.com/system/files/TechDocs/40332.pdf - APM Vol2,
ch-15.20 - "Event Injection".

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

