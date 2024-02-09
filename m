Return-Path: <kvm+bounces-8452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FB3B84FAD3
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 18:15:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 441901C241DB
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 17:15:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 097C37BB0D;
	Fri,  9 Feb 2024 17:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="EKhKBbA6"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A4174E04;
	Fri,  9 Feb 2024 17:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.180.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707498898; cv=fail; b=cn2abIY3e0PoXyHgbD854U1sJOZ3DzY11IwtFnTm9Ti6kXNrichsgKqnuyFAPMPi1g/bhs2tZ9hDhWLnv6Dpj/pF2gW7NQO6ac3sJrEcacJYT/8Fj4e9GH42z/uOZ/TP0h7nef/2qtTjQFzR33Pwtc2lOVk6kIDsSnWoif0vr3g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707498898; c=relaxed/simple;
	bh=JgMdAdB7os66ZCA1gP6nA6VmS7tEUv1lbUeG8fWiJNg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Jyo1QJQgHJRrhoMB5nx6zUN3VY9f7tmIYjVqL8mRZVK53trHWRzZ9hxzN2PLdPq4CHskgnC7UGEHD2XgGN2640LP6xqomAKnOvnDoo2B8JJSS5GtHBtYKuNvqiIAsS+mRLG5LthrkCU6lbvWKH4dJVFpl7Vn4lKZ4YCxdK8czUs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=EKhKBbA6; arc=fail smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 419EoRZq019363;
	Fri, 9 Feb 2024 17:14:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	qcppdkim1; bh=JgMdAdB7os66ZCA1gP6nA6VmS7tEUv1lbUeG8fWiJNg=; b=EK
	hKBbA6R84FSWe1GJRv6UlGqeXnb++GLCRQseQ+bYPcjhH09hJ++ypgnj42JYatTR
	6VWjyhw51UWA+I4+wmo9A1wLDOcGO7CUZ6JtBo3KJxrua5hugcuOouWcfXICqBO+
	3vEw51I8gOgEn1lk3PeBbUIfgDVz3Muu8u4LCm8RUAA3OmBEz1rKlrLHBWPvQc1e
	rFZfWchnWy46+CgxE16d5pzQMs433p4P2Av9zY2feIBIPa5fVrHTCTwkuwT0CaBK
	XgoN3ejW6TAUCaiShMK2XQUP+uu6kMDJLxJHLWCzvcAAzwLjMrZ9FbWxyo8yQZtF
	90XvAXUKSLDGXZUKeaqg==
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3w4m3an2rr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 09 Feb 2024 17:14:44 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GqNuPCuM5r59WE9HFvvBiRS1XDF/cfE4wFB5VeVwczfTSfxxynkXLXebVCiSiZJYpei4WnbMcHpKZHSw6wOxMPzs2vs2Edu2vqiPUoRBYkSQUtnU+VlpZUmp3dv3GEYoA/c20Mm6zNB0Un+19Y5bPN5OrFC8X4hCi1TgLpnM2KrNB8EfGxNufCRyd5fcTPCs9a3YBrxhiZoUx8bmhBer/u4J/KYcFAtoSjF4DuMdKUv1HGtwptxb6Qy93/ByzAEvJzVNg3SivRiwMC0NJy4DAsXl6e/CTGcYUi5GjawlTFhBahYMVBOpHWijekVomxSUcz8c/rhnwdtsoEA/uFNtSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JgMdAdB7os66ZCA1gP6nA6VmS7tEUv1lbUeG8fWiJNg=;
 b=kA2/l9fvLOwzDypmVDLP7cKeENOiKH6LTpCOpQ5DvZZVi78FPQJ9+ZCrlH+LcUK7/maIxMqg+g5LTUhrlYXt0HB0q31osX0SZVT2HN2lmUtyKHxSQrTTWDDryOwQEegWz//0DsHU5bGarGGXJ5iuAVYswGhsQYZaFihW49fZbSu4uVK36BBsXRYCrJAI7RGZ/S5Y+uywSGMnsjSJvJFhk6yFbZMnf1n+96f4cRTCBBiSIWFW9JmXV8cDZBex4RKg6tsfLBeAE/vqq6QGV+mxY8VPWrmwz4ofP+7KmVmAuj4FNQMC14NASPj3UZNYIUAo1AFxE8uqI4u4QOEq5KONUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=quicinc.com; dmarc=pass action=none header.from=quicinc.com;
 dkim=pass header.d=quicinc.com; arc=none
Received: from DM6PR02MB4058.namprd02.prod.outlook.com (2603:10b6:5:9f::19) by
 LV3PR02MB10243.namprd02.prod.outlook.com (2603:10b6:408:20e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.24; Fri, 9 Feb
 2024 17:14:40 +0000
Received: from DM6PR02MB4058.namprd02.prod.outlook.com
 ([fe80::9a92:5351:474:b845]) by DM6PR02MB4058.namprd02.prod.outlook.com
 ([fe80::9a92:5351:474:b845%3]) with mapi id 15.20.7249.039; Fri, 9 Feb 2024
 17:14:40 +0000
From: "Andrew Pinski (QUIC)" <quic_apinski@quicinc.com>
To: Nick Desaulniers <ndesaulniers@google.com>,
        Sean Christopherson
	<seanjc@google.com>,
        "Andrew Pinski (QUIC)" <quic_apinski@quicinc.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Masahiro
 Yamada <masahiroy@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH] Kconfig: Explicitly disable asm goto w/ outputs on gcc-11
 (and earlier)
Thread-Topic: [PATCH] Kconfig: Explicitly disable asm goto w/ outputs on
 gcc-11 (and earlier)
Thread-Index: AQHaW3n0uKIKGks820iKFMFkm+8R77ECP/kw
Date: Fri, 9 Feb 2024 17:14:40 +0000
Message-ID: 
 <DM6PR02MB40587AD6ABBF1814E9CCFA7CB84B2@DM6PR02MB4058.namprd02.prod.outlook.com>
References: <20240208220604.140859-1-seanjc@google.com>
 <CAKwvOdk_obRUkD6WQHhS9uoFVe3HrgqH5h+FpqsNNgmj4cmvCQ@mail.gmail.com>
In-Reply-To: 
 <CAKwvOdk_obRUkD6WQHhS9uoFVe3HrgqH5h+FpqsNNgmj4cmvCQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR02MB4058:EE_|LV3PR02MB10243:EE_
x-ms-office365-filtering-correlation-id: af6f6a94-2b28-43b6-9bef-08dc29929a2d
x-ld-processed: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 gLJSvs2LNstGmWAj90Dhc90QbtzEGxL2lYdHlKgUTOEUPIqBjhi4H2R14jj7RelAKmDGKR6sMcmFYwHNxiiqp168Nrpy2BqGmDkIfDov4lNMn5bYCE6L01/Xbw3I0iH2QPtu9K+5lDrF8Gq93CPBk0PH1+kpGV+KQjR1npK0BvDr36oZSHhmzjOwBNLwYBhhQ5UlYUtRPfoOlb0tZRqsGmDDhx5wMQh2OPjkPm/Z3QTLkb0VnjuRfrhD7C7pXCOfSZuJ+Mo4Be5vDPZWtT61i1kv3e2GD+iQW3uKF/F7j9AiIIMmMFhB8Bu3NZ6WbpDO73zAFbfAuIJCvAKVPxT658b3zc6OFjKamHMNIMaJtMc6yuXSvjK3ju9AwvK5rLOBJlN4zncxLVzmlh0AhXRq+RJ+TYkAik3+ufrPIItDoMOCPp++yhAXDqjjUeu8X8V3NuLP4DEOIGmC/IW3weHeAuhFiMTGR3N6lkBgfWA8fldPM2BVW2RWiK0T2wFhRfaS1tqSZTy4d7/6vbrBYIEkNeBkQfkxsNAFnLkjtdi7X++Kd/yo0Twx4DSYc9aGRh0Z44NAaQygRo4JiHVJ0sXzjPagwdsoTsy0O5V4Ibc/MJQ=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR02MB4058.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(136003)(366004)(39860400002)(396003)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(55016003)(52536014)(2906002)(4326008)(8676002)(8936002)(5660300002)(41300700001)(83380400001)(86362001)(38070700009)(66556008)(64756008)(6506007)(7696005)(66446008)(71200400001)(66946007)(76116006)(122000001)(110136005)(66476007)(966005)(54906003)(478600001)(26005)(316002)(9686003)(38100700002)(53546011)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?MEdLZFNERHdzcTMyU0dLQVhyekRzbDJGSWpjNjRQN0xuSUkzeHhWcVRUUFZp?=
 =?utf-8?B?K2xkMG5ZdjdseHhBL2ZIejNXS2xseWlGNWR1dUtmT0pPVUF1bU5LK2F5TjAr?=
 =?utf-8?B?KzNxT0x4R0tHMDRsL01oaHdBZFZFS2xIL3BYSEhDWTJSL1hmNzAvbnowYjhz?=
 =?utf-8?B?TENka3VCMGZSYkxySnN4WEZpVUFHdzc0RjJTNU9OME9rcjhKNklaM0Nvejl6?=
 =?utf-8?B?LzA5c1pTNExTTWM2Y1Zpd01ZR1ErWk9qczRrb2I5M1p5YVc0VlAzTDh6RGRx?=
 =?utf-8?B?YmU5SVY1NFZjTCtjcTVyUmlPc3Bnalhvb004SmhXK3F4bTlQYnZlYmJpdGli?=
 =?utf-8?B?c1dwQW4wekZtakVXbzBMck5XdGZuUy9UVXJ3VVdiTkVXWm9wc3dheStPeFBV?=
 =?utf-8?B?a1EvcFBLRmltZkNCTWoyRVF5OThSQk5LRHFBWlJabmIwM1dRUytCSEgyV0Rm?=
 =?utf-8?B?TjRrY0xlQ3crUkMvZ09pS0JFY2llVVNRQzErbENYQy9NQzIzZkJVZnkwT2pl?=
 =?utf-8?B?WUZZY1hnYmExQ29XUGpoa2s1cElFeUxrRGM3N1lESEpKdVQ2Q002MC9takMv?=
 =?utf-8?B?VXhyU3NkTlRpak9aK1hTTTZhTldhWDdveXpSem04UVFQSkMwcVc5OVljOFJR?=
 =?utf-8?B?L1dIaXU0WWJVWWZwQnBnekN0U1J3bk5TSEFQdEx0TEJ5bVp5V1orTFRaREQv?=
 =?utf-8?B?WkRNRy82VVljdFMwMkdoMG56VFAvVlhpY3crL1RMUm51dWtqNHU1SXdHbWo5?=
 =?utf-8?B?d1pjdkVrN0Fuc0h1M2Qxb2pFYzRXYmdxNml5QmMvZzNPb1dHSnFuVkpWdXli?=
 =?utf-8?B?RUpIUnhLeWxSWXNpdXgwMkZWYXdpaFpEVmp4ZzBmZ2kxb1pzWmhzUEtFMWkw?=
 =?utf-8?B?QlpYNG1ZQ2tHSFFWNkNPZ0w4dzgxV2xIWUo3WGRObnNTelJJZ3haQ0daOGZ1?=
 =?utf-8?B?elAzbnhmS1liSWo3RmRGZ2E0Rk42MllFMVJhcHd0aUxpcm1aV1NHMjB3Z0lS?=
 =?utf-8?B?cGVCeTF3Q0xRUlk1QnU1WkwzekFuRXJySjA0WUpTeW5BelExVlMrSnVtbThQ?=
 =?utf-8?B?amYxMThLb0hVeVNXL3lpdXg3T3FHQk13NmorVEE0eUo4SVQyREdnU3c2OXlo?=
 =?utf-8?B?b2FiYUphY2RLcy9wN0p3VHVOQ1g0Unh3NHk0Q3h2U3hEZ1hVNzNBRms1WDJW?=
 =?utf-8?B?Tk1VbXFuQ1lLNkZVMkFkUTRLMng3dGw2RGpGVkQ3SkRRZ3ZSb1B6MmwxZVVN?=
 =?utf-8?B?c1FxVm9TQloveG5vTlltd2V0VllPNHhpY29iZTlWWm02NlBZUDBJN0RKeEVS?=
 =?utf-8?B?Vkk0anJRTTVzOWU2ckZhaWpiSE40ZlE2OUtsa1dRYkZwY0NYQlRhcHRIcW5k?=
 =?utf-8?B?R3RrNGlmcyt1WG5oWi9MM2JtdUhjR2duaGh2WHR3bFVTcDRYU1NUMUNQN2hS?=
 =?utf-8?B?aEExYmFQb1FXdHU0MnpVZ2pTbEFIVE1uRFlhM0FGaTN6bkRoY2UwcWFSajBI?=
 =?utf-8?B?VUQvNW82Zk5BUjhTYWhMZERKUng0VU45OS9mSnZDSmpSbUcydlp5MVdHVXc0?=
 =?utf-8?B?c2JxQ0wzT0J4alA1TmlrVE9nekZqQ242REI2L1pBTm5rTHhJekdkRHJ6L0hC?=
 =?utf-8?B?anFrbEhUN2I5Q3llL2ZxSXRHSE5vUlVOc0FYQ0NGTHZNNlVMZmlsb0hhZUtu?=
 =?utf-8?B?UE1meEJ1K1RneDY0TXl0eGM1VFcrNWlLblpJWmhjSmFPYXNNZkpLUW5oZXlu?=
 =?utf-8?B?TUVFKzZZN2FONHVMVGtXeGJmN1JJbVFqV3hxQXV6ak1mSDk0dUZxY2pXaEFs?=
 =?utf-8?B?Sm1FZlFpK0FTUDdxamlDY2k0OUhKNUlTRGphNHVubEl0SkVTMEhab05pbElY?=
 =?utf-8?B?QVBHVkRMTVlLclFvMEpJcXJqUGtrV0ZLUlE0Zno4b0NHZ1J5NE9nSERTdVhD?=
 =?utf-8?B?ZC9uakRCQ05TSXhhZE5pYVZRd1BEbmozeFdVYlo1dWcxNnlLQjdhT0JoRFdP?=
 =?utf-8?B?L29mYnlVTkRyb3hzOGRiT0dkRUNSZWF6YU5lYjlLUmlmOGhTaGdUcEFGK3k3?=
 =?utf-8?B?dEN0enM0Z2pFS1FJd3lUalJ1UWFxRlh4TUIyRVpLZTI1UElvenprMDJONTlp?=
 =?utf-8?Q?CpCU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	cTwsNRwjrOa26nLDh6yLXNIcS7yR3Fy0FGvFluyGGpxZ5H92vqxMNdKwI8BoSlurCsTtYejX/YpW0V9aPBeY3x0hj8gqSQoE9YsuDcyJnQ3EhM/wly/rxKWzWwJh+ARe5aPDYwqPg+KSGoGeQ0MrylElyI/H8qz5mM1Jeuc+KLIS7qAkjKgL0elTtCFVXv1Lcj2tT7SgOLjV/ChKT+dvozCCZNu6tFcBr/dDrkhBFIhkDJoOf1zLZwC71tLaP60fIh4wZG+DKnC+zB/BY9Q7Iw/JjGUXG6pZX6QlfDMsVZjT6EQ+fNeNqy2e11JF+wMjNVxuvBzftmks3Zb3duscmOSFiRSQe3W8FjKXYvU1VkEZdlXKTfGM8Tm58wdfTNxP3rZwxNBSjmnOcXxlOmN1bfe9s+bJuWuIGgkaKd2u48LnjRJeYn3EwFlFGTHUW4IpHFSBaWuTjLJe8Kyvj73tn6kio5WRpk79GpjH7/h+wwjfhdIb9OSLNEggfztVN+acW0mN3lH33CoHxW+hrhEHzs9sf1t7EhOPaTChlK+LHkgpOSGwX1wryv8KLVAydN8GUaR0rI0sgQnPqQqGvufoGj4fzaNXUvRu79UmGPNWPiPN6rNoz9Csnh2KbUCjq6Fn
X-OriginatorOrg: quicinc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR02MB4058.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af6f6a94-2b28-43b6-9bef-08dc29929a2d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2024 17:14:40.7810
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7ng2ZqpRiDpSQDHl3fAiHFHub5TXfEchihtkaJeRcoDFv35Xh7TVl64KRjFHbr343OeojdY0NMsAG4hvhHrQiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR02MB10243
X-Proofpoint-ORIG-GUID: MArHLKo-wki9SzjeTQ7-5Uk2As_WoISN
X-Proofpoint-GUID: MArHLKo-wki9SzjeTQ7-5Uk2As_WoISN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-09_14,2024-02-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 bulkscore=0 lowpriorityscore=0 impostorscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2401310000 definitions=main-2402090123

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBOaWNrIERlc2F1bG5pZXJzIDxu
ZGVzYXVsbmllcnNAZ29vZ2xlLmNvbT4NCj4gU2VudDogRnJpZGF5LCBGZWJydWFyeSA5LCAyMDI0
IDk6MDMgQU0NCj4gVG86IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPjsg
QW5kcmV3IFBpbnNraSAoUVVJQykNCj4gPHF1aWNfYXBpbnNraUBxdWljaW5jLmNvbT4NCj4gQ2M6
IExpbnVzIFRvcnZhbGRzIDx0b3J2YWxkc0BsaW51eC1mb3VuZGF0aW9uLm9yZz47IGxpbnV4LQ0K
PiBrZXJuZWxAdmdlci5rZXJuZWwub3JnOyBNYXNhaGlybyBZYW1hZGEgPG1hc2FoaXJveUBrZXJu
ZWwub3JnPjsgUGV0ZXINCj4gWmlqbHN0cmEgPHBldGVyekBpbmZyYWRlYWQub3JnPjsga3ZtQHZn
ZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSBLY29uZmlnOiBFeHBsaWNpdGx5
IGRpc2FibGUgYXNtIGdvdG8gdy8gb3V0cHV0cyBvbiBnY2MtMTENCj4gKGFuZCBlYXJsaWVyKQ0K
PiANCj4gKyBBbmRyZXcNCj4gDQo+IEFuZHJldywgaGVyZSdzIHRoZSBmdWxsIHRocmVhZCwgSSBj
dXQgbW9zdCBvZiBpdCBvdXQ6DQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvMjAyNDAy
MDgyMjA2MDQuMTQwODU5LTEtDQo+IHNlYW5qY0Bnb29nbGUuY29tLw0KDQpTbyB0aGUgZXhhY3Qg
dmVyc2lvbnMgb2YgR0NDIHdoZXJlIHRoaXMgaXMvd2FzIGZpeGVkIGFyZToNCjEyLjQuMCAobm90
IHJlbGVhc2VkIHlldCkNCjEzLjIuMA0KMTQuMS4wIChub3QgcmVsZWFzZWQgeWV0KQ0KDQpUaGlz
IGluZm9ybWF0aW9uIGlzIGxpc3RlZCBpbiB0aGUgYnVnIHJlcG9ydCB2aWEgdGhlICJrbm93biB0
byB3b3JrIiBmaWVsZCB0aG91Z2ggc2luY2UgMTIuNC4wIGlzIG5vdCByZWxlYXNlZCB5ZXQsIGl0
IGlzIGxpc3RlZCBhcyAxMi4zLjEuICgxMy4yLjAgd2FzIG5vdCByZWxlYXNlZCBhdCB0aGUgdGlt
ZSBpdCB3YXMgYmFja3BvcnRlZCBzbyBpdCBpcyBsaXN0ZWQgYXMgMTMuMS4xKS4gVGhlIHRhcmdl
dCBtaWxlc3RvbmUgaW4gdGhpcyBjYXNlIGxpc3RzIHRoZSBsb3dlc3QgdmVyc2lvbiAjIHdoZXJl
IHRoZSBmaXggaXMvd2lsbCBiZSBpbmNsdWRlZC4NCg0KVGhhbmtzLA0KQW5kcmV3IFBpbnNraQ0K
DQo+IC4NCj4gDQo+IE9uIFRodSwgRmViIDgsIDIwMjQgYXQgMjowNuKAr1BNIFNlYW4gQ2hyaXN0
b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KPiB3cm90ZToNCj4gPg0KPiA+IEV4cGxpY2l0
bHkgcmVxdWlyZSBnY2MtMTIrIHRvIGVuYWJsZSBhc20gZ290byB3aXRoIG91dHB1dHMgb24gZ2Nj
IHRvDQo+ID4gYXZvaWQgd2hhdCBpcyBlZmZlY3RpdmVseSBhIGRhdGEgY29ycnVwdGlvbiBidWcg
b24gZ2NjLTExLiAgQXMgcGVyDQo+ID4gaHR0cHM6Ly9nY2MuZ251Lm9yZy9vbmxpbmVkb2NzL2dj
Yy9FeHRlbmRlZC1Bc20uaHRtbCwgImFzbSBnb3RvIiBpcw0KPiA+ICpzdXBwb3NlZCogYmUgaW1w
bGljaXRseSB2b2xhdGlsZSwgYnV0IGdjYy0xMSBmYWlscyB0byB0cmVhdCBpdCBhcyBzdWNoLg0K
PiA+IFdoZW4gY29tcGlsaW5nIHdpdGggLU8yLCBmYWlsdXJlIHRvIHRyZWF0IHRoZSBhc20gYmxv
Y2sgYXMgdm9sYXRpbGUNCj4gPiBjYW4gcmVzdWx0IGluIHRoZSBlbnRpcmUgYmxvY2sgYmVpbmcg
ZGlzY2FyZGVkIGR1cmluZyBvcHRpbWl6YXRpb24uDQo+ID4NCj4gPiBMaW5rOiBodHRwczovL2dj
Yy5nbnUub3JnL2J1Z3ppbGxhL3Nob3dfYnVnLmNnaT9pZD0xMDM5NzkNCj4gDQo+IFNob290LCBJ
IHdhcyBjYydlZCBvbiB0aGF0IGJ1ZyAoSSB0aGluayBJIG5vdGljZWQgaXQgaW4gdGVzdGluZyBh
cyB3ZWxsLCBhbmQNCj4gcG9pbnRlZCBpdCBvdXQgdG8gQW5kcmV3IG9uIElSQyB3aG8gdGhlbiBj
YydlZCBtZSB0byBpdCkuIEkgcHJvYmFibHkgc2hvdWxkDQo+IGhhdmUgYXNrZWQgaWYgdGhhdCB3
b3VsZCBjYXVzZSBpc3N1ZXMgYXQgc29tZSBwb2ludCBmb3IgdGhlIGtlcm5lbC4NCj4gDQo+IEkg
dG9vayBhIGxvb2sgYXQgdGhlIHRlc3QgY2FzZSBhZGRlZCBpbiB0aGF0IGJ1ZzsgaXQgZG9lc24n
dCBjb21waWxlIHVudGlsIGdjYy0xMw0KPiAoc3BlY2lmaWNhbGx5IGdjYyAxMy4yLCBub3QgZ2Nj
IDEzLjEpLiAgSSdtIGN1cmlvdXMgc2luY2UgdGhlIGJ1ZyBzYXlzIHRoZSBmaXggd2FzDQo+IGJh
Y2twb3J0ZWQgdG8gZ2NjLTEyIGFuZCBnY2MtMTMuIEFyZSB0aGVyZSBzcGVjaWZpYyB2ZXJzaW9u
cyBvZiB0aG9zZSB0aGF0DQo+IGNvbnRhaW4gdGhlIGZpeD8gSWYgc28sIHNob3VsZCBTZWFuIGFt
ZW5kIGhpcyB2ZXJzaW9uIGNoZWNrcyBiZWxvdz8gRm9yDQo+IGluc3RhbmNlLCB3YXMgdGhlIGZp
eCBiYWNrcG9ydGVkIHRvIGdjYyAxMi4zLCBzbyB1c2VycyBvZiBnY2MgMTIuMiB3b3VsZCBzdGls
bA0KPiBoYXZlIGlzc3Vlcz8gIEkgY2FuJ3QgdGVsbCBpbiBnb2Rib2x0IHNpbmNlIHRoZSBhZGRl
ZCB0ZXN0IGNhc2UgZG9lc24ndCBjb21waWxlDQo+IHVudGlsIGdjYyAxMy4yLiBodHRwczovL2dv
ZGJvbHQub3JnL3ovZXFhYTdkZm8zDQo+IA0KPiBNeSBpbXBsZW1lbnRhdGlvbiBpbiBjbGFuZyBz
dGlsbCBoYXMgc29tZSBpc3N1ZXMsIHRvby4gIEl0J3MgaGFyZCB0byBnZXQgbmV3DQo+IGNvbnRy
b2wgZmxvdyByaWdodCwgYW5kIHRoZXJlIGFyZSBtaW5pbWFsIHVzZXJzIG91dHNpZGUgdGhlIGtl
cm5lbCB0byBoZWxwIHVzDQo+IHZhbGlkYXRlLg0KPiANCj4gU28gYXMgbXVjaCBvZiBhIGZhbiBv
ZiBmZWF0dXJlIGRldGVjdGlvbiBhcyBJIGFtLCBJIGFkbWl0IHNvbWUgb2YgdGhlc2UgZWRnZQ0K
PiBjYXNlcyBhcmVuJ3QgcGVyZmVjdCwgYW5kIHdlIG1heSBuZWVkIHRvIHJlc3VsdCB0byB2ZXJz
aW9uIGRldGVjdGlvbiB3aGVuDQo+IHN1Y2ggYnVncyBiZWNvbWUgb2JzZXJ2YWJsZSB0byB1c2Vy
cy4NCj4gDQo+IEknbSBoYXBweSB0byBhY2sgdGhpcyBwYXRjaCwgYnV0IEkgd291bGQgbGlrZSB0
byB3YWl0IGZvciBmZWVkYmFjayBmcm9tIEFuZHJldw0KPiBhcyB0byB3aGV0aGVyIHdlIGNhbiBi
ZSBldmVuIG1vcmUgcHJlY2lzZSB3aXRoIGF2b2lkaW5nIG1vcmUgc3BlY2lmaWMNCj4gdmVyc2lv
bnMgb2YgZ2NjIDEyIGFuZCAxMyAoaWYgbmVjZXNzYXJ5KS4NCj4gDQo+ID4gRml4ZXM6IDU4N2Yx
NzAxOGEyYyAoIktjb25maWc6IGFkZCBjb25maWcgb3B0aW9uIGZvciBhc20gZ290byB3Lw0KPiA+
IG91dHB1dHMiKQ0KPiA+IENjOiBOaWNrIERlc2F1bG5pZXJzIDxuZGVzYXVsbmllcnNAZ29vZ2xl
LmNvbT4NCj4gPiBDYzogTWFzYWhpcm8gWWFtYWRhIDxtYXNhaGlyb3lAa2VybmVsLm9yZz4NCj4g
PiBDYzogUGV0ZXIgWmlqbHN0cmEgPHBldGVyekBpbmZyYWRlYWQub3JnPg0KPiA+IENjOiBrdm1A
dmdlci5rZXJuZWwub3JnDQo+ID4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gPiBTaWdu
ZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gPiAt
LS0NCj4gPg0KPiA+IExpbnVzLCBJJ20gc2VuZGluZyB0byB5b3UgZGlyZWN0bHkgYXMgdGhpcyBz
ZWVtcyB1cmdlbnQgZW5vdWdoIHRvDQo+ID4gYXBwbHkgc3RyYWlnaHRhd2F5LCBhbmQgdGhpcyBv
YnZpb3VzbHkgYWZmZWN0cyBtdWNoIG1vcmUgdGhhbiB0aGUgYnVpbGQNCj4gc3lzdGVtLg0KPiA+
DQo+ID4gIGluaXQvS2NvbmZpZyB8IDUgKysrKysNCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDUgaW5z
ZXJ0aW9ucygrKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2luaXQvS2NvbmZpZyBiL2luaXQvS2Nv
bmZpZyBpbmRleA0KPiA+IGRlZGEzZDE0MTM1Yi4uZjRlNDZkNjRjMWU3IDEwMDY0NA0KPiA+IC0t
LSBhL2luaXQvS2NvbmZpZw0KPiA+ICsrKyBiL2luaXQvS2NvbmZpZw0KPiA+IEBAIC04Miw2ICs4
MiwxMSBAQCBjb25maWcgQ0NfQ0FOX0xJTktfU1RBVElDDQo+ID4gICAgICAgICBkZWZhdWx0ICQo
c3VjY2VzcywkKHNyY3RyZWUpL3NjcmlwdHMvY2MtY2FuLWxpbmsuc2ggJChDQykNCj4gPiAkKENM
QU5HX0ZMQUdTKSAkKFVTRVJDRkxBR1MpICQoVVNFUkxERkxBR1MpICQobTMyLWZsYWcpIC1zdGF0
aWMpDQo+ID4NCj4gPiAgY29uZmlnIENDX0hBU19BU01fR09UT19PVVRQVVQNCj4gPiArICAgICAg
ICMgZ2NjLTExIGhhcyBhIG5hc3R5IGJ1ZyB3aGVyZSBpdCBkb2Vzbid0IHRyZWF0IGFzbSBnb3Rv
IGFzIHZvbGF0aWxlLA0KPiA+ICsgICAgICAgIyB3aGljaCBjYW4gcmVzdWx0IGluIGFzbSBibG9j
a3MgYmVpbmcgZHJvcHBlZCB3aGVuIGNvbXBpbGluZyB3aXRoIC0NCj4gMDIuDQo+ID4gKyAgICAg
ICAjIE5vdGUsIGV4cGxpY2l0bHkgZm9yY2luZyB2b2xhdGlsZSBkb2Vzbid0IGVudGlyZWx5IGZp
eCB0aGUgYnVnIQ0KPiA+ICsgICAgICAgIyBodHRwczovL2djYy5nbnUub3JnL2J1Z3ppbGxhL3No
b3dfYnVnLmNnaT9pZD0xMDM5NzkNCj4gPiArICAgICAgIGRlcGVuZHMgb24gIUNDX0lTX0dDQyB8
fCBHQ0NfVkVSU0lPTiA+PSAxMjAwMDANCj4gDQo+IExHVE07IGJ1dCB3ZSBtaWdodCBuZWVkIHRv
IGJlIG1vcmUgc3BlY2lmaWMgYWJvdXQgYXZvaWRpbmcgY2VydGFpbiBtaW4NCj4gdmVyc2lvbnMg
b2YgZ2NjIDEzIGFuZCAxMi4NCj4gDQo+ID4gICAgICAgICBkZWZfYm9vbCAkKHN1Y2Nlc3MsZWNo
byAnaW50IGZvbyhpbnQgeCkgeyBhc20gZ290byAoIiI6DQo+ID4gIj1yIih4KSA6OjogYmFyKTsg
cmV0dXJuIHg7IGJhcjogcmV0dXJuIDA7IH0nIHwgJChDQykgLXggYyAtIC1jIC1vDQo+ID4gL2Rl
di9udWxsKQ0KPiA+DQo+ID4gIGNvbmZpZyBDQ19IQVNfQVNNX0dPVE9fVElFRF9PVVRQVVQNCj4g
Pg0KPiA+IGJhc2UtY29tbWl0OiAwNDczNzE5NjhmZmM0NzA3NjlmNTQxZDY5MzNlMjYyZGM3MDg1
NDU2DQo+ID4gLS0NCj4gPiAyLjQzLjAuNjg3LmczOGFhNjU1OWIwLWdvb2cNCj4gPg0KPiANCj4g
DQo+IC0tDQo+IFRoYW5rcywNCj4gfk5pY2sgRGVzYXVsbmllcnMNCg==

