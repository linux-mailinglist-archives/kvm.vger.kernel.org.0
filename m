Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41FF66ED287
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 18:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbjDXQeg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 12:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbjDXQeV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 12:34:21 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2050.outbound.protection.outlook.com [40.107.223.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B99D8
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 09:34:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BXm//fJrOq6AwQmiku44jW+pnOOTgjAnvn/zVZeNB3ROTvMOI9QRg08Q97CJ6ziNY4FL2/LnAewounRDXRYUGTiDfFDnysSBNVLMtStD37+s6X6WX0gepZ/VZH1V4oPbdmoaV+TSs0MTPHKw/iBjgQ30ZIOsi5gqY0XzRAnwVEY5IyeyQRrbYWAxz2wubEffiFD1CXcaaFHVHH+TxFkGP+a5I3tcDMkEiCN3g6rPmg+n/dOsJZo4zmn80AxekDReUK1VVXPKYpv3rDrfvoyioHYyYMJqjpB/NE5gVqDfa3pSzIxclfyeg1fJr8CR4diQlaO73I3LFDhwGZe6VbdxQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LWsXwchhkVOYokOGWubGZ7CyhtinkOMsqErSxMxIBbU=;
 b=JAImdy5jSuuCALkKQXiMm/rtPBWUcD722xtrmfAi9dWiIOzUU/JvGx13xE1J+pt0oeid0fhLVKoeAC1/Su37RDFCekWfYZeeVyx0bbep7O8GURE/8ngIJTqcyxD+Pe7jtRvY2vdq/tABxx0kpqEr6IPPZ2n9pCthsjo8jpM/Ho2qP8aB2OIVPBq1Cdmpwrxibyms/llijJ8XRgLHtQlvq83i949Bo3RcaguJ6gPBVza8z5+LtQF2LxcNa54HuIF92N7c8Ib/iJJfxCiB9JgmbwuRrFOLZ9pZgXvnlfac/fYd5egzsqIIRQAUNgaDL6mF/JrfMMJD3tebMJ73V0xzeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LWsXwchhkVOYokOGWubGZ7CyhtinkOMsqErSxMxIBbU=;
 b=23nydJX63daFzqQOv+kbbVUO/YVMsPNigdf2lpcM1fGzUpk5jjuQ36GbeSAib0ci/mriIKxb8Na+EXL9MeFesuhFCtD8ehbZQaUllziEutKUR4liMtX/XouyRe3TuH2GKb7sThepJgj3ex2B71Bdt2ZLz30XLcVGNhH22OHa+g0=
Received: from DS7PR03CA0132.namprd03.prod.outlook.com (2603:10b6:5:3b4::17)
 by IA0PR12MB8982.namprd12.prod.outlook.com (2603:10b6:208:481::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 16:34:17 +0000
Received: from DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b4:cafe::4a) by DS7PR03CA0132.outlook.office365.com
 (2603:10b6:5:3b4::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33 via Frontend
 Transport; Mon, 24 Apr 2023 16:34:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT054.mail.protection.outlook.com (10.13.173.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6340.19 via Frontend Transport; Mon, 24 Apr 2023 16:34:16 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 24 Apr
 2023 11:34:14 -0500
From:   Babu Moger <babu.moger@amd.com>
To:     <pbonzini@redhat.com>, <richard.henderson@linaro.org>
CC:     <weijiang.yang@intel.com>, <philmd@linaro.org>,
        <dwmw@amazon.co.uk>, <paul@xen.org>, <joao.m.martins@oracle.com>,
        <qemu-devel@nongnu.org>, <mtosatti@redhat.com>,
        <kvm@vger.kernel.org>, <mst@redhat.com>,
        <marcel.apfelbaum@gmail.com>, <yang.zhong@intel.com>,
        <jing2.liu@intel.com>, <vkuznets@redhat.com>,
        <michael.roth@amd.com>, <wei.huang2@amd.com>,
        <berrange@redhat.com>, <babu.moger@amd.com>
Subject: [PATCH v3 0/7] Add EPYC-Genoa model and update previous EPYC Models
Date:   Mon, 24 Apr 2023 11:33:54 -0500
Message-ID: <20230424163401.23018-1-babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT054:EE_|IA0PR12MB8982:EE_
X-MS-Office365-Filtering-Correlation-Id: b62b92b1-c5ac-4eef-b74a-08db44e1bf17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QstI7LNGDzWlGE4Nov1Hv1QILilglG8NuIuyYnCtrMYzltXMlpgfjzzqPkqtDQAoAGtInUKmhsRkFeE2SpBMKmfsEqieAefNwpgu3/y5J+bN7jZIyEiQhrdCO4qqQ4SGl5MtUYCJx5cR+P63UIPAXDbp4JRE8euSlumy+2v4WlqRRHlmi1EXFO2GdWE6kRKV+DBTK/sWnsID1oUMjk4vp6piejJA/lFrmvW3pdb4I2Oin+yAuquNf3WQItQI3UDUmog/lL2NQVk78n+1oumYOs0l5X2XmHx4d1tRR7yvF+wqivV8NMjoD+wAH9j5zqhc6vHZOhiq66YeLsQ0zrEhO99EvZ/GbUOhHPQTP3btATSIDkV5FcXC2p3zIZtd9cFBUwzHF3o9YAX6tbfmrEG0Bt9+VIXf1E1YcFc8eVw9so7AQB3FSMLUwVieCzoTPOrp1gu/RXcpEdCwBYBVdw347Ryd9M13ipzW86/d81sofbvtqhd4wBVjB6fZVpnUe+JiT937+IlkCLOcMbGVkzStOo6ZywNQE4nULtmSLo4hnpEoO02DILjU6hUQy9BwyT+46XrblazM0tVsnZ3IBgDgZ9tSunGEI7xKUSouXSnAueX5cwO6Sn4EtLyaBzvClO7E7VYfikMuSCxrSCiGJFrChRYuOQftVkpwUvNv9veOBeykjPWRiciun3sybXGn00Fagix2D0V4X9wcYhg5nLH88nUNS1Rf3NawkpaJLo3RScVyRzeWQS4V9eu3tRRYVZwhYwm52b1uxp92NJPf3aJtV8ApwXUPDUD11RtJ1sBaf4E=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(346002)(376002)(136003)(451199021)(40470700004)(46966006)(36840700001)(36756003)(8676002)(8936002)(110136005)(54906003)(40460700003)(478600001)(4326008)(70206006)(70586007)(7416002)(40480700001)(15650500001)(356005)(44832011)(81166007)(316002)(41300700001)(82740400003)(2906002)(5660300002)(2616005)(86362001)(186003)(36860700001)(16526019)(966005)(336012)(426003)(26005)(1076003)(7696005)(6666004)(47076005)(83380400001)(82310400005)(170073001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 16:34:16.6608
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b62b92b1-c5ac-4eef-b74a-08db44e1bf17
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8982
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series updates the AMD EPYC models and adds new EPYC-Genoa model.
Sent out v1,v2 earlier but those changes are not merged yet. Now adding
EPYC-Genoa on top of that.

Here are the features.
a. Allow versioned CPUs to specify new cache_info pointers.
b. Add EPYC-v4, EPYC-Rome-v3 and EPYC-Milan-v2 fixing the
   cache_info.complex_indexing.
c. Introduce EPYC-Milan-v2 by adding few missing feature bits.
d. Add CPU model for AMD EPYC Genoa processor series

This series depends on the following recent kernel commits:
8c19b6f257fa ("KVM: x86: Propagate the AMD Automatic IBRS feature to the guest")
e7862eda309e ("x86/cpu: Support AMD Automatic IBRS")
5b909d4ae59a ("x86/cpu, kvm: Add the Null Selector Clears Base feature")
a9dc9ec5a1fa ("x86/cpu, kvm: Add the NO_NESTED_DATA_BP feature")
0977cfac6e76 ("KVM: nSVM: Implement support for nested VNMI")
fa4c027a7956 ("KVM: x86: Add support for SVM's Virtual NMI")
---
v3:
  Refreshed the patches on top of latest master.
  Add CPU model for AMD EPYC Genoa processor series (zen4)
  
v2:
  Refreshed the patches on top of latest master.
  Changed the feature NULL_SELECT_CLEARS_BASE to NULL_SEL_CLR_BASE to
  match the kernel name.
  https://lore.kernel.org/kvm/20221205233235.622491-3-kim.phillips@amd.com/

v1: https://lore.kernel.org/kvm/167001034454.62456.7111414518087569436.stgit@bmoger-ubuntu/
v2: https://lore.kernel.org/kvm/20230106185700.28744-1-babu.moger@amd.com/

Babu Moger (5):
  target/i386: Add a couple of feature bits in  8000_0008_EBX
  target/i386: Add feature bits for CPUID_Fn80000021_EAX
  target/i386: Add missing feature bits in EPYC-Milan model
  target/i386: Add VNMI and automatic IBRS feature bits
  target/i386: Add EPYC-Genoa model to support Zen 4 processor series

Michael Roth (2):
  target/i386: allow versioned CPUs to specify new  cache_info
  target/i386: Add new EPYC CPU versions with updated  cache_info

 target/i386/cpu.c | 376 +++++++++++++++++++++++++++++++++++++++++++++-
 target/i386/cpu.h |  15 ++
 2 files changed, 385 insertions(+), 6 deletions(-)

-- 
2.34.1

