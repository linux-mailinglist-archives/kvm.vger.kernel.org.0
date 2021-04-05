Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 391F73542C0
	for <lists+kvm@lfdr.de>; Mon,  5 Apr 2021 16:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235994AbhDEOZP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 10:25:15 -0400
Received: from mail-dm6nam12on2057.outbound.protection.outlook.com ([40.107.243.57]:61793
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235915AbhDEOZP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Apr 2021 10:25:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UPilkxhFbaHYZTXuBBslVVYeDZRwgAYvhu7U73Q15y/iDhjhb55wOG4ZF0TGjb0dLcH0YdsljV8QF1Zu7RhwGbggR31X/nwJMVK+/dbcBQe3K3uzTXZF0pNLEG0SDVKYntbiMkwSPxdxVsERuKs1EyLKUhiBP3iBipr6eqTNOyZt6RhWIAVwJvKcBUvgeMJfyW+2SZAUdl4/FYPYF3Qvas6ZxNlqDnzLi228oUK0gRQCzdG7pCvplSgPi7Mbycun8slpo9JSfv4LUAA/KioucO6WcdZP8hjLJrSai5bwtu/GlWTuZZy8IIoOs9G/Kjc+B0hiEPECaicQ3ZR4j+WVcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OAR4TeFg0Nlu/8iO2BhJJHdmuEIITuF8bwy+t8L0m98=;
 b=O1AhOJNVH0tU9IJ7wJkU4xt93qmvPG2MY2EJLpU6Gt1ZlAI8qFOMUemuIfRbnUpmC2tWRvYexva72N6NtPJzcg9wNabUAyEEG4u7PcBXqeUiGJEYhb82u53XOmCZUHZz9mWX3dHCY5r6bpZuZJONYjkvENWXT5QEHmfKRZK62HRkKAAIFGCnOGmTx/Lj0SYxx35TaMGpJ93/ATWcQEet4+e2tfhe0pERbMt42BFPr2PVIsrwzqIdfDQOdRP6RmYUKKIdLkI/jPklsypwGGlW1U4XsIrcYBnsgzPCxpKAJfBLW0pCASUulekSLu+zl2ckaxwbU55iFopOHHclQ/FR7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OAR4TeFg0Nlu/8iO2BhJJHdmuEIITuF8bwy+t8L0m98=;
 b=L7h190nL0r9GLfe64WZ7Z/vKeju8cWpByXcJX7glHdM2I3euu/yknuvNAKj2TLXt75wVxujCUFtjfFNexw34WgEB+x5sy9Xa5TZm0ag7Bit7j1azB1Uz3zYH49wluuRVG6aIokegF3nWsmmSmUdZ05eCm/A16cT/M2HAmTx5PjQ=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Mon, 5 Apr
 2021 14:25:05 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3999.032; Mon, 5 Apr 2021
 14:25:05 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v11 05/13] KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command
Date:   Mon,  5 Apr 2021 14:24:41 +0000
Message-Id: <c5d0e3e719db7bb37ea85d79ed4db52e9da06257.1617302792.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1617302792.git.ashish.kalra@amd.com>
References: <cover.1617302792.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0201CA0035.namprd02.prod.outlook.com
 (2603:10b6:803:2e::21) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0201CA0035.namprd02.prod.outlook.com (2603:10b6:803:2e::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Mon, 5 Apr 2021 14:25:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 149d5d3e-5733-44e2-5fc2-08d8f83e9b9e
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB27676FB0F5DAF4C61C69EE978E779@SN6PR12MB2767.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YnSQZ337hI5r5Sx3s1OF9RURMiJjTks+mwL5JyE9a/htp2T4ikoxBKorrN5CdngWam1AHnp6vK9RLs7s1RbLHnmapDAoW1ncpaklYQlEUgabUjpCT+Lnjfm9wx7dfZBRvi70m+40OMg3ZDW3d0Xx1QHl1dYPG1IOweB69/gg5ONhd4ffPnpAgR+S3sGKF+UmZyWMIBTnpggO+2OZj6HS0KCnF1rvceKV0iT/Shh+fTjxRdJexRRw8t8MQ/z3jNywlycHgTAASxN0rZDwB2Qx9e9KcrSYsVU2036K0SnumzUcKJxqV6dnna44OCHSqrHN6s+XrKPS8ilSUjnaCfvbSylVVTP39lbWw227iknhKvZH9OWlbVh0uUXqc5FIl4IRMyzHG09/5WMEjKHRQvDNe5zbLgdQHqK9U1lkKL35a8UE9vcFH6JI7kBPdLQjeI1BRx7ZxUmJmxe55hDEXZ/HPWceFnZ0mu2DTqXWyxedknqw8A9GmDC+X6Q9xbXnEpsQkzqoVd91t1j1P5gG3dGaUV4wM0Z//Ab5S0ZpgLXS7DnKiD0gX1zTsBovN3TLb4rcGJ6MOm5sDGOQ6cE4IQr33m5NS5Gf2GnJrjTGtzxhcabKHe3X4R9pkgNlAkPxl2p7m055cKeKsXKwiX5kx36xoqODQQdvi0IKNz226KHoh8U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(39860400002)(376002)(396003)(136003)(66556008)(8936002)(66476007)(478600001)(36756003)(83380400001)(7696005)(66946007)(52116002)(5660300002)(186003)(2616005)(16526019)(26005)(86362001)(2906002)(38100700001)(6666004)(6916009)(7416002)(316002)(4326008)(956004)(8676002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VTNzSERvN2tPSDZtdlV1ajRWQnFsUHhyMEMrYjNhVWVRenc1S1JrdDlLL3Rl?=
 =?utf-8?B?elo3cHJYWVE1MUZ1c2x0K2pvRFZ3dUNJSXBzSmdDSVFyZ2svc2UwbDZhWm1p?=
 =?utf-8?B?M3Z3dUdBME53dTlWL0FTY0RxbnYza3ljaTU5NllKeGVNNktXVU1jbWxLajkx?=
 =?utf-8?B?N1JLb2pZRjdvZk42OUZjcnYvWXR3ekhsWUJ3anN3bXovM0trS0E2aHQvM3dK?=
 =?utf-8?B?YUg5cEtQMUlpb3VMdlJiT0Q1S1krQzdTeTMxVHIzZSthYUV1ZW9TaDhvVi9H?=
 =?utf-8?B?RDN5Yks0eDFwL3ZtWVVaYWJyTXNvOVFxNnZjTUtzVGVWNGNybEQ4R0h1aWR5?=
 =?utf-8?B?VU0xb21SYjhlVExCU1dUTlRUbGlkKzh4V3lwSGhFc01KSk95b0ZGTFVib3p3?=
 =?utf-8?B?SUptNkJLUnJ1THJ0RXB3WDd6MWRhdm5HdHZPaGdmUUZRK3BlS3lqSzlkaGJx?=
 =?utf-8?B?cWtWMUpINlU5OHVzeXBlUGtHb0FoK3dxdDZKSVVaVmtrSzF5S3grSnFqenI4?=
 =?utf-8?B?cng5ZUNSc1ROZ0VybUhONFNWaEl4YTI5cDZReHQ1Y3A0c3owdWJFdDltd3dw?=
 =?utf-8?B?UkowT1RGVnhXaUUrTHU3cUYvMEpCR003MFZVUXZpbmszZWZSdWc2dUZSSEx4?=
 =?utf-8?B?aW12QVRzczQ5bnFsTVp6MUFiVXFUc1Z6Y29HSVlmWHZ4YzhrS2ovcjh4S1JO?=
 =?utf-8?B?eU5YcWczWlJqV1MrM3A4VDdTRjdzQW5rd2sxWVJNRGJoK2hHRjIvU3lnY3J2?=
 =?utf-8?B?ZWlSOHNQWjVUNGk1U2xYUWpzdTU4UFVRLzhZMnFlRWVYUUEzWEFsUUEwQXNM?=
 =?utf-8?B?SjhmYktORE9TblBaRTcwRDNtbmkzMUNPQ0NlVkUxaG95ZzR6d0V0bW92K1Y3?=
 =?utf-8?B?ZnBEbDRZSmx1c1ZkMkFoZHBsRjFuMDN6OXhFU2ZUS0NXVURKSy9acnBTNkdx?=
 =?utf-8?B?NzEreE9Lc3VNK282bTlPUHhGaE1wTzRuSFV5cngzblQrbzJ1VTgvOHRnT1Fr?=
 =?utf-8?B?TE83OHhxR1JzOUdwTTREMXh0dVhmQ1c1VUdwU2pUV3NTYlhubVJqUWY4TmJ6?=
 =?utf-8?B?UFptNk5TeHcrR3JxbG5VT0MxdXdoNDZ2WWtCdkRaNGxTSlBWcFJkYnI1SmpU?=
 =?utf-8?B?NGVESmpDQkFjSUZyNFVCdUNPUlhPdXE2WU9KUUhtcDNZanFYQ3VKdWtaNkxt?=
 =?utf-8?B?QmtFM3h1WWtSZXBTbitqWjlkS2V3YzAvL2VtNFRndVJhS2hDRWtLZ0N6STJO?=
 =?utf-8?B?OFUyemwyNjhGV1pQOWFwUlJLeE9hZk1zSVdiUTJpZWtXMHEySEJYeXhBYWlw?=
 =?utf-8?B?SG1JaDdPQit1Qmc0cFN3OXRIY2hGQ2xTalNBVURIMW1Qd0NSM293djB6aE5t?=
 =?utf-8?B?dTNYaUJHN1dXclVsN1hMcm5sTG8vM1RsVkpmYXZlcXRrOVRIdWlhTlVKVkJv?=
 =?utf-8?B?OHBvdDZyazFlWWo1RVpiVHZ0Vm5oZUtBK3BIcm5kQlh6dFRjQTZna3M0Y1ds?=
 =?utf-8?B?UlgxdFR4em9qcHhhVDJmT3VSSlFvVWIyY2tNK1pQT0c5dlcwek9PUThubjhx?=
 =?utf-8?B?SUFTM0hWYlkyTTlNUjhIUnp5NjZBcWl3RjErMDdJbmJRNi83MjVLN3lmRmdS?=
 =?utf-8?B?NC91VTN4SnI4TS9HWjlUMlQvVkh2aG5UYkhMUEN5WnJUdzFIblBmL3pwMGZQ?=
 =?utf-8?B?Slp1bnNYM2x1Mm9GTEY3cnM4Q0wrZkx4YnVxUDFuM1lVditEQ2QyM3hZd3dv?=
 =?utf-8?Q?5XTzKGSaPxmhJejK5QNE8B18clAFVrWfFnzp41s?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 149d5d3e-5733-44e2-5fc2-08d8f83e9b9e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2021 14:25:05.7342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LYy1339lIa3tvK3z8g0hwIgeB7Ti5NMKapQEB+MVD0eAwDpmg8zX+Q4uWHD/mDcwjYeYLDrtH3DqSZoQS5e4ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2767
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

