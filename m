Return-Path: <kvm+bounces-5709-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E5BB68250D4
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 10:28:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9641B285B2E
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 09:28:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ADB5241E9;
	Fri,  5 Jan 2024 09:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Dp5kmJIl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD1222EF9;
	Fri,  5 Jan 2024 09:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704446925; x=1735982925;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+T9wvX5PaN1Kvor2o7a8+ORD+aXYnq7JbdRSIBx3d+Y=;
  b=Dp5kmJIlh4CBfic+Ya8LgOoZCfMvcdqUKcizcI+/Dk3BFmK/McYjG8L/
   vbtGc6gBLdH36+F0ovLLCjR/coYERyfp54i89RsEQHGnx+rluacN+PgyT
   e3W72citG+d5hQIRgmdU0xQImJWAnfv0ixDcRtX88O3ZoYxR2XS7DpJ8U
   sRVXa7kauXlZ3JNvDJV4tUiI5GA37Rlml8PqUfGfckpsJO92HLDc977EQ
   MPngnB8kdZkIMOd0LKA3aO/32IaX6hbnYtDkRwjNK7L8CQ/cCZKKZsdG/
   wbgZfvn1T86+PDhRnXpNCx6hJgwiJr5dnlRt9tXELnffR03fr4v1HjOwn
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="387918129"
X-IronPort-AV: E=Sophos;i="6.04,333,1695711600"; 
   d="scan'208";a="387918129"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2024 01:28:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="1027714499"
X-IronPort-AV: E=Sophos;i="6.04,333,1695711600"; 
   d="scan'208";a="1027714499"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Jan 2024 01:28:44 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 5 Jan 2024 01:28:43 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 5 Jan 2024 01:28:43 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 5 Jan 2024 01:28:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D522LrhDxwClqXDebp4+DZ7EY+xXY+LFgrdWjCzNEyX/sxH3TP9c9pm7VgortA6enDVmElUttNV+qbmXUFuk/Weh+ibr20ipHwMQVzpEyB7Nlx+TruRREcGLOgjSRN/RQFk3qMQqJWOHl+8Bp7eRqsPB7fo6RYcguXnnph25Bk9koEev5q+gmAUDJlpos+OPMK7+olwjjdqUby4m6/g13LKxK5moHgeNlJ8xpc4N81wYm4riFjxIFYwCjCtfwP373O7H+LGOuWpFc8+bGwEaf1NILcKbtZdH1NYAmIY324Tzt/jHKaHzam8GhUO+aS7vNvs2HzfpHkEp4Ih1p5RniA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Cr6D4Q4Y63rGHO2skd5KXz4GMxjx1q+4njavdjhUsM=;
 b=Uruv2wCl4LK/Gwyd68PBlx4Ni3UAdEk1C7jhH81LhnLxmJgEub3kf3iwSp3hkZ4YpGPuHwHnRCaNeX7/Pwo8jAWvwcQoMi6z1WeGr34pSgp0fAJ0TKyYcS5bGFO2YsYB4bEjSO+Uu0M6axF1+cyz1TfR3aZZ5U2DxDb7KmKgJ8SVThcjJ6daVdok5w5Amv2qpRmHc53ZVL/bcfljIt4h0mIShkeM8wuDSz3WQZmxa8kBR4YX9RSKjkPeZEUJjm4EsLOi2xfhUneasMMWcVeNyD8YLdsWirp0QGtDui6Xo2Hq/PK/G7ioHjO8tSe+5twpPmRnDvA6osfiHattZ546Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by IA0PR11MB8379.namprd11.prod.outlook.com (2603:10b6:208:488::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.17; Fri, 5 Jan
 2024 09:28:40 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::819:818b:9159:3af1]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::819:818b:9159:3af1%3]) with mapi id 15.20.7159.015; Fri, 5 Jan 2024
 09:28:40 +0000
Message-ID: <8f070910-2b2e-425d-995e-dfa03a7695de@intel.com>
Date: Fri, 5 Jan 2024 17:28:27 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 00/26] Enable CET Virtualization
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>, Rick P Edgecombe
	<rick.p.edgecombe@intel.com>
CC: Chao Gao <chao.gao@intel.com>, Dave Hansen <dave.hansen@intel.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "john.allen@amd.com"
	<john.allen@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
 <93f118670137933980e9ed263d01afdb532010ed.camel@intel.com>
 <5f57ce03-9568-4739-b02d-e9fac6ed381a@intel.com>
 <6179ddcb25c683bd178e74e7e2455cee63ba74de.camel@intel.com>
 <ZZdLG5W5u19PsnTo@google.com>
 <a2344e2143ef2b9eca0d153c86091e58e596709d.camel@intel.com>
 <ZZdSSzCqvd-3sdBL@google.com>
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZZdSSzCqvd-3sdBL@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR03CA0102.apcprd03.prod.outlook.com
 (2603:1096:4:7c::30) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|IA0PR11MB8379:EE_
X-MS-Office365-Filtering-Correlation-Id: bc956235-3ab2-47ac-015d-08dc0dd0b386
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VQdhA1TPm6zaNSX2huF3yH3W+3yLyboZzRosg9zy0VKnnZ3nAEz4UxhUoTz7nvRnKXuxVU5QTtwxzhMN++Z5kKIkbENW4X/CBCuu6IGX+G2Bxu9TTHt08Oj+/Yl3OHclNd8/UvlxAC+i+/NsCPtK6lBoKUBQN0WAkSoIoy+POkWzM8V2bm90bnwEvbgOQSVbmPOlWNrWa2qRzKmvUogBxO/jHDWHHSbbJ3+PlvByJEclK3IMU3YuNC9fVWQoNuC7S+sdZCaSQ2/gZuYCAvmarVJbsvJ5YKWt3iSruMA7NLxSLNQW86RXgZ8p/aU4nCvM+C7x4PFh39tprPNs7mccrhpSWHSo0RlPI+U3muPY7QaqUbbMzMS8ynSBsJ++8oCsEW5k12nDd+baPZgVY/5dIIoQ2Nl9NmAxKgT6jPTzOv243AubVSw14jCsa01jjZtfHqhihdohH9+xxFrZzTAMV5M6SfuLo0Q8/eUcU41RDF7DDsGOZ9J6vSI2Np5b6xo8WpTS8oIeMZG8Ff19Ue8Gt6slqM7ssZXCPwddeQJ8nGPGKFBfE1bKpAyHQAlfn1MgHlvDnpfK/hH4914YGeRIPBa8okilToUi6Qj9S56wGoc1iS8yB8j8q/LWbekeSv9P1bxt4lIIHOVAG//E++3bEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(366004)(136003)(376002)(346002)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(83380400001)(6506007)(53546011)(26005)(6512007)(38100700002)(4326008)(8676002)(8936002)(2616005)(5660300002)(478600001)(2906002)(6486002)(110136005)(6666004)(54906003)(6636002)(66476007)(66556008)(316002)(66946007)(41300700001)(36756003)(86362001)(82960400001)(31696002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eXhjdk8zMm9IV0VCQ2VBS2JxaDhodnhSVVNHdW1aZjgrTVp1R1NXOVhMOW9l?=
 =?utf-8?B?ZU5za3BHb2ZOSWN3QkpGWksyWk5sQldSWFVRSmdISTJrMkxNZm5GSFFCZHl1?=
 =?utf-8?B?bFVWdm5yaEVWd1NBR1VQWG1vSDY1aWZQVVNwdExRWFVRNG1JdVlYcGNUVFdk?=
 =?utf-8?B?L0tndENCNFVSNFRuZzhPODNlZzNMTXMvdDdhK2V2Z0xobmp1YUhkdnRGL2RZ?=
 =?utf-8?B?ZTI4TDBsVHZpUEJJNWE2djl5eWh2a1VWZ3NSU3FvZko1OWlvRWM1bTJSejNX?=
 =?utf-8?B?eFJBM1B4WldDaHN4L1hJRmpNMnVDUGxSQ095MVNqdUxkNmt2cVZRWWEyMms0?=
 =?utf-8?B?NTAyUTlzSjJHZGthb2ZWWXNYK2E2enNiTXVnUEdqN3RBYjhBMnlWeG9HcU40?=
 =?utf-8?B?OXZQU3FubnhqUTNMSVhBa09uMUxwVzRBUWJTR3ppSnFZdnNoMVgzNXFMM1JQ?=
 =?utf-8?B?cWczaVAya2dWSisxZ2cwU25udlBaQ3RoRUdCVXFqdGUrb0lQYWJJV094V0NT?=
 =?utf-8?B?NE14QURIWnI5Z1N6T1BnTk9GMW9yS0Z5bmdMSnBJR0RSbW1vTmxscU16eHlQ?=
 =?utf-8?B?OEgyMzRnWmk5OUxJRGZORG5TUitwUzhQa0x0OCtFcWdCNEdjanl4a1FWWW9p?=
 =?utf-8?B?RjRZTHBsWktySndEU3gwTlBnTFpZMGFJNG1wRlQxbXorSlNlMDRxeTJSRVJ1?=
 =?utf-8?B?dDFnalJFVW1zUC9BMzlwbVFETkJieWxzVXMzRXNidnp2YzZhNGFld3NZQnlm?=
 =?utf-8?B?VlhqTXoxWXpsbTdESjBleVdHblI1ZnkyZzZQT1NncGl5VXdvTHpIK2d5QlJ4?=
 =?utf-8?B?T25yc0pzT1hXZ2RrelpEYVlOYUZxSWNMVWdhd3VJZlEzc2ZqVEl5OWFuMCtt?=
 =?utf-8?B?eWJpckgwYjE5cWZXL0EvM2kvdkM3NVVQK3U5L0tiVktIN3hYbXBzbUNGWGpZ?=
 =?utf-8?B?Yk9qYnREck13UksyT0xYU3A1a1hXeXFLQ2Rad1dWNDY3ME5lV0YyZU9RUE9E?=
 =?utf-8?B?L0VQamFtZ2psbW1JSjZHZFFhSjd4UUI1dCs1c2JlQU03cFdNT0VNNDI2bGFw?=
 =?utf-8?B?Vkl3Y0VzRklZQjlCR1pqc3hJQU9sSzVXYzJBY0tBWFhTK0VEcXd3UitjckJB?=
 =?utf-8?B?U0s0THlQeDhWL0hGRHN3dXEvTEp5bFB1OUdyOGNnOFBtNWVKbndnNWwwNXhp?=
 =?utf-8?B?OE9KZzc0Z2s2UmpVMjlmSks0NVVjaXFsSWRTR3hZcEc1Wko0KzJRMUtBYU1r?=
 =?utf-8?B?bWhjanhBWC9GMTkzWWxDZEhYQSsvY0hUVy9SbTBRcEQrSG8zVFA4REorNWR6?=
 =?utf-8?B?dVp5SzdTdmNOcjJGMVhEanFsUkVITGtxVUJTTHoxcyttcHVlOWRwZy9Tb2RH?=
 =?utf-8?B?cUJ0YS96akJiOVNGWGNSc2FOZm1QU1ZNSXFqdmhLcFRKbHg1cGh0VktleDVk?=
 =?utf-8?B?Q2kyMFVMSDhTNHd5dGQzVGdraFc4SDdIMWRGTDh4QVRxQkR1ek1XZFMzc2J0?=
 =?utf-8?B?RlY5V21lR1FVejl0bSs1QTkxbTZTbzVpdjFSeUVsYWozQzVnYWhadjZXampU?=
 =?utf-8?B?cUkrT2ZPVEVtWUwrZ2Z4NmJZUnJ2Y2h4dEN6a2tsR1dMYnBLWkR5Yjh2bENH?=
 =?utf-8?B?TUFYWnRlMm1HVWFNTmpOL25lemJYd2NXWXFEZ3dpZ3NEY21xcWI4bThZcWdY?=
 =?utf-8?B?RE1YRVFONnRkSVNXZXRTV29uU0ZtMzcvSUhHNFlXQVZ1bThqNkl2RnVscnJz?=
 =?utf-8?B?dmd4bm9mWEJTT3hxSTUrTVBZcUh2Y3hURFNSa0J4OWVDS042cWI5UEw2b1Jh?=
 =?utf-8?B?VHY2Mms2bG0zdWQzRzJ4enlQMzY0Q0NCd3RCNStTWEJvTm1Wa0QzdkNYaVRV?=
 =?utf-8?B?OFhTL2VCMEFNby9UNUNGazR3c3NGc2dwNXo4bUhvODAvWUprVkc5bU5ZRVFH?=
 =?utf-8?B?WVFiVjJjRlNHSWFvUmlDUmp5Y3oyc1B3ajNWblNPYTI2RXo5ekt2ODFGQ2hw?=
 =?utf-8?B?QU1ENkNwMTBtbTZNZ2pxWHN2QVRBUTdFOUxEdGZTR2pRbzgrTDBQTjBCUjNX?=
 =?utf-8?B?MnFpODJPVU5nVFNxeVVPODJLT0RET0VUWjVjNUgzMFVWemkxN2l5MGY1ZWZM?=
 =?utf-8?B?TFptbUpTUHNtVzVQRXhNaldCQ2dkdE9KZ0h2UEFxNjNBSVVtTXgzb1crTzA4?=
 =?utf-8?B?ZWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bc956235-3ab2-47ac-015d-08dc0dd0b386
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2024 09:28:40.0062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9JRKxDEU1ukzmUvgzTW1X/UU2B4s7BggVqpOi6HPbotN5hAhmpaS6KnLO45JiEagbeXBQntD8AOIfV0fGYM+JQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8379
X-OriginatorOrg: intel.com

On 1/5/2024 8:54 AM, Sean Christopherson wrote:
> On Fri, Jan 05, 2024, Rick P Edgecombe wrote:
>> On Thu, 2024-01-04 at 16:22 -0800, Sean Christopherson wrote:
>>> No, the days of KVM making shit up from are done.  IIUC, you're advocating
>>> that it's ok for KVM to induce a #CP that architecturally should not
>>> happen.  That is not acceptable, full stop.
>> Nope, not advocating that at all.
> Heh, wrong "you".  That "you" was directed at Weijiang, who I *think* is saying
> that clobbering the shadow stack by emulating CALL+RET and thus inducing a bogus
> #CP in the guest is ok.

My fault, I just thought of the normal execution instead of the subverting cases :-)

>
>> I'm noticing that in this series KVM has special emulator behavior that
>> doesn't match the HW when CET is enabled. That it *skips* emitting #CPs (and
>> other CET behaviors SW depends on), and wondering if it is a problem.
> Yes, it's a problem.  But IIUC, as is KVM would also induce bogus #CPs (which is
> probably less of a problem in practice, but still not acceptable).

I'd choose to stop emulating the CET sensitive instructions while CET is enabled in guest
as re-enter guest after emulation would raise some kind of risk, but I don't know how to
stop the emulation decently.

>> I'm worried that there is some way attackers will induce the host to
>> emulate an instruction and skip CET enforcement that the HW would
>> normally do.
> Yep.  The best behavior for this is likely KVM's existing behavior, i.e. retry
> the instruction in the guest, and if that doesn't work, kick out to userspace and
> let userspace try to sort things out.
>
>>> For CALL/RET (and presumably any branch instructions with IBT?) other
>>> instructions that are directly affected by CET, the simplest thing would
>>> probably be to disable those in KVM's emulator if shadow stacks and/or IBT
>>> are enabled, and let KVM's failure paths take it from there.
>> Right, that is what I was wondering might be the normal solution for
>> situations like this.
> If KVM can't emulate something, it either retries the instruction (with some
> decent logic to guard against infinite retries) or punts to userspace.

What kind of error is proper if KVM has to punt to userspace? Or just inject #UD into guest
on detecting this case?

>
> Or if the platform owner likes to play with fire and doesn't enable
> KVM_CAP_EXIT_ON_EMULATION_FAILURE, KVM will inject a #UD (and still exit to
> userspace if the emulation happened at CPL0).  And yes, that #UD is 100% KVM
> making shit up, and yes, it has caused problems and confusion. :-)
>   
>>> Then, *if* a use case comes along where the guest is utilizing CET and
>>> "needs" KVM to emulate affected instructions, we can add the necessary
>>> support the emulator.
>>>
>>> Alternatively, if teaching KVM's emulator to play nice with shadow stacks
>>> and IBT is easy-ish, just do that.
>> I think it will not be very easy.
> Yeah.  As Jim alluded to, I think it's probably time to admit that emulating
> instructions for modern CPUs is a fools errand and KVM should simply stop trying.
>


