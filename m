Return-Path: <kvm+bounces-15055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99D738A93A5
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 09:01:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BDF861C21824
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 07:01:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78E613BBF9;
	Thu, 18 Apr 2024 07:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SJbf9FOf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE81B37719
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 07:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713423656; cv=fail; b=jX7msBTIXPQxZVBItYJiYIXg66uj+V1801qq6QfvudVmGIqR96EEI0jfT82UD9HIbK0iS+eyo4ITBwef43JNOug32oz/AKWaNpMhnJkMCIZPKV3qtbGO8xupEkGfz04Yj9A9RLZQUPOa1hK+f9hjYC8akw6dbSA25h4OpHzXy6A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713423656; c=relaxed/simple;
	bh=HmkeHU8mnCbg4rfjWQmoltdmJDlSkwlAdGpDuyMOYNw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RbnPR72jc0vP6gSAUblR4xT1PB8zwom8l6pGdvjwzRiTBqj5zEpC1kzb2Zzw6OulJEqJaPTjgfDPwD7AMLE3h5VSC6rpnZ4qb+JYKXHuSKeSMfX5oHMCCPGxfQ9ieyLjc0YYAAevZOw8lzEJPOx6B0wpFzMwnnTeQj9WYjcOLnI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SJbf9FOf; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713423652; x=1744959652;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HmkeHU8mnCbg4rfjWQmoltdmJDlSkwlAdGpDuyMOYNw=;
  b=SJbf9FOfZIdSzUge3lq22N8YwY9GVTK/cgomLGnw9ViEYTeK7+6n3lHO
   ioB7L2esJok/93vLbbBM1n0JAgnXRrkhSPsocTP6RfM8NaE+XTSs+MT+c
   oWPE1Ygstz9s/TA/SK7yab3FcsFqoYbpHqfPHQkuPkbLf01rxUkRCl8X0
   wawKtsZUAxcOhAYLDb/gW0cabWLsKky4BEjgjgWzlPiWi2HpG/ghwe1sV
   kZewNuFmTru80pIilRe66M71colwnBFBUVMTrN84+cCEPLFu9Ih/lp2QR
   EkL6/0eXavT0OfxpednNLyxgDt0IcaQUYTbgnXPCAiUwziQ55shGggTdl
   g==;
X-CSE-ConnectionGUID: AhjBMRmkSjCFMjrUl8CgaA==
X-CSE-MsgGUID: e1LCD1htTFGKTGrHpxWw7Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="20375658"
X-IronPort-AV: E=Sophos;i="6.07,211,1708416000"; 
   d="scan'208";a="20375658"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 00:00:34 -0700
X-CSE-ConnectionGUID: 1x+9X6KBT4+QmTPf6i2Y0Q==
X-CSE-MsgGUID: bEpAC/odSXuapPMOrR8uQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,211,1708416000"; 
   d="scan'208";a="27305258"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Apr 2024 00:00:34 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 18 Apr 2024 00:00:33 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 18 Apr 2024 00:00:33 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 18 Apr 2024 00:00:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=epdsNysUGYqmoMlgmpkQ0YbPZvfrbVpNv7c7AGCAS1se6akLIQzokB1eutL9A4emTPdnrAuJjqQO8t4RrAwry+E18fSkhWyyYWBIzNWbRHRwPvGx8SuuXYb+Gne3bMKLTKYTtKy1OFEhrJkxCGgy175XowrUS7lFqSs5rI9E4iycMlyeropKwbnOxTMgFGMrcVoE9kM7zx/nWsQRRobt/u5tyRJBiTKhTkS59z+C0YxjS4P9xsrqP/w+lmbZJLI6/kluM1HtBNnB8Bwvj7C00k3q6T9B8WnynmTcllnfirYhu0MN3+8d5JKOH9yWJhde8jlrTFK7qQ7Mm4beyjnenw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wjhAy0d3r3d3TLkVPKGuyEJKP3qSoJjhsLXrlVUeeis=;
 b=P1LGKLZQBsC8bjpyS6iZ4kIn/zhHCUhiFv7jaLK8SUAAL7IOjCWHNoN2E+dZC2S298jQpCPsFi5rV6vBP+NAU13i4++VXzuT2MGlyk+R7vfBM2aPznUDo0jx/ADfp6VG+nmdbv+W8zISCukswRpyhF4j4ZoiGEOd6Up5Sj6OAm0VuVtVfdqA/c0/YP9hjp6dqmazbhNVldlcsa0MvNzogyoeqn8QnJXWY4fb+h5tedcrm2Wh3eL86PNKDEZsSSVTv74yIbb/Qp3y9ihzyJ9YJUO82Je73fg+gYc1+kkdyUdw84WJ4CI4tcmvroC2DAjp139QwkoTT4nssXx6bgS68g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA0PR11MB4639.namprd11.prod.outlook.com (2603:10b6:806:70::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.27; Thu, 18 Apr
 2024 07:00:31 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%6]) with mapi id 15.20.7452.046; Thu, 18 Apr 2024
 07:00:31 +0000
Message-ID: <aab2d3c1-418a-432b-a3e6-4ca07225116a@intel.com>
Date: Thu, 18 Apr 2024 15:04:06 +0800
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
 <d0dc889b-003c-44cd-9f8a-a14d6b7009bc@intel.com>
 <BN9PR11MB5276D407CC14E0C9D8AE17998C082@BN9PR11MB5276.namprd11.prod.outlook.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB5276D407CC14E0C9D8AE17998C082@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0194.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::22) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SA0PR11MB4639:EE_
X-MS-Office365-Filtering-Correlation-Id: de6e4b31-81a8-4396-a8d2-08dc5f753c86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iS/3prJYi4aQkYHBe2dDpiYEmHmlqktD2e1ZwZLQkGNRmf9q/8DDzrL9OBtfRiqXmLKepcmOU3VemQ39w03uatV92JXonUazQKiwgjFoZAQ3NwuAm3RvQIT1Ye8M7aA74lT8uJ69/XeHCqMxURRliSqO5yg46ahtzLzkJXZPaUHOtEC69GsMT9H86U+DwYiSmfgD4KTCZz6qWxTIiQhQoveLmS0ukZnlobiiKgvcB0I+O9+HksvP9lssJpiY9NCGjKlOxM1badLsB5LAoWaDchhPz4d3+TCbTOz3Qe3EWbWDy7Lk3Q7fjwVd/Jffz20wWHSeCwSIVIX0itEYT59AP/6Ku1EE4rUIkd6Wxbo/h3T7UxbOwCKvnaFG58gPozHNtTkOXN8TI9iK5cT4ZBaFNpfep1OgEQ+rredCMvnnCLZ73DVEKGB+kejjJeKCnBamyw7Ey9xq+R63tZIAeEFaw3mqgWwQu4/AFb2+yovNhK4kwGyLA1R6UI4IJutex2Ve9LwRnZxbmn1YlCYPmJN2OtPhFcWPx7NjWIwsKopSf/6QsRIWboN/V+iXexSlHW5VC2RRPWk1An/Ac1Y96lUwI6hZHUr/l64sN0dOK8CnIHHIYqUrNKVOEJfkVGjDrLrgehzZoEwOXaRZm/0GDwGvYOMMzDhup9J8WsDB03SzYv0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VVB1dlhoQXk1R0dGTW9TelF3QXRFTDJ3MTVGQXdxcVNDZDE0ZklRZC9tV2dn?=
 =?utf-8?B?MWhTVWN3UlhudExvZitUVzVGaVVCa3VOcDFSTUdqbkFLUmEzc3lDM2NRd0pn?=
 =?utf-8?B?eEZ5ZGRCd01lMStOL25nZjhYN2Z0QU93TElUMm1WbmUzb2xoZjdXbksxTEVI?=
 =?utf-8?B?WkVnbmsvTmhRWk1lNFlEc211TXZzUkZyeDczNjc3VC8zMEF6YTY2WEZYWEFV?=
 =?utf-8?B?aDN2L3huS0s0N21uemhxU3dDTnFmYzE0b3pBdGJ1TlpWai8yMk9wR0Vtei9X?=
 =?utf-8?B?VCsxUUFPcklmUkx0emhGTU11OFZDVFNWalVDNVd1UjBiakwzdHRWZlN3TGNm?=
 =?utf-8?B?VTBHNDF5NGFjeU9XZEMrTC9zZnArcXBxNmxEOXNUdVNYbXVVdVd5QVpqV1E2?=
 =?utf-8?B?NXREUmp4eTNOWUNtc1FqK2xkRVJvUXE4VStiUGd3bjA3Wk05K3p5ckFwRE94?=
 =?utf-8?B?Sk9jejZxSmFwcEsxTEJMQUloTld2RGhhZnFlRUtzNElMVk8rT0FuRTFLQTRn?=
 =?utf-8?B?U2d0Q0VCUWsxY1gzeGxnS05aclV2Z0t2alplR1F4SmZreVBaNE42YW82SVZk?=
 =?utf-8?B?ZERLS2VzTFovZ1d4c1AyWmNzMENsV3EzUmJUbEFQUnZUQ294dVd1NjZGN3BR?=
 =?utf-8?B?SXFhTzZOTGNEL3U4Qlh5TFEvZVg3S0w5b3ZIYlNqbno1TmhPWThsVk5jYUFo?=
 =?utf-8?B?bUNPUzZqaFM2cm52RUIxUzVKeHRnWEFrQkQ4R3hOWE1ZWVRxYzBTR1JzaTRi?=
 =?utf-8?B?RnhQVDdjcExTMFZVS1hNaVA3dGxPRFhBV3IzRkJ5d1JmYVlZM3BCcy95QmE3?=
 =?utf-8?B?ZUJaZGdiaFNKK1gwSEo2OExEeTcrR0hrRDJoUUU1NjFralVzNHVmREE5NmJY?=
 =?utf-8?B?bzA5Yk5pWGUrclRUQ1RYa0RlVVRKZ2hWbWxEaCs5THREbXMzVlJOOE5jYmtY?=
 =?utf-8?B?c1A2d1F6RUJEeWVLNDJVUDJPV2MwYzE4T3RGSEF5RHpIMnI4RmRPZDkyRzJ4?=
 =?utf-8?B?d05NK2Q3b3JWSHhnbkFJNlFKYXFDNnRDMm9KMFhMSXhYdUs2V2d4QU5xODVK?=
 =?utf-8?B?QkNoOEJ5U0pGMlBvQ2NlQVVNTU83QVlpZll3RTNtSlZqT3lRL0twVGh1cnpU?=
 =?utf-8?B?UElORkphcWZjcElpN0hzSDVoZWxhaTZsNm5TUkhHNy94cEZtMzNSQ1VmNVRk?=
 =?utf-8?B?RHFXd2JLdTVFRHJYeHpMOWxWQ0lsbHlnY0kweDR2dlNnVytab01ndEZrbkk4?=
 =?utf-8?B?VFJHeWQ1U24vR212TkdsSzFkUHd6V2RQcTRVQm9YdkZZOFptaTQ3Q2lPVVUr?=
 =?utf-8?B?bi9jNmtwNXBOdXh2Z2VIQVh1SFVrVVh2Z2JGT3IyZmh5SmloVUJObG8xc3Bz?=
 =?utf-8?B?NUFMS0lMN1ZUZHlKOFhGWkJJRFVYUnNIbG0vV2tuSXloaXY4RnNMeTZ6Z3Bo?=
 =?utf-8?B?dVRsUXFhQXd4SStpMERKVDZ3YnRlWG5WZU42MnQzV28yczhQcmZJNkdiUkVk?=
 =?utf-8?B?RDdKb1l1blg4cE5pSVdPVVFOdGY3Ym81eGJwRkJ6M1F6YVpwS2xIQVJPZW04?=
 =?utf-8?B?YVJvRHliUUlmWGxqQ1RJSDVjT0lLd2FiMGZLL2IyUFpGaEw0WXQwcXc5MzBY?=
 =?utf-8?B?YWY0V2hPK3ArbEZkcjdNbVZONVluUXlMRkRxdzdrQzZXMkNqRkJIbmRSbHc4?=
 =?utf-8?B?ZW8wMzdaYlhjT1c1TWxGeW9VQUJUZi9ydlJsNnZicVVkVnJ2VlZnUVM0OFFW?=
 =?utf-8?B?czZySUw0QVMwdkQ1VVBGUjNROTQ2TEZldnozK3JrMzNTa1NCakVhZCtjbitC?=
 =?utf-8?B?eXpCaXBvVGI5OVNQelBXQ250ZlRtaUsyVGlkNHN4eTZpSjBqSXlIRmoyQ1Ux?=
 =?utf-8?B?M2dIbVBUcDZ5U1cvYytPZEFkS3ZNS2lpRXhpeHc4OXE1ZjJrNzM1bmtVWnpE?=
 =?utf-8?B?Z0s1dWxYTndDNjU3S21FVTY5a1A1L2pNdzl0UHRGc0pkbG5LRHFwOUlpOEI5?=
 =?utf-8?B?MFdZcklaZkpIc0NZZENERzI2bVZrSVgxSkFlZEZReGNqbENxVTVxTmYxUVVQ?=
 =?utf-8?B?ME0vVkhXczhZNVlyUnNVbkpMY3NqOE5MWlFHNkxPYjVPalJmQWtoVXlDRTBZ?=
 =?utf-8?Q?jW9ivW4WfVc2kpciwm5iACY5N?=
X-MS-Exchange-CrossTenant-Network-Message-Id: de6e4b31-81a8-4396-a8d2-08dc5f753c86
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2024 07:00:31.2185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 511mhNRSWd3MVrXCd9MHV6c27oPFk+vGm+1MJk7JQb14uMBZbKO6SvQvVzLAVyFpGovz6sfFu6TFWwUwbYBU3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4639
X-OriginatorOrg: intel.com



On 2024/4/16 17:47, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Tuesday, April 16, 2024 5:25 PM
>>
>> On 2024/4/16 17:01, Tian, Kevin wrote:
>>>> From: Liu, Yi L <yi.l.liu@intel.com>
>>>> Sent: Friday, April 12, 2024 4:21 PM
>>>>
>>>> +
>>>> +	rc = ida_get_lowest(&vdev->pasids, pasid, pasid);
>>>> +	if (rc == pasid)
>>>> +		return iommufd_device_pasid_replace(vdev-
>>>>> iommufd_device,
>>>> +						    pasid, pt_id);
>>>> +
>>>> +	rc = iommufd_device_pasid_attach(vdev->iommufd_device, pasid,
>>>> pt_id);
>>>> +	if (rc)
>>>> +		return rc;
>>>> +
>>>> +	rc = ida_alloc_range(&vdev->pasids, pasid, pasid, GFP_KERNEL);
>>>> +	if (rc < 0) {
>>>> +		iommufd_device_pasid_detach(vdev->iommufd_device,
>>>> pasid);
>>>> +		return rc;
>>>> +	}
>>>
>>> I'd do simple operation (ida_alloc_range()) first before doing attach.
>>>
>>
>> But that means we rely on the ida_alloc_range() to return -ENOSPC to
>> indicate the pasid is allocated, hence this attach is actually a
>> replacement. This is easy to be broken if ida_alloc_range() returns
>> -ENOSPC for other reasons in future.
>>
> 
> ida_alloc_range() could fail for other reasons e.g. -ENOMEM.
> 
> in case I didn't make it clear I just meant to swap the order
> between iommufd_device_pasid_attach() and ida_alloc_range().
> 
> replacement is still checked against ida_get_lowest().

aha, I see.

-- 
Regards,
Yi Liu

