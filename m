Return-Path: <kvm+bounces-24125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF900951953
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 12:47:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E52101C209D9
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 10:47:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4CBE1AE04C;
	Wed, 14 Aug 2024 10:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ARCQ+6LE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396FC13635F;
	Wed, 14 Aug 2024 10:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723632424; cv=fail; b=AxuL3BFXhcYHYbyt1TM3ttqxbo1OqvBLajlcc3XFrTgDYt6+O7+gJy38g78tCp73QwMLblWA8ExcpJl8aqYAuHelKjBGpS+E8OBm/HkA3mX+udE72UYgIbXrncPxsEe6AZzSBgxy0B+sASWfG99Z/7czplVo0GfpgRrm22SYRSE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723632424; c=relaxed/simple;
	bh=+6v4zupK70agjbjdDSdXkoyxTaaQka9grtztPC0pKl0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gzLGs2I0qpPmFop26AArBh5/j/ojDIeGku+INHHSbc2kUmLznXJV8WtCPelw1iGD4wL4N0smxOWIQ0lfydERomQ66nI7NaaM8NSmluAipBolkk9Yo2UkIuBx8n2p8rQN4ZggJL5YSXzneCc7o2Tcpn2a8MCttZZYLoTa3Yj5Xb0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ARCQ+6LE; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723632422; x=1755168422;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=+6v4zupK70agjbjdDSdXkoyxTaaQka9grtztPC0pKl0=;
  b=ARCQ+6LEOtc/zP+q43Q9ie0PjTghIDnPiekE6fO/RHD1YJbWB+GBgNan
   p403J/nCW7yGIZX4wa/63OhSM3sMuM+hI0zvtayEt7pQlskoOF+0j/WMr
   iD1H0tLibIe/exJoYvDo4eVl8pzJk+HDeVVQcnPNoGHehwcLG+hImBXtW
   gEASJt9NvKoQOzCFmm02HQ/uh3eVTGY/Ylck43v/zXLJBexjhfxH7pdP0
   ZTb60+MTFfkQtv/ahXU9KgJg3m/VDeEKbdWpcTB7UuQW1kC2j3nLsL6Y/
   eIhm1IUOyMVnIvPJf972tbArNhAxLlhUNOc6toiFcy2UNjLWNEFXurDR1
   Q==;
X-CSE-ConnectionGUID: orBJq0KiRouVQt92lZDosA==
X-CSE-MsgGUID: 6FJNctW6TGmm7eWSglFMvA==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="21698899"
X-IronPort-AV: E=Sophos;i="6.09,145,1716274800"; 
   d="scan'208";a="21698899"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2024 03:47:01 -0700
X-CSE-ConnectionGUID: xojUtlRMTtW0h0jh16/jWw==
X-CSE-MsgGUID: ddpdSTgUQj2MFPXeDVVhgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,145,1716274800"; 
   d="scan'208";a="63823557"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Aug 2024 03:47:01 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 Aug 2024 03:47:01 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 14 Aug 2024 03:47:00 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 14 Aug 2024 03:47:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zose42uBFzd0zpifvI3Jlp56uomndSsUijVcwaO2BpjYF6B2d2WWKsRX1qnQuvbn4wADafS5Iz/T1qoOteq/5j3EnD1R2VBrpKP8+T4uCFXAuPnFgzwolryU0D3irBpkHInlYl7YORXN0kElXMmO68T/fC/qL4AI3KX4S0uXbLVFDQcSsLzrbbqTptmNsKYMkzSiaIKK6nTgWkSFF+6OYXhnvqD8sf2WLjfAg23CJ59z+akt7M5gbf6uuiJAhXCn7XYeNHJPGX76X9nTgxI4K4BTps0N+ARyTmAUgfQb/dGvoXx4MGvFp0EGgivcnCUdANprOsXMdg4ECbKqEyEYqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FfjbM8eCNCRlbQiMZrE0i4y8dzeaEYMVsYwR7ZnfmMU=;
 b=eArI5Gax2gyfdGB6o2MTlbtSqVt+DCYYVL4RdV7smvUTCV3t9G8jsDrAZbcGSP84jg7Vi/3z2VQuG3hmwWt+07Yh83DOiWgfeKroCnOJTgsXFsqZ2mu0ZwmjqhYQ3qebEYJDRGv2PcSCZl0EXrBXFpZ78e3WJazN36vnbfrlWIvgyqpEuF1fXWYyCjxc+z5zUFLXMvCkTMUbJ5cnq/yO12qqImaKVhwXe1703uMghB+Ry6xgLneCOu7YnF7vZlGVhblK3vTxx5XAmV4aikFMmCMP+5PYsmFeF4dLWJ3QmSMXYTwIAk35ETG7IYxE8XZIih/2F8jhEWixM+n+QQ8kQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA1PR11MB5826.namprd11.prod.outlook.com (2603:10b6:806:235::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.31; Wed, 14 Aug
 2024 10:46:53 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%3]) with mapi id 15.20.7875.016; Wed, 14 Aug 2024
 10:46:53 +0000
Date: Wed, 14 Aug 2024 18:46:43 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Xiaoyao Li <xiaoyao.li@intel.com>, Rick Edgecombe
	<rick.p.edgecombe@intel.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kai.huang@intel.com>, <isaku.yamahata@gmail.com>,
	<tony.lindgren@linux.intel.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 25/25] KVM: x86: Add CPUID bits missing from
 KVM_GET_SUPPORTED_CPUID
Message-ID: <ZryLE+wNxhYHpyIP@chao-email>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-26-rick.p.edgecombe@intel.com>
 <ZrtEvEh4UJ6ZbPq5@chao-email>
 <efc22d22-9cb6-41f7-a703-e96cbaf0aca7@intel.com>
 <Zrv+uHq2/mm4H58x@chao-email>
 <ZrwFWiSQc6pRHrCG@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZrwFWiSQc6pRHrCG@google.com>
X-ClientProxiedBy: SG2P153CA0038.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::7)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA1PR11MB5826:EE_
X-MS-Office365-Filtering-Correlation-Id: 48e76aeb-3b28-472e-8db6-08dcbc4e6915
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?LEV+tHLstrsihVu/S79EMa15+z8ROfsfBN8Jndo1UYK4EHCwb3csyLUCYXGy?=
 =?us-ascii?Q?19y48LUYySnM5NOh1UluWiC67Iji4bre112VJOCpct74QonLnW5gcnU2NmrU?=
 =?us-ascii?Q?3fTTQaeGvRuIIfnQSIJsS3xfyT4XVjzctf/2l1NhF3dlqh9wrEZnNnPwFAvU?=
 =?us-ascii?Q?n2XaTlfqV9BQ6+qd59LS04ucLhb6u5PhVzo6x2++g4Xvnl2tumB6LZuiRWF2?=
 =?us-ascii?Q?h9zmf4pNERj2rz7c6cugzMPsXmuO8F+XsMmep7U+jVYASy5Z53YO21H+pVAt?=
 =?us-ascii?Q?YmQAZQX/H7ChnGyhidB10O7inYD31k0wWt6vtezdmJ3Cs8nz6eZLaAeQ8URD?=
 =?us-ascii?Q?BW8e0QyXTHa7qqo52J2DiHSsFk7+620/ZV5UeMfX4smj/n6GGutqSoXE2ixl?=
 =?us-ascii?Q?mjlORd+XJsrX1XlPQSkoSloLW2nX/CLjACJNNiC8BXeL1m2l0G44jqN0iO1d?=
 =?us-ascii?Q?0qA20Gjbs0ynFukdLTkK1EDkSnxAomQvslCYZKZHzsqCAMis2uphXYYJkFb3?=
 =?us-ascii?Q?2XePv8hxzRQIZ6BJKfe957gzhAKr3M3fe53sEPYy6BOkGJG/V0w2fRpEXe6X?=
 =?us-ascii?Q?5/uwz+e63S7sqn91QQlLtGYVfnEE5qd+4UBTk55KQjKoL1usjjMIx8+KKR2z?=
 =?us-ascii?Q?nYG1a9K1/5WmbPuUGpPs5XiAktLdTwVEQVae405a6oGiXLi7m+QtYC4hyMNX?=
 =?us-ascii?Q?soMdrOA7+EFvxnwq4BDZaY0PDyS0XApYYD9EnCe5SK0xioZGjw/jXzlANl7X?=
 =?us-ascii?Q?AK6TxZ9tMs3L5WnCuJx5kZAV7Hcb+CNdGmg3fRpCrn1ETVnkomuAEXOT1W25?=
 =?us-ascii?Q?LEE3ePbwxMnNWhN2ZMRJzckBh0mI8ezNnqWH/vQLMhwPX/QbreosXu9QLM1u?=
 =?us-ascii?Q?ZP/DszHGcGIU7Xi8T3QEOyrZ9ow5c9qfJkEWtY7SSvIVt+zRR0EBCs/rXuHR?=
 =?us-ascii?Q?NE6SfwM/6dPI87dxVtzDKNA7LIRrq9JgEWMMXK5Uq/Q/P1UpG6QdgF+vF3Fm?=
 =?us-ascii?Q?mJ3ikPksSi+xsQeBU5G1y0tSyxRl57sXEAAKhJUNhaL24pg5naDHVHP6BLsH?=
 =?us-ascii?Q?VA0xCPRv0N9EdEmo/sR55AVGtXuoH5duJIgyusS+TU7EeYf3iXdPCYNgSJbV?=
 =?us-ascii?Q?63/S93vOm7qvUrfd/aye45YBsO+RDcIM5ZfovMpCBfye9PV+evewkFVbZDNo?=
 =?us-ascii?Q?3yavpMfB5k1bRqXqyMx3ksHLv9WINM7bQcXd4wIFmLIORwCum5PDmWhI3Io4?=
 =?us-ascii?Q?brpAuQsMHAm8E+zInvLki9pECRyH+kuHS4+6vXXpLjUZ1NQoy5LtjYOco33a?=
 =?us-ascii?Q?yXw77ErcWSJY+9+RveZnrv4nDVI6wDyCXZz/a/JipH6/Pg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ev+HWKWT7I9L1JvCz97WbqMi3NxDivoOiR7os1nyZRTNVK0SZ9EvBrAE5hhM?=
 =?us-ascii?Q?OvlNJfJW3sJFFJr8rukChI2WhrXNiW0NdOcIdM8SHOQb5NY3mFCDXQJp59e1?=
 =?us-ascii?Q?THRsC22ILMKl95Obd6eeSwFMuTu3vaKh7cfhDdQrsEwirjJ0Ub6GH+by8lNr?=
 =?us-ascii?Q?5i9v/ciENC79BRXI7S8crMmPraVay5I4yHKCBfyVWpxm6R2nvg/yAaHfg5u0?=
 =?us-ascii?Q?YPtl/drmupqNm52r4A+uzvdDt4kMPGB+PIVh1M+5U2VOOdTEMyorZFkAOipc?=
 =?us-ascii?Q?q5ujyLOiZhGYO0EojidrV+xudhJQtW1r4FgqMQ7v8WjWFQC3MYJgDm1vLFbY?=
 =?us-ascii?Q?vEUh9ng7Y8s7dVtlAbq856QOu3w+QSu+l4qdqlJagmQmDo9DPSMNvUUFcY4q?=
 =?us-ascii?Q?FJ6nnxgoHLJd1pq935pEpg4BtLcE/cTkWZuPvwb6ZWzMIVEyQg9JhNz3cixv?=
 =?us-ascii?Q?ishpROHZgCNkXDwwa5bjE/A+EvVn7YyZ0qibwNLw9rLLXW4ttT+MxGqjrkHn?=
 =?us-ascii?Q?l/xrF+bjcYO/aFSv+Lmkjg3SvXzc678Y9ZDNCPpD4jMmJgu6ec9lQIZ/tTuQ?=
 =?us-ascii?Q?k6RdT01NcrPjf/t92C9y4UqTVLnQAwtrYFPdCwkIEUOc+k2UEM3AzHoJQkFt?=
 =?us-ascii?Q?elrQnA5JR7xrNBFiZ+YS2lpT/mmpWx4Ag5RPesKQWhjyG317NKgSYgdW8owN?=
 =?us-ascii?Q?fU2CxVRiMfUuR82OXbx1vIADdC++htwyFnX17PckSjLERNp47786qjuSWhCj?=
 =?us-ascii?Q?puBoVSQx8agyCYxLOaJ4asnbrzKztbTd15FSVH3YpDRiNsAL5fIqvNziB+5d?=
 =?us-ascii?Q?Eky2JEEjrNPfGiJtV6gRpMkM1zY4GwrYj5bIQe/bzX4hQMwH3layzPHpxhNy?=
 =?us-ascii?Q?4jWlHe4/QCPpZ3NQWjC476HYlbYI+7VMVYOAac0JxHtjIapqXUvqAChVZkpF?=
 =?us-ascii?Q?xIosH4hFBtooBItgi0lm8ivVi+X7pBSfkQUC6A/p7dQhRV2EJwG465KA0T4w?=
 =?us-ascii?Q?w8y4gPX9GNHduT80gHSc11tHAhQb0B1JVwCkbRxy2jmj3w53h62DAGYEJPXt?=
 =?us-ascii?Q?Eby86pRErtTvdmwjGzCpr8YqdRI6NlOaODwX7URWUzU7ktwUBOTz6KRlnp66?=
 =?us-ascii?Q?NbZhGvBY2cpYhKqS8xgeebqjC9Ic8JSmq0y834WCfoAJTUh8OJOEBRWiVufa?=
 =?us-ascii?Q?B3EEJLymYXwbBDROFt4dIvgI4Ek6mVIsSHpUw2eLfhzSqNHfwuuOnAc11hvs?=
 =?us-ascii?Q?Uk++1/aKEnSSOgVSpaSrHiuyeFcpqaJpjoIYna0p6CkuBnxrfadUNZaG3I3k?=
 =?us-ascii?Q?DqJPvf9OiKhpT5/nWawitLqSEgUuFs6CMQ1IX0vYynZZlSJp/OKYdTaT5FQd?=
 =?us-ascii?Q?aljWR7ACeXNw5SSLYG48sh0NigVeEsmAswWVM6xnvc1DVxK2MIe+ux4+0d2I?=
 =?us-ascii?Q?db+gzf8b17cIwF+BaWpVytJmF1Rjir9uDtSWB04KAl4ECfk5SIM4LNUcEZ9V?=
 =?us-ascii?Q?joo0fTMzUb+9sVSZAK6y2WbVeA79gVtBhAHN98t8XF8PElEHt+U8rW6KapA1?=
 =?us-ascii?Q?WIIPAy7IT+WodddW26KpixBIgI4xPTl9BPLO30dN?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 48e76aeb-3b28-472e-8db6-08dcbc4e6915
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 10:46:53.7319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kyU9WX9AxJFYwOWoYNmDSHszyIIh/uhnJVpWP0RsDJ7cQ6Ef4z/0UhKzvQpd/hwIZYHvbViIcPU8TJXFbS4UEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5826
X-OriginatorOrg: intel.com

On Tue, Aug 13, 2024 at 06:16:10PM -0700, Sean Christopherson wrote:
>On Wed, Aug 14, 2024, Chao Gao wrote:
>> On Tue, Aug 13, 2024 at 11:14:31PM +0800, Xiaoyao Li wrote:
>> >On 8/13/2024 7:34 PM, Chao Gao wrote:
>> >> I think adding new fixed-1 bits is fine as long as they don't break KVM, i.e.,
>> >> KVM shouldn't need to take any action for the new fixed-1 bits, like
>> >> saving/restoring more host CPU states across TD-enter/exit or emulating
>> >> CPUID/MSR accesses from guests
>> >
>> >I disagree. Adding new fixed-1 bits in a newer TDX module can lead to a
>> >different TD with same cpu model.
>> 
>> The new TDX module simply doesn't support old CPU models.
>
>What happens if the new TDX module is needed to fix a security issue?  Or if a
>customer wants to support a heterogenous migration pool, and older (physical)
>CPUs don't support the feature?  Or if a customer wants to continue hosting
>existing VM shapes on newer hardware?
>
>> QEMU can report an error and define a new CPU model that works with the TDX
>> module. Sometimes, CPUs may drop features;
>
>Very, very rarely.  And when it does happen, there are years of warning before
>the features are dropped.
>
>> this may cause KVM to not support some features and in turn some old CPU
>> models having those features cannot be supported.  is it a requirement for
>> TDX modules alone that old CPU models must always be supported?
>
>Not a hard requirement, but a pretty firm one.  There needs to be sane, reasonable
>behavior, or we're going to have problems.

OK. So, the expectation is the TDX module should avoid adding new fixed-1 bits.

I suppose this also applies to "native" CPUID bits, which are not configurable
and simply reflected as native values to TDs.

One scenario where "fixed-1" bits can help is: we discover a security issue and
release a microcode update to expose a feature indicating which CPUs are
vulnerable. if the TDX module allows the VMM to configure the feature as 0
(i.e., not vulnerable) on vulnerable CPUs, a TD might incorrectly assume it's
not vulnerable, creating a security issue.

I think in above case, the TDX module has to add a "fixed-1" bit. An example of
such a feature is RRSBA in the IA32_ARCH_CAPABILITIES MSR.

