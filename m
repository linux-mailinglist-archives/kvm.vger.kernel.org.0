Return-Path: <kvm+bounces-40122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94083A4F54F
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 04:21:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA6403AA96E
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 03:21:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C38EA1624EB;
	Wed,  5 Mar 2025 03:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D7Lgwl+K"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7672E3383;
	Wed,  5 Mar 2025 03:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741144880; cv=fail; b=N6TuTh/sWRPeEcWY/H4QFOn3+47Lk+AO4182iB85yxTFvWbr9XaG8Tah8TgXlKm7NTqoIhk0t9ImOFgmSihtYpnQwL+kXpAaXzrwRq79NVnEMlrmjyAZayAeaNGX4Mi9gBVu14nx8lGyY59yMIOQ5UvJMvdSsIAorGX3/TYnIdk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741144880; c=relaxed/simple;
	bh=Pa/PrDdb89W4LT1FeOK6U7f2k4mwWJLLvi8hLyMJXYI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bFRTl1k01H4cXhJBbxWULpbJO59hUksULb/xJ5C8t7xEcwf6e7DBE8WRmzosJnN955qyHk84YrKtAOVSC4ZSQgAlFYqVyPYtLfkYUTPtF/y7OKiEkvvkjZAUKNBpP4SFX6lERWfryknsxdoXmRR2697ecmda18/+P9i1UqBKcKw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D7Lgwl+K; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741144879; x=1772680879;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=Pa/PrDdb89W4LT1FeOK6U7f2k4mwWJLLvi8hLyMJXYI=;
  b=D7Lgwl+KHQAenl6AeCtpULoDHyXrFEIcAt9izF8cM5DxozDcNZG6kLZC
   bRFZwKj4rGey7XJ1qb3XqvFq5oTKdBbm1y6SL3LM8ts9rJm1tghGgEqvx
   +fxajyFX0F46WftSYIuDScE2kdZ4ZB9T5V5fBZJx4kX/zpskF5Jf1TPvZ
   Jczo47rwHFzlNNoNjQB8LXKyhGM2RRk7BI8Y/IZ5bhV6tMlq9MIB3efRF
   Iv9D48Had8/VnWRf/qiB2dz+tQwjbyGHFkHNHJwI3qJEQBy+c1np+Ngkn
   IvO89Zer7WyksyyqtVFE2vZXOyiUnZeQVWiIqhi/ZKy4U9eBwCHavisgo
   w==;
X-CSE-ConnectionGUID: 5G4+ko4LRDep+AndS3A6OA==
X-CSE-MsgGUID: p4oHTEdsTW+5ZBJhpELa2A==
X-IronPort-AV: E=McAfee;i="6700,10204,11363"; a="42338199"
X-IronPort-AV: E=Sophos;i="6.14,221,1736841600"; 
   d="scan'208";a="42338199"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 19:21:11 -0800
X-CSE-ConnectionGUID: EAVXJlQ7SAizZwQKzK+FqQ==
X-CSE-MsgGUID: DZXhdHyuR3C4jtLVkts7dw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,221,1736841600"; 
   d="scan'208";a="118566937"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 19:20:41 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 4 Mar 2025 19:20:40 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 4 Mar 2025 19:20:40 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.47) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 4 Mar 2025 19:20:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uEQqhl6gM55sS0bt3PID8wHIj7ejiXpFOSqILq2W6vJxgYFB1GGMNP61Fb8fUa8Qi1dEjWG+hFOxlDsWEvW9O/1+bzNFqsvh1aaENpguqclkO466xBwFf5/LR8Siu7J7Abbf3ZZ6xo8FjUcWUlqDkzxJqzHr9iZ/pq577DHrbevqd+UHJtHsMwc6lxlwXZPSyn3iE8+voLvraaWB2Cr6tvVF0AnCNfBaLaUAG7eg5y0Z/yUvlf8yFWJ8QROpf5e2zVq26y7M8O7pXCXSld3ck9HTRrnf3Bke/4w+2byytBko1Ku9kvV/3/OBLDS+NHDW4uz+VZRDN5qEboQtqG66kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ncHwyp39RD4qdBiV7XNIuk6eebte32xx4Xsz50+Pk7Q=;
 b=QgZzaEr0tbhNVt+0UmY0GDsAAgimMgMa6imN2fe4WNXpibESqF4pEkm+64EH5SJE2FcDuUkxFq1co3Akjkjz6Bl1fN2aFf1zmB67+PV0ozd9xK671ZsjhdPN/oKraV4/Y0+JWzwpeGVm6cYXWfNyfP/Q+nFYSDXErZT1muiJiK6+rdFLwoqfTFsraJuWkzoT9Tox2x5DczKNSvELwNHXEwf1r7zZZ9a78GxRPku1VUX6pCtHs5D9E0BS/hYc6q/Hl2HzR/3qVZvOPs5mIcZfVhQkCrP5pJou49qVW0NRyFzU3VHiIZq8+4V4zzVY1EzkCbo4nfnLZIgREqEtwpbY5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB8599.namprd11.prod.outlook.com (2603:10b6:510:2ff::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8489.29; Wed, 5 Mar 2025 03:20:35 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8511.017; Wed, 5 Mar 2025
 03:20:35 +0000
Date: Wed, 5 Mar 2025 11:19:13 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<xiaoyao.li@intel.com>, <seanjc@google.com>, Kevin Tian
	<kevin.tian@intel.com>
Subject: Re: [PATCH v3 4/6] KVM: x86: Introduce Intel specific quirk
 KVM_X86_QUIRK_IGNORE_GUEST_PAT
Message-ID: <Z8fCsVF1hu6yMv6Y@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250304060647.2903469-1-pbonzini@redhat.com>
 <20250304060647.2903469-5-pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250304060647.2903469-5-pbonzini@redhat.com>
X-ClientProxiedBy: SI2PR04CA0002.apcprd04.prod.outlook.com
 (2603:1096:4:197::17) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB8599:EE_
X-MS-Office365-Filtering-Correlation-Id: ef9b069a-a357-4c5e-224c-08dd5b94b1c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?+0dBqk7U2+4W3Gxf16DIARrPijprwV3ifJ3QtS+W6Ku4G4hFzffeiUtos5lF?=
 =?us-ascii?Q?yZT5DdEEM3vxPs+zowgPfPE1MDdxZSuvlNwLNH2MGZ8HsDP2/GAT30damWCK?=
 =?us-ascii?Q?818vODjx4XHFcDS93Mc2I2zUEpeZvd5wHJDL+kcuT7hhsNgGWfOVym72sk8C?=
 =?us-ascii?Q?J7G9JG7SMaUBHoUeRZCAwVj35/wX2v9oSdkLJZPV8Cjsrkz2k6EVTCI2biHu?=
 =?us-ascii?Q?nldHA8oaa+rRudHmPieDtBM2TDkxcsIZUuUB9BWb5qL4Z7i0dEo1yjVkLBl+?=
 =?us-ascii?Q?p/BsnnLSjYY7aHH4eF7q+1cGStB9zemrazSTqC7FJkWUI6Vbji6SkCrlIiDL?=
 =?us-ascii?Q?bTuSSIVvIceQr3IqUTxFeENQ5e0eCRwebp/EYArqLlLcLL7YE3/n8NjZg8oj?=
 =?us-ascii?Q?qrezLyODpd0JfCDGhxcDuKEw8+VqrCzYZF2lW7KaeeTDonpJITce59/q8oGj?=
 =?us-ascii?Q?wCo3i7Nm8Iio6fRRBoMIdDVEU2PMrzxRFDRI8E9S+Hmwrcd27tVnKPHX5gxp?=
 =?us-ascii?Q?AIgETvCwEYa9nUH0iVmey02P6Cfhw87kwD/cBYzoJ+uU3ASBQY4byOjVaHV0?=
 =?us-ascii?Q?R5+rSKVJGwZfr+/YbJnhZ7nlMLmYrCmqD7JN0MAMRIwrrHkrD5kNQcYIrzIY?=
 =?us-ascii?Q?ntmK4bAltAiXUstGaRFhFK+SjGo8vvHxPxZLC8TlJqYDIJa+Jx3tI0nZulnw?=
 =?us-ascii?Q?A++7D87I5NxZOKZq3slovIGPbNrP2kxE3tfXu3/6ufZcXO+3312AEeVa2wSg?=
 =?us-ascii?Q?jXhOcsoLHFsE2XP6TAJmUXYc6uZUSOM9CkffnR9JJPgsVj3RcZuffvZzPYb6?=
 =?us-ascii?Q?H2J8K++6dW60mU3vRX5hyiqN14wF7Lr/nslAL8tRqk21VnfuSZIjY0AZjRNF?=
 =?us-ascii?Q?TJbqUgfONxiq4KyVIhBZqM3SqZRYpML73IiNnUanwIQuTgQry2gdBalhzuep?=
 =?us-ascii?Q?AWL5Rrkzd28FnGvY4CjXZHFWbaznJ/tf0okG1PfU9n0siB5t7kIvbJT/E0i1?=
 =?us-ascii?Q?VaiNmt4zJUho7PBY0/VUorUjG5QDJlmYEHzP5wJXv9E4ocHjPvweOH61oNPh?=
 =?us-ascii?Q?RzD4XVCNS4gS1z1EpoGCCRURduC4Qr53SFELNjwhIy3jLH81bsR/QiEWr14/?=
 =?us-ascii?Q?x+O5VdRCewdH2jpq4UiRSedtMj2YYL9DpxejI511Xz1m1NYVh/woOP+LGg5D?=
 =?us-ascii?Q?bX1HTUXFOMCLDuErEl9JAi/1p5zVJ9U274InK0Q0JjPG2+vbjJE00sbs00WX?=
 =?us-ascii?Q?t39XwVhJsHWhr332haJ7nvvxJ8bngXyy/cMHqk1wPMaIMny4cnzZogxfqJBe?=
 =?us-ascii?Q?gnpoQNdd9vdSAPZBvs9USq8ef9o2iK/SYE3gtZ2SNHJ5dDnNdxyZtJag5zHA?=
 =?us-ascii?Q?+rcFEfohFioAe+mcRKpl5ch9dmVmUYNm4zuVzc+gq+VkTFXurg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+AknHBmQyQdgX6TakrKFktxMLVEzWR5oorrQDld9UWg8+4SYnA8waDDr9LJa?=
 =?us-ascii?Q?VmXKDsVIl0YQ2+Dn8IMxzMHbjvqfnUMD0QY4uK5XfigesVfWmu1epapoNI3z?=
 =?us-ascii?Q?AW/d5wevqnqbRqHp4alwAqGY+SjxzEudE/jlb1qfsXkBymCwO3w8QaCLk4IM?=
 =?us-ascii?Q?PBCsewegRbPjKt8jYdB7VAj9GHG32Tqf0rsmmHDhtsipp5E0Z7olwMdEci5k?=
 =?us-ascii?Q?3huJMAxC2/3b8mOvmg1U2ClENJwaY3P39v3xK051H+JHaOkNFDh6Rwbt3KLm?=
 =?us-ascii?Q?OMkeH8EkyyKCD9LRjtny1unHG3mGG8ksUrx5IawIaZz0/zKWoBTcC8pCWaKV?=
 =?us-ascii?Q?41LRhTjcpanUIghGuzJ93V6zDpea4U9/7dGFgmDlYpDKMQK7Z/E51jkTn+4u?=
 =?us-ascii?Q?6vLjBfpCP/IvzquwzvfH2wYYVwXH6AagWvNpXac3yV1mlFjVf3hE2slD7ETU?=
 =?us-ascii?Q?sSd9TogD225oYLjMkMeAgZTeffhxdKSGu9QER87ssgx4NoROSGjZ45RcAD1E?=
 =?us-ascii?Q?U2eucmzTdTALMtfxmhrCs4ZmjfIW0MnYX2o+SIpU+BvDoK4TTY/X4yM8Ps0h?=
 =?us-ascii?Q?FPcFVq0LtycuKP34ODIfBS1Ded32pnOtTsfmN/o9NvPhNph76syHRfKM8j+S?=
 =?us-ascii?Q?yCi1+XTMwPsLGlRK6oObTglFHRtse0yUekDpF3RmRX1M0IQUb3jh5bXoDKBi?=
 =?us-ascii?Q?wwtTtuiYcZksPi+SCtc8Bcw3cQ1UBjZvOS2VNVnzLIXIv5WhPP46yT/wHnFN?=
 =?us-ascii?Q?2wjKU/nLbCJDRwRB5S+OyjNInz+jF5Ix7q3jXKZ7vvwpNADhXTC+Ejfnvz/x?=
 =?us-ascii?Q?RmQhGJZA+KtUIUoHvTtM9aDcP6cqYL+ZLYyR9Th33EsNhDQ1NxCOGiXr7XzY?=
 =?us-ascii?Q?bAv+4J78IuKbukm+4LgdNyvC218FOAjMP4EZRu9zzxRitZd/dQnnnexyDN7M?=
 =?us-ascii?Q?7RHW1AVYEYuNQMKm07Hkpxol57E604paBKzbA5B9Vs1/L8X+TtwXodM7p+HB?=
 =?us-ascii?Q?dDYLR5NYQ6F0N6AaoiEiXQxP4P5yc3/CbtBBaXGrdKQXKN6q3mHC+X1ehs3M?=
 =?us-ascii?Q?z8ljLL+aOKFkAt1BslWKWt5b2+7sEY9P9Jx2upLNVxqnRKNJ0WVO9LN/1x6f?=
 =?us-ascii?Q?c75Rjb+Wf/UDEK+P45UFL7L5RWbaL0p00ENikG5EtOosokLTEUWNGJFZoe7n?=
 =?us-ascii?Q?tq1PZmofBW/ktpHCqbAOLYyt4zibaGJef+i/4w4xQKg7RO5ZQB0P1d0f6exp?=
 =?us-ascii?Q?p4pFodfU5GdaMb9pBXCPsUI8D93t86JWbmzN7Ew/ulVLzRoeeAbflVqccJOk?=
 =?us-ascii?Q?FeeC83VF/eyyNtLKiLxm3tFIMs+5e/vt1NpEdnA6wxtXH2wuH/xOtREFwtfn?=
 =?us-ascii?Q?cXa+a6jhivwfRMxhsVGO5JsLlTYPDh6UrCTaeqL+/R23BUhdOzllF0epz7TF?=
 =?us-ascii?Q?xeeG/5YF9990PIw2HvICk4nqQLV8ajuAtCoEmlCPitN9ailAS2PLQDMBg6QG?=
 =?us-ascii?Q?iKzHh4UR6ycA4pxOQVgLULh0dn4qLPH06Rde1WiHJv1/6WlS3ANtZAIQt1J0?=
 =?us-ascii?Q?n0buTrMHPs1/dGlyXAhPN8loQ7tLKAKVoo4Yj4Mk?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ef9b069a-a357-4c5e-224c-08dd5b94b1c6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2025 03:20:35.3360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Niah+WeD9F6f9QjoFz6MyYq9It/EQzaZPc3sirI+x7B6wkA1Sm0XQpexHddky8aViqmSXvex5aDBbdr9JQCpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8599
X-OriginatorOrg: intel.com

On Tue, Mar 04, 2025 at 01:06:45AM -0500, Paolo Bonzini wrote:
> From: Yan Zhao <yan.y.zhao@intel.com>
> 
> Introduce an Intel specific quirk KVM_X86_QUIRK_IGNORE_GUEST_PAT to have
> KVM ignore guest PAT when this quirk is enabled.
> 
> On AMD platforms, KVM always honors guest PAT.  On Intel however there are
> two issues.  First, KVM *cannot* honor guest PAT if CPU feature self-snoop
> is not supported. Second, UC access on certain Intel platforms can be very
> slow[1] and honoring guest PAT on those platforms may break some old
> guests that accidentally specify video RAM as UC. Those old guests may
> never expect the slowness since KVM always forces WB previously. See [2].
> 
> So, introduce a quirk that KVM can enable by default on all Intel platforms
> to avoid breaking old unmodifiable guests. Newer userspace can disable this
> quirk if it wishes KVM to honor guest PAT; disabling the quirk will fail
> if self-snoop is not supported, i.e. if KVM cannot obey the wish.
> 
> The quirk is a no-op on AMD and also if any assigned devices have
> non-coherent DMA.  This is not an issue, as KVM_X86_QUIRK_CD_NW_CLEARED is
> another example of a quirk that is sometimes automatically disabled.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Cc: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> Link: https://lore.kernel.org/all/Ztl9NWCOupNfVaCA@yzhao56-desk.sh.intel.com # [1]
> Link: https://lore.kernel.org/all/87jzfutmfc.fsf@redhat.com # [2]
> Message-ID: <20250224070946.31482-1-yan.y.zhao@intel.com>
> [Use supported_quirks/inapplicable_quirks to support both AMD and
>  no-self-snoop cases, as well as to remove the shadow_memtype_mask check
>  from kvm_mmu_may_ignore_guest_pat(). - Paolo]
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  Documentation/virt/kvm/api.rst  | 22 ++++++++++++++++++
>  arch/x86/include/asm/kvm_host.h |  6 +++--
>  arch/x86/include/uapi/asm/kvm.h |  1 +
>  arch/x86/kvm/mmu.h              |  2 +-
>  arch/x86/kvm/mmu/mmu.c          | 10 ++++----
>  arch/x86/kvm/vmx/vmx.c          | 41 +++++++++++++++++++++++++++------
>  arch/x86/kvm/x86.c              |  2 +-
>  7 files changed, 69 insertions(+), 15 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 2d75edc9db4f..452439b605af 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -8157,6 +8157,28 @@ KVM_X86_QUIRK_STUFF_FEATURE_MSRS    By default, at vCPU creation, KVM sets the
>                                      and 0x489), as KVM does now allow them to
>                                      be set by userspace (KVM sets them based on
>                                      guest CPUID, for safety purposes).
> +
> +KVM_X86_QUIRK_IGNORE_GUEST_PAT      By default, on Intel platforms, KVM ignores
> +                                    guest PAT and forces the effective memory
> +                                    type to WB in EPT.  The quirk is not available
> +                                    on Intel platforms which are incapable of
> +                                    safely honoring guest PAT (i.e., without CPU
> +                                    self-snoop, KVM always ignores guest PAT and
> +                                    forces effective memory type to WB).  It is
Not sure if it's necessary to add something like:
The quirk is also not available on Intel platforms which do not enable EPT
(i.e., in the shadow paging case, KVM always ignores guest PAT).

> +                                    also ignored on AMD platforms or, on Intel,
> +                                    when a VM has non-coherent DMA devices
> +                                    assigned; KVM always honors guest PAT in
> +                                    such case. The quirk is needed to avoid
> +                                    slowdowns on certain Intel Xeon platforms
> +                                    (e.g. ICX, SPR) where self-snoop feature is
> +                                    supported but UC is slow enough to cause
> +                                    issues with some older guests that use
> +                                    UC instead of WC to map the video RAM.
> +                                    Userspace can disable the quirk to honor
> +                                    guest PAT if it knows that there is no such
> +                                    guest software, for example if it does not
> +                                    expose a bochs graphics device (which is
> +                                    known to have had a buggy driver).
>  =================================== ============================================
>  
>  7.32 KVM_CAP_MAX_VCPU_ID
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index a4f213d235dd..9b9dde476f3c 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2418,10 +2418,12 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
>  	 KVM_X86_QUIRK_FIX_HYPERCALL_INSN |	\
>  	 KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS |	\
>  	 KVM_X86_QUIRK_SLOT_ZAP_ALL |		\
> -	 KVM_X86_QUIRK_STUFF_FEATURE_MSRS)
> +	 KVM_X86_QUIRK_STUFF_FEATURE_MSRS |	\
> +	 KVM_X86_QUIRK_IGNORE_GUEST_PAT)
>  
>  #define KVM_X86_CONDITIONAL_QUIRKS		\
> -	 KVM_X86_QUIRK_CD_NW_CLEARED
> +	(KVM_X86_QUIRK_CD_NW_CLEARED |		\
> +	 KVM_X86_QUIRK_IGNORE_GUEST_PAT)
>  
>  /*
>   * KVM previously used a u32 field in kvm_run to indicate the hypercall was
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 89cc7a18ef45..dc4d6428dd02 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -441,6 +441,7 @@ struct kvm_sync_regs {
>  #define KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS	(1 << 6)
>  #define KVM_X86_QUIRK_SLOT_ZAP_ALL		(1 << 7)
>  #define KVM_X86_QUIRK_STUFF_FEATURE_MSRS	(1 << 8)
> +#define KVM_X86_QUIRK_IGNORE_GUEST_PAT		(1 << 9)
>  
>  #define KVM_STATE_NESTED_FORMAT_VMX	0
>  #define KVM_STATE_NESTED_FORMAT_SVM	1
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 47e64a3c4ce3..f999c15d8d3e 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -232,7 +232,7 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  	return -(u32)fault & errcode;
>  }
>  
> -bool kvm_mmu_may_ignore_guest_pat(void);
> +bool kvm_mmu_may_ignore_guest_pat(struct kvm *kvm);
>  
>  int kvm_mmu_post_init_vm(struct kvm *kvm);
>  void kvm_mmu_pre_destroy_vm(struct kvm *kvm);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e6eb3a262f8d..9d6294f76d19 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4663,17 +4663,19 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
>  }
>  #endif
>  
> -bool kvm_mmu_may_ignore_guest_pat(void)
> +bool kvm_mmu_may_ignore_guest_pat(struct kvm *kvm)
>  {
>  	/*
>  	 * When EPT is enabled (shadow_memtype_mask is non-zero), and the VM
>  	 * has non-coherent DMA (DMA doesn't snoop CPU caches), KVM's ABI is to
>  	 * honor the memtype from the guest's PAT so that guest accesses to
>  	 * memory that is DMA'd aren't cached against the guest's wishes.  As a
> -	 * result, KVM _may_ ignore guest PAT, whereas without non-coherent DMA,
> -	 * KVM _always_ ignores guest PAT (when EPT is enabled).
> +	 * result, KVM _may_ ignore guest PAT, whereas without non-coherent DMA.
> +	 * KVM _always_ ignores guest PAT, when EPT is enabled and when quirk
> +	 * KVM_X86_QUIRK_IGNORE_GUEST_PAT is enabled or the CPU lacks the
> +	 * ability to safely honor guest PAT.
>  	 */
> -	return shadow_memtype_mask;
> +	return kvm_check_has_quirk(kvm, KVM_X86_QUIRK_IGNORE_GUEST_PAT);
This changes the original logic for shadow paging.
But maybe it's benign as the point in [1].
[1] https://lore.kernel.org/all/Z8bbKCICpzBKyVBT@yzhao56-desk.sh.intel.com/

>  }
>  
>  int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 486fbdb4365c..719e79712339 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7599,6 +7599,17 @@ int vmx_vm_init(struct kvm *kvm)
>  	return 0;
>  }
>  
> +static inline bool vmx_ignore_guest_pat(struct kvm *kvm)
> +{
> +	/*
> +	 * Non-coherent DMA devices need the guest to flush CPU properly.
> +	 * In that case it is not possible to map all guest RAM as WB, so
> +	 * always trust guest PAT.
> +	 */
> +	return !kvm_arch_has_noncoherent_dma(kvm) &&
> +	       kvm_check_has_quirk(kvm, KVM_X86_QUIRK_IGNORE_GUEST_PAT);
> +}
> +
>  u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
>  {
>  	/*
> @@ -7608,13 +7619,8 @@ u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
>  	if (is_mmio)
>  		return MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;
>  
> -	/*
> -	 * Force WB and ignore guest PAT if the VM does NOT have a non-coherent
> -	 * device attached.  Letting the guest control memory types on Intel
> -	 * CPUs may result in unexpected behavior, and so KVM's ABI is to trust
> -	 * the guest to behave only as a last resort.
> -	 */
> -	if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
> +	/* Force WB if ignoring guest PAT */
> +	if (vmx_ignore_guest_pat(vcpu->kvm))
>  		return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
>  
>  	return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT);
> @@ -8506,6 +8512,27 @@ __init int vmx_hardware_setup(void)
>  
>  	kvm_set_posted_intr_wakeup_handler(pi_wakeup_handler);
>  
> +	/*
> +	 * On Intel CPUs that lack self-snoop feature, letting the guest control
> +	 * memory types may result in unexpected behavior. So always ignore guest
> +	 * PAT on those CPUs and map VM as writeback, not allowing userspace to
> +	 * disable the quirk.
> +	 *
> +	 * On certain Intel CPUs (e.g. SPR, ICX), though self-snoop feature is
> +	 * supported, UC is slow enough to cause issues with some older guests (e.g.
> +	 * an old version of bochs driver uses ioremap() instead of ioremap_wc() to
> +	 * map the video RAM, causing wayland desktop to fail to get started
> +	 * correctly). To avoid breaking those older guests that rely on KVM to force
> +	 * memory type to WB, provide KVM_X86_QUIRK_IGNORE_GUEST_PAT to preserve the
> +	 * safer (for performance) default behavior.
> +	 *
> +	 * On top of this, non-coherent DMA devices need the guest to flush CPU
> +	 * caches properly.  This also requires honoring guest PAT, and is forced
> +	 * independent of the quirk in vmx_ignore_guest_pat().
> +	 */
> +	if (!static_cpu_has(X86_FEATURE_SELFSNOOP))
What about
	if (!static_cpu_has(X86_FEATURE_SELFSNOOP) || !enable_ept)
?

> +		kvm_caps.supported_quirks &= ~KVM_X86_QUIRK_IGNORE_GUEST_PAT;
> +       kvm_caps.inapplicable_quirks &= ~KVM_X86_QUIRK_IGNORE_GUEST_PAT;
>  	return r;
>  }
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 062c1b58b223..5b45fca3ddfa 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13545,7 +13545,7 @@ static void kvm_noncoherent_dma_assignment_start_or_stop(struct kvm *kvm)
>  	 * (or last) non-coherent device is (un)registered to so that new SPTEs
>  	 * with the correct "ignore guest PAT" setting are created.
>  	 */
> -	if (kvm_mmu_may_ignore_guest_pat())
> +	if (kvm_mmu_may_ignore_guest_pat(kvm))
>  		kvm_zap_gfn_range(kvm, gpa_to_gfn(0), gpa_to_gfn(~0ULL));
>  }
>  
> -- 
> 2.43.5
> 
> 

