Return-Path: <kvm+bounces-12011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2387287EF1C
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 18:43:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 500461C219C9
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 17:43:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21D5255C27;
	Mon, 18 Mar 2024 17:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WNknpojU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4943A297;
	Mon, 18 Mar 2024 17:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710783820; cv=fail; b=WXamlKNzLRWmfFdnpqH7XYT5fTZ4UEE2jLYKbre0DoArhLbloR1IwuYh8dOvF9eTNKWVdoN6DdfvcRlBgEO2zUqCVwMC0K3VPrZ0mPvGU/sfG7qeTpvKiET8vNY4eegl8U/X4d8813Hw1sySeDTgXQqzr2TQVBm0jp7B9IuvLsY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710783820; c=relaxed/simple;
	bh=h6CPXrbjIf8+EuG+GPOYrrkLBw+jd0FoRSM4FXbbdB0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KR09kVE/x8jorhKocbcs0vwTKwYeCVjuskFssqqGr+uFZohrFplPNE55MCLGKHU6pv5fztgV/k4HGE1qyAco/hKuX3AZUY7E5w2PlAI+1uiJxXX4/QGyzVIMr1kejRRnFZcYKG31wMZjeYywlVf/VPciWtpqZTp3dDlG9o/iTiQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WNknpojU; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710783818; x=1742319818;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=h6CPXrbjIf8+EuG+GPOYrrkLBw+jd0FoRSM4FXbbdB0=;
  b=WNknpojUi3RatcXjsSU97ykR+gQq+C+x9a2gBCIgz+NXXSDnOfVZdvZk
   wqn493i/9+OzYXt9VKQYjkNmyOQVp8qrc3Ydhb39e1hXjHHeraS0f+3Qe
   9upvlD+z/D8OxogYPNRFqLO1TCXvNC/DRa+rp+udaaVKmRaqe4WprwCb+
   VIri96jQPhIDACwGkyFDo1PP/jLz8Som/xJDtK4cHMHxWugovbcNmh2tN
   TguDOCNGvcJJ7R0TufuCoPcZ4rDmHyWs6BbHm3IwldXXcSpPWsq+TgZHe
   JDWKQzX9m+WR8r9haTeG3YHR+m0CxrYqCyc7FEe/3X0000ibltv5fNg3A
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11017"; a="16160510"
X-IronPort-AV: E=Sophos;i="6.07,134,1708416000"; 
   d="scan'208";a="16160510"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 10:43:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,134,1708416000"; 
   d="scan'208";a="13576363"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Mar 2024 10:43:38 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 18 Mar 2024 10:43:36 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 18 Mar 2024 10:43:36 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 18 Mar 2024 10:43:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BYaDJRefN5YfIDZxOfb7qfdK9M5/EX8JDXdnnfklF1vON1assOaK4q3QrDp94gUX6KrgyVCGhQGH8wWNqsu6vxeY1fRxxoOSh/meOU7J3pH95gmcPQZG90WUJfoNZXhafkQgKtk0OUupAUXL98IF+adzURiXh/Lfx0S+69fwurgx8M4g5K/CBLCMVEYYXWTjWqmEO9YosxLyeghPrRR03JwPlTcl9Gcy432CtI6CHdi7rE60HOSm9I+uelBzpT77rcnvzECyDgeL5XIzxfplGK7XoTuZGFqz2IgIpxwVVYeWET4YQeTx9/FPF1OHl7CYGM7R61yG/eKaFZCXa2XxiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h6CPXrbjIf8+EuG+GPOYrrkLBw+jd0FoRSM4FXbbdB0=;
 b=d2Sm3wJU86ILGeAbyGmQpOSPOAjcLImo8yt8XZS6fgxZYffNZBciLVJtrFB6bSVkC1n2LCTWOdkbdM/DQNrOx7dvT0Of8MP4KgbdIvjn1Km3YmuPX+SiM7CGVl8U1vgarRUzYyoMDhyonSFy9M7Eb13nHJS1H37a18oKRuseymr0vnHIeN6q/DjTh2VDxvgpo0KjEtMkKWFfcNEZHlzaSIwop29gX/LMx6O/eXCjXlNDeLNUEiiZM8LPz1ito/V0sXyiL9ZpSW7jGkD1lO+ayeeXKcl9JWrGg5ic1DzmxrIfEMyi0rVbO3wgwmFigxV0n7puhc4ZWDqXEbKCu5XYvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA0PR11MB4734.namprd11.prod.outlook.com (2603:10b6:806:99::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.12; Mon, 18 Mar
 2024 17:43:33 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7409.008; Mon, 18 Mar 2024
 17:43:33 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH v19 120/130] KVM: TDX: Add a method to ignore dirty
 logging
Thread-Topic: [PATCH v19 120/130] KVM: TDX: Add a method to ignore dirty
 logging
Thread-Index: AQHadmyiHbz3BdiqjUa/DQsd0Q/1DbE4BTCAgADQlACABOw/AIAACLoA
Date: Mon, 18 Mar 2024 17:43:33 +0000
Message-ID: <6986b1ddf25f064d3609793979ca315567d7e875.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <1491dd247829bf1a29df1904aeed5ed6b464d29c.1708933498.git.isaku.yamahata@intel.com>
	 <b4cde44a884f2f048987826d59e2054cd1fa532b.camel@intel.com>
	 <20240315013511.GF1258280@ls.amr.corp.intel.com>
	 <fc6278a55deeccf8c67fba818647829a1dddcf0a.camel@intel.com>
	 <20240318171218.GA1645738@ls.amr.corp.intel.com>
In-Reply-To: <20240318171218.GA1645738@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA0PR11MB4734:EE_
x-ms-office365-filtering-correlation-id: 73d732aa-6a5f-49c9-f16d-08dc4772eeba
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LSd1AuRdEuC0fOfulHCosaxaQEt83/hLlYJusPeNw4w9bX2vjIKGt5vxLRZ8CMLdgQb2mWxac6zLHQhWUPuVqeYwb41/derAAV4L4zyxvLQgV/E/yms7BT2Eegcshhnd6D7sYKrjeIpp9m48nch+EfXZ4HgasVqpsr+jS3br1VPV3iENXi1meiAZZ7BgDfY0D51fF8yrgx9+WA/ExAmnQk9cfJmi8cB0pf9i+ajytqIsgdr9GSv6DD/O0aCD1DxfQC7xIPNFiD11PBHt5iVd3zGn0+a8AKJ5oYYOxABZI4mRKMxyK+mZBt8M2DGoebV/6yCcTjOIiOfsxdVBl4580pp2C5RMIxUKWKe0Vyy2wtDY8fXWQRIwbYv2v88eOD03eP6UEwTo+PVdOwoN590tjotdWXciyTkoPPRnHVLMKYYdY9yt/ONdHJo/evKEV+Qc1PkThNiZKQW3SCQEN1ArEccYxkSd7ebkxMBYcnLAQCtlSfqxw3vzctFrKLObyvKscSfrsPt5Mgo2lGj1hccfAz/gdu6Yk5CbRTEzrbwUHM9tpRcIgYvC0yBzhGyvLZEozwVLw+5Mjdq8i6IcASAPFQTS0DrtuzmuomknVsth85ZA6oeYGztS6p4RYgk1fQPAdi93xh7rz2LZ2Qo/YmnVEnEd+Hf684r7Wyy9yINhIF8H0NitXTjgzDrolys7NIVtSjTW6VjCeiLKdIoR5C7RrE9Sy0ebZiHyeZlZzqQyM2c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dUV0aGhVc3l4TG1nQXl2b1BvcWpQOFVlc3RQSVFkVkRiSVo2bnQyT2NkUGVM?=
 =?utf-8?B?dWprOVVYdjJ2MTEwS3U5STNXL0MxdjRvdy96SDE1VFMvb0JERDIwZk5HWmo2?=
 =?utf-8?B?V1o2QWhMclQ4TUxBRUY5NzFrS1BKM0dYYU5jejJJY1FsSENGeEhGSXZlbzNh?=
 =?utf-8?B?eHBnYzY4cUJHNklEQUxlekFkTit6MkVJQnFEUTlERFdNaWtDVjd5WkRuWUZh?=
 =?utf-8?B?SW5GR05XS2dWeGoxUUdEVE12eEdTYlR6NCsvZEhWOXJkS0w0Tk1DQmFRU0Er?=
 =?utf-8?B?TmFpak1DUWRrdXM4SmY4VHUzWWMzVWFDbzJ6ajRtaGhXS2M2Q2VORTB0K0pu?=
 =?utf-8?B?aENsT21LYjlwMmliSG1OY2RieEd0UWxuSk9zc1FRY3NFMnZZT0xqTDhBZHRn?=
 =?utf-8?B?ZXRIVzRKOUErSDZkUEtRSVRuN1hPRVJHSkpDQkpYdkI2VzVTaEhSYVl5WVYr?=
 =?utf-8?B?SmlJVTJvckh5RnJWdWR2TGpDRlFzVnFidE1JMnI0OTgxdXdxUDZKQk9ZeVg0?=
 =?utf-8?B?VlRzK3dnQlhPdlB2cDRUWmlZYm51YURRNnA4b2FhUkJWTCs3dUZDbmVTYll5?=
 =?utf-8?B?YU82ODVackwzZVppclNnNThmU20vb3BxaFJiWHN1dUYwY2VmeUVNTHlDSVRY?=
 =?utf-8?B?ZzFFTE1jTXQ0OUZ1cmtrSnBqMUsydXFiS1lZYmcydjNEYlNleS9ncjJGbXFN?=
 =?utf-8?B?OVFmaDZIVG9LYTZhOFZRY1llRmd5Wk9ubDVod2hockw1dlcvTldjWWRzaUI1?=
 =?utf-8?B?dENsaDN5dloxUk13aGVYYkdCamF4V0FOVk4rVmc3Mm1IYUkxOUNJeDdLbFp5?=
 =?utf-8?B?dm5zUzVUVWdFNlZmMDhReG1BYkxzR2E4ZUErQW1UWTFOME1UOStWeTVJWDFF?=
 =?utf-8?B?TTRLNjFKWm5FNjN3VTU4bEtwQ3lONXJORnlmdFlISkRpaDkwMDN5VGc5R0Ev?=
 =?utf-8?B?MGJXbGNlNkRubnJSQVB3cmlJUDZvVU5hVTdreDJiSlB5ai93b3h1TkJSTy80?=
 =?utf-8?B?Y2dGNVhtMy9SZUNhYWJzZWhSNFRFb2V3MTM4SDVKeXdZeUI2cTRRd0xKY0l1?=
 =?utf-8?B?ZkJlRElwVWlRSk02ZkR5QUthN1llalBQWjVkWU5Hejg5SFRaOGRoVG5ndEVU?=
 =?utf-8?B?RlJPQzBpYXZaZHpNdmkzRzNNQituWEo4S0FzMXEzTCtnTjZSbTd3ZWtOeTlF?=
 =?utf-8?B?QThGUmw4SzcycTR4YXcvanI2S0t1TjBXQXU5cFl6Rk1QekMzOHRQeEJYNWd5?=
 =?utf-8?B?M3ZCL3FVenBnMEVxaWFGekxiMVhEYmRZdStScEpNd2NWY2N4a0lYVVJHcFdX?=
 =?utf-8?B?MTc1NXhJaG45eVYzUFJKejltNGowYktEa2k2YnRmcUFuYnFERUFrZlhoYTJz?=
 =?utf-8?B?ZGdTQUlQYnlsTmpNM3ZhemswcFlLWFN0Q1FOd1NtV1JzZjVrT0Y4NVJrY0pt?=
 =?utf-8?B?UzROVHFIT2ZMN2diZlZPamx2akVPc1JyalhjQUV2dVhXS3U0TjdlSnBkTFdQ?=
 =?utf-8?B?QmxPSy9ZM1NvMkVYb2ZaSVV4QnVHRm0xcmxPQ3Uxc0ZBWUdkdmdUQzE3ejJE?=
 =?utf-8?B?bEtvT1VXM2JicUFBOVYzWXRCeXozT2ViRnNHQTduM1lWbGl4WGdFOUl0SXkv?=
 =?utf-8?B?NG9CajdHQzZnc1ZMclhsR0hCWnA4T1Jtd3VmeUpmNDVadkZBSlh4YjhKVVQ4?=
 =?utf-8?B?empEWGVWRjFvSFVReUZ4STh1M2xHYllXQ0hialRlUDQ5KzY1c29ZcWZmOFc3?=
 =?utf-8?B?T3FZRU9mRkR2SVFMVHBhUjRDaEk2V2I0Ky9RdVhSaVI0QjliNExCQ2lGMVIv?=
 =?utf-8?B?aFZVaWRnVU0zQTVQbzBsbWw5ekx6M1Q2Vk5kK2lubGw1RXBCQjltWHphbXU0?=
 =?utf-8?B?VHd4R0ZGL0hPOVpkc3A2MHRlK3lBVS90MVNlaW1rZ0VXQnE5YUwwSm9DMy9V?=
 =?utf-8?B?MVQyU0JMMm05a21TdW0zSHgweWM0VW54em9PZkFCd0FzbkpCNk1oVy9KeEZ0?=
 =?utf-8?B?bFczMng3NGtkTmJGdW9Dckc1K3NxcUNkWDNvMWZjSzZYT0F4MHhDdlh5bVYr?=
 =?utf-8?B?VHpWUVNLc2MxMXBtS2YyTHFYM1BVV2U4SXV0dTNubTBzS25JZE5WcEFid0xN?=
 =?utf-8?B?OXdFZ3B5NXlZNWxYVnNVQURhMVU5eVd3eUZudGRxVkpGNUNPVmdyMk5PT21X?=
 =?utf-8?Q?GU5P7WBuh7RwH7USgMX//Jk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E2C859818FB0834788708160012DE6B9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73d732aa-6a5f-49c9-f16d-08dc4772eeba
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2024 17:43:33.6466
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YVYaK/y2q36tmTGptSuUhY8ia+rrIz5gnkpmE4876ESBtK+0JSKeRiHP4Q979aIxhQ+RX/xIK0TGyDxuh2EVQzE3l6uL7xOCk0s2w0VAZf8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4734
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTAzLTE4IGF0IDEwOjEyIC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gSSBjYXRlZ29yaXplIGFzIGZvbGxvd3MuIFVubGVzcyBvdGhlcndpc2UsIEknbGwgdXBkYXRl
IHRoaXMgc2VyaWVzLg0KPiANCj4gLSBkaXJ0eSBsb2cgY2hlY2sNCj4gwqAgQXMgd2Ugd2lsbCBk
cm9wIHRoaXMgcHRhY2gsIHdlJ2xsIGhhdmUgbm8gY2FsbCBzaXRlLg0KPiANCj4gLSBLVk1fQlVH
X09OKCkgaW4gbWFpbi5jDQo+IMKgIFdlIHNob3VsZCBkcm9wIHRoZW0gYmVjYXVzZSB0aGVpciBs
b2dpYyBpc24ndCBjb21wbGV4Lg0KV2hhdCBhYm91dCAiS1ZNOiBURFg6IEFkZCBtZXRob2RzIHRv
IGlnbm9yZSBndWVzdCBpbnN0cnVjdGlvbg0KZW11bGF0aW9uIj8gSXMgaXQgY2xlYW5seSBibG9j
a2VkIHNvbWVob3c/DQoNCj4gwqAgDQo+IC0gS1ZNX0JVR19PTigpIGluIHRkeC5jDQo+IMKgIC0g
VGhlIGVycm9yIGNoZWNrIG9mIHRoZSByZXR1cm4gdmFsdWUgZnJvbSBTRUFNQ0FMTA0KPiDCoMKg
wqAgV2Ugc2hvdWxkIGtlZXAgaXQgYXMgaXQncyB1bmV4cGVjdGVkIGVycm9yIGZyb20gVERYIG1v
ZHVsZS4gV2hlbg0KPiB3ZSBoaXQNCj4gwqDCoMKgIHRoaXMsIHdlIHNob3VsZCBtYXJrIHRoZSBn
dWVzdCBidWdnZWQgYW5kIHByZXZlbnQgZnVydGhlcg0KPiBvcGVyYXRpb24uwqAgSXQncw0KPiDC
oMKgwqAgaGFyZCB0byBkZWR1Y2UgdGhlIHJlYXNvbi7CoCBURFggbWRvdWxlIG1pZ2h0IGJlIGJy
b2tlbi4NClllcy4gTWFrZXMgc2Vuc2UuDQoNCj4gDQo+IMKgIC0gT3RoZXIgY2hlY2sNCj4gwqDC
oMKgIFdlIHNob3VsZCBkcm9wIHRoZW0uDQoNCk9mZmhhbmQsIEknbSBub3Qgc3VyZSB3aGF0IGlz
IGluIHRoaXMgY2F0ZWdvcnkuDQo=

