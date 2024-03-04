Return-Path: <kvm+bounces-10764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BEEFC86FB4A
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 09:06:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27A6D2823B0
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 08:06:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4030171A7;
	Mon,  4 Mar 2024 08:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DTisB+WN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD3B14A8C;
	Mon,  4 Mar 2024 08:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709539568; cv=fail; b=szFmch2SYfknf3aYMx3YBeQHAstQIWZ7iI3uS1aDZRm5D5vxqc5v6Ze+qvaRmWRd0Rb1gyRTrUZ16Ltpgdi5+2X5Yc9Y5JCMszuyknvg4+6+kaVnojq2Ag9DjT/Ex81mlLaopSiBZfxpCCv6UY2IKEvptjVBhDmDf8Gk0WZX8Z4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709539568; c=relaxed/simple;
	bh=N6i/UrEc6iXyHkafR3IiG8tWh+W342jJ5U4oTzCRtoY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=W8jL1eYXuoCzrKXE5Saq2HFHOMJj2trxWXpfbbYRyl2SadIrUIcOrd07JKsBulTw1dRZDhPq5snHfXR7h18loRABMGalA+tNMpe0foskIAbWQESVguAucSZr/hTKiRqBXeK75RKXwSuRbPcuxM4JpOhU8rheo7K1gB8qTkQFbXc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DTisB+WN; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709539566; x=1741075566;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=N6i/UrEc6iXyHkafR3IiG8tWh+W342jJ5U4oTzCRtoY=;
  b=DTisB+WNccPg7rrpSP/DfC0nupJetW4FtvrvFHbtbcypWap+7k1s7xZE
   6koQijlu098p0uFU+x8gXyjLCluw0vvdq2+U+uAQZuAapivNSoncImUZl
   Wkg0D+bHxUDTFgmXr5v8qOZpEJ8Co34waJvVif5Y73LSnracUJ3/a8opJ
   D0u93RIBUh5g1GLw1n4wpI0DqnkPuG9vzYbE+I1feTQ7SIZi8jyFu/Jmg
   AMOepoW+r3m8zZoe9UIB+28zkT5Y1/5ybamqsVrogJDAJK4u86F9BjIsM
   X9JpO7F/ayOT8VkeKzBO79wMGbRzM1MZs9FIuhMHOoEAiOzHnfBtG1AJo
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11002"; a="29440286"
X-IronPort-AV: E=Sophos;i="6.06,203,1705392000"; 
   d="scan'208";a="29440286"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2024 00:06:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,203,1705392000"; 
   d="scan'208";a="46419635"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Mar 2024 00:06:05 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Mar 2024 00:06:04 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Mar 2024 00:06:04 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 4 Mar 2024 00:06:04 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 4 Mar 2024 00:06:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i5V6IZkhb4+szVmAruCFQUacwQ9WL9LQEYOeftHeNW1xAMUI4ihncWsvAox/ea4J0ffOuIehb66WCreDMh4C/532T04Mhpyaf510gVeJXr5GLsOu7oWidHpGgSUf/THsr7eXN4X4061vok1Yt2CM/47L83HYErhcRhjFAwfSnJbH2XIN7uX/AOmKeSXz1Y7RPoqieW+oI7Moyb/DBvGLxdagydNbUN9A94yMvm5NBheduxoaBGPJOX2JioxcSxDVoSd4Erwdn+Evls9ba0H+NfzXInDDPsdvfHzRdADIT0TCC9hHZuSJiTgyHvS5uGWSOLYlPajrlzSrxUlFCM0OPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rcpNDrGbjxSmQGc94msUJz67J6WVOpJ0Hocin3fJZIQ=;
 b=U4dHC/cEDAsgGgFAp/9L1gyuhVMRSqu41in9GVlLrSv3t4jZdmzQxdVzRtk3umBZii9BCcWm9kZeuupsZLdECBziBN2JkioavDEeV7gZ63HQ84TczlaClgS+lAB7c827Qjaafcg0RDrFknwzrb4stxfSp7quIPyQPx5zQNo/evslCXN/N4jOISEsQ+OpnWu4j8NSqry99bFKCYQG3xorFlq179WhpCKMmkYSaFGpnOe1jCCc9FT2b750PRLB4fVAVA/iIH7MLb1lpl5tpTauVDCaWrNwM12KarQsF0jJgeKTx4FwN9cjd7HD/+vIcJtftbRKKENvz5jli6yuJ110Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY8PR11MB7731.namprd11.prod.outlook.com (2603:10b6:930:75::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.23; Mon, 4 Mar
 2024 08:06:02 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::39d:5a9c:c9f5:c327]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::39d:5a9c:c9f5:c327%5]) with mapi id 15.20.7362.019; Mon, 4 Mar 2024
 08:06:02 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "david@redhat.com" <david@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] Revert "vfio/type1: Unpin zero pages"
Thread-Topic: [PATCH] Revert "vfio/type1: Unpin zero pages"
Thread-Index: AQHaa1+9vCqOMpJOeEum19hngVFPlrEnPr4Q
Date: Mon, 4 Mar 2024 08:06:02 +0000
Message-ID: <BN9PR11MB5276C1CCFD4034AAC0F7B7A68C232@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240229223544.257207-1-alex.williamson@redhat.com>
In-Reply-To: <20240229223544.257207-1-alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CY8PR11MB7731:EE_
x-ms-office365-filtering-correlation-id: 8955c062-c0f9-4f3a-52f7-08dc3c21ef00
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +ZbaxQPWcteUShNZ7rzMbiEKzKfX/WJncUY2f4o5VsurCZJPbiTJuiETDRqSDXSoV1Y+G8yH7jRMXlDuNjH5J9ZdBqbp9hGRQz+f4anCHE3FF02je8W6xG7H1SRZSVb2Q8YXtQzsYtV4XgFLAEhxghUdIHoRwLt/bCtiOLEixevNAppdjXBbD3iCb/0j7OOrO//dgRdtpgkPatQCGEeXq12PndOVjEbfr3T2Vg/UKjR6FgUKIbKulo3zyioAMvqM9C3+yUMHos5QvcgVlJSGncgfyGyoIJPveWHnioZVuOWZ8G4lCkAiTilHgn1xgzs1zOyHJAHNeY6iOBFb1qEcEc00wDxwQmlTzXQM0u0MFEWkiVgFpq2Un8rkccsE86eOcoT6gNWWLwdr4fdT80tudhWcxdy0CgloLiEsVV2OPW++hNkEntiTT1kTCzIg5yL2r8UbNbbY96JRjEHZKMJEFCjycJ+h/tWH7a4G+gLTtmaXqQ8G5w0Ys/fH4FygC3C3ZjtNN7RbJ1HljfqvBxP17j/3nJlBzpEpRsJdyY/2qXl4c8ibTL+lMSREx8jMxXJzLuHbX/+aYcKApqCluasO4F9ZwtwcF2MTQikJOrGzUryFR1Kk4ta37+mZAAeHh2PAq/W2r8wjkqvwAp3ZF5v4kB14bj32zvqNLVa1ukFizJmoOPZzILHpMXMpGLCKQ42c/+nyHsh2bWATIcpB29sxBr3PnZ7M9chMITX+aNM0qio=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8nncwu3guiX2L6IF4mpBmtmasbPZ717fL5HhhHOX/MB28PhhnewO6WjnXC3M?=
 =?us-ascii?Q?M7Jjq98xuturbHFwbVtjksyCSqHfZoU4sndGmhbHCRY4IosAPVQMvABx8xOF?=
 =?us-ascii?Q?ljcXFrtY50CRNHt7SrcEayX328mfZllhYg2nlstnJgJMwfeMYpPEiAF8Zf0c?=
 =?us-ascii?Q?0XUV50vXBQ/wBJM6v4AYMS0BrSgwMHOZfabzYhp1g2zFJT8gxmFZ115ckMk5?=
 =?us-ascii?Q?WXE69qUu8QT93LPnORf8cDrF2AjP41r3941sr5LcJUalwm5lcGMwydAcVxks?=
 =?us-ascii?Q?3WaaTfRD9KMcab2HdDZCohPBP3Cnv2MwXVeDoNVZA5fsO/v4Fn6rZp3vV2Lw?=
 =?us-ascii?Q?4tIKk2sHbbHrV2AuWOSa0R1S7ZDIzHGXWusPt1gB1FilL4NhO2gj7tAMO5l4?=
 =?us-ascii?Q?g94kc/duKVthlj54RFEvxJEz79FYb/Jr0s/VbiyrTcyZhGu8Wduk+eh4Msdv?=
 =?us-ascii?Q?1uBmi3zs4zv3sYid9kxWV/dIorhyGgAJL6sXDcdtKILGJrWemdZ/m1FHXtbg?=
 =?us-ascii?Q?i7WVfaPpVh85k++Z3NfQLfzusBJkHWy2m3tf9thSBYQOUI85+68Z6DsGXP+l?=
 =?us-ascii?Q?tJT7u2mi1UMsh/Bnv8xMVrwJObLlf0ZHI3jHk6C9EyaTH9q88FlKLiHTQ8yW?=
 =?us-ascii?Q?OpNc6XaREjdeSzG+MkkQNFGBrGimjm+ZurCIf/XDdwf5MPs6KeU7aTLOW3RW?=
 =?us-ascii?Q?caMDQuRBstq9xwhDGuA1T2o9RMoRXUyqAgLOKj7Falr5VvHs4/Y0ON8UE9Zb?=
 =?us-ascii?Q?fN8NoCq9vImm9W5vTzYYkQSWnsLn/bX+qfg/fj6KtP9GyIM5ztQPzTUbKK08?=
 =?us-ascii?Q?oDnAXQzVHLhIfsVCQXKtZQzHGOzyfeCFdpvs63cecqkYV3UNeNACXpE3oMpu?=
 =?us-ascii?Q?I38UfxzXjzfoZ3SX1WPTusBzoWkszDs+CLB/Jz/fPuhJ56oazfoqht2DxVhU?=
 =?us-ascii?Q?ehHYUk6lsqU8/QRht+2Ri53+lNL/nNVS0Zz3+tl+9LcKCTqzP2E8rCzbzMM+?=
 =?us-ascii?Q?nQU/O3DiRxCoN/tVrbYdNSHo7NvYhumdFG+uPMR1/V0L+EuHEJVW2Bhpe5O6?=
 =?us-ascii?Q?foMJru1mf6AfxidH95HEP+S2vufQQawRJUX+JKuyipIminYtjNcwy4wapqJy?=
 =?us-ascii?Q?HkBCZazXrlrx07YLCl5zw1aFC+SjD2ssK5ZSAY2ORhNim8h6CZF9MUGXs3rv?=
 =?us-ascii?Q?Xdb5EuIZYgS9PbrDknuuZSiYI0VEP8Zo1dUFe6sfePg/8Qyo9nMEBpSBF/R2?=
 =?us-ascii?Q?lZJx2WrN/JYPusmrYntl14l9RonCAOgdKab+5vkKJJ0SFNhGQjtW4/nDBIjo?=
 =?us-ascii?Q?f2+FD8SysJ7009V6/4x3u5HE5c+q/+89wTer5lWkQu57fHhbIecm6UyavjuM?=
 =?us-ascii?Q?MG6R8hB1daZDpd5fXHsku0mZ7EAlwigwe03ahCJYZw0lMkDtTgFzGxxrO0Pr?=
 =?us-ascii?Q?cSDalp+VmdmvJKZynlmoFzyLTvAXdv74s8WRm8tBf0i402rRXrzXE4LNBf0j?=
 =?us-ascii?Q?dOqTS7wsYTmK2bGR4Qmalp5Fg70LU+4qj4Y5/jeTtY/I2EZ71tkxdjVnPNW6?=
 =?us-ascii?Q?X+bPEbJAn8A/OTiY/GSwsrtTeL81D3NjVEZgnnih?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8955c062-c0f9-4f3a-52f7-08dc3c21ef00
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2024 08:06:02.0800
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ugegw7+GR73yX4PiNswefYlGP4HocumPcqn6iXSsOErNOtyPMSFbXW5Bn0/LnptxuvyhmLB3j+Hn0B9sGheJzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7731
X-OriginatorOrg: intel.com

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, March 1, 2024 6:36 AM
>=20
> This reverts commit 873aefb376bbc0ed1dd2381ea1d6ec88106fdbd4.
>=20
> This was a heinous workaround and it turns out it's been fixed in mm
> twice since it was introduced.  Most recently, commit c8070b787519
> ("mm: Don't pin ZERO_PAGE in pin_user_pages()") would have prevented
> running up the zeropage refcount, but even before that commit
> 84209e87c696 ("mm/gup: reliable R/O long-term pinning in COW mappings")
> avoids the vfio use case from pinning the zeropage at all, instead
> replacing it with exclusive anonymous pages.
>=20
> Remove this now useless overhead.
>=20
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

