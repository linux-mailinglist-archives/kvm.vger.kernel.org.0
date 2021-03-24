Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE9C347EB8
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 18:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237232AbhCXRFv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 13:05:51 -0400
Received: from mail-dm6nam11on2071.outbound.protection.outlook.com ([40.107.223.71]:41848
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237054AbhCXRFI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 13:05:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C5+6fLq+YPpJfF2UhHuAWVYVXSdpfYtNd+Cr9/aGtL8t7byQosvF5p6Mni1CQC1UtbsYfK0vHSFhFTZjpHqnf3RFSY8szgcIXY6VtKaeftS3W8iyjCKjql3aU6LtX78C0bB//eO9Y9iYg2KhFJOA5/0VzwOhk4VL0WCRVr4fYglM0P0aDcyby2268PtbRNnPA4CiDHcnybej+pLABFDMD4gPe65rcTNHqSmGvGyKBBKd1SIYCUxBnbAUv2fKUYSZDok/a8rRiJ2vx0sd2cFjcnLTJJ2Wdw2z6O/gaI99RVzwrZ2uSboyiFMaRmtX/NWX0J90JKjuLxwD+HCeVrejtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=62dt+AxoNHZGDqiA1RV1K24dKu7zv7Iirhr+Lsn5cYM=;
 b=EQAl/TZrbxfdTrsPiOcNNhO6BVKUigEo4HANNez9w1z+c0WRDW8qsiD20RtMtxaKt3jOZmgdXa3gOanx5svsKK7Yh2sp6snYAqQljYGZAln7CHrxHlMTRoNrG7IjBOHluDdj97BIgr1vh6ky4cj58v3kgnnFE/GwdlvldEQwvrNhNIFsn0h01e4Agfo0gfiiLVom8FBAuHpLMY1ARSCd2FPEuFUSLwLAOoS3w/5Oq7d47lPzfwlS0droxrXiKj20RAy+1TUo10qBKX/KRrzpGG2AInClH6GKd2IgVofke3iOVtFSowmgjmrdugalP8emmQDQKMW5CfqyyvlKl4e3YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=62dt+AxoNHZGDqiA1RV1K24dKu7zv7Iirhr+Lsn5cYM=;
 b=lwIywfEWhg9cb0Xuel6DVMIojvSlr/kM7H0cb1pu5T/dSfrENlJWR2yY6GAu7zjFZSjOdMtN/0lIf3+QQtI4K4Acest8a0bySibDqNfuJAUhV/arF+gFNrmDdwxWE3Ky+Fm+AtrteP1odnZYpkZrA34zYRFkCah0m0pmmF9bjZc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4382.namprd12.prod.outlook.com (2603:10b6:806:9a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Wed, 24 Mar
 2021 17:05:05 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 17:05:05 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org
Cc:     ak@linux.intel.com, herbert@gondor.apana.org.au,
        Brijesh Singh <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [RFC Part2 PATCH 17/30] KVM: SVM: add KVM_SEV_SNP_LAUNCH_START command
Date:   Wed, 24 Mar 2021 12:04:23 -0500
Message-Id: <20210324170436.31843-18-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210324170436.31843-1-brijesh.singh@amd.com>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0210.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::35) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0210.namprd11.prod.outlook.com (2603:10b6:806:1bc::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Wed, 24 Mar 2021 17:05:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9ff53f3b-06cb-4d23-6e9c-08d8eee6f838
X-MS-TrafficTypeDiagnostic: SA0PR12MB4382:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4382CCE6F7C0A8FCFF0E59F2E5639@SA0PR12MB4382.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NinE5UI/msX0HYZ8iOSc3L8Hd/iiKgxClDkwjJdCt9wfNtszp8ajXL35H4G1asfZHlKvrckkUxn3+Kda635FXHlgj2PGbFIJcPpWinmFbZ6rJu2zw+Qa9PjJvfF3tLod3rUnjKKC53OB5URE5d9UxBd2uo82gVHY4CE9Zb17FesGfnnoZRP6P2nZ4aadtOHyWGKfD4Pi6Ay09GUmXaFSbah2neNoT2/Za7i9NuLSoWjE+ieQNN3pADHarY7RGtdo3H6Il72UaCP5ekbKMmVIYAoPVxjAwpu10/klVd9ikt25D2LYQKCgOYWzd7purqqAAFzDu2uwhuvWQ5FRyePv9haPgb5oprhu+3DdXeoNv653iJCY06DB0pqM8jjNJal2qT7oLehY4UeNUFNsEbSmpEX0VHSvPS5qyOWLHYkpavT4pqLbPSOj9/JMyOUK3mMS+THcxSKaCuTS88tB0D4Xexay5kFvKSFxerJy20kjzskBWQhd7tMkAI6/A+OE0kBWzFzQ6aSjiwD9hQCcnrRM/1pvbx5W5m4EH3dQT8PSEGe63zDCD/lTLEB0qchKpTTRpg+4/3HZ/bky8I8OhdNQP42/Ljdpy+gQ7k+4XogHIaN9dzs1LEaInl6MFz2xAY/B2z+fdKaOppGtgfbEbmZ9zg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(346002)(366004)(39860400002)(6666004)(44832011)(66946007)(1076003)(66556008)(66476007)(956004)(36756003)(478600001)(2616005)(83380400001)(8676002)(2906002)(8936002)(26005)(86362001)(5660300002)(52116002)(7696005)(38100700001)(4326008)(54906003)(7416002)(16526019)(6486002)(316002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?J+rBy8j4YzjeARwPvGlMeqNOkvrPyZD6AJZYa94mo77WUfahhMSDQVLzHBfI?=
 =?us-ascii?Q?65OGLmX21kqe0pdTHbYjQlznqJN2+kUvXNokjULDU6T/dzqcX/45a07Q/nUa?=
 =?us-ascii?Q?c4Te4vy1pYXL5lMGW8q+uqxPAqwuHc1A2Fn1GVILzZzBIoi8ZIvbFnxATfw4?=
 =?us-ascii?Q?rw+nP4cHjkCtJkGOWh3MIG0wcL+Eya4ZvMy0OkQim82B4zyugC19i7cDg7RG?=
 =?us-ascii?Q?1xBis3xrDVYnRfsnsY/mjsOsnxUWl6rs+a31PUlZpgahDSnfdHNrvUdid5Hr?=
 =?us-ascii?Q?ToqPt25Scs+vchDkP386/+Xoq4hjmgHwn6IhPtJwmzHqOaFOqSmUVNt0YNfV?=
 =?us-ascii?Q?vBAKjWYhVTvhdiMONXul1e9YZg3wBTWKCs0IPe0+rwJjlyKdytORAVudKL60?=
 =?us-ascii?Q?SPT1gtwr0+2pKDDFVaHSuv5PVF9TN3NimsBnoT3OmpqN9poRsOFENSn4zyg6?=
 =?us-ascii?Q?gOmyXHea665iUmb2vgnx1gxLtCT3EjmQ81ltgHEXvCLvLLOY0iCXEsWH8w0L?=
 =?us-ascii?Q?6119roByiYIwOCdnGf6aTNxh14IfDjqsvmHU+Vei767oyQsAQFxmlH68OjXs?=
 =?us-ascii?Q?23qiy0u1UaqsuxgpW2m+eOyZBmxWAmVIaIZP2VRJYL1gZJQ2diTpp60fnu7i?=
 =?us-ascii?Q?g8Tr8zaJJaCI8qVYXYzZuC/L5RghupSGINV7OgjJF/0IW+fQo2BHkY/vW93E?=
 =?us-ascii?Q?m2XIhTqsA+WqT1GA8fRBGpN0pXSH5IpBnLApDysqDNtOOzF4++UQxICGaG29?=
 =?us-ascii?Q?vn2FA37Q8rb3Mj6gJJwhmb8qwK+5+/6tiTZlLapVk96cUWi8QFmJACkNWvIe?=
 =?us-ascii?Q?G0RLROTLD5sge9mu8HXXBbEb64AfYuSmWPB4INXm70kyOdcgoYLy73mg6IF2?=
 =?us-ascii?Q?aSA2ux1O1HCIoH7YHIvH8DbckbhgXO7RTvie8Fb+AGTzZiXpnYk8TRFR0mWl?=
 =?us-ascii?Q?DxppA9mXfKum/Z9OcShXGnJLneg6rZ7qu6RKJY55oP2dBFO4gtMLUZ1p394J?=
 =?us-ascii?Q?q6NyqGoNtUBbQ7SJEEWZIL+1R7LyO2W3gEVVByIQYUrk3vyePMKr5ql3Rw7N?=
 =?us-ascii?Q?OXl8Qv1l63Q3DChf9JPQsZyJhW8H+9zTZPIgN6zFzeCDnRukFunN9FePOl5r?=
 =?us-ascii?Q?Efs9QjQRloaf3wBLyelDkQwAXvkHGGiKgJ5WemX7S78laUiAhTkgsu1oJN59?=
 =?us-ascii?Q?mPmms9Lgg5z36oOhTu1Wixlhw8WSYOJUpbIz+mPEp8UTYXwnMc4eGR/uRjjz?=
 =?us-ascii?Q?0BrOFd4QmefKF+j85faXEXvBs3Ik4jEWsdAZ3LPInAwhZyEOsGDAPdws9BPV?=
 =?us-ascii?Q?0YL5t/NG3muW6K0rfqFUqEdw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ff53f3b-06cb-4d23-6e9c-08d8eee6f838
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 17:05:04.9480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e3gQyYaR0ABzX8lZms1qiuviHfVplMo7PzykyT7/XPzvD+E7eGStGiLODArFBTfJlz5mg0ouAcL7IeSuaSZI5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4382
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_SEV_SNP_LAUNCH_START begins the launch process for an SEV-SNP guest.
The command initializes a cryptographic digest context used to construct the
measurement of the guest. If the guest is expected to be migrated, the
command also binds a migration agent (MA) to the guest.

For more information see the SEV-SNP spec section 4.5 and 8.11.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/svm/sev.c   | 221 ++++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.h   |   1 +
 include/uapi/linux/kvm.h |   8 ++
 3 files changed, 229 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 36042a2b19b3..7652e57f7e01 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -37,6 +37,9 @@ static unsigned int min_sev_asid;
 static unsigned long *sev_asid_bitmap;
 static unsigned long *sev_reclaim_asid_bitmap;
 
+static void snp_free_context_page(struct page *page);
+static int snp_decommission_context(struct kvm *kvm);
+
 struct enc_region {
 	struct list_head list;
 	unsigned long npages;
@@ -1069,6 +1072,181 @@ static int sev_snp_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return 0;
 }
 
+static int snp_page_reclaim(struct page *page, int rmppage_size)
+{
+	struct sev_data_snp_page_reclaim *data;
+	struct rmpupdate e = {};
+	int rc, error;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
+	if (!data)
+		return -ENOMEM;
+
+	data->paddr = __sme_page_pa(page) | rmppage_size;
+	rc = sev_snp_reclaim(data, &error);
+	if (rc)
+		goto e_free;
+
+	rc = rmptable_rmpupdate(page, &e);
+
+e_free:
+	kfree(data);
+
+	return rc;
+}
+
+static void snp_free_context_page(struct page *page)
+{
+	/* Reclaim the page before changing the attribute */
+	if (snp_page_reclaim(page, RMP_PG_SIZE_4K)) {
+		pr_info("SEV-SNP: failed to reclaim page, leaking it.\n");
+		return;
+	}
+
+	__free_page(page);
+}
+
+static struct page *snp_alloc_context_page(void)
+{
+	struct rmpupdate val = {};
+	struct page *page = NULL;
+	int rc;
+
+	page = alloc_page(GFP_KERNEL);
+	if (!page)
+		return NULL;
+
+	/* Transition the context page to the firmware state.*/
+	val.immutable = 1;
+	val.assigned = 1;
+	val.pagesize = RMP_PG_SIZE_4K;
+	rc = rmptable_rmpupdate(page, &val);
+	if (rc)
+		goto e_free;
+
+	return page;
+
+e_free:
+	__free_page(page);
+
+	return NULL;
+}
+
+static struct page *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct sev_data_snp_gctx_create *data;
+	struct page *context = NULL;
+	int rc;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
+	if (!data)
+		return NULL;
+
+	/* Allocate memory for context page */
+	context = snp_alloc_context_page();
+	if (!context)
+		goto e_free;
+
+	data->gctx_paddr = __sme_page_pa(context);
+	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_GCTX_CREATE, data, &argp->error);
+	if (rc) {
+		snp_free_context_page(context);
+		context = NULL;
+	}
+
+e_free:
+	kfree(data);
+
+	return context;
+}
+
+static int snp_bind_asid(struct kvm *kvm, int *error)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_activate *data;
+	int asid = sev_get_asid(kvm);
+	int ret, retry_count = 0;
+
+	data = kmalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
+	if (!data)
+		return -ENOMEM;
+
+	/* Activate ASID on the given context */
+	data->gctx_paddr = __sme_page_pa(sev->snp_context);
+	data->asid   = asid;
+again:
+	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_ACTIVATE, data, error);
+
+	/* Check if the DF_FLUSH is required, and try again */
+	if (ret && (*error == SEV_RET_DFFLUSH_REQUIRED) && (!retry_count)) {
+		/* Guard DEACTIVATE against WBINVD/DF_FLUSH used in ASID recycling */
+		down_read(&sev_deactivate_lock);
+		wbinvd_on_all_cpus();
+		ret = sev_guest_snp_df_flush(error);
+		up_read(&sev_deactivate_lock);
+
+		if (ret)
+			goto e_free;
+
+		/* only one retry */
+		retry_count = 1;
+
+		goto again;
+	}
+
+e_free:
+	kfree(data);
+
+	return ret;
+}
+
+static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_launch_start *start;
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
+	rc = -ENOMEM;
+	start = kzalloc(sizeof(*start), GFP_KERNEL_ACCOUNT);
+	if (!start)
+		goto e_free_context;
+
+	/* Issue the LAUNCH_START command */
+	start->gctx_paddr = __sme_page_pa(sev->snp_context);
+	start->policy = params.policy;
+	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_START, start, &argp->error);
+	if (rc)
+		goto e_free_context;
+
+	/* Bind ASID to this guest */
+	sev->fd = argp->sev_fd;
+	rc = snp_bind_asid(kvm, &argp->error);
+	if (rc)
+		goto e_free_context;
+
+	goto e_free_start;
+
+e_free_context:
+	snp_decommission_context(kvm);
+
+e_free_start:
+	kfree(start);
+
+	return rc;
+}
+
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -1122,6 +1300,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_SNP_INIT:
 		r = sev_snp_guest_init(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_LAUNCH_START:
+		r = snp_launch_start(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
@@ -1241,6 +1422,36 @@ int svm_unregister_enc_region(struct kvm *kvm,
 	return ret;
 }
 
+static int snp_decommission_context(struct kvm *kvm)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_decommission *data;
+	int ret;
+
+	/* If context is not created then do nothing */
+	if (!sev->snp_context)
+		return 0;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
+	if (!data)
+		return -ENOMEM;
+
+	data->gctx_paddr = __sme_page_pa(sev->snp_context);
+	ret = sev_guest_snp_decommission(data, NULL);
+	if (ret) {
+		pr_err("SEV-SNP: failed to decommission context, leaking the context page\n");
+		return ret;
+	}
+
+	/* free the context page now */
+	snp_free_context_page(sev->snp_context);
+	sev->snp_context = NULL;
+
+	kfree(data);
+
+	return 0;
+}
+
 void sev_vm_destroy(struct kvm *kvm)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
@@ -1273,7 +1484,15 @@ void sev_vm_destroy(struct kvm *kvm)
 
 	mutex_unlock(&kvm->lock);
 
-	sev_unbind_asid(kvm, sev->handle);
+	if (sev_snp_guest(kvm)) {
+		if (snp_decommission_context(kvm)) {
+			pr_err("SEV-SNP: failed to free guest context, leaking asid!\n");
+			return;
+		}
+	} else {
+		sev_unbind_asid(kvm, sev->handle);
+	}
+
 	sev_asid_free(sev->asid);
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 9d41735699c6..97efdca498ed 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -80,6 +80,7 @@ struct kvm_sev_info {
 	unsigned long pages_locked; /* Number of pages locked */
 	struct list_head regions_list;  /* List of registered regions */
 	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
+	struct page *snp_context;      /* SNP guest context page */
 };
 
 struct kvm_svm {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index e0e7dd71a863..84a242597d81 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1596,6 +1596,7 @@ enum sev_cmd_id {
 
 	/* SNP specific commands */
 	KVM_SEV_SNP_INIT,
+	KVM_SEV_SNP_LAUNCH_START,
 
 	KVM_SEV_NR_MAX,
 };
@@ -1648,6 +1649,13 @@ struct kvm_sev_dbg {
 	__u32 len;
 };
 
+struct kvm_sev_snp_launch_start {
+	__u64 policy;
+	__u64 ma_uaddr;
+	__u8 ma_en;
+	__u8 imi_en;
+};
+
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
 #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
-- 
2.17.1

