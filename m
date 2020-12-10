Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA9FB2D6470
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 19:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404081AbgLJSFc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 13:05:32 -0500
Received: from mail-bn8nam11on2087.outbound.protection.outlook.com ([40.107.236.87]:25696
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392578AbgLJRL4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:11:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UDjxLR1VOiZEkpRvd1LHcGGmxP0nTXOD1EVs1URsU340VSm+HiCLLxJebMn2Mk87n/HI8CBkGOU+pe+ydAvrFfMaWtvkRPYIR4bLERo5uMUaY8qWnVq/yi/qOjiAr8IA1zVPMJoJ+DkP+dmq/tx88SHCJMRUsQvcurpZIBHDK5DtqP4FQEqxJu44Myt4aLp9ScANqzMwG3gHw0FTOoRfVuQK1rN1rGPiuH6CKa8sp88rG18lvRfReB8bnZxhEepRUR+eN3F3di0jBLl/dIdu0GR+Yha9XMZ0IpIau8CxpjBV8ucy84fZeJMDBY5omLFYYgEQeGDAT6ehpK9XtP4Img==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jIDSQVwBhceTkXrKGCJrfTL5U9e5STc9iqm9UuU3694=;
 b=Dybb8heY7SWuCik5fBpouj4CIBIxjihECg5Lgq4xktDwTOdRW+3kw5u40YCZUMB2Vy/hoJwY62Jx0J/+wP0oiUXWvj1+2gld+Zttu+8fxpG1kqQqQzAnJTQBdTqpHgSXtZjCa6hkj+K/yY9crkAthmMQxdBEMf19yqbc9c1wnlz7ZitdfPHO2zkyu5z0ZDWa0YRgNOigpeE+t8o6Ae5bitE/jgDreiszDUVkYhS49llSJCOpC41dcH2v7GawYpzvUHjGb5j6NCWS/qhEh3I0QLfKZj9029jZm7bLG3Ymplx0rU85vAviS1BnvQ2U8/Ujygo0hwggkbHepzYx/49e9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jIDSQVwBhceTkXrKGCJrfTL5U9e5STc9iqm9UuU3694=;
 b=RaPL/SkflB8LRrlDUl58Y7ylkGyIR/lXEK5m17/ZVaruES2QrHiLzqsALxxfPopOgG/fLe7bRZ9ZRuQeq8Lofn3htDKwQScpIXLQBSEYZ19pikf2uLgruVqxQmSV2RiSLuEl3s1Y9s5ZnGSM9iEzZ2h6m58J7DBkr2ymU+zrDbA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR1201MB0168.namprd12.prod.outlook.com (2603:10b6:910:1d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.22; Thu, 10 Dec
 2020 17:10:26 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:10:26 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v5 01/34] x86/cpu: Add VM page flush MSR availablility as a CPUID feature
Date:   Thu, 10 Dec 2020 11:09:36 -0600
Message-Id: <f1966379e31f9b208db5257509c4a089a87d33d0.1607620209.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607620209.git.thomas.lendacky@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR10CA0030.namprd10.prod.outlook.com
 (2603:10b6:610:4c::40) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH2PR10CA0030.namprd10.prod.outlook.com (2603:10b6:610:4c::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 17:10:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f4a4e8cf-7de9-4e2a-d163-08d89d2e7cf2
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0168:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0168D137EF7DCC3A0EDD0433ECCB0@CY4PR1201MB0168.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CaDYmh9pJ0oZgX31lFTZu8qWQdjbaCNAh2lkDRwGoAca2tWQExcM63apcxoSFqJreu2rM+b06YYJsk1wxKOf1VgQ4UJtgWezKuBCUn0pPH9kg4G66CNfrEhRyRiDP+hMyDBdVRzINm+o41VjGt8fuLtAbRp322bhTR4dMLps+AA1MICM+pKCCzcVvuKmt++CdX9WhHl4gyElizH3I5aSyIpYA46bmi+b/SgsNiZjpq/oQK795TUmmIkNnJPt977N43fDn/wrIpKBTCXTTY4gp18qyhUh356FxjUr6sc6ohIv1PYv1xaOXAHFzdIG/2jH782PEW/P3wI4YY1W0IL1YyUbxDrfSQZ0xtyD/QFQrurHz5FyKuCumoy+EQcMvBNQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(376002)(36756003)(8676002)(6486002)(4326008)(66476007)(86362001)(7416002)(66946007)(7696005)(54906003)(6666004)(26005)(16526019)(34490700003)(66556008)(8936002)(186003)(2906002)(2616005)(52116002)(956004)(508600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?GrAyUDUVg9k3mbUZeUV2moygcE761cqfgC4vppU9BoFbMAatF2142WL1mYKR?=
 =?us-ascii?Q?vL45hsQoFC711neDQhSJ5VR9sxyVG3mpIRyKoP3JI+a0PTiWDOB7e+L6rLuT?=
 =?us-ascii?Q?+CQU14Q/U4IE+jEe41CEG+lO1Ppva1j1PKdlO+A7GOA/HcDwrdEcmWMbabxT?=
 =?us-ascii?Q?Zuzeju2PJ71EAQpQk0nZEHRsWqc5QsJWovovwstI2+gB/nRSBySmG6MLafSi?=
 =?us-ascii?Q?eXw2JOI4zzAM1RKoLr06kOBJXFTQZeKd1xy8FfBSTrxUbgVuDIPo/4wpIOZG?=
 =?us-ascii?Q?0+ZNN23JOLXUhYCb1a8T0yLZHNUKtgAx54n93GigC/0sVQO01aLh73+dzX8n?=
 =?us-ascii?Q?97x53bS8LGLJDvnkK/sU6UXANJlgAwkDL2s7SmxT1B5kmPGC7nYml/LEtidg?=
 =?us-ascii?Q?L7blSMzgeUqZY5FQ5EwNesP7Z+ubN9k4HfzOdJ2cnHqVVXj5Ll/2kbrJxNXT?=
 =?us-ascii?Q?CcKy1dkD2l18m5mR0GG3HGAy+4Rdcnf8u2wqD07iZl9zwJXsqs3/hDg6ka69?=
 =?us-ascii?Q?bA0RW22KXPMcZ6jjXzrIaIAT85vdtW7mBHP4XMzNOtEoQEfrTYGF5K/dmeml?=
 =?us-ascii?Q?1kfk8GaHv/CmtZeLq7xAU/EWpwFb23L4mL3cdfok2EOP+FTE01nYgrkQiWjH?=
 =?us-ascii?Q?q7zYP6eS/849G4EKoDocs9Qo+jUslUIHh6podqENPUNV9BScL8+29ydatXuI?=
 =?us-ascii?Q?XQeAcnDOdE7nbFInzTquZNXbJSfiwSazghjBOdKCCDv6M36j1tPWbQxogN3o?=
 =?us-ascii?Q?2dCoS99CaYqlTCXczdCZ0fY4swuKZneSwWIr8SpzD7ewKoBWIOcNIADIqkQg?=
 =?us-ascii?Q?omhod9E0Ev5ngsqd78UbDwiMTqd6g+TxzsHPSrMMA1A3KXDHlI+hIwXDkIdh?=
 =?us-ascii?Q?YjZ0ds2vjvdEqGva4t3u3G9rSd/IzBsSNdVDkNFy//6/+rtyEoS6KcZi71ho?=
 =?us-ascii?Q?eAaPDba5edLffTUfg9pshakOLZfU6ia+qoV+TkPR6nCTWRPJ3u4a8yzROK1F?=
 =?us-ascii?Q?MMHF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:10:26.2710
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: f4a4e8cf-7de9-4e2a-d163-08d89d2e7cf2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mDMUBBZZ78kOxEeZuFTWRGknlJaLjRFIBDPEq8WGUCZwt0qMLCpTqxW7l75lljS9oD2se4MjcDi/xYkkKlUXVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0168
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

On systems that do not have hardware enforced cache coherency between
encrypted and unencrypted mappings of the same physical page, the
hypervisor can use the VM page flush MSR (0xc001011e) to flush the cache
contents of an SEV guest page. When a small number of pages are being
flushed, this can be used in place of issuing a WBINVD across all CPUs.

CPUID 0x8000001f_eax[2] is used to determine if the VM page flush MSR is
available. Add a CPUID feature to indicate it is supported and define the
MSR.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/include/asm/msr-index.h   | 1 +
 arch/x86/kernel/cpu/scattered.c    | 1 +
 3 files changed, 3 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index dad350d42ecf..54df367b3180 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -237,6 +237,7 @@
 #define X86_FEATURE_VMCALL		( 8*32+18) /* "" Hypervisor supports the VMCALL instruction */
 #define X86_FEATURE_VMW_VMMCALL		( 8*32+19) /* "" VMware prefers VMMCALL hypercall instruction */
 #define X86_FEATURE_SEV_ES		( 8*32+20) /* AMD Secure Encrypted Virtualization - Encrypted State */
+#define X86_FEATURE_VM_PAGE_FLUSH	( 8*32+21) /* "" VM Page Flush MSR is supported */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (EBX), word 9 */
 #define X86_FEATURE_FSGSBASE		( 9*32+ 0) /* RDFSBASE, WRFSBASE, RDGSBASE, WRGSBASE instructions*/
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 972a34d93505..abfc9b0fbd8d 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -470,6 +470,7 @@
 #define MSR_AMD64_ICIBSEXTDCTL		0xc001103c
 #define MSR_AMD64_IBSOPDATA4		0xc001103d
 #define MSR_AMD64_IBS_REG_COUNT_MAX	8 /* includes MSR_AMD64_IBSBRTARGET */
+#define MSR_AMD64_VM_PAGE_FLUSH		0xc001011e
 #define MSR_AMD64_SEV_ES_GHCB		0xc0010130
 #define MSR_AMD64_SEV			0xc0010131
 #define MSR_AMD64_SEV_ENABLED_BIT	0
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 866c9a9bcdee..236924930bf0 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -44,6 +44,7 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_SEV,		CPUID_EAX,  1, 0x8000001f, 0 },
 	{ X86_FEATURE_SEV_ES,		CPUID_EAX,  3, 0x8000001f, 0 },
 	{ X86_FEATURE_SME_COHERENT,	CPUID_EAX, 10, 0x8000001f, 0 },
+	{ X86_FEATURE_VM_PAGE_FLUSH,	CPUID_EAX,  2, 0x8000001f, 0 },
 	{ 0, 0, 0, 0, 0 }
 };
 
-- 
2.28.0

