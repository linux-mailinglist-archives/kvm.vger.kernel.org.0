Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 136B2197221
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 03:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbgC3Bjr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Mar 2020 21:39:47 -0400
Received: from mail-eopbgr750041.outbound.protection.outlook.com ([40.107.75.41]:37124
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727801AbgC3Bjr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 Mar 2020 21:39:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CKgCuS++UOjwBK7BCTuQ31njNZAzLVzebPpLhxexQGRuXoA1hcn1JrxZKl3h1PgCskfSicGzgtqdR1TVca1ffcb4HKEuwe2eswuMVBDPfaumq9luvU1gT4vUkaHDPOwYoGAJYhs+rbIUG7h5dZ5veND1EEtnY8ja72tnC1AStFTgu+U+NCuc73WaomSbiz5kSRLotncUNFXz5ZXyb7ZzH7TxJLzgczboBpoB/OFKuugOrS4F5hAybx8UVCmS7nVW2QeXrZcRXSPtbg9w/n4ENV4zLVyysZmwI2nIZ/cCY21gj7f5zrC0Rb4VV2zGbLRQTeqLpjSp/J6s+aiH7V+wlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=coEXQKta0i8hjS/TsVIf2MiaJHX/DIbg2a4S2sQ4Vx8=;
 b=DvuFmWfTperzvEFc6TOim8ffvHmkbNAbGlSkkLiU4Lf5ojg/mM0IEEy+ok0XNJKteC6sLLw3Od8WesW6RFnRfyancCB5OeKhuG/Q4px5B6SD5fqQDI3KhT8wrN+7ls1/LXBgazGZTPiYErfnauRC52LODoONmSzcwTM/s74psyG4HxWQJjzzicwguhoS7snBlBr9rWsR6gKa2TsTbhO8wk32cNPGk8rWq1gl/Nm7lItqtiurS97PdEp+7xr2YjnRQ2XM5GrRp0/YA53EiXUqgEeGu6ZNuzAarzzttvTG9oKt7HWkPW5RMS3c80ZkMVYFQjaNwtzhZ6odgGGZKJl6KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=coEXQKta0i8hjS/TsVIf2MiaJHX/DIbg2a4S2sQ4Vx8=;
 b=IvGYtCKJxbVX9+K1ATfdf8OlUk00UC2EHcaN7uu0zsTPa1ZdDDpzbs7N9hLEBb14pkxxSW5r5fnjXi8kQO6JuqxDVOQkAOm24cdcrNTGdXczGL9ZvbsVtQ4cU057LKiGkjsd79ioW2KYlVYqD8KcXX/4N5msbiqB/YKt2eQI7SI=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1387.namprd12.prod.outlook.com (2603:10b6:3:6c::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.20; Mon, 30 Mar 2020 01:37:49 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 01:37:49 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, srutherford@google.com, luto@kernel.org,
        brijesh.singh@amd.com
Subject: [PATCH v5 12/14] KVM: x86: Introduce KVM_PAGE_ENC_BITMAP_RESET ioctl
Date:   Mon, 30 Mar 2020 01:37:39 +0000
Message-Id: <3a6b8429065e7d8367ee225775a31293da87dd58.1585531159.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1585531159.git.ashish.kalra@amd.com>
References: <cover.1585531159.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0501CA0150.namprd05.prod.outlook.com
 (2603:10b6:803:2c::28) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0501CA0150.namprd05.prod.outlook.com (2603:10b6:803:2c::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.9 via Frontend Transport; Mon, 30 Mar 2020 01:37:48 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2ddf5b56-c1d6-43fd-a354-08d7d44af4b8
X-MS-TrafficTypeDiagnostic: DM5PR12MB1387:|DM5PR12MB1387:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1387B802757B7561C0011EC08ECB0@DM5PR12MB1387.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0358535363
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(186003)(66556008)(6666004)(66476007)(86362001)(6916009)(66946007)(316002)(4326008)(7696005)(52116002)(5660300002)(6486002)(16526019)(26005)(36756003)(478600001)(7416002)(81166006)(81156014)(8936002)(2616005)(8676002)(2906002)(956004)(136400200001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +HnJ/BOndkpTw9vZ2HRo3yMJrkb+JZKp+kiE5oXOD/KB/SaeMtIploMLfB2UHRARfrqtv4IFXu5wEPuYsRQW3hnRdhLoDYMzlSWm5oqLy6QflwHyGu9VvcWbvDmV7uub9+Prx6AGcMLLbipqmVwuFB5S9mcxjHx7RsbhPtCJQ9SKdnUcreiwz/C05M5DQdktcrQRgdy2Kvesg03A7Gor93/iqosnCCLupDcNALVkr+I68YBrYAFG13P4IdmEk3qwqzDLL8hWN0DdkLdD/j2DWlw433LED5Zz39eJ3NmCIYNi38bIfx5gSmx5pRcJv4Ughl5sp1JKF7Ktnj+7KwzJjm+qsHCpdTqWDa6f5pu7vpIGYszpLmK+QS841BGVziiohdcdmT5rZAbdu1BwN9jkCT0vwj1CmEBKWWXje4jHEkhA8FS6s3+DGQIruUmKrDoBdG5Z0k6SZWN5ojPbp+vjmVCvQp9ywjkyiI3+CWWDbmBP6S5EnCqT0V+g6C2chYPL
X-MS-Exchange-AntiSpam-MessageData: 40Kq2aDyDB2dnhqd6GXu9TKF2uFZxPmXJCpH4O1hiCHwqhj2CeqlO5zQgsKHrPzcrNNuFbg+grhLi9XuKHq888s7ftpXv1AdE14rF8WS5uZfON1gJoiS1uGj8/mfqQzbTLsishMCRB3/YWHGKlxslA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ddf5b56-c1d6-43fd-a354-08d7d44af4b8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2020 01:37:49.6203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8JGxUn8gnDcJSOhjv7fXLYQEp6D8/gTI/7LY/B48wjmjCRCjuwpOqRdE7huXaS6U7VTAhjaLbdAaALZvo+dc4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1387
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

This ioctl can be used by the application to reset the page
encryption bitmap managed by the KVM driver. A typical usage
for this ioctl is on VM reboot, on reboot, we must reinitialize
the bitmap.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 Documentation/virt/kvm/api.rst  | 13 +++++++++++++
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm.c              | 16 ++++++++++++++++
 arch/x86/kvm/x86.c              |  6 ++++++
 include/uapi/linux/kvm.h        |  1 +
 5 files changed, 37 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 4d1004a154f6..a11326ccc51d 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4698,6 +4698,19 @@ During the guest live migration the outgoing guest exports its page encryption
 bitmap, the KVM_SET_PAGE_ENC_BITMAP can be used to build the page encryption
 bitmap for an incoming guest.
 
+4.127 KVM_PAGE_ENC_BITMAP_RESET (vm ioctl)
+-----------------------------------------
+
+:Capability: basic
+:Architectures: x86
+:Type: vm ioctl
+:Parameters: none
+:Returns: 0 on success, -1 on error
+
+The KVM_PAGE_ENC_BITMAP_RESET is used to reset the guest's page encryption
+bitmap during guest reboot and this is only done on the guest's boot vCPU.
+
+
 5. The kvm_run structure
 ========================
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d30f770aaaea..a96ef6338cd2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1273,6 +1273,7 @@ struct kvm_x86_ops {
 				struct kvm_page_enc_bitmap *bmap);
 	int (*set_page_enc_bitmap)(struct kvm *kvm,
 				struct kvm_page_enc_bitmap *bmap);
+	int (*reset_page_enc_bitmap)(struct kvm *kvm);
 };
 
 struct kvm_arch_async_pf {
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index e7fa196f3de1..d74773573811 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7796,6 +7796,21 @@ static int svm_set_page_enc_bitmap(struct kvm *kvm,
 	return ret;
 }
 
+static int svm_reset_page_enc_bitmap(struct kvm *kvm)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+
+	if (!sev_guest(kvm))
+		return -ENOTTY;
+
+	mutex_lock(&kvm->lock);
+	/* by default all pages should be marked encrypted */
+	if (sev->page_enc_bmap_size)
+		bitmap_fill(sev->page_enc_bmap, sev->page_enc_bmap_size);
+	mutex_unlock(&kvm->lock);
+	return 0;
+}
+
 static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -8202,6 +8217,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.page_enc_status_hc = svm_page_enc_status_hc,
 	.get_page_enc_bitmap = svm_get_page_enc_bitmap,
 	.set_page_enc_bitmap = svm_set_page_enc_bitmap,
+	.reset_page_enc_bitmap = svm_reset_page_enc_bitmap,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 05e953b2ec61..2127ed937f53 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5250,6 +5250,12 @@ long kvm_arch_vm_ioctl(struct file *filp,
 			r = kvm_x86_ops->set_page_enc_bitmap(kvm, &bitmap);
 		break;
 	}
+	case KVM_PAGE_ENC_BITMAP_RESET: {
+		r = -ENOTTY;
+		if (kvm_x86_ops->reset_page_enc_bitmap)
+			r = kvm_x86_ops->reset_page_enc_bitmap(kvm);
+		break;
+	}
 	default:
 		r = -ENOTTY;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index b4b01d47e568..0884a581fc37 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1490,6 +1490,7 @@ struct kvm_enc_region {
 
 #define KVM_GET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc5, struct kvm_page_enc_bitmap)
 #define KVM_SET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc6, struct kvm_page_enc_bitmap)
+#define KVM_PAGE_ENC_BITMAP_RESET	_IO(KVMIO, 0xc7)
 
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
-- 
2.17.1

