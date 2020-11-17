Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6922B6B1D
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 18:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728624AbgKQRIF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 12:08:05 -0500
Received: from mail-dm6nam12on2082.outbound.protection.outlook.com ([40.107.243.82]:43254
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726196AbgKQRIF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 12:08:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P0XTVk+chRmekHfOT8VNr6ozY5bn/RB1u5K4Bzyp+bnu6Hb4fi5gs/IDkjNzDZIRHmcunpFgk9XwO2n0SD/0ApETZY8/2IuYIUuWseMtMvtIE3k9wIAZ+DwVHpdySsk3Vm4q77XmHFSylp2H05CbejKfrPEDOV7BZthj3GyRD6RWZuIAPFb8iVYxUkfclLd1rwV0ZqDgPDtsOuRWmoRH3bJIaZsJNbv9beRYSzdZWZimrgwrnF3G+o1ibVrj+EX/SFfgkdgtUKzggGZ1EXmq4miJcue5XU3t+r9HDFNyiq5QOV++P5LYdEJSw49LCtUGBQ++Fe27DcLtscKqiLU9AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jIDSQVwBhceTkXrKGCJrfTL5U9e5STc9iqm9UuU3694=;
 b=KbRxlNP2Sa6UBphIlYhrvqLKxT5VOH5ri95/vPn9Q9Dxk5WcnVpCMlG9EzQd+WdpSC+hCO5L9JM/aFSuNm4sHKhhReX4j25wSHWibzgoQQZGJmakEbX6eFgG4jt5FZwOX2V9ODjEqjWUjMAYEMreoCVu5GRYCDlKX86OX+HXOz9MgDqveBZA67xKXItP4g9veVcXsC67KMdUI1nLmZhIRYaRaBp1or85t+oUOcGAOOqYonxQid7ETSYd+uyr3GgT0/QtQLCPhsdRTpp/dxNCf5mg8WDYubWYcbDqUsifwqEzpj2WdkgaZ/Ugx63QX3YpneEgvGj1zZQsRp4L5z12+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jIDSQVwBhceTkXrKGCJrfTL5U9e5STc9iqm9UuU3694=;
 b=QZ2RagTC4XgzAUJvQMYEDr+chGyyCqYyHm5yCh+5DD0CyAV/EkZJf4VOJMTQcYJQXQv5u89ksjUB2TvDDmsvqpxW8cg8tL9d1B+rD/NSENbolUabIglnHXP2wcc3y1s/dQGhUch8qseBuOZOa/cbsZLS4sVDR2G/TK9YCfRjr50=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1772.namprd12.prod.outlook.com (2603:10b6:3:107::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.25; Tue, 17 Nov 2020 17:07:58 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe%12]) with mapi id 15.20.3564.028; Tue, 17 Nov
 2020 17:07:58 +0000
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
Subject: [PATCH v4 01/34] x86/cpu: Add VM page flush MSR availablility as a CPUID feature
Date:   Tue, 17 Nov 2020 11:07:04 -0600
Message-Id: <4c43715b4efc7a4c8c120b4246198a069f81bce7.1605632857.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1605632857.git.thomas.lendacky@amd.com>
References: <cover.1605632857.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR22CA0010.namprd22.prod.outlook.com
 (2603:10b6:3:101::20) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR22CA0010.namprd22.prod.outlook.com (2603:10b6:3:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28 via Frontend Transport; Tue, 17 Nov 2020 17:07:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a72ca651-735b-488c-0167-08d88b1b5511
X-MS-TrafficTypeDiagnostic: DM5PR12MB1772:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB17721EC6810BFB2CA62954DFECE20@DM5PR12MB1772.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sjx40CJlBI5mH8sJZ0eQxUnK+pbe6Re0Eob6X6SFBZc/RZhl4hGWLMMYPqJgqzCCsTqXDZAnhhqn1AaM3i6OunDf21CqXjKw4GWVYd1+rAY3tbdmRrGRk93PB2Ww8lamLh1KH07LzzNuJAl0H2s40jSrGOLYVjjkWxuQGjKlWj3nd+/7Q6D4zFjR8j3Y/Ywc7TUbJJ3kriVHeSrSCvb/dcd6UFT4zfXQYZPRCbh4L7uKyrzGVScq6RD0pQaJ1KVJP4oe+oEz+sDFD+sA0xXyYlQVEGU8MEN/65jJAGOC+xie7Zv2dg5aDX8KzwjYhQoCwaHbI2qJJyWhoUBowkhVyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(6486002)(66476007)(66946007)(8936002)(5660300002)(26005)(478600001)(66556008)(16526019)(6666004)(186003)(36756003)(86362001)(8676002)(316002)(956004)(52116002)(4326008)(54906003)(7696005)(7416002)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: hpfKuoa34hW1hfcngx35eKIGmt6/R4LaFjm4sPkWaZWH+KjrEj58UnMghm81IH+M6y/WZBqT6uvUU3JexnR6cHVVKySGQDnGS0C3cxd28avN8Fmrrb97HFbUGcw+2pOl0nwyfC2/YtVlmknYWxvkg1lo2tfx35gVdiZCVAJZTvZHJtu5oD2kkmxnd2hRFu9KYn/x6Da1I9bJPGe4nXnkcCiRRXvwV8hdzYrf36t7t2P2vIWx5SHtQQdXUdcmy5vIUSR+D8ehYyznNDtXjVqyX30GNxCPnj79Fj/SfiMwhyP3T7JfA2AjxAUuvjxpemogZEhMcs/V3yZ3kz1Wi/tRNJ7DxJAQoTECjoCT/vAqriP/cke75vyUUVPYwGHmiXC05o261a4nBwmruYBu9gnZDXxqxdJK/BpNjr7plGd36veuCRpeOF0tqwJBtIxXjkGWBfMvXASC/G88J4qsNoIVyIvA8yFW4pc6wbhXLREYqfLNJbpAvfpdUnyYJ38Jfbo5br0LWTq6TRKx4DWQ6Nv2Y4ir7ar2P5tB68orr9p8M1w3sXzd3AS5kUTCBhjnSHATnzPz676SiM40eviVGSJa8LNqic5jjQoljrMzdY9lWOkdaK0rDbmv0ghpM+hFqcp2QItKtkrts9+xC7TuJIjMzw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a72ca651-735b-488c-0167-08d88b1b5511
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 17:07:58.2879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5czkLKAL+VvhidbT6o8ra+/k9Si7iOs9bVBvAfDE4vD/8vTXnJkH0zIcfBj0FwZykZt+qpUSAJBCjjTLV+c4Jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1772
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

