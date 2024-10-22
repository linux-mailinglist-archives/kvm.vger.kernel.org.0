Return-Path: <kvm+bounces-29402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CF58A9AA277
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 14:48:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 531541F23737
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 12:48:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBAA019D880;
	Tue, 22 Oct 2024 12:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Sa6dt3Jv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8021537D9
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 12:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729601248; cv=fail; b=rbVd1sWwnryefAiZ2PedwRHlUj0oCqbrXZFQnn5LJJQ1u1WPUb4Nb8ZUEoYg5eubNIxquM9+XwK3EAssCKIyZHBkUGCYJa01gGieedC2zHnn4Fp8oGkPgUZMwBdlu67aCChAelBc2phr/PaWOcuXT5i65iwHBheVL7Jtapts4+4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729601248; c=relaxed/simple;
	bh=blVD54kEZUjhzKhm710EG38D44fZ/VUsWpXBjwyBC9c=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FnUToYe5vjobbgvT2S7+dimWmpnv1DyiQwA4sUkqxCAhapWYjea4ihHXARvsoCjr7ie/JX0Loq3yF8AD/TkFQXywglIAfsZRkwxsVekPCoSZpxjq9kAujK7WTmtwax2cb6nv3ID1qFzui0FxDmxRkLWlwE6OJzrFPGlXGp3Exko=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Sa6dt3Jv; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729601246; x=1761137246;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=blVD54kEZUjhzKhm710EG38D44fZ/VUsWpXBjwyBC9c=;
  b=Sa6dt3JvTRqdpBMElqQ6EGcAZ53MSH3mRFHlS4bDq9LcCldFPCZZg83I
   40gudR95BDLo9Du6uEWN+ToarnmH9tRZ+0/xH6kvSHb3X813GkxtkjRiV
   R0cT/Z0gU3Hqd1a3KyAa6QvuvvFTAvJ7t+dZTCb2RCds7QUzr34IyvAiJ
   P7Gz22xwa2CABRMU/Cl1krIIvPoydDsOs3epH2l1mN9iARgbfCGUOCnSQ
   SAldPLIlCNJYjQj/mN0mCIS5QGx7WtfSPegvz/qCOSh40xrIug1SQPKYT
   Wq374VY4PXWYfXP+tp1vhNlko69Suc3eEzGbzJXDlEfGGdV00BKXyEkRY
   Q==;
X-CSE-ConnectionGUID: 523+cJcKQsmZc+E7iXV+lw==
X-CSE-MsgGUID: tsRu/4NKSNmcDBnMceSOmg==
X-IronPort-AV: E=McAfee;i="6700,10204,11232"; a="16760511"
X-IronPort-AV: E=Sophos;i="6.11,223,1725346800"; 
   d="scan'208";a="16760511"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2024 05:47:25 -0700
X-CSE-ConnectionGUID: uePN0Um7SY6srqLXz96TNg==
X-CSE-MsgGUID: pJCLLCOgQ7KiAEWV+PpyxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,223,1725346800"; 
   d="scan'208";a="84939176"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Oct 2024 05:47:25 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 22 Oct 2024 05:47:25 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 22 Oct 2024 05:47:24 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 22 Oct 2024 05:47:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EB2T+u0agu8GP5++bKmj2CECQKf4VZH+iN1HWN302Zx5vvBSkpM/cZ4879+3Cdn7ZpPV48SThIOH9znCr3EeDosgJsRFM2H6sRw5HEZvJREzMMCtGcQHX8u7NaxZnUmueP97mmh3yX2i8/mMs2a5JYKfjQzTSGYT4valWCmiy3IeULLrOMG++Zp8TZuV63NB2F12/3Rv/iz4TcOgNT3bs4WQFljh4ym9l+1gGiTUauntrfLxTCYvJX2/rbZZwgPcLMkNky8z9m1JcTgFpHlU/13pcOGKn9zjqTDsJpen/NOj2ZCljvDp0RtiNpI+9f5650N7DbFgc9yud2FCgWoCNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IAOTxGEgrIShJhqjhbKDievxFWHGYWMtfFQ6cCYwMYk=;
 b=WGBoOIMo3iOAa8I2h8NpburnFRxFQv0rA+0QECqg1HDLkUnBrRIH5XzYCQ/td+bH16U3rJT8gE/hOiP3KsHiAfJ/ItsUrjiIEGM0Bb2BJ4LSm4W1u0/OS17+1t0FmomQtAkRuZx+E4nWZCt2U1Dff4EfYXDDrR6Nh9KCmBN1Y/UQ2IIEUI3g1yDK3NLLBH8gpbwaE1JL6VUPKr/HzoIBstO7hL0G/0Zw1LqCf3pfIYho7KZou/YaEq/SRYbD4JgLTxpwX6sV+R9D1NbVuZ1kQOi/RgxkMo/EewvolfH8SDbiMjR6SPwbzWF7u7mxgbpbY3KdA1yhkDUxR1zJuB1qDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA0PR11MB4669.namprd11.prod.outlook.com (2603:10b6:806:99::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.16; Tue, 22 Oct
 2024 12:47:22 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.8069.027; Tue, 22 Oct 2024
 12:47:22 +0000
Message-ID: <91141a3f-5086-434d-b2f8-10d7ae1ee13c@intel.com>
Date: Tue, 22 Oct 2024 20:51:56 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] iommu: Add a wrapper for remove_dev_pasid
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <joro@8bytes.org>, <kevin.tian@intel.com>, <baolu.lu@linux.intel.com>,
	<will@kernel.org>, <alex.williamson@redhat.com>, <eric.auger@redhat.com>,
	<nicolinc@nvidia.com>, <kvm@vger.kernel.org>, <chao.p.peng@linux.intel.com>,
	<iommu@lists.linux.dev>, <zhenzhong.duan@intel.com>, <vasant.hegde@amd.com>
References: <20241018055824.24880-1-yi.l.liu@intel.com>
 <20241018055824.24880-2-yi.l.liu@intel.com>
 <20241018143924.GH3559746@nvidia.com>
 <9434c0d2-6575-4990-aeab-e4f6bfe4de45@intel.com>
 <20241021123354.GR3559746@nvidia.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20241021123354.GR3559746@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR04CA0009.apcprd04.prod.outlook.com
 (2603:1096:4:197::8) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SA0PR11MB4669:EE_
X-MS-Office365-Filtering-Correlation-Id: e8495a07-84e8-4a46-b840-08dcf297ac3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?V3R0bERWazYyV3YrUDRmZk81WDRhQ3VDejZXeDJMYjdVY1I1OGt6NXgzMG1N?=
 =?utf-8?B?ejZJVklJRTR2VjhiSjBNV0ZSWjBjKzE5UVN6RlZ1RXVTTjkyNDYrSnFPSk8r?=
 =?utf-8?B?dm5aNUJHTHMvRjFyUzFoTkk3TkwwM2VwQ3JDc0pkcnBFRlUwZ1J3QXQ5VFFV?=
 =?utf-8?B?czlyY3hOb25OZHJIOXdhMWUveFlGeFlWQ2tHbWVKWkJoQ0thR3o1UGk4ckhH?=
 =?utf-8?B?cEVuQi92Q0RDWFI1elZnNHZETlNLVDVKeHJ4ZVgvbjZDWUFTWE40b2F3ZTNJ?=
 =?utf-8?B?TzlscENwZmczOHFtNHI5UTFxeFRRWWtJYkF3dlY5V1gyL1JXQjl6NlNGME5F?=
 =?utf-8?B?M2RXVE1wclpkZXVoVWFHd05EeExQbDJmQVBHVDdoaDZEZkFZaE1jQUdZRTV3?=
 =?utf-8?B?cHdxZm82T2JueTJLdS9HMUFWZVhpb2FRcU94Yk44ajI1VjkwcW0rcklDWDNM?=
 =?utf-8?B?d05PVnU0UlZSSDZnaXFvcVMzY2JEWnZCWml4QmtkRlpFUkluSjdNYUpUUWtG?=
 =?utf-8?B?RjBjZGVNdGtHTlE4Wk1nQ3V3T3FTTEQ2eVFqYmlVY25JZHgrSjZQRVF4NHpP?=
 =?utf-8?B?OTEwTFFJL2pUdklXQkxDdWk2OW9WS1JxSUZIY0I3b1hKSDFSUGpOdEhrTmIw?=
 =?utf-8?B?Z0NjNk1Cc1YwR1VTdDNaSnovK0xzSGZ4SU05aDdiZkhtVm4wR2dnNm9Yb2Z0?=
 =?utf-8?B?aTdFUjhlbzRiYm90enRSWVZOek1jTzl5RkdnS1ZSMytBSExVaDlIdEw3WENn?=
 =?utf-8?B?NWYwUjU1UVE1cGJaaFVncytSRDRUc2IzRGFUQ2s0bkFqb3RKdjF6ZDBhd0Nv?=
 =?utf-8?B?MnBjS1ZBQ2dpOGRuVit2R0g2Rk13MlVwQkxsU2tPWWtGRlYzbHdwVUdmdEw5?=
 =?utf-8?B?SUlodG4yRStuYVhweEVsalVneE1vYnFSSzJaczJWYXRTVHBmQ1lmY1hXWm4x?=
 =?utf-8?B?cGhJcEM5TTF6cW1la1hvYWd2QzdocWg0RmYwN25JSnFzN2dneHhsaDFYVTEw?=
 =?utf-8?B?cmR3RnEwLzVJZkQ0anZNM3NxRUhZemxsbndRQnJ6bThHd1Y5N2ZsdGFOa1dF?=
 =?utf-8?B?d01TaDlZQ1NqU25pdWpOZFFaR0NWOGxWSjl5RzlkdnJxZnVLRDZoc2V2Ulp2?=
 =?utf-8?B?eW85VGpMRjBLVEl0SXYrdmVrYXlyQkJHMzBLMk5yRldpcVpFM2ttaTg4VC81?=
 =?utf-8?B?ZGhEKzNMZkxjejVEUmhCVm9udTkxaGlJT2g4N3dvSXQ2dTRPRWVGR2pFWFQx?=
 =?utf-8?B?SWxTNDF0K0tPbVhUZ3U2S2pCVWJBcmxtQ3dZa2N2eFVCS3ByTDY0dUUyN1Q3?=
 =?utf-8?B?NVNwRHdhYjlINHhUSkkzL3gwaWVLalhRdGNUVmdjYzMrTzV1U3gzWSttL0Nr?=
 =?utf-8?B?c1ludkUxeGNWQVZVUTNQd0Z4UXcrNVVKL1NTVmplN1dwWDQ0bGZyTTA0Qmk3?=
 =?utf-8?B?SGg4azROYXRiMnFlUFhTalZGRmNEM05KcmMzK0pDTmZHNEpKUkFOdzlCY1kv?=
 =?utf-8?B?RlNWSjEyeE5KeXIwTTNWQWtDL1k3VHBVLzhzbHByWWRzamJjQ24xcElaTEJH?=
 =?utf-8?B?ckxJRmhycUoySjdZTzd5Y1I5azZRN2I0ZU5teXBjVC8yUmV3YUhBQTFpMG1Z?=
 =?utf-8?B?MitoN3JHSjlneUovTGhPTFEyODVsOER3bnJqNVpEWFVQNkw3Y0dDZGhwT0Z3?=
 =?utf-8?B?d1hha3JxVHl5VVlha1p1a0NZNnRIUjV1SzVIbis0Vk9XY0NKR0F5QlRXMWIw?=
 =?utf-8?Q?kRPS9p4SzQrJcERzg8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZHNVNGVSeUtiWEJNTzRmZmwyVkIxanBQL3c2KzNDQW5GTXNJTVFDc1VRZjJq?=
 =?utf-8?B?TTZ3alhIVzVEVjZkNDc0REZEUjFxSUlOQ1JkQUlUL1hjbXVhVzRBQUJtbzIr?=
 =?utf-8?B?cG4xenRHZ2VXRWFmYys3RC9kWlBMV09Cbmx4cFpXVUk3U01ibUZjcStNbVdG?=
 =?utf-8?B?Zms3Wm5iemg2QmRtelM2U1plbTI3TGlBME1PMUY1NmY0Um0xaWJFSVUvRWpU?=
 =?utf-8?B?Vzh3ZlpPUnF5NG8ra2pHVWdwNTR0ZDdXWW1hL04yUWoxWHhKUzVXREVTcGJD?=
 =?utf-8?B?Qyt6bEI1K2o5dWFhMjUxUFY0QWt5cWh4aHNQWmFUTnh4VExBcUNodGlCRE9p?=
 =?utf-8?B?NnhzdmVNSUtDQjd3NlkvNk8zb3NWRXZ5VnFlWDcxb25vamhuc3c2R053MEY5?=
 =?utf-8?B?WGdYMG4relM1RUppWWFjTEs3VTB3cDgvVFJaSkU0WXBXeSsxbHJJbVRPL3RT?=
 =?utf-8?B?UUNLR3BkQkR6MFI2TzNpZGZMWVhSUlV2cFY4c0UxdC9pRW5sUVRseEJvNUdQ?=
 =?utf-8?B?UUlqYVowMDhXc2IxYm1MWDZqVkQ4dlZHdzh2RW02ZVN3cDVWZlZQZ3pVSHZh?=
 =?utf-8?B?VSt6Z05zU0g5dmVXR1gvTkZwelRlaFJ1dkE2Z0FLWm9SVTVNdUFibEpKZ01P?=
 =?utf-8?B?enpCS2t1MkFSWUxhdjhLWitsanl5ZVF2R1pYS3VYV2xaRXByM1ZQc3R6b1FY?=
 =?utf-8?B?TTlRMklNc2VvU3owaGpiZ2RXVnBYM2tvbjNQNEVQMExDZjdlcUhtZ2dNV3JE?=
 =?utf-8?B?ekhJMi9WOStMakRhNGZNMEZwZ28rR1VDcmExaXZVZnFQeUJjdzlZeTRxWXpZ?=
 =?utf-8?B?Mm9VQkZtYkJlNXRROVdtK2EzYUtYdVRJNGpCaTBYUU1OTy92U3R6cWpTNXAz?=
 =?utf-8?B?cjZmZE42SzNGL21vRWxiVXdZWG5sUlZ1SUYvejZkUEZjbG1oemFHL09vYU8z?=
 =?utf-8?B?VW96N1MvNEFqV3lnUFFReTlIa0Rqd3d0bDZzQ1ZtR2ZXWmdaeUV5YmVZeUxR?=
 =?utf-8?B?c1I3eFVHU051c0JBRzNISVBVUHdwUzd0UTcvdHlQMWJPeHlCWXV4Y1NtaGx1?=
 =?utf-8?B?TTNFZXFvTXR4TEhGUUt4TG5MQnVYbCtzYTA5aWI5eFdkTUNnVWhSbjJlblVK?=
 =?utf-8?B?Y0ZqUUthUHJCU2NaV0M1eE8zbW1SeDZtSUx4Vys1YVg5Z0NUMVhnRy9qZlVK?=
 =?utf-8?B?ZWF2bmVuL21PM0FZSllPRmtoUHpvZ3BsREN6Tm5maWtOenBjT2dsb0pBU2w5?=
 =?utf-8?B?eUVOcnZTRTRKb2pNQmdOL1FveVp0WU93NEZvaUFXdTFFb1l5cklsT1ltQjJD?=
 =?utf-8?B?d2p4NUR6aXc5OVNxOVF0SlMxdXNPQTR0cGordnNtcEhFbzdBMDJDR1RSYi9R?=
 =?utf-8?B?NHFDK25icGtJZzRmL003a09lOHJpTDBwVnFQS1hrZ0xRTW12cUxrVWxnTHM2?=
 =?utf-8?B?UTIvS0ptYVhRdi9JLzlLdUQ4bTVhUkxYU2ZKdTZTQy9HS3hCMWlRdFovR2pp?=
 =?utf-8?B?MUQ2am5QNCtqNmhrSVAwRVcrVkwwRzhPMlRkZ2tmcmpmS3NOb2ZCQ1V3SVhI?=
 =?utf-8?B?NUNGMzFhNDE2b2lzYklyNjlaMG1xbUMxZGJmTWFrcmhHRE5oMUxac01pSVZw?=
 =?utf-8?B?S2QvTmx0SjFZNGlnS0dyZWdSWmRvRzBKUS9JQmJPdkUya21kbnArVk16dGQ1?=
 =?utf-8?B?TXFWY1NlZEFrTHRmd3VCNzhiYUhTMmhVZ1ZBaytRRzc3Qmg2M2ZZeW9PYWFV?=
 =?utf-8?B?dDBiaTh2R05YbnEvbnZpM0VOcUFKL1JWbXJqV0tSTXJQYitjVTNveXdLd1hP?=
 =?utf-8?B?TDlRakpVZDg2enJVUDllSG1VZGJHOHZFM0FwMkpPV3ljanBVZ0E3K3h5RGZP?=
 =?utf-8?B?TUpIZ0hxMUdPZ3JYNWVzSS9VRW5qaHlwWnJ3WEg0dkJHMVVjRW55d05mb3BQ?=
 =?utf-8?B?Zk1oblNERzZ0NFlhRjlsck0ycm1BTkRPcUo2ZEhtTUpxaHliVDhENkRkWno1?=
 =?utf-8?B?L0U2MWsyaUNpYndMV0t3NW1HbnlRNWxnUGRDSjk1VFpKMUVsSW9QVEk4VENT?=
 =?utf-8?B?TXpUQlJZNks0N1VjQkVjVFVWVXBqdGpndW5IL1NBdVpCdTFaMmJhQVI2NWQ0?=
 =?utf-8?Q?Tw535067AbErcNlEfBZYzP2UB?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e8495a07-84e8-4a46-b840-08dcf297ac3c
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2024 12:47:22.6694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nKI7vde3WNDi/2jp5RgtqXj8wMmuGm8YgLrQrqI5CP9Puoq3BT+SrDfKpVD4L/pWyg9728Z4zapZcMfw/dr1rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4669
X-OriginatorOrg: intel.com

On 2024/10/21 20:33, Jason Gunthorpe wrote:
> On Mon, Oct 21, 2024 at 05:35:38PM +0800, Yi Liu wrote:
>> On 2024/10/18 22:39, Jason Gunthorpe wrote:
>>> On Thu, Oct 17, 2024 at 10:58:22PM -0700, Yi Liu wrote:
>>>> The iommu drivers are on the way to drop the remove_dev_pasid op by
>>>> extending the blocked_domain to support PASID. However, this cannot be
>>>> done in one shot. So far, the Intel iommu and the ARM SMMUv3 driver have
>>>> supported it, while the AMD iommu driver has not yet. During this
>>>> transition, the IOMMU core needs to support both ways to destroy the
>>>> attachment of device/PASID and domain.
>>>
>>> Let's just fix AMD?
>>
>> cool.
> 
> You could probably do better on this and fixup
> amd_iommu_remove_dev_pasid() to have the right signature directly,
> like the other drivers did

It might make sense to move the amd_iommu_remove_dev_pasid() to the
drivers/iommu/amd/iommu.c and make it to be the blocked_domain_set_dev_pasid().


diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index b11b014fa82d..55ac1ad10fb3 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -54,8 +54,8 @@ void amd_iommu_domain_free(struct iommu_domain *dom);
  int iommu_sva_set_dev_pasid(struct iommu_domain *domain,
  			    struct device *dev, ioasid_t pasid,
  			    struct iommu_domain *old);
-void amd_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
-				struct iommu_domain *domain);
+void remove_pdom_dev_pasid(struct protection_domain *pdom,
+			   struct device *dev, ioasid_t pasid);

  /* SVA/PASID */
  bool amd_iommu_pasid_supported(void);
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 8364cd6fa47d..f807c4956a75 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2437,6 +2437,30 @@ static int blocked_domain_attach_device(struct 
iommu_domain *domain,
  	return 0;
  }

+static int blocked_domain_set_dev_pasid(struct iommu_domain *domain,
+					struct device *dev, ioasid_t pasid,
+					struct iommu_domain *old)
+{
+	struct protection_domain *pdom = to_pdomain(old);
+	unsigned long flags;
+
+	if (old->type != IOMMU_DOMAIN_SVA)
+		return -EINVAL;
+
+	if (!is_pasid_valid(dev_iommu_priv_get(dev), pasid))
+		return 0;
+
+	pdom = to_pdomain(domain);
+
+	spin_lock_irqsave(&pdom->lock, flags);
+
+	/* Remove PASID from dev_data_list */
+	remove_pdom_dev_pasid(pdom, dev, pasid);
+
+	spin_unlock_irqrestore(&pdom->lock, flags);
+	return 0;
+}
+
  static struct iommu_domain blocked_domain = {
  	.type = IOMMU_DOMAIN_BLOCKED,
  	.ops = &(const struct iommu_domain_ops) {
diff --git a/drivers/iommu/amd/pasid.c b/drivers/iommu/amd/pasid.c
index 8c73a30c2800..c43c7286c872 100644
--- a/drivers/iommu/amd/pasid.c
+++ b/drivers/iommu/amd/pasid.c
@@ -39,8 +39,8 @@ static void remove_dev_pasid(struct pdom_dev_data 
*pdom_dev_data)
  }

  /* Clear PASID from device GCR3 table and remove pdom_dev_data from list */
-static void remove_pdom_dev_pasid(struct protection_domain *pdom,
-				  struct device *dev, ioasid_t pasid)
+void remove_pdom_dev_pasid(struct protection_domain *pdom,
+			   struct device *dev, ioasid_t pasid)
  {
  	struct pdom_dev_data *pdom_dev_data;
  	struct iommu_dev_data *dev_data = dev_iommu_priv_get(dev);
@@ -145,25 +145,6 @@ int iommu_sva_set_dev_pasid(struct iommu_domain *domain,
  	return ret;
  }

-void amd_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
-				struct iommu_domain *domain)
-{
-	struct protection_domain *sva_pdom;
-	unsigned long flags;
-
-	if (!is_pasid_valid(dev_iommu_priv_get(dev), pasid))
-		return;
-
-	sva_pdom = to_pdomain(domain);
-
-	spin_lock_irqsave(&sva_pdom->lock, flags);
-
-	/* Remove PASID from dev_data_list */
-	remove_pdom_dev_pasid(sva_pdom, dev, pasid);
-
-	spin_unlock_irqrestore(&sva_pdom->lock, flags);
-}
-
  static void iommu_sva_domain_free(struct iommu_domain *domain)
  {
  	struct protection_domain *sva_pdom = to_pdomain(domain);


-- 
Regards,
Yi Liu

