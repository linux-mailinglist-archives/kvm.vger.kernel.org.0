Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95B642D35E1
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 23:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731135AbgLHWHJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 17:07:09 -0500
Received: from mail-mw2nam12on2074.outbound.protection.outlook.com ([40.107.244.74]:34912
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729512AbgLHWHG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 17:07:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m7ukVRJwdT+Vo++KH3tzAt4MFHipzfVFfBar2qNz7HKp9oJKqRj8gB3ae/6lYmLxdfcGvgaXFOBYE3E+mATjeGTYbhO7ktI22xCeTo1velbfpOIBkUMjHPDZbJKK3lfnkVhKWQQubDRmJe8B6l6T8nDFVCEgbra+T+3tI1XoDqUBZPFrlfvqXsWTynHMiD8vU1ethY5bUdHrNut+otLXvOrP7uCO8HGm+NkrJzw/dk4JKuEefXbBwkXlb/JiAnfMU9vebU+BPJCbyEShjwJvmfK0DE6NYjuGwpBj0dokyqng3xf7ddR2tav335oZAdWJSzvkRMjMI/QebG/dPCnGRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y/5wfYm2q3Xhned3b/mnMFzFkfmUAFtT0lW+lT+hCCY=;
 b=hYraxTESypBOIPPF1HelRwcJ+3a+7SdjNHvUR2XuvFcb2TugnxnA8YML131p0MHLrP7zT4gvCpZfHezwRosWn9LZpU7VIb+A32mSM1R4wQ+b4cOhwYAmRVPqYkZyRt/g+gLtYW2hgNastyL61n5qQpz8F3BEkuJsMaII8tgK6qnd4x9KMPPeCqUYTqv4VdLzNjvy9A63uH7IdEEp0OEF5oogT6AmEWWzWJ+53EWHpwNkd5QD8jOCghxjK//Hh6pTGTUQV6BqVYfBc3o5CPzlLS/yGDA9aMaoFz3tRfwC2OF0zys0QA0X6TS9tE6I0qLvtgfjtX4MbxXllZvRHLukBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y/5wfYm2q3Xhned3b/mnMFzFkfmUAFtT0lW+lT+hCCY=;
 b=ECQf4jycjSLXsr4bUmccof2VRP2KDraMIAt1UlcItve/VBV2N4TDnpxv6UzH6XO8yOEsFVry79+mpxK9SGFAvrzySICxltk113A0N/V/5L/UTRouAHl6XOJ8bj+cfkBpHNRYduMYQeIgYkOPDUrrg2hUJlYAtTnFe7o5xbqLyfI=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4415.namprd12.prod.outlook.com (2603:10b6:806:70::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.23; Tue, 8 Dec
 2020 22:06:29 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 22:06:29 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v9 08/18] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
Date:   Tue,  8 Dec 2020 22:06:14 +0000
Message-Id: <5506c55bbf19794c7815c9c4d2a9867158b275eb.1607460588.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1607460588.git.ashish.kalra@amd.com>
References: <cover.1607460588.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR05CA0025.namprd05.prod.outlook.com (2603:10b6:610::38)
 To SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by CH2PR05CA0025.namprd05.prod.outlook.com (2603:10b6:610::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.5 via Frontend Transport; Tue, 8 Dec 2020 22:06:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: db097197-06b3-424d-7265-08d89bc583b8
X-MS-TrafficTypeDiagnostic: SA0PR12MB4415:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4415546625B244C424E6FCF48ECD0@SA0PR12MB4415.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:324;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qKzSYbbcvu0aKzmNr37MLlCboumo3ruhH45JYUM0+QNvBEEHFOhgMqOohWwhh/Y9U0DRyCDe0Rtcl4B3S5/9PVfoYTZ/IYEkc1cLYfjH/LSF9gBZHIp4EKpVMNrXH6CF0oa53JMX9nC1i/b0sSoofIqCN1Lj6olX7IT/FVYOyiGUOVjlMgVgO+M1gVrb9y+mdcPsgcCpkGDa8IKl3LERlDF7vTQgXH5NFEkP2qf4/CD/BPn2idGIqKv0AU7gJsnCT7WlvMsz9i7/6sEz8DVAiLxZHM8ZhZLAWjZeS9c1Y6+SlY+sHTe/9Jq3p2QMLemVOXXIuDZen9UVrxK0ra8uXRZ2nFXMM9MrTT5VBwiJXBtwZ8svUt34s+Z9tYHy0hci
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(366004)(34490700003)(83380400001)(186003)(4326008)(86362001)(6916009)(7416002)(16526019)(6486002)(5660300002)(66556008)(8676002)(8936002)(508600001)(7696005)(52116002)(66574015)(66946007)(956004)(36756003)(2906002)(6666004)(26005)(66476007)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bEJtV3BuOU91cXdGZXNIV1UzMTJrQzhrTWY1VWxBTkovZzVHRmNISlFzbUYz?=
 =?utf-8?B?NGYvRVM1ZEhkcHplaVNRNm1DUytNbWQ5NzFMUXIzRllEcmJrZWx3b1cydUEx?=
 =?utf-8?B?T3ZjWnRqQ0Z3NmhPODNMKy9xY1ZnbkU0ZWxVeFd2N1R0YzNvZUswUGlNMDBU?=
 =?utf-8?B?K01WS0xBY0w3N0pPK0YvRlFOK1k5VmkzQ2d3M3ZiVTJJSUoyMGgxOS9OTWVP?=
 =?utf-8?B?SldIclJQOXAwdUo4SmZVcDR1Uml3YXFDQVh1anFGRkRLbEtZYjZjc1A5dTlE?=
 =?utf-8?B?M0RnYUpGcW9NQjZvdDFMSlI3OHVYWWpsaVhzSmYza21GSkNpKyt1dUZjT3Fw?=
 =?utf-8?B?cVJrMzBieFBzYmtaY0Z0NzYvM2kwWEFKWWtIMzBpUWlwdEU0RUN3MCtPRjFh?=
 =?utf-8?B?bkluY3lSUHZiWktaa1BCVEVzZ0FnVm1HYkRGUERXdzlSV0tFQi94dDhvY2dl?=
 =?utf-8?B?bHRvSTNCOGxsTlBWak1BU2tkK3FWVkN3ZG9RVU5LU1dtUGhqczYvY3BxQlp0?=
 =?utf-8?B?QU5sbXJLSms0L1hBMGFEQzlobTllLyt5ckZyTVdtNEY5dHowSk9BOU9EbGw2?=
 =?utf-8?B?RjZNZUhGeGZIekxQYWQzQmR5RTVndjRJRkVpQ0c5VGw3ZFhtb2thZUNzM0FY?=
 =?utf-8?B?QUFtWlRNYnI2dy9TbllYaXU5Q21mby9uUWFXOWI4Q0IwSDZ6R2R0c3hYZlJn?=
 =?utf-8?B?VnI5emsvbTBzNkFqU1JQSWx6SzZiNU9lUEY5V0pCUUFZVlk1Q05xdnhNam54?=
 =?utf-8?B?QUtXaG8vcS9pZG5zS1I0ZzVGSi9ZZ3ErcEJHTXZjQ2t0NFNvY2FOMjdTa0E5?=
 =?utf-8?B?STEwZW9hbHZlMHNkRk1NNUVxQXZISXZmbHZjZ0FsT1Fub3FtaVhST1BCZDFJ?=
 =?utf-8?B?a3V3emFnOGtOK3ByV1FyRFgzTStJRUowN1JYbVIwMGpIbFpISnBZMWhRNkt0?=
 =?utf-8?B?bitmcG10Zk95Y3ZPYVpHVC8yYTMwSENSYjUwWkpUeUgyaTdaZ2lreGFRL0ZO?=
 =?utf-8?B?OE1oc2JmZTZ4ajVySFN4Vk5uRkxHNWhiZzQ0ZzJZMWZJem81SmtFelZUK0tN?=
 =?utf-8?B?V3prVFY3UDNmVlBRczRKeXlFU0ZkYUw1VXkycTlZcE1qbmIrMk1MWEVxeE44?=
 =?utf-8?B?bnJRN29sRjNyZUZsZmVJZXQyUTJXWEpVSTRkWjlSSU1NbUFLMVNwQzFyZUZi?=
 =?utf-8?B?eWU3S1FibEZ5MFNjQW52a1BuNlhEZUEwNUhsNnlRNmxIQmtSekpiaWU3cWxQ?=
 =?utf-8?B?NWN3ZUF0ZFJUNXl4cmo3blEzUGZ3WEZyR0lXL3h4K1RhcDdVeWFlV1lzSjlr?=
 =?utf-8?Q?CSN/5NQD6B7a3MztF6ugxFi/BhD/XJxhfq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 22:06:29.2551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: db097197-06b3-424d-7265-08d89bc583b8
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NnTYh0eOfWHqC4biQXtO+7bOOf3XA47XVT14mtliTDq8EF6mYaqE4VlbhR61e8COuSdD44VYlYFvQgCXftWw2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4415
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
index edd98a8de2f8..134d7f330fed 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1361,6 +1361,93 @@ static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
@@ -1575,6 +1662,9 @@ void sev_vm_destroy(struct kvm *kvm)
 
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
index c3441e7e5a87..f0a00e69f892 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7719,6 +7719,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.can_emulate_instruction = vmx_can_emulate_instruction,
 	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
 	.migrate_timers = vmx_migrate_timers,
+	.page_enc_status_hc = NULL,
 
 	.msr_filter_changed = vmx_msr_filter_changed,
 	.cpu_dirty_log_size = vmx_cpu_dirty_log_size,
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

