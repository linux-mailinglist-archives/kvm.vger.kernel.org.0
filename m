Return-Path: <kvm+bounces-27335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 664349840B1
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 10:39:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B7591C2237C
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 08:39:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B38F1531D2;
	Tue, 24 Sep 2024 08:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gzfz6RMP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA023398E;
	Tue, 24 Sep 2024 08:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727167163; cv=fail; b=K3U/zurbDMmyuu3te/kp2lud5tgPpj+OPj4RxZnukKVuTZf+6LFgGdZLw8RD8LL09gjoOuZ59UyNfvdW4EG6t6C4Xu34Y7zwLxZBLxiUxXZAYCnQdSmpKxRZUJlS3hpLXJnLUIvlMv3Mfshv9ll80wtE5+Lg19Zx2Z/LhEk3kS8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727167163; c=relaxed/simple;
	bh=U3FnsJs0JbkmyvsDQyCkh0SZsqQk/i1867Xy0h50xtI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=d7lZT+zKaBhumWk9FzxBCYkmi1KjSymt9bdgL0ZJ++C5/WEQYqWdbS4SiU//zQOgp+oIALplKV68xBFcRWZmNBwkX1N5qMbqAF0L4/1LBvK30ub0KcUBfG+dfG7jRgrOALh2mAb+52xUSKeIBAcHBLyFoLj0m8Dbm8FVRjX8cCQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gzfz6RMP; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727167162; x=1758703162;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=U3FnsJs0JbkmyvsDQyCkh0SZsqQk/i1867Xy0h50xtI=;
  b=Gzfz6RMPEd3XdZyc+qEz+R0AfSh9XTczrzGGe313JNdw0FQcjo02G9TN
   uwts0x8Suw9id/qrFwzOBcbQvKxaCIgrfBusWOiiz3m7erGmTIw66eEx7
   R3O9TmqoXgtv3ZrBY7eR6dniejuAROhDFuzpiObwDju3Cy8lrifqPuMuR
   UGRW2f+4vyFYTpSO7l1R9i77wPGk5aAPMrhd6zzGIeZmxnDAadN7szRJc
   VOn/P0uO+HpEU7YJH2ATNECYG4cs0mPxlZLD+ZMfyxlaQuf8i4JhfvO9a
   +QpPgdc68rU/4fh9w7O0AO96s0BnIHA1BJSRlZ7NnidTDP+5rpSOeFW1Y
   w==;
X-CSE-ConnectionGUID: xljQwo86T7ubbNizlUJsAg==
X-CSE-MsgGUID: kWdzmi1/RsyezdFdBPqGVA==
X-IronPort-AV: E=McAfee;i="6700,10204,11204"; a="26099803"
X-IronPort-AV: E=Sophos;i="6.10,254,1719903600"; 
   d="scan'208";a="26099803"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2024 01:39:21 -0700
X-CSE-ConnectionGUID: bKR8MvCnSR25M3z/aqAkWA==
X-CSE-MsgGUID: 4yAVp+6fTVi6mqdm90nL+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,254,1719903600"; 
   d="scan'208";a="71486539"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Sep 2024 01:39:21 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 24 Sep 2024 01:39:20 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 24 Sep 2024 01:39:20 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 24 Sep 2024 01:39:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JNZlYGfN5iE84q14AyYQYHXZR2J2PYxJxD2uaGcR7WWfE+PfgJLFCBrH5ulYfeK7SHQOLZJTR9/ajBpKxNYHTWRGGZsrpD6AuT3EMyz/fC7VeNmxyj+by46t/r/iB0CDFek+uHincVJd8MVSVfhAJRTyRYFCpK/ZBKGiW6aLAoVVKsrg3fNTs7XZP8XATGf79a0bOm2XMujaKT0LGk5UM5ahhHVtfQOYegldzL7BKvh2knsNqyzDsRSgdEFUY45Kv1uHF37fMXan/qtof1CsofEyMQzOShQF5HMHRRa+If452oNXU0ZNTLH+i2myrZ1QNDi1sBBtF1vjJonnAjUPEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8olYlp9ZFU3mik9oxG4Z8nTnR/2/cN6gBFXFf/IAqmg=;
 b=yR77uMh4iz0L66kzcB1TSKXUOZXfRPeOwolC4caG0zIWsT2qeaqM0esbBijPaM9zXwI9SC8np4S1HOxEOByV/6+Mpijz8edNJsX6AYFIUrLJ8srBkkujvDwZxVRKAn96cqXS8dHcZFgYjDVSGmNPh+8ZpjKnCcIGkVlI9uFaOiW3Q4hITeIzTD7shqk/odSX8rNokWrhySIzwQ0qGgJIR2XuXxIYP+9FG90THS5WjGJHEaCBJr02p9bBvZCXdwtU2Z8wDji8NgPgmgVv6t8Ajv37UijvabJAFkchjgEmx4vIQBQILrsvue+kcU2cDGH6wrrNfixriDIfyCiCWNYJsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB7606.namprd11.prod.outlook.com (2603:10b6:510:271::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7982.27; Tue, 24 Sep 2024 08:39:16 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7982.022; Tue, 24 Sep 2024
 08:39:16 +0000
Date: Tue, 24 Sep 2024 16:37:11 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <rick.p.edgecombe@intel.com>,
	<kai.huang@intel.com>, <isaku.yamahata@intel.com>, <dmatlack@google.com>,
	<sagis@google.com>, <erdemaktas@google.com>, <graf@amazon.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] KVM: x86/mmu: Introduce a quirk to control
 memslot zap behavior
Message-ID: <ZvJ6N3oRBjlUf+l4@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240703020921.13855-1-yan.y.zhao@intel.com>
 <20240703021043.13881-1-yan.y.zhao@intel.com>
 <ZvG1Wki4GvIyVWqB@google.com>
 <ZvIOox8CncED/gSL@yzhao56-desk.sh.intel.com>
 <ZvJuMGmpYT60Qh6I@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZvJuMGmpYT60Qh6I@google.com>
X-ClientProxiedBy: SI1PR02CA0028.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::6) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB7606:EE_
X-MS-Office365-Filtering-Correlation-Id: 88f640c5-8868-4eec-a800-08dcdc745ffb
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Lozdb7+uFuVyzGseMeDWOIVFBLKKsnnhAYGN64ve5bnfDBGUjrqWRU2q3iO0?=
 =?us-ascii?Q?WPSWEGs6fb7VpWlcgN9Z/F0KthoUgwqwdizGTZ5MjLNWsJyEtEKS0mZf7zIf?=
 =?us-ascii?Q?MvQL2Zs8jXL58wFeicpudWmhaWXIxl2bXGhi3ErnOkOeHy0U3KoF/ay1wma9?=
 =?us-ascii?Q?ZnKTWj2tf1eajDb41ileICM/RkVtchU2EOBask7EDGH5CFoDYox85GUgnJTL?=
 =?us-ascii?Q?rCson0EvMZ59lzefpdGr0n6Y1iDGkV6w5IP+PXRRX315PvnhqoG3Ur15v4Oa?=
 =?us-ascii?Q?v/BrlgONIixg7kZh6X6a8XZnWTeLAsyvkFFSYuy0nNRgpwW+q9B1hgF+9wVS?=
 =?us-ascii?Q?KWfknL3bdh/9VSeNWacWFOU38tdUmxIhk17b6NXwR25FKwyGx/fL/Ys9Fdz+?=
 =?us-ascii?Q?nxIg6GFo40GPqpSh7lrBQx6E9H2sSUvItzQMj5O8qgHzfHoL60ynEaMI8IsM?=
 =?us-ascii?Q?M9Rz6G2IflEMu4h9MS4EGuUnKDu9o4iHedA1h6RqCgwDRKEqsdHh0mmCd9hQ?=
 =?us-ascii?Q?krmuUqNlnsuUIYLTfMl21zO5tu8ogLcz61jE20RDqJD1UGhZvLfAIbembuKt?=
 =?us-ascii?Q?Qi1jU1s2pbQl3fxsUKmD51a1sHZYFa4G4MhL4h4CuCB7DBFB2tAvhAV5CRRn?=
 =?us-ascii?Q?aMAHRkbcAySvm7ODy4JRC40O+IlTb/I0UG9wAndewD08SgIAmk9B6FXsRxgX?=
 =?us-ascii?Q?nl0WZ2srkLU4m1Uw9BzcL19QxL4NR6zQVoi5/WE0KOA2FsXpHX2bhm8EPW82?=
 =?us-ascii?Q?7ecM0tejm9h+k6N/PMWWjr/2r98rqnbaqnzvJCIM8XwuA5UR0ScI4mThV2YU?=
 =?us-ascii?Q?r1em+fsIfBjoKQbzAym2kkC6rakxvAqYrQgOlPr7wz9UOjjbXWyMexb62Dqk?=
 =?us-ascii?Q?kG/FmqqXmUr1GW1Ti8sXJd2nTjsn3sXQrWPgWpNmTTWkARAww6PTTfMREcee?=
 =?us-ascii?Q?2/d9HULgE06Wy2+9ZEpSh8oyiVtG5CVpFPiOoWfo53J6XGkpicEP6K7eqZYC?=
 =?us-ascii?Q?TtdiBwhmZ8JI3QHXFVZrmgbb9bHPvVGPkNI+Hx2X4yTSAst5/JsjeXoylW9p?=
 =?us-ascii?Q?HG1poAge9XeHbsEAs3WLa1oDLnWpugg8HxwtT8WmXqIJt2TDOYRGaxsFdF6U?=
 =?us-ascii?Q?nx2mSSTzqEgLNS0Kh4kH5pX0WaowYvKVPl0sbPDpTZk0LN3MKnpb0Gruc8G7?=
 =?us-ascii?Q?tiiL0SQhq8K4wsyBo6YHrNWOG/l12x2I1Cx18K3IWFWpkDiY3bFPOn2gq+nV?=
 =?us-ascii?Q?n8/4sBhat13Cb0AR886Ln0c2S1gfOfKj5HI6saAB5aBVfE9Kra3CcqOmx1lY?=
 =?us-ascii?Q?4/+EUe7L7MGtwP7G6EtRgp94QPyQPDW6FYZHThsgqDRU0Q=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U2vlIh+9oB03SOBsmJWY6Glh07NmdWoI4uDGfxd1YWVzhee6JlhRjggfROh1?=
 =?us-ascii?Q?dFfSpH7R7HRrToymRkGU/XpYBC5lTV4eJ4pTIVtQZKJ8lQI/FGr/V25yLcFQ?=
 =?us-ascii?Q?bKmJpPtImzBIdmDjIVQvmfftZmgzKRKoaOL2HWFHH1q1QQY7PzR/MPo6yQMt?=
 =?us-ascii?Q?yFBb14uKEB92VFG5YO5/CagpunPm2MQrum7IOS4FI+INx0iunaPdR20X0rCK?=
 =?us-ascii?Q?ynop6KRZPvieNcJqNi/NtixyDe5FG/8aGMSuWVcWuz6cUX9N/GijVGjJ4Bln?=
 =?us-ascii?Q?L21haruJEMHzZuKNaWAhV1LfC2QS2tpr0TPTUxk/oPyQvW6GkrPedmg6x+OH?=
 =?us-ascii?Q?otLjpI7RQ5Z+GM78UopfISHIwApNiVtuFZf+7q7dm8sQNcN/UmU2OqKAlltt?=
 =?us-ascii?Q?nfnffwK6Am49VvDB7YKO3AxNSrFfpV2MO7M+7IoYa3EMY2yl75nfT7eB2cya?=
 =?us-ascii?Q?Ex1sxMqmnSR2wN4WfqqEv7qrE2fJtbgPwJ0vHEvx1h92gg/09iCxhcolC4P/?=
 =?us-ascii?Q?YCSQIJCVyacQ8mdFuVv/K14E2vNL9SmjOvfQAJRH3ik9gELvVOcYzLbn7rga?=
 =?us-ascii?Q?FscF4791S9ldAMr+A6MkQsxqmhOAx3+5RuNHWOC82XoW5aYf40FzX7RCyyAe?=
 =?us-ascii?Q?PfQq8yFgDVD2hnL0cfOG+hHnReDoQF/6YHVxveisyNPc+Ym8i3Xl32Z6h21n?=
 =?us-ascii?Q?9GDKOMouJSoHi5t18Pma0qPx7vRq3KFisL9txPnhH8Q661SC1kXr6BhSkWvr?=
 =?us-ascii?Q?p8Wms3em73AkUoIqrOsu2yyD4Xhqq91kIO+1hywxlJiL4sDshIbveXZZutHH?=
 =?us-ascii?Q?kwXVEq3u71E8yPnSjjP6oxH55mSKn/QunbxGJsMg5n5A2NIYgGoBhDSJWy3X?=
 =?us-ascii?Q?yzILGtQjXAB98dM7rBzqXFJo3UPL4UnkJOb0Ki4+NktQzLZmB8SEveH+sa7L?=
 =?us-ascii?Q?KhiVLOgVI7/HeIuF+8d2ObD9Ca3y2gZh0cmq9q5H2GWVJLCTPbA9NZC8o4oo?=
 =?us-ascii?Q?CwZYeLrPf/w/JDIsWm5+c2xmQP2Fkt9jIDMI69OY6XVdhvuj4GVkWnlWjNUt?=
 =?us-ascii?Q?BNSjdFgMtuNei7Myb7EWvFDXKiFaJbsZddtdxNu/T+dJcegfr7wx5r7s/vtT?=
 =?us-ascii?Q?lrruOm9DDZu2PQTSCYvUF0/uJBU9AmCIJgrA1WjK1DOXf6Ug6Ej5yEIh4fOk?=
 =?us-ascii?Q?c1AAEL6vFLoOpTtVn2GhJXidQoaf59XjQqBw+OrplUK65E7rCVQPTVThQ4L9?=
 =?us-ascii?Q?1n4DSQNvUVfmq8c9MRM5Xsm5vw7LO/FfoCzgto4+MKQCfiaoTeSJfaa0iVIv?=
 =?us-ascii?Q?1+iOMuVxIU0eowGIGS+qXi/iyaVic8To2hGj/75Cf6IgjMa6/odIjQavComF?=
 =?us-ascii?Q?0UD/Y10djOSXaBVokfISN0bNzss0c32eoKHl5Nqpa/Mymlx7QrWhkBtmiqxg?=
 =?us-ascii?Q?0fMX4TJlinnj1V5Tb2xh7c9V/1FcPHOZpRDfOCNj0Qm0ryevgnYQMdH5a/N0?=
 =?us-ascii?Q?/0I2aHW2WiNiMjBLSSDPffyhvXq21F9d+J73+MI/Gb+VZxT59DmHQYbIABA8?=
 =?us-ascii?Q?hyRsn2unDZTDE10z9siyVe+vawIFcenp0UnaWSlq?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 88f640c5-8868-4eec-a800-08dcdc745ffb
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2024 08:39:16.5602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bzkCFfZ39P0IFT1suqnImoTx5vi5JmZshwGdM3iF8UMFWQs9e3a6fo1lNi/XjWVZ/HCm9+lnzvvfWl1XOPQ0xA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7606
X-OriginatorOrg: intel.com

On Tue, Sep 24, 2024 at 12:45:52AM -0700, Sean Christopherson wrote:
> On Tue, Sep 24, 2024, Yan Zhao wrote:
> > On Mon, Sep 23, 2024 at 11:37:14AM -0700, Sean Christopherson wrote:
> > > > +static void kvm_mmu_zap_memslot_leafs(struct kvm *kvm, struct kvm_memory_slot *slot)
> > > > +{
> > > > +	struct kvm_gfn_range range = {
> > > > +		.slot = slot,
> > > > +		.start = slot->base_gfn,
> > > > +		.end = slot->base_gfn + slot->npages,
> > > > +		.may_block = true,
> > > > +	};
> > > > +	bool flush = false;
> > > > +
> > > > +	write_lock(&kvm->mmu_lock);
> > > > +
> > > > +	if (kvm_memslots_have_rmaps(kvm))
> > > > +		flush = kvm_handle_gfn_range(kvm, &range, kvm_zap_rmap);
> > > 
> > > This, and Paolo's merged variant, break shadow paging.  As was tried in commit
> > > 4e103134b862 ("KVM: x86/mmu: Zap only the relevant pages when removing a memslot"),
> > > all shadow pages, i.e. non-leaf SPTEs, need to be zapped.  All of the accounting
> > > for a shadow page is tied to the memslot, i.e. the shadow page holds a reference
> > > to the memslot, for all intents and purposes.  Deleting the memslot without removing
> > > all relevant shadow pages results in NULL pointer derefs when tearing down the VM.
> > > 
> > > Note, that commit is/was buggy, and I suspect my follow-up attempt[*] was as well.
> > > https://lore.kernel.org/all/20190820200318.GA15808@linux.intel.com
> > > 
> > > Rather than trying to get this functional for shadow paging (which includes nested
> > > TDP), I think we should scrap the quirk idea and simply make this the behavior for
> > > S-EPT and nothing else.
> > Ok. Thanks for identifying this error. Will change code to this way.
> 
> For now, I think a full revert of the entire series makes sense.  Irrespective of
> this bug, I don't think KVM should commit to specific implementation behavior,
> i.e. KVM shouldn't explicitly say only leaf SPTEs are zapped.  The quirk docs
> should instead say that if the quirk is disabled, KVM will only guarantee that
> the delete memslot will be inaccessible.  That way, KVM can still do a fast zap
> when it makes sense, e.g. for large memslots, do a complete fast zap, and for
> small memslots, do a targeted zap of the TDP MMU but a fast zap of any shadow
> MMUs.
For TDX, could we do as below after the full revert of this series?

void kvm_arch_flush_shadow_memslot(struct kvm *kvm,                              
                                   struct kvm_memory_slot *slot)                 
{                                                                                
        kvm_mmu_zap_all_fast(kvm); ==> this will skip mirror root
        kvm_mmu_zap_memslot_mirror_leafs(kvm, slot);  ==> zap memslot leaf entries
	                                                  in mirror root
}  

> 
> > BTW: update some findings regarding to the previous bug with Nvidia GPU
> > assignment:
> > I found that after v5.19-rc1+, even with nx_huge_pages=N, the bug is not
> > reproducible when only leaf entries of memslot are zapped.
> > (no more detailed info due to limited time to debug).
> 
> Heh, I've given up hope on ever finding a root cause for that issue.

