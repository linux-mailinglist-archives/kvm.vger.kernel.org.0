Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3873542C8
	for <lists+kvm@lfdr.de>; Mon,  5 Apr 2021 16:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241337AbhDEO2x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 10:28:53 -0400
Received: from mail-mw2nam08on2086.outbound.protection.outlook.com ([40.107.101.86]:12288
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235915AbhDEO2v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Apr 2021 10:28:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Se7f0NRbgrxG4kYIUxyiryKgf+6mFV4YuOREuG/GFDD0/KHPJecehIT1lGQOn0bjWBp455eID7oFe4D41Cdgs74ZTWAwmRdmC1NQNmSVqv83KSsKy5QooTVN6e980ey5Mmn/cbICnpadG8pfy/Ln34ycYGe+7yRU+uIRmIowAYATttbuGlIPFSLk9gyiwZ/xADEpXNoeXd6y0GpxqssWRHTNkjq80fsBaFK6M/LMAuMctU+Xz4nLgEJCXmAW5gjDE+mrBbnWM6/MEXxQeVyu9AZ9IJa52enRBIUeQt8m42K12lIVq8/2mSYspbAfkT88+YC1p0xN3GiJam+AkccHOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U3QtukQKZIJ+olgbztN942htCrg0VvOeCKPt9wchrDY=;
 b=APiNF2TQ8HwcfGjvjQQO5M4Rj4lNqLcJIqpqY0xD8POEZMu98FCQXdabebiEu3Fm7gWQ+llczQtHgAIyOCtAmiPb2UxMT4yR73qDzM4B8+qqFrlwcyZEZ8fl+Nt4hSJn0aVHthraTOrC/No+EaTL2YxkYMI+zhi/v4sviUNbGcNVLdcsY5vRcSpu9p8joL3kvrDhIuTl11X1GZxDgkAkK+FVGre5rDVf4I3B9dXLajnronjyb6opyVCXdcRw0aEtDgYRtJ4RdeYdkNQ7ysUWi0SbdVZZKArKQhGxmdf4Bi45027fX+69/jL1BMYzgCJrxD2W45L9IzuA8/9XZ6wx3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U3QtukQKZIJ+olgbztN942htCrg0VvOeCKPt9wchrDY=;
 b=WUf2J7khi8PTjgKj+GrluEEBtEOojTTakRmJBkDEiTeuqb+X+74XpKPPCjqA63RetlmBf26L8d+OlVwftABKnWX+e4rsshWwV1srSOIAuAPOdYqNr1TiudUpfvFSA3THVYNCpVJnoOUbobXPkS8jj3rAhElsSK8TLEDJ3UKlzUc=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4413.namprd12.prod.outlook.com (2603:10b6:806:9e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Mon, 5 Apr
 2021 14:28:42 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3999.032; Mon, 5 Apr 2021
 14:28:42 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com, will@kernel.org,
        maz@kernel.org, qperret@google.com
Subject: [PATCH v11 08/13] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
Date:   Mon,  5 Apr 2021 14:28:32 +0000
Message-Id: <4da0d40c309a21ba3952d06f346b6411930729c9.1617302792.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1617302792.git.ashish.kalra@amd.com>
References: <cover.1617302792.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0201CA0072.namprd02.prod.outlook.com
 (2603:10b6:803:20::34) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0201CA0072.namprd02.prod.outlook.com (2603:10b6:803:20::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Mon, 5 Apr 2021 14:28:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d08e309b-5e11-4424-7dc4-08d8f83f1ce9
X-MS-TrafficTypeDiagnostic: SA0PR12MB4413:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4413313B95A751CA7A1960118E779@SA0PR12MB4413.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QzqUIw4QWYumX+dsMCF75E49ceXAHUnQVCtEjEquL+ZDgxnQsARKy/kyW1aIO2bOfxTXuoABz+ZMr6lbcc3DvBpwjqVcjmTkIS8ncSRYMLGNuzyuvWc+f1p/48lJXzX4WACYK5WeIOvMldOlVOSC1oIH7msicnyMc7ibmB5MLWTFblHlHt+qpcMpqfKY85v+pLNq5a9xQnWzqDaOUZQOwmbrF45kjY/KuAgM+kwYMUL7w00oZURZ9ds2zEj/by9mjikwC1aHkOQ7HtgHDJooKbHji+qR/lvrxCBSIVuDz/qpG+z/q6IXq0FW+VZys0bnjDeYzGZZ4Vuv4S007HTmy6gsXND1hd31KWMhemvwb5jBH+rYK1PikjbSCOz7594kT9bWyiZkt/t3xSj8uOiQ5OzCA/Mn1jvNrcucpGaBqL7LoSJerNJc+6ppaaoa//4rX3r1V944EVMl1p4UW9jR+en/YJHneD+Kw93NQSEYf6Zqy3JFAzd62/J7HFbvcrhqS4sqTUGdsFCuHXlJos+oj6/l3o4c/Y5cZjXZhHJzSdbHeuHijNMl+qU7p+RcHo3NVbw5IbWKicbz8nH+9MGVQ4cnxh5gMtLrtKGIdo/WlrAo0NqbpkzJ8UAcjijtj2/dTfLVuPqgvSDGwTEKAVj5ZHNfaenwhiMYDqkA/T6R0AA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(366004)(346002)(396003)(38100700001)(7416002)(26005)(316002)(8936002)(83380400001)(16526019)(956004)(52116002)(7696005)(66946007)(6666004)(6486002)(36756003)(478600001)(8676002)(86362001)(66476007)(2616005)(2906002)(4326008)(6916009)(186003)(66556008)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SlpwNVZEUzNidVBya2JIWjhBa0pYTTlpTlRHRzgvaWxvZlRINTFiSXJpV3dL?=
 =?utf-8?B?aVhzaEJDWFlyaGZaa0tiTW95d0FXSHV3SG5PZ3JwNzhkYnlTVVQzWmxDUHJs?=
 =?utf-8?B?em5paUNNZ1dXcFlxNnVQckM5OUdsOWRHV3BjcnZQNnJ2djVZTUtSL3lWdmFX?=
 =?utf-8?B?YnNrQ3dwVmp5eW8xU09yclV6Vm8zdHhSNU1jeW1OZHU5b3NJUDZobFNXazVw?=
 =?utf-8?B?VmpnZVcyNFQyR1d4bGNWSzNFSUh6QVp6aEtuTWtVQUR3d3JucFJWdzRKUm9y?=
 =?utf-8?B?V2hVWTRxK01rZDV2cEFxdkNIK3hkdzdSbzdEdzNpdFNyWjhSbzcwT2xiNWN0?=
 =?utf-8?B?TTRWZElsaFhvMlNFSzRGcFk2VUh0UEpHVlhZVGRudjJ6aG1OWlhGMnRWckFU?=
 =?utf-8?B?UUw3aUdrV21RSlR4dCtiajcrODFVMjN3ckxubmVCNTZ4KzVxakV0dFRLb2lP?=
 =?utf-8?B?R09qRjBnZHkrbGlmNVB4elZmM0VOOUFIcHRVc0xSOGZrQTRhNmRMY1ZZZ1JQ?=
 =?utf-8?B?R0p5TDJydlNiNkJkU20wQjlqcEZSSkVydVgrenpyaXFUYzNhMDFwd3I5MGFP?=
 =?utf-8?B?NE0wcmpvS1l2RnBzZkxHUzZBa0RKUGxaZmFHNDR6YjdGOEo0Y29rK1pLSm5C?=
 =?utf-8?B?Y0dvZmNydW1hK0pIa1JqSVJZQlB5VXk1cjZ6ZUtmNHVvZEVLeGV0cWR4L3Zt?=
 =?utf-8?B?SDRWam54RURBdVNvTEFOdEtvd2V4RWZqWXdENTRsNmhpUVdMWENNUkE4czNy?=
 =?utf-8?B?ZG56eWppNGJONmQxcmtscC82Mko0VEJFS2gxQjBFTWZrZU12WFVmYmlUUDJD?=
 =?utf-8?B?TVp0T2doMmxlTnh3aU1hNFd1VkxpWmNuam4yZ3hlWDVzeWpXb2d2amxBL2NS?=
 =?utf-8?B?aEhNL0FNSENlUzVCQnI3L2NId2dtMFdweS84bGlPSERCd2RQazNYeldUbzNh?=
 =?utf-8?B?akFVclQzcXBoNkRXTVd2RnNPcE1WTVZTZWlmanZBNzY1K3pjWHUrdm9Jdkcx?=
 =?utf-8?B?dldYR1l1eFMrMUhmVTREdmZROU90TUdGREZ5dkdadi9ac2VIRzJXQk5aWllt?=
 =?utf-8?B?MGl6OEp0RTQyRW80SmloSXluTnZwSnU2YlhZQmpvaS9GVUNITmNGZ2ZnV1ZF?=
 =?utf-8?B?WWlNRU13Y1ljSVZoZkdkUUxiYWdhTTRQOXpPVmp4YVU4dlpzd2VvZmhqM0sz?=
 =?utf-8?B?amdJMGtqcm9ic1NXZmRsYlg5UE5RNTZ6aDZNcFNjWmJuOXdzenZRYkd0dkxj?=
 =?utf-8?B?NUJCZitZTFI3ZW0rbkppVldpalVmTHliZGRsWUU5KzdhYWVWVFU5eFpGMm8w?=
 =?utf-8?B?VkdZbUhENlN5QndjZzBLeG80cGZmTUszZEsxSGQxU0pVWStHNEVoaU54bXFm?=
 =?utf-8?B?MVFYZUhxNTkxUFlpS0Rsei9udVM5Z05VN25QcmFHMWFFVGJhVlE3WitIT1hS?=
 =?utf-8?B?ZUZaQytSZVI3KzBNTUErTitJVk1qMWpnWVdOMitSSjRZbVYwNnZvbkRhUUIy?=
 =?utf-8?B?d096ZUQ2T1hmeUdDWmhoU1hIVDNLdTZ1OTB5WFFqYWZFQnhrOWd4V3p3N3k0?=
 =?utf-8?B?UUkxcFFNRkxrY0xFMWxKNXhlMzNoZGp3MGVVY1UrdTZ5R1VpVGIxb3NoSW1J?=
 =?utf-8?B?Y1lWZGI4cUdwRytXa1JtbFJYUjU0aTNOSmpDSHhTUERBSUhVSEhsenB2ZU1p?=
 =?utf-8?B?UCtvelJUemVuaWlUaVF3M0pHcjlGY0Q4cTRRc1VKVTdvUHpVR2drOUk2VWkx?=
 =?utf-8?Q?DkejsP4UcZh0Byctw9Fcvi4GRaYiGroKJlCM8wq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d08e309b-5e11-4424-7dc4-08d8f83f1ce9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2021 14:28:42.6186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p7fXAVPkJWAvt8gICbuh2l5n0DWFH7od+3qEmJIBkdBuNBwaj3uZ27aE8VsUTQ/U7wzc4/vTxGOIqzdEW1nngw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4413
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

This hypercall is used by the SEV guest to notify a change in the page
encryption status to the hypervisor. The hypercall should be invoked
only when the encryption attribute is changed from encrypted -> decrypted
and vice versa. By default all guest pages are considered encrypted.

The hypercall exits to userspace to manage the guest shared regions and
integrate with the userspace VMM's migration code.

The patch integrates and extends DMA_SHARE/UNSHARE hypercall to
userspace exit functionality (arm64-specific) patch from Marc Zyngier,
to avoid arch-specific stuff and have a common interface
from the guest back to the VMM and sharing of the host handling of the
hypercall to support use case for a guest to share memory with a host.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 Documentation/virt/kvm/api.rst        | 18 ++++++++
 Documentation/virt/kvm/hypercalls.rst | 15 +++++++
 arch/x86/include/asm/kvm_host.h       |  2 +
 arch/x86/kvm/svm/sev.c                | 61 +++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c                |  2 +
 arch/x86/kvm/svm/svm.h                |  2 +
 arch/x86/kvm/vmx/vmx.c                |  1 +
 arch/x86/kvm/x86.c                    | 12 ++++++
 include/uapi/linux/kvm.h              |  8 ++++
 include/uapi/linux/kvm_para.h         |  1 +
 10 files changed, 122 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 307f2fcf1b02..52bd7e475fd6 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5475,6 +5475,24 @@ Valid values for 'type' are:
     Userspace is expected to place the hypercall result into the appropriate
     field before invoking KVM_RUN again.
 
+::
+
+		/* KVM_EXIT_DMA_SHARE / KVM_EXIT_DMA_UNSHARE */
+		struct {
+			__u64 addr;
+			__u64 len;
+			__u64 ret;
+		} dma_sharing;
+
+This defines a common interface from the guest back to the KVM to support
+use case for a guest to share memory with a host.
+
+The addr and len fields define the starting address and length of the
+shared memory region.
+
+Userspace is expected to place the hypercall result into the "ret" field
+before invoking KVM_RUN again.
+
 ::
 
 		/* Fix the size of the union. */
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
index 3768819693e5..78284ebbbee7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1352,6 +1352,8 @@ struct kvm_x86_ops {
 	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
 
 	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
+	int (*page_enc_status_hc)(struct kvm_vcpu *vcpu, unsigned long gpa,
+				  unsigned long sz, unsigned long mode);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c9795a22e502..fb3a315e5827 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1544,6 +1544,67 @@ static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static int sev_complete_userspace_page_enc_status_hc(struct kvm_vcpu *vcpu)
+{
+	vcpu->run->exit_reason = 0;
+	kvm_rax_write(vcpu, vcpu->run->dma_sharing.ret);
+	++vcpu->stat.hypercalls;
+	return kvm_skip_emulated_instruction(vcpu);
+}
+
+int svm_page_enc_status_hc(struct kvm_vcpu *vcpu, unsigned long gpa,
+			   unsigned long npages, unsigned long enc)
+{
+	kvm_pfn_t pfn_start, pfn_end;
+	struct kvm *kvm = vcpu->kvm;
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
+		 * to the shared pages list.
+		 */
+		return -EINVAL;
+	}
+
+	if (is_error_noslot_pfn(pfn_end) && !is_noslot_pfn(pfn_end)) {
+		/*
+		 * Allow guest MMIO range(s) to be added
+		 * to the shared pages list.
+		 */
+		return -EINVAL;
+	}
+
+	if (enc)
+		vcpu->run->exit_reason = KVM_EXIT_DMA_UNSHARE;
+	else
+		vcpu->run->exit_reason = KVM_EXIT_DMA_SHARE;
+
+	vcpu->run->dma_sharing.addr = gfn_start;
+	vcpu->run->dma_sharing.len = npages * PAGE_SIZE;
+	vcpu->arch.complete_userspace_io =
+		sev_complete_userspace_page_enc_status_hc;
+
+	return 0;
+}
+
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 58a45bb139f8..3cbf000beff1 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4620,6 +4620,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.complete_emulated_msr = svm_complete_emulated_msr,
 
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
+
+	.page_enc_status_hc = svm_page_enc_status_hc,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 39e071fdab0c..9cc16d2c0b8f 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -451,6 +451,8 @@ int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 			       bool has_error_code, u32 error_code);
 int nested_svm_exit_special(struct vcpu_svm *svm);
 void sync_nested_vmcb_control(struct vcpu_svm *svm);
+int svm_page_enc_status_hc(struct kvm_vcpu *vcpu, unsigned long gpa,
+			   unsigned long npages, unsigned long enc);
 
 extern struct kvm_x86_nested_ops svm_nested_ops;
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 32cf8287d4a7..2c98a5ed554b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7748,6 +7748,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.can_emulate_instruction = vmx_can_emulate_instruction,
 	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
 	.migrate_timers = vmx_migrate_timers,
+	.page_enc_status_hc = NULL,
 
 	.msr_filter_changed = vmx_msr_filter_changed,
 	.complete_emulated_msr = kvm_complete_insn_gp,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f7d12fca397b..ef5c77d59651 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8273,6 +8273,18 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		kvm_sched_yield(vcpu->kvm, a0);
 		ret = 0;
 		break;
+	case KVM_HC_PAGE_ENC_STATUS: {
+		int r;
+
+		ret = -KVM_ENOSYS;
+		if (kvm_x86_ops.page_enc_status_hc) {
+			r = kvm_x86_ops.page_enc_status_hc(vcpu, a0, a1, a2);
+			if (r >= 0)
+				return r;
+			ret = r;
+		}
+		break;
+	}
 	default:
 		ret = -KVM_ENOSYS;
 		break;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 3a656d43fc6c..4174925aa5fc 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -268,6 +268,8 @@ struct kvm_xen_exit {
 #define KVM_EXIT_AP_RESET_HOLD    32
 #define KVM_EXIT_X86_BUS_LOCK     33
 #define KVM_EXIT_XEN              34
+#define KVM_EXIT_DMA_SHARE        35
+#define KVM_EXIT_DMA_UNSHARE      36
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -446,6 +448,12 @@ struct kvm_run {
 		} msr;
 		/* KVM_EXIT_XEN */
 		struct kvm_xen_exit xen;
+		/* KVM_EXIT_DMA_SHARE / KVM_EXIT_DMA_UNSHARE */
+		struct {
+			__u64 addr;
+			__u64 len;
+			__u64 ret;
+		} dma_sharing;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
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

