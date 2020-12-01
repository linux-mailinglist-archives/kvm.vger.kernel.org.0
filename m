Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0C272C944E
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 01:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389198AbgLAAtq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 19:49:46 -0500
Received: from mail-bn7nam10on2050.outbound.protection.outlook.com ([40.107.92.50]:4864
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731173AbgLAAtp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 19:49:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=haib30Oq5dyF5cWbdYeclQCGRwZnuwRpZlcY3He+O5BLhtDkOCxwlDq3sTujOPjTLU1B19yVBuuYQDoejfeUiIW0Dw+FTDOLYhDKINhka8M4+qGexSueWvvaWIrW0QBJDtQPeARhkFMS2oUD7GesMfsTgAITbotP3uNWy/rTM0loyWHE7WQ9v0C32RiX8X6HXfUH9OjmP57xPgDpKhyxvp1NXxbmxZ0ekpSU4E8BblNPeRJrJnFZL8D1ZxysDDuSwIaE4X6ygECaQA2lSHfa9xvEm2NoZE2BAmDxP18NmSqNu1EoiYViG3OA9YfyRT2H54cqDYqjxaGsCX6lQCF5jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kaz3IPhNOXC4h/JSeiegVZV1vWlNhyCRDAW+WYkCYZM=;
 b=EuEIaZmSCZkYLKeFCjJv0f0Vx5CaUE9F1rR6WlnucCj9pomGWmPOutuRklaOvh1LQfSjodyyPLe85q9+kZvAQATaAMUHqCkEGvrDN0ZfvL1+jvqsypYZI0r3v11yhjFbbfQBD4hhyjg2/2RZzoue+PZFZRJhBfYFs6RFMEHC/b1hNm2BQA4nZ8Ji+jMCflr7/uQn3WPjykPs8H23XLSlCuWCbWu50gXy9vYFuf+peKFaYjemXVefCv39dJ5MRx4VQc33grJcOdxdCcHE/Wf9lpllJ++UtBFiiadSc6h8YR7Wl99qq/7LRLV8XSMlMuuZOkZflyDxqNuXZ/Pq0G11cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kaz3IPhNOXC4h/JSeiegVZV1vWlNhyCRDAW+WYkCYZM=;
 b=tnKF3BXOMfiQlbZKdbPC3foBviyVh41sN89X6yZh6gU0fpU5iJorrXqeE3ZSMFRMLVzvybRLApKj/guerJIXnbCdW0yd5zcUQIXp0MKfqAzN8KGB7oR/8rjQBQXS4wItOHU48pAm4Bezes+VSW1e6h3YFmQxQX2WkSbR/Kt9Wlc=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB4751.namprd12.prod.outlook.com (2603:10b6:805:df::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.24; Tue, 1 Dec
 2020 00:49:08 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3611.025; Tue, 1 Dec 2020
 00:49:06 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, brijesh.singh@amd.com,
        dovmurik@linux.vnet.ibm.com, tobin@ibm.com, jejb@linux.ibm.com,
        frankeh@us.ibm.com, dgilbert@redhat.com
Subject: [PATCH v2 9/9] KVM: SVM: Bypass DBG_DECRYPT API calls for unecrypted guest memory.
Date:   Tue,  1 Dec 2020 00:48:55 +0000
Message-Id: <6a3cf86ce0eb6cc18b0cdad61ed1266755e9b929.1606782580.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1606782580.git.ashish.kalra@amd.com>
References: <cover.1606782580.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM3PR12CA0043.namprd12.prod.outlook.com
 (2603:10b6:0:56::11) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM3PR12CA0043.namprd12.prod.outlook.com (2603:10b6:0:56::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Tue, 1 Dec 2020 00:49:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f6a3d054-202e-4040-34d8-08d89592e7e7
X-MS-TrafficTypeDiagnostic: SN6PR12MB4751:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB4751BA4B134BB0EF35CF0AB78EF40@SN6PR12MB4751.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:747;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZfnJS+LD4bHoULZKXzQL4KwpvGZR/TgYGsxQYRcAhfqQSykg/xsB4vxFqn3q+K36YT+Sim1eK68RWdJNFwH8mthkupQCoCJE/nRLgdr1kkGVFYuzljd0foW3AM7dofFOT0qHVsJU1UUFKwEUQvrZGOhpW68vYk8L4oVQrqHXvR4/Zin48ELwlXjetmwtIOk5dWhlOW/v0AFA8I8KJbKfUcZGQJDHnNKlnSsSiwLGHoz2dK8MKuFu3OEam8YLwCMlc6jW6P9on1aUulbfUYGEdJfY72/XGCukorl8H7HdlxlVeZamS3wi9RhConGfJjHYK0EDnxvKaOuEZfF3X/fuuw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39860400002)(346002)(396003)(376002)(8676002)(7416002)(8936002)(2906002)(66476007)(5660300002)(66556008)(36756003)(86362001)(66946007)(2616005)(6916009)(4326008)(478600001)(83380400001)(186003)(6666004)(26005)(7696005)(6486002)(16526019)(52116002)(316002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?GZu+8rzeVShCJoQXpt1OJx2KR5rgHOYGbjUSU5yULjmxT9CVBp4uOE64yFma?=
 =?us-ascii?Q?2agm2o1e9JHjIqwwC1LCJ71oF6EfjbyBE5r/tju2tmirvqr6FIGGGIj1w9A/?=
 =?us-ascii?Q?cWq/LT3FQTB8b44ymi7/tY1alGzQ2WLuqJNEMO779xLY8Z9gXy9EusOh77Aa?=
 =?us-ascii?Q?LtViFn9dfdwhkGGOGqOgyVkC0Sc0uJ4DQms3x8PfJtIbBULVUIl90T1UAgxT?=
 =?us-ascii?Q?dIpUKACivIkqB3FfEg+0NdYu/wd39q75MX2s8Uf1yFy0WVZ9AkCfhnAk2SP0?=
 =?us-ascii?Q?EhBA9h1XcCxkH/+Fj6/9Ke/51onCIDwQmrrtEKfq/sAPo0IoI70AXiUoX2St?=
 =?us-ascii?Q?P74jBN9uorSd6DTepQuY2xOtgPKOpCrIlQZxtCdUEnw5dcJEGlAi7lCUvGUC?=
 =?us-ascii?Q?GvTB0LgVR4ObRUK1AKWRpvUSvYtPsk1Ej0WFE1zQrOCmPHb1xzisfg0/EvKy?=
 =?us-ascii?Q?6NI/xlvndZ34nTcUnVdC0nnbLg9LfV0Q6/yztv1Ozvo4zazGVilEUQzrhIbZ?=
 =?us-ascii?Q?fE0O9WU5tKMKrhCL5wSIG7xoQ+SLVKBRPamTriCEOJduiciW23mh/zdEnM/k?=
 =?us-ascii?Q?XmYe8ON15ksJUgiCzOiUK7NEDqoVXdhLOpR6QI7knLmzQ0NfZArp4tAV9lqz?=
 =?us-ascii?Q?gqEcwvTIrxzaqi5/7PO80XzEQmPw01lCPKHf43G4J0gaGPDewbHSnzl13anG?=
 =?us-ascii?Q?RdDI7qx3SiwsTRsJGI8ahEXsWyuvQz2YYa4SdTBET0Ri+1Sv2+XJU0aMJAUa?=
 =?us-ascii?Q?YfCZyhlDdhDMdklmfHhH2z8Jp5XYmscPmjoAX/qBud1SHgzi2SWj1PGM4Zz5?=
 =?us-ascii?Q?YVGo/KtmA9CE2lYT4hbZKOyXOQpHOc3FcRZaCM3jxLgOq36NW4A3CgxkBxdP?=
 =?us-ascii?Q?yXreNqVYZZQzSBIzVRtUQVGarcqm6VsW8JWIoj7nDTIv3cEsvJzIa4NTZqNl?=
 =?us-ascii?Q?hXs6egxnfjcxOJMoWabOrPopXSBoAM1DritKwXfXh5FjjqRsqmD+j00x4xwc?=
 =?us-ascii?Q?teVD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6a3d054-202e-4040-34d8-08d89592e7e7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2020 00:49:06.2877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: be7767+lcx2tsqkjTnwhAo1gKKGL8pTMt54OIFXmELOcPzwbBBllVtkYuBgq2Uktc2tvSlOxO2BkciiA2x9xYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4751
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
index 8b089cef1eba..2524a47531ee 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -763,6 +763,37 @@ static int __sev_dbg_encrypt_user(struct kvm *kvm, unsigned long paddr,
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
@@ -792,6 +823,50 @@ static int sev_dbg_crypt(struct kvm *kvm, struct kvm_sev_cmd *argp, bool dec)
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
@@ -836,6 +911,7 @@ static int sev_dbg_crypt(struct kvm *kvm, struct kvm_sev_cmd *argp, bool dec)
 		sev_unpin_memory(kvm, src_p, n);
 		sev_unpin_memory(kvm, dst_p, n);
 
+already_decrypted:
 		if (ret)
 			goto err;
 
-- 
2.17.1

