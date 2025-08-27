Return-Path: <kvm+bounces-55854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 20FECB37DBD
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 10:26:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C7ADB7C80D7
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 08:26:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B1B3335BCB;
	Wed, 27 Aug 2025 08:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Yde8YpGq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3422F28F4;
	Wed, 27 Aug 2025 08:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756283196; cv=fail; b=KGULC3s10s1wBfA53GEq/t2c8oHDi6Lx4xKPcRVwzTAZSmUwUe18q/KVFqxh0ZeFPrsfuVy6+btsXL5KCumErRpXX7zsGal/goFxOFavY1pgbhL9BrzLntkBuF+ZhfGtIXYGhuiyTO34zvy3qIyv2iFfRdnoOq8grBkWh/GnrTE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756283196; c=relaxed/simple;
	bh=gY/fWh/wFo3RvcDiOISJYdjt0zsboidV7daVtf2G4xg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=H6wKqQso6yrlMbqxVVhHEFwEH+yK9Gumo/alW5I2Hm/oA0RhdtgWaFAejkl5SsSJ8fyh5x70buXYMWnbtzR83fAxOYrmgIez7YVF7kzb2T4ZN3wk7Klm7cZFSDhVPc4daBgQMslLNHZr9WLW4XeTx0eZpLFxlTRYS2TtgOwbWbo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Yde8YpGq; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756283194; x=1787819194;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=gY/fWh/wFo3RvcDiOISJYdjt0zsboidV7daVtf2G4xg=;
  b=Yde8YpGqimVi8nxUjVd1A/ldpeYxz75wdtB8rWo5807t7qjX7yvNkSLJ
   IwQMkYcFzMV9pn+BtNmfx+6sT3JmnsDy2l4xssnF/OQKow8OfbMRrtSDn
   1BYNPdcJha7/NwHhlaC2rydK5REL4OlJ/k1JwHBvTp9SeIvTWeITEqx5D
   jM8w/rncHNcuBHSqy+ePzR1PIyJZtaQoeFBOBLVOojTUQgZ3a4JVZ23Qy
   k4fWVaRVTX+u9GiswjQQQ10u/tb9Eyi7mUBrWO/2wWJZyGF/6hEzNdr4o
   nwRYReZ8ked+zwf13RCEn7dOa8uRojUVTvRuvtKB5jDv1OHzTJphyXTe+
   Q==;
X-CSE-ConnectionGUID: NZ0Y12xKRgy/MZK64GAjow==
X-CSE-MsgGUID: CBdZaXwGTdKh68oul56nkQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="58449120"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="58449120"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 01:26:34 -0700
X-CSE-ConnectionGUID: BGrYWCoPSfGmX/zWFZu76Q==
X-CSE-MsgGUID: MjVAydgzTkOaP8a37VKg5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="169695775"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 01:26:34 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 01:26:33 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 27 Aug 2025 01:26:33 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.61)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 01:26:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tk7qbymX1TB854mVgZTK02SuW+64q8pGinNvrChenVNof5hRNUT1CY0L95HxOgIh9lABgbGorrWaY5XP6kkKt7VHccr24fgdNur5MkAd1qhJuiVGKGsVnWz1Z0INT4D2NHukVx9CzalR2KGGuIZR1ld5PRZhX/alCy9o0IDI7MvoyLH+fKychYaqfRuyPM+YV5MbUI8DTzUtAwOSE6Uy9i+OFveItm9+9xwypQN628BKFYfy6Ie6gCkRo5Vs9mZuX/HSz9MMNQeWC4XBmOpjMVsS8Gi2uKOYbtI3w3yA0A03EXY3GKgm3v/KC/RSLl0J9Cb2fubon9ce5/lxVd2Aww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TXpg+OW75PeLWNrR1fRyxX//fMvmM0xCnkdDEKKQWDs=;
 b=JyXp0H8+RK+WaFAcZtCDHrL6uiRyjPwtElBo66Oo2o6KwIx27TdPaXImYlnU0/oVSUUGd/o76iEND1psm7cz65W6KQY+dZ290UjqtVB7RvDaMhdkAkIon4eCX4hiJScRNbc66b2Nb5pXrYnDVjXV36taWiTBxg3loxyO1cJNDVXt0H8Vg9w7JyRrijjThAL+qTg7rq2AtnLcCXWo1MYv1d2/GbOFmo9nJohA7AVNURgD1mkmeonXslmdttxWrybIzJrzACps9NCHwWULCzF1ghCay4wgjOfyefx/rNSdnO0omisGmVIKMlJxl6zLUJV6hcC6r+sta4abfla49yj/eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH3PR11MB7179.namprd11.prod.outlook.com (2603:10b6:610:142::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.21; Wed, 27 Aug 2025 08:26:29 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9052.013; Wed, 27 Aug 2025
 08:26:29 +0000
Date: Wed, 27 Aug 2025 16:25:41 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Michael Roth <michael.roth@amd.com>, "Ira
 Weiny" <ira.weiny@intel.com>, Vishal Annapurve <vannapurve@google.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>
Subject: Re: [RFC PATCH 02/12] KVM: x86/mmu: Add dedicated API to map
 guest_memfd pfn into TDP MMU
Message-ID: <aK7BBen/EGnSY1ub@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
 <20250827000522.4022426-3-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250827000522.4022426-3-seanjc@google.com>
X-ClientProxiedBy: SI2P153CA0031.APCP153.PROD.OUTLOOK.COM (2603:1096:4:190::7)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH3PR11MB7179:EE_
X-MS-Office365-Filtering-Correlation-Id: e1967e01-b0f5-4249-066d-08dde5436bdd
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?sK4sThDFO6ZBjzI7lZ8AdkMrP0FgpW4MDfS3lxx4P/UPU5O4gkVne1bkKEAR?=
 =?us-ascii?Q?F3I8ikYKCvFjZtywxUYT3+ryQnn6r03xhv9SEmK1fPGbjLcXDC2UPl2gbf0V?=
 =?us-ascii?Q?H3nRfGAWIXY2X8+ZcclwOmKbAmw75Y7l/JleM3R6qWAxT1fOUVRaQVqtHQNO?=
 =?us-ascii?Q?q/7QEOj0Teb4H+ybOG5GlNvJH74vniwk1IIiZhM6Up5KvMux+wroGTixc0wQ?=
 =?us-ascii?Q?ajRuf1iqXqxYCKYont3d0tU55FXdXzbiD+HqJaCdNl+qjdLm4YP+gkjtpBOM?=
 =?us-ascii?Q?srek6rSIXBQk5mOrpEHuZAtgHyY95Ooon3F8okd16C+SZCDOs7tq+CPljVsd?=
 =?us-ascii?Q?UBn2UuxaRf6zeGhHnRUHM6KgcawY+hp+UG2qGkHd+wwhZqa2Qn6GTyAaPVQZ?=
 =?us-ascii?Q?0m+gxQwTZb7Ie5lnsDCNustB2LTk9jLdsmkPjTKzx6vc69VkEe5R26gO/a3e?=
 =?us-ascii?Q?gXsSpeHQ9MWoBLxxFRx67mky59z2BTV2Bsz42vU9xAGTahVWDwO2HLR60F7U?=
 =?us-ascii?Q?xg5leKEJWrWngcrUGzEjd3Sol+MQ1ZsVbmrjmcjy7tazmgm0TXEhd+4lV7F8?=
 =?us-ascii?Q?yDT6WAHrmhi63vGt12p2H6U4a8sziK+6uX2O2fCFGHzavfUoNUhrfhE7fxZs?=
 =?us-ascii?Q?Y0qYyk2lJrMwEtHF1p2vm0lJtZLB23ZtYi9sZ5WpbLh6sWp2rBhNMV9ZuXH2?=
 =?us-ascii?Q?wWV62vVjYsX2IJq+gzrhChaPMlHizQsPK0P7N7KSaUfsN1bpRKyt4voSdqb6?=
 =?us-ascii?Q?YGlTdYRZB7qvXsIffKt+WXhzJ+0qCqvEEOIeFPF8IIkgVQB03UUnFizzdI1/?=
 =?us-ascii?Q?EdPnud/Ue31QmVn80KkirWzzI2GGZoZ7ktOxCB3jv7stoYqcGShHyck70vBE?=
 =?us-ascii?Q?MkKjjhpkdPfFJg+gJobAuZbn76kl9gM9Nj85bJ+7wRQublSb/Cu9tK0tJJs/?=
 =?us-ascii?Q?7gQVCAu3gFJIttKg4OLI3GhRQkP52SfRkNWDoaFXnzkeoMVdJ8YHSN/VCl7K?=
 =?us-ascii?Q?KU3rDV46IyJhFJkrq+QfNMNvLHQFexLywXeNgt9Ud4mBgrZXyesMouyxN7Yk?=
 =?us-ascii?Q?Gvm0QJIyXXTW5+JtakQesb/0pRezF0NZ5mB2Oelegky/NSej6keRfRhy6gff?=
 =?us-ascii?Q?VQjlGPpxjd0Jyh9V9rm6LqBH648J120vSC9//7NIjTaWBf/pwm/wkcVwFzPE?=
 =?us-ascii?Q?sxhzxRZ2ww6mgy7yCcQ0qfvZknq20nTCF2mMvtT4v/lOxDnXtzlc5SfILQw7?=
 =?us-ascii?Q?+P1spv3QRux4EnpSdMlnQb3rk27RBVXo7QrhrtWQfi+P4JT9oPlLKuF5m0oi?=
 =?us-ascii?Q?C4EhuGx/YpenaYTU5AcevxyuSwY3TcDGHijClU0dp+usEwnEBoH/K+ReJLog?=
 =?us-ascii?Q?EowMQGenr8hDSvaCxRpPfiRMenmpkwLoq9SADEbHtAu65gA9uKIRbK3iO/KM?=
 =?us-ascii?Q?GzhFCphcrs4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?REYYgVss4lf0stQUiSfxSXnLMhRTiQvBVziI1veL2FHskSl+G5nibpzXylbd?=
 =?us-ascii?Q?QdLfVjVlIJYKqBr83Gq4/gZ3GoMEeSga4YAd5VgfbrbtM7e1s6+Bl0DzqPTx?=
 =?us-ascii?Q?+1EEDuSqKaH5V1S7r4ZNKfyZHW69y7CsngNzN2C48adISSqdHUeRIqC9NB5a?=
 =?us-ascii?Q?MR0Wfud4qL+cOcXE22L7DtdlBxbTntF6VQq6u1pIJ52tIZBzWjdYAPOzi472?=
 =?us-ascii?Q?02O2blyUDio8/fQkEZwHgLBGRhIaDNY19mX1mtRdju7zBOrLtUj1YQRd4zd/?=
 =?us-ascii?Q?r181f10Qhajd8a7cKmTnM2B13H7GERHkTAXfIl1HPHZ0dExEjFT1pzmB9IBf?=
 =?us-ascii?Q?B4SvUZ1Fzvk0DePrLRTMePYsureQDpw1h0nnGHALntuELiiHluOiDxLxww0z?=
 =?us-ascii?Q?NqbNWYyVN80UwXV+bIsQDM4VMKTm7tQNJjNfEg4m9agbMuVrokOC9apdAQ0D?=
 =?us-ascii?Q?GHfxoF72jfIZkQXU2sjvwZuGK6WnQzDDJER23fjyfdVBICuQwKYg6wZWhDdU?=
 =?us-ascii?Q?9RFdjT42mTd+n8vtsBE6qrVYOkx8td00Mir+1NqnTlITNHqBxaPy0/D1oeCH?=
 =?us-ascii?Q?kTiQYkhYH43KdGrSO5Oh28LSH305Ist+kRzUfT1lEYWr0qDnSSMIrIu4pliM?=
 =?us-ascii?Q?cVjaBkS+/xNFkFnIwTXW4niWDJbEFsoPhp4rNXcQHXzS4GgrtB8HtEXnNRoR?=
 =?us-ascii?Q?0N1+Ay1rH8vFZoV15nGZrZnuruDuuj0Q9uRcUhaoC1ks4rAoBwGug4ya2HzG?=
 =?us-ascii?Q?CK+2wEnm/kMnBabteZ34TPFBfBEppe3iEcspamPf7vY6q2PFrbg0RPsfnhqN?=
 =?us-ascii?Q?bzIBQdl4NNypYy8eRxkO64WApSP88vlQjp8S+iLXb+ItENPVwXra3YKfvZfv?=
 =?us-ascii?Q?3qW6TRdaKTPWHHs4t8WZbVPxbvuKAzZ5F5w+iGV5dYemgmRc0G+d712Lckuv?=
 =?us-ascii?Q?Vhcfjo0O/YbkJh6K+L9Oye68Nv1DzXrdsh5zD8xGmTGXuDEtkQCIhg2hJPkZ?=
 =?us-ascii?Q?u59enAi2+Q76nNIoF1v7GwwTQ2w4aG7/iyPkadfiqLFOGZCPPpP1cxPP2LzL?=
 =?us-ascii?Q?nS+/QDbSNtYr3jEcoDZpR0bcQzwGqJX1QuoOabzCtL8TiCfCj0ln/yiVz7v+?=
 =?us-ascii?Q?Ocmnw4EFcMZT1CrKwtjAqX/YNp48tgCje2mjsXMtzoR3HV1WX3jIsV+dB2Zn?=
 =?us-ascii?Q?mKMpge2nAe8IZh/9UMxUSoKWQ0JRDdyLUdnGqu8yrUsGSqZFzYo12LRa+VQZ?=
 =?us-ascii?Q?GTnrA+sbggqRPHY3CR25KDvpDFVNUCHBXeOyK3qmpQN+W5H5fY4p/qdOkW0L?=
 =?us-ascii?Q?NAWO/37bdKF0k2VKBffMz6DtAoZgwT6CxZi85WjI/1uG/rZVbwgf6TAjiWT5?=
 =?us-ascii?Q?6xdBLs2MtwDbIO6EjA8LCQ7rmN5I6cBAM53q/XCAzy+2LaQaKTLCAkpiat/7?=
 =?us-ascii?Q?xj1P8vNeDfmUKHRGMOTi9KveKIlYmmWImgU/dNmQYLanZoIIIDvSTiZz7TsG?=
 =?us-ascii?Q?rsXZ2KU+jBHhA/0DVFNnzBZ2ru7YwmWUF1b6Kd7sHSFNPugkRfCYSkbX0bm7?=
 =?us-ascii?Q?Du0DG0+N0stkhkjM2W851klM1q5BKQ3wZiw0ZfZn?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e1967e01-b0f5-4249-066d-08dde5436bdd
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 08:26:29.2657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: agvI7Ky+yt9JZvpqreoEpkQvqdLqgRZDFBUPTpg+tnJ9FZ8bYy+JCZsW3OTusAbzgaeQrunuDmjy2T1o4IzC+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7179
X-OriginatorOrg: intel.com

On Tue, Aug 26, 2025 at 05:05:12PM -0700, Sean Christopherson wrote:
> Add and use a new API for mapping a private pfn from guest_memfd into the
> TDP MMU from TDX's post-populate hook instead of partially open-coding the
> functionality into the TDX code.  Sharing code with the pre-fault path
> sounded good on paper, but it's fatally flawed as simulating a fault loses
> the pfn, and calling back into gmem to re-retrieve the pfn creates locking
> problems, e.g. kvm_gmem_populate() already holds the gmem invalidation
> lock.
> 
> Providing a dedicated API will also removing several MMU exports that
> ideally would not be exposed outside of the MMU, let alone to vendor code.
> On that topic, opportunistically drop the kvm_mmu_load() export.  Leave
> kvm_tdp_mmu_gpa_is_mapped() alone for now; the entire commit that added
> kvm_tdp_mmu_gpa_is_mapped() will be removed in the near future.
> 
> Cc: Michael Roth <michael.roth@amd.com>
> Cc: Yan Zhao <yan.y.zhao@intel.com>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Vishal Annapurve <vannapurve@google.com>
> Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Link: https://lore.kernel.org/all/20250709232103.zwmufocd3l7sqk7y@amd.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu.h     |  1 +
>  arch/x86/kvm/mmu/mmu.c | 60 +++++++++++++++++++++++++++++++++++++++++-
>  arch/x86/kvm/vmx/tdx.c | 10 +++----
>  3 files changed, 63 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index b4b6860ab971..697b90a97f43 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -259,6 +259,7 @@ extern bool tdp_mmu_enabled;
>  
>  bool kvm_tdp_mmu_gpa_is_mapped(struct kvm_vcpu *vcpu, u64 gpa);
>  int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level);
> +int kvm_tdp_mmu_map_private_pfn(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn);
>  
>  static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
>  {
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6e838cb6c9e1..d3625e00baf9 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4990,6 +4990,65 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>  	return min(range->size, end - range->gpa);
>  }
>  
> +int kvm_tdp_mmu_map_private_pfn(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
As the function starts with kvm_tdp_mmu, can we move it to tdp_mmu.c?

> +{
> +	struct kvm_page_fault fault = {
> +		.addr = gfn_to_gpa(gfn),
> +		.error_code = PFERR_GUEST_FINAL_MASK | PFERR_PRIVATE_ACCESS,
> +		.prefetch = true,
> +		.is_tdp = true,
> +		.nx_huge_page_workaround_enabled = is_nx_huge_page_enabled(vcpu->kvm),
> +
> +		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
Looks the kvm_tdp_mmu_map_private_pfn() is only for initial memory mapping,
given that ".prefetch = true" and RET_PF_SPURIOUS is not a valid return value.

Then, what about setting
                .max_level = PG_LEVEL_4K,
directly?

Otherwise, the "(KVM_BUG_ON(level != PG_LEVEL_4K, kvm)" would be triggered in
tdx_sept_set_private_spte().

> +		.req_level = PG_LEVEL_4K,
> +		.goal_level = PG_LEVEL_4K,
> +		.is_private = true,
> +
> +		.gfn = gfn,
> +		.slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn),
> +		.pfn = pfn,
> +		.map_writable = true,
> +	};
> +	struct kvm *kvm = vcpu->kvm;
> +	int r;
> +
> +	lockdep_assert_held(&kvm->slots_lock);
> +
> +	if (KVM_BUG_ON(!tdp_mmu_enabled, kvm))
> +		return -EIO;
> +
> +	if (kvm_gfn_is_write_tracked(kvm, fault.slot, fault.gfn))
> +		return -EPERM;
> +
> +	r = kvm_mmu_reload(vcpu);
> +	if (r)
> +		return r;
> +
> +	r = mmu_topup_memory_caches(vcpu, false);
> +	if (r)
> +		return r;
> +
> +	do {
> +		if (signal_pending(current))
> +			return -EINTR;
> +
> +		if (kvm_test_request(KVM_REQ_VM_DEAD, vcpu))
> +			return -EIO;
> +
> +		cond_resched();
> +
> +		guard(read_lock)(&kvm->mmu_lock);
> +
> +		r = kvm_tdp_mmu_map(vcpu, &fault);
> +	} while (r == RET_PF_RETRY);
> +
> +	if (r != RET_PF_FIXED)
> +		return -EIO;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(kvm_tdp_mmu_map_private_pfn);
> +
>  static void nonpaging_init_context(struct kvm_mmu *context)
>  {
>  	context->page_fault = nonpaging_page_fault;
> @@ -5973,7 +6032,6 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
>  out:
>  	return r;
>  }
> -EXPORT_SYMBOL_GPL(kvm_mmu_load);
>  
>  void kvm_mmu_unload(struct kvm_vcpu *vcpu)
>  {
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index a6155f76cc6a..1724d82c8512 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -3151,15 +3151,12 @@ struct tdx_gmem_post_populate_arg {
>  static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>  				  void __user *src, int order, void *_arg)
>  {
> -	u64 error_code = PFERR_GUEST_FINAL_MASK | PFERR_PRIVATE_ACCESS;
> -	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
>  	struct tdx_gmem_post_populate_arg *arg = _arg;
> -	struct kvm_vcpu *vcpu = arg->vcpu;
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	u64 err, entry, level_state;
>  	gpa_t gpa = gfn_to_gpa(gfn);
> -	u8 level = PG_LEVEL_4K;
>  	struct page *src_page;
>  	int ret, i;
> -	u64 err, entry, level_state;
>  
>  	/*
>  	 * Get the source page if it has been faulted in. Return failure if the
> @@ -3171,7 +3168,7 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>  	if (ret != 1)
>  		return -ENOMEM;
>  
> -	ret = kvm_tdp_map_page(vcpu, gpa, error_code, &level);
> +	ret = kvm_tdp_mmu_map_private_pfn(arg->vcpu, gfn, pfn);
>  	if (ret < 0)
>  		goto out;
>  
> @@ -3234,7 +3231,6 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *c
>  	    !vt_is_tdx_private_gpa(kvm, region.gpa + (region.nr_pages << PAGE_SHIFT) - 1))
>  		return -EINVAL;
>  
> -	kvm_mmu_reload(vcpu);
>  	ret = 0;
>  	while (region.nr_pages) {
>  		if (signal_pending(current)) {
> -- 
> 2.51.0.268.g9569e192d0-goog
> 

