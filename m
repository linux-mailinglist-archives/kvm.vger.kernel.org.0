Return-Path: <kvm+bounces-72421-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gDr5I4gHpmkzJAAAu9opvQ
	(envelope-from <kvm+bounces-72421-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 22:56:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CE1F1E455B
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 22:56:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 237823081B6B
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 21:47:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 099FC388FF7;
	Mon,  2 Mar 2026 21:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FJ8Ge3e0"
X-Original-To: kvm@vger.kernel.org
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010062.outbound.protection.outlook.com [52.101.85.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B676C388FE3;
	Mon,  2 Mar 2026 21:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772487428; cv=fail; b=b/SCOHLYtKRCM6KfQnBFNgPi6UxsNjWJ3Invuiz4qjr6n+oR3JQjprdif33dB8eZ2WUxHRs/WvqTBFZzeu30nFm25cJSroiXgHBCMqArdUPK1jM4LY0s+/S3M3Pw9FZ4PqOVVBbOuvRSXjeEaecx+4fsJJd0DSAEYYiAR5aY5MA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772487428; c=relaxed/simple;
	bh=x1VCQ5cjZ5/hQSs7n7cUALz0BaWXySyLQlkH1xDQXFU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oYwE3Cpqq0sjsu1OyX0+iy3j7W9D01xUzO2w8ZqJ1yR1tZ4yE2X/a75LZbvmyao7ouPJkuPZiqQvfOFZ7syoORBUMyyurbaWEhJ3uONvE/lezWhf2cEs75UANvNmKclUSlTIe24u+RQTRfrcFPIVJCQEnJigTK4N94fSsyFd7nY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FJ8Ge3e0; arc=fail smtp.client-ip=52.101.85.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZJ+EI6dlmZqroJ1/sCpO3IU42yvqFizuH/TXJsrabD6uc6j8HN9OXEKJVI9t6fEUynfJ9pVvzbMXk5Tyv/xprp/djw3ZSi7eyNyrpTwnVzWcMwcZzxD6eGQyokIpzoysB8wlISAyFAcOscOLSqA7qVQHplgGMA2QEEuluxOjKcjv6W7+1wIzJWTAzNu9PQsaoIqI/8pRJm9stAYjUyZSs/65bXwahOy/Q4kfU2/VlgX0JZspR0Uaf73w/DpMSixXgbCfCd7r8DAkXOavqAeSGtMbHzeDSTVHjFxB2FCbYukJvOu36iBYbRW307EcvYL6dRtyENqMFbumKLtSkP3Djw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kNK9Qf6KXoQOXkdSH2R6RYiWFeG5DzOE8es7YaLInUo=;
 b=BneE3ApIcWon23gsTMT/rplfNdxo1q99hXjr6No5zDjZGPWtUXAPYhQMYk4LqdAtdcl6+LabZMkiwUj56A2WGEdUm4izK7+7Ab8hXj25T5jBA3keS+sFIMbiQhZI12J4YwGb/hU2QONjkIv43rUplKcqsnALF+MBtRmTAOoOPtMvD9NmzvgGRWAK6OeENRHe6vnn7cxZTnm/urhEz7UzqZKjLCweN5ubVP6R34v5gW5LRO7TNOliIH0oTjuslOXqTD9CFDL+c+HTcw25L+uJsEko5kOXa/xDM59OOfJKUdNi+0axwdsSx72yMP3UDPDw+GFk2gVheXeXWcuZe9yI+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kNK9Qf6KXoQOXkdSH2R6RYiWFeG5DzOE8es7YaLInUo=;
 b=FJ8Ge3e0eZdexybV/pqnRl1MpbAkpa1kfVH0snlr+arJY3F0EnO3FZ0sT5Ah9EXK3gG+rw/5BuDL5+fP6b3MwZwTTvBNZvHKqh2l9KMcx0rbVbXNFEQTwhyt0m8nJdjpJKBIsHPv5IDJbpEFIP93/Cc9mtWsA6xJftHywUNgb2U=
Received: from CH0PR07CA0021.namprd07.prod.outlook.com (2603:10b6:610:32::26)
 by SA1PR12MB7271.namprd12.prod.outlook.com (2603:10b6:806:2b8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.16; Mon, 2 Mar
 2026 21:37:00 +0000
Received: from DS2PEPF000061C5.namprd02.prod.outlook.com
 (2603:10b6:610:32:cafe::9b) by CH0PR07CA0021.outlook.office365.com
 (2603:10b6:610:32::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.21 via Frontend Transport; Mon,
 2 Mar 2026 21:36:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS2PEPF000061C5.mail.protection.outlook.com (10.167.23.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.16 via Frontend Transport; Mon, 2 Mar 2026 21:37:00 +0000
Received: from nigeria-2635-os.aus-spse (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 2 Mar
 2026 15:36:58 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <peterz@infradead.org>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <ardb@kernel.org>
CC: <pbonzini@redhat.com>, <aik@amd.com>, <Michael.Roth@amd.com>,
	<KPrateek.Nayak@amd.com>, <Tycho.Andersen@amd.com>,
	<Nathan.Fontenot@amd.com>, <jackyli@google.com>, <pgonda@google.com>,
	<rientjes@google.com>, <jacobhxu@google.com>, <xin@zytor.com>,
	<pawan.kumar.gupta@linux.intel.com>, <babu.moger@amd.com>,
	<dyoung@redhat.com>, <nikunj@amd.com>, <john.allen@amd.com>,
	<darwi@linutronix.de>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH v2 5/7] KVM: guest_memfd: Add cleanup interface for guest teardown
Date: Mon, 2 Mar 2026 21:36:48 +0000
Message-ID: <ce99dc548000b5a1f4486cdd3efe510b3874684b.1772486459.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1772486459.git.ashish.kalra@amd.com>
References: <cover.1772486459.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF000061C5:EE_|SA1PR12MB7271:EE_
X-MS-Office365-Filtering-Correlation-Id: e3bf3140-a7b1-4f0c-5d0e-08de78a3d628
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|36860700013|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	EqduD0CwiJlCObKkDc+vZNyOS7CuQzr99iWv2v9UcqOwFaq9/660ahl+JvCMcfGD8O8Ab4rXTjLvCy5qVFocpFDOcPhfIR/qDgZx1TLeMOWvSWQipXcffDXfjl1yrtst63vHa4vekoNQCk3pjo7rVQ2uZRHYKc/Har5sHoiy/LqFETlbJeV3CMD8w6Uz/FbOWqRPlLIgmWIFK4Nh5zpNJoVW2LBglRhq+LcWGuNxaKLox9mAO77CfQe1l/xRzch/DGilGAbajt/EkxB37nYCwoKkQmnOl2Of1RCBo5kyvPuNc5WP9K+4sMVpFd4YYl/sbkDTTRf9fjAaVw8CPXGKEuPpe2q7vDg/eWDsCCXKsRlpkvBQUvqB6svDnffhctqDtmLUgGG1dG1Zu4iwvWeiMqVAKsXVtJamA2U6Q+PiyjnukVaPdNr0gOEOwy2gd33VR4aGLYnji1q23YiL0KSPgiEogIDhjUC2ItzjrMdgWO5hefANM9AGCXG+0jieMIPWHqpWHTNYBdlx947qJKnvcrgmkUuyw1iROh0Tn+TXQ0p26QdZZgOtiBvi+XwznaoMLi3gUfqqlAIqC00vDYsx+Pq75BZMHiyB1A2T9wCR9SireqPV+Zw+1C8hEez+ddWFSJ5w5SgSj4r0kPctUk/BY7ymnNJ4bINAEQg+bwfQT0JGD9f878p/Kc6/njUnXQ0mz5RBYFcS+5Pwo4orercaNFlVgjOz22UB+iGBhUaPm/Ui/cO/u35XhXuArp/JQnl6mMZ4XxhCcAZdjY0J/M37fVuqSMuEMJ6mHhRwcg/PJai7FtHBf6KInfRx/ybBshrccPpY/h5ck7lcK1rwJ6LdGxf/qiL5iiSIczrnKIGwicw=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(36860700013)(82310400026)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	IlK+pcyQXHL/3A3A4oyk2aaiiS6TqbDXb2Z6F3YhG1abXU391BWQksQD0jXSlGJ1AvKsEDawcHI10GCnHDfkRotEsPpb17OT6Fb94Z998SLEUJoJiZbkvACoKiZV/Nczyv0NQX8uQMKkTsYw4zpMaMg/8NGqqhkyFUg8luO52m6HNhheZSaVAW7zVasPe4n0GDwoWafj2EebVeqWnb5blLpVXDqRo53rhO9JUjd60GdyD2qLB2cSStgCvyFUsrdqvA+uwYLQPN2opeAhGRNOG8nHQQNotXUFey4CQyKXZQ8Ac5JOQawUPYaEPj9Yg+LvoPMyY9QnOSjWQ5iKXv6QF1r+515NMaTsSShBEHRb3iuQJH/Ig/HJWZDmSRTCuzd1Le0e2sF9+pqJv6IM68I0Kze8DGH1/Nm38Yp4jQ8ZbCUP5GE/VVEMdHv6WnLKYlzl
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 21:37:00.0381
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e3bf3140-a7b1-4f0c-5d0e-08de78a3d628
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF000061C5.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7271
X-Rspamd-Queue-Id: 3CE1F1E455B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72421-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[33];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Ashish.Kalra@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:dkim,amd.com:email,amd.com:mid,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Action: no action

From: Ashish Kalra <ashish.kalra@amd.com>

Introduce kvm_arch_gmem_cleanup() to perform architecture-specific
cleanups when the last file descriptor for the guest_memfd inode is
closed. This typically occurs during guest shutdown and termination
and allows for final resource release.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 1 +
 arch/x86/include/asm/kvm_host.h    | 1 +
 arch/x86/kvm/x86.c                 | 7 +++++++
 include/linux/kvm_host.h           | 4 ++++
 virt/kvm/Kconfig                   | 4 ++++
 virt/kvm/guest_memfd.c             | 8 ++++++++
 6 files changed, 25 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index de709fb5bd76..ebbecd0c9e4f 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -148,6 +148,7 @@ KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
 KVM_X86_OP_OPTIONAL_RET0(gmem_prepare)
 KVM_X86_OP_OPTIONAL_RET0(gmem_max_mapping_level)
 KVM_X86_OP_OPTIONAL(gmem_invalidate)
+KVM_X86_OP_OPTIONAL(gmem_cleanup)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ff07c45e3c73..7894cf791fef 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1962,6 +1962,7 @@ struct kvm_x86_ops {
 	int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 	void (*gmem_invalidate)(kvm_pfn_t start, kvm_pfn_t end);
 	int (*gmem_max_mapping_level)(struct kvm *kvm, kvm_pfn_t pfn, bool is_private);
+	void (*gmem_cleanup)(void);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3fb64905d190..d992848942c3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -14080,6 +14080,13 @@ void kvm_arch_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
 	kvm_x86_call(gmem_invalidate)(start, end);
 }
 #endif
+
+#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CLEANUP
+void kvm_arch_gmem_cleanup(void)
+{
+	kvm_x86_call(gmem_cleanup)();
+}
+#endif
 #endif
 
 int kvm_spec_ctrl_test_value(u64 value)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index dde605cb894e..b14143c427eb 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2607,6 +2607,10 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, long npages
 void kvm_arch_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
 #endif
 
+#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CLEANUP
+void kvm_arch_gmem_cleanup(void);
+#endif
+
 #ifdef CONFIG_KVM_GENERIC_PRE_FAULT_MEMORY
 long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 				    struct kvm_pre_fault_memory *range);
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 267c7369c765..9072ec12d5e7 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -125,3 +125,7 @@ config HAVE_KVM_ARCH_GMEM_INVALIDATE
 config HAVE_KVM_ARCH_GMEM_POPULATE
        bool
        depends on KVM_GUEST_MEMFD
+
+config HAVE_KVM_ARCH_GMEM_CLEANUP
+       bool
+       depends on KVM_GUEST_MEMFD
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 017d84a7adf3..2724dd1099f2 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -955,6 +955,14 @@ static void kvm_gmem_destroy_inode(struct inode *inode)
 
 static void kvm_gmem_free_inode(struct inode *inode)
 {
+#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CLEANUP
+	/*
+	 * Finalize cleanup for the inode once the last guest_memfd
+	 * reference is released. This usually occurs after guest
+	 * termination.
+	 */
+	kvm_arch_gmem_cleanup();
+#endif
 	kmem_cache_free(kvm_gmem_inode_cachep, GMEM_I(inode));
 }
 
-- 
2.43.0


