Return-Path: <kvm+bounces-16368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A1F9D8B8F7B
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 20:22:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C17DD1C2141E
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 18:22:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A4511474C9;
	Wed,  1 May 2024 18:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XZFuIDRX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6851E182DF;
	Wed,  1 May 2024 18:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714587759; cv=fail; b=FjiwUCXtLlDy60ctVTpMBa5LVxyWMZTrvJn+sMiurHMCycWQHc+t0JR1QukmIMh+eXfSKaechoft616dx5PKe9tCFwmK9i2Ma6he2gWnopy/ILHDLyOIeqYSzpbkJDimNte/DBrH+hWQebvw9RguUNmiAInMknBJs6LRUEoPP4A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714587759; c=relaxed/simple;
	bh=ssZvVptyOYOEqeInhWKL/STj3nPPOtctfNnbqcaCkvw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HKhhF61yTfch0k8W+At56QTiGHtRgAIIlDm3l788Ki0CA/YdIrDTikv9ej6mL3iimB2ICLPkWin0rizm9TpKkxtggU0koMT+henBerE8L8UMn3tRRk6mSH1VDthvL7sqi666FDOBr7st8OwOad14xqFWqVDRHtg1a/DpC4hg2c8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XZFuIDRX; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714587758; x=1746123758;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ssZvVptyOYOEqeInhWKL/STj3nPPOtctfNnbqcaCkvw=;
  b=XZFuIDRX7ylO8Q8lKL5cqkJ7QbUC+91UjfPqxqv8Kr+J9873PVACeXl+
   5dXj260MpMzADB8LcoT90IIYG32w1k6vvHKZMnmtMDINMKSdqzQhyrzS2
   VlYpzr+FsUDuXbieFKl5Do6EUOvRwXNpX8JLblMfRk/l/BEF+rS+rKvyL
   FtP/IOY9zb/jiv3Ah6jYCspfwj59+MMC2P/uN9HS+Q8PWkSUcque6rINV
   OExQ6XmFk2vPmJx09bMqaw2dJOWnrzy4qRwXcA2EGN9lbsS3MJ0hzIIVm
   8q6Q1MBbJW7t3X/gMoBpuer1IRQP+LQ/+ru+IZcd1FRCcqaMmfRgf+PFB
   Q==;
X-CSE-ConnectionGUID: p0QcfHcVQ4KAq6zJiwgw4A==
X-CSE-MsgGUID: yOYBNCJ1QCmbZ8PpWOFB1w==
X-IronPort-AV: E=McAfee;i="6600,9927,11061"; a="27855564"
X-IronPort-AV: E=Sophos;i="6.07,246,1708416000"; 
   d="scan'208";a="27855564"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2024 11:22:29 -0700
X-CSE-ConnectionGUID: LxKEZry+QYyf2J8PAEHZ3Q==
X-CSE-MsgGUID: sdoiNUumSJmuoWdVW7Qd8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,246,1708416000"; 
   d="scan'208";a="26860124"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 May 2024 11:22:28 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 1 May 2024 11:22:27 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 1 May 2024 11:22:27 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 1 May 2024 11:22:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OhhImly2csMJKW8ixStJ4JORWSCwBgC5ea1XGHv3dfPH47EPcqxMm2JB0H5e5/3Xrdq/1n2LAazz1BXZJnMucFialQRLosISb/+mnIKxt5cj70CPfWurPUvPiI0tKdv1c8W+y2XsN3+xhHldAEv3QSh+CuUUutsebIwbxPQXddjsENfRYjzPiwSW6cmCNHLBdFkSBvpdVhcvQ78gvKWXjKdW7hPMmbdHzbaoFSjqmzRUGa/qItighjhnwgMu1Ieva3IhfgrYcCbfsF+lc4IW93QcLfE3ka1X6XeunBuaAVZpo1v+jL52dL3EbV3GkFJVmr8aOQ1Bk5IF3uA4/SbUag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o14ruo/V9ESTfm4eMVeNrok8aUwYuR4op+vyqu8GkV4=;
 b=crJacuBlD8snKA4fYNFUT4c6seSOmWINZIJ836yzihgWdiYzCpOVO9jPqgq9AC1xN0Y0wJui255e21g1Zq2LW/dxCApmpQJYJEI2MWJDK7avH9NwGzYfFyRabsZ3WBpN8PKuBHrid9CQMVJ3lo1G9SQ9hppSt9zX7wHDqA7PvZnouv4uUHHMABhRjC/hctdW4ceCPprHQSG9cNZvfRN14Bh3rN7U3BfBa8vdaoFvvMxSsu2hikicBUOn2NZ+/g526bzadzdEj9Ls2s0Gh6Js1szTajzO5iysn2UWfmaHGX0xzPQ1lfyqGZwavplxZZxEPU0PIEYqFHVJHgEIPrh4HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB8009.namprd11.prod.outlook.com (2603:10b6:510:248::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.36; Wed, 1 May
 2024 18:22:22 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::b394:287f:b57e:2519]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::b394:287f:b57e:2519%4]) with mapi id 15.20.7544.023; Wed, 1 May 2024
 18:22:22 +0000
Message-ID: <3b1b1b23-b633-4085-825b-2867f665abc7@intel.com>
Date: Wed, 1 May 2024 11:22:19 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 101/130] KVM: TDX: handle ept violation/misconfig exit
To: Isaku Yamahata <isaku.yamahata@intel.com>
CC: Chao Gao <chao.gao@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <isaku.yamahata@gmail.com>, Paolo Bonzini
	<pbonzini@redhat.com>, <erdemaktas@google.com>, Sean Christopherson
	<seanjc@google.com>, Sagi Shahar <sagis@google.com>, Kai Huang
	<kai.huang@intel.com>, <chen.bo@intel.com>, <hang.yuan@intel.com>,
	<tina.zhang@intel.com>, <isaku.yamahata@linux.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <f05b978021522d70a259472337e0b53658d47636.1708933498.git.isaku.yamahata@intel.com>
 <Zgoz0sizgEZhnQ98@chao-email>
 <20240403184216.GJ2444378@ls.amr.corp.intel.com>
 <43cbaf90-7af3-4742-97b7-2ea587b16174@intel.com>
 <20240501155620.GA13783@ls.amr.corp.intel.com>
 <399cec29-ddf4-4dd5-a34b-ffec72cbfa26@intel.com>
 <20240501181921.GB13783@ls.amr.corp.intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240501181921.GB13783@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0288.namprd03.prod.outlook.com
 (2603:10b6:303:b5::23) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB8009:EE_
X-MS-Office365-Filtering-Correlation-Id: 478f9a66-4208-42a4-e831-08dc6a0ba4e1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RlIwMFRSSlpTaHBPL2NWczdNUGZwOFpaZklJNUxKelQ2TVhYZmZmUGZXZTdz?=
 =?utf-8?B?YW51cGYya0h4OXlINnZ3djgrQ1VjRUk3ZVNrMmRBakQvd3lSWWs2RmVLVjQ4?=
 =?utf-8?B?a0lQSUdkdStKU1hYR0xRSEJNbk1abHlUTHgrTXZ2UXp4MTRMeXpIVDN1SWJ2?=
 =?utf-8?B?Sk1xM2Y0c1BBR01NVFByOXp1WTlsYmtRWHVwVC8yYUU1eVpaLzFvZThqSFNz?=
 =?utf-8?B?WVprbkl0VTNNcWJVNTBEZE1DdDg2K3IzT0c1Y2tiU0pneTdYay9zUFd1bCth?=
 =?utf-8?B?T1ZoNVh6V05GSmNpZUZkSERHd0R2U3orK1R0bU51VXd0N1pLazZZdUFTY0Rq?=
 =?utf-8?B?ZXlNNnUzZ0RQdGF4TGZJeFBsUG5IMm90NXdJZHlaQnJjWng4Y0NRY0U0UUhS?=
 =?utf-8?B?dW5OQmNrOXJPK09KVTM4RlVsV09lZVVLYmpiNW51NmplbXYyekdGMVJ2dVFX?=
 =?utf-8?B?Q0I1NllnVkY4eFpDamd5d3RJZ2hCblpmenBIYkRnWkRHVU9ndUEwUlFMUUtR?=
 =?utf-8?B?WlhKaUVHbVNZcnlLV0dLRURBbVNleVE4RUFYYnRlNlBEbnJvdlVqMXdsMGVy?=
 =?utf-8?B?ZU95S1VMMWZnbE1MM0hRYVJINnRBazZac0c4U1JxMDBWelZkRVBlcHVDYnZs?=
 =?utf-8?B?TTJJc0JkZGRvSXIxU2lJalljTFE0cmI3R0Z5aEoyWmlabGU5VXFWQ1ZyLzZL?=
 =?utf-8?B?NHRXWWt2ak5jbnZnS1NpOC9EMndvSG1na25ySHV4dTJyOTEzc0N3VUdIME81?=
 =?utf-8?B?VlZvZ0RUVEZRbFdSZjNuejR5elVzVGw1Z29ZR1VPYzZpSkxoN3JGTzBIcDRM?=
 =?utf-8?B?VklsMW1MOWI2bmFsL0FOaFpyY0hVbUhaY1NTc3Jyb2N2STNUNHhxaGxxYks0?=
 =?utf-8?B?c0NOKy9wNXl1Ym1mQlJpVEY4byt3d1F1azFKZTJ4RlIvYjlReU1tK3IwNWtU?=
 =?utf-8?B?dkR4cktQak95RTZsY3lBbkdnQURWYnNGZG9JQnNtbFNCWXpZbERCdVBZd3hu?=
 =?utf-8?B?SUVld2VwYkxDdTI4V1dmcDd1TWJyejBUY0d4OXI2Nk9TR2NQUUx0cmFSTTlY?=
 =?utf-8?B?Z1NpbnVLbzNhTzBhdFY5ZGl5OEtWRkIxejlzdE04aUk3V1ZYekkyZHBqUTB3?=
 =?utf-8?B?R0RoTWlwekFhU3RNTzYzZFVvaWZSOHRGYWhrTW9PbHJRc3ZqTmxPL2luY2cw?=
 =?utf-8?B?cEVFZ25WQXhMcE9qc3BLR1gwOHE1MDF6cVdKUDMrOUo5VUczUlZueW11bXYw?=
 =?utf-8?B?bGsyYjJJajNVUG9US1UyMzlzWGQwNHgwam9ubFZxaWNKUkcwUmpvaWxHWWZo?=
 =?utf-8?B?bWNBY2FOcUg1ek9nYzV6aytCcFdTWExhMzZld2lTZVIxalg5MHhrYXg0YkFI?=
 =?utf-8?B?MEZTQzZNS1o1TjlYQTlrMll0aStON3JmZHlmYlY5djFEL3ExSVp0VVkvQ1l5?=
 =?utf-8?B?aUZzMEp3L0hwRmRrVnE1cE01STVUV1BwbktqYi8xbVByb0VURzZoMHViNTV6?=
 =?utf-8?B?TC9IYnJuOHBRT3NxenBCSDVzZWdrM3BWYnhSRkp5MDJSQ0l3OCtUOCtlNGtX?=
 =?utf-8?B?TDVxc1ZteGM2Y1hhZFlhZFFtbTNCbWlIRUpFc0M2N2xOZDU3bkFhNm1pZHQw?=
 =?utf-8?B?b0hmSWhsdlRZc25vaDhNRVRuU0ZackJHQUw3WEVGR2dPRHFucktRclpISHI0?=
 =?utf-8?B?UW1ETDAvTUo5TEllWTZuYjZVSjQwN2U1WjQ2UGR6a2NBcHZNWWlYZ2NBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Mm9NTmZoVVlLN2Mzc1B2VFNyYzJ3U1l6OThDc25ZL1NJdHJ1c21jTXdBdkdr?=
 =?utf-8?B?V0ZXWllNbVNYeFBZbkFXeFpFOGRpT3BVQTNqM1lVTWFsRUNqUG1pZ1o0ckxa?=
 =?utf-8?B?UVVvakxXMWg1d3MzbHNLMEhWdmJzcS95dGdDSnRKMWw0Q0t4QmptUFBnbEpH?=
 =?utf-8?B?RGJ3TU9oRjlINDM4SDRLTktIQXBKSmVqd3o0V0VUdTVZcGFQWHV3dkF0cERR?=
 =?utf-8?B?dEEzalRVSHBSbEphNmo0Ymd1aEJCNnZ3U1RrL054c3pISU1OWkdhemtMTi9q?=
 =?utf-8?B?WUhFaTJOSHlnSHpxeDZqN3krdDRxMTNsYXBpSU1wVnRSMmRuaVFmalRsRUVq?=
 =?utf-8?B?ek1tMmNGNkoxWmRkOXMyajRvSFJsTW1iaXJJSVJSdzZGQzlxcDRpcFRCdm8x?=
 =?utf-8?B?Vk9vNVpORjBTQnpGdkV2bGpYcm00YVA0dVZFSGo3SGtDWVR4WS9hZ0lRbktp?=
 =?utf-8?B?ZGZyOVFJR3NSVzA0ODlyK0w2SGZCb0c0L0lEZFZVc2FCSklsbDdxN3VNa0tm?=
 =?utf-8?B?VkNZYlBoWGtUbkdIVENhQm9wVldXdWVRNmVrZnRBUzBZOEJjb0drZVFpR0hx?=
 =?utf-8?B?dSs1Z3c2emhGZm1FMFhyYkZyMEt2ZGZ2TkFVdS84aHNEQ25UNC9LUlFuWkY3?=
 =?utf-8?B?ZE9rdXhweEhzZXRacy8yRktHd0hWK2IvcEZWUVpBcHF6M0swWndTVkxIdWEr?=
 =?utf-8?B?cUdJQjdDQ3NPUE5xZ1lISXVzMVlQOXhZVjIxNXBmNjR1NmIyRHA1MUppUFUw?=
 =?utf-8?B?WVZLenhuYm1CakNrd3RHQmVOa0w2NE9CSHhhd0ZzOGh6VUNaM0QwaXVOellM?=
 =?utf-8?B?V3JZOEdxdVdXdWw2c2xLalR3OVlSck1JT1RRZ0tOYVNqeDUyS0ZFbVdmMTg0?=
 =?utf-8?B?Q1MrNjBDQ3BJb2x3NmRKSjM2ZnFrRDV6RXJoajBHRGN1YUhRc3c0SmVVbmh5?=
 =?utf-8?B?Z3pQMjA2V1hmM2FEOHZVNm03R0w2Y1JEUm1FQTJvbkMxL1BtM1IvYnc2bkJ0?=
 =?utf-8?B?bHVGUncwTTFJV3JOb2ZOc0RuWHh4TnB5UEdwTFVDcG5CcWVIL01ZQ3FqUUdh?=
 =?utf-8?B?Vk9EcFdNR0JtTXpRTk1qT01rTG9VK0ovc2RqbCtuYTd4NkcxYmRNdlp3cjFS?=
 =?utf-8?B?Z0kxV2RWOUFmVjJ0b3NyZHVIRFJqMXRmcDRtaGl0bkZhR2lIcDFHY1JMMWdT?=
 =?utf-8?B?RkswNk14cHFhV0xQZlNIckwvT1M1Um1JK1ZKMUdXcGgrSjQ0Mm9SKzRJM05H?=
 =?utf-8?B?WEwrcFkzWEdqVGJia00zd2c4OVhoclRlQ3M5ZE1DOGZLbzZ4WjR5VkttSkVQ?=
 =?utf-8?B?c0owOFdpZ0xyRnk4RWdmcmwwc1NyWjJWOG1nTFI0dExaVk5CR2xPeFdQSkpU?=
 =?utf-8?B?bWx5c2lFVHFuNVZtZGZUODAwNWtJcWRxTTlJcVNzVkRKQ2trVjZma0ZjMGw2?=
 =?utf-8?B?NnhMd2I3dGdhSjJZWHF4eU1nRE01djlLU3RFYjgxL2ttWWR0VnY3ZGluMG1H?=
 =?utf-8?B?b1VMSVhUZSs4ZCtQRERyMVpvQm8wZ0M0R2taNXg4RVgxRlhoS0NjOU94TlJt?=
 =?utf-8?B?blhVNlp2L1lkVGZRM3ViOENDN2p6c3ppTFJjelRsdVQvUXhKdWdCbkRxNjhq?=
 =?utf-8?B?Mzk4ckJWRG95ZUp0Qmpka0o1Q3ppQTBhY1g1UXJjT1l4RkUxOUZ0MFgvMHhM?=
 =?utf-8?B?YzNPZ0dwenJWbWQ5MnArVUpyRnA3U3VpbWc4UDFxdVdhYWRqZE5iUlZRM3BL?=
 =?utf-8?B?NFNIa2JyV2hrQk5NSC9FWitGaTZBQURIS2dBcEgxQU1ncEdCWWNHSmlTek5V?=
 =?utf-8?B?VmFuekxSaGFWRjV6RC9TUzZqcEV5SFRxOWJGOTBkM09Rc2FhWDlZc1RKdCtL?=
 =?utf-8?B?dS9takM1b3FBRFlud2hRQzhKaDlITk0yUVdidEpVdEErd1FiMWttUDdpWDJk?=
 =?utf-8?B?ZWlGY2kzckgyU0ErTmp5b2Y1bUZwME5sZ0tNVHgzTlJsQ2JJOXRCSUhtQXRE?=
 =?utf-8?B?LzIySDZLOWNIaVZNWU5SNnlUZTJCQThQVUV6VThvM2pQcDBLM1p3UkczR0Z6?=
 =?utf-8?B?L2ZVRDBrTGMxZ3hUd0lLWitxcGNPenBhMVU1c28wRGtLcnlORUVqejVnVXFV?=
 =?utf-8?B?MWFscXBzZGU3MlBHMWlEcUFRNm5YR290cnVlM2dwUVhwa0x2eVVKMzM4Q0d6?=
 =?utf-8?B?QkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 478f9a66-4208-42a4-e831-08dc6a0ba4e1
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2024 18:22:22.4781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1XK2eAQRyG53OwEH8LbKqyh7tzNiMUZ/I5PFmxkMY0xw+vS8VFqXqqdWzt8OzMMyXwyNuyeLXC1BDkHgGk740b/5l+/gMQZEJYT2em9IVtE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8009
X-OriginatorOrg: intel.com

Hi Isaku,

On 5/1/2024 11:19 AM, Isaku Yamahata wrote:
> On Wed, May 01, 2024 at 09:54:07AM -0700,
> Reinette Chatre <reinette.chatre@intel.com> wrote:
> 
>> Hi Isaku,
>>
>> On 5/1/2024 8:56 AM, Isaku Yamahata wrote:
>>> On Tue, Apr 30, 2024 at 01:47:07PM -0700,
>>> Reinette Chatre <reinette.chatre@intel.com> wrote:
>>>> On 4/3/2024 11:42 AM, Isaku Yamahata wrote:
>>>>> On Mon, Apr 01, 2024 at 12:10:58PM +0800,
>>>>> Chao Gao <chao.gao@intel.com> wrote:
>>>>>
>>>>>>> +static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
>>>>>>> +{
>>>>>>> +	unsigned long exit_qual;
>>>>>>> +
>>>>>>> +	if (kvm_is_private_gpa(vcpu->kvm, tdexit_gpa(vcpu))) {
>>>>>>> +		/*
>>>>>>> +		 * Always treat SEPT violations as write faults.  Ignore the
>>>>>>> +		 * EXIT_QUALIFICATION reported by TDX-SEAM for SEPT violations.
>>>>>>> +		 * TD private pages are always RWX in the SEPT tables,
>>>>>>> +		 * i.e. they're always mapped writable.  Just as importantly,
>>>>>>> +		 * treating SEPT violations as write faults is necessary to
>>>>>>> +		 * avoid COW allocations, which will cause TDAUGPAGE failures
>>>>>>> +		 * due to aliasing a single HPA to multiple GPAs.
>>>>>>> +		 */
>>>>>>> +#define TDX_SEPT_VIOLATION_EXIT_QUAL	EPT_VIOLATION_ACC_WRITE
>>>>>>> +		exit_qual = TDX_SEPT_VIOLATION_EXIT_QUAL;
>>>>>>> +	} else {
>>>>>>> +		exit_qual = tdexit_exit_qual(vcpu);
>>>>>>> +		if (exit_qual & EPT_VIOLATION_ACC_INSTR) {
>>>>>>
>>>>>> Unless the CPU has a bug, instruction fetch in TD from shared memory causes a
>>>>>> #PF. I think you can add a comment for this.
>>>>>
>>>>> Yes.
>>>>>
>>>>>
>>>>>> Maybe KVM_BUG_ON() is more appropriate as it signifies a potential bug.
>>>>>
>>>>> Bug of what component? CPU. If so, I think KVM_EXIT_INTERNAL_ERROR +
>>>>> KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON is more appropriate.
>>>>>
>>>>
>>>> Is below what you have in mind?
>>>
>>> Yes. data[0] should be the raw value of exit reason if possible.
>>> data[2] should be exit_qual.  Hmm, I don't find document on data[] for
>>
>> Did you perhaps intend to write "data[1] should be exit_qual" or would you
>> like to see ndata = 3? I followed existing usages, for example [1] and [2],
>> that have ndata = 2 with "data[1] = vcpu->arch.last_vmentry_cpu".
>>
>>> KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON.
>>> Qemu doesn't assumt ndata = 2. Just report all data within ndata.
>>
>> I am not sure I interpreted your response correctly so I share one possible
>> snippet below as I interpret it. Could you please check where I misinterpreted
>> you? I could also make ndata = 3 to break the existing custom and add
>> "data[2] = vcpu->arch.last_vmentry_cpu" to match existing pattern. What do you
>> think?
>>
> Sorry, I wasn't clear enough. I meant
>   ndata = 3;
>   data[0] = exit_reason.full;
>   data[1] = vcpu->arch.last_vmentry_cpu;
>   data[2] = exit_qual;
> 
> Because I hesitate to change the meaning of data[1] from other usage, I
> appended exit_qual as data[2].

I understand it now. Thank you very much Isaku.

Reinette
 

