Return-Path: <kvm+bounces-63418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B7EAC66097
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 20:56:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E9096346CD1
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 19:56:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9365932C30A;
	Mon, 17 Nov 2025 19:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D/Ag8kDO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B062D4801;
	Mon, 17 Nov 2025 19:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763409384; cv=fail; b=p4fd/UI32Assdvnfm3aykLsjNoWwKlVSrjNbAUXE3RcvrmTJUhnaCl9ptHsq3iv0x1MZcBx5NcUgFZY0WYRuKT6IlkWVFYO078eeZdlWkE67W1ZDBqkiDdqI8tqnvalXWxuZEDD7uMgCro+S9eClO/oNLKdg8Sqhqy/UOfUMSWI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763409384; c=relaxed/simple;
	bh=+I9LaIwB9bhFXZ5qA4BibGBwycuyuJ/Ed+e+YV/G0Eg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VgyqCi2By9NTGpByHOII55xWfmQssuE3kVdH6C4OHol3pO+3JNOcNxqPn1t00T2sEBp/jwir8rnDUAC3a2y7bFTmm+VtmxrjpwbthKnIve4rkIN4IH30uyeq1pPXGip81wTMPBQoCOIUnJtHvAJc5m3klQEpY/KNUUGoYG5OPZs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D/Ag8kDO; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763409379; x=1794945379;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+I9LaIwB9bhFXZ5qA4BibGBwycuyuJ/Ed+e+YV/G0Eg=;
  b=D/Ag8kDOeEFMC92/Yp/NVgTR3MgaJ6tyS9jK0Xpb6uPHN40X7YCVdS0A
   3XvqE4AGOH0Zmo2Ex3JEVFuavNRuPhMjgTOYYSbg1rW6eYpJsCY2XDVr1
   BFOLQYtufenMXuoOvbRGyZNR27iWv4yhZ2ymNxZk1VJQTS4T/ooMVvjJT
   GRT/OIl2DbeYQn4tV6xP8RgDCUlpIcNbtO3nO1GiNh1bnq0GM8Z6WcoR2
   uB1vr9qunKya/ShXrvzDIjkouCqfyGo7pPwAAe5bpqr4/GW/rWDFR6gp3
   bdvrEbmulnBkhDs+0/WXLokqkqUi72pCDRXNDdpU10WFUt2nZQ8O3LaTX
   Q==;
X-CSE-ConnectionGUID: YASfohKpQLazG8Ndb5Cdxw==
X-CSE-MsgGUID: y/UMDxIAQmK0tranmsdQ1A==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="76522772"
X-IronPort-AV: E=Sophos;i="6.19,312,1754982000"; 
   d="scan'208";a="76522772"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 11:56:17 -0800
X-CSE-ConnectionGUID: RES4YR7PS86z+nrxIPm9Vg==
X-CSE-MsgGUID: Y20/p+e9QAmL5AzocYuYwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,312,1754982000"; 
   d="scan'208";a="195012836"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 11:56:17 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 11:56:16 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 17 Nov 2025 11:56:16 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.19) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 11:56:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vYBxO3LQvehx9D87tl2YHYV0w05BsVpd0Qr9QOVm1/c5pZxH6VjLdbt7FZ3BJE2vpkEwladrlG7lA3UkwzetXhmL4HbM/uPh2Ng8lpHwRsgQJFVTHpTuPR3i+R5fU6AvNW1Xorup87/oNsdGGnGrLoWbQZGvQ7wc/0T4bsOWk/F7y2N1Oy3QNr9lUDElPtZLpBBhfbhwNKN/5YazgIVZeJnXhLd4VX7s3VkVaveEo/YscIy9sHIBajvfItacSVifNjXJn8wBFVrUCkShWQnR0J7DTDwRxG5r8COeLD/S3IIAkEaYheeVlGBAQuiAfmkdSsjr6iiVbB9wknU27cvanw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+uFwLwU2s26WLnVEl3q/9ImGvOKNOemNd4rG+JE9DWU=;
 b=raHv+ncob+e/n/S3vdmCOnaLDo6jQnvWQaA5uXs6s+x8A63ezRT+Fymh5Hg7akalvXVKxkv+PNYb76v15NDAgIxiXEwV77k4v3d70RPzqdnC+FzxdrVAHuXzFvA2XGy8jzov6ViPL0p0ZUZyDw013Brz1WBT9kFDn2SXzHNkHyJGZi8hwZjIaeMsvavrMacPVFa5hggDLBDJFlcdSxQVURz5c27oOHkR2+AJFBppf5ZqcIwJigoizIxA/qCy6NvFQnBrjvQkSMKQmUfRbq5bNLSJyjXfDyTAHIVPJChQz8OHuU3dv/ygRSZ9DoZuhkDStaZvjZ4/lm6w5fGRdEBGWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 CH3PR11MB7819.namprd11.prod.outlook.com (2603:10b6:610:125::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Mon, 17 Nov
 2025 19:56:14 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%6]) with mapi id 15.20.9320.021; Mon, 17 Nov 2025
 19:56:14 +0000
Message-ID: <c7273e7f-b192-4a17-822b-ec3ee0c80ec2@intel.com>
Date: Mon, 17 Nov 2025 11:56:12 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/10] KVM: emulate: add get_xcr callback
To: Paolo Bonzini <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
CC: <kbusch@kernel.org>
References: <20251114003633.60689-1-pbonzini@redhat.com>
 <20251114003633.60689-7-pbonzini@redhat.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <20251114003633.60689-7-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR04CA0026.namprd04.prod.outlook.com
 (2603:10b6:a03:40::39) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|CH3PR11MB7819:EE_
X-MS-Office365-Filtering-Correlation-Id: f64b0654-534a-446a-1706-08de26135d2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QmFLTktJMlJVRUZ6Y3B6dzU1N204RlVpbEZsLzk2L2dvcFJteG8wNTZab2t1?=
 =?utf-8?B?NDRwS3R4WFNOZ3pNVWlHSGM2cjVWV0ZzUFA4T1krb3R2U28zZEpZSmxWYjk4?=
 =?utf-8?B?akNJNURxbkRVTkJTVDhUUUNpbjdaMmY5akVpTUJQZmozUkVuYkE3a0cycGpk?=
 =?utf-8?B?MGhqanBUQWF1c0N6aktla1Y1SDErOEJzSkJiNTBBcnZRbWdFWFh6THNTSUEz?=
 =?utf-8?B?ODNuUHBvYjErRkZXRU5SMm12Ty9lU2xVQ0RXcTU2a1A4NFJOYW1zTWVLcUJI?=
 =?utf-8?B?MTRhaDVSTUZJcXZ3UGRCS3h6WEhqV1h6cHRlRnhpUnltRFc3dnkyRGZXa1k4?=
 =?utf-8?B?WHZ6MVgvcnR0T1VoTTBUYW5XbFBLeVliMk5yQ3dwSFUxSFl2bm5vZE1JZ3o1?=
 =?utf-8?B?ZzR4bVhBUFM0V2kwWTFmOGZIWXBRNzJJVzJJUXJUWUJSdVdJNFFYejE0V2pz?=
 =?utf-8?B?TzQwL1VvWUZrR3Z2WVhhakJWNUw1bFhvQnFRNjNOV0VMaWFNcllGYW10UTVR?=
 =?utf-8?B?bzE3UzF4dHJxaTlUVTdETG11dW1MU1lJMGVXcG8vempyank0WmVZdTNvQ01W?=
 =?utf-8?B?S2RPakorWE1jUzdlSTZQRmhOdUlNWk5jQjJRa2QvcjlzSmNERW1tVTN5U0NW?=
 =?utf-8?B?ZDZWckVMQVRTYTJsZUtXWnFMbE1uaHlab01JVDgzWXA1NUIreFRoT3NEcFE0?=
 =?utf-8?B?c291a3RKMTFNajIxQnpCaDA0bFQ0ZHhYYnpMSmJLaEF1ZG54NHc1M1RIclk2?=
 =?utf-8?B?QzJSLytZTFYxNXBpWmExRkRyRmdRWXpLY0dxQTFpWTkvOHNUWndOcXFQN0NQ?=
 =?utf-8?B?eUtRS1MvaU5PalZUdzRyV0ZkQ2hlWmQ5a2NGcHpFU1FKVXBVNm5oRC9jQlBC?=
 =?utf-8?B?SU5ocXJSSml5WjZ5cUJsajdhOEptVkZwcWMxTW5VdTE0dWNKRDBHS0tUTGVS?=
 =?utf-8?B?NG1wL1FRN1FPNE55VjdPdHVsYk1XMjJtSXI4ZFB2NW9HRE83QlorNmpqRzNn?=
 =?utf-8?B?UnRSYy9JVU9ZUytiT0dWejVONW51blRaZTl5ZzMwNW1oY08zdFdEQXV0VnVL?=
 =?utf-8?B?THhUcmxpd2x4WWphc0lNNUZlYmJGYlczQ25oNmE4OThKMVFaMkFrakI2WURa?=
 =?utf-8?B?Rmh4c016WmJHMXFPeDNPRndERjdnbjc0ekJFWHJtM3I1THVQd2VLNjE5Vmdm?=
 =?utf-8?B?bEV3YVhtQ1hSYnUza3hGdEVmeExHay9QSjZja0g3US9YSWc1RytScy84TCtO?=
 =?utf-8?B?WWZzcUhZcEJjZmZmYkI5dWhQSFluZUxiODR6M1ltOVA1dzJzbnNpUGlkb2xF?=
 =?utf-8?B?by8rRitxeTJ5NVZ1elMwUlZYT3pqVDVYdU9Nck1VbzRwZDdHKzhwT3E3aE1W?=
 =?utf-8?B?bk1raGJNMUNGSjdkcHl1VkgrLytpdTF3eG13WUh4STMzUFd1akpGalJhOVBa?=
 =?utf-8?B?emphUVNmTjcwSWh0UklqajJWaWVzMjJmMnZncW5zcHhycW4vSk1obml5WG9Z?=
 =?utf-8?B?RS9WcS9Nb2Z1S2xxSkdmcmVSbURtQS9NSHRNR3VtTDVBTTJHQlVvN3BqVlN4?=
 =?utf-8?B?clJodEhSTmVmZ3NNbnVKSldpZVNPcCs0MS80ZWF4Y1ZJOFgrTTA2MnpnUDdD?=
 =?utf-8?B?VXc1UGZJYWN6L1haQ3VJdCtFRktQS3N2YnV3djF0VVo5QnNKUndZQXQ1WFd5?=
 =?utf-8?B?YUlSeFBvVVVYTkZhbVRZMTJ1S2xGc3g3eDdtMVhVQzhNQlpOZXBSY1pjTlZY?=
 =?utf-8?B?Y1kzTEpHTUFtQmYybGhWT2pvV3NQcGZuRkVrbmNZNlgxNkNNSWJMSTlPenpo?=
 =?utf-8?B?dmtTdkFXQy9tUUlhdVJjMUNGbnpHM3ZkY280RUJrSDlQTlBNOUpJZi84MWky?=
 =?utf-8?B?VmxaTDZ3TkQweC92MExuYzA0ekZEVHN3NjNqNUtPV1JJaVFPdDJReER3WDdN?=
 =?utf-8?Q?+uUvP884bdaMr9lUkKzo2lAWyE2hbWp9?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YVhtUnRyTnV6cnlzZVNpeSsyRm5TRkRyYzVVY3dKZHZCWVI1bnNqMDQ5NG1V?=
 =?utf-8?B?ZzIrMlA1OUpCbDNUdzFGT1hRYURzeGt5c0xUdFlWSnNsaGwvSFRLTTFNOTZa?=
 =?utf-8?B?bzZQZk5SYUpWYzdwS0JIUUlTWUd0ODlHYzVRaHltQjAzTDFZTWRnUE11eHo2?=
 =?utf-8?B?dTh1SG1RQ2U3dVZ2N01KMEJOMUVqZ21OZVVMbFVhTHBhblVxaG9PakRaTUNn?=
 =?utf-8?B?R2Y1bTlnNkZnaGo0MGN2T01rbDh1NGFHTCtkSnJuSnRPRXNZejZ2MDNab1M5?=
 =?utf-8?B?MkNTZ2w3Rm4zMTlmdzd5SjVMMzMzUXVuMUYzeHBCZ2t5V1VMakdOV2NxcUN6?=
 =?utf-8?B?cDNvYzU3UGpZb0dRS3I1VVJra2V4d3Z2bFFEZ1RzMHBvOElrcmtVNTZmMGxT?=
 =?utf-8?B?cjZOdjRrRU9qblJ1c0Z0cThzQU9TNGx6ek9BN29SZW54WTd5SW9zSXQzODkr?=
 =?utf-8?B?ZmVMVUlZZlpMbXkxSnhTT3kxdDUzQ1Q3RjNiWSt5ZndQRnB0cVlMeERDNVM3?=
 =?utf-8?B?ZXZGUkR1Mm5yOTlJT0ZhOWFaSFM3dmowTmVybC9oSzZsTFkyK1l4OFBoNXBo?=
 =?utf-8?B?VGdYMStSNlpVa2xvZGxpd2NCdlhCalB3cFgwb0JvOHM1ZGpOcnkzV2tLaENq?=
 =?utf-8?B?c1NwaXZodVYxcTBlTG5TWFROcS9rRnNDQjk0NXI0VU40TW1FaHB6UkQ2VTM0?=
 =?utf-8?B?OFdtZFNwVWdScGZ0V2tIZWxGMWFxclNzaVM5dzR4QTJacy9sNTJmRWROZGlx?=
 =?utf-8?B?TzhrMHgyRU1JQVlVSHFNWlR1ZGpqZDJXNlU3ODUybDV3NkVGNXVEcVNHWUVS?=
 =?utf-8?B?ZVllNXY3YjBVU0lpb0UrZ0J0NWlLMGhKTFVndmxtNFpPK0c1TzQzZW5KandI?=
 =?utf-8?B?NU5wZHdRV3Z3N1JZMWlkUTViZGN6NDlraDR0YkJETXJGemUxOEZ5WGFrWlN1?=
 =?utf-8?B?NERSTWhPcGRZTnRMRWxPVzNmUjE0Z0hRZVFITWtsd1FwakRwQlNwWW1BYVdQ?=
 =?utf-8?B?cy9iVHBCemdwMUpMTHdBeUNlQ1JicjZZUWFaeUxIa3hGUXBoODdSQ215RXgy?=
 =?utf-8?B?SEdJcUZ6UUtnd2NScFpVU0lWN2I0ZUJlUDQ0S1pDcXNaMmxwUmpXbTVoek43?=
 =?utf-8?B?dS9obUpDTWdPbW1qOThXYnB4alg2eFpZYTY4QzN4WS9HZUZRMzcrQ3pSNjR4?=
 =?utf-8?B?WXYrWjJ5K2VpUWpXcklBK3o4MDk4VEhwOVJxK3FmOEVuWW9ORHBkVnluaHZa?=
 =?utf-8?B?MWdKdGxMT08zOGpqSy93VDFiM3JUTHFxajNQVEpYem5BTTdsTGFtUFo2RzZO?=
 =?utf-8?B?d3R5T1VJZzRHbk9haFk1a1p1S2JGTmtpTTg4OWRZbE1NaUs1L2dNWk9kekZi?=
 =?utf-8?B?RGpJZGtCcnhxaWd3NGpNTHlIWWhldXRyd1dQNUR2ekI0cUprQUZmU3FZakZJ?=
 =?utf-8?B?ZUNTRXZ0bmExcmdzWmtIZWRzeWdKaVYyZjcyMW5MdmdpdHlHVU9lWkxMZDNL?=
 =?utf-8?B?WXlYQ05OUVN1VGtGT3orcm1ROXVIbCtDT0ZYRlBzdEM3bXplRDFkWVZvUjJB?=
 =?utf-8?B?RVpXTU5IczFvaHk3azhSWldramlBbmVwdG9yRlh6Mi9hMFRzMDdQbVdjSTRp?=
 =?utf-8?B?dXMzMk8yTXlSLzNMTEwrdENZVFNBNGVtdE9kcGxETzhOKzRpN042RXRtN2pa?=
 =?utf-8?B?dTRZKzVkbVRETEE0V3hrVWFaOUNiWVV1WkZnbm5BN1N6dlVVVmZTRVlzczVP?=
 =?utf-8?B?aUt5T0tUL2ZXNTlhR2pFLzVZdU52ZUc5OHhqYklMR2QwQnZ5OFk4ZXdwTUcr?=
 =?utf-8?B?alBqL21pZlB4TWZsWUpMVHdGNlBCalBiVVVHZEJXdkRtY0hva0N4Z2dkYWpC?=
 =?utf-8?B?eHR1dFF6QmtKYW5hdWFqeGtuQUVOZVdRS0g1YTdxUFlsNjh4R0N6YlVmdnBm?=
 =?utf-8?B?QS9nWHVWY3NsTVA3eEZKQ0s2ekUxUENoeS9oVjU2US9SRnZUai9BZ0ZvYnB2?=
 =?utf-8?B?L1cvU2VBVXNNOXFVS0JQNnJ4Q1QvdHgveHhlMEJEVC90b2phbFNtNWR1aG11?=
 =?utf-8?B?L2JoOWNrZWZRYkx3NkNkZFFKRFdLdnJvb3MrRDViY0l5U3UrNHMzUFR6MEk2?=
 =?utf-8?B?R0h1ejlTZnE4R2ZSZFl1OU16WWh4b2pkK2owNTR2dXlTUk9YUEJsVDZqS2FW?=
 =?utf-8?B?aFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f64b0654-534a-446a-1706-08de26135d2c
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 19:56:14.4091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HJJZL/QtWm5Ua18ofAKAiKsoTmpb5Mbx3K0I8n9PfgN7uqgmf62q6saQvs+nnT/51rcgof59V4TLMfyMUvUamS9ovV6SBV8b4Z4qRbJRG6A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7819
X-OriginatorOrg: intel.com

On 11/13/2025 4:36 PM, Paolo Bonzini wrote:
> This will be necessary in order to check whether AVX is enabled.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Indeed, REX2 emulation support also needs this to check APX. Thanks!

   Reviewed-by: Chang S. Bae <chang.seok.bae@intel.com>

