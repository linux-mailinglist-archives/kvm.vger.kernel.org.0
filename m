Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE6CF2C9434
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 01:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389120AbgLAArb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 19:47:31 -0500
Received: from mail-bn8nam12on2071.outbound.protection.outlook.com ([40.107.237.71]:20033
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729483AbgLAAra (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 19:47:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LXVZ1NJFH4Io9XRzdABUCCEtCrWJbf5sD+Fi5ssfsV0sUZXK/3bIljhy5Bwr3Fuuy7f4kaJkN6j1SUMCK9XGOZMDG/ajS2XZGzXljTTmSgFzPEAJQF6TVL2lC/5cREG9m/+uj4fxKUIT/69jHS735L8bYAdB14mlS6u6bR94u6/LxljMWlnzhNYD0lx7Q5R5pWm2ZRpzZlip7sgpoAoLpFAwNMUe/yIJ6rtBquzkAZOx6RF+XCSK0mDQpgrDdOe6L1WX+lq5d2vfOO3+exejByWYIu4sCnn6RuiMpMvELDDtRHM5c3D9JRJDajS3gMLNe8b8rBHhjvy9koY5Jm94Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ifQSUw6m5ce3Ns1/AZJ87k4sULco/sqI2cNQoGJCFIk=;
 b=dzwiLTKWtXYkmXHfEo9O/OFVt7ANNNwJKo6DVnGJJhvwmQB/0TDYOCZxrfxkdPo5UnX2c1LsY9VwkMIV7NxwVZQi0xgnkLGVjxzjI0V5ir9ESDWYaGtUO7My8/44PXnVmlGJTLXMmN+CXqL1WzoiYDXB1QOi7GWY+fkw5YyjFNiZJZ9z9U9ObcuGOPgm4CAuATLkKEFoqi3/hkmY9K5h5kV/yw3eYr3gWG1Akj7DkpM+AXtv5pOHCZLjMetAhXu74bzpw/JlNu75ZnoBG3yzvzDqQCRyXWOkqLCT2/NKU5KZDkOG3KqhGi85DSzUmjPCVzCxa9dFa7YplF6UvRGv0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ifQSUw6m5ce3Ns1/AZJ87k4sULco/sqI2cNQoGJCFIk=;
 b=zlC+Z0d4zIBO2MFPy2wQv8ZecviZwy2nBDXSjtO+6AO8SvddhA4a1kKRRe2bjKULcHX7fmZy6dZoTnB3ZA6/59CfGINpdm1o0DE9QCY96eepF70R2g09eoEU2D+3QBKtOGGkoscEdWSf4iEKe9AvNnGLYbpliXF25bZzntRbW3Y=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4573.namprd12.prod.outlook.com (2603:10b6:806:9c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22; Tue, 1 Dec
 2020 00:46:56 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3611.025; Tue, 1 Dec 2020
 00:46:56 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, brijesh.singh@amd.com,
        dovmurik@linux.vnet.ibm.com, tobin@ibm.com, jejb@linux.ibm.com,
        frankeh@us.ibm.com, dgilbert@redhat.com
Subject: [PATCH v2 2/9] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
Date:   Tue,  1 Dec 2020 00:46:20 +0000
Message-Id: <40acca4b49cd904ea73038309908151508fb555c.1606782580.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1606782580.git.ashish.kalra@amd.com>
References: <cover.1606782580.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DS7PR03CA0066.namprd03.prod.outlook.com
 (2603:10b6:5:3bb::11) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DS7PR03CA0066.namprd03.prod.outlook.com (2603:10b6:5:3bb::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.26 via Frontend Transport; Tue, 1 Dec 2020 00:46:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fee60356-5f98-4f8e-99ad-08d895929a5a
X-MS-TrafficTypeDiagnostic: SA0PR12MB4573:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45734C917B84EC092F4FA6178EF40@SA0PR12MB4573.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:289;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fr0MJ+2leTnLgPQMGF1Gn8Y+vYXEbB/MqriUs8gDNSk2UQWAa0G+l5QspNzRJ5ZLIVO1psbwiztmFRfeNGLCmToo0sYYWhMvkmiSiG3eA96XJ2XD1RuclpE4JJDz9ZqiWZCNQPqCcXE1Rkr9tPi0AfSQ9KdAF9t12TX3ZU9s/aLQFHxMUPpzVEKG1XI+tTjKE5yLQTrKfHDj5nHcgb1n4ae5B5jBMpXwABTEZkNfThFPO6U0QFXVOTbVCxpl9spN1BGGA7hQCUkNGgQxJGZRNFzlKvAFL3SV+DXZpiAnZ7n0925m06VWhVB1IuFzVAOB40Unj7TMD3fgDgv5JofgXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(136003)(396003)(39860400002)(478600001)(6486002)(7696005)(316002)(4326008)(956004)(6666004)(8676002)(186003)(16526019)(8936002)(52116002)(66946007)(5660300002)(7416002)(2616005)(83380400001)(86362001)(26005)(2906002)(36756003)(66556008)(6916009)(66574015)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Qll4YlNmWGF4d0tSalpNV21oUmhEbFR3Y0dRYW1jU3JmQmRlK3hqQVp5Rm1C?=
 =?utf-8?B?eGZJaUw2aXV4ODFkZlp4S0UwaEJvV3JUQlhmYlQvVmtsZ21MZ3g3cG96UzY4?=
 =?utf-8?B?Yk1ORUp0K0IwUEhJcU52M2ZpVW5IeXA4SzUrbjl3UktSNXJUcWp2ZFZMcFYy?=
 =?utf-8?B?cXdhS2tzYWNlZzRQSXVlQzBaNmVlNEhMSm9Zem5RTWJZUnl1VE5zUTRwYTJW?=
 =?utf-8?B?akNZSmZaOTNuUk9lUHVJRW0yekR1VS9OUngzekhJUjQ3VGY1dGVlU0lMUGtU?=
 =?utf-8?B?NlQvOHFZK24yZ2l2ZS9WSVVCdmhZTnlCUVhTcXpsWExTRktuOVdlVnZiYjk2?=
 =?utf-8?B?Y0hOOWtoT0NoT1hYK0xMTVM0d01POWhhMitEOTdUb29QT2JnTlY0dW9ETkNR?=
 =?utf-8?B?aXhLNU12Q2FHeWh0U0Y1Q2N3dkZlR0NuWEFRZE9ic3ZsTVB6VjZXNzNWcFBH?=
 =?utf-8?B?NWN6VEJDQW0vYm8wY1M1YXVWNitSbDNPQ0xFVXZBWjdSMHAzUTYwMnZpbkwv?=
 =?utf-8?B?VURJbFpsTXN5T1Y2YlhWb2RLRGdLbHAyeGlVYWFJUFRiSWlsVE9MUmg0SnlR?=
 =?utf-8?B?VWhxVHRkWlc1Z3N2Ky9EaWtiRjdON1U5bEUySjUxS0NyUDZ0Um5CdnRycCs5?=
 =?utf-8?B?cVBuTmRwUEtFSnlBeUMwQjR6WkdHYkNOSEtJc29YdElYckRtSFdnQW9NWnBr?=
 =?utf-8?B?Q25iVmlObFRxQmRPd1E3cUFuV0pzNXRNWjZuMnpaTmJmZmVGK3liVXNiOUli?=
 =?utf-8?B?ZG1XUWdUM29uWjZkNklQOU5USk8zN2Z3UlFWZnh4SEpyQ09TcTB3VUViSVJ1?=
 =?utf-8?B?MVQrSUZpZ3lhUXVLQUhCWXFKWmxFaWVDaTNGVnNuOU4zdzN3SDVCV3hNM21F?=
 =?utf-8?B?UUN2Tk4yOUpGVjFZNFkzL1VYbEhhZzg1aGNYSTljamJGY0dFT1VuVDBITkt5?=
 =?utf-8?B?NTFId0xISjMvemFDOE8xNzZtNHhvMjI2c011YkJXRjNDSUxvY1NNa1Y2WlpR?=
 =?utf-8?B?S09ENXY3SC93WDdCejdXQ1JCbnpFVFFLT2VwV3Z1RFJwUFdpaDRZQmgvNUYz?=
 =?utf-8?B?YkFiUWc2c0M0QzhFMyt2SlYwS2xINlArakdkSDhJTXlWMjFIRGtaQXRWVDNa?=
 =?utf-8?B?YkxpRXJLcjYzcENvMjNSdU4ycVdBMUJyS0x0ZXVWWm8wSUZnR2RWdmcwQ2Jp?=
 =?utf-8?B?T2U0cXkrT0VSOFc3ekRWR0FiWnYzVEt6aTRGRVltdnI0YXFwT0JOcmpDclhO?=
 =?utf-8?B?eTE1NXJMQnlZd2UzSFZ2dzB5RHpxK2xHWStwYmJ4QVRoNUp2bElyYkRWV1Rp?=
 =?utf-8?Q?0aC8iIre7i0tFD+Xvynx3xQ5e8Dwmbsnuq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fee60356-5f98-4f8e-99ad-08d895929a5a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2020 00:46:56.1547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dcz/nINimGimjPFhk/CeRiOmkmaKbeqZw0HO/OdVtZOZ/ec0DPs7JANbjB2EpdL5CZAOHUNNqUKXPYjt2O0fkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4573
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

This hypercall is used by the SEV guest to notify a change in the page
encryption status to the hypervisor. The hypercall should be invoked
only when the encryption attribute is changed from encrypted -> decrypted
and vice versa. By default all guest pages are considered encrypted.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Radim Krčmář" <rkrcmar@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Venu Busireddy <venu.busireddy@oracle.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 Documentation/virt/kvm/hypercalls.rst | 15 +++++
 arch/x86/include/asm/kvm_host.h       |  2 +
 arch/x86/kvm/svm/sev.c                | 90 +++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c                |  2 +
 arch/x86/kvm/svm/svm.h                |  4 ++
 arch/x86/kvm/vmx/vmx.c                |  1 +
 arch/x86/kvm/x86.c                    |  6 ++
 include/uapi/linux/kvm_para.h         |  1 +
 8 files changed, 121 insertions(+)

diff --git a/Documentation/virt/kvm/hypercalls.rst b/Documentation/virt/kvm/hypercalls.rst
index ed4fddd364ea..7aff0cebab7c 100644
--- a/Documentation/virt/kvm/hypercalls.rst
+++ b/Documentation/virt/kvm/hypercalls.rst
@@ -169,3 +169,18 @@ a0: destination APIC ID
 
 :Usage example: When sending a call-function IPI-many to vCPUs, yield if
 	        any of the IPI target vCPUs was preempted.
+
+
+8. KVM_HC_PAGE_ENC_STATUS
+-------------------------
+:Architecture: x86
+:Status: active
+:Purpose: Notify the encryption status changes in guest page table (SEV guest)
+
+a0: the guest physical address of the start page
+a1: the number of pages
+a2: encryption attribute
+
+   Where:
+	* 1: Encryption attribute is set
+	* 0: Encryption attribute is cleared
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f002cdb13a0b..d035dc983a7a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1282,6 +1282,8 @@ struct kvm_x86_ops {
 
 	void (*migrate_timers)(struct kvm_vcpu *vcpu);
 	void (*msr_filter_changed)(struct kvm_vcpu *vcpu);
+	int (*page_enc_status_hc)(struct kvm *kvm, unsigned long gpa,
+				  unsigned long sz, unsigned long mode);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c0b14106258a..6b8bc1297f9c 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -927,6 +927,93 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static int sev_resize_page_enc_bitmap(struct kvm *kvm, unsigned long new_size)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	unsigned long *map;
+	unsigned long sz;
+
+	if (sev->page_enc_bmap_size >= new_size)
+		return 0;
+
+	sz = ALIGN(new_size, BITS_PER_LONG) / 8;
+
+	map = vmalloc(sz);
+	if (!map) {
+		pr_err_once("Failed to allocate encrypted bitmap size %lx\n",
+				sz);
+		return -ENOMEM;
+	}
+
+	/* mark the page encrypted (by default) */
+	memset(map, 0xff, sz);
+
+	bitmap_copy(map, sev->page_enc_bmap, sev->page_enc_bmap_size);
+	kvfree(sev->page_enc_bmap);
+
+	sev->page_enc_bmap = map;
+	sev->page_enc_bmap_size = new_size;
+
+	return 0;
+}
+
+int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
+				  unsigned long npages, unsigned long enc)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	kvm_pfn_t pfn_start, pfn_end;
+	gfn_t gfn_start, gfn_end;
+
+	if (!sev_guest(kvm))
+		return -EINVAL;
+
+	if (!npages)
+		return 0;
+
+	gfn_start = gpa_to_gfn(gpa);
+	gfn_end = gfn_start + npages;
+
+	/* out of bound access error check */
+	if (gfn_end <= gfn_start)
+		return -EINVAL;
+
+	/* lets make sure that gpa exist in our memslot */
+	pfn_start = gfn_to_pfn(kvm, gfn_start);
+	pfn_end = gfn_to_pfn(kvm, gfn_end);
+
+	if (is_error_noslot_pfn(pfn_start) && !is_noslot_pfn(pfn_start)) {
+		/*
+		 * Allow guest MMIO range(s) to be added
+		 * to the page encryption bitmap.
+		 */
+		return -EINVAL;
+	}
+
+	if (is_error_noslot_pfn(pfn_end) && !is_noslot_pfn(pfn_end)) {
+		/*
+		 * Allow guest MMIO range(s) to be added
+		 * to the page encryption bitmap.
+		 */
+		return -EINVAL;
+	}
+
+	mutex_lock(&kvm->lock);
+
+	if (sev->page_enc_bmap_size < gfn_end)
+		goto unlock;
+
+	if (enc)
+		__bitmap_set(sev->page_enc_bmap, gfn_start,
+				gfn_end - gfn_start);
+	else
+		__bitmap_clear(sev->page_enc_bmap, gfn_start,
+				gfn_end - gfn_start);
+
+unlock:
+	mutex_unlock(&kvm->lock);
+	return 0;
+}
+
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -1123,6 +1210,9 @@ void sev_vm_destroy(struct kvm *kvm)
 
 	sev_unbind_asid(kvm, sev->handle);
 	sev_asid_free(sev->asid);
+
+	kvfree(sev->page_enc_bmap);
+	sev->page_enc_bmap = NULL;
 }
 
 int __init sev_hardware_setup(void)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6dc337b9c231..7122ea5f7c47 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4312,6 +4312,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
 
 	.msr_filter_changed = svm_msr_filter_changed,
+
+	.page_enc_status_hc = svm_page_enc_status_hc,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index fdff76eb6ceb..0103a23ca174 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -66,6 +66,8 @@ struct kvm_sev_info {
 	int fd;			/* SEV device fd */
 	unsigned long pages_locked; /* Number of pages locked */
 	struct list_head regions_list;  /* List of registered regions */
+	unsigned long *page_enc_bmap;
+	unsigned long page_enc_bmap_size;
 };
 
 struct kvm_svm {
@@ -409,6 +411,8 @@ int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 			       bool has_error_code, u32 error_code);
 int nested_svm_exit_special(struct vcpu_svm *svm);
 void sync_nested_vmcb_control(struct vcpu_svm *svm);
+int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
+                           unsigned long npages, unsigned long enc);
 
 extern struct kvm_x86_nested_ops svm_nested_ops;
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c3441e7e5a87..5bc37a38e6be 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7722,6 +7722,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 
 	.msr_filter_changed = vmx_msr_filter_changed,
 	.cpu_dirty_log_size = vmx_cpu_dirty_log_size,
+	.page_enc_status_hc = NULL,
 };
 
 static __init int hardware_setup(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a3fdc16cfd6f..3afc78f18f69 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8125,6 +8125,12 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		kvm_sched_yield(vcpu->kvm, a0);
 		ret = 0;
 		break;
+	case KVM_HC_PAGE_ENC_STATUS:
+		ret = -KVM_ENOSYS;
+		if (kvm_x86_ops.page_enc_status_hc)
+			ret = kvm_x86_ops.page_enc_status_hc(vcpu->kvm,
+					a0, a1, a2);
+		break;
 	default:
 		ret = -KVM_ENOSYS;
 		break;
diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
index 8b86609849b9..847b83b75dc8 100644
--- a/include/uapi/linux/kvm_para.h
+++ b/include/uapi/linux/kvm_para.h
@@ -29,6 +29,7 @@
 #define KVM_HC_CLOCK_PAIRING		9
 #define KVM_HC_SEND_IPI		10
 #define KVM_HC_SCHED_YIELD		11
+#define KVM_HC_PAGE_ENC_STATUS		12
 
 /*
  * hypercalls use architecture specific
-- 
2.17.1

