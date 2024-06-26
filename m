Return-Path: <kvm+bounces-20535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 56490917C31
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 11:15:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A36AEB26B93
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 09:15:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C60D517C22E;
	Wed, 26 Jun 2024 09:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AUUCfUVa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0155516A949;
	Wed, 26 Jun 2024 09:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719393174; cv=fail; b=e4R5ZEGrGPiJF388m601Kq4DGDJ2TIQN5FT/Gmv2/iQibdhGQKafNlGbF6Z1WF9cM++0hqtVlSRTi1N2jZiScn9FN8HYYNkqPfsJJZwJH2MB/sY0zhEnAYR/xihke62kMwgf6ok0IoQGo/JnTsbFjlQLAqHsY8pO4n6JHjYPmgQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719393174; c=relaxed/simple;
	bh=coDlGR8UuLHCnnrOY0yiexMkXYqT7JC0YKIVcFay/54=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=oEITA4LFW87YEwVZzvbRj031eGwpq1hDUwxV2mltucKsDQlUWy2+5MaVbDDXu4u+x5POxdS2D7aRZgZXNr7wEJfFBocRsYgq6WgNH3/GVzQy1o9frs6/cMAxy0P3lJ/sCsjTiEXQPMuzPx96tS1se+sjhXUBYGjDcmMIlW1hYF0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AUUCfUVa; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719393173; x=1750929173;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=coDlGR8UuLHCnnrOY0yiexMkXYqT7JC0YKIVcFay/54=;
  b=AUUCfUVawmhGeC95+hH/HYqghX3Dw+wEb1eiZxaLWTvKVgFxrldwA/7i
   biTKpHwEBoG2D/Ad6d9r8JYnNeAdmgX1LdP6ySzeSYZfomXmnwXSmlSZ6
   mi0d8XSfE86A9ChwMNxBCMfiScKHzGMVs7i8aHbPEHLjNMKgHAjXOas8y
   XOErtdo+nLMZ0cHIvHjExswCfVwlWlToU5Ty6KbQ5N9yrFqtDuu6G/fDy
   C68GkxD7st/5+gDzB8/O5G19x44O9pxrtk++T4uts9DA1hEkol5LA7kbH
   IdTgP1+JGsAhfDDJTP3rKdk3cyhpCSdr4fi1PIUJFyHUVcKgQ2J47EvMl
   A==;
X-CSE-ConnectionGUID: xNoBhAQTRouJVFsMStbZLA==
X-CSE-MsgGUID: C5onywCASP+sVnQkZtpWZQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11114"; a="19343119"
X-IronPort-AV: E=Sophos;i="6.08,266,1712646000"; 
   d="scan'208";a="19343119"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2024 02:12:52 -0700
X-CSE-ConnectionGUID: 4QYMS7guQXa3i72jddkMzQ==
X-CSE-MsgGUID: 7F36oU2IQUKEBobBj/Vj0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,266,1712646000"; 
   d="scan'208";a="43752214"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Jun 2024 02:12:52 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 26 Jun 2024 02:12:52 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 26 Jun 2024 02:12:51 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 26 Jun 2024 02:12:51 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 26 Jun 2024 02:12:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SyQQBdJmoIKqzV/tTLlJPbC/mbwo7OCTSsjN1GefmhA/S991egqjozygZkNBR9v3EOZtSecIXf1coxLUULKp72zX2+XX92VgLScQWSsLYIcbKQElQexywg8NE+bFm0ro69APOxsiEDq2W9ApTJIfq6LDSsTMd896COXASvvGVEoRXymi5tJ/oax51M/o1IXzj6JaexmEvWYT9rTZaqqg99CxNtjE9mBFcTzXYeYiMo/a9OJJeBRSBBvZNZYN83RPaKzGzxzwVQEOzhLDpCVC4XVn/4bx6qpO6/FMo0kDuTo8ZpuYJtShwh0BzJQDCflfDbkBQ0Ue0AEJ+Cw7koEgoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XZZ9zM8WodYE1L27j54Deo+mIrny3j59pKDISxbTSiA=;
 b=SGLJ5MmJRipI0boeaqTLXjSN2zc5MrDy7LcQhIBTbyMtbgrz/yWsyPmUv+QK5Etp9vqJ5UzIIz6I0WQ1VtB24oM/fcMRpA/OmcKc9/e9MNAUxrnmUxSPMLoGgdKcBz/EfXqS/6sMsiBK/i67fh6Tl6fAZfiLsdCvMOnMSd8I0HHrTWG1PXY4fHC4qXn6FczH+qyVBODzRhyqj7gEqk0wX915Of8wBJpK065/GZbVtu1qqdV0M5d+GD4rFV0b3OMO8bf2RTc1woU2ngHxJRvXE8QjuxveH2fpCCxNVVXSCqOlnh9gWkKojQTVh4PctmFqAET1J24G46OBQs7BT2HTJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA1PR11MB8200.namprd11.prod.outlook.com (2603:10b6:208:454::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7698.32; Wed, 26 Jun 2024 09:12:44 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7698.025; Wed, 26 Jun 2024
 09:12:44 +0000
Date: Wed, 26 Jun 2024 17:11:32 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "jgg@nvidia.com"
	<jgg@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>,
	"ajones@ventanamicro.com" <ajones@ventanamicro.com>
Subject: Re: [PATCH] vfio: Reuse file f_inode as vfio device inode
Message-ID: <ZnvbRFcfcufERwr7@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240617095332.30543-1-yan.y.zhao@intel.com>
 <ZnQBEmjEFoO39rRO@yzhao56-desk.sh.intel.com>
 <BN9PR11MB527603C378C5D0DA1294ED268CD62@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527603C378C5D0DA1294ED268CD62@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: SI2PR01CA0024.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::20) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA1PR11MB8200:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e9a0916-5da8-4df6-343e-08dc95c02355
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230038|1800799022|366014|376012;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Wt5wROWpuAhFMiwriWYFDH4uuZzuHwFGr96iZZNVxI621LKOtapS8wcnfzK0?=
 =?us-ascii?Q?OjOUegg0bEJ2XxbvvEA2Mdvov3/bfKPV2BQjdt+CUs6NlYwyucPsCfPwP/N6?=
 =?us-ascii?Q?9Ck9KpX9UtAufsF/YsQcqlpyNh4gT5u8mGrktrA8yY8N2NUviKXenvpW5Bz7?=
 =?us-ascii?Q?3FLzU4MknYp/1ZeVnBaNnT1F981DjFDyxVTHWXzMgHwt4dDAjtBekB7rtIGp?=
 =?us-ascii?Q?uzGsR9Gz6botqLYNgonsoADzWUNARSvQG0DNDkbwOdi/H2+Op6ugU6TMZGZR?=
 =?us-ascii?Q?ENJa9PhBdsitfQPLxRuM5UmQD4IktCK0XoptDHEunAAul/5iGysYFTCGqYk2?=
 =?us-ascii?Q?XnSdh6BD14Ro7ODemkQcAdui4TixHX0XU+Bx4iqnLqIrSHyetlOGLIn9Ptr1?=
 =?us-ascii?Q?BrPQ1I6XGnGPn+fXRprFu1XJ47ImPaF13VI+Kz8lYxL9wp/dmh4tmTj7deja?=
 =?us-ascii?Q?Ji3X+c0gAtOAot6/pprT6cGFrAb2cKxmNYzYIC+5qM8Zq7jkQNqgmqe00Qd2?=
 =?us-ascii?Q?PMsdMC5/c3Mq8bIzzLyiADkW5QTmBFtxwijZ2GIr9ZRhXgRZNLAt45bWsC5G?=
 =?us-ascii?Q?+3SY0dJ1A87DqHf0SD/w09kTiKp/3YMGtiqB+MP2jXbLlgdiiah+21NgwzAD?=
 =?us-ascii?Q?GFugdk7gFYi0blVjLTI965BrfhqhDoh/R7l9TI3Rx4+BaLeoyMFUo6d25eDZ?=
 =?us-ascii?Q?5W7g7LesGdSaffLux6IYrdvWeYIQhHuwaQ67o0K5xLFTIgyoMABq53iENQ4i?=
 =?us-ascii?Q?ILXDd5Wvh0B6Y0rFY1vPaKSZWlUqeOcaVUCCeTPXfBiCIpTnRamgp6r9fYOj?=
 =?us-ascii?Q?QJrvO4XyDBoJfEolF3szSolBvQXgQbu9Y3+0spQWfZR+hSsVVsXdmgE/RVM6?=
 =?us-ascii?Q?XlnPMvCdX5atPLMpDoobnbAvyzw66bNi5BBX9/t4pR8ZkylezFuGHddsFuGb?=
 =?us-ascii?Q?IUtOEFCzJXdc7GH+iyBmOOUCRjy3tdxj0u1Gs+00oNyilW2Hptk3EbIA0mAh?=
 =?us-ascii?Q?ebge1+ePgsIBTs6VuR+upgdTieebKNqgKeACLGsSpJW+E2m1iizuI7Dgacyz?=
 =?us-ascii?Q?YBSGf0jRQV5lxYrM3DjpBvQwFCITKXijZYDmUWlyTt2X7oGwhOBtMuUEWyZd?=
 =?us-ascii?Q?rukC27JBC+GDsyAPMx52MhGRmQalR6h7NhB0mcEK9MadBK8RNwtmCv/X4wzh?=
 =?us-ascii?Q?WYd6Pwnf3LlHhwB806LzFxuuuKiM4kvwchOg3jSVcgq9270USltLLg1p0FQd?=
 =?us-ascii?Q?3j1BfN8p7z4XgODjUOAyNKR7/PFHo5WpJDNnOJJrRcw3qpJe2vjg4TaNmgzp?=
 =?us-ascii?Q?9OTjevwhdyDGCDgkzMW/UhPq?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230038)(1800799022)(366014)(376012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Wu2xq0yTr2Gm3U5sGJobt8xqaNN8YIkQgJXUH8LQ17EPDVDebbECdK+pivxo?=
 =?us-ascii?Q?Y8CcN5rPT99hozK3Wyqd2Q5zKlL9oNKlhiIVFrDnoC+hF9JTXWeqlxZtTjXD?=
 =?us-ascii?Q?HnN4qW1lDdU7sZ8IWpW2svT+AXB9VMbHtftZojvy7gZduHQAh/kklroOH2Uf?=
 =?us-ascii?Q?I1ajJGhfwe5PCr2WzJauZ9xyTdRO/x9Too/Ydjx6OgvHq28ABQc44DUn77g+?=
 =?us-ascii?Q?Vgm0COVd/2wS/ivNUt8mTerX2tvIbSZB0Q/q86DEiEIKV22rJqShBBnIXyyJ?=
 =?us-ascii?Q?YtcBTnfR5kcpnXopyrT/+lEbnK7+JdjBmMudGB9S5rCcp7qd1M3BO1Uo8IKX?=
 =?us-ascii?Q?bvQkd1RWnXoPJe+It0tzYjgr3qTiJjPNR/OI701KyaZPOZ6fZZkyiUrIox7R?=
 =?us-ascii?Q?gGdRPIWEiQIdJQn+zcKNZuFLb5MP/CvglpaLTUBfd5NcWv3ws0QIA2y73wQf?=
 =?us-ascii?Q?qY7v/ZyY1xkpN/fPymB5HAHSay6zTPvu5NkHbBxebQHkK8d5pmchNvS9Rtvt?=
 =?us-ascii?Q?asXGWqLz9HoHDhN+iuWwrWPa3vNWBjaZfDiEL37AzLlvYzgD3yaTCgFNviCu?=
 =?us-ascii?Q?rmWscrknfzgI6Tcgkg2hl5DN6qjnBWrwmkNXz3R8ypXt+AFGiYO4IHrF9G4f?=
 =?us-ascii?Q?uHVN7FBiJiPflsiT1baj46i1+NeOa8K4O2mmx6CibBW4E3tc6kRgKmP5P5fg?=
 =?us-ascii?Q?6cjuHP1N4yr5DxvfNoRk0DuAXg8sj5oGM2k1/43DWtI5UwH93Nrr1ZttwGZh?=
 =?us-ascii?Q?dupq3A2MIAoPWISy9L/8TiS70yYnOiWLycPrF5LhqyCEMlQbVVAfS7rsOB4l?=
 =?us-ascii?Q?jXg6DKc8Zs31Me6mJZsuZ9u2WjZWWsjFheqLIO2rJRBKz6++nXCz6elUKQ+9?=
 =?us-ascii?Q?ywaOJDhqKKkOew8HM38fc4xhcobPyTW1821O2xJCdBySISiBHpf8D/09y8xh?=
 =?us-ascii?Q?SiwGheVoXL3k1Qs4jgnIsbKH6/zo/8e5dAZVk51rwtNuFaV+3xH+M4PJGa3n?=
 =?us-ascii?Q?S0U2rj2HkwgTjBpR9QCxKOb2ajZNZh7k0zT6CXx1Pes5NpxK+9ufYfW30Lc6?=
 =?us-ascii?Q?ZM6oEivXL/1fZ90kXbuYs8QrKP6KvbKIsPEdqarYqYaypcrpY0UNETaRZPGU?=
 =?us-ascii?Q?SL+pdb3pF/yrEYne4XagNR4PwORUWfn1Y0V/B/JfXHL/qyxYdPvlb/YlFr6h?=
 =?us-ascii?Q?CVJmPpmwsXW1gnsbCautoZm0TnYo1DYfprR03do2PRXtc6htKeijRwJvqIfL?=
 =?us-ascii?Q?40swhCnB9GBT1E6T7F3Iptsq1nKk7WYU9xHC44hNsK8Tun3X/lYeann9IbHo?=
 =?us-ascii?Q?VgNbGm/WnQcE0mM55aEAzDdKSRnhtVU+HK4ejQTyZEyDjGId4bg5sX2ifd05?=
 =?us-ascii?Q?ifTQ+Es/9TLyzroVF7XBL1PgariaHob7MTe8Y639b+rPsORRHsLpnNl/G5b3?=
 =?us-ascii?Q?pykdXH1szD71dyXbrujhCBqfblXfWdTa0zCgV2C7cqQ2KhbCUSiLZvNV6SFI?=
 =?us-ascii?Q?QnabXmZlpCOTE3qlwSRgkpUB9yHJJ6JcuYFUVM3XLO8nO6g4QZj/UGwF+5aY?=
 =?us-ascii?Q?TGr6LP/IyltWMfV3JOQRmIrN9vDpO2+fS/fk1hK3?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e9a0916-5da8-4df6-343e-08dc95c02355
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2024 09:12:43.9853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mcOjw+tICaff5cGZ6nc/hYxKTnZWvou3bM08P4zQFR/WuPg4oCbvirtjGMJcZSG1mUzqRadHuBaklxwSJeVbUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8200
X-OriginatorOrg: intel.com

On Wed, Jun 26, 2024 at 04:36:26PM +0800, Tian, Kevin wrote:
> > From: Zhao, Yan Y <yan.y.zhao@intel.com>
> > Sent: Thursday, June 20, 2024 6:15 PM
> > 
> > On Mon, Jun 17, 2024 at 05:53:32PM +0800, Yan Zhao wrote:
> > ...
> > > diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> > > index ded364588d29..aaef188003b6 100644
> > > --- a/drivers/vfio/group.c
> > > +++ b/drivers/vfio/group.c
> > > @@ -268,31 +268,14 @@ static struct file *vfio_device_open_file(struct
> > vfio_device *device)
> > >  	if (ret)
> > >  		goto err_free;
> > >
> > > -	/*
> > > -	 * We can't use anon_inode_getfd() because we need to modify
> > > -	 * the f_mode flags directly to allow more than just ioctls
> > > -	 */
> > > -	filep = anon_inode_getfile("[vfio-device]", &vfio_device_fops,
> > > -				   df, O_RDWR);
> > > +	filep = vfio_device_get_pseudo_file(device);
> > If getting an inode from vfio_fs_type is not a must, maybe we could use
> > anon_inode_create_getfile() here?
> > Then changes to group.c and vfio_main.c can be simplified as below:
> 
> not familiar with file system, but at a glance the anon_inodefs is similar
> to vfio's own pseudo fs so it might work. anyway what is required here
> is to have an unique inode per vfio device to hold an unique address space
> and anon_inode_create_getfile() appears to achieve it.
Right.
 
> > 
> > diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> > index ded364588d29..7f2f7871403f 100644
> > --- a/drivers/vfio/group.c
> > +++ b/drivers/vfio/group.c
> > @@ -269,29 +269,22 @@ static struct file *vfio_device_open_file(struct
> > vfio_device *device)
> >                 goto err_free;
> > 
> >         /*
> > -        * We can't use anon_inode_getfd() because we need to modify
> > -        * the f_mode flags directly to allow more than just ioctls
> > +        * Get a unique inode from anon_inodefs
> >          */
> > -       filep = anon_inode_getfile("[vfio-device]", &vfio_device_fops,
> > -                                  df, O_RDWR);
> > +       filep = anon_inode_create_getfile("[vfio-device]", &vfio_device_fops, df,
> > +                                         O_RDWR, NULL);
> >         if (IS_ERR(filep)) {
> >                 ret = PTR_ERR(filep);
> >                 goto err_close_device;
> >         }
> > -
> > -       /*
> > -        * TODO: add an anon_inode interface to do this.
> > -        * Appears to be missing by lack of need rather than
> > -        * explicitly prevented.  Now there's need.
> > -        */
> 
> why removing this comment?
I found it's confusing, as now an anon_inode is available but
"filep->f_mode |= (FMODE_PREAD | FMODE_PWRITE)" still cannot be avoided.
To avoid it, the file needs be opened through do_dentry_open() interface,
which is not easily achieved.


> >         filep->f_mode |= (FMODE_PREAD | FMODE_PWRITE);
> > 
> >         /*
> > -        * Use the pseudo fs inode on the device to link all mmaps
> > -        * to the same address space, allowing us to unmap all vmas
> > -        * associated to this device using unmap_mapping_range().
> > +        * mmaps are linked to the address space of the filep->f_inode.
> > +        * Save the inode in device->inode to allow unmap_mapping_range() to
> > +        * unmap all vmas.
> >          */
> > -       filep->f_mapping = device->inode->i_mapping;
> > +       device->inode = filep->f_inode;
> > 
> >         if (device->group->type == VFIO_NO_IOMMU)
> >                 dev_warn(device->dev, "vfio-noiommu device opened by user "
> > 
> > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > index a5a62d9d963f..c9dac788411b 100644
> > --- a/drivers/vfio/vfio_main.c
> > +++ b/drivers/vfio/vfio_main.c
> > @@ -192,8 +192,6 @@ static void vfio_device_release(struct device *dev)
> >         if (device->ops->release)
> >                 device->ops->release(device);
> > 
> > -       iput(device->inode);
> > -       simple_release_fs(&vfio.vfs_mount, &vfio.fs_count);
> >         kvfree(device);
> >  }
> > 
> > @@ -248,22 +246,6 @@ static struct file_system_type vfio_fs_type = {
> >         .kill_sb = kill_anon_super,
> >  };
> 
> then vfio_fs_type can be removed too.
Right. Thanks for catching it.

> > 
> > -static struct inode *vfio_fs_inode_new(void)
> > -{
> > -       struct inode *inode;
> > -       int ret;
> > -
> > -       ret = simple_pin_fs(&vfio_fs_type, &vfio.vfs_mount, &vfio.fs_count);
> > -       if (ret)
> > -               return ERR_PTR(ret);
> > -
> > -       inode = alloc_anon_inode(vfio.vfs_mount->mnt_sb);
> > -       if (IS_ERR(inode))
> > -               simple_release_fs(&vfio.vfs_mount, &vfio.fs_count);
> > -
> > -       return inode;
> > -}
> > -
> >  /*
> >   * Initialize a vfio_device so it can be registered to vfio core.
> >   */
> > @@ -282,11 +264,6 @@ static int vfio_init_device(struct vfio_device *device,
> > struct device *dev,
> >         init_completion(&device->comp);
> >         device->dev = dev;
> >         device->ops = ops;
> > -       device->inode = vfio_fs_inode_new();
> > -       if (IS_ERR(device->inode)) {
> > -               ret = PTR_ERR(device->inode);
> > -               goto out_inode;
> > -       }
> > 
> >         if (ops->init) {
> >                 ret = ops->init(device);
> > @@ -301,9 +278,6 @@ static int vfio_init_device(struct vfio_device *device,
> > struct device *dev,
> >         return 0;
> > 
> >  out_uninit:
> > -       iput(device->inode);
> > -       simple_release_fs(&vfio.vfs_mount, &vfio.fs_count);
> > -out_inode:
> >         vfio_release_device_set(device);
> >         ida_free(&vfio.device_ida, device->index);
> >         return ret;
> > 
> > 
> > > diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> > > index 50128da18bca..1f8915f79fbb 100644
> > > --- a/drivers/vfio/vfio.h
> > > +++ b/drivers/vfio/vfio.h
> > > @@ -35,6 +35,7 @@ struct vfio_device_file *
> > >  vfio_allocate_device_file(struct vfio_device *device);
> > >
> > >  extern const struct file_operations vfio_device_fops;
> > > +struct file *vfio_device_get_pseudo_file(struct vfio_device *device);
> > >
> > >  #ifdef CONFIG_VFIO_NOIOMMU
> > >  extern bool vfio_noiommu __read_mostly;
> > > @@ -420,6 +421,7 @@ static inline void vfio_cdev_cleanup(void)
> > >  {
> > >  }
> > >  #endif /* CONFIG_VFIO_DEVICE_CDEV */
> > > +struct file *vfio_device_get_pseduo_file(struct vfio_device *device);
> > Sorry, this line was included by mistake.

