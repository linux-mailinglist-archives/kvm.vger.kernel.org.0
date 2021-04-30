Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 260CB36FABE
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232846AbhD3Mn7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:43:59 -0400
Received: from mail-bn8nam12on2044.outbound.protection.outlook.com ([40.107.237.44]:33505
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231984AbhD3Mmg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:42:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TsC+e0gkFYJLQQ219/WufJKl4PQdPoZbL4+BNr7xSNSQrfwPPUkn2AF+F6/bbr8NHrcbN/FXGodpnpKTk8rjL6POhMGsaysYEoL6NEh2mTDkQiKoU3xOxapT97T9r0PzZd89PD9D1IDEwRR6AEPScMusSeZQ104EFRpp320upwKkH82z5izDWjlRoQz2it+ogWVcfHFZon4tQFG8bpSt1hxlu50pScvi62Ci5AxbVKj0+K3ScfOvaT8YPebI8nFCrWjDcz/SFNaBAXiF9veF31dIKVKHExVOkPNftVk0tIhdDisYP3XRN4o5AF6khZG6M+lG/nu5EuTSCN0k11y4PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7O3x/zHDKj7dzsdcsRJAGUDAkiTNK8ITfL26ZIDyw4=;
 b=cZxsIwNwmXTWxN6uY3+ReF/dUE6LMiYVSMFaxILKrqfq3zlGBoX89FA3VHLvh+QRp5KUTQ7KhXna5gOkNu259U1eeqPX73dg6vt1xGU1oNdQug7iipXBlvU3j3Ccz+7rOpFQlD2IrZ3wYvdUmtBWfkW+kdC0V8YoTKNUKjnu9EbemE13y+DIaNFzWznUvPemMDVisU5ahAAgp6CXJGcfdxk0ckRSFOBmOJmQvmTCfuqlg6F40KZ6ZpGRSpAj1YwXBK+elSoz7EyvSM6+4fuT/9RfQLpfpKFQmISZzkRlI5HpFEXP+HvelW9Qonh5KQ9XwS3LqP2w5F/9ju91MVi/7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7O3x/zHDKj7dzsdcsRJAGUDAkiTNK8ITfL26ZIDyw4=;
 b=1tTyrcKAuVRA24goPnlutkzhMF+sKi9GcuGkWEkFPRoduEc6Xi35izpT+qL8FFwZN/9sm4sI3SJn4B/6yOf1Pz1RDnSYfnz6dTmyX1UKvrhoAY/bbie4RV7qvUQ2vQ6WxD55gIXsyWK0v0JzmkJ7B9xqGjesbDkvbyYPOgr6mFs=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2832.namprd12.prod.outlook.com (2603:10b6:805:eb::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Fri, 30 Apr
 2021 12:39:10 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:39:10 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v2 22/37] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_START command
Date:   Fri, 30 Apr 2021 07:38:07 -0500
Message-Id: <20210430123822.13825-23-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0501CA0089.namprd05.prod.outlook.com (2603:10b6:803:22::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 12:39:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 66e5f7c0-9d78-4260-ff1d-08d90bd4f3a8
X-MS-TrafficTypeDiagnostic: SN6PR12MB2832:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2832A52E7D216D9A74AEC128E55E9@SN6PR12MB2832.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Il8WM+o7XfQi7A/1X2mHnWRtQi9ZOjO9K6XxOmrXZYFZs50FAJhHoTThygBlnURvDErHkLMHRC2aIowzc/cMFZk9ZzcH//aNZJnhdB9r1aje1dVbzIA/yQys3mKt+O7l9tX5rK0IGK8QnsWO1QdD8KrsBerAGgsb18f7Cd4krlaFLzX9Vqhsu9ymc5EKDoUlLmpChdvEXlYyhQPMr9zExLTFmheekZE999sKwyj5gjSMfPTmukBrYLJ4nRGIfVH+lkvyjRaTKflh/6TbLt0FJmx+u0A12TkcxV4Hq1Ke6ZP+iDuTYxqb0P6rPhBWf1XK9hPiTQFroQsVb/7DcIfc0/psA8GUSjInnI4Jz6rK1CsCTjIGSSV//RS1wo3arrVHbH/cqm13L2db3CbD44JbGThCAjrEhw8YHWcq9rnkUEcp289aDHFCVyHeVwurE5mobBP0U8n1IJO/LY1EbM8WDlwuljRNlELRpl0iPqS+3SsRvSkf+cekJDoqzeQxFwwGcv7Rl38qRdOxXsLZ71/8ZpOngi09+Q0bWhv900BLFI87+RyV0YtnG7X7pucv9a7YpfN5M9UdOkAC6PlAOHymAWGGsXzelaEsxlMacEUgTJViycxiR8xcKrgwY0e9LJcLN+hAMjg4J96okg+1JNgodQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(136003)(376002)(346002)(66556008)(956004)(7696005)(66476007)(2906002)(7416002)(66946007)(1076003)(52116002)(38100700002)(186003)(16526019)(4326008)(2616005)(6486002)(5660300002)(44832011)(8676002)(26005)(316002)(8936002)(36756003)(478600001)(83380400001)(86362001)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?3FvzbVgGUBQMt5CjEktBKGgNkrCSX4LbbEDWzxPAqol4TPNvwKRg7EN7YWPX?=
 =?us-ascii?Q?zK4M9v3yUAGd5+Gy0vsIErYoHczd7BhvRNLKb1fj1aewxb+ctBxQ55/wghoA?=
 =?us-ascii?Q?ZJiv3spihes4nXZaLxDRNJvGqTShADt3CB6J5wQErcwoqYwkMKttO+EBTTya?=
 =?us-ascii?Q?XZkdgOlcH0rT0SRMqlBZgnfLRJR11293qsgvASAS8lI66xRSuOT5/yhFNaxF?=
 =?us-ascii?Q?GrObdie/mTPjPcCX1i9fXygYR3Re4yNnxJH1sNnMHT/G6+5op/G/VA38ecdt?=
 =?us-ascii?Q?RcY34JQdy4qaa3muOFYLkBMhLFBrRcowj15e7pOXAZB/0N5y7waMLolcHHFa?=
 =?us-ascii?Q?/CuqpPHj9a9ZiJQ1OEg5tYg95m50v7b+uz58YBpqQ7qrIpiWVUV3jqS7GYQs?=
 =?us-ascii?Q?W5rJ9KPQICEy6RrGyX5B16vpIPkcEDevcVha05ddr5qbIPL9FwKvyx6G86Ct?=
 =?us-ascii?Q?RB7Uw+snMzHoXDb+r/h0zVwpRexxD4Cx3Z/zQH0o3iUgR557UbFensFj+g7n?=
 =?us-ascii?Q?hojrMOb53uvIjO2UgJGXPOj28VrMl06r3ZWpSk+YGGoBUSahhiuR1RVCwtrA?=
 =?us-ascii?Q?1271lIHUg4P8UgmSTPo7lOlz4kcUT+FJGx+U4LrgAjgOl+reZ9GAV2yBqImR?=
 =?us-ascii?Q?MZmwXAY+xLKTp9IzHq4fLJ4zVGOFjDzCGKRO7m/LYgdToW3JSh1RUk2Kmwvj?=
 =?us-ascii?Q?nGUSV+q3TYpTZe6qMe34XX8v4kE4mx4cFCJH+JTfpXtkFa5VLkjQ4LukN5jX?=
 =?us-ascii?Q?hJv+5BISpzqBgc2iSbf5j2/3DO7JqZynXiZHHTc5ED/P3A0GcWZdVr7UzwYN?=
 =?us-ascii?Q?vYAynV0AzFJiacGekrXxpRyyxNWjkRylrIWvAGDlhitnYYtISz9jFpwdQswA?=
 =?us-ascii?Q?ZObWwtNmh6bQYoOJ4XlqTJ0WLl5jXrzK1/VMbDh77Q+QD92lgQOom1Um1GwN?=
 =?us-ascii?Q?z+YkeX8gkxIyaMZUs8l58GOi40ASjpnu6Wzwna+h1S9pr+q78w9CjQ/qREOB?=
 =?us-ascii?Q?8ApKPQpzJJNa1RkPSjtuK+ipypU82OZffU8twjM8rcCeV1H349QG2G8dPAxz?=
 =?us-ascii?Q?EdvMDT352NPliDfHqtTAY4Z+LkdTni2hKzy/Qjs0a4CaFbrfXgl3C+lhf7ME?=
 =?us-ascii?Q?B5SZQVDnXXpeenMC7/PtGKQq0Z9i2P1N4cB9eavE1lq/7ZLy0O/SmuTUqiyI?=
 =?us-ascii?Q?nNGCGRJHfx5l/pWthOKwrCLufFWy4PjwmGptjgWlokZWSiW2aVctj8wyYo8i?=
 =?us-ascii?Q?qZPhvg1ZfYdHKIqDGxGPd4TBxeDHBDGl+1PsCyzvGAFT7vTD2hLlCUmCIM5Z?=
 =?us-ascii?Q?U5HY+aPuKNXhTPfCcl1bTn9P?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66e5f7c0-9d78-4260-ff1d-08d90bd4f3a8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:39:09.9806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2emZaHVrUkTHS5XaJ7onDvA3uVd0EDlhoF7f9Q0H9+WWeAdBtELohsFWVGhL2oladAbwRToYJjzVtnCn5eUjbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2832
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
 arch/x86/kvm/svm/sev.c   | 132 ++++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.h   |   1 +
 include/uapi/linux/kvm.h |   9 +++
 3 files changed, 141 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index ea74dd9e03d3..90d70038b607 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -20,6 +20,7 @@
 #include <asm/fpu/internal.h>
 
 #include <asm/trapnr.h>
+#include <asm/sev.h>
 
 #include "x86.h"
 #include "svm.h"
@@ -75,6 +76,8 @@ static unsigned long sev_me_mask;
 static unsigned long *sev_asid_bitmap;
 static unsigned long *sev_reclaim_asid_bitmap;
 
+static int snp_decommission_context(struct kvm *kvm);
+
 struct enc_region {
 	struct list_head list;
 	unsigned long npages;
@@ -1510,6 +1513,100 @@ static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
+	struct sev_data_snp_activate data = {};
+	int asid = sev_get_asid(kvm);
+	int ret, retry_count = 0;
+
+	/* Activate ASID on the given context */
+	data.gctx_paddr = __psp_pa(sev->snp_context);
+	data.asid   = asid;
+again:
+	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_ACTIVATE, &data, error);
+
+	/* Check if the DF_FLUSH is required, and try again */
+	if (ret && (*error == SEV_RET_DFFLUSH_REQUIRED) && (!retry_count)) {
+		/* Guard DEACTIVATE against WBINVD/DF_FLUSH used in ASID recycling */
+		down_read(&sev_deactivate_lock);
+		wbinvd_on_all_cpus();
+		ret = snp_guest_df_flush(error);
+		up_read(&sev_deactivate_lock);
+
+		if (ret)
+			return ret;
+
+		/* only one retry */
+		retry_count = 1;
+
+		goto again;
+	}
+
+	return ret;
+}
+
+static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_launch_start start = {};
+	struct kvm_sev_snp_launch_start params;
+	int rc;
+
+	if (!sev_snp_guest(kvm))
+		return -ENOTTY;
+
+	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
+		return -EFAULT;
+
+	/* Initialize the guest context */
+	sev->snp_context = snp_context_create(kvm, argp);
+	if (!sev->snp_context)
+		return -ENOTTY;
+
+	/* Issue the LAUNCH_START command */
+	start.gctx_paddr = __psp_pa(sev->snp_context);
+	start.policy = params.policy;
+	memcpy(start.gosvw, params.gosvw, sizeof(params.gosvw));
+	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_START, &start, &argp->error);
+	if (rc)
+		goto e_free_context;
+
+	/* Bind ASID to this guest */
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
@@ -1599,6 +1696,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_RECEIVE_FINISH:
 		r = sev_receive_finish(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_LAUNCH_START:
+		r = snp_launch_start(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
@@ -1791,6 +1891,28 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
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
+	if (ret)
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
@@ -1829,7 +1951,15 @@ void sev_vm_destroy(struct kvm *kvm)
 
 	mutex_unlock(&kvm->lock);
 
-	sev_unbind_asid(kvm, sev->handle);
+	if (sev_snp_guest(kvm)) {
+		if (snp_decommission_context(kvm)) {
+			pr_err("Failed to free SNP guest context, leaking asid!\n");
+			return;
+		}
+	} else {
+		sev_unbind_asid(kvm, sev->handle);
+	}
+
 	sev_asid_free(sev);
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 85a2d5857ffb..a870bbb64ce7 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -67,6 +67,7 @@ struct kvm_sev_info {
 	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
 	struct kvm *enc_context_owner; /* Owner of copied encryption context */
 	struct misc_cg *misc_cg; /* For misc cgroup accounting */
+	void *snp_context;      /* SNP guest context page */
 };
 
 struct kvm_svm {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index aaa2d62f09b5..00427707d053 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1680,6 +1680,7 @@ enum sev_cmd_id {
 
 	/* SNP specific commands */
 	KVM_SEV_SNP_INIT,
+	KVM_SEV_SNP_LAUNCH_START,
 
 	KVM_SEV_NR_MAX,
 };
@@ -1777,6 +1778,14 @@ struct kvm_sev_receive_update_data {
 	__u32 trans_len;
 };
 
+struct kvm_sev_snp_launch_start {
+	__u64 policy;
+	__u64 ma_uaddr;
+	__u8 ma_en;
+	__u8 imi_en;
+	__u8 gosvw[16];
+};
+
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
 #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
-- 
2.17.1

