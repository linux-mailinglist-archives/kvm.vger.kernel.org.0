Return-Path: <kvm+bounces-73204-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YOl5GU2Aq2mwdgEAu9opvQ
	(envelope-from <kvm+bounces-73204-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 02:33:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D6EB3229609
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 02:33:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 12E0F301ECE1
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2026 01:32:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F22C2EC08C;
	Sat,  7 Mar 2026 01:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZEVFWn4J"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3546E283FDC;
	Sat,  7 Mar 2026 01:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772847148; cv=fail; b=ks4zKsWtCFTzZfs3hXF2MkFlIVfUUOZQBF9gyvAHkDU17Xzt71sPaI2W6dzPBplo+lv3AYCT+UQGySh3/U3Qfv4IY5l2gdup2rGR+0f5obNQIOaHY2HsdeCg4E52xUQTUznkzcnkaZWho0QGkbEEJ7K48WhVx2dW1NInEbKJpkQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772847148; c=relaxed/simple;
	bh=08T4SWY+c6O9xTSn4GcWQp9lQjQ8H3aPBbTsDH8HZn8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AkLpi8TMKXzYgBxTaxg0tmet9RJfzEuugSS4MRZFs1Op0LUfdKA/PtxDnC40OZUCE6/QgQGCISo5FgvNQbEZP2viwEklKuCpt2j+2g7lAngEWMur0wMal2zg+AtttjrcHNdyfQPNbmojCgDMk2itCfWAcLBMH6qc4ToJSuRZ/VA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZEVFWn4J; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772847147; x=1804383147;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=08T4SWY+c6O9xTSn4GcWQp9lQjQ8H3aPBbTsDH8HZn8=;
  b=ZEVFWn4JVH3ucZ0ODba7N1CS8rFZMeK/FwnLp+UyWKugClXHLndv15cZ
   454JmJteoO0pi2gQjkZMkZwcjM1+LCVvPOrv12+eyetMljoYOKOeuytJ0
   c5qDTA47aZSu6mlay1de8B377aXjA6P3theNm/RIXsCiiTw74wdC/Evv8
   S2/tJqRS9ro8AG7sb0d7WvlbDnRjdDqiqKbQAC5ybVvxDIKhO8+G6stT7
   Yau5HogNT7pdApuCvj8hs12XuxlLIdOl5f4SbJhznZMHkYrneBkuODfw0
   bwWruY/sAOznvDcLZpfrXm+Sw1eq6EPI6LB0obHpszXIBZMel7xDGmKvw
   w==;
X-CSE-ConnectionGUID: S7L/tkIRQPmPKMgN/FiRUA==
X-CSE-MsgGUID: TzAMYOntRyOFOd3XnHJTsA==
X-IronPort-AV: E=McAfee;i="6800,10657,11721"; a="74035971"
X-IronPort-AV: E=Sophos;i="6.23,105,1770624000"; 
   d="scan'208";a="74035971"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 17:32:26 -0800
X-CSE-ConnectionGUID: GmCduIKJSKaYoNqRmdMiNw==
X-CSE-MsgGUID: FfcCiYagTjCiwRhOfEZV5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,105,1770624000"; 
   d="scan'208";a="245371082"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 17:32:27 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 6 Mar 2026 17:32:26 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 6 Mar 2026 17:32:26 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.53) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 6 Mar 2026 17:32:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rYG8nNxy8wN5//AZLKYFOSno81Nx5GvsPYiif5mEiszHAsjCkTYWXGLHPQqDidGBivxq+2pfATwP8kh8lJkET8saOK0k6P3RGQnT3KPErSjhUpcto3BuB0sw8F5Fu+bce2QMq227oXkSh5ufjWson1T8ufjBah2KXW92c4no8A/wZJz964+Vloq+QRxFqtipu2Gy60eIX+rMsfgUO2fAE0X3/S/eyDoApBQdx7L8k2hCFKh9ggSeV4T2IPOIMzkebs9l9GLAFQ6nKrAx/IJXAz/HySaGTxuSMGeiSaFpkNf7WmOOD6VEhD59aKYrQyrdcXASZBgOrVqy6nR+UCed+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hpJvSBAepWtv4BbROVO8oJwC+Sgmk4vDcwIT8spETOo=;
 b=KizaKsWC6AvPwQwaxtTD+TlTm+i87fQc6+WBn9e9M97G+ZlQMg2SVsMjpeAB+SAkUdp7FuyoKmAuXacdtXgrq3EXB5TjOppn3YhPByZ0MdxYnyZzoWAQSUsppF34CpLlcljKQrGg6LPJJybt7y3ChVYwX0H9uG3NcApDHRemxOWa0Y0YWbr5L2YiEygK6EVWTPEwqcrRZRMivLYiA6ZA7mVFAot8QTMTJ3PvILBIDODSax/OHzyyX/39hqX54DQ0OyDth8hcyABuC7UoMHckaAawmx2Vwp/pngjxKFqh1W/7+aU/bqWmVpLR2I6u7EsM7JkFbFbgbskJq2jBY1/mlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 DS7PR11MB6040.namprd11.prod.outlook.com (2603:10b6:8:77::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9700.5; Sat, 7 Mar 2026 01:32:23 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::60af:89a0:65dc:9c84]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::60af:89a0:65dc:9c84%3]) with mapi id 15.20.9700.003; Sat, 7 Mar 2026
 01:32:23 +0000
Message-ID: <b5b9efce-9205-4282-acc2-380d348c4f50@intel.com>
Date: Fri, 6 Mar 2026 17:32:20 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/16] KVM: x86: Rename register accessors to be
 GPR-specific
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <chao.gao@intel.com>
References: <20260112235408.168200-1-chang.seok.bae@intel.com>
 <20260112235408.168200-2-chang.seok.bae@intel.com>
 <aajd6Fa8gHz6lW78@google.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <aajd6Fa8gHz6lW78@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0111.namprd05.prod.outlook.com
 (2603:10b6:a03:334::26) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|DS7PR11MB6040:EE_
X-MS-Office365-Filtering-Correlation-Id: 3253b52c-9591-4d50-cda8-08de7be96175
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: LmFnclilF3tasfnHMN2E2muVSutL9DTY13PgvZlpE1rBQrzhaJMoO1odrkC+xwj9yrxSWqoOYe1gvpaEEPvJEJzGIWtFB9edcSlWXfBcOvaCceVaj2PISxYXtW9g3ioVk5y/hmMaVGa8ornqODll7nj+2oToRUsXrTwFedb/5taxb7+9yGYzDCkTp4QsMLEcSrWPH6qRGza7iXdywixgxmgGu+HloxAPhxha1m9VsDtzZ4ooDdTOF1wstTtgtaJqpUi0wd1qCOXeqWzXG7Q+drYRxDzbeF5kbJGxn2WO7xTAyN00mczLILJGN8QOfs9OG0nlIQcPSBV7pxFWniN05zJtGC+vWrR4nwlk8PW/UnxqHw+SsfkptUtMx6CC7h0la9NRiXjAWRpLctn+t0MuEavU8YApXGKF8oQa9AZYYI0fFKcHKC9Qu7X09IHZx2pFJD3T0Gljgd66QQCZCGg8mG4mFvpzb6cBKsj088VDK2StelNPzO9BrJJubFxQnFYTUSSGlFITT0Q7U7xw+HXG2syXGLw31Nk8K+FH8b4GY1RhKdL9Ajra5hy5B/3nLcSZmzRrh1A/ENuBNR9F13HR7pIKGmh789ChuAjWKafMoKiKHrQ1fKSoFT/wY/561HQX/IUwGfNGcdgv66Al0G/E4z36/Z9NbZEJINheEjeAZy/ScDZik+oODoOhGNPOEsoLnZdOTi2Dvo1ZKLA5iLll1Gr7I8WNDCRVUH9Y7mr+P84=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NVQrditHVDR4enU3QW91aFhwZjk3aEllRytRa2VsN3pWbC93ZU50dFNFclQw?=
 =?utf-8?B?MlM1Y0ppZ2pxV2l2aXdVZzVQVit4WUo0eFlJMTMrSnlNTGlCUkZWWmxCMGN3?=
 =?utf-8?B?ZXlhM2lTYThpQm5ZdTVQM1haZHBiYUNML3FZb01JcU5mS1E4M2o2M3NwTDFT?=
 =?utf-8?B?RXVSMnJZZExWQWhWd3hRMFMwY3g3MlllUmgrUVdaU1ErcjkzZjM3WGVRMnNY?=
 =?utf-8?B?aTc3VTVsblo1S25wS29TMWgxc1JSVEN2OEtlMFc2SWEvMnpHbmZFMWNncE42?=
 =?utf-8?B?RUtpcHpuTmlaZHVWNWRBektWMXA0OUdwSEtENkg2djJHRmMvTzRCbUdIZWJT?=
 =?utf-8?B?TjhhLzRVbU9TcSt4ZnJuRmY4MFdRZzZGYno0MEVEMVEvYzRic3hjZUo3QU50?=
 =?utf-8?B?ZzlSbFJVK3JyWitwenhLYmtta3dqUmp4SHYvcUh0QkpaRkV4NG1oZkptcXZM?=
 =?utf-8?B?c25zcXVRUFZoT3pYT1lkV05hYjlHMGlVYkdLOGh4K3lpOFZqZ2hpVEM5dGRH?=
 =?utf-8?B?WGFvQy9LOFd1NUlocmdLNVFzMi80Q3hBenNHS0hzVjNWU1VuYzlCUy9ucWZI?=
 =?utf-8?B?Y0VHNDEyQXBVa0RVaDJTbkUzckhQL0NHQk9DRW0xRXhIRUJZRTNPaVRUZ3lP?=
 =?utf-8?B?OGQwQWszSzdMTzU3U3FFcExnVjFJNXZMbzRuL1dwY3RSK1A2VXF0eWxPdUda?=
 =?utf-8?B?dngxdTRWMTlRZHJKTlJsYnNLSWxBVWJiaklYZWRpcFBpWHBkRm5QRkRsY3VO?=
 =?utf-8?B?bzVRZXEvY3BSVkFqYkVET1lHTTZ2MWlPT2hCYWhjOVlzd2xtY1ZsbGs1aHVq?=
 =?utf-8?B?Vi93dm5ta1JJekpia3VUU0xCQ0FucWljdmxEa0VTSEgzTXRKZ1BhWElmZGJm?=
 =?utf-8?B?NmFIc2grYW1peHVWaG4rQlE5U2I4NWNDREk0NzlQR3NaVS8wd3lXMWg1cDYx?=
 =?utf-8?B?OWtBR2cxS25uUVZLemlGYUoyNjJPWXgzV21yVjdNZE5IUTh0R3JuMWlGN0tj?=
 =?utf-8?B?bGNDU01qcWRxT3IzdEhKanJkUTQ5SkdxN0o3eDUyT3ZSZnFod2xadStNQ2xU?=
 =?utf-8?B?NGJkMWNwVFl5S2dwM0JqUXI1RHgzNHpQUUxXVE5EZ0lENVVQbmh3YUlMa01m?=
 =?utf-8?B?YTd1RDYwTGlPWUNheG1yamZqeFcxZ1VoYzhDemI3cHhZRkxPNDlJUU5pdDZV?=
 =?utf-8?B?eVlmTlQ2akhrU0FJVXgrbS81bUtRNDlHTGQrSDFia0tzdjNORWhWYmFNZ2hi?=
 =?utf-8?B?OCtGN1k5K2Nva20rRGE3OGlwYmsweDVndU5pMGE4UVVKVk5NSFNuTVpkdVBW?=
 =?utf-8?B?Rzlkakt6TmtMOGRHdkk3UHM0RXBXY1BzOUtHMkhlV2JXQkdGU1lVYWtBcHFr?=
 =?utf-8?B?Y052ZWlCdHhnRGx1ZWMrWmFnV3BJMW5JWGN0dXZJOGc0UUFuRUVVNUNGN0pS?=
 =?utf-8?B?Vis3ZEdENUZHL0xwT09QT0s1SnVpSy94alU1RkdrRGpyb2I1ZHpaU284bkFu?=
 =?utf-8?B?cUo5OVNaaEkrd090M1lGNWFqK2ZwTTN2ZU5lbW1OWk9KODg1ZCtiZlJHZkRB?=
 =?utf-8?B?cVQwRm50VnJZMGdSWkgrcGVNR3Uzc2Q0SXNUOWZWd1dvaW53bnZzcFNITm96?=
 =?utf-8?B?WnRETHhWWDdUalpQNnBmeFM0bURlaFhiWjNORkJFQnNHQzJqQVRuODZadkN6?=
 =?utf-8?B?S29sNEZoZXNKRExzaWhDSG01Q3lSWnd0NTNmaWZYNjIyVkhaZDRub1FXcXN2?=
 =?utf-8?B?WkphZEd4RHlOTWFXQlhvNWNTYmZYS3ppN0pGKzRKM2ExcUZTeDhPQUNiQnRW?=
 =?utf-8?B?TkY2RERGbndzTUVhdFV2U0JveGV3ekJ4L0pZYnlYeDVMb3hrOHZidWlkcHBC?=
 =?utf-8?B?a25OQm9kM1lsV29pdXBkbk9McEZrT09ZNU9YWlJncmxET1lpS1pHclBWbTVB?=
 =?utf-8?B?ZzF4Z3lUTHFjOE0wb1p6dDUzVG9uWmVBdGZ1cms1N2E5ZEMxOWlCRXBtUTVN?=
 =?utf-8?B?d3JiT1ZmQmRnSStkOUNrOXBIZE9NM0tvWVFNTW1aN1dEbDI2MEVIUC9MZHFI?=
 =?utf-8?B?cEZpUUkvcC9WTHF3R1NmZWV3bFNtaFpSVEMvRzV0dEVOUXRabndvT1lFeVpy?=
 =?utf-8?B?d28yTVdEWStrV2NlajlVdjBCS0puczk1bDVTd3RnZFArZlNDSGdvMWExYitB?=
 =?utf-8?B?TE1rSDRpOVltUXU1M0Nndktja0ZHYTcwRUU1M0JiZTVjOXdWbnNVamo3YkdJ?=
 =?utf-8?B?SmNiVUQvU2JvQXVVbVpGSHR4OWRrVzJHZG51cUI1RFMzOG56QUlRak1Xcmx3?=
 =?utf-8?B?amk5Tkx3T1hKTFBKNDZQb28vcy85bjU0b055b2JyeTF5Mi9rMkppdz09?=
X-Exchange-RoutingPolicyChecked: QyBvWvF+Vbel7fdISRHxsWYjAXowJmATYcTejZO5DEZfcIQJbxUFLjz7hYwJ5EzxYYbbMp4CDm+xd1PLsFcO4IarV7rlfAdZKyoV0EGakiKo6DlolxUry3e+2DJJrWpW2Uk+R9mGlIgPlj8S+NfDrFJbxB+Trk3UVXFGUeYUUfpJ8U1w2eryhbayNJl54lyxc5ypgmRPAFtJLnWAkcEOvzzyfnW/Dj0sLP4/3Pl4O5YET8bQb+mVzPGhfNeU/0Bi+KoZ6tE/vzvN2Ux6GRJKgeI+wR1Sw920dZS2HNRR0c0C/pZZIaFRSz3lTKi5buWDhZaQ8jVaUYmduTxkP7hbCw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 3253b52c-9591-4d50-cda8-08de7be96175
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2026 01:32:22.9667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zbtxe8ntF+AJlG3qGYNQyqO+UhTmRx803lK6lI1a/gLGr8Gw5dXBpW2RDmPuuWgT8oT1RcEkpd9MVzDQP5yxuVzcEKd1K3ve+1sgrjPzxY0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6040
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: D6EB3229609
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73204-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,intel.com:dkim,intel.com:mid];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[chang.seok.bae@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.972];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Action: no action

On 3/4/2026 5:35 PM, Sean Christopherson wrote:
> On Mon, Jan 12, 2026, Chang S. Bae wrote:
>> Refactor the VCPU register state accessors to make them explicitly
>> GPR-only.
> 
> I like "register" though.

Yeah, agree that it is more general.

> 
>> The existing register accessors operate on the cached VCPU register
>> state. That cache holds GPRs and RIP. RIP has its own interface already.
> 
> Isn't it possible that e.g. get_vmx_mem_address() will do kvm_register_read()
> for a RIP-relative address?  One could RIP isn't a pure GPR, but it's also not
> something entirely different either.

The 'reg' argument has historically matched the index of the register 
cache array, vcpu::arch::regs[]. When extending the accessors to support 
EGPRs, it looked smooth to keep using it as a register ID, since that 
wires up cleanly with VMX instruction info and emulator sites. But then 
reg=16 immediately conflicts with RIP.

Separating accessors for RIP and GPRs was an option. Yes, the usages are 
very close and EGPRs are strictly not *legacy* GPRs.

Then, another option would be adjust RIP numbering. For example, use 
something like VCPU_REGS_RIP=32 for the accessor, while keeping a 
separate value like __VCPU_REGS_RIP=16 for the reg cache index. But 
there are many sites directly referencing regs[] and the change looked 
rather ugly -- two numberings for RIP alone.

Thoughts?

