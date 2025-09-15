Return-Path: <kvm+bounces-57532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E135FB574C7
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 11:24:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 126E83B378A
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 09:22:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4272F2F5319;
	Mon, 15 Sep 2025 09:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jsl4W/So"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2049.outbound.protection.outlook.com [40.107.243.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63ADC2EA735;
	Mon, 15 Sep 2025 09:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757928109; cv=fail; b=F9hZ22GvkVPVqNcBETPUL1BNklUYyszZrI2XnvsaVpc7Yvo5bbJbffFtnX7npzUC4HAiyjCJc+d0s0y6aYK4e/RuekpvV6h6n8iDBtZ1Ipp5maYHhly8QLXDLS06GYmPQBe5Up4PY8i2Aaa807eEI29VEgXAQ+XV5pJpKkINE1U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757928109; c=relaxed/simple;
	bh=BS6TLOPJpDH13uKoHZI3C6AEjIjAAiaeVz05utgwn34=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EuwKtCH07CjTkZZDIQ99ey/hPnQ0zJOHT++PUVvL8L+wFx1vMbNZqfy0FAWO+qU/qMqJTH2T/WZzPyRNrC8juWZuVzcOmXxd9Qm6+882zxSWwnkBAoh0LEFf+z7O3uf9UQeZPnS6ts8E9mGmcY7tHmyhoaXYBnoLjCfubrUgp9s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jsl4W/So; arc=fail smtp.client-ip=40.107.243.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IYpmcJFHuTsxPWGEb6YxN1EOzTU7jsNm8g+A1wizCtNe4A1g9Abs+ddh7RwzF5+UCiovEJGHRZT8Ns+/wXjXwrhQ4PvDo2NGIEs8xPB2jPNTxn/wCqclUmfvPQrwigj206NFwPfKyrAACD9zHkSprmi7bwUYm7KY2xjpzhqdof+YYFqjLqEPEfBxRmyRuGWSv6lrPfeFdDejNJ1x0JBfoEKZuOsgW0Y8lho8dfWzeZpXa6pFePpZ/AL/HOs4K5tBsovDYGDurYpAGW1yv4K9H+mjo9GxExyxKK8N0ddf1z4eTUn2gNCLtUYM6mGVBiin7tveuYwAQhMSJSs1KYJy+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3PBk+TR3XygkoEGYCI7L3Wfjgn1ehOvROJ42moXdNUg=;
 b=IZAPBrra40+onxvT4hb0OSPgYXymHojyeWIqfkna1NiXeIcu8vHsyVI2c+Aigp6lFI/l7G7ObK+EKVwmqBgtcO/YWmFK2UqwDVDrWgg7H6T/6LlV5kRpmki+/VAXjM2tBTzqJoZdnmyFtc4h0wpMXKAtMeMOdNd/Xw0QaKPJIlviXWmb8lbK4Hpcs32qjZuEyt7WLsjyLwOp55cCa2xaZVl0CxXcXv7LFRqgBUFXa5Chh1QMgMY3ZMZCfIzBP+4VKaay6O+UHeR/+gc+EPgvIH4mSAf4vcotdNXPmse8pSqLDmdhYY/b+sNmEV2UXSpzqzkW06OIyK8x6DS0HeCF0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3PBk+TR3XygkoEGYCI7L3Wfjgn1ehOvROJ42moXdNUg=;
 b=jsl4W/So2cfZUATcsuhIhg2oquHGzFihP0MbUe9zBG8DhXk4KMHC0QBRFRnLWbKh/97nRs8I3mxSiYkSTwxRqnkvIWNQukU/x9AEF1vq75Vri3w6bKIDEoO0Sd86a8n4o7x5JaYAKrpe/vifKn4gIxSKdUD2N7Boj+LFyJWHD53xx+LFgDJsDlodsn1n22c88jbTc54w8zzM5ZQOgGFHRV3TWewBGpybJCk0sIQuvRYJUeM13Pk74NI1E95v/EtLPyOKMdIKySUZR9Al58YT610V8zklvbqUHpkKWJVBgKMm6SsAWhPsSRr3K/mY2iDmEo8Fo5a5wFuAc6JaZ1LvtA==
Received: from IA0PR12MB7555.namprd12.prod.outlook.com (2603:10b6:208:43d::5)
 by CH1PPF12253E83C.namprd12.prod.outlook.com (2603:10b6:61f:fc00::606) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Mon, 15 Sep
 2025 09:21:43 +0000
Received: from IA0PR12MB7555.namprd12.prod.outlook.com
 ([fe80::963e:9c86:4830:2ebd]) by IA0PR12MB7555.namprd12.prod.outlook.com
 ([fe80::963e:9c86:4830:2ebd%4]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 09:21:37 +0000
From: Shameer Kolothum <skolothumtho@nvidia.com>
To: Ankit Agrawal <ankita@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, Yishai Hadas
	<yishaih@nvidia.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>, Zhi Wang <zhiw@nvidia.com>
CC: Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti
 Wankhede <kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)"
	<targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy Currid
	<ACurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John Hubbard
	<jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>, "Anuj Aggarwal
 (SW-GPU)" <anuaggarwal@nvidia.com>, Matt Ochs <mochs@nvidia.com>, Krishnakant
 Jaju <kjaju@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [RFC 11/14] vfio/nvgrace-egm: Fetch EGM region retired pages list
Thread-Topic: [RFC 11/14] vfio/nvgrace-egm: Fetch EGM region retired pages
 list
Thread-Index: AQHcHVGddRYNONvQr0OffZOZ03WJC7SUBHJA
Date: Mon, 15 Sep 2025 09:21:37 +0000
Message-ID:
 <IA0PR12MB75556D77378EEDE673132DF5AB15A@IA0PR12MB7555.namprd12.prod.outlook.com>
References: <20250904040828.319452-1-ankita@nvidia.com>
 <20250904040828.319452-12-ankita@nvidia.com>
In-Reply-To: <20250904040828.319452-12-ankita@nvidia.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA0PR12MB7555:EE_|CH1PPF12253E83C:EE_
x-ms-office365-filtering-correlation-id: f2b3fb6e-ca84-4c59-421c-08ddf439456c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021|7053199007;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?BBjGIRjXBJgBv+bQNIZoUqmFCa4xiEaRKln1f5WksbDCyhzKx56zv/iydeMo?=
 =?us-ascii?Q?BP+Qar+PRooKezWp3U4jOm57jjaT6gUStBpMy1GTib8M5KuIVex3UFp1j7CE?=
 =?us-ascii?Q?eEvoo/PbGtcVtkqSe2/qXaM5ybSiDP2Mnn/hWjO8B+vxQEg3C6w02TNmIIpl?=
 =?us-ascii?Q?iJkiBt5mEh4lNfhzjCK8E5Ag4IFaN/dZT0jPXQhb5sdP/Bf1yTiwg0Gx2tnK?=
 =?us-ascii?Q?KFA+mZZ1SwYV/2+WXIhXV9XK/6xvnPaE6tee0nMi3cWUhQVrG+wBq26faBhx?=
 =?us-ascii?Q?UQgQfq5jTv5C/IDymB7imKW3VhJrt5ahPILsSvuyP7BJG4TEoZl3tp/eDOkg?=
 =?us-ascii?Q?LpYhahIuoK1mZu8KieqXzPJ+qQSa0X0sgvuwWoOMJrhdy/rZD7EiTb0LLc24?=
 =?us-ascii?Q?bC4LqnR8mVuOEwtn9MnRlEB1jBkIOacbwr2UEPnA521cFhkIG16zGSCu6Ty6?=
 =?us-ascii?Q?BNxCBrVV6LtTXMaHkTLipLQyz5kWIkKFWY9EJ+2SbQB3F/EV9iIgDK7Xa5En?=
 =?us-ascii?Q?ka1HEMyUjJVLhV7YSEqLPIu6AwIrDxDFbVY/P56iGtlh+ueE1pZU5fIeYDZl?=
 =?us-ascii?Q?Nu8P2EwvHxmVcuI+/hVGthY2HEtCx8YtSAyZs4kYZ8e7JLrtsP2iF+P9xHu4?=
 =?us-ascii?Q?GIgNbw5WfnRVhXQua59R/ACms2B8YW6jHx0J/a48l/y4xb70ShXyWOHmTYzT?=
 =?us-ascii?Q?8y6xhds62OUDCQl/A2fY88bfmY/ooQ2FK/oFXUZHMXZ0D0UANcWyMRIELX49?=
 =?us-ascii?Q?yyMJZ0WJVXOIcrEq22q55D/mzQGxk/Jl8XruFf7ZVuToaakFn94RgCUKiNmU?=
 =?us-ascii?Q?6b97HMWRWzajSlqn7RjmQgpT6AugN0D6OQaejCoZIVxaL4vAg4sUX+lGBpjy?=
 =?us-ascii?Q?Jqz7CRoUNj2PSX2W9ZVDVB1s92L8Z5q3HBGs9S15SA0OK7wmFREqyczjtHw4?=
 =?us-ascii?Q?45p8xwje5hTeHUdlgKY4J9rnyl7mQGLgp1k9kHJUvZ9397fqSTa2LLpDnj3x?=
 =?us-ascii?Q?1qJ3yoMY2Bplei1SRt6iMw6ZA0WV7reBz/Yt54xL3sA4Vgi4r1V5ESnvQ9Yh?=
 =?us-ascii?Q?My3dkW2L9bTJeclaMI1zcgqpB4Xre5+Of2qqI0mRxzKV9YqsxUEwBBwL74KY?=
 =?us-ascii?Q?0G16W16hfMGTch3Gwo1d2LIcMD3gXkR2YgS/MY7msKvBznlv9AQHdiQyveVd?=
 =?us-ascii?Q?9kM5mRNvA4DlFmsXXnDt+n50A0vwHy277KMRcqErU99lmvlvrOtaKHfaij83?=
 =?us-ascii?Q?HGaHiazio7alylZVXiZBWH/P1HqlqNL/JC/YUnpKfLiyATxkfHaYc8+Q6ypq?=
 =?us-ascii?Q?WLq1lXMM/hHkxt0fPHLzh0E0tzdXw4jRVkoKI3XC15Hl/733Df98vPqLj6Lz?=
 =?us-ascii?Q?PSJ+stj2x52whhMi0Ehp/H2C69dsTHh1gYdm+Fo9FZd4MSAdmtXkVB/BdTPP?=
 =?us-ascii?Q?XE5t68jp8GtNnk17rwNaRHW2SGCcmY1bJU63k5IGdJmdKM8MFsYPDrNv63D/?=
 =?us-ascii?Q?SE0hP3mS4xdnUJI=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB7555.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?+fMKcSqgCYcWcUoNalQuQSb62s8SCcIGRQAldDub/EWa4BFjGxbeXzU+Zt5d?=
 =?us-ascii?Q?k2Mh/tdYTH8AhcagAPlKDROGUDuv+jy8OK6kCHWFceEH2KvaMtPZHQTkF73n?=
 =?us-ascii?Q?VA8QintrA2eaVyLcbcIx9ZerMOWAFZrZM0pRE1AMxl0zZwEYlBnwNvu05ks/?=
 =?us-ascii?Q?DKf7l+6dIfqGyafksWv7LvLZfwINr33Rb4HvK+XZP2G0WkGai53IXSlrmzTZ?=
 =?us-ascii?Q?qF8CEg0TTethxxENQG2F6vw1AQbb++MEIAZ6bbWb2v+Bq6B2yAt1JtcJDay3?=
 =?us-ascii?Q?Ji5DnJTBMft7FY3vOG4JB5rRLCwJRuwSioe+jG4ZsIRFcgv45+5nRBhlOiR4?=
 =?us-ascii?Q?MOmkI6XCYi9oQJsYeqyu/Xdek/4SvHHn1fPC0u/V/D+0JQKh3HvdnmQ5c2hX?=
 =?us-ascii?Q?NB7ytliFEii7XtKPKsx5lzAZ8K+Q56KIu6IC8B67knhw71xVX8om+wK92SMk?=
 =?us-ascii?Q?GTm44FSPp4ppH+TcErMkA7k7uXFbm1ES5Ng9gsxAoOMNVEvvwyJFCBmrZKvH?=
 =?us-ascii?Q?2f8q01NWPerJ8ub6QcXrUOtNMvvOSXxT4KCOgTpNhL9KSTV34ZPvH7eSk5U8?=
 =?us-ascii?Q?g9yA2iW8l0PMVZl2LGwsXv0EiUTOqpXp1UIBUTxjBuxM9UnVptRyt3QF8B7W?=
 =?us-ascii?Q?BQc0NxF3c8cOWMLt9apJGato4CdoBKRYJIX9TWeAU+uUCHwy+aVUKVlp7ctI?=
 =?us-ascii?Q?rs4qwdW4UwFQYFg23j4cp36Ie+wrqwI7nPiaE5vbl8ffB5Mv8NstmfQRKXmt?=
 =?us-ascii?Q?TX69A96BkrQydQ3DPFAeWBUk8lfclAiR8jdg2gH6p11yusNj5gbJbwKRHZGM?=
 =?us-ascii?Q?h2QsB1Zb75FSptPFRGTDQFfgfYgF5fozgZh51xoBe8HRLK/CKpR/O9KhePAz?=
 =?us-ascii?Q?HmhkO4fyX20f4FiuLFLimUAA2HmMQvLqRaTAq29JJP8pHUchKe8Cj51XjiBw?=
 =?us-ascii?Q?kPyTeoWxyQLYFCkua08IHUa1xo/HunbLvMxSvSNQyiCM03KmtLwnNxxLIf88?=
 =?us-ascii?Q?CkTgv3N2VkbcyFRS2/mxzAHf1EcTVNoPn19gO57YtCxfczPo0iAjQkqLGJjr?=
 =?us-ascii?Q?8nPT0tJSB8b28/jM+/JI6IycQQB/R6NeSRuEILGZk202wQpkomBg0DUeb70b?=
 =?us-ascii?Q?cILuLIMmFn18hZ+0z4C0isdKNpFb1Mc5aPTrRWZKt8e2q4ckjMLD5ZJOM3Hx?=
 =?us-ascii?Q?bJfV/YES9q0opCxOuiUoxth2T15KImJpVVfFpwjmyJbFvZdlstWazFipBPao?=
 =?us-ascii?Q?nNFQj+nw2lnExnXnIWo7YdmvbPZCBhIiUqAWEfpO/4R35ZIsOksBH4NE5M60?=
 =?us-ascii?Q?JIs9YOk0rqlgqh0HQhp4iKU4G7rvuGxSWzVHsKeiecb3zgXPGUnovM1+6RLz?=
 =?us-ascii?Q?m8NEWkblr89g0FF2F+PtrFL70hLn2db7Dz83Q6nfbM2dTz/F1JNnzPoE7EOW?=
 =?us-ascii?Q?FCS75sdGcH4b7mn4upM3Ks6EhYguJbRP+5TACIyYdZ/VkQjDVWELA5NvCOvR?=
 =?us-ascii?Q?NrI3c1RPdfe1Bi+2E12/ELjiCBrIoH69Gr2BxRXgQYi4YEyXDUwm+JEZRJYN?=
 =?us-ascii?Q?wJJYISsx2JqLOr9oXpkpRad5pGjd5No5kIYKGj6e?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB7555.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2b3fb6e-ca84-4c59-421c-08ddf439456c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2025 09:21:37.1473
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UeN/XlACANOkUIjphN4w4iUGAcXomTFPIqAadB02VCVR4dePpgx8bw2vA4K+QMbXJKElFchwGg+KfTYfpnca7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPF12253E83C



> -----Original Message-----
> From: Ankit Agrawal <ankita@nvidia.com>
> Sent: 04 September 2025 05:08
> To: Ankit Agrawal <ankita@nvidia.com>; Jason Gunthorpe <jgg@nvidia.com>;
> alex.williamson@redhat.com; Yishai Hadas <yishaih@nvidia.com>; Shameer
> Kolothum <skolothumtho@nvidia.com>; kevin.tian@intel.com;
> yi.l.liu@intel.com; Zhi Wang <zhiw@nvidia.com>
> Cc: Aniket Agashe <aniketa@nvidia.com>; Neo Jia <cjia@nvidia.com>; Kirti
> Wankhede <kwankhede@nvidia.com>; Tarun Gupta (SW-GPU)
> <targupta@nvidia.com>; Vikram Sethi <vsethi@nvidia.com>; Andy Currid
> <acurrid@nvidia.com>; Alistair Popple <apopple@nvidia.com>; John Hubbard
> <jhubbard@nvidia.com>; Dan Williams <danw@nvidia.com>; Anuj Aggarwal
> (SW-GPU) <anuaggarwal@nvidia.com>; Matt Ochs <mochs@nvidia.com>;
> Krishnakant Jaju <kjaju@nvidia.com>; Dheeraj Nigam <dnigam@nvidia.com>;
> kvm@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [RFC 11/14] vfio/nvgrace-egm: Fetch EGM region retired pages lis=
t
>=20
> From: Ankit Agrawal <ankita@nvidia.com>
>=20
> It is possible for some system memory pages on the EGM to
> have retired pages with uncorrectable ECC errors. A list of
> pages known with such errors (referred as retired pages) are
> maintained by the Host UEFI. The Host UEFI populates such list
> in a reserved region. It communicates the SPA of this region
> through a ACPI DSDT property.
>=20
> nvgrace-egm module is responsible to store the list of retired page
> offsets to be made available for usermode processes. The module:
> 1. Get the reserved memory region SPA and maps to it to fetch
> the list of bad pages.
> 2. Calculate the retired page offsets in the EGM and stores it.
>=20
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/egm.c     | 81 ++++++++++++++++++++++++++
>  drivers/vfio/pci/nvgrace-gpu/egm_dev.c | 32 ++++++++--
>  drivers/vfio/pci/nvgrace-gpu/egm_dev.h |  5 +-
>  drivers/vfio/pci/nvgrace-gpu/main.c    |  8 ++-
>  include/linux/nvgrace-egm.h            |  2 +
>  5 files changed, 118 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/vfio/pci/nvgrace-gpu/egm.c b/drivers/vfio/pci/nvgrac=
e-
> gpu/egm.c
> index bf1241ed1d60..7a026b4d98f7 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/egm.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/egm.c
> @@ -8,6 +8,11 @@
>=20
>  #define MAX_EGM_NODES 4
>=20
> +struct h_node {
> +	unsigned long mem_offset;
> +	struct hlist_node node;
> +};
> +
>  static dev_t dev;
>  static struct class *class;
>  static DEFINE_XARRAY(egm_chardevs);
> @@ -16,6 +21,7 @@ struct chardev {
>  	struct device device;
>  	struct cdev cdev;
>  	atomic_t open_count;
> +	DECLARE_HASHTABLE(htbl, 0x10);
>  };
>=20
>  static struct nvgrace_egm_dev *
> @@ -145,20 +151,86 @@ static void del_egm_chardev(struct chardev
> *egm_chardev)
>  	put_device(&egm_chardev->device);
>  }
>=20
> +static void cleanup_retired_pages(struct chardev *egm_chardev)
> +{
> +	struct h_node *cur_page;
> +	unsigned long bkt;
> +	struct hlist_node *temp_node;
> +
> +	hash_for_each_safe(egm_chardev->htbl, bkt, temp_node, cur_page,
> node) {
> +		hash_del(&cur_page->node);
> +		kvfree(cur_page);
> +	}
> +}
> +
> +static int nvgrace_egm_fetch_retired_pages(struct nvgrace_egm_dev
> *egm_dev,
> +					   struct chardev *egm_chardev)
> +{
> +	u64 count;
> +	void *memaddr;
> +	int index, ret =3D 0;
> +
> +	memaddr =3D memremap(egm_dev->retiredpagesphys, PAGE_SIZE,
> MEMREMAP_WB);
> +	if (!memaddr)
> +		return -ENOMEM;
> +
> +	count =3D *(u64 *)memaddr;
> +
> +	for (index =3D 0; index < count; index++) {
> +		struct h_node *retired_page;
> +
> +		/*
> +		 * Since the EGM is linearly mapped, the offset in the
> +		 * carveout is the same offset in the VM system memory.
> +		 *
> +		 * Calculate the offset to communicate to the usermode
> +		 * apps.
> +		 */
> +		retired_page =3D kvzalloc(sizeof(*retired_page), GFP_KERNEL);
> +		if (!retired_page) {
> +			ret =3D -ENOMEM;
> +			break;
> +		}
> +
> +		retired_page->mem_offset =3D *((u64 *)memaddr + index + 1) -
> +					   egm_dev->egmphys;

Above the mapping is only for PAGE_SIZE and there is no check for count. Th=
ere
is a possibility here to access goes beyond the mapped area.  Please check.

> +		hash_add(egm_chardev->htbl, &retired_page->node,
> +			 retired_page->mem_offset);
> +	}
> +
> +	memunmap(memaddr);
> +
> +	if (ret)
> +		cleanup_retired_pages(egm_chardev);
> +
> +	return ret;
> +}
> +
>  static int egm_driver_probe(struct auxiliary_device *aux_dev,
>  			    const struct auxiliary_device_id *id)
>  {
>  	struct nvgrace_egm_dev *egm_dev =3D
>  		container_of(aux_dev, struct nvgrace_egm_dev, aux_dev);
>  	struct chardev *egm_chardev;
> +	int ret;
>=20
>  	egm_chardev =3D setup_egm_chardev(egm_dev);
>  	if (!egm_chardev)
>  		return -EINVAL;
>=20
> +	hash_init(egm_chardev->htbl);
> +
> +	ret =3D nvgrace_egm_fetch_retired_pages(egm_dev, egm_chardev);
> +	if (ret)
> +		goto error_exit;
> +
>  	xa_store(&egm_chardevs, egm_dev->egmpxm, egm_chardev,
> GFP_KERNEL);
>=20
>  	return 0;
> +
> +error_exit:
> +	del_egm_chardev(egm_chardev);
> +	return ret;
>  }
>=20
>  static void egm_driver_remove(struct auxiliary_device *aux_dev)
> @@ -166,10 +238,19 @@ static void egm_driver_remove(struct
> auxiliary_device *aux_dev)
>  	struct nvgrace_egm_dev *egm_dev =3D
>  		container_of(aux_dev, struct nvgrace_egm_dev, aux_dev);
>  	struct chardev *egm_chardev =3D xa_erase(&egm_chardevs, egm_dev-
> >egmpxm);
> +	struct h_node *cur_page;
> +	unsigned long bkt;
> +	struct hlist_node *temp_node;
>=20
>  	if (!egm_chardev)
>  		return;
>=20
> +	hash_for_each_safe(egm_chardev->htbl, bkt, temp_node, cur_page,
> node) {
> +		hash_del(&cur_page->node);
> +		kvfree(cur_page);
> +	}

The above is not required as the below cleanup also does the same thing.

Also, do we really need a hash table here? Since this is just storing page =
info=20
and returning it via an IOCTL, a simple array or linked list would suffice.
Or is there any plan to use it later for lookups?

Thanks,
Shameer


> +	cleanup_retired_pages(egm_chardev);
>  	del_egm_chardev(egm_chardev);
>  }
>=20
> diff --git a/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
> b/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
> index ca50bc1f67a0..b8e143542bce 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
> @@ -18,22 +18,41 @@ int nvgrace_gpu_has_egm_property(struct pci_dev
> *pdev, u64 *pegmpxm)
>  }
>=20
>  int nvgrace_gpu_fetch_egm_property(struct pci_dev *pdev, u64 *pegmphys,
> -				   u64 *pegmlength)
> +				   u64 *pegmlength, u64 *pretiredpagesphys)
>  {
>  	int ret;
>=20
>  	/*
> -	 * The memory information is present in the system ACPI tables as DSD
> -	 * properties nvidia,egm-base-pa and nvidia,egm-size.
> +	 * The EGM memory information is present in the system ACPI tables
> +	 * as DSD properties nvidia,egm-base-pa and nvidia,egm-size.
>  	 */
>  	ret =3D device_property_read_u64(&pdev->dev, "nvidia,egm-size",
>  				       pegmlength);
>  	if (ret)
> -		return ret;
> +		goto error_exit;
>=20
>  	ret =3D device_property_read_u64(&pdev->dev, "nvidia,egm-base-pa",
>  				       pegmphys);
> +	if (ret)
> +		goto error_exit;
> +
> +	/*
> +	 * SBIOS puts the list of retired pages on a region. The region
> +	 * SPA is exposed as "nvidia,egm-retired-pages-data-base".
> +	 */
> +	ret =3D device_property_read_u64(&pdev->dev,
> +				       "nvidia,egm-retired-pages-data-base",
> +				       pretiredpagesphys);
> +	if (ret)
> +		goto error_exit;
> +
> +	/* Catch firmware bug and avoid a crash */
> +	if (*pretiredpagesphys =3D=3D 0) {
> +		dev_err(&pdev->dev, "Retired pages region is not setup\n");
> +		ret =3D -EINVAL;
> +	}
>=20
> +error_exit:
>  	return ret;
>  }
>=20
> @@ -74,7 +93,8 @@ static void nvgrace_gpu_release_aux_device(struct
> device *device)
>=20
>  struct nvgrace_egm_dev *
>  nvgrace_gpu_create_aux_device(struct pci_dev *pdev, const char *name,
> -			      u64 egmphys, u64 egmlength, u64 egmpxm)
> +			      u64 egmphys, u64 egmlength, u64 egmpxm,
> +			      u64 retiredpagesphys)
>  {
>  	struct nvgrace_egm_dev *egm_dev;
>  	int ret;
> @@ -86,6 +106,8 @@ nvgrace_gpu_create_aux_device(struct pci_dev *pdev,
> const char *name,
>  	egm_dev->egmpxm =3D egmpxm;
>  	egm_dev->egmphys =3D egmphys;
>  	egm_dev->egmlength =3D egmlength;
> +	egm_dev->retiredpagesphys =3D retiredpagesphys;
> +
>  	INIT_LIST_HEAD(&egm_dev->gpus);
>=20
>  	egm_dev->aux_dev.id =3D egmpxm;
> diff --git a/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
> b/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
> index 2e1612445898..2f329a05685d 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
> +++ b/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
> @@ -16,8 +16,9 @@ void remove_gpu(struct nvgrace_egm_dev *egm_dev,
> struct pci_dev *pdev);
>=20
>  struct nvgrace_egm_dev *
>  nvgrace_gpu_create_aux_device(struct pci_dev *pdev, const char *name,
> -			      u64 egmphys, u64 egmlength, u64 egmpxm);
> +			      u64 egmphys, u64 egmlength, u64 egmpxm,
> +			      u64 retiredpagesphys);
>=20
>  int nvgrace_gpu_fetch_egm_property(struct pci_dev *pdev, u64 *pegmphys,
> -				   u64 *pegmlength);
> +				   u64 *pegmlength, u64 *pretiredpagesphys);
>  #endif /* EGM_DEV_H */
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgra=
ce-
> gpu/main.c
> index b1ccd1ac2e0a..534dc3ee6113 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -67,7 +67,7 @@ static struct list_head egm_dev_list;
>  static int nvgrace_gpu_create_egm_aux_device(struct pci_dev *pdev)
>  {
>  	struct nvgrace_egm_dev_entry *egm_entry =3D NULL;
> -	u64 egmphys, egmlength, egmpxm;
> +	u64 egmphys, egmlength, egmpxm, retiredpagesphys;
>  	int ret =3D 0;
>  	bool is_new_region =3D false;
>=20
> @@ -80,7 +80,8 @@ static int nvgrace_gpu_create_egm_aux_device(struct
> pci_dev *pdev)
>  	if (nvgrace_gpu_has_egm_property(pdev, &egmpxm))
>  		goto exit;
>=20
> -	ret =3D nvgrace_gpu_fetch_egm_property(pdev, &egmphys,
> &egmlength);
> +	ret =3D nvgrace_gpu_fetch_egm_property(pdev, &egmphys,
> &egmlength,
> +					     &retiredpagesphys);
>  	if (ret)
>  		goto exit;
>=20
> @@ -103,7 +104,8 @@ static int nvgrace_gpu_create_egm_aux_device(struct
> pci_dev *pdev)
>=20
>  	egm_entry->egm_dev =3D
>  		nvgrace_gpu_create_aux_device(pdev,
> NVGRACE_EGM_DEV_NAME,
> -					      egmphys, egmlength, egmpxm);
> +					      egmphys, egmlength, egmpxm,
> +					      retiredpagesphys);
>  	if (!egm_entry->egm_dev) {
>  		ret =3D -EINVAL;
>  		goto free_egm_entry;
> diff --git a/include/linux/nvgrace-egm.h b/include/linux/nvgrace-egm.h
> index a66906753267..197255c2a3b7 100644
> --- a/include/linux/nvgrace-egm.h
> +++ b/include/linux/nvgrace-egm.h
> @@ -7,6 +7,7 @@
>  #define NVGRACE_EGM_H
>=20
>  #include <linux/auxiliary_bus.h>
> +#include <linux/hashtable.h>
>=20
>  #define NVGRACE_EGM_DEV_NAME "egm"
>=20
> @@ -19,6 +20,7 @@ struct nvgrace_egm_dev {
>  	struct auxiliary_device aux_dev;
>  	phys_addr_t egmphys;
>  	size_t egmlength;
> +	phys_addr_t retiredpagesphys;
>  	u64 egmpxm;
>  	struct list_head gpus;
>  };
> --
> 2.34.1


