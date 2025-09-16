Return-Path: <kvm+bounces-57799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60AB6B7DBF9
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 14:34:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F03FA32502E
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 23:34:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7D7F2D372D;
	Tue, 16 Sep 2025 23:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="K5GAjMmh"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013031.outbound.protection.outlook.com [40.93.201.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F5FBA45;
	Tue, 16 Sep 2025 23:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758065643; cv=fail; b=suYidq9lKcPIeAgL9LhB9xw1MOCouzF2peq3SCl14OfTUM0X0zyUh12Y36WXqvcqQmC704K6KGfp9ETtrt7grioQ/TgJCNuf6dsItOmC4WuajG3BRBs2iBuSCfEJPRq48jbIHDryKD0PjO3d5Jl9yPQqwdlBZ1vqK5DwwAr9NIs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758065643; c=relaxed/simple;
	bh=cYbFvgsqJvx77YcFNU8KUU1P7f2bKCoOrk1pZbPmXPk=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HMxygnWvfhbgKUeJ82rlltmxKGuezmBjoaj2IsnJewJZ4PiKjwaRdXdC2lV3LwoNI6JzsrTcEGPuneAjDIZBNEuAZ5ipK6PS8qj4bdBMZdSV1lzoHTT72hRlbvp84QOX93MZG0FKG23lCirFok7adLQ1fRje436KcYOPjXyPTgY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=K5GAjMmh; arc=fail smtp.client-ip=40.93.201.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aPBzAIgUyzmyLzAUM8xfoKkR/3IzuWpfbmrH4n82d+KfVHU4gEqsB1X4cAzKBeT4o4DVKtay21If6PLys8Pnajhrli+LTXYb4g9wn4bFQ8Yslt0lN7ObpP94s4b5U8AahpxZBn7petXpYdNKeYzHfN6Vwvb4hSTicZjZYkAsQlG0U6q0/5h3SQ1tehqa3GORzlGRrdJ1+TK3GPM6pu56V2nw/YSMGqb9Z5OkNzZ4dqMAyBN5+TF7FmgFtjnX2jNPLY0kKQ8TRD6E9pNRW74FpdG/L2EJ0KmYcaT3aPufHiHYIkvDwCDr+X5og4/x8LIDqRWcsRLP69GBKGX7/1BJWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cj8fLV3BBwNmrLeQQfjwntZ/T4urDB8PG/NecqD4WrE=;
 b=VEoMgFpaAkj2/GmFNVe+g1EM7HnZkfKPKe0VfDdVpu57/8bmt6FxTZ6YpaLvmakQCkxhela84pssX8EF9HtlUtuFUsX6T3XMzqk9kWNz08my6mHWAkjBMSGatZFBwSynlklVow6JSIMRfcur2qgDnkGLBLQikDbWtcQe33vdGg5rO699c5S8Puxo8jpKY1qKFI9OpBwp37UUnLtQBtCBcLWRkygUFF+k6ve/tstgIXTv95dOqoY0SwjD+trEHqc0W5wjU2cS6KdWfculytkWdAT4jb90eCZrXW66ZWrV8PW04ILJFenOYfYCeT8bJOYL1d3G015mtQNGqD1lNZsPGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cj8fLV3BBwNmrLeQQfjwntZ/T4urDB8PG/NecqD4WrE=;
 b=K5GAjMmhQuRje2tg2YexhXkkGVV4I+v/AM3GuRRDk0tW2qYhjCqw7HC3aAbE7C8w+OWnoD8MVIxhl7b25d34OYfmQprAcJmE9KBS6ZuPFSDbs+4HeyGX5uV9Ij7eP1s/B3jCPDL8KtKO39ekBNZnMz4U6d3wFp4P5TxNC9Z6qj0=
Received: from BYAPR08CA0003.namprd08.prod.outlook.com (2603:10b6:a03:100::16)
 by SA3PR12MB9227.namprd12.prod.outlook.com (2603:10b6:806:398::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.23; Tue, 16 Sep
 2025 23:33:55 +0000
Received: from SN1PEPF000397B3.namprd05.prod.outlook.com
 (2603:10b6:a03:100:cafe::e3) by BYAPR08CA0003.outlook.office365.com
 (2603:10b6:a03:100::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.22 via Frontend Transport; Tue,
 16 Sep 2025 23:33:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF000397B3.mail.protection.outlook.com (10.167.248.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Tue, 16 Sep 2025 23:33:54 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 16 Sep
 2025 16:33:53 -0700
Date: Tue, 16 Sep 2025 18:33:35 -0500
From: Michael Roth <michael.roth@amd.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <david@redhat.com>, <tabba@google.com>,
	<vannapurve@google.com>, <ira.weiny@intel.com>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<joro@8bytes.org>, <pratikrajesh.sampat@amd.com>, <liam.merwick@oracle.com>,
	<yan.y.zhao@intel.com>, <aik@amd.com>
Subject: Re: [PATCH RFC v1 1/5] KVM: guest_memfd: Remove preparation tracking
Message-ID: <20250916233335.wv2lf4fiejlw53o2@amd.com>
References: <20250613005400.3694904-1-michael.roth@amd.com>
 <20250613005400.3694904-2-michael.roth@amd.com>
 <diqztt1vf198.fsf@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <diqztt1vf198.fsf@google.com>
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B3:EE_|SA3PR12MB9227:EE_
X-MS-Office365-Filtering-Correlation-Id: 578fca2a-af35-454c-4542-08ddf5797feb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|7416014|1800799024|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CMNN4QLmxXNsrvAj+KuNh7HH4TK3kRkWPsR09mQSvoKuUotxXdWrUgoku05z?=
 =?us-ascii?Q?EEjZu25hS695YlUATCqylgG/RoKztOJXSpPW3xL62J1fhmRlX3sb6SMexNo6?=
 =?us-ascii?Q?1cB1cTLp6CmU+rgx29oCYEoU5FuMoPR5+F6QnW83xV0vA0xerw0KaltWg7e3?=
 =?us-ascii?Q?68hWySwUf2wbS0onl4F52KJXpU3zgHVIABjogbwJ2siNrl19/ekfp5gt5/PD?=
 =?us-ascii?Q?nUzjCIK3CcRXSoByr1d5Jw/KDMH+Kpcy8DQQNnCZZhZFyM+EMKnDHX1aAUjx?=
 =?us-ascii?Q?zj7tmWiRpiRo/MTG2Wdn64fjwCBbMRWELPWIvDwSXbP9jacpt5CsasnoQGz4?=
 =?us-ascii?Q?4XkdfJ3dgrBdv9Zxv6Ni02NfqD8/DSLHJs0gUHW4UDAkHgbniwXD28n11xWl?=
 =?us-ascii?Q?xPRolsiQtuaaSGohmJkPBxfirW1gH2vuzPkA3zKQVd73f/NxbYAFNa1e6KOz?=
 =?us-ascii?Q?OrNBI12mmyWIbL9WfdQ3bqfHVFH21V/gtZLh4by3Jq7Gs3/BWpHICxFw/JVS?=
 =?us-ascii?Q?/h13R14kFPMc6FJT90bJw799NWb59hHsv9IKiwPGZwcgtBMOEzYH9Xo9+iBj?=
 =?us-ascii?Q?fbCSMZ8OdsBIxRYDBhXaDcWXqxno85voyV7E2QFqlIlG/YJbtB8F2em+Ksm1?=
 =?us-ascii?Q?s/BuBuMU7rlpnliuhyOExv071dKN1Wy7Fh3hdVSAAV6sajMBRnb8jyzrEDux?=
 =?us-ascii?Q?0jxfhkyZRqK56d3n185XBZXABQ3oVirkAojyoc7YyFUup8H/gki7w7TppF1O?=
 =?us-ascii?Q?slPg4f+zU33yyyxIxnZ01QXeQUw9OscmjlgxPZzB8RjELBMj9Vf0hsaG9QJm?=
 =?us-ascii?Q?6Gf/XRgbe275lHwu6gSmV/lxo9tHA1fjMFDw+E3B2bMibzejmXzG+/MKvnSF?=
 =?us-ascii?Q?O0Qj5QT8loubao4GT3HiGxEafvQNbASJQQJlzA/k2QsZEU2HHP/cyyDTgPDO?=
 =?us-ascii?Q?L1ViKcouck70+tbkO1vmUJccQuH5Tg+ymNzldWB9/etCofC2kUMZD9gjWHEK?=
 =?us-ascii?Q?/yKtjzMVcDgAsYof/OOeZVzrdH+1MHtwCH336yy3CU6wgwA/yimygwzodFyR?=
 =?us-ascii?Q?ObiQPg8j3wF+3QTGrUXxvOooU1iBsPAbHjtetc5xzAicdvSFjpNLTeULV312?=
 =?us-ascii?Q?31OqM33CSuhioozQowFzGMINwqjttel4cHrdzACSUHY4GbMPZy4t8eh9RcPi?=
 =?us-ascii?Q?74/XjCqqvoxlViOlsskS2ay1RwWVyQXL7JdDslm1r/K/5J15sOjoyeVK0wai?=
 =?us-ascii?Q?j4aztq30kR/zAlZ41fjjvZIXN/lIJ2tzKxeeDPWN2KZzrXN/Pvh84jhCk8k+?=
 =?us-ascii?Q?6MjRJDk3T74V02dqrR773LM8XfmNgYRchxSIZ1cnl9PiEkuAy2WlSGlx6x+a?=
 =?us-ascii?Q?OfTwYxOm1V2GRGdp3fRsiVh9xxI/Uji9PwKDjNqJEpa3dLg6sWho+ZyE3mQI?=
 =?us-ascii?Q?hINOt6okx6WNcivjtmeDwrqxd5WhP16N8y5HLriDoj26PTg02rPre9FXC+HL?=
 =?us-ascii?Q?LE0GOHByw+Be7HE=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(7416014)(1800799024)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 23:33:54.1804
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 578fca2a-af35-454c-4542-08ddf5797feb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9227

On Mon, Aug 25, 2025 at 04:08:19PM -0700, Ackerley Tng wrote:
> Michael Roth <michael.roth@amd.com> writes:
> 
> > guest_memfd currently uses the folio uptodate flag to track:
> >
> >   1) whether or not a page had been cleared before initial usage
> >   2) whether or not the architecture hooks have been issued to put the
> >      page in a private state as defined by the architecture
> >
> > In practice, 2) is only actually being tracked for SEV-SNP VMs, and
> > there do not seem to be any plans/reasons that would suggest this will
> > change in the future, so this additional tracking/complexity is not
> > really providing any general benefit to guest_memfd users. Future plans
> > around in-place conversion and hugepage support, where the per-folio
> > uptodate flag is planned to be used purely to track the initial clearing
> > of folios, whereas conversion operations could trigger multiple
> > transitions between 'prepared' and 'unprepared' and thus need separate
> > tracking, will make the burden of tracking this information within
> > guest_memfd even more complex, since preparation generally happens
> > during fault time, on the "read-side" of any global locks that might
> > protect state tracked by guest_memfd, and so may require more complex
> > locking schemes to allow for concurrent handling of page faults for
> > multiple vCPUs where the "preparedness" state tracked by guest_memfd
> > might need to be updated as part of handling the fault.
> >
> > Instead of keeping this current/future complexity within guest_memfd for
> > what is essentially just SEV-SNP, just drop the tracking for 2) and have
> > the arch-specific preparation hooks get triggered unconditionally on
> > every fault so the arch-specific hooks can check the preparation state
> > directly and decide whether or not a folio still needs additional
> > preparation. In the case of SEV-SNP, the preparation state is already
> > checked again via the preparation hooks to avoid double-preparation, so
> > nothing extra needs to be done to update the handling of things there.
> >
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> >  virt/kvm/guest_memfd.c | 47 ++++++++++++++----------------------------
> >  1 file changed, 15 insertions(+), 32 deletions(-)
> >
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index 35f94a288e52..cc93c502b5d8 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -421,11 +421,6 @@ static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slo
> >  	return 0;
> >  }
> >  
> > -static inline void kvm_gmem_mark_prepared(struct folio *folio)
> > -{
> > -	folio_mark_uptodate(folio);
> > -}
> > -
> >  /*
> >   * Process @folio, which contains @gfn, so that the guest can use it.
> >   * The folio must be locked and the gfn must be contained in @slot.
> > @@ -435,13 +430,7 @@ static inline void kvm_gmem_mark_prepared(struct folio *folio)
> >  static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
> >  				  gfn_t gfn, struct folio *folio)
> >  {
> > -	unsigned long nr_pages, i;
> >  	pgoff_t index;
> > -	int r;
> > -
> > -	nr_pages = folio_nr_pages(folio);
> > -	for (i = 0; i < nr_pages; i++)
> > -		clear_highpage(folio_page(folio, i));
> >  
> >  	/*
> >  	 * Preparing huge folios should always be safe, since it should
> > @@ -459,11 +448,8 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
> 
> While working on HugeTLB support for guest_memfd, I added a test that
> tries to map a non-huge-page-aligned gmem.pgoff to a huge-page aligned
> gfn.
> 
> I understand that config would destroy the performance advantages of
> huge pages, but I think the test is necessary since Yan brought up the
> use case here [1].
> 
> The conclusion in that thread, I believe, was to allow binding of
> unaligned GFNs to offsets, but disallow large pages in that case. The
> next series for guest_memfd HugeTLB support will include a fix similar
> to this [2].
> 
> While testing, I hit this WARN_ON with a non-huge-page-aligned
> gmem.pgoff.
> 
> >  	WARN_ON(!IS_ALIGNED(slot->gmem.pgoff, 1 << folio_order(folio)));
> 
> Do you all think this WARN_ON can be removed?

I think so.. I actually ended up dropping this WARN_ON() for a similar
reason:

  https://github.com/AMDESE/linux/commit/c654cd144ad0d823f4db8793ebf9b43a3e8a7c48

but in that case it was to deal with memslots where most of the GPA
ranges are huge-page aligned to the gmemfd, and it's just that the start/end
GPA ranges have been split up and associated with other memslots. In that case
I still try to allow hugepages but force order 0 in kvm_gmem_get_pfn()
for the start/end ranges.

I haven't really considered the case where entire GPA range is misaligned
with gmemfd hugepage offsets but the proposed handling seems reasonable
to me... I need to take a closer look at whether the above-mentioned
logic is at odds with what is/will be implemented in
kvm_alloc_memslot_metadata() however as that seems a bit more restrictive.

Thanks,

Mike

> 
> Also, do you think kvm_gmem_prepare_folio()s interface should perhaps be
> changed to take pfn, gfn, nr_pages (PAGE_SIZE pages) and level?
> 
> I think taking a folio is kind of awkward since we're not really setting
> up the folio, we're setting up something mapping-related for the
> folio. Also, kvm_gmem_invalidate() doesn't take folios, which is more
> aligned with invalidating mappings rather than something folio-related.
> 
> [1] https://lore.kernel.org/all/aA7UXI0NB7oQQrL2@yzhao56-desk.sh.intel.com/
> [2] https://github.com/googleprodkernel/linux-cc/commit/371ed9281e0c9ba41cfdc20b48a6c5566f61a7df
> 
> >  	index = gfn - slot->base_gfn + slot->gmem.pgoff;
> >  	index = ALIGN_DOWN(index, 1 << folio_order(folio));
> > -	r = __kvm_gmem_prepare_folio(kvm, slot, index, folio);
> > -	if (!r)
> > -		kvm_gmem_mark_prepared(folio);
> >  
> > -	return r;
> > +	return __kvm_gmem_prepare_folio(kvm, slot, index, folio);
> >  }
> >  
> > 
> > [...snip...]
> > 
> 

