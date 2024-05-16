Return-Path: <kvm+bounces-17560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA1F78C7EE9
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 01:16:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AE444B212D4
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 23:16:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E77A2C1B6;
	Thu, 16 May 2024 23:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lKZLnN9w"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E8C273FC;
	Thu, 16 May 2024 23:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715901402; cv=fail; b=Bwc/Ch12Ste8f/c6FOQEZcsdGwZKGK9TbxQwzLD+FaZ5RrzCGYbSNNPStpE1rSisqp0QwdHMuQHZ8nDjV2skHrCBCDXMBaQEJ+DDUMZbymhSVvkYw5u0s1NK5lo+5KwxI1ZgSDpSRmTvcBl8Yf7qUQAA4HqLuMLYvU1HsVsXMPM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715901402; c=relaxed/simple;
	bh=1DsspVeR7RsNmrueggicbMD79tufhpWDEeEbOM6or10=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Qwge8WHUpKbgV1/shIschLO3R55DlDMxEHRYuoKFR3veKZ65GrH0dGDqTE0ecj1YEQEetLkZHz9GZZ9OXNQ8IorYy0pUq2uJjA5WHki3vla3z7nhuOwGj2ptuGWZAdoAq1EkrptDCFYlazG7f7LIs84aNuEjJmZyy0aDm7Ke+1c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lKZLnN9w; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715901400; x=1747437400;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1DsspVeR7RsNmrueggicbMD79tufhpWDEeEbOM6or10=;
  b=lKZLnN9wUFHen6M7FdnniQ5y4le6dwSVsfXYfZ858Lpci+JHxFRKfal0
   9XCwHvsUGTuLQ1hX5V/ag9kc8rJkPN3lEf85dLBk47QoKfYsc8JXeDH5V
   GoY7aJkICdzidwy0hBjNTqOt7l6ixBCchDRUPx+ZasLN/OgxDDOTaHQnm
   PFdZAVqb575A6I5Dd+YNaZGCiXsS+LyZcHGAryRX6UvzqpYhgX2fjA2yQ
   i9yvuHVj7brI3U22vxZCFUMlRNEX3NCnbBzTujxQZqH3AHPdLTz+d6Zct
   iw1siWd8CLJJiqNq0jZlsJmZgm7m8HSqRUZV2Hla/YQkVWj3mJpVtObAf
   Q==;
X-CSE-ConnectionGUID: b/AoJnobQnSYbX55o5fYFw==
X-CSE-MsgGUID: uIWgxxM9RbmZSdNbQ2ihJQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="15880754"
X-IronPort-AV: E=Sophos;i="6.08,165,1712646000"; 
   d="scan'208";a="15880754"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2024 16:16:39 -0700
X-CSE-ConnectionGUID: rcCnAp4eQmOxipu8nA4gIg==
X-CSE-MsgGUID: af1uenvXS56sbGJYOz70Tw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,165,1712646000"; 
   d="scan'208";a="36384437"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 May 2024 16:16:39 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 16 May 2024 16:16:38 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 16 May 2024 16:16:38 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 16 May 2024 16:16:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JU7oh2qorY2vSKustbwoUY/7NNHfcZawVqKGlkl0CX1MHvaP7hN1RuxnrvKNrzn97qzyxcsoAv9qni7tj5OPwLO2oNuqa4jb7MrdqgUHfnnV20r4IsrEdOijuNfnc/vPQKiRnQSzH64Dj76y2lhGYDM2AXrXfNmukjoANHd5GtjrwQA2heHUZcQ2KDVFBqekuKJKBubHKlu2m8bIV3YyTMHmhFfnLs8dro+HYRazaQTruDpHiABGkV6Vl2vAi6DY1cNvYI8NUdy++hXh2I3dMckCEBNGPwhUox5bJK95zWw5YKrtO/VVtgLALGFzaH7KES77Xyt0+ihM6liOjLgo7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jOQtJbsmvlydLWM+a+6uGjVm3FYIDoF+cKCP8d7O0E4=;
 b=GP/YstrnwPz9mxABGGG/0LcFsXFZdweIO7KR/C+c+Qn2rUJZ66LRpqinjlNb1mcyOU/YruDnWpyZnDWjz0xidQu0KpngomBNDhb6z4kMInvI5fk5NENHeYE73gltbS/bLJy9VN8LeU0MBuam5M59VrKh53MR/SeDGyPgUKiya/9SEdHvlK9ytLN0BxuC1Ly54020gkjaPGsTjpNxKzhE2WT9rPIOwsv/84CO8WVwGdha/X77CaUubU8yJWIwRKx+vJ46pjXRDofnH5QP6pU2d9SkP5cyl+tZvttdh9qs1zZRGdwUHDk/5DQZ6lXEormIwS4PrvNQfz+dXJG2Z29Ckw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ2PR11MB8472.namprd11.prod.outlook.com (2603:10b6:a03:574::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.30; Thu, 16 May
 2024 23:16:36 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7587.028; Thu, 16 May 2024
 23:16:36 +0000
Message-ID: <1fe263c0-d6f5-417b-8819-c24dba3dee69@intel.com>
Date: Fri, 17 May 2024 11:16:26 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/16] KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is
 called for TDX
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "sagis@google.com"
	<sagis@google.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Aktas, Erdem"
	<erdemaktas@google.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-9-rick.p.edgecombe@intel.com>
 <aa8899fd3bba00720b76836ec4b4eec3347d43dc.camel@intel.com>
 <e5d163ea-63ca-4c4f-9e69-6d1686be92c3@intel.com>
 <00d2cfe84f67dde1d9cbdcb2a2d907354e2d704a.camel@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <00d2cfe84f67dde1d9cbdcb2a2d907354e2d704a.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0330.namprd03.prod.outlook.com
 (2603:10b6:303:dd::35) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SJ2PR11MB8472:EE_
X-MS-Office365-Filtering-Correlation-Id: faddbfe8-69ad-4197-a76c-08dc75fe3b7d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?akZPTnVSbWFUSnRuSjFWcWMvbGxodWdVMjRyTlc0UWxWYXg0M01Fb1Yyd3ZF?=
 =?utf-8?B?eVpEbWNXYitBRTZOWG9kNXAvQld5dkx0VytsdXZSMnFJamRDdnpwdCswWnlX?=
 =?utf-8?B?S00wZmFzSmxscXV5Q3dLaGNpdE9LeitUY28zblB5Zzc3QWNsQ0l0cUdHTXdh?=
 =?utf-8?B?dWZUVlNzV2FvSm5TN1ZneTMvTTFEY3djYVZHV0U5TVljbkZiaVdwSUNZbXE1?=
 =?utf-8?B?REhidC9oSGc2VjNma0piRnY5NGF0czhUd04xVFBkNld1YXhWYS9qU1BJRmcw?=
 =?utf-8?B?N2daOG9NbFVWTkQ4WDlVclAzYXR6UW9EcWtJUEs1b2MrY09vT1BQYjM0YzJi?=
 =?utf-8?B?U1RoTjBxZlJrRmVpV1N5czhsNHJiOTJlR2VjVG82NlRsMndIdStWOU9CVmxz?=
 =?utf-8?B?RzRReUZaSC9zTThmbWtSVStiSmNrRzdFOEEvMmtIS1dkVjRGQzJxVno5cktU?=
 =?utf-8?B?RGdnOUEwaXNQdXVWeE1rNzdBWVp3QlBCUk9CMERuL0N0Qm1tMUZURnB1Zzhw?=
 =?utf-8?B?YkI1eEkxRUQwQzJBaHVhbnl4d2l3elV4SjNwTVdVK3NSeTRwajNEcFpjWjVx?=
 =?utf-8?B?Z1ppQVFPRGtwWGNpcW9nQVJ3cmw0YmptV0RkVGZzdS95blBCZ0tBSzZBcnFv?=
 =?utf-8?B?Mm5vZTh4K2Y2T3phR1BRbEt4R2RzQkdBdUkwZTJuM1oxTUdjUGF4TThQUHZY?=
 =?utf-8?B?YUdxRGpNZGFNUUFnazVTekdEMXVjQ3NxS0Q5M1dQTTRFeFdHaHpES2hJZXJ0?=
 =?utf-8?B?cWkvRmN1MG82ZGU2WEFGZm91K1lDaHI4d2cxeGV2V1pTY2plancxM3FxQTR1?=
 =?utf-8?B?ZWtmYXpqbWdBSzRva2NTZXZRRlRZbXJlVGVUNmQ3dGhzSmhodExOeXZBSjUv?=
 =?utf-8?B?MXZ5V0dhd1Fwd0UrbnRaSlpBYUNoQ08ydkNpRWZjaFIxbzBYV01uSmZ4Mlg0?=
 =?utf-8?B?VlRmMnh5Z2o1QUhheCs2bENoLzc0Q2ZCUGhxUWVmS2RJdWtNQzkxNkJlVnRH?=
 =?utf-8?B?Z01mcHJDOHRxU2VxNG5ySmRaNkpQdVJBdHdnUFpWaEdFNVlkMXFlVm5YQ2Nv?=
 =?utf-8?B?T1kxc1BVTWM2WEdjazBZMkhjU2tuUHpSQjdrT29vZWxhclNXMzQrTnZoM0tu?=
 =?utf-8?B?VjhBN29jbUwwbVpaaStyQXhjOWZXMjMrU3NaSXJYTTVmdiszQmxiYi9DNzhl?=
 =?utf-8?B?M2dOd0c3OFRBa05GTmQySEo3aEcxT0VOZFhRWEo5dTFXYkFvdnREK1MzdHp5?=
 =?utf-8?B?NUpURXFWS1lUajJTMWRQcDVSaHJCSFErVnV2NVhUL29maEhpVDF5Y0FMVGpJ?=
 =?utf-8?B?UUVsL1ZzdG5mY1pwc3BDKzNkcDFLWGN3YlVEWWtLcVlSR2ZETzF2QVozUFZu?=
 =?utf-8?B?ZVlyL1NsMTZtM1lYTTRFc01WVEgraWhPNkFwTFZybURiSnhiUDFOaG44K1k2?=
 =?utf-8?B?ZEFxK3ZNcjB3UGMzUGxGTjlHMnNBUDVPMHJXRkhvbENCWk5XNmh4Y3F2b3BZ?=
 =?utf-8?B?UFgzYkZhWnZ1T2NmcWo0UzZwRTQrRmN0c0ZUaVRYNC9vTy9QaDVJQ0U5b25r?=
 =?utf-8?B?SFNhbU5VQjNVTVhPOEFKeFZjLzlSWk1JUCsxcXdzMWhaMG9rRVhRdDNwYWxI?=
 =?utf-8?Q?y/OoY+L5I1ahM03//EDRyS6cRAxfqmKMVTOE8fOAUds4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VEdReU9nTXIxejd5WmJWQVFnbXFaYnpCMngxN2FGeWlzeDI4OVFIZzhRSEM2?=
 =?utf-8?B?blVTK2RyZ3hoMFNKYVhMRGNlZjRPRGR6YzdIeXRyZlpHcVFHWkc0bFRRM2ti?=
 =?utf-8?B?T0VtVzIya0lMU3AzOENtNndIY05PanlDTWZvc1ZxQis0TjgyNjgxZ2RFd3Yr?=
 =?utf-8?B?SzJwNWEydlZOQWNtVy83U0lBMkhlUnFmUlBUU0hicXMrOGd2SmVFbm5lQ1Nv?=
 =?utf-8?B?V3FDNnhybFNEVjErT3ovTHZwemNLUHdjL0JadDgrdUpkZktOemxveE9IcjRY?=
 =?utf-8?B?QlV5dlJiWFVRZll3UWhPU2VxRnhTRVN0U0pQSUVOaU9qRENDVEl2ZGhORlgr?=
 =?utf-8?B?bXdOdjNhTjFDNXlUeFpyWGVMT1BzVk1PUUc2V0Q1SlIvdFVEQjNXQ3NrMFU2?=
 =?utf-8?B?S3N0TTZJVUtYdTFpQmpQY2NRZEZMRnNRUzBINlFoVTJvUUtoWU9Xb1VEcW9K?=
 =?utf-8?B?ZEdRMXNDeXZxQnhmSjViT0xTUDlPaFozQ3BjQVVTc29meTJyUk91UHNIZXNJ?=
 =?utf-8?B?NGczWHYwQ285djBuVUZvdUtNdDJOcG9hZkYwUmdtQkU0eW5qSjJ6amZvbk1P?=
 =?utf-8?B?NkRZZUlpK1VoaHJLaHhITFdPc2VqVlpyVnV1dXB1eU9ocWd5OU1HTG9UMlEx?=
 =?utf-8?B?djRnTitCb3RVd1h4SzdQYjJSWHBoVGVsNVRyMmVyeEtsbUwvYWZsWUtmSldx?=
 =?utf-8?B?STZIenpVV1RaVm9pVGQ1SFFkUzEzUVAzaFg1bFZkbW9mMDF3L0sreWJsUmRN?=
 =?utf-8?B?MEMvTXUyczEvL09WdlFGUyszaEp0MDZjdUsxMlhZdFUxMXUrQThReTB6eis5?=
 =?utf-8?B?OEk1a3BvMFd3QzR2UU04ZTVlcjNacmJXVy9lQWlWZmVEMDlwa0t0cExZUDlz?=
 =?utf-8?B?bFF6Nk9aWDE3aWZDOTZ6KzB1MForQVJ0ZlpnN3l1ZzMzU2tkOTBXQ0NVME5K?=
 =?utf-8?B?T1AyMTkyUTVoeDFRUktUWGR0OWxobWlwM2NDOHQyeVVzRCtLV3Y2cUFlbzVr?=
 =?utf-8?B?a3VvM21NcWgwa01FK3hUNmxaWTlTN2dGYnc0bHEwUDMxdndVdjNKZ1RwMzdq?=
 =?utf-8?B?Zzk0eGFyL2FSVHZHcC85QkgvTUszUUJjK3FseWZORVh2N2VhalN0bUF3OWJh?=
 =?utf-8?B?a041Mm5SYStzREJpZmFmV3hXZ25wTmxhR01TSnlXVHRkOWRMVlN1UTltSVBO?=
 =?utf-8?B?Yk5EazFNRGJYMTF0TUpZRjVNRGlibDc4QU4vRE0veGZoa1pIRXJBbVRUdlFH?=
 =?utf-8?B?cXFiYjU2Rlg0Rmo2a2RSb0dVY0twK3hyUFpMOHhrOWI4cG94Ykxaek9yQlg5?=
 =?utf-8?B?QzRhVmQ1K01mNjVMTkJhNnltTWtobzVCNHJVdVREaitWNjlqS05zUWNQaGtF?=
 =?utf-8?B?RVNzclZiK25pcmdxQ3dqV3E5WGdSVFgvaEJjWjR1b0tVMHZXY0p5UUhXYk05?=
 =?utf-8?B?YURVakgwOENtWG1Yblg4SEdnbGZTVEZGS3FVcjFCNlRnbWpzakRMNHVnWWVO?=
 =?utf-8?B?dXgvdEJ5YXk0S0drWG5WY0F1eVJTdWhPc1EvMWN1c1R0aFFuYzJmbnF5K2ZI?=
 =?utf-8?B?WTlyOGFHeG9SZ2lxT1AyVHVHc0ZiejI4aTNWQ25qUmVLb2FYU0JoUlQ5MjN1?=
 =?utf-8?B?NGFvVWMxd2l3VnBCUXB6OUVDditoUEpQVTl6MlBEYStrdG1USnQrc1JCeFhG?=
 =?utf-8?B?Mm5DUEtTaDJsdEpEamZHZFZSaENLaWpJQlZBZmN2QTQ0c1VWODJjbSszcE5V?=
 =?utf-8?B?RHZ6R0V3U2JNK29nay9lN0J0N1RRZkVmNG9mNkpCSmdReUZtVHdCSGdTb1hz?=
 =?utf-8?B?c0ZBUnArWjQvSGNSYzNMbDlUZGxZUk1XekdFZTZCMytDUnZZcWQzQTVIUzN2?=
 =?utf-8?B?N1Vka0xRWUlPd3hMS0QvdkNIOEpuUlJEbVhwLzdaTXg1R0hlMlErZmNOVFUv?=
 =?utf-8?B?Y2pCa0pwQWIxNmRRS1JQLzNSd3Z5T3Era1E1UHdCSmlWZlNxWGJ6dUxlSjNl?=
 =?utf-8?B?bkNjKzVxNU1rSllZdmVnNFlrd1pmTmNDU2hjTmVTYVF0cmZXaHd1dWxwbHpl?=
 =?utf-8?B?YVUrcXFTS08vdHhMQWlpem82TFJpTllyVmJsKzh0R3NTdmszN0d1MWo2WkNj?=
 =?utf-8?Q?iSFLk129xbPO0QfRTXoJa89Hy?=
X-MS-Exchange-CrossTenant-Network-Message-Id: faddbfe8-69ad-4197-a76c-08dc75fe3b7d
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 23:16:36.1054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VZdinBdHCQFPXpzdvpTh/PFVYDzUZsmPpVDXvVKYqEOlToWfnmnRrmTqJ6FhDoGRdukeb57B6CnXI70mBVHsdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8472
X-OriginatorOrg: intel.com



On 17/05/2024 10:38 am, Edgecombe, Rick P wrote:
> On Fri, 2024-05-17 at 10:23 +1200, Huang, Kai wrote:
>> On 17/05/2024 9:46 am, Edgecombe, Rick P wrote:
>>> On Tue, 2024-05-14 at 17:59 -0700, Rick Edgecombe wrote:
>>>>
>>>> For lack of a better method currently, use kvm_gfn_shared_mask() to
>>>> determine if private memory cannot be zapped (as in TDX, the only VM type
>>>> that sets it).
>>>
>>> Trying to replace kvm_gfn_shared_mask() with something appropriate, I saw
>>> that
>>> SNP actually uses this function:
>>> https://lore.kernel.org/kvm/20240501085210.2213060-12-michael.roth@amd.com/
>>>
>>> So trying to have a helper that says "The VM can't zap and refault in memory
>>> at
>>> will" won't cut it. I guess there would have to be some more specific. I'm
>>> thinking to just drop this patch instead.
>>
>> Or KVM_BUG_ON() in the callers by explicitly checking VM type being TDX
>> as I mentioned before.
>>
>> Having such checking in a generic function like this is just dangerous
>> and not flexible.
>>
>> Just my 2 cents, though.
> 
> As I said before, the point is to catch new callers. I see how it's a little
> wrong to assume the intentions of the callers, but I don't see how it's
> dangerous. Can you explain?

Dangerous means when "a little wrong to assume the intentions of the 
callers" actually goes wrong.  In other words, a general intention to 
"catch new callers" doesn't make a lot sense to me.

Anyway as said before, it's just my 2 cents, and it's totally up to you.

