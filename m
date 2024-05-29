Return-Path: <kvm+bounces-18253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CEF3B8D2AA7
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 04:13:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F0FF91C21DB1
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 02:13:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7EDD15ADA8;
	Wed, 29 May 2024 02:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Dv/QBfw7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E8B22324;
	Wed, 29 May 2024 02:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716948812; cv=fail; b=cUFXQq7mzlPWzSEaodpUhmP6mkMyopYwBJ+pVh8FMiFF4N3XFoG2+Kr/B1xtDguUmf7phlK/K8Psl+kFAEZ/nY/fYTsW9JtYsnWOdQbscllV1L3Cf4errC2wZBzIIqZsxHX2efzZFKW6/1YLCoNiXs6Y8ow4eilqPzxaSOitg2I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716948812; c=relaxed/simple;
	bh=7QRCaTl2Al7Y489mHkHhNpaxqF+e+k3jfKLdLBmFiyE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Is7CYB5HA/SRvg5xwUrxGbsshBCyVr2Si2Jm/PhLjcvAKoz9fZODAn5lUfXI+Yw/D+FMCalz5ZjkvPISIMGw/Wci5D62cIeOlmVY1khlWXoD0eQzkPorvREUghHON8tBVMRyIsuJU0XPlIYHPFSEWcA0+GVzWj5v9UITCf57UfY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Dv/QBfw7; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716948811; x=1748484811;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=7QRCaTl2Al7Y489mHkHhNpaxqF+e+k3jfKLdLBmFiyE=;
  b=Dv/QBfw7uVPad7scV9aM+OPVQg2vMQEGIcQWvuu6UTWA5cOiQ+kbOi2P
   AIVdGqvJ5hFXjSUyG1OlaB6IVxqv+b7TklYn9jqx7qIHqTy1/6ia5Sm2E
   NUYBVdN/xGoWzdQ0hs6OBkygwT2520r/ICpve+nNJuhy1Iolur51zCFNR
   0iHb6K+56CzakKEbr/m+VsgZJt1lCic9OrKJMmKnSi7FjfetIL7bP66xo
   ChFZwjlJGBLGfyVa7GGCRNrxnWPu/evc9uSF1MZ4ylwdDa8dV1VgPO6Vb
   EsFZe+FVJYnWjMq6iDTHRA8lQNXIZmlL8zNcQlz6/qYxI2J/Ztvw9T/J4
   g==;
X-CSE-ConnectionGUID: PAe59+JnSE2r30zZTcEPsA==
X-CSE-MsgGUID: kWqoAHg5S7ysDKoV0krH8w==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="13496310"
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="13496310"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 19:13:30 -0700
X-CSE-ConnectionGUID: Hh1/8gmySBK98qga0KG2bg==
X-CSE-MsgGUID: 4DD+E3c+T9avqCzHub+k9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="39700217"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 May 2024 19:13:28 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 28 May 2024 19:13:28 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 28 May 2024 19:13:27 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 28 May 2024 19:13:27 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 28 May 2024 19:13:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W7iFgiyExMK/CWVPEYhNSMYqy0cWT1obObeDrW238yuKXcfpbqQAMn/uyLjGK1WM/10B4AANXQbI5+fqlvg3vDReDvmm7nUnPxXgJL6EW2nH+uDPkRUMKQihDyUfTjhvFTHK0yjN29gYH5EDxpjM/Rl50WHRAzO0RJsPFPWB/dvvuwyoO3/okTY0gsZKozpT2G6+vCGRLGZrGxXvFctF6zfi+XBHja6JYvld8xLqETaRFBjPRB2iY8I2t+q2mug5XX9LVXVtX2RQJ+BEugi+Qncxi3lD7JLAFlnduUx9aQMwwaa/DcA8c180z2/NhVKj3A8PgbPw+lJZa2shZyVC/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7QRCaTl2Al7Y489mHkHhNpaxqF+e+k3jfKLdLBmFiyE=;
 b=VcEh0znd9d3jCQzqpuhX4sjWeu4JPIdHzcUztdlqhVB2iZGEBrayQ8jLk1EWpfb9MzcrL6gIA2uiieZXUG9hLfXZKYqxSr7jHAlwL9ol3/MUEWzM8MUmRmaUJetjYyFQlWcj69fMh4PAh2zfseZPuF8bn7v1zYZavHasPUkCDmSgEkcXIDPQ51VTZM4cFWzlBQSHX9nb84c3w+cDfVJ3CNSKBPVkCrvV4Tjy/od0Vb6rW6yvnSNNUow67oCHT42VoNU61b45xfsTqbL3qs2bn/8lXluYdMgbPyyI5QVTTuT6RcsX76Y1buLWw9CBdZczwgMuq9o+ozUJrATFniI5sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA0PR11MB8333.namprd11.prod.outlook.com (2603:10b6:208:491::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30; Wed, 29 May
 2024 02:13:24 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7611.030; Wed, 29 May 2024
 02:13:24 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "sagis@google.com"
	<sagis@google.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "dmatlack@google.com" <dmatlack@google.com>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Topic: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Index: AQHapmNTP3XGfqhyyEaM/KHu10XBU7GtWqMAgAAvzYCAAARZgA==
Date: Wed, 29 May 2024 02:13:24 +0000
Message-ID: <6a831f1b429ab6d1dd3e60a947cab7ab0b3f7149.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-11-rick.p.edgecombe@intel.com>
	 <a5ad658b1eec38f621315431a24e028187b5ca2d.camel@intel.com>
	 <20240529015749.GF386318@ls.amr.corp.intel.com>
In-Reply-To: <20240529015749.GF386318@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA0PR11MB8333:EE_
x-ms-office365-filtering-correlation-id: c0595892-b323-40e5-169c-08dc7f84eb77
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|366007|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?M01xTW5zM0U5NVlBaThsS2RaZ2pmMDd2QXJXMjZoVjVIcXRSbHdLYnlLdXNh?=
 =?utf-8?B?V2VqS0NKUmtkeTBTcDNOK1lXZjJLZG1xNDQyRm90TGVMNDZxUFVMdWF1OG9S?=
 =?utf-8?B?Vm1uUjF4ZEFwQ2oyT0ZFSEVRRTl4cmhES1ZHUWs0N0VPZitZenJVaHRjZFVU?=
 =?utf-8?B?cGlNNXN0RW53VWFMa2NmaE1oZkgzaExoSHUvcHNRQUE5d0d3WDd6Vm1UaERr?=
 =?utf-8?B?QUdCeFBsZzRaZTN3SUhITC9Ed3d2VXluQUVlbVpkQzhvdjE5VTJLcTN0ejVV?=
 =?utf-8?B?SnVTTFEzV0pBbmRuOGh5dm5MY2JVWEpLc3ROTk9pbk02ZEYzVGwreEJvMyth?=
 =?utf-8?B?MGRRbkt3SG8wU0dHanJzSERVTXRiQUlXT290ZC93Rm9nOU85SDRlYjhQc095?=
 =?utf-8?B?a2lwcVJ5NU9jL2c1dlAyNFd6bGwxL0Z1K0tQNFlYSU1YZ2YzWFh1dUZlaHd5?=
 =?utf-8?B?OXRDOHcvL0dNVm13MGVmRmh4ZTJoUkdyeFAxdW1nalVTbk1WQXpaS2kzWSt0?=
 =?utf-8?B?T1RBaVdla2thdVQzUW1VdkhVckQ4VnZGUk9oYjhCd3d0OVNSK2wwekN0RVZp?=
 =?utf-8?B?SlM0bDRpVEtKVDlITlR5c29PZHdtNFdZZCtqbHZsQWh5TnFraDM5VkNORXBM?=
 =?utf-8?B?anhuSHUwZ2lxdHVFeDI3dHlDc2dVOUErWEFMYVdUY3p5L3BxQ0tjdWdLYTI3?=
 =?utf-8?B?SkNGL2I4VkVycU1WRVpYeXpoR1VIZXV5MnN4VHNEOURXMGNGZUhwYXhmekRm?=
 =?utf-8?B?YmZxeEtNMUZrdHZkLytCd3BJbFlFU2E1SlBXM1pjbFFaMXlaMFNQZ0ZhOUVi?=
 =?utf-8?B?a0Rrd3dTTHJxNVptVzJPM3NCc1RibGYyR1RBc2I5OThlWUhGb0lsTEcyZmxV?=
 =?utf-8?B?VU5SMVV5WTBnZmNoT2pCemZUZ3Izak1ycjRDeTUyN1I0L3FMZ3BrbEoyUWVo?=
 =?utf-8?B?cUZHYUR5MWg5blZyWE1BNWQ3WnpBNW1CRC9vSUt2Z3JyVHkveFVUQlVuUmo3?=
 =?utf-8?B?ZENJa21FZjJPNFFoa2l0UElFajAveVJ1eDI5aHdQYkc1Ymd1OW1KUENhWWQz?=
 =?utf-8?B?eWQ2Y0Y1WTh0dDVUb3RoTzB4a0ZaTzlQejdnUzk5Y2FpZkZhNDZieU1mRG9N?=
 =?utf-8?B?MVFnQzduSDRkaVltQS9WQkVtRkdSbXBKREhsUEk4eU9iL3VIMTM2UGlKM2dI?=
 =?utf-8?B?bExpb254T1YrUXpnbDN6d3JvK2U4bzR3RUh1Ry9Ca0h1Wm5TSTNPZjJmcGRO?=
 =?utf-8?B?VGVadSszMEU1akZxaTdlVnA3dHRzNEN1OWZEMmVWOWFvUExlYTZxb09nUVh4?=
 =?utf-8?B?N3RhdVJ3M2NBNTZNbGJkcVFERi9Ya2UyS2xkYXowNW9pcFlFL2JHZk1zblRW?=
 =?utf-8?B?M2N5SFJ6UmFCaXpVZjQvaElldWpQS2ZZZTJmdWZ3R1ZsVmNYSzhvMUNaNWc0?=
 =?utf-8?B?dW5uYjd4SkFxWG5qcEhzNkhNRm9weFQ5OEFWL2FiQndPNVZjc3dubCtiUWlX?=
 =?utf-8?B?eFZXK2FKb3hJV0VyV0pDaXVQQVRYSWlVbUhsNnVuRHRtZDl0Mk1rS0VhS3Zq?=
 =?utf-8?B?SlFTYWR6cElzZmI1TWU3UStUY3dGc2Y1d0c5bXZ4a3Y4aWhHclVJMWJWMDJm?=
 =?utf-8?B?bmhKdkJwR09BekEvcVI2ZDVDSWJhYmxyM2kyNjlpbCtQSTA2TkwvNmQ5b0N4?=
 =?utf-8?B?ODYxdG5wKy9YMmlYcmpnR2RjKzluRkpBOU9CbHBzNVNqVW1EdlVoUEJ4aXZa?=
 =?utf-8?B?T0JCUDFaY2JBQXBJWmMwcllJaFFDYVYzTXdXTDNJdDZiTTZtMkFNbGswSUFz?=
 =?utf-8?B?RzdxdDRhZXNDWU5rRkM1Zz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bnZxSUJSMytlQmR2VU8wVUUrSW5DRExJVkdHV0xzTmU2L21Hd01rWGhGMWZj?=
 =?utf-8?B?VHkrUjFaS2ZDK1N4TkYxb2U0elJGMko5UW9GZXJkQms4TThFdjRmc3RnNEZk?=
 =?utf-8?B?dVdsUmFSRE1pY2htR3lPM3RKajVVYW5Md3gzTGRCY0p6NWpNQlY2cWZXc2FS?=
 =?utf-8?B?M09iOEMzMGcvY0NpS0ZBeUNiNnVkMEtTNERRcFljOHFsVWlXUHBFeVBqWmp5?=
 =?utf-8?B?WGhhV0N6Rmw2dmFnUFIwaW5qYTJKSEE4RFB2eEV5dnhSbmt0eUdpR0o5Mlk0?=
 =?utf-8?B?YmlROEtqbWtZNUZtcXFERDlvOHlKa2Fjc0JxbHBxd0ZKNU9TTnBCdjBtakVy?=
 =?utf-8?B?UWx3OTJuK2VCaE0vM205a0tPYmpTQ3B1WWYxVEIybDBjWU8va3Zid25rQXky?=
 =?utf-8?B?NDZ1VWtXeW94S0l4NlB4YnFBOVdlRktMTXRiMmQwaTArdDdqN3BKRVlkaysv?=
 =?utf-8?B?OGs1ZDFQNFN5cTAzUkwrbjNtSS8xTElnZGNVUE52RUtXSndiTHZYdWNMamxI?=
 =?utf-8?B?RWZFQi80S2MvQW4xN2V2bWJENHlXWlByOWRQTmE4K0w1V2MvRExCRDUvTjRz?=
 =?utf-8?B?VEZZa2VCRUw4Qk1mZHJFMkFVMXJPUjV0UGVBV005dURTa0xmUUJYTG1LMHdR?=
 =?utf-8?B?VHBiOW1lQnQ4dHlOR2pVaWd5ZmpNQnRYZWNtM1U0OTFMNENBMWVzWUxtVERZ?=
 =?utf-8?B?RGJMYUtaNDNrZ1NiZCtQT3ZzdE5BemJibFBpbzFuaWtmZzZWaXZORnZsUXpW?=
 =?utf-8?B?ZjFnVHozWUpSZVFjMW5nMXFFbEZ4QUMrakQ1QWJ0MlVJR0c5RUxNWklac0tY?=
 =?utf-8?B?dDF6S0gvckw2RGhrb1VZVFNJY29YTUJOWGFxMWFjVG8yYm5vS3lwbW9LcXlm?=
 =?utf-8?B?ek1KODVNS1pQV1dHMzN2Q1NzRHd1S1p0b3ZUUTJKb0NndzhITUZpZmQ0OXFR?=
 =?utf-8?B?aHg1NTlIRnBxRGFxWU1KeTg3OWtodWYweWRaKzI4alZNT3FMZUhDbFJISzV5?=
 =?utf-8?B?cEx1QkYzZnpvZGo2QUdlRGRyYUZnV0RaZDB4TXRYUGhkWm9Ga1M3cGlYSm5Q?=
 =?utf-8?B?ZFFSZzgybFBKMDJaN1o0VDNSRE5PTkg3MTM0RTU3azRRNU5kZUxpczBYdEQv?=
 =?utf-8?B?djVLdTNZaHFFaHl3S1JVTmltZWtwL3NXbHB5azBUWGNncXJIN1Z1ZjA4djRG?=
 =?utf-8?B?by9vR0pnam5GYjNpaWs4SmdVQ1R6aldyUzhFVkJ1V01pRUFCcUNyVWZOQ3Zr?=
 =?utf-8?B?aklZcjk4L2pFYlNHeUVIanZQMll5V0FCSnl4VmtmQXZIdXRMQzVWNElwdkxZ?=
 =?utf-8?B?WDJGUG5zcEd2b05YTUcya3BSSnM4KytjNE90bjBEUTdHN1ZUMjNRWnBQNW0y?=
 =?utf-8?B?TUZUaU5QTkJvZ0ltV215UXVPUkl4NkZNZStYbEc5RjNIMGZQYUpTY2RENVkv?=
 =?utf-8?B?ZXlDY051T1ZTcHdGcUFYR0thR3VvVng4blBUaTIrZGRQL3IzOXJ3R3BCTjRq?=
 =?utf-8?B?OXlCaGhsQkhIOUhqQ0NWYWI1OXhBUXZmWFVWOW91YmVITjNraUxJcUUzNldU?=
 =?utf-8?B?dWRwZkNFTGFURnR6U0lYSnc4WjhUQ29wU2h4d3RacjEveENTNWtFcUVlWHQr?=
 =?utf-8?B?OC80Z2hFSksvY1g4d2VTdlUyeXF6NVRSMThmY2JabnEwQjU4M0tDWmVaYXVX?=
 =?utf-8?B?VlpmK2dmNzNGTHZPeWVxOUY2a25PUjhMVktJeUU2UU0xeE5TcWxBbTZLMWNl?=
 =?utf-8?B?VXdiOXR2aCtCN29zRlN5TmdrM0NSVGtBMzR3OWRma0lYc3NiOU5tWVZ2eEpR?=
 =?utf-8?B?MFFxTDR0c2JtYis1NklIVU16VTh4TGl4dHFFYmJFVG9tUkRKRTVPdlVSNTc1?=
 =?utf-8?B?RDBlWW93dGtma1JsdjFMSkp4dFYraVAzWDUybWc0bXRZODRmR1hhUkVpWUVt?=
 =?utf-8?B?aGlmSlB3SWFwbzBvbjErYXZxVXRSbU5qbm9hazMzcTE2TU96YWRZckhYWTNE?=
 =?utf-8?B?b0pCWGJPdmd6aWt1WFgvME5DZWVmNDFDdWpVTjB3aDhIYWtCc3Q4bndoTTRW?=
 =?utf-8?B?bDNsZHUrZCtpc0tkak56QTk3bjBad0NORU54Wm1IQ1MvZHVESVM4UXR6U3U2?=
 =?utf-8?B?L1g2MlhJVTVscWVNb0Izdk1GZC9rS0lGWEcxN0w1RHNBUWw3SUs2aFBIZkdQ?=
 =?utf-8?Q?NB1ihlW6SHNyQO3K+N90On4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6B1410145B84164193363DAA24C7EDBE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0595892-b323-40e5-169c-08dc7f84eb77
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2024 02:13:24.2339
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Tfk6KKD9XovlYy5j9qofKA9WZyT6Id4k/Qrz3JHy2sKUzX3IoiM2EsnkTkvmJI2+bbufYDsBmcZsGc5ilC3Tt4zlc8Gs6GkIYc0KmgnAhjY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8333
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA1LTI4IGF0IDE4OjU3IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToK
PiA+IC0tLSBhL2FyY2gveDg2L2t2bS9tbXUvdGRwX21tdS5jCj4gPiArKysgYi9hcmNoL3g4Ni9r
dm0vbW11L3RkcF9tbXUuYwo+ID4gQEAgLTQzOCw2ICs0MzgsOSBAQCBzdGF0aWMgdm9pZCBoYW5k
bGVfcmVtb3ZlZF9wdChzdHJ1Y3Qga3ZtICprdm0sCj4gPiB0ZHBfcHRlcF90Cj4gPiBwdCwgYm9v
bCBzaGFyZWQpCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCAqLwo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIG9sZF9zcHRlID0ga3ZtX3RkcF9tbXVfd3JpdGVfc3B0ZShzcHRlcCwgb2xkX3NwdGUs
Cj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBSRU1PVkVEX1NQVEUsCj4gPiBsZXZlbCk7Cj4gPiArCj4gPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKGlzX21pcnJvcl9zcChzcCkpCj4g
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIHJlZmxlY3RfcmVtb3ZlZF9zcHRlKGt2bSwgZ2ZuLCBvbGRfc3B0ZSwKPiA+IFJFTU9W
RURfU1BURSwgbGV2ZWwpOwo+IAo+IFRoZSBjYWxsYmFjayBiZWZvcmUgaGFuZGxpbmcgbG93ZXIg
bGV2ZWwgd2lsbCByZXN1bHQgaW4gZXJyb3IuCgpIbW0sIHllYSB0aGUgb3JkZXIgaXMgY2hhbmdl
ZC4gSXQgZGlkbid0IHJlc3VsdCBpbiBhbiBlcnJvciBmb3Igc29tZSByZWFzb24KdGhvdWdoLiBD
YW4geW91IGVsYWJvcmF0ZT8KCj4gCj4gCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCB9Cj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBoYW5kbGVfY2hhbmdl
ZF9zcHRlKGt2bSwga3ZtX21tdV9wYWdlX2FzX2lkKHNwKSwgZ2ZuLAo+ID4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIG9sZF9zcHRlLCBSRU1PVkVEX1NQVEUsIHNwLT5yb2xlLAo+ID4gc2hhcmVkKTsKPiAKPiAK
PiBXZSBzaG91bGQgY2FsbCBpdCBoZXJlIGFmdGVyIHByb2Nlc3NpbmcgbG93ZXIgbGV2ZWwuCj4g
Cj4gCj4gCj4gPiBAQCAtNjY3LDkgKzY3MCw2IEBAIHN0YXRpYyB2b2lkIGhhbmRsZV9jaGFuZ2Vk
X3NwdGUoc3RydWN0IGt2bSAqa3ZtLCBpbnQKPiA+IGFzX2lkLAo+ID4gZ2ZuX3QgZ2ZuLAo+ID4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaGFuZGxlX3JlbW92ZWRfcHQoa3ZtLCBz
cHRlX3RvX2NoaWxkX3B0KG9sZF9zcHRlLCBsZXZlbCksCj4gPiBzaGFyZWQpOwo+ID4gwqDCoMKg
wqDCoMKgwqDCoCB9Cj4gPiDCoCAKPiA+IC3CoMKgwqDCoMKgwqAgaWYgKGlzX21pcnJvciAmJiAh
aXNfcHJlc2VudCkKPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJlZmxlY3RfcmVt
b3ZlZF9zcHRlKGt2bSwgZ2ZuLCBvbGRfc3B0ZSwgbmV3X3NwdGUsCj4gPiByb2xlLmxldmVsKTsK
PiA+IC0KPiA+IMKgwqDCoMKgwqDCoMKgwqAgaWYgKHdhc19sZWFmICYmIGlzX2FjY2Vzc2VkX3Nw
dGUob2xkX3NwdGUpICYmCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKCFpc19wcmVzZW50
IHx8ICFpc19hY2Nlc3NlZF9zcHRlKG5ld19zcHRlKSB8fCBwZm5fY2hhbmdlZCkpCj4gPiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBrdm1fc2V0X3Bmbl9hY2Nlc3NlZChzcHRlX3Rv
X3BmbihvbGRfc3B0ZSkpOwo+ID4gQEAgLTgzOSw2ICs4MzksOSBAQCBzdGF0aWMgdTY0IHRkcF9t
bXVfc2V0X3NwdGUoc3RydWN0IGt2bSAqa3ZtLCBpbnQgYXNfaWQsCj4gPiB0ZHBfcHRlcF90IHNw
dGVwLAo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIG5ld19zcHRlLCBsZXZlbCksCj4gPiBrdm0pOwo+ID4gwqDCoMKgwqDCoMKgwqDCoCB9Cj4g
PiDCoCAKPiA+ICvCoMKgwqDCoMKgwqAgaWYgKGlzX21pcnJvcl9zcHRlcChzcHRlcCkpCj4gPiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZWZsZWN0X3JlbW92ZWRfc3B0ZShrdm0sIGdm
biwgb2xkX3NwdGUsIFJFTU9WRURfU1BURSwKPiA+IGxldmVsKTsKPiA+ICsKPiAKPiBEaXR0by4K
PiAKPiAKPiA+IMKgwqDCoMKgwqDCoMKgwqAgcm9sZSA9IHNwdGVwX3RvX3NwKHNwdGVwKS0+cm9s
ZTsKPiA+IMKgwqDCoMKgwqDCoMKgwqAgcm9sZS5sZXZlbCA9IGxldmVsOwo+ID4gwqDCoMKgwqDC
oMKgwqDCoCBoYW5kbGVfY2hhbmdlZF9zcHRlKGt2bSwgYXNfaWQsIGdmbiwgb2xkX3NwdGUsIG5l
d19zcHRlLCByb2xlLAo+ID4gZmFsc2UpOwo+IAo+IFRoZSBjYWxsYmFjayBzaG91bGQgYmUgaGVy
ZS7CoCBJdCBzaG91bGQgYmUgYWZ0ZXIgaGFuZGxpbmcgdGhlIGxvd2VyIGxldmVsLgoKT2ssIGxl
dCBtZSB0cnkuCgo+IAo+IAo+IAo+ID4gT3RoZXJ3aXNlLCB3ZSBjb3VsZCBtb3ZlIHRoZSAic2V0
IHByZXNlbnQiIG1pcnJvcmluZyBvcGVyYXRpb25zIGludG8KPiA+IGhhbmRsZV9jaGFuZ2VkX3Nw
dGUoKSwgYW5kIGhhdmUgc29tZSBlYXJsaWVyIGNvbmRpdGlvbmFsIGxvZ2ljIGRvIHRoZQo+ID4g
UkVNT1ZFRF9TUFRFIHBhcnRzLiBJdCBzdGFydHMgdG8gYmVjb21lIG1vcmUgc2NhdHRlcmVkLgo+
ID4gQW55d2F5LCBpdCdzIGp1c3QgYSBjb2RlIGNsYXJpdHkgdGhpbmcgYXJpc2luZyBmcm9tIGhh
dmluZyBoYXJkIHRpbWUKPiA+IGV4cGxhaW5pbmcKPiA+IHRoZSBkZXNpZ24gaW4gdGhlIGxvZy4g
QW55IG9waW5pb25zPwo+IAo+IE9yaWdpbmFsbHkgSSB0cmllZCB0byBjb25zb2xpZGF0ZSB0aGUg
Y2FsbGJhY2tzIGJ5IGZvbGxvd2luZyBURFAgTU1VIHVzaW5nCj4gaGFuZGxlX2NoYW5nZWRfc3B0
ZSgpLgoKSG93IGRpZCBpdCBoYW5kbGUgdGhlIFJFTU9WRURfU1BURSBwYXJ0IG9mIHRoZSBzZXRf
cHJlc2VudCgpIHBhdGg/Cgo+IMKgIEFueXdheSB3ZSBjYW4gcGljayBmcm9tIHR3byBvdXRjb21l
cyBiYXNlZCBvbiB3aGljaCBpcwo+IGVhc3kgdG8gdW5kZXJzdGFuZC9tYWludGFpbi4KCkkgZ3Vl
c3MgSSBjYW4gdHJ5IHRvIGdlbmVyYXRlIGEgZGlmZiBvZiB0aGUgb3RoZXIgb25lIGFuZCB3ZSBj
YW4gY29tcGFyZS4gSXQncyBhCm1hdHRlciBvZiBvcGluaW9uLCBidXQgSSB0aGluayBzcGxpdHRp
bmcgaXQgYmV0d2VlbiB0aGUgdHdvIG1ldGhvZHMgaXMgdGhlIG1vc3QKY29uZnVzaW5nLgoK

