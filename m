Return-Path: <kvm+bounces-18258-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 903448D2ADE
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 04:31:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4472A2888B9
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 02:31:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC2E615B0FA;
	Wed, 29 May 2024 02:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T5W+sHED"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE2E15B0FC
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 02:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716949830; cv=fail; b=HP8nwdu7QlW5Q2f1E0lPpYTpFdOx+uQjTdIlkrdXG/XLR5ggffMLJmj4JB+PcfC2wKHKMD5YUfJMEG8w/mcrEeabca62e++7FLK91xDvfUrJjMLAzju8NsNLZVvGnxb1XEAT3XPY4aCywFS9kQJJdiNJYe1nlNAODZthxJdhS3w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716949830; c=relaxed/simple;
	bh=jaQNqdpRaR7tIosoJ29htOpE70pHJwXsNm9Zb33h2Z4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TveGZnv6ZUYIV39+uFt487P3mO0pDUCcgN4TV/XfbPIzsGyhqmhjsfpYxjfaCcgJgmith358MbcIb36yWdo4UJfyt9jei711fcDZ1bn7VCwJtgX+KPXRhT7ZBUgKlJBqCfKob/zIFrNbL2EYhvfLTF5q+JtnfNH5Vuj63PxnQdY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T5W+sHED; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716949829; x=1748485829;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=jaQNqdpRaR7tIosoJ29htOpE70pHJwXsNm9Zb33h2Z4=;
  b=T5W+sHED5eYCQJ18ASLEyHPWHXcSvTUP+dfH2mBTaGTql0eCTknzdRCa
   PsZ1o92qohDFUx6pANNJA+ZRdIDOhaMHd3pZR36U00JcBSOdr4mbw5cPj
   fUS/ucs1vnwQn1rwckBOiCcX5KcaArS3q9wwiit7dF0vgPOlGNYuV6x1q
   5kVmhbfuhvcA+EY7SZeXuernsTCcJ6yDdxvS1TC33unEb4jGhBnk/tDE5
   G/NkVEV5km9ItKCAdOPyH900oIoSEESjBnpsn/anhBJe5VuzoaP8CcYWY
   njO8g/aM4ZjWeqTwQhStOZLpIZp6pRv+NUhUG/4n0tev5nyke2j6qMXHN
   Q==;
X-CSE-ConnectionGUID: rwjtuxL0TKm/0x8Lk5FJJA==
X-CSE-MsgGUID: ifO7jkgMRs6kM/gENMIFSQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="30857401"
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="30857401"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 19:30:28 -0700
X-CSE-ConnectionGUID: VoKlFjDXQQCUAeL6denahA==
X-CSE-MsgGUID: YIEy7KvaSX+puZm5gXc28Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="66125094"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 May 2024 19:30:28 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 28 May 2024 19:30:27 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 28 May 2024 19:30:27 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 28 May 2024 19:30:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sb1tWDW/+EdDJgTb4+tKB2uXKQ+jiR3LW9UGST8AJpZm4198xoBkgQfC746ILqLWyPdFDZhLDRep4M301cK4dljjpvLrBhrxH7Aqy0MeLwsXKAoGzOFJJ7dchcI5xEbcZ7XVDCMglmfYuvGDwGGRUiw+617ACetIPYeKd/hUdG2dpy7Ui6Pc2qZZvRHvzTWCblcNJP70LjpG/EFRphQApzm5GKXees7j4zcyOKsUb4b3fiFjxHihTT++X0QRpHX+pT+ihtPQkecviBTelr5O+QW7lidL/e758JUAcnrrQE81Y3JZmyGXbGakXIKyCCre9J+0dOE9KAYbWO4A6yPVrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jXsbhB9gUmj6ERllpQdtAG1PBhK7uTRbV3cMs8HkoSA=;
 b=V5Vv8A+B3c7Lo+InRKSVXgD+ACC6wps7b82y4Cl/svL3OLAJrlSGe4GvKw16kj+LZWx0hd1tj+b1Itc8q/yP09CLIQsfUCh1uViKn56Pga6hQP26qmlm4CfdQltYlz2vGSoxpcYYX1IEy67OL6OYt+qJ3V3BA0LawCxBxbOLAAtOf9cavHuGwRhKz0A+/4qiCaEULXJ1PU91M9WfrH+y5X0VW71sY1edZsnObt70653Rhh2AWS+peijOYh1tPTGGk/pAojzxdn8MnfLbQCPHr+lhyMjgvPIxYv0i4qGtF3GHFv/LAL7NppvIm90atb9I4BSBpDxVEeQO6SXb19+1qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MW3PR11MB4523.namprd11.prod.outlook.com (2603:10b6:303:5b::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7633.19; Wed, 29 May 2024 02:30:25 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7611.030; Wed, 29 May 2024
 02:30:25 +0000
Date: Wed, 29 May 2024 10:29:33 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Peter Xu <peterx@redhat.com>, <kvm@vger.kernel.org>,
	<ajones@ventanamicro.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>
Subject: Re: [PATCH 2/2] vfio/pci: Use unmap_mapping_range()
Message-ID: <ZlaTDXc3Zjw9g3nG@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240523195629.218043-1-alex.williamson@redhat.com>
 <20240523195629.218043-3-alex.williamson@redhat.com>
 <Zk/hye296sGU/zwy@yzhao56-desk.sh.intel.com>
 <Zk_j_zVp_0j75Zxr@x1n>
 <Zk/xlxpsDTYvCSUK@yzhao56-desk.sh.intel.com>
 <20240528124251.3c3dcfe4.alex.williamson@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240528124251.3c3dcfe4.alex.williamson@redhat.com>
X-ClientProxiedBy: SG2PR06CA0217.apcprd06.prod.outlook.com
 (2603:1096:4:68::25) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MW3PR11MB4523:EE_
X-MS-Office365-Filtering-Correlation-Id: fa7e904d-56f5-4262-76fc-08dc7f874bf2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?txichQL/DP+lMgBo6YvCYvwfkryz32ZktxmD17k7oN5Sf8F02uJBfTGe876R?=
 =?us-ascii?Q?TnJwpILA9kyC/FEDlB0P4ac+jeVtGHTncBcw+ytiJ2LiDPskoigF/oeaEuhO?=
 =?us-ascii?Q?2pl6vdRq3GQz9LLxNfRs3ok2TbIyp+gmybxIdc6A6OP0iEcSWEndQWFffn+J?=
 =?us-ascii?Q?HB1WaUuCnzYDZqzUSklThe6x2/nQneFlil3QdITthdsblRb9r9p9k0xgv6kj?=
 =?us-ascii?Q?uhjGgmRGE8WgMMvuevufQTN2Uax/f5u8EB+dHOyJRW10EWaqI3xfPiFwwB1G?=
 =?us-ascii?Q?qM2II5KE3BICR/sYH8YnOcZXbLAqQvv1EpOsQGxE/IimKL6WwNZT/KRVGKEQ?=
 =?us-ascii?Q?6v8pcfLrG+BtCqppCM65ZsmTGDvOrxxOHA5G+JLPTQc3HthDTU+2gpt0uSi4?=
 =?us-ascii?Q?3LGsqmOskwDaLOHmodFZckPOo9DfQ+HGZXAc9idJ+21lfySNJgFshFYUdDvN?=
 =?us-ascii?Q?GuzseFtO82l89yoqnOxrGwIvrEnnPXRnc9mTPE9EfsvtMsBRMSl3K1bt76v9?=
 =?us-ascii?Q?c9r7z4u9yt8IuJBT5yS341GDfog3W79iEyIBdEew75RaC8+ZHvH3e95iyjeL?=
 =?us-ascii?Q?Pn6cq4nEGrfctv/Er/h3nk5b8UdX39+LCZvPr4+R6Jouy+IvlY7iz81nWzUr?=
 =?us-ascii?Q?AkoOrF+YEBhONFON8+lrpinqU3xEw15C7gw7VrzR0O7j9w6zvQeenoYzXyOA?=
 =?us-ascii?Q?5trHEuJ4/7uPr6ZsjdQ7jlgbvrm5RofplLMhYt+SS9P6K3yeFarTbAYClj8p?=
 =?us-ascii?Q?eGtkIU1eQ12+0gPrUhY8umQYT8TTJ3WsFIc4ksXpzL7YrwW6CethcZ6NmcyP?=
 =?us-ascii?Q?tuBWa/AANyTUbc46a8sWM8W5vIS8DkvZPDmyV+ug7welUoiLUjFiGsevlOIu?=
 =?us-ascii?Q?4Kc3r6N1Faf3OJ0TWHhLIyjvZGBBfblufDLpICwPIHbB7l+D9oZU/GkNpTEw?=
 =?us-ascii?Q?LrNravVfFbrdG87X6foSjIkKjZVpYj3Tj5UQJNckI2leVfaD0TtCXYwBAES2?=
 =?us-ascii?Q?vAptqNk2arFVeQpLE9XGnk1blW1vdufnJ5lgcSWu0+8SQ0RYqXUZGSpqZoZ9?=
 =?us-ascii?Q?J48fRkRCeJTuH3F9eJqHnOl+FWoDvNsRA1kR9CoPTxTqiRForRPMvop5BXvo?=
 =?us-ascii?Q?OD4HMREm730LsU5hyO4hL38ESdhkPvElTHuGqDF9aPRSHruc6XAdoziVz5Y7?=
 =?us-ascii?Q?bzegdAGb8mjqZjP7d5wgC/k3NDr65+/gADC5HYUOXRVwJ7jNWu58E5IKEBQ?=
 =?us-ascii?Q?=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RMqzVwrVQ+iL3DOaKvL8iUrisYhv78npj4YtR1hfmgSdIkC+KLIDcxP/nJ/G?=
 =?us-ascii?Q?PBHZ+/Y/kDriluBNBI/9uAB2nTDCgYmAxRxy2byAZgGDY9vihLsKObqwojz8?=
 =?us-ascii?Q?Y6osvCrSdb9lse9PlaOHa4ZinMST0Qn/AMqn23lzicq1D7DGag7mFG41uiLU?=
 =?us-ascii?Q?tFWY0IPfgD/8eKsoIfDSFPvvbbQQNr6UXKXNDXfnmq8ylCe+J0FLVZ8DQEpU?=
 =?us-ascii?Q?Xc6imb7y3S4TyeoBLm4spsvq9Y669jWM1oac1eNup+m2IIPHhqUD1r6K+eJw?=
 =?us-ascii?Q?ma/tKp2aAl5rJa4sOpUsjQS7KqKse5EU3Gjp7CIX0TrkVv1ANS6ruahoyBZ0?=
 =?us-ascii?Q?tjdgf0+CBB9C52qj6LKYS0ZLhLIYhA1T+vby+0KoTSnp50FxWT+5r8zBACfY?=
 =?us-ascii?Q?Q2B4fH70niaRcoTUC10hFpZkAVkURgaP9Awn7fgTjdTN9zEwXLVcSAdX5xuM?=
 =?us-ascii?Q?0XPdYHAyCHq4PcslOSSPbtgs59kq1FZFMpLdHVGr9EdjHhIENDZREFEwgBb7?=
 =?us-ascii?Q?cg+bUXwpVGjSsBNwuEd/iubjApfRLaLEJ3/u+uU2Aw3M1kUL+r46HCNjWxm0?=
 =?us-ascii?Q?NBjMfcQXrZQz0EjFSlvCEkdsBZoFTGxD6BBdhx+4Ho6DBdVgfVfk7za+Dw5W?=
 =?us-ascii?Q?yGV3rIre5xDvYGXmqWqo+ezLML2DoBRNy+FMVc8M4VwJwnVCKPSGjy94yWOf?=
 =?us-ascii?Q?POBIIJf0gmFhz8fB/QOYuSH0NZmxkOguq9NPjSEOltb5Y53hawL3p8PJbOuc?=
 =?us-ascii?Q?vPAdJJ2wP1JFKtk/i2T4CyCIFTY3mLbt3cAKwlJoIjMaZxYhfLmIUU2a2Mv1?=
 =?us-ascii?Q?rhK8a3x28WvqpxeccU2p1jWc00vUBnDpKWg9nlhfASQwIowru5VsOVUHJYbR?=
 =?us-ascii?Q?MSj02+DzV64iUx3SpnME7jB7tKZyIiNw+9T7QMPNbNZ/BmbcziGFq7azQE1V?=
 =?us-ascii?Q?PzcqhPlHZGL5QPBFFsoUbCx/yP1wbbL95SUgfqwwc//PsqjVyMa/k5PByg3Q?=
 =?us-ascii?Q?yjun2T5P940yB9ggXs1G2iYAlfYn9NyU7x19tyhC1IFSPtQF7KR9Rcj7hoCT?=
 =?us-ascii?Q?r1g7unPamgWdMhDjjAbpzjz+nPVac/u2A34jlWBQHJU21vYvCYq3C9+9WwR2?=
 =?us-ascii?Q?IJIidn3D3aOhOoOWwzDbIJJ/cWKA5765RTxihse9x6oS3YF2MtXhFEzo3Fvi?=
 =?us-ascii?Q?cQuLR9PaxoZ6N36cPuA9XZP311P2EONUh+ILnzuqgyobtaCpQFFVaMfA10F5?=
 =?us-ascii?Q?Wow2EhFUo1taZMIN5bMWUPAc+4Y/er63vT8txF7U1mvnilOfhq1gaX/Y6cLD?=
 =?us-ascii?Q?gc/kCn6psBFyQhStad4C9HsFm6x6hw1cJyzWTxNGg9jiTRuDaBWCOPcC41/w?=
 =?us-ascii?Q?1FvXoSCIc6jv+0Mevh7TB13AgLO30nG20NyctUTUBa1YKobADIjDEHEIwEcG?=
 =?us-ascii?Q?ccWhNCcyWGrVYTlMS3TEdIcx/cDg76NdIe6JBW/hzBxJM0KNpSuD12wkn1hB?=
 =?us-ascii?Q?v6wFXrVWuL75HdILcO1jYqssAsM8BJCC8dl/0URibsxEt5ztGwFm61pU8y7+?=
 =?us-ascii?Q?nD/N5Z0lB9veVoApVI3B4H7POJX5ATqwko4OYzMH?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fa7e904d-56f5-4262-76fc-08dc7f874bf2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2024 02:30:25.2149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9eNTVUZY0siYgMHwoLqZl91g45PC8Uzya87CzE7OFX4EmvdIo+q+oqowrD8KwXU0+lIVfdt/WPt1P9gl9m/PwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4523
X-OriginatorOrg: intel.com

On Tue, May 28, 2024 at 12:42:51PM -0600, Alex Williamson wrote:
> On Fri, 24 May 2024 09:47:03 +0800
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > On Thu, May 23, 2024 at 08:49:03PM -0400, Peter Xu wrote:
> > > Hi, Yan,
> > > 
> > > On Fri, May 24, 2024 at 08:39:37AM +0800, Yan Zhao wrote:  
> > > > On Thu, May 23, 2024 at 01:56:27PM -0600, Alex Williamson wrote:  
> > > > > With the vfio device fd tied to the address space of the pseudo fs
> > > > > inode, we can use the mm to track all vmas that might be mmap'ing
> > > > > device BARs, which removes our vma_list and all the complicated lock
> > > > > ordering necessary to manually zap each related vma.
> > > > > 
> > > > > Note that we can no longer store the pfn in vm_pgoff if we want to use
> > > > > unmap_mapping_range() to zap a selective portion of the device fd
> > > > > corresponding to BAR mappings.
> > > > > 
> > > > > This also converts our mmap fault handler to use vmf_insert_pfn()  
> > > > Looks vmf_insert_pfn() does not call memtype_reserve() to reserve memory type
> > > > for the PFN on x86 as what's done in io_remap_pfn_range().
> > > > 
> > > > Instead, it just calls lookup_memtype() and determine the final prot based on
> > > > the result from this lookup, which might not prevent others from reserving the
> > > > PFN to other memory types.  
> > > 
> > > I didn't worry too much on others reserving the same pfn range, as that
> > > should be the mmio region for this device, and this device should be owned
> > > by vfio driver.
> > > 
> > > However I share the same question, see:
> > > 
> > > https://lore.kernel.org/r/20240523223745.395337-2-peterx@redhat.com
> > > 
> > > So far I think it's not a major issue as VFIO always use UC- mem type, and
> > > that's also the default.  But I do also feel like there's something we can  
> > Right, but I feel that it may lead to inconsistency in reserved mem type if VFIO
> > (or the variant driver) opts to use WC for certain BAR as mem type in future.
> > Not sure if it will be true though :)
> 
> Does Kevin's comment[1] satisfy your concern?  vfio_pci_core_mmap()
> needs to make sure the PCI BAR region is requested before the mmap,
> which is tracked via the barmap.  Therefore the barmap is always setup
> via pci_iomap() which will call memtype_reserve() with UC- attribute.
Just a question out of curiosity.
Is this a must to call pci_iomap() in vfio_pci_core_mmap()?
I don't see it or ioremap*() is called before nvgrace_gpu_mmap().

> 
> If there are any additional comments required to make this more clear
> or outline steps for WC support in the future, please provide
> suggestions.  Thanks,
> 
> Alex
> 
> [1]https://lore.kernel.org/all/BN9PR11MB52764E958E6481A112649B5D8CF52@BN9PR11MB5276.namprd11.prod.outlook.com/
> 
> > > > Does that matter?  
> > > > > because we no longer have a vma_list to avoid the concurrency problem
> > > > > with io_remap_pfn_range().  The goal is to eventually use the vm_ops
> > > > > huge_fault handler to avoid the additional faulting overhead, but
> > > > > vmf_insert_pfn_{pmd,pud}() need to learn about pfnmaps first.
> > > > >
> > > > > Also, Jason notes that a race exists between unmap_mapping_range() and
> > > > > the fops mmap callback if we were to call io_remap_pfn_range() to
> > > > > populate the vma on mmap.  Specifically, mmap_region() does call_mmap()
> > > > > before it does vma_link_file() which gives a window where the vma is
> > > > > populated but invisible to unmap_mapping_range().
> > > > >   
> > > >   
> > > 
> > > -- 
> > > Peter Xu
> > >   
> > 
> 

