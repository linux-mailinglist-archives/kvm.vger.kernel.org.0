Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95A30398C32
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 16:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbhFBOP6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 10:15:58 -0400
Received: from mail-dm6nam10on2044.outbound.protection.outlook.com ([40.107.93.44]:27560
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231777AbhFBOOY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 10:14:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HMtY2njHM4urBzQ+5Ya7YDp/uYJmVPLkwjS6zHGgZrm19gGZU/ohDaWfZLl9TD2c4hlV0TtwEBMSS8V9EuN3jG4J2nmonE2+bDs9LzslEmDrcsnVpfuLfmUYdScHQUbPEW4NQqf7On7UyCxA4T7vHimCBgIrD8Vx1whY8WvNobUygt4vgmc3f/t58MBRHMkYTwTn+e0LoethgoLzeNZRgW7p+G3mb3eU+mBa07l7UznHKLaWGbDJ705ccAHOzLLRnfiP+Gv1Po5mRLzhUeR4ZWkR+Z6dXjX7qRa0zN/5Mwdq01TmSS5PVdAPJCImYeHNuKTrylqFnL2Rh1iDeshjew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VzLt/1RgVgPzPJ0od+Ix1HpNL7dG2JcRammV/qLXJzo=;
 b=T3LWlL3LTCso8LE+6SFAm9T2Cba/0ILF0hh3VM5K98FJK7QSVmGl4Qxwi1vbuVyeI9bxKXuE2cpAybz/x4TxZml144vWRx9bzXjLlTATFs16CWJSOADIsvdiIFgG/5Xjg+JymlHq4MonxcN2i5LcgoMo5YL3QemxZ7e5zY8lMXKukvPvrWBhgwTHDt7x3WGN09c9r3W01bqZOm7E/ToowRA19oqVy7wN3OJVxYX+22Obp6QI17+KzF00IjfDKUTw2fB8zsyItYOomUao3XQAdKr6XAeAmuJDutyvr4OpeQChmhalKcpdGwOzZvmIkBVvWAWAEogiFO3a9BDZD2aJJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VzLt/1RgVgPzPJ0od+Ix1HpNL7dG2JcRammV/qLXJzo=;
 b=yYvYy7vR9Hd39ijEqiy15OtjlvpPF5oewnpmNOeMympuiA0xvncpYO5zkNrFihNCGyd1MeVCSPz7VxK/Af5Mbg5DzHqEuCSDRIAP6+VoYS72dPRuSXfI+cU43bpsIAxmhIWsACzrWvCTSCn0ygM9TE26x0zbxvNgF7cwhSHQU9c=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4592.namprd12.prod.outlook.com (2603:10b6:806:9b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22; Wed, 2 Jun
 2021 14:11:58 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 14:11:58 +0000
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
Subject: [PATCH Part2 RFC v3 23/37] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_FINISH command
Date:   Wed,  2 Jun 2021 09:10:43 -0500
Message-Id: <20210602141057.27107-24-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0056.namprd11.prod.outlook.com (2603:10b6:806:d0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Wed, 2 Jun 2021 14:11:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0102e53c-3ac2-406c-a02d-08d925d0622a
X-MS-TrafficTypeDiagnostic: SA0PR12MB4592:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4592631861B1932AF66BB40BE53D9@SA0PR12MB4592.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xlajeET/HUnvhSEIptjzWU1t6epxzjA/pNomjk2Aj26s0JUxPaA52OHOG+e1xkgk9FY6tKglPaLuCWG6CNVBjq32lEWnFZNWVhZ1WZyGwxauTu3QRl9kKA1WKhbpSmRMOmH0guoNDz48f0jWvSlUn2NfdybYSnCERvBuy7kOYD7SEuLCrqKfTXq+zUOIhG113qp6+dMrtbzGtuDdutKSgAusC+7VpsH80GLew6+Lk+580pIG7XYr3dFRaS3sc0w2tLHx8PlA6a4W6brnFS1pz2kFTTBC2kslmAnW9fbYIqvxpKw/+aWDLCsxNqo0Jb9rtF0atNc/Tk9DLosUyasY/QrkvLIHIq28vMdx+hJXqRw1VQaPW+aQOpiOj+icXMSDbhbCXti77Ql021LU9sXbD70h13s8teSxf7gtKLQkXULS0ZiK2pTKeMl57X+DVol6etzOCnkgKc4PZQrC41I4WiGN29Fp7tRk0vBv0JaAR68yZ4NhZCh7To5tkLQe4uBVJarl1BJDbGZx3Q2YCPJBns3HJ4JfxrTRzJJJTc3+9HdEOQ6ZZi+ABmDQKesOiFXxkOP9WkiuMEc/sajomK/+jkNl3n3F7H38PTPtUh7R3hWd62cuLRXFBq8YpeBJd1h0Dh0sDD+8MgcDqN6hC8cthg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(956004)(8936002)(8676002)(36756003)(478600001)(54906003)(83380400001)(1076003)(44832011)(2616005)(6666004)(38350700002)(38100700002)(5660300002)(66476007)(66556008)(2906002)(66946007)(4326008)(26005)(86362001)(186003)(7696005)(52116002)(16526019)(6486002)(7416002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?L9tJ7Pzpvy3on8C0+c7M02CKDax2oKJxVx9bMwG/qPV2jVyFOr9ofYPJdIWp?=
 =?us-ascii?Q?/txYSAaT2CpIUEC67SnX6joqmEEpNirKMK+n+ro/uyv3WQFaGfjO9iT7xwTA?=
 =?us-ascii?Q?rftNVWDemLB38F8cwrhOYQI3tFUmGJXT+GP1/CEy1sW1UMxg5ufR1jyzXrjO?=
 =?us-ascii?Q?7xiXvcpubVdLS0JE0w0GGO5PERdHhqxL5b4NbfiiDlnqBDmBiyQHuerdZmUQ?=
 =?us-ascii?Q?C05bAf6vk2pyESHfQ2Pxcku5ZyPwtHOsg40iI2VOoXNe73TOJcHTyO0vsS7k?=
 =?us-ascii?Q?f39f/v5rd3U/ctt0DuITb+7hxvAOryCcg5z/GcTIcxOqfutlgaXdnOK/4eld?=
 =?us-ascii?Q?UYmSt8bAdpVN4xu6W3dSTyAdoVInZlg24PTTGcDQhi/CIWrbHfQDFvrDx81t?=
 =?us-ascii?Q?LNDrk4QgZwV6tiexiOiuv+XN90ss8fjF9ZuwCxMQQl7g7wN2HjMHF7BYD/6V?=
 =?us-ascii?Q?wWYvVl3i4MIu8yjboFZLlMgzPKafRwYIyYFlUqJEVld5jLLjXgtqdgEykQ51?=
 =?us-ascii?Q?XbvFFYyqME2MmfwbUXw2/TSji3B/pn8cDsvaI+rKxBwh96d4cP/Yc3mbdLQx?=
 =?us-ascii?Q?RNt7qtNtK15Scfmmo1TvkeHNuDwNqk+TXkFq1FZ8feNrYgtnKb0miib3wRij?=
 =?us-ascii?Q?k5LpKfNexdapB8eBxiiCxeK6eNhQWN/6QH4zMQ+fMSWM1slftTyiBRHY4KrH?=
 =?us-ascii?Q?h+Cmx8fL6MFP5TkEeffVDyO23rg1z87/JrlfNv4gX3eXYLN/nvqccLxxYJsR?=
 =?us-ascii?Q?UaToF6q/0DTRIYiIMDlE0jq6zwdrtUNjqcMrwfPUpOz1R0wPc7MD/Z0Go+q2?=
 =?us-ascii?Q?VwvOVyJpXk2EsTGG487fUow+zm1LRr5QjTgb0rjiHEiomsTt9CNqo/zH4yr6?=
 =?us-ascii?Q?jHxMQsVqxKJEwtPpAVm2t7jr1zcW5MYonftubX53hJUCoNz3ydBlNKnaXCTB?=
 =?us-ascii?Q?h3XaynyqEeKTnySopfF4slFSR2Iv0PFE/YJCZyib5z8MerW9qRwu91hm01bl?=
 =?us-ascii?Q?8/PSkHP7Axygp7FRwRyvhStm0NqZeGiBd8wNAU46NlerpaNX0N23UrRNdPcE?=
 =?us-ascii?Q?QO7dDEDgKUOfNzTPJrafhrrlQ6IM+KZucJLID89n6oqb12oMauM/nnmlobaD?=
 =?us-ascii?Q?etpnEtOtHpGlS5pV2utyiXZSltOxUTYPO+nIhHMAWZpDyW++JmvbPFaTI8U6?=
 =?us-ascii?Q?7JSupou9h1Ftq49bujK8XShiU4s+WBr0KBvbDoXrQfOYHoyRvjyZj1FcmW25?=
 =?us-ascii?Q?sfV1lmRERDKdjszeETKuyziMo9X9Zo90jil5DTqxgVA/VxHKo/cJpy5DUjXP?=
 =?us-ascii?Q?qrqtvJ3Y03d9opP5vZch7P2J?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0102e53c-3ac2-406c-a02d-08d925d0622a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 14:11:58.1850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4yEB/AEbpofqiO8pvlH/iQVYfkZNGDALyvy93QmboTOuwwGJb1+WooLKZrbCjWEG+qkAwN2pugfY7fFZNxGtyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4592
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
index 6b7c8287eada..856a6cf99a61 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1741,6 +1741,111 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
@@ -1836,6 +1941,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_SNP_LAUNCH_UPDATE:
 		r = snp_launch_update(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_LAUNCH_FINISH:
+		r = snp_launch_finish(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
@@ -2324,8 +2432,25 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
 
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
index 8890d5a340be..8db12055b8b9 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1682,6 +1682,7 @@ enum sev_cmd_id {
 	KVM_SEV_SNP_INIT = 255,
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

