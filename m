Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5A71D035C
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 01:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731852AbgELX72 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 19:59:28 -0400
Received: from mail-bn7nam10on2080.outbound.protection.outlook.com ([40.107.92.80]:51040
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731718AbgELX71 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 19:59:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gm0e76Jzc4ykYQ1jdrhH/2vRtA99M6BYsTXagHVzdUf/oArXCPKyohr/0zlFaeuKT4pqt/fOVZQf6zmVCN/PCK2lp70mnqosL3/RiKCtjqYNEqMCPyGQAPLvicZ1aI9u/n+QfqGXQ7enGA684wyPtp6bZ+NoNmaLrVn3K4TuMepWX4fRpYooJZYfc604TAoxBwb/TX+xvVBqvCrC+qxQN4LeQjlueP93k7j0GHZftcCxMwk/LOllDxrlDY7JVBSCidVCtPiqXsCKgqpD+2ts8IS5iWD3wdtankbRqRmVgPsA9LvpW6fBCd2pgvCoxqeJ8KFru79KxNOwfbcCCMjbCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E28rQdLIcibd2sbPFlCXYihTb2HalG61q18REzXIwq0=;
 b=GRfHuDjDEzI4evLjLj/MJMGYJDT8zPshAGP3d5W82mPJuCxFWv5XsZFyng46E4Z4r1RrTIDsmV8w1POBUddxkbXFfixvApYDWYzctXWFbnZdiHtg/4XMLmHJLF1j2jGG5xJsGQjgRhE1Myk4pPTb9PRrI0wfavqlWj8SdAzQTXiHr2CLCPBEq/8KwH1Yz/Kr2uiwGgZ8dRV4naVOB4cG4KQhJZOfBMY6oNZVNFEkFEDY8vdDP7VOngsneHfdANQtyPyQjhJT1cb+xBB3R5Bliq4dK0MXz6MX1n1BhI6GZqbDNzgxxElEebodOMjgK5CC/oieiRDf2Oaj6/pwCJdF/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E28rQdLIcibd2sbPFlCXYihTb2HalG61q18REzXIwq0=;
 b=27Sm+cTdv/cEqzdZT9zdcAyFnbPhWrHrEsSah8hFaLL+nDzswkxzAEqMppkKYDMsYa7Nkbq9/hMe2dlfR9l1jeGJKiRxVLEbO12HP7OqEROOSYAtRJxz78jlBJ5RvjS35nHvHoD/a2jZrnXSJI/3npcBbzpxpe6QM8llEXIMQUU=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2512.namprd12.prod.outlook.com (2603:10b6:802:31::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Tue, 12 May
 2020 23:59:20 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d%7]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 23:59:20 +0000
Subject: [PATCH v4 3/3] KVM: x86: Move MPK feature detection to common code
From:   Babu Moger <babu.moger@amd.com>
To:     corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, pbonzini@redhat.com, sean.j.christopherson@intel.com
Cc:     x86@kernel.org, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, dave.hansen@linux.intel.com,
        luto@kernel.org, peterz@infradead.org, mchehab+samsung@kernel.org,
        babu.moger@amd.com, changbin.du@intel.com, namit@vmware.com,
        bigeasy@linutronix.de, yang.shi@linux.alibaba.com,
        asteinhauser@google.com, anshuman.khandual@arm.com,
        jan.kiszka@siemens.com, akpm@linux-foundation.org,
        steven.price@arm.com, rppt@linux.vnet.ibm.com, peterx@redhat.com,
        dan.j.williams@intel.com, arjunroy@google.com, logang@deltatee.com,
        thellstrom@vmware.com, aarcange@redhat.com, justin.he@arm.com,
        robin.murphy@arm.com, ira.weiny@intel.com, keescook@chromium.org,
        jgross@suse.com, andrew.cooper3@citrix.com,
        pawan.kumar.gupta@linux.intel.com, fenghua.yu@intel.com,
        vineela.tummalapalli@intel.com, yamada.masahiro@socionext.com,
        sam@ravnborg.org, acme@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Tue, 12 May 2020 18:59:16 -0500
Message-ID: <158932795627.44260.15144185478040178638.stgit@naples-babu.amd.com>
In-Reply-To: <158932780954.44260.4292038705292213548.stgit@naples-babu.amd.com>
References: <158932780954.44260.4292038705292213548.stgit@naples-babu.amd.com>
User-Agent: StGit/unknown-version
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR11CA0045.namprd11.prod.outlook.com
 (2603:10b6:5:14c::22) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from naples-babu.amd.com (165.204.78.2) by DM6PR11CA0045.namprd11.prod.outlook.com (2603:10b6:5:14c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Tue, 12 May 2020 23:59:17 +0000
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8e9dcead-2195-4c2b-bc49-08d7f6d07ccb
X-MS-TrafficTypeDiagnostic: SN1PR12MB2512:|SN1PR12MB2512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB25120ECE9F2C22DBBFCE870E95BE0@SN1PR12MB2512.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MhJUHAPLTHmyK4gTji9MVZgOSVt1gD8hNw+a7U9xTBn3eILxUDHRYNgqRYiEi+eIV1g27G0QprbnatqmlxQ4ZpoaUAsgV1E62Ep0UYeuKsZN8V2gZpXmkEWEggC6kdU5e+4mhiXi1U7yVmlIs9VHExGuvPBWzK8EY1/R7xGWF2Oiwcy8p2EEzUcUQZ2nkYYbxMFvnonzxzLLnuwSfwo40lTkngqoK3mWZhdp6vkzZQaFzCutXUq+B+VM+LmcYLzAsmPFpN4d+mqL6H/HeRU1d5s1EzLnskEuCWHJYDf2HtfTu/HrZyhsLgJVnXRz7d9O0ynn0W9eNmMUOrDzlzFtVuHSxpHTQha6Qb229284USPv2AULcEp0J03UkdYM+oRZmG4irnpFrohQkRr/prOmW3sOqo1vbkaEq1K8ohoghDQY+gV5ytJJ12Zhu/EN1GiSQRkxH/Pf1s1IzBAgYllFITTQYrJD2CTlegn8VKFBujndmflyQoO7arEolWJllQ02nr/GfCC6wTL6vswLeAva4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(136003)(346002)(376002)(396003)(33430700001)(52116002)(26005)(8676002)(7696005)(66556008)(8936002)(5660300002)(16526019)(186003)(2906002)(7416002)(103116003)(956004)(316002)(7406005)(44832011)(55016002)(66946007)(478600001)(33440700001)(4326008)(66476007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: upZ0IZo3EopfDTf8Ag+uHvQV2Via0Cgf5Y+zRWvkFqvuU8N87Y2YaKlT1S0QbplGCMLsu8J2MHpXThwa9a8xpBmg/ZeriswQO57rNls0tALm2TUl3WU4agyjZ3GSNSewuqAdoN/MmS+8z38FAuVKi31LSd6Bqie8nf1GzSUaEbZvPPeO7eq9GuBPMBTkVrDNFNOgf7IkZEqnJxw/UWTS/IWF/Qmd3Kw9ZeTMm4+OSM/vvpRJZ4rHBUt7oZlya9xRVUa6v5SUaqSyp03tqC8zRWPk3Zx9yluXBPwP5SQZsUtsV0b9Qi3P2s7/hgfhC+vnQErSKwV78/UnomRjlH0U7y1AbiQcwNhNRsCedMKrkS5rxbyGSix2gzT/nnr30m+3CNMWLJDAu1r5kCBgtuEqT7t8O1Bglc16SbwC7gVHQowpK0dUO7wCkt2kzgsU/ZVP6/w2mUbxPDCZBePYhvRs5wfjgUMZeBhNXy25FCahKME=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e9dcead-2195-4c2b-bc49-08d7f6d07ccb
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 23:59:20.7149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hpXxFmzvc9b/kEYKuB90RkzxAAfc3SLY6dEjbWGXI5i2xIdltcuxf+V4gmhtzcEp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2512
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Both Intel and AMD support (MPK) Memory Protection Key feature.
Move the feature detection from VMX to the common code. It should
work for both the platforms now.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/kvm/cpuid.c   |    9 ++++++++-
 arch/x86/kvm/vmx/vmx.c |    4 ----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 901cd1fdecd9..d2c36768667d 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -326,7 +326,7 @@ void kvm_set_cpu_caps(void)
 	);
 
 	kvm_cpu_cap_mask(CPUID_7_ECX,
-		F(AVX512VBMI) | F(LA57) | 0 /*PKU*/ | 0 /*OSPKE*/ | F(RDPID) |
+		F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ | F(RDPID) |
 		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
 		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
 		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/
@@ -335,6 +335,13 @@ void kvm_set_cpu_caps(void)
 	if (cpuid_ecx(7) & F(LA57))
 		kvm_cpu_cap_set(X86_FEATURE_LA57);
 
+	/*
+	 * PKU not yet implemented for shadow paging and requires OSPKE
+	 * to be set on the host. Clear it if that is not the case
+	 */
+	if (!tdp_enabled || !boot_cpu_has(X86_FEATURE_OSPKE))
+		kvm_cpu_cap_clear(X86_FEATURE_PKU);
+
 	kvm_cpu_cap_mask(CPUID_7_EDX,
 		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
 		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 46898a476ba7..d153732ed88f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7136,10 +7136,6 @@ static __init void vmx_set_cpu_caps(void)
 	if (vmx_pt_mode_is_host_guest())
 		kvm_cpu_cap_check_and_set(X86_FEATURE_INTEL_PT);
 
-	/* PKU is not yet implemented for shadow paging. */
-	if (enable_ept && boot_cpu_has(X86_FEATURE_OSPKE))
-		kvm_cpu_cap_check_and_set(X86_FEATURE_PKU);
-
 	if (vmx_umip_emulated())
 		kvm_cpu_cap_set(X86_FEATURE_UMIP);
 

