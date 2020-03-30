Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7607197467
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 08:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729067AbgC3GWv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 02:22:51 -0400
Received: from mail-dm6nam12on2059.outbound.protection.outlook.com ([40.107.243.59]:6140
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728733AbgC3GWv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 02:22:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A5E3L91dA+HiPCVxsZo3dWj3ruzaRR0g300dexzChwcK2XkGtRExaLRILHDcRAsY0lX/I/GhDCOogsg31UEEr60fbFylKSLI468+o4SFWuyumuO5SjxBpeymZ1yQLgeK5vxEnqf+AuCoKaWUw9NDOx6fwH0A4io7H085PSMPx7Lbl4SnJXz1/ZGJLeJCjdLlQ+BTU7vl5LjHz8dz7jCx+shPi9X85xtKQXO+5u4geZktJh0/RhTY2NsFivjY26sFxLDy2SQ6ns6KWkMoCvYFp4SajxEaRMxvaNFUAFEd9w9Xxba0TferIY5gJRRsjyH1V050aqsP6tEfmEBDzuRthQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mNCIg21NfzBsxz6tXc2n9kRGysg5tKj5UwioRRbI0mY=;
 b=L6TjufBGNOKhon6ypVvufdGRsPjOFveJWacTR6xSSP62ICLz6G++XYuRvgbOcIpAEHDRTAxfcaiNxwHyPBmcuLrlTkdzvpK7Jl1cDvYgp6ZUb7CMTz+hf//gXr6sf/MD7hcg4yuskmR3O3tqcE+NT+F3xZAxcShcsEnwJ8R59VhT9POf66EKBUonSHE4CaTtw9bRtAELY9mlw3RkSvZ5WFrWyunR2PbjhwFVL3ijCdlSvri2Nu3tfT91N9977trTNOzkPfN2M/lBGEBUTGkxRM7tbkrdsftXWllKsMRHHKSvsJNhxwQfUfWn/2cJp+cQx99VViFKRQkwEUoFb5V2Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mNCIg21NfzBsxz6tXc2n9kRGysg5tKj5UwioRRbI0mY=;
 b=IDWh7VNbtxvfs+k2zigXmtplDytyoQjRetR3JIdbY/adsQBLL8iqEQuu/lARJYDL6JZkbCJd1yJLKIEmb3ZxVyDeDADuNneH4NXEAjvPTISMMZCoqtHVmCoUq6tpcWi2GWomNgaRJaTTUTD/5jQ8a0t1Jh/K+RHq+CuwRpkOMVk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1692.namprd12.prod.outlook.com (2603:10b6:4:5::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.18; Mon, 30 Mar 2020 06:22:16 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 06:22:16 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, srutherford@google.com, luto@kernel.org,
        brijesh.singh@amd.com
Subject: [PATCH v6 08/14] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
Date:   Mon, 30 Mar 2020 06:22:07 +0000
Message-Id: <265ef8a0ab75f01bc673cce6ddcf7988c7623943.1585548051.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1585548051.git.ashish.kalra@amd.com>
References: <cover.1585548051.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR13CA0017.namprd13.prod.outlook.com
 (2603:10b6:5:bc::30) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM6PR13CA0017.namprd13.prod.outlook.com (2603:10b6:5:bc::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.12 via Frontend Transport; Mon, 30 Mar 2020 06:22:15 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c6f1f298-c3f5-401e-00da-08d7d472b169
X-MS-TrafficTypeDiagnostic: DM5PR12MB1692:|DM5PR12MB1692:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB16920827B0717E086440891B8ECB0@DM5PR12MB1692.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:323;
X-Forefront-PRVS: 0358535363
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(136003)(366004)(39860400002)(396003)(376002)(66556008)(86362001)(66476007)(478600001)(2616005)(956004)(81166006)(52116002)(8676002)(66574012)(81156014)(6916009)(7696005)(8936002)(5660300002)(6666004)(6486002)(16526019)(186003)(26005)(66946007)(316002)(7416002)(2906002)(4326008)(36756003)(136400200001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XxkMjEP2tjtgmY4aXg7S4U5nOtoqxDISHvPDgf/cA1achusZZ151oFV96fe4ucIrGRtXxnCAZ58PRhIk+5khEd0GQwhT62K883aAk4d3DcqL3M2S/0n/GQOgYXY8YA3fYOuazrWd6+/OCpWeqxEQBxamhq92WhrjEYw8gKFC/BysyrJJGeyylnmBUbaD+35g3IkipKD7mvPefTRQNUsCQgPSl4QkYLEzmMhyKBIkJlcOLTZGCrGcme2In9zTRcBG7xBWnr/Z8Ws4vkz951a8nN20t89dK9lXD8l0PCKgxmG5Yx2J5uVH9JqGP4yefFiKt/PiHhTJihi2fNLbZSw8fDEeDkUw82qEkDjy3gSG7qZtfK2+kADdRWQ5g5ZTsmwwE8CZCgUCcssT2fZqG927xO0Q5azXNIpUGH1GV5oXv7RAUptZVQaYZBjEbphm/r7YqkClI4s1HvBWSI1JwrrUV6Z6cZupQ8G6PZHWZDVAfXtAu40An5bQfR1sN69oGnxz
X-MS-Exchange-AntiSpam-MessageData: o4W1K+zb8SfgH+s67GnMt6qy4qaQyZdlBM7fQ1A2yaueR6qnz1jezfC2iFdmSLunn4s0Db1dmxWeuxs6RdOpmwJ9yhQ0ahXF/gBitZTUsaYo+KAiyHWg/XxxwMNlK3f6wN3L64ZXV2uEIih2YSzAAQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6f1f298-c3f5-401e-00da-08d7d472b169
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2020 06:22:16.5502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8yMdQTzjDq0ar3D9sRgPC8Hzq6/LjK7u4J6oMBDofeP/ShgCO7+7Et+T6qX+DjdQok6zqlmI1TxLkpXWqc65rQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1692
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
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 Documentation/virt/kvm/hypercalls.rst | 15 +++++
 arch/x86/include/asm/kvm_host.h       |  2 +
 arch/x86/kvm/svm.c                    | 95 +++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c                |  1 +
 arch/x86/kvm/x86.c                    |  6 ++
 include/uapi/linux/kvm_para.h         |  1 +
 6 files changed, 120 insertions(+)

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
index 98959e8cd448..90718fa3db47 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1267,6 +1267,8 @@ struct kvm_x86_ops {
 
 	bool (*apic_init_signal_blocked)(struct kvm_vcpu *vcpu);
 	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
+	int (*page_enc_status_hc)(struct kvm *kvm, unsigned long gpa,
+				  unsigned long sz, unsigned long mode);
 };
 
 struct kvm_arch_async_pf {
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 7c2721e18b06..1d8beaf1bceb 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -136,6 +136,8 @@ struct kvm_sev_info {
 	int fd;			/* SEV device fd */
 	unsigned long pages_locked; /* Number of pages locked */
 	struct list_head regions_list;  /* List of registered regions */
+	unsigned long *page_enc_bmap;
+	unsigned long page_enc_bmap_size;
 };
 
 struct kvm_svm {
@@ -1991,6 +1993,9 @@ static void sev_vm_destroy(struct kvm *kvm)
 
 	sev_unbind_asid(kvm, sev->handle);
 	sev_asid_free(sev->asid);
+
+	kvfree(sev->page_enc_bmap);
+	sev->page_enc_bmap = NULL;
 }
 
 static void avic_vm_destroy(struct kvm *kvm)
@@ -7593,6 +7598,94 @@ static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
+	kvm_pfn_t pfn_start, pfn_end;
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
@@ -7995,6 +8088,8 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
 
 	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
+
+	.page_enc_status_hc = svm_page_enc_status_hc,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 079d9fbf278e..f68e76ee7f9c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8001,6 +8001,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.nested_get_evmcs_version = NULL,
 	.need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
 	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
+	.page_enc_status_hc = NULL,
 };
 
 static void vmx_cleanup_l1d_flush(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cf95c36cb4f4..68428eef2dde 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7564,6 +7564,12 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
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

