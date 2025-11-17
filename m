Return-Path: <kvm+bounces-63419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B4430C6609D
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 20:57:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 030424EC7D2
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 19:57:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E40732D0D1;
	Mon, 17 Nov 2025 19:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JEXd0uBP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5D8258EDE;
	Mon, 17 Nov 2025 19:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763409420; cv=fail; b=Yxk/bjcgneHriUM1iIxEVGFjii9h1ufanP+LkmZpRwvNtSOvvQ5xfxwiT/HZ+Qw7t2208BoDerf7XnivtRfZChoqrNNGe4mIcUeyCm+hYXGfMBoGaHWule5Nlq7JLnqdmC72r7F+SBylRoMzUsJWzfSjeizMHzQXGOBpQ6BP+TU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763409420; c=relaxed/simple;
	bh=fBlWzT0jUen2hlVlirFOBlD51ua5v0JkWjwBlDLoPbU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dLK1CsrUbflNijcCK4/t86WBznAi6zxieE2+hYN8HKSUFZdJcetj9ZuEPZo3wxSgtlMIwIEma8MRST8p72L1niOqtIpVChP+Wyv3cW+bP0tRL4pRRrurZ6ZOQ1CWMx+8aYkS5DUN96thSVUOpo7gFAT8N7YkpXt26zRLVdlvaTA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JEXd0uBP; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763409419; x=1794945419;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fBlWzT0jUen2hlVlirFOBlD51ua5v0JkWjwBlDLoPbU=;
  b=JEXd0uBPEqGOK12cpnTm+xVS5eRfYbrcefQKlhCqOjEMctwWvR078SuU
   s/Lgr4pF3PIpIfwIgv+du0zQnns67eSceNWTPTOj+sM95gYPZNchTF1XB
   79T9m/Aup+GUkZNppScvmRWqsUm4obUMNOHrmT/WIn0ESGBWA8NQRYmOh
   tTuZV1DbtJLFaRwmKRNyjQSMZ9Vc+atHK53oJu4dXYwkbo6AohqBtg3MR
   NmSF6TaTBXoxDejZk2d1FDC9L/6odX3WkqKNqoVogDom5QkVFEt013K6J
   MeNV0nZ+Yb6ILK6N75aXh93zpwOfOL7aNtxUOZYu9SclYSpDOLN67+tPD
   w==;
X-CSE-ConnectionGUID: bP34kqTBT/ye8W3BUEpMow==
X-CSE-MsgGUID: s48F/fL5RuiqMhxY3bmXiQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="76522839"
X-IronPort-AV: E=Sophos;i="6.19,312,1754982000"; 
   d="scan'208";a="76522839"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 11:56:59 -0800
X-CSE-ConnectionGUID: Az4YN/KyQE+a8ywatwlEIA==
X-CSE-MsgGUID: 6rGNSa8rRGaFPtynmKGoqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,312,1754982000"; 
   d="scan'208";a="195012939"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 11:56:59 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 11:56:58 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 17 Nov 2025 11:56:58 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.69) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 11:56:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TirvhJr3sX/kUKtGJULO6nFimWTBksU9Z4GcyNxrnt3NwLjKipFWIPeL8P5vlmDK6OIvziH7hZ27mnWCkRWgRJnjY62F2XlEGeRy+vImq3uwjn7LSGrFcQw7Vl9CsyciTm/PDVNjh1AJ8WVAznEDjOtJd/azARylsaCbWK33CChGPURii57MaJ0/j8w1LuetSgqRZbZRQ0wNOuJeonwRCRY/HiGcgilQTCaDdDzI8We/pwuq9bCDp0ex9TvQXqX/FMTZwH2sG3GzWFSIU1fImC3DNxe77Hd2ERs4asdjZi84OkO9YhdAiyAgwEpaKo4kkN7Ez+szqz8fvpwuVZrxNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SeDj9GQEJJHhyNofunhoeRP+D51EcO4o/NcNEh9kLPU=;
 b=fIRT9rT+CBEVWdZDuO91MwoapPj5QswvMJlRz4hjJOKbK0sDZB48a39LU+0X/YJzDIPsT+NCBMSw+h6v+xM8hMjrZ2uVvOQblsodrOPsM0+O8S17wMB9XPk+mWeVl0W/73QacGaPVvzdGuAwQpqEDPUSUCZnhHO1jixeFAj3Jif5sHM+ccYPQjDH8R/6fPyjyP5WLoj/DRIhPrw3BfKTSoC6foNiPAJD82tlP7bxMTk/pwY9UWYDDYcVc23mHSHmpWTQjp72iF25VJCJYPhAP4IO5zrA9xrfxuxBF08PPPMIIJObOsI/undb9K0d89SHVnI0vbQwTnFn3dKfM8g1vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 CH3PR11MB7819.namprd11.prod.outlook.com (2603:10b6:610:125::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Mon, 17 Nov
 2025 19:56:56 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%6]) with mapi id 15.20.9320.021; Mon, 17 Nov 2025
 19:56:56 +0000
Message-ID: <dcc0eb50-bb85-486f-aa21-8a06e4a43251@intel.com>
Date: Mon, 17 Nov 2025 11:56:54 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/10] KVM: x86: Refactor REX prefix handling in
 instruction emulation
To: Paolo Bonzini <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
CC: <kbusch@kernel.org>
References: <20251114003633.60689-1-pbonzini@redhat.com>
 <20251114003633.60689-9-pbonzini@redhat.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <20251114003633.60689-9-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0345.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::20) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|CH3PR11MB7819:EE_
X-MS-Office365-Filtering-Correlation-Id: 8401cc7e-52ff-4e68-92cb-08de2613762d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VGVIZDNhUUtpZFlpWHNwT01oU1pxaWIzR2ZyTmpWWmRzT0pUYkQxZ0ZIRUM4?=
 =?utf-8?B?RGs0Z0d3SHFackpkbTArTHphQytkc0hDN3FIb01vTkxvVUlSMy9JblRYL2Nn?=
 =?utf-8?B?bUZuYWFWUi9VZVVnRlhVYzNZVktCVXdGZGFJelVJTnRzc1NaQ2JLV2hTd1ZW?=
 =?utf-8?B?VUxOalU5NTUrWHdmZkcrUnAzZ2VaQUpqRU9yQTZQamcxUmpkZ0hKVzI2T1Nh?=
 =?utf-8?B?emp3ZG1ickVQQ1RHbFcxWFdRL1FrWDF6NUZxbmx5N2JkWVZMMzV6aWs2QjR5?=
 =?utf-8?B?cUZPNGNLR2ErZFhCZkJ0UTFpYnhMOFBIa3kvRmtyNFhxWnNRcXRsZDdvakNj?=
 =?utf-8?B?NEVnR0Y0ZkZ3aG5GdXRBWE1kakMxa05kNUZpZW1SSTFkTWY2OXBBeGZ1U0JG?=
 =?utf-8?B?T1Z4NmpZb1p4MkVIRTBMZHBrRS9Qa25reWxzL3Q1bjhyckNVZ2dDTkh2UWw2?=
 =?utf-8?B?OUJPbUR6UEJEVXFmclpxWXgvZHdOYnZpUkFibGxBb0hhWWdRYzRCbkZGNXZx?=
 =?utf-8?B?R2FZYnFyOHMvdU5PeHpIY0F0R1R3TElxZHd3VjFIS0dYaUU4Q0wxWTJkVEU1?=
 =?utf-8?B?ZGpRTWpkRjBpWE1NZTBYOGExQ1pjNXpEYVJVckY2T0YzNHNXeVQwYW9vWjla?=
 =?utf-8?B?S0FlcjNwSGN3WjV5V0pBWUNybTIreGZ0MHBvTjJOV1hISGNZQnVUZzJnUHpR?=
 =?utf-8?B?Wm83ejdDdVNsZTc5SkFNRXhEVnp3cUhIblRialYrbXlXeDZ5SlR1VUtQZ0pu?=
 =?utf-8?B?Vll5b1Y1QSt1K2trNTRIUXZqeFd3aFluVXl5T3RzcFNOaXhFbUgxR3hEWW9L?=
 =?utf-8?B?ajJ5ZmRiLzlHOWJmWXFaa2UxWFVNQ1oxcDc3b0lXMjhmZnIrRVlWWDRmdDJD?=
 =?utf-8?B?T1NqMmJsWlFoRVdubU0rVkFTSjJ1b09XZHBBTEhEaHA1Wm9wckhaclhZTVlk?=
 =?utf-8?B?Wkc3Y2F1WElzS1FLSzg5VHJtV05KcUhRS2tsSWlkR0RYd1NTcEpvTTN3Vmxi?=
 =?utf-8?B?VUpXS0xmaHgxTHFOVVdwNlJyOWlXN0RNTnZoQUlYZjZHYllYNk53bHRVL3lM?=
 =?utf-8?B?dk1kcjloTnIwemRXUGJWQTJaWGhWYk9LSkp4b1RBSjNnb1VHRUUzcjM0eFhj?=
 =?utf-8?B?VHFLSDQwa2NxZ2IrNzQxdkROZ0pNdHNMNzZOWS9ad3NxekEzQVhDelZicnhJ?=
 =?utf-8?B?dzJ5ajlHSWxrSmRYTUZyeFdVWW1rRWd4VmdhbFdkb1I1NDdaMTJVTmFHYWFo?=
 =?utf-8?B?M0s0M3A4a3VCcVJKeG9ZUGVSTm05T0lBV1ZsdTZwaTA2d3NreTdtVWxIS2Y0?=
 =?utf-8?B?TnpIV0Y5K092UjA1YWVRY3htalA3VTFkcjVoYTRDOGtyWXp0UlFWZ0FCVk9B?=
 =?utf-8?B?YVBrZ3lWMEE2UjdSZ2E1Mmh0RTZPS0EyNHY4ZkxqSmhaSy9nZnNaeXZkUGF1?=
 =?utf-8?B?SXdsNlQzQy9RamgzMWNtNGptMFJEcVY5WkdYUVlCaHVtblFiRkxEV3JEYTVC?=
 =?utf-8?B?YXJTdndDaWU0L1J2Wjlmd3ZBTVFWRkpMOExFU2NsTGozL04wNTlUUzY3QnF2?=
 =?utf-8?B?d3QwdC9LVkw4YWtMUmU4MmJOeHFueUNlSElRRFJZMi93azdscW5zV0lzamg3?=
 =?utf-8?B?V1oraXE1SzBsK3VKYldZVGhtVDZSWStXUEI2end5U1M5V3ZDMkUrYlpEQTRi?=
 =?utf-8?B?Y2dTZ2NuWmdJcVYwT3VqMk1kTlhwZmYrWFltY09SbTBTN1pUV3pRM25OOWkv?=
 =?utf-8?B?SHdDMEJocnFWRWpua1p1SUloMFErL0IwQkJTR3loZ1BQSlJwNHMvUEo5NDlr?=
 =?utf-8?B?eDlzUHMzbVQ4eTByc25qdkRmOXhTUGFhSXFHWE5WTysyZ0VLeCsyYjBVdVlW?=
 =?utf-8?B?Njl5MEVrLzQrak1QdDQ5L3E5NkEwT1F1TEZESDZ2WkNpRWUxdnZXcVdLQ1Jr?=
 =?utf-8?Q?/dzKOnS00wyUWKbfqwH+NWD9LiQbbW9e?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NzZodDZaYmlkZG05NDJNTEF0REJ6TmttZDFSYTBPWGxIT2ZVcElyNW1aRkVa?=
 =?utf-8?B?S2VveXFaMFRBeHQ4SnNBM2dKcHpwdmRqSExzOHp3MmNYRzNSaTdod3d5S2t6?=
 =?utf-8?B?aHVKbFNJOHFqVmUydFlZUUFBRklOSnViV2RBUU5ma08xaVFnTFJsMkE0RHJ1?=
 =?utf-8?B?R2t1UThJNjFFa29DNW02L3NZVEZlTlYvZzRRR1B3NHZtZzlIMDk4aHQrUXRz?=
 =?utf-8?B?VXZqTm9FVXNNQ3JTVmhtL2VpMnRnQTZJLzlCUFI0Z2pvTnZ4UDNEVG5LWEVr?=
 =?utf-8?B?aDVKcGFRWU1OQlJlYXNWSEFPSTNBWWNHdXJmbkFnd0dMMm1nSlkwUW1QSkdT?=
 =?utf-8?B?ejZwaSs5bStqaEdkU05QNTJLUFZCK05jVDBNZmNMWEdUUG5Kd0QyNHNDckxS?=
 =?utf-8?B?d2grVVBDeTE5empsVkV0c1A5VHFBQnJ2MGZmWXgweHZsckhZUmpWQW5uZ1Fn?=
 =?utf-8?B?MEd1Rm8rci95aW9MOW93WUFBdWFtekJjZDNzakNHZXVTU2dIZUhweXhicEJP?=
 =?utf-8?B?Qlo1RExuM0k1MnRMdXUrQkMzMklYMHBZVWlMVU5jMGZzcEpuZmtpWEZKZDRs?=
 =?utf-8?B?VjBmUUl3NGVKZjNoQUFMQWVvekZFTFUyNElJbXRvZUtQbmZTcExNbzcySEpK?=
 =?utf-8?B?OW9WbTRhMDZWeVhiUmRHUjY1UkNjS1dpLzVicnZFbTlsQzdOTTJGOW5RL2Ur?=
 =?utf-8?B?NWZUR2RXaDlOVnJja2k0TmZ6MzMrSmJQVWRWcUVkc2NNWDFvNTRIUGVDQjZQ?=
 =?utf-8?B?aHpXQ0lUSWlMTERDcGRCdHh6RWpPcm1FeGx4YjdDTW9GUFNscWdZd29HT0dM?=
 =?utf-8?B?UE9ENS8wVG01aUdYMGJGVlhpb1FEN0kzV09RZmRpZmk2WmkvaSthQ3Vha0Vn?=
 =?utf-8?B?Q0Z6QmdTa01JaDhUbEdYZU90b3hjR0xHc21lM1JHZ01rZExSOFZkeWtVRzZa?=
 =?utf-8?B?YSt1d2RlVGkrM2t0aXNRMUZ6MWhyeXlPK09TUnlEUkVQZWpHTjFzN05jTURZ?=
 =?utf-8?B?OFpTMDRueUVrdHBHN2JIZlphZUMxUHQyWDJ1ZDN4aDZXcFRDWHNkV3RYTGZx?=
 =?utf-8?B?Vlpwd3lpMGR2UkFMNU9Da0F6M3A2dWlOMEgrbU5TQUtFbWJkY2VFeGM2Wjd4?=
 =?utf-8?B?VGdkRmpmdGNRNnpVQU44QmhjUlZvMU5PTlV6d3RGWGpzR0tJcjl1N2JzUmxK?=
 =?utf-8?B?a0ZpVzAzemI3RzM1NTI1c3RnZU0zUTBDTlpMMmMwd2EySE9CRHVDUmdLVnJH?=
 =?utf-8?B?b2FuSFN5UllEYkM1YWZXNmZzRTJHK1NBelZXcnpzREN1RVI0K1o1ajRtekgx?=
 =?utf-8?B?T0tyZjFKUGs5M1ZUdlRFWGJCa2RLU2tpQ1ZJTkhFcGZaNTVJMUhWcGx0Zksr?=
 =?utf-8?B?MmRUbFByQThpTXNHNWcyekcyTXhFSzdkczdrdmtKZ3NGWW1seTR5UldLZ1Y0?=
 =?utf-8?B?TFU0VHRpZWlTV2FJcklDamdHNHRPNkZOMlhLR255Um5pRm5sMkFLM0k1ZTdX?=
 =?utf-8?B?R2gwS0JydDYzQ0hIQUYzMmhLSGkxaWhJa0ZyN3VSaEJhKzEzZFQvRXdveFBB?=
 =?utf-8?B?SkRNcnBCZUdmT0VoRXhFMHlFSGRiVGN2K2lia3FrNDNuSmdGZXdPM2VLV25y?=
 =?utf-8?B?eVNXUktybURDTmk3V082Y3pyZWxRd0hIdkhDNU1yakVrUkZhNUpNYUo1d0dz?=
 =?utf-8?B?Y0w2TVRzQ2xJaUxzV20vVEhUaTJ1UWdOU1NUMzNQUjdJTVVmVGE1am5lRzNh?=
 =?utf-8?B?NlJUSktiNFVIMEJXVk1KZnJLTjNyZWpJUXQzUDlHMSs0Tml2UVFLOEE5MG4w?=
 =?utf-8?B?OTVQMy9NVy9FTmVaZU9yQ3VPRE1LdStRY2dzbHpQbnRjOWZOWkRka1k0bmxF?=
 =?utf-8?B?WnFyZjVYcmliNTlaS3FCWFh3YUVHTmEzRk9iUStSUkRLbWlrWmRpeUszMDdr?=
 =?utf-8?B?T0ZNOU9GUXpWSXRtRnRTREt0UkZ6Z2ZEaEpuZHREankxcFNUY2hoU2ZhMnJB?=
 =?utf-8?B?cWx3bWFUZWIxMU4rSkJiY3NDWWJaRExlN0ZpOFJNdlhHdGJQbGw5KzhRYzFE?=
 =?utf-8?B?Vi9ndmk0Ny9Jc3VucWtIbWJOalVxNHdwZndPVlRpdmQ1L1F6L1E1dEVYTDZY?=
 =?utf-8?B?RkpLREt0L3hjTFAxaUVVYndIUTY0eEdIRzB3b2gzWXBzcGplZTVZRkZHWThC?=
 =?utf-8?B?c3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8401cc7e-52ff-4e68-92cb-08de2613762d
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 19:56:56.3936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gatfx3hGirY5Y+cfQe+yfIRT1qxVwLfQ2SZmjAzgCrMimuD3d/I4/UEes9n3s5iFUgd4NEem0BVROnBJwM+PLKH0vHreX6F5BozwXKkSmr0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7819
X-OriginatorOrg: intel.com

On 11/13/2025 4:36 PM, Paolo Bonzini wrote:
> From: "Chang S. Bae" <chang.seok.bae@intel.com>
> 
> Restructure how to represent and interpret REX fields, preparing
> for handling of both REX2 and VEX.
> 
> REX uses the upper four bits of a single byte as a fixed identifier,
> and the lower four bits containing the data. VEX and REX2 extends this so
> that the first byte identifies the prefix and the rest encode additional
> bits; and while VEX only has the same four data bits as REX, eight zero
> bits are a valid value for the data bits of REX2.  So, stop storing the
> REX byte as-is.  Instead, store only the low bits of the REX prefix and
> track separately whether a REX-like prefix was used.
> 
> No functional changes intended.
> 
> Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
> Message-ID: <20251110180131.28264-11-chang.seok.bae@intel.com>
> [Extracted from APX series; removed bitfields and REX2-specific default. - Paolo]
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Thanks for the incorporation!

