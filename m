Return-Path: <kvm+bounces-12377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D08688593E
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 13:40:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 429AC281896
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 12:39:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE55B83CD9;
	Thu, 21 Mar 2024 12:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PKfGfdfn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A507083A1D;
	Thu, 21 Mar 2024 12:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711024781; cv=fail; b=bCuVUIf1LpgPdg23+/xMkf3sWvGL0SiRPfelFaFUJ49jzJv8xlIZPIui+E9YLv2bnPnuxd6ZmA6e/5dDC7sNpG+SSA5KKmteOz0F9nhna/7WIAWXyKGC9B+n7spqdyjqYr7/ZKmuuk6haszXUZhjQzbbvkYDm2n19lswXOQ7e7M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711024781; c=relaxed/simple;
	bh=xujeMOi7b5BKYaDc5/d+c+SUdmrE4yBdvKpgmcbDU4Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ios8+tHcyD0Er8FIqBiR2sYWVfT05pPsCd6Eu/HO+kIYtcPaY71vYSpByIorXQLXkPu7x4ESSPqzSFbHCqHm6FoLH0V7BHi0XO3NudEXiT9napYVD9TgXZU0YrNFHKdrk9GwJKShhYkZmB9HceqeQlEP4HqrDsS4u0N2HgUQXS8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PKfGfdfn; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711024780; x=1742560780;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=xujeMOi7b5BKYaDc5/d+c+SUdmrE4yBdvKpgmcbDU4Y=;
  b=PKfGfdfnSR5u1MtCokKfFaKM0HIjjUL24TaLLQn/3z6THSXdULfTZPKY
   fGLMtI9opOSusEHYe/T7+jdlIqpQ4VXeT7P0ld03oDOlJOXqKELaeQpNj
   WlQ9mHMb7TOwnsgprgfWfq72hHysbHpZaMwUeHDHJNHtuCaGSq6hbUYj+
   F2reUe9Ecjhtgkh4sQQxrfxjOBEqz3lWbJirSYv4THQz26BCCcx/GptRZ
   OfM1ig6NwqWCv2y9NEUeeUL+Vt5QAxTzPsZ44zdUYdimuaHoVG8MvXj9e
   SnA9KL5VIYEOc+KNOa5tW0RvZV/fv8RVOpPzvxD7c1efYq0MMipjonX2E
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11019"; a="5858130"
X-IronPort-AV: E=Sophos;i="6.07,142,1708416000"; 
   d="scan'208";a="5858130"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 05:39:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,142,1708416000"; 
   d="scan'208";a="14567457"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Mar 2024 05:39:38 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 21 Mar 2024 05:39:38 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 21 Mar 2024 05:39:37 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 21 Mar 2024 05:39:37 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 21 Mar 2024 05:39:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BmWyrqcK2d1V1n2kbdmY4rIvrTilwIy6XplY/FGSo9SFBlOaKRsI/m290taHDK5CN8cgaFA8k7WnDYQw1xtLgZNk0j2uC+ehXyy6kOr869Ha7V0dLxcp2OWspP7ZcPw8dTei/zbkX5IoIfcvOPNxcSr5IO6NYUBDe6i2s8kbvnbHCmB31aIEAiSTzm8+t8Xnyw4P2dpofKAgUX1nZbIZgUM14QhaPuraVQFxCn3BFXW7kNIPsN8u9Ksm8Y+kwfhnHR4qJEzdyYOvBuNMX0l5KLGvrx4M9/ziQsWc/OuRIigTTcUk3kqt/mGD2Qe54h2Eo9NU0y9notfpgDPUcaX8lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xujeMOi7b5BKYaDc5/d+c+SUdmrE4yBdvKpgmcbDU4Y=;
 b=KcwrOZhrUZLM637z6Es1dwAiVaUESI+D7QmsddIsfi0YdXiFHFqsR3HzhqCal0tYqQjXos/HLyC5wa+Lhbzl8bxisG7/fMrmHfpQRSiv3GnFjfOgUhMLfn9aGVIeLYMZ69vDIsvI2VJfNED03L3oDbLrLGZFlBaa7y80fZshSvIQ0coNrapdcdcwkj17W28NUGiwen4HonF4MeuaI2uzS2+lYnYHiaGQorbDOTAHlcQHOiYHqBhtnORrGv6Zk//1cj/d8x3X7wx1k5KCa+xYWApOQwMmHsvYcewGewjamTha38umi+T1QMsUy89xyL5ZMqGqBzsfgjl76tj0scsCFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW3PR11MB4553.namprd11.prod.outlook.com (2603:10b6:303:2c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.11; Thu, 21 Mar
 2024 12:39:35 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.010; Thu, 21 Mar 2024
 12:39:35 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Yuan, Hang" <hang.yuan@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Topic: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Index: AQHaaI2222Sa8TxUXk24fGddYGoigLE2lxiAgADwvACAAM4SAIABOT+AgAi5ZAA=
Date: Thu, 21 Mar 2024 12:39:34 +0000
Message-ID: <e90e5993a565eaca9a567c00378b8486889ceb67.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <f028d43abeadaa3134297d28fb99f283445c0333.1708933498.git.isaku.yamahata@intel.com>
	 <f5da22e3-55fd-4e8b-8112-ccf1468012c8@linux.intel.com>
	 <20240314162712.GO935089@ls.amr.corp.intel.com>
	 <5470a429-cbbd-4946-b11a-ab86380d9b68@linux.intel.com>
	 <20240315232555.GK1258280@ls.amr.corp.intel.com>
In-Reply-To: <20240315232555.GK1258280@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW3PR11MB4553:EE_
x-ms-office365-filtering-correlation-id: fbd01405-749d-415b-fbd4-08dc49a3f6f4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dzaztVEaSmE4yP97F/LP7EhOHVN5CdaRRRrtHU6S7dXcFBHBMD8nNWgab2BDjy21LvwfVNADZR4vznkMEBA4DqXHVdeE6ezdvvYhglrcsAcORzf2MBuHtLB9XeaW3It52g9JFNrcUAVEi7FM+VsvZri90ZrxGSoHoOrc2sFhT9b3ufJXgufL8ZLBL9Jh9E8+tiwVpNd4OTIdKimIl7NgqVsi/a9d5td9F+JpiDlWs1X5bvvLLC+xLJBySnC6xZT6r7Jo3CqMRHqI+5GZEvTDSoBTLuTJkSg+sFOgXoPWsyq71av2A+1zQfgmmFzurHoopaA3rW44XSMHfyCHOlRhVE5bI4/1vHp/2/1v1c13HlUbQFC1K8qtbFrCbNCpll8o8KadQfiP55AQhrlH9tDZizXYp6csqwD/bGUjo/znjHdMuBVDLLRQ0EvQBABp56wLEWdfE/GwDAGTzBPEO0G/NOxZ+e6hpWTzzypiyu02OBy2VEKMIgoLATwaTNmq12i2ZG4ZdaU66Aw798ESuzEDyVa078kwZT+/t4uBDv5/FT+DKwnrNttxX1eX3gHL64aYzNqYlOhJkFT35kLIo9DvGnMss/gOi82HKDA2BLhf50CilJjtJITkt8XQ7hDxfDtFUCrzjDu2ISK8uP838gNUQic4KkaHxAt+peYmxmO7kNWikjo5VZF/Fp1YJD18fA/Fh3qq4rYvAytjPBU1D9e32vCyRE6FzfdAOlYUnvJumhM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RmtlTTAyYVVwbDZRTzV1Skw0T3Q1dG1ZSXFIb2dRNjY5a1BmQ29xeC8zakhW?=
 =?utf-8?B?U1V2ejZlSmdNS0RpNVpyNUtBQS9CaC9DTlFkNTJiMDdyVng1MnZzeFJJM2J1?=
 =?utf-8?B?S2QwUThjL1FnWFVlU2hUWkZlbmNqYlZFMENkZ1draHVPdDJkT0VneUFoUlha?=
 =?utf-8?B?ZWJwTkZ0VE4xUkkyUjRkQUQwY0ZmZE9YZ0Y2dGhLMGNYenBueEhwVytwakc2?=
 =?utf-8?B?TldMall3amt2Z01kL2VCL3N3bzFJUlordGxQQXBOME9qYVB1S1o0MEhXeGRw?=
 =?utf-8?B?T2hWMU0rbGhxVnVkNXF3RE53WEMzQ2JJNUF2K3c5UkZOL1hUeEk1T01kRk1H?=
 =?utf-8?B?dlZ3RnpVYXd1elpQKzhMU29nL29IM2l0M2hhNHpIbnFDS3JtLzlrRE90NTdV?=
 =?utf-8?B?UWJtUHRvbmtTbXNNU2tZbkZ4ZzZ6dXBNK1B6TDVLc2xVc2FPY1loNzNwYWU3?=
 =?utf-8?B?V1JDY2ZvZkhHZUYrUlFlRDJ6SEhzNm1pUEp4Vk5VRXRBLzE2TmJpZjlPUElB?=
 =?utf-8?B?MGNlS2F1NVZGUUlHOHpRMHdWRkR4WWJyVUtQMzBpeDdHZFY2RTVaNEM2Z01v?=
 =?utf-8?B?OXJxcXhiMFdWbTFSdUw2UzdGWmFjQkZoeWhIb0tSdTlMa2VUMGVXTU43N2lp?=
 =?utf-8?B?aW11a0FKMVR6SElOWXNsN0N1QnRRVFNSV2NvZEltWG9rd2YxL0NwSjdvdTBM?=
 =?utf-8?B?amJwSWFWWEQ3anVqOERzaDgzYjJ2MW9VZEUxdU5RVUtmN3lodzlHbGdMVFFJ?=
 =?utf-8?B?emloR0dyT3VzQnJPcEt3UHBvV2NaQTJCcnhHL3B3N29LZDRuNThqZkZicml4?=
 =?utf-8?B?bjZrR3MrcFU0UVhUQW5HREY2MUViUE80S3JxRlZZY3Fhd1F6NGhIYjBBNW9h?=
 =?utf-8?B?VzVZOHl4YlF4Z3kwZTdOUjZlUkhEbUMreEFoTkMxV1A2Qy9nNHNLOFAyMm52?=
 =?utf-8?B?NG9hTHRKVnkzL3hzWkFEVWRxY1VHYWpQNEF4RmNZd1V4dVE3VnJpTlVjSTdt?=
 =?utf-8?B?QVRaNVFBRE1HU1pWZXVsSHhrOEpxTm9ibEVabTZqVDZNaXh4R1M1MFBjQ0tt?=
 =?utf-8?B?MFhPVWhVcE90K3VNbndhUVh5K0RYTTUyWk5IRGVTMGQ3SWJKUld1bHQvcnNw?=
 =?utf-8?B?V0lIcmw5Nk1mRlBHVGlPVDFqZkE5MzdMeC9rOFVWdFowNXhXYVNWbGxHb3pE?=
 =?utf-8?B?czQyc0VUZXJGc0gyU0VaRWhXRStqbDVjTHNFdnB4WlZMMGQwYUxOTDFLbUVI?=
 =?utf-8?B?VjloNzVZRUFtamhScm5uQXBDcXZCWU5OdkxnRGlURnpaYkJsZ005MHU1VGlU?=
 =?utf-8?B?YzhRdTdmUWhUdG05Z25TcldFdGt4a0hoOW5uODNkdWd5VnhLYU90b2xLTUJr?=
 =?utf-8?B?ZVhVNmFJTjJJTjdYY3lFczRtUDBOdGdCNGh4Yk9BME9SeTg0SUZEUmVKRFBZ?=
 =?utf-8?B?Znh0YXlvSHRDMmRuTUkxMkpCckN5NzYrNit0d1lHUzNzaDJPMTE5bUk1d3Jz?=
 =?utf-8?B?VU1DcjUvMGdNdEJ2UkJjQzdhUkhoTTRHelNISXE1UDgrM3Zra3VzU2drRVJI?=
 =?utf-8?B?THdRcVNLQ05WQ2V2NHJ6WGZFZkxiUThMNDd4V3ByR0tXL0o5TzIvbWw3cDI3?=
 =?utf-8?B?RG4yckZvUVprVnY4WnRvK0JCZy9kMmNmR0wzT1QyUmxaOXZxdGtwUmNGK25S?=
 =?utf-8?B?d3gyMStJSTM0VW9LcFRoMlppdzA1ZVJub29WcWI0ZkZ3TGhkejVpcXRXYWsx?=
 =?utf-8?B?bCtNNWpyNmhadVk4Ylc2NEtORmh0VllGbUVYVzdmUGMrSVZYKzBMZWwvR24z?=
 =?utf-8?B?N25mblhYcWMwZVl3cFhWMm40dUI3S2JRZnp2T0s0VEFRdlNxSHNOWHFXZnBa?=
 =?utf-8?B?UjhZUGY3OUtjbUd0ZVNWNHd5TjE4cU5mMUl3UUlNcDVCMzBRTzNkaTR2LzB1?=
 =?utf-8?B?ampVZVAxNVRZMnNzYm5ZdCtQNVI0eHcwTUpnVnNEaGR1ODhPR3BERGdaYjNu?=
 =?utf-8?B?aEhCM3h5VjFiZ1JRT3lKNEJjeFdValArRmxIekVYQ21FWEdMTnE3elpwamFk?=
 =?utf-8?B?T0c5c25YZThXZWJYRS92ZDdZSlJDTjNpT1ZtSXZYeVhiTEgxZkI3VU5TT3E1?=
 =?utf-8?B?WU9GZDRGOXQwM2twWHV5N0huaEYwbTUxS05mcFVpWEszQndTclZ6ZHIrTnk1?=
 =?utf-8?B?UEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F56AE1AEB5712640B1FB62ABF5046588@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbd01405-749d-415b-fbd4-08dc49a3f6f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2024 12:39:34.8858
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g8+tNqZnGfUtVNvBpPgJqFMcYc0Qr2GoaMBS6N9Rz4KPMe8IsO73dU8LKnd7/gl8++N6O4+tZeB+7UW0qjWi4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4553
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTAzLTE1IGF0IDE2OjI1IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gPiA+ID4gSG93IGFib3V0IGlmIHRoZXJlIGFyZSBzb21lIExQcyB0aGF0IGFyZSBvZmZsaW5l
Lg0KPiA+ID4gPiBJbiB0ZHhfaGFyZHdhcmVfc2V0dXAoKSwgb25seSBvbmxpbmUgTFBzIGFyZSBp
bml0aWFsZWQgZm9yIFREWCwgcmlnaHQ/DQo+ID4gPiBDb3JyZWN0Lg0KPiA+ID4gDQo+ID4gPiAN
Cj4gPiA+ID4gVGhlbiB3aGVuIGFuIG9mZmxpbmUgTFAgYmVjb21pbmcgb25saW5lLCBpdCBkb2Vz
bid0IGhhdmUgYSBjaGFuY2UgdG8gY2FsbA0KPiA+ID4gPiB0ZHhfY3B1X2VuYWJsZSgpPw0KPiA+
ID4gS1ZNIHJlZ2lzdGVycyBrdm1fb25saW5lL29mZmxpbmVfY3B1KCkgQCBrdm1fbWFpbi5jIGFz
IGNwdSBob3RwbHVnIGNhbGxiYWNrcy4NCj4gPiA+IEV2ZW50dWFsbHkgeDg2IGt2bSBoYXJkd2Fy
ZV9lbmFibGUoKSBpcyBjYWxsZWQgb24gb25saW5lL29mZmxpbmUgZXZlbnQuDQo+ID4gDQo+ID4g
WWVzLCBoYXJkd2FyZV9lbmFibGUoKSB3aWxsIGJlIGNhbGxlZCB3aGVuIG9ubGluZSwNCj4gPiBi
dXTCoCBoYXJkd2FyZV9lbmFibGUoKSBub3cgaXMgdm14X2hhcmR3YXJlX2VuYWJsZSgpIHJpZ2h0
Pw0KPiA+IEl0IGRvZW5zJ3QgY2FsbCB0ZHhfY3B1X2VuYWJsZSgpIGR1cmluZyB0aGUgb25saW5l
IHBhdGguDQo+IA0KPiBURFggbW9kdWxlIHJlcXVpcmVzIFRESC5TWVMuTFAuSU5JVCgpIG9uIGFs
bCBsb2dpY2FsIHByb2Nlc3NvcnMoTFBzKS7CoCBJZiB3ZQ0KPiBzdWNjZXNzZnVsbHkgaW5pdGlh
bGl6ZWQgVERYIG1vZHVsZSwgd2UgZG9uJ3QgbmVlZCBmdXJ0aGVyIGFjdGlvbiBmb3IgVERYIG9u
IGNwdQ0KPiBvbmxpbmUvb2ZmbGluZS4NCj4gDQo+IElmIHNvbWUgb2YgTFBzIGFyZSBub3Qgb25s
aW5lIHdoZW4gbG9hZGluZyBrdm1faW50ZWwua28sIEtWTSBmYWlscyB0byBpbml0aWFsaXplDQo+
IFREWCBtb2R1bGUuIFREWCBzdXBwb3J0IGlzIGRpc2FibGVkLsKgIFdlIGRvbid0IGJvdGhlciB0
byBhdHRlbXB0IGl0LsKgIExlYXZlIGl0DQo+IHRvIHRoZSBhZG1pbiBvZiB0aGUgbWFjaGluZS4N
Cg0KTm8uICBXZSBoYXZlIHJlbGF4ZWQgdGhpcy4gIE5vdyB0aGUgVERYIG1vZHVsZSBjYW4gYmUg
aW5pdGlhbGl6ZWQgb24gYSBzdWJzZXQgb2YNCmFsbCBsb2dpY2FsIGNwdXMsIHdpdGggYXJiaXRy
YXJ5IG51bWJlciBvZiBjcHVzIGJlaW5nIG9mZmxpbmUuICANCg0KVGhvc2UgY3B1cyBjYW4gYmVj
b21lIG9ubGluZSBhZnRlciBtb2R1bGUgaW5pdGlhbGl6YXRpb24sIGFuZCBUREguU1lTLkxQLklO
SVQgb24NCnRoZW0gd29uJ3QgZmFpbC4NCg0K

