Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD51360F8C
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 17:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234150AbhDOPzx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 11:55:53 -0400
Received: from mail-mw2nam12on2076.outbound.protection.outlook.com ([40.107.244.76]:35297
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232913AbhDOPzw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 11:55:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KJ5hUrANdMzAngqMGctkBJ6BvUjltc+9Kj+oSDyAeDTbEhRTWxU7XO8jUR1b0VR6G5/K41FIyynEULwsSUztPY177KSLltavteACeChIMXK5Mp9El6hlf5/aPrBRuK0MYf4qKV4Xa6YgkV5B4q9cI8CUp1WzOOs4UoxUzCBo/jL9VG+OAue9En4b3ZlsUgUYUP9J9f6r92pCDAWWNfOZiVvWprOIERq6eVQ0Vv76mBwDR6PMWPhgNtOPDaftl94RsC3eB67JdSGpTqeq+WJaZVWJXhD2dhdSJ96eih5LfEZywAsZ/Xw2Lg2RTR4/I5q/YdJcpptRRywWAbjhavuFFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wW+QIzgm47mqkBj6KHO+72rt7qHzdoxmlba2LXIzqI4=;
 b=VFQIjZv8stMf+uFgBFx1EAf9WJ9QYP+vibKT2nRVMj313acoKzTo/yrOjf5eGbcfu7+P+k3Hzqv2qT02hbcmXt37YIgVMOYr/gUJkxCoP5H9FxXt1shf31+NIkzKRS23vWKRbvkFhQzC+V5adJuK249jaX1/EcRQNiyoqmqNR+dE95pzU0ttnPYtaLrkWEzfjC3Xf0bF6RHpLEgtTaN7PhIdmKVUxapqvkL5gaIuIbNl7Kvfrvt8pak/6mYcw0pE0sIuqYOZehrcOZLrhrhfYG0iMwUSIjAoASs6AOd00ZHNaBJV/gn7FfwPsTCvPWLKFyhlPJCxwr9XAjRump/EqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wW+QIzgm47mqkBj6KHO+72rt7qHzdoxmlba2LXIzqI4=;
 b=h9JqXxr8LAxgTZE8GWP1ixgHxbi70gTDsdVSU5oyDvwzXBQAWVycT3LVQwhIXNOd/9U3Xg5lE4wruqTUdNOBmxzGf67w+bAcWu5MssFLQSjpMa+wkwmJJ2RlfvogA4rf5oTTz6ksWV9iPgeWMngQ1XMROF6mhbOWz8bsIABPAfU=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4592.namprd12.prod.outlook.com (2603:10b6:806:9b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Thu, 15 Apr
 2021 15:55:28 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%6]) with mapi id 15.20.4042.018; Thu, 15 Apr 2021
 15:55:28 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v13 05/12] KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command
Date:   Thu, 15 Apr 2021 15:55:17 +0000
Message-Id: <c5d0e3e719db7bb37ea85d79ed4db52e9da06257.1618498113.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1618498113.git.ashish.kalra@amd.com>
References: <cover.1618498113.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR12CA0015.namprd12.prod.outlook.com
 (2603:10b6:806:6f::20) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SA0PR12CA0015.namprd12.prod.outlook.com (2603:10b6:806:6f::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Thu, 15 Apr 2021 15:55:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb54e82b-548f-41bc-2f03-08d90026e3ac
X-MS-TrafficTypeDiagnostic: SA0PR12MB4592:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45924CCC38874734C5689D0B8E4D9@SA0PR12MB4592.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e5n0diah7fxcsljFicy0GrvQIoENZrmenfI/QM6cUYOyHujGPyg9pwrppo8kgTo8rzkUfKTRfElUuAoxfrqYB2zLlBLz5vlmH0HV3pm/IBcORBTWwOzlOty/N8yU4WU8aOsH4T9gSYLO/syTysnaQHdMT1pyOkAjIbjYMtIaFlDTOkFBKXwjPZa4ftopvdQdiGVS3wiFHqzxcNVUSVAe9gw8Y0Z4wMHb9eOfCgOE14jj7jNAXGS5u9LlTTicTZr4K7c/MNApXVFR5moz5I3++AMTYYDIGBl//SIaJbrg9DRE6Qf0OcqQIEMlvxjZpWF9uugqreVwXMAyrCIkYYhRrgDsh5vhhpkrrp5rQ0AyWalaw8JvGEBK+m4kFdpZKm82j9aOGt6X738AydFt8HyogGOigqNnhsBgRyRDW3Kl1UZCpj+v/IttRsDWt5Lcb93OGHEbgD8yY3k6l8xuchl45mfIDiMmlodKAbr61vQYgLwYOqTWBMBfFa7ZoBuXHro18OL2+Gfgy9EhCwS/SLmdXjAGxCDb28UAfvf/GhpQfCQQJWwCg2lwhPbLEiv4nPkKQbMuPPU/fpBP2ACAiVEcNl/wnPtoI/PwLg5YSXczIuE2XXjBC05+50wHxV6F8BGLMzK+0X1T/Zov8vHnCEACOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(366004)(136003)(346002)(39860400002)(5660300002)(186003)(26005)(956004)(66556008)(16526019)(4326008)(83380400001)(478600001)(6666004)(2616005)(6916009)(38350700002)(52116002)(86362001)(36756003)(7416002)(7696005)(8936002)(66476007)(8676002)(2906002)(66946007)(316002)(6486002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QzROZFJHU0htU1hlMFdhSFdMMHRaZHppdmVxd09mb1VicU40czlxWVRkbkUw?=
 =?utf-8?B?L0dZYTNKdU5wNWE2eXRBRXN2alNrOW8vVU9zNFJGMm5qNUdNK01jbTNpOUx2?=
 =?utf-8?B?WXRIbXdQVzBKZkRrZk5jTUJoL0RhVVdDVXJQK2NEVEY3S20yN3Z3cWRhbFBk?=
 =?utf-8?B?eWRaMWJmL0VFTFhSTzBNRitKQ004T0JWNlN3YWRXaUhVQk9leFRYTzk1T1E2?=
 =?utf-8?B?cGJxR1NZY3dEb2dtVlNFdnlaZlgrR2hJWDdzYU5zZlhyM3FhV1RNeERYbmI2?=
 =?utf-8?B?NmxKTXVIbFYrK2V3Q3QwQ09vcndFSko2S0MwUkQxVDZKTnJDWVlTb2VXSjQ5?=
 =?utf-8?B?RGtkbFZTUS9UVlNiMUd4ellsWXlrTmhUdytDRUUxVE9QNWJ1cXNNMU1SeVhW?=
 =?utf-8?B?Y21JcTJEeXhycDlManNzL1BNc09KRkVnK1M3cUIwUDNuV3hkYVZ1bEFrelp5?=
 =?utf-8?B?U0Z2TjZCU2dpbGZ1UmNVdTlyL01LQktvV3NjSkFLNzh5bXcxY09XVW1JV0th?=
 =?utf-8?B?bFlRQ1NqcXRzbGpiejdDZklPdGN5L0Y5ZWZNaVIxY2t0NThhS3ZlY3haRmp4?=
 =?utf-8?B?TGpSb0FDcHRUbWN3ZmNncUs4QmNmSnlyUnMxcXVtSC9Qb3EyUlYvNkppcHpD?=
 =?utf-8?B?NnNZUm5Rb3NDT0VrWVlLM25MVTVNRGhGeWx4bmJEQ0M1NlVadUE1ZmV3T0FE?=
 =?utf-8?B?a1ZvM2NTUGFoeUZjclh5a2xCbVdFSkZ3TXVjcmxqa1ZETi9Ocm1DVmpKa1dE?=
 =?utf-8?B?ZzNpVTNjRzc2aWZyZUVMTFJFUWV4ajVpTVJScjFCcjFsbHQxQ25zamMwaENS?=
 =?utf-8?B?bkZVcE9PQWNaTlpBa0tXMCtHdVlIZHB5L3k0dDhjN2FxT0xvazQ1S3BIaEJx?=
 =?utf-8?B?dU5NTkVXcU5mTHlUeU9JdGdmb3FOWXFWbTZuUTdSRXN1ak5OL2VpbFMvSWVH?=
 =?utf-8?B?RDRzUWpSUzZOZ0c1dE8ySWo2L1AyZnZDRXlQRXA5YXl2R3NHZlM2MHNQOS9h?=
 =?utf-8?B?V0RZMHlaQzRyODdleVhYM2ZqSWpqM3p4OGZkWUlHTlRKRFE4THFvYmVJVFhN?=
 =?utf-8?B?TmJ3eWhaa1BVaDJoVVpUWjZGYk5zRk5kcE9rdlkyR2Y5SkRwTFloSjFuL3dn?=
 =?utf-8?B?WjhuczlBY1BDNlB6cnc5Uzl4SE1NZ0Uza2FHekFMZ2R3TEFxZHFMQVpFM1lu?=
 =?utf-8?B?amJ6TVliRnBSQVZJc0kyZWJDS05WYmxjZzU0NnZUajFKVUdCa3o2S2ZpRmNp?=
 =?utf-8?B?ZWdOUTFES0oxeUM4M01xcVk5U0s5R3ZDU1F2TEtEUkpnRGdqSm4zUGgybDJm?=
 =?utf-8?B?b05zY3BNWFJ1L0U2ZTdOVTR0aHFXcUFiOWxQeThmTXVrTGg4V0doR251eFZW?=
 =?utf-8?B?dFBKT0ZXTEF1U25GYlh6bEZPZmtCbmZxQlBqT29VemlncElRN3hyZmVjYTJF?=
 =?utf-8?B?TERHNC9SK3VsWkk1Z3d1MDZjY3l2QjdrdURhY1gzUit6Ym5IcklLNERZS29C?=
 =?utf-8?B?ck14NkRGQTNDKzE5TWN2aGZORG1DT2dsM1NpNGg4cWdQV1gwY3gvaitYMGwx?=
 =?utf-8?B?STRLbmYxcUc4MmNqaTNjanFvc3pYeUlTdEU1ZXpndDZkeEFKdndva1NVOXJW?=
 =?utf-8?B?TG9SUk9rTU1Pd09zbjkxSW8wZzRWODdTTWpTSTlRay9WSklDU2JSa2lyTGJE?=
 =?utf-8?B?M0dqaGpSWk9NWEptUzU1eEIzVUhlcGdtOVB2Z2JLQVZqQlZDTTlWb0EwdFlp?=
 =?utf-8?Q?iWDt7ym+34bAPTOHyYCzQjEwdfHk83Bo2IYT+7S?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb54e82b-548f-41bc-2f03-08d90026e3ac
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2021 15:55:27.9474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Rgnxx/KYQGCxUudYk0okNIWaYMAVlSjR4L7/yKtTA/NdImmLVCuVvPvrJcQOHEqiOkVEzZie3bJY5sXoLqJhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4592
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

The command is used for copying the incoming buffer into the
SEV guest memory space.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Steve Rutherford <srutherford@google.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 .../virt/kvm/amd-memory-encryption.rst        | 24 ++++++
 arch/x86/kvm/svm/sev.c                        | 79 +++++++++++++++++++
 include/uapi/linux/kvm.h                      |  9 +++
 3 files changed, 112 insertions(+)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index c86c1ded8dd8..c6ed5b26d841 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -372,6 +372,30 @@ On success, the 'handle' field contains a new handle and on error, a negative va
 
 For more details, see SEV spec Section 6.12.
 
+14. KVM_SEV_RECEIVE_UPDATE_DATA
+----------------------------
+
+The KVM_SEV_RECEIVE_UPDATE_DATA command can be used by the hypervisor to copy
+the incoming buffers into the guest memory region with encryption context
+created during the KVM_SEV_RECEIVE_START.
+
+Parameters (in): struct kvm_sev_receive_update_data
+
+Returns: 0 on success, -negative on error
+
+::
+
+        struct kvm_sev_launch_receive_update_data {
+                __u64 hdr_uaddr;        /* userspace address containing the packet header */
+                __u32 hdr_len;
+
+                __u64 guest_uaddr;      /* the destination guest memory region */
+                __u32 guest_len;
+
+                __u64 trans_uaddr;      /* the incoming buffer memory region  */
+                __u32 trans_len;
+        };
+
 References
 ==========
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e530c2b34b5e..2c95657cc9bf 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1448,6 +1448,82 @@ static int sev_receive_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct kvm_sev_receive_update_data params;
+	struct sev_data_receive_update_data *data;
+	void *hdr = NULL, *trans = NULL;
+	struct page **guest_page;
+	unsigned long n;
+	int ret, offset;
+
+	if (!sev_guest(kvm))
+		return -EINVAL;
+
+	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
+			sizeof(struct kvm_sev_receive_update_data)))
+		return -EFAULT;
+
+	if (!params.hdr_uaddr || !params.hdr_len ||
+	    !params.guest_uaddr || !params.guest_len ||
+	    !params.trans_uaddr || !params.trans_len)
+		return -EINVAL;
+
+	/* Check if we are crossing the page boundary */
+	offset = params.guest_uaddr & (PAGE_SIZE - 1);
+	if ((params.guest_len + offset > PAGE_SIZE))
+		return -EINVAL;
+
+	hdr = psp_copy_user_blob(params.hdr_uaddr, params.hdr_len);
+	if (IS_ERR(hdr))
+		return PTR_ERR(hdr);
+
+	trans = psp_copy_user_blob(params.trans_uaddr, params.trans_len);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto e_free_hdr;
+	}
+
+	ret = -ENOMEM;
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		goto e_free_trans;
+
+	data->hdr_address = __psp_pa(hdr);
+	data->hdr_len = params.hdr_len;
+	data->trans_address = __psp_pa(trans);
+	data->trans_len = params.trans_len;
+
+	/* Pin guest memory */
+	ret = -EFAULT;
+	guest_page = sev_pin_memory(kvm, params.guest_uaddr & PAGE_MASK,
+				    PAGE_SIZE, &n, 0);
+	if (!guest_page)
+		goto e_free;
+
+	/* The RECEIVE_UPDATE_DATA command requires C-bit to be always set. */
+	data->guest_address = (page_to_pfn(guest_page[0]) << PAGE_SHIFT) +
+				offset;
+	data->guest_address |= sev_me_mask;
+	data->guest_len = params.guest_len;
+	data->handle = sev->handle;
+
+	ret = sev_issue_cmd(kvm, SEV_CMD_RECEIVE_UPDATE_DATA, data,
+				&argp->error);
+
+	sev_unpin_memory(kvm, guest_page, n);
+
+e_free:
+	kfree(data);
+e_free_trans:
+	kfree(trans);
+e_free_hdr:
+	kfree(hdr);
+
+	return ret;
+}
+
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -1513,6 +1589,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_RECEIVE_START:
 		r = sev_receive_start(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_RECEIVE_UPDATE_DATA:
+		r = sev_receive_update_data(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 29c25e641a0c..3a656d43fc6c 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1759,6 +1759,15 @@ struct kvm_sev_receive_start {
 	__u32 session_len;
 };
 
+struct kvm_sev_receive_update_data {
+	__u64 hdr_uaddr;
+	__u32 hdr_len;
+	__u64 guest_uaddr;
+	__u32 guest_len;
+	__u64 trans_uaddr;
+	__u32 trans_len;
+};
+
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
 #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
-- 
2.17.1

