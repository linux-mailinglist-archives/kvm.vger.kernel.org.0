Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A542F398C15
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 16:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbhFBOOq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 10:14:46 -0400
Received: from mail-dm6nam12on2047.outbound.protection.outlook.com ([40.107.243.47]:30304
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230209AbhFBONj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 10:13:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YNk8mMrR+DDbFp6HEuL24gxa5TIijYnlm8pVL7ela8DAKRCGGQIxP4yqumKAP2m5KzEhH+eX5DDx+e1GVQmZZoJRWy77w8fJyys2wKdp4S062QLh9GTqTjncofNrSYD3lyr8Vz7SAcqoN0AomifmR8umvN0k57EICK6yBbNcBonILEjgwO6x3jnT5kH+mm7/xIwxFbwiDLmDI4FWIhK7GbXXbtCLuvYbX0FFpHjEMwIHoAtjxsAodGCDXmxGWWUct2NHNp5VadQbbolyurrRZkhlkOup5Z2ZEUWNixKxv3htG3f9Gm6qn4znN/r9SYNwpslij8bI2mJFx1KombaFzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=54QajzVC4b5Be8qChUfvrQpUNx0sYf93+mCe253wOFA=;
 b=hCoaG1J9JnUXv+zng7l1M3d152L0oTXoTQjnKH2cVyqeKOZoy/vNF8W+1etklAWVrpM3ZCN8wkVAWkXqXWCt8VZ7IhJiG0Aqai61BEZFWdPOgDvKyA/4FsLd735Bl8KhtW+8tFQCXP161FPgyYlVDpjxMq2eqOTELkduY9y31/u+JI0D3N7rZKddhJRtDJgfh0+BztyLziG1jDZL12/JW/8T/jejzoTw4Jtx7ce2oRGGjZoxp47pMWyyJjM8HenYSJXxMgV9lBzoV3neadkciqPBh+XC49ASMy7Ii7a4mRqsXO0IF7L1l0kw2IuTRF8pKkuFA/WtgYqjBOAy1ncsqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=54QajzVC4b5Be8qChUfvrQpUNx0sYf93+mCe253wOFA=;
 b=48qtUK52LJglh7kgwblA40xvvSRdwf2g47289Mkz2CDv0G1aS1kqjrsU7RHRjCebxfxbCTO8yMD3L/u7c3TShiSVWPQnDHkY2e6gZy04FXs426ouawj+/xQIcYi5EpDwheCZOFxb8Qnzbjv/3Z5Mgt4/eeHQS5AXnFTPia/Ja+k=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4592.namprd12.prod.outlook.com (2603:10b6:806:9b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22; Wed, 2 Jun
 2021 14:11:54 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 14:11:54 +0000
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
        David Rientjes <rientjes@google.com>, tony.luck@intel.com,
        npmccallum@redhat.com, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v3 20/37] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_START command
Date:   Wed,  2 Jun 2021 09:10:40 -0500
Message-Id: <20210602141057.27107-21-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210602141057.27107-1-brijesh.singh@amd.com>
References: <20210602141057.27107-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0056.namprd11.prod.outlook.com
 (2603:10b6:806:d0::31) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0056.namprd11.prod.outlook.com (2603:10b6:806:d0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Wed, 2 Jun 2021 14:11:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef970233-27e1-4925-96ee-08d925d05f8f
X-MS-TrafficTypeDiagnostic: SA0PR12MB4592:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45927E4785E270F6AD9699A6E53D9@SA0PR12MB4592.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: udYJAtl+u/4E3EcdI6C5fIkaTgWfbJgzZOwJCYlXQfR6Gcs5cDEspvMZ0qeVOGhFZ811qdiq9jeRZFz/INe2G9LFRIXVsunuc0XaOv2i6023ShVqfmpUxt7j4yGT7rDRZuBSLigys3JW8KjFJK/ha7Bz1YAOmTVe84kwHwk/Ho8/N7+WSakCh2aZfOcm+8CKq92DtsQf6w/sWFcS2R7bTzxUIrOmf5flwQfTy1zpR5nmGZFb1ZaL5kmk0THMZSE0O0UiyvbImWBAXX2pAKYm7h+57FDczT1hNN3yEtr8NUJ0adauInhWxG2TT1Hoee5WtNwPSayMIGS/jMbsOSnEaT+ejPCSmkCp2UR/6mZRfbfxmsuCrSSrgmzAleXiTz6w/lyFaOBy4rgL+Yq6RsI5D1snSn+ODbWWQVe0YputK1pPAM4KvhuTUPmWZHmlTnm8iuGNBDJHoSnzLocZWtp52/WDMIZ0yLNVGYdmu+IvTC3H/h+Lt39LOf2kmrp9tmqRFFol06oxyAk7PzJDY48IIu324j551+QWeV4JLm/WUAYw5k7FF6Hem7a+xdYEWqTaHn6zg2GquhNZ/DkovoEUVeYsQZ2rhOMQi5yqKALtZ3+Lmc3uUoA6eDrzURsywYHzr6zJ9CPaJPDXWMWvkZ1HYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(956004)(8936002)(8676002)(36756003)(478600001)(54906003)(83380400001)(1076003)(44832011)(2616005)(6666004)(38350700002)(38100700002)(5660300002)(66476007)(66556008)(2906002)(66946007)(4326008)(26005)(86362001)(186003)(7696005)(52116002)(16526019)(6486002)(7416002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?iY1Qw3SpK//AAB//5j59/vizbjUCvVQBbB66mpepL0t6q9/nr6GbDnBzAWGd?=
 =?us-ascii?Q?/yHmq8eWVFMoSkHiE85dwsXUPQ5Qke+kjz+v2fOvS6ke3QEUPbYfUPEkaqno?=
 =?us-ascii?Q?1NSEQkFJcT9ek2KW83bxG0tJXCNShgdh8q5xPW5rQOmZUMFoCw2ZM1xJIXOn?=
 =?us-ascii?Q?Y5uFKdp+RAjtMgI7s9fXJeQ5mnF3lv5JD8rXdFU/4J5QLyPw4owN+ku02nof?=
 =?us-ascii?Q?HrVO8GlmjZYuoHhBt66Zx7foDHlL5jeZVJFNfOfgXls1AbEE8R+kNZ7R3br7?=
 =?us-ascii?Q?y3sxMc114DPNYQTP2d+JUse/LpxmCub8/+1XQ3R3UXi6i7Q1DK/txGy9qWBi?=
 =?us-ascii?Q?Xod9NuG4ReDap+M/IsHqWuCtzvroHtwv5szEEPA+vs+5safIhZKtkvggJEZS?=
 =?us-ascii?Q?2e1FmiP6ds0JlTG7JovVg49sCNJRc9MI/ciNPy+SIDsEZO8XZfH3WJsVKapC?=
 =?us-ascii?Q?GF4GCm0JNLHibET3m+fz0GmuU9a29xDqMLR+w5B0jP0Wm2iaBg3ti+YFsYJK?=
 =?us-ascii?Q?3Btu98PWXDQgQnBr4+5NVDgnefXWwA2F9Hxi1dpB++8nMMRjF5QQ54lA1yig?=
 =?us-ascii?Q?XI/zFdyZEqOsF4s+wvfhREesu5qpI3qS8py755GMja1aXc7w1j0wbrBuTHl+?=
 =?us-ascii?Q?2fSfhkbYyF9wsBkXfgM5bUJz1hCnWL/Wrqj9Snl6jEdB/h0VDrFJZgjlCwdy?=
 =?us-ascii?Q?1DTRFkr36LNtYXkpPIYl9WwI2DcUv0a9QdmE6woqtAtewCISgw0TYL+iQaaC?=
 =?us-ascii?Q?FEBu1bP5kh5V8fLpqZyNdV7e17fY/7DFpH5MOOE9Jn9BIDvmV8I+u3XT9IL8?=
 =?us-ascii?Q?k3ACN1UkxrWnzzKHmLK666BK4fVlBgTkBLizL1x2Q2EjZIqQ/IhEz78qa/4A?=
 =?us-ascii?Q?jYwvZ5GxU0/muC6nQxxWhI094ReIzxaXcCFHRcaN8YolnCTjGUIUGQTxkjqd?=
 =?us-ascii?Q?lEygJ7xnzOxgculRp//cvOxXFeMAhrRhBmMM7oL43IBReVlRxWduQERCOW7w?=
 =?us-ascii?Q?xECFFrxEpFbQe1hRwg2Wrv9ciD9GIMMz9nhM/+3MZBIzxR7Nt8vthsPbhmAe?=
 =?us-ascii?Q?7Tz4t3nrQoZ5tB/73m7AtT0ClgPyBJZ9Mf0/OyhYnCsY0PZ6I+FQzu3QrcEV?=
 =?us-ascii?Q?MO9dGycgc8j956y/XBRVkBtpGJ3GxrWRzQn8xVhW7pwt6Lw3UwtO/HGlhpD8?=
 =?us-ascii?Q?l1sMggVGHwUyngtKv9WuSygKAPgixlOqPT5sZEKeqsNMUzOTUlP8InknRxM8?=
 =?us-ascii?Q?SkTFY1j1tdGT/CrazyDrblV9g1ZIFbclu1Ko9pVggfp7mVxeqNIhdsd9lFVP?=
 =?us-ascii?Q?ytB6N56zw3AGVZ6J7WodmaKk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef970233-27e1-4925-96ee-08d925d05f8f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 14:11:53.9425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1FmwpMY5zn7ZXWMgejevRclXU0b1frGqfxWJlL1TOruoSAFMZ3h5khK85/h2funEMQN3V/Ft++stOhlYW/UEAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4592
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
index 0cd0078baf75..dac71bdedac4 100644
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
@@ -1508,6 +1511,100 @@ static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
@@ -1597,6 +1694,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_RECEIVE_FINISH:
 		r = sev_receive_finish(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_LAUNCH_START:
+		r = snp_launch_start(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
@@ -1790,6 +1890,28 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
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
@@ -1828,7 +1950,15 @@ void sev_vm_destroy(struct kvm *kvm)
 
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
index b9ea99f8579e..bc5582b44356 100644
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
index f3a86d3a8f04..56ab5576741e 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1680,6 +1680,7 @@ enum sev_cmd_id {
 
 	/* SNP specific commands */
 	KVM_SEV_SNP_INIT = 255,
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

