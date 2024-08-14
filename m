Return-Path: <kvm+bounces-24114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 39CBF951669
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 10:17:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD9C91F23728
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 08:17:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 409BB4D8B6;
	Wed, 14 Aug 2024 08:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fc/CNIh9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BFC394
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 08:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723623305; cv=fail; b=Kf/kAdgz7xYAq3In/mLXuSo7yvgnqX1A7NFTnm/oIvl83bJeYEZcWxs0YBJSwnWFObWXR4dMgEpjfm7xkBYcAqo1e+XrpvZYWk0+NHxr5QYja0Tj5c9XJ9e9+Rwv71VFr1RfNM678j46G6tkLJSMphNmp0UEyuZn/VCmSxW133I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723623305; c=relaxed/simple;
	bh=+WePzd92r2YDZ18pzKH8bGI2oTVAxqPwknlVnf7Ms3k=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EfC0OWy6wA4o0F7dviWdhJKTAW5541XCpA51TuN1a4ZHKLakSCSoe2cXZiU4gVw+41IqKIlR6q1++YUoVsxuGoGb0ZW/IbUIp2sOalPOjOv7K91aYdQDn4N/eIgzVxNXrWA4xeujmABe2oDUswV5tL6iFTvECFQiYjHJlvLl/Bo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fc/CNIh9; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723623305; x=1755159305;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+WePzd92r2YDZ18pzKH8bGI2oTVAxqPwknlVnf7Ms3k=;
  b=Fc/CNIh99NlfLJspc//4hE526gfZ81rf+EqPNK31kTqyGcqfNA1xZEKF
   tV0m6Vh+OfDL2woVwMV15qMW/GI24D/4THVVi58983k59ec5nsFqZfdyP
   LtmSdzcdVNfc8osTMpJx5+d8gtAXg77c3K1qUYbmZ2K9uKbJCmPSouJab
   U0lZjWAOqVxAay7Uw3ykkyFE1154YjwWeBE/KtxJnPc+1I5IpUX5b8Qs9
   pdQsm4rM6r3Rd4R8y7nWuGPG5ESMR2rJvUJp+oZ/3w1S5n/nObbsnAXoL
   lC9fidP4Vla102X0t2uvDWEJbKTtIpQpDcTpeBaO+9q2AeVbgVjz/LdPB
   Q==;
X-CSE-ConnectionGUID: wD/drlLgRxWH0/IwIrJeOw==
X-CSE-MsgGUID: MfNMJQ4dTq+PRE0KBYk74w==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="21955123"
X-IronPort-AV: E=Sophos;i="6.09,288,1716274800"; 
   d="scan'208";a="21955123"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2024 01:15:04 -0700
X-CSE-ConnectionGUID: 3aHtQVfKThGzXwEtd5Kiww==
X-CSE-MsgGUID: EH/FKBywTz2ODu8AweGZKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,288,1716274800"; 
   d="scan'208";a="58633749"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Aug 2024 01:15:03 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 Aug 2024 01:15:02 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 Aug 2024 01:15:02 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 14 Aug 2024 01:15:02 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 14 Aug 2024 01:15:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q97ER923EiL8vErvO5oriNKj4EGh6AO5dMXWuUwiUPi98boUrT2rnGcffoJvlqBAfiqbqG/x54hw/a3s48mgDlQFdiwq73V0cVmiAdp+mW/MV4kqbwOxE5mxLiZnftTKDUq8RPPgnxfKLCMcjbqdtf+Z0eXHuIiaPFMTKtzYqubNMxxAgM335xblM7KT1ciQtImGIeqOXprcq+E6hLhViKd48+zC6OvPqrnn9k+V/Cf4d3sdT+A5fKHg+G8sCxGCSd8I4cKn7ChT0CI8zWRtGQlu6zGK14n8Lw+2bGkzG+Hj9yVIBSGAjs/ZGShfFOtmg0PgrkUjuy03FADFwlYFvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hlIPS3S2mSjU45MbxrLmkt33vfl5hts0znwlwNBWGT8=;
 b=dLZqBVJpsEM6KQoaYbWroEMYeTvjX4cTZdCiIX16bDXBhKmN0qXvLvEcpA3iqDZzLAb+PpJuzg2Mn4x6IUVLgMRrRbUjGKr5mJ0/CIIJYnibbEJuj1yfzBuvkNTSgGu6X5o1NNsFCtTj0Aj3jIdcRbg1UNezIK8Oc+yGZtVKTquu75CAp1p6uY5W92nb88cCfObafdUK0MYBzbZKkNQFWwevhZR1LmoqBRg6AQWFRe/6KtMr/+kzqi+cJnMQEC7BmCLiYFNt6wI9EkDeo1+pAwCLzMUaKGkfKNM+1xw4XQdgMpTTR/MjTBS5YFKp1MM83Zh7q4KqcxvRynzNb1tgug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA2PR11MB4937.namprd11.prod.outlook.com (2603:10b6:806:118::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.31; Wed, 14 Aug
 2024 08:15:00 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%3]) with mapi id 15.20.7828.030; Wed, 14 Aug 2024
 08:15:00 +0000
Message-ID: <4f5bfba2-c1e7-4923-aa9c-59d76ccc4390@intel.com>
Date: Wed, 14 Aug 2024 16:19:13 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] vfio-pci support pasid attach/detach
To: "Tian, Kevin" <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
CC: Alex Williamson <alex.williamson@redhat.com>, "joro@8bytes.org"
	<joro@8bytes.org>, "robin.murphy@arm.com" <robin.murphy@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
	<clg@redhat.com>
References: <20240426141117.GY941030@nvidia.com>
 <20240426141354.1f003b5f.alex.williamson@redhat.com>
 <20240429174442.GJ941030@nvidia.com>
 <BN9PR11MB5276C4EF3CFB6075C7FC60AC8CAA2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240730113517.27b06160.alex.williamson@redhat.com>
 <BN9PR11MB5276D184783C687B0B1B6FE68CB12@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240731110436.7a569ce0.alex.williamson@redhat.com>
 <BN9PR11MB5276BEBDDD6720C2FEFD4B718CB22@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240802122528.329814a7.alex.williamson@redhat.com>
 <BN9PR11MB5276318969A212AD0649C7BE8CBE2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240806142047.GN478300@nvidia.com>
 <0ae87b83-c936-47d2-b981-ef1e8c87f7fa@intel.com>
 <BN9PR11MB5276871E150DC968B2F652798C872@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB5276871E150DC968B2F652798C872@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR01CA0018.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::7) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SA2PR11MB4937:EE_
X-MS-Office365-Filtering-Correlation-Id: b35cfec0-d3f5-4ba8-941f-08dcbc393102
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dzdCV2hPOUxGRWZ2cDZ1MzRHc2ZRWTRaS2lxMHBmUFo2bWMrdTUySVNKYmty?=
 =?utf-8?B?TnBscU95WlRtZnVmVnF2Yld1QjRJVjlGdElWRFFHVzRJbkNyemtTd3hDZmhn?=
 =?utf-8?B?c2lPK2xpMFdHcy94L2FmNGc2L09ublIwaTJwTUtlRkh1ZFFHckhKQ1dtcGRq?=
 =?utf-8?B?QlFKU0JMZndHOWcvblMwQTZYUUZDYWxoK3l3NDVLcUlsZ2JseUJwYWNQcytj?=
 =?utf-8?B?TU5SdTV5bE1wdnZmSTNNcThJRS91clZmWXlLb1BPdFZzNG5PMDd2bjAvbWhZ?=
 =?utf-8?B?ZVlPcWk5ZVBIRm1lSm9SWkJmUHd1WHdoc2MzcUZRYzRScWJDSFBLbnhXb1p3?=
 =?utf-8?B?MXl3UEN1SlpHcnNVNVZNVlluM1NtUWY2K0tmaUdKTDh2Z0Mya2lqWEI4Vkw1?=
 =?utf-8?B?S1pSZ3VBWUplZ1paODZJVnpyLzdtUjk0bjRpUFcyNHdTY3NsYUxOaktLR2xs?=
 =?utf-8?B?Qy9QMjBZSVRxeTJCR0I5S2tYRjhyR1B6VFFQRUhhQjJKWkpIY3hHTlcrbnE4?=
 =?utf-8?B?UWx2NjhDUlBJbWZWaVlNalFrem01RG40OWVXRC9SckUva1N2RHorUGl5bXNZ?=
 =?utf-8?B?SEplcDVwMWxrMU5tZ2pNV0JsS044OHdUbnpmYnFKU09ZSEJRWGdsL3lxTCtn?=
 =?utf-8?B?ZGR3elpTajlDUXVUZWpuMTRtbG1GZmxEZGprdzJkYWlkWndVK1h0eXQ1Z0N2?=
 =?utf-8?B?VWRYQ0lnRE5LQW85aGM5OE9laGZ5YUcrM3BIR0pOWXFJb3ZNRDFHeWNERlhn?=
 =?utf-8?B?a3RrYWU3V3FsNzVoeCs2UW5vTU95YVJhdWwvZmZNVjF4aHRUbFVnQkE2eWNF?=
 =?utf-8?B?SFdxSDVJdGltazB1VEJVSkZkR3dpQzNlb0k4aFZsRG5Jdk9oODhvSjFFUi9I?=
 =?utf-8?B?ejBNZ0tJV213eit2b2xOOVkvMXBENUlnSFV4WnVvZC9hMVljdXRzK0ZZSE1L?=
 =?utf-8?B?UzJ1bURMRnZ3UVRsQzZOalZLOWRra01aekM2MHhNMWt1L2tKcnQ0bVdPbDZy?=
 =?utf-8?B?VDFVV2Y0OTBnRkg5aEtUZ1NEVHBiU1ZSU2NPdkQrYXAvQVpBNk8zSFpjSm04?=
 =?utf-8?B?c0FONGJJL2w0ZDdiR283cHdBRDViN2pwbU85MWVpM2pvb2pKNVQ1RU5MZ1ZC?=
 =?utf-8?B?MDd1MzNVdndlLzZHYkQzYURlL2tMT3F6OUxBdlZYaFZZSFpGNTkxa21tY3o4?=
 =?utf-8?B?SEpwS0RKZkkxbjlJWFRtbGQ1ZWcyR2QxTjFMeUs1Wm5JY2JvUURucGdKZ2py?=
 =?utf-8?B?VCtMclVxYkVZd2FreDF3TFVxTytTdU4rUysyQjlzRjhBK3ZmRnRGbHd4Z3J6?=
 =?utf-8?B?MS9JTE5MSjhOc1lIQzE1Z2FFcFZpK1dRSkJrYXk0Y3dzRUkwSWdCVG9GQWF4?=
 =?utf-8?B?bnFkY2RTZmw0Qnh2VWt0bytyWjlSQ1dhKzJYTVowRmFxQTA0NnFldllSdVd5?=
 =?utf-8?B?Q3c5UnR0WjhXWmthQWJ0Y2pReTJTWnBsd1pieXNoRW1qcHhGZ1A4QTVMQXpK?=
 =?utf-8?B?NytlNjF0UWR4akZiLzRGOTdWM3FpSWMyblRIMVhxcFVncWY1VlJUKzUyV05Q?=
 =?utf-8?B?K3dvT25yZUFlSFdkLytTN2Q2V1R3WmdicDFESktOdXpZTElMbEE3RUxNWlQ3?=
 =?utf-8?B?VTBSQjhESG5VdHZ5Yko2MWxDak1mWkYzWVBsaU9CZFl4N29ZanZuU0lVY2tL?=
 =?utf-8?B?NFFWYjhqaUVZSmJaYXh6TWdOQ240aHpFN2JteWNucWJWc1NQYkg0N2ljM3U4?=
 =?utf-8?B?RXBiYnVSbHg0cUlyalc3V214Ums4Z0Rxc0o1OVVVR1B0ZzRIaUU2eTRkbnBZ?=
 =?utf-8?B?YzE0Q2kyNVZtbVAzR0QwUT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZnFhZEIvWldUbTVzUmdLV041d1ZHWFNiNDRYYXQ1K25ZZnpFRnlVRnhGUWZ0?=
 =?utf-8?B?RHY1cjNKdGZwUTZDUmYwbWVPYUk1Z0RNcCtYS0V3bEp3NXFzcStjK0RMckJG?=
 =?utf-8?B?NnI3SVpNc2RlSUs5YUIwUXkvV2crMm94Y3JyT2FCVXAvendLQUlKTHd1TFB0?=
 =?utf-8?B?RndTRklDcHhmWURkM0VzS2NUUFhPbzk4SjdRTTl5dWlESlNiekNhV3BRajN5?=
 =?utf-8?B?cURlR3lNMU4yVXUvQVVOZ3ZHK2htaUlDaUlvaUhtSnlMazNsbnJ0QzV6QXM2?=
 =?utf-8?B?ZVR4a0c5c1U1cmxXNjhobFBuTHJqdDV3TkhSMTRaTmpZanNGSS8vSXhGOU1H?=
 =?utf-8?B?Y0xGY1lQTi96bHd1eUlab3ZvZFVUS3pCSzNBWW5tRzZuWGZJN0FDenNDRFZS?=
 =?utf-8?B?OFVxdE5IL3VhbXhScTRLUWJtMm5vZUJBVDAwelUxWXRZSGJjOFNGK2dpOUth?=
 =?utf-8?B?UGpnTElqbzBGWnZKc3BvN1dSWTdmQytJd1JMRmdJN2MxS0gvSFZEQms2OFh2?=
 =?utf-8?B?aEVXZytzdFVxSUt1Y2hkMWJhUFlGN1paaTZDQTN0OGloQkNZM2hYemVXL3du?=
 =?utf-8?B?WThNeFNUdkFVM0xUSHkzVFcrSnFxK0FVcGphVThUdjRFZWxlZ1M1ZmhXN2c5?=
 =?utf-8?B?eDdqZjNnOHZmcEdrQmxrNk1wTGxPVlFJMmF2d2xVT1ozaE5iVjB3ak1tOXAw?=
 =?utf-8?B?WDNDdEdYMXlnQlM5Nkducm9sQUxTd3VBOS9QNTZNRVdLSnZROWY1cSthQVhn?=
 =?utf-8?B?UWNDclVTT05sOXJoNXFwaDZpZlFhMHQrVlNKOW96OGY2SGpRNmVwZXNSU0lE?=
 =?utf-8?B?MEdaWTJjNW1lRkluVG56bGhpWlRmaVpYYzY3Mkk3dE5QYjFvOWFEUXdZRVUx?=
 =?utf-8?B?T0Nxb29ndlFIV1JvR1Q1MzhZdUlMaktyTHE4dFhZbGNycWR4U2pvNmpxOEhp?=
 =?utf-8?B?ZGZ3MldOOVBIWmJlZ0x2NCtBSExTekRnbStXRWpteXBCNU0reDVsRkxKdG1v?=
 =?utf-8?B?MFRIVXU2M3JZUGJBckt6ZCtaZkdlV0JNdmNXNlplMHdnNnNaRzg3SFhKdmNG?=
 =?utf-8?B?SGlkWEVrR3pxWExBVmtEeDIwNzRRWWVCamdnVEF1RGU0RGFPZkRQcTNXQTYz?=
 =?utf-8?B?ZUZ0NXVlZHFNektpMlVQT0c3R3U0dm9kU0tmSFMrQ1d2K29JSkRzR0V6WWpH?=
 =?utf-8?B?UnJWRC9XQXUvMGNkUC9kWVQxMVJzdGxBYW5xeElncm5HaFE3ZzNzVWRvZ25R?=
 =?utf-8?B?eWx4WnpBa3B2WDUwZmtnTXE1ZE1hdVpkRCtyYzUyS2hNSk1kMmc0d0NZTlpZ?=
 =?utf-8?B?N3EzTEE3b29kd2I4bzVlY1BKZ3RzV0Y4U3hISnB6R2lOQVBEQ00vZDdudG1H?=
 =?utf-8?B?dHQ3c1NKRUo2VmROYjE2N1hWRzhjdlVzYldnOWpnckpTZE1mL0Z3dXJtMGda?=
 =?utf-8?B?T21mM29NMlBVNXBaVG4ybnppdW9jYythWHhzYTJYb1hEQ1RWWTZBdnFvY1A2?=
 =?utf-8?B?S2F2MFMwZ0hjQS93bzVrRTJNZU5qbGRWSGtZa0RTWHlxZ3JJUE9yVGIzVHZN?=
 =?utf-8?B?Rm8rbDl5dWsrQ1R5OC95Rncrdjh6TW9pZFVMMVpMR3FXZHlWcVh5RlRqWEtO?=
 =?utf-8?B?eStzL2tLaG1IN2MySHlHUmZIOHc2MTdnMEh1YUZSYlVaK2srdnJiZEFVcGZk?=
 =?utf-8?B?VGtuRDYwSzFRVU5ZVGR4ai9kQXRDQk9SV0x1ZEoyRTJaV1I1Z0xVcG96SVNX?=
 =?utf-8?B?WURLaGdMZ0phSmE3VTBHeXFpKzBOUVlUOUZTMnhhZThtUHBGdW9BcThtK3Qw?=
 =?utf-8?B?bzdyWjNBNHFwSWd5V21VR2RxYVRvMEhlSS8rbnZTSUhzRWNZZ3hJa3ZWdlFH?=
 =?utf-8?B?aEtVQXYwUVl1RFJJUHFFZ3NBWDVpWjVRamVkNlBTVjU4eUdOSTh3YjZGS29R?=
 =?utf-8?B?eEFIODg4QUxSaklFMkVsbTBhKzFFY05SMkRvWmNxTTB2Uk0xNjU4a05pSEVP?=
 =?utf-8?B?YzZUUlJuYVBJKzVTUjJWWlMwVDdVQWxDTlhNTWNRS3A0eE9mMDZIVGxOakxv?=
 =?utf-8?B?ZGFZazQxVFNuRVYzeWRNV1paMmhlNGhIRlVqRnI3SCt1QjgzcktlSHZtR0lu?=
 =?utf-8?Q?HzTdGhqNp4d2W40+Sp5SgRRg9?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b35cfec0-d3f5-4ba8-941f-08dcbc393102
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 08:15:00.4331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g8wqQcWtKAs43lN79wgsAsnMW95ROQCvZzDbfJOIKJ5CRuzctRpQOfTry+mw66SlRrIfSKojpVGS00u+TK33pA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4937
X-OriginatorOrg: intel.com

On 2024/8/14 15:38, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Wednesday, August 14, 2024 2:39 PM
>>
>> On 2024/8/6 22:20, Jason Gunthorpe wrote:
>>> On Mon, Aug 05, 2024 at 05:35:17AM +0000, Tian, Kevin wrote:
>>>
>>>> Okay. With that I edited my earlier reply a bit by removing the note
>>>> of cmdline option, adding DVSEC possibility, and making it clear that
>>>> the PASID option is in vIOMMU:
>>>>
>>>> "
>>>> Overall this sounds a feasible path to move forward - starting with
>>>> the VMM to find the gap automatically if PASID is opted in vIOMMU.
>>>> Devices with hidden registers may fail. Devices with volatile
>>>> config space due to FW upgrade or cross vendors may fail to migrate.
>>>> Then evolving it to the file-based scheme, and there is time to discuss
>>>> any intermediate improvement (fixed quirks, DVSEC, etc.) in between.
>>>> "
>>>>
>>>> Jason, your thoughts?
>>>
>>> This thread is big and I've read it quickly, but I could support the
>>> above summary.
>>>
>>
>> thanks for the ideas. I think we still need a uapi to report if the device
>> supports PASID or not. Do we have agreement on where should this uapi be
>> defined? vfio or iommufd.
> 
> IOMMUFD_CMD_GET_HW_INFO.

I see. TBH. The existing GET_HW_INFO is for iommu hw info. Extending it to
report PASID supporting makes it cover device capability now. I may need to
add one more capability enum in struct iommu_hw_info just like the below
one. Perhaps name it as iommufd_device_capabilities. And only set the PASID 
capability in the new device capability when the device's or its PF's pasid 
cap is enabled. Does it look good?


/**
  * enum iommufd_hw_capabilities
  * @IOMMU_HW_CAP_DIRTY_TRACKING: IOMMU hardware support for dirty tracking
  *                               If available, it means the following APIs
  *                               are supported:
  *
  *                                   IOMMU_HWPT_GET_DIRTY_BITMAP
  *                                   IOMMU_HWPT_SET_DIRTY_TRACKING
  *
  */
enum iommufd_hw_capabilities {
	IOMMU_HW_CAP_DIRTY_TRACKING = 1 << 0,
};

>>
>> Besides, I've a question on how the userspace know the hidden registers
>> when trying to find a gap for the vPASID cap. It should only know the
>> standard pci caps.
>>
> 
> for the initial implementation VMM doesn't know any hidden registers.
> The user passes a new vIOMMU option to the VMM for exposing
> the PASID capability in vIOMMU and in device, based on info in
> IOMMUFD_CMD_GET_HW_INFO. The VMM identifies a hole between
> existing caps to put the vPASID cap. If a device with hidden registers
> doesn’t work correctly then then a quirk may be added for it.

I see. But we cannot know it until a guest device driver failed. This is
acceptable. right? Perhaps this should be documented somewhere to let the
user/device vendor know before safely exposing vPASID cap on a device. :)

-- 
Regards,
Yi Liu

