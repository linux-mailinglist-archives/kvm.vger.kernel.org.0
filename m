Return-Path: <kvm+bounces-21633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A5CAB930F70
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 10:19:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 50087281385
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 08:19:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E1EE172BA6;
	Mon, 15 Jul 2024 08:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SvuMuV93"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A104C66
	for <kvm@vger.kernel.org>; Mon, 15 Jul 2024 08:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721031558; cv=fail; b=ohkrFtFzgE1GSGHWOeVpPr192dB83QYQ1EvDeSj+ZDgtXUdwKMJ3yd6KwQBWeu45aMIgZ6z60waz+kEIWb0A5RJBFbxXT7yfMLwdpyRcDFRDCJ/kv0fI8hdCv4sj5AsyhA5eSsYVfgwJ1pR9feDMlfYwQAkkrWFFiePwmB3T3hw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721031558; c=relaxed/simple;
	bh=RXl7tkzjQKpCCeaXnFSYVCy7oVv8/zeue5Um44xx8lM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dkauQJrMW4I4BIZxjWosiC0KwJaC37VXYfQ9UnrCrWZgfiduqtcbHD4JVWg3QeFGeoe3r2LfjluH9kC5ocTGM3FVyYBR7qDdgS4cZ+oHSnj3JiV90qWabk87H+1QxuA6p0Dhda437zHuWTVt0TVOIpQI6BE0P+ANohOEdf4ceC0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SvuMuV93; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721031557; x=1752567557;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RXl7tkzjQKpCCeaXnFSYVCy7oVv8/zeue5Um44xx8lM=;
  b=SvuMuV93SgWIPd8hwM0K3+x5EE5Liyt2EhWVZfr9qcBZHtbE1beFXHHQ
   qokupSof5FwViNbtjgQ4JdKdu5c0C+7wr5LP6z5rWAgv2FwTUfJ2XQnjn
   K3vc1zL76hePX9P1dN0N8amw7iv40grOBUCUoFgNTFDqMx7PdOlWmBXcq
   LZxne8nVTbJHX/2btFhBkKKa2v8pGDTor1NyJ+mAYZgBsLlmkFHzUTVMy
   dU2NuHP+3uHJPwfun3csfwznYKftSTCLiPMW/G8qeVEdksQ4vrXaI0tpD
   YRKuKzz2T0g8i06Hckx2iVl0pet5lMIWvTiDk7cEvi5mfX7bRxDBsnsNb
   Q==;
X-CSE-ConnectionGUID: 1b0ClKk1S4e6Ybm4Z1A8wA==
X-CSE-MsgGUID: gCyJPShtQgG7lShib2FB8A==
X-IronPort-AV: E=McAfee;i="6700,10204,11133"; a="18548207"
X-IronPort-AV: E=Sophos;i="6.09,209,1716274800"; 
   d="scan'208";a="18548207"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2024 01:19:16 -0700
X-CSE-ConnectionGUID: +ZyomAGDQN+73Ugplm9aoA==
X-CSE-MsgGUID: /jXyq12CRpipE4CeITsTZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,209,1716274800"; 
   d="scan'208";a="50307078"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Jul 2024 01:19:16 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 15 Jul 2024 01:19:15 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 15 Jul 2024 01:19:15 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 15 Jul 2024 01:19:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uRB5B4yKJfgVllMxaOxKv7uktyBuXWCOLpdVFgo6oEvWY5TBJ1v3jQU2xN4LT0/Kbe+oSXBaj0dSGRtNwBxo7nDaUimQ2Fl4PoiA6m2oJ+D3DdepGseiQX9/EvBougw6mqnJnLwg3h60S/Y31fKHWC4i1SsBqVwVOZziaw44ENG4dF+MkSd+zDHZ4Dr1+hsTERhc8gpN/6rCL8a9x15Z/nI4ThGF9xoLx3/wAB01PvCz2Gc6CQuhLkASj7VVhVFzU/wOJPraSJzzH1XgFOcEFVNpLM2bztYFCn8xAHP3pgHVGWLWnb7TbHcY56GU9cEuiRkJh0GAU663DxzsIADRgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LU3uPcbFpCrajIX5Gj6oTFRwHzfRSSZWJ6OXIgP3sRg=;
 b=MaXXapuSwgxJHtqrxW7mgqZQ+RXJy4d3WeRmCVrTyt55RGRdnCjfOG5GY3ljQcks7Ut7zI9KkfCKznfpaCf5swW+MdSvpklQEus+dEkRwtiSqYsNM0Z+ACxZf84uXj2gfUBxmhiMqy6eej/fyFD5NwPESU836sbdcwfkDRAVRgmAJvPrME9kg3YglKZ93oSlMSa8ablNi0GhWZcr5VykB3BLzo6PZD3YsIE0ZBcmud4SZo1xqQk9o3pFsx4RDMvTTOAfEOLB1FPY4an1JqlmuRO+RCNeTk7U5Un9D9Lf9jf0BHywRNLb6F9e+1NbU/yof8jke6420qAe6z+uVtddmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA0PR11MB4576.namprd11.prod.outlook.com (2603:10b6:806:97::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28; Mon, 15 Jul
 2024 08:19:13 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.7762.027; Mon, 15 Jul 2024
 08:19:12 +0000
Message-ID: <a3848458-b41c-4ef1-ae0e-28bf5f3ad43c@intel.com>
Date: Mon, 15 Jul 2024 16:23:07 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] Make set_dev_pasid op supportting domain replacement
To: Jason Gunthorpe <jgg@nvidia.com>, "Tian, Kevin" <kevin.tian@intel.com>
CC: "joro@8bytes.org" <joro@8bytes.org>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "robin.murphy@arm.com" <robin.murphy@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>
References: <20240628085538.47049-1-yi.l.liu@intel.com>
 <BN9PR11MB5276F74566E3CBE666FCD3BB8CA42@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240711184119.GL1482543@nvidia.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20240711184119.GL1482543@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR04CA0004.apcprd04.prod.outlook.com
 (2603:1096:4:197::22) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SA0PR11MB4576:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d5687bd-3356-43bb-7c31-08dca4a6cf2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TlJIekxnK01INXlEdWd0L0E4VVlPRlp0VEFTRVU3d1A2UG5iS1Q5bUVhWkRw?=
 =?utf-8?B?WnMxV1dmZnI5KzhERStHTEZIV3A3Rk9vYzNUMGx4cmp4WE5rV1pSWnFmbjI0?=
 =?utf-8?B?dHJYMzdBdGlJcFRhSCtmUzRPaHBPR09MZ01heFFrbXZBYWxqVTBaTUtEMkUr?=
 =?utf-8?B?MkRqdWh3M3RXWW5DOUpRTzJOaWdFS1h5anB1N3dISHZ1VWg3bm9EdS9zN0xx?=
 =?utf-8?B?b2cyVmJJWk1PRTY4Q3ZvOXN3TzltRW53L2I5d2JaRnJ5L3NxNkZ4bUE3bVI5?=
 =?utf-8?B?WHNTRXo2TVNOcEp0bVdRR3NsUWlnd05nc1VucGhyb2M2UmtBdnBLWFJJc0ht?=
 =?utf-8?B?Q2dmL3lPRXlTT3BKZm44M2VaUGE3cWNPN0N4UmRsQ0FtbEhKVE15QUYzd0kv?=
 =?utf-8?B?OWVld05hdDZEQUNucTVLZmtzcVI3NnpHaUt6V1JvcG5PTHNVdXFEcis0K0pj?=
 =?utf-8?B?OWtyMFF0MlZ1b1lRcCsyZWI3bHlGZFI3YlRaL2kyRFNQYnoxM1M0TUIvR09G?=
 =?utf-8?B?eTVYWjBSYnMxaGlUbHFnY1dEK1lwOHBnQU9Wbnd4Zzg5c2xlYXFqTDlkMEZW?=
 =?utf-8?B?MVpiQkUvc0RMRWNYa0JXSUZ3bFkwbDZnQzd1QkhJajArVWo4TTZER0oxUThZ?=
 =?utf-8?B?Mkc1WTlrTDhaOGoxc1VxRFFySkZFaG9WYkl2TWpGMzdBdTl6dDcxZEJGaUpm?=
 =?utf-8?B?SGJ1aVZNdldOd0NzeG0vMnl0TWQ3ejBYSHFpWnRIWjA0eTdEVnNQZ3dqWjI3?=
 =?utf-8?B?YXJwbkxBZkRHWHRFc2EvN0cwOTMxL0Jtc2JtTDNxUlFqNWxwdFNOM3hKM2cw?=
 =?utf-8?B?QlVpcXhyalZnT1hUR2VET0VPdzdZN3VkdW5TVElldUtDM0NHNCs4RGVuNThF?=
 =?utf-8?B?REFFN1ZrNGhnSC9MdHNUQTFLT01VRHYyZ0luOExmMFdUQnN0OXBBaUlpNVJU?=
 =?utf-8?B?QVZCMWw3RW45dEJwVGthLzZFcjRocWIrbk1oZzdBcDVMZkUxdmw5WldZVFlW?=
 =?utf-8?B?eE1xdjk4a3hIY2RkMlBoQWpZRVIzQncyN3BrOFJpVEMyVXRoR3BLWVJQS3F4?=
 =?utf-8?B?c0dZQUpRcmdwd2kxTit0RHNzSVhaT2RkQThoUHNvZGEvRW1MSHdRaXhOREsy?=
 =?utf-8?B?MjZsUHBxNDVpTVI5dTVEeXFNbUZuNmhZZWNhKzhBWlBvcGI3QStJbXR6SWxJ?=
 =?utf-8?B?RWo5Mk40QmxBMGJvbGhGTWZVeDc1dWNHTXNENzlKajJiQmtzZHlSNFVjb2tr?=
 =?utf-8?B?YXRpcE9GdTlzaW5ySUJjWHp0bTNhSHllZXdQUUYwVW9Sb1p1VFFFL3U1UnpF?=
 =?utf-8?B?OUhvYVhEVVh2RmEvZzFGOUxsbVJTdG90cGFzOS9kMEI1RDFRUkp0V1grYmdn?=
 =?utf-8?B?KzhsMUZrZElHMlpxSXN3TlZWTUd5enpzTFZHa0RBMlBRQ0pyT29sclVCb095?=
 =?utf-8?B?UVVKdnlab2NzRVFIempRUmhCeklTbVQxTXRYb0lvZWlEYmE4MlJUZjhyK2NU?=
 =?utf-8?B?WXJzcTVZUnBBZkRqM0ptWjNuSDJaZHBYaTZZbWx4TzIwSU1CKzBQcFZmeTBQ?=
 =?utf-8?B?UnI2c09iOFZXTW4vaTJ3bS9saFpEQW5kc1RUTXpnUHNBWFQ1TGJUTUIyOTZn?=
 =?utf-8?B?enVXYUpEeUlLQTJmcVNHNjN0dTNpRkRHUm91ZHFrSUFDZ09xdmRNSlhpdjJO?=
 =?utf-8?B?Mlg3ZGtYRzdNV0xwNUFZYTA5MDM2Q01odWRhVEVZNTZ2TThNNytkZ3dSbnJH?=
 =?utf-8?B?enhTRGFYbXNMZ2xncUNBZ1Jlb3lBT1ZKYXF2d3NUM2tyQm1JVEJ4RlR3RkxS?=
 =?utf-8?B?SWlOVFV4RXRIVzFHU2hVQT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cFo4Y01LTlNTYmoyUDZyc0VkSmM4cjhYbDQ0cDQ1QzJDRi81dS91WEVTZWpu?=
 =?utf-8?B?SzMycUxEcklLQWE4Z0paUDV2blRjK2J5U3I5Sk9JTGN0VXFxOVJqNWIzUTFB?=
 =?utf-8?B?RmU2Yml2SmZ6Q2RRTE04ZzRHZFRzZ3lpbUZnVzNjcUo1M1dnWFFqT0UzaDhH?=
 =?utf-8?B?M3JDR21aWkpNZk94WVdpYWpQamVWakhFcUVocnFXd1g1OHQyRy8zbW1zcWNM?=
 =?utf-8?B?NWFpaEFlWmZ2Wm5MRFhramhjUmRsVzdUbmlaOVREamYyS0R5WTU4bTgzUHVQ?=
 =?utf-8?B?aXdzQXRLTlcxdHN4WDVJeXBZeTJBNUZiVEdvTkFoaG1qend5YUZNM2lBcDV0?=
 =?utf-8?B?UmVqeWplTWc4ZTBxL0ZVcEZnNzRzMDZNWldHYWY5ZWtrYS9PWWNaSE5iaVZy?=
 =?utf-8?B?Q1JGN0tpbktmSC9ScGw0blE5NzJwRHdrRjB0eHNob1ZNWjlOOXdMVGVYWFg2?=
 =?utf-8?B?Y2d5ZURjRmR6VzVzVXp1U3B2bDZIRmVIZkxMREV2aFBad0kxNG1FdDVDYllF?=
 =?utf-8?B?NXU5VkplZ0owMHY1Y3BmTDRoRlVEYXloUzJudU55TWNDUS8wWUhIWFljREhk?=
 =?utf-8?B?aHZyYSt4N3F1OStrVFRYd3Z2bVo1eUVUVnR3Q1AxSkg1MC9wY01oZkxlSk55?=
 =?utf-8?B?RUFUcS9iUDlnY3JoUXdDbE1yeGdHYnNQZlZMeVdZczRsSkxiOHVFQ2pFdWxl?=
 =?utf-8?B?c0JlWjNEZ0ZKN0VKT011aml3eUtLSUIxeGJhR0lhSnJrcGdoSncyM1pTWkNG?=
 =?utf-8?B?QzhOUVZlWE4xbVkxKzMyc2lWOFBnRkRDWEUvVHhoVnRLcE9jYnI4Z3Z5enpX?=
 =?utf-8?B?S0MycVRpdldhTVVFOTN6NzJJbEQ1YWg4dmRlUXZyMFhKTUZWamViYVVITUh5?=
 =?utf-8?B?Q3F1bzlCRkI3TlZkQlNEWWxiU3RRb2x6OEIyUGJLMUN4OXFpSGdPQkpyK2Vv?=
 =?utf-8?B?VU1FQ29QUEFra1pJNDgrOGlGNXhscElNRVlIdStYdEl4cGpCdGRKQWRCUXF4?=
 =?utf-8?B?cUQ2M0hGbDd0aGhlNXY5cXBjaUNjVllWT2gxZTMwQnVUdmo3T0ZReGhFMGJP?=
 =?utf-8?B?SSsrTW1sS1ByVUZsY2pyanJ2MVNaKzZyUTJ4ZDZnbDg5MHNIT1AwbDk1cmZT?=
 =?utf-8?B?TGs0cHdBakhwMWdNMExoSXpaSmd6Q2RBckFpa0NBaUM0eXhtYmdEcTA3ZDd4?=
 =?utf-8?B?Vmplb2JyQXNuekEzZ25BdjJGZ0h3bG5jWXZodVprYXJEQVYvMVYwUGI5WGQ0?=
 =?utf-8?B?REV0NzhaaW90YzJrc2NXazVoOWZXKzJ2cHFQVDFXNDRoeUVCOGZZVWcxYzJH?=
 =?utf-8?B?YnNYUU5SMVFaSGZkbjcvVThBMGJLT25VdlNYZTFIeGdGaDlWR2owYVJsRVU0?=
 =?utf-8?B?TjVVTmZOb0N4RGltM2lDSlMwTDV3UHVxc01WU3J4OVB5MC93Tmc1RkhSb2ln?=
 =?utf-8?B?endDSUJhb2ljRHBDVXhoa3I5cmV6S3ZSMUVHSDdIb29mblZTZFJhQTlFQTBz?=
 =?utf-8?B?QW1TV3RsMXRMNzEvTHNPU1h1NEZia3ZXUFU5RTdPZFNORDBZSDlMV1J5WTUx?=
 =?utf-8?B?S1VJN1dON2VVYkRPbUtaWnZZSUtkY2JZaWI2emk5NmJzUHpvOUpJNEhybU04?=
 =?utf-8?B?ZUZHbElaRzNXbkZkSlRuSXNUYzlKY2ZWMTEvanhlcmlEejBzSGlzcXlYV0lN?=
 =?utf-8?B?Q2krcmhWUjNYNCtWVWw3OWZXWTFEMFdBUG1NUGpEMko4bHZMSE5JRWR6RDNq?=
 =?utf-8?B?dHNxME53eDZUemNGaDVQTmE2Vjl5djRmSHRmLzJPM3haNHdYZ21OZmY3anFO?=
 =?utf-8?B?MlJEdHlYWHBwOFl0QmlpZzlBUG9lZ1BzWUE0Rk1FT0NhLzRjUm9IdkVOc3pZ?=
 =?utf-8?B?LzlmdVFTZk8ySEYwd25uNm8zVmZDMmVYeHNyMS9JYUxoUENtV3E5VzE3Zllw?=
 =?utf-8?B?ekwzT05CYVlYTUJtNzYvK3N3Q0VCK292T2Z5eXMzM3cxVlhlRXNCZklua3cz?=
 =?utf-8?B?eEZ0UkZaelZERU9NT296UzdGdkt5VENIa0g5aTNMc3pGZHczcm01NFMzSGxj?=
 =?utf-8?B?UW9hOG1Ub29iMHZhdUQ3ZXQvaytxR1QxOTRwNTR6dllZL1VKaHJkTXB1eTBY?=
 =?utf-8?Q?H7i2LNas9Kf83PFDxjcWXbe0E?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d5687bd-3356-43bb-7c31-08dca4a6cf2c
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2024 08:19:12.7765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YcXpeJiFdisENJJY2YDymVh5vkrqkFzTrPReFtiqeqS7QJGJBgZcJAer3OLO9lZbV7Olfmy9WLaIQRfOojvU1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4576
X-OriginatorOrg: intel.com

On 2024/7/12 02:41, Jason Gunthorpe wrote:
> On Wed, Jul 10, 2024 at 08:24:16AM +0000, Tian, Kevin wrote:
>>> From: Liu, Yi L <yi.l.liu@intel.com>
>>> Sent: Friday, June 28, 2024 4:56 PM
>>>
>>> This splits the preparation works of the iommu and the Intel iommu driver
>>> out from the iommufd pasid attach/replace series. [1]
>>>
>>> To support domain replacement, the definition of the set_dev_pasid op
>>> needs to be enhanced. Meanwhile, the existing set_dev_pasid callbacks
>>> should be extended as well to suit the new definition.
>>>
>>> pasid attach/replace is mandatory on Intel VT-d given the PASID table
>>> locates in the physical address space hence must be managed by the kernel,
>>> both for supporting vSVA and coming SIOV. But it's optional on ARM/AMD
>>> which allow configuring the PASID/CD table either in host physical address
>>> space or nested on top of an GPA address space. This series only extends
>>> the Intel iommu driver as the minimal requirement.
>>
>> Looks above is only within VFIO/IOMMUFD context (copied from the old
>> series). But this series is all in IOMMU and pasid attach is certainly not
>> optional for SVA on all platforms. this needs to be revised.
> 
> I feel like we should explicitly block replace on AMD by checking if
> old_domain is !NULL and failing.

yes, patch 6 of this series has made it fail in AMD's set_dev_pasid
callback.

> Then the description is sort of like
> 
> Replace is useful for iommufd/VFIO to provide perfect HW emulation in
> case the VM is expecting to be able to change a PASID on the fly. As
> AMD will only support PASID in VM's using nested translation where we
> don't use the set_dev_pasid API leave it disabled for now.

Does it apply to SMMUv3 as well? IIRC. ARM SMMUv3 also has the CD table
(a.k.a PASID table) within the guest. And I think this is the major reason
for your above statement. right?

-- 
Regards,
Yi Liu

