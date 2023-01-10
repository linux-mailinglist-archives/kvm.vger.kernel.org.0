Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D30D9664EF3
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 23:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234326AbjAJWrL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 17:47:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234011AbjAJWrE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 17:47:04 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2072.outbound.protection.outlook.com [40.107.92.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F581C438;
        Tue, 10 Jan 2023 14:47:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DB8QDW1CFqSWgGTAgQaSBRzsmpGOiYFCmgyO7iYwW1sPyaYVVZx8Ldo/jqrxlkIGhjHSW6QGkdK8Ro++R8H2IYQPzpnERQ/F2GpUwvn7UeJpIrOMUQzI/6X38pIpU0O4EvYH7bZQyXr96EPGj9S0qlkB3x1nlIT1gczx7ovTRJXPpPfEBzyeOWgw92kGJOUzdY9XeWVv+X4FixoJnrsGzOxf19o4+7E3Olmbfmo+J3sVuGP7vCqGhM/vA4r3GQ/YmuvwG9JW+WxAqtiDmKkNPkt5/jBhwWb3PZNJjXGajE+EpcnDZ0Q11ApYcsEUpEYHkTZ2gZU/wJSYGVbwtoMA7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Kt261YnFbX/ILXuVpIcOLG7v05S1XAQmXH6bQtbdh8=;
 b=TpjO60thJHio4jXnQhpDPJfP8WhgQ/oi36mnTjdNiwo4jw3ZqcDV9OMd2dAhywrn5qADtnWzOZTqRV9jKKXEGYUSFJUh8hnjP0sL+jxQDPQ6lHQ6ehYrBO5JwabUZdDSASXTwZPV5XOkM+zMWY/txxJj3Wrf80Tb+/L7FhIuQclFKT4X5ZCO2NucQCfwpKj+V7omQk0a5VZhJPAg3a6iNotb5EarIcO7LNZHTYNq2zdk1xW6P7MFwl78GmyofhJrruioX8xCd6AZ/To9kM/9NKYulo2vbhcl+tgpYBvaqtXNOXsU9+p+7mdTW5m35n/VcHDblX3o4cAPyZmorCbOEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Kt261YnFbX/ILXuVpIcOLG7v05S1XAQmXH6bQtbdh8=;
 b=yWSAF/tHUul54IUiLrwKGvV+gOqa6kTeT5XtLzHhCPNsB9LX/LurdC7KOUWPY6ZL8p3O0zSsY2r6V07heDWmm9ARn1ZTTUTUVlrTJL5p4q9ln6AFXinnizanYSaLJm204JBqIkL4hcet9350+IuRvW1oK0bVmYA29gAy9YlH1o4=
Received: from BY5PR17CA0030.namprd17.prod.outlook.com (2603:10b6:a03:1b8::43)
 by IA0PR12MB8325.namprd12.prod.outlook.com (2603:10b6:208:407::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 22:46:57 +0000
Received: from CO1PEPF00001A64.namprd05.prod.outlook.com
 (2603:10b6:a03:1b8:cafe::a0) by BY5PR17CA0030.outlook.office365.com
 (2603:10b6:a03:1b8::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18 via Frontend
 Transport; Tue, 10 Jan 2023 22:46:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF00001A64.mail.protection.outlook.com (10.167.241.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6002.11 via Frontend Transport; Tue, 10 Jan 2023 22:46:54 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 10 Jan
 2023 16:46:51 -0600
From:   Kim Phillips <kim.phillips@amd.com>
To:     <x86@kernel.org>
CC:     Kim Phillips <kim.phillips@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Borislav Petkov <borislav.petkov@amd.com>,
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
Subject: [PATCH v6 0/7] x86/cpu, kvm: Support AMD Automatic IBRS
Date:   Tue, 10 Jan 2023 16:46:35 -0600
Message-ID: <20230110224643.452273-1-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00001A64:EE_|IA0PR12MB8325:EE_
X-MS-Office365-Filtering-Correlation-Id: 27c7fe41-d990-4386-7acd-08daf35c9293
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JSKD9VlZ6Sr9gcmuAbXqPVn40s794wVkwCh2mBmV1+v1Bg7iIGXwwUAFmmtsYf3cWodiRkY1XbYJInsfb3nOJwQJpqFWOvTQguwLwUTggscPwrq70xv9RiCgy0pOKqg2tcRum7V+FVetF8zYxFu5KgIaW4OonCVL+RqaMjbc8zHoGGsKp46f0MOmBlnqd4KHxA+yHPEY19rDWpX6mgqI8cny/JU7bvo9mJ7np8sSxPVbG3PGJFKAbJ89vAYV3KuseZ/zqmMuTGWgjWteOwzBWxUvTa70XWt20XStrOMz3Sbg4UCZcfTSbPc1uTBarnCoG/27e66azSlTTlsl2ikNrulQIYyzyCgWpi91vVf82hBwnpbFzlJbRs7w/Mxqqt4cyhSHHdEg3suGzfbOTflEPdSAK/K0rGlcw/l+TK11zYQLgTLG3NhEhq8jUsxKLw6D3nAoUCmhRR/EMBVFxvxJDS30cPPkl7+w0I92dsoTpRzvUHRrnpalf17GI0AmRYTXf3la+wM0AW1yCc2OhXT+NjoyEBXkuo/nlSFnLn5WFxsMTiK2+frH5xQ4EGC8LJjxL1V5QsvJA7q7DLMcfmNfepmOoqUaD73pOwVkD1ib/B8QbYLkmjJSi5tpy5BJPlxyw1RdgcHzJFyr/XEcso47DK/rtXs8GXvueea2jqegbxS9Sru3TWxj2XE8wtLsgR9zUOrJYjfPvNiZFLLFXXj6pZjDwhFu+vIhyyZqxa0TGL3Hk8OWf6fI6ZlND93g9SBMJBIJ2222ph0i5eGNY7s9HA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(451199015)(36840700001)(46966006)(40470700004)(6916009)(356005)(81166007)(36860700001)(70206006)(86362001)(83380400001)(4326008)(70586007)(54906003)(8676002)(40460700003)(426003)(44832011)(8936002)(2906002)(5660300002)(316002)(7416002)(16526019)(82310400005)(1076003)(336012)(47076005)(2616005)(186003)(966005)(508600001)(26005)(7696005)(6666004)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 22:46:54.6619
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 27c7fe41-d990-4386-7acd-08daf35c9293
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF00001A64.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8325
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

v6: Address v5 comment from Boris:
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
Cc: Borislav Petkov <borislav.petkov@amd.com>
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
 arch/x86/kernel/cpu/bugs.c                    | 20 ++++++++-----
 arch/x86/kernel/cpu/common.c                  | 22 +++++++++-----
 arch/x86/kvm/cpuid.c                          | 30 +++++++------------
 arch/x86/kvm/reverse_cpuid.h                  |  1 +
 arch/x86/kvm/svm/svm.c                        |  3 ++
 arch/x86/kvm/x86.c                            |  3 ++
 13 files changed, 70 insertions(+), 47 deletions(-)

-- 
2.34.1

