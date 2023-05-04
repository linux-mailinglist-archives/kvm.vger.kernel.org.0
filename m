Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 489966F778B
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 22:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbjEDUzN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 16:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbjEDUyr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 16:54:47 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on20628.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::628])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 866769EDB
        for <kvm@vger.kernel.org>; Thu,  4 May 2023 13:54:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J1nmoKdzqa4n+OInhA6uVbcbU6ekjxvMHBxJYo2pVXAsiQea7AdPRV/OhFHuu+QNBRwRbBu88yyBIKS8IEzz0u60Cv5YXoo0fUdIX1wpufST7RqIHAnTETfyyDkF06mnR/ynMLKbhFkRP8TNjmaO9pDMvk+Kr+nGpYBfPLMHoZ8q+FVDddxGie//WVNv05S/sblsQtfJEOd4MRXc56CTV70m8ozrQqB4rQDPmFsN4rpENhrkXFmGihOjI0pjhz9afnE85kNgRcTb1EYPY56Vrfh/3PaCdolX41SoNqYZjgTWebTPFFg/zhUZaf37IPLLKhu+AXduTjf5iOpVBFE5Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q/61EDjxQjnEgveD1OOw1GjU7f2wXAypzPTMo2T3a08=;
 b=ZDsc4Bt6CPd8zund+JWPCFyljc3VveVdIeqsvjYOEcdo4N6VkrkwexggITpJI8YwJ5We4zx59EFuH3Ohk3itDpTvRdRbv+riJNCQZdhkJw4CUWOsMpUrWnTgQQwI2zEX5sXe/7NhM+3uLmeRlw8ehHQmFJGH3RDuMbaOKoI8uDNnoz/7mBEqWc3He1an0VuXtLHplVxzC2KA3YNWAEYmji1Kh2awJzL3DjcnobBixfepYk+sHSX8IppU6MzPk9YuPPwS9xAtCxd8g58bYhso1BfjZ2kzE+FSX5z9LVuehsrd52RUQQ9j6eEBjTA9MbkZzqD9ua5AmeJwmUr2C8qJtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q/61EDjxQjnEgveD1OOw1GjU7f2wXAypzPTMo2T3a08=;
 b=EVuv0MFwO3IhmggXI0q8ThCIt+VlG6/FIUc3jshUOwKXHbYldlFiEIrbO+AMZciFpnd7Kwkw+oWmU5TAWbPMHW7zz7wlGLqdhAwANiavZeoVWKYaBWwl49EcHCfRVNB2lw+JPjgDhynYFVhTRGCQhRkycg+cNpefQsdaJHIf6Yo=
Received: from MW4P222CA0008.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::13)
 by DS0PR12MB8415.namprd12.prod.outlook.com (2603:10b6:8:fc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26; Thu, 4 May
 2023 20:53:28 +0000
Received: from CO1NAM11FT098.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::91) by MW4P222CA0008.outlook.office365.com
 (2603:10b6:303:114::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26 via Frontend
 Transport; Thu, 4 May 2023 20:53:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT098.mail.protection.outlook.com (10.13.174.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6363.26 via Frontend Transport; Thu, 4 May 2023 20:53:27 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 4 May
 2023 15:53:22 -0500
From:   Babu Moger <babu.moger@amd.com>
To:     <pbonzini@redhat.com>, <richard.henderson@linaro.org>
CC:     <weijiang.yang@intel.com>, <philmd@linaro.org>,
        <dwmw@amazon.co.uk>, <paul@xen.org>, <joao.m.martins@oracle.com>,
        <qemu-devel@nongnu.org>, <mtosatti@redhat.com>,
        <kvm@vger.kernel.org>, <mst@redhat.com>,
        <marcel.apfelbaum@gmail.com>, <yang.zhong@intel.com>,
        <jing2.liu@intel.com>, <vkuznets@redhat.com>,
        <michael.roth@amd.com>, <wei.huang2@amd.com>,
        <berrange@redhat.com>, <babu.moger@amd.com>, <bdas@redhat.com>
Subject: [PATCH v4 0/7] Add EPYC-Genoa model and update previous EPYC Models
Date:   Thu, 4 May 2023 15:53:05 -0500
Message-ID: <20230504205313.225073-1-babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT098:EE_|DS0PR12MB8415:EE_
X-MS-Office365-Filtering-Correlation-Id: 65f29cb6-31e4-44fa-50c0-08db4ce19c20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aNFlu+GoQVmQdhP/hfFhZdZS32zPtwfsaJzdMKlOAFIp8Sqxka3/bz7ILRc69gngjeMOvaFKWWz5SM4QCR9qV4KntAPNYKzcluipmQQOCRg+2kWHPuWjRjp1BjFQQLd3ISe2CqZv5+WNaaGQx6uf5evmoOHNwRHUDB8TdlKqBDlBRRDbVOnsVNJSPflmbqE+gt5cux5OUYxpr+fpUkr+f1wYEdrmbn2YAlBFApvsjPlTPFfPMBQMUBlNMLWVnUug2VXF97auVbypuYeaG7XUt8eT3S1hEZAYyUObwmj870w+qyxqr3RO0QX2ALP+GKI5704vZacrqG5azjQSr2UwLeZCShALH3egRf+SjhEMQ9BwyHIj3VZoKrnbUFubfD4Zlhyj8GIU63uWLk6pjlsYX9zCXQaDIUu90eErpj6cIp7/OKfsibx3jlolPvWG9htsEyGjBVq5YViSWdjd49PPZwPOvYZ1wB/OFlPTUA7X09i2Lfrpk/P+AgFAk/SIRYSnhbynHaKzo/dsqnLWKQJtp1wV29n14vLrvD+qeebpty8OGKVzVBcfB9x1fDzzhu5PGrRw9KCpcASINmHuPZIAWwIffW1nVovgk3whbSXazGd9yxPfmDy9oLhScrTjf3x5s5dO6NwTJeqt5f1iqPpcrwQSHLE0j0I23kuCzE2WIgVwI5JaHV00O8nhJsVnihPt3o1jchoWOdTlUTH2bdUuj1Ilt0Er1611A1eoGZ4faNPLnPpV0kVISt8Q9RyNH4s9cHPNnhjnMuMwaneVc5mwKm+HXJQmhlZ2COmknFkiwh4=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(136003)(39860400002)(376002)(451199021)(46966006)(36840700001)(40470700004)(1076003)(16526019)(26005)(186003)(2616005)(966005)(336012)(426003)(110136005)(54906003)(83380400001)(36860700001)(7696005)(47076005)(36756003)(6666004)(40460700003)(316002)(40480700001)(5660300002)(82740400003)(2906002)(478600001)(15650500001)(4326008)(86362001)(7416002)(8676002)(44832011)(8936002)(41300700001)(81166007)(70586007)(82310400005)(356005)(70206006)(170073001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 20:53:27.1742
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 65f29cb6-31e4-44fa-50c0-08db4ce19c20
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT098.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8415
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series updates the AMD EPYC models and adds new EPYC-Genoa model.

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
v4:
  Minor text changes and function name change in patch1 (Robert Hoo).

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
v3: https://lore.kernel.org/kvm/20230424163401.23018-1-babu.moger@amd.com/

Babu Moger (5):
  target/i386: Add a couple of feature bits in  8000_0008_EBX
  target/i386: Add feature bits for CPUID_Fn80000021_EAX
  target/i386: Add missing feature bits in EPYC-Milan model
  target/i386: Add VNMI and automatic IBRS feature bits
  target/i386: Add EPYC-Genoa model to support Zen 4 processor series

Michael Roth (2):
  target/i386: allow versioned CPUs to specify new cache_info
  target/i386: Add new EPYC CPU versions with updated  cache_info

 target/i386/cpu.c | 375 +++++++++++++++++++++++++++++++++++++++++++++-
 target/i386/cpu.h |  15 ++
 2 files changed, 384 insertions(+), 6 deletions(-)

-- 
2.34.1

