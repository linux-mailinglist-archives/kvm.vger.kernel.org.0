Return-Path: <kvm+bounces-32986-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA6FF9E3397
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 07:38:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3AA25B23604
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 06:38:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF45A188724;
	Wed,  4 Dec 2024 06:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gPKa902l"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F9D2AEE7;
	Wed,  4 Dec 2024 06:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733294294; cv=fail; b=IcD0+e0k0jCmgeo6nM1fKMqH8vk1I0usQXGb7xkYTCr7Br4HHTvNLF5JEJyHg9ajVr8pNOXvYCBdw1D1uI8WHNL1UhS1gw08wbSo6zMA/Gbc1YvfqIjf9L5cy7drFPKr/o5DJY2nUE49DgJv6uDZFIpE52ZStyCLmEhfmYfjgWU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733294294; c=relaxed/simple;
	bh=/tYjQhpAp2tcvUwzVebuUrbHzTAa3LpzC+Mm9+Yfs3w=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=n8jJEn8C6lrcD0C/NxPRWyLvocalJEheny7UgyicfGmeGjFw5yUDDq7ggZ0l1Oe5Fx2sRPHCVwR+y5wTVMfW+aDf5F3jpweuRgvod0amWEu8WCbYL6ESCXGubrEaGYKOFhsMtFoLxDP14GDHYCvqV26YGLxAH2mZELLQvVvJ1IE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gPKa902l; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733294292; x=1764830292;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=/tYjQhpAp2tcvUwzVebuUrbHzTAa3LpzC+Mm9+Yfs3w=;
  b=gPKa902l1Y5O07M3szdSmABAwakYyvj9GT2KLuF/ga1rc5L+0bRyEodw
   lwlQOD636LpNKqxAG3qVAhTArLyHn3MXE+m7Z0Zzzuei6sUmYXavC+g7a
   wnfh76rh+gUc2CKfC2hCwXcY0yGTDe8KZU8ChYpxS7xhIll61lXB55Vat
   vqsgKoPzu2X2T3ITfnrlzpNqlptdovJbB2fWDzCPZKrpB2epfKWzApxqX
   QIEG3l5GYB0BsSMQeHvcNsrf+qh0L1oNlECyN6hPM4jTvCq6dT3ryvZnE
   G1kNF2xjUg9Yilr7Y+DVg0fBsNFWKARftqDumf6kh/ZmyH96+fqVi3plw
   g==;
X-CSE-ConnectionGUID: WxHoUIXNRNCCHMFVUDYK0g==
X-CSE-MsgGUID: RbtdGwvkT4ObwFBmybvYIg==
X-IronPort-AV: E=McAfee;i="6700,10204,11275"; a="33464216"
X-IronPort-AV: E=Sophos;i="6.12,207,1728975600"; 
   d="scan'208";a="33464216"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2024 22:38:11 -0800
X-CSE-ConnectionGUID: eiVFmWY7SPOVzx2MxoQsVA==
X-CSE-MsgGUID: mOg7qKwLTBe+2gGhdcSqUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,207,1728975600"; 
   d="scan'208";a="93858909"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Dec 2024 22:38:11 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 3 Dec 2024 22:38:11 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 3 Dec 2024 22:38:11 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 3 Dec 2024 22:38:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=btFMi0FLu3kss0cP41hEdZJD3TgMMrxVeKPacRyVRt81ZCNPs4Ma4vcolaMJqQj84kRmGlD1zAZplbXEgsERXyf2bE96Cr8OF7M1DswutJKRwO6Fk1ecCho2UA3Cn8jOMgZ5wEFst9Vdxl6SKZo8XM5Yamh6iCLfe36KskfTpZRHunlYjM999XUPMj3W0BSABwXmd1gcoqx9dlcDWhaWHQfnmoncMgBFwH0vY0tLIJzOFAFu65DWjPneDMWGWHrlaff9yOdVyWJP8YiYf05AFL5M0d82iQWwKU2UpAlvAvsrn320gumvoyPgpLX8E/E9AR5fvP4R/wGD2MoVnKT4mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QqkgNShZdI5ResPZN36msvLg4BgIgRyX6o0UG2LakJM=;
 b=whcmBdnurIN5fEtDhiYX5Gl5xeY6ufFDBi2YmHEKPiaDqiOtSilqZrPCfOK1wxpwxvhqE/U7v6JOG2w9GIhbXusy/YhFHVv2u5Jxb26eVxc1fwjICvqtMgxC7gSWsimD/v7wnIzQdBLyAyYGweYA8VIywZlxr1TfPvcac67ONPBLfwO/7YjR5p7qrBT6xfvD4l0H1N+PZBv61MrLkfRZHOtitq43WFsjKR/vCfeFAiZnDfYetNHgj8v8JgwneKHTGlPHO0UUOU6tCodZm+C30wsrRSNVUKmTasJExtojG7OYUHFevUXnHX7a8hq+tbJ7hpqeQhc3RfXH1nqQXG0DkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DS0PR11MB6470.namprd11.prod.outlook.com (2603:10b6:8:c2::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8207.19; Wed, 4 Dec 2024 06:38:07 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%2]) with mapi id 15.20.8207.017; Wed, 4 Dec 2024
 06:38:06 +0000
Date: Wed, 4 Dec 2024 14:37:54 +0800
From: Chao Gao <chao.gao@intel.com>
To: Adrian Hunter <adrian.hunter@intel.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Huang, Kai" <kai.huang@intel.com>, "Zhao,
 Yan Y" <yan.y.zhao@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Yang, Weijiang" <weijiang.yang@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 7/7] KVM: TDX: Add TSX_CTRL msr into uret_msrs list
Message-ID: <Z0/4wsR2WCwWfZyV@intel.com>
References: <Zz/6NBmZIcRUFvLQ@intel.com>
 <Z0cmEd5ehnYT8uc-@google.com>
 <b36dd125-ad80-4572-8258-7eea3a899bf9@intel.com>
 <Z04Ffd7Lqxr4Wwua@google.com>
 <c98556099074f52af1c81ec1e82f89bec92cb7cd.camel@intel.com>
 <Z05SK2OxASuznmPq@google.com>
 <60e2ed472e03834c13a48e774dc9f006eda92bf5.camel@intel.com>
 <9beb9e92-b98c-42a2-a2d3-35c5b681ad03@intel.com>
 <Z0+vdVRptHNX5LPo@intel.com>
 <0e34f9d0-0927-4ac8-b1cb-ef8500b8d877@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0e34f9d0-0927-4ac8-b1cb-ef8500b8d877@intel.com>
X-ClientProxiedBy: SI2PR01CA0050.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::21) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DS0PR11MB6470:EE_
X-MS-Office365-Filtering-Correlation-Id: 9866604b-70e0-479b-29a7-08dd142e361a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?0B0AM/O1UyGIfVj2UjHo1uFUThMWU/eR4A1UkUrxa9fIKxQP/vy4S4sEEqOB?=
 =?us-ascii?Q?JtpLJMC6zJJUaL+qLKQxlfp3zJ8FlmkcpPetGP3o7b90LYVZfmGbiMQXLo0T?=
 =?us-ascii?Q?qH3gyUS9gfv2IrgWtIFbfDwVdK4xmxPpB+MW7eNQ2giiAIo9Dp4X3Yk4QzWW?=
 =?us-ascii?Q?Xfy+wk8naXQLliQEEw66Glyt67OuK6tN7oMOxuFceyF2FYl0k78h36HZHL+r?=
 =?us-ascii?Q?+hn/2e0phqLh8RlfLAq0c0dKvAbgNL0wAKu7MNxbsloxTnC9VGtsyL8Dx5+z?=
 =?us-ascii?Q?Cd4jB5fnFWnm/eWcbTu4bnvWhYmlkr0ZdRFMYE1qBd/wFvcNnIHPjT4dT7je?=
 =?us-ascii?Q?pCyxGAfYQ1ytkvsMGAflEIUVMiCfTyJqhox42XZnD2iFh0iXXx5jRPOes1zz?=
 =?us-ascii?Q?j9lQ65ycs7ES1xs1PRGBwFGRE2cONIp6ezg0aa95LI8P0X2HbxiQyNmNE26w?=
 =?us-ascii?Q?+KCdMovlfVdQM6vOEWU2CtcoIAmbpUh3ddvQ+yOvgw9EXTmPuXB1888KTXQy?=
 =?us-ascii?Q?UrwJAvoX6gE7781+oR8MNT9P82M0vRodb7lB7WyUf5bX3KHsb0RVfXz6MM7x?=
 =?us-ascii?Q?UntpY4VDoy9btcNCNaQM91IxNeuMHzCrBvoIt/TB7/HeGLpqN+cCS2ZM3+da?=
 =?us-ascii?Q?7xGe3C/AsDnewlAQwn7F5WHSf5ZkpKouR1RGFqnbIca820sJp4J+s++JP0cx?=
 =?us-ascii?Q?geUJpFjI5LIO0HedAML7uuppsG160bnhKy5BFjsC4jiHiVcuPyu0rriIiIHg?=
 =?us-ascii?Q?jmfWpi2kue6yS9rP9NNk57dhlMvr4xZ4e1pZ8orFC6G8aN6yYL5TWwQ0X5PC?=
 =?us-ascii?Q?N3xRZIZAM50dfmqzmmoi89yggv4OUkBLawJwvnPRzlrJOjJsUPJeyKxR/7vw?=
 =?us-ascii?Q?eFG9QW19YofCSuGNi1KBw/ys5StnJ8SihpwmvUuMYeMn1LpfR98swvnyfGAX?=
 =?us-ascii?Q?DSa/ToSwuKM4rgpoPcQZpqz/5XNeCfJYKuJdrx/toheY+/P9W3jNpRhNVJE6?=
 =?us-ascii?Q?FGdAHyZQGc+MbRUZeN/OAqpGAaNkNjk1+qBDCLUP1jVJB6X9HPki47aQifsS?=
 =?us-ascii?Q?Cx5bujCK6UcMwnnMv+6JuZ78jbWzXdRWaKXKDyIY3UsaSMSlLXhHbiKX4SGz?=
 =?us-ascii?Q?A6NeqkfDu1ZYE1v0JcO720CyRlylnEHDWJtdapQLeW0CpaTZmeiZGvyM31bM?=
 =?us-ascii?Q?sjRfuJ9gHz7xkk5h1xf3D0uKgQzAbun3MvRytvu8jLF7gOrdQdJmsPJ7mGCc?=
 =?us-ascii?Q?hrvGdJKE1P6pf4aopm4AKlzpi7pY/DMXsCEqcLSh4SMYQIgEs0OUOwt8B6YA?=
 =?us-ascii?Q?NBh0pXrRINCWHn89igBsYDwxJxuw9rIGjRqXpa7l+GMcuA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mge1s26o+FF0BcL13fGzlMnWELQwHvHIQnpQMn3NH+z3ZjYkUVZ3i6pDTbEM?=
 =?us-ascii?Q?Dc74VhRVInntjIpSKtC+MfzFt+3hfYF+GTKZLf3Dq9Z0szDKViAygmC63V1B?=
 =?us-ascii?Q?AdcjeNgmWDzGwjaBQbCHl3ivsR1fkvonfBF65uAJcruczrU0/mOYE9hHj2Us?=
 =?us-ascii?Q?QmAYUzyji41dswJ2ROpklWyY+IAIhyrKod5K5R6XG4XwVdKhNeLWb+bGAEnl?=
 =?us-ascii?Q?6MkXm49IEngKnGaJZDjdz6mbFvkuh06Qa82u5z9VPVb0ZhR8fwCR8VGyH88l?=
 =?us-ascii?Q?4G5epIVbNUiN5cH6/Ab3JqUidx6/RchG250lqVx93A2s681nNsEIf1EQ88yz?=
 =?us-ascii?Q?NAoEasP1jPgBHuNE0djrmlZBSK4rRYVmkMKrL0Dgm1L7azJfY1XPONceYZSF?=
 =?us-ascii?Q?PMtFHwvE3hwfHtxsAdmZDKqlFXSa4YzUwnPbC+2xtbBvvUAKEmt5Qk5Wxhuc?=
 =?us-ascii?Q?2BJEdj052b8BpSh2YI1QOcsDciWetRBz8oMyIjSo9YYSAnQD0l+bYMDd+nS8?=
 =?us-ascii?Q?QO+9ucKs0oPaRQJuMK/mwPPvXcVMGq16j/6o/+p3aPvBepHFtv3cLa77SBl0?=
 =?us-ascii?Q?sSDSMlvAJQp7kF/Q6DM+4PN3HTObF0R4lrGllvSUWrwC7zvD7WHfI+o1jwWB?=
 =?us-ascii?Q?jvl7dg2xtavhNErZ1honsTErc1JSNItM8+QD+p1V7mD1QXcacsZyC7LMGEle?=
 =?us-ascii?Q?WRIntU0jPu+Id3b4Rilj49PQ87wdAcSwAuEummS5j0heE3Stes/QlNMdadbx?=
 =?us-ascii?Q?jEtqZOYx5UAB6H71bwf6/h+ka7+/6PSI1jalj8jHtuB5YRHfPgdu7EbWrSMR?=
 =?us-ascii?Q?0GGmtDKKB8iyOesX0a9mAYma3uUKTzst+0iQLfgdQm+keecdJ761OIN2BHbG?=
 =?us-ascii?Q?LBm2Y/8lgnBjANmViY4eIa+m3lxkvhgm1s4nYwwr9OUumNhoIGY5Ofymt0Ut?=
 =?us-ascii?Q?xa3FfITDGIPErKcBd7fD55X4n3GCAv6kQwtITcqKtT6NKKca23LvXwMOKKKJ?=
 =?us-ascii?Q?LNlhjuR+ITJVoDS2mjOhhB0tQm/FI6IURwWhzFjU3E6DMOUnXHgpI1xfuZCU?=
 =?us-ascii?Q?qUZTMvx6Qi1/paiQZgIf04JLi+xe6VpPyRMNgoglInm7iqh7c0jLs3C7CizH?=
 =?us-ascii?Q?bkmsWktPwJo39CqdJ11adLKFO5tNtaxX8HZfYRLQ7IhpACkSHLUBVYxOpRKg?=
 =?us-ascii?Q?5SQbnMYZYFqgtQZh/2ZN/a7YQi1S8TU4A9pW/xRZXIoGDLXd5pSPSChgb0HT?=
 =?us-ascii?Q?a/Gaoz4e+xoPSV0xfqFblTknCzDGGMNQBmrsXxT9YgVoy1Yw1ZCUUXBSm40y?=
 =?us-ascii?Q?TKfNO4D/wjg1DgMJu0B2ZXC56ChZKM4W8e80J53Na2H64hndjDWhv6Nax86a?=
 =?us-ascii?Q?IzVO5NnBzIDwSdBkzrrMjROpLBdeVo5xqAUEqFGwWRJpUdpn3JpBHr6/WedL?=
 =?us-ascii?Q?6nvTFcgP7iluoffnII3DkvzhqQcdVYZq/DadDNiE9MAFRkcKchkLO2gvYFyk?=
 =?us-ascii?Q?GIU9/yWK8hpXHLLpEdJb0/FA5/ScAAYVgGrpjASweeKe7aTiM4sW7iLJbFf7?=
 =?us-ascii?Q?bQp77WDcpyjANZtYDGW67N7f/F/SvPyA2821MWa8?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9866604b-70e0-479b-29a7-08dd142e361a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2024 06:38:06.7587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w/T3GZl8CvAvZ1buWwJ0FckG/+pGiTZPLWGzjWbz2YP3gzpn6ARV0sXCZTZkBM1W6DjACORNxbF6CNOCXYtOaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6470
X-OriginatorOrg: intel.com

On Wed, Dec 04, 2024 at 08:18:32AM +0200, Adrian Hunter wrote:
>On 4/12/24 03:25, Chao Gao wrote:
>>> +#define TDX_FEATURE_TSX (__feature_bit(X86_FEATURE_HLE) | __feature_bit(X86_FEATURE_RTM))
>>> +
>>> +static bool has_tsx(const struct kvm_cpuid_entry2 *entry)
>>> +{
>>> +	return entry->function == 7 && entry->index == 0 &&
>>> +	       (entry->ebx & TDX_FEATURE_TSX);
>>> +}
>>> +
>>> +static void clear_tsx(struct kvm_cpuid_entry2 *entry)
>>> +{
>>> +	entry->ebx &= ~TDX_FEATURE_TSX;
>>> +}
>>> +
>>> +static bool has_waitpkg(const struct kvm_cpuid_entry2 *entry)
>>> +{
>>> +	return entry->function == 7 && entry->index == 0 &&
>>> +	       (entry->ecx & __feature_bit(X86_FEATURE_WAITPKG));
>>> +}
>>> +
>>> +static void clear_waitpkg(struct kvm_cpuid_entry2 *entry)
>>> +{
>>> +	entry->ecx &= ~__feature_bit(X86_FEATURE_WAITPKG);
>>> +}
>>> +
>>> +static void tdx_clear_unsupported_cpuid(struct kvm_cpuid_entry2 *entry)
>>> +{
>>> +	if (has_tsx(entry))
>>> +		clear_tsx(entry);
>>> +
>>> +	if (has_waitpkg(entry))
>>> +		clear_waitpkg(entry);
>>> +}
>>> +
>>> +static bool tdx_unsupported_cpuid(const struct kvm_cpuid_entry2 *entry)
>>> +{
>>> +	return has_tsx(entry) || has_waitpkg(entry);
>>> +}
>> 
>> No need to check TSX/WAITPKG explicitly because setup_tdparams_cpuids() already
>> ensures that unconfigurable bits are not set by userspace.
>
>Aren't they configurable?

They are cleared from the configurable bitmap by tdx_clear_unsupported_cpuid(),
so they are not configurable from a userspace perspective. Did I miss anything?
KVM should check user inputs against its adjusted configurable bitmap, right?

>
>> 
>>> +
>>> #define KVM_TDX_CPUID_NO_SUBLEAF	((__u32)-1)
>>>
>>> static void td_init_cpuid_entry2(struct kvm_cpuid_entry2 *entry, unsigned char idx)
>>> @@ -124,6 +162,8 @@ static void td_init_cpuid_entry2(struct kvm_cpuid_entry2 *entry, unsigned char i
>>> 	/* Work around missing support on old TDX modules */
>>> 	if (entry->function == 0x80000008)
>>> 		entry->eax = tdx_set_guest_phys_addr_bits(entry->eax, 0xff);
>>> +
>>> +	tdx_clear_unsupported_cpuid(entry);
>>> }
>>>
>>> static int init_kvm_tdx_caps(const struct tdx_sys_info_td_conf *td_conf,
>>> @@ -1235,6 +1275,9 @@ static int setup_tdparams_cpuids(struct kvm_cpuid2 *cpuid,
>>> 		if (!entry)
>>> 			continue;
>>>
>>> +		if (tdx_unsupported_cpuid(entry))
>>> +			return -EINVAL;
>>> +
>>> 		copy_cnt++;
>>>
>>> 		value = &td_params->cpuid_values[i];
>>> -- 
>>> 2.43.0
>>>
>

