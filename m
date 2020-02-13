Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 752B215B681
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 02:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729474AbgBMBQ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 20:16:56 -0500
Received: from mail-eopbgr690076.outbound.protection.outlook.com ([40.107.69.76]:33177
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729471AbgBMBQz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 20:16:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PA5C5m0Gl9+6iJ1g3oM+hpPgbq1H4htRO0zV8cqis/F36/R9CaZrGEx6x4qtprJdlXC60J9iRU79ZLHuqV+6wd+/lyXN9otTjthSXwX/SRVnX5R6wap7lg3qailFQiRyHPh33K8JvlFVRak4YInbfgL5f3YZ8Ci9t8/Uh3sDiGltPJ2FMdyOj4nGNYEtt96g3rzyx3nFbDSaW/Rvpr2mzmEA1V/pE2LfSLwYRxQ8G4e99wg6M3qumLwfO/4wojsI9JtTLMFYec4YBhpehMrKWn1QajJh1fYOaK6Xuxef3S+TIs/8huXZv9/6j3SB2zBeFbR6WZ/MiT6SPgVvu22OQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6j3ax/5Nr5Um6CDjrC6SKBk9X2dyMEERxprdBaAS7n8=;
 b=VazKbDQ561uSmTZmg6u+TscGEpJUms+b7IPpmK6S7w/qLayJJc9o5qTBaVjLLJO+ixr+i3eeVfjiadSIUUrEOUTQD82k3qqYIqIpHHvBsVl6orxEmAoyMRPCE9b/7BGVMQ5Q3LFFwuSl/z/JJRUgYrEVI6FjKXiDhGLAkJ8wwMVnU9f3YamQWaTbxhGE/GU1PNWUHn1BUcYWQzU8V7E0Ubxr2tlHNNlc/MEKOlrsfd434n+X+/Olzy1JFJHrCwk/oo+yqCBhUrXhWVqyIqMpbhs9vngXgQqd32N+ffIprInbYyqhZ+ZQo/CKRczRmSCOMCFizsrJlRUk7AlFYVzNcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6j3ax/5Nr5Um6CDjrC6SKBk9X2dyMEERxprdBaAS7n8=;
 b=axWO7rAO5fQJtemrd+k+SW2QifwkoZWJScUtN2K2GfatOM9qR59VdSNUNC10k1LP1G6d1q5yJDOc10bLlLnNiXIT6+f5DkAkBI+3FMd2PiWS3ISSPxFSDi9LviRLvSyLmIn7c7GaVKrwVE1rITOKLadkj8mORWHAA4Z6vXgC3jw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from SN1PR12MB2528.namprd12.prod.outlook.com (52.132.196.33) by
 SN1PR12MB2366.namprd12.prod.outlook.com (52.132.194.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Thu, 13 Feb 2020 01:16:53 +0000
Received: from SN1PR12MB2528.namprd12.prod.outlook.com
 ([fe80::fd48:9921:dd63:c6e1]) by SN1PR12MB2528.namprd12.prod.outlook.com
 ([fe80::fd48:9921:dd63:c6e1%7]) with mapi id 15.20.2707.030; Thu, 13 Feb 2020
 01:16:53 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, rientjes@google.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 05/12] KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command
Date:   Thu, 13 Feb 2020 01:16:43 +0000
Message-Id: <9d9166c94a1202285d674f4c5ae6be2b7cdc27e7.1581555616.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1581555616.git.ashish.kalra@amd.com>
References: <cover.1581555616.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR07CA0048.namprd07.prod.outlook.com
 (2603:10b6:5:74::25) To SN1PR12MB2528.namprd12.prod.outlook.com
 (2603:10b6:802:28::33)
MIME-Version: 1.0
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM6PR07CA0048.namprd07.prod.outlook.com (2603:10b6:5:74::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22 via Frontend Transport; Thu, 13 Feb 2020 01:16:51 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 92e1e255-81c2-4e76-f40c-08d7b02268e0
X-MS-TrafficTypeDiagnostic: SN1PR12MB2366:|SN1PR12MB2366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB23662B10653E0A16FB592C5F8E1A0@SN1PR12MB2366.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 031257FE13
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(366004)(376002)(39860400002)(396003)(199004)(189003)(8936002)(5660300002)(66946007)(66476007)(66556008)(7416002)(2906002)(6916009)(6666004)(4326008)(7696005)(52116002)(316002)(36756003)(66574012)(6486002)(86362001)(956004)(2616005)(81156014)(478600001)(8676002)(81166006)(26005)(16526019)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:SN1PR12MB2366;H:SN1PR12MB2528.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: npSP0d4OWxhMRHMvqE+dXwNzX0bemqvbLGUSFqskl3/GTW2GiI0HI4rEDFvG30NFItTbxq1L11ck3doM70+tN0krv1FsFrAjSACuOWS+cmxUYyd7UUPovkeRAp5JsCsSCqqmxeY3yUoJLsQkiAIq5HJYfavdd6oetFzz8+jPtv/YK3Z5nE6Q/euoUMnc0tU3IBU3FZQRdEI6oizqqr2njIs7n7n87FAVs+KNv+SaKGvQ41tLUeETY2sOIHe2+8pY7faTv8vjug2O6t+hbJtHiTp3+dnfSpWKHiXm/TEonxYTkLu+KvMDNZWcFttQfsQLgeAL2SAdLUWG7iExvN3Z0K7uCxj3O4rxAPiA/kY5bqEn8EzRvcLB2NWcbEFt4mx5MolfGSkzAFAQ3HQycbQbmtMw/EVPQ6ZdDbYVB04XOh4rLjGoKb/edITP2Prpm9n4
X-MS-Exchange-AntiSpam-MessageData: 2zKk16UjEdBXRSlLOoqO8A4Y2anc5GIQ1mROtLk+UaKAeHt8j2Ux0/SAcw7LdWKiLHYmnJ21ObITKuGc8YZh1Ovc6sSlQkLPH73uaLD2DU6wcu8x4VasWFR2wuh5WmKILqTrqU1lWqcUt/neJwgmiw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92e1e255-81c2-4e76-f40c-08d7b02268e0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2020 01:16:53.2313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mMGhzlyvYk8IkUs/XfaMSdLzXqIrtig5c7TfXzc0QdJySrBzEKpD/cOBKvGjyS6GEKYhyfWgq0WO1Z942E40xQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2366
Sender: kvm-owner@vger.kernel.org
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
 arch/x86/kvm/svm.c                            | 79 +++++++++++++++++++
 include/uapi/linux/kvm.h                      |  9 +++
 3 files changed, 112 insertions(+)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index 4b882fb681fa..52fca9e258dc 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -326,6 +326,30 @@ On success, the 'handle' field contains a new handle and on error, a negative va
 
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
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 3b766f386c84..907c59ca74ad 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7485,6 +7485,82 @@ static int sev_receive_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
 static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -7538,6 +7614,9 @@ static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
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
index 74764b9db5fa..4e80c57a3182 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1588,6 +1588,15 @@ struct kvm_sev_receive_start {
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

