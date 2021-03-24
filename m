Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15533347DFF
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 17:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236610AbhCXQo6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 12:44:58 -0400
Received: from mail-bn8nam12on2055.outbound.protection.outlook.com ([40.107.237.55]:61165
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236512AbhCXQoo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 12:44:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BPG66eJktK8b5iPmyHLhuf/TOMbTkxOXlVWNrXDJWV39VPu0sSq6d+FkbaPtPeDhh8zBNWEUvFIAyturN+acU7UFJ9CEMuqLBu9UXH0Q9DT0SYFrSRWRsx5aAv6dlPtTAwyeGpQPmWouYYfK8D7shPJ9JxKWozfXt87G7NznaG+8LpbiJ8VA2++5h7j4fUjzSXPrk5L6WRaup/vRhOru5SGSP8nqjR2XNNNLbkULaYrHT8ci/vLCIIyqD3QC+gmdtJr6kxUJN99Rx8Ki7CUCAxBteTrfuVx3IapMu5vOuhDwMyq1buviiTGKJX5PRrAieeLG1/Qisvr1jTVNDB7YJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P1ZsLS3VYeU7Lc/sTMx0EH63IpRTYdy8IAEWThPE4yc=;
 b=QlPZoLcw9k/916SpEMq/6rqaozZPdQVPfPHHo1uEgcu9DG4s2VMOgyBp8b0SWiAamiOVnAC72r6cXoHaEPtFzGYcf4GIR1jnE0FxgYAzS+dkrE19AI1ehZy0sHD1QXvJOLbJ22UjMQFvaBQjdEkVaFd77fMwIxSZPEWCWlnAXqTyQrfRl+EomhFZy7xA6cAzy2av2GEy3+VP6UEqH5VMhD5TUyVCwlZaUNqgCkDIhZA40M/D6lgfoVkjl0vIfLtgosr1S0X831F1wo0ymptDApbo7/8uTj4ozynStJFyjAeeKQlcrOzvqOjFIOQ3ZXF3xL/p2mMu44gGlJM0FFEdHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P1ZsLS3VYeU7Lc/sTMx0EH63IpRTYdy8IAEWThPE4yc=;
 b=hHH/SQVsCjtJUrQ3IcZSHKwSIy6ioPxYsm6xTvok+aaQxDL9+NdYeo94/78DdM1OBze+ObFTssA1H26VE/Na1C56vsUS5oHCkMsSbxtoyy7gww/DWuaCiCo9mssEk4wHVUcCuKD7rPj/Wqc+4R51wrNkuH9Bv0MQdu2w8WxwXnI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2447.namprd12.prod.outlook.com (2603:10b6:802:27::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 24 Mar
 2021 16:44:39 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 16:44:39 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     ak@linux.intel.com, Brijesh Singh <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC Part1 PATCH 01/13] x86/cpufeatures: Add SEV-SNP CPU feature
Date:   Wed, 24 Mar 2021 11:44:12 -0500
Message-Id: <20210324164424.28124-2-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210324164424.28124-1-brijesh.singh@amd.com>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0010.namprd11.prod.outlook.com
 (2603:10b6:806:d3::15) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0010.namprd11.prod.outlook.com (2603:10b6:806:d3::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Wed, 24 Mar 2021 16:44:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a41b520e-8759-4794-8141-08d8eee41d37
X-MS-TrafficTypeDiagnostic: SN1PR12MB2447:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB24477BDCA52DD3A802D614CDE5639@SN1PR12MB2447.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v6rsIdyU9RbV9HW+vE2uoO3BTjFF45ATUm34+lr+TzBwZtd9mJvse+Jqv/C+CvfNhDkwkjWqGr/HVrTp+K7LFgwYR8sZnimapO9taUz2RIJaSSK8TR4KQEXGFe858GBa/0mnwf9KPo39ObUHh3qA1wkV49ikCCpLCiG0uhFfggmQEXDYgUvleWGSV/8AUBqbELXUxMHNx550g0OHsckZ5E1OeERahQZ7SBKvAdZgiUcJe+6sMnovsxqfBWpueGQEPMjwSY1WZEcY5nwgnoaG5GWro+tAZ3IFoldRE1JDp4UpG0zVVD+h5FkK4tA/ZWUZgOVBXgQVpmlHKI4W5X3mfUuVJddIelqLYYx0FGc6bjh8Iy/dAaBeChApOmGCjM+OYSQMmjLUkNlYQsowd9aZwx3Q5ohy2t/bB3XkTVWPMNm7JQFWDe+uZvXo8VRoN3BT9deAmQ9YEAWMykFhAX/AI5g2mYoTuh1PiqMjn8Zd3E1dWRkmWZnSUHoydXHKgZkh7eL4ODJfrkor9kulGQhwtm2Rx7kGVqKRoGerkWYgIHqK5g6vds70fJq/TXibWeOCiyuOruO0URb9mJ2jZaGN/l1onWvQMBUQpDTqVdL6Qep3ZFgYAdrg1QCY8krG/qlue0dndLWF0lDlKO1+7T3cUWkJMIMnLbEyLUNM8D6OgHU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(396003)(136003)(366004)(16526019)(38100700001)(5660300002)(26005)(44832011)(36756003)(1076003)(54906003)(8676002)(316002)(83380400001)(8936002)(4326008)(956004)(2906002)(186003)(6486002)(86362001)(7416002)(2616005)(66946007)(7696005)(478600001)(66556008)(66476007)(52116002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?A4JvgWKerJE4pb8+bnjhCwe2EX+m9LRnjzUaQvI6Fq31hL6MHXFVTLiTIduk?=
 =?us-ascii?Q?WzJ1fovvWodvp0DYcWSxzN1b3fQ7nh3nNV6hFj3VhTyjWCrmsMJUQ9M4fK4k?=
 =?us-ascii?Q?+RqPuIBFXKzrk0Jb7KS+c15+rQT5GHxfw59/zmvlTv356gI+uI4T+KYlFCBi?=
 =?us-ascii?Q?OlBF8NA7hKera8PseDfTinpnufGsml2Q4Yg2Ck4i7nr1E8FoqzVRIpFwvvQG?=
 =?us-ascii?Q?iA4wxHIjUb5oE6S56jvWujOHrPQjlG3njMsE595mDm84ZgXl9Cmc9T28rCS0?=
 =?us-ascii?Q?0fUgT3Yw+rywdldZW2iujHEfutk5xzt7X25Usby2voaupZCc0aaP8p8XOQm1?=
 =?us-ascii?Q?MZCBrJu9PQUsbKKZ7FsXaWqfbY1HLuhTnEi1r+fcSuPLhPybBcQUMC0NgEH5?=
 =?us-ascii?Q?sc4+2VAM/FXVdmIGwE/Q8xgU8uXLnUcGunMQYuqDwavPnctawvpT/KaH9pyZ?=
 =?us-ascii?Q?crHmCau1vt0TCjesbn9IJoEfJWZeGfMZ5THA2jFgbnJ4zK5NmkelVWsWS4w8?=
 =?us-ascii?Q?5v07WFLuncwks2J1VrRm9bNYRBpo6xODf/Au9DHklSdp/LI2n4RRzFqNg2JA?=
 =?us-ascii?Q?7jltmpQTNJbIEfmDYmBKt9aM8/tu4Hq9nhOyONIMAbmeg48y5y8BIcivhoiY?=
 =?us-ascii?Q?ct3s/iomMVPTxF+TCK52MsFRGB/2J3BhGmW8yyAIOfC7zH3MSUwf6yHKY9od?=
 =?us-ascii?Q?zIufaMdabKdYCd5Nd0VydYF8drgfKiI4xq6ANh/2P3WfhYz4IliJp5jHMV4i?=
 =?us-ascii?Q?33S7Wakfhsxgy3wCqKgB7pR/L9SgQznb5w19VUzIKFkRKioj3wSbhF0t/R5k?=
 =?us-ascii?Q?Et/YeVHzglV8DkkmcSw9Sis9Yvcm+l+D4/EhrvB/9VELqWHs66RDRgqhOog2?=
 =?us-ascii?Q?g+ZkCKPFP0/YgKTSqonrCS7c7Q/B31t3Lfa8mHjdByP0tlZ9u2PbIb1psjpG?=
 =?us-ascii?Q?aAJUR2ozTwWmZ35AMIO0kVv/2weEbGrNZBD+QylToS2A/KeLCRO7rZV7XLB4?=
 =?us-ascii?Q?eKCqpJqvxsf2dnrUVy1v/1Rp1x2fcCnKMBjFolPEdL8X2xMA+ny06XCO8irY?=
 =?us-ascii?Q?CAxmK6m8DBHu5puRz0ocGfU5J4IBYM5As2ltsaGDkBfn44onEoZcCzVSYN+d?=
 =?us-ascii?Q?+wE3/F3/l5ANcYAPjV5Iui4AVxjlitTkKJ2MUXJV7UJG4zuxR/5OPVc8vtSW?=
 =?us-ascii?Q?SSTFXmXFFuOLvGaO+lZxnS8RXbAtqPQZp9nNGALF63Z8CXIXOyUICvfoDqmF?=
 =?us-ascii?Q?/9Z+E2Yy9on5cEW6yOP98JiCAvBb5qQogPkPoLLweyGOfT5tu/Bk1uCPkVwX?=
 =?us-ascii?Q?S2BSG9k84gDP/QdTIIv467lt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a41b520e-8759-4794-8141-08d8eee41d37
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 16:44:38.5075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ttnaftJOCDW5xmHuV2UKieGVvPCqqcnTffaJbDYpZrRd08jTEjK3pi8fnlwTWyf4lzIHBDBbcYcIoud4f99EUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2447
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add CPU feature detection for Secure Encrypted Virtualization with
Secure Nested Paging. This feature adds a strong memory integrity
protection to help prevent malicious hypervisor-based attacks like
data replay, memory re-mapping, and more.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kernel/cpu/amd.c          | 3 ++-
 arch/x86/kernel/cpu/scattered.c    | 1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 84b887825f12..a5b369f10bcd 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -238,6 +238,7 @@
 #define X86_FEATURE_VMW_VMMCALL		( 8*32+19) /* "" VMware prefers VMMCALL hypercall instruction */
 #define X86_FEATURE_SEV_ES		( 8*32+20) /* AMD Secure Encrypted Virtualization - Encrypted State */
 #define X86_FEATURE_VM_PAGE_FLUSH	( 8*32+21) /* "" VM Page Flush MSR is supported */
+#define X86_FEATURE_SEV_SNP		( 8*32+22) /* AMD Secure Encrypted Virtualization - Secure Nested Paging */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (EBX), word 9 */
 #define X86_FEATURE_FSGSBASE		( 9*32+ 0) /* RDFSBASE, WRFSBASE, RDGSBASE, WRGSBASE instructions*/
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index f8ca66f3d861..39f7a4b5b04c 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -586,7 +586,7 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
 	 *	      If BIOS has not enabled SME then don't advertise the
 	 *	      SME feature (set in scattered.c).
 	 *   For SEV: If BIOS has not enabled SEV then don't advertise the
-	 *            SEV and SEV_ES feature (set in scattered.c).
+	 *            SEV, SEV_ES and SEV_SNP feature (set in scattered.c).
 	 *
 	 *   In all cases, since support for SME and SEV requires long mode,
 	 *   don't advertise the feature under CONFIG_X86_32.
@@ -618,6 +618,7 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
 clear_sev:
 		setup_clear_cpu_cap(X86_FEATURE_SEV);
 		setup_clear_cpu_cap(X86_FEATURE_SEV_ES);
+		setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
 	}
 }
 
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 236924930bf0..eaec1278dc2e 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -45,6 +45,7 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_SEV_ES,		CPUID_EAX,  3, 0x8000001f, 0 },
 	{ X86_FEATURE_SME_COHERENT,	CPUID_EAX, 10, 0x8000001f, 0 },
 	{ X86_FEATURE_VM_PAGE_FLUSH,	CPUID_EAX,  2, 0x8000001f, 0 },
+	{ X86_FEATURE_SEV_SNP,		CPUID_EAX,  4, 0x8000001f, 0 },
 	{ 0, 0, 0, 0, 0 }
 };
 
-- 
2.17.1

