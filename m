Return-Path: <kvm+bounces-20753-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 705E191D7A4
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 07:49:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F05C21F228D9
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 05:49:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BBF6482D8;
	Mon,  1 Jul 2024 05:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="luMCkzot"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB1243AD7;
	Mon,  1 Jul 2024 05:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719812965; cv=fail; b=pJ1MV5qF3giM/Eql5Bhv4qh76Nr8P8iNOH6jepitVEAFysduV5TImccuRJgeeAcuFfCVG/ApBHAysRK7Z4SZVEit2TWc3JONNXQ4VOs1u0hEvHw9m5MXB3iAE5BuXxj+RBDmm0xbDooglWiGJ7IfITkroiCjKO9cnwYd+nJ5OSU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719812965; c=relaxed/simple;
	bh=vsIt6utnR4wPnkYsUM6BHGWS2O0m8KvHvseK2kKsLdc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=W+CA1kYENesVXUdmJnDhMi4sotG+Mg1GOQOa4IoEzE/AL6nFTMn1OR6xpyFgzMXKk4JbiqK/341u5YyGrBPVSfS75aTROvmjsWx6a/R1bw+vTygSYWoBCIQuIYdcYXcCuo2mGCRq0fVxO2ACk0hS+3srSsxGImX2956dByYKa1o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=luMCkzot; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719812964; x=1751348964;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=vsIt6utnR4wPnkYsUM6BHGWS2O0m8KvHvseK2kKsLdc=;
  b=luMCkzotQeyptWkSP1K8eqZz9hHrLhl3bM2RZJOU32wpmJNNInn5phkV
   6x1rDjcZRQHZYR0avBbNaT47o6xVdiO0J9/Ld5aVLcdA2sAj+ieogSq0E
   B5UmONetzWt3p1Y1J5xFzEvtYDM0AdEcQ8lGOJXkW0L+qpGubNTwiVRAl
   R+f5CoHxLpCT0d2EfoHiMswJeBCljzQC6LkIwWQhTPWDngQdwe4W85uYX
   EMnEt81X1k0DIfjlKjjxVdUWUcUY7tBhT15yNh1jcHEAoo+elIqcGNRGw
   O2DiwsZmBt1pe73UeS4J9eXEnwzKnZ2ixUHhGgIQD2ZEuiYVOZmo9xgNW
   A==;
X-CSE-ConnectionGUID: VD1+9x8kTSa75em/ZfJ9dQ==
X-CSE-MsgGUID: 8CEeZP4xTQ2JajCVe/404Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11119"; a="19816370"
X-IronPort-AV: E=Sophos;i="6.09,175,1716274800"; 
   d="scan'208";a="19816370"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2024 22:49:23 -0700
X-CSE-ConnectionGUID: muXkKZEwR6yCD3Ks0XAn5g==
X-CSE-MsgGUID: XKfTtW/wRTODq8si4x7VmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,175,1716274800"; 
   d="scan'208";a="45400833"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Jun 2024 22:49:23 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 30 Jun 2024 22:49:22 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 30 Jun 2024 22:49:22 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 30 Jun 2024 22:49:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PoXWQZmZL4X4MtU7oCDb0pMjzZdeOntNbfSNHydrRTXbsg+46yQ9RNYn0OKnXOhhE4aF2XcceexRJK2SxdhdTgEowBBJDOI/diJHByeTEtji8QMUSEY1oMqGTVe1PVVNinhRHr+fIBt0+MEU4Qr3W9jByE5H9iVVC+tKLinIantmn03Flkp4XVOhXechboDjAM1AkRnPqPwfkEo4RMZ1kg7uGODLdfrZU9NIhbxdpacGvTgYh0HY65vzgx0THitnbIJos3jmZS29xCCA7MpJAad7EQnRNZs+KMq2pBsbOXJIg4TwmBVXE/TFigh+Ezeb6m15oiAdWIazZgPFH8/05w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8mKFHAtGnIbdkgaOLUly1WbsnBM9erk8GWvcH7JulJk=;
 b=ZIpBh+o9WQT2Dnv5cVTXXWCs/p/vUNBMGLmat5cWIQd2qYuAZsFZXF0qQY57pdnb+9b9xzpTI5TwR3f+BPy1tev8TnLPhT9Ab1RUmkd3ubtu3Np21NbJVyLXmOKxRapHmmn48hQOkb1a7aZBUJWa9XuVyAD9TvP+e/CRBc/WxKmF56Pu971X0iTpqNuZ2msRZoQ632WMmgtpzuxklWt5qb5kXsW1TSOrRHX28s3IbqQLCUNF8ct6yWgyE5em0lyKhJXV7HfwThE0PynOnlM6yIsjocLG4ZSMB1jbcEcbC4S9fm/ANEQvtLYpaA+MllCYPIaVlyLel7rGvpT+/V0/WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA0PR11MB7749.namprd11.prod.outlook.com (2603:10b6:208:442::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7719.29; Mon, 1 Jul 2024 05:49:20 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7719.029; Mon, 1 Jul 2024
 05:49:20 +0000
Date: Mon, 1 Jul 2024 13:48:07 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Yi Liu <yi.l.liu@intel.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, "Tian, Kevin" <kevin.tian@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "peterx@redhat.com" <peterx@redhat.com>,
	"ajones@ventanamicro.com" <ajones@ventanamicro.com>
Subject: Re: [PATCH] vfio: Reuse file f_inode as vfio device inode
Message-ID: <ZoJDFyqzGVuntt94@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240626133528.GE2494510@nvidia.com>
 <BN9PR11MB5276407FF3276B2D9C2D85798CD72@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Zn02BUdJ7kvOg6Vw@yzhao56-desk.sh.intel.com>
 <20240627124209.GK2494510@nvidia.com>
 <Zn5IVqVsM/ehfRbv@yzhao56-desk.sh.intel.com>
 <cba9e18a-3add-4fd1-89ad-bb5d0fc521e4@intel.com>
 <Zn7WofbKsjhlN41U@yzhao56-desk.sh.intel.com>
 <f588f627-2593-4e89-ae13-df9bb64143c4@intel.com>
 <ZoIKwAhOkgkTYtyf@yzhao56-desk.sh.intel.com>
 <e568a45a-4e1d-4477-ac10-103cd605eff3@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e568a45a-4e1d-4477-ac10-103cd605eff3@intel.com>
X-ClientProxiedBy: SI2PR01CA0011.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::6) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA0PR11MB7749:EE_
X-MS-Office365-Filtering-Correlation-Id: 197b8d38-c0aa-4cad-326c-08dc99918d60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?DpYSni52SzRiXlFl3yFEAPekHzpJYFcQUZd+Irgm2H7VKCqCP2LLTXdo0T2J?=
 =?us-ascii?Q?pBFTYYJlQH5jw4qGO76WlMvGV3l3ftFP5OF32dZoyyeD19etd5sZz0KZsZkY?=
 =?us-ascii?Q?GkV0yjnaHAqpyJXW5rbNhwNqeWBWUuwS5NV8b1WrEwAq+aZ8fSEYr1x6hqGL?=
 =?us-ascii?Q?D7jaSJqfLIwf+w78G89ajk7TwMehnnz1pwK6AXGP9SYpCxA21UOIpSO6X40i?=
 =?us-ascii?Q?KM8Go+a7dumzcJRJdTDgv8DorFVBx3SBcVnSB9KG2K/QlTJ20NGRSPYOR8si?=
 =?us-ascii?Q?APdiR66mmVi1M/srlAKKDxnSq5jcuoSfkSHa3vOR0tb35a6sLWZ3Ea+4VHld?=
 =?us-ascii?Q?ALn3DT5BpZ6q6m6bMLT20etufxD3U0TZY8VJro8tj89+6P+e6jfaE20cxgMe?=
 =?us-ascii?Q?9OW9wQzDDa8p8M6Bt7w2EbK5fFHecm47sRy8eEUWO6AQMKSeezQoit2Um5q0?=
 =?us-ascii?Q?+pRrcZR0D6UTttd8xpBb/lJzlu8hL80zLiinBoX57WtQmmwUqSVXCRLBgU+i?=
 =?us-ascii?Q?c2rg5hWpzstCu1VtDp+5U0GSzaD1UznAfmbe7OZI6R/boD0uFEkJLpdvPz6w?=
 =?us-ascii?Q?gwH5Sc92TbABDNMyQzRr6vXGwuaQIg3zXZIyJpge1ixNH5DjZkivnGSiuoFw?=
 =?us-ascii?Q?tZWErmrzcyfu9S7e4XVLLwxLhvnYwrtUoXL1JTZoAYJr9znAkyuf3q+liucu?=
 =?us-ascii?Q?XBVGMmzsgYqrgPDMwxC6s/KoScpgv39Ix2avVvDrJ+LSCv1EDSOSLnwVC9oS?=
 =?us-ascii?Q?NZiWhWYHtgAWMx2i+ZAO0UDpketgNnKEk1uG3QFHbEndPQ6e+KVXmBUudtU3?=
 =?us-ascii?Q?AvX8CHZNeEWeD9P6QnJsdbJTz6hOSrybd9u99Q1heaPthuYSySrniGu8yc7o?=
 =?us-ascii?Q?8eEHtSX2t5Y8AJi3o+RWSpzc3Y+kh2Ej5ioFE18ajbj2wR5t2YpBGP/qug6p?=
 =?us-ascii?Q?HB+CASQ8zrI5ndfp/CgVuFAlgFBvsf3DDA1okbzub5hs0WavZcfAcfoJVEz1?=
 =?us-ascii?Q?oKdyirhLjSpTdu+7WiR3wk7zk1x0tp+irns3Pv4n8HW2CMnziBNZJXeXSWlI?=
 =?us-ascii?Q?k5duePcSdXFUdO/zeYOUw+fxeUjgbPtScJHgyt5IPlEz7wmMW7WR3hk6rhJt?=
 =?us-ascii?Q?F9GxVavrDe/pOQrzOgCmduLqSlEm+Pthf+JU/6Jn2ixMJ5ZSuoZ1yHA6QQ+X?=
 =?us-ascii?Q?TGkmH1d+DqyPn9j5dMjxym//l5RrrowUdKH/0eGX9o3xcYI/5LvSMEZICFvd?=
 =?us-ascii?Q?uKYNSRgQ4amnx3ZJrKFqB8NRzaR3oenCJyhl6JbsLB5QPQYfbqp7ULokDEtk?=
 =?us-ascii?Q?7xhA6jpabTdVo8iJxEvzq/Ekv/19Zn2jpOIKBH2aj+MQgg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9OEDNSx+5czd7ce3ZDOaqpSxUUFyGPpRLHDuxgRZkXaaVKU/IA03IgsSMZrA?=
 =?us-ascii?Q?vWjPhewNStuvSkdQsE04URzjTyK9vs2oaF+RwA6Vwtv52v2dmEOk2ipfVsOv?=
 =?us-ascii?Q?cKabcdGcmykpGxHKVQTQg5r4ZVISXXRKrDucdbN30s0DRn+SN+yuN/KpPVKn?=
 =?us-ascii?Q?EmZv4yAfE51NBEYCJxnhk0OTgd7pjnXXoyF3HnJSAr+UxF+SLdisrKHRPsKp?=
 =?us-ascii?Q?R5lNTf1g8thOT8cNo+LcnFO36y5kKgiXShJAwHWRK2gEa62ljXnsiCGMA91i?=
 =?us-ascii?Q?1GQKmyMMaiKMJjZhCGKRF3G6pROyezSsLZX85PiYRewlERUA3l0cDWUK7fu9?=
 =?us-ascii?Q?vK2SVwdepMhNHGLLQNb8AEj/GE11LibGU4/UsEvUkoySMcGW87L0zqKvDcNj?=
 =?us-ascii?Q?CrzWGSZJAybksF0oGhZH3dvi1Yw/inuieIu1IdKsKTYnBlDlt9t6Ym/9kYLl?=
 =?us-ascii?Q?0Nf3jJti27e5rv6VcHh+bRYBzG92+8VfLrZxI0FMVHaCm1Ofn6Jxk/m5c0s4?=
 =?us-ascii?Q?qO6UZHdNsDtS/tdYACm+1Rc11fF/OfYZmcfuRuhf3IvfvMmqyCywd6VV7bQB?=
 =?us-ascii?Q?G8pMLVYqhUvQpWL6ZgQvfH7pHEFKI/viEPw87vGUmP0vDVY+uLwiGpdndi6i?=
 =?us-ascii?Q?uiQgoPRoo1FFNzgJkmR4HwUp888dUTUva/xxI3nF15tBsTL4kXEvgDPy/yvQ?=
 =?us-ascii?Q?d0BOMzKhj0hJWqfzXMFfuwHWFZHrQXpaGG4v6KMvqjsCaG7HlMNDL4iaoF+L?=
 =?us-ascii?Q?+O62mfjwxIaxVsPcv/V2Ya07ZuXggurYCYZBGYeYM4oKpcX2qvmA6fJnZskY?=
 =?us-ascii?Q?zVlZiCMV8vwTutJl1B8Z6qXBb161XCVZpQLXyF0e/Rm5RIeG1xKH7Ryc/NzO?=
 =?us-ascii?Q?oMeInu6sHHnSTdHfPh7S5mcUugCtindDHzx/t2J1QDhyV4bSKbv0JtcvTFOu?=
 =?us-ascii?Q?yjw2miqJYvwsVA4Gy4wojIS3AKCiWmJTh6Ip31euip9PyFZ3OTTWunowakGO?=
 =?us-ascii?Q?4IhEe0YrY28YYoR+UHrUYL1GECPsAVLR3N/AdrGCVzVvJhVS1vKs75eJvNB9?=
 =?us-ascii?Q?P/IGGerWoXqFNU/EENNtQngHxfhGRmse3dYknCi6SuHFfN45AizLpW9o+JvF?=
 =?us-ascii?Q?840ZaYAwqRGthPae+UrSWn+HvYpkJx97VzFVRhlotrC7rGDdj9+PjuQOT/dB?=
 =?us-ascii?Q?J2qyej5IDG1KNRQo2psJ0aUQ3cUPOSUc7pKwuOUEQqrsgaYYOLIG8tJpOTME?=
 =?us-ascii?Q?4+tRD+aJTHThTC0YzSkEwhQht+OagQTzL74TH2UFBXhXI3pPM7q+So4aGaZU?=
 =?us-ascii?Q?SJj5fKlXi0DkxSlEN5dF+ZWvg6q33KgzmkxMgQ0FDDGrsGRD0D/c6wdtHpZu?=
 =?us-ascii?Q?+s9Jws0wxqFgaiiaWpORbgnOh4/Vwa1ycce/adtqImOxCf0TyO6O8QNrzWDt?=
 =?us-ascii?Q?xVJBPVuk0Ra9HfKy77R1kiLdDDkrL9LjU65gDWQb271WXgNHowIPUkq/mNCp?=
 =?us-ascii?Q?8apFvKhfCh6iWiBjjkpuRBBwGgfVRFZmopNtQKn++iDznwzIjGS5gpnxlXCR?=
 =?us-ascii?Q?rtDR7A6tHtOkXDAmso0AhjvztCD4E5yHCKkIopVU?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 197b8d38-c0aa-4cad-326c-08dc99918d60
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2024 05:49:20.2004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oAlDVT6PO9Q3Pl1sI1yR3fDj4aCaPLe1DRwoF65x83TRAhTQJtesYB7/XtPI+Y3WafFCoHkhGLYJPBXclzuwAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7749
X-OriginatorOrg: intel.com

On Mon, Jul 01, 2024 at 01:44:01PM +0800, Yi Liu wrote:
> On 2024/7/1 09:47, Yan Zhao wrote:
> > On Sun, Jun 30, 2024 at 03:06:05PM +0800, Yi Liu wrote:
> > > On 2024/6/28 23:28, Yan Zhao wrote:
> > > > On Fri, Jun 28, 2024 at 05:48:11PM +0800, Yi Liu wrote:
> > > > > On 2024/6/28 13:21, Yan Zhao wrote:
> > > > > > On Thu, Jun 27, 2024 at 09:42:09AM -0300, Jason Gunthorpe wrote:
> > > > > > > On Thu, Jun 27, 2024 at 05:51:01PM +0800, Yan Zhao wrote:
> > > > > > > 
> > > > > > > > > > > This doesn't seem right.. There is only one device but multiple file
> > > > > > > > > > > can be opened on that device.
> > > > > > > > Maybe we can put this assignment to vfio_df_ioctl_bind_iommufd() after
> > > > > > > > vfio_df_open() makes sure device->open_count is 1.
> > > > > > > 
> > > > > > > Yeah, that seems better.
> > > > > > > 
> > > > > > > Logically it would be best if all places set the inode once the
> > > > > > > inode/FD has been made to be the one and only way to access it.
> > > > > > For group path, I'm afraid there's no such a place ensuring only one active fd
> > > > > > in kernel.
> > > > > > I tried modifying QEMU to allow two openings and two assignments of the same
> > > > > > device. It works and appears to guest that there were 2 devices, though this
> > > > > > ultimately leads to device malfunctions in guest.
> > > > > > 
> > > > > > > > BTW, in group path, what's the benefit of allowing multiple open of device?
> > > > > > > 
> > > > > > > I don't know, the thing that opened the first FD can just dup it, no
> > > > > > > idea why two different FDs would be useful. It is something we removed
> > > > > > > in the cdev flow
> > > > > > > 
> > > > > > Thanks. However, from the code, it reads like a drawback of the cdev flow :)
> > > > > > I don't understand why the group path is secure though.
> > > > > > 
> > > > > >            /*
> > > > > >             * Only the group path allows the device to be opened multiple
> > > > > >             * times.  The device cdev path doesn't have a secure way for it.
> > > > > >             */
> > > > > >            if (device->open_count != 0 && !df->group)
> > > > > >                    return -EINVAL;
> > > > > > 
> > > > > > 
> > > > > 
> > > > > The group path only allow single group open, so the device FDs retrieved
> > > > > via the group is just within the opener of the group. This secure is built
> > > > > on top of single open of group.
> > > > What if the group is opened for only once but VFIO_GROUP_GET_DEVICE_FD
> > > > ioctl is called for multiple times?
> > > 
> > > this should happen within the process context that has opened the group. it
> > > should be safe, and that would be tracked by the open_count.
> > Thanks for explanation.
> > 
> > Even within a single process, for the group path, it appears that accesses to
> > the multiple opened device fds still require proper synchronization.
> 
> this is for sure as they are accessing the same device.
> 
> > With proper synchronizations, for cdev path, accesses from different processes
> > can still function correctly.
> > Additionally, the group fd can also be passed to another process, allowing
> > device fds to be acquired and accessed from a different process.
> 
> I think the secure boundary is within a process. If there are multiple
> processes accessing a single device, then the boundary is broken.
> 
> > On the other hand, cdev path might also support multiple opened fds from a
> > single process by checking task gid.
> > 
> > The device cdev path simply opts not to do that because it is unnecessary, right?
> 
> This is part of the reason. The major reason is that the vfio group can be
> compiled out. Without the vfio group, it's a bit complicated to ensure all
> the devices within the same iommu group been opened by one user. As no
> known usage of it, so we didn't explore it very much. Actually, if multiple
> FDs are needed, may be dup() is a choice. Do you have such a need?
No, I don't have such a need.
I just find it's confusing to say "Only the group path allows the device to be
opened multiple times. The device cdev path doesn't have a secure way for it",
since it's still doable to achieve the same "secure" level in cdev path and the
group path is not that "secure" :)

