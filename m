Return-Path: <kvm+bounces-20580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DE76919B72
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 01:56:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A18BC1F23E9D
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 23:56:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C55A1946B1;
	Wed, 26 Jun 2024 23:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H3UbqpiE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E545194159;
	Wed, 26 Jun 2024 23:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719446169; cv=fail; b=g4xVps2ftGGetKabwe0tTPR1//DhbrN69CfRiQe32Nj7OH5lQE6VZPkyxilMI/fhlYFYmYuNUKcGfryJ0K5Bl1y6WA4VAEuEIEzA9gv68S+l6puAGrwr7H66EXHUKTQGoJttImEImegeL/lHf9GQOXaWVdAUYpeLic8EsKSnxCo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719446169; c=relaxed/simple;
	bh=u56XqYVNW7eGams8M/hOEpW9CnFyPGjlpnuQ1C9YemA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WXZG+im+PA9h9vwul/6DN30nvLmPDJQ64tSbizSwLKuHhxxRDjdCW+mlM+G8AaNIoqxfGND+UrhLuUrz/fLwVciJKrmnfI83MexulYmg9YEikVgteD+HysfdhsVzkjok+3ees7OWd5V7Sh1qR7+pMcrW4IwNOeOhqOubo8rUyfU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H3UbqpiE; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719446168; x=1750982168;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=u56XqYVNW7eGams8M/hOEpW9CnFyPGjlpnuQ1C9YemA=;
  b=H3UbqpiEK++JZFxfsIL4IlCLcqUdY+kE1hWRcKMqKoB5Bnw44pQVIyNl
   6jh/POPImIbYVa9Sbw0UUsoAJ7Q4CblM3nxbAvOxpRflLZS4eGViWIZIZ
   RvMzSNraTG5v39EdAitN9YVEjUmPi0ReTFMWV2wO/AFuLE6gsx4xZFl0L
   Rp24g2Lberqn6+mZLNoW7fWqMc8QTv5sIQWbWErBhSgPTUMt+CqbjCaMJ
   g6wlYEh3LjrVZu9dufwSqDCG9gF+nqAQHyURoLlR4gkNUGbEaFzmuiyY4
   GmBFKHTt67jHhPXhwpmT9OBGfRNbiPzIB3UMHAn6mwN617R0bE3I4XPMa
   Q==;
X-CSE-ConnectionGUID: 6LSU8aQFSwSY2sF8cEce8Q==
X-CSE-MsgGUID: TA+tiOeGQ5uUmhwat98qNQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11115"; a="16386996"
X-IronPort-AV: E=Sophos;i="6.08,268,1712646000"; 
   d="scan'208";a="16386996"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2024 16:56:07 -0700
X-CSE-ConnectionGUID: vvcGxW//RqKyXF7iZxq6wA==
X-CSE-MsgGUID: 6FV8eEM0QBiIRAEwiRae8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,268,1712646000"; 
   d="scan'208";a="44303499"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Jun 2024 16:56:07 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 26 Jun 2024 16:56:06 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 26 Jun 2024 16:56:06 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.49) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 26 Jun 2024 16:56:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FJmJb86sxo68NdD3PalgPPHrkppbos2wq9PzMs39VBC479PiEUZJcYXbAnvnGusDNLel6ADfal8yk8IMHOSEiNPNqDM9GVLBa2vZkSHnH4vVXe7OQQF/4S/4TIMMWg93j8xd1sxGEhHpyRzLfyYluN6N/d8LeRTVfx4JpRHVkwnLEjf+p3Fu2eKnsRyMYUqm/AMNZIgoIzYeYhUV5mxQXukpoKdE7m5IwTCtKVFLy2FjBQlAgMiJjJQK9r7YrZoQV+1ls2zwVRDkpT+Fox4ty5xGhp+UVqUAA3mKKVN+M1P7psCimor4mR4X3+4WRH9pbIo8IadUN2Ooy7508OsnOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d+INiWfE85x5nkthnmaQmYkSd8GvPiAHTyDRULbyKqA=;
 b=U+OEfOSKn4px0HbgUJe6S41NjP+Y71GcxV1D10QhK1Rt/LCIKssZTlYqWl+IYl2a56FdJltGbCQ0tY/+7R7bp5CJCATsKChTmiN0QmbEQ8XPvKmrOwDuOESaTtrdX9RHDN2jP47VpSkdQoz0oB0/29iVtpFAH/zfEsIbECJQZz7F1ampdN7t/PvzWbjqcGr1j3qUXn2o1nwwGP8VrEqoUgFiN+QWkEH9KliDROfs0U6xv/WL5r8qWMxlPgGVcV9sKLVxKiFqZTSxCMVo50+XYQHfl/u1tb26XOuWgbBOOnwDGAyZk4fwjqUlw7LLEo1qMB86JeSQ5CY9mxUmacjkcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB7412.namprd11.prod.outlook.com (2603:10b6:8:152::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.32; Wed, 26 Jun
 2024 23:56:00 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.7698.032; Wed, 26 Jun 2024
 23:55:59 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"peterx@redhat.com" <peterx@redhat.com>, "ajones@ventanamicro.com"
	<ajones@ventanamicro.com>
Subject: RE: [PATCH] vfio: Reuse file f_inode as vfio device inode
Thread-Topic: [PATCH] vfio: Reuse file f_inode as vfio device inode
Thread-Index: AQHawJxm3I/CN7lO/0SZyxULdM6QfbHaGjEAgACpYlA=
Date: Wed, 26 Jun 2024 23:55:59 +0000
Message-ID: <BN9PR11MB5276951FB77A98CBD6CCF79C8CD62@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240617095332.30543-1-yan.y.zhao@intel.com>
 <20240626133528.GE2494510@nvidia.com>
In-Reply-To: <20240626133528.GE2494510@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB7412:EE_
x-ms-office365-filtering-correlation-id: 0f6f2f4c-f7f2-437a-42d9-08dc963b8763
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?wnTKcuyHgd6t3GyTDoLi9Ppo1UcUqn0qoBPtIg/fQ+jZsAmhxRz9oJKEplZG?=
 =?us-ascii?Q?dAOCmUAtWozDPQK5IcWuj9ME6I8qgnu7wF4WyRmAyk/x4NmTucqa9q1v/qVv?=
 =?us-ascii?Q?b4tqlzJRlO5BXO1xYfQN/3/qIhJZmkjIEIc5JMqV/qDy/lEDdonKPCk8OhKf?=
 =?us-ascii?Q?CTHe7R0VCZEa29e4l2G4g+xmLZGeY8bf2jfP/vtsapnAGFoKjOBZNS92tGUt?=
 =?us-ascii?Q?BYrIB9KLyo7BCxedvwEFXKFg0OtbCk0Lj3nyNZIIULt0YJZJEEUYudlN7dNz?=
 =?us-ascii?Q?i2ikW4/9H/fM7cXW/wC7W0cpvOF0HSO7eZMZx5+3cCzBPZwJWoQ75sEg6REJ?=
 =?us-ascii?Q?J/3E7QylIynbiaUR3iqwGaUsYpg+jLSfiTJmKexzrGqY5c7AUN7O2EkSuPPL?=
 =?us-ascii?Q?3R2EuF91nCTDKDlU1/RwrSNnC5IdbvHfIo7gF4SyKGv/xAT2nGL0Y9uHgiWZ?=
 =?us-ascii?Q?KyT86OuVbAi+ntNludDgE7BA5DWtHGhe6CdF9Yic9wXIz5ufGwDswtHn9gKv?=
 =?us-ascii?Q?QN7muQmMXAxhzkANWKxqk+OhPxwojIAHlP3LB5lR2+tI9eQnArcn2Bt/kgCt?=
 =?us-ascii?Q?NGTtITDZXCdNxsrJLIPEb2dwRAByqhAehlZlqwUr/GTsZt4FJUpN3HZNssvl?=
 =?us-ascii?Q?W3UTDWiYijz3XkTSyzDlb3yeWj31aQZJPWVbVlw46U2VL/gkir0ACOEG1qpg?=
 =?us-ascii?Q?65POwotS1jzaDM+87xbTpDgP0BMoJnGjQ65CnBihJtABxDv4aBEX5FUZbpUU?=
 =?us-ascii?Q?qnMStoinQ0UpYErQE0U1ybnG/j3zhQ943+NGnpcDBsF5QuuBgJOoQhNO6woh?=
 =?us-ascii?Q?xDuMTnw3h+//ge7DyP7tAHbDzBb7poLq6CZ0b+E8X76OAJqBDFbeH26zx2Lx?=
 =?us-ascii?Q?BazeMdGSBe2ZfnU+sqpMzxYWRW3SejcwXKEGKXhFAn8Ix4uWacWTox0DtLwp?=
 =?us-ascii?Q?eK53JriNIyH0krScWtCVbo57j52D9AAK1TD9Kb3UHqc0FL+GiQE2p15Btbh7?=
 =?us-ascii?Q?nJaTQ9BGox8Shhe+xOlEatFgK5dGyi7CuZW2uJOA+3gJ4kbWNaKfIEMHZ1dh?=
 =?us-ascii?Q?tuY1IESWVRktt3afhW37SFRCc0u1stUJOTTgTIK9ScJf8Bi6j2wlewa6YYN/?=
 =?us-ascii?Q?NR/tphsShPlVsoqMDjtV4DDQTqxolu9q4UKtUz1K1pb09nuDGI4Y2kswZrab?=
 =?us-ascii?Q?0QcnbjDvufEErfXaiP9FQSbSqBFMF4Ys7jbW15xMrbrLcKoEBeMzb7Zw5ihk?=
 =?us-ascii?Q?hZVmnjRWR3kFrbXNQcvMp76/HovgxJMiwmZxpC0bm1F+P4uwQGstTUVnyN6T?=
 =?us-ascii?Q?HWu0BAO9+KSqM3VMi90wTF2CwPVrksi860cPzk7TDOXzjIgUCXSra1xS8dMR?=
 =?us-ascii?Q?rgFH+versIh9mjjhIolZFmRp+0pN/ZIkF6IgpXuEsLdevLjksA=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?//j71jGJ0c0+c6JX8giBAlIZAqr3JNJMb3lYoDPhTfsfWGXOUFaYRozKlfAO?=
 =?us-ascii?Q?T0HVf2r8V+ubuZj6ni70qw5pCPFdL8qtM/G9hF6MQW81uguWe+yF1Vqqj7qY?=
 =?us-ascii?Q?5rspwsHdGnDT+AALFxbcIFFPeG+OB+OqnaPYcLsE0MVT0bNgMgZV3rJS23G1?=
 =?us-ascii?Q?WoJ9WlqQgdr7mlQDn+rLxRQlF4h82sPGIPgIjsd10AlLlg1eMzxNDFQsyyH+?=
 =?us-ascii?Q?6t1Nd6OZ6o+6Pk9eIJlIY2QGpbBIkkrmnJgRathZZkBd1dUtofJTOWH0yYi4?=
 =?us-ascii?Q?65ApjND7VIQxnV33KI9hKd3kVEIy32s1LyqNDenQYih5+VHYNuWjAI/6M4zM?=
 =?us-ascii?Q?CTberRFnEzZllViItULeNBStTpyJoWEzJwkfTZ19r4w8jMP7MNbsBwh3BCTJ?=
 =?us-ascii?Q?ErwrAPXZKOrjhdvlr07DcCMsJHLN/omhD+/kT2P8r6q9eGlE1N374QRoA3q7?=
 =?us-ascii?Q?eiNfzXQJrAyIzKJC2D8qYb/1mp4QYOGOP87vFYe6foI7PRDAZrGEWgXgKMz1?=
 =?us-ascii?Q?n01Gcg9jVDFBkq0puWpJGzhOcwoy8q+eDguNSDjzdr3Ow3SIWv+S19xpq3Yr?=
 =?us-ascii?Q?Wx5Usi5u7CWfRokaJSZohyOK60bYcUrHmm7ZYCBSPW3BJ8Rfig20bsSVQ5jb?=
 =?us-ascii?Q?HUgL43MaTrOL1o7XjEv0Cx8iCKvyimfRNM2dTPyPmDg2MD5+pu+72HzN4LLV?=
 =?us-ascii?Q?qUHyOy7svcCjmEl773aS8cizWmTmADtgAMljNjB7QNdSSPR9JKBy8uc67TLO?=
 =?us-ascii?Q?zU+r1T79scKPj/ZClx83ucIG06mkEDISziviTksU9shji+cgpM7AkkLAdiuF?=
 =?us-ascii?Q?fSjuivOwnWuc+dYnhdHBj3f1XGh4KwXf5pXruaEUob5s+WfsqrmtfhqlnDO1?=
 =?us-ascii?Q?UQXQRgSe+FCak69eJ7oZYF7BMs4emc/9B1CYSZekgNSwesIBbIz1z8njuMdW?=
 =?us-ascii?Q?48HM9puGs6UDIW0Ft4QBfkTEaVcxPahROhgB6fuwyqyGlumlBYHnHbV9sheA?=
 =?us-ascii?Q?RLTMYPyLCaMXpbOZhf42xxplSuSb+CrvTGB3kGWZAU72rqNe0YD2UTBhD9sz?=
 =?us-ascii?Q?xkrXqUgB0NGfviP+rQGE9U0rOrHd/idMJs6XOzi75oWgIax1xGKZIOG3q5jU?=
 =?us-ascii?Q?xrfm6rR6KmAKtjq1cNxU2FsnlrnFnIDHbMTSRhJhC+wautpW136ETdYjONTs?=
 =?us-ascii?Q?v8uwZjx5vjSzZZRhfNk74MNipiLzhOKcyleB8NEYwZvbssnN1AEsUNPN+6Sx?=
 =?us-ascii?Q?anl3GA2XF8mRnVbjqw0IpYqQRmsY4ZiWwCKIxMXgw2m3J+KwzYR9nvgD4+9c?=
 =?us-ascii?Q?6Qc0gzmK2ZP565Oip3/Ig648ZNwwpR1BBM352KfqWdOrtSf4cEMCZexgAWnN?=
 =?us-ascii?Q?h7sn1JpHVggQIysxG20fMspOsq3Nhp3vqy/SL1OATlVoLdXi6jsowuY1Xpcv?=
 =?us-ascii?Q?QmC9l6Frf4F83ZpwP64C3sk7Vcvkb70OYyYfMht4TgTDVdLPrgLSdrI/lRkn?=
 =?us-ascii?Q?KRYGo0tXdqToYvY8MLs29/2k8Anobtb64R9gWbBsDq62y+gFHlpFMn7pMlFx?=
 =?us-ascii?Q?9kMOiqsp06Uc5cqcx1MuLuJFL2o+H2eyEbbmbdKf?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f6f2f4c-f7f2-437a-42d9-08dc963b8763
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2024 23:55:59.8228
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rHREe/4zE9tP/kLrBFou29JBF+yijrP9QtkFt1wHZz2uPSKQoXS3l1XkYr6FYePd76wpErW6mvr6t2CXRYMkgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7412
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, June 26, 2024 9:35 PM
>=20
> On Mon, Jun 17, 2024 at 05:53:32PM +0800, Yan Zhao wrote:
> > Reuse file f_inode as vfio device inode and associate pseudo path file
> > directly to inode allocated in vfio fs.
> >
> > Currently, vfio device is opened via 2 ways:
> > 1) via cdev open
> >    vfio device is opened with a cdev device with file f_inode and addre=
ss
> >    space associated with a cdev inode;
> > 2) via VFIO_GROUP_GET_DEVICE_FD ioctl
> >    vfio device is opened via a pseudo path file with file f_inode and
> >    address space associated with an inode in anon_inode_fs.
> >
> > In commit b7c5e64fecfa ("vfio: Create vfio_fs_type with inode per devic=
e"),
> > an inode in vfio fs is allocated for each vfio device. However, this in=
ode
> > in vfio fs is only used to assign its address space to that of a file
> > associated with another cdev inode or an inode in anon_inode_fs.
> >
> > This patch
> > - reuses cdev device inode as the vfio device inode when it's opened vi=
a
> >   cdev way;
> > - allocates an inode in vfio fs, associate it to the pseudo path file,
> >   and save it as the vfio device inode when the vfio device is opened v=
ia
> >   VFIO_GROUP_GET_DEVICE_FD ioctl.
> >
> > File address space will then point automatically to the address space o=
f
> > the vfio device inode. Tools like unmap_mapping_range() can then zap al=
l
> > vmas associated with the vfio device.
> >
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >  drivers/vfio/device_cdev.c |  9 ++++---
> >  drivers/vfio/group.c       | 21 ++--------------
> >  drivers/vfio/vfio.h        |  2 ++
> >  drivers/vfio/vfio_main.c   | 49 +++++++++++++++++++++++++++-----------
> >  4 files changed, 43 insertions(+), 38 deletions(-)
> >
> > diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> > index bb1817bd4ff3..a4eec8e88f5c 100644
> > --- a/drivers/vfio/device_cdev.c
> > +++ b/drivers/vfio/device_cdev.c
> > @@ -40,12 +40,11 @@ int vfio_device_fops_cdev_open(struct inode
> *inode, struct file *filep)
> >  	filep->private_data =3D df;
> >
> >  	/*
> > -	 * Use the pseudo fs inode on the device to link all mmaps
> > -	 * to the same address space, allowing us to unmap all vmas
> > -	 * associated to this device using unmap_mapping_range().
> > +	 * mmaps are linked to the address space of the inode of device cdev.
> > +	 * Save the inode of device cdev in device->inode to allow
> > +	 * unmap_mapping_range() to unmap all vmas.
> >  	 */
> > -	filep->f_mapping =3D device->inode->i_mapping;
> > -
> > +	device->inode =3D inode;
>=20
> This doesn't seem right.. There is only one device but multiple file
> can be opened on that device.
>=20
> We expect every open file to have a unique inode otherwise the
> unmap_mapping_range() will not function properly.
>=20

Does it mean that the existing code is already broken? there is only
one vfio-fs inode per device (allocated at vfio_init_device()).

And if we expect unique inode per open file then there will be a list
of inodes tracked under vfio_pci_core_device for unmap_mapping_range()
but it's also not the case today:

static void vfio_pci_zap_bars(struct vfio_pci_core_device *vdev)
{
	struct vfio_device *core_vdev =3D &vdev->vdev;
	loff_t start =3D VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_BAR0_REGION_INDEX);
	loff_t end =3D VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_ROM_REGION_INDEX);
	loff_t len =3D end - start;

	unmap_mapping_range(core_vdev->inode->i_mapping, start, len, true);
}

