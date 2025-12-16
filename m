Return-Path: <kvm+bounces-66087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 60B4ACC4F82
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 20:01:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DCED2302C8E5
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 19:01:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BF88318142;
	Tue, 16 Dec 2025 19:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="f7OkW+kN"
X-Original-To: kvm@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013027.outbound.protection.outlook.com [40.93.196.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06CD11946DF;
	Tue, 16 Dec 2025 19:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765911700; cv=fail; b=AQ4fXhFpEUDs5i2deESOvRo3JzgpideN2i96g83+Wp4oHNykJHh0WRsB04/J6fRDBJRJc6Qg6uXP/43d1MxWM3x/vhsbeBTRyznGcxHn0VkTixS4RuhbPVE1SfO2+YGngUb5M2Z5Xt259WOQV+Zcf5wH/vhr6jmMn7XsXKunWbo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765911700; c=relaxed/simple;
	bh=4KH9N0a/pvaYXfTnLoGwuqf+IHX8aqf09W5JT+qX71Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KDkAg3Llne2WsVfervimenVsWqU4v4iCXAB9l53OBfXhuGjXKnG/0VcQTiUTStIZkGfS4xf2c7zMcEFaL9WIhn1zWRSNU/kTgr+8i3I2wFvdPUJhIpbu9fIG2k7V6m+Zqpt60JtCZ6iaX+f7FpAh6X/wTRBY6Vkp52f+0HqNNsU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=f7OkW+kN; arc=fail smtp.client-ip=40.93.196.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PKC9W518iZWeDMi3hOnFQhYO03QJjsKJqgdbvZCz4mULtYUb9uzxDuZIXtAZB3fTp+wb4MJTUTDCHPiuXjstjbHv2UuhBw85+w5YqIs9chJVqiRr0xG3MTisAnSSKdpALKJUnoWpJcRP9NRU4y+MrcYIOb+QKRievpbP57E1UAtslmZm6adIC/T1B/y4OpqDmDIZIUwRcxLm1fjCEyXg0h34TekaYThbJh4jrwDgvVeAKNmElTGs9+ztWUiLTETGSq79090hoYwY56u3V2W3UoGxcuHq7fNSb5EGylQL7pc7RdEm9lvl7HHMIXN6E4eOFQm4+vWDrFugl8Tceg//qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eZjSg7Avf5aj1BMMM2sVXbHQTYZCCD18bj4EIKEByMU=;
 b=MkKvQ1v0ApBxhzE7AwT4yRtq3LyzZv4cu/hcgsHhFHdOcYFp375+TFMMiPbwjguhBo26XtOxz3Oab3dkqbMHxsjpJtDDjOSCJ494XK93xvCbgrKa3vOZxCEbirs8cGGHQibgDgrU4Anp+syfyYYwVjzucV6SDeQlLDqcSlYkKmBNkOkuEOQU8zSb+c03Eo4KbsR4cyj3kFT4AuBGqgKiD0A+PMCzxlJBfvfxQ6/PrUlXQ3Vo4QwImH/LUCT6cbMwldiHrLoPhRy43egzMFdb+d46OY9thpluMOur1XLfWGWEpwm2KAS3MMM8iOR2YX/4FB41D9PsvccvspeZYFheoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eZjSg7Avf5aj1BMMM2sVXbHQTYZCCD18bj4EIKEByMU=;
 b=f7OkW+kNmAAZBpHc7gbhhHGMquOfi0lAuwTcFsZhbrIbT9D7A4F8Yzp8q7Q0l67K44gDVEq4euRWcncx88371mUEG8dGxLGyYWBn/0SrVOMS74qErFqY2rGRQYt5EOkCGIaoKtZGyHevL5UCBfEvU5w9zGJA7JsrKnFD+iPBEMt9lj+xOVuAjonVJPrA0vgufo81SsBOcTUIB0fLg8CLCnfPsFZFuTNWl8Q2hCNWhghChzsS2sHOiB0GCltVMO7yr0ltiO9Ai5C88aHjVgjWjFwfQFA8DjiKCCIOkht2F9AfIuroRUm3k2okSCB5zGtktqMQUNZ3+sVhWcGjhtdJNw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY1PR12MB9601.namprd12.prod.outlook.com (2603:10b6:930:107::16)
 by MN2PR12MB4237.namprd12.prod.outlook.com (2603:10b6:208:1d6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Tue, 16 Dec
 2025 19:01:34 +0000
Received: from CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3]) by CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3%6]) with mapi id 15.20.9412.011; Tue, 16 Dec 2025
 19:01:33 +0000
Date: Tue, 16 Dec 2025 15:01:31 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Alex Mastro <amastro@fb.com>, David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 4/4] vfio-pci: Best-effort huge pfnmaps with
 !MAP_FIXED mappings
Message-ID: <20251216190131.GI6079@nvidia.com>
References: <20251204151003.171039-1-peterx@redhat.com>
 <20251204151003.171039-5-peterx@redhat.com>
 <aTWqvfYHWWMgKHPQ@nvidia.com>
 <aTnbf_dtwOo_gaVM@x1.local>
 <20251216144224.GE6079@nvidia.com>
 <aUGCPN2ngvWMG2Ta@x1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUGCPN2ngvWMG2Ta@x1.local>
X-ClientProxiedBy: BYAPR06CA0035.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::48) To CY1PR12MB9601.namprd12.prod.outlook.com
 (2603:10b6:930:107::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY1PR12MB9601:EE_|MN2PR12MB4237:EE_
X-MS-Office365-Filtering-Correlation-Id: 409d1458-100a-4390-bd3d-08de3cd5872c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jvrsH2I5aLMIlMtRmAYf2072t9mrSrUYP5WFKjk2EDjobNxCrya24sfky0l6?=
 =?us-ascii?Q?BqAhr3z2igEps5ws5dez1CVe3QZor5Kp2bON5XPtfx6ZhObFyPTd5++yagKI?=
 =?us-ascii?Q?H8Q9JoH3EgUYrN23trXGpjmi2O0e7KIZ8MbSnSWJAxh46SRnTrurKjZzL+mv?=
 =?us-ascii?Q?EL5VIG5f4rw6keO0y8JAguO6t+x2wcdFffU7DZDRmdbWR+u84K70gLiwA7gR?=
 =?us-ascii?Q?NnKgpe+nUY45K0kQ1vbAzt6q3eV4+ZtIG6cseXt56jSzFOB8B0ZSFCCXxmvw?=
 =?us-ascii?Q?x/mPZ8zX11Q7x/d5GJ8PUloZX7o4m7bsGlM3xXE1W/gArrkPUiw023sj8Q1+?=
 =?us-ascii?Q?rwjJqt92DCWQcgby6kRBibYG4FVwMUk6BbqBaGuESXLiO9YLSideOW0VuxmW?=
 =?us-ascii?Q?zJju0nB4Itdzkp6XKXekEY6QhwdPwD4lR+4KfE7VZiHMSfMR0mN9F9qMjIej?=
 =?us-ascii?Q?gteJQ8bo9zdfusWPaIuv64+MEEe9s9700wE5TyJzvzePdCEyPNPAjeKqmQos?=
 =?us-ascii?Q?HjQ2z0q5CsHWrjxi8FJP4dOA0qQ1uWvv0VZffWQBs+wBzgYPey0ZJvg4ygpR?=
 =?us-ascii?Q?UPMUdxRAb3dkkYh909ICv+ru/K4oDKw+bPj+g6wiFqIy8FfeQeaf1qt3yCwm?=
 =?us-ascii?Q?aP96VjyMjEfAQyCKvxk8Xmd+8nmzHmh73mxJf0NsOjjMl2BrsIzlULJYfFpD?=
 =?us-ascii?Q?vP2+ky0uoJRVmAmRdEuBfmiD3pbFdd408YANF73WhAmG+PWbrAKHcf/fakkM?=
 =?us-ascii?Q?vHx8nrH1mVnJKJ3fwnS0ycDcm6AoGWHVoDOpGrOHnaMD9boHdaxE3HWZIGlx?=
 =?us-ascii?Q?RnOfW6kB+WREhTWhbUzxMvUsaltkIygjjMSbYDG2mRv/BjGbmUhZ6V5TsfLk?=
 =?us-ascii?Q?4ggJDJZgOvR8arrC1+ZVI0mwVhwsgH3DTu/ktE57z3H2adkL639s2ZsXD/D+?=
 =?us-ascii?Q?mHrZ11d5A+tP6qH23bopAdxWqHzM8B8Zy8/uaz5DBzxxFoHbacqFplwf8BS8?=
 =?us-ascii?Q?oWWRv5H5WnaTBOizqaxJGSLBko5vtylWpwxO+TKruG74Zd/btKOAtBXxipIy?=
 =?us-ascii?Q?uFBPMM8R9x5nf5i8qLaSv/O7ZQIin8J7dXxR8gbOmjP+CUTqrn0XUrFhH6C9?=
 =?us-ascii?Q?xU0mTvkoTsTRoziGJTJ/37B7J4uJiv94vTo+s8Fn31Wthoo57MVZmBEM3CeQ?=
 =?us-ascii?Q?EFPoARz/RZD2QPk0j1ChJXREzpIP6R9euYIRw9c8C7hQbyNmTs0pUaaqJOYu?=
 =?us-ascii?Q?28nN5TMQm80kxOzCOyi+ivVVNkObBzYkUqivYReEaJehNsP4yQThaX7I0u6d?=
 =?us-ascii?Q?ELp3s5Vm0dWMJTPtQsjtnP4ydnhfzXbD/cpkNANDJsERUy7kvuEzkFY0NyTc?=
 =?us-ascii?Q?XorpkyfuLphDCtpDAyiIJTLKepO7yT840L6VPO+cJ2RUQJL1WaQgfDbO8YfX?=
 =?us-ascii?Q?kGWeJGM8u9KtpoG9SdWrXheOfgSq9qia?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY1PR12MB9601.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iokox01+gXIPf4wLk/Pe1wVBxwuW9TiGSWw43VG1kf7NlpPxs4uwNiEpWY+9?=
 =?us-ascii?Q?ZHNLd1x3PnWNnUxQ19lfhKxCd84LUTsjAme9qgiqr2UNOwRADDmoE2yTAnQW?=
 =?us-ascii?Q?k4tAKxnAAqJ6gcytH1KV5cULF5ysW8T2ChU8ZLFP9ObcaSDJowAo5INJpwUb?=
 =?us-ascii?Q?VssPYqmZ3f3h8vdQ+W/Bw74jDTymqqxoOKtiyY+pWMJ6zummIRwvykaNwTjo?=
 =?us-ascii?Q?rATxaeXihOS4vdbCSA34igHaoA+FOBQObwY2ZarqEVUf7EGVDwuoWD8OSkeo?=
 =?us-ascii?Q?TWsTf9NwjDHZK02LWezd8k/8Qy7GmX7lP0rQV25E5kv5uJBto2SdjafZ89l/?=
 =?us-ascii?Q?zc444SyH/1N5AAazQdc5SaqMW194waUCXwJNJjam3eodhW3HhDUG1ECVN59r?=
 =?us-ascii?Q?p0OHIyuuyvInCRIO+PsOtfCX11XGfcPR8Fw6JirTg3BziMHxkAiOGlHW8l+H?=
 =?us-ascii?Q?2+2J4faExEgf3rf5FHdirP4I2jZ/oVzjmNnnRJeFZXVSEnofV6Zy+vuqTN5l?=
 =?us-ascii?Q?5wT03u57TmTwpe6L8a8MjRzIb/zOSLLWXhVba4QXMwAit/qYxBCoRQKxc9GT?=
 =?us-ascii?Q?SNHa9tpZ24dfDTjJXVohVkyhpcI66p8c4zSB3lf/lFexZqfO2KmRDUAnD2Nm?=
 =?us-ascii?Q?BcpaW2qncBXqJyrHJ0hRyROku8qSpeMCyB6LZai3u3oVRz3aOJtHkgk6VU6a?=
 =?us-ascii?Q?oA6hSLcwbrOjQLNdxCUFaIGL7fMh3oEo9O71MrmgdH8Mx5+1hS1vZ7ckaihZ?=
 =?us-ascii?Q?2y8faWJDfwbiY//WW1RLpTqcCD2Na+SDqRvsbvXOBIrq7dQvwDQk2t5W80nn?=
 =?us-ascii?Q?AGjGRlmGEBtdkQIAd9fUMWz/1K/vVrsPcMZrStRlq65ftF4dKdHM3tHQN4Zu?=
 =?us-ascii?Q?CWoBp/EZaA4lQQNVNJednaJh/hfoVJPWLZ0hEi1JPe8pf3sz5EgWsFDHA0sw?=
 =?us-ascii?Q?NjjUY9Y/HQaLZ9BudaaeoGB/Ny80AmHiPHMK0xN5yHH6Kk48rCju5cEUR29V?=
 =?us-ascii?Q?UM+pldKyvB71hBPSujugpH/Wo7OatmG7K2bP/n+5b6azna8s/YWauXyvHS/C?=
 =?us-ascii?Q?zpo9OQuit4fNYIp2sypswf3ok4lZWwAA3W/hhkV4wWXnTM+YiGbqtSH8aTUK?=
 =?us-ascii?Q?gXfz9vlMuW5pcywbeIZuFgJJbsZgC8yThcnP2VmShOU+1wkHaD8xRQDkuv2I?=
 =?us-ascii?Q?Wf2f3Zwonwjm/gr5npbZRtaRBM4B53BEvFx7MNfUyFicfUf9zK/vF9zcvajd?=
 =?us-ascii?Q?Uxl1+JaYAjF9ElssyLhhEf8/iG1mJ+efEpgKXtebeypIofL4wtcB3zeLsMQe?=
 =?us-ascii?Q?uJF41Zboktx/Iee1vxl/D7Bj02/ekSoQthQYM4GP7/YIEh8T4jKE0VqzAcrh?=
 =?us-ascii?Q?u0zReVYKS3VcbQgkD4EmBEa3VuceaX75xrObEbcd9GWClKvlLmlRP6Y1eHJX?=
 =?us-ascii?Q?qRNNA1xB81oCvWpUN4p9OOebFf5Agui6/UFpldIeRw48B1bMvmn9spzkqyto?=
 =?us-ascii?Q?QSUba8R4061GYTknnB+oh+iHWgbmO3niHiyOQFz2tNOskq3vOT2hUxIXln37?=
 =?us-ascii?Q?/jCDn2XqS16y3dAFkq+vcc6zC8y9SbHqMX/YpEyN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 409d1458-100a-4390-bd3d-08de3cd5872c
X-MS-Exchange-CrossTenant-AuthSource: CY1PR12MB9601.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 19:01:32.8909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Adq0Hr1f1OFf5xiJa28eo7LrkbLr2xTZqNPv+zM/LAF5a0T2DXgGIo1QKEILh+nT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4237

On Tue, Dec 16, 2025 at 11:01:00AM -0500, Peter Xu wrote:
> Do we have any function that we can fetch the best mapping lower than a
> specific order?

I'm not aware of anything

> > None of this logic should be in drivers.
> 
> I still think it's the driver's decision to have its own macro controlling
> the huge pfnmap behavior.  I agree with you core mm can have it, I don't
> see it blocks the driver not returning huge order if huge pfnmap is turned
> off.  VFIO-PCI currently indeed only depends directly on global THP
> configs, but I don't see why it's strictly needed.  So I think it's fine if
> a driver (even if global THP enabled for pmd/pud) deselect huge pfnmap for
> other reasons, then here the order returned can still always be PSIZE for
> the driver.  It's really not a huge deal to me.

All these APIs should be around the idea that the driver just returns
what it has and the core mm places it into ptes. There is not a good
reason drivers should be overriding this logic or doing their own
thing.

> > Drivers shouldn't implement this alignment function without also
> > implementing huge fault, it is pointless. Don't see a reason to add
> > extra complexity.
> 
> It's not implementing the order hint without huge fault.  It's when both
> are turned off in a kernel config.. then the order hint (even from driver
> POV) shouldn't need to be reported.

No, it should still all be the same the core code just won't call the
function.

> I don't know why you have so strong feeling on having a config check in
> vfio-pci drivers is bad.

It is leaking MM details into drivers that should not be in drivers.

> I still think it's good to have it pairing with the same macro in
> huge_fault(),

It should not be there either.

Jason

