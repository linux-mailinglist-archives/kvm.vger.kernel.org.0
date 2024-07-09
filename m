Return-Path: <kvm+bounces-21146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78EA392AE84
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 05:18:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65BF428366E
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 03:18:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2133144366;
	Tue,  9 Jul 2024 03:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cgjIomT+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A5678C83;
	Tue,  9 Jul 2024 03:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720495096; cv=fail; b=WbHzCefcRhYQCLMD7GnShxkvlI92kXW4uvl0h5UGRAApi/QNY0dTwZ+yTWWS8kOyN7Sqaj/yFxjFASpBd9vIlIRhfvnkgc1/e8Z5p2kT2qUa1nuz+2vt3AxMTief1l6J/9o75dLu0bmZyYI2b6ySpzvLrZSy5s0V+WD6JaBO7/k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720495096; c=relaxed/simple;
	bh=q5MDo8X3gVty9M+N/nQ3g4Wun2DmoX5RYlyCEiN/h8Q=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HTsRLush4HqFDBQD3uH47QVyIWE2jeYBCM9VHZr1ccBdmFw+WWXwOxUSH715atzTQArAE7nuXQ2bVJ55VUGpfqb5uSr5WWSQfW43/r0JmVLGEtDEYXTIjRskI3x5Lvk0e42nDaVdZKu8To+w27qJPEdbIlpRKl2prPsF81mkTC8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cgjIomT+; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720495094; x=1752031094;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=q5MDo8X3gVty9M+N/nQ3g4Wun2DmoX5RYlyCEiN/h8Q=;
  b=cgjIomT+5GnySVgvhVHfNn/UqNY0Idxv0olatmHOvhn6lqWXU7o7/z0a
   QRph7M9rTIjdeAW05ltr+KUvB6353E48wsDd/FLu3yTB5j3CuLnrCdpB5
   Nc6tYuhhti5RmHNtDf00xFUG+2+uukaSZeEtKBVUJN+A4aLdPJM4W0+pj
   pT0q85sP3mvCjF9MXQp7be2M+QrM+H/A8zz9sT/p529yF7eu192E22J5E
   cNJK1EkfzszqLLLssBEMeD3cwYlst9x55BW7wLwzxB/Es/i7kBr9c/ejY
   2cjXePBZiniHw8q2DJcB0yW4p42CU1wjfVnafsMVzoFr2F0oqiVoSmsfA
   w==;
X-CSE-ConnectionGUID: F6cMG3ZGSlWSNx6fWfgnCw==
X-CSE-MsgGUID: LIKRCnlMTuOVqCjxBm8g9g==
X-IronPort-AV: E=McAfee;i="6700,10204,11127"; a="20625045"
X-IronPort-AV: E=Sophos;i="6.09,193,1716274800"; 
   d="scan'208";a="20625045"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2024 20:18:14 -0700
X-CSE-ConnectionGUID: GPO/IQ+pQsKHMRMVNN25mA==
X-CSE-MsgGUID: s5RNpaYjQgCJCRP6DBvoiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,193,1716274800"; 
   d="scan'208";a="47669743"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Jul 2024 20:18:13 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 8 Jul 2024 20:18:13 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 8 Jul 2024 20:18:12 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 8 Jul 2024 20:18:12 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 8 Jul 2024 20:18:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aBuVqneTtCv5p6fN+wluUULoA9k52qCLvqH9HXEPygbmy49y7sVYIDkaKfv4ep2N6VvQzaXq5tJMM4qM57DEpdFo5FG0vX7xDlccv34u1I6VA4fMDp3gw1cbmAP1baki4mCtxitXbkMClRz8RRHd3f/NkhbhI2XEviqAUHwVE9bX5ZZQgp5H5vA8QRD+FPdJd02xkCUyeKyrschNln5oTx5PRynWthlSRkcgt21uJAa5igm6WsO9d5D6zr8L7C3NrelT+jGXOh44bvzayyhds1+pRJmjXcHcT8pVLKvdyRUpiqWESpGIyZmzvegDL+GaTr50YXxyZatnzywCqsIHRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q5MDo8X3gVty9M+N/nQ3g4Wun2DmoX5RYlyCEiN/h8Q=;
 b=iytdtB5E8rL8DSNucJo+ZyOvQ+VxWf+VGLJwRjpGajhu76uXjQQF3huowWMOnej94Ct2OaVVsCrWuWN5PHUcWjMoIeNWVhkRFv0jpzlLsAZ5thCYeE760MewfIhWyjGAeuwO2SpWuDrlSEud0MGFQxV+Isu0ZC0CApVbfh8uMMA0TiqwHGFsWKnxN5eqEa8x0DbLl02xT0dKJTHgBEXcaqHgJgYHbBSCwYGoI2hx1lMj8Q5teuKwzM+IODpQdq850ietIqWcFhg/97PTy/Blpmg689tQj6Pr823VKtxIrqiEz7wiKlLZevKH1jK/K9UW3v47yFZG398dMhS3HRQjiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DS0PR11MB7357.namprd11.prod.outlook.com (2603:10b6:8:136::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.36; Tue, 9 Jul
 2024 03:18:08 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4%4]) with mapi id 15.20.7741.033; Tue, 9 Jul 2024
 03:18:08 +0000
Message-ID: <67c5a358-0e40-4b2f-b679-33dd0dfe73fb@intel.com>
Date: Tue, 9 Jul 2024 11:17:57 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] Introduce CET supervisor state support
To: <tglx@linutronix.de>, <dave.hansen@intel.com>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
CC: <peterz@infradead.org>, <chao.gao@intel.com>,
	<rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>, <john.allen@amd.com>
References: <20240531090331.13713-1-weijiang.yang@intel.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20240531090331.13713-1-weijiang.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0004.apcprd02.prod.outlook.com
 (2603:1096:4:194::14) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DS0PR11MB7357:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a2d0b79-6992-41ea-d340-08dc9fc5c111
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SUVQRkQ5dENyUVF6VjVIVWhDSHJ6RWlWc3Zzb1ZUQ0k1dkZlVlRXWGVKRGUz?=
 =?utf-8?B?L2daOVVpcHpBTzNnR0Q3dTZNUkpSTnI5N0t3ZDVHWGNESVcrc3k3MmF3Tldl?=
 =?utf-8?B?aWRmdlFYeEZ6eFpqcDBRLzB0cEdBU3JEOWcvOUtIa241WXZlU3RqbE9FNU16?=
 =?utf-8?B?aktWaTdZenptdSs0NVhjOCs2TzVBY3FrUVFDS0ZJUnVzZmJZSDY1TTQvcVBX?=
 =?utf-8?B?Y3c1dFhHME56TmpzMFpTTlJ0L1Q3cFptQUQwUkFYZ0xsSjkweTRzbU1OZjhr?=
 =?utf-8?B?REVNYUxpVzRGUTNCTUtFMkxjWmgwVEtPd0NBMnFhUnJWTWsweW13ei9vU2Fa?=
 =?utf-8?B?aXM5ckorbjlLQ3RDTExENVRCYVp0bVlDUkQ5NjhvRnlKY2todi81U1dCSFpO?=
 =?utf-8?B?UFFUbGk2bEs3SVlqb2xhK0NlSWI0SDJlSVc2MGc1T1g1S0svbVBzdzV2dWR6?=
 =?utf-8?B?UzRJQ1JpamJnVStwdjZWcHUxbkd0Y05Rd2s0MTEvSHZ6enhsM0FONE9TUmtn?=
 =?utf-8?B?VHV3ZEIybDdGMWJmTEprY3I4VGNob0Uvd1NrMytzNys1OE1mUENhN0lFL1Fz?=
 =?utf-8?B?TWFLUzQ1QTllY3hpYWRtTUUyc3VmOG5MdmJvYjFZWCtONmQwemNYeWdtWFVY?=
 =?utf-8?B?N0xpVEJxNlpGMm1DY1d5USt5emcvUCttWG5abzZDQ0p2V3ZiZ1M3eEJvOUd2?=
 =?utf-8?B?Rzl5bC9oMXRRaUhZM1RGcFVEWFkzdVVENUtnOTNsRkwxOWtweFVTSTNtOEta?=
 =?utf-8?B?QjVmTW1QNUdXRGVMblNXZ0JRNWoxNmZOWmkvcmlGQzFaUG1KZzVxaGFLdm1n?=
 =?utf-8?B?dmlHME5Na0gxU2xhQytnT01aMnJyNWZRL0NYWmpFbkVBb0grSzVDSm1aUjdB?=
 =?utf-8?B?SEZJNWtuTFNkVEFWcXhoUHdLMC9tSng1NWs3U0Z2ei9jRVBRTlpjSk4vOFdn?=
 =?utf-8?B?WlJnTVh6eDVUck1DWnMrNVBrWXp4ZmVMamFkTFNocFdOczJDc2FPQjd2dDBa?=
 =?utf-8?B?S3lqamlPV3ZXUFZyYU9SbXp3ZlJMaFdSOUJzSDNUcWgwc3QvUEdXZjd6aFNM?=
 =?utf-8?B?QnpjdVZaNlB2S0JqVE1QZW1nem8rUzByTE1UOEpFVlFCTXZzSkhYdW9nTDkr?=
 =?utf-8?B?RDcwNHM0RHkwa0hkZnE2QlRReXFDQnkvQ0szWVRCYitnR3Q2YUphTG1ybHVD?=
 =?utf-8?B?STJNdkl5TGIyQ29TSnhWckFLcnhWUTRISnQ4Um5ZWGFZMEtadmpFbVBmNWla?=
 =?utf-8?B?SXdQVTQ0YzlReksvV1JKNUhWanMyQnJFSk9iclFvUENyYzdndmF3dXZOZjB0?=
 =?utf-8?B?MVdkczRENmptSnZVdG1hc29mdzhYSUIrUi9qaUxueHhwd0luUEpwd2pZeldQ?=
 =?utf-8?B?NUh3WVRQeUIzM3p5aTNFSTJUYStiTUQxbGlTUHFSL2F6VUg1TnJ3b3B2R2Q3?=
 =?utf-8?B?dnRjeDRXYWZqWURycUt5eWhocXdER3dXbDIydnVJbngvNnl2a2ZNTnppTENG?=
 =?utf-8?B?UVh5ck9uMC9DRjBPTGppVTREd1RtRWRzR3BiWWpVcnVGVW1RdDloWVJZb3hU?=
 =?utf-8?B?L1p0TmlUQjVPdjZzaXlCNWc3TGpQV053U1g3S214eU5LazlQaVNRU1JpVTVZ?=
 =?utf-8?B?dGhEVWRncTQyWnVtc2dxMkZLRXUwZVR3aWtNcW9aYkhlTlBodERiaTlQcE5M?=
 =?utf-8?B?UW9FWElMTUZPTjBQOFpJazcrbERPZzk2ekgvRm5ISUs1aGhWTTJoNmlYOXZz?=
 =?utf-8?Q?nwzNV+rL0OEmdNlhyw=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aG10ek1nbDZ1Wmtud1k5WmJYUlBFREM3cXV2ZzdwYWp6VjJvY0FzS2xBandC?=
 =?utf-8?B?RFFWcjVGZ0JsOFFPN2JMTlFLQk8wTnFLTjN1d2JwSWIrZ1Y0eWR3bXVVN1pW?=
 =?utf-8?B?OVlBVVFCNE9yMGowV09oNjBYUERSdlRZOTl1RUdZRWZaaEhWSnpnbmZaVlFL?=
 =?utf-8?B?ODZqQndRYm5OdnZQT0dLaTczdEpaODdBNW1WaTdmYi9Ed242OHZvS1FhSEpv?=
 =?utf-8?B?bnMxcS9WYzlzNm0xOGRBOFFGUWNnTVhOVEJPN2dtaWswTW5sQ2hpdEJmOU41?=
 =?utf-8?B?d0JwY21hUldTUnBZNzVlUHZycUNYNTJHNVBVNTlRdXp3WkdCNllDWE5EMWR1?=
 =?utf-8?B?dDlhcllKNTV2eFlWZjhHNnlCVlNyUHNhcnIvUEtXNDI5VGdPRnZxcmVKVEpY?=
 =?utf-8?B?Z3h2VUk5eEU2SmdoK0s3QkFNenNXaGZWcFE3NXpiVEdWYk9kVFpUdFB6R2Z3?=
 =?utf-8?B?S2cwTVI2Qmp6djVTK1I3YXdOeW9RcVliTjRaYVMyTjBDRVBjOXF2ckxsRWZU?=
 =?utf-8?B?L3JzcU4vVGt4cHBBTm5PYXZaNE5FUXJsdWNhNnEyVWhaYm1oa01mRmdkL2Uv?=
 =?utf-8?B?Nk9zdy9IeHp0MFpiYk8wWlRaZ0d0UitzWWpmVnY0ZjliQVBXVjRTcTV3Y3dB?=
 =?utf-8?B?ekkrSVhxSkZjWGM0eDlvNUhrWEkwYXlGMFNwcktuSEp0MWQvVHV3dm9TWWZB?=
 =?utf-8?B?YmVCUnNSN3hZMXp1TU1MQVY4bUg3cE11cGRDL3o4bE1XVEh1bWVya1NhaVI5?=
 =?utf-8?B?T3ExaUliVTE0enpKOUpjVFpTdkt6WEI3SDJyMkFiRVVyU1dIcTBtanRqbm1r?=
 =?utf-8?B?SUJWdUo2Tjl5Y3BZVTF4dzA0V3pNS1BkakFYaFMyTHBXYUhVTVI1bWxHUUVR?=
 =?utf-8?B?YVY1RG55QzRDTmJQTnliWWtYR3gxZHNPNlNwSW45YVBCL010UU44bkZvQXht?=
 =?utf-8?B?WFNYbHRWVTVRSitJUU1jTWdmd3JFem55RXNockNOTnV5OUFTWEIzTWRhVzl5?=
 =?utf-8?B?WXpHc2lVVGp5WWxKR09LUFN4Vmo5RU04Z2NveWJKd0c3Y1dpWkhmUVVXVFN6?=
 =?utf-8?B?TFZMT2NsdTdQVFFHdEtUSWpGTk9PNE9IM0poUWFIL2ZNeHpjZEZHRFRTalRT?=
 =?utf-8?B?aXNWTkc4ZXREdGQ0ODZNZm5IS3o5K0J2M0UzRlJ2QnYydUIrZTd3cmdxNWxP?=
 =?utf-8?B?VlJCTWdtVG9CT1pxc0p0bTZkdklwRm9DZ1pJR3p4eHVVYU9xUktJSjl6bnMx?=
 =?utf-8?B?czdmVzlXZmFHVlZ0bDRJaFpVbVE5RHN0VUhqSnZaeTFZTkZ3VFF5S0NtK2Ex?=
 =?utf-8?B?L2JmSm9NVU4zd0J4SzF6VllWd3EvZC9SQ3VRRVpDYWVaYkcwdFBvdC9Oajg0?=
 =?utf-8?B?ZGFUblNlSmhZVmtKMUcrem13RnZzcHlVdzlTWHUrVHFqbjlNaGN0bWFONU9y?=
 =?utf-8?B?SnZYVVRPa3dDaGVXb2s5VzhKYkZVUFNWQUVKS1JFNnRoaTNKa2pqcFdmRDlH?=
 =?utf-8?B?bWphb2hTdUFJT1RwSjIwKzdMNHJBR0Q2NzZCQ3Nxb3QwNVJGUXc2cEkwY0Rk?=
 =?utf-8?B?c1EvSWg4aHc4ZTRpanIzdkVYbHM3SXpnRjZGMjRLUE5tTXp0Zy9tTUVjOEUz?=
 =?utf-8?B?eVVnRnpSNE9WRExNUEE3K0JvZXdFYThBb0F0M3RtdnNtSndiSG15eTc2M0Jy?=
 =?utf-8?B?YjlRTzU4RlVyczEydVg1SDloaExFbE01NHArTFpENE1sa2FCWWFzb1lZTDgv?=
 =?utf-8?B?R1pjbDZmeXdIS201azk4UHRiSkI0R3IvNlJvVE00QjhJOUdwb0dGMGdGMTNP?=
 =?utf-8?B?ZE1iVkFWOFYvZ2RFdHZtUlNQL0Q5WG1xTDFBY29qZ3ZseWdSQkNvWkF1dE9o?=
 =?utf-8?B?MEJJajRzYmljayt2ajlkem5qTFU0YlZNd01sYUJGblU0U0hPbHBHTlpiMEZz?=
 =?utf-8?B?ZXZnbDVLZUpoUjhyaXFHZi9LK2Jzb05aTWRQOGg5UHF3dHF1Y2U2TllncU00?=
 =?utf-8?B?VjhWVk1rcGJyNktWTDNZcFZWd1QzT2NwcVI0NnBDcHVWUFNIRTdCM043UEEv?=
 =?utf-8?B?U2dwdE9TRitsMmVpR0RXUmpCdmZXN0pDdVhZbDFDU0x0ajlSSU1ReHpFeHYw?=
 =?utf-8?B?RnJqZm40TCt3SWRLVTh4Zlo4T0pTYkpoalhLZVZ2MDZWcko2cUNEZ2JJTWFD?=
 =?utf-8?B?dUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a2d0b79-6992-41ea-d340-08dc9fc5c111
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2024 03:18:07.9197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ozHP52+C1cGh9zFZOJBYBLyy993tY4rTAburPAwcIsY7sG3Li2MP0gnxPKCeewKj+AS1PIU5Vz4brRAWkrNt5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7357
X-OriginatorOrg: intel.com

Hi, maintainers,
I recently did some tests for this series, the benchmark is here:
https://github.com/antonblanchard/will-it-scale/blob/master/tests/context_switch1.c

The purpose is to check what's the overall performance impact in thread/process context-
switch when CET supervisor state bit, i.e., RFBM[12], is fixed with 0 or 1 in xsaves/xrstors.

3 cases are tested:
case 1: stock v6.10-rc1 kernel.
case 2: v6.10-rc1 kernel + this patch series so that RFBM[12] == 0 for normal thread/process.
case 3: v6.10-rc1 kernel + this patch series and with patch 3(Introduce XFEATURE_MASK_KERNEL_DYNAMIC
xfeature set) reverted so that RFBM[12] == 1 for normal thread process.

Run below command 10 times in each case:

./context_switch1_processes -s 20 -t 50 -n

Trim the results by removing the top and down 10% of the data in each case, and I got below numbers:

case 1:16444675.45Set as 1

case 2:16412285.61~99.80%

case 3:16405716.19~99.76%

As you can see from the results, in case 2 with optimization based on XFEATURE_MASK_KERNEL_DYNAMIC,
the performance gain is ~0.2%.

So I'm not sure whether XFEATURE_MASK_KERNEL_DYNAMIC and related changes are worth or not
for this series.

Could you share your thoughts?

Thanks a lot!








