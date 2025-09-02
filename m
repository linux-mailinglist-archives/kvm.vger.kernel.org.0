Return-Path: <kvm+bounces-56549-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FD57B3FA45
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 11:25:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 098CA16DA34
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 09:25:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4338B2EA15E;
	Tue,  2 Sep 2025 09:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KR4QF4ig"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C622DEA6E;
	Tue,  2 Sep 2025 09:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756805151; cv=fail; b=gYszT3rcsrbYwHCUMjg+aZioqVAojYteMPT8v1t+sGCf6zCvflagNInNcYk/nV8hPPYZSJsQAfBkjW8YsDyEJqCtyzY3q7u8JmGCaB3zqaCf2qt6OPfoSr+brEjTZ7IQwLE9tORqjdKzc0GFcXJJ+s4bivlFCjc+q0o4i2MZNo4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756805151; c=relaxed/simple;
	bh=W9eDO1Ca2PbvKft9O4SdOsM7CDkfTV2r8Wn22kUCAm8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Rr75VHJA5iASX1JwwIat7ZxbABDq89lUv3J3Zsmr5/WRAd5EBP5VcgNzveuaEptCMTkK0h/81sMFBSJrZnmehLIivZa/Nn5XK1XEStz3fZakVIRuPxnW6MTnyVqrofnrkVne0oVzOh/inkDQNt2TA4DZIFKstgBvxKIFyIHEekg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KR4QF4ig; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756805150; x=1788341150;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=W9eDO1Ca2PbvKft9O4SdOsM7CDkfTV2r8Wn22kUCAm8=;
  b=KR4QF4igAOYdn0Nx43yOBYCWp8cmpwv+sgkDSFaqiWC5AALoEUNqlnJh
   DFLa00eDlVYwqF1KCz3fi9qWXKMaYpA9JVhDWwAoL0AXBrZQzN4WFc9Om
   kiaPuH2MMa6mTGpZPVKC7jHxXssBjPuVDo7NMm3nRmvgejHRyBR0BcBp0
   zlUIfqsIy2QRGSxVBHHKeN+p0fgSd1xc7U0ExdUZ0ZY26pxZae+Ig9xhu
   nU1t0Nosx9D9Iw1k8Rggw4+rzPGg0SmLfv04ySyW1FNiUvFlC7PerXTQN
   ztg2+wyHsKYKs2AuDCUHRQHTkKRQppeRo96uAP6ThZ28fxs87yTNLg4ul
   w==;
X-CSE-ConnectionGUID: 8LMPg/CfRGqxlmADAU72LQ==
X-CSE-MsgGUID: DXVhYQV3QhWr7YEFP+VACA==
X-IronPort-AV: E=McAfee;i="6800,10657,11540"; a="61710978"
X-IronPort-AV: E=Sophos;i="6.18,230,1751266800"; 
   d="scan'208";a="61710978"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 02:25:48 -0700
X-CSE-ConnectionGUID: lBhxW8wmTKyqSOhNZ2H0xQ==
X-CSE-MsgGUID: GD3vhELeR5GWfLgzxE1D8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,230,1751266800"; 
   d="scan'208";a="175592641"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 02:25:47 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 2 Sep 2025 02:25:46 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 2 Sep 2025 02:25:46 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.63) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 2 Sep 2025 02:25:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FIycS8vc9Sfz1JF510FttfYna3uXDiBasuuF1JzYVbl5+8MhGF/IKklYB/K3kEVU848VShHTBppU3LAyAqwLnTSUibtPk9biR0/4ZEX5Y661OUHHz9OXifjrCjg9WSUNBkC2ocK9qlBLcEqSYcBInSsOhA26SAni5IQmW+QWoiigc4+XD0DM+5gkxdj/4gM8iZ6kV/ZdaoUYQqSyJHGtLKTZoZmwu0veu21eAU0wIJ6Rv4Q9Z2jdx98/dxC/xLCbbEtE+OnicjKop0n/DGOHVW8nBSYmFKsFZYP/cfl8LSIcDsVjgNuzzttIf2d+mIDPLRnyyP0SFPfAW/nR1wDkwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yIuw1FssxTtgRnP/p4NPpQOdWcYdnuXD/3fLRpdHSNQ=;
 b=V1NnDxGLPRm+Qv1GJM0UXnavattXOVjXeAihukWKeCu3RVGy2sojfcyyX2erLtR78v1koCM2I6iqU82v2N0H+kyvi8eNqmoTraYrM2R6t+Nc3Gk9fXozNKdREhT/PS1vG5Qu53BqWfA037BfdQK7BAt0+i7D7X+hS1nBYUOFFnwOogHodJqYprkN46ajS2fRMkwWiA6KtWD+qhDFPjr5QznxnxJMHxHSpqFJ2e56TOXiUreVYw57Vccqg7rrXUYM7O7cmKEnUohNVPVX4B3UaH1ha4MKbyjWtnpSSS0llgmUOHoBhsshgZmTB9o4NAiUqZ39f53mlmjP8NVCTBDE+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH3PR11MB8561.namprd11.prod.outlook.com (2603:10b6:610:1ad::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Tue, 2 Sep
 2025 09:25:42 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9073.026; Tue, 2 Sep 2025
 09:25:42 +0000
Date: Tue, 2 Sep 2025 17:24:49 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Rick P Edgecombe <rick.p.edgecombe@intel.com>, Kai Huang
	<kai.huang@intel.com>, "ackerleytng@google.com" <ackerleytng@google.com>,
	Vishal Annapurve <vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [RFC PATCH v2 12/18] KVM: TDX: Bug the VM if extended the
 initial measurement fails
Message-ID: <aLa34QCJCXGLk/fl@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250829000618.351013-1-seanjc@google.com>
 <20250829000618.351013-13-seanjc@google.com>
 <aLFiPq1smdzN3Ary@yzhao56-desk.sh.intel.com>
 <8445ac8c96706ba1f079f4012584ef7631c60c8b.camel@intel.com>
 <aLIJd7xpNfJvdMeT@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aLIJd7xpNfJvdMeT@google.com>
X-ClientProxiedBy: SG2PR02CA0056.apcprd02.prod.outlook.com
 (2603:1096:4:54::20) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH3PR11MB8561:EE_
X-MS-Office365-Filtering-Correlation-Id: 213148bc-b132-4617-f001-08ddea02afd8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?n9Ms3NhRd5oRewJxq4N5YptSfi5A4WyupmM7cDju2ppkg3XZDVkV15kH8zSo?=
 =?us-ascii?Q?Dli9uX7w4E0yLS/+OpYVRT4aqqJXb9glez0cpKtOACePQN1Iq0sVoDCz49d6?=
 =?us-ascii?Q?dac0m+V7mhPJq+HNOoFy5JTqfxXaXljMTBNVN3wcTHLGFWTo0ym7EQ2Lxj3Z?=
 =?us-ascii?Q?P5K2dIJoZLEbdFpPKI/Qnmfnm0vIe4APjwUboqyPKijUmY8PTSkE+jjfRcjs?=
 =?us-ascii?Q?vH8O3wMaezWzzlPzJGtmSl71f9Rn2vRcAJABCx3xzb18+raSu8SFTEFNIohs?=
 =?us-ascii?Q?GQbP34rrMQu45bF83SQOD4bFipbSu9XeCmwP0UhrtAvgCvw4MKec0OokpO0E?=
 =?us-ascii?Q?95VnYKwNpDuyRAuihS47Rm6TE775Fw0e81KmqjB6kTmdA9QHJW6RgF+Kt6gr?=
 =?us-ascii?Q?6uRSBM9MNgV/frMBANe8ILlZKPgv3AFa9eGVIokV3FajzJ9Kb+4I4RouhEYh?=
 =?us-ascii?Q?pNN+eyt6wglyLbAg+aBQ0ITm2kgooOkWbWX7O4DUPrzMDFztOWPHrzeASrsY?=
 =?us-ascii?Q?Z1DGniWEy3h6dx84QnsX6kFiFGz11u9M7Qz0J8B0gQoscuxk2Mv4+pmyAqqN?=
 =?us-ascii?Q?d2lRb3RoAqABEdiysUptyHxBQk6ocYEV8A3xGRc9IpZRQUaObjRkltKosP/Y?=
 =?us-ascii?Q?ScPxWxMVP4O/cxWhEqmraLRyd1edwkAPPAfE7MADYzbYhsmg0XdslM1zPfpW?=
 =?us-ascii?Q?iwbjm8Y/1UZT+XvX5QnRbwPwplIcWJ75tZHird4twekj13FpQdQXTu1Dy4Ho?=
 =?us-ascii?Q?DL/Lrvu7o3q3rnKfuFC0SIU4/fbPQhzHXk+FIRGZCceMSc1+hO3IJc8UYOFl?=
 =?us-ascii?Q?AmesinUtsoLj4LlmoGeD6AumMSyloWb0ML6fvvRchLcGzH+FPipaOD3YFWm0?=
 =?us-ascii?Q?LsHo48bI60wz7wwjVSZExhSIiMw/Rz5Ofzj42xevRRKdcDdE3iF9jyJ1Y4tn?=
 =?us-ascii?Q?QJmxa1s9qqWFlnTHqJGVMGV/3kqnko73K35mzAZu/u+hbGrNmF4UwxRre1VN?=
 =?us-ascii?Q?2X7ANxFQenPgHEFOvRm8IVTkCQbSWGLjiYae1RN4QjJwWkiUY0hD6WEl+4ae?=
 =?us-ascii?Q?K8s1CfHfBtAB5UwG7o39rQmlBUBSKlxI768WwKhiP6Aq+0Mxa9Ct4Tkp4ZX7?=
 =?us-ascii?Q?v+XHG23uqTn58CO9FYN8CyXuh692q3PEar2bpRhWZinPhHfrLm45khexbAZA?=
 =?us-ascii?Q?XQ4ywkVPzdw71+AXeokfSc2s2Op7ZGPHIZQB/JWWkRcQXOlsXaaRMXj5HzFn?=
 =?us-ascii?Q?fJi2mVCdR4+it6EwiqC1DvcbjufceF0gQwCHIkAtc0p4ARAgkxRxKe7jfhO0?=
 =?us-ascii?Q?Trm/lmtrlc4w/RM53kqHXIcrZByPZ8QI93i4uuNnozN9ObPM1bX4z33DAxd/?=
 =?us-ascii?Q?lXnV9g8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tzhgGwsIc+PIYe88dsN2cB+O7ZPczZbNjwoqiDf443UMguW1ZuuU9B9fPQum?=
 =?us-ascii?Q?wLbpHymFaVhsGAuLLLrSxDNm3dYuWnZ3TvUh5jqK8o2740sX7sRCtgpHkZKy?=
 =?us-ascii?Q?bI2IJ7wJBhNaBtpAN5b5k+I2EdHQ5XUdqKU49P2v7xIgenmNUVaXVEYNq7i4?=
 =?us-ascii?Q?mN0oVltc5mixawILicdALWitQQ2lHMgacn8Y831DmToJeK6pb23JNO080ZVB?=
 =?us-ascii?Q?bFaUNlurhOS65QcrQ7RfaylONihNbZ19DbVfpSERBb/U8/M6AegB8+Oa2RGn?=
 =?us-ascii?Q?8APurO715F5cdM4CrEgTarD9hDXjlg+BgF8swezrKbHIpU6yYVdC9aPoHsTh?=
 =?us-ascii?Q?yLkJaX5vI+wzd/2eTe13COF91yUnxuqGmP/yO0rSQHM9psfIIYDOywhvINvh?=
 =?us-ascii?Q?SJo5U/9kiSV4mzTwgzGEeHPt2gcfvZq9dhXHBK9K7kO1iOGq8LKVRqpJrAUi?=
 =?us-ascii?Q?LeK5rFSZONJ029ScA0IMvhqi5VbVtmdbkFJfTv8EL7Rlrg7nHZVetdgM8qQL?=
 =?us-ascii?Q?aS6vC2Q+mIGq7UMDiMyHw1ccn8x86ypzQ/xiHymXvxx6ajSBcXHNxrGadsjg?=
 =?us-ascii?Q?1h6+beIikGXJSYk457NTsvbM5YVX5gWBiFk17Tec5PxAmLFGty6zIDhwKdUS?=
 =?us-ascii?Q?O+hskbPv8c5rkQkCOA+TRN1hhvC8EJeiNgO4cWZ61AbulhhVNSHBztMLjurQ?=
 =?us-ascii?Q?QIusxGE176ZY9zYyejARbX4BhSnVf1rJirYQI0pkno2GRD+xqVmMa2nNzsY3?=
 =?us-ascii?Q?RQVcmpKI7t13KMVW+dKZwe1aIxvHrM56Htk4vBQKrRc/oDHJrvcQPJgI3uk0?=
 =?us-ascii?Q?mmbOvmgj45WT3ZJftUnPeBEihjxt4/azFWP8Dei09PxGqhvQvNmU8mLhar2o?=
 =?us-ascii?Q?gR1wXtsL0WaL/hvtzeS1ZODigwsd4vtvjXcIKLo+f+MnCFZ/FW2lzloyjc9z?=
 =?us-ascii?Q?JIENL7xrGVyY83TNlhgckr1lx+ik/ktMp0jkwl956R2CtPcJWxXiGW4XopkH?=
 =?us-ascii?Q?mSZ9NUnV+hnns+eWSp+Rg4YcISpNb/Z0DgsFyBCSxEg2X/4Iy8m09U07h4M2?=
 =?us-ascii?Q?eLaYPW0069r21Kg63ZdT2hzGvBNQIPJ5WGPSibGyiskK/k1SbdRWNFLrTKxa?=
 =?us-ascii?Q?DmVi5U6ttWnBrcfwpkxK7AiaZExOqkea2CMj8vWoWkelWHwXlKEUvRCOnBiA?=
 =?us-ascii?Q?chBdg/P3GeUuayhtaIn+EzOJqKKe6Bg8elhRNeo22/omfSlPBMsHrn6OoTqs?=
 =?us-ascii?Q?R8CahTsqRB5Rz2GwjW7R5+cMtqoTjxPNC2Vvon5a2OYF9wEqgP4CJO0F/ZPq?=
 =?us-ascii?Q?IQQiKtNocZvC75K1/cAI/cg6ZfPnxdKKC7MAOZiFqTuGP5Jsypl8okbkPXB9?=
 =?us-ascii?Q?6+7Xx6yM1jAkT7rrePPdeXnXxWNc1VdJlbAKccr/fvYmTWx40ZAJOz4jPmZG?=
 =?us-ascii?Q?mE+YT6W97lKgHbmwUnqY5czPrBuXQ45oFL6Jo9Gd4sXSq4OKbmkNinVFcZUG?=
 =?us-ascii?Q?nm1u9P0ra61ZR5vTzc01NTXdqzWiGY/FWaFyntqg/rzNDe+0SXoHJ+dfJlpf?=
 =?us-ascii?Q?dfCanpouDUTR90gzVt7D40FioaRHWy8kkw4BdkLT?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 213148bc-b132-4617-f001-08ddea02afd8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 09:25:42.0733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FsYM1gxmd/hZYSsmjBQDS+5apRKpShUPBsUNupOWRDDCk36+pRLVfUgYm8FT1liWqB0u3ZqpUVcHOzyS9TjL/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8561
X-OriginatorOrg: intel.com

On Fri, Aug 29, 2025 at 01:11:35PM -0700, Sean Christopherson wrote:
> On Fri, Aug 29, 2025, Rick P Edgecombe wrote:
> > On Fri, 2025-08-29 at 16:18 +0800, Yan Zhao wrote:
> > > > +	/*
> > > > +	 * Note, MR.EXTEND can fail if the S-EPT mapping is somehow removed
> > > > +	 * between mapping the pfn and now, but slots_lock prevents memslot
> > > > +	 * updates, filemap_invalidate_lock() prevents guest_memfd updates,
> > > > +	 * mmu_notifier events can't reach S-EPT entries, and KVM's
> > > > internal
> > > > +	 * zapping flows are mutually exclusive with S-EPT mappings.
> > > > +	 */
> > > > +	for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
> > > > +		err = tdh_mr_extend(&kvm_tdx->td, gpa + i, &entry,
> > > > &level_state);
> > > > +		if (KVM_BUG_ON(err, kvm)) {
> > > I suspect tdh_mr_extend() running on one vCPU may contend with
> > > tdh_vp_create()/tdh_vp_addcx()/tdh_vp_init*()/tdh_vp_rd()/tdh_vp_wr()/
> > > tdh_mng_rd()/tdh_vp_flush() on other vCPUs, if userspace invokes ioctl
> > > KVM_TDX_INIT_MEM_REGION on one vCPU while initializing other vCPUs.
> > > 
> > > It's similar to the analysis of contention of tdh_mem_page_add() [1], as
> > > both tdh_mr_extend() and tdh_mem_page_add() acquire exclusive lock on
> > > resource TDR.
> > > 
> > > I'll try to write a test to verify it and come back to you.
I've written a selftest and proved the contention between tdh_mr_extend() and
tdh_vp_create().

The KVM_BUG_ON() after tdh_mr_extend() now is not hittable with Sean's newly
provided 2 fixes.


But during writing another concurrency test, I found a sad news :

SEAMCALL TDH_VP_INIT requires to hold exclusive lock for resource TDR when its
leaf_opcode.version > 0. So, when I use v1 (which is the current value in
upstream, for x2apic?) to test executing ioctl KVM_TDX_INIT_VCPU on different
vCPUs concurrently, the TDX_BUG_ON() following tdh_vp_init() will print error
"SEAMCALL TDH_VP_INIT failed: 0x8000020000000080".

If I switch to using v0 version of TDH_VP_INIT, the contention will be gone.

Note: this acquiring of exclusive lock was not previously present in the public
repo https://github.com/intel/tdx-module.git, branch tdx_1.5.
(The branch has been force-updated to new implementation now).


> > I'm seeing the same thing in the TDX module. It could fail because of contention
> > controllable from userspace. So the KVM_BUG_ON() is not appropriate.
> > 
> > Today though if tdh_mr_extend() fails because of contention then the TD is
> > essentially dead anyway. Trying to redo KVM_TDX_INIT_MEM_REGION will fail. The
> > M-EPT fault could be spurious but the second tdh_mem_page_add() would return an
> > error and never get back to the tdh_mr_extend().
> > 
> > The version in this patch can't recover for a different reason. That is 
> > kvm_tdp_mmu_map_private_pfn() doesn't handle spurious faults, so I'd say just
> > drop the KVM_BUG_ON(), and try to handle the contention in a separate effort.
> > 
> > I guess the two approaches could be to make KVM_TDX_INIT_MEM_REGION more robust,
> 
> This.  First and foremost, KVM's ordering and locking rules need to be explicit
> (ideally documented, but at the very least apparent in the code), *especially*
> when the locking (or lack thereof) impacts userspace.  Even if effectively relying
> on the TDX-module to provide ordering "works", it's all but impossible to follow.
> 
> And it doesn't truly work, as everything in the TDX-Module is a trylock, and that
> in turn prevents KVM from asserting success.  Sometimes KVM has better option than
> to rely on hardware to detect failure, but it really should be a last resort,
> because not being able to expect success makes debugging no fun.  Even worse, it
> bleeds hard-to-document, specific ordering requirements into userspace, e.g. in
> this case, it sounds like userspace can't do _anything_ on vCPUs while doing
> KVM_TDX_INIT_MEM_REGION.  Which might not be a burden for userspace, but oof is
> it nasty from an ABI perspective.
> 
> > or prevent the contention. For the latter case:
> > tdh_vp_create()/tdh_vp_addcx()/tdh_vp_init*()/tdh_vp_rd()/tdh_vp_wr()
> > ...I think we could just take slots_lock during KVM_TDX_INIT_VCPU and
> > KVM_TDX_GET_CPUID.
> > 
> > For tdh_vp_flush() the vcpu_load() in kvm_arch_vcpu_ioctl() could be hard to
> > handle.
> > 
> > So I'd think maybe to look towards making KVM_TDX_INIT_MEM_REGION more robust,
> > which would mean the eventual solution wouldn't have ABI concerns by later
> > blocking things that used to be allowed.
> > 
> > Maybe having kvm_tdp_mmu_map_private_pfn() return success for spurious faults is
> > enough. But this is all for a case that userspace isn't expected to actually
> > hit, so seems like something that could be kicked down the road easily.
> 
> You're trying to be too "nice", just smack 'em with a big hammer.  For all intents
> and purposes, the paths in question are fully serialized, there's no reason to try
> and allow anything remotely interesting to happen.
This big hammer looks good to me :)

> 
> Acquire kvm->lock to prevent VM-wide things from happening, slots_lock to prevent
> kvm_mmu_zap_all_fast(), and _all_ vCPU mutexes to prevent vCPUs from interefering.
Nit: we should have no worry to kvm_mmu_zap_all_fast(), since it only zaps
!mirror roots. The slots_lock should be for slots deletion.

> 
> Doing that for a vCPU ioctl is a bit awkward, but not awful.  E.g. we can abuse
> kvm_arch_vcpu_async_ioctl().  In hindsight, a more clever approach would have
> been to make KVM_TDX_INIT_MEM_REGION a VM-scoped ioctl that takes a vCPU fd.  Oh
> well.
> 
> Anyways, I think we need to avoid the "synchronous" ioctl path anyways, because
> taking kvm->slots_lock inside vcpu->mutex is gross.  AFAICT it's not actively
> problematic today, but it feels like a deadlock waiting to happen.
Note: Looks kvm_inhibit_apic_access_page() also takes kvm->slots_lock inside
vcpu->mutex.

 
> The other oddity I see is the handling of kvm_tdx->state.  I don't see how this
> check in tdx_vcpu_create() is safe:
> 
> 	if (kvm_tdx->state != TD_STATE_INITIALIZED)
> 		return -EIO;

Right, if tdh_vp_create() contends with tdh_mr_finalize(), KVM_BUG_ON() will be
triggered.
I previously overlooked the KVM_BUG_ON() after tdh_vp_create(), thinking that
it's ok to have it return error once tdh_vp_create() is invoked after
tdh_mr_finalize().

...
>  int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
>  {
>  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> @@ -3146,19 +3211,14 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
>  	if (!is_hkid_assigned(kvm_tdx) || kvm_tdx->state == TD_STATE_RUNNABLE)
>  		return -EINVAL;
>  
> -	if (copy_from_user(&cmd, argp, sizeof(cmd)))
> -		return -EFAULT;
> -
> -	if (cmd.hw_error)
> -		return -EINVAL;
> +	ret = tdx_get_cmd(argp, &cmd);
> +	if (ret)
> +		return ret;
>  
>  	switch (cmd.id) {
>  	case KVM_TDX_INIT_VCPU:
>  		ret = tdx_vcpu_init(vcpu, &cmd);
>  		break;
So, do we need to move KVM_TDX_INIT_VCPU to tdx_vcpu_async_ioctl() as well?

> -	case KVM_TDX_INIT_MEM_REGION:
> -		ret = tdx_vcpu_init_mem_region(vcpu, &cmd);
> -		break;
>  	case KVM_TDX_GET_CPUID:
>  		ret = tdx_vcpu_get_cpuid(vcpu, &cmd);


