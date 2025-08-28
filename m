Return-Path: <kvm+bounces-56131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F20A3B3A45D
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 17:27:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 327B07A93B8
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 15:26:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D79E222A7E0;
	Thu, 28 Aug 2025 15:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SaHPDFF+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D264121D58B;
	Thu, 28 Aug 2025 15:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756394851; cv=fail; b=lW5EQ3A6h6/eKxT8IxKN7ainCoQ0JwJHgP9j5Ww0fZ+0bzAMifl8Op6gRzgDzaEh6sogpJqvdN1N+gzMZc8+3S/8bp/en5arQd03PH3jRix2tuPUUvx/gz9ns3gsSA/np0w3nHNv5xvExs7qKsb7HWCAmBdzrioXbigEvMLzoA0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756394851; c=relaxed/simple;
	bh=ow+N3wBCwk6tKSGKLqLCKGbxf+gvf7Megb59th2PE7M=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SDH4y/rMKoR+IyP00FUBpmxFAoA5ctsP0shJkaEOQ5k2nSu3QtCqCBUcmsglADbvR1GR6ZcuSl1LHmy3Om/ytKXQ7sjCIMWatBRZ5tloSkIYzWvhjhq/Y0x9c9oXDBR2Hz4mTxWXlEY4zbQLWLKNlgMz66aUzN6caCZLMnMZWBw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SaHPDFF+; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756394849; x=1787930849;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ow+N3wBCwk6tKSGKLqLCKGbxf+gvf7Megb59th2PE7M=;
  b=SaHPDFF+Lb8WJ7rL1Q2d+maGga2MHeA/LoujDIB9iaMnhWphChjoZA0M
   SwIXj6U+HhnKjKM8PCcZ5Mj2ygXzcl3wrTkZr4IvzapQ0eITTZ8HY9SCR
   FpQULgaThwgDZ6NjUYcPELO2Bv0E8bE5jRMLof68gsMuJbCLb8k0YVANl
   P+UHpRin2Z0u4AF7H8/nPFeCDDvKNP/zNoL3Y2OLUqg6XeL+xyjDCE0qj
   4vjNIzoQxu0hdwVeXQD8DQpGcqwreJcfhjh0LJKvPwhhJsMax0msowBYZ
   o/S0TdwiUUXq6k2IVRkgWmBdo4PPhz7hvSlkdZO/14SRjquBpaDEdw5+b
   w==;
X-CSE-ConnectionGUID: lm/rL+W0S8CaXxvMmEWJhw==
X-CSE-MsgGUID: H0WxpEfZR8aU3Z+1gYyMtg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="58594252"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="58594252"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 08:27:26 -0700
X-CSE-ConnectionGUID: ZFpk8i/DSwKLBmBzE9Qjbw==
X-CSE-MsgGUID: OhyPb7qoS/S7UbWHqNWN5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="174477947"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 08:27:25 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 08:27:22 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 08:27:22 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.82)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 08:27:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ULyjt1cYoVZ9vsg4XfPiTpqJc4LAfY+xwc/x1c40TGNrwyc5LhOKXQ4CIAhIf7GjhYN7yQC9NfTOc4PewCIn6aC2nUXrCWuvDNBeWE67T6O52T51p0inUxlS15VevW2bIA1y4YV8kgKolpctFEG2W/i6rIQhqNngxe28zYlf9gbRW6BxJlN0cQEk9GrerMykBzof1Tk9IcgxHOVy8zW7XKHFvzb5MExold0tGFSgclo4sJZGznx8/Vw1u/Yg40/fIqrBNTnb9llohNSE1Dlh0WngQiKLcjvpSS6hMTrVSPzLmfx5M/Sv2YRbEej/sTNT2rBhgWoo6GWMiOoVfhLmqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6HLh6ymyeW72SoOo/pHT8CJrGzfguPpoQdrPRZ+87BI=;
 b=iaUnHZsU84YLHrspQKzW5/XLtFT/bJSOXx68WnRh7tEpGSHubhjITGhC1d8/c4Cu4139XT00po1ojXRH4MQ+dDmYSJteGvSRmUbTrFEnLDAYmfA6CZ0BY/WBgozFjOIh0lGDRBEUXZf1PePMXD07uC6JCWDM9SC5BEC5vqcjB9bzUrRS8eKPiYTKb1Y4T1xZAWFj2JkDsj3DV81CqH8cuNBvV3VYZdQw3wvEu7/2G7T8TDvpgewioC4HQoMr3vIkPJu4xbcV9p8fP5uav7JPn20YiyTJE7UKm3CpwMeGtxiHOZ0yw4KCBp+Fl2wNPmoUOo1bVfgkBAGODs7RYOaYvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by MW4PR11MB5889.namprd11.prod.outlook.com
 (2603:10b6:303:168::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.13; Thu, 28 Aug
 2025 15:27:09 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa%7]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 15:27:09 +0000
Date: Thu, 28 Aug 2025 10:28:56 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Yan Zhao <yan.y.zhao@intel.com>, Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Michael Roth <michael.roth@amd.com>, "Ira
 Weiny" <ira.weiny@intel.com>, Vishal Annapurve <vannapurve@google.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>
Subject: Re: [RFC PATCH 09/12] KVM: TDX: Fold
 tdx_mem_page_record_premap_cnt() into its sole caller
Message-ID: <68b075b8a9b26_22d98294dc@iweiny-mobl.notmuch>
References: <20250827000522.4022426-1-seanjc@google.com>
 <20250827000522.4022426-10-seanjc@google.com>
 <aK7Ji3kAoDaEYn3h@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aK7Ji3kAoDaEYn3h@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: MW4P221CA0021.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::26) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|MW4PR11MB5889:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f2fb283-8319-452b-6d7c-08dde6475a48
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?e+Op2koXasORxdblahn5zApGHiz+hORzxB7+ZC4ot+GCNrtYH5YQzsqoRqoH?=
 =?us-ascii?Q?RgfFKyVWT+KuZ9MEBy7B+VaE2cPsPnNKWofYE8XESg6ChqLWZrK34TWCOC/F?=
 =?us-ascii?Q?ecICGBDUP4B65X0I7DK9BPwkv37by52rah7kdk9YxDIR0qDGdi/OvEqoAOvF?=
 =?us-ascii?Q?NUg/1Cz+ikCFgU5w+8oYA5TfBL6cbekT40hptcLrfWwWBffrtOwZSGtP0kmP?=
 =?us-ascii?Q?ZnWFOCuMSDzX1CkG+FnOkVvAe8NIJoRKbpxNa+6gKgRttWedaK/TE/oiTaNz?=
 =?us-ascii?Q?Sg2sCzMxC5dVJgFFL8RKUk4LBz23SkWnviC5ewkdLI66PT69PjJipTb5G/AM?=
 =?us-ascii?Q?syYokQ62h7Qwqx755/aYl3gnbzyFwl7Sk1zbOgew0x0tj4WC9ccu63cprDfE?=
 =?us-ascii?Q?SkIt/Mhr53PWSg3nVKgHR0edZGfgCtJqkigGn3+if1jhpv5TzaE9EPeRn/C7?=
 =?us-ascii?Q?okKB4fqri/VzKeEU2+2X3anVK5Wyrh4mm9F2XzX53mDArkvSpy3aAmtu8Hmq?=
 =?us-ascii?Q?s7YYGVK7J1Qup8nppT+IQmCRqvHxQnwVwFrZvbNOAagphV8sTYz/zuZYrLOv?=
 =?us-ascii?Q?/qdZrvGSMk+xs+cfNL5Puzb68yeDOmA7yCxQPZ+3C/HjizlqetIIGbelXvNl?=
 =?us-ascii?Q?aba7WReOhNotJ6aBxz2/I2qcV5WO6R0qzOkzGLOIRuxVLIixhXMqT8P5xS/4?=
 =?us-ascii?Q?zG0BpE85+riIGPx61qZ5lBa9GzgvY7OVk22r3sHTDas3Lsvbvt4E31zazFKW?=
 =?us-ascii?Q?gw5+jdTOhQey92D6KZOay09nbbg0dg5hGCMn1cla0OwqqkYThNveKiclfqXY?=
 =?us-ascii?Q?jEeDmGJkOhUDudpASi1E9P9Nf3omWb3B69+gxdgBcq8zXxsHzP0/xgJV95AT?=
 =?us-ascii?Q?RUn78JS+2yKecx0HdCenvgYcgLQ+vsRD8XvZRuhgUi7Qs3vdA+K6FFfL1JL/?=
 =?us-ascii?Q?ov8JkeBZV8ntC+fOITg8RVquab07rHPeWKg7tx+CyV9YoVkxm5Pzy9Zib53q?=
 =?us-ascii?Q?6KFRAlDK25/1uYHNsgD0OWmw4X/sBSinOyDoruTBMmipKcCJhAvMHsxoogzp?=
 =?us-ascii?Q?Hg960Jf4yHczX0UuAzuJjkdd3zFRdZ+inpuAALvyP4auE5BdpsMqhceCSILk?=
 =?us-ascii?Q?S3y9wMX6eJsFMSaj9zSLxslrcqM7QjzjQvgGb9W8t5qL4umv1n3k1GNllSLd?=
 =?us-ascii?Q?0VnCuzZpZGlV/IjR6OeCFei7NRAQkRlRraDTaiXJ5EUHoofY75SFNhdk4dp/?=
 =?us-ascii?Q?j/tdmundTkWME3SIQr9qX7l5VK5bNMd17EY/K7CJ1QmYUi2YMqcG+h7of4aF?=
 =?us-ascii?Q?HUHdPStZArxpFqv4GqUAx0Xwt1PnbWOIzIr3VLnCiQCwCsiGFWYR9gRhNaVU?=
 =?us-ascii?Q?u2aRJXRPbuyap0naZg62KZyQlSxl4OrKsmBl/ThIaf1euF2T30oz4liM4xNN?=
 =?us-ascii?Q?p1t9wjw3J34=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tPs2LSI7ToRQsHubHkpq7+F3HfHMFZScHc7ILsss1PQGZnyIBnHRRin4439A?=
 =?us-ascii?Q?gs+dAB/ezz27T0uUCWJ4tkWt/HSoGJBlvPfW+Wpkm04LDsrOOjTjeyfB9OtY?=
 =?us-ascii?Q?hu7t3kMS/hiGY0v4yxU9jlO04OqILqJvZU0Ciom0D0irc0GZqQeljxUkc4YD?=
 =?us-ascii?Q?r8+nVhz0coFBfG5WT93IfMU8HX7yP0G8UslIssh6XhlNNk7kwQ6BdOLFPUYM?=
 =?us-ascii?Q?CUAIG4LJuKLdTO3RXBIKusn1Z/hVJ08C9ZJ7YhXOwTWx2iXwiTVneDk3JMYH?=
 =?us-ascii?Q?sLVOLvz31j8eBKu7rgS59v78PbCrsYU55S/TX92+2hKusnLTGFKOloGBwRIF?=
 =?us-ascii?Q?rQegZMBlWH5yf+xhNNVU2qIaFpPW4v8Db5pOPfK6+0e7ZsedOLUqeDe6514e?=
 =?us-ascii?Q?paxxqayBZ05V/uet8/e2joGuzIJqQGzB2LDvwQzfHBKX2Ui1K0rqwDoJNcvK?=
 =?us-ascii?Q?6kLenIy/oaqgY/VhZ7hm2NMh0hO3QmUyaVmIDV3BwsLBy31VsiQT5Hk9eSrJ?=
 =?us-ascii?Q?UGvPvmZHDacPUA+gXwjUC0oqqDZabLVikinGYZY/pCdBSLUP2xM3I0GfW/iv?=
 =?us-ascii?Q?2Hup1Y/Gcjs+ocf0FOMMrL+TviHmyKpAJQdbBo00Gyj5eDPwHChGPoUMTE2T?=
 =?us-ascii?Q?CoHlxH0NBbXIWHGlJivp9vUIq8OlaUBeSd/+jwCw73bc7ps/WQsXDfaZA5nZ?=
 =?us-ascii?Q?Z8XarNtTrhQx9twEegAQ7lcW1m3JZYR3UpeFX8LGWW/L/S1Ypkj8oknF8ZIS?=
 =?us-ascii?Q?EcMUhAOn14dSXxG9YMv7Atkn5e2Ixib7ngHD05vi4qPSl1xwVCZLpk0OsrU0?=
 =?us-ascii?Q?RQ5/bEkVnxBBGj2cWCyfiUp/oVP2+EtrAx8QTdysKcKMG8B3NtZcuc/vTz3Y?=
 =?us-ascii?Q?+ylBWyx6vvKm3og3sZAtKE5p1CAGehuD+QBC+tJpBpOWSpBeAHudJUKqRISU?=
 =?us-ascii?Q?h3QBOAUNSVOIXePzkNPN2TFv5g0RiMqpVq3gYp00aajDh9MjvbXwPusOfNcN?=
 =?us-ascii?Q?Y3gd7bAosyH1sPFn53lCtmCgh+wWrZDAxfDuRMXvOkwhIpjpbglUu1zNskEY?=
 =?us-ascii?Q?taVRQA/S71cR3j/6M+oYV4p4UbACLoeBjUJD3rjGTteXYPzqbimKE00ExuU3?=
 =?us-ascii?Q?cJ4pp6LlOIdLqxt29I/UdlG+xMsGTgDJvnoohtHnlKTPIy3rGHMaMJmN9JJA?=
 =?us-ascii?Q?e6C7qVYk4eWuWIIGZTI45MIYjgZgsxvX1lVNoJ1csV19MiEMH4C5McuTiWcf?=
 =?us-ascii?Q?QyhulIZShYc+grwtFVvCCnOLxyBHjwqnF65bHUMTOgtAAK11WE9/siBhYFei?=
 =?us-ascii?Q?I3auWvjLOc509OlV9AfoRN9lDcpoOxrHDcPmaXfwzi7CaMvrbG6jq8HDLxFe?=
 =?us-ascii?Q?8baoPG/0dyM4xnvaduv9CGalaobqgvefogPQjuloe6fT4BQvqwbJ9exjPIPo?=
 =?us-ascii?Q?cq2q/1jenwTXY5Y5JkJ1SQoRvEnArXtASIf12YE19Pyjsq/2cCjKS3q2R2zX?=
 =?us-ascii?Q?O8uQkoDTXdQlkU1s+FVSDR18oRJoZHZjCxTJK463dH9Cfsgj5Gl0PhlEBd80?=
 =?us-ascii?Q?mi7+yynf5es3hQbypFg8U4qfZV/WfvUA0hrmUyrZ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f2fb283-8319-452b-6d7c-08dde6475a48
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 15:27:08.9836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ERT7mk5gM/JV28zgEFWxHtL5gf+T26yBuWgjpy93+H1O5GPJZN/FwmapHcekmcO08XA3xJDabm+j+y5q5Cl01A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5889
X-OriginatorOrg: intel.com

Yan Zhao wrote:
> On Tue, Aug 26, 2025 at 05:05:19PM -0700, Sean Christopherson wrote:

[snip]

> > @@ -1641,14 +1618,30 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
> >  		return -EIO;
> >  
> >  	/*
> > -	 * Read 'pre_fault_allowed' before 'kvm_tdx->state'; see matching
> > -	 * barrier in tdx_td_finalize().
> > +	 * Ensure pre_fault_allowed is read by kvm_arch_vcpu_pre_fault_memory()
> > +	 * before kvm_tdx->state.  Userspace must not be allowed to pre-fault
> > +	 * arbitrary memory until the initial memory image is finalized.  Pairs
> > +	 * with the smp_wmb() in tdx_td_finalize().
> >  	 */
> >  	smp_rmb();
> > -	if (likely(kvm_tdx->state == TD_STATE_RUNNABLE))
> > -		return tdx_mem_page_aug(kvm, gfn, level, pfn);
> >  
> > -	return tdx_mem_page_record_premap_cnt(kvm, gfn, level, pfn);
> > +	/*
> > +	 * If the TD isn't finalized/runnable, then userspace is initializing
> > +	 * the VM image via KVM_TDX_INIT_MEM_REGION.  Increment the number of
> > +	 * pages that need to be initialized via TDH.MEM.PAGE.ADD (PAGE.ADD
> > +	 * requires a pre-existing S-EPT mapping).  KVM_TDX_FINALIZE_VM checks
> > +	 * the counter to ensure all mapped pages have been added to the image,
> > +	 * to prevent running the TD with uninitialized memory.
> To prevent the mismatch between mirror EPT and the S-EPT?
> 
> e.g., Before KVM_TDX_FINALIZE_VM,
> if userspace performs a zap after the TDH.MEM.PAGE.ADD, the page will be removed
> from the S-EPT. The count of nr_premapped will not change after the successful
> TDH.MEM.RANGE.BLOCK and TDH.MEM.PAGE.REMOVE.
> 
> As a result, the TD will still run with uninitialized memory.

I'm wondering if we are trying to over-architect this.

Should we even allow KVM_TDX_FINALIZE_VM to race with
KVM_TDX_INIT_MEM_REGION?  What is the use case for that?

It seems a basic sanity check/KVM_BUG_ON would suffice to tell the user;
Don't start adding memory dynamically until yall have finalized the VM.

Ira

