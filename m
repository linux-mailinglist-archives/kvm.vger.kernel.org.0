Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7E4643981
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 00:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbiLEXcy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 18:32:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbiLEXcw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 18:32:52 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2069.outbound.protection.outlook.com [40.107.243.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ACEE6543;
        Mon,  5 Dec 2022 15:32:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nBa5UdOsc5uKK2agFcTaKiExl8KE+t6HAP2bAau96ldDy7a5+QNww4DewMqT+OBdyEj0X5GLXi8GC422jDk+TSWG+cx2RcI4pfDxsBCLlmJSbGocJYfrtvoKHLhKS4IbsaVRvVeVEvOVyv6lGGalMj5QhxEE2kYxLEhd6hcZdJeMHZ6hg53CuKCoikcAxLh3+9boJRvgkSyZ8Cx1oNpISz+YtGN694mi/2bLDb2HBO5QOL9b6Ig4/s34phBnU90P+ddxEmdZMXKamaP2zLiYOXiBCe0UKmnQIunjnvvNuSN8Trjbil3d/8XNKm0vq7BNC7pxwg9+dTU1VTQj7Fw8cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oq+0Yzs6dxN6WQai/kZfnR0CZOdjFT4e6eXWc+J6wIg=;
 b=nnKHBPt6AlEcUZb9zXYJVaAvWfaXNnTAIhcN+vYsKk1ulCjKJLZBNxIDwSWXR6rm5U+RTHz4HsizFK8J4Yb+tr9evU+2KIuwmuzn9o5XAOP80WmJnNsPZC2MXEgKobm3LulXVmVliWIXGCCNbuwezWxxpkfv17kY7Ng4Dwm8osrajNHYeghQp58TbXORLkgvNSSzia8sHvTisUcAa3cLhGLlZ6sYqf+bGRUFdrEy9TQ12RHRHYBdZ6+ItRsGJu1Z4wvjzRr3mKnh67mlSIHZGf/0ezWi4gIQaYsbbZu+bltO3Cz6c0QXzQITkqxx4gMeQD+Xve7Yu1P+RJpHMtG9bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oq+0Yzs6dxN6WQai/kZfnR0CZOdjFT4e6eXWc+J6wIg=;
 b=HI7I11KJcLdPDO1E3oIms6kRNQNEfZ5D+c0j3W9LNJHL5shs35j0mV3VIgedrH2ZGkSFInlGgB0au52j4ITtndrI5+6CL+gOW8H9kw/0w6SsD0t0sOBWriCpdg/Y1VP6RMrrZf2u8xbEk3DtYk0BwaRRZXm9s7qPMf1saUXuHcM=
Received: from DS7PR03CA0326.namprd03.prod.outlook.com (2603:10b6:8:2b::28) by
 BL0PR12MB4849.namprd12.prod.outlook.com (2603:10b6:208:1c2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Mon, 5 Dec
 2022 23:32:45 +0000
Received: from DS1PEPF0000E643.namprd02.prod.outlook.com
 (2603:10b6:8:2b:cafe::83) by DS7PR03CA0326.outlook.office365.com
 (2603:10b6:8:2b::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Mon, 5 Dec 2022 23:32:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E643.mail.protection.outlook.com (10.167.17.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.8 via Frontend Transport; Mon, 5 Dec 2022 23:32:45 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 5 Dec
 2022 17:32:43 -0600
From:   Kim Phillips <kim.phillips@amd.com>
To:     <x86@kernel.org>
CC:     Kim Phillips <kim.phillips@amd.com>,
        Babu Moger <Babu.Moger@amd.com>,
        Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@amd.com>,
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
Subject: [PATCH v5 0/7] x86/cpu, kvm: Support AMD Automatic IBRS
Date:   Mon, 5 Dec 2022 17:32:28 -0600
Message-ID: <20221205233235.622491-1-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E643:EE_|BL0PR12MB4849:EE_
X-MS-Office365-Filtering-Correlation-Id: e72ec5f1-ee38-476d-b685-08dad7190316
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a1R0WiFAkDexnESh1NiHEygwqysjntnjgstvDzUkaKCKyhvil/+T7RSUT5hElDnKxOGJulealFwR3zAzKQn8TCn5PMQKKoGJzG81Ilzue+VPYIFRZwbq+swil9Fo31WubsZ+NHXsz8NCCp+3Wz6PXtsGA8y+UzVIqtS1fMfrF0aPJKROmB/1Wu7ZlGCEbirvrpi1g38jneh3ws8T0JkHmqhEre51S7KrhD2sz6ANP99LtXxr8GD+1CEwrvcxi6GRPL1sxB9QboTZSXw0LKwS5S63m+VJR9zWiUfUwzSt1BbEVvEdA/eyKR56tDaN3NcZ+WWKckYYvhAdIEs2zHWEmiqMuSfgu2KXOl4SumWPIQLcuCf1L0SxWATJFKfx8tminF/J7FOQbQVqfZARwX5PVZJbadwIy321zX5OfI9o/oQcmoDjmme0KOU4LVadTY36j+cQ6oHQhKFJXo1U6IbhiRXVBA5VEY6c4t6yZZRjZGSAfVga8VsXVxDTUvLeCVnPMyO08pIInvPJ8t2x88/4S/0kiELRzpL6O4y852tfGAHuPLzQ32As9jxa2nOh4tRqUCUTVaUqpEXOuV6mC5GsZbI7i1rqyJsTpAcA3j8wGdAIGKeYEVf17seo8sLAgqefiJLH9JmqmNCQZ36yfculfOrmkeaANB4oE4vISky64oJvkaBRy2gpHvmNDQUhiJXCFp0e5O1Q7tATmzCywCvuqMe0/WZkxGJBYT4J0HNZdlM5Ucd7h4tSm9McjMfIFi1I5QUV/spx1eioQNRaGU8di93mQQC6/1W+zgcvR7CMjbpl554SnqM9jheWh5Pe6Gk4
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(136003)(376002)(346002)(451199015)(46966006)(40470700004)(36840700001)(83380400001)(36860700001)(86362001)(81166007)(82740400003)(356005)(7416002)(5660300002)(44832011)(2906002)(41300700001)(40460700003)(8936002)(4326008)(8676002)(82310400005)(40480700001)(26005)(186003)(7696005)(6666004)(1076003)(16526019)(47076005)(426003)(336012)(6916009)(316002)(54906003)(2616005)(70586007)(966005)(478600001)(70206006)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 23:32:45.0602
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e72ec5f1-ee38-476d-b685-08dad7190316
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E643.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4849
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

v5: Address v4 comments from Dave Hansen, Pawan Gupta, and Boris:
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
Cc: Babu Moger <Babu.Moger@amd.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Borislav Petkov <bp@amd.com>
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

 Documentation/admin-guide/hw-vuln/spectre.rst |  6 ++---
 .../admin-guide/kernel-parameters.txt         |  6 ++---
 arch/x86/include/asm/cpufeatures.h            |  3 +++
 arch/x86/include/asm/msr-index.h              |  2 ++
 arch/x86/kernel/cpu/bugs.c                    | 20 +++++++++------
 arch/x86/kernel/cpu/common.c                  | 22 ++++++++--------
 arch/x86/kernel/cpu/scattered.c               |  4 +++
 arch/x86/kvm/cpuid.c                          | 25 ++++++++-----------
 arch/x86/kvm/reverse_cpuid.h                  | 24 +++++++++++++-----
 arch/x86/kvm/svm/svm.c                        |  3 +++
 arch/x86/kvm/x86.c                            |  3 +++
 11 files changed, 73 insertions(+), 45 deletions(-)

-- 
2.34.1

