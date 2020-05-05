Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 367991C62D9
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 23:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729443AbgEEVRg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 17:17:36 -0400
Received: from mail-dm6nam12on2069.outbound.protection.outlook.com ([40.107.243.69]:22337
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729265AbgEEVRf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 17:17:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VVjSIfnipxmUNOqm+WTkByWGOvunEG4mSKB8vg50ccR7gvvEK5WXr2l+oPJdZos8f9Co23RBMHAWohM2xmX7iiy3aA9NOs58fNzCu3XTvhGHQovhkgtEBgx1IvYu3uGmzJbGEyMvGpW3uT1he0YDmmIRTMdPiO2geKo6GVuzO4XMNbZFutaDw+2ts1COwhd1BuF9LpbnZ1XXvPllAjhbuooagjKHdCGO/cd+7QV3fBxGHSiuKgI7kTRzzmeYH08YYvUtjX48IHjyp1w76Mstp4iPG/moxDgEsNkdNRyzZi08r55I3M7GOCEIfV5KqVdGn37xn2VnCnCoXlI80sFcLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MbqCDveUBPc1zlWDRF+76ey8lhRbWeu3iyq7/E93A8s=;
 b=XKegZ7Ia1iYOGQXqi6eRYQnOIC7QYPonuyArjQQY/93ZRvRFWC4jrU30q02LNIwmg5yQRR1+J+e35++Trm6NeTvKwrrRzugOihke2fYIgOa+WbrhOWXWkqY6TDkdKen1LLU3va0446r/P8i+fDYSfZuO34kmUghAIBibDwBds4kncbfMxeFYNlpd+NyjlOjfXZT8CxSb3r8EICoD2lr7fvLGZ/24Ymw1ndtwwMxZlLYl3JGhXH1daOVUDq+a35c02J9B+QwezD+19suHla9F4F42AQmqvut9FchrberNXalmr6vSFZUyFm6vrH2obin8kUapDj3zCTwEwAhMidfJIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MbqCDveUBPc1zlWDRF+76ey8lhRbWeu3iyq7/E93A8s=;
 b=Kd1QauSb0I+6w2uO0td7H9Zd5YXCA76XHHCwfMahuuI/C8RjO3Ytfk/enRYmczSYx5UikRpTlxB2slU1oukdEEsydii1NEYCme7h9mxDf3BR3UFmZeTHvAKUVR0UI//Mzok24YmsoJSAOAkSEwU0sX6qdTbh357VVZPSDsYgWXM=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB2518.namprd12.prod.outlook.com (2603:10b6:4:b0::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.20; Tue, 5 May 2020 21:17:28 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb%3]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 21:17:28 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, Thomas.Lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v8 08/18] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
Date:   Tue,  5 May 2020 21:17:19 +0000
Message-Id: <12a50d857773f74f25555e0985480fb565ec8438.1588711355.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588711355.git.ashish.kalra@amd.com>
References: <cover.1588711355.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM5PR18CA0052.namprd18.prod.outlook.com
 (2603:10b6:3:22::14) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM5PR18CA0052.namprd18.prod.outlook.com (2603:10b6:3:22::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Tue, 5 May 2020 21:17:27 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 95b10c00-2e29-4035-49de-08d7f139b70d
X-MS-TrafficTypeDiagnostic: DM5PR12MB2518:|DM5PR12MB2518:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB2518E6F03081FB42F9A77C228EA70@DM5PR12MB2518.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:323;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lWYODXPbThbfeBGxj0DyEb8bu6tGv9zgSdj/A3gguOLvFfK/M6dTTyi+PzOW8Sh32/6SFFQojXXuywG5GIuTSmwwK0lazOpZVV3h9yzeaQ8+YDl944Ge4lslfgeUaGaOIFMOrYngHa0cPgwUZDEU5dWia0jO3Jc9gyuCQHA3y8lkdJ63XRrfKov0SfbZnpRo1OwMgO2o92f1jThZ4rGgbqZPT2TOADbNJGZiz4mGZ7Zzrp2qBGI6yyKzvKpfG4WbdxwEoE4egpTs9nVcehByxfXkknmbVkASqi9k8iVrz1OwbizsZez5Xa79fIG9KCL/z94tl+NzsHPW/r/x3VVcAsiRYhfNEz3rLWuOfL6zduIokvImbjbbOIS+l6h3EgsEXC9DaexE1jCdIYxCdjmCvw4KdEXY6IVTHHPLA5DI2KePeZx9YFcfRCpdJODR6kEdUP0qjz0C7F4k5LbErYZAe5h0yK77gPQOK4w51xLb/0A4LCbibP8rndKtA9LMPhj852PT2is/L3arg/5fUfUs1TYlGIX8OXs9Iv/0uXNwDmINkg+eAYCnI02rrWWJi0xd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(33430700001)(6916009)(26005)(36756003)(956004)(16526019)(478600001)(6486002)(2906002)(5660300002)(6666004)(2616005)(66574013)(186003)(66476007)(7416002)(52116002)(8936002)(86362001)(7696005)(8676002)(66556008)(66946007)(4326008)(33440700001)(316002)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: W0JGkS/wT/97e/wABpdq/1tfpYYkEmzXDKe3mVsVo7glv8uxHQ5dH7wH5+UPThgvAwlAX94jhvWO8oFR2L+NERPZllZtVxQGHCeFlB7/5e7MiBLeZE4R3HLrght51csm8MDVsyASlMQt6TdhfvtBVov+RTzOaHfD56lQ6nreX5vDblmHGjoKF27eug+n6x/lJr54mduaboMlteqZhikmADRji9lnrCAaIpV15zYrrI/HHpoJ+IDjAUzVo0bb4cc8XCT9/705OQSdHaA7FVAZEvK9PgD2mnDWR3xQdC2SVxLypk4XM84NxcDDLplwr/Bke80ds04db6xn9KtlI8KU8f5CaIzTesqLFJAkiJSJwHB+VQOlF9OG8omZhK5gRlkq9x77XAub6uuKR+zFTmKhi0Kyq4mU7Hci8A1ytpBbzEvFLDgH33KKuv3PnB1r9gq7VnAtgA/00NdSTt7UcZvvTXw9hWYyzI1rqFraxsrp2gSulSmsk+elqRo8N3m7An/sujocneaCduMjsj4k82zQ+2Kl6IMsxHiB/PWS+FYNXkUfNvvkcIYT0Rw+RV2gZsorzoes8VK8dwEySEKiFOUqD9rYTkV874Q+TUOsHRlvZcEs7BNXXGW4Ub581qLMEwb1W+h0jopLXcW7LDFBW4wNaWQp2bkKXAHMJrrtN2aCGxtpYjBE6436Zul2oEuuINH2s/IrFPds4gSCzNrUugD8VIlxTUih6KE/mfDLVsURLXEcjYKxD50QswMJsnAO09vqXnzxVeQq41+3C3QX7ipZdKrPh6R1jXRchFUAqGG6QnI=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95b10c00-2e29-4035-49de-08d7f139b70d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 21:17:28.5054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l0YOyp6HqEQWkrfxNeR62HM/V9VoUrct8cQecyBiNwL+8IsKHnz1OxPc05POxNE6HSWM/v0DG6b0PbcW0udxYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2518
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
index 698704defbcd..f088467708f0 100644
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

