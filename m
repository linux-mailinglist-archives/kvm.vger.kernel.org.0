Return-Path: <kvm+bounces-26480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C579D974D8A
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 10:55:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 39B8F1F239BE
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 08:55:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22FCB185B70;
	Wed, 11 Sep 2024 08:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hgs55CtE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD17183CAE;
	Wed, 11 Sep 2024 08:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726044760; cv=fail; b=j0/NGYq5v64WUVu3IoxELsgBx7P4QOEwColtL9HIMHrCN7DMzgwJsMdBMW6D/Hu32fqM3IOef7NZm5HBAPN+4VYFeR7f0mIlQ50yHt0MCfTrMbO95sdpR1TVigUccB9O7Psda8rKYQqEz4opg+HINnn+a9nkqbDfO9GBFJyORNU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726044760; c=relaxed/simple;
	bh=EFe9xCfAjYXRur/KuuUXJUYmiI7DrZvWla/ncCxcLl0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SXdD1zHT4EQs241BdilyXrYqOSTW//kJp8UlNO9jCAa8bA54sccjwMBoVpzxMDnh1OE2l/ZlLPeEk24ywVhH0Ueq9Uu/PicAf+A8WaSLfmO82zhbWKyab/iEOJk1vq8gNZrRa6WegheEAQ0bBajlkgm1MgvS+0q2SQzYaAFgnHo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hgs55CtE; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726044759; x=1757580759;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=EFe9xCfAjYXRur/KuuUXJUYmiI7DrZvWla/ncCxcLl0=;
  b=Hgs55CtER9F0LhoxlDl3/3dMztGrUKoPzbg5g76Mozki3B3YVIENqcNG
   XvY29VvuwBVpoa9G9WhQDrjVajn6XtejcSiwpQz9fesI/4ZNzI2W4hGc4
   TSYSCrybHY2JZRh/ReczkASnald99QdLVN53U0vxTOAj3hTmnRs5cz8Yf
   zSmdEBRAG2aaD4EjMDYRr/7riLS6DxVGKk+CCW8NZMwKVB3H7xrAMAx4O
   ZB20dXwBDLMAksGhIYVJiiICNf/jHpfRiExVO4ehOKMgpMzajKPlBlMzN
   drYhDLqy1wHq864bPd1bDnNGyjCPZx8GW8IJnJb+lKkNsQFr9kFq8fG6A
   A==;
X-CSE-ConnectionGUID: bVV0FvXdRDu54oX+ILDLIw==
X-CSE-MsgGUID: PuUQCHlCSbGSp4wXXdIqew==
X-IronPort-AV: E=McAfee;i="6700,10204,11191"; a="28608544"
X-IronPort-AV: E=Sophos;i="6.10,219,1719903600"; 
   d="scan'208";a="28608544"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2024 01:52:38 -0700
X-CSE-ConnectionGUID: w9oyzb5yS7iGoJUho87+rQ==
X-CSE-MsgGUID: PMkqRC+tRgGBiyz48UkM3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,219,1719903600"; 
   d="scan'208";a="71436128"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Sep 2024 01:52:37 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 11 Sep 2024 01:52:37 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 11 Sep 2024 01:52:37 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 11 Sep 2024 01:52:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JHzhPObcUdCDjOhZMW8pEEpUuHq/oQ4moY7FpMFm2YXbYLkG5hmOsDEucWR0ZZ/Lr7TSPleDG9CHpOD3yoPsgPrZcAIqxQt0/JC1cdR4hKbHeayByFy8zhN+3ltz6EsesOSEi4SsPbU9bTQkRokFK7Jks9Sh43up0cf5aZCEdSEL4Q1IFerMeGv0mMWyeGdD2WZPGvzuSw1evvKLX727u3hKrbb7VFu8UQap5Noax1sTjuYpOUR/kGG0e8vfOcZ82yXQr5BqPPr1e9LJ4gmG8wjf8d3Yz1QqtWpAwMUu2WClhxiM9XMBZ8HiHGWegmbEKXpp84s59UMuxzg13j48+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/uGq32DmBdg+sY2WWu7ab/5vl275H4dO/LTnb1GVm/Q=;
 b=dQDSAxg6JHYW8MA3CO1Wky3KT2XJvFXjH1ZQxIG8MqMwAuzH4zCbB3ty+yS9WP8L08tN6PeYGLTbL2LYZbkNrc45+9ZRTKXnaLZGnIhSer+9ZlNvG+DOtUAs69WlG//NPpkbJGWtUirpoMKNLDkupR/hpYEtEpXjp5h0wmgdY3Hp7oVsuA+GwRzWV2Nb0V6x4ol6fImsYYd2TpvA8rqZoZqYeKqGnEhPCJLGPvgyNywemzSXCs0aYt6gbUEYxuj7yU339Nd/34D1BppUMwJBdX3gOgSNcvh880dg8kl4p1t6OnrNSfECbznQnUNncWWzu4i+aDg/9OuSO/v4wy7k5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DM6PR11MB4529.namprd11.prod.outlook.com (2603:10b6:5:2ae::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.17; Wed, 11 Sep
 2024 08:52:34 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.7918.024; Wed, 11 Sep 2024
 08:52:34 +0000
Date: Wed, 11 Sep 2024 16:52:23 +0800
From: Chao Gao <chao.gao@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kai.huang@intel.com>, <dmatlack@google.com>, <isaku.yamahata@gmail.com>,
	<yan.y.zhao@intel.com>, <nik.borisov@suse.com>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/21] KVM: VMX: Teach EPT violation helper about private
 mem
Message-ID: <ZuFaR0xiGITjy0km@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-6-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240904030751.117579-6-rick.p.edgecombe@intel.com>
X-ClientProxiedBy: SI1PR02CA0008.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::14) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DM6PR11MB4529:EE_
X-MS-Office365-Filtering-Correlation-Id: de6b075e-c479-497a-8735-08dcd23f1436
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?hVef0H2qSWxGdq1P125Dy/d/wybWYmObkRUg/70efrMSp8kk+df8vLv7bfMn?=
 =?us-ascii?Q?WTPVqQwD9uG8USvz/J1LIf/n9yZbjiM3SOwkHH01BZddHpOsBCzAPowXAI74?=
 =?us-ascii?Q?Ppn8YlY+FOWknUZS3a2x79YSrng4fkRm8gAAyitNNtvu1NPEDDlY1zBx/I/r?=
 =?us-ascii?Q?MDaWPCUbKgctIPQsOhhP+O/BScYAsw2caB+n2M0kyTHOkHhibqomIrjMH0yW?=
 =?us-ascii?Q?yGLLqIP7kyZTdglg3yrG9T9l3sRwyI7H1RCHAemXNdnqJKiq/+ds6QVhMo4k?=
 =?us-ascii?Q?f+2XG/k9GAt1V/j/RXSWQljyyQtWlzykDlsjqG3LlJOu075EYxp+BXx8MTGn?=
 =?us-ascii?Q?8FHXlEjqp2M9TNaIAo99c4+5flVvmtsklTxmwSjDf+2uCmolAwuXhNUOk/Pq?=
 =?us-ascii?Q?yR8qPxQAa33XFOo+KyfrAR7BUilAAKJMq6k//U2WMfJROTQ0rEnvJUkHzNZe?=
 =?us-ascii?Q?fDCpGJmtZCKdgYSU2GA8GUH8vXIsBbNG12oQkdCqh3ufElUNWGYVcfRy8f9s?=
 =?us-ascii?Q?4u30AqMHY7g0kNPjuLe2ltyn4+Hh+czRe+vsBywQD1KDe4e2gaj83hY3BRNq?=
 =?us-ascii?Q?/OocRMgy9IVEJYtRSSEhD7uW56kSIlgiHPrnb1KvqwLR9BvH8G4Qv14K04pL?=
 =?us-ascii?Q?ZjvIHPnJy56KSN/yVS4iBtwGhLCJo6ASUsWMp9fYaCDoaBqzPKx77IffgA/D?=
 =?us-ascii?Q?tVlh7ZBSHZjF4F3fE9gig4/WsjkWrdifMxdU/oh5mYazpBiPmjCVJZszKM+3?=
 =?us-ascii?Q?PXhd2XKG4/GalyvlXt36zgSGVEsQR+7C2LXa1hyWkz00VQDfIVi10m+YGnDY?=
 =?us-ascii?Q?cTzETqAFnIIZLsVKuz8WacqkSDvbTRmuJL/LDn/YI7pdkSe43VewvHZX/+z5?=
 =?us-ascii?Q?aZSULitvzq3RL9GYqOjmadXV5kpmqCg5xienM7g3pRmseAsSCb82EkSJFbei?=
 =?us-ascii?Q?BIUgPrB2mnuycsRTyjAspqOEqMyDPASozjo/H4towieXYPKJ0E0FQ1ZhU+Gl?=
 =?us-ascii?Q?bjX6AjuBu3HfECiPbhan9L3qXc+BQTIEn9gCEOZJn5r+FlBx4XGNTnbA05bG?=
 =?us-ascii?Q?BF+cXBXlWrW5n46oy0AubZjRn88duqw49shOAOcRggIioxPlWK4Bg/cNABRQ?=
 =?us-ascii?Q?5ST4cRr8XCYw5l5W2WEeM1X0kmX6PFM7QjEgj6+m8Fmoe09t4u2lE/7gbBd3?=
 =?us-ascii?Q?e2lGzFkc8ddh0q+gEhHovCZAJ6yOE0zt2Cai22jEs1I103E4X5eONOg2sTab?=
 =?us-ascii?Q?o8UJaK2y5k87MapfYCwbJhQHGAb3GSMmLiqZpbTzhz60Efw47gSLl1uaat0z?=
 =?us-ascii?Q?UkM6xR0oVShjk8eAoJf76QepRLenZeD3OCtd/CnIKvMSNg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kCExLFJcPT/FTjbTlLRwCYwHy1QVuOAWf1Q8+dzunHuJnwdt00bAWYzPrZcu?=
 =?us-ascii?Q?C8mAJXkf9gcW41YD2COaC1rJa/sJydnoLQICLL/q+OkFJbLn6UbCXteV8ecs?=
 =?us-ascii?Q?j6qlHe0SXv1azMZLtt+16tpabCf1TvAdF+RJMlA8kRkzDL2BQpNgOZ4rgvVt?=
 =?us-ascii?Q?UHGgd9kNld08CiZPkrJw49Pi6hZGzfK/bDZLOw6VJ+cesv4hOgUmB3OQCdZw?=
 =?us-ascii?Q?gRSxvaH/Unmk2EYzVCoozwuxzVFBW6MhReuYur08RdAvrU44bEUEt2ubwAf0?=
 =?us-ascii?Q?TSYJdXQ1PE7Va8HIfeqGDHlQXWgMaoDuGVuUMrR+s7AwH48n6RRmA51m0D42?=
 =?us-ascii?Q?IcJG5XMQRywFZVTpwQp08NbB4KkxgIX+Op8mG6foGmk4bwAvlzfX35fhm/CN?=
 =?us-ascii?Q?XdOhHIywShcy1/G+JoePZvxm5/EbY8DGcvHol0wqyzd5UFrVHo8dm1SoM5VT?=
 =?us-ascii?Q?ZE/x6JD1U5JDpjNdZ99uM6ymUPfhhYEZm9nbNuwNJ/jgjsTD3KXUxA1YhEGn?=
 =?us-ascii?Q?ZL+ZYDje6sw9vTCmxpzPyUbkZ8aEf4N+W+e/0RApWLOqbEYh4yfAj6FFrtpq?=
 =?us-ascii?Q?Qcc0jy9gJPa8TsgDxfAn/K6gROo7yJ3syP2EUhwdZj5RnNz0iZu2fvXBmFVl?=
 =?us-ascii?Q?RdKNkFWvDy+wAbzMefp3r5ax40hJJthok81KKKziMjaElxWcPCX4LhsMsD2+?=
 =?us-ascii?Q?DSgfT88Pw6tt8opyHN3n6w2nTpkdprc1NyclWfbkcR62G5iYmhEns8nKTegL?=
 =?us-ascii?Q?uvy9CnPdOb8IIp68vsgL8glfg77Xeg93jZI5R9P2yTQR1gSE9+sJ3FsYIvF+?=
 =?us-ascii?Q?x28ka7qNYWCpFlDbcGdc6wR+GcF7YJeYtZJafcHQQgRu1Ytpx73/AWYhgz9B?=
 =?us-ascii?Q?wAEEbKVLs1AJcGwaFnyVlIQ1bnEdc6S4ktcCh7184VULu66sLmAU/Uz6RRGA?=
 =?us-ascii?Q?f1NWKaoJLRaFfPnDMqV0HQNx3vzg01EN6KR7YXbxZqRha53CWMn1ol8Uk63n?=
 =?us-ascii?Q?6uY5PnFip1DU3gDVW6E+ibzMxwNAhuV+vh4Dq/IW4LkkXlJVOVpndJJOn0ea?=
 =?us-ascii?Q?GTQ6j7Wvh/LabS4m9sPgwHmL7/4Eofoh9FBlwOzQ72R1ZyH61QWlCOGmrLz9?=
 =?us-ascii?Q?SmDNqJfG3PXsIGRs4i2gY2PWJghUU3fJJY1UITVRJohmmnilNkN95Gtj8IGR?=
 =?us-ascii?Q?PJ0W7imRA4OO8P664rujZnl11r+aP11W4UHL9zvwjfSj4S+9Kh90esmzLW0j?=
 =?us-ascii?Q?0to8ENIN3uiB+ke3UxL86HpXvqMTnzRiQn01BKMGufuUgZHshYj3q+yBMmqU?=
 =?us-ascii?Q?RS9pRltUroa/Pdtsn7KBLCSjschRKuAISnRJDOOVKUcuW7zjyBRPrvb+AlxB?=
 =?us-ascii?Q?Fk1YwbGg4AX9ruQ0AxGmfzjCWwLCYgKf9UxNGsfKBr8spLL+LXLrgLGOoY9P?=
 =?us-ascii?Q?BThiqGIu2DsyhijYMDcaTgiTOdlY9THlzSSR+2gBXGxaq/vddk28finVUtVI?=
 =?us-ascii?Q?G5Alpl4Trd9Bh65ahE+L0QcFbvTXNrSO0wefDN3ZfDU8HDV1lNkh6Wbdl121?=
 =?us-ascii?Q?jxPkQq/a3Rcfr0oKWTMWYPXgJTKhtiu70uYHP3aZ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: de6b075e-c479-497a-8735-08dcd23f1436
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2024 08:52:34.6809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +iUQjz3RmvVYrp2JcgP/EboHPbLD042n6HJVQzRvqBiVB3MO1zz9XP0wvO2JpcZ3bIrJSk3s8Zni1e9vzm/XiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4529
X-OriginatorOrg: intel.com

On Tue, Sep 03, 2024 at 08:07:35PM -0700, Rick Edgecombe wrote:
>Teach EPT violation helper to check shared mask of a GPA to find out
>whether the GPA is for private memory.
>
>When EPT violation is triggered after TD accessing a private GPA, KVM will
>exit to user space if the corresponding GFN's attribute is not private.
>User space will then update GFN's attribute during its memory conversion
>process. After that, TD will re-access the private GPA and trigger EPT
>violation again. Only with GFN's attribute matches to private, KVM will
>fault in private page, map it in mirrored TDP root, and propagate changes
>to private EPT to resolve the EPT violation.
>
>Relying on GFN's attribute tracking xarray to determine if a GFN is
>private, as for KVM_X86_SW_PROTECTED_VM, may lead to endless EPT
>violations.
>
>Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
>Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
>Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
>---
>TDX MMU part 2 v1:
> - Split from "KVM: TDX: handle ept violation/misconfig exit"
>---
> arch/x86/kvm/vmx/common.h | 13 +++++++++++++
> 1 file changed, 13 insertions(+)
>
>diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
>index 78ae39b6cdcd..10aa12d45097 100644
>--- a/arch/x86/kvm/vmx/common.h
>+++ b/arch/x86/kvm/vmx/common.h
>@@ -6,6 +6,12 @@
> 
> #include "mmu.h"
> 
>+static inline bool kvm_is_private_gpa(struct kvm *kvm, gpa_t gpa)
>+{
>+	/* For TDX the direct mask is the shared mask. */
>+	return !kvm_is_addr_direct(kvm, gpa);
>+}
>+
> static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
> 					     unsigned long exit_qualification)
> {
>@@ -28,6 +34,13 @@ static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
> 		error_code |= (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) ?
> 			      PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
> 
>+	/*
>+	 * Don't rely on GFN's attribute tracking xarray to prevent EPT violation
>+	 * loops.
>+	 */

The comment seems a bit odd to me. We cannot use the gfn attribute from the
attribute xarray simply because here we need to determine if *this access* is
to private memory, which may not match the gfn attribute. Even if there are
other ways to prevent an infinite EPT violation loop, we still need to check
the shared bit in the faulting GPA.

>+	if (kvm_is_private_gpa(vcpu->kvm, gpa))
>+		error_code |= PFERR_PRIVATE_ACCESS;
>+
> 	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
> }
> 
>-- 
>2.34.1
>
>

