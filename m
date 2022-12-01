Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0546D63E741
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 02:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbiLABu0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 20:50:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiLABuY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 20:50:24 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D9B900F9;
        Wed, 30 Nov 2022 17:50:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NRXaB6tYfqYpxUfbt1tlvI6K+syf6zZdT/iwZV0W+FOvEXdZ/LSvClD9901oHpBssqtg1655eI41vy4FBbK/rbMIWazVVLL+Ctg+y+8xzejr5gC4RWCk+3sNQtvNY/t1SI99dB2QUWtvzT061whP6djr7BQBHOVUCI1OPc6mOyLC3rDhv/5nz/PMsOGViZsjZxx+yPleSoTjrBZvcwU1L64y7tptG6bwVs4nKmlU7kY6TMxCIdhT9elOAHP0BViApTaFz+yEkINOGsN1BHqZVdueWZmkwl0kChX70+zDOEDmVc4L91dcTQpjK4/+Bcs3zYDrYf2tP6lL5FaGfZexeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xj4z/XsQfhRdIT3YZcbN9OdTZjLNTDWdqDrbZo4Qzy8=;
 b=jK03VnyvVwfehZ4Ma2iaH3O9LGYoOkREmZ939/KkODxZvaZXRM+AwZ/1OPQFOopuY1XxVqXdqospkquplRQhCAMlXwzy4tPQpYvcPOfxHHEI5VWjSKXTfBe/RWC1Z+0Dt6ZKkhujzN/3otPc5yxRuIbN8Rbj387w4BgNPpFXAey04LOeP75iDJJfCA1xcIJ2EWG+ptaSQPMwRtVilABggGJ799eiNNZvP82ZJThuZYSna+ZkoMPbzy558F9fabFf7gSCrM0XSZeDlQeegO5mOJb0vYgHKvtdMrJzSzRBeqH8E+2nPXT6mOfCnVaxRXLTm5gbQ44Q+9/gR5et8wNCCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xj4z/XsQfhRdIT3YZcbN9OdTZjLNTDWdqDrbZo4Qzy8=;
 b=F5mjWz/BK7pc2LUF+T4ivDcehHb5xmgEbBIqrdsTGxv8COOHdRQqSI0r1shE0ISzvLx+0Y3IAKQaH4FRaKYv9Gp9Wx+fsXWjk6bwNOAnIrHTUojcpdx7l1uOuWPiOxvH9M5PM59zEW21kaIPchYmz1sIihnGJ9cnNfEirtkTN2E=
Received: from MN2PR19CA0038.namprd19.prod.outlook.com (2603:10b6:208:19b::15)
 by MW4PR12MB7032.namprd12.prod.outlook.com (2603:10b6:303:20a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 01:50:20 +0000
Received: from BL02EPF0000EE3C.namprd05.prod.outlook.com
 (2603:10b6:208:19b:cafe::3d) by MN2PR19CA0038.outlook.office365.com
 (2603:10b6:208:19b::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.17 via Frontend
 Transport; Thu, 1 Dec 2022 01:50:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0000EE3C.mail.protection.outlook.com (10.167.241.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.8 via Frontend Transport; Thu, 1 Dec 2022 01:50:20 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 30 Nov
 2022 19:50:17 -0600
From:   Kim Phillips <kim.phillips@amd.com>
To:     <x86@kernel.org>
CC:     Kim Phillips <kim.phillips@amd.com>,
        Babu Moger <Babu.Moger@amd.com>,
        Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 0/7] x86/cpu, kvm: Support AMD Automatic IBRS
Date:   Wed, 30 Nov 2022 19:49:56 -0600
Message-ID: <20221201015003.295769-1-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0000EE3C:EE_|MW4PR12MB7032:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c3b3319-6bad-4d31-3301-08dad33e674f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vv8877LmUNK32X5td1swkJNla/7kKcBCewYxD2RCtbuRzuN760/PfMcPCe9wsHTq7YgrC9Vz0ApSuh5+G+wsbZjlHKQMh4Wu2LGavlC3SWSUiusNyoEuIivYQBW6xUOfAZVWzoEerpNtmlLpbXPQsUf39VOXeSZMlS7VR/gx7UCvewSdr8hOFOOttBQ94ClIWE07lTyEY8p9pZDM3TzgO8nKz01cXuyfOvEQNj3yy8m+pIIT+KmwVDaolYho0IEhLtZeUhamEgcp2ULISjd6BXQ4Khkh2jpqjFMfR2fXgWs4P+uPVXfEOTKDLopwrqlrtBQNKi7DDXjH23wEO5jZ3+Vf+ePXXPeu12X5cjTSYbG/BCWKTD2cOUI0I6FqGn8kZUcDLSu800RA9iOhOUrD9krwQKYc6ocD95QOkCXj2imnK2niboX28+VyDt37DaEuPhYoAPAGvu54dDcjJeRQq7mpgbvH9tBa34u7xgIvne6StN7cqhIgf6vVfrTBiopn2Zp9MCHB/itiuFQlXCwz7yOSNHjv5F97O64E2tGvEujAFJRvVgOiGt2BIByr7rLUuP19oj27y4MvH0UTMhBrm5HaBBgdllcHz1dsdyQFtEfuWYB6zbZOh7E/YAdsCV1bs0xWVNWvkR46NZn2tHWpu2aePbQQGDBpA7YmqC3Y8o6eD63IChC8u1c7J7v4oITk4VmdCJrd2d1/mWkKMQo1m2OPsH86iiIXw6eCZEf///wrXQENyeORCY2KTA58whWy1h8UTOsvzL0xlr01OVYS8w/VOYr/OHDml+am+pwFRdBVVFwzGn7ZEKjuCRA1VGJG
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(346002)(39860400002)(376002)(451199015)(46966006)(40470700004)(36840700001)(2906002)(7696005)(966005)(40460700003)(478600001)(40480700001)(356005)(81166007)(36756003)(86362001)(82740400003)(1076003)(26005)(2616005)(426003)(186003)(336012)(47076005)(16526019)(83380400001)(6666004)(41300700001)(70206006)(70586007)(44832011)(4326008)(36860700001)(8676002)(5660300002)(8936002)(7416002)(82310400005)(316002)(6916009)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 01:50:20.0241
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c3b3319-6bad-4d31-3301-08dad33e674f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0000EE3C.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7032
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The AMD Zen4 core supports a new feature called Automatic IBRS
(Indirect Branch Restricted Speculation).

Enable Automatic IBRS by default if the CPU feature is present.
It typically provides greater performance over the incumbent
generic retpolines mitigation.

Patches 1-3 take the existing CPUID 0x80000021 EAX feature bits
that are being propagated to the guest and define scattered
versions for patch 4.

Patch 4 moves CPUID 0x80000021 EAX feature bits propagation code
to kvm_set_cpu_caps().

Patch 5 Defines the AutoIBRS feature bit.

Patch 6 Adds support for AutoIBRS by turning its EFER
enablement bit on at startup if the feature is available.

Patch 7 Adds support for propagating AutoIBRS to the guest.

Thanks to Babu Moger for helping debug guest propagation (patch 7).

Also thanks to Boris and Paolo for their early version diffs.

v4: Moved some kvm bits that had crept into patch 6/7 back into 7/7,
    and addressed v3 comments:
    - Don't put ", kvm" in titles of patches that don't touch kvm.  [SeanC]
    - () after function names, i.e. kvm_set_cpu_caps().  [SeanC]
    - follow the established kvm_cpu_cap_init_scattered() style [SeanC]
    - Add using cpu_feature_enabled() instead of static_cpu_has() to
      commit text [SeanC]
    - Pawan Gupta mentioned that the ordering of enabling the Intel
      feature bit past Intel EIBRS bug detection could be avoided
      by setting NO_EIBRS_PBRSB to cpu_vuln_whitelist, so did that
      which allowed regrouping all EIBRS related code to one place
      in cpu_set_bug_bits().

v3: https://lore.kernel.org/lkml/20221129235816.188737-1-kim.phillips@amd.com/
    - Remove Co-developed-bys.  They require signed-off-bys,
      so co-developers need to add them themselves.
    - update check_null_seg_clears_base() [Boris]
    - Made the feature bit additions separate patches
      because v2 patch was clearly doing too many things at once.

v2: https://lore.kernel.org/lkml/20221124000449.79014-1-kim.phillips@amd.com/
    https://lkml.org/lkml/2022/11/23/1690
    - Use synthetic/scattered bits instead of introducing new leaf [Boris]
    - Combine the rest of the leaf's bits being used [Paolo]
      Note: Bits not used by the host can be moved to kvm/cpuid.c if
      maintainers do not want them in cpufeatures.h.
    - Hoist bitsetting code to kvm_set_cpu_caps(), and use
      cpuid_entry_override() in __do_cpuid_func() [Paolo]
    - Reuse SPECTRE_V2_EIBRS spectre_v2_mitigation enum [Boris, PeterZ, D.Hansen]
      - Change from Boris' diff:
        Moved setting X86_FEATURE_IBRS_ENHANCED to after BUG_EIBRS_PBRSB
        so PBRSB mitigations wouldn't be enabled.
    - Allow for users to specify "autoibrs,lfence/retpoline" instead
      of actively preventing the extra protections.  AutoIBRS doesn't
      require the extra protection, but we allow it anyway.

v1: https://lore.kernel.org/lkml/20221104213651.141057-1-kim.phillips@amd.com/

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Cc: Babu Moger <Babu.Moger@amd.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Borislav Petkov <bp@suse.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: David Woodhouse <dwmw@amazon.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Juergen Gross <jgross@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Alexey Kardashevskiy <aik@amd.com>
Cc: kvm@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org

Kim Phillips (7):
  x86/cpu: Define a scattered No Nested Data Breakpoints feature bit
  x86/cpu: Define a scattered Null Selector Clears Base feature bit
  x86/cpu: Make X86_FEATURE_LFENCE_RDTSC a scattered feature bit
  x86/cpu, kvm: Move CPUID 0x80000021 EAX feature bits propagation to
    kvm_set_cpu_caps()
  x86/cpu: Define a scattered AMD Automatic IBRS feature bit
  x86/cpu: Support AMD Automatic IBRS
  x86/cpu, kvm: Propagate the AMD Automatic IBRS feature to the guest

 .../admin-guide/kernel-parameters.txt         |  9 ++++---
 arch/x86/include/asm/cpufeatures.h            |  3 +++
 arch/x86/include/asm/msr-index.h              |  2 ++
 arch/x86/kernel/cpu/bugs.c                    | 23 +++++++++++------
 arch/x86/kernel/cpu/common.c                  | 20 ++++++++-------
 arch/x86/kernel/cpu/scattered.c               |  4 +++
 arch/x86/kvm/cpuid.c                          | 25 ++++++++-----------
 arch/x86/kvm/reverse_cpuid.h                  | 24 +++++++++++++-----
 arch/x86/kvm/svm/svm.c                        |  3 +++
 arch/x86/kvm/x86.c                            |  3 +++
 10 files changed, 75 insertions(+), 41 deletions(-)

-- 
2.34.1

