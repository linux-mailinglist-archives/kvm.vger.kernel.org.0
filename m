Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC3D30E8AA
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 01:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234222AbhBDAjR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 19:39:17 -0500
Received: from mail-dm6nam12on2045.outbound.protection.outlook.com ([40.107.243.45]:57185
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234165AbhBDAjG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 19:39:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nLa/eWtaGirLBGRG4Z2RCqkR8oyXjcQH+Crd/+EiVKN+6GuJyyY/AYY3LZJl6th1zPjNvw+jZxy480YwtqQvCrWWiu0LrzLQim6Ihk6zuhPv8WwQLu5LErIAE3pggR2SDqgU7ZXEY1dj31niroOR65HF1Xaz8Nd9GVXsg7TRYed5U5a9X8cuS6WYJFMh95wSHQShrW33+W/VATqNkXWCvH2+Phfi/agrKS1z4FUrNtpDZ6XJhqgXAFSLrCn2ZQXzb4gsQr+aaNzWrzGjatre2RQgvSEaHgIKKzoEiRmcQtE7UKqYNgH7t6psNjse1XfPY/9wwQd9eZLqHsgzTOHsLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ej6g0rTXxZK5k/hjH4z8jfgZfT1471iiPfThY3ovefM=;
 b=ezvn/5U5/3yNeQzRj5nDNAyfpRhGFkSsTFc9ZEK+afoSteJ4TzMWZPx8MhQ5mJUwuG4EhV4bQirr2AS044CHgaklCuP05D3iFS0erUrxcQ7T274s9EJ8Hp4nVaZeIY5YN+mNxyFdo5TNa342f8I3XikOHeMUQel3yCEhRJc+/M29e5HiRV4uL36Vp+SHYOts7Vb9ItFspPkq6lkCzsX8Vge8fT7/nrb1fKjmLNwTwcp85SpNYYmQ1DndurrECVJRjyYBYNg9Uu8o7LpvvJNAF/C0GWt1t/3YlU6j0VF2IeGClwY9+tupJrufxQ8LU9RIWfoqrV+l5ekLKVbiNJjE8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ej6g0rTXxZK5k/hjH4z8jfgZfT1471iiPfThY3ovefM=;
 b=Gu5lC8Kqm2T9rfH4IKvtOKybKil7zNDwby6qcOi5NIZNQFzMAIE/pqS6AlC6ErUvNhHf3ugBZQzQFGjgUA+oyCQzwNV02YMyQl9z3Q+YXcwLreNV4nLTyqmwNp3w8rGOI4OlILj2eHb1/ypA59fAqqiXI6cLuaYoUTzYaLnt4Ek=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Thu, 4 Feb
 2021 00:37:53 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3805.028; Thu, 4 Feb 2021
 00:37:53 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        seanjc@google.com, venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v10 05/16] KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command
Date:   Thu,  4 Feb 2021 00:37:45 +0000
Message-Id: <5e7cf05c927f379de358a6d9df12885558adf7e1.1612398155.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1612398155.git.ashish.kalra@amd.com>
References: <cover.1612398155.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN7PR04CA0067.namprd04.prod.outlook.com
 (2603:10b6:806:121::12) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN7PR04CA0067.namprd04.prod.outlook.com (2603:10b6:806:121::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Thu, 4 Feb 2021 00:37:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dda980fb-ff6c-4a8d-8ad8-08d8c8a51bea
X-MS-TrafficTypeDiagnostic: SA0PR12MB4384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4384A112DC00AA7AA55060178EB39@SA0PR12MB4384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3ior7J2YgpY0NWXpmI9rRAqCBWntaRlvYpSeTtSY5LVwN3kDOMRlKUsHdUysgjaLz6YLGx76j90D0MFs9R9x8QErMYArc9VUuvC8ataKheEllC4LSNkdVg3sWXvrUGSPQLfBKZ2fKAMgWVLnFIoQY2voc2J9uiFt5/fgFWR+ohnVEbcW0ViRRPJqK6uQ8sbT90InOT+oOke1UTARotH5LO6W4mm3PRi4EIdNJKUH33sQvA9OVqqUMPKnmxeVrBv1R6ce2h6LKKrYLW9R/PcItsdkcuUbT0BpQ9Kli1TAPHa1TjJOl/EfXAQz7FinNicD5EvtrJO+cPTb1pUjoV+iaqWSX7atQBQynENH/W7PIKfp1srmlfwRD4QYvkzxoy5/QLK1pTFup35EfPnTUC0zvdUpx305PNL6GgdNM4G3XPfhS3QTxGrpOb0uu6fkHqJqCpnHnfp8ASAUrJaydzyw+r0o6tSXsnwaeVuRMDkS9fnm6fp6vB8oAwzYdcB3ckdeuhShUA51CiosF+gt1RvdKQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(366004)(346002)(376002)(396003)(8936002)(4326008)(66556008)(86362001)(6666004)(66476007)(2906002)(186003)(478600001)(26005)(6916009)(6486002)(5660300002)(52116002)(16526019)(36756003)(7696005)(7416002)(66946007)(83380400001)(8676002)(956004)(2616005)(66574015)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ek9IbWoxYjRkUXBYb1pkMW9XMmltMWtRWmgzUW81aVVDNGs1bm14S2Z2ZEJp?=
 =?utf-8?B?UGI3R0lGQjgzWGpubC9XbUxEOU8wYnNrM2c4WDhDdTlIUEZlWTFyY3l4ekh0?=
 =?utf-8?B?U2p2QXJ1RzloWFNGRFZHUXhuYklrenh3SlhFNmhnTGdoWjJadFNEYnRML01G?=
 =?utf-8?B?N28rV053UHZMcC9GeGlUa2NKVDJTMmZVZkE1WTR6YVMwQWtHMUkrTU9GOWZ1?=
 =?utf-8?B?QjF1VDBMZHY1SnhrZytZZFNnS0xPaVp0VkE0V21tMGJJaHJTTkQwTHF6azhs?=
 =?utf-8?B?NGxiWHpyWFJ0QTZyZWV4QzV5dlAwRng1bm9yQjRzS3ZZSmtpaTd4UWVVdFdh?=
 =?utf-8?B?bUZ3OVR3c2I1WmFmM0JOcUk5OVhTZjQ1RG9uRE4zU0N3Sk9GeHF4UUhXYldO?=
 =?utf-8?B?ZFBwdHJodW5WMmI2aVRjL24veHFHUzV0UjhlL1E3QWUxd0xEYXhvbW5OeFFu?=
 =?utf-8?B?TDZzU3BGVStPYXZuREJReW9MUEx5T2NVY3NGUzhzR2hwd09Pdi9aTjdjcm5I?=
 =?utf-8?B?bjZXR2d2bXlONnRhZWtsY0k2THdnUzdONng4cHF4dGM4VmVhZlpnVWZOOGdM?=
 =?utf-8?B?cXBHNVI1OUlhbzdMYXVYNHl0dmRMMG1EUkNvZUY5ak5GVnU1SmVCOVN0MktP?=
 =?utf-8?B?RHBCRHhXbEtjSkhxVWQvNHhRUi9mUHJ6RHI3dTRVNW9oYTZ0bTRqODBncG5t?=
 =?utf-8?B?TzRZb0RFaHBGam1FNnljQWZQOE5ieFBpcm5oK3Q1ZjluLzNhbE1xVTk2cjd5?=
 =?utf-8?B?SUc2UnhaZHZKYWZpdTZoVTZNL1BlQ0ZqREhPZDRNS0FOTERycVVFR3ltQlRa?=
 =?utf-8?B?d0xYdnhoMmpFaHp2amQ5ZFpLNzJMUysxeExmTWdyZGgxY21tdnZYaGc3TU9a?=
 =?utf-8?B?TWIvS2hFM2syUHVQMitpekVKWEFsT0hhM0FuclZUOHBYOS9lYk4xZmd5SUdE?=
 =?utf-8?B?OE9NVmVuSFlBZUQvQVk3dlU1WkwwaWVJeTgwZGN2ZjZRMDJ6SVF4SEdGL2Zi?=
 =?utf-8?B?ZVFYdEo1RlMxMy83REdqa2dhekhQczFTVGdVck9wSDRYN0xweEtlT0RPVW5w?=
 =?utf-8?B?cFNnSnkxVkg5OVArNFZaYkMzc3dLcjZPWlZ5Z2hhdHlZekpoY3cxNE8yemZ6?=
 =?utf-8?B?SDloNzJtM2xiVGpxb3pLUWp6V09JSHlVZHBOazBGRzVWZzJMRStuUHd3V1JL?=
 =?utf-8?B?NU1CUWIwV2tYVXdFU08xdXJlRUR2RzhBRVBCblkwN0xBUU9RcGVzUjVJYkNj?=
 =?utf-8?B?ME1iNmovdGZITm9YVHo3UHdRbmhqVlEyMVBNY3FEMHlmb21wOXdEMWJmd043?=
 =?utf-8?B?VU9yTEg4MjRXcmdXcDVGaTBZT3lqdjREeWkzc0Qxc1BEQ1lXYm1Ddnc1dTRL?=
 =?utf-8?B?cGdkYzJiRHhxdmZReHRJdVc4bWljam5HalpYZTNVWmd1blJic1lqT0xPd2pj?=
 =?utf-8?B?NWVpRko2aHBROGJIeFB3NS9YWlk5Yjd5MkI1NER2bUdjWlVRRDB6YStCamV4?=
 =?utf-8?B?clVRclUzZ2dkOFBmNzhWcWVjajBUUEhkQXl5MUhMbFFxcjZLRGpqNmpPYWlL?=
 =?utf-8?B?RVdlK0NpaDE0NlhKeDJ4NXJLVThTNmdLWkwweU5jK3lnVisyUFh0c3J1eEZi?=
 =?utf-8?B?bUpYRnhFZVVWbU9sYmRVdUxxRlMweUk0WVNLWG94MWRwUDYvUlNHLzBQeUhT?=
 =?utf-8?B?OUIyMWp2TXFaVFZhanpHVGt2R2lkSkkwUmVicVRRVEhhMk9ERzVTRHY3L0Jz?=
 =?utf-8?Q?QajlOZu5X7p2N8eQOeOo/yH8nl7MNWzAiU53nYQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dda980fb-ff6c-4a8d-8ad8-08d8c8a51bea
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 00:37:53.8618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MXFbs+sAcE0Ljkd3hRi6OPyFSG3Ad4EGN5HfuC39YviPEsQXnlwz8Of8sSjeSP2rpeLcb54RNtRNqzNW6/eKJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384
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
Cc: "Radim Krčmář" <rkrcmar@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 .../virt/kvm/amd-memory-encryption.rst        | 24 ++++++
 arch/x86/kvm/svm/sev.c                        | 79 +++++++++++++++++++
 include/uapi/linux/kvm.h                      |  9 +++
 3 files changed, 112 insertions(+)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index 079ac5ac2459..da40be3d8bc2 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -351,6 +351,30 @@ On success, the 'handle' field contains a new handle and on error, a negative va
 
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
index ec0d573cb09a..73d5dbb72a65 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1377,6 +1377,82 @@ static int sev_receive_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
@@ -1439,6 +1515,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
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
index d2eea75de8b3..c4e195a4220f 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1675,6 +1675,15 @@ struct kvm_sev_receive_start {
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

