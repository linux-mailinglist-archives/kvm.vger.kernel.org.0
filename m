Return-Path: <kvm+bounces-10867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 37CBE87155B
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 06:46:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A27ECB22D11
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 05:46:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCBB562171;
	Tue,  5 Mar 2024 05:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="C7epLVqy"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2094.outbound.protection.outlook.com [40.107.244.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A33AD5E;
	Tue,  5 Mar 2024 05:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.94
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709617592; cv=fail; b=TGg6HSpNVRH/AqXaq38ijluWrN0TRWx2SShVFt+b3uF+dESYSl1vhw/BwoVGtmjNUj/vrxRW/lAEaOoS/N+0Id3YKBLk6anjLuUaFIkvjUR0oJYS9owdhRlrPHuHyoM5jRkd1pfcYXfyFxJUEvAQ0WQf3PJXUYvOXUiEgbGuGAc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709617592; c=relaxed/simple;
	bh=fvm6PWk/jOIBj5IDMUR8ZIzsuPphjE/h2GOFx3WBTZ8=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=FOaD3rPBQHKBP8vWRQPNZ7yd0pQoec7AFTAHOfIkcZUJPB+l4OBX7K8f8BM7O2D+lGuUHMf9ZvwFlOKtPWeYRWQCD5tilGXtNjo3pdV3XTBsNBUazgC4RLkBgKH6jILzcW3go+24/tIjSvkQ7WmXrNdELTCuzMuT2izSHmAQLsI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=C7epLVqy; arc=fail smtp.client-ip=40.107.244.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ElOj8rSi/W6oiqvEwV03zd5hwC4socswoqsQpcS+urjHyLmWUNk91a881JX6XsG1SZRl8w3T8Rr7+U47RSNecByXnKeEQTW58tm1su9NDaF0jmwunTanMBw95eHyWiR3zo78JaC6GdYi8r/Aoe+6OgBYmOVwrHOG5rdlqVqVFGZfLxZPmPIFjlcvY412KALe+auTzDHP7mPrEGf8jCvBXOqj4I+gfGO4UqoKYMDjIRhOpTwQOX83qcL6O58uNH5Lt+075GEBFZGkpaYQF7UtOFPmEx28rCedTmWwq4GS5n/xla/aqBKbrFgetRpLCs81oSjwLFK8V0yay2TJdGldrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o76U4oQZ7U4En32PT+pRE3QIJWdoaQeX0VSWW6gNAbo=;
 b=RcUPfGVG3IYhjwYwIdCQ35GemHysLNvAtUhMHS+oorRXRu4VgGqUc/ZkEUAXc4k+9yshZKaAFYxR8e31ql1gcInAKMKfq0IuBFlqrs9O2UQNWJmbXx7bICc9X45HP721mJvaypulB8Rqnb5t6qVT4xnhW5zO+4FwCfUw2rf98oIoBOy84yhr7Lo8W6f/yRSV2M1MnSQywn/jhvKmtordSR6tgqR6EF8pXpWS8KPSDeYP7+IQhjX7n1qqQ0I6TdYQPGom+hrvpf9kJTtNyk9LJcz1CPIxkLOliTlJobb3h6VASKSsPw+hr9GU7Ytx6NpWD2wxzcSC35GXp0ayzn7nUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o76U4oQZ7U4En32PT+pRE3QIJWdoaQeX0VSWW6gNAbo=;
 b=C7epLVqy3Usb//L1wVeIjWn2hvDWW4bQjz7PYR8Q2c7gzfw3ylaJH3TiODh9Ph0mymQ8E04wBLozAjgU+3Rc5w67VmvE/wL5W/Uyp3Fbx1cM00rfj9UIQWUsYpm61/OqqBK4G97M31SsiQBh3BiZz36NvW/tid6kWpGeAs/gRUg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 PH7PR01MB8124.prod.exchangelabs.com (2603:10b6:510:2a5::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7339.39; Tue, 5 Mar 2024 05:46:25 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::d3dd:ece:637f:bde9]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::d3dd:ece:637f:bde9%3]) with mapi id 15.20.7339.035; Tue, 5 Mar 2024
 05:46:25 +0000
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
To: kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	darren@os.amperecomputing.com,
	d.scott.phillips@amperecomputing.com,
	gankulkarni@os.amperecomputing.com
Subject: [RFC PATCH] kvm: nv: Optimize the unmapping of shadow S2-MMU tables.
Date: Mon,  4 Mar 2024 21:46:06 -0800
Message-Id: <20240305054606.13261-1-gankulkarni@os.amperecomputing.com>
X-Mailer: git-send-email 2.40.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P221CA0006.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:11c::29) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|PH7PR01MB8124:EE_
X-MS-Office365-Filtering-Correlation-Id: 77c29341-7365-43ea-ccc9-08dc3cd7984a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Bkniur6+xFBJyIsx1Z5Y3arAmeGSZzgMgLQqk2CbU+cDbX0kN4LgwIehVnDssrMb/RehmgkvToS2G4K2sb7PVjB0E7PzSI/XU9mla0wl5AqT8ADd96utThuYtLoS0T0iUMb3zOLIa1rNQL3VkP+07BPSsAJGp4opu5iJ3Bwn19VhTnf19bJrRdBPf92Gzxgp7Tz0rW0KE5FngDux5lW9f1vZGbp06YhbnHlvnF2e4oTpUBRxb9FrCpuQddknZcNfoAy7iuSltYfBuGprZzJOc8hFhY9kdvMbNhCWCcBxiQJEIqFBTKP/Wol9w5wHucK+aG2dZ4iuSVyR35dGUha5Cb6TpDwTWWp/ZaEIpdh2dbPLSviGqbr46tGltUD7sQxbU2u2IpM0cTISMvLG/BGorkMfSlqxu6HUgIm4Y0WX7aX6w1MvUHnYC4Zh22rOCiuJMpau80JqaPFZ8eqFveZkTIfEdbWsejZpNIDhmVfz9+wLre7na+oCQc37SFczfgLhpSzDhtfnSBWcN+HhOhfhwM2XLvWc2wcUNh75QxFepe1UWFW2WSaiv0HmeP3MVOyZIJj9sznZ9RwYEJ4BqvW2fXHmEw8J91NSAl/NAi0vqW2shiwG1TG1fEkmj8s27xBCGIoU0LS71x1yjT/7c/w/Ng8nD0+rC0PCN5LRch1vMBcGDnJTdZ4UWfRDrdi2LQcdHC1NpoSlO+f+zhsmt6XHhjqIXR2xma6Q256Cq4mVmIk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(38350700005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nkj7zNr/mQ06jgXS8xz+LOo586YUtpo3fd+fkiF1Hl1TTrmbSPtfSaOWU1ZL?=
 =?us-ascii?Q?gVSEBYiZwxfR7b+e/4jBwGAUS5Tkvnu/o14II6uJPKSOPjx75M7Y/acUIGJ2?=
 =?us-ascii?Q?oO7+FFV9oGmd4BHquG2BgKz+BwjFRaHOUmBm0Z50iAmNc+9ZmdtTmx3zf85I?=
 =?us-ascii?Q?CWIH8wCw9Dp5CasgxAdMuQItIBIOifb2wvR1jnB5B/NOCQgB2byjyMoEg68P?=
 =?us-ascii?Q?8dzt4b1XXZEGcqC6QxUQD0J37MiP2/JJo5QFXn+iW5X/IiN0ubJlbJt4I/k6?=
 =?us-ascii?Q?E7tCmK77tUgWm6BH8sm3KXvH/E2SqIni8SLq4NRyPgrOJAbDEI2Vh/KKuS1M?=
 =?us-ascii?Q?h2Wdl8mMUvvivXe6g9rWoztOwssMegy6mP4pDja6gbU34GCbeHe/ooKvrGr4?=
 =?us-ascii?Q?jg6silW0a6F81fzAZI/xRc7Ut81NRFdJsiRKrd3U2Vg+G8rKi6b3dphK9RbR?=
 =?us-ascii?Q?NHLtVyK9I9XDllblFZibrM9Dj9Ep2Y0R0fmTmuzDVgj2hIDFR7nKdCLgOQLo?=
 =?us-ascii?Q?A9nTbmSERabVciZJK1enXIPPojGv9Bnpzhezz6h54UD1NaJl5NXimOf0kTJC?=
 =?us-ascii?Q?Y0n3fwwlUETVXwyLb3EC/JDzsk4Ct4ooTrenzOdQJto4lUr3QoH8VHKpynZ/?=
 =?us-ascii?Q?zu5gkfMyQdLF49fxTN65L/P7mxI7HReoBE+7K23b8/OsZd34xUa3wIbU7PQq?=
 =?us-ascii?Q?BMjvOx2Bp3gImnEdrXO1U/OE3rQu5XkbU5tM9y7Q4Rwh72PLl2nJHBJLVU9a?=
 =?us-ascii?Q?gJQsawAboEFnWNGctsODYRKG6fbJzKAZ26DKhV/JBM5GyDVK9IzRAzKw10vc?=
 =?us-ascii?Q?k+sBCYG2rG2QZrYZHGoP8QMO+bO/t7wNdpj9u2ECvdsFx7YqqimEtuPlI3X8?=
 =?us-ascii?Q?4bizTwU22zDNISQbLBAGmVn473iv8Obt+v0RVJnPdxu1xOYH4f0sOPl97GGV?=
 =?us-ascii?Q?ICsfqTyvOYqhnbt0PdEdDgInGB8mw/ouZo3uAgHAImTMuSU6hY4UvuVfJ9zx?=
 =?us-ascii?Q?Cu8VMxQUGIvLsgxjyojEyysIO6FcKcsmk5as6rMNApdsxSOq1I5yLqKb61eu?=
 =?us-ascii?Q?5qkHYT5P8I5pUzHWjUCWRAj/S5DwtPs2VXofoinoKit3fP6ddKY5ObH1OjrT?=
 =?us-ascii?Q?KpXxnPfP7wwJcYK76ExaIMgb9yClL9wwSW7A5cRR1+CpLKH0m6aQQMRDbtG5?=
 =?us-ascii?Q?+EEYywvcFCZ+3fPS2TejGjQIn3T6CwbGoJanjfwHCQ1mbkj1DjFp6k6EG1WQ?=
 =?us-ascii?Q?OoAiWIBuze1bBHpXfU9CmXNq7PbUmkLyMdUXQmtwU/XywH8gW5W2Q8S7p57S?=
 =?us-ascii?Q?eHj8YGBEXmUpeBU7Eta8i6KKgaIrJXAnIClfJNYjMjxs7lVrxpCWiJMmlrdJ?=
 =?us-ascii?Q?ZYa7XkjdnoZfDQgZsUmm+Y8JVeyS5HaRTsI7Ko5BI95DBiZ8Bcmp244e7oSj?=
 =?us-ascii?Q?BTFUn8jIDzR+a1XlkyeJ74SRmZ1W23uYeMmgOeqJqoIRGR9LzmM77wNt9RXZ?=
 =?us-ascii?Q?6KkcFN0Sz7srBiKzhNsUIV/lpKKqWj30joc5WFD+kUsyqDNVghkDyJCw7mZA?=
 =?us-ascii?Q?O1rKaEe3Af+Yb5tzKWVCtB/VNTyoVQwXzwhya1mXgCt2hCFMUrX2HTcRFwQj?=
 =?us-ascii?Q?R6Y5chEtCWf7Mepy7Uojxeg=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77c29341-7365-43ea-ccc9-08dc3cd7984a
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2024 05:46:25.1835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YnNe6GnIBtV+1/orUXVE0Jnrx+CG7/fHSzqCqhK9x0E5+5+kBUow5DIG1iSfu35rUxtYYOit8aNXDRpy6lnuHNJbZi9KCAqe6WAPtBu46BAf3WGuj1SkUQKvBplpfd5P
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR01MB8124

As per 'commit 178a6915434c ("KVM: arm64: nv: Unmap/flush shadow stage 2
page tables")', when ever there is unmap of pages that
are mapped to L1, they are invalidated from both L1 S2-MMU and from
all the active shadow/L2 S2-MMU tables. Since there is no mapping
to invalidate the IPAs of Shadow S2 to a page, there is a complete
S2-MMU page table walk and invalidation is done covering complete
address space allocated to a L2. This has performance impacts and
even soft lockup for NV(L1 and L2) boots with higher number of
CPUs and large Memory.

Adding a lookup table of mapping of Shadow IPA to Canonical IPA
whenever a page is mapped to any of the L2. While any page is
unmaped, this lookup is helpful to unmap only if it is mapped in
any of the shadow S2-MMU tables. Hence avoids unnecessary long
iterations of S2-MMU table walk-through and invalidation for the
complete address space.

Signed-off-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
---
 arch/arm64/include/asm/kvm_emulate.h |   5 ++
 arch/arm64/include/asm/kvm_host.h    |  14 ++++
 arch/arm64/include/asm/kvm_nested.h  |   4 +
 arch/arm64/kvm/mmu.c                 |  19 ++++-
 arch/arm64/kvm/nested.c              | 113 +++++++++++++++++++++++++++
 5 files changed, 152 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 5173f8cf2904..f503b2eaedc4 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -656,4 +656,9 @@ static inline bool kvm_is_shadow_s2_fault(struct kvm_vcpu *vcpu)
 		vcpu->arch.hw_mmu->nested_stage2_enabled);
 }
 
+static inline bool kvm_is_l1_using_shadow_s2(struct kvm_vcpu *vcpu)
+{
+	return (vcpu->arch.hw_mmu != &vcpu->kvm->arch.mmu);
+}
+
 #endif /* __ARM64_KVM_EMULATE_H__ */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8da3c9a81ae3..f61c674c300a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -144,6 +144,13 @@ struct kvm_vmid {
 	atomic64_t id;
 };
 
+struct mapipa_node {
+	struct rb_node node;
+	phys_addr_t ipa;
+	phys_addr_t shadow_ipa;
+	long size;
+};
+
 struct kvm_s2_mmu {
 	struct kvm_vmid vmid;
 
@@ -216,6 +223,13 @@ struct kvm_s2_mmu {
 	 * >0: Somebody is actively using this.
 	 */
 	atomic_t refcnt;
+
+	/*
+	 * For a Canonical IPA to Shadow IPA mapping.
+	 */
+	struct rb_root nested_mapipa_root;
+	rwlock_t mmu_lock;
+
 };
 
 static inline bool kvm_s2_mmu_valid(struct kvm_s2_mmu *mmu)
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index da7ebd2f6e24..c31a59a1fdc6 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -65,6 +65,9 @@ extern void kvm_init_nested(struct kvm *kvm);
 extern int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu);
 extern void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu);
 extern struct kvm_s2_mmu *lookup_s2_mmu(struct kvm_vcpu *vcpu);
+extern void add_shadow_ipa_map_node(
+		struct kvm_s2_mmu *mmu,
+		phys_addr_t ipa, phys_addr_t shadow_ipa, long size);
 
 union tlbi_info;
 
@@ -123,6 +126,7 @@ extern int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu,
 extern int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2);
 extern void kvm_nested_s2_wp(struct kvm *kvm);
 extern void kvm_nested_s2_unmap(struct kvm *kvm);
+extern void kvm_nested_s2_unmap_range(struct kvm *kvm, struct kvm_gfn_range *range);
 extern void kvm_nested_s2_flush(struct kvm *kvm);
 int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe);
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 61bdd8798f83..3948681426a0 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1695,6 +1695,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 					     memcache,
 					     KVM_PGTABLE_WALK_HANDLE_FAULT |
 					     KVM_PGTABLE_WALK_SHARED);
+		if ((nested || kvm_is_l1_using_shadow_s2(vcpu)) && !ret) {
+			struct kvm_s2_mmu *shadow_s2_mmu;
+
+			ipa &= ~(vma_pagesize - 1);
+			shadow_s2_mmu = lookup_s2_mmu(vcpu);
+			add_shadow_ipa_map_node(shadow_s2_mmu, ipa, fault_ipa, vma_pagesize);
+		}
 	}
 
 	/* Mark the page dirty only if the fault is handled successfully */
@@ -1918,7 +1925,7 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 			     (range->end - range->start) << PAGE_SHIFT,
 			     range->may_block);
 
-	kvm_nested_s2_unmap(kvm);
+	kvm_nested_s2_unmap_range(kvm, range);
 	return false;
 }
 
@@ -1953,7 +1960,7 @@ bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 			       PAGE_SIZE, __pfn_to_phys(pfn),
 			       KVM_PGTABLE_PROT_R, NULL, 0);
 
-	kvm_nested_s2_unmap(kvm);
+	kvm_nested_s2_unmap_range(kvm, range);
 	return false;
 }
 
@@ -2223,12 +2230,18 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 				   struct kvm_memory_slot *slot)
 {
+	struct kvm_gfn_range range;
+
 	gpa_t gpa = slot->base_gfn << PAGE_SHIFT;
 	phys_addr_t size = slot->npages << PAGE_SHIFT;
 
+	range.start = gpa;
+	range.end = gpa + size;
+	range.may_block = true;
+
 	write_lock(&kvm->mmu_lock);
 	kvm_unmap_stage2_range(&kvm->arch.mmu, gpa, size);
-	kvm_nested_s2_unmap(kvm);
+	kvm_nested_s2_unmap_range(kvm, &range);
 	write_unlock(&kvm->mmu_lock);
 }
 
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index f88d9213c6b3..888ec9fba4a0 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -565,6 +565,88 @@ void kvm_s2_mmu_iterate_by_vmid(struct kvm *kvm, u16 vmid,
 	write_unlock(&kvm->mmu_lock);
 }
 
+/*
+ * Create a node and add to lookup table, when a page is mapped to
+ * Canonical IPA and also mapped to Shadow IPA.
+ */
+void add_shadow_ipa_map_node(struct kvm_s2_mmu *mmu,
+			phys_addr_t ipa,
+			phys_addr_t shadow_ipa, long size)
+{
+	struct rb_root *ipa_root = &(mmu->nested_mapipa_root);
+	struct rb_node **node = &(ipa_root->rb_node), *parent = NULL;
+	struct mapipa_node *new;
+
+	new = kzalloc(sizeof(struct mapipa_node), GFP_KERNEL);
+	if (!new)
+		return;
+
+	new->shadow_ipa = shadow_ipa;
+	new->ipa = ipa;
+	new->size = size;
+
+	write_lock(&mmu->mmu_lock);
+
+	while (*node) {
+		struct mapipa_node *tmp;
+
+		tmp = container_of(*node, struct mapipa_node, node);
+		parent = *node;
+		if (new->ipa < tmp->ipa) {
+			node = &(*node)->rb_left;
+		} else if (new->ipa > tmp->ipa) {
+			node = &(*node)->rb_right;
+		} else {
+			write_unlock(&mmu->mmu_lock);
+			kfree(new);
+			return;
+		}
+	}
+
+	rb_link_node(&new->node, parent, node);
+	rb_insert_color(&new->node, ipa_root);
+	write_unlock(&mmu->mmu_lock);
+}
+
+/*
+ * Iterate over the lookup table of Canonical IPA to Shadow IPA.
+ * Return Shadow IPA, if the page mapped to Canonical IPA is
+ * also mapped to a Shadow IPA.
+ *
+ */
+bool get_shadow_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa, phys_addr_t *shadow_ipa, long *size)
+{
+	struct rb_node *node;
+	struct mapipa_node *tmp = NULL;
+
+	read_lock(&mmu->mmu_lock);
+	node = mmu->nested_mapipa_root.rb_node;
+
+	while (node) {
+		tmp = container_of(node, struct mapipa_node, node);
+
+		if (tmp->ipa == ipa)
+			break;
+		else if (ipa > tmp->ipa)
+			node = node->rb_right;
+		else
+			node = node->rb_left;
+	}
+
+	read_unlock(&mmu->mmu_lock);
+
+	if (tmp && tmp->ipa == ipa) {
+		*shadow_ipa = tmp->shadow_ipa;
+		*size = tmp->size;
+		write_lock(&mmu->mmu_lock);
+		rb_erase(&tmp->node, &mmu->nested_mapipa_root);
+		write_unlock(&mmu->mmu_lock);
+		kfree(tmp);
+		return true;
+	}
+	return false;
+}
+
 /* Must be called with kvm->mmu_lock held */
 struct kvm_s2_mmu *lookup_s2_mmu(struct kvm_vcpu *vcpu)
 {
@@ -674,6 +756,7 @@ void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu)
 	mmu->tlb_vttbr = 1;
 	mmu->nested_stage2_enabled = false;
 	atomic_set(&mmu->refcnt, 0);
+	mmu->nested_mapipa_root = RB_ROOT;
 }
 
 void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu)
@@ -760,6 +843,36 @@ void kvm_nested_s2_unmap(struct kvm *kvm)
 	}
 }
 
+void kvm_nested_s2_unmap_range(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	int i;
+	long size;
+	bool ret;
+
+	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
+		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
+
+		if (kvm_s2_mmu_valid(mmu)) {
+			phys_addr_t shadow_ipa, start, end;
+
+			start = range->start << PAGE_SHIFT;
+			end = range->end << PAGE_SHIFT;
+
+			while (start < end) {
+				size = PAGE_SIZE;
+				/*
+				 * get the Shadow IPA if the page is mapped
+				 * to L1 and also mapped to any of active L2.
+				 */
+				ret = get_shadow_ipa(mmu, start, &shadow_ipa, &size);
+				if (ret)
+					kvm_unmap_stage2_range(mmu, shadow_ipa, size);
+				start += size;
+			}
+		}
+	}
+}
+
 /* expects kvm->mmu_lock to be held */
 void kvm_nested_s2_flush(struct kvm *kvm)
 {
-- 
2.40.1


