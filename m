Return-Path: <kvm+bounces-16471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A4E08BA539
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 04:16:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 64F311C21E31
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 02:16:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62C2D168C7;
	Fri,  3 May 2024 02:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dyt8s143"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234D8E556;
	Fri,  3 May 2024 02:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714702562; cv=fail; b=WctzLU2V9/mYClKoNNR4KsyopsC+i+8NWqxxisfgyEhDIZTvPea/7R9sokeikbRdplIGkE8MpADGdMalEINp2IANWhPqg4Y6SrT+ESirCcSydm6X8AnA0MfJmNdNcN5v4uT+/qt4i1pRQd1c4vb6x+grB1w5ahm7k/2U/CfKEpI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714702562; c=relaxed/simple;
	bh=Qyx0y9T6ndVu60WqcPrtNmSupsfFOKDHVxqRyG/Np8M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bvrEJv3BPff+vbPOiQ54F4QPJtwDJR0pW5I7PrOySaLSge/kjF56TvNYm1ArlubpdrUUMbhB7jfC3FQ3fylqMLGFGBgRi4XUNyNzMhHZ5t2KwXYlOzREVjIOvFXPJb92lZlnAqDHgtwjQs1KrdOX61ciY7g1CBSlXB73GeNz+mc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dyt8s143; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714702560; x=1746238560;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Qyx0y9T6ndVu60WqcPrtNmSupsfFOKDHVxqRyG/Np8M=;
  b=dyt8s143F9qwVLwld8HMqtgEGbEerXAbOISNCqYelF1slsWlsjd7x05e
   gezvhQDR0DllL62Ci0Q/qhj40DcfY43/J7tw4u/+NDKhrc/78ToErBmH2
   t8LxyoJJfeevBsFIG/kKRsCShje76bXqyXWdaqbXHesglJOUD/ZQpGNIr
   AbFmRfRZqUDpCaDMKizQOz6PADnVkNPAEe4lvMthsbAeoXl/e2bC1aNIp
   LvfHy3K/scIiM6QOtcmgkbQFuJ7kebicxiIlt+/x/IAajIhpiSpulwqsO
   hUWu8qLSe10qDSTdTQBsiy8MQxZkOQr2PA4/INqoGG/UNFfpmS/jDO74+
   g==;
X-CSE-ConnectionGUID: JzWZ3XPaS2q6zbsE4MtejA==
X-CSE-MsgGUID: N7vtIZSkQcOGSnU8nixLGg==
X-IronPort-AV: E=McAfee;i="6600,9927,11062"; a="27983685"
X-IronPort-AV: E=Sophos;i="6.07,247,1708416000"; 
   d="scan'208";a="27983685"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2024 19:15:41 -0700
X-CSE-ConnectionGUID: nO1Xi1TbRCSyLQxQszwhBQ==
X-CSE-MsgGUID: /BrSIRqnQA26okr3RyBuoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,247,1708416000"; 
   d="scan'208";a="32114362"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 May 2024 19:15:41 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 2 May 2024 19:15:40 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 2 May 2024 19:15:39 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 2 May 2024 19:15:39 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 2 May 2024 19:15:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DobTfLPFUEtEEOq0jpqJERkwowdu6Jk22HdTFIiFL2CXEDWFRWgMXdWjvhph5YRPhQHmmn3yc0qa7M8LN2ebMmSlAzyosyNwxJ1S5m83F4KG32Q0sNmdy176NbUHEHExwUeSEK+KI1l+q4dZaLORJt+T7G0BLvAx/JxFfv/xDikv20PgAIelqyc2WamaI5jr4QWzUgFgY8Zrn6KmY56gb30I8o/pOCXazDd0glrFo/YZ1j69H7uXlXxH27CqP0Yl4lkPa8iUeA/Sq6pE4AAFBxZdrAZoZ5Lb5cq1gqWouTR8lAc2wbAFIScl6WY6mWIY4FUJZDD6ixYTR2lDadKPDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TQa5rZry8zfvj2X2pQ0ALoTOO7rs7jHrINegEvLWyAo=;
 b=NVooWGsaxhV2C8uVFRZEWdgDA8T9daSvsJ0dzFAXpZx9Ng5mvQ2cziPgFD38cyWCWi35P6k/MG6KkKtFqQDAqyRYiVvutOIErXJ1otnsOT9nfp5a7cb8XzGJXQbmd1Syq8eKDiOKYLwoQKVBUWfCafd1s5fMHopNm+J9h12qvCpHaLwSIrhWNa3wc0kp5igv7kGVU5d2k0hpsCTQ2I7hfrenHk/YPLeopFuNVjp+TnoIGr1E7lBvtf9u1zyH2R6KKFoGafKwfQLiUQP4BWHj60zqcnwk0tqqjd9+QLkWNmfsRzsJsZFxkPnUQu2AITGVxZAQ3KRcbrQJuU0vPeyeUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 LV3PR11MB8604.namprd11.prod.outlook.com (2603:10b6:408:1ae::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.28; Fri, 3 May
 2024 02:15:38 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::2dd5:1312:cd85:e1e]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::2dd5:1312:cd85:e1e%4]) with mapi id 15.20.7544.023; Fri, 3 May 2024
 02:15:38 +0000
From: "Wang, Wei W" <wei.w.wang@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 3/3] KVM: x86/pmu: Add KVM_PMU_CALL() to simplify
 static calls of kvm_pmu_ops
Thread-Topic: [PATCH v3 3/3] KVM: x86/pmu: Add KVM_PMU_CALL() to simplify
 static calls of kvm_pmu_ops
Thread-Index: AQHalw+NriuTQtnWX0+9HT1Q2NE/m7GEpN0AgAArYgA=
Date: Fri, 3 May 2024 02:15:38 +0000
Message-ID: <DS0PR11MB6373EA67C70B8579A194089EDC1F2@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20240425125252.48963-1-wei.w.wang@intel.com>
 <20240425125252.48963-4-wei.w.wang@intel.com> <ZjQjYiwBg1jGmdUq@google.com>
In-Reply-To: <ZjQjYiwBg1jGmdUq@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|LV3PR11MB8604:EE_
x-ms-office365-filtering-correlation-id: 91511715-b1f6-4567-be88-08dc6b16ec7e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?us-ascii?Q?TkUvxb0lMycK2xAfasym+SRb+dUf8GAGPx37uryeP6shyLzTUzL1sIx019//?=
 =?us-ascii?Q?95UaImhlkjvvcgZur0S5WSmtdecuzH7o/twSAg5zephJowTfBDDjMrtuc130?=
 =?us-ascii?Q?a4NywnaFSRvDajJvdY/Odx5OIRKeuLYMGDIWLTVqSlP/fOq4NUaj9tzfL3ES?=
 =?us-ascii?Q?u4mxwfqYAp6oGgSDilsod8iXziHFSyJbbGTL/aqmgS75o4xBRblWGJ6tVn/r?=
 =?us-ascii?Q?B2jdtqyyM2tHkosDv0AI1SvaDjAqZBIzkwenF44QzEkDfnDAAIf6OVfkNfU/?=
 =?us-ascii?Q?Ib91PHJEc+5uKP/fkYIpq7hCAfCoBxui+v+oU8mQDcIjXZ5q/3dOVEU3Q09+?=
 =?us-ascii?Q?FxoM7XSaaTlmRUSY+UUVTQ/N2FSBDjhQsZzs3CmF9+dybTuH+w27CczB1akM?=
 =?us-ascii?Q?DyJvzRfK4GScD8FjrJSuzW4MAcup7MG8Ga7c5XsqiefEUc9CpIzaHYoHpxfd?=
 =?us-ascii?Q?z7YpmOPO8du6BB0X33VohSX+W5CDoF1ESsH4uzEqZ2CMnXTuZDRH+Lw/6XzY?=
 =?us-ascii?Q?MQeEEv8+4kUiXmod1mTqoLIdpxVaT8Kch9BUirwNfONdFIiIEQVR4NiDU6vd?=
 =?us-ascii?Q?mT1y5q+zpzMtSladeTGRQYlVxSTFKWhvdmC2lwu4wmsvU76wflk0FpP4QYj1?=
 =?us-ascii?Q?WZyAiS6Ds45Gm7UtKUhTeIWDM8/hgpSoDxTI2euV1G4hnLkwxgrnPJJ7baXz?=
 =?us-ascii?Q?fIPDn3RXBFzhwQuglbHPR8+zZm7hyTm47R0D84xnhjz0gSm8bUXSCQXHu8HQ?=
 =?us-ascii?Q?1wSwPApSLBKI9IO/Pzeaw4mDCjIQxWcxyRKEGEF6PUFvgM/X7+6b/3X+cxcE?=
 =?us-ascii?Q?ewx0S5AgIojaI9mZbMZoyB28yPE7NFN57gzyM0NolyYRZvFmZ/YSaz+487yd?=
 =?us-ascii?Q?5vcrJcCmvC6ZOyQcqk8eB+UH41ogQ9vwDc3zKcnls+8kWHtPQXpehklc7XNE?=
 =?us-ascii?Q?Be+qE8y9Xj/uagNShdRkvXPQdl4OsYWryJSKus76spyYvtdZ+jZ6hXxOhI3T?=
 =?us-ascii?Q?zYdSmJstPwDoGmDf6pUWVwsKvd4RcBVKYDKHj84ocY++wq7UGsltkVc6AnQv?=
 =?us-ascii?Q?l14m+UoQlnUIXPcl1zgFJuivLbdrws5w1NfrTCSlydqqnP1fNEDvfY4mGIzy?=
 =?us-ascii?Q?gab1FLFGjVk9ff1tHxocDHu5qiXeMjagYmswrzw/n65meeDdps22ludZydWu?=
 =?us-ascii?Q?er4A2yHDAdvxs2dopJj6PRYe83pSd+mXqtTCG+Ywb2XOhK/1MRMGYUA744VW?=
 =?us-ascii?Q?3awJHhuy1EavX+o/iqMFcaDVt3l3edBqQ43KkoN+u67UJbQhda3ofr2v5nJC?=
 =?us-ascii?Q?rF49hyiQgV50NAO3rvyOChnfojI0XU9kGcbiiPnqpABUHQ=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?o4krxRYCQqvKM8wZ2fElz7FaN1C6hO/W/bnG9kbCU2rTcWcaytfSRIk0XWFK?=
 =?us-ascii?Q?zqrbydNWh2U8F9SX6p39KBY7LHsYd/ZjFDz6CTlT52yrPKABcSkKQhEXvStb?=
 =?us-ascii?Q?llYl9TeJR8AzDvXgvJlmqJieS2Sg+WA9eO6J7bhFgMBwm3eo2wsRlzGJxnQY?=
 =?us-ascii?Q?KW9gFycrmVzHSgaoYwvQVKG5RgwR9BesBM1AuZ6kZ8dpbQqbIQAdU+X/9kxK?=
 =?us-ascii?Q?u3f00u8i5TcbtCGePiP3U3kLsZoZrR2FtR0LApBoDl99epigcPmZxfBY8YYt?=
 =?us-ascii?Q?ldpkI7My9+VCa9TMbOk5gvrkYzMy6VYIIrhAZtGPaW39BC/ln5EnKBaQzpvC?=
 =?us-ascii?Q?z2u63+yABS73uabvdpPuNxkdGix2grFIcG3KPrdsu1qZ3CxyxYgCQEYNSdGS?=
 =?us-ascii?Q?+ManDanOsDQymKQdbdyCknEFfYyWrPyP5abm8vHY/3FunwoDbcj3CvBnBf0V?=
 =?us-ascii?Q?eJh5pl/ouOa1GX3EVKeVHb0NEa06x0GBoKnwVx4cn10Gr0SMLsExy62cuQmb?=
 =?us-ascii?Q?wejFbkCZUlYBty/Tkx6UrqAq8yTK/tPbghhyvBv5q2LNNvYfFcQKq8D/X7Ht?=
 =?us-ascii?Q?4DNIbG92dKNhOB+MZmZapJ89egYBqt0EokGtcXwQ+tJO5bwg71HS6T7IKjQn?=
 =?us-ascii?Q?CdcKy3MTq988R+qmpjvMQkWUHnGE1cBEWx3Kiz2mX2/QlQz1dKa0xKvUStV/?=
 =?us-ascii?Q?6vnyLfuaLpWZWcZ9WGapjqDlnNz2DABrfxKyHeHQa87ycAIoRvTLFymYInng?=
 =?us-ascii?Q?Mij9Ty++mj1Rfj8DUSM1UZOI7fhm3AdqJe6Bgyb9vmKiRE6tsIy6c7JmTqsH?=
 =?us-ascii?Q?OdW5LVVAx1JCnyAGeoW9IzKL+Ln7Ot1kH3R35Cc9Ntb6z1iNqNyUt1Ay/J9s?=
 =?us-ascii?Q?TKYTEt2kaMrtHiSQ8vDGmE87NdUoYcU+8LYzIJMdmfzIu39S6sQA0CvwqHF9?=
 =?us-ascii?Q?AVA3Bx9yTajB0A8YnDwmXYdnVjFjwOMgVRYxeVHBeIfqZWKY5PicpJSKXOQm?=
 =?us-ascii?Q?e5drIuzwoZkOQkwAU8xd+2yZs3i/TdI+BVlLVjbilYDWo3sQNnh6LTne4HLo?=
 =?us-ascii?Q?c+dAkyJ5V7KOwBnDYPgaoclLpCjmynCDKMyk96oHWxwTDzsb7s31hzN5rzd2?=
 =?us-ascii?Q?VrfTOKc6ld75/OPzmv0fau1Zma5y4zApDw4UpFAUXC+Wp5kC+BOMx7zBgiKY?=
 =?us-ascii?Q?hhGxbtO3gs87Pa8LgectdWuzgpAssp/QkVKH0hUW6Bei2+LF7jlPrJE6DxsI?=
 =?us-ascii?Q?7L6SVgTgv2LN/5CbmaRGhymSoKoLmrYtCB5FPdU6Lt8GcEPNr3ko3pcVk2qT?=
 =?us-ascii?Q?/qhd3r3sM5AqdiENdfdv8MEP+IJj0pglAWCLdR6mf9t3YiNVWCYeeyTvi56+?=
 =?us-ascii?Q?WeWnc7iKnDpT7nQ0MZ7xHBl9xV0b22b+hME9glJJMZc/+ujKLPz8J70BNaw9?=
 =?us-ascii?Q?jEqinhY8cXKp89J3oNT86UD3fnwnkWDQ0WLj0jmipDfHPoAmZ3RapMO2T03L?=
 =?us-ascii?Q?90Vu5As9rXGi7bcH7L0OpL2WVpSYe+OH21p4XDLzmXc7SiNgT5ax6SKuUY3f?=
 =?us-ascii?Q?jBOAbnXS9HeHnGS9zaC3IovJg3srKCjlFk+p4kGr?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91511715-b1f6-4567-be88-08dc6b16ec7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2024 02:15:38.0711
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nJGZCVdBUb4kl6TI1UnifqlSuEtEp7OLpWWUK6L0y1/xjRZ+VRM87WQxMfHCpgAdBoJMqq19+cgL7DyEFynozQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8604
X-OriginatorOrg: intel.com

On Friday, May 3, 2024 7:36 AM, Sean Christopherson wrote:
> On Thu, Apr 25, 2024, Wei Wang wrote:
> >  #define KVM_X86_CALL(func) static_call(kvm_x86_##func)
> > +#define KVM_PMU_CALL(func) static_call(kvm_x86_pmu_##func)
>=20
> ...
>=20
> > @@ -796,7 +796,7 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
> >  	struct kvm_pmu *pmu =3D vcpu_to_pmu(vcpu);
> >
> >  	memset(pmu, 0, sizeof(*pmu));
> > -	static_call(kvm_x86_pmu_init)(vcpu);
> > +	KVM_PMU_CALL(init)(vcpu);
> >  	kvm_pmu_refresh(vcpu);
>=20
> I usually like macros to use CAPS so that they're clearly macros, but in =
this case
> I find the code a bit jarring.  Essentially, I *want* my to be fooled int=
o thinking
> it's a function call, because that's really what it is.
>=20
> So rather than all caps, what if we follow function naming style?  E.g.

Yep, it looks good to me, and the coding-style doc mentions that "CAPITALIZ=
ED
macro names are appreciated but macros resembling functions may be named in
lower case".

To maintain consistency, maybe apply the same lower-case style for KVM_X86_=
CALL()?

