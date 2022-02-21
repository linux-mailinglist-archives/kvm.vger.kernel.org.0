Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A56DC4BD3D2
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 03:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343594AbiBUCXV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Feb 2022 21:23:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343563AbiBUCXO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Feb 2022 21:23:14 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2045.outbound.protection.outlook.com [40.107.244.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9388A3B2A3;
        Sun, 20 Feb 2022 18:22:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KbcdxaawS9L3cj/gObv6T+gndMU4yBNN8X42/rB6gK7qEMrfNRgkgvawwBER5viVlMW3ZyJGwfT+aW/72D67u10WpVmJaD6UgiRBE/CKRQnuLYaM5lrnF+dgw6mqJp1VW4P2Uh9R/2J5M5fXw2zam+qBIB98Dkq4Q88aYA+OrEq7V4XHCb6nHaY42NP5TuDSWMEaMck/ueGXCIqe5tyuiJaEOo3BRulvn5Apar/xw7QvqR9R6gPLcbWhEZELucw9IlJIKef1T8LdL5zi7Or/eX5iKVSTQ48HHO1vikIK65lOX9tNsp2uaH9V+fU+OhAGob/vrYu6sVSTbsp0ZJ31TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zfpGwzmO7gmU+3tZa3lf4CE4iatWWboCiyBvHOIyZbI=;
 b=lVrROKVUS31MH8iekwIq8OEW7DSsVjKwUKOqQP2Sj+duKnYd53sNhPjRisY5JTCGMMyVgnHBQE1Gw6qIUwi44tihECMvZ54NV2u5YT7pBMKJUEvld4qEspQXTXyMEml3YMEnWGHa0qaJkdg/XIng+q5175W04F88hGuFPiczQ04KMC0UWiMTpLgQ7JE0ZzMOI6ejvRoaqy6svTFM9f1qbXChgISQL0HaEvp24YBYMF9ndxsgXI0LmQcMm3GJ669ujGw7d8lh8Iqvpp8CKvM/ELL0GL3uWfMXvpq1KSAvmOVlzFmI6xN2SlX6KJJCY4h4xBZlGqBiGoyg2u2BlHR0cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zfpGwzmO7gmU+3tZa3lf4CE4iatWWboCiyBvHOIyZbI=;
 b=sxeqJ4n72CHH5eM5+SuSQhrgcsYyCqy5aBgFQwenj77q92iCrHuNC9ndJedug1HQ6hpsHVQM2OisScE3C3kmMuiQOty5LeQYGOckQ8AYQmvFITlQ8e6mbDdoQH1vte6ZYOwiApakL0b+sujCgcEKinMo6jcvfvDk0HqTRBGSCoM=
Received: from MWHPR1401CA0024.namprd14.prod.outlook.com
 (2603:10b6:301:4b::34) by MN2PR12MB3117.namprd12.prod.outlook.com
 (2603:10b6:208:d1::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.22; Mon, 21 Feb
 2022 02:22:44 +0000
Received: from CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:4b:cafe::f7) by MWHPR1401CA0024.outlook.office365.com
 (2603:10b6:301:4b::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24 via Frontend
 Transport; Mon, 21 Feb 2022 02:22:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT027.mail.protection.outlook.com (10.13.174.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4995.15 via Frontend Transport; Mon, 21 Feb 2022 02:22:43 +0000
Received: from sp5-759chost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Sun, 20 Feb
 2022 20:22:41 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <seanjc@google.com>, <joro@8bytes.org>,
        <jon.grimm@amd.com>, <wei.huang2@amd.com>, <terry.bowman@amd.com>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>
Subject: [RFC PATCH 00/13] Introducing AMD x2APIC Virtualization (x2AVIC) support.
Date:   Sun, 20 Feb 2022 20:19:09 -0600
Message-ID: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d340e69d-8266-469b-baef-08d9f4e10b12
X-MS-TrafficTypeDiagnostic: MN2PR12MB3117:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB31172DDF31C26968AE49C324F33A9@MN2PR12MB3117.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R7/RxPQLXnNdQS72sI7UwzvWcvO/Tqvnx43ExWTGLEJAk+KNvAyzPWk0ho2vU0AR1WedoirQeVhJSE3fw98Kztrgv+2PVKr+f/3bvYNKmWm/fxLWDFuvaiOMG5oop1ey3om8Jjq/tGDhc2PjZpMiILHCvHiugXGurhRU1RVlSLmVdQ9HYYgYiDJ4bnROfPY7MMXqBhMVXmJax1F0AiQrgPSTNX2HqdUXNcpqUYHCKwWcm0ENLEjtPxV1dlhmv15DVNmkPzcm4Ou70qyYJt+Cmqxrm1mXPes08xg1TyKYb8C3wd2YLYRCTHvq+cyz+S2dXaKoGHt5lB6af6oQ9QA2YgHvu34XZ/OWv5/N6p2HKEKOlZzSb918qa+HQfa6cdFxbVlgjtD2Y6HKtq7vZaowgyzX6PQK/Gh+FPzzBgqcSBWKMshFcA55Mqhq+hWExKbFtBJJi2OE6j/O98uhNXfu7nhpUCK1eHYheDKOV5/n+092Ald48wZuoCln+a6v4k8mPRtnkjH4LqHHUf8xyIkvhjslOV+nswo1Ow3/oGtaG8lJmDCfgIPH9zSTqthX8CCTB/LUXonDbXixBSEkBitW5H78r4zxkWmsGMAZg9NseLXxFEOyx8BMAM/Hypxequhw8gl4wlbbonnPpVoIawfKixN8jydSAyooQ5VYFIhOp3MvVf0PIdr2BvP0uFp8jstSoDq0GoeyVeFzO75C39ybDg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(36756003)(40460700003)(7696005)(6666004)(508600001)(47076005)(2616005)(2906002)(36860700001)(16526019)(5660300002)(186003)(110136005)(54906003)(8936002)(26005)(1076003)(316002)(44832011)(82310400004)(356005)(81166007)(86362001)(336012)(426003)(70586007)(70206006)(83380400001)(4326008)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 02:22:43.8356
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d340e69d-8266-469b-baef-08d9f4e10b12
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3117
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
    and logical modes upto 511 vCPUs.

Regards,
Suravee


Suravee Suthikulpanit (13):
  KVM: SVM: Add warning when encounter invalid APIC ID
  x86/cpufeatures: Introduce x2AVIC CPUID bit
  KVM: SVM: Detect X2APIC virtualization (x2AVIC) support
  KVM: SVM: Only call vcpu_(un)blocking when AVIC is enabled.
  KVM: SVM: Update max number of vCPUs supported for x2AVIC mode
  KVM: SVM: Add logic to determine x2APIC mode
  KVM: SVM: Update avic_kick_target_vcpus to support 32-bit APIC ID
  KVM: SVM: Do not update logical APIC ID table when in x2APIC mode
  KVM: SVM: Introduce helper function avic_get_apic_id
  KVM: SVM: Adding support for configuring x2APIC MSRs interception
  KVM: SVM: Add logic to switch between APIC and x2APIC virtualization
    mode
  KVM: SVM: Remove APICv inhibit reasone due to x2APIC
  KVM: SVM: Use fastpath x2apic IPI emulation when #vmexit with x2AVIC

 arch/x86/include/asm/cpufeatures.h |   1 +
 arch/x86/include/asm/svm.h         |  15 +-
 arch/x86/kvm/svm/avic.c            | 216 ++++++++++++++++++++++++++---
 arch/x86/kvm/svm/svm.c             | 102 ++++++++------
 arch/x86/kvm/svm/svm.h             |  13 +-
 arch/x86/kvm/x86.c                 |   3 +-
 arch/x86/kvm/x86.h                 |   1 +
 7 files changed, 281 insertions(+), 70 deletions(-)

-- 
2.25.1

