Return-Path: <kvm+bounces-17992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 207C28CC91F
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 00:36:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 70CE2B20FF0
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 22:36:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1286214901E;
	Wed, 22 May 2024 22:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SHU6KqxO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB63E146A8F;
	Wed, 22 May 2024 22:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716417386; cv=fail; b=DA9BHkvUjWeVj8Np8KhmrkoGOAGbbLvQfEvVzu7FCYuPRyZrFbrTywBiCV5Z2goeAcPvSDrDw/HdR7mQ3ZDdrORRw404lxx10WjpBlXGxy2O7dAo34S3EQqKDdZH8Ze0HmD1NnztJc7h6q+oucduqJusuRI0+b7Zqk3QBiA8AoY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716417386; c=relaxed/simple;
	bh=sQKjDSrRq+Sj2Fe7cbPyb4VpKhrd6cMDGan3mVCQM24=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aIYY9/zABS12aw+z4uszTKqKVV6j8+F2Y11HhXV6i2zb2h8FKeRuzZmZKQSFJU3a3KMGcfmzv1u4J1/vOXGC1j8NCyVSgXjE9iJkyaJazNIbsIOpE8YrKypgsjVz0UvCpcF+pVGIDpQH3NfFdAAg9Zo37ySeV9hhnLeiDWZ9IHw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SHU6KqxO; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716417385; x=1747953385;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sQKjDSrRq+Sj2Fe7cbPyb4VpKhrd6cMDGan3mVCQM24=;
  b=SHU6KqxOLV+/1rWq6uMep8gOZaYasn/blDKDRVoTXLZeIwqj9i0puLZV
   kdPbmBLF1NuAhik2YD2pmVLGv0ZiAPXHo/gDgD81tdxWbpyQzeKTqoUIA
   7F5KerJ9aUiDgZMaaZ/Q8dK5P5b4tSeXHuEKf28ZUBuFEmMvfFyWBud+x
   bpzvApHIUB/OiA6kAjCS6lZNZDTpULitzB58KAth5lUTpLQnI15Qkf9uE
   Fx4/P5L84Ese1dQ2SHoy6kkQisDX833/T/ppsyH0g1KGASqVeRJsTWoOr
   L2Y9TFEVgSF8K4MWkXrvNVSKh5zHIxQKEJkKU55CPxkxBivw9fsLprDmo
   Q==;
X-CSE-ConnectionGUID: VMYAdKheTBmMejWiFaUf5Q==
X-CSE-MsgGUID: YcazQ0zNR5mX5qv5Efm1cw==
X-IronPort-AV: E=McAfee;i="6600,9927,11080"; a="12882227"
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="12882227"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 15:36:07 -0700
X-CSE-ConnectionGUID: jRUVqgYvQqeRKYagQiokmg==
X-CSE-MsgGUID: xm1nWPlFRK2BFUKNdW+UNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="38286647"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 May 2024 15:36:07 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 15:36:06 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 22 May 2024 15:36:06 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 22 May 2024 15:36:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fRUDH8ASInoB6ogsqQHAaghWj8sBBqC3SAKqBIrc1JxtTnU2mBHWYo2JU65lu7ZUF8lGe+FlNhzpRQuzBVbQpkls114sk7RCFPxZCpaUBs1UCM+87O2wz+0Q6Eu6IKDydBCfssNL78kOxqsC69c6jN6K6fWX/zpi3meKpP27GForQt9a4heKSWc52YvYl8pWxfTFLjWIk+WkBexnkqe7lUMbI5C0wzqW8iJxWxo3QdO+37O1IzDFmd2Rbih9PxqeZon+dLJf4O1gtoIDXGlD6dNZkGxNvd+UEPBK2BoYClukuOdrVE44LLbYSUB1GhCh9mJDyp+QQ5mfSC7YqJ6t9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0+R+sWyO2cqznCGmsgfTiYnoNu+QZLa/7P1zFmW7EDg=;
 b=D1px5fnj1laLwaVK3obPbTqh6XQMmP71BW5V2d7YE6mLXOzAVWpRURDPhNzNxhWzaerYNvCvzQmVg5gaiFOK5Mj0qPFRUjkl5YVpJMj6DiIgPLi2EjmX0IQzvwx/vN6h/axLWxO/SY8MsJ9Y565oPzVnQ9vDgWMF6Ws158hnho4RYSd4n7HDnIAfQqeJomOJIMYpQx5kiZB/ezxC9rOMb7f882bWzHBSzaTV1SC+wYA9JT3QUHjU/6XD4iu1KYaAulKDHropOrXebM4NM1m0uIQWInArXwpP6OMuD3Kqhyari5mJL4LsMhLwHUnknSsQOE4RdBXsKoCWQC7YmayrLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH8PR11MB8015.namprd11.prod.outlook.com (2603:10b6:510:23b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.19; Wed, 22 May
 2024 22:36:04 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7611.016; Wed, 22 May 2024
 22:36:04 +0000
Message-ID: <e90647e8-4d37-4c2d-8c3e-759c6cb6ec52@intel.com>
Date: Thu, 23 May 2024 10:35:58 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/6] x86/reboot: Unconditionally define
 cpu_emergency_virt_cb typedef
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Chao Gao
	<chao.gao@intel.com>
References: <20240522022827.1690416-1-seanjc@google.com>
 <20240522022827.1690416-6-seanjc@google.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240522022827.1690416-6-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0095.namprd03.prod.outlook.com
 (2603:10b6:a03:333::10) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH8PR11MB8015:EE_
X-MS-Office365-Filtering-Correlation-Id: cbb91d7f-b191-480f-57fb-08dc7aaf905d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QzRnTUlZZTA0V2VTQkp0M2dzaTZGY2ExZWZSMmVsUjMvM0Z2alJmRXpPckhv?=
 =?utf-8?B?N25maFUxaTlNL2Z3VDU0RDd2RVYvcFZyMzRsUlY4VHlockR0Z0wwNGVkUFlV?=
 =?utf-8?B?eTdQbzRDSkE1RDcvYWhQcGZWSWxqcEl5SFAveG1JOU9BM3pZV0UrdjZLRmYy?=
 =?utf-8?B?TlpNVGxqQW5VN0pCd2V6bk9sN3oyeW1pV3ZIWnFhVUhyYlNuUzM3Q2xibm4r?=
 =?utf-8?B?bEo0Q0MxVXQ1WjZTQWF3alZJSTd4enlsazFQL2NqbmJYOVVac00wUDN1RDNw?=
 =?utf-8?B?QUltTzlHOGN0OTlZZjFQZmpvbHFJbnRsMHJ1eVN3VHZ0azVFRzdrWk84ci9T?=
 =?utf-8?B?M3RJQ1JzZTJVWU9xN2hpc1pITkxPbFNnZ3ZvSGRuTVJQNXdNbXFic21MUDFY?=
 =?utf-8?B?N2h0azNmSnE4c1d5cDNsWDRCRFBvWlhIVFFVR2l3ak9zUVdFU0RGdTMxakNL?=
 =?utf-8?B?ZTlwTVF3dEx3NDNEdnFmRTIwZ3ZjenNWem9TOVh0VlMzSTA4ZHJhTk1icFZa?=
 =?utf-8?B?djZuOFpRTnFnNGorckRXd2hoYmZnTkhFVEFKaG9tanFCaWpFaURqNFEvN21w?=
 =?utf-8?B?U3RBZ0xEK3dvYTNjeHgzRndBN2MvTWJvdzBPU0xsOVl5M1I5QzNPanN2c0Fj?=
 =?utf-8?B?ZU9iQUVUcmIrYnNxYTYrb1NzdXZLV041ZVpZSnZOSnkwNWs3QjF2RWIyN2s3?=
 =?utf-8?B?bHNEU1dwV29HNDcxVDlpRWJycUVGemRLQnN2aDJBSWtyVm5KZUFLcHV0Z25x?=
 =?utf-8?B?STE1WnV0NTdtMnFaM0UrSlBCcEcvNDlDYXRDOXJYd1lHOHpaVkRGU3F3aXRS?=
 =?utf-8?B?VUtXVUJJeEEvVkd4VWV6cnBqR3lXTm1tQkRGb2t4R25Lc3k5Z0tKMUk3S2Mz?=
 =?utf-8?B?MlhHR0YySGwzeFFiekRmOE1IanBBQjNsVTJhNXJIUnd1MnRhTHR1UWxuUHl0?=
 =?utf-8?B?K2I4Y2ZoaFhOUUZLa1E0ckhwRS9iMUV0QVdRUDJsUEVWY24zYk5KbnlKd3p3?=
 =?utf-8?B?a05ZdDA4VS9MVk9UbGd2ZFM2aVRsc2VkTnZRZ1dJSmxJem9VWkduQ3o4ZHpt?=
 =?utf-8?B?aXM2RnlONkE1Njczd1NaZFh5YXdBTVdjM2FFeHhzWm5Nc21TY004K3hOQ3U0?=
 =?utf-8?B?QzRjNklhbTJnRmVValM2WmhRd0tyc003UFllUzBHayt4Q3BCU0Nvc1BHRks5?=
 =?utf-8?B?VHFhejNjYWtQNmoyQ0VaNzViR1hvVXh0aXJHd0tPU0QzeDNWQkdGdjQ0ckZP?=
 =?utf-8?B?MnFiMnk5cnFZVUpicGszakpZNVUyM1MyR0dJR0V6V0EvekRYbmlxUWhCTlBi?=
 =?utf-8?B?dUpQK3JnVVU3aEZTM040WDEwYkkvenIzaFNVSVFuSVc5c2tvTHdVOUQ1THc2?=
 =?utf-8?B?YXZvakRnYjVRZ2RNaTY3ZkRiKyt6VlExejVoN1JpMUFORjJMSllybVB5S3cx?=
 =?utf-8?B?TTRSQkxtL0F2Y3VrZktWanY5aVQrMTdBNXJrellUU3dSODY3VEQ3aUNSNFVJ?=
 =?utf-8?B?T3diRzhSV3FpVzFHQ2I3ZS94b1lTWWpkcWZEMkNQQ2t1c0h3Y1FRK3dWYW5V?=
 =?utf-8?B?RmJKZVJ6dG44cEJKRGhoKzdYWEVwa1IzL2dsNDFsT0F4VllUL3VwSWZXbnBi?=
 =?utf-8?B?K0JLYXpOMU5EYi8zSW0xTlZoMTNFVnpWNlRBNCtYQ2xmN0VPTDRnNllTaTgx?=
 =?utf-8?B?ZkRTZnlvVlR4LzZGUWppc2haWkp1cHptQmUvOGhpVDRRbWs2OTlPYmdnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eExDOTFlOFJkeUh3elJhd3BJYzRhdTIvcElhMVVwUzBxN0FWTzZFZlRMV1NZ?=
 =?utf-8?B?UXZUbzRDcUJUR3hrc3Q3TFptd2ZXdWE1VlhSaW1yQWJUSmduQ1hOOGYwNzFh?=
 =?utf-8?B?dkx1U3V5YklmdktEcDdJNWJBQ0lFcjZ4ckoyRUsyajhtM1Q0MGxqd1kwRHQv?=
 =?utf-8?B?amVqR01RcktnYXh0RDhaQUcvU1ZmK1RjWGZDOFpGWUlhNC9NWGdwV0VYY3B1?=
 =?utf-8?B?MnNVWitFekg5M3FxUHRkZTIrUFZ1b214cWZyUGhsUnRMQ3JWMVl6Zm5tZkRM?=
 =?utf-8?B?amRQOE1PUS96QllwMmpnK0hGS2o3TDZQOXJzVTB1NmRpc055QUcrSDg0eXdj?=
 =?utf-8?B?UUVQOEhMRy9LbFlUT3dJT3h5ZGhWN1ZleStMeUFGR2x1K0RDQ0dKZkw4Sll6?=
 =?utf-8?B?NHNEMnFMNVRkakhseWs0OWV2TTZTZHdzL0lxendaWnVOUnk5WHJWSmFaRVVX?=
 =?utf-8?B?UGp6V3ZJK2VXNi9BTHhQMjArVWFxaHJ5Tmk0cERUZTZKWGlYakFtTmJkWVAv?=
 =?utf-8?B?WkZ6NmVuWnB0VXpxTkJuOUgwL0FDU3hSN2dybHQ3TE9mQldlZnFiWk1wUEU2?=
 =?utf-8?B?RFdJcFZscldUZkVvbkZEWDRlMXhIMTNsMjloakl4d3FHTWwxN2g3SGlIeEh2?=
 =?utf-8?B?TnA5QnhFTksydnQvS3IvUnZtdGJ3VW5IMjk1V1JESW1sUlBzekU4c1RtR0Y2?=
 =?utf-8?B?aDhndFBCL2ZYWkdzalFTUVZoR0VlQ0FqdVRQQ09nVmlqNDhva216L2Zsc0xr?=
 =?utf-8?B?T1J1N0p4enorQm1mT3lQNWRqaWE0RU1GeENRTHVmNGR6MXFzNTdrc3U2OW1u?=
 =?utf-8?B?QXF2N2lUak1RRVFlMlczcGhnVVl0dU5xLytNUzRoVFZxbjhEbDB0d0IxQ1ZC?=
 =?utf-8?B?L3cwbTEzaTVocTB6NER4ZS9DbmQ2UVhTdmFDMHlqUUd6c09wZDd0MlE5ZVZy?=
 =?utf-8?B?N0FiU0JUUFJlTGk0dTdpVmVweEZZNnhqTDlqTUZ6QnU0NGoydmw4V2xtTVN2?=
 =?utf-8?B?Sk9kWXN4SGtBVC8vNlViK0NGcUdWRmNVWFM4b29tb2dmTWo4NndKSU5ZTlFL?=
 =?utf-8?B?Yk9RRzBaNEtQYm9hOWoyQ2JJWEVPbEFPQ3lKMDUxUWx6K3Y5ZGJ1YUdIWTFn?=
 =?utf-8?B?dG53QVpBeTVORUNzVE9Ram9UOE1VeGxjQ3ppbnVMVXNuNWZObnVrUVNOMnZ1?=
 =?utf-8?B?WUoxQkR5WTkrLzdTVkYxYy8yY1RlMUR1dXJPdERxMGRvNm5MdjkzY1o2N1dB?=
 =?utf-8?B?THdKaUxvUXFUSVpBLzQyRGVJb05VQjhJTUVpM3Q1bmxid3dESm5tVlk0d1Er?=
 =?utf-8?B?OTdNaHE5MjNIWE1CL3h0VGpOT0pCRHA4YmZXOU1IS3YxMDJ0RE9XMkRTVGFU?=
 =?utf-8?B?eUVEKzZWdXVBUzNkZFV6VXcrQ0lOKzVraEl1TzB1VnlFTGVLdlFudzVxUGwz?=
 =?utf-8?B?R2pESnhVWUh5OXZMcFBjUzVCcWw4QVlWQnBSSjV4SnBVb1k5aEVibnY3emRj?=
 =?utf-8?B?Zk9GdXhBUERhVkt3K3JNR0dDcTZBWndHQUtZTDFqY1N5bkJOMk5vbDF2YUxC?=
 =?utf-8?B?bFoyMHZxNHY3MVMxV3NocDkvQjRWUDRHdFNWN3pEdU1OckpicGd5QWRCUXJI?=
 =?utf-8?B?MldQZ09NQUk3Q1l2Q3FPTjRvZ1UwZVluNm9hWlBIM3k4bk1iaWVzaENEMHE3?=
 =?utf-8?B?TXZUV0Q1MFFxY3dUYkRJWmZRaWZhcXlFaDZ3MDVDcmU1YVJZS1pLcmRBUElP?=
 =?utf-8?B?M2dCZWF1NmpZbEwwTzQxUWhzZDJGTS93TVlENnlpQjVEMVJDa0Fxb1FMdWV0?=
 =?utf-8?B?QUJ3NlJyVSt0OXJMS2lLOEJwWW1xcEdzK0xlT0pXSzB1N25HdzFEemltNHQx?=
 =?utf-8?B?L1czb3VsS2JhcVZSL3RlRm16Y2tDUng5Ti9DNC9SdTJDMjRnek5tQUNZa1Np?=
 =?utf-8?B?U2V3c0RGY0I2MTRSVHlSUEpPeDA2YjQ1SitsQWZJZjN0d0ZvRHA4WlVVRVRl?=
 =?utf-8?B?c01xa0VCT1FqbDZ6ZjhzMEc1aWJKYjFvYndGSnAxOE5Pd2hKMGJrTWRVdDdp?=
 =?utf-8?B?bnp1bFhDWGlOMzJXRnNXVGVwNnlOd1V3R3BISmVJVklqdmpxbFBGci91VHFW?=
 =?utf-8?Q?MZpXUZYG+qVs4gVx+4b2lBtvi?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cbb91d7f-b191-480f-57fb-08dc7aaf905d
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 22:36:04.1583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N+eyFDMgzYJB1bwZqJZeUGuGmL97+jHHhjvsJfiQ1uk4gzzz2diQhJF5Vr6gZeP2A87Zu6y3r3ZIO1M44y49sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8015
X-OriginatorOrg: intel.com



On 22/05/2024 2:28 pm, Sean Christopherson wrote:
> Define cpu_emergency_virt_cb even if the kernel is being built without KVM
> support so that KVM can reference the typedef in asm/kvm_host.h without
> needing yet more #ifdefs.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Acked-by: Kai Huang <kai.huang@intel.com>

