Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71F8B63CC06
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 00:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbiK2X6h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 18:58:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiK2X6g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 18:58:36 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2052.outbound.protection.outlook.com [40.107.94.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB2A58BDF;
        Tue, 29 Nov 2022 15:58:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FFFeF0alVhw3eyGAxMxah9oad9MM3UvRmyCu8XT3aVRM1d+FYWTZ2pVhPK3hB48GN95w9bdWRUYoLfQvCXWOYxk0Sp5DiMcdEUzGm2UtAY5YpNZuWB4353gBvk9+EGQr6b5EKGDjS66hKPucqV6DSgCt+bMUM3Xs0UwAloEsYxAC80x+DvRm149sOWTBwEAtbNsBo7UfsSd2PFMN2kDbfkRhh8z6R8hPAEZtJPxhOUrrIkr1ZKeYbuxgCK/u8/7prYbQnjdhe4sg0TbQnS3rRqzJzEPgZLvZ9XHkoavrkN+8rkY7d6GdFAaYDt9j6MnXdemjMj0rPXoHCJ1j2Rmo0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I6+1bQw6PtXu1jmBzgBG1pBSV22ydrN9Y5mIUzgvxcY=;
 b=dhw7YJmwZ2lk4KTrBM5jMnh26C2oo+FglKF9cRcEH2Cl6WuQni3qgpC0U5vVY8eIdgfihkggEaT8yD8qi9w9r8Bn9m3cLY3NJz7EQ6Jl9/kUseYsa5oO/QLG9oGi2WZiVydBLUjIUm5JJzrWxh3fJBqaqBZ5xWjBGelDbm7OSYCyJ51YypB/50QD7UlxVn26AoAuHiZ23i99AuJFa1SaUj+9whmiEzh2M4HRl/ajVopgXY3DD7J+4cppjaZIWsmIPMHpewiGG21+6JTC+FNaK2rlkUcwZ//mubfnDKE6YlQCgXC7xq7Mjfebh05w0OszGgqMTXyfLpcyhkEfkOCwWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I6+1bQw6PtXu1jmBzgBG1pBSV22ydrN9Y5mIUzgvxcY=;
 b=ODXMpsOQ39Nog4kpsztpRdNy/tMbURn7AqlfJUDh3eJppCqDcnOLv4hZqcCtMkppfxWgWO1OrO9Or6oLJC2x95DJ6VnznKWRljf3N+BnkmkhI/pXwGkb//LYqrqOwJgJEzF7Wpjb1dB5VNHfr6oSFUNFZovtosSq6OFsPEKsYP0=
Received: from DM6PR17CA0018.namprd17.prod.outlook.com (2603:10b6:5:1b3::31)
 by MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 23:58:32 +0000
Received: from DM6NAM11FT075.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b3:cafe::64) by DM6PR17CA0018.outlook.office365.com
 (2603:10b6:5:1b3::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.17 via Frontend
 Transport; Tue, 29 Nov 2022 23:58:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT075.mail.protection.outlook.com (10.13.173.42) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5857.23 via Frontend Transport; Tue, 29 Nov 2022 23:58:32 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 29 Nov
 2022 17:58:30 -0600
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
Subject: [PATCH v3 0/7] x86/cpu, kvm: Support AMD Automatic IBRS
Date:   Tue, 29 Nov 2022 17:58:09 -0600
Message-ID: <20221129235816.188737-1-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT075:EE_|MN2PR12MB4192:EE_
X-MS-Office365-Filtering-Correlation-Id: de5e2818-69da-432a-b805-08dad2659ece
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ipHAQqLKekv+7mFhLhYZrEl0Vs46LDW+hrcji+7QNjNXe7Xgexhyemg0Sc0u5xIotagFVWEyL/Q55hWCavZ8sU5R/w6ZOqhrynPgBTM1PqNVedFJMou/gxVWTLaSuQzgfVioISgsia6FUzLrhM3JJ5R/6hH5WdFenpFrSdXBl04syuvRJUwo79LKFVXuaFQjAATr+ELHli3vSULqEsYkJY3gXkeTiNhvXD+WwKZDTNB80mxYnjU4yUV/0CUMUJBBNfYgLoziZhQK35audUXvbTjHE0WswqGCw5JvLUAU3IK7pwJ0PQL7VMFjVhjwa8t0kzR2KlJn5RriTjACjkJy1t1xPKeGde4uBeVPTVCZPxd1NfsBBe82B3oiABxtVmoTbNuBWpByyq4oR+ZXdijC/nEYI0+Zy3l9aBcGSbSHasglWBFb6LYSdAesne7IZfrtejfeITuYigwrVn1uKNoTdqWgRO/AxsC6rRbPCZc7V+sccjh6c3A9UHSWORENB2NnBsUlujoaEyD8p5jcE3uXA8+j3uMdjKTjqK/IqfM3aBYgjIwx+Verir32VGdqdSFy6ZSNzpBsV482e+8C79gEAXABjgAs/WW3CuN9XN9BH9xlBvfslZHI4BF5R1XMCDXvFLx9VUF6iRboXR3Ev3qtP9xubQPiWR9U47RoUymMZ6ds2b05WmXtwpIy2a+VuGkS7rzMVHNLxyCDICLk6zBhErVtormqBPdgOlwqoueSe7BX5zZAq5GbGX0vtrmL0UpqXfYEJrhX03RDHJhop2eVA3Chh9a69ggdstvUIhSR6PjIup6cgJ4QJRrzAoqzZASJ
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(39860400002)(136003)(451199015)(40470700004)(46966006)(36840700001)(47076005)(426003)(5660300002)(44832011)(7416002)(40480700001)(54906003)(41300700001)(26005)(6916009)(316002)(2616005)(40460700003)(186003)(336012)(16526019)(36756003)(8676002)(70206006)(70586007)(4326008)(82310400005)(81166007)(356005)(8936002)(1076003)(82740400003)(2906002)(83380400001)(36860700001)(86362001)(966005)(7696005)(6666004)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 23:58:32.3442
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: de5e2818-69da-432a-b805-08dad2659ece
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT075.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4192
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

Thanks to Babu Moger for helping debug guest propagation.
Babu, feel free to add your Co-developed and Signed-off-bys
to patches 4 and/or 7?

v3: Addressed v2 comments:
    - Remove Co-developed-bys.  They require signed-off-bys,
      so co-developers need to add them themselves.
    - update check_null_seg_clears_base() [Boris]
    - Made the feature bit additions separate patches
      because v2 patch was clearly doing too many things at once.

v2: https://lkml.org/lkml/2022/11/23/1690
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

v1: https://lore.kernel.org/lkml/20221104213651.141057-2-kim.phillips@amd.com/, and
    https://lore.kernel.org/lkml/20221104213651.141057-4-kim.phillips@amd.com/, and
    https://lore.kernel.org/lkml/20221104213651.141057-3-kim.phillips@amd.com/

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
  x86/cpu, kvm: Define a scattered No Nested Data Breakpoints feature
    bit
  x86/cpu, kvm: Define a scattered Null Selector Clears Base feature bit
  x86/cpu, kvm: Make X86_FEATURE_LFENCE_RDTSC a scattered feature bit
  x86/cpu, kvm: Move CPUID 0x80000021 EAX feature bits propagation to
    kvm_set_cpu_caps
  x86/cpu, kvm: Define a scattered AMD Automatic IBRS feature bit
  x86/cpu, kvm: Support AMD Automatic IBRS
  x86/cpu, kvm: Propagate the AMD Automatic IBRS feature to the guest

 .../admin-guide/kernel-parameters.txt         |  9 +++--
 arch/x86/include/asm/cpufeatures.h            |  4 ++-
 arch/x86/include/asm/msr-index.h              |  2 ++
 arch/x86/kernel/cpu/bugs.c                    | 23 +++++++-----
 arch/x86/kernel/cpu/common.c                  | 11 ++++--
 arch/x86/kernel/cpu/scattered.c               |  4 +++
 arch/x86/kvm/cpuid.c                          | 35 +++++++++++--------
 arch/x86/kvm/reverse_cpuid.h                  | 24 +++++++++----
 arch/x86/kvm/svm/svm.c                        |  3 ++
 arch/x86/kvm/x86.c                            |  3 ++
 10 files changed, 83 insertions(+), 35 deletions(-)

-- 
2.34.1

