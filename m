Return-Path: <kvm+bounces-6416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A6D6F83124E
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 06:16:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7CCF91C21B48
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 05:16:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C20279475;
	Thu, 18 Jan 2024 05:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wx6opOg4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97F99444;
	Thu, 18 Jan 2024 05:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705554974; cv=fail; b=EkmLJbI3BXEizKClX92FzMeQ2aMXY1zxRmyz61+vxPrzB8E7T7qp93Q9V6BiEAYs/zeZB3+ApL/ssa0PzrX99ZVNs6QYmltBtOEsSIKXTGKtGExz+TGoymQ8mvFKAHRBBLDawhPvsCZyBUaOoGUmEh6fmdry2N6vPGPsWypv0MM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705554974; c=relaxed/simple;
	bh=b3L3auIlG1VXZj9gCYJvFtVhi1yUn4a8tVBmzyIarT4=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:Received:Received:Received:Received:
	 ARC-Message-Signature:ARC-Authentication-Results:Received:Received:
	 From:To:CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:
	 References:In-Reply-To:Accept-Language:Content-Language:
	 X-MS-Has-Attach:X-MS-TNEF-Correlator:x-ms-publictraffictype:
	 x-ms-traffictypediagnostic:x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-senderadcheck:x-ms-exchange-antispam-relay:
	 x-microsoft-antispam:x-microsoft-antispam-message-info:
	 x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:
	 X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	b=tSqo3pdoeGYOZGl0sUQ9rFwdfx5x5KkTN6Th5Bb80ai0uAI7IA8LLylTwPbIWWGyvU/YBNvMJjcT/ggXFZsDrGzjpBr2VViUw3OUFyopIgHEqbzJXMI5aGt0inbm9Rp9IpTgz2SnVaKgeoBp04MF+6l9okBmNLamHpKjFcwBxic=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wx6opOg4; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705554972; x=1737090972;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=b3L3auIlG1VXZj9gCYJvFtVhi1yUn4a8tVBmzyIarT4=;
  b=Wx6opOg4HTugEsCiePkWX8RVDUfkU8bumgOoiArQkeWwRjUBMvjjca+9
   knSVmlTnTU+mCgky7+wY4QotGx2xBPI5HfVVaztzbfKz8415Dt3xXqt+W
   QrK779dF6AcxEq+6sDiu3KsJugpByebytm1qjOXEAle9Aeu7ins2nh/Gb
   eHTx1ZzwEkW5kjFIGnCrBjzYPJopTjx56TN1qjtWziIpYRJSDp9DhHemf
   MP1RhT6TSQC9ZjQRroYgQgIfBVDnqeOcWrQWDekgPUJpxAddhSEcel0mW
   722qUT6ARuJPSb6qj3w4GTOYod7BfucStAuB5YGmS5VfN40nnSM1gqgFq
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="18947362"
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="18947362"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2024 21:16:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="235569"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Jan 2024 21:16:11 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Jan 2024 21:16:10 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 17 Jan 2024 21:16:10 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 17 Jan 2024 21:16:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iy4bj7wv1FtokaVQo2iaY8i4klfDzT+FngOCwwNGXv3fUcUqdM2xcQYLl1I6TIKV0Px3c7+iGsRsgQOfOsEdOjfTpQrmZkeEk++5YhyLtoUcssS/iY+Fjs7KnxZ+vTCN2n94hLk+itG7k+4Ew30QZvoU98Tx0aytG+d9epIDIdAUmcwxWYw9NylZahVqoDIT31J5GS0XtlabzYtRmKNmb7DD+oQ1i6rGJI+Pe63Gjmzo488s3pPHW8P9dkWo6IQrZdc6C8jrb/vQrP9cKq4GTnDdh2a44/SZ8YASidYwIDVI1W0BlDQ0IuT9P4YU+gF38zZlkEPN6wGuSSL4D3GyuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b3L3auIlG1VXZj9gCYJvFtVhi1yUn4a8tVBmzyIarT4=;
 b=kP5OAIHEhYGlIFFM2nyrtz6K5U/Q5Z7leZCK//0NlSuQV97l6+YdMx8QcgWuoseeJjNC/ZNqP+/kFXg0ghIS9skXgCBJ76jPAjyASfz9A07SpIoe2+7fpghRl9DYNbwCCjB1mGuWjFQpDiEdSTb8DyxUY0wwbfax0rgi8TQZ1e4H2xYW8roNJZtQcFodGTpcZaei9mPPdXQFVAdd9ETwMXG8GCAbn1dogBFmrktIpUnitTrWoQIn7Y3aRQ0mBOjavWcvHhxUm4wn8HShsEqyRwe6JP6VgbxXf8ka9wXpuGA6UjR+wRsHzJuF7sUDwUiqZWXEewBZJIfXahv5u4juAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by CYXPR11MB8662.namprd11.prod.outlook.com (2603:10b6:930:de::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.23; Thu, 18 Jan
 2024 05:16:08 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::8ccb:4e83:8802:c277]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::8ccb:4e83:8802:c277%4]) with mapi id 15.20.7202.020; Thu, 18 Jan 2024
 05:16:08 +0000
From: "Li, Xin3" <xin3.li@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "Yang, Weijiang" <weijiang.yang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "bp@alien8.de" <bp@alien8.de>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: RE: [PATCH v4 1/2] KVM: VMX: Cleanup VMX basic information defines
 and usages
Thread-Topic: [PATCH v4 1/2] KVM: VMX: Cleanup VMX basic information defines
 and usages
Thread-Index: AQHaRT8NfyvFkqdAjk6/fSX6qVKXsrDe7iKAgAAiKPA=
Date: Thu, 18 Jan 2024 05:16:08 +0000
Message-ID: <SA1PR11MB67346BBAB5E81039FBCDB692A8712@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20240112093449.88583-1-xin3.li@intel.com>
 <a6c44305e822b5525c50624d892b652b3f511b45.camel@intel.com>
In-Reply-To: <a6c44305e822b5525c50624d892b652b3f511b45.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|CYXPR11MB8662:EE_
x-ms-office365-filtering-correlation-id: 4025d2d6-59b2-4c2d-3837-08dc17e49413
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bycI8UsyiRdV1Ursneita2gvgIBdMM4NY68tvZ/9kAcn1H3DhpKBCA2VMRlITajjvm0ZTCEMedwRnt8m6dc6OEpEgqQ4RRTHIBHAYDw/fVtzLeJUAjKo8UTLD6Av2jMXfbZZwdx1Xy+dSoHU9/yquKS6YxP9nkt/LhJ7xzGu0jrY64YPw3M20ZOlopuThnE/+oca5oHMYQhqVwsv0uHHfeTHypNk/rdg7ZqREsNglerqZ5GWpAE6BaM8RK7ocY0MeJLgwhNnc5fQdH+F+834k45AUW2Oq7MXIB9IGwoZuOEPqc2qNPrcxMS+cwh0X05Jevuz+I7XE7rLWUpfg89VkrJ5YJGq9E9YPuP1qYqTRkQQtuhKwnAxAzSt7SU/c8qpGir52aG6Hqmc09C6C+59YPxKKuX6SKfPQ3wd+NHVC/w/F4m6KW0QeSTf+/RRTql8dRIvTfRusAXQ6AQbOtUERmMnBVLhq21Wx2bOWSrup0FkVhWtSFqXHQZUgM3H4wg1BbRUFjnwzUYREFq3XC8RU7AtLuw0CIuKawF2o+0Z1sk6TDBTGWOJigd9G4DXyX7gBtbuiuI+4Vc/y7pu4kic1Zx6nBuZ2HTLE/QgIa1/ciQHrpfWQaZZopPBMKmXEWrN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(39860400002)(136003)(366004)(376002)(230922051799003)(451199024)(1800799012)(64100799003)(186009)(26005)(9686003)(66556008)(38100700002)(122000001)(66446008)(4326008)(52536014)(8676002)(7416002)(4744005)(2906002)(8936002)(5660300002)(41300700001)(478600001)(76116006)(316002)(54906003)(110136005)(66946007)(66476007)(64756008)(71200400001)(7696005)(33656002)(86362001)(6506007)(82960400001)(38070700009)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZUZnYnNjTDdBZmRMUmxrRVhhWldvUGN1NDR6UVpPWldoZDEvZUFwSFV5S29H?=
 =?utf-8?B?dU5lTE8yblVDcHZGT2xpeG00U1B4QTZCY25FUGRuRW5WVWpkRURPZlZtc3hE?=
 =?utf-8?B?M0lMcHp3cS93L1ovNDB2K2xQRHUrNjF5bm4zNHZhR1RxaXNWa29wTUFhRkNK?=
 =?utf-8?B?SHd0L1F6VTY1VVVkdXcrWkQ3NzQ5cDFZa2x0WTVjYUxEeGZPTTFub1M5T0Ry?=
 =?utf-8?B?MTJJdnZpTHJiU1Rqd1dCNUZTOHNYc1pVZ1VKcmNLWkY1ZU1WK2xrbzNKaGNT?=
 =?utf-8?B?OGt3TEhuSElEUWI5QUo1Zi93NmYzQzJPRWpGUzZtSVUyeUk4K3RNZDNxUjJy?=
 =?utf-8?B?M0JzYXZxVXdMeVNsYTdITFF0RVZBb2cxRlhpck9XTVdwRzNSMHNQZ29pY2Zq?=
 =?utf-8?B?OWFORXhiU2hnWGtRdGg1VjY0MzFNa2g4NzBzVHNCNGNRQVM3bnFiM1djSWZC?=
 =?utf-8?B?L0pRcDVhZGRNTEg4S3Q1OUxWaVNTYzREMmZKNE9MOTdETEtUS1d0VVBWYVZE?=
 =?utf-8?B?WHArR2lrb25sTXlUSjRCbXZ5YU9RUlZuYThCQlpjbmNNbXlLTXBHNXExOHhD?=
 =?utf-8?B?OUtMSnZMUWFYY1V0emdVZ1VRdjJxUEpsaDU4NFNTMVR0OEllSFQ5RFFycU9V?=
 =?utf-8?B?bHFzOGh6T29aa093QjJYVEhGa2JrdjVvdzBWckRxcmd0aVpNSkRpZVVla3Bv?=
 =?utf-8?B?eU5KamVBSFJJRTZDaWF5WUdyZ0VzYkpFT0JUT2d1b25zMVNETXRtWDVUWGRi?=
 =?utf-8?B?cERUbHlCczMvU2Jqbk5lRVkvMDEyd2JJV1hVWnFkY3JiSEY0eSthRW9sRHBm?=
 =?utf-8?B?R2p5ald6U29KNHJjNFlWM3BHaFhqNWJncFRMMDQvQytyU0c4L2E5MEFOYUZJ?=
 =?utf-8?B?ZjZESHgzYWwxQVdILzJGNHg0QW52aGx1cndMcGlBVjlLU1JLb05WTk4vYXlI?=
 =?utf-8?B?SmZOUjFNdW4zbm9BUFA1NHVtR2R1RDZ2M3U5cVhCd3llcU00YUUzcEpqOHVZ?=
 =?utf-8?B?UlJjM2RiRVhoRjZVMEVJejdwQk0zRm82QlFod0IvTld4R3psMkM1WFRNOWFJ?=
 =?utf-8?B?UjRnUzlmbkpheWtUWHdQdzZGcGhaUUpLZWJEZXRBTm4yZ25lUmRUL3RSVzUw?=
 =?utf-8?B?clJVMEo4T2ErWFl2aVZFcEhHb0hjMWxqbEZuaDRCTVlvbXBIZUc0M1lBcllK?=
 =?utf-8?B?WjFGeTVSS3VkcTc5T3IraVQvbWUzS005VThnRFlwQUw2WFBhbUlLTEEvMjZh?=
 =?utf-8?B?QTN2Nkl5K0dUUDcvbXcwUStjcTFsVWppR2FGWXhYaURNZjNMNXorS0t1blB2?=
 =?utf-8?B?YUVpUVJWb1N6a21jeU1menU3UHFrMmdaQ1plakx6aUlTOERsZU01WlN3Ryt5?=
 =?utf-8?B?Szhud0dOUHpFRWg5a1ZqOTV3MmQyWExIT0ZDWlZaS2pTRUNZVXY5b3ZoUWlH?=
 =?utf-8?B?Sjh4K2U0OURQM0paMjF0dlE3RjM3Y05ieTdWejUyUFZ1amJ6aHZQL2JrcVhZ?=
 =?utf-8?B?YmZrSzJXRFBZU1YzMkhXRGJpNHZpTXVjZVkvN0ViTUk0MHR2MGpjR0dRUXBG?=
 =?utf-8?B?eE82K1FDMnVsTVY1V0RzSUJ5V0lsSnAyelpaYnJYYkdoSFl2S1NQTGwyS095?=
 =?utf-8?B?cFg5c0ExOUVQU040Z3NBT3YxQU8yNFl4RWFiaThxMDlvUDZJa1NDS3NETnNP?=
 =?utf-8?B?YXhYN3UvdkZQUVVwaG1NWWNsN0s2VWdZOGJWNGV1dHVlcnBTMWdiQ2pKZkY3?=
 =?utf-8?B?bzhJWE4rTzR2SUNTeUd2TTNoUTdFUHY1U01HVVcwQjh2d3U3QVIyUS8vVVhY?=
 =?utf-8?B?ZzFqL2pmU0VvdDVQNEwvdHVrWFZ0TngxaTNoVnRTMHJNVGY5cEdZTzNrOTM3?=
 =?utf-8?B?TmRna3hLUTVuNTcwTEVoSFJUMXFBK0pINW1kNUxYREthcFZFL0JkN0Q1dkxF?=
 =?utf-8?B?ZktneFk5SFJFVTM5NEl1aGJIZ2VCcU43RmI0bDlESG1oN2VXTVdCSXNMV1lF?=
 =?utf-8?B?UjEvYjhIdnFmaGRPMmticUFEMkU0Y2hZMFhCUFFlWkY2NDE5R25YejY4MjNn?=
 =?utf-8?B?d3hycHh3V0ZuMWtxTFIwMk9uL2o3c0ptSGRQam9CSTZnVFlhQ1RiRzdkSFpP?=
 =?utf-8?Q?JeqU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4025d2d6-59b2-4c2d-3837-08dc17e49413
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2024 05:16:08.3675
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mg02bZ835/2OSGw7v2kl2qmNv08fTEWLufZn+dWZtByTSziwmuqvP75tj502YwuiGJ6wA2skoGlIciudeGtrVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR11MB8662
X-OriginatorOrg: intel.com

PiBPbiBGcmksIDIwMjQtMDEtMTIgYXQgMDE6MzQgLTA4MDAsIFhpbiBMaSB3cm90ZToNCj4gPiBE
ZWZpbmUgVk1YIGJhc2ljIGluZm9ybWF0aW9uIGZpZWxkcyB3aXRoIEJJVF9VTEwoKS9HRU5NQVNL
X1VMTCgpLCBhbmQNCj4gPiByZXBsYWNlIGhhcmRjb2RlZCBWTVggYmFzaWMgbnVtYmVycyB3aXRo
IHRoZXNlIGZpZWxkIG1hY3Jvcy4NCj4gPg0KPiA+IFBlciBTZWFuJ3MgYXNrLCBzYXZlIHRoZSBm
dWxsL3JhdyB2YWx1ZSBvZiBNU1JfSUEzMl9WTVhfQkFTSUMgaW4gdGhlDQo+ID4gZ2xvYmFsIHZt
Y3NfY29uZmlnIGFzIHR5cGUgdTY0IHRvIGdldCByaWQgb2YgdGhlIGhpL2xvIGNydWQsIGFuZCB0
aGVuDQo+ID4gdXNlIFZNWF9CQVNJQyBoZWxwZXJzIHRvIGV4dHJhY3QgaW5mbyBhcyBuZWVkZWQu
DQo+ID4NCj4gPiBUZXN0ZWQtYnk6IFNoYW4gS2FuZyA8c2hhbi5rYW5nQGludGVsLmNvbT4NCj4g
PiBTaWduZWQtb2ZmLWJ5OiBYaW4gTGkgPHhpbjMubGlAaW50ZWwuY29tPg0KPiA+IC0tLQ0KPiA+
DQo+IA0KPiBbLi4uXQ0KPiANCj4gPiArLyogeDg2IG1lbW9yeSB0eXBlcywgZXhwbGljaXRseSB1
c2VkIGluIFZNWCBvbmx5ICovDQo+ID4gKyNkZWZpbmUgTUVNX1RZUEVfV0IJCQkJMHg2VUxMDQo+
ID4gKyNkZWZpbmUgTUVNX1RZUEVfVUMJCQkJMHgwVUxMDQo+ID4gKw0KPiANCj4gWy4uLl0NCj4g
DQo+ID4gLSNkZWZpbmUgVk1YX0VQVFBfTVRfV0IJCQkJMHg2dWxsDQo+ID4gLSNkZWZpbmUgVk1Y
X0VQVFBfTVRfVUMJCQkJMHgwdWxsDQo+IA0KPiBDb3VsZCB5b3UgYWxzbyBwdXQgc29tZSB3b3Jk
cyB0byB0aGUgY2hhbmdlbG9nIHRvIGp1c3RpZnkgeW91ciBjaGFuZ2UgYXJvdW5kDQo+IG1lbW9y
eSB0eXBlIG1hY3Jvcz8NCg0KTlAuDQo=

