Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 664F73F30F2
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbhHTQFi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:05:38 -0400
Received: from mail-co1nam11on2073.outbound.protection.outlook.com ([40.107.220.73]:9218
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236193AbhHTQDg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:03:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ibd2WDtCRT+pfBCk0XCtpTW81JXyCSfdLfuxPaU5/ootYRkdj4yGfbEl3nRBc9AMs7nmfsKidoo440FSDBVbs28dDmlfyTEIGzgo9tC390b27Tuyne8OYccyFq1ULtSU2mAlem1HBkXXZtXZQC3j+m0bq2tlmR2XpnQyfz551fsMZ94vUAEd7DtxclTSCgRgvYGL/NFfNGeKXWEm75bHFqVqWC2gjmEQtrCf4NQNBKM/xAsgPFJ1AiOZYq/ggsKFNFdzOe8CjIGGETXSUcRFaXDT+L190pyh1w9puoMVErKfWz1KebW1XQcwq1z0cmWnwlF6Jo7/FzAxJeU4cM+viA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S1kExqUKrSBpmRMqIbVKR/f0u79+2cblIBKLs+KKFWs=;
 b=eU6gm817DPJqb/uBCCxr4NuygDD+MdMs0sOoaCuJSN4Pm76fJj2sICEMGCxZFN93gkM3tO8dT2neZnDVJxYEUWzug6CIhUmqVrVvAhJ5JJ2L6EtkflsfOo6TugSBkrd4xcAv0vBHJrVWZiWz/aMyATh4ujEkBArlpSkq5pTNiq+liadAgSgK+G2tQzlQPAHtvJunItjczn3GnZVh8d4hDTwpDB0ghxSAVP5tk7BKxp4YyG8jdM/bwD+swBgS1w7Q3T+yM7RsVKma8ej8FsRxXG5xC3+Q2hqmwYPQ9LSOejw1QKPkgcmPxIxBYdJ22fhCIeAnNPyntLnl1g20tM7syA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S1kExqUKrSBpmRMqIbVKR/f0u79+2cblIBKLs+KKFWs=;
 b=3xrKVqIoHptjdd6ooTFsRWN3izP3gFyVMYz1OkuckoUDhOxHJKeqciEDWhanpwYemPrHIyqe6L9yAgaujfq/zLwegQAQC2BvcyHr8dx5qaFpAGfxdNk3SY6Y0Uxyyuxt36xCWq2pGJhbLXP6CnjpISzbCyoeyChcSsuO64bNknU=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2685.namprd12.prod.outlook.com (2603:10b6:805:67::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.21; Fri, 20 Aug
 2021 16:00:29 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 16:00:29 +0000
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
Subject: [PATCH Part2 v5 27/45] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_FINISH command
Date:   Fri, 20 Aug 2021 10:59:00 -0500
Message-Id: <20210820155918.7518-28-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 16:00:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b0e8582-e614-4873-a3a4-08d963f3a162
X-MS-TrafficTypeDiagnostic: SN6PR12MB2685:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB26852AF7A38350FD9C6ACF3CE5C19@SN6PR12MB2685.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SD1UmCO5HHk0PW88odzlT2bdDqmodqHG9p6ecXxxvtxwdHmQ3KyPt0Hp1FjTk1eMVxVDFBK7l5lPh8AHTKQqyPlomLCQ0/heDfBg9zEU4Up53mxdNx8jV11t7dth08cWhdPfYeiSTZEuYo7SlKjQgIjOZjWKNAwCRZ2+b8X7uWi2A24mnD9Pi4+hBp6WdT2sQbQfjAZSyEZdXPMNtHWIfK7BmqucFF2GkLBcGHizSkX1s5//Lj26DH9yHoYb7R0pA5BSRraOBGCM31GazcKzrMCVBw7jieszpXz0/5yP93PQ4gsMVRRgumVYAMEpABJot+jWdojBlFkAsMRDVJbVXAAz6UhoCSvvUpasiJ5KP3aOXLx7flRayAs8yTsCTPlSP4vfKw5DZVXpwwEFnK4HFHATM04m0pNYTxmGZPuixL7nt8TKNWX/V3JE5g4bgGnx//CY10igUbYhqe0oiZos3jtGIHq0nHf3P64EAcS+bbkZp1uShzMi9UgQt/3X3yeJ8AEf0p1tPb/FmahHrJ/LQhqS+20Rs4UjV1NjYiCLjOADnMRj8TDwPtxb1Xluk1tNt2amRmMzU5pkuGqP5N3HIWSqgAhPM+OsGFI4ft0yBq85hEBBT/v+0ftBEh01OPu0pIhTQW0RinJeJwP2FRkWofuCFxOhD7SyDe2dCFghC1ExPkMdVMI6BfZSsOdukmJs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(376002)(346002)(366004)(956004)(186003)(44832011)(2616005)(26005)(83380400001)(66946007)(52116002)(66556008)(66476007)(7696005)(7406005)(6666004)(7416002)(1076003)(2906002)(478600001)(36756003)(316002)(54906003)(8676002)(8936002)(5660300002)(6486002)(38350700002)(4326008)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fopCZQghCp/c0lUhyI2NXxEQhM6z+bWiWgsuND83dvsY1F9/D8XiFtk2tL2m?=
 =?us-ascii?Q?R9PVU6kF3kZHLscrTubwv3XH/cwhxkvasL8jvrksCKFeXjAHw5NNNSphunpJ?=
 =?us-ascii?Q?zd0EGuGTvDZL0A31C7bipfMy8+UzeBFKc2C8RkEqKxk/JTFLOTTDlXlFlIW0?=
 =?us-ascii?Q?KZJwY3epYlKJxsqYv7DnfbRXblGzsN0Bxle4FiMvc+85unNVNSYzoiIV9yqK?=
 =?us-ascii?Q?IZDPRa6pVutAy9VoZ8m1Rlfl1KFu2mWRE0fsP2iyF1S8IW+SC1uGsijr8qyA?=
 =?us-ascii?Q?B7g2Dj4c8r25GxMulDtPt0RcT3Jq56D7ZO5QFlTf/YvmtmyHrNBXv/kTOh3s?=
 =?us-ascii?Q?xCEVTfSl7heRQI+PTtE1iwKEDD2LR6zdNL9c6PB2GjKjAiARzrWiRxNPKEG+?=
 =?us-ascii?Q?ZToa8jdpoZ2rKKKrHkJIYAWnTg78bo9vNQFg9YWVLr0aWkV4ACE+qWDuGhY7?=
 =?us-ascii?Q?Svdku88FtVyzJh9BhYwPqzfqTp0IyZU4J46oW0xVGOzZ1Fol6lsFlSzhPl+F?=
 =?us-ascii?Q?DzYsXOSCXB6himPKltk793Zs/C/dpH18rtjkv0g5GOeUaMwysruU7UmR/I8n?=
 =?us-ascii?Q?h99Uyg+v9ld2XF1uuxBoIas+I0d3gRs1Wvyo/vHB5P1+WjVB9TEgJf0ZMhoW?=
 =?us-ascii?Q?Owr24KAW0joglzo6z5Q03QrHSI7XPgAQh66mubeFNfvRQf4mtlYrqNFtb5Yp?=
 =?us-ascii?Q?FB7SoPKkdGaKYrmOuiW2QaIoLlV+vzirweeD5+qQ+gz8NQ85BwdxNutCrgek?=
 =?us-ascii?Q?OtuK3jZDkHRAcKJMn48QLhQMzZeJohxsMOXYzFW7wYdxhydDMgf3g8fMrgAM?=
 =?us-ascii?Q?1Y6fsbyf4vJvzXGlmNmjmpDsFX58LQW8RHhB+RJAOH25YPLMGFnxRw1KeMca?=
 =?us-ascii?Q?MaG3k4TGG5zgB+xQE2rl82Ubx/SnQXZggQIhY1P5ZzF2brz2SKIQqXuqSo/f?=
 =?us-ascii?Q?HCZ9LZJTBejVnjJHlBpabSjVys8RWmlbNxEv5yJsA36AhZv5WnzTxDCdEslv?=
 =?us-ascii?Q?9I2pP7mnC5Mai7QOc9Ouuh8eZU8U1EmRjvX2TJ35HmYOoUO3Na2HaQXOO6+g?=
 =?us-ascii?Q?P/LUy5Tbs09EgluTaJNYt5sAu3mmaXcGOEY4cz8cSHcHXA8yMqw0pCFVnaxO?=
 =?us-ascii?Q?Pj6OinyKKvB9SUuF3mUIS59GlokUh8LDYFH3zq0AVj/Cbr4H4U0Z0yhu7ri7?=
 =?us-ascii?Q?Rdbmzv5uiY1OB87nGRc7XTUiesk2Tezn+OKLv59jyGtZ04Pk4G93nhS2NpC1?=
 =?us-ascii?Q?RCE2f4g1ZMFTvYpuJ9i0O1RgPaBEMMZRmAYOucTM9kqwOwyOYJM+YPUNgXsN?=
 =?us-ascii?Q?s9b8znPXm3dU9otHLoDSRjwg?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b0e8582-e614-4873-a3a4-08d963f3a162
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 16:00:28.7613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4aygKcmDRNQOjsbvf164n05L0Z24LSvo2HQMNjq3ogRizTc+xRpNCRAz3TczKmCuAAwLAWzvTY7/Gytops2ruw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2685
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM_SEV_SNP_LAUNCH_FINISH finalize the cryptographic digest and stores
it as the measurement of the guest at launch.

While finalizing the launch flow, it also issues the LAUNCH_UPDATE command
to encrypt the VMSA pages.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 .../virt/kvm/amd-memory-encryption.rst        |  22 ++++
 arch/x86/kvm/svm/sev.c                        | 116 ++++++++++++++++++
 include/uapi/linux/kvm.h                      |  14 +++
 3 files changed, 152 insertions(+)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index ddcd94e9ffed..c7332e0e0baa 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -506,6 +506,28 @@ Returns: 0 on success, -negative on error
 See the SEV-SNP spec for further details on how to build the VMPL permission
 mask and page type.
 
+21. KVM_SNP_LAUNCH_FINISH
+-------------------------
+
+After completion of the SNP guest launch flow, the KVM_SNP_LAUNCH_FINISH command can be
+issued to make the guest ready for the execution.
+
+Parameters (in): struct kvm_sev_snp_launch_finish
+
+Returns: 0 on success, -negative on error
+
+::
+
+        struct kvm_sev_snp_launch_finish {
+                __u64 id_block_uaddr;
+                __u64 id_auth_uaddr;
+                __u8 id_block_en;
+                __u8 auth_key_en;
+                __u8 host_data[32];
+        };
+
+
+See SEV-SNP specification for further details on launch finish input parameters.
 
 References
 ==========
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index dcef0ae5f8e4..248096a5c307 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1813,6 +1813,106 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
+		u64 pfn = __pa(svm->vmsa) >> PAGE_SHIFT;
+
+		/* Perform some pre-encryption checks against the VMSA */
+		ret = sev_es_sync_vmsa(svm);
+		if (ret)
+			return ret;
+
+		/* Transition the VMSA page to a firmware state. */
+		ret = rmp_make_private(pfn, -1, PG_LEVEL_4K, sev->asid, true);
+		if (ret)
+			return ret;
+
+		/* Issue the SNP command to encrypt the VMSA */
+		data.address = __sme_pa(svm->vmsa);
+		ret = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE,
+				      &data, &argp->error);
+		if (ret) {
+			snp_page_reclaim(pfn);
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
@@ -1908,6 +2008,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_SNP_LAUNCH_UPDATE:
 		r = snp_launch_update(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_LAUNCH_FINISH:
+		r = snp_launch_finish(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
@@ -2364,16 +2467,29 @@ static void sev_flush_guest_memory(struct vcpu_svm *svm, void *va,
 void sev_free_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm;
+	u64 pfn;
 
 	if (!sev_es_guest(vcpu->kvm))
 		return;
 
 	svm = to_svm(vcpu);
+	pfn = __pa(svm->vmsa) >> PAGE_SHIFT;
 
 	if (vcpu->arch.guest_state_protected)
 		sev_flush_guest_memory(svm, svm->vmsa, PAGE_SIZE);
+
+	/*
+	 * If its an SNP guest, then VMSA was added in the RMP entry as
+	 * a guest owned page. Transition the page to hyperivosr state
+	 * before releasing it back to the system.
+	 */
+	if (sev_snp_guest(vcpu->kvm) &&
+	    host_rmp_make_shared(pfn, PG_LEVEL_4K, false))
+		goto skip_vmsa_free;
+
 	__free_page(virt_to_page(svm->vmsa));
 
+skip_vmsa_free:
 	if (svm->ghcb_sa_free)
 		kfree(svm->ghcb_sa);
 }
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 0681be4bdfdf..ab9b1c82b0ee 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1716,6 +1716,7 @@ enum sev_cmd_id {
 	KVM_SEV_SNP_INIT,
 	KVM_SEV_SNP_LAUNCH_START,
 	KVM_SEV_SNP_LAUNCH_UPDATE,
+	KVM_SEV_SNP_LAUNCH_FINISH,
 
 	KVM_SEV_NR_MAX,
 };
@@ -1850,6 +1851,19 @@ struct kvm_sev_snp_launch_update {
 	__u8 vmpl1_perms;
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
+	__u8 pad[6];
+};
+
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
 #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
-- 
2.17.1

