Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 282431C62CB
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 23:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729210AbgEEVQL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 17:16:11 -0400
Received: from mail-bn8nam12on2043.outbound.protection.outlook.com ([40.107.237.43]:18785
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728135AbgEEVQL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 17:16:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JHFAIa9US3xdkZu6Y02c4jfO0LXjlSx1f19EyGTQKhYbJknHdOR6yiwY73e8wWE724tsrkOYGJtSw98YqKN7cFcO8909meC2tjqn5fiNsisO43EVkhmq4Lf14muzB0dOdJ0sJMMBQjLSioHyfWASAKmCHpvGD2Ae1BAsuKavDP9jaJhn6wNJq8Cazg6DwBF6JYoSL7P0XfVfnO+GBahMQaGnhQ7sa3JALyeHQEmebMVA7dHjNCuwUsVllju2heFt1q2pDKe/8f7hL+y0CSOlfVEuP3pEt3P8bhU6sHtKPAWRf/56uMGJUOTgWrHqrXjzM0PLTbTboTDgBRWlvAN3+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V/EKHUhHpQNT0DbA78p7H6D6PQBYjPxCDqiXy0V866g=;
 b=SLmFG6wa2LHLG+DH9kr7ip2goKjz944PIvgW4B0Xk9p6xzNi8KcYJCN/8WBSu0X47J9dVUwOZv9VBhmt+bMfE+CLsxaiVni+qK1oRosjWDVis0j0rCimvRKvatLG/IcwsPbhVVhhwd7hTCKdjW8FzvIBOz7QRuoDGBUE1899msSM28paIzVhIrSl7o+lnVeOms10Wlw3kgr80grRrnEsVaqUo6X+K37D1yc2epnUfIxDjxReijYfEWfrPvCld/dMuKk+ZwbauFMwMKJjmMO3HNu/GkkisDAkHX5YuyKx/8R78ed0wkbZDGx/z/t3UVSf9VFSBetQHlfdZFgl8G8CFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V/EKHUhHpQNT0DbA78p7H6D6PQBYjPxCDqiXy0V866g=;
 b=d/6a7tStcj/W2p3P6rDst2zvry/gexTp+VFyeAyg7/r7MLxbtkVu3j18AxZQaXuArXpu6tzHG/FMxcVC4qsEpGu0wsRj+phv3X6rNAqmWK+v1x9GLjNmtHT/vR8K7uzRDuBD1HhQnY57T7VTZJD+Wcud8GIt+MJLgUFQ3EUmrzs=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB2518.namprd12.prod.outlook.com (2603:10b6:4:b0::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.20; Tue, 5 May 2020 21:16:08 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb%3]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 21:16:08 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, Thomas.Lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v8 05/18] KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command
Date:   Tue,  5 May 2020 21:15:59 +0000
Message-Id: <d7495b194c5727668fab1714e71a7a8f839aef2a.1588711355.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588711355.git.ashish.kalra@amd.com>
References: <cover.1588711355.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM5PR2001CA0012.namprd20.prod.outlook.com
 (2603:10b6:4:16::22) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM5PR2001CA0012.namprd20.prod.outlook.com (2603:10b6:4:16::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Tue, 5 May 2020 21:16:07 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 72774dc4-3a00-4d49-89bc-08d7f139872b
X-MS-TrafficTypeDiagnostic: DM5PR12MB2518:|DM5PR12MB2518:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB2518E40B6B71747AABA1DCC48EA70@DM5PR12MB2518.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kL/AVCtNoxdxkAXlZEkVD6uByIPFgnsjXbXQqh6fJN+h5kmoynQY0pfT4Ge6WCeVUXLnUyZJq1k3KndPb+E4vWoPNqBcyaSNCb2MWyyuFLRf1C+L/PoJZND96WLED+FLh7qsKoBMeXWDi5RqQ10YJZuSjF8H20sbeAMyKHitHepvqauzwwsxTLErmFAI5yUiwgfZY0REXH1kn1Kphz6BX+Vf+2jdlqhS3h98KnSMEAFcwE+IAThnr984VQzx9LfFrhAH/Lgyj8m3PmUz9Y6hf1fp0wHFAgqFjhyVIOCxnGejGH2ecBwJgHXWg6GU5AwZi1gVzKApaz1Wg4KLKdCh9yB7zOmg44vQzcFReNvjltLeb+gVd1FZhjkea3BPoAIxgGvTTmWu3hDHsFzovp3E9hjaYe5+o+klhPkfOgjrAxP5ocI07jq1ZvpFVUg7yFQ7OGDxYU3PZ1FwTFFrO0yxoO+MaBTNOM/0uhlW58f4cvaOKrALUJ0ENy9Xr8pamSNI/4LZLZl9xAyS28Ov9OJqjHwMM4ootm8XyKEePFPHGoJ9K61Ntv7HnvxHkTtStcQh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(33430700001)(6916009)(26005)(36756003)(956004)(16526019)(478600001)(6486002)(2906002)(5660300002)(6666004)(2616005)(66574013)(186003)(66476007)(7416002)(52116002)(8936002)(86362001)(7696005)(8676002)(66556008)(66946007)(4326008)(33440700001)(316002)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: rDcNK8BB0PvoJCY68iZQQMNu1Gq+dyn/W0tVpXqc9kBp7qglFr4G/82iCkw95iLS5fm4BbVHdCYoldHPttNNM6MK/NqVCenEu1DRGXdWVasGBCIQtiaCRBGBDf5hNrDSb5R4OLDppc1pmW+cCmXck3FVlxg0UL6C+4WJblIcBC5emHDeXeMNWrJlzo35fi3B1pJxuhIsHjTOfnR2zwBmNWg9iO7kAJjoFztSk3WxAO2dBKsYTtW7K741afb91RosWtJhvTiysA0BAN0lGAl/TWoYC2CQpI84gV3E18cmWuUO+i10Kibi8xbCMhkA7hyBq+BcE06xmtE7MqrJE1/I3dcCiGOuLmDWt5zNlOZf6mR4eEGy7kYxeScfifZ6Du9zKFNE9nZ6B8+Dhf4PPFyZJLHlrd0YpUwrne3FZ0eHOR1hsxqYY8K2tp47TiWqDnjB2DX/YAntutBL+R9EtH0YtFDws9t5o3qkI2GeIHQt4potPQrSRSPUl0wRbAGr8tEjgbrAOVigt5WsI4hRGB1PHFBDuI7sniZxF5Qm9G9yyDkmlJBkmbRdIi2ZJNO9/hNIwPk4rxE5eyh008QlqaXB/2VXGYH3a05vUyjDUeJMrnDe9HM6bqMeZM8XjjiwXJPBJ9lGV7mtHcbL1SE7EBIk8qHR51kTVExJ404WL7OUqg3XEHykvano4vz4fXlo7DWOCaYHCfz8qWQL45G3ODtOKFAQf6nDjf0fkJvVFtsvY0Ynf1BDeNwYLsfFcKs7lBswLnXrEMAwqf50ilYDiEh5rB3qig7YZSPPQ5WYdrDDong=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72774dc4-3a00-4d49-89bc-08d7f139872b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 21:16:08.1630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j/nAyh3Zd2ibsT+F8Dyaux8t4A0bwY3Xt07rB8JZ640etdnru5lgq4awjbxx5kWra4ElB/vFxcMPC85xNMCpbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2518
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
index 337bf6a8a3ee..04333ec1b001 100644
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
index b575aa8e27af..165a612f317a 100644
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

