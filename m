Return-Path: <kvm+bounces-7402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 23D76841874
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 02:39:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CCF2D28286D
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 01:39:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC72636137;
	Tue, 30 Jan 2024 01:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NbJVHgcS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41BFB1E4A7;
	Tue, 30 Jan 2024 01:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706578738; cv=fail; b=E4Na5mE3/X98QYjjbNWuZ3Zst2tmWYX5fMKtKTNJdq2cMuIz3q37mGr1tCqIwlY3DNFqqa0mKEzuWLx2D3TaWOTs8T1zwOeLHLMCs8MgPgIf0f8Hv8sYFEwvJca7vGKVNSSvBQnh7v0BwqsHSRn6OUb/Jy9MzFoIvBGOpevix3E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706578738; c=relaxed/simple;
	bh=OB2XSDsUaoWvVV0T2Sv9NDaIFBRYTB2U/eQDYmxDxVA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aVmf9MsbnJOekVqaYwn1HlF6HiLstgqgjskpq8Q5Ry8oD1/jc4Ftzk8giATS31EG9E/29Gq66C2XF+2IyInJAQZWB+GGjfyuBJc+6pCCEqUeZXLcnSt/5AOfvCuC26yff9+wE6uoSpA3SsDb8KRBDMXCC9pdeagKiDf76VbEhXE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NbJVHgcS; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706578736; x=1738114736;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OB2XSDsUaoWvVV0T2Sv9NDaIFBRYTB2U/eQDYmxDxVA=;
  b=NbJVHgcSYgnhz6qqU4hgXm2gVVO2El6OW4z/oGKO7ncxFYlbaTjgKneV
   7CsNw8EcHc27lKFAtG07xrqKnACtZ85n5B/fjRwNYAXPWFbRnwLzGZ+Qt
   Ux+/lb/rpVHh6tE4AUDXNQUaCoTIFlRUKd3xVbvQ5sRrB0CakPCG3s1Si
   DH6tpSBLLRzpFchwXytzwdwEJH8Qr8gx0YgROiO7PtxZ9zkwtGULZwPrI
   f6UJ6vz6Qps9b4XvBZazQ/eKOv13eFgIzXNlpAI6Qp4+pu1yIHqtzXdOv
   dkvKaLvQ0Wm8zY2rGxCNdzeYWawRI53yGmI8Y3+mWx9WG+0xd2aYvzocd
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10968"; a="16524395"
X-IronPort-AV: E=Sophos;i="6.05,227,1701158400"; 
   d="scan'208";a="16524395"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2024 17:38:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10968"; a="788017604"
X-IronPort-AV: E=Sophos;i="6.05,227,1701158400"; 
   d="scan'208";a="788017604"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Jan 2024 17:38:54 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 29 Jan 2024 17:38:53 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 29 Jan 2024 17:38:52 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 29 Jan 2024 17:38:52 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 29 Jan 2024 17:38:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YeXZ4Dz13bJ/6H7IT7z5Nvk+x43UIQiYun4Z+QRdYEA6M1H40Nv+Gk+0CCNfcy46+ErUoMUgcpcL7SM15f9E+LpxZ7ayDq4u3qknYni37sXS9mZc3DTbCZ/I+tFhtiMgAz8eXkLqB52ZHW5yz4enX8d8vA0S7UMVymybHSCVcci7o/epGHgcFJZeyWpGllIBZNxMfVkI74TzG2yqoBJ6fil/2wB1bP4UsXYgMMbRKa2U+yDR0MtOsCfGmq5r+jNU2O8zHkw5j+Q+NN5ijiM7+F3xUx8HobV99egLV8Y1H3NUhELQ6WN0E85vgCG9nVht0PbsYA0XRQsTHGDyIsJ26g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OB2XSDsUaoWvVV0T2Sv9NDaIFBRYTB2U/eQDYmxDxVA=;
 b=LPhMAGOl2fet9bzPjb9ezY/JbhnDgVatNdkg56KFg4nyIPBeOGr4Yq0bq0HnjCTxqZsPEgnejeIg6xW0SpEMYtSV3FKYDN/gw/UGGQE+jdaFcHptCJ4R1f98/afi0vyA74wTWfAw4VKqtT3Y3VlJQvffm/QCNZAw1IIpDqQApipEYvD3euRX+pie+g5DKYph2dDXKYZeVlh7K/rFg/Wb2mGF7gGayUvrFeN+giSF+ktKcfnt9xLAFAquJdKQbUN/FV5jvM67d+bWOapvrGWiwHf4cuvmqPAskA0vc52Bd2vVQo6HV6NdMumei516HGeHwd6OEiNaCrVYUqV80hy9LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA1PR11MB7823.namprd11.prod.outlook.com (2603:10b6:208:3f3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.32; Tue, 30 Jan
 2024 01:38:45 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::5d40:83fd:94ac:d409]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::5d40:83fd:94ac:d409%7]) with mapi id 15.20.7228.029; Tue, 30 Jan 2024
 01:38:45 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yang, Weijiang" <weijiang.yang@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "yuan.yao@linux.intel.com"
	<yuan.yao@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "john.allen@amd.com" <john.allen@amd.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "Gao, Chao" <chao.gao@intel.com>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>
Subject: Re: [PATCH v9 06/27] x86/fpu/xstate: Create guest fpstate with guest
 specific config
Thread-Topic: [PATCH v9 06/27] x86/fpu/xstate: Create guest fpstate with guest
 specific config
Thread-Index: AQHaTm8AcGO2MTjOc0GJJZpi7ST9orDxnUAA
Date: Tue, 30 Jan 2024 01:38:45 +0000
Message-ID: <c179a5f4fba9086f9d35e56ec16423558cea5b8b.camel@intel.com>
References: <20240124024200.102792-1-weijiang.yang@intel.com>
	 <20240124024200.102792-7-weijiang.yang@intel.com>
In-Reply-To: <20240124024200.102792-7-weijiang.yang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA1PR11MB7823:EE_
x-ms-office365-filtering-correlation-id: 8945b45d-31f3-48ae-a342-08dc213432f3
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j4C3Fc8NCxjITr4ucvnJ00lU5mWvqpw1T2DLikwKS23RA539YBBnXqu26RsecVw3E7Aw4+YY06cDgbOhqL50sY6IbUk0Wg1eArdc3G7BhxtrXVdbHBes4pRMqiGJUOYg0SfIQSMLyznF4Lsl4LISltVB5zw1/Kr6NwOcvBhzVle3HWC8u3cl8R8Ixk+IyDnWSI2vowyqXIWiVFeoyzJK+tjCz2HqTKieovcGRTsCL9poV6NAIObFT9tCFpyr0YvRUbZc84HON6xcF/7kzrosfvQP+69LB+Tq/nRqMjMqFNOgVwC+xxJzeyqXe3nHf11+YjV6Ag4iFTUlxtzj/TTJ7kzmz++J7pi0zHrEvglkD5CKxNTCm1Ln2LA4VDDK8qi6ZkufUDgSNBt5iU0Hds83RvlqZYN9Xm9QV2dUCUYULzf9Eor2yQw6j+r7IaqT/uRnazSJ0q1GOJFhDoxzg7VCLO6fdLWVEmFMLM8vEjHKdMqgc//KRx3Bs4/J9nCt6G8RubnXlcCAMGcmwOH8s0/nZH/Gd56FgWYtqFIYGe5TNF0SRO6LHXmcdv3KY3W9Yz21oJG5AgjD8ER3vfOe1W9+FG2eNL4bGIYWHpMHrNh+9b62yuOkC7p6l9IcNzRBWcsy7IAMd3hB1hBGGMlLNg8OTw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(39860400002)(366004)(346002)(136003)(230922051799003)(451199024)(1800799012)(186009)(64100799003)(6512007)(6506007)(66946007)(478600001)(122000001)(38100700002)(316002)(8936002)(8676002)(5660300002)(4326008)(41300700001)(2616005)(71200400001)(6486002)(2906002)(64756008)(66476007)(76116006)(54906003)(110136005)(66556008)(66446008)(26005)(921011)(36756003)(86362001)(82960400001)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TkhMeEdWZzRQczhaengrM2tCaHQxaVpXT0VzT21IRmhJcnFhMTBMRWRoZ0dI?=
 =?utf-8?B?SG92amd4YjFxL09tUmtOb2JoTERSWlMySW4zOTZBeUM0UzBVS29VMWYyQ3NV?=
 =?utf-8?B?eVVsWEphdytNTExyd2VVS2l2b3ZxZ3lMOFVQMnRQZ0EvZEtud3NGdmU0REF6?=
 =?utf-8?B?OHprR28zbS82bTJRblZjQngva1FvMHNGZ0lXK3oyb1JRbW9wL2s4SnlLV0FN?=
 =?utf-8?B?N0w5Vll0K2pQMGQ2VHVBdkZqazlDMWpzdkxRKytyalVNTVlKUGN2Z3haS2kw?=
 =?utf-8?B?OWJpRWIxT1d0c2ZyWHJkckpkeTBEeWJYUjFPYXJlNUZsM3dxM21vL0ZhQXpw?=
 =?utf-8?B?anBNWGdhLzBmWmw1MnlwNVo4SEpNYzZUbnlVdGd3UCtJMTN5Y1AvVzdnK29p?=
 =?utf-8?B?WDV3TnZoQWhVT2JUYS9YOGZRdUFUbzVWbktmbGtsZ0d3VHhjQ1RnVGVPeUd1?=
 =?utf-8?B?djhMYjJSSXdlVW1TbzZQRVRTSHI3OVltZ1lNWXZRZmZtdytOeWoyT0FId0to?=
 =?utf-8?B?ckFQaUdCMkEvdTJLRGRaNERTZFRlc2NyaWd5S0ltZHpGY0xDdmZLZjJha25L?=
 =?utf-8?B?enRBUElwU0pqblQ4SldhZ09GSXRhbUtOUWtJNTRaN2ZteW5qVHZvZWh3SGE3?=
 =?utf-8?B?ZVNGcFllTVBaWVNKN1N5eGVkYS9rcjlzclhpM210Yms2TGo3RW5pVTRlanNR?=
 =?utf-8?B?d2hhWElRbjhJeUp2S1F6dDlUQjhDZWgwZ0VnRlIvU1hDZG1RbUEyZEFDaUlq?=
 =?utf-8?B?cjA5cHNoWkZyQWNoalVmNVQ5Q1JDV1dGZjhwNURTbHUzbDFFL2dmUEJyYlVi?=
 =?utf-8?B?R2dCbUZCVHY0dFpwb3JmR0EwYkZpUmVmcjlyMUQ0NXVjS3IyTGJxeHc2Rkhh?=
 =?utf-8?B?MUYvbDlHU0wzbFowYzBIdnVJcEkyY0FON0xPdlJSRHpaSVQraEc0aTV1Z0hR?=
 =?utf-8?B?dC9UK3F4R2lVdS9ZNE5TWDRhd0gxNnBPdkZuSllEK0QxS1FOVklzRDFlb09V?=
 =?utf-8?B?TUg5ZmZvdlBLeVV0Y2FqYjRwc0N3UnJoa080U1YvTzJKa0VYb3o5dEpyMzR3?=
 =?utf-8?B?aWlEUlRqa0U3enlHWlpWcDJTOHNMZHVBc0VtaXRPdWRSOEZNOGVybTFxV09E?=
 =?utf-8?B?cExxWEN1ZkZFVWRJR0lleEFzTGtYaFVLUlRNT2IzU01NdnYwWUxPZDdMeUNH?=
 =?utf-8?B?TlVQNEpOQkN6OFFiMUljRzdkTWd6aXZ0S0x0ZUJ4WGtxUDl6L01hMGJUNUlp?=
 =?utf-8?B?M2pNaEdYZFhwMGZVTlByT0tBRm1mZU9iZGwwN0tXT1dSdUQ0OWh4STNJM1l0?=
 =?utf-8?B?a3hxVm1YTml0Mjd4Wks2cVBvR2ozY3NneGgyWVVZTHRQdkJEMWZpMEkzVDR2?=
 =?utf-8?B?akdBOVdzbDRod0JoUnU2dkc5Rkx5ajJYRlNjbkhPTURCeGdYK3VNOG90aHF3?=
 =?utf-8?B?Uy9TeGs5SDZsR1MrMjJ1dGQrRlNEcXdPaEtJSDUwNTQ3S0pFcStEZWdSNU44?=
 =?utf-8?B?eU0zdDJwRHhNeTUwb2pKdGNIampUYmFpaWxTWEUrVWFkMkQrcTBxWWZUZTJI?=
 =?utf-8?B?YmVvYXF2V0pna1lRRWlPZlYreXhuVGhkTllYZ01tNVVrditwVENwNzJjWWhs?=
 =?utf-8?B?Y0NscHhncVA1ZU9xM0h2VzNkd3F2eUpTOGlFenJCU1llTEVZMWxUUUIxaUEy?=
 =?utf-8?B?UDdLMjJiQ2lkYzNPNi9TZXRLVVRDc29WUnlrelE1YW5KeWVlYXFxUFlQOVBV?=
 =?utf-8?B?enlqWTNzM1d5STV3azZlVDFwbTJBMUNVKzg1SUpINUhKejlMdVJlRVZpWlJv?=
 =?utf-8?B?dE5MOW05WE0ycGlHSzcyNnhuZzAvMjVkMld6N3BpbktBUlBsbkNVWEVvYmdV?=
 =?utf-8?B?L0d3T0dRZFRPWVZYa29IMGJsd0tWYTdzL2xacWxnVFVmYlN4MVkrUit0SC95?=
 =?utf-8?B?MlBCMkxWNWpDRkZwSVh1Vjh3cWdUajJEWnZzN2lSeXJzUWlLTlhjNnN3SVRM?=
 =?utf-8?B?a1MrSWxLNjIvak1FWkwxbzJBWENKK2l6L1JrMXR2Wms1Z1JOT0VDTjBjV3pE?=
 =?utf-8?B?WlRtQXloRHN3YVZQL1R5bE9Nc3hKa3BhSE83ZXIrTlFpSndEMW1jME5CcXQ4?=
 =?utf-8?B?YWl3d2ZGMHVGSmI0eXFrKy9CTEJGem9UVkdoRTJOTFhSWkVhdWpBZE5TWllr?=
 =?utf-8?B?Vmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A8972A744A1F7E40AC81B22C236412EB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8945b45d-31f3-48ae-a342-08dc213432f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2024 01:38:45.6590
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VUrjoN6pKEIUfXNX5kOZED+lhYglgIlBRJgBbqDrJ4L/yXdkwJc6vIib1WVg3NGzlTSuRVnUg46yM2oC53SImJ9fT4aMajPkRRfgMogrQvs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7823
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTAxLTIzIGF0IDE4OjQxIC0wODAwLCBZYW5nIFdlaWppYW5nIHdyb3RlOgo+
IC1ib29sIGZwdV9hbGxvY19ndWVzdF9mcHN0YXRlKHN0cnVjdCBmcHVfZ3Vlc3QgKmdmcHUpCj4g
K3N0YXRpYyBzdHJ1Y3QgZnBzdGF0ZSAqX19mcHVfYWxsb2NfaW5pdF9ndWVzdF9mcHN0YXRlKHN0
cnVjdAo+IGZwdV9ndWVzdCAqZ2ZwdSkKPiDCoHsKPiDCoMKgwqDCoMKgwqDCoMKgc3RydWN0IGZw
c3RhdGUgKmZwc3RhdGU7Cj4gwqDCoMKgwqDCoMKgwqDCoHVuc2lnbmVkIGludCBzaXplOwo+IMKg
Cj4gLcKgwqDCoMKgwqDCoMKgc2l6ZSA9IGZwdV91c2VyX2NmZy5kZWZhdWx0X3NpemUgKyBBTElH
TihvZmZzZXRvZihzdHJ1Y3QKPiBmcHN0YXRlLCByZWdzKSwgNjQpOwo+ICvCoMKgwqDCoMKgwqDC
oC8qCj4gK8KgwqDCoMKgwqDCoMKgICogZnB1X2d1ZXN0X2NmZy5kZWZhdWx0X3NpemUgaXMgaW5p
dGlhbGl6ZWQgdG8gaG9sZCBhbGwKPiBlbmFibGVkCj4gK8KgwqDCoMKgwqDCoMKgICogeGZlYXR1
cmVzIGV4Y2VwdCB0aGUgdXNlciBkeW5hbWljIHhmZWF0dXJlcy4gSWYgdGhlIHVzZXIKPiBkeW5h
bWljCj4gK8KgwqDCoMKgwqDCoMKgICogeGZlYXR1cmVzIGFyZSBlbmFibGVkLCB0aGUgZ3Vlc3Qg
ZnBzdGF0ZSB3aWxsIGJlIHJlLQo+IGFsbG9jYXRlZCB0bwo+ICvCoMKgwqDCoMKgwqDCoCAqIGhv
bGQgYWxsIGd1ZXN0IGVuYWJsZWQgeGZlYXR1cmVzLCBzbyBvbWl0IHVzZXIgZHluYW1pYwo+IHhm
ZWF0dXJlcwo+ICvCoMKgwqDCoMKgwqDCoCAqIGhlcmUuCj4gK8KgwqDCoMKgwqDCoMKgICovCj4g
K8KgwqDCoMKgwqDCoMKgc2l6ZSA9IGZwdV9ndWVzdF9jZmcuZGVmYXVsdF9zaXplICsKPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgQUxJR04ob2Zmc2V0b2Yoc3RydWN0IGZwc3RhdGUsIHJl
Z3MpLCA2NCk7CgpNaW5vciwgSSdtIG5vdCBzdXJlIHRoZSBleHRyYSBjaGFyIHdhcnJhbnRzIGNo
YW5naW5nIGl0IHRvIGEgd3JhcHBlZApsaW5lLCBidXQgdGhhdCdzIGp1c3QgbXkgcGVyc29uYWwg
b3Bpbmlvbi4KCj4gKwo+IMKgwqDCoMKgwqDCoMKgwqBmcHN0YXRlID0gdnphbGxvYyhzaXplKTsK
PiDCoMKgwqDCoMKgwqDCoMKgaWYgKCFmcHN0YXRlKQo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqByZXR1cm4gZmFsc2U7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJl
dHVybiBOVUxMOwo+ICvCoMKgwqDCoMKgwqDCoC8qCj4gK8KgwqDCoMKgwqDCoMKgICogSW5pdGlh
bGl6ZSBzaXplcyBhbmQgZmVhdHVyZSBtYXNrcywgdXNlIGZwdV91c2VyX2NmZy4qCj4gK8KgwqDC
oMKgwqDCoMKgICogZm9yIHVzZXJfKiBzZXR0aW5ncyBmb3IgY29tcGF0aWJpbGl0eSBvZiBleGl0
aW5nIHVBUElzLgo+ICvCoMKgwqDCoMKgwqDCoCAqLwo+ICvCoMKgwqDCoMKgwqDCoGZwc3RhdGUt
PnNpemXCoMKgwqDCoMKgwqDCoMKgwqDCoMKgPSBmcHVfZ3Vlc3RfY2ZnLmRlZmF1bHRfc2l6ZTsK
PiArwqDCoMKgwqDCoMKgwqBmcHN0YXRlLT54ZmVhdHVyZXPCoMKgwqDCoMKgwqA9IGZwdV9ndWVz
dF9jZmcuZGVmYXVsdF9mZWF0dXJlczsKPiArwqDCoMKgwqDCoMKgwqBmcHN0YXRlLT51c2VyX3Np
emXCoMKgwqDCoMKgwqA9IGZwdV91c2VyX2NmZy5kZWZhdWx0X3NpemU7Cj4gK8KgwqDCoMKgwqDC
oMKgZnBzdGF0ZS0+dXNlcl94ZmVhdHVyZXPCoD0gZnB1X3VzZXJfY2ZnLmRlZmF1bHRfZmVhdHVy
ZXM7Cj4gK8KgwqDCoMKgwqDCoMKgZnBzdGF0ZS0+eGZkwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
PSAwOwo+IMKgCj4gLcKgwqDCoMKgwqDCoMKgLyogTGVhdmUgeGZkIHRvIDAgKHRoZSByZXNldCB2
YWx1ZSBkZWZpbmVkIGJ5IHNwZWMpICovCj4gLcKgwqDCoMKgwqDCoMKgX19mcHN0YXRlX3Jlc2V0
KGZwc3RhdGUsIDApOwo+IMKgwqDCoMKgwqDCoMKgwqBmcHN0YXRlX2luaXRfdXNlcihmcHN0YXRl
KTsKPiDCoMKgwqDCoMKgwqDCoMKgZnBzdGF0ZS0+aXNfdmFsbG9jwqDCoMKgwqDCoMKgPSB0cnVl
Owo+IMKgwqDCoMKgwqDCoMKgwqBmcHN0YXRlLT5pc19ndWVzdMKgwqDCoMKgwqDCoMKgPSB0cnVl
Owo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoGdmcHUtPmZwc3RhdGXCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgPSBmcHN0YXRlOwo+IC3CoMKgwqDCoMKgwqDCoGdmcHUtPnhmZWF0dXJlc8KgwqDCoMKgwqDC
oMKgwqDCoD0gZnB1X3VzZXJfY2ZnLmRlZmF1bHRfZmVhdHVyZXM7Cj4gLcKgwqDCoMKgwqDCoMKg
Z2ZwdS0+cGVybcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqA9IGZwdV91c2VyX2NmZy5kZWZh
dWx0X2ZlYXR1cmVzOwo+ICvCoMKgwqDCoMKgwqDCoGdmcHUtPnhmZWF0dXJlc8KgwqDCoMKgwqDC
oMKgwqDCoD0gZnB1X2d1ZXN0X2NmZy5kZWZhdWx0X2ZlYXR1cmVzOwo+ICvCoMKgwqDCoMKgwqDC
oGdmcHUtPnBlcm3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgPSBmcHVfZ3Vlc3RfY2ZnLmRl
ZmF1bHRfZmVhdHVyZXM7Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoHJldHVybiBmcHN0YXRlOwo+ICt9
Cj4gKwo+ICtib29sIGZwdV9hbGxvY19ndWVzdF9mcHN0YXRlKHN0cnVjdCBmcHVfZ3Vlc3QgKmdm
cHUpCj4gK3sKPiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgZnBzdGF0ZSAqZnBzdGF0ZTsKPiArCj4g
K8KgwqDCoMKgwqDCoMKgZnBzdGF0ZSA9IF9fZnB1X2FsbG9jX2luaXRfZ3Vlc3RfZnBzdGF0ZShn
ZnB1KTsKClRoZSBhYm92ZSB0d28gc3RhdGVtZW50cyBjb3VsZCBiZSBqdXN0IG9uZSBsaW5lIGFu
ZCBzdGlsbCBldmVuIGZpdAp1bmRlciA4MCBjaGFycy4KCkFsbCB0aGUgc2FtZSwKClJldmlld2Vk
LWJ5OiBSaWNrIEVkZ2Vjb21iZSA8cmljay5wLmVkZ2Vjb21iZUBpbnRlbC5jb20+Cgo+ICsKPiAr
wqDCoMKgwqDCoMKgwqBpZiAoIWZwc3RhdGUpCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoHJldHVybiBmYWxzZTsKPiDCoAoK

