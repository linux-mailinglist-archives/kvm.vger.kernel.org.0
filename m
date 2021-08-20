Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAB453F310E
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236489AbhHTQHS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:07:18 -0400
Received: from mail-bn8nam12on2057.outbound.protection.outlook.com ([40.107.237.57]:38305
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235229AbhHTQFT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:05:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZoTh3DZBhIpDQJ+SRWuDp3x6IZYpP885RrHAfS5lZWlieqmfhFRw+vILK61e/Ua8iuCMXfJ5GnpS3MXOm8n6ZpB+2GP3Jke1n8qsSjiE4lCZc26AZ4cxJ6FtJXdxj7bEP5/Thy7e3bLUYbzRWv/Fl6DAm3JU7bUkjB0gQs81WiJtBr5B7pbqCNr9jtjjPzW2nY5d7mnSK7QVt9Rvc9gBH852OhahRkAVk85Izfxzlot3afbtG+7zgE3P6mTfQeQteBNJNE7Wov6IJwVsq6Vzp1j6g9OEdhpg5sMYjYSpqEXx1eGMGdhX7x5mK+AzDT1/BVgVc2OhZ/uUrVro9EQ5IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Jnc8826SaxneZ/hmGLQnqlgePBBme6Gmk5hvvmG1oY=;
 b=lzXSxGWmOeXFn6k4vFynHyyTvImFLgLe5XxCvxxcmJjR4EFkPmMT514REuERwXtiCOrQuLZx4hp3YhfDpoKnFDwaIGOLNb+WNUZKjSsk5GWThbVc3EExY8+9h2BGvmnt8rIj25lBghFSTLa3Svkolu+Qmy4eYSIpIwc88VO9+v+sdKK+ahJG96NzWok0BRG4aVHz3ahJRscukskVtLT8mrG/0r610dSG3rkrUFrJN+FwTIwivTJDxDR5eirOp8/G5MA8V0f7KDayNjaZyZpJJH83QNHwsd7ElUVq3kYwXf8QhwwSsdHrJbzt5aacD7FWBPUYYvl6lYjOauytkxVNIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Jnc8826SaxneZ/hmGLQnqlgePBBme6Gmk5hvvmG1oY=;
 b=MOG1GqpZYlxC/jeI6OL4jfrFP8OHeUYI84bgPAxrx03igkh4bPps/Y0zIU2XmjJFD10YtRvfnFriJAT+h1DkXt/j2Wks8f2l+CU+cQKAqYAAJ925EcNwbD3VesSx/ZL5IH6zrzt5md4wj9yPDVWrhDLgOau6pMiMEfZRDBLkYlM=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4509.namprd12.prod.outlook.com (2603:10b6:806:9e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 16:01:10 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 16:01:10 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 v5 44/45] KVM: SVM: Support SEV-SNP AP Creation NAE event
Date:   Fri, 20 Aug 2021 10:59:17 -0500
Message-Id: <20210820155918.7518-45-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 16:00:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91c65fce-b0ec-4dd4-7331-08d963f3adee
X-MS-TrafficTypeDiagnostic: SA0PR12MB4509:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45090340CCFF5B78D20E34ADE5C19@SA0PR12MB4509.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XsOSIq+8r9p5+QIK/wih3iblcZQLB+fuBVPAmqYXyfBcBTyqW64jnUH/na6GvdZWb7u1o6SL8C5PJpJhxI6Yu+EOF8mxfcEEyqATlpw30mwHOlsyWAk7Gt1j85ChTiHzaTCswrOmN4KAvpSeahOZSFauSV1/wu22GX/EMM02qlZpD49DknF03gOZoSIHg5lkgDLbgqAsCrNTXlfJNPqrXdykQYh5TJWLrjtUj8RcyLSJ3EhimAT7uTJ/+38JVJmnwpxFRZ7+j9EkTTGcH4rgHCut2GZpFGgPJH5JCIfUwv94a6JWkpA+nuNLOP0QgTYRdnygu6hJDbv6SkVNHTNn+ymlsmmvlEJrhhEbQ6weaAJSkyjwI9c15wG93HpXMawxDhRRJB7v4+HuUBmdUQfo2dBXeGF6DI5Qz90IXVWS5vnAmaP/lozYXvd0LMQjgX26fLt1ayaPJw9AVuK9Q+KYH6GJsD/7jhwiqqBkBV/UXjbON7eblNuI0yAeWdGNd+xcU+q9DAVtidMIN6ZMiv5pC+nE6oPJzsVFyLbvr80KksDBOAbA2VlgLDZDXzmiN3i1W9e/+lX+000244LTjMKebsjOqqFrGhnwHAinDASUan7xmSL7X0HDT5URZWakgYe8f7W/CAMmw/P6rI56spI/YCV2V4vGL5FCMuyBwtuH9pwOxKq65ERNQHac42uM931rvNTIdc5RDVsA8BH/26u+3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(4326008)(36756003)(7416002)(44832011)(54906003)(316002)(66946007)(66556008)(66476007)(86362001)(7406005)(956004)(6486002)(2616005)(2906002)(83380400001)(38350700002)(38100700002)(186003)(30864003)(5660300002)(8936002)(52116002)(1076003)(7696005)(8676002)(26005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jbla7kgeCUO6bqShGA0ej3wnNav72xN3PHbnI4us75ozlCCEIfBzdo3ZpG4k?=
 =?us-ascii?Q?Rio8XXdvTbeFWoMSg6Go11Y04hPkbainygYMcLyql1d2jAC4ECeUIHPQHLnI?=
 =?us-ascii?Q?H5OSnDukVA0fsH/EUcQR4Mblyz3UHEPRPuf4Zmt7ul2kXnUtdFlRh7X5ctyB?=
 =?us-ascii?Q?isqRMA7T5vzaw9WhBG/m7+mL8L1rRLCFdcGdcYvd4lKfjOhCN83oom3b7DuN?=
 =?us-ascii?Q?AhJo/j4U7THnpWQNj5RoAWdmT+fnZgJmSGGa0k63qWmZX3nyIwiObmHxjVxh?=
 =?us-ascii?Q?za10bJZchdONE04tHRmNdPqW3S0BiuWMODbEjY4m65QnJTvhq6T6iUPpMkvk?=
 =?us-ascii?Q?xlDUQdvP+XKnA/qbV2DmSboUOllhwLbSiAodygYym2TQwTaRjYeMWQwSbcoY?=
 =?us-ascii?Q?y2Ufei8IL3eb4IXUxLpPn4+zKZ2YjSlZW2Rw3Ibg/D4gwQ+4+9ZyZNtHz6iq?=
 =?us-ascii?Q?mTpY2PoXXWjI9Vmo0Dt/TgJjjLpClOtUbogxjbzbrRZqTZL9Md8OoqWOCHgK?=
 =?us-ascii?Q?Xp9LXZxD0yp0uY5jXNqIrVORiFvi/boWaEW6R//BY9pgnN8924osMsdzaflb?=
 =?us-ascii?Q?Z5Sg71EK2WiElCEKWrty1jSNIScsDDK8P3KOip2kxPRSErjx8P5QeMGIP5Fo?=
 =?us-ascii?Q?qrx6N2m0V2gB9Ca9aRno6ijOlnFzcfeRyW22iVZd5HlwbDwo29zykyJ1sq/I?=
 =?us-ascii?Q?2u2Hg6IRvLAApFqdJe4tP3BS2zVuVo27nhGjXDQk1Fy98lW4W+Bo32JHxpZm?=
 =?us-ascii?Q?QdC/evKAfKyIkJtMdc06LRHUz+TU5+/XyhENuvFlCx9BfDmyMfjc7zh5WUw/?=
 =?us-ascii?Q?PeSvjRvlGgJ7zeqypcUPM41pd2m5adNU5jCvNlpYxB/eWjXtLYecFBwDAlMs?=
 =?us-ascii?Q?orEjYgKDmjGgd68xy9TqJBRBtoxaiR35RSCPTVwuB18XhlWFzyzGJHtL8+/z?=
 =?us-ascii?Q?f2regEC2X/HVpTRixDsZZN1QhQftcsedbXFiihs9jZPtB8I306KZGb3dsWHB?=
 =?us-ascii?Q?WP0yABTGyJk7YMQSanSvnyhdfiFEwtT/yThqV7xJ4BEz29FNZO7XCR/5+o8R?=
 =?us-ascii?Q?DYYE+sKvlRBY8Q7LE6isZSJ59dXgc5IVE6kuNrytM69lKuJowbPiP+QyTTb1?=
 =?us-ascii?Q?l/yX1lViaI4h3lGiUyzxTgwDjWHULdlsM1ev8bR8jrMfU1tRhkbv1STNdbw/?=
 =?us-ascii?Q?ciBKQHkgN89PjAGhfv1ZBDE0PbLMb0esvIJw8Xq88j0NTUxYwyGIuL+NuB/Q?=
 =?us-ascii?Q?WgfF3v/CYJQZoN+6buv3teBWqnavDQWSRw0ClJG5KIpwE2gb0VEwvx6rd5iM?=
 =?us-ascii?Q?CPuZlfH+f9URC8DUH37zlQrE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91c65fce-b0ec-4dd4-7331-08d963f3adee
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 16:00:49.7543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CTPvbpP83Yhpxuynx4gC/DIlBVHIZojjCVF+URJ80HiS4N6pKwTL/3D2mi9sv8EQ809FE1TlMvXKM3IYSGqhsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4509
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Add support for the SEV-SNP AP Creation NAE event. This allows SEV-SNP
guests to alter the register state of the APs on their own. This allows
the guest a way of simulating INIT-SIPI.

A new event, KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, is created and used
so as to avoid updating the VMSA pointer while the vCPU is running.

For CREATE
  The guest supplies the GPA of the VMSA to be used for the vCPU with the
  specified APIC ID. The GPA is saved in the svm struct of the target
  vCPU, the KVM_REQ_UPDATE_PROTECTED_GUEST_STATE event is added to the
  vCPU and then the vCPU is kicked.

For CREATE_ON_INIT:
  The guest supplies the GPA of the VMSA to be used for the vCPU with the
  specified APIC ID the next time an INIT is performed. The GPA is saved
  in the svm struct of the target vCPU.

For DESTROY:
  The guest indicates it wishes to stop the vCPU. The GPA is cleared from
  the svm struct, the KVM_REQ_UPDATE_PROTECTED_GUEST_STATE event is added
  to vCPU and then the vCPU is kicked.


The KVM_REQ_UPDATE_PROTECTED_GUEST_STATE event handler will be invoked as
a result of the event or as a result of an INIT. The handler sets the vCPU
to the KVM_MP_STATE_UNINITIALIZED state, so that any errors will leave the
vCPU as not runnable. Any previous VMSA pages that were installed as
part of an SEV-SNP AP Creation NAE event are un-pinned. If a new VMSA is
to be installed, the VMSA guest page is pinned and set as the VMSA in the
vCPU VMCB and the vCPU state is set to KVM_MP_STATE_RUNNABLE. If a new
VMSA is not to be installed, the VMSA is cleared in the vCPU VMCB and the
vCPU state is left as KVM_MP_STATE_UNINITIALIZED to prevent it from being
run.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |   1 +
 arch/x86/include/asm/kvm_host.h    |   3 +
 arch/x86/include/asm/svm.h         |   7 +-
 arch/x86/kvm/svm/sev.c             | 211 +++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c             |   6 +-
 arch/x86/kvm/svm/svm.h             |   9 ++
 arch/x86/kvm/x86.c                 |  13 +-
 7 files changed, 247 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index c09bd40e0160..01f31957bd7d 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -126,6 +126,7 @@ KVM_X86_OP(alloc_apic_backing_page)
 KVM_X86_OP_NULL(rmp_page_level_adjust)
 KVM_X86_OP(post_map_gfn)
 KVM_X86_OP(post_unmap_gfn)
+KVM_X86_OP(update_protected_guest_state)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_NULL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8773c1f9e45e..11ce66fe1656 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -91,6 +91,7 @@
 #define KVM_REQ_MSR_FILTER_CHANGED	KVM_ARCH_REQ(29)
 #define KVM_REQ_UPDATE_CPU_DIRTY_LOGGING \
 	KVM_ARCH_REQ_FLAGS(30, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE	KVM_ARCH_REQ(31)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
@@ -1468,6 +1469,8 @@ struct kvm_x86_ops {
 
 	int (*post_map_gfn)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int *token);
 	void (*post_unmap_gfn)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int token);
+
+	int (*update_protected_guest_state)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index a39e31845a33..cf7c88a0d60a 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -218,7 +218,12 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define SVM_NESTED_CTL_SEV_ENABLE	BIT(1)
 #define SVM_NESTED_CTL_SEV_ES_ENABLE	BIT(2)
 
-#define SVM_SEV_FEAT_SNP_ACTIVE		BIT(0)
+#define SVM_SEV_FEAT_SNP_ACTIVE			BIT(0)
+#define SVM_SEV_FEAT_RESTRICTED_INJECTION	BIT(3)
+#define SVM_SEV_FEAT_ALTERNATE_INJECTION	BIT(4)
+#define SVM_SEV_FEAT_INT_INJ_MODES		\
+	(SVM_SEV_FEAT_RESTRICTED_INJECTION |	\
+	 SVM_SEV_FEAT_ALTERNATE_INJECTION)
 
 struct vmcb_seg {
 	u16 selector;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 05f795c30816..151747ec0809 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -649,6 +649,7 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 {
+	struct kvm_sev_info *sev = &to_kvm_svm(svm->vcpu.kvm)->sev_info;
 	struct sev_es_save_area *save = svm->vmsa;
 
 	/* Check some debug related fields before encrypting the VMSA */
@@ -693,6 +694,12 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	if (sev_snp_guest(svm->vcpu.kvm))
 		save->sev_features |= SVM_SEV_FEAT_SNP_ACTIVE;
 
+	/*
+	 * Save the VMSA synced SEV features. For now, they are the same for
+	 * all vCPUs, so just save each time.
+	 */
+	sev->sev_features = save->sev_features;
+
 	return 0;
 }
 
@@ -2760,6 +2767,10 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm, u64 *exit_code)
 		if (!ghcb_sw_scratch_is_valid(ghcb))
 			goto vmgexit_err;
 		break;
+	case SVM_VMGEXIT_AP_CREATION:
+		if (!ghcb_rax_is_valid(ghcb))
+			goto vmgexit_err;
+		break;
 	case SVM_VMGEXIT_NMI_COMPLETE:
 	case SVM_VMGEXIT_AP_HLT_LOOP:
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
@@ -3332,6 +3343,191 @@ static void snp_handle_ext_guest_request(struct vcpu_svm *svm, gpa_t req_gpa, gp
 	svm_set_ghcb_sw_exit_info_2(vcpu, rc);
 }
 
+static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	kvm_pfn_t pfn;
+
+	WARN_ON(!mutex_is_locked(&svm->snp_vmsa_mutex));
+
+	/* Mark the vCPU as offline and not runnable */
+	vcpu->arch.pv.pv_unhalted = false;
+	vcpu->arch.mp_state = KVM_MP_STATE_STOPPED;
+
+	/* Clear use of the VMSA in the sev_es_init_vmcb() path */
+	svm->vmsa_pa = INVALID_PAGE;
+
+	/* Clear use of the VMSA from the VMCB */
+	svm->vmcb->control.vmsa_pa = INVALID_PAGE;
+
+	if (VALID_PAGE(svm->snp_vmsa_pfn)) {
+		/*
+		 * The snp_vmsa_pfn fields holds the hypervisor physical address
+		 * of the about to be replaced VMSA which will no longer be used
+		 * or referenced, so un-pin it.
+		 */
+		kvm_release_pfn_dirty(svm->snp_vmsa_pfn);
+		svm->snp_vmsa_pfn = INVALID_PAGE;
+	}
+
+	if (VALID_PAGE(svm->snp_vmsa_gpa)) {
+		/*
+		 * The VMSA is referenced by the hypervisor physical address,
+		 * so retrieve the PFN and pin it.
+		 */
+		pfn = gfn_to_pfn(vcpu->kvm, gpa_to_gfn(svm->snp_vmsa_gpa));
+		if (is_error_pfn(pfn))
+			return -EINVAL;
+
+		svm->snp_vmsa_pfn = pfn;
+
+		/* Use the new VMSA in the sev_es_init_vmcb() path */
+		svm->vmsa_pa = pfn_to_hpa(pfn);
+		svm->vmcb->control.vmsa_pa = svm->vmsa_pa;
+
+		/* Mark the vCPU as runnable */
+		vcpu->arch.pv.pv_unhalted = false;
+		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+	}
+
+	return 0;
+}
+
+/*
+ * Invoked as part of vcpu_enter_guest() event processing.
+ * Expected return values are:
+ *   0 - exit to userspace
+ *   1 - continue vcpu_run() execution loop
+ */
+int sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	int ret;
+
+	mutex_lock(&svm->snp_vmsa_mutex);
+
+	ret = __sev_snp_update_protected_guest_state(vcpu);
+	if (ret)
+		vcpu_unimpl(vcpu, "snp: AP state update failed\n");
+
+	mutex_unlock(&svm->snp_vmsa_mutex);
+
+	return ret ? 0 : 1;
+}
+
+/*
+ * Invoked as part of svm_vcpu_reset() processing of an init event.
+ */
+void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	int ret;
+
+	if (!sev_snp_guest(vcpu->kvm))
+		return;
+
+	mutex_lock(&svm->snp_vmsa_mutex);
+
+	if (!svm->snp_vmsa_update_on_init)
+		goto unlock;
+
+	svm->snp_vmsa_update_on_init = false;
+
+	ret = __sev_snp_update_protected_guest_state(vcpu);
+	if (ret)
+		vcpu_unimpl(vcpu, "snp: AP state update on init failed\n");
+
+unlock:
+	mutex_unlock(&svm->snp_vmsa_mutex);
+}
+
+static int sev_snp_ap_creation(struct vcpu_svm *svm)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(svm->vcpu.kvm)->sev_info;
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct kvm_vcpu *target_vcpu;
+	struct vcpu_svm *target_svm;
+	unsigned int request;
+	unsigned int apic_id;
+	bool kick;
+	int ret;
+
+	request = lower_32_bits(svm->vmcb->control.exit_info_1);
+	apic_id = upper_32_bits(svm->vmcb->control.exit_info_1);
+
+	/* Validate the APIC ID */
+	target_vcpu = kvm_get_vcpu_by_id(vcpu->kvm, apic_id);
+	if (!target_vcpu) {
+		vcpu_unimpl(vcpu, "vmgexit: invalid AP APIC ID [%#x] from guest\n",
+			    apic_id);
+		return -EINVAL;
+	}
+
+	ret = 0;
+
+	target_svm = to_svm(target_vcpu);
+
+	/*
+	 * We have a valid target vCPU, so the vCPU will be kicked unless the
+	 * request is for CREATE_ON_INIT. For any errors at this stage, the
+	 * kick will place the vCPU in an non-runnable state.
+	 */
+	kick = true;
+
+	mutex_lock(&target_svm->snp_vmsa_mutex);
+
+	target_svm->snp_vmsa_gpa = INVALID_PAGE;
+	target_svm->snp_vmsa_update_on_init = false;
+
+	/* Interrupt injection mode shouldn't change for AP creation */
+	if (request < SVM_VMGEXIT_AP_DESTROY) {
+		u64 sev_features;
+
+		sev_features = vcpu->arch.regs[VCPU_REGS_RAX];
+		sev_features ^= sev->sev_features;
+		if (sev_features & SVM_SEV_FEAT_INT_INJ_MODES) {
+			vcpu_unimpl(vcpu, "vmgexit: invalid AP injection mode [%#lx] from guest\n",
+				    vcpu->arch.regs[VCPU_REGS_RAX]);
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
+	switch (request) {
+	case SVM_VMGEXIT_AP_CREATE_ON_INIT:
+		kick = false;
+		target_svm->snp_vmsa_update_on_init = true;
+		fallthrough;
+	case SVM_VMGEXIT_AP_CREATE:
+		if (!page_address_valid(vcpu, svm->vmcb->control.exit_info_2)) {
+			vcpu_unimpl(vcpu, "vmgexit: invalid AP VMSA address [%#llx] from guest\n",
+				    svm->vmcb->control.exit_info_2);
+			ret = -EINVAL;
+			goto out;
+		}
+
+		target_svm->snp_vmsa_gpa = svm->vmcb->control.exit_info_2;
+		break;
+	case SVM_VMGEXIT_AP_DESTROY:
+		break;
+	default:
+		vcpu_unimpl(vcpu, "vmgexit: invalid AP creation request [%#x] from guest\n",
+			    request);
+		ret = -EINVAL;
+		break;
+	}
+
+out:
+	mutex_unlock(&target_svm->snp_vmsa_mutex);
+
+	if (kick) {
+		kvm_make_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, target_vcpu);
+		kvm_vcpu_kick(target_vcpu);
+	}
+
+	return ret;
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -3589,6 +3785,18 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = 1;
 		break;
 	}
+	case SVM_VMGEXIT_AP_CREATION:
+		ret = sev_snp_ap_creation(svm);
+		if (ret) {
+			svm_set_ghcb_sw_exit_info_1(vcpu, 1);
+			svm_set_ghcb_sw_exit_info_2(vcpu,
+						    X86_TRAP_GP |
+						    SVM_EVTINJ_TYPE_EXEPT |
+						    SVM_EVTINJ_VALID);
+		}
+
+		ret = 1;
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
@@ -3663,6 +3871,9 @@ void sev_es_create_vcpu(struct vcpu_svm *svm)
 	set_ghcb_msr(svm, GHCB_MSR_SEV_INFO(GHCB_VERSION_MAX,
 					    GHCB_VERSION_MIN,
 					    sev_enc_bit));
+
+	mutex_init(&svm->snp_vmsa_mutex);
+	svm->snp_vmsa_pfn = INVALID_PAGE;
 }
 
 void sev_es_prepare_guest_switch(struct vcpu_svm *svm, unsigned int cpu)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index be820eb999fb..29e7666a710b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1336,7 +1336,9 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	svm->spec_ctrl = 0;
 	svm->virt_spec_ctrl = 0;
 
-	if (!init_event) {
+	if (init_event) {
+		sev_snp_init_protected_guest_state(vcpu);
+	} else {
 		vcpu->arch.apic_base = APIC_DEFAULT_PHYS_BASE |
 				       MSR_IA32_APICBASE_ENABLE;
 		if (kvm_vcpu_is_reset_bsp(vcpu))
@@ -4697,6 +4699,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.post_map_gfn = sev_post_map_gfn,
 	.post_unmap_gfn = sev_post_unmap_gfn,
+
+	.update_protected_guest_state = sev_snp_update_protected_guest_state,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 9bf6404142dd..59044b3a7c7a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -94,6 +94,8 @@ struct kvm_sev_info {
 	struct srcu_struct psc_srcu;
 	void *snp_certs_data;
 	struct mutex guest_req_lock;
+
+	u64 sev_features;	/* Features set at VMSA creation */
 };
 
 struct kvm_svm {
@@ -221,6 +223,11 @@ struct vcpu_svm {
 	u64 ghcb_sw_exit_info_2;
 
 	u64 ghcb_registered_gpa;
+
+	struct mutex snp_vmsa_mutex;
+	gpa_t snp_vmsa_gpa;
+	kvm_pfn_t snp_vmsa_pfn;
+	bool snp_vmsa_update_on_init;	/* SEV-SNP AP Creation on INIT-SIPI */
 };
 
 struct svm_cpu_data {
@@ -630,6 +637,8 @@ void sev_rmp_page_level_adjust(struct kvm *kvm, kvm_pfn_t pfn, int *level);
 int sev_post_map_gfn(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int *token);
 void sev_post_unmap_gfn(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int token);
 void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
+void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
+int sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu);
 
 /* vmenter.S */
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bf4389ffc88f..dbb8362cc576 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9576,6 +9576,16 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 		if (kvm_check_request(KVM_REQ_UPDATE_CPU_DIRTY_LOGGING, vcpu))
 			static_call(kvm_x86_update_cpu_dirty_logging)(vcpu);
+
+		if (kvm_check_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, vcpu)) {
+			r = static_call(kvm_x86_update_protected_guest_state)(vcpu);
+			if (!r) {
+				vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+				goto out;
+			} else if (vcpu->arch.mp_state != KVM_MP_STATE_RUNNABLE) {
+				goto out;
+			}
+		}
 	}
 
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win ||
@@ -11656,7 +11666,8 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 	if (!list_empty_careful(&vcpu->async_pf.done))
 		return true;
 
-	if (kvm_apic_has_events(vcpu))
+	if (kvm_apic_has_events(vcpu) ||
+	    kvm_test_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, vcpu))
 		return true;
 
 	if (vcpu->arch.pv.pv_unhalted)
-- 
2.17.1

