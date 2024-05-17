Return-Path: <kvm+bounces-17581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F1D778C824D
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 10:05:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 206C51C21F83
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 08:05:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 005FB1B809;
	Fri, 17 May 2024 08:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kqV2Ly7V"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429C417C69;
	Fri, 17 May 2024 08:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715933093; cv=fail; b=Ib8v4vkCoeSZF1iD1cVFM44yCX+z4/wab/FiN9IQLJuy4noOWtCgG2H4DN9xQZBWVnWZxBmcofoBef4YNNXgMIfmMwQlKSLu/7496khzHlBohaO6+fjSApHRMZ46v4LNuL8g8mTMFqOwxY1Xu7FcU6ZSVBi9O21WpIs9Eu8+Lek=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715933093; c=relaxed/simple;
	bh=67T6mnPrL73n+ISU5Ouf4M4u0PgKvs9cIA4hAr5Jv7U=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YzzO+2zF9jjuWwaAPuEBejaQ6zXC5TCZZuBNfauj3UET44gdk4ckx69MP+gByRQ1RoG+8jOtOxlsEaVr6A6Elkdt+3+W9Jrtbaaqgrk1buj8mxAXwj5zZubE0VQOyGx+zcJiN9aCZahtTYwbwVokARHbbWvqyZEvcPWKFVWVxiw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kqV2Ly7V; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715933091; x=1747469091;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=67T6mnPrL73n+ISU5Ouf4M4u0PgKvs9cIA4hAr5Jv7U=;
  b=kqV2Ly7VYQinM/3HsPel6i6ExLeNeYNaoTPe9Vau28VFyntQ+rN+/Szm
   5pVP94HKBDBVfTcrzmpjint58wqopjbTWSE/c04s1bBv8vj1cMYs1IvNo
   0PByUZwFOUmpr2elQVCUdegT9OE/4xrhwrKuMDHcKDvqO/P6Vr+IFBN2B
   GELFIIVqcqK5EpadgwW56b6LEX1lVmgSDRkiNI4PQUCaJh6U6/Uvb/O81
   MU/p2ags8hcHt3dP+gutNBD8cXi+456HCG3M/VRD1TnPrTfgH9hXm5UGR
   vXTm/tTf4o/pAYnHVHK8EduXbgwBEF5Lh+/J9swFeO5/YvjRtXKt9wZNF
   g==;
X-CSE-ConnectionGUID: Khzn4cRZT4av8EWjUP/3jg==
X-CSE-MsgGUID: 5OQmaRTwTPuYYro+a5WQXw==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="29596783"
X-IronPort-AV: E=Sophos;i="6.08,167,1712646000"; 
   d="scan'208";a="29596783"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2024 01:04:50 -0700
X-CSE-ConnectionGUID: iRU+p2AASXqVttvwyejIcw==
X-CSE-MsgGUID: Q2g0brAGTJSx23YBG4PFfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,167,1712646000"; 
   d="scan'208";a="32129274"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 May 2024 01:04:50 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 17 May 2024 01:04:50 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 17 May 2024 01:04:50 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 17 May 2024 01:04:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZD9RwrRD5NcI/GvmHbItamHzqxz6hhwIQULsr3gKDLHCFnc6q9Vjn1rpphDJ3rV0Kc4id6oUj07hgC77RZDai0+qBKF4XVlWf+7cfFcFTl8A2LTaT55n6gEPwmtHS/vmt9yO4QvmtxrOVeJDvibRKQbRSDa/UoFDx8vgV1lQ8rdqhmn8P5yZfyBkd2hh7MkTWbR+ow9Zr1ym9GjkpXkHp7kYdt2Eb6UP/u6SihFs1DQEK4a1/3/TnKI8h/r2q1dQ/nG921QAG6RqjIQ0x/XqT16jBXZK3voO6KKSplWTcmatGymIXrAATW3NIxAKlZL2EHazuC41QrsOhXV8aNvs7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wOj8ZYrs2VB6EQoIj+DzuccOwxl3xW/f5KnXC75te7Q=;
 b=TndxmeG+Uoindl5KqRRFGWCfTpnk9w/QhU//IZWuGf9G8joV856Y0EZn/UNflxMJmOXyDY6Q3dZBmt0VMsnpUzD2RL/eEzbUbvW1TN8G+ZUCwydEBlIMaNRYBellI2nXHVt31c5L9GsXD2uh4SWB3IXfRbGyj8N23KtB4ZS5FQe3ClnQXuRr/Xi4qtbHskSf93YfbNd4YBFF4xNaj02Lirf1s2Xce1jX1r0ZFnwUYoWrTGpVIGbQZ7o+mgkmpjh2XUa7anDQdo55fzWmj/nGaY50BXKFeP3NeLqmmPw1BEsc1YjLYHcvW9P5HuDkS516TJzPTmhavf4g0hLYXaxHSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by MW6PR11MB8365.namprd11.prod.outlook.com (2603:10b6:303:240::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.26; Fri, 17 May
 2024 08:04:47 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4%7]) with mapi id 15.20.7587.028; Fri, 17 May 2024
 08:04:47 +0000
Message-ID: <f80b1b68-fd29-4fbe-bcbd-782932432937@intel.com>
Date: Fri, 17 May 2024 16:04:38 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 24/27] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <dave.hansen@intel.com>, <x86@kernel.org>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<mlevitsk@redhat.com>, <john.allen@amd.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
 <20240219074733.122080-25-weijiang.yang@intel.com>
 <ZjLRnisdUgeYgg8i@google.com>
 <83bb5f3f-a374-4b0e-a26d-9a9d88561bbe@intel.com>
 <f77496b0-ee94-4690-803f-44650706640f@intel.com>
 <ZkYbdaW-2p9wHwEL@google.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZkYbdaW-2p9wHwEL@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR01CA0007.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::11) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|MW6PR11MB8365:EE_
X-MS-Office365-Filtering-Correlation-Id: 8cbb0d20-9d4f-4c0b-a463-08dc764804d6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SWw0aXZMMkZHL1d3a1JlZE1zRytlKzNaa1NMVVdnTU5kZmJoT1JjM2Y3MmFE?=
 =?utf-8?B?VEl4R3pyRXUvQ3dUWDdjNnRjRWhYUFVNS0xaUUJrZVlTdmc5S0tHN2FwakNi?=
 =?utf-8?B?VVUzdUs2a1E5SXp2ZjRxUTd2bktrVmQ3NUtza3lvQ0xPdzBZRWdVZ1p4THBi?=
 =?utf-8?B?bEFBMnFFSnhwL3FHMGhBdTdja0J2cXFNbkZWVWZPRnBWUWFQV2FpK2tVZTB4?=
 =?utf-8?B?ZFNvcFd4TzAwUFV1Tk9CRUlObE5MZ0Y2cXN1dzhrYVZNWWpUS2FldlBCL1hz?=
 =?utf-8?B?U24yNnZZUUJzQytRSzJaYXMzUHA5SnE1Z0YxK0lmZldnQmZ3bk0vZ0h1SEc1?=
 =?utf-8?B?UGpyR25FZXpxWmkwODJLdllsYnlhY2lualowL3BPNlY5OWV0QVRyYWRVVk41?=
 =?utf-8?B?MW1nVVh4eVgvcmFHQnlHc3RBbW16T0pMbDQ3blVvRUhNRGYvK1dlQzY5YnR1?=
 =?utf-8?B?Si9IZjNCUGxQQlFpRjJyQmFRTU1nczJtVnNubHN0Q2laY2Z4N1d2YzRaUlhR?=
 =?utf-8?B?c0lGZ1dRRnVnNkRqQWhIS3R2WVRTNFpLcXJZMmY4aXlBcWVWZzB2dkppRkZM?=
 =?utf-8?B?ZEpTbjZFS203Y01YOUJrSkRqaU1raktJSEg0QVJHeW1jYzNJSWlnem5TSUhX?=
 =?utf-8?B?WjJCdHFxTGRuSkZ4empsRExBRDIra0lySFZxbEVlV0FEalZYR0JtaEJhQXp6?=
 =?utf-8?B?ekxIajIweUIvK3h4Qm50R1RxWC8xR09Jem1ZbFY4bHdUZFFwb25LVldnQlA5?=
 =?utf-8?B?ZGxkVWpUYVhpcllMWmdnQkVzSFZoS2Zpc2ZlTWIzU21tNUVmTFc4KzB1M0pw?=
 =?utf-8?B?alVEdXdLeS9PVzB6b3F0aFZGeExlTXh4bFV6TENVMUxvRUZlZWNCVk5jdmI3?=
 =?utf-8?B?ck5PaDR1Q3FqdDM1akp4M2NtWVM4UThSb3N4RUcvdkh3ZkR0UjA2amlKVlpw?=
 =?utf-8?B?NUwzWXZvb3J4bmFMOFVzQjlGdklINEdoRlIyc1V4N1lCekRhSEhLa1lhSWky?=
 =?utf-8?B?VCtWYmFUTHVkK0g5cVo3ZmF6QlZrNDlhYUgxUUlxdm9oMi9yQVpVN0NvTk5y?=
 =?utf-8?B?M0JDZGtxTzFSeUdGNllHRERrM01VWE1YZU5qK0FZNWc2RUljVkZPRmdCUkt2?=
 =?utf-8?B?Qk1BM2EyeXgrMVN0WTByMkNqak9nSWlDRHRvcVRMQjNvWmZHK0c0UTdvZlJM?=
 =?utf-8?B?d3dNTy9VWjhzakhhSmpsellteExtbVZJUlJJNC90Y3J1UGI0SjRkN1dxdnRp?=
 =?utf-8?B?M1VyMW8yWUFLWUc2OHVxS2lENW5PclFxcjhLSUY4d1dmQk1XOVBXb0xETytP?=
 =?utf-8?B?VDQvVzdtL0J4SjUzQUFLb2RBdFlKWWl4VWkyZmNvRXd5ZkVlNWE1VEJ4aGZY?=
 =?utf-8?B?WFdUUlNDb1N5RmNGZVBxSVhPTmpKLzRmT2s0Ry83cHRxZW1CTHhPUXYySzJx?=
 =?utf-8?B?bHV4UTFYeHl5d3BFZ2Z1TGtVNzlUYnRMZXYwZjZXSFYyVGdOcHhmbGRLSWt0?=
 =?utf-8?B?dE55L2piWHdOL0RwYnBDRDJZRVdmNllaN0Z3eU5nc2tQZ3JCS29iMEpabGtI?=
 =?utf-8?B?cGcrQm9ha1dLU0NzcDJOU3kxTVJ0ZGs1UDh2M2o5VDUyUTFRclF2WVhxT29z?=
 =?utf-8?B?aEc3WTBQTDJRbjMreC9jaHNQMXZ5WTJIY0ExY1Z6UkVYbGswSlZtVDJLSGk1?=
 =?utf-8?B?RGh3RWxBZUwyN2R6YjFGZDZaWGRFWFJDQzBuTzR1RzN1dHdHcENCUWVnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U04zT3JSN3NrRHBwak54KzQvZ3pxeUR1SjhSakFBYUhPRGhCQUJ0dmNHYklX?=
 =?utf-8?B?VWhRLzRKQldUKzF6bnV6dDYza3JGWVhLZmJFZUhFTytnSnR3Qm9rTVdNQlhk?=
 =?utf-8?B?UFI4RGdpZlRnS2NNeGx2VUhYcm44SW5LMnJ1RXVJOWM1Wkx3N1A0dEhocjc5?=
 =?utf-8?B?a1licElGaHh6eU8wWHpidklQYjFpRFVYWnpLb2t6WjhDdnZZaGUwLzVDTVov?=
 =?utf-8?B?dXBBQWJkK3hsS0dIa05rQ1Z4RldsWGViUnZLOFRlY29SaXZrTy9IT2Ywd1c3?=
 =?utf-8?B?OXRHRW1vbWtyc0RFME5UQThWYXhqdFRKdzZzVEdWK1ZTY1hnVFVob005dVll?=
 =?utf-8?B?SURZK2VBWGhLbTNoaXdRZlY2MC9NTDkxOVVOS3QvbVFHRmJDaUw3b2pFcnNp?=
 =?utf-8?B?ckhTVXRJZFBwaTh1VXdML3VzQmpDaXpiNUVtSTR6RkF2Q2FKeXpBVVFmUWRJ?=
 =?utf-8?B?VEZBdGxVNVpDb3p1T2xxd09FQnQ3UE43MXQyV2ZxcVExU2dSajQ4bUV4WGJW?=
 =?utf-8?B?OGIrVjdORFRlT29pR2J1c1dOdC9lSkE5N0luMkJ0VTJaT29oVWVEVVlFQmlZ?=
 =?utf-8?B?K1FvTlgzRnlrWEgxZE9JT0VoekRnM015a1NYcmRQZGthZFJlclVYKzVLT1F2?=
 =?utf-8?B?REluUkI5UUNXOUxFVE5LdE9tR3oyVncwRmpzL0VaM0sySXlrMHpsMnJkekNl?=
 =?utf-8?B?cTl4dGlHRUt6WlFmblBVcis5SjlOYmJJMjR2eHVodXdnb2ovcWRsMm5NSUph?=
 =?utf-8?B?aFhZUVNPeEFLbFZ5YmRoV1VVV1FWNTBoUFErVDZGa1BUaHovL1hkWGdxYk1p?=
 =?utf-8?B?U3MxR2pwdmNpaWZSdUdZK2U1UExFNDRVZXBjY3pwaS9ZU2YxclNMd1dCS2pX?=
 =?utf-8?B?b1ZsNFVYVXJnVm8xSUV0cUxiTkpoQ3JiMVhqME4rQ3hLUXVBemdob2RlRVRz?=
 =?utf-8?B?SnlwSm43T0g0SE9hTXMvYnVFaXV3Z2t3MFBVSi9vc3ZGWDBpSGhaOXpCYXkr?=
 =?utf-8?B?YTV3eEQ4d3VxNHBpd2VydW1adGhDVitvTkQ5VkgwNEUyZFFGZDRRaHoydGtl?=
 =?utf-8?B?NU1CMzBNOHUrYmY2ZXpzZExmNVVQczFWRWthWHpGQVo1K0orUDhKMlVhTHdO?=
 =?utf-8?B?VGo1WFl6eW5IbklndmhiUHpyQnVUOUpreWEyQi8ySE5obExlRzB5TWNkaUd2?=
 =?utf-8?B?MlFxakZGTTZ1ZkNRZlhWaG9QbHQ1UXhSdk1rMU5waUlBUlBkYUtVQnptOGlk?=
 =?utf-8?B?ZXhBdG5JQW9zeUtWSy9mK3JTWnhxWS9jUmlrTUwvUGVhYUlDQUtITXBMRFdV?=
 =?utf-8?B?eDh3ZGFCZW5yS2gvMm9CSDFHODlOa3VFYjJ3SEF4SUpOaWFoS2hQbGF0c0Jo?=
 =?utf-8?B?R0twODNwVHMrNUs5M3hSaXdicVoyenlOeVRodHBDZlF1RFBrbDVqckVVVTFh?=
 =?utf-8?B?OW4wa2NJa2YweUdJNXgvcUc1NzFITi9kbUszSFNsWGFNamllZFpnVk1tb1lM?=
 =?utf-8?B?eEJNWnNHamxoSVNRTVFadk9QVlViQW5QSGY1a0h4SWsxSTZRQVczUytOcWZ3?=
 =?utf-8?B?NWEvb1dWM1I5OTZyRVVYWWNNb1lwdWtjNGd2TzVhWXoyTHIyV2tiZEdpMjVt?=
 =?utf-8?B?ZDZwTHRHZElxcEVMK1pyeVg4UVJmL3NXVkpGSFlZbTh0VXBCdE1ESExqUEJN?=
 =?utf-8?B?VFd5OWN1ZU5WOHQwTnNXeEJMa0FVZmFPc2FybTVGN2tBUnU5enFpZUNoL1JU?=
 =?utf-8?B?YkpUUC96VUM1Tkhtb1Y0YTMwVjhDVm1DRVcwaElnZWtwcVJTbnJOanZEN1l1?=
 =?utf-8?B?OFRoWDdINnJtYkpoUUdvYnJPNUs3QmlTTUR1U2huRHR6SFdXalJ1UXc5cWJq?=
 =?utf-8?B?OVBBZE5JVjh3S3dOeHAwUHdDOTNhRUg3MnlYdEZjWkllWUxvK2xWbm1UUEd5?=
 =?utf-8?B?SmNYVHgzQUwvOUZ1S2w1TXRaYjk2OTVvdmhkZlcyOFR4Y0lhUkZnMndjcXUw?=
 =?utf-8?B?K1RDdmdQUFlpckloQUk3ZXlKWkg0OFlYUnhFY201RU80azBYRU82aE5hUU90?=
 =?utf-8?B?Y3h4TjlMektsVnNMS2sxejVwejdkZTJpYTE3cC9kbmpiTXVaZFZUb1NSRjlR?=
 =?utf-8?B?VmVjTG9wbmJsT1hhK3h6d3FneGNyU0ZVOVFiTVNHM1ZBenpaa1d6N0VmMkpv?=
 =?utf-8?B?SFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cbb0d20-9d4f-4c0b-a463-08dc764804d6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2024 08:04:47.4389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5j4VB/8CDTZE09ySQE7TdsvbzgOWC/CBlZRFQo7Z06X9MiOPb/+F9QDuwkH+HceWC6O3jIEQt27rIyn8SibzbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8365
X-OriginatorOrg: intel.com

On 5/16/2024 10:43 PM, Sean Christopherson wrote:
> On Thu, May 16, 2024, Weijiang Yang wrote:
>> On 5/6/2024 5:41 PM, Yang, Weijiang wrote:
>>> On 5/2/2024 7:34 AM, Sean Christopherson wrote:
>>>> On Sun, Feb 18, 2024, Yang Weijiang wrote:
>>>>> @@ -665,7 +665,7 @@ void kvm_set_cpu_caps(void)
>>>>>            F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
>>>>>            F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
>>>>>            F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/ |
>>>>> -        F(SGX_LC) | F(BUS_LOCK_DETECT)
>>>>> +        F(SGX_LC) | F(BUS_LOCK_DETECT) | F(SHSTK)
>>>>>        );
>>>>>        /* Set LA57 based on hardware capability. */
>>>>>        if (cpuid_ecx(7) & F(LA57))
>>>>> @@ -683,7 +683,8 @@ void kvm_set_cpu_caps(void)
>>>>>            F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
>>>>>            F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
>>>>>            F(SERIALIZE) | F(TSXLDTRK) | F(AVX512_FP16) |
>>>>> -        F(AMX_TILE) | F(AMX_INT8) | F(AMX_BF16) | F(FLUSH_L1D)
>>>>> +        F(AMX_TILE) | F(AMX_INT8) | F(AMX_BF16) | F(FLUSH_L1D) |
>>>>> +        F(IBT)
>>>>>        );
>>>> ...
>>>>
>>>>> @@ -7977,6 +7993,18 @@ static __init void vmx_set_cpu_caps(void)
>>>>>          if (cpu_has_vmx_waitpkg())
>>>>>            kvm_cpu_cap_check_and_set(X86_FEATURE_WAITPKG);
>>>>> +
>>>>> +    /*
>>>>> +     * Disable CET if unrestricted_guest is unsupported as KVM doesn't
>>>>> +     * enforce CET HW behaviors in emulator. On platforms with
>>>>> +     * VMX_BASIC[bit56] == 0, inject #CP at VMX entry with error code
>>>>> +     * fails, so disable CET in this case too.
>>>>> +     */
>>>>> +    if (!cpu_has_load_cet_ctrl() || !enable_unrestricted_guest ||
>>>>> +        !cpu_has_vmx_basic_no_hw_errcode()) {
>>>>> +        kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
>>>>> +        kvm_cpu_cap_clear(X86_FEATURE_IBT);
>>>>> +    }
>>>> Oh!  Almost missed it.  This patch should explicitly kvm_cpu_cap_clear()
>>>> X86_FEATURE_SHSTK and X86_FEATURE_IBT.  We *know* there are upcoming AMD CPUs
>>>> that support at least SHSTK, so enumerating support for common code would yield
>>>> a version of KVM that incorrectly advertises support for SHSTK.
>>>>
>>>> I hope to land both Intel and AMD virtualization in the same kernel release, but
>>>> there are no guarantees that will happen.  And explicitly clearing both SHSTK and
>>>> IBT would guard against IBT showing up in some future AMD CPU in advance of KVM
>>>> gaining full support.
>>> Let me be clear on this, you want me to disable SHSTK/IBT with
>>> kvm_cpu_cap_clear() unconditionally for now in this patch, and wait until
>>> both AMD's SVM patches and this series are ready for guest CET, then remove
>>> the disabling code in this patch for final merge, am I right?
> No, allow it to be enabled for VMX, but explicitly disable it for SVM, i.e.
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 4aaffbf22531..b3df12af4ee6 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5125,6 +5125,10 @@ static __init void svm_set_cpu_caps(void)
>          kvm_caps.supported_perf_cap = 0;
>          kvm_caps.supported_xss = 0;
>   
> +       /* KVM doesn't yet support CET virtualization for SVM. */
> +       kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
> +       kvm_cpu_cap_clear(X86_FEATURE_IBT);
> +
>          /* CPUID 0x80000001 and 0x8000000A (SVM features) */
>          if (nested) {
>                  kvm_cpu_cap_set(X86_FEATURE_SVM);
>
> Then the SVM series can simply delete those lines when all is ready.

Understood, thanks!



