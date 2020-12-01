Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 408522C943D
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 01:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731034AbgLAAsT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 19:48:19 -0500
Received: from mail-bn8nam12on2071.outbound.protection.outlook.com ([40.107.237.71]:20033
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726316AbgLAAsT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 19:48:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V9jadLR/rygYo2U21PiiiSU3pvUtmJyk9FqBnfnuYkNJUohTQSuLaWDmioRbhijFWRNg7iv0NG9r7kAMnqNsMS7zCBPLkl2leL/hWqHKENMdJrGSQ3n0p5Ep3erbnjQMhulg8WZNshP6yj58OVyHzu+qLTSfenKXO3LhuKJcaXvcruRIDy0OPJwRhTrZy39JiOSkC/D0/zsz6NdoenhMUeRsI0NIgPogyF975sK427FloqZzIMKzw57DNA8HxT8c1OU7vdjGnoJV9Baa7UGF8pMV7QaWy4mN1TqO086PFVw8nAPQtKLBDE9Bfg5NQxjD1EqAp1hHkRAsHjPPIAT1sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lj0b4xph8HtRfjuyDWm7ZSlKkT59hKuGpUSh6cIllW4=;
 b=JdRzvg7dPfjujhJKDnz2IyrXrRLXCf97XgG8twV0Wlk12THU8k/vcgYxesC1mD6sQ/SDs068S1oHZdgWlpRx637VXcJO4pLfTaOIIb76VEAxZ2SVRpKBhiuO8QS2OANowMVpa8hGPeCcO6OOUwbA8Tt0X2GCrRiuD+CRC7CbdHm5qTFtU9VFNFiPsYfHLB6bmCzgRAxduP5APrlTDQNXV/czdhRMFNPQe0GQ1+SlQerI0hliYpknwN+LiDAJVcO1Srq12fp7JtIfTrHdD+TEKqM0Dv7+vwLGn+u8ymkgxSyYSzPmRSRYBpjhVuvsjChlAoASiMlRhLh68/VllFH5eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lj0b4xph8HtRfjuyDWm7ZSlKkT59hKuGpUSh6cIllW4=;
 b=KVnWddrrry2ir15cJdvk2puiZ/Lh0BwodObWdGBiK0rWimVBX1VW/f2Lo+kl2smXkHRecTP9tYYSMezBVtg+Qz0cWe/EGolMDqfP58ikqC3J/IWa3J+LGgQC8saj94B2LNhbkWci65beSRIhT8lqjMfHyjGlxmyQ0NN1TG+PO7U=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4573.namprd12.prod.outlook.com (2603:10b6:806:9c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22; Tue, 1 Dec
 2020 00:47:45 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3611.025; Tue, 1 Dec 2020
 00:47:45 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, brijesh.singh@amd.com,
        dovmurik@linux.vnet.ibm.com, tobin@ibm.com, jejb@linux.ibm.com,
        frankeh@us.ibm.com, dgilbert@redhat.com
Subject: [PATCH v2 5/9] KVM: x86: Introduce KVM_SET_PAGE_ENC_BITMAP ioctl
Date:   Tue,  1 Dec 2020 00:47:36 +0000
Message-Id: <6ed96d11482919c74a635905f7ab108bb4cdf6fc.1606782580.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1606782580.git.ashish.kalra@amd.com>
References: <cover.1606782580.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0085.namprd05.prod.outlook.com
 (2603:10b6:803:22::23) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0501CA0085.namprd05.prod.outlook.com (2603:10b6:803:22::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.6 via Frontend Transport; Tue, 1 Dec 2020 00:47:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e1a61024-203d-4f30-a297-08d89592b7de
X-MS-TrafficTypeDiagnostic: SA0PR12MB4573:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4573C7516247BDBDD02EDD9C8EF40@SA0PR12MB4573.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FLs+xYSnn+mQtDYPZYc9mqF7HxrVygmmDTgs0E3DN9itFaUwodRU/77wmHaD4iDc4i+QEY65Q4OS68TvArOWIPFtn8XGz8pLyKwo4lvlWPCuzldh/ECcNeH5KYhMW35ecC0Hhty2Wyr8Q2ErfYRKvJK8XkwhXi5GldRqLLuv5c3SNDiosMeou4ZxOFAGboYCmTa4D7EHAI+n4Gshbh6Qb979MQyyrhC1OfJiCVUTqpwbYt6kFatFChoQPRkF4ivc4shzwX5LmQuuB0cd2T3nO1ndK84Pzwfu6V0KY9Xmc1ezIFlSsfQlziO9VH6uBkyZyBqlhrlwE+bwVrxF8O/7FQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(136003)(396003)(39860400002)(478600001)(6486002)(7696005)(316002)(4326008)(956004)(6666004)(8676002)(186003)(16526019)(8936002)(52116002)(66946007)(5660300002)(7416002)(2616005)(83380400001)(86362001)(26005)(2906002)(36756003)(66556008)(6916009)(66574015)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WEdzekdQTVlZd1QzMzN2SjZqNHdZSlpxSlZwN2I1aGVab25zcjdGNEU3Myt1?=
 =?utf-8?B?Wlk2NnBLTUQvczZtZUlyblRGc3VWRjczQTFjd01OM2wvTWhaSVlPdmIwbENV?=
 =?utf-8?B?YmZqR3A3QnNrMHVpWTNZSSttclpjbjBhQUxGN21wN2cyMDg3QkUwMkhPTnJj?=
 =?utf-8?B?ZWUxY0I2V2d2Q1RwWnEyVjd2bXdReUdNaWNhWDk3SWJMSS9CV0JjZ05HNjdZ?=
 =?utf-8?B?OHgwZ1Ryek4xTkpFQ0o1ZllscWtXYng4OExaS1NUNWlYZ01PNTdXdDFMTVkr?=
 =?utf-8?B?Qzg2UW9QQ0dRc3pPMVdXa1d2MnBRdkY4S0hleGlqTnBSa0MrdWpibW4vN1dN?=
 =?utf-8?B?bmVvbjU3ajZPRW02OUhnU1lrQlV3ekxIOU1iM3BVdndpNUliWTIvSnl4TXdP?=
 =?utf-8?B?UXdzRkFXU1E2UjlOWkF4RStydkMxZ09abGRlN1Nwd21za0s3TzJxODRPeGZK?=
 =?utf-8?B?aHJRdEljRmpwSzgzaUVCd1ZCZ3o4VXlkbEdMYjZ4SzVFNGRNWG9ibXNzWXhz?=
 =?utf-8?B?RHYzelBFSGQ5VE5kYUYrN0E5N3o1dUtNMGU0Q2pnTHkzanVmQllmUkdUYVVV?=
 =?utf-8?B?dTkybFdBb0RtbnVMQ3BLVk1wUFNkWXYyb29QbE9iU0pxdVliTXpNWTZRVHIz?=
 =?utf-8?B?aU8zRGdXRGN3NDlQK0lPK3R5STlGdWFqaDEwWlVxVVU5cCswMTB2VXN3WG9x?=
 =?utf-8?B?VnJCNnBianFvOXBhQnpISUFLTkhXWXAxTmZ3aUIvWWlORHFlMWt3RFAyUW8z?=
 =?utf-8?B?YTBoQWFBTUhGNHUyUGdwcU9CZnFISjhBV2FLSFNlTFpVZ2F3TU1MR08rU3pw?=
 =?utf-8?B?WHBKY29FZlc3WndjUnc5M0tGanliWGF0OGJzVXNsTkZpdVJKVGxHYmpWcHJh?=
 =?utf-8?B?Zy9SRFlrTWI1RGF0d3VrbDRnbjhVaFhXenAyd2FIa3E3emlrRXRjQklvNlZ4?=
 =?utf-8?B?cHJoZWZ5YWFzR2k0dDFpWWVQUWZwYlEyMW94TkxzMFJwYWpyQW9zOHVpMlUy?=
 =?utf-8?B?WHp5eVVzemk3bzJCQzh3amZOQ0h1QW1oK3RiNnlVcWhGeW9xbkN1QnNtb3lG?=
 =?utf-8?B?QlVOWklMTVJBclBIWlUweG9QZ21uVjVjZ2dQcVlOdnk0UGd3Q0kwQmN0aXpr?=
 =?utf-8?B?KzZjVmVKN1hmc2RuQTNZcG1ObzNkVTBrRlFrWTJSdFdaTlB2V2JTRG96VzdT?=
 =?utf-8?B?aDRiZ1ZGa1FIekJFeHhtbXBOS2lwd2l3NnFSSC9rZUFETFpYNCtnNExvSUww?=
 =?utf-8?B?MmlUZnFEbFpadkVSbUR4Nmt0dStsTjUyQkllbzlaNlRKM24wM3YwdThUVEtZ?=
 =?utf-8?Q?cR+SEu+Owf0LVUSMBB690TtWneSzupofzv?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1a61024-203d-4f30-a297-08d89592b7de
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2020 00:47:45.6889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YtlLXbEk3wrcMh7ZDPX1GbFzyH5BHxEFiSIvFOVYhMSXMOkEw7mRDROdL7EOEXVyv13hdbiNeHjevzwj5rxUqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4573
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
index a6586dd29767..e99ea9c711de 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1084,6 +1084,56 @@ int svm_get_page_enc_bitmap(struct kvm *kvm,
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
index d0b9171bdb03..8e1adcd598a8 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1574,6 +1574,7 @@ struct kvm_pv_cmd {
 #define KVM_RESET_DIRTY_RINGS		_IO(KVMIO, 0xc7)
 
 #define KVM_GET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc6, struct kvm_page_enc_bitmap)
+#define KVM_SET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc7, struct kvm_page_enc_bitmap)
 
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
-- 
2.17.1

