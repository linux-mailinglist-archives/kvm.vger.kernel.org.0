Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC511BF331
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 10:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbgD3InV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 04:43:21 -0400
Received: from mail-eopbgr700045.outbound.protection.outlook.com ([40.107.70.45]:54881
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726765AbgD3InV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 04:43:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cVb6zaTegTw4CAdYUSs9zd6u3Qhcbt5yLDsKWJsQIJpCK3QbpPPwSLSmgziGvTLs9igm467/5PKgzbGduQ/tSIYDZszkotdE1pzcGO0x8gEm7L0Wb9iJXiJZZ/1FfJ16G8KODkC5FxTwcqzQGZB0qtOcaHQGkAhlgdxJVw0N3EkgiQ42tIfgsf+oJgBalpqYwgtpZZp2IW88+Yw296sVuZ/YIg0XecByS8BuQU9bxUEJGtu3PU8HgzncOMWyLQJZusDTK+jlN36RLE8J584tgcnT2dCuSPNVpsynMVAJ42blP7oZi35Po1mychgDQTyKlX/JcV0aQVwucKPe0ONVVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=th9gCGQ91L9XX4ZbdL4mIFdQGKabGX+H5YWFfqm6wpI=;
 b=J6oIRYSSyZsgox2GuCK3UHRUPqhULQmwfFIy300zO9TKR6SSHOtI7BWCHI516e4I26lhVFlJGc1S2UyFthWSvTpNgkLh8wvW8TI2QVazea5hq17a5Wuojk/mIolnvmFinDhdeAkm7hJo6NhnnE4S32kVlEN/4cC5+7axtYafvbhn8GEYRBNUWfOO5WtHLGeU6DQpUuxniqQ2Tc4bVx5F8xDP0DKlBIFLEL+RD2zVnlvHa22hEQLX5brogSwXE9dMzRP6uvIvRt9dy0WPnj8ygFWjpmNfrxTE/ULwmAC8OGpXCYLmnuu5ejggB4m9gLE+4XOhxarjLB3q515Ka0eDfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=th9gCGQ91L9XX4ZbdL4mIFdQGKabGX+H5YWFfqm6wpI=;
 b=JHRLDGPxJ05LI1dE1EX7yNDdtxO/W4NVL2HU/+HJQo4YrX3NCKQ2fr73OEgzzqTr8RzH3UtrAIe7AcV75XjHfTpYNB0VZT9WUSvIOuiIR4d01qC03IHKpRsk25ACTwLGkBKyrU0iR2fFnd54huAMqozIsny2ukIRpW0fYuyQzzM=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1883.namprd12.prod.outlook.com (2603:10b6:3:113::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.13; Thu, 30 Apr 2020 08:43:18 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 08:43:17 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v7 08/18] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
Date:   Thu, 30 Apr 2020 08:43:08 +0000
Message-Id: <e4bc3979b1797188deb75994e698a03d4fdbd143.1588234824.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588234824.git.ashish.kalra@amd.com>
References: <cover.1588234824.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR02CA0133.namprd02.prod.outlook.com
 (2603:10b6:5:1b4::35) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM6PR02CA0133.namprd02.prod.outlook.com (2603:10b6:5:1b4::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 08:43:16 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a4fa82e9-b60b-43e8-e20e-08d7ece28779
X-MS-TrafficTypeDiagnostic: DM5PR12MB1883:|DM5PR12MB1883:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB18836B199BF4AC11AE045BCD8EAA0@DM5PR12MB1883.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:323;
X-Forefront-PRVS: 0389EDA07F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(366004)(136003)(376002)(39860400002)(478600001)(86362001)(956004)(8936002)(26005)(2906002)(2616005)(6916009)(8676002)(36756003)(6486002)(7416002)(4326008)(16526019)(186003)(66574012)(7696005)(66476007)(5660300002)(66946007)(6666004)(52116002)(66556008)(316002)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k2RxeY3oMUm87IUTy/1S2GTb7Xii4u7JwgcaIcz5Yzb83ASa4SNZin/AS1wTwIXNtF/sSEk41INoZhdICimKq/I2V6DjPxEPoiCUza/uowZnkoDfsjoB7XM9hp4pyq7fh5KQUGtkzdzByI1QvelbaFmyTOsCjN/aodzYwl6tvpPg7TtJs5K6Jv5UmVrp6K+Zdlz1MQhgbWcJIkWk2CUjb3X5mYbzfFyClFe2oXqcwaoqUScFGk2lhrd5ZOytXnDO9+45XCY7lAyW/6lkUVmrAeLmbi7QzxaZIgbMCb89du5WOJ//yM8cElk9bY7Qbc7TJ5FyucgHnGv6U5T/T3kZjsOtKD3axbHfbTfEtgxEPQU9K8cAV+mD1KGvpj8jHyftvQFORy3dqNPBKHd2ad/TKn8KbBEwEjyx/X1Lr4txaYCOCZ5QKRQeJGM+8Y9LicptiZfovxJBuTBZPzbRNpe77bebSiEhLy2kgeYVdaaYixHLM+Hf55LbFCaLXulrFd52
X-MS-Exchange-AntiSpam-MessageData: STgdo3WnvWXp8dSfsaOztMje/cTfZhGV7GDGhZZayc6+GMMWSEF0woU0qPDQkzSb4tlNTlDMl+RiewFZ8M1We2qoxehCZ7dx6mYCrwTAPXh+I9I/nnISV/DTJP2Eh/A6MJWFfvkM4Kt4AIBUQZh5FQPVMzDtyy32oxajoWQLuv+ASOkYq8UeFBz4hA5y+YASVB1iC0mZJmdvUxJ1xzNL6zfnu8QGGWWhAr9i8PTank5LEpL0J0/YkDgjWm4tVvEGC5xIf+ndFiB6qFrqAixTpc5wI5BTnnGJl1zEDIYiaYQwram9pwcGPG3mg7e4TSUx869wR3QKEXkM2+YCwDQYv/DwgUP9s9hggzxsSlmWpATfSk7TZPkmBUYcUtxhuGCYzsycIzppYmHtEGPI+wDArh398UNWv6BfcMg+Eb46OqEnEpmxbL+VbKNsGwuVSwGbUfQkowbj7k+F2ho4BF8XivEgGlceKHVbzgNW2Gbd9HLkudurvwPEiYqKqrIKvyR8C6rcSbmK8qICkiB/HshzzSz/ZjG3a0Zt5obcSItlzyAfXzzYdt5CF7c14L5rgx3zJxhvtx/3MKE23M7R78S+VHhNg/JHZ+Kn5TK809qjOL1PdLxelLYwip6SMwvAZbF+5pTgIb4k9fI7ZZMP+sTuzTh4Aa/BtLYqGF31WmfsU0UKfrqQQpjdB/mqAnnHI/fLpUALMy270BZZewi/d7sP6RUo0ZsFehYGrjTVng4+kkJsY/umotjzh6utjDennOCGiC0mxFMTQ747Wc+WQabcOk/4bjvb/Me7Qm79aTh41Zs=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4fa82e9-b60b-43e8-e20e-08d7ece28779
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 08:43:17.8069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OxAeo4kfcYoKlSi4y+3hPT5CNqNi9tJph0dNcnS5m1sFkBccIbs+SwNKkVq4rQ3WANogbBKeDVELKlGVNITrNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1883
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <Brijesh.Singh@amd.com>

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
index dbaf207e560d..ff5287e68e81 100644
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
index 42a2d0d3984a..4a8ee22f4f5b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1254,6 +1254,8 @@ struct kvm_x86_ops {
 
 	bool (*apic_init_signal_blocked)(struct kvm_vcpu *vcpu);
 	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
+	int (*page_enc_status_hc)(struct kvm *kvm, unsigned long gpa,
+				  unsigned long sz, unsigned long mode);
 };
 
 struct kvm_x86_init_ops {
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 1f9181e37ef0..7dc68db70405 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1347,6 +1347,93 @@ static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
@@ -1560,6 +1647,9 @@ void sev_vm_destroy(struct kvm *kvm)
 
 	sev_unbind_asid(kvm, sev->handle);
 	sev_asid_free(sev->asid);
+
+	kvfree(sev->page_enc_bmap);
+	sev->page_enc_bmap = NULL;
 }
 
 int __init sev_hardware_setup(void)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2f379bacbb26..1013ef0f4ce2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4014,6 +4014,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
 
 	.check_nested_events = svm_check_nested_events,
+
+	.page_enc_status_hc = svm_page_enc_status_hc,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index df3474f4fb02..6a562f5928a2 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -65,6 +65,8 @@ struct kvm_sev_info {
 	int fd;			/* SEV device fd */
 	unsigned long pages_locked; /* Number of pages locked */
 	struct list_head regions_list;  /* List of registered regions */
+	unsigned long *page_enc_bmap;
+	unsigned long page_enc_bmap_size;
 };
 
 struct kvm_svm {
@@ -400,6 +402,8 @@ int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 			       bool has_error_code, u32 error_code);
 int svm_check_nested_events(struct kvm_vcpu *vcpu);
 int nested_svm_exit_special(struct vcpu_svm *svm);
+int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
+				  unsigned long npages, unsigned long enc);
 
 /* avic.c */
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c2c6335a998c..7d01d3aa6461 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7838,6 +7838,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.nested_get_evmcs_version = NULL,
 	.need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
 	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
+	.page_enc_status_hc = NULL,
 };
 
 static __init int hardware_setup(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c5835f9cb9ad..5f5ddb5765e2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7605,6 +7605,12 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
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

