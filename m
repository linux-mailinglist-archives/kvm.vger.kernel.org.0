Return-Path: <kvm+bounces-60013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B773BD90F0
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 13:34:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7AED3B4A30
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 11:34:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F12C530BF6B;
	Tue, 14 Oct 2025 11:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fLnEL9NG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FFC91F239B
	for <kvm@vger.kernel.org>; Tue, 14 Oct 2025 11:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760441664; cv=fail; b=UstdA/0sonctBMNcXbYBbMEuPWs1RpFd4vrR3A6I0IusybSXBTcCw6D5jXGjpCvx4Lhd7UH9D3qKVz+h1Bu9Vwc9cb0VbPy3V6swKfYVqXJBTqPMhCMHjXKPe1nrOSqnkr9mmeg398S75JPYb7G13hfMVzGriyTkQi14BEBPwhM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760441664; c=relaxed/simple;
	bh=xH18KKEAQi3aiN/93VIiCiLskIsVjKBIHGrh9f5RRyQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rwjlbs1DQBvV/TVrHQvnq+QxsngD6QJkihmsWs26LHeANjAPzi4sd8Y8teEOQCwSLiP73EJGlwN7MfXzZZobVJzlntL4lejBRVRDhRyQr8rBW6ohFmJlrIRKXxDKK7vc9UfdNqfEx2FbH5RcG+0rUMG7CzvRkVRrKt7S9P24ZAo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fLnEL9NG; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760441662; x=1791977662;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=xH18KKEAQi3aiN/93VIiCiLskIsVjKBIHGrh9f5RRyQ=;
  b=fLnEL9NGUBZ9Qxrd2PIb+dTGPZih9rWk9lkGq0KfSeJfv/3wCUIttG5S
   GfRger6E8Ie+xcQKfXpZ3hS89w2LhKYEQoCnRkFTrrZvBFCGVpBYy9ycq
   /1v9d6HYtLQ9own2b+uUWnGvv5tPpLGcvoB51Hfsl/FSEiaeF7m64z3no
   WbCdCA97FCDv0D2R+ObEuKplyvwXiNXk4ZzL718T8bh+Y3y3yHWBfg7AL
   zYAhaYZhpyCKq+it41hkJDoGgkINj5DcAcauYtZvlaIZKjfOYGeb+P5c7
   dGFdRw4It1RvupxvnflXMkvB6HY4e7n23+kCMGQGqU0YEyXZl62lAqlmt
   Q==;
X-CSE-ConnectionGUID: HBgg3MTQSn6TUqoWiJjl4w==
X-CSE-MsgGUID: 5mzaWf/2RSqQjuB2tmc70g==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="61808397"
X-IronPort-AV: E=Sophos;i="6.19,228,1754982000"; 
   d="scan'208";a="61808397"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 04:34:22 -0700
X-CSE-ConnectionGUID: wVMjjc2sTC6a3cCjnfNXxw==
X-CSE-MsgGUID: Se85EGeMTCa0V9Qo3Bg5Ag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,228,1754982000"; 
   d="scan'208";a="181816211"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 04:34:22 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 04:34:21 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 14 Oct 2025 04:34:21 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.54) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 04:34:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wXlXBKVgCSeZP32FDp4mQXx2TYpW8Ii+9Ky9LZzOvqKWa8kziSq3CVYX40QFu93CAyprgP/p+5xjsfAsEE5fAl3/Btbrm+z4r1cmA+DXK1Syj3gBvKXm+177/2G8GOfIRhpYN4dltHx+MEb0NtpgvGYdbf4NHaSxUydGhbNX2eif9uRE7nrXrcguW+2p5TaDd2tX/EOCrennoc/6OHJt6Uw+nJN6GDZ3ccgMGJcMyMZNHyfQbE9OmJf0oGIIOmU5PxbhEts0m74XU6+RQBj1fYMNmCw36uaADNBtvjZuvTVlPyOEcRd/b6LxOCMear8vGAwddh0Qe+yisAlP8BgTfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xH18KKEAQi3aiN/93VIiCiLskIsVjKBIHGrh9f5RRyQ=;
 b=j9fdtwcOMLLftuznnBulICBRCRbCcaqUud3S2NQhqGzL7wFKuz20+16Hp3wALFiIbUl/bOu3x+KcjIlBAhjRweH9lSO8bITlzVD/BP2pTyKPJInKe9UW9ZfK/PbdrRtZbqFe94BY+hAgS5gMNz02oFP8PXZTd8lLPJoB20P1uYr/uR+kw/yQPirfgCbq10ibqKiObSdRAqTRApuYZC3S75mik0JvIJBlqWnANfpRzL9DpOqkdQJeppbRIPGoqTQTiE+nqScmQeSQNr8WPioLYAhC7qx8Br7CquijwkkhiqbvpNngjXXu5IHGhopD1Ouk7fPwRcg6/FIS7N/heEHneA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by BN9PR11MB5241.namprd11.prod.outlook.com (2603:10b6:408:132::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.10; Tue, 14 Oct
 2025 11:34:19 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9228.009; Tue, 14 Oct 2025
 11:34:19 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "nikunj@amd.com" <nikunj@amd.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v4 4/7] KVM: x86: Move nested CPU dirty logging logic to
 common code
Thread-Topic: [PATCH v4 4/7] KVM: x86: Move nested CPU dirty logging logic to
 common code
Thread-Index: AQHcPApHQq5GYUzMbUWZEhHpuKXxubTBhNuA
Date: Tue, 14 Oct 2025 11:34:19 +0000
Message-ID: <30dd3c26d3e3f6372b41c0d7741abedb5b51d57d.camel@intel.com>
References: <20251013062515.3712430-1-nikunj@amd.com>
	 <20251013062515.3712430-5-nikunj@amd.com>
In-Reply-To: <20251013062515.3712430-5-nikunj@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|BN9PR11MB5241:EE_
x-ms-office365-filtering-correlation-id: c10a8633-770f-4c84-3ba9-08de0b159d1f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?dHh2QU4zdE52ZGdmM2ZiNnlyNWhVb1RWcHBkMW9Zekh4SWVvbWs5SS95UVh1?=
 =?utf-8?B?UHZwTHluUC9YUzNCMEVCQXlZM2Jnc2YzZVE0aHNWMkV6SXI3eXl4QlN6cnB4?=
 =?utf-8?B?cEdxdUZNdlJCamRhdjAwaE9janM2QUNjcmN0NkRWZlVvS3pWRU9RRzVrdGFE?=
 =?utf-8?B?T3dGamxZdGthWnBodnlVS3U2Q2N6eHJjdXlIbUVBNnhoa3FZdFoxWm5sOUtK?=
 =?utf-8?B?UkRmOXMzdERTODFTdEJTQVk0NVNPK05rSnhZRkM2T2ZaU1g0YlJkTy9sWnZP?=
 =?utf-8?B?Qnc0RW9jWXY3SmpvRFN6NEtwdWJlUTBYaEJEbFE5eDRycjdXNnRaMUhiYjRz?=
 =?utf-8?B?YXZYbHpqWXk0MjhHU1htZmZuK20zcVhlT095UEFSWmpIbHg5Yk12NHk4bk00?=
 =?utf-8?B?ajhncDBoaEx2L2ZrQWdxZVgrK1ZCYVU5UHNzY0d2T0hNSG04QzZySllQUzcv?=
 =?utf-8?B?UTg4WDVJQzloamJDRlU3YmFKT3BGOGZuRDBSdU4zNTFBbHNnVHlaWElyNFly?=
 =?utf-8?B?NTJPSHdDQmVsMFNNRVI1ZzltSFQzdG9taDEvb2F5bEdaQU1aUDNoaXZIbHNV?=
 =?utf-8?B?VFUvM014SjN3L0UxNUlHRXcrd2tIMFJKZURRbXgxMWFjN2xFcjJxTmxZMXNF?=
 =?utf-8?B?VUZmS3BDSXVpdUMwOUtLRmJkSlBKK3UvUzRnM0tqTDRnajczalBGWnlMTVFB?=
 =?utf-8?B?OG95L3RMc3cwT0MzY2dhUTJnTG5jTHJFaDR2bitaM1VpcGpvUG5lUDJyRG5I?=
 =?utf-8?B?MGNSWDhEWEdrREFOa2VzaWp0UkhMdnIwV1JETmNsYnB1am9RZVB1eCtaMmcw?=
 =?utf-8?B?NldRcG5KSWV1endIRWZ1REFBTStVN3RyRGF0cHN3KzZXNHdFVmlqMk9zT09V?=
 =?utf-8?B?b1VHS240SVJMYlU1bFI0ZkxET3JKN0VjZXZqeFdnbS9iR3pPSFZyVko3bXIv?=
 =?utf-8?B?MG12K1JFSmF0cDNyTDYxU2QyU0pOSE1lZ2toUngrcEI4dzNodDM3UXFmMlNa?=
 =?utf-8?B?QS8wV2tpSUJJYXhmODFRcVQ0cWlvWGppM1RWcE1jS05zZzdwdkxXZmdueEIv?=
 =?utf-8?B?NUwxK0J3d2FyemFOVG1Nb21LSDFGOUtmcE9yQ1E1ZWtSUTVTcGU4TlJVUWxo?=
 =?utf-8?B?WUF6aGdkaHpRejQvNXVKMU5rYmI1dGZFY0pBbmx0WE43RHVoaEpBaFBKV0sy?=
 =?utf-8?B?WnNOZXUvd09PN0l0eXg5RzRHZjVpSzdzdWNndVlRa2ZUUzZCVE9UQWk0dXJl?=
 =?utf-8?B?K1JET0kxUnl6cm5hQm5CekN6TkdKTDlWK3V0OEF3cHZMSWlRRVlnbnRUL0U5?=
 =?utf-8?B?bnoxVW1Jc3BKSDJOdzhteVA4Tlc2SEVwRCs4OG90MjFiRDhHTmMwU3pYMUVy?=
 =?utf-8?B?NlNjY1dpWFF1YXp0bUpHc0lLbVdTbnBpVWJ1QlRKaXlRQnVwdE5CQVZwRmc2?=
 =?utf-8?B?MVF6V2JGV1prV3pGclBBbW8zWko3R0Y1dVBBOW4zRW1NbEFKZ2d2azJsQ1BK?=
 =?utf-8?B?MFFrYUg0QkgvU256c05zZmVONGxTRTdlbUhMbktpdUI2dzE0SVZSY2NRekJJ?=
 =?utf-8?B?NC9wYnFVVEFLdjNFY0hjTnJoWDYvd3RScS9RWERFNXdtT0x4ejZHZmJveG43?=
 =?utf-8?B?d1EyV2FHNmZvemtKTHlhSE1jYlIwKzQzbTZqYkl3R3RiUEtOdXQvUlBFQ3RO?=
 =?utf-8?B?NFloM3RMZzFYWEZvSHMwRG8ySnArakRFTG14WDdiRGhLbnNScHBrOFAvYTdu?=
 =?utf-8?B?dHQyNk9rYXZHNUpqNE1pRmNXZkRFWDJnZVpwcWFZTE9teDlYWTh6QkVRVTBL?=
 =?utf-8?B?RVdBRU15TjE3SGUwT3kybDlyZUJPWFl4RCs3eUN4ZzFhN1RjMFo0M003dENl?=
 =?utf-8?B?aXN5eTNTSmw3VnJ0aWVlVEw5UEs0MlMrTnY0S3ZrQkVmYXZWOFNhczRrdS8r?=
 =?utf-8?B?UnVRVDdqTGl6MzBIbnhZZUxiRWdyM0NRWUVxY2xvNXdZdHhRaDZQOC8rN0x3?=
 =?utf-8?B?OHZESGhnYnRLcTVqTmpEUnoxNzNPNVNhMmhnN2NOdGp6TVNIMGdNZXl4V0ls?=
 =?utf-8?Q?8u4QOh?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MlpaTU91aWU4b0YzMncxaUFBSU9qR1I1UTBjZ2FqdmxwUnlEYmQrbHp3SjRv?=
 =?utf-8?B?eXVxMXJQSmdaMG1SQmplU0VnTWRlOGo4eUtpRGk3UmNHUmxzZ3A5T2JqSVl0?=
 =?utf-8?B?T0JOTmRqWnVNczlaNnpyTU9abEtiWVViL0VLTk13ODhWUklGcVlITXdTb1ds?=
 =?utf-8?B?N3doUmdCN0Z2ZmMxcmdxZWNzVkdlTTMxZUo1K3ZJVU9VYnZESEU0NkIwaE93?=
 =?utf-8?B?Y201NXNTZmtvbXpxZndjODBvaWpHeU9SclMrd1J1MFh2UDRVaW1tWWZTQWZ5?=
 =?utf-8?B?U2s2LzlTWDY0ZWd6ckl5emdRZzJSMFFMWDlYRytNZ3lOcFU4dzVRZmYxVlA3?=
 =?utf-8?B?YWNkYUlsb0RabjFtWkhYL002bjBkK0pMVEorcUlTVFNTNnZmVTgzTzNTcE5M?=
 =?utf-8?B?K1VHL3I4dGh6MU5RTzY3YTkzSmh6NVV4aWNWa3hCY09WdTBVOGROaDZwTVFS?=
 =?utf-8?B?VWM0YWE1WWxISnJqeG1pSUFQakFiRHlCbTJDbkVqR0ZzVGN2UkVCbExuNFNG?=
 =?utf-8?B?azJSbE8vYkNiNzBiZlNmTVdOcFUrbkJMblo3UjZrQTlvU2prVUJlYTBONXla?=
 =?utf-8?B?Wm8vZDc2WGxnRUw2MGRQTG1MOVNkeG9rVG4xOFhPcFRoY0daaUtjaURJZE9G?=
 =?utf-8?B?OTdUSkpKelFPZjVpT3lNZlc5Tld1RElYK0lySEN6Z0ovTytLTUhjcEJrUXF4?=
 =?utf-8?B?dEhDcVp5TXl2alRhamFPRnczSlkwK1FvS2t0OEZOQ05ZalRKd0VjNkRlUWlv?=
 =?utf-8?B?VUwrbm5ZaVBtVVVpRWRPT1NOeDQ3WEc2cVk0dXQ0dGVzNjd4TC8ydkVzV1FQ?=
 =?utf-8?B?bWd1WkV1WkVYQmRTVmRaTlhmTVQ5cU9vUDgxM2d2bDRZYk9qT3FXVHYwaFRS?=
 =?utf-8?B?K1F6WnIvWkw4clIvL3BJbnJjNnhKbjlQUFlJQklubjkwbS9WYlV1K0cxcXR6?=
 =?utf-8?B?Nk5Uc3c5MWZ6Ty9PUk1RMVpCTXVxMC95U0pkbDlFdm9aeTByanRLN0RXcURm?=
 =?utf-8?B?K0ZyR0FPSjhSbjZkdk94SCtpdU54VzA1WEZkV1ZsSWxyWmNYcTEwbmVsSDM2?=
 =?utf-8?B?NGt5TTAzeFM3b2d4QVdYVUFWYWlZd2ZRZFR0d25sODVtUHdvcnNUZXFEOGFI?=
 =?utf-8?B?a2F4Y2ZGamhkWEpidEJRNHlwa09CMHF5NzNYc0pEMEliMDVnS0dyT1N2STBO?=
 =?utf-8?B?V2kybFBoT1lLWlh0Y3R1UEJxY21DVDMyOFEzTmFCTFN4Z002c2tGdU9nVm9U?=
 =?utf-8?B?Vk84YmhTam01ZTZwZzBwRElYZy9WQ1hDdHRBSkZhazRiZWtGZ3ZTRDJZMXBC?=
 =?utf-8?B?V1ZVWWhNd3IxbHZZK2dWNmI4MDN5SnZWQ1p6aGZId3JDSlN2WnIrcHdUMkpt?=
 =?utf-8?B?ZWx6Q2NPWDQrODMzWXcrYVVmN1VkSlV4dGg5Y3RRWWhUYkh2eHlsTlVMOWlu?=
 =?utf-8?B?NSsyZk1Tc0w2cHNQZXNnZmN3M0Rac1BGMGVMcnl3cnFDK0kwWDc2ZGRJYWNC?=
 =?utf-8?B?aC9HUTR3VlVVUU9NYjRKYUJBcW85TnB3SFQ3WEw0d2M3RVo1Q3c4SHJkQlBm?=
 =?utf-8?B?YUM5UkRoYzM5TitwN3FYUjNmS09ndVpwWDBrY21VTmJBSjdYd3RLZlFXaFNw?=
 =?utf-8?B?elh6RGZDUUdzWmpVdjFvY3U3ZXR3bHhpaG9qSWlhOVFQYWUvNlZZL1R2ZHJP?=
 =?utf-8?B?QmdTZ0FuZWxINjRwSzdyVnlQVThNTWNZSnlsNDdoUlFpQjBPTlJqRXdQaXV3?=
 =?utf-8?B?UytoNFl6MEVVY0hHRFpzQTNBblY0eldmNVc3WjFQSXFac2RCUmhIR0VsbHJp?=
 =?utf-8?B?bmlBVEliWmt5OTExQzNaVTU4a0ZlQlkrMEhONklkN0kzY1RsNG9iaTR2NXpz?=
 =?utf-8?B?bStoUnUrRUZiSDFDRS9UZisrcFhZZ2xlQldjRzVqRXVBWHZQaUJ0M01rc3F3?=
 =?utf-8?B?bHZ1T2dGTk55WmFSOGRSOHJ2MFo0NFFWcFFXT2JWdVVGcGgyRWVtbmVuUS9M?=
 =?utf-8?B?dnJIWTMzUjRmcFJZMGxVc2tRaTJJL0FjVWxhVDBIckxJY1AvSkp3bHZBeE81?=
 =?utf-8?B?WVBVU1ZMQzZzK2tVVTBRWTNDMzlhV2I5S3FsWENpaThlV3ozbnBuQnhXSlRD?=
 =?utf-8?Q?OQ5Ga9f+80I5IjLcTTK64qJP7?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9A8DA40EB2BDE846AAD8C1029559AE2A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c10a8633-770f-4c84-3ba9-08de0b159d1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2025 11:34:19.0820
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FS6z+3zyowhp7wo32FDezz+yHnus3oOqcE04eQq7WAB5purDq4eUQ1zSECbxwzxecSgIE54L2tpUj0jEqO3zjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5241
X-OriginatorOrg: intel.com

DQo+ICANCj4gLXZvaWQgdm14X3VwZGF0ZV9jcHVfZGlydHlfbG9nZ2luZyhzdHJ1Y3Qga3ZtX3Zj
cHUgKnZjcHUpDQo+ICt2b2lkIHZteF91cGRhdGVfY3B1X2RpcnR5X2xvZ2dpbmcoc3RydWN0IGt2
bV92Y3B1ICp2Y3B1LCBib29sIGVuYWJsZSkNCj4gIHsNCj4gLQlzdHJ1Y3QgdmNwdV92bXggKnZt
eCA9IHRvX3ZteCh2Y3B1KTsNCj4gLQ0KPiAtCWlmIChXQVJOX09OX09OQ0UoIWVuYWJsZV9wbWwp
KQ0KPiAtCQlyZXR1cm47DQo+IC0NCj4gLQlpZiAoaXNfZ3Vlc3RfbW9kZSh2Y3B1KSkgew0KPiAt
CQl2bXgtPm5lc3RlZC51cGRhdGVfdm1jczAxX2NwdV9kaXJ0eV9sb2dnaW5nID0gdHJ1ZTsNCj4g
LQkJcmV0dXJuOw0KPiAtCX0NCj4gLQ0KPiAtCS8qDQo+IC0JICogTm90ZSwgbnJfbWVtc2xvdHNf
ZGlydHlfbG9nZ2luZyBjYW4gYmUgY2hhbmdlZCBjb25jdXJyZW50IHdpdGggdGhpcw0KPiAtCSAq
IGNvZGUsIGJ1dCBpbiB0aGF0IGNhc2UgYW5vdGhlciB1cGRhdGUgcmVxdWVzdCB3aWxsIGJlIG1h
ZGUgYW5kIHNvDQo+IC0JICogdGhlIGd1ZXN0IHdpbGwgbmV2ZXIgcnVuIHdpdGggYSBzdGFsZSBQ
TUwgdmFsdWUuDQo+IC0JICovDQo+IC0JaWYgKGF0b21pY19yZWFkKCZ2Y3B1LT5rdm0tPm5yX21l
bXNsb3RzX2RpcnR5X2xvZ2dpbmcpKQ0KPiAtCQlzZWNvbmRhcnlfZXhlY19jb250cm9sc19zZXRi
aXQodm14LCBTRUNPTkRBUllfRVhFQ19FTkFCTEVfUE1MKTsNCj4gKwlpZiAoZW5hYmxlKQ0KPiAr
CQlzZWNvbmRhcnlfZXhlY19jb250cm9sc19zZXRiaXQodG9fdm14KHZjcHUpLCBTRUNPTkRBUllf
RVhFQ19FTkFCTEVfUE1MKTsNCj4gIAllbHNlDQo+IC0JCXNlY29uZGFyeV9leGVjX2NvbnRyb2xz
X2NsZWFyYml0KHZteCwgU0VDT05EQVJZX0VYRUNfRU5BQkxFX1BNTCk7DQo+ICsJCXNlY29uZGFy
eV9leGVjX2NvbnRyb2xzX2NsZWFyYml0KHRvX3ZteCh2Y3B1KSwgU0VDT05EQVJZX0VYRUNfRU5B
QkxFX1BNTCk7DQoNClNpZGUgdG9waWM6DQoNCkhtbSBJIHdpc2ggd2UgY2FuIGFsc28gbW92ZSB0
aGUgY29kZSB3aGljaCBwcm9ncmFtcyBQTUwgYnVmZmVyIGFuZCBpbmRleA0KdG8gVk1DUyBoZXJl
IHRvIG1ha2UgdGhlIGNvZGUgY2xlYXJlci4gIFNWTSBjYW4gZG8gdGhlIHNhbWUgdGhpbmcgSQ0K
YmVsaWV2ZS4NCg0KQnV0IHdlIGNhbiBkbyB0aGlzIHNlcGFyYXRlbHkgSSB0aGluaywgaWYgbmVl
ZGVkLg0KDQo+ICB9DQoNCg0KWy4uLl0NCg0KPiAgDQo+ICtzdGF0aWMgdm9pZCBrdm1fdmNwdV91
cGRhdGVfY3B1X2RpcnR5X2xvZ2dpbmcoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiArew0KPiAr
CWlmIChXQVJOX09OX09OQ0UoIWVuYWJsZV9wbWwpKQ0KPiArCQlyZXR1cm47DQoNCk5pdDogIA0K
DQpTaW5jZSBrdm1fbW11X3VwZGF0ZV9jcHVfZGlydHlfbG9nZ2luZygpIGNoZWNrcyBrdm0tDQo+
YXJjaC5jcHVfZGlydHlfbG9nX3NpemUgdG8gZGV0ZXJtaW5lIHdoZXRoZXIgUE1MIGlzIGVuYWJs
ZWQsIG1heWJlIGl0J3MNCmJldHRlciB0byBjaGVjayB2Y3B1LT5rdm0uYXJjaC5jcHVfZGlydHlf
bG9nX3NpemUgaGVyZSB0b28gdG8gbWFrZSB0aGVtDQpjb25zaXN0ZW50Lg0KDQpBbnl3YXksIHRo
ZSBpbnRlbnRpb24gb2YgdGhpcyBwYXRjaCBpcyBtb3ZpbmcgY29kZSBvdXQgb2YgVk1YIHRvIHg4
Niwgc28NCmlmIG5lZWRlZCwgcGVyaGFwcyB3ZSBjYW4gZG8gdGhlIGNoYW5nZSBpbiBhbm90aGVy
IHBhdGNoLg0KDQpCdHcsIG5vdyB3aXRoICdlbmFibGVfcG1sJyBhbHNvIGJlaW5nIG1vdmVkIHRv
IHg4NiBjb21tb24sIGJvdGgNCidlbmFibGVfcG1sJyBhbmQgJ2t2bS0+YXJjaC5jcHVfZGlydHlf
bG9nX3NpemUnIGNhbiBiZSB1c2VkIHRvIGRldGVybWluZQ0Kd2hldGhlciBLVk0gaGFzIGVuYWJs
ZWQgUE1MLiAgSXQncyBraW5kYSByZWR1bmRhbnQsIGJ1dCBJIGd1ZXNzIGl0J3MgZmluZS4NCg0K
PiArDQo+ICsJaWYgKGlzX2d1ZXN0X21vZGUodmNwdSkpIHsNCj4gKwkJdmNwdS0+YXJjaC51cGRh
dGVfY3B1X2RpcnR5X2xvZ2dpbmdfcGVuZGluZyA9IHRydWU7DQo+ICsJCXJldHVybjsNCj4gKwl9
DQo+ICsNCj4gKwkvKg0KPiArCSAqIE5vdGUsIG5yX21lbXNsb3RzX2RpcnR5X2xvZ2dpbmcgY2Fu
IGJlIGNoYW5nZWQgY29uY3VycmVudGx5IHdpdGggdGhpcw0KPiArCSAqIGNvZGUsIGJ1dCBpbiB0
aGF0IGNhc2UgYW5vdGhlciB1cGRhdGUgcmVxdWVzdCB3aWxsIGJlIG1hZGUgYW5kIHNvIHRoZQ0K
PiArCSAqIGd1ZXN0IHdpbGwgbmV2ZXIgcnVuIHdpdGggYSBzdGFsZSBQTUwgdmFsdWUuDQo+ICsJ
ICovDQo+ICsJa3ZtX3g4Nl9jYWxsKHVwZGF0ZV9jcHVfZGlydHlfbG9nZ2luZykodmNwdSwNCj4g
KwkJCWF0b21pY19yZWFkKCZ2Y3B1LT5rdm0tPm5yX21lbXNsb3RzX2RpcnR5X2xvZ2dpbmcpKTsN
Cj4gK30NCj4gKw0KPiAgLyoNCj4gICAqIENhbGxlZCB3aXRoaW4ga3ZtLT5zcmN1IHJlYWQgc2lk
ZS4NCj4gICAqIFJldHVybnMgMSB0byBsZXQgdmNwdV9ydW4oKSBjb250aW51ZSB0aGUgZ3Vlc3Qg
ZXhlY3V0aW9uIGxvb3Agd2l0aG91dA0KPiBAQCAtMTEyMjEsNyArMTEyNDEsNyBAQCBzdGF0aWMg
aW50IHZjcHVfZW50ZXJfZ3Vlc3Qoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiAgCQkJa3ZtX3g4
Nl9jYWxsKHJlY2FsY19pbnRlcmNlcHRzKSh2Y3B1KTsNCj4gIA0KPiAgCQlpZiAoa3ZtX2NoZWNr
X3JlcXVlc3QoS1ZNX1JFUV9VUERBVEVfQ1BVX0RJUlRZX0xPR0dJTkcsIHZjcHUpKQ0KPiAtCQkJ
a3ZtX3g4Nl9jYWxsKHVwZGF0ZV9jcHVfZGlydHlfbG9nZ2luZykodmNwdSk7DQo+ICsJCQlrdm1f
dmNwdV91cGRhdGVfY3B1X2RpcnR5X2xvZ2dpbmcodmNwdSk7DQo+ICANCj4gIAkJaWYgKGt2bV9j
aGVja19yZXF1ZXN0KEtWTV9SRVFfVVBEQVRFX1BST1RFQ1RFRF9HVUVTVF9TVEFURSwgdmNwdSkp
IHsNCj4gIAkJCWt2bV92Y3B1X3Jlc2V0KHZjcHUsIHRydWUpOw0K

