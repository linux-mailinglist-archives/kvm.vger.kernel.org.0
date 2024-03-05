Return-Path: <kvm+bounces-11019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47BA0872482
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 17:40:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6AFAA1C25017
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 16:40:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A8EE14F62;
	Tue,  5 Mar 2024 16:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HCuBm8tM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82E7D520;
	Tue,  5 Mar 2024 16:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709656786; cv=fail; b=WvuzZkDe/cf0S8JDbzfK+I3QIyRvHCM6OWh2FCwemPjNF9Bo6XY7/3Pm74UfPqTlkQr8nl3XHT4x7tilEsbO09iqfRFHEsBO+MxBINfjT2M4MF0b+NHVl86F46khQfrrqGCVViUdHnMAdXXNlQlFuduLjAmbfXKQ7varyiZfEgs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709656786; c=relaxed/simple;
	bh=33A9ph0keNb+crMqKhKEr/ADHhGsYBkTLtDdDaGdrKI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TCfx7BXmF7tTVVtDmvBGVGFhJ+7J4u1/dlF9P5n0fUONsDIM4YCHSqJwD3S0SqBpskcudBnez3VNHhnd8GbM4iplzpdugmZ7P0hjpuWoFmhMXWwPZT3gVSCgFtcubzF08tE80lABlgxLHbphOQzt61tphtwu3GYGj0xFC6r0S6E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HCuBm8tM; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PqvfpAvSHT2jlnKu11mm5FHsJ8rLUMXbKlZ41sv/qiXiBKzmRIPzGNmZJh6Se14XIXroZfDHINQ2pUFipsBYiLCQvlG6jJzaQX58IKgL8kewuaQRKnvYUQFWc+yw0AMBA5xvMHdX68JIG6Gj3QT5/Wi8g8lokput1zBs8ueOdm7kBBBICg7BYyv3tXUCPvHkGQ091cwkpDokyltD3lDSIKDig4WpKZf2lpdTnPIE/47O3rUMw4E3ePlLbnhS9jSGjk9SSFqZitjmjaBpVuCdxbcyzU+XGD4VXvutOroLT2weG4oZAt7D8CW/pRD/KFcMfX2iWZZ7eqaLtDkY3wm/wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=33A9ph0keNb+crMqKhKEr/ADHhGsYBkTLtDdDaGdrKI=;
 b=iyXFt9D9+xN9y9croJ90QWxd8GpF7ChoO0+E9hb8XGsGhyZHkw7Y0O1wW0pQE00pcex2CboXwqlRLExsdII9IkxpXZM1fyaIQsuYlpaOvahTBsIbnAr3gf0Ab98admCMk3G/bzgwM96+uwwA/WOqdfbI5qytpk+fiqiFJHljqUT3t4XzhXE0bZpznUbVWi0wt3wURcnX1WtA1tTSlwvs+G55Fuzw4S4ZxgEIEa/vpRWuP1LJkKu6oaOIgjUgByJGYJIcKwKiIi7a1NdLpoCdgYXjnuD9g0b5OocdUN8G4CsBmeH5fAworw6Y43M6dH+0D+Nt9D66li09a4gnyywuHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=33A9ph0keNb+crMqKhKEr/ADHhGsYBkTLtDdDaGdrKI=;
 b=HCuBm8tMTjF6MuVb52pGcFFG7M3G7L82ZZxlXCWiJUN7cjKRrY9s5vUC2amQFydWUuSXcGCa1pt7DuKvkxPyl7OjiDOHO9bQabUdvbhnRH9PV2L4fUVG4oaLvpo4soqNAeOaYM5KZwiFzPDxFgSxm2GGVkRn2kMk1wHlYleJ9Wm/UEbR251wCneSvIQ4/LkYjiWZSOmo8fT0so6TgWjXzlsteUKyqUWs548GXIO/rgDeoNlOqz9fOzC+FwqBiZItulCMP5T8l2G04b7xNJqKQAeBtmxikzkWVYFg5NkOpqUD1sRJXcCWPgddbjfTrRcVME76f5f4h1ln3UrdvddqGw==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by SA3PR12MB9132.namprd12.prod.outlook.com (2603:10b6:806:394::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.39; Tue, 5 Mar
 2024 16:39:40 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::a1:5ecd:3681:16f2]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::a1:5ecd:3681:16f2%7]) with mapi id 15.20.7339.035; Tue, 5 Mar 2024
 16:39:40 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, Leon
 Romanovsky <leon@kernel.org>
CC: Christoph Hellwig <hch@lst.de>, Robin Murphy <robin.murphy@arm.com>, Marek
 Szyprowski <m.szyprowski@samsung.com>, Joerg Roedel <joro@8bytes.org>, Will
 Deacon <will@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Chaitanya Kulkarni
	<chaitanyak@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, Sagi Grimberg
	<sagi@grimberg.me>, Yishai Hadas <yishaih@nvidia.com>, Shameer Kolothum
	<shameerali.kolothum.thodi@huawei.com>, Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?utf-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Bart Van
 Assche <bvanassche@acm.org>, Damien Le Moal
	<damien.lemoal@opensource.wdc.com>, Amir Goldstein <amir73il@gmail.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, "daniel@iogearbox.net" <daniel@iogearbox.net>,
	Dan Williams <dan.j.williams@intel.com>, "jack@suse.com" <jack@suse.com>,
	Leon Romanovsky <leonro@nvidia.com>, Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: Re: [RFC RESEND 16/16] nvme-pci: use blk_rq_dma_map() for NVMe SGL
Thread-Topic: [RFC RESEND 16/16] nvme-pci: use blk_rq_dma_map() for NVMe SGL
Thread-Index: AQHabu8RTS4WklM5BkqSvNX/cXqR77EpTDsAgAAEsICAAAikAA==
Date: Tue, 5 Mar 2024 16:39:39 +0000
Message-ID: <22a03aa8-f121-486e-8471-ceecbe452b35@nvidia.com>
References: <cover.1709635535.git.leon@kernel.org>
 <016fc02cbfa9be3c156a6f74df38def1e09c08f1.1709635535.git.leon@kernel.org>
 <Zec_nAQn1Ft_ZTHH@kbusch-mbp.dhcp.thefacebook.com>
 <06787e6a-4e78-4524-960d-ec24b9f38191@kernel.dk>
In-Reply-To: <06787e6a-4e78-4524-960d-ec24b9f38191@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|SA3PR12MB9132:EE_
x-ms-office365-filtering-correlation-id: d0defe28-6bf2-41a5-1d44-08dc3d32da51
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 o2kStEWeSO8Fi3HxmCOBEOlaQ+0hBXXNpZJRduSFmPdKrtTJsqqQQwhlp9TBr3BoEMCCMPsYOvIv/yBvFMRbL6OEjCCEeoVuMJuMGtFToiBiXKboomMaeL8i4kvbcHdw8t2NXZL9HFndkSE7bSK/N8gUJfEVVHe7YXvg8rFvMiqpsW0pLaPjXqSUVX3zPH6GxRGs0/ki0ToiH2/q08dZC9IydNwcH9zDo9nn6rf3MnKoJI/qSHvOcV5L65cT/DxL/aLYfkVZ5ZXkeRRE6+iUQ8xq9pZ8YiV5MOOilKnulYw27FFUMesiTdhkV93H93bkgs42CnM+mX0BtWaXcJnBhlfbg/lh/DhIKa6m2imE7U3cNOodzrezjy8XUNdDh35/qJOzCUXP5PmNhmwuv3oH3l38xy7YwQLCfdzxSoBzT8g/xyeusVoyF1iU/1R/PG5GkzK60QZ0t/CvvDMfpzk2tPfZGgkDQu8xdCWPoxpUYmI8pj7xAA8ilI6SYZztszBKxCKyAc7557SfDMUWs1b6FL6TPDS96m1Z0JXWsvJ9Vmf8EjKviZ1/oyovP5bBcvblukMIJF0kyjPf97lJg5Emp0DLBSqqzpvdYp0uXhUbUvao761T8i4ecaoSz40TRsYno48MEAGCmBtzbwL2gd+6xJu4xbcQrcFiek+IT190F6e6wuoIyIJE3Y+pJwXcZJQfENY0Fvmg4h+yiOepxx9yYm83Acnn1TPfxzG6qFR20q8=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WWhUemwvMFBTRFhPbU1LRXBoaEhvZmFEMTFFWlNQU1I0cXBlWjVRbSt2bTZU?=
 =?utf-8?B?S2x4UU1lQnFSRTRLdmlWcWliYm01MzJCRkkvRGgydlBMcWQyRDNlSGduUGpS?=
 =?utf-8?B?cEZhcjB1clZIMXUzU0dvZUV1OEYzMVQzYThUdWw5Zkc0Nmx1eUZMTStNOGpB?=
 =?utf-8?B?RFdOM2lFZjFhNDVDRVhhSlFucmFVUnF5QTN1V1lEeEJpaE1aR2pmeFFsOU1r?=
 =?utf-8?B?TzRGN0c5WU1Idmw1OGh3SWRDWGJTVDJMN25ta3FMVjdkQzVjUnpQeUN2emdY?=
 =?utf-8?B?eFdHNVVobTY5cm13MmFIRDNuYnZKdGp0VENobVkvQUxLY1lzWVJ1ekE1aVpv?=
 =?utf-8?B?SU5Bd3BpSENNVUQxK2RYKzFGM3J3V2lYclJTeEdkTHBrdHM2REFYcWJDL0tJ?=
 =?utf-8?B?ZXdYZnJicnpJRTgzNEw1WFFMWEFUQ3ZYaW90U2JwQ0EvQ3NZS09hc1JxVXNW?=
 =?utf-8?B?Tm0vS21rVW1HSHVrb1A3ckdFTlljTnlYYUpRRUxkSWNybVkyK0svbnVoVGwv?=
 =?utf-8?B?dzd6SnMxUFJlZjM2WEJCaG1YdzEyaDNIeXJTNngyQ1BzMVNDeVRWKytibkJa?=
 =?utf-8?B?VjZKVDVZY2VTOVlQb2ZVT1JJcUxuTW1oeE5oRVFYNGozaGlMVENCNjhiUGxB?=
 =?utf-8?B?VXlzK2R4Z1VwTGw4Q3BiY0JlcUJUMVkwMlBpN1BqMGQ0N0p1T2ZaVW9DNjhr?=
 =?utf-8?B?cFVtNEE5UXVZMENVWWFGaW8xeC9udzJqdU95Y2Zuayt6bVJsWmZmU3NpTW9t?=
 =?utf-8?B?bmJEb0c2QnFIcExTbzVYSU9xdFdyeUhhWGRSMHZQM28rZzF1R1NEaVdJOGxp?=
 =?utf-8?B?KytqeEFuZ21qYVkrTDluOVZmaUVvRnZJblBsRWdtMkhQUnJYeDU2YnZpYkVq?=
 =?utf-8?B?elVRSS9GN0RNZlNkWXQ5dXZYVlhCK1oveUxWaWNNRGlSVXdIc0NHZ3JyMm1H?=
 =?utf-8?B?MDNkaUUxc0JmN1pzUVo0RkEzbXBNVjcyTVFseVVPWWZOUW50MTUwYmhtYURO?=
 =?utf-8?B?bG5FYUEvRlRVMUpxR2JDVEZlVjRmOTFnT3J0Ykh6U1dkVnlaR2NwSHpFUUhT?=
 =?utf-8?B?azg0WjN4dDRNVUt3Zms5eXNDVjBMK0FXckFGOU02REljbEVmd2t2ZlFnL3ov?=
 =?utf-8?B?RTNOekpzUHUydFdleHZiUk55UG82eW42c2RZeWNiU3JBOWxtTXMxcUdwb21I?=
 =?utf-8?B?M0dmaVE0NTJSYW9RLzlhelRQcEFNY3pMSWNRanZHcTg4VzA4L3dOWmhRdy80?=
 =?utf-8?B?MWRBR2JWL1pyS2hZYzRzSkRQK3RDSjByV1J0NjUzdmIweGFINEszdjZmT3hO?=
 =?utf-8?B?RmFNemNTTUFZSWd4VEdDVS9WOEQ4U0w3amplZ3V6UHAyZ0MyTHJIN2ordm5r?=
 =?utf-8?B?Z2pseTdEbXRYTnZRa1AvTmRCcG1HQ0xhRkpWNllOU0VMMG1QRktlc1J3QVF6?=
 =?utf-8?B?Q055ZWVWMUZ6dHFibWpjNGI0dllBUUVjR3pTQmlXd0RqalN1Wk1kTFJtdjBq?=
 =?utf-8?B?bFN0UXM5MXErZUp2ZUV6YXBJc2QyOUJYdVVaZ3hSYXJpc2xUamlzcWxVWXhj?=
 =?utf-8?B?VXI5RjJrdm5GY0hQV0d2TlB2UkRXYUlrd1JMa0U3OWNOMUQvakxxZExPQnor?=
 =?utf-8?B?TFg4ZXlxRk9ZbWlaY2JraWpvazlGRG1aTzlXcklVeThFbVpyZU5MSUNaVzJE?=
 =?utf-8?B?VStNSnZGK1l4WW91Z1gxaEZRd0J1dnVNUTVGMGcrM0xwYWdjTmtCbmcxaEhN?=
 =?utf-8?B?NHBBTUtkbUtFN3paNDQzV1JjM2pYQVltSkxxa1VqRW5lR0I4T2Y2aWx0Vmpt?=
 =?utf-8?B?SUJSUXJkZVlLSmt2czZFRVc3Q0ErL1dtSCt6SS8rMWdPT2tFTjVpeElJbElZ?=
 =?utf-8?B?MHlaUnVhMmFVc25jNzRjSVkrTjBPV3RueFZOSE82N3dVakZOY3dOazF4TGN6?=
 =?utf-8?B?dzZJdGxiRG1ndkp4WWtmSGtBMUhSSCtrY29OTUt4eHBXVkwya1dud2xsVlhs?=
 =?utf-8?B?Mis5OEVWQUQvZjZNNGo5MUtpeHFEWmZDUWVOeWJwdWNTZFZrSGtML3hJNzRp?=
 =?utf-8?B?ZFNndGN5RldDVlJIUzRqdTBsbEJneDI0NWNianliUkFGMU8ySjFsSkhIcjgr?=
 =?utf-8?B?RXk1c2tGY2x6Mkd0cENZYitTcjB2ZXRjZTBna3I3VHdnTGRoR1I5UzdleFA5?=
 =?utf-8?Q?vBv39wdpX/svdonKSdgcP9U2MUpc4ThFTzGOdr4PxTtl?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3779E6529C7642428E2D5370CDF4AD37@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9404.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0defe28-6bf2-41a5-1d44-08dc3d32da51
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2024 16:39:39.9567
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nFhdzo/3LqUTC26UCfjY9R7EzDPR2qXiK9YAXZXdBAkB+9YHKVMIsqzvGRRoAXDWlVZIbAGeW9voX6ruYtG1vA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9132

T24gMy81LzI0IDA4OjA4LCBKZW5zIEF4Ym9lIHdyb3RlOg0KPiBPbiAzLzUvMjQgODo1MSBBTSwg
S2VpdGggQnVzY2ggd3JvdGU6DQo+PiBPbiBUdWUsIE1hciAwNSwgMjAyNCBhdCAwMToxODo0N1BN
ICswMjAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6DQo+Pj4gQEAgLTIzNiw3ICsyMzYsOSBAQCBz
dHJ1Y3QgbnZtZV9pb2Qgew0KPj4+ICAgCXVuc2lnbmVkIGludCBkbWFfbGVuOwkvKiBsZW5ndGgg
b2Ygc2luZ2xlIERNQSBzZWdtZW50IG1hcHBpbmcgKi8NCj4+PiAgIAlkbWFfYWRkcl90IGZpcnN0
X2RtYTsNCj4+PiAgIAlkbWFfYWRkcl90IG1ldGFfZG1hOw0KPj4+IC0Jc3RydWN0IHNnX3RhYmxl
IHNndDsNCj4+PiArCXN0cnVjdCBkbWFfaW92YV9hdHRycyBpb3ZhOw0KPj4+ICsJZG1hX2FkZHJf
dCBkbWFfbGlua19hZGRyZXNzWzEyOF07DQo+Pj4gKwl1MTYgbnJfZG1hX2xpbmtfYWRkcmVzczsN
Cj4+PiAgIAl1bmlvbiBudm1lX2Rlc2NyaXB0b3IgbGlzdFtOVk1FX01BWF9OUl9BTExPQ0FUSU9O
U107DQo+Pj4gICB9Ow0KPj4gVGhhdCdzIHF1aXRlIGEgbG90IG9mIHNwYWNlIHRvIGFkZCB0byB0
aGUgaW9kLiBXZSBwcmVhbGxvY2F0ZSBvbmUgZm9yDQo+PiBldmVyeSByZXF1ZXN0LCBhbmQgdGhl
cmUgY291bGQgYmUgbWlsbGlvbnMgb2YgdGhlbS4NCj4gWWVhaCwgdGhhdCdzIGp1c3QgYSBjb21w
bGV0ZSBub24tc3RhcnRlci4gQXMgZmFyIGFzIEkgY2FuIHRlbGwsIHRoaXMNCj4gZW5kcyB1cCBh
ZGRpbmcgMTA1MiBieXRlcyBwZXIgcmVxdWVzdC4gRG9pbmcgdGhlIHF1aWNrIG1hdGggb24gbXkg
dGVzdA0KPiBib3ggKDI0IGRyaXZlcyksIHRoYXQncyBqdXN0IGEgc21pZGdlIG92ZXIgM0dCIG9m
IGV4dHJhIG1lbW9yeS4gVGhhdCdzDQo+IG5vdCBnb2luZyB0byB3b3JrLCBub3QgZXZlbiBjbG9z
ZS4NCj4NCg0KSSBkb24ndCBoYXZlIGFueSBpbnRlbnQgdG8gdXNlIG1vcmUgc3BhY2UgZm9yIHRo
ZSBudm1lX2lvZCB0aGFuIHdoYXQNCml0IGlzIG5vdy4gSSdsbCB0cmltIGRvd24gdGhlIGlvZCBz
dHJ1Y3R1cmUgYW5kIHNlbmQgb3V0IGEgcGF0Y2ggc29vbiB3aXRoDQp0aGlzIGZpeGVkIHRvIGNv
bnRpbnVlIHRoZSBkaXNjdXNzaW9uIGhlcmUgb24gdGhpcyB0aHJlYWQgLi4uDQoNCi1jaw0KDQoN
Cg==

