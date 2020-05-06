Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3871C7CFB
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 00:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730071AbgEFWCc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 18:02:32 -0400
Received: from mail-dm6nam10on2044.outbound.protection.outlook.com ([40.107.93.44]:6101
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729981AbgEFWCa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 18:02:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kFYACvTt/q+0E4veYw3/GbCYI4oKERVetl3iw5A/wbDUrt9OKA+DB60n4/RXDIdQQsEbyu0j1tWuO3U+BNiFY+RRPdGjFaKWXdTY2/XrhFOsXqeoywUWvCDhAOwppQFsgq+RrGj3UpQ8kTEvmcb0EQn/HceJ2IMWmmZ7xtSTFNq66qTOt5skaGq3s2lvvxzqh36Egrgq33ngEiKNrzmV/LAiRnWQ4KLOgkJzzwtqGGakWrt5qdffFK4kvmbb3NuO7zFNWmrUOtwbLd4egFO4LgbbY11fdHHUcZ9UJmVD5L2qjrHWYxOop5CBUtF1fbCgZMrPy0qgzk2Er35cF23XZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hg+GvtMV5Nsl0jslmtCbYCPaUDAdn+kfBfk+6pOH/4U=;
 b=SuQTQsAiQplFZhEB5HVxtKUHCqfHR3blhEHWCUUo8T07Kmm+/XdCFZCxCcdyCY4p/zeEBPIDBH6WFVIG5x+b+mFIxS4AxL6QnsB/L25KaLjkdFzrH4OtgTjOTb5iKTg2PItKO3FWoHpKeu7q9scbElK/vDWvXYUbYt6iKAi81yEK24ul8e4N6C1agi0EdkAdTL92cws3cZUaFZWqlMj923CUCrKs9XT4jFN/ydc3tvysBVzwxgQLCp28Svh91paULE7O0c+rBOVUJhgrNGyRVDaOwHMl6B4VO1DQz3Sb+0TlPgs/2JUfft41G5U7CbzvW1nJn4OH4cx9/1NdwflWCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hg+GvtMV5Nsl0jslmtCbYCPaUDAdn+kfBfk+6pOH/4U=;
 b=tEdPv01a5QoW7GdDI7Ti7Oqb2LexkZaBOPCvgw4U1CymA3XX/RaDSGnX4GnSPEsH6UG1sdsm04fpH22JTtv8GFBBVZhaKlK4byzPXosuQ5VYnJcQkLO8rRBZ6E91XfGQLUXuVmzcDeNLO9ZEGR9hjy7OYw5sH2eUls/lhnFINk0=
Authentication-Results: tencent.com; dkim=none (message not signed)
 header.d=none;tencent.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2512.namprd12.prod.outlook.com (2603:10b6:802:31::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Wed, 6 May
 2020 22:02:23 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d%7]) with mapi id 15.20.2979.028; Wed, 6 May 2020
 22:02:23 +0000
Subject: [PATCH 2/2] KVM: SVM: Add support for MPK feature on AMD
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
Date:   Wed, 06 May 2020 17:02:21 -0500
Message-ID: <158880254122.11615.156420638099504288.stgit@naples-babu.amd.com>
In-Reply-To: <158880240546.11615.2219410169137148044.stgit@naples-babu.amd.com>
References: <158880240546.11615.2219410169137148044.stgit@naples-babu.amd.com>
User-Agent: StGit/unknown-version
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN1PR12CA0082.namprd12.prod.outlook.com
 (2603:10b6:802:21::17) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from naples-babu.amd.com (165.204.78.2) by SN1PR12CA0082.namprd12.prod.outlook.com (2603:10b6:802:21::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Wed, 6 May 2020 22:02:21 +0000
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ede7d559-36fa-482f-2f55-08d7f20927e1
X-MS-TrafficTypeDiagnostic: SN1PR12MB2512:|SN1PR12MB2512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB251220294A65ED439D50CC2295A40@SN1PR12MB2512.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 03950F25EC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kqRvQ8v+dZ1eCkVKjq4/v0LZSHXGQsoHpD9AnHhGVe7Wap7msDSrGlKgoE3XMf455djII9gWDUpu8UZxc7dxCMg3TfahqZWnwwABeIhAXY5ISMQgkV8OWKeXtND2gVqQ+lKbbZ7PF73UyTQ71weeGvU1TPe7ANQ4KSEj5AbK3QWPJ+h/bR3XR92+0+DW1QN58YWC6zZ4HhBF4mcvlZW42398JNn1YXzP/kMPphlh6OzEONhQceOAYtsoY0AOAlttEJAaz4T1uhTTxApbuEfGZpxOPSSztvclvAhOOMTHJ2899zRQ9Y2aaIUOgaaMhqYSDgyjQtUY82rxJOu6k0VylKHH7f0a1VTehs2Gq0CqgqTY3diSN+SFO7a514OyOBYBxaV19mwQwMiqx+NaRMWvDC9+8owCNVwTZgTdZTzB3esofcJt2kKAfBjgQLszTKlBZbtUgtDF0qNyJIs1aUeZGTVTDcuuL5mQ5MdmGV5Nk71Jhv+exasV0C6r34lFdgYW+A6ft36Pp0VO91LR3vwZJoHXDqFO6K/K6JXdScWcnU8hvtVtv2ZOg3hByPaiF8d5Y+tVS3X6mQ/YLUjk7LtuT2IREpkSEsIMhT69SVE9Pts=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(136003)(39860400002)(396003)(366004)(33430700001)(26005)(52116002)(7696005)(4326008)(2906002)(8936002)(33440700001)(66476007)(66556008)(8676002)(16526019)(478600001)(55016002)(186003)(103116003)(966005)(316002)(86362001)(956004)(66946007)(7416002)(7406005)(5660300002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: vpst/WTqMQWHSRvAXkjLQcr0vfujY4Fm/L5l/4ttFUAL115KzIgoIlKWckjO6Yjucq1uoqEhcF8hTO+y44jlUynIY+Utl61U/8pIlNaJOzpLN1yAHPVrEx4lMBs/r4GFJ8I/viNxDVRbFbB5+HbBpD8j5LM+dOI+K00mVvZjBEesR+7PyLWM0GdXVJPstWgxQf57ammXPHTj57Utgoh2WpAC36TwnKpBuGPd2xI/peW/y7fJSorelsfvi5JTTE7OduQLMt3ELy0tqyeIYn0kJO9sw0VfiSz/fm294KPtj88zx/Jk73sbygy6Lu5DWvRlOMiqzUB24kcfe8dYSVOKmuUbOKwV/ptrMRYQg1/soNqyeL5xZhbqeGfjmEfyrGypYk9mVVEP2w5lcBuhdRHRTby+VSc7uNb/occTn/DbjwaIaxyFT6yzNoR3W/hPw71BN11MGyPr5YHTnSu+2NuJbJjWzQPIw//8LdkFT8PVN4Pg3KS1uSYWjrOeK9NETUD73bsAk4Mfj6kiRdkpvCHAGHzrzoN9IJKb7O/A6ARSJnFqdaXOOxQMkXUsef8nozBUc6dLu6t4J4WOT2JMjBGGjTVj8ZFeCPoCJI8/2O+A8VPTl4qrVkvOcXlopWrA8Ziky9OUcngwz0HjDxwx1DT1PM2/rFN4jGr4SCyPm2b9t+ioAJ2+Ez19XXpkm+AWgvRa5UcJoBaRKseQRQ3U29773yF0VdAzC8Oz/A/PkcxfPgbTQpLjx1TRKObmjjEgLFbG4yOoMcUmeVrSU0QXU2c6igbx+eDQdHGERqGMtmSBUCk=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ede7d559-36fa-482f-2f55-08d7f20927e1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2020 22:02:23.7079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8L3rbj/1Bv6hoe9dUIu7htWOidCBRN+vpvRXJIQhd1dBEKK00TErdsdVxjUqpnj4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2512
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Memory Protection Key (MPK) feature provides a way for applications
to impose page-based data access protections (read/write, read-only or
no access), without requiring modification of page tables and subsequent
TLB invalidations when the application changes protection domains.

This feature is already available in Intel platforms. Now enable the
feature on AMD platforms.

The host pkru state needs to be saved/restored during the guest/host
switches in SVM.  Other changes are already taken care by the pkru
common code.

AMD documentation for MPK feature is available at "AMD64 Architecture
Programmer’s Manual Volume 2: System Programming, Pub. 24593 Rev. 3.34,
Section 5.6.6 Memory Protection Keys (MPK) Bit". Documentation can be
obtained at the link below.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537
Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/kvm/svm/svm.c |   20 ++++++++++++++++++++
 arch/x86/kvm/svm/svm.h |    2 ++
 2 files changed, 22 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2f379bacbb26..de327f02470f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -818,6 +818,10 @@ static __init void svm_set_cpu_caps(void)
 	if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) ||
 	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
 		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
+
+	/* PKU is not yet implemented for shadow paging. */
+	if (npt_enabled && boot_cpu_has(X86_FEATURE_OSPKE))
+		kvm_cpu_cap_check_and_set(X86_FEATURE_PKU);
 }
 
 static __init int svm_hardware_setup(void)
@@ -1300,6 +1304,8 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		indirect_branch_prediction_barrier();
 	}
 	avic_vcpu_load(vcpu, cpu);
+
+	svm->host_pkru = read_pkru();
 }
 
 static void svm_vcpu_put(struct kvm_vcpu *vcpu)
@@ -3318,6 +3324,12 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 	clgi();
 	kvm_load_guest_xsave_state(vcpu);
 
+	/* Load the guest pkru state */
+	if (static_cpu_has(X86_FEATURE_PKU) &&
+	    kvm_read_cr4_bits(vcpu, X86_CR4_PKE) &&
+	    vcpu->arch.pkru != svm->host_pkru)
+		__write_pkru(vcpu->arch.pkru);
+
 	if (lapic_in_kernel(vcpu) &&
 		vcpu->arch.apic->lapic_timer.timer_advance_ns)
 		kvm_wait_lapic_expire(vcpu);
@@ -3371,6 +3383,14 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
 		kvm_before_interrupt(&svm->vcpu);
 
+	/* Save the guest pkru state and restore the host pkru state back */
+	if (static_cpu_has(X86_FEATURE_PKU) &&
+	    kvm_read_cr4_bits(vcpu, X86_CR4_PKE)) {
+		vcpu->arch.pkru = rdpkru();
+		if (vcpu->arch.pkru != svm->host_pkru)
+			__write_pkru(svm->host_pkru);
+	}
+
 	kvm_load_host_xsave_state(vcpu);
 	stgi();
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index df3474f4fb02..5d20a28c1b0e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -158,6 +158,8 @@ struct vcpu_svm {
 	u64 *avic_physical_id_cache;
 	bool avic_is_running;
 
+	u32 host_pkru;
+
 	/*
 	 * Per-vcpu list of struct amd_svm_iommu_ir:
 	 * This is used mainly to store interrupt remapping information used

