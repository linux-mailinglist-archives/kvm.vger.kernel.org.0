Return-Path: <kvm+bounces-64422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D514C8221B
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 19:42:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 580913A5628
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 18:42:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F17BB31A7F2;
	Mon, 24 Nov 2025 18:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="a42R1vyD"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010037.outbound.protection.outlook.com [52.101.46.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1BC31985C;
	Mon, 24 Nov 2025 18:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764009708; cv=fail; b=dxkGqKQfBK3P6u2vL13Fa6mcmVYFyTp1s3SH4wNIBxdxW/FfkALm4Jz4PT6zZ5v4KUv8uKb6rBHqur+rh8rfSM9UdoswcbuCu0T1NYCMmBq3+cNYVHqT7vgFoxmWDbNI3rGZmo3XeaBne4IZpSScsMlckflzviVneS1/UP9WwBE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764009708; c=relaxed/simple;
	bh=gkQM27A4Y8qz4IYiNOMxYvSLwHTYoqY+2n0lsFjones=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qvTxYRYSygZ2qxwGrBY3iT4b/nqraU5qaWygZktkD9cWDcJqZA+g8wLvdPwlQ1nc83RTVob7l/cXKq7RW0m9YGaeRmvzo7WQVG58d0tMyW1VLMvSxbWCtBJm5uCPzp7DHoNg4+NoZfHG9yjsTnDIAZzS7APzrEu4NHogRTeg6YY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=a42R1vyD; arc=fail smtp.client-ip=52.101.46.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YK+4ZAwUxuNAgKXYxsQjHti6LKfeToybY7NvW90XTCBm5lfk0I6LuRYS1s0zR1MkKRDEW+HHDkJOjRYRrAbsGx7rr5x0KDsYCUdF6wTOkxfsOWBmge1ymHneckEFggFFbqiG9EkvsyAAOAWu5otP+u9MMK571dYFXKWG9ZkvLn2T+f4R4HxJjwwdB0mLoCv5lD6eUClmnu++NfpZdIJ1CCJ14n+sACkDoPzCWE1eHGX2TDYGxytdsrtbP0i/D4L/m4sKn+TSiOZ83ma4UDKRW2839xVCMgrpITEqGQOv1id4RgpbNeNMQ6OsdjJcpWTkunJU7FxbMoF6COCb4d3eRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ez8fmjCwL4dZgcEha6EiRUqdXAgrNRlw+FxLv/UldCE=;
 b=PF2mJfV3SyeUl9s6yz4Vo/+uXKIQzYZamTRN68yBBFzLrPwpgHEHO9fuLY6x2APkKE/hsBqMiSRJcurj+jLiIxczd0RtSNimSB3EeIzd3tfI15vsNFTPeIyw2UE2RiI247cCP7unCQYFswBbVU/dEwdTGSAVjNq/LYaQm8osTNuHcHRi/q2NjEkGHpQQKOSpkYk9jJ2dnTxfEHW0TIYn0fNyy5GPW/aBzA2HtNpUZTL5pRELxjlWHRDH5WE8O1sGT/WLOFg04ZGsbI6Q/ywanELE5SloUYiK2hyASQ4vXwgTLAaH8+KcssSyWD8p3h+gkffjdm7cRxcsvuZILP6Bog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ez8fmjCwL4dZgcEha6EiRUqdXAgrNRlw+FxLv/UldCE=;
 b=a42R1vyDbMNpq/qOlDQyIOwiJ3LssgeDyujlj3KS3C/1KSqNe+aSZHpmfkcI6m7t7aVcRPVKJrOjmrwZ7hq/rjK6UBqZ8yIThpwZxe26nRxXfU537vsG7UKIIfcNgVeWHUiw+ITTIDI3V6XGaG8o3f2gO7I27ffoxyhNxcXHHXKVQ0RWEHb/P5VZNP1TArUCD4afq8RwNfXSY75LImK6OaxlGz2bdYA3FWHCbmhuaMVC2MX3ro7o4sr1gpM9bpOypuW6RG6ohuztmQfnx8780gn3hvF9BTuVu1JViDeXWoU9g9flZEl4GMcmoENTUpxVz7wcrnVLM8Sw8CVf7i7e8w==
Received: from CH3PR12MB7548.namprd12.prod.outlook.com (2603:10b6:610:144::12)
 by CY8PR12MB7290.namprd12.prod.outlook.com (2603:10b6:930:55::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 18:41:42 +0000
Received: from CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::e8c:e992:7287:cb06]) by CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::e8c:e992:7287:cb06%5]) with mapi id 15.20.9343.016; Mon, 24 Nov 2025
 18:41:42 +0000
From: Shameer Kolothum <skolothumtho@nvidia.com>
To: Ankit Agrawal <ankita@nvidia.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, Yishai
 Hadas <yishaih@nvidia.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
	"alex@shazbot.org" <alex@shazbot.org>, Aniket Agashe <aniketa@nvidia.com>,
	Vikram Sethi <vsethi@nvidia.com>, Matt Ochs <mochs@nvidia.com>
CC: "Yunxiang.Li@amd.com" <Yunxiang.Li@amd.com>, "yi.l.liu@intel.com"
	<yi.l.liu@intel.com>, "zhangdongdong@eswincomputing.com"
	<zhangdongdong@eswincomputing.com>, Avihai Horon <avihaih@nvidia.com>,
	"bhelgaas@google.com" <bhelgaas@google.com>, "peterx@redhat.com"
	<peterx@redhat.com>, "pstanner@redhat.com" <pstanner@redhat.com>, Alistair
 Popple <apopple@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Neo Jia
	<cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, Dan Williams
	<danw@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>, Krishnakant Jaju
	<kjaju@nvidia.com>
Subject: RE: [PATCH v5 7/7] vfio/nvgrace-gpu: wait for the GPU mem to be ready
Thread-Topic: [PATCH v5 7/7] vfio/nvgrace-gpu: wait for the GPU mem to be
 ready
Thread-Index: AQHcXTnUrE7WBaJrsEqvGwYscgzBc7UCKIjQ
Date: Mon, 24 Nov 2025 18:41:42 +0000
Message-ID:
 <CH3PR12MB7548E8A78A55D6693461EDAEABD0A@CH3PR12MB7548.namprd12.prod.outlook.com>
References: <20251124115926.119027-1-ankita@nvidia.com>
 <20251124115926.119027-8-ankita@nvidia.com>
In-Reply-To: <20251124115926.119027-8-ankita@nvidia.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR12MB7548:EE_|CY8PR12MB7290:EE_
x-ms-office365-filtering-correlation-id: 958c9c99-5cea-41f9-9f2c-08de2b891cda
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700021|7053199007;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?s2sn4kAAw1vEhVSWzc+l8kp/Rvqy5vkhmP1qy20Ifg14okyCiRGL3NCBsPS+?=
 =?us-ascii?Q?zvZ6tcrHXF29d3hUbthBSQfKBFwixh+ji3i5FppqvricdjBZPUXmLR/CEAXB?=
 =?us-ascii?Q?EZYVGR8SHU26D17DwyQxVOjlyMQ6SFsNuGTZOf9xACXah3EJwdyIGaTm3h7/?=
 =?us-ascii?Q?eX2lNFqvd4PrHzmx0kQGarM7gubgg3h33julatkDJQJP/xsfDhm1jSekCGBT?=
 =?us-ascii?Q?vN5AjfE+JjE7lpdaMZSMPxliswK0vjGaYS17MsziGc4Gokec6KaEV9fQzzxA?=
 =?us-ascii?Q?zy4+qAHjgY8cHbEuf45e9ZEqlSfgG9lxpwT/oxL+3TZoabVTwvjPkzAF3jYj?=
 =?us-ascii?Q?qXAl4GCCyINAC4Nh66u0GZUmuwvYT40w5YOppAM8CLWqtUJ7ZFpY/32sNo4r?=
 =?us-ascii?Q?/60Bq6rmF0KGWKMNRyZxzguPZVhoTSxeGHhHRbq/Ce73PX6MkifLAkC1lwCH?=
 =?us-ascii?Q?dMFFm6ffIL05DO5W61ETw9eP88BTqc6ggVVNHqKBx8Xsh4PSJtHxfLi0B1jk?=
 =?us-ascii?Q?UpfRIbM3cFzbVgU07OvkZPRp8GbFJ/mKPDZofcjQRBlzB/iQsnJUWQV3DMfK?=
 =?us-ascii?Q?l7D2X+HjA5KyMv4miCyO9DxXw2ZMdhXHW8XeQl3frLFKkG+VPwrMMmWDWpVm?=
 =?us-ascii?Q?CTvDSjOqDU8MgW7aYH3dRw3r8vwmJzB2ja7flma7ZfyVp1qk18+ty1k272KM?=
 =?us-ascii?Q?rgpbRpV3JIm16/XV1FBvidf8rCzs+rE15gMW/U9tMkW21XvzcLwCw612D1jX?=
 =?us-ascii?Q?P2Fprw0rb+LisHSflpHC4Rz63mvXjxbmZlnokBOtQRo4sUf6bvHPc3y7tW78?=
 =?us-ascii?Q?2972VotWMKY62Y0b7WYj9oBhV1/MB0cNRz8eRhzdgF2pfTreNtvSnhA12hpm?=
 =?us-ascii?Q?zU/3iqGg18Jtt2rdp2JW23VnrUgpvHvCnm96KrA2a2YGLLBqniOeKev11dE0?=
 =?us-ascii?Q?khgCh1ADLClhQoo3MCIa8arnBJUwW1SCRfDbi9/xxi0U1mDDV4Rt9cugB3eL?=
 =?us-ascii?Q?kjMImMgDBvMdhe7g03ulhVRBxoc53nu6AkKxikf3+SuanapUhQPZ2JLimH+i?=
 =?us-ascii?Q?1K/3SnrksH+p0BUxrahAHUfHvR+oNChgpvkYqW5AMxnTyN9W+oGOgg8Cm1Ow?=
 =?us-ascii?Q?QlAP7ysAFm9DDv1TZYyDiAwGaWlzlJl3I0WJxIkdyVsRbqrpW8rvxbj08KTx?=
 =?us-ascii?Q?pvsxD8a/C58raFToCNmxlscrBn/ns9rI40gSTk4f6DiLLEB6fZgMPfwKIyz8?=
 =?us-ascii?Q?z9ScQT9hLsM/Dfa8zUBFxYKEG9hbltmynCK0Pvc8ahSFeTJQA6cOlgeeQFt0?=
 =?us-ascii?Q?L+G5/yigXGMFW6c1ZlOMzVLcM292L3k08NViYOGglMLYM07VFoDfhBLW7kfu?=
 =?us-ascii?Q?MxqM5cPjnhqH1Mh9YQH1htIwuT7MnP1YGJZyq7mkhfK2e9hZxVFglLqRnaym?=
 =?us-ascii?Q?F6TN2xrUIn0rHnxzF0mwLoYpXLPqcBmDv7FniRvBW9SOUxB2BoeDmWtzhu4Y?=
 =?us-ascii?Q?5f/q96zBo0s3H9slF0BX41HDRcs6Muep4rGz?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7548.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700021)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?HhZkj5ouJEVuLN5dz5i128ONzkJnqJteMfJfx3achH0UqLWbQhJN3mzIEU1a?=
 =?us-ascii?Q?1qsImPURfzO167mikhpMPwV3MBxsQ00mh4ylfXpPSJ+mr61m9RJ6/J3oYlLs?=
 =?us-ascii?Q?Mx9X7N7ujllbHhE+GNF/4Z3y5ijHQhdG3TmFTjPWZPVHl7iAXunqWwvu1l6g?=
 =?us-ascii?Q?XsSML8J9DfqIH11sv+MqAIUgay+amOnJLNfUDnvl+THhpN5uW7XpierUTp+N?=
 =?us-ascii?Q?rD3DW210QV1/l8wZjpPwFDZFUxM8/dgA0yzScYUAZYuT/XVx9/keHLm2to2s?=
 =?us-ascii?Q?wheAzCscquqMm/BN26c3FpnNDlRf7QrpJMsQDkTFcE4F392iWcNoZd41NCRk?=
 =?us-ascii?Q?JWVbgp2sS8X3OVuinmFaQWnAfhGPYGT4iuYfhXFTtND5kCxmWi3Trfjs0GBB?=
 =?us-ascii?Q?mAIQynIZMXxKZ2yJ1I8fdUNLReyXcc5Rv8AzfyHZNmSVs0gHHKAbKXf7c8T/?=
 =?us-ascii?Q?dk9slK1GBKLG5Y/hFgIAonyuzt62uP2fAafi2c/u4Ejc8h8vp4KzQDT4kquz?=
 =?us-ascii?Q?gwIk817NEV5YnkS6WQBBBeP3Hy/HhsEFREjOAn2Ka9Wi5bh4/XMLO70nJHjv?=
 =?us-ascii?Q?DXrhPUyhEGCPgERfax/eaNpZxbstpWmy4kbs2iXB4QyZ8BRLHC9pW3Je5oA7?=
 =?us-ascii?Q?aln7YfAjoIEHEV6N0/u7U8BxGwS6Og4j1M9enRDEsSZN6vWMvLCFB26rLYmh?=
 =?us-ascii?Q?CSx9S3cDy8wVGOd1tZ1j+OWwN1tXO2rM7HAKLH2tmUc6yUyH5ChdMhSnv2E+?=
 =?us-ascii?Q?6jHwZEFwkUfARFbmDv9N2FIldQcZDpFVBkvlNsc/6i45THObfJQ/snmtSsmF?=
 =?us-ascii?Q?72d085NrYIB1nwavqlxNvugy0KFI+J76zKtndRPx6gENTFi2INwdkbrBdsyh?=
 =?us-ascii?Q?mCoVEIFw/M9ueKLSW1XgOIITXmOR4CiLw53453tlKulaHiwUy93BdRjcCCLK?=
 =?us-ascii?Q?IxmFUbhqecBIsqCTcYXJ+kX1O6cJl8szbtpcDrF6+Rz44vykY0+/76YKfEoW?=
 =?us-ascii?Q?IRtj9ZMFNbxj3s1zxRckeknEt+ROPZFXesazOTWyZkHKZnLVGMSespHMtIRE?=
 =?us-ascii?Q?zhg+b3UpBSJ9QRJ8BRJwEuX0bvJOBreiQN4PJcR2qR86T4aARuDvXIXJYJC8?=
 =?us-ascii?Q?cuOvfUkGFuh21BsRnIdo5CvR9cYIzGxCp/mocbXPje4mYXb5yomXyWJNoAjD?=
 =?us-ascii?Q?2NImm46cz4zBbm7pbvZP/0qCXWm1YDuyO/NO9JPE3ZIJuqRBFpxlO6mALA4R?=
 =?us-ascii?Q?uJj4z2zSTGWjZHU+8L3xrjOdFpYGQ7pV7NC3BXQLtBwCWc1vNfvddJqwHAjv?=
 =?us-ascii?Q?gpwoMrHfiZY4jgFQiI4S4Xe4YKdLDKdy508ulY38kpNCY69p2kbn0xWMI3Zv?=
 =?us-ascii?Q?C3PWF7U3uAZI24GGYrWT6jzhNdjWQluHx65xHZdtVZqWxA0Cjn0fm15DmWBM?=
 =?us-ascii?Q?bWDWkCLl5szF1ruLNT92QLAwmR9ZgGW4JOavXTwUVaFb21UhPNnwZpHZoibo?=
 =?us-ascii?Q?a5RBdBwwk7b9MOybn8FoPS4kTc6hLKOkgtzkGZXLSucjVa7agOcB9oRAmOiH?=
 =?us-ascii?Q?dsSZl1T5RAGlWqprUpk6BbAzv6702a26G88Kuy/T?=
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
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7548.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 958c9c99-5cea-41f9-9f2c-08de2b891cda
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2025 18:41:42.7232
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qv3LJyZXHIc2DzC52t3Rwd4ypiFp3EC6rz+4rRNGocyrY3nRo0SMpNVPyfuEC9AFK+D6R6NJ64LQXiao8px79w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7290



> -----Original Message-----
> From: Ankit Agrawal <ankita@nvidia.com>
> Sent: 24 November 2025 11:59
> To: Ankit Agrawal <ankita@nvidia.com>; jgg@ziepe.ca; Yishai Hadas
> <yishaih@nvidia.com>; Shameer Kolothum <skolothumtho@nvidia.com>;
> kevin.tian@intel.com; alex@shazbot.org; Aniket Agashe
> <aniketa@nvidia.com>; Vikram Sethi <vsethi@nvidia.com>; Matt Ochs
> <mochs@nvidia.com>
> Cc: Yunxiang.Li@amd.com; yi.l.liu@intel.com;
> zhangdongdong@eswincomputing.com; Avihai Horon <avihaih@nvidia.com>;
> bhelgaas@google.com; peterx@redhat.com; pstanner@redhat.com; Alistair
> Popple <apopple@nvidia.com>; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; Neo Jia <cjia@nvidia.com>; Kirti Wankhede
> <kwankhede@nvidia.com>; Tarun Gupta (SW-GPU) <targupta@nvidia.com>;
> Zhi Wang <zhiw@nvidia.com>; Dan Williams <danw@nvidia.com>; Dheeraj
> Nigam <dnigam@nvidia.com>; Krishnakant Jaju <kjaju@nvidia.com>
> Subject: [PATCH v5 7/7] vfio/nvgrace-gpu: wait for the GPU mem to be read=
y
>=20
> From: Ankit Agrawal <ankita@nvidia.com>
>=20
> Speculative prefetches from CPU to GPU memory until the GPU is
> ready after reset can cause harmless corrected RAS events to
> be logged on Grace systems. It is thus preferred that the
> mapping not be re-established until the GPU is ready post reset.
>=20
> The GPU readiness can be checked through BAR0 registers similar
> to the checking at the time of device probe.
>=20
> It can take several seconds for the GPU to be ready. So it is
> desirable that the time overlaps as much of the VM startup as
> possible to reduce impact on the VM bootup time. The GPU
> readiness state is thus checked on the first fault/huge_fault
> request or read/write access which amortizes the GPU readiness
> time.
>=20
> The first fault and read/write checks the GPU state when the
> reset_done flag - which denotes whether the GPU has just been
> reset. The memory_lock is taken across map/access to avoid
> races with GPU reset.
>=20
> cc: Alex Williamson <alex@shazbot.org>
> cc: Jason Gunthorpe <jgg@ziepe.ca>
> cc: Vikram Sethi <vsethi@nvidia.com>
> Suggested-by: Alex Williamson <alex@shazbot.org>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/main.c | 79 ++++++++++++++++++++++++++-
> --
>  1 file changed, 72 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgra=
ce-
> gpu/main.c
> index bef9f25bf8f3..fbc19fe688ca 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -104,6 +104,17 @@ static int nvgrace_gpu_open_device(struct
> vfio_device *core_vdev)
>  		mutex_init(&nvdev->remap_lock);
>  	}
>=20
> +	/*
> +	 * GPU readiness is checked by reading the BAR0 registers.
> +	 *
> +	 * ioremap BAR0 to ensure that the BAR0 mapping is present before
> +	 * register reads on first fault before establishing any GPU
> +	 * memory mapping.
> +	 */
> +	ret =3D vfio_pci_core_setup_barmap(vdev, 0);
> +	if (ret)
> +		return ret;
> +
>  	vfio_pci_core_finish_enable(vdev);
>=20
>  	return 0;
> @@ -150,6 +161,26 @@ static int nvgrace_gpu_wait_device_ready(void
> __iomem *io)
>  	return ret;
>  }
>=20
> +static int
> +nvgrace_gpu_check_device_ready(struct nvgrace_gpu_pci_core_device
> *nvdev)
> +{
> +	struct vfio_pci_core_device *vdev =3D &nvdev->core_device;
> +	int ret;
> +
> +	lockdep_assert_held_read(&vdev->memory_lock);
> +
> +	if (!nvdev->reset_done)
> +		return 0;
> +
> +	ret =3D nvgrace_gpu_wait_device_ready(vdev->barmap[0]);
> +	if (ret)
> +		return ret;
> +
> +	nvdev->reset_done =3D false;
> +
> +	return 0;
> +}
> +
>  static vm_fault_t nvgrace_gpu_vfio_pci_huge_fault(struct vm_fault *vmf,
>  						  unsigned int order)
>  {
> @@ -173,8 +204,18 @@ static vm_fault_t
> nvgrace_gpu_vfio_pci_huge_fault(struct vm_fault *vmf,
>  		      pfn & ((1 << order) - 1)))
>  		return VM_FAULT_FALLBACK;
>=20
> -	scoped_guard(rwsem_read, &nvdev->core_device.memory_lock)
> +	scoped_guard(rwsem_read, &nvdev->core_device.memory_lock) {
> +		/*
> +		 * If the GPU memory is accessed by the CPU while the GPU is
> +		 * not ready after reset, it can cause harmless corrected RAS
> +		 * events to be logged. Make sure the GPU is ready before
> +		 * establishing the mappings.
> +		 */
> +		if (nvgrace_gpu_check_device_ready(nvdev))
> +			return ret;
> +
>  		ret =3D vfio_pci_vmf_insert_pfn(vmf, pfn, order);
> +	}
>=20
>  	return ret;
>  }
> @@ -593,9 +634,21 @@ nvgrace_gpu_read_mem(struct
> nvgrace_gpu_pci_core_device *nvdev,
>  	else
>  		mem_count =3D min(count, memregion->memlength -
> (size_t)offset);
>=20
> -	ret =3D nvgrace_gpu_map_and_read(nvdev, buf, mem_count, ppos);
> -	if (ret)
> -		return ret;
> +	scoped_guard(rwsem_read, &nvdev->core_device.memory_lock) {
> +		/*
> +		 * If the GPU memory is accessed by the CPU while the GPU is
> +		 * not ready after reset, it can cause harmless corrected RAS
> +		 * events to be logged. Make sure the GPU is ready before
> +		 * establishing the mappings.
> +		 */
> +		ret =3D nvgrace_gpu_check_device_ready(nvdev);
> +		if (ret)
> +			return ret;
> +
> +		ret =3D nvgrace_gpu_map_and_read(nvdev, buf, mem_count,
> ppos);
> +		if (ret)
> +			return ret;
> +	}
>=20
>  	/*
>  	 * Only the device memory present on the hardware is mapped, which
> may
> @@ -713,9 +766,21 @@ nvgrace_gpu_write_mem(struct
> nvgrace_gpu_pci_core_device *nvdev,
>  	 */
>  	mem_count =3D min(count, memregion->memlength - (size_t)offset);
>=20
> -	ret =3D nvgrace_gpu_map_and_write(nvdev, buf, mem_count, ppos);
> -	if (ret)
> -		return ret;
> +	scoped_guard(rwsem_read, &nvdev->core_device.memory_lock) {
> +		/*
> +		 * If the GPU memory is accessed by the CPU while the GPU is
> +		 * not ready after reset, it can cause harmless corrected RAS
> +		 * events to be logged. Make sure the GPU is ready before
> +		 * establishing the mappings.
> +		 */

The comment above is now repeated 3 times. Good to consolidate and add=20
that comment above nvgrace_gpu_check_device_ready().

Thanks,
Shameer

> +		ret =3D nvgrace_gpu_check_device_ready(nvdev);
> +		if (ret)
> +			return ret;
> +
> +		ret =3D nvgrace_gpu_map_and_write(nvdev, buf, mem_count,
> ppos);
> +		if (ret)
> +			return ret;
> +	}
>=20
>  exitfn:
>  	*ppos +=3D count;
> --
> 2.34.1


