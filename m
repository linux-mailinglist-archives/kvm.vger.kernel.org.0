Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40B7330E8A2
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 01:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234233AbhBDAiA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 19:38:00 -0500
Received: from mail-dm6nam12on2045.outbound.protection.outlook.com ([40.107.243.45]:57185
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234122AbhBDAhz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 19:37:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JzX4PJu+OfSvnKYvYMxyvEsam4iQNR4WM6L0UoD9YuOTz+c9iArUOU07Bpymf16Pd8sQiWtyekf+WmB+TMB5gMFx3lhlT8ANQgpmdrVh88jG0PBdpD86Pucg7uieUURvan2jf/lrTRHuvxLZmwjoljiL2CQIShEOZHs7fRfioASOT6W/sjWdrVQpJfFWS+yyrfOSkfbGImlvy50rMVy4ISIYz2SXfrosObJZRXw/YYb3xXib9S+JXdS0lxgCCKJ7hom2hQZ4q8UROFQRio/BuHqQJAJQnkpxJmuo5IsUq8exFuED/7tS22Nyjgadjj0Bg5mOgI2xARPGJxQVh5hRTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bykBY3MiAJo9G5X+vgpvDHuOkhNLZlEh5jPLcGxhGfI=;
 b=mdvfuu/qJWVuesEsze6oQja/2nzl/EhklETadKZpZR2EzUEN+NnNfqoy2LlMN9nDRG6li+JdukrPchcWA/9UmdGvKUO+JwLs9aNqLSSxG2pFFsd0Qx7VjkDll3Ipa3+jZQK/NZd/fVePZ16/ziDYyJX1kZ6/m57xdmWd+wueZzwTJPEkbVSAI1jkPaE2pJzCfCymQglvaOcmrZBD4ZE+2BNq2D34wNnWAsOdCNN5I4k/ueNkAAQAb91tLgO727FDoPugucIsHRyAvMQgP5kUfB4PW7q+qkzSvme0T00LA63FdfUtqWYewl0dhkIc+wxRrFsc8EcXWzNqjC7BoVVvIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bykBY3MiAJo9G5X+vgpvDHuOkhNLZlEh5jPLcGxhGfI=;
 b=DP94ceASXGb0YKLb+7VAZxcvP3KjVD5o74yjIwUH49aVILrSK+7URUf1apVj2OLoZyYs3RxqVZdziKNq3+9+pZIWkx+q5smwk6Sop5IucGsuomKs6TkshluGsdo5EK+RRgzG4l1Taptt0P5ZSH5FA+T7ns5uU5yonHcV20yxH1k=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Thu, 4 Feb
 2021 00:37:06 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3805.028; Thu, 4 Feb 2021
 00:37:06 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        seanjc@google.com, venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v10 02/16] KVM: SVM: Add KVM_SEND_UPDATE_DATA command
Date:   Thu,  4 Feb 2021 00:36:57 +0000
Message-Id: <5d48b40c36d82c8a5ef2a68236a8e5e115e4e275.1612398155.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1612398155.git.ashish.kalra@amd.com>
References: <cover.1612398155.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN6PR05CA0036.namprd05.prod.outlook.com
 (2603:10b6:805:de::49) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN6PR05CA0036.namprd05.prod.outlook.com (2603:10b6:805:de::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.15 via Frontend Transport; Thu, 4 Feb 2021 00:37:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 73a20b8b-36d7-4f79-da0a-08d8c8a4ff9c
X-MS-TrafficTypeDiagnostic: SA0PR12MB4384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB438407B3E0EAB1DDCE1667E88EB39@SA0PR12MB4384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MdBZ66tF3KyMe1sMETd1Ul44+k1Q7/94ALHdRVWfQNZiKlZGzL+j8qh8k238YPOkG6h4pADCL/HNDA4yRHFokOzsvTDvqxqEBm2AUJ0vDSw2AH1KkkDiJhiu3RbmekOVbkS7SJcohK5fe4K/ggF5tD5fklquvS0n9e84J1fpfWoSb3Yx2Ds9avtAcdk6ZW0Owefhn9iVHPWBKJUjXE0N0J6Ti5zYAhTUj76PmXrtdqGZKut2jrjHJGJpwJmWpwS1RCjZxcTiSFga+RCLQA5uKEciyx8SaJQVyoGh+s4GlXtP4CuAHAboJKRwuMrZ/x57yXKmfHf6lqJlUnfGo5jmsyz6pInBpqehgmPUUnd6UyUWuVc32lBiJwE+eRqYxkIXmZz2DPKl6f8mJO/wqL/vdN8R4FGuYsi0VdR8O08at3yYwEcC+hzm8YFf7j0W30yNRx9d04OUwUdy7X/M+gUc6G9yQjjXFvFzWI89WaxfFJJ+C9x0GnZ36dj0OyFYw8NNZ59ZvPiAaRAt/Cu9hNKl9w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(366004)(346002)(376002)(396003)(8936002)(4326008)(66556008)(86362001)(6666004)(66476007)(2906002)(186003)(478600001)(26005)(6916009)(6486002)(5660300002)(52116002)(16526019)(36756003)(7696005)(7416002)(66946007)(83380400001)(8676002)(956004)(2616005)(66574015)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?V3A5RGFGYzlJUXlJN05mM05TOHFOWHEydzdLcS83Tm9uZnlRbHhHd2Y5cFM5?=
 =?utf-8?B?cnVpUjR5TnFmdTlSRE1mNGkrU2ZPSFF4RUVndm00dWduZ3M0T0txYU5PbU9I?=
 =?utf-8?B?NFM1T3NLT2pJemI3N2N0YkhicnZQUTV4UGlEYlQxd3QwYnVZYnpkeEg3RUJa?=
 =?utf-8?B?aEZncWdxS2R6dzkxUWJoUXJUTDgxQ0RCVUY5MTRXaHEwblFBNGtTcEJJVmhu?=
 =?utf-8?B?alVRUVBQTXZhNWwrR1J2dTlrWHNHQTB0ZnBwUTl1dC95SUtwcHlWazRnTzUy?=
 =?utf-8?B?aTRyVWZjTkMxaE5WdWkxMWVwWDB4YnZIRkNRbWdiZXh2TzNYdTJRVVlTVm9C?=
 =?utf-8?B?OGdRWWpZeVozemoydExFVWVpWjgvWnI0VUpPQVdyYjJVc0krWHYvbGpIZy9J?=
 =?utf-8?B?VlVvYTAreGhJSU5FM2hSTTRnUStMOWhyU2NkQVlSK1laRklWOVUyamJJNXFH?=
 =?utf-8?B?bUYxZlVmdHlEWUNRUjBubVFGYnhnVU8va1pOVm9KbHFWYXcycTYvRjBKTk41?=
 =?utf-8?B?WWdSWWZhMVA5ZXc0WG4xa1p6ZGNNTlduSjhUTG9vWDZRWWtONVd5ZEk1UlNW?=
 =?utf-8?B?UTFuME9zRHpXVzVFeEFSd2NKdEtOK1o1eFZlSmFvdU83VjRwb1A0Z3k3TXlw?=
 =?utf-8?B?U0tlR2dseTZJL3IxbDh0Nm50N1dRNkhEb2ZGcEYvTHBzUW5teExqUEk5WWhk?=
 =?utf-8?B?eU9lUkszVXZyYVBGNVIvUDQwZzdYYTRrN1pTVXY1T0lPM1BRUmlhY09yVkJQ?=
 =?utf-8?B?OXoyMmttcmhzVzBNc2tYUTl6c0ZUNmt4aWxuTXFEMlA1clQ3MVZFMXBvbGxq?=
 =?utf-8?B?eG9nUGJXQ2ltM3dHSHRqblNZSkFPTFJ0THU5MzY1Tm1jZXl0VUtqUzVReTIz?=
 =?utf-8?B?M0FnRDk0SlkxR0JGc3BybXMrZTdoMTFJZ1FvN2F2dHI4b0svb29peDJKcm5u?=
 =?utf-8?B?YUdDVlZsOFFCQUVMbVZkaUpETGVzTkpmaWtNVzJvdm5GL2R4TXlLOXhaOGpP?=
 =?utf-8?B?a3IyTFYxRjROZ3lOOW5nTWxKZENVVmZZSmN5MnRNK1RmM3FyZnRLaGJ3cWR5?=
 =?utf-8?B?bllHVXBTRlFId2lVTEF3dHNzNENPMU44bUc2aGE4dWxUZlNaYW9xaFZsT3dU?=
 =?utf-8?B?Mkg1V2hUR21OTVAxcWhYNzRsazBRS1BzZmpHbWZ0NnRNMWNiblFnS2g0ZFNn?=
 =?utf-8?B?cVRZU1BVVTFGcUJYVXAydkhsZENXTHpLM1ppbHozeTBiUWlNTTkxK2lxWFFm?=
 =?utf-8?B?QkdqbndVTVlaS2kwcGpoZ2xRMnJWRGZwN1NTZ3gyUUpZZDNvR08xWkRyMlk4?=
 =?utf-8?B?UUVZQzVDSWpkdmdJby9nYmNjUG1reEp0eHRHVjJRMlZiZGFzUVNIbzBCbDhw?=
 =?utf-8?B?NFprZ3pKSzRxSTAvTVltM3JMV0ZtRG5LVEhmN0c0MzViVVZQRkJRYUY4VXNQ?=
 =?utf-8?B?M05ldXp5ZnZ1ZG1iRGZ2dGRoS3R4M1lwTU5CWW1OZkZyaEtkK3VENFZqeHNh?=
 =?utf-8?B?M1FVd2Jqb0FPTzVlbkhWL2x2VXMrdHNOU0hrQXpqR2NZa2JZWmQ4cjB4YmZq?=
 =?utf-8?B?RWFPZ1VLMkRnc2FndHhVQXpmVGI2Q2xRSFYwZjE5WG5CRDc2K0g0a1dYWWpr?=
 =?utf-8?B?b1BqOXhYcUlrRXpMMmY2d0FITWRwdVd1OHcrV1AzTkFPVzFVdTVrVmtGZVYr?=
 =?utf-8?B?RWg2T1ZXR1plOGdwUXVYV21IM3VZZjBuaFhBdThDUUVjTGx2TDlRWWVzVndm?=
 =?utf-8?Q?FDl1rTSSfraGt8s+DqUgT4oiKCUAySxm6bRKKL8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73a20b8b-36d7-4f79-da0a-08d8c8a4ff9c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 00:37:06.3125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NwDFtzlaGTwDf/cyJ9lNXxLjTGBZDigp4pbW9DLLj31IPCcxRFcEzih5j8u+44pqibMUdN9iDAjndMze0x1iZg==
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
 arch/x86/kvm/svm/sev.c                        | 122 ++++++++++++++++++
 include/uapi/linux/kvm.h                      |   9 ++
 3 files changed, 155 insertions(+)

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
index 3026c7fd2ffc..98e46ae1cba3 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -33,6 +33,7 @@ static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
 unsigned int max_sev_asid;
 static unsigned int min_sev_asid;
+static unsigned long sev_me_mask;
 static unsigned long *sev_asid_bitmap;
 static unsigned long *sev_reclaim_asid_bitmap;
 
@@ -1161,6 +1162,123 @@ static int sev_send_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
@@ -1214,6 +1332,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_SEND_START:
 		r = sev_send_start(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SEND_UPDATE_DATA:
+		r = sev_send_update_data(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
@@ -1392,6 +1513,7 @@ void __init sev_hardware_setup(void)
 
 	/* Minimum ASID value that should be used for SEV guest */
 	min_sev_asid = edx;
+	sev_me_mask = 1UL << (ebx & 0x3f);
 
 	/* Initialize SEV ASID bitmaps */
 	sev_asid_bitmap = bitmap_zalloc(max_sev_asid, GFP_KERNEL);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 8f538fd873f6..0ff7bed508fc 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1657,6 +1657,15 @@ struct kvm_sev_send_start {
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

