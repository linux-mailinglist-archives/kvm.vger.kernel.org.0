Return-Path: <kvm+bounces-7183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2993183DF70
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 18:04:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A9A6B1F21FD1
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 17:04:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9186E1EB49;
	Fri, 26 Jan 2024 17:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="K7TwhBwo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2043.outbound.protection.outlook.com [40.107.237.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F17D1DFF7;
	Fri, 26 Jan 2024 17:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706288676; cv=fail; b=Z5sfzHh6Un4eHhOCOcO1VBc52aaCTCIfS9ZpZ5qorjQ3Ed/EZEfwYrfXIrGRa+64InIZ6jH/q4C3hchlvOI4YHFbM/q1ZPvm/N+p+3pYqrnZPUisTBje3NECwqRhQguQgysd+iMHVSsS2YLD65vX5bfH/hSqiwSEJ5xwMgiUlI0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706288676; c=relaxed/simple;
	bh=09mwhBDbwNEi9M6AIMT2Bpc1lpk3eAIVAjymH4XtRlI=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bgcxj4Xlr3vsoy4uvl+msIWG8J7jHCcsnJIf9bNJIWe+0X0cMF/GdQYmi6oEOzzyFgNW/vd6qbBxRBTk9gEH6EynVYNaBcvt6jZS2t934y8/GTraq6/2e/ivtFkWKeBuNhQNWi8mOzsOfR0vMGdWq32js/YPioHH/d33e4j86jM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=K7TwhBwo; arc=fail smtp.client-ip=40.107.237.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d7xH/NtPJZRS+RkJUmQuDNWhknQHwb9+zJ+pYSmOvzpJV6CSZeqM85taMgALAxBf1HCwyBLeup2xiICE960rleTuR7ZE/em3PNmnoIIphbdwO/BRZR7uE0xRAOUsUyUYV+RigPEGHFL1u1IYoA1kjJSi98F+6HdUiij3HuCdMfKwxiNcfJ58g1VmoQ2gZ3vmj5eDrFkZWQ6L82VLr5cocn+9jVaA+iMHIt1pUfPBsq3FFSDaNiye0paxi3wK1g3wu4lgWdmB7Zd91RpEEB0Xo46wVOUAal+II0vrj8k7N4B607xxGYMjTGvOhO+8qKRCkgsQlBMSIenxMmEV997ixA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7D3HMU4iNiLKmlHuqj7Pyiq0i3oOiWA0wLhseqWLGJE=;
 b=Ar7n4r2jM6GCywfxni9SB93dYuah0jmXUxI1tethNedbJgcdN9dcRzwXx47IvHzZHyQw5I/P3ueej5HeBBiLFgJmGJl1BkslyUg/1F3TmAwgrD45Monv7f35SlJO0+boXzKXMtml9y4xGcS0oBW0eZVHzg8W/yohy7dKYYIsB99JK56xS7DuyL5zBfd/QVt3o2mjSIvAsxqK2bfZ/waHiDqZgsGhEwUoqR9dShY9lL1ryRoFsZI6r2vANw8josol5Ty24LgGDNIia7y1l30ebIwM1oKHlNtDJjlrbSDrighLFri0n+h82ZtpykY/j0TcIrRpKvetzpzwv6fj2H2LGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7D3HMU4iNiLKmlHuqj7Pyiq0i3oOiWA0wLhseqWLGJE=;
 b=K7TwhBwok/nYgBwjan/byZuOeQDLTc46S/zW2yELxTUthSPpOVMdAh/Bwbvag9epAbq0WNRNzbNu8iKx8Vnm3gFND+7upcZlCbDVqENvqLQKSUMeBKfEMb8G8NIUpPzDE9txDkjRiwyuj2VGD9oYU7NbVCzDJ7gNudi8CmlMWUc=
Received: from BN9PR03CA0919.namprd03.prod.outlook.com (2603:10b6:408:107::24)
 by DM4PR12MB5342.namprd12.prod.outlook.com (2603:10b6:5:39f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.24; Fri, 26 Jan
 2024 17:04:31 +0000
Received: from BN2PEPF000044AC.namprd04.prod.outlook.com
 (2603:10b6:408:107:cafe::a8) by BN9PR03CA0919.outlook.office365.com
 (2603:10b6:408:107::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.27 via Frontend
 Transport; Fri, 26 Jan 2024 17:04:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000044AC.mail.protection.outlook.com (10.167.243.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7228.16 via Frontend Transport; Fri, 26 Jan 2024 17:04:30 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Fri, 26 Jan
 2024 11:04:28 -0600
Date: Fri, 26 Jan 2024 11:04:15 -0600
From: Michael Roth <michael.roth@amd.com>
To: Borislav Petkov <bp@alien8.de>
CC: <x86@kernel.org>, <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <tobin@ibm.com>, <vbabka@suse.cz>,
	<kirill@shutemov.name>, <ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: Re: [PATCH v2 11/25] x86/sev: Adjust directmap to avoid inadvertant
 RMP faults
Message-ID: <20240126170415.f7r4nvsrzgpzcrzv@amd.com>
References: <20240126041126.1927228-1-michael.roth@amd.com>
 <20240126041126.1927228-12-michael.roth@amd.com>
 <20240126153451.GDZbPRG3KxaQik-0aY@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240126153451.GDZbPRG3KxaQik-0aY@fat_crate.local>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044AC:EE_|DM4PR12MB5342:EE_
X-MS-Office365-Filtering-Correlation-Id: 16614c17-f87a-4b56-3195-08dc1e90dcb8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	1QMnA6ffmzgL/PyywB+uInmTvbFcDvcLerf00p9Y6y1hC8ECTPEID2wCPZ0U/ih+nTJRacH5aStUwtSUWvObwHtzz9doa3p9Z6IGrxuZYg6Bde2UEL8Il952P5eyeasKbSx3detu2ws/z3wYe/nH5CAhThkDI9V9Nf9A4UT8qQ3jviWIfbFKGxACgljVM/bweo9hdFYW+3R1v4HMjYAyik86Q4E5sqsMqbeiEhaMoY0RFfsM1kGD3l+pVCMOUpEnEXEbrsCAH5M/tZZ83I+wjGzS2lNo59MHFpPLOqJH7aDCxoRGW+k3Ej3FLDj3pH0bvD5b2yS0Xpe22dlfVc1H517U/z5J78dBwDZiYVzqg/PkeUVEAnOCmOxIOgwY5aUkgQTbOz4DhnjqrD9O1WfCHZUfeX5s0ZoHy5fgxWOvRhUdt4wIKQrmVrBSgiyWw83UVd1kjn8o+DEE/2KSGNIoo4AHdUeY5hX6IeNz4xbYoNAN27VyeKMS8Zxj1pjcDDoDPjMtFZuPE74q1IcVp2j4h16dnbWJGeEZbVJfTCX4Ae9ZgBLzshGfAw4B1xNHWG4S4SN1epnd8b8npCrS01Ucuir3XEDrBDYBoiNN4xPWfE8QOqjfIo1wrWiNPVZxzoWKLHXgNjA7sGlI8LvpNvkpFblPLsLBda1jQ1zJqA0XRq5sJuglh7BNz77nH/GECEQHDKgPtDHAskME9srrtKagUIza2VIJqLaIGsYcmxTc6tgiJiKd0k+UV8XpNf+S5R8Gi3I0swmGacufZSx6ojlTTQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(136003)(39860400002)(376002)(346002)(230922051799003)(82310400011)(64100799003)(1800799012)(186009)(451199024)(40470700004)(46966006)(36840700001)(336012)(426003)(26005)(16526019)(2616005)(4326008)(36756003)(1076003)(6916009)(8676002)(70586007)(54906003)(316002)(44832011)(7416002)(7406005)(2906002)(5660300002)(8936002)(86362001)(70206006)(6666004)(478600001)(41300700001)(966005)(40460700003)(40480700001)(36860700001)(47076005)(81166007)(82740400003)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 17:04:30.5231
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 16614c17-f87a-4b56-3195-08dc1e90dcb8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044AC.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5342

On Fri, Jan 26, 2024 at 04:34:51PM +0100, Borislav Petkov wrote:
> On Thu, Jan 25, 2024 at 10:11:11PM -0600, Michael Roth wrote:
> > +static int adjust_direct_map(u64 pfn, int rmp_level)
> > +{
> > +	unsigned long vaddr = (unsigned long)pfn_to_kaddr(pfn);
> > +	unsigned int level;
> > +	int npages, ret;
> > +	pte_t *pte;
> 
> Again, something I asked the last time but no reply:
> 
> Looking at Documentation/arch/x86/x86_64/mm.rst, the direct map starts
> at page_offset_base so this here should at least check
> 
> 	if (vaddr < __PAGE_OFFSET)
> 		return 0;

vaddr comes from pfn_to_kaddr(pfn), i.e. __va(paddr), so it will
necessarily be a direct-mapped address above __PAGE_OFFSET.

> 
> I'm not sure about the upper end. Right now, the adjusting should not

For upper-end, a pfn_valid(pfn) check might suffice, since only a valid
PFN would have a possibly-valid mapping wthin the directmap range.

> happen only for the direct map but also for the whole kernel address
> space range because we don't want to cause any mismatch between page
> mappings anywhere.
> 
> Which means, this function should be called adjust_kernel_map() or so...

These are PFNs that are owned/allocated-to the caller. Due to the nature
of the directmap it's possible non-owners would write to a mapping that
overlaps, but vmalloc()/etc. would not create mappings for any pages that
were not specifically part of an allocation that belongs to the caller,
so I don't see where there's any chance for an overlap there. And the caller
of these functions would not be adjusting directmap for PFNs that might be
mapped into other kernel address ranges like kernel-text/etc unless the
caller was specifically making SNP-aware adjustments to those ranges, in
which case it would be responsible for making those other adjustments,
or implementing the necessary helpers/etc.

I'm not aware of such cases in the current code, and I don't think it makes
sense to attempt to try to handle them here generically until such a case
arises, since it will likely involve more specific requirements than what
we can anticipate from a theoretical/generic standpoint.

-Mike

> 
> Hmmm.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

