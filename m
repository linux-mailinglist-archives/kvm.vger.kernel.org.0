Return-Path: <kvm+bounces-21060-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7FAE9294C1
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2024 18:38:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D5A35B21809
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2024 16:38:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B757113B285;
	Sat,  6 Jul 2024 16:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cX6INluj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27F7AD23
	for <kvm@vger.kernel.org>; Sat,  6 Jul 2024 16:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720283907; cv=fail; b=ZYlD+UTxMf8n4I25WDpp4r3ZZkuvB3uOOv0Y7EyflINjcd6Y5zfokXEvV0TupJhDCfSxbpELEyh7C17qAjPGDc6KiQOd3qf4GwJORsjkm+xfP2vnkzRMNtp0+1rxnSL1tw6k7DyLHJMjZQgejl4QrSdbIADmxhr8i/9jJ5ptjdk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720283907; c=relaxed/simple;
	bh=YG6a2uMclJVIn0KESuGfDTvYwoAeU6NOnx0xhQAHDIw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=U4BdtsdG1v+TI3zXMxj6pOWrySbjHYhvpHYz1g+fK0OFp8464GR2w5gaZPh9XhnJeSFlOYd4/chpk2w3R4t83jj7pAkUIph9SNQGGpUqJbz8uw4HIzYXEmbaOLd3Tb2iWH7u98hbisyUbx/OsIpNbqxwJ4ymYTI8FqvJ8IIHRSM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cX6INluj; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720283906; x=1751819906;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YG6a2uMclJVIn0KESuGfDTvYwoAeU6NOnx0xhQAHDIw=;
  b=cX6INlujgkBc1pLmeaTfUYxW4nvbSkujhbPWNFFOK+6VOyAIhiTiWwSO
   jN4pX34Bs+Uc7AVxxVoRUAYkJKKKr0OQc774xCqm6erw3xNpHq6jUTg6j
   A+x+IdulDsanCkNeo/QneEUIEbLYd9WhNrjkfVAYeBNksewggekjvOAQJ
   T13JjqvuYOC84opM4eCCCLURvQZDq3yL33oYD33uL+tAs+ijQmNlOOip9
   tiPionYqt+D2C1q6+S+fIUAx9AR+wwF9uQJM/gIYbOiWbG6HXC9fETzoW
   pIZpLyAc8Ospt3pzaXiCBmeKdrD9QDc/0RU5/doBRmravN13wjL9nW4qT
   Q==;
X-CSE-ConnectionGUID: t6cfs6PZQbiUF7n5zJHbEw==
X-CSE-MsgGUID: lshUkJVuRmqcYZkeX/FIEA==
X-IronPort-AV: E=McAfee;i="6700,10204,11125"; a="17748475"
X-IronPort-AV: E=Sophos;i="6.09,187,1716274800"; 
   d="scan'208";a="17748475"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2024 09:38:21 -0700
X-CSE-ConnectionGUID: 6co1oruNRUmkTdGOnwXx7g==
X-CSE-MsgGUID: QsPd/+xsR/yR3MQzt5dy9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,187,1716274800"; 
   d="scan'208";a="46997557"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Jul 2024 09:38:21 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sat, 6 Jul 2024 09:38:20 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sat, 6 Jul 2024 09:38:20 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sat, 6 Jul 2024 09:38:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kW1pCHpcLnOAgjHNlcRQRs+UPfL/1TiDvz1pEMQJVC/cWHS1sA2u0lrqKD0BmORx+rEfCqgx7pA9p5X11IvDqD+/Y0AZr9kTpjkpM/7qes579zIpRswYmhsDHEwSBRh3+VOSzLR9EhPA/o7JydhipqzUMOkemsdJx8+Y5I59aGDtiVRQ7ALfyLkBmAwEYGgstNN7wGkN3lBo7FT9hzoV4utyTxNsZavxAw3Zuq16ApCyFicnzYABvwkOyVX1A4AMe5C0kUm2fxR4mYGcXAHzY+/IWvpe1jUX72adu9NyiVdfPBiQ2GrAwn417PSL8bfTS1LXome/9z6+clDCW/xXpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YAKwL1YR5bVD7Y2laKwDKfZJYoIrqBWiylnMAd5RHe8=;
 b=HXHQ9D+tYAQ59F6rDQA3kn2878nU8Q0YDRNOXXTuz35AF2/pSKBNkmP7wSHt3FVzDKWt6E7uIuQDznq8Va7rDTpL6niDm8FSkYl76UsCP1twGkq9NPZu4CfmfHOnBhSxXEX8HisoLQS5U3cYh+Sjwn0IX1BKUOejWz/V0YnWes8QeDILZ22ona05tcCRjQE9cBVYos+WDxdHQchGcXDr0IKfAPjrzzWChjJImbqIoe+3kB0Ves1GGMbW9mE9+BrkupeK+uNbzNVzr6Z1HOtMdNBfnJeJrEXwt2DSUUuKgc6jM1yIebv2cRGkKer2dcVubiODOZJH3mYjV+oWRmawCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by PH0PR11MB5143.namprd11.prod.outlook.com (2603:10b6:510:3f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.34; Sat, 6 Jul
 2024 16:38:18 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::fcf6:46d6:f050:8a8c]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::fcf6:46d6:f050:8a8c%4]) with mapi id 15.20.7719.028; Sat, 6 Jul 2024
 16:38:18 +0000
From: "Li, Xin3" <xin3.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: "Gao, Chao" <chao.gao@intel.com>, Eduardo Habkost <eduardo@habkost.net>,
	"Anvin, H. Peter" <hpa@zytor.com>, kvm <kvm@vger.kernel.org>, qemu-devel
	<qemu-devel@nongnu.org>, Richard Henderson <richard.henderson@linaro.org>,
	Sean Christopherson <seanjc@google.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>
Subject: RE: [PATCH v3 4/6] target/i386: add support for VMX FRED controls
Thread-Topic: [PATCH v3 4/6] target/i386: add support for VMX FRED controls
Thread-Index: AQHaz7q9ZjMUH5bzOkKKsRzdx5eB47Hp4kaAgAACuGA=
Date: Sat, 6 Jul 2024 16:38:17 +0000
Message-ID: <SA1PR11MB6734C2304EB31581A3DCB6A2A8D82@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <SA1PR11MB6734CC22FDFD4F85E7887553A8D82@SA1PR11MB6734.namprd11.prod.outlook.com>
 <CABgObfaG1HVQ4YEHOGy=6rX_a3cVEq5-255U6XEPSvvX0rRrwg@mail.gmail.com>
In-Reply-To: <CABgObfaG1HVQ4YEHOGy=6rX_a3cVEq5-255U6XEPSvvX0rRrwg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|PH0PR11MB5143:EE_
x-ms-office365-filtering-correlation-id: a1279213-02fd-4010-5568-08dc9dda0a3d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?s04fo7uztK/1OWXUM0GdKN9bEiX5LIpmtyVeru899gbPJmBH91UgAKbvHWP8?=
 =?us-ascii?Q?EGNMWddV93H2IDLGEfg8rzSVpGG7UzOkppK4iEtu4sTkldhw9RUcUPgdWBMB?=
 =?us-ascii?Q?LypGnpUoZnh+FyaJOq4GuEte3asPEoSnmJJxJSHy0YTvJQBSboynH/IRLBH+?=
 =?us-ascii?Q?JfAN4qs4slta6690OPuPueY+fyxFXKIATKADqlE8JHhbOkV7dMSn98bd1VT7?=
 =?us-ascii?Q?UNz0pI6DnMwgsHDQi3SbsNf7FNi3llkQDLcXiNvSvfXf5j1ITXn9TgkZ4TO+?=
 =?us-ascii?Q?oWCkNFgLH942P/0BOn8sLpFX3YrQUH5uhkrDigkTTE18bJ719/sixISSRNDh?=
 =?us-ascii?Q?V29qAwW3OFAwztcxQKyGKa9CRZmL0DXOhEJL1WcsS/elL1tOr9DnxbcCKh9u?=
 =?us-ascii?Q?NzgBxsLXaZrsWTo9tNC12Y4lO1ihrhJoiaRTY44bU+wAy/FZ6xr0RGDzqo/b?=
 =?us-ascii?Q?TBu0aY4RZZj2OxJUgkk3ECW+SniXn2BvsLX0c5ip25ORwN0px+WfpNLtx12C?=
 =?us-ascii?Q?UKTxcOzp/Kbeg2I90ZfOSy6tqVrkEqqvzEacDUJx/EVhGUxzQvvqDb5e5mmU?=
 =?us-ascii?Q?IgDrufY/uuYWjMvssuzLvJjBNvN4fsR1d2ro1903dlNc/nXQj+3q13YcvDkC?=
 =?us-ascii?Q?wkNryvAKOVDYiIUHyclwQlGmH8F8l6rPuqV/vLv8PFz36rNx6bsqMoxVH1Oq?=
 =?us-ascii?Q?fP24CvJefnVF9hpT3RZC4t/xt3CNKdCv2vzzrWk0JTBOfHQwcq96TE9/nwUG?=
 =?us-ascii?Q?Y2qCGc4bdggh0nIQFRWp9bb+Pu55O0E1gzSfzLxVzedIx7lbq3Kx9bNR407M?=
 =?us-ascii?Q?F7Hw3hBUf5xCyZ0z1IOmJhsPT0FKuD28ZUYvU0SCXfhFxFkMQFUMm6QDwcuc?=
 =?us-ascii?Q?taTU//luVMeyEGzjDIFB4kxryiT/2xeD4TpgsEhjRBXP9rgZNyIuWQh/ZOXZ?=
 =?us-ascii?Q?LTmJKq8Y1DIwx/C3hoWp2IEq/n6SWAB7Br1Vw5pz2rLHDlpEdPawjla63qxX?=
 =?us-ascii?Q?EeKjUczZk2jGAw4UzbvKfzeRu4oUYRpbe51ialjGsYBD6ikYSSXBQ1gtint4?=
 =?us-ascii?Q?WCR2mcPxmw9+fouoO0l6buRESsLExlA/doiFG/ifd2d9WC4OIxrG63/S23/d?=
 =?us-ascii?Q?8rOcjjRu27teyGwhRZdh17ZG+k/IBTp0a7P1GS+3WAnkxMgRrzn+1wWfQ280?=
 =?us-ascii?Q?TyGkNBVX3XkZ3ekqgMJymc+Z0huR45YwUZAtq8tYMod36UL3A68mkxvFkwFe?=
 =?us-ascii?Q?ekOE0ixVDklxoMcuqk6NwFM0FYlUYODUuLtYCWchb+DT5Van4fDIL16HlMr6?=
 =?us-ascii?Q?1miueVCpFcPm9JC0X2QRdWN3gCjJA0m5Sk2aeOxa6GfNIinqfVwWpvp78qcT?=
 =?us-ascii?Q?RSp7P9g=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?t3alw1YAnFewlFh4eDRXhwtsKQ9172pslYCIQl+fXJZlz6vqQv6/kxbH2iBR?=
 =?us-ascii?Q?jNkTVig7yPyDWZPbX6ljT3+mvMVnj85/4TQYnHjYRDYWgG9b/pnPXOuIVuSK?=
 =?us-ascii?Q?/TbOMGGZJo8d62khpzcf0jI9PQnt0FwaMVZZsvlyJN1sRmFGh1MUPopIY3ha?=
 =?us-ascii?Q?jxPZLsSEaojQERk3bZG2O97UH5Yj++Er1kTEdAunxR4s9COpnZn14Sqn2i9o?=
 =?us-ascii?Q?aQuw87Hh9O02ApNSwJiARig4dEO1zA/kWDqgG9nvrnj0LtZans+oHyFM3Oul?=
 =?us-ascii?Q?4p7ixji1AI2nq5C8LBKa+h3WDTu3xwrzpjcwm18zF3LDJfHze8Fk0zTDNbGU?=
 =?us-ascii?Q?jz7UimH6fVf9dQb17N4woT9x1cAHf/l/WUzIDVoSpEMhdvAYlSNLgGrwa4Y5?=
 =?us-ascii?Q?0lx7tJ2amQ5k//adN6IR01weI03Z08WvZJl6jZ7rSOVAguVGQeF6cPLgT/eP?=
 =?us-ascii?Q?lK4E+RjuB0eInaMk2dRFtVhpGWfs7cw5STsqJU1jTCMFO3V58IfI00mn4anO?=
 =?us-ascii?Q?+9VhdDQ/oSb9+QYEBZMpn5hoxOWyIvqI/EZwGl396OMgZUqUB9TGEQGfxGKu?=
 =?us-ascii?Q?4HOOReqa6eBur9TOhVC6nxcN2h3iJdOKZZKArvIrmlzamismeaOdZa469/WF?=
 =?us-ascii?Q?5WfAHXU4FsbFOlmkyxzgVGQaZ3RkEE4gbMtneITJkionuuxr7lX7ppJSSarG?=
 =?us-ascii?Q?WFdYF1EqmFAJgrVbvspyAeLTN5j/bXcYJ92GzY7FO+6rDUyOSUODhwYmd7UU?=
 =?us-ascii?Q?PBBFxhASOH+C6s2dv0s7wVyuCoW2bhkV9rnHm78jOyGc6HiI7spTEScSNCUU?=
 =?us-ascii?Q?RQuBVATg1V9+AbOSm634+WzazSyAveY9Y/nDc3MolPDLLZD3aAUO8Jn1LfR9?=
 =?us-ascii?Q?eQvtrpqSqK74fkmQOOkyr8mHlPIB8PdHrspzRwe/bRN7XPtM99aDnTJTHdX1?=
 =?us-ascii?Q?gkyqnpegZaQrvgr7mEbsQGuNVcJ7eomPKaBWZU9DTurenbcEeT1jEFO/TrNa?=
 =?us-ascii?Q?4IDTYnKh5NScyyflaxTJOK/SAp5GW1Fb3bDa1nk7+YmlVS4VNSZIrUVvdkze?=
 =?us-ascii?Q?2S7Tc6tYKg5RD7aA4PWZqMG3IUGcibrHoAh4W/g7gcfsJz4pNgYtovkngldn?=
 =?us-ascii?Q?2OdhxL5EtRD3dDWVQVV7dhYZ262qQW42MRSkZ/yfhraJ9k0ArgEmkm1k7BCz?=
 =?us-ascii?Q?QpEw4GoFiEyjdZan4EeGJ+ge4ylsaCC9/pavMTuMTZgzm8ZtoZvKUxRQ2a/i?=
 =?us-ascii?Q?QsWL3T8p5ObLBArCJELJOkVwaroYJhz29/AjAU5sFALJjp5lgYZohjHPaUWN?=
 =?us-ascii?Q?5oWIs+/7apjmxW4jonqq36gc4gYyUl7b8CMIEOVG7N7o+gUzXZSNuhfVhT0w?=
 =?us-ascii?Q?6EPy5rpl/Kl6W6xEkLMjIQm7tt97Z7zqA7XRMUUBxIm7tJb5Z8AbEWyaAWlF?=
 =?us-ascii?Q?NbwN9TDzhVBOPWdUjMQv4H6G1QWHiei2dAOpFQRus9WkrohpyFamraDgSQro?=
 =?us-ascii?Q?BtX/rq/W77MhsoQTRX3sZaJVP6F0ljzj3a0ECRZFLsPC3dji/9kWt0VEYPhi?=
 =?us-ascii?Q?jF2y3V3oR01WPwmZaRg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1279213-02fd-4010-5568-08dc9dda0a3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2024 16:38:17.9489
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IC9e6s5HDhc1GwCzKOp84MtfpudSaFpGVoeCC2ugamZNOeX1SLl4BUueOFgAtakNvFeN/zGufhZ/jnMgM+3GiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5143
X-OriginatorOrg: intel.com

On 7/6/2024 9:23 AM, Paolo Bonzini wrote:
>=20
>=20
> Il sab 6 lug 2024, 17:57 Li, Xin3 <xin3.li@intel.com=20
> <mailto:xin3.li@intel.com>> ha scritto:
>=20
>      >> The bits in the secondary vmexit controls are not supported, and
>     in general the same
>      >> is true for the secondary vmexit case.  I think it's better to
>     not include the vmx-entry-
>      >> load-fred bit either, and only do the vmxcap changes.
>=20
>      > Right, we don't need it at all.
>=20
>     Hi Paolo,
>=20
>     We actually do need the following change for nested FRED guests to bo=
ot:
>=20
>     diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>     index 227ee1c759..dcf914a7ec 100644
>     --- a/target/i386/cpu.c
>     +++ b/target/i386/cpu.c
>     @@ -1285,7 +1285,7 @@ FeatureWordInfo
>     feature_word_info[FEATURE_WORDS] =3D {
>                   NULL, "vmx-entry-ia32e-mode", NULL, NULL,
>                   NULL, "vmx-entry-load-perf-global-ctrl",
>     "vmx-entry-load-pat", "vmx-entry-load-efer",
>                   "vmx-entry-load-bndcfgs", NULL,
>     "vmx-entry-load-rtit-ctl", NULL,
>     -            NULL, NULL, "vmx-entry-load-pkrs", NULL,
>     +            NULL, NULL, "vmx-entry-load-pkrs", "vmx-entry-load-fred"=
,
>                   NULL, NULL, NULL, NULL,
>                   NULL, NULL, NULL, NULL,
>               },
>=20
>     Or do you think it's not the root cause?
>=20
>=20
> The patch is correct but is FRED supported in nested VMX? Or is it with=20
> not yet merged patches?

The FRED KVM patchset has support for nested FRED, but not merged yet.

It's here:
https://lore.kernel.org/kvm/20240207172646.3981-1-xin3.li@intel.com/

Thanks!
    Xin



