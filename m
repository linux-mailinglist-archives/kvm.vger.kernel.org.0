Return-Path: <kvm+bounces-30256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A1729B855A
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 22:30:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9037A1F222A9
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 21:30:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 118681E283F;
	Thu, 31 Oct 2024 21:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BxY4VPl9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E32D15665E;
	Thu, 31 Oct 2024 21:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730410195; cv=fail; b=kLR6oqVsk8yYSEMrklB/arrlpk1C0sX4hGCSjjzw2nrYwV9zKgFWws1VO3nj+XHsuoe+mIa05naJTxVK+ZMo8pYbocJc+ttRnW7k8jAHIv/iZNns4FD1g60SyEGkY3CEzZ7Q78WgNiQdVuhLlQIAi3Evcf7xA5E+weXnep0Xv0c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730410195; c=relaxed/simple;
	bh=sjkuR69NjFe641MIlfh0zCubuetk3iCQSAVoQgnL4OM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UKl4nNZTVhlm3Ds5dUJFZF+zcoJRDPCcmxXbkLPU+eiyNRZepN/QITXbNDfcU6OPcOJWgq6FmggOiBxG/LWhNrZ/V7HlbLxBeLTJDPKUj42uZ84bruwoXYoLtaX09FF4bbp/NvTePHE80Zt56aBD72Nk5n5prQorvk450LQDBMc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BxY4VPl9; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730410189; x=1761946189;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=sjkuR69NjFe641MIlfh0zCubuetk3iCQSAVoQgnL4OM=;
  b=BxY4VPl9tFoEMO2Ah+urDQUUYnKqknDWqDXKkvtLCud+k1W+M9PF5ju1
   otqxp8qZmfEpslhEstuUonDgIpg2tfnglvWSeuHktQmcH7XPgRyR0oDwO
   SE8RItA2s7AwzZ0TYJX6GJKE8izKOF6DibdCkHU+rwot9OOoPR1p+8r1k
   aO/Ebw7H1SAWu0zIKn8xQj1a8gSFkktenZgyEpDzhHo7wKbTXrBDpt8Xb
   ReInon4I+HRkKvzudzC84YMsZnBq4QB6b2HexunQ+sYSA242B8+fVSUwL
   OLVhhT5I9bp+eOeZF7MGeSzkIK7hr0keuZvVo08TOySkcZi/Ikco+y2pc
   g==;
X-CSE-ConnectionGUID: mKwnN9b/QbOjTqf6x6lmEQ==
X-CSE-MsgGUID: ODhKIyxzSbKQKR6XaB3Yqg==
X-IronPort-AV: E=McAfee;i="6700,10204,11242"; a="47651284"
X-IronPort-AV: E=Sophos;i="6.11,247,1725346800"; 
   d="scan'208";a="47651284"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 14:29:49 -0700
X-CSE-ConnectionGUID: Ma/bxOf5R0SYUEjBbOeAHA==
X-CSE-MsgGUID: 1lPTYJpxSM2A+BxBfjdY5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,247,1725346800"; 
   d="scan'208";a="82288680"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 Oct 2024 14:29:48 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 31 Oct 2024 14:29:48 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 31 Oct 2024 14:29:48 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 31 Oct 2024 14:29:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U0fXi0dyBh9V9Gw/bPagG579a6egzk+L1UmIhBXExXJagACUVtTrwwubkny06bjW5zfWg7nkHOaZCWb4KTrkvq8kVCzMo3swmtDVbZrQNZrNTvnhnvk6lZ6rtrEyZK+Hiy9FKKIn0odz/Ade7qN3A+K5xsMqdHU5TzIe8K5dmvds6bAWlWWGo40HnPYUST4fHk6KU812VqHKNMa0FfJeLGYkRb3B03mvOxBjM8jRSQeuqOrKKhk4Kbt0aPXd6VyQwE0ARPiQN8OJ9iw5K3poeRwUeTmoB7DuVOV4YAB94rr0P1w3kU9HAUeTCeao42WnFM6Bu1wmHg39ekrOQ/Dniw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sjkuR69NjFe641MIlfh0zCubuetk3iCQSAVoQgnL4OM=;
 b=ZXyOrbqOYhqVgcLyEUt7PG3+45ik6MmoSBs71UDO5gXd7jda/ZZOMVafHISxFkjoN7B2+IB0n2UvVOPib5DOi5o+qUbFaOpQdwMxThSUpHmFG85ccaKWtrvtmqSr2dxHw6mfhXmN6EGIiDeJwKdTdlqSSWGxsBj1xQh1HuscZ+P42erVxQj25cQ0fbmgQQRES56vjSGEYh5qyZPG8/WNptv1Nex1m4ZgZX7NqGMRi+w3jx+qaH/5iCB6caXmCGv5jUtbiKtCd967A3QT/Yc67MEzmlnE8oy9KJ+ns2hkWQ0D2TsD8Dls7Glx09DPEJSuDwraU3QfWbTAPCp22v495w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BL3PR11MB6508.namprd11.prod.outlook.com (2603:10b6:208:38f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.23; Thu, 31 Oct
 2024 21:29:43 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8093.027; Thu, 31 Oct 2024
 21:29:43 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Lindgren, Tony" <tony.lindgren@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kristen@linux.intel.com"
	<kristen@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 3/3] KVM: VMX: Initialize TDX during KVM module load
Thread-Topic: [PATCH 3/3] KVM: VMX: Initialize TDX during KVM module load
Thread-Index: AQHbKTw/WuuSVUZ27UaZWQ3Th9tij7Kfa8kAgAFOmQCAAJhjgIAAEH0AgAACRAA=
Date: Thu, 31 Oct 2024 21:29:43 +0000
Message-ID: <28d1c75da965c53b9162521477af5a966967125c.camel@intel.com>
References: <cover.1730120881.git.kai.huang@intel.com>
	 <f7394b88a22e52774f23854950d45c1bfeafe42c.1730120881.git.kai.huang@intel.com>
	 <ZyJOiPQnBz31qLZ7@google.com>
	 <46ea74bcd8eebe241a143e9280c65ca33cb8dcce.camel@intel.com>
	 <ZyPnC3K9hjjKAWCM@google.com>
	 <2f56b5c7-f722-450b-9da8-1362700b77ef@intel.com>
In-Reply-To: <2f56b5c7-f722-450b-9da8-1362700b77ef@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BL3PR11MB6508:EE_
x-ms-office365-filtering-correlation-id: f3aadbd9-cc5e-4d91-111c-08dcf9f322aa
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UTNUSUxNY0xaSyswVjNlTHg5dytIKzJQYnZ1MHBCaU1YR0ZoV3BueXJVT2lp?=
 =?utf-8?B?OWRRWjFERW8rcVVKSExnbTlwVnQ3ZWJ4dWdRMzAvY2ZmdDk0aXRtaldBYVVo?=
 =?utf-8?B?Ym1VVFJxQ1pHNGt6VWNBa2xReDNWYjNKUmxPWHhPMG9peVZJUFBucEFlc0VB?=
 =?utf-8?B?WjlSZ0xxNDNPa3BWWjlHZ3RSMkJXYTA4WkVKaWxybmpLdXgyandJRUpKQ2x1?=
 =?utf-8?B?dFhoRUYyQ0R4S09uaEZUZDViaXhGbEpJbENJQWptUFFScXVGZ3BKZkxSa1FR?=
 =?utf-8?B?Y3NDN1RQKzZGaERpQnlQZ1Rhc295NlpGeGFqQ3JBNk1qbFBiZktrM2t1eEZX?=
 =?utf-8?B?SlZ3Ykp0WEhza1JKSWFqaU5WemYxT0FUL1Y1T2lsQUdNcFlCcFMvNENSdHEv?=
 =?utf-8?B?M1IwYW12VWdqWitmYmZGTEdxZm5sT1ZPNFNEUG9NVk1pSEROSjBjcm1TR3pl?=
 =?utf-8?B?VnVac2tBYVFucTJTdkVIaktKSE9OU01talZhVDZ3ckI4czRtc2tGdFQrNm5h?=
 =?utf-8?B?YTNCcjlCS1lUaFBBVGpmbU4vTVd6M3lscGNTL1hwT2ZvQUdqTGFHdkVzd2xV?=
 =?utf-8?B?OFVGODk1OWlVc01BRmxPZUxzTGJMamhCMVVzQkFCSHVEV1Rmd1FxU1VJRU9Y?=
 =?utf-8?B?cENENVZKenJiSWpDcFFQYWdQS2t2YVpGVDdPbHJoWEpUVmptdGw5QXN4dExh?=
 =?utf-8?B?NTZqTkxvVU0xV3hhakRpMlJndDg2MjNiU3ZuK3c1OHpKR0I3eFIvNk5vNXNp?=
 =?utf-8?B?V2FOZm56T1FjWWNVZ2p6UEs5UXlvODBaMVJEZWVnaVI2ZnBTb0F1NFJpS3JE?=
 =?utf-8?B?TFFLT1hkM3EzOHFtbnNwQnZ5SjdJVUthM2EzblYwQkpzeHNNcWpDRzRrai9a?=
 =?utf-8?B?ajV4U0w3Q2cvc3lIU2VlUFdOTkM3UlFoTjd5OXN0bFhIUStmU3JzRjIvZ2N1?=
 =?utf-8?B?RWpiYUNmUzdaNTBnSDdQSXp6aUZpZXVOL0FKVEVTeXZjSXoxeUVFRldpVERi?=
 =?utf-8?B?amJPZnpFYk42Q09VNTU4ZHZ2M2U3dUtyc3NTNzRRZ3ZHOGt2UDRlakNiaEdK?=
 =?utf-8?B?UjB0eWJKVEtqSWp1TUF1Y2ZGREVhVjFmRUlqUHliTzhydkJjWjM3VFJxRjlY?=
 =?utf-8?B?bHE0cVZleDcxcjlGVCtGWFBqR0lMYlNZUEpIalAyTmxMQ20zY2NPU1ZIUXRM?=
 =?utf-8?B?UFFQTGRXSGxzTjc0Wm5CTTNCL25mSGY0eTFBY2Z4N0VzME1sTjdKdHgrcVRW?=
 =?utf-8?B?S01rMTBUYndMajl4NkJzd0l0TjRkSmVNbUI0NU9HcUhZaDQ1cXpwTlVwa1Rh?=
 =?utf-8?B?TUMreHFJclJWeE5RWHpCQVl3cHlLVHI1WHNpZ2NWeTdwZDZySkF4Z0tJZXlC?=
 =?utf-8?B?SmxHaHBtbU9UUzBhYlpmRitNM2NwZTh4VnpibVJ3eWQ4Tkt6NUNsRkxkVXkr?=
 =?utf-8?B?ZW9uZm1PVVBjWi83RHhQaW05Ni9TdU1iNHBma1BwZTNTb1hjY0ZHN1B3MHF6?=
 =?utf-8?B?R3pNb3dLQWVDQU5GN2VvMVBFb2I1bmZST3hXa1FnbWEwM3hBWFpoM1dSemFE?=
 =?utf-8?B?TkM3MFowamhpbTIwaVVGaGhVK3NwVWFyVTBOTFk4NSs5MkNkQVNEWXljY3Yz?=
 =?utf-8?B?cUhPelpHd2d6cStqekQ2SXNVQ0tLZUNtbkNjWEF0eStvdUtsSkcxZ25ER0hn?=
 =?utf-8?B?Vm95emRNdHlHUzhqNElNaFQ5U2tWZVExcGxPM2l4NDE0bFdENE1Kamo2ZFpt?=
 =?utf-8?B?QXhiVnM0emRKSkxUZkwwNVI1S1J2ckI1K3NDbTgrTUV0U214NHhPZ1BCR1pq?=
 =?utf-8?Q?ntBHzLY1J5fdyyF4jVma0904fSYz9kbhSj+mQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K0QxYVphWUJ6K2w5YUprYWl0S21YTE1XU25tRGJ1QU9vVXpYcFZNNTluY0Nl?=
 =?utf-8?B?dGJxaTZrL1kzcjB4dzlwUkVRWEVIRU5rT2J5Mi9xRDN2aHhVVHI3VWdOb0h4?=
 =?utf-8?B?WThPUG1lQWxpRHdSeHRYMlAxNmJiblk0L01NenQvRHE1OFF4NjZLeTY0eVZ3?=
 =?utf-8?B?WVN4TE54T3NFcHhDakxTR0FEOWNxcjU4cGF6YW93U1pyNTM5VGtOdUcvSERU?=
 =?utf-8?B?UmYzZTJnMzJ1MTY1VmUwV29mTFNvSlhEaUkyU3BVMlhSdmVXS1lBTktFMjcy?=
 =?utf-8?B?T0w3RzdFbFg2Y2pTYnorR1NmUFdsUjZkcHZrbDV1VlhzeFZmVit3MTNLNlJj?=
 =?utf-8?B?V3ZReklkYW94VmlQbFBrcVR3RWI4WnNZL0Rrd0pWQ05EQUVNWVV5YkNHTmRm?=
 =?utf-8?B?RDBHQmxKNnRyRnhPVVg3b2J2RUE0K2R4UldUZW9qT3BJVEZqaUxRa3hnWEVU?=
 =?utf-8?B?ZC95WDhiTFFXN0lyQlVZTmsxdU9ZTXUxOVdzRHN4ZjJFUUU5TDhMSHR5QmRN?=
 =?utf-8?B?ZzRXdktUZFJKTnMvdCt2S3dVeVJQTnE3L0ZkblhuVXlDL3I0SkhRZXN6Vmln?=
 =?utf-8?B?S2twMlFlOFdmUUViZkkxRFFnTWxwK3J3RUx0SndsemlYMkM2aFpta002bWRo?=
 =?utf-8?B?VzdWQUtBLzljcG96TVE3UjBxVEduZnRSTUpITGtlcVA4K1dNUWdCQkg5RlNu?=
 =?utf-8?B?TkZEeGZKYUhva3dOZ25BbThVKzEyY09iQ2ZtQzBLZDFiZG1MTVNLbGtKNCsz?=
 =?utf-8?B?TS9BTEI4QXJnMG9HOFphZ0Ftczh2RTNva3hGSVpCOHk2b21QVkJQTCt3QUVS?=
 =?utf-8?B?OEFDU2ZGdGVyQXNqUzVvcGE0RWVpeGhtSm1oTHFBWU10VGNmcGs5aEtPVVhJ?=
 =?utf-8?B?RnpmM0xaU1pxNWhWKzFJVm1rTWN6N3dhUnJCMlpyWm0wemFhaFA1dWRlZHJ4?=
 =?utf-8?B?RmZGYXRrOVpZUGcwa1hiNXBEZHpHUElpTnM1N0JnK1lzYTh1a2RUL0p2eVJ6?=
 =?utf-8?B?eWJFSmhHWE1CWHV2WFpOUFY0K1BiOWZCa2s5aEhIamFpQ3dVeUlzd2JKdFRY?=
 =?utf-8?B?U0VkTllack5ubEtpTkRTT2FRY25lVXZsYStyZVhDWHNNNVZSRE5XajRiSyta?=
 =?utf-8?B?R2Rtdk15OVZWTlg4eHc5ckdTMXgxZytmZThXNmJxQjBXSFIwWnE1TEFzS3k0?=
 =?utf-8?B?azRoM3hteDFaRG9RMDl3b0JiQU4zRjZvaHYxQThQS0dha21TVDBOYmpWaDZn?=
 =?utf-8?B?L0VHR3FRQjI3QTlqUTFnZmswSS8vV1plTW1GZFptZTNaUitvUTBiV3BMZ2o1?=
 =?utf-8?B?YzA3M1BUekw2QWNSdnFwQUVyM0xDazI0ZjdOWnhIaU5aK1luWVE0VFBVbDEv?=
 =?utf-8?B?dXZSZUlxTk5ZRUlMcUhGWnFZRGtvMUFSMU1Makg3amxpcU5kNEp0aHZHZE1P?=
 =?utf-8?B?Q3ZZSnRwcGZLRmZXVGkxalZMQ254THBXRFlyTDAyWjR1cHdrNnVrSTdvMXVR?=
 =?utf-8?B?amowZzBGMkFHZW14U2xOV212VzBOVXJ4d1VESURsbXB4QTBTRUNvaXZOcy9n?=
 =?utf-8?B?TUh6czlhS3lUTEczZ0Q1VWlKYnNzZnN1MXBoZnNReEVRWktrOGJiWGlxT25Q?=
 =?utf-8?B?TFhaZmw0OS9rcEYrVzdlRWtLRlJoTm14c2NLcUJNRnMyNDJzWU0yS09Zc1ho?=
 =?utf-8?B?T2lVM3AzUHJPaUFNQXFrV051UTJ3UiticERDaXNGeXpyLzduWkF6bUZMbUxT?=
 =?utf-8?B?ejhKOGxsTGpGcURVTjA4NkIvMzVEZ2w2aUxhUmI3MUptYmw1UUtmcUxSZENI?=
 =?utf-8?B?V1c4VTZwQVZmWVRuZDRhaURsUW9GbnhOM3g2cnpJb3RVdlFaaHp0cEhhaHNY?=
 =?utf-8?B?eGNwV1BEU3JxTDJrcFB2V0V4WFNNQkV5WWgvNVJKZmYxRnM2ck95RE84dXdo?=
 =?utf-8?B?a3VxOUdkbjNHOUVTdlV1SDgrcmtJZDFlaml2ZTViYnc4V0VWSTVxSUMyQjNV?=
 =?utf-8?B?YnZTL1FwTjBpaWk3VE90Y3pxMUV2QmlFNjhLNndmYVlQRWxFVWh2V3lxcCtT?=
 =?utf-8?B?eWhVSmpuaWJPTTFtYWR2cUdnRHBvYnl6dmlzY080Tk1PK3ByOGNvUjlySUVu?=
 =?utf-8?B?ZXl3STJ5ZFNsU2tUUXExRFN1TUM2Q3VaTW1pTDhKdy9lZFN2Z0NBVDIxaDYy?=
 =?utf-8?B?dWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <05E47AC58073384F9843398AEDAD066B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3aadbd9-cc5e-4d91-111c-08dcf9f322aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2024 21:29:43.3346
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XCH8Eq77KI2WVkQvxKLO8v80rifMJKN29u4zpdVER3huk/aSwiKxuQdQHki/2lfCV3XaHrfTju4mfaJzJBmcxFoSEUEEDb0GXYuNMlJaOzs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6508
X-OriginatorOrg: intel.com

UGFvbG8sDQoNCk9uIEZyaSwgMjAyNC0xMS0wMSBhdCAxMDoyMSArMTMwMCwgSHVhbmcsIEthaSB3
cm90ZToNCj4gPiANCj4gPiBJIHdvdWxkIHByZWZlciB0aGUgbG9naWMgdG8gYmU6IHJlamVjdCBs
b2FkaW5nIGt2bS1pbnRlbC5rbyBpZiBhbiBvcGVyYXRpb24NCj4gPiB0aGF0DQo+ID4gd291bGQg
bm9ybWFsbHkgc3VjY2VlZCwgZmFpbHMuDQo+IA0KPiBPSyB3aWxsIGNoYW5nZSB0byB3aGF0IHlv
dSBzdWdnZXN0ZWQuwqAgSSdsbCBuZWVkIHRvIHRha2UgYSBkZWVwZXIgbG9vayANCj4gdGhvdWdo
IHNpbmNlIGxhdGVyIHBhdGNoZXMgd2lsbCBhZGQgbW9yZSBjaGVja3MuDQo+IA0KPiBUaGFua3Mg
Zm9yIHRoZSBjb21tZW50cyENCg0KV2UgaGFkIHRhbGtlZCBhYm91dCB5b3UgdGFraW5nIHRoaXMg
c2VyaWVzIG92ZXIsIHVuZGVyIHRoZSBhc3N1bXB0aW9uIHRoYXQgaXQNCndhcyBtb3N0bHkgc2V0
dGxlZC4gV291bGQgaXQgaGVscCBmb3IgdXMgdG8gc3BpbiBhbm90aGVyIGJyYW5jaCB3aXRoIHRo
ZXNlDQpjaGFuZ2VzPw0K

