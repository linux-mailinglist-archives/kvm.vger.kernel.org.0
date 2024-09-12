Return-Path: <kvm+bounces-26755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AA3BA9770DF
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 20:42:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3918D1F2370A
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 18:42:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6FA11BF81C;
	Thu, 12 Sep 2024 18:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FnomKo0w"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C09149C50;
	Thu, 12 Sep 2024 18:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726166569; cv=fail; b=V7hc1SyE7kN7aas3EOuuv+9bAlFTGXfoH5j012/MQyZq1bAhB6RdgrbiawI8mvpb5BoyOgRzWwd8FLP6J3vRLT/lViK8oHcEDZkp3s0GtsGnrvUEPGGRJyX44E+aPk9xjoW8qDVpl5Yq3Zczmsa8FeXVCq/lhzKNekZJPflNTts=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726166569; c=relaxed/simple;
	bh=jDcVpZKhTSHPGAgDalCp4/3X1B28iB5nYXAN7b/juTM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=G4Afa7WWsOKo9znSmAn+OfoJ8Ri4+A39Um+G1XQzpXstzKjP8Fl+AzXMEOU7HQH9uEiwwG5AanWEKFft7a27vnrK7kmSreiKPrgNQT+Ddx4EzIkS0zB7Twll+Nt2KbnAtqGDGcyel8kbW5Z4GNGkM77D3evh28qA00DGdQ9dILo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FnomKo0w; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726166567; x=1757702567;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jDcVpZKhTSHPGAgDalCp4/3X1B28iB5nYXAN7b/juTM=;
  b=FnomKo0wFxKi1r/hLnkhSb9K7cQL+nII8LaNeSEiEA/Qvo1/JEMU+YPW
   FZZ+dU6IzT+kQiJuDbhMoBM6mBAtmPVs06I712FTa7tGHcXjY5QPme7wR
   QUjh8aXOVBH+idYsbecAcvsXDTcNO/0EjNiIicwqKwo26bha+dHPf+XR6
   nTshSrpQWv7hjaXJlFVJlxXIhslXsFoAgxTZXh9b+9hOWv2TPYUMlTrbG
   d0/ANJA5w/ti8ht+hFqUs94GCKTXXOL/xVxIDVt8E2XQGyluM+XzTFSfw
   A4hguhHRvcouU89V0JzX/Q4PBwfxEhC2I97nYi/GKYuuD21a74tGNzt5s
   g==;
X-CSE-ConnectionGUID: BkixEqCnTUeYkKYHxZKazQ==
X-CSE-MsgGUID: kBdgUfkXQ5y5HYyDDWNZ1g==
X-IronPort-AV: E=McAfee;i="6700,10204,11193"; a="42557662"
X-IronPort-AV: E=Sophos;i="6.10,223,1719903600"; 
   d="scan'208";a="42557662"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2024 11:42:46 -0700
X-CSE-ConnectionGUID: YY+wnAZWRvmIJX1aS1Bi+g==
X-CSE-MsgGUID: JRYFx2fyRmO15E6jAn13MA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,223,1719903600"; 
   d="scan'208";a="68058018"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Sep 2024 11:42:46 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 12 Sep 2024 11:42:45 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 12 Sep 2024 11:42:44 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 12 Sep 2024 11:42:44 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.47) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 12 Sep 2024 11:42:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wy/JpIdLsUrTNEOaK3+VVI4yLYYjDLKFWOM76zmtmFFkEK1UNOmHHKEICTEkzRDXdzCgWMppMauegZz0TmnEeas4ndYQLESBxMf7TJw3TN866y1xKUwp7GXzeuUNnmOZ3MDDR9Lyhi8IoPJWkNnvKX3nKV7QtHcNfdsgaNGTDJlxs/f92OtVemO+Kj8SaH3ASFvnKua6j1czVPF+B+ORLr1+b2rFuH0hPHhy3Qu2vuQHKOzFY78c891i1F7HY0ed7S8tSYsNJHhNhKzAvPxwERrBp1hoMtO0FUTxljHKvSv3eStgwHQhue9ZQSTMEiqyaX9N9RMIQDEclcYBfLMfrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jDcVpZKhTSHPGAgDalCp4/3X1B28iB5nYXAN7b/juTM=;
 b=O+URemrBmSjNeolnMY3J1rGrh8zI2M74Gl03zCjIxHFM8Aq1UOh3kPTIJv+ZdG/5Ki8EN6L6q7Ytb8MV+vBoF5aupHIzi6oVYAuOTPzbCliyXLuKL6ju3QqcNE9SGAmch5b+UReQQkX7gWctGjxllooFTJxOobuhMIAz7asXiZEI/HQvxwfnIjV0EAqB39CiuK2EjbyyyDstRE/rSeqekHX0LVi/eS3xpuX3YzVDRbjJF+Co+pTAS6yzd+e99363s3GKL1TmodYB/pctX4I/ghtzUoyHI6UH3gTZIGIhbZCEyBK9cNsCHdAtzlvzP5uS4+GprQqOEQwHZcG26a9F4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY5PR11MB6212.namprd11.prod.outlook.com (2603:10b6:930:24::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.17; Thu, 12 Sep
 2024 18:42:42 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.7939.017; Thu, 12 Sep 2024
 18:42:42 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 25/25] KVM: x86: Add CPUID bits missing from
 KVM_GET_SUPPORTED_CPUID
Thread-Topic: [PATCH 25/25] KVM: x86: Add CPUID bits missing from
 KVM_GET_SUPPORTED_CPUID
Thread-Index: AQHa7QnThnZIMHm/AkW0hgwbYo+0yrJRemKAgAJ7zwCAAGp1gIAACiSAgAAAtYCAAB/QAIAAHgOAgAADsoA=
Date: Thu, 12 Sep 2024 18:42:42 +0000
Message-ID: <8e1afc752580e877c8cfea4715a9babf639e88a7.camel@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
	 <20240812224820.34826-26-rick.p.edgecombe@intel.com>
	 <05cf3e20-6508-48c3-9e4c-9f2a2a719012@redhat.com>
	 <cd236026-0bc9-424c-8d49-6bdc9daf5743@intel.com>
	 <CABgObfbyd-a_bD-3fKmF3jVgrTiCDa3SHmrmugRji8BB-vs5GA@mail.gmail.com>
	 <df05e4fe-a50b-49a8-9ea0-2077cb061c44@intel.com>
	 <CABgObfZ5ssWK=Beu7t+7RqyZGMiY2zbmAKPy_Sk0URDZ9zbhJA@mail.gmail.com>
	 <ZuMZ2u937xQzeA-v@google.com>
	 <CABgObfZV3-xRSALfS6syL3pzdMoep82OjWT4m7=4fLRaiWp=XQ@mail.gmail.com>
In-Reply-To: <CABgObfZV3-xRSALfS6syL3pzdMoep82OjWT4m7=4fLRaiWp=XQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY5PR11MB6212:EE_
x-ms-office365-filtering-correlation-id: f0cf1605-ec83-4095-36e8-08dcd35aaf4a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VERKbDNGRHdXZmlmN1dNZE9NT05iVHpLUFdRekpXUDBMRzM0SDJTR2h1ako5?=
 =?utf-8?B?N3A0d0liMi80ejV0c251Z0pqTzdZRkF1NDcyZUxnWGZsOG9XbVFaZ1UzUlBu?=
 =?utf-8?B?T2t5S21hQWpaL2QyL05BaS82TVFIbVhZdTZrQlJtY1lMdmJWaWI2YlFBWmJS?=
 =?utf-8?B?c0d2aitrVFY1Z3lBc3p2b2Q1OXdoNEFIOWU3YmIrRyt2bE9IdFJ2MS8rcC85?=
 =?utf-8?B?R05BL2lKakl6YTdpU0lGWnhaT1lUbEl1cXlDUUt2SjB1M1Vmd1ZIaE1jZjYx?=
 =?utf-8?B?RTlFUWdTazBWbGErbG95YlJXS1BYU1hUTDArcTZZYWpHcExQeitIemxCWGVG?=
 =?utf-8?B?cnFJWHV0QnFuTVZiNHpUTWNNaXp0U3J1WW1VODJkME1RR0w5ZHBvU1lvU1Y1?=
 =?utf-8?B?c09LME1MdXlGRTIwWmhNcWNJMG9UbFpwbFBaWTFtRnkxVkRRTnZXSEpJazJl?=
 =?utf-8?B?REo4aU1nQTBQelNHR2RyQ1N1Rmh3U3BINEYwTWNScjVlSWgrdlU0ZDdrUVh4?=
 =?utf-8?B?ZE9lZ3FDRHI2ejR4L1lvUlREaXBwYVJQaGxZYkZlNXVheHAzczYwT0VTZUxE?=
 =?utf-8?B?U1kxRXhuTjFubEF3NjJtc0pUTm0vUGlONS9NRGF2ZTJTS0pVQXoycWxXK2hP?=
 =?utf-8?B?M0JGaVRZR0gwQ3Z3V3ZFTW03VENZTHdiK29QZ2NYR3F1Y01takYxZGM4Y29l?=
 =?utf-8?B?WmZJenJGQmxRdmp3RUh5UjJaYUdKL3ZWeEd0QnNJdGZsVmRZa09wQ2xEZSth?=
 =?utf-8?B?L2tPUTJYL2FHSGdnZzNNUU1JM0N0WkcvS3loZE5iUFJidVhtQStyMTdVbjEr?=
 =?utf-8?B?UlNYZjFtbnB6VnEwQ3owM3g1QUh3dzZQbDI3UEVnWlY1MzcxVGw4cjBiQ2lz?=
 =?utf-8?B?N3BCR2hYM20xYzYwTUM4bU90eUh4RkZ2d2RmL0pmT2NtbkRMYlk1Z1FjTjN4?=
 =?utf-8?B?Y2x3ZXBkTnNLTk0zVGNHTFhObXlLRjJnMGVRRUh2REYyUTdmR1VYRzl2dXJN?=
 =?utf-8?B?NjFuZStVYS9GRzRhNTVQVmZlWDR2SkNlWnQ1bSs2cElzb2UwQ1hDKzVqL2ky?=
 =?utf-8?B?WXB4V3ZFWG44ZnRkbHRVR3kvaGwwcHZmSitkcHA0cGZPaTEyamJ1cjFRcnls?=
 =?utf-8?B?aFB1bEg3dm5IeVI3Y3RLV0NVcTNyYXVqNGd5U25POTNjUTNFSnZYR0hNMkJv?=
 =?utf-8?B?L2RHd3gyRFRzVHhEK1dTa1dJelZZMWNmUWZrZ094YmpnK01OTVl5aEZpRllz?=
 =?utf-8?B?NzFlcHBEMndXdy9kK2t3bHFCSmhsNTZia1VrajhwRlhrcXRjTDhDUXlEZCtX?=
 =?utf-8?B?SVRZVWZqMjR4RktLOXVYUFRDSlBlb3JZV0xDL2J2cUhwaTNGV3lRZHMxVTFO?=
 =?utf-8?B?ZEVpMS9SYmlON2V4OGhUWnRTQlAzTU00UnZ3L3JlZTRrcTZtd2JvNTJlRHVE?=
 =?utf-8?B?dUZaK2hIZkhNNllTZjIreERMUGFMR0ZaaHpBYnI1SS9DWlJhQUw4ZGFYdmZL?=
 =?utf-8?B?RWZJOFVETWlNUG4rWDJZWjQ4WlAvV3FlcnFzZFpUQTA1M0kzRGNqVE1xVHda?=
 =?utf-8?B?ZHNhQjJhRjZZSEZwQ0MwSUFvNzBISXloZ1dZUW5JckhIUHB0SWZMbFNiSlNw?=
 =?utf-8?B?SFpiQWFnaW1UdEJTMVRFVlYzQThod1JEcHFkMmRka0ZZOVRzQTNVOVUyUk0y?=
 =?utf-8?B?QW5wUy83bHY0WWgxSnlsSG1JT0dFYnlZM3lyZUF5bmhlVm9jY1YzTGkrYURO?=
 =?utf-8?B?YzZwTEYvTVlhdURJdTJKVVBwNkRPZTlod3c4SUhVZklERWhjdnl0RCt1aDBs?=
 =?utf-8?B?cS9GVkVpR1F1UzZZaUQrL0FPTUhRZmNsN1Rzc2hvWG0xUlMrTURheWZKWVBr?=
 =?utf-8?B?MVN2NkJBQUVlUVFaSTlSc211Y0h3V3hiRUhKWXZyVlFoOHc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S0c4RWl5Y2pIRXp6Q3g1MCthSSt0aTA1Q2ZYcmNNZjNsL0VHalcwZGJ2M0xK?=
 =?utf-8?B?S3VUVVlxcUlFUjVDUjZkQWZHSE9zbkk2L2JKWjhRY2lRc2RyZWdQb3ZPSHR1?=
 =?utf-8?B?czR6RjAzZ1JJLytxREp3d2RyQXBMVlpDb1hsYWJCWk8vMXZHY0NjWDUwV0V4?=
 =?utf-8?B?Z0pGZzh2dnVRU21RdHJ5L3ZHVVNGZ2JrcnliSTFBbmZCTDZiK2ppVEJQdG9D?=
 =?utf-8?B?U3p4b1luM3k1aWdBUmlJSzZya3V0ZWp1eENXSDlZaDcrZmpjTU5CTFRoWnZH?=
 =?utf-8?B?RGo1TW1pRXVUUEg4akFQdytWRzdvY09yQlRnQVpydm04UFlwZ1FqMDc0WnJ0?=
 =?utf-8?B?RHNyVFMyR0ovSzM4ZWx5MEpqU0Y4SDMwaFZiclFMQnltWHpna3BpcXNxTXM5?=
 =?utf-8?B?QUtQNUNiRkxpcmdCYnhrWW5YMXlGcnV5Q0hxRXdMZTVDUkRMdzVJZ1BsNlNK?=
 =?utf-8?B?dmNUK0JwbUhmZnJsYnpvQWg2bmVNaldMNFhHeWYwLytnaVZqdVFBRVZZbEZx?=
 =?utf-8?B?WXJBYjd4a3pFSERSK0NoMjhnQ1k2ejFDNFRyQ0FBSVJXL1IybWRXMDc5OFVm?=
 =?utf-8?B?ZkFCSjZIZWFLZ1dnSXlmR2JPWXhWYkt6dTd6TG1YZFF0LytBZzNGeVVNMnp5?=
 =?utf-8?B?NFk3cVlOcWNYZmh6dkFEOURjL0xta1hUbitoVHZnb2VXTmpDRGJPZVpjYXJq?=
 =?utf-8?B?Y3ZZWXdYNG50clJETnE4R0lPUDhTd1M1WnRsRlNjRjdqRE9uc0crNjlhSkN1?=
 =?utf-8?B?ZlVxZlBsS29UMnVCUU5oZUlQZGhITmdVS0dRaSt4UXVoMzdrMFV6MUNqd25B?=
 =?utf-8?B?T2Rock5mSTVTTW1xei82bWg3amJia3FMTFBzaURjRHVsa3loRzZGUW53N0p5?=
 =?utf-8?B?VVpwMlprT0F5NVJwdmN3UVVpbHJwa2xEZUNpZHFVZlpwdHlxeWhweGVjdHhP?=
 =?utf-8?B?Z2lqem9EeTAreW5WYjY1eHpxdXdnQTlPWWlvTzdFWGlVM3ZaZ2Q1UDRENWNB?=
 =?utf-8?B?cUM4SGFwRzFrVnFZQXVtOHpTcjg0ZW84bkxlRlVFQkRvQU5URlk3V2U4U01W?=
 =?utf-8?B?Ujlhd3lLdC9KN2hac2JPME9tRFFGdmRXMUlWTndSTkVTcGRxdlA4Y0pNbUZW?=
 =?utf-8?B?Z2lhNmliYmFFd2J2K0RsTXlxanhmTGIrcjltQTNEaWg4Q1Rtanc0aFEyUWUr?=
 =?utf-8?B?ek8xdnRhc3cwMHQ3U1NpWGxuditWSVc0T1hUd2pPU2JYZHFsZXVVa3R1ajQr?=
 =?utf-8?B?MlVkY3ZqbVVVR3JvMjJyNjQ0ZzZuOWJ3cHJvY3ZaNjBITkFERktZY2hhaXdh?=
 =?utf-8?B?TERVZDc0eVdZRlRyQ0JTaERWOWM0VU5aelI3enhoWVRGSFkyTGhveGVpQmVL?=
 =?utf-8?B?bVhTeTdnSVFiQ1EwYkk2ZWRITnVYTmwwaC9rOW1DOHZxb29Bc3B0K3dUd3Fn?=
 =?utf-8?B?aVlVekhtb0NOTCtGQUtFOEh2ZHNLNmQ2TGhQVmo5d25pYTNHNS8xYnJ5QkNV?=
 =?utf-8?B?ZFZQaTUwaE9zVW9pRkR5YkJhREdIcVA4OXZmSEJJR0wvOXhnMU9EVzA4eDI1?=
 =?utf-8?B?Q1d3UGhjbVBHVDRadWV1bFdabVErYjF4TnRDaEhVUktLVU9meW93eVkzbWpN?=
 =?utf-8?B?ekZvcFlnS3FiY1pVVFd6R2o5c1JGOXFSRGdPaDhSdEpHWkhpNEJwbE8zdmgy?=
 =?utf-8?B?TWc1cjV5TW9oL0I2V1c0Y0g1ZVhJR3NZdXF6bkpPZXJ1U1RiUlJwOU55TUhG?=
 =?utf-8?B?bGVHQjJ1cVRlbzZWRFErcVhEbFNkVTBCcmtWMnpmVFE3ZnI1Y0w3MldiS1ZQ?=
 =?utf-8?B?Z1F5UlUyOVYxVTkxNWt1dXNXUFJFb1JQMzFmQWJVRncwKy9UM2NxTkJIcVdz?=
 =?utf-8?B?eUltTEFtQjhZRHRjc0c2K2hmVkNEWFEzUTdCUVVFQmV3M3V6WDZ0NGdwTG5Y?=
 =?utf-8?B?bkZYVnl0NHpKMGRMTEhoQWZuMnpvdlZQMENIb3Y3QXZSU2VJZlNoYk5ibk1j?=
 =?utf-8?B?akZ0NU9OWSttZ1IycTRnNzhzc3Z3MXpIcEkxSThYVHpIQXpyYTBMOStTdnpS?=
 =?utf-8?B?b3lnU3V0M2MwYkd2c3B1YlRIMFZuVjkzdDJ3VUxkYThpRms1MVM2U3F2ZVJo?=
 =?utf-8?B?NzVkWlVZQTJhQmdqRkpXSHJhMlF3NS8xOTgvQVhidDFJblo3WUJ2MlR3SUNw?=
 =?utf-8?B?c0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7314B8EA1FB0B64B81E803871D682E0E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0cf1605-ec83-4095-36e8-08dcd35aaf4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2024 18:42:42.0558
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ldz7w1AMjldp4hx022ytqEtN8l/a3LK9AjDKLq+iJGFxjM/VoiT1cX3xnOWhOo6dC9ZTu+C/s4AcDjkKdH/5OF/TIvkJOcvD08j8sVcwugc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6212
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA5LTEyIGF0IDIwOjI5ICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiA+IElJVUMsIHRoZSBwcm9wb3NhbCBoZXJlIGlzIHRvIGFsbG93IHVzZXJzcGFjZSB0byBjb25m
aWd1cmUgdGhlIGZlYXR1cmVzIHRoYXQNCj4gPiBhcmUNCj4gPiBleHBvc2VkIF9hbmQgZW5hYmxl
ZF8gZm9yIGEgVERYIFZNIHdpdGhvdXQgYW55IGVuZm9yY2VtZW50IGZyb20gS1ZNLg0KPiANCj4g
WWVhaCwgdGhhdCdzIGNvcnJlY3QsIG9uIHRoZSBvdGhlciBoYW5kIGEgbG90IG9mIGZlYXR1cmVz
IGFyZSBqdXN0DQo+IG5ldyBpbnN0cnVjdGlvbnMgYW5kIG5vIG5ldyByZWdpc3RlcnMuwqAgVGhv
c2UgcGFzcyB1bmRlciB0aGUgcmFkYXINCj4gYW5kIGluIGZhY3QgeW91IGNhbiBldmVuIHVzZSB0
aGVtIGlmIHRoZSBDUFVJRCBiaXQgaXMgMCAob2YgY291cnNlKS4NCj4gT3RoZXJzIGFyZSBqdXN0
IGRhdGEsIGFuZCBhZ2FpbiB5b3UgY2FuIHBhc3MgYW55IGNyYXAgeW91J2QgbGlrZS4NCj4gDQo+
IEFuZCBmb3IgU05QIHdlIGhhZCB0aGUgY2FzZSB3aGVyZSB3ZSBhcmUgZm9yY2VkIHRvIGxlYXZl
IGZlYXR1cmVzDQo+IGVuYWJsZWQgaWYgdGhlaXIgc3RhdGUgaXMgaW4gdGhlIFZNU0EsIGJlY2F1
c2Ugd2UgY2Fubm90IGJsb2NrDQo+IHdyaXRlcyB0byBYQ1IwIGFuZCBYU1MgdGhhdCB3ZSdkIGxp
a2UgdG8gYmUgaW52YWxpZC4NCj4gDQo+ID4gQ0VUIG1pZ2h0IGJlIGEgYmFkIGV4YW1wbGUgYmVj
YXVzZSBpdCBsb29rcyBsaWtlIGl0J3MgY29udHJvbGxlZCBieQ0KPiA+IFREQ1MuWEZBTSwgYnV0
DQo+ID4gcHJlc3VtYWJseSB0aGVyZSBhcmUgb3RoZXIgQ1BVSUQtYmFzZWQgZmVhdHVyZXMgdGhh
dCB3b3VsZCBhY3RpdmVseSBlbmFibGUNCj4gPiBzb21lDQo+ID4gZmVhdHVyZSBmb3IgYSBURFgg
Vk0uDQo+IA0KPiBYRkFNIGlzIGNvbnRyb2xsZWQgYnkgdXNlcnNwYWNlIHRob3VnaCwgbm90IEtW
TSwgc28gd2UndmUgZ290IG5vDQo+IGNvbnRyb2wgb24gdGhhdCBlaXRoZXIuDQoNClRoZXJlIGFy
ZSBzb21lIEFUVFJJQlVURVMgKHRoZSBub24teHNhdmUgZmVhdHVyZXMgbGlrZSBQS1MgZ2V0IGJ1
Y2tldGVkIGluDQp0aGVyZSksIHdoaWNoIGNhbiBhZmZlY3QgdGhlIGhvc3QuIFNvIHdlIGhhdmUg
dG8gZmlsdGVyIHRoaXMgY29uZmlnIGluIEtWTS4gSSdkDQpqdXN0IGFzc3VtZSBub3QgdHJ1c3Qg
ZnV0dXJlIFhGQU0gYml0cyBiZWNhdXNlIGl0J3MgZWFzeSB0byBpbXBsZW1lbnQuDQoNCg0KPiAN
Cj4gPiBGb3IgSFlQRVJWSVNPUiBhbmQgVFNDX0RFQURMSU5FX1RJTUVSLCBJIHdvdWxkIG11Y2gg
cHJlZmVyIHRvIGZpeCB0aG9zZSBLVk0NCj4gPiB3YXJ0cywNCj4gPiBhbmQgaGF2ZSBhbHJlYWR5
IHBvc3RlZCBwYXRjaGVzWzFdWzJdIHRvIGRvIGV4YWN0bHkgdGhhdC4NCj4gPiANCj4gPiBXaXRo
IHRob3NlIG91dCBvZiB0aGUgd2F5LCBhcmUgdGhlcmUgYW55IG90aGVyIENQVUlELWJhc2VkIGZl
YXR1cmVzIHRoYXQgS1ZNDQo+ID4gc3VwcG9ydHMsIGJ1dCBkb2Vzbid0IGFkdmVydGlzZT/CoCBJ
Z25vcmUgTVdBSVQsIGl0J3MgYSBzcGVjaWFsIGNhc2UgYW5kDQo+ID4gaXNuJ3QNCj4gPiBhbGxv
d2VkIGluIFREWCBWTXMgYW55d2F5cy4NCj4gDQo+IEkgZG9uJ3QgdGhpbmsgc28uDQoNCg0K

