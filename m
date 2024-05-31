Return-Path: <kvm+bounces-18569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CC0B8D6CF2
	for <lists+kvm@lfdr.de>; Sat,  1 Jun 2024 01:42:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 704901C225FB
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 23:42:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9594712F596;
	Fri, 31 May 2024 23:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jRk51JFy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B890134BC
	for <kvm@vger.kernel.org>; Fri, 31 May 2024 23:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717198935; cv=fail; b=kx5vnh3nptpdxXsB/cY9KBADtByLI5sRfJkntW+/aRPKEbQqYTrPt4FVEgjJU8XAXYYzAkuwsLXfxqLPXH/S3YowHnr0iIucdNf+4y2dW+/233tsRwLROMSrWL0GMaPqa2fsgZKOld7ss7D3aC1Mm+0s/b7Dh8ySuXQmoVyVNas=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717198935; c=relaxed/simple;
	bh=Yj0ZK/4Xqf7q9lWFrY0BF2nM8xpesOYW8SaJTcvl1Fw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Qn3PdfPvu3EzcYwlORV1DKvZ3BUwxjFX8TBFXDmtmBRHCYzxgAZuMoFDDzTU1+otRkW2CPd4/deRn7LQjwjHoA+u07Vyj1YPhaiDiPyJ90gJ2Utt05/EANITvPXxoRAMNqn3ffsEwqnjLsxoqUCwqeq7FL1L2Zo8XsdgrKV0KMM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jRk51JFy; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717198933; x=1748734933;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=Yj0ZK/4Xqf7q9lWFrY0BF2nM8xpesOYW8SaJTcvl1Fw=;
  b=jRk51JFyGPansqyvkoFsxF4CWGd0XF23DyU0dmR+yERh5HIA/Ph06Twz
   QACbyU0136WzQRMx3BJfH83HOMMyiaMeDJWn8iAFIKwEVqho2ABkapnUb
   MHc2FoYp3t1ZXHmq9dxcxgQVI5CiK/vhfQ9jxLWlfGOXeKd+J+HrhU3cf
   qCEJpQa82MPQT37SwF05EI/IJ1MPI2sYW2YhH1bFuCHX4WWLFsibRVTtT
   7+LqDbxrYzqQhaxT1e1yqC6UC0q8kpP9yHkYTaule4HutiO+iQp68+XEe
   NQy+Oxio0RB9zMATgIdwc8tuQukm+BUdZ65zZx5xdURoOW/s3lyl+9P3t
   A==;
X-CSE-ConnectionGUID: FxuW7Sb8RhSVZW6BGZ6WOw==
X-CSE-MsgGUID: qzWWBtYjR1eXkFVksYX/ng==
X-IronPort-AV: E=McAfee;i="6600,9927,11089"; a="13885508"
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="13885508"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 16:42:13 -0700
X-CSE-ConnectionGUID: n8AvXPKDQdSqtlzZvc7snw==
X-CSE-MsgGUID: tKUNbiM+SoGP/MGJhmvM1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="36393088"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 May 2024 16:42:12 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 31 May 2024 16:42:12 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 31 May 2024 16:42:12 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 31 May 2024 16:42:12 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 31 May 2024 16:42:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SAWd1vpKhnNknbrvIXz3eagbE62p29psnqKeC2XfM5S8F4WHWTRud/Iy6wJ6u0Rdoo23nOuvMgC6BbO17AmpftObdI/U+y6mZJmpOSMsjZxIduDfC1oeNxZpx1lWXatpYf/Gcnkj12NW1tqRsMurE6T2h44qFc+9XIYYGPhRpLa24TQJuw6yuDHaIk9bjpDoly38uDEwoZOPFCs5W74BrujfLNzaWJ0AjvXd8kbwZzWANOSM0Pb/WbmOcYwac6vF7vlOKGkymepZJlgHni/B4YIUi+GEuegrZFVyjelZ1XLuOzMgUCPC9WnK+vb28M01PiLRX1j5yh1xK+k7U8ex1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qXQHjHgG3ea4vPcqimxdQbqvoJJV4ju6bkujdNloOQs=;
 b=J+l+n81tD/M/f2YwJsA+15av84fqhWZOADYjmYzWfrZFWvtly+IWJSfg47GtyOjniMy4WOzex9hFhuHblqW40t8AfEjHwiVD3ezMiiiU7JOMOjoJPIPnS1Q9n71q1vXWFJwRqtWV8ccYJX4An04OXIftuggeuo6Q6bPl1Kxm40lzyZIJsquvC7HUWwTXToetBLDYEjxKiQhMsZF+81G+N/qMck1qdvJpCn2MQXu93cyZlXipayFMtfCQOmHjQhx7EvRE9oFrEozXUCVcF1v4PQOS9NJa0PFtb600/GxTVVrvUUzur+SUlSzFRQDXzBYsBspFcDD24Lq5wO+qlKA0Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 BY1PR11MB7983.namprd11.prod.outlook.com (2603:10b6:a03:52b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7633.21; Fri, 31 May 2024 23:42:09 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7633.021; Fri, 31 May 2024
 23:42:09 +0000
Date: Sat, 1 Jun 2024 07:41:15 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: <kvm@vger.kernel.org>, <ajones@ventanamicro.com>, <kevin.tian@intel.com>,
	<jgg@nvidia.com>, <peterx@redhat.com>
Subject: Re: [PATCH v2 1/2] vfio: Create vfio_fs_type with inode per device
Message-ID: <ZlpgG4vA+2yScHE/@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240530045236.1005864-1-alex.williamson@redhat.com>
 <20240530045236.1005864-2-alex.williamson@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240530045236.1005864-2-alex.williamson@redhat.com>
X-ClientProxiedBy: SG2PR03CA0092.apcprd03.prod.outlook.com
 (2603:1096:4:7c::20) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|BY1PR11MB7983:EE_
X-MS-Office365-Filtering-Correlation-Id: ffa17b72-6364-435b-b7d8-08dc81cb49b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?MawsMV/HOZbwAO/+89irYpQnYyzVbQJSHf+qNrWcRf8MtXf+w8lutkgo6ezM?=
 =?us-ascii?Q?GH9JmIWPyUeNnyaHEWyyY7Azfelpl45rks9huW3MPiO6bz/DXENoWDBW4jES?=
 =?us-ascii?Q?TG7wqTiWKMdbpFZUiOQjice+WCtLceeQQzz2RI+w8Ae4ooZiLQ0D2ocTAS8H?=
 =?us-ascii?Q?0kWjZYU6Vxw+0XuuxBLidH96z8qOo3YpbrDnzA+p+5r26Ga6rn12QT1n1PVE?=
 =?us-ascii?Q?5+G9x+Olr6ANIhonrNUv6Winxsy7HSPf0mX+ZYGmYiXsdzziy4Yl8hIaI2fS?=
 =?us-ascii?Q?PzyJ8utLYbPUvN1Erajv2eBLM7HQCqhxxW+LRvZGKMJcmG03NVoszsnh4d83?=
 =?us-ascii?Q?ydRz3YPZTlSUhWjkOe3ZUJs0aEtlIlES+UsdOqOZ7FR5/gP24day/RbklPQQ?=
 =?us-ascii?Q?VUpkle6WWf+Kik1bZihjzN6IcMKxm7iq1tJXzzwySfVv37SN/0wC307lRLiD?=
 =?us-ascii?Q?iSKxxgAQVvqIJxaIar18YPSCExDjgCNbN1UxU1970Hec6OrDIfZq47vi54hA?=
 =?us-ascii?Q?wFHPU8y2uK88Y7xA9GaTJTkpI7J4Gqqnzo0nqz+aXcmYxf/RRRlOMvXSy2mG?=
 =?us-ascii?Q?dkWg8z+MkjLsRXsaSOc6TENX0iunad69SCQqpub8MlOqIEzemN7t5kWEEA92?=
 =?us-ascii?Q?OK0YHboceWzoAYBiwZ89Ug3nYc8zG5iYBnzinlpFY+0Iev7P27pImQVrLxpx?=
 =?us-ascii?Q?Zxor6TqPrsJOj29jhq4Uohg0xW70je6leOKLsHCPQtsY/Up7ZKjFOrDjmlEr?=
 =?us-ascii?Q?N5f8ZMXO3/o+BoduCzi+SwutuDba6Z1xSxaa4GQbK5BIyV0AVotYqxuRV44a?=
 =?us-ascii?Q?GNJU3jPco5Fvo2gcAtkm/e8HpS2toQzAcU790DnO6Fa/BxJMHGBPaRUklJVR?=
 =?us-ascii?Q?mvCcoAOT5JdwUVPrW9j8sftnsdQSZNTheEpcLn7pNuch10h0vV6GASv5ciZU?=
 =?us-ascii?Q?99Di8iWRqASEjcrJIUjd+fEzD0bsJAVIH6M8pmnxsfiu9VP3uGRAbkZZHLMe?=
 =?us-ascii?Q?QzqDSc6McQhzJnjt9a2mMjLCE/s0jLMQaIOGUsG0YJ4zo4QeozJLS12lFHe7?=
 =?us-ascii?Q?J++PoJ7AqS/M1tfzXYOUsagaC9q2nd0VSHJPAoDXzeoavPUXVOj2U5n7tHBa?=
 =?us-ascii?Q?bXGeHDWZ8LuLSDLlE5hO16Nh20NTaH1CZSsj19GNuMuR5wdazSZHya/mZ0rl?=
 =?us-ascii?Q?/3p+7g8EQcMiT+Dd7dmCd2YuQjDR3Y0Tde7JWMQImQlGLlubfbAaXuJKMbMm?=
 =?us-ascii?Q?XVHiVlCG2GKE0RXOJnxiNAwIcbWCAmThhtmCuxT+aw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HHQ59VCOPvl7mCWyYrdsJtWzFtEOHLpPknxxKZ7A822AimSMOeDGRwiTaeGB?=
 =?us-ascii?Q?3pcu8528ZMze20qFjew/B/uNQBvK/vYgazWhHcm6dQ4CW0DfiIusws4K6RiP?=
 =?us-ascii?Q?wy1lwe3QgSgbFDgzVz90lpIOzEt/ZXNXraHPUQKSgWkctsEwugm3QSPI29b+?=
 =?us-ascii?Q?iIdI4/jPMTaAPZu8yA2VUSrdphwKEj38amaB/z0Js85PYICyW52AZArMR25d?=
 =?us-ascii?Q?O7HHelCtBdrOYfe52t2+ZVouPWTtMFX62piJfEqmlCG2z7Yhv5QI2eU8JE5t?=
 =?us-ascii?Q?L2c46lGjxW7Tk9AJ2k3Bh8vjJi2m3lYFCn8YvC9im/mjNtOuAjzr/9MeSfsT?=
 =?us-ascii?Q?0x6Z4Xzw3O1WBPtsKaNrAZ/Ftk7qc014EkEVKRdkUz3s3QKwCswyxuZeZT8k?=
 =?us-ascii?Q?2KKkMMFJHdzI02qjjdJgf4CKV12D+uynB+I6KphDCPsBuD4GiDutLx2EJDCY?=
 =?us-ascii?Q?8n0jW/7+ldRbh4ML8DsJFf8H0uwuviqQHQxdVelAV9SbjdlL3I5uoZdCRRl3?=
 =?us-ascii?Q?JeMAOPxI+YSon67AILMLx3JGKiVvIZDDhTp1TIDpNJ7XT2hCccBMX1ATMUG+?=
 =?us-ascii?Q?TwrM2YxAgE3gDAvQ6HubaJahInUBx5WfwoOyb9Klvo2fJFbpWcngM7D5Ahvo?=
 =?us-ascii?Q?Ybdl1DfY71jT3qQxfuAUq+Q8zbH3U/yLdGaLUqiURsLIFosjrswwRPaeVc+w?=
 =?us-ascii?Q?jFs6Jyhl9kBGjfOLvMx8n4EK2uciq7Q3A/+ke62TPPY0cDV9qOe55wgLJOx/?=
 =?us-ascii?Q?gwbFVCqixp1GGKyKn8+ZdAeD3fQoGsVF9wmOsaI+SLn0dNekOVPIEVKElufl?=
 =?us-ascii?Q?2A3ZT5fq6BGl7FZy3x6rX6c5SrWESCO/3vOZ9eNM7gciOpi11Ve39vD4vO9c?=
 =?us-ascii?Q?mPlpWRYb03FtorfgLwLkAi2HkCBujHAy3cIPa1JXLGcCYq3qeYNzj55FMfT4?=
 =?us-ascii?Q?QIYRNn4upGBW5gOub+RnSsjZNtnmMhzcmZuIZk2cl/HNN6d7GBM7pmrQp7l5?=
 =?us-ascii?Q?ykKTXEJs53CZ3nWotvtrNzul9+xVL9akQTCrkTWmbQZDqY9wIwpVY230/Qqt?=
 =?us-ascii?Q?X12dNUWAJKDJ/AHR6aXc1EQl98y9fjn7GZP74yLojZxRDWdGJ4Ga3bimRm9I?=
 =?us-ascii?Q?FMX4Nz1kwxGpAPcqHTN9TC93z8DvY7C1mybJO/KcHikizBNoEN47Irrahivu?=
 =?us-ascii?Q?n9tt3BNpt2JHolgbR137GO2ot0vd/9KFDsUVuEfHt9xGwuMuBPmXpHZk++q4?=
 =?us-ascii?Q?5tRQCAv3ZEJiVqyT21+8oGnoczsESsk4VpBXqCRJHAD/Q/r59RgtmwCJIkX6?=
 =?us-ascii?Q?fZj5ksVqCtbHeqAVCbHookEy1oY11a2uZqB4MciXtfH6Mzybw6XW7YLYrwh0?=
 =?us-ascii?Q?krNsuaRs2FukiYNbZmiHKoteceAibtzsFL0AGp6STAGUoM8HKxYKWtipR1GI?=
 =?us-ascii?Q?R1aWzdfaSiYbuOb85kXV9AaluZ7S3KhG5IifryDotRElSkuQZ0a4WShXfWlX?=
 =?us-ascii?Q?/1ldyXjo3roBMc/U0FEmuhtOI4uOHNHifXRhSGQHung2VzSUfpz7diNz5INt?=
 =?us-ascii?Q?q0OpfnQYZcgjCOTFhAzN2A+j76QraVRBjPOSwrNX?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ffa17b72-6364-435b-b7d8-08dc81cb49b0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 23:42:09.5709
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PeyOl4fIaNZM3juKK8YDZIfZ01Pi2ujUW3Pzi23A+KtZ2XadqYAcW4XcjWXr21p+ibTMmZmpwhKbQ+xPbomMig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB7983
X-OriginatorOrg: intel.com

On Wed, May 29, 2024 at 10:52:30PM -0600, Alex Williamson wrote:
...
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index 610a429c6191..ded364588d29 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -286,6 +286,13 @@ static struct file *vfio_device_open_file(struct vfio_device *device)
>  	 */
>  	filep->f_mode |= (FMODE_PREAD | FMODE_PWRITE);
>  
Instead of using anon_inode_getfile(), is it possible to get the filep like
filep = alloc_file_pseudo_noaccount(device->inode, get_vfs_mount(),"[vfio-device]", O_RDWR, &vfio_device_fops);

> +	/*
> +	 * Use the pseudo fs inode on the device to link all mmaps
> +	 * to the same address space, allowing us to unmap all vmas
> +	 * associated to this device using unmap_mapping_range().
> +	 */
> +	filep->f_mapping = device->inode->i_mapping;
Then this is not necessary here. 

Thanks
Yan
>  	if (device->group->type == VFIO_NO_IOMMU)
>  		dev_warn(device->dev, "vfio-noiommu device opened by user "
>  			 "(%s:%d)\n", current->comm, task_pid_nr(current));


