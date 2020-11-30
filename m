Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9042C92BC
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 00:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388997AbgK3Xex (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 18:34:53 -0500
Received: from mail-bn8nam11on2064.outbound.protection.outlook.com ([40.107.236.64]:11880
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388951AbgK3Xew (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 18:34:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cELLfQkYLue05RdjMgNMBszhRRP7A6kGAnL0hYKIbyU3BYGs8HST3vIMzePhR+dVqUL/rl9h02tP9JEVnpsigF1+Mj4wEUYJNmo7I3QfP6VJlLEWfHJHBQykNmI2GbJkKluFfpcwAnbSb9CUMgEiwX3XaQgf+/y0bA+HvRDZXO5kwJSzNg/BI7UZ7VnY230P8wNpjCP2+iqJRpZdFDXsjfCVXrfDbPrWSUkqPQ9M736diYPdHzCzMzfxrD+aBtfkXoMaXCChAr2M/pNU1qVLq+0UgdfNyitDNi3ub0W+UjD9dD8L0hCKFgRChLns9U0YoiFr7VH7ZmgidozMl2ZXQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8/74j3Bng+v30Jvcj+OAfvabtGBBqTJhxgRHD6tfhu0=;
 b=IgssKWuu3Ha7J87kdiOc3eusoKgKuIbp2AcwTwaBV4JCsn37LDv/rpSYaeXZ2R4OYDWco/evTEhUwsx3hB4IWSWXMoTrx0iFl5UlQx/LgEX6m+lWiXigIWdC34JZL+zHsIFY/SaC/Nf0hRCAQ8YFfQ6btzhRMguUO0ewa/dNYT68Pk2g1ELdJ17c7aasADkA2z/1farOskIqUguCtrjMgQucdv6bo8Gv/TnuFuX3AHUg0k1yHpwrMFUt3zduSMKBJHA/KchcW3aql44NvWGLfMRbgNxzd2S6n9zb0IbQQcejJlCQm9p+C2lUO+PhnsjjoN5hj3trf75Hp9XDGrfucQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8/74j3Bng+v30Jvcj+OAfvabtGBBqTJhxgRHD6tfhu0=;
 b=LeAmU3Iyf+n5Pm9OoZcqVTEP5df1/O2+V1DsU1fbduNIUvwSKSLJGq8V5IXZ/+zpu0wTbEQas35UXsBaV+PHOhxPrUYMbGjmT0jeKjzvUIU7ibhvTDaJWmwaUv11QbGb/7LPO4XdldUIVSZ7caw5kuV9YOV+BGo5RoS5HmZwuFs=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4509.namprd12.prod.outlook.com (2603:10b6:806:9e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Mon, 30 Nov
 2020 23:34:12 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3611.025; Mon, 30 Nov 2020
 23:34:12 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        brijesh.singh@amd.com, dovmurik@linux.vnet.ibm.com, tobin@ibm.com,
        jejb@linux.ibm.com, frankeh@us.ibm.com, dgilbert@redhat.com
Subject: [PATCH 9/9] KVM: SVM: Bypass DBG_DECRYPT API calls for unecrypted guest memory.
Date:   Mon, 30 Nov 2020 23:34:03 +0000
Message-Id: <9d82016559ff5397fba0b6d06c54526396e24c1a.1606633738.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1606633738.git.ashish.kalra@amd.com>
References: <cover.1606633738.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0401CA0047.namprd04.prod.outlook.com
 (2603:10b6:803:2a::33) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0401CA0047.namprd04.prod.outlook.com (2603:10b6:803:2a::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22 via Frontend Transport; Mon, 30 Nov 2020 23:34:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6891bf21-f430-45dd-49fe-08d89588717e
X-MS-TrafficTypeDiagnostic: SA0PR12MB4509:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4509F41ED88740AECA5829038EF50@SA0PR12MB4509.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:747;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3XiFTvT5SPY6GMhNxnKk6F6aOlm0qdMaoIx6FFmpmjPNGB+E87s1avYAfj+0ip1BzHljz/45mKXjqSOOBJI/Gzf7RdlLKDg8xv+ECzRcCSx7Kmbhu8Z+mtqlAPIHg3DFY2fONvEkRwZozj7rQzqied2S0qbr9sOIHm3zCP0x47FudbRyUyB4kOBMORwBY7zA7lO6YfimdvuE/HNzgktEwIPeJnuSy718+Xdcunh/Z3AHkHcNHYLbsYdKK1BxkBtl/k+KOLSeBH2lZRpBX4JQc/wCaQgYhnO+eG0TC4PcFZjBsvDuN+RwI838cOBeyfr6vN0MavRFbNCGkC/x4gmgPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(26005)(83380400001)(956004)(5660300002)(16526019)(7416002)(4326008)(86362001)(2616005)(186003)(316002)(7696005)(6916009)(2906002)(8936002)(6486002)(52116002)(8676002)(66946007)(478600001)(6666004)(66476007)(66556008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: PVUEiK3m+hKZ8SNyrH44Lei/UG3ZvywVPoKo7hktD8NoiElQshT8qmSrd61yk7HrFIlAZfJqHvhK8LUv288kd3spbJI2aGV6bhYoZCziU+8Fx8iRLJn07CixLCYvq7ZQvzFPPatK6XZIlfv3kkqRedDIGinzbtwK+nJqFN0763OyBSK2mpyLe9mXVBN615b8LjZmL0UIR9JsbA+lm0eyVZygsTf6LIKsJidsaMqo9FcwljpceAZe5SECkm2F59OZ8eFUIjIAsthWwjf3Y2CL+59Sfbdy0ICAuRk/GJH1wsBr1X3BLtWmiMY1AYuAzb02YoS8ATpiJ/lakHBm467cuiATOWi7wqh0AKF2fH/dj5PzHUF20JBDbF+r6GgZfwMOXxxydAK5sWWpNFrU9ajTm2wTEN40xnxbIZ7eWe0b3XVogLZiAwv4USYZeeCniADndLcQxTZMBMFgi4pEW0VhaML00Vwb3zyrPZx/b3NIWFRPlmAJtYcm55cH10IUIMMNfLN2RZDf1Pl02oNMNj0upDAD1jwGHlV4/bXMLxN4DCAX6B/DjCKVrQevhZwmGyqGXx4mlEqp9xE+Rmw0Yc2ObjADObl8thobgvp2WImWyc2KKPlfRYlz+z16fp1TerR5WjXwoza18IyzeaQevByjZ08sUBPZg69+b4oEK8L28+d+QcL1tjAnNBRjmq64lSJjw4UEwwobS8OnKsCWYugHTPSfSrUbs//oVh1kN/H9lh20Q4QplIdU8u7vJjnARXzP
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6891bf21-f430-45dd-49fe-08d89588717e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2020 23:34:12.6437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5ZGXSzZdi58TVzq9we1w19Li2VLvzXYileM+lzbUaX3lxWf/33gQwqevgIIGQ14oUUssb01elinQ3HIDZk5aEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4509
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
 arch/x86/kvm/svm/sev.c | 74 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 37cf12cfbde6..8b3268878911 100644
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
@@ -792,6 +823,48 @@ static int sev_dbg_crypt(struct kvm *kvm, struct kvm_sev_cmd *argp, bool dec)
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
+			if (!hva_to_gfn(kvm, vaddr, &gfn_start))
+				return -EINVAL;
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
@@ -836,6 +909,7 @@ static int sev_dbg_crypt(struct kvm *kvm, struct kvm_sev_cmd *argp, bool dec)
 		sev_unpin_memory(kvm, src_p, n);
 		sev_unpin_memory(kvm, dst_p, n);
 
+already_decrypted:
 		if (ret)
 			goto err;
 
-- 
2.17.1

