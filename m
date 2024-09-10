Return-Path: <kvm+bounces-26183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A11F9726BE
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 03:54:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A19701F24342
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 01:54:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DDD413C9B3;
	Tue, 10 Sep 2024 01:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OByMDnsA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9581042AA4;
	Tue, 10 Sep 2024 01:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725933269; cv=fail; b=B5aqkW6dAtd30nuEnzXV8npQW4QG0TMa+iUld0SW43nHcHUhSwWZmR5dekUW8jRwLatNLUh2p4JlB7uIooFr/j/FO4u9Utng7X5C+sy5lvlMvAaDvvVvSZn7/yFtn9GK5JboFCYkOHjP6H/8va3p5pmryLHKKguApBvo/nlem1c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725933269; c=relaxed/simple;
	bh=DaBNEUSmt2HQsbdrerlV1NMPcUxtMxRCI9ZU0HlfI6E=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=O9QxwUCvr7iNia2JPvTWoBnFd91jdTg7JxUbAzvsMs59hBg5OIZcR2lROPOMSmG9epDOFeiRLj5WNG/PxA4mQfuIbvo27nSNjq8sRdcDieisOcJIF0peKjXFckz1lbnxWPZ8SB7vx+34svmYdihsRwaPx5CRmTZFijaixa2lhpo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OByMDnsA; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725933268; x=1757469268;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=DaBNEUSmt2HQsbdrerlV1NMPcUxtMxRCI9ZU0HlfI6E=;
  b=OByMDnsAVs/aL/bUpWEbjkcXbaeqVH5XDVxQoEsFCroKUuay/sPEh/VQ
   SLDTF4B1sAuLMBGc0DhqTiXOeHZmIoHiSp8UZqmpikRDYFT0nTidMsC2q
   73D2x67buXZkh2VqsMZCSvmzr0BF+Nh/ZQLWAjX5KU7Cu69h57CH1oYIy
   +ecwvx5pDqdi3JZCQR8Im6AtuX5ClFdYZeyYV1YgthA+eSTkb1TeysTNZ
   l/T/onlETViI4w7zKiQgvTaXJE1SPsGLtOoFjkIyxn3NRVJZoOQywx+GD
   AvSKgzXb8dzBrHA3aGCRjVvT7N/al+baSJrVi3+lUlG03kchHYsUS/QRm
   w==;
X-CSE-ConnectionGUID: BYM3DfnZRjiATJ2ruBVDsA==
X-CSE-MsgGUID: 6Fmn7lAJSIu0QkGyYZp0xA==
X-IronPort-AV: E=McAfee;i="6700,10204,11190"; a="24160096"
X-IronPort-AV: E=Sophos;i="6.10,215,1719903600"; 
   d="scan'208";a="24160096"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 18:54:26 -0700
X-CSE-ConnectionGUID: 8SU2Mws2SGeKF+Bt6+3+ww==
X-CSE-MsgGUID: I38xrkt3RCOuWvwTRtIF7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,215,1719903600"; 
   d="scan'208";a="67115658"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Sep 2024 18:54:25 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 9 Sep 2024 18:54:25 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 9 Sep 2024 18:54:25 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 9 Sep 2024 18:54:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lPfenq1pxuQxFXmD9yttrnnYLVBH67Lo0qczI0blQfdWAwQHRpmhbtM/hxohPW7aW2vJ05LUYC+yBi6Std+1MhWEs6Y4tHUPgGjiJOvIf2MTjByT6UQgJEZ4Ukd/v5oG2Jc2QSXF9YcbwyYVxQpzg4aZHWxCHCXoxTCkKfDPKE5SAuwgvmnkYW88YdoMjx95vKfQJiq8y2fWs6ZaDvS3oFeCSSWVyZowRMVYAFsebZbA4BNoU4xjIcVYpserr6piPqmC62deCUsjL+QTu44LCRU1M4otldoSp6g2LQZufhEMhQhHMFrEtpK1boAHVK8ZC2S9BnndJrN6/0Ufdb5PgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rt+B97+/HigvrkgMHkqEs8ILEW8pPcrUCFingJuYJLs=;
 b=UG9mFbNuBKfqOm6sCWVO/E7Xv6vkMCh9RPZ4hUdK6mNumF1k6W8jX3q6YqJy5eix+TP2nYRSvto+sQVl781Oz61JSCHjjil1ToNJ3c1ZI2zAZwmOtBfAkBQft6/aeHpzTpNm0u7v/Iaq/z/AavZqc1N26S8DpARA9MVoMufg9Lj1+bSpPEkKJgaytE9EMwDJqf2Kx2ksrc57j0lQaG8N05NvpFaTt1GJPSR77Kes0WQemB8YuQLhQ4RxnljKhZ+YQj02wPbFZtDL1KNJoElwSQwrnPFU3YgVxQnIIyC/QzcqWaVohMKtRfiNIGynzd8xcy5ndijgLKV+VBQ7FsVhxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ2PR11MB8452.namprd11.prod.outlook.com (2603:10b6:a03:574::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.20; Tue, 10 Sep
 2024 01:54:17 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.7939.017; Tue, 10 Sep 2024
 01:54:16 +0000
Date: Tue, 10 Sep 2024 09:52:20 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/21] KVM: TDX: Implement hooks to propagate changes of
 TDP MMU mirror page table
Message-ID: <Zt+mVAn1bnv/CxlK@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-15-rick.p.edgecombe@intel.com>
 <5303616b-5001-43f4-a4d7-2dc7579f2d0d@intel.com>
 <a675c5f0696118f5d7d1f3c22e188051f14485ce.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a675c5f0696118f5d7d1f3c22e188051f14485ce.camel@intel.com>
X-ClientProxiedBy: SG2PR02CA0075.apcprd02.prod.outlook.com
 (2603:1096:4:90::15) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ2PR11MB8452:EE_
X-MS-Office365-Filtering-Correlation-Id: a54639bd-0535-410e-8044-08dcd13b7a4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?7k8I8YT5czBHNYT+Y9EhK6rUUnqm+7b9pkbcKFrYx7fpIHvXmqg864OUOX?=
 =?iso-8859-1?Q?tRAgWDRT+h7S8R6Oy3KAHnSSISRFjoLJnEN/kv1Mevk6MxyQq1VgoVO2az?=
 =?iso-8859-1?Q?SpCucnrLK72OkYwfCkWE4+OeKYLBXui5XnsUqgosfDMa4f7KvIRlQXnH3B?=
 =?iso-8859-1?Q?FRewevH2O2HXWi+nx0sj8RQWE6c4+LecRXKQ7ZGxcPDi2GVfz8iI4ZYhbC?=
 =?iso-8859-1?Q?RqK6xP4+6rzFbheXWKCJxuBTSn4O5Vu/S1kgh2QQlP3nnh+kCZV2XnHvpG?=
 =?iso-8859-1?Q?uRIV7hviowio/6D2NPeK7BuUEHBoKMd1LSSivoCl1y8fney547F+uiHLWz?=
 =?iso-8859-1?Q?CIf0Mb0DxCL4rcq7PoImGnMxBH/ax6wUXH3Yrd0BQUqYWxwrlGP6drx49/?=
 =?iso-8859-1?Q?jPrl70nmURMI0u6e0xMRbVWtLwmWjY88NHkXaAgJB/+tp4u59vxYh0M02i?=
 =?iso-8859-1?Q?WO34lS5YBNU8IhmaY8EcTouXvk54WsS1okZT0K3Dpq3tXlMdioTmKBL/FA?=
 =?iso-8859-1?Q?qmazf1jBulj/g0XDU8NfDdt/N1Eke44jJqsKfLM2ZmaeAfD9iETI52wuDE?=
 =?iso-8859-1?Q?k6PbTeMtHShL7+nYZZYY2gBP+j0o8tgI6lqmTqm/gUOLbHd7NeiOcGtzvV?=
 =?iso-8859-1?Q?Mwsrkp50XNVu5hsa7qdOL5gdgXUKFwJpM9nfTxYqsvz8K9JA0vvpIl0Rc2?=
 =?iso-8859-1?Q?vjrML66FtA6JJRByZVGLEOCzJnJtT8e35trzJN20/vHO3BNS1cEnJYCap/?=
 =?iso-8859-1?Q?VRC7YN/lZnqhvhE/itiooutznyCyqdntL0aj3L7/O0tgmu8luwQ9nZdOt3?=
 =?iso-8859-1?Q?rWyxz/nfVNzfKaFLNsk32XDLbO7QN1R9YOBedUOslnOWWUok6NIkBVQ4WU?=
 =?iso-8859-1?Q?H+bowTtql4ngplkg+hfwnOsuVyQpdc76JIrGW0OL325nqSWX97s20nGPvm?=
 =?iso-8859-1?Q?v72ZNjt6Ao4HBUMBwc/rWG8icYINT9TAJYFMh/BKGGvMHZj8PW42x+mw86?=
 =?iso-8859-1?Q?65+d/t8CLoANcjAa8oJbFA2lzLUNZGBo1NUuGFnEEpO9sMX3kE1DbK4I48?=
 =?iso-8859-1?Q?EKOrH0Ovpyd2ozxIO02Tij+LcrFlzPpo1BEmcnMJl647etH9b3JuuQ+iCI?=
 =?iso-8859-1?Q?4JYXC96MWvXh9KBAhAz321/YES1vxRHtsb+W1BT5Ub5p9jfoCGc2V/JX26?=
 =?iso-8859-1?Q?k7kZHke7+hhSYbedXl9R9mr5mtVQAZzrtYQ7mzcTwM5MfxPuoLjM6DwyUG?=
 =?iso-8859-1?Q?nLfFp+QoLlklupdrYPHvkMMNNcvRJGzfOKSLk18mY7MpZOG7TQPot7cOCN?=
 =?iso-8859-1?Q?/dIcJ4Jsai/fczLgTbmpoUIIyx4XZ4Y/OpGG4EQGm0BQZJ2gORNjY322nU?=
 =?iso-8859-1?Q?ZX6aygmUqLuD9gFO3flLJqJxD6kWmHTA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?4ZfaycIpXnGf70JNak2nsh080qfA7uqu957O+69ehY7Wg8AoA21/KvwPwI?=
 =?iso-8859-1?Q?O4nV66KEpo0RdCWooR4/LG2VlYTQ1bEgamq3RmrU91GmLr18exizdvJBij?=
 =?iso-8859-1?Q?VLHIz6P8xZa/+gctCQK8HTxXWUZpc2cN8bnmeOT2GfcY//11N7D3QN7T+6?=
 =?iso-8859-1?Q?ymjh4BepdV+FvxOMtlv2wyiHTMHkJjSY9UzezdToIvesPAtZ2Sc4qJ7cec?=
 =?iso-8859-1?Q?OyHio/U3U4lfKTeO0MUJ8I16JEAROnvLE5PwQFMR612hMOZiAvuBeLtO57?=
 =?iso-8859-1?Q?mSwQGA7kjrwrJwq41VOIi4/9LGn139OUXJwln40rM+dRPEc4zE7rAB60L5?=
 =?iso-8859-1?Q?lo42Zi+g+FXuD0UurfZKhUjcgIQNWPjA4wM1EvGiqbnDIeTpVDZ5OzMQef?=
 =?iso-8859-1?Q?1VIn6SkMxo/X6pf1P0O8pyE/b/tkBrxGvr3Vdjub/ekg2P/QoNcF0Odxuh?=
 =?iso-8859-1?Q?fJZzHEEMjc+XxtyMVSoZOyb6FSfcfb8qaiUka8Qqatg6HUnnXfHBhc8mN7?=
 =?iso-8859-1?Q?W06Ic6pSDY32r/O7PZX3Fu00GqebXxZzDdWL2sl/00whfeeRN+/mg0qU7u?=
 =?iso-8859-1?Q?vngpfwRgaaIwCovmnIlLArbUoPoohzAzfSd3A8JSFgz+0gqfjR1mo4KV2Y?=
 =?iso-8859-1?Q?Lpmulk2xj62h+YtNBJuKtcXhfwKbbSSdkET6H8IgEkKtHltoAaXoxYBxoV?=
 =?iso-8859-1?Q?5hr4ykrt99RUka2jYbOziwz/ydGCj8K5pqQ9DMY1Ihac49CRkks/TTq+wK?=
 =?iso-8859-1?Q?z8Hd5bTQvkW7Jd0DHyxVCfNsHWvyFTwJDQmPAN0OAS7QvoxxtbKg8YIOUa?=
 =?iso-8859-1?Q?eAMctTE+N/xZVQGRRC4TufKmHKSb3ac7ykZ1O+O0KvwmiFz6F1BIBadZcP?=
 =?iso-8859-1?Q?K0/imEMazs+1HB55GfQ/KwDAdwQfIjjmXA0d99sZufdYCkg238fvffrvtE?=
 =?iso-8859-1?Q?3r6HEAOkkUaikw2kRa1Ixd6FT+IOzIZca5vcTbm/3Zdc2v7Kd2OAWDD/rL?=
 =?iso-8859-1?Q?tdMtgZd8B0YNsEo0QC935VTkJF1gRhhGo1VXANkXe1Ts41hRm6OF9e7P7W?=
 =?iso-8859-1?Q?gTLobZjqjY36raMaQSByZDg9uC9qSq2FsvMlcbouJ5x7LpWlpdFvFxc2Od?=
 =?iso-8859-1?Q?SgCtP3qc0EcC6iFGLAO+K9G8qTmNXiBwFb9SNXCRdlGZ7/+qk4nNuWcFAZ?=
 =?iso-8859-1?Q?zfw4ljdwHqRFEFd98j9hFwMu3+yrymXysORU3hWjrmOJk0oUSiPJnJBhKk?=
 =?iso-8859-1?Q?Q9te9aoWoVoZkGeAR2ob1FyZs0wJSHUudDIEsk0Nvlpg3Zvr5D10MMPM+z?=
 =?iso-8859-1?Q?La8/HGZEpgrqxN3/2dgkK8uoBq+wO2ZIfmNiJAumVlamtSoY6icXw5tewe?=
 =?iso-8859-1?Q?FBQcYISI6V30QR/D7Tu1EK5BidY1d5GE17BvpRtzrW68R83SpF4P0eWgAq?=
 =?iso-8859-1?Q?l/aI7JpNCoU3wnPbX7OI3IrppoJSsIkLybUU8oEVcP4hkILaJKaRqL6Rir?=
 =?iso-8859-1?Q?+FQA4WlQggeSReJr0cwkIcinm+PB3R3IiIkoz5vIqo2ejZslfGPy+IvcLN?=
 =?iso-8859-1?Q?rA0CHBLHCHsBfsP6XlZSKBvBi5/eQ7gKEjPaPXnWJjiHuUht0l9SEvaeHG?=
 =?iso-8859-1?Q?SOnDnCx2op2QdPPyQUVw+2Navt2NeN1CWG?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a54639bd-0535-410e-8044-08dcd13b7a4c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2024 01:54:16.5891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TmZg/juyn4WZKx1ctCXFcEQb12XvqN1+ucY+b7caIvV8XbB/tayVBMJHHrrc2hWC62wTwlUWC0f01p9JmEHaSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8452
X-OriginatorOrg: intel.com

On Tue, Sep 10, 2024 at 05:03:57AM +0800, Edgecombe, Rick P wrote:
> On Fri, 2024-09-06 at 14:10 +1200, Huang, Kai wrote:
...
> > > +        * which causes gmem invalidation to zap all spte.
> > > +        * Population is only allowed after KVM_TDX_INIT_VM.
> > > +        */
> > 
> > What does the second sentence ("Population ...")  meaning?  Why is it 
> > relevant here?
> > 
> How about:
> /*
>  * HKID is released after all private pages have been removed,
>  * and set before any might be populated. Warn if zapping is
>  * attempted when there can't be anything populated in the private
>  * EPT.
>  */
> 
> But actually, I wonder if we need to remove the KVM_BUG_ON(). I think if you did
> a KVM_PRE_FAULT_MEMORY and then deleted the memslot you could hit it?
If we disallow vCPU creation before TD initialization, as discussed in [1],
the BUG_ON should not be hit.

[1] https://lore.kernel.org/all/ZtAU7FIV2Xkw+L3O@yzhao56-desk.sh.intel.com/

