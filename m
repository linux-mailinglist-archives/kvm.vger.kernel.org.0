Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B17915B687
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 02:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729404AbgBMBRn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 20:17:43 -0500
Received: from mail-eopbgr680062.outbound.protection.outlook.com ([40.107.68.62]:29957
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729285AbgBMBRn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 20:17:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F1EEGwl6RXl+/HC+XOPlqeUSNci6zbQM447QDTWzFO/7Dva8KBOQqoL0jZisNVrwGPmEEubJqRsE/epw07DNn1VKKlL2ML3IFlDnKf4F7raQ6qFXp7jlZhy2dpJ61IF3MgB/b49f9HAS/NBK6ZFi4A1hpa1X6VbiCyj8UXOmptGQEBhNPbOox9sGwmf2M+JofDYSQiwu7jsTDU+IXmxz0jj9zNlYmOQX9aLAlx3+Wp5q3c0iwf8Mgmjs8x4XCD4A/OnYlRhOdWmTzvvqosAnjn9yIxVfqcDDoFti8YrIq7K9S/3didrCHxAvEGoYRX6ePATcd13ApC+qCeru/sTi9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9hg4VVmNf/f9F05KEgjZ0Vg7G8pbRgtMtRuDuAXi9XE=;
 b=dQrHa5Qg4DGXtd7L3S4dYe35Zm5I/MZlNpMfQDeS71PQos6jv4H/39Cjjdp7PCJlzt6nkKY22MsLjGc5uprIF75bor1gMksgxy9ersXeiCPMvulmT8Fg+pT7Pe+3CXajHArO3qNO/rZ6Qj0ZJ6CcXRljgfr/JDRvkmSVSBqs0k+fjVVK5Dtjoe3Iobiem2dWU4YsI4ExOkjGdLxomHCXU8IJHNL42BXsdJHD4/rFThncyU0Yq2CSZOxZbRHJnEl4h6DFa6PNdJl3Wp1JnesahLXbDh06l249zlWxfz/sk3cNOZW5sikXr4uhztzUzKuyjVqVTC+y/VVmeRTmvVwX/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9hg4VVmNf/f9F05KEgjZ0Vg7G8pbRgtMtRuDuAXi9XE=;
 b=h2M7rZ9tkbjlh9IOkfikJe033qF8EZSXdt4G+iftc/d7h2L7LKKPYJY7NxSX9/GMj81TeoiP3xBXIJgHy0JO1DQ/iQYG+j2TIqjoja+UlkxYXzoobGAkq6TIS9eJtllJJlCGYRXkY45fqBDZx6Z14QyVhrTJa+seh8PNc6xSoKU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from SN1PR12MB2528.namprd12.prod.outlook.com (52.132.196.33) by
 SN1PR12MB2366.namprd12.prod.outlook.com (52.132.194.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Thu, 13 Feb 2020 01:17:39 +0000
Received: from SN1PR12MB2528.namprd12.prod.outlook.com
 ([fe80::fd48:9921:dd63:c6e1]) by SN1PR12MB2528.namprd12.prod.outlook.com
 ([fe80::fd48:9921:dd63:c6e1%7]) with mapi id 15.20.2707.030; Thu, 13 Feb 2020
 01:17:39 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, rientjes@google.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 08/12] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
Date:   Thu, 13 Feb 2020 01:17:29 +0000
Message-Id: <fc5e111e0a4eda0e6ea1ee3923327384906aff36.1581555616.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1581555616.git.ashish.kalra@amd.com>
References: <cover.1581555616.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR11CA0067.namprd11.prod.outlook.com
 (2603:10b6:5:14c::44) To SN1PR12MB2528.namprd12.prod.outlook.com
 (2603:10b6:802:28::33)
MIME-Version: 1.0
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM6PR11CA0067.namprd11.prod.outlook.com (2603:10b6:5:14c::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22 via Frontend Transport; Thu, 13 Feb 2020 01:17:38 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d971251c-1855-4793-e0b0-08d7b0228481
X-MS-TrafficTypeDiagnostic: SN1PR12MB2366:|SN1PR12MB2366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB23667DC0DF7E423CE1D2BB678E1A0@SN1PR12MB2366.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:323;
X-Forefront-PRVS: 031257FE13
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(366004)(376002)(39860400002)(396003)(199004)(189003)(8936002)(5660300002)(66946007)(66476007)(66556008)(7416002)(2906002)(6916009)(6666004)(4326008)(7696005)(52116002)(316002)(36756003)(66574012)(6486002)(86362001)(956004)(2616005)(81156014)(478600001)(8676002)(81166006)(26005)(16526019)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:SN1PR12MB2366;H:SN1PR12MB2528.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eArWVNBPKeN2n9HIZTuk3aG2GRIKJx+bdFSyKj+rLkqz0rRsHeiKpwo5ofj8FsavKVJxRVfjmpUS6UP0Iv3nFZ12SUPzK77HPapeyjy6r1pEpm4/MFiIE0Z3fQfm3dEWRzs32XqoU46G1whsvH5Xj5wBjpEEFkMWIU1C0xQqW1t7043zCTQ1lICAYK6nQsK5REtDpxqz2QAy6XmOaZo+P9SCP0IuJddig/I7SBB6XL+sQcy2+oSL7w6imD3m312wrvNPNtdf4bwwIVAiu4RaAvWQanAyB56WLroRYV1xHUgeY0i8VlX/jr1WtkTuMyBrNt3v8UsNbvsVoi4ZTHAVoYov6coH67VCjRPzxKm9RoP8+EvszNAsdlVWoInsDAM6CsYuqNuPWyOLCXkLjio7KWH06xbZW5kFJGvrK/yfYmFK1pCyb8Fv7BDZrmGsI+sg
X-MS-Exchange-AntiSpam-MessageData: yWGV9dKkglVUyLrqXgazT28+GrwWk+43Mzfr1IiDbJqKAWRr5OVaZ1oSfvlWH+nYyXaY4OXFvO2b7Gm99zQOsKlYiPAXQ9+hctHhd0fZWmOlH0WNp+4juLytMKCTQVzkQuoZ3lcB+1JtYbuMrtsHXg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d971251c-1855-4793-e0b0-08d7b0228481
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2020 01:17:39.5914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IiPm7I14DsX60em4xSOsKD75Jf5ch0a0jUeoUp7OyUVEVoP5RRVw3m/nsC5l61k3jF+yZZ3gIQOtl6YAvlF8Xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2366
Sender: kvm-owner@vger.kernel.org
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
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 Documentation/virt/kvm/hypercalls.txt | 14 ++++
 arch/x86/include/asm/kvm_host.h       |  2 +
 arch/x86/kvm/svm.c                    | 94 +++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c                |  1 +
 arch/x86/kvm/x86.c                    |  6 ++
 include/uapi/linux/kvm_para.h         |  1 +
 6 files changed, 118 insertions(+)

diff --git a/Documentation/virt/kvm/hypercalls.txt b/Documentation/virt/kvm/hypercalls.txt
index 5f6d291bd004..8ff0e4adcb13 100644
--- a/Documentation/virt/kvm/hypercalls.txt
+++ b/Documentation/virt/kvm/hypercalls.txt
@@ -152,3 +152,17 @@ a0: destination APIC ID
 
 Usage example: When sending a call-function IPI-many to vCPUs, yield if
 any of the IPI target vCPUs was preempted.
+
+8. KVM_HC_PAGE_ENC_STATUS
+-------------------------
+Architecture: x86
+Status: active
+Purpose: Notify the encryption status changes in guest page table (SEV guest)
+
+a0: the guest physical address of the start page
+a1: the number of pages
+a2: encryption attribute
+
+   Where:
+	* 1: Encryption attribute is set
+	* 0: Encryption attribute is cleared
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4dffbc10d3f8..4ae7293033b2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1256,6 +1256,8 @@ struct kvm_x86_ops {
 
 	bool (*apic_init_signal_blocked)(struct kvm_vcpu *vcpu);
 	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
+	int (*page_enc_status_hc)(struct kvm *kvm, unsigned long gpa,
+				  unsigned long sz, unsigned long mode);
 };
 
 struct kvm_arch_async_pf {
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index d86b02bece3a..f09791109075 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -134,6 +134,8 @@ struct kvm_sev_info {
 	int fd;			/* SEV device fd */
 	unsigned long pages_locked; /* Number of pages locked */
 	struct list_head regions_list;  /* List of registered regions */
+	unsigned long *page_enc_bmap;
+	unsigned long page_enc_bmap_size;
 };
 
 struct kvm_svm {
@@ -1992,6 +1994,9 @@ static void sev_vm_destroy(struct kvm *kvm)
 
 	sev_unbind_asid(kvm, sev->handle);
 	sev_asid_free(sev->asid);
+
+	kvfree(sev->page_enc_bmap);
+	sev->page_enc_bmap = NULL;
 }
 
 static void avic_vm_destroy(struct kvm *kvm)
@@ -7581,6 +7586,93 @@ static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
+static int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
+				  unsigned long npages, unsigned long enc)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	gfn_t gfn_start, gfn_end;
+	int ret;
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
+	ret = sev_resize_page_enc_bitmap(kvm, gfn_end);
+	if (ret)
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
+	return ret;
+}
+
 static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -7972,6 +8064,8 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
 
 	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
+
+	.page_enc_status_hc = svm_page_enc_status_hc,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9a6664886f2e..7963f2979fdf 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7879,6 +7879,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.nested_get_evmcs_version = NULL,
 	.need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
 	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
+	.page_enc_status_hc = NULL,
 };
 
 static void vmx_cleanup_l1d_flush(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fbabb2f06273..298627fa3d39 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7547,6 +7547,12 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		kvm_sched_yield(vcpu->kvm, a0);
 		ret = 0;
 		break;
+	case KVM_HC_PAGE_ENC_STATUS:
+		ret = -KVM_ENOSYS;
+		if (kvm_x86_ops->page_enc_status_hc)
+			ret = kvm_x86_ops->page_enc_status_hc(vcpu->kvm,
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

