Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3D7472B6E
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 12:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235967AbhLMLcT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 06:32:19 -0500
Received: from mail-mw2nam08on2079.outbound.protection.outlook.com ([40.107.101.79]:52705
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232749AbhLMLcS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 06:32:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VV2l2Lepu5XIsabAxa5HYOSYp2BJYmdIRbquTFamM4ckrmawLu0/yr7hija2LanqXD/l2Bl6qgeYvO8yY09MoPbI4a3IPPrnkExfdnUb18sF4FUwEOWrjjlbslZrgMlkpgyn0mMxqwhUvnxrDrTXkPW7ptgs+87y5sC50rvITMp/6gEDS8d5svQkAyAMyZR8WWQXz2x6Gz2fja2Y+Qrr8ltLZKDjZnZkUMgduvb3/cXCo+fEYfrOtv/s8boVGhuC7mgPnwwXSdEuW5VgJM9Mt7/DyNsOEFDf2izLbaqq2keMJySuSgkbfQpZ/xGY57XFMAXgORotKB95aryrM6Ta3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2TwO+zIaGMKRh9ZF95gwdAPRUqHELfD2NDIk+oFHDZE=;
 b=fOqnlNCFgOl5ekqQdfT40iBQ4Y3gsvXXDD8AuTTFo1RanDX33j4TkxMwjDB0AZTSOhlgQ69GrO32yqO/YcS9G+LFTqv6y7PWSSYqCVpMe9y2yEM3ir4XqeekoN267zGFGpqBb5RnFkJRPbFBUTeqw/9OTA1pjCyvp996T7gcCXNM7qy1n/zKcTcQXI1o6kt2NujHZVBYC2xnn3dvBHDFbWjV0KWAmQELhhoGJYmpD3QhK/x60SrRN110OkkfcyAqi0T1QSaqbA2f9PXkh0u3uh9sjkFzUObK+GMGIruutOHUjaxEbCrSUrbjBe16t3MQuuth8sY6bn2osEIRUtFAbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2TwO+zIaGMKRh9ZF95gwdAPRUqHELfD2NDIk+oFHDZE=;
 b=kAVRav1aE7FK8+5VhySoLoJBJ50OgjDOQgc3mPezmF3RbyYFh+av2fOnEE71mJ2Rh66pjuJub8DZgs7eb3nMh260J9hnlLavgWlBx+lxezhbm9onbW/95frFXmT/ZWI/rzYD97ERZcCmjecG4n5D0YBP+AneAwe9vHth9Wzqork=
Received: from DS7PR05CA0049.namprd05.prod.outlook.com (2603:10b6:8:2f::27) by
 DM6PR12MB3930.namprd12.prod.outlook.com (2603:10b6:5:1c9::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4778.13; Mon, 13 Dec 2021 11:32:16 +0000
Received: from DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2f:cafe::4f) by DS7PR05CA0049.outlook.office365.com
 (2603:10b6:8:2f::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.12 via Frontend
 Transport; Mon, 13 Dec 2021 11:32:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT040.mail.protection.outlook.com (10.13.173.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4778.13 via Frontend Transport; Mon, 13 Dec 2021 11:32:16 +0000
Received: from sos-ubuntu2004-quartz01.amd.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 13 Dec 2021 05:32:15 -0600
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>
CC:     <pbonzini@redhat.com>, <joro@8bytes.org>, <seanjc@google.com>,
        <mlevitsk@redhat.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <bp@alien8.de>, <peterz@infradead.org>, <hpa@zytor.com>,
        <thomas.lendacky@amd.com>, <jon.grimm@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v3 0/3] svm: avic: Allow AVIC support on system w/ physical APIC ID > 255
Date:   Mon, 13 Dec 2021 05:31:07 -0600
Message-ID: <20211213113110.12143-1-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: efcc6290-26bb-465c-0062-08d9be2c3746
X-MS-TrafficTypeDiagnostic: DM6PR12MB3930:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB39306F75ED1CC0ED350273CCF3749@DM6PR12MB3930.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZsRP2h2RjpmHOiEiBiMLCzvLvgDqqOjG9bxxuGPhUBdgDN+QH1+8hsTQe35DcPon5zLbYR63nTG3SHDqeHzosVqFkQxT2rrMxBYlyTk5yHaxotwp4BBl4Jl6wV/FYc/ti9uaCBcmFoWBrMPx11U9b/sF26/Yhf5M+mpwbykKdW+3S97NBpNYdo1bHFrGqABKdCzVzdkGs+Pbkx0+s1w2QJOQq1c0GhWFjY6jxUUueYyn9Kgt20Pjdpqry26Oa4mycdr8+OyOzM0tye2SiOkZeaLRt7p07xWOxKAqWvkes+gkiLhdT++vn/CxsJMWA3uTwqdWCCgyv/I7OPlbossFNqgyh7X6yGldAA9QFY1uV8FdPWQgExYHfJp+E1SPoDSRcDzosO89hbn9523EIScejEwrOXj7CBDpSrBiqQ+BV6uXWn7LGDKAhgsX0mGvVQViAR0swQEmOA4QnCiayXcx6J7mjMirhALzZ3boPyGmN6/0BfTJkwCo6bMLweLYhGU7Rz7E/EoTDRut6BU2v68fj88BBDHFDCmfbAaAvAff5XrUEzreK0KLVacZEeUQdECZ5Ba/4Cu25KnElNb7855hrNfqZUYMWklC9s0oogotb+dd/rk/cLOhWp1eIlc7AaVS7mCVFxWdY4UOI2zZPc+rdtGJp8NEQIfqlCKo1Tg7ek43vQQ1oBU6O+9GmjOpqX4qQGLvZC0YGiaUULYm3uIjr1oKxd2IPUIxrstVkZbnXJxBGVH39yKpgc/7a+22djkjVEH3TNiy5j5XnmrxbRXNRLfcxxxCwkU0EQJJTNHW435NmysPBGKb5rcNA10bpa+LTjz2OVeeJ98LbIjEy5vkxmTO/lBVt25/Y+jV0UdBJ1peeQyGzNvVSm844pGBlTVt
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(110136005)(26005)(54906003)(86362001)(36756003)(2906002)(36860700001)(4326008)(47076005)(316002)(8676002)(5660300002)(508600001)(356005)(44832011)(336012)(7696005)(70206006)(83380400001)(70586007)(2616005)(16526019)(8936002)(6666004)(1076003)(186003)(82310400004)(40460700001)(426003)(81166007)(7416002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2021 11:32:16.4015
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: efcc6290-26bb-465c-0062-08d9be2c3746
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3930
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

Changes from V2 (https://www.spinics.net/lists/kvm/msg261351.html)

 * Use global variable npt_enabled instead (patch 1/3)

 * Use BIT_ULL() instead of BIT() since avic_host_physical_id_mask
   is 64-bit value (patch 3/3)

Suravee Suthikulpanit (3):
  KVM: SVM: Refactor AVIC hardware setup logic into helper function
  x86/apic: Add helper function to get maximum physical APIC ID
  KVM: SVM: Extend host physical APIC ID field to support more than
    8-bit

 arch/x86/include/asm/apic.h |  1 +
 arch/x86/kernel/apic/apic.c |  6 ++++++
 arch/x86/kvm/svm/avic.c     | 38 +++++++++++++++++++++++++++++--------
 arch/x86/kvm/svm/svm.c      |  8 +-------
 arch/x86/kvm/svm/svm.h      |  2 +-
 5 files changed, 39 insertions(+), 16 deletions(-)

-- 
2.25.1

