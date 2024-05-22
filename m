Return-Path: <kvm+bounces-17916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F19628CB9C3
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 05:25:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A8005283556
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 03:25:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B1F856444;
	Wed, 22 May 2024 03:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XmCs1z36"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C585234;
	Wed, 22 May 2024 03:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716348319; cv=fail; b=EDAXf6sp0lHXUkY/Cp7fltBxX4HO2igGP/S1wDwhBiM0yd3NF9pCZHB/zAIH1y0swctJTBwFRMt1UyGBWNy2jSptvPwp2fQVKxV3oRPFLit8xFCesJGMWrBvP71cU0DQUEKNIg4fAwrWYu/42PA0VQRb2KdsmabQHv5LqvHiLT0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716348319; c=relaxed/simple;
	bh=nFbj1Adlpmea9J9FdSV6sBnKbCv317gW2FnnMHgvZRU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=C/TZXbft0VhQyUYMaJFvRMvoIvB2XIIVJw70L7OEiZG8vSbSGBnEzWUXOKdb5yY9ovAznM5N7yiWH/f7muSzML1uo8US4hxvST7NzSJBWKcq+xjXYflK94I6+Hsv5SCtwg/eStLIPOOtR3FPmdVMSJrsfVZW801eJ5fzsyjjvl8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XmCs1z36; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716348318; x=1747884318;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=nFbj1Adlpmea9J9FdSV6sBnKbCv317gW2FnnMHgvZRU=;
  b=XmCs1z368pzI3df862lUFbae/FO+XqoGaIPRkFL+fVWsMAI0UK87kk7k
   SWzgRyETzvaObP03sfuALz0pHm9GVr6IDancr1rp/pVWZy0THzGWiF4a8
   T/ae+LX9QQPBeK7Z1qT4LE28BEExZsNhljfDDXPiMrPqpWJkUovwyKBH6
   TMKzjqthnhglKCSLLeJX0L7tkU2ytUdlF3J1hoQ7AguO8OuQ2JiC+0luS
   EFXWPD4LE0QGf8iwGrvXi9fX7EbtmnrNz+PjD4MXnSLkjlRxuhcrrWvja
   xOpETyRRV0yoUX/N4aqVcbZnUB0/+pbfGKoRZbfBQYf6y4HfhjJtIOtD0
   Q==;
X-CSE-ConnectionGUID: WiHlXrmdRsWk4FwNaE2AHQ==
X-CSE-MsgGUID: onT7BPlATWeAWlc6IvoUnQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11079"; a="12423327"
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="12423327"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2024 20:25:17 -0700
X-CSE-ConnectionGUID: yICBUfeeQDC5pPz2bsE6Qw==
X-CSE-MsgGUID: Qu3wyz3yQXGAltbNd93TXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="33005052"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 May 2024 20:25:17 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 21 May 2024 20:25:17 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 21 May 2024 20:25:17 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 21 May 2024 20:25:17 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 21 May 2024 20:25:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jzsydYFZ3NYZT4fyY1VM0ZEvxuZsDtNaUGpZNUoH5IFd7cr8kuv+yvcsVT7fRhH1+ICbHtkfzGahsF288CFuT5kuOl7WcsrauWJf3NKXUIfK/E6iPqoApZmLgnmlBCh7nHW1RC8D3W7KSeepKrD5i1qyvSvR1V7tXxOhTVQy8pwBD31ea2ou48f/pVCygpfx56PoPRznTM1pz+IJzAvxAHhJVW+MpmBn6UBFLShIzFFDBvCTd7+SVhcSwIMY7D3wuSMimAqq9VdvBodKtAXy5DrCHkNtcmDCXhtMuCGlNgxXYeMa4ta427FIxYHxWiI7NY9nLQBxka0xt06ctys89Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hdIbOGtUHtsM+/46l75xdKdwHHPM9zSnS4ykC3CXnns=;
 b=CllnYdATqq1i7yaCt7KGMLz1o1OnSubK/Yqx284UiuGXtYBubizpCN1Tp8B4eHbH4XgMy9b1hlhq95KDNY2eeBU+QpbtvDij4LbKrP71SI7BcA62YgUU2cQlD51+nDl/chx6o2TM5DXI0wbsxp+/wVLgnh1kVfFdvkzvC4azCpJ4wLfYlC4CcoRurRpROgz1+M4/Od0j9y148hqztfxrVLrNAZXk84mZRB8Aof+syUFphi9MUZ14TiKFqGoXW3+NueRmiqNfGqcsLyziGpx/DMTYQOZQ/NAB9W4iDXE1OOb29SMpMmZnzF5ZKO2u/f/PTF8ELugXsGeHFNL6cWdbQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH8PR11MB6903.namprd11.prod.outlook.com (2603:10b6:510:228::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.36; Wed, 22 May 2024 03:25:12 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7587.030; Wed, 22 May 2024
 03:25:12 +0000
Date: Wed, 22 May 2024 11:24:20 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Alex Williamson <alex.williamson@redhat.com>, "Tian, Kevin"
	<kevin.tian@intel.com>, "Vetter, Daniel" <daniel.vetter@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"luto@kernel.org" <luto@kernel.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"hpa@zytor.com" <hpa@zytor.com>, "corbet@lwn.net" <corbet@lwn.net>,
	"joro@8bytes.org" <joro@8bytes.org>, "will@kernel.org" <will@kernel.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH 4/5] vfio/type1: Flush CPU caches on DMA pages in
 non-coherent domains
Message-ID: <Zk1lZNCPywTmythz@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <Zj33cUe7HYOIfj5N@yzhao56-desk.sh.intel.com>
 <20240510105728.76d97bbb.alex.williamson@redhat.com>
 <ZkG9IEQwi7HG3YBk@yzhao56-desk.sh.intel.com>
 <BN9PR11MB52766D78684F6206121590B98CED2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240516143159.0416d6c7.alex.williamson@redhat.com>
 <20240517171117.GB20229@nvidia.com>
 <BN9PR11MB5276250B2CF376D15D16FF928CE92@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240521160714.GJ20229@nvidia.com>
 <20240521102123.7baaf85a.alex.williamson@redhat.com>
 <20240521163400.GK20229@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240521163400.GK20229@nvidia.com>
X-ClientProxiedBy: SG2PR04CA0190.apcprd04.prod.outlook.com
 (2603:1096:4:14::28) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH8PR11MB6903:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f5f9af5-e9b2-4bdf-63b5-08dc7a0eca63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?bsatbVM0OVxGu/bSh6fn/CEsLY/oWKHvyP4qvsClVuSjtpp3SZ7RhY35xYtY?=
 =?us-ascii?Q?Cw1RKkptTZJ8kKgB8cRp9uNIs6GkHu5oXffTzn7/730kNIlU/PeaSq1KsNKc?=
 =?us-ascii?Q?vd+bDMUr5+boQMyu5nGmkrzVDY8XACF8YEAnPHY8r3UHFV6e4OYtti+pdnvm?=
 =?us-ascii?Q?5yL2nHNKQOpwvBqMOisaLsW5f2chiBXe1uYROsnEYBSRmlrd3ptBLYs9lvoG?=
 =?us-ascii?Q?0KUAH/91CgQJyzKB6XGWNMR/J/8gN2mSY5ecYPLDI8XWXwuokyxOxbYlwPqn?=
 =?us-ascii?Q?EYYfJ0+MXqaqWVSl0pA7MyE4++bcPGx9c7SqR5RaSyenIvB6/zpmnpAhlAs2?=
 =?us-ascii?Q?GMbeiOUBkgvDiJ7xNOVlU/77MuQjjHA3r7mHZBFkC3OFLp5BDl5R01tvTsW3?=
 =?us-ascii?Q?vEqbRDcvqILogYK4tP59iLStIaEf/jXk4GP1M9hFvyJP4x4j/mlJDcolinvT?=
 =?us-ascii?Q?euHTOnnF47z5IZMPu9T+FW/QkjntM25FOAgHOUlqQdfPZXAGlQZZK/P9TPCN?=
 =?us-ascii?Q?bhzcYH0AdpaK+V9KH3w/tc2lorKFrVAFVygK/aWLPCls6OCpN+M/muYt50QM?=
 =?us-ascii?Q?kEMN6xSpzlRwTvFGGxuHWeMIMGr9tb2VNlxU3kwlh2+4CO3Pzg2Q/XnmSlT8?=
 =?us-ascii?Q?P+Gna1KThTx8CS3o4r7oyqF8WHsK/o49WMsuttFf482CBAm+xbvL3QGApAIe?=
 =?us-ascii?Q?SAbdqpNdTk5FRM2qJ3DhoMAV7ccR1B81rUFEEt7pYpLEr22torayV5aXVdhF?=
 =?us-ascii?Q?JZbVLsObux41Expe27Ygf2OrSCJIRbqffJAEiMBE8WtV6zGiy1EtGWe5u3cX?=
 =?us-ascii?Q?VI/0tx713H2uXMvLJC+TBNlzcdikZ1HPeylxEZWTHdnEwnVBGl8MbXI7xCvu?=
 =?us-ascii?Q?Mk7p39XsAzgH8FXxNKOLW/Wu3wuNZWPKrOo9PCdW8LuYCa2ot0azAGuli6IA?=
 =?us-ascii?Q?LYFTSM6u92/X6xv++ozRmtuwwzwGGOrWHO1go34f6Qr/INGz5v4tQkKBQBo+?=
 =?us-ascii?Q?hORh9UYcTbZ22GVyRo9qNkScgQZnCyhCAIW6oxdNL4DSL4h4b1ZFVHJY6hnt?=
 =?us-ascii?Q?p6q6k4CJdHNeWkxspwZCTRpPeWEf982NyAXvLwdr/kyZn7ICz19EsK4Of1e8?=
 =?us-ascii?Q?3AGfXDKAl/v3h5aIA+7e4RvNgu1Ajs0nbG0vOO9wnQzNOLRMxdHA+u9lLKdA?=
 =?us-ascii?Q?RCj+uBIJs6aaeYvSNnhBu8VTOxZlNxoT5XXU4FugdRO9NXkS22ItRsbXY25G?=
 =?us-ascii?Q?GSlSavlfyl1vzX6SSsQNZ1LUEXa6DvQF+nY8UtbJhQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9zjrcEANPTTU7eoxBVtzOU50JQe8TNDMHj9/0epyly5fFsRxD+BTgZCE5J3v?=
 =?us-ascii?Q?77B8RTqaHyP0lZHwI5ZubVPHwC6d6FpqmMz5vJ0rbGaAIJcEbbD7tLbOO/1A?=
 =?us-ascii?Q?bliI/GMsRZrh0DUluF58kBdPUA0Kaq2cXxylQ2S23LvdbWfdULlM2udKo20a?=
 =?us-ascii?Q?t73EIUFKRzFYmpZPIFtHZqJ28X0/B+q5cro2vLWcm7i25nIdiJDhtAFOrU5A?=
 =?us-ascii?Q?OVhHyC26lI0J7YakMFvBGZ/nUQmRL/z7+lV9uXDMp1GrckBxf2HVRX/5qMgk?=
 =?us-ascii?Q?qQcEfhStIxm3Oq/WPif57GUefGVJX+ZjgFiutD21b2iIGM7IDUNMkEC79M0V?=
 =?us-ascii?Q?0nm3592MyFeplGVTf7jRzsxt1rxbNM2VsABK+kLBY5GFR86/tgaRKjVJ+pBH?=
 =?us-ascii?Q?G/1F5MYFgtFzjA9ekwVQvflguRGJuRGLS2brQrroHrIp3SnsDaryJ17ZMoxk?=
 =?us-ascii?Q?sKpUGDvmqRkajW1yQE31eG2A8fCKYgkOcd7JGFqsuUawyiAgHRCv8BXiaG0H?=
 =?us-ascii?Q?PwL7CJeEnDbEdCwTD9HqsXQUMyS1rIK/zh23KTn/yKHD/W5zILU5YfAmkFQW?=
 =?us-ascii?Q?DSxF1wTyiCSukQlLo97z4IHkhZQP4lroCpgblEm8Y7Pr411dJ1v9pfQP9FaM?=
 =?us-ascii?Q?tqV3KwSKxRKQ1Ruv1SlTKrAjFuyFTgoGjIZFL9k2KSyQ0f9xlADbUo6goQXV?=
 =?us-ascii?Q?KgInSzxxPN9AKbBpEDTcqC9kypfA7ytWEKfzmto+ANIbFfjSaFoBSYdz/ECk?=
 =?us-ascii?Q?2r683skWYMgvJEbM4bD1XjUGKV+RK3otFpcWVmTQUukc5Uy6eGxu10TNQnF1?=
 =?us-ascii?Q?FAg6o5aUJLRgg6Kxj3qgoES/cGIiObR2CHwQz1aIXkhCEoBC7Ap7ofNg5l+8?=
 =?us-ascii?Q?Or+otUJfuF/021TURGGDe+/BI6eRV3+S1Cn/lLWrawr4F7fWFsv+2aZKH8HX?=
 =?us-ascii?Q?lOPdvqqlaG6H24faNRaHnLISj2q/w6pPOaVk23crhSkXJuDyJCGg2drvixxx?=
 =?us-ascii?Q?Mfzt8bqCLdBA4soNMzlc4aQtXGTLcL5pyXOfO/dU84d9yyEF1iabC7cpXkaL?=
 =?us-ascii?Q?+zcxRGTPWLdAsBa1exPNgF2Zwd7mEQUlVM7Y4/N6/2gjJONVqf6N0KkZQXGL?=
 =?us-ascii?Q?Fwhsvu57zg+rdjtNxIsopskneJxPBDVqBj1uj46CoFruNS+9hPDaPDdZj+yq?=
 =?us-ascii?Q?GuWjJ0L5RUvKuMERzM29zGvXLGPL4g8p6TSw/k3RmCA2nOTJWhLXP8j06SEq?=
 =?us-ascii?Q?9+pf6ayzOYFAJbA35t5pIXOSdplwK3snSSIpazNh0d1DaUQq4ZE84ym3CTLh?=
 =?us-ascii?Q?eQ8rHEEMY1pXa/l75tIkh9HGm1RBQz8lrvrwxkcgN9o8EnFES/f7K4ox9RuL?=
 =?us-ascii?Q?/sdSWt20/ByS1A0hxQp7FZ6RQ1c9y/W990X8xxvUZzV54+kSn0od6LGutJTn?=
 =?us-ascii?Q?NzwmYCCAoap3/12qLHcG7ccjotdM/fiHEg+/yrG7znfr2p6LW6ND25r90z5C?=
 =?us-ascii?Q?VIVtmDLfU6FPu3nzmSMDahxfCH8DOrmB1RNywqUKAcTWfMeny87iS78Kk0wr?=
 =?us-ascii?Q?WS19rgR/N7DO54PLebLGRqmXLBj1+ceH3oFNmghn?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f5f9af5-e9b2-4bdf-63b5-08dc7a0eca63
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 03:25:12.4706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4+Jyv/5WrjKFATA1djyz1T9vU+3SNQrwg8f2R/MoFVT7mJkwmoSUubXgiaA1vp+yGyPlSwpkGgzQtjGP37IRxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6903
X-OriginatorOrg: intel.com

On Tue, May 21, 2024 at 01:34:00PM -0300, Jason Gunthorpe wrote:
> On Tue, May 21, 2024 at 10:21:23AM -0600, Alex Williamson wrote:
> 
> > > Intel GPU weirdness should not leak into making other devices
> > > insecure/slow. If necessary Intel GPU only should get some variant
> > > override to keep no snoop working.
> > > 
> > > It would make alot of good sense if VFIO made the default to disable
> > > no-snoop via the config space.
> > 
> > We can certainly virtualize the config space no-snoop enable bit, but
> > I'm not sure what it actually accomplishes.  We'd then be relying on
> > the device to honor the bit and not have any backdoors to twiddle the
> > bit otherwise (where we know that GPUs often have multiple paths to get
> > to config space).
> 
> I'm OK with this. If devices are insecure then they need quirks in
> vfio to disclose their problems, we shouldn't punish everyone who
> followed the spec because of some bad actors.
Does that mean a malicous device that does not honor the bit could read
uninitialized host data?

