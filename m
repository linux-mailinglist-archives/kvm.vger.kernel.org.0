Return-Path: <kvm+bounces-38552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E87C9A3B1AE
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 07:34:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 666A17A5E30
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 06:33:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CCDA1BC9F4;
	Wed, 19 Feb 2025 06:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dYXcMyRY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F241B425D
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 06:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739946876; cv=fail; b=EzcvQvAIpMO6m3YcbZZQYV65Jn51pxklZRdEpipjo+M7hKv/Ur5fGdKKYTaFcbRZJXo3V4bizw/UBW1hi2dQTupY5M2GXXztZpH0vt3Vl0GcoX1o6z7WmVa9rzQFPSJXlG9uVNtBxOd6oWN25yx+i+GtcWOXBuZ1jQ2lYb82NvI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739946876; c=relaxed/simple;
	bh=xWWqTjgrPSuWULkiH4Rur1WSX2iImhRGGGpw+ZBUSjs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EOyT4Cw5HTzCURL/sS4caXWCducqxZ57HvEe3RjLN1pdMuvLPOpeh4OYM6211w74y5NGve63zwiZmfjcZ+n8ojB9omPT9MNuPGmDqIggh+siWCI9ZuFEMVdjkAxLUHqpSbVvwRfTWaD+MiU+G8fpn0JI4oTpXYDIP0meLl7eZy4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dYXcMyRY; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739946874; x=1771482874;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xWWqTjgrPSuWULkiH4Rur1WSX2iImhRGGGpw+ZBUSjs=;
  b=dYXcMyRYuW+TbHL70BoumpPXTEmZAHgVEoHQVFs/f7DGTzfHHsyR5uFe
   blHQcUK5JfOOF4Clf1WgkFoMHGovV79+HZdOEnVJmJuAx3lpQ/93ZL/OP
   d8lNdBHdwOjpCFlkD1gtpkx9nX0TjYyHZDqFg9WLswCUi5dBFD/ct9kXU
   z4/bK3sDUWwaHuAtHMam4rDcxZ92Sp41+SMCoCg43WBzonfproRUqhDSq
   WRYE3TE2Q6kvRsyLFjoVyPkttbzxYJDk2faDKFRmVz22imzrpW8Soe5M9
   7Vs2TKow3542FiVz+6HESqYIbP7t+pzslL10t4oznt2CTbbWdP0sziGOe
   Q==;
X-CSE-ConnectionGUID: AWqqeQpEQJaCeaGK/XA4TA==
X-CSE-MsgGUID: Nj4HpSpWRPq5zxxj6HbNUA==
X-IronPort-AV: E=McAfee;i="6700,10204,11348"; a="51289146"
X-IronPort-AV: E=Sophos;i="6.13,298,1732608000"; 
   d="scan'208";a="51289146"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 22:34:26 -0800
X-CSE-ConnectionGUID: +9e3xwcOT8ueHVPrGPwI7w==
X-CSE-MsgGUID: j1fQ7H7PQ7yZxkMZuSRotQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,298,1732608000"; 
   d="scan'208";a="114363467"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Feb 2025 22:34:24 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 18 Feb 2025 22:34:23 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 18 Feb 2025 22:34:23 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 18 Feb 2025 22:34:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ah1A32NV3x73JsyeY5SkrQBOEQ4FsTECXQTgjGFv3/25i8HV0Ua8E8ZGxlNfPtgLyDTvPwjbALAAYBxEFQzIasVZNqfGX4Sk5JUyCtygc2oADDVTI/6bJYric04L6i/325TEerPWT/RfBSlYhZDkZyZAmPDg7TwjycaeuH2tHs7ksd4m99mZioSy5dW1pFIflVg1fRER9s0iv8vq65ToUl0tnl6c9iLK5v37owu9Ra9Vlk18FOVstcsInUQqIEmpLNRAP9xC/i/Z3Vz9hiGA8kgiAvwfZoFUNbxN+veKCRPX6eLCvK/l9kEi5Czctzki9FdX2+dV9LoyxXI46Zd6rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wmd4XrjWVvqU7UpRZoxyD1FYlSlbKYT9LY7g87zUx+g=;
 b=W661VslLkJ3DED84f+9HjUFiGV6DENtmLmDhxpYLxfOOYYxwgEWPQc7/8fYmWvgd1XtJhd92g1BhUXBDu8s8O7bhpz3eCLqjVZiE8FEL0vlvNdN6budu2Jx4gd5Vu6FehvQZmMs4+ykq5MZsEJZKAgy9J4ZwrxzuLFvNfn0nYSrG89z2o4dJQ/+EC9VLLl7V11qkwdospGBLDeyFQXdCR/03Yx9rTSqh5IW+2bra9v642HDdfelD7f8t2v6lPSckRqo43Zi+46Jstl+GxZOU/dmprO0mecrCYDzV3+CJaoUalVaROQ/31vS0gGbDIkoZ6TDcvVVaGY3lFU/vV3fCrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 BL4PR11MB8797.namprd11.prod.outlook.com (2603:10b6:208:5a7::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8466.14; Wed, 19 Feb 2025 06:33:40 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%7]) with mapi id 15.20.8445.017; Wed, 19 Feb 2025
 06:33:40 +0000
Message-ID: <d410d033-dd1c-43fe-85df-1bdaecf250fd@intel.com>
Date: Wed, 19 Feb 2025 14:33:31 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/6] memory-attribute-manager: Introduce
 MemoryAttributeManager to manage RAMBLock with guest_memfd
To: Alexey Kardashevskiy <aik@amd.com>, David Hildenbrand <david@redhat.com>,
	Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao
	<xiaoyao.li@intel.com>
References: <20250217081833.21568-1-chenyi.qiang@intel.com>
 <20250217081833.21568-4-chenyi.qiang@intel.com>
 <60c9ddb7-7f3e-4066-a165-c583af2411ea@amd.com>
 <c5682028-b84c-4b4c-8c4d-f3b43d412e83@intel.com>
 <23e2553b-0390-4215-a19d-0422b55efa38@amd.com>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <23e2553b-0390-4215-a19d-0422b55efa38@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2P153CA0036.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::11) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|BL4PR11MB8797:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d46d008-fdd6-4c71-60e0-08dd50af58fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bEhQak5aQXIxU3d3bW1OZ01abnJVUnk1WUF4Vmxnc1pOQ1ZYVHdOWnNCM25j?=
 =?utf-8?B?d0JqRHFnTWQ5VnlBcUt0OERxTEhVVkJvc2ZCblhoWk1aeW16S3V4dEdSWXZS?=
 =?utf-8?B?c250MGl1RFZFTStyMTN1akdBc011Q0JnZEU0RzBJSkVQYmZ0REtlaGh0bUxX?=
 =?utf-8?B?RklQU3cyNVlJb0hFa0R0ZWJrM001ai8xZXFmR0h2azUxL0FJU1BWWndEVWRC?=
 =?utf-8?B?bGYzVTIzaVpxY25pMy9ZQStpVWFJZjNINWdNSlJQMFdnVXhaQ1BlK0hldUxj?=
 =?utf-8?B?d2Foa21UUnNYd1I3SFhLaWpKWU81SXNqRjhNS1loTVdpZUtpekt6N0pvdUdy?=
 =?utf-8?B?Y2xDaHRITHdaTkE4aDdMM090UjZobmVwYnE4ZTN3bkcxa3Zjck1uR0FxNll3?=
 =?utf-8?B?WkFZVHFzOEZGVk5DN1ZLUHp2T1lPRnYxL21EUnVKb201ZWpkYjU3Q1lGM0gr?=
 =?utf-8?B?Vkg0R1lpcTZVcjFmQXdmeWFlSGViYmI1NVJNOWFNUmY1MlZaWEljUlBiaFdH?=
 =?utf-8?B?ZnJDN1Y4UStEekIzTnlZaTBOYnplclFuS2NxTE8yMnlaaXRDM3pMc1lIVnRO?=
 =?utf-8?B?Mk9SS2lNcWZzaWY0M1UvWkplQ3JSWERxa0lweFZlaHNxdWdKS2NqMGJ2aGR2?=
 =?utf-8?B?TDV3QzQwVlp5ZXk5L2tRc0doN2xnNmVhd2xLM1U0QlBxdkM0UUdKUldGUnF6?=
 =?utf-8?B?MWUxaGdyOGdmRkYzd1EzMFhQSkFCMmwyTnBiSUFLcWpwcVZ0Ym5oeXAzci9L?=
 =?utf-8?B?a24zdVp6RklSRjVWTDZ6VGVFcXpMdWp3MlBoY1NIK0Y2akJyRHJxa2hoaDNh?=
 =?utf-8?B?cmtoQ0dKUDRidnhRWlI4Sy9BOG5pRnBELzVqbDhWMUEyZHdWTFV4OFoyZy8z?=
 =?utf-8?B?aWFSbzBhMHRuandaa2JYdWpuNHVobUgrZ0xHSFllMk45T3U0V2NpM1ZCVVFH?=
 =?utf-8?B?RnYxakRlcE9IelVNKzVhc3l2aXBxYll0SFhyWVl6L1lMNnIxcFhxZVRnUUQx?=
 =?utf-8?B?UTJ1R0IwTGNmcFg2L1JjT0doOXE3dVRmQyt0bnF5MjNSNVZjQ3N0WmplWWlB?=
 =?utf-8?B?UEx0MjRuVVhxUEU3KzUwV25uQUNhZEpxTVJSNk9ocHBRU1ViTmJZbCtPdCsv?=
 =?utf-8?B?SVBhVWVqbUdQd1Zkd3JDdDhDM3BGTDRQdVVtMVYyZFJmSXZkS2cxdzcxbUtK?=
 =?utf-8?B?dE96K2R6VkhKMTc0L1ZrYkhMQzhrSkJrWGw1RUl0Ti9vUzZGMmFWb0NnSXdL?=
 =?utf-8?B?SWt6T1l4RGp6Zjk5elFMWkdIa1hsN0FOU01DQjl4U2dvKzJwbXNnYzlZUGo1?=
 =?utf-8?B?dVBJellFTTNlNUxCOXFOMjNhU2t6TXdYQTM0MnRRUzJpVWh4SXAwOTYzeUJK?=
 =?utf-8?B?MkxkOUxGRUhtMzBVNXdSMEVjS1FOM2ZZQXVOeWdaYnlCY2pTeERUR0phNThQ?=
 =?utf-8?B?VFZqamZTLzFvcndkV210YkdwUHZVSW1PS0U2b0FaTHlIS0NSdC84YUxtbGdn?=
 =?utf-8?B?clR0dWUyQ0NpVmFHUGFEc0Z0TkM4cHh3WTEyalFOVGVJQ2NoMTdhLzdXcG50?=
 =?utf-8?B?MjNRdzkvS21TWWFoUnp2SnJGRllodi9NMEFrSUFFc2JGTnRKeXVqT1JUQ1do?=
 =?utf-8?B?TEJ4Q3dKL0lVNVA0Nm5CTEhPc2NQVWl2UGRwSjlQNHRkN09JdWJJVGQ3Rmdu?=
 =?utf-8?B?Z0p4bE9VSysxSkkrVU11eC9xd2twTEQ1c3duM2JES0Z5NTFBdVJvU01sUWNY?=
 =?utf-8?B?UDMzdHBhU0o0b3pLZGFDbndKaU9TUzR4UklwZzZLUHdUbGN2NUIzckw2dnBZ?=
 =?utf-8?B?NGEySFlBeTN0OGlNcldURWQxODBvZEhrM0Naa3I4S2U2M1lSSktDWjVmSlhF?=
 =?utf-8?Q?xVHYvLA6LQk5U?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RVM2c2MzODhkZ3FmYzVySDZxNjBEWXUwKzhSVk5RRVdNa2kzdTA5NXFoVEYw?=
 =?utf-8?B?eVltaXJSREZyWlJBZmVZN3NOSURFU29vSTArYTJLeDRZQWo0WDdBZTZzSnpm?=
 =?utf-8?B?YXZyMnBlU240bUwrU0VibkI0bjBoczZRRk1iZTJCYU02b1AzcUhWV1JhMldq?=
 =?utf-8?B?eHZwbzJWK29mNE5ROFBKT2hNeEMyZTRhYXBEV2hwT1RwcDM3YXNwRmI0T01r?=
 =?utf-8?B?WS9CcEhJSmthV3N4UTBBL01Cem9lV0xVdWVkNlF0cWN4dkJwQjErd3dCWTNj?=
 =?utf-8?B?RjVvR1YyamZIQlJua0dXV0FqREFrWVU3Y2ZzV083alVTMmV1T3dPNVlVQUVm?=
 =?utf-8?B?QU1OTUpEODdYbjg0dVVyMzlJNkd6VHNXTUxib0l1dnIyalFSdWE2dDdXSTFk?=
 =?utf-8?B?UUpMbm84V2lFUnZvVUwvM21LaHMxTTczeklZdEx3WnN6bTcyeDhsZXh4YnQ3?=
 =?utf-8?B?emxwa08wcjhlVmJlWW5kZkdESU5CaG5IRXNWblFtS3MwTUZJamFUeDNXSTFY?=
 =?utf-8?B?VVU0WFlEc2tXbnVNQzFWM0xHYmpRNGJqK1dES3gxbWJLQzIxaUtZWDBkL3BO?=
 =?utf-8?B?ajIxVTdhcm5HUGpIR2Jjb2RPSGlPUFB2TG5YQUVNcGRJR0kvUnlubXFwSkgr?=
 =?utf-8?B?ZWFSdG9id0pwR0dYeU1WR09mb0wrb1YzcVZZaFp3S1VPck80V2d0cVlJVXB1?=
 =?utf-8?B?WnQ5SldHYThBa08yYklMZzRQYTFrS3pBQ3NQWGNoUXAzWHJmL0FrK1EvMGNn?=
 =?utf-8?B?QWhGUnFjdW12dTV1c3A1OXZyZE9sQUlVbjVTUVZBT3ZNZVNlNXRQS1dTYVNa?=
 =?utf-8?B?QXVjZjdFMTZIU2dyZG5Mb2tueW1XVWlFbGcrZ1NsZW1iSnBva3ExamordHNt?=
 =?utf-8?B?SysvUEJ1TE80ZmllWFMwaVM5SzFYamRlTFJNYWlRMjltMXVJT0ZLMmdNOTND?=
 =?utf-8?B?TXlxcjkxUWxRUFVvUmkyNEt3ejdVbkFibitWeEZDVlVTTnVmMHVjbEVPTlNQ?=
 =?utf-8?B?dzB2RTlzRGZveURKWnVnUy9HemQ0RmtVVGtTeS9XS2xSVjhHeTZUR3N1bFJO?=
 =?utf-8?B?eGNCbG9LcXZ5c1lHaHYzaEdsQWhVR1pKaWVxTlNyUG1XWW9JYndzd2dHemIv?=
 =?utf-8?B?bENQRWlwRTBrQ1VXbGRTMlZVSSsrdzRYeldsUEJPcDhKdHEwMkpOOG9aZWVZ?=
 =?utf-8?B?SVdhUlI2TUNCZFJqaEFQanNxQXQ2cm1GamJ4bytVNzZrQUNiWE1IRUpyNzhI?=
 =?utf-8?B?d1N1NFF2YWJnZWpKeDFxRVN5d3hhUjF2dDdXZDhoVVo4WGt5dVA1Z1h2Zk5M?=
 =?utf-8?B?TTk4MEw3NlVoWFZ0bm5NaHBtelpiREZPNm9OZVFmSmpZR0s5L1k0MEZmS3Bt?=
 =?utf-8?B?WGdUMFU5b0R0ZTVqanoydXkvTUNHZ1BlUFR2Qm42SGFFMEJQOHBkMkZlR0pY?=
 =?utf-8?B?ZEtPMUYzZlkybXB5b3FVSTI5c0s3VjdibVRUeFlkUXNWSUhrbWM1MkdlcnAw?=
 =?utf-8?B?eW1Lc2dkbi9iRTFMQzBNazB6MHl0VzAxMFVqclhWOWoxTXVnbHVSZHppRWpt?=
 =?utf-8?B?eE9yZVljeGV0cHJqbGQ2TWhVWS9kNkJMSy9RRlR4QktyR3VOemk1SU1HM0Fw?=
 =?utf-8?B?RUhUS2FveExEU3VwcjBubWtHN2tzVGJMMjYwVU9XWVVuZGdHU2hKVWgrVENN?=
 =?utf-8?B?RUwwbmFoa0pIYjBLNkNZbm9jSDZJSjRxY0ROVGZEL1ZaQ2hZWVAvSGpRVXJ0?=
 =?utf-8?B?MVdrbVdZRFZHVFh1cFQ1Wm1vQkhndXFXZEdTcTJtd3dhbUdpR0d6OHlEK2Rt?=
 =?utf-8?B?aFBubmk1T1lXOWlLVlRWaDgyb1hXNGJUT3VVSDZHYVhmaFVWM0g3L3hyVk5i?=
 =?utf-8?B?YTVHT2c0SDhjNmpDVWpCTWtoOTM4VURRSUxUKzVvK3l3SGNHciszQUZ5TG0y?=
 =?utf-8?B?c0d1a0hQZW1FcXpGc3hWTHF6a0t1TDNuOUo3V2hEVjljOXduZEdrcjcwRSt0?=
 =?utf-8?B?KzN3RUtUb254NW5qNXVPMkNEazNFVFBlY0lzRTdZa3ZxSW1kWjg4V3g3WnNK?=
 =?utf-8?B?ZWpBcnhyakxrL01hTTVCaTVuMlRMVVRRS3RqT3FXb25BV0x3ajE3Y1pSOVRI?=
 =?utf-8?B?VFg2RGEvbXlmUFkxaVZHWGlpNWFNZ0lyRGdQYVdjdzl6TmdEai9IOVNpOC9a?=
 =?utf-8?B?T3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d46d008-fdd6-4c71-60e0-08dd50af58fd
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2025 06:33:40.2818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KYymIHKSRkeWxHw05iI4xq19SCxJPcxgFjqnfQoR16to1LKAJCu4bvAMvQLhUFzbizgfWdg0QdSkwJMpibdjZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR11MB8797
X-OriginatorOrg: intel.com



On 2/19/2025 11:49 AM, Alexey Kardashevskiy wrote:
> 
> 
> On 19/2/25 12:20, Chenyi Qiang wrote:
>>
>>
>> On 2/18/2025 5:19 PM, Alexey Kardashevskiy wrote:
>>>
>>>
>>
>> [..]
>>
>>>> diff --git a/include/system/memory-attribute-manager.h b/include/
>>>> system/memory-attribute-manager.h
>>>> new file mode 100644
>>>> index 0000000000..72adc0028e
>>>> --- /dev/null
>>>> +++ b/include/system/memory-attribute-manager.h
>>>> @@ -0,0 +1,42 @@
>>>> +/*
>>>> + * QEMU memory attribute manager
>>>> + *
>>>> + * Copyright Intel
>>>> + *
>>>> + * Author:
>>>> + *      Chenyi Qiang <chenyi.qiang@intel.com>
>>>> + *
>>>> + * This work is licensed under the terms of the GNU GPL, version 2 or
>>>> later.
>>>> + * See the COPYING file in the top-level directory
>>>> + *
>>>> + */
>>>> +
>>>> +#ifndef SYSTEM_MEMORY_ATTRIBUTE_MANAGER_H
>>>> +#define SYSTEM_MEMORY_ATTRIBUTE_MANAGER_H
>>>> +
>>>> +#include "system/hostmem.h"
>>>> +
>>>> +#define TYPE_MEMORY_ATTRIBUTE_MANAGER "memory-attribute-manager"
>>>> +
>>>> +OBJECT_DECLARE_TYPE(MemoryAttributeManager,
>>>> MemoryAttributeManagerClass, MEMORY_ATTRIBUTE_MANAGER)
>>>> +
>>>> +struct MemoryAttributeManager {
>>>> +    Object parent;
>>>> +
>>>> +    MemoryRegion *mr;
>>>> +
>>>> +    /* 1-setting of the bit represents the memory is populated
>>>> (shared) */
>>>> +    int32_t bitmap_size;
>>>
>>> unsigned.
>>>
>>> Also, do either s/bitmap_size/shared_bitmap_size/ or
>>> s/shared_bitmap/bitmap/
>>
>> Will change it. Thanks.
>>
>>>
>>>
>>>
>>>> +    unsigned long *shared_bitmap;
>>>> +
>>>> +    QLIST_HEAD(, RamDiscardListener) rdl_list;
>>>> +};
>>>> +
>>>> +struct MemoryAttributeManagerClass {
>>>> +    ObjectClass parent_class;
>>>> +};
>>>> +
>>>> +int memory_attribute_manager_realize(MemoryAttributeManager *mgr,
>>>> MemoryRegion *mr);
>>>> +void memory_attribute_manager_unrealize(MemoryAttributeManager *mgr);
>>>> +
>>>> +#endif
>>>> diff --git a/system/memory-attribute-manager.c b/system/memory-
>>>> attribute-manager.c
>>>> new file mode 100644
>>>> index 0000000000..ed97e43dd0
>>>> --- /dev/null
>>>> +++ b/system/memory-attribute-manager.c
>>>> @@ -0,0 +1,292 @@
>>>> +/*
>>>> + * QEMU memory attribute manager
>>>> + *
>>>> + * Copyright Intel
>>>> + *
>>>> + * Author:
>>>> + *      Chenyi Qiang <chenyi.qiang@intel.com>
>>>> + *
>>>> + * This work is licensed under the terms of the GNU GPL, version 2 or
>>>> later.
>>>> + * See the COPYING file in the top-level directory
>>>> + *
>>>> + */
>>>> +
>>>> +#include "qemu/osdep.h"
>>>> +#include "qemu/error-report.h"
>>>> +#include "system/memory-attribute-manager.h"
>>>> +
>>>> +OBJECT_DEFINE_TYPE_WITH_INTERFACES(MemoryAttributeManager,
>>>> +                                   memory_attribute_manager,
>>>> +                                   MEMORY_ATTRIBUTE_MANAGER,
>>>> +                                   OBJECT,
>>>> +                                   { TYPE_RAM_DISCARD_MANAGER },
>>>> +                                   { })
>>>> +
>>>> +static int memory_attribute_manager_get_block_size(const
>>>> MemoryAttributeManager *mgr)
>>>> +{
>>>> +    /*
>>>> +     * Because page conversion could be manipulated in the size of at
>>>> least 4K or 4K aligned,
>>>> +     * Use the host page size as the granularity to track the memory
>>>> attribute.
>>>> +     * TODO: if necessary, switch to get the page_size from RAMBlock.
>>>> +     * i.e. mgr->mr->ram_block->page_size.
>>>
>>> I'd assume it is rather necessary already.
>>
>> OK, Will return the page_size of RAMBlock directly.
>>
>>>
>>>> +     */
>>>> +    return qemu_real_host_page_size();
>>>> +}
>>>> +
>>>> +
>>>> +static bool memory_attribute_rdm_is_populated(const RamDiscardManager
>>>> *rdm,
>>>> +                                              const
>>>> MemoryRegionSection *section)
>>>> +{
>>>> +    const MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(rdm);
>>>> +    int block_size = memory_attribute_manager_get_block_size(mgr);
>>>> +    uint64_t first_bit = section->offset_within_region / block_size;
>>>> +    uint64_t last_bit = first_bit + int128_get64(section->size) /
>>>> block_size - 1;
>>>> +    unsigned long first_discard_bit;
>>>> +
>>>> +    first_discard_bit = find_next_zero_bit(mgr->shared_bitmap,
>>>> last_bit + 1, first_bit);
>>>> +    return first_discard_bit > last_bit;
>>>> +}
>>>> +
>>>> +typedef int (*memory_attribute_section_cb)(MemoryRegionSection *s,
>>>> void *arg);
>>>> +
>>>> +static int memory_attribute_notify_populate_cb(MemoryRegionSection
>>>> *section, void *arg)
>>>> +{
>>>> +    RamDiscardListener *rdl = arg;
>>>> +
>>>> +    return rdl->notify_populate(rdl, section);
>>>> +}
>>>> +
>>>> +static int memory_attribute_notify_discard_cb(MemoryRegionSection
>>>> *section, void *arg)
>>>> +{
>>>> +    RamDiscardListener *rdl = arg;
>>>> +
>>>> +    rdl->notify_discard(rdl, section);
>>>> +
>>>> +    return 0;
>>>> +}
>>>> +
>>>> +static int memory_attribute_for_each_populated_section(const
>>>> MemoryAttributeManager *mgr,
>>>> +
>>>> MemoryRegionSection *section,
>>>> +                                                       void *arg,
>>>> +
>>>> memory_attribute_section_cb cb)
>>>> +{
>>>> +    unsigned long first_one_bit, last_one_bit;
>>>> +    uint64_t offset, size;
>>>> +    int block_size = memory_attribute_manager_get_block_size(mgr);
>>>> +    int ret = 0;
>>>> +
>>>> +    first_one_bit = section->offset_within_region / block_size;
>>>> +    first_one_bit = find_next_bit(mgr->shared_bitmap, mgr-
>>>>> bitmap_size, first_one_bit);
>>>> +
>>>> +    while (first_one_bit < mgr->bitmap_size) {
>>>> +        MemoryRegionSection tmp = *section;
>>>> +
>>>> +        offset = first_one_bit * block_size;
>>>> +        last_one_bit = find_next_zero_bit(mgr->shared_bitmap, mgr-
>>>>> bitmap_size,
>>>> +                                          first_one_bit + 1) - 1;
>>>> +        size = (last_one_bit - first_one_bit + 1) * block_size;
>>>
>>>
>>> What all this math is for if we stuck with VFIO doing 1 page at the
>>> time? (I think I commented on this)
>>
>> Sorry, I missed your previous comment. IMHO, as we track the status in
>> bitmap and we want to call the cb() on the shared part within
>> MemoryRegionSection. Here we do the calculation to find the expected
>> sub-range.
> 
> 
> You find a largest intersection here and call cb() on it which will call
> VFIO with 1 page at the time. So you could just call cb() for every page
> from here which will make the code simpler.

I prefer to keep calling cb() on a large intersection . I think in
future after cut_mapping is supported, we don't need to make VFIO call 1
page at a time. VFIO can call on the large range directly.

In addition, calling cb() for every page seems specific to VFIO usage.
It is more generic to call on a large intersection. If more RDM listener
added in future(although VFIO is the only user currently), do the split
in caller is inefficient.

> 
> 
>>>
>>>> +
>>>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>>>> size)) {
>>>> +            break;
>>>> +        }
>>>> +
>>>> +        ret = cb(&tmp, arg);
>>>> +        if (ret) {
>>>> +            error_report("%s: Failed to notify RAM discard listener:
>>>> %s", __func__,
>>>> +                         strerror(-ret));
>>>> +            break;
>>>> +        }
>>>> +
>>>> +        first_one_bit = find_next_bit(mgr->shared_bitmap, mgr-
>>>>> bitmap_size,
>>>> +                                      last_one_bit + 2);
>>>> +    }
>>>> +
>>>> +    return ret;
>>>> +}
>>>> +
>>
>> [..]
>>
>>>> +
>>>> +static void
>>>> memory_attribute_rdm_unregister_listener(RamDiscardManager *rdm,
>>>> +
>>>> RamDiscardListener *rdl)
>>>> +{
>>>> +    MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(rdm);
>>>> +    int ret;
>>>> +
>>>> +    g_assert(rdl->section);
>>>> +    g_assert(rdl->section->mr == mgr->mr);
>>>> +
>>>> +    ret = memory_attribute_for_each_populated_section(mgr, rdl-
>>>>> section, rdl,
>>>> +
>>>> memory_attribute_notify_discard_cb);
>>>> +    if (ret) {
>>>> +        error_report("%s: Failed to unregister RAM discard listener:
>>>> %s", __func__,
>>>> +                     strerror(-ret));
>>>> +    }
>>>> +
>>>> +    memory_region_section_free_copy(rdl->section);
>>>> +    rdl->section = NULL;
>>>> +    QLIST_REMOVE(rdl, next);
>>>> +
>>>> +}
>>>> +
>>>> +typedef struct MemoryAttributeReplayData {
>>>> +    void *fn;
>>>
>>> ReplayRamDiscard *fn, not void*.
>>
>> We could cast the void *fn either to ReplayRamPopulate or
>> ReplayRamDiscard (see below).
> 
> 
> Hard to read, hard to maintain, and they take same parameters, only the
> return value is different (int/void) - if this is really important, have
> 2 fn pointers in MemoryAttributeReplayData. It is already hard to follow
> this train on callbacks.

Actually, I prefer to make ReplayRamDiscard and ReplayRamPopulate
unified. Make ReplayRamDiscard() also return int. Then we only need to
define one function like:

typedef int (*ReplayMemoryAttributeChange)(MemoryRegionSection *section,
void *opaque);

Maybe David can share his opinions.

> 
> 
>>>> +    void *opaque;
>>>> +} MemoryAttributeReplayData;
>>>> +
>>>> +static int
>>>> memory_attribute_rdm_replay_populated_cb(MemoryRegionSection *section,
>>>> void *arg)
>>>> +{
>>>> +    MemoryAttributeReplayData *data = arg;
>>>> +
>>>> +    return ((ReplayRamPopulate)data->fn)(section, data->opaque);
>>>> +}
>>>> +
>>>> +static int memory_attribute_rdm_replay_populated(const
>>>> RamDiscardManager *rdm,
>>>> +                                                 MemoryRegionSection
>>>> *section,
>>>> +                                                 ReplayRamPopulate
>>>> replay_fn,
>>>> +                                                 void *opaque)
>>>> +{
>>>> +    MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(rdm);
>>>> +    MemoryAttributeReplayData data = { .fn = replay_fn, .opaque =
>>>> opaque };
>>>> +
>>>> +    g_assert(section->mr == mgr->mr);
>>>> +    return memory_attribute_for_each_populated_section(mgr, section,
>>>> &data,
>>>> +
>>>> memory_attribute_rdm_replay_populated_cb);
>>>> +}
>>>> +
>>>> +static int
>>>> memory_attribute_rdm_replay_discarded_cb(MemoryRegionSection *section,
>>>> void *arg)
>>>> +{
>>>> +    MemoryAttributeReplayData *data = arg;
>>>> +
>>>> +    ((ReplayRamDiscard)data->fn)(section, data->opaque);
>>>> +    return 0;
>>>> +}
>>>> +
>>>> +static void memory_attribute_rdm_replay_discarded(const
>>>> RamDiscardManager *rdm,
>>>> +                                                  MemoryRegionSection
>>>> *section,
>>>> +                                                  ReplayRamDiscard
>>>> replay_fn,
>>>> +                                                  void *opaque)
>>>> +{
>>>> +    MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(rdm);
>>>> +    MemoryAttributeReplayData data = { .fn = replay_fn, .opaque =
>>>> opaque };
>>>> +
>>>> +    g_assert(section->mr == mgr->mr);
>>>> +    memory_attribute_for_each_discarded_section(mgr, section, &data,
>>>> +
>>>> memory_attribute_rdm_replay_discarded_cb);
>>>> +}
>>>> +
>>>> +int memory_attribute_manager_realize(MemoryAttributeManager *mgr,
>>>> MemoryRegion *mr)
>>>> +{
>>>> +    uint64_t bitmap_size;
>>>> +    int block_size = memory_attribute_manager_get_block_size(mgr);
>>>> +    int ret;
>>>> +
>>>> +    bitmap_size = ROUND_UP(mr->size, block_size) / block_size;
>>>> +
>>>> +    mgr->mr = mr;
>>>> +    mgr->bitmap_size = bitmap_size;
>>>> +    mgr->shared_bitmap = bitmap_new(bitmap_size);
>>>> +
>>>> +    ret = memory_region_set_ram_discard_manager(mgr->mr,
>>>> RAM_DISCARD_MANAGER(mgr));
>>>
>>> Move it 3 lines up and avoid stale data in mgr->mr/bitmap_size/
>>> shared_bitmap and avoid g_free below?
>>
>> Make sense. I will move it up the same as patch 02 before bitmap_new().
>>
>>>
>>>> +    if (ret) {
>>>> +        g_free(mgr->shared_bitmap);
>>>> +    }
>>>> +
>>>> +    return ret;
>>>> +}
>>>> +
>>>> +void memory_attribute_manager_unrealize(MemoryAttributeManager *mgr)
>>>> +{
>>>> +    memory_region_set_ram_discard_manager(mgr->mr, NULL);
>>>> +
>>>> +    g_free(mgr->shared_bitmap);
>>>> +}
>>>> +
>>>> +static void memory_attribute_manager_init(Object *obj)
>>>
>>> Not used.
>>>
>>>> +{
>>>> +    MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(obj);
>>>> +
>>>> +    QLIST_INIT(&mgr->rdl_list);
>>>> +} > +
>>>> +static void memory_attribute_manager_finalize(Object *obj)
>>>
>>> Not used either. Thanks,
>>
>> I think it is OK to define it as a placeholder? Just some preference.
> 
> At very least gcc should warn on these (I am surprised it did not) and
> nobody likes this. Thanks,

I tried a little. They must be defined. The init() and finalize() calls
are used in the OBJECT_DEFINE_TYPE_WITH_INTERFACES() macro. I think it
is a common template to define in this way.

> 
> 
>>>
>>>> +{
>>>> +}
>>>> +
>>>> +static void memory_attribute_manager_class_init(ObjectClass *oc, void
>>>> *data)
>>>> +{
>>>> +    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_CLASS(oc);
>>>> +
>>>> +    rdmc->get_min_granularity =
>>>> memory_attribute_rdm_get_min_granularity;
>>>> +    rdmc->register_listener = memory_attribute_rdm_register_listener;
>>>> +    rdmc->unregister_listener =
>>>> memory_attribute_rdm_unregister_listener;
>>>> +    rdmc->is_populated = memory_attribute_rdm_is_populated;
>>>> +    rdmc->replay_populated = memory_attribute_rdm_replay_populated;
>>>> +    rdmc->replay_discarded = memory_attribute_rdm_replay_discarded;
>>>> +}
>>>> diff --git a/system/meson.build b/system/meson.build
>>>> index 4952f4b2c7..ab07ff1442 100644
>>>> --- a/system/meson.build
>>>> +++ b/system/meson.build
>>>> @@ -15,6 +15,7 @@ system_ss.add(files(
>>>>      'dirtylimit.c',
>>>>      'dma-helpers.c',
>>>>      'globals.c',
>>>> +  'memory-attribute-manager.c',
>>>>      'memory_mapping.c',
>>>>      'qdev-monitor.c',
>>>>      'qtest.c',
>>>
>>
> 


