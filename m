Return-Path: <kvm+bounces-22122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D6DA93A331
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 16:49:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8446A1F22DA6
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 14:49:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31C7A156F30;
	Tue, 23 Jul 2024 14:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KI/3RYBJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB8115698B;
	Tue, 23 Jul 2024 14:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721746164; cv=fail; b=tpk+h6sKN0FMGQtetFTQimNNDcbinR8tGPjeW0CnHm+DVao3WRbDK0duXbECRtvCa+nusfao3exRAJhUZqYzjbzALys6cTse1oHM6gmrYuBuYqH9tM5cQyvk6BklUXCZjvk98fe5C3zYA83FT48lnQhMxFETey+abZlukTUVLKo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721746164; c=relaxed/simple;
	bh=FhSAXfP1X8ZmdTKcLosdwX3KmKPpGECN51Wab7j/Dek=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=t/3Wrbs1nPDwgMv+9Zw2Gi1ZzhPFS7A0dw7EEyD9jSgtepR6ays1cis9my56IPNne04JFNF7ykXuh7ugSQS+fvDkcOUjg5tdu2kkjFHM2QmVpijaakDRivwA2Qa/+tbEdKJyoWxYTTQf412V4YPGl215EGUxn24g/xAyEAjcKdw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KI/3RYBJ; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721746163; x=1753282163;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=FhSAXfP1X8ZmdTKcLosdwX3KmKPpGECN51Wab7j/Dek=;
  b=KI/3RYBJ1IhM2LJhD1ACQOREqIodkIzTMCSyH/1Mi9ptmdkJ4pNp0O+1
   w+x3SKHBsNBCbWsE6vEw5WDp6Tdzo4JajcFm4JUyiEfU2h+OuOU2CVq6Y
   peiprpYfjqKripsyaSp5bZ4G2EcOf/m+K21RP0vdIqE9pIwjKH+uTiRu5
   Vu+Dz0h9EaL4OWYhUAxu6sAdtHN+xMG2DRqhyd2ReXjTr/G6+m0ek4jZI
   sJ3EaOwIj69bq2vf/9wi6IKyy5LC7mk9vu21WeEvEFyITIPkW0yvHNiJ5
   oYZuPNFbFFNWcMPDkpehj7ccdRsWT40VA6pri3frv5AAg19T/4BC3ewOo
   Q==;
X-CSE-ConnectionGUID: J89nomWBRV6ez7nVou6ncg==
X-CSE-MsgGUID: P6U7CqRiQCGtk6dl3y8T4Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11142"; a="44798495"
X-IronPort-AV: E=Sophos;i="6.09,230,1716274800"; 
   d="scan'208";a="44798495"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2024 07:49:22 -0700
X-CSE-ConnectionGUID: BrlvP5/QQWG1+dDlsHbr1g==
X-CSE-MsgGUID: PRR/X7T3Qq+QAJ5y/M2WZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,230,1716274800"; 
   d="scan'208";a="51938451"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Jul 2024 07:49:21 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 23 Jul 2024 07:49:21 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 23 Jul 2024 07:49:21 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 23 Jul 2024 07:49:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XSEX/D0EtRUfyxeW7xqdDdU8ZPhCdhRGQbJkRwvuzXeYnk/gK6sYbd4XK05VTKMOSd4TI0lag47CjBolhfujO9I4x/DU5c4DFZFJW+HA5g5NhTNwLlKoexCUH7du41qkr51BE2a8JRoyDpy6BezVKo5TOoJXgSHXG/7vwVbRntVfkg5X8OQf1gb37HXxYBVDagpl/H6BniK3enuXmHdB22rlscbmO/wu7K6SnTlBVKQ+k7GG8ehbTgmju53N2mpCp7FFKxpvw75irZVszdQtY7WZUvdkNvH+cP5PPFmgRyJFDWFtzZqRfLsVfDF4JW6+vAqcJ/RPuS9pNzVMh3LkBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J2V8RVhb0kmNt0rZhGEeFdxGpyfLkI7AJu/v17cdH9A=;
 b=vbIFiYPEQjSIIS4L0SGNKYFMEuxN60Q/yFhm1pGFLN2G83jlpYbMMqr4qhy6LUuint8oyClelXHhb7w+sNdGV+dYA7JffWO6HJo4r8IjcQANsH/rzbD7Pb404sXpp8nQuMqga2tgQxB6mtjPucis92ftlLKi7pK8radi5BKmLfUch7yUidwUlRPyGpj4Q//I8L5BG+iOPlS6STf0yH7IQ4nSF3hpvreD+iU5aHb5VlxUcd1WI/BWPo84z/6XNHHFJHPBNn9D/pglCpJHAwLyYsZN2v4HpPtCUk/y6F8j1SH2PxA/oq3Rp85tT4ytx9uJdhOB5my0LgxCD2EPl+sOUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CY8PR11MB7011.namprd11.prod.outlook.com (2603:10b6:930:55::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.15; Tue, 23 Jul
 2024 14:49:18 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%6]) with mapi id 15.20.7784.016; Tue, 23 Jul 2024
 14:49:18 +0000
Date: Tue, 23 Jul 2024 22:49:08 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Zeng Guang <guang.zeng@intel.com>
Subject: Re: [PATCH 6/6] KVM: nVMX: Detect nested posted interrupt NV at
 nested VM-Exit injection
Message-ID: <Zp/C5IlwfzC5DCsl@chao-email>
References: <20240720000138.3027780-1-seanjc@google.com>
 <20240720000138.3027780-7-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240720000138.3027780-7-seanjc@google.com>
X-ClientProxiedBy: SG3P274CA0007.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::19)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CY8PR11MB7011:EE_
X-MS-Office365-Filtering-Correlation-Id: e7c20dda-ddc9-4eca-93b7-08dcab26a148
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?g6QM7IGlnrvrxGV0FMSiVMrywkotnGsStcX4ev6wtSSaSOUN3sid8e6Jm6Wg?=
 =?us-ascii?Q?yCe/BfjblnP4Y9YCzAGLC9AVlf3bazUDM3HMpEWtY7s7SB5BH4dmjnqqycbe?=
 =?us-ascii?Q?afU9lwcgZ6Mvq6y43o941ndy4LRH1+F1rRAebg4zXo5jD6SaOAtDzcYvUD0w?=
 =?us-ascii?Q?tKxpfgrCNTk/IdSKvKxuGj1oAeG5JCzIc/JKjrhumfEE50JvonSNlNUht6kE?=
 =?us-ascii?Q?R537/pJCtkcDFz0c0pUWGH/cqW7NPmFgC678rzXNHtaEtABwVGVucY6BVv8T?=
 =?us-ascii?Q?UYUOEFuCmkeonsEMz/bQJ1wXmVg1d261KfQHNc5XAa9p+XIsWQX4yU/ZCoDZ?=
 =?us-ascii?Q?/ymrMdVSEEAnjAsQ+wxXAnFYd7PBhZ4YNfnal0nRQhixb8gKl8a1UsrcVliF?=
 =?us-ascii?Q?qeL/rg7JiHUEyy3Pb3eu9kpL6psDD+7XijO5W/XzwHbUwo7SNrF2Iw2NE9BC?=
 =?us-ascii?Q?p7ckKfHPif12yYKPxwzCZ/Xapj6usM5ZvsTGSGqcm4FSXS3/Z2QKIn75qdip?=
 =?us-ascii?Q?Uw1rqTFlMpmCrkAVi5TjWRNLuJzme95G+fECLStkxE4gn0XrC2jpg0D5JqJz?=
 =?us-ascii?Q?fSB/0uD5zVi6/1hGF4rUwrGPHVbvyFXxwz+3DaL4ZrgkpZMLkpX7X6LTX0R4?=
 =?us-ascii?Q?ruOQHPrMNZf4gJvf1QQ/3/rE16BIAX1Whyisx0Oomc4P0uFoxGFsBlxsQaL1?=
 =?us-ascii?Q?HWih+1c1Df+9BAmwhMxLbpDb06RaONZCE7s/u0KLxduEpIO9KWc9wlUk7KNl?=
 =?us-ascii?Q?EoWUG2ARRRtPVVAA9C8IZqSw5BvsAvFlWzMSQ5U6PuC7lGyT6IsYvmbbhDE1?=
 =?us-ascii?Q?//g5pMHFGpDbB9tman63jPlI9LV2bIzp93w4dKpNEVPu7fw9Qb4QyIjS7rlC?=
 =?us-ascii?Q?xmiaxcisL5vQ4EmF+se8lyXGF1+eA4Cro3HDGz/vISmBqWAqHl4P6ZqPAu2M?=
 =?us-ascii?Q?1ISNN6mZw2fl5ixSJmsF3AV+I7vSq5MnimAjKoK8xtLB4ZTzEUibXlA3d83f?=
 =?us-ascii?Q?rakBOBYGl7sEoTZkGPd18JxYf2MlwXpDJPR8FQrwhWfLLSu7xL2ecUBMbhhk?=
 =?us-ascii?Q?U+3DHlPO6h1elvKRHTUo3R+PfRfhweYEFBDA93Tg1IAhKVxnaWFtHNXsoCof?=
 =?us-ascii?Q?yWhAUB1LyCdBXBZD16WmP5Q3hwnfXGkytmmxf2hoddMsSfbTnVNTjqpVmedu?=
 =?us-ascii?Q?PSoocJYdOkbnrtmKsCF1GuKxDMX0l1TylL+KpQX9RFwRlBFzjaxRzTZbgGV4?=
 =?us-ascii?Q?Wzx0lJAvnYkzaPOfuyobL0bXUNd2lCDZA9vR14/Wnuf0dPDmzBxF293nZ/5H?=
 =?us-ascii?Q?TZlUiG5INRRQydWTCX++HpKceFLeJWrrQuyn+jaWbLbfuA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S8RINN2k974V88LniB0mU3G9aFKLYMc9N22Lb36sZwoB55Zf3mOpMOLvFHn1?=
 =?us-ascii?Q?sG7Q+t7i/mJLAHuo9IlgvxR7IYi0f0aIJ3Ge5AmDgC5ysyj/hAjy70/AwsGb?=
 =?us-ascii?Q?ahfg3iJJMy+NVm1R3Qnpd5syQKR4ji2cnclWU41IASMhIvntp5MrlTvyTlHO?=
 =?us-ascii?Q?KZSh66BTXG2pyQkaGsAZruSISzJeSBX/fQNGQYyM9YlKNyN+n+ovszaOE/2O?=
 =?us-ascii?Q?ozSPtz7YWbm1TFHvsCh66N0nqBA/zIOqKi6ezgtT14OeBzk3tSR7hHpcLFbb?=
 =?us-ascii?Q?apzFA51szy5vHkoE6ccPGNDWHAHtjPwqdzJMHk6bnvGSH3yLWLYTZIcNJ9gq?=
 =?us-ascii?Q?/Qe98j8PnThf4LM2FpZCB8z7nrJJkhyx9w26Epjiis/mWbkckZtUb3/rzbNW?=
 =?us-ascii?Q?TYWu4w+zccaFoZDTBUWIq0W04anZAvPc31YpRiboWlz+QR/WIx+0N7y5z5fm?=
 =?us-ascii?Q?SfX5QCa+TVIuuWDAKDi1QPSKUVbcxzRa6kHrLQdIG7/A3g1sXQ6eTAI4usyn?=
 =?us-ascii?Q?oNzVklrGIyyqCTg7y09WnaGA4Fi69u/g5LtEqddoR6jMJob8CjZVvIJodqKI?=
 =?us-ascii?Q?51RHTcG/QJCYibgTOMswwl+87ziVX1JfjqNZseblR44nQvdPKeafCoCTwIWE?=
 =?us-ascii?Q?SSpDqNHXJFmRm3Gr2sFXDroqI6+rit+tLUiHIgMOgOycmU7O71oZX36LaZzz?=
 =?us-ascii?Q?zioQq70m5+sMBSVLHYuSrnaSDrhV4yOyR5fMPJD+XsUNX/TZu5y2yxS5ZSbg?=
 =?us-ascii?Q?daoSO15V+Xo5eA2QX4+o4wpUnwX8vejHYbolIQ7CNk6Dq327e6i0g4fzIabl?=
 =?us-ascii?Q?0mh/ycS0r/EXWk9QDjYh2k60kicT4TdVFgZvMXCnVJ4Suref3AaCp2OBN2Hh?=
 =?us-ascii?Q?e8e7o6wa7apUupLGTtdz0qWGu0+2Xi2XxMT9C8yqU9sfyenB+zcBs+sguPsM?=
 =?us-ascii?Q?NUzIFr6ch9WpXX4X45r+MiTFGkVE1saaJZCkLmMxujnk7DF25prs1cz4FFI/?=
 =?us-ascii?Q?feENGP3P1AeM7+zyfRaEvBiznO6/Anb5aLcFy4gxF22ErHi2cTpKdrmZBDbW?=
 =?us-ascii?Q?OJ/obLbd5PwsQlQ4xC+erUkGKC2Ev+C0g3LzZBxAcdGOl/8NKb2LuJviiqe3?=
 =?us-ascii?Q?2d7SeRXYFkNUpCdRSNNJJSozO7NYZzzl/49eGqM0rUADjBO+PMVabSyJ/Lcp?=
 =?us-ascii?Q?d44k+OIC/T5LmkUTbJA5p4dNcVUYHBnh98fMdpHLKBUCQ9h4bGK7oMSmumtD?=
 =?us-ascii?Q?59M46Wx2s/0ATTbLFCobgAQ5o232UGI2JHG5iJPSRpTN8HRnpPBzXTQYDnvn?=
 =?us-ascii?Q?cv9Rv1Ij3nWp2tg+dKQc6Bb6ch+uHSRj2A2NcOeWqlXYdfzAVUwx7PdTUkVf?=
 =?us-ascii?Q?+XYafvnlstnx6ENPNPoVIQTOBFWzWlsqdfn8KyrLwCMGWSLqP5VK1dUUnry/?=
 =?us-ascii?Q?5uU2ZjxpA+Ho4c+VLDesPQh6NYZ/htnR1GGZrRd4WZZ3Uc/7LWHcEMwr/kZO?=
 =?us-ascii?Q?4K/fClz0biveu2jQineNbcXI3runPUplGGbmmgY1AvcYvvqp/z/WeD5yyXQT?=
 =?us-ascii?Q?sNGHHxdsHwuhf4Hr4GTvR0W+fajLe4F/MqriYhrL?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e7c20dda-ddc9-4eca-93b7-08dcab26a148
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2024 14:49:18.4901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6/s9VYlFMZrli8Ptp7GfXSQQ+fGhgs5yEh8BaHio4SjNw7dPaWC6YftQ1dbDN4AUz4qFa0LkX5HFbS56HWLnfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7011
X-OriginatorOrg: intel.com

On Fri, Jul 19, 2024 at 05:01:38PM -0700, Sean Christopherson wrote:
>When synthensizing a nested VM-Exit due to an external interrupt, pend a
>nested posted interrupt if the external interrupt vector matches L2's PI
>notification vector, i.e. if the interrupt is a PI notification for L2.
>This fixes a bug where KVM will incorrectly inject VM-Exit instead of
>processing nested posted interrupt when IPI virtualization is enabled.
>
>Per the SDM, detection of the notification vector doesn't occur until the
>interrupt is acknowledge and deliver to the CPU core.
>
>  If the external-interrupt exiting VM-execution control is 1, any unmasked
>  external interrupt causes a VM exit (see Section 26.2). If the "process
>  posted interrupts" VM-execution control is also 1, this behavior is
>  changed and the processor handles an external interrupt as follows:
>
>    1. The local APIC is acknowledged; this provides the processor core
>       with an interrupt vector, called here the physical vector.
>    2. If the physical vector equals the posted-interrupt notification
>       vector, the logical processor continues to the next step. Otherwise,
>       a VM exit occurs as it would normally due to an external interrupt;
>       the vector is saved in the VM-exit interruption-information field.
>
>For the most part, KVM has avoided problems because a PI NV for L2 that
>arrives will L2 is active will be processed by hardware, and KVM checks
>for a pending notification vector during nested VM-Enter.

With this series in place, I wonder if we can remove the check for a pending
notification vector during nested VM-Enter.

	/* Emulate processing of posted interrupts on VM-Enter. */
	if (nested_cpu_has_posted_intr(vmcs12) &&
	    kvm_apic_has_interrupt(vcpu) == vmx->nested.posted_intr_nv) {
		vmx->nested.pi_pending = true;
		kvm_make_request(KVM_REQ_EVENT, vcpu);
		kvm_apic_clear_irr(vcpu, vmx->nested.posted_intr_nv);
	}

I believe the check is arguably incorrect because:

1. nested_vmx_run() may set pi_pending and clear the IRR bit of the notification
vector, but this doesn't guarantee that vmx_complete_nested_posted_interrupt()
will be called later in vmx_check_nested_events(). This could lead to partial
posted interrupt processing, where the IRR bit is cleared but PIR isn't copied
into VIRR. This might confuse L1 since, from L1's perspective, posted interrupt
processing should be atomic. Per the SDM, the logical processor performs
posted-interrupt processing "in an uninterruptible manner".

2. The check doesn't respect event priority. For example, if a higher-priority
event (preemption timer exit or NMI-window exit) causes an immediate nested
VM-exit, the notification vector should remain pending after the nested VM-exit.

