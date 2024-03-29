Return-Path: <kvm+bounces-13111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A8DE892619
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 22:31:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CBFC61F23A5C
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 21:31:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B42F713BC02;
	Fri, 29 Mar 2024 21:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="f1jbCNR+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2077.outbound.protection.outlook.com [40.107.244.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1AC1369BC
	for <kvm@vger.kernel.org>; Fri, 29 Mar 2024 21:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711747865; cv=fail; b=kXtvAK/ArmxuRAOG6B9TmP9Z6WpB/7vXbm0VQHO5+RxJSnkVOTkcxG5RQs9LGbzvwrjGxqdwc/IBIs0WuFbTRGf7JocI3PONBTK6ER0ZJxT4aD3WGaxQtorlFNvU8pD3Q+QA29pClV2BLWq68fEkPF0m/iCdATVu6Eutdhv/mZk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711747865; c=relaxed/simple;
	bh=lNtCR0A1c6b5FZaYMd40gScah5uy1hgosrD7l+hIo0w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QTARjv6C+KbwcHNtblzNvvhs/lp0Z020LNX+putszDwVxIHeh1T+yNbyr5KTliqx5AK5XCwEnxlP7VyWULVSbalf8cotggsYWEeUeyucq3otrCY/VOcEBldiXL4nXX1hQ/87dZSAl6CwPTrrlPvUxj6t+Llx12X26gJafWVomqo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=f1jbCNR+; arc=fail smtp.client-ip=40.107.244.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RqUaU/h8ZP5PBw9z0lxOh+Zw/4m9pVFhy/Y5qv2mzLt6192RVUDvGeZaDPjYcwvCfmpboT5Dnr7LTHZ1jYHWTczCkMHIywrPxhTcOmzmvaa9lq7xiybui62Dumt+GL2anngWDj/Q42QmWe01/z6iSFF1Pk5C4uJb6uMWZI3Xv3N2Fo0Qw1s8H3rZCqbSBKDXETZnCQgXaq9TuGWDgVkrB5YNK4UPBigpalathiDzSpER6/qSvBEZMNbxa7Qgf8QZw4DS6Z5XXa0NcMzKVWf5Wn57d5mNBs6WO7Lux2VL8Vg3ok/K4bC952HRQQSObWoVlEAjtkKclQQut+3o14ch1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hFtBDS2no1Ul0Q4qQCB1DyAo8Aqu1dKOcg07pwJhEVM=;
 b=hjSPiattuXzlYaXHt9Xq56ft8sjLFX6I4V6UD3KBrUe5rFFacwjj5IlpmD13mzHnbaTil9bWb5WbCb9GmH2ZQx5fzJhACztw7d4MR/dUVadR9PZTLrJkPM7eV9pbvslCCKXznedNVD0MdZF5piGpZgmnApBZw32WFlwFBbJosFC6eq5pcxczf53sRrmGFGhEP3pZ5YACtyw+BYXcHN0LMr/lx8jiXu1DwnuEvh4/Geh8ZcC5r4rpWUlGY0xfyKuKol0/Bb60xNj3YMOB+GBmvX3kvfIRYMMI0gsMmDUJ+/W7htDaBzdiR+9lLBsIxiMcP+ds5essGq2F/G0sKLn7tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hFtBDS2no1Ul0Q4qQCB1DyAo8Aqu1dKOcg07pwJhEVM=;
 b=f1jbCNR+EJ0MSfQ1UDy3v2RHCVUbl9ATQEPs3k9dBXXhqzHbbo/BMR+neA4cSvowVvf/ui3l+/w2Qplb75FS4nu82IEO7xUCjzslz2uI3e8NUrN05v23sJMiFVeyLvpiWKpyusQydRZA9Urw9q/a9CFpaDpvRagYpyhFaw5DgPk=
Received: from SJ0PR05CA0180.namprd05.prod.outlook.com (2603:10b6:a03:339::35)
 by PH7PR12MB7212.namprd12.prod.outlook.com (2603:10b6:510:207::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40; Fri, 29 Mar
 2024 21:30:59 +0000
Received: from SJ5PEPF000001CA.namprd05.prod.outlook.com
 (2603:10b6:a03:339:cafe::37) by SJ0PR05CA0180.outlook.office365.com
 (2603:10b6:a03:339::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.41 via Frontend
 Transport; Fri, 29 Mar 2024 21:30:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001CA.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 21:30:59 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 Mar
 2024 16:30:56 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, Sean
 Christopherson <seanjc@google.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>, Xu Yilun <yilun.xu@linux.intel.com>, Binbin
 Wu <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH gmem 6/6] KVM: guest_memfd: Add interface for populating gmem pages with user data
Date: Fri, 29 Mar 2024 16:24:44 -0500
Message-ID: <20240329212444.395559-7-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240329212444.395559-1-michael.roth@amd.com>
References: <20240329212444.395559-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CA:EE_|PH7PR12MB7212:EE_
X-MS-Office365-Filtering-Correlation-Id: d078135d-9400-4a37-0907-08dc503786af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	a/6IEK7LA25fwn30gqlHpbIvyUmYKkiv9J1GdoqDoiQXKkHiQQsZRLKgCmjjACgb0oZz+57k6Ad0Z+1ipT43fhGP+hDBsZGfhZLC4YAlLwYtHLX3xzqeDcj/YFJqikvBSPhB1jDs/G+SE5UMroyMGqwRJ48IaEbQ3z1ftRUu2vql0mg423htKJWCx1kXYJlx3AGw/JEGUow1xTWcu2/xtc+ZadajqHaMNfqDJDSeSQ79PouC3uy7qrR9aTjgRttTK0CHs5OauDgxFfUpA3qRU71e1qRpalMpxS9ewrsguGomi64Xzxo1ieKv75DLvYFmwxGR2iIqis9Ugt6q86RG92o1vJLIC9gloS9Adm5KBzIoA2ENKBTtMVf1/m+t5fbXvO9xF/iRojfn5qIOP/XJdUq0jWBvhuzl6dGkWf6N0tcqBs1XLoSQO70hO9QG+27QqiTGIqvdK9YDhW40Q1q/A65uv6ERjFtuqghYEl/l4fKoTPJ0US9ntqejkffrx4oZS3/mAi1HyH70nQ1eISbRQr2QdF+Tnr4fJADN6fo8IU5R3d+bDTAX/kGuZzIJZ7Zt4bl8Vm2LXfEg/TyQ7XIURHNFcHFHBXNvUm/SuaNWnezx6KCNKH/Ga9EQH9Kp114t4MAj/GjJadENNsDhJLw/AoJD41FFVuK/j9NgpPYfQ36dlax5E+VHu/wnjt7PJpcA2cW4LE6VC0E5JtItoxZAbDSEg0IGpu4ORC9Jhv9aqDqQox84pVziZkgaLhAykdjA
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(36860700004)(82310400014)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 21:30:59.1559
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d078135d-9400-4a37-0907-08dc503786af
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7212

During guest run-time, kvm_arch_gmem_prepare() is issued as needed to
prepare newly-allocated gmem pages prior to mapping them into the guest.
In the case of SEV-SNP, this mainly involves setting the pages to
private in the RMP table.

However, for the GPA ranges comprising the initial guest payload, which
are encrypted/measured prior to starting the guest, the gmem pages need
to be accessed prior to setting them to private in the RMP table so they
can be initialized with the userspace-provided data. Additionally, an
SNP firmware call is needed afterward to encrypt them in-place and
measure the contents into the guest's launch digest.

While it is possible to bypass the kvm_arch_gmem_prepare() hooks so that
this handling can be done in an open-coded/vendor-specific manner, this
may expose more gmem-internal state/dependencies to external callers
than necessary. Try to avoid this by implementing an interface that
tries to handle as much of the common functionality inside gmem as
possible, while also making it generic enough to potentially be
usable/extensible for use-cases beyond just SEV-SNP.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 include/linux/kvm_host.h | 40 ++++++++++++++++++++++++++++++++++++++++
 virt/kvm/guest_memfd.c   | 40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 5b8308b5e4af..8a75787090f3 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2473,4 +2473,44 @@ bool kvm_arch_gmem_prepare_needed(struct kvm *kvm);
 void kvm_arch_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
 #endif
 
+/**
+ * kvm_gmem_populate_args - kvm_gmem_populate() argument structure
+ *
+ * @gfn: starting GFN to be populated
+ * @src: userspace-provided buffer containing data to copy into GFN range
+ * @npages: number of pages to copy from userspace-buffer
+ * @do_memcpy: whether to do a direct memcpy of the data prior to issuing
+ *             the post-populate callback
+ * @post_populate: callback to issue for each gmem page that backs the GPA
+ *                 range (which will be filled with corresponding contents from
+ *                 @src if @do_memcpy was set)
+ * @opaque: opaque data to pass to @post_populate callback
+ */
+struct kvm_gmem_populate_args {
+	gfn_t gfn;
+	void __user *src;
+	int npages;
+	bool do_memcpy;
+	int (*post_populate)(struct kvm *kvm, struct kvm_memory_slot *slot,
+			     gfn_t gfn, kvm_pfn_t pfn, void __user *src, int order,
+			     void *opaque);
+	void *opaque;
+};
+
+/**
+ * kvm_gmem_populate() - Populate/prepare a GPA range with guest data
+ *
+ * @kvm: KVM instance
+ * @slot: slot containing the GPA range being prepared
+ * @args: argument structure
+ *
+ * This is primarily intended for cases where a gmem-backed GPA range needs
+ * to be initialized with userspace-provided data prior to being mapped into
+ * the guest as a private page. This should be called with the slots->lock
+ * held so that caller-enforced invariants regarding the expected memory
+ * attributes of the GPA range do not race with KVM_SET_MEMORY_ATTRIBUTES.
+ */
+int kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
+		      struct kvm_gmem_populate_args *args);
+
 #endif
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 3668a5f1d82b..3e3c4b7fff3b 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -643,3 +643,43 @@ int kvm_gmem_undo_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	return r;
 }
 EXPORT_SYMBOL_GPL(kvm_gmem_undo_get_pfn);
+
+int kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
+		      struct kvm_gmem_populate_args *args)
+{
+	int ret, max_order, i;
+
+	for (i = 0; i < args->npages; i += (1 << max_order)) {
+		void __user *src = args->src + i * PAGE_SIZE;
+		gfn_t gfn = args->gfn + i;
+		kvm_pfn_t pfn;
+
+		ret = __kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, &max_order, false);
+		if (ret)
+			break;
+
+		if (!IS_ALIGNED(gfn, (1 << max_order)) ||
+		    (args->npages - i) < (1 << max_order))
+			max_order = 0;
+
+		if (args->do_memcpy && args->src) {
+			ret = copy_from_user(pfn_to_kaddr(pfn), src, (1 << max_order) * PAGE_SIZE);
+			if (ret)
+				goto e_release;
+		}
+
+		if (args->post_populate) {
+			ret = args->post_populate(kvm, slot, gfn, pfn, src, max_order,
+						  args->opaque);
+			if (ret)
+				goto e_release;
+		}
+e_release:
+		put_page(pfn_to_page(pfn));
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kvm_gmem_populate);
-- 
2.25.1


