Return-Path: <kvm+bounces-30898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2755C9BE34C
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 10:58:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB83A28445B
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 09:58:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35D121DC1AF;
	Wed,  6 Nov 2024 09:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F5omJWCa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B8F1DBB03
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 09:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730887085; cv=fail; b=Uu0ZBzo3agmWw2jlXqYq7JIHEZR9NfdtL+RWtrm+ahs4d9HEk6Z6UGgWedEqqof+I64QXzD7/wDK8L7ELWpW+lfQ188oA36hDjxf5zjYbtH8MsAZZNMO6WEu9lPtgb+A7mKsDuXjWHAChR+pYNHeKJvAbS+DeFJ+oxaDYAmnxAY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730887085; c=relaxed/simple;
	bh=MBskHDZkfxZv85N9tFcr6oBsh5rKPdxtSY19E+cOh1k=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pZ8eyMNvv0zT2VnIEeSC35W8uRwNjHrt0SkKyRNuJ0uSGMSwUwsCmMCSltVSZ8fAVBtSv0k3TFnSaRWZqylerrLdLEhBrQACFbuQrzo0bOGfjYuGzVdXERK8Ikwm+wTmYPgqT4l63CQ53ps6tdqkkzqDL73TAiMu5J7PTQ4Qkb0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F5omJWCa; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730887084; x=1762423084;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MBskHDZkfxZv85N9tFcr6oBsh5rKPdxtSY19E+cOh1k=;
  b=F5omJWCadkHX4AlvwLtQWQlKAQiYbJ6s2NaCJa/CQnwwES/pchVLh/sq
   IwYNOWbTVy5d2WiOXUonsHr5z7aZbN2GfjB/DOPffLLNvaQZLj9VGqyGz
   t9WTT1DGZSFOvr2cBEQdW7nLAM7+GVLdho7EaloIgMGJtPsCLGIGTg45O
   YFfxj1LHAxpyF5Xu4gZ1Pg7LsiiyHX7Bx7KgvAkeYpzLUSphvnHgdYXtI
   SoXurZ3mcRA730K9flWHYaVjYPGnDsZ7VcnvvbUl4VFKlWlESD17ckEgr
   KQi0RHZleyFiaMrnBUEVyh/Fwb9asx0C+eGT+wVpWWuf3DtLQtVwt8LPf
   g==;
X-CSE-ConnectionGUID: QGwMu0qcTASS6/UZC+bG4Q==
X-CSE-MsgGUID: qMduXldkTlS4Uo2YBkIPxA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30857228"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30857228"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 01:58:04 -0800
X-CSE-ConnectionGUID: D26qRAZYQrGIJg8LS2rMZw==
X-CSE-MsgGUID: WFr8NDyGSTewtb3ho+lukg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="83993684"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Nov 2024 01:58:03 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 6 Nov 2024 01:58:02 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 6 Nov 2024 01:58:02 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 6 Nov 2024 01:57:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vwJ+GF/EwiHrRN6OqAZOfUUOh2a3XPHlpagq9vS62qPRnQ3mOZspwrltLfYMY6pc8AuMbpY7DxCj1MbDMoOdRuT2aY10WUUt8Q/8zzl0X8oIyhGzY0QKfW/lxmIoUQrgaI68sTAweaJiwhZEIECLXU4Lm38axAClqEJLPljLXtNzAVfN2QPiskGq8ZTzfw+qP8x/LxMucs6HBnTQSYtGP5xquPwcDDJA4AEsOQ9s7C4L0PRrKUkgmpemedJRZ3iznBmPwt6aHRaC9h5VF84hA56+jW8COQoVloHFDfFnlbT6jB8bc+Hlce+Bp3XrL5RCmmrpeHaGazHhl3yalhNO8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uvhaTZbxi/xd7UJNjaZOxlh4HNAQbfgvmVxkMd6l120=;
 b=Id1gyyWIGe1ifKeVTVS/9vyvTWxheg+mjzyZ3dKQMJXWm+b8UFsOOSkmAQfn28zBkZ3s5qYpjTWq/w7MXVE7A5dUFK/N+g7oE9HFtD2o5/M+3eVIuqnetr/vEfaodwHypfRbJrMsUc4cy76DW0AqNtd/iW6QcBujs2wK24P5kyWYreZBxwRYWqVuIgsG/4C1woAg9jaSW9THBQQsyKxUUM+qmKJOpvLkzLDIwfM4dqit0C/NKmTBEWJg26CJpxRBffC2SAgn9U4OGoPtvA6JXICXeB+oBaOpR6clRaCvhtqppUUfl3cvfqxtZy82DNhi+g4Xf3HrQf6Eyu1Jg/STNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA1PR11MB8840.namprd11.prod.outlook.com (2603:10b6:806:469::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Wed, 6 Nov
 2024 09:57:29 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.8137.018; Wed, 6 Nov 2024
 09:57:29 +0000
Message-ID: <30114c7f-de39-4023-819f-134ee3b74467@intel.com>
Date: Wed, 6 Nov 2024 18:02:04 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/13] iommu/vt-d: Add pasid replace helpers
To: "Tian, Kevin" <kevin.tian@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "vasant.hegde@amd.com" <vasant.hegde@amd.com>,
	"will@kernel.org" <will@kernel.org>
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-5-yi.l.liu@intel.com>
 <BN9PR11MB5276B9F6A5D42D30579E05E28C532@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d218eb1c-ca02-4975-bd6a-310a81b3d88c@intel.com>
 <BN9PR11MB52766A4A2C15C9C58F9513128C532@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB52766A4A2C15C9C58F9513128C532@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0025.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::10) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SA1PR11MB8840:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f37ba8b-cd0e-416c-d7bf-08dcfe496ca0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YzROQkZmVysySzdhVTBpTHc1d1RsSnlUMUFNSGVJd01XTnZrVUpqSkpSOW5p?=
 =?utf-8?B?R2hUQnNWRzBEdFR6T2FQNXdCLzFYK21TeTg5MG5aMjJkVmlsMDZRVFBVYTRM?=
 =?utf-8?B?SFhTVmZwS2VOWWR1L25abEx1NFR2SFFBUi9uNlR5OUtQR05McHd1Qnk0b2tt?=
 =?utf-8?B?SDh5ZWZYb2I0a2p0SVFRV1FsNytkSyt5WnB3Y2p3cWRtTHlLWEE1QW5xYUFT?=
 =?utf-8?B?STJkWE10T3FGVnM2akxldlV5WHNnTWNaZUEvRnkrNkRRRHBpTE1DQ1FpbWRp?=
 =?utf-8?B?NTU5Y1dNbFNMS2N6STRxS1JCZTJCbFBnQ0xMQ1FaUWdOdFdLZ1F3RjJSQXFv?=
 =?utf-8?B?cnZ4Q0JwcDlycjg3b1BqcmpmU2QyS2FEalo3QWZGZm5hQjZ1NkZVTTVYcS9o?=
 =?utf-8?B?WWNrZkt0TlJlSzJIdmg2dTduRGgxM01rdURLOVExaHdtTzJld3lVRHBQOEp6?=
 =?utf-8?B?QWdERG9xeXlndW5LdG4wSnlEM1lqcjN4MUV6NjdPOVJFdk45b3NYNUhPQ29C?=
 =?utf-8?B?S0RGLzdjSlF2anBvYUhKSEdlMUtlYVk1SzhSVGFycWFjR2Z1eGJXTzNOYWZV?=
 =?utf-8?B?cExvYUFPKzVPTEpwR0x6L3cyN0lCejVaUmVoUXhBYUU1QWFWNndCM01Mdm1s?=
 =?utf-8?B?NFpzK255MzZCQ3VOQ2xnN1dQcSsvemlyTEtoSmlyNGNqTjk0SlY3MW95ZDl2?=
 =?utf-8?B?eE1FV29zTEcrZ1FEaktsQWlleklKSEIwc2FWVmhHRDdlZGpTR3VhOWo1QUlm?=
 =?utf-8?B?UklZSjlaakJtVVpwZ3p3a1lxZVhDZHd5M2RoZ3pldUtCM0RTR3hnNktVZVMz?=
 =?utf-8?B?MW9EbjhWZzN0dm9sRndxeWZpZ1dybVJxc1pQYjRPNjA3YnRaUmZyTVFxa1lp?=
 =?utf-8?B?VkJnTGJBUzBvMGxWNG5yemxaZjVmOFE4S1Y5czZPeDdJR1g0UzZ2Wk5wc2Vi?=
 =?utf-8?B?bDFkenBqRUVvQ3g5blAxc09jS2tlUHYydUZBTEFCbDl4bVA5elJUdEM5YUY5?=
 =?utf-8?B?VmZ0OTUrZXhZOXlJa3RBV2pmL2FEdnMyQ0FKY1R2NHBRUEtrbVpxTUlOTXFE?=
 =?utf-8?B?Y2ZUSUdLT0EyekRnK2ovOWU4R3AzSTFRMFRXNWdxZnN3NUJXSzBqcE1lZ2xZ?=
 =?utf-8?B?cU13TmFXcVB2KzFxMTFBZlBsdWNGTEpUWXoyRXk3NVcvVkVQN2k1NjNNVURO?=
 =?utf-8?B?SWN0MHpJZXZZQm45czcxdkNYd2N1akd2V1k4NWo2Y0JnTWRpNFRLL1hWZEdZ?=
 =?utf-8?B?YmhYSWI4eFdRUmtDbndCaXcvYnhrNml1eGxnUDJVOUEwT2V6UE9qLzc0alJK?=
 =?utf-8?B?TzlxRndram92Q0VPUms0ODlWYkRsc1V1eVl3MVd1aWkyQXNMR2ZHbzlkbmRV?=
 =?utf-8?B?YTRzbmZqR2dHKzVlNjFXZnZEbU14cENWbXhYUmF2Wng1UEFSRktIZ3Roa2NR?=
 =?utf-8?B?dkR2cFJaUTI1L2RRSjV2Um4wT2VJSytCUFlYcEpmN2xtMzhUdW9YTWFibE84?=
 =?utf-8?B?WUNFRXZuNzlWd1lzN0FIcEtrOERGb1d5cldRYjB4eTBlMUFaMWw4dkQxUnQ3?=
 =?utf-8?B?TVpuOURaV1B3aWl6MmlUb2EwTUtVdjZCa3JITmg0UEN3TlJVd0R3MEFSSDFr?=
 =?utf-8?B?ck5wRUJIU0NiVVVORnBOM3IzMzhZQ0xzWEloNjQyTFB4bk8wVlR5VW96NzQr?=
 =?utf-8?B?Nzh3aHcxeVFqblhRVlFUREw1NjYrdWwwazFaNUluQ3B0REIyTlhzaDl2azBF?=
 =?utf-8?Q?WKESBNh5csdidvWEDk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UWZMTTlXeE5ldDdqUTE3Q3MyRnIrN09kWnMvdnFvNTBBMmJSOWpMdE0waWQ1?=
 =?utf-8?B?aWd6NTdNNmVVV29XOUNMOWZmT1k3YzlFVURjMndkYVlyNEM4Q2EyTkJTQS9C?=
 =?utf-8?B?R29OV2FtU3dEbkVnZ2VFbWF6OTB3T0E0bElMa3E0VnV4SjNkekxjaXBlTU9E?=
 =?utf-8?B?NGtaMUlIYUczWnlGenUvWTU0UjFmZ05JTlBIdXV6azdmRmpRczZseFgzTVdS?=
 =?utf-8?B?SElMc283TVdsaXY3QTFaaStscU9IdW01ay82dzRyY3Q4RzVaaW96YjJVWFNz?=
 =?utf-8?B?ekhLclNNMGVEb0xFcGZZV0tGbTZFeUVtMXJraFE2MjltYTl6bjk4cUU4Ynpr?=
 =?utf-8?B?WnpuWHJTZGRIdVZFaHNTSkpPYWlXYm9UQ1VtaWZGdHUrcWsvODVPSWxrTm90?=
 =?utf-8?B?WEFEQUdlKytmM2dUcVJzMHEvMjVpemp3Wmp5bllZMEg0bnBuay8yeEpybWxS?=
 =?utf-8?B?cjRHVDZXWVBnS0k2SDFFUzNxT1NoY3JuSGNWTmNnRUF3VnRDSG1XbWpUOEdk?=
 =?utf-8?B?eWdRUWVYOWM3V2dlaWQzNmNZbExWZ3lscUh2WXB3ZlFobncwM2lnTTVZU2py?=
 =?utf-8?B?aGEvT3pld0tOSk5zWTdyWTladlc4aENEbVFTN1p1RmVKSE82RzZSL2pQNXY5?=
 =?utf-8?B?eFdXTmJwU0lTci9XdWlvVVdSeWc2QVQ3OFhtZHFTbWZhNXhjQnRFSTFzaGNH?=
 =?utf-8?B?RUNSZVpwclpacTBBNG8vVHdYemI4VHZoT3g4VTczV0dsc3RIMzRYMm1tRmty?=
 =?utf-8?B?Zitib29EMGh5NEVyZnYzMmhnSExQMitZYXVFY3k2NStzUnNsand2bEdOSVVG?=
 =?utf-8?B?dTZXSDBNbFR3OHlqVlQ3aUF4L2NoWlYvMEY0TmdlaS9USWpvdjViNkljN1hl?=
 =?utf-8?B?TjRtdDZveXZmU25odk1FbmJJOEUraVA1bGxHeU1FblhLMG1Odi9RN003R0tH?=
 =?utf-8?B?NUNwc0RZb2k2WHEyejV6RkdXUHFuNGx4bGtVSGxYTVNyU3hwYzdOV21IYUpp?=
 =?utf-8?B?dGxLVXhrdXIxaXdQMDc5UVdIYWZyajBTTjd6VnprVTRmWjJ3aE96eEw0WmxK?=
 =?utf-8?B?bFIzWXNSYXllbzYySkNOaHpnaGNLYUswY0FDQ3YxbWluZmlrTGR1WHlxU1lJ?=
 =?utf-8?B?WE1mVHdXNGVrVDd3ZFNMUDltR0VxclNIbjBtd1lkaTlwRXdkZk9NTnh5OXEx?=
 =?utf-8?B?QVN3UExCSmVHU1RPeUNyYzEvV2tVRVZtdWhydEF1ZFpjcU9vTVRXSElZZGls?=
 =?utf-8?B?Sys2TTlIcTNpUW9pc2NFTWVoQ01MOTM5Y0tkakJUa1ZlUmkxSkVaRU9sNzlq?=
 =?utf-8?B?VTlnVUo0Y1FLcHVUemE1V2dtUWhlYi8vWG9EOTBncGNleHQzS09JaGx3UDhw?=
 =?utf-8?B?aGVsd1ExbTh6T1dmazhvSThNNmN4bDByMDI4TUZVb2ltK2ZONU5WNUxoVjI0?=
 =?utf-8?B?SlhoYlVIaThLQ294eDRpeUxrQ3c3UlFkNHV0bDN6ajUzOHdhdkQwNy81dE0w?=
 =?utf-8?B?RUNaeFp6bUlmdzQ5UVBJSVMxVExpdHZiVDVaS29JQ0x4WlVhRDZYRElLc3la?=
 =?utf-8?B?SWF5aWVYR2sxcEZrd1M1ZDJMcXdud1JobHJMSk5MckYyVmlvV0Uvcm53eGwy?=
 =?utf-8?B?VFB2MUpDSlhzVmRIYUQwenJUQ2c2YTF3dWxTQ1Y4UUZyRHEwbFFhVklkWXQ4?=
 =?utf-8?B?dmR1WkVWSGhGVkdiN2h2Q3ZlbWd6bzFNQURuREVwR0hDWGgyVXRpSmwwK3Bj?=
 =?utf-8?B?K3EvNDJSdTFQZk1LcHFlN1RieDFuNkh3VjlkK0lKOVA5aVBzdUJ1bm0yVU1M?=
 =?utf-8?B?WkNYUkRVcVlPS2t1Q2NyeVRHMklVWlNNQm5JR05MOUt6eXJoaXdkeUphekpY?=
 =?utf-8?B?Vy9jY3lvMTBLeDZ3SVhESW9SdE82SVFwaGFuK3FGVTk4VTJqZzhqT3JqdDhj?=
 =?utf-8?B?RU05cjg0dDYrMWFydU0xcXdibEdUTmo0R1hQeS9QcEMvSzN5dXE2UVZHQ3pq?=
 =?utf-8?B?dmt1em5Dcnl3SmdSMmZyd1dkUjltU2htT3Vacm9MSWc4c2lPdHFQc1dWRVlR?=
 =?utf-8?B?SU9BSGY1VGhMN09Da281ZmtGNjh4bDR5LzNVdWdMRVowdVlJUW1aTzdoSWhT?=
 =?utf-8?Q?7QIFqdKoNuDiBaoVNxMhhx3zM?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f37ba8b-cd0e-416c-d7bf-08dcfe496ca0
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2024 09:57:29.1347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wKm8ok0W64jk3PHnfLcNZBvxIWyLomvP4IgYqkUsbMu45krHyDBRDNZJJJ5EwAPDdRJ/vhwlpZe0dAVJBL+8RQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8840
X-OriginatorOrg: intel.com

On 2024/11/6 17:51, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Wednesday, November 6, 2024 5:31 PM
>>
>> On 2024/11/6 15:31, Tian, Kevin wrote:
>>>> From: Liu, Yi L <yi.l.liu@intel.com>
>>>> Sent: Monday, November 4, 2024 9:19 PM
>>>>
>>>>
>>>> +int intel_pasid_replace_first_level(struct intel_iommu *iommu,
>>>> +				    struct device *dev, pgd_t *pgd,
>>>> +				    u32 pasid, u16 did, int flags)
>>>> +{
>>>> +	struct pasid_entry *pte;
>>>> +	u16 old_did;
>>>> +
>>>> +	if (!ecap_flts(iommu->ecap) ||
>>>> +	    ((flags & PASID_FLAG_FL5LP) && !cap_fl5lp_support(iommu->cap)))
>>>> +		return -EINVAL;
>>>
>>> better copy the error messages from the setup part.
>>>
>>> there may be further chance to consolidate them later but no clear
>>> reason why different error warning schemes should be used
>>> between them.
>>>
>>> same for other helpers.
>>
>> sure. I think Baolu has a point that this may be trigger-able by userspace
>> hence drop the error message to avoid DOS.
>>
> 
> Isn't the existing path also trigger-able by userspace? It's better to
> have a consistent policy cross all paths then you can clean it up
> together later.

I see. May we add ratelimit to it.

>   
>>>> +
>>>> +	spin_lock(&iommu->lock);
>>>> +	pte = intel_pasid_get_entry(dev, pasid);
>>>> +	if (!pte) {
>>>> +		spin_unlock(&iommu->lock);
>>>> +		return -ENODEV;
>>>> +	}
>>>> +
>>>> +	if (!pasid_pte_is_present(pte)) {
>>>> +		spin_unlock(&iommu->lock);
>>>> +		return -EINVAL;
>>>> +	}
>>>> +
>>>> +	old_did = pasid_get_domain_id(pte);
>>>
>>> probably should pass the old domain in and check whether the
>>> domain->did is same as the one in the pasid entry and warn otherwise.
>>
>> this would be a sw bug. :) Do we really want to catch every bug by warn? :)
>>
> 
> this one should not happen. If it does, something severe jumps out...

yes. that's why I doubt if it's valuable to do it. It should be a vital
bug that bring us this warn. or instead of passing id old domain, how
about just old_did? We use the passed in did instead of using the did
from pte.

-- 
Regards,
Yi Liu

