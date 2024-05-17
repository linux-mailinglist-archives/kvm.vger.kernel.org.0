Return-Path: <kvm+bounces-17594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AD42F8C8518
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 12:47:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 364A21F23120
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 10:47:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D3E53B1AA;
	Fri, 17 May 2024 10:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DTPt3nGX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE4439AC3;
	Fri, 17 May 2024 10:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715942836; cv=fail; b=kw4iYgYVpNOMrLOrxUgsdjU6oiY1tAShHQIEimoI+ikoq+i861JRMLxc7S7rSd4eQu26z9VcH7p2fq8yVEbA5FQOPOMGbOmtMfAIawNBogs7b8UvcWWkedj1cTmO5lrsyE4LcV5mUBNsBNLrsXl5y9pX4R6Nz//j5+hUcp6G9rU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715942836; c=relaxed/simple;
	bh=OehvJMq3/x4Y4FAvRUcrPXD34f8bWVh5DYj9TlVbsKY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=E62NwCm0gPCVKEO3xuQBHk5jArojrH89b2taIniIahvqIPG6hZqpU/IFH0ArciwOPqBojvTbkwgZ6HmqeosffC3sJeaf5Jwqv23orgmSSrBgYGAi3dhJnGz98LWKOmt/w96UUGIpZYyKZD7FrOhfQNapvwq6UFEkYkG3B1Hrp6o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DTPt3nGX; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715942834; x=1747478834;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OehvJMq3/x4Y4FAvRUcrPXD34f8bWVh5DYj9TlVbsKY=;
  b=DTPt3nGXhmNzjyqESN9d6r/evI3UmdB+JNsUjGY3Fv9pBDaxZwmJ77CJ
   maFR7gM14/9VDcsUjioWwT2gL7iJJMebd2X1BRv7FYU5KuLaYAuHsGeLK
   IU7nVSWO9Kpo9m6aFtN6DmkBKwfWZba4TSiYftUllYc1npSYZg5e5ixg/
   yFCkBLoHmwP1X/vV7K9Nxef9kx7qlOXaok9RbpBvgPYSxQEIpLsFiZRLW
   hGKF1sxcq3q4/dEQRxuqLO4ZDto10CpZ5d6lUJvGAgr5rZcMK+UVYCHAM
   Kr/RbKBjr/JU1ws/LVep0dSKL1JQfyLnfiBxiakUEXu+Gp8bSsVhdWb+u
   w==;
X-CSE-ConnectionGUID: nMqPeg1kQY2MT2q3PvFFLA==
X-CSE-MsgGUID: TJ9ib+t0RPyfN9lYkdP1fQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="12055343"
X-IronPort-AV: E=Sophos;i="6.08,167,1712646000"; 
   d="scan'208";a="12055343"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2024 03:47:14 -0700
X-CSE-ConnectionGUID: GCpBksl3R1i6/sEdXfn/7Q==
X-CSE-MsgGUID: vpBgHK1IRUuc+iEhyFVkJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,167,1712646000"; 
   d="scan'208";a="36657331"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 May 2024 03:47:14 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 17 May 2024 03:47:13 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 17 May 2024 03:47:13 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 17 May 2024 03:47:13 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 17 May 2024 03:47:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SHTUYlokLLs8zuzqRAOIgv8uzRhQiDho3fl9E8nwOzWGtovdZR2yXwkEgGDAI+BjHyqljilnSWDzOJApRxNo4ZAY5PaU90ZeGqGxkEVrJEH0vAtnglfJwIniu+U6mDD9Ay9O7DQkfCKZfi9RgVG2+e0ZsxqCFgdw437J4RbF45cP9b5MYPyZnREk3VLOoeSGoUCajjW6z7BjkuOkEJhrcpY4RCMoqrHibqYDKlapK+3A1PfoDsGNOBD+SZKrGU6eIUYr2ZKWtUwR/ftHVr48WmWt1Aso6bgzb6l9zyrv9bJxntE4H8MPbqFORQlcL7/qwAF4JeYv1a5fUuMUzhId3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tXaBUuy49Xz52zl/NB7LHBAI7JeGiz56ETDMyvpAK88=;
 b=OmF3lPIBx0ZDU/1RopThNqZJgiztGNYX6X7Tg72Ai6TsM9PzRl5tM7iauXHL2SyMz1ApEltGTfItwrS9Cbto8BANRSH6t+Mq/+JXZ4Acy4EcneChdsMvghgjYP6wsYqdVgyNcot7si3H6OV0ZUW/m0ioaBrca3iNpraMpoZZX5hXehLkNSACf9CW4mbcQbeWrjA+is82pJQT0+eVfDJdB19WU+wQT0AdtVeZnGy6N5Vb6XldELttEZGiO6Hhpzq4q9H5jC0h9f4qliAY8cqtbKRkivhcVQYPqJe/6Vr1JGGYUP0UDksm0J8RWLZnP546/stRHzbcCPv9h6stprO0QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB2535.namprd11.prod.outlook.com (2603:10b6:a02:be::32)
 by CY8PR11MB6937.namprd11.prod.outlook.com (2603:10b6:930:5b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Fri, 17 May
 2024 10:47:09 +0000
Received: from BYAPR11MB2535.namprd11.prod.outlook.com
 ([fe80::391:2d89:2ce4:a1c7]) by BYAPR11MB2535.namprd11.prod.outlook.com
 ([fe80::391:2d89:2ce4:a1c7%5]) with mapi id 15.20.7587.028; Fri, 17 May 2024
 10:47:09 +0000
Message-ID: <0b0aa4cc-3262-4709-ace5-1fe3943e7894@intel.com>
Date: Fri, 17 May 2024 03:47:00 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] vfio/pci: Extract duplicated code into macro
To: Gerd Bayer <gbayer@linux.ibm.com>, Alex Williamson
	<alex.williamson@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Niklas Schnelle
	<schnelle@linux.ibm.com>
CC: <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>, Ankit Agrawal
	<ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>, Halil Pasic
	<pasic@linux.ibm.com>, Julian Ruess <julianr@linux.ibm.com>, "Thomas, Ramesh"
	<ramesh.thomas@intel.com>
References: <20240425165604.899447-1-gbayer@linux.ibm.com>
 <20240425165604.899447-2-gbayer@linux.ibm.com>
Content-Language: en-US
From: Ramesh Thomas <ramesh.thomas@intel.com>
In-Reply-To: <20240425165604.899447-2-gbayer@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0090.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::31) To BYAPR11MB2535.namprd11.prod.outlook.com
 (2603:10b6:a02:be::32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB2535:EE_|CY8PR11MB6937:EE_
X-MS-Office365-Filtering-Correlation-Id: ab376357-8c5a-4dfe-2125-08dc765eb3d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|7416005|366007|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?U0ZqbDRYUnk3TmVodzZOWFBQMTliUStVQ1VBb0ZIQ2RBUFlTSE1ETjM5VVd0?=
 =?utf-8?B?YVpmWUMvRjJwNitvakR5WUV0cW1TbkVjTHNXWnFZc0pla09LVWlxZXczOUNP?=
 =?utf-8?B?clIvMHZmbzZUV09hRkFUbkExUE9PN01aYUxjTzZuZzBlcnlHQ0Jjb0NXV1lB?=
 =?utf-8?B?MThXa2VWaVdnc3Iyd0xoT2NUSFZkSnBwVjBVYldmdEtXeXRQbHpoN0xDTjFo?=
 =?utf-8?B?MGxaRDk4RThOS1dGN0lJTkREdXV6RWQ4eUtqa1d1TUQzNmd3ZGlGN25TVUs3?=
 =?utf-8?B?YnFOQTlZK1ljWmJhUHNRcWxUZUlwSnY1UUxwbTY3RCtHWlk4ZForWkE1SE5Z?=
 =?utf-8?B?SkQ1aU0yTUxrNFl6MkorN3VFaUdVNEZORnFIK294RWtmQTBGc0UwRHY1bDlm?=
 =?utf-8?B?dmhTbDRCa0JUei9YcEJ3UWxWVXF0Z2tQaVhsL3Y1aW90R3NvRjI0MEJXdG4x?=
 =?utf-8?B?aUQyTTZ2TVZtTDdwMlNhUjR6Rml5SmpCQ213SWliZ2o5NFNlbG5Mb0taSDZU?=
 =?utf-8?B?bGVWZmF3cEtxNkxxdjQyY29QakE5Y0xJbkVJbVJSRVJHakQ2dXZFNlFTRTJH?=
 =?utf-8?B?a1dubkVPZnl5RnpTa084SEZDRnRyTjJya0lBVjVoL1VIcDNudm5IVzhRUTkz?=
 =?utf-8?B?OEVhZWlTUTM5WlBqMUdIMUd5WHlBemF4czlGYzYvL3huTWkyVXFlWXdOTXlx?=
 =?utf-8?B?UUVJOWg2UEdwcE5BQytoZlR6dzNzZ0NuamdKZW5FUzc4YlRMZ2lNVXN5NTQw?=
 =?utf-8?B?SmlIeEtRSkxrT0JxWFF5bFY5RHBBekZaczZvYThuSEhqaWlLNEdrOVlIVDNQ?=
 =?utf-8?B?SGZBbEFuaDJKOGtvVU5GNk1NeGhxT3FKTmorNTUrdDRQNENGNlBQTFRoNGZV?=
 =?utf-8?B?L2ZJZ2NHZUVzK3VMc0FnZUtwMG1scG1rejEwVHlpT3E1SVJFVnoxTFpZSk0w?=
 =?utf-8?B?WFBPUU4zMmYxUWVvR0NEbUsrK3hWQkVnYWlTZUVzRUc3V0xVZGsydG1xWE9M?=
 =?utf-8?B?WkJqL3BkanhmTTZDNlBZcUZNQ2RLKzlwOWN5MCs2MzFRdFJOd0RTaU44VWJI?=
 =?utf-8?B?N2JMSHhNalQ3R1RzSmtKMXltT3JTdXpzaGo4dzczcWVmWlVnQ3Z2bC9LaVRh?=
 =?utf-8?B?MUNWdDRNbWZEQ2F2WWthTnhFR2l4Ky9sNjBKQWVXNlhKV0NSUUtxZnIzeFV2?=
 =?utf-8?B?ZnZMY05abG9KK1Zla0hPUnFLdkdab2o5ZEpqRzhlUDh6b2JYT3o1Yk9ueXl2?=
 =?utf-8?B?dUV1S0EvMHNETGEra2pQeTd0MHFIREhYekNBUzU0amtUYkZKSkVqbzl2VmlG?=
 =?utf-8?B?b2FyQ1Z4dUhlQXFNZ3ZiMmZpZWY5RGhCYUJmSnlpSEluT0VFTW9ybHlQZHRi?=
 =?utf-8?B?cVpmcldBRGRWSUxjZmhKMEZVT1NrODlNOVJsYmRXeEUwSUs4MkMzV25MOFB6?=
 =?utf-8?B?bWx1a2I1bmNlK3BsTXRFWXIwc1NyTVVlUCsxWElCMTVKQmY0b1JZNzFKTTJD?=
 =?utf-8?B?UjRDVjRUUlBlYW11dDBmY0tLdUtnZlFrSHJKTkRHOWVESnNNakEwRlNhTEs0?=
 =?utf-8?B?WThYOCs4dzBLZU1hY0lYRnBuQTIreGpjT3dERlY4UWdCelNXR0k2akMyU3By?=
 =?utf-8?B?SVdSNnFxTGg1MW5jR1RKdXlHcTMrSWtQRFloVEgxdjltUjliZVRVSmNFcGcr?=
 =?utf-8?B?ZW0reVFNanozMVYrNU44akVmZ2lrRU5zeFdkSVR1QVQ3VDNUNSs2ZGtBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2535.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?KzhEN0dTc3RNL3R1ZGNkNWRkeG14SU41a2NkVlUxeHdzN2dFenhmRFd2OTFR?=
 =?utf-8?B?ZzhDaUh5bnNhSU5MRnlqNU9OMFhCdE5PbGxxck5RbGswUEZZWXIvTmxPalNJ?=
 =?utf-8?B?QmMrWXEvOSs1YzdqckM5SngxVk02UEE0bDdaTkJWYkFxZHdBeXNOZHRsTi84?=
 =?utf-8?B?M0hKblhGcnBrdUJQcWwrNDA5YUlUSlJSNzlQVFVlMVBHNElLR1k2QlJHc3RZ?=
 =?utf-8?B?bUdub1Zhcmg3YVA0VVNMMkoyK21ZamtFM0ZOTE14OStxUVQ2NlN5b0dpdUgr?=
 =?utf-8?B?V3NTWkhUTW9ueUlnNmY4dDR5ZzJjZ0NOb2lZWXhaVExHK3BLU3Z1bGl2OXd1?=
 =?utf-8?B?ZkJPdGlxeldSZURrV1RVaEpHUjh1c0dYWlNUaHpGYUxrZVR1NXJDcm9Lc1lJ?=
 =?utf-8?B?SW1pK3NEKzR2S2VGejBSMG9LVFIyc0MvUnpPbktTeWU2WTgzNEVwaTg0c0RD?=
 =?utf-8?B?Nk1hZVZQZDZRVjZ6Zm9sUThDTDl5WTEzOHVJM0lHNWE0R0RFdUlXbUd6bVFo?=
 =?utf-8?B?ODFEaU1rdlBXVmNSYVUyUjFyLzFyZndxZitBbmdtZUg2NlIrVDZrcjBKQW5U?=
 =?utf-8?B?Z2x1VlpGYXRQcDUzUUQ1enlTbHh2dXpYcVdKd3ZVc0grTHcwNHFaeFcwejdB?=
 =?utf-8?B?OWs4V05nd21ibUdFT1djem1IUkE2VE1laHNNSHlwczVUOEsvNEFCVHkzbWNm?=
 =?utf-8?B?RVE1UHptRWN6Y2JPZ1o3dUlITDk2SWVyVjVDMjRyWDQzREdFVTFJVmxJMExJ?=
 =?utf-8?B?YmRxUGV2dE9JZ0Z0NmpQZDRpcnlBaVpWWDB5NkhOY1FYWW1pYTk5dkRVek01?=
 =?utf-8?B?OFlyY05oVVZFbFRTZkh6bW5ucmxpWTJhY1hLYnNkR1RyNE56cCtmTnQ3Z0NJ?=
 =?utf-8?B?ZFZmWXBOMlR3RExQdGR1L3FvNEVRd0tqRUlqTDBpbE9FTm1WL3Z1M0Q3eGdi?=
 =?utf-8?B?Zk5ONnpMTzJFSWdTSUpqTlN3YkVMOXUvbUM2dVcxV2VSeG5qazZ5R1VhZU1P?=
 =?utf-8?B?dlJsbnBPRHhXcEFuVWpKTVlld3d4RzI0WkJGT3MxaTNQNkRYRmRYRDVhWjI3?=
 =?utf-8?B?dStORERBMnd1Z2h5MXdJQlkwbUN1Wmo4QTduSFpOaVZrL1FLN243U1N0TWxp?=
 =?utf-8?B?V01US1dVbWx6SzJpbEZOSC9jQjZwNTlQWThxTU9Td0lGM0tIRm5qa0M2UUZu?=
 =?utf-8?B?NzZmK2JsMVBkZUFpYTBBckMvc1A1SlJMWWFMQUJXVWJRQzhPZkpmVytFai9B?=
 =?utf-8?B?dTlXU01qWXJhbE5MQzlKMVRVQnc3OFRlWjI4d0NDSzZOeVVvc2lmbDk5MDd4?=
 =?utf-8?B?MWs3TTh3dWM3UDJYTGlPUzhOdU5ab0FKc3AvWW5pcnpJYUsvYkp4U0tnWDVS?=
 =?utf-8?B?Q1JweWlOS3pLVXRZQVNDTk90Nk1VOXN0R3lQalloVHQ1MWxPL1lkd3psdFJi?=
 =?utf-8?B?QmJBS0t5MTg5L1o2WXoram5uM1E2R0ZpWWYvcmxGNERFWEdIZ25lL2JKdTd6?=
 =?utf-8?B?NTZ6YzByeVFHZ0tYeXNFSU9GbXdlcjBRY1BiZmhUOExFTXlaU2UyUEpYdXFr?=
 =?utf-8?B?WDk1KzdwUkNNWFJnV1FJMDdPM0xKdkJPeFd1RXdjbG41YU4wRXZNWXhBK2gy?=
 =?utf-8?B?VFBGYWIwbnlNeTVZU0JTR0wrTUVNUE04cmd3U2hVaXdaS080NGFkcFNZdmI1?=
 =?utf-8?B?T2dPMFRDRXlwTjF2Sk9GWUNvRHo1bkl3ajc4OGRScGRrNDh4ZUxJQnkvbXQy?=
 =?utf-8?B?STBEaHltakdwVWFOM2gwMlg1SnI4L2pmMUpUSEhxMXhJNk05Z1VLWmJUN05t?=
 =?utf-8?B?UHMxem1QdUVMRmwwV3V2ckhXUldIUU1JYUlNT1dzZHhmbk5McE1kTmhZbHIz?=
 =?utf-8?B?bkx4dzA3NTZQU0FFdThpenBzRXV3Vi84SlltSy9HcTEvMTdOUE5yWjMwcVBs?=
 =?utf-8?B?UFR5aU1keVhMS3dpUEo0cnE4ZytxZUVVZDcwUUlwU3pVL1czTVZmQitOczlz?=
 =?utf-8?B?Y1Z1UnJVemdJVUdMNHNNQWxvNVFueE95aUhTNXhPbi9IMUoyOFhOb1BqQUNj?=
 =?utf-8?B?SDdHeWZIUXVrdHVZdGZyaG5Tc29qeUI3VkhjcHRZSmo0K1ZZR1YxZnd0UGwx?=
 =?utf-8?Q?oEmNH6LKBgF+HOnSNH291vNKT?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ab376357-8c5a-4dfe-2125-08dc765eb3d2
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2535.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2024 10:47:09.6391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oafhmp8la2XIBTWZy81EinMVTcuaRYAmCfx7MTw3tjMVP/652gDOEsY7nB+RIFOIm3b1+IDHHQggDBktxRcKXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6937
X-OriginatorOrg: intel.com

On 4/25/2024 9:56 AM, Gerd Bayer wrote:
> vfio_pci_core_do_io_rw() repeats the same code for multiple access
> widths. Factor this out into a macro
> 
> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Gerd Bayer <gbayer@linux.ibm.com>
> ---
>   drivers/vfio/pci/vfio_pci_rdwr.c | 106 ++++++++++++++-----------------
>   1 file changed, 46 insertions(+), 60 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
> index 03b8f7ada1ac..3335f1b868b1 100644
> --- a/drivers/vfio/pci/vfio_pci_rdwr.c
> +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
> @@ -90,6 +90,40 @@ VFIO_IOREAD(8)
>   VFIO_IOREAD(16)
>   VFIO_IOREAD(32)
>   
> +#define VFIO_IORDWR(size)						\
> +static int vfio_pci_core_iordwr##size(struct vfio_pci_core_device *vdev,\
> +				bool iswrite, bool test_mem,		\
> +				void __iomem *io, char __user *buf,	\
> +				loff_t off, size_t *filled)		\
> +{									\
> +	u##size val;							\
> +	int ret;							\
> +									\
> +	if (iswrite) {							\
> +		if (copy_from_user(&val, buf, sizeof(val)))		\

Another way to get the size is (size)/8
"if (copy_from_user(&val, buf, (size)/8))"

> +			return -EFAULT;					\
> +									\
> +		ret = vfio_pci_core_iowrite##size(vdev, test_mem,	\
> +						  val, io + off);	\
> +		if (ret)						\
> +			return ret;					\
> +	} else {							\
> +		ret = vfio_pci_core_ioread##size(vdev, test_mem,	\
> +						 &val, io + off);	\
> +		if (ret)						\
> +			return ret;					\
> +									\
> +		if (copy_to_user(buf, &val, sizeof(val)))		\
> +			return -EFAULT;					\
> +	}								\
> +									\
> +	*filled = sizeof(val);						\
> +	return 0;							\
> +}									\
> +
> +VFIO_IORDWR(8)
> +VFIO_IORDWR(16)
> +VFIO_IORDWR(32)
>   /*
>    * Read or write from an __iomem region (MMIO or I/O port) with an excluded
>    * range which is inaccessible.  The excluded range drops writes and fills
> @@ -115,71 +149,23 @@ ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
>   			fillable = 0;
>   
>   		if (fillable >= 4 && !(off % 4)) {
> -			u32 val;
> -
> -			if (iswrite) {
> -				if (copy_from_user(&val, buf, 4))
> -					return -EFAULT;
> -
> -				ret = vfio_pci_core_iowrite32(vdev, test_mem,
> -							      val, io + off);
> -				if (ret)
> -					return ret;
> -			} else {
> -				ret = vfio_pci_core_ioread32(vdev, test_mem,
> -							     &val, io + off);
> -				if (ret)
> -					return ret;
> -
> -				if (copy_to_user(buf, &val, 4))
> -					return -EFAULT;
> -			}
> +			ret = vfio_pci_core_iordwr32(vdev, iswrite, test_mem,
> +						     io, buf, off, &filled);
> +			if (ret)
> +				return ret;
>   
> -			filled = 4;
>   		} else if (fillable >= 2 && !(off % 2)) {
> -			u16 val;
> -
> -			if (iswrite) {
> -				if (copy_from_user(&val, buf, 2))
> -					return -EFAULT;
> -
> -				ret = vfio_pci_core_iowrite16(vdev, test_mem,
> -							      val, io + off);
> -				if (ret)
> -					return ret;
> -			} else {
> -				ret = vfio_pci_core_ioread16(vdev, test_mem,
> -							     &val, io + off);
> -				if (ret)
> -					return ret;
> -
> -				if (copy_to_user(buf, &val, 2))
> -					return -EFAULT;
> -			}
> +			ret = vfio_pci_core_iordwr16(vdev, iswrite, test_mem,
> +						     io, buf, off, &filled);
> +			if (ret)
> +				return ret;
>   
> -			filled = 2;
>   		} else if (fillable) {
> -			u8 val;
> -
> -			if (iswrite) {
> -				if (copy_from_user(&val, buf, 1))
> -					return -EFAULT;
> -
> -				ret = vfio_pci_core_iowrite8(vdev, test_mem,
> -							     val, io + off);
> -				if (ret)
> -					return ret;
> -			} else {
> -				ret = vfio_pci_core_ioread8(vdev, test_mem,
> -							    &val, io + off);
> -				if (ret)
> -					return ret;
> -
> -				if (copy_to_user(buf, &val, 1))
> -					return -EFAULT;
> -			}
> +			ret = vfio_pci_core_iordwr8(vdev, iswrite, test_mem,
> +						    io, buf, off, &filled);
> +			if (ret)
> +				return ret;
>   
> -			filled = 1;
>   		} else {
>   			/* Fill reads with -1, drop writes */
>   			filled = min(count, (size_t)(x_end - off));


