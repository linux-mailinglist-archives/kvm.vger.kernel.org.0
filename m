Return-Path: <kvm+bounces-69546-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qEwQMpVoe2lEEgIAu9opvQ
	(envelope-from <kvm+bounces-69546-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 15:03:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id ECB44B0A9A
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 15:02:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9D9F23026AAB
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 14:02:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF7303793DD;
	Thu, 29 Jan 2026 14:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RyKmACfm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477F81A23B9;
	Thu, 29 Jan 2026 14:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769695363; cv=fail; b=MPrpnLZ0hiryb+DftfbJH6rHomM+kcs5nXXPZIf+80FvnCnYphRUI87/4k1QpdwGAr//my/pczoJ2eJDDfV4qYLo7V7qnLLKNb5/VLXB9I06DW+ALNlTN8MXo47w9IeNcx4zD9v1BtYarlXXcWC1firCycu/PWl3pT5Mv1yFfzU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769695363; c=relaxed/simple;
	bh=v3v1iV6lR3C8IJqzMarbEMIdgjZNuRHjAA1zprtrlKA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gAUPAdQK7i2ChzyvcO0qGzBrb2Fgg45a9wVNgWjkMMKVkBmLEcCz2oOv0WYU+RcPIA5Z7Nfsj9m7H2ezzHW+uzz2+TvrvkzUtkGfiyd42SDBzut38RZwdeOJI7ixE+FJ77SLUStUaUVZSG9XjEMfkpQpoeM3mIhoVy73j/elHCY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RyKmACfm; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769695361; x=1801231361;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=v3v1iV6lR3C8IJqzMarbEMIdgjZNuRHjAA1zprtrlKA=;
  b=RyKmACfmw3STgtmQU6XecOek0v7/0MzXseQd2sEPGn+NbPrzsEOfwJPr
   Q5LzBAHPs+20ve7n4hzqQelkankWqnZYfTXhUxO+W29tHv/hNlXXB2D3A
   v3FHZWTu1Hlo9llrX89PxW6d3L+mZ32UlZ+CXjv7bHn4/gaYNCnitFVvH
   OVztZ0hgUwZ9AMEuv85FJ+GdukaRR7GkkDvl0dRBhuY1w4FK+pVJkqCxv
   maNgIgU07+iiOwsGBQp3kaP9x2dSOtx+7s415x04zylI8n3Sjz48k24aO
   qNpGDCBQMe/uM53jMrXkaoAKC/wenrLjj7PzA/Fy3uNKhSo42NV0ELfJD
   w==;
X-CSE-ConnectionGUID: dwyYSnnvR6y9ch5IqDPBSQ==
X-CSE-MsgGUID: h5D32WLSQkCzDOnvATAL4g==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="73528752"
X-IronPort-AV: E=Sophos;i="6.21,261,1763452800"; 
   d="scan'208";a="73528752"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 06:02:40 -0800
X-CSE-ConnectionGUID: znlJ8LRqTbeXoTULfv/NSQ==
X-CSE-MsgGUID: hycZ8KEBQQCDB5Sbxf6ZvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,261,1763452800"; 
   d="scan'208";a="208491488"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 06:02:40 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 29 Jan 2026 06:02:39 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 29 Jan 2026 06:02:39 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.3) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 29 Jan 2026 06:02:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FxKWOgUpreOCQ+0J+LNznrxleCyJM1Wi95uhZDXeaLF0saMCN1zAwhBPTzUbCaGyLlnuGnbe/dze290q8Uaf7DJyyT5af6ZrnTOLbuI2a0IdneGP6AqPq7gkgwk1z3DehN4PfbiAYdDBl6o+LUCHrhrPkBupiqDoAP/RdgBr82UHFF5UhJ4ROT6Cn/8g0lL06Zy+ILvHmB8TtvE6L0MQtJgbPxoLhSuRcYdSf18ObNpo+gZ8auaO2A708vHWKEwm95a9CI+z2fVGw45/bis8rm4jdX45qorl8AUDf8zQV/gKWXRKZnOwNp64eOUV3qjtKGQOfZFzf9pQic9njVDE3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sdCNAloF5e184g7QkANP2JUsthTmY9EoVvOEjKO+NWw=;
 b=U8Mb/kFvfpyALkpTmuOGRr/kHJCyHiBR1pWwJinIrBw4P2ZeLCSgmIw93K//8abUHAcmhXTlyFAe8jrf0nu2s2uvgpkc+14n0F6kQ905kaWgT8EUSVJE0ZsKN2+a+3FChb0yYNje0p7xNWB5Eu+0yIFqagHV6qetYr3J8vOS41UFhFtLthDhzo6ZWf+wE4veJcPVSIybVaB1XWNycRive9Yt/MW13Ftg/XnYv9A2S3SvgVdDH7KM0xyDDupEcb1aaO6OlO6QU3DuvziXV1E1wxz8g2EZ3XuxbTyASVzdlLGw/oozjGhbbjDFrj4KZG0x2BJnUwy5H0uHCyJN3/7gPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH7PR11MB6649.namprd11.prod.outlook.com (2603:10b6:510:1a7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Thu, 29 Jan
 2026 14:02:27 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9564.006; Thu, 29 Jan 2026
 14:02:26 +0000
Date: Thu, 29 Jan 2026 22:02:13 +0800
From: Chao Gao <chao.gao@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: Binbin Wu <binbin.wu@linux.intel.com>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<reinette.chatre@intel.com>, <ira.weiny@intel.com>, <kai.huang@intel.com>,
	<dan.j.williams@intel.com>, <yilun.xu@linux.intel.com>, <sagis@google.com>,
	<vannapurve@google.com>, <paulmck@kernel.org>, <nik.borisov@suse.com>,
	<zhenzhong.duan@intel.com>, <seanjc@google.com>,
	<rick.p.edgecombe@intel.com>, <kas@kernel.org>,
	<dave.hansen@linux.intel.com>, <vishal.l.verma@intel.com>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3 03/26] x86/virt/tdx: Move low level SEAMCALL helpers
 out of <asm/tdx.h>
Message-ID: <aXtoZTRlCMSAIeda@intel.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-4-chao.gao@intel.com>
 <f8329aaf-7074-4bcc-b05b-b50a639cc970@linux.intel.com>
 <aXoEQP0jyXgR6ohs@intel.com>
 <1bd9bdcb-6dca-4496-945c-526abee46059@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1bd9bdcb-6dca-4496-945c-526abee46059@intel.com>
X-ClientProxiedBy: TY4PR01CA0119.jpnprd01.prod.outlook.com
 (2603:1096:405:379::10) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH7PR11MB6649:EE_
X-MS-Office365-Filtering-Correlation-Id: 05560e89-2840-4cb9-d456-08de5f3f0899
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?NEgmrvH1Yx5TU152ZUW6ZA1QicA2Z8ijFIwAccG/W/iTzCaUtpPSKR7Tcko4?=
 =?us-ascii?Q?BlTZKidWvLsQ0sZyLV2UjjLFXr0OVqh/1ffUCj2UEhjWTScsOvvwJVMjiM5L?=
 =?us-ascii?Q?1xzIpZx3p0w4ntShTSwE37gnQUK5/+1sw1lTsCKCHmPTtbdkU4XysYQrhGF1?=
 =?us-ascii?Q?MrLVfRm265tVoF83PlUDks77YXGyYDB5P/KpICIeUUrMYfeP0SJB5loRxCVN?=
 =?us-ascii?Q?WkdsqX2FWu77PPN4jwJRkTBvR6JJKJlMH8GSLjRvwDyOks5AbCisFBfpqJep?=
 =?us-ascii?Q?eOCX06BrLQVE7TViscXWISWcl+Y+nmFWW2dqaAvT2rxil03xUD3k0BxyvMae?=
 =?us-ascii?Q?8fcAuuZCwXgUuIoiGLri/Hn+qESlDMfNIKTKEtrmWfqMCr1nyKhu8TIeM/VG?=
 =?us-ascii?Q?yzyUDqwKfFIDWMP/ETcydMfJZB/jREULt5f8FuKTU1EzYKEzhRqHKvivVrBh?=
 =?us-ascii?Q?hNZ6Ekr7UoVMELeIh1Wtfs0E4zL9+f7wW/oCDXrDcRDh/PR7N8XR44KTocTV?=
 =?us-ascii?Q?z/P8NN6mwp/5U+9yBcPGHoE90dxEdX4/2FFTt1nN8dqzp56OroOHNfXfGPsO?=
 =?us-ascii?Q?xlA4EKqACizHKJAPaPfkCL7/gyBef0aFTCKKcZkty5dX5JBUejjcY8MxIW3g?=
 =?us-ascii?Q?XBPd0a2gnIKNCiRGoymJbYc46FTGGFz71TswfN7YYpeC3GMPQVP6bFlmBHZ3?=
 =?us-ascii?Q?kU/59T4JqrL5Qpbutj7Vn4t64E29Wwuvy7Q6eVs2y8mMdjpEacYKKW2JwD4B?=
 =?us-ascii?Q?Pkv32on2qy7MLB15/vA3Ki2+Xliynz/okzGqcmQ8UEDC3ao+RuNR4SWhzIVF?=
 =?us-ascii?Q?bZNdO8nvi6W9EiluIbLXXvh0ckI3UUXt0EFdL3oJmTEODp+kPIvKuvD8cPiv?=
 =?us-ascii?Q?CPH3KGyxsP+ixFnnRUCfCISXx2U7GZl51Hx6IGStDfE0D8YAP7bWuEfR0ogf?=
 =?us-ascii?Q?sxpqz1zixrt7u/+zTWuD/XsLbYLsiM5XRNCElFbz47l1+jsEjpDNBoifIFEA?=
 =?us-ascii?Q?hpcJqbSs1ph99SnQHHE9V7+kQpfAq8y9TbE+thVGeSKwmCZvkAwSLitIP1By?=
 =?us-ascii?Q?MXFXK2WAbIrCo18chf+DztznZ1vzhQJlOQ1kV4ug6BUIKa14wY4wSsgY1N5t?=
 =?us-ascii?Q?2gJEjDx3SU99OVIquKBH8DXRs1qZQLR/R2JKTj8BLHDtlzOOVkTg7huVGof6?=
 =?us-ascii?Q?ATq2Q8PTWg7z8rqATgJVxB/7y9NPU5gqbcwCJB8RRRVn8ALnk9TRzFjkzVrW?=
 =?us-ascii?Q?NhQ7UskRXZdz/zmj1jDAjMpdaNe8T76SrMhf6t/sqll2BcN8G6LCIIBU+mj7?=
 =?us-ascii?Q?ClRVTU9X8lX/P16NZLZyCIPsZX9Vigko2dAkGUjusJf+JT0PCUchBG57VbHt?=
 =?us-ascii?Q?zAhuFUt83THhisBbZl8mi6xtj2tbsMQX202KtZmX6073g3yuMmtQfbNzKGP0?=
 =?us-ascii?Q?cJocaFTkkn012AAiB6hNW9t5tzzfoCphKY113r4rFCjavZW/0KsYclRwIdeI?=
 =?us-ascii?Q?0AIqfppliUPTngQHg7ZCDeoNu4wVUKCQBfiXay+dDTcgN9DSRIA2+FL7Ruvp?=
 =?us-ascii?Q?UPr9M55At9GMa6r/Bss=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z3r0XSxRpP8mWVHbykThpl+LG4KnUClXsJ2BC27HOmcUdBRWzwbCXrJjZpNR?=
 =?us-ascii?Q?n+vvFrZdnHMlURDP+7gzqbPdu1BqL1Kb/jq6ymu+Yj7kGrG4vHUqtLzXdNL6?=
 =?us-ascii?Q?dxkByVmNcv766JCTnbHRmkzczsXvUx/kL59dPHon/8UvM5wT7AImt9JZxoZ7?=
 =?us-ascii?Q?XCm6bJoYufDOGU9LjzS/yYUb6iX4vtJgEZQiyRYaPOqQJ5jnwqazR3mdL90h?=
 =?us-ascii?Q?+rGcGn1qKrZSc7Qs6dRdv8jvc4ZSigz5Ssuj4VtHjo9zIxvUStjQr45YfjNb?=
 =?us-ascii?Q?70o02L5bxuGZTjhpO9vf18LfarnV9xDRvgC52k3J85p6DmXscQO/za5Ddmk8?=
 =?us-ascii?Q?NnzVeDPqHQTGBiHC/CxYlPZXSJaZF1hmxfB4v8ybsq696AGwFaWhOaNnKEtR?=
 =?us-ascii?Q?sfIcaQbERtjBz1tfIP9KZ4MgHLeZcsPl9U3JJUAXGpq5wqcp36XktKAFenwA?=
 =?us-ascii?Q?i/4PSnCcpWAgcc2Mx5lcAG5H2+e1r+TsPUI3zeNxSbbEuSwuZ0HP2TVTAQdl?=
 =?us-ascii?Q?z/mJU3KYLXksLxMD74AHTUWrxYrCUf3H0/HpJuE4ROmqJayeNtVMOdD5XKgK?=
 =?us-ascii?Q?IfdOXmA5XFhMnpjBdNo852ceVq7BXeMs1q9D/hE/5QraFcBXPRdosyTPBx2b?=
 =?us-ascii?Q?RHvZZOugkP2kEmSuz7NZefpQCz0qLCybsJO7j6aDc0J29S4dBqdIm2G0//tr?=
 =?us-ascii?Q?AQkJbhPJMk9AQnJF3+8HARs4K2v86LjqPwf5+WgfqixA1rfY9lVJq4nRZTYb?=
 =?us-ascii?Q?AovfsuJT3eKbpD76jqgUv7c9c570hQApkQZn3QfwRb5q0gYklK3woKp1xjnP?=
 =?us-ascii?Q?u9YeSkm/eKSxxIIDl1OqWoSyzL3NDLMKmg3iJyfM2dPR7UaQmy0TkDrz3kMJ?=
 =?us-ascii?Q?BkxNauKWwnHVAUEArUjbaKBq3KndRNIbREMfuV5OXn6yKdxICMxyKsXyTtHb?=
 =?us-ascii?Q?uGkUyl9G0d7SoskRY6WWkHtSRrOvYtPNkAY9xwOesmvnI5sNAueThHvsxv3p?=
 =?us-ascii?Q?16MTzRW3DWW+SDnSb/BuXqwedOr2ISW69pacWA4get+vrYdhtsQftxj76BMG?=
 =?us-ascii?Q?zu30RDsb9CbvQEcDUCB4BsC9GVUzWblwmlEJI+AujqCRLI71GbefPEZKH3Xv?=
 =?us-ascii?Q?j93HV6Bx9YbRWUwwlCx+CbGDLn2U7ydhU+lnxnUkWJRzT9Ix0qOeJF4YdovP?=
 =?us-ascii?Q?TQwhi5xoIMQVXmAKR67p01ILpCIvH2JjStUx0AqWM4eS9aTbyznmRtRuifmI?=
 =?us-ascii?Q?eU1G9794zs74jmMwebDR+0KBzXZ3xz7KB+mwM+VotmmQSCEInUZsO4XFCoUa?=
 =?us-ascii?Q?eROwHsNytIB1xnmwK+jPypawsal3Q3+RZ28P7ec2VRfsWtQbdRzPGjBuNujA?=
 =?us-ascii?Q?mhxTOZAzPxJTeTXUavoQpT11slM5lKS3t/BRg26deK9z0OsbO75ifD55ywG2?=
 =?us-ascii?Q?UvDwkKLvsXstehoLyAZKEdSeEJltznK1tLHlmvXBOWW7qCVbOJhzi7NsAi4b?=
 =?us-ascii?Q?G00h41CR6LIMHt60wIcC2oaNEAgJrY3/lbdKt6IBsHc+aBm64+liynmK6mNr?=
 =?us-ascii?Q?pLkr92FEE0Iva5ni3h/FHVZssdAi8DX8iCwTms7jufo4jZdDhkT01DqqeVHK?=
 =?us-ascii?Q?kSWsY7KxePEfcTP7by1BmmR6Jc/eNWeioqJLj9VoCm9WQT6cdqjjVLmEtN+u?=
 =?us-ascii?Q?HUaxpQ5UDixtCUk8E43/89xuoBiXTzCo/K2FM6vr9aU9MKDgtFBBh3rvOSBq?=
 =?us-ascii?Q?5GAqc/i1mA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 05560e89-2840-4cb9-d456-08de5f3f0899
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 14:02:26.6910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gebN1kNd2zsf76bEOcr8Y2pWei7p0p1y1fxVDA1/2Sx0DW3+cnZH/HANxFvQHXJNO7gFkl3uGwB5Qt6rUNTgvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6649
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69546-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: ECB44B0A9A
X-Rspamd-Action: no action

On Wed, Jan 28, 2026 at 08:31:26AM -0800, Dave Hansen wrote:
>On 1/28/26 04:42, Chao Gao wrote:
>>>> diff --git a/arch/x86/virt/vmx/tdx/seamcall.h b/arch/x86/virt/vmx/tdx/seamcall.h
>>>> new file mode 100644
>>>> index 000000000000..0912e03fabfe
>>>> --- /dev/null
>>>> +++ b/arch/x86/virt/vmx/tdx/seamcall.h
>>>> @@ -0,0 +1,99 @@
>>>> +/* SPDX-License-Identifier: GPL-2.0 */
>>>> +/* Copyright (C) 2025 Intel Corporation */
>>> Should this be updated to 2026?
>> Yes. And I may drop the copyright notice if it is not necessary.
>
>No.

Sorry.  I am a bit confused..

>
>The copyright is to document the timing of a creative action. Moving
>code is not a creative action.

This sounds like we don't need to add copyright notices for moving code.

>
>If you want to remove it, do it in another patch. If you move code, just
>_move_ _the_ _code_. You can _maybe_ clean up whitespace if you want to
>along the way. But that's it. Don't muck with it unless you have a
>reason. A *good* reason.

But this sounds like the copyright notice should be kept.

Do you mean the copyright notices from the original files should be carried
over to the new file?

This patch extracts code from arch/x86/include/asm/tdx.h and
arch/x86/virt/vmx/tdx/tdx.c. They have:

	Copyright (C) 2021-2022 Intel Corporation
	Copyright(c) 2023 Intel Corporation.

So for the new file, the copyright notice should be

	Copyright (C) 2021-2023 Intel Corporation
?

