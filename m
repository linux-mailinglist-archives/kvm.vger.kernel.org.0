Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D797A1D0355
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 01:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731821AbgELX7T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 19:59:19 -0400
Received: from mail-bn7nam10on2055.outbound.protection.outlook.com ([40.107.92.55]:18017
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731670AbgELX7T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 19:59:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EaLEeX6kVthKLutWfswowdxuOK34ZBtpPjshKN8D4u0RHALKAGqKHytO1bQdCFkrwOYU1wEwe0SGOGn7wt5ctRPVFBSxOWAUrsgb2x20DkYWS+JXS7vssn0KxP/Rd/2PPt/YLcikbWEvccUjjbOH6nsdPRaQWEjy3AvXpaDFfdLbwsizXJUMD3ouYXH4S1W/5he8fX2+n1fGrVZJxTucRSa0hEUDvuTfoWmSLnDzGlYJXXWgyVJAu00kJg/mziRKcAy0d7m+l/wN5rv0KhbcpYNWtc+Cvhsf0q6PLEMN1ycfTRYsokqQFYN/61qRImbWpfJVSWdTMutJUqY7kYdCbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=znldyMC6F1kTbKS1KKqAHBggcCg8jmIa+CEice6T2E0=;
 b=Bzd37PEoGa5P2gi3D9fyssUQyIR5mbLCm796QVtduFslU/bE9Pn465v3j71LGdU+7GUIMOVtvxSvYMHm2Sw78+0SwQ+j5GUucpBkmAR9Q0M+mPmLpsPES+aYgJ7ypgyxnSwvZ3fsEW+G1Si8wFoBQrMBq5NFtaskvpesOcW79Yj8jKGzEHzpv97ZHxGDuiViG+x86tB1fXoTSkyRzwYXMwp0+yWmGyVE5IRkOgd5qx84+NC8Amd8wPYN9Gn0Ysyp1I9QCbPZqQdne6uW2qNOKIsCgLoNeEYMJH7kY+HprazKq8WLeqzxH71/DALPL4TUuR1B2I/e74l96epo7NNbZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=znldyMC6F1kTbKS1KKqAHBggcCg8jmIa+CEice6T2E0=;
 b=XjVwZ/TglONP3THT8X4LyVNMbaf+2gyaudjZ+pAP1VDrZLU7mKBdD01XveJtB2zxQsuaX/REiGy38kOi95JrbtgX+uNNek0E3htvPr41eMKnu9RG+Ilkr7uPYoCk0STsesSAg1EnSNeejuFJqsVbtlwrgVeWIFbkp79f8UV0Nx4=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2512.namprd12.prod.outlook.com (2603:10b6:802:31::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Tue, 12 May
 2020 23:59:11 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d%7]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 23:59:11 +0000
Subject: [PATCH v4 2/3] KVM: x86: Move pkru save/restore to x86.c
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
Date:   Tue, 12 May 2020 18:59:06 -0500
Message-ID: <158932794619.44260.14508381096663848853.stgit@naples-babu.amd.com>
In-Reply-To: <158932780954.44260.4292038705292213548.stgit@naples-babu.amd.com>
References: <158932780954.44260.4292038705292213548.stgit@naples-babu.amd.com>
User-Agent: StGit/unknown-version
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR04CA0035.namprd04.prod.outlook.com
 (2603:10b6:3:12b::21) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from naples-babu.amd.com (165.204.78.2) by DM5PR04CA0035.namprd04.prod.outlook.com (2603:10b6:3:12b::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Tue, 12 May 2020 23:59:07 +0000
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cd439882-04ff-4de9-71fe-08d7f6d076cb
X-MS-TrafficTypeDiagnostic: SN1PR12MB2512:|SN1PR12MB2512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB25125A1539CD58E961DC83C995BE0@SN1PR12MB2512.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3vWtWEU+QwTHW3XVybdExwxKx+v1oXZTzK2BiRwdihx+8tyJeCzCHD46iIQV3q/Q8Hx47pievJ+P1kjs+vshTu1boaSKrea5gGA8iW5SBKv8yxx3wza0mQ88unW+YX1HHmdeSmMwiNxC7gMrxw7F4rH+lG8/fn+4ypSZDEwrGCYpSOSRmR7HdMrYH/n37GdoUfNW6Pl7DPUCKIhR6V8AJAMgExoNf8lm73Fhv9Y2AWezgGCFPKylhZbd/t//QrH5f8Ht3VCyy8ShY5oVcMqSs5WNXfN/YbFQdWwxnNcEpvX4H+TWxfTDqPk7vRZe9Iwu3khbzvhv+enio+cRdnmND6524GVNfL0o+9zh/ypRNdr3wqMxz6G3I0tlQKDXrap2cTCuJzDlR21XMD7Fz92O8eHp4KmYZJq4hp3gyH7aumST4SD5V6y9uZgPUiiA6noGLMPaZTghW6T3K+UsBbz29lkkwQhwQmlyTLRHZnLY9Rc2Q5M9sRslZR6rF4gng92Abh0pw3PKBSBr6HYL4sg/mg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(136003)(346002)(376002)(396003)(33430700001)(52116002)(26005)(8676002)(7696005)(66556008)(8936002)(5660300002)(16526019)(186003)(2906002)(7416002)(103116003)(956004)(316002)(7406005)(44832011)(55016002)(66946007)(478600001)(33440700001)(4326008)(66476007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: uYcpm4oEN+l3ZIZ8YWAF7mxakcmg+dDkGuel1d/qz1WPW51tewg4mLezhj7JncV18cSYxbDXl+eo2ojWlfrLF89GRoPdbv8vYYLItPdrNGx9D3gH4MZjZnJeUdrI07z4MpX3xJpvGemeYpT86txcwk9Frtpt2dMDhQIt1eNPP0ndEp7Z0uwQnie3lFfAmki+h9Isg1U4kEzoDqC5mkrorKuA4aE9S6Tkwy0NW9AmcdBhnL/fPwgitGPdTOKP9vdZOuTSpDq+Zble5tXBGBT98c/gjk2nskkQNhM39DKVJdzuGuc/bpavScZvNpFMirVa+LTi3cU2rMDcFYuf3z+yHU0emMdwdrSksvwccUO64QMqFdkgF0Zd1+17HZmvVjqYpGFcSloUz9ghiiv8grnJoIupJlE0WJlVPPqBakL62X/8l1lz2pICEWmM0TOOo0nRWC7JxGY4FC9ZmHyLlilDrdj4qULeLb4ZFRUfENisW+M=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd439882-04ff-4de9-71fe-08d7f6d076cb
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 23:59:11.0395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wc1InbiQjiaTkj1j3ZttkNb2HG48d2rgFd5G+/2suzvUN+6UmU10dIR8veiQoO4I
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2512
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

MPK feature is supported by both VMX and SVM. So we can
safely move pkru state save/restore to common code. Also
move all the pkru data structure to kvm_vcpu_arch.

Also fixes the problem Jim Mattson pointed and suggested below.

"Though rdpkru and wrpkru are contingent upon CR4.PKE, the PKRU
resource isn't. It can be read with XSAVE and written with XRSTOR.
So, if we don't set the guest PKRU value here(kvm_load_guest_xsave_state),
the guest can read the host value.

In case of kvm_load_host_xsave_state, guest with CR4.PKE clear could
potentially use XRSTOR to change the host PKRU value"

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/vmx/vmx.c          |   18 ------------------
 arch/x86/kvm/x86.c              |   17 +++++++++++++++++
 3 files changed, 18 insertions(+), 18 deletions(-)

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
index c5835f9cb9ad..98baeb74452c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -836,11 +836,25 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
 		    vcpu->arch.ia32_xss != host_xss)
 			wrmsrl(MSR_IA32_XSS, vcpu->arch.ia32_xss);
 	}
+
+	if (static_cpu_has(X86_FEATURE_PKU) &&
+	    (kvm_read_cr4_bits(vcpu, X86_CR4_PKE) ||
+	     (vcpu->arch.xcr0 & XFEATURE_MASK_PKRU)) &&
+	    vcpu->arch.pkru != vcpu->arch.host_pkru)
+		__write_pkru(vcpu->arch.pkru);
 }
 EXPORT_SYMBOL_GPL(kvm_load_guest_xsave_state);
 
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
 {
+	if (static_cpu_has(X86_FEATURE_PKU) &&
+	    (kvm_read_cr4_bits(vcpu, X86_CR4_PKE) ||
+	     (vcpu->arch.xcr0 & XFEATURE_MASK_PKRU))) {
+		vcpu->arch.pkru = rdpkru();
+		if (vcpu->arch.pkru != vcpu->arch.host_pkru)
+			__write_pkru(vcpu->arch.host_pkru);
+	}
+
 	if (kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE)) {
 
 		if (vcpu->arch.xcr0 != host_xcr0)
@@ -3570,6 +3584,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	kvm_x86_ops.vcpu_load(vcpu, cpu);
 
+	/* Save host pkru register if supported */
+	vcpu->arch.host_pkru = read_pkru();
+
 	/* Apply any externally detected TSC adjustments (due to suspend) */
 	if (unlikely(vcpu->arch.tsc_offset_adjustment)) {
 		adjust_tsc_offset_host(vcpu, vcpu->arch.tsc_offset_adjustment);

