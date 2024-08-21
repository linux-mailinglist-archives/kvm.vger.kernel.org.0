Return-Path: <kvm+bounces-24686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 19AC1959430
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 07:40:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 694D51F23B30
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 05:40:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09B5F161936;
	Wed, 21 Aug 2024 05:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gskp8jBd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C7D1547E5;
	Wed, 21 Aug 2024 05:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724218840; cv=fail; b=eNLnxGV3ijmTmmoVgWjYPh97YRJf4E9cpSBSWWTdijwevpogjhpvNXOy7M27kUlIVJ/DyVHabrlymSGm1YWnL2uj+uLwaHqP0f2kzUlXvUPGttl4hoqJzEsgdhYDAfAh5spmQY8b3TOh8l1Q7sVkKMiALU8NVRYMmkr/0OBQqsE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724218840; c=relaxed/simple;
	bh=1fPcYd4h0n/eNnw1luX1WeTcwr4yOjpPN94VhsUQhOU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PGM+qdPcwIPDKI5UFIr9OOOaQmPiiMIGV4/VtTZPOkOovZ6iRXrJLu8BekCyw/vbpbuDLPNlWRDc8yjDLGKRwcEFrV+pawGe1b4HJNJhWu+81PDmppqmjT6/oSXGB8betSHMVF9B+qUYoErhybRGyKR6/sbGHY7Fh+1V2nRx5So=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gskp8jBd; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724218838; x=1755754838;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=1fPcYd4h0n/eNnw1luX1WeTcwr4yOjpPN94VhsUQhOU=;
  b=Gskp8jBdcqW96vkU56+T9UvMt/qVIMLrkAuAe9hdr/g70Q9ab/V+pZFC
   aoa2Z76Cnsca2eFLMnwHBjMVZpbND+xO36lPIMvHCQGtEHxxc1lrXn3k9
   DlFmqk/0QEfpgSVAx11xFkSIOV6FDzMCscRmdfk9Cd8QWm3Ppe2sIRQSl
   sdGnTXWmAWADamy+TouhJBfKI2tRxSEfUh4Qzy7hs/zakBC0kwHqG/dpe
   mDEKabM1Ign62RAx4bY+CmF6EF+Mr4fLGBKvC+V8wbQ22GZsogyCuK0U/
   gCOzNIoaj3lFMGwpUw7pqc9ceiKh8MdqCm/2WCjkrTxH0f3jYQ77/sBYe
   w==;
X-CSE-ConnectionGUID: q9XvY/c9T3Wz1/IXVJAljg==
X-CSE-MsgGUID: XKDZPFk8R/2p66WIVGkuaw==
X-IronPort-AV: E=McAfee;i="6700,10204,11170"; a="45084213"
X-IronPort-AV: E=Sophos;i="6.10,164,1719903600"; 
   d="scan'208";a="45084213"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2024 22:40:37 -0700
X-CSE-ConnectionGUID: +nlRSnCIQ3CFJjy9ADu34Q==
X-CSE-MsgGUID: DtN/mnI3S5i5jlyAdGTxbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,164,1719903600"; 
   d="scan'208";a="65815502"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Aug 2024 22:40:37 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 20 Aug 2024 22:40:37 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 20 Aug 2024 22:40:36 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 20 Aug 2024 22:40:36 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 20 Aug 2024 22:40:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kb2xXH0jlcj+xYO8McE2+Mwx4YbL3d89plNuXU8jkrRCklLJSIf7UiIOhNB9ej6kEBbrQOq/JqFcUkrAymsMC7o+i45+K55Mg1VlHKApha01C/p0w9Q5CG6jMHQFG4e2T2Ie2QKy5IUzmhYc6OqnDtylc7tXFqX5CcfENXKgUsGmkaW6Alkc1/Qz5XgY5CxbGadQdRHCmCc45qJIAu5tfpvcFpwAID8gIuolnxSJYyqgEVJS3HGsco6lD+qLU1ekl2b7j1HJPDcGWKozUJqNgNJuqO4FZ2LFEs+mXRg0ZB8INeulbnhkm6gri16EOsPswdq8aoRja6lNzWs8Hkyisg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rpwz36aLCHOhxbkqNEx3MQz2bliUlEbtTlBn7aM4u8Y=;
 b=cM2A6AFV66tQRNI5ohu4mUMugyBVQK/tyhL5XHdPtdSazF5tlPYnl4SHCEDfU1WkfTpQhO2B7ak9h+imUwng0SJG1G66UoruCiwmcTJLzSp/b89/RbS2c0KlcdyEcHaQZua7j6CJQ3OonCWaAbGH9G36QVpVJvS5XT/MSZO7oaP6XadxZYD669ClSvawD6D59Wz6i7Sf4aRBwHa8PkIGZXkAwND0zOlOzLaiKoEYsB1pq5SngJhDX/h//75mRSPdhWVRfJAICiQt1S2M2HGd070/X0SPDr01AF7i3WiTf/JImROyeR551ersQwJanQQo9a2Yj3zk7tTbBXdxbKqhKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CH3PR11MB8704.namprd11.prod.outlook.com (2603:10b6:610:1c7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Wed, 21 Aug
 2024 05:40:27 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.7897.014; Wed, 21 Aug 2024
 05:40:27 +0000
Date: Wed, 21 Aug 2024 13:40:16 +0800
From: Chao Gao <chao.gao@intel.com>
To: Suleiman Souhlal <suleiman@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<ssouhlal@freebsd.org>
Subject: Re: [PATCH v2 1/3] KVM: Introduce kvm_total_suspend_ns().
Message-ID: <ZsV9wDXDoUMSNWgm@intel.com>
References: <20240820043543.837914-1-suleiman@google.com>
 <20240820043543.837914-2-suleiman@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240820043543.837914-2-suleiman@google.com>
X-ClientProxiedBy: SI2PR04CA0013.apcprd04.prod.outlook.com
 (2603:1096:4:197::6) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CH3PR11MB8704:EE_
X-MS-Office365-Filtering-Correlation-Id: 1aaa160c-c327-4973-075e-08dcc1a3c30e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?zOd7+MRULEnsP7PwKWeyPZig3jlf31d+ABIyHy0xfhcIpiBwkXYoQMfQ9f42?=
 =?us-ascii?Q?Fhm64GUE+miPZsd/zuFIycw9WDS3H0X+dj408lepiEjyWqf7+jumBE6IxohX?=
 =?us-ascii?Q?hWPYBUgfkicTFh22ySEGk1DZxvbxeDDEgIp96PIL0CkMyDW4/dZjyrvLipTt?=
 =?us-ascii?Q?orFL3F/VPFgk9ab76ycyZNbur4JZoSsV3tQSVW04tcXmaXa/DlUx2tGVyI5s?=
 =?us-ascii?Q?VXfQZA42DvrRjUJZHBLsRtCFxsEQG/WUB5MoRhZfI8e2Paj9sY2ZFddWJ9mS?=
 =?us-ascii?Q?Dt5ogHOyAOGWPn/vKBLEPDPadQ3IX0GwjkYm9UdtGzPkh2T/0rvvtck3Kcz3?=
 =?us-ascii?Q?/JBAUYEd8jZgh2eIyV46BqESvI+eWPdtmVlpZlSf16wYO8CnAxxqE/pwlZfM?=
 =?us-ascii?Q?FGWp7K96khYnU2C9Vh+1F6hQtjmGcrgq1M0VvZ40qOJWzTUBRJiHxx8FzlhV?=
 =?us-ascii?Q?8CszB9pRVIQycdISVUETPDcGiEp6Kvdc8jfsl/r511/uQ4+3cfUdGxlRnVM/?=
 =?us-ascii?Q?FQc6iDGpdAK2GAl/WORO82YaYUv8LlWltK9h/3VkT6cbfFeZbOgDGs/0Vw+e?=
 =?us-ascii?Q?f+5ISqKadyEVK/oTj/b+1xic7AvOkGX27TN7smlwBQ72dDbMGv+UY6uURfp7?=
 =?us-ascii?Q?4hzDCyqlEcVVIGw6ljxpPsaNIUwltrKi93ksLD2tflzfvGv31c0xckJK2oKH?=
 =?us-ascii?Q?2gBavtTFeNej/RgOlmt4Ht0VEFdLCYfe5BMaBudzBfPdHdTh/4uiv1QO7rS1?=
 =?us-ascii?Q?pv27MTcU6V+e9F8ys/hUzYvn50aQnuXzSBqr6geJK9vDu1zO+VorFC7l0KVr?=
 =?us-ascii?Q?P8/yK8WhDvEwVwzQB+Epe26b5HVOUu7G3A1hu4zs8T2Easj6jFLCPCAGpKP1?=
 =?us-ascii?Q?96Bh7gjSC8VZD1BO34kyRL8DbtrR4HIL/xSsa+RD576AlUo+MMucYSlNAQo3?=
 =?us-ascii?Q?SrZbIqeiORkOucCqPXnpZ8XTY5abwZYFbpHJuA3Un/3ivXZ39pHvCGSlbxqy?=
 =?us-ascii?Q?ZW9TM7ceVLPLuBvff/rtQJtdLXKPFVNPtQbrjJHrLiSZ9C6D/nXhh30IeQes?=
 =?us-ascii?Q?bJx/E6xdKv/8rcewu04RoBzox9wEzzWAim6ni0BXC5Hsv+Iy8IAp9eCtIell?=
 =?us-ascii?Q?e/Slo0qKadYZdPGJjjx65+8ukfljcN6dwM26a2YfmF1aC+1XEUMS+rUMSkUr?=
 =?us-ascii?Q?NPg+DN57YFmrlVvhAS1ZGZqD1oL7jhSqjRECPg/rKKWcZky+d3Om2GLv/HfU?=
 =?us-ascii?Q?HGOtWNdwkdpl4pKpx6e51kg06J3ZAw6dySGN6S/RZqmz5VLyY4lxKdhmogMC?=
 =?us-ascii?Q?l9t10PSPvlz43us0qXDcv0gqwuPmb0ulhoiYsSj8xxoSAw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Nioeas6yPkebl8N/U1sRQwsnwk+RqVwFNcdUa8yPrGT8tuwVpe15lHG67xig?=
 =?us-ascii?Q?E6CbyudaRCbT5b3gIIozoQOqC8/cD2VoKJlIm2cDB0HTkuptumJKv3H+Lu7N?=
 =?us-ascii?Q?J4270N8OY6/ivzGx079o2Re68d+v+QH7Mw7RNqrIMh9MgWREHqAzQzZwBtzp?=
 =?us-ascii?Q?OwsDr4HerGEAJaHs6zKbHuoJw20GTxNvvrYFwwalnfWLHJvUmBcAdJWDWsIE?=
 =?us-ascii?Q?1qOu6FwARnAG/CxbiTZ5wn8e2iFrhEohgqFGrJ/6Rb3KYzjpFB/4SO54l5n1?=
 =?us-ascii?Q?c/fwuv132OA6YmANlLG2NyuL6xAn0iQnoOosicTcw67vrGto6Zt2vWq90lXj?=
 =?us-ascii?Q?UbAjY8FHe7BKc3DIWok7qBAjUlr7eT1kQo88kWXrQg8JnjvgwShTdpUAb03r?=
 =?us-ascii?Q?iVED0diodISXQ1LgkQ+Tk7X8KkDtuSxwWaq0cm0G7Eh8LgmhiKMxpKlOL5oB?=
 =?us-ascii?Q?Om+Fca4pd+g549uCnW+6bSHyn+FY+uBMrWTEGAg6GA9IqvM6yDiKLA4PgDne?=
 =?us-ascii?Q?3oJbF7qLGUffY7ujEKkQ2kpBJM1lolcoy8MtdhSeck5106Z11l5BAN1zEN/h?=
 =?us-ascii?Q?0jlYtGoSqNfpcz6Gn3Rir+0r5fUXp6PSxS83BK4Ljvt277YJh8tEapiD7ne+?=
 =?us-ascii?Q?bC5WkIU6r9SKi7zCwjQLc9eyYJitoYAuYMPCUB/Cz51W5YZyAVg2eqB9FIMt?=
 =?us-ascii?Q?y4bRRLK2ffOpGU8Z1p7pyTigy1PX4lCR8gauHuUwclMWZQh5Gbx+z7/b0uzD?=
 =?us-ascii?Q?/hGhGY/fimJeRUpdw/fGJhvTVdqSk0fm4D6YomVqDkwpRatf+9x2z8SZgoKf?=
 =?us-ascii?Q?BN9cwz/Fgjpg0cp6eILH+so7jjct7gDvTFp1hAQ81BqTOUc+/+DjfFbr9Ir6?=
 =?us-ascii?Q?2srJDc5C8sc6WFOrDZ5HVOntStWJ5J+iXQ8k8Yo4vE1vJt7Zw3MgEvC45OkT?=
 =?us-ascii?Q?+g5y7mXwFfPQwQVbgQeTpIOHUuF3Ww+V4tOJ8fKD9Y0umKC1iMrdUSzER732?=
 =?us-ascii?Q?/Al47d/v3B4HpaC6YirM1+cIt9lXDm67cMSDtXjCpDUZnz8lSPJXil7CXBgL?=
 =?us-ascii?Q?X9bddC5R5/ZFYT/1+ef6jbmD86a+PPiwTJLEdavslkd/8ZS7J4DmOP/S88TS?=
 =?us-ascii?Q?EFcLHfU9rKD5iRJavpHTw0+I0YHhS99pv4pByS7oCbUyWX+htYUn3IqtjYHM?=
 =?us-ascii?Q?dDUfb9FK/qoCS3qeZLcxVQtjZvHIeHWsuxH8/3DBx/RfnfSnd8LVRwWLhheM?=
 =?us-ascii?Q?X5SYTeaFgbQE4SbXdC4swOv5RvpHNepsH/i4bwUb1D9FRImWl57jFKCOoavs?=
 =?us-ascii?Q?JU0uA2Kblj419s6p0RXYhbSTFTly0cAFeCJqCi9eIUlmMQTf3I31XDe+8N3+?=
 =?us-ascii?Q?bxiCSHpfHU0dAwtCmlcM0tnjmLP5YWMgXw+Zso9Kg7IGjRrcEKj/7KlklUid?=
 =?us-ascii?Q?Ma+BOxtwJzHBl5KQKOPNe8XWOxPyIQv/EVJZHFHMyoxwMuah8dnK40XGUzDz?=
 =?us-ascii?Q?YoEvmSRWIeMUOVVHyVkd+XTFksGjgF3Q0JPxTx4d4w0beYymgWYFW5IpyyAU?=
 =?us-ascii?Q?lHUNgN8e4e6kpvSq5WkdmWqDY/STu4VNpJLMbhJH?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1aaa160c-c327-4973-075e-08dcc1a3c30e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2024 05:40:27.7074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FSCtv6wy5qHOaBkA9jF2xWrclBGEMZohm8oLDQLqaqsh+m+hSllWplNjeR4XKNubvlrWLXmGXkC9XBNloz60jQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8704
X-OriginatorOrg: intel.com

On Tue, Aug 20, 2024 at 01:35:41PM +0900, Suleiman Souhlal wrote:
>It returns the cumulative nanoseconds that the host has been suspended.
>It is intended to be used for reporting host suspend time to the guest.
>
>Signed-off-by: Suleiman Souhlal <suleiman@google.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

one nit below

>---
> include/linux/kvm_host.h |  2 ++
> virt/kvm/kvm_main.c      | 13 +++++++++++++
> 2 files changed, 15 insertions(+)
>
>diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>index b23c6d48392f7c..8fec37b372d8c0 100644
>--- a/include/linux/kvm_host.h
>+++ b/include/linux/kvm_host.h
>@@ -2494,4 +2494,6 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
> 				    struct kvm_pre_fault_memory *range);
> #endif
> 
>+u64 kvm_total_suspend_ns(void);
>+
> #endif
>diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>index cb2b78e92910fb..2235933d9247bc 100644
>--- a/virt/kvm/kvm_main.c
>+++ b/virt/kvm/kvm_main.c
>@@ -5720,6 +5720,15 @@ static void kvm_shutdown(void)
> 	on_each_cpu(hardware_disable_nolock, NULL, 1);
> }
> 
>+static u64 last_suspend;
>+static u64 total_suspend_ns;
>+
>+u64
>+kvm_total_suspend_ns(void)

nit: don't wrap before the function name.

>+{
>+	return total_suspend_ns;
>+}
>+
> static int kvm_suspend(void)
> {
> 	/*
>@@ -5735,6 +5744,8 @@ static int kvm_suspend(void)
> 
> 	if (kvm_usage_count)
> 		hardware_disable_nolock(NULL);
>+
>+	last_suspend = ktime_get_boottime_ns();
> 	return 0;
> }
> 
>@@ -5745,6 +5756,8 @@ static void kvm_resume(void)
> 
> 	if (kvm_usage_count)
> 		WARN_ON_ONCE(__hardware_enable_nolock());
>+
>+	total_suspend_ns += ktime_get_boottime_ns() - last_suspend;
> }
> 
> static struct syscore_ops kvm_syscore_ops = {
>-- 
>2.46.0.184.g6999bdac58-goog
>

