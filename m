Return-Path: <kvm+bounces-17572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3703F8C805C
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 06:27:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D37F1282999
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 04:27:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AAD4C15D;
	Fri, 17 May 2024 04:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HIvlcR4J"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC014BA39;
	Fri, 17 May 2024 04:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715920035; cv=fail; b=bzIamCo2+2eba1Luo7Egm/9KKGFY//hkks9qInmFAafSb0tWquEcg/xTubE4PgYuRwevHaPLWGJ5IdEVcALvT4Fw6jlCFLdHlqBVVmFmsJOrGc2+sg5MzUEbe9I/5TF6lPY6eUc5Qy7cJRHktxUXNRiBk8xBxggO7hDyYsvvHvA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715920035; c=relaxed/simple;
	bh=9ikC6Q6CdOnMg/JlWeUuyEnE+reWQ3uQWw/OqeGdM4k=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JPTvrozu6xsU+vGsICPUOWTZg7LCa41x6YeYVuZShtd6ATFIPCUtYuXUEZqQQwkyUaIeL1kz7yKxt67nuygqrZi8TW+ct+reVZyJa0o7W+E8DRV0VL3IMX83drRjObuN7v1gWgb0xwEp8Xo40qWnt8LUNttqIV54F4ggMbftDz4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HIvlcR4J; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715920034; x=1747456034;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9ikC6Q6CdOnMg/JlWeUuyEnE+reWQ3uQWw/OqeGdM4k=;
  b=HIvlcR4JQ6XtZlVHcIN38bkUkVBBv93XxXDgtQDbNBei3RafDx6eC1EX
   SeRdsGySqtxtdheiMeGQph+i8cr12joNPgVXunZqOVBHHZKgIaGAVChbw
   cd+XN4C00b5fdQIBUlbLEnS0iJzdw4bL8U0GQL1zIqgNQKIz0BLv5DnbX
   6h7K8aFf27GUeFAJ1/gilmHT33l/j7VygyocoLS/nvbdRdqwTNN0F6laV
   nv3QX7M71oj3r9rljNVt+f/CBaTDiHwlIUMjzN7/zqVicxDmy0HicZbge
   KvPs2JovUUUtiKU+43xXE2OVA5h/4ZOHqzuAJNlWHTT73Ei6JJv938M+5
   A==;
X-CSE-ConnectionGUID: qOttc9ZlTHmyof7809Zo+Q==
X-CSE-MsgGUID: nn2TaDYYQnu7jPvjOFbjAQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="37456978"
X-IronPort-AV: E=Sophos;i="6.08,166,1712646000"; 
   d="scan'208";a="37456978"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2024 21:27:13 -0700
X-CSE-ConnectionGUID: yrChIIs+RGSbuDU06j+LUQ==
X-CSE-MsgGUID: qyqjt6zzQomef/wotS3Nwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,166,1712646000"; 
   d="scan'208";a="31667509"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 May 2024 21:27:13 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 16 May 2024 21:27:13 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 16 May 2024 21:27:12 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 16 May 2024 21:27:12 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 16 May 2024 21:27:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cESND1nvbSzdvql0hZfWDp4QZxi9A2iDedavxQCCuXbDppl7CcarZVzcbsTrWkPJ747u4CppHb3g60U+YhYl6sjodnaCJ2bSEk1joX8t4mJLYgknyvKjtjlOP6Ltv5sidb4PpFsomYpOdZ1QeRhpc0pJD5CMeQk9jSdJGpwSHRLfwfyiMyqgbCiTHmEs+q80T6ddSBsnRneAKTEBt3kLRcFdK/2LdGhG5qCaomQH6Rmfe+8qkBLB8nOwP9losSAPd2Pn7Ar+dPN9HrdKcmqem4m/kO9KK5Pp30H/9J8HlA+0J2rETYWP8/sgjI8/gIm89oREOnzs0YiMP7T12FqX8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fk3hjIV96zTIgtSmuAzXPooxlUoPHnfDfuEyVZDsfrg=;
 b=ObcOWvxqKl3xHfLC+1KtRHX0Enzy5LhqqF2vuD6wA5crQpbnwpvYigQiq2fKVhEtDyHR5gtCCwcdXekTub+QMer6NddPz/Vrlbb165y9kYiSPkT/YqaXo7M6LJrbZfHl2vT/e6wfiXGanMKm6ybBnNsSA/LSqaGMQQXa4htnaVyAN2GL1pb6/diL3HVw/yFNmXUJ8vAIVEgRK4O/fvPV3s6AVJKoe9Xs6+a1fU0V51CMbcKDP57zA1t70fY9lhvrF7/vx9EwPpDirXnFhZLY0z/K5E1Il9nYawJbUeQABhq5WJ12k3ywYrE5XZQBXbMxH8klDQdmZP00p0iUXcAA6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS7PR11MB7783.namprd11.prod.outlook.com (2603:10b6:8:e1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.30; Fri, 17 May
 2024 04:27:07 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7587.028; Fri, 17 May 2024
 04:27:07 +0000
Message-ID: <e31f0793-c939-4018-9c3b-041aa8800515@intel.com>
Date: Fri, 17 May 2024 16:26:51 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/16] KVM: x86/mmu: Add address conversion functions for
 TDX shared bit of GPA
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "sagis@google.com" <sagis@google.com>, "dmatlack@google.com"
	<dmatlack@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Aktas, Erdem"
	<erdemaktas@google.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-5-rick.p.edgecombe@intel.com>
 <9f315b56-7da8-428d-bc19-224e19f557e0@intel.com>
 <307f2360707e5c7377a898b544fabc7d72421572.camel@intel.com>
 <eb98d0e7-8fbd-40d2-a6b3-0bf98edb77f9@intel.com>
 <fe9687d5f17fa04e5e15fdfd7021fa6e882d5e37.camel@intel.com>
 <465b8cb0-4ce1-4c9b-8c31-64e4a503e5f2@intel.com>
 <bf1038ae56693014e62984af671af52a5f30faba.camel@intel.com>
 <4e0968ae-11db-426a-b3a4-afbd4b8e9a49@intel.com>
 <0a168cbcd8e500452f3b6603cc53d088b5073535.camel@intel.com>
 <6df62046-aa3b-42bd-b5d6-e44349332c73@intel.com>
 <1270d9237ba8891098fb52f7abe61b0f5d02c8ad.camel@intel.com>
 <d5c37fcc-e457-43b0-8905-c6e230cf7dda@intel.com>
 <0a1afee57c955775bef99d6cf34fd70a18edb869.camel@intel.com>
 <9556a9a426af155ee12533166ed3b8ee86fa88fe.camel@intel.com>
 <d9c2a9b4-a6b8-4d29-9c22-ebdce77f3606@intel.com>
 <240f61b5da5015a8205de414a87c3c433b1c09a0.camel@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <240f61b5da5015a8205de414a87c3c433b1c09a0.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR06CA0229.apcprd06.prod.outlook.com
 (2603:1096:4:ac::13) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|DS7PR11MB7783:EE_
X-MS-Office365-Filtering-Correlation-Id: 0919bd50-c268-4dfd-bbd3-08dc76299cbc
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MURKU2JZRHpEWk0zTFF2dGdJOXk3ODhDUjVHdG9CKzNvOU5ZK1lUeGtBb3Vi?=
 =?utf-8?B?cVkvL0lmNnQvSmpwNjlvVlVINEZURS8zWHJXa1ZDSE9LTzN4VWI3cys5bEUz?=
 =?utf-8?B?c3ovTW9abVpRTGZ0bkEwK2FhbnE0RDU0MEdWQmVZOTltTGp2WmtwaGJwZ0Rv?=
 =?utf-8?B?UjY0bHlYclBRRENBMDlRYlYwOE41UFJMZVQ0Z0MybVpoeE4rVHg0aFp6TllW?=
 =?utf-8?B?M2VINVg0d21uOTlEekxBUmtVYjk5aldCeDNpRTEwT1pFYm1WbFcxOTM3R1hG?=
 =?utf-8?B?bk1TaVFYZUNKV0tsVnJTSk5CcjFBMldvUWsxSEhUTkkwWU8wWXIvRXRkSm02?=
 =?utf-8?B?bEhnaXVJVXVXVS84NWxkT1JKMUxzNnJrZVdHLzdDVnNMdndYVHhXbkhtYWd5?=
 =?utf-8?B?bzMveHRiQ0FJZXYxZndJODA3eS94V1BYZjNaVjBaRUlla1U5NG5GVWljRzFX?=
 =?utf-8?B?SE5JNTROSnF5ODhDcmdnTnRYNG1DN21vTURiTGtTME4wTHllUDJjak1UVWZC?=
 =?utf-8?B?a3V5czZvbVNQNThHdTdVdUM2OTVoRU0rK3BJRkJPeFlReVpjTk9mTm1XeFNW?=
 =?utf-8?B?TnJRdVJ3SHg2dUJibUcrSzVlTVFGbzI1a1RmZGcvWWNKaUhKRXhVNWMreXo1?=
 =?utf-8?B?aTJsL3FEek4rbktwUWxVcUNSZkY1ZkYxYzBZV0FzSnUvbDFZWlNSdHJFM0Iz?=
 =?utf-8?B?a2cxeE5GQVk2SWY0cGg3UW9FU2FrWitsYlBxT2EvRU4rS1oxRGtRQkxGTVhE?=
 =?utf-8?B?ekoxVTdaUFJaU0pPSEQ2aXFmeUpjeTIyNU83bUQ2eWRxYlVzeEJWT3NYM2lB?=
 =?utf-8?B?aG12Q3lKUUdDUlIvcUVZd0VhNm81VXBxUFdPWXAyOHk1UTFCK2p2eml1OEdi?=
 =?utf-8?B?MHFUYjhVZVAzeldLZ0QxNWt1Wkg4M2s0NHYveldvL1doMDNsTnF6eitablhP?=
 =?utf-8?B?RU9ZZzRlMTZMVjgxRDlyNUwvM0FUUzU3R21oZlRxOTlNVFVNY0hHR0Mrd2FK?=
 =?utf-8?B?WURLUWhBZU9tck1UYTJRVmhta0Zhc2NKbFE2M2pVd3pMTmJML2tyK3ZycnpL?=
 =?utf-8?B?dlEwclRSS0FvTFUzNEZ4Q00xWmJ3aXp4RUtBOTJMb2QxeXEzVWpXZVlyS3pk?=
 =?utf-8?B?Q1FXUDZnNnVnMnJ6SXc5WGdTb2xHblpZZFFDT1EydHpKcjFQV3kzS2lIMVZh?=
 =?utf-8?B?a09CNHZ4Y211SFhJRGVJa1VLZXI0Q1VWQmFrODhPZ2s3WXpGTlRsM2dLc0pF?=
 =?utf-8?B?aTFEektQZU15WFhPRTBRc2NFMHN5ZDNHeE4rdytoeXNpaEtzd0NwZmowUEdT?=
 =?utf-8?B?T3Z2M25aLzhMdjZRazdoOTdnbzYrOGsrZDZOUHBjd25TYkpqRHB6R3lEUzVP?=
 =?utf-8?B?dityeWZHU21KcmF1TFVPNnhPVy9ZNDhaeFIrcW9BaXNDMkZKNkRNV1M2Vk4y?=
 =?utf-8?B?SlRFcHVzMDdrT3Bzdlc5UWJBNW11ZXZ2VFpZdUZDWVd0Qk1JdWh1YTRFVWJH?=
 =?utf-8?B?anhjaUNEdmFVV1ArenV4UnA5YUtpMjhWSHZjT1VVckpVWXlwd2NFcWZoN0xI?=
 =?utf-8?B?T3pEb2ZxL0lvbFd4OWxmTVZRS3pYbFQrOWV1MjJ2ZDh4cGNWN1ZKL21HeUJE?=
 =?utf-8?B?L3JsM1I0ZmdIMXNTYllVMlhkQUdmaGFvdmJPQmh6L2t5dmRDaGlCSE9ITzZq?=
 =?utf-8?B?Zy9hN2p1VGtIVWhzaDk4eEF5akR1TGFXbS9FTlhmKzE3d05jY3pmcVRnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WHk1NUoyd3lRaElraFZiSXBPd1hDQU5iMWhTR2JPL3ZDY2RwY3FtOGQxMU1B?=
 =?utf-8?B?Tm8za0ZvRFd6T0wwaUlNQjB4cWtSY09iTTlCdUxQM0tYWHc5MlE2QVpleVVs?=
 =?utf-8?B?WHIrdExDMWY3aXV5QzR6VUhBY2NOckl4cHFGdEdJc1N3bGs1VEtGdlFURDJF?=
 =?utf-8?B?K0RMSDBMWjlMSHFBS3lkd0I3ZzZwKyt2cWNJbXpuSjRXbnEvdkM3VkNhZ0hm?=
 =?utf-8?B?Z1U3YmpKTysrRUxEa2xtaVY0Y2pkdC9xZ2VMNnNtMFFhc25zUnpJMUhCVGs1?=
 =?utf-8?B?VStNUmJGVmpoM0pKaVJsRTlEaVVyeFI1d1o5U044UjEyTWd0RHoxUVVLckhx?=
 =?utf-8?B?TEpXeVBOaXRucFBvMVhzZi96RE52N1NHeXhuT3gra3d3dSt0OGtMSFR1cXh3?=
 =?utf-8?B?OXQ2djE2dUhzenpubFQ5aUZHQTA3b3NFUGZGNllxWVVxV0ZOUm84dHlvM1JF?=
 =?utf-8?B?bG44NERuUmpwSnJaWCtVVkYxUUhRaEJ1WHY3eVNUUGNraTNhMGNZRlYyUXlt?=
 =?utf-8?B?VDkvc2haeUU0bCtQMDZWT1Z5ejR0VW1UWDBKKzdDZkh6NVpoZ09yM0Ftbjkw?=
 =?utf-8?B?Q1BuSnRpTk51OWpHUEFDQWozb2JvZ2hZVkYyanR2VnFpL1ZidVdkdjJQSmls?=
 =?utf-8?B?VHBsVFRabDJKZUhRNmhOckNhRjdQZS9RVmtLYUNNTGZiV2xvaWdFZGxSM1VB?=
 =?utf-8?B?QWM5Wk14SFVMYnR6VTFDc2NQbC9SVU9ESGVGdldMajJITUw1NGFlcWFxejRS?=
 =?utf-8?B?M095dHpUNHlSTTJUNTJuT3FLQThWY0crSGM1MFdHaHlxVEZsd2dZZWxJWUlz?=
 =?utf-8?B?YThVN1BkaEQ0SkhueHFOdm9qekxQRlRGTTlOSVdCQW1FSzc3ajV6bDdsUXh2?=
 =?utf-8?B?TVlndTNuRHpRSFNOMWwxT0tXVmtDSktVV255N2F2VlpoTEU0WkF5QitHcjhD?=
 =?utf-8?B?U3lHbXRpeDZpZnUxNGlRZkZtOVE1eHhoV1drdW1XbW1qZkpWWmxCOWJxL3BY?=
 =?utf-8?B?K1lFUUxZSWNia3hpdDYxYkpWaFZzV3F6MFJ6V3RlSHpjY2xrOVE3bFRzMmVr?=
 =?utf-8?B?VmY2WnRXLzhUaTJGazBuWXJUSnJSajNNcitwMnFoaTBoQ2dYZ3UvTkZCUHFp?=
 =?utf-8?B?cTlMTkxyQWMxQkJPVDlRVTluUGxtVTVmYUF5SWRJSkJwOFpWbW80TUFDZ2pZ?=
 =?utf-8?B?WDExTXd6d0ZxRnZxVDFjMDVaZEg3MjdWV2RlZWNQa1YxR1VnYjdxcG9XSUMr?=
 =?utf-8?B?WGhSTENZbTFxOFNLanlUeXVKdXdXNkIwVEJieStCSGNXMXNxakFjYTlTVjdx?=
 =?utf-8?B?cUxCSEIzVlZkQXJqc05xNm5XaWNhVDJOeTI4VCt5UllFYkw3aDZWeUFhOHla?=
 =?utf-8?B?RWZJTlBtRkdXbGlUaVJxSFJIcUVhMmJxQ1VmbktWYVpZNmtFREFVR2pmZUUz?=
 =?utf-8?B?OHBNcTVmc09pd241dUNRQnFtOGloSFFoTWtxdC9WOXVKcXJCUmxqSVVKSXZY?=
 =?utf-8?B?ZDIwRFZ4Mld1Ymo0TzFUcHFGOWF0STQyeDE1NGV6elF0eXZPL3o5N015N0Zi?=
 =?utf-8?B?OXJoV3ZJSFJTYldJUXJlTXBiK3U0bWVhMHdYN3ZGbmxOY3hCVXlENXBtb2ZL?=
 =?utf-8?B?T0ZUY3NxYVJ4bldNcStkWk44eGRFMWFCYnM3aW5oT042RE00dWNaSUhGQXR2?=
 =?utf-8?B?VEFseGtoNVRtK3hybFE1dWJycmh2cEF6UEtVSzdIaWZJcURGK2lORndCQ2ZT?=
 =?utf-8?B?NmR5YTRRb2xadUppMHF1dDErd0JKOG5ZWUlvenpTYnVHeVRPdjhkTXY5Zzcw?=
 =?utf-8?B?SGdxdXpzS014SCtjUlY2Q1M1WEFVK0gyeVFBdmoyRlErT01GeXBvRkVZeEJE?=
 =?utf-8?B?NkxMdDA5MnR5UVV5T0tLSGZkYkF2UWprY2hSZUMrR3FDN2lGZ3RJc1dQcDZZ?=
 =?utf-8?B?ajVDQkJUczk3RTVsOWx1d2ZLQVFpRVZyMVBCaVFNWUlDdC9rSVpvMklVSmp5?=
 =?utf-8?B?TGhGbWY4MHRlN0ZQd2JtcUhoU09VeGlYbkY0RGN2NzQzYXgrbG12VjlpT2FK?=
 =?utf-8?B?Znp6SXFOTXowMzBEUFlRalEySzFobmVhZncyb0JsejZoZ3M3U1ZkblNHV25G?=
 =?utf-8?Q?yp9YEfsIr89LoRFNlYFMyTPfQ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0919bd50-c268-4dfd-bbd3-08dc76299cbc
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2024 04:27:07.6268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rbRyvmY/QJ4xveG6/8xYFi1rH/t49SWfw4biFw7zVuBGJ0IUCoQJuH9O99miXmY9UY5lkMK1BfUetEqxx0jdKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7783
X-OriginatorOrg: intel.com


>> E.g,  why we cannot do:
>>
>>          static bool kvm_use_private_root(struct kvm *kvm)
>>          {
>>                  return kvm->arch.vm_type == VM_TYPE_TDX;
>>          }
>>
>> Or,
>>          static bool kvm_use_private_root(struct kvm *kvm)
>>          {
>>                  return kvm->arch.use_private_root;
>>          }
>>
>> Or, assuming we would love to keep the kvm_gfn_shared_mask():
>>
>>          static bool kvm_use_private_root(struct kvm *kvm)
>>          {
>>                  return !!kvm_gfn_shared_mask(kvm);
>>          }
>>
>> And then:
>>
>> In fault handler:
>>
>>          if (fault->is_private && kvm_use_private_root(kvm))
>>                  // use private root
>>          else
>>                  // use shared/normal root
>>
>> When you zap:
>>
>>          bool private_gpa = kvm_mem_is_private(kvm, gfn);
>>          
>>          if (private_gpa && kvm_use_private_root(kvm))
>>                  // zap private root
>>          else
>>                  // zap shared/normal root.
>>
> 
> I think you are trying to say not to abuse kvm_gfn_shared_mask() as is currently
> done in this logic. But we already agreed on this. So not sure.

To be clear:  We agreed on this in general, but not on this 
kvm_on_private_root().

It's obvious that you still want to "use kvm_gfn_shared_mask() to 
determine whether a GPA is private" for this helper but I don't like it. 
  In fact I don't see why we even need this helper.

I think I am just too obsessed on avoiding using kvm_gfn_shared_mask() 
so I'll stop commenting/replying on this.

[...]

> 
> I don't think we can get rid of the shared mask. Even if we relied on
> kvm_mem_is_private() to determine if a GPA is private or shared, at absolute
> minimum we need to add the shared bit when we are zapping a GFN or mapping it.

No we cannot, but we can avoid using it here.

> 
> Let's table the discussion until we have some code to look again.

100% agreed.

