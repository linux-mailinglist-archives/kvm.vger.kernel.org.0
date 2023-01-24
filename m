Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8C70679EB1
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 17:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbjAXQdk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 11:33:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbjAXQdi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 11:33:38 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2077.outbound.protection.outlook.com [40.107.244.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4193C2A3;
        Tue, 24 Jan 2023 08:33:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GgikWWuN7jygbV5ufL0fU+WaaTTlL4nCacp3z5ZdFzkiAWmdDV8XQJ7Hn9ol6jLrM1mC5nU1O5baNUORH5LRoqomkWUHWr2T0ON2/WapnhQf+KNKODu1WxdBoIlIf8l0B4e7/NLJQ4ySchZOdedcCJSqjhiBHdApJi4vlmvEuttCnGaDT47NLI5kh0JS62I3CSfIhaBeu5nYaLeMXllIALMkjfkpdXeVCpqUFBuVKCWO5QiFew4fjV4t3jOo47E+PaDzTwuqLpfIYXymps84h6lJoCUSeixb0EqXivoPgmhUvuKcFBft1n/IsEVGktxosMA6KkNGmPfPWycTEAb0gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pfrDpbFZOxQxlFhjetE3KzuLw9ZlXdCrt49kygt1DvI=;
 b=Ui6Rr0OCaR787aNgYQQiZjEp3TfaYdJVngNo7GcfbDyO8hI27Kvtxmm1chHzWuNfJrgMTUeKKJB1mFzhpsTrAyEkLwzpEqwBEZPy2bktx3CmEBJeqnP95v+lY4O7deTSRlGcnWM0diwSLsYcC2lahna2un8q6CJNXzLsF08QHGU46wuuINtNUlz3/0uXQWIZwUftWu4eSFbFBydmAvXHg8fItYjh6in7dndjWL7HVuxVUBog+6UbVq3Lv3+pO2ms0uTDQe+aFJ32t+PZcsaxw8kQGqh3BPhhm9nkIHcZ4Xe0p9tpTtiI0j99zKjouEJceCK4Jt9ClG1hshp6N4Km+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pfrDpbFZOxQxlFhjetE3KzuLw9ZlXdCrt49kygt1DvI=;
 b=iMc459clU0tcc9dZt2iz5sV8IzXR1PITf4g77EUfyMGHmf1S36nDldCOjbeRKChfym6G89e4qDb2lo8xCaXy6AlvYDIHNfe5Fe/ApZXIsoqp3/DIN92B2xktNDKA8Gxj3SZqAXEitYsqFLO6qwJRxNhyEbyFuXa8NnaNXI3iZkg=
Received: from BN0PR04CA0151.namprd04.prod.outlook.com (2603:10b6:408:eb::6)
 by CO6PR12MB5443.namprd12.prod.outlook.com (2603:10b6:303:13a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 16:33:35 +0000
Received: from BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:eb:cafe::1a) by BN0PR04CA0151.outlook.office365.com
 (2603:10b6:408:eb::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Tue, 24 Jan 2023 16:33:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT007.mail.protection.outlook.com (10.13.177.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6023.16 via Frontend Transport; Tue, 24 Jan 2023 16:33:34 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 24 Jan
 2023 10:33:32 -0600
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
Subject: [PATCH v9 0/8] x86/cpu, kvm: Support AMD Automatic IBRS
Date:   Tue, 24 Jan 2023 10:33:11 -0600
Message-ID: <20230124163319.2277355-1-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT007:EE_|CO6PR12MB5443:EE_
X-MS-Office365-Filtering-Correlation-Id: c2eb9f55-6678-492b-cafb-08dafe28bc91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pBxET91WpOqF7oXtrUDER0VEWwJoRuCb/1Er8cVTNRwvWHdCN1nXHmvPh1g3BK6qAPyStl03ev2IJ1oq7KE0znxdsBW3sINP0xNT1Jv+1YkvhLlTUtdcr9W0Mo0IELQtFBafH0I1FAVwnjh7RMLZhjV23cwBA/GHR1UcZd7ayVMwUfHii26HUkDh8PHtE0yxzPDu5SlatDCTMmwkZdGJKT3TnbRKB2skbppc97g+XELouBC+tbvijPS8ysHThVVMdOs6Z+vwlit6UjcoWJzdhxBAzy3Ut8PQPSrN8BCAq4k56O66KC/8/JbxizPChhVA5y3UhJYWvlenJmp42vUUUms4q4FoIBPO0aK/xXMSN+Ty3ba0C088TDtp4XwQSzMXZewOTazJTvSW8P+RohYdGgVvQYcr2BFKocevY5GXy7fhlANQGp9/z6DUVCCZc/9fuJuChWk7qC/I97io4O9Td9jEnPccLSisgbjz2hpVrK+n61FlIUSUoNStO5wXdQnJUVKtKzNbJiJBz2fnWET/WvfRjYRqxLRTzNHVT1C2wG/4xRQzuAiuBY+CVISGeBglW/+bLqVEUEnmfHCTXGx7cHWBC+fUyZS9Lt7KCAmZ3RUBlgH/orj43p4CdPX+KpozwVWHn7YKWvZQ3iLOk8+5X8MTd7yqE8v1Epj94eFM/uNeYg+1vyodhMYR7jo11wZsHWvKf7VT1MBfmMnc7uJCYbiGvuJNm5lD+UJShDGgp5od2XEtNQAE6JqhrUvLyQ2YZATYRnTG7nSWxdpjqCTse6M0SdVlud7dd7YjtMS1J+12Eg42CsIqjKxNDsN+QZm+
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(136003)(396003)(376002)(451199015)(40470700004)(46966006)(36840700001)(36756003)(356005)(2906002)(7416002)(82740400003)(8936002)(81166007)(4326008)(44832011)(82310400005)(41300700001)(5660300002)(83380400001)(36860700001)(86362001)(26005)(478600001)(7696005)(966005)(186003)(16526019)(6916009)(40480700001)(54906003)(40460700003)(70206006)(2616005)(8676002)(316002)(70586007)(426003)(47076005)(336012)(1076003)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 16:33:34.1696
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c2eb9f55-6678-492b-cafb-08dafe28bc91
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5443
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

v9: Address comments from Sean Christopherson:
    - Patch 1: "KVM guests", not "VM guests"
    - Patches 2 & 8:
      - Subject prefix change to "KVM: x86: "
    - Patch 2:
      - Added Sean's blurb about the synthetic features to the commit message
      - Added BIT(2) /* LFENCE always serializing */ to
        kvm_cpu_cap_mask() in kvm_set_cpu_caps() to mirror true code movement
    - Patch 4: Removed the kvm_cpu_cap_set for LFENCE_RDTSC since the
      previous set_cpu_cap()s and kvm_cpu_cap_mask() presence will effectively
      synthesize the feature now that the feature bit is in its proper place.

v8: https://lore.kernel.org/lkml/20230123225700.2224063-1-kim.phillips@amd.com/
    Address comments from Sean Christopherson, Boris:
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

Kim Phillips (8):
  x86/cpu, kvm: Add support for CPUID_80000021_EAX
  KVM: x86: Move open-coded cpuid leaf 0x80000021 EAX bit propagation
    code
  x86/cpu, kvm: Add the NO_NESTED_DATA_BP feature
  x86/cpu, kvm: Move X86_FEATURE_LFENCE_RDTSC to its native leaf
  x86/cpu, kvm: Add the Null Selector Clears Base feature
  x86/cpu, kvm: Add the SMM_CTL MSR not present feature
  x86/cpu: Support AMD Automatic IBRS
  KVM: x86: Propagate the AMD Automatic IBRS feature to the guest

 Documentation/admin-guide/hw-vuln/spectre.rst |  6 ++--
 .../admin-guide/kernel-parameters.txt         |  6 ++--
 arch/x86/include/asm/cpufeature.h             |  7 +++--
 arch/x86/include/asm/cpufeatures.h            | 11 ++++++--
 arch/x86/include/asm/disabled-features.h      |  3 +-
 arch/x86/include/asm/msr-index.h              |  2 ++
 arch/x86/include/asm/required-features.h      |  3 +-
 arch/x86/kernel/cpu/amd.c                     |  2 +-
 arch/x86/kernel/cpu/bugs.c                    | 20 +++++++------
 arch/x86/kernel/cpu/common.c                  | 26 +++++++++--------
 arch/x86/kvm/cpuid.c                          | 28 ++++++-------------
 arch/x86/kvm/reverse_cpuid.h                  |  1 +
 arch/x86/kvm/svm/svm.c                        |  3 ++
 arch/x86/kvm/x86.c                            |  3 ++
 14 files changed, 70 insertions(+), 51 deletions(-)

-- 
2.34.1

