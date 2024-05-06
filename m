Return-Path: <kvm+bounces-16703-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 97DEC8BCA97
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 11:26:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 262AF1F23212
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 09:26:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 174451422DD;
	Mon,  6 May 2024 09:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RoJuZb3j"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B1F6CDCE;
	Mon,  6 May 2024 09:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714987559; cv=fail; b=dw+u2NZcYWdpzkoTFsEHy6fpYKuN4GaZY3Q2uH2mbfGY0GM8iBxBFMitF5yaYJXhYducyu33K34fNQMJ42JOzTl2o9eZ06Yq001PjBtPKTTMgnEbWgmdAr5Tki9mw7jF3gZG36wXDypcIkOYjjswtMHRkho5cmyEdKWPcGs5aiI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714987559; c=relaxed/simple;
	bh=0DcdYA3S9k7xrlDeOkEh6t1yHkrcObqvNoTSj6jWLzo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BLOorrxf+Kd1C8lU8F4fdh2E/6inRs/lp8UBuzmtId1IwVG8u6iVihb8QvlULeviEz9OPtw2iVeKAaWaawKg1gw1ha8jpRNBfEA4818w8NcT40PNPyh2z4hgCfX0qFp/+n3QeGmZuN2ds9dDSI2ptgYXomYtAup3EiFY3Tq1L6I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RoJuZb3j; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714987557; x=1746523557;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0DcdYA3S9k7xrlDeOkEh6t1yHkrcObqvNoTSj6jWLzo=;
  b=RoJuZb3jJM+jI408PDF32KZCzz4o/akBV2WVuufymY3a9oZC5Wg5L2IT
   yb8klpu+l+PoB/jqtQnAYuxgfw5Xtq42GCLp3QEATUdqebBFeBvZS1l5N
   cydG5TAwCq+tlDx0agEwOe3YVYP9A3lkaW3p62lEtKvOmkxSHak5qnE8u
   gcK9/J3zyQyJh04si8bqGTRhJqZSGsdmkSWUrn3vQc30or/CmCcfGywbE
   qjJw+/8yUEzkx7jo12ftUyoVTl9xVGlpH6tYnxg2SAbUrmTtz5SezoJ4t
   ji1+1LPizX2xlKb9K8bk1hXVe2HVFfQwvoOdXZNt7W3KO8zxmxMgezmy9
   A==;
X-CSE-ConnectionGUID: ATon3sTKTgyqC0dZzhTLJA==
X-CSE-MsgGUID: fWgEvdamTDCbugHniPmW4A==
X-IronPort-AV: E=McAfee;i="6600,9927,11064"; a="10847433"
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="10847433"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 02:25:57 -0700
X-CSE-ConnectionGUID: XCs+28qbRCusY4rhI9H8zw==
X-CSE-MsgGUID: e7vswTGvQEapW5aXmTdsuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="28189783"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 May 2024 02:25:57 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 6 May 2024 02:25:55 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 6 May 2024 02:25:55 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 6 May 2024 02:25:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FRi8Oo99c9PRsV5nM7UhckxF8KrJuf7hhUIU3UBepKEIC/Fq3BJ1Vynroshjd9LKjm7FYwWLzx43Tj2tS32uc7ZmMa7i13AK+/P8t6V/6EdS/QhqNBpxEg+GKtiEUyqnD4wN9VvD9HDu2WhMMuBajGW9qcTPTMufWyA002clHz59R4DAQq1ay15Zrms1ZkCkuzFV3joKfFJQKHP67Rtj1PhJan3j5+OXDf7mpr/WMLbtmOmVoHV4T4bUu3iDDMJBxM+3DK1yDnhIhPJYdEZXEf8OkPNZ5CXwXrZWmselBA9mcKKl0phG7ryEqJgDDCxJ8iLNLw35nvuysDr8HicAkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/zd5uAlZesqPOdnyInDWFmN7ldaBEqGtEyHOJzMBvJI=;
 b=AAMusYZO9CUQr3idG3nLVF6zSuodga+nU1IrFC2vCIc7zTeuvd2pMCrnUW4wGUnMXZLnK17T5mapXyIng/pPbk1lXFYZt0ezKSxNzQ0+N6JMHeRfmPGhhdO9KsuiH5iQK0UaVXahV1EEncvFTXmCL7Imm8gmDui0d0Kw4JMMlceIBkYRnBLjOrq2EgQNI4d2YxJG/wuceg6pDDKukTgihKoL19QdwNZwqBqVFLfTczzS3C6QmY2NmDOUsnHc+msr6FCkBa1riBa7pJznEcnErA78YT35tXdPlcBo1ti4Wn3f43DOVHZPoTu/fVSrYLhxHT8ELwI/2Xgx4vdb+XppCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by IA1PR11MB7248.namprd11.prod.outlook.com (2603:10b6:208:42c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.30; Mon, 6 May
 2024 09:25:54 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4%6]) with mapi id 15.20.7544.029; Mon, 6 May 2024
 09:25:53 +0000
Message-ID: <071499ba-16b3-4c79-8b4b-95c03faf7493@intel.com>
Date: Mon, 6 May 2024 17:25:44 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 26/27] KVM: nVMX: Enable CET support for nested guest
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <dave.hansen@intel.com>, <x86@kernel.org>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<mlevitsk@redhat.com>, <john.allen@amd.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
 <20240219074733.122080-27-weijiang.yang@intel.com>
 <ZjLO8FsnJ7NgED0G@google.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZjLO8FsnJ7NgED0G@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0038.apcprd02.prod.outlook.com
 (2603:1096:4:196::22) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|IA1PR11MB7248:EE_
X-MS-Office365-Filtering-Correlation-Id: d66707ff-1dcf-4721-071a-08dc6dae86dc
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QjdnYnhrZi8wenpJWlJoWDVBRVVNdU5laThvNVE0L1NHRW5uTUlycXdxb2dD?=
 =?utf-8?B?b2ZMQ1pMRExIemFza1dlcnM0dzE4STVPOVRmZksrTk16eFJyUnJ3YjNxenJO?=
 =?utf-8?B?Z1RqVGNPTjR1VDNLUDNrRGc2a05tSXZRdVZ2anBER3RRek95YWJ1YklRbzh3?=
 =?utf-8?B?UGdvTzJpU3ZmK040TnVqbVRnN0FaY2lkOU1xNHdrMWpGSXN0cmlSV3hwaytN?=
 =?utf-8?B?QXlQc1BZd244M2tBWjdRWHBJQUJJU1RMWGlRMDEvSytpU1hqbmtLUEFGQmtN?=
 =?utf-8?B?NFhvY0l1VHlkcjVpSGN1SCtRV3IzazJwbFd5RUZEVEdnSVR5NGVUY0tvckli?=
 =?utf-8?B?QmZoL0cvU3pMN0JaOFpKMFQ2dURvSWlpNTA2NlZMSkwwRkYybTM1eXJTWDlS?=
 =?utf-8?B?WVlUU3ZxNUJoYnpnb3FGdTFOV3V0d1dGU08wM05mbkVXQ05OVHpqWGZQTXg3?=
 =?utf-8?B?S3d0LzAyRGNvVkc3U2xrRUR2OGN1ZXRtWVl2cEtYSEtSQmdvZ05vT05lTlhP?=
 =?utf-8?B?YmJqV0ZTaFh3Zy9TUG12TVdSS1pmNlhqVnZXd0EzTHA4WlZ5bGd5cGpFeVlx?=
 =?utf-8?B?dDJCc0pLSlI0YWRtanNXMVFVeXRzdlMvOTBTcytiZUJNT3BUSVV5NmVkTE5z?=
 =?utf-8?B?cWx4M2xla3FDQ2crdzhqVVo4a0NNWm40RUswalVXQUNoTmlCc1RrTTU3NS9V?=
 =?utf-8?B?WHBEb1ZwaTF3QnJLSGFYYU9UT2ZDNVNzdVdMTFJ1VHZobU1HbzJhQzkyNWd6?=
 =?utf-8?B?eDhCTk94UmdqVkJtRHVWc3o3bXpsRmxJeGVpZFFKOVh3cGxWU1lNTFlMOGVU?=
 =?utf-8?B?ZXdISFRIcTg1Rkw3eWxTWTFjWkxNZVZwTkpBMzI3dXpiSVJrOUJhT3FHRXE4?=
 =?utf-8?B?RkxIQi91YTlYV3B6eEMyVnBuZDJSa0p5d1NTWm0xZHFYVHA3YUdGbk9LSFc3?=
 =?utf-8?B?WFUxdklGVmZxU1Q3cGRWYmVVeTU2bkNwajJXYTBSdGl4VlVQU0hGRlB1RnRR?=
 =?utf-8?B?Q2UzcGlDenBXd0hjcmltTS9xL2xnbEFwSTFiZjRRckY2bmlBKzE0SktWSFNT?=
 =?utf-8?B?emxyK2RDdEVMdWdHSlFBMmp5SUtBbWtWZDM5STRUQTFwRTlEVkptOERocTVy?=
 =?utf-8?B?RythTk9ocE4wNC8zUVd4TUwyNkloUnpod2RTdzFKbUVpOWFOTjFVNWVjM05x?=
 =?utf-8?B?ekN6emZlcUdMNUhOOWswKzVoaVVCcjlIWEFmbHVVZ09uUW52YkVqbUJXMDNI?=
 =?utf-8?B?UVJxQXo1RzVtWmZpVmFZZ0lRbjNuMVVHSnpGaEVuRHlaakIvd0k2WkZtV0VN?=
 =?utf-8?B?MG5pZXVpbjFOYSs5b0pPdzMrQXdMczVIdlk1M1ZpblpvajFJWi82SEpFa05J?=
 =?utf-8?B?SmVGMWJJY3RVZElsZHNkTTZOeS9NbXdkZzQxOExjV3hONlFYUXpTcE1wMGlN?=
 =?utf-8?B?REo2Nk5FNW9UaHBEdWY2b1RockVlaGFiK1dDRjBZaFF0VFNwZUZzYVkrV1hD?=
 =?utf-8?B?SUtJQWpXbitGVFRkR3lmUks4Ty9GamVOZ2FlVEtyNnRhT0wyS2hnSk1KOW44?=
 =?utf-8?B?WmVUTkYrczY3dWRGZ1dsNGFPeFZKN1NwejZ0dFdRQmRYMTY4Rm1tRnh1Q3NU?=
 =?utf-8?B?R1JTK1dPMk9QKy9jQkFqazJZWVNIOThIUXRsdkZ2ODFmVkxzek55dkhpNnRG?=
 =?utf-8?B?dXd5UmRCRWJ4amdMeTViMjl3ckVaR2lWaUpiSWpnSFpiaVAxQkJCYnRBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y3Fwdnh6ZnpPTnVyaEJLdFJRU0xYbXdkV2pLZ21PN0RWQ3RoT01rSFRBUTdh?=
 =?utf-8?B?cWtMZmtQWHpwcEQvazNMbUdPMWNtNG82VS9IUHJDUnQvOGs2TzZSMVdQMnE0?=
 =?utf-8?B?MjJzcnl3U0xuQ1UvM2k2RkVXNEQvVXNLWUJyemxvT3Z4aFhIMUJRS2Vleldz?=
 =?utf-8?B?L1VXVmVIeDlFRXNyTXNNSVpYcXIzeU4wY01DdWFHUHJuRysycUI1WHpsNm9M?=
 =?utf-8?B?Q25ZeEc4dDlsbGo0MC9zMjFzMkt4b2dFbExMY2U4Q3ZRSnoxQ0xhR3JWQUlS?=
 =?utf-8?B?Y20yTWZuRy8wMitPNElLajdIcjBJVWwyd0N1NUVGS04rSDYzV0dGTjV2ajlZ?=
 =?utf-8?B?cjJWaVlZNGxLV1dGZlV0bmhPa2ZZUkhSTTcwNTJ6R1poQmJBR0t2cTFUVEtM?=
 =?utf-8?B?YlY2UGJIcmF1STU4Zy9ud0RCSUhVcUQzSmcybW84QWMvck8yNmFwV25ZeGdS?=
 =?utf-8?B?MzEvWEUxaStIUTJXTDJWQ2phN3VSZ25MUXYvdGQ4TnZ1M2grZXE0c0FhYlhZ?=
 =?utf-8?B?VnRqRzJLQ1hEUXZmNWM1Rm02YTVNMGNueWNXcFJrUkpnbDZZNzJ2VnFnbFJ4?=
 =?utf-8?B?MHFvRVZ0ai80K2NGUXBtbWl2UTMzTW1OeFgrbFkvQkZ0dVJNbEMwb3lEakMx?=
 =?utf-8?B?MkxrbDVMeDVERitIWjhXQWlOcW1ic2ZtUERZZkdkY1dUTTk5akoySm9xWUNR?=
 =?utf-8?B?V1ZqTWI4Y2crOTRGb2hwWGtmM3M0UVJ2OEJRT0VqQmpNMVdTVHFQVEZPWWlN?=
 =?utf-8?B?N2Q2eE80UXZIaVF0dWxxRHp5Zys2clFaSW85Z1A2UTI1M3greDJWWW9kWWUr?=
 =?utf-8?B?bWRJOWxSYWd4dWJCTGV0bTd5VkZzanM5N2ZTK3JKVFZBOFgxUDJ3WWRlOThE?=
 =?utf-8?B?MnJBMXJSbE5kZnNMOENaSkgvNDc2M2xUQTlDWkgxeUZUQ0tWRHBVTVBJWWJo?=
 =?utf-8?B?SVZoOEJKdk80NUdlcC9oSURja3NlVWtBWnVhbDk3WWhNVG1zcXIyd0tySFhS?=
 =?utf-8?B?YWFjSHFXdnZjbUpwUnNhV0FqMzlDQkNTbEhZU1RyNloyaTJpSHI3UG1wNjRZ?=
 =?utf-8?B?RXJvQXJTRjNwQlQ4Ry9CU1NPZlNIaUo5alI2N09qWVlLalZHRzAzemVQMDJp?=
 =?utf-8?B?SHA5Vk5lREJYaHlWTmNxTmNodWxrM2J6ZGVRTEUvYTh0Nk44cS9wRXVyYzI1?=
 =?utf-8?B?S1RWWVE5OUcwOFpQeXhQVzZVbVhyUDBzOFNYcmloeVpPU2NBNWwrRGVvbGdM?=
 =?utf-8?B?SmZVVVJPN2djeHBROVdPZTVVQUtveTdSWnlHZWtvemlVSVF4K0Z5T2hPckhM?=
 =?utf-8?B?VlpVYzhmbGlpRzZydk5ISHdlcUZZTmM2bWtPSFhzVWpoMFpyelZJdXpOVVUx?=
 =?utf-8?B?dFFyQzlnU3kxWEExK0VjZlJyYWppS2thcS9JY1ZnSVY1RlF4cWJuNnN2UXpx?=
 =?utf-8?B?bTNmZE13Mm9VY1lHUDFMRHNkU3JUV0VjY2swMzNVWkttdmVkdkdiNjFjVS92?=
 =?utf-8?B?UTdlQkhqWUZYRUhLcGZUZFFPMkR4VWF0OXJIWFBnTVhUSTc5RWhQTVhJVTVZ?=
 =?utf-8?B?Um16VW5URFovSjBlYlN0STk2b1NnVTRFUFZYd0kzTHplT0MwRENmVm0zM0Uy?=
 =?utf-8?B?QjdyUlo1R2RKcG13RXFMcWxrY3NnMG1qbGxsdHpENkZndnNMRzh4VC9yYmM2?=
 =?utf-8?B?eWpRT2tTRlNsaWx0bUQzWDNLZ2dSUzJNME9GRmQ2ck5XYmNsTVJ4M3lmdFRU?=
 =?utf-8?B?cnJLRDFPM0dBWXExd0ZWZDNIeEY0ejl3ZjBxUXhveUx2RE1PUnhLc1BoT1RV?=
 =?utf-8?B?OVZPVEl3Y2pQRXN3ei9iRGp5TzJ4TU9idStxU0tpQWtEQUpvLytSUU15UXpi?=
 =?utf-8?B?YjFnK3VtdnZHMlF5cmNCWEI5d2lMa3lSSWJZYkYwMEdvckxNUkwzOFVBMCt6?=
 =?utf-8?B?Yzh2UVFjZVlHc1h6b3k5enIxakNRczBqTWJpcUZXeW9CcFE3QWFMSVdSM1ov?=
 =?utf-8?B?eUVzZSs1ZUpQNDFHc21Ta25reGtrcjZsZTNWSG1ManBZQ3NNbXpZZndvcVpn?=
 =?utf-8?B?QzZIT3FDU1lwKzNwV2thWGpGQ2psSkZMUUZBM1BwR0tLdHllR0hzSnZrVzRj?=
 =?utf-8?B?aFBISStXaGwrQk1xN2c0dC9LWTYzVW1aU3NZMy9STkJMekZ1VGdIM0twQ2dH?=
 =?utf-8?B?NlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d66707ff-1dcf-4721-071a-08dc6dae86dc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2024 09:25:53.7546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KBcMeVo6QBxSQ0QBJ4J53xhz7T2gbC/GlHwqIwhFKtlwzs7NOPS9g1Bnm9kb7k9hFW8oiUuF9u3QybH9ykk+ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7248
X-OriginatorOrg: intel.com

On 5/2/2024 7:23 AM, Sean Christopherson wrote:
> On Sun, Feb 18, 2024, Yang Weijiang wrote:
>> @@ -2438,6 +2460,30 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
>>   	}
>>   }
>>   
>> +static inline void cet_vmcs_fields_get(struct kvm_vcpu *vcpu, u64 *ssp,
>> +				       u64 *s_cet, u64 *ssp_tbl)
>> +{
>> +	if (guest_can_use(vcpu, X86_FEATURE_SHSTK)) {
>> +		*ssp = vmcs_readl(GUEST_SSP);
>> +		*s_cet = vmcs_readl(GUEST_S_CET);
>> +		*ssp_tbl = vmcs_readl(GUEST_INTR_SSP_TABLE);
>> +	} else if (guest_can_use(vcpu, X86_FEATURE_IBT)) {
>> +		*s_cet = vmcs_readl(GUEST_S_CET);
>> +	}
> Same comments about accessing S_CET, please do so in a dedicated path.

Will change it, thanks!

>
>> +}
>> +
>> +static inline void cet_vmcs_fields_put(struct kvm_vcpu *vcpu, u64 ssp,
>> +				       u64 s_cet, u64 ssp_tbl)
> This should probably use "set" instead of "put".  I can't think of a single case
> where KVM uses "put" to describe writing state, e.g. "put" is always used when
> putting a reference or unloading state.

Yes, "put" is not proper in this case, will change it.


>
>> +{
>> +	if (guest_can_use(vcpu, X86_FEATURE_SHSTK)) {
>> +		vmcs_writel(GUEST_SSP, ssp);
>> +		vmcs_writel(GUEST_S_CET, s_cet);
>> +		vmcs_writel(GUEST_INTR_SSP_TABLE, ssp_tbl);
>> +	} else if (guest_can_use(vcpu, X86_FEATURE_IBT)) {
>> +		vmcs_writel(GUEST_S_CET, s_cet);
>> +	}
> And here.

OK.



