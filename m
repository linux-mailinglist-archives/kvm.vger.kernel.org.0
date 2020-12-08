Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30BDA2D35D7
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 23:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731029AbgLHWGE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 17:06:04 -0500
Received: from mail-mw2nam12on2045.outbound.protection.outlook.com ([40.107.244.45]:62081
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730370AbgLHWFu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 17:05:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ft6bxEGWnPnz+XktTMMf29BDxfpnWfKSugflWxBB8EIMKZ02usaLZnPFmwu+al7ToXd+59B4kURwovMwvsluMkWMJXgUCPFGijbBxu0nnQMCN9nayLIpC+DGvKNINecgKcjJxMW/nbpcwNu/uk84ElxEiMyKdag12fEKsc7Wn7/q6jBhgNs5QR0Ro5PiA3RUmfo1cDNIeMU3qB+vNZyhTptIcWuwo9cQBsADEsaCmpUEf3yx/TIUlUDaQ87qWQQ+tS1BqSYo4+4/oYOwlOkQ/NIkUFXakWgdXOnpDLPGBE9Cw3lUUILir+4dh/bbvMPoTlXEFn4TWaAIzNIjb1vxSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IqfZHu1UBRE1TEpbNIxfADaDPUI/FgfkoeIJpAYkjJQ=;
 b=SOBURB9W0OQc1DOc+Mf37awbPPFJfm8MylyHZvQWt7+HX0yGUdzyjMuKg9AQb17ysv8kqJqqKOr0qR7FQEoRg2Jz/hbpbJiRBPnl3rLWSZAADSy27w3qhdPNkCozkFB6yQHzosOpvfDSYNJ1IotpY7zOhIxVvLhFviQ4tt34Qgrh2rM/jXYHzspH5oEk9XTmH2p1NTRh0C7kLpw3jNb2+TGcv48GYMaaKBPR1UvnQmyW3C+JyBKHrsFC3Y8HvUL2MTk6e9vu8G7Un9TgmXVUKbqp7L3tVu/oVYfm6az7S1euLVu4S9iFMAIhAEl6l+qfG9fTggV9dMYp9dHL0GL3sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IqfZHu1UBRE1TEpbNIxfADaDPUI/FgfkoeIJpAYkjJQ=;
 b=SQcvhwQn08nxuVjUMrnwOzsCInc+2lc+/zNxZd8OMgjppW2QkEZju8z2IBJYMd8YK+mPJqnfr3U1nETwzD/rCO8lp2niGTCb6tLIxaU/PcIwEG/igzpEBRmWG8ivruaFDdQpWvjjkm849Mmz9sJ8VzPrpTVWPd15vZTFYhe29tM=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4365.namprd12.prod.outlook.com (2603:10b6:806:96::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Tue, 8 Dec
 2020 22:04:23 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 22:04:23 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v9 02/18] KVM: SVM: Add KVM_SEND_UPDATE_DATA command
Date:   Tue,  8 Dec 2020 22:04:12 +0000
Message-Id: <294c63b0f9e7dbc94cdf813a94eb0cdc9622b4bb.1607460588.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1607460588.git.ashish.kalra@amd.com>
References: <cover.1607460588.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR13CA0208.namprd13.prod.outlook.com
 (2603:10b6:806:26::33) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SA9PR13CA0208.namprd13.prod.outlook.com (2603:10b6:806:26::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.9 via Frontend Transport; Tue, 8 Dec 2020 22:04:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8b0eeb9c-d4e5-4dcb-f546-08d89bc53866
X-MS-TrafficTypeDiagnostic: SA0PR12MB4365:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB436510B65C668EA7AC8D27B08ECD0@SA0PR12MB4365.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RpAtde3w4upe8tQviuCB3Pho4fC+gQq+tD+u8FxQQY7NrMDrwahfxN25/tzfDjDNeRXg7EiUmjm3AZDY8vp3ZY7Ib8mWtkeG1HyMW6eCsFAZH7EjLr+9AzRdzYBTbMIHMuwzBLRcqwVPJTBeg7en8a+LwX9GsdmQu4VpYkqrcUKdT0Nd5kVxAXSz2T08tAlOMOBcquENa9IvBhYwItz8zFSu08cWkhpcoqSw4BweI2Dx7QJnbgyREdGWJRRwB//kT2fd0KkwlsMxL4f2Kd2kUch9Lw4+byVxYIWn8sT/NyQhJmjCuua/eaS+221xd5WzzvCyhBq8Y226qvW8eYF+cZeWP658sJMrjoNAsQbUT+jlXx17ybDuaZ+/JkYjIbiH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(136003)(7696005)(508600001)(6666004)(66476007)(66574015)(66556008)(4326008)(66946007)(52116002)(5660300002)(186003)(2906002)(6916009)(34490700003)(86362001)(2616005)(16526019)(26005)(956004)(7416002)(8936002)(36756003)(6486002)(8676002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VUUzV0w0VjFkMDdWenlIUDFnWnNiVzRuSmZKVWJNWmZlQmZ6V2ducmlPKzdH?=
 =?utf-8?B?c0swYlEyck9GUEJuWHd4ZDFsVlY0RjNZclBUYTdyR3BoeXp1Njhrc1U1endG?=
 =?utf-8?B?SGZRWW1mRHRwR0hJV3RsNU93bWMzYllDOUVoM2YrdlJvTWJCTmI0WE5nZkJD?=
 =?utf-8?B?ODIrbExvSk9keHE4c1Mzd09SZk5IMjQ2eTIxSjliMXA0cFdDeWxUZ2FaSlVG?=
 =?utf-8?B?eFlROUlDTDViMWF1M2h3TGIzdFZ4ZmZ0N2ZEQTRxUTB5eTl3NFFQVEljK0FG?=
 =?utf-8?B?WU9PblFvNnFqMXErM2g4VkdsTmpOM0d4QksxV3MyNkZHZHB5TXBSZXJSZGVV?=
 =?utf-8?B?ZjBNdTNhMU9aVjFWcG5yMUpZa3kwNXhWNHZ3WnI4Z2pSaGR3aW90aVR6QTlV?=
 =?utf-8?B?Mm5JS3hwMzVPMWFzRHRKNy9INGJCQlBmSG9pY2tZSXQ3ODJFbWtrZCs4WmJa?=
 =?utf-8?B?YWR5TFk0bTJpSUNQTHl5RzBEODVMenBhRXdsU242d1ZMUmNpRExMSmhnTC9o?=
 =?utf-8?B?Rnc3ckcwcy80ZXNCOWhGbFU3TDM4bmxnR0RUQzBqNkVtcFg2UEYrblBmY3JR?=
 =?utf-8?B?bHBBR0diK2tQTzh5SUphN3c3SnJZRW81eVlkOVh3RVRWbWczNWFNWDRnbHNP?=
 =?utf-8?B?RWJETXJMS2hpZ2J5QXAvWWg3QzMzUFdVRTg0dnlBaHFiNkpyQm40U0Q4YTVE?=
 =?utf-8?B?YTBFY0MyYWJFVDU5Z2lIZUUxVGZDb0pyRzF5ZTFpbTI5empoazFEaVhyeTl5?=
 =?utf-8?B?WGc1b0djOGFqZ2dGZ0t4d1VTRDBpcXI2bHQyTzZKMWZmaW05dVc5V1NYaHdI?=
 =?utf-8?B?TXkxVzlmQ0ZKcXJaSWpyVitCZGthZk93bWQzWTFoaVIxZkkvRGo2YzdBMFlD?=
 =?utf-8?B?UExkTHpGQkxCQXdwSk00RWxEWEdXb0RmZFAyY05TZ0lIK3VSTTl6Z3RCSVB3?=
 =?utf-8?B?MTVFTENrcnYyZU1aVXdTY3VZeHdRWE9PQTlkbzQvZTBxREQ2Y05JZlNCNlAw?=
 =?utf-8?B?em94NjVGb0pnajhNcFFQdGEvSU5semRWVEFpUWJrQjhnQ3Yxb2ZzUWxRSFc4?=
 =?utf-8?B?U0djRDE3V3pjZkdMbDR0dEs4c0R2Szk5RDd4dWRFWjlKMjZiMXpLZDBCZGJR?=
 =?utf-8?B?Q2JqY2dWeG1ZbXpqK096V1hKdjFDbE55OTVoRXptVS80Y0pUN0U5S211bVVh?=
 =?utf-8?B?VHIrWDd0bXJBUHpTdDlqVmU5UlJIM2ZtbC9BQkpDRFZDSmk0YmIzNTJ5ekxy?=
 =?utf-8?B?bXVwTGVqZHA1eGFWNHhZY0RhdTRmTlZTTm13Z2wzaGdmd0JLbitOWUcwL1NB?=
 =?utf-8?Q?+wRc31PgjrvWmuueww42+3JsDDfW9pjy0D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 22:04:22.8979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b0eeb9c-d4e5-4dcb-f546-08d89bc53866
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xahb9PSvzMb9zPmRSO8vj70/C4apytx2XJkoCW6aB9Bjf5ikiXQN87GEjafIT6OQISrqum7oCBovfCd48T7oAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4365
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
Cc: "Radim Krčmář" <rkrcmar@redhat.com>
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
 arch/x86/kvm/svm/sev.c                        | 124 ++++++++++++++++++
 include/uapi/linux/kvm.h                      |   9 ++
 3 files changed, 157 insertions(+)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index 9f9896b72d36..8bed1d801558 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -290,6 +290,30 @@ Returns: 0 on success, -negative on error
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
index f28a800e087a..adfe2e53abf3 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -23,6 +23,7 @@ static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
 unsigned int max_sev_asid;
 static unsigned int min_sev_asid;
+static unsigned long sev_me_mask;
 static unsigned long *sev_asid_bitmap;
 static unsigned long *sev_reclaim_asid_bitmap;
 #define __sme_page_pa(x) __sme_set(page_to_pfn(x) << PAGE_SHIFT)
@@ -1049,6 +1050,123 @@ static int sev_send_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
@@ -1096,6 +1214,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_SEND_START:
 		r = sev_send_start(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SEND_UPDATE_DATA:
+		r = sev_send_update_data(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
@@ -1253,6 +1374,7 @@ void sev_vm_destroy(struct kvm *kvm)
 int __init sev_hardware_setup(void)
 {
 	struct sev_user_data_status *status;
+	unsigned int ebx;
 	int rc;
 
 	/* Maximum number of encrypted guests supported simultaneously */
@@ -1263,6 +1385,8 @@ int __init sev_hardware_setup(void)
 
 	/* Minimum ASID value that should be used for SEV guest */
 	min_sev_asid = cpuid_edx(0x8000001F);
+	ebx = cpuid_ebx(0x8000001F);
+	sev_me_mask = 1UL << (ebx & 0x3f);
 
 	/* Initialize SEV ASID bitmaps */
 	sev_asid_bitmap = bitmap_zalloc(max_sev_asid, GFP_KERNEL);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index f91aca926e89..c6f9d58b5a81 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1655,6 +1655,15 @@ struct kvm_sev_send_start {
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

