Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47FBA15B690
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 02:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729472AbgBMBSm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 20:18:42 -0500
Received: from mail-eopbgr680058.outbound.protection.outlook.com ([40.107.68.58]:29926
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729401AbgBMBSm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 20:18:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BR2b2USINx5PTmdLQ38a7TGuUZTs3qa6DUfclG7LaH8zdUvwMDiuhRmTRCVVnZMdwAHYiXnLqvxON0t/+UEc/dHrCzRpYKlcoTAMcGGIudpa9DBPhgCIl4lVhmzi8y/giixI1MwS7NeQoZ7RKFMNNA9hWfSuhxBqxm8DLtLHeCJ3Urgq0bVlj+BZUT+ln32Z7AjJxsTfm/9HTetVpKZJ0e2h1dMUMBmiN06+/7xo8/sYbv3Kp1pYOwmxrwxi8uc13j/l8CmO4rOYIi5ustfiGxNZ36l8U2MoMfR1F0X2ln+c4FV9c1mGCJac+lHMp3pAMV1v+ShQn66GrJ41QXG2eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ED3x3T23R/2IY5Yo8F/wTx+qVvyPpmSMS5bdCyjSBvg=;
 b=ff5Et+BR9RUMGuTlZByawgGPZB166+qRyVDhOkPbNUJ0uSn2fgSmrVrt3x09OF3lvsToV+7ANdfHcUweyAXVdX9GnPjmpUQTMzyp+wnIcHVGQuUU5boBUt53VII3muGD4cfC0Sg2BtzeosEP6eUx4jbXLKCCznnFrd8oc4CTBZx6vSJYL2DS7MWXa+wmy+M29cIFXjooIdAtQV4DJ7K42x/oOU9cZTyKQ1s6ohUz2imVI1GD8nD10tln0qn+R1pYwEf0NXssgc87xn+1+wzDIhbizP5CEETri+xWiQPLVdSxi2Ky5nl+V4r5ze67C61lEJae4czsnXySTgaJyh8atw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ED3x3T23R/2IY5Yo8F/wTx+qVvyPpmSMS5bdCyjSBvg=;
 b=EpRekUDNc+4wJ5KsEchlmpmuxUdQlNqX6gLBhLk4/ioi3ypFzaEa8VTukaKh9b5xQPpVKoDX7nLLzEgQrjZ9+NXH6qfy95WX8OrOjaDgvxmnHki5zlCOwjYzI87jtDdrunnnUyF/rKTisZawLCotcy6m8Wq5xHAbhdkfNH0nLw8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from SN1PR12MB2528.namprd12.prod.outlook.com (52.132.196.33) by
 SN1PR12MB2366.namprd12.prod.outlook.com (52.132.194.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Thu, 13 Feb 2020 01:18:38 +0000
Received: from SN1PR12MB2528.namprd12.prod.outlook.com
 ([fe80::fd48:9921:dd63:c6e1]) by SN1PR12MB2528.namprd12.prod.outlook.com
 ([fe80::fd48:9921:dd63:c6e1%7]) with mapi id 15.20.2707.030; Thu, 13 Feb 2020
 01:18:38 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, rientjes@google.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 12/12] KVM: x86: Introduce KVM_PAGE_ENC_BITMAP_RESET ioctl
Date:   Thu, 13 Feb 2020 01:18:29 +0000
Message-Id: <042534206aa0800f9eeb038176e22c3ab39df11c.1581555616.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1581555616.git.ashish.kalra@amd.com>
References: <cover.1581555616.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN2PR01CA0065.prod.exchangelabs.com (2603:10b6:800::33) To
 SN1PR12MB2528.namprd12.prod.outlook.com (2603:10b6:802:28::33)
MIME-Version: 1.0
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN2PR01CA0065.prod.exchangelabs.com (2603:10b6:800::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.23 via Frontend Transport; Thu, 13 Feb 2020 01:18:38 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cb14941d-6858-4d18-3fe2-08d7b022a7a1
X-MS-TrafficTypeDiagnostic: SN1PR12MB2366:|SN1PR12MB2366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB23661EB040DFA771679E53348E1A0@SN1PR12MB2366.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 031257FE13
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(199004)(189003)(8936002)(5660300002)(66946007)(66476007)(66556008)(7416002)(2906002)(6916009)(6666004)(4326008)(7696005)(52116002)(36756003)(6486002)(86362001)(956004)(2616005)(81156014)(498600001)(8676002)(81166006)(26005)(16526019)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:SN1PR12MB2366;H:SN1PR12MB2528.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JlMNLUb/toR0kEPg+34wa/RyTDGvy74e7YaH0UKP3L6OBKqorYx1gesTEk5VvdAbplkWRM4iGWP4AI9g8YpaRujgOug2RpUS2yCObHQqyvBug7BzyYGjZbWfs591GDuVqEIsG0OVQWtAPk1mZbOQ8rlTu8MlYtW2r1lbg6dwXg25K0ffje3Iepe1L9ymHl4RZ5kAxrLQX1fM7Iv6g+vXOJXn7/bcZmL40s2SXuRcVgyLx4GrnXIEgWiezqEvw7uKhf9zj4YwuVH9mf75JjbA6WxmI7dQmcBoRE1wiLaiOQkp3/91QNGnzi+PK1CGc/T2fDO1JB1O27/VXkhlancH22Xhdv49dBqTgs5EiF7dznSoYIg2R5HI/ySRpumi6jlW0FORi6fhdl4fJHemwXjxON0Tn7uHzRZZ/X/Bai8UZH3k8Lea1KzIFooRYQpcNhWl
X-MS-Exchange-AntiSpam-MessageData: rjM3+VzRbhbkiPivU4YSJ5wsf1ZXkeDNYMNLcXtv0x9Y5MTGS9//oNfe4WfTcXFbV8zx8Do4v+PU32dcQVphmsDMJFF37+mj2nU3rmnaPE9kstlz0DtarHgZiMUUEk7HWl5nmAHx8pReqD4qRfqa4Q==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb14941d-6858-4d18-3fe2-08d7b022a7a1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2020 01:18:38.5073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PIAAhvcXl08rdGfU8zEtEuNgKYRN0xidUv1rVLf3W7h/BU7GKpgxi4BsLndtt+kVr3BkZzRHdqdKFiCqhTYKzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2366
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
 Documentation/virt/kvm/api.txt  | 11 +++++++++++
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm.c              | 16 ++++++++++++++++
 arch/x86/kvm/x86.c              |  6 ++++++
 include/uapi/linux/kvm.h        |  1 +
 5 files changed, 35 insertions(+)

diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
index d4e29a457e80..bf0fd3c2ea07 100644
--- a/Documentation/virt/kvm/api.txt
+++ b/Documentation/virt/kvm/api.txt
@@ -4261,6 +4261,17 @@ During the guest live migration the outgoing guest exports its page encryption
 bitmap, the KVM_SET_PAGE_ENC_BITMAP can be used to build the page encryption
 bitmap for an incoming guest.
 
+4.122 KVM_PAGE_ENC_BITMAP_RESET (vm ioctl)
+
+Capability: basic
+Architectures: x86
+Type: vm ioctl
+Parameters: none
+Returns: 0 on success, -1 on error
+
+The KVM_PAGE_ENC_BITMAP_RESET is used to reset the guest's page encryption
+bitmap during guest reboot and this is only done on the guest's boot vCPU.
+
 5. The kvm_run structure
 ------------------------
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 698ea92290af..746c9c84d14a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1262,6 +1262,7 @@ struct kvm_x86_ops {
 				struct kvm_page_enc_bitmap *bmap);
 	int (*set_page_enc_bitmap)(struct kvm *kvm,
 				struct kvm_page_enc_bitmap *bmap);
+	int (*reset_page_enc_bitmap)(struct kvm *kvm);
 };
 
 struct kvm_arch_async_pf {
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index a710a6a2d18c..1659539b1873 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7756,6 +7756,21 @@ static int svm_set_page_enc_bitmap(struct kvm *kvm,
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
@@ -8151,6 +8166,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.page_enc_status_hc = svm_page_enc_status_hc,
 	.get_page_enc_bitmap = svm_get_page_enc_bitmap,
 	.set_page_enc_bitmap = svm_set_page_enc_bitmap,
+	.reset_page_enc_bitmap = svm_reset_page_enc_bitmap,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a1ac5b8c5cd7..eeb2a3dfeb02 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5237,6 +5237,12 @@ long kvm_arch_vm_ioctl(struct file *filp,
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
index 2f36afd11e0e..4001c22cb36b 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1490,6 +1490,7 @@ struct kvm_enc_region {
 
 #define KVM_GET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc2, struct kvm_page_enc_bitmap)
 #define KVM_SET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc3, struct kvm_page_enc_bitmap)
+#define KVM_PAGE_ENC_BITMAP_RESET	_IO(KVMIO, 0xc4)
 
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
-- 
2.17.1

