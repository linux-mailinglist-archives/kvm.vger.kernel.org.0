Return-Path: <kvm+bounces-28377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B224997FF0
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 10:34:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B2C661F20B67
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 08:34:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6C59204F9D;
	Thu, 10 Oct 2024 08:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P1nDytXy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BFCA1CF29D;
	Thu, 10 Oct 2024 08:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728547307; cv=fail; b=iRCbBp9pqCnmpObrwYHTJ/ewEhabuHlvUevWye9C1GQmXOSa/xNz2Bj8d9ZAM23Yw6r+VzfEWNz1I531noAa6Q7bSpKBsvpSRXDln6Hy5Hsvy9z9yDOPr1Vsp7um82cgwi2vDKj5ALwKNA5qVWlubO9lYDqGetadO3DHjlFce3E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728547307; c=relaxed/simple;
	bh=65BzKjzbJOG7S3DlqUEiFo88TDxwmThrMPNW7z74mBk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=EqDoHvICZKdlB4Ja9l7Rw5tmdxch4s4x5/XaOmujPHHqTZut9Xjk1Li3YOIgUOdd6t/OHw/w2/AMQaaaBOj05Xqi9xaSzUie2tlbISs0gQqqLqmjno1nmObUT+XyZdeufsppXYzS+YTRwQFDrtJn9tPgasTqs0u/0Z4ncqfJ9G8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P1nDytXy; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728547306; x=1760083306;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=65BzKjzbJOG7S3DlqUEiFo88TDxwmThrMPNW7z74mBk=;
  b=P1nDytXyo+pWJAnlRlMmLWOs2d5XIe5lJoT/JWRVWXeZGgN3w+7uJt/n
   lVSAe/1g0cSzzZVVjQuXkAYL/BLGK+UEzgscVSQgK4ZRluNH7BdMhA032
   pzTm+T/l71r4HYViWCpoyTFjGlPAKdH0Io8ZcveYClUsP/4F9f0MJNoq5
   Vqb5CXhcQwKv1sQZzKAmU3C7ILMDuUvP0k0EhrqGuPdvQAFvPMZHdTnYe
   EsaJ37jtfqTPUzbTqnccMeDeiToAALia5TkZqiHVN5ZetlM6wBh13yZFS
   edOvgFkyYGu+BwDR7qiI5dyra5XCI3jaJE4sRoggNylD6DVVRbi4cGp9/
   g==;
X-CSE-ConnectionGUID: H7wQC2s4Sf+7/EPUHz79UA==
X-CSE-MsgGUID: 2uBiWnIkSoWpzncRXthu7Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11220"; a="28019821"
X-IronPort-AV: E=Sophos;i="6.11,192,1725346800"; 
   d="scan'208";a="28019821"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2024 01:01:46 -0700
X-CSE-ConnectionGUID: 9rDZsOwXQHiafJXX+RyDLQ==
X-CSE-MsgGUID: Y6iCqDi9Q2ylz+sE/+UM4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,192,1725346800"; 
   d="scan'208";a="77344115"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Oct 2024 01:01:45 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 10 Oct 2024 01:01:45 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 10 Oct 2024 01:01:44 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 10 Oct 2024 01:01:44 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 10 Oct 2024 01:01:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hPoNRRHY5W/Qz4B3mSDeoDJjP7kOil1y6rVcLcR+hAGb5+Vp17rcQeMWXqxA0DFsYyNG1bNCElsIRLj6iBE5fqZxU/H1Aw71371DJEYPrKHFfIlTltoulZqerMaXKfg+/D0jSJspcaZIih5goSU4SxT8m5ae13KttYh6NVI76uxrU+r5vO57jpNSYynfd4r+1JVE8yTJN2F6yPv9rkG/4RJZ0eBjmFZOhhWRrU49H0jjXQJBvwBE8OHgD/yxRAQzJsV8zNnGuJCbnQ9u31uXeTi6ZdqEKX1H/si5qsCP+Msv5OxptI3sc2CG+G77Dcn+zhbc5G5Hnk8UeH7903T5qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EEIqnMsAuVFh3tQC/X9RyByspHAU3FPT86AtkTm51io=;
 b=GTSji/iV5GYoRq8RbcJnSy9AYrTkhE2+JP5EFTDB21pZIAa4oPjFsOJXBTa8Aim44IFAJWKIhf/dboysXOWVfoJsUrWCXxBw6nepVlXjcCli8Tblz+OlZKlzHsPIcqVL61pk9Nwbaq9yjd6g5UOlD5TyqEPxynS8OicYP0lnBe3arHJTG4ogRiSEQokTXeZNs0VHOw1T83mJ1Ip6/AGunglAv95pGiU55VNdx2KWpGS2gFMBSn54Wo4h7G2n1eeO4PQqAVFtEfp2fSFbdFj0Qvp7bZnhe+Z6vmG+TeFJU7bZ17hJujLsRCkCfOPNSr7S0/3IvvffqPmHuW7MsooPVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 BL1PR11MB5222.namprd11.prod.outlook.com (2603:10b6:208:313::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.24; Thu, 10 Oct
 2024 08:01:41 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8048.013; Thu, 10 Oct 2024
 08:01:41 +0000
Date: Thu, 10 Oct 2024 15:59:27 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] KVM: x86/mmu: Zap only SPs that shadow gPTEs when
 deleting memslot
Message-ID: <ZweJX6R3OsGpi2Ai@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20241009192345.1148353-1-seanjc@google.com>
 <20241009192345.1148353-2-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241009192345.1148353-2-seanjc@google.com>
X-ClientProxiedBy: SG2PR02CA0083.apcprd02.prod.outlook.com
 (2603:1096:4:90::23) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|BL1PR11MB5222:EE_
X-MS-Office365-Filtering-Correlation-Id: 766e7f03-f343-453b-39f5-08dce901c629
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?9rfyM7wGeFOhVARYBU5N1aDUpqKdFyoADOZmbnQygNbi1iAEasGgmMgnu0LU?=
 =?us-ascii?Q?m0lY05VHvJ4WRpxn/U+b68OP2+3xG+p5SYXIQtRM8WYq7dGJztyQTediVyzD?=
 =?us-ascii?Q?MEiNYq4LDT3Oy+hFKwvZUGEmOQ+i0QqBlJ5ThisHsluZArtOqhqgCCxfCJNR?=
 =?us-ascii?Q?br9lgUuco2NJyPwpcL8B2lKK1J3eh26WVvK1bLlmmU6hAwDuRdqMEu7y1P30?=
 =?us-ascii?Q?fyxrGmmQ8/ctHB5QUuW6mTOBGfYauQZ4mWU8tI/fAg5gg6wCT1za0SN0eI9o?=
 =?us-ascii?Q?XlqEtfqwfY3c0uGTlOi1fRUk4NqBKSoGx+bK29Yha5tbZt5rP+xsAAlkJxm/?=
 =?us-ascii?Q?6/I4TcM5q4F/GWfap7QCxnlYRfL1sv5XRMwGvJ4KGLZCiTJL2BembnDTllfF?=
 =?us-ascii?Q?gvRHb/Ke0foO5UhJJXey7UzxMppl7uLDBTiY4+KlJt9adG7+mLlufdvFAoR6?=
 =?us-ascii?Q?ialEs2sR9xE9Ca3vrHkre7Xp51iVpaG8PhwVstRhQjem6rlvOl9X6xXO244B?=
 =?us-ascii?Q?AO+X4/Y+/lMzxoBa8tbyo3FjCnu77gEqf5sAas9pErCJd0yPQjZeBAfo7YR+?=
 =?us-ascii?Q?8CbDDEpOunc6N0/sd8L6+dICC570GB4c4gwCV8AWyU0NVD4AguNHWhZwFmcU?=
 =?us-ascii?Q?ePq19wmEWWEw0mJo9X8tZ2pMKypbrVc1tgWpkNWE5XVJEaiJ2pqrxbaeuaNJ?=
 =?us-ascii?Q?A5Qn+oKzffV9zkvxTv0ZcDivKrtyvSJmeojzvDfLup8291AnXohZuvKqPb5x?=
 =?us-ascii?Q?hEEOvNRvd0GUThtotniO/ZM4KUlSsRXT7gdev0pC0QegzxVgDo5UypbgDUj0?=
 =?us-ascii?Q?P4BssSTrjnpN7D4z31tMMibqe7CnLyGtappK/HR30a7gQI9MdBRa1kCATlEB?=
 =?us-ascii?Q?7dEANOu3tbNKK4Rq5BAz8ojm+YNhsd62kxPXTikt2kPydFHqDm4c8/60RpZJ?=
 =?us-ascii?Q?9fRbAoBbjKrAxKrcInSfEug0e3+8ji22XIlodEGp+Z8uGSmz7RP30RRZoyIC?=
 =?us-ascii?Q?DFqFN49Hc7tfI61vXdkARusp88OrfntMDxwuHKYweMx0IPggM66dS2whB5aY?=
 =?us-ascii?Q?NbNuoWNvGZjeoQYRkNU0ZGYNVvprf1zuGKA7Di4z/VNjvUngo2WXU/WTVZSV?=
 =?us-ascii?Q?H7MJKF6MpkZKZOT718DVnhJmb/pm7b1I+Sz0X0oji0lwcRvatzEFayY8ENvy?=
 =?us-ascii?Q?bvjlC5D8IOsZkBs1v3ItKlxUxE2DEMg37Pot2zeXVJG15RuzHu3bkjv86p0Q?=
 =?us-ascii?Q?EB70iHGuq2x0NXm1Z9S6XBYz/jlYeJVmYgPYMNufWg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BywTFAbEzIj/7rGEM2I43tPTzVTaDH2ODSJkPavnx96aDAEZr39z+ggXqNR5?=
 =?us-ascii?Q?eTefN+cdIajFrUUjbwPLh2lv0/d9FQ0Yc5PMM8QacUfc2RE2yZGgavnB4/zY?=
 =?us-ascii?Q?gi1d9P/ZzYS/vLf7LNbaCv0/nzn9A3eQchJvo/yzoDjbD2lHtV7ykV2r13zx?=
 =?us-ascii?Q?FKsid2IOPNWKdbXa4JQIGrJLHt2gAaXoSH9y0XpI9pFDwQhPS1BvR+YTgHHb?=
 =?us-ascii?Q?YVsNRNboSQljlUU7ZXpOoVm7PCP2wjxVeGDLxQ+Ofh3NCh40kek7O7+YrSYX?=
 =?us-ascii?Q?yGqXH6PocUiZEtiAuJWIP3vcupht4EaB8LQTuykTANFLKqOhtk+VilH8csJD?=
 =?us-ascii?Q?6OvrnW8FosXeqCpIdScbJ3nISHguDrV4M+5On5q0ixTbZ0DZCUZT6De6ei1a?=
 =?us-ascii?Q?+G9Y+rOUQNtkVuNaF8SC9sZ/yPP77vzPwlBWFBHxgC5dofykJVc4v82HRgXp?=
 =?us-ascii?Q?pHvZRzbFoJO17uQ9hBdaTOphS6XNe6sYixj0ev0QlpWJC2gM0cXKZncZlIuZ?=
 =?us-ascii?Q?hDbHNLD5z6Nb0ruRthpozMafvV8Pmq67yc5iC0GPReHYXXIK/HllkLZaDiwF?=
 =?us-ascii?Q?VtmZCB9OuBYRmF365S7sbzjNgE5ILAG+xyJ1/EdW+kxEqNlcvqf1aXYfPG09?=
 =?us-ascii?Q?o1bxhGhg4HbEjKGy7PM5aA9iDb5fsXooF6kVsp1SiT9XQtpRYk1Zq3tCoweT?=
 =?us-ascii?Q?AI12SQnSC9k1/xIZiFF14H7uZTzDqctUkbRCziYHeWUfoe/4NOGj2JqPWg0f?=
 =?us-ascii?Q?gfrXtkJmTsy1dWK9HlbhaMmGLZ055qRIq6mk50Cb4EdlIXXw7lOCxocmcRXx?=
 =?us-ascii?Q?d/ryCzO/6v2EuMuQgppUheMMru42F72GYR9IadfpQMaorL2uMl/OMBJzGdCn?=
 =?us-ascii?Q?ehpJE1iwv8V28ijnkOUlAXt2ZoaQX9aR6lhCAi7QxWzxd+pq76Nha0C6CB9w?=
 =?us-ascii?Q?qFi5ps36Y1gQsmQeGDqM0X1uk5ns0AvZ6ww/BedmNzioEKEexgTp+nQq8ilB?=
 =?us-ascii?Q?umhU36ySlVmSBfzmRSferLfs+ZvsnrgHH+PENzGpDcd7am+x4nvvJB0/ON0u?=
 =?us-ascii?Q?aJ3NJoueYkPfZ/Xv6juo+ojsT6Kn2df59U597XBOMEkyLIuF50GfMv7ftwe0?=
 =?us-ascii?Q?GsB4+z5GgTed637Tf667ozC9IzJlPqeZ+JVzjKSD5VHJv45qpRs/JZe5nWeJ?=
 =?us-ascii?Q?TgVByXy3C1G57hgVOP/ZnF/R666/om0kcJnWxM6JBwZYmOrT0L4yYQulHZnL?=
 =?us-ascii?Q?E/39SV8F2uo8Fb24OnwZO3ssdNMRswBiEEXOiLzstv8aHXrT6kUTBmonAzN3?=
 =?us-ascii?Q?YVSNCWZqu/Jh44P7b9NuUZjjicAP+BJRvVXwtQ9A0uo5PTTScCn8s8ObPptW?=
 =?us-ascii?Q?e50e1VY7gNivoQyvukwlR2+50wy98QtUWhq0RUruIw88z6+DwYLAEcjcBf0O?=
 =?us-ascii?Q?RyYxI56vG62zsNYvwEly0FX1WfFf6uT4+HtRuDVGYRlqEQjxuyBt+/bcUo4C?=
 =?us-ascii?Q?O7yDbnNxmx+FgywM8+2p2ljYfI8vNokmRgr+LG+myqM5qslVwBGco/yB8RKr?=
 =?us-ascii?Q?XAb7yRyBEmHsIclSwh8cu4hT2on7I4/TT/08wvXH?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 766e7f03-f343-453b-39f5-08dce901c629
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2024 08:01:40.9893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iS6OCPDD67UQwveikqFLI6viTUUL3C3t/fDwRrjmdSPs5jJcz1tbyNQfoDyPffLjx8Q1KWv0NVUJahBs0ECP6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5222
X-OriginatorOrg: intel.com

Tests of "normal VM + nested VM + 3 selftests" passed on the 3 configs
1) modprobe kvm_intel ept=0,
2) modprobe kvm tdp_mmu=0
   modprobe kvm_intel ept=1
3) modprobe kvm tdp_mmu=1
   modprobe kvm_intel ept=1

Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>
Tested-by: Yan Zhao <yan.y.zhao@intel.com>

On Wed, Oct 09, 2024 at 12:23:43PM -0700, Sean Christopherson wrote:
> When performing a targeted zap on memslot removal, zap only MMU pages that
> shadow guest PTEs, as zapping all SPs that "match" the gfn is inexact and
> unnecessary.  Furthermore, for_each_gfn_valid_sp() arguably shouldn't
> exist, because it doesn't do what most people would it expect it to do.
> The "round gfn for level" adjustment that is done for direct SPs (no gPTE)
> means that the exact gfn comparison will not get a match, even when a SP
> does "cover" a gfn, or was even created specifically for a gfn.
> 
> For memslot deletion specifically, KVM's behavior will vary significantly
> based on the size and alignment of a memslot, and in weird ways.  E.g. for
> a 4KiB memslot, KVM will zap more SPs if the slot is 1GiB aligned than if
> it's only 4KiB aligned.  And as described below, zapping SPs in the
> aligned case overzaps for direct MMUs, as odds are good the upper-level
> SPs are serving other memslots.
> 
> To iterate over all potentially-relevant gfns, KVM would need to make a
> pass over the hash table for each level, with the gfn used for lookup
> rounded for said level.  And then check that the SP is of the correct
> level, too, e.g. to avoid over-zapping.
> 
> But even then, KVM would massively overzap, as processing every level is
> all but guaranteed to zap SPs that serve other memslots, especially if the
> memslot being removed is relatively small.  KVM could mitigate that issue
> by processing only levels that can be possible guest huge pages, i.e. are
> less likely to be re-used for other memslot, but while somewhat logical,
> that's quite arbitrary and would be a bit of a mess to implement.
> 
> So, zap only SPs with gPTEs, as the resulting behavior is easy to describe,
> is predictable, and is explicitly minimal, i.e. KVM only zaps SPs that
> absolutely must be zapped.
> 
> Cc: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a9a23e058555..09494d01c38e 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1884,14 +1884,10 @@ static bool sp_has_gptes(struct kvm_mmu_page *sp)
>  		if (is_obsolete_sp((_kvm), (_sp))) {			\
>  		} else
>  
> -#define for_each_gfn_valid_sp(_kvm, _sp, _gfn)				\
> +#define for_each_gfn_valid_sp_with_gptes(_kvm, _sp, _gfn)		\
>  	for_each_valid_sp(_kvm, _sp,					\
>  	  &(_kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(_gfn)])	\
> -		if ((_sp)->gfn != (_gfn)) {} else
> -
> -#define for_each_gfn_valid_sp_with_gptes(_kvm, _sp, _gfn)		\
> -	for_each_gfn_valid_sp(_kvm, _sp, _gfn)				\
> -		if (!sp_has_gptes(_sp)) {} else
> +		if ((_sp)->gfn != (_gfn) || !sp_has_gptes(_sp)) {} else
>  
>  static bool kvm_sync_page_check(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
>  {
> @@ -7063,15 +7059,15 @@ static void kvm_mmu_zap_memslot_pages_and_flush(struct kvm *kvm,
>  
>  	/*
>  	 * Since accounting information is stored in struct kvm_arch_memory_slot,
> -	 * shadow pages deletion (e.g. unaccount_shadowed()) requires that all
> -	 * gfns with a shadow page have a corresponding memslot.  Do so before
> -	 * the memslot goes away.
> +	 * all MMU pages that are shadowing guest PTEs must be zapped before the
> +	 * memslot is deleted, as freeing such pages after the memslot is freed
> +	 * will result in use-after-free, e.g. in unaccount_shadowed().
>  	 */
>  	for (i = 0; i < slot->npages; i++) {
>  		struct kvm_mmu_page *sp;
>  		gfn_t gfn = slot->base_gfn + i;
>  
> -		for_each_gfn_valid_sp(kvm, sp, gfn)
> +		for_each_gfn_valid_sp_with_gptes(kvm, sp, gfn)
>  			kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
>  
>  		if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
> -- 
> 2.47.0.rc1.288.g06298d1525-goog
> 

