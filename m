Return-Path: <kvm+bounces-16468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D7368BA4BB
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 02:55:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B77F285651
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 00:55:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5461D2FA;
	Fri,  3 May 2024 00:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ACBNzVMz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE2D1367;
	Fri,  3 May 2024 00:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714697695; cv=fail; b=Rn6ui0Qunvkb2U6dsh86fg0H/iIWJq5OQzzG8lZ2CQg+BKfglVPRXZ4+4SP+C9hanHOM6WIYC8Vvk+Y/InKvfnoDmt7G2UTaI0jyDyC9jwgdxVl9j2mCSiNOwHPYnrpLVhGiGxzIuY2P4MjOZmi6aFYsPSAwLppAiT13YHKFILI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714697695; c=relaxed/simple;
	bh=uU3qtkIjJ8MoAgTRvU7ieBGvmCcDHGwo8te7tODZNIo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IAZ/wSJNxR2pTrSC4l/wXlATAlPuCcFpZxOUoMCS65PshkCgkzDrcWLqkoYiEzwR7AkMcDGhZUpM8dNqfn723dp9P6riuDfvPYe6fYd1xDIwjW3pdgEnWJ+3I+JeT1TGG417rjdtA7td3vot7sWhif79K6xTjxADD/sHaXStkLU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ACBNzVMz; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714697695; x=1746233695;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uU3qtkIjJ8MoAgTRvU7ieBGvmCcDHGwo8te7tODZNIo=;
  b=ACBNzVMz5f6pgpmWD9tjaEpTJfBVYqr1b3/KM2o1MQEvmwCtRqZ89Xra
   gnoM7X6PyctH/voqMlc4szhT5nsyEcb3Snn7YlzQKf8rNHiYpsHxxwXXs
   S8Wz+AWdyu6UUPJDdhROMoe3xGwn0p5L0xHLRiL3tjEM45o5iriR0cMVb
   xCo+L/9vQk9EMcSG3hs9wE2c6Z819g4fYn4nkpQnI0dl/MthNzWwI/EqB
   w/yDPDokrQrH2Kp7pIFhiS2U6zv1r71269dFyrSserXBomY1N7HLIePo0
   Qfk2AD42hRZVmMDJrWkUY4TqFdDETTx48NhSZNVv8yuthLYysWKtbGYsa
   Q==;
X-CSE-ConnectionGUID: 3oQTJr2FSh6fKtY2jBaG3g==
X-CSE-MsgGUID: GH7EOGjzSQ6Rqyvb3XtidQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11062"; a="14312394"
X-IronPort-AV: E=Sophos;i="6.07,247,1708416000"; 
   d="scan'208";a="14312394"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2024 17:54:55 -0700
X-CSE-ConnectionGUID: yx3J6gPXQ1O6AZ4crmp+CA==
X-CSE-MsgGUID: 3bqDR7N/S+Sagp75u0wi+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,247,1708416000"; 
   d="scan'208";a="31915322"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 May 2024 17:54:53 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 2 May 2024 17:54:53 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 2 May 2024 17:54:52 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 2 May 2024 17:54:52 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 2 May 2024 17:54:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VVjaGU0M8LsAmHa8YjoxdHx2wmowdiGJCO6AJH3UlNDkKi7YRsWCAJgE9ujzeL/qLO5adUvZrZZUopGDjRq2BRnZD5I7JOF+ZBBxVj50kWjcrJIZ+R7FWB4xucMetJKJDoiMlzzeF29X2ghyHE9kJ8hxylcvPsYRkELVARZMNBeALMeaRYORyb8hKo8KuqwobB5ggPBOQseBWubXbS7oSkZmduoEKE0LunjlRq7K1IjLoLx5N8KN3WZYsIgUpjM9eePZcP0f2vfUwmz6U1axm42sJZJiiPTukXuBsbtxxTSOfzAF0BT/fRXZEye25s7Jn7ULaulrQipfUj7Y7Wj+3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CHVvPBP36GSyOpI8CGmqKPpyhCiKABodcw7ySDR5ciA=;
 b=eWSbJRGu440kF0R+4Zjq9ZDmjmYs0NDR2uHTn2XIy5dXGWDi6A7jpk3XyTsT/WtjqeDS7u3aj2RKC+Onl+OEY0AR0TXSienxr75NEO3g41Tbcp9E2MHvdCdmDSgLjDiHf5MIizc4f4/qHtVhkMfLi4VeM4+lCQ683tXJcizlAPEG52g75SlS2HbSW+LYS0O0by9WDi0hhXGRylnATea0zxH1QKf3e7MoWFSUshMEkiad688aSbyV9oPV3r1rJcAShEHXGZuGfWT/qLxR4ctY1RmXx9Nso0H9sES0vwHnwoECb+LM+F7xNmkNmF96LrLi3v5bpDgqhavnNojaROwbJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB4808.namprd11.prod.outlook.com (2603:10b6:510:39::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.30; Fri, 3 May
 2024 00:54:50 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.029; Fri, 3 May 2024
 00:54:50 +0000
Message-ID: <2c671b0f-fc45-4073-aff7-f65461d2e785@intel.com>
Date: Fri, 3 May 2024 12:54:40 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] x86/virt/tdx: Move TDMR metadata fields map table to
 local variable
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "jgross@suse.com" <jgross@suse.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
References: <cover.1709288433.git.kai.huang@intel.com>
 <41cd371d8a9caadf183e3ab464c57f9f715184d3.1709288433.git.kai.huang@intel.com>
 <21310a611d652f14b39da4a88a75ded1d155672e.camel@intel.com>
 <6d173173-97de-42a9-85f7-20c5b6a2e6fe@intel.com>
 <6cbb56898011b8b0adbff216f1318dc5529b7d1f.camel@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <6cbb56898011b8b0adbff216f1318dc5529b7d1f.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0074.namprd03.prod.outlook.com
 (2603:10b6:303:b6::19) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH0PR11MB4808:EE_
X-MS-Office365-Filtering-Correlation-Id: 22749874-ed92-4d10-c4a7-08dc6b0ba31b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|7416005|1800799015|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QytzUjRza05wakpaN1JXZEd3UlV0aGw5SW85MDlFRERzRVp2YTJyaElZYWtn?=
 =?utf-8?B?emMwRUJyZXBKNTVqMnNSek5qOXBRdllpNFN6Z25OYko0ZWY1cWZDR3o3OU53?=
 =?utf-8?B?NGdIcUdWTUxFSVQ3S1BONE5iSnBLZUhDanhLdFE5KzcrQ0JDcmVybmg5N25I?=
 =?utf-8?B?cUxLaEJxV242MTZ0NURGRTc3MVRxclZ5U01pMW1WUzRUT1RjcUZBdUZjeDZG?=
 =?utf-8?B?eitvVzBhY0FrclMvcEk1dUdwQnFleTc0T3lRYVRNZmVQbU9RU3c0cFRkNTVI?=
 =?utf-8?B?YnhmVnRWMnNlQkxZNVRESldMdElTQ1MxM1QwQ0ZmbkZDdTNHUmFXaldpQzR6?=
 =?utf-8?B?UC9tdmdYbU1pdkJxWC84emVLM1RjY2JtVFBVRlFCMWJLTXlSM0JsWDRHQ3Q2?=
 =?utf-8?B?NVpUU1ZPUi9JMW9jUjA4dnV1dThMeGFyTnNxU1BIbWpRWm03QkZOV01oTEkv?=
 =?utf-8?B?YitrdzlnTFdLMDBMaXNoSXJhNStrMXBXbDAyYjZrVjBGN3A4Z0VZVDY2U3Y5?=
 =?utf-8?B?RUliQU9NTlc1eWx2cWxyYzNscko5OVVtd2ZQUkhTU2wxOFJCSWNQWkZjQlFi?=
 =?utf-8?B?eElOcDhpQi9zS0dLSkdtVk53NkJEalZyaG83d05Uek9EaHg5VFR6MkVwMlRs?=
 =?utf-8?B?cVVCWk4vQzAvTGtKUFBsQmpZSXk4cWsvWEd2N3hyVFExVnNRZURwTkl6b2ZV?=
 =?utf-8?B?ZHF3U2lpaU83OGdFQWhhaXpBWUxCa3djbjJWRysrL0kwL2Nia1gwMFlEeEc0?=
 =?utf-8?B?NW1DT1RnMTJ6Z2pGZFhtWFZ0TGdWdmhrR2o1NGxjYW1HckVNNGp6MmV1QVdx?=
 =?utf-8?B?UkRFTDduNEx1eXZRZmorajhGRityaEM2bkc1Q0dqQnpCMERTcysvdFBWODBy?=
 =?utf-8?B?ejBudXdaNnNCeEJPK29nQlB3MG9rYXhRWEI0UmtTa1UyMlc0TlQrditLUkNX?=
 =?utf-8?B?SjcwZlVhVkpDRGhFY3N5QlBPdjVLdldsV2t3bVZLK0hEKy9NczAzZzk3QmFv?=
 =?utf-8?B?UDR6dmN4VXVzNEpxa2tZTHozZjNYWDhNNk56M2o4ZlhTY2tHUCtIeWRLSEJY?=
 =?utf-8?B?ZnRXS292MTFmVEhnUm9CVWtVL0VhN1Z5djJOYUhiZmFZQjdEMUFvbXEvaVd0?=
 =?utf-8?B?NlZXd1dEU3F0WS9KdHFPZjlrb2xqcTJKU3ZzZzlacHA0WWdTQ2ZWZFRSekFj?=
 =?utf-8?B?a0Q5TFJoTEc2aFdDREo2ZTJ3MnllaXpjYVY3dUczY3lnSXUwcE10YVdqTTgx?=
 =?utf-8?B?KzFJYXNSYmdoVStMSzZXem5DVFZ4Q3hISmZOcWE3NjFmbFJBLzBmR2QwV3JX?=
 =?utf-8?B?UmFaaDQzQXQreTBhbncyLzF5OUd5dk9GQlJkVWQxSnhEK0RyZk5WQUc0eEUv?=
 =?utf-8?B?VEFoeWZnbXVXYW9va2p1Y1F4QXBlV1N2V3BTd1p6OFQ3Q21ZSmtqbG1FVUh4?=
 =?utf-8?B?VzZRZkFJdzI0clphT25vSWVsOS93czM0emNkRytBeUJ6K1FjS1BvZGh2S3ZQ?=
 =?utf-8?B?WVA1SjNIQnczYXQ3eDFlSUlUeGN3RkhKQWpQSDFTR1ptNjAvVTFTcnY2SThI?=
 =?utf-8?B?T1crcVVTdkowK3FOcU5FdTI0UjZ1MTl6VzUrZ1NlK0h3U0FUelE3aFZDUU5p?=
 =?utf-8?B?a2V5ZVBVcHpqbUxxWFJhWWppdWJYQk1NSFVRWDU2d3lzQlhpVWRFTWpVQUp2?=
 =?utf-8?B?ZVJMWHZSOS92Z3c3SXVVemtMc2lYckRSUWVzODlOeXc4Q29tcjB1c2ZnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bWYzSjBqcXNWODNyblB1b0FvRm15dWVCcWpwbzF4NFhjaFZ4VmVneHY4bk5V?=
 =?utf-8?B?UTJQL05LZloyS1Azb1pIR3pLYTNXTXEwNUhrSUJrZFZ4ckxzWitQUkdheWxr?=
 =?utf-8?B?VVQ5UCt4T294K1N3aEQzWlFROVJNajk0T3RZL3JrMkFXcCtoekt6T2ppa25H?=
 =?utf-8?B?RU5QYmJVUXQrcyt6VFNYb1ZWZVRoS2FUNUJCVzgwQkloR0hSc3gzSU0vY0NY?=
 =?utf-8?B?UUxqOG8rcFJCNlVDcFdOd0tndmg0V21JT2srenZENnVWN1Jzck41SHhnNkM1?=
 =?utf-8?B?NEU0eXRnSDY4NDF3OVp6bjFaaWtkZU9lWnBRd1V0Rk52TUxMSUtsYmNrTXJl?=
 =?utf-8?B?ci9zMTM4ZkFsQkpJdGZIMVZRMjN1MlBHQk5IVTdZV3VmNitLL3NuSFQxeEgr?=
 =?utf-8?B?RFJPa2xkbVF6RjIxaVJRR1FzVHYvK2NuYWxIUmhvV1c0cjZUcmNyUmxwb1ND?=
 =?utf-8?B?SEFLVitNYlMxaEExZjRGZXNtMjJJR3NqSGNPeVhUZHdJamJLT2x4dkJOSmVW?=
 =?utf-8?B?TmVGMFJmcWxZOWZRRmVSSXBqeEtUYXlMYURoRnpoTDBYSTVpM2Q3ekczWlFu?=
 =?utf-8?B?Z3pjbEdjSmRYYmxuL0JJcFBSc3UwYXptakhvemdFWlFPcmZ1cVJMZ3orNzE4?=
 =?utf-8?B?R3hmdnlodHZPVnBwOUlCK0dwWCtJN0wybVpNZHRveko3UVBjT1ZKTThoYTRZ?=
 =?utf-8?B?RVcvQ0NKZzU3aGZHVzJWRE9sdkttNjB1d1RHcXBjc1ZqT1o5cjN2TE9IYmF2?=
 =?utf-8?B?R3NxdlZUNFI2KzBBRnppeDNqY2VFWDBPeFhqNk1JZHNqSXk3VVJBK1VsWUw3?=
 =?utf-8?B?dDJISm82ODg0aWRXTUZwWllhZW5vbnRDbWpPbWRkdzkyYlVKR1c1YzVPVFhE?=
 =?utf-8?B?cHRkaFRpTjBHOUJ4Z1dYVEJCbnVRZ3RwWWt0NHZEYUg1MWM1bUcxSHJzRzRv?=
 =?utf-8?B?TzgzMWQvSlJsL3BUenI5alQwSVh3aGVscHJZeWVuQTBaSWdQcXJ5KzlIVmN5?=
 =?utf-8?B?MUZHaWQwaTJUYXBYVHZOS3hhMVJCMXgzanJuZkIwQTNRRmV0UGxETjRieXVL?=
 =?utf-8?B?TTNSM3ZibUZGSk1vWExubDZJTHd0Sy9hcTRubEJrNE5ZUENqWjM3WlJ2RHM1?=
 =?utf-8?B?eFpFSmZUOFFmbDlvZUNKZlQ3WUdFcUJrVWFHeUdjZDQ0Qmk4L1grZS90VEVW?=
 =?utf-8?B?bkdhSnU2dE1VWFFlaEtyRVFGaFR5NyswNThXU29vWjAxTWpPZ1diaktneDRv?=
 =?utf-8?B?S094L21ZQlVJWHlmRFExQVNxQ3hrV1plT2wyV1JraXQvNWhLT1ZsTHpJR3VV?=
 =?utf-8?B?cDI4bDhlR0RPL2dqaXE1bFdVZnEvU2VTQ3FLcER5WVJCVy9STWN1MXdmaTRp?=
 =?utf-8?B?cm1IVkliYnM5dHFDMFM3VTBOcUVjZHNxYTZyWm1DYW1yZVRPN3NGRlZKQWND?=
 =?utf-8?B?UHoyV1l1UVNGT1RjaGlzUXVLZDJyOXZ0UDF1K2xGR29tVVBaZ3dnL0xpU2Nm?=
 =?utf-8?B?T2RMRHN0N0ZYZExIL05ZTlF6anZrd1F4OEFoNXhrUnJlUHNzVkNqVHBCdWcv?=
 =?utf-8?B?V2x0cys5ZDh0cVRrSUVQV21PZ0FVQWZudDlYZzhTNit0UVhvQzRQb0U1OTN5?=
 =?utf-8?B?ZFB1UDFKeDIrbXM4TFYxdE4xbVgyK0tHUnFsYUcyV1RzQnNNdms4NDFnT3Bj?=
 =?utf-8?B?Z0ZnRHNEUDBUanE1WXg3U0lXSVB5aEl2dmZkUWRYVG8xZmlrQzFEUjE1THpL?=
 =?utf-8?B?N3J6eVVaSS9Rb0hNeXhtbW40ZmZoTDVGaFdJT3hsQy9ZdVg0UVllWDZyZ3pP?=
 =?utf-8?B?SmcyQ3doQk15U0ZacktnMHBWMW9ZSmluK294Y1NTYktNRWUxdjF2Z3duRXh2?=
 =?utf-8?B?dTJZRnFTVXZ6ZGFCZXNsTzE4ZnU3c0RCY2prN3pwQ3NTTnhRbXVRRzQzTkdh?=
 =?utf-8?B?Z25VZzcyTnl5THRKNTVyYisrQ0N1UVNnL3V3d2NWKy90a1VTMmlZWTF0ZUVv?=
 =?utf-8?B?b3NEN1pBVmdzTU5qZjU4V0d6eW4zaVJqZkk0d01CTjQxYkhjUVBaa0pONEt6?=
 =?utf-8?B?cnBqUjkxbFlTQlNFNHB1QnYzeE5XeGVZajh0bHlEREJQVUlVN25xYTRTcCtP?=
 =?utf-8?Q?vZJV2JfhADbLA1qehnwrU8oiF?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 22749874-ed92-4d10-c4a7-08dc6b0ba31b
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2024 00:54:50.6768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M2KP4AdyzSBJDoI/geOFRQoArhJqIORibqQ+UUPh9FTsHuJ1awq2D2cd82V75CEJ+l4ztXnj4OhbssQG420b4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4808
X-OriginatorOrg: intel.com



On 3/05/2024 12:29 pm, Edgecombe, Rick P wrote:
> On Fri, 2024-05-03 at 12:18 +1200, Huang, Kai wrote:
>>
>>
>> On 3/05/2024 12:09 pm, Edgecombe, Rick P wrote:
>>> On Sat, 2024-03-02 at 00:20 +1300, Kai Huang wrote:
>>>> The kernel reads all TDMR related global metadata fields based on a
>>>> table which maps the metadata fields to the corresponding members of
>>>> 'struct tdx_tdmr_sysinfo'.
>>>>
>>>> Currently this table is a static variable.  But this table is only used
>>>> by the function which reads these metadata fields and becomes useless
>>>> after reading is done.
>>>>
>>>> Change the table to function local variable.  This also saves the
>>>> storage of the table from the kernel image.
>>>
>>> It seems like a reasonable change, but I don't see how it helps the purpose
>>> of
>>> this series. It seems more like generic cleanup. Can you explain?
>>
>> It doesn't help KVM from exporting API's perspective.
>>
>> I just uses this series for some small improvement (that I believe) of
>> the current code too.
>>
>> I can certainly drop this if you don't want it, but it's just a small
>> change and I don't see the benefit of sending it out separately.
> 
> The change makes sense to me by itself, but it needs to be called out as
> unrelated cleanup. Otherwise it will be confusing to anyone reviewing this from
> the perspective of something KVM TDX needs.
> 
> Don't have a super strong opinion. But given the choice, I would prefer it gets
> separated, because to me it's a lower priority then the rest (which is high).

OK I'll drop this one.

