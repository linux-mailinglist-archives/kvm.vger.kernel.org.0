Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CADC63F309A
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbhHTQBt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:01:49 -0400
Received: from mail-co1nam11on2082.outbound.protection.outlook.com ([40.107.220.82]:59393
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233162AbhHTQBN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:01:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uz1+nCk3CYcM19427Br6DD9a4NHvbQTZtONY+C3d3ETFidSBNstLd6h9RgKvGn2RAtKDNYpnYi4KEDk7VXQ5N6MiTFvcbwHKEO4Tr3nZ0nSOQuMgywS1+XBzZBpWxIakEwlUzrp186CqacoB2hFODpj4RVwUaKnnSecIf1hVL9FWhrM9wevcFaNnUeTrnNsNGJh8K9EjehRtZjp7Qanq349xgvbJpvuqlJgdg2qUGyEEPJNFtOOho7IltVbLwbVgNeMUiXAftgBoVSnK0CI9YxzxD16D/3PokdzHK9zNCJWiGQWaub5EWTUeIqF07r46BvnphRC3rUJ0SxenC1+Feg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iqaEi1VL7oW9ugkrxVDLVhl/9Js0PWrpstIMbzNj2aA=;
 b=OzSfvAtnUj3dNY/+uOzbvxu6sElAiIDYoF7mgppaf1XQC/3cCiyuqFdzX2SQYZ4RUkhC65shAiNYfYE+EvZi2sI/zZfn9AuC2O6gKuOMhoax5w6G+S/pYucKnndL8mMmcbi0CoMd9AXASAPRxu/ZxIDwcbdB9S6U0evmmo2jmuLwXy2c4umSlYlMROr7od4Vdu8Ovdv2QgxTizNm4ggTSS5z9/L3IJ5hRv+cKImU6D/pSyQKI6xmGRS2VbNfaq4rrac/kXVGLmTheoRzuAFSx+TMilxvUmDidpls5L3+hfU1TrFZH01pzqSPsx/FCRTbVpGFwbrF3EGVKuj+sQThmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iqaEi1VL7oW9ugkrxVDLVhl/9Js0PWrpstIMbzNj2aA=;
 b=ZBUbmWjfO5r+Z2gn0NVXyFGhZplOR71jkyO+ytd+o3d/o0D9UnBlpK9yE0YUVaxEnHpE43WaYpotLIl7B+oXMaBj8FDnVK0X/z4R+1uNwTm8nxnN9EAoHP4rY2+iD9MWXd35XZOlsdsI0fzQfLgJPT+Zbe57MDzfILX0D8sNptI=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4574.namprd12.prod.outlook.com (2603:10b6:806:94::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 16:00:24 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 16:00:24 +0000
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
Subject: [PATCH Part2 v5 24/45] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_START command
Date:   Fri, 20 Aug 2021 10:58:57 -0500
Message-Id: <20210820155918.7518-25-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 16:00:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b6e502b-377d-49c6-3b8f-08d963f39efa
X-MS-TrafficTypeDiagnostic: SA0PR12MB4574:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4574FEF26EF4DC92C6922564E5C19@SA0PR12MB4574.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ch5BBSy7fo13I5NJjvudWq29T1+VGzPhk1Q31lh0H1Cf01yAhRxnIIHIHnaKVjptm+9UvoGr5G/tEYiMPJt2v70C7IZ59z8y3myFTs4bjTyMJ/jAPTs2sYyEPqLBHvYyMVT/T4UHTyPGyNwMOOfpEvZnNyLrHs/cNVZT5HFhI4J2+AHYWPKtBrHfYu1SIm2CQ5HTct3CCS25Yq5WdQWeBIR+G18l/gbjHZ9QqEcapL7ujM/I6eVylA79KDpYL2nVzSGB3JH6csT7Bo5PMjSaZGMEW82pDxu9TdxAn2OEmLrytDUBYVdQyGSMiyzkxJX2u0eyciYWFZlg5DSNTSUsgLWDjgqS7gMSs3/wl+UFRYwdfpeC6AEyh2KPoLPRLpbtAgEwiWrxVx9syKbI5EkKdmkdU2BRllsKkx8VTdU/jr0fY5iPbwn5dSn+p7Wdl8qmQoMPdaV3YQxWYVCEW4v/fzWLsguOQL+OSwzQGGu3jrT0rJaOhyjRTRi15AbecrT5HQK0UFNrSMKWwr6xvIL/OaE4xccZRkCSbDvYrK+KteWG8fskosv8/Ql3G3K2iyu1tWbdVk1UKMsv/IaR9XxuglZBsBquHVWMvIaKPeudDUtMia68+yxykrKEiLff1emBy/gN10pj9+WJK0kgLpcgYLgp1cU+wLTQyM+Bf1qVUUnVp8QsJDLxzooJSvxWAyvte5jZ5rAdyiTHIUYas789OA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(346002)(366004)(39860400002)(1076003)(38100700002)(316002)(38350700002)(5660300002)(26005)(44832011)(4326008)(66556008)(54906003)(7416002)(7406005)(8676002)(66476007)(86362001)(66946007)(6666004)(2616005)(956004)(8936002)(2906002)(36756003)(83380400001)(478600001)(6486002)(7696005)(52116002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nttLCe0wJi38nC6ZdpqBSazkURpdkqqc+JvR85o/Wvxpok4WZaEekPQsdFjQ?=
 =?us-ascii?Q?F7Oljg56SAoWWUykxzQ84oevNy5kO0zWKxEqKQthADTCfvDBJHe2vnGv3YPK?=
 =?us-ascii?Q?fCF1KEpHoqeJRIbre1jHUNmm0kkK8duKnRZ3U0Fk8OIgUQoH0re2RupNNuSs?=
 =?us-ascii?Q?df/u8789FqvqExw9V7UMLzz/Hx5hoS38VNde4bakIMJPQZ4TCNJlyih1TaTw?=
 =?us-ascii?Q?Ed8GMIFg/nl+p2UIrnigKPknfx0aWUkHdm7LYvF6h2WrbWpj34dxi/3qyP0n?=
 =?us-ascii?Q?x9UjQWpSzJn5KIfkw8K5FhAlH5/E3YUmGJE904fQcMpZtVgNuSRqytd4CQMn?=
 =?us-ascii?Q?8KoE4q/IBBpH3F2ICESTaPCMi+5B+vfsw8jfRUdX3lD0mw2cRc5eN5wJCzMC?=
 =?us-ascii?Q?+sGyY+Pyggeyi/0HH56+dhn5Uo3GOZy/lzMUE0UX0cFeFXkD2OiBz4Pv+f8k?=
 =?us-ascii?Q?wnW327kXgH3P1p5YVMeVsVbTf8stHYyeEFeUsCp0QtlHG6eqSLhyFVCAgRAT?=
 =?us-ascii?Q?BRyP7GKk9u9GpaxpGv5fOssN0O4KhDkkQ9xZEwIeg6BawRABH2wuUGtEeFr3?=
 =?us-ascii?Q?9z/n3NI5zDFnRSV+eNy50IU9uRRB22GV3QQJMkQp480jWbHXoJCIIrbwfl34?=
 =?us-ascii?Q?uCreaGnUmhypY8VCyVvGxO9wz1nVqpLthyq5aTHEPGmb3A/PkyYlUmdcx5V9?=
 =?us-ascii?Q?8tvlJTRx8xx+oYRx/QExUquaPA8FK0l+8pVnvt+NCat3CodtBk8aOGhLvnQa?=
 =?us-ascii?Q?lRDI5M4IH17+hJBxktLbcw5rvAU5H7hd4i83v+Y4fX/I0d87f9sJw+DNP9YQ?=
 =?us-ascii?Q?wLOv+ZHKaith2ZW69kV95gf0HNJmRFebwK8f3ZYGxxminRJjKOez5O9fBPdq?=
 =?us-ascii?Q?NQpMLNfSierZY/pzCY544EpsYjRciO1RYab0sUjRbM8bH7IeUhzdoazdTBLu?=
 =?us-ascii?Q?RXUcraPlFaZMkPP/sqqAu2BmLWHhbgj1tkbQH15f8nY9REDQz3mDn2iFk5aV?=
 =?us-ascii?Q?qBtbSCdgxuWr34EHtSE0OJY4+FOezy/YMmH8r414EhK4WRjBArYvGt3ix1Be?=
 =?us-ascii?Q?vvImB21uJNBumfNVCuVPxHHwk5VqVw9AqO0cNPUluFJmhlX+Cd4B6KAp2TT2?=
 =?us-ascii?Q?wXPC6ybI9CMyjdukSSvR4xF9Ji/SlWelnerDd6TgFg44pgH1CAwdk4vCXaXZ?=
 =?us-ascii?Q?l6ev74joN/1I7RhoWTWBCmYAENgOGOyym1D+1FmC/dWOssGrA0jBbPaeRoNP?=
 =?us-ascii?Q?sYUH18vxwtzCLIYN+c9sHL38inFmw062k0jJoHLFbsNQjrwKB9CV7n3woQOW?=
 =?us-ascii?Q?ZXhxVhGiY4h9iO+F0rPjKaMl?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b6e502b-377d-49c6-3b8f-08d963f39efa
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 16:00:24.7156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MSC6WgVQack+LsZKlfnwwYEvlBjknLtFlE1kahTRYvgLVgHtPmky3aiatyJYX/igK30W+pz3P+GnVcIIFy6Lsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4574
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_SEV_SNP_LAUNCH_START begins the launch process for an SEV-SNP guest.
The command initializes a cryptographic digest context used to construct
the measurement of the guest. If the guest is expected to be migrated,
the command also binds a migration agent (MA) to the guest.

For more information see the SEV-SNP specification.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 .../virt/kvm/amd-memory-encryption.rst        |  24 ++++
 arch/x86/kvm/svm/sev.c                        | 116 +++++++++++++++++-
 arch/x86/kvm/svm/svm.h                        |   1 +
 include/uapi/linux/kvm.h                      |  10 ++
 4 files changed, 148 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index 7b1d32fb99a8..937af3447954 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -454,6 +454,30 @@ The flags bitmap is defined as::
 If the specified flags is not supported then return -EOPNOTSUPP, and the supported
 flags are returned.
 
+19. KVM_SNP_LAUNCH_START
+------------------------
+
+The KVM_SNP_LAUNCH_START command is used for creating the memory encryption
+context for the SEV-SNP guest. To create the encryption context, user must
+provide a guest policy, migration agent (if any) and guest OS visible
+workarounds value as defined SEV-SNP specification.
+
+Parameters (in): struct  kvm_snp_launch_start
+
+Returns: 0 on success, -negative on error
+
+::
+
+        struct kvm_sev_snp_launch_start {
+                __u64 policy;           /* Guest policy to use. */
+                __u64 ma_uaddr;         /* userspace address of migration agent */
+                __u8 ma_en;             /* 1 if the migtation agent is enabled */
+                __u8 imi_en;            /* set IMI to 1. */
+                __u8 gosvw[16];         /* guest OS visible workarounds */
+        };
+
+See the SEV-SNP specification for further detail on the launch input.
+
 References
 ==========
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 93da463545ef..dbf04a52b23d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -21,6 +21,7 @@
 
 #include <asm/pkru.h>
 #include <asm/trapnr.h>
+#include <asm/sev.h>
 
 #include "x86.h"
 #include "svm.h"
@@ -74,6 +75,8 @@ static unsigned long sev_me_mask;
 static unsigned long *sev_asid_bitmap;
 static unsigned long *sev_reclaim_asid_bitmap;
 
+static int snp_decommission_context(struct kvm *kvm);
+
 struct enc_region {
 	struct list_head list;
 	unsigned long npages;
@@ -85,7 +88,7 @@ struct enc_region {
 /* Called with the sev_bitmap_lock held, or on shutdown  */
 static int sev_flush_asids(int min_asid, int max_asid)
 {
-	int ret, pos, error = 0;
+	int ret, pos, error = 0, ret_snp = 0, error_snp = 0;
 
 	/* Check if there are any ASIDs to reclaim before performing a flush */
 	pos = find_next_bit(sev_reclaim_asid_bitmap, max_asid, min_asid);
@@ -101,12 +104,18 @@ static int sev_flush_asids(int min_asid, int max_asid)
 	wbinvd_on_all_cpus();
 	ret = sev_guest_df_flush(&error);
 
+	if (sev_snp_enabled)
+		ret_snp = snp_guest_df_flush(&error_snp);
+
 	up_write(&sev_deactivate_lock);
 
 	if (ret)
 		pr_err("SEV: DF_FLUSH failed, ret=%d, error=%#x\n", ret, error);
 
-	return ret;
+	if (ret_snp)
+		pr_err("SEV: SNP_DF_FLUSH failed, ret=%d, error=%#x\n", ret_snp, error_snp);
+
+	return ret || ret_snp;
 }
 
 static inline bool is_mirroring_enc_context(struct kvm *kvm)
@@ -1543,6 +1552,74 @@ static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return sev_issue_cmd(kvm, SEV_CMD_RECEIVE_FINISH, &data, &argp->error);
 }
 
+static void *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct sev_data_snp_gctx_create data = {};
+	void *context;
+	int rc;
+
+	/* Allocate memory for context page */
+	context = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT);
+	if (!context)
+		return NULL;
+
+	data.gctx_paddr = __psp_pa(context);
+	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_GCTX_CREATE, &data, &argp->error);
+	if (rc) {
+		snp_free_firmware_page(context);
+		return NULL;
+	}
+
+	return context;
+}
+
+static int snp_bind_asid(struct kvm *kvm, int *error)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_activate data = {0};
+
+	data.gctx_paddr = __psp_pa(sev->snp_context);
+	data.asid   = sev_get_asid(kvm);
+	return sev_issue_cmd(kvm, SEV_CMD_SNP_ACTIVATE, &data, error);
+}
+
+static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_launch_start start = {0};
+	struct kvm_sev_snp_launch_start params;
+	int rc;
+
+	if (!sev_snp_guest(kvm))
+		return -ENOTTY;
+
+	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
+		return -EFAULT;
+
+	sev->snp_context = snp_context_create(kvm, argp);
+	if (!sev->snp_context)
+		return -ENOTTY;
+
+	start.gctx_paddr = __psp_pa(sev->snp_context);
+	start.policy = params.policy;
+	memcpy(start.gosvw, params.gosvw, sizeof(params.gosvw));
+	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_START, &start, &argp->error);
+	if (rc)
+		goto e_free_context;
+
+	sev->fd = argp->sev_fd;
+	rc = snp_bind_asid(kvm, &argp->error);
+	if (rc)
+		goto e_free_context;
+
+	return 0;
+
+e_free_context:
+	snp_decommission_context(kvm);
+
+	return rc;
+}
+
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -1632,6 +1709,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_RECEIVE_FINISH:
 		r = sev_receive_finish(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_LAUNCH_START:
+		r = snp_launch_start(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
@@ -1825,6 +1905,28 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
 	return ret;
 }
 
+static int snp_decommission_context(struct kvm *kvm)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_decommission data = {};
+	int ret;
+
+	/* If context is not created then do nothing */
+	if (!sev->snp_context)
+		return 0;
+
+	data.gctx_paddr = __sme_pa(sev->snp_context);
+	ret = snp_guest_decommission(&data, NULL);
+	if (WARN_ONCE(ret, "failed to release guest context"))
+		return ret;
+
+	/* free the context page now */
+	snp_free_firmware_page(sev->snp_context);
+	sev->snp_context = NULL;
+
+	return 0;
+}
+
 void sev_vm_destroy(struct kvm *kvm)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
@@ -1863,7 +1965,15 @@ void sev_vm_destroy(struct kvm *kvm)
 
 	mutex_unlock(&kvm->lock);
 
-	sev_unbind_asid(kvm, sev->handle);
+	if (sev_snp_guest(kvm)) {
+		if (snp_decommission_context(kvm)) {
+			WARN_ONCE(1, "Failed to free SNP guest context, leaking asid!\n");
+			return;
+		}
+	} else {
+		sev_unbind_asid(kvm, sev->handle);
+	}
+
 	sev_asid_free(sev);
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 57c3c404b0b3..85417c44812d 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -85,6 +85,7 @@ struct kvm_sev_info {
 	struct kvm *enc_context_owner; /* Owner of copied encryption context */
 	struct misc_cg *misc_cg; /* For misc cgroup accounting */
 	u64 snp_init_flags;
+	void *snp_context;      /* SNP guest context page */
 };
 
 struct kvm_svm {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 944e2bf601fe..e6416e58cd9a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1714,6 +1714,7 @@ enum sev_cmd_id {
 
 	/* SNP specific commands */
 	KVM_SEV_SNP_INIT,
+	KVM_SEV_SNP_LAUNCH_START,
 
 	KVM_SEV_NR_MAX,
 };
@@ -1821,6 +1822,15 @@ struct kvm_snp_init {
 	__u64 flags;
 };
 
+struct kvm_sev_snp_launch_start {
+	__u64 policy;
+	__u64 ma_uaddr;
+	__u8 ma_en;
+	__u8 imi_en;
+	__u8 gosvw[16];
+	__u8 pad[6];
+};
+
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
 #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
-- 
2.17.1

