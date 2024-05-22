Return-Path: <kvm+bounces-18005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 814E48CC9E1
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 01:51:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C4AB1F22680
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 23:51:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 576FB14D28B;
	Wed, 22 May 2024 23:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ei1LFuv6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117862E631;
	Wed, 22 May 2024 23:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716421863; cv=fail; b=Gf3+RsG6gYPWXDMyrBZkx1hClc6duIfTzGtWX7s+R7fyHK8wkAEPRqRmONlfGj8kawfJb7NZHF/3oWOm+0+Ssl5B7U/jMX4AXW7M+bkcpHlCjz6sQ51t3VsjAR2mfkMRVzrBAA0tPdlER/TgwQsD18N7oXnoPzS2IPpE3knlp4g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716421863; c=relaxed/simple;
	bh=RGdFZjFyodPOozFB6agG6lT+uN8kgnv0BwLXQW1JJok=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=m7e5946ULbcU/W3nLuhD9Dg6eJlER43Rkn+wUI2hK3m6P/Gldmy//qo0Zt9AZMaKfcVM4xU4YCvUShDKs8P/34c02e4mhC6JFdXqhCf1u3Z1cD/e9PWL0MiKx4gMLTcO/hu6UBieLaXpeuBPxKB17PAY9KZb55X7iVWOrWQK8I0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ei1LFuv6; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716421862; x=1747957862;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=RGdFZjFyodPOozFB6agG6lT+uN8kgnv0BwLXQW1JJok=;
  b=ei1LFuv68jE4rh9X5fbRG6HzKwewmNVtPUoa2cRHvc6LIdikRt+3r6ND
   Ln2yThm+FJPdyX8E2AwYmMgJzeWqeLeRfEP5ST16WLZ/DionH+dxyAcHn
   y7V51ncIdDwabAAf0wcFtlxQYXGrANweqlNjLNmMcIUdnz54aN6cOfqVd
   wOsh1M0xmBwoa/quDp+NIvln2ssbjLJGAKdJMWDYf8U+8sF7mVvYrW++6
   X6bVXgb8z0McOqHMLccsoKLkMQVb/yThljwXg/OEUyvD6eT5Zpmx7giGn
   oIlVAGL7csSinkHkHx9d00lGbWVQh5niQ4lkWS/up65bMaT+6JK3lADBt
   A==;
X-CSE-ConnectionGUID: LfcS26r3TrmMr5XONrurVw==
X-CSE-MsgGUID: IkPnWWAmT92Rvy4cYDDznQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11080"; a="35219497"
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="35219497"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 16:51:01 -0700
X-CSE-ConnectionGUID: 9i+RAzQMTlG2+YbWbPzYag==
X-CSE-MsgGUID: pqxu4LCiQ82UWbC/7NrXpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="33572593"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 May 2024 16:51:01 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 16:51:01 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 22 May 2024 16:51:01 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 22 May 2024 16:51:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NVGMKegUS4yIYh94DUPr+PWj98FUuovxrqFNIL7GsO3EJoN9/CeUqa2aJ4wVEbDmMM2vv0zDNejKNn+ChuB8hRf7d3vei0VQ2ONRpEIJnfJ271h4/8MKEB9gbpNhfgpKRQhoSb+bVyGYQaoqbW2Lm5k6oKipYtnxK+ohxtjIisXMzLbN3GNx0xfhPF2l0/DPxDB4EikN/rZ3egFUG0E83gLvBOrBUFjMDlbNntd1Dnptxr17cxwlnY0tt2TqIgsGVVKgGIEdjF1sj+gyad3mbWIQVpdomwenNDEZC1im9s+hcPg8i3KHSAkr5Kj5ro0sGYpSEAlrqSpkFhAond/ZQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RGdFZjFyodPOozFB6agG6lT+uN8kgnv0BwLXQW1JJok=;
 b=ghm84S3wleZIDuuTezRYsqDaxyDSyN/OJ5GQMskKggpCW1qXeLp/4/PmP1dQ59YofJlUKGHFVGU/ZCSXESU07aNvoQWOBQ42q+G733SQlMKLn/k6OyKcKQHnkHmWbEMmFIYMvKeeXcfXQ8sWrrPc/2wUikjz82ryceJ8o/cq6U5ofIUVElxRXHda5vNsjiFGaOijZcWD+6c+d15ztrZCtXJY8oDDUw+zaTjDyUb/3UQWvDZrjg6Sy1LPWsb3ynMhNWHceM62u2P7AEazsMyi/WzhEWzc2KeTuX+qWqsoy+0XJdzaIK+ubJyrkRj0G4Vj4m9BeVavCPlU6kmdWISWlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ0PR11MB6696.namprd11.prod.outlook.com (2603:10b6:a03:44f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.21; Wed, 22 May
 2024 23:50:58 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7611.016; Wed, 22 May 2024
 23:50:58 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "seanjc@google.com"
	<seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>, "sagis@google.com"
	<sagis@google.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "dmatlack@google.com"
	<dmatlack@google.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Topic: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Index: AQHapmNTP3XGfqhyyEaM/KHu10XBU7GZCeQAgAAJxQCAAAs0AIAADfKAgACpkgCAADtVgIAAM8qAgABzkACAAGxrAIAAmmaAgAAQyQCABP6CgIABBVgAgAAS3ACAAfwwgIAACfeAgAAKoACAAADagA==
Date: Wed, 22 May 2024 23:50:58 +0000
Message-ID: <4a6e393c6a1f99ee45b9020fbd2ac70f48c980b4.camel@intel.com>
References: <20240516194209.GL168153@ls.amr.corp.intel.com>
	 <55c24448fdf42d383d45601ff6c0b07f44f61787.camel@intel.com>
	 <20240517090348.GN168153@ls.amr.corp.intel.com>
	 <d7b5a1e327d6a91e8c2596996df3ff100992dc6c.camel@intel.com>
	 <20240517191630.GC412700@ls.amr.corp.intel.com>
	 <20240520233227.GA29916@ls.amr.corp.intel.com>
	 <a071748328e5c0a85d91ea89bb57c4d23cd79025.camel@intel.com>
	 <20240521161520.GB212599@ls.amr.corp.intel.com>
	 <20240522223413.GC212599@ls.amr.corp.intel.com>
	 <9bc661643e3ce11f32f0bac78a2dbfd62d9cd283.camel@intel.com>
	 <20240522234754.GD212599@ls.amr.corp.intel.com>
In-Reply-To: <20240522234754.GD212599@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ0PR11MB6696:EE_
x-ms-office365-filtering-correlation-id: efc2e7d0-ee6c-4bea-ea21-08dc7aba0741
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?SWNHOS9xVWlqb3JJSDFabVZaeTBvQ2lYYndCbitEMXRkUlhQYTh5a1JtMUxO?=
 =?utf-8?B?aUtjVGgwRC8raUZobEpWaXlrWWVudEk4VTl6b0NFWkFyOGNiVjZCWlh6a2Vo?=
 =?utf-8?B?KzZMei9LMGFhekpUdDd6OEkwc2hUT1NwenZEZ2tER01hbm1YSFpZYWYya3NL?=
 =?utf-8?B?aWdLRm5vVFBIZnN0cndDTkxvNDJyeTFLRjEzUzdIMjF2MDBESTlzeEVMYk1W?=
 =?utf-8?B?Y3cvYzdUVnVxcGl5OFpGbno4SG5UZzFaN0k5bXFSNGNiZlA4d0UyUno4RkhF?=
 =?utf-8?B?S3BubVpycXlsd0xnT3NkbjZrai9XQTFYKzFCS1VyV0RvK0RVWDllNWEvdXd4?=
 =?utf-8?B?WmF1QzVobWdtTXAwQkNLdXpQQzE5b1JNeWo5Slk0U3VrWjlMMFl5dDZkcGRs?=
 =?utf-8?B?bG11d2lCS2ZZa1dpY1dqd0p3WHhWdUdQTHFpRENkRjd2TmwxK0wvTjJuNFVu?=
 =?utf-8?B?enZSQmpYaE4ySDV4NjJXN1lOSncwVmZ6WHE0Z1hrbWpxN2tUQzQvbkZHa29Q?=
 =?utf-8?B?UWVpL3Y4YmN2YmhzUWozTXdIT3E3M2lNcGVvR2U0T0Q1bTVzNm5xYklnWTNB?=
 =?utf-8?B?dkZnTmw4NU1qTzdMTSsxSVBMQTAvOVkweDd5RTZCUGthU1lZVG05azNleHJz?=
 =?utf-8?B?b1Bjb1pRNmc2REJWLytDT045Wit5bW5FaHdpemJmVnJYM011bWt5L3lBTDNu?=
 =?utf-8?B?YWNCSkp5NDloVm1qTzRHUGF1dlpXZldVaXZhZmkyT0xJaXlycFpwUHd3TERw?=
 =?utf-8?B?bE5pR3R2Tm5PV3Z2ekh6VTRUb3BLRWt6YWNnTFNDRVpZWnJ3REJHVDd5RG5s?=
 =?utf-8?B?VytXQTRtTUwvc3VjbWdFYmplTzJmbUdsZlR4cXhYODBiWHZqUXprNXMxMkJz?=
 =?utf-8?B?UXV4TTVabnIzdC92NkxsU3N3eHRlOWJLVVdpNlE5Z1AwdmhzUGFjeEZpcXU1?=
 =?utf-8?B?SjZrbVRhdWlOMTRnRjN3WFNDbEFNVjBGUytpYnI3cVBlU2Fza0ZsajY4S2ZD?=
 =?utf-8?B?aFpsd0pNRnVaQ0hCTnpFbzN6dDFndzg1cnVDTzlrZFo2amd4TFdXQUpvQms4?=
 =?utf-8?B?WnZ1OGp2TFcxVGs5Uk1tQzFnK1lqWm41TUFNdkFTaVJLMDdzd04reDJsTFV4?=
 =?utf-8?B?ZWpWcFFCQXJ2MEU2R2ViMExpZDExbXJoZHBzMlpLcncxQUtIcXFoVFhCcGls?=
 =?utf-8?B?SHoxeXRBZFhVRkFwbGpWUFd6WWt5M0J2SmN6OFV4anpTWmxna2VNWVdZU0d5?=
 =?utf-8?B?eHZ3Ym5aay85NjliSmJ1VFFJclpkR1pkVkJSOUtlbjBhNzBwcm0wM3ljREg2?=
 =?utf-8?B?UDZVYkJGZkRwU3Z2d1dlN0pSLzU1VHpzTFBnRHBNTkJkM3JnUWJzd09PVlM4?=
 =?utf-8?B?MWpwL0NHcmJ5V3hMQkJpY0w5QTVZU0pUUHBqUGVKTWRrc1oxbit2N0ozcERP?=
 =?utf-8?B?ZXY2SnAzQzJZaWRWSTdZakNYMlMzTVdnUlNicW9veWdVT0NKY2F1T0ozajNP?=
 =?utf-8?B?RFhRZUM2Y1ltUXdLYUYzdVhMTm9iQVhCUmlobUpxUUVSQnllQnZ4WjJNVkZ0?=
 =?utf-8?B?bW5GUVJIMXlyODBqL1JiNllCS0FwQW9vWW9wZVpZaTNlWnhEaTJyV09JcUxK?=
 =?utf-8?B?MVArMW1NWmFITHBEM0k2bDNFSDhGVkU1aDA0T255d0dwaThFVnZSYjNleUxz?=
 =?utf-8?B?TVE5K3RCS3JiSUk5RWV1RWxNNVhyT1VmYnM2U2ozVTZrK0tDTTVKczNSV0t3?=
 =?utf-8?B?OERzOTRrcjNaVEZYd0NOOWtWb0ZCOEVFaURIRnd4cUREdU5Tc0NJR1RCNFZZ?=
 =?utf-8?B?SVhHaFlJeW9iVXhaUm4xUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OHhjNmxZVWFMZGUrK2lIUEFqYWF4TDltVFRDVlZOOE1mVlVDMUtjVktpUFFW?=
 =?utf-8?B?TktCOW5KQ1c5akVNZDlUTzVWbWhScTc3WVVVUS8yRjlUTWJuLzQ3Ryt0VnZI?=
 =?utf-8?B?aVI0UDZRSys0d0c5NkdRVVNoZ210dGRRZkJ3SFhGTEkxVU9JS2xmSzRFV2dD?=
 =?utf-8?B?b1h3ZGFHczJBYlNCRU4wZzBvVFBpYjFmcFBnWW94UUJ2VVMydndYSlZPYUho?=
 =?utf-8?B?U3M4eWM2czNYamkzTVJqWkNoU2hKUFl0YlErQUp5RzFwUFFJN3FWSWZMUVBa?=
 =?utf-8?B?bTZhdS8vdUo1R1VSMlM3N3RJdG1ibDZ3RjJSaC9wMW5PUk9IclIvSzR0Q0FH?=
 =?utf-8?B?TVZ0ZWN3bUlPajk0S0VPdXAzSEpQRDJNWXp5enQwdVl3ZXRzeFZVRUFKZDJT?=
 =?utf-8?B?OFV1N2JvVVBXQkY5RW1XQUdwamFSNlpJYXFHK0ZHdW9kNmRYcEErRlR3YWJv?=
 =?utf-8?B?M28xUDNLa2Nma3N5SVVqdXlsVjRNYTFVR2JibVdkY3QrU3RTUUswOFREbnA2?=
 =?utf-8?B?UnVpTTBPb3JhRnJWMDcyekRQZ1hUZU5LQnNUWjFMcmMrWlV2b0VJTGJzalBN?=
 =?utf-8?B?aDc1dStNR3VJRU96RFl5YmhCUW12QXMrRWV1M0JIeHBxMGxjMmJ0UU00eUdW?=
 =?utf-8?B?cENEU3ZMd3JoYWJCQXZFaHVzUnJtLzhWTk1zcmxvbnhjNDFHYWVEQ0swbFFi?=
 =?utf-8?B?Vms1aTRxTms2ZW9hUGlHbFgwMkVzWG0wdkJOdTJCUWNMQThqbUROUHBqellR?=
 =?utf-8?B?WFdvR2VpVmp0aERjQjdCT2s0cVdYSlROZ29sZURtYjhZUTYzU29oV1c2N2R4?=
 =?utf-8?B?TmNhV05VMTA4cUNJQ2laRHRlSE5OTjJwRHI2SHhUN1R4a2hPaWFmekdmSGFZ?=
 =?utf-8?B?VnBRSHZpYm9sanc0eUJPQXhhNDlvZkdFVDlLUTJFOTVKMDk5a2xIVGZ0enFR?=
 =?utf-8?B?VTNnUC9nVVlyZEZybTlucTlJemxZY0NXVXhGcVQzakJ2eUtIU1NlaVhKYWdk?=
 =?utf-8?B?ekQ0cjFaYUMvMXJodTRZbDZWS0tPS2NBR1M3bFJrN2Z4bGZOY2NEbWZoL0pn?=
 =?utf-8?B?RWZ2d29XWG82T1hrYjczN0V0ZitBUGFzN2JXT3puQ2hhZ1dmYkRDUnpTNG1Q?=
 =?utf-8?B?TUNyVU1LS1VvTmp4TUI3OWlMNTRCc0hKU05zUm5rMlFoSzFBbGtkRDZIS2ky?=
 =?utf-8?B?WHNrTWtCNGNjeHlONS9nM0trRVBuY1FlWHdTd3I3SW9haEV6ZGhZNExHWnl3?=
 =?utf-8?B?bGZXMDByWTFYcmdjMFdLNFVnTGhaWXpYVXc4a0JPUzZ4Q1lvZmtYSmZLQkk3?=
 =?utf-8?B?clVsdEdGTU01QWN0ZlFaUEFUQUgrUDVlbVR6dEp5cjBmL0ZSaWhRbWlGWndO?=
 =?utf-8?B?VmJ6UDVKWExpei9ab1Q3V05oU3N0RGpmSjVrWnB3dTZPYmp1bTRWanVvcDA3?=
 =?utf-8?B?YVdxMVgzc1J4K1pScUk0MzJabmpKREpkUThZQXhMbEtuTStmU3Z4OUphS1ll?=
 =?utf-8?B?Zlpsdjc4QXQ1WVlmR3pURGZLQjdBc24vRmRnRkxFZ1kzc2RWSjdacVNHdDVa?=
 =?utf-8?B?ZS8rM3hVM3M0ZkZLZkQ0dytscHNSWEtmRy80aytHQXF6SlZEemxYQmo3M3Ex?=
 =?utf-8?B?MXVPK1hOeE5VMTFuR2xmOEMyYW1WajhJUTZCU2Y1QXJ2WDZLMWRwWlVsdDc0?=
 =?utf-8?B?UWpFQTVwWkM5WnVZTEw3TDdLRUdqNnVvOTFjbkVmVEY1RURWVGhSemJ4Z1Rj?=
 =?utf-8?B?M3JHajhyU3BwRWxlOUFxbnB0ek1WcG5EU1BDWW9tck1UbkczU3A4N0l1WmFO?=
 =?utf-8?B?MndwSUdzT3N0S2NvZVpzUWhnQ09JSExpZVdOV2F5VFYrclorSVpQQmxGWlhl?=
 =?utf-8?B?MDdBMFhGQzQyendVa0NTRjNLanlIR242WExUMldNK3U0QzA1YVp5OFU0MTFm?=
 =?utf-8?B?eHltR0FJQmxRQzdWMDRtOWFXQUlZd2FrUVZkbVUvSjdNanhGMEtlSEs5c1hP?=
 =?utf-8?B?U3M2OU9mb2FUZk0wdjN3V05FNDNSK0wzMGJLWDIyaGUyaEozbGVTdll2RlEz?=
 =?utf-8?B?QlIwc0Fpa0VRUE5QUkxsQnd3blBEQXpndnpVN0t6Tk5lRGhEM0NhWmUwS01Q?=
 =?utf-8?B?dnYybUw4Q09zaWR4cm9jV2wxdW4zT21ZLzVKamhEOWVTeUVEK2NYcW9vN1Z1?=
 =?utf-8?B?d0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <246A37730AD6F1459FB0E69C127186E5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efc2e7d0-ee6c-4bea-ea21-08dc7aba0741
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2024 23:50:58.3789
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rHKC86+vHFvaOzOLlTPn3JqhT2l7VntEP6EF0QXSWAD0y2Aj3XnPIEByGkslgPYL5hNIfnzTOY4F1JKIB0FxrN4hOtIpCPEJOPISw74KXSY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6696
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA1LTIyIGF0IDE2OjQ3IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gPiBIb3cgYWJvdXQgd2UgbGVhdmUgb3B0aW9uIDEgYXMgYSBzZXBhcmF0ZSBwYXRjaCBhbmQg
bm90ZSBpdCBpcyBub3QNCj4gPiBmdW5jdGlvbmFsbHkNCj4gPiByZXF1aXJlZD8gVGhlbiB3ZSBj
YW4gc2hlZCBpdCBpZiBuZWVkZWQuIEF0IHRoZSBsZWFzdCBpdCBjYW4gc2VydmUgYXMgYQ0KPiA+
IGNvbnZlcnNhdGlvbiBwaWVjZSBpbiB0aGUgbWVhbnRpbWUuDQo+IA0KPiBPay4gV2UgdW5kZXJz
dGFuZCB0aGUgc2l0dWF0aW9uIGNvcnJlY3RseS4gSSB0aGluayBpdCdzIG9rYXkgdG8gZG8gbm90
aGluZyBmb3INCj4gbm93IHdpdGggc29tZSBub3RlcyBzb21ld2hlcmUgYXMgcmVjb3JkIGJlY2F1
c2UgaXQgZG9lc24ndCBhZmZlY3QgbXVjaCBmb3INCj4gdXN1YWwNCj4gY2FzZS4NCg0KSSBtZWFu
dCB3ZSBpbmNsdWRlIHlvdXIgcHJvcG9zZWQgb3B0aW9uIDEgYXMgYSBzZXBhcmF0ZSBwYXRjaCBp
biB0aGUgbmV4dA0Kc2VyaWVzLiBJJ20gd3JpdGluZyBhbSBjdXJyZW50bHkgd3JpdGluZyBhIGxv
ZyBmb3IgdGhlIGl0ZXJhdG9yIGNoYW5nZXMsIGFuZA0KSSdsbCBub3RlIGl0IGFzIGFuIGlzc3Vl
LiBBbmQgdGhlbiB3ZSBpbmNsdWRlIHRoaXMgbGF0ZXIgaW4gdGhlIHNhbWUgc2VyaWVzLiBObz8N
Cg==

