Return-Path: <kvm+bounces-12741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F44388D35F
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 01:27:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2533D1F3A1F6
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 00:27:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C11F01CD2B;
	Wed, 27 Mar 2024 00:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OnI5JTib"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF90618E11;
	Wed, 27 Mar 2024 00:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711499232; cv=fail; b=lkLJVx9WNljXtXo2MslzhT+YAFj72tbS90bF1W4XEsS4JEQqjth/XyqZpe12chwktYdwTb/wooMw5rKdiGVJtkuVv6zzifGugzy4HwSKorT6+Uv08Gsq0awQjeKcH8fVPrbXmgotMg4+dcAWm2le+8TkVTz01EQc2KOs9KeAQgs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711499232; c=relaxed/simple;
	bh=/tQzUcPuKlo66DkIqUxdhL1B9h/GQXOC6Mj204myDzY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TrjRjyRq0qtrT8nNla2KbRFL6IB5a5C8ZXMN7/Z0C7atibwx2h1jQcUh3r+7T6vNxTIQBspfU6Xhe9hEMYVNWnRRzyyOp7Po74i57Ju8FJGOgh+ATJNNBhISAB3uCLFndXDwi63WMdqJjq9goqPDQt1EsifjLA7BB/xoC0UrA64=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OnI5JTib; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711499230; x=1743035230;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/tQzUcPuKlo66DkIqUxdhL1B9h/GQXOC6Mj204myDzY=;
  b=OnI5JTibP/vcnKBAf0L9YS4PxvakmU+2C2LfjEjdwWAhUdc+cQE1G4DS
   TsH7G0fIrHKXmKl0ftmRghsqytq+RFdw2GQXD6IDrF1GfMy8KHht8dFOC
   97VomLWz6KunDTyfjWWsN8vWKz3oWQhyJxqBVcK8jfyGArPG1tb595U6x
   PauA5lJGpeIDtniY4KwzDbPedWy6+yFe8palEDQL39ehnGx1ddruge8ub
   sf3w3ztKQnCZDhNk6Ls/TENTKN9XhI2sxf3EDmv2TpMSj87e1C9TUKNZa
   vQ+TlaQ8F2uAMkHQNauIFDEtse4Ov+xwdLLc7FvfzLigsFhvDw2GKsWsE
   A==;
X-CSE-ConnectionGUID: yIf6UjNBRXGWWbSJpoWM4Q==
X-CSE-MsgGUID: zoWVjNmMTOKRRl3fxJ3xuQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11025"; a="6408896"
X-IronPort-AV: E=Sophos;i="6.07,157,1708416000"; 
   d="scan'208";a="6408896"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2024 17:27:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,157,1708416000"; 
   d="scan'208";a="16563205"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Mar 2024 17:27:08 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 26 Mar 2024 17:27:08 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 26 Mar 2024 17:27:08 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 26 Mar 2024 17:27:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IBfM5rWwBXcCu5VqZjIid7760LldnjtKUNRZgUSVZ8k+pkaFkydQBo3Yt5a79J7kFH8moXGlJCbIJ9dyRxCTTkGQQ9o+3xND9Lbx5ChBysvJzvufgYiyRckKpIoynT2lEKWyKqFX0qyE6DRUvrElDY/uR/ZYOh0Dsz23Pv68WVRc0Zo1xo7/Ge18IaxkL5KZqd64hipui+whxaQTTI90AZVNz47Rq9zx7H4gtDfjbUrs68gbok8+dIeBnypU7gyBXSdctHE0ZGoQEKLIabDR6J1RY2CFdC6LVHWkfHk+Xh7jLxYvNpk9uf1t9AcRJCXthEuTDAB2bNklRCXIsnkLSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/tQzUcPuKlo66DkIqUxdhL1B9h/GQXOC6Mj204myDzY=;
 b=GiAE0r40hs2LLrRpp7LcfKgU+Gn29XILvRHlx0vrRQ2BCL5B8GSagG3UTuKFbBCaWF1KNM2/9hOr9kFHzylNt/yUnwK6t1oYj6IW6YU/elrLCFHU6LvJf8Xl1zCum/wCSCCwiauOBzF8xrc2kqSTXXzRPEgebDvfWzJZkXSTSIYoNhT7L8yfTDfs+ZCSt4sv66eNIqRp4Cp60lvs0GBX0RGIAK9Y+NxU5FMLEIMZiUjRqOXlr1tcTLKmeLsjPt2HEMyfTlnjLR21ZwY/xSDLLceoO605OzaFLfpaGs4Hnm05yMT0MFHH8Bep7HAX2XFdzdRKczwtdODCTXu1WHi0vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA2PR11MB4795.namprd11.prod.outlook.com (2603:10b6:806:118::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 00:27:04 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7409.028; Wed, 27 Mar 2024
 00:27:03 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Huang, Kai"
	<kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com"
	<sagis@google.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "sean.j.christopherson@intel.com"
	<sean.j.christopherson@intel.com>
Subject: Re: [PATCH v19 044/130] KVM: TDX: Do TDX specific vcpu initialization
Thread-Topic: [PATCH v19 044/130] KVM: TDX: Do TDX specific vcpu
 initialization
Thread-Index: AQHadnqkwWefc3iQakORGBZWkXNqfLFKzgQA
Date: Wed, 27 Mar 2024 00:27:03 +0000
Message-ID: <3f4f164a6375c8ada364dd2a83562a506019db86.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <d6a21fe6ea9eb53c24b6527ef8e5a07f0c2e8806.1708933498.git.isaku.yamahata@intel.com>
In-Reply-To: <d6a21fe6ea9eb53c24b6527ef8e5a07f0c2e8806.1708933498.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA2PR11MB4795:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bs9qr0Yh/51lZOg0fZL5n+9ygy9kKF0lkPZQR4D0WIJwnxzPd4W0Lq9gxTVo/loiyFKKx0bR1nlbv8RTw395T+CnR8zf/byBQdYSLvUjnqqEzIOqRJWEFyZAGv1b1n8pTQhtUn3tIcQ3sw/lyrw03NcU+5HCo4fE5fFwEHw+6GE3UVpo6mM7q993fKmHIwOT3ypZEB9x4w5kRJqGrMAAvtA/TV4dfBffsqzN6AvIkMsakKQvpHb/uVdgQ6B78adG4lpAOWy75UkcI4Gvpa2KKdQabi5Ag7qkELmsOlBy7p2ziF/o69g4XAtZ3Uj+g9byWdxApLNHhUYYMb4QSxha4UL1gfwetFPtZKIvkUD25aaFEC1tuoXjBVrE56kvlgP/KQrJ1Kdc5SVZmb5C4AHe9QwMWmeikZmlbna0XArMeL6H3yBLP7QOyKRIgkScr4WkNS55MkkijdwA4G+AjkDHSy+a/ths0encBdTgdFwTSrkxdBdaPYAeuKb3vrDCiK54ln/H/zr43xE4fZPBhrffRZD0AgXQCSrBsaUPA/qE/AKVD6wfoGYZJ69UdSTOwBfsjlDMlv9leMqU/5H59nPfxKocjUeVf19iuHNlRxHPHv0G5tb3Xkwiq4u0vkE88t6+Pr+3+0knE6yEUpIIvJhZrpXKhsTksx74bRg/piJ/Ix4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MzY1dU9GcEc3V04zT0w4dW41WURBb2J5Nk5FSTVaaUVmU3JtZEpqcllKczFn?=
 =?utf-8?B?WmtRWUpQNzgzQldxZDY0T1M5SU8zTmRySWlCSHVTS2dObU9aQ3NHcFo2MkhI?=
 =?utf-8?B?QzJ0ZU5sRUFjd1loR09qN2NJSFUzemYyblVmREpGNFg5YUF1VFhTWTJzLzFF?=
 =?utf-8?B?VDg5WndxN0dONXFwNG9hQW44bEpIZ1JGb1J2UzVVWS84NWRXWGpUb2w5djBz?=
 =?utf-8?B?M0lTZFhQYlRzeUlnKzdrYTBsK2FoMVFkM2d5aHVxZ0ZuWUVpaTI4VHM1Y3Fa?=
 =?utf-8?B?aGtjdHp6RDloQjJkV3RqNWFvdm5NbDk3aWZCV3FveUozOE1xZ21MMWwrZU51?=
 =?utf-8?B?bzBIYWRqK28zTmJWamNLc2IxRGNJZkV5Y3IyTDFoSHV6MVA3VVpwN2dScGZo?=
 =?utf-8?B?QkwwdXRJMmZNZUJibVQ0TWF6MEZUVFhQUTRiMjBHUmhqaVVNU2dkdHJBeTJQ?=
 =?utf-8?B?dGxya1NRdGNHOWw1YlBVWDhmNitzMTdiSktnZlc0MjgzemZhNjMya1AxamJ3?=
 =?utf-8?B?ZVZXYW9BbEg3TGlsNWIvSU15L0w1NDJmRDJ0Rm10YnBXMllwSm41TFBUODBR?=
 =?utf-8?B?Tkd2b2RzZ2ZnYitnV0ljOW12bU5LLzNRbGJJZU9LNHFJeGMyYWk0aVlUUEJa?=
 =?utf-8?B?elByUndkdDBkY2N4MnBsckUyT1ZGTTlzaUs1aHd6WEFVOFE5Tmp1SFQvblZr?=
 =?utf-8?B?bHFIY2ZseDE5bjN2M2dyTitqRUpzRjNmMmErVnVDMXIrVU81L0R4M1RaL1hW?=
 =?utf-8?B?eWFzdGZ4S1RFenRNVzdBSTQ1amFqQzBqSXJ3cHRWZnEzLzRUYkg4SE1ybDVM?=
 =?utf-8?B?a3RDMWV0K0c2cFluSWlIMnZCT3N0NXNjNDJDN1FPU2M3ajdlcnIrUUFDc0xQ?=
 =?utf-8?B?SUNVTWdVSDREOTRudU1FUWVId2p6clNOMU1nM2oxWkdPZ3JwUnEwWStHaTVu?=
 =?utf-8?B?SVdSMkhvc1ViM3llYjI5RklMSXgxdkJHYTBnbld3d3lLaGdwUVYyVjMzZUt0?=
 =?utf-8?B?UUtGZWdUQ0phS2F1a0dWM1dvSDVFMG5oQnhLZjhoYlB0SmxGNkdZdkhLME1y?=
 =?utf-8?B?amdnZS91amxWMEdyRFdja0VuenNlK1pkcVNCeUtIeE9JeGUwLy9ucXZCbS9P?=
 =?utf-8?B?MVFjSGRQNlNlZUF0bmRQa2pEWU5NdFJpL0crTDhXb2NxTlJDY3dsOEJHL1Fr?=
 =?utf-8?B?WC9SVHAvWHZRbC9BdEhITGtlYUxrZ2Zhc292dTh6NHBpMzhYK2szc2xaQUxI?=
 =?utf-8?B?K3VXeEYrNWFqTVgzdUhQRkpvczQxTGdMN1FiVXF1OW1TZUJtNE11ZEJxaGJ0?=
 =?utf-8?B?WlJyaVNZeXMzWGpIL29GT0ltWDJaUzc5Sis4aWs3L1dtVk1UTkh0MDBTT055?=
 =?utf-8?B?Mmt5WWRxTUlCcG5HMlV4a0IvTWJteUZkVlBJK2lncnlDS2dCUzV4cGR4RUpa?=
 =?utf-8?B?NEk4dUhHMUNjVHkzUkwvTnRoNTBESW82NjRlODI0T3lmTGZINmZ0ZDd4MUs1?=
 =?utf-8?B?OW1ORncrbFBaaHpyTWt4RDJWUHd3ZEN2R2J1M1N6UTIvNDlpQ3dZZElubUlS?=
 =?utf-8?B?Z2FKMU9wVVZzOERKdm1RM2d5dXB0MktoZnZvdmFzZTZCamdsS09kditnMFkz?=
 =?utf-8?B?MzFXdWxwRWdWQllKSk5qRW1SNEJ2MXBON0MwT3NkQVZwbjVGbnNUT2VlMXNt?=
 =?utf-8?B?cjh5VnZVMUsvVmZHTXFPUnRyTGgzUHJiTG55MHFCN3Y0RzBCbWlLVDc2MzRj?=
 =?utf-8?B?bm9mOHJTdW5JYWlubFlKMUZYS3ZnYU5kS01jUG5ZVkxraVJEUklmYm12eHVy?=
 =?utf-8?B?RG5MbmJrOFJQa0lYNjJBZ2g0bmdjYmFqZkhyaG5ScnNGS2o1QWZONi9NL3gz?=
 =?utf-8?B?RHFwdTZYVi9tT0pDZUYvbE1sU0h6MjF0U3RGVlBBTWNJM2dJK0FVcUNkM25C?=
 =?utf-8?B?OUN6ZjRndTJxb05OaEVJTGkvT0crV0YyTHV3cEdkWlQyMkR3T0I5TVhxbGdj?=
 =?utf-8?B?aTV2TWg3SDN1M2p1Z0ZwMXlJWDJwdm9YOUdDSThPS1FydTFVTmxqaDBMK1Fq?=
 =?utf-8?B?Q3VFazQyMHhLeldBd3ZjdU9wT3BSQ1BPdEorTnBhMHBNbGlMMi9DMWhUUDlM?=
 =?utf-8?B?VlFPZ1d1bjRVMWVqeXBtbXZycEh4VXZwQ09QTTZSdWNNOU5GQTl2VXBYTEpO?=
 =?utf-8?Q?LKk7bfCfJ0XcVGLxzuw3bUw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C205EE7DBE96FC488794F5609F076B01@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83e9da28-e13f-4446-4212-08dc4df4a064
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2024 00:27:03.7738
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IWkE9O0PVO8noiyPMC7hBaslm8HB4Oy7qpFnLNZp+Jzt1hpqLS0xdqh13tP3SUVO1q+K4oMObGQ21nPmSmbRxiRxt4qz+KC+i1WLUnkDsUs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4795
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTAyLTI2IGF0IDAwOjI1IC0wODAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6Cj4gKy8qIFZNTSBjYW4gcGFzcyBvbmUgNjRiaXQgYXV4aWxpYXJ5IGRhdGEgdG8g
dmNwdSB2aWEgUkNYIGZvciBndWVzdCBCSU9TLiAqLwo+ICtzdGF0aWMgaW50IHRkeF90ZF92Y3B1
X2luaXQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1NjQgdmNwdV9yY3gpCj4gK3sKPiArwqDCoMKg
wqDCoMKgwqBzdHJ1Y3Qga3ZtX3RkeCAqa3ZtX3RkeCA9IHRvX2t2bV90ZHgodmNwdS0+a3ZtKTsK
PiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgdmNwdV90ZHggKnRkeCA9IHRvX3RkeCh2Y3B1KTsKPiAr
wqDCoMKgwqDCoMKgwqB1bnNpZ25lZCBsb25nICp0ZHZweF9wYSA9IE5VTEw7Cj4gK8KgwqDCoMKg
wqDCoMKgdW5zaWduZWQgbG9uZyB0ZHZwcl9wYTsKCgpJIHRoaW5rIHdlIGNvdWxkIGRyb3AgdGhl
c2Vsb2NhbCB2YXJpYWJsZXMgYW5kIGp1c3QgdXNlIHRkeC0+dGR2cHJfcGEgYW5kIHRkeC0+dGR2
cHhfcGEuIFRoZW4gd2UKZG9uJ3QgaGF2ZSB0byBoYXZlIHRoZSBhc3NpZ25tZW50cyBsYXRlci4K
Cj4gK8KgwqDCoMKgwqDCoMKgdW5zaWduZWQgbG9uZyB2YTsKPiArwqDCoMKgwqDCoMKgwqBpbnQg
cmV0LCBpOwo+ICvCoMKgwqDCoMKgwqDCoHU2NCBlcnI7Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoGlm
IChpc190ZF92Y3B1X2NyZWF0ZWQodGR4KSkKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgcmV0dXJuIC1FSU5WQUw7Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoC8qCj4gK8KgwqDCoMKgwqDC
oMKgICogdmNwdV9mcmVlIG1ldGhvZCBmcmVlcyBhbGxvY2F0ZWQgcGFnZXMuwqAgQXZvaWQgcGFy
dGlhbCBzZXR1cCBzbwo+ICvCoMKgwqDCoMKgwqDCoCAqIHRoYXQgdGhlIG1ldGhvZCBjYW4ndCBo
YW5kbGUgaXQuCj4gK8KgwqDCoMKgwqDCoMKgICovCj4gK8KgwqDCoMKgwqDCoMKgdmEgPSBfX2dl
dF9mcmVlX3BhZ2UoR0ZQX0tFUk5FTF9BQ0NPVU5UKTsKPiArwqDCoMKgwqDCoMKgwqBpZiAoIXZh
KQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gLUVOT01FTTsKPiArwqDC
oMKgwqDCoMKgwqB0ZHZwcl9wYSA9IF9fcGEodmEpOwo+ICsKPiArwqDCoMKgwqDCoMKgwqB0ZHZw
eF9wYSA9IGtjYWxsb2ModGR4X2luZm8tPm5yX3RkdnB4X3BhZ2VzLCBzaXplb2YoKnRkeC0+dGR2
cHhfcGEpLAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBHRlBfS0VSTkVMX0FDQ09VTlQpOwo+ICvCoMKgwqDCoMKgwqDCoGlmICghdGR2cHhfcGEp
IHsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0ID0gLUVOT01FTTsKPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZ290byBmcmVlX3RkdnByOwo+ICvCoMKgwqDCoMKg
wqDCoH0KPiArwqDCoMKgwqDCoMKgwqBmb3IgKGkgPSAwOyBpIDwgdGR4X2luZm8tPm5yX3RkdnB4
X3BhZ2VzOyBpKyspIHsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgdmEgPSBfX2dl
dF9mcmVlX3BhZ2UoR0ZQX0tFUk5FTF9BQ0NPVU5UKTsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgaWYgKCF2YSkgewo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgcmV0ID0gLUVOT01FTTsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoGdvdG8gZnJlZV90ZHZweDsKPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgfQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB0ZHZweF9wYVtp
XSA9IF9fcGEodmEpOwo+ICvCoMKgwqDCoMKgwqDCoH0KPiArCj4gK8KgwqDCoMKgwqDCoMKgZXJy
ID0gdGRoX3ZwX2NyZWF0ZShrdm1fdGR4LT50ZHJfcGEsIHRkdnByX3BhKTsKPiArwqDCoMKgwqDC
oMKgwqBpZiAoS1ZNX0JVR19PTihlcnIsIHZjcHUtPmt2bSkpIHsKPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgcmV0ID0gLUVJTzsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgcHJfdGR4X2Vycm9yKFRESF9WUF9DUkVBVEUsIGVyciwgTlVMTCk7Cj4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoGdvdG8gZnJlZV90ZHZweDsKPiArwqDCoMKgwqDCoMKgwqB9Cj4g
K8KgwqDCoMKgwqDCoMKgdGR4LT50ZHZwcl9wYSA9IHRkdnByX3BhOwo+ICsKPiArwqDCoMKgwqDC
oMKgwqB0ZHgtPnRkdnB4X3BhID0gdGR2cHhfcGE7CgpPciBhbHRlcm5hdGl2ZWx5IGxldCdzIG1v
dmUgdGhlc2UgdG8gcmlnaHQgYmVmb3JlIHRoZXkgYXJlIHVzZWQuIChpbiB0aGUgY3VycmVudCBi
cmFuY2ggCgo+ICvCoMKgwqDCoMKgwqDCoGZvciAoaSA9IDA7IGkgPCB0ZHhfaW5mby0+bnJfdGR2
cHhfcGFnZXM7IGkrKykgewo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBlcnIgPSB0
ZGhfdnBfYWRkY3godGR4LT50ZHZwcl9wYSwgdGR2cHhfcGFbaV0pOwo+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqBpZiAoS1ZNX0JVR19PTihlcnIsIHZjcHUtPmt2bSkpIHsKPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHByX3RkeF9lcnJvcihU
REhfVlBfQUREQ1gsIGVyciwgTlVMTCk7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqBmb3IgKDsgaSA8IHRkeF9pbmZvLT5ucl90ZHZweF9wYWdlczsgaSsr
KSB7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgZnJlZV9wYWdlKCh1bnNpZ25lZCBsb25nKV9fdmEodGR2cHhfcGFbaV0pKTsK
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqB0ZHZweF9wYVtpXSA9IDA7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqB9Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAvKiB2Y3B1X2ZyZWUgbWV0aG9kIGZyZWVzIFREVlBYIGFuZCBURFIgZG9uYXRl
ZCB0byBURFggKi8KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoHJldHVybiAtRUlPOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB9Cj4gK8Kg
wqDCoMKgwqDCoMKgfQo+IAo+IApJbiB0aGUgY3VycmVudCBicmFuY2ggdGRoX3ZwX2luaXQoKSB0
YWtlcyBzdHJ1Y3QgdmNwdV90ZHgsIHNvIHRoZXkgd291bGQgYmUgbW92ZWQgcmlnaHQgaGVyZS4K
CldoYXQgZG8geW91IHRoaW5rPwoKPiArCj4gK8KgwqDCoMKgwqDCoMKgZXJyID0gdGRoX3ZwX2lu
aXQodGR4LT50ZHZwcl9wYSwgdmNwdV9yY3gpOwo+ICvCoMKgwqDCoMKgwqDCoGlmIChLVk1fQlVH
X09OKGVyciwgdmNwdS0+a3ZtKSkgewo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBw
cl90ZHhfZXJyb3IoVERIX1ZQX0lOSVQsIGVyciwgTlVMTCk7Cj4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoHJldHVybiAtRUlPOwo+ICvCoMKgwqDCoMKgwqDCoH0KPiArCj4gK8KgwqDC
oMKgwqDCoMKgdmNwdS0+YXJjaC5tcF9zdGF0ZSA9IEtWTV9NUF9TVEFURV9SVU5OQUJMRTsKPiAr
wqDCoMKgwqDCoMKgwqB0ZHgtPnRkX3ZjcHVfY3JlYXRlZCA9IHRydWU7Cj4gK8KgwqDCoMKgwqDC
oMKgcmV0dXJuIDA7Cj4gKwo+ICtmcmVlX3RkdnB4Ogo+ICvCoMKgwqDCoMKgwqDCoGZvciAoaSA9
IDA7IGkgPCB0ZHhfaW5mby0+bnJfdGR2cHhfcGFnZXM7IGkrKykgewo+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqBpZiAodGR2cHhfcGFbaV0pCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBmcmVlX3BhZ2UoKHVuc2lnbmVkIGxvbmcpX192YSh0
ZHZweF9wYVtpXSkpOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB0ZHZweF9wYVtp
XSA9IDA7Cj4gK8KgwqDCoMKgwqDCoMKgfQo+ICvCoMKgwqDCoMKgwqDCoGtmcmVlKHRkdnB4X3Bh
KTsKPiArwqDCoMKgwqDCoMKgwqB0ZHgtPnRkdnB4X3BhID0gTlVMTDsKPiArZnJlZV90ZHZwcjoK
PiArwqDCoMKgwqDCoMKgwqBpZiAodGR2cHJfcGEpCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoGZyZWVfcGFnZSgodW5zaWduZWQgbG9uZylfX3ZhKHRkdnByX3BhKSk7Cj4gK8KgwqDC
oMKgwqDCoMKgdGR4LT50ZHZwcl9wYSA9IDA7Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoHJldHVybiBy
ZXQ7Cj4gK30KCg==

