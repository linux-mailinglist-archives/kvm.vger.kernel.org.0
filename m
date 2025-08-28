Return-Path: <kvm+bounces-56126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DB82B3A37F
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 17:07:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96A06A007EA
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 15:03:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7653233F9;
	Thu, 28 Aug 2025 15:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UjvKthhj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302223398A;
	Thu, 28 Aug 2025 15:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756393351; cv=fail; b=fyUReqLWltYdSkzuFPN5TYQdP0w2Jawf6eM1uLho0pCfL4Z91+q8B6XwQ7B4AEtkOCWrnSZhfNYsjywYbNl1+eoZDuA+R2Z3ADYWnI4rCNxKxt6/aTesDMI24E8KpXXlw/WtPKoBMjxDoAZU1dHUyPrey4NFytbVfGT+cMkavBM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756393351; c=relaxed/simple;
	bh=34Z3vfyYNhWBZ/vwhMlrhrb/fWEH3wPED6k+emJ16+g=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=uLBUbN9XWV0DxhTCr9AbmptCbnPjZPpVSXOjVUdbH/JD2GOgTnO1kh79PF5MN8hQoNAb976CRtcyhENhdDri4FzvV55WfOhDSTOMzhSitfXpAMWrqC0RVcjFdNGH1/T861TBTR8WUmNg15XyMPVXF1KmT2AqL8wpqyuCdTmcZv0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UjvKthhj; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756393351; x=1787929351;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=34Z3vfyYNhWBZ/vwhMlrhrb/fWEH3wPED6k+emJ16+g=;
  b=UjvKthhjKDEWFUC6TRttePk+MW+HLYKZ/RCtsn66yhI/IAWVuVxUoGQ2
   XRVoNC052+GhxkX2TWTsMTs58SKXDO8JIE7ims+/7dFiUmJhsddXjN6W3
   0l3nTCbHn1jLFJqi3ssfg7uVp3Sxd1FYx8smALbdbr3y4HE8/OpOGpfkY
   o7tC6/lOmtgBE6GcKOvVckauD49bH0Hb/SgG9YF3YQnexnGHZ740kCATr
   P9nZUORMYsoKRcP6QlbrTXwnJKyjACLm5JLPSnB32S4Fl5b6J6f1ZR7jM
   F3DRqCPYAZXhSYSWDNRsJU1u71HSGl8GCszIxH9dV48K1dEqsy6L8FC2c
   A==;
X-CSE-ConnectionGUID: x1yNEfD7Qhixk4Ox6loYcg==
X-CSE-MsgGUID: NzGD92NwQS2Svq+xhqgl8g==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="76115767"
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="76115767"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 08:02:30 -0700
X-CSE-ConnectionGUID: UCrHMXWiRSuenuowVEONIQ==
X-CSE-MsgGUID: IBXOtBI7Q3CR2zOYxV/zyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="170308846"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 08:02:21 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 08:02:17 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 08:02:17 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.58)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 08:02:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c8axt4YGcAMaXcdoCx1vql5BW7lMofmxzBVkZEenjnnlnZeDeMAZwbxnpxGm7zbSshPy2xGM1GvdyHIiOLnzdX9gqI9i/uy2hglyp9rfwK+JNLXQyFzywr8e6rswX6eNSyUiKMlr7tfJxPD87Kl25f68WskRyj7hp9ELjiwsIN+94f3x2QYxJMsr8pngB3tZ50hkIiResJYpgEbcEA8bhmAlnKjFamWfOcEit4H7W2XOL8sUK9Sbo6+/VOclmIrx3EenxyRR7apIvUzavVds/N94BQ6EPW/HDdu309lDvppesYSMZcy08zc3VOiud9LsZdUkuYMg92bB/IseQ53+uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JbV0lWhLTe0pPLeE2q0CDwuqjLA3w2Z7WAZx71s14ac=;
 b=c8DroS2RVppYY1Bu2llIA6YuGiB6rAE7UrjxzmnROVTHjd8f0RCI/U/hM/lg7taS69yFKWzquvdrCtrrpGFhm5YBszEqie5jFhZJQp2SNr4F51vVJwESjU3nnk/Ez5eL8VgcR2JzWiTC0/kjG3feawYgvTqGBoFkMp34CUKSZuPJmjJewzW8hBdKpowxNFtUCJvghlxon46c3NFrLWQ3xMQ+Ts6klBU/cCISIuzTBXeMkJ9ji/X31mv/ySVe+04R4KheO2dL52MPTsrOggguTCwffI3E2oRSHr2mmqJOalIY3QxmT6N4ElHijh6zPCE+3Oqn8u0hTWTlJ5knVgSVfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by PH0PR11MB5111.namprd11.prod.outlook.com
 (2603:10b6:510:3c::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.13; Thu, 28 Aug
 2025 15:02:07 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa%7]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 15:02:07 +0000
Date: Thu, 28 Aug 2025 10:03:54 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Michael Roth
	<michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, Ira Weiny
	<ira.weiny@intel.com>, Vishal Annapurve <vannapurve@google.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>
Subject: Re: [RFC PATCH 06/12] KVM: TDX: Return -EIO, not -EINVAL, on a
 KVM_BUG_ON() condition
Message-ID: <68b06fda5448f_2114829480@iweiny-mobl.notmuch>
References: <20250827000522.4022426-1-seanjc@google.com>
 <20250827000522.4022426-7-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250827000522.4022426-7-seanjc@google.com>
X-ClientProxiedBy: MW4PR03CA0261.namprd03.prod.outlook.com
 (2603:10b6:303:b4::26) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|PH0PR11MB5111:EE_
X-MS-Office365-Filtering-Correlation-Id: e2897c02-bdc3-45cf-f405-08dde643db67
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?JjPUzMK0woiBzdk4UNjuof3J3XBdgVwHk3S5EXb4xKMdv8J4fnYCZJ7jOZJg?=
 =?us-ascii?Q?GRiYu28b+nkQC6G6zxXlDqAJw6/Zy1bSaXwKm52UZzJbuBms7SecYw3/6Xpk?=
 =?us-ascii?Q?G2HiKojtCDRsvpR+gFG7qCQXx0/TaznM3LF+Rpacpp+I34OgpGu6/vUUFHpM?=
 =?us-ascii?Q?UY2Iif5byNVjM2zumHNHH5DH3xy0fttXgVgaHdr/dL6hhLkfqF4VICuYmtCf?=
 =?us-ascii?Q?pSf8uCKs6Ps0wLbUfrD84HNEK7oT8wdktoGMc/0LEoaC1sK84ICs7MiQkkJs?=
 =?us-ascii?Q?IQzlL0On7/3dXXzQBfWtruSmvyn7AA5v5JhNul1Gapiva3iPXiqeRJAouU0i?=
 =?us-ascii?Q?zqtXkyly4b9D1ctzllZ7CvswEyUuzL5d9DubABLMiIuBr5IhOvWHDYWihLD+?=
 =?us-ascii?Q?7XztpQOBxRnKia4QN3yvuyHCrjdk9EhGXhAl3OLDd/739J2weguB5ZjEVY+b?=
 =?us-ascii?Q?rLYk9ow98stNYKyv0BWQzbRx6dYszBWVaYMjJ2UbXdMJ9a5AkD0XwSoZrKlb?=
 =?us-ascii?Q?VsnCkO2tG4rnKRIbYx32HbaNwvEnw//2kd3J5fJ/7LlVs5CklLySNIlKARl8?=
 =?us-ascii?Q?874y7tYCxZKHgAfXyG/ymDbkcD+wzgaKagewrrJbtraN9tPoynLJFZKjFzaI?=
 =?us-ascii?Q?ifkmz0OjX6JQ3pVuGKNPeVP1lehwag14hlZ1nnPd5mkFaJ+YsAQngX+KiVwo?=
 =?us-ascii?Q?MMk3jC1Rmm6ZAq1WHi8N6tY7mLWyfPw/8Z4nY/RDJ6xB7XsuTaRFqcXn8VzC?=
 =?us-ascii?Q?q0c2JV1wZAm5Z0+G6axMjTYNnvF14onI0hWu+4nLZUUU3cFNzZALxkFFxE2w?=
 =?us-ascii?Q?Spwg6AVeBx+APOcRGgIjIlt9Gm5QdTRqU6Ad696z0ZQ09ypa988OE8tGXSd9?=
 =?us-ascii?Q?fM12xNLUZgtU+R4wOrfAt+6Fjmwqhz/QS4zAJx+b2NY18gpK4DVfnYiNB0Ep?=
 =?us-ascii?Q?i/GaKuw3rtEaWiCJ1eqhcBB6pAqKiA1alY4dLHMYIR7ve5aPfCPPbcAkfePe?=
 =?us-ascii?Q?MbJBOT7GY3XEhSSfu+IVZkyKwnvbobkAjVr+Rho/rcpdWP6ASy6EMV2t0KI2?=
 =?us-ascii?Q?bc7+n1Epvw8a6SZCjQIJqyfqZQTFdMvAY0d6euA0B05yxM7jxj0GM9hNXTkv?=
 =?us-ascii?Q?mdaJxlz6aTZEbeevkUmd1eKoz1/iox4r4K+xXdHL/AqR5J76w2yt7EQVRQFB?=
 =?us-ascii?Q?eYwz7BFkFlUg4P5UtZVLf3fvWbddjNgUtQJBSxprZREm5SteMvNxS6CUIIGn?=
 =?us-ascii?Q?+tOnI2hobzFnQbw7o0GAR/9TnYaeV22TPrjXs9Qrcl+uBXuEoznctv6rWaXE?=
 =?us-ascii?Q?i4tkyae2FGoiEYPjIc2sQ0o9d3wvW/LrKS80iKNqUidfR8DzWXvzP/XGLbJt?=
 =?us-ascii?Q?yBeADEtH3iafrGZnQohRZF4YcY5hAunUEs5pM7PkgQ2fTx/tnw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2TJTBX8ABgcQwBtM0vdbbcQxZWh7K4FLwMNG7w/rgvMcqjyAxJu/mLGSU0yI?=
 =?us-ascii?Q?+VqEcc5H7mQokUw517/w7zkL6IZy1sYezJBLwD9zRrLX0c7L/bR3o7b/+6TF?=
 =?us-ascii?Q?+YDzyPL0u0RuABXmuSKlIA8qlWSnOm7Cn1Bl15Ep3LxOi6anOEMprgp5/h9j?=
 =?us-ascii?Q?zqsHcoPkjNl9qkyzvk0WDauZ4TyWq2lLab27xbrKn4UTJo0paS5Q+4+eyupq?=
 =?us-ascii?Q?nGyjx2go3mcRWBF4XAWQhPn+yHsXLKQ5H9GZiqeTo+aCs+C3LTNBasOOPESx?=
 =?us-ascii?Q?uE2ugrbZRU0nJaCfmg5SSF75qxTg9J+Ffh7aDXm5xHSwIHpXndz+62eCyj0i?=
 =?us-ascii?Q?uBucUXuvJuaEOQPHX717bRnGKCFLhooFUzXdF0gjCODXiAOErZIWkv0ELbmD?=
 =?us-ascii?Q?CogEHbuoncAlhC1lXWId3KlCP/1CJPUr2HmiHcfQ2bpbQN4kFUWT3GXJp58G?=
 =?us-ascii?Q?EovP5p3qiMCuX1lZJQVT6lHZsFis/KVC23+he1rrWSQSkSx8OkXB7cD0m02D?=
 =?us-ascii?Q?U5QLEipoCkNi5dHzQHciE8o8fRmT4HaJNPhfaWfGBuiICYgwWtJyMbzOjrK/?=
 =?us-ascii?Q?Xgb5bPCxb2Vx1e2Fdjxb3Vxgs87P8VTa1zNULEIlFo0Xl6YCxQ8lqfowyH+E?=
 =?us-ascii?Q?JWa+CksJR/Ml/wNbUV0lgzYnAxNIGqJBL93NZVL1F/dL9NcAfm9EcIlABfEg?=
 =?us-ascii?Q?Y+m4NN+5voYLmSE9Rbi1qQ7EWExGAh9fN3ST4+9/nMK4RoafNBKZ0TeKS9CB?=
 =?us-ascii?Q?UTyqaFF4xuBm0LqZp2IkvuHi6YUkAGiKIcJRGtiEX8fAm3FOaj3vqQr0qXJ8?=
 =?us-ascii?Q?7fxjESzHBeZFHPXiG98uf1KYY5PPkhObDaRw6XjTp4lvrZLp1YkuS2v8LBn5?=
 =?us-ascii?Q?z6Mz2UxbfFfXslutXG2IokfGS59PAhk5F+22yF7PmNwRaeE/wp7WQp2fbZhj?=
 =?us-ascii?Q?rCqSsvVoM8mgBNE0dpHO084qKT/k3zFiFk+Rp9VVW6jAlk7f4XK0T1bQPBu1?=
 =?us-ascii?Q?FRcSLP8WIn3dsKn9F0EM9sqqVBIi1rgw8Pc/2W8LMB22VXdQaeJevQwOGJr8?=
 =?us-ascii?Q?584fIA7Y7d6nmqNn6sZBisHJF+k1HhKdotO0dCKAZf5G5F2SAJPmmaJbGaIX?=
 =?us-ascii?Q?j6FwMH42EcNstZ7Aa43SvxeZ+9na2xdJsVy/qk4wjQko4IGYQPaieW7ikKBx?=
 =?us-ascii?Q?VTIzcoMGf7LXdurIcLK43uoVAeekaDFjqGHp4gSDCUJxOQOHT1TO0cpMkBci?=
 =?us-ascii?Q?M/FLe+w4lpbjuDwtjEt0RYYLNAlYr1hEgcq2mdMNw7sw78Ueaik/gVKXDACf?=
 =?us-ascii?Q?1qpf5in0SHlV89+7oAsoyEL8z7SnIYjy2GYdYYtZtGxun3x1QEm7dDOdeLQ2?=
 =?us-ascii?Q?8fvTkFrUBZ5+hhQQ/Hfo9kaIyDhbj8UWzqLC3sQVpA/mDWv4VxL0P3V8H5wm?=
 =?us-ascii?Q?BI6XgTkkGIxRDDAv8kBZtEt11ULNkdzGsWupzw9PklVZx0EH+aSRIDJ7QQxv?=
 =?us-ascii?Q?sEdQzF+H02Q7fNbE1OLOqA5LOvRcS2pp6MlMg+YJmKIxPWewg5f1WsYmsZxL?=
 =?us-ascii?Q?f8LNQSqy/C5tXTzFVBxn+/AzzeJtgwYxj/5CbqNV?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e2897c02-bdc3-45cf-f405-08dde643db67
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 15:02:07.6421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bp3lir+ZHVJIgCqQ31qOC2Lv17Gae0bOhiUoNAfTyudk4iwmr8LVt/iRaKePqNijgcYVl7CQlIj98dTbw5gTrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5111
X-OriginatorOrg: intel.com

Sean Christopherson wrote:
> Return -EIO when a KVM_BUG_ON() is tripped, as KVM's ABI is to return -EIO
> when a VM has been killed due to a KVM bug, not -EINVAL.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

[snip]

