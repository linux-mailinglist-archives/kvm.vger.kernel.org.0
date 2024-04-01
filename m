Return-Path: <kvm+bounces-13297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C259E894737
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 00:23:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7890D2824FA
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 22:23:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D96BB5674A;
	Mon,  1 Apr 2024 22:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="yRW90wHy"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2057.outbound.protection.outlook.com [40.107.220.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7881EB37;
	Mon,  1 Apr 2024 22:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712010185; cv=fail; b=mwRC2ZBgjCUmupRy4P95N7hYPkuli2zEc1EY0QIYNk9PRWMOYED2bxxlXPUe2Wdl44FUa8Zg7PUulXaIU5k2ZLIEdRZan+hoEXbqNZEOV/rTRcL81UlRaLDyNhVwOxYg+bhynfNHXb72qVN/mBYbG47CDlEDHiG7mBpc0P96Fj0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712010185; c=relaxed/simple;
	bh=9awq9AKTdgSn7CRyOrgRlvrOr60UIj7X6QJxqX4g8TA=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rDc8xwK9NT837hDyC7lEKyCDf+UQLij5wxQu1y9OpR6Pq6JpQcpFsiJpALKduIWaFpAx5sPwA8np+tfqH6EqDUo4nRmFqpNmbiu73PfDGzQuKqYgUz4SW8hVXkqoPzcSEEDm5wzN2HTzTSqNvb2Tk+/8qwRIeCI930O88Neold4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=yRW90wHy; arc=fail smtp.client-ip=40.107.220.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b/bJ2/a/4DxCEQdWkZl8F1yFad/MJgJt3jUi3NuxEBVmkGQo1h1xK6msc4/cEuOePjjyU0bt2dLK5/1M1bXgISR1Oa5uPlZ8e7kzcqiu7kQxBt3j8kKe2vdWV8ukoKMaYnkNKa2llDSY07gF7NUzqe9WmLmMNQvEcEacoh5w7Y67YS/G6x8clM3qYUg7SaG+mLP+DwV8qU1E3z73QgpoPDMmMrjy8yisWdEMT4/f0LwxjRkemQ6wCPH+oXlaQHH3olMXCwTQnGd8k09BUQk69ZQ1wMXyNXR7TKC/hdEWzXPrQjPjKWLH6vF1bEjxPSh217XcDJsJd4uu1IrsQt/I9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k0N8Vaj10N0dSIsXzzDqTH4AangxrFBtBRt3deKak0U=;
 b=eZMUtMzBPM553rjA+YA5Zc6zq1oy0h4RMf4t1PKXm0r3uWAxNbKOr6jWiMnNAzQbIh9UM9LGFXkgiuDY55ZSjJss3HfhmuqzRwYerI9FMPJdUKtGaH1tNGACeds3zuxTRZYGYRcOcC50TBhWNf/7CgPQNDLJKLLYz9lIi9dAgRYf7Mp2VlXQyPBb5vHKkp3aWY7Q1yIQ3amCmTiRl1lSd72qw7v0z46qDhtsP/Ka5SfZMnbE9Q8D2qcTAgY7mfl9QK3POmZ4GAGEXXlcDssn3nGRWYEXVeF5IR/24OCB7gtQWRgFIpUey6Dp80yuczKjfZj8CsOZBPGO0cv/SC1Tmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k0N8Vaj10N0dSIsXzzDqTH4AangxrFBtBRt3deKak0U=;
 b=yRW90wHygAtZCvp5N1ujSDHEK4mY7Zss8ymANofV/3JZvvobZrRRjeD/3gYzu6QtNJMhWFtF3Yk7ljTUEbJR35o9zHUPXTVnQ4sldNZ0+qg6vz3OKJ0uLELcVyeMp2urykH1Sby4ULM6gGmPSDnwiydk4X23lpVHClW7v4pTcB0=
Received: from CH2PR16CA0008.namprd16.prod.outlook.com (2603:10b6:610:50::18)
 by IA1PR12MB8222.namprd12.prod.outlook.com (2603:10b6:208:3f2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Mon, 1 Apr
 2024 22:22:52 +0000
Received: from CH1PEPF0000AD7D.namprd04.prod.outlook.com
 (2603:10b6:610:50:cafe::38) by CH2PR16CA0008.outlook.office365.com
 (2603:10b6:610:50::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46 via Frontend
 Transport; Mon, 1 Apr 2024 22:22:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD7D.mail.protection.outlook.com (10.167.244.86) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Mon, 1 Apr 2024 22:22:52 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 1 Apr
 2024 17:22:50 -0500
Date: Mon, 1 Apr 2024 17:22:29 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<jmattson@google.com>, <luto@kernel.org>, <dave.hansen@linux.intel.com>,
	<slp@redhat.com>, <pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>,
	<kirill@shutemov.name>, <ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>, Xu Yilun <yilun.xu@linux.intel.com>, Binbin Wu
	<binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v12 11/29] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
Message-ID: <20240401222229.qpnpozdsr6b2sntk@amd.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
 <20240329225835.400662-12-michael.roth@amd.com>
 <8c3685a6-833c-4b3c-83f4-c0bd78bba36e@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8c3685a6-833c-4b3c-83f4-c0bd78bba36e@redhat.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7D:EE_|IA1PR12MB8222:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a43d095-3e4e-417d-b0d8-08dc529a455a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4Ct9tPtFn37krlC2vECNzi4QxEfzsNZIqi7hseJJogkgpd9mMvY9UxfB/TTTot23lXHeNLaSbuKR9VPOmYvuMYj1/hltw3uO14lsxGfPlG+isUkQ/1NGt7htpusU1oZZOodgdEAR/RzS/1dPVPhP4Ah7hcxsUi1soQjf0UjFbXW6/coRoWpbPBPoktCTOlm5x4jCjabrtKpEa/vlJEM7xsNNhZqs8WXGWoXr7eI8bql8Uc7H1O+ADN8ZDejSE1rBSg/jFi21fzUYZuei4dbvk9FC1d9nk9Xr9b8I6Hmbl5X1TRasnlbwevcnMkm+pPyJEJ/67m+hRovPpQvYMNykxp1Mh+iW1FPhpXXSK0VbNmEL4mcvvbTaIlEbsW6Rv49A+FHO+DmA4AC8CmVfPxbU2OtnsCHPaLgyS4VTi5njk/YFkVqyhdHrwyBp8uH8SFP9nR6yT3K7YFAnzNc0LDjwGG2rzIVGhS7qVQ6vfVK2ul5KrffPZA9IjCUCC3V0IKrtMueIXyIubezFeuRQzfTziyHU291P+LmDtrY9EK+AygR0PkI4S4fyYPEf5xUFCX2a4gnYFPHS8XgcTpJH74dC8i82g91Gt+xN+Z6qFUrwExCFV++qjgXMeQYEawbh6X7xNt8QNlUlvG0jYZFWQvcjbKBd3Hu9NaC/rR8ubfmq1PnP0f80M/ryLTa/3/OCHFb8DN5AuHxcgi7C+Dj+OObEiw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(36860700004)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2024 22:22:52.0061
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a43d095-3e4e-417d-b0d8-08dc529a455a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8222

On Sat, Mar 30, 2024 at 09:31:40PM +0100, Paolo Bonzini wrote:
> On 3/29/24 23:58, Michael Roth wrote:

Cc'ing some more TDX folks.

> > +	memslot = gfn_to_memslot(kvm, params.gfn_start);
> > +	if (!kvm_slot_can_be_private(memslot)) {
> > +		ret = -EINVAL;
> > +		goto out;
> > +	}
> > +
> 
> This can be moved to kvm_gmem_populate.

That does seem nicer, but I hadn't really seen that pattern for
kvm_gmem_get_pfn()/etc. so wasn't sure if that was by design or not. I
suppose in those cases the memslot is already available at the main
KVM page-fault call-sites so maybe it was just unecessary to do the
lookup internally there.

> 
> > +	populate_args.src = u64_to_user_ptr(params.uaddr);
> 
> This is not used if !do_memcpy, and in fact src is redundant with do_memcpy.
> Overall the arguments can be "kvm, gfn, src, npages, post_populate, opaque"
> which are relatively few and do not need the struct.

This was actually a consideration for TDX that was discussed during the
"Finalizing internal guest_memfd APIs for SNP/TDX" PUCK call. In that
case, they have a TDH_MEM_PAGE_ADD seamcall that takes @src and encrypts
it, loads it into the destination page, and then maps it into SecureEPT
through a single call. So in that particular case, @src would be
initialized, but the memcpy() would be unecessary.

It's not actually clear TDX plans to use this interface. In v19 they still
used a KVM MMU hook (set_private_spte) that gets triggered through a call
to KVM_MAP_MEMORY->kvm_mmu_map_tdp_page() prior to starting the guest. But
more recent discussion[1] suggests that KVM_MAP_MEMORY->kvm_mmu_map_tdp_page()
would now only be used to create upper levels of SecureEPT, and the
actual mapping/encrypting of the leaf page would be handled by a
separate TDX-specific interface.

With that model, the potential for using kvm_gmem_populate() seemed
plausible to I was trying to make it immediately usable for that
purpose. But maybe the TDX folks can confirm whether this would be
usable for them or not. (kvm_gmem_populate was introduced here[2] for
reference/background)

-Mike

[1] https://lore.kernel.org/kvm/20240319155349.GE1645738@ls.amr.corp.intel.com/T/#m8580d8e39476be565534d6ff5f5afa295fe8d4f7
[2] https://lore.kernel.org/kvm/20240329212444.395559-3-michael.roth@amd.com/T/#m3aeba660fcc991602820d3703b1265722b871025)


> 
> I'll do that when posting the next version of the patches in kvm-coco-queue.
> 
> Paolo
> 

