Return-Path: <kvm+bounces-52002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68342AFF54F
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 01:21:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 854613A7805
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 23:21:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56BE52561D9;
	Wed,  9 Jul 2025 23:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kxGaqhLL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2077.outbound.protection.outlook.com [40.107.243.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19DBA21766A;
	Wed,  9 Jul 2025 23:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752103289; cv=fail; b=pK2Y9GNvrdsUI6g+lst0CREDe0PKPMICmdwZf76glnHuHCPofUEyNCx+fXvU+dcA78ToCvyw5rD4JTZx9N8/aZ1ipeQtO3A82v/QpiO+U/eFSOKE/4BbPJpVNc28nEEyisv/4ZuB3LN3S6BW7qT1csljzWdpTJi6c/LEWedYrMA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752103289; c=relaxed/simple;
	bh=q7oQM0kbP7ubN2nkQ/itj+sEZRk3X2IG52cAcoxuU2U=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lkz4fPH9mV9adREYB09i4U4Cw0qd1aox9tcEVymFVu1eHsdFp6j7hCMHr5XlefjwQCiaGk4Fj1hibHphozTJ+lfxGEPieCjkEG1+gtFCofZzc0bSqqxXv5jh2oAmURff2AiofcNr5zZkIWjzoJw62YjjM5WYs8EEuG6YJoTJERw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kxGaqhLL; arc=fail smtp.client-ip=40.107.243.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F3+sjBVd6gQXl2BdnpgIR9io+SwhGpF33yyya0hXOgqxzk+yic2BzHY+HeZ7jhuCVz5PZ+eXBMSd21eBLORHHQBK2eDZzGrnglTs415XV1K7Gb0Dd5VQHq6hGnaQKCV9lPfx1uNNW133eiBtPgPUDr8tDHQixC8tAxgo7MXqLYhgz5XrNknkUVo3SyWI8hHIqQzbilRZ4OLVaOFFEAubYY0ftB5WnECie9mhh8mBftSnraF8EPgHkMm2ZetN0CvbxRVGckviF32HS/Y8weCiIozVqBekh0TbuFS5aws/5jC0pS1zwgDMy+C+RwuCspB3ZOmaNMFMUrphD80GI5Ximg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WmUEjEMgwZKch0ojiLaj5WTyqRq9zR1hSwL2L6Kyu1c=;
 b=BdB/yr1HofMwOLoaDK839PIGz+3Ur1zLqTHJDYDUcpeY82v7bylqC969LweJoiCfV8W3d7sihwXXH1yNtR2YCzP+yBLgbhKEeCfJf9BI8f3drRKjM/W0zvFO4mrUnvIY6WCRZ76A0RHY2waAVO2BkaJcU/156xU5OgktAPgIUmK3sgADATh6AZuMERPmKr2nxbPmgzQQbPKk/0T4zpPZlqPcM+uPY+PI6/8yg0QfERlQAoIaU7oeCse+wLrkRk/A2Bliz1EOAyKG8FVzZpN7XSl0fPDWZUFmp0dtaTvFxaq8Ha7aOP2lQsMhZ7DiguluGHrpaubCc3egNSXPP36/zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WmUEjEMgwZKch0ojiLaj5WTyqRq9zR1hSwL2L6Kyu1c=;
 b=kxGaqhLLJFSnZYmDT0+2tPYrS961X1fHgDxnaQTy665ZCMUzThPOyhySczXS2GHpRe9HB3VEvpM0N8au8N26PaT9VeCp1t483sLKTXdy/hgXC+8bK1StZLOO0k+5MQhmYEahc5mCnlB0cWnHZik0rGgY5owjT2O4NKUb1X0dTB8=
Received: from SJ0P220CA0002.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:41b::10)
 by DM4PR12MB6325.namprd12.prod.outlook.com (2603:10b6:8:a4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.24; Wed, 9 Jul
 2025 23:21:21 +0000
Received: from SJ5PEPF00000209.namprd05.prod.outlook.com
 (2603:10b6:a03:41b:cafe::6b) by SJ0P220CA0002.outlook.office365.com
 (2603:10b6:a03:41b::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.22 via Frontend Transport; Wed,
 9 Jul 2025 23:21:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF00000209.mail.protection.outlook.com (10.167.244.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Wed, 9 Jul 2025 23:21:20 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 9 Jul
 2025 18:21:19 -0500
Date: Wed, 9 Jul 2025 18:21:03 -0500
From: Michael Roth <michael.roth@amd.com>
To: Yan Zhao <yan.y.zhao@intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
	<kai.huang@intel.com>, <adrian.hunter@intel.com>,
	<reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@intel.com>, <binbin.wu@linux.intel.com>,
	<dmatlack@google.com>, <isaku.yamahata@intel.com>, <ira.weiny@intel.com>,
	<vannapurve@google.com>, <david@redhat.com>, <ackerleytng@google.com>,
	<tabba@google.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH] KVM: TDX: Decouple TDX init mem region from
 kvm_gmem_populate()
Message-ID: <20250709232103.zwmufocd3l7sqk7y@amd.com>
References: <20250703062641.3247-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250703062641.3247-1-yan.y.zhao@intel.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000209:EE_|DM4PR12MB6325:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ca33c67-412b-4c74-a137-08ddbf3f5027
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|36860700013|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eq4Ow8pw9mNoMRZvpfNNMh5HROIvpogGQjv+TOdRYgeyGEj2Pe//U2RDVDk4?=
 =?us-ascii?Q?vW+dp8Mzx5HuvzF6waW52MnWyS/HENo4kR9AWmlnQMt29mXVU5YlWOzKD22/?=
 =?us-ascii?Q?4kbtpiVy9f1lVeNusboXEGTfYQ/N2r8B892oR04ZiasS/2jlZsa8ZsAlWiYF?=
 =?us-ascii?Q?y6Qbj0/UXchWVLNlJv1xgJ1/4grZ0RtNEDU71IOWsXhv4ew6O4QHBKiMuEqa?=
 =?us-ascii?Q?wv7Egknx+45K5WS3F1MLeuij4WB7t2ZLVCOqFMPxczodOp86sTvfnDClVbTO?=
 =?us-ascii?Q?vFwCo9he5hCS3QSl/JoaqvfOdPmxK5/lUZMa4MK+VURI/X6gb8gOkWohzTKD?=
 =?us-ascii?Q?qLhrbrRbuLXdfxHSTV9/7XEWT3xA2aQ0RHA8qb3O+n0buIhmMyBPl8sn4gho?=
 =?us-ascii?Q?7y6T4XZ9LuoT10CiO0MXJkxr51qdrPh/LAEnAP/9FLQ3u/tyetMHHkXffdfG?=
 =?us-ascii?Q?eunCyVXJgy3wLzwcxALDV7ghZPQiV73+H1X0agMuI3btrXNZqdrMoW89B/zx?=
 =?us-ascii?Q?t9hVhYW4u9iA7oy70y9JDLiLncGUnfPlOOIDKhnTBIRCnWTY6RZ7vvDNr3R3?=
 =?us-ascii?Q?xu4s7k+fnEqG5eT4ZuEXkdXqVWahvX44HjUwAulrEvGi0s8Z35XexXwIo9C3?=
 =?us-ascii?Q?i/UTXU1912/xqg1tgagmK8h8tXlgY8gUeEGj9ILILsC1vjtJUO0+HN1xIH6Y?=
 =?us-ascii?Q?/HVEQq2ujBtUqDbATK+Fxr4UCfrjcXqJis6gQkCGVZEz4yQFPvxDM1j/0ukk?=
 =?us-ascii?Q?Kr9WzvHed9l864spDy5SIxDHXyLaIYV8Rq8Qf1rRWTzlYchrG1hmxZNi+6Hi?=
 =?us-ascii?Q?ddl5TmAyZ/zLZowV28jXqgtJoJKftfPYgEMg2e63GdmbcyMp0pk9XOcD8+dq?=
 =?us-ascii?Q?AiZlC77KQly+b5SHYVQ9Xexhg/bgnlZLq7h2z33mG82VToSoBiaHrlifrDWS?=
 =?us-ascii?Q?JCJBYlcKL0vnEkk2AJ5D7+iQSSNdYcAWO4fmZUqfEXKXkJxaQ6jLs/WRO/rG?=
 =?us-ascii?Q?Ly+3m1uHSIGbh9kTO7NVrsYzwJpq3pZN5EjjDHcsamu3LR2tvtgKzI8NcNs6?=
 =?us-ascii?Q?/XKcbxUXymAY2UjIUkyOxc1/i9EZygMh7snbSMt89O6VdIQPZgXYAa6/U+IK?=
 =?us-ascii?Q?6m0/neByx/R+qwoI1HGQ3wULeitgZT7mzskjW/Q4aJFgFtKMviCS6Hap6jZ1?=
 =?us-ascii?Q?AMZX9s3S5UMwZ+fQctue2+OiBuJ4w9Ka4M6/SWSePACd6+weALBiyDvNvTTI?=
 =?us-ascii?Q?35/W1DMiXLxl8R9pQ6DdeqmRGGljFqzYaPNXyulcbBEbxw3ET/LBtWcsYtAe?=
 =?us-ascii?Q?AcQMP9oSTG0m61GgLLn76y0klNzW3M2uWm69EPnPaD44LNO5bgGZduCLkCxc?=
 =?us-ascii?Q?a4Nefsfy+++7gpTIxXiO6DLSK5bHh61W4173aSSmdkMtGvJsddiZISk+IvF1?=
 =?us-ascii?Q?4nZTJdvEWZ45LIXp+ThmYZ76EpAkI28tvsqCe6P9Ov9MWtEtRe6VNpQP9xcA?=
 =?us-ascii?Q?hT2xdmNvCDdbYRaJPbN8qbzmWasRwHzXdQKeIED1uvFUVpsgQituv1ayVQ?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(36860700013)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 23:21:20.3779
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ca33c67-412b-4c74-a137-08ddbf3f5027
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000209.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6325

On Thu, Jul 03, 2025 at 02:26:41PM +0800, Yan Zhao wrote:
> Rather than invoking kvm_gmem_populate(), allow tdx_vcpu_init_mem_region()
> to use open code to populate the initial memory region into the mirror page
> table, and add the region to S-EPT.
> 
> Background
> ===
> Sean initially suggested TDX to populate initial memory region in a 4-step
> way [1]. Paolo refactored guest_memfd and introduced kvm_gmem_populate()
> interface [2] to help TDX populate init memory region.
> 
> tdx_vcpu_init_mem_region
>     guard(mutex)(&kvm->slots_lock)
>     kvm_gmem_populate
>         filemap_invalidate_lock(file->f_mapping)
>             __kvm_gmem_get_pfn      //1. get private PFN
>             post_populate           //tdx_gmem_post_populate
>                 get_user_pages_fast //2. get source page
>                 kvm_tdp_map_page    //3. map private PFN to mirror root
>                 tdh_mem_page_add    //4. add private PFN to S-EPT and copy
>                                          source page to it.
> 
> kvm_gmem_populate() helps TDX to "get private PFN" in step 1. Its file
> invalidate lock also helps ensure the private PFN remains valid when
> tdh_mem_page_add() is invoked in TDX's post_populate hook.
> 
> Though TDX does not need the folio prepration code, kvm_gmem_populate()
> helps on sharing common code between SEV-SNP and TDX.
> 
> Problem
> ===
> (1)
> In Michael's series "KVM: gmem: 2MB THP support and preparedness tracking
> changes" [4], kvm_gmem_get_pfn() was modified to rely on the filemap
> invalidation lock for protecting its preparedness tracking. Similarly, the
> in-place conversion version of guest_memfd series by Ackerly also requires
> kvm_gmem_get_pfn() to acquire filemap invalidation lock [5].
> 
> kvm_gmem_get_pfn
>     filemap_invalidate_lock_shared(file_inode(file)->i_mapping);
> 
> However, since kvm_gmem_get_pfn() is called by kvm_tdp_map_page(), which is
> in turn invoked within kvm_gmem_populate() in TDX, a deadlock occurs on the
> filemap invalidation lock.

Bringing the prior discussion over to here: it seems wrong that
kvm_gmem_get_pfn() is getting called within the kvm_gmem_populate()
chain, because:

1) kvm_gmem_populate() is specifically passing the gmem PFN down to
   tdx_gmem_post_populate(), but we are throwing it away to grab it
   again kvm_gmem_get_pfn(), which is then creating these locking issues
   that we are trying to work around. If we could simply pass that PFN down
   to kvm_tdp_map_page() (or some variant), then we would not trigger any
   deadlocks in the first place.

2) kvm_gmem_populate() is intended for pre-boot population of guest
   memory, and allows the post_populate callback to handle setting
   up the architecture-specific preparation, whereas kvm_gmem_get_pfn()
   calls kvm_arch_gmem_prepare(), which is intended to handle post-boot
   setup of private memory. Having kvm_gmem_get_pfn() called as part of
   kvm_gmem_populate() chain brings things 2 things in conflict with
   each other, and TDX seems to be relying on that fact that it doesn't
   implement a handler for kvm_arch_gmem_prepare(). 

I don't think this hurts anything in the current code, and I don't
personally see any issue with open-coding the population path if it doesn't
fit TDX very well, but there was some effort put into making
kvm_gmem_populate() usable for both TDX/SNP, and if the real issue isn't the
design of the interface itself, but instead just some inflexibility on the
KVM MMU mapping side, then it seems more robust to address the latter if
possible.

Would something like the below be reasonable? I scoped it to only be for
mapping gmem pages, but I guess it could be generalized if similar use-case
ever arose. (completely untested)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index b4b6860ab971..93319f02f8b7 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -259,6 +259,8 @@ extern bool tdp_mmu_enabled;
 
 bool kvm_tdp_mmu_gpa_is_mapped(struct kvm_vcpu *vcpu, u64 gpa);
 int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level);
+int kvm_tdp_map_page_gmem(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level,
+                         kvm_pfn_t gmem_pfn);
 
 static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
 {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4e06e2e89a8f..61766ac0fa29 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4503,11 +4503,17 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
                return -EFAULT;
        }
 
-       r = kvm_gmem_get_pfn(vcpu->kvm, fault->slot, fault->gfn, &fault->pfn,
-                            &fault->refcounted_page, &max_order);
-       if (r) {
-               kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
-               return r;
+       if (fault->gmem_pfn == KVM_PFN_ERR_FAULT) {
+               r = kvm_gmem_get_pfn(vcpu->kvm, fault->slot, fault->gfn, &fault->pfn,
+                                    &fault->refcounted_page, &max_order);
+               if (r) {
+                       kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
+                       return r;
+               }
+       } else {
+               /* Only the above-handled KVM_PFN_ERR_FAULT is expected currently. */
+               WARN_ON_ONCE(is_error_pfn(fault->gmem_pfn);
+               fault->pfn = fault->gmem_pfn;
        }
 
        fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
@@ -4847,7 +4853,8 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
        return direct_page_fault(vcpu, fault);
 }
 
-int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level)
+int kvm_tdp_map_page_gmem(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level,
+                         kvm_pfn_t gmem_pfn)
 {
        int r;
 
@@ -4866,7 +4873,12 @@ int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level
                        return -EIO;
 
                cond_resched();
-               r = kvm_mmu_do_page_fault(vcpu, gpa, error_code, true, NULL, level);
+
+               if (is_error_pfn(pfn))
+                       r = kvm_mmu_do_page_fault(vcpu, gpa, error_code, true, NULL, level);
+               else
+                       folio_get(
+                       r = kvm_mmu_do_page_fault_pfn(vcpu, gpa, error_code, true, NULL, level, pfn);
        } while (r == RET_PF_RETRY);
 
        if (r < 0)
@@ -4889,6 +4901,12 @@ int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level
                return -EIO;
        }
 }
+EXPORT_SYMBOL_GPL(kvm_tdp_map_page_gmem);
+
+int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level)
+{
+       return kvm_tdp_map_page_gmem(vcpu, gpa, error_code, level, KVM_PFN_ERR_FAULT);
+}
 EXPORT_SYMBOL_GPL(kvm_tdp_map_page);
 
 long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index db8f33e4de62..b0ffa4541657 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -286,6 +286,7 @@ struct kvm_page_fault {
        /* Outputs of kvm_mmu_faultin_pfn().  */
        unsigned long mmu_seq;
        kvm_pfn_t pfn;
+       kvm_pfn_t gmem_pfn;
        struct page *refcounted_page;
        bool map_writable;
 
@@ -344,9 +345,10 @@ static inline void kvm_mmu_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
                                      fault->is_private);
 }
 
-static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
-                                       u64 err, bool prefetch,
-                                       int *emulation_type, u8 *level)
+static inline int __kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
+                                         u64 err, bool prefetch,
+                                         int *emulation_type, u8 *level,
+                                         kvm_pfn_t gmem_pfn)
 {
        struct kvm_page_fault fault = {
                .addr = cr2_or_gpa,
@@ -367,6 +369,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
                .is_private = err & PFERR_PRIVATE_ACCESS,
 
                .pfn = KVM_PFN_ERR_FAULT,
+               .gmem_pfn = gmem_pfn,
        };
        int r;
 
@@ -408,6 +411,14 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
        return r;
 }
 
+static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
+                                       u64 err, bool prefetch,
+                                       int *emulation_type, u8 *level)
+{
+       return __kvm_mmu_do_page_fault(vcpu, cr2_or_gpa, err, prefetch,
+                                      emulation_type, level, KVM_PFN_ERR_FAULT);
+}
+
 int kvm_mmu_max_mapping_level(struct kvm *kvm,
                              const struct kvm_memory_slot *slot, gfn_t gfn);
 void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b952bc673271..516416a9af27 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3075,7 +3075,7 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
        if (ret != 1)
                return -ENOMEM;
 
-       ret = kvm_tdp_map_page(vcpu, gpa, error_code, &level);
+       ret = kvm_tdp_map_page_gmem(vcpu, gpa, error_code, &level, pfn);
        if (ret < 0)
                goto out;

Thanks,

Mike

> 
> (2)
> Moreover, in step 2, get_user_pages_fast() may acquire mm->mmap_lock,
> resulting in the following lock sequence in tdx_vcpu_init_mem_region():
> - filemap invalidation lock --> mm->mmap_lock
> 
> However, in future code, the shared filemap invalidation lock will be held
> in kvm_gmem_fault_shared() (see [6]), leading to the lock sequence:
> - mm->mmap_lock --> filemap invalidation lock
> 
> This creates an AB-BA deadlock issue.
> 
> These two issues should still present in Michael Roth's code [7], [8].
> 
> Proposal
> ===
> To prevent deadlock and the AB-BA issue, this patch enables TDX to populate
> the initial memory region independently of kvm_gmem_populate(). The revised
> sequence in tdx_vcpu_init_mem_region() is as follows:
> 
> tdx_vcpu_init_mem_region
>     guard(mutex)(&kvm->slots_lock)
>     tdx_init_mem_populate
>         get_user_pages_fast //1. get source page
>         kvm_tdp_map_page    //2. map private PFN to mirror root
>         read_lock(&kvm->mmu_lock);
>         kvm_tdp_mmu_gpa_is_mapped // 3. check if the gpa is mapped in the
>                                         mirror root and return the mapped
>                                         private PFN.
>         tdh_mem_page_add    //4. add private PFN to S-EPT and copy source
>                                  page to it
>         read_unlock(&kvm->mmu_lock);
> 
> The original step 1 "get private PFN" is now integrated in the new step 3
> "check if the gpa is mapped in the mirror root and return the mapped
> private PFN".
> 
> With the protection of slots_lock, the read mmu_lock ensures the private
> PFN added by tdh_mem_page_add() is the same one mapped in the mirror page
> table. Addiontionally, before the TD state becomes TD_STATE_RUNNABLE, the
> only permitted map level is 4KB, preventing any potential merging or
> splitting in the mirror root under the read mmu_lock.
> 
> So, this approach should work for TDX. It still follows the spirit in
> Sean's suggestion [1], where mapping the private PFN to mirror root and
> adding it to the S-EPT with initial content from the source page are
> executed in separate steps.
> 
> Discussions
> ===
> The introduction of kvm_gmem_populate() was intended to make it usable by
> both TDX and SEV-SNP [3], which is why Paolo provided the vendor hook
> post_populate for both.
> 
> a) TDX keeps using kvm_gmem_populate().
>    Pros: - keep the status quo
>          - share common code between SEV-SNP and TDX, though TDX does not
>            need to prepare folios.
>    Cons: - we need to explore solutions to the locking issues, e.g. the
>            proposal at [11].
>          - PFN is faulted in twice for each GFN:
>            one in __kvm_gmem_get_pfn(), another in kvm_gmem_get_pfn().
> 
> b) Michael suggested introducing some variant of
>    kvm_tdp_map_page()/kvm_mmu_do_page_fault() to avoid invoking
>    kvm_gmem_get_pfn() in the kvm_gmem_populate() path. [10].
>    Pro:  - TDX can still invoke kvm_gmem_populate().
>            can share common code between SEV-SNP and TDX.
>    Cons: - only TDX needs this variant.
>          - can't fix the 2nd AB-BA lock issue.
> 
> c) Change in this patch
>    Pro: greater flexibility. Simplify the implementation for both SEV-SNP
>         and TDX.
>    Con: undermine the purpose of sharing common code.
>         kvm_gmem_populate() may only be usable by SEV-SNP in future.
> 
> Link: https://lore.kernel.org/kvm/Ze-TJh0BBOWm9spT@google.com [1]
> Link: https://lore.kernel.org/lkml/20240404185034.3184582-10-pbonzini@redhat.com [2]
> Link: https://lore.kernel.org/lkml/20240404185034.3184582-1-pbonzini@redhat.com [3]
> Link: https://lore.kernel.org/lkml/20241212063635.712877-4-michael.roth@amd.com [4]
> Link: https://lore.kernel.org/all/b784326e9ccae6a08388f1bf39db70a2204bdc51.1747264138.git.ackerleytng@google.com [5]
> Link: https://lore.kernel.org/all/20250430165655.605595-9-tabba@google.com [6]
> Link: https://github.com/mdroth/linux/commits/mmap-swprot-v10-snp0-wip2 [7]
> Link: https://lore.kernel.org/kvm/20250613005400.3694904-1-michael.roth@amd.com [8]
> Link: https://lore.kernel.org/lkml/20250613151939.z5ztzrtibr6xatql@amd.com [9]
> Link: https://lore.kernel.org/lkml/20250613180418.bo4vqveigxsq2ouu@amd.com [10]
> Link: https://lore.kernel.org/lkml/aErK25Oo5VJna40z@yzhao56-desk.sh.intel.com [11]
> 
> Suggested-by: Vishal Annapurve <vannapurve@google.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
> This is an RFC patch. Will split it later.
> ---
>  arch/x86/kvm/mmu.h         |  3 +-
>  arch/x86/kvm/mmu/tdp_mmu.c |  6 ++-
>  arch/x86/kvm/vmx/tdx.c     | 96 ++++++++++++++------------------------
>  3 files changed, 42 insertions(+), 63 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index b4b6860ab971..b122255c7d4e 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -257,7 +257,8 @@ extern bool tdp_mmu_enabled;
>  #define tdp_mmu_enabled false
>  #endif
>  
> -bool kvm_tdp_mmu_gpa_is_mapped(struct kvm_vcpu *vcpu, u64 gpa);
> +bool kvm_tdp_mmu_gpa_is_mapped(struct kvm_vcpu *vcpu, gpa_t gpa, int level,
> +			       kvm_pfn_t *pfn);
>  int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level);
>  
>  static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 7f3d7229b2c1..bb95c95f6531 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1934,7 +1934,8 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
>  	return __kvm_tdp_mmu_get_walk(vcpu, addr, sptes, root);
>  }
>  
> -bool kvm_tdp_mmu_gpa_is_mapped(struct kvm_vcpu *vcpu, u64 gpa)
> +bool kvm_tdp_mmu_gpa_is_mapped(struct kvm_vcpu *vcpu, gpa_t gpa, int level,
> +			       kvm_pfn_t *pfn)
>  {
>  	struct kvm *kvm = vcpu->kvm;
>  	bool is_direct = kvm_is_addr_direct(kvm, gpa);
> @@ -1947,10 +1948,11 @@ bool kvm_tdp_mmu_gpa_is_mapped(struct kvm_vcpu *vcpu, u64 gpa)
>  	rcu_read_lock();
>  	leaf = __kvm_tdp_mmu_get_walk(vcpu, gpa, sptes, root_to_sp(root));
>  	rcu_read_unlock();
> -	if (leaf < 0)
> +	if (leaf < 0 || leaf != level)
>  		return false;
>  
>  	spte = sptes[leaf];
> +	*pfn = spte_to_pfn(spte);
>  	return is_shadow_present_pte(spte) && is_last_spte(spte, leaf);
>  }
>  EXPORT_SYMBOL_GPL(kvm_tdp_mmu_gpa_is_mapped);
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index b952bc673271..f3c2bb3554c3 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1521,9 +1521,9 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
>  }
>  
>  /*
> - * KVM_TDX_INIT_MEM_REGION calls kvm_gmem_populate() to map guest pages; the
> - * callback tdx_gmem_post_populate() then maps pages into private memory.
> - * through the a seamcall TDH.MEM.PAGE.ADD().  The SEAMCALL also requires the
> + * KVM_TDX_INIT_MEM_REGION calls tdx_init_mem_populate() to first map guest
> + * pages into mirror page table and then maps pages into private memory through
> + * the a SEAMCALL TDH.MEM.PAGE.ADD().  The SEAMCALL also requires the
>   * private EPT structures for the page to have been built before, which is
>   * done via kvm_tdp_map_page(). nr_premapped counts the number of pages that
>   * were added to the EPT structures but not added with TDH.MEM.PAGE.ADD().
> @@ -3047,23 +3047,17 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  	WARN_ON_ONCE(init_event);
>  }
>  
> -struct tdx_gmem_post_populate_arg {
> -	struct kvm_vcpu *vcpu;
> -	__u32 flags;
> -};
> -
> -static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> -				  void __user *src, int order, void *_arg)
> +static int tdx_init_mem_populate(struct kvm_vcpu *vcpu, gpa_t gpa,
> +				 void __user *src, __u32 flags)
>  {
>  	u64 error_code = PFERR_GUEST_FINAL_MASK | PFERR_PRIVATE_ACCESS;
> -	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> -	struct tdx_gmem_post_populate_arg *arg = _arg;
> -	struct kvm_vcpu *vcpu = arg->vcpu;
> -	gpa_t gpa = gfn_to_gpa(gfn);
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> +	struct kvm *kvm = vcpu->kvm;
>  	u8 level = PG_LEVEL_4K;
>  	struct page *src_page;
>  	int ret, i;
>  	u64 err, entry, level_state;
> +	kvm_pfn_t pfn;
>  
>  	/*
>  	 * Get the source page if it has been faulted in. Return failure if the
> @@ -3079,38 +3073,33 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>  	if (ret < 0)
>  		goto out;
>  
> -	/*
> -	 * The private mem cannot be zapped after kvm_tdp_map_page()
> -	 * because all paths are covered by slots_lock and the
> -	 * filemap invalidate lock.  Check that they are indeed enough.
> -	 */
> -	if (IS_ENABLED(CONFIG_KVM_PROVE_MMU)) {
> -		scoped_guard(read_lock, &kvm->mmu_lock) {
> -			if (KVM_BUG_ON(!kvm_tdp_mmu_gpa_is_mapped(vcpu, gpa), kvm)) {
> -				ret = -EIO;
> -				goto out;
> -			}
> -		}
> -	}
> +	KVM_BUG_ON(level != PG_LEVEL_4K, kvm);
>  
> -	ret = 0;
> -	err = tdh_mem_page_add(&kvm_tdx->td, gpa, pfn_to_page(pfn),
> -			       src_page, &entry, &level_state);
> -	if (err) {
> -		ret = unlikely(tdx_operand_busy(err)) ? -EBUSY : -EIO;
> -		goto out;
> -	}
> +	scoped_guard(read_lock, &kvm->mmu_lock) {
> +		if (!kvm_tdp_mmu_gpa_is_mapped(vcpu, gpa, level, &pfn)) {
> +			ret = -EIO;
> +			goto out;
> +		}
>  
> -	if (!KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm))
> -		atomic64_dec(&kvm_tdx->nr_premapped);
> +		ret = 0;
> +		err = tdh_mem_page_add(&kvm_tdx->td, gpa, pfn_to_page(pfn),
> +				       src_page, &entry, &level_state);
> +		if (err) {
> +			ret = unlikely(tdx_operand_busy(err)) ? -EBUSY : -EIO;
> +			goto out;
> +		}
>  
> -	if (arg->flags & KVM_TDX_MEASURE_MEMORY_REGION) {
> -		for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
> -			err = tdh_mr_extend(&kvm_tdx->td, gpa + i, &entry,
> -					    &level_state);
> -			if (err) {
> -				ret = -EIO;
> -				break;
> +		if (!KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm))
> +			atomic64_dec(&kvm_tdx->nr_premapped);
> +
> +		if (flags & KVM_TDX_MEASURE_MEMORY_REGION) {
> +			for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
> +				err = tdh_mr_extend(&kvm_tdx->td, gpa + i, &entry,
> +						    &level_state);
> +				if (err) {
> +					ret = -EIO;
> +					break;
> +				}
>  			}
>  		}
>  	}
> @@ -3126,8 +3115,6 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *c
>  	struct kvm *kvm = vcpu->kvm;
>  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
>  	struct kvm_tdx_init_mem_region region;
> -	struct tdx_gmem_post_populate_arg arg;
> -	long gmem_ret;
>  	int ret;
>  
>  	if (tdx->state != VCPU_TD_STATE_INITIALIZED)
> @@ -3160,22 +3147,11 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *c
>  			break;
>  		}
>  
> -		arg = (struct tdx_gmem_post_populate_arg) {
> -			.vcpu = vcpu,
> -			.flags = cmd->flags,
> -		};
> -		gmem_ret = kvm_gmem_populate(kvm, gpa_to_gfn(region.gpa),
> -					     u64_to_user_ptr(region.source_addr),
> -					     1, tdx_gmem_post_populate, &arg);
> -		if (gmem_ret < 0) {
> -			ret = gmem_ret;
> -			break;
> -		}
> -
> -		if (gmem_ret != 1) {
> -			ret = -EIO;
> +		ret = tdx_init_mem_populate(vcpu, region.gpa,
> +					    u64_to_user_ptr(region.source_addr),
> +					    cmd->flags);
> +		if (ret)
>  			break;
> -		}
>  
>  		region.source_addr += PAGE_SIZE;
>  		region.gpa += PAGE_SIZE;
> -- 
> 2.43.2
> 

