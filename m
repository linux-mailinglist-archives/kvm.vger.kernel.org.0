Return-Path: <kvm+bounces-24493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FB65956A9E
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 14:19:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E37F284137
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 12:19:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4EEE16B399;
	Mon, 19 Aug 2024 12:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="syzflwpO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2071.outbound.protection.outlook.com [40.107.223.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56ECC16A92D;
	Mon, 19 Aug 2024 12:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724069971; cv=fail; b=eEStZ5OqC3011R8P8h1dk8DZoWpLU5R/wtLaIVHIgv/H8NjDEOnYGC8usEqvfXvykYsiBZtx+e7UDTVhvWoF3LLFFzoxNkUTShTJGoQmiSZtzL9ahbzC4kfaaN5VdEmS0KdR3DnRQ22norMC2Y2dIueGTOrKk/X9BgFv48MlqJM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724069971; c=relaxed/simple;
	bh=PJfxMW0zjDw3au9LEf+PHQM/rUd+5+X4kZyP+vyKgqQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=S3SrQUmXjiycShMMcyFTOTeKNxbuReLU1e21wqW8Ut8WY8M1uhHvRKDtO9a/ee0zcLA+CRqMEMCeZEmoyjqlhEbUkT/uPYv28h7udxniwnP1xO6ERvRPCIuyQvHMkkaZ3zgC/xOmeLFEJY4GsbPT5vwIat+jRZLLEkw/RU+w/fg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=syzflwpO; arc=fail smtp.client-ip=40.107.223.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S31CeETiwj0wVwbgp86kNeH0l/p/Bd+ru3vOM7BjtvNGvm/TlMH/uUEsLlt+te0AMNX/LMpAyRUotaKCHgG4vCOIEozUfgTdNSHgzUD6VfceK0xwwQg65EJWBYKld2MkV/7dYzJT6W868t2pqqzQx52wtChxAPXLZhSnozWSx+gw4lOaAE+DNJskqQqGVpXQ2kH0m+DrUg0yK/bqTkrI46uYT3yzFPRVCfMKrRWCzAt+c3MetkTKCdib5W3f0V1skoabo4kxLtAiEkdwe3D00tWpbMD1ddlMXDT3sOac0N+gUA77j8Whywz5jt9V2y+woPi1CsTW1xF1onhxvEDUPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PJfxMW0zjDw3au9LEf+PHQM/rUd+5+X4kZyP+vyKgqQ=;
 b=QbpGB9wUP+zRYiFOl3uMbt632O2K+gBvEMoscmjJdLjp2WEPDyniEik4foY1Dak1M/15Wk69cXQfmoSTfFf6w40ny48OHuW5D8ozLY7ddhMEVhL8nnyftc9mN9cTe3lE5WNahtH4qnlBrO5qlpjvTTdriBDkBSeGN6nEKgFpIpY9FQt5UlMehuhBAh5QQvMmJDcPE0vyHNY31/924FCSux3+/Ah4HbvWuAXYrhKIemFRO+9YCb9BTvwOCkrI1TUCKuzyeP30m2kHwAZgT7CoSThZRwVci5HMkqb78FViCZjXr5ym2vxV8+oLODd1k2Ui0LR8EquSm9ssrU1lWXFIsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PJfxMW0zjDw3au9LEf+PHQM/rUd+5+X4kZyP+vyKgqQ=;
 b=syzflwpOazbiZCAiGiRTVfnHgQ1NH/16OxWZC1uRy7aHfxXBGb4HmvjmapA9YnovfUVXGjf0v+SpNXV5u1JwigCOsbzgQoMb8jXJaVOG7ALoiy1L87/Kv20wEyClNT8BxNKG/xJbnVpcSaZCb8sLx+R0Id70vmKq0nVKwAUT9DjnyKYVNn1QnNy1N729L761XKiLVqG1zAlLx9qmpFHr4Ux93Zb+0WUKN9zQ+RSHqiWlMcqMJaheSOxr10Zax74t+84Yy337GaPsGOsuaYdTrem0/RBQrMLU5hz8aV6VWPoCGL931iqAhFAjwFXRq+6n5SEpvMbNA8zGL6RHGzSWbQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by DM4PR12MB6566.namprd12.prod.outlook.com (2603:10b6:8:8d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Mon, 19 Aug
 2024 12:19:27 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.019; Mon, 19 Aug 2024
 12:19:27 +0000
Date: Mon, 19 Aug 2024 09:19:26 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
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
Message-ID: <20240819121926.GG2032816@nvidia.com>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240809160909.1023470-7-peterx@redhat.com>
 <b103edb7-c41b-4a5b-9d9f-9690c5b25eb7@redhat.com>
 <ZrZJqd8FBLU_GqFH@x1n>
 <d9d1b682-cf3c-4808-ba50-56c75a406dae@redhat.com>
 <20240814130525.GH2032816@nvidia.com>
 <81080764-7c94-463f-80d3-e3b2968ddf5f@redhat.com>
 <Zr9gXek8ScalQs33@x1n>
 <d311645d-9677-44ca-9d86-6d37f971082c@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d311645d-9677-44ca-9d86-6d37f971082c@redhat.com>
X-ClientProxiedBy: MN2PR15CA0038.namprd15.prod.outlook.com
 (2603:10b6:208:237::7) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|DM4PR12MB6566:EE_
X-MS-Office365-Filtering-Correlation-Id: f1ab3cf5-d2f7-41be-dea6-08dcc0492b47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?G48h6Hf2OSb0TMFFS9MgzsGYm0SnxxdGd0jR6bptKBq5QfQS3IYpAIhMKCKX?=
 =?us-ascii?Q?4VcPkqb8yaoTjmWaw5oEL11QCFmuCSEM2ZmdwDCOsZhKb80dUVdu2RNYj1Cr?=
 =?us-ascii?Q?F1+THopT3ak/CmEf+4qWytjmOibjnynpimmaUoNR7mUlvPA/YQbnHLDwrVYP?=
 =?us-ascii?Q?O12qRjEcIbBuck2ZZ8TwWH9DQmrSqHuayJxBSMau3riA2V5M5nXGYDLbKtH8?=
 =?us-ascii?Q?gROXuw5ZV4gDSVmYS/QJHBZZDAnJJSNcFrVgJtafVJTPPLGN65EdBgoH9A2P?=
 =?us-ascii?Q?CxFy/JPNjS+dX35O8mm5y0fbX7d1gGcQ1bjk8PlziINd1es9h0fzuPxuFDze?=
 =?us-ascii?Q?RHoHv6/7+zA0BrpbfRWx2bhcJr6eIuPhmCnNFS+a7jEszlDZdlazObMvyw9D?=
 =?us-ascii?Q?J6GSwy9UsrI+HvEgCE0fZPd4zGEiwYEBhut43tHPmCShyNqh0zCxW2/GHyhO?=
 =?us-ascii?Q?WFuxlHoMLSyl6SMYfWREmOpImpZsif0RO5wiVzSltDoWAU6QQklcIeJFtrjv?=
 =?us-ascii?Q?tpAwKnhXbUvAqZmS/4p3OY3SjEjKcYx2HPgPgqKhdaW4pT9EnSRTgd10SdYL?=
 =?us-ascii?Q?11h6ZLJCWJ79LykY/Y355Hi6qgjoFMl4YB1Q9HGDnikge2uVaaUIyvvhYLg4?=
 =?us-ascii?Q?sNLySAReSye9a9eIK6NmwV4NZlavtln3Mmyr3226aMhOsvEdRS9kxdm2PKwB?=
 =?us-ascii?Q?kk5HpILO5+9qfAwsRz+il3w7E2ub3p/fMBRMHW8ywhXJid/ifEaZyQViDqWg?=
 =?us-ascii?Q?s58jCezl8MO46nIiddbf8QIHIK9pWE+xfhjTKO6nJrAZoGiA8PRQ5ybPA6ZG?=
 =?us-ascii?Q?spCPlm2uiM7vUEtP00KIiAsa8jGDPCo3jRv+p2OKktawI3Kpwlsk3HKz3d5O?=
 =?us-ascii?Q?/y6qGOVWbn3n45Mm2RZp6q6MGygb6KpMl1msh5hjt3UGq8IgCoARuwKynZ1L?=
 =?us-ascii?Q?X6d3vjM6engAGKIBhgtEbX941vDeUDwBb0/3q5gY7LFaeAr8BzQ3zsxXHcOJ?=
 =?us-ascii?Q?GFew3chmOm16AIaLIifxXMzjmpzcOEH9wKEF4Rh6RVABPcH8dXKcmiMswNqW?=
 =?us-ascii?Q?CJntw6LFE8x9+94/Zkr1jqGgej6po7/pgNGK2eDlOqrLie8BWHFBoxWxUfXd?=
 =?us-ascii?Q?aO9cmjMDZuiIZYqs9mZDo1m73MtycpA9w83pEhJWKlhUAKjYr9GDw069WsAZ?=
 =?us-ascii?Q?vg532/UbjiJOkh26WyU0DUFm5D0vMSzXBO5uIR58M1XRny4LQNDkGQi5UuSc?=
 =?us-ascii?Q?w0wEhHT8o0oVmMC1VwVPB4IYyFNf71fhwkWaOqYbl/Bui3fv4FJt0lozg4vb?=
 =?us-ascii?Q?U+hqdj3mz7jqUmU8U4Y5GtuJntvJkvCGLig/RQfeRKXegw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BmVlZECIuBqiuKQOuuznqWiEkr31P3LYCiKLfgvu+krV3z3UlfcoHnDRhPiQ?=
 =?us-ascii?Q?bgpbXUr6CZnNV6UeuSrQCRFx00vgZy3sZL2h0u9ScApFZyjplu/NYh8VfbSP?=
 =?us-ascii?Q?ts0u/iU7xEMkuLWNMUMDk/dP7Z6fq9D6nTDMgYH9+1KgzDC72x0Nh4w2lzar?=
 =?us-ascii?Q?2XlI8VrrHMnOfvmJ9Dyssr11zkbu7QhpFEQC6/TJpbbf5peFGN/gPn8tBw12?=
 =?us-ascii?Q?qeR5adAs6lh/8TL1je9cFx1UW4PGYEi7xbj25JhLje+JFCu3+sY7TKyRfhGb?=
 =?us-ascii?Q?+5pIe7G+0yZ9rXMWwlME8ok3Bn0vqQbPJP8ukzVjz+imG2SVSEZ8nEINE+ME?=
 =?us-ascii?Q?QG6NZFK0ANnQRCtEnGuGSlES6wpB65G23zcXlwmbOx+AudM1Rzt8kRYgvc20?=
 =?us-ascii?Q?JJpD8dhBzQKDeq81YiC/Omu1+IbbJ8tSKyFyIaeMmaqdLfPIPkqtCp/HRtjV?=
 =?us-ascii?Q?pRcTGLwIvxo+2vZMDOltxgvMdaiMYdCPCuCDiYUHO6Lv8PdoGYdqQAbIraF7?=
 =?us-ascii?Q?TK5pKyG0XJZ0yVKEWS6baZTzTKPJFwidxBVQviCHIjb8Ic5o+Riz0d6yefhW?=
 =?us-ascii?Q?/pHgDPlsp3Bg008YcQadA56pdN8wfOx6iNMVO8LI6HTJOkeVlJRXmzrNPFL/?=
 =?us-ascii?Q?5+dz2LnUdZlqLPfYAK5kqxqPjONF1Hhp8qfjCEwZ4pd89QDZ/5T0m/lIa0bK?=
 =?us-ascii?Q?MYrWs3q+a53bFwTmsZnqgt+2/Z5grtf8cCrez9AR4EH1GBbF/21zf2MxAj6f?=
 =?us-ascii?Q?rf0gJ2YFYFuGOArtuVXWeHxdQV2ftV2upeC6CF8f62J3iQiWXFjOZqvqrP9f?=
 =?us-ascii?Q?FM7xzJO65gbTw5U4HrFuY29QJLX8QjquGVU5lE076KEL/xgxdMc16Jzs03PH?=
 =?us-ascii?Q?V+v+UuoAAZ5HnZkN7F4AEwd5oiQXmPI5aDlMuEbQ0Ln8YKAgn/sYFHLm6Ar1?=
 =?us-ascii?Q?dpXruYQ3/DfhjOEfVSdgtzQn/jiwIom2TqPfj7abDJ2NeIicw33JHSSPjOAD?=
 =?us-ascii?Q?mmkDMbYg6AbS4otJHWyftflmE3pltfoNCQthUkO9KnL86b+bEf78tvVvRT1k?=
 =?us-ascii?Q?gYMo2Psxq03VNmPX/4HKATpzDhh3Isrc7vYQABkR09soxNsMS+fUkYfKhdLW?=
 =?us-ascii?Q?V90lcMms9jyAcdM/468MOgAaN/RVYbSyv2/Kn1FTyzkJa0jDQ6OhtrAz6rAm?=
 =?us-ascii?Q?Y+kN+7lmWBk8nqIsUwaWKflrHmYI8eDpUbIQutXXLTaO2/RLdKuQcFRso1H/?=
 =?us-ascii?Q?hYtL7uAsPyML6N+BGhV46yxAraovSvYvPt9/Vmas7t/u1BMZsv/pWkUHjcrG?=
 =?us-ascii?Q?7KdraoAaT+jajbYaNmebadw1Wmu0TEc4ABVJvmOkgrz69ihF/WtDr3tAK+S9?=
 =?us-ascii?Q?TZGO+DrtBvM3FOBQCoNt+RXiJI15lzzQlSovPQzFYKvkc4yTthsBuj5pGsX6?=
 =?us-ascii?Q?PvtscUUKTceuGge7y4/fz5hK6rGhBfAgMz6OONIfPQHmlG3Ke34eawCxk/la?=
 =?us-ascii?Q?3fHNTT6MFLe1rNT03gzpJfw6vKq3jIdrff9MnDkPE0RMqKgDvXDxLg2JK17G?=
 =?us-ascii?Q?qLO0y5kTpUoe5BFJbZ/17uSDZAyU1BYM/fjrp87y?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1ab3cf5-d2f7-41be-dea6-08dcc0492b47
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2024 12:19:27.2687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KcTMWaponkF7OcqKeyMdei5uhfE/K2+Bi9OxFJtjDU51YIBDQLbm12ek/QOQoTw4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6566

On Fri, Aug 16, 2024 at 07:56:30PM +0200, David Hildenbrand wrote:

> I think KVM does something nasty: if it something with a "struct page", and
> it's not PageReserved, it would take a reference (if I get
> kvm_pfn_to_refcounted_page()) independent if it's a "normal" or "not normal"
> page -- it essentially ignores the vm_normal_page() information in the page
> tables ...

Oh that's nasty. Nothing should be upgrading the output of the follow
functions to refcounted. That's what GUP is for.

And PFNMAP pages, even if they have struct pages for some reason,
should *NEVER* be refcounted because they are in a PFNMAP VMA. That is
completely against the whole point :\ If they could be safely
refcounted then it would be a MIXEDMAP.

Jason

