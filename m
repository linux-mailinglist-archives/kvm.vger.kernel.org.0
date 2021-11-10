Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E05844BE74
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 11:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbhKJKV1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 05:21:27 -0500
Received: from mail-dm6nam11on2086.outbound.protection.outlook.com ([40.107.223.86]:43008
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231301AbhKJKVY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 05:21:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V89wRff+Ee9H2nae6+azjrWAkzua/rBFjlUP4wu1vJ2f3xyCFNe9VwyxBLHfM5RXp1Njomz7LBL9TgZDhn9vQRDEOVmX5R2+2Nq9dpUmDXVS1NX8eB6B8BZ8w0eJgozne6tugB2kEAvJgRiePbVxkIXmzU3X/mNK4YTEQCivoivGwoAqugmXqzRjnvcmZ5DJdzy0hYXdEbJDCvfCWX/56YL6WYWQZI/QC81QzmSZQe5Gx+D8ql74j3hRL4Kd/gVTAVGMA+7SVRPeHAaqHtj3b+RwDop0EAWlMg1Hf1PcJhhzsSc1UYJBLQorNyhmXWCJgQprLV9/HAYpf2Vcs9OfsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H5J8ssTIU/OU5qPUZiOrKmwTeNzk6kwInLYfpFmL0uA=;
 b=nxidZqLNjR2uxeGZOsdJHotdv+kGD3Z8Yz7y/WpsDuCd9YTXDYw7buarkogXkQUlL8tZO77PHNx/KXI3yMBdCoqxlJ+cweh1z89eBsInzfJZLBIzWEa3UlT1H6YP4HW2pJkjls+94sq2OjXxRiKBPZNn6euCsL6P6GaMcMdokXd/MIGNljAhAuyE985sK9dcWqMvcmt9avlP2zh1gNChVMvgvC2M/EaK4qRJHOtXFf81Zftk3R39Um8JXDnavK+7maEGx18u2PwH8E7klLo6YvmDOwJWDw/cvboeYCgT43HVxuYxO6TerR27xcx/3QsFQgWSiWbskUmFlT6mWK/Yag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H5J8ssTIU/OU5qPUZiOrKmwTeNzk6kwInLYfpFmL0uA=;
 b=vseLOa/EdOX329Jn7GZuK4ctV1TgHTldvFNdEM4PK1EKqBOK0619qvr31wETH1PjyH62q1vMJ49XyE98cUzyaxNG7tKsFsFsuNvSIvuLBUEBqP5SUt2IjloTazd0tk/kxgyKMO26CM233SaeAZDW7Q+w0djv5TvuYmz8DFmc20Y=
Received: from DM6PR13CA0024.namprd13.prod.outlook.com (2603:10b6:5:bc::37) by
 BY5PR12MB4641.namprd12.prod.outlook.com (2603:10b6:a03:1f7::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Wed, 10 Nov
 2021 10:18:35 +0000
Received: from DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:bc:cafe::29) by DM6PR13CA0024.outlook.office365.com
 (2603:10b6:5:bc::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.6 via Frontend
 Transport; Wed, 10 Nov 2021 10:18:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT021.mail.protection.outlook.com (10.13.173.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4690.15 via Frontend Transport; Wed, 10 Nov 2021 10:18:34 +0000
Received: from sos-ubuntu2004-quartz01.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 10 Nov 2021 04:18:33 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>
CC:     <pbonzini@redhat.com>, <joro@8bytes.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <peterz@infradead.org>,
        <hpa@zytor.com>, <thomas.lendacky@amd.com>, <jon.grimm@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 0/2] svm: avic: Allow AVIC support on system w/ physical APIC ID > 255
Date:   Wed, 10 Nov 2021 04:18:03 -0600
Message-ID: <20211110101805.16343-1-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a92f3ed0-0a96-459b-e702-08d9a4337420
X-MS-TrafficTypeDiagnostic: BY5PR12MB4641:
X-Microsoft-Antispam-PRVS: <BY5PR12MB4641384B9611E16339E695F0F3939@BY5PR12MB4641.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X6l3Iq50ctwPx7SBd72OGl5fDZus3uA9QSMMhchl4oLi5xRYw2SzaiFuXriwRssTnBQ+sRq/jgSG5DN8dGgeLe4ysW0b5dK5kn3RFwMxmiqykzzOjuHM+o0BsM1SjRID3uT+4KCblLcOHWJxKe2R3UjcVoAti1J+G4K25hfn13bN0FJqRJRJ+ezv7ambkvZv7ntUcqc1d91Ut7tunFo54JLA+5DJjotRXtMTuI693/dCSP8cQQd+11GIc+DLMgUSsCaN+W6yiQQdsu8RH/A1D9YDQBquHwzd6G3i/DpUI6AvxiBlFVhPQBouzHZ4p46TtKYxw1MqTCSldQU87rvVnmooveVOB8loBeVAhJkSBENOFczwXXp64bi/caBPaibpiH/lSEPuW42qfQfLO1C5xVRZ+oIATjJHYrbhfmTHhOPF/f+zneaiVSbQbZbX8kZmcwTCq2ryS7L+qXw4Hj0tPfpQ0h+ddjC4Sn4pbbHnzAqYk0os9xhw+Mi9Lul+Vr6B/0SyQwAkXzLLq80Mg7oqaLShZoFo5os6c0T10A13mTe9TLE1dMfS/WF7dcr+i6jrVDlphQuHETwngXtoxPxNnbpnpYRtKQVE22ryz49cRVxrMDHhSXWXSXDrzFDYwA0Qa9bLCZET18BuM5PJZK4DpIEFZ8eTqanR+5IzS8CIe19vgV0D/JHLIPYbDCeuNRQtCFg3bYL/jsvVa5mJToYCoqvoYCc+h7oOvFvnSI2d5Rg=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(8936002)(1076003)(336012)(186003)(508600001)(16526019)(83380400001)(316002)(7696005)(4744005)(110136005)(2616005)(70586007)(70206006)(26005)(82310400003)(356005)(5660300002)(6666004)(4326008)(44832011)(47076005)(36756003)(36860700001)(2906002)(86362001)(8676002)(7416002)(426003)(81166007)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2021 10:18:34.7506
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a92f3ed0-0a96-459b-e702-08d9a4337420
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4641
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Originally, AMD SVM AVIC supports 8-bit host physical APIC ID.
However, newer AMD systems can have physical APIC ID larger than 255,
and AVIC hardware has been extended to support upto the maximum physical
APIC ID available in the system.

This series introduces a helper function in the APIC subsystem to get
the maximum physical APIC ID allowing the SVM AVIC driver to calculate
the number of bits to program the host physical APIC ID in the AVIC
physical APIC ID table entry.

Regards,
Suravee Suthikulpanit

Suravee Suthikulpanit (2):
  x86/apic: Add helper function to get maximum physical APIC ID
  KVM: SVM: Extend host physical APIC ID field to support more than
    8-bit

 arch/x86/include/asm/apic.h |  1 +
 arch/x86/kernel/apic/apic.c |  6 +++++
 arch/x86/kvm/svm/avic.c     | 53 +++++++++++++++++++++++++++++++------
 arch/x86/kvm/svm/svm.c      |  6 +++++
 arch/x86/kvm/svm/svm.h      |  2 +-
 5 files changed, 59 insertions(+), 9 deletions(-)

-- 
2.25.1

