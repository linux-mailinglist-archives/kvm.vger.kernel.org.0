Return-Path: <kvm+bounces-33558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 220829EDFF9
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 08:08:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 248CD160214
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 07:08:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 547E12080C7;
	Thu, 12 Dec 2024 07:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lpslCQSE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDD62054F5
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 07:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733987304; cv=fail; b=WKijSGol5hxc6hF8SAtjWI9woPKtO2dnEVcVn3xVAuvr8ojGPWEGcc0Hk4sbVAPAUD2ibememrIjp2UdY/mJjD7U6odV6S/xS7G9F5lt9dKyY4eh03M+1vOv8yuGeAE3gEG3wv9KEvU0RUu0DSoTocz1e3bYE6782ld/uYFrwXY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733987304; c=relaxed/simple;
	bh=4ZNvviaOGCIrrz1bJ67zpSXzAGOGC5oAauLq/mPYxVs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Lvcb366Hj9nWiknX7zCu9QJ9sXhPWFTZBC8p3rcBDugc51CZAXhkeaN1dLaQ7S6GfUw79r2drb6MYjQSHQxo0ZBloVJtQAOp82gnuFHYauw0hA6SG9lKjIPyedy+gWI5hwApfkSHdZceS/d4IDk5opwCM+LE9P1b7R6QbBRagdE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lpslCQSE; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733987302; x=1765523302;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4ZNvviaOGCIrrz1bJ67zpSXzAGOGC5oAauLq/mPYxVs=;
  b=lpslCQSEY+u+uFyBMY6XJL2QAlSwIfi1ECODQuyM86e92713Ei6QTaFN
   s195uVQEUS2Z2mSRkDNaWxltODujKUYcfAdHQ86hEtCcOp0aDKMZ65zIo
   3nbxTCy4ejKj3BjXUgUXhdi6csn2lRn53U8kY6XCKcH2oc2QufgjznXTF
   RFO07OxMMYDAKmBTtEGnbgwheTEeyqZ5hjIY33pmFMkK6DzfFT9GW7wzK
   K4LLjIBwV8sxEbCNNKdEevNMz4JNHFCvKXbpp9XISqPpwQfJwQ15Oy5Sd
   xR0IMqwYBFh9KRwccdImgPEH8VbYe6Kh5DIjzMpKoYw7N27lKZ3pqxDh8
   A==;
X-CSE-ConnectionGUID: tdXAfcW0QT6L7tZ92noUNQ==
X-CSE-MsgGUID: zjdqskyPTVy7VJRor0ve5g==
X-IronPort-AV: E=McAfee;i="6700,10204,11282"; a="45798321"
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="45798321"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2024 23:08:20 -0800
X-CSE-ConnectionGUID: TEwF7N0HTa+PK1cSZS8kdQ==
X-CSE-MsgGUID: ZbdF4+S8TN6ZiaZL1zwGWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="96940422"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Dec 2024 23:08:20 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 11 Dec 2024 23:08:19 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 11 Dec 2024 23:08:19 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 11 Dec 2024 23:08:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FopjLDhl+L3A+3/xAyyRa7yVRlYeuzX7Myq8NR5wJMCa/asUWoQG8GdLgg0ows1F1Gdijbh8pBmkC97mpF7YU46yxRfKnslnedM2vvG4VSxtrLNTlonBkx2FRe105HF/1+7WwV5MFTNJEmxnH8gxB3ot3tRT0bGDfPMh7aM755UxiaZitrhOGiL6F0k/JHuDsk65LhnAPdEwo1UJ7p7eyNQEmDlJ8Cpn5fEN84oKaaMElPdu58Rg3y8IO9YHYZvKh9OCK0WaZxGnZrIzI4rQ4oQmbbVji0e/926xxDEViNenlCbn8yZiLawVacRXKsLCNjElJ9Clm9vKS37Vit8HRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gp/LXhf26upNOpyv/R4wBrXp5vV4O3DrwHTBQnErgCI=;
 b=vxenj82AqcM4bNEvjac/xXJOoW6YVSsOjrQzsP3svN2xarZN4vDL2WLVWfjZZphcPXnmnCnN/F69oOKKwPp7ame6UY/PKhjT4kBXPbn4GN4o8Xzf3hCgusDP5f6e/CjAz1EM55h3Hp7f/nbUTzRiVxLVe5EGjiDfUS+zymbVlWxzkD2QCcDmSmVxgfX2P4Iyn+8aoWtcJbKWWi4l+tdpLZjKS9+SOa0MZl6TorrlFOu0bJ1TZRLemv+6quz9Ud+809ia36z9OCxoeXXiHMWEWDEHKIPYp8/5RF2Y4k6Ms9+U3a5iDv3Hv9bS3Jbh/i8vI0C14LO0cpmXyV8otWsiPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MN2PR11MB4582.namprd11.prod.outlook.com (2603:10b6:208:265::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.15; Thu, 12 Dec
 2024 07:08:17 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%5]) with mapi id 15.20.8251.008; Thu, 12 Dec 2024
 07:08:16 +0000
Message-ID: <98229361-52a8-43ef-a803-90a3c7b945a7@intel.com>
Date: Thu, 12 Dec 2024 15:13:14 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/12] iommufd: Enforce pasid compatible domain for
 PASID-capable device
To: "Tian, Kevin" <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
CC: "joro@8bytes.org" <joro@8bytes.org>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"vasant.hegde@amd.com" <vasant.hegde@amd.com>
References: <20241104132513.15890-1-yi.l.liu@intel.com>
 <20241104132513.15890-9-yi.l.liu@intel.com>
 <39a68273-fd4b-4586-8b4a-27c2e3c8e106@intel.com>
 <20241206175804.GQ1253388@nvidia.com>
 <0f93cdeb-2317-4a8f-be22-d90811cb243b@intel.com>
 <20241209145718.GC2347147@nvidia.com>
 <9a3b3ae5-10d2-4ad6-9e3b-403e526a7f17@intel.com>
 <BN9PR11MB5276563840B2D015C0F1104B8C3E2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <a9e7c4cd-b93f-4bc9-8389-8e5e8f3ba8af@intel.com>
 <BN9PR11MB52762E5F7077BF8107BDE07C8C3F2@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB52762E5F7077BF8107BDE07C8C3F2@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0042.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::17) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|MN2PR11MB4582:EE_
X-MS-Office365-Filtering-Correlation-Id: 7554fa55-bace-47d9-cba2-08dd1a7bbfee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eHBkZ2R0SXdEY00wRUtsdnVmam1QUTM1RjJkRzV0OTlHWDNYdjN1emNXdzNT?=
 =?utf-8?B?M212WlQ2eitaNEdpZC9EQU5PUHRNQUw1MGhsMVcyd21IWURVNWJVVmhnSkRB?=
 =?utf-8?B?cXpBKzNucWFXcjNHeXZVY2JzZXE0cW1SQzBWWlBzSHgxRUgzUEVmY0NYQndR?=
 =?utf-8?B?MEl4OENMMG96SUJRcHlUN0xVNGp4NXNMeEZ0QS9QWnQ0N2xmMWZjRFhLYmZh?=
 =?utf-8?B?VEVJejRKSWs0ZHpBR2lPazdXVXZFUENPampsdW9nVzZTSGYvL2p1elgwK25E?=
 =?utf-8?B?WHpTYmpvakUrc1N4MzFRWDJ0c2lCc1hEdElUNmdYQVBUTGxPV3VkSzY1bXcv?=
 =?utf-8?B?c3hDM1EvOVp1QkFJaVJ3clNmT1RwQ0JZQzJkOEd6am9YL0NHeS9NczVHSmVQ?=
 =?utf-8?B?Ym4yRnJnd2lETDFlQU5MUEJHTVc3eGRVb3kzd2dGb1FSbDhjZzcrMDQzNTRC?=
 =?utf-8?B?by9adWRYeVlZTHhRMGZGQmpwM3c3NVo0UGJSK2lXTVE4TGdKMlFXUnUrckIz?=
 =?utf-8?B?dXJtRjdSR25MN2NBSFNqUEFFYjI5bFN5SmU0UkU3ZkpBVzVJdGlwQjZ1Q0pu?=
 =?utf-8?B?NXllMnZ5QkljaUs1clF6OGxZMDI4UTRsdGpKVDFMYzZKNW1Fb3BRV213cXgw?=
 =?utf-8?B?cDdpOWlESlpYa1NtMjB6WENnS1lDR2N1SmVJQVNPRGFsNTJ4MnBzZzlSUjJo?=
 =?utf-8?B?ZE56bi9pVHh1Z3RlRkQxaTBVNkZXQ0Y4ekRBNmxvS1NwTzU2c0kvUkpvWmpF?=
 =?utf-8?B?a0xvWUk2by9ZZHlNRnRyYW5ZN3I2dUJPRGttRGNhekUzRFJEeUNuYXh2M25D?=
 =?utf-8?B?VVlRdTdCZFk0MUtXcTVxSmJoS2NQSmpKY1hGVmVRM2xxbXRmYldUREJONTVR?=
 =?utf-8?B?SFJ5WnVFNWdCMCtRS2dOQnA5RHNCdmdPdTdBUHJScmE4WHNMTXQydksrZFA0?=
 =?utf-8?B?Mk5HdDZ6KzNwQ3pkbFk4ZlFpMnFoUEpIS0NnbllUVFhER25LZllEOWoyYnQx?=
 =?utf-8?B?NEdaK054d1hUS2hJdnVKM2pQeUx5b2g3UWFydlhJK3A3YmhtdVg5Z1NCWmdk?=
 =?utf-8?B?dTdxQnVBUXhsODhoSktSV2ZkazN5d3hNR2lBbi9EbkJyRmZ1MlNVc2JsVzZ4?=
 =?utf-8?B?OEZudTFVTGlWdGtmd2N5aXJZVU1DckNGK2pTR0U4MXZKVWU0RjB5aFNtMFNr?=
 =?utf-8?B?a0xIbFBIRUNTeUpFVTNQdE1OUndaN0lvTWorcHA3Z1ZsZHV2R2d4ZFNpeVdX?=
 =?utf-8?B?cTRrREsxaHd5clF2VzFLOWUwQmZhN0crVE1TWHEzOW1xd3R5NlVFeTU2RE1F?=
 =?utf-8?B?ZmN0OCtMVWtyem13c0dzWXlxTHdwSFVVdGJXMkJZQm1pUkRtSlo5cXJxSzdD?=
 =?utf-8?B?QUtKWC9SRHhXY0QzTmhWeFdWUXpTL0dGNWljdjRNV0JpaHNrNGp0RkhuMVJz?=
 =?utf-8?B?QXEvZHdIeGRUMk0rL1BJZXZGMWVZTjQ1K3piaVB4cE0wa3I2dDdXWkl3dDl2?=
 =?utf-8?B?bFErbmU2QXl0SWFZbE15VW1Wai9uUUkxZFFyWHlPVlB2UDJRTzhRRGxJZW0z?=
 =?utf-8?B?U3ZYV0Q1ME1tbEFsTVpDZG1jdkJ5aTFmemhoUlIzenUwUGhuVUkvdzhFM041?=
 =?utf-8?B?a3MyUk5KRDZpdXlreUtsWFdxQ0tLa0ZsNlpWemlPcVJ0a0VFNXZ3MldyK0lD?=
 =?utf-8?B?WkF0VTRENFQyN1BSRzNLR0ovWmVCZ1R4QmQ4WjI5RFErZmhvSFBBaFRiTk9u?=
 =?utf-8?B?NkVMQy90ZG11NytTaTZuTnphZ3RBUnFFOG9aWDRoeVhnMjVWTmZkRkRvek1n?=
 =?utf-8?B?ejQrd0ZJNldCRXVsdHJUQT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VEx0UHpYMWtzZXlSY1BQVk9rSW5qRHh4Um5zU0tRdEtHbWZkc1NWMjRVL2xS?=
 =?utf-8?B?YXZvV1YzRTU2enJOU2VrUGs4WnZHRmFGYWtENmZObTluVXA5TzJCQnhnWXdu?=
 =?utf-8?B?dUUvQ2lxakJyUjI4d1hQT251MlkrTW0rejEvUmJxS0JjQ3h5NlJCa2pKaXlU?=
 =?utf-8?B?WTdsRTVGSDloUis4RTExU1NlSlRZUkZiUzBwSDNjdmFoSVMwR1REclAvbUxG?=
 =?utf-8?B?bWtZZWdOV1ZyajJVL2NYKzdSSW8xbEFnQUJjejJUU2piQ1RnM2crZGthemVJ?=
 =?utf-8?B?aHJJQUk0cWFhTUREYWFOUnBESDVSQ1RYdDRTNWY5YmN2aHpyTkRsUVA2UjBo?=
 =?utf-8?B?ekZ3WDVudnhFZHFhMS9QNGNCWEkraEhUbCtNZ29vTDdzdlZuUnJpSklyRW9p?=
 =?utf-8?B?dEt0dU0rM0tsbURQeTFkdXdEZjZjZldDTjJTWEVXbnprdmpoa1U0QVpJUUlP?=
 =?utf-8?B?Wkx2dUpBRmNDR3l1WEYvQUxSWnRmTS9qQTdGMldKdE1ydktPUktvUlhQREdu?=
 =?utf-8?B?Z3l6TndGUkZYTStSblpjZmh5YlNneUVtR3hiZW5YanBDS2VhVTUzR0hBdGxH?=
 =?utf-8?B?MEptL0VCc3NkNm9TTjBiR2x5d0Mrc0JDQXBzTTV5T2I3cmZoV2ZqMGk2ZnM1?=
 =?utf-8?B?bmE3aHRWUU1nTjBYUE1DUnRwSkwxeDJyL3pxT2Y3emY5VW1Wb1BwWlBhRG95?=
 =?utf-8?B?RFBYVHdJRHlrN3E5QVhRaDMxQW5FVTFGa0dKL09NVFc0WEgrVmtEeDRaV1p3?=
 =?utf-8?B?NG5GazRQRUorbE9JUG1EZ3duZC94OWROSThLK3hKdW53cVBNdzNkM2psRVlW?=
 =?utf-8?B?ekxIcXRkRVFEVGYwSjFGcGExZXlTSGE3Y3pCaUF6UWdKUjJwUUk3Vzc5NlhS?=
 =?utf-8?B?OTFxcEZmUTE0SWdaZk9DbWdKbDBBeXFMVThuNGxvR0VXcVc5MGRYOVlYQmM5?=
 =?utf-8?B?ajlYMnpJVDk1OFJBV0FHa2NQeFQ4RnkxNDZhTVA4OGxmTjZpYXcxeGs2QWE0?=
 =?utf-8?B?S00rdlp1Tkk0cXlJQXJITWtCYzYwSm1rNUJmd2djL0loV2srNU1OZjRVSWcw?=
 =?utf-8?B?VFR1SzlBc0lkWjFMc09PVS9YTzNCcDkvRGYzYzBCNVYwQmJxbk0wSmk3TTZ6?=
 =?utf-8?B?TXFhQ2lRUVVNb1NQMlFaYmQwY1IwNCtaSU5rMU00UzZiWWtrNUZTQk9QMU5r?=
 =?utf-8?B?bmV5SGtNK05kaTFZVGdaV3o3Ynh4aFZhVXV4V3cvanhyanpSeVpRR25DRmVP?=
 =?utf-8?B?Z3hQaFFwaWhobzZBdGpXUTY4R2lKYXExVTJHQnRCMklFcm1jWUNnZzR5cjlQ?=
 =?utf-8?B?Skp2VExjZ25yRTl4MFNSSWFKN3I1QTBqdXZBa1hVTzZsYUNNbTl2dnl2bXpt?=
 =?utf-8?B?Q0p2cU1uQTBUZEtnalViVzdyNTFXTktHRWFZNmpRamFVV3FWenZZMW4yaVIy?=
 =?utf-8?B?WSs5b2VoTVp2bnBqWWFjNFFBZHhQclRBVG1MZUVZdUZXTS9CeGtXcG1ocktu?=
 =?utf-8?B?OStzMS9HekRlV1JDRHVGd3JTa04zREJOWStNaVRaVGp4NWVlS0Y3SFljUmEr?=
 =?utf-8?B?RHpsaVI2TXlicDhFaWVKUjlRc3c1K2lxVklUbzh2VkVTMEg4dzk4ZTc0UXd6?=
 =?utf-8?B?YytGR1R0ZHJNcVlzZ0pKRWNLSTFqd3F2Y1diUkVSWTJwTWZsR2xXVTczb0tL?=
 =?utf-8?B?dXZIMDgrVW1pckdIdXdvSytPcnRoWjN2VkpUWFJOT2xRZ3Q2bHlaekNxcGF4?=
 =?utf-8?B?NEY0SWhOdzBxWXU0SEJtS0RZdjl2YVU4UzlWakJRM2JOQzFmZGxWM083OGoz?=
 =?utf-8?B?eVZwWng1RWxTODVuNnhhcGJxdDdnY09nRW1aYWxXcmMvU1owNCtyN05XaEVo?=
 =?utf-8?B?Z0t6THZSSmpjVC9ia3g3NjVTdVFPcWpFcDFwc0JUdlZid3BpdC9ha2xTZTRH?=
 =?utf-8?B?SUtDdlNqanAxejMreHRaRFVqMURvSmEwVFV5NDRwaC82WTJtVGFQTnJnVERx?=
 =?utf-8?B?bjRZNUpZMDlxNVFkajA4SFRzMDZkdXpBZnAwZ3lBOWFWVmh6TVAzQWFrcC9Z?=
 =?utf-8?B?QmZsT0lySVhLQXJPMy8wRmV6NXZqSjZXblV1U1EzZ2Q0bnpvY3lsREtSdkFo?=
 =?utf-8?Q?VmSr9szTn+dtPxT5qrq/imOYN?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7554fa55-bace-47d9-cba2-08dd1a7bbfee
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2024 07:08:16.3679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jW438I0NFj31NFqll1ioafFdyGtB3k6kWjx3s2pwstq5ddPJQBqcoLKYIqBH+tVOIRIPFBFheWLlvQZzVALtyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4582
X-OriginatorOrg: intel.com

On 2024/12/12 13:51, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Thursday, December 12, 2024 11:15 AM
>>
>> On 2024/12/11 16:46, Tian, Kevin wrote:
>>>> From: Liu, Yi L <yi.l.liu@intel.com>
>>>> Sent: Tuesday, December 10, 2024 11:15 AM
>>>>
>>>> On 2024/12/9 22:57, Jason Gunthorpe wrote:
>>>>>
>>>>> We want some reasonable compromise to encourage applications to use
>>>>> IOMMU_HWPT_ALLOC_PASID properly, but not build too much
>> complexity
>>>> to
>>>>> reject driver-specific behavior.
>>>>
>>>> I'm ok to do it in iommufd as long as it is only applicable to hwpt_paging.
>>>> Otherwise, attaching nested domain to pasid would be failed according to
>>>> the aforementioned enforcement.
>>>>
>>>
>>> IMHO we may want to have a general enforcement in IOMMUFD that
>>> any domain (paging or nested) must have ALLOC_PASID set to be
>>> used in pasid-oriented operations.
>>>
>>> drivers can have more restrictions, e.g. for arm/amd allocating a nested
>>> domain with that bit set will fail at the beginning.
>>
>> ARM/AMD should allow allocating nested domain with this flag. Otherwise,
>> it does not suit the ALLOC_PASID definition. It requires both the PASID
>> path and non-PASID path to use pasid-compat domain.
> 
> hmm the main point you raised at the beginning was that ARM/AMD
> doesn't support the flag on nested domain, given the CD/PASID table
> is a per-RID thing.

yes.

> 
>>
>> So maybe we should not stick with the initial purpose of ALLOC_PASID flag.
>> It actually means selecting V2 page table. But the definition of it allows
>> us to consider the nested domains to be pasid-compat as Intel allows it.
>> And, a sane userspace running on ARM/AMD will never attach nested
>> domain
>> to PASIDs. Even it does, the ARM SMMU and AMD iommu driver can fail such
>> attempts. In this way, we can enforce the ALLOC_PASID flag for any domains
>> used by PASID-capable devices in iommufd. This suits the existing
>> ALLOC_PASID definition as well.
> 
> Isn't it what I was suggesting? IOMMUFD just enforces that flag must
> be set if a domain will be attached to PASID, and drivers will do
> additional restrictions e.g. AMD/ARM allows the flag only on paging
> domain while VT-d allows it for any type.

A slight difference. :) I think we also need to enforce it for the
non-PASID path. If not, the PASID path cannot work according to the
ALLOC_PASID definition. But we are on the same page about the additional
restrictions in ARM/AMD drivers about the nested domain used on PASIDs.
This is supposed to be done in attach phase instead of domain allocation
time.

-- 
Regards,
Yi Liu

