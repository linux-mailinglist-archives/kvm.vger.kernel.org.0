Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 708B11C62E0
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 23:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729498AbgEEVSV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 17:18:21 -0400
Received: from mail-bn7nam10on2041.outbound.protection.outlook.com ([40.107.92.41]:6189
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729031AbgEEVSU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 17:18:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hF7eVkx7IQLKj69PWKAvybHL2Qa68Rx7gmbJ4nKX0PHA8vAK/V5TfVQEMUpJ7Z+PTc6HDy/AnHoEl3lHzYeoA3wWVgSS4VfCYNKRtKlycC+gG9i6J8FRT34cPs1hPoi93V8qmnvPmfcym80ZdjY8IfrVxqE5CvdiZ8F2kdtCGIQNUFHw1TmvlS+Y17R8KNZ2GxsxzTG1iNvU8Lfq8KcqxZkP/StyfKi5YxbdeIdVigt0F4eQXTAFiOz9OM0pFNLhYPPksSB3pQ2lom1cyjb1UfomLHH55LA6cuTaNWShsjk2jYMSAGmi62+txXJhJ0MmAdQKqmEHwjaq6XG927wW9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4d9nd2guchaUPlm62R2CFdQ0ghiakGkEXEeHVbGcpME=;
 b=oSXEkhsrMQ9bc5/ezyBkKfw/M+zaxvpJtFHpWhKmi8S/nH14DRjkG1ZCmt5jFgWyXJyuug03s8kX/IKo5DWNPipreUMQK9iZM0HnsyeD0E+29IuJKtAOXGKOfAgg32wmBccH1vDzlrr3/2tON/1Jig/Gw0ttVxWDZrmJMlTYCrXhASXIcLFvzpjNDBLDQ6ksDLB0kQnFKLJ3+UxL//crWEKIhwyVy2NI00HNEDk0i+pVv4ogoayrSeVoN8aUuxiM0d/V1BdW/Cv6KZ9DPTpM8WlcjscsSEHTSCLfDvJXQJUPR9KLBh+l97mEVGg8sdbEGm5bcwT7fIXKD9R+GZ1ebA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4d9nd2guchaUPlm62R2CFdQ0ghiakGkEXEeHVbGcpME=;
 b=LjuOYJvcdoGqXO21kOTPJ6vB1doc+u0qaNjld8tzCzV9CzJz2bVORvI2vdXCdj8Na3Xc4hFSF1D4/y8IAm3cPt6TFnsvs4IOf7nXdPzSXaHHWglAYiYfwUNJ3/yvFxosHtVdRjUesgAuJ7ET1izkBu0reqPOt5/gH/CN0xdaTIo=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB2518.namprd12.prod.outlook.com (2603:10b6:4:b0::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.20; Tue, 5 May 2020 21:18:16 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb%3]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 21:18:16 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, Thomas.Lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v8 11/18] KVM: x86: Introduce KVM_SET_PAGE_ENC_BITMAP ioctl
Date:   Tue,  5 May 2020 21:18:07 +0000
Message-Id: <eeacea5ff4c2c5ba16a14dfdb86869dc5b17520a.1588711355.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588711355.git.ashish.kalra@amd.com>
References: <cover.1588711355.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM5PR15CA0053.namprd15.prod.outlook.com
 (2603:10b6:3:ae::15) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM5PR15CA0053.namprd15.prod.outlook.com (2603:10b6:3:ae::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Tue, 5 May 2020 21:18:15 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1fbc5c5d-bbae-41b3-1798-08d7f139d3a8
X-MS-TrafficTypeDiagnostic: DM5PR12MB2518:|DM5PR12MB2518:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB2518483908A03A6C8C13339F8EA70@DM5PR12MB2518.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q0h8LGw8DSUPJT7l6eV4RNlp/H6ah0qVlG+hL8eR55efn39yuGwtblVGwCpeW9YXXa5oFRJoqNmxehYnOrTPSfIuxkFPL7cu/r0QWbU2AM53hWDbAq0RQm7CvUSL9pyGlHWYwIX18l0XfJPICWfAnwaOLe5eaFR9jW2hsPdFXQQOOiQ1OrCwR0EZV2TxekvoiTw9NSy8wN8+Ns3tHSQyuKsn4r4B0jCZ2Ox6wMaWHMzHMvnLa4jNMkfAx80Q3ilHDjl0BRwTs20/v0d6ZtME20EDDLrl2ROY4VHdshnCnm439KqET+T2UMueDdZvWnkt7UKTexadAmT+MR0rgDOKmdYCTPnrZEALfH+9afSuKdYoWdNFPIgmAmztKwjfs3WMQauY8e+JuTWvVllflDVB57pQeV2KHmk5UEGLsvamp9Mx5Uqm33X9mtT9/5U7TgCRah2AowHChQufjo2DwWm+NjSUeTYYa0LUhJ+YkiQHFZ97IhK3iBpTeB+GGFv1P0Vu8dEX+3hSC/zutudEfw9get6wqOgYOT30p/oJ149oeejZ36sJ0DRU2iUM+TAKcCOA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(33430700001)(6916009)(26005)(36756003)(956004)(16526019)(478600001)(6486002)(2906002)(5660300002)(6666004)(2616005)(66574013)(186003)(66476007)(7416002)(52116002)(8936002)(86362001)(7696005)(8676002)(66556008)(66946007)(4326008)(33440700001)(316002)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: BHLbGlGa8tdZCjPAe21C6qiBOLDWr2+fqfHfW0BAx9GUX/FH4aLdHdAsi+PEDrebDKZDbml/pQplEAETXKQGpLz7lvh8U7HdrY4TsJeKSG5ujzy3C+s92tzndgYS+XOXGWJq2M71F4BQsI+0TgpezXzPtJpfhi0Ihjwm9EKAHe52UlpuMSSmAboC1rEgg5KyP4/Zmtf4+dM89bGBOKPHGcskC3JykBaB9Ex4BHfygniIYHfbpFp1ggjCbNDQ/ag10b/ZpDs04jlVCQL+ozYicYNbW5SlYQLHznsUj3MWfikeMTpCvsDtV/EZTNWMXuk05Jqn8iutH01aKCPpay6UCPTN4QeuRFPkbuq7n6kKiKkvok+dmQwO8xbG2UtvHqxZAaDxTV6OFw37TGwtfqYHntfI3XtFV7PvVBipULzZxKzwIwAi6+TdZFAK5JpwW2bNEKApJcnL8O0wA3hKQvroktZkhIcSzCs2fsuHJim/+Eik2fuh4SpEUwEMttKYic7DLYn2Wihu5HNDcTV32i4AY6y0zcYBax9JxXKd5qTkQ3Yqcq0fiQB3DfA+vk2dLB/vComBRO9fIQ5SqHY8KRoHrNkK6cWLaS/Cb6f2GtzBQrTLcCP51jfbJpu72Q+dloU3vc5pY9uRvx3d2LFh1T/QG/1+A9tmO+DIYxfga8rE1jzAntkBuV3OuJNk4WrYOXrzSt4HLdR/k0t8NnHD588C3IO2dKXoWEPlRhrfgg2bnugBX6jkvFBntnK4NGfmKGGLH0ELR5MVoc3gHMdvYt8T5UyMgUKublaOoIBantvX2Mc=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fbc5c5d-bbae-41b3-1798-08d7f139d3a8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 21:18:16.4802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RnBq9FBT/nbGK9wqWc8xaDMIth/Xd0GGpcFolzaJCD/Um26SS4PtAcWIxPqQlQJhuJV9oVnJFVRlSrwKo7x/3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2518
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <Brijesh.Singh@amd.com>

The ioctl can be used to set page encryption bitmap for an
incoming guest.

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
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 Documentation/virt/kvm/api.rst  | 44 +++++++++++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/svm/sev.c          | 50 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          |  1 +
 arch/x86/kvm/svm/svm.h          |  1 +
 arch/x86/kvm/x86.c              | 12 ++++++++
 include/uapi/linux/kvm.h        |  1 +
 7 files changed, 111 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index ecad84086892..fa70017ee693 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4663,6 +4663,28 @@ or shared. The bitmap can be used during the guest migration. If the page
 is private then the userspace need to use SEV migration commands to transmit
 the page.
 
+4.126 KVM_SET_PAGE_ENC_BITMAP (vm ioctl)
+---------------------------------------
+
+:Capability: basic
+:Architectures: x86
+:Type: vm ioctl
+:Parameters: struct kvm_page_enc_bitmap (in/out)
+:Returns: 0 on success, -1 on error
+
+/* for KVM_SET_PAGE_ENC_BITMAP */
+struct kvm_page_enc_bitmap {
+	__u64 start_gfn;
+	__u64 num_pages;
+	union {
+		void __user *enc_bitmap; /* one bit per page */
+		__u64 padding2;
+	};
+};
+
+During the guest live migration the outgoing guest exports its page encryption
+bitmap, the KVM_SET_PAGE_ENC_BITMAP can be used to build the page encryption
+bitmap for an incoming guest.
 
 4.125 KVM_S390_PV_COMMAND
 -------------------------
@@ -4717,6 +4739,28 @@ KVM_PV_VM_VERIFY
   Verify the integrity of the unpacked image. Only if this succeeds,
   KVM is allowed to start protected VCPUs.
 
+4.126 KVM_SET_PAGE_ENC_BITMAP (vm ioctl)
+---------------------------------------
+
+:Capability: basic
+:Architectures: x86
+:Type: vm ioctl
+:Parameters: struct kvm_page_enc_bitmap (in/out)
+:Returns: 0 on success, -1 on error
+
+/* for KVM_SET_PAGE_ENC_BITMAP */
+struct kvm_page_enc_bitmap {
+	__u64 start_gfn;
+	__u64 num_pages;
+	union {
+		void __user *enc_bitmap; /* one bit per page */
+		__u64 padding2;
+	};
+};
+
+During the guest live migration the outgoing guest exports its page encryption
+bitmap, the KVM_SET_PAGE_ENC_BITMAP can be used to build the page encryption
+bitmap for an incoming guest.
 
 5. The kvm_run structure
 ========================
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9e428befb6a4..fc74144d5ab0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1258,6 +1258,8 @@ struct kvm_x86_ops {
 				  unsigned long sz, unsigned long mode);
 	int (*get_page_enc_bitmap)(struct kvm *kvm,
 				struct kvm_page_enc_bitmap *bmap);
+	int (*set_page_enc_bitmap)(struct kvm *kvm,
+				struct kvm_page_enc_bitmap *bmap);
 };
 
 struct kvm_x86_init_ops {
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 387045902470..30efc1068707 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1504,6 +1504,56 @@ int svm_get_page_enc_bitmap(struct kvm *kvm,
 	return ret;
 }
 
+int svm_set_page_enc_bitmap(struct kvm *kvm,
+				   struct kvm_page_enc_bitmap *bmap)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	unsigned long gfn_start, gfn_end;
+	unsigned long *bitmap;
+	unsigned long sz;
+	int ret;
+
+	if (!sev_guest(kvm))
+		return -ENOTTY;
+	/* special case of resetting the complete bitmap */
+	if (!bmap->enc_bitmap) {
+		mutex_lock(&kvm->lock);
+		/* by default all pages are marked encrypted */
+		if (sev->page_enc_bmap_size)
+			bitmap_fill(sev->page_enc_bmap,
+				    sev->page_enc_bmap_size);
+		mutex_unlock(&kvm->lock);
+		return 0;
+	}
+
+	gfn_start = bmap->start_gfn;
+	gfn_end = gfn_start + bmap->num_pages;
+
+	sz = ALIGN(bmap->num_pages, BITS_PER_LONG) / 8;
+	bitmap = kmalloc(sz, GFP_KERNEL);
+	if (!bitmap)
+		return -ENOMEM;
+
+	ret = -EFAULT;
+	if (copy_from_user(bitmap, bmap->enc_bitmap, sz))
+		goto out;
+
+	mutex_lock(&kvm->lock);
+	ret = sev_resize_page_enc_bitmap(kvm, gfn_end);
+	if (ret)
+		goto unlock;
+
+	bitmap_copy(sev->page_enc_bmap + BIT_WORD(gfn_start), bitmap,
+		    (gfn_end - gfn_start));
+
+	ret = 0;
+unlock:
+	mutex_unlock(&kvm->lock);
+out:
+	kfree(bitmap);
+	return ret;
+}
+
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 588709a9f68e..501e82f5593c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4017,6 +4017,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.page_enc_status_hc = svm_page_enc_status_hc,
 	.get_page_enc_bitmap = svm_get_page_enc_bitmap,
+	.set_page_enc_bitmap = svm_set_page_enc_bitmap,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index f087fa7b380c..2ebdcce50312 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -405,6 +405,7 @@ int nested_svm_exit_special(struct vcpu_svm *svm);
 int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
 				  unsigned long npages, unsigned long enc);
 int svm_get_page_enc_bitmap(struct kvm *kvm, struct kvm_page_enc_bitmap *bmap);
+int svm_set_page_enc_bitmap(struct kvm *kvm, struct kvm_page_enc_bitmap *bmap);
 
 /* avic.c */
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 937797cfaf9a..c4166d7a0493 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5220,6 +5220,18 @@ long kvm_arch_vm_ioctl(struct file *filp,
 			r = kvm_x86_ops.get_page_enc_bitmap(kvm, &bitmap);
 		break;
 	}
+	case KVM_SET_PAGE_ENC_BITMAP: {
+		struct kvm_page_enc_bitmap bitmap;
+
+		r = -EFAULT;
+		if (copy_from_user(&bitmap, argp, sizeof(bitmap)))
+			goto out;
+
+		r = -ENOTTY;
+		if (kvm_x86_ops.set_page_enc_bitmap)
+			r = kvm_x86_ops.set_page_enc_bitmap(kvm, &bitmap);
+		break;
+	}
 	default:
 		r = -ENOTTY;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index af62f2afaa5d..2798b17484d0 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1529,6 +1529,7 @@ struct kvm_pv_cmd {
 #define KVM_S390_PV_COMMAND		_IOWR(KVMIO, 0xc5, struct kvm_pv_cmd)
 
 #define KVM_GET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc6, struct kvm_page_enc_bitmap)
+#define KVM_SET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc7, struct kvm_page_enc_bitmap)
 
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
-- 
2.17.1

