Return-Path: <kvm+bounces-24406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C66EB955020
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 19:40:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 57DD4B22C65
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 17:40:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CF991C2338;
	Fri, 16 Aug 2024 17:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ij5wn8oH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2087.outbound.protection.outlook.com [40.107.244.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0DDC1AC8BE;
	Fri, 16 Aug 2024 17:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723830039; cv=fail; b=jwdCIfuqOmGWIDIVNZYyZ/ALf+Y2D6jkz3HH5MPmeyVJVwzbBaX+dJnBJhc6SvavDP3hMt/pIOyaSK/12W44Dv6PJIMd4F6fNLM3hj402QowhiU3hJtnUg5jFjN2CQ3E/tVi/8kV4dpDnU4ydD4gYTDJwLmQKqoBMIZ2mYxmS4Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723830039; c=relaxed/simple;
	bh=qw2Trbhg7WraKQc4Ffmr4xjpPzu2WZ/tG5DvOLdY2V8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=K22WYRg3X72adtUrb+46b1OnvyFn7CO6JRU6vZWNrdsGfeY/KSpvkkDAkoqOgXw6hiQHRkSDrWtthQ1KNVqKYXXrdnstuZpa5QJHH0wdlIfSnHs94gY2hSCld66wAqXxrNA77gOREPE2wy8FFnLEs59909xGzZmGeqC4q/8pf88=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ij5wn8oH; arc=fail smtp.client-ip=40.107.244.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OR7kxfXYB1BqCc615CRmS91cToqoDzEsIzVvm2lWJjl7Qi6Uw/19i/Vibi8y78BNYaeH/+sevYyrY1/y4QJ7bboUXxv43bc04Kf+RIrnkiGW2rKwOSvOtmNi/WIC9UGln4AKmAt8pyhyFSMigpUPzkxGRgGHrCDmB9BqDb8wfRkqOZ57YHDAQpQ/eHhYGAgtXNm4V5cxTujWfaUm+2SHP+CoE2NrHzxsdyqrYK3dRy9yIa2hWH5kNA1Y2O6OdsuTm2T8zFEwK9UYQ/GqsLlSJAODANdAXhpYuDsHsFMia/5XTV2hJi9hEX+CQZBoNgwybSkuUNHxEBPAPaSzfl08Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4umQplemR+89QkBubgfFWDypoBLwNYMly4mIsImuFms=;
 b=SKd4ksEDKVOauUr1SPwAdWDPvUsutexdFdcKHWyqb2WYgiaygk7GDlAzNgOo+3AlgGp0dbxi/2CaW8LDk3UuCZ/vIsYmy7VIYZPSTr9wBl7R1qQYyuiZNk4GZp2Q9K5MiFjOls/goXkTw/LclPiAXLUEimrhJs+32T8lngdYqXzeMwhiNCRgQCTTHPVoHVmgqBqiZwdCZRiHYK34PEPzeXGgHB5f+1q9bj00HwBMbCU5ufhNl4NqHWSicIWyyRCEapx4gGXvMIllKlaPD7OkcSsLpnxNX6LClqHMuc/wOftpNdoIzFQbXPEGZswf3/QC3MlcFKuS1EWRzid2AunRaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4umQplemR+89QkBubgfFWDypoBLwNYMly4mIsImuFms=;
 b=Ij5wn8oHXvOwQQEGezUhdrkaXxXiuiX4rfMXJUKGgqmTXzuAjny3rbVCEb21SzgL9Cd2bQbXkdnLZ/fhXXnflYmBqnB/54Lcjc7LOTElfBwZEoCrRza38sxxdN4DN4TSXMVwZi+KOcEyp8AbHulWxHlnqMcO65kpfSN/H3BFIBikxMIsCHj00Xu6E+m50fd83tTObH0+K7buaJTpFQ2h5n1MGp4YV24YGUeMGhY0qqS8eJumr0gB1takFmMCw+etqtdEKp6RM4u17ztW7sC9DAm1PwKBseVZir9hvanlyvG6HuUTf+0xVSdaPF1MomNTlKZRvNph3m1ORc4ozV1X1g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SA3PR12MB7999.namprd12.prod.outlook.com (2603:10b6:806:312::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.18; Fri, 16 Aug
 2024 17:40:34 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.016; Fri, 16 Aug 2024
 17:40:34 +0000
Date: Fri, 16 Aug 2024 14:38:36 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org,
	Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: Re: [PATCH 06/19] mm/pagewalk: Check pfnmap early for
 folio_walk_start()
Message-ID: <20240816173836.GD2032816@nvidia.com>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240809160909.1023470-7-peterx@redhat.com>
 <b103edb7-c41b-4a5b-9d9f-9690c5b25eb7@redhat.com>
 <ZrZJqd8FBLU_GqFH@x1n>
 <d9d1b682-cf3c-4808-ba50-56c75a406dae@redhat.com>
 <20240814130525.GH2032816@nvidia.com>
 <81080764-7c94-463f-80d3-e3b2968ddf5f@redhat.com>
 <Zr9gXek8ScalQs33@x1n>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zr9gXek8ScalQs33@x1n>
X-ClientProxiedBy: BL1PR13CA0313.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::18) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SA3PR12MB7999:EE_
X-MS-Office365-Filtering-Correlation-Id: 83cea4f6-1379-4297-658c-08dcbe1a87aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?X5VdMg5FAoHB/OZkF5IU3W/u/dUwwr4NG2/lgmfK7shSIFMALGeYoF9Ga+gd?=
 =?us-ascii?Q?1S+5vHraqnC65lncEzAxnCLD+X8R/BoRc3tuoSimGAKOheijKxd4N6kqnaU7?=
 =?us-ascii?Q?UBs8z08+eu8SsaLD1QAeuIUBagPGFWu8ZaTPNXfZn8Q0ECXCsPkP9drv00PM?=
 =?us-ascii?Q?uQ7wJJXl3iECp5zs0Zb+nxvx0Lxw0CTeFIX+TwTEEWRH6DSMTAcTGRijWMln?=
 =?us-ascii?Q?ba39bd5uydxV6a/NhC1zhcWbIb896Iea0xisbRCO5ruX3o6a1P48FOcZGKf1?=
 =?us-ascii?Q?5iZ2Yw1KJCTFL/ss+9fM8xiOHvAdnMrq1ph9XqhTxK/ZmRJAs7qGInb28hq3?=
 =?us-ascii?Q?4Vu/e3Cpm64tFhOCpm2I8/Ok99vKF7ybgUi5zQA0R8HLXb2C4IR4kxhWtEG5?=
 =?us-ascii?Q?jzM3/yDuO5LPVuY9d3tEkas1IwVjnK40kvtT0NC6SlOYTpn+LNVlKBOS6cwW?=
 =?us-ascii?Q?UTi0K0ly+nTDOJWRXJ9p5bqbdYSMf1L3iXm9BqDTODdvtLhY1tlJ9LbdgF0l?=
 =?us-ascii?Q?OxWXinYDh3k2f0jrtosaZgjqKrC2+D8c9gCgmt9peqkqUWvXHpvA5bUSKglE?=
 =?us-ascii?Q?pJCbD4GoLVSUgV+n+NErKSDHWFuzkdHTC4alaW8CX/HR6BTCPHaRIq0SpmWN?=
 =?us-ascii?Q?KbB9Lxut/xzT6I3/DgmQiHhUrerOKH+XGogrvZw7BD75FMcxRdc0n4TXTBtu?=
 =?us-ascii?Q?cx6Heen2iMcLE3l4IE2Yya3kBvNt2OkFTog/UfLjbee6kFsojwTxTahz1K7k?=
 =?us-ascii?Q?IGwqm2pnjQ5fZNvtej2ugh9ezCQvHKxXSnIpzWRXVJbUsBc3rtP4XVhGBCMc?=
 =?us-ascii?Q?bQHrhwTrHl6khZLcilJ7ozjvgTQvQooR+fTzpKAkv0HFG9aRxkk+JSVSYAIS?=
 =?us-ascii?Q?eIey3grKGsjsrwpTTD6hvXweAumsW/k1SWhOvrJNTKchxUpnuLRShf4LoPEf?=
 =?us-ascii?Q?kDefxj5b5YCKvb5Ce9o7jWUAFEHFBaMQADyuLUO4p35EGszcziUDw1x7eLnv?=
 =?us-ascii?Q?duciLNHiuzDbofg+tuaI6TDBjVZAS5/yfpmQiQRFGYoMN3rR+1QAiP2go9Ye?=
 =?us-ascii?Q?xeLRjTz6vhAMRUH01ONwaPsZrdnRmyGX7kaTFg6p/qQ0EfFZQY68fdjM0Qzq?=
 =?us-ascii?Q?2wyI+7XneCZia5dnipSvC/TwqoZdDtaaf9H2IJbiwIfxebUOYN7U/78rwqN2?=
 =?us-ascii?Q?0kFX8R3o424knwjs+yY9URcnsRfaF18EnUjmbP8fkoNKmRHecsvKVUi2xpi2?=
 =?us-ascii?Q?9rvgI/9tx8uMfu9flWw0GYQR4t/pihquYIiUrcqHJU6nJK6IXNK27Io1qZgV?=
 =?us-ascii?Q?DYaD50btG6LhMyvs1P+pxqCt68E9QDa6Qi5odxxqQ4t6cA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QgLMkzXsx3YmQOkN5aavPWbfczSBEzRQmSL/FR2YVJKRj5eiCmVXizsdp9rT?=
 =?us-ascii?Q?Pqnebk8oZ+o9sEfVP33OpB9+M2TVdAF3Fw3p6UzNmRtfNbArvclc4zRHGvyC?=
 =?us-ascii?Q?FbEeNrd7mzU6YD1vYTQtkOmdmHlHHNQYFdvVBwWe/lCktvHZ58xwnR/dGOFl?=
 =?us-ascii?Q?xT1RBa9BjPTm4n5q+aa9WU/jhvTspOwJ8i2qXdWNDokfOBl5XmQ1gjkUDe4g?=
 =?us-ascii?Q?6BZ1J1eg914Z9u3fBAqExHFWtYqlGRbwnU0DompsOFViOxcRzspZV/Rl03Fz?=
 =?us-ascii?Q?3geMwTkW03QdlMhcvR1Xr+WaFpk3xnCBtlNLQCblQh+0LoZoeiH9F0YhCs7J?=
 =?us-ascii?Q?J/CtYNysgFzccdpWGoL98nA4GPluoXb19aG79AMROW6HkjRbZMsFFogJ0xTR?=
 =?us-ascii?Q?BPxmFfeL3f0WQHq6qA1U7u+5G861MWzG2c9B5PZMcAItM9iGi1cGM7EjLnOi?=
 =?us-ascii?Q?eeX9LtKJNdK39p12Gd2ys4dBAlZiS5un1eTrjRLbyjeKYnFvEcpXmrbaGnqp?=
 =?us-ascii?Q?NGKmnDFkxBaDn81hCCB4w0a/bN6Qgm2wGPIauKZXXEj9QJI/s1ISFRoZxnhx?=
 =?us-ascii?Q?SnHrWUKTljytiSueVZt2WM617OZnYCdVOo+DseOlh2esRuJfsYcMBcSp8vMo?=
 =?us-ascii?Q?mSmit7MrdLmrN4HSgbRM5sYMGIJyVigPThonNCQDYRVVoHYf6YBtHqhcvgyZ?=
 =?us-ascii?Q?95yP/B/l3AeM56+G4MyCN5z/8Vk8eTrRZh+llKTB8/B7o9jxvZ4c8aQbarkF?=
 =?us-ascii?Q?4a4gwls2EY9/IILT1ynqNwGqrLx0cuQ9ZGyU+h/FizDDzeTL98ib0QM+oNaK?=
 =?us-ascii?Q?ZSzHBx5/kH2Sl0y9+FrBXUiwDkg/wg9EZ/hVf45VCz6V/3F8qiSOG6JRR00t?=
 =?us-ascii?Q?nywGGtxFvuOUm5HKA1E+hRaptJYE1KYB/ioMGKF2c5tttWd7A7lRm6853bOq?=
 =?us-ascii?Q?GUwc3XuYYAfJ/ZDr8Eqyt7ofZ36hgcbeOJO4xZIWMHOtZZCV5psLTJ54tHti?=
 =?us-ascii?Q?NWnjr+ifE3f9cM7614VJi/9IkZqLISyD6NacQpyW6Op4qFj8vA6HNl7i3r0Z?=
 =?us-ascii?Q?F1NZZyxwvRYsizuHtlm1rkk3DhXbQKiXw2KhSwFKmcWzX5ZcbkW+oHZHNl2f?=
 =?us-ascii?Q?fMsQPuO61EXwSaBp3+CeFDCIsT1p43GR5IrWV7Imn18bqL5cmg+RWY94rP6x?=
 =?us-ascii?Q?soKYF+7lOI7lSxVpaF8F2rIw4q2yflgDK+JD7OiyYQginunfyBrrkndjBCBS?=
 =?us-ascii?Q?zuXaxU5bfeuLir4fBrWgled0rq092p30qUBfKY4LANTw7/NQyAVyS80sXJRZ?=
 =?us-ascii?Q?05tbqhTaJ1XgMmlHDi7y9sn/67a8Zh6ObCQXcGCrKMTDxiZeqLmPlQzzRi3S?=
 =?us-ascii?Q?MWrgcByU/tikTgDP5f0cBE0Y4dfJa3iLY3VQKGgFJf+YtcHvUD1iNiFNquKD?=
 =?us-ascii?Q?PPxF+7GSNOqHTIi4TPLknFkTJIjFqGjzpG4mAn/wWAVKG3/GFRITOBHlzHne?=
 =?us-ascii?Q?c2DNN8lnxfGysIWhphzPTbAoUS1bMchGER38kCkhbG/frWvtPPam0VDuOAji?=
 =?us-ascii?Q?R1XYDyuJdORsFe/5+rE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83cea4f6-1379-4297-658c-08dcbe1a87aa
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2024 17:40:33.5374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xa0b7PwddHG7ZSB0PEHL7Nwu6RhBKqJo61vX41BFaU3Zhn6x2Wl89U1F7v55UDQP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7999

On Fri, Aug 16, 2024 at 10:21:17AM -0400, Peter Xu wrote:
> On Fri, Aug 16, 2024 at 11:30:31AM +0200, David Hildenbrand wrote:
> > On 14.08.24 15:05, Jason Gunthorpe wrote:
> > > On Fri, Aug 09, 2024 at 07:25:36PM +0200, David Hildenbrand wrote:
> > > 
> > > > > > That is in general not what we want, and we still have some places that
> > > > > > wrongly hard-code that behavior.
> > > > > > 
> > > > > > In a MAP_PRIVATE mapping you might have anon pages that we can happily walk.
> > > > > > 
> > > > > > vm_normal_page() / vm_normal_page_pmd() [and as commented as a TODO,
> > > > > > vm_normal_page_pud()] should be able to identify PFN maps and reject them,
> > > > > > no?
> > > > > 
> > > > > Yep, I think we can also rely on special bit.
> > > 
> > > It is more than just relying on the special bit..
> > > 
> > > VM_PFNMAP/VM_MIXEDMAP should really only be used inside
> > > vm_normal_page() because thay are, effectively, support for a limited
> > > emulation of the special bit on arches that don't have them. There are
> > > a bunch of weird rules that are used to try and make that work
> > > properly that have to be followed.
> > > 
> > > On arches with the sepcial bit they should possibly never be checked
> > > since the special bit does everything you need.
> > > 
> > > Arguably any place reading those flags out side of vm_normal_page/etc
> > > is suspect.
> > 
> > IIUC, your opinion matches mine: VM_PFNMAP/VM_MIXEDMAP and pte_special()/...
> > usage should be limited to vm_normal_page/vm_normal_page_pmd/ ... of course,
> > GUP-fast is special (one of the reason for "pte_special()" and friends after
> > all).
> 
> The issue is at least GUP currently doesn't work with pfnmaps, while
> there're potentially users who wants to be able to work on both page +
> !page use cases.  Besides access_process_vm(), KVM also uses similar thing,
> and maybe more; these all seem to be valid use case of reference the vma
> flags for PFNMAP and such, so they can identify "it's pfnmap" or more
> generic issues like "permission check error on pgtable".

Why are those valid compared with calling vm_normal_page() per-page
instead?

What reason is there to not do something based only on the PFNMAP
flag?

Jason

