Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC449347EBC
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 18:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237265AbhCXRF5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 13:05:57 -0400
Received: from mail-dm6nam11on2071.outbound.protection.outlook.com ([40.107.223.71]:41848
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237058AbhCXRFK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 13:05:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ApgQqQjiXqtq2KH2NsrMPb0Van8VjHDIXs/UdzDLt+SKann+0fHYGtblLGMkUS5oOWKhg/hsvXzQS7H1XDLi5H1Pdie/KaDpPKpuB4b3Th8vu9XroGqoN8gwR0oiMpRBn3DEWWGUZJ4EPJMUguryfI8Ua6tDRy2uUib997XDg/o2W58ReZZenpceOrZpZpGTzqMp6uEV0N5QWl3plgjnajEQLjUsGR7wOF1eVSDPavjlWnKJTka8yhbl8SNjLN9Mv1SFD/rdOgmqt/x0DHXNBvl2w6HS5GtqcEx6QQMWGAOmlJBoaf8MTZPu9+7cVP+ND1mdEwDyKOACj/yf8mDeMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BzeLaLh96fzHoIyvXZk9oX9ydYKh+Bq12f0ALF6LMmI=;
 b=gTpTrSuyZshpxFaAXU/vMMBjMqOx545XNvSFzPY3Q+7vm4ABBkneik1Xv7AVWITmLeiHe4mo8XtJmqRAnL87WgUBCuE0JcJsMPbX2oXlLVnwBdcnpivILTUu6H9PNqYf0TypXK+8adIOnhpf4/FLcF1tMGrx67hqGrJNdYQiwEIU5yBopzWsqFxruFHLCfrn0MRbI1BgDnvs7Xa7yACfyTmRr2L5hidxEbfwHdD5AmVyu2RT2lsnRGI8qLqxUtW6iEb3+kz7ULidQu2JTDR5IaVq0nVpDnnI8VDaZXqtk2ugDWl7JB53UF8nbNmsfeZDdVi588qlw1vIAL+DzX10pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BzeLaLh96fzHoIyvXZk9oX9ydYKh+Bq12f0ALF6LMmI=;
 b=vpxhy3EP1DUgHn3OdyPEBtgZ9KPVTGHrvY99qE3J+wrOvkDVC3AC2Kse/tNKH+Jhvkt7ZOCSOVc4bFB0gHkA8k55WCC7t1b2wcbDKOc3L9fcO07Cesz3jax40D11rkmO9HliUZXz2D6m5kPZOH37guw43CyS9bMZP/AOFpWsLcc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4382.namprd12.prod.outlook.com (2603:10b6:806:9a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Wed, 24 Mar
 2021 17:05:08 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 17:05:08 +0000
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
Subject: [RFC Part2 PATCH 20/30] KVM: SVM: add KVM_SEV_SNP_LAUNCH_FINISH command
Date:   Wed, 24 Mar 2021 12:04:26 -0500
Message-Id: <20210324170436.31843-21-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0210.namprd11.prod.outlook.com (2603:10b6:806:1bc::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Wed, 24 Mar 2021 17:05:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 32c7e980-d75b-4ea9-166a-08d8eee6f9bc
X-MS-TrafficTypeDiagnostic: SA0PR12MB4382:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB43828339D043AE476514EE1FE5639@SA0PR12MB4382.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zUq8TSipb7vYNPp4lLQW/SyB7s/pFjsDK05PIfdSyMo48w4dToRtwHLRYuPVXfhOBwccbmQLsSi37q2R/fM8V7uZAxIf7ajisDht1aN4w4pcUiYP/iKhhXIgRt385GN1mHsDB5LcF3krsJwUXzIERP60A3+FOCu4qgoQMoup55OFbRnnJLxjahrhaVQI9otnO70XbG8lxL12LleMc6vU3WDAQ+GqSz2WL+pp7MR0QhaIGfXfT6BB0cYCHrAQdZYUs/F95QXewJi9L7LXf2pTy8ctSYkcxKxYskCND4PtHXnPWqyfgz5uSqIY7xRHsU+m3oBEON463XFKZdpy+9Q4qYtd6X9yl3AunW6pdHm4cpHeI2DgBfjUNFnSFEBQO7Xz8B3paM/ZB1FvgN+55+YLRtfQ73JhOWMaQ+DyJwmJiUtOa5aWkZm68Axx0P+8Tc4wMV4QXsjNqCn1XnrmQbEAcpgolY5fjHCcku4qoK1vqWERq07wb5eEhZXjFb3OwXQNXqeotB1MCm3SBeuBdcNsCsv6LgEq588Ebfg0DoXY/WlZjKXQs1G70+X/cSqm1H6MWWrbFvZ82bHzFmf/l2gJs6SXct/Fiwng8tFoMUBOcD6QpETSk+eHSvsj4oQI313wiaNDtEbCKI70XPxGYra2Vw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(346002)(366004)(39860400002)(6666004)(44832011)(66946007)(1076003)(66556008)(66476007)(956004)(36756003)(478600001)(2616005)(83380400001)(8676002)(2906002)(8936002)(26005)(86362001)(5660300002)(52116002)(7696005)(38100700001)(4326008)(54906003)(7416002)(16526019)(6486002)(316002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?x/PSyxNkc3B+EdMsnaAMw8iNyISd7fXav+0oX4sgF0K9dYfGM+dvhhgUXEMj?=
 =?us-ascii?Q?xRLjwde9+RBGdrQpiIu+DMotyDBMKvqErHshiTBMFZFwID4jIdKoNUp9jYpJ?=
 =?us-ascii?Q?JRwkyJAQq8UVOw+z3/g585eoBopiQtmDYiNs6T60hDeXQaNXMfUdFdzu7BLR?=
 =?us-ascii?Q?t7LDx7G/lUaQUjWT6mgCL4+ps1uPYV/TnhjSez3Q/wjUD7siJjGl10/h+6gY?=
 =?us-ascii?Q?4IAzu8JYH4NSgOlGuWPZIkyVJXxITh++E1W9EF3imNuWVDLtMSfZ+INUcKVf?=
 =?us-ascii?Q?U49NvJqCqQHQB9wVigHvUW3P+z0xKvYHKfZWA9FKkQcH62oaUrzh6Pm4zuxU?=
 =?us-ascii?Q?r1Wma3uh6/RmQxoaq8QXLCPMkV3H/lyWH1cmoA7juvbH6xg+0OqbpNCcmVJv?=
 =?us-ascii?Q?kmHWZssSaIy2Pyl/Iisq4EuJK7C4KvzkXUuUdyGrEqIVYVbUDUk3DmtvxQzv?=
 =?us-ascii?Q?GGTdrApHX8teW3pBbD7lJO8k2iIx+6Gf78TuyS7nmHmzgQpXhVDX42Tmmyk7?=
 =?us-ascii?Q?7hnjEjbRYhOSC/dBE4j21k78PlegUmW0FEsBeof5mIAvFzQJVWJdvloypTZY?=
 =?us-ascii?Q?V7+DAqqWwZLEvN5B3+zj7mIsthDmYUrCM+49hEwP21f4JU5cGqZjxvU1T8+l?=
 =?us-ascii?Q?zlBtyifFDyyHcGmUqi9Fhm04Trgl+IS2CY/sx2vWMIxSmHRwccq9P4Xafs/U?=
 =?us-ascii?Q?/FJLhBNmn9OwwBJ6JtarX/X0d6zwQhYlPS10wxKmAyIvWiuIrOSDUpz+iwb0?=
 =?us-ascii?Q?4Ogjnqrp71Tvffyn0lbZ//hBOsZ0zfroFrSlHIyXB0hNrZs4Y6QzLtPiU9q6?=
 =?us-ascii?Q?kr90yj2imEV9lD1V9C5d1tBUWBB41JRPVYlGVoXjqQKPzu4BqdGzoNtAkkOX?=
 =?us-ascii?Q?ZB/katwRkjzUGWtfjwYkZNC8uXW1jftBnOlc66zaXh/4k4kRdCPbJ9cfNGQ9?=
 =?us-ascii?Q?KJnJbtqTswM4vo1fguwqrQVA2qE6v5cDAhxt3Mi6fqlw7cfGtgSafpU5QzR3?=
 =?us-ascii?Q?vH1u4Sd7O1hGhl35ERxvTj6Njoo8ooNXpizms0lq+3Di1cbB4lBQexMw0w5r?=
 =?us-ascii?Q?YZ8rJuMBUTdGeIFMngHRbIQdQGS+Ih5wHuJU+Th6G00Fgp/OPD9ElwC3nW2d?=
 =?us-ascii?Q?/qoAWi9MMIiWJgODnwbBr3lqSmub/X7XGvMOtWgMSAbFrAqt32mBPbdd0wdj?=
 =?us-ascii?Q?aybO8obI0CBbPcBs9gmjVp6z/ob70S82DgNBXwjpp4sUN7g1w9UXCFQMLQOY?=
 =?us-ascii?Q?YPfTbhjSFf7CnABsnElt2ha83WqQoOmlY19voduRa9CbnI189e13WKr+iLbG?=
 =?us-ascii?Q?yjSCRIMHuGAZ+et9sCj7vKvU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32c7e980-d75b-4ea9-166a-08d8eee6f9bc
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 17:05:07.4646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jkEuQuPKKeRUrQsbbVvDCcqMCakG2ogUZMKKEeEAgIupjFMsdH3r5yjEkArnUaAAmd3YyAHNB/OjJ0Ii4lKpkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4382
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM_SEV_SNP_LAUNCH_FINISH finalize the cryptographic digest and stores
it as the measurement of the guest at launch.

While finalizing the launch flow, it also issues the LAUNCH_UPDATE command
to encrypt the VMSA pages.

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
 arch/x86/kvm/svm/sev.c   | 131 +++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h |  13 ++++
 2 files changed, 144 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 4037430b8d56..810fd2b8a9ff 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1380,6 +1380,117 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_launch_update *data;
+	int i, ret;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
+	if (!data)
+		return -ENOMEM;
+
+	data->gctx_paddr = __sme_page_pa(sev->snp_context);
+	data->page_type = SNP_PAGE_TYPE_VMSA;
+
+	for (i = 0; i < kvm->created_vcpus; i++) {
+		struct vcpu_svm *svm = to_svm(kvm->vcpus[i]);
+		struct rmpupdate e = {};
+
+		/* Perform some pre-encryption checks against the VMSA */
+		ret = sev_es_sync_vmsa(svm);
+		if (ret)
+			goto e_free;
+
+		/* Transition the VMSA page to a firmware state. */
+		e.assigned = 1;
+		e.immutable = 1;
+		e.asid = sev->asid;
+		e.gpa = -1;
+		e.pagesize = RMP_PG_SIZE_4K;
+		ret = rmptable_rmpupdate(virt_to_page(svm->vmsa), &e);
+		if (ret)
+			goto e_free;
+
+		/* Issue the SNP command to encrypt the VMSA */
+		data->address = __sme_pa(svm->vmsa);
+		ret = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE, data, &argp->error);
+		if (ret) {
+			snp_page_reclaim(virt_to_page(svm->vmsa), RMP_PG_SIZE_4K);
+			goto e_free;
+		}
+
+		svm->vcpu.arch.guest_state_protected = true;
+	}
+
+e_free:
+	kfree(data);
+
+	return ret;
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
+	data->gctx_paddr = __sme_page_pa(sev->snp_context);
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
@@ -1439,6 +1550,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_SNP_LAUNCH_UPDATE:
 		r = snp_launch_update(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_LAUNCH_FINISH:
+		r = snp_launch_finish(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
@@ -1820,6 +1934,23 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
 
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
+		rc = rmptable_rmpupdate(virt_to_page(svm->vmsa), &e);
+		if (rc) {
+			pr_err("SEV-SNP: failed to clear RMP entry error %d, leaking the page\n",
+				rc);
+			return;
+		}
+	}
+
 	__free_page(virt_to_page(svm->vmsa));
 
 	if (svm->ghcb_sa_free)
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index a9f7aa9e412d..bfd5340e153d 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1598,6 +1598,7 @@ enum sev_cmd_id {
 	KVM_SEV_SNP_INIT,
 	KVM_SEV_SNP_LAUNCH_START,
 	KVM_SEV_SNP_LAUNCH_UPDATE,
+	KVM_SEV_SNP_LAUNCH_FINISH,
 
 	KVM_SEV_NR_MAX,
 };
@@ -1609,6 +1610,18 @@ struct kvm_sev_cmd {
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

