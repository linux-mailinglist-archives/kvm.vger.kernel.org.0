Return-Path: <kvm+bounces-10782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 027AB86FD06
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 10:19:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 266941C22526
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 09:19:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A44A0249F3;
	Mon,  4 Mar 2024 09:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LMGMLGtU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E219D19BA6;
	Mon,  4 Mar 2024 09:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709543887; cv=fail; b=a9AvSmB+8jwAjM4BZjpa+KIalBiWQIANvavdrekbdNgpVJt+51VqrwvFLPGNdIe6P34J8o0UtksQGnpRgblPS/wtp3AYTsYKpdX8MF4+k6hIaUrFZ4o/oyanMmsIN1N2ltoscOHd73Tll5AncT48W6y38GyJUOqY0vEhBGLvkGQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709543887; c=relaxed/simple;
	bh=xXRFHR2Tn3+WLdzv93fUaX+174XpZD8benoF00Rsjic=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=E5pjp1OUB9F8SRopekc1hz49gw4u3lj2VhcGlF7CM39dN0ydPUgL95mV1spLtEypLnoxxoZH4A+jq72UhlCt8Xf4UE93JPqKGLgm+cFRBgKweXY699pscKj8cAndP4YsX9R1fTzxCSKedLcvDVqBg1TBHaWeZH/tTOpcVimYR5M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LMGMLGtU; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709543885; x=1741079885;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xXRFHR2Tn3+WLdzv93fUaX+174XpZD8benoF00Rsjic=;
  b=LMGMLGtU+8Vl6iAQbDdoLvgZMN1cjlsr7hxB3wQNuI/apZqK4Yseid8m
   YC15dn2U7FYS11q1iLBaTjEOvAWKWm4gZX9Ad52FdsEjMMfsM5nTDjlb4
   XD7G85En/5l/QxOKp/efG581b9sLCMWyCbVtwNIacgObU553qP4puF8HP
   j/5X0fEL9m/fzgDVXKX51l+7chNnwEkkK8YL+k7ujcR+cBHEOZY41p5A4
   oL1K1u4eyQGkSmOazSRNNRtXNRmQvrpNsWrVcU+bLQLjodUTej0f1tZGO
   8VgOZknnOGnSq9AUD03Ht4o6XmpwRRU8OFPJbIRh0ABDX/Krn3CT/0iST
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11002"; a="3885603"
X-IronPort-AV: E=Sophos;i="6.06,203,1705392000"; 
   d="scan'208";a="3885603"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2024 01:18:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,203,1705392000"; 
   d="scan'208";a="13591817"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Mar 2024 01:18:04 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Mar 2024 01:18:03 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Mar 2024 01:18:02 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 4 Mar 2024 01:18:02 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 4 Mar 2024 01:18:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bpmNtRz7Wx+ckw1vt30OCswB5TanCKcbAvwjVfq8mMySwtjFIL15pmRHKmc88sTIqjubrZ7lYIYpDZM1Fer7srXK48wAESl5qXcBYTJkHHoTWNsWdtabJh1zd9SLs+6I+JFBN8ZYYwnWSicMVfLv+wTWJxBthvSxERdsv/koRsTPlwdyHx3GyefZwXd0JfdxcVAPbitejuyEcTooSBAV6K5wxCPM7bjwrG/0JdVjURLB7R843XU66ms0m/hCHacu1cXlEO6mLfE67OApgjO9TLzHTH3AdVoB4ZOPeBl89cbl+OloR8ISJG1s2ZSJveQgaMA4tYSuqp7lvjMdl0sV7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xXRFHR2Tn3+WLdzv93fUaX+174XpZD8benoF00Rsjic=;
 b=ThsoosWrvJf9gexR4UkS/h1GzUGV+KGd8hvc2KxA/z490rn43mkJEznpL9yIuKXpEjRdfQ2WWnlCgbyHOFQOhtuoKUMK6Yl5MtX41OPazf+CmiJIywj5F90Ja+zpHYh/gfdJa38Q676ZhaZbDUwjXm8sdbyajAQlBnUANEkINFMoJvGmz7CGzX23gr6o7TXdI9d631JkKbZrBFqkXpUlhi/Xv2U1GLz3bfs5aU1xoINCFeJJ1o8LC5+8EZl1C3PgSqmuoAcf4Xp9V5TWNgIfXxtVQwSB/CvJPuLP67STuH0B0QtJq7VxPeq1aZ8dsZeaTfDKPEgOTPI1niITADKViA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by CYYPR11MB8431.namprd11.prod.outlook.com (2603:10b6:930:c7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.22; Mon, 4 Mar
 2024 09:18:00 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::ca67:e14d:c39b:5c01]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::ca67:e14d:c39b:5c01%4]) with mapi id 15.20.7362.019; Mon, 4 Mar 2024
 09:18:00 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Zeng, Xin" <xin.zeng@intel.com>, "herbert@gondor.apana.org.au"
	<herbert@gondor.apana.org.au>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com" <shameerali.kolothum.thodi@huawei.com>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, qat-linux <qat-linux@intel.com>,
	"Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
Subject: RE: [PATCH v4 01/10] crypto: qat - adf_get_etr_base() helper
Thread-Topic: [PATCH v4 01/10] crypto: qat - adf_get_etr_base() helper
Thread-Index: AQHaalRrxMw1HNq2EEyUy2uDoGUJELEnVD8A
Date: Mon, 4 Mar 2024 09:18:00 +0000
Message-ID: <BL1PR11MB52717E799927181BCB06D2C18C232@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <20240228143402.89219-1-xin.zeng@intel.com>
 <20240228143402.89219-2-xin.zeng@intel.com>
In-Reply-To: <20240228143402.89219-2-xin.zeng@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|CYYPR11MB8431:EE_
x-ms-office365-filtering-correlation-id: ca9afe36-5bd0-410f-ebbd-08dc3c2bfcfc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TLwad11W4i653X3dMNGVj6Pja1k6WSsAjTA3HFmHR/pnh2gad8+DizFiuaueAxQyabMhIlgrUKycG3z974bzUQ+rvgtkagFARtlylegwHqaQxJFHOvx1TKBIvrvk4ws0bAlq5S5V0ELBrCzfyUjbsd9bFVXzPSUtowSR0OENL/k4H56+HjPx6I9L3MR9KeSrmA+gFRbZFeEekn+yHT79E/Y+4FQwF5DJQCtyrfVe+Pmah/3ogUiTYo2UvMr0rvWifl6g1BuytelH2MJCZNMSRq9Skyv7fKj8LrHooYHDfB8ws6mmas4Ya/WjM3sCB5LsVbiDicaT8dV5V8btpUWU+1F1u54kMJKhIMrSay7Tc7+RAFSKCKNvEP4YPDFXN/PWt9CorqxvgFkq0kk3q/I7SZJneVegYSDglXlDPck3nSObyQ5plEXPTbhpCBtYWcw/gd5FYJtBpHKP/a7ahLEtQyRI+EzMPXrkRsCNr2Jwxq9cnP1RaL2BGMBMK4AiCP2ztSpbAArCrALgP+Jwy45qcapt6hpQJtLQIhEAFMcSm0IWcGYChWhbkPyCvJFWxuFBcZx/avpmhPQqEVxROsUqFr+tXrqx/r6qzMZNsh5cF2qGg2ld49VPkLJuPWO6/39LOgZdmIKfMA6PcmO33TCggicxb+w1ZGeglSslJYyCcpOkz30S+iybyOaawftmf5P8qZENSZY2GBmt4UUf/zQu7w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Qb9tlOF9pwlJSbwlvEY39e9mMKJEpMs8DDJkYSWYibiyvJ1MhVtvWmnfUI1c?=
 =?us-ascii?Q?rA3qxbNwEBkVil8u/dQ0OSXc+efLOdN+1hAzm3FR51bXOzguyxSFIbcqji7g?=
 =?us-ascii?Q?Lhap9hkgnXsTEigYBtMDOnvEjXC6+jW5vjIT7w1s3isF1SlFulvI59tYRCiE?=
 =?us-ascii?Q?v7P5pHUHkYRjbXw91pbBJaGUM9LwU8CSZaJk+GNZTTgUe6GktSPYJiW/p0ko?=
 =?us-ascii?Q?1nUfn2AgP2QiZFH3VOUaCRJV25UhevVESjR4Q9OgAjApkW7WR/mpAUWZF6G9?=
 =?us-ascii?Q?8TJIqZd3EbQylRFD0z6PDAtDgAh200ylUIUpX+YCJ0Q0dHfM2ZfCHbMH+FLR?=
 =?us-ascii?Q?vjmPP0OtEEUsw79rinnMLm5PENQAdSrQJlv7O9OWEef7WWfZmQ1MbAAPIAd9?=
 =?us-ascii?Q?ccJXOUbvuEDAg24LPpcCFywMAg9xKf0pmUGYPfafGLsPb62nu16+PUovfx3p?=
 =?us-ascii?Q?pSXKbne+/Qqz8iO5jJIMsQyyQRzpjMHgyH7cMP2EOZvAxDAATOJ/jtQK1IKp?=
 =?us-ascii?Q?YlhxYBm/ZhDxU7vxQC/aAaT6Kof8kjBfrzkShqNax3q+6nny7+cFNqQW81fi?=
 =?us-ascii?Q?jPTEPGLGIYYa2rnI7I8u0DmxXFLGVeDopmwUNZXNnWT2Xrb7QNMzTBh/tGEz?=
 =?us-ascii?Q?e9aGFLbrzXcVKz+jNgGNHQfNmKUt1LIWaGSZ0QzCF7OBs1Qcd/+fL/Axdcqb?=
 =?us-ascii?Q?1Nnb1OwqUcHuQowcJ5n+Wr2WYICoXZh2p4MlVgJaH0muW46F/XkTcCpgFrWe?=
 =?us-ascii?Q?eWuEvj1zbnPtbkuRBMzoLLlxH/hlUi4ZV5Q3sO8+f1FSEiTbyZPN3ByU9C2B?=
 =?us-ascii?Q?ZnvCgN6gDnnHlCq3cyDE5A1x8LEUeXKJhZTi6r1uPMZPchR8qGCFI4ep0zLW?=
 =?us-ascii?Q?rdL+WFiAh2BZuL+a3/k3qzHYyAK4xOk4bJe1SgSpy+ksl5v3jJxP/naINA7N?=
 =?us-ascii?Q?WvL6I2wjOhlprFXYDHOHf9/DCdWBnGlJH1/nHIP6uh8UJqd1sxq1vZH1Djwv?=
 =?us-ascii?Q?56mopXnbpwOeLmR8kzOINAZCRP+hl+syRT4HVyQIt465DIETtPMLEVf364An?=
 =?us-ascii?Q?As2+NvBTB28BBlOamNQQJsz3MoPCC35VIVDscDhLYiY7dB+q0qegMAAybpKz?=
 =?us-ascii?Q?d1mOVa/F0WoVEdH62/CV8UA+XgqDWv2KLGoHXDosLGfqpJGlq+t04pneDty3?=
 =?us-ascii?Q?KPY6C6Hdwfq+Eo4frFqEarEqyJ8beoQlu53HQQPNRVciRuLctqBh6V/e3ocG?=
 =?us-ascii?Q?GO7q/ifv4K6pmwYzK4b5lfEtmo9Lo+CMYvf+SuRwd0a38172nc7GM8ADmSQj?=
 =?us-ascii?Q?8Vsebe9ElpL8NzALzUh/pUpT8qsBtPBKEn1y4fjX25065qkB5splPWqB6gLX?=
 =?us-ascii?Q?DBjkz7UrR+5QCOhnDlTdZzQsb8FMAZken2FgZZRxofJnFL7pU+nV4Oz7Onyb?=
 =?us-ascii?Q?iYD0dGC1aEf2qul2t5mlZnDEWQD5N6KFGdxYwLpkZMC3p1RyuBeE6pCGa6KO?=
 =?us-ascii?Q?ATVY1VKgRotuwgykYwIZNfDBgPPauOe4GCxuLU8RCK2dyJ3kbBIgI5RtBrp5?=
 =?us-ascii?Q?Sj/qN7LxtqJZKZlAlZ00jaCMn/YyOu4wK6UiCqPo?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca9afe36-5bd0-410f-ebbd-08dc3c2bfcfc
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2024 09:18:00.5351
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FdhIfZrJSIn3aWXKQyV+fcpaiKV0Z0tEGJzSRJBqyNohFSfvNxnau2vo9DDwKsm3HZje5pVl6a1FMfZYeCkzdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8431
X-OriginatorOrg: intel.com

> From: Zeng, Xin <xin.zeng@intel.com>
> Sent: Wednesday, February 28, 2024 10:34 PM
>=20
> From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
>=20
> Add and use the new helper function adf_get_etr_base() which retrieves
> the virtual address of the ring bar.
>=20
> This will be used extensively when adding support for Live Migration.
>=20
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Xin Zeng <xin.zeng@intel.com>
> Signed-off-by: Xin Zeng <xin.zeng@intel.com>

IMHO s-o-b already implies that the author has reviewed his own code...

