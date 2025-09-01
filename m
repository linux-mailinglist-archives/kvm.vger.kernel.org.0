Return-Path: <kvm+bounces-56395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DE19B3D64B
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 03:26:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 29A603BB115
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 01:26:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B11721F4613;
	Mon,  1 Sep 2025 01:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f5GCmpxU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6691F948;
	Mon,  1 Sep 2025 01:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756690001; cv=fail; b=WdGf1cp8Ojwz4J2Bbt9NiccCEQv7yBZECVwD7JMzqhW37bQs3tMkxZUzitYoF2sm0jJRqTtVdnuI8wQAdEH9ClQaCHUXuVHpjskkE1GghFukAmWfeV83Cj1O7tNv32Ezy4Zi6Gxy0I0vwixeRWDx1gPqyY4jbCTbzBysFtoq1SU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756690001; c=relaxed/simple;
	bh=F2b3Hp/arEtVPN0k0xWdG7cSVXgCiculwZtJ8f19//k=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=m+bDLOMFgCqu2Sx4unb72Y35riZVRDot3JhsQUfMLmneZDxk0EG6VIZVeZZFez1KDJN/sFugYMIwH7jyeVjN2oSGScRkA+h3c50f5hvN2ERarBNi3h9N6VYYMuRiE31HlSYI/hJ1wUV+2Tu30zFc0lsmw5VGrq3m68TadEG4AIw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f5GCmpxU; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756690000; x=1788226000;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=F2b3Hp/arEtVPN0k0xWdG7cSVXgCiculwZtJ8f19//k=;
  b=f5GCmpxU4ZyX1giFBSp+MdvzIxtml0tCECPVKQphYCsAJytV93Z+vJrK
   4bXe5PbLDgZp0b5xqLaby2ZgIcxiN6YxFbBdl5E8nb3YhfeYp+fp6aHlg
   pUOjQF98tGAVFLamcSS4cx5YLUxMzxuHDMTNoOsc3XCUXOYcqTa/T3ZWT
   E6t9yYObS1me7vy+OzfikMOqDv6mihLYzwg6ZkXDwbfTIrivMyrP6b2hY
   INd2VVtaqTumlGRFAnQhfNarSaY0p/CPMAsV0Rssq7nAA5KLSA0dxVFC4
   /i13uBeV8ukFhY3ZrcDfkZaPQvcOw2042/oNyC27RZsBMjZxeYArGPcnv
   g==;
X-CSE-ConnectionGUID: NdJVe1/bRDCYcvWoir/mJA==
X-CSE-MsgGUID: f2yttiwnSY6Zf1ldMqR6rA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="58836495"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="58836495"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2025 18:26:40 -0700
X-CSE-ConnectionGUID: FddIDDJrSSSU7IMpAbSbug==
X-CSE-MsgGUID: ztpVhdflRlS0hXMk2AS2GA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="170143460"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2025 18:26:39 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 31 Aug 2025 18:26:38 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Sun, 31 Aug 2025 18:26:38 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.60)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 31 Aug 2025 18:26:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EiiPq9hRpHv4Qtn0XEZo8qCtFOxFcTaREX6yAuPTQ1Cw/AKKK5AfHeSQeLuEw1P/tNhsFAg+nIHoYaeuZG5SAhFJGleVyRLrd7GGGtD+dtzgO/nNfI0RFa4x1xUR3pM7zvgcgAisZPLHyJesjzPrQCADTZm2UIYWWx87MuedmJFVEkwPcMVPT6XCqxpDjaxBEFjsbYSk67/WGWvzZWwkvqRZs5u394gtbA7c/QK5jph04VNwct+gmnEkBGPmB9M+MHS6Kx4F365LyVCfkPw2Vu9eFL1SD7fszTLLzGgS7Sj9xUrecFos7KXihQqhsOYPYcZsqWGm0iUIoHc/2iUIgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gzBF+1UPt/lsOFoWkvM7fpuCSrnBxwP4avgcW4crnAs=;
 b=vsdm04Y2fkFc4mEkpSd9ldtQBqh7mdF/57jQzU2FawrBzDf0hHfajQJMlrnx95ajRasajt2/Zd13a7K2IReTaGI/GXPPnuM348Sh/Otq6EQoYm4ipA9V7IHbLRleKGcsYBXiVnEzEk2el8s/oDJwsFXtAlFmNqR220vCKgu29KYQy7fEDrlgbGhfdygs2mkbWS0vzYSHhLVPsgCpz6cU2hYRbnIGMVh4GuIQUzfas0rr/uw4HJzNIVnNU95ufA8ssv2+i4X6aSum7RPNIRfDrSfrI/jf3aRvI+Ekbvyp3Rn51+E3CW4FhlBtTIBmynRMGu22AYUH4I9SAEi1PWMunA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH3PR11MB7817.namprd11.prod.outlook.com (2603:10b6:610:123::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.21; Mon, 1 Sep
 2025 01:26:35 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9052.013; Mon, 1 Sep 2025
 01:26:35 +0000
Date: Mon, 1 Sep 2025 09:25:43 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Weiny, Ira" <ira.weiny@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>
Subject: Re: [RFC PATCH v2 05/18] KVM: TDX: Drop superfluous page pinning in
 S-EPT management
Message-ID: <aLT2FwlMySKVYP1i@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250829000618.351013-1-seanjc@google.com>
 <20250829000618.351013-6-seanjc@google.com>
 <49c337d247940e8bd3920e5723c2fa710cd0dd83.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <49c337d247940e8bd3920e5723c2fa710cd0dd83.camel@intel.com>
X-ClientProxiedBy: SI2PR02CA0036.apcprd02.prod.outlook.com
 (2603:1096:4:195::15) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH3PR11MB7817:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f7f2181-347f-49a8-8cd1-08dde8f696f2
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?4UpEIVJzErbIn91GDYWSbUCeJtT+a2W8+elPOafcpU9wmP08/2zfHW8wIjsL?=
 =?us-ascii?Q?vIywMEof/xY4E2B2PheLnnpNhyMRWNvQVLXw+qhfWJdQdb5aRYdkVPlP770+?=
 =?us-ascii?Q?TeWkfUBTowcvrDHdpoLWC36bcyoaREVOGcWhRYE386y2IlvGOfVGrwJ3xD+S?=
 =?us-ascii?Q?p5oY+d1uTpj/41pv9O+bakpRwejCq98kRprOBOJih5FC7sEM5i+KS0nerQ+p?=
 =?us-ascii?Q?f95Tpc1wBptNLNrPK9H8YG+Sk8omiafpl97dnCZkyLL30bl7v3x8aFqMrz8I?=
 =?us-ascii?Q?/kxtP7c6Jyon7vWpHbQN5sDl4OVnqTQdpmmdsqiuzuOG16KgX+XmX++Hj6pV?=
 =?us-ascii?Q?b/76xCGHNmBV5U9WescMyd99KZ+YmY9bxZVw2I/3qZIQj4GjiHfpZKd29YwL?=
 =?us-ascii?Q?UVj5Eco1Aw0UaeoAYmdJCAT+W5HAITG5dg6krQtQ+shyfgZux3VsrhvD9kxh?=
 =?us-ascii?Q?K54jVmNP59a/78IMIu0yn+exU8QV3zV+9MNvlwNOb9YkFpjuJAzw0nWLOZvx?=
 =?us-ascii?Q?kO2QzzKbpS1OpiBb/2PNIgXpeZJiswZtSrKBdBPg5XFWRTm5TgSz+lwVSBW8?=
 =?us-ascii?Q?bBBzZKLAkU61cDgcW22lhhWJzYB/OSTyNLYcbGesKBp8CvcuR8IptmFBPi02?=
 =?us-ascii?Q?XiaxK7WGPnRngQhsLZokmBhQM+8kvWzrPZ5+v7V4864wHlmdCLVmTWBl801F?=
 =?us-ascii?Q?JfJ5701ylU335mP3wpADP9JDvOSN/0yZrk56uPVF9+xE90ABPTWY8bb4lX4R?=
 =?us-ascii?Q?wbffrkTxqDY/lRgFkrCCNaTTnkr5XPREm1CYXbfu1/GCL01m4koGJNCs8+Jz?=
 =?us-ascii?Q?Tg9ASwxTnZ/r5zrUJsPzTXdftQKmhz9uEorPN2DDk9O9CAKjxxUv5kRPMTrN?=
 =?us-ascii?Q?TJiLvmSfGMO814eJKJhp64r8WSkN1PMYW+czzlNr8zRDr+uEvd4Vp3BZouKX?=
 =?us-ascii?Q?cJC/BB1Y/HLL5vxq558ixDIZKUYgSfO3JasNN7pewnU4ezdI5xV8e6kZ76KD?=
 =?us-ascii?Q?aA1lZq1K3cZVRVvPI8jwIqeIuFEwWrEY8zbPHP4ZrDSp82ZxDVuMdvqfBUr/?=
 =?us-ascii?Q?QG8X2ojdC71SQVj9C+ooSCMXxy17OK0PDGMNIe1d6KPnduGwOtP+y69WOCp/?=
 =?us-ascii?Q?KnX8PySpmKuKg+G/j8PZIcwbF7XB+ZQDVcKQrEnM0fXi0whsnCnzi29kqGKI?=
 =?us-ascii?Q?y5uVNKfgpsCuXcsPD9QGlbq1E4WvW+JeTGQ2G+avhbXCufKx7bD0tjKve+UO?=
 =?us-ascii?Q?IB6G2PM7mIzYUhWWLcmtmxzlJJxiGr21r0/FiVjYb2FO1P/cEzcTU6MVBALw?=
 =?us-ascii?Q?I1lVtBBR/A7/Ei0sRm3cTVq86jsuBJpwwF5ax0Y2BTqDor0KVWRkefCZnY47?=
 =?us-ascii?Q?jZk9ox2gsuY/GolX0asPTgFlvyM3GYJqqYl+zwZOAvX3GKbgPgzL3Bcw9r4p?=
 =?us-ascii?Q?zqRfvYrxPRU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4mqu4xaOIxGhTbWwf4hiwlFo+WN8ZrF0KaF17w3Ov3qtHnnxtflbv0Q3ZPuw?=
 =?us-ascii?Q?1S8Mz6eNZfRUkb+ds3PrAGCZQ6p4JcCzaK7WHIDGRmvgIqSqwYQnGnunYrSP?=
 =?us-ascii?Q?H58F3GU/9G8zJ/y5R/IlZ+7GN02f4BMElBo9ouXtdMV6kht/5PcnRNBZaWw4?=
 =?us-ascii?Q?1qBGNaU1wGP/utQ/o5Fy6coFImKPMNYXahdVGzlaULt+DMsquNezvMVt9HW2?=
 =?us-ascii?Q?53xSER5y5Qj7ZEupJeaDGX71U/t1Vh1gN2NT4QloHGmP4tfH5JrTVlPTaCl9?=
 =?us-ascii?Q?e3ORXGAfpBUFlBUKi7l8Q4UiLp45rjmxI8xE3wcr/oxNvGBx6XeEWN2e5rHe?=
 =?us-ascii?Q?h53BJWXW0LXJ1NPKQTRkfWsWHLSyxtZmMNIzJS5vAQOgSEYW3+nYi8RM43pY?=
 =?us-ascii?Q?mHvehFQqOgFu3LvOuLdslAW9dXuKwINtL7iiXGrOVUo/+b8/REFHbAhme4PT?=
 =?us-ascii?Q?jeeEvchnP6cEPxUekbYhJMbNcWUrpZgcaKDRu9sfqpuL4F7Snfcg5WuzWDUw?=
 =?us-ascii?Q?fmORk1jyUfdJDZMpYOjTmU/3qql0AP7FeAkZxGy2Ogfje+xWResSJ9rp76or?=
 =?us-ascii?Q?ux+97aIiKAYpc0enaKu+AHBj5Ms/GkmT9p4MDbq1/n4cpIV5aE49ShAYGodZ?=
 =?us-ascii?Q?Y5ZvqaCAxGqjW3i7MvfSZrB1Ez0tPrMUxZTSws+zKqrPb45eO3GBWn3Ygm6M?=
 =?us-ascii?Q?QfCued0ZIl/EobESnVQFHzcfoNaS5XIh+lXKIj4z2hXgRs9xg2y7DeAb5NFI?=
 =?us-ascii?Q?ZtUi3Gu3sXxSnsUJ4L1UNgn201ekdbxq5aohloEFX1DHA8qUlkbmUcOCKtj2?=
 =?us-ascii?Q?p2Vx68R+MYSvxGRrPaYKl+K8XJEWEAtbMPcOTkk2N/YuZWenNeJhwTSFxI9k?=
 =?us-ascii?Q?YC8ofM6CpHAJjGhaGZkQIPtkq8gesiXNd46267VNNGwlM6oyKIEaIJUpgyue?=
 =?us-ascii?Q?QzY2oVMiByrffbvpkjrdFEPgz42bQApVMb9nyhcsk6S39tAhcPUFzxVfsk/L?=
 =?us-ascii?Q?BHFC0eduM1Ga2lWVi2XyRsDxAbESB8SKzTehpaJEaQpuj0OdudghCn37XoWn?=
 =?us-ascii?Q?60eVnJXNKkWrOsiWKt8qqs6AyEQtLn1IFmyQQK7UQCiZUtwxjMpzfFHeQLvr?=
 =?us-ascii?Q?d1OQg0mxpxOvNnMnx1vH1tq3RserESK6jhvHUF6wZ/JH7UIQ2j3nRhP0tKzI?=
 =?us-ascii?Q?n3RStgHp5ePp6maR2YoX0LIFFqxWRk0HNI+Sz5PQUWEi/p4CAlABRi3L4BDU?=
 =?us-ascii?Q?FF2Cs0M67Cc5xOc5dMdz42LlGRjNiaiJpANrDRZck3vI3zgWUKThs0xM5DnI?=
 =?us-ascii?Q?cZHhOZ9gt3lHz/DoWxUC9NyLs+Y1MfkeUkNxTV70vTAHoiv/CUxwOIvG6Nc1?=
 =?us-ascii?Q?f/eADlba3PXRWzUGB/NFDpitquc8Ax2NQNtVOsyLBRRjwroDjaARcm4HGBYm?=
 =?us-ascii?Q?x6tlrSG664FOHAD0IvUZL9Pj+P6xJG10Oit0mec9G61izTZaeY4uECUQmBoF?=
 =?us-ascii?Q?HGse0MRS8i79QJGc6hiHiMJNHIiqUX4oR62e5iRe3o9Gu3q2u9lmYFVB4GK2?=
 =?us-ascii?Q?pe3UYxGJ4SfF4tOLN+uu+lxM/kJS1H0E7YiH2YK8?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f7f2181-347f-49a8-8cd1-08dde8f696f2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 01:26:35.0708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z8YarPHyRqHoyT3cA5TifbfrGxYVmzhckA4hu6rsqhIZ/Mw/KR6uty9B7TMACcptKZibo4g9WRGTcgefTIOhZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7817
X-OriginatorOrg: intel.com

On Sat, Aug 30, 2025 at 03:53:24AM +0800, Edgecombe, Rick P wrote:
> On Thu, 2025-08-28 at 17:06 -0700, Sean Christopherson wrote:
> > From: Yan Zhao <yan.y.zhao@intel.com>
> > When S-EPT zapping errors occur, KVM_BUG_ON() is invoked to kick off all
> > vCPUs and mark the VM as dead. Although there is a potential window that a
> > private page mapped in the S-EPT could be reallocated and used outside the
> > VM, the loud warning from KVM_BUG_ON() should provide sufficient debug
> > information.
... 
> Yan, can you clarify what you mean by "there could be a small window"? I'm
> thinking this is a hypothetical window around vm_dead races? Or more concrete? I
> *don't* want to re-open the debate on whether to go with this approach, but I
> think this is a good teaching edge case to settle on how we want to treat
> similar issues. So I just want to make sure we have the justification right.
I think this window isn't hypothetical.

1. SEAMCALL failure in tdx_sept_remove_private_spte().
   KVM_BUG_ON() sets vm_dead and kicks off all vCPUs.
2. guest_memfd invalidation completes. memory is freed.
3. VM gets killed.

After 2, the page is still mapped in the S-EPT, but it could potentially be
reallocated and used outside the VM.

From the TDX module and hardware's perspective, the mapping in the S-EPT for
this page remains valid. So, I'm uncertain if the TDX module might do something
creative to access the guest page after 2.

Besides, a cache flush after 2 can essentially cause a memory write to the page.
Though we could invoke tdh_phymem_page_wbinvd_hkid() after the KVM_BUG_ON(), the
SEAMCALL itself can fail.

