Return-Path: <kvm+bounces-11486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 560528779AB
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 02:55:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC19B280F00
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 01:55:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A97C110A;
	Mon, 11 Mar 2024 01:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FGgidLkO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCBC7EC;
	Mon, 11 Mar 2024 01:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710122128; cv=fail; b=RQk6SDfwXpA6VW+rpFWZwQCKR6YSMeV/0m/SXfZzW1myRwqvPuY8O9R4ozJ60Fjx0M7ypN1u3cWZVugNcmih8R5JDn26GED77zampr70Jnduorc9bDVVOsV6nLFu3I2UFNSfh4H1sqZf4cEu59kghxmyFISARRnGXH8hkUxy484=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710122128; c=relaxed/simple;
	bh=JjrnJldzmaom5eU8fOdoVTIW+H0DoHnQkmD55N4rjAo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RvapPY1wZClF9VL4fXu+rKE9L5mxM2hhP74M93gLRXdB/1eFNQOSU5sjyRKqUWxx8iVLLWB9uMJMeGq3KwSC4zl8OmMcPQ6X452guRyHZz5J36+yH95/Ri2XxuKPltqdcs0pjhX/4M2ahEpf89O1PYjwXf3wVQmmUG47Wt7FgjU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FGgidLkO; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710122127; x=1741658127;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JjrnJldzmaom5eU8fOdoVTIW+H0DoHnQkmD55N4rjAo=;
  b=FGgidLkOo0eq1pt9i3mfwTX+v87ZIOXZlXKKkk1LKpaIKmmIr72QIGL+
   biiL9uNf+/8YtVeBqBwgHUQMl/05CGzYHYdz5KopjeZVRIQXlqmjtXV57
   rExCEHj3r4idyIx6O3SzyFejsZKEWR5EVKv1EiRrbFLsW6o2D224Ovvx4
   eW1kFRdey+a43FX1+OJ1UIYZarNVn+yybrR6u9QaW1D5/w2wBURhEAtKa
   Ix021eBssRzn5awMRmEWHzgFpxNvhrZOH84/FZBrHkle1p2iLyPcCRC1v
   UNNAFMhOav9lxREwsQm/4F/6nt5zkT1AcBIHWpRRz52ZwHEJX/j2WORt9
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11009"; a="8522800"
X-IronPort-AV: E=Sophos;i="6.07,115,1708416000"; 
   d="scan'208";a="8522800"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2024 18:55:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,115,1708416000"; 
   d="scan'208";a="11075434"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Mar 2024 18:55:26 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 10 Mar 2024 18:55:25 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 10 Mar 2024 18:55:24 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Sun, 10 Mar 2024 18:55:24 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sun, 10 Mar 2024 18:55:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mB8wJpvycpul/axr9AUo2PuRrJr+NwGYOZdDDcd5HCEv7FZfQvPs0VOkDjiAO5U1xDI8VknV+kTz3jozOF8kTztypaPggQn2Vja6kypzvtQx6S4awO2ZG5M1W8kEHvUPagIOgGc5RDXsOT4jYRETa6QVrxxcGzZgdQpOXV86GPkmMihQfPR6XVxaJ5VAf8QSoIdSlhjnR9ZZg5uiUMmy7Ca9WWHgCkyQAmi7AC35sU/Ou46hF7Af3FoB1Kk2HKiM76XvWyp1ilABRwIa+lFnb6BDJHZWDIJCiR1BcO2vGS6V2MtjkkYwRfHpjlKzC5gag5yjTflbBowUnAaqpMH9+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jUk2rIETGZ0cL+p3gq+a0o1z+yXYzT6vJ32xRdX7KCA=;
 b=hVMzgWy/xZrBU3jFJzlytPyMk2Qcwh+cQ6dO65vnKIQVHr2qaDARHnpNlL3eyM1q7WS0MLM4jWQe3tgCDu/JPjlcyBom2uAShW1TzL3xB8CFpGwtI6K0zippeWFBW+ALtacJjSeVbMLawZWHaWlhXoI5FP9Y1t9c/nCor3MC9J+XBVdjbELXFJQUYVIbmj7AezlV1T+KbNCraB99kBHQOH4pBAPeY89XeaANEXWXhlch8ZshKa+UZ7bLEZ3rJmlHbAAG0/uUvD89wbXKqRCeVU/2HA+31OPIlU1AeonSouKQL3dvxnz0hefKpkt879muXys+xqtNNRQiaITkaOKJug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN7PR11MB6993.namprd11.prod.outlook.com (2603:10b6:806:2ac::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.10; Mon, 11 Mar
 2024 01:55:22 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::39d:5a9c:c9f5:c327]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::39d:5a9c:c9f5:c327%5]) with mapi id 15.20.7386.016; Mon, 11 Mar 2024
 01:55:22 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "clg@redhat.com" <clg@redhat.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
Subject: RE: [PATCH v2 5/7] vfio/platform: Disable virqfds on cleanup
Thread-Topic: [PATCH v2 5/7] vfio/platform: Disable virqfds on cleanup
Thread-Index: AQHaca1dA+HV3A1AZ0at9Mxd7MP9PbExyutQ
Date: Mon, 11 Mar 2024 01:55:22 +0000
Message-ID: <BN9PR11MB52768644027E02B08578CE368C242@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240308230557.805580-1-alex.williamson@redhat.com>
 <20240308230557.805580-6-alex.williamson@redhat.com>
In-Reply-To: <20240308230557.805580-6-alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SN7PR11MB6993:EE_
x-ms-office365-filtering-correlation-id: 15acbeb6-aee9-4847-4188-08dc416e5010
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b7SckzfO87Q4aXS3IyfIGRu+VzyJ7i6sgzza7+ldI7sFnqST9hb+rgDzicu+zWQTzLOhv3leILLAT9Dqj3IJi96LQ3OPlVLSGkCCHwpJpH6JUGX7ltUuAGs6obj6NO1907zcEWZDJv+nRim1rQjjiqUahwKfZJi90dsEwOGSTOYmcjW/UBzrJZGdq1T5UI2sIgVPgn5cqyOZ6k5SNb9DqT/GImwL/f9rT00N9+QDNJQ0aGExLuzfDRpxSK8tldejbHtqMaTng8SwScBgyAGqyY5p2+rrhxHIZ2Vh77gcB/yVHtxza20D33OPvuDLTo3GQiSltctxyAJ/zV2pPoxBV05rBn/EefIqUap23BUDouqVUVeKOOZEgBVa1+zj1UxlkpeOvzLzBI/rgrU1kvl9DfjVoeg7ou7gW6xj8OOgNcS+3mUSdZQ/zvEbasDQR9dQcvCf1Zxr/bupxygG4cSUg8gE8plrIfqbH+pMxbUhCvxSDtCNf8QZ3Y/XyGn5m5gmi88IQBGeqTEE7DlKiFybNQ0EuCqCnMd9guRJmNbFS6MGAzdvZOomEKPoKrFLMVABaxN3TFjMJbtHCtlvY50IhShWNqIz6d6lRDLWuHB3GPmRoBu2e6EDSwMO1HpJBHpo//LKyq0v3d2uhQ1tjv518CIiviq6+9YpKQVN7/leKKAPXb8CtF6RQebbwhwzW0tPioS+1KW+920+xRO/GKZWSpe9O6EUKq7yPbuE+QepO5U=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xdDg4y241nyznCtHnnAZ+VG7XMno7dFkeaRWRJlhE9p8KoxH9Fmr4LAA6a3s?=
 =?us-ascii?Q?LLrajd5XtEaC6DzPkUGgdhhjlcA11B7r/vkTLo7L0rm61g+20eMSot/42z5Y?=
 =?us-ascii?Q?ZqRuYyZm3UjEUa5C0j6mSRofqeS87J78IvQ0JITHOtVyg/6JFZOiF+Xl2MJE?=
 =?us-ascii?Q?8xBwBskOYj1V3nC1/ouEdOtVprYh/U1QL/TnMWFLYSEmKSq/ykEcJXgM7LI8?=
 =?us-ascii?Q?XPaiXXktrKTf9wzZ84qOnCK9J6EXFKAzb0utAE9SRUyQRMc0FVz9/6SQzrrc?=
 =?us-ascii?Q?e4/SwYBn8yaiB2j9QnrTZY7nNOjN51lOF38gBFjs/KiyM5fQIF0JdeCdkHDe?=
 =?us-ascii?Q?2UJDEonRH7genz6hVY2Voao/kP0EuEotJjpETFKKldYd7uzKjQU8LCf/XaHY?=
 =?us-ascii?Q?ymKWUV8sVQw0Z4wKAt2+MQSSv5p5kuiaMozX38KfZddjBap2H6j4NjO1ZwEk?=
 =?us-ascii?Q?iiJtENPH3eBEiyZS79T0ZGDsGoKEFZSxXIoZEaVFchTtTmVXvY9ZEZ0RXqur?=
 =?us-ascii?Q?aVEXIN0zPd+xgBNtd1q1DtyC9JzY8zkMdjX6XQRiFMJSXgT4Iewx3EIccBzB?=
 =?us-ascii?Q?+J2SB/nYYxKm8lYutCmd73Rs71l/GOgwSEkgukQLvj1daBuafLWg4dbkVHl5?=
 =?us-ascii?Q?xUT/Zoa2zN7wmniCb4Wlcx45AZ4OVaCggNq4Wv81MZaxSLDqzW7qdU66KMZL?=
 =?us-ascii?Q?u9dYma2GWNapQV8V/flnxs17EO5jXWx8vv3Trm9nB4TsBtPi/EogId7tccic?=
 =?us-ascii?Q?Ts2Dy4C7sKiZDeA0/TfTVHEDJUVlAaKlO5t64wa40uftKJieD8YaNVeUbBBf?=
 =?us-ascii?Q?cVTCqBi9KjvXZx1528cR8I28jS963YQVDopURpi9wEaKzP6syldcgI0Xz27a?=
 =?us-ascii?Q?zWN+qQvrs2sPwwyoRPsejZhjLoLWoIMGbP0e7a1eE7TDsf+kD1F85FHwAk7D?=
 =?us-ascii?Q?2jXwogDNTpwZnmvsebOHueqhPyQvqUy4ahgBiQMUvuX87Z134p5ozObT5Mk1?=
 =?us-ascii?Q?OAscg3ydxI6YuNxbH1ZngO5s7jZcAzaklgSpMnSoHYQ01FjaS+x9HI/FHrp2?=
 =?us-ascii?Q?zwfHVkxcbMUOGYVu+lCfaiLEDNbXh7aEMxUUC1DCQM2/nuDlG7ib8mpsLEEl?=
 =?us-ascii?Q?02WgbVt1duh1tf8BbrOXqUjEVS/2ZKZXCnnjrNI7CQQgWVL1tCSvDO4VntR9?=
 =?us-ascii?Q?xuOhDh26Z++UmR0xxi0dik8rgKlQBer9aTlH4WhoV9LZKRIfvP8MD0FXz6Tp?=
 =?us-ascii?Q?ZaMkupREVGd2x/zkH6f5x0goVfLORp/HWG3jEgTFBojfCuI3pv1Y7WbELihU?=
 =?us-ascii?Q?3e5UjpKr8MaAijL2AZrAiTtuCgQJb4H3RvABrx6z1f2htu2yLI8313YWwM3H?=
 =?us-ascii?Q?VADwJ5AbfisvHJU3nTzbPzOKNllb1OWursCjuaF04OYlschGDju0fU6knT/l?=
 =?us-ascii?Q?H0sxdVutOcxNDCenKrJu1QKB/7G0WK6G39ouadH9BH8VA6vnDX9b5Grd4L7H?=
 =?us-ascii?Q?6afQ9RziCJPxSFI8iEO6QS7Hwglwl2GBslKDG/+z8VRCENz0pLYsJjlAqzfr?=
 =?us-ascii?Q?b1UYbxMR3x3z1j7qwjymgUz7ho8sHBQNfDMB9nou?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 15acbeb6-aee9-4847-4188-08dc416e5010
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2024 01:55:22.5197
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7G81mrrhNQ/K7R0rmNjSDFTit5B601ModFcr6HGLC6r2/Y6nKCjae02ptM+OecTTOrzVlF5Zom1fPk70hNLcmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6993
X-OriginatorOrg: intel.com

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Saturday, March 9, 2024 7:05 AM
>=20
> irqfds for mask and unmask that are not specifically disabled by the
> user are leaked.  Remove any irqfds during cleanup
>=20
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: stable@vger.kernel.org
> Fixes: a7fa7c77cf15 ("vfio/platform: implement IRQ masking/unmasking via
> an eventfd")
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

