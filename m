Return-Path: <kvm+bounces-6414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 576488311AB
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 04:13:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 033CE285DF3
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 03:13:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C94816120;
	Thu, 18 Jan 2024 03:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cJL5sQ/g"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8045D5390;
	Thu, 18 Jan 2024 03:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=134.134.136.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705547624; cv=fail; b=uXuH1LERZuP9ZQyC0LFpzYNuLDwYG3wamO9dO4TCLCFEkACFQbI4/jpZrG4cdx+c/B9TvvLh+OcKzR5SM/bXStI8eFbGwE/JISlI4Enf0aBOQVBv1lD7OxfEYVq2Ph8FyOaAy39moKdMtRU5iaHbkHZEB+pvD/idcOJ1ks1sbOk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705547624; c=relaxed/simple;
	bh=ay1FyfLCczy1pzQzBzj3G34cSQOPuEUr6wP2nZyPps4=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:X-IronPort-AV:Received:Received:Received:Received:
	 ARC-Message-Signature:ARC-Authentication-Results:Received:Received:
	 From:To:CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:
	 References:In-Reply-To:Accept-Language:Content-Language:
	 X-MS-Has-Attach:X-MS-TNEF-Correlator:user-agent:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-senderadcheck:x-ms-exchange-antispam-relay:
	 x-microsoft-antispam:x-microsoft-antispam-message-info:
	 x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:Content-ID:
	 Content-Transfer-Encoding:MIME-Version:
	 X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	b=SxzRMupuIu6SK39bCWPQ/zp1gZYRrVvkcaOW+hPbt8PQF29No/2zVk2WKbIv/6ycX2ERKvFKLbgiIoNFoTep4txE06GReIzJ7nOggEmQQisk1B8b3CwZ0UzBh3SHZKwN9uG6ZETeFLwPT6xnBAL3wodCB2nmi6458D/zFjvnECI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cJL5sQ/g; arc=fail smtp.client-ip=134.134.136.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705547622; x=1737083622;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ay1FyfLCczy1pzQzBzj3G34cSQOPuEUr6wP2nZyPps4=;
  b=cJL5sQ/gR+VejmGmCBsvZ5yOxx1HQoidSsyWSiZ8VmdAsZc+CTBbQmHj
   MB0yGfNnI5zXwcF3m2eXtILUw3I//I5IvBfVxTodVZi9n+WTI3OkkpBqj
   PJtwClIa9p1kJAn6gu945nO4tlalOwN26h8qKbGJMF6PN9ZYeYmMYa1jw
   gFCia4QkAma7uaU3SlVScwtFaSZRbrk1EQ5Kl2/l9BhQhpL/G0KGCOGum
   p/uh3f0SX1trzk3Wgvc7GjoAT8bR3YjF/Yi9hMrETzr6SE92BWo3/2Gv7
   0Muz/iGcCj/S8mQWDDelMk1BIDTRGYL1SUS6RCT40+lF2wPCMfR3bFevz
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="464617724"
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="464617724"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2024 19:13:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="777617244"
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="777617244"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Jan 2024 19:13:41 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Jan 2024 19:13:40 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 17 Jan 2024 19:13:40 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 17 Jan 2024 19:13:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YDcpCa1QlFU7FgpBJKQ4m700BKoY15fregg7otc1wgzF0vJ55POOLTMwJ3Gji8TWK24PJhyuY8U7Qhsz/P7F+Lq+55LFwexYiJQ1DthyUuejo+726C2LknZZogBiB6NpJQAwQbicbdAArudb79kgLGfQRFCsQNcPXXwGANL8DbZtR6kcgWNygleFdP0rbZ2ypi4mVcMwn/6W73RfSmlOH5a8dOg3QNrUpIDG50d5beCU6g/H27Wlpod8npSfRbNi8c2WQQjncelJJ3las9lk156mOQzbrGSlnrue4sbog/tEPfTB4E1iDY6DXGlAceQCHRtvsiG08vDBtGEVjgd71w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ay1FyfLCczy1pzQzBzj3G34cSQOPuEUr6wP2nZyPps4=;
 b=WNbTheaJIal+EwPU8D4sryrodI7tzNQbzucEkL3T2cTQ/roEfn0bshif+BS/m5sPGkOntUYu5eYnVZAV/NNz2yc9b6veDGkSoy7S+/1G1T0iYUK8aVB2df/nfAl0UZRXL4Pj+hBm+GgpiM6NIHU5Zz5k4LsjmpfD7nFS3UqRlUc3YceJWp49UFGGBWnFavSAunqzMux2iFxboVKFuVWKkBZ0ic9J37wrcakpBEiqzPyi65bexvtqDr16Z2W1DeE+u6HckatS0ozj7YM8LFB97JPpe17gKUMk/nOB7JWOvB15//3J7k0kGR1OcalyQr0R4IhMxYlvb9z++HO38NrnBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL3PR11MB6508.namprd11.prod.outlook.com (2603:10b6:208:38f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.30; Thu, 18 Jan
 2024 03:13:32 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ca1e:db:ee01:887]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ca1e:db:ee01:887%5]) with mapi id 15.20.7202.020; Thu, 18 Jan 2024
 03:13:32 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Li, Xin3" <xin3.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "Yang, Weijiang" <weijiang.yang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "bp@alien8.de" <bp@alien8.de>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH v4 1/2] KVM: VMX: Cleanup VMX basic information defines
 and usages
Thread-Topic: [PATCH v4 1/2] KVM: VMX: Cleanup VMX basic information defines
 and usages
Thread-Index: AQHaRT8Fg8dZJ6KNyk+kWUJ6VvYyeLDe7iCA
Date: Thu, 18 Jan 2024 03:13:31 +0000
Message-ID: <a6c44305e822b5525c50624d892b652b3f511b45.camel@intel.com>
References: <20240112093449.88583-1-xin3.li@intel.com>
In-Reply-To: <20240112093449.88583-1-xin3.li@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.2 (3.50.2-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BL3PR11MB6508:EE_
x-ms-office365-filtering-correlation-id: c35c140e-b2af-4044-cbfc-08dc17d37350
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9NU3dtpyo5w/FC53xMn5y0Ls/wx1SvtQODIMAeA9SLSy2xga10eGQAXy98+KHatfebPKMVtpuCeOI03jqkMLwngOmvt6i1uZ7udCSSafSsAHF/JooJIxyrFaz1DgnLtV0C3x8RM6avLQ3G85V/8XgYt4E7Ght8S78ntT3MZfSznEZGYpYuAWbZAWJ2K81JFKgF8F8a9mD7oT//sdlGCgZysgoQR4Vb94nnTJqlrV6UXFO67e0pyQjtUIWT3ud9+5uTYWBVC6yJwOVe7WhfuI1Ac1pNbT2otgIv1Xsyt1UQ3AEFG9uCR0WyWyF5coUPxDVFR/5X3sQ1J4qxyrjSOqClBa5dmghSvq1vhq4/wyoFYt3XzrQxUly0bmwmNjns1J0tIYSxZ70cRbl9m2HuSUFB/bIcXfNhLHce1Q2C5JWSYM/Cz7EsFTIjyuwoIQXvPZhndIWixJ6th+5PKoVWO9iQd+ys5yp2WmVusZqBtAHvUO1C7aHvmJzA/KIh/+FdKU0K7RWstMKl7KCTKQAh4X7xsusgtlM1Pj17v7cn9QouKA55B+cJvj5/o4HMQWsJ5LD2lIV4REeEpuRlJi/NeTNoS39Av3RH0VlS3OuF7f+X3OZpNJ2mih2BtYIvtv0IZd
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(39860400002)(396003)(366004)(376002)(230922051799003)(186009)(1800799012)(64100799003)(451199024)(38070700009)(478600001)(7416002)(5660300002)(4326008)(4744005)(316002)(64756008)(6512007)(8936002)(66946007)(8676002)(6506007)(54906003)(110136005)(66476007)(66556008)(66446008)(76116006)(2616005)(6486002)(26005)(71200400001)(122000001)(2906002)(82960400001)(38100700002)(41300700001)(86362001)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UGZKYTZuS3JBMkRUQk83ajZidFd4SVZEeUluZzU5S3JtUDVEVUxNenQweDJD?=
 =?utf-8?B?UWFtenQ4RDRVZm1UL1YwS3pXNjNjU0Q3VjFleURFQ3ZsY2RzYloycjhKNTA0?=
 =?utf-8?B?Sm1Wa0I1bEFVN0xDeXMyMURydmVSU3NETEFxRGU4T3hFSkQzSFN5R0JjYXZ0?=
 =?utf-8?B?dG54YnNJNFVaTzNuZW4ybHdRMXdMLzUxY2NHYm8za29CeFl6elFRUHlNU0Fh?=
 =?utf-8?B?QWJ1WDdkaVZqTHA2RlFzeE1QdXBNNGFQNU5yb093ZXNLTWpmVkRPZUt3WEZT?=
 =?utf-8?B?WXcvNEN1YTQ3WjM3cnIxUjhyOC9ZWmNaSGZsMXA1ZEFGOXZEeVpDQWZhajRl?=
 =?utf-8?B?cFQ3dnR2S1RZczI3MlVjNWFaaU9tekxxa1ZiWFhzeTgvcXJBbnd6U1IzbER2?=
 =?utf-8?B?YWNGL2dFTjBRZm1Tb1Y1SXE2V2RrcHVXSXBQTGdoc0FBMVUxeTFoT3JzTS9l?=
 =?utf-8?B?eGwwTkNmc1dDbit0cHlRMGh2S3NoeWFCNU5veEwyWloxemhLMFZFTk1BSzJG?=
 =?utf-8?B?MjlBQkxqWU9IaERmeVc5OThnWndndlVFNVpNeHJFVWFwQVkzbmd6VXFFR1Q4?=
 =?utf-8?B?Q3p0SERuaWoxRERFZ1lyZzVHSms5REF5UHRKL2tJeWFER0FYOEJTYnZGcWpi?=
 =?utf-8?B?bWVISENNUEE0VWVrTTlGc2RCZ2JoRnR0NUNUZmtDZVM0YmtZQUxkUGgybVg2?=
 =?utf-8?B?YUdVWEdXKzBiYnp4Tm5Ya0ovMnV2bHUzUTBtVjBCb2dFQ1JNblVKZk9xekEy?=
 =?utf-8?B?cUZJQW8rZ01DL3hMRTBoTS8zdzVSdXprRXRDVGg3eG42VWgzMWRJOEVQQVRv?=
 =?utf-8?B?UDRuR0lqM2lzaG14MmZ5V2ltT3VWM3hnSGVpWnQyM2xNNXRhSmFDelRjcml6?=
 =?utf-8?B?M1ZXTmswOXpGcXhlbitLQmZFdnBWaFUzQjBsRkIyWHRWL2xHdUw3ZmR2WVNY?=
 =?utf-8?B?SXB3ekJJTVMxYWU0b0JTZXlmZ1IxUFNNanZkQUtFdnJhZXJydllCVVFXNzFs?=
 =?utf-8?B?QmFtV2VoVTVCRy9DbGY1SE1oSEs5NGdaWmJNWlBXSVJuSlpSeUVpT1JIdk1E?=
 =?utf-8?B?Mk1uTENVSTdJM2VoWStzNFF2bXBROS9VVDBRZ0ZRb2FNYi9GUllReGpkNHUw?=
 =?utf-8?B?ZG11R1pyTkUwRkdiaFVVOHVvdGJlSThNTTRoem9CVFJCT1htTEdLalVzYkRY?=
 =?utf-8?B?cmNGVWtDTHR6VVY3VTIyZ2V6SkZHSEJwUkdWdjloa01Vaktrd2Y4L1VrRkwx?=
 =?utf-8?B?aWt0TW5nV2xnb3ZYWjFrY2FMNHBIdm9paUEzalA2VE5MeTJLcXVHWDZCNzdQ?=
 =?utf-8?B?Zm9PeTZvdzVSdUk1aHRvVU5zOWRyYnY4TnUyVG1YMERxUll1WEQ4ODNZTlcz?=
 =?utf-8?B?OHErLzZxNUZVNWpxaGduT0E2eFc1ZzBjVTFsRXNrcXpIbitLcEdMMk1QRGRs?=
 =?utf-8?B?QkZIZk9XaS9ISENNV3JMcnBXNi90UFlMQ2VkNVVDekk4dEd3emJLYnNVQ2t5?=
 =?utf-8?B?ajJabThOVXZHNlE0ZWhzbmN3UEI5RENmdElPTlFtTTlrUEppd2xNdmg4RFZv?=
 =?utf-8?B?YmpnQUQyeXRSWE9tMTl1dHRHZ2V4V0ptc096aVZrK1Y1cmt3K3g3dE1ZYks4?=
 =?utf-8?B?M3FkQVdLd3Z0emcxZjY2eFQvTTZ2L09wRFlSMjkzT2MyUE9MbzE0S1BaVm5s?=
 =?utf-8?B?czVnQ3A4Q2ttbW0yQ2NhdDZ4Mm5NTzRYcTFrZW1lajNoTDJEUVZsdTF1UEN1?=
 =?utf-8?B?YnVRZlJ5Vm02SVBJbkVUdUk1S2tGYWdJK1pJWjVBWUhmaDZ5Z0FIVGVCYWN5?=
 =?utf-8?B?MklaQm9ZK1pjdlZtTGdDU1V5bFBacTBBTG9tMUREVGRsQWxXV0dWQU4zU0N3?=
 =?utf-8?B?RGNnQmJXdVJjbFVQQVRZN1JueWV0TS9wOFVyK0RFbXhiTWVsY2RvY0xPS1F2?=
 =?utf-8?B?SUF3MXFURjhXU3RXOVVpM2hPN2xDQng2QWNiVCtha3dUcW5rbS9lQi9jMHhj?=
 =?utf-8?B?TUVqbC91cEExOWZnZFhxVW1KU2RTRThyajNySGM5SDBpK1hXTUtWNXN1L2FE?=
 =?utf-8?B?SGo2cXpDQjlja3NCbTJqb3ZMclNsSXRiSEJ5bFI2bWg1d3U2ZnRzNGlhTUM1?=
 =?utf-8?B?bmxCazJVa0tGTmN3SVN6TmdYeE03TmNqQkdOdUZlM2NwQ3lrRU5PYmJDUVpx?=
 =?utf-8?B?ZWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BE7859C65076994D8D64EA7BFE3A017B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c35c140e-b2af-4044-cbfc-08dc17d37350
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2024 03:13:31.9837
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fj+sQXFgFzyKWdNGtmViph4Il/ptsxMxWXGw9YifmOB5Xn/X0u01I90WccilZbesepvKIZDCFy67KfVndmMMiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6508
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTAxLTEyIGF0IDAxOjM0IC0wODAwLCBYaW4gTGkgd3JvdGU6DQo+IERlZmlu
ZSBWTVggYmFzaWMgaW5mb3JtYXRpb24gZmllbGRzIHdpdGggQklUX1VMTCgpL0dFTk1BU0tfVUxM
KCksIGFuZA0KPiByZXBsYWNlIGhhcmRjb2RlZCBWTVggYmFzaWMgbnVtYmVycyB3aXRoIHRoZXNl
IGZpZWxkIG1hY3Jvcy4NCj4gDQo+IFBlciBTZWFuJ3MgYXNrLCBzYXZlIHRoZSBmdWxsL3JhdyB2
YWx1ZSBvZiBNU1JfSUEzMl9WTVhfQkFTSUMgaW4gdGhlDQo+IGdsb2JhbCB2bWNzX2NvbmZpZyBh
cyB0eXBlIHU2NCB0byBnZXQgcmlkIG9mIHRoZSBoaS9sbyBjcnVkLCBhbmQgdGhlbg0KPiB1c2Ug
Vk1YX0JBU0lDIGhlbHBlcnMgdG8gZXh0cmFjdCBpbmZvIGFzIG5lZWRlZC4NCj4gDQo+IFRlc3Rl
ZC1ieTogU2hhbiBLYW5nIDxzaGFuLmthbmdAaW50ZWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBY
aW4gTGkgPHhpbjMubGlAaW50ZWwuY29tPg0KPiAtLS0NCj4gDQoNClsuLi5dDQoNCj4gKy8qIHg4
NiBtZW1vcnkgdHlwZXMsIGV4cGxpY2l0bHkgdXNlZCBpbiBWTVggb25seSAqLw0KPiArI2RlZmlu
ZSBNRU1fVFlQRV9XQgkJCQkweDZVTEwNCj4gKyNkZWZpbmUgTUVNX1RZUEVfVUMJCQkJMHgwVUxM
DQo+ICsNCg0KWy4uLl0NCg0KPiAtI2RlZmluZSBWTVhfRVBUUF9NVF9XQgkJCQkweDZ1bGwNCj4g
LSNkZWZpbmUgVk1YX0VQVFBfTVRfVUMJCQkJMHgwdWxsDQoNCkNvdWxkIHlvdSBhbHNvIHB1dCBz
b21lIHdvcmRzIHRvIHRoZSBjaGFuZ2Vsb2cgdG8ganVzdGlmeSB5b3VyIGNoYW5nZSBhcm91bmQN
Cm1lbW9yeSB0eXBlIG1hY3Jvcz8NCg==

