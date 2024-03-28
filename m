Return-Path: <kvm+bounces-12924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 08B0688F468
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 02:13:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B12F92A9A1D
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 01:13:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C3841D540;
	Thu, 28 Mar 2024 01:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gSpwBwyH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA60A3C0B;
	Thu, 28 Mar 2024 01:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711588376; cv=fail; b=I2d1lyCyZvUyVrGr7uQ5aAN2iLpwQmcv55kJ35LxQ6lVRul4GQJPMgF/uuN5MWM9bCPKJIiYo05yPhuiGDjcZRroRL6fj0Mw9Cnr9WCDBMyANHIOnDEgoaw0RkuVdygiWswtEaenkjP5QWiTdQfw2tpq3EgWwy7wYwTXMX39guc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711588376; c=relaxed/simple;
	bh=CO12TySnH8tMoEOq5ib2g8rlK1oIFwslyhPrwtSmjJw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=j2ds9K+Y7nxEtqsmOFHor14v2/Uee6d8jUUjv8H2uAxuUMhbiz5OxXVQV42MHa54CuCM4YeTmhc92R7B/PJ0ax2Vq9kAbUKCTsFUhmv9OJ8NJ1EXzWgtqn13EYDSXo1ampxWtbfZALXXo2q9HkDxhcwArSGQrQ1+NMWDNaAifdQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gSpwBwyH; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711588374; x=1743124374;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=CO12TySnH8tMoEOq5ib2g8rlK1oIFwslyhPrwtSmjJw=;
  b=gSpwBwyH620WE2DZ8BRPdUKPXGf5Y/gTUIanBug11nGVmaHXGUjT566R
   yYMuvxxboddYhltzvqJAICiCgNrmeCrOT069crfZWsCfl++XW5mG6Ym/P
   qGAupBBf8Ktijq8IENMWFih3EtwwJHdI+HC71mixdRqVhfU9g4fNt2C7o
   y1HYDlwxPtxcTDC2tgNrqLb4Yaq4zp8r9T09LAYfLWlhkZKvsNh01JGZ8
   Bm0sbYz+izx1o+sHTjMieXUdCCGGmHA+II/Sw9gtOPtJd25H8iad42WES
   YRZFYOu7FG45nXZc7Er+hU5kR2rF/wrSvuFZ86qOziC6NMq4IX8MLf3FT
   g==;
X-CSE-ConnectionGUID: sP68rrYwQZarhe96fCNJJQ==
X-CSE-MsgGUID: IeNPFj/QQ6m+pjP97NSIRw==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="6584845"
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="6584845"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 18:12:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="16878398"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Mar 2024 18:12:53 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 18:12:53 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 27 Mar 2024 18:12:53 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 27 Mar 2024 18:12:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FfKcugDhlFIeVYYzyCwaj8FIfbt6oqGqq2Vi5Va1/UZOzanJIabyLTPuJ0KW4QslOulqfI/y+1x35Nc4d27uS5GVq0kH+X4Ym3fVOB/46VcfvGYtyXnb5JpOVrLrswtEedSeuMP0ldCoJazyt6VKmprxGWlUsJ69c3un4pM/NT4B1vYxmemG6L5rGTkv1Hg1lJ5URhwHcDNJq8epvBXoo6RLqMLvNe93GFAoBM/ANWE4/g9dV4HYbFRSDJGfwylMXwkxBkE7f5CaBYGrYuWvuigvILT+NP7uqCU53P4wW2E/frWjf87ACxQPpergH4VsHubdPzJY/MYo0RWAkezv+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CO12TySnH8tMoEOq5ib2g8rlK1oIFwslyhPrwtSmjJw=;
 b=EH6Olw9s+xJknf4nzadwZ4caq7PvAiZBYC5RWSMeKoS8z3KpxJqwwWoECkNL8Z4E1gtSUvOlfkrGyfK+MtLLyw73pD3NDLN4QY5p0EchnrjHR2BFIT+VtrF4/fx4b6CiqfGlo2my65GcHejsYt2/mq0Y/7ssNq2/CNaJsFeQiv1Fj60LIx3+Bn3pJM9ENSju9txY1BL8uKvEnf2/0O0PhL1vesVcFp18hfqbXGd4G+c481GgNLMO41SNugm72ubbqjEYa9gR80k63sQXJAsmMG5DlJku9XPDJngjl1j0fB1WyJ7BamRqsNRLmKaxupohxDg1cLrXhmoi58MPWCx3+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA3PR11MB8003.namprd11.prod.outlook.com (2603:10b6:806:2f7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Thu, 28 Mar
 2024 01:12:50 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7409.028; Thu, 28 Mar 2024
 01:12:50 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Gao, Chao" <chao.gao@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"Chen, Bo2" <chen.bo@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Aktas, Erdem" <erdemaktas@google.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yuan, Hang"
	<hang.yuan@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v19 039/130] KVM: TDX: initialize VM with TDX specific
 parameters
Thread-Topic: [PATCH v19 039/130] KVM: TDX: initialize VM with TDX specific
 parameters
Thread-Index: AQHadnqikJftpAPTRECy6a/NFCG2mQ==
Date: Thu, 28 Mar 2024 01:12:50 +0000
Message-ID: <5470570d804b52dcf24b454d5fdfc2320f735e80.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <5eca97e6a3978cf4dcf1cff21be6ec8b639a66b9.1708933498.git.isaku.yamahata@intel.com>
	 <Zfp+YWzHV0DxVf1+@chao-email>
	 <20240321155513.GL1994522@ls.amr.corp.intel.com>
In-Reply-To: <20240321155513.GL1994522@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA3PR11MB8003:EE_
x-ms-office365-filtering-correlation-id: 3b60c742-84e8-4fe5-a9e6-08dc4ec42fcf
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jZoTgyXqa3Otr92cf+N9inIgconw1tlMUorBGGR3uEClfxneRNCJ7uKy73t+LWsObG2S+ZfO0GO62Nrf+mQcLxqsp0htkZi4UakcefO/DzWKdYAm79zvzB96fAk26et6GsCRxLCzhABo7guwydMPsj8D3BK4sxXaC52QfVmdNPwUMOMeAupBEz7bRgBslPced6kCGg3caFG7cH4KYGWV7dFlVUMCEsnvGawQVvQNBa4mJs8cYIvn9FjmP6MougTGl31zA76oMuOsl+CKevMV7l23ZCFac9E9/QrWoIwfYMOH/ato4iXw1cua4Q58I5bFglCIFt15easIq6BVf5NYp0foGZeS8/wvaZxmzbjaTeZDknS8zwNxdkfnfNYSvE/E7R0gt0pBRkXZZzNa1JDmr5bolohb/FBbDMLJX+cUD3UhsnjNxF4wL//kkdGFjF4nSzm0n61hor2R+LaYVulmHNIA1Wuufgd9UxB1K+kw4QsCoLIO9V8L+UTpdEwtfuE10G+MJmEnwdBE/I5ABaRrG1jvwK69BKV3C80KiayviJ5gnyJkD6FTg9M2FsLePKPMkuQjXfKqHXYmDQidwCxN+HUwUGjq1p00m7MdgSztkf0raMNlt4mHfZtQ+SLWXppd5XG7v4RqhOAsa7VMM2iysSMgAdescTcWUBE3iv94VIy73p8DtmB2ouAGwlDcyFjT+qe8wJ19RSUm251CDi72mQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UlZRN3ZyQ3pOUWN1VmRvZ0l0S1RmTG1idnhrQjNxc3BobUhmeDI5R0NwZW1t?=
 =?utf-8?B?L1BYREJpK0ZLbFpOdzhVMkxLQjd1ZXFndFFVa0pFYkZHNGdQcTNjZWpPcWtL?=
 =?utf-8?B?UE8ybG0rV0NNbjhzS1lnY3hwOTNxY0xGRkV4K2l6dDVwbitSc3NKUVBwV0NX?=
 =?utf-8?B?RzNMQnU4b09iMGpFZWtiOWFNSGE2aWZ4VXo3R3hNbG1tcGR5dlBLUEoyUXFR?=
 =?utf-8?B?Q3RwK1oxYWMrempKQm9tSC9BLzlCUGllOVpiK2kxMm1oN2phakRRS0I3M0pN?=
 =?utf-8?B?MVNwL29wbDQzRzZ1cVFvZE9WUmVUUDV2dHd2WnMwMnZwbmhsbExHM0xNTkRV?=
 =?utf-8?B?bHhFd2RFWUo2OEkxZGliRDZEOG5iNEFhSjdlOHdhMWU3Z01oYTR6SkNNbzl1?=
 =?utf-8?B?VS80c0JGZU1YclJNMy96Vldzd1lEeGRWWnBWaS91dmpEZmNqUit3Qm9DVVFm?=
 =?utf-8?B?T3Z1Q0EwQmYvNWtzSUtVYm1nZ01xMmZTT3Y2dTJhdTRTVXN6UEU1WG12RnFx?=
 =?utf-8?B?VTFnbk1ZR05pUUEyUFVHY09JWnd2MjhGOFpBdnQwRjYwWnB4OTEySWNad1lt?=
 =?utf-8?B?bkpEQ3hwczlOV2lPT0lxTkFJYS9SZE1lT29UbXpYUmYzWWpTSUwzM1V5ZU4z?=
 =?utf-8?B?V0c5WVVDb0lDUTNNR2oyc0ZpMGlKVGRQWExPd0s0dkRKNUIwbnZCVEFacm9E?=
 =?utf-8?B?cGNZbytPZnNsWDBEdDVpRWtadGdWcmdtOVlqZWJtYmVPREZBTUc4aFNoVlYw?=
 =?utf-8?B?RmFEemIzVEZBbFdweE9aQVI1dXF4TnVoc1NqUUg3L0RFbU02T2NjTTUwbVh4?=
 =?utf-8?B?bkNzTlQ3ZXRIZmJSWmlKSGhoSFVYc1M5ZC9lUUx0Q0VxMWFWZk5WbzhsRlBT?=
 =?utf-8?B?MmNwcUFzR2R6T2JQcm5Xb3dCMW8zSjJHWFhBUzFlMWdMMlhteCtQN2p1UmtQ?=
 =?utf-8?B?SiszelUvSXd4dVNzZ0RWQlN0YVNQMERJdlhVSXZIVXg5L1l4K2lvMVlPTVps?=
 =?utf-8?B?ZzI5MUdqd0hQRzlFaVhLSTJxR2ZJNDkzaG8relkvMWtBL3MyTm1ha3BwMDlB?=
 =?utf-8?B?TEtRWWNMem8zUjV6cStVL1JFcHFPeSt2RGdQajg3RE1OakM5WHpCalIwUHVE?=
 =?utf-8?B?UU9DWFNnSnE0NHppZ0hBOEd0bDQzTVV3M0k1QTNpYjhvVTh4RXBNSG9VNnpD?=
 =?utf-8?B?V0tXY01aVXFnMjY0amFreFh6RTZVRm9nMEJqNTNkMjdRdkNaQjl3ZjhJc3Rl?=
 =?utf-8?B?bEF5UTZReGlwYTJIcjU2bElBYW4vY0FqdFdtMzFpaVBlMEFlc2VZajEvSm9i?=
 =?utf-8?B?VG04MnJ1YkxzcDByemNUYndEd3k1U3BFQnE3aTlPRWV4WFd3ajROdm4wN2tW?=
 =?utf-8?B?bGNpZkw4VXRLQ0xiWklrM1ZBZUZaWmR5Wm5WRFc5aktZVlZ5VU1DQmtVYXN2?=
 =?utf-8?B?SWhjdTE2R1RINkl0bm8zMlhURXYrTElROFNqd1J4MnNYSG9rdDJFcmcyZk5Q?=
 =?utf-8?B?TSs2bE1oYnVLNGZIdWlQVHNmclBOZXVTQnFIbmZFSTdsZS9NeUlaSXZJZWFC?=
 =?utf-8?B?NUhJdlNwTU1VT3QxaDRhUUdyalplME1uaFU4cksxd0J1cDlaa3g5WE1WSUxw?=
 =?utf-8?B?aHllS2l4Y2t2ektlT2hmSGY2emRQZ1NKT01yTFo0T2lZWlVpbjY0aVNlZFVK?=
 =?utf-8?B?dmZCMlRGc3owYmUxUXF2cFp4eWdiOG5BVDFuRlFZR08zZmFtNnNFeU0rVnRa?=
 =?utf-8?B?Vmp2M2l1M1djMGFIQ3lDWnJVVkVnaHNXWDNlTlRlbERqclJGaWdkZGRwNmdj?=
 =?utf-8?B?RUtsOERBTUdPOWNmYzNzOGdQdVdvMVIzQTZnZktueDZ3VEdTQzF2RFllOWs1?=
 =?utf-8?B?djdGN3BUczFKRlZDMGxuVHJrall6Z3gwYUVselBEOFhuQ2M3Q0l3dkpZZndR?=
 =?utf-8?B?K0Z1TE80TjZ3MlJoQU02OExwWUtRbHZVN0tXSU5OVFhIQ3FlcDQ3YUdJRWpm?=
 =?utf-8?B?MCtyK09Ib0NWMEJOeXkweGFTdlppUU9BZkhzUUNQK2Yrc2t0V2hiM3FSODVs?=
 =?utf-8?B?ZUJrMVNiaUovZ1dEempqYTVPZy8vRG9GdlpDOUdFOHZ1RXhIOEZVbGpBeEVX?=
 =?utf-8?B?Q013MUlTQ1BsWUJlcWRBdlp6K1VNODQ4U1ErNTIvZWJwZjQzMzVmTlphK0kw?=
 =?utf-8?Q?Bu+UeKhh1eBXIDm3KGFTdBQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F3893D9CB3100F489A03DF3081B08DD9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b60c742-84e8-4fe5-a9e6-08dc4ec42fcf
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2024 01:12:50.2014
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: if3cVK9liVjB1fyo7fa2XUYBX2pVbzfeaRG8f2R1NJt1RHGCafJzf0peuIVDIi0KTmBCoq6S8PfFevfDzdzfmdR6MJAv4z11UFq2E0AxwUc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8003
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTAzLTIxIGF0IDA4OjU1IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToK
PiBPbiBXZWQsIE1hciAyMCwgMjAyNCBhdCAwMjoxMjo0OVBNICswODAwLAo+IENoYW8gR2FvIDxj
aGFvLmdhb0BpbnRlbC5jb20+IHdyb3RlOgo+IAo+ID4gPiArc3RhdGljIHZvaWQgc2V0dXBfdGRw
YXJhbXNfY3B1aWRzKHN0cnVjdCBrdm1fY3B1aWQyICpjcHVpZCwKPiA+ID4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc3Ry
dWN0IHRkX3BhcmFtcyAqdGRfcGFyYW1zKQo+ID4gPiArewo+ID4gPiArwqDCoMKgwqDCoMKgwqBp
bnQgaTsKPiA+ID4gKwo+ID4gPiArwqDCoMKgwqDCoMKgwqAvKgo+ID4gPiArwqDCoMKgwqDCoMKg
wqAgKiB0ZF9wYXJhbXMuY3B1aWRfdmFsdWVzOiBUaGUgbnVtYmVyIGFuZCB0aGUgb3JkZXIgb2Yg
Y3B1aWRfdmFsdWUgbXVzdAo+ID4gPiArwqDCoMKgwqDCoMKgwqAgKiBiZSBzYW1lIHRvIHRoZSBv
bmUgb2Ygc3RydWN0IHRkc3lzaW5mby57bnVtX2NwdWlkX2NvbmZpZywgY3B1aWRfY29uZmlnc30K
PiA+ID4gK8KgwqDCoMKgwqDCoMKgICogSXQncyBhc3N1bWVkIHRoYXQgdGRfcGFyYW1zIHdhcyB6
ZXJvZWQuCj4gPiA+ICvCoMKgwqDCoMKgwqDCoCAqLwo+ID4gPiArwqDCoMKgwqDCoMKgwqBmb3Ig
KGkgPSAwOyBpIDwgdGR4X2luZm8tPm51bV9jcHVpZF9jb25maWc7IGkrKykgewo+ID4gPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgY29uc3Qgc3RydWN0IGt2bV90ZHhfY3B1aWRfY29u
ZmlnICpjID0gJnRkeF9pbmZvLT5jcHVpZF9jb25maWdzW2ldOwo+ID4gPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgLyogS1ZNX1REWF9DUFVJRF9OT19TVUJMRUFGIG1lYW5zIGluZGV4
ID0gMC4gKi8KPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHUzMiBpbmRleCA9
IGMtPnN1Yl9sZWFmID09IEtWTV9URFhfQ1BVSURfTk9fU1VCTEVBRiA/IDAgOiBjLT5zdWJfbGVh
ZjsKPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGNvbnN0IHN0cnVjdCBrdm1f
Y3B1aWRfZW50cnkyICplbnRyeSA9Cj4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKga3ZtX2ZpbmRfY3B1aWRfZW50cnkyKGNwdWlkLT5lbnRyaWVzLCBj
cHVpZC0+bmVudCwKPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYy0+bGVh
ZiwgaW5kZXgpOwo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgc3RydWN0IHRk
eF9jcHVpZF92YWx1ZSAqdmFsdWUgPSAmdGRfcGFyYW1zLT5jcHVpZF92YWx1ZXNbaV07Cj4gPiA+
ICsKPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmICghZW50cnkpCj4gPiA+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgY29udGludWU7
Cj4gPiA+ICsKPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoC8qCj4gPiA+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiB0ZHN5c2luZm8uY3B1aWRfY29uZmlnc1td
LntlYXgsIGVieCwgZWN4LCBlZHh9Cj4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgKiBiaXQgMSBtZWFucyBpdCBjYW4gYmUgY29uZmlndXJlZCB0byB6ZXJvIG9yIG9uZS4KPiA+
ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIGJpdCAwIG1lYW5zIGl0IG11c3Qg
YmUgemVyby4KPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIE1hc2sgb3V0
IG5vbi1jb25maWd1cmFibGUgYml0cy4KPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCAqLwo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgdmFsdWUtPmVheCA9
IGVudHJ5LT5lYXggJiBjLT5lYXg7Cj4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqB2YWx1ZS0+ZWJ4ID0gZW50cnktPmVieCAmIGMtPmVieDsKPiA+ID4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoHZhbHVlLT5lY3ggPSBlbnRyeS0+ZWN4ICYgYy0+ZWN4Owo+ID4gPiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgdmFsdWUtPmVkeCA9IGVudHJ5LT5lZHggJiBj
LT5lZHg7Cj4gPiAKPiA+IEFueSByZWFzb24gdG8gbWFzayBvZmYgbm9uLWNvbmZpZ3VyYWJsZSBi
aXRzIHJhdGhlciB0aGFuIHJldHVybiBhbiBlcnJvcj8gdGhpcwo+ID4gaXMgbWlzbGVhZGluZyB0
byB1c2Vyc3BhY2UgYmVjYXVzZSBndWVzdCBzZWVzIHRoZSB2YWx1ZXMgZW11bGF0ZWQgYnkgVERY
IG1vZHVsZQo+ID4gaW5zdGVhZCBvZiB0aGUgdmFsdWVzIHBhc3NlZCBmcm9tIHVzZXJzcGFjZSAo
aS5lLiwgdGhlIHJlcXVlc3QgZnJvbSB1c2Vyc3BhY2UKPiA+IGlzbid0IGRvbmUgYnV0IHRoZXJl
IGlzIG5vIGluZGljYXRpb24gb2YgdGhhdCB0byB1c2Vyc3BhY2UpLgo+IAo+IE9rLCBJJ2xsIGVs
aW1pbmF0ZSB0aGVtLsKgIElmIHVzZXIgc3BhY2UgcGFzc2VzIHdyb25nIGNwdWlkcywgVERYIG1v
ZHVsZSB3aWxsCj4gcmV0dXJuIGVycm9yLiBJJ2xsIGxlYXZlIHRoZSBlcnJvciBjaGVjayB0byB0
aGUgVERYIG1vZHVsZS4KCkkgd2FzIGp1c3QgbG9va2luZyBhdCB0aGlzLiBBZ3JlZWQuIEl0IGJy
ZWFrcyB0aGUgc2VsZnRlc3RzIHRob3VnaC4K

