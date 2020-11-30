Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D33E2C92A7
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 00:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388858AbgK3Xdo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 18:33:44 -0500
Received: from mail-bn8nam11on2064.outbound.protection.outlook.com ([40.107.236.64]:11880
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388814AbgK3Xdn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 18:33:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pa91OK90B0XcG/Qo68m7Rf7lJcw27ehvotxgZOlDH5HO1kTM6gWK9cMC0FqDcj7kMvRCG5BiYsCRWV1O7vFgwej6kjyB3FcU7hg+6lBcQ44TYHrGqxOW+HPkpMelBrrrL84SCKkrxmw2KfWFFJsGpSzbGJN3dsx8+ZwcuF/5+VnDi9TbOBt1KDxej4ETe2n63ql5wXYfOH4OBRhHIRlV5kkHLqyd3NjzqWShO7WFF1xyUv9sWzJjmxigE6p5xIzzXNgPykI9mrHpq1hS9lk7MI4WZxurG8IfC0zpfoMV8YDDyuWpMadq7Cfs/TBIskPru32gSX8ojT/0+yQE/VhBFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6/W/Bj1oWA6as8Ly5QDHBEa5SeBoKho1LBHHRkltC9s=;
 b=ahVH2psgaoGoAhvJE3FNOBDE4Irdy2ZHPy8KoExKu73Ea1d6RqFPP5ugCqF27a8wW8yOlBoAeKgIE0q+9fqPCYXAL09iKg6Y3pmke2CBls8qBlLm4kbtU1LZp9z+b8HCPH+7j+7qM8ltjYkXItMIDKz9L4gJDBTavc8/F4iQ+rNbj79q+KTGRH9c7sEdpkSE2uHXbRFaRzdTjbXIXhURC/XH5VfKWbNJWdlkH0adNUTg3XD1Fhn99CUwdzftXb/yelpu1sbajyoKId+p9ukHYEz9UOa3HXnikMhNLnNhHRwacJioUoocav02SqktedS+ENuhGgNemDTV2NlvjK6B/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6/W/Bj1oWA6as8Ly5QDHBEa5SeBoKho1LBHHRkltC9s=;
 b=uBFKXQqwrgPGhLL4gV8aMtGTb4oLXlJM13y4AzHFyFwZ5I8fmI8XT7+2P/kjPgMiFI/+PpFjTMkIlrB4VWxdpyc9yup6/GwDVL4JJ9eI+SDDoInKtSGMdQx69kKCBuHRfb5Z5VrYt87wQi8CFv0GTuHPHaW0TbkxQBxmMJNzZ64=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4509.namprd12.prod.outlook.com (2603:10b6:806:9e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Mon, 30 Nov
 2020 23:32:18 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3611.025; Mon, 30 Nov 2020
 23:32:18 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        brijesh.singh@amd.com, dovmurik@linux.vnet.ibm.com, tobin@ibm.com,
        jejb@linux.ibm.com, frankeh@us.ibm.com, dgilbert@redhat.com
Subject: [PATCH 2/9] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
Date:   Mon, 30 Nov 2020 23:32:08 +0000
Message-Id: <75ca679a44a12cb482ddf75cb95943f74a594bad.1606633738.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1606633738.git.ashish.kalra@amd.com>
References: <cover.1606633738.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN6PR16CA0057.namprd16.prod.outlook.com
 (2603:10b6:805:ca::34) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN6PR16CA0057.namprd16.prod.outlook.com (2603:10b6:805:ca::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Mon, 30 Nov 2020 23:32:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e50db2f0-3909-452d-b1b1-08d895882d6b
X-MS-TrafficTypeDiagnostic: SA0PR12MB4509:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4509DDBAC97554CE841060EF8EF50@SA0PR12MB4509.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:289;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p5/VZU8MPXpp/KGq8WYFna6kyEViqTPLYgX9/o117Gk/ElsgwvKvgDW69CPXhIWjsmwCabdX+4CzONhgghSypgCgOsz5gSIL4HNwKzybQKd+rXdaYuhSF6bJZpjFRpBsvkilYjaaBVN3zs3/RGQbO4PVFQVrXFM00XzFFfoDgolTHammGREvj/DIq51eGHWZlP0iGGLABnIvq6YIiaivjgggt+6rw94OTX4Fmx2FMHzUleQVGLPdiWpI7dVWEwZFj0b7nHcKZqsavO8VM8GWSMfbt/CsA+mqJ9IRG2i3fzF9rdyLXaO6lej0P55pVDDBcQEJXBh3rhLg9tLW+vgsuw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(26005)(83380400001)(956004)(5660300002)(16526019)(7416002)(4326008)(86362001)(2616005)(186003)(316002)(7696005)(6916009)(2906002)(8936002)(6486002)(52116002)(8676002)(66946007)(478600001)(6666004)(66476007)(66556008)(66574015)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: VE3WGiOW1zp4jXxoR8Q7MGfDL1OAwUAzocKjsnatliN41aELV34W/ytsh5rD1nMm2EtL69uOKNMzaMDfFfs1Y+dyFIh9paKYwEa2gYBMWfiBN0UbWJ43ZncDm+0jaoID8S3CBGwzp1pL+hht3190trykt2c3FnKulqjod7LWH+yfqM7fvV7lNyhdFml7WwovhuAauEF5zdOr44dtc1/rkkpDZ9i9MjkRPZAdC097Bj2DC0bW4Ly9FmZQkwGMr2zxWO9g/I6QdydXGlJUCcS+TriA50qRc9OJazl++r4zkDKEgvQcCgQISH5SgVHfVLHS9HfHJOeE2c+LTtE8X/D4Qghw9EikJUZWVPbb0LME5yJaXrzc+tqACiXuzCsF43OZ0kBdE6gZTT+FWLaTsJ8IZY5p1v217hWMOg8ibBP/xNwyFzI5ob2BqutcldHsqKvJDGtacOFV6A2PxfrwsISV2XEFtx8N/udNKVuL5eZr0ZnAJtpBSCwifBm99kdSQSbnc+rYUMAtfsob2KORUAg0MZNDVySx+mhBdUismI6DDpabOmcBJaNIn9V9Eqgsn8AQ4aTonyJh0ZY2cIkzy5hEUTFvdQnWcsqE7EGhsmvS/TpydVhNB/ueSwqZCB9JBMYJ4xH1CnYCN+9M39Ssk9Ez/aMqL/hNS6vZMX9vHxyhZ6PBlcCNjFg8385/ElIlvJujhrOQo3ZHs8+vfxxmnDgWmOvgGqiu8XfwlhwSvwj5X+wmJ7k0uZCl+Cos8P9N+0y+
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e50db2f0-3909-452d-b1b1-08d895882d6b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2020 23:32:18.4577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YZ14Iyk1cEJlEewcyRKI7tfY7t0pwBqsqd6jlOHDEiEjx8fwZvY4xp9R3XBNjzuralQd2eOepsz1C77SIll3Uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4509
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
index 566f4d18185b..3e56d00aa1c6 100644
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

