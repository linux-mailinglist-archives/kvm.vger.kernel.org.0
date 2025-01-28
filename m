Return-Path: <kvm+bounces-36767-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CE05A20BA1
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 14:56:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A9F47167981
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 13:56:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E74A91A8F95;
	Tue, 28 Jan 2025 13:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=epam.com header.i=@epam.com header.b="LlUDvMrR"
X-Original-To: kvm@vger.kernel.org
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11012062.outbound.protection.outlook.com [52.101.66.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096BA1A23B6
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 13:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738072579; cv=fail; b=nGF2W5xvZ/iXPdJA/nvSEWjWw8ku7v6sACfh7Mb9OOsxY3h1GrJhmGtNnsu1MI1lUWtAaTtcYvXoLYX+kh6Tedg+nzlXOM72Y3pyQk9VQKo7tePu/pERaWnNVZk8Woysklw1XX6K/i+gR2k7YQqoIybY2wfTsJ6yD8DowxZUbW0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738072579; c=relaxed/simple;
	bh=usTWRN2z0JpujSqsCZSfKDy3PS6I2IDzMugzKzKSyjM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MoWLY/4Qq13eh/x6x4sKOPSSdhspAmXYA207LCU66YfveC28MHbCDS9xll0JsYa0BIyZcgGYLU6nTcJHplewz9PrQLF6u7L1PEexuHt48i+ZnskZ85hJ1bFVUi7c9fMURgI/DuanrFE8GSoKzLoIVN9Fw6mNv+ZaUqHUBC0o6cI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=epam.com; spf=pass smtp.mailfrom=epam.com; dkim=pass (2048-bit key) header.d=epam.com header.i=@epam.com header.b=LlUDvMrR; arc=fail smtp.client-ip=52.101.66.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=epam.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=epam.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eu7GvWfSw/7eV3P4S9ckCmvtyPud2woGS50LZM8LPvmJJbm95ETJijNVaCq2Snlsb3DQl0WCLfw2KIG8OVkJ064dNFRkq3CeXjIoHxzpEedXxb5XV0ubI+PIC6PRLQjsA5nGejZ/9yL3Ogt4aYlJLUi9jrnYWao46/yDRy8mg4bvnrxKYyjHQI6bv07fD5VT4y1ia1O++2aZpZ6hoNFAcr6KsNdW5XxD9EbBsva5aVulnR2ADDSKpbnxJ0cfOyxqlSwpgig2CU+MGUQAPcPRHuKvZ6Ygh88jploZ1jXBZ/vBrd0muBT+6dJ8pL6h38b5P0b/iYHYooT5Iz8O8RsdRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B0pNXWwA2mqIbLXyd62EsEBdt2mktzsojj7ikNt1cwM=;
 b=Do1TWId4CO2J5h8A0IfNZpcsog/Pz01aETSdBZJCSyKN7qWI47yRwZqQ17sdkm4qCkBV5mxz9CrEXK/qz7yiM32rIq1ZgF3wy2JKC39baC0JFRovc4NLj00ESlIdT8HAP7YgO0TPCcYDiB+sJfnkVdqrT8Qafx8x6Wxoux6qoV+KV1p8Lwvexc2TZc2H7Bmp+Z+Oj/lGWqIAE07056cUG4JMb4gwzrSy7sMPXkS/5WpwKDSu6+of9+H8jdEbQAVjXxFlwCxvPA5CsDtAfPKDclVEqmw2GEbqz6j1j5zUl0niwpjBVUvFan2BZNtuyeSj/wIvDcpBh7aWFKnf5U8v3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=epam.com; dmarc=pass action=none header.from=epam.com;
 dkim=pass header.d=epam.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=epam.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B0pNXWwA2mqIbLXyd62EsEBdt2mktzsojj7ikNt1cwM=;
 b=LlUDvMrRmc1GecMEy49pH5YejizDGGFIwzMHGJNEKtkcQlDjDK6o5HbcV9rREPfDUfoYboSewicaISOzEHN3MbY0jmIM4JA1P9WeevRUbBoxvXvSJBrgzaB2Y/DHwVHtgs+pNg5KmfQnJpTKRPKP8Q650Z3baGLXq/vbwAa3oBLljLOKWafVL32OMnADlYp5ZiZQg7WGqy+ZEZbb+6iwpzj5xcK3HK9S+OtBfIT5Hy4lmaeX56Kx3PM9XJe+2H8zg3BYXCmKzYnFwVL21gBAJfVkfjRaffeu3CE0PrcCyjAHkhXUhHkMvlGkjFNrlT57qtIE3hX19Un7knS9w69u0Q==
Received: from GV1PR03MB10456.eurprd03.prod.outlook.com
 (2603:10a6:150:16a::21) by AS2PR03MB9121.eurprd03.prod.outlook.com
 (2603:10a6:20b:5f8::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.22; Tue, 28 Jan
 2025 13:56:12 +0000
Received: from GV1PR03MB10456.eurprd03.prod.outlook.com
 ([fe80::a41e:5aa8:e298:757e]) by GV1PR03MB10456.eurprd03.prod.outlook.com
 ([fe80::a41e:5aa8:e298:757e%6]) with mapi id 15.20.8377.021; Tue, 28 Jan 2025
 13:56:11 +0000
From: Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>
To: Marc Zyngier <maz@kernel.org>
CC: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
	<suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu
	<yuzenghui@huawei.com>, Bjorn Andersson <andersson@kernel.org>, Christoffer
 Dall <christoffer.dall@arm.com>, Ganapatrao Kulkarni
	<gankulkarni@os.amperecomputing.com>, Chase Conklin <chase.conklin@arm.com>,
	Eric Auger <eauger@redhat.com>, Dmytro Terletskyi
	<Dmytro_Terletskyi@epam.com>, Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
Subject: Re: [PATCH v2 02/12] KVM: arm64: nv: Sync nested timer state with
 FEAT_NV2
Thread-Topic: [PATCH v2 02/12] KVM: arm64: nv: Sync nested timer state with
 FEAT_NV2
Thread-Index: AQHbcAaOrTBbbSLpA0ukEQZvbJQCdQ==
Date: Tue, 28 Jan 2025 13:56:11 +0000
Message-ID: <874j1j11qd.fsf@epam.com>
References: <20241217142321.763801-1-maz@kernel.org>
	<20241217142321.763801-3-maz@kernel.org> <87frl51tse.fsf@epam.com>
	<86h65kuqia.wl-maz@kernel.org> <87a5bb18j7.fsf@epam.com>
	<86frl3uo8q.wl-maz@kernel.org>
In-Reply-To: <86frl3uo8q.wl-maz@kernel.org> (Marc Zyngier's message of "Tue,
	28 Jan 2025 12:17:09 +0000")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=epam.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: GV1PR03MB10456:EE_|AS2PR03MB9121:EE_
x-ms-office365-filtering-correlation-id: 5f209d0d-0dee-4dbf-937b-08dd3fa385d8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?F1ugKqObfJ4XsvX+mPPzISSTzbKHdiddBzvRpdfaVYtyy17TiwDiXFDhE7?=
 =?iso-8859-1?Q?FJSgCBNfUhirPPcDYb5Kvs1yhismN9rCpKvEcs9vFQnufVXfuT2YIlqFGe?=
 =?iso-8859-1?Q?agHjAP3iyyGOVkzYyVyYZ2ww2+OCZYK5ezITnVLXV7jfMsoqCfX+I4e/ez?=
 =?iso-8859-1?Q?Wq3pfxYLBpb9lWBWvP7MZWJ+PDQC4RLc3U8qqvh3pxPlxTxIgk3YdG3VKN?=
 =?iso-8859-1?Q?F5DY9Lc2U7BURWD3mH6anoOtVbVoPp4B0RS2DTO9I5rWyZWPn4BpIgQ9TF?=
 =?iso-8859-1?Q?Pgz/8YmfNcjonpmvmFj01jLuv1cpH/4GZh04IpjQqLKIgnAFksm6RYwRbh?=
 =?iso-8859-1?Q?R+PWyD3UmppvtQtDbersfUaDi7ELUmT6klGuO6H20RgKanC7ClhQ2SidUP?=
 =?iso-8859-1?Q?4JMJB3E+uB2Kxx9DTKt/cV11InoqUkBvmzA4ISrlq6GxGSZkt5CFYFznVo?=
 =?iso-8859-1?Q?GjPGuGzLLDOJHhqcGXVVnBA3/D9NkSPI61IL28I92xgLgSBh1UiN2P08WJ?=
 =?iso-8859-1?Q?wnfFraE6b+vWzVugUsildk8ZNQUdZooL+Z7wAzi2Bnu79cgTMleCT82Vxg?=
 =?iso-8859-1?Q?qzGQG5hKNAJZb68+e5cfTOnM/nCU5VXeSCYwb4uV/cZdN62471Mk1BE2E3?=
 =?iso-8859-1?Q?9t5La/wNTDjqb7QWoqruMjVsrXcbFOtYYvJTq13EZuvSGd0FQrx2IjOFYi?=
 =?iso-8859-1?Q?3bEUljb1N8r4BBQpKMG83SY9e3ILuQ0N2EvtI4XXX4fj0TEyV402TLDBJq?=
 =?iso-8859-1?Q?jtb46s0ctocKDIQ2Q3pCvr9kh3ByBJ5VzrMPrn5q4/PWyjmkR0ZrwfrtY2?=
 =?iso-8859-1?Q?WywjOFx+4KbJ84tMaQtmHl2WOdDAi7YBsR/9bdj7mak4Gs2pUuWkNdHMk3?=
 =?iso-8859-1?Q?z7TEN+3EQInKKqmHCBrgJwX5npnFnzkmCLMwPiUPlRtjvYpPexebnHmh1d?=
 =?iso-8859-1?Q?1MJJ9xMAME/qP245+Jn8MMJUBakcUAVIcsoYqk7PPzXNCFrVbWw2SD8cBK?=
 =?iso-8859-1?Q?xsRzcC+kO5umy2o3M37ANoXy0vol/8YcVOQ2LX2kf5Dy6W41DWdZ2+B+JI?=
 =?iso-8859-1?Q?lNQ8kj1bpDqT/M/5SoiqKD2XGK/GgXJuer/jJiTdnOy50BBrT7tKvbB8BC?=
 =?iso-8859-1?Q?Wd1fJPfblTAceDhgsqElJ0dzaTSk88Om7xmqRsmcLHa8kHL4Vh1NR4hdc1?=
 =?iso-8859-1?Q?3s0q2bW8OFPvFwOXjFom4qkK/vXyPI9mq+XFO1fY/9YTuqAxOqPTJ9Mn4Y?=
 =?iso-8859-1?Q?LV2Jrd7x9btaMldif3/eeD9ggxSZHzBLB8kRiY8WPTj8scrRqzESuzE6RR?=
 =?iso-8859-1?Q?5Sd9PcpzGrcZnbP0wDQJYoiv6zwp4k/72ts84ejvhUKZXf+3jSj+9dkec0?=
 =?iso-8859-1?Q?gq0F5KRhw60ipblv/159hY5kalPS3ZAnnVhEx+Fjs6cExvGdwk5HPqQbtL?=
 =?iso-8859-1?Q?Uhy1N7v5L3OHH4jGvjlopXvHOmejlX8jOWSIuQOHSX4nvSSejR02RpbMQ8?=
 =?iso-8859-1?Q?NEv3BKGMGW+poJcG0n48TE?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR03MB10456.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?2EhncEvorb/XJulvRHt6P+aQWzHCI66k1AsNhQG97qNH5CQXv2qqP5Cq6U?=
 =?iso-8859-1?Q?R8FdNQ4hd1DVPG8SO+Vi4OjLpKGL1uZZrBwoZNXS25oqzodey6alDgIRdh?=
 =?iso-8859-1?Q?MBeb22zOOObyLO86qYxfnNJUau0CsgGBSn3z3sVTZAy+tCyuD7iJEfn5jN?=
 =?iso-8859-1?Q?RBZ4oaBOowCPjrlhonNo9Ymv1KU/Dcx6YJS1+dWQRX88sGaiS7lagfj+ms?=
 =?iso-8859-1?Q?a2FQvw6Y7bNrdiLzH0w+1dIsEQzD6FjAxAQwDQcbZ3xMdM+zf8bvVfzl/v?=
 =?iso-8859-1?Q?M1st6WMmP82c7MhchzPUn1jphPPbAzZw1ypRxydAIZfOr/WlIbz/AsggUm?=
 =?iso-8859-1?Q?p+MhXU1eODDoeSCZdNtbkyB4weXPML+Y1ck2vfaSheJAsDKuMUtK2a+h+J?=
 =?iso-8859-1?Q?DpGy0z/PCOPeZ0wfCS5CtNOntDBAajM1uLKily5zXBD3nEvP3MinTAYlvZ?=
 =?iso-8859-1?Q?5GTPu4liLtuxxNhpHbIc/yh4+ymyp8IZQC2Ydse7axbXAHYlHD2T2+nyvT?=
 =?iso-8859-1?Q?SE5F8GG/5DVxPP5w8p2nX1tBdxoFCOJPJHW1d/MQWhBqyNMuiyQAJVrP2k?=
 =?iso-8859-1?Q?SVtqzxmVN+krouogWPhmeFeR6YOEMUIXAZ8Bldwh0DRrrXxPWI8ckjMb/w?=
 =?iso-8859-1?Q?gCFBUQWh3+rSDXI+RD/an++eYBUAPnhuxpphA24TIHeh66pmZ/RO2ClLhK?=
 =?iso-8859-1?Q?Ob+1SGv9OcBIlH8DfprEeqTlwyyKREacDP/B506phBHOAMMogZ1uVXhurZ?=
 =?iso-8859-1?Q?5RD/GxhScMt9y9C+V++Fo7GPEUASZ7XHLC7g3iYF9tx/uN4JHPVbLRKjwg?=
 =?iso-8859-1?Q?xBabQWfkSHlcMSrB4fxVS0F7DZOvPn2jV0nEoA7Suk5Y0N0hG4uMyW8o+Q?=
 =?iso-8859-1?Q?ysS2tKuO3FQkRd43mmHZSe5tYitvB4bS0X7A+w05VevBpCZYvfyb/eAfkD?=
 =?iso-8859-1?Q?fmVYe6G4SJylhGgodb4eHP1A8PVsQrQOcIVyhCIi6EVIphgitUTd+/U/BO?=
 =?iso-8859-1?Q?aCEAkND6YXGDT8TCsSVbTYNMRHsZ08+9Sx0YMChOYuX47xGW/l1G+bgM2H?=
 =?iso-8859-1?Q?trVFqipAIsMGUAaERLP2HO5Xw3goEkPrD8143ql6ohfzZzMWkXAx02Talq?=
 =?iso-8859-1?Q?Ex3DfbnJH8RMdwdsvBhzOjvig0HfBdIRNzOQ76b3ZC1jaKFl+8NAKQHcxp?=
 =?iso-8859-1?Q?PL4X+N9DZcEG5f+bdN+QyWu7Lbz3e8MBfjEr/UIn1oJ88D8AO83WlFG2Jn?=
 =?iso-8859-1?Q?CmjOeIyglgvdmM+54HMAUeVyTw/kVjrKpRvmBs2mxUh5AEerdsOP10HjCR?=
 =?iso-8859-1?Q?m1BNaxKVBY7mCYarNqJ+U+KoB/33WOpTz+NSR9QMfkXYkza9b4LRfCi1ts?=
 =?iso-8859-1?Q?g7tPC1ZTvQm3uRMn258ufQcFr68YI7pczLEh/pZHRxQ156mXAjOA1lTL09?=
 =?iso-8859-1?Q?UzG0wNh0Lg/tZC246V8KmV+1O9KwzW9mmz4HMkl1194HvJYywSx7GZdna2?=
 =?iso-8859-1?Q?o2A/VdS64rNFkIGd0FhelmL+h0o+xlLLtEKbIzZ2zvxoiZw5G81NOTB988?=
 =?iso-8859-1?Q?NkOpzUrGcntNQ69y6G2S7GwuoXIADqgNGl2pTqk4F6rGVfty2q3FExvx5H?=
 =?iso-8859-1?Q?Qn/Sp0x0iBai3fxfGDxE0Ii9q618XfV2lguRVMuSWnsaAzfL6qNg8cdQ?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: epam.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GV1PR03MB10456.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f209d0d-0dee-4dbf-937b-08dd3fa385d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2025 13:56:11.3649
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b41b72d0-4e9f-4c26-8a69-f949f367c91d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FMC7E0SqV7BZRk8ngi0UNasns+BMOv7k0BGY9UX4FqSt6jiqa+Vyxm4jGdZ2FE8gRbQRjsjyDQ5yZa6T3VeDoREPFK+osZMNGfqVbWP1rtg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR03MB9121


Marc Zyngier <maz@kernel.org> writes:

> On Tue, 28 Jan 2025 11:29:18 +0000,
> Volodymyr Babchuk <Volodymyr_Babchuk@epam.com> wrote:
>>=20
>>=20
>> Hi Marc,
>>=20
>>=20
>> Marc Zyngier <maz@kernel.org> writes:
>>=20
>> > + Wei-Lin Chang, who spotted something similar 3 weeks ago, that I
>> > didn't manage to investigate in time.
>> >
>> > On Sun, 26 Jan 2025 15:25:39 +0000,
>> > Volodymyr Babchuk <Volodymyr_Babchuk@epam.com> wrote:
>> >>=20
>> >>=20
>> >> Hi Marc,
>> >>=20
>> >> Thank you for these patches. We (myself and Dmytro Terletskyi) are
>> >> trying to use this series to launch up Xen on Amazon Graviton 4 platf=
orm.
>> >> Graviton 4 is built on Neoverse V2 cores and does **not** support
>> >> FEAT_ECV. Looks like we have found issue in this particular patch on
>> >> this particular setup.
>> >>=20
>> >> Marc Zyngier <maz@kernel.org> writes:
>> >>=20
>> >> > Emulating the timers with FEAT_NV2 is a bit odd, as the timers
>> >> > can be reconfigured behind our back without the hypervisor even
>> >> > noticing. In the VHE case, that's an actual regression in the
>> >> > architecture...
>> >> >
>> >> > Co-developed-by: Christoffer Dall <christoffer.dall@arm.com>
>> >> > Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
>> >> > Signed-off-by: Marc Zyngier <maz@kernel.org>
>> >> > ---
>> >> >  arch/arm64/kvm/arch_timer.c  | 44 ++++++++++++++++++++++++++++++++=
++++
>> >> >  arch/arm64/kvm/arm.c         |  3 +++
>> >> >  include/kvm/arm_arch_timer.h |  1 +
>> >> >  3 files changed, 48 insertions(+)
>> >> >
>> >> > diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_time=
r.c
>> >> > index 1215df5904185..ee5f732fbbece 100644
>> >> > --- a/arch/arm64/kvm/arch_timer.c
>> >> > +++ b/arch/arm64/kvm/arch_timer.c
>> >> > @@ -905,6 +905,50 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
>> >> >  		kvm_timer_blocking(vcpu);
>> >> >  }
>> >> > =20
>> >> > +void kvm_timer_sync_nested(struct kvm_vcpu *vcpu)
>> >> > +{
>> >> > +	/*
>> >> > +	 * When NV2 is on, guest hypervisors have their EL1 timer registe=
r
>> >> > +	 * accesses redirected to the VNCR page. Any guest action taken o=
n
>> >> > +	 * the timer is postponed until the next exit, leading to a very
>> >> > +	 * poor quality of emulation.
>> >> > +	 */
>> >> > +	if (!is_hyp_ctxt(vcpu))
>> >> > +		return;
>> >> > +
>> >> > +	if (!vcpu_el2_e2h_is_set(vcpu)) {
>> >> > +		/*
>> >> > +		 * A non-VHE guest hypervisor doesn't have any direct access
>> >> > +		 * to its timers: the EL2 registers trap (and the HW is
>> >> > +		 * fully emulated), while the EL0 registers access memory
>> >> > +		 * despite the access being notionally direct. Boo.
>> >> > +		 *
>> >> > +		 * We update the hardware timer registers with the
>> >> > +		 * latest value written by the guest to the VNCR page
>> >> > +		 * and let the hardware take care of the rest.
>> >> > +		 */
>> >> > +		write_sysreg_el0(__vcpu_sys_reg(vcpu, CNTV_CTL_EL0),  SYS_CNTV_C=
TL);
>> >> > +		write_sysreg_el0(__vcpu_sys_reg(vcpu, CNTV_CVAL_EL0), SYS_CNTV_C=
VAL);
>> >> > +		write_sysreg_el0(__vcpu_sys_reg(vcpu, CNTP_CTL_EL0),  SYS_CNTP_C=
TL);
>> >> > +		write_sysreg_el0(__vcpu_sys_reg(vcpu, CNTP_CVAL_EL0), SYS_CNTP_C=
VAL);
>> >>=20
>> >>=20
>> >> Here you are overwriting trapped/emulated state of  EL2 vtimer with E=
L0
>> >> vtimer, which renders all writes to EL2 timer registers useless.
>> >>=20
>> >> This is the behavior we observed:
>> >>=20
>> >>  1. Xen writes to CNTHP_CVAL_EL2, which is trapped and handled in
>> >>     kvm_arm_timer_write_sysreg().
>> >>=20
>> >>  2. timer_set_cval() updates __vcpu_sys_reg(vcpu, CNTHP_CVAL_EL2)
>> >>=20
>> >>  3. timer_restore_state() updates real CNTP_CVAL_EL0 with value from
>> >>    __vcpu_sys_reg(vcpu, CNTHP_CVAL_EL2)
>> >>=20
>> >>  (so far so good)
>> >>=20
>> >>  4. kvm_timer_sync_nested() is called and it updates real CNTP_CVAL_E=
L0
>> >>  with __vcpu_sys_reg(vcpu, CNTP_CVAL_EL0), overwriting value that we =
got
>> >>  from Xen.
>> >>=20
>> >> The same stands for other hypervisor timer registers of course.
>> >>=20
>> >> I am wondering, what is the correct fix for this issue?
>> >>=20
>> >> Also, we are observing issues with timers in Dom0, which seems relate=
d
>> >> to this, but we didn't pinpoint exact problem yet.
>> >
>> > Thanks for the great debug above, much appreciated.
>> >
>> > As Wei-Lin pointed out in their email[1], there is a copious amount of
>> > nonsense here. This is due to leftovers from the mix of NV+NV2 that
>> > KVM was initially trying to handle before switching to NV2 only.
>> >
>> > The whole VHE vs nVHE makes no sense at all, and both should have the
>> > same behaviour. The only difference is around what gets trapped, and
>> > what doesn't.
>> >
>> > Finally, this crap is masking a subtle bug in timer_emulate(), where
>> > we return too early on updating the IRQ state, hence failing to
>> > publish the interrupt state.
>> >
>> > Could you please give the hack below a go with your setup and report
>> > whether it solves this particular issue?
>>=20
>> Thanks! This is exactly what we needed. Your suggested changes fixed
>> both issues: in Xen and in Dom0.
>
> Great, thanks for letting me know.
>
> I'll shortly post the fixes on the list, and would appreciate it if
> you could reply with a Tested-by: tag.
>

Sure. I am not subscribed to the list. So could you please CC me and
Dmytro?

--=20
WBR, Volodymyr=

