Return-Path: <kvm+bounces-20165-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 948A1911253
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 21:40:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 158A71F23917
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 19:40:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF8A61B9AD1;
	Thu, 20 Jun 2024 19:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NeMQSztZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47193A1CD;
	Thu, 20 Jun 2024 19:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718912417; cv=fail; b=O7XU3GwbNWEPRMwhjtOhhTXdtmUZWwuDt3ZSUAhHKyyaLbKoohBCxAan7dD3kIHvw1rEuMPjJVZ50dLJhw+kDDOwV7oysBOkUzfni89FSFlHKkN3K3dateNUB8PJegbVaOWe1M55YJTYzvyADDLwN1nM+FwSn2nVtQKJuoj31kQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718912417; c=relaxed/simple;
	bh=9izL63qYJBnisG7ABU6u5wYUEMl5SBGfyJpd8fsel6I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=u4T+C0dOgDn0Y/bGbPM5468A1qXq2P2I0KOJZkgEhlWLg2IeBiHNcfhANlfHC83ISRfAa+Qe8o7IOIwEyX28X7F0aapuRZbcPXMA+ly2KycoEVDxQG+dqXvdNpUOAHJSqjcPf5/swfD+XKq77h8KXeuCb4XVv8mS/0vWyWatuoc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NeMQSztZ; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718912416; x=1750448416;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9izL63qYJBnisG7ABU6u5wYUEMl5SBGfyJpd8fsel6I=;
  b=NeMQSztZQUVBLD+sd2+DTjs+3GeMocxgKnUfNeZcirqBabvevWbq7qGG
   sRSznVkBuyOFTbVyzSAN/hIhQ3MyorYUSJ4FGXU7JXjHsmsTYXpyFpi6A
   WfaH8UyB1TIk0Ci6cYVB4Zvv/iiemz9uCS6inx/3S0uVw45P6A0g8nNjh
   YdH5W44akzVtLogkxRo0K9wvOWty3X/4b93YZmZNIxG16BLkjUnusY/pG
   veixPjZiJqz2oXtD90YtIwQ3JUsath19HBaqrPeK7me9KU2x06PvztRW5
   yYx+Kd2ijE6icszRbp/ENX3MkwEX078xV8VX4RAm/DsK5mXHySHFgvkUU
   Q==;
X-CSE-ConnectionGUID: p0FOtHhnQaWOTF0H+MnYFw==
X-CSE-MsgGUID: I7Z5PBfkTwaaatDx97ri/w==
X-IronPort-AV: E=McAfee;i="6700,10204,11109"; a="15749226"
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="15749226"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 12:40:15 -0700
X-CSE-ConnectionGUID: ZWaCFE57QD+TSiy3fXJpxw==
X-CSE-MsgGUID: UNp2oIN8TSu3aa2CyB18aA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="79857996"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Jun 2024 12:40:15 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 12:40:14 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 20 Jun 2024 12:40:14 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 20 Jun 2024 12:40:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TkfXo/9V+2RHielNNXHH6Ss6e1HEEPbT8cqWW0e2UnsYVdMx9ZsB5B+6zdo2PnGn9Rk0UCatnd+EiYP5Jc3AngxIWoNjwxdr13Duu4yJg9zuaNAlQ/IXphPbag5YM7GeQE2n27EwXRI83U99VvgZubNarK6wsJ9jEfjtKLFjqSTdhxjWgqM5n5soVMQz8hQEaACxEVeswK3Y9JRKTyLjC1jyWKwxvgB1mf/BMscru536vRaZlyury5YwIPzLB52KauLr4G0K+bxpTiTYa7+2u4pa6vqE+S0lzQTTyDZeajdqmBGXNbdPT+hJ562Ur3DSb+vyrKaBS6unjN1Ub6Nj0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9izL63qYJBnisG7ABU6u5wYUEMl5SBGfyJpd8fsel6I=;
 b=YNMNDMsGZKUJB2dOU1osQ8/kRPrV5kTjH4gR39CVi4nDx/oTJKTg9P1JVBqBzwegXj8mP0URPsZ5rAqifEPRmdwi/iiSa2RgtFncGfrxsiVB9o+06ET1uP2+W2i70/J++unsW5RHrVWab6VmOS3RZPJHh1ykhx8hGDPEcW9xbK88o1xYnhiDqZZMMBIbzveJ+EvklgWbQx/dIvoeH5KR5klQLeoaMFTiON8RNHHlJeP5/E0yXmRsAPaP+3kyfPM7cYz4e0tx3KYYrHEybD3C6maC4pQ+p3nvjf+a0ORQMwoMeT7dDBOty57O4BoGzG4FK4Ld/zeAgl6BzUz3lWI19Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH8PR11MB6952.namprd11.prod.outlook.com (2603:10b6:510:224::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.22; Thu, 20 Jun
 2024 19:40:11 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.7698.017; Thu, 20 Jun 2024
 19:40:11 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "dmatlack@google.com" <dmatlack@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Implement memslot deletion for TDX
Thread-Topic: [PATCH] KVM: x86/mmu: Implement memslot deletion for TDX
Thread-Index: AQHaw0lDpap4PCJZJESxstQmwV3uIbHRDL8A
Date: Thu, 20 Jun 2024 19:40:11 +0000
Message-ID: <720d92d2b5627339c1ab2f837b667be0516b25bf.camel@intel.com>
References: <20240613060708.11761-1-yan.y.zhao@intel.com>
	 <20240620193701.374519-1-rick.p.edgecombe@intel.com>
In-Reply-To: <20240620193701.374519-1-rick.p.edgecombe@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH8PR11MB6952:EE_
x-ms-office365-filtering-correlation-id: b662c846-188a-44ac-583c-08dc9160cc51
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|376011|366013|1800799021|38070700015;
x-microsoft-antispam-message-info: =?utf-8?B?emZnOHZSeVhHN2l3NXVVS3FEUUg0ZmkyOWEwcVFWNmI4NWljcURyTXltbzNM?=
 =?utf-8?B?VUtCanE3S0xMMGRwUmoxUVpuMGxuNXE5b0NLakVyY205YUhNZUtIRFY1RmFs?=
 =?utf-8?B?U2c2aGlXRU0xZlhxdDBsRllOa1ZtUHJnSDdnemIwQXZyUnlhMVhwM1FSSWww?=
 =?utf-8?B?MHg5bGhYL2d0UjNFWEhTMzF6aWhSN2dYUHZtaGtZc3VOTVdvUzhKZzFDSEIz?=
 =?utf-8?B?bFJzNzA1b0x5b0JMbG5QU2srTmY3N2JLankwSk93OEswbTdlVmx3V3FyanVk?=
 =?utf-8?B?N2cyNkRNVWNwd0pURUlmODlQVkh5RGd4a0dVR2h0cmVmWFhhWTdzMkg0YTh5?=
 =?utf-8?B?ZWpXRkErSjlacVFrYWZjd1BwWDc3UWZIUzF4a0hzUDBoS1liWXZKaVZLU0ZR?=
 =?utf-8?B?dktrTGZMcmh6U1B1YVFmUENDTWZVNlBXd0dkUExQcjluRXVLb1VWSm54dktk?=
 =?utf-8?B?S2hneWRqYkE5WnFOQTFZSDNpVzlTbVFvTnNJTWRoaG9GbFBETVl2RERVeVVR?=
 =?utf-8?B?M0JGTUhPWlJJWkNTUUVGemh6TE1hSTJNRnYxQ1NIQVBKeEtPQ2pKTFhNZFc5?=
 =?utf-8?B?ZUJDU2xPeld1d3Z2OWEyS0RDUmZ4OWJVMDVqc3l3KzhsZEFQdkFKMkt1Mm1a?=
 =?utf-8?B?dVN0NXpUMUxWbXVZaFE1VUtDSS83RHZIaHI0N24rYjJLam0wUWU3QUFwcXNm?=
 =?utf-8?B?UUx1Q3VQenFnWTJMMjlBYm90Q2RMYWFWbTFZSUxSZkt5VHVzdlJsenFWbW1H?=
 =?utf-8?B?RFRoVVJlVXUzY0RuL2pVaGlkWDBKanova1NhQzlBTEhNc0VGenBJdjB3bXph?=
 =?utf-8?B?UFNLaCtwWjBCUGdXQTMwUHRId0w0ZGpPeDFiVEdzWHVJS21Yd2RJQnRoWXdZ?=
 =?utf-8?B?ME4zUEVsaTZXQ0VFSFRzK0N6YkNqbUxUeW9CMmRzaGgwMndoVmtzdEF2d3hQ?=
 =?utf-8?B?S0hsZTBBbmVjNUhESFRadWo4SzRtdVhMZHU0VUoyQnNWb1IxQ0hOeUhlaXVh?=
 =?utf-8?B?dDZiUXU1NGwxZXg3OThZQWZDN1RIUlNzM1Ywbk5qMUd4b1VQZVJvMUhSVDN2?=
 =?utf-8?B?Z0hnWFNBc3cyTkppTElIc3RJR1ZvcjU4WEtxeXRIRDJFRzZnRUFvM2lzcHVS?=
 =?utf-8?B?YlVZdm9yemJhZU5rejFZVmpLY0UvUCs0VXNqL2xTM3c3MDhERHV6eEFJdEla?=
 =?utf-8?B?WEpzM3RERGduaCtnZFVvdzNNVVpCRTJzeEVrMGgzckkxQmp2ZDNqRHQwazl1?=
 =?utf-8?B?c25VQWVlMDlCUjNUL0FlUi9jcTFPVjFyUTRNbmE3U050c1RNTktzZnNyL0V2?=
 =?utf-8?B?ckhIdDI4SlFyWVlmc2hqTzlPNHN6eDlldDhLUTh0ZDkwUndCRzJFNzA0Zmlm?=
 =?utf-8?B?N1hyMUV0VGFxc2d4M3ZDdUJ3cjY0MFlqZGlFQ05kWGJrMmpoOEwyMUx1eFNY?=
 =?utf-8?B?V3Y2NUVSbmxMbWZtZTNkMkpQcHY0UGZLZVh4TXpZbGZpSXhIbmZKc09rSUVX?=
 =?utf-8?B?bktVT1VDdkthZGN4SytQS0lSYTRkZU9rcE11dmVKTkIxN3FrZnFWNXJkRWtI?=
 =?utf-8?B?Q1Iwb1pmeXgwSlVDZS9BelVmbDltVVRPbk9JSGRXcDRpTnBXL3d6L1hwNHdC?=
 =?utf-8?B?dnJmMVpNT1piTTA2akdhWk85ZTZqL1lESzMvTllJOFBEaWIvVy95SGZROXRH?=
 =?utf-8?B?YitpWk1vN2dHbDBzeXdhV0FSUkUyeUFhb1FWMWNOZU5MRU51NnRZVkhFUGdC?=
 =?utf-8?Q?ovP/jps7uEqBqlfXhg=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(366013)(1800799021)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NVJxU1BFeTQ0Tmcwbno2MDREQ29QNWdMcGxXY0U3VVZETFdHTG5tS21ZTHFL?=
 =?utf-8?B?ZFJsczNSbURiN1VaUkZFVVhSMUEwNThVUHJOMkZjZTZtOEtpdzQzOUk3Z0ZY?=
 =?utf-8?B?NmV2NjdwWDhoa3RzRXlGVkJMa2FNWGhpVmRIbnlSRUsyY0FHOGF5YlowUVJZ?=
 =?utf-8?B?RjNHRlByMGRXbzlhL0V0bHpXRjNycFgxYzRhUGpnbTZpbXdhZzI2ZWtJbkxR?=
 =?utf-8?B?aEpFVUNhbUtZazJKZ2ZzL00xMTFWZlZGZkNENXVadGtxUzlPeWdTdHY4MXVx?=
 =?utf-8?B?dG51bDFXQ2VhOVhxbXd4dGlFWUlER2lEa3NhdEdYSlRRVURLNjFUV1hyZDZk?=
 =?utf-8?B?N1FEYXBwd2RObThXOWxsaXRQeEtrQnRwRStWd3hhVUprWDlhc0tYcmlZMENM?=
 =?utf-8?B?YnFwM0cwU1ArYXY2N0orN0ZVQi9VVFo5MEI3VU0xUi9GcUpWZFp3T0dFVXA0?=
 =?utf-8?B?dEppMVltRUkzR0ZYUUtyUllBRGJCQkZBY1FvaUpKN3YvRUl6cFVYbGdBYjdW?=
 =?utf-8?B?WERjWGZxcHRKSnlCbU9tUi9VcVhnRCs0YUk2d1U1Nk9GMnZMVXVySXR6ZC9W?=
 =?utf-8?B?dkhDVG03M3RndFA4UDZmbHJGTkFndUxqVEdwOHBIeWcyaWxvMGh6QW9xdGdr?=
 =?utf-8?B?L25HSm1Ea04yY3FFTGtQK3FrcnBpaVlXNERLQ0I1Q3gzK1lYVDAyeGJIVUdM?=
 =?utf-8?B?QXFPcTQya3QybXdHWFZHcmE5bXVvUlBFWGNiMlVCQlB0NFIxVlUxRlF4OVRX?=
 =?utf-8?B?QnoyYUk1MVJpSDlFQldLWFVaalJLQWs1TmRUc0dndVZ6SzhKWlFrdDdmVDA1?=
 =?utf-8?B?dlB1bUxlWTM5d09icTRrSkhNck1rMm9OQnN3QWZLSGNaV3RrZFFzRUZTeGZF?=
 =?utf-8?B?WjZPekovR0RGSGdyQWN1SDB5bW5sMnllYStTYVJvdDRuR04xMCtYeE5KVTVx?=
 =?utf-8?B?KzVDc01udXdOZFFoZjBHa1R4V0JSejlEc0NxQlJpczc2S0VwK3lYUFZUTFF3?=
 =?utf-8?B?UTRXM3NhZzc2TEhTNkdiWGt0MUZlZCtOeG5xQS8rMlk5R2RnY2dYOTdoSTdo?=
 =?utf-8?B?eVA2U0FVZXpYdFZuWXNDWER2MGRnd216Q3drakp3T2dtUTJvdTRDZ3JBNG5G?=
 =?utf-8?B?L3FHWjB4V1pySlFnM05hYkpnMm5vcWxzblVBbXNTSm9iV1dhcnJBZERVNHhr?=
 =?utf-8?B?L2dJVno2azEveUp2dmJGUXFSTzVFUlRXSGpmekNVWXF6OHRkVFBURDlkaG1K?=
 =?utf-8?B?TmVSdWFvMWxIdjRzdTdhMWlUTXVtZWFubjc5bk1mb1BndEFjakpCemYvNWNI?=
 =?utf-8?B?b2NMekE1c0dwYTN6a1VLNDEvK2M4Rjd5M3R4K2loWVVaOWY2Q0xqWVcyZzU4?=
 =?utf-8?B?YXVQR0M1cHpHem5majRZU29JdVdseTNreE5idWdXdXEzRVl5dmRwMHEwQUhQ?=
 =?utf-8?B?K1dwRU1Yc1VRSm9pZ2RrOHYzNUJKMG8wSDZOMU9ZcW52amxmMDhsRUY4ejN3?=
 =?utf-8?B?NUhWQW5vd0Z2YWZJV296WGZ6M05hTXpSZGpvbCtlckw4RjdXT3ZuU2ZyK3pv?=
 =?utf-8?B?RFpjSmd3T0RXTEpYeDJuVTk5RDRxSDRzclU2M1ltdW1SRUgybWJFZ0tOQWt2?=
 =?utf-8?B?YkpOSTZKMU5tejRHTU8wSTJHaVVGV1ZpN1kwblViZk9SdDlYbktJT0ZFN1h4?=
 =?utf-8?B?eVhzcSs5aXNTRXcwYWkrNlY3SW44L3JRNlFzUnpIQWRRYXY3cWpibUE2V1FC?=
 =?utf-8?B?bkdIL1Qwbi93RzVUMDJrUGF4d0J4R3pjczRwVjdPR2VIb0ZIY2M2K1NUanRl?=
 =?utf-8?B?ZUdpOUw0S2pmRGROL1c4SXFvWVB5NmJZQkFEMzFBbE9qREZpdzFGN01JeC9v?=
 =?utf-8?B?N1VxbHNPNUZLcnlReWp2d1RvNEcrUTRxRU9maVI2bWo1RW11dnQ3emVrZFl1?=
 =?utf-8?B?V0h6ak9KS21wWnE5MUFqNTVDTERlanY2bHpRWEFtOXcvWVFvbHpmZ3JySVBq?=
 =?utf-8?B?emdDWDNvaEQyMlB5ejh3dGRJcy9nNCtwRk5iRzVYc0p4cm1Sa3AzYXBKbFpo?=
 =?utf-8?B?U1lOdittQzRTemxGMmRyTGN6bWlFQ0dvdWlMbkhsTmNNTnhTUEJaR09yRUs2?=
 =?utf-8?B?V25JWGpHekg5ZXZHMTNDL1ZTODZsR1lPclhtaHBwL0dUbUliY1lUbUhhRjBX?=
 =?utf-8?Q?5OkI0B7kXNOxWQOFX76FjRk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CA28E4CE00FB184994FAC7EC19465B38@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b662c846-188a-44ac-583c-08dc9160cc51
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2024 19:40:11.0307
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6q930nGphtMm8MGDvkUAFzyLNpdlXrQGjknbMlPSRCbcdXOGvuxPqhrdUWyi3Pn9DbnMZZ1pKCa764zsPAjcJaNugba9qYrKLJ5+hMXYsu4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6952
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA2LTIwIGF0IDEyOjM3IC0wNzAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToN
Cj4gSGVyZSBpcyB0aGUgcGF0Y2ggZm9yIFREWCBpbnRlZ3JhdGlvbi4gSXQgaXMgbm90IG5lZWRl
ZCB1bnRpbCB3ZSBjYW4NCj4gYWN0dWFsbHkgY3JlYXRlIEtWTV9YODZfVERYX1ZNcy4NCg0KSXQg
ZGVwZW5kcyBvbiB0aGlzIHNlcmllcyBhcyB3ZWxsOg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcv
a3ZtL2U2OTNhZGFiLTlmYTMtNDdmZC1iNjJmLWMzZjI1ODlmZmU3ZkBsaW51eC5pbnRlbC5jb20v
DQoNClNvIGl0IHNob3VsZCBub3QgYmUgaW5jbHVkZWQgd2hlbiBhcHBseWluZyBqdXN0IHRoaXMg
c2VyaWVzICh3aWxsIGdldCBhIGJ1aWxkDQplcnJvcikuDQo=

