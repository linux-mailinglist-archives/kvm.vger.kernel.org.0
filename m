Return-Path: <kvm+bounces-14750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E700E8A6700
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 11:21:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 161401C21721
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 09:21:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9354D85272;
	Tue, 16 Apr 2024 09:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZIZqgOCX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA8D84FC9
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 09:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713259277; cv=fail; b=bKinXWft9xgmVSKK+a1xyDMDs2RmI5LSsp6b8r5pKlhWVjyN4BFKwE+RiSNDggRAjTewYLV2jKWGVh/iWXOQOm0dLWesgNRqrRbCKIjS5rmuXcD6d2iDKH6G5pQZAfYiHh9hDn8yG4J1JsFWFaDwbzHNPRHKU43d6wilz5Yfdxc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713259277; c=relaxed/simple;
	bh=WMRrV/LsMR1vJrfvsySopxp+GER7JzgkzRSs0k+sMS4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=awGtE45icqGPKKccLtOz6gc2C7otS7GMIJjMC1dfJUeAAvD3Wx2spneehCXOsjPhPdqp2uhIqM13RpPQBRsUUvG3aI4oIxcmczXElmN3uE4FkoqPwWkVQ8ONKYfxu69pm4lj/7EdHjA39qkTkukCpwHm1taycSaSnosMhB8t4lA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZIZqgOCX; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713259276; x=1744795276;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WMRrV/LsMR1vJrfvsySopxp+GER7JzgkzRSs0k+sMS4=;
  b=ZIZqgOCXvP+BEvCh/j7XdAGKvNGrsmf7vhqeEFnsdjDTnLIkB+ReMwdh
   hg6plhXEKb7WRhivS9oNPy3v+ZzzhZq49bd6B4stnrkuRFSk2iVHmHyEe
   3p7rzSeqGknPlF4SY4aBxvBqaTwb3K9AMZt18ZKjRabbQ6YiX/RwJxvnd
   2RluTTUx31uiBrSykJUoKGai9p+ffqdwcRN8ZfubZC34QxNeaI7grr5fw
   jHiSil9efPtfoHGOdAdBdRO+IDjfrmu2jgWdWZQcru6ztfIpfxCb5GMlY
   RsvhOtMROJFimKPWP990u4jdMmdG6cN0IO7KlaFLpXxeW+P6T/VwpVYiA
   A==;
X-CSE-ConnectionGUID: uHoFm/AwSbmV5QfPYoRzeA==
X-CSE-MsgGUID: PnKsMgAhRvGqOxgvFo8New==
X-IronPort-AV: E=McAfee;i="6600,9927,11045"; a="8796053"
X-IronPort-AV: E=Sophos;i="6.07,205,1708416000"; 
   d="scan'208";a="8796053"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 02:21:15 -0700
X-CSE-ConnectionGUID: S+rOpzNFS2G/GpXNGkHhHQ==
X-CSE-MsgGUID: da3HHue+Rv+5+c0jqHQH2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,205,1708416000"; 
   d="scan'208";a="26852526"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Apr 2024 02:21:15 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 02:21:14 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 02:21:14 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 16 Apr 2024 02:21:14 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 16 Apr 2024 02:21:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kOj1G4Ncaz3/wHJMdoSHKMa2QUlBvYE4dI1QdYW1VcAdL3ryCYwDK9gpqc0LDpFxX3A/zYaUW625yEJ0MGFacQO9crlDHJcsRs8GrNf0D1jHKPZle1YoRwezPQwKoMWuDoFzgUztHVkEHJXdEUIEZvTbX3Cxhyd2utnP5Qsjj2wdGGiJj2W/C1Ij5/r+wwY8s15PId58NizEjfSEkSDk431C/xgtdqF1BmLAppSb33kaS2t5VnVxFcD/4yAj5gwpiFT6GVsKXInRTYILe9jezgLNkvgZXfVrF3FhAQn1EBUxVLC251Z8Y71AO3921SZ17EIuzK4Qh9lSfj14UfMBBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ARa1j9jnhKV6OWEKeEuhYmjMA4dG2Ahn2qgT/fh9YSw=;
 b=lhSME5GEFI4U6pAjPm6dsY71h6qeVUTqkvhPCH96uAj7JZcDGMK5TOSb6bUkw5TMv20xdh7pVUPWl6ohfKobCRM4WDqVpRdx9OcwK2EDisUFEWM7JGm3GmEvcelJGqBTkb/Oe70Ylc7WTqiCCBu3rfs+WfFdDlJ9EKF8n1yDYW744BdHycFk4CXmXdeSgc9PxtPFrNyKagQdPEPz5BmfzXVKKapgYzyb6KYw2ec7VDH6JMvpMxzO0HkQStXg+sW8gjlbmG39HXJE7UJBWAZbGiVJJSsQ5TvjXmxdSwyLNaIXmSPgCjImCYiBsnYmS2FbipIQJf9wabK0it5VxDzHvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by BL3PR11MB6316.namprd11.prod.outlook.com (2603:10b6:208:3b3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.43; Tue, 16 Apr
 2024 09:21:12 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%6]) with mapi id 15.20.7452.046; Tue, 16 Apr 2024
 09:21:12 +0000
Message-ID: <d0dc889b-003c-44cd-9f8a-a14d6b7009bc@intel.com>
Date: Tue, 16 Apr 2024 17:24:42 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] vfio-iommufd: Support pasid [at|de]tach for
 physical VFIO devices
Content-Language: en-US
To: "Tian, Kevin" <kevin.tian@intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>
CC: "joro@8bytes.org" <joro@8bytes.org>, "robin.murphy@arm.com"
	<robin.murphy@arm.com>, "eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>, Matthew Wilcox
	<willy@infradead.org>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
 <20240412082121.33382-3-yi.l.liu@intel.com>
 <BN9PR11MB527623D4BA89D35C61A1D7D08C082@BN9PR11MB5276.namprd11.prod.outlook.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB527623D4BA89D35C61A1D7D08C082@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0044.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::13)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|BL3PR11MB6316:EE_
X-MS-Office365-Filtering-Correlation-Id: 9194f1e5-73d7-4e61-ec1b-08dc5df68f20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hgWT9MD1G8d9oKDSI6F5IyEnJu2tMi7sPDzkqiG8+3fNvUrniaoQ+e9y48WIB7Rs44KL2v4a/Fk02swFSHq1VDyWtFySLP+ykMY+ocADhE5PJFVQvuBtkTRHwSTDJdYgbQm0MwXOfdcHskj7XLioeUn/2h2rsO45Du6+DVMEWXns84WzdalGAc6ResIVwfrsFtFGIGh/tQICyYvETyG9djWkGRB5trahlS5qOY1sjrznG2XVlcFtc7+2u3Ll1ViKwJvivWnz9Wbuo51BLJ3qlWmqMw5TckD5vfWjhkAhxlkOKUygqFYbUpX2+5kVvMDupUOstY8bw03soVl1nwvvlvPPfxzZ3+vzQFSSg9RgEcsqL+l9MJumgr4kVOUNkzI+1BumPUJoozeirUnj6c6j+02K16zWWmvY9S9J9GfGaAW+SrathfQXPi5wqnP7BOBS7/pKeRyPQmdTE/Q9EmtcZvcwgOBiW4mW+sI7xlqWAJAn9pzxD6jK0VPAUbLvRwt1R0ewEy6Y4cU/c6SMK7vcHuF0I9MX08WBm9OR8HX8uHPIBBpX17EF3U66x/3L/6vGULsDX7Ax09l6iH6rNTxFg7QiT0+0FSccx352Dcwr0iNMJi9hrgGL+Sr22SzEuikpyNV5jtTprN2GbHGl2ezfnCEKKtmynoA9Am1nOYiTfCc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a2JaeVZQZkg0ZGV3SXN1L25jNU55c2c1OFIrV3lNcXRpVEpwek1qRGU1R2pV?=
 =?utf-8?B?MDVHb3B5M1A3QlFqNkU0d0JRRk43MzdSV2pwRjh3ZDhFWVlPU1YvanR5WHZD?=
 =?utf-8?B?RUZnaU5DeEo5OXhWVHl3c2k4eE94c2MvMkxza1p5WitCRnhpM1JyMVF0N1Bs?=
 =?utf-8?B?aGFJUG8ra2F5a3g0cVpnWlFtNk9NY0tseExuZG9tWkVvd3Uwc21Ock9obnBS?=
 =?utf-8?B?VVp6WitMS2hGcTRGa3BrNWFqQnF0VVE4WlljUFpSd3o4KzdObmF6U3hjdm5J?=
 =?utf-8?B?RVNualgrdXFPSjgxbE5tZFY4RUhBVDJVbURrc0hSQXhwTGFnNVRMN2dXekxj?=
 =?utf-8?B?QVdrdUZOZVBFRXFyaDNva0todUFENHpGeXdwcEpSdWZEVllSNTBobWs1Nk5J?=
 =?utf-8?B?MENhNVhmdUtmWTZUWkRtKzVVNnlLQjhNN2FwMEd0dHczaFFsQ3VTM3dpdlk0?=
 =?utf-8?B?T3FlRm4yRTBuMzZKQ0htZ25vSmZmSVZsUlhJQ1UwcGxDVHFsaWdTUElkU0tK?=
 =?utf-8?B?dTBkNklOM21hU1RHSHpDamUxS3dPUStuVnRpcWJpWmd6MEpyUHgyYVRwQ3RZ?=
 =?utf-8?B?dVdKdVlNNHdVWG5TSVlmUTUyNU5zc2ZjSDEwWjViZ1dHb0svMzFGaTh1MzZ3?=
 =?utf-8?B?bnpuM1BnVXlvRWM2YWZUTGNiSGlLRTZrd1RvQ1BHUDZlY2ZjbkdpVUk5ZXBT?=
 =?utf-8?B?WmdnS3ZBMlgybmJIMDh5VWlTeUp0MDM1K0pZUzhEMUdHbU92L3U2VVdSK09N?=
 =?utf-8?B?cW5EeTlnU1RNUjQ0djhqMWFqdXRlNmRkN1JJaW8rRVd5ZnZsRXZyT08xbmd0?=
 =?utf-8?B?WWY2QUhjeGJDb3d6SmpFbU1JcUF6MytvYmxhcklTWW4vWjAzS2Q5dEtEYVll?=
 =?utf-8?B?VUhON1p3aG04NVVwUFhtRmc2b2pZMDRYMlRYK0dmMXV2Vks3ZXNTUlVJdHp3?=
 =?utf-8?B?YndIYkd0ZTJUcXJZNDVQNEVZV1h0cUpsVE93MEVMYWtMRU1oTXBNQVd6ZHR6?=
 =?utf-8?B?eUVGb0h2YUVrT0Y4RzVaWURIQytxem5sN3VvVCtyT0IwUnFmcTVtd0g3bXUy?=
 =?utf-8?B?T012bjZkYTh4RVJGNnRRNXdEdGFsSXJ5NkpiV3p5bXd2UUUzQi94Zlc4QkQ5?=
 =?utf-8?B?V0J0OVc3ZEZjL3R3aU9idWVCT2tsWU1KQmlUa3dWU2I1d2pMNHpOR0RmcEh1?=
 =?utf-8?B?WTFqdFlxeTNxZUVaaFpOYUhRcFkvQVdrVm1LUXU4c2VZdjdNYW9PK1BIRXNt?=
 =?utf-8?B?WE1QTHpVdzF1NVNDSnBLWUZyZ0hnZ0JEWU82bWFDT0lCd3M0eWViVTJqTnE2?=
 =?utf-8?B?Vyt3c216WlVMZFgzRGVoZDBYdDRLbTluWXk3NlczQmR1cDZEc3ExczNVODVm?=
 =?utf-8?B?N3I4TTgyMWNBTllaWW5YcEw1MUhBTzNEM011REFkTGl6Y2x1blRvOG9KV21j?=
 =?utf-8?B?bWcybVZyV2grRWFabk5lT1Nad0dUd0gwTTB5LzBHYllnQUUrQlFqb1Z1OHVu?=
 =?utf-8?B?UnJmS1VvaDBoUTZDMW9VM2REU1F4VmNBRStId1MvQkx5UUFxRStlZTBqcjFi?=
 =?utf-8?B?SWJlQWR4Z29PNnB5Y0Y3QitmQTg1c2tIblc4RzZQcThsOVdNU2FoeHY0VUpv?=
 =?utf-8?B?dStJK0d6R3JSVFRlRkh1V1VPN2VKQy8yNCtyM3BlTGdjbE1oOHZmdFo2N0Fj?=
 =?utf-8?B?Si9oRVdVODd0U2RhamJhelQzSTNrYWRYcG9KaWNZei9lTjUxSUpzMkIxQ0xl?=
 =?utf-8?B?UHJHUmJGWjlHM2VCWjhrcml0Vk5nakxRYVdWZlovYisxS3Q2QXpGeW16TUls?=
 =?utf-8?B?VGx0TWZESmdKaE5jTGcxZFJxbXNFaVNENTAxbytvNmdCN3RDOStaenIxd05P?=
 =?utf-8?B?R0xCREduNnNhT3ZhanJPN2UzZ2tPS21xN0J6ZmpDTk9yOFZzM2ZidG11S0M4?=
 =?utf-8?B?aDhzb0t1YkhsRklSTDhjaE94R3NzWmxhQzdWMWhpRHZFZG5VR25zU1lpK0R6?=
 =?utf-8?B?c2lBS2dDZkthVnVNSmZqdUo5d01qNEtoVjJaTXQrMFZXUC9KK3ptUFI1QnZV?=
 =?utf-8?B?SENQVGJyUXorT1BtTjFMSlpMR3A0UEk3ZlRVc01mSVB3UzUrU3dRd3V0UUkx?=
 =?utf-8?Q?WoSHZUIVAixlReA8daLBK+u/E?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9194f1e5-73d7-4e61-ec1b-08dc5df68f20
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 09:21:12.5552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +ECeTKjoH33Qp0ZioydW4qhA5LV8rvZ6VyFNShXaaC/7DJkOM4Y57OGgQHlN/kFvHrMf677iFkE1iypf3t34fQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6316
X-OriginatorOrg: intel.com

On 2024/4/16 17:01, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Friday, April 12, 2024 4:21 PM
>>
>>   void vfio_iommufd_physical_unbind(struct vfio_device *vdev)
>>   {
>> +	int pasid = 0;
>> +
>>   	lockdep_assert_held(&vdev->dev_set->lock);
>>
>> +	while (!ida_is_empty(&vdev->pasids)) {
>> +		pasid = ida_get_lowest(&vdev->pasids, pasid, INT_MAX);
>> +		if (pasid < 0)
>> +			break;
> 
> WARN_ON as this shouldn't happen when ida is not empty.

ok.

>>
>> +int vfio_iommufd_physical_pasid_attach_ioas(struct vfio_device *vdev,
>> +					    u32 pasid, u32 *pt_id)
> 
> the name is too long. What about removing 'physical' as there is no
> plan (unlikely) to support pasid on mdev?

I'm ok to do it.

>> +{
>> +	int rc;
>> +
>> +	lockdep_assert_held(&vdev->dev_set->lock);
>> +
>> +	if (WARN_ON(!vdev->iommufd_device))
>> +		return -EINVAL;
>> +
>> +	rc = ida_get_lowest(&vdev->pasids, pasid, pasid);
>> +	if (rc == pasid)
>> +		return iommufd_device_pasid_replace(vdev-
>>> iommufd_device,
>> +						    pasid, pt_id);
>> +
>> +	rc = iommufd_device_pasid_attach(vdev->iommufd_device, pasid,
>> pt_id);
>> +	if (rc)
>> +		return rc;
>> +
>> +	rc = ida_alloc_range(&vdev->pasids, pasid, pasid, GFP_KERNEL);
>> +	if (rc < 0) {
>> +		iommufd_device_pasid_detach(vdev->iommufd_device,
>> pasid);
>> +		return rc;
>> +	}
> 
> I'd do simple operation (ida_alloc_range()) first before doing attach.
> 

But that means we rely on the ida_alloc_range() to return -ENOSPC to
indicate the pasid is allocated, hence this attach is actually a
replacement. This is easy to be broken if ida_alloc_range() returns
-ENOSPC for other reasons in future.

-- 
Regards,
Yi Liu

