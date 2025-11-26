Return-Path: <kvm+bounces-64632-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 20497C88CEB
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 09:59:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9287D3521B0
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 08:59:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52F282D0C9B;
	Wed, 26 Nov 2025 08:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JawcPaEj"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013018.outbound.protection.outlook.com [40.93.201.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56692877D9;
	Wed, 26 Nov 2025 08:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764147568; cv=fail; b=Jpqy9u+Pybc0VKzO4jtS/ocGv832gQTl+Y7D/o0F1u6HtC17ACHMCAIP1Jp/NDtVZQyRW+LS1XAQuRPMzkDsuVjB+KuF8anA4qsyGBukyBBF9q55JYXpgezs8eFEI76OSxJ6gfs9zZXoWb8BE5S+7rFZmJKfzXHAKxU2v/XstuY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764147568; c=relaxed/simple;
	bh=hW4T3cdytUxXvB6ge3m35URcIqMZOqpqrLHdvT8n+CM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=j/In4p35aJAbCAA4VDO9jdW/7dmb4KwDH8cslcPL5NIrB7kjznh5Qwvrc0PX57A38vOwW8HjlOlFRfVO7VOmHpRN7ZpnJa0S6CPkznL7YjF9QZ8ymYUTPMUN/9T7EmIpQeYg5oQIJivLH7Bgsf1KzM8Cb6/gZqr5nI5vdpfxtZg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JawcPaEj; arc=fail smtp.client-ip=40.93.201.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ctdu+WUn3gWW6qCl4LOiL3IoGdfvN2hgVNGK002d/PIjjBcfhFyDYKhlExMaU9fefafeCOR/YVij8Lu+4bzLFhDGpGQf0nLglqSzdIAVC41CI5dUgXS4NmYLJxlf/BxvqZYAtetJA52lqxBjOlb1H8Krs5tC2WW9u6V3hK6YygnNKm4pKdWVaSRJDaQmhcy9INaRGsmlOxEikIpxwhDQRYujHwMNEKMs1mGQ9gZnpXiBxwK+uGw5bdpixrWP97sQKlVEkj9mkMfbwgNrd2OsucTIb7sugC0cTOEVBPR1D4tkw688izHZt86omVV2YxAGmc12U5qNyCvBRgpOumRHAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hW4T3cdytUxXvB6ge3m35URcIqMZOqpqrLHdvT8n+CM=;
 b=ZzZukpjfk5aGBnw9m+YwbaZ5bnQmbZY79ormnxeHQHtAvZnoYGe6CM8EV9jksyySqid7LuQNNKUB/AV63c34mS0cPG8kDjBBceXVTYIkcVIxhXBMT36fieRhtdjfQcUwHUfyL4bSI2pKyNNODdoWqxErsMmMdLI2tB3lhqtN3rnmcB5NW15qx0DT4sTpUrhbri5igOjKjEsUzxYjwqflA+Lpqt7BoGQeOuXMDVFkJBTbxrvDqZutmnS6YjIc0jcEhF2Ru0RMAX+9y+FiKfBbEcxiFRqSWZA/N2Bz/i4PaofPRDgs/qakeP5Do5Yy1tDDwHVeBCTSTFlkXrJ2oDvhpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hW4T3cdytUxXvB6ge3m35URcIqMZOqpqrLHdvT8n+CM=;
 b=JawcPaEjjSvZQuV9j3+9qZS6L/jw/Q4D5oLskJSKoLy8UrueEEHUcXS/Mniwf37P3Z3Oj4NUhZrTA3jqkcKpHWolhMtCXI6SPiyDkBfa0VIqxmle5uLgfcCDh1ND48HUfg5WuzZHiKEwZ9CfVoBe+ANWnNUdw60zCn6uofaxHdlJAZLSAoOBeXaQNvYVhJfmjGlwmCT5xGsCe2fpIr78mC8r0ZqvIAHY4vxfYdD0ztt6hcEClgz6JQIqPMX+0hCqJoQsah42WUhAE4IbkPT51tZdn1qnYAtwSSEpt1/oMV5ynEtLKJS1SYqZ5pLvy0DOA2kx+1zMDM2988k0Ftiq1g==
Received: from CH3PR12MB7548.namprd12.prod.outlook.com (2603:10b6:610:144::12)
 by SA1PR12MB7293.namprd12.prod.outlook.com (2603:10b6:806:2b9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Wed, 26 Nov
 2025 08:59:20 +0000
Received: from CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::e8c:e992:7287:cb06]) by CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::e8c:e992:7287:cb06%5]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 08:59:20 +0000
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
Subject: RE: [PATCH v7 2/6] vfio/nvgrace-gpu: Add support for huge pfnmap
Thread-Topic: [PATCH v7 2/6] vfio/nvgrace-gpu: Add support for huge pfnmap
Thread-Index: AQHcXpU+UaBUBDabw0OR/1DujshhTrUEqGrQ
Date: Wed, 26 Nov 2025 08:59:20 +0000
Message-ID:
 <CH3PR12MB7548581B57EBA82B803EE884ABDEA@CH3PR12MB7548.namprd12.prod.outlook.com>
References: <20251126052627.43335-1-ankita@nvidia.com>
 <20251126052627.43335-3-ankita@nvidia.com>
In-Reply-To: <20251126052627.43335-3-ankita@nvidia.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR12MB7548:EE_|SA1PR12MB7293:EE_
x-ms-office365-filtering-correlation-id: d3a187ff-0246-47b3-3686-08de2cca1659
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700021|7053199007;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?AItPdU0x4+UCGs7Xt7oc+CCvdlUyHbyyGOMe8cnZiHiJnBB17RpXKb4yeOBU?=
 =?us-ascii?Q?mJ2C5/cIol3M7/EK2izNRm+MKf6g86WgE73gTK4YYNLzFIEYQzOTcFoXAiSj?=
 =?us-ascii?Q?/R8aEKHj5Ke0SenqyWAjsulTV0clxkT03xx8/wfT65/94YjcdgIWvGaGW/dk?=
 =?us-ascii?Q?EPh9UttnJH99ZKye+NiAbWCngebIbYVei2U9lkaX2VSMhR+iAr/Vqj4zfnPE?=
 =?us-ascii?Q?POEZciFCVD0uNANTxKRfTh4J4N5hHOVdjqQWI3ZyU+uy+854mJ4k7VybXZ+J?=
 =?us-ascii?Q?/yw3fUZXdE/3IeTWhmswlgvnP08gzeUU2CmLO8r5SkHlscfQ5vTLyfkL2Epd?=
 =?us-ascii?Q?YTGobU/UEoVaHSTFB6yz50uwbnPUpLZWs2F0zdW2H7ouwnkbNBfAlDIAQe1l?=
 =?us-ascii?Q?k02sLlXK+MLHaTvWP98l99UzBVK8COwkI7uTIw+Vl69mHENq+5diyfX9235b?=
 =?us-ascii?Q?4mGf/lKTjuZNsXGantFO9PEE+Fxx3mpCgvD17Atb86hnnntpbNClDrtWUZ2D?=
 =?us-ascii?Q?2sl0MFOVsDuKojz5asxC1plevwhctNapehlxge61Hk0XnKaSmIlNKhRW7tc/?=
 =?us-ascii?Q?tEfSxmixRJFAwABn0UaMHVf6znGTRth0PQ/cXz8dzY128CEdKz5VUPyH5l6K?=
 =?us-ascii?Q?8E2HR8CNtn6+GmlEWQL+VRcdIQ7kCibwmuYVp96kthZuM17zSGuSyBvbu2Mv?=
 =?us-ascii?Q?HcT2bAUm/0Z/1VoTBXY36504ghWU1thfhd06i0UE+JOrklyCIHdeLBMPIstd?=
 =?us-ascii?Q?AlcfkJORASbbF2AOwdbh8SofzBTFWcyovJD76OhbC9PVzERO46DiKyVfreYV?=
 =?us-ascii?Q?g3lDKxgefpoac97aqQS2Y6gP8t3mSpwKE5rk0UTizt8a45RPvFI8gY1Gh7Xc?=
 =?us-ascii?Q?nkdkSYTPR7EeoCMA2ul3AaG9d4vhb3B1a2FBfVb8c26NmQDgqd4fu6k9QnAf?=
 =?us-ascii?Q?bzPrZNqBzf3TZs+vyAOvRNbEE81gxUj4ZmUKg7TCHmlH4xAmaHfBY0m/LnjF?=
 =?us-ascii?Q?Eiw/KMcQVQICO594VN5eoOtTMoSGUspNQWUQCk2SA9HZVrOQzqrHlcsvyNcH?=
 =?us-ascii?Q?ajP6YdrfO4xYq4/S5dxqI6G8vbrKm/1myftLW+hcB5V3khxKEiluGCR+HZrb?=
 =?us-ascii?Q?s27nCKIjNRvS5JT7MjqpEbQJAGSMvo0Bjv32r/Cx0SXikL9/aoaXnWhPQoiu?=
 =?us-ascii?Q?/42OK7/3nHZDxTiBZQ7pM0ujf3TbqSy03C++mTJ5W853/I9+j7mvWvEjOEqk?=
 =?us-ascii?Q?fUoGqmKRnYczODBteqqNHUpHNyTCDo0SqQcv4I3TUrmWXG0CFL4jN/o7hhQh?=
 =?us-ascii?Q?ZsNEOhj1epD/wyIWwzDo8Vjn+bE97aGG3b8fJ4VlTDoxzZ1v1uYlSYEkVBBv?=
 =?us-ascii?Q?PvmLhC/bHT2b3gvqQFV7gnjgskqsezeq3e1Fqp8ghLPWvLPjPB22A3rtaq7a?=
 =?us-ascii?Q?qqfL/yS2lKHVXv6aYLMkzwzdM+oigBCVAzJuzYzf4YzWmbOSm5jCJXGwvaqg?=
 =?us-ascii?Q?/Dn+uRA1FHZJoe/HdtyGXNTx0f/WmXN8592R?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7548.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700021)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?tAUcfEtQYWda+GDvZx4FIZ+MJoVE1mvTgONlJ2fI/DQ4iiBp+5266OCsAcL0?=
 =?us-ascii?Q?2bcpjsTNBwfQomtDSmt2f0A6gCaJdF3MUFWQBiWWa4lBrrjsStoFF9AQy3rS?=
 =?us-ascii?Q?rTD6nWi3kItcNO7QmAgf2ajTDJpf4yRVH0TqbLxDGoo1KTiDY2BbzSsSOQRg?=
 =?us-ascii?Q?bXc/ekyXIZD63q31s02mac4NHb718zkdk7mWHzPN5U//4JEM7siIicXs6Yb/?=
 =?us-ascii?Q?KCWy6ZQWidZYOHVCd2KxEDnFPGUdVwtEVTi1y7igQetVQtJPX1vR4CpAG/DI?=
 =?us-ascii?Q?kNFpkJ+aSc8tled+br/0ftRheBDpp6Ry/HLjBPRPKcxGm3ilF1xze9Z0jYv4?=
 =?us-ascii?Q?4R9+Ej7kxzOT0x3Dl1ujrDpG+VCo21QZ1BhuminID5PkEBauvAN5l02t2d23?=
 =?us-ascii?Q?8JBzbGcO0sRQt+zd2Xz0H+fk9vqPqbYu7jV2QUEYeIao3WMFzAR3AaUOxSlw?=
 =?us-ascii?Q?soL9PGOeyiSbLTAnSii79P3vEOn9aNvxR33mU/9wR680/NOPODdQ5X2jgSje?=
 =?us-ascii?Q?FLHDZ5pju7SldXUstky/RZd8oVNVExVIcPEl+3X9xNs+EBt7f60ZuOEBU1hD?=
 =?us-ascii?Q?tBVDRsieLhlaMaLIe/W4VlpYG67coWwA4p5CTvrCez6KjqQ6tsHjdAjHqWtl?=
 =?us-ascii?Q?fwU96ypU75pw3jB8y4ZlD0EE+3hTlLkysVdgA9CkRikKzkvElj5CKFT9lgJG?=
 =?us-ascii?Q?stWcEi7M2O001wlenswUHLRnWkA5SXAoAyBWyfn7gUb8gvhYbpS1xfHufohr?=
 =?us-ascii?Q?IMhKmkJYhQtXetvfXGaWRhlmnNteCzgt2U/yeaWO+4sjNDbYUjfRpVZbqxK0?=
 =?us-ascii?Q?C57b3okWEL9UKBPHAPBCAn7HnMCldt0hlNKn8sW0cB6nxcDY16cnPbN75zRR?=
 =?us-ascii?Q?tYNPyV4bRARQJ4T/PWVo5iZwCNHIm4LBB+yQILtlYsW4aY05JQHW9R7Jk+Od?=
 =?us-ascii?Q?kIipH/AK+LUZ6azXL7MMx3AwoxnCiVlmA+d1+R+yhxWsId3x/ZudsQYfOCdR?=
 =?us-ascii?Q?s6Sv6KfN67ZJyYzTT8pIgEU5QDL+elD0gR4qxSaN08TsUjm0o9IrOoeP53kP?=
 =?us-ascii?Q?IQz43K4bp016BIhV39ItoCJ6E45EoiSu26yVZDCAgVh6aYszCrT89w5l4rrl?=
 =?us-ascii?Q?8q5IoGnFygEOqKdf5dkgFLGrmnOEAVAPMLp70f+KhTBWH8vWN135QkU9xC81?=
 =?us-ascii?Q?bztukAITytl1m55krngSgZxdK4aCU3e458T4tXxWIzgefIsUFhCkbp5HJrIg?=
 =?us-ascii?Q?VHP3/CvuEWAvsxtuQjAoJou5fmvv3J2h2xHDZuYBhpXvR3UA0wbjHa1ALLh3?=
 =?us-ascii?Q?XY2Wa6C8/p6eLOSGDi87j/f+9bqLDNRnWZPG85V6/mZv5VuBiEXG6PM8jSda?=
 =?us-ascii?Q?9MFfQYpxs9+2YAlg91C6g2v8llbc0BIeb9PiY3Y4oge7iHqRqvtunh6RFZme?=
 =?us-ascii?Q?6yh/ZzjldeAGz54o6XSU7dcP65+/4oZ9Y4VQvQdd2u4JvNN0flKtLlcT4SeD?=
 =?us-ascii?Q?4P7m1sjfC+MtLUCPWrT50erOAbHrof8MlJiBzVTPSKNvlHjPZ++g/nNJ8Y/u?=
 =?us-ascii?Q?E2hFwezcLXuWKNf7iLT+WFAkl/SNI6977pZTQbfM?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d3a187ff-0246-47b3-3686-08de2cca1659
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2025 08:59:20.2529
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FIvT/74BcKqJusc4BQ8A7Z1OyTZ5dr4z+BDyk/hVhkCpLd2pE0GRHGfNVeQaDlc3RwAY66A9ok1Xebuq+yjqBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7293



> -----Original Message-----
> From: Ankit Agrawal <ankita@nvidia.com>
> Sent: 26 November 2025 05:26
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
> Subject: [PATCH v7 2/6] vfio/nvgrace-gpu: Add support for huge pfnmap
>=20
> From: Ankit Agrawal <ankita@nvidia.com>
>=20
> NVIDIA's Grace based systems have large device memory. The device
> memory is mapped as VM_PFNMAP in the VMM VMA. The nvgrace-gpu
> module could make use of the huge PFNMAP support added in mm [1].
>=20
> To make use of the huge pfnmap support, fault/huge_fault ops
> based mapping mechanism needs to be implemented. Currently nvgrace-gpu
> module relies on remap_pfn_range to do the mapping during VM bootup.
> Replace it to instead rely on fault and use vfio_pci_vmf_insert_pfn
> to setup the mapping.
>=20
> Moreover to enable huge pfnmap, nvgrace-gpu module is updated by
> adding huge_fault ops implementation. The implementation establishes
> mapping according to the order request. Note that if the PFN or the
> VMA address is unaligned to the order, the mapping fallbacks to
> the PTE level.
>=20
> Link: https://lore.kernel.org/all/20240826204353.2228736-1-
> peterx@redhat.com/ [1]
>=20
> Cc: Shameer Kolothum <skolothumtho@nvidia.com>
> Cc: Alex Williamson <alex@shazbot.org>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Vikram Sethi <vsethi@nvidia.com>
> Reviewed-by: Zhi Wang <zhiw@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>

Reviewed-by: Shameer Kolothum <skolothumtho@nvidia.com>

