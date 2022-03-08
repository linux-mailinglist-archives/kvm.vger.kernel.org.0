Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8D874D1D70
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 17:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348426AbiCHQko (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 11:40:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240740AbiCHQkm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 11:40:42 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2064.outbound.protection.outlook.com [40.107.243.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407974BFDD;
        Tue,  8 Mar 2022 08:39:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XqQ5giIrzAgM+WnMK7IBikqY4gQBqYd27oJVkJ4XgAnuojyAePhZAjYEe8x2ov69ooWfVYFVtJ5t2Hpa27A2F3I+6RJDcdnYg/t+OX6oSsiXp/AsABvYx8ikH615rQJR1D68uk/Qg1vOu/67GRj/MoLgrhtHZeNPVKCiWTjtEQxUHkdcQ9DF4GTynuPkaOOoxFcfDPSnAQ3eW/6daEttYDyCXPzw6ZsY8N4YbnpRUGKqDjB/kwJYgDg1DjLW2Yh5zHd+OCwvTuxEbsLproKFcoH2BOAzsIFzi1KZW97FrLSKWY8zMTJ7Hux9m5I7nT0+Mfd9yIbByR+RU3gRKiTsfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IRHGorfkVVed+aAZvKhgtoUQAu69uSt/R/+u3vi7QPc=;
 b=CqgI4ekELER9dGJVfyaUvuC4r2cmFwvDkJh55e1mzi1VqAlkKIoaC1NZljlKfDvDapS5U9HOsVPUL6kBlgKMRq3hx3nkU/xL5d81IUdvcN9bZLWRhd2Lx5DIBJuMb4lqd4ygpipQ3fj/yg8xerCBfJJQq/6jW5ko+dHOHhEjnHG9MFkrkKzPuKe6hQr59oKo+t9xFYA35802DYHiFl+2yzbdffJdCWITKcvrRttd4rkFTYVDJUZz6mQTE+0bROhtGBwlo3YAbxr1n8jlgcSwfv4BuJ6LpJuE9Gss8jYJ5S/cdbXCbVM/Mw9/zGqfmjNmDzvWQbBA2+BzIhuxypZioQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IRHGorfkVVed+aAZvKhgtoUQAu69uSt/R/+u3vi7QPc=;
 b=vZHYMyHB9klLOoztT9/2dGeNuxezBzp5uzbyiZ7MePAj8tlQoNjhP5JLtMo9qxIQVaf4qmqq1KCP6K7iW2lkaebvZTt92E+E4lZrcC5j+jLslNNskHoISlt8Ocjl3c9/3UKHYifkAvvgynxdN53z/XsIwTdNkyFSd9BNNiBwSfM=
Received: from BN9PR03CA0317.namprd03.prod.outlook.com (2603:10b6:408:112::22)
 by DM6PR12MB3163.namprd12.prod.outlook.com (2603:10b6:5:15e::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Tue, 8 Mar
 2022 16:39:43 +0000
Received: from BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:112:cafe::e4) by BN9PR03CA0317.outlook.office365.com
 (2603:10b6:408:112::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14 via Frontend
 Transport; Tue, 8 Mar 2022 16:39:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT012.mail.protection.outlook.com (10.13.177.55) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5038.14 via Frontend Transport; Tue, 8 Mar 2022 16:39:42 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Tue, 8 Mar
 2022 10:39:40 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mlevitsk@redhat.com>, <seanjc@google.com>,
        <joro@8bytes.org>, <jon.grimm@amd.com>, <wei.huang2@amd.com>,
        <terry.bowman@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [RFCv2 PATCH 00/12] Introducing AMD x2APIC Virtualization (x2AVIC) support.
Date:   Tue, 8 Mar 2022 10:39:14 -0600
Message-ID: <20220308163926.563994-1-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a7cc6a0-b9e4-44b7-68e4-08da01223f14
X-MS-TrafficTypeDiagnostic: DM6PR12MB3163:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3163DBF97CBCBEF45FB74141F3099@DM6PR12MB3163.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vilGkCKKlxpBoJpYZFiMwJxykjoXB4odxhHwrjMjGXlTISi8p/Mokam994igYC2rhu3JCNo87bVanZ84z8/t8CdsUA+eXoTr6MhRs8vLbwzW1h/rPDAH340fP1T+RfdSnQQKcqNEJNzN5jiMYpVJ/ONGW/tdwOYm4eE+Q/XvVEmY0BicRWpvJcq3jlLDuZ0Tx/mX2n3IG0nyV47AHziFMHIo33RKGbgHlKmTwMlHc+MjsQ4mdUhjx6syogEnb8Z7TZohpu5iwCbFkfpTBynTc4hg5jsg70YJCPShVsOttKrrUNJJUQhquSOdnuAzvYnr5J6bk7TjG6AMogT9PDX7MvTzTK0V4GahszaaTCYsMjoRi/WdCQpr6ODhOPVzTZ29PIZ3R9fyWkEh6d6htQPzYfAKTmhHRO2J2M0AUtbXrP0+GaXZHloa5XpqwMgaQWNkfBEvvmfm9vEqEhtX8zSwa+1nWhaQ6gewA2i+8i4zlP4FH6PLdtFtigqUoxngBnou0JF/lwkJ+Km3yr/US/Ky4LJQgYa+TfGXO29XCHN7DoJMlKLfgegpAXtcSgOtPUEtSoV/qyYNT2k7GReeFtAM41SOhstocuD4UXWuRvv+KWKip3q4un1jpzyxo/S8InUFcRfnh5IkfnRSHUvz2wTTdiy50MYGOeEZom6J3w545G//OaV5/8V30qmjlVqxhSHwcPraFHYRVdZWf4rWQOJXG0YrXOPXHx/alSIu9olj+x8ovyWibZPAYoc6soZJNnqeBvluoo7eBHEITo6sJ3TiwGuiSS49JAsYqU81GWGW3zQ=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(426003)(336012)(16526019)(6666004)(40460700003)(2906002)(36756003)(26005)(54906003)(110136005)(47076005)(186003)(2616005)(316002)(1076003)(81166007)(83380400001)(7696005)(86362001)(36860700001)(44832011)(8676002)(70586007)(82310400004)(4326008)(5660300002)(70206006)(356005)(8936002)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 16:39:42.4539
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a7cc6a0-b9e4-44b7-68e4-08da01223f14
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3163
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Previously, with AVIC, guest needs to disable x2APIC capability and
can only run in APIC mode to activate hardware-accelerated interrupt
virtualization.  With x2AVIC, guest can run in x2APIC mode.
This feature is indicated by the CPUID Fn8000_000A EDX[14],
and it can be activated by setting bit 31 (enable AVIC) and
bit 30 (x2APIC mode) of VMCB offset 60h.

The mode of interrupt virtualization can dynamically change during runtime.
For example, when AVIC is enabled, the hypervisor currently keeps track of
the AVIC activation and set the VMCB bit 31 accordingly. With x2AVIC,
the guest OS can also switch between APIC and x2APIC modes during runtime.
The kvm_amd driver needs to also keep track and set the VMCB
bit 30 accordingly. 

Besides, for x2AVIC, kvm_amd driver needs to disable interception for the
x2APIC MSR range to allow AVIC hardware to virtualize register accesses.

Testing:
  * This series has been tested booting a Linux VM with x2APIC physical
    and logical modes upto 512 vCPUs.

Regards,
Suravee

Change from RFCv1 (https://lkml.org/lkml/2022/2/20/435)
  * Mostly update the series based on review comments from Maxim.
  * Patch 2/12 is new to the series
  * Patch 3/12 removes unused helper function.
  * Patch 6/12 update commit message w/ the expected hardware
    behavior when writing to x2APIC LDR register to address
    a concern in the review comment.
  * Patch 7/12 has been redesigned to return proper error code
    and move the function definition to arch/x86/kvm/lapic.c.
  * Patch 9/12 moves logic into svm_set_virtual_apic_mode(). 
  * Patch 11/12 separates the warning removal into a separate patch
    w/ detail description.
  * Remove non-x2AVIC related patches, which will be sent separately.

Suravee Suthikulpanit (12):
  x86/cpufeatures: Introduce x2AVIC CPUID bit
  KVM: x86: lapic: Rename [GET/SET]_APIC_DEST_FIELD to
    [GET/SET]_XAPIC_DEST_FIELD
  KVM: SVM: Detect X2APIC virtualization (x2AVIC) support
  KVM: SVM: Update max number of vCPUs supported for x2AVIC mode
  KVM: SVM: Update avic_kick_target_vcpus to support 32-bit APIC ID
  KVM: SVM: Do not update logical APIC ID table when in x2APIC mode
  KVM: SVM: Introduce helper function kvm_get_apic_id
  KVM: SVM: Adding support for configuring x2APIC MSRs interception
  KVM: SVM: Refresh AVIC settings when changing APIC mode
  KVM: SVM: Introduce helper functions to (de)activate AVIC and x2AVIC
  KVM: SVM: Do not throw warning when calling avic_vcpu_load on a
    running vcpu
  KVM: SVM: Do not inhibit APICv when x2APIC is present

 arch/x86/hyperv/hv_apic.c          |   2 +-
 arch/x86/include/asm/apicdef.h     |   4 +-
 arch/x86/include/asm/cpufeatures.h |   1 +
 arch/x86/include/asm/svm.h         |  16 ++-
 arch/x86/kernel/apic/apic.c        |   2 +-
 arch/x86/kernel/apic/ipi.c         |   2 +-
 arch/x86/kvm/lapic.c               |  25 ++++-
 arch/x86/kvm/lapic.h               |   5 +-
 arch/x86/kvm/svm/avic.c            | 171 ++++++++++++++++++++++++++---
 arch/x86/kvm/svm/svm.c             |  93 +++++++++-------
 arch/x86/kvm/svm/svm.h             |   9 ++
 11 files changed, 262 insertions(+), 68 deletions(-)

-- 
2.25.1

