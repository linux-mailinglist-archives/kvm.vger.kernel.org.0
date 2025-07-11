Return-Path: <kvm+bounces-52185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 351CDB021EE
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 18:37:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 803AE567BDE
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 16:37:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CCA32EF29A;
	Fri, 11 Jul 2025 16:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PFZ/Uq8y"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2061.outbound.protection.outlook.com [40.107.236.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF856ADD;
	Fri, 11 Jul 2025 16:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752251860; cv=fail; b=BhQ7ZwNoLqr3x8P2egZMNLuTInYFPPUISxQtQMPsDpcHvHiC6XJcxztBl4Etuhwz5VSZ4I4P47IzmhhdTfHUiSQbC0h8lHcMdbL09aNc1OZZidlXuz9M6GFUZIJT8zfOHXpHjHjdo4SE+yvFMVuVdzFEKcGlV2eG9Rqs7XC1ClE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752251860; c=relaxed/simple;
	bh=sgf2Oqq6JU3XZSbsVCmUz5qCPbjm9aMJ0KQcsPQkD9w=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gVeF8fUjvuxp+waYj1n6zLWrFLZolzr8Zn9BG6/C2YK/5JRiwsFoLgcQAI2q8dEzUVOPk91Yr8mX9SQtp0qgsvWkmgiqh8HPxSpRXSMDD92tnU9zoZUoSVrv5sIarNqMlCE87dALNjcSeN4ZQPZI9MnBydE+AewcO7iOnPRtWtI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PFZ/Uq8y; arc=fail smtp.client-ip=40.107.236.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S1rOOvuCWwAXYdZdY6Pxh1V3jdtbpyFPff11sDS7C1r2TG4WApYRe9qTg+iEwmC8OJtxwPfroOpbQcNVLdwWjGLomwyTjDWauA5IvAW/QOqOiWlwsuVC1nctiw+caGUcsuSkBRr9i8ujDe0A/bFKUsAv7d9rhesXoS5v/TakHsO5zIVcIwknQU2Nh6tbyiEc1kePCyZ94lKa+YjylxntEJEwWfBMxtl/xvEAUC2Ow9o/A5Nezcr7Lo99f2WSGfuKOXeXseQOGEV5WZcTL+yJ2JfMXV7oO+lWDvtywgOhywrDev1RVXbbvm6ELxSKXIieLQ8Xjl5Ox7tUU4X44QHMoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DeMTBO6/gpQUgvqgDYi1ml7zN0BCCm0a9MT9C6fhkGw=;
 b=WInncwjlzAh3GGO/SWdv6laWYEPnX4nIdRr/BYhhe7LTpJP+3wJpwJoDz2rwpT5O8JcOe6gaYNSPCkXD98TM2sPJXcX9UBYbi4gMJjJAtD/X+t/fKdagFFYQKp70pJuK0GGu1Xw6ZPQ9dCLrHdhPvGWEVpVG7XLcjEcSht8+RXVglD4fLyH4tb3uHpLMa6gFEr3QXrjgzgq2ThZx9IHX/CnQiYpFCmXUNTnjr+ThEIpV5/D4LiBulMdADvnUm1cMEkGRuCDNPyQlqVIxGBZ0dFXbiPN8FTavcLie1czy24oBuyKgjyB798HUrBGMaFITKJ1f4USBa5rpsnOrBeMlOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DeMTBO6/gpQUgvqgDYi1ml7zN0BCCm0a9MT9C6fhkGw=;
 b=PFZ/Uq8ytsGgmqf28z6yAVex4t2bRbbrokGBIlboAGE/Y1L1jyA4a60c9hwkli/rOoOSPT1ZN/+eOmi67suvM+12VojJUdgarNkkvVozgw9XLpk7kgsnxTLCOPIQo+n49JN4D7q7lFx4h5ibAyzEwBMR+W6Xa/haRyRJLUUrCTk=
Received: from CH0P223CA0021.NAMP223.PROD.OUTLOOK.COM (2603:10b6:610:116::9)
 by DS7PR12MB6214.namprd12.prod.outlook.com (2603:10b6:8:96::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.29; Fri, 11 Jul
 2025 16:37:33 +0000
Received: from CH3PEPF00000012.namprd21.prod.outlook.com
 (2603:10b6:610:116:cafe::49) by CH0P223CA0021.outlook.office365.com
 (2603:10b6:610:116::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.25 via Frontend Transport; Fri,
 11 Jul 2025 16:37:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF00000012.mail.protection.outlook.com (10.167.244.117) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8964.1 via Frontend Transport; Fri, 11 Jul 2025 16:37:32 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 11 Jul
 2025 11:37:32 -0500
Date: Fri, 11 Jul 2025 11:34:40 -0500
From: Michael Roth <michael.roth@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: Yan Zhao <yan.y.zhao@intel.com>, <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kai.huang@intel.com>,
	<adrian.hunter@intel.com>, <reinette.chatre@intel.com>,
	<xiaoyao.li@intel.com>, <tony.lindgren@intel.com>,
	<binbin.wu@linux.intel.com>, <dmatlack@google.com>,
	<isaku.yamahata@intel.com>, <ira.weiny@intel.com>, <vannapurve@google.com>,
	<david@redhat.com>, <ackerleytng@google.com>, <tabba@google.com>,
	<chao.p.peng@intel.com>
Subject: Re: [RFC PATCH] KVM: TDX: Decouple TDX init mem region from
 kvm_gmem_populate()
Message-ID: <20250711163440.kwjebnzd7zeb4bxt@amd.com>
References: <20250703062641.3247-1-yan.y.zhao@intel.com>
 <20250709232103.zwmufocd3l7sqk7y@amd.com>
 <aG_pLUlHdYIZ2luh@google.com>
 <aHCUyKJ4I4BQnfFP@yzhao56-desk>
 <20250711151719.goee7eqti4xyhsqr@amd.com>
 <aHEwT4X0RcfZzHlt@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aHEwT4X0RcfZzHlt@google.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF00000012:EE_|DS7PR12MB6214:EE_
X-MS-Office365-Filtering-Correlation-Id: 29dcdd90-93e4-460b-6bea-08ddc0993c47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iAYTnhrs+JBDpJ8N0tA8oMeU+757mv8gmrgsUTkz2nY4j3OSkVpVK3iQFnbR?=
 =?us-ascii?Q?XE5pzEVKpPg1ftUFyXd9lb6FYhRUT7l5AK94LsDrIg00DJ0eLMHjHZK4JAma?=
 =?us-ascii?Q?Jc5TFZGJO+eXnnzOh94okCWMDjkK+6QVD1Us/0r3ivi/SlvRFFHmZK8Tcjef?=
 =?us-ascii?Q?JMgCTZg1+w9o4PBcND+zHKsfvNwe+CDfFCBE05Cijqtvp3wic9GJKM3L1hE+?=
 =?us-ascii?Q?f2K2O/MhN1k7sENQ2ni9QrQOImb0VW6EnO75rbS/LoA7ZJdLn6OOChLgjX9u?=
 =?us-ascii?Q?28KH3Cggc70iwwjVlnwTDJekM7IkJc/zrMn7l9urCXjT6cFbGrUkb/wlgTrq?=
 =?us-ascii?Q?2GxusGrufwdgAEclFCRjBluty38PwjTb0uihAD1X/a+FzE9Lxi9q3PjG8wx4?=
 =?us-ascii?Q?7stsiUxZdfr8tpU7RI/jzYifs24QYEkUgVeNlewPRqBDtjNnrgjrUKdo9T55?=
 =?us-ascii?Q?5ZjKqaLNvbcPszgmg0bfEfxrisN/Q+vK9t9asl2iHGvkaokrWdLDXbSJqnRJ?=
 =?us-ascii?Q?SoNbX/JYMV+exX72P/D00FcvVjdgS/hoNcdaLNmuiw8ldfREujVi41bFY424?=
 =?us-ascii?Q?bv7DQEYrAoUBDs4CxctwasKdW5WLpBt1/EJYphHn5FUKts1ht72erflo/z13?=
 =?us-ascii?Q?YoWQNMlwbuWB2w3955wtUFiJtHpPYLGnauRe/V4WYZVnOZZKU4MNbbxSKDLi?=
 =?us-ascii?Q?dQpOBtGl/GkbFEuvlObrI3KqLrh+bO6V5AZhH6BmVU9tFUJr0E9LbfjNSD/q?=
 =?us-ascii?Q?mGXvWVMm8IzAkDramn00FzVlD9kUhSd+UZ0oj09lnVeDSrQt8hgATrFMp/Tc?=
 =?us-ascii?Q?P5ElFy6fXeabAyHYtcVrMTo0nc+NIOy21YNqgQl2hQv5ntsOzqvADzd8FY9n?=
 =?us-ascii?Q?zqM6M1C9ZND4hkETnmUIt1uJzN2FzU6puyJcr9pb5ZWsMqk1Jm0azOl5VuO1?=
 =?us-ascii?Q?IuhBmWzrF4AxpcuOCq/0OhXet1LDfBXl+T/LhzYmNwRwlqVgcxU4zx7ZknQm?=
 =?us-ascii?Q?/VNl9caCIPZwysAmiNqtXdUlIoyFyym9givpUixOh0Lfsqy4TKcZe1Ennnb4?=
 =?us-ascii?Q?LdFtYi1y9JtclivuWaA2KnWm7aNiGJxXibdATq4wS7ACkzMLPIqOfgKxndtc?=
 =?us-ascii?Q?ksfja5fBpVaG4zM/SqCfuwyiYyMurmUwH472PDMcUYD73kRBt/7hJhAPpMAS?=
 =?us-ascii?Q?gUdjoJ+xQpKeKklxS4+rZo+GWkEwpxPVMFFoW/todg+wh7C/l268IyrKo8Xu?=
 =?us-ascii?Q?w083Miy6eYzsQ1NeNCPLstY4XUOYjhUzqMUe6yZTv6cPBDACICQY2iYWiDui?=
 =?us-ascii?Q?XG+4c9hcKd98wSHTzhoAFrd4M8GZRNxKP5o9CUuuSSTgTTKT64DMVWzM9m34?=
 =?us-ascii?Q?9XsEikFLJAaoTFwj1HFmVXfe8+8LKwqqi3JI6wSU/Wd/C9isrUThFRSbsWRq?=
 =?us-ascii?Q?GSPkWf/cner/7o+6OCD6pYJ7v49LmSDSLRRaQkxg0PSFSdezz3CtWujdKUle?=
 =?us-ascii?Q?F5OJl+q3zXG4Em0=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2025 16:37:32.9777
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 29dcdd90-93e4-460b-6bea-08ddc0993c47
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000012.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6214

On Fri, Jul 11, 2025 at 08:39:59AM -0700, Sean Christopherson wrote:
> On Fri, Jul 11, 2025, Michael Roth wrote:
> > On Fri, Jul 11, 2025 at 12:36:24PM +0800, Yan Zhao wrote:
> > > Besides, it can't address the 2nd AB-BA lock issue as mentioned in the patch
> > > log:
> > > 
> > > Problem
> > > ===
> > > ...
> > > (2)
> > > Moreover, in step 2, get_user_pages_fast() may acquire mm->mmap_lock,
> > > resulting in the following lock sequence in tdx_vcpu_init_mem_region():
> > > - filemap invalidation lock --> mm->mmap_lock
> > > 
> > > However, in future code, the shared filemap invalidation lock will be held
> > > in kvm_gmem_fault_shared() (see [6]), leading to the lock sequence:
> > > - mm->mmap_lock --> filemap invalidation lock
> > 
> > I wouldn't expect kvm_gmem_fault_shared() to trigger for the
> > KVM_MEMSLOT_SUPPORTS_GMEM_SHARED case (or whatever we end up naming it).
> 
> Irrespective of shared faults, I think the API could do with a bit of cleanup
> now that TDX has landed, i.e. now that we can see a bit more of the picture.
> 
> As is, I'm pretty sure TDX is broken with respect to hugepage support, because
> kvm_gmem_populate() marks an entire folio as prepared, but TDX only ever deals

Yes, for the THP-based hugepage patchset the preparation-tracking was
modified so that only the range passed to post_populate() callback will
be marked as prepared, so I think that would have addressed this case
unless there's something more specific to TDX in that regard (otherwise
it seems analogous to SNP considerations).

However, I think the current leaning here is to drop tracking of
prepared/unprepared entirely for in-place conversion / hugepage case. I
posted an RFC patch that does this in prep for in-place conversion support:

  https://lore.kernel.org/kvm/20250613005400.3694904-2-michael.roth@amd.com/

So in that case kvm_arch_gmem_prepare() would always be called via
kvm_gmem_get_pfn() and the architecture-specific code will handle
checking whether additional prep is needed or not. (In that context,
one might even consider removing kvm_arch_gmem_prepare() entirely from
gmem in that case and considering it a KVM/hypervisor MMU hook instead
(which would be more along the lines of TDX, but that's a less-important
topic)).


> with one page at a time.  So that needs to be changed.  I assume it's already
> address in one of the many upcoming series, but it still shows a flaw in the API.
> 
> Hoisting the retrieval of the source page outside of filemap_invalidate_lock()
> seems pretty straightforward, and would provide consistent ABI for all vendor
> flavors.  E.g. as is, non-struct-page memory will work for SNP, but not TDX.  The
> obvious downside is that struct-page becomes a requirement for SNP, but that
> 
> The below could be tweaked to batch get_user_pages() into an array of pointers,
> but given that both SNP and TDX can only operate on one 4KiB page at a time, and
> that hugepage support doesn't yet exist, trying to super optimize the hugepage
> case straightaway doesn't seem like a pressing concern.
> 
> static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
> 				struct file *file, gfn_t gfn, void __user *src,
> 				kvm_gmem_populate_cb post_populate, void *opaque)
> {
> 	pgoff_t index = kvm_gmem_get_index(slot, gfn);
> 	struct page *src_page = NULL;
> 	bool is_prepared = false;
> 	struct folio *folio;
> 	int ret, max_order;
> 	kvm_pfn_t pfn;
> 
> 	if (src) {
> 		ret = get_user_pages((unsigned long)src, 1, 0, &src_page);
> 		if (ret < 0)
> 			return ret;
> 		if (ret != 1)
> 			return -ENOMEM;
> 	}

One tricky part here is that the uAPI currently expects the pages to
have the private attribute set prior to calling kvm_gmem_populate(),
which gets enforced below.

For in-place conversion: the idea is that userspace will convert
private->shared to update in-place, then immediately convert back
shared->private; so that approach would remain compatible with above
behavior. But if we pass a 'src' parameter to kvm_gmem_populate(),
and do a GUP or copy_from_user() on it at any point, regardless if
it is is outside of filemap_invalidate_lock(), then
kvm_gmem_fault_shared() will return -EACCES. The only 2 ways I see
around that are to either a) stop enforcing that pages that get
processed by kvm_gmem_populate() are private for in-place conversion
case, or b) enforce that 'src' is NULL for in-place conversion case.

I think either would handle the ABBA issue.

One nice thing about a) is that we wouldn't have to change the API for
SNP_LAUNCH_UPDATE since 'src' could still get passed to
kvm_gmem_populate(), but it's kind of silly since we are copying the
pages into themselves in that case. And we still need uAPI updates
regardless expected initial shared/private state for pages passed to
SNP_LAUNCH_UPDATE so to me it seems simpler to just never have to deal
with 'src' anymore outside of the legacy cases (but maybe your change
still makes sense to have just in terms of making the sequencing of
locks/etc clearer for the legacy case).

-Mike

> 
> 	filemap_invalidate_lock(file->f_mapping);
> 
> 	if (!kvm_range_has_memory_attributes(kvm, gfn, gfn + 1,
> 					     KVM_MEMORY_ATTRIBUTE_PRIVATE,
> 					     KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
> 		ret = -EINVAL;
> 		goto out_unlock;
> 	}
> 
> 	folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &is_prepared, &max_order);
> 	if (IS_ERR(folio)) {
> 		ret = PTR_ERR(folio);
> 		goto out_unlock;
> 	}
> 
> 	folio_unlock(folio);
> 
> 	if (is_prepared) {
> 		ret = -EEXIST;
> 		goto out_put_folio;
> 	}
> 
> 	ret = post_populate(kvm, gfn, pfn, src_page, opaque);
> 	if (!ret)
> 		kvm_gmem_mark_prepared(folio);
> 
> out_put_folio:
> 	folio_put(folio);
> out_unlock:
> 	filemap_invalidate_unlock(file->f_mapping);
> 
> 	if (src_page)
> 		put_page(src_page);
> 	return ret;
> }
> 
> long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
> 		       kvm_gmem_populate_cb post_populate, void *opaque)
> {
> 	struct file *file;
> 	struct kvm_memory_slot *slot;
> 	void __user *p;
> 	int ret = 0;
> 	long i;
> 
> 	lockdep_assert_held(&kvm->slots_lock);
> 	if (npages < 0)
> 		return -EINVAL;
> 
> 	slot = gfn_to_memslot(kvm, start_gfn);
> 	if (!kvm_slot_can_be_private(slot))
> 		return -EINVAL;
> 
> 	file = kvm_gmem_get_file(slot);
> 	if (!file)
> 		return -EFAULT;
> 
> 	npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
> 	for (i = 0; i < npages; i ++) {
> 		if (signal_pending(current)) {
> 			ret = -EINTR;
> 			break;
> 		}
> 
> 		p = src ? src + i * PAGE_SIZE : NULL;
> 
> 		ret = __kvm_gmem_populate(kvm, slot, file, start_gfn + i, p,
> 					  post_populate, opaque);
> 		if (ret)
> 			break;
> 	}
> 
> 	fput(file);
> 	return ret && !i ? ret : i;
> }
> 

