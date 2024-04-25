Return-Path: <kvm+bounces-15904-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8975E8B2012
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 13:17:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 420732883DB
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 11:17:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 570EC85626;
	Thu, 25 Apr 2024 11:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RkIn5QQu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F4584DE2;
	Thu, 25 Apr 2024 11:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714043836; cv=fail; b=uB0yQZqSpPoMzDMEIp49IvbyPYF7o/YyCparIVGVka+Ks1BdO51JjGwNBkF/MSkiWg8Ql7V0C5QPpJzS+GCVH9b9pneP8mw5cAIS1H5UamwppFF01OcqubiMLGo1eMlhidPXJbRPEmkmr3dTxzKK0x5+AIqMvTvZt/mhlbqKDTY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714043836; c=relaxed/simple;
	bh=cd0gTq0VGjnfySmwVBKDaIIMG3UhRFYKn5zHoLURQuE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mgdtVdacX29D2vv/oU0vRL9IvjfeOnMlmI96qPTZlD9GisvEFxHJi9JId8+rirhUOvQLOMMrhu6ufdKfCq28PL9U+pNDhGQHpfmM3QjI6q0Zr2nBnPGAdsHZWnumVvctgiEcxpGKJjYtXBMXoO3Um7T4pfR9bqqr0BDw9EtAzg0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RkIn5QQu; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714043834; x=1745579834;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cd0gTq0VGjnfySmwVBKDaIIMG3UhRFYKn5zHoLURQuE=;
  b=RkIn5QQuuXlnKieiRl8a4lPwySR2QTCRIWfzM054FUsEKdPBwDNxv/2C
   TEGxMDMtZv+UVSRKUoqyx1ElNA6V1aD9qmh50mNJgeABai4UjoGFhk+0C
   5BPcbzvxXtVZcoczi+dh6oTJUAI4V0H9m/xxky6ePW6qnHg/0W5dI1YJq
   a6RUXGd41U+g48xNtDSpAe7QGG/+QeoGRb89B/2uGshjjjiACUFYw+aZG
   rxJ0TIjMU5Igy6uhz48SFCQArWHL1WP/9Mn5E+NRRpLVpoGZFN/pCQHtf
   sBSMOuOlc5mVqbUEalia1IlrAK78o7mQRV43q7xtBEFJ66l4GWIFXVGjJ
   w==;
X-CSE-ConnectionGUID: LWIUeMmwSzGs+FzHFM0Yqw==
X-CSE-MsgGUID: TgS6leuCTHuIxTWex+YXfg==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9939591"
X-IronPort-AV: E=Sophos;i="6.07,229,1708416000"; 
   d="scan'208";a="9939591"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 04:17:13 -0700
X-CSE-ConnectionGUID: hWgB6qMJSmWIzqa6qBFGiw==
X-CSE-MsgGUID: Js5dNzcUR52Bgc0BXZWrXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,229,1708416000"; 
   d="scan'208";a="29831469"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Apr 2024 04:17:13 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Apr 2024 04:17:12 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 25 Apr 2024 04:17:12 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 25 Apr 2024 04:17:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SfKvHr+nKgNAwLFVwlwodUsgxSfNvcTISLHwBuqPd9IwB+2FKmhryPOmvgAtoWh72J7dNdSANeFdvNBbPd+1ikatIXR7bY0ZxZq8h7CMM1c9svITOcqYftOdhltqkUWd2JoKcfCnXBfLP0vaLfD+rGArFM44z4t5BxPgoWZuK7CXf2nMoF0nrw9YtJHr5yJg3vdsbvNgAYIKXj8TPvWUGcuCrB1Wo727PwUJV1JSrZ2PoJUA87gbVBf4MeWtmFkkVwjLzdqnq/Lw19yBEpmCPjgxVr05jj7mF0nnAUVM5lgl4s2foIunDUwcr45VHQBoKxNCVILUx4hd1exDCOZQhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ZuwaDndajLqOKbfi7JXlhl0jSdIUcMdUgxGQHAcZ1E=;
 b=DHXIpP+Qmo7c3bw+q4XHEBj7XG+Ef68P9m0gxqEx7hD0u8B4p08ctNhYSR3Lmc7xUerUQTOzvCcRNRfcuGnJElIegKwtDUCi17z6Eupucg2bVzvWSmrD62MxIqy2OnXygRPTUaljg1rK2T97MF/Ed9ase3/nYCaqLwHaA7D/pTODneWzF4zql/0mwzfhNY9C7g+MkwNjY72DouDhdT4JvloNMWBLzCtEYJE84I7GWS6LPwMlvHswZJb9+y4i1gZZR0x+Yeu3FfmwUMf52qmIOLjTtwkngDuQ17vZaSE+IiTOryWF3trY+moD7WpPBlu3RvF2fgPecl0c4HRxt6UWUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 CH3PR11MB8496.namprd11.prod.outlook.com (2603:10b6:610:1ba::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.22; Thu, 25 Apr
 2024 11:17:10 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::55de:b95:2c83:7e6c]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::55de:b95:2c83:7e6c%7]) with mapi id 15.20.7519.021; Thu, 25 Apr 2024
 11:17:10 +0000
From: "Wang, Wei W" <wei.w.wang@intel.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/4] KVM: x86: Collect host state snapshots into a struct
Thread-Topic: [PATCH 0/4] KVM: x86: Collect host state snapshots into a struct
Thread-Index: AQHalcvOvJHKHdG+PEK5/c2S4LZHsrF4V4XA
Date: Thu, 25 Apr 2024 11:17:10 +0000
Message-ID: <DS0PR11MB6373E404A16BD8CC55128FDFDC172@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20240423221521.2923759-1-seanjc@google.com>
In-Reply-To: <20240423221521.2923759-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|CH3PR11MB8496:EE_
x-ms-office365-filtering-correlation-id: 198f5ed8-215b-47fa-cc69-08dc6519404e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info: =?us-ascii?Q?7B3bXEYUgp3pilsSwRt6YoFjQXKEk23hDEb3QqhdxXbqPTIjVbQLQ3lKG0sG?=
 =?us-ascii?Q?x/b80KA0s6/TxYJ6eXHSn7E2e9EJuF94tj5mJd92eHZGEPoM1FndR7ow2hKV?=
 =?us-ascii?Q?OK9yPNOm+pChEQ2g1Br7haXAmSDasxehWQLpPf+BD5xDpHhOX+B9OFgKAYiO?=
 =?us-ascii?Q?LZunHTuKdbrVgP8sceYhBZILMgeskBQmZryR2hzucTdw/A46mBBbjb8BE1Ng?=
 =?us-ascii?Q?gloKJ5E0RA6Q3v/JmaSK5DzNjciDwguVsVZcSZcq1OrV6jfInZm44ILaZFTr?=
 =?us-ascii?Q?gqRFjG629KOFTwGOuAB+gN6swdy19fBbu/zCxPji7mWENdacKKGh6WXx1E2t?=
 =?us-ascii?Q?GuGf/7ScNyleuk6V/823AC7BfKDKLSQBGePo7JbZp/hSrNG4Ne8lI0NBKivY?=
 =?us-ascii?Q?R040vFVJw8fFUev07uicqlW4MRc/LxsDBrM6579p9DPRf3nIc26ZpQ22xcZX?=
 =?us-ascii?Q?oL/yYi/xXkYwCbcFrWd3Abg5pKXAHcgU/yL1OSk50F/SUOpLfVqFtpsURaB8?=
 =?us-ascii?Q?y9e76dZKJWiAVhN11a0vBcTMpHcuVBATClQj+TRHt6icDnpW5Segq6KhKVjo?=
 =?us-ascii?Q?yJeLSmSTagJZkuLmQqu6KmFm3fUB2r2gIPh2ZpaohPCwxecUZCnKAtxl/wwH?=
 =?us-ascii?Q?YQ7qNL84CGN2kUKayEuqVmElgjlZDmjaSaj1/J3i91olKPlRUDa104G5uePr?=
 =?us-ascii?Q?Mq3oPgnBgY4AcUfced59m3xUj1N2U3g61hHR5oL84Fsufl6t3HCPPORWDOV/?=
 =?us-ascii?Q?+3KIrenEDXxy3WYje0lK3NejOSNnqzcQ/5oRYIlwIcO0ZCjJFCzTDYU3Wioz?=
 =?us-ascii?Q?sAB9OblBfPS208ERFcdw4NSL3BzFv8sjoY5B8cm8q2EVH33VAyXr6ryYatmf?=
 =?us-ascii?Q?H/l02FJhkwUYs/9obAE0hJPsjVpkPqq3pTgNpF0E13OsUNKOmGT1yQTrtTaO?=
 =?us-ascii?Q?Xk3TQlad6yvSkojqWC2u1pyUK35uzc9YVbF9z6n4klEId1I/chEfIbfNNKix?=
 =?us-ascii?Q?xVMuz86jv0raOXikCCEwzhwXlE3v3XL35Gcfa7VBJWKFeYrJnqYbtfW7yf58?=
 =?us-ascii?Q?GSqHYi2uJafDxUMEAYuyRDAhIAmuHe+xqvgwriuU2aVTFOQ7iMpEi32dJ7/x?=
 =?us-ascii?Q?4xuRRF0Pj82ha1D3vvXcG9LWFAhHUW4qDbTD4WNYuMP6UWcRIJwkCTA5xX9f?=
 =?us-ascii?Q?w5QLWIzdliYaWU4kU0DPmKLWiqRqkXl0jYOesjvUb6QNhusv4AFaMwnDx9Fz?=
 =?us-ascii?Q?KJMKrquICnjP1s8gBk47Y7uEICZNTaEdEkJIQu6y7P8UM6LoISJh2XeWMD4U?=
 =?us-ascii?Q?N4juWN+fwsT3Mnoo37ZKXZl4iKmjp2jhIGaz6CiC0Ssq8g=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sogQWL7SU7CMNhWsOYPnXibIlaM5+I3THdJUNQSKqMsYHoByCWDnjU1myCN6?=
 =?us-ascii?Q?v6617cIOubsO+xBBKVs3/FfxeiFTkEXL7BSlpGZI4cW3QdxWeRnX1cZfNumf?=
 =?us-ascii?Q?a/jkLkBigIjbEyRdX3zNPsTNmSvMR5D3IEmqsuZJZ7GULbKXIV43/x0uI4TN?=
 =?us-ascii?Q?Y5l2y4utMt/p925W5X5mgiBzo0m9FTpEPHO35LllEX3oRM4r0qeaU/89e7Jv?=
 =?us-ascii?Q?lDjr0LzRp5HfEnKd5WPjon8xTuRlLcB+nnA8eTHxXUL3RqayBIP7ARJuP7/5?=
 =?us-ascii?Q?4jND848iy5CIoDmoN75Sa6UQjz/x17Cw1cQ1siwV3DWE8t5eSrYxpprUfJaz?=
 =?us-ascii?Q?gEFb5TmUCHx02SCnKZ+JUyi8yP9u0w52bXS/uG/1ca0452WYRCge3i+0K98v?=
 =?us-ascii?Q?3h9GiGcT2qm0qich0GIeUtZera47cp4d1udT0A2ALDPtPYdC7oaXXeMoHheB?=
 =?us-ascii?Q?Ds9WEWJ7AanALe/YG9+v0Gi3VOZQ6GCsut/Iyjotkmt3Xu95dM2OZ1UHYBoH?=
 =?us-ascii?Q?5ddN/QEmlhvzyTao3Dug3LQ6QjEkX/2gNPdJnRDSJucL8NYi/B4QFwwcODch?=
 =?us-ascii?Q?BtCPm6DBJMQAWOdadU/SAKsXBq6dRHRtyVfoJ44uQzBeJuV/bPxxAUipvkNu?=
 =?us-ascii?Q?g4eVZErn3PoIFE4myV+79hIPYS2HgpyTmigcOcyBuHC3TFWywJgREJzbi5IT?=
 =?us-ascii?Q?3ux4jUjCXIKHzUpU4xygGO7OY9+NIbKf6d42a8ZTxH9pPFirnSgc1+N6V5c8?=
 =?us-ascii?Q?1hBnUhJVOHBGHq13ZnLroLL/mJ7bUu9jm7qqiefd845nq1bLYmQcxCr5QULg?=
 =?us-ascii?Q?OzxRlGR0rVEpDsCY4qIh7eofoTmi9OynotQtSlVG/G31CcraaeKOS2HfEvYj?=
 =?us-ascii?Q?K5mj317ji3BK9HmOrqpmPQ5QknFD+0UyL+/BWAoY6AsvhqOlCnmN49leSuk1?=
 =?us-ascii?Q?nt7vRQAClPEgUvgRJQ71znd3dLjTanm3DcHh2wymovK+jD7PdbWJ/cpBpLgo?=
 =?us-ascii?Q?Mhr+eMaVCryU2b/1p2xiDqw6OmVxCBY41wd9l+5XWfh9G9LtHK3oymGdc3oL?=
 =?us-ascii?Q?zwUo+i3TP7fu6J65xZgztjKlzJuQe9f//47dniKdV0rS/cL1bgNKLtNmB6Zs?=
 =?us-ascii?Q?aOQiaU7AGQOuW2zPedfRdpkkhXhUoIXk6wQNHuZvC57CcdrHa/5q8hNYAXYt?=
 =?us-ascii?Q?tu06jY0YlTh8Hp02qZ2pnhaCNQz+rc37OKRSsMGXal8nmvBE/ruq/hM6ZaSS?=
 =?us-ascii?Q?99bYGE/rqcPm8i+GzmvwBI06GpLCickzz1ltm3hAmR/KzTVv0jjO6/mNb9x9?=
 =?us-ascii?Q?r7JwDmpaJVhz+LzA1JxmIXRvAhf0nPRuO5+Ms0EYdvLLviZzVmE/Bh8y/wey?=
 =?us-ascii?Q?kPyls1YBlBEBhcG4ptobXv99JNpfxiYyCK8zgFqHslWl89hodaqt2BpadPpS?=
 =?us-ascii?Q?HItr1CORqHLwKxF2datTCCqS8gOJywU35yKBNywhW8IyQLXycVaYJjly0UVO?=
 =?us-ascii?Q?u48IiCPgSZTKovDsgbx6hNo+5z0iwlLpOvP2C+4U4S/aINDIs3BHaZfcyOo4?=
 =?us-ascii?Q?2MzeeVYNkjRsM1Jx9pG85/314GgD/NVoBVW/dUWj?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 198f5ed8-215b-47fa-cc69-08dc6519404e
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2024 11:17:10.6978
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nnghFogDEuG1MCQgpWs7EjMz+PGy2UVF8SBV+cxf3KA3jLGKNgGhCRxRMai4vC/POxUU6onq5lcTMsfvdmSsxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8496
X-OriginatorOrg: intel.com

On Wednesday, April 24, 2024 6:15 AM, Sean Christopherson wrote:
> Add a global "kvm_host" structure to hold various host values, e.g. for E=
FER,
> XCR0, raw MAXPHYADDR etc., instead of having a bunch of one-off variables
> that inevitably need to be exported, or in the case of shadow_phys_bits, =
are
> buried in a random location and are awkward to use, leading to duplicate
> code.

Looks good. How about applying similar improvements to the module
parameters as well? I've changed the "enable_pmu" parameter as an example b=
elow:

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 77352a4abd87..a221ba7b546f 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1013,7 +1013,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_ar=
ray *array, u32 function)
                union cpuid10_eax eax;
                union cpuid10_edx edx;

-               if (!enable_pmu || !static_cpu_has(X86_FEATURE_ARCH_PERFMON=
)) {
+               if (!kvm_caps.enable_pmu || !static_cpu_has(X86_FEATURE_ARC=
H_PERFMON)) {
                        entry->eax =3D entry->ebx =3D entry->ecx =3D entry-=
>edx =3D 0;
                        break;
                }
@@ -1306,7 +1306,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_ar=
ray *array, u32 function)
                union cpuid_0x80000022_ebx ebx;

                entry->ecx =3D entry->edx =3D 0;
-               if (!enable_pmu || !kvm_cpu_cap_has(X86_FEATURE_PERFMON_V2)=
) {
+               if (!kvm_caps.enable_pmu || !kvm_cpu_cap_has(X86_FEATURE_PE=
RFMON_V2)) {
                        entry->eax =3D entry->ebx;
                        break;
                }
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 4d52b0b539ba..7e359db64dbd 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -190,9 +190,9 @@ static inline void kvm_init_pmu_capability(const struct=
 kvm_pmu_ops *pmu_ops)
         * for hybrid PMUs until KVM gains a way to let userspace opt-in.
         */
        if (cpu_feature_enabled(X86_FEATURE_HYBRID_CPU))
-               enable_pmu =3D false;
+               kvm_caps.enable_pmu =3D false;

-       if (enable_pmu) {
+       if (kvm_caps.enable_pmu) {
                perf_get_x86_pmu_capability(&kvm_pmu_cap);

                /*
@@ -203,12 +203,12 @@ static inline void kvm_init_pmu_capability(const stru=
ct kvm_pmu_ops *pmu_ops)
                 */
                if (!kvm_pmu_cap.num_counters_gp ||
                    WARN_ON_ONCE(kvm_pmu_cap.num_counters_gp < min_nr_gp_ct=
rs))
-                       enable_pmu =3D false;
+                       kvm_caps.enable_pmu =3D false;
                else if (is_intel && !kvm_pmu_cap.version)
-                       enable_pmu =3D false;
+                       kvm_caps.enable_pmu =3D false;
        }

-       if (!enable_pmu) {
+       if (!kvm_caps.enable_pmu) {
                memset(&kvm_pmu_cap, 0, sizeof(kvm_pmu_cap));
                return;
        }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7ea0e7f13da4..4ed8c73f88e4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7869,7 +7869,7 @@ static __init u64 vmx_get_perf_capabilities(void)
        u64 perf_cap =3D PMU_CAP_FW_WRITES;
        u64 host_perf_cap =3D 0;

-       if (!enable_pmu)
+       if (!kvm_caps.enable_pmu)
                return 0;

        if (boot_cpu_has(X86_FEATURE_PDCM))
@@ -7938,7 +7938,7 @@ static __init void vmx_set_cpu_caps(void)
                kvm_cpu_cap_check_and_set(X86_FEATURE_DTES64);
        }

-       if (!enable_pmu)
+       if (!kvm_caps.enable_pmu)
                kvm_cpu_cap_clear(X86_FEATURE_PDCM);
        kvm_caps.supported_perf_cap =3D vmx_get_perf_capabilities();

@@ -8683,7 +8683,7 @@ static __init int hardware_setup(void)

        if (pt_mode !=3D PT_MODE_SYSTEM && pt_mode !=3D PT_MODE_HOST_GUEST)
                return -EINVAL;
-       if (!enable_ept || !enable_pmu || !cpu_has_vmx_intel_pt())
+       if (!enable_ept || !kvm_caps.enable_pmu || !cpu_has_vmx_intel_pt())
                pt_mode =3D PT_MODE_SYSTEM;
        if (pt_mode =3D=3D PT_MODE_HOST_GUEST)
                vmx_init_ops.handle_intel_pt_intr =3D vmx_handle_intel_pt_i=
ntr;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cdcda1bbf5a3..36d471a7af87 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -94,6 +94,7 @@

 struct kvm_caps kvm_caps __read_mostly =3D {
        .supported_mce_cap =3D MCG_CTL_P | MCG_SER_P,
+       .enable_pmu =3D true,
 };
 EXPORT_SYMBOL_GPL(kvm_caps);

@@ -192,9 +193,7 @@ int __read_mostly pi_inject_timer =3D -1;
 module_param(pi_inject_timer, bint, 0644);

 /* Enable/disable PMU virtualization */
-bool __read_mostly enable_pmu =3D true;
-EXPORT_SYMBOL_GPL(enable_pmu);
-module_param(enable_pmu, bool, 0444);
+module_param_named(enable_pmu, kvm_caps.enable_pmu, bool, 0444);

 bool __read_mostly eager_page_split =3D true;
 module_param(eager_page_split, bool, 0644);
@@ -4815,7 +4814,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, lon=
g ext)
                break;
        }
        case KVM_CAP_PMU_CAPABILITY:
-               r =3D enable_pmu ? KVM_CAP_PMU_VALID_MASK : 0;
+               r =3D kvm_caps.enable_pmu ? KVM_CAP_PMU_VALID_MASK : 0;
                break;
        case KVM_CAP_DISABLE_QUIRKS2:
                r =3D KVM_X86_VALID_QUIRKS;
@@ -6652,7 +6651,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
                break;
        case KVM_CAP_PMU_CAPABILITY:
                r =3D -EINVAL;
-               if (!enable_pmu || (cap->args[0] & ~KVM_CAP_PMU_VALID_MASK)=
)
+               if (!kvm_caps.enable_pmu || (cap->args[0] & ~KVM_CAP_PMU_VA=
LID_MASK))
                        break;

                mutex_lock(&kvm->lock);
@@ -7438,7 +7437,7 @@ static void kvm_init_msr_lists(void)
        for (i =3D 0; i < ARRAY_SIZE(msrs_to_save_base); i++)
                kvm_probe_msr_to_save(msrs_to_save_base[i]);

-       if (enable_pmu) {
+       if (kvm_caps.enable_pmu) {
                for (i =3D 0; i < ARRAY_SIZE(msrs_to_save_pmu); i++)
                        kvm_probe_msr_to_save(msrs_to_save_pmu[i]);
        }
@@ -12555,7 +12554,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long=
 type)

        kvm->arch.default_tsc_khz =3D max_tsc_khz ? : tsc_khz;
        kvm->arch.guest_can_read_msr_platform_info =3D true;
-       kvm->arch.enable_pmu =3D enable_pmu;
+       kvm->arch.enable_pmu =3D kvm_caps.enable_pmu;

 #if IS_ENABLED(CONFIG_HYPERV)
        spin_lock_init(&kvm->arch.hv_root_tdp_lock);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 102754dc85bc..c4d99338aaa1 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -29,6 +29,9 @@ struct kvm_caps {
        u64 supported_xcr0;
        u64 supported_xss;
        u64 supported_perf_cap;
+
+       /* KVM module parameters */
+       bool enable_pmu;
 };

 struct kvm_host_values {
@@ -340,8 +343,6 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vc=
pu *vcpu);
 extern struct kvm_caps kvm_caps;
 extern struct kvm_host_values kvm_host;

-extern bool enable_pmu;

