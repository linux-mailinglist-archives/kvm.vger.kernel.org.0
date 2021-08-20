Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF8BC3F30B2
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236739AbhHTQCv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:02:51 -0400
Received: from mail-co1nam11on2082.outbound.protection.outlook.com ([40.107.220.82]:59393
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238379AbhHTQBo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:01:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IAH6GotQA2X0s3BRJosN4Hj1Nk/0CBTX1xAboJuFKmb62Og62d1AErT8HbkjyJJ37VUxYaCKMxb+WuTMfMBLigEDnQ3vm7/cerZr7rpQj2S6LRRVz5I56ggmNkIDnrT2jKEqlNVsSaoBCBeR+6QbXBhbylQHbRknPzqKxUbWfDbYgeWh6kvsqJdpppp0kkfGyHTDnODzVz1IbrFsy4GCi1/Et3Bg4bmYzKTY/4sH5c/slg3NmSkfqx3sii+VuojZqSxsU+ShYFHrhToX7r0J60tzJ7trjNY+cSBCgFDoqs5s3g247+v4PoUAkA0Qt8hwO7khMhTN+2rqrUWNV7LH2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/GoMsrfjUi/kgw9wBv8ov2FQ/Bd44cHkwYsWl4zlNzU=;
 b=D7lmnQlVFlNa7jYR45czEW0wNR4AR5AJuQRokImPaxpitdIt8v56BFfu0kLECXQmaz6CgNvmmVURPw0mNEFCrLMZFu2faW89PXslq433978VKTbSx50aYWcg5dc4QEPUoTh+/veQHYBaHTORkIn+86oHi5vo1T51e6XlJCBAP0zIJxOYbUUjhiLIBVjElc5fyEDvxSjkqvduhsD6U/UanbK0Tw2JhEyuR/lOgKWXJLVijwFi9OH+VMb0JedPiuOUObvDxhdWW8xdyug8J7huUtS71nSQJVhsCf6tLqw9UDv+StwPPTT1LgcjcHTcyu7iTxQH2vy/i323lCGmUb+Qnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/GoMsrfjUi/kgw9wBv8ov2FQ/Bd44cHkwYsWl4zlNzU=;
 b=lpm5PvVBQKPnTzCQhI79i+Io2tmjyIPzzAOQ8FHeHvxSvvvqYZQEtWzTOsgcE0yhoF+Cu1tIeX3KW5FtAQgWZaDGE951vKAGIx39fjFy8MXWkNeBRflKNr18m5bPcchaFoEg3NJVCqE2axWWdFUH3jNzLHtyMCMw4+p+i/j7z5w=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4574.namprd12.prod.outlook.com (2603:10b6:806:94::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 16:00:29 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 16:00:29 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 v5 26/45] KVM: SVM: Mark the private vma unmerable for SEV-SNP guests
Date:   Fri, 20 Aug 2021 10:58:59 -0500
Message-Id: <20210820155918.7518-27-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 16:00:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b7c2830-a8e1-496e-0fbc-08d963f3a0b0
X-MS-TrafficTypeDiagnostic: SA0PR12MB4574:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4574CF07B8B84270E4D9539CE5C19@SA0PR12MB4574.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MpYWWrgN/v9MlCNoOVvy+F9aIfktA2AcgSfCbC+KI+XfMrWxnnNm39R7OhJzyMtEjQPh73mIHC4qh/fvlnwP70e/rJkZP97ULcsiY3jKS0rGlkeQlAVKQxauSbtwPkUBOKITQ7OGXMwj2CpUIYXnZHZR4/rxgwFJdfS9x0oxogydUNhdWxe1uBCtizIMMmKS8auaRsZ+rVN229ghvBpHBzRGjRlMJiyLYOAtR9ZI/9eBMBeIFVOVdb/op1xvUrFkqfnPk9QuIqNxf2rxqHGuWjmrcUUHma2fHbPHAFEJS7LqvS1hYv/mY1t+xjr9GfeCiq8h3FmzzpRvi1FPyxBZoXreMC+8raJyNZNruaRt0BAUbOIOA2q3te7k3BInMCoQx9JKCJ1us3BrjHW0gx8UCEAQB6km+NFPyi6oQGm306tkiQssOfEJrIAXv3s7ZnkbW+DnK2EjJicGLDM8cTU8FeAAXxttCXGw599oZCRgK2HBCgAKqtUPuIiRQSQQmZFaqbS/7/6H1VNNFjng59HMaE0qp/sC/eo05qBnCTjsBjEUlZ0Ktzk8D7LW1Zjm43KZ1XwgpYen0wrUUtvFwItrPB5XitkpuwN2YSZau1ZxkzfFOOrVjJmYexFYzl3mXTW2r6Wpgob1cX5ocAQXk+O5iGlbF3pN9oZoapqW65dyTrP0MevENV74s5+ixQVWQ29J7lyc9kbFbwqiUv0NWh/d4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(346002)(366004)(39860400002)(1076003)(38100700002)(316002)(38350700002)(5660300002)(26005)(44832011)(4326008)(66556008)(54906003)(7416002)(7406005)(8676002)(66476007)(86362001)(66946007)(6666004)(2616005)(956004)(8936002)(2906002)(36756003)(83380400001)(478600001)(6486002)(7696005)(52116002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QQ7EcEs8emAgmSzQwJNDG34pxP/sn38AZyB+hM6ltOF1cWhwpWCsSWmK4HiL?=
 =?us-ascii?Q?i6Yz9sGyBmMBAoZGF6rjuJS6TBo6p9NMqw8nXXLJG0vgo8pCrfh9Q2++abK2?=
 =?us-ascii?Q?oHfiMWz6mxHcWIUBPj9M5/F7RMMqrZcynPvHUu3GJ6fh/m3pD1tkHQN+5pbH?=
 =?us-ascii?Q?6bd7469kDx5vDNZUUUP/BNDZ5eu2PQpw+ZeDFdRGySj/VqY124X7GvKkU53f?=
 =?us-ascii?Q?qMegfmtHtNJ4xlogpPSCDu17OdLnQBDdEnikOQc8KMWYKtBy/JAk5Zdr3d6C?=
 =?us-ascii?Q?uSrkwWG7zJQjD5/Xq2BY/VvKvArYaK6q7esKb+57/ft4bZe/46Od53m4eBve?=
 =?us-ascii?Q?krVNfJVh0uigHY8rHRd8qLN/hBlofcF+nlYGA4Y3mXhzzQ+zNf87qWuNj5/+?=
 =?us-ascii?Q?2LnrcaqWrTmeBZeLD9GjE05qW8U58VJiENldMUXdU2laz2123J2qOFXNe/XF?=
 =?us-ascii?Q?IUuAERt/FrzSmFybygB2NjQMd10ozf5UPfy/LXEx4E3Ao2O3drxymhvTUvL/?=
 =?us-ascii?Q?9eAAIJvA/eYagBvzXxJPmXCEv2OXH03x1LlsxzDwzX45mEbIrjUw8Szpy0t2?=
 =?us-ascii?Q?5mDkJdAXr8o/5fu9+iukeHBJPMA6TD3xgAYher6VuFeabhRCgOj9Ogha0c3V?=
 =?us-ascii?Q?6aae1Viw2RyZxQqBp9jNpv+elzOfzBKizAPW1Qr77W+HPAHb6dvStpRNmjEX?=
 =?us-ascii?Q?EEMXP9JPYBV3HQCqHfIt0OeVFXgZDN7lB2DPPX+oPCfAcuJ++PE3rTXa6If0?=
 =?us-ascii?Q?RAay0sde12uchr5OFsg28YH+IAxwg7WMGJ/ni1P7wWwRs54kpGSO5mkmHIFO?=
 =?us-ascii?Q?oapzqtR5QVOh6GXjq4okwz2JUuDNkq46BLk8KssYlfrfHLAVhaGtB/dL9vK/?=
 =?us-ascii?Q?2M425IVZZDaJXv13Wl9eJkVQ3P9AYv27RE+prAXvX3bt1gFWGOX586ANPeGv?=
 =?us-ascii?Q?mpjov6TREpnNpdUXTsTmxtQ7WU8veKGkKq9gVWaFnQyRd/E0ES0sQt4mHECs?=
 =?us-ascii?Q?0KOpOcZGC7lxDk81/FNVajEEGRPsd1J4et4k06ruOBMtlKi8VHcPq83lIf1A?=
 =?us-ascii?Q?82YHu1GSOTRDhWrpKlynjbNd8Oh8EMtk/Lol3uzw9yefGP9iqqFSQcJqHkhb?=
 =?us-ascii?Q?Ega7VnLTpfaMqygo04g7kEH4ULwOFT4YUngyfYB2hC4KE5s43vog3VnckQ3Q?=
 =?us-ascii?Q?N3r5tCa24PxaWE+gvZVKIzi1dai9ChsqhOVpo3nLZRCGt2h+1XZhN0f2prJF?=
 =?us-ascii?Q?Ojku3SNGwE/MxCk/uKXlI1Uv4Nudd8gtC86ccnm9Q/nT3PCMU8u4+TobDDNa?=
 =?us-ascii?Q?IyzR1tMX3FhoNLTKwXcqGY2b?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b7c2830-a8e1-496e-0fbc-08d963f3a0b0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 16:00:27.5520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oXr/N3c8IHYiypjjkiTU9twYvdaumofKq4gNqouF9E3rJYHRvseA46OoPkMahIFVaMGjYve384tDNDXDyR6gPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4574
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When SEV-SNP is enabled, the guest private pages are added in the RMP
table; while adding the pages, the rmp_make_private() unmaps the pages
from the direct map. If KSM attempts to access those unmapped pages then
it will trigger #PF (page-not-present).

Encrypted guest pages cannot be shared between the process, so an
userspace should not mark the region mergeable but to be safe, mark the
process vma unmerable before adding the pages in the RMP table.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/svm/sev.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 4b126598b7aa..dcef0ae5f8e4 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -18,11 +18,13 @@
 #include <linux/processor.h>
 #include <linux/trace_events.h>
 #include <linux/sev.h>
+#include <linux/ksm.h>
 #include <asm/fpu/internal.h>
 
 #include <asm/pkru.h>
 #include <asm/trapnr.h>
 #include <asm/sev.h>
+#include <asm/mman.h>
 
 #include "x86.h"
 #include "svm.h"
@@ -1683,6 +1685,30 @@ static bool is_hva_registered(struct kvm *kvm, hva_t hva, size_t len)
 	return false;
 }
 
+static int snp_mark_unmergable(struct kvm *kvm, u64 start, u64 size)
+{
+	struct vm_area_struct *vma;
+	u64 end = start + size;
+	int ret;
+
+	do {
+		vma = find_vma_intersection(kvm->mm, start, end);
+		if (!vma) {
+			ret = -EINVAL;
+			break;
+		}
+
+		ret = ksm_madvise(vma, vma->vm_start, vma->vm_end,
+				  MADV_UNMERGEABLE, &vma->vm_flags);
+		if (ret)
+			break;
+
+		start = vma->vm_end;
+	} while (end > vma->vm_end);
+
+	return ret;
+}
+
 static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
@@ -1707,6 +1733,12 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (!is_hva_registered(kvm, params.uaddr, params.len))
 		return -EINVAL;
 
+	mmap_write_lock(kvm->mm);
+	ret = snp_mark_unmergable(kvm, params.uaddr, params.len);
+	mmap_write_unlock(kvm->mm);
+	if (ret)
+		return -EFAULT;
+
 	/*
 	 * The userspace memory is already locked so technically we don't
 	 * need to lock it again. Later part of the function needs to know
-- 
2.17.1

