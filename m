Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185531CB985
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 23:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbgEHVKF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 17:10:05 -0400
Received: from mail-bn7nam10on2087.outbound.protection.outlook.com ([40.107.92.87]:6033
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728010AbgEHVKE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 17:10:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LD0kJZkiUFUdj8UQcmKnj+CKQRmdIFPi/9FsUL25Ng45VPcu8wLag1mIW1HmYZFiD+KsSwhKKvI+Qa0co04baLAneJBx4YJsL18K9yK0H8U5Cldzj6NiPCMzpY+iHJ0v25hXuyGh7NQMR3IrS6rAhreXtapF191R4xuYqv4PcyrF3Irfdvl2MKPncj8QfQm5RIcOiC4dJ/k19kYKNAAnY8P5Z73K1jESarnqwnxE3a5SOpJ/0/mVTWymheL4P8gjTUhINx4ixMmj04mZd3Oti+QE6k3QS5sUGgK8ztHiREfdTUXqhej4CD57ngkPMy0BqI68H2x+VYESRWH7nHHPkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L7f3cYZbrywI5AXrBrn0M7ssWckZGZmOvo/qwaTHxdI=;
 b=n8TIqO6KTBlRmTBco0IQCRNl7lbYIpBcy861hrygvu6cdZz48sDTuhBCHfzzYynBjS+ERH6MdM2lcWVX9iMb1EKjUEQwYiVSIffU4YEaWNz/Ix9B86PGvcO1cP314cWaa/yGt5SXFA/G+PvVoTEJ6BdxhirZ0PYmzH8nVUuKyaBDjXpIj7xjxrG9W3K1cFEDfA1cLG1A4830rBaK/SXdn2I+PZ2GQSYCsHhKmW+TPQGmC+tj1OvkU2zgF5hk1+ckTrzWvtdxu277tXTOBMFoO07UQ+Y5CQ86yhGDdatf5/F9Fwr02Rdsv9aUXKmaWw7UOs/DClpaH7k9YiwBc90Gug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L7f3cYZbrywI5AXrBrn0M7ssWckZGZmOvo/qwaTHxdI=;
 b=p4t4kNvjfEpCPSOQPSX8/jkwA7uYsrXyuIu78LFTTlPRdhXM5KvGXEffbGVeOCtIGNZKz9sQhCyLXGluOcCZ87fCYltajOgD6RyHYI9/CYfDWhhaQZOTnKuQF3JibaKOfKB9LP+2/DJBIK8JnfXESHgao/3abalLENmdyzH3QII=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2591.namprd12.prod.outlook.com (2603:10b6:802:30::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.33; Fri, 8 May
 2020 21:09:58 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d%7]) with mapi id 15.20.2979.028; Fri, 8 May 2020
 21:09:58 +0000
Subject: [PATCH v2 2/3] KVM: x86: Move pkru save/restore to x86.c
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
Date:   Fri, 08 May 2020 16:09:55 -0500
Message-ID: <158897219574.22378.9077333868984828038.stgit@naples-babu.amd.com>
In-Reply-To: <158897190718.22378.3974700869904223395.stgit@naples-babu.amd.com>
References: <158897190718.22378.3974700869904223395.stgit@naples-babu.amd.com>
User-Agent: StGit/unknown-version
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0057.namprd05.prod.outlook.com
 (2603:10b6:803:41::34) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from naples-babu.amd.com (165.204.78.2) by SN4PR0501CA0057.namprd05.prod.outlook.com (2603:10b6:803:41::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.12 via Frontend Transport; Fri, 8 May 2020 21:09:56 +0000
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6ce0e40a-d3a8-40b2-754b-08d7f39429e7
X-MS-TrafficTypeDiagnostic: SN1PR12MB2591:|SN1PR12MB2591:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB25911FE873DFE83EE934089795A20@SN1PR12MB2591.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-Forefront-PRVS: 039735BC4E
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lxUKumY/sCu4p0DOY4Ztxzc3+AXQQ8CyTplBKYwygcwS74gg/9Vh/w8LoEP1R8dvkVIH/v1Pform19LP25AJWGl0Ikm11VxLGw/csibGWvEcXXlGZkx9J9hsxF0l7Y1y6LU0sGxHuXQwBHu6nyh5GCJzdkqzN9+8wqKal2K6xwUqmqrUHX7o07ows0g3b/5C0uidT6YMkVjrzSu+KEZATQX8lXEgWavwdrvnt38VMkDig+iHEpgWyTs3wp3UKys5pb7Ef0z99nFtMjaV7JKJb6htHpQ4KFtaLxhGEQFyILNTjA9WPfnkuCA6c7OAd0nkSS+bZGGAgJZ9tUGFLs3oJV7Mx3orp+ftifCGgFCVjw6jniGnNOlHNYebHTLDlK/R8h4QI5RXOECzBPP3GyD8Iohqu//s7PXy8QQKDMylyyrS0u4bmzhK2mShKPO2Y0Jl0iZxQtTl+okVq/sv/zKnbZiBn//1eOq5FgrW6Ampw0uwRpXkmCl2Tf/yOSseWUWw2Yxhtg/t/lULw7fqgYynPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(33430700001)(7406005)(16526019)(4326008)(7696005)(7416002)(186003)(26005)(66556008)(8936002)(52116002)(316002)(66946007)(66476007)(33440700001)(2906002)(44832011)(956004)(478600001)(55016002)(5660300002)(8676002)(103116003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: uKtaq+ryW5sbuBWtbrGxD/v++UXRGtS53ClBZxh4ybvUTPd56vanyEcMNvRlibnkUKbTLSW2aoHI2izp26A9jt+CI8QNuqQRYNUw7mSBzclsVCk75vDNVRrmLY+3e0o/Sqk1SLWXfvK4YDKKl/DirM9Mwk0wgI/T0n2XVw9pwkmZDfRyRzmJdb0ViYo4gjvFtC7z8LNrU+NppZHJs6/fL8TSucQtbfsyNk4PgD8R5E+uq/TmWCgVNuAl00JY714zT6Cyvjy2Vce0ZRWl4dhc0edL3lYRPFny8/20itykZ1N6FE72kbldwzgEQ9ujTNxrNpC8v1rUhO85H741naTkFmHLZJloEzttot8Oo8aALNemc/kiHQNi4CfRn3ofOGxucpb6S0j2QFR7IdxX9n9On2T8MHJc5faFTtqp+cmUseneBAseIsUlr8gcl6W0yn//5RJ5nIHbCW2RxOhIlGsVu8BUtgBCK6euD8v6v8Damao=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ce0e40a-d3a8-40b2-754b-08d7f39429e7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2020 21:09:58.3006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CqZeJ+NlqNrhaQ2LFiSqUCG1Atgnmgfdce6ZJzDnYB3Fvjd8vSqzrPkl7ahN1UVw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2591
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PKU feature is supported by both VMX and SVM. So we can
safely move pkru state save/restore to common code.
Also move all the pkru data structure to kvm_vcpu_arch.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/vmx/vmx.c          |   18 ------------------
 arch/x86/kvm/x86.c              |   20 ++++++++++++++++++++
 3 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 42a2d0d3984a..afd8f3780ae0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -578,6 +578,7 @@ struct kvm_vcpu_arch {
 	unsigned long cr4;
 	unsigned long cr4_guest_owned_bits;
 	unsigned long cr8;
+	u32 host_pkru;
 	u32 pkru;
 	u32 hflags;
 	u64 efer;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c2c6335a998c..46898a476ba7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1372,7 +1372,6 @@ void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	vmx_vcpu_pi_load(vcpu, cpu);
 
-	vmx->host_pkru = read_pkru();
 	vmx->host_debugctlmsr = get_debugctlmsr();
 }
 
@@ -6577,11 +6576,6 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	kvm_load_guest_xsave_state(vcpu);
 
-	if (static_cpu_has(X86_FEATURE_PKU) &&
-	    kvm_read_cr4_bits(vcpu, X86_CR4_PKE) &&
-	    vcpu->arch.pkru != vmx->host_pkru)
-		__write_pkru(vcpu->arch.pkru);
-
 	pt_guest_enter(vmx);
 
 	if (vcpu_to_pmu(vcpu)->version)
@@ -6671,18 +6665,6 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	pt_guest_exit(vmx);
 
-	/*
-	 * eager fpu is enabled if PKEY is supported and CR4 is switched
-	 * back on host, so it is safe to read guest PKRU from current
-	 * XSAVE.
-	 */
-	if (static_cpu_has(X86_FEATURE_PKU) &&
-	    kvm_read_cr4_bits(vcpu, X86_CR4_PKE)) {
-		vcpu->arch.pkru = rdpkru();
-		if (vcpu->arch.pkru != vmx->host_pkru)
-			__write_pkru(vmx->host_pkru);
-	}
-
 	kvm_load_host_xsave_state(vcpu);
 
 	vmx->nested.nested_run_pending = 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c5835f9cb9ad..1b27e78fb3c1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -836,11 +836,28 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
 		    vcpu->arch.ia32_xss != host_xss)
 			wrmsrl(MSR_IA32_XSS, vcpu->arch.ia32_xss);
 	}
+
+	if (static_cpu_has(X86_FEATURE_PKU) &&
+	    kvm_read_cr4_bits(vcpu, X86_CR4_PKE) &&
+	    vcpu->arch.pkru != vcpu->arch.host_pkru)
+		__write_pkru(vcpu->arch.pkru);
 }
 EXPORT_SYMBOL_GPL(kvm_load_guest_xsave_state);
 
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
 {
+	/*
+	 * eager fpu is enabled if PKEY is supported and CR4 is switched
+	 * back on host, so it is safe to read guest PKRU from current
+	 * XSAVE.
+	 */
+	if (static_cpu_has(X86_FEATURE_PKU) &&
+	    kvm_read_cr4_bits(vcpu, X86_CR4_PKE)) {
+		vcpu->arch.pkru = rdpkru();
+		if (vcpu->arch.pkru != vcpu->arch.host_pkru)
+			__write_pkru(vcpu->arch.host_pkru);
+	}
+
 	if (kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE)) {
 
 		if (vcpu->arch.xcr0 != host_xcr0)
@@ -3570,6 +3587,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	kvm_x86_ops.vcpu_load(vcpu, cpu);
 
+	/* Save host pkru register if supported */
+	vcpu->arch.host_pkru = read_pkru();
+
 	/* Apply any externally detected TSC adjustments (due to suspend) */
 	if (unlikely(vcpu->arch.tsc_offset_adjustment)) {
 		adjust_tsc_offset_host(vcpu, vcpu->arch.tsc_offset_adjustment);

