Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C75503F30A6
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235310AbhHTQCd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:02:33 -0400
Received: from mail-co1nam11on2054.outbound.protection.outlook.com ([40.107.220.54]:58929
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230039AbhHTQBl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:01:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OVWA22obn2+/nu1CmudXVUNyhRbbOxJ6C+BPkKheP7iDFruWFe3zTfFCtoHgm6+mAupWlDJ0KL1zbsVh3sKzQ/xZrOGnot5Qo/u+XIZQ+bXYLXwa4/XNOUkKEm4olTVlj+FK7bXYuy2qAaek/+EfLXXoEYt6B0KPS5EZDP9mhX9Sg2CeFkv5Nu2gSBE4Zyx0IMumpjCTRbYOwVDxB/cmKs8gNKyK5Kv499MBHovarJIgC16D61dTt59jvHTlQoMy64O9DUfASu1jdk3MCyhAgxdblhtCgodrcKiJx5CIpYc4ou41EgqpEQLPQV1ZWR5sVbkr31lFj3jKjQcuP7fhNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZKtzTgCwBcMrEh+41fiavNBlg3Ad7ktpHyNHUcdRJqk=;
 b=Grqk/1O3JEUlIya0lkymrXZpCap08Kcyv6mQOmMb2bL0Vc1HdhIhbIASLzzO0hTFgZBQzXbZeJAr1W0vGiQjNdyoTwWQde7N4zsopIRE8rtrVF8jsyFaTgnSelRNni52FM8qeoUXpx5Ck1p6xDES4reI4147G2vcPcawZIm7MfvfBv6pblLF/W35EKFYVLf0hoBLMTXL97v4fL8Ogdf3jmVKg1iazA/MCj0o16k8Dp2+H3Kb+wl8sGMaDtPxCj3tHm8TAjAGJiOGeHq6L1yv3APDq6S/l7M4AWRYDboMJ0LQkZyIIP+W7emQd97m8qfM3DBJeSXDX2o0ThuQONaInA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZKtzTgCwBcMrEh+41fiavNBlg3Ad7ktpHyNHUcdRJqk=;
 b=SdZK7DBa6IukiCvLRSZRTGRiN0O/P1XybpCzInfGHsIaclXOMkEvDIHIChP3ykhQ8GZQJZ5nsL5Kp1uLVoRFORxI9gDRFPrvWPG6jdSPpoY2uk+u/8kbiX2HdKBrH1xWPuXwsr1VzYQBG0pUX1d5cr/R7muWBKReUWJGmi3HTjM=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4574.namprd12.prod.outlook.com (2603:10b6:806:94::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 16:00:28 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 16:00:26 +0000
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
Subject: [PATCH Part2 v5 25/45] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_UPDATE command
Date:   Fri, 20 Aug 2021 10:58:58 -0500
Message-Id: <20210820155918.7518-26-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 16:00:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b887704-238c-4bc7-3f98-08d963f39ff5
X-MS-TrafficTypeDiagnostic: SA0PR12MB4574:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4574CBD088573A9AE4EBAB96E5C19@SA0PR12MB4574.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0fEwu5MC68ssAYIH9kMwrBItIjaSxrJRzeTXhRGRWvA2b2ZrkEqmk04mpqEcprAPv6kTfNjmQJ/iXSzFLmXXe3RAi2sFzFEYKTyPqVTu9yqs6qD+fkbczWrOylqssmGrNgTxUSvjKqwC7oMqLwRp7MXgIdQRPgN7HsykGJrBqvnsAMuvogW6jUIf+u7CdkG9YcK1XGglEmVuEm4d0ylIzrriRuCSdJYJ1v1BFGXqtLLr2FxoFuOH2RALzFBYceJQT0X8frR90C5l3ufhNo9SvEVOq3HUdXrdbJMgrstmEdlW/oBfe4EDYfr6Q8Inm+KZMnpO+vAwyBf4WxnYeiRPQSOLCQZHufMqnGDgddKL5tKqvuBF/R0XZ3rNfQRDgl7Wvkp5aIyWgowpa8fxdoVqxRNU/SEZS1YbrmfZdIuCvcc4DW3tmB1ssvvp/GtHbU9YO3JGjybIoPLYjN+ocPn5G5caMd+QTlMVWidPwl6KTBrTezB95kpcw1x6/w9dFGP3mU+nmEIJTNybJxIuuaXO4cawLW1TDwhs1yiTwodp5eerJv1Vef7ysR3a/5BbjOYQA8hDuG6N4zZvkvN06vOJgiVXoVjmhaIZS2tz9b7bkJHh94lhkj4w9twl4b7OcAKK/GI24cbExWRXXOIHiFBzxfG4nrjAQ/qgaCi8hYN0H4nrd15IZW3DE9lyi8Sao47tCd7J5M1rxfGVh9QdWpY6Sw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(346002)(366004)(39860400002)(1076003)(38100700002)(316002)(38350700002)(5660300002)(26005)(44832011)(4326008)(66556008)(54906003)(7416002)(7406005)(8676002)(66476007)(86362001)(66946007)(6666004)(2616005)(956004)(8936002)(2906002)(36756003)(83380400001)(478600001)(6486002)(7696005)(52116002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ohJGmdiU6S++lLUteSgUjkBfPNxNT7a6yWLi30kG3nhaDknDYNI4adCwVd9S?=
 =?us-ascii?Q?zdjZGsur25G8R+lSt2ODKSn6TuA/Rb4T9nJYui3HdYUTrlh5cWDncEKEalCU?=
 =?us-ascii?Q?8z16rf+rxtIk+jA33G+SJIebDr3qWw8lTIJfPNhEvjY57jI59x6YBPklYfUJ?=
 =?us-ascii?Q?9lbyudcJcFO3u1QCgzJP/7yxNWCeo2u17o62UFWgizxe73d3tYr603NcTown?=
 =?us-ascii?Q?NIMqRMumgn1jm9TNm7XpqAFrluMzRP+kwggV36eGn2WXsc07vcRE/cygwhMs?=
 =?us-ascii?Q?5M01t7tG+bQc6LrWT6WHeUDsXmrRxt6N0TNHHzoo4yL+du+Y7iUjN9h6aaZH?=
 =?us-ascii?Q?7ZH2ujZFA4EWUcFKpfRPBVutcatrixaXLxEX3QWG1vU+ZUJ5MrBKZCuoSMSm?=
 =?us-ascii?Q?Qwq2PaAMJQr5Qh0/fWJ8kwgcgAICnYXv2mTNu+qvrVP7VAStGEaVCwXhxbJe?=
 =?us-ascii?Q?vxZx7v5qYSLvN5YaOyhme2t7SpBpa0WKkRGIsgz0pVVIZuP9FqdLXDumv4A5?=
 =?us-ascii?Q?dIU1kFzHVg2vA9Lkn8CnSRNy5X8Ng8OLF3NrXtlajyXQxx6FV769UNk81v5W?=
 =?us-ascii?Q?nf5yVfJM+FsSsyycZRfQQmwNhxgFiXQZzzL6SWvudxR6juX/GLyeQRKcvf1X?=
 =?us-ascii?Q?8v0+YpLHK7cjnILEjUJ7nu3yXRUb7PO9Yq1ECHZuciDUSOo7rdaZaUUuIPRo?=
 =?us-ascii?Q?XO2Stl/mUXuCokZSn7Xv2rsesjvnHYJflXMt/XBh6ftSLecVI3MRVIFWl0TI?=
 =?us-ascii?Q?KQPSdgQeule9fDdlS0qXbYXo51/zsoqUrIQwqd+Jed+Hr4KUiuuIzvf7rvV0?=
 =?us-ascii?Q?hu5ZOfy6gy8ALcvbPAnUoEwfUF5rsJlhieKwrZ9jTNmKpQmq7in3yRYSq6ws?=
 =?us-ascii?Q?48YhIUtLXQ/oy6yL/cCngsJURzHvzkkuUFquvaQxc2H6xK9XIuTO2f+B4D14?=
 =?us-ascii?Q?oKrrvUSUH6Z1p4UdIWN5NPVg7G1WrtBd4Pb+Jlz6bFTU9mIHFNq6IVd9wQCG?=
 =?us-ascii?Q?c6OVgYNEhZyE7Q27xnSMecNzmgwVVfDzlD9PAEOGYxNFjNuzyhiLHBJyaIXg?=
 =?us-ascii?Q?XwDM5sQKCwURK/eNqbiPUOSMu/FV8QSgd7QUc9B7PAcZOXaeyB2X2tGn5nLc?=
 =?us-ascii?Q?tr1UqNrK5+8Hm070WnJteiT/dz/lwczlxTl8Bfdvnje3+wSuk1KG8GrcxvIV?=
 =?us-ascii?Q?r5z94DnMlOfGp1FywXKMCib4GrNDaf5ABGWYBHEQiCaHTlS4dZm3snkcw0aj?=
 =?us-ascii?Q?Nfy+zZwjhu+dECBC+wjKnt/4sm6539o8NYGjjuNUO9MZ958q+J3vx4U8NKjC?=
 =?us-ascii?Q?RZb+A8AYcMzsIqlPOBbAfP4M?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b887704-238c-4bc7-3f98-08d963f39ff5
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 16:00:26.3667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6/LWPlBXTLswztQUDFurUbFUNfonmnBClZSnOpLmH1ZWDHNNvXDoq8JGkdsW1CFgwZFRjrSZ7D/qOphcqsV5kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4574
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM_SEV_SNP_LAUNCH_UPDATE command can be used to insert data into the
guest's memory. The data is encrypted with the cryptographic context
created with the KVM_SEV_SNP_LAUNCH_START.

In addition to the inserting data, it can insert a two special pages
into the guests memory: the secrets page and the CPUID page.

While terminating the guest, reclaim the guest pages added in the RMP
table. If the reclaim fails, then the page is no longer safe to be
released back to the system and leak them.

For more information see the SEV-SNP specification.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 .../virt/kvm/amd-memory-encryption.rst        |  29 +++
 arch/x86/kvm/svm/sev.c                        | 187 ++++++++++++++++++
 include/uapi/linux/kvm.h                      |  19 ++
 3 files changed, 235 insertions(+)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index 937af3447954..ddcd94e9ffed 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -478,6 +478,35 @@ Returns: 0 on success, -negative on error
 
 See the SEV-SNP specification for further detail on the launch input.
 
+20. KVM_SNP_LAUNCH_UPDATE
+-------------------------
+
+The KVM_SNP_LAUNCH_UPDATE is used for encrypting a memory region. It also
+calculates a measurement of the memory contents. The measurement is a signature
+of the memory contents that can be sent to the guest owner as an attestation
+that the memory was encrypted correctly by the firmware.
+
+Parameters (in): struct  kvm_snp_launch_update
+
+Returns: 0 on success, -negative on error
+
+::
+
+        struct kvm_sev_snp_launch_update {
+                __u64 start_gfn;        /* Guest page number to start from. */
+                __u64 uaddr;            /* userspace address need to be encrypted */
+                __u32 len;              /* length of memory region */
+                __u8 imi_page;          /* 1 if memory is part of the IMI */
+                __u8 page_type;         /* page type */
+                __u8 vmpl3_perms;       /* VMPL3 permission mask */
+                __u8 vmpl2_perms;       /* VMPL2 permission mask */
+                __u8 vmpl1_perms;       /* VMPL1 permission mask */
+        };
+
+See the SEV-SNP spec for further details on how to build the VMPL permission
+mask and page type.
+
+
 References
 ==========
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index dbf04a52b23d..4b126598b7aa 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -17,6 +17,7 @@
 #include <linux/misc_cgroup.h>
 #include <linux/processor.h>
 #include <linux/trace_events.h>
+#include <linux/sev.h>
 #include <asm/fpu/internal.h>
 
 #include <asm/pkru.h>
@@ -227,6 +228,49 @@ static void sev_decommission(unsigned int handle)
 	sev_guest_decommission(&decommission, NULL);
 }
 
+static inline void snp_leak_pages(u64 pfn, enum pg_level level)
+{
+	unsigned int npages = page_level_size(level) >> PAGE_SHIFT;
+
+	WARN(1, "psc failed pfn 0x%llx pages %d (leaking)\n", pfn, npages);
+
+	while (npages) {
+		memory_failure(pfn, 0);
+		dump_rmpentry(pfn);
+		npages--;
+		pfn++;
+	}
+}
+
+static int snp_page_reclaim(u64 pfn)
+{
+	struct sev_data_snp_page_reclaim data = {0};
+	int err, rc;
+
+	data.paddr = __sme_set(pfn << PAGE_SHIFT);
+	rc = snp_guest_page_reclaim(&data, &err);
+	if (rc) {
+		/*
+		 * If the reclaim failed, then page is no longer safe
+		 * to use.
+		 */
+		snp_leak_pages(pfn, PG_LEVEL_4K);
+	}
+
+	return rc;
+}
+
+static int host_rmp_make_shared(u64 pfn, enum pg_level level, bool leak)
+{
+	int rc;
+
+	rc = rmp_make_shared(pfn, level);
+	if (rc && leak)
+		snp_leak_pages(pfn, level);
+
+	return rc;
+}
+
 static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
 {
 	struct sev_data_deactivate deactivate;
@@ -1620,6 +1664,123 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return rc;
 }
 
+static bool is_hva_registered(struct kvm *kvm, hva_t hva, size_t len)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct list_head *head = &sev->regions_list;
+	struct enc_region *i;
+
+	lockdep_assert_held(&kvm->lock);
+
+	list_for_each_entry(i, head, list) {
+		u64 start = i->uaddr;
+		u64 end = start + i->size;
+
+		if (start <= hva && end >= (hva + len))
+			return true;
+	}
+
+	return false;
+}
+
+static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_launch_update data = {0};
+	struct kvm_sev_snp_launch_update params;
+	unsigned long npages, pfn, n = 0;
+	int *error = &argp->error;
+	struct page **inpages;
+	int ret, i, level;
+	u64 gfn;
+
+	if (!sev_snp_guest(kvm))
+		return -ENOTTY;
+
+	if (!sev->snp_context)
+		return -EINVAL;
+
+	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
+		return -EFAULT;
+
+	/* Verify that the specified address range is registered. */
+	if (!is_hva_registered(kvm, params.uaddr, params.len))
+		return -EINVAL;
+
+	/*
+	 * The userspace memory is already locked so technically we don't
+	 * need to lock it again. Later part of the function needs to know
+	 * pfn so call the sev_pin_memory() so that we can get the list of
+	 * pages to iterate through.
+	 */
+	inpages = sev_pin_memory(kvm, params.uaddr, params.len, &npages, 1);
+	if (!inpages)
+		return -ENOMEM;
+
+	/*
+	 * Verify that all the pages are marked shared in the RMP table before
+	 * going further. This is avoid the cases where the userspace may try
+	 * updating the same page twice.
+	 */
+	for (i = 0; i < npages; i++) {
+		if (snp_lookup_rmpentry(page_to_pfn(inpages[i]), &level) != 0) {
+			sev_unpin_memory(kvm, inpages, npages);
+			return -EFAULT;
+		}
+	}
+
+	gfn = params.start_gfn;
+	level = PG_LEVEL_4K;
+	data.gctx_paddr = __psp_pa(sev->snp_context);
+
+	for (i = 0; i < npages; i++) {
+		pfn = page_to_pfn(inpages[i]);
+
+		ret = rmp_make_private(pfn, gfn << PAGE_SHIFT, level, sev_get_asid(kvm), true);
+		if (ret) {
+			ret = -EFAULT;
+			goto e_unpin;
+		}
+
+		n++;
+		data.address = __sme_page_pa(inpages[i]);
+		data.page_size = X86_TO_RMP_PG_LEVEL(level);
+		data.page_type = params.page_type;
+		data.vmpl3_perms = params.vmpl3_perms;
+		data.vmpl2_perms = params.vmpl2_perms;
+		data.vmpl1_perms = params.vmpl1_perms;
+		ret = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE, &data, error);
+		if (ret) {
+			/*
+			 * If the command failed then need to reclaim the page.
+			 */
+			snp_page_reclaim(pfn);
+			goto e_unpin;
+		}
+
+		gfn++;
+	}
+
+e_unpin:
+	/* Content of memory is updated, mark pages dirty */
+	for (i = 0; i < n; i++) {
+		set_page_dirty_lock(inpages[i]);
+		mark_page_accessed(inpages[i]);
+
+		/*
+		 * If its an error, then update RMP entry to change page ownership
+		 * to the hypervisor.
+		 */
+		if (ret)
+			host_rmp_make_shared(pfn, level, true);
+	}
+
+	/* Unlock the user pages */
+	sev_unpin_memory(kvm, inpages, npages);
+
+	return ret;
+}
+
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -1712,6 +1873,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_SNP_LAUNCH_START:
 		r = snp_launch_start(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_LAUNCH_UPDATE:
+		r = snp_launch_update(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
@@ -1794,6 +1958,29 @@ find_enc_region(struct kvm *kvm, struct kvm_enc_region *range)
 static void __unregister_enc_region_locked(struct kvm *kvm,
 					   struct enc_region *region)
 {
+	unsigned long i, pfn;
+	int level;
+
+	/*
+	 * The guest memory pages are assigned in the RMP table. Unassign it
+	 * before releasing the memory.
+	 */
+	if (sev_snp_guest(kvm)) {
+		for (i = 0; i < region->npages; i++) {
+			pfn = page_to_pfn(region->pages[i]);
+
+			if (!snp_lookup_rmpentry(pfn, &level))
+				continue;
+
+			cond_resched();
+
+			if (level > PG_LEVEL_4K)
+				pfn &= ~(KVM_PAGES_PER_HPAGE(PG_LEVEL_2M) - 1);
+
+			host_rmp_make_shared(pfn, level, true);
+		}
+	}
+
 	sev_unpin_memory(kvm, region->pages, region->npages);
 	list_del(&region->list);
 	kfree(region);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index e6416e58cd9a..0681be4bdfdf 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1715,6 +1715,7 @@ enum sev_cmd_id {
 	/* SNP specific commands */
 	KVM_SEV_SNP_INIT,
 	KVM_SEV_SNP_LAUNCH_START,
+	KVM_SEV_SNP_LAUNCH_UPDATE,
 
 	KVM_SEV_NR_MAX,
 };
@@ -1831,6 +1832,24 @@ struct kvm_sev_snp_launch_start {
 	__u8 pad[6];
 };
 
+#define KVM_SEV_SNP_PAGE_TYPE_NORMAL		0x1
+#define KVM_SEV_SNP_PAGE_TYPE_VMSA		0x2
+#define KVM_SEV_SNP_PAGE_TYPE_ZERO		0x3
+#define KVM_SEV_SNP_PAGE_TYPE_UNMEASURED	0x4
+#define KVM_SEV_SNP_PAGE_TYPE_SECRETS		0x5
+#define KVM_SEV_SNP_PAGE_TYPE_CPUID		0x6
+
+struct kvm_sev_snp_launch_update {
+	__u64 start_gfn;
+	__u64 uaddr;
+	__u32 len;
+	__u8 imi_page;
+	__u8 page_type;
+	__u8 vmpl3_perms;
+	__u8 vmpl2_perms;
+	__u8 vmpl1_perms;
+};
+
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
 #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
-- 
2.17.1

