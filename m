Return-Path: <kvm+bounces-58381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CA5FB9059A
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 13:28:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8AB5F189CACE
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 11:28:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A53A4305066;
	Mon, 22 Sep 2025 11:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="amj78dVU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EEEB304BB7;
	Mon, 22 Sep 2025 11:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758540489; cv=fail; b=KFoCebNtQb1jpxavZFVgs2gwnCcBUFQfWMiFOsQMTWjiaJjXHOhJ+8iLKIvJCckIIuuMtfqyzal9m5OjxtHUro+pOEghSDbKaHK0gyO1o9gEbOuyuzJQH6HHacNmXBxmiUkSnql+VFrQo3R6TOao5HZ++9eMuCarvt0TlF6+jlw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758540489; c=relaxed/simple;
	bh=kx8lI/ujA1yKbXhjLKiDZomwNV32SdTiwkOnL6vClpw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=M3ATVFCyyb5ukbx8wkUMlsp5WC81j+Z+hVKMep0jToN9xjFG//2S8Zk/ZbGVN5+I9DGACHSMOlTS9QVtwwF7QUXVrrUxk2+IQq30gwqOZQjQElQKbqmKQIL51HTMpKyDxB/IeC/jmkrIZhv3UElZOqKRDDBmY75w06RlHlM9eEs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=amj78dVU; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758540488; x=1790076488;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=kx8lI/ujA1yKbXhjLKiDZomwNV32SdTiwkOnL6vClpw=;
  b=amj78dVU8U4AoLKmRctkknyCl1WpcvzAlOf559XrpTfOMQz/KiHZV3b1
   TAMGBstUIhpcjE/cuI5zZJF9c3vye2G1rOa+ONBOlM6anR/XGDC56VLQX
   6CrifkrjH8GBIpU4Law+pKwLXOOYBedQmOd+q8bPXAp7eZ9rS76JnP0kw
   YSCrcG+HZx1IKMEPSSa2Vn+JL4fsFKmqfX11P3uUL28KL+Y9F0g2218Lo
   mawXjRRCuQGS6LvFE2i0JK+eEGZNfyaI6tCCyoSnbXg6AT/bYOLj9+wek
   dS/6e52tlgHMVVMkRqmjhvULJURO+GNVcUV6SEYXi1NzSn8AMPuKoeSlQ
   Q==;
X-CSE-ConnectionGUID: Dy7gKXweT8+JuSqgaNxe+w==
X-CSE-MsgGUID: hJahkgL0S0Cd0IoAIrzdbg==
X-IronPort-AV: E=McAfee;i="6800,10657,11560"; a="60687508"
X-IronPort-AV: E=Sophos;i="6.18,285,1751266800"; 
   d="scan'208";a="60687508"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 04:28:08 -0700
X-CSE-ConnectionGUID: NcL4dxtJRASKPTcXd5qwOA==
X-CSE-MsgGUID: IjZrw28aQEOPNua5grcjBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,285,1751266800"; 
   d="scan'208";a="176835000"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 04:28:06 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 04:28:05 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 22 Sep 2025 04:28:05 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.43)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 04:28:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xoR+CPoCy5MqfOHd2Rr61Yt41UcLdtthhoN/rdLIfZ/nL4h3gWy35zgS4bf+9Icnyawi2r0FT6kk8sq7OYlhikloICXiBqcePpjLJU8WByOg5kKQaP/tI+DLFWKdS/yfNmEhtobq4skuC4iQJhHGgWmP+GyOlJDSb+fs4xebtJTQC+x8HxCd+0VbxaFXNCFUyQZPb3Oh8nqgpnQDMFVXJNm+QauidrY2urHb+Y6SujOt8YgPaODdDfnC8S5iXa/ol3a8mWDatN+vfzDtDi9bLQc8VWrKT6SzFeWJgWrsNN/HdSsurhFTOJNSRihXFcLjFHqlFmeAystZ8w+lKqURJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KQ3j8NlstQJhsw/58N2KS+RLJ0Z3zr0pfrLarj8gN0I=;
 b=INF15FCvIQektj79KjuSGJmXGiNN6pZpr9ZKi4bOxmmqBb7rhgFl/qSa99iaH9ilmNhELQvVnP4y/YM9c3AKs8pF2FyFBwQ1c3U31THqg7/LwFifaLVufqPjHrebGAc7GJf3EaXtbOBgqfJH1WmKTgpA5rn1YR+cYkYV9rft5lhyDAFBg2W2Hka1tFIndS+prmwI3YtYEUusneCxapqC5+HYICqRVElFfGDPUQ/I87GR6NWR+hQPGXDk6ZleMjGZPFCK7LApOTwUtlHo39PobkLH9ajx4ORmh5JIuJ4s51zr8/XyVw/1uziHIyFfjNyexJf9BHsggqJ05a2bFFSTXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA1PR11MB7343.namprd11.prod.outlook.com (2603:10b6:208:424::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Mon, 22 Sep
 2025 11:28:03 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9137.012; Mon, 22 Sep 2025
 11:28:03 +0000
Date: Mon, 22 Sep 2025 19:27:51 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Binbin Wu
	<binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, "Maxim
 Levitsky" <mlevitsk@redhat.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>,
	"Xin Li" <xin@zytor.com>
Subject: Re: [PATCH v16 19/51] KVM: x86: Don't emulate task switches when IBT
 or SHSTK is enabled
Message-ID: <aNEyt/z8eAXQr8/r@intel.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-20-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250919223258.1604852-20-seanjc@google.com>
X-ClientProxiedBy: SG2PR04CA0163.apcprd04.prod.outlook.com (2603:1096:4::25)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA1PR11MB7343:EE_
X-MS-Office365-Filtering-Correlation-Id: 892e0d2d-f48a-4d35-5d13-08ddf9cb178c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?WdfEYOLHY04+w329J7sHwmZGt+kEVtTlXI585lsR5zWWBfkE/lpdhghazR6K?=
 =?us-ascii?Q?e2+QurLr+2dBqhW9fNJV5CBPyPTd0qrSYWRK8nQuK0PeCeYl8n6pE3PBwJ9r?=
 =?us-ascii?Q?sUpv0EVvlhUXr60A2S8j77seaBYQpxB94McegtrJm9qLRdz8qr1ZeTVJ2X2J?=
 =?us-ascii?Q?Mhh1FZopt+DeBgohxYHPGt9djPTua5+c0eMxDCaIwEeU4WVa/7NQgVb67yAM?=
 =?us-ascii?Q?YtkhiizFkNzXxxASazAtR6wFJIQxms8buLiUC073jDRSVY6EYymPDOerOR4C?=
 =?us-ascii?Q?muT7f7+2NEAhstctfGZXE+207gg2uIwjNm1iJlr/g4+Wb1eS7tJ83BZawY4y?=
 =?us-ascii?Q?IsOatycgVDq4xSgfs3R/l/Ia/dbGXXRtN6ZB5PxT4Qsc1boH2EIQtv9Teb1M?=
 =?us-ascii?Q?ChakJvAUuA67xNouzqyySohPQmGLBZDaJOFpqP508g5/KnBwmWoCg0o+TpA8?=
 =?us-ascii?Q?eQLqi875vH1Pak3EEbY0GSmZHrFJ8+LOanpd3zlAWgxlUFpOMNPZlztuSdwG?=
 =?us-ascii?Q?YX5o1+od+EV4Qe3gIkeRNiuYabLxre9vGefBal4QNRZVmFCgE6cuhUZQxu2P?=
 =?us-ascii?Q?a87bcTWjQcYBGGEew/fZTRr/fwCc4GGz9PfLovpTkCnJ4niRegegCFApqjJf?=
 =?us-ascii?Q?mzjLAENeUcfMbQAQ45ApZykHlOhSENbCEUMUwE5K5cAAPxWjPB5mObUnkPFC?=
 =?us-ascii?Q?YUtzMyJVw64Rb+KqyRooRPqCK4qWS9NHHmuKR6auEE3J+EZhz77/h3B2etBT?=
 =?us-ascii?Q?QyG2TM/BttNygHKmUWYIAinZ9vO3obbXy9s4/x93Di34V/vOnYkrQAmlpoIl?=
 =?us-ascii?Q?OjwxKFMB0ovZRP+MwqYieT7ftkol5VmUqWLn15k7gIwvuwhdJhgxs92NpYvQ?=
 =?us-ascii?Q?P+nywvYrIub97foR//0DYZwoNmj22ecZ7GwZBsACwUfXsbFB9iA8gQyEJ7gi?=
 =?us-ascii?Q?NdloLEdu61nlasGHX/k8PpOE77sff9tSJ0HlxBhb2UNbFbICgS/NMwsrZfa3?=
 =?us-ascii?Q?MhF90JhSrkaqzOXzW3EIhnWBRiGXBu/mo/WWIgED7k0cnNwDaQ/A0/QEKQaO?=
 =?us-ascii?Q?Ds4CCUGJpqvvxEk0BAnzCzHNgae1kQDukeY7g0R91F28IJEX+BLhoRvSJ6Lg?=
 =?us-ascii?Q?YTW5vwn/G9YRf5dCgAfl/EC7mb4xhcJN+uOja4Q1zBhOIjYWcitXuCKcy5/J?=
 =?us-ascii?Q?YNyTLVPUBnlXnR/2Fd5CCxD3BgV8vYXcaT++F46Vo6il445CXjzL0cglOxSg?=
 =?us-ascii?Q?C8VxhkNZrsI2WD/KBDeIxlZap5smc4A62EI/qgA6fTgpDSx/PqQvaBJHcSTd?=
 =?us-ascii?Q?YN0l+8hB2V7mS2REIF4B5HaIiu4+ZEg1EV4I7KA+H3W6X5UY8KItTjzFDADK?=
 =?us-ascii?Q?qlu/kDOCkILRed687wME6EHWa9xJDUpgqiV7NcZalofzSJ+J5Kav8E7DDpES?=
 =?us-ascii?Q?xlZfkmKPpoE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?16pkuF4y/t1vQXDjZCHlMpzw0LMgXtLeMTLZcAEHmgEteXqsmMSI1zUhFwdy?=
 =?us-ascii?Q?Gux0WuEjyRFckHlYLG/F0/I+0mpaViDbK8JwwXsMSg2KyIDH4nl/r2tP/zmB?=
 =?us-ascii?Q?iOx5tyh99aDR7w/lYfV6LuBw6hFEPVWG224hq3nF5v9CMCsPEl3UrD1gtBrx?=
 =?us-ascii?Q?n7+7u2M5nuYa/XvcK/OnyjtVJy8PjPRmdalZ4FDAFj7deMHdcoxrWds/v5rW?=
 =?us-ascii?Q?fTQOhXDt6676+K7nl5/WPRqx5SreSvCDoVK0AgFa3ZQSkaodyNseIjn482Sz?=
 =?us-ascii?Q?dbN75sqVP0riz2+IcPRin+7hoXTlS/3WGciBiObzJu66fOFmfzqKHMxH9biP?=
 =?us-ascii?Q?PUVd39WlJKlyfns7a7pulzLj37l9+YW2vuNSTv0gXaXCcCfZmdLzBy+75Dv1?=
 =?us-ascii?Q?VvDbwwVgvKez0GsLbm0sdVSuJCPVbQOZMsQgiWcyEQ3Gjhavz3P6cHUjTnu3?=
 =?us-ascii?Q?NxesJxUg9lgRwsfgb2PySS+y9bvKAgdI3+DBFiVhhJW12gFmu93lofZEG92W?=
 =?us-ascii?Q?tXJLsvv325JxzR+rKedq6dvKukduxpulvz6BiGHSFOr0y1Ddifc/RnSqyYf2?=
 =?us-ascii?Q?TOOAEVibgen9VvHWIwNXRMeWDJPsNAABXwViIMQEWHKbOPH64hfW2nTK5p6a?=
 =?us-ascii?Q?ic7l5v0tCa/Ii1ofbR5PRVjHHA3c56niD+96PoNRs/p5/49pyXa+stxKGkUX?=
 =?us-ascii?Q?afmmq25FN2v2zuh/NAa7Ip7V2jK6xJmW7qHj3ucllpShPQ2+AGqBqDj1nd/P?=
 =?us-ascii?Q?Ps4XBBgre/dpLt7rWVZ+Ybggu/dFEB9TsGoHNCkhc/WgFOIhlCFPA+ZKElyK?=
 =?us-ascii?Q?6dCw2ESwJTIXDwYT3A8GeCLYolcnhi7p2qYDG9xANp8PGjNBywlXK9uRQrtu?=
 =?us-ascii?Q?9U3WHIEzYyYRSo6xm2/7b4FNiQSCQsZZih5KGB+tFKu4POkBYT9W0HcHz25t?=
 =?us-ascii?Q?Q1MJBvGsi13P7boj5Kk+4YqDf8ZvsCXQV2fUqE1v8uwBQQaSd40QbudsX9W3?=
 =?us-ascii?Q?GiyDb8hRVikwg9cbaFVnObq0C0pYdB+C4ozpmz2epees478PeWEHsPjZGTWF?=
 =?us-ascii?Q?dWG0i5c5QUohoylPSRo329hsa9d7/Y4xsR6E+bl1RdPEcHaNa0NIX5egnu4H?=
 =?us-ascii?Q?OuF4fW8FiLebNZYiJN2ZqWHe96U7t2vGUV6fwNW+2bGTFh4A1AxbYz26Ipd3?=
 =?us-ascii?Q?H0/XwtC6/uPohpBoiG5Ib9EVzAURIKiBaMhCXVt9ELend1hioefoR5jCqNOH?=
 =?us-ascii?Q?ZitcMAAIgSRAUM2Ar/7JJGVVBE9yqILelmwmYV5AkfnWSdFNxP8VfQF5v7RI?=
 =?us-ascii?Q?tZAEKNvxwNJm325TwnzxtJRPTl2bxpYe0HRby6z++2PswSrkjhoPxIdDxW2Z?=
 =?us-ascii?Q?yeGVclbJgB5nbwZiPwhKaNbbmnSL1LGkf9uwQyjZW4+Kk6LTrn0gMK6z0f8F?=
 =?us-ascii?Q?2PGkfxrvA4hGdnLX54tOpgf+T0dMnYRXCg07wduXATfyzWxEmSTBcXs5NmK4?=
 =?us-ascii?Q?kdqKUquje3q/gqK7U7TcYQdK8yTIWU1HFAVpuAGePeXjHSZMsLIfAmfnWXO9?=
 =?us-ascii?Q?/xuWq0DB0bmMXQXeZtcmWOiaar2nmaHjs5nKmVTx?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 892e0d2d-f48a-4d35-5d13-08ddf9cb178c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2025 11:28:02.8860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yekH6uUq/N1bUDV96otlfws/oSFmw+oNQu/bFrEljlJiaOAcXKOHYWhFa1oYHJl4H1PG2iexNjK28T7KlTi2Ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7343
X-OriginatorOrg: intel.com

>@@ -12178,6 +12178,25 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
> 	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
> 	int ret;
> 
>+	if (kvm_is_cr4_bit_set(vcpu, X86_CR4_CET)) {
>+		u64 u_cet, s_cet;
>+
>+		/*
>+		 * Check both User and Supervisor on task switches as inter-
>+		 * privilege level task switches are impacted by CET at both
>+		 * the current privilege level and the new privilege level, and
>+		 * that information is not known at this time.  The expectation
>+		 * is that the guest won't require emulation of task switches
>+		 * while using IBT or Shadow Stacks.
>+		 */
>+		if (__kvm_emulate_msr_read(vcpu, MSR_IA32_U_CET, &u_cet) ||
>+		    __kvm_emulate_msr_read(vcpu, MSR_IA32_S_CET, &s_cet))
>+			return EMULATION_FAILED;

is it ok to return EMULATION_FAILED (-1) here?

It looks like this error code will be propagated to userspace and be
interpreted as -EPERM.

