Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71DE52D35EE
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 23:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731308AbgLHWIt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 17:08:49 -0500
Received: from mail-co1nam11on2089.outbound.protection.outlook.com ([40.107.220.89]:31937
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730400AbgLHWIs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 17:08:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CrF50yefmZq4gQcWUEoqH8/sjgsLxOg2s9rKyrQtBImg7RZe5kuAbv4/ktDBCiHaS64ql57y29Le/0qOfcdtF5XSJbfjKzRBj689IhJHSUSOiOqekU97B+tZGF9ThMfAO4eu5sm/iOWxcWXCmiETR+6RMJRNdOq3CXUiPWCZTcRHZPx49vAQh6sfJpgZjWcDGRVb/+mYi6Z1K1bRLebhApHg5nAtliNK2Ln7unQjr1/3LROdi4F5Hf1ejUNi0985ijwbticJ16pci3HG8QDLs2k3FPes9x8Dp+6cQViWlR6RrXxCW6uQMPrDU4GbT7cED/PWFJmeqlRTgsMxIV3DwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UsZaEuAQ/93o6jJ7PP8H0kJ72lYvSkBTWtz8MmVKmWs=;
 b=Jg909qKd0Owl5XYvpyfVCsNyfkb91l1faOPx/5USLUS119GroEWJqH2BhxEiMiotzAhZOL2qDl5Q0GTdRfDq87/cXekzMmz8o83YQj34/uD4z727Q8judODkzj3aY3FvzknfhDZ0E7lqPjz0FJjgEXmbDuXjRbgEliicBt47rlT/qjHxp/ZkO+HnL/8j8l/HEmAnnq295sp130KfQq/Rbvw5b71r3hF1ByYZbf9Y/CHAvuT71hTW1mch7ssBXOzNW3gEuCQKE6F8vt3ZrlyJyZ3fjf59pwQWf3vm9kLHeiiP3AvuWi8vBgynESeAq8ydw5Ztp9/FsCqnFeMf2S2/tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UsZaEuAQ/93o6jJ7PP8H0kJ72lYvSkBTWtz8MmVKmWs=;
 b=X8l8uJY+6PA23u0co0VNS3WIgYPNsE7Dn1/gyxgDRjvaJhAIrGOkP7Ssj4QokGMnz3x/oodEYPuVlo9ye+kfo7YjmQdYEvlfVhi8FOIH6Byn+3WgiB52/MpH74cqwNkQirob110i3mdruuMJcSqjXkQEKkCh+MbD05Sudvlkjls=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2640.namprd12.prod.outlook.com (2603:10b6:805:6c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Tue, 8 Dec
 2020 22:07:23 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 22:07:23 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v9 11/18] KVM: x86: Introduce KVM_SET_PAGE_ENC_BITMAP ioctl
Date:   Tue,  8 Dec 2020 22:07:11 +0000
Message-Id: <cdda5c5b5bea5d66a80a9c2469a624a37e1aa734.1607460588.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1607460588.git.ashish.kalra@amd.com>
References: <cover.1607460588.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH0PR04CA0083.namprd04.prod.outlook.com
 (2603:10b6:610:74::28) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by CH0PR04CA0083.namprd04.prod.outlook.com (2603:10b6:610:74::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 8 Dec 2020 22:07:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 875d6f96-3b22-4d92-c3ff-08d89bc5a3d6
X-MS-TrafficTypeDiagnostic: SN6PR12MB2640:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB26408E785A8433F605A4ED078ECD0@SN6PR12MB2640.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +2NhryJOhppunBRr0xHIJnXEXwZBAnqkRJoPDm3mM0GOGrHgNTa70yrdOjKXv9W29MZxMN0moXHfr4Bz5inriMzJ6jxSnGRcFmIPwgjm4VQomp+gfkkAFtwKfSYFMeITrbicHIb123VVU/gwDWYY5yciLGNiZnv+P9Y0DXr0IuJaesvUYEwzxcyyubxY1RH38/+9g1eRHSJOo1mfBk5emoYwXamOp5j62u8uvCe+5o/2RTk08ZHND3CFV5NaG7HFDloEwz4zy4U7Bvl25FcKyLRS/opxbUdw5bBayKsP+K59rS32KkG1lzT4bqFw3fEkHtpxdt3NdstR0zBsMmU+McYyS/LVHxrevh8emi3WK+IG0NiAR4/Ai7UDb8aUL/eV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(136003)(2616005)(2906002)(66556008)(83380400001)(508600001)(4326008)(5660300002)(6916009)(52116002)(7416002)(66476007)(6486002)(66574015)(34490700003)(186003)(6666004)(8936002)(16526019)(8676002)(66946007)(86362001)(7696005)(26005)(956004)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RE5VOTJZOWQ3czBCNi8yMEdwSk9sckkzYlY1aitUREtVNTkzNU5OeFpYTGJN?=
 =?utf-8?B?R0FhN0grT2RyYitkR0Vvd2MwT2dJdEFZNmloL3p2ZVBDcXlVckpZMW5qd3p0?=
 =?utf-8?B?RkU5OERUQ2pNb1lIS0JPMTRFL1lXcll2Q3ZzdnFqbVkvTVN4NFN5MnpPejZM?=
 =?utf-8?B?MkNZVkNwZW5Kb05DblBqQVpCNW84bGpWallzUVNJR1ZiaEZoWnQvcWJ0TFpt?=
 =?utf-8?B?d0FrTjJmTzQzVUp6SHZkMEphMW9IaGZKVnl5TitkdWk3QTlZdmhKWG9BVnFy?=
 =?utf-8?B?Q0QrelN2ckZ4d3BSd2o4azM0YWczWncxbnhGTmZud0RuT1Zvc3dOUjU1eHVx?=
 =?utf-8?B?RkZQSjMzR2VTaVFhY1E1NHNRRmtZbTJ0bjZUeW1STHZxNnlIaDNUb3lzUXZj?=
 =?utf-8?B?bHNzdDdlS2hyMEtubk9nazBBQ0YrU0lZNlk1V1dvbW1kZUdMNWRCZy9wbjds?=
 =?utf-8?B?TkJEQmtyNDBOTEZ2dHAzM2hpZXlRSmpCMFdScE9ZOE81RGVPTmsrYnFJNS96?=
 =?utf-8?B?VlE3TDg3UzhrZ0RVWkI4dnN0TUw5QzNtc1BqR0VJLzJsSmg5U0FUL0NFTVdL?=
 =?utf-8?B?eVpSOTNGb2lQTFZzSUJrTnA3UHVDVkJOcThaei84alNvSWg0aFhCdVVnT05V?=
 =?utf-8?B?eGt1a1NzNmt6cXBOSVI3R0p3cC93amtCTStOU3lhaTh0T2RCMlg5V0VpaFIy?=
 =?utf-8?B?NXVpYzZncVpXenBHaFBDd1Q4Rmk2eWJJN1ZpcFdDWDBZYU04NldoYjN5T3Jv?=
 =?utf-8?B?ekxWUGE0d0NrbUdKbzV4MithUldObGFtb0tuYnAvR0Q3WGtwY1crOW9Sci9m?=
 =?utf-8?B?WWxqNzgxcGE4MEJYZGxEU1p5cDNJV0dFRlBOUE94Q2cwY3RrcWhvdXlDK3k4?=
 =?utf-8?B?VkI5ajltQjFYbXR5NldnT3NYOWxDaXFxcUdSb1BpaFN6bU9hQUI2VWd4RVpz?=
 =?utf-8?B?ZXNoUzNaM1JLYWpUYmt5MzJvMWwvUU1hTkM2Q01MY3FHSHJvVU5ia0hOTHFx?=
 =?utf-8?B?WmxWS2pES2Q5all3Tjk2OHdzZk5NWm1jK3NnNHlIZk4wdEJmNGJVNjFDZU9E?=
 =?utf-8?B?bGRIelFCNFNmZjNqMU9ESnhtKytZRC9VRnJvWDV1UWtJWUFjSVVHSVBYeFc2?=
 =?utf-8?B?ekx3TytOOVZ0UElZQUlwdkhZRzV0RldYd0diSlBobEE5L0tjTXlUN3kwa1FI?=
 =?utf-8?B?dnRWYmdQL0dwTjVpQkVYZG10RUpORzJQS0lTdnVRSDZSay8vUjRWK3dmV29V?=
 =?utf-8?B?UkNPcFRGUnJWeDhuT01DMDBjREFmM1g4ZkhueUFjRlJzL1NQVXZLVHBPMUY5?=
 =?utf-8?Q?SVULScnBSooQczg7/o9gQMpgPPYE8pNEzF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 22:07:23.1719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 875d6f96-3b22-4d92-c3ff-08d89bc5a3d6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2PpeRslbtMhQme3B7gX1k57TfAqicIy0jP9o4oOpxeC8cWnNd+NmXekYWTQ824pwbZneevOzXtcgM3NUGyTc9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2640
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

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
index ae410f4332ab..1a3336cbbfe8 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4698,6 +4698,28 @@ or shared. The bitmap can be used during the guest migration. If the page
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
@@ -4852,6 +4874,28 @@ into user space.
 If a vCPU is in running state while this ioctl is invoked, the vCPU may
 experience inconsistent filtering behavior on MSR accesses.
 
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
index 8c2e40199ecb..352ebc576036 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1286,6 +1286,8 @@ struct kvm_x86_ops {
 				  unsigned long sz, unsigned long mode);
 	int (*get_page_enc_bitmap)(struct kvm *kvm,
 				struct kvm_page_enc_bitmap *bmap);
+	int (*set_page_enc_bitmap)(struct kvm *kvm,
+				struct kvm_page_enc_bitmap *bmap);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 4280da9dfea1..6f34d0214440 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1518,6 +1518,56 @@ int svm_get_page_enc_bitmap(struct kvm *kvm,
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
index bff89cab3ed0..6ebdf20773ea 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4315,6 +4315,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.page_enc_status_hc = svm_page_enc_status_hc,
 	.get_page_enc_bitmap = svm_get_page_enc_bitmap,
+	.set_page_enc_bitmap = svm_set_page_enc_bitmap,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 4ce73f1034b9..2268c0ab650b 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -414,6 +414,7 @@ void sync_nested_vmcb_control(struct vcpu_svm *svm);
 int svm_page_enc_status_hc(struct kvm *kvm, unsigned long gpa,
                            unsigned long npages, unsigned long enc);
 int svm_get_page_enc_bitmap(struct kvm *kvm, struct kvm_page_enc_bitmap *bmap);
+int svm_set_page_enc_bitmap(struct kvm *kvm, struct kvm_page_enc_bitmap *bmap);
 
 extern struct kvm_x86_nested_ops svm_nested_ops;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d3cb95a4dd55..3cf64a94004f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5707,6 +5707,18 @@ long kvm_arch_vm_ioctl(struct file *filp,
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
index 67cdb301ec4d..79cd28b17b33 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1574,6 +1574,7 @@ struct kvm_pv_cmd {
 #define KVM_RESET_DIRTY_RINGS		_IO(KVMIO, 0xc7)
 
 #define KVM_GET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc8, struct kvm_page_enc_bitmap)
+#define KVM_SET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc9, struct kvm_page_enc_bitmap)
 
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
-- 
2.17.1

