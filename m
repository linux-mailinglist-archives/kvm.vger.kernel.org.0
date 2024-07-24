Return-Path: <kvm+bounces-22149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CE8393AB31
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 04:26:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE91C1F23545
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 02:26:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9080F17758;
	Wed, 24 Jul 2024 02:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ma8uhvRM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0194A00
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 02:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721787999; cv=fail; b=ou3O6TESgsztyWWEKydNTp+oQReEytwYxhutXJxip2/nh6OIY8Ki2aj0o9jnknsJlS1E5xhqXYJpdEpBVWuzUKia6JRc8itykw03dIr4VJcD55onN3MZL3q+rSRwp3bcv7Me5oPc7oXPFKtaCDfQnhfcFCwkb4zqHquyqlbuucE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721787999; c=relaxed/simple;
	bh=fHG5UUyvVu+XMxALStpDXx8yB/hqiANClRHCykJqRL8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mmYur7r5K9YaYVIvp32ATwOxpklv6oLgRhxUaQzDFZACGJfackpTy6Z791HXZJYU05NsBsa9ycg7KiwlrpIE+IjPZPURCnpbAnjJlgJJ5guv3rlAjJZEyHkuE4RXWdFtxWnJDUff41q/ah1Us+btRGrSyrMSqmyofnHUyav+NbE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ma8uhvRM; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721787998; x=1753323998;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fHG5UUyvVu+XMxALStpDXx8yB/hqiANClRHCykJqRL8=;
  b=ma8uhvRMTbbrg/4/pVoEby50RiLU4PG1dvMwTn9+KuzAEMXW/jpU+lun
   bDHd1xsrS4BE8227TpsXNCT8Y64pdOu+VtTBRP/C9DMAhSbhLaJ/5UXCC
   c4sgFo/oOb4qUxvv0s1aKR5X3l0iYgckImmUFsr7B5m73vcjWV5dmyPyE
   kvvs8qclxXh9gnLT1XWE3TWnsjzHAp2eC/Zh+MioNzzvxtGmIKc2pHBS4
   JkgKXuyjGdpQQmuRUkqNIzHjZQovgiRGsWkeetmy5yB4f5vwrvNN1OC1r
   6dljyr/k1VX00E8G0Gf7Yp1I6e35sE7A1IwdoC9hdUlpxadxf8Lg8lmIX
   g==;
X-CSE-ConnectionGUID: lgcYxglrReuQSMH5mach3A==
X-CSE-MsgGUID: 61OnzlKXTaCdey+DDe+eQQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11142"; a="19590553"
X-IronPort-AV: E=Sophos;i="6.09,232,1716274800"; 
   d="scan'208";a="19590553"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2024 19:26:34 -0700
X-CSE-ConnectionGUID: TppvD7R8SXye8nhJ+QI1EQ==
X-CSE-MsgGUID: DlbuD6dJQtWrV44z5PAhyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,232,1716274800"; 
   d="scan'208";a="52493083"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Jul 2024 19:26:29 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 23 Jul 2024 19:26:28 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 23 Jul 2024 19:26:28 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 23 Jul 2024 19:26:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w6azb2Yd+j2uzqMoAL+ZdArC+sRMuBgrBKOuHoKRum5/rof68f+/Uon4EwATrjRxu1zgEFO6/GSOD77N31SfxPCJCUDrF11JBQlVk1+7DBD6OLG5ssZDWTN7DXsfl+HZR+jOikUsrrscFrzWjAyTmeTDTpv6i5JnptN6g/ZaEiE6ZDCYlzOGfo12O+tdMvSRTSywAcRfgyKueE1GNLskNGjSUQ0btq38iYHxyIDFfmtFgnDTILQ8DpppmCVcyQ/bV/G4t+YWi+6BJjMVzm0XkWZf8+Xsf+Js9FNot4IcVXsW4Ev+J+YG7VX4Dfdc+cAa2YXtVGIQGgDhYt0oHArB/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bhHXTO9G3SK86uGGPHcPg6t46DmzOShBAb6DzKpMxNw=;
 b=drwtGPAEcuNtzqdEE73XqB8jQQ36d9ow8jlOzd9Ae9OnjQG2ydj6IDip0z9Ifx+5UF/Q7VCEqZCBhRAFMYZwJBdNvT/qLeoQ+4Kw5uZ2U7ZkaTsBDeGkpkyNw67VBlwS0yxyKk221DLAq5pGERH4aEqIW2a2P58TkNHnHn0eH2JyQfUC6e2kmmEt0cQr2yNz4GeJk3MxTzI3J8wuCte6dibdukvGnIY6hu2/fHGxVP0CwAr7INPSSa7JgdFZmc6QSQXXyycy+S2QERUGugKBXUztm/F1xAfNq9Crt0dDAE0EdoyWH8Z7SlsFO70ixfyDyeDVVdpDgu0ymY+U8WCFOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA3PR11MB7978.namprd11.prod.outlook.com (2603:10b6:806:2fa::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.20; Wed, 24 Jul
 2024 02:26:20 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%3]) with mapi id 15.20.7784.016; Wed, 24 Jul 2024
 02:26:20 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Alex Williamson
	<alex.williamson@redhat.com>
CC: "Liu, Yi L" <yi.l.liu@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>,
	=?iso-8859-1?Q?C=E9dric_Le_Goater?= <clg@redhat.com>
Subject: RE: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Thread-Topic: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Thread-Index: AQHajLJtgFipqDFp5kGVxfWLZ+e8jbFqmBhwgACbmQCAANtx0IAAWtiAgACzNgCAAAsdMIAAnMyAgADCDYCAAJZRIIAAuGoAgAWh6eCAAFrQgIAAvzfAgAAM8ICAATEtgIAAA00AgAAbNoCAAr9fgIAAZVAAgASNTwCAhOTNIA==
Date: Wed, 24 Jul 2024 02:26:20 +0000
Message-ID: <BN9PR11MB5276C4EF3CFB6075C7FC60AC8CAA2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240419103550.71b6a616.alex.williamson@redhat.com>
 <BN9PR11MB52766862E17DF94F848575248C112@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240423120139.GD194812@nvidia.com>
 <BN9PR11MB5276B3F627368E869ED828558C112@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240424001221.GF941030@nvidia.com>
 <20240424122437.24113510.alex.williamson@redhat.com>
 <20240424183626.GT941030@nvidia.com>
 <20240424141349.376bdbf9.alex.williamson@redhat.com>
 <20240426141117.GY941030@nvidia.com>
 <20240426141354.1f003b5f.alex.williamson@redhat.com>
 <20240429174442.GJ941030@nvidia.com>
In-Reply-To: <20240429174442.GJ941030@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA3PR11MB7978:EE_
x-ms-office365-filtering-correlation-id: 3ee8a8f3-675c-4be5-6d81-08dcab88015e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?iso-8859-1?Q?n3kPepEpTPiatKJO9sAGvzUAEILBTXJgKTl9ooFBTx8C7hiXTpQRvcrKmw?=
 =?iso-8859-1?Q?me7GzK0viB6sXiJbG3vvUxI5jdesgonPjqiovLzCniM80Jb2/LWMt96Ion?=
 =?iso-8859-1?Q?NwNTyBckZB9p+ekCn0TcHfLCTjCiGa0WySLzTPMUnuNt7zvyBBi+MFdarR?=
 =?iso-8859-1?Q?ekulh3lcaeWW7rxHkhiQfQLr4OvTGFIdxbjR/q7Tl2pbevv2B3brrkInPc?=
 =?iso-8859-1?Q?oTFeg6Kl2ntYYezJh0E3UZNWy55iT8Yh9hb1Dr87UBQH87oas/1+7IIE3U?=
 =?iso-8859-1?Q?x7QczJgdesKXqKXFZk26ZK5dXzs7kTlF+9GrcT4YxqvYZOstdL9vbTLPJu?=
 =?iso-8859-1?Q?1sBw4JqMB/h6HPoeyBg3rcG5isdyk3iRjR7xf9p791CGULM2HVQFsgkoLU?=
 =?iso-8859-1?Q?v6EB6iwuH4Sv5ekWD99AcSH7QpneSQc2rTFTG3qF15yxi4187en/J3m5Or?=
 =?iso-8859-1?Q?oezcaeiwAClwYzwevNAEDao3t6EEtdhPBOAVHyWzwUc6ofBOSTG7TaeONA?=
 =?iso-8859-1?Q?5sbClp0f0wDvYFJ9x7Qsl8AkNDSfV8exNK0ce+j29yGgPtHXO3sLal718o?=
 =?iso-8859-1?Q?Tot286j8hCJvM0RD7yWMEQsjDSEFfdw2jwrFAx2ZTobmH321nB2a+0SFVw?=
 =?iso-8859-1?Q?trVkpsVyFn/C1WOB4YFTdt6voa1tiCUQuAqkDOPLbf8Axsep3CEZkwizcn?=
 =?iso-8859-1?Q?6c4MWBpEBmYqds5Lrq+5mI1ACTlLh5SpqoJvyIciHNUsKkZC4oltSmbjxX?=
 =?iso-8859-1?Q?2i2RKAPRei/zgYfWTx5O20cnx1ghCLW91GSPNqxzgW/6KcIZJRb6Cd+8Lm?=
 =?iso-8859-1?Q?s36J6bN15EbhB/E+q2jv/SIVq277IIwiwByoTnzRdc5uc7Lrtun/aOfzEM?=
 =?iso-8859-1?Q?cPivue+bPYu50Xj0yyPeJDD0z5zYH8g23gROSGXhucT670v2Fo1nOCY7Z3?=
 =?iso-8859-1?Q?5WhL5Yv7DU7nU6zKT81nr9z4KhXDWb3poqn7oAX6mJfIqudnspkmerui/K?=
 =?iso-8859-1?Q?86kd91NLZS4Muv8TSsxi3lj6slKt/n3QGgbgdHhruoA9JZ0yXWXi8zKcdP?=
 =?iso-8859-1?Q?cfTkviVqsZHd+5UTMXmrLwoxCK7Cnv1McZe85Qi+x9JdcekASg/2T01QID?=
 =?iso-8859-1?Q?pc5NLKhSWR+tghD/aj2SvPDG/gMRff/x1kh13InE1qtzdVRGmH0nt+VtDc?=
 =?iso-8859-1?Q?1dCRYpHwg4e+XpKFnJiSIIU0CqUtimAGkUqij5jOaEykqI/IQIBWAOtxrc?=
 =?iso-8859-1?Q?fymmrz0XgIY9Oo8TDJzwRcdnFPp97NVsokhJoFVGfEH/b406WUpD5UkNhx?=
 =?iso-8859-1?Q?cr8QzppEde+ed8ctlKpjYNvzgBQgk+7t+65rmRbe6DPYNLbaKRSNyVuiTn?=
 =?iso-8859-1?Q?hDhHTav4sQI5o5wEe8/CtOndO0ErTdX1kfpFegOh0St2ZZIryaHvukgw7m?=
 =?iso-8859-1?Q?i0halnFhMrjgfHCL4JPNdWc9RPw1LzuWxWkdCA=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?6QRxCgn/SyYWh5YGEdLGf+zqsRYa0EPBaCliJlg2bkKEFzgmw9jixiD8sO?=
 =?iso-8859-1?Q?bI20cF7TTTd+Z7gWiwoCp4u94IcwFrroh08jnmxqGZIl6HO03WFQUKD7P8?=
 =?iso-8859-1?Q?KiKVD8j+K672F6vEnbuEFjP22GmY79iKruCl3QxVcgxVy11jzL2k/lS0ht?=
 =?iso-8859-1?Q?DmlORgFecjWKkipKsXpsa90HcZYmjWY9dy5HrpmyR3MBb3kXM9Bonq9+2b?=
 =?iso-8859-1?Q?t11WrUJMeDgAWEQR9x54Df0fvPjoZ2N17tjeLB4wqqBGiRwXfi1lAUZZWp?=
 =?iso-8859-1?Q?yR4pJ+pnUWWqPUkRqsvW8BJ5gcPQHQvoSDyh9mC7khcbwmgFuC9+qVgKRV?=
 =?iso-8859-1?Q?B6+NFMIOT2fjLnxPzwMpHNAzTxYtUoSWXzQmzyugNyv7gHpO3z8fQ2PAvH?=
 =?iso-8859-1?Q?J0RAazFAKvDoDv5uJs9qfzCEqWNyfkDjwgpoM/4MCpegUYLt3Ot97toDNs?=
 =?iso-8859-1?Q?7+U88BDQVvyyY4uMLZRYDBMzsfFuJ3bLOCGMb4kjwnAn6akjdk2ojf8qXO?=
 =?iso-8859-1?Q?cY5kPGIaXWKupLkuf2A3XjLFrEGmvxOkZPKavtCktTAgwqHvtnpI65V1MP?=
 =?iso-8859-1?Q?OIEKSreSvfYeHKYINjX9l2MGiQl7TI5QjZX2DedpFKabFMe8duuYrNKRRx?=
 =?iso-8859-1?Q?39+7AOA+Y2KVOsRidzN7K8BM0EEQ2TDH5DthjaImW2uBnTgRzNa1BoRjPz?=
 =?iso-8859-1?Q?WrnhHoOBAmGrcA+GCbRma/MEuBNJZJ8B6qZ5d4jemZV9qGkskuFBUvfFig?=
 =?iso-8859-1?Q?vrQ0eEPmCxVZbHORrnHXrjgsF2wyn0F8JpkVOw5z95Vo4m9P329RqdltjU?=
 =?iso-8859-1?Q?WNraCThbUciKfzB0opbj4AQ6kBTLXomz3OKujewtDM7Zb0dhIIvrveIu27?=
 =?iso-8859-1?Q?30qUOPeFHfHPQ4RYRmV7Bu1MJYV5V066n3CiuJAAwAl5CY11Lcdp4vy9uq?=
 =?iso-8859-1?Q?g9oNCYJxNWpPwuShB9H1DVt4QS4S3/KmC7XAF9Jy/poZLKPoHQWzwRR4qe?=
 =?iso-8859-1?Q?nd9+OAJYxWI51ORsm+grzGnqmhAXZJCaM9dHbNJvWLKBWi0PebeqmoNCkg?=
 =?iso-8859-1?Q?iiWu6dLnwHANNCJxLPoH0VZmYdd9ruvnaqX3fGfu+pw51Oi1lHzp9ZXCL4?=
 =?iso-8859-1?Q?C77naVKtDzBUWksZcwhNFoH+8ebxjDRIzmGykQJTCiytXYECTkVXCWK4Le?=
 =?iso-8859-1?Q?vZpZsM4FzNuXZYSkm0izzVYMaaJq62Nd75U0ataP44Kg533LUVSTY4vlhg?=
 =?iso-8859-1?Q?b79Q7ZztQnuIHtL2Y6whZTv87J5pN/NQhUBT2SpJyJwuwbYhqicCUDtEsk?=
 =?iso-8859-1?Q?BaCr9I3QOpcZqaw2c0uHdondKOkEat0yhrsQ0be44wMuKCfW4YETnz4D7r?=
 =?iso-8859-1?Q?6vBA6b2BPKBmycAzEBz7suVHjGFvCmCACu7fL7PHSHqmnb+rLhcD0yyA9d?=
 =?iso-8859-1?Q?cMbFUQbcnqLlsG9FQvJYCYpYY84LOxHWKuwF+XP1w51JAEXxNQKYK0ld7x?=
 =?iso-8859-1?Q?iliVW3HA0ujgppYtJBftxLM1KjYcT00XyN8xOXEPU/XQoRHytaJQ6wS2lx?=
 =?iso-8859-1?Q?WqJ6xGRp7FtQk/r90e+KCrTe6xMy6uQNOtPrUobDoSpgmxIAzODjDLYxgw?=
 =?iso-8859-1?Q?m28c33221b6PJsW4WXWYjbDwPR3V5MGUo6?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ee8a8f3-675c-4be5-6d81-08dcab88015e
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2024 02:26:20.6107
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ca0we/Kw3/HILrgBF6pc6OyBkyLND73mBHRecYGf+Mo3Iri8xCYi1o9uMMVj4Fc6Q2WWwiBnQrO1Go+86yi66Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7978
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, April 30, 2024 1:45 AM
>=20
> On Fri, Apr 26, 2024 at 02:13:54PM -0600, Alex Williamson wrote:
> > Regarding "if we accept that text file configuration should be
> > something the VMM supports", I'm not on board with this yet, so
> > applying it to PASID discussion seems premature.
>=20
> Sure, I'm just explaining a way this could all fit together.
>=20

Thinking more along this direction.

I'm not sure how long it will take to standardize such text files and
share them across VMMs. We may need a way to move in steps in
Qemu to unblock the kernel development toward that end goal, e.g.
first accepting a pasid option plus user-specified offset (if offset
unspecified then auto-pick one in cap holes). Later when the text
file is ready then such per-cap options can be deprecated.

This simple way won't fix the migration issue, but at least it's on
par with physical caps (i.e. fail the migration if offset mismatched
between dest/src) and both will be fixed when the text file model
is ready.

Then look at what uAPI is required to report the vPASID cap.

In earlier discussion it's leaning toward extending GET_HW_INFO
in iommufd given both iommu/pci support are required to get
PASID working and iommu driver will not report such support until
pasid has been enabled in both iommu/pci. With that there is no
need to further report PASID in vfio-pci.

But there may be other caps which are shared between VF and
PF while having nothing to do with the iommu. e.g. the Device
Serial Number extended cap (permitted but not recommended
in VF). If there is a need to report such cap on VF which doesn't
implement it to userspace, a vfio uAPI (device_feature or a new
one dedicated to synthetical vcap) appears to be inevitable.

So I wonder whether we leave this part untouched until a real
demand comes or use vpasid to formalize that uAPI to be forward
looking. If in the end such uAPI will exist then it's a bit weird to
have PASID escaped (especially when vfio-pci already reports
PRI/ATS  which have iommu dependency too in vconfig).

In concept the Qemu logic will be clearer if any PCI caps (real
or synthesized) is always conveyed via vfio-pci while iommufd is
for identifying a viommu cap.

Thanks
Kevin

