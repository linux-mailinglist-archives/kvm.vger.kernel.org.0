Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E41AD3542BA
	for <lists+kvm@lfdr.de>; Mon,  5 Apr 2021 16:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241324AbhDEOXq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 10:23:46 -0400
Received: from mail-co1nam11on2083.outbound.protection.outlook.com ([40.107.220.83]:47073
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237153AbhDEOXp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Apr 2021 10:23:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b9+93Nup24VIPaJzESMre/36Xt4iDw9MniC3qoqomBGNaaWVOtW0TBaM63W3AIDa2iqnYwiHhRikHijBfRwwZtw+QXdyLaLvNjpPtbC1x+DcdkQ2vKvLdZiRBk8EXjG6K7dR8AHh8u9SMYpbIeCNBjQq6B/LkgvAf9GrGq1oPjpuUjx1SYhsQmTrbiv2IDjOfwGHmnBFXS8PvJ9352mA+HbGlrVNMiZR0RNqzQbZh8Mjke8xxDvgsg6giyxH/SKxxIvU/LFEvULdQ36tCMG5ltUAfkV18zmKkIjwoUFCmnhppjANQ9SB3q+rbIEF5nh93K7ndkVwXHTymyVZ8hAXcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TmptNcWrK0Wse7VDXUmUvzb21xGh5dE1N4aXqer08gc=;
 b=EZtqL+fMuW+yWr49xkeSC2GtHzboQ5P3DcsgQKydpphCZgadlItwv/0g5BOquS1YG5f0LceJXeJVqaOR9ex3ih48Elt5jecaTNi/YS2zBlzzs8M2skvF82ZQ5fY0cIFAnFwI4tffM7af7KqlwuN6SvwduZFnP5SiM3Eepu78LJfkaytb7u8bggytuOQH+TYpeUW18oYyWHcJkNB28VGaDATZD5CBVvlc/7WJl1cF/IjVYj6qkfriu3qAgUCGI62xK5JBRbbOt5y7z6ztB9C5rHU8d3+5OK0zA7lhXXX4EnCKpDMSOB9J2FE0ja7dtrCNHOw9ISinriY1CBgN37YNqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TmptNcWrK0Wse7VDXUmUvzb21xGh5dE1N4aXqer08gc=;
 b=0uTnF3dLspluMcbIpBbcyPTUH2DDDfAOWyX+sd8H8RoNRBxxwRKLdm9guTiOhNcSG9kROh0RtxKhteUrVowhu1of2oGk4Y0OmmZ0+QdyNfS3bgc60AeZca0KeZ/UIRVRCweNKpvkTgk5EogC6/JKorfgHX/PIcAzgyzd9DmnM9s=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Mon, 5 Apr
 2021 14:23:36 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3999.032; Mon, 5 Apr 2021
 14:23:36 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v11 02/13] KVM: SVM: Add KVM_SEND_UPDATE_DATA command
Date:   Mon,  5 Apr 2021 14:23:26 +0000
Message-Id: <d6a6ea740b0c668b30905ae31eac5ad7da048bb3.1617302792.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1617302792.git.ashish.kalra@amd.com>
References: <cover.1617302792.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0003.namprd05.prod.outlook.com
 (2603:10b6:803:40::16) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0501CA0003.namprd05.prod.outlook.com (2603:10b6:803:40::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.8 via Frontend Transport; Mon, 5 Apr 2021 14:23:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e63b4af0-bc8e-4755-87e3-08d8f83e663f
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2767E0B3B46AB8B78B4C35E98E779@SN6PR12MB2767.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P11NxgzdRtGI5edZ6QOaiiJwh2OqXh6M+MNrn6bHczGOpNGwl9dxssIGKZyAX/3PL/nPHDutlmyEaA4qwzW0Q/8SZEqIWF7FX4U4ouxvNFJJVb5WkIXR9AOd0jH/4Kd0vq/SW286Z16UItwEeWkSzDM/bavTJQC5ViryK3qgcD0MUnnreEGcG6REuUgOQh6zZuH9lot2HlEUqtsJZYZ6YEJFKxe587BCREoq44NbqXO9mF9aaGjijTU6+GhgdmuwibhnCUF23PjoJ2El5P6bg+Q2uEST9UR80etZQlloaXgzzpKXecEY7W/Wi4KWW2vomkza+8kHLEIImM3E/dRZUOFJ3bJLoaPW8SrvNNtVMcYZj/twTWQZLaADbpcv5AnKnPK2zevibioZCfvWz9/UGfKnTXpKasQ6LjowiwBSAGWUUE97QQBaYkIPQIqkTgY+9NUNTyODWvKFxePOLvq2GXosr7r+/8YX+5WQVVWZI+hdFXz5e4iU+mBPXDGA1ayt5eoxYRZ+v7sGdIn+r/zyAOsRkljbp4xrXOy++PY6NVQOflISEgFU9oDN8cMxkcEgDgSd2rm+Q0JVHo8v8+K+qynYQWsM9OYcrmHcK7JHMBhVYjY05r6TS5x/kXHJYrL4H3H3dTv4jTGF3McHA+Q7qytGFlUahBy5Qs8ABxmZgeg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(39860400002)(376002)(396003)(136003)(66556008)(8936002)(66476007)(478600001)(36756003)(83380400001)(7696005)(66946007)(52116002)(5660300002)(186003)(2616005)(16526019)(26005)(86362001)(2906002)(38100700001)(6666004)(6916009)(7416002)(316002)(4326008)(956004)(8676002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Nm82eDFtSm5KQm40YzMvYVpkMnFCSStmRzIvSjZtQzFPMnZFTHd3eE93VnN6?=
 =?utf-8?B?OXhINDFIUXQ4VnNGemJxbGFIUHBudUdMYmtyOWxyRkQ1MytGZHBYL0tiZCtm?=
 =?utf-8?B?UXBQL3BKYXIwTlhmczE5dGcxQUg1dTlkSVpRZkxRMy8yRjYwc3BmUG9oOVFJ?=
 =?utf-8?B?RXo4eElPQTk3T3JTdU44V0g1RjVpaHZVTm5UUWZPRFlsNzR3Q0h3STgrTDZi?=
 =?utf-8?B?bTZuSndvRzlVSDFaa2pHTDFNRmtzTkxiZ2kwYk1jZTBPd0lNbUNPWDRCSExv?=
 =?utf-8?B?T1F1dEUrY3dubEoyQUNjVGVPZXFYOUNOSmlleURMdlBVcWp1OHpoRkpQQkNz?=
 =?utf-8?B?VmRHODJlYU1xTkZJT3R3SVA2UFlsNTRJUTBHbWNGanhPbVU4SjRrN3dydlJ2?=
 =?utf-8?B?MTRIcG1uY2RIUDlHQmR1QUgrZC9EVFl2VkFpYllTVjJwSkltQWNmTm95N2xJ?=
 =?utf-8?B?VHltd1hPaitXUEd2dU0vTDBEUk85ODFnTXkvMU9jaWVDekI3U3kzV200ZHZN?=
 =?utf-8?B?Nzlsb0J0SDV2bUk5VWszZ1VoaWZvVmRSSGhaRDhsRGt3S3ZvWlU1MjM2R29V?=
 =?utf-8?B?R2RrK0xqVjMyVGgzQzBEeFZnbSt6VDErcWhTUis4NDk2ZGlVQld3N0g0N3R5?=
 =?utf-8?B?N2krQ3MwbldXTkdLVDlnQm9qMGNCMmMrS3dQTVUwMzZzT3lkRVFFTmVGWU1l?=
 =?utf-8?B?dndtOW9nNkZ1aFNwSEVnMGxkem96ZGVqZk9uQ0hPRUdiUEk2Nm9KdHpHNE5y?=
 =?utf-8?B?cXE4dlZJVkg2cDRZUW0rSG93ZlVlTWVMU1ZHemViMnhOVUJOeVI0aCtNSjFE?=
 =?utf-8?B?K1UwNUFMc1R0V01ScXZGbnFDRzFLa1ZsSU9tRDZEWDZmU3lDNWlkekQwSXls?=
 =?utf-8?B?d01KcE1mQWhnUnpsbkZXOEcrdDZLa1RMTkVBdjg3eHZVN2F1U2U5WjVReWxy?=
 =?utf-8?B?YTR1RHh6dWtGSm94OFhEeVJkRmR5RG10Zm1HOWp4ejdjUG5FRC9wazhnNWZi?=
 =?utf-8?B?eTcreFRCMDRBbkJxenZPaTZHUVFZS0lCWEd1enJralhNS3E2Nmc3NGxtTU9i?=
 =?utf-8?B?QjV2QmxpK0xUN2kvNlBQVTg2eUhJbHlQbytLRmJwMHRRTStBbUxPS0h6QWly?=
 =?utf-8?B?S3VmS3ZoZVNjdURIT1dWUUVzVnhmU1NFdS9MbHIybXZZelQ3K3kzc0p4SjEx?=
 =?utf-8?B?eE0zeStxWjNLdU4vRS9NcURxWnA2d0ZYRERhdENFMHlPMHorWFZyZWVENEpz?=
 =?utf-8?B?U01oV0trb1NvZ1Z0dzRpbmVpaGp6Mis2THJJVHhtdUdraUhmRS8wK21Kb3Ey?=
 =?utf-8?B?S0xORk5NNjVuV2pFc0JkT0VJUGJkNjJmRWd2SEtXSFhlUkdZaUtRTDNkUTZ5?=
 =?utf-8?B?YnZJYk1zb01ac1dZY3BHVUdrd3RXcGFTUFA4SmxKVmNWRjFpU3prdU9hVGpJ?=
 =?utf-8?B?WEc0bEhveG1DcjVuWlEwY0k4YXNKbnFXQXU1ZHYzMm03UlFOQnRzRlFsZ3Y1?=
 =?utf-8?B?S0UwbUFBSXAvYm51bHQ0Z29Mc2Zteml1TGlJY0RPZ2tYSnJLNzdMektDcEFJ?=
 =?utf-8?B?UHJZeko5N1ZDOUZLSDYyUlNadGlQUXpESmlDSjVDWGlESjBzTjVabm4zY1p0?=
 =?utf-8?B?OHJHYkNpNms5R2huUHk3elByWmJZZEhvSVJ0STNSQ0lmblVuQmFsWll6V2NM?=
 =?utf-8?B?SXYwbi9MS2hOR1NtMGRwWGFwUjFMTE5pWWttZFNYY05kTTUrZi9aZmtXc29E?=
 =?utf-8?Q?p2nAl1M24nz1aYzoRTRVTcuhZ83w9pAZBvbGodW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e63b4af0-bc8e-4755-87e3-08d8f83e663f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2021 14:23:36.1334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mm8KST750zFF5twWI9SfcLrGw0zcPhbzypj5swPuwY4AjV4/HEJ082iuDASd/RaiQx3ow0VXK5lDDLUGn8R4Yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2767
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

