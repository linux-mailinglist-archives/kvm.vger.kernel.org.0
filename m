Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12B3D30E8ED
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 01:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234457AbhBDAnD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 19:43:03 -0500
Received: from mail-bn8nam11on2056.outbound.protection.outlook.com ([40.107.236.56]:27937
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234421AbhBDAmu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 19:42:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nccAklR1hLYr2GIPzXx+BO6Q7ViWuhgOrKUs36ysBWGDvypOF1412E/I7p5kIpDSrHkwvvDo7MFHsNTArr3to/30ASWIYoGdvBZpMX3gLJ8w5jNEHCt+g7Rs8ZshwLKHdN34mOzeUSFSLAAjPZDZe9mZzjOCWe2WppZWa6CmmgDoN8zO04ovJSQqN+grgfX1NVqjfN053zD+ivq71UgX9ob72Kdf7vxnh1WHYUhL9CDhJET1WnNcjSqwTGfaEzFesJO7jmMLPTA0X5XR0fXQymTz63tRv3dMjTRGFu44mYbjyCRwSYiwY2+RtH+XBWd0IWNNvKRa4SXnEgXQQXb4iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wsbWATYAuUJOtwXtqdwT1Doc7+IdQyBsZs/DW0YScAQ=;
 b=g9GH8Y+iMzLKFh7LfTDgYbNKnpiysZryug2YefA6cRD4U31MpGNSBvyYpdcI3nkn8yDszXoskP46IDSm6KWdQUje5m63RFPoL+MElZUB7dyvp6sUPXR9sNOB2oYI0gkuaynry1gStnYVANz5YrZxdi6Mw2JDVRg25vEZ6n8pTs7z9vPfYhy0Y2/SFUN5/uJBZ5dzpcw1/dtoiCKAxEBcHKfBjfk5vcNyr+HV05LFOOwtroYro3AasKII2KvBYraa1yIFzp/jNG+802yYctFmaJvXQdkYjE8+y+V0xdwpONo8vhbEMNZJyXWYZxxwawjKhCvZ/Nt9szTIRG3UTAkgFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wsbWATYAuUJOtwXtqdwT1Doc7+IdQyBsZs/DW0YScAQ=;
 b=KsFEsJBUeg4IBiFFQX//Rwzqx4/xdbKpkDGUJ/p30PsdoBbBUIRNQYVzVb7ChFQ97qCxrjMhHq7D5XLU9aCHRWZJo7d2JTwYGl/srQ1JafrLeNeqkTWmECcHMD1IDNULmsDbo/lRDw0AuE6xhyS9pobOhjdBsx1DbT733Yol+8k=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Thu, 4 Feb
 2021 00:40:57 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3805.028; Thu, 4 Feb 2021
 00:40:57 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        seanjc@google.com, venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v10 16/16] KVM: SVM: Bypass DBG_DECRYPT API calls for unencrypted guest memory.
Date:   Thu,  4 Feb 2021 00:40:48 +0000
Message-Id: <a6a3826234bebe908290bb3f6de35356f44acbb9.1612398155.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1612398155.git.ashish.kalra@amd.com>
References: <cover.1612398155.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR11CA0015.namprd11.prod.outlook.com
 (2603:10b6:806:6e::20) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SA9PR11CA0015.namprd11.prod.outlook.com (2603:10b6:806:6e::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17 via Frontend Transport; Thu, 4 Feb 2021 00:40:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 05259c3a-881b-4a0a-d49d-08d8c8a58959
X-MS-TrafficTypeDiagnostic: SA0PR12MB4384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4384D89E05837D31646573378EB39@SA0PR12MB4384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:369;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wKjtkb7Z6q5qfXSWQtWlCYiJJFRP+Lm8Ie57JU1sX8IuHOKCBQBPn2dFllz6dpnmLCspVaVvDjmmTG2TiguPfURiWzEesij5GX73ruD3O6wA/QTjEbx247xIJBz1Ut5qQibKQ4SrcAFNcBp9VPEbofH/1A6klRDNPJsyOHMQ+zMo5iJdhCE8UxH7PIDmDfcRSwc1Q5BgpctIyx3eCs4jJ9WHdWWiE0n+wTFiuTfm/rKdVeAga2tIeEUEBopQQdsuISnvUD265ig1Py2w+mDifSAwssJWzsUpbPo/CKdmban0HBlT4pLWg17cNn8HMHC9PDXrGRoTjhrf5BqHKkT3E/Q+KKfZ8fqDL7rYyPvhJ9ZfZDkXgkS+4C9prN0eb/fxuxsvJhoX8X8ZA5mN9ZiCvtcM3r76ib/aVdZH2ZJK1TnIpH9eRk+OXSExcXVBFozjl77galFPN23yrKIsIWM5vHYnSBIDxPokfhuMqfzZuZnps6ORrP2U2rHjsO0uf924BCyQXTi9bK2co53zlNrqug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(366004)(346002)(376002)(396003)(8936002)(4326008)(66556008)(86362001)(6666004)(66476007)(2906002)(186003)(478600001)(26005)(6916009)(6486002)(5660300002)(52116002)(16526019)(36756003)(7696005)(7416002)(66946007)(83380400001)(8676002)(956004)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?reCgN7b0FcgEBoMsWLSCo+aLM5209+563UqFPbqrTlP9kQuP9t5eVYKUY2s9?=
 =?us-ascii?Q?KLb8bp4s0TGEh+/WkMzcDMOMArXKUzMC+14jBesPUEymL4OBiaCLvEX8eHTW?=
 =?us-ascii?Q?mL4tDyy79nfL3WlB3NuqvriZmJoLtVxmqCYECSgInRWSmcZbWS1r7wwDWfUL?=
 =?us-ascii?Q?Dx35+8hR9rs21atOl8h+E8TCxH6+MNEEJepb0bgxijtSQjhO1H9JPLEkCrQf?=
 =?us-ascii?Q?Mh7zHUR3O+4HY5YJV4fRGYs/3omyleCpe/0kKL1sDpkOAADZMcVBedFpq6Sj?=
 =?us-ascii?Q?WPANRVBlbEKYGwrBISBrqI6A7L+P8F6YDDogaTagE6pIChnZZ9sKjp60xs4j?=
 =?us-ascii?Q?1OCXCmGsboyIDj/JjBgCnwuiuE6U3s3hL98C0MiBEwOPaQg7+Z8DwS0bxtwo?=
 =?us-ascii?Q?cz2hq9IO8u61KNBKsLO0Rw8U0ZtTlRVTPxCDld7m8f/X9ssH41JXjGDj7Fgt?=
 =?us-ascii?Q?S1bPEmzl+OoHyfHC+f0ObKh5wZrCxMIOFwXbNGXxatxE8fbubu9xYuRllIXr?=
 =?us-ascii?Q?S/6fsM/jdEQH8xG6jps+o2KyY1KIbGrWFLkL3l2tA4HalLEAt+VZdJPA3HQv?=
 =?us-ascii?Q?VmhcvjEw4hqcXEZXvKYgcgBIiaHGDowh+vubBf7bRLWY/Jk+EON1Qb2gQ/KF?=
 =?us-ascii?Q?yuC+BARMVqnd46PBi4qSMRpHAQJ4Hnd9vHq4cxNhzYyKc5IPMD41eKYBEr83?=
 =?us-ascii?Q?MbYG9XD8o5mjbHJimUHaFP1bvD7F/2hk/8xxcZ+Ur2fapku0O6YLiZU5eNdE?=
 =?us-ascii?Q?wA51zIpLt1O9qCDwPTwwBC/VISYI6lm8TulvLaOXQmMMtwaFGEbSBgbCYAqK?=
 =?us-ascii?Q?NSN5h1yJ5SOj7lNtv7nX9Gua2Ib4MfFH8spjNHcMbeDOcRnIVT3G4B+zdP7Y?=
 =?us-ascii?Q?gRAcX8WPjfIH5tpULUpxxEuTUGLgln9a+z2uc2TMsC8gL1IzX8+eOxI7pWDR?=
 =?us-ascii?Q?a3dkFFSYaXEdsu6b0SjJAq4cjWUwQ4BbJsGYwKw7UNXOhE+XJVN0zJ6LGGjL?=
 =?us-ascii?Q?/4K921tAKW+c+xg5HVUVQBMzm5EU407vrDhs4FjeAFXX690VxDACQPdshRFQ?=
 =?us-ascii?Q?pDFeli0Ersi1WJ8AwJg5KNCjJBnHzMPxq64TS4aS9mgB6N9B9wZkcRa6NCME?=
 =?us-ascii?Q?rGS+t3GEGioo7bhT0D7Gkv0CEgdp2sPoIBb6txIBfuXKnhew/cNr38henm4v?=
 =?us-ascii?Q?nxD0f05a7g4GSoWOBgNce7s6FPK96jyFXN3ye/VYX8sz+BYBCrEz3RK7B40g?=
 =?us-ascii?Q?3q7l5TiI0xPqBrA9v/ghPU3FqXJ9tmaZWk9AoWcjR0O6lUi4qzC8BCfW/Lei?=
 =?us-ascii?Q?uwCTH+ZTNdNnEYyUyNOhEWDY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05259c3a-881b-4a0a-d49d-08d8c8a58959
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 00:40:57.3979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r3PXMQSebXh99vBwT/FOwQAl5BCAA2ukym2Uyw8vP1aGd6IeeUqmppNyuOzhZmAQrkktX8sIeZ3Z81napUD9BQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

For all unencrypted guest memory regions such as S/W IOTLB
bounce buffers and for guest regions marked as "__bss_decrypted",
ensure that DBG_DECRYPT API calls are bypassed.
The guest memory regions encryption status is referenced using the
shared pages list.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/svm/sev.c | 126 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 126 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 93f42b3d3e33..fa3fbbb73b33 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -888,6 +888,117 @@ static int __sev_dbg_encrypt_user(struct kvm *kvm, unsigned long paddr,
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
+static bool is_unencrypted_region(gfn_t gfn_start, gfn_t gfn_end,
+				  struct list_head *head)
+{
+	struct shared_region *pos;
+
+	list_for_each_entry(pos, head, list)
+		if (gfn_start >= pos->gfn_start &&
+		    gfn_end <= pos->gfn_end)
+			return true;
+
+	return false;
+}
+
+static int handle_unencrypted_region(struct kvm *kvm,
+				     unsigned long vaddr,
+				     unsigned long vaddr_end,
+				     unsigned long dst_vaddr,
+				     unsigned int size,
+				     bool *is_decrypted)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct page *page = NULL;
+	gfn_t gfn_start, gfn_end;
+	int len, s_off, d_off;
+	int srcu_idx;
+	int ret = 0;
+
+	/* ensure hva_to_gfn translations remain valid */
+	srcu_idx = srcu_read_lock(&kvm->srcu);
+
+	if (!hva_to_gfn(kvm, vaddr, &gfn_start)) {
+		srcu_read_unlock(&kvm->srcu, srcu_idx);
+		return -EINVAL;
+	}
+
+	if (!hva_to_gfn(kvm, vaddr_end, &gfn_end)) {
+		srcu_read_unlock(&kvm->srcu, srcu_idx);
+		return -EINVAL;
+	}
+
+	if (sev->shared_pages_list_count) {
+		if (is_unencrypted_region(gfn_start, gfn_end,
+					  &sev->shared_pages_list)) {
+			page = alloc_page(GFP_KERNEL);
+			if (!page) {
+				srcu_read_unlock(&kvm->srcu, srcu_idx);
+				return -ENOMEM;
+			}
+
+			/*
+			 * Since user buffer may not be page aligned, calculate the
+			 * offset within the page.
+			 */
+			s_off = vaddr & ~PAGE_MASK;
+			d_off = dst_vaddr & ~PAGE_MASK;
+			len = min_t(size_t, (PAGE_SIZE - s_off), size);
+
+			if (copy_from_user(page_address(page),
+					   (void __user *)(uintptr_t)vaddr, len)) {
+				__free_page(page);
+				srcu_read_unlock(&kvm->srcu, srcu_idx);
+				return -EFAULT;
+			}
+
+			if (copy_to_user((void __user *)(uintptr_t)dst_vaddr,
+					 page_address(page), len)) {
+				ret = -EFAULT;
+			}
+
+			__free_page(page);
+			srcu_read_unlock(&kvm->srcu, srcu_idx);
+			*is_decrypted = true;
+			return ret;
+		}
+	}
+	srcu_read_unlock(&kvm->srcu, srcu_idx);
+	*is_decrypted = false;
+	return ret;
+}
+
 static int sev_dbg_crypt(struct kvm *kvm, struct kvm_sev_cmd *argp, bool dec)
 {
 	unsigned long vaddr, vaddr_end, next_vaddr;
@@ -917,6 +1028,20 @@ static int sev_dbg_crypt(struct kvm *kvm, struct kvm_sev_cmd *argp, bool dec)
 	for (; vaddr < vaddr_end; vaddr = next_vaddr) {
 		int len, s_off, d_off;
 
+		if (dec) {
+			bool is_already_decrypted;
+
+			ret = handle_unencrypted_region(kvm,
+							vaddr,
+							vaddr_end,
+							dst_vaddr,
+							size,
+							&is_already_decrypted);
+
+			if (ret || is_already_decrypted)
+				goto already_decrypted;
+		}
+
 		/* lock userspace source and destination page */
 		src_p = sev_pin_memory(kvm, vaddr & PAGE_MASK, PAGE_SIZE, &n, 0);
 		if (IS_ERR(src_p))
@@ -961,6 +1086,7 @@ static int sev_dbg_crypt(struct kvm *kvm, struct kvm_sev_cmd *argp, bool dec)
 		sev_unpin_memory(kvm, src_p, n);
 		sev_unpin_memory(kvm, dst_p, n);
 
+already_decrypted:
 		if (ret)
 			goto err;
 
-- 
2.17.1

