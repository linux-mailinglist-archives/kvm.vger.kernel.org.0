Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15F853F3092
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235156AbhHTQBn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:01:43 -0400
Received: from mail-co1nam11on2054.outbound.protection.outlook.com ([40.107.220.54]:58929
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238730AbhHTQBH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:01:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rcs3yvXKOOY5krGLR52eEpURns+525y5rn7duXllN9NF0Y6vTpIh9qCLb76tDdNpBhItGdLCX66CvBYLjTX2mPzkVNmCSPkPU3i3zRWKrmOxybopcV5/4PXczpvjlViAtVVtUGkRKsxhbBh+NxbJyZvD3daO4teV0rGlQ+Gad4FcnrSGKfbGtJD8V9X8DheTJWUmQhlwWccZmrbH9TIa1cEfMMQkpNhJLjRnCtXtresZxuX4CwoVa9dUzPQJPoX8kVbSmJ8cadoqRjgsnWM93PmJmQSJ960FI0RruCCbHbUo0BA0adlAyXwUmnr5n3YzI321CeBEtT0dHdNCI5Sd4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jlJcvYVaiMD/JLeTyfBRvK66K4Ki94b7fyfP1H7TJ80=;
 b=TI07HdjO0JpM+IWilWOFb3XH4x4HNbvGwWLG9fGuPndjMr1h92G5cs+q1Y3X42pfSG4jzWJm45tRLDiALnN8iTkzHIdotLWVN6YRGNJZITwiZh4cUiItRABkD9fxej5VQZyFVA3HKdDEuWaBx/NjPxq2saNNPYIA1/Clwc2Ivq5mMluvVHxYfq4kTvK+l2c2TMsCXJ5vOn+WNnGw4svyLHWzHpwoZl2EvroUB/UF4yRk3kd5M90rjvcoGzR4yqMmrWIJJnINwsEVTJwtpaKW9Ifnzw6G7RZDo09hP2rlnV+YD45BK4BYWVn38mWADy3otkqpLVHAXSSF5Hjg83qySQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jlJcvYVaiMD/JLeTyfBRvK66K4Ki94b7fyfP1H7TJ80=;
 b=CNJGhwg3tuF4YZKuatKfRqRYX1VqHXIfqqt5AdMrFOaKnolWljgaVDKNEqiC1ImBSeLuxcc/KRDISC+vjkxnJ8AEEPg3Uf6TPuUs6yaogu+l8Uwm42SUEneXrAGrNJURMZZU5zrq8o+1wT8zXPtyM0rqsyWnAyJuzBH8en7vzJE=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4574.namprd12.prod.outlook.com (2603:10b6:806:94::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 16:00:23 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 16:00:23 +0000
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
        Brijesh Singh <brijesh.singh@amd.com>,
        Pavan Kumar Paluri <papaluri@amd.com>
Subject: [PATCH Part2 v5 23/45] KVM: SVM: Add KVM_SNP_INIT command
Date:   Fri, 20 Aug 2021 10:58:56 -0500
Message-Id: <20210820155918.7518-24-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 16:00:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ace43b19-b5a6-4fb5-7841-08d963f39e42
X-MS-TrafficTypeDiagnostic: SA0PR12MB4574:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB457484C2DEC1565924331881E5C19@SA0PR12MB4574.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dO7eQHXX0LddXgVsYWJiF/dpQ8bHvbQJ0nMe0jiQROkDQ203ndzvo7jIL8yiD4u/Z8EbbVqIUkOzB0nz6FTK7HPMYf4nHmavPY6NkSqZFFxxPxThwLGVURWFOLfkCJLWeH31SbgdwTFhM+VBEjXJ2gQJSz3RxmYxsUN4M6s+PdwvfAK4CUlwuJk1ZPQlFhkO4QJKlAiAb03yaJ9QUldOATMHtnmhuqiOOgMbUHBEopNv7UVLcxpGojTTcGh2TF+kuwYBpKcL6ojAQVbj5yauDL59yFV9SgG8lKo3S6lF6EutEL3IeYk10gdqaQ3cTRkAnSA/wyPYVkeCJyrYyidPbSOu6mbKbjwHL8iXoQp1tVPw8VQm3vs5ZV+Ry/GNKD49s2E7tfECPxRqcQJON/snojnqBb+PmZtxaOEavhQgSnM8OEizcqYXgYjkEBtWIUFE81hkt10BwUS5nLqYdbM2sNYxOm8aYSaAFhLZkG80SMuDFs533YZ4ONOB0ejARXCspKZJ/CO8sE6FInGaLGfS3wFdHDiCvUKsJ60ThiYv2F4UXA0jDrMOe4yr4QJB4ZX81y1yBBYPv+EWIfS/QTqoTI1UBK+zBaNhvhD7MUEAiegU++SWEUZvM4j40gy8dKa79Gss4LIPkWKNMLfyuj6EAzfKDlP9qmco8f5wyrWnfBe93NVigbEySciaJ5/TQxjzbwivFrtaQYFRa6uddIgi5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(346002)(366004)(39860400002)(1076003)(38100700002)(316002)(38350700002)(5660300002)(26005)(44832011)(4326008)(66556008)(54906003)(7416002)(7406005)(8676002)(66476007)(86362001)(66946007)(6666004)(2616005)(956004)(8936002)(2906002)(36756003)(83380400001)(478600001)(6486002)(7696005)(52116002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CxNfI7jw3+8E0wtzJ6Z8chBIBcpqhLr4Joko9WESYCkWIFSn/m7TiycEkl4O?=
 =?us-ascii?Q?jTcfNoc2h3XVZPJM1fQ4T0gVIROlmbqnHGCix2qqf3102/QNrRUxPfdpzi7Q?=
 =?us-ascii?Q?UFXLPpnv/Grwan6sLq9fSce4kF1yHKhBpDEInrRsgdY8ZN31Uoms/p++AvFm?=
 =?us-ascii?Q?ssU1790n3ENuLKjgJhJD+8rVGiUOoTNglOULO7Qn/IYjKvlPubeb9v0S/LZm?=
 =?us-ascii?Q?43r9WXb1fhSPf6u+0FhLEbUeGMJVCqXVVq4xbbkKfQwTuvH89H3Wu4I2Jnv6?=
 =?us-ascii?Q?8SBvumUNpIPrbF9OX/YLkKiG1GYwB/gFp08Oy+9MfS4RzdyjKYy4ygOnOXZm?=
 =?us-ascii?Q?toNhRF3O360ASX2vBs4rHe5aJLLbJKtjY+DakK7wrrS7otRoyWhS8Ayv7hMl?=
 =?us-ascii?Q?FlcLa0Vf5lgsnphJih31lPalbkaiqB7XOVKMdM+usFg2DDEGxksljK9TPd6p?=
 =?us-ascii?Q?cIDk+m70EGBV9oYydchAdO0wsbn/Ns68lTSIA1pmNxR0Vr8L4hIRfbbyLRAI?=
 =?us-ascii?Q?ptySRC11zVjuqUllYHNkkAwhUMTlBwt6nkJKAdCbkgfzUtq4NIwPA3HuiCE6?=
 =?us-ascii?Q?1W9HiuoHtdwPep01mDenhbX/pXHZgE7TQSDvAFo/0FKI1gRSzE0f7UWijota?=
 =?us-ascii?Q?ZkdrvHhTpVpjgzdnWARM5zTWbLcN7zwoDbZvM201PrhPCvJu5RX1TPejy+M7?=
 =?us-ascii?Q?HufGCa801y7LEwxhOJzOUkv7nybPplPpEelMjSfKaRXXJdyJWy2hOq22auLe?=
 =?us-ascii?Q?CgxBGPkBXOqCFz6aWHv7UTpwSsiHoTdPvgrkX8RohpxIEcPfurCzLhmLyUYy?=
 =?us-ascii?Q?tCz1J5hNLiH0b6vO5LhTQQ8zX7yMaUBZzY7Z02CT6H9t+mn9vmcNNPMl/jYA?=
 =?us-ascii?Q?tL0aOmDGa1Qhksdt0vmUjEFolhO95i9iF6LRBE9jZ/UFHpUksYULbVL8H2qw?=
 =?us-ascii?Q?ZIr+UITW8FT+UWkGHhtfIH01wHSCNJfVOXKz+85jo9f2CfCWqNbrvTHXE0w8?=
 =?us-ascii?Q?4ZDoMTLZSbnwVOuycVqt7q5+iHj/KhuwLag/LhQRqiC8zRMlYWHB8JnVuTBU?=
 =?us-ascii?Q?01Lz3xLv8AS9JA7HqpoNBevqcAbuImBICU9bc9Z7+RxBLPXGnTLWnMxiF4t1?=
 =?us-ascii?Q?rc6oRt4yywkyQ1ttwgyN4il2qpfJDLHtXLBdZGUHu1TLINTKS6DKC4chgA76?=
 =?us-ascii?Q?EneK43yotIT/F8ilJpi6qWMHrpwyW0FRBlGpEHrmfpwlxGoxRUrJngQybGrq?=
 =?us-ascii?Q?+pxxQttjRDf3mEoiDMJan8suJhSpIOf8EsC6kpeNu/XfWpS5cz9rzn7pTFwJ?=
 =?us-ascii?Q?ttiXqZZuyq7BzrsvYZKea7k1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ace43b19-b5a6-4fb5-7841-08d963f39e42
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 16:00:23.4673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 85iCzkdOEsgf1rp90/pRtHM0KYsHScXuJYU7oL9ES7cHNIoX+nhyY2o6fe1KvQtbJRzUH2Zcg+nXCNiEEkkh9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4574
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM_SNP_INIT command is used by the hypervisor to initialize the
SEV-SNP platform context. In a typical workflow, this command should be the
first command issued. When creating SEV-SNP guest, the VMM must use this
command instead of the KVM_SEV_INIT or KVM_SEV_ES_INIT.

The flags value must be zero, it will be extended in future SNP support to
communicate the optional features (such as restricted INT injection etc).

Co-developed-by: Pavan Kumar Paluri <papaluri@amd.com>
Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 .../virt/kvm/amd-memory-encryption.rst        | 27 ++++++++++++
 arch/x86/include/asm/svm.h                    |  2 +
 arch/x86/kvm/svm/sev.c                        | 44 ++++++++++++++++++-
 arch/x86/kvm/svm/svm.h                        |  4 ++
 include/uapi/linux/kvm.h                      | 13 ++++++
 5 files changed, 88 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index 5c081c8c7164..7b1d32fb99a8 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -427,6 +427,33 @@ issued by the hypervisor to make the guest ready for execution.
 
 Returns: 0 on success, -negative on error
 
+18. KVM_SNP_INIT
+----------------
+
+The KVM_SNP_INIT command can be used by the hypervisor to initialize SEV-SNP
+context. In a typical workflow, this command should be the first command issued.
+
+Parameters (in/out): struct kvm_snp_init
+
+Returns: 0 on success, -negative on error
+
+::
+
+        struct kvm_snp_init {
+                __u64 flags;
+        };
+
+The flags bitmap is defined as::
+
+   /* enable the restricted injection */
+   #define KVM_SEV_SNP_RESTRICTED_INJET   (1<<0)
+
+   /* enable the restricted injection timer */
+   #define KVM_SEV_SNP_RESTRICTED_TIMER_INJET   (1<<1)
+
+If the specified flags is not supported then return -EOPNOTSUPP, and the supported
+flags are returned.
+
 References
 ==========
 
diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 44a3f920f886..a39e31845a33 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -218,6 +218,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define SVM_NESTED_CTL_SEV_ENABLE	BIT(1)
 #define SVM_NESTED_CTL_SEV_ES_ENABLE	BIT(2)
 
+#define SVM_SEV_FEAT_SNP_ACTIVE		BIT(0)
+
 struct vmcb_seg {
 	u16 selector;
 	u16 attrib;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 50fddbe56981..93da463545ef 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -235,10 +235,30 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
 	sev_decommission(handle);
 }
 
+static int verify_snp_init_flags(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_snp_init params;
+	int ret = 0;
+
+	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
+		return -EFAULT;
+
+	if (params.flags & ~SEV_SNP_SUPPORTED_FLAGS)
+		ret = -EOPNOTSUPP;
+
+	params.flags = SEV_SNP_SUPPORTED_FLAGS;
+
+	if (copy_to_user((void __user *)(uintptr_t)argp->data, &params, sizeof(params)))
+		ret = -EFAULT;
+
+	return ret;
+}
+
 static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
+	bool es_active = (argp->id == KVM_SEV_ES_INIT || argp->id == KVM_SEV_SNP_INIT);
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-	bool es_active = argp->id == KVM_SEV_ES_INIT;
+	bool snp_active = argp->id == KVM_SEV_SNP_INIT;
 	int asid, ret;
 
 	if (kvm->created_vcpus)
@@ -249,12 +269,22 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		return ret;
 
 	sev->es_active = es_active;
+	sev->snp_active = snp_active;
 	asid = sev_asid_new(sev);
 	if (asid < 0)
 		goto e_no_asid;
 	sev->asid = asid;
 
-	ret = sev_platform_init(&argp->error);
+	if (snp_active) {
+		ret = verify_snp_init_flags(kvm, argp);
+		if (ret)
+			goto e_free;
+
+		ret = sev_snp_init(&argp->error);
+	} else {
+		ret = sev_platform_init(&argp->error);
+	}
+
 	if (ret)
 		goto e_free;
 
@@ -600,6 +630,10 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	save->pkru = svm->vcpu.arch.pkru;
 	save->xss  = svm->vcpu.arch.ia32_xss;
 
+	/* Enable the SEV-SNP feature */
+	if (sev_snp_guest(svm->vcpu.kvm))
+		save->sev_features |= SVM_SEV_FEAT_SNP_ACTIVE;
+
 	return 0;
 }
 
@@ -1532,6 +1566,12 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	}
 
 	switch (sev_cmd.id) {
+	case KVM_SEV_SNP_INIT:
+		if (!sev_snp_enabled) {
+			r = -ENOTTY;
+			goto out;
+		}
+		fallthrough;
 	case KVM_SEV_ES_INIT:
 		if (!sev_es_enabled) {
 			r = -ENOTTY;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 01953522097d..57c3c404b0b3 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -69,6 +69,9 @@ enum {
 /* TPR and CR2 are always written before VMRUN */
 #define VMCB_ALWAYS_DIRTY_MASK	((1U << VMCB_INTR) | (1U << VMCB_CR2))
 
+/* Supported init feature flags */
+#define SEV_SNP_SUPPORTED_FLAGS		0x0
+
 struct kvm_sev_info {
 	bool active;		/* SEV enabled guest */
 	bool es_active;		/* SEV-ES enabled guest */
@@ -81,6 +84,7 @@ struct kvm_sev_info {
 	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
 	struct kvm *enc_context_owner; /* Owner of copied encryption context */
 	struct misc_cg *misc_cg; /* For misc cgroup accounting */
+	u64 snp_init_flags;
 };
 
 struct kvm_svm {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index d9e4aabcb31a..944e2bf601fe 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1712,6 +1712,9 @@ enum sev_cmd_id {
 	/* Guest Migration Extension */
 	KVM_SEV_SEND_CANCEL,
 
+	/* SNP specific commands */
+	KVM_SEV_SNP_INIT,
+
 	KVM_SEV_NR_MAX,
 };
 
@@ -1808,6 +1811,16 @@ struct kvm_sev_receive_update_data {
 	__u32 trans_len;
 };
 
+/* enable the restricted injection */
+#define KVM_SEV_SNP_RESTRICTED_INJET   (1 << 0)
+
+/* enable the restricted injection timer */
+#define KVM_SEV_SNP_RESTRICTED_TIMER_INJET   (1 << 1)
+
+struct kvm_snp_init {
+	__u64 flags;
+};
+
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
 #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
-- 
2.17.1

