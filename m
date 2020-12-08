Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE0E2D35FB
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 23:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730697AbgLHWKM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 17:10:12 -0500
Received: from mail-co1nam11on2067.outbound.protection.outlook.com ([40.107.220.67]:15968
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730552AbgLHWKM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 17:10:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lyzw37eJGTlKWzNLFoEYXE7eSp4mbgSMh8Ob7cyntgk1arjbOZGA4NA5kqlMunkZh1Vza+ujZaUC4PRQ30apYdHkzRMAik0BEHVCsC5fifVyUz7JlSBd4ONBf6FzL6/aWV4l9LFXych6YnAAS8R6htK2b3ZGHdcJW9C1x7E3g+3+hMf9ACanKzHahTp5S033GiLFvSRm9mc7Phs6Z1R5ZEvIHvIASzeYG4U515+J+j718cUeLNLvgHKFhb1o89fhEuWMQwXss8ynZGUjveuv7XESll0sCGvwVe7cvOS9r0mzAUAbWERnv7CmrL7x7IuxAdwBuptfcxmQtNXwA5e0hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pyb/AdcWHNJO4hx0tqbBzqOyCCgIgiYSEF6v0WqbEy8=;
 b=jRfTdOQV6v2TD7TAB+B5ffUUV6mXq/iiFANHfZiztrAFUdHjKgjvoeheguZh2Ol3c4FsmB5kkNFuHjnlpAtrcE0s58AMJRTOSdDrRlljnhzbNGqkqE/EzL/8zVA2sCk89pKZO6inpXS190zP/O4mN/ZirDmF3csGnJMMY9oRONcR/shk74hcZ5yXWLaI0GI5jKCjDSV46jrKpkyni5lmesp488OoRmn01Hhf2sI3515TgdSjExXDK7dj2lMMbasE56KzuLYFq1TkxoXRLTfFzKt7ipvNKLjs2wsBz+vf7ltNMYyKRtdurAY/JYxtBX1pg58vQ9RXIDE72PbxDtJ5Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pyb/AdcWHNJO4hx0tqbBzqOyCCgIgiYSEF6v0WqbEy8=;
 b=DeEfpFZ0J0fm8h4d9F6AHFkKHydu2ofyMfsSXrHIVRNbUBC/DOm1wLQyGdT7zwJqBV7gdZaaZPkGYiV3CBByF4W3oVoWCAMvQeslvvg2wB2Q/yVXJuQb+vBKm2wSrif8kII1TwSHw8dajZNUeUPeBeb1gSsbb2I95zfEKmOYODs=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2640.namprd12.prod.outlook.com (2603:10b6:805:6c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Tue, 8 Dec
 2020 22:09:27 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 22:09:27 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v9 18/18] KVM: SVM: Bypass DBG_DECRYPT API calls for unecrypted guest memory.
Date:   Tue,  8 Dec 2020 22:09:16 +0000
Message-Id: <aa3b3b645f282d778d2eaf6b118df85d08ae43d7.1607460588.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1607460588.git.ashish.kalra@amd.com>
References: <cover.1607460588.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR18CA0007.namprd18.prod.outlook.com
 (2603:10b6:610:4f::17) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by CH2PR18CA0007.namprd18.prod.outlook.com (2603:10b6:610:4f::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 8 Dec 2020 22:09:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 09ee149b-e387-4c22-9ca0-08d89bc5ee13
X-MS-TrafficTypeDiagnostic: SN6PR12MB2640:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB26408FEE210E99A10D43B7178ECD0@SN6PR12MB2640.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:747;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: re6ZS82Utv0cUjqgQTeXA1I7dYrXNqlmytoPLEEH3lt3wmJN2CBipzj173qSBDg5ATAzJ7UH8miPkcV8wIPmPpNnIvVi23y65cbtE4iD/t8NZ3VfduPso98l+CxC4smHEE9PLh6vNFtsjcAo53xpkkM+9x7G0oz9rzPq5RwtUK8Tr37ET63fDjYDpVNrPebhuUyWsxxWXJC8HaSlOR4lL76x9r6gKfq6FrSVzQoH98j6uzxHXNHXLu2Qw5D7dRmUmYvHCbkzJzKnD1CQTnxTJDpSrWyRXP6h5dkB+vGeusKl78PHwS2yMq1NCJCH+GoGsfcRMEz9pob0ev5dhveOnTntnhCrmc9RMfjaNVEL0za0CxqIcUI/id2Iu3UH8+9U
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(136003)(2616005)(2906002)(66556008)(83380400001)(508600001)(4326008)(5660300002)(6916009)(52116002)(7416002)(66476007)(6486002)(34490700003)(186003)(6666004)(8936002)(16526019)(8676002)(66946007)(86362001)(7696005)(26005)(956004)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?IQOyr1gExZ+cqm8bjIuQ5oIpyzCZcZ0WVCmtlN9eWIcVfaI5u7mqNTfKRVmn?=
 =?us-ascii?Q?aZ3EcT2EVKnUYmAhvYkAtnI0oGSWjNLiE2JaSua3jz/lHd28zWpTHWKpjcI+?=
 =?us-ascii?Q?xf6iWojzxVf7RXKBoW/FS84R+cziV/whgSx5NyUSF6NNoCYAtuu9uxENGWcS?=
 =?us-ascii?Q?dLB9nVjtgZnFzZqMdBdKozjbLeGWueXCIi7TeuTnsckaeNqVB3o+ING6PS6a?=
 =?us-ascii?Q?0qaYwRdg61jBmdQgXAjZfSodUx6dU6HK7gfHxK2JCAjnbtQsUEmJ+PK+OD+m?=
 =?us-ascii?Q?OInSkchOKt87zN5vdrUwn4IYLXJDkJc+k2lXe8AF1uq8HBgOVTPGTkYQXXNP?=
 =?us-ascii?Q?oyxtqQSj7cbjRBrgr2p13vbrzPjhCuI6KJDnOYqpBvg/+iEqMf2eTQhs5kfm?=
 =?us-ascii?Q?iH7NkpQyDa/6C6bc6wwAxY+TAyCPKCBIkJ6eY1rHiiDLYU6fk0p6CcYgkHK7?=
 =?us-ascii?Q?JPJCk6l4XOkMWb29pa1gvBSOga6AsebQzjZXCprLrx1SI1nC2va7w58sPINq?=
 =?us-ascii?Q?pYPZrSatC7HY2cqBIU82I5eT2QpiicWWgPDo0H+u8fPWMCXnM7HU2YsIViGU?=
 =?us-ascii?Q?Cx3SHdgH5QXgIFt7oLhhfO2VKuwV3fjwSNJUDUgFfpcHBeIzsbHE4JDDOvyg?=
 =?us-ascii?Q?U4sy7jZX72xdE0vjUCeAXoaAF8j1MmBvFwvS3b2d5Q/5rvHgVLXJ9VPprBQb?=
 =?us-ascii?Q?WWBNMMiWRvwHaJ6kTuNfvidpFMjaXsBuOojov04Px6FtsiZ7KN4qD7RUluyY?=
 =?us-ascii?Q?qaR4Gw5cPf7frV5MKbDHfxm24wBFeYEJW1IzfqLxql22kfanoWU0r8tKdoX7?=
 =?us-ascii?Q?L0qX4g7HA+4XBKnUaLGbiLthXTu95d/aieeHpn/bj6S4ULVnGehblGRLjEEI?=
 =?us-ascii?Q?FSZyjN1OphmhbW6nz+A6Q2fBk/LkWmNAnVVtKhpjJ5H/9hkKMThhDLfFUvNf?=
 =?us-ascii?Q?IlTTkpFwZBC6vqMuvowns4NaG5Y/DWWZeglDuYr7YZMGF0mufJQlWhYkngSl?=
 =?us-ascii?Q?Djux?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 22:09:27.7270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 09ee149b-e387-4c22-9ca0-08d89bc5ee13
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5uW7NQv4Fab+5LbxrZO0qU1WGAkt3Cq7A9nogG2xT1lemculc8EELuRaSGzyhZIY2Yx/w4sadnQK/oCTdAp/xA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2640
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

For all explicitly unecrypted guest memory regions such as S/W IOTLB
bounce buffers, dma_decrypted() allocated regions and for guest regions
marked as "__bss_decrypted", ensure that DBG_DECRYPT API calls are
bypassed for such regions. The guest memory regions encryption status
is referenced using the page encryption bitmap.

Uses the two added infrastructure functions hva_to_memslot() and
hva_to_gfn().

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/svm/sev.c | 76 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 83565e35fa09..da002945a5ae 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -764,6 +764,37 @@ static int __sev_dbg_encrypt_user(struct kvm *kvm, unsigned long paddr,
 	return ret;
 }
 
+static struct kvm_memory_slot *hva_to_memslot(struct kvm *kvm,
+					      unsigned long hva)
+{
+	struct kvm_memslots *slots = kvm_memslots(kvm);
+	struct kvm_memory_slot *memslot;
+
+	kvm_for_each_memslot(memslot, slots) {
+		if (hva >= memslot->userspace_addr &&
+		    hva < memslot->userspace_addr +
+			      (memslot->npages << PAGE_SHIFT))
+			return memslot;
+	}
+
+	return NULL;
+}
+
+static bool hva_to_gfn(struct kvm *kvm, unsigned long hva, gfn_t *gfn)
+{
+	struct kvm_memory_slot *memslot;
+	gpa_t gpa_offset;
+
+	memslot = hva_to_memslot(kvm, hva);
+	if (!memslot)
+		return false;
+
+	gpa_offset = hva - memslot->userspace_addr;
+	*gfn = ((memslot->base_gfn << PAGE_SHIFT) + gpa_offset) >> PAGE_SHIFT;
+
+	return true;
+}
+
 static int sev_dbg_crypt(struct kvm *kvm, struct kvm_sev_cmd *argp, bool dec)
 {
 	unsigned long vaddr, vaddr_end, next_vaddr;
@@ -793,6 +824,50 @@ static int sev_dbg_crypt(struct kvm *kvm, struct kvm_sev_cmd *argp, bool dec)
 	for (; vaddr < vaddr_end; vaddr = next_vaddr) {
 		int len, s_off, d_off;
 
+		if (dec) {
+			struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+			struct page *src_tpage = NULL;
+			gfn_t gfn_start;
+			int srcu_idx;
+
+			/* ensure hva_to_gfn translations remain valid */
+			srcu_idx = srcu_read_lock(&kvm->srcu);
+			if (!hva_to_gfn(kvm, vaddr, &gfn_start)) {
+				srcu_read_unlock(&kvm->srcu, srcu_idx);
+				return -EINVAL;
+			}
+			if (sev->page_enc_bmap) {
+				if (!test_bit(gfn_start, sev->page_enc_bmap)) {
+					src_tpage = alloc_page(GFP_KERNEL);
+					if (!src_tpage) {
+						srcu_read_unlock(&kvm->srcu, srcu_idx);
+						return -ENOMEM;
+					}
+					/*
+					 * Since user buffer may not be page aligned, calculate the
+					 * offset within the page.
+					*/
+					s_off = vaddr & ~PAGE_MASK;
+					d_off = dst_vaddr & ~PAGE_MASK;
+					len = min_t(size_t, (PAGE_SIZE - s_off), size);
+
+					if (copy_from_user(page_address(src_tpage),
+							   (void __user *)(uintptr_t)vaddr, len)) {
+						__free_page(src_tpage);
+						srcu_read_unlock(&kvm->srcu, srcu_idx);
+						return -EFAULT;
+					}
+					if (copy_to_user((void __user *)(uintptr_t)dst_vaddr,
+							 page_address(src_tpage), len)) {
+						ret = -EFAULT;
+					}
+					__free_page(src_tpage);
+					srcu_read_unlock(&kvm->srcu, srcu_idx);
+					goto already_decrypted;
+				}
+			}
+		}
+
 		/* lock userspace source and destination page */
 		src_p = sev_pin_memory(kvm, vaddr & PAGE_MASK, PAGE_SIZE, &n, 0);
 		if (IS_ERR(src_p))
@@ -837,6 +912,7 @@ static int sev_dbg_crypt(struct kvm *kvm, struct kvm_sev_cmd *argp, bool dec)
 		sev_unpin_memory(kvm, src_p, n);
 		sev_unpin_memory(kvm, dst_p, n);
 
+already_decrypted:
 		if (ret)
 			goto err;
 
-- 
2.17.1

