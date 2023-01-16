Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D42166D26C
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 00:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235074AbjAPXCP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 18:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233570AbjAPXCN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 18:02:13 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2057.outbound.protection.outlook.com [40.107.94.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EAF9233D4;
        Mon, 16 Jan 2023 15:02:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RwMnxGHz445YrBT9xhxfggfCqJ0OnxqoRpevvUGbQ2cwVSOkK5RgAoAoyr+8AXj1wfEEfSay/mgGwt9JEnGsi9zDIsNOwNp2gAxjtM982EBePq4k5Eh/6eKVaubhQcedmSJpmg1tWrUu+5W6Y18qiNJmPDAZIm8dhp2JkJddFFLmcX10Q1TZV1Nmnv8Yg2Nf8KlDfJ8tnHAOL/xz/K96v69dMECJc1KQCF6KqfzJ6tNUZM/AsSMWMfcAjLnWpAmRnbYBX+vDwf/EGHwzscN8x3/Ycmwpn15DCj//gASvEajfAgfLS3oUAALUuFvOMzVU/M1tRpXxl6PRu6fZ/8oDKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BYtiquKxTlA/AZn4YbIID/gATHanB7cwpVurloRQqfo=;
 b=SYI2ePlkah2GRlAwU7K6leGZQKVBadURAO19GUUlLAZYGTg+m7GqXu6Jf1kLxGdHpLLveYKqsYbA2tKIY4b+Eij58HwdlpzjQ0xb6rjSe0Bzzs+tCcWjETc39foH+HWxOKLZ4atiY20yC5Uv44b1ssT+BkwPA1DlQtumCXRiaHBRs0ILQCD5iaTUoufzSgaZ1rHGyu3HMIbcrP+F1B9C1bKqSWUe96gbLoRFFe0huJhb7AUFs/Th+ilkMN47HNDXMN+e0TwSw8PtW0T86FV8DgLwzvQnsEI+YIEe8+v62tE4JxzfqIVW16nsypbEc3o+pzXLX4/3/BccY4j/8Zefxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BYtiquKxTlA/AZn4YbIID/gATHanB7cwpVurloRQqfo=;
 b=wJlhZU5WyDo7bMrZ4iONejJSDMLrGMGxQHy72IGB8iwvNBzBe6CYXIXJsoHcmWf9x5nHuO3F5NVVbxHrEFfzpvIyO2/qLAoT3DFDBFzDXuGL39ipqLisqSesli6sdTBBu6EE6SkjVpNO1KWyFFVfIxXAI50Z/BML5B8ALKmaGlI=
Received: from DS7PR05CA0070.namprd05.prod.outlook.com (2603:10b6:8:57::28) by
 DM4PR12MB5072.namprd12.prod.outlook.com (2603:10b6:5:38b::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.23; Mon, 16 Jan 2023 23:02:08 +0000
Received: from DS1PEPF0000B078.namprd05.prod.outlook.com
 (2603:10b6:8:57:cafe::2a) by DS7PR05CA0070.outlook.office365.com
 (2603:10b6:8:57::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6023.12 via Frontend
 Transport; Mon, 16 Jan 2023 23:02:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000B078.mail.protection.outlook.com (10.167.17.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6002.11 via Frontend Transport; Mon, 16 Jan 2023 23:02:08 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 16 Jan
 2023 17:02:06 -0600
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
Subject: [PATCH v7 0/7] x86/cpu, kvm: Support AMD Automatic IBRS
Date:   Mon, 16 Jan 2023 17:01:52 -0600
Message-ID: <20230116230159.1511393-1-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000B078:EE_|DM4PR12MB5072:EE_
X-MS-Office365-Filtering-Correlation-Id: 93b4baa0-ab42-485e-c91f-08daf815b1ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GRy/v5y3t5lhTTOjLtc+GjR3TDotqWMYGJt/3kFzkmncoBwuh9/1J0nCnu1gPRtPV+04GhBLhBsn9tJh2apXaBgAa69ylAH8DpjKmkjD5XkhLTlYWn2Tz2IwDHJss6banYSBf9QHRjV6Iqcb/ZPjaURSGcTngoWwI9kIUkHy9y+Y07CBfvkSAmHpodQGC4TtqEPZARF9NoAJv2MyGkn8NoxaVCPlse8rxlZ4QxI8dfu8zE778yomAppDQcSOsI6EvpLZ3QSOlHPri3fL9bpPyzSc/+2yG8k5OR9MEGH5OwGNcljR752DT6QLot4CTiAS8CZlyRK+FRqFsSLENHIBj1gg2y5XFh/myQgcrVgPHGFPjjiwJKivixHEYC7MQLGaiIhw12mB7O5OOgmCWvOuCmO8UpBOiJexs6p0oUpXYV8eZshEKLxCagXnsSd+JSL+NtmUIz9jDc9Vpt05ZuESBRu7Cnq0OYeblQc8RlRRwjOY0dUw9wuQJ7gunT2LMQ4UUHNLsJUMXuefexq9xLBoeOKoT116pL/bX6CTWjgM1tAXPYCD3jxuukhUJhMAS6wJKqxYrjULebDcOl5qaK6778gF9PKZuUkxBYN5ie5erbW9pTMgkcaDQA7s/FlG0g7HkmlaH3E3FgPgEA+QaswK01uu0xcLUk3mejJxPASM4wEIa8oJn3zD3X112WZaGNP0F98xNSz42j0n61f1EQL3XKG2L2WUIb+uHDmJZ6ybcyXXY3NHfOZyHH8qyNQfYsQ/i+76DhqmUDyyG2mo8dM6MrNY9NQnDNvN3eczTDRmjTrwlkPmnNzoyX+jiugYuec1
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(396003)(136003)(346002)(451199015)(36840700001)(46966006)(40470700004)(36756003)(82310400005)(70586007)(70206006)(47076005)(426003)(41300700001)(2616005)(16526019)(26005)(186003)(8676002)(6916009)(4326008)(86362001)(83380400001)(336012)(5660300002)(36860700001)(82740400003)(8936002)(6666004)(54906003)(478600001)(7696005)(316002)(40480700001)(1076003)(356005)(7416002)(2906002)(81166007)(966005)(44832011)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2023 23:02:08.4458
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 93b4baa0-ab42-485e-c91f-08daf815b1ac
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000B078.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5072
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

Patch 1 adds support for the whole leaf that contains the
AutoIBRS feature bit.

Patches 2-5 mainly move the existing features over from
scattered / open-coded in KVM into the new shared leaf,
where they match hardware.

Patch 6 Adds support for AutoIBRS by turning its EFER
enablement bit on at startup if the feature is available.

Patch 7 Adds support for propagating AutoIBRS to the guest.

v7: - Add Dave Hansen's Acked-by to unchanged patch 6/7
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
      options that we have to document: reuse 'eibrs'
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
      require the extra protection, but we allow it anyway.

v1: https://lore.kernel.org/lkml/20221104213651.141057-1-kim.phillips@amd.com/

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Cc: Borislav Petkov <bp@alien8.de>
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
  x86/cpu, kvm: Add support for cpuid leaf 80000021/EAX (FeatureExt2Eax)
  x86/cpu, kvm: Add the NO_NESTED_DATA_BP feature
  x86/cpu, kvm: Move the LFENCE_RDTSC / LFENCE always serializing
    feature
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
 arch/x86/kernel/cpu/common.c                  | 22 +++++++++-----
 arch/x86/kvm/cpuid.c                          | 30 +++++++------------
 arch/x86/kvm/reverse_cpuid.h                  |  1 +
 arch/x86/kvm/svm/svm.c                        |  3 ++
 arch/x86/kvm/x86.c                            |  3 ++
 14 files changed, 71 insertions(+), 48 deletions(-)

-- 
2.34.1

