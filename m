Return-Path: <kvm+bounces-24074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 89913951102
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 02:27:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 26CD91F236D5
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 00:27:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3AFF4A01;
	Wed, 14 Aug 2024 00:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G0LjohBC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5F31859;
	Wed, 14 Aug 2024 00:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723595228; cv=fail; b=lc36jHXRN6RTNWltCzvpkENDhOi50MxiZhmbZh+3NHVqSedQOCPBWKeSYYHmTVo9NagOVf48+ydKlFBtYkc2DDLYtVyle82j+MZjxyhmbEdrOqS6G2+cst1l+MxIbhOGOnAimuYud47bEKImO4ylLzMs1XL5nT0O2vyKO9IHxg0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723595228; c=relaxed/simple;
	bh=TfiDu6ErRAUE/wgYeFesvFnuKxVWkxJbp5iQk/PoLCg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YnrnBQqYekJArQwZWklxs845L6Cy9Z7Bmoee4bUYpV8AqopSplQvxrS+kOciUcUD5ra5wp8uZDvPIrVLV4psLO18CLiakBPzhQwO1gTSbdvAunc0d/SN0ClAVbvxok/TXLc9q7mnutvcQjsHzMroIkDOUiKxFARju1IVAPwiyu4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G0LjohBC; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723595226; x=1755131226;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=TfiDu6ErRAUE/wgYeFesvFnuKxVWkxJbp5iQk/PoLCg=;
  b=G0LjohBCGGnETBsjlmQJvucNXDa9tYZ2lMmtC0V8cr4/JgsMv9AxAfoa
   UdGyUqjS6rdJsawdk55nrmCrnwBCQXb2nbtwteR6+ClQz7f7E8e43EFND
   8BmgH+WwOqs5OZQNUqgEwCMKdHpVzNI3urfwr++RDuyH3c8XSsdNDpxGr
   7sw2ChQR02yTb85kyE/YRwMKoTXPIarcKP1aNDflqwrRlz+hjK0JAk1s7
   gZAWIz0FGZh8TJY71aNkfz+xvJILjUG8LWi2Tl2jBGCySNJdlUNxPYeWI
   SjgZkgeFJ+FlN4zQRcO0zYhRlCQ9LjT1YUX0diWfyqYELT4DbkOq0P6Cp
   g==;
X-CSE-ConnectionGUID: To9KFsp3QMGMKKfeU44n3A==
X-CSE-MsgGUID: 86rSVkYlSUqnKBoHxkyjVQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="21946819"
X-IronPort-AV: E=Sophos;i="6.09,287,1716274800"; 
   d="scan'208";a="21946819"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 17:27:06 -0700
X-CSE-ConnectionGUID: FhtOFQyxScO0N6uFeqjQxw==
X-CSE-MsgGUID: kRUSiuNrQYiOA7o8RUST9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,287,1716274800"; 
   d="scan'208";a="89521352"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Aug 2024 17:27:05 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 13 Aug 2024 17:27:04 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 13 Aug 2024 17:27:04 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.49) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 13 Aug 2024 17:27:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cZKYedFDb0hQwU4M/sf8Xvv53m+UUv/tC5cbcVpfTEYQZz8kRMjJAtprozRwloRkrz71JlEFglupV02QZV/UyApBJYQVcVcdJ3nDykcCz549fW51gxZhwcOKDDC/cyGot9TTTh7EpuHRqZ5O7P60LY5eFSu6LaWebffa+6ZgAw7m1O1nsMm09SRmYeWBnqL7HLRg5cwU5q1Q91RTq9lf1yH8EUFFPil3pe+mG32GWNBxdzaNeyiCpbii/KSVxs9gLei2dEOqu2Vx+8Tff43Vvo6+UFy+rPukm//mVQNIIYuohOPkAcndQNOkVRKsufrSFjm8H6R2ND0H0w/sOpNmxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hd59twGKk7fQl5jwAzWM34HAkbZvl4y+4yAZL+EAUCU=;
 b=oeiJUtk0EeuLtuqDmTWx0Ng1yqPlaARlu23y++RtMBWiNEKW6uV/XA2O+v7ky0hDfJezHGlsrkSTgCwEoh0WOOaIzmBlFhoKWc2x4QqT3cFzyiFKOj0Hgm7pBEJBpTgdVTusarW4SKFwTvZ3NvFLX/sBe8FqG5z0lUr2x4ey2FfRaOso5CxIpAoBySRyXLtNLi8LaMe3V4Y+M57urB+RS7CSzmOT6j+MgCIPc5YvTZGlTB+9AQNR6CXUzLN/uZUFXQRupNb1wk44rvnZqYu3cvHpP7wkGqApPFLSA39/lGscTSm/yMYVngU2FoxESk6G3rV/+7zUOYpR2fw+lvYRvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB8665.namprd11.prod.outlook.com (2603:10b6:8:1b8::6) by
 DS7PR11MB7885.namprd11.prod.outlook.com (2603:10b6:8:d8::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7828.32; Wed, 14 Aug 2024 00:27:01 +0000
Received: from DS0PR11MB8665.namprd11.prod.outlook.com
 ([fe80::8e7e:4f8:f7e4:3955]) by DS0PR11MB8665.namprd11.prod.outlook.com
 ([fe80::8e7e:4f8:f7e4:3955%6]) with mapi id 15.20.7828.023; Wed, 14 Aug 2024
 00:27:01 +0000
Date: Wed, 14 Aug 2024 08:26:51 +0800
From: Chao Gao <chao.gao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: Rick Edgecombe <rick.p.edgecombe@intel.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <kai.huang@intel.com>,
	<isaku.yamahata@gmail.com>, <tony.lindgren@linux.intel.com>,
	<xiaoyao.li@intel.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/25] KVM: TDX: Initialize KVM supported capabilities
 when module setup
Message-ID: <Zrv5y0zk+prwBxz9@chao-email>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-11-rick.p.edgecombe@intel.com>
 <ZrrSMaAxyqMBcp8a@chao-email>
 <7ddf7841-7872-4e7b-9194-25c529bd0ae1@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7ddf7841-7872-4e7b-9194-25c529bd0ae1@linux.intel.com>
X-ClientProxiedBy: SG3P274CA0008.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::20)
 To DS0PR11MB8665.namprd11.prod.outlook.com (2603:10b6:8:1b8::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB8665:EE_|DS7PR11MB7885:EE_
X-MS-Office365-Filtering-Correlation-Id: 1682fda3-d607-4c04-1833-08dcbbf7d0a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?xWZpIlETG5yLenRqSrD5ACuYbIb347jwx83XjaWvMGA0lgmXy++l+ZWp+oLi?=
 =?us-ascii?Q?EDdL+PE77o8ynkqdKP0PbpDTXh1GaKVVGG0r4H+EyztAJbviGfO+Sk+UvMPU?=
 =?us-ascii?Q?SRjU3oWDQE/2qW2H2/GMSHQtDagqhcfa3XjFkDrqlkSsd2u+8pg3CP/epBaA?=
 =?us-ascii?Q?FMjguEln1NfUhkTJTRDGwBqxkbA66lb1BEukvqvhYka08i56NnkcdIXoC/eL?=
 =?us-ascii?Q?mq9B9UNcmhEefyNe8uEgSkdJPvQ/kxATsr5kKY8ugIC0UxfANzRYARo/HEbh?=
 =?us-ascii?Q?v/K9GANcSfDbVEskqT+WFKezrMr+MZraBht7rlmRFv66jjKZpSGzaKf/5bMP?=
 =?us-ascii?Q?aH4EctDd7XLLXQCaQEJnoll7f1rFucwqBrfKMgFwgoIC20aAeZSHmvkjBZjG?=
 =?us-ascii?Q?3eF7zqr2VkPb4uqiaLNffRsotA+FwmuvaN7CDH8OxJTNesT8HEVBO6RRDypi?=
 =?us-ascii?Q?5IrMYRAh/fMULcwwqVGiAnj5dA749MgajkFyQWDcjpOq6VXjuxXCIKLMgNr3?=
 =?us-ascii?Q?ejkkTaWMNqBbhD16EgG35RBdVchmBja93Ju2dU/1HtmIFh0NmGW5iroG4hoE?=
 =?us-ascii?Q?o3u+iW8myEGZ/LN9ONwfV0eq6ZwAVl/JeJ2WNvGJb4EorrBLZ93MZybL6ovJ?=
 =?us-ascii?Q?H1cnPb/9lJrG5tap7mwzAvIsMimxD7pTyqWKLperjwHXkXUgR+NuWX22BvlK?=
 =?us-ascii?Q?5BPHCt2HBceC6XPp7u1sw/erTS/vmx9xeArzdGe/Km8nMe67kn9SUDlbAlD5?=
 =?us-ascii?Q?0VC8UAVRdkbAzL5FL/YJFkB0l9QwB+Tp7f8KycbSFRdLuXUS89+jTtj/q1me?=
 =?us-ascii?Q?NT6yee1u1g89gF8ZMtNPU2gf/F2FqbXXrvYfsFfSMEMd1PwUeqrxg/v5YTZA?=
 =?us-ascii?Q?iTqaMrAXpJiNmvkIa/UJjFsdps1eTgHTuTDXKShtcy5QMXkzoSw+8nJWiAc/?=
 =?us-ascii?Q?EcK778l/fHrP1AoxD1M+92XK0fy2MkJxecAwXYyH3rzdWLvhzEbSZ5xAkah2?=
 =?us-ascii?Q?O09h7gHa4Yv72L39QERk911rtr6OxvNZHNjuJ6DV03JGTzwYBVlHP2xQUPne?=
 =?us-ascii?Q?Ac5HcWtBcEqsMmVZobqrHLLZ2uKZ31ZA8JQcdCGLMqU67W65EdsUfcEixnV0?=
 =?us-ascii?Q?fwL2CK5beYbLiUfU9IgMeB6BT/tP9r1iAMK77j6hEZuUzWXLYPGrhzkAH4H2?=
 =?us-ascii?Q?zFw3lCQqZPVbO+dgQnf1sUDx2jNxN1zgT9q5FbWZLNNHGhWJeWmti9HEL1WW?=
 =?us-ascii?Q?pYnY4VqegAdB7giJhcY18Stp9QEqXxG5wYWdVTIfMRLCgXtBoNm/w417qnsZ?=
 =?us-ascii?Q?UDwI/VV/KYnhP6SkxhSm28Rp/0eaCdbmaSjRxy9BQvbNQQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB8665.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HO0HIemjm6jwdzpJbf4iWnmObGhpKVqLOznmcl2OZ745Ln6uqmxQ7nexsDF+?=
 =?us-ascii?Q?o2heqBaLH2WJWgt9mflecsEt+fCqMUfCPa/bmhIXZV7AqVorn+SBrSsZsXQm?=
 =?us-ascii?Q?e/WN7l4HLoOis3iAW6LJA9sW5TPvKWUIv1On0ylR4mrSTdNT40jO0TcqKpDd?=
 =?us-ascii?Q?Op6csBfKOCFKev0+sXTFYXVzVAGRCcZt8RF1bSPUB03FChFrKnDGQX9RMvpw?=
 =?us-ascii?Q?ZYCKIZ6N0IjgYw0BbIa4g+EIJ5zqpmXiQWjvJY5gPdwN9hAAppKvJOjIPiBw?=
 =?us-ascii?Q?YZuEloqP7nj+AFyyOR7lci5Y1n5FuYPhIywjXVktnYzBREhaRObQ0m/aJdmc?=
 =?us-ascii?Q?lQzrQP0rULeSONLmo8sUsFZXv3V7AQkjf1zByX0nGK0n0OVOWuGv9ls0/AN4?=
 =?us-ascii?Q?r34vbe1fMaCg3Q57DrWfIkV7N+aVj+ylTRNWavSzTwBUcKyMSEZgEc1o74Du?=
 =?us-ascii?Q?rsWzAWTxNfV7RDpodmPmNHALFFK5+C0P8Ihlzodm9v5KOwsYJtK8d7OM76s6?=
 =?us-ascii?Q?HDt/ZaGdZSS9T2UCN4ckxTPsf7CHLblwqhA5+L2qfoA13IhpEJ+xrBUJdhX0?=
 =?us-ascii?Q?snicVaDgytFJs82Sw9qB0NiqSjIflm6HJonbK2J1sc0nUmgCTEffPz5NPQrz?=
 =?us-ascii?Q?trGFscZqcbzwdMkpu4XLuXXdhmJiHyN29TLlrJJmj3YwQ4zFU/dwdAvNLp8d?=
 =?us-ascii?Q?jktS9rdpMOX3tehm+32YhpikmphpNDjaLI19AGmnRGS4Nyazuk/jG5joCJ0S?=
 =?us-ascii?Q?Z+JYAmsN9w/8HbTwI5wQkg0iIX/5CR5Nv15Den+4i224TxTSTdTVPi3ckq6l?=
 =?us-ascii?Q?er6jUhUYK+n4qona//fb/0Kiq/hwgDB3weGM03dCXqpbSUMRLIFmBVOHMw0Z?=
 =?us-ascii?Q?U2bsWg3MgRJnoAcu2axoJaKTwJYM7stxe9JvKYKRNzOcSeNWN53mWeGOWyqf?=
 =?us-ascii?Q?LxF68B5xU986EBnZSYPnlryB9SAzozkVp4hW5lpGiq6XrdtIhMynlz+fZB6j?=
 =?us-ascii?Q?NCpBVX7DVV/VLvhm8PCMdJRwnmmqg3lE/wLAlGpBNPEPjjBHA1rxVMjskTq+?=
 =?us-ascii?Q?I8qDNFrA3XPXiCOA/T4YBLUeALzOIR5Bl8PbYluc5dEaxf00D2uTzXN0lvEy?=
 =?us-ascii?Q?qZi1TJUSUbKavLr+Gf9YMhLzawZ9egI2SKZdmbiBFrXTL6HJDMCIvikcWV4R?=
 =?us-ascii?Q?MmDmXtE2rqRJ6QhA8Nrz04pysAz6myZ5tncbeUScaGJayWbyoFpk7gWSODYF?=
 =?us-ascii?Q?6AL0rhBqNZuDlJ0Ii5OcpaJKPzeil5X5k0I94flwPhed4bvZkjlVqGWePq3D?=
 =?us-ascii?Q?CPOPyTpXjfAjDDaFSvafmClc/JfiH1fme8DdYRytmIX9NbUBcnNWSeXM/TPW?=
 =?us-ascii?Q?QR8eij3hRnyDtyN1aQTNTRrKxE+mLJKjsWSrJmbcUlo9rWtYTHwgi1oCNVe1?=
 =?us-ascii?Q?dN3TFbbIv1omIztuAey6z4YGi7CnKDtFDlz1J9wi+ctYWmveAr+tdJYFqTgx?=
 =?us-ascii?Q?cNEoYX0Txb1jJp8pk8BzTFFCEXIHxgopte5smFea2R3DWEuH+baixzwVBbHZ?=
 =?us-ascii?Q?UlqxovI2v7x/u7Wp1iCgCLLg82BbA4v15cVlBHbg?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1682fda3-d607-4c04-1833-08dcbbf7d0a3
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB8665.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 00:27:01.3135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 78OjMADVhbe6EujAxbg4vX1ls/NymDdgP1P1JuJ+dbx0qvSzuv4hoc8qVs9w/EZcaVPLcpioKuRhJamUAE1FYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7885
X-OriginatorOrg: intel.com

On Tue, Aug 13, 2024 at 03:24:32PM +0800, Binbin Wu wrote:
>
>
>
>On 8/13/2024 11:25 AM, Chao Gao wrote:
>> On Mon, Aug 12, 2024 at 03:48:05PM -0700, Rick Edgecombe wrote:
>> > From: Xiaoyao Li <xiaoyao.li@intel.com>
>> > 
>> > While TDX module reports a set of capabilities/features that it
>> > supports, what KVM currently supports might be a subset of them.
>> > E.g., DEBUG and PERFMON are supported by TDX module but currently not
>> > supported by KVM.
>> > 
>> > Introduce a new struct kvm_tdx_caps to store KVM's capabilities of TDX.
>> > supported_attrs and suppported_xfam are validated against fixed0/1
>> > values enumerated by TDX module. Configurable CPUID bits derive from TDX
>> > module plus applying KVM's capabilities (KVM_GET_SUPPORTED_CPUID),
>> > i.e., mask off the bits that are configurable in the view of TDX module
>> > but not supported by KVM yet.
>> > 
>> > KVM_TDX_CPUID_NO_SUBLEAF is the concept from TDX module, switch it to 0
>> > and use KVM_CPUID_FLAG_SIGNIFCANT_INDEX, which are the concept of KVM.
>> If we convert KVM_TDX_CPUID_NO_SUBLEAF to 0 when reporting capabilities to
>> QEMU, QEMU cannot distinguish a CPUID subleaf 0 from a CPUID w/o subleaf.
>> Does it matter to QEMU?
>
>According to "and use KVM_CPUID_FLAG_SIGNIFCANT_INDEX, which are the
>concept of KVM". IIUC, KVM's ABI uses KVM_CPUID_FLAG_SIGNIFCANT_INDEX
>in flags of struct kvm_cpuid_entry2 to distinguish whether the index
>is significant.

If KVM doesn't indicate which CPU leaf doesn't support subleafs when reporting
TDX capabilities, how can QEMU know whether it should set the
KVM_CPUID_FLAG_SIGNIFICANT_INDEX flag for a given CPUID leaf?  Or is the
expectation that QEMU can discover that on its own?

