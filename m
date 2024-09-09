Return-Path: <kvm+bounces-26124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7A61971BF0
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 16:00:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 907682840BA
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 14:00:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B18B71BA882;
	Mon,  9 Sep 2024 13:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jp/bt3tE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1811717837E
	for <kvm@vger.kernel.org>; Mon,  9 Sep 2024 13:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725890273; cv=fail; b=M1g5VvLp9MJPbo0CID0E68xJZtjifasEiuxKMoR9RjggHhhBvxU1iSjEcTTfsdX4XFp3pNCnnqPhVUNXfKktY5V1VZH2DgTux1uVwmpi3y8inrH8YtzJ8ZsKSaYeCk6Zbq3JnsHdjcuHQNlf+wqZz/CkAcW6jwD2ZPJI//E4GsQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725890273; c=relaxed/simple;
	bh=CfzYr8Ya70WYmEyPA4FH+rHMJn3sX/DSVI0WvshBsyc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QxNKgKhpIhCdkoKa5NoeEc++eaBGPPa0StdjheQEiOzHLKuo7mBahH2IQK7BgF12r53BmdEvaT+593JNjSeZkeagRX8b6QDoWMA9YS6i/jdC646gl/vnfj/SXzpHYy+XZw/eZsQyWW/QnFyMejV4gyKriAwRpjJmQIeR6xjM5cg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jp/bt3tE; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725890273; x=1757426273;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CfzYr8Ya70WYmEyPA4FH+rHMJn3sX/DSVI0WvshBsyc=;
  b=Jp/bt3tETg+1QsujK5BeYCopYHdvyWapRg62KybSg1JgZyHXhRB9k8vz
   ddMlkbUTM95dH6iYazj9cdLuDfA0bvqV4hq6gwf+XQYQQU+ymJ/5eVu7T
   CZHH9/Qnyg8KO3oO44iUG45BM/v3RT8fs2e0AxQQenAZOQVQQFoIxvWQL
   iR9YJQYAJcaHsMIJ5a/rbH0pLZzrQgIyAWsXuxJ4fKbK6n5DgVDM8TCKL
   378T1GmYMsU5LFbuHs044tKDFDEo7v5y1n/L4DallpWZq5rnhJ9AMysnu
   14Zo4pbbANUfiPO9cVSeVzUebIfuN59NnMw+0AbQxyhgCVL6tBvTYwZ5c
   g==;
X-CSE-ConnectionGUID: YiEUuB3KR+eTNwJMKgZvdw==
X-CSE-MsgGUID: J6mf13aQTTm+1UlCiFPJSw==
X-IronPort-AV: E=McAfee;i="6700,10204,11190"; a="28367743"
X-IronPort-AV: E=Sophos;i="6.10,214,1719903600"; 
   d="scan'208";a="28367743"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 06:57:52 -0700
X-CSE-ConnectionGUID: v7wbMiG2SfGAJmxAEkjqYg==
X-CSE-MsgGUID: HUco8zmqRrWebI8MENNYrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,214,1719903600"; 
   d="scan'208";a="71641476"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Sep 2024 06:57:51 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 9 Sep 2024 06:57:50 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 9 Sep 2024 06:57:50 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 9 Sep 2024 06:57:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZdixcYZRU6QfjD4xGIjvcCnrUrEeESeGCnFuqnpzEZigu9w/PF24/MI4H5f3S9BI4UWFdopu/mu5GErgAAp/RNC5TRXhqSnGBadHoOGF7A7O0wHAID0xpdtvQK+vKtWEigoFbjFdHO4qX6YuURu6cBcoQjRzwZdNlv3d/CMPl8CCzvP3W6Ebd/P/C1I4zQ96rIPJACGDx4/KTu5C0+8zB7CYwhflondNa0igOjwZvXGFcJdfaxZW4cdFdle4LiEnNXRyfzb2NCLrltfFCQ86aobhPtW0B1YVJ3j2oDgR2dV6rxTlzzdU+E+S2wlgjBXy4FcgviiHQ70vpLwHh8Hucg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eGVTh6Hzj2X60lhCvN56CXGwWUCvrfptkr9ODOjNQvo=;
 b=kdqjl9QliepkY5F9NvMVAOqAqyu8sfObS4PuTwqHoX7P2HcZ7VCNzylfJr+CI/k1RoZg3eu1azNgbrjPlcblZlUI1xDi5fggH8G3p+1rP/4Fg4QxU5bE7cdDOkV/rmgqPCBUu2AfN2ftX8TX7kkSnbDXyVJJPQh3+0ZvIhNBYF8hAoKYmUKM94+DIfMo5vPCUDZHzLYALQnn0I/hsAki1jVV9YrWWds55GcE0IAEyrzuv0Be7zwr7qEE8A1nyN/2wX/Fv00FR2yogji9W9nQ/BsOBRM+uKspEwrtHRiELMETocWPknh9gZf/rq2w2ZVcDYqkA+dVI0ItaXOUhrzadg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA2PR11MB4938.namprd11.prod.outlook.com (2603:10b6:806:fb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.28; Mon, 9 Sep
 2024 13:57:48 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.7918.024; Mon, 9 Sep 2024
 13:57:48 +0000
Message-ID: <32b4cbc5-ed7c-4d4f-98ee-029b6e1d346b@intel.com>
Date: Mon, 9 Sep 2024 22:02:02 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] vfio-pci support pasid attach/detach
To: Jason Gunthorpe <jgg@nvidia.com>
CC: "Tian, Kevin" <kevin.tian@intel.com>, Alex Williamson
	<alex.williamson@redhat.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
	<clg@redhat.com>
References: <20240731110436.7a569ce0.alex.williamson@redhat.com>
 <BN9PR11MB5276BEBDDD6720C2FEFD4B718CB22@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240802122528.329814a7.alex.williamson@redhat.com>
 <BN9PR11MB5276318969A212AD0649C7BE8CBE2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240806142047.GN478300@nvidia.com>
 <0ae87b83-c936-47d2-b981-ef1e8c87f7fa@intel.com>
 <BN9PR11MB5276871E150DC968B2F652798C872@BN9PR11MB5276.namprd11.prod.outlook.com>
 <4f2daf50-a5ad-4599-ab59-bcfc008688d8@intel.com>
 <20240909130437.GB58321@nvidia.com>
 <bf023188-ba72-457c-b1df-7209be423567@intel.com>
 <20240909134048.GC58321@nvidia.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20240909134048.GC58321@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0192.apcprd06.prod.outlook.com (2603:1096:4:1::24)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SA2PR11MB4938:EE_
X-MS-Office365-Filtering-Correlation-Id: ede2af50-1262-4865-3ef9-08dcd0d7633a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QXc5REd3K3ZtcEgrdWtvRDJTb2ZvenN0OU9BWG9rcDZZN0ptTEVZVE9jUDRH?=
 =?utf-8?B?SkJDYjNENEpERjhxeDgyOG5RNitCUmtxOUVlbEhOS0ZCZEFsdjE4M2pRajNE?=
 =?utf-8?B?NGptTWZPcjIxMTlNdncrUC9VQXcwVGpTUS95aWFZdUt6ZmlQRkZIcS9reE1P?=
 =?utf-8?B?c2Y3WHBuZXdXajRtRHEzRU4xeTVOcFhSMGRsR0RvRnBwKzJWTDNzWXlLOXR3?=
 =?utf-8?B?bjFoYUNtQ0d1WEs1K0daKzAydGpKam03RklZK3FxNWExWlBZSmFmSmVzUFZv?=
 =?utf-8?B?Q1FTdGp0V0N1RFRnTVBaNjFlU0F0RCtXd0xWQ3JndVZhZjZEVEFNNHFBcVU4?=
 =?utf-8?B?cS9oNGZaRFFUVU5VS2dtNFNkYWovNDZIM0cra2FNeFcwR01iL2Nrb0xGVXdM?=
 =?utf-8?B?STJoZE96SnV4U0QxR3ZadnlFV2tNdEc2WmZsdE1oSEYxWW1wR3VkUFBBUCtL?=
 =?utf-8?B?cWk0a0VwL3dDYy92aDNUbjRsN0R3MUUydkhGUlNFclR0Qit5TUJoQ2dTKzFY?=
 =?utf-8?B?NXhDaVgwUDlzdzljNFZFUVJLSS9vN3lydGhBZC9hc1RnYTEzK1ExTWsvK0R5?=
 =?utf-8?B?UFpucjl1S1F2VHJRY3JhQ2pDVDZ2bEpDZGIwalhKN1hLQ1VuVXN5V2psdkRO?=
 =?utf-8?B?OGY2Y0NHejJ5cnJuYi9vdlBGUFl5RE56TVJyODZOQTl4NEFZVVZwakJiMmVW?=
 =?utf-8?B?cTRLTEpsbTZwV1B5MlN6QTUxNU5icENJSE9WTm8ycTlHYTloeFlDYlJPbllD?=
 =?utf-8?B?cFlLTHhiQVg0Y1kyT3VPUjR5cUJqVjgwZjBWa2dzdUlLR0xFUUN2S2xHQ2Fj?=
 =?utf-8?B?b3ZZZ1Y1dVVPTlN0ZTJVNmU2Q2lNM0ZmNzVNK3ErTFRBS1NYTllyUHBxcWdN?=
 =?utf-8?B?MnJWU1RVbS8zZDlIKzZUMloxaWRKRFYxQ1gwUTQ1WWJoUVhoTHZYOHhMeDYx?=
 =?utf-8?B?clhxeVJDZzhyaThoZ0hRK0V1QWJ6QkNtSTNTS0RES3ordzRnUU1ONTQvN1Nk?=
 =?utf-8?B?YVFjcTFzWmhwWU5mY29ER1Z6cjlzbWhCZVZwbHhyWG9IK01ZTGZhdjU5d3pN?=
 =?utf-8?B?d003K2ZVOTBDYXcrc28xVFJJaGp4UzZPRmh2WGtKNG5PZXNVZEVZaVlYNGdR?=
 =?utf-8?B?TzBBN29YbDY4VFcvV0pVYkhUWHR3em1samU1cVlwL0ZUQno5S28xTitXSEhk?=
 =?utf-8?B?b0RRbDJlWHdDNmpNN21pZjhiNzNPamZhZThCcXVHY1NtNDZqYlpoV2xkb0pV?=
 =?utf-8?B?YUlaTzFEcEpDSmwxM0hYU0RNblRNWFhSQWdIQTVTVGw3ZTV1TUk3amdsdnNZ?=
 =?utf-8?B?MkNBS1lyT1ROM3hwc0F6WldRc3JxYkVHSFdycittL2pHVndEbzJycGd5MVc2?=
 =?utf-8?B?YmdPSmZLb25aV0F2b3Y5dzZXMkFzZFdtTUhDTGF3YmJpQkhvT2RwV0pKT1Bu?=
 =?utf-8?B?Wlo3WTNZUUc2SVlOU2ZtbkhiMjZTd2NET1NaY3RtV0JLaEJXREZ2V0REL2pC?=
 =?utf-8?B?N1JSVGNTNitydHNoSktnZnh4SWw0KzFxTyswRzFLWWlQMkRmbEpEdkxvYXA2?=
 =?utf-8?B?dDlEWTlRRjR6aVlwbzFCMzM4NmVkaHd3Y3BFNHYxYTREZmlsdFErQ1JDeitu?=
 =?utf-8?B?UXRVbFB3VDlMNG51R3F1MEpSZ3gzSmZtQ1Q4a3prclZIVmpJdGdBSzJ1WXZW?=
 =?utf-8?B?VGdGeFVZcjJuaTRyM1RiaHFBYkJHTVJ1QXVQVWFxNkFCSEY2Q0xFenpsUFNZ?=
 =?utf-8?B?TmUwWVQ1LzB4MXFQT3VJRndVUUNrZGNZaUpMNFduQVlpT3JMLzNlc3lrRHRW?=
 =?utf-8?B?RzBEcUMvUVRiUU1qVkR0dz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aUk1RDIxZjRJNFI0Wk1FTWp2UVBoNDRTaDNuSlpFUk9wYXhkOFhQcDdUV0xD?=
 =?utf-8?B?bW1mOENiZi82VzF1Q2JRVVYrVlhtYVp2TXlZVUdXK3k0NWNzcWdtZGZJdlFC?=
 =?utf-8?B?bm9INzhZQUhYaW1pczdrSDRQVGprck5VZHZ2SUNFTkRHeFMzWDFwRCtndHNS?=
 =?utf-8?B?ZmJPWXBWQ3dCVkNhZTFkZGxaVlNHcGNrL1orM3orbHBTMURqa1VNWVEwYnda?=
 =?utf-8?B?TDVFNkdUWUpncVVtVjBHeCs3NFovQWdjVXI3VzlMUWhNNURCTThhVXJNM2l4?=
 =?utf-8?B?dm1LQU43UTFMSWhDY1U3eFFNUjh5enNReUtLaEl6SUlmSDkwZ1NlYnZFQUh6?=
 =?utf-8?B?TUVrMDVzY1ZRcDdVd0Z2MnJoNmZYRUdKR05qb2NWdFJpaFpEaDE0Q1VTYnhC?=
 =?utf-8?B?RklKVDZJaXFuMUx0TE1jeFFlZXNnNldHK3c3Vzg2Z0RrSCtmeWdYTGlnNmRo?=
 =?utf-8?B?dWlpQ0JrNGJEc2RRY2tTdzV6cTFMYld3Vzdtd2RDQkc5VEs1NlgyTHR0WVFj?=
 =?utf-8?B?VFI4YjM1RFRDcnZrVlZ1MDQ4d3FLWWl3WTE3R01QMU5XczZTVEZHVUJDSnZK?=
 =?utf-8?B?M2JocjVMTURGWGRLeUtXTDh3U2dSUlNPbERZYkxqcjhNZWord0JJY2pLQ3dK?=
 =?utf-8?B?bFdObjl4OVAyZk5TUVNaNVdUYjMxNmxhMWk1bExtRytzeWQwOFA3dk94QTUr?=
 =?utf-8?B?Wi81eEhJTVBsVU1nSlFadFJISDJjOGlidkpOVHlZYXBuV1lFR3lpUHR0V0xQ?=
 =?utf-8?B?RDAvNFNrVlBobmNUc1lUWWh4amU1UC9FckUwT3psUnlzd0JJZzFMZjlTeTRu?=
 =?utf-8?B?Z3JhTmVaVDhlWmhnN1BBNC82TDh3NnBnMDhWNmE3MmlNYk1tb2RMT1g2dTBU?=
 =?utf-8?B?L1B0L3E2TjQxOTdJSFZQWmRsZ0ZiTG8vYXFWdnJaQkdTQ2xPWitiTTJsWmlk?=
 =?utf-8?B?RmF2aVNEd3hpUkUwSVFtTVQ3YW5qSW1QcE5tNzBkUlovSVh5Z0w2Y0Z1eVA4?=
 =?utf-8?B?UnQ2UWQ2TGlMZEN5VXk4OERTQXlpOXBaS3YybGVKeU1WcVYxVkZCK2NVMFBC?=
 =?utf-8?B?dFN4QnkrSEdaUUo0aFh6aXdiRGNRVHdtdGdIL3NSejNoWWNkY0M2KzlRQ0to?=
 =?utf-8?B?b29uWStkWWtXR0dHcDBiMjZQcCtaeExYR09FTXBsN2FzQkxvcTNOQTg0MkZT?=
 =?utf-8?B?bHhKVDE0UzVjaStCMlJXTERpTm9mLzJtYWZDVzRISFkwRUlYMDJYZy9xOHFD?=
 =?utf-8?B?REU3TjNZMFh4Mk9hc1BSd2hCTjZWc2IrQmNMOGZlY2VEQ0ZvNmFteDc4akow?=
 =?utf-8?B?S1prTkZwZ3FtUklxVUg2MUd0MDYwZUdZaHBCbTI4d0c4ZEdGU09JL3FMbkVL?=
 =?utf-8?B?VEU5NnFxc1RORmZqa25nbGt5M2VoTlZDelgxOCtGTnhwdXdpdXhmMU5hbWZL?=
 =?utf-8?B?WEtpU1l3aWcrNXEyYXNOalhpU2ZmTm1XRk0xVlpSeEtoQW11T2MvSnVhbThU?=
 =?utf-8?B?WmpRb0ZWSW9FQ1VJZEVZWkpSWWFHd29ucmo0NmhiWUx1VXJlZGNvejdJRDll?=
 =?utf-8?B?ckY0ZVNoN1hxaW1KMUpkcysxSHFYVXJGTzNxd0xIN21PUWhmMGg4QzRIUlNY?=
 =?utf-8?B?Sm5qOHJhL0xobjRqMzlSQUZwRGk3dUEyNDU5b2pvb1RaelkrU2lOYWVGa0xX?=
 =?utf-8?B?M1pSalNlQ0s4d01YNXFtTTBRTThXcnRraWpNV050enJMOHpYbFRpalFQcUJR?=
 =?utf-8?B?RWFpczRuYi81ckZWaHpxL2RMc0dHQmlPc0MyLytWUVZEUnd6eVYxV1B0a3g1?=
 =?utf-8?B?ajNEN3RQOC81LzlBcHVHSmM4N0paSC9ybkJZNW5FUVlpR3ZZWlZqTVlWbXVp?=
 =?utf-8?B?TUZSNlRHZnZ3dXExYndLVHJaQjY1VVNxeVRrbVVjcXh2SlJKeEViRUp6L3hk?=
 =?utf-8?B?anBoa3BIK0M3bmhYNmtnaVc5WGdQdldsN0FvWlNuSE13SXUzbkhmNzEyZ2V5?=
 =?utf-8?B?YTF5ZytCMFBpTzYzMnBRSzQxMU1wSkdFU2lqZkppUTZSNldlQ3A2U2Jva3J1?=
 =?utf-8?B?TlUwbXNuQUl5ZnhaSmxuaUlrdHBSWGtENjBpOXFOUTZOYmc4dFhoYkRqU3VJ?=
 =?utf-8?Q?VlEAX1Yy3KnvMXHsygnBWR6pk?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ede2af50-1262-4865-3ef9-08dcd0d7633a
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2024 13:57:48.4896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X+J0IONDfNCtkI1jU1nMsw27spEs/pG+R6YoMs++52/Z8H721IKE3KnDPgxFhzzeAwCJP5G2k5g5grkt5ABWzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4938
X-OriginatorOrg: intel.com

On 2024/9/9 21:40, Jason Gunthorpe wrote:
> On Mon, Sep 09, 2024 at 09:29:09PM +0800, Yi Liu wrote:
>> On 2024/9/9 21:04, Jason Gunthorpe wrote:
>>> On Mon, Sep 09, 2024 at 08:59:32PM +0800, Yi Liu wrote:
>>>
>>>> In order to synthesize the vPASID cap, the VMM should get to know the
>>>> capabilities like Privilege mode, Execute permission from the physical
>>>> device's config space. We have two choices as well. vfio or iommufd.
>>>>
>>>> It appears to be better reporting the capabilities via vfio uapi (e.g.
>>>> VFIO_DEVICE_FEATURE). If we want to go through iommufd, then we need to
>>>> add a pair of data_uptr/data_size fields in the GET_HW_INFO to report the
>>>> PASID capabilities to userspace. Please let me know your preference. :)
>>>
>>> I don't think you'd need a new data_uptr, that doesn't quite make
>>> sense
>>>
>>> What struct data do you imagine needing?
>>
>> something like below.
>>
>> struct iommufd_hw_info_pasid {
>>         __u16 capabilities;
>> #define IOMMUFD_PASID_CAP_EXEC     (1 << 0)
>> #define IOMMUFD_PASID_CAP_PRIV     (1 << 1)
>>         __u8 width;
>>         __u8 __reserved;
>> };
> 
> I think you could just stick that in the top level GET_HW_INFO struct
> if you want.
> 
> It does make a sense that an iommufd user would need to know that
> information, especially width (but call it something better,
> max_pasid_log2 or something) to successefully use the iommfd PASID
> APIs anyhow.

I see, we may define the IOMMUFD_PASID_CAP_EXEC and IOMMUFD_PASID_CAP_PRIV
in the struct iommu_hw_info::out_capabilities, and add a max_pasid_log2 to
the struct iommu_hw_info.

However, I have one scalability concern. Do we only have PASID and PRI that
needs to be synthesized by userspace? For PRI, kernel would need to report
Outstanding Page Request Capacity to userspace. If only PASID and PRI cap,
it's fine. But if there are more such caps, then the struct iommu_hw_info
may grow bigger and bigger.

-- 
Regards,
Yi Liu

