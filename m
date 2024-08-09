Return-Path: <kvm+bounces-23664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EA39294C89B
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 04:36:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4857FB22128
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 02:36:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95EAF17BB6;
	Fri,  9 Aug 2024 02:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nPcwsZ3G"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34219175B1;
	Fri,  9 Aug 2024 02:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723170980; cv=fail; b=OHzSp8N8Vc8bzUKTjO736Mz38FAwu7jVfHAkSClIGMjgJHcuALpDfCiMwojRIAbM4JFLn7VvE6T6LrwOyfUWDQJ+qaMFeQXfL5jBnixAIBSw5lLMeHMqxmJzYfkD27yEiwZaFwVhlvks6CNw1ncxBy8ztuNXNeW27HsdkZQwSok=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723170980; c=relaxed/simple;
	bh=ewiDOR5lvzjBNewFLdrJZ32gj/SAfEguY/PxGiwotJA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NI3JkvnZJeXiy+b6Efryi9p3W8tVLa4emScM0T/WmljI3IlF5MGSpbdzVjJiy8yqmc8vKQ3iU5gR2q3J0yLiE76mnoQbLCwXf+tAofDcMiwx4kJVlMourozFYAJZBnBgr6mq00nTLaTWTeJXBy6pDkV4eyKc6LDNQA0BKhzNX34=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nPcwsZ3G; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723170979; x=1754706979;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ewiDOR5lvzjBNewFLdrJZ32gj/SAfEguY/PxGiwotJA=;
  b=nPcwsZ3GD/9sfJBbQ1ogAjoKkuTD7JzidSBuuFl1bOj+CKLdTyR9H1J0
   cwUU7qq0Ui/3CA2dtE3vAaVjGr7byawm41HGaAt61sfuhSrtQSNkM/hrt
   DKO8sJ6RQXYS2VAiSQaFWemxiOeEgTvGybUwl+/+BKoqfXRdOnUrwCudQ
   f834NiAp7b9L0Ymd3cY5E8k+iXaqoTa+4j9BuETkHYSu01leKUAU5CfHV
   IktSk+Ghla4F51cjKJ0M9386d6wKQBwQPr2nw9cOWY055iM6MMK4IYM3T
   KYLS2q9zUFmvhJj05jddtK7VxoYlfXSkHEnztotQdBPZhnLsF7e/WRxGO
   Q==;
X-CSE-ConnectionGUID: zVI0l8GdR9y3OFhD0Mp9zA==
X-CSE-MsgGUID: sEo7l+wnSAK0Y9i2Hgp3Cg==
X-IronPort-AV: E=McAfee;i="6700,10204,11158"; a="46737733"
X-IronPort-AV: E=Sophos;i="6.09,274,1716274800"; 
   d="scan'208";a="46737733"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2024 19:36:18 -0700
X-CSE-ConnectionGUID: qBMACLqDTFycRExIMALKfQ==
X-CSE-MsgGUID: IT7ZYKafRvapOKNLc3fSoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,274,1716274800"; 
   d="scan'208";a="57299577"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Aug 2024 19:36:18 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 8 Aug 2024 19:36:17 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 8 Aug 2024 19:36:17 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 8 Aug 2024 19:36:17 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 8 Aug 2024 19:36:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nH71IKhad6OzlYBJ3XTkv3kPOTozHh5vnfG4XOU+ZevSOmHDZamdLjPHekdPrppkVd2bI6hUOD8KIxlI0lVXv2u+eue6HyPmKIEpd6Vj970ZiG0IJO/TXqJ37Y/7jIM95FoVEuUvtEGR6QbkdKN/aJ6Apf+8new+wfXexGJcePLslwrjbLhZEJE28DAQcFbqfSoNt+rbQfOD4AXndF4NHTQYGph/asde4SyE8jhh4G+9IOevCw7I3OEPMNAWW8kN1plBJpDzBX4jmCUdfhYskaE8UHZPcJHebhMeGp88bngyB/Zz7My2faQORGNpXejUVR+5RHDUpSw+iYuia8qAkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YPHomvYe7lz31NuTzZWVENEKRGBF3SrPu8Uw4IpaNx4=;
 b=WzLJHnB86I/XtCtlOVyJR5IHLyydasvPUI4Ge9tjbKra1iOCyw3ko1iHc8NHk7OLEhYDxDm078LcyRKDm3iKxtgzdpLDlDPV8yUqjxQsa4OE5HmZfnRO1OQ308PjTyxbF9FxmFMkdunIVqyhzTd4S2F2N8Crojr4zFmA/7mIGyOhXS0Dn2dsrYlJF7k7fHiTmVrU9MrEDQ8jUebHFLRxXNzbbvoJO9N5aRqV6V0EIVS7Yc2Hgix7PZ61Kji27JAFErREyLGh7VHAdUHWGmyoI6BvkIvkuda0tCRcbDrmyVW//XTHEKoXRSZ/3nHnP9dxW8eo64EEVzx1WYKtMueyAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB5072.namprd11.prod.outlook.com (2603:10b6:a03:2db::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.29; Fri, 9 Aug
 2024 02:36:14 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%3]) with mapi id 15.20.7828.023; Fri, 9 Aug 2024
 02:36:14 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Lu Baolu <baolu.lu@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>, David Woodhouse <dwmw2@infradead.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, Joerg Roedel
	<joro@8bytes.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>, Robin Murphy <robin.murphy@arm.com>, "Suravee
 Suthikulpanit" <suravee.suthikulpanit@amd.com>, Will Deacon <will@kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH] iommu: Allow ATS to work on VFs when the PF uses IDENTITY
Thread-Topic: [PATCH] iommu: Allow ATS to work on VFs when the PF uses
 IDENTITY
Thread-Index: AQHa6PZmMIHnBjt+Fk633+Z4DoVWPrIeNWKg
Date: Fri, 9 Aug 2024 02:36:14 +0000
Message-ID: <BN9PR11MB52762296EEA7F307A48591518CBA2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-0fb4d2ab6770+7e706-ats_vf_jgg@nvidia.com>
In-Reply-To: <0-v1-0fb4d2ab6770+7e706-ats_vf_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB5072:EE_
x-ms-office365-filtering-correlation-id: 86a8a317-cfbb-4873-6a45-08dcb81c09d0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014|38070700018|921020;
x-microsoft-antispam-message-info: =?us-ascii?Q?01+RCnq+EzhsS1EBKIRm/y88FU8R4U4X83uWUvL6c3hgbxMqXUYpboUusskK?=
 =?us-ascii?Q?hMr4zK1aWZJ8ztH4SZm75GrM/GNCExA5wck7Sgc1Y9I/gWQg7HyxCGfqPe9y?=
 =?us-ascii?Q?FJfVlNEda0hlNrgbeOeJcIQG2dncUjaIZ6ulGqOyuBuJYALsBuq54vk/p1Kk?=
 =?us-ascii?Q?L6xdYpmKl0twTzNYFa/L9zZxmo97hSkmYbnc67K1GTVX4tjLVXpCWvTawruU?=
 =?us-ascii?Q?OyLmg4xc305bYNABG++PSq+ua8ydngXZ6E3d/AeNz0+UTT2WMWETyDbY5eWR?=
 =?us-ascii?Q?pmXcSDMH3GO6NT9ysM7FauSsjvsTpAYUHvwsqgdQ5U3KRLlgfKBGM0E5q3dH?=
 =?us-ascii?Q?FcRxdkHb/ofO0Fo0aulz1sgnyxHUzpZcHNJ1JXdq4UjfgYeFf8rrun0nZVbQ?=
 =?us-ascii?Q?+tvViTRplEWO8mUwnUYrdWgjyZKQ6TycF221k1/SAdyOoyn3H0l0wEfQaOgm?=
 =?us-ascii?Q?Pqu8qBluzEB385u+FelL4rJcQ8+8TNMKYETpfFabPLMaevAum/ojv757rmYh?=
 =?us-ascii?Q?NkAZw+BB1lHo/a/BuI5tG5dDYtzjtr2J7fUjXfK3dySimosTPvDH3z61u8sT?=
 =?us-ascii?Q?Dr0YHNZU6ZsbAf1GKOXxIoluv2A/N2g5E/CEeHtizCZ9hXGRr+cjTpyKOmd3?=
 =?us-ascii?Q?Gvvqkzx8nGvaHk1s2Ux1HmpwSqKaIylX5WDdOhoz0dJSoiG7klRwOaNaMVkx?=
 =?us-ascii?Q?ZYYlXtpS8iYNVSQBoQR61IL3IBE5eAU+c9LvYEke9wy6FCkqU+5+lsM3Frjd?=
 =?us-ascii?Q?BlmeADsbymQCA3ex7PKZU9fHIH7SSZE4JS0soiYFQ8BMlpbETPVWw//kNZXx?=
 =?us-ascii?Q?54TsCHTReMOTPjh+bJgjpzONXZ3AN8c1GF/RJ90jEJmaVl1R5cVKZE0whBKs?=
 =?us-ascii?Q?nkVV+MYqsnC4HwYzCoSprqa3hG9RkqLXS9EfV7QINRkbrr3as99JckJI+KR3?=
 =?us-ascii?Q?sRI4plgizK2rx4dJb0wF8mlHAsasYh1wAl64XLSiYGRIlQQ4nqfXD/a+upRF?=
 =?us-ascii?Q?zE81O3D4gLwS4kqLFN8PDnTlNaPrJFvukm6OTxkPKjYXKhjlXKX2PrafS0+p?=
 =?us-ascii?Q?QOWp+kgNIl3Qt35MqgrWBk0fdFJQuxq0Wfcmjuzh2IqhH9ZOx33xjCxhlLF6?=
 =?us-ascii?Q?ljtGoSG3uv43mVRuVSBVv6lGOmbcaWmTWX+fmreeRH8a3syF5FpVKyKT37va?=
 =?us-ascii?Q?y9ewQRJ+HN4Pb5kLYiN9bPeSGwJEhiLJ/jg5igd74+oE3Cjoo0gDqNxwaGkL?=
 =?us-ascii?Q?1GEjE9+nt7h8WUAY+zG+r1nILh2WgPtqo+rYIOkrfCNEIc7+DZ1Lrqzq9ovM?=
 =?us-ascii?Q?kkTTn7+U0yV0qN0rJ+6QG1XgInpUD3kuFW0pM03YzO4j9JRohI8bQ2DsolkR?=
 =?us-ascii?Q?PopoYkZhTumG0HovFwFp2Vklko/7d+TEvGY52tdHMZXg8xwHvFT6xkniZY0p?=
 =?us-ascii?Q?z9D0mXqjyBs=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?IvgbWknofpJjLymro6pvhaz79NEazGDA6FjZC2fx8b3d9b2XxtUZ+gWXYz7F?=
 =?us-ascii?Q?Qfs0o7y6+0Y8jn7AhRaYWXQsdw6FcG/DG6cKW3ZwuUVpitpbNylPFs8nUOev?=
 =?us-ascii?Q?HBmFCF3CTZtjrImFRQG4NWalpbzZd8qK6zztaxWnQj0DfNdFZV8JBVZ8dFXv?=
 =?us-ascii?Q?m2P1JQ52mWNjzmL6qoueRwowJ5RVSxkSDoyeqF1Sw7fbNXAnO/j6EMJQIJp5?=
 =?us-ascii?Q?rbTnRcSyCKHPIQi+9KuVviugmWtcTGTrAF9HWtYwJ0nlGH7uJO6rWDwfPoTd?=
 =?us-ascii?Q?dNOAVW2wouQ120j9gzgCtg+JXYfroBOfjxdiSJLqh24RGdtc0PNlDYybNi9T?=
 =?us-ascii?Q?su349O5kvigPfjAa+dRb2S6Wh4C+5Fz+w7ehYWxCMQxupN/V5bdm49lLq/Qq?=
 =?us-ascii?Q?4AyWY+mEyP6owH5N8j/VDk8EmCfM/OikN7tHvhLUflc0FcbSFAVWpCTl6ziK?=
 =?us-ascii?Q?ZESFZXTbLKRtvoh/3gafvicB64XT8OP9G56xEdIZ0b3IqLrgzE+fmqZv3GY6?=
 =?us-ascii?Q?E3u2XKl6M0iujZNgPnJRf8bQ4glgAN/aqfmQpx+Z4/dY/WsZsF9Ph+vD49ds?=
 =?us-ascii?Q?2K6UfsI8wPBedqkZRKCorL2rLjxRhs/+qblyUyCS4il3M4VE7kSQNtvsBaZr?=
 =?us-ascii?Q?tLMTaOoPpnMlhxTK+IkqR7GRGCiBhcvJ115m6+Tfds/ypy5cIAnHKc4X+IWG?=
 =?us-ascii?Q?Hvj89D38yTfgw4h7UIKMEWAR88oH+3scoqK8A/G/J//hAaSod+MbdOp09dUC?=
 =?us-ascii?Q?FASD91qlPaRUPRZVhZOgkrvoXKpkcD1TFKsKqwf1V1advdIxunzmqD8qjwXB?=
 =?us-ascii?Q?fTc1fvMuZ3zi/c8KhXA/hQ1CXQXuIiZuBB2Gvw48L3fLSPcN8wxmmy5GFJa5?=
 =?us-ascii?Q?jlPF02+FWoNtvyNrVaVMHR8xyLv/38o4e2IIcjqJwrteBymc/uEXWP//z1OX?=
 =?us-ascii?Q?galgMtht59BFMpOY7YoyXsCBOx1Wt301pYwtGmMUPoHmSLfNz1M425x+tDqy?=
 =?us-ascii?Q?NHUCAPH6Io9dwNc2EZyoTOINGSoH7IWH35KpKcUMknyeh/2auXwn7g5eqgNe?=
 =?us-ascii?Q?f1Ko2LwpwIn0/6wlRmbVen9WWChGEen6mFBP5V1QfKkPhguEW8honXiqnKhl?=
 =?us-ascii?Q?b2ua5sGiRxtxSVP9RaKnmg/B6czGMaFRG8ouvTosk8kDqpzmedu41/RJoeLO?=
 =?us-ascii?Q?DxRZGu8/tYL/cT+uiSq0axYzhRvJkL+KIOppIjTMwv3cmenGR+Tr0qyOw6gQ?=
 =?us-ascii?Q?MVFt1ubv6sU+VKAQ5NM4LA/McpIsHdFfHZxsQjKPxe2uY/XrYRxeF617i18Q?=
 =?us-ascii?Q?TL04aBa5eKRRXB85oU8U3EccXV5e5Xihk5MT0ha/RzcETcbDughmUODl0+NA?=
 =?us-ascii?Q?trSKH4Z6qq3zja3crmrYXSZveewOi7vpMKiTWmE0dJBK2C2lu6aKRpKE1vX/?=
 =?us-ascii?Q?bmDMMs7biSrkqdkirfECrMb83qRugqzkqa6UzVPfksZa+2Yf2Mix6ClaS3Hf?=
 =?us-ascii?Q?ZzLxr4/GV6LZiXv0BpVMgo5/692hwCSM162wbkY79t8QIExoCVpKtN4GnMXd?=
 =?us-ascii?Q?6vZfKN35WOu8gmXGjNCnj9HONA6IJqiBtznIeo0B?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 86a8a317-cfbb-4873-6a45-08dcb81c09d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2024 02:36:14.2639
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lw5ND0b5y7/hgPU/UVjjedr0xPDdwQBprwuOHTGSLDM9unSMHM92X3eAvEv9zXPbB2FIXIRp1+3kQynXGJdnbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5072
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, August 8, 2024 2:19 AM
>=20
> PCI ATS has a global Smallest Translation Unit field that is located in
> the PF but shared by all of the VFs.
>=20
> The expectation is that the STU will be set to the root port's global STU
> capability which is driven by the IO page table configuration of the iomm=
u
> HW. Today it becomes set when the iommu driver first enables ATS.
>=20
> Thus, to enable ATS on the VF, the PF must have already had the correct
> STU programmed, even if ATS is off on the PF.
>=20
> Unfortunately the PF only programs the STU when the PF enables ATS. The
> iommu drivers tend to leave ATS disabled when IDENTITY translation is
> being used.

Is there more context on this?

Looking at intel-iommu driver ATS is disabled for IDENETITY when
the iommu is in legacy mode:

dmar_domain_attach_device()
{
	...
	if (sm_supported(info->iommu) || !domain_type_is_si(info->domain))
		iommu_enable_pci_caps(info);
	...
}

But this follows what VT-d spec says (section 9.3):

TT: Translate Type
10b: Untranslated requests are processed as pass-through. The SSPTPTR
field is ignored by hardware. Translated and Translation Requests are
blocked.

=20
> +/**
> + * pci_prepare_ats - Setup the PS for ATS
> + * @dev: the PCI device
> + * @ps: the IOMMU page shift
> + *
> + * This must be done by the IOMMU driver on the PF before any VFs are
> created to
> + * ensure that the VF can have ATS enabled.
> + *
> + * Returns 0 on success, or negative on failure.
> + */
> +int pci_prepare_ats(struct pci_dev *dev, int ps)
> +{
> +	u16 ctrl;
> +
> +	if (!pci_ats_supported(dev))
> +		return -EINVAL;
> +
> +	if (WARN_ON(dev->ats_enabled))
> +		return -EBUSY;
> +
> +	if (ps < PCI_ATS_MIN_STU)
> +		return -EINVAL;
> +
> +	if (dev->is_virtfn)
> +		return 0;

missed a check that 'ps' matches pf's ats_stu.

> +
> +	dev->ats_stu =3D ps;
> +	ctrl =3D PCI_ATS_CTRL_STU(dev->ats_stu - PCI_ATS_MIN_STU);
> +	pci_write_config_word(dev, dev->ats_cap + PCI_ATS_CTRL, ctrl);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(pci_prepare_ats);
> +

Then there is no need to keep the 'ps' parameter in pci_enable_ats().


