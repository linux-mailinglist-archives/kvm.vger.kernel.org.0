Return-Path: <kvm+bounces-7401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C476C841846
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 02:30:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B75531C218CB
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 01:30:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84F103611F;
	Tue, 30 Jan 2024 01:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zh9krua7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8652CCD5;
	Tue, 30 Jan 2024 01:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706578201; cv=fail; b=VJ6gbb6poKiezlFJS1c50IgpFBJHRnjDRspO9MfXDxuDPxRLbodEHCGFO8iv5NdKHJPzpjCG1QLjho9olCKoaUe6u7MDkq1m5qQnMVL85juw6gpnjlTIg8MGV1sKGTJQNjxAJVfQAb473RCI9Eq2iIym4OirwgMB6tJd4bIkyg0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706578201; c=relaxed/simple;
	bh=YJe5za861j2zxnUEi1aZnoNxx7dq8bXqw2EdQFi6xfA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iOjmSsPXqGM+XPKg9DXyvTutUZh80/9NWseAW+udC4coV6wyVEnrVqHI3bRyIXgjpQQg1bX/stCNDaNLeqx9SCB2WQQ/8jB8l0cNLMPcSOsme/aV4A0og8goS/7SKQwh9dHnUXE9DzYF8yfJzCiba2j0pTIiay3qlnuiFPAMUVY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Zh9krua7; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706578200; x=1738114200;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=YJe5za861j2zxnUEi1aZnoNxx7dq8bXqw2EdQFi6xfA=;
  b=Zh9krua7zw5MOs9tlVlnhqotkRjOWOCIDPEkNPoKeLCUD3FSwr40pVIi
   owzAucRycsEkf5oNV5BVgNB/ELpiY6YB2iY2n8pcnf1iXW3N+fzMQzWSi
   hH/6HCmJcr+EjyLhymmNmmrDZScX8YT5Pr9VbKHb+65ICwk5uKgSs5j/y
   nQVu+uljOu9HWLnqe3nFDdCM3t4TUKiSK1tsXR5gtUy0VOAA0MTBtGzvR
   yVQQhiRqShqB4Sa9qAa3o7VOsiPY/ffE+ZhcBXPu+QHPnh758Ndj9o6v2
   vXL+gRhsBWsijUbasoVh123TJZ9qsNhiEIPSuqUFyIGIDoK5Y6RLHKCIp
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10968"; a="16521753"
X-IronPort-AV: E=Sophos;i="6.05,227,1701158400"; 
   d="scan'208";a="16521753"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2024 17:29:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10968"; a="1119085939"
X-IronPort-AV: E=Sophos;i="6.05,227,1701158400"; 
   d="scan'208";a="1119085939"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Jan 2024 17:29:58 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 29 Jan 2024 17:29:57 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 29 Jan 2024 17:29:57 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 29 Jan 2024 17:29:57 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 29 Jan 2024 17:29:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O782RzTtEsKJgoE1oWzSbvZ8SzOvBVldrKD2elsN779qrpXTXZtxS6ZrUxo8RDvZJhfrWkvcrXXWyR5MW+If4TBBTMqKMk0BFHXqtokb08exgnv1kF8CFLTMmiB/fVlUUigl5TxzEW7DLQkri2yVUUb1KZOuXL/aZ2b+/TAv1UltdN2hOP5o2afIRqr9CnwH5RELLpui/4iHFzv4yo0zUi3kufqgvu9aZuj1eQKjBfhWJTVPeqbp1A9Fdnbd1+/syXDatWibXX+mGILjF39Uxt86jEJdc4/bIsHO0t7G5pNuagqgtqig95/z21aNIAdtNYcrBSTPQFko0QZ3RaU3cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YJe5za861j2zxnUEi1aZnoNxx7dq8bXqw2EdQFi6xfA=;
 b=B1U0F00OpCAQGdlafBSnvH71dO4L1w/OXzSOf/GKvCMCv0ZiEF5pNF92svXbyoL8kaIG/hRHe0SOIxkzwhmgVeVlcxtl3vqXVzmZri4GhjfKTAsvvBUAanA1VSCgXRwdTggqWo6wKh/NO7272E3FqYSFXjl1eAYnwStrZh49moknD7y1sLBChYY/oi/kY2vwAwLGn9MJdTJqhwI4IyYmtGEcHEMc87wqGTTuxSYGoUxJzdWzqBWuYGT7yBTRhxO7YcdVrPq3EI4cg95R1UmeD99TIkmlY5Tc2gP6lYMvrfebORQ0isIBZlt4h9IuXoyW7lAM8K+ZL3SwwfAX7zmDSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH3PR11MB7894.namprd11.prod.outlook.com (2603:10b6:610:12c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34; Tue, 30 Jan
 2024 01:29:55 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::5d40:83fd:94ac:d409]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::5d40:83fd:94ac:d409%7]) with mapi id 15.20.7228.029; Tue, 30 Jan 2024
 01:29:55 +0000
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
Subject: Re: [PATCH v9 05/27] x86/fpu/xstate: Introduce fpu_guest_cfg for
 guest FPU configuration
Thread-Topic: [PATCH v9 05/27] x86/fpu/xstate: Introduce fpu_guest_cfg for
 guest FPU configuration
Thread-Index: AQHaTm7/DsG1r3R2ZkSYi/e3Hu5x67DxmskA
Date: Tue, 30 Jan 2024 01:29:55 +0000
Message-ID: <0221fdbd07cd35f954faa466a851cb063db57d03.camel@intel.com>
References: <20240124024200.102792-1-weijiang.yang@intel.com>
	 <20240124024200.102792-6-weijiang.yang@intel.com>
In-Reply-To: <20240124024200.102792-6-weijiang.yang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH3PR11MB7894:EE_
x-ms-office365-filtering-correlation-id: 283185a0-c146-4018-7638-08dc2132f708
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FypD06zaqU9/k9VJQUM21J/Xq2JT9ELzv0MxQIAaqZWdxn58gwdEhLv9l7dNs5isZybOERAnWBFYZC8CTZFzrRtqM5dLxvmfoi3TGcvsEPD185UoAfYhQY5a+qa5kCtyccpGwOAa3LgLd2P/QdDST2XCcDTQOcSjVtrNw+A7+rC7UHLpjjLlOyKsTECGo6rzKbljirQ/LHLH0LkZ4PWYZh/Iyp/MSL/CKJQBlx9k4gS1ZRdKL+YIgK03iYIseLDM39hDccucjxrbWzZMj+TKCt8AHVJdSVQQK2AFLzI5FvtqfVOqPbbZ6q3uuV1K/f5agx2Or1C+Frd4S8spUVAo+15X0++6c9gakBlPpSzM7HWXnOBPd6ejJnhQ0xi86Uj3f0t1ZWoJDrnNHZLE8Y+0INGDKjQ2PFEq4PEqbC1kLh5VAI4R+91uA1iTXpyZOFtinmKUs+lLPcbcLOAf3R7BRErR6LXAqUXix5YmiRYCNXRrkksjhYBHPF+QaebTDrLpbRzV4RHB1vs6JmkPlzGCamDfZqk4HTl8CLlLcjjV4V78CXdTc0tTs8zmcTrgBnlzfdPBHfpH8v6EyRw2r4nFv/BPsw+CKU+i9Vy1v9nwmSTHa7vDV50R1Kj6OQRUXU2bOToYJSOoD4X0BOv+tpoahw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(136003)(39860400002)(396003)(376002)(230922051799003)(451199024)(1800799012)(64100799003)(186009)(6506007)(26005)(2616005)(6512007)(71200400001)(5660300002)(4744005)(83380400001)(122000001)(2906002)(41300700001)(54906003)(66946007)(4326008)(478600001)(64756008)(316002)(66446008)(110136005)(921011)(8676002)(66476007)(8936002)(66556008)(6486002)(76116006)(82960400001)(86362001)(38100700002)(36756003)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NmxrR2VUVXhGeHNEN3Z4bkRRNzg4dEl3RFZTSWtOVlYxNmRFbVZ2SHFnQ013?=
 =?utf-8?B?UkdudTEyV0R4OXZweWlOclRkOCtTd0ZITW51WEJBWUZZNGJ6KzQ2K05mOWw2?=
 =?utf-8?B?UEk5QllYQU9kZ1RHZWRQYTRxRGUrU1h5c1JFZHJISElGSjJuSjFxQ0FhSytF?=
 =?utf-8?B?MThPYzdpb3RkdHNINzg3QkdiRFBwOUlDaFp3ZG1IeTFmOEVxOWZnQ3ZrT3Zz?=
 =?utf-8?B?NlZTZ2Y0NUJnWHpBdWxEUXA2WlZES3RpWTZlR2xNZ25lcjlmaE5IK2huaTM1?=
 =?utf-8?B?NmRuTHh5ZmYzdE5iMlFMYWUvdUFncUUzNHMxYUdvUnppR2VxM3lHN09XZThj?=
 =?utf-8?B?RGo4UGU5Snh5MEV3YmhZdzZWL2d1RkhqZGxKczhxUmI4dmFJZHpsV2luUWhU?=
 =?utf-8?B?aHNnMWJSeTRDM2xqakxlbmk0aXovQnFTTmlxS1BUTFJ3Rk9ua1M5WXdCVG5i?=
 =?utf-8?B?WGxaeVlWMkNtRy9kRXZ6K2tSYUV3SmtiVXc4dVNBMkZ2UE5XUitxakNiUXQz?=
 =?utf-8?B?YUNwbFNhc0hkMGxSczhXRVZhQ25WdDVDdmxPUGV6UUdyQi9aQW04MTZieHAv?=
 =?utf-8?B?eHRXSnlDTlIrM0pkM3o4d3V3UXdTYWQ1RkgvakZ6MlZyVnlLdTdNSlBqeHZt?=
 =?utf-8?B?RE9kdVk2OWd5d3RseFJMUlYxRGV1VUduTWVoYjNDeEI3c1NXenZUbnZ3aUM2?=
 =?utf-8?B?aXpIeHYzb0Q4TGhDSEdWeVVuY1huczQrb0M2cmxBRyt2VEVJM1kxV2drRWgz?=
 =?utf-8?B?Y3FBQTgxaW1vUFV4ZGwxdExuM0lMTGN5MnQ3UmQwbnZMeTJXYzk0MG1PUnNx?=
 =?utf-8?B?c25abmJsRWZYY2hyeHd0UG16dndGaEtzakJuNVhsTHMvMDc5WFNPRTkxWmd3?=
 =?utf-8?B?VE5uUVBnbUU5cEppc05LZy9KNS9OZmdyUVVHSHBsVDB2KzRtd3NzU3R3UHVM?=
 =?utf-8?B?NWdzU2dSeDlQVm9pKy9FVUpYdG1vV01MWFFLYkw4a3dIZ3QrVU9jcDVjN2Z0?=
 =?utf-8?B?SWFGNThhb3pUNnJ3TFdVdTNkbXRRbi9MbE9WRVBLZFhjcjNJTHYzcC9JOTVl?=
 =?utf-8?B?WGM0cVhKVm1IcTJMMTdHdzduTWJwRWxnNDlEK2VodjdoREdTdUVRUUttbDlz?=
 =?utf-8?B?TnlLYkVFV3JaMmFDd29qak40WkcreEc2ZzdDUnIyY0tudmJLUnZiQlMzcjVZ?=
 =?utf-8?B?enJ2NkJzdUg3NXNaNkVvYlNVcmdjU0NXcm9acTdZRXFmSzByRjBsangvQVhB?=
 =?utf-8?B?N3JreGdFWW5VTDlDazA4TGcyTmpXeHQ1K0twZlB2QU1NMGYxNW0wUDhYWmR1?=
 =?utf-8?B?QWZzb0k0UVVQYm9xVWsyKy94SUNZVlFxQS9yWWE2azVJNFgvVkRhaVdmZVNl?=
 =?utf-8?B?YnRWakROWHFCc0o2dWx3RGRHNWtuZG52bUdURG14bDBzWE5hZUJLTm83d0Vm?=
 =?utf-8?B?cTVVa3ZDREZIY0o5R1RyT0lpZWMvWFBLTW9SOC9yQzRQSlhXemY1cVBIM2pB?=
 =?utf-8?B?MXdFS1gyN0RVSklwYlVTYlBFcGVuZG5wMmsxam41Yk9hcWhRS1BoaUFDZGJJ?=
 =?utf-8?B?OGx3ck8zNTlUdVU2WU53N1VHTVdKd1VpR0ZaMEtyTVI1U2NVb0NYUmNnUlF4?=
 =?utf-8?B?aHVpMTFpVWpHV0xra0dNQ0c4N1F6VVlFRERVb3pXbWUrZFJsNVJQNDV6Zy83?=
 =?utf-8?B?SWZEbi9pVFhaVjFuLzNSY3Y0aWcrbzlzRU1MeXJUbmcrdTBTNU9OL2I4UG8w?=
 =?utf-8?B?ZW9wejVGOTNMOFVkS21KVjNlRXhHbXZaM0xpT3c0VUpOejlRVEQ2ZVdQUzFj?=
 =?utf-8?B?TnNOcnVOQVF2UGZQZ2U4WitTVVBXc1VhRnVmRlJRSTVuYlhJbWdKVm9EbHNy?=
 =?utf-8?B?UGloaVluZTVHeEk0MmhFVVdBMnNIdVl5ZldJam5mUkhKbVJhWTZvRVpsaGNG?=
 =?utf-8?B?RDc0c0ZCTms3VmNsOW9Bcm1WSGVpTjlSU1pWSmlJRlArL0I4ZjBlOGlTK3Ju?=
 =?utf-8?B?OUtFS3d2dU1tT2VSL3hCTnFWeThqM3JRVW5mUVBvWEM0MG1hVWN6OHV3OVlH?=
 =?utf-8?B?UlNncml2Mi9sSmVJQnh4VGNqbkVKTndkOWxkQW1WTWtWaTBSUEYwUUM5aVhp?=
 =?utf-8?B?eE00MCt0amJKdFBkOFdhbFRrY2habERTV2g1a2VMSHdGcDZqOS9WbkVVZktw?=
 =?utf-8?B?WWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A6D4ABDA78995240AF79A3F2E41E9492@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 283185a0-c146-4018-7638-08dc2132f708
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2024 01:29:55.5970
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2t7kAmnebJE2Zc2WZkx28l7lhX6wQMtosIxR0XlaPpoPE5gs9DqsXo0MukdYvjNUdCPfFnMa/JFOYG7nhvbSCaKUEPixw+ga5iAWYQMffRk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7894
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTAxLTIzIGF0IDE4OjQxIC0wODAwLCBZYW5nIFdlaWppYW5nIHdyb3RlOg0K
PiBEZWZpbmUgbmV3IGZwdV9ndWVzdF9jZmcgdG8gaG9sZCBhbGwgZ3Vlc3QgRlBVIHNldHRpbmdz
IHNvIHRoYXQgaXQNCj4gY2FuDQo+IGRpZmZlciBmcm9tIGdlbmVyaWMga2VybmVsIEZQVSBzZXR0
aW5ncywgZS5nLiwgZW5hYmxpbmcgQ0VUDQo+IHN1cGVydmlzb3INCj4geHN0YXRlIGJ5IGRlZmF1
bHQgZm9yIGd1ZXN0IGZwc3RhdGUgd2hpbGUgaXQncyByZW1haW5lZCBkaXNhYmxlZCBpbg0KPiBr
ZXJuZWwgRlBVIGNvbmZpZy4NCj4gDQo+IFRoZSBrZXJuZWwgZHluYW1pYyB4ZmVhdHVyZXMgYXJl
IHNwZWNpZmljYWxseSB1c2VkIGJ5IGd1ZXN0IGZwc3RhdGUNCj4gbm93LA0KPiBhZGQgdGhlIG1h
c2sgZm9yIGd1ZXN0IGZwc3RhdGUgc28gdGhhdCBndWVzdF9wZXJtLl9fc3RhdGVfcGVybWl0ID09
DQoNCkkgdGhpbmsgeW91IG1lYW4gJ2d1ZXN0X3Blcm0uX19zdGF0ZV9wZXJtJy4NCg0KT3RoZXJ3
aXNlOg0KUmV2aWV3ZWQtYnk6IFJpY2sgRWRnZWNvbWJlIDxyaWNrLnAuZWRnZWNvbWJlQGludGVs
LmNvbT4NCg0KDQo=

