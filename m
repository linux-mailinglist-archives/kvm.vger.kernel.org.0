Return-Path: <kvm+bounces-32335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E962B9D588E
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 04:28:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 56AD7B22606
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 03:28:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA7D414F12F;
	Fri, 22 Nov 2024 03:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B34ZPK3O"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84A823098F;
	Fri, 22 Nov 2024 03:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732246085; cv=fail; b=Yk4Jwp+18IW/5YX6Rg5lGIUNU269Mxq3L5BdXflnvCP8kOeE4i9xz3Wyi5C+fa1f8yNqYx/32aI7YM5Ilv6qmaHYaGlEp5Mn3kfQMhpsKmyWIibBTRHsR5zKMIjzN9NSWwzw8HrLkqUxz+PYmSfLnKLCXDGoB71PJDL78Lq8Pu8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732246085; c=relaxed/simple;
	bh=ysGEvzLfjcebyveO/CdINgCYTkBHQhbK7EtgVZUSP7o=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mgc11ScLBTj68ZugkvFDul64gRHrUJXNIbShUJK01ikWLzM9XS7PHdCQCznFzX0AHU6DIUidwpGCWHMXnsj+7UT9xGrNaHrlMzfQJdzlH5GCnEOkbaYAM2U/eebn87RYEpgJMJ/kDXy+QGO5D5YDrw9nVQw2JPI3t1BKjRLy44I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B34ZPK3O; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732246084; x=1763782084;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ysGEvzLfjcebyveO/CdINgCYTkBHQhbK7EtgVZUSP7o=;
  b=B34ZPK3ODdNk+cFLbnQnsJrcu4Ux3+4JFLw73+p/DD5YinlNqp+MXzb2
   aHj029p56z1XHXrvkCy6Z6SrnGQkrOzXbrCvQ+lrUMNMma1QisKAJKMVv
   jnqwYBKy3zSkaEu6wRKoBtzEOaBfgp30SSGjmSJ0fYxtXp03rcEDh2cER
   gWACF3Jh3WIwVcyjZTHZIQ8w9yuxfyDGVP9m06AYPcDZ8/6zYmyL+2k09
   K0f+6g8ZxzsfbX3gJdS+0ECnkvKLgp08pkHYOClfWQdT2HEV5A9bfURam
   06q9M/q3dx8YgrnJDR/+7wlmtpzaU+Ajr/ZP7yrCjpY6aEzjxv+p9wV4+
   w==;
X-CSE-ConnectionGUID: 5l/syhQoSxqTXmVgdvirHQ==
X-CSE-MsgGUID: euIrOJ/oS0eJqUMf3e59CQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11263"; a="43767435"
X-IronPort-AV: E=Sophos;i="6.12,174,1728975600"; 
   d="scan'208";a="43767435"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 19:28:03 -0800
X-CSE-ConnectionGUID: BhFfHUcDSvWYEKBxdac/8g==
X-CSE-MsgGUID: oljBwnMDQ1+3fwRTCti+3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,174,1728975600"; 
   d="scan'208";a="91248581"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Nov 2024 19:28:03 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 21 Nov 2024 19:28:02 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 21 Nov 2024 19:28:02 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 21 Nov 2024 19:28:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uvg2hMI10Zgt00Wa4M26reESbxOaPe11WemQ5BwKZLg3FrHIzhDpyqYEw9z1IhlK95h73InEkcXZ3OBNrK/8/ZwYEgK8ZrspX2kY2w/r06McezLEkgQyKDN7QQ8eSi5S87uIITI+tg4cwaGwmpYopDyuLiJYsIxXYIFVrwNuuiglarFJrUTsXHoe5y8HDzKCWYqiW1mOJdjjzFdZ+rO8FNh0r7TWus5Nm53KnCVoS65f6ExAoyPZYkt5/70RqsAQPgNw6xrKDVmo7Ri7m02By1Su8kIwWJNECQfD6QPuq1pSwYmOq9aI/gBw5BJ5s1cYR8iVwSPYvzp9PE3IkVa5uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oZSjo3awFOmKmUoOG0M9NXLHyaSGOMe3FA7hg6IqL4o=;
 b=jOH/C7VtADAtrj/H/NY4xbEwj6TCHz8r90yar/kOBLZniSmoOU5zYke1lTt9oDhObE9fz4+DZUK20ovksOqOyAkxItKEVDdQNlYqncExAxT64Llne6Jeoou+2MdfVCEtc90h1nW+0tDF4lObdd9T8n5Sb+IwCWtK+b239KWZAh+gLJ5WKn764SnTIvQ+p9MqywzsMd0hxMPDGoyv1njrDU4OP4tRmYuq7ME71nqBSu0rnqLXcOknzYR9bwswOK49frKSwMLuBp3bN+OkegXv/zKv9rpPYzy1BgrHh3+aM2P8NJ7pUf7lgOO/LvqCR9TvWU2wXu9INNbkHYRgG4JyrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DS0PR11MB7850.namprd11.prod.outlook.com (2603:10b6:8:fe::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.17; Fri, 22 Nov
 2024 03:28:00 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%3]) with mapi id 15.20.8158.023; Fri, 22 Nov 2024
 03:28:00 +0000
Date: Fri, 22 Nov 2024 11:27:48 +0800
From: Chao Gao <chao.gao@intel.com>
To: Adrian Hunter <adrian.hunter@intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <kvm@vger.kernel.org>,
	<dave.hansen@linux.intel.com>, <rick.p.edgecombe@intel.com>,
	<kai.huang@intel.com>, <reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<dmatlack@google.com>, <isaku.yamahata@intel.com>, <nik.borisov@suse.com>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>, <yan.y.zhao@intel.com>,
	<weijiang.yang@intel.com>
Subject: Re: [PATCH 7/7] KVM: TDX: Add TSX_CTRL msr into uret_msrs list
Message-ID: <Zz/6NBmZIcRUFvLQ@intel.com>
References: <20241121201448.36170-1-adrian.hunter@intel.com>
 <20241121201448.36170-8-adrian.hunter@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241121201448.36170-8-adrian.hunter@intel.com>
X-ClientProxiedBy: SG2PR02CA0009.apcprd02.prod.outlook.com
 (2603:1096:3:17::21) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DS0PR11MB7850:EE_
X-MS-Office365-Filtering-Correlation-Id: 68b8d36c-6fcf-4af9-bc07-08dd0aa5aa6d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?gagJggP40eFg825d0bbnPruUdnM2RKD7/n6t+Pr6GBiicoOxWkN7KsZ+/tqd?=
 =?us-ascii?Q?AroS4RKakNQzBph4sqcPjdKZ2B0i6SNLiKTy7WJ4qv3ZQ3IVVaWxa96pM1qn?=
 =?us-ascii?Q?yvncslA8ysunRCdapMl+cjKlfy14KGRCXlEp1RS/SSEntW923pJ8yRaiicGu?=
 =?us-ascii?Q?gJf0ywH2tuVUBOPQOSVv6+U0AL8wrdjfVFfHHjIgqM4YSVoHqxV//8+QD66W?=
 =?us-ascii?Q?r/5whn7m7QUk0Cx8/uhYAukKzVCOb/cdIP7WRziI0vrFTZXIXKBuWiK5HTxi?=
 =?us-ascii?Q?mIvK/52Knu4xmcAAOVO+7W7esACyYGBVTpwjfS0MHnmA+ahXmLBIgFePMwbB?=
 =?us-ascii?Q?/J9Hnj0RiA2x4evtCtC3s5ep+4cdweeGXXEmRmtrfdbXMsbgNpNxWB6OMNFv?=
 =?us-ascii?Q?eUmMd6JJWyuWBQWEfPyvmfBqMa80cZiSECqs3s38nGXakM0jNqq8otz5GDVI?=
 =?us-ascii?Q?Xtu6eQPbq2LnzM9xichcIDMZMbYGkMKSPjbjjg/42IoVqbb35svL0Aqxn9Ch?=
 =?us-ascii?Q?9oBqLUndfKILwuzXk21/EPvi7P+zgy4HQPCkEhihV5l2mbb0h0NRgO47OMFZ?=
 =?us-ascii?Q?abK4olooQqkLql7sKs34kD3wYI7ALPZDqxCftaKQRytVV6SCzwQ986HaU887?=
 =?us-ascii?Q?aFTCCyUrvZNACKHWrkCywuvH9iDvTXt9rWUebMd3r60qO33WA4jlqHPlc9Tn?=
 =?us-ascii?Q?2SF/N+B2y9cucbfdBt9wpJKIDE+dOg1Wm5xXeLNufC8Rkrm4IMBHmS6d9WAC?=
 =?us-ascii?Q?LEKRZLmxBr+KGmC6zDkLXDWbhKBQZy8HD1x0UMcqSdX+F9HRJHYOlRRqeJWN?=
 =?us-ascii?Q?2ljRUC7tQ/b2xqIiAgTdwZ8NLrlFl0GRY5GLbBFlEDhhQfSnFh4lo6OKq2oN?=
 =?us-ascii?Q?CazdTPjXz/xssvKQjN9sutI1pIJIwJLNIcZq50S79TzrYU+DtABdvAgRN3gh?=
 =?us-ascii?Q?hAee0a/xqRr/Rezgh3Pb8ZFIC/fk8UN5hcFrL5IgrHYIpfw7WUsqnCEQDDBj?=
 =?us-ascii?Q?Tetmpb+8Zvan0FVOpzZhF9geVqFy5w+CERTMpE+4P3tY9OKXXo8l1nQExK4l?=
 =?us-ascii?Q?ZzkV0wMCQCC2hslDgcaOKJlnq/rxvaIPjxYfSwtkxhXqxVL/UntmYH4YFvf0?=
 =?us-ascii?Q?34t6ia/z7xdAHatWrlrffBPPMbd+YBrSGOi/kyOkIO4lDOUAjIwJMy0HlpZ7?=
 =?us-ascii?Q?o7KBZHwO8TIs0UCrDXNXkNLzgqiR7x0UC9tsRL32k8joMYKHdTeNh2SgvzxA?=
 =?us-ascii?Q?h5++ddP6eUYpOxJObiFSHnq2FX5QrEoFtdsvD2b5b9Pk5/nbNxW13+MuQXM5?=
 =?us-ascii?Q?H6sswUj7Q4uLmD6n3eJjrFoU?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QEfWrJPZyV0CTd99Az6ovMcgzFh6vTcX25VqqYnnI7X4pnzihF6gdQkEQkY7?=
 =?us-ascii?Q?m6Y3BZo7efYeAtCWp9DLZ/RicCWy2G1PwB3UrZOeu778EQlqQiPu9YXaC5Xj?=
 =?us-ascii?Q?D6Z+h67fiGUknwzAKkBKey8lxrWz7JTobyVEiPrMzJSV0L5QohfXIsICXExP?=
 =?us-ascii?Q?tvzP8AKXN5ymD1GzzcMAml41MFj1IlBL3Q5VVwMDc6e4lUAPPv3nfJ0Y1Hq6?=
 =?us-ascii?Q?F21KFuDmfvFXJai1s54NJYXMF+zQCFcDcwUY3OnywIhXxkwiZxosDiYDCOEo?=
 =?us-ascii?Q?kffnqt5VJeSKi0MCMFZYVhW7otkCoDXtHAudEq2qjJrgBzG3QriE+1CpyaB7?=
 =?us-ascii?Q?qSOwEEqeoW9zzLnSE1g8CH9rWW4qWJMmF188id8DrDpG1Ae3zts0f7jr+U8U?=
 =?us-ascii?Q?fVJoPjIC94ehd+kmXrkhypi0QvwC2MHySefVXvO0HPeLVSxhoAT6OjF7XdgS?=
 =?us-ascii?Q?00mFaZ/bv4PiPGEQESy8ChR3O1R+EeCWocZNsr3JtjHkxRXlIq9mQ1RdJgRk?=
 =?us-ascii?Q?SahHkT1Q9tR4GWxzhBCDB810kVxNYxUs+Z7ZrzjCGUzyCnL3rRM1SfHX2bWT?=
 =?us-ascii?Q?vVKiBUWZGXxzwzFLsNSerKCYXDTOpmkWEmd7fikCKgWTEFaqCNUCgb0zZa/4?=
 =?us-ascii?Q?oagbOiQA6N08cmuyJuu/20S75wsOWXCQN0fKSe1hBmC6/xQPP3ocL3Ocp54G?=
 =?us-ascii?Q?k0mzQ4Xt1TK8OoA5VGHm2XEdiLQwcLiN/1N1XzlQpkcXCcvFql8X+igVGSe8?=
 =?us-ascii?Q?DO4OZ3JuV1ubnmJ29twgdr82a+0g+Bk6F1Z2NrU1tc6sH0Br5UWOVGUixtq9?=
 =?us-ascii?Q?AmAOu59rR5onJhsL2omTB9JT/9T6cK3AXlAEM6TKE87PUokXJSt2inR5cE/P?=
 =?us-ascii?Q?BWxT6ntFZg7qbZ4lQ7imiJzRzZMgwPNPbAEC3wS8AeR8XFPnOIgAkylDBJCP?=
 =?us-ascii?Q?6rcuM5c3S053w/eCVQDBrPQxUnd06GnVSleJir4fBpNKGxArJvvbeU5APMxR?=
 =?us-ascii?Q?uDb6xZNm4H5whPSsgdHTS4BjV7uhlO1YOPYdGcdPjZpVvBGtXbRBTbM2jSR/?=
 =?us-ascii?Q?XQ6TqMB8mkdiS/tdjBOH2NZLJzWBPcyO1jNAnA7WTZaWWNvxuwMZhRllj/uv?=
 =?us-ascii?Q?8Xqb+a8Z8S5vVaTA46UKO19AervWMapIs+u1dORCniGn2TuJ/MYDyjlIHYIs?=
 =?us-ascii?Q?Vk5JjayB227WWYnRIefwdR2TxA0abvI99im/9G2Sbhm08hFMLT4+Ek1DLWZp?=
 =?us-ascii?Q?fQ2Hz225jZjuzmPtSy1zgY+YhWF4vRaTpJU3MJQq21lUa8GilK+wIEyyHXJX?=
 =?us-ascii?Q?UAo+yGAAyyz+yzb0RC/6PoVVIoUxHOwiHqQs7XN3BkSjQ59JAbTkE8HhOHT5?=
 =?us-ascii?Q?R/WAFLmnJrGKstWU24ExjlPNrV6QVld8wwlzBNP35ItBpHBIvj+Z2Zy14pWS?=
 =?us-ascii?Q?PA3ytmVRS3ApuDO8sRvJqLaf5OLWFctE0b8niOASFr+LX50NwVKciaHEk5uX?=
 =?us-ascii?Q?rdhByqzXqoGHNuoUD+QNc99Qcl4SlDXnWLOzq1XxegJe4d4EkW7Iv2C1Q2qJ?=
 =?us-ascii?Q?PvAuIfcwFd8RnJzlzfbSMluOQEWvRaYYd8q6IFl4?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 68b8d36c-6fcf-4af9-bc07-08dd0aa5aa6d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2024 03:28:00.2925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0pBbni9k1zNT6nCVT4mmzYIbBeRrLEuBnlVhowEtkcqhE5QZ0aE2gO48r/SshAPleVFgb2HfOG7sOX07fWkAbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7850
X-OriginatorOrg: intel.com

>+static bool tdparams_tsx_supported(struct kvm_cpuid2 *cpuid)
>+{
>+	const struct kvm_cpuid_entry2 *entry;
>+	u64 mask;
>+	u32 ebx;
>+
>+	entry = kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent, 0x7, 0);
>+	if (entry)
>+		ebx = entry->ebx;
>+	else
>+		ebx = 0;
>+
>+	mask = __feature_bit(X86_FEATURE_HLE) | __feature_bit(X86_FEATURE_RTM);
>+	return ebx & mask;
>+}
>+
> static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
> 			struct kvm_tdx_init_vm *init_vm)
> {
>@@ -1299,6 +1322,7 @@ static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
> 	MEMCPY_SAME_SIZE(td_params->mrowner, init_vm->mrowner);
> 	MEMCPY_SAME_SIZE(td_params->mrownerconfig, init_vm->mrownerconfig);
> 
>+	to_kvm_tdx(kvm)->tsx_supported = tdparams_tsx_supported(cpuid);
> 	return 0;
> }
> 
>@@ -2272,6 +2296,11 @@ static int __init __tdx_bringup(void)
> 			return -EIO;
> 		}
> 	}
>+	tdx_uret_tsx_ctrl_slot = kvm_find_user_return_msr(MSR_IA32_TSX_CTRL);
>+	if (tdx_uret_tsx_ctrl_slot == -1 && boot_cpu_has(X86_FEATURE_MSR_TSX_CTRL)) {
>+		pr_err("MSR_IA32_TSX_CTRL isn't included by kvm_find_user_return_msr\n");
>+		return -EIO;
>+	}
> 
> 	/*
> 	 * Enabling TDX requires enabling hardware virtualization first,
>diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
>index 48cf0a1abfcc..815ff6bdbc7e 100644
>--- a/arch/x86/kvm/vmx/tdx.h
>+++ b/arch/x86/kvm/vmx/tdx.h
>@@ -29,6 +29,14 @@ struct kvm_tdx {
> 	u8 nr_tdcs_pages;
> 	u8 nr_vcpu_tdcx_pages;
> 
>+	/*
>+	 * Used on each TD-exit, see tdx_user_return_msr_update_cache().
>+	 * TSX_CTRL value on TD exit
>+	 * - set 0     if guest TSX enabled
>+	 * - preserved if guest TSX disabled
>+	 */
>+	bool tsx_supported;

Is it possible to drop this boolean and tdparams_tsx_supported()? I think we
can use the guest_can_use() framework instead.

>+
> 	u64 tsc_offset;
> 
> 	enum kvm_tdx_state state;
>-- 
>2.43.0
>

