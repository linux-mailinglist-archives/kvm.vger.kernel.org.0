Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E576736FAA9
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232894AbhD3Mme (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:42:34 -0400
Received: from mail-bn8nam12on2044.outbound.protection.outlook.com ([40.107.237.44]:33505
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232813AbhD3MlV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:41:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a198KZhO3nitFWinbFE4b+qH8U3Ny5uy1ACmGz77W8vHvdr0P81QF0YK3RBE6fZZhD4TA969dlbBr+bM6f8X1bZyUU8VStvOlYn0KV2ao5DjfXkLcb0s/0K3OrLlv002/FLHfWFTLcUEcVBEe7tPDds9xSyNbxVwvgav0qF3fLzSJKMBalQC53Y0hKr8+srPMpIVJUILCQK4Tcbq32W/tE/UtNjW29hvKZ5MEr0x5yL2JJC7AQVu03NnWOiEkb0FHRM5xMI340+GR76VkTAY0DVANo7oOkJQeZ3f5Bro8+GUiPSfq20BRvXWute2a42joKl2zPeXi8ePI57DqspbyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Ifh8ZX/B/CMwX7nWhsjmsJ9swM7UDJIRvcVNjt3ou4=;
 b=lfH4q0a2MTDui13w+2fVjutgrwAO4eo/J5yuqXE3Ecn0jWhzHKnBVpetNOEFwKrAkf39PauSiWOmqtho56P3tKnLfIi7uEtrknfA//oVY4Iu2RvX9PmaJ2OOt0FRX2CBjpDI3icISfyf0W1OS5YvKjr7saZynZZWJaaeOiuGgqT8ej29z5RKJpdD5evmrw5mQjwiEghX6qnL8Y53UqKai9rtlEZAnTvk/nSOSXIiXpr1IpIBTlbQAEPx16FkcrV2W+2sVULOkBFsxO8A27GCDGE3FK07NS95ZRYcLnfpXdJ5f5dxhtM9s98Tw+/sKA/c82FGDSSK9cmPI3O1Rxzqag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Ifh8ZX/B/CMwX7nWhsjmsJ9swM7UDJIRvcVNjt3ou4=;
 b=eEYC1nbsbAmga7wlX/U6XSdjtYHFClFkQhBaH9DHnqa//kTwjoV5Qj7bZCMX1DDdhLfvopLxoIjKjs1QvDEH/rCE4PqvISJWzeET3UolczbUJFGJ1UL63U4Pl+M5cP18178vzqCZwip+g+7nNPhsU7srIZYb2lu0DqJGIerREdQ=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2832.namprd12.prod.outlook.com (2603:10b6:805:eb::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Fri, 30 Apr
 2021 12:39:07 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:39:07 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v2 18/37] KVM: SVM: make AVIC backing, VMSA and VMCB memory allocation SNP safe
Date:   Fri, 30 Apr 2021 07:38:03 -0500
Message-Id: <20210430123822.13825-19-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210430123822.13825-1-brijesh.singh@amd.com>
References: <20210430123822.13825-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0089.namprd05.prod.outlook.com
 (2603:10b6:803:22::27) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0501CA0089.namprd05.prod.outlook.com (2603:10b6:803:22::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 12:39:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22f2ca94-b83a-4ee7-27ea-08d90bd4f1e3
X-MS-TrafficTypeDiagnostic: SN6PR12MB2832:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2832047ADF8EFDCB8568016BE55E9@SN6PR12MB2832.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DhQLuYsGVYKWmRkdLg/PI/u3zlZYVyIInkpSpkmXxkTrmGLddrRUgRi9tjZ1Kdg532DSLgXT50fwwXZ4meI6LkspWbWJ1P5j/asE/hbADfDJvpMovwkBO3d1AqPzvbE1GMTyTcPJnflKuwvi0k149GnJAc4MBIHmb8vpZocck+Dl4HQ+ZBrbiYJZw+WQHTmM5QAxpnivsRMVcl7OoBlewzx0zJmhyk11v7GC+8WacGahBZ0nN52Pl2bTPKMEzYHheIBEBO+WQwu97uaCJ4A/C92Ib/qJgrAbvPc/eZIiscNBqsATi5d1L0H5hs2jM+CU2lD79DcLyDganIXWhxyDGXEAX33xKHmb679BC+Vu+IbW8VNLG3b3uLsJXRSHceY5I8F7fBASbV+eUogeG9c1eE+Q1wTVPNhI8tsAynWrSuurO6RLdvMTyJOQjc7yD+TrOeEp4mr+37REn+fjKqhCR0rSo3v2jYzM1bdxMQaSuZiYfKXRzUR/IrZ8mcbCWVde6qn2ujtcAxpx1D1exEVenHYNWutRvxsUYJYrTNBV4kamePlkVIB6MzBbK+cd+sn2eYJjODV2mgdBb5V4fCZpF05mBUUS2cv6Z5wS/+CN3sX+CgB1POzM2D6CzM0wfkEvpaFgHUzyrx509O76D5kT6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(136003)(376002)(346002)(66556008)(956004)(7696005)(66476007)(6666004)(2906002)(7416002)(66946007)(1076003)(52116002)(38100700002)(186003)(16526019)(4326008)(2616005)(6486002)(5660300002)(44832011)(8676002)(26005)(316002)(8936002)(36756003)(478600001)(83380400001)(86362001)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Sxqr0lsepIZH1a53CZhnMOMrIOaEXCWeaNvaFkSENw0X/lZZAYy6Vb6tRClV?=
 =?us-ascii?Q?82ajWQdCQQPsY6cXPGqeG+CHtsSq6K5Aqowt6RKSGJeoKspXVpb+tkNWZ+xF?=
 =?us-ascii?Q?pOXJWIqwIo8qiDSHX5/eyYk3wzqUUCfeozIYHzQGRVDbeRKsgrWpwgKX8dFR?=
 =?us-ascii?Q?VSg9X3yLu4bmQkH1AowhTrwFQy3RdMVeg2U6dX0GKk9jXBHNxk64MK5e0UHH?=
 =?us-ascii?Q?Yzn6ePBLMToQKSHlZnCtOMvcwQ8B7/6prVh3gxsTsoiWq5IeeNy7oOoTtIBE?=
 =?us-ascii?Q?LIpKcLx5UR08c8qOVYcBv0cEOIzI7SRamgnZuKFYO49DBonxwPslx4Mc2QBR?=
 =?us-ascii?Q?06SNrzCt7yXmwtPLEK5mqjLW5vLTkuZCe3uXagiiL47NV6iaeYZpxanHjghQ?=
 =?us-ascii?Q?WmViKbMSxuxzw5JGj49nYfZjX4GAf3NikZdkOrQ9AI5RTVllZd9YmhRgUYOP?=
 =?us-ascii?Q?Ou6Q2oEEdqMj2OI9e7CbFz/staxv9oHsv+wEqvqnC1bZa9UaKWOGB9B/UN/7?=
 =?us-ascii?Q?PELXNXxX8wFJpW67fxSBjluq5cFibUkgOvi1SvB7O8MmViEiBNxW72at75Uq?=
 =?us-ascii?Q?mYYpO+rX2e+mJRVz5XvS0YkAa2OM+6lfZ2WTvN0uFh8iIPUY+78FkTGcqf4i?=
 =?us-ascii?Q?vN6PRAUCzUE0MR4j0p2OWelAexEj7n0RCeVu80QiFdVuPHOgA2GnJDR9SrKl?=
 =?us-ascii?Q?eqsf6fx6Vk1d9xukoeUpcTF+5Uiwy5OmQwoDxoKv04VifsWAqFO9BJywJBS0?=
 =?us-ascii?Q?7zsl5t3bGMHpHzy7BDn2ACulqI5I0gkeg2yYjKUoHIrBBD82SmNftT47OWkx?=
 =?us-ascii?Q?ZbwF3xqGkv07qp1NWTuBOClBKdT6bChEOHQbdkfnvQk2zY3RzgU7g+9Nil8a?=
 =?us-ascii?Q?nPF0khm9uhKIY8Lw7q+3p3zPUEbD8zL4wTBPiasV318J3arj0dY0p98y5iw/?=
 =?us-ascii?Q?W281LqYIV7Z9NdYn1n1K9sDRz7oK4HqA127dUnQdIo1kOsUNBEhSgzJv/vCm?=
 =?us-ascii?Q?PGvcvnrCXwy1RGyADiv94DIYjDW+8mP39SnNV9WCk4GR84nyUUZI5PlTrCj2?=
 =?us-ascii?Q?Ik9ye/fdn7DlzUSD42gfhzuubBatEnVN7TrS8gnTw9c+05XyM3DLKpPPO14K?=
 =?us-ascii?Q?uNRc719Az+WzWLPzgy509rcdmLaF6pF91QiScheFx+dA13jubyemH4Ch9dlj?=
 =?us-ascii?Q?bGnu9Id3w5nUTbaald8ivFyu3tQ2VV7rlHmBDnRxkCtY3CmM/v9yGdY0UO8p?=
 =?us-ascii?Q?L2cNbRpCCImKYBikAAHMPtsAznyPAg3wA50E8K/wM3/G8plVGC+e7NO8Igv9?=
 =?us-ascii?Q?E1+NhG4af3tV7MELUqSwpvx0?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22f2ca94-b83a-4ee7-27ea-08d90bd4f1e3
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:39:07.0722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Od5QoALLHSygoy7ID93fwTjvcFLrBmbQjuQq84TuamcojcFAOTxWqyk/UnQxZjlEBtLkGx1zlOjNOH4akuXoLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2832
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When SEV-SNP is globally enabled on a system, the VMRUN instruction
performs additional security checks on AVIC backing, VMSA, and VMCB page.
On a successful VMRUN, these pages are marked "in-use" by the
hardware in the RMP entry, and any attempt to modify the RMP entry for
these pages will result in page-fault (RMP violation check).

While performing the RMP check, hardware will try to create a 2MB TLB
entry for the large page accesses. When it does this, it first reads
the RMP for the base of 2MB region and verifies that all this memory is
safe. If AVIC backing, VMSA, and VMCB memory happen to be the base of
2MB region, then RMP check will fail because of the "in-use" marking for
the base entry of this 2MB region.

e.g.

1. A VMCB was allocated on 2MB-aligned address.
2. The VMRUN instruction marks this RMP entry as "in-use".
3. Another process allocated some other page of memory that happened to be
   within the same 2MB region.
4. That process tried to write its page using physmap.

If the physmap entry in step #4 uses a large (1G/2M) page, then the
hardware will attempt to create a 2M TLB entry. The hardware will find
that the "in-use" bit is set in the RMP entry (because it was a
VMCB page) and will cause an RMP violation check.

See APM2 section 15.36.12 for more information on VMRUN checks when
SEV-SNP is globally active.

A generic allocator can return a page which are 2M aligned and will not
be safe to be used when SEV-SNP is globally enabled. Add a
snp_safe_alloc_page() helper that can be used for allocating the
SNP safe memory. The helper allocated 2 pages and splits them into order-1
allocation. It frees one page and keeps one of the page which is not
2M aligned.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/lapic.c            |  5 ++++-
 arch/x86/kvm/svm/sev.c          | 27 +++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          | 16 ++++++++++++++--
 arch/x86/kvm/svm/svm.h          |  1 +
 5 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ad22d4839bcc..71e79a1998ad 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1381,6 +1381,7 @@ struct kvm_x86_ops {
 	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
 
 	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
+	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 152591f9243a..897ce6ebdd7c 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2441,7 +2441,10 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
 
 	vcpu->arch.apic = apic;
 
-	apic->regs = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
+	if (kvm_x86_ops.alloc_apic_backing_page)
+		apic->regs = kvm_x86_ops.alloc_apic_backing_page(vcpu);
+	else
+		apic->regs = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
 	if (!apic->regs) {
 		printk(KERN_ERR "malloc apic regs error for vcpu %x\n",
 		       vcpu->vcpu_id);
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 5f0034e0dacc..b750e435626a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2696,3 +2696,30 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 		break;
 	}
 }
+
+struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
+{
+	unsigned long pfn;
+	struct page *p;
+
+	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
+		return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+
+	p = alloc_pages(GFP_KERNEL_ACCOUNT | __GFP_ZERO, 1);
+	if (!p)
+		return NULL;
+
+	/* split the page order */
+	split_page(p, 1);
+
+	/* Find a non-2M aligned page */
+	pfn = page_to_pfn(p);
+	if (IS_ALIGNED(__pfn_to_phys(pfn), PMD_SIZE)) {
+		pfn++;
+		__free_page(p);
+	} else {
+		__free_page(pfn_to_page(pfn + 1));
+	}
+
+	return pfn_to_page(pfn);
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 392d44a2756d..ede3cf460894 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1323,7 +1323,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	svm = to_svm(vcpu);
 
 	err = -ENOMEM;
-	vmcb01_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	vmcb01_page = snp_safe_alloc_page(vcpu);
 	if (!vmcb01_page)
 		goto out;
 
@@ -1332,7 +1332,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 		 * SEV-ES guests require a separate VMSA page used to contain
 		 * the encrypted register state of the guest.
 		 */
-		vmsa_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+		vmsa_page = snp_safe_alloc_page(vcpu);
 		if (!vmsa_page)
 			goto error_free_vmcb_page;
 
@@ -4480,6 +4480,16 @@ static int svm_vm_init(struct kvm *kvm)
 	return 0;
 }
 
+static void *svm_alloc_apic_backing_page(struct kvm_vcpu *vcpu)
+{
+	struct page *page = snp_safe_alloc_page(vcpu);
+
+	if (!page)
+		return NULL;
+
+	return page_address(page);
+}
+
 static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.hardware_unsetup = svm_hardware_teardown,
 	.hardware_enable = svm_hardware_enable,
@@ -4605,6 +4615,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.complete_emulated_msr = svm_complete_emulated_msr,
 
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
+
+	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 053f2505a738..894e828227d9 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -553,6 +553,7 @@ void sev_es_init_vmcb(struct vcpu_svm *svm);
 void sev_es_create_vcpu(struct vcpu_svm *svm);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_prepare_guest_switch(struct vcpu_svm *svm, unsigned int cpu);
+struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
 
 /* vmenter.S */
 
-- 
2.17.1

