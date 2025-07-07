Return-Path: <kvm+bounces-51666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E9EEAFB363
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 14:37:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E8321678CD
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 12:37:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AD6529ACF6;
	Mon,  7 Jul 2025 12:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tu+Oqr6O"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAEF813635C;
	Mon,  7 Jul 2025 12:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751891833; cv=fail; b=Rr2ybf44gK9WpIZ19ZHL2VV2TGxFabBdEhvQFcYF0Bejk+bZ/KJTp2V5ziTBKSO8LnEFZxZYIaMh5niLhzm7swyMUptbA9Dwh4uW8AurUzZ8dMy81ihCXM3QjhbQN7n2jcYHEetZYyNjbdhqyajJQSFJfggMfFrtvSN/KQO+wes=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751891833; c=relaxed/simple;
	bh=WDmwCkkoF288fWzaD5QQY2QzKPDUlBLxReNWYNkD88g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=F7CA6ExWZ+SUtl4VosU2YoSYYBTGMOil4DwGmerurEZxjrZirbUATttD+NeJofcXZGjsdJc5nhLy6duu4MygF0+8qt+27tdXkNJwwzc3q9n3TGvXK3924PCxq0wKdKxlPNgZuvZ8FkdLs53TjTUqmt1Xj5peoDJUIqVgHlPx9+E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Tu+Oqr6O; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751891832; x=1783427832;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=WDmwCkkoF288fWzaD5QQY2QzKPDUlBLxReNWYNkD88g=;
  b=Tu+Oqr6OpZjenjqgGH1JBgNLo9ryx1A1C2Zb2r5NBBkxeQghUi1ZGOpm
   EwNpyciJcP6V9U9zFm+7UAXTAJPK7IAISlFxB9UgBJdCxWfZIXnc1h7GW
   1JtTd6Ec6Shz7zrlvPOBNja3xjEgEyazQtXuNCapBKXWD0hKiYON7FSZt
   bhCwHgzDHvhqGATNbLx1hUi0GLVcjD8BM+JEUGS62Rx3oyViuSrN6YHrB
   u5o5veBVriqibWQc/EcXAWn7+3e6Cj5ZuQL8nYxFEOOcqDp9ATGsqQb21
   ZxYKVIXq/E8uNnm2GLIZovT/SxqB1qxnVN7N5t8uKjCC2j7YIiZZcVnpA
   A==;
X-CSE-ConnectionGUID: bYMm+rSBQhKVGMj8ulOE1Q==
X-CSE-MsgGUID: vJ1j0GHaRCC6nuWYUKZtKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="53231607"
X-IronPort-AV: E=Sophos;i="6.16,294,1744095600"; 
   d="scan'208";a="53231607"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2025 05:37:11 -0700
X-CSE-ConnectionGUID: lxn89c4VQCmHkf562PF0WA==
X-CSE-MsgGUID: MvbxjWRmTqm5mr4tKolYwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,294,1744095600"; 
   d="scan'208";a="154629323"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2025 05:37:11 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 7 Jul 2025 05:37:10 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 7 Jul 2025 05:37:10 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.86)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 7 Jul 2025 05:37:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xpV35MDnU0A7fR8D3/HC5jfiep8cSluidqMzzwKA6tqWYq21xt45mZXgJRaecpcLDRXNAl0zHHkFh/cMufEoQFd6huNDY3Yy9YC65rWROx1DetxtbGs6OQmEBi33jyri6NjV9T+l87AbwzGMq4VgKjn5J4KI8kwmtEQFfasgi7H2IzPswIQ+OAKPvHOodsI55TAlofppY32CNnpvf08lp6B5hVWH0Zvb0pCGHG575s9R43CGtTCthJFI7lSBISEa62XtzETwgPIFKv+qPexh2QzBSJklHH6dz3C9gSDYMYwbzTeBqvWgqmub6dFlqkT49dVDfvtfzKBc6wwHX1rzzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WDmwCkkoF288fWzaD5QQY2QzKPDUlBLxReNWYNkD88g=;
 b=G53Eps4q/XRGSBb+jEBnI0/WSdS4wXeXbv3HMekHrDXX0B2TFsE+9bNTMBZtNC3xx46tdpVB98KCRHbfoi8DSbnm8kHtrVwCidj6Ulb2yJF6bjUHEQLkUMf7w+SH7+qyIgUhGrePzs9xqytaVKaEAu8ApXDJkQY6DkdRSsmvMUkxm7Gnug1cYFPpsmW8+CNK8vBH2nLDrFlsRjlOgRAb3ntgWkfcYOr/ETgpRW5HauCGrl7tyWj0NzW0te2nyzFU0Isn3mvp3SS/N+WNdZQijRtIKwBUKtRqfu3itv9/nXuZ8E8j1BiG3UKDlRHN04yy4b/3WARX9Invs2O/Y7HxCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CY8PR11MB7747.namprd11.prod.outlook.com (2603:10b6:930:91::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.22; Mon, 7 Jul
 2025 12:37:07 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8901.023; Mon, 7 Jul 2025
 12:37:06 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Gao, Chao" <chao.gao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "ashish.kalra@amd.com"
	<ashish.kalra@amd.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "sagis@google.com" <sagis@google.com>, "Chen, Farrah"
	<farrah.chen@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>, "Williams,
 Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v3 6/6] KVM: TDX: Explicitly do WBINVD upon reboot
 notifier
Thread-Topic: [PATCH v3 6/6] KVM: TDX: Explicitly do WBINVD upon reboot
 notifier
Thread-Index: AQHb5ob2sxTequ6YNU2TEnElo1JBELQegCmAgAgqdgA=
Date: Mon, 7 Jul 2025 12:37:06 +0000
Message-ID: <698057b46d1a95b693205288d768f896ec1b95bf.camel@intel.com>
References: <cover.1750934177.git.kai.huang@intel.com>
	 <6cc612331718a8bdaae9ee7071b6a360d71f2ab8.1750934177.git.kai.huang@intel.com>
	 <aGTl09wV1Kt6b0Hz@intel.com>
In-Reply-To: <aGTl09wV1Kt6b0Hz@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CY8PR11MB7747:EE_
x-ms-office365-filtering-correlation-id: d144826f-d37d-4a1c-da05-08ddbd52fc02
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?aWk5eUVxZEcvMlNJWHFiVWsrSDRWczF3RnVpM3JmTEdJUEpDdVFjNTU2UGtk?=
 =?utf-8?B?YUtVemJiR2dsZzNCb2lETUZnUjF6ODBSOWJTZnZqeHhNZVJFZi9YNzVSbzJM?=
 =?utf-8?B?Wnc3NVdDY0xuUTF2K2ViSDI2TTA3cFhnTGlqNHZwUGdqU3YyemJkanE5SnAr?=
 =?utf-8?B?UzdwaGFVOC9tSVlMR3ZGRUtJankzMGJXWUxRaERSd1creEl4ZmtETG10cmhT?=
 =?utf-8?B?OVdTRmY1WUlSVGhsWEZKcVZMYmszdjFheU9zMHUvc2lhUCszZm9VQ0l6UmxE?=
 =?utf-8?B?NmpKMDYxVjZISkc5bHNVOFBYaEJLR2t5Uzl4U1ZwWmxtY0s1a0x2SXZ6Q2FO?=
 =?utf-8?B?aERRY3FvVmlMdU55NHRnRk1hLzRZa1ZKVVNlWWtkaGo5Z3p5RnA0RWFzTk9a?=
 =?utf-8?B?OVI4S0dTZkkweDFYajJ3anNxUVFobHo5SmlsZTBLdkJuZTFGNVpZS1I1Uy93?=
 =?utf-8?B?c05ncjVNYmdpUzd2MHRqUEplQ1hLNlNhaDZFZ1VpUENkdzFkUFBnQWFtam5i?=
 =?utf-8?B?SDdrTVB5TmcxbktxQWtiL2FEZlBXRTRiTDVWVzk3bUN0K1RZMDVyYkVaRlA4?=
 =?utf-8?B?bG9Xbno2UXRad20vaDJRZitoN3lHL3dyTmMwc1B4TURuaWZvdXh4MVl6RGdT?=
 =?utf-8?B?KzFNM2JDeTcySUdFTVBKclpUVmNYcDQxYmNxTVd6Nkp0ajk4UGxVRjVZQjJZ?=
 =?utf-8?B?QnFPRktUUWhvK0Q1NE5WSFdMUXVnNERldTVobzAvbEpBUFNFYXBDNjFveHU5?=
 =?utf-8?B?QXRDSEJ5ZElseGxaZWhEM1BTbWV0ZzZEK1ZxTEtDTEo0Q3V6UXNvenl2cGI1?=
 =?utf-8?B?TjRJcllyU1RxZ3B3Q2JpNWMza3UrcGV1WExjaUxhbFRGUk5hQ1U1Y1QzOEtm?=
 =?utf-8?B?Kys2V1FFTFFNZllMaXE4djA5QzdmbWs4T1hqdWE2eUlnMHNLR25XczZFUm5v?=
 =?utf-8?B?c1UzMERiR3JjcUp2QTdPTWdnZStoRVF2aURwTnNBUG51cDN3d0swZ1FrbHpa?=
 =?utf-8?B?SVJQZUNueSs2cW9YRFJQenFtdkpqUDlPTGJMdG1NakNwNVZESEY2Um1SanVE?=
 =?utf-8?B?M0cvd0E1a2ZhMThVc1cvVFoxZE1TUGM0d2tsd2tYUlp5dW84Y0xIdGdCeUlK?=
 =?utf-8?B?dGRSUmpNSlU5eHBtUXBHUTI2eGRsd3pSd0RSSWJyWkwvKzdySENRSVYvb1lp?=
 =?utf-8?B?SHVwOUJhMEJ6M252R1J3QW80QmpjT1FhcmF6Z1Z0aU9XSUVEZ3hGNzAydkhn?=
 =?utf-8?B?WXp1K1ZTV0kzSE1uRXlGZnlOelpLTTdSWEx4QzFDTWhRQVBPQ0RRenNzOXgz?=
 =?utf-8?B?MTU4OWpIcVp2Qk1CTGtCOE5zdEZwTGhocXZRSDJqVElPSnZmTGZpaWw5Rmd0?=
 =?utf-8?B?cHBFOU1OaWlUUzZYMUMxUVhZV2krZEx1TXJFc2RKS0pZUFhtSnAwNTFLUlp6?=
 =?utf-8?B?UHRZNTFNNjlRZHJWMzl1Z2pETFNVNHVCbElJbXk2Nkw2SG1HTmpYSEZtZjNN?=
 =?utf-8?B?b1kwRllLQ1FmS3drQllTL0tNVUM3d1dKaTdwSmZSRTlIV3QxckFDSFZvOTVo?=
 =?utf-8?B?VUh0U00wei9rY2p4elo1UTdnb2NRZDlTVzdoOVJSNjFQaEV1c3ZBcktLTFpi?=
 =?utf-8?B?YXZ6bDZnRUxyTklKWkRPK2plQXZ0TTMyUGpzT3A4bW9VWjZaSnlNdHgvZVZq?=
 =?utf-8?B?ZnRWT3VqV3hOMUMzcHk0TlJ5MFI1MFJ3ZjRvaFptcnAxREloaDNHR3BUSllV?=
 =?utf-8?B?UktPL3BqNTVrajR1R3kyS0hRYk9NSmV1Yi9PdXFJak5hWGh1T1pwOXYvUjFK?=
 =?utf-8?B?YmY1QVlYbWN4bDlEa29HMyt4V1BpUG9Edm56dGNhZFpXQzdUWjNnQjl4VHVt?=
 =?utf-8?B?MkZ2TndIV1RJNkM5dnptRUVHY3ptKzdZOFlvUE9UQlE4ekVFNmFlVzZ4UWRu?=
 =?utf-8?B?bENNK2VmRTFzU2h6aHRzWnhkZDVwK3NaUXI3WDZrQ2VJKzFiWlBUaCtnZ2Zt?=
 =?utf-8?Q?Q9vuTe6N/ySiILPwshnvXv5ecb5c0I=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZEJQRURETDFBTWIyN0tWU1g1Qmx0SERtNGtNemJUcFM1L2ZESjBxMW13RlRk?=
 =?utf-8?B?ZGY4SGE5M0V6cE5TcmpvbVhQSXVNcFl0cHVDaDNGSXhRUmFwTkxzUDVWOVpu?=
 =?utf-8?B?TEdMZ0VuQjkxMURCY0I0MVZTaWhBRE5ZZW9vUEhzWGVnQlRoZGNpWmI3dGJS?=
 =?utf-8?B?V0o4UUptTVNDbFBtSUp6QWpZdnFkRnZ4RHM5aW02c1lpTFl4eTBNalpFQmwy?=
 =?utf-8?B?UlE5UHpMQVlzOWdyaHBpUkRTdVJDUmcwcEw5RFFudEl6NWx2SXA4TUVtWGE1?=
 =?utf-8?B?RlBadWw4bGMwbUsralFlU2RqZ0RHWmQvdkdFd05XZkZxTkhzUGlpSmkyOS9t?=
 =?utf-8?B?MzZjdjVqYmQvTWQ5dFgyVVpBZDkrUjFwSGlVTEFFT2x1bmZJd2YwNTNsanFY?=
 =?utf-8?B?SnRvS1FlZVZ2NmNKTXNidDZKU1h0OXhscGxLMTBVd1NoellvUERTaGpKOEZH?=
 =?utf-8?B?UjlkM3BOVUl1VnpJbFE3OEZkRTNka2RtSUxRVWFTaHBrODVOazBUeHZ3R1dE?=
 =?utf-8?B?NVREaFVsS0FkRkFtNFB3SjBYTkQrVjBxazIweVJxMit1V2hUTHJGdFN5SkJ5?=
 =?utf-8?B?aTBHSVdmVEx1WTduOE1RQ1llVCtSTWhJQjZGSlVxWG1NNlhEY1JKM0NnaUNR?=
 =?utf-8?B?Njh6RW9JN1NPM1V6MDVXbU9wSWJ1TTF1UW5LQzNqdDdZZktNeGY4bnZpZ1Fh?=
 =?utf-8?B?TmhTVzE1UUJPYlc5TzFsU3IvNUIvVnVicEVZc2xDZGYwaERBak9MVTNNcWZ5?=
 =?utf-8?B?Ny9TZERIRXlaT00rb1ZVZUFPVE9BVlEwbGZ2a3p6Nmh5bnFJOVM1VnBEWUlG?=
 =?utf-8?B?aWY1T0NZRXQySEVFZWc5N3VYZ2lsMDg5RnpBM2JGQmoxcWVybkpIWGZCaXl0?=
 =?utf-8?B?TTg0bURKendxeGUreFVlM3Z3RnRJN2E3RUxCWlArZ0dqNWo4WFBFaWVmUkYy?=
 =?utf-8?B?eTFscFVITGp4NjZmdlM3NHJSVjBmWVhnYWtVeHd6cFF4c3hMUXpMOThocVdZ?=
 =?utf-8?B?dUdiV3BFVWsxTDRjTnZrYzFPL2h4b09xRUdDdnhwNDdLOExlSnRIRWVUeUpY?=
 =?utf-8?B?eDYrOWxQNTYyTGJWNk9wZmlDdkpTeWhvOXRPT3I4TlNQNXphZ0RkMVdvUnlm?=
 =?utf-8?B?cGxwaG9kYmdpdVAxY3R2cTR2WmZVZ0N2MGZIb012bGlwSnAwVlNQc0xWaFBN?=
 =?utf-8?B?Y1dlU0pocVBSTU8zRE53NUkzaWtyUytUV2FKWW5iM3ljaUxOM2lMRE5adk1H?=
 =?utf-8?B?bnFtS2V1dG4xMGhJUmQxbEFqZnZwTXFOK1p1SmUzVDViYXVxakxyNFMyR0hN?=
 =?utf-8?B?VXM3RHgxWlBDb3NPSzB4dW5xT3R3T052c2liNEJ0cmxHWnE2S1dWYXQ3RzBp?=
 =?utf-8?B?YkpjZzNmUDc0NGxNZWtIckJsZkxsaTlERk5Fa3FmTWdQS29hUElXTmgvUWRj?=
 =?utf-8?B?TlFhQTJUVXBqdWpXZXhuT0V0TGpGUWV3RXVzWnE2YmpVYjVJVnZHZ3lOakNu?=
 =?utf-8?B?RVo2Z3k0UEx1cDBMTUdiTG1ab0o1Wmo2WXh1dXkwZ2lTWFNIM29kR2Y1OFJq?=
 =?utf-8?B?dENsS2FkQkRTS2QxVjNhU0hIeWcyb3VYb2FOU0ZDeVZoTkM0UmZRV29QVlIw?=
 =?utf-8?B?VWdFMkthU3dIdXl5aERhVnB5NElaVzA5Y3lwZGVRWVZrN2Z5eGZKemd0dVlm?=
 =?utf-8?B?cHZJZ0s4SmxVb1h0RmlGaW9QRnVLL2pQRkU0Z2E4RkdEUVk1QVpiSlNMamdp?=
 =?utf-8?B?bjlNWUtuc1FNelJMSVZBcUdNYmdKeVh0MW9VMWVSazZzeHgrOVNjL09QdUly?=
 =?utf-8?B?MURaS05xamFWSy82ek10NXdGaVRDaVNkQk10aXJOaVoxRWg5NmNPY2M3bVFM?=
 =?utf-8?B?Nk9Jdkd0Wjl6cWhtS2pWbW0xazdGWi82ckFuZG9kRTg2ODdKN2hMaVZuQXhw?=
 =?utf-8?B?ZkV4TTRNZTVtMWJkMzgvYlROcFBzdG5ySEYwdTNDcWdBMmVQZ0tzbmQxVHlS?=
 =?utf-8?B?Mkd4YU05eGtJRDBzUVFZcCthWkw0STl3WE1aeE94VnBCWkFTMGxKbXVsVG1W?=
 =?utf-8?B?Y09sRmZIcDNxenQwbG5nL2RFbkRIdjJYeUtiRHJEQmdpdlQ0TG52MU80U05K?=
 =?utf-8?Q?qpzbVCMm6i+87lEA/ywTHmxv5?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7A11298357B3414492B82387C8928A25@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d144826f-d37d-4a1c-da05-08ddbd52fc02
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2025 12:37:06.9360
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TLbHx6SAdvfznw+TiN2OjIgpJTCdxwHW4mQnZEkN/buAyH1eWyqiH9z2UN5SSkoesnx4AbcIZNTJI5PrwpIVrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7747
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA3LTAyIGF0IDE1OjU0ICswODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gSSB3
b25kZXIgd2h5IHdlIGRvbid0IHNpbXBseSBwZXJmb3JtIFdCSU5WRCBpbg0KPiB2dF9kaXNhYmxl
X3ZpcnR1YWxpemF0aW9uX2NwdSgpIGFmdGVyIFZNWE9GRiwgaS5lLiwNCj4gDQo+IGRpZmYgLS1n
aXQgYS9hcmNoL3g4Ni9rdm0vdm14L21haW4uYyBiL2FyY2gveDg2L2t2bS92bXgvbWFpbi5jDQo+
IGluZGV4IGQxZTAyZTU2N2I1Ny4uMWFkM2MyOGI4ZWZmIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4
Ni9rdm0vdm14L21haW4uYw0KPiArKysgYi9hcmNoL3g4Ni9rdm0vdm14L21haW4uYw0KPiBAQCAt
MTksNiArMTksOCBAQCBzdGF0aWMgdm9pZCB2dF9kaXNhYmxlX3ZpcnR1YWxpemF0aW9uX2NwdSh2
b2lkKQ0KPiAJaWYgKGVuYWJsZV90ZHgpDQo+IAkJdGR4X2Rpc2FibGVfdmlydHVhbGl6YXRpb25f
Y3B1KCk7DQo+IAl2bXhfZGlzYWJsZV92aXJ0dWFsaXphdGlvbl9jcHUoKTsNCj4gKwkvKiBFeHBs
YWluIHdoeSBXQklOVkQgaXMgbmVlZGVkICovDQo+ICsJaWYgKGVuYWJsZV90ZHgpDQo+ICsJCXdi
aW52ZCgpOw0KPiDCoH0NCj4gwqANCj4gwqBzdGF0aWMgX19pbml0IGludCB2dF9oYXJkd2FyZV9z
ZXR1cCh2b2lkKQ0KPiANCj4gSXQgY2FuIHNvbHZlIHRoZSBjYWNoZSBsaW5lIGFsaWFzaW5nIHBy
b2JsZW0gYW5kIGlzIG11Y2ggc2ltcGxlciB0aGFuDQo+IHBhdGNoZXMgMS0yIGFuZCA2Lg0KDQpB
ZnRlciBtb3JlIHRoaW5raW5nLCBJIHRoaW5rIHRoZSBwZXJjcHUgYm9vbGVhbiBpc24ndCBjb25m
bGljdGluZyB3aXRoDQp3aGF0IHlvdSBzdWdnZXN0ZWQgYWJvdmUuICBBcyBEYXZlIG1lbnRpb25l
ZCBoZXJlWypdLCBpdCBjYW4gaGVscCBjYXRjaA0Kd2JpbnZkKCkgYXQga2V4ZWMtaW5nIHRpbWUg
aWYgc29tZXRoaW5nIHNjcmV3ZWQgdXAgYXQgZWFybGllciB0aW1lOg0KDQogIC4uLg0KICBob3Bl
ZnVsbHkgYXQgcG9pbnQgYWZ0ZXIgeW91J3JlIHN1cmUgbm8gbW9yZSBURENBTExzIGFyZSBiZWlu
ZyBtYWRlLiBJZg0KICB5b3Ugc2NyZXcgaXQgdXAsIG5vIGJpZ2dpZTogdGhlIGtleGVjLXRpbWUg
b25lIHdpbGwgbWFrZSB1cCBmb3IgaXQsDQogIGV4cG9zaW5nIFREWCBzeXN0ZW1zIHRvIHRoZSBr
ZXhlYyB0aW1pbmcgYnVncy4gQnV0IGlmIHRoZSBvbl9lYWNoX2NwdSgpDQogIHRoaW5nIHdvcmtz
IGluIHRoZSBjb21tb24gY2FzZSwgeW91IGdldCBubyBhZGRpdGlvbmFsIGJ1ZyBleHBvc3VyZS4N
Cg0KQnR3LCB0aGUgcmVhc29uIHRoYXQgSSB3YW50ZWQgdG8gZG8gd2JpbnZkKCkgaW4gcmVib290
aW5nIG5vdGlmaWVyIGlzIGl0DQpzdWl0cyBhIGdvb2QgcGxhY2UgdG8gcmVzZXQgVERYIHByaXZh
dGUgbWVtb3J5IG1hbmFnZWQgYnkgS1ZNIG9uICJwYXJ0aWFsDQp3cml0ZSBtYWNoaW5lIGNoZWNr
IiBlcnJhdHVtIHBsYXRmb3JtcyAod2hpY2ggaXNuJ3QgaW5jbHVkZWQgaW4gdGhpcyBwYXRjaA0K
dGhvdWdoKS4gIFdlIG5lZWQgdG8gZmx1c2ggY2FjaGUgYmVmb3JlIHJlc2V0dGluZyBURFggcHJp
dmF0ZSBtZW1vcnkuDQoNClNvIHdoaWxlIGRvaW5nIHdiaW52ZCgpIGFmdGVyIHZteF9kaXNhYmxl
X3ZpcnR1YWxpemF0aW9uX2NwdSgpIHNvdW5kcw0KcHJvbWlzaW5nIGZvciBjYWNoZSBmbHVzaCwg
aXQgaXMgbm90IGlkZWFsIGZvciBoYW5kbGluZyBlcnJhdHVtLiAgVXNpbmcNCnJlYm9vdGluZyBu
b3RpZmllciBtYWtlcyBzdWNoIGNvZGUgc2VsZi1jb250YWluZWQgaW4gdGR4LmMgaW4gS1ZNLg0K
DQpbKl06DQpodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sLzMxZTE3YmM4LTJlOWUtNGU5My1h
OTEyLTNkNTQ4MjZlNTlkMEBpbnRlbC5jb20vDQo=

