Return-Path: <kvm+bounces-15780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38C348B075E
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 12:31:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 57CCA1C221AD
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 10:30:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06424142E6D;
	Wed, 24 Apr 2024 10:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VPLissl7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638B541C63;
	Wed, 24 Apr 2024 10:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713954651; cv=fail; b=l/ZskfUVcscjtt4rfzMYIjAFzsDm/+Cgq6VINL8AOZaSWY2M1G5SwQ+gfCTT2TKa8CWm26AvHStRmr3QaExojs0vMwTorPonmQAd65POLiQqHclzvEzVp4EiVR1JMCfy1RgOCDToi3JHpFKZoNCBuKhP7emRnDq6gHKJq1ndpQg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713954651; c=relaxed/simple;
	bh=sJRnhjhY4wLwzuGbU4Hp0Vu0QSdzOXBKdomWJM+8wmw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SIfipYc1DI39WTKHIskdflSo8E7CBTXpa7fvoI4bo/orKhESQw53MBabuRPPOGK5yyuNCDQ2OJ/wcu4EwWS/tHVU+Sx8IPS03Ob+KPBnx+ZDV0jLmEi1NIOr9/57l4Ub/OhbVyMIPlKum3mpmzupyaRBhQ9idmV6E1O45/MHMw0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VPLissl7; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713954649; x=1745490649;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=sJRnhjhY4wLwzuGbU4Hp0Vu0QSdzOXBKdomWJM+8wmw=;
  b=VPLissl7X00gT/SlXxu5StCSOwA3NE+oXm70uFl+fNxEStyh+MbstUxB
   U6hYQgru8+nZFBtX1IlazciZHcHe5PxRXdFuNdGWOR+zIdlxZlfWGu+Z6
   4rWCRGnMdZOM0g8P1xL5l+Sdah1vI4Qymx2je5FRxhjdFCx9xv2W73EVV
   lW9tRmEwW35PSyiNdIPl66ABeCyPDpA4iKgjjehtx/qeRjaElD2DYwMI8
   BWRXlivEkLlbX8c7xn0Qba+juzkUvgSS7qcsEbi7mvdMGfvPJ0k7W8tyU
   C2JjGUukdg4dK3lbmGqkilU+KkbvqCV7KLU93CXLcxlH8r73bEcwNvppm
   w==;
X-CSE-ConnectionGUID: b1Kk3ioGQWW+OyiqRlXMwA==
X-CSE-MsgGUID: 7UKvBA7vQ42nE1KJmQ7Ueg==
X-IronPort-AV: E=McAfee;i="6600,9927,11053"; a="9449525"
X-IronPort-AV: E=Sophos;i="6.07,225,1708416000"; 
   d="scan'208";a="9449525"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 03:30:49 -0700
X-CSE-ConnectionGUID: qBkVJ0fMTUSr46FXl/QvmQ==
X-CSE-MsgGUID: As+8L5d/Q3a2Ym91xY3GoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,225,1708416000"; 
   d="scan'208";a="55627989"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Apr 2024 03:30:49 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 24 Apr 2024 03:30:48 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 24 Apr 2024 03:30:48 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 24 Apr 2024 03:30:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EG9fk6Y0ghTPs77oqyQk3Fm/hAEO/gR8o46xu/Z+MDwIIs+xHcP+uaeIV0BZVUPHdHatWqkiv7H52LRpZuTXhUqN8G85GyhsbC/GUL/jRWB5WcmD8xbn6r55TUwvzbwSmRzagJhmM2FjsYdhlnidFjOcQILm9dyjWM7UMwvXqvGK214DzKLGgRUwtsuvrLgrMqz2n8M3Qqx1AhVc1Ba+SXSgxV8QHmWbMseIxxiy/ei3u481I7GqC4Hu5neIA7sdfjf36frX+NKpSkUFgxqkgFh/B3JM2K7KVjy8kTH2V3YwlEpaTrZ+eM+aFiutB7Vfc4adXzA4KnSTzskI84+XGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sJRnhjhY4wLwzuGbU4Hp0Vu0QSdzOXBKdomWJM+8wmw=;
 b=IXTD0gUtpjtSXAgnNTKLkxLzAMMCNKFg4ndhJv+aTrbuMykRjWrdOkM4JmhzFvPWuNNmsY9ZrzQnCdw5xE+x89ymRV1QkjeqA2IjpCXtscf979wMJmu+ukYSqy6bl5H9tyvoSPucJGlHQkRQyvFBxfXwD6xAog+sbzOS0pNp+2ykuTF2ov3b53bnErTNUEDA38ygqYplkqZeq+Yb1Of+MJosdpwujbdF9iNv0yEXZIf6LvMt+1fZWlfwn1523Kb17fJVUBqNHRBsTx6WjmFtb5VRDMSZnw1rbxGCWibXtuFf+HIDx3zuUNo0jUFSJb16QlJqarp7lmLs5TNOSSEADA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA2PR11MB4988.namprd11.prod.outlook.com (2603:10b6:806:f8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.19; Wed, 24 Apr
 2024 10:30:46 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7519.021; Wed, 24 Apr 2024
 10:30:45 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Chen, Bo2"
	<chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Aktas, Erdem"
	<erdemaktas@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v19 036/130] KVM: TDX: x86: Add ioctl to get TDX
 systemwide parameters
Thread-Topic: [PATCH v19 036/130] KVM: TDX: x86: Add ioctl to get TDX
 systemwide parameters
Thread-Index: AQHaaI28fnAWALyPokyd56S1TO7BZbF3k84A
Date: Wed, 24 Apr 2024 10:30:45 +0000
Message-ID: <72a718244456db291fc3bb243fcbafcb03f854e7.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <167f8f7e9b19154d30c7fe8f733f947592eb244c.1708933498.git.isaku.yamahata@intel.com>
In-Reply-To: <167f8f7e9b19154d30c7fe8f733f947592eb244c.1708933498.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA2PR11MB4988:EE_
x-ms-office365-filtering-correlation-id: 235470c2-c9fa-4ac1-b24e-08dc64499a03
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?THluYnpkOG8yRlB2Z3hDd3RqYklzTWJodEx6bVk3aVpLb25xZTYzc2VjUDAx?=
 =?utf-8?B?STRINXlKQU5RMzd6NGhjNEgxL2ZCOWdjSVpHTFc4WTVIbDhDazc3K3pBUnU5?=
 =?utf-8?B?Qm1FcFN2aTNEdFEwMG95SmVIVnU0UU1MUkFkNmpLV1ljZDVlK0IxUXdnL05J?=
 =?utf-8?B?djJwaFkxMysrU2xVcXhZeDZoQjR4YklvcFRqN3h3VGtYS0JDSGNQeUt4WCtQ?=
 =?utf-8?B?OUwvd0RLblhuNkFRSHo3bmJOaGVqVUllUWc4ekgwS0hSaEEvME9WTEF3UHd0?=
 =?utf-8?B?dUMzdmZXV0R2bU9OV1NjSlJFY29YZmtONDkyWXVWUXk1SUxBL0lYZi9xN3Iv?=
 =?utf-8?B?azJNZmJFQ2dMTTNLY21CQmVpR2ZzMG9yS2Q0QlBKMDQyYVVzUU9qdXBqWUh3?=
 =?utf-8?B?Wm1acmtwdnNjSW4wN3JuK1gyWlBrVTdZWFF5Z2tHSC9ZWWtOOWcxeGZ5eFl2?=
 =?utf-8?B?ZUlNT1EralR4bC9Gb3UyREFJZWhENmlvL2Q0YURmb3NrYWNHTy85QTV4czR6?=
 =?utf-8?B?aEFFazVBd2Y0YkJrWkszbjFSQ3ZwYy9oS1RpT0psY3A4U0owSFprM1ZxdFl1?=
 =?utf-8?B?cGVBU2Y0RWdRQVVFa25MbmpxdFpnem5OZnZEc3JpdWROZjFiWHNzSUVwa2Jx?=
 =?utf-8?B?WmJ5WisxMDlDQ1VYUlZlaXpoVXAyWStxZTRyQzhhNlVNVVJzT0hyODczS3dG?=
 =?utf-8?B?U2hnSTkzZkNDREl3QnMvK1YrcE9yMUZsM1pGdFZVeDd1aUJlQjRrTnM1Z1oy?=
 =?utf-8?B?d2lRVUlDbndsbWlmdzdwelRaeXdQTGlBYkN3Qk9RTnZOeWZKdnVmQ3BKRWN6?=
 =?utf-8?B?RW9TYVhhY1NGZEYvYXpnTmZML1hFR2wrZ3hQOGxydUFiSzBvWjJzbjh2RlBO?=
 =?utf-8?B?NUJieU81eWY2cUtObldzak1JSzNHbGg5eFNiOEpMcENkQVNGY2FyN3luOUlC?=
 =?utf-8?B?b2hEVHc4U2RqSldkMklSbEN6Um9vL21MZnpmK2dqTm01QWoxc1VudW52djA5?=
 =?utf-8?B?UEtKNEJFNEN4azVXNHF0cVgrOTdhQVhRbndVd3FSeHBtM1NrV2lPdGJlM3BN?=
 =?utf-8?B?STM1L3RhcGN6dCtTQkE1OC8vUlA4QmpKeHd4aVJCQlV1c1ZtOHJkSTVXZ0R3?=
 =?utf-8?B?MHVLWUsrL1JpVklidXE2NmxWQWZoSFJNNndmV1JyNkp3YVR6UjNabXhIQlVN?=
 =?utf-8?B?c0QrMTNuL2VoeFBoQTltbGgvTmIyalNxck5TY1RzWU9RMExVaE5MUjAveE1Z?=
 =?utf-8?B?K3pHVksxc2VyY1RaVlVtZ0dCVVV5ZzV0UmxrRG9IZE9nMnhsdDlmNldxY2ZE?=
 =?utf-8?B?bGpqY2NBWnhjcWVSc2hsczVqbjFJdVhWeTRNZUNFS2c3ekxsYjZYM0JZcGYr?=
 =?utf-8?B?d0lWdEcxcWg3dGdHRXRHVXVYQ2VrVDczM3J5VVgrTUVVK2ZPaDhtYm5kc2JJ?=
 =?utf-8?B?UitLSkJmbHRuMllqTERRR3VRZ25FM051WmtQeTRNZGtHYm94UVRQUm1Db3V6?=
 =?utf-8?B?NDh2cHdqcS9ZS1F1dW1HRG8wa2tMVjlHcWRTMGljcWxQSitXaVFhYStNeFFp?=
 =?utf-8?B?VTREYU9MaWNaZUFSZ29RYjVjTlFuVDlmVUJ3MlV3ekRqdG9aOGgxUW4yZWly?=
 =?utf-8?B?NHBaQWpPTmN0TUc1VGZGb2R4L25yZFRYVTVwUjFhWUtOWDhEbjJ3RnphK0hN?=
 =?utf-8?B?T2U0RmhoUURtVVZFMHBuaHJVUGJQSVlCVGY5aTJuMHRiaHVJZ0dSNFdieUJ5?=
 =?utf-8?B?Z3VjV2FuN3pqWHVFQnBuTUdPNDVqTi9NdE10OG1kQytKcEd4cVhkZmc2Q3lI?=
 =?utf-8?B?ZEo1RFJtblVRNGNhT2JQQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T3R2aG45anM3NHFEQlhQeDRucktvMUsvNGxzcmtRNElXVGxNQTh0V1NVbURy?=
 =?utf-8?B?cEhPdjlrWFVyNWMyMVp2RVlQZFhNdjhlOS9kSW5TMnA0dTVrV3J2YnkzSkxs?=
 =?utf-8?B?Mm1qRDVJMHg4NmRFL25SY29VWWw0Vzc5RHA1dGwwbnNDai82SkNGcEVQbkRj?=
 =?utf-8?B?cDM5NmRCR3Y5b2pTaDEyWTJKVVhkOENleUNyazFFL2tIWjJMMTdzZTFqbXhI?=
 =?utf-8?B?VW5uNDhnY1hiM3FmM2NhNk5kSGZvM0J0bkpWTk85RUhyNGoyUEpueWhHRFl2?=
 =?utf-8?B?dk5pbFBrRGFxdmtuZmI4KzFIayt6Mjh6VnRQVDlENm1pbWcxaDFqWE92ODA3?=
 =?utf-8?B?M2dKbFg0aTltcXU0TTVxa25Yc3VRTkVoVHRmeDdhTUdNVWI4MDJnbFZ4ZVBC?=
 =?utf-8?B?TGdSRzcvaGJxc09xNVZCaFB4cjB0TlZhZ3JUMnZRenp0K2hHT1dWS3h3OGx6?=
 =?utf-8?B?RkkyQU5NZ2hyaHFiK2xncmt2M21kTWp4dXJmQmdtOTZpMTVUQTQ5cGV4aUph?=
 =?utf-8?B?UWVibXdMTWR2TnpIVmMwYS8xYUd3RkkrRVhOT3dNVHFIMjVmTVdDbUR5VVRk?=
 =?utf-8?B?bkR2b1dLQXJUV2d0WGRid2t6YXd6N0czMWs2QjdmdDdRcjR0emYrV1FaeDZp?=
 =?utf-8?B?YVZkSVFxN0lKdkNxeE13cTgyZDZCcjA1M1Qrc05mWlA1cmpNV0pCMVpBc0Jm?=
 =?utf-8?B?eFMzd2J0R1pvZDNPOFFBVTRXazJyUjZwT2xvNEgyRnJMa3J6aSsreVB6bWZI?=
 =?utf-8?B?dTJkWWpETW1ndmV5NlhuVFZLWkNRL2E0bk9KTk11amFZUjgyZW4xMXlsdm10?=
 =?utf-8?B?V1RaTDc0QmhKelBpRzdkNVNEbjhSb28zbG9qS1hMRFlRc0tyNWpPcmd5L3RD?=
 =?utf-8?B?T3FWYWtmRStwR1FZV3BQU24rM0ZJcnN1Vk4vNTg2OWdESGRWdXhoOTViR1Fi?=
 =?utf-8?B?UFZuUjdDNTN3ejBKWEpVei9UdHZNLzhreGRtMDBLTGVBQTRvOGZCcUVqVEV2?=
 =?utf-8?B?S2JjNFRNVElvQU9pVHZKbk9GZStWRTRaV1JvdHQvc1RqS1FSNVpqNkdmNGNR?=
 =?utf-8?B?bjFwc1FOV2xxUGlwc1g3TWVyN3cvVDY2ZUtXN3BFWE1yVnQ2Ry96dVVkVFBC?=
 =?utf-8?B?dGpHK1U5QmhHSCtsaUgra3p3LzloYWZjWWViZERJclc5M2JlYmxBd0tRN2Q4?=
 =?utf-8?B?QldJVGh3OU1qTVJFV0kyVzBjZFNjK1hmRGkrOGdmSXRuYzVVVHJqbFNzYWF6?=
 =?utf-8?B?WWZXblJkd2dBWStRRC9STXhoMTNmb2FWMEk2Y1FBM3pBbERZalY2YU55dmFD?=
 =?utf-8?B?Qis0V2tuZXROUnpqem5KNlR1UTJKeGk0REM5K3FNMzM3UXprMkE4Nk5DVFdL?=
 =?utf-8?B?YVZmZmtuT25sZWorOE1ZemtRZ2pDd0JSY0svOGxKQldpdTBkb3lpY0lhWGtC?=
 =?utf-8?B?MG9wZTVHZlh6NDh0WWZITnE1T2ZlR2svYzVnZU83RnZ1UHo0Q3VRRWpYbE52?=
 =?utf-8?B?Q2RWek5Ia2QxaXJJdzk0RE1oT1JUTXJXSWtxTDZ6SklTeTBkMGhDTnZZdjRO?=
 =?utf-8?B?dVp5NTRORjZ6VTdGUnRQNVhVTkRWVXordnBnUE1PRnZVRHU0bE1FbjFNVHFS?=
 =?utf-8?B?YUJEbDh3MVp0WE5Za3dLdHlZZjZPL21IQnIrOURadXBldFpqeWpNY1UwM29h?=
 =?utf-8?B?WWdMZE9GaXFXcU1MbThZdUxkYVNUd2gvZFFFdmd6OVlJeS9XTFZPbVFaajZU?=
 =?utf-8?B?M0tkSGtINUw5TFVJNDdJbU1SRWY4NFJuajZJUTYrOTBVSkN4VHRaOW52V3Bp?=
 =?utf-8?B?bEwySFJ2R3dzN3RvM0ZpYnJuNkVha1B3QURtaTFsOHA3Q0VkaU1yanhvaWVv?=
 =?utf-8?B?R3ZSSVBFYVN3UEp6SGFBb1RSMHh2YmZKSFhuSzlpWlRxa09nWHRlRkJ0Z2I0?=
 =?utf-8?B?ZzBtTkh4cjN5QTllS2VwMjJUU0VjWXdnKzFyM2s1T3RJQU5rRHFoeXQ4eEs3?=
 =?utf-8?B?NmlUZERxT2JHQTlDdzIyUXkwbzJJUkZNV0VscWxDdWhwVldySGsyZzQ3djR1?=
 =?utf-8?B?Y2VsTW8wWGdzS09iR08wYkViUWJNNVlHemZhQVJEaDgxRXJwVzlkck9nWVQy?=
 =?utf-8?B?dDBKNkxIU1crUXczdFIrZXdDaVNPekdTbUZueFlDVmsvcDJzTE1kZk83cXcz?=
 =?utf-8?B?Snc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <306DCD7DC33E1F489C94AD32E0046A48@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 235470c2-c9fa-4ac1-b24e-08dc64499a03
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2024 10:30:45.9061
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RjsqIUo4Ce6Zzhfy2fk/3Td0FZPHHr5f7+ZDm3eyEAjp3Zj7GdMmrn9T6D4x6Ppxk0WhpW2BFS94p7iObC2JbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4988
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTAyLTI2IGF0IDAwOjI1IC0wODAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IC0tLSBhL2FyY2gveDg2L2t2bS92bXgvdGR4LmgNCj4gKysrIGIvYXJjaC94
ODYva3ZtL3ZteC90ZHguaA0KPiBAQCAtMyw2ICszLDkgQEANCj4gwqAjZGVmaW5lIF9fS1ZNX1g4
Nl9URFhfSA0KPiDCoA0KPiDCoCNpZmRlZiBDT05GSUdfSU5URUxfVERYX0hPU1QNCj4gKw0KPiAr
I2luY2x1ZGUgInRkeF9vcHMuaCINCj4gKw0KPiDCoHN0cnVjdCBrdm1fdGR4IHsNCj4gwqAJc3Ry
dWN0IGt2bSBrdm07DQo+IMKgCS8qIFREWCBzcGVjaWZpYyBtZW1iZXJzIGZvbGxvdy4gKi8NCg0K
SSBhbSBjb25zaXN0ZW50bHkgaGl0dGluZyBidWlsZCBlcnJvciBmb3IgdGhlIG1pZGRsZSBwYXRj
aGVzIGluIG91cg0KaW50ZXJuYWwgdHJlZSwgbW9zdGx5IGJlY2F1c2Ugb2YgdGhpcyBtYWRuZXNz
IG9mIGhlYWRlciBmaWxlIGluY2x1c2lvbi4NCg0KSSBmb3VuZCB0aGUgYWJvdmUgaW5jbHVzaW9u
IG9mICJ0ZHhfb3BzLmgiIGluICJ0ZHguaCIganVzdCBvdXQgb2YgYmx1ZS4NCg0KV2UgaGF2ZQ0K
DQogLSAidGR4X2FyY2guaCINCiAtICJ0ZHhfZXJybm8uaCINCiAtICJ0ZHhfb3BzLmgiDQogLSAi
dGR4LmgiDQoNCg0KVGhlIGZpcnN0IHR3byBjYW4gYmUgaW5jbHVkZWQgYnkgdGhlICJ0ZHguaCIs
IHNvIHRoYXQgd2UgY2FuIGhhdmUgYSBydWxlDQpmb3IgQyBmaWxlcyB0byBqdXN0IGluY2x1ZGUg
InRkeC5oIiwgaS5lLiwgdGhlIEMgZmlsZXMgc2hvdWxkIG5ldmVyIG5lZWQNCnRvIGluY2x1ZGUg
dGhlIGZpcnN0IHR3byBleHBsaWNpdGx5Lg0KDQpUaGUgInRkeF9vcHMuaCIgaXMgYSBsaXR0bGUg
Yml0IGNvbmZ1c2luZy4gIEkgX3RoaW5rXyB0aGUgcHVycG9zZSBvZiBpdCBpcw0KdG8gb25seSBj
b250YWluIFNFQU1DQUxMIHdyYXBwZXJzLiAgQnV0IEkgYW0gbm90IHN1cmUgd2hldGhlciBpdCBj
YW4gYmUNCmluY2x1ZGVkIGJ5IGFueSBDIGZpbGUgZGlyZWN0bHkuDQoNCkJhc2VkIG9uIGFib3Zl
IGNvZGUgY2hhbmdlLCBJIF90aGlua18gdGhlIGludGVudGlvbiBpcyB0byBhbHNvIGVtYmVkIGl0
IHRvDQoidGR4LmgiLCBzbyB0aGUgQyBmaWxlcyBzaG91bGQganVzdCBpbmNsdWRlICJ0ZHguaCIu
DQoNCkJ1dCBiYXNlZCBvbiBTZWFuJ3MgY29tbWVudHMsIHRoZSBTRUFNQ0FMTCB3cmFwcGVycyB3
aWxsIGJlIGNoYW5nZWQgdG8NCnRha2UgJ3N0cnVjdCBrdm1fdGR4IConIGFuZCAnc3RydWN0IHZj
cHVfdGR4IConLCBzbyB0aGV5IG5lZWQgdGhlDQpkZWNsYXJhdGlvbiBvZiB0aG9zZSBzdHJ1Y3R1
cmVzIHdoaWNoIGFyZSBpbiAidGR4LmgiLg0KDQpJIHRoaW5rIHdlIGNhbiBqdXN0IG1ha2UgYSBy
dWxlIHRoYXQsICJ0ZHhfb3BzLmgiIHNob3VsZCBuZXZlciBiZSBkaXJlY3RseQ0KaW5jbHVkZWQg
YnkgYW55IEMgZmlsZSwgaW5zdGVhZCwgd2UgaW5jbHVkZSAidGR4X29wcy5oIiBpbnRvICJ0ZHgu
aCINCnNvbWV3aGVyZSBhZnRlciBkZWNsYXJhdGlvbiBvZiAnc3RydWN0IGt2bV90ZHgnIGFuZCAn
c3RydWN0IHZjcHVfdGR4Jy4NCg0KQW5kIHN1Y2ggaW5jbHVzaW9uIHNob3VsZCBoYXBwZW4gd2hl
biB0aGUgInRkeF9vcHMuaCIgaXMgaW50cm9kdWNlZC4NCg0KQW0gSSBtaXNzaW5nIGFueXRoaW5n
PyANCg0KDQo=

