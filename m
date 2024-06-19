Return-Path: <kvm+bounces-19923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8885D90E342
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 08:18:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A6F1728262F
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 06:18:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4D1E46453;
	Wed, 19 Jun 2024 06:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bB08cZay"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCBF06A8D2;
	Wed, 19 Jun 2024 06:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718777867; cv=fail; b=sVXZzL115KRpxSWcsfMj9qNRep4aBP7sUbZ56TA12AQZ0nQymtycbCQnoWjyimKGMEbRtZTt3lYoofUrJt68i/PWeP2PLrLfcFhap59Jzr7kWIKjTn5Cz5V10yZ0UphrPEC48lt0hdheWzSwL7t60s1EJdM+s2Cbv9LGa/w+2Nw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718777867; c=relaxed/simple;
	bh=U57D/lv5ZtLA1etlAzY4pw3fNqkIH1SGjhshBLP8J7s=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HfNUScKwJlO3mZg1TVsmbvMMc9wQNWqsWYGht0e0dsGX0Xm11FhIt7TcGQ1UVsQzhAAdRI7sPh/9c+48ybe7vyXfV28oCPv/NRh1jr6rfK1E92S28gnv9Z0r9z/IPbzKVBxUkWRu5pnB3EFrPOz4Fz/E2UFASfu0gVfi0e5Dnvo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bB08cZay; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718777866; x=1750313866;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=U57D/lv5ZtLA1etlAzY4pw3fNqkIH1SGjhshBLP8J7s=;
  b=bB08cZayRay0HAM5CH5ZJG3QwEo7qHKll8cUwNokc1Lez6qoLMLnlj0D
   /ItTtfHAG6fD9DOP33WsWxJfdehX+fiWtYuuzH3OAJKgh9vJ87H2/rvdf
   hBgYpwKEMFCJixtKxpC531YpyFZlej/xP79W5lK9XHC5GCa7UXzZgB37q
   FO/SktOhcXUFmNi2Hu3QeRMe2E9DNt4PNgxgp7tTbDizMg0psaIlEk2GX
   V8z/kx8WUv2NjFIZ29YV0ydbvuPX3czvozzkfB3jA80auWIPl5Xi/QfnX
   i4gQ4RSv5L9eIQntGTUcrXucs54IRxounWyadWBg4ZY8qa5R++Hb3FhtD
   g==;
X-CSE-ConnectionGUID: bNJv32BoQKGeXrINN0TO+A==
X-CSE-MsgGUID: aybpakgMTcmBv0sJU9a2Xw==
X-IronPort-AV: E=McAfee;i="6700,10204,11107"; a="15837562"
X-IronPort-AV: E=Sophos;i="6.08,249,1712646000"; 
   d="scan'208";a="15837562"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2024 23:17:46 -0700
X-CSE-ConnectionGUID: vIO6r7JARBmXzd0XFXoLOg==
X-CSE-MsgGUID: uYX7fh+lR4azmmsvXg/Utw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,249,1712646000"; 
   d="scan'208";a="65039895"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Jun 2024 23:17:46 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 18 Jun 2024 23:17:44 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 18 Jun 2024 23:17:44 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 18 Jun 2024 23:17:44 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 18 Jun 2024 23:17:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P/LTOePpor3adWTPmnS0cr8KnM0bU8Pmpu5xd10bw91gO4A2CBw8bihCZZgvWktgmYF7GPuISgD3+JL/L8BTyqaG+3c8wURPFH9cMH/ReSSkhixO1HRn6MtT+W1LShl66az8xvsRIoiIUXtZ+wSrifMJRXeMRpWG4dDrXAs4SYWKwQT80cRJLvtLpc91K00JFC6uvSeiBIESyGg0coEsVMmW3EQDMVgOAItyi215OPCDUgnrHGGmFeWJvPNA0WS4UpN4nUP0LT6z45rK+hy2MPAYf7vP9KWsEQGyq8xmcoqeJZRL1WNIMGiAk6QBwb4jPjQ2qO/fPFJS3aP/EoanPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gH7TTrWgqhbqk7Kd2PLrrFtaon9T9NjLRPjsm567Sqc=;
 b=BabcOK3Y8NGb/96bwej/wb/3kIvsiO9buozu6Pez6OMt9wf7J5s6fatKoHhLlLDqLKUhaNp+HZVIriryeW+ty5LAMaSkqTzqJImLStn+nzWaR8Q/JohADEkxgC+d3YDIf3hlF9rTJPg0m4pa+GRadneuqkKCBwi6QfDUjXYtnh6BUQNo/RxV5q0AOriwzb1iMXGejR+nvBFke4ePOIQXxmBOtAOZxI0GCEun4X/5N50JM3j4O3FUsUJOMgER4E3wP9p2KHQMSzuQ8Adndew5Cg6aFaYQTArdZ+36MECIceCzie32U8F+y0CuYvBUEPHi9gkgK3DFX3W6MMH8Q/LtZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by IA1PR11MB6171.namprd11.prod.outlook.com (2603:10b6:208:3e9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Wed, 19 Jun
 2024 06:17:42 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4%7]) with mapi id 15.20.7698.017; Wed, 19 Jun 2024
 06:17:42 +0000
Message-ID: <cb6e3c03-547b-4223-8dd4-3bc2e4fd4dff@intel.com>
Date: Wed, 19 Jun 2024 14:17:31 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 18/49] KVM: x86: Account for max supported CPUID leaf
 when getting raw host CPUID
To: Sean Christopherson <seanjc@google.com>
CC: Vitaly Kuznetsov <vkuznets@redhat.com>, Paolo Bonzini
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>,
	Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>,
	Binbin Wu <binbin.wu@linux.intel.com>, Robert Hoo
	<robert.hoo.linux@gmail.com>
References: <20240517173926.965351-1-seanjc@google.com>
 <20240517173926.965351-19-seanjc@google.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20240517173926.965351-19-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR06CA0008.apcprd06.prod.outlook.com
 (2603:1096:4:186::23) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|IA1PR11MB6171:EE_
X-MS-Office365-Filtering-Correlation-Id: 02c2ed02-20c5-4ff4-d37c-08dc902786db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|376011|7416011|1800799021;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WTFCbE05TnQzQ0xyS1pjZ1lQbHg0dXU2NzRmWStON1IzN0ZtTGw3dHNVWktq?=
 =?utf-8?B?aGlBZjljVHZzSDNoODMvNTZ5Q0V4aktrUmZRd3pBQUhMRmN0b3Z3M3RnMHpP?=
 =?utf-8?B?aTdkeUZhM0ViMzUyQjlaTUZ0OFRqcmhxdmFJc1d5UTNYMCtlby92WUVlbndi?=
 =?utf-8?B?ekdCRE1RTlJWMVV0bVJ3RmQ5QWJjTmMrcmV0TnJFRWxVWStUZmhCM29uWjVw?=
 =?utf-8?B?cmJKaEhEVlRwZXZUWHNBV04zWDR2c0plSlVpdUJ4YkJhc21OVHpFTldaVUx2?=
 =?utf-8?B?am81OCtNTDJnSzdQVlVGblRyZzFhM01ya2dFaTgxN04vdjRqaEREZWdPOFpj?=
 =?utf-8?B?Z0lxWVNBb2lsTDJJaExJbjY0S0tRcm5mZEhpNFRnbjB0aE9sUlJhUnBIRjEr?=
 =?utf-8?B?ckp1KzV4TitzSUkxWlZLd0lIYVNrSktmMkMzZ3Z4ME5XK21lUytZL09QT01I?=
 =?utf-8?B?ZkdqVmpZNytZWXdqK3NDMzlTYU5FMWM2WXdTTnpRaklmaDVIcVFmRjFVVWlB?=
 =?utf-8?B?VThRcFJDVjVDT2poYjhvakdvditqaDRoQVdNRTRQRU9vWnpGbnNhazY4dDVa?=
 =?utf-8?B?bUZXNHErcjdNQ0VEbkxaWGM2dzVHQ0pwYTVVSjBoQmx0YUcybG5QM2NkNW1Y?=
 =?utf-8?B?RUJOUVdrdUZMdUNURHY0MFBGVDBoM3dHbUREZllMeThsWEFYRk9MdnNYcWZ0?=
 =?utf-8?B?SnlyMitoVUM3N2ErZXhCdVRkQkZkYkMzbVJIbGRKd3dERnpQY0oxS0VON1U2?=
 =?utf-8?B?WnptVU5GQm1TNjR1OU1tK3NKQTJ1dEcwSysrRndmNnlUUWh2TFZILzVWZnQ4?=
 =?utf-8?B?SFJmbGpiNy82TkhoeXY4bXNFSHI0bExHQ2xUT00rWmVhOHlhR0J5dzFRZVVW?=
 =?utf-8?B?NStCV0w2T1FMbE9mYUNaK2w3R0RtN3JaYkFHMEhwcUNnQlEyN0tSVmF5TGZr?=
 =?utf-8?B?aFZGWitiWlU4TU9RcmlaUkNhNS9SbHd2N1E3TDd2TEFLYkw2VDFpMEs5V1Iy?=
 =?utf-8?B?NDdDL1kreWx4SUg4bDNmMEUwQTBZaVpkV0NUZGJMT0IyQVkzUU4xQm1oUTBz?=
 =?utf-8?B?QTF6OFVFZDB5RGNrTkl4WWppQlBDVU1TOThiSHZTZzkvSkNkclBxeVVibW1Z?=
 =?utf-8?B?V3ZheWo4L1A0UzRJc216ek0wTTJRdGdWV1hST0F5Qm9rMmt6Um1ZVncyZ1ZK?=
 =?utf-8?B?aGdQeDRFMTJVRzVqZGxaNnB3YlZvbitBeFNZa0ZlM0xCSFdXeThKQUEvdHM3?=
 =?utf-8?B?UWx6dlJhdnJwWUJqYWlmeTc4eWE1MFBnbWl4ZDFvb0kyWUlKdG9JbXVNZUZQ?=
 =?utf-8?B?QmhVSEpVK2JUOWNDZHNiNUpNNUhTVE9NSnFNNTN1U3RpWUxueXBkRS84RnpL?=
 =?utf-8?B?TzNqVWVna3FLNXJpcWxpakRhcEs4ajVxL1VONVRJclhlalI0N092Y3BsaExS?=
 =?utf-8?B?S1RsM0xHVXlmQ2hMMHlGbXZKdG9GdlNRdXIrSnUzOGd1RXo2ZExuOElHVGM3?=
 =?utf-8?B?TWNWRENHOGpyNS9pOC9qUXpHeE9rNllsZ0xIeE84NENEby9uNlkyY2RvUHRa?=
 =?utf-8?B?MlJSTit0ZHRvNEk3RXFid0Yva2tITlZPRy9jblZIRTJ5cmpGZWdWaHByTmd5?=
 =?utf-8?B?OG9DVEY1SDRhQW5ySnYrY2gwNTIwM0JoNVBIV09pcmE3dFlpaFV5c0I4eE9l?=
 =?utf-8?B?b0V0WWttSnlSZXhwMERLc1JRa1owZmQvc3hlNytFV3M4NDNBSWtqTWJWMU1V?=
 =?utf-8?Q?t8m83qzBEx49qDaCXJ/9rBOtIOuRTqVn12h7dJJ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(376011)(7416011)(1800799021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RGhFYkxveWlMbFJoTUxDNGNyVHZvc2IzNXNaRzg2V0ZlMUlpOHQzTzZ1dVNi?=
 =?utf-8?B?VW1mZVIwL3BnK3ptaC8wQ1FNdWM0M1R6NkI0elo3aEljZG9zREdLMUhsVGlt?=
 =?utf-8?B?S0JUQ0NlSDM4cTNyaW1jd0NZTnA2d3R4THgraUtKMDZrdmhOc0E5ZnFlMEll?=
 =?utf-8?B?eXZ3WDhOYVB0cEtOT29EUys1MEUxUFc4MUVDS090OUlSNDYrbWRoczA1YzUw?=
 =?utf-8?B?L0dKV1RjVWFGQ3FtNm82OUlDSWswbGRXYTk3Y2FEOCs2SzNOOWVuNlhZNmlM?=
 =?utf-8?B?ZWJmVGVTVzh0Q3NUU1V5b1hIWUxLNEs3VXZnUW5sWXR3ZUt2MnQ3QlBBdndG?=
 =?utf-8?B?dlJUZGRQbWp2dGZ1MkJZdWpva0lyUFJKZHlrSjBvYWFyQVl5QTRjU3JUOTg5?=
 =?utf-8?B?VklmTW5FRGFvRUdVdTl6dDFvdStuL0FQcmRqeW91NEJ1T0EvSzFaZm9ObEMx?=
 =?utf-8?B?L3BtTG5SSms2bkUzUm9yaVFkWWYwZ0xiSm9RaDc4OXdCRmxPZlFOd0FHS3RZ?=
 =?utf-8?B?eTZ1czFKak80ajZma0thMWExcDBmRk5BRGc4S1VnTDJNUUFVRnJuSjVTV3dh?=
 =?utf-8?B?TnJ5bjhoaUdVem80UUdJMHBRZkhqeFQ4djFyN0ZMQ1Frd29PMVpMbk5DK21D?=
 =?utf-8?B?Qjc5cWJleUdZNmhqL3VUSlJ4UGQxUmhQUzYxd3NGdHVVcmlHVEo1Z1FCQkRG?=
 =?utf-8?B?Y3lONkgrU2JiT2gvVzlxK1kySW1nc1pDNjUwUDVaMjdQQWdMTlROVTFTN3M1?=
 =?utf-8?B?bFVRVytUM2dzNHZ5dzh2ZmVCTmhXQVhJM0plYzhZY01aUzZYaGx6RXhpbkZW?=
 =?utf-8?B?YnRHRDNHbUxGL0NGbWMwL1ZFb2JUNHA3ckZoQzZBZjNUWUtxMVFJaTJTS1hD?=
 =?utf-8?B?ZVZvUDZ0S3llcFhyN1FrcTBqakYxREdrQnQxalpvQkpmOWVjZGMwY1VMRXlt?=
 =?utf-8?B?QWFncXpnSGpBSHBveHhpMzZmVnlrNjNxZWJadWZtaytvMWk0VXJvbXhJQXpw?=
 =?utf-8?B?blFERVdKNTN5bU16c3VpWTUzSlFxNENKWWlyWnFTZ1djUEZ3RTdaTXZ4aHJv?=
 =?utf-8?B?eFAxdnNXMDR6VnFBVkhJZHllTjVMVjNFQWhGNHlMa1lBUEx2QTBGSXBsNVhG?=
 =?utf-8?B?am85dE4xa0NOd09HdU1tL2VSbExEMXpGa1dibFNLdWZja01WY1o4M0VmakZ6?=
 =?utf-8?B?WHQ2WVZ6YWtMYTBuaEdEZFEyQXI3RGpkTzlOOXVpcERDVUMrdHZqR254Wkdp?=
 =?utf-8?B?NXFGY0t2OUl4Q3NVRytEQ0RvVWdFeE9RMk01UGFSMm5RcXZnbWN4elFiMnZQ?=
 =?utf-8?B?eEt6aGZaSDZOMTQ2eUc0Vm0yWktEc0xTbCs5Z0g4SU5RSUVQWGZIZG0xSmlU?=
 =?utf-8?B?WDY2SGhBcnE5bWErdERyNkU1UnJKSklYS0VKQjE0azRaa2NUbTVkTStXKzVj?=
 =?utf-8?B?L2JSUlJsdUcyanFwcjYvem5WTk9oeG1WMVR3aXNpZmxNa2lGS1JDTVA3MmFU?=
 =?utf-8?B?RHM0b2NEa1BGdnBVYTdzRklSMmtyNWNvdFV3Y2JZa3pWM1U5VEgwL1RTc2Y0?=
 =?utf-8?B?SlZxTDdPeHRINDFMaUZUYk81LytJZ2tiSkV6YzhaWWU2WkRNUlRvL1dVV0lJ?=
 =?utf-8?B?ME4vbXo2TUdoeHBtZkRkd2lBNENsNHB6RTNqb1o4YittL05pS2dsV1lvTE03?=
 =?utf-8?B?VjBmZjRNSzJnZHJENGtyU1loT2IyTUF6NXEzOTVSK0RtOXQ1TlVScmlQYmNY?=
 =?utf-8?B?ODcwa3lWOTl6N0NGeU9ScWpTcU5sczY0bEEyVFhKbFR6SG5XajFFbVpxK0I1?=
 =?utf-8?B?YXlxNUE5TnNIMUpFaDZVZXk4ZThvQlowOTZXS2pJWEgvZDdBQjFURGhpTHNV?=
 =?utf-8?B?TzFpR3dWWHY3anRzbURGN01EWGQ1VTlRQkFNMXJBektueGRYOTFka0FNWmdr?=
 =?utf-8?B?QlpWZUlJUWh1ZnhidnlHaVRnWGZGSFp0OVRHVEJpcUtZcGFjZmlvaDB0RW5B?=
 =?utf-8?B?cUlOVC9EYUJuMVBqSTJjZExoWDhmVEF2TXNNcjBkTU53WmhWNnErd29DWVNL?=
 =?utf-8?B?TmRFT1ZtWTVjNlhOZ01PWlJxUVBlM29CckFTa20vRkJCdjNpc3BDd1k3L3Jq?=
 =?utf-8?B?dWdnZEhCSFNvMTNZWWRFNHZQWWJISGNjT3dIdkh3cFJoR1IyOXpwcllleXZP?=
 =?utf-8?B?WVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 02c2ed02-20c5-4ff4-d37c-08dc902786db
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2024 06:17:42.3478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tK0Qgk+rnUCHWCqkRxuKVnoAK9cSp3FZUylwJIdnSYCQBzav2DgylDO+SkAcnV1r1Lj8MGCzjxSRF4bCmsFLuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6171
X-OriginatorOrg: intel.com

On 5/18/2024 1:38 AM, Sean Christopherson wrote:

[...]

>   /* Mask kvm_cpu_caps for @leaf with the raw CPUID capabilities of this CPU. */
>   static __always_inline void __kvm_cpu_cap_mask(unsigned int leaf)
>   {
>   	const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);
> -	struct kvm_cpuid_entry2 entry;
>   
>   	reverse_cpuid_check(leaf);

IIUC, this reverse_cpuid_check() is redundant since it's already enforced in x86_feature_cpuid() via __feature_leaf() as previous patch(17) shows.
>   
> -	cpuid_count(cpuid.function, cpuid.index,
> -		    &entry.eax, &entry.ebx, &entry.ecx, &entry.edx);
> -
> -	kvm_cpu_caps[leaf] &= *__cpuid_entry_get_reg(&entry, cpuid.reg);
> +	kvm_cpu_caps[leaf] &= raw_cpuid_get(cpuid);
>   }
>   
>   static __always_inline


