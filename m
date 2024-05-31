Return-Path: <kvm+bounces-18556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9409F8D6C5A
	for <lists+kvm@lfdr.de>; Sat,  1 Jun 2024 00:17:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B05C31C23477
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 22:17:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E74980626;
	Fri, 31 May 2024 22:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jd50vNmh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD06200B7;
	Fri, 31 May 2024 22:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717193826; cv=fail; b=MeyPoKMkCdD3rCsSUNPy7/3381/bmTAof7gtlwND+X2eboXCQKB721pLpiVp0mEOB4JMopsKA08DgnLorX37b/aPFljQ04X1g2GKJaxiM16KRctzlgKO09/DfQhZJkadcozZkfljb4I/g0e6u3g2x0KrXNxG7/nVZ9CerkyR2So=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717193826; c=relaxed/simple;
	bh=I68b2vGM1AeL3u1vePN8knYFWChcTAeq6pn5pTTEU0c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oBnYlnizTNS5LZr6b5qSJF4Uup9bxFjwQ4A+LZrOODBE6jHLcTtLehNT7JQesd3kmBb0ln34SklnjajhB/IqkzPArFyKb3mVJ/8b0QgpiO8MSRhzjPhNOtefRRbthxL93Dg2KlLouk/egwcuTRVA8jzMRxTaW2F3BZr9B5/376Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jd50vNmh; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717193825; x=1748729825;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=I68b2vGM1AeL3u1vePN8knYFWChcTAeq6pn5pTTEU0c=;
  b=Jd50vNmhZwpF4Bf8vtFlrZ4pAML0WSVyuaYwzUHUKRfYjKJO7v/kTSU6
   GnjKntQKCei8eMzhqqXkut1khVz/90cBXI3SiffZc7M1c4FVv73EEw1LJ
   a5Tkny+FMeeo8OHkCu2B0kBhnrmlxgU3QmxomhcXR+iT3y9vdKrbovHuz
   scRGb0Al7AJZ5a2ahjAiRShUys9eVac4dnWfy/aw6DHWHG/Fsg9rl0MfK
   QRpXRaEDVNwnkcqpHMnRpHlokT8ap/8jAUKlFlkDbZNQRnQ0rObD+bajy
   M1pROSvriI/Q0LtAKbLaUWCYJDHcgk4yZEEjdsQwTWcEHLYd8wvBd2oTg
   w==;
X-CSE-ConnectionGUID: iLNhdYYOTw+FFF0VQc0/dA==
X-CSE-MsgGUID: WzEFcTf8Sb2OY9q5QYDiQw==
X-IronPort-AV: E=McAfee;i="6600,9927,11089"; a="13626749"
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="13626749"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 15:17:04 -0700
X-CSE-ConnectionGUID: 2WxfzNjYTsGFZSj7QAfaMg==
X-CSE-MsgGUID: S6/MRb7bSyCGm8zW7bnOaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="59469921"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 May 2024 15:17:03 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 31 May 2024 15:17:02 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 31 May 2024 15:17:02 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 31 May 2024 15:17:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nKGtgbzrN/XsUVNa1HOaph0EK5+RmtFFEMzNZ9vqhgmC0rzf0Cv5OhVj5wPTCLoPg2HV0IN8b8CzrEoWwH9qQl6yO9FMYZMtVJTbUxs3rbtLp9r3ULyd3gyj2BHYggthvMRA927YVtk1z70UEL07NCxNeYRqNHIqFRpR506xb4ESh63A6ZaH1lzmNuTPRcHvo03/XKWIZbajBvNeyRVWe/shMTaTb8pylR+B8PWRHT8T+IG0kuFZ2KakKZ0KBcTLHERWDrLEW0V0jxCxqkFW2tjy5tRQUBwPcOWVtGdExI7OD/BP1maS/iOOVokm519haxEVWeg4azxjfC14WpKwtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I68b2vGM1AeL3u1vePN8knYFWChcTAeq6pn5pTTEU0c=;
 b=MTVObHu8oPRCvMmpP6CTROKr0Qy/a7XZ+4Q6E/BMprfB9+szHdejghqm8u1IUAWZYWMTk3O9JfjFFKooN5VdW8qMDtjkcqQucXsk82oxRIJkz34YtR4IkvjZ2icRg7ycpVSuCJSlEBFHN9GmsyUtSkfcCHLDKKlJmNDey14ICrxVqBD30woDwTf8tF2Nvyq/70ffWIAwg5kd87/Js/Hfdcr/aRahdcd3iaEqJ7W8O1FIYeflsobV6ysDDYBA67+z5RSjQya44omI0EhbHNWvChQTteBDdEq5Ad01btPC2ypnjo2gzFD/HbMU359UExlB5Iqn/Wp7ggShpJw5OLw9ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CYXPR11MB8664.namprd11.prod.outlook.com (2603:10b6:930:e6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.22; Fri, 31 May
 2024 22:16:59 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7633.021; Fri, 31 May 2024
 22:16:58 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Chen, Yu C" <yu.c.chen@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Zhang, Tina" <tina.zhang@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
	"Yin, Fengwei" <fengwei.yin@intel.com>, "sagis@google.com"
	<sagis@google.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yuan, Hang"
	<hang.yuan@intel.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v19 070/130] KVM: TDX: TDP MMU TDX support
Thread-Topic: [PATCH v19 070/130] KVM: TDX: TDP MMU TDX support
Thread-Index: AQHadnqu5I+yEA5c80y4LFwbE/1wVg==
Date: Fri, 31 May 2024 22:16:58 +0000
Message-ID: <98e906539441c6839ce7399644906bfca1653062.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <56cdb0da8bbf17dc293a2a6b4ff74f6e3e034bbd.1708933498.git.isaku.yamahata@intel.com>
	 <ZgTgOVNmyVVgfvFM@chao-email> <ZlL2m3PKnYqc3uHr@chenyu5-mobl2>
	 <20240529005519.GA386318@ls.amr.corp.intel.com>
	 <20240529005859.GB386318@ls.amr.corp.intel.com>
	 <ZlbftscsqGQjWZqj@chenyu5-mobl2>
In-Reply-To: <ZlbftscsqGQjWZqj@chenyu5-mobl2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CYXPR11MB8664:EE_
x-ms-office365-filtering-correlation-id: 200d2f45-d52e-4446-8aed-08dc81bf6338
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?Q0NhdjhWNWF2Wm05SHJWNW9OeU1USVBrWVZMVWR3K29UN2F5Z0IwZ3FyY3hv?=
 =?utf-8?B?NWp0cjRiRXpJanVWSlV0SllXTVdBbzBhZlNHQ1VxR0Q4eUU3dVdkMFJHSXIr?=
 =?utf-8?B?bHFQZG00UXU0WTVUNHhrb0JtM1k0cHAweDN4TVgrdXhTdjB4dUFqOFRyS05U?=
 =?utf-8?B?TmdLTHRIb0I3dUZzMU04V2FIRDBWTndITE96Q3RnVTZmSm15bEEyOEQ3QlFj?=
 =?utf-8?B?Z212SjA2OG9VV0JkMUw1aDRCQlFlNFpsRDFDRkFhWHY1Y1RJN3d6a2paTXRw?=
 =?utf-8?B?ZUtIZzd1eFJ6ZHpmMWp1TFV6RlQ2RkRNdDlXUWljREZ2QW94dVIzWlJpcGJI?=
 =?utf-8?B?SzNrNzcrL3FzSTkzUU1DQjZBSDdnT1o0OFRnSmdHUkFjT25wMHY0cmJBWjdR?=
 =?utf-8?B?MG5ndWJCZmNHTzE2MDc4Q3Z4TnUwMW92WWg5bTdLOW1aQTFMZ3FxYS9HSFU4?=
 =?utf-8?B?Rnd1R3lReFVZbzFxd1dnY2tHVksrc08ySFE5blF3aGpaSFBWK1R4czg4TWta?=
 =?utf-8?B?WlFZaG5mYzlQTzNFUStTTzFxaEhIK2hyNW9PaysvWjVjQmtsbDJNVFZ0RzBG?=
 =?utf-8?B?aEJSbkk5R043ZU4ybGtpZHpJVk5TNVNtQjl1NFZxd3Z4RSs3NURVMXRvNGVp?=
 =?utf-8?B?eDNQbE12emMwQy9ySE1VbWgveGpsNDFKamlhb29HZ1NMT3RsV2Q2bkdWdE04?=
 =?utf-8?B?aTMwWE1uSFZhaEpFcUhoWXVNRk5LejV4VTkvdnA2QkRnT041MjdSei9FRkow?=
 =?utf-8?B?YU91QmtWNnp5ZjZyYkJxWU9iUW9CU3cxRkE0QkZvNEtSK0tyTTI5SXd1a2J2?=
 =?utf-8?B?dUV4cWYvbFVZd3U0VERtVWQ0a1Yxd0EwR1FUUTNvZ3REQnlwelRyWmE0ai9y?=
 =?utf-8?B?Y3R6SFMreXcwd1o2ZHlhU1UvQzFjS3dBSjJxOTRVY0NzdnRZZmQxVG1ZUjEz?=
 =?utf-8?B?V1VSeThTWlk2U0dpWThFU1AyRThqRlZEd0h0NnRDdVdIZU1xaVRkaG05Z281?=
 =?utf-8?B?Y3J5ZmdJbG9nbEJuYmRGcFJWa2ZESmliNVVrdjcyZUdFaUMxMFZFelZRZ1Bu?=
 =?utf-8?B?ZTJGQlFiR3JHU2FJQ2ZGZXFiMVJZVEVLdkdlY0FBU3hiT2ZXeUdIeERmd1hv?=
 =?utf-8?B?N0NnYnFyS3ZMVzZINkl3b2FPbk5mZmZaQnVyRzZPRFlDQXFMZmFlbTF1OFJQ?=
 =?utf-8?B?MC9RZkozai92R0FLSGNXcTFiUFBmV1FLM3lCdHBQTzJyVnYvNHJDTGdQV3li?=
 =?utf-8?B?NWR6aDJIUkF2Q0M3SFh2djN4VnR3a0tNL25MNEdLdVdaaUcrRFQ0WnRjdG9E?=
 =?utf-8?B?N1ZNcElXV2F6L3B3RHFlZ3NmZmdMUzhEYVRKOGxyU2t3N1MxdERqVmRJOGZQ?=
 =?utf-8?B?M09LUE0xN2hZOVR0R1N4Lzk5dEpWckxLRkJ5UTZ0bEhxZmdtQkFzZjY5UFJT?=
 =?utf-8?B?bm9UVTBqUmlGOFl4OGJqOWVOUm90alFMODdrRGVVUFF3SUZoMkwzZzNJZ1V0?=
 =?utf-8?B?TmVDQWxtRUV4SVZpY2haT3BKWWRnc3U2cHZ1SDVjVk9ZLytrS1dxK3BZWmdN?=
 =?utf-8?B?SHlra1VEUFZkRTNWMjY0M1crZmZvVVdWL29zQVVqWmtGcExHdk5heTJrRWN4?=
 =?utf-8?B?RnM1VENzMThUTGtGSEtWMXd4NWdJcjUrem40Z0taZ1hwbnE4WWRaRzZobEFo?=
 =?utf-8?B?ZDg3WUpCbWVhOFdTcGtzajRqVThkTWViMGtTeWduKzZQR3lqd0I0S3hCbkJQ?=
 =?utf-8?B?OE5kOCtIOHR0SzBzbmZTZURjT1lSbXJkZytXbkFKQzBUVDFYY1BZVkthNkZ4?=
 =?utf-8?B?M090bTF5UktJaHY5TEhsdz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WElrSjBXL2xWU3EzSXNtWG4yS1huN1ZMblVIVkZUSWtJcUdPekFJd3AxS09T?=
 =?utf-8?B?YWh5VTF6NzZndnI3MWsvMVpNMm1ydjZzbVBuU2NGZGk4RE9BNUlURzVOdjEx?=
 =?utf-8?B?MVkxOUNtRzdWZitwTzhVQkdOMTVnS09rcTdZbG1GY1c1Zk44Rng3NU5mZnpV?=
 =?utf-8?B?bFhtWGhYcWNpckdRVTFKK3ZoZXZaK2M1dnFicmtHS2RzKzh2emtNS0VZbTVN?=
 =?utf-8?B?RVlHWkdlTEs2WVhYRCtQcXFYRmhuaUtQcGhLKzFvUy8xQmJpUi9heVRiMU9h?=
 =?utf-8?B?S1JZeUJqZFY1NzhlalNCNXdVbEc5Zkh3WTE0cngyL2xZTm9pSExmM0pmVHVs?=
 =?utf-8?B?T2d3U05NbE9JbVlrSDEzVWE5WTFsRnR6OGNRYkdkOFdndllnTlRQN2N4LzdE?=
 =?utf-8?B?U0JOQW5Qb2RqcE82cU9FUXg3NFUyZldUM3E0Y1lBZE9LQnFnemR0K1hqTG5t?=
 =?utf-8?B?bFhrNm5sZzBqOHFFVHNsRHk1akhkWC9HNkxEc3l4M0JvaDErcmJWTXIwbW0x?=
 =?utf-8?B?UVNzUjhqUi9Jblc2WWhRSjJDWmYyUGk2ZC9UOFVkZTBQQTI1THN3MnpFOHZ1?=
 =?utf-8?B?ZXIreU01ajVIUWh3T1RTK1lGYkl1dWFlcGlTYTRJN3BMMldyVGNmMDF6SEl5?=
 =?utf-8?B?QkFGZDE4SytPNmQvUEp2MXRSNVlpUnl1Q2JBNUVSSDY5bFRWM2t1ZUpXelFD?=
 =?utf-8?B?ZTZIR1B6aXY3Yld6czVQcVQzTTdnaGJ1b3g4T2N2aytXaDFoV3I3TGFjY1Bm?=
 =?utf-8?B?V1hzQXNaU0xyQzcvMHQvWDZCSXdEdllFeDVocXpUVkJWOEhGa244SFM1ZDdw?=
 =?utf-8?B?a1VxZE5BYUh3L2t2RHZURDJMU0xsVVpEamV1L1ZBZE55b3NhdjMwV0ZYMmR3?=
 =?utf-8?B?azRINytBK1h4SE5iMVl5RDgwb2pSRXJiZmVmNnRVU29SQ21HTlpYWFV3dmZ2?=
 =?utf-8?B?VHVhZVc0czY3QXVPd1plSEI2WmlPOWUwaFhEWUlBazhRRjdBa21qeUVqOFdQ?=
 =?utf-8?B?UTM3ci84SDY1VTZhVFhxMnJycW0ydDZKdU9HaTlXTzZGWVN1WSs3UGxPb2pG?=
 =?utf-8?B?VGhkK2R1cXhPaE1qME1aTW11Q0tlbnZhNlBiU0JQay94b1VubFNucTk4RFgy?=
 =?utf-8?B?RUo2U0I0Tk4rTnMrcWxkLzJtMnhudk5MTCsyUThIRGhaMHB6cmxSUS9mTTFw?=
 =?utf-8?B?L3lUcUxxTUkwNExjQnVBUHROaFZLdmRWVTFuSWxNKytXWHQyVjRMME1mMTJk?=
 =?utf-8?B?WGdBdDh0UzdCS0ZaTExTbEp0U3Vrejc0N1BwdzZQaEYrQjRnZ3hVLzJ6WmFp?=
 =?utf-8?B?MUFJUEJFTnh0OVBNUFZ3ejVFUng3SjVPd2p4YS9sdStBTE15Q3QwNzlvYjEr?=
 =?utf-8?B?NXBpVG1UVnJLS0ZQVnFpUFBmT25ja05maGJ1cGQ2ZmNDZXdjZkswUVBGYmcw?=
 =?utf-8?B?Ykp5S1hlTnZvaE92Q2VuWlZlWWpFS2VidWlnV0JIMnZ2RjBpNXVKU2hmdTk5?=
 =?utf-8?B?THh6WVp0dnJaSzljT0EzZlJRYll2WWFUaXdkRW5SaVZhdU9oWEo2OXZYVVJo?=
 =?utf-8?B?NnI0OXphYmQvNk0yanJMZG5PWXJkK0lWUHJML05PMjhzMXdYbUJhNnhYbmN0?=
 =?utf-8?B?cUdadVlzYUNsU3NoS3Q1ZGtYQnkySk4rb0RKZjRQVnZSMUI2bjlWQ1VOeCsz?=
 =?utf-8?B?MThCeHZqMFliZlh3N084RjVjNkx2RUdxT25ZT3JiV0U4NVMwUlowd2hKb2Z6?=
 =?utf-8?B?T0Z2ajlJNmkyYk4zRnhkRU40R2tTUFB3T0V3c3RjZ2hqUmJrNnBnZlhlVkZV?=
 =?utf-8?B?K0xTTmpydHVwbWtpMC9DOGh2NEFZcko1NmJ4VSs1dTVWazdvN1N5aHA2VVJR?=
 =?utf-8?B?eWJGME9EanJDWldqNUtCUmdwdlh5d2lwMjBPMXc5S25USzRiOG4rQ1Fza2ll?=
 =?utf-8?B?MUNVYldDM2ZSUCtJbExQNmtiSUtRWHpuTmVlbXBMa2YreVlzeGM0LzYvZnBW?=
 =?utf-8?B?K0l6OVZZeUhwd1dReFBlWEpmU2ptSkhxTXpyNi9sdTRCL3R6MFlKelZsMUJR?=
 =?utf-8?B?RG1WUGZYME9xeCt5UW9qbjZVdW52WGxUcFFQVitaVThPbjNBRDlrWWljcVZn?=
 =?utf-8?B?Z2w0eEc3MmJDT1pWM0RDaHBmbWNiQ0o5cnVSMlAzcHc1UTE0aEIyQjUxQ3Rh?=
 =?utf-8?Q?q8bhkq6/j291Wd3A5lhuV5o=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F967E9F995C19E4BAC5957E6EC536880@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 200d2f45-d52e-4446-8aed-08dc81bf6338
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2024 22:16:58.3012
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FhfP9UA756XQ4V3ilPNpPT3uUIbeeasdyGO7uplTtwv1n2+XgnjuiYCv6/2j7oX8U/LgIugo2C6lXprRKTFQRfYY6H7ltFPctnQF/VNG0ic=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR11MB8664
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA1LTI5IGF0IDE1OjU2ICswODAwLCBDaGVuIFl1IHdyb3RlOg0KPiA+ID4g
WW91IGRvbid0IGxpa2UgSVNfRU5BQkxFRChDT05GSUdfSFlQRVJWKSB8fCBJU19FTkFCTEVEKENP
TkZJR19URFhfSE9TVCkgaW4NCj4gPiA+IG1hbnkNCj4gPiA+IHBsYWNlcz/CoCBUaGVuLCB3ZSBj
YW4gZG8gc29tZXRoaW5nIGxpa2UgdGhlIGZvbGxvd2luZ3MuwqAgQWx0aG91Z2ggSXQgd291bGQN
Cj4gPiA+IGJlDQo+ID4gPiBhIGJpdCB1Z2x5IHRoYW4gdGhlIGNvbW1pdCBvZiAwMjc3MDIyYTc3
YTUsIGl0J3MgYmV0dGVyIHRvIGtlZXAgdGhlDQo+ID4gPiBpbnRlbnRpb24NCj4gPiA+IG9mIGl0
Lg0KPiA+ID4gDQo+ID4gDQo+ID4gQWgsIHdlIGhhdmUgYWxyZWFkeSBfX0tWTV9IQVZFX0FSQ0hf
RkxVU0hfUkVNT1RFX1RMQlNfUkFOR0UuIFdlIGNhbiB1c2UgaXQuDQo+IA0KPiBZZXMsIGFuZCB0
aGVyZSBpcyBhbHNvIF9fS1ZNX0hBVkVfQVJDSF9GTFVTSF9SRU1PVEVfVExCUyBzbyB3ZSBjYW4g
dXNlDQo+IGlmZGVmIF9fS1ZNX0hBVkVfQVJDSF9GTFVTSF9SRU1PVEVfVExCU19SQU5HRSB3aGVu
IG5lZWRlZC4NCg0KSW4gdGhlIGN1cnJlbnQgZGV2IGJyYW5jaCB3ZSBhbHJlYWR5IGhhdmU6DQoj
aWYgSVNfRU5BQkxFRChDT05GSUdfSFlQRVJWKSB8fCBJU19FTkFCTEVEKENPTkZJR19JTlRFTF9U
RFhfSE9TVCkNCglpbnQgICgqZmx1c2hfcmVtb3RlX3RsYnMpKHN0cnVjdCBrdm0gKmt2bSk7DQoj
ZW5kaWYNCg0KSXQgd2FzIGFwcGFyZW50bHkgcmVwb3J0ZWQgYnkgVmlqYXkgRGhhbnJhaiBhbHNv
Lg0KDQoNCjAyNzcwMjJhNzdhNSBoYXM6DQogICAgRGVjbGFyZSB0aGUga3ZtX3g4Nl9vcHMgaG9v
a3MgdXNlZCB0byB3aXJlIHVwIHBhcmF2aXJ0IFRMQiBmbHVzaGVzIHdoZW4NCiAgICBydW5uaW5n
IHVuZGVyIEh5cGVyLVYgaWYgYW5kIG9ubHkgaWYgQ09ORklHX0hZUEVSViE9bi4gIFdyYXBwaW5n
IHlldCBtb3JlDQogICAgY29kZSB3aXRoIElTX0VOQUJMRUQoQ09ORklHX0hZUEVSVikgZWxpbWlu
YXRlcyBhIGhhbmRmdWwgb2YgY29uZGl0aW9uYWwNCiAgICBicmFuY2hlcywgYW5kIG1ha2VzIGl0
IHN1cGVyIG9idmlvdXMgd2h5IHRoZSBob29rcyAqbWlnaHQqIGJlIHZhbGlkLg0KICAgIA0KU28g
dGhlIGJ1ZyBzaG91bGQgYWxyZWFkeSBiZSBmaXhlZCwgYnV0IGlmIGFueW9uZSBoYXMgYSBzdHJv
bmcgc3R5bGUgb3Bpbmlvbg0KcGxlYXNlIHNlbmQgYSBmaXh1cC4gTm9uZSBvZiB0aGUgb3B0aW9u
cyBqdW1wIG91dCB0byBtZSBhcyBvYnZpb3VzbHkgYmV0dGVyLg0K

