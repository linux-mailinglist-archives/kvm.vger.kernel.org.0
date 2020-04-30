Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B02901BF328
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 10:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgD3Imf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 04:42:35 -0400
Received: from mail-dm6nam12on2042.outbound.protection.outlook.com ([40.107.243.42]:27355
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726412AbgD3Imf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 04:42:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uv3DDH5ju/czUiKPJvInqECBFenvUcyd4J4cgAetfrUL21r3fp0aAQtYJcH3kXsCMbVz1QuYRvFxBwze8aEmXRvyRzzpegbg9nlr+EbEYbcBoICks6PdiMBvfYy2ZT9XEEKMWfPu4aW1OwWRtHws/RH5dtiTRMxRtrRVcA37mGtXgNCx4ERHtTh5dp7uymo/X2+c98qyvZlQzpf4VPxQhiK5JHDE8s1lSEJp/UlB7CTo0eDxe8EtcKrBikztzXlR7fcQO/0KJ0AeHdI3J0TdBkfog2KxpgiXrtX9wvDDQEW6Cg9N6L3YR7isavseSQNRO/pHCZCNlUJLE1WcfxvkUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6b3VjYnBbMaZnBOtWYZedbsnefh0du4wQJSw6x1hNlI=;
 b=U/tmm6xjvmVIfrebzzpz+fj5AgMU5CPyYhS9sjSDmeQy9X1IjQJccr70xLY4SX2UtvfVvqEBUcbEkAINTcDQyJsimYoFQfy304swzh9NCaYFFgSpdRwvZLDnYGEbMD4cTSv2obY1tiPLGJpsGKIi6K8sC5CL1Fj8fMQvlAOGwZuAMqoFaulVGjenSDSZ4TGeKZFD5o6/pn3ChlFnTqTOwqBfTNHDZ/BtnNN2nInUKf3BWckcVJPHozLCdIKey5jFlxk1fbeXTa9A0VkSt7kryiH72RTktZx2LTYYDKL79uqOzQKT7zXhkJLUaR2bHV+90EK/R6woAhSG6W8RlVeL6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6b3VjYnBbMaZnBOtWYZedbsnefh0du4wQJSw6x1hNlI=;
 b=WkdANb1JJ2F161GPVhyEYZpylI3FMbzVFMLbkeq489axQfPGtakICdUwQkvBG7thDVZD/NMv1PQykYfyoSj5+i76adQiIeqv58Owo2ebydhrw764v82OdXUaocDFI1ahdsuNC7zaj9xlEZm8fY59LdfPjWr3sSioaLbOSfn9R1Y=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1194.namprd12.prod.outlook.com (2603:10b6:3:6e::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.22; Thu, 30 Apr 2020 08:42:31 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 08:42:31 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v7 05/18] KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command
Date:   Thu, 30 Apr 2020 08:42:21 +0000
Message-Id: <c1d3a47a7a9a9b8957a132b5265f2d367deefa97.1588234824.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588234824.git.ashish.kalra@amd.com>
References: <cover.1588234824.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR10CA0021.namprd10.prod.outlook.com
 (2603:10b6:806:a7::26) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SA9PR10CA0021.namprd10.prod.outlook.com (2603:10b6:806:a7::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 08:42:30 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4665b064-c5d8-40cb-f970-08d7ece26ba9
X-MS-TrafficTypeDiagnostic: DM5PR12MB1194:|DM5PR12MB1194:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1194D490138B71C5872363CB8EAA0@DM5PR12MB1194.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0389EDA07F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(396003)(366004)(376002)(39860400002)(4326008)(6486002)(6916009)(66574012)(66476007)(66946007)(52116002)(186003)(36756003)(7696005)(6666004)(316002)(5660300002)(26005)(86362001)(2906002)(8676002)(478600001)(66556008)(8936002)(956004)(2616005)(7416002)(16526019)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GGWgFkpDCuvIhFx0mQl5aVzRjtmSeWepm14xqJWV13xzxHZDFBGcERt/IsXe/Q/mTZgpukky8Fm35plrB85IV+uY4xVxgNlmT94waj80TXkVQlhTFBknvyOMuCbYN2ADmrsa50N12GL30fz4cypb709YsmE7rfNz8MwCyCBbOJQg0BIa8Ibttowun+2D2kMFgQEmPzX7/XRnZKofTr9NMkA5zyfKr/X+VyOA6bA6E04Hk/XiX6eMGf8WFkaSe4nq+Bu3Uzhn2LAKI91YB84Yx6khun+BmmEO56gg0kCQMtCh8dAbPssyjd8SkhtdbldtXe229HaTJCHQpZcmqwRkHNs//yOd+IEm1Z91rt/scatnkO0gsd7L/iTpuktGpbgOIV55ox+E5chXshoxX+CgIBbWYJMuldf3AwekhDPW30ClnXzlQug5nekqakRprGz7Ko19e2i3XYOFvkHQL/G0e+X3Nbb7PgCvHUM5KUU6rqAo3mg2rDPVXn8tYm1ZuDLy
X-MS-Exchange-AntiSpam-MessageData: 7XYcMl9k6G4GgBTAunkirpKVc5ESzm7PJ/hbjuuMTdPBngmpYQ4iwrVjhL3jerDpaiUJJdYhFOA/VO5cHWGYBmO0TMpzPjr6JeXsfJr8l8y+wK/zOvozjJoXyOi8knPUR1wLmZTgwmJ/AlQZM5iz67qXrGT4L5zcodxQj1HE3inKzFxAfaPjvq/0oHtMxKNjEQq+3ViBvnL6HfNzWVPRfF0sCLZjjErd1QfEgcnM8U/aPDBCWjLZzlUdTG8RbWNyMJhOUfHP36d7QifcwQslOfkUHYB52mzZheWyCFGVUcnJWNN8VB5jSBQzkoIdkLNiDDpz5V4sWxuucmprQ9RDsOhBEaBXfuPV2e/dLePkt0QsEQM+vXYQGZNGzltq8A7WETKVdsng0DDhbixiO99VKcwEFSldUjo2u+CvoW7eEg8VSImbj763kTcm+sFktm5Ja8HiBiebYW8Lw3k1SWW8zsXSbUBVCki9l67FOJBIkWmboEnpjrFb0qlfPP44bZLdWEE9gP+dXdPbRZ5PvjYvnUXpzonOGL+9fXpHJg3iFpxVtkblDm8Z0T/RrkoULTolTN2mt/VnL4/pAvFQNvTQsPdLg4ZydJ7jTJgJG9yWtWcTn2J6UzdQPKzsUANsLGGcDE3T2bzJK7FJBsFkW2JePxff+gGJnpoSkp8apaWry3Lm5w1nbuXbyQQir0SJFLhVAXeVH8UHaIb9FkvMI2IXxhu05E4m+zaolzwxIe4RhscubsA9zpR1E+NXIjK/5egJG+eNSblkSH+946pWOHiin79g7AMaLz3SmXG1AI5G38Q=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4665b064-c5d8-40cb-f970-08d7ece26ba9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 08:42:31.1469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eX8Tyx4CUH3rX4fc3WY/ct3F2TVfk5/1vYuIkbBwBb7Fkxy85NLF3XaaRFvzv3VdxXoxLhwnANM+EsY6Wyi+tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1194
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <Brijesh.Singh@amd.com>

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
Reviewed-by: Venu Busireddy <venu.busireddy@oracle.com>
Reviewed-by: Steve Rutherford <srutherford@google.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 .../virt/kvm/amd-memory-encryption.rst        | 24 ++++++
 arch/x86/kvm/svm/sev.c                        | 79 +++++++++++++++++++
 include/uapi/linux/kvm.h                      |  9 +++
 3 files changed, 112 insertions(+)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index ef1f1f3a5b40..554aa33a99cc 100644
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
index 74a847c9106d..d5dfd0da53b9 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1251,6 +1251,82 @@ static int sev_receive_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
@@ -1307,6 +1383,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
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
index 24ac57151d53..0fe1d206d750 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1628,6 +1628,15 @@ struct kvm_sev_receive_start {
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

