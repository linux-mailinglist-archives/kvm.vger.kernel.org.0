Return-Path: <kvm+bounces-33319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B2269E999F
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 15:57:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B6CB18872DB
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 14:57:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A2461C5CCC;
	Mon,  9 Dec 2024 14:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mFTYMJ75"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB331B424E;
	Mon,  9 Dec 2024 14:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733756151; cv=fail; b=fmfssoWterovTti07I2U87dkGlUFdHh8zgpqZfZ2h3DLj4E5VJU5kTTFP6d5DBFpLkmR03SQrA0M8Wh+7uxCM8RrLT4IuvTzFHC+GWHrWRDuSUqjwSatZOwFkF14bjGFIJcqt7UCP6mTmgjgJ3Wnpjoh2RVbhoBj/xEgvoYYoAQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733756151; c=relaxed/simple;
	bh=2Z+Vs3c4ibCod8k1+WENIP0ZnlbM81d0B0hTAOAM98Q=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=DSQtLvcgMjUoWliXx3gTw1cKG/6rtZrol/x1+jKb7oUbwzc2A9FfKSRkAPGvxg3z1zY+tc8pYl6uMilOVecNWqP9Re+B6l9e8tKuo8KTP+MohPO9rxr8m4xwZ8VprZU6Nb5capk/YaAp+dg+Fi+8TsTomCyc8hWgo0NJQ1PMxVg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mFTYMJ75; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733756148; x=1765292148;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=2Z+Vs3c4ibCod8k1+WENIP0ZnlbM81d0B0hTAOAM98Q=;
  b=mFTYMJ75aYeYWB0xj+82w6eqSrqfHhu5k7EKH4RmjUZl2kKmymF4YwAH
   luybWtNjQ/gkaKzyyye3ZWBfXGCEwDJ29hxp8telxcolHWFDJWl8IYM85
   aB1oBTK7FBEw5O4qSLh0CSdh7nt3oFisyu0JOcPdhGyZ0Cdg7xUGH9LuH
   PhuBjmFW/mJ46GO6hRz06FNV0PICQNF6Zz05X5DPwOwZfWhZkch/ycyip
   2fMWJSHpgamCWdXKUjJVuR3ofDRzCV2wqRV/aPiOo3JRsjT5gmwrb1NS6
   6Ye4zU9ORDEOv6IGv+8Uae32AeanIg7zQ9cwe/KY3l/uNpdt4amEDpBpQ
   w==;
X-CSE-ConnectionGUID: QKAPKcszRH65xnwiKH6Cww==
X-CSE-MsgGUID: ht/fnoesTquR+XWJOCNMHg==
X-IronPort-AV: E=McAfee;i="6700,10204,11281"; a="34184414"
X-IronPort-AV: E=Sophos;i="6.12,219,1728975600"; 
   d="scan'208";a="34184414"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 06:55:47 -0800
X-CSE-ConnectionGUID: pqCs7P7WQHS4oplw1rMUfw==
X-CSE-MsgGUID: /ewLxjV1SyOUdxbNsIEE9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="100123570"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Dec 2024 06:55:47 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 9 Dec 2024 06:55:46 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 9 Dec 2024 06:55:46 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 9 Dec 2024 06:55:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XzWOraFniUltFqt4bPC94ktw74grpW1KrOuygwLYYK57m/ikQJ/4qsP5JP8KDhwlPWK2wGji0NuVlRkpbpld9AGstGSNHaqEg20ua0q+LW066GTC877Rc6W6sde2DslKxnoPELpG9CdJ9AvP/UzjPpJIZ97ry56wMVoPLVelYxKsuTOUBhzCwPjrgC5ncflSZptQv+CNn77k/1B1hDbT4SVWynsqncr34EGoifkMJ0O/sANVLfr75Wk3+YVejFUzS4swWvZ7NVRIiJPc6L4u3/GNu4lAZuyCRewc/AEAIKP62SQgUnGHcCje6GpJ7qfj4xDjEExlxLrmXARbXEhH6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MraUcmK/WxnXDXT5G3o0uv3ZQRhyEtbOlFcq6e5Cl4A=;
 b=atdiJI5g3iaXZMIJGhnjDCevfbtdF3l5itKbmT0r2EtvS2nOrPmZ3MLdxYRGW7VxZDr5wtjVV7dTrGuvGACeUbkArqhy8LyFb1zS2ZdUhNiyVJwoN7uZn9BQ6Kgz2C2Aen/k2PimXrRn/o+gxeH1qUgQrIyXBK1Emp5dfG/9BzoLzmmalfaMVS/RFZe2tv1BURb2WNsYmnB3mn3aMyu/Mq+8BaHi8qpy9z1YLCZtbM0Pio092V4YTXzDxHEv/r5LAvEcfxRKLR9Xj/GUUHZIzAsHMhGNlKWHDNsGQcNfFlCW4Tub6018k/9Oz7iPeki/znk3tKDIt3fNIeF/iK7Ynw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by DS7PR11MB6104.namprd11.prod.outlook.com (2603:10b6:8:9f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8230.18; Mon, 9 Dec 2024 14:55:42 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%6]) with mapi id 15.20.8230.010; Mon, 9 Dec 2024
 14:55:42 +0000
Date: Mon, 9 Dec 2024 22:55:32 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Tejun Heo <tj@kernel.org>, Luca Boccassi <bluca@debian.org>, "Sean
 Christopherson" <seanjc@google.com>, <kvm@vger.kernel.org>,
	<oliver.sang@intel.com>
Subject: [linus:master] [KVM]  d96c77bd4e:  stress-ng.kvm.ops_per_sec 11.1%
 improvement
Message-ID: <202412092202.7aae9e89-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0010.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::17) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|DS7PR11MB6104:EE_
X-MS-Office365-Filtering-Correlation-Id: 29beae1c-cdc5-4e09-4ec2-08dd18618d77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?g2+TuhQZxB1xDY4m78ARtbnRFFoM+qFm6EwYtN4bC50Tainn8XJwLlAe18?=
 =?iso-8859-1?Q?sCXSz5k54zjQ8XicmXtd7AInDf/IFFE/5KtX/3RX1QYQDzCv0OK1Z+suh5?=
 =?iso-8859-1?Q?DdErTCsX4qST/ZkrQd7w53Dx0KFnn2b3Koj97+AJeJCGYpZs5YSxnhA/GA?=
 =?iso-8859-1?Q?fX8LtrZyx3a1vIrKz1HszCayPL/faVC4KChxjx6CQPpbBpSCoK8neN2yfc?=
 =?iso-8859-1?Q?+AmFlaC40SecfZIutrDZJpnOo4/FPzU2/JYlMbgxIAONCzJwTrnksGFXkC?=
 =?iso-8859-1?Q?QZfY1um87FuvuRdvWTN4jrryAoE+ilRw2ReZtouYd4/P87qORzK3axgWNj?=
 =?iso-8859-1?Q?0Oz+bG7VF/saSv8o0q/O8i0Nu/bFcwf4MnY6wAfA1XoqnxL/hDgE86cS77?=
 =?iso-8859-1?Q?0jGzoW/crUbI4wg8yCYfVlXccYx/YYJSv7M16ucbqlFOF0AQ7gFCk+ZdyF?=
 =?iso-8859-1?Q?Sq4+trt8AmO8s/h5wNcQBeG+1YbGsxvWXEjD2myiUzpZbI+pE6zF8LzCxN?=
 =?iso-8859-1?Q?U5w8wh0HD2ryYg3QaEU/4DA5cRP85+Du/h3zV7vLx9lAgExDXxL87s9IvB?=
 =?iso-8859-1?Q?G3qUg5fr87L9UVlDGBuakWZUL+XvApv3WNKex4kZb291/au3n2rI1hp0hL?=
 =?iso-8859-1?Q?XEAfVK7lrtWsCWlBgSMnnkQFLyLg6v6NYG6xJ30jEf4OjiEYv0h3ck2Ye9?=
 =?iso-8859-1?Q?hMwQ8O7p7/je5UCySxQ+RwGDqkEfN9NXSpkY6xOS4fYhVGewdMv6kGwEpP?=
 =?iso-8859-1?Q?BjnSQEDKvVaVVztanfk6UVO7rglyu56l2a2dJ/f99chfrlRtvIwWKhdiuZ?=
 =?iso-8859-1?Q?OffyK3qph6ybC+uAaP/zVYFc+At+BlMYb57PSyJrEUVWHgt0p8OsbE5YLz?=
 =?iso-8859-1?Q?T/RSWfPHHKYP5iG5DwE1IoEtHkd6/KhA5agbJFmpUxMMnu34y/aRcWliLT?=
 =?iso-8859-1?Q?FmxNgvhDNMZ7BoP+pssvhwbdYKUB1f75YDuGZvvX4yUOYh2NqeOKkIzc8t?=
 =?iso-8859-1?Q?5UArM1o+kpYr9w4ExVe/LRq5HbyLGFDYuQk/T9ZcHd1xFIE8uf2Pcyxnk5?=
 =?iso-8859-1?Q?fl7tNl3tjpqkErSS/vWB0XIi18qQT9B7M2o4sGOtNxFvNct+Iy9NLBUdbS?=
 =?iso-8859-1?Q?Xtv41mpmQLnfRzLrA+hUJi+QUycnzcsZtVFJWYxdcOWFvUpkHbxSEjUxp0?=
 =?iso-8859-1?Q?xyZM5RcsspoMCjd0O4r6i0VmpMKrSMihn8BqboeUNoJ9hWtieAQMqY8NUY?=
 =?iso-8859-1?Q?tX7ldOpHqOjMzgZjw8pEvKvF3M9O0n+1mDcGeWpEC3Tt4phq13I4TGppGb?=
 =?iso-8859-1?Q?PfLb2N2SRHn/BWtGCxasEFgvNg5b89Bmb28RbeAnsRb1EfWwE9Bx4EQ8xF?=
 =?iso-8859-1?Q?kPt7+A3jbfuqLN4Q29AHCEEZxrpcq7IUsmYHidpE9GyRoo3DwgZE4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?+fXnyDXhlhhOqQf4yTXLCKIso/Jy9Ve0Ch4OEhlwE07yMyokVSyTqBEsOs?=
 =?iso-8859-1?Q?d4xarULmeglKGxvKiAYxCgRHZYKWu2JnsCtDpezvFL1cd+WNOH9UomJM+y?=
 =?iso-8859-1?Q?fZzjJGIAxGOUb6tapiyL79StyUwLkWk5CEhnmVy3gbSEzv5ZCKJ+qCFlgV?=
 =?iso-8859-1?Q?KlxDVB78M+FCehwFVCoWWRSavGfr9J366iLg+/V8IkmvbK2PgUFdVOVoeR?=
 =?iso-8859-1?Q?GWPSWNp6unpOoJ4DGok10sSA9PjkGyfLFe/zQEh59+deuCrRr6BsSSaDfS?=
 =?iso-8859-1?Q?neL+v7gLcuQZE+X0EzLyGX5BWspBdkqNFiBOLZgejk96LRRu+NYlHv78T9?=
 =?iso-8859-1?Q?RavVRFwkJSivTw84kHHwzS6kU7V+ki2suhsg2/4BlYEULTs+bPUhqKT0Ow?=
 =?iso-8859-1?Q?1zemhkRKjb8UWlL10FM1IEQjj6yBgtmzH6x88mVgI6zXHstYn3NTR+Uifh?=
 =?iso-8859-1?Q?AM31TB+HbyaBY9Ga1rTg3i8z9Jzxa7aPxC21WYb23iSAT/9ZZcomL0SAc3?=
 =?iso-8859-1?Q?SgC5p6MYE2xy2HgrGC6OruqsEBQDj8TtPlZhd8kfE3IGCN1HaofmzZiYPz?=
 =?iso-8859-1?Q?rWIwrGtlJMiprtXY4W8n8Uro7toMJUrj17kJsl0xgHGcRqC5pSjoDabb7T?=
 =?iso-8859-1?Q?osWXlRcBJELbfZYHTR08AILweR7HZYzLcHMDsoW3gBvWDi1460JqMvmL9P?=
 =?iso-8859-1?Q?NPglAV9PaAbqPifPWrv8+4bxvz6VWrtFWbbpA2uUzbnrqQqH2Mly7J/M1M?=
 =?iso-8859-1?Q?bJz5nMAuj1CCc4clKixKDstR/YvbPLNRKaAbk2VnoDdNAQiFVP4L5QzIWO?=
 =?iso-8859-1?Q?YEk9nZ+OhfrnDdexVxqAvAgIGGphZXMfwfACrHQ4Z9aggo2Y0pV6sDU/Kb?=
 =?iso-8859-1?Q?CYOfYvpC67YLOhUlbSyMHlTVbrH5aWHIV9gQNmewp1NRIGgmm3pt7zFkOi?=
 =?iso-8859-1?Q?vk2Gd8CxpoLtBixF2LEmdg6+UVxDtzoje/M/XgpRjK0cFo1V8XHAvEhB9b?=
 =?iso-8859-1?Q?Tg9As4ISWwhxZCGs5FK7enE3uqoDPYqeIngU6jQKTST73QczXcgAyUHzoT?=
 =?iso-8859-1?Q?DzhC7PHdaDn41pKRAQ6Ia4DigNNZ8RLxLgExIDr5T/lHCAKPvlMp9BwIHX?=
 =?iso-8859-1?Q?2wMcwY3Ay9XR9ZpsjuemaEEWsgB8117pxCjPK4gvBMA78+RInJhWGb8TrN?=
 =?iso-8859-1?Q?mW3MsYFjqx8oH8cCGLSr0ldGc+NKRAgFUg7rpD+JWxJrPd0GU897QOwsiz?=
 =?iso-8859-1?Q?L9x0+8HyqZE11PeJCqWiWGcXFuPLbRZWVHiaRgu5RTIsf5Zam1deAXZZ/A?=
 =?iso-8859-1?Q?RkoHo/uJ7GFEWSo20FCx6o1Z3IPBD35HIr35dJnPxF4deIJd/2BL6DIUtz?=
 =?iso-8859-1?Q?sxwpAXLedZdtcSzZMWQFiwMQBt8D0B5Cah7L3vZTFJSwo5233zPYtSnyBi?=
 =?iso-8859-1?Q?YEvF89Q6kRn+ftxNofIvT0AB7F33iuix7d+dz8tAVZWNal+CWlOx/5cNvh?=
 =?iso-8859-1?Q?pLdRpZCTLzwzv+tJwa6lRKHR9yTYCIGMfX0NeRSWLcTZ9oRDkEXF/CbUaa?=
 =?iso-8859-1?Q?2+EeUr5BM7WItOLy0DWSfWTvuR7a4xcrw//RN8E7KBQviVAYqlmmcYKJ+m?=
 =?iso-8859-1?Q?6nxTocDpJpQh54O3THqqKKY1yIgJfWF7ju01kh7AicWSpg1U1OJUR1iQ?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 29beae1c-cdc5-4e09-4ec2-08dd18618d77
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2024 14:55:42.5220
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WAg3u7CWei6+onHhxbxhLg1qqDVXCrEa6Sfv1RyuDmYeZmskEFoQO/03yptiXssa1bnZwiCbGKFVQk3FgENXag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6104
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed a 11.1% improvement of stress-ng.kvm.ops_per_sec on:


commit: d96c77bd4eeba469bddbbb14323d2191684da82a ("KVM: x86: switch hugepage recovery thread to vhost_task")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master


testcase: stress-ng
config: x86_64-rhel-9.4
compiler: gcc-12
test machine: 64 threads 2 sockets Intel(R) Xeon(R) Gold 6346 CPU @ 3.10GHz (Ice Lake) with 256G memory
parameters:

	nr_threads: 100%
	testtime: 60s
	test: kvm
	cpufreq_governor: performance






Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20241209/202412092202.7aae9e89-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-12/performance/x86_64-rhel-9.4/100%/debian-12-x86_64-20240206.cgz/lkp-icl-2sp7/kvm/stress-ng/60s

commit: 
  0586ade9e7 ("Merge tag 'loongarch-kvm-6.13' of git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson into HEAD")
  d96c77bd4e ("KVM: x86: switch hugepage recovery thread to vhost_task")

0586ade9e7f9491c d96c77bd4eeba469bddbbb14323 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
    723877 ± 16%     +35.2%     978789 ± 10%  numa-meminfo.node1.AnonHugePages
      1442 ±  9%     +17.5%       1695 ±  6%  perf-c2c.HITM.local
 2.528e+09 ±  2%     -11.6%  2.235e+09 ±  2%  cpuidle..time
   3569356 ±  3%     -21.0%    2819592 ±  4%  cpuidle..usage
     64.52           -10.9%      57.49 ±  2%  vmstat.cpu.id
     23.34 ±  4%     +30.1%      30.36 ± 10%  vmstat.procs.r
     13939           -12.8%      12150 ±  2%  vmstat.system.cs
      0.79 ±  2%      +0.1        0.89 ±  2%  mpstat.cpu.all.guest%
     63.44 ±  2%      -7.2       56.20 ±  2%  mpstat.cpu.all.idle%
      0.48 ±  4%      +0.1        0.54 ±  3%  mpstat.cpu.all.irq%
     32.33 ±  3%      +7.0       39.30 ±  3%  mpstat.cpu.all.sys%
    443.20 ±  8%     +19.5%     529.74 ± 10%  numa-vmstat.node0.nr_anon_transparent_hugepages
    315827 ±  6%     +27.5%     402638 ±  6%  numa-vmstat.node1.nr_active_anon
    275814 ±  8%     +31.5%     362699 ±  8%  numa-vmstat.node1.nr_anon_pages
    342.47 ± 11%     +51.8%     519.83 ±  6%  numa-vmstat.node1.nr_anon_transparent_hugepages
    315773 ±  6%     +27.5%     402610 ±  6%  numa-vmstat.node1.nr_zone_active_anon
     17472 ±  2%     +11.1%      19402 ±  2%  stress-ng.kvm.ops
    290.78 ±  2%     +11.1%     322.94 ±  2%  stress-ng.kvm.ops_per_sec
     51303 ±  7%     +58.7%      81441 ± 11%  stress-ng.time.involuntary_context_switches
      2146 ±  3%     +20.6%       2588 ±  3%  stress-ng.time.percent_of_cpu_this_job_got
      1257 ±  3%     +20.8%       1519 ±  3%  stress-ng.time.system_time
    104856 ±  2%      -6.6%      97892 ±  2%  stress-ng.time.voluntary_context_switches
    278787 ± 13%    +126.1%     630300 ±  7%  sched_debug.cfs_rq:/.avg_vruntime.min
    227.71 ± 63%     -71.0%      65.95 ± 45%  sched_debug.cfs_rq:/.load_avg.avg
    824.16 ± 78%     -72.5%     226.40 ± 71%  sched_debug.cfs_rq:/.load_avg.stddev
    278787 ± 13%    +126.1%     630300 ±  7%  sched_debug.cfs_rq:/.min_vruntime.min
    222108 ±  6%     -11.3%     197050 ±  3%  sched_debug.cpu.avg_idle.stddev
      8649 ±  2%     -11.5%       7656 ±  2%  sched_debug.cpu.nr_switches.avg
    -54.00           -30.7%     -37.42        sched_debug.cpu.nr_uninterruptible.min
     15.65 ±  7%     -40.8%       9.26 ± 14%  sched_debug.cpu.nr_uninterruptible.stddev
    611289 ± 10%     +24.8%     763168 ±  6%  proc-vmstat.nr_active_anon
    558549 ± 11%     +26.6%     707278 ±  6%  proc-vmstat.nr_anon_pages
    761.04 ± 16%     +37.4%       1045 ±  8%  proc-vmstat.nr_anon_transparent_hugepages
     17892            -4.4%      17106        proc-vmstat.nr_kernel_stack
     48984 ±  2%      +5.9%      51878 ±  2%  proc-vmstat.nr_shmem
     43444            -4.0%      41719        proc-vmstat.nr_slab_unreclaimable
    611282 ± 10%     +24.8%     763164 ±  6%  proc-vmstat.nr_zone_active_anon
      5143 ±  9%     -98.6%      73.17 ± 49%  proc-vmstat.numa_huge_pte_updates
   2764317 ±  7%     -93.8%     172403 ± 14%  proc-vmstat.numa_pte_updates
 5.598e+08 ±  2%     +11.7%  6.255e+08        proc-vmstat.pgalloc_normal
 5.596e+08 ±  2%     +11.7%  6.253e+08        proc-vmstat.pgfree
   1071233 ±  2%     +11.7%    1196235 ±  2%  proc-vmstat.thp_fault_alloc
     74.39 ±  2%      +5.3%      78.31 ±  2%  perf-stat.i.MPKI
 1.724e+09 ±  2%      +6.5%  1.836e+09        perf-stat.i.branch-instructions
      2.13 ±  4%      -0.2        1.92 ±  2%  perf-stat.i.branch-miss-rate%
 6.151e+08 ±  2%     +12.2%  6.899e+08 ±  2%  perf-stat.i.cache-misses
 6.512e+08 ±  2%     +11.9%  7.288e+08 ±  2%  perf-stat.i.cache-references
     14247           -13.6%      12308 ±  2%  perf-stat.i.context-switches
      8.84 ±  2%     +11.7%       9.87 ±  4%  perf-stat.i.cpi
 7.365e+10 ±  3%     +18.9%  8.755e+10 ±  3%  perf-stat.i.cpu-cycles
 8.511e+09 ±  2%      +6.4%  9.056e+09        perf-stat.i.instructions
      0.12 ±  4%     -10.9%       0.11 ±  3%  perf-stat.i.ipc
     72.42 ±  2%      +5.2%      76.22 ±  2%  perf-stat.overall.MPKI
      2.16 ±  4%      -0.2        1.95 ±  2%  perf-stat.overall.branch-miss-rate%
      8.67 ±  3%     +11.6%       9.67 ±  3%  perf-stat.overall.cpi
    119.66            +6.0%     126.87        perf-stat.overall.cycles-between-cache-misses
      0.12 ±  3%     -10.4%       0.10 ±  3%  perf-stat.overall.ipc
 1.693e+09 ±  2%      +6.5%  1.804e+09        perf-stat.ps.branch-instructions
 6.048e+08 ±  2%     +12.1%  6.777e+08 ±  2%  perf-stat.ps.cache-misses
 6.404e+08 ±  2%     +11.8%  7.161e+08        perf-stat.ps.cache-references
     14002           -13.6%      12095 ±  2%  perf-stat.ps.context-switches
 7.239e+10 ±  3%     +18.8%  8.602e+10 ±  3%  perf-stat.ps.cpu-cycles
 8.356e+09 ±  2%      +6.4%  8.894e+09        perf-stat.ps.instructions
 5.138e+11 ±  3%      +6.1%   5.45e+11        perf-stat.total.instructions
      2.21 ±  8%      -0.5        1.66 ± 10%  perf-profile.calltrace.cycles-pp.common_startup_64
      2.15 ±  8%      -0.5        1.61 ± 10%  perf-profile.calltrace.cycles-pp.cpu_startup_entry.start_secondary.common_startup_64
      2.15 ±  8%      -0.5        1.61 ± 10%  perf-profile.calltrace.cycles-pp.start_secondary.common_startup_64
      2.14 ±  8%      -0.5        1.61 ± 10%  perf-profile.calltrace.cycles-pp.do_idle.cpu_startup_entry.start_secondary.common_startup_64
      2.04 ±  8%      -0.5        1.52 ± 10%  perf-profile.calltrace.cycles-pp.cpuidle_idle_call.do_idle.cpu_startup_entry.start_secondary.common_startup_64
      1.93 ±  8%      -0.5        1.45 ± 11%  perf-profile.calltrace.cycles-pp.cpuidle_enter.cpuidle_idle_call.do_idle.cpu_startup_entry.start_secondary
      1.88 ±  8%      -0.5        1.40 ± 11%  perf-profile.calltrace.cycles-pp.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call.do_idle.cpu_startup_entry
      0.65 ±  6%      -0.3        0.35 ± 71%  perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call.do_idle
      1.07 ±  9%      -0.3        0.79 ± 11%  perf-profile.calltrace.cycles-pp.intel_idle.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call.do_idle
      2.21 ±  8%      -0.5        1.66 ± 10%  perf-profile.children.cycles-pp.common_startup_64
      2.21 ±  8%      -0.5        1.66 ± 10%  perf-profile.children.cycles-pp.cpu_startup_entry
      2.21 ±  8%      -0.5        1.66 ± 10%  perf-profile.children.cycles-pp.do_idle
      2.15 ±  8%      -0.5        1.61 ± 10%  perf-profile.children.cycles-pp.start_secondary
      2.09 ±  8%      -0.5        1.58 ± 11%  perf-profile.children.cycles-pp.cpuidle_idle_call
      1.98 ±  8%      -0.5        1.49 ± 11%  perf-profile.children.cycles-pp.cpuidle_enter
      1.98 ±  8%      -0.5        1.49 ± 11%  perf-profile.children.cycles-pp.cpuidle_enter_state
      1.10 ±  9%      -0.3        0.82 ± 11%  perf-profile.children.cycles-pp.intel_idle
      0.54 ± 68%      -0.3        0.28 ±  7%  perf-profile.children.cycles-pp.ret_from_fork
      0.54 ± 68%      -0.3        0.28 ±  7%  perf-profile.children.cycles-pp.ret_from_fork_asm
      0.48 ± 76%      -0.2        0.24 ±  7%  perf-profile.children.cycles-pp.kthread
      1.85 ±  2%      -0.1        1.73 ±  2%  perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      1.57 ±  2%      -0.1        1.45 ±  2%  perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      0.34 ±  5%      -0.1        0.28 ±  3%  perf-profile.children.cycles-pp.vmx_vcpu_run
      0.22 ±  7%      -0.0        0.18 ± 10%  perf-profile.children.cycles-pp.ktime_get
      0.16 ±  5%      -0.0        0.12 ±  4%  perf-profile.children.cycles-pp.sched_balance_rq
      0.24 ±  3%      -0.0        0.20        perf-profile.children.cycles-pp.__schedule
      0.18 ±  2%      -0.0        0.14 ±  3%  perf-profile.children.cycles-pp.schedule
      0.24 ±  6%      -0.0        0.20 ±  7%  perf-profile.children.cycles-pp.handle_softirqs
      0.26 ±  5%      -0.0        0.22 ±  7%  perf-profile.children.cycles-pp.__irq_exit_rcu
      0.08 ± 14%      -0.0        0.04 ± 44%  perf-profile.children.cycles-pp.mutex_lock_killable
      0.12 ±  7%      -0.0        0.09 ±  5%  perf-profile.children.cycles-pp.update_sd_lb_stats
      0.12 ±  6%      -0.0        0.09 ±  4%  perf-profile.children.cycles-pp.sched_balance_find_src_group
      0.14 ±  5%      -0.0        0.11 ±  6%  perf-profile.children.cycles-pp.pick_next_task_fair
      0.11 ±  8%      -0.0        0.08 ±  4%  perf-profile.children.cycles-pp.update_sg_lb_stats
      0.14 ±  3%      -0.0        0.12 ±  4%  perf-profile.children.cycles-pp.__pick_next_task
      0.12 ± 10%      -0.0        0.09 ± 14%  perf-profile.children.cycles-pp.tick_irq_enter
      0.12 ±  7%      -0.0        0.09        perf-profile.children.cycles-pp.sched_balance_newidle
      0.12 ±  6%      -0.0        0.10 ± 10%  perf-profile.children.cycles-pp.__flush_smp_call_function_queue
      0.10 ±  4%      -0.0        0.09 ±  5%  perf-profile.children.cycles-pp.syscall_exit_to_user_mode
      0.05            +0.0        0.06        perf-profile.children.cycles-pp.kvm_skip_emulated_instruction
      0.22 ±  4%      +0.0        0.25 ±  4%  perf-profile.children.cycles-pp.__kmalloc_cache_noprof
      0.10 ±  4%      +0.0        0.15 ±  4%  perf-profile.children.cycles-pp.vmx_handle_exit
      0.00            +0.1        0.06 ±  7%  perf-profile.children.cycles-pp.kvm_mmu_post_init_vm
      0.18 ± 10%      +0.1        0.28 ± 13%  perf-profile.children.cycles-pp.mntput_no_expire
      0.35 ±  4%      +0.1        0.45 ±  8%  perf-profile.children.cycles-pp.kvm_destroy_vm_debugfs
      0.33 ±  4%      +0.1        0.43 ±  8%  perf-profile.children.cycles-pp.simple_recursive_removal
      0.33 ±  4%      +0.1        0.44 ±  8%  perf-profile.children.cycles-pp.debugfs_remove
      0.22 ± 13%      +0.1        0.34 ± 17%  perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
     95.03            +0.7       95.78        perf-profile.children.cycles-pp.do_syscall_64
     95.06            +0.7       95.80        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
      1.10 ±  9%      -0.3        0.82 ± 11%  perf-profile.self.cycles-pp.intel_idle
      0.21 ±  7%      -0.0        0.16 ± 10%  perf-profile.self.cycles-pp.ktime_get
      0.07 ± 14%      -0.0        0.04 ± 45%  perf-profile.self.cycles-pp.cpuidle_enter_state
      0.09 ±  4%      -0.0        0.07 ±  7%  perf-profile.self.cycles-pp.update_sg_lb_stats
      0.05 ±  7%      +0.0        0.07 ±  6%  perf-profile.self.cycles-pp.__kmalloc_cache_noprof
      0.22 ± 13%      +0.1        0.34 ± 17%  perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath
      0.03 ± 71%    +274.8%       0.10 ± 60%  perf-sched.sch_delay.avg.ms.__cond_resched.__alloc_pages_noprof.alloc_pages_mpol_noprof.folio_alloc_mpol_noprof.vma_alloc_folio_noprof
      0.02 ±124%   +1183.3%       0.22 ±134%  perf-sched.sch_delay.avg.ms.__cond_resched.__kmalloc_cache_noprof.kvm_init_irq_routing.kvm_create_vm.kvm_dev_ioctl
      0.01 ±104%   +2913.6%       0.22 ±195%  perf-sched.sch_delay.avg.ms.__cond_resched.__kmalloc_cache_noprof.kvm_vcpu_ioctl.__x64_sys_ioctl.do_syscall_64
      0.09 ± 14%     -33.2%       0.06 ± 25%  perf-sched.sch_delay.avg.ms.__cond_resched.__wait_for_common.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity
      0.46 ± 50%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__wait_for_common.kvm_vm_create_worker_thread.kvm_mmu_post_init_vm.kvm_create_vm
      0.07 ± 55%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__wait_for_common.wait_for_completion_killable.__kthread_create_on_node.kthread_create_on_node
      0.01 ± 85%    +173.8%       0.02 ± 36%  perf-sched.sch_delay.avg.ms.__cond_resched.process_one_work.worker_thread.kthread.ret_from_fork
      0.07 ±117%     -93.8%       0.00 ±167%  perf-sched.sch_delay.avg.ms.__cond_resched.stop_one_cpu.migrate_task_to.task_numa_migrate.isra
      0.01 ± 22%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.kthreadd.ret_from_fork.ret_from_fork_asm
      0.01 ± 23%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.percpu_down_write.cgroup_attach_task_all.kvm_vm_worker_thread.kthread
      0.02 ± 54%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.percpu_rwsem_wait.__percpu_down_read.cgroup_css_set_fork.cgroup_can_fork
      0.02 ± 37%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.percpu_rwsem_wait.__percpu_down_read.exit_signals.do_exit
      0.01 ± 11%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.schedule_preempt_disabled.__kthread_parkme.kvm_vm_worker_thread.kthread
      0.00 ±  8%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.schedule_preempt_disabled.kthread.ret_from_fork.ret_from_fork_asm
      0.02 ± 26%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.schedule_timeout.__wait_for_common.kthread_stop.kvm_destroy_vm
      0.03 ± 44%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.schedule_timeout.__wait_for_common.kvm_vm_create_worker_thread.kvm_mmu_post_init_vm
      0.22 ± 62%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.schedule_timeout.__wait_for_common.wait_for_completion_killable.__kthread_create_on_node
      0.01 ± 52%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.schedule_timeout.kvm_nx_huge_page_recovery_worker.kvm_vm_worker_thread.kthread
      0.03 ±137%    +872.7%       0.25 ±120%  perf-sched.sch_delay.max.ms.__cond_resched.__kmalloc_cache_noprof.kvm_init_irq_routing.kvm_create_vm.kvm_dev_ioctl
      0.01 ±104%   +6604.2%       0.54 ±205%  perf-sched.sch_delay.max.ms.__cond_resched.__kmalloc_cache_noprof.kvm_vcpu_ioctl.__x64_sys_ioctl.do_syscall_64
      2.13 ± 64%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__wait_for_common.kvm_vm_create_worker_thread.kvm_mmu_post_init_vm.kvm_create_vm
      0.99 ± 92%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__wait_for_common.wait_for_completion_killable.__kthread_create_on_node.kthread_create_on_node
      0.49 ±179%     -99.1%       0.00 ±167%  perf-sched.sch_delay.max.ms.__cond_resched.stop_one_cpu.migrate_task_to.task_numa_migrate.isra
      0.56 ± 54%    +305.5%       2.28 ±125%  perf-sched.sch_delay.max.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown]
      0.92 ± 56%    -100.0%       0.00        perf-sched.sch_delay.max.ms.kthreadd.ret_from_fork.ret_from_fork_asm
      0.02 ± 42%    -100.0%       0.00        perf-sched.sch_delay.max.ms.percpu_down_write.cgroup_attach_task_all.kvm_vm_worker_thread.kthread
      0.41 ± 73%    -100.0%       0.00        perf-sched.sch_delay.max.ms.percpu_rwsem_wait.__percpu_down_read.cgroup_css_set_fork.cgroup_can_fork
      0.04 ± 71%    -100.0%       0.00        perf-sched.sch_delay.max.ms.percpu_rwsem_wait.__percpu_down_read.exit_signals.do_exit
      0.59 ± 65%    -100.0%       0.00        perf-sched.sch_delay.max.ms.schedule_preempt_disabled.__kthread_parkme.kvm_vm_worker_thread.kthread
      0.14 ± 59%    -100.0%       0.00        perf-sched.sch_delay.max.ms.schedule_preempt_disabled.kthread.ret_from_fork.ret_from_fork_asm
      4.18 ± 15%    -100.0%       0.00        perf-sched.sch_delay.max.ms.schedule_timeout.__wait_for_common.kthread_stop.kvm_destroy_vm
      3.41 ± 52%    -100.0%       0.00        perf-sched.sch_delay.max.ms.schedule_timeout.__wait_for_common.kvm_vm_create_worker_thread.kvm_mmu_post_init_vm
    102.46 ± 45%    -100.0%       0.00        perf-sched.sch_delay.max.ms.schedule_timeout.__wait_for_common.wait_for_completion_killable.__kthread_create_on_node
      1.29 ± 59%    -100.0%       0.00        perf-sched.sch_delay.max.ms.schedule_timeout.kvm_nx_huge_page_recovery_worker.kvm_vm_worker_thread.kthread
      0.09 ± 32%  +49267.1%      46.08 ± 28%  perf-sched.wait_and_delay.avg.ms.__cond_resched.__wait_for_common.__synchronize_srcu.part.0
    109.95 ± 23%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.__cond_resched.__wait_for_common.wait_for_completion_killable.__kthread_create_on_node.kthread_create_on_node
    126.03 ± 17%     -51.4%      61.29 ± 82%  perf-sched.wait_and_delay.avg.ms.__cond_resched.down_write.mm_take_all_locks.__mmu_notifier_register.mmu_notifier_register
      0.47 ± 84%   +4864.0%      23.41 ± 56%  perf-sched.wait_and_delay.avg.ms.__cond_resched.folio_zero_user.__do_huge_pmd_anonymous_page.__handle_mm_fault.handle_mm_fault
      3.11 ±  2%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.do_task_dead.do_exit.kthread_exit.kthread.ret_from_fork
      3.73 ±  3%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.kthreadd.ret_from_fork.ret_from_fork_asm
     69.11 ± 15%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.percpu_rwsem_wait.__percpu_down_read.exit_signals.do_exit
      0.05 ± 36%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.schedule_preempt_disabled.__kthread_parkme.kvm_vm_worker_thread.kthread
      0.00 ±  8%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.schedule_preempt_disabled.kthread.ret_from_fork.ret_from_fork_asm
      0.05 ± 44%    +649.5%       0.34 ± 43%  perf-sched.wait_and_delay.avg.ms.schedule_timeout.__wait_for_common.__synchronize_srcu.part.0
      0.05 ± 25%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.schedule_timeout.__wait_for_common.kthread_stop.kvm_destroy_vm
      0.12 ± 21%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.schedule_timeout.__wait_for_common.kvm_vm_create_worker_thread.kvm_mmu_post_init_vm
    115.49 ±  5%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.schedule_timeout.__wait_for_common.wait_for_completion_killable.__kthread_create_on_node
      0.05 ± 54%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.schedule_timeout.kvm_nx_huge_page_recovery_worker.kvm_vm_worker_thread.kthread
    443.01 ±  3%     +16.6%     516.61 ±  9%  perf-sched.wait_and_delay.avg.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      1956 ±  2%     +15.5%       2260 ±  7%  perf-sched.wait_and_delay.count.__cond_resched.__wait_for_common.__synchronize_srcu.part.0
     29.33 ± 87%    -100.0%       0.00        perf-sched.wait_and_delay.count.__cond_resched.__wait_for_common.wait_for_completion_killable.__kthread_create_on_node.kthread_create_on_node
      1533 ±  2%    -100.0%       0.00        perf-sched.wait_and_delay.count.do_task_dead.do_exit.kthread_exit.kthread.ret_from_fork
      1295 ±  2%    -100.0%       0.00        perf-sched.wait_and_delay.count.kthreadd.ret_from_fork.ret_from_fork_asm
      8.67 ± 40%    -100.0%       0.00        perf-sched.wait_and_delay.count.percpu_rwsem_wait.__percpu_down_read.exit_signals.do_exit
      1532 ±  2%    -100.0%       0.00        perf-sched.wait_and_delay.count.schedule_preempt_disabled.__kthread_parkme.kvm_vm_worker_thread.kthread
      1533 ±  2%    -100.0%       0.00        perf-sched.wait_and_delay.count.schedule_preempt_disabled.kthread.ret_from_fork.ret_from_fork_asm
      1527 ±  2%    -100.0%       0.00        perf-sched.wait_and_delay.count.schedule_timeout.__wait_for_common.kthread_stop.kvm_destroy_vm
      1512 ±  2%    -100.0%       0.00        perf-sched.wait_and_delay.count.schedule_timeout.__wait_for_common.kvm_vm_create_worker_thread.kvm_mmu_post_init_vm
      1520 ±  2%    -100.0%       0.00        perf-sched.wait_and_delay.count.schedule_timeout.__wait_for_common.wait_for_completion_killable.__kthread_create_on_node
      1533 ±  2%    -100.0%       0.00        perf-sched.wait_and_delay.count.schedule_timeout.kvm_nx_huge_page_recovery_worker.kvm_vm_worker_thread.kthread
      1206 ±  2%     -22.7%     932.83 ±  7%  perf-sched.wait_and_delay.count.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      9.06 ± 58%   +2759.4%     259.12 ±  3%  perf-sched.wait_and_delay.max.ms.__cond_resched.__wait_for_common.__synchronize_srcu.part.0
    192.18 ± 22%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.__cond_resched.__wait_for_common.wait_for_completion_killable.__kthread_create_on_node.kthread_create_on_node
     19.46 ± 81%   +1187.5%     250.50 ±  9%  perf-sched.wait_and_delay.max.ms.__cond_resched.folio_zero_user.__do_huge_pmd_anonymous_page.__handle_mm_fault.handle_mm_fault
    170.49 ± 13%     -41.8%      99.23 ± 58%  perf-sched.wait_and_delay.max.ms.__cond_resched.kmem_cache_alloc_lru_noprof.alloc_inode.new_inode.__debugfs_create_file
     85.98 ± 16%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.do_task_dead.do_exit.kthread_exit.kthread.ret_from_fork
    166.34 ±  3%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.kthreadd.ret_from_fork.ret_from_fork_asm
    135.27 ±  8%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.percpu_rwsem_wait.__percpu_down_read.exit_signals.do_exit
      3.82 ± 43%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.schedule_preempt_disabled.__kthread_parkme.kvm_vm_worker_thread.kthread
    250.93 ± 10%     -18.2%     205.36 ± 15%  perf-sched.wait_and_delay.max.ms.schedule_preempt_disabled.__mutex_lock.constprop.0.mm_take_all_locks
      0.14 ± 59%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.schedule_preempt_disabled.kthread.ret_from_fork.ret_from_fork_asm
     28.03 ±172%    +486.3%     164.36 ± 25%  perf-sched.wait_and_delay.max.ms.schedule_timeout.__wait_for_common.__synchronize_srcu.part.0
      6.38 ± 25%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.schedule_timeout.__wait_for_common.kthread_stop.kvm_destroy_vm
      6.97 ± 48%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.schedule_timeout.__wait_for_common.kvm_vm_create_worker_thread.kvm_mmu_post_init_vm
    284.62 ±  8%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.schedule_timeout.__wait_for_common.wait_for_completion_killable.__kthread_create_on_node
     11.65 ±146%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.schedule_timeout.kvm_nx_huge_page_recovery_worker.kvm_vm_worker_thread.kthread
      0.03 ± 59%  +43825.1%      14.86 ± 59%  perf-sched.wait_time.avg.ms.__cond_resched.__alloc_pages_noprof.alloc_pages_mpol_noprof.folio_alloc_mpol_noprof.vma_alloc_folio_noprof
      0.15 ± 44%  +17885.5%      27.85 ± 79%  perf-sched.wait_time.avg.ms.__cond_resched.__alloc_pages_noprof.alloc_pages_mpol_noprof.pte_alloc_one.__do_huge_pmd_anonymous_page
      0.08 ± 67%  +35500.4%      28.54 ± 68%  perf-sched.wait_time.avg.ms.__cond_resched.__get_user_pages.populate_vma_page_range.__mm_populate.vm_mmap_pgoff
      0.01 ± 86%   +2505.9%       0.22 ±194%  perf-sched.wait_time.avg.ms.__cond_resched.__kmalloc_cache_noprof.kvm_vcpu_ioctl.__x64_sys_ioctl.do_syscall_64
      0.05 ± 30%  +86818.3%      45.92 ± 28%  perf-sched.wait_time.avg.ms.__cond_resched.__wait_for_common.__synchronize_srcu.part.0
      0.57 ± 46%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__wait_for_common.kvm_vm_create_worker_thread.kvm_mmu_post_init_vm.kvm_create_vm
    109.88 ± 23%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__wait_for_common.wait_for_completion_killable.__kthread_create_on_node.kthread_create_on_node
    126.01 ± 17%     -43.6%      71.10 ± 55%  perf-sched.wait_time.avg.ms.__cond_resched.down_write.mm_take_all_locks.__mmu_notifier_register.mmu_notifier_register
      0.24 ± 84%   +9652.8%      23.26 ± 56%  perf-sched.wait_time.avg.ms.__cond_resched.folio_zero_user.__do_huge_pmd_anonymous_page.__handle_mm_fault.handle_mm_fault
      0.01 ± 72%    +425.4%       0.06 ± 55%  perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_noprof.__kvm_mmu_topup_memory_cache.kvm_mmu_load.vcpu_enter_guest
      0.17 ± 91%  +54596.8%      92.80 ± 29%  perf-sched.wait_time.avg.ms.__cond_resched.mutex_lock.kvm_create_vm.kvm_dev_ioctl.__x64_sys_ioctl
      0.03 ±139%  +1.2e+05%      41.90 ±222%  perf-sched.wait_time.avg.ms.__cond_resched.zap_pmd_range.isra.0.unmap_page_range
      3.11 ±  2%    -100.0%       0.00        perf-sched.wait_time.avg.ms.do_task_dead.do_exit.kthread_exit.kthread.ret_from_fork
      3.72 ±  3%    -100.0%       0.00        perf-sched.wait_time.avg.ms.kthreadd.ret_from_fork.ret_from_fork_asm
      8.21 ± 23%    -100.0%       0.00        perf-sched.wait_time.avg.ms.percpu_down_write.cgroup_attach_task_all.kvm_vm_worker_thread.kthread
      0.59 ±191%    -100.0%       0.00        perf-sched.wait_time.avg.ms.percpu_rwsem_wait.__percpu_down_read.cgroup_css_set_fork.cgroup_can_fork
     69.10 ± 15%    -100.0%       0.00        perf-sched.wait_time.avg.ms.percpu_rwsem_wait.__percpu_down_read.exit_signals.do_exit
      0.04 ± 42%    -100.0%       0.00        perf-sched.wait_time.avg.ms.schedule_preempt_disabled.__kthread_parkme.kvm_vm_worker_thread.kthread
      0.03 ± 66%    +998.3%       0.32 ± 46%  perf-sched.wait_time.avg.ms.schedule_timeout.__wait_for_common.__synchronize_srcu.part.0
      0.03 ± 29%    -100.0%       0.00        perf-sched.wait_time.avg.ms.schedule_timeout.__wait_for_common.kthread_stop.kvm_destroy_vm
      0.09 ± 15%    -100.0%       0.00        perf-sched.wait_time.avg.ms.schedule_timeout.__wait_for_common.kvm_vm_create_worker_thread.kvm_mmu_post_init_vm
    115.27 ±  5%    -100.0%       0.00        perf-sched.wait_time.avg.ms.schedule_timeout.__wait_for_common.wait_for_completion_killable.__kthread_create_on_node
      0.04 ± 54%    -100.0%       0.00        perf-sched.wait_time.avg.ms.schedule_timeout.kvm_nx_huge_page_recovery_worker.kvm_vm_worker_thread.kthread
    442.99 ±  3%     +16.6%     516.60 ±  9%  perf-sched.wait_time.avg.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      1.38 ±195%   +1156.7%      17.32 ± 39%  perf-sched.wait_time.avg.ms.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      0.15 ±101%  +93541.9%     142.02 ± 47%  perf-sched.wait_time.max.ms.__cond_resched.__alloc_pages_noprof.alloc_pages_mpol_noprof.folio_alloc_mpol_noprof.vma_alloc_folio_noprof
      3.01 ± 49%   +6033.5%     184.87 ± 13%  perf-sched.wait_time.max.ms.__cond_resched.__alloc_pages_noprof.alloc_pages_mpol_noprof.pte_alloc_one.__do_huge_pmd_anonymous_page
      1.67 ±101%  +13142.2%     220.53 ± 16%  perf-sched.wait_time.max.ms.__cond_resched.__get_user_pages.populate_vma_page_range.__mm_populate.vm_mmap_pgoff
      0.01 ± 87%   +5859.3%       0.54 ±205%  perf-sched.wait_time.max.ms.__cond_resched.__kmalloc_cache_noprof.kvm_vcpu_ioctl.__x64_sys_ioctl.do_syscall_64
      0.04 ± 51%   +2258.2%       1.01 ±126%  perf-sched.wait_time.max.ms.__cond_resched.__tlb_batch_free_encoded_pages.tlb_finish_mmu.vms_clear_ptes.part
      6.20 ±101%   +4081.5%     259.10 ±  3%  perf-sched.wait_time.max.ms.__cond_resched.__wait_for_common.__synchronize_srcu.part.0
      2.36 ± 57%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__wait_for_common.kvm_vm_create_worker_thread.kvm_mmu_post_init_vm.kvm_create_vm
    192.15 ± 22%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__wait_for_common.wait_for_completion_killable.__kthread_create_on_node.kthread_create_on_node
      9.78 ± 80%   +2460.3%     250.48 ±  9%  perf-sched.wait_time.max.ms.__cond_resched.folio_zero_user.__do_huge_pmd_anonymous_page.__handle_mm_fault.handle_mm_fault
    170.47 ± 13%     -31.8%     116.31 ± 32%  perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_lru_noprof.alloc_inode.new_inode.__debugfs_create_file
      0.01 ± 72%    +734.3%       0.09 ± 89%  perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_noprof.__kvm_mmu_topup_memory_cache.kvm_mmu_load.vcpu_enter_guest
      1.87 ± 85%   +8622.8%     162.93 ± 19%  perf-sched.wait_time.max.ms.__cond_resched.mutex_lock.kvm_create_vm.kvm_dev_ioctl.__x64_sys_ioctl
      0.16 ±188%  +1.1e+05%     168.55 ±220%  perf-sched.wait_time.max.ms.__cond_resched.zap_pmd_range.isra.0.unmap_page_range
     85.98 ± 16%    -100.0%       0.00        perf-sched.wait_time.max.ms.do_task_dead.do_exit.kthread_exit.kthread.ret_from_fork
    166.33 ±  3%    -100.0%       0.00        perf-sched.wait_time.max.ms.kthreadd.ret_from_fork.ret_from_fork_asm
    101.24 ± 10%    -100.0%       0.00        perf-sched.wait_time.max.ms.percpu_down_write.cgroup_attach_task_all.kvm_vm_worker_thread.kthread
     16.51 ±212%    -100.0%       0.00        perf-sched.wait_time.max.ms.percpu_rwsem_wait.__percpu_down_read.cgroup_css_set_fork.cgroup_can_fork
    135.25 ±  8%    -100.0%       0.00        perf-sched.wait_time.max.ms.percpu_rwsem_wait.__percpu_down_read.exit_signals.do_exit
      3.64 ± 43%    -100.0%       0.00        perf-sched.wait_time.max.ms.schedule_preempt_disabled.__kthread_parkme.kvm_vm_worker_thread.kthread
    250.91 ± 10%     -18.2%     205.34 ± 15%  perf-sched.wait_time.max.ms.schedule_preempt_disabled.__mutex_lock.constprop.0.mm_take_all_locks
     25.20 ±193%    +552.2%     164.34 ± 25%  perf-sched.wait_time.max.ms.schedule_timeout.__wait_for_common.__synchronize_srcu.part.0
      3.37 ± 19%    -100.0%       0.00        perf-sched.wait_time.max.ms.schedule_timeout.__wait_for_common.kthread_stop.kvm_destroy_vm
      3.71 ± 42%    -100.0%       0.00        perf-sched.wait_time.max.ms.schedule_timeout.__wait_for_common.kvm_vm_create_worker_thread.kvm_mmu_post_init_vm
    284.60 ±  8%    -100.0%       0.00        perf-sched.wait_time.max.ms.schedule_timeout.__wait_for_common.wait_for_completion_killable.__kthread_create_on_node
     11.46 ±149%    -100.0%       0.00        perf-sched.wait_time.max.ms.schedule_timeout.kvm_nx_huge_page_recovery_worker.kvm_vm_worker_thread.kthread




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


