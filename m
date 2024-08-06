Return-Path: <kvm+bounces-23309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CDACB94887A
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 06:48:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA8F61C21750
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 04:48:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D972015C12F;
	Tue,  6 Aug 2024 04:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TQsho9g0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C63A35;
	Tue,  6 Aug 2024 04:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722919674; cv=fail; b=TZhIAAkcYE5Ybqw3UjNrt14TxIY/FFvOy0qCGs1RpC177xQS5DaMPqbpwF41gB1Vts1YX12QE6zoQl6UpKMChhq6hZaK18xny7CL4i+s0u7AI/a7NC/AzHjlxDqHknQQl5Kc+RLQ+nHpeGaWKfCuA17wTkUrJIkMbGmX5rte4Ac=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722919674; c=relaxed/simple;
	bh=wrZyM0eqrF6vWj6tgR1gDAm/IulcJVmczTNJLv0azk8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=iNVQsqwJ9WXk3oeiN0egQRgz10FivRuRgyiaXTrmOBSnGjAFlW6lUR9umj+pd2vzSnt9Kb1GSxxn3gW9q8kh+gXaIZPrwDMUpB6HTgolu3u5TrvtoX3/dfNGlfHo42XPe29UZ8EM7HSgeWlcwW3TdfL7f0Xb13RbOKivbY0k/bY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TQsho9g0; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722919672; x=1754455672;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=wrZyM0eqrF6vWj6tgR1gDAm/IulcJVmczTNJLv0azk8=;
  b=TQsho9g00OfteB9Plnyfd6RyLhIiD39G0ODj6Zc2o+S17uj4iG3wlfPa
   jrybPidSdYAnwF2eFbNLTjHtUAeEJVhoJuTA07mVLIwbxzfWhX/WfG/e+
   7iJ2QbQlCFS3GkZhNiKrmD/+mdm38qpx+qU2odq+vTv5xlLrDRblLP+zL
   is9adlB/Enh6CMQ+G+C+5qBMeun0ljskd+GU1AuNpYxQlT3Pq+m4Q4z1D
   DeXg+WXnnrLCXYlrNWnNt5UMajBL75vAU2D/GEI7eNZmZoBKOQ9GgrmCq
   4d1NpYhn/K/gAK/iUROrsRz4QUGDRH39zY7pB02b+W941//4j7yhv5ycT
   Q==;
X-CSE-ConnectionGUID: I5D3T9sBRKe2MgdUNDChGg==
X-CSE-MsgGUID: E6MakzkYRWyTQh2cPdiEGg==
X-IronPort-AV: E=McAfee;i="6700,10204,11155"; a="32068080"
X-IronPort-AV: E=Sophos;i="6.09,266,1716274800"; 
   d="scan'208";a="32068080"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2024 21:47:51 -0700
X-CSE-ConnectionGUID: +L+1cGaOSCmtI270ZQtGKg==
X-CSE-MsgGUID: rcQK4JgRTQG21wM56tnpAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,266,1716274800"; 
   d="scan'208";a="61241776"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Aug 2024 21:47:50 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 5 Aug 2024 21:47:48 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 5 Aug 2024 21:47:48 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.44) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 5 Aug 2024 21:47:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wJ8rSIFDVA+UeMPG8Ke0ltqvecttm9/cyf0gouiTVsaPkE8bN4leaeglCqvftvxJlqlVn9OZ8J4HET9+9NC658WUZu/YAr9pVC4QpBwJYZL6sOKacfZWhBL3zjr76ABU8Vo1MzXJb1EA/zyA9AZmivvc14HVli+X80p0AdkmXJ6Jv9hKd5mJnhxALb+lJ7unntSZ4Z7DGoR/tYsCY8+XwO0HZDnkpKUccRVGAaAO12Roll2rNDkJJXwOUR/hluxPc/GjNc+kW2LHm4IhiYlfCWNjuMrwksnx8kHX91FEw9t4SX/0jM1AedaXY2+ZTPz00W+IG//93UqI0screCmfjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qps6A4AbF6Tw6CyN8L5KyBEQmO64698oWwTAEZcF2vw=;
 b=bgB9CBKABtjlwYt75pLE7G79xvSAcHovdAnPEi4c42yTxGOqJm3cGRwrYXe7aQtZIMcvVkE/ttNuGtoxqFR4WzqgJf3Df0fKslMTnXYqWzx4/lBgPEWmxLGIWJKxNTRWovLurZtNeDT8QjzRAdJWw31gRgH/7bpEnyZBD93EEoaTJtf9jq+yi2fYbVay9bFqiBI5jLWwAZJcNzQa2iTQQjY68l46VA3wy3H0/2Tggdpsrovn2tZcM0+/co796drrQQmrHI56vy76NM81dMFj+ECbuKX+OMQg4sUrSPq1Go4ca6dGj+/ctyG9Bb0NGm3Z2Djz87zXbnFSVRNBE5r2sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH7PR11MB7004.namprd11.prod.outlook.com (2603:10b6:510:20b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.22; Tue, 6 Aug
 2024 04:47:46 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%4]) with mapi id 15.20.7828.021; Tue, 6 Aug 2024
 04:47:46 +0000
Date: Mon, 5 Aug 2024 21:47:42 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Kai Huang <kai.huang@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@linux.intel.com>, <bp@alien8.de>, <tglx@linutronix.de>,
	<peterz@infradead.org>, <mingo@redhat.com>, <hpa@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dan.j.williams@intel.com>
CC: <x86@kernel.org>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<chao.gao@intel.com>, <binbin.wu@linux.intel.com>, <kai.huang@intel.com>
Subject: Re: [PATCH v2 09/10] x86/virt/tdx: Reduce TDMR's reserved areas by
 using CMRs to find memory holes
Message-ID: <66b1aaee6e7d9_4fc72941e@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1721186590.git.kai.huang@intel.com>
 <39c7ffb3a6d5d4075017a1c0931f85486d64e9f7.1721186590.git.kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <39c7ffb3a6d5d4075017a1c0931f85486d64e9f7.1721186590.git.kai.huang@intel.com>
X-ClientProxiedBy: MW4PR03CA0109.namprd03.prod.outlook.com
 (2603:10b6:303:b7::24) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH7PR11MB7004:EE_
X-MS-Office365-Filtering-Correlation-Id: 347ba2cc-ec47-4844-2548-08dcb5d2ea60
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?wOsvbf3nsNoXUVAVuULZzCB7q+G1yj9WfyAqFfZi4Mms9Xrw5Y1vcuwW9Xkd?=
 =?us-ascii?Q?rcn2vUCyDZdFwLfP1yjKk0rC4RoTkV1S0vheKMo94ANg2P7G95bfUdBV5YkK?=
 =?us-ascii?Q?hMxJpXotK+teIoACjl48gC674IumdI2rBDIX1U5kqu0hTpgCFzVp6bGVyJe3?=
 =?us-ascii?Q?K6W6T37E1HqgllVY0PTMa8b8NUy/+Qk0xK+aZAWSEGzbb7hCwkqb/pgMr9lD?=
 =?us-ascii?Q?j1bDzYpj2HJkAsSqqzOZyexQ5OQbp4rj0Iw8IkhReiCjNe/bav69ViTBwxtR?=
 =?us-ascii?Q?FY80mJaTdSGKIUa8ut/01T2LGaI2Bkuy2aqR7oEgGiv5QQZPVsCuRZfLCURP?=
 =?us-ascii?Q?n88IpOIH7ld7PvA9I00uVq3OFmBYLyDno1pQZfEAph/4pR9LmFhD0nRqrpZ7?=
 =?us-ascii?Q?3XEYUNUykEfrh5/8cvGQb+If9qOheJBt+D70y+9nZ2GdyKViWzc3zBXZNiKx?=
 =?us-ascii?Q?RbFXbSbkGUJEGqiSbR8vNLc+ur5SrL7OO8SMmwedL5fUkc8GxXdD/YFMmKdT?=
 =?us-ascii?Q?+mm3YC0IcXyw0KS85NdVXbZQ/1Z2n7x3OIzAxS13x8wvQw8BEQn9gpWq00Cc?=
 =?us-ascii?Q?ET1eDs3Axz6zkYcDqeA7ZuRcbt0dADIjg6U2SUzQM+12xcvh3dctpFWO0dxP?=
 =?us-ascii?Q?kaRL+Evv3Sc1dHOQIReLShPSnYSrsMguGI7tEULuD3VBcGhe58eu/smCfzs7?=
 =?us-ascii?Q?T+UrHGXv5GvYJNGou1Pw/zAApf06ayuG0qhjraAIqqnIIz31dvUNQvvPSsB1?=
 =?us-ascii?Q?t8LAnXlfpOPIIEYZvZm4gVz4NgoV8FGNDmCZEguiLRVD6ffMAFGAGJC6ps9r?=
 =?us-ascii?Q?XBXUhgzNuhDRgdBN8E9Q81rgjs3BQioVuuK3xoBLV1MoKuhNjJYQPsWOEC6x?=
 =?us-ascii?Q?rMkJlqAllgwBt1eVIq0jNJv0QAsdCuuev46sxKkYHgeNr7Et+fVqP43OEj+a?=
 =?us-ascii?Q?KlCbR1cAsjh5TFS4o5+oVbG+9fgT/adZPYtXzF0O0aTClFd2DKPDre209mXn?=
 =?us-ascii?Q?C7WlG6Q3/Mhc2wKcT4fWNZ5em+yCZHJoJBoTUvZXAD6z3UXNapz8hFxDBdwh?=
 =?us-ascii?Q?HvN55KDDAi+qFYl7SjUilrmtKysnUQPx2jsXJ0GeyFOHVS1Fje2foC+0sdDK?=
 =?us-ascii?Q?JQMZiuvBGGRyxrdttSCkyCshikRYHaY3lSH5aUgHAt2esdF7Ib/FJTSsLCc/?=
 =?us-ascii?Q?Jy7wWKGYuxRChAdNG9s1eTLW5hrDc7p4/PbAIAdfye0aMiCvV5cdW6j9lZAE?=
 =?us-ascii?Q?Mj1TjOe1OINIgkPsYT+sXfYSXd1m421jQr4aIvqMdC6RyEACE0h5qbBrym86?=
 =?us-ascii?Q?vD9y+zYSMqXJ4Lkk/Bds1TgaaDJxxJbVmy+w21S85kXg+7ZyZCnceYauE9it?=
 =?us-ascii?Q?SvHeLjUptxSoq4nT0VrrNiYNfEFq?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dmRLW3ccGbXZ0MGNMPC52j+q1yYZ2EdNi02EDBjAXC6NZkCmAe9trhs1oapf?=
 =?us-ascii?Q?xz+uJKh6ygbY1N8wZjGTmqcmhag7FGI47TLMJqPUivA1/04c5a0xustL1U/t?=
 =?us-ascii?Q?lyUtkE+loELb/26gRK0tkCFGav20iwToD6fv8OX5awgq6bgO+ar8hHWYdOsv?=
 =?us-ascii?Q?ovdI7KI7Q/VxdgWQEOmZrNv9lEabWsmJ6miTeN9k7uHisvpKknrHYf0pP2qI?=
 =?us-ascii?Q?4L+naWsHiFu/QdL38hUZEdii3WDKJYZxOG8kHtVWrtiBCX3nc+Ysv3SmDJQs?=
 =?us-ascii?Q?MwhZXzx1bAQKN6/99uZI5px7inzY0NhBY0qnbxQP1ZSODQ6dTGn5geQZu+/y?=
 =?us-ascii?Q?LYE9iWXSEsZxVRxXLM2NG99Wk5Gxaw+Jc2yzTr9of+5zUj191KkdXUTlxE8A?=
 =?us-ascii?Q?ML9mAXA7ozfq1zQdAQXd9IW8awNjMTM7c89RTAz0+QpeZIMXq4AutDw0t5Rk?=
 =?us-ascii?Q?/XE+tkwJzagF90dVaTuQeIz948OidK3hWNiEMyp388XPcbyk28hxfDp2Ludu?=
 =?us-ascii?Q?c49CkswvxUGDsCCE0RNxQurZlkmH7FBYS+Ep6APC4XB6UlgCVQ6TzEIGjTzD?=
 =?us-ascii?Q?4MnuKYVlXNILad9d5JhxppXGIw8xIrwNvSHaeDpWXUYPMgNntAe6zrm8+Eot?=
 =?us-ascii?Q?I7T2AauOvoqd/37HcxE+BAe3OmPUVuUArL7sgUb/jLylK3nzzTHZ+C6T0esZ?=
 =?us-ascii?Q?116temETd/JFbnSTNJYHOq90erFYfHQ/OO+CtWlhS5l5BrVIOaY0yYS4xltq?=
 =?us-ascii?Q?7kfwmzHtRVW3sZUoFJpnNtyMJytZ7OHMgUelcwbyG3VfD6Lqh9qKE4zgOSUA?=
 =?us-ascii?Q?LTPcqJhzH4gQ4s624EizOOuQB8fbNR3U5w5ebA5VqU9jMjAkIXkt+j4xhs1I?=
 =?us-ascii?Q?LpFGUYpdVjEJ8Lim2OS4f+L2W4MR241tQKqBDbppg+n6k2EJivQrLIuLG9Ns?=
 =?us-ascii?Q?TJJ+irKK6x9ZLyIsN1V9P7PGOgpUYcZaRDx1If4QsIGp3RjsHhloizXR0J6F?=
 =?us-ascii?Q?W6zGtNsN8PzYsfpUumg57xbda2J+u+pgM8roCJYrgZdPW7kVejHRaN02NQRa?=
 =?us-ascii?Q?30rTzNCYB+lNXR+9H+uKHigujw/579zqGN0ObqnX6rFyhAQxiKt7j8irM3Yq?=
 =?us-ascii?Q?iC0FhZmQpokuvDozwUFZJCmpKayauMZ0Ukh5DI5c3J1mD2/HCL1sV+gumTML?=
 =?us-ascii?Q?35+4aV69/K/ywgi6D30jWFRBQAExRgOZn+GPaGM11zytvnCr1LPwJ8VdkJaX?=
 =?us-ascii?Q?yUUSEUOsbJ4h8j9My2QjQSDUDGl9io5GFP+V8tXp7m2twF2NPTpXfw1/Dz1G?=
 =?us-ascii?Q?V8LQNziK7W5gNJK9zl5AhjYtriW6yO+VH76x8kK+p6T4gjSaKegN7MDzWYAf?=
 =?us-ascii?Q?Pljm9wI6/9Z9DNXChj0BkgohpLEe56GuEiMLXW9ZsGGjPgH41Uvs8KrIZ0I2?=
 =?us-ascii?Q?AXnbgMz8G27FSCm47jCrFLiRPK+X7D/2K3w3gz83Y4oYWiII6TbyD/+nbbLt?=
 =?us-ascii?Q?WmYXQp/kPPNr6Gshav8u5Hr+LjkfVAwhQGdbVOxbDkAvedrfvyuL0Nn+y7WB?=
 =?us-ascii?Q?Vry6EIGKEZyNVhXRilKLKex3FbmF6YDocFtBd0CERNANbimTFFGIUv18U7fB?=
 =?us-ascii?Q?2g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 347ba2cc-ec47-4844-2548-08dcb5d2ea60
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 04:47:46.0920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aXIpCPcIGJhh50XeXDaxmEF8xP/vo4qwRVC9eG97WKTDQdkLZeUB+bBnEVRDqcNbzpDE0Gzy/WF2yY9m6vQ423LyDsCa+TWipklTRjkpNbs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7004
X-OriginatorOrg: intel.com

Kai Huang wrote:
> A TDX module initialization failure was reported on a Emerald Rapids
> platform:
> 
>   virt/tdx: initialization failed: TDMR [0x0, 0x80000000): reserved areas exhausted.
>   virt/tdx: module initialization failed (-28)
> 
> As part of initializing the TDX module, the kernel informs the TDX
> module of all "TDX-usable memory regions" using an array of TDX defined
> structure "TD Memory Region" (TDMR).  Each TDMR must be in 1GB aligned
> and in 1GB granularity, and all "non-TDX-usable memory holes" within a
> given TDMR must be marked as "reserved areas".  The TDX module reports a
> maximum number of reserved areas that can be supported per TDMR.
> 
> Currently, the kernel finds those "non-TDX-usable memory holes" within a
> given TDMR by walking over a list of "TDX-usable memory regions", which
> essentially reflects the "usable" regions in the e820 table (w/o memory
> hotplug operations precisely, but this is not relevant here).
> 
> As shown above, the root cause of this failure is when the kernel tries
> to construct a TDMR to cover address range [0x0, 0x80000000), there
> are too many memory holes within that range and the number of memory
> holes exceeds the maximum number of reserved areas.
> 
> The E820 table of that platform (see [1] below) reflects this: the
> number of memory holes among e820 "usable" entries exceeds 16, which is
> the maximum number of reserved areas TDX module supports in practice.
> 
> === Fix ===
> 
> There are two options to fix this: 1) reduce the number of memory holes
> when constructing a TDMR to save "reserved areas"; 2) reduce the TDMR's
> size to cover fewer memory regions, thus fewer memory holes.

What about option3? Fix the BIOS. If the BIOS scattershots low memory
holes why does the kernel need to suffer the burden of putting it back
together?

What about option4? Don't use for_each_mem_pfn_range() to populate TDMRs
and instead walk the resource tree asking if each resource is covered by
a CMR then add it to the TDMR list. In other words starting from
page-allocatable memory to populate the list seems like the wrong
starting point.

> Option 1) is possible, and in fact is easier and preferable:
> 
> TDX actually has a concept of "Convertible Memory Regions" (CMRs).  TDX
> reports a list of CMRs that meet TDX's security requirements on memory.
> TDX requires all the "TDX-usable memory regions" that the kernel passes
> to the module via TDMRs, a.k.a, all the "non-reserved regions in TDMRs",
> must be convertible memory.
> 
> In other words, if a memory hole is indeed CMR, then it's not mandatory
> for the kernel to add it to the reserved areas.  By doing so, the number
> of consumed reserved areas can be reduced w/o having any functional
> impact.  The kernel still allocates TDX memory from the page allocator.
> There's no harm if the kernel tells the TDX module some memory regions
> are "TDX-usable" but they will never be allocated by the kernel as TDX
> memory.
> 
> Note this doesn't have any security impact either because the kernel is
> out of TDX's TCB anyway.
> 
> This is feasible because in practice the CMRs just reflect the nature of
> whether the RAM can indeed be used by TDX, thus each CMR tends to be a
> large, uninterrupted range of memory, i.e., unlike the e820 table which
> contains numerous "ACPI *" entries in the first 2G range.  Refer to [2]
> for CMRs reported on the problematic platform using off-tree TDX code.
> 
> So for this particular module initialization failure, the memory holes
> that are within [0x0, 0x80000000) are mostly indeed CMR.  By not adding
> them to the reserved areas, the number of consumed reserved areas for
> the TDMR [0x0, 0x80000000) can be dramatically reduced.
> 
> Option 2) is also theoretically feasible, but it is not desired:
> 
> It requires more complicated logic to handle splitting TDMR into smaller
> ones, which isn't trivial.  There are limitations to splitting TDMR too,
> thus it may not always work: 1) The smallest TDMR is 1GB, and it cannot
> be split any further; 2) This also increases the total number of TDMRs,
> which also has a maximum value limited by the TDX module.
> 
> So, fix this issue by using option 1):
> 
> 1) reading out the CMRs from the TDX module global metadata, and
> 2) changing to find memory holes for a given TDMR based on CMRs, but not
>    based on the list of "TDX-usable memory regions".
> 
> Also dump the CMRs in dmesg.  They are helpful when something goes wrong
> around "constructing the TDMRs and configuring the TDX module with
> them".  Note there are no existing userspace tools that the user can get
> CMRs since they can only be read via SEAMCALL (no CPUID, MSR etc).
> 
> [1] BIOS-E820 table of the problematic platform:
> 
>   BIOS-e820: [mem 0x0000000000000000-0x000000000009efff] usable
>   BIOS-e820: [mem 0x000000000009f000-0x00000000000fffff] reserved
>   BIOS-e820: [mem 0x0000000000100000-0x000000005d168fff] usable
>   BIOS-e820: [mem 0x000000005d169000-0x000000005d22afff] ACPI data
>   BIOS-e820: [mem 0x000000005d22b000-0x000000005d3cefff] usable
>   BIOS-e820: [mem 0x000000005d3cf000-0x000000005d469fff] reserved
>   BIOS-e820: [mem 0x000000005d46a000-0x000000005e5b2fff] usable
>   BIOS-e820: [mem 0x000000005e5b3000-0x000000005e5c2fff] reserved
>   BIOS-e820: [mem 0x000000005e5c3000-0x000000005e5d2fff] usable
>   BIOS-e820: [mem 0x000000005e5d3000-0x000000005e5e4fff] reserved
>   BIOS-e820: [mem 0x000000005e5e5000-0x000000005eb57fff] usable
>   BIOS-e820: [mem 0x000000005eb58000-0x0000000061357fff] ACPI NVS
>   BIOS-e820: [mem 0x0000000061358000-0x000000006172afff] usable
>   BIOS-e820: [mem 0x000000006172b000-0x0000000061794fff] ACPI data
>   BIOS-e820: [mem 0x0000000061795000-0x00000000617fefff] usable
>   BIOS-e820: [mem 0x00000000617ff000-0x0000000061912fff] ACPI data
>   BIOS-e820: [mem 0x0000000061913000-0x0000000061998fff] usable
>   BIOS-e820: [mem 0x0000000061999000-0x00000000619dffff] ACPI data
>   BIOS-e820: [mem 0x00000000619e0000-0x00000000619e1fff] usable
>   BIOS-e820: [mem 0x00000000619e2000-0x00000000619e9fff] reserved
>   BIOS-e820: [mem 0x00000000619ea000-0x0000000061a26fff] usable
>   BIOS-e820: [mem 0x0000000061a27000-0x0000000061baefff] ACPI data
>   BIOS-e820: [mem 0x0000000061baf000-0x00000000623c2fff] usable
>   BIOS-e820: [mem 0x00000000623c3000-0x0000000062471fff] reserved
>   BIOS-e820: [mem 0x0000000062472000-0x0000000062823fff] usable
>   BIOS-e820: [mem 0x0000000062824000-0x0000000063a24fff] reserved
>   BIOS-e820: [mem 0x0000000063a25000-0x0000000063d57fff] usable
>   BIOS-e820: [mem 0x0000000063d58000-0x0000000064157fff] reserved
>   BIOS-e820: [mem 0x0000000064158000-0x0000000064158fff] usable
>   BIOS-e820: [mem 0x0000000064159000-0x0000000064194fff] reserved
>   BIOS-e820: [mem 0x0000000064195000-0x000000006e9cefff] usable
>   BIOS-e820: [mem 0x000000006e9cf000-0x000000006eccefff] reserved
>   BIOS-e820: [mem 0x000000006eccf000-0x000000006f6fefff] ACPI NVS
>   BIOS-e820: [mem 0x000000006f6ff000-0x000000006f7fefff] ACPI data
>   BIOS-e820: [mem 0x000000006f7ff000-0x000000006f7fffff] usable
>   BIOS-e820: [mem 0x000000006f800000-0x000000008fffffff] reserved
>   ......
> 
> [2] Convertible Memory Regions of the problematic platform:
> 
>   virt/tdx: CMR: [0x100000, 0x6f800000)
>   virt/tdx: CMR: [0x100000000, 0x107a000000)
>   virt/tdx: CMR: [0x1080000000, 0x207c000000)
>   virt/tdx: CMR: [0x2080000000, 0x307c000000)
>   virt/tdx: CMR: [0x3080000000, 0x407c000000)
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>

It bothers me that this fix buried behind a bunch of other cleanup, but
I guess that is ok if this issue is not urgent. If it *is* urgent then
maybe a fix without so many dependencies would be more appropriate.

