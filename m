Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6974C1CE92F
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 01:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbgEKXdQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 May 2020 19:33:16 -0400
Received: from mail-eopbgr760047.outbound.protection.outlook.com ([40.107.76.47]:6090
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728267AbgEKXdM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 May 2020 19:33:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RnvHdXSBs/2fay9xnaROdRH5qnQ0xnqsSV65tAyM1lzpth37IVe+KcH5u2oPENA+OHTHbdy48ubIjM02gmNe8vCjEE+B9grtwDJZ9uz/ObgYd4tu+4gsjx8bUcChOwBAdCLWXbSCjWl0KVJEMRwn12mKRijvbmXbCJ1dBBTHFwg/rBcRm1DMNciOEOMfjuE1gL77BsdYEWdec/5eZM+BIImXokD+D10IwX4FzSjSQ3IbgUA80YootZ2gEoSL4X+ecCgm4HJ+yoykW6LWp2DpbZLGhEGjJlvhFM5vOnTHMwWdvcshF8z1OxV2BRWk1E6PP8OuGJoHep3UINrzO7ToKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=znldyMC6F1kTbKS1KKqAHBggcCg8jmIa+CEice6T2E0=;
 b=ClHNUqwZJ0TsnV9pn+TcSzD3H9E+jQ88zc9vBOwmJAhEALeu/LLwa4CLKpWtHW3ChrXrb4EnYeLpQPyOXyan3ZnD4KVEf6+BIdiSSkMMKET1li6gGnljCA64oqXAkByM2a+dUTSL54Sc7mNwHDa9vymfqGjMg/VjjyHhNtET0DkdcCrqobxCOxZu8+6YscsNtgJ+9T0mHanGDlvllChh2UnL3vZwmgSxx/MhvmCcd4C8n4INjg4zCIYqU0vZHhIqDMchNYX9aqDW010ml+Sgq2VuxPyl9UBURB0IkYtP5nw6455KO2172kcQx5lXWdNtve/g/RRcrK437keSOtDyyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=znldyMC6F1kTbKS1KKqAHBggcCg8jmIa+CEice6T2E0=;
 b=uywgBhIkia3beR/rYCbc8v5Vmd2WcoJg7SZCeqdi2oN0VtOEXulDZ8m7mck9n66zzjaZhrnPbHBY27R6ldTtqjwX648JgUfNbXF3zzpfmr9tuIX7+npdYEceQqcBJA2OOTozenWC6lue3UvOHqCuLwbLhZSd01mFLNQOSP+gBmg=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2478.namprd12.prod.outlook.com (2603:10b6:802:23::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28; Mon, 11 May
 2020 23:33:09 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d%7]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 23:33:08 +0000
Subject: [PATCH v3 2/3] KVM: x86: Move pkru save/restore to x86.c
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
Date:   Mon, 11 May 2020 18:33:04 -0500
Message-ID: <158923998430.20128.2992701977443921714.stgit@naples-babu.amd.com>
In-Reply-To: <158923982830.20128.14580309786525588408.stgit@naples-babu.amd.com>
References: <158923982830.20128.14580309786525588408.stgit@naples-babu.amd.com>
User-Agent: StGit/unknown-version
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR15CA0064.namprd15.prod.outlook.com
 (2603:10b6:3:ae::26) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from naples-babu.amd.com (165.204.78.2) by DM5PR15CA0064.namprd15.prod.outlook.com (2603:10b6:3:ae::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28 via Frontend Transport; Mon, 11 May 2020 23:33:05 +0000
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 45225a86-f351-45bc-7698-08d7f603a947
X-MS-TrafficTypeDiagnostic: SN1PR12MB2478:|SN1PR12MB2478:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB24784803F6534E7C4D39B07795A10@SN1PR12MB2478.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 04004D94E2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jh5Sc/mlN5vHsM5SkosuD8/ihHhgrFCIPElU1ptPtMUkCcudglh5sUWEsQ043VMU6cWujUwjmo2ivi2CPDVrcUyJ7l51clqLiknqDOwHY2gGTJPoXuXWva/5ew/yfH441gz6ztkHQyyYk71F9TZ/AueYznMJQ4uK05p3wmzgfx4SSM5rZzNj7DVTn8B3cK939fsvFX5NoKrNkPibDvz19DBrS9e+FQTDf8+wfZtickP4mx/toX5n8NL+MU/6RrGN0hMMHJGYq1OS5PZPOLHR++Ogmu/iI1Dx1lUCglVr5gx6LvHcfYg/ztToUT5yMIAaub6lFJ2cFu6xRzXqjDWLSmrmqIlxdWsMeezaqKQpc9w+2A31jjx6uyXiXjRO4JhSkq3+gX9s65aO+DdUC+X+YrwYSdWGcR3Sy8A5vRxuFY6MtQtU3oyy+89ZJoCOMNbDm/JCenJagwF8SdPN1Afs/mirKUTBFZtHMqlzxbA1+nvFf5HpL9TNkXn87pu7vfVqi1Yful7PDz13mQNg4DmJVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(33430700001)(8676002)(2906002)(478600001)(4326008)(8936002)(186003)(26005)(7406005)(16526019)(5660300002)(7416002)(44832011)(86362001)(316002)(103116003)(956004)(33440700001)(55016002)(66946007)(52116002)(7696005)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 33g4s4KUlCQIRCcxfu/As5VONlBUKQQUY2CD6bciH8DiH3CO3an0lWEgE5Kp2+bYY+nhiRJw0shHrwRrHdVMU5SPcgrrNlo3QJkvLyH2KFCON76cgzEcQuAuHJUZs2RdZQOFt4z55vjO6sX3Z55b0F2oca861VkrBjilGTGq23pgWfjwPoEb7/KAno/377rR9fML3HvQBdLgXXYET9+fy+i4lh3xMh4FdSMX+CCnXV7rphjml+l46QW+vhpbUwkDVmom6UmkmXni4GP1DcEcm/XViPBbaNQY+gma+GOUGaRtfnvkX7F2zbhMfgTziyTptFkoAr79HH3vGRiOEFcCw6RfoyXK8aMibwkNB+Y8GLcHQlOt7Qs+uosl59q9YjjUNA6PHn5tVZz12PoufjaiRE2Wt62mTDmIUTQhEdP5pZ05JnLqSiAL68T1N5J/ngUZcR2jUumo89rMFoz/VWxA60FdrUl8il8uj2ANTreUQVc=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45225a86-f351-45bc-7698-08d7f603a947
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2020 23:33:08.5979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TMSqZQTJ+fsRuIrStgm4e/SulLzLcRhSh2svgdypAqYr7OssZsUT45g2Uts2RQ78
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2478
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

