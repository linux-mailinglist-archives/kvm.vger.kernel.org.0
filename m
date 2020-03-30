Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59592197470
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 08:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729197AbgC3GXe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 02:23:34 -0400
Received: from mail-dm6nam12on2043.outbound.protection.outlook.com ([40.107.243.43]:5248
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729109AbgC3GXd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 02:23:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bRaVTp9NKf/d9csK2y7Yab5Y3Tu/F2tmKGXeknsp/tomyqlSgXjByZxCOhx4dI3nM8a8Og1cP4OMWiJ6JghifX6mcwbUIjnbCHWBhmpaAPXtPX3amDjdSCEkdaVW6y1vlb8R1b5zs2elnVLpH/3B5fzD82zqylOQwqpVGm6jEkhwmseX9SshvU2PzZfJNuHHmB/tiXq8s+sLPLfktIlzhKplQvsbibr8am+DGRe8JmYTtfR8vgAcqqegwSFtgmjemDvOR35WR8X1tRwGvrJhZ93DXB0jJKqxEzeJx/qRRDw6SVJraEEPaIaeLigqGUC/jGIYB7khIIJ/2G3zhp9CWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lxhyB6GM8IKZeRDrarcQ85YwcLCO4aV+65O8KJcvfxY=;
 b=Bz5i/09jMKr1nmXAtq4OFg9/n7iqC+7Uk+qCezmtuszbRoxxVe0lwlWATZkKyFjzS2S9G5i0k85ghevHzm5hs12IXjIAOyWE0fM40K2U0ktpOEz7SIA7q/YZ4BTU0UKzQLsZrCU5co8TxBKvf/mkM/H4BOekpdc/UDZb6dntw+qLXeLrXaviQFt/caA5XAbSdCeAIZURkDZmcl6BU3nmqG3Uv8Ainnq4yr1RsQoVroIn3FqGTvbnv9B/aLl+Wqhmo8VqBH6iinXd80hbnvXmz0TM3s93Pf9Gc2dN/MpeRYDW2iTuFOLNTV2Sb0BbPG9XvIIDAvKx1IVdbHlJsvVaBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lxhyB6GM8IKZeRDrarcQ85YwcLCO4aV+65O8KJcvfxY=;
 b=bRHDdgSies3Fq7LYcLV101K5ulC9bG+2TmhePSRxeg8Fx5za1uss6qANVgSWmkjswdLAa+6tntK5C0kbzA/iRyu0qxMfoKrRez46Skz+3gnJg8DnfUpQWa/QSdVjB+xCRpFHSzx2J9T/mKXpWJyd+7GILPkSjHLkBu382XwevGg=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1692.namprd12.prod.outlook.com (2603:10b6:4:5::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.18; Mon, 30 Mar 2020 06:23:19 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 06:23:19 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, srutherford@google.com, luto@kernel.org,
        brijesh.singh@amd.com
Subject: [PATCH v6 12/14] KVM: x86: Introduce KVM_PAGE_ENC_BITMAP_RESET ioctl
Date:   Mon, 30 Mar 2020 06:23:10 +0000
Message-Id: <9e959ee134ad77f62c9881b8c54cd27e35055072.1585548051.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1585548051.git.ashish.kalra@amd.com>
References: <cover.1585548051.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0102.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::43) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM6PR02CA0102.namprd02.prod.outlook.com (2603:10b6:5:1f4::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20 via Frontend Transport; Mon, 30 Mar 2020 06:23:19 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9398f8cc-4d77-466b-e3ba-08d7d472d717
X-MS-TrafficTypeDiagnostic: DM5PR12MB1692:|DM5PR12MB1692:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1692488F837BA1C0D22D1CC58ECB0@DM5PR12MB1692.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0358535363
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(136003)(366004)(39860400002)(396003)(376002)(66556008)(86362001)(66476007)(478600001)(2616005)(956004)(81166006)(52116002)(8676002)(81156014)(6916009)(7696005)(8936002)(5660300002)(6666004)(6486002)(16526019)(186003)(26005)(66946007)(316002)(7416002)(2906002)(4326008)(36756003)(136400200001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j0Ucsobq5BE1Ne9a2TvK41rjoTbreLkCgMtbXSqm1ti4xYf3rInTveQmU/aPm9Edq5uLxsB1IOpX0HhHrV6k2I2bnd3VDdrVfRNyR6rSBxarVj+uxfZSiIXgF9GcQb3Z9+XHyaoK5BGRYWvWNR8C7haTvn3dAs8fR6wpftAgB82l8duZUHmw23HCCpXetxGbRcc9yijiNjGJ2Cbpa8t/Pg9Bmoe8hN8fSRuDLaZyBYcdgAilQUJUwHZYTpXacZNihsEfM22K31W8wulXWp769obIazjJBDy+A3R/I/P6z4ISy8wfLJ/ZGSipdlXXSaardMhNYyLnPbPE+c2uglWGP8mt6p8CdHw9z8SCbHeLGlPhbrkEGmktluf4tZm51gHDhdp3Nf2ypWl/EO70TWN/JeG6ZT4acM8VARn2CyWZlrNYvI+y9YZU0ZYNCOJAk4XCNYPZVkLCRA60PHpvF6h984tSBurpq3DvBD5WUZWbBDy+yRhCXi7JlHk7hBGSY+Y0
X-MS-Exchange-AntiSpam-MessageData: ZCUKWaKD1DnD9NZ6aHsYAWG+bHtiophnrcfhYVcWWJvaLaNrAlYFo3tQVOpslEcN7xa6Qhl3cTl8ptYHdOs2OZvOs+ic9WdeMmI5IhxTAgueH4WH73SdVoZyDHZYAqVmisMzoP2whD+bEfxGVsqfgg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9398f8cc-4d77-466b-e3ba-08d7d472d717
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2020 06:23:19.7611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ndyCyRELWtGV2YS9+9IOmBYTgYZ9AD+C6GiJh1hfknIP+XY6B3NGkBb6b33yjYvTS7WJfnepQkcDi24VYkNumw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1692
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
index 313343a43045..c99b0207a443 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7797,6 +7797,21 @@ static int svm_set_page_enc_bitmap(struct kvm *kvm,
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
@@ -8203,6 +8218,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
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

