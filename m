Return-Path: <kvm+bounces-31712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BBD6A9C6912
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 07:06:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4AE0C1F255FB
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 06:06:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CAB8178384;
	Wed, 13 Nov 2024 06:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lJPd9wbU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD8815F40B
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 06:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731477979; cv=fail; b=T9PkLZBbR3XjjzMy7dIq+kYmedwjNPJfXTZa2SQZehQK0UYFm/6G09gzBAeDXET/Zj8hSrt/kpYTwjhgeuIlfdzpps0U6cUhrP0agxeGc9veo6qy6fuqX6epr1awguvmz7hCibXAtzPTe81+OK6HotDAKfCH7a2+toCKjFoXB7E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731477979; c=relaxed/simple;
	bh=ACxyAb1Jlll9hgxi11OxqAJaoraMqPCGBaabKGd/0nU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QqmIMxJgHRewk6AD5z9U5fJyObw9csLznCN3j/ARHpvdYGnyiZ09o+QWyXcpYehNjziW0Dss+cJksc22bLNUFG/PMG3vr7VmgmbcQ4E/DJ1mrTsSy8uQnxJ9Ed16ahP2nqlTd31XuopbfVETAciTMIyimfdMbbLSHvhQzuBnBJk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lJPd9wbU; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731477977; x=1763013977;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ACxyAb1Jlll9hgxi11OxqAJaoraMqPCGBaabKGd/0nU=;
  b=lJPd9wbUdD7pLLQLnmXJ59CGnU/wYBk1yNYfBRSZ+wEZXHZYpLsuWL0y
   x/TPgowhBl0ENXuzdNW6tQMNBYYQ/8NrDp3eYnzUScVmdnt3wqLg0JMrN
   r3K4J0+sryoqfrGKoIKEesuigiaC4ltvJU9w7I+f48GNleAbRWM75FwLD
   vL8eoGUC3L8o60rLlTgYJUZIlhs+9Tz2xCnOLeKznbO8djMQl8jMSO5hW
   3q/AIklM0/hgITrCpmNi0vx7trATpKjhqbzLF+pGNvWChZTnLeo7fktJY
   azO9tCWqX1MnEnSgv3/OB5UV7cL/DA9dNCWysJ7vcZB7Oaf4MGSX5tIu4
   g==;
X-CSE-ConnectionGUID: 1YCOUQIqTtub+1lud/pxrQ==
X-CSE-MsgGUID: eGO45nzqR/6MgDjDg0M3cQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11254"; a="42738990"
X-IronPort-AV: E=Sophos;i="6.12,150,1728975600"; 
   d="scan'208";a="42738990"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2024 22:06:16 -0800
X-CSE-ConnectionGUID: m3Kjg8a5R0CUdPRJ8LUOCA==
X-CSE-MsgGUID: VcXuD3YcTuaGL3jpqfCLKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,150,1728975600"; 
   d="scan'208";a="92836224"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Nov 2024 22:06:17 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 12 Nov 2024 22:06:16 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 12 Nov 2024 22:06:16 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 12 Nov 2024 22:06:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JUrr6DSorwqzOJt13IHhBMKZ+2PEDLedgdHU8BH3rxGfxWJjIh4bJp/HyvN1q25GMo/r82wxBzc88cCj3lh4OnvGvqnaIKdgX7oLwbj1yZVuB5Y8OxEsRgDRP7UJj9MUKSjy14K56S4KHYojVsykCXwECDJ53+QQGj6hP2NVdE/U5ZKmpd7fgn0NElEBO3XAyWEOC7IbvTSGYEPpiiUj1U5UBuH9ealkTG5/q+wVIxhJgyMcCW3oEkcyMR2ZllBNW3d+pfME2Uq7ysTiThNPj7YYr7warmcW6aEZEZ/g+i8/loKUYq9McfX8PeHCS0QrTNTjhgg6krHdb24WDxkTCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ACxyAb1Jlll9hgxi11OxqAJaoraMqPCGBaabKGd/0nU=;
 b=mpSHL1TPQJSTsgHcj4ZdMeymApSdI3L2LX2JIQlWog4qyHwUT1ubVmld9h0302NwsZrUEXDAK9gaL8L6NBYxsZDncU7ZvXJPlfE5bd9sqCzcBSRzNJZP/nchjBYNGRoBflIwM76bwNzv3PAGHy5cUUuqIL08pxFO9/PSNIWpFQliFkb6D83QD7kDmW7qpijhr20eO49cbcU2vygxNjhXu/Hzr2f6s/ej+HCsCC1TqePekoAO1khRVuUTg079LrZRqVbEMxXGN1dPdWTZAc0KVBYjc6C0+I96cK0eL82Rh192DyVWfjmzSC10TcVsTxCHJmRKP15aX7rKmiTQ3OsmdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Wed, 13 Nov
 2024 06:06:13 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%3]) with mapi id 15.20.8158.013; Wed, 13 Nov 2024
 06:06:12 +0000
Date: Wed, 13 Nov 2024 14:06:04 +0800
From: Chao Gao <chao.gao@intel.com>
To: David Hildenbrand <david@redhat.com>
CC: <linux-coco@lists.linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	KVM <kvm@vger.kernel.org>
Subject: Re: [Invitation] bi-weekly guest_memfd upstream call on 2024-11-14
Message-ID: <ZzRBzGJJJoezCge8@intel.com>
References: <6f2bfac2-d9e7-4e4a-9298-7accded16b4f@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6f2bfac2-d9e7-4e4a-9298-7accded16b4f@redhat.com>
X-ClientProxiedBy: SI2PR02CA0019.apcprd02.prod.outlook.com
 (2603:1096:4:195::13) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH7PR11MB8121:EE_
X-MS-Office365-Filtering-Correlation-Id: 764e8b08-1247-4621-46a3-08dd03a9469f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?cA4WTUvl3MUL/b88giMzuaY+0S27Ek95TA0cKJ7p8EYmeKl5AaKT/BooYEk6?=
 =?us-ascii?Q?DvhN7y8E1fGb4nUyRgrBVvQVjKXPX0HvoGDlcWxXSarHpzqkdCv6jaZZOovA?=
 =?us-ascii?Q?QT+OXwjcSNH2oPdKqyidLZ5f4ShskYxAmNPxBnZj5wkq0a4doKOSyb6ZwCxt?=
 =?us-ascii?Q?JyVDqyXkRkhVW9EkkInvGL4XIAM7kCETzpGXAdbZ52eoGLubs1DRa1FFo1st?=
 =?us-ascii?Q?+aiuSpx1FAS5kUt+8+sXVQ+ZgNJuGsrQJp1+aO7nU6fEEGiQiZiq60qpG3Hs?=
 =?us-ascii?Q?mBFbcdYKexCQ2S0ulfShc+PJAz4iKgcxlPM+6UUzNOkn/J3ticY3Q090aXZU?=
 =?us-ascii?Q?Gs5FzAdxN9WhJE/WbHm7Wvj48sSawRdmekTqQ2Sx3GeRyrqEB38ZYor87T00?=
 =?us-ascii?Q?32Fidl7Ub9s+W7OJ1xgIstGLwWrVS5lGlHOwXEZG2wGS2CcyDvl0j0O/kv0F?=
 =?us-ascii?Q?IdzM59cbKX39ZAIf0aAa+zBaq4mVGymueDPwKcG5B3BWukoru2dbxMJbwx/O?=
 =?us-ascii?Q?sWHEqnCRfFAVsncy+Gvc/nNVruY2K7eGdgx6ZThCtA7zX7oelTuzxmMVtYBx?=
 =?us-ascii?Q?6/1Py75BXDHjvZLdlGRd9peL9xjEVYLPtj558llFdaPFf+DnOJzZk+MQQ9N4?=
 =?us-ascii?Q?Vndvm5L3Nfhzkli6yOrIbjIRn0RwCajh9njdjVWSEJu7Gv7pUbqn74MyeEKG?=
 =?us-ascii?Q?eX4CiEqCAZFNy+YjVgxck8stIhEJwTwPfylmKHO8uvwpvcCbwQ+Us61/RN+z?=
 =?us-ascii?Q?bydca4mvAQSGi8elMDXexT6rLeKBM3HRnKVixiNRB5HehxSn1oxgZXHZMQnf?=
 =?us-ascii?Q?aLmiBbYqt5xKpQwFLkQMKsFYjtMehk83gwLEaOGQFrawFoTB+yW7zHCQ7pKl?=
 =?us-ascii?Q?0yFXJ+MuZXiT6T3yDTtv37Og/DB1QoY79r9arXAsJjm005+jPppFXLixB3qH?=
 =?us-ascii?Q?N3WbLHUChV1L4nWre3a/+OEUDvB9kqKyqsKcFwzMa0CnAh1Xtf8RYCUShHNI?=
 =?us-ascii?Q?sYzadSGLRRPsnIV8xtIVoafHFW0peSXJuJUHIqKuzmVEwJMNiolmnaPTJUs/?=
 =?us-ascii?Q?UmgfCgUW710kv2hbzDmpma9JH72EFO6LDqxH/MzjANTZyRHq2kkdaz6h94K9?=
 =?us-ascii?Q?977k+lzFqGvULbdSyHW9H5FXB23+Gpv0jxVzr9Z6bE09jAQgNFwUYdrQf9MU?=
 =?us-ascii?Q?vR2YMt46BynlQ8Sb04o7UolToWiB7uXKM7+6HRGsRMDVpBkGXdVCaKkGE7rJ?=
 =?us-ascii?Q?0aO+g/tiq574BmTpTvSbL8uhB5LsDVUfWnkBFEWGSsdktoZ270NDpzPwe8gl?=
 =?us-ascii?Q?9O/1rwAqHDEnbwptnwkum2cB?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FoBFcWRS9wPQL1Jag2rVCIFBmKwXpXJEljrTiwAJ6QXjp4ernrj8maUl6KrZ?=
 =?us-ascii?Q?jFYnFjYFGHDnkD7Jm8W/gPwfSJkGw+bHxpf9C8jnHgJ52bUjHtpm9gyylCvz?=
 =?us-ascii?Q?DCxuzOkhZOoHPe4AKXke4wuby/cmMWs8dgFe7wZ2uAguCcHDKYt1qHx9WrHo?=
 =?us-ascii?Q?8F1LR4Z+Q37i3qJB0D6kMOkkX6Z4vamF3QzvNJUnC7WPOK8l1p6kT4LGyZDQ?=
 =?us-ascii?Q?n9UNrOEorXdz/pKM5CrvTFVaQnWoFFvAXOjD8TxKMIkYTthE7Q/HV8HQQ89R?=
 =?us-ascii?Q?G7n+X2ymScA0P42So9NAIEohCiPNGfeY5+K0XG87T3s53Dk8OUe6KocU1F67?=
 =?us-ascii?Q?vF88A+R/Z5B1wPay1AqbageE8+msCG5CEvA4nLXBzZDFSD+72PcGxY5DPif2?=
 =?us-ascii?Q?8aPoKa4+7yiuN1lkPPR2PzKXHku9KLVx8432mf6MY4dtZz32bWeygYfnhRfB?=
 =?us-ascii?Q?fUOm5zSmXl+nvp3WKt6vo1/8lcKo64OMF4DLsn2nER20jVNNMYu6+sFSJZ+C?=
 =?us-ascii?Q?69oq9GlqAhjsubLA/mBzx3/GT8ajPPK5otsWmT9Sj1cWmfX9CodheuyAAvWI?=
 =?us-ascii?Q?+LxQBST8yb7eAudW6RI+YIBa0k9wfMikWRZ0AX947MWW3ZAHpKwbgxZrk8B/?=
 =?us-ascii?Q?8B81UxPtOzuNi/eGzT4iahbv0oWn02qfcI+herAFGVTJDCxASYETdCmUpXAz?=
 =?us-ascii?Q?sYJn/SXuhCf+yVEjTepItycgwwoxkLZz8TkdcO8RxCyIfbR4v0GSsqOh07CJ?=
 =?us-ascii?Q?MoM0GFTi1VvkPQbh2t+xUWBiEbki/fQ1iKOxbwq4oxl56zGF+56v5Wk0L4SU?=
 =?us-ascii?Q?fQr/uY0q/cD131PSV3n3BoxIpbmgL6fiK6k8iuLh77tIoC2W17YewDWrXkn/?=
 =?us-ascii?Q?hJ38UDqFDX+7HQRXDCrjhDDudEy7Ak2lxfXJDYOCmJhNfC+vYVVesfIEMqwA?=
 =?us-ascii?Q?u/bu5fhwwDI3WLC3y8fpOH2OVvcJugjs7r5q3uOpAulrp5OQ8D8U9JOyrnv0?=
 =?us-ascii?Q?NDAJrSkUpOnOVNva+MOimhXLJi0IuenratKV4a8Gp4vmoN16O+Lak+WeTcJp?=
 =?us-ascii?Q?JMI+ywcBRT7AMU/1AG2LkIwz6W0hH7tkOeD49Ar//HE6256yebB0jYRRFuLV?=
 =?us-ascii?Q?GcOnkCYk2/OcVk+e7rRWgy5hC+Qw7dXdGMvk+DBWwk/YLXHV1ga+/yWcFNZ8?=
 =?us-ascii?Q?zjrpTcLchf05DGrHmpN8MyuAhyzhRGRrWNVeMvUY3W3PIHwh8luXakSEM4vP?=
 =?us-ascii?Q?c0gpwOXJDt8q/8tegWdHHjPSugwyrw1SNXNXiX3PktRH0S+p4fM7ua6ZCiJR?=
 =?us-ascii?Q?TeZZJ810f77H7siPApAtFSSMn9B3qtJpokpal0Z9cl7GtJ57RhhALDkoFbbX?=
 =?us-ascii?Q?vIZ3OF7WGdjAx0qFH8jMP/qywP18IZzSjWewDNikdPZeOLphKtCUvTlc71LY?=
 =?us-ascii?Q?iiz5cqTg5XxKf/07D6KBCXu5IIKb9s+aYfqK0zn3tFTyTnK/SV8dzOjuWFv/?=
 =?us-ascii?Q?A0tWXDGViKz/nDlLt+EzWIVQbf9n3mlYhBfkEjevtP4Fdjgvnen5sb9kUZiT?=
 =?us-ascii?Q?Q1caM2gJR8hwTjwRttnfUsYaEpPdqylXPBrSuxht?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 764e8b08-1247-4621-46a3-08dd03a9469f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2024 06:06:12.7070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ls79K8OoFJe/6PiWES+9B7kLM4X8nFqP8w5prlA2VAJKsYy5Ln5e7YP8q4WBk9NIdzApgGkswpoLe3db/u5Lgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8121
X-OriginatorOrg: intel.com

On Tue, Nov 12, 2024 at 01:30:06PM +0100, David Hildenbrand wrote:
>Hi,
>
>the next guest_memfd upstream call will happen this Thursday, 2024-11-14
>at at 9:00 - 10:00am (GMT-08:00) Pacific Time - Vancouver.
>
>We'll be using the following Google meet:
>http://meet.google.com/wxp-wtju-jzw
>
>The meeting notes are linked from the google calendar invitation. If you
>want an invitation that also covers all future meetings, just write me a
>mail.
>
>In this meeting we'll discuss:
>* fbind() and NUMA mempolicy for guest_memfd
>* Persisting guest_memfd across reboot / guest_memfs
>* guest_memfd use cases for a PFN range allocator
>
>And we'll continue our discussion on:
>* Challenges with supporting huge pages
>* Challenges with shared vs. private conversion
>* guest_memfd as a "library"
>
>To put something to discuss onto the agenda, reply to this mail or add
>them to the "Topics/questions for next meeting(s)" section in the
>meeting notes as a comment.

Hi David,

We would like to discuss how to adapt the proposal for shared device assignment
[1] to recent guest_memfd changes, such as the support of in-place conversion.

With in-place conversion, QEMU can map shared memory and supply the virtual
address to VFIO to set up DMA mappings. From this perspective, in-place
conversion doesn't change or require any changes to the way QEMU interacts
with VFIO. So, the key for device assignment remains updating DMA mappings
accordingly during shared/private conversions. It seems that whether in-place
conversion is in use (i.e., whether shared memory is managed by guest_memfd or
not) doesn't require big changes to that proposal. Not sure if anyone thinks
otherwise. We want to align with you on the direction for device assignment
support for guest_memfd.
(I set aside the idea of letting KVM manage the IOMMU page table in the above
 analysis because we probably won't get that support in the near future)

Could you please add this topic to the agenda?

btw, the current time slot is not very convenient for us. If possible, could we
schedule the meeting one hour earlier, if this works for others? Two hours
earlier would be even better

[1]: https://lore.kernel.org/all/20240725072118.358923-1-chenyi.qiang@intel.com/

