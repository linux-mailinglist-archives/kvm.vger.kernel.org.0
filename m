Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F13BA360F79
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 17:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233914AbhDOPyc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 11:54:32 -0400
Received: from mail-bn7nam10on2073.outbound.protection.outlook.com ([40.107.92.73]:60993
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231726AbhDOPyb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 11:54:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A74J/l9TJJBHU9/zIoBWUu5HI3GTHQrLRioLlO6aEzx7aDdfLkjMmE+9yz0t5qNG3CSYslFdfxVrcAWENhHR7omJ3wtFgtNaAECsIE1cy1eNU/gqlako8/U5gMcvbCls+vjyEGlH472IARdQRjpJtiWZTI4UbUFacvLfbRT5zwf+2MRN7joxmMkW2Ji53CVMxTndVH/kleXCn9w/42nc5P7zf/pXxxG6DW38rWKfVwhuT7enGIzJ0ry4p8/usuNW+9J765XyyiFbBSdJDMSGF0O/tZAvyclT1VK9PgMxw+Vdxd+ME2YYGm01Oj7HjJOYQRVFv4+E2MeQmAVNVbkkwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TmptNcWrK0Wse7VDXUmUvzb21xGh5dE1N4aXqer08gc=;
 b=iXyVBzhOkAcoP5LNGlzQXy4XlcGK6wU2AFt5Ukv6rUdJEt1Ufcp0cvYvGx4JoWOfvDLRQtvltoYdHWUxCxb6fSeRmQqcrbbWhtIJlkrvmmCDI2THM2q7WWjdxbksYKXm6wKoDYM6czzPimlg3GRn2ozXgQCeTsLeuTrnvcAT47OX5JUsjDqGbu7mOWYFmvdf3M2iOh3q523F+H0uscwBX99gWlg+6prTd7F98ba5l2k5C22+j3pYCKq0bruc3njUNrm66F1GDXCGu1RM+X+UtwaUfX9Gp7/Go3w4nTCLVohvOD2Pyb9SHJyf7cibVL1toNcuRfmqP/r4ui3w8lYkMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TmptNcWrK0Wse7VDXUmUvzb21xGh5dE1N4aXqer08gc=;
 b=hkI1q+I6w4mQ77SEdAT9ZgY3UWRnDbgiF6vJK+Ne9K85MVWMT4yAs9Uk3ujC7Xwa3VTgZ3rPNire3gSHpN1TER8XJnOToyPUe4+ofqnI5LyQlXBMq9+gAYyQMNQxMXYZTTylgih+37B6Oy2PXK1+j04GlrzAz/5QPj1WCfNNKDE=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Thu, 15 Apr
 2021 15:54:06 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%6]) with mapi id 15.20.4042.018; Thu, 15 Apr 2021
 15:54:06 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v13 02/12] KVM: SVM: Add KVM_SEND_UPDATE_DATA command
Date:   Thu, 15 Apr 2021 15:53:55 +0000
Message-Id: <d6a6ea740b0c668b30905ae31eac5ad7da048bb3.1618498113.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1618498113.git.ashish.kalra@amd.com>
References: <cover.1618498113.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0066.namprd11.prod.outlook.com
 (2603:10b6:806:d2::11) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SA0PR11CA0066.namprd11.prod.outlook.com (2603:10b6:806:d2::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Thu, 15 Apr 2021 15:54:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee5759df-fa0f-452c-95f0-08d90026b32b
X-MS-TrafficTypeDiagnostic: SA0PR12MB4384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4384B9C85E9A97744897D4B88E4D9@SA0PR12MB4384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uIeyPmAxjzCHW6Z61RNCCiP6cEVrzTPDWNLCWwaymb1I1LXdZMMusx4Y0Gf8pMoQp39+wKLNJlBqjbQ5dDGc8y8PDeHbPqqYqA4XCmh9VqlR99zKsbKdtfEk1RMRVg9zUy1XKITUWsRqje3IjX3rmVCfVNlCnQs+nIboRUC3JijjTXc8jrBl8FHVXY/fZLd+Hxw4fiuSG6WoNz8MTE2oCy7Wjbmx4CMu5tKKuZacVzPn7SYFXJw6BrUCUJQ03dzFoiujg8JticixkyPAaI9/NkGti8SijpgMsOpvMGwtfktdSM9ie6lhX+VY/uUkMSbRxUwS61wUFXHldRb9T6Womh13kFVTkU2Hq9xzeqiX4YNcnbduRi0qWVyFG4V+eQYMdEZeWuHksuvb6kta/aFa3dmmfHHyXgFFmFPajpjqnZOXUgUVaKupAnJkdXkwbFOxQg304bKN6uWtpnE1Zjby0J4pbfNi8vITjuVMcK5a8x2RtRW0J/HTZkxdtLwwhKLEta9f4bkCk1jyRW1OB6bHxfsS61Kknqg/NvqBmzBrifc02hDZd2SFsJGSzby+eC2rPzul+kwSW4/plPsubaACle5Qsb7VkrKBdz28Hh0Yzwl8w2tZJIP4D7emAEho9o2oBluAVuftmshoPB40nu65Uw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(376002)(39860400002)(366004)(2906002)(4326008)(83380400001)(6666004)(316002)(38350700002)(2616005)(38100700002)(36756003)(8676002)(956004)(8936002)(26005)(16526019)(7696005)(66946007)(186003)(66476007)(66556008)(478600001)(5660300002)(7416002)(52116002)(6486002)(86362001)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SGU3czgxN25xVUE5QnI4bkszUUN4RFIwV09RendtaXpLLzV2bXhrQkJFSGlM?=
 =?utf-8?B?Rk5xWE9rNXZ0bzhZSHdQclBUR3JYS0tPM3cxM2hvU3FqZFdBbDlSeUFSZ2tq?=
 =?utf-8?B?aCtiQ2ViQWpxWVlVTENvVWxTZkhPUHUxdldYUjE4ZzdVNlNueFR5bWllL0ND?=
 =?utf-8?B?TmJjK1NIbGJEYzkyeGlPZFVkN2ZBZ0dPbWtUcCtRQVBhejJpTkJwZHFuV3Ix?=
 =?utf-8?B?Yzdqd21pQ2tMcGp0NW5FMk5sNkpiLzVRK1VoOFlRZWlDaEtiK3VWZXNFMU8r?=
 =?utf-8?B?Q1M2eHl3UHRmZzNRQUJBVCtabTVpVGtWZTZna0IxQ3kyZ01ISDhTdmp0UDM2?=
 =?utf-8?B?alNmTVRleVIwSm93UDY0bmYySTBWcjkrS2d3NXdVZHV2OHgyVitNVkl5ckpM?=
 =?utf-8?B?ODBPcFc3QWhYdG9Pam5GWHE3dUhHclc4c05LdUhWcitlSEVqMmp0Q3EzOE9o?=
 =?utf-8?B?OTI1c3hXTU01TW5IaHQwRjg1ejZmYWFKVVpGTWxaZnBpNHZrK3VwVmdlUFlk?=
 =?utf-8?B?M09UdWlxRzYvNGh0aGJIc3B3VWZ5Z3BsalRncFNhdlYySXFhL3JBMm1WMHZj?=
 =?utf-8?B?eVJYdXpvekkyMnhranhyNUxmL2pFYlFzaXBORlFmc1RPK0g3OTdQREdWZ1R2?=
 =?utf-8?B?eXpDK3ZZNkEzWHpSMVRkZndYRGJOZzhLSk9NWTRGdFE1L2MxSk5Od0Z0QWQw?=
 =?utf-8?B?b1dEeHJnbWx0U2srZjljS21NVGZZNjFoUk5NenprMEdvTnNvT1FoeW02Zm9R?=
 =?utf-8?B?QTZSdzBNM2Z4V3dTUTE5ZlpqbG1xeXZiSUhoM0lFUVJaS3BDZFI1NDNoT3dQ?=
 =?utf-8?B?b1ZYVTIxcjdrOXNjZlBqY3JFR0wxQ1drUGlsSnc3eWpUajQ4TkxOa1NaMGVm?=
 =?utf-8?B?MHFqZHR3ZmtrbXB6bEhNVVNXTEdHdkwvd3dYTENGRGpNSnRLQUQvUU93WXBE?=
 =?utf-8?B?eHZjNUxrTzlPSDRKcnZzVEhuM2JneFNhOHB3TGQ3OVF4TzNTYk5oS3N0dUJm?=
 =?utf-8?B?NFFlckoxT0xqb3hRN3A5ZWowekI4cEttKytwU2JSMkI2MTlzMWNGYVdlWWdj?=
 =?utf-8?B?TmlhS2JVUjRVNnNDM1BqeDJLRXJ1QmMzUEpoWXVMWXkrbUoxWUxBZWJyRTQ1?=
 =?utf-8?B?UkxkT1VmZVBYbUxZSllneVhBR1hBSDRLL2NYaDFZS3hXbW9FVmFMcHFidkU0?=
 =?utf-8?B?WTlBSXpDM0ZnZW5OVGkzWE5palh0bkhjcTVod0YrbVVGcnBtL2VDc3VlVlhk?=
 =?utf-8?B?eTJQUzdSb1NodG1JRUZ1c2VQZTZUSjIvRW9nQkFRWkE4YzlQVGNpL1RDbmpG?=
 =?utf-8?B?a3RGY3lKQXk3SkVQNlQ5Uno5UmxiUXRiRXlINWc3cUtuZzk2OElKaHZ6WlRO?=
 =?utf-8?B?R0doYkVzNUUrZURhdzVEaDFYMVRibTBJUHJyQmRoSVplRlFadjZTMFM2QjNn?=
 =?utf-8?B?aDVCWE9WSjVsSkRVQ0Y2dm5DVnY3L0VoSDUzQ3RFd2ZiYnA5ZHNlNzMrY3BR?=
 =?utf-8?B?VEtKUG80Y29UL3BZWGdRaHg4ZUg4S2RtR3ZXbXNBaURNc1FlaXFmZ1hqT1Rw?=
 =?utf-8?B?VkFWL0p0OVAxc1hSUkN0TmJrYkFueG9TNisvaTlHclMwZHJERVR1S2VNR2xD?=
 =?utf-8?B?U2RKcE03a0pDUy81WTd3L3BCdUFpOWRvZy9Kc0pVQmtVWllrRFF0UE5VNTBL?=
 =?utf-8?B?cTd0T1AxWWs4VmZwWkdCWXQyN1htd1VOcWdhdGtKayt5TjZiNlVUUVR0eHBB?=
 =?utf-8?Q?uR71DF5/BNA6GDLcth+nBpnofQz1rvAFVGAEFMp?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee5759df-fa0f-452c-95f0-08d90026b32b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2021 15:54:06.6479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k8BQlZl7CCBEpny5O/a+A99SReWE4O9S/tisSR25txggIlqlaLrFVZTvpZEprTPkIDHgVTdUHEMLWYoSpAG79w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

The command is used for encrypting the guest memory region using the encryption
context created with KVM_SEV_SEND_START.

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
Reviewed-by : Steve Rutherford <srutherford@google.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 .../virt/kvm/amd-memory-encryption.rst        |  24 ++++
 arch/x86/kvm/svm/sev.c                        | 122 ++++++++++++++++++
 include/uapi/linux/kvm.h                      |   9 ++
 3 files changed, 155 insertions(+)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index ac799dd7a618..3c5456e0268a 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -311,6 +311,30 @@ Returns: 0 on success, -negative on error
                 __u32 session_len;
         };
 
+11. KVM_SEV_SEND_UPDATE_DATA
+----------------------------
+
+The KVM_SEV_SEND_UPDATE_DATA command can be used by the hypervisor to encrypt the
+outgoing guest memory region with the encryption context creating using
+KVM_SEV_SEND_START.
+
+Parameters (in): struct kvm_sev_send_update_data
+
+Returns: 0 on success, -negative on error
+
+::
+
+        struct kvm_sev_launch_send_update_data {
+                __u64 hdr_uaddr;        /* userspace address containing the packet header */
+                __u32 hdr_len;
+
+                __u64 guest_uaddr;      /* the source memory region to be encrypted */
+                __u32 guest_len;
+
+                __u64 trans_uaddr;      /* the destition memory region  */
+                __u32 trans_len;
+        };
+
 References
 ==========
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2b65900c05d6..30527285a39a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -34,6 +34,7 @@ static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
 unsigned int max_sev_asid;
 static unsigned int min_sev_asid;
+static unsigned long sev_me_mask;
 static unsigned long *sev_asid_bitmap;
 static unsigned long *sev_reclaim_asid_bitmap;
 
@@ -1232,6 +1233,123 @@ static int sev_send_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+/* Userspace wants to query either header or trans length. */
+static int
+__sev_send_update_data_query_lengths(struct kvm *kvm, struct kvm_sev_cmd *argp,
+				     struct kvm_sev_send_update_data *params)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_send_update_data *data;
+	int ret;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
+	if (!data)
+		return -ENOMEM;
+
+	data->handle = sev->handle;
+	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_UPDATE_DATA, data, &argp->error);
+
+	params->hdr_len = data->hdr_len;
+	params->trans_len = data->trans_len;
+
+	if (copy_to_user((void __user *)(uintptr_t)argp->data, params,
+			 sizeof(struct kvm_sev_send_update_data)))
+		ret = -EFAULT;
+
+	kfree(data);
+	return ret;
+}
+
+static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_send_update_data *data;
+	struct kvm_sev_send_update_data params;
+	void *hdr, *trans_data;
+	struct page **guest_page;
+	unsigned long n;
+	int ret, offset;
+
+	if (!sev_guest(kvm))
+		return -ENOTTY;
+
+	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
+			sizeof(struct kvm_sev_send_update_data)))
+		return -EFAULT;
+
+	/* userspace wants to query either header or trans length */
+	if (!params.trans_len || !params.hdr_len)
+		return __sev_send_update_data_query_lengths(kvm, argp, &params);
+
+	if (!params.trans_uaddr || !params.guest_uaddr ||
+	    !params.guest_len || !params.hdr_uaddr)
+		return -EINVAL;
+
+	/* Check if we are crossing the page boundary */
+	offset = params.guest_uaddr & (PAGE_SIZE - 1);
+	if ((params.guest_len + offset > PAGE_SIZE))
+		return -EINVAL;
+
+	/* Pin guest memory */
+	guest_page = sev_pin_memory(kvm, params.guest_uaddr & PAGE_MASK,
+				    PAGE_SIZE, &n, 0);
+	if (!guest_page)
+		return -EFAULT;
+
+	/* allocate memory for header and transport buffer */
+	ret = -ENOMEM;
+	hdr = kmalloc(params.hdr_len, GFP_KERNEL_ACCOUNT);
+	if (!hdr)
+		goto e_unpin;
+
+	trans_data = kmalloc(params.trans_len, GFP_KERNEL_ACCOUNT);
+	if (!trans_data)
+		goto e_free_hdr;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		goto e_free_trans_data;
+
+	data->hdr_address = __psp_pa(hdr);
+	data->hdr_len = params.hdr_len;
+	data->trans_address = __psp_pa(trans_data);
+	data->trans_len = params.trans_len;
+
+	/* The SEND_UPDATE_DATA command requires C-bit to be always set. */
+	data->guest_address = (page_to_pfn(guest_page[0]) << PAGE_SHIFT) +
+				offset;
+	data->guest_address |= sev_me_mask;
+	data->guest_len = params.guest_len;
+	data->handle = sev->handle;
+
+	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_UPDATE_DATA, data, &argp->error);
+
+	if (ret)
+		goto e_free;
+
+	/* copy transport buffer to user space */
+	if (copy_to_user((void __user *)(uintptr_t)params.trans_uaddr,
+			 trans_data, params.trans_len)) {
+		ret = -EFAULT;
+		goto e_free;
+	}
+
+	/* Copy packet header to userspace. */
+	ret = copy_to_user((void __user *)(uintptr_t)params.hdr_uaddr, hdr,
+				params.hdr_len);
+
+e_free:
+	kfree(data);
+e_free_trans_data:
+	kfree(trans_data);
+e_free_hdr:
+	kfree(hdr);
+e_unpin:
+	sev_unpin_memory(kvm, guest_page, n);
+
+	return ret;
+}
+
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -1288,6 +1406,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_SEND_START:
 		r = sev_send_start(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SEND_UPDATE_DATA:
+		r = sev_send_update_data(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
@@ -1467,6 +1588,7 @@ void __init sev_hardware_setup(void)
 
 	/* Minimum ASID value that should be used for SEV guest */
 	min_sev_asid = edx;
+	sev_me_mask = 1UL << (ebx & 0x3f);
 
 	/* Initialize SEV ASID bitmaps */
 	sev_asid_bitmap = bitmap_zalloc(max_sev_asid, GFP_KERNEL);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index ac53ad2e7271..d45af34c31be 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1741,6 +1741,15 @@ struct kvm_sev_send_start {
 	__u32 session_len;
 };
 
+struct kvm_sev_send_update_data {
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

