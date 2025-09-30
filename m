Return-Path: <kvm+bounces-59053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 80E33BAAD7B
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 03:10:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3299617F706
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 01:10:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 753BF1A9FB9;
	Tue, 30 Sep 2025 01:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c5cAnHvK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08D51C862D;
	Tue, 30 Sep 2025 01:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759194634; cv=fail; b=aZOGC+1xlk9eA6eViiqrYaDwcE2ARAQRZMr8fYW4xfNye4pAOLuTjX7f5ek5V9mQ8lTVQ7pNQ/mz8rd8esFqh4rOLcBt1f4AcnCpyo3WvlSq2bacBijYGSMkFpTJ2VAaTB3NaIbR0gwZtt6bktBZz9fycb3DW51zp+QJCOvEy6c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759194634; c=relaxed/simple;
	bh=nJEfiGvvpJ1YtmZhRi75booh5zCb0le8Mr/BaYu8sFs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gkLarT1yuJCIoXrPfvfH9acKF1a9aFBd0O9UtWDsYfGhOnDxmkmIs4hNzMRfrU5LTWjGU2UDMtDOruz9WMRz+/M9fOzwBD8MPgfy1CgrRsR3KuPJGlqani2Q8IFWGZpiIAWpLc2+mSIPITSbqdnGxaFXTLy/KPyJHzq3SMX0k8g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c5cAnHvK; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759194633; x=1790730633;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=nJEfiGvvpJ1YtmZhRi75booh5zCb0le8Mr/BaYu8sFs=;
  b=c5cAnHvKT82VPJtp4nUl5WTXykFeebwi/FNXB9R5iqRG5YSvCJLyYNvl
   /0qnbJWCGr1Yqqr+nuJaFRfBVFWJG9u4d6yLJbvwOu1kSXhv4pbDYjD/C
   I8+GcXSJmQ5N8gW39I3ZGLqfAKxhlT+5kx1dbsZUEFQ2W9d5RpSv7mon9
   jOWnkewT6u8weLiZAqkw8X02fg5Wlx1+pq49EAXxpT3UfCF1A5SbHFwZT
   UqL039GEhFZJ+11GqEuTgMuuJy8eb5YTIbZJZlrPjVL3C8sII1tfGUE0Q
   cfY7Rwf3e/ihastTTFsnqwUTBprwf5CdaAOS1llaFKVGwTkiS3ukZNFE3
   w==;
X-CSE-ConnectionGUID: R1bsHNgLQJyw23Mp4W04Dg==
X-CSE-MsgGUID: uBMHUsaDSp2QdlDNc0QGWQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11568"; a="78867405"
X-IronPort-AV: E=Sophos;i="6.18,302,1751266800"; 
   d="scan'208";a="78867405"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2025 18:10:33 -0700
X-CSE-ConnectionGUID: qeITrPb3SgWrC+LUIdbPQw==
X-CSE-MsgGUID: XCyOTdDiQLWewJuX0AYyRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,302,1751266800"; 
   d="scan'208";a="209097631"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2025 18:10:32 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 29 Sep 2025 18:10:32 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 29 Sep 2025 18:10:32 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.64) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 29 Sep 2025 18:10:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X177aDTJVf5RbW4Dq+Q9eNlE3G+s/ujIjwVvaQYkchba3QVMoxnD0ONJVesEtM4ypoT49iHNhP2jMc8FxSQIYqBf+Ai/fa0XLBlbT351pKX+KP4Ym2YkEpWOn5T6NqVIovf0S/i0jnxbc9dALKJA6okraQwhn8AhVbX4rDD95G3Y+H1CZJgjFUuE5IWtvQwzYHCwD41DeCwoYPKb77xWUGoUZgwCBE+FiMUp60U9bvdtgwEepM8aEOIJ+ZWhWJe9V8JoYpUKGwaxyxZ/B4+OZmEbIEMGc1zajiXppWvr9Infeut+x76n5cDHhHqt0duqBQ3MNXAK3NnNYZPiwnGEnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E5zhmwU/jKKJ1+LnupO7xCX1Ujm5gINHoJZaovmewsU=;
 b=JNzNGfzt8spLF7b32bOyK623tCEKCceCxsl+V/BHp15aYmJuljNmThYAOK5drGdxLufIlZZB0ChppEZ75uoaKbmPHiBF8V4f93EQaWLE5dx8FfdHHUmeDULzdJIebLRLaCIpZcGQB4JtGo/ihIVOXcoZZHlMvdsiUpODkFAd5u6ADGcxx8/42Us78euPWG0tf0Mf4cQclv5htulkyGIHA9KFBY4oHEPRF1ZQafJexBiVN1NWqC1+jL/bJg93keLcN+EMZ9Dh51mUXgf7oBkWlglGalK9wurv8qW0nl9on74VMWb5svB2jmf7fgEcnssRlA2h0ZFuzSQmArIRNbiIeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB7661.namprd11.prod.outlook.com (2603:10b6:510:27b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Tue, 30 Sep
 2025 01:10:22 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9160.015; Tue, 30 Sep 2025
 01:10:22 +0000
Date: Tue, 30 Sep 2025 09:09:12 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
CC: <kas@kernel.org>, <bp@alien8.de>, <chao.gao@intel.com>,
	<dave.hansen@linux.intel.com>, <isaku.yamahata@intel.com>,
	<kai.huang@intel.com>, <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <mingo@redhat.com>, <pbonzini@redhat.com>,
	<seanjc@google.com>, <tglx@linutronix.de>, <x86@kernel.org>,
	<vannapurve@google.com>, "Kirill A. Shutemov"
	<kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v3 13/16] KVM: TDX: Handle PAMT allocation in fault path
Message-ID: <aNstuNoT/kp6XGGR@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
 <20250918232224.2202592-14-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250918232224.2202592-14-rick.p.edgecombe@intel.com>
X-ClientProxiedBy: SI2PR01CA0031.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::11) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB7661:EE_
X-MS-Office365-Filtering-Correlation-Id: a318dfbf-dd65-42b0-d50e-08ddffbe212f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?/TrdOUpXIoey+Hb6/GMpQNy4EhXuiL/L5sTPJUTrfr7/kHdrhCAd/P00/ORA?=
 =?us-ascii?Q?pRHXmMACp8MSyGL4TOEqb8112xkn7XaG4ADpUnXWjLJuJRJta8riZ6d9GMbC?=
 =?us-ascii?Q?Qg0Tcm3Ppb6lFVOVYgdw2l7bwScuTYngNobpUVV/vSl+bF5GCxFmLfINUWoe?=
 =?us-ascii?Q?sQoA+vqsyy9jPUKnWURIjHCHon/IgsYwHnuyu0i1NqjFOSkduKh7GShdq2WM?=
 =?us-ascii?Q?R4fqAsYvywIHT+ocwGFR7cKWm7LVSYIIlds46PxR9dhVSoDgzM41fo4I62rI?=
 =?us-ascii?Q?VA34uSDQ3omby0XARWVe6eYcQ1a8MucNYfBVErI+j+sb8cr3b8lSNqw25BJ3?=
 =?us-ascii?Q?n7miGJh31V36IK0UpN0XvBdUvmPDYoAM6X4qA/feHkzeFflas6p8kamN8KoI?=
 =?us-ascii?Q?I7hIQmCHz8Q/UbXmIsK5mmgcMwdCi/tbAYbNcBnoPb2kauRX1UY8VTT0krjB?=
 =?us-ascii?Q?P/f6V2D05/9psZf7E88BnEaYMo58syfPkae56Svgu+Q0sPMZ9REtxLeOvhwr?=
 =?us-ascii?Q?1gSxJlyd9BKsyIVoI7G+fj9qZ4dt9z0J12lzKQZRGMBcgtPudeaIYjCZHLrC?=
 =?us-ascii?Q?TDDEqqMjOdmfAo2uVCVinAwnnNM6zV5WTbGAtcKQQK3kCdgmquvBCNHYwREA?=
 =?us-ascii?Q?V96dhv2/hNy61dbnBT5m6YawEaNCKY3TPCmfW6/c9TtwXQ841Itx7bOcc7Tm?=
 =?us-ascii?Q?Zx8y6R8uqumL3NOM+unWFH5bNqgFLJMKm9SXs7+310B19EWlVFH2aL7xVB1L?=
 =?us-ascii?Q?KNPfLyt4DxvMD3RoVBD/2laMjTCn/rCjnHnzbwJWdIOXOlI7VfWjYmBLlrXp?=
 =?us-ascii?Q?lmE3igkC7IgZW0tJ0YYKtUSLQqmle8ajlIX320fUUd2SFwTBeYjyF0Ecu7Cg?=
 =?us-ascii?Q?iUGokfPK2LKOZ9L/nyzkRTJlH+dQo3gsCneYasNjbw+1u8eVDDi2cTL4a/bY?=
 =?us-ascii?Q?mqELcOOj9YfqJ1AeYj4iazKjuIfJf5TcY+B2mc6o9MP6SphdBvyoub34LjKk?=
 =?us-ascii?Q?8OyElpch3WJGhbhxVmd8iVMMdz7WT0oziWZND78EHdnlT79HTL19yZYZDl5/?=
 =?us-ascii?Q?ps5WT0/dVSWJSFcPUc1EkPTDtxOQK+y/PjMneW72mFup5LvNvDJrWVErlbL1?=
 =?us-ascii?Q?cJxW6FQ9m0egv7DaAI0lL0R2raF+PO457P30TizWJAT34Ble1QpJaT2MtBgH?=
 =?us-ascii?Q?HE+MX9OnTdaMDGYaeQ8pa+yQGotQPiw9kCh5MxvssQTHT1HaMC/K1xq5wXxx?=
 =?us-ascii?Q?J8qH0lBq0sXsA6MEjwAouui91k7Pda4WQH20mmIwgoMaEVX3DfEvhxzdjRnF?=
 =?us-ascii?Q?gTEDjAyqjnSN0dorDeJqDlTy2WOwqnMDQEZJsfunnLoeemkgbLjnYKZl+r1A?=
 =?us-ascii?Q?cE+mID5ZgXM1iUNsXX2l2MJ8ckbY5k6Gd/buGKNmc9n1bYVQ+JkBsMxH25Tp?=
 =?us-ascii?Q?7OmVYhOm9athWhBEObLujn8bvg6maG3T?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jc+kbVPyRagnaZ4yMpWXcTPNFWxqScqm5zAlGNurXwZ1nWU8wIXlPqGnH9tN?=
 =?us-ascii?Q?DLuYGhEz9K7TPsWe0/c3wUKS3McU9IK/BZWNsC3jId5ympM1jBVG105Sk5S6?=
 =?us-ascii?Q?cdrB+H71QA7RlzeeIB1COFWMbE5iLKnE8/G5fuOQo83YkpWS470u6ixJpr+t?=
 =?us-ascii?Q?8nAy0mUOiDEKk32ImZMKudNLreq9Rr/3kSqYNFENcmca3BB9vp2ncuVm1r4S?=
 =?us-ascii?Q?7IcEpFHZe0vC6ogakIakwJbBLARtfHVD+SUQWuHKSThMSSWCBQEifWuk84QT?=
 =?us-ascii?Q?sszRSWHCPC7uMDjj7qblbi3nMIiZ3BZT+RAeFHWsl2ZJNjzjlQ0WXsrp0ZYH?=
 =?us-ascii?Q?51AufY2nZIUSIe6Pkdw25/K7D1eI/443zyQ0yRJeLYwFsj/M4DvQPn/oEpHc?=
 =?us-ascii?Q?LTRyQjKeXyzF3aXN5MTA01MRhhwnbe0bsPpT8JzwWH9Ait/ZAlb/yuZQB/L5?=
 =?us-ascii?Q?iBrXSm0GMq01rzGPH7VvC+rSF9USqEsxmA9kp0ZkJjx88Xd/vODVnuzb7QPR?=
 =?us-ascii?Q?Vy8szkdqj6ucTOADuTUj+elpq4Wag3g6M3DoquWFkcDFSPSKa9Tz17HqXWOX?=
 =?us-ascii?Q?lcKzCVYhUd9rJLj3/pqCMGmixuCiFXTiTtaMT3G7WctC6h3P5ERvexgJWoQr?=
 =?us-ascii?Q?TWg9vqLnP2PO7SW2GMnBhoC/ZrNcM8Bc6dVAOq2wFA1wPkLnOM9xbr4q7hOC?=
 =?us-ascii?Q?3abOWYYk2gVbimDkWejGmdbR4vmAselndzbkh6eEM4nXn2G1iLefFWDaP9NK?=
 =?us-ascii?Q?HtkenAoZJ6QfG3kAs5w4zbUo7ldk+jcHvvDWh8XfZvcH5z5DZm2l4crdUQ71?=
 =?us-ascii?Q?JUFzW8TzZlTkXe8XgzLCZMwzv0CbmfSDOVPy/QlUX7Mx3S+tdR2MknforvNg?=
 =?us-ascii?Q?YRkkH9FEpMqnOhfVkfGYEazfyLeaCcmfdKw17xA5n9YGxATJv1/lPddHFK8Q?=
 =?us-ascii?Q?yl38LBGaRpGXU88/r9e8Z74q1n9G1X1H9ODOnJsdbm20VnBfYHvR64Cfedq7?=
 =?us-ascii?Q?7Eb/omgisSIoG4Hu+A7VZTu+PAOOQWXhp1nF6K6c2O1lV8YdU8wA1uCdm8Eb?=
 =?us-ascii?Q?sbRoMmjv0fXRUjneh+hp/ZVYY0N5811M4fNemyn7HAnSaG/70lkmCWHveQmw?=
 =?us-ascii?Q?OF3pQ90DeTeVRtIcVNUFk2V7GMZiDe+2bBEkMQxSuOmo4mhy5lyP3LezDPd3?=
 =?us-ascii?Q?dMKbg4gi7yvL8fdL9Mc6/0DYSIhwkrnEQ5PYa+SidtjTxwRgSBRTVdghJvFd?=
 =?us-ascii?Q?7lHMqafYrXDN1uFz1/tHEwpD8px2EpESDR/M3Wl7ai0JxIjraI8xLGQK5x8s?=
 =?us-ascii?Q?rqOQe8pU5HWccM9HYlWkvrWUzpQJ16ivbJ1BDFP7zuw8GP49Ld+MAmf1nxov?=
 =?us-ascii?Q?4UQMdZXyefc7uLHD+Rw/YasvNnnaND/9hopDg0tPVnlS/ylS70cIzQzzYV4Y?=
 =?us-ascii?Q?fj9t93Qxi8GGZyryzZIQjbiTguf2GRp6DJOZhs4JTS7pEx8RafQZVN5XEcnD?=
 =?us-ascii?Q?crNahuOcUA3KPmWLSzSLAPB7Rtdn0rggjCbS7wn0t+Tp9/2pfr1BIed7V3RN?=
 =?us-ascii?Q?N0WhDWJP68EDC9jjlBTZ/fpj62KjfOLsdbEl3WJF?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a318dfbf-dd65-42b0-d50e-08ddffbe212f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2025 01:10:22.6412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xy8Eo+OsEP57hq6TSMKWq1pbt6rkMTuqxzo+eaWgxfCeS997ZnOFso4X068y2WvdKw0pDgFYjYBGU5pf/H4Hlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7661
X-OriginatorOrg: intel.com

On Thu, Sep 18, 2025 at 04:22:21PM -0700, Rick Edgecombe wrote:
> @@ -862,6 +863,9 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu)
>  		tdx->vp.tdvpr_page = 0;
>  	}
>  
> +	while ((page = get_tdx_prealloc_page(&tdx->prealloc)))
> +		__free_page(page);
> +
>  	tdx->state = VCPU_TD_STATE_UNINITIALIZED;
>  }
tdx_vcpu_free() may be invoked even if the vcpu ioctl KVM_TDX_INIT_VCPU was
never called.

> @@ -2966,6 +2999,8 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
>  	int ret, i;
>  	u64 err;
>  
> +	INIT_LIST_HEAD(&tdx->prealloc.page_list);
So, need to move this list init to tdx_vcpu_create().

>  	page = tdx_alloc_page();
>  	if (!page)
>  		return -ENOMEM;
> -- 
> 2.51.0
> 

