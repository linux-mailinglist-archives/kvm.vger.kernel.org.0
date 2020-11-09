Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0219F2AC854
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 23:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731267AbgKIW01 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 17:26:27 -0500
Received: from mail-bn8nam12on2045.outbound.protection.outlook.com ([40.107.237.45]:49248
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729874AbgKIW00 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 17:26:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=etuSdj4/ne9m54oG1dw48Vdfgr8+LudBx9hIITqwJrA6o5/tlhBj/DKd81Kq7/tUESFnp3spezGyFc00jpx01JG7o0WXjmeKL63PFGHgytgLx8pBqTRwBNu3MJWbuOyM3BRCJYlyJ/ER+ubbI9SebjFi+o9ajWho0XGfzOfMjQo2LA9mLOGZQLiusAnEXW7FIy5txEZgoKMwFnhh2/+wNKcr98a0bV6ydej9VgesScohPHaJC/US2XZwzrVNFT10iOOeua6m3nxXGtkNG4YTAWcKgFGwENZ5vKIY3TkPIaGAuVXso5DGR0Dns3Mm2RtWIaPmnybTci8zvZwvkEZT/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jIDSQVwBhceTkXrKGCJrfTL5U9e5STc9iqm9UuU3694=;
 b=Bc8W+D64NcIbCY6UYiM5gZOGJguSwi6gFamiZaR/vK3THa+kY99xlDKTNt/Q6+VjPpeDzDFGXjTA+zvV2oFPIpP35p66I1wt15xffXI4/DljfWdIfZ1oVFZq4jcvNdzuc2oXXliv8R7ZW8pk2LxrP++PbSSjC6w89byG2nMSqi2RQZ+VFjRqPwPKpahGiB8A+a3RtaWRFZqGk5NbjfOSvAnjJZnerPtBK4Ca3eFRbREtPXaLtoOBdy++/E/y1K55fcIu0Svtg7t1RH3USxVn29bzYhrIPniddJL/JHcjGsLzkrjneNAj7feff/k/t7Tc1iI6SEb4YOixgmDf0UYcEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jIDSQVwBhceTkXrKGCJrfTL5U9e5STc9iqm9UuU3694=;
 b=sEsUcBacp+56QrbSCo405BDe5GJI65q27/K82zIm9OBlHPFEjxoHkHrOVI0nHydG1MXIBPbriAHX09d86K+NdeYH+vb3XNbrajYoQwDH2376ckXA38uj0J4r4h6gHQaA9GGef581q+OnD1WSGiex7A2w4pVq3gdkuug4vmlDuf0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Mon, 9 Nov 2020 22:26:23 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba%6]) with mapi id 15.20.3499.032; Mon, 9 Nov 2020
 22:26:23 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v3 01/34] x86/cpu: Add VM page flush MSR availablility as a CPUID feature
Date:   Mon,  9 Nov 2020 16:25:27 -0600
Message-Id: <da22668e810bcfb922349b5ef7c3df53424e48fc.1604960760.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1604960760.git.thomas.lendacky@amd.com>
References: <cover.1604960760.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN2PR01CA0035.prod.exchangelabs.com (2603:10b6:804:2::45)
 To DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN2PR01CA0035.prod.exchangelabs.com (2603:10b6:804:2::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 22:26:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2ba750a5-b352-4375-4587-08d884fe7d57
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4058E16134B9F39A78F06752ECEA0@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ajOFnrpiWGv0GHJaU7IUK1iK1O8hqj8bNphC2/g8mu3SSkyNHAFgzhz0/XqIraYWwDINYETcbLkbI2jkVe9s+6U3wCqCxuCeY7MsoUnnc8KE1k3FtDVvUnCIb5cSLcbRReTSHeuzuC2Vb4i/4OYv6X9yyYr8iSZQX37dEzt10vvARpdSxHmqyV42GROaEOK6Li8ujXqjG0IQJugiPkGzu3SQFLKq6RHYCpIfHQbGe7ayQzOnNrmcU9N7FOYebMG8MZ1Iifza4eWAC3tErQc6YWf906BxllHgBhZrwretvyJydKQqwTprAP2Xhi39i8I+5TELqMmoxiyBBhiAb/D6xA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(2616005)(956004)(8676002)(16526019)(54906003)(316002)(86362001)(4326008)(26005)(8936002)(7416002)(36756003)(5660300002)(52116002)(7696005)(66556008)(66476007)(66946007)(6486002)(478600001)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: JituLAE1SGjntN4YVAnOJdRxeYPJm6GZhZY5utty3gmacC7612a5DZuLXSho9n8ab9i8m0suVdXBshtIPVoCYwWMRpfZQUKdtsMweOiuUVP9HBPv2Ng+vOGZtGcufFMzSETQewgu7p/TRQBy3lG32sJYS7pf84mQl8g/VSYWc+nWO/feE9LyQiASuAyugtO+4GqbeOYhDCLFNJJebUya6x3xeL2C5SL88trjzUaB/MLruHhdz6nlhbNYiATIyy51QRpth/5Msov2vy31rOaECQK9AksTHWK2DW1IJyNryeZ/34wjRm1kPFnJVZmHHEVi5WP8cVGecJ3EzTk/b1YiG+GVKaKZTkZJiw8JziXKL3EqkIWEotYglLzo3hH5LKSJFOa9Uy5oienR5qZ8Ajq+sS2OOeQtGC0rryAG5/cL1sMMU5epBaYWAxyW06NmfX640g/MPOXdDnMFZFak7lqHAXgf8UtGOsh4dCW5/hSQBSErzzDNOmVpAesgQgjqxBwiQowMEJRqlqKObelzxdSNbRyfmQc3sm01uuSiFP5v7OHoYp0sBVFVEt49sF8b4yzvFX30mfqAFLvGSiIFZILC4YyBKqmSLwPZAHdDGtGVMEEqraXQvX+fTuPWzgYCiBsEyPy1NT0dSuN7Ew2wTB/6kQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ba750a5-b352-4375-4587-08d884fe7d57
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 22:26:23.4465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6xG7LUVHxDz9mq0nSftR7F7dxvZ5ner6zA77KZ80+bPdIOa231ACn3JWtU6wiR0wh0EBH1tsYylt6hhTK6CU5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
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

