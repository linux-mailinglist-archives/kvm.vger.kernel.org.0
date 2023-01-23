Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1D4E678B21
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 23:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233400AbjAWW5R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 17:57:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231634AbjAWW5Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 17:57:16 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2059.outbound.protection.outlook.com [40.107.237.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C748112F2A;
        Mon, 23 Jan 2023 14:57:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ndEBiXyzPxK+PXA18xr43GOU+aqcBf1YgvSFjqVj8kwAJhuWxpt0Br2pK1mTbkA/rpJC03gLdHi/X0sQR3P2Sg7oRnUoe6EFlxDZnSeKbqfYnDaMD+28ctwCb7bLBgzaIXJaxLB6iJuyhMmMrhQfMWR9Rz+ahr5AmpI32o1yqQd5g2FHf0ESWZ8fIL/ehrgqdsBnjvqNCd1VeTBUO0ezz8FQWGsYFNlV6AgMxAKiiJjea027JpT9u0nxA1GB6ACrQyjjzVskQa5qX5B+S/VRC7k3EWOa99nt9XcGkSMGq43yzDN8/8CofBEY4GLoOK62pcxzjSrtqaOXTofBjxBx4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RPG3Bts0JmFdi5wqksSVDt9p8JrnLTYYQoE4GvS6sVc=;
 b=NBmoiRTiNzVoe65t4Gyu4Hzo/D4wQyTebOg2QkhjFQDopn/z/KfS+Lw0+Zi5MCyGjn7CSkhUIHEG1ifAjheftmcDBqKSin4TG0NEEpIMOyNOniKzdk/tSTPFEk7aAgC3Hztn8zfR9gfzqP+GSmeJdl9GXCctnGdodQBDXtC1zp4oKIFk1YowvGA2h1C1vCbmWQ9a9iiefpCer+jgGFE0RBP2QFFgcFnmqMK0JUwBRPbQ92x9UxMAqAXWY9ubEqdzxL5H6bke1rgJB76nHuMBOD1MYZ72HfxiXO3mzpSPJ8qlLbormyi4309hu/JUu8idqzjDdJZFFvKLroYDxRbx+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RPG3Bts0JmFdi5wqksSVDt9p8JrnLTYYQoE4GvS6sVc=;
 b=bfGgivcE/XtAzMyGw+jIqHf9L8n+5QHfMlQdOzyxappY1DDh3aRYfhcdweDefqH43sXOIfsSVWIi/Ol9aLlvA/g5bj6UxpoEuZ6VrLiwwmEz9zsMyn3g3JcvC5VYzm6Cyv+nWarzG008xjQBwwCCJEl2MFlHymfYEkR038gcfMo=
Received: from BN0PR04CA0047.namprd04.prod.outlook.com (2603:10b6:408:e8::22)
 by DS0PR12MB8413.namprd12.prod.outlook.com (2603:10b6:8:f9::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.33; Mon, 23 Jan 2023 22:57:11 +0000
Received: from BN8NAM11FT114.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e8:cafe::52) by BN0PR04CA0047.outlook.office365.com
 (2603:10b6:408:e8::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Mon, 23 Jan 2023 22:57:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT114.mail.protection.outlook.com (10.13.177.46) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6023.16 via Frontend Transport; Mon, 23 Jan 2023 22:57:11 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 23 Jan
 2023 16:57:09 -0600
From:   Kim Phillips <kim.phillips@amd.com>
To:     <x86@kernel.org>
CC:     Kim Phillips <kim.phillips@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "Alexey Kardashevskiy" <aik@amd.com>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v8 0/8] x86/cpu, kvm: Support AMD Automatic IBRS
Date:   Mon, 23 Jan 2023 16:56:52 -0600
Message-ID: <20230123225700.2224063-1-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT114:EE_|DS0PR12MB8413:EE_
X-MS-Office365-Filtering-Correlation-Id: c703b377-f91a-4cdc-ce72-08dafd952973
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ohU/IikmTK0xYflYOGDkkJp2gFHaNl5Y4AvWW1TuOnJrSH/PzMN2Pxlr8eDK5HTWpojOmRMXFnlhA1Z/c9QjrFASzVxcfR7GGAt/eE79XOTdAJ2bAW/dcgz0xRLzlN+sQiwgJCrK5DPpfM91Z2YnFJ0hBUzNzONm+JBeiAV6Y11Te2kUgtJ4go2KPGJ4rvIG7Bt+Io9VD37eOCPfOh4OHV2f9usSMzNY5wNFq1I5wizQS7/dFesdzNlfdLxVYzZuS7pXQgmhxSR593aP+HN/hrrhD3EvwuJ4jfzCm5sQVJ3g91z7NlUgBeXHrgjfOTb3Yd7dvPX1mQvMmRiH2QM3HdJKesADSeg7Mb6CTsfBLQ9vS6CXkEhupb/gCyRslSO+9JdMI2j81zrfymhuFz9lcjHvjrRZNdpFD+0/DE/8x4mXXdCpIkrIptHxKZWlb30aBbrguT5ynoSd6yILX5HVVrEP4YC2J5j8rI6pUN/W4yBZmbor31AyWMv0Q13jwM3zAGSNQAuZU1Sgy4K8ztD/Lm+etUJXXzmgMnldkIVt0X+t1ykiJSrM+5033wDxrdAAhWBjZ6L2FsgVv0YtkWTKkolJvr3pi0gvnf5iFS3qfUlwipXSVh4KHV6W4FvobF5LXZu3zQfw1qaqS5RR8SlKoex78Zg/XmEhJ+s3Gtb4NJD6XsBg2wvVoHYNI+cK+z7KgYBFkgPBWVmXaI6YWGOReb7fsLZI2bocLphNw8VbvvY8b3Y8OW/gUeLS2P72b1te+WLlh4enrRRUxFTKTlMjp8AAixkJckYRYDfyzU8/FilljvHmVZabJauH/PsYbyn7
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(396003)(346002)(376002)(451199015)(36840700001)(46966006)(40470700004)(36860700001)(36756003)(316002)(4326008)(86362001)(70206006)(8676002)(70586007)(6916009)(54906003)(16526019)(186003)(26005)(6666004)(40480700001)(83380400001)(7696005)(478600001)(966005)(356005)(336012)(81166007)(2616005)(1076003)(7416002)(5660300002)(44832011)(47076005)(40460700003)(8936002)(41300700001)(2906002)(82740400003)(426003)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 22:57:11.3287
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c703b377-f91a-4cdc-ce72-08dafd952973
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT114.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8413
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

Patch 1 [unchanged from v7] Adds support for the leaf that
contains the AutoIBRS feature bit.

Patch 2 moves the leaf's open-coded code from __do_cpuid_func()
to kvm_set_cpu_caps() in preparation for adding the features in
their native leaf.

Patches 3-6 introduce the new leaf's supported bits one by one.

Patch 7 [unchanged from v7] Adds support for AutoIBRS by turning
its EFER enablement bit on at startup if the feature is available.

Patch 8 [unchanged from v7] Adds support for propagating AutoIBRS
to the guest.

v8: Address comments from Sean Christopherson, Boris:
    - Move open-coded cpuid leaf 0x80000021 EAX bit propagation code
      in a single step/patch to avoid CPUID bits getting cleared
      by the open-coded ANDs coming after cpuid_entry_override().
    - Includes changes Boris made when committing v7 to tip/x86-cpu, i.e.:
      - Removing "AMD" prefix from feature comment text in cpufeatures.h
      - Convert test in check_null_seg_clears_base() too.
      - commit message changes

v7: https://lore.kernel.org/lkml/20230116230159.1511393-1-kim.phillips@amd.com/
    - Add Dave Hansen's Acked-by to unchanged patch 6/7
    - Change patch 3/7 to not bother to set MSR DE_CFG[1]
      if X86_FEATURE_LFENCE_RDTSC is already set [Boris]
    - v6 went out with two 1/1's, try to not do that again

v6: https://lore.kernel.org/lkml/20230110224643.452273-1-kim.phillips@amd.com/
    Address v5 comment from Boris:
    - Move CPUID leaf 0x8000021 EAX feature bits from scattered
      to the new whole leaf since the majority of the features
      will be used in the kernel and thus a separate leaf is
       appropriate.

v5: https://lore.kernel.org/lkml/20221205233235.622491-1-kim.phillips@amd.com/
    Address v4 comments from Dave Hansen, Pawan Gupta, and Boris:
    - Don't add new user-visible 'autoibrs' command line
      options that have to be documented: reuse 'eibrs'
    - Update Documentation/admin-guide/hw-vuln/spectre.rst
    - Add NO_EIBRS_PBRSB to Hygon as well
    - Re-word commit texts to not use words like 'us'

v4: https://lore.kernel.org/lkml/20221201015003.295769-8-kim.phillips@amd.com/
    Moved some kvm bits that had crept into patch 6/7 back into 7/7,
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
      require the extra protection, but allow it anyway.

v1: https://lore.kernel.org/lkml/20221104213651.141057-1-kim.phillips@amd.com/

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
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

Kim Phillips (8):
  x86/cpu, kvm: Add support for CPUID_80000021_EAX
  x86/cpu, kvm: Move open-coded cpuid leaf 0x80000021 EAX bit
    propagation code
  x86/cpu, kvm: Add the NO_NESTED_DATA_BP feature
  x86/cpu, kvm: Move X86_FEATURE_LFENCE_RDTSC to its native leaf
  x86/cpu, kvm: Add the Null Selector Clears Base feature
  x86/cpu, kvm: Add the SMM_CTL MSR not present feature
  x86/cpu: Support AMD Automatic IBRS
  x86/cpu, kvm: Propagate the AMD Automatic IBRS feature to the guest

 Documentation/admin-guide/hw-vuln/spectre.rst |  6 ++--
 .../admin-guide/kernel-parameters.txt         |  6 ++--
 arch/x86/include/asm/cpufeature.h             |  7 +++--
 arch/x86/include/asm/cpufeatures.h            | 11 +++++--
 arch/x86/include/asm/disabled-features.h      |  3 +-
 arch/x86/include/asm/msr-index.h              |  2 ++
 arch/x86/include/asm/required-features.h      |  3 +-
 arch/x86/kernel/cpu/amd.c                     |  2 +-
 arch/x86/kernel/cpu/bugs.c                    | 20 ++++++++-----
 arch/x86/kernel/cpu/common.c                  | 26 +++++++++-------
 arch/x86/kvm/cpuid.c                          | 30 +++++++------------
 arch/x86/kvm/reverse_cpuid.h                  |  1 +
 arch/x86/kvm/svm/svm.c                        |  3 ++
 arch/x86/kvm/x86.c                            |  3 ++
 14 files changed, 72 insertions(+), 51 deletions(-)

-- 
2.34.1

