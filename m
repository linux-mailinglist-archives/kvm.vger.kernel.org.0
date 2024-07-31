Return-Path: <kvm+bounces-22716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 50098942408
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 03:03:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BEDCE1F21C47
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 01:03:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 397B4947A;
	Wed, 31 Jul 2024 01:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cZAiBBHA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9853A8BE0;
	Wed, 31 Jul 2024 01:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722387807; cv=fail; b=cwAYpIoX5eCHmuQXHmyegHbGH74dAeTe4xvFXa1kmyDQbEgcr/gBD7DwQzei+ZoRtV7uSZfQlDQrja0TpddUEVx3sDoscfn6kkdgk4GxGidUaRpOhSyzim5gnIdyW+mvIqb+hkXbh74QfcLh5N5njYPctGU7MuBQ3OP3tbF46Dk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722387807; c=relaxed/simple;
	bh=xVLCK8UW3pQV51EkbWdXUjYI1sWZVxUF7qODVlNZdwQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=d/x3vOaCKEXSIC0xc7kY4EzzXUxrQyp0pAeqHUp3lPJx2PKcCul8yQ1DMhUNvPnueM/hK1pcJxYeC1erVtOgYyIscDoRbOh9KP7c7n3zjmlxAAHcR8fwS+8i6izlsur3ZsspqUoTTpvpwtVNId3hv6PlWaLg4NXcFGqnIkBofpc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cZAiBBHA; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722387805; x=1753923805;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=xVLCK8UW3pQV51EkbWdXUjYI1sWZVxUF7qODVlNZdwQ=;
  b=cZAiBBHAuw+0ngEc4Ez2cN1gjdXlMyonqMcbu1ub6vNAG05U9XO8L7Iv
   nDPGkU/77yrMdsf4BKan9d+Bv76Sz9TxgUooDRqDkkitoM1ojn8j3GQZc
   eh577K2O/Pa5FKxlrLq7oVUGTSFbcZwytb38cI5XQFex65B9zlTCMTXvR
   cVs+h9xVhszpnERrRHbneNnw72q2htsmszzyyPh7XVCYuvSFoqiqGcC9z
   ehujXDxRXRrC15D4av+OIMGBrcOQ9nYpx3YSJ0V2NIRh0pU17JXoLcQYM
   l+S9WfxVLl1MxEnXMH8Y2xfLHpLz7xn07SPhdUrOo9KjNwtbtHWNjTrUF
   g==;
X-CSE-ConnectionGUID: LV9ogCGAReGl3ZBvwRSgmg==
X-CSE-MsgGUID: g9M0+MOZTK2+GnKwWc0PHw==
X-IronPort-AV: E=McAfee;i="6700,10204,11149"; a="37753889"
X-IronPort-AV: E=Sophos;i="6.09,250,1716274800"; 
   d="scan'208";a="37753889"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2024 18:03:24 -0700
X-CSE-ConnectionGUID: /JRZ/cDBRZqz+CAIIFvgXQ==
X-CSE-MsgGUID: 4JSHzPGARUGpRvNBeDhE1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,250,1716274800"; 
   d="scan'208";a="54559373"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Jul 2024 18:03:23 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 30 Jul 2024 18:03:23 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 30 Jul 2024 18:03:23 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 30 Jul 2024 18:03:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=twAVIu8RKZrrIbd3KzfL6ctHsC+qcKzKG4YuavGkNLc7tI3J208NpE4PFmvGE+HywQBxvSmTuPoCpD7MK4hcSQgnPzt3VFVblLM7V006RpPDngb8xcJdrbs5bA0GMyMjsPUSGy3ce5P1Ku/Ad6nGxGue/MrQz67IddO8jbP33ysu73IHPnDTvtvTcnoqL0d5xuq1Ffm67CpWY8HyBpNZHzpvDHgBXKGTp7kBkp33fxp2xzeaM5NCLvcZUK3imAj/Glicgr+jbRBMPzLswj6eDy+1pjmdzZEiP4O5jEHrqsIu+/To4+eH+Jo955F8788dRot45XU3A5DkkLyZLbVsyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=spnM0nVx5Pwu2GAyr6rS0Cm6vQiQm9hcGCo8tRdp7ro=;
 b=ypesmWgoYhr+gf1STxdWqaKU/1KZOt8q1MSIu/69H/MsSUuTmSB2ZSudXtbbwhiNOeBlD8y4b+Sxtt375S7VkStwzZTqwcHhhAfrVjLLqbs/1BlWhJ9prMpvX+nfJyHPr66Hj6YY/xgEXs+2RWKTs2zmT+xJ5W0a33J9Kwef04mYUluAwaHcGnU4rwIX+8RkR7+d8gob/xkzhYn26rMxYeqsVMfXKXClT2ApCIL5kmtgqiKkgJfPVSyl8/ZrC5HyvGHoqKaiyWH1jG/muwX/bPErnJ5oKca2tIwY+f8+FzUZtWNFdvAICu04ntCIWentk3Fld0nBkStwcZcJuNYlqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CH3PR11MB8239.namprd11.prod.outlook.com (2603:10b6:610:156::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.28; Wed, 31 Jul
 2024 01:03:21 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%6]) with mapi id 15.20.7807.026; Wed, 31 Jul 2024
 01:03:21 +0000
Date: Wed, 31 Jul 2024 09:03:10 +0800
From: Chao Gao <chao.gao@intel.com>
To: Suleiman Souhlal <ssouhlal@freebsd.org>
CC: Suleiman Souhlal <suleiman@google.com>, Sean Christopherson
	<seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: Include host suspended time in steal time.
Message-ID: <ZqmNTl8KrjpfsRuR@chao-email>
References: <20240710074410.770409-1-suleiman@google.com>
 <ZqhPVnmD7XwFPHtW@chao-email>
 <Zqi2RJKp8JxSedOI@freefall.freebsd.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Zqi2RJKp8JxSedOI@freefall.freebsd.org>
X-ClientProxiedBy: SI2PR01CA0024.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::20) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CH3PR11MB8239:EE_
X-MS-Office365-Filtering-Correlation-Id: 343dddad-3297-460c-d918-08dcb0fc9244
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?yHQzfEtyNsxF9oh7+KLfYZPmfozLavHKNSsCRqsnaUZljeqrRGzJZ43NUPF6?=
 =?us-ascii?Q?C2iKPjMRyuKM+QP5XilyB/Hv7VQMbdLjNSxaW+XGVSC/ApBnru+jpDKhIUGS?=
 =?us-ascii?Q?U1j542kosUlZ73iEkZt0+zujhOozrXVjAwX6EbO3+hNHyoF0k9zBOGn6YY6Y?=
 =?us-ascii?Q?j0clKrIymAGiW2202RzuIkqRgJlkrWffDTwEwBL3qZoVDxsGkLak3LwaBnbX?=
 =?us-ascii?Q?1xJjHZX4cGWhWaGJMS2axhcTmPq6CM0xbj/HhDme1EM/k7ZwRYiljq283CQF?=
 =?us-ascii?Q?3aEEXC2wKiH88VqwKSB0PUFuL3CIeoz7buqdcLdmkd27CUUOnN3F63oEcweI?=
 =?us-ascii?Q?O1Cfn5ediOudVOPJ2yTdh0EpHpr/3ZC8khCEvc+lltL5FgUNCpIq3K1HNyPn?=
 =?us-ascii?Q?S//v97hHmYYnVArCIXZGtnqjyxflLQ3Ug6wamuwOu2F72ew/SCWMqI9UoS/V?=
 =?us-ascii?Q?S1pDMTQPovgsj5qyyse2J6U5pUorphwBYuRq0Gjg3TEka3NpIKFAEOsmx5Mw?=
 =?us-ascii?Q?ftfrcrNu9Yadw9vwISmXROAFaKJEqxWOuPcA2iqBy4vp7muqsKCohx1VY+Ax?=
 =?us-ascii?Q?CjDnNDUBzEb5vKajb05vDI3DtnM87Unnd1Dzp0JRoZ2B5rNrcF0ML6GBILW6?=
 =?us-ascii?Q?iQMfWWZSsCbcqN0t3KtPOA/gJQxK1urrGRseStovZo9EewiNlhaplTtJF6gS?=
 =?us-ascii?Q?5s+omX30SK1rVY1mvnnoMJywOAFNqrdSZnCOgFeVnbLRygBdt8eMpjme/7A8?=
 =?us-ascii?Q?PFfvSIRvBaf61MM7slb50/oG29WhajYngaO3AQ4v8u5DFmx4b8qMwJHKKMVZ?=
 =?us-ascii?Q?cIvB42CDxkv9LSpqyTRbe+JmFp7GCfXcLu7rWWYkfbX9w7NoZd/XkesQDus1?=
 =?us-ascii?Q?xRUKZMzTDLnsJ+uHIjpkjfBa0kH16iD5vqe+1bpxDFwRT2vsWEdqPbK1PAJK?=
 =?us-ascii?Q?Tjnr2TPuEWoQAVCVhW8cZIHKxu1kPbPLwu/oGQoRXB51JXk3kD8vT6yMpgRl?=
 =?us-ascii?Q?7bnyVgeYDnwH0z4omvDXQX9mgnUqV81BBGHOy7aezBi0sbF4bvQYBrGozmeW?=
 =?us-ascii?Q?GuZSuHlNyvfQSakf9gW28+kEUguFBYNB2m7BQZHfJRXYv7xPoBsoFhzAdqiH?=
 =?us-ascii?Q?z+QuFuKodV9Q4EgEcR6bMSDgWiBaNoFIMWAWwlDy2iRfVAljU6s6Pn2NiSmu?=
 =?us-ascii?Q?t5ynPAnaL79W+vwZP5vm8WD6Vax4A34PbqrVqL/T5bJqHYYNr+4DF1WA+4J0?=
 =?us-ascii?Q?v3Df2TlJI+aewAIR0q+rqfsfCzV17i4ncf+VhXkus86QpJ6ORr6JKH+0IwOW?=
 =?us-ascii?Q?xG+yCUF30uHjJEcdxFW9nBsTnYDOJe8+gUWCLv+aYkbDow=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+bIPELgYMG62efx7rxtmJOx/270BtIoNss2RWk57Z2RYLwQXwQtSCdIIVez/?=
 =?us-ascii?Q?8mZroxa8DR8kRYa7fblcBIqEQkPvOIvChGApj/tTzB9drcmxpgj3LryOWkOl?=
 =?us-ascii?Q?T6iZMw8aNiD5AXoU+cy6Vx+QqywvJSnX7qT/H3/KbrfFYzzMqX6gFLvSfEYi?=
 =?us-ascii?Q?WHLeybxGmZyMu705XNpij6M51xCc5qIOakHPU45EYpLRevUVuHk6Dfql5fBN?=
 =?us-ascii?Q?MjoaDtRhegBwZQUQ+iXcQtSw43pZxDVFL80Dvf817ZUqOL8Uu0A8CaFA6Goi?=
 =?us-ascii?Q?a2HgpPtW43AWIpp7sPNhyFD7E6aDhJJvILSNDvBqsNQSQSnGXZhHKpWuX+Vi?=
 =?us-ascii?Q?E1VRsUlk3Oig1uCZarqI+mXWa1sv+c01i29cBR2J2qxj4oso0KsAllCa2qbt?=
 =?us-ascii?Q?+NziAKozFI2uz03dVODmHw4C7QBITRq6aymQxCpauddgalDb9H16JA/151gZ?=
 =?us-ascii?Q?KZI/ty5CIlwO7coSpytoVPb0oOWryETH6Kbfo9B/Aq0rde/GPB6dxbgo4ELo?=
 =?us-ascii?Q?K3tTejr3sLXsGH6k98KQzi0QBSaaeSGyfw45NGj47oW52JTD9BYqzWqFavR+?=
 =?us-ascii?Q?XdH3a43zqZQUC1uqQvGGgOZ7p8G5iWSY1Sw8kBLF6kVyq992egmZKPAsKarH?=
 =?us-ascii?Q?TEi6pvBV4cyFpV7sy89LGEpRoYl9x1qMxOTAM8+vu17bNb5r+zFQr+pGlUpk?=
 =?us-ascii?Q?GsQ8WojV6ZG27+Fh3HN2XlC1nyNvYYlksVtH4+AK2VJt69skrXbEHlc42MEr?=
 =?us-ascii?Q?JiJDA+AOnmxsDD3ORdtLe7jGjinUCEYaSLy1cgdDpglvqaGm1ttaDVXTNVFb?=
 =?us-ascii?Q?ZcNK9gH3BDqAT6uWdOTl9qNnCEdkilZuJSmyciSWOD1hc/VAFt7Qy85mjSnj?=
 =?us-ascii?Q?hrnRfZ9bZrzYvXYDoTM/TgEx6ZQ4DO5JM3gn8/IjSu+oSshorRfC38AJw8Is?=
 =?us-ascii?Q?LebqWT6ma/BzeYu3ejDqjaqlQIPUGdhNmsLt3hblonMwlfCfGBju1zMIooQ3?=
 =?us-ascii?Q?vFApPcnmyGDiYaqUchq95tixBQ39de8nqOFjBLx3nHEE4uRGp/q3apDoEeQ5?=
 =?us-ascii?Q?TLPInfNhOmgCwyYPKGEvWE2NQ1IOZ9prgRB3GKfnTvWHepE0uf3///BZPe8+?=
 =?us-ascii?Q?PG3ZxQbjifsXIszbk68/QObFNrwfNbgGlhrc9Uyt9iRs8sWbZ7mWseO/yWoZ?=
 =?us-ascii?Q?6DbjgvoEbgfqUoI+LJc+kXCJqVH63Tis61E4r4nZGScPhflGw/pAolrEwAX0?=
 =?us-ascii?Q?tGf16pYZJTk9gJs4sUSRXpvSviU9d1/wzpWjsRvyyGL1xqiE6MgFs2LhrC1F?=
 =?us-ascii?Q?cGHEVb7iU7w69XIZEmEUJCzvvn6BPl9GBVdlUmA0PWAwXttxiyyFVW41k0NY?=
 =?us-ascii?Q?74Q3n/BLhKsJRWliT5kWQYbiRQ/3B/MyW07bPFj5kaLKvD4Iq1MyvhAl4TEc?=
 =?us-ascii?Q?LAQ2UN90G7Euf61JomaUdTCciKJeFTszfT85CBqBKmWtYVs/R5yeffWwtFFg?=
 =?us-ascii?Q?utBCp7RB69cShvcXoUm1e05ndPjJ4kGVA/L5fH8K/8couZ62xuDr8G3Vd/Mj?=
 =?us-ascii?Q?JI8Adh3X1wlKgb8NI8QfAcksd8+xOfneJlGKr8kh?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 343dddad-3297-460c-d918-08dcb0fc9244
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2024 01:03:21.3116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c5WWA066Q+otDLMVHFvdMDkZ7DWtnHNV6w6+tMlB1tc0soS1u+nre6Vn12RINqKf/NQre4Dl51yypRM1cOi5vA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8239
X-OriginatorOrg: intel.com

>> >+static int
>> >+kvm_arch_resume_notifier(struct kvm *kvm)
>> >+{
>> >+	kvm->last_suspend_duration = ktime_get_boottime_ns() -
>> >+	    kvm->suspended_time;
>> 
>> Is it possible that a vCPU doesn't get any chance to run (i.e., update steal
>> time) between two suspends? In this case, only the second suspend would be
>> recorded.
>
>Good point. I'll address this.
>
>> 
>> Maybe we need an infrastructure in the PM subsystem to record accumulated
>> suspended time. When updating steal time, KVM can add the additional suspended
>> time since the last update into steal_time (as how KVM deals with
>> current->sched_info.run_deley). This way, the scenario I mentioned above won't
>> be a problem and KVM needn't calculate the suspend duration for each guest. And
>> this approach can potentially benefit RISC-V and ARM as well, since they have
>> the same logic as x86 regarding steal_time.
>
>Thanks for the suggestion.
>I'm a bit wary of making a whole PM subsystem addition for such a counter, but
>maybe I can make a architecture-independent KVM change for it, with a PM
>notifier in kvm_main.c.

Sounds good.

>
>> 
>> Additionally, it seems that if a guest migrates to another system after a suspend
>> and before updating steal time, the suspended time is lost during migration. I'm
>> not sure if this is a practical issue.
>
>The systems where the host suspends don't usually do VM migrations. Or at least
>the ones where we're encountering the problem this patch is trying to address
>don't (laptops).
>But even if they did, it doesn't seem that likely that the migration would
>happen over a host suspend.
>If it's ok with you, I'll put this issue aside for the time being.

I am fine with putting this issue aside.

