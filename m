Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 155F136FA86
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbhD3MkS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:40:18 -0400
Received: from mail-co1nam11on2082.outbound.protection.outlook.com ([40.107.220.82]:56928
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232529AbhD3MkC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:40:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VXKCyFBwzjWK3F26A6O1SXA69i3b4A946F3vwee4X5NZDqDzrZaunVx7gOKZz5RogFYqrlM4xYPJJkF3buLyHeM8Zg/6HDl9KMhKABGitqxU9D+ioQbhf1uXRn34LyWTQn50+uymuCOhaMGTt89M0Ev/iL9lhZTyJ6ALl+4dDFtb0S2uyefIagbT4TNSrLHyXQkcwYqDD4DIvx0DuOWgIuQNSu22rFHAwxL21YE0ovTbtzsAjGZzVwxBxbBv+avbaZkKyoOpsZMT0b3ue0vJ1IIZVXw2fgj1cjhM0Z4wu6E++Ztb2NlIlDbPm6z7cvPPoRQYTwqMTnomfwOIkdLV3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w/nBt5GAj6xuog3fGhsnBODL187PjubD3Ke4LT5LX84=;
 b=axlE2iWdjzjDATTOUxC6bSAdEmen80Ws5DiUI4F2KGCbKGUsS4dhloEHwnSHQEfk2CkYrw3/cqTgYRHcypWpdNUzVrxolnLAAqykm9dqwJs/SKEm2S/Ocq1czOBM7HQU7rSmTNnOhqsYAAR9QsN9Blpay6eJFnvHrYMgcyo9fTKkBbeiva9rPCcZNO9721QF+HatK8DMR2mqv7BGjIYBbNNgus+LJ9qR2cDFGyrUt0NJIafJWIDf1mvQlYTaLnsYKUk/a/M5Y2nX4ZC2x7zxdGMLtlZ5yvqASqA+jP5j7BJxeFMZunCCZ1QTKiM92gNmIYkCZgNeLLiSM/lgpaYd7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w/nBt5GAj6xuog3fGhsnBODL187PjubD3Ke4LT5LX84=;
 b=V80173IPoFCKQttRghVsk5Qp7wf+dLmeg+QfQDEjvuokbviUKXOOA0xA/NP5PinqTQKlc4qZAMbi+D0vLz5nlPa32i2C+cdcbECcI0OYonB01yonmfEGYKoBAigxHiff/OizszT5V+ccRUKC1xFQtE7FtKTey19JK4k2qqgTVzs=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2688.namprd12.prod.outlook.com (2603:10b6:805:6f::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.35; Fri, 30 Apr
 2021 12:39:12 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:39:12 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v2 25/37] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_FINISH command
Date:   Fri, 30 Apr 2021 07:38:10 -0500
Message-Id: <20210430123822.13825-26-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0501CA0089.namprd05.prod.outlook.com (2603:10b6:803:22::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 12:39:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4cd1d19d-ea5b-404b-126d-08d90bd4f4fd
X-MS-TrafficTypeDiagnostic: SN6PR12MB2688:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB268888EDADDFA9F99724B933E55E9@SN6PR12MB2688.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xX3aIWNHQw9qvhojz5JGztvWQWMhakEpv/KLxIZI+PVcfhKYcOvl6g32rqogEQOPV2m+iCuTLTZcwqFKHqWHG3wuH4c3IzwUh/wHBHcSC7ZGhxz3F1+fQ4e8BN7RlUIYLmWQZ4dES2izzj69tiPnTe/9yl7AkJVq026XiXkh79pM29tfAW2hv09R8iPeVFFF3x1plB//b4V6ALspsJayAamORdrXW2V58RbV1MdHhQa6ATbebVirzF8NUsOog2iEmpWmPDgQ8HtcAgDr58g46h1vQMuWJrG8TtX7dlMTcacaz87D48ziYps8bUmKRZQ+rddSIQJ4v8s8ZYjL0ly4fYp+t7TMscl1S2NO0dljz7TDUORbn2MS51ZblmS60NYCGNzgshQf4THoTpdvDBKvKdwIbdE7FImoHtWINW2ezxha7UYyvv+jIcm4YiYPi4oQ3yXUDyXxISF0EnwxRDB29NKaI2y0bfh9hDDmihjVb9YUtwHJr7emmm+1MrBFg/qnjWBo7D0fcvFVjg8GUYn2IWzfr6l7IAmMPcLRIzHJfkAQ2tPgszNu7Z8dmDPiKxh76G0D5PetyPVOTpYxKc4MVXjkLlDH67VQRzazavwgSBKTD9O3trTdQ374ULy4ozzWqPNpccUkWGKWr6wxz5nR5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(136003)(396003)(346002)(26005)(8936002)(86362001)(478600001)(52116002)(8676002)(1076003)(66946007)(66556008)(2906002)(7696005)(83380400001)(36756003)(66476007)(44832011)(5660300002)(956004)(38350700002)(38100700002)(7416002)(2616005)(16526019)(186003)(316002)(6486002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Sx0JbA+uWysLgc1BWUtUT36QlWOcXpISdS/wdOW/Fz5p3ijzZToENlwzRI8Z?=
 =?us-ascii?Q?/1mCCavBnVyAW8rco43PxQDHry4we4MSVkpBTFaMPTCg3DNbJT/1OvJ9uPpW?=
 =?us-ascii?Q?tdFwW1KUCbKa8XzCzs1MeMY+rsoYZsSoBHlCN+Or7SowBuCMRKHzQKAVtvpn?=
 =?us-ascii?Q?xsdHMiLlVsQkaUZtnFdYAHsCQHBn1zfATUA639it/+E+p/8z3V6PdQNCQQye?=
 =?us-ascii?Q?oHm8d2KC0LDZlRXc0pKYFt2TfrRW2MQnhHcmt7Xj8V7qVE7W+CPX3cS/sbTj?=
 =?us-ascii?Q?4xStCwLZ0k9M93oRFPSRdluV7QbhiHx+AbSqrwlTpg9HxKtjNgG6LXB4KDox?=
 =?us-ascii?Q?3LFGAM9UnXdMNEJL78PIa8yks3/t6iZDlon3FtZ3B3lJWYMKv9dVy3QA5an9?=
 =?us-ascii?Q?wNr8JuL8+BXzecn9ajj0Ggf8bk7PZt3oMbAAcA4MP7YE6r4GNkLkErrRPVWb?=
 =?us-ascii?Q?shs0Bete4PxtM4r6LPAjlvBE4k9XyxIVgXp7ohNppNAbqd5aaYcRuLpQvBLr?=
 =?us-ascii?Q?Vo3a9sfStlTtkxIqCQHDkAEu8GrJPpQwbEHukA2Ck58npbggRLrcm0w8dC25?=
 =?us-ascii?Q?iatFa9tF1/BxdaUV2pizDlDVzjjr4Bde+nmZgCNnR3N6rgTHagX5Z2fsbxvo?=
 =?us-ascii?Q?BCQlVO+6/ZE83rPoV89xtLRUDBUyMG1zaWKLwYXXr2TvilYXM1OnDjuKat1O?=
 =?us-ascii?Q?0IEivkRKuHLffmFc/Tj6wImjjLcmK+9ri4cw4NEsMgcse8eXej+t3zw0S4cc?=
 =?us-ascii?Q?/IaMiZs3TNysGebUApWhN0+Wj+2YDwBh2NE971D9lpe9/OCBkWWK2WKilnLu?=
 =?us-ascii?Q?2VwUajeygqELmGbRwho6YRNyDabjjn0n5xtoYQcoexN1Le4n0mu5htWKlOcz?=
 =?us-ascii?Q?FNMZpRt+QiL6FCqg0fpST0o0RwyTqA2AURGkymExOnHJ+1aP4OGYN75TFdIE?=
 =?us-ascii?Q?BQ+F3AezD+5O2OIi/1LfW0rpdEh5J24FwriZp+qL5WeT/noc9RzPp20Z5GiR?=
 =?us-ascii?Q?1kN3Rcg13cRKFJV9+n07f8tpkai9mj97oOh+lYncb+Byh5XtbB4ZlYlGIejp?=
 =?us-ascii?Q?d3W6fQpL/IS5Cn/puEnyJ9I5YkAw2CKtRtxgFBvK3C3MPiTxzfteyfAl+3ba?=
 =?us-ascii?Q?ZecBS0OJBnXhv1FyDDm7xaKPFQT8tc42JciOvUkZ+Ya0cgx8v0Tm94gVR+Nk?=
 =?us-ascii?Q?ykrY4QWG4QKMcFXa6n/9wkphHLhwK6ZTYZOSJjiF1DRgUHNf+yruauJld+cj?=
 =?us-ascii?Q?lBvByALFcdBRm+yYe/xJXn+2ahRbmh7WtJgNlAn48Oz1IHrui/pb9ci3nB94?=
 =?us-ascii?Q?3DfX3F7wUFoiotvO6SWKyRll?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cd1d19d-ea5b-404b-126d-08d90bd4f4fd
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:39:12.2473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hO5ED2e5ri+0lcPQfuZUCTp1VCtVwHDSkXD/TCfusTQEOwWReweFn9iXRPVGxSQaAIvUHlPqV5rLbP4fRGfsFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2688
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM_SEV_SNP_LAUNCH_FINISH finalize the cryptographic digest and stores
it as the measurement of the guest at launch.

While finalizing the launch flow, it also issues the LAUNCH_UPDATE command
to encrypt the VMSA pages.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/svm/sev.c   | 125 +++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h |  13 ++++
 2 files changed, 138 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 4ce91c2583a3..7da24b3600c4 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1743,6 +1743,111 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_launch_update data = {};
+	int i, ret;
+
+	data.gctx_paddr = __psp_pa(sev->snp_context);
+	data.page_type = SNP_PAGE_TYPE_VMSA;
+
+	for (i = 0; i < kvm->created_vcpus; i++) {
+		struct vcpu_svm *svm = to_svm(kvm->vcpus[i]);
+		struct rmpupdate e = {};
+
+		/* Perform some pre-encryption checks against the VMSA */
+		ret = sev_es_sync_vmsa(svm);
+		if (ret)
+			return ret;
+
+		/* Transition the VMSA page to a firmware state. */
+		e.assigned = 1;
+		e.immutable = 1;
+		e.asid = sev->asid;
+		e.gpa = -1;
+		e.pagesize = RMP_PG_SIZE_4K;
+		ret = rmpupdate(virt_to_page(svm->vmsa), &e);
+		if (ret)
+			return ret;
+
+		/* Issue the SNP command to encrypt the VMSA */
+		data.address = __sme_pa(svm->vmsa);
+		ret = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE,
+				      &data, &argp->error);
+		if (ret) {
+			snp_page_reclaim(virt_to_page(svm->vmsa), RMP_PG_SIZE_4K);
+			return ret;
+		}
+
+		svm->vcpu.arch.guest_state_protected = true;
+	}
+
+	return 0;
+}
+
+static int snp_launch_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_launch_finish *data;
+	void *id_block = NULL, *id_auth = NULL;
+	struct kvm_sev_snp_launch_finish params;
+	int ret;
+
+	if (!sev_snp_guest(kvm))
+		return -ENOTTY;
+
+	if (!sev->snp_context)
+		return -EINVAL;
+
+	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
+		return -EFAULT;
+
+	/* Measure all vCPUs using LAUNCH_UPDATE before we finalize the launch flow. */
+	ret = snp_launch_update_vmsa(kvm, argp);
+	if (ret)
+		return ret;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
+	if (!data)
+		return -ENOMEM;
+
+	if (params.id_block_en) {
+		id_block = psp_copy_user_blob(params.id_block_uaddr, KVM_SEV_SNP_ID_BLOCK_SIZE);
+		if (IS_ERR(id_block)) {
+			ret = PTR_ERR(id_block);
+			goto e_free;
+		}
+
+		data->id_block_en = 1;
+		data->id_block_paddr = __sme_pa(id_block);
+	}
+
+	if (params.auth_key_en) {
+		id_auth = psp_copy_user_blob(params.id_auth_uaddr, KVM_SEV_SNP_ID_AUTH_SIZE);
+		if (IS_ERR(id_auth)) {
+			ret = PTR_ERR(id_auth);
+			goto e_free_id_block;
+		}
+
+		data->auth_key_en = 1;
+		data->id_auth_paddr = __sme_pa(id_auth);
+	}
+
+	data->gctx_paddr = __psp_pa(sev->snp_context);
+	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_LAUNCH_FINISH, data, &argp->error);
+
+	kfree(id_auth);
+
+e_free_id_block:
+	kfree(id_block);
+
+e_free:
+	kfree(data);
+
+	return ret;
+}
+
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -1838,6 +1943,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_SNP_LAUNCH_UPDATE:
 		r = snp_launch_update(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_LAUNCH_FINISH:
+		r = snp_launch_finish(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
@@ -2325,8 +2433,25 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
 
 	if (vcpu->arch.guest_state_protected)
 		sev_flush_guest_memory(svm, svm->vmsa, PAGE_SIZE);
+
+	/*
+	 * If its an SNP guest, then VMSA was added in the RMP entry as a guest owned page.
+	 * Transition the page to hyperivosr state before releasing it back to the system.
+	 */
+	if (sev_snp_guest(vcpu->kvm)) {
+		struct rmpupdate e = {};
+		int rc;
+
+		rc = rmpupdate(virt_to_page(svm->vmsa), &e);
+		if (rc) {
+			pr_err("Failed to release SNP guest VMSA page (rc %d), leaking it\n", rc);
+			goto skip_vmsa_free;
+		}
+	}
+
 	__free_page(virt_to_page(svm->vmsa));
 
+skip_vmsa_free:
 	if (svm->ghcb_sa_free)
 		kfree(svm->ghcb_sa);
 }
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index dfc4975820d6..33f8919afac2 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1682,6 +1682,7 @@ enum sev_cmd_id {
 	KVM_SEV_SNP_INIT,
 	KVM_SEV_SNP_LAUNCH_START,
 	KVM_SEV_SNP_LAUNCH_UPDATE,
+	KVM_SEV_SNP_LAUNCH_FINISH,
 
 	KVM_SEV_NR_MAX,
 };
@@ -1693,6 +1694,18 @@ struct kvm_sev_cmd {
 	__u32 sev_fd;
 };
 
+#define KVM_SEV_SNP_ID_BLOCK_SIZE	96
+#define KVM_SEV_SNP_ID_AUTH_SIZE	4096
+#define KVM_SEV_SNP_FINISH_DATA_SIZE	32
+
+struct kvm_sev_snp_launch_finish {
+	__u64 id_block_uaddr;
+	__u64 id_auth_uaddr;
+	__u8 id_block_en;
+	__u8 auth_key_en;
+	__u8 host_data[KVM_SEV_SNP_FINISH_DATA_SIZE];
+};
+
 struct kvm_sev_launch_start {
 	__u32 handle;
 	__u32 policy;
-- 
2.17.1

