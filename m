Return-Path: <kvm+bounces-40013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A672FA4DB6F
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 11:53:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 49ABC189B325
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 10:53:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F4561FCF60;
	Tue,  4 Mar 2025 10:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cKFBuNz0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484D31F5834;
	Tue,  4 Mar 2025 10:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741085566; cv=fail; b=Vd81wDlM3LH1GqLHxprwzu8iAFpMHpvwoaHP3/yASFC78o6Pja5DKF75V0FQ35Y/p+u/eNPEcGCTVyK6IQLtKmZUNG7GxOC1FVIz/kyyJA5LcwrznLuu0aDc6u7S72vQr7RymDR6PnFQWXeeG7UBW4ZIrjH95ecKxB5RqGqO+Ik=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741085566; c=relaxed/simple;
	bh=eehEVfGm0chNIFkOUW4Hrl5Cu7QnV0gCXgh2GZeuS8E=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hl9FmeJd3qmM3ftstpjhaSBqJ6wNFACm1Y4Igb5x3J5wOzDqiWShmDq2YiRn///nch0Ca2mYkgciRAiT6lEEZWJ5cYGQ+tUiwyeE3k9fWUQcWhLjO2mXTuVir9oH65fLZfOyUDSQy7njodak74mEvaNwZ6hdonkhpCcGXH/9mC8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cKFBuNz0; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741085566; x=1772621566;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=eehEVfGm0chNIFkOUW4Hrl5Cu7QnV0gCXgh2GZeuS8E=;
  b=cKFBuNz0Ej6Z8XSCQADXHivTNgYDik1AqzlZRGtIWPqAbJDDTIQv9qaH
   qI816qYexPg5Xkl/OrCpU+o9nDSbl4WFDadtN4k8NBIEfnknwdJKCAVy9
   mxAU5EIt4IggA0f1F/nIO/lLuqVCatelCgj0q2yis5DaLOdpesSLkCRBZ
   TxhU9/GsiwilzaGBMZXJ4/GJgEVYdLiUYkPIUIcgxCJoWf4qePcZpO61K
   zwjNydJSbjhmH0iZ+3997KEmvoAEbhKy7mm5pr07wx0vUlww8GDNJhZW2
   rAl+8+jKxuWbquZPo0NVqa5btcq8pKfpz0+I+P9TpTPZyfgLehU73ILmQ
   g==;
X-CSE-ConnectionGUID: cHrR9JrURNeIFf9MzEAykg==
X-CSE-MsgGUID: iNcVVjmuRiiu04ZPCWQf7A==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="53391779"
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="53391779"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 02:52:44 -0800
X-CSE-ConnectionGUID: wGp4EqN8QPuE1CLtgmewhQ==
X-CSE-MsgGUID: fy66p+IjT/m3tnFSrbOADg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="119029116"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 02:52:43 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 4 Mar 2025 02:52:42 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 4 Mar 2025 02:52:42 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 4 Mar 2025 02:52:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wMqzuhgo5+uu8vzAyL01Ln1S2WR09jg/rUBJNs1y3Y5LBDBrYPwf9NdcsDYlrlCfLwvwp6OC184SmpsGb2U/GoYa0zu3NKD3/bLb6lUsaoXqJPCkEO3c2cPS3IuvM9X2rPZIYlEJqCgyMlraBTbgqjiJ7Kzhvj2+r3xvxNZ1OGb7E/aixiRLoyKMiwzNgsHrhkKgv9S41DKt2xxoJ5NCt7umT7y/uy1egbJC1yuPQw9beR90l2DvxnpOBy6hKrZrb5DupxKGTgciEck30WkbAqOLSyI/zfPrJ71UhOKVYP3Dq0O9FUx22DtfFOzr9fgm/xn6yJDfwGco8iySRGnoiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gFxgP7ob9HX+UGktvj/tDu5La9nywypHKh7vqFnXrz0=;
 b=rkddboJUztqHr7q1/I/FoBT/IO/xn9p+7HbYd3WzPKfi2D+S/ZXm3DjJflr3Y4ml4XLXqVg7Ibw1i2z/vdyAJYdFWJlJrnrMBUYL201xd5ujnc87ORWa6t/FuC/abbXekixr5Cs4A41Gl87tmCLuIK8zju95h1EF0AhhC0g7SRL/b5h/s1dXMA2ZH5Yf5bvZs/4BQ/AE3UbpemY+sjM1f08pXTD8PyC2719iKXHXLwxsJdXrp/FjiBLm1UaRZFICX1vb+i43ZAsVUGHPISPppLhtNqyFK7Asg7N3qeZSiAteOqCpVOaepPeL1senc6c8X2qSmXMo0C13DSwfpaVrmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH3PR11MB7940.namprd11.prod.outlook.com (2603:10b6:610:130::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.26; Tue, 4 Mar
 2025 10:52:40 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8511.017; Tue, 4 Mar 2025
 10:52:40 +0000
Date: Tue, 4 Mar 2025 18:51:20 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<xiaoyao.li@intel.com>, <seanjc@google.com>
Subject: Re: [PATCH v3 5/6] KVM: x86: remove shadow_memtype_mask
Message-ID: <Z8bbKCICpzBKyVBT@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250304060647.2903469-1-pbonzini@redhat.com>
 <20250304060647.2903469-6-pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250304060647.2903469-6-pbonzini@redhat.com>
X-ClientProxiedBy: SG2PR02CA0013.apcprd02.prod.outlook.com
 (2603:1096:3:17::25) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH3PR11MB7940:EE_
X-MS-Office365-Filtering-Correlation-Id: eba4d7bb-1a08-4337-17c5-08dd5b0aaf68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?w6/oVnJK9lmRd8Pa0hkg5wrqWsWIFItNbIcfrpPV9P9jCSKIJvBdB8alN5Aa?=
 =?us-ascii?Q?frH/htTe9FtMgW8lCBaWunmwOUt0I6I8Z8hlxeN8hznEnv/knS9d+DzjIDW6?=
 =?us-ascii?Q?+CgqRDD9x1SF0V4fN/FjBW+HHMv7FM7uaDfE4MEzEsZETj2k4tTtu4nKyx4U?=
 =?us-ascii?Q?HF7Ur+a5H1OBS3OB/W9lWs/cywL8Zhjuf2e3sKrgpahOBkr94ZmZaFpDAXz6?=
 =?us-ascii?Q?EIl27opLIda5E9UD+zSZVnKD0XK/f0OOBC6FP5E7JWtj0qY6xYdmCMbqmm5w?=
 =?us-ascii?Q?ZKEVpWH4fdWPtVMz9lv86ckbr6tKGkdjOZGN+/PHp8uyYeJdG/EeFr2ep+7M?=
 =?us-ascii?Q?kStFl10XW/TS+3ykyH+KCKCpTvgu/42GKkMbjgMx3jmaTBJxfLEBIJSrpU3R?=
 =?us-ascii?Q?ufwUwjuqYwSbY6tBUA+9OB1ePcMLSWb0pZNT/3w5iSepyOT83DN/Ocuk2Sgq?=
 =?us-ascii?Q?M+bsq6CfBRRVcRzbN4Cz4wLmB3qWbjbgJDppuin5XyJQ7AYCh+MkxBgz6+cj?=
 =?us-ascii?Q?1pOxMKodP5r/dwg5cOxSwymVUxx8tBAxLiYt3dE1IL/b8pFVA4+VgFsnTFgy?=
 =?us-ascii?Q?zQsrKNBXsIcJtGIU0cehwHbxOe4MuhlLjdVawaUWelm/JUhnVGXpc39sthyR?=
 =?us-ascii?Q?gXsw7iBOrC+CQ39i8Ub/34I83uCuWjDfNWSqOh4v4FjeEE/KcGUrOLukSiOw?=
 =?us-ascii?Q?XL3hiRxvprki2b6Gg2s2otr9tMPKln/7/AVrsdUlm5yf76Hgb6ISeg1j+gj7?=
 =?us-ascii?Q?jh2dmJb2hYHAex7hcqAb5XIpZLUGdlRKNMhg4nXsnnJLE4hl4W6ol/UHULaC?=
 =?us-ascii?Q?kmKyFL/HohjXmbyj0EgutOgDBobmTwRNWlDmf/fJPXotmySe/9TOFIcJL6qc?=
 =?us-ascii?Q?YDMLXYsF5Xq+HlMX7rHh5nH9Ufa1V2QCS+YGzH7gs3UnPSat7jyP5BaUJh9E?=
 =?us-ascii?Q?t43OcXcKdcsyKoluE9HOcHf7CFrYJfRWZRm09jzUcWcf5H86OMQbGLuTt+Du?=
 =?us-ascii?Q?I2nzHThT0qKnAWq9IJm2UVdLY/KcWZ4iqxJXt/Z85f44tZ7tqvL3wDOXo5Ip?=
 =?us-ascii?Q?d8uUhYur0S5IuSbE3OW1Al5dvzYXeYEUGX52gaUNR/lGXBTodFaMRxg5FDPG?=
 =?us-ascii?Q?Va1fB8ucaA7SVA1HcE6Y4iYmznTibrTj9R2J4IISnX/qB04NG9ecW7uTNyUm?=
 =?us-ascii?Q?xzmu9Ea854+suHetQjV1lEHDmrLqWGoG+zvAy6CHHV+IOYtZ2o4idZtnxLp7?=
 =?us-ascii?Q?f2TQILqbvZ+YYzU6zNejuBQ5hddEwkcyIeXZArRUIExEuLlN1lD58UwSNiM+?=
 =?us-ascii?Q?eVjtkJynun+rqwXl0DMphvjDeii96yVRjMGTndslwAarYk2foycy9WZ+lMxN?=
 =?us-ascii?Q?ax6Pqhe0qj7EbOd5UzVTgEdTZ8nV?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+yFjLzVjENDhzYVzGOQqcgclbSYXFYvSajkaLbkIF55N0MLjfUMHqX70sKeC?=
 =?us-ascii?Q?z8s9t7jDLBlTZdBYaydevznreJ+XKQ/+JI+vwUBUG3zyOnYzxRYTQj2nG8/k?=
 =?us-ascii?Q?pLFjQId8+eD3UQ9NR883AuSRQjYCg8zVgaC4dN0jiW5sN0pDyWab2h1CbjKp?=
 =?us-ascii?Q?qqypLnBps5anRHpGkEgNdk3GW3pmyiEeoGNilvOeB9hfQJPU3F/0u7HoMzfS?=
 =?us-ascii?Q?ZlgRFs3OXbwBURe6DoUpNqtGplr67q3yIESC9YGQ/4aPLzRHKgOGWRaIVW4a?=
 =?us-ascii?Q?yB7JhrYaWGScN2egO+KENKck5pDDXqr0Th9+LzId+FIiskc2TfERoYJxtydI?=
 =?us-ascii?Q?r93P24TlNQOS9fl6UhoO5t69qo61dgIj68KdVI0Qd/ur4pcD2MLSAUyHDjkJ?=
 =?us-ascii?Q?xSN4ppNDivVz/JPKM32FxS1wlpvWT7M3aFfw6AjUQxWytqeYLEYxOjCFVHff?=
 =?us-ascii?Q?v+KEQAEOLBl6FtvEfLjHpLzbrQqmBRO02M3dDGjKqwqsPof2u1zyglmhEjcb?=
 =?us-ascii?Q?7zQ+QwLvEX4l3O2DYc0zeEcIOfjyl55OUW0TtdG1tdFDIshuwHTFcJ+Dodya?=
 =?us-ascii?Q?kD0ZZx7GI79+VJEj5aWJEvpiifsC7+tBdS+ZGbEhVHculrNfZi/fULMsnn//?=
 =?us-ascii?Q?CYNfryh9LsxxzOiBDdNAtqxMmHf6LwzC5rmteVGhW5/pZZg1PQNVY1OLmEVi?=
 =?us-ascii?Q?jiLJtWJKr93xyoCnCs5cIGz2WxY1Ffn3VrNK3E498Uh9in0TWCoLGVI6VF/x?=
 =?us-ascii?Q?2cDQ535p1uEVUf27RS9tHq4Qs1UYvKaNcyFcGOLXVXcQxh4aewHGRJuLKWbY?=
 =?us-ascii?Q?WLuj/vivsvty2SU2dTva8TXKBrj9/uqI+BeGsk622J79ZhgJoEeMiciMf2tA?=
 =?us-ascii?Q?Ifq+fyWlC1SVeYvcGu6Tfr6nwUOyqhb979I5JLqYVDsUnNA3vMhUDMG1His2?=
 =?us-ascii?Q?C+XhYCnstSYLe+LbDQ7ncGVIXOshSKxuxSMxIeRK4t46C0JnkX0fwGwBIg6P?=
 =?us-ascii?Q?oZLfbhzHRpCit5XiCutK08WMftdE/TGEnZ0YfvKxxFVrHZnUScxZ0ignTYjq?=
 =?us-ascii?Q?Hni5M+wZlzHZKAidrD2ZBa6rD8s3izs4dPyma1MX+ciFmieikCE5tmtkv6c0?=
 =?us-ascii?Q?ldBW2n2hgs7bJZ38B90q2vgr6ttnHnYoGPjp39pvvVdAQyeT2ZgbCkE9Epdh?=
 =?us-ascii?Q?VQiu4o5sTVZ/6Yl6qcZL0fXv8K9cHu1dK8gjdGXvCtGdHaQg68WlPnio3Qjc?=
 =?us-ascii?Q?8TVb+hn/qknYTGQmefCV/fGgf3wjdeAnbfDQObK2+vs2XH/RPNDQCAxY72GC?=
 =?us-ascii?Q?74BG0wkXjJ4ddXusB3ozInpdJNXSXKEUASo/gsMi96HPcn0voHeF4gRkZS/K?=
 =?us-ascii?Q?TWSYEDavu2zCBuFJ5Rf+F0BcNhWEhYMytV1hbaHLrogO5BZqDZSGFz19n4Rc?=
 =?us-ascii?Q?WBF3W6aHm9oIfk7OyH4NDbePQjT6Ad13jfnqvO7yJlCrDVxVtZlo9TbDo8VG?=
 =?us-ascii?Q?v6ZplQBrAI/ax4nW+dej8YNDX162INZLYwdnuUQ3FY9MvWkYnv3xHKQkMKj+?=
 =?us-ascii?Q?XQqRx2Di6PRGCX0n8zkRVXQK1FtwJrz4RSDJc/XN?=
X-MS-Exchange-CrossTenant-Network-Message-Id: eba4d7bb-1a08-4337-17c5-08dd5b0aaf68
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2025 10:52:40.8274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4jslR6SS0W48tPx/JbuJb2h0AGHFir3uLuAV0Vl+k1twEpaYVFM6SFj/Yar+HYDsWdlkWBE6bhFgrrTK6qO5+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7940
X-OriginatorOrg: intel.com

On Tue, Mar 04, 2025 at 01:06:46AM -0500, Paolo Bonzini wrote:
> The IGNORE_GUEST_PAT quirk is inapplicable, and thus always-disabled,
> if shadow_memtype_mask is zero.  As long as vmx_get_mt_mask is not
For shadow paging case, current KVM always ignores guest PAT, i.e., the quirk is
always-enabled.

However, this might be negligible, as non-coherent DMA is unlikely to function
well with shadow paging anyway, if I don't miss anything.

> called for the shadow paging case, there is no need to consult
> shadow_memtype_mask and it can be removed altogether.
... 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5b45fca3ddfa..8bf50cecc75c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13544,8 +13544,10 @@ static void kvm_noncoherent_dma_assignment_start_or_stop(struct kvm *kvm)
>  	 * due to toggling the "ignore PAT" bit.  Zap all SPTEs when the first
>  	 * (or last) non-coherent device is (un)registered to so that new SPTEs
>  	 * with the correct "ignore guest PAT" setting are created.
> +	 *
> +	 * If KVM always honors guest PAT, however, there is nothing to do.
>  	 */
> -	if (kvm_mmu_may_ignore_guest_pat(kvm))
> +	if (kvm_check_has_quirk(kvm, KVM_X86_QUIRK_IGNORE_GUEST_PAT))
>  		kvm_zap_gfn_range(kvm, gpa_to_gfn(0), gpa_to_gfn(~0ULL));
>  }
>  
> -- 
> 2.43.5
> 
> 

